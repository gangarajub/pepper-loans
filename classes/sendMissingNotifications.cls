/**
 * @Created By : Varun Arora
 * @Date : 17/01/2018
 * @Description : This class send automatic notifications for property insurances that are about to expire.
 **/
//Rename this class to sendMissingNotifications after cloning the same.
Public class sendMissingNotifications implements DataBase.Batchable<sobject>,DataBase.Allowscallouts,DataBase.Stateful{
    
    Public string notificationType;
    Public set<Id> actualDiaryNotesId;
    Public set<id> forteenDaySmsDiaryNote;
    Public set<id> oneDayPostExpiryDiaryNote;
    Public set<id> sevenDayLetterDiaryNote;
    Public Map<id,List<String>> propertyIDtoSurrogates;
    Public Boolean isFriday = false;
    Public Boolean isHoliday = false;
    static final string status = 'Open';
    static final string sourcename = 'MORTGAGE';
    static final string originatorId = '0001635';
    public Id sydneyQueueId;
    public Boolean ifPostExpireSMS = false;
    //Contructor to initialise the sets to hold the ids of the Property Insurances and diary notes form the previous Batch class as this Batch class is self calling.
    Public sendMissingNotifications(string notificationType1,set<id> forteenDaySmsDiaryNotes,set<id> oneDayPostExpiryDiaryNotes,set<id> sevenDayLetterDiaryNotes,set<ID> actualDiaryNotesIds) {
       
        sydneyQueueId = [select Id,name from Group where Type = 'Queue' and name='Sydney Queue' Limit 1].Id;
        notificationType=notificationType1;
        if(actualDiaryNotesIds==null){
            actualDiaryNotesId= new set<id>();
        }
        else{
            actualDiaryNotesId= new set<id>();
            actualDiaryNotesId.addall(actualDiaryNotesIds);
        }
        if(forteenDaySmsDiaryNotes==null){
            forteenDaySmsDiaryNote= new set<Id>();
        }
        else{
            forteenDaySmsDiaryNote= new set<Id>();
            forteenDaySmsDiaryNote.addall(forteenDaySmsDiaryNotes);
        }
        if(oneDayPostExpiryDiaryNotes==null){
            oneDayPostExpiryDiaryNote= new set<Id>();
        }
        else{
            oneDayPostExpiryDiaryNote= new set<Id>();
            oneDayPostExpiryDiaryNote.addall(oneDayPostExpiryDiaryNotes);
        }
        if(sevenDayLetterDiaryNotes==null){
            sevenDayLetterDiaryNote= new set<Id>();
        }
        else{
            sevenDayLetterDiaryNote= new set<Id>();
            sevenDayLetterDiaryNote.addall(sevenDayLetterDiaryNotes);
        }
    }
    //This method is called one time during the batch class to query the Property Insurances corresponding to the notification Type i.e 14 Day Expiry or 1 Day Post Expiry or Pre Expiry 7 day Letter.
    Public DataBase.querylocator start(DataBase.BatchableContext context){
        
        string query;
        if(notificationType=='SMS'){
            
            if(!ifPostExpireSMS){
                //add ownerId=Sydeny Queue in and condition as well as apply Limit 50
                query='Select id,Property__c,DWH_Propert_Ins_Exp_Date__c,Disable_SMS_To_Customer__c,Mobile_Phone__c,'
                    + 'OriginatorID__c,Source_Name__c,Not_Applicable_for_COC_Process__c from Property_Insurance__c '
                    
                    +'where (SMS_Before_14_Days__c=False OR SMS_1_Day_Post_Expiry__c=False)'
                    +' AND  Disable_SMS_To_Customer__c=False AND Mobile_Phone__c!=null AND OriginatorID__c!=:originatorId '
                    +'AND Source_Name__c=:sourcename  AND Status__c=:status And OwnerId =:sydneyQueueId Limit 50';
            }
            else{
                query='Select id,Property__c,DWH_Propert_Ins_Exp_Date__c,Disable_SMS_To_Customer__c,Mobile_Phone__c,'
                    + 'OriginatorID__c,Source_Name__c,Not_Applicable_for_COC_Process__c from Property_Insurance__c '
                    
                    +'where (SMS_Before_14_Days__c=True And SMS_1_Day_Post_Expiry__c=False)'
                    +' AND  Disable_SMS_To_Customer__c=False AND Mobile_Phone__c!=null AND OriginatorID__c!=:originatorId '
                    +'AND Source_Name__c=:sourcename  AND Status__c=:status And OwnerId =:sydneyQueueId Limit 50';
            }
                
        }
        if(notificationType=='Letter'){
             //add ownerId=Sydeny Queue in and condition as well as apply Limit 50 and Id IN:forteenDaySmsDiaryNote
            set<String> bendogostrings = new set<String>();
            bendogostrings.addall(BendigoStrings__c.getall().keyset());
           
            query='Select id,Disable_Letter_To_Customer__c,Property__c,DWH_Propert_Ins_Exp_Date__c,'
                +'Disable_SMS_To_Customer__c, Mobile_Phone__c,OriginatorID__c, Source_Name__c, Not_Applicable_for_COC_Process__c '
                +'from Property_Insurance__c '
                
                +'where (Letter_Generation_Submitted__c =False) AND  Disable_Letter_To_Customer__c=False '
                +' AND Source_Name__c=:sourcename AND Status__c=:status AND MotgageFunding__c NOT IN:bendogostrings';
        }
        if(notificationType == 'DiaryNote') {
            query='Select id,comment__c,Invoked_From_Batch__c,Property_Insurance__c  from Diary_Notes__c where id in :actualDiaryNotesId';
        }

        return DataBase.getqueryLocator(query);
    }
    
    //This method is called multiple times depending upon the Batch size passed to send the SMS/Letter(i.e invoking Apis of ESB to send Letter as well as invoking SMS Magic's api to send the sms.)
    Public void execute(DataBase.Batchablecontext context,List<sobject> scope){

         
        propertyIDtoSurrogates =new map<id,List<String>>();
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        Map<id,id> propertyinsuranceToProperty = new  Map<id,id>();
        set<id> propertyIds = new set<Id>();
        set<id> insurancepropertiesids = new set<id>();
        set<id> currentcontextdiaryNotesId = new set<id>();
        
        if(scope!=null && scope.size()>0) {
            
            if(notificationType=='SMS' || notificationType=='Letter') {
                
                for(sobject sobj:scope) {
                    
                    Property_Insurance__c prIns =(Property_Insurance__c)sobj;
                    insurancepropertiesids.add(prIns.id);
                    
                    if(prIns.Property__c != null) {
                        
                        propertyIds.add(prIns.Property__c);
                        propertyinsuranceToProperty.put(prIns.id,prIns.Property__c);
                    }
                }
            }
            if(notificationType=='DiaryNote') {
                
                for(sobject sobj:scope) {
                    
                    Diary_Notes__c diaryNote =(Diary_Notes__c)sobj;
                    insurancepropertiesids.add(diaryNote.Property_Insurance__c);
                    currentcontextdiaryNotesId.add(diaryNote.id);
                }
                List<Property_Insurance__c> propertyInsurancesforDiaryNotes=[Select id,Property__c from Property_Insurance__c where id in:insurancepropertiesids];
                
                if(propertyInsurancesforDiaryNotes != null && propertyInsurancesforDiaryNotes.size()>0) {
                    
                    for(Property_Insurance__c propInsurance:propertyInsurancesforDiaryNotes) {
                        if(propInsurance.Property__c != null){
                            propertyIds.add(propInsurance.Property__c);
                            propertyinsuranceToProperty.put(propInsurance.id,propInsurance.Property__c);
                        }
                    } 
                }
            }
            if(propertyIds != null && propertyIds.size()>0) {
                
                List<Property_Surrogate__c> propertySurrogates =[Select id,Property__c,Property__r.Property_Unit_House_Number__c,Property__r.Property_Street__c,Property__r.Property_Suburb_Town__c,Property__r.Property_State__c,Property__r.Property_PostCode__c,Loan_Surrogate__r.collect__Account__c,Loan_Surrogate__r.collect__Account__r.isPersonAccount,Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone,Loan_Surrogate__r.collect__Contact__c,Loan_Surrogate__r.ScCollection_Lender_Record__c,Loan_Surrogate__r.collect__Loan_Status__c,Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c,Loan_Surrogate__r.collect__Contact__r.MobilePhone,Loan_Surrogate__r.collect__External_ID__c,Registration_Status__c,DWH_Registration_date__c from Property_Surrogate__c where Property__c in:propertyIds and Registration_Status__c='R' and Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c not in:StatusTOExcludeForCOC__c.getall().keyset() and Loan_Surrogate__r.ScCollection_Lender_Record__c in:LenderRecordsForCOC__c.getall().keyset()  order BY DWH_Registration_date__c DESC];
                
                if(propertySurrogates != null && propertySurrogates.size()>0) {
                    
                    for(Property_Surrogate__c prp:propertySurrogates){
                        
                        if(!propertyIDtoSurrogates.containskey(prp.Property__c))
                            propertyIDtoSurrogates.put(prp.Property__c,new List<string>());
                        if(prp.Loan_Surrogate__r.collect__External_ID__c.contains(':') && prp.Loan_Surrogate__r.collect__External_ID__c.contains('_'))
                            propertyIDtoSurrogates.get(prp.Property__c).add(prp.Loan_Surrogate__r.collect__External_ID__c.substring(prp.Loan_Surrogate__r.collect__External_ID__c.indexof(':')+1,prp.Loan_Surrogate__r.collect__External_ID__c.indexof('_')));
                    }
                }
            }
            if(insurancepropertiesids != null && insurancepropertiesids.size()>0 && notificationtype !='DiaryNote') {
                
                for(Property_Insurance__c prp : [Select id,Property__r.Property_Number__c,DWH_Propert_Ins_Exp_Date__c,Property_Insurer__r.insurer__c,Property_Ins_Policy_No__c,Property_Amount_Insured__c,Property_Replace_Sq_Mtrs__c,Public_Liability_Cover__c,Insurance_Premium__c,Property__r.Insurance_Type__c,Mobile_Phone__c,Is_SMS_Send_Pending_Holiday_14_days__c,Is_SMS_Send_Pending_Holiday_1_day_exp__c,Is_Letter_Send_Pending_Holiday_7_days__c    from Property_Insurance__c where id in:insurancepropertiesids]){
                    
                    if(propertyIDtoSurrogates.containskey(prp.Property__c) && notificationtype!='DiaryNote') {
                        
                                if(notificationType=='SMS' && ifPostExpireSMS==False)
                                    forteenDaySmsDiaryNote.add(prp.Id);
                                if(notificationType=='SMS' && ifPostExpireSMS==True)
                                    oneDayPostExpiryDiaryNote.add(prp.Id);
                                if(notificationType=='Letter')
                                    sevenDayLetterDiaryNote.add(prp.Id);
                            
                            }
                           
                            
                        
                        /* comment the same while invoking clas for 14 day Post expiry...
                        if(postExpiryDateSet.contains(prp.DWH_Propert_Ins_Exp_Date__c)) {

                           
                                oneDayPostExpiryDiaryNote.add(prp.Id);
                      
                            }
                        
                       if(letterInvocationDateSet.contains(prp.DWH_Propert_Ins_Exp_Date__c)) {
                           
                            if(!isHoliday) {
                                sevenDayLetterDiaryNote.add(prp.Id);
                            }
                            else {
                                prp.Is_Letter_Send_Pending_Holiday_7_days__c = true;
                                sevenDayPreExpiryLetterPending.add(prp);
                            }
                        }
                        */
                        /*
                        What to Do(Sushant)///////
                        1.Add the condition with this notification Type == 'SMS' in AND mode.The condition should be that !HolidaySet.contains(Date.today())
                        2.To retreive the Template Text we have to apply the condition for the Dates like (For 15 and 16 day scenario also smstext of Before14Days custom setting instance must go,For same day  and Date.Today().adddays(1) day scenario also smstext of After1Day custom setting instance must go )                        
                        */
                        if(notificationType=='SMS') {
                            
                            String senderId = Label.senderId;
                            String templateText = ifPostExpireSMS==False?SMSText__c.getinstance('Before14Days').SMS_Text__c:SMSText__c.getinstance('After1Day').SMS_Text__c;
                            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                            smsObject.smagicinteract__SenderId__c = senderId;
                            smsObject.smagicinteract__PhoneNumber__c =prp.Mobile_Phone__c;
                            smsObject.smagicinteract__Name__c ='Pepper'; // records name
                            smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
                            smsObject.smagicinteract__disableSMSOnTrigger__c = 1; 
                            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                            smsObject.smagicinteract__SMSText__c = templateText;
                            smsObjectList.add(smsObject);
                        }
                        
                        if(notificationType=='Letter') {
                            PropertyInsuranceHandling.invokeLetterGeneration(propertyIDtoSurrogates.get(prp.Property__c),prp.Property__r.Property_Number__c,string.valueof(prp.id));
                        }
                    }
                    
                }
                if(smsObjectList!=null && smsObjectList.size()>0) {
                    String response = smagicinteract.ApexAPI.pushSMSCallout(smsObjectList);
                    Database.insert(smsObjectList,false);
                }
            }
            if(currentcontextdiaryNotesId != null && currentcontextdiaryNotesId.size()>0){
                for(Diary_Notes__c drn:[Select id,Property_Insurance__r.Property__c,Invoked_From_Batch__c,Comment__c from Diary_Notes__c where id in:currentcontextdiaryNotesId]){
                    PropertyInsuranceHandling.insertDiaryNotesfromBatch(propertyIDtoSurrogates.get(drn.Property_Insurance__r.Property__c),drn.Invoked_From_Batch__c==True?Label.JacksonGenericEmail:userinfo.getuseremail(),drn.Comment__c,string.valueof(drn.id));
                }
            }
            
            
        }
    
    
    //This method is called at the end of  the Batch class to do the Final updates of the Diary Notes, Property Insurances and to invoke the Batch class again for diferent notification Type.
    Public void finish(DataBase.Batchablecontext context) {
        //Sending Email if any failure occurs in Batch Processing.
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email, ExtendedStatus
                          from AsyncApexJob where Id = :context.getJobId()];
        
        // Email the COC Automatic Notification failure's if any to the .
        if(a.NumberOfErrors!= null && a.NumberOfErrors>0) {
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>();
            for(String str:Label.AutomaticNotificationFailureEmails.split(',')) {
                toAddresses.add(str);
            }
            mail.setToAddresses(toAddresses);
            mail.setSubject('sendAutomaticNotifications batch Status: ' + a.Status);
            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                                  ' batches with '+ a.NumberOfErrors + ' failures.' + 'for'+' ' +notificationType+' '+'Automation');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }          
        if(notificationType=='SMS') {
            
            List<Property_Insurance__c> propertyInsurances14dayUpdation = new List<property_Insurance__c>();
            List<Property_Insurance__c> propertyInsurancesPost1DayUpdation = new List<property_Insurance__c>();
            if(forteenDaySmsDiaryNote != null && forteenDaySmsDiaryNote.size()>0) {
                
                for(Property_Insurance__c prIns:[Select id,SMS_Before_14_Days__c from Property_Insurance__c where id in :forteenDaySmsDiaryNote]){
                    prIns.SMS_Before_14_Days__c=True;
                    propertyInsurances14dayUpdation.add(prIns);
                }
            }
            if(oneDayPostExpiryDiaryNote !=null && oneDayPostExpiryDiaryNote.size()>0) {
                
                for(Property_Insurance__c prIns:[Select id,SMS_1_Day_Post_Expiry__c from Property_Insurance__c where id in:oneDayPostExpiryDiaryNote]){
                    prIns.SMS_1_Day_Post_Expiry__c=True;
                    propertyInsurancesPost1DayUpdation.add(prIns);
                }
            }
            if(propertyInsurances14dayUpdation!=null && propertyInsurances14dayUpdation.size()>0)
                update propertyInsurances14dayUpdation;
            if(propertyInsurancesPost1DayUpdation!=null && propertyInsurancesPost1DayUpdation.size()>0)
                update propertyInsurancesPost1DayUpdation;
            sendAutomaticNotifications sendAutomaticNotifications = new sendAutomaticNotifications('Letter',forteenDaySmsDiaryNote !=null && forteenDaySmsDiaryNote.size()>0?forteenDaySmsDiaryNote:null,oneDayPostExpiryDiaryNote!=null&&OneDayPostexpiryDiaryNote.size()>0?OneDayPostexpiryDiaryNote:null,sevenDayLetterDiaryNote!=null && sevenDayLetterDiaryNote.size() >0? sevenDayLetterDiaryNote:null,null);
            if(!Test.isRunningTest())
                DataBase.executeBatch(sendAutomaticNotifications,1);
        }
        if(notificationType=='Letter') {
            
            List<Diary_Notes__c> diaryNotes =new List<Diary_Notes__c>();
            set<ID> diarynoteID = new set<ID>();
            List<Property_Insurance__c> propertyInsurancesLetterUpdation = new List<property_Insurance__c>();
            
            if(sevenDayLetterDiaryNote!=null && sevenDayLetterDiaryNote.size()>0) {
                
                for(Property_Insurance__c propertyIns:[Select id,Letter_Sent_To_Customer__c from Property_Insurance__c where id in:sevenDayLetterDiaryNote]) {
                    propertyIns.Letter_Sent_To_Customer__c=True;
                    propertyInsurancesLetterUpdation.add(propertyIns);
                }
            }
            
            if(propertyInsurancesLetterUpdation!=null && propertyInsurancesLetterUpdation.size()>0)
                update propertyInsurancesLetterUpdation;
            List<Property_Insurance__c> propertyInsurances=[Select id,Property__c  from Property_Insurance__c where id in :forteenDaySmsDiaryNote or id in:OneDayPostexpiryDiaryNote or id in:sevenDayLetterDiaryNote];
            
            if(propertyInsurances != null && propertyInsurances.size()>0) {
                
                for(Property_Insurance__c propInsurance: propertyInsurances) {
                    
                    if(forteenDaySmsDiaryNote.contains(propInsurance.Id)) {
                        Diary_Notes__c drn = new Diary_Notes__c(Invoked_From_Batch__c=True,Comment__c=Label.ExpirySMSNote,Property_Insurance__c=propInsurance.id);
                        diaryNotes.add(drn);
                    }
                    if(oneDayPostExpiryDiaryNote.contains(propInsurance.Id)) {
                        Diary_Notes__c drn = new Diary_Notes__c(Invoked_From_Batch__c=True,Comment__c=Label.OneDaySMSnote,Property_Insurance__c=propInsurance.id);
                        diaryNotes.add(drn);
                    }
                    if(sevenDayLetterDiaryNote.contains(propInsurance.Id)) {
                        Diary_Notes__c drn = new Diary_Notes__c(Invoked_From_Batch__c=True,Comment__c=Label.LettertoJackson,Property_Insurance__c=propInsurance.id);
                        diaryNotes.add(drn);
                    }
                }
            }
            if(diaryNotes!=null && diaryNotes.size()>0) {
                insert diaryNotes;
                for(Diary_Notes__c drnote:[Select id from Diary_Notes__c where id in:diaryNotes]){
                    diarynoteID.add(drnote.id);
                }
            }
            
            sendAutomaticNotifications sendAutomaticNotifications = new sendAutomaticNotifications('DiaryNote',forteenDaySmsDiaryNote !=null && forteenDaySmsDiaryNote.size() >0? forteenDaySmsDiaryNote:null,oneDayPostExpiryDiaryNote !=null && oneDayPostExpiryDiaryNote.size() > 0? oneDayPostExpiryDiaryNote:null,sevenDayLetterDiaryNote !=null && sevenDayLetterDiaryNote.size()>0?sevenDayLetterDiaryNote:null,diarynoteID);
            if(!Test.isRunningTest())
                DataBase.executeBatch(sendAutomaticNotifications,1);
        }
        
        
    }
    
   
}