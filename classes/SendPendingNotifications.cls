/**
 * @Auther : Varun Arora
 * @Date : 1/10/2017
 * @Description : This class is used to send the automatic notifications(SMS/Letter) on the business day for the 
 *                  Security Insurances against which communication has been pending due to stopping of the communicatioon
 *                  on the non business day.
 **/

Public class SendPendingNotifications implements DataBase.Batchable<sobject>,DataBase.Allowscallouts,DataBase.Stateful {
    //Variables declaration to hold various scenarios.
    Public string  notificationType;
    Public set<Id> actualDiaryNotesId;
    Public set<id> forteenDaySmsDiaryNote;
    Public set<id> oneDayPostExpiryDiaryNote;
    Public set<id> sevenDayLetterDiaryNote;
    Public Map<id,List<String>> propertyIDtoSurrogates;
    Public Boolean isHoliday = false;
    static final string status = 'Open';
    static final string sourcename = 'MORTGAGE';
    static final string originatorId = '0001635';
    //Constructor to hold the property Insurance Ids between various execute methods.
    Public  SendPendingNotifications(string notificationType1,set<id> forteenDaySmsDiaryNotes,set<id> oneDayPostExpiryDiaryNotes,set<id> sevenDayLetterDiaryNotes,set<ID> actualDiaryNotesIds) {
        
        //Code Added By sushant, to identify current day as holiday or friday
        isHoliday = isHoliday();
        
        notificationType=notificationType1;
        if(actualDiarynotesIds==null) {
            actualdiaryNotesId= new set<id>();
        }
        else {
            actualDiaryNotesId= new set<id>();
            actualDiaryNotesId.addall(actualDiaryNotesIds);
        }
        if(forteenDaySmsDiaryNotes==null) {
            forteenDaySmsDiaryNote= new set<Id>();
        }
        else {
            forteenDaySmsDiaryNote= new set<Id>();
            forteenDaySmsDiaryNote.addall(forteenDaySmsDiaryNotes);
        }
        if(oneDayPostExpiryDiaryNotes==null) {
            oneDayPostExpiryDiaryNote= new set<Id>();
        }
        else{
            oneDayPostExpiryDiaryNote= new set<Id>();
            oneDayPostExpiryDiaryNote.addall(oneDayPostExpiryDiaryNotes);
        }
        if(sevenDayLetterDiaryNotes==null) {
            sevenDayLetterDiaryNote= new set<Id>();
        }
        else {
            sevenDayLetterDiaryNote= new set<Id>();
            sevenDayLetterDiaryNote.addall(sevenDayLetterDiaryNotes);
        }
    }
    
    /**
     * Created By : Varun Arora
     * @Description : Start method to build basic query to find Insurances against  which communication needs to be sent.
     **/
    Public DataBase.querylocator start(DataBase.BatchableContext context) {
        
     
        string query;
        
        if(notificationType=='SMS') {
            
            query='Select id,Property__c,DWH_Propert_Ins_Exp_Date__c,Disable_SMS_To_Customer__c,Mobile_Phone__c,'
                + 'OriginatorID__c,Is_SMS_Send_Pending_Holiday_14_days__c,Is_SMS_Send_Pending_Holiday_1_day_exp__c,Source_Name__c,Not_Applicable_for_COC_Process__c from Property_Insurance__c '
                
                +'where (Is_SMS_Send_Pending_Holiday_14_days__c=True  OR Is_SMS_Send_Pending_Holiday_1_day_exp__c=True)'
                +' AND  Disable_SMS_To_Customer__c=False AND Mobile_Phone__c!=null AND OriginatorID__c!=:originatorId '
                +'AND Source_Name__c=:sourceName  AND Status__c=:status';
        }
        
        if(notificationType=='Letter') {
            
            set<String> bendogoStrings = new set<String>();
            bendogoStrings.addall(BendigoStrings__c.getall().keyset());
           
            query='Select id,Disable_Letter_To_Customer__c,Property__c,DWH_Propert_Ins_Exp_Date__c,'
                +'Disable_SMS_To_Customer__c, Mobile_Phone__c,Is_Letter_Send_Pending_Holiday_7_days__c,OriginatorID__c, Source_Name__c, Not_Applicable_for_COC_Process__c '
                +'from Property_Insurance__c '
                
                +'where   Is_Letter_Send_Pending_Holiday_7_days__c=True AND  Disable_Letter_To_Customer__c=False '
                +' AND Source_Name__c=:sourceName AND Status__c=:status AND MotgageFunding__c NOT IN:bendogoStrings';
        }
        
        if(notificationType == 'DiaryNote') {
            query='Select id,comment__c,Invoked_From_Batch__c,Property_Insurance__c  from Diary_Notes__c where id in:actualDiaryNotesId';
        }
        
        return DataBase.getqueryLocator(query);
    }
    
    //Batch's execute method to make Letter Invocation request or to send SMS.
    Public void execute(DataBase.Batchablecontext context,List<sobject> scope) {  
       
        propertyIdToSurrogates=new map<id,List<String>>();
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        Map<id,id> propertyInsuranceToProperty = new  Map<id,id>();
        set<id> propertyIds = new set<Id>();
        set<id> insurancePropertiesIds = new set<id>();
        set<id> currentContextDiaryNotesId = new set<id>();
        
        if(scope!=null && scope.size()>0) {
            
            if(notificationType=='SMS' || notificationType=='Letter') {
                for(sobject sobj:scope) {
                    
                    Property_Insurance__c prIns =(Property_Insurance__c)sobj;
                    insurancePropertiesIds.add(prIns.id);
                    if(prIns.Property__c != null) {
                        
                        propertyIds.add(prIns.Property__c);
                        propertyInsuranceToProperty.put(prIns.id,prIns.Property__c);
                    }
                }
            }
            if(notificationType=='DiaryNote') {
                
                for(sobject sobj:scope) {
                    
                    Diary_Notes__c diaryNote =(Diary_Notes__c)sobj;
                    insurancePropertiesIds.add(diaryNote.Property_Insurance__c);
                    currentContextDiaryNotesId.add(diaryNote.id);
                }
                List<Property_Insurance__c> propertyInsurancesForDiaryNotes=[Select id,Property__c from Property_Insurance__c where id in:insurancePropertiesIds];
                if(propertyInsurancesForDiaryNotes != null && propertyInsurancesForDiaryNotes.size()>0) {
                    
                    for(Property_Insurance__c propInsurance:propertyInsurancesForDiaryNotes) {
                        
                        if(propInsurance.Property__c != null) {
                            propertyIds.add(propInsurance.Property__c);
                            propertyInsuranceToProperty.put(propInsurance.id,propInsurance.Property__c);
                        }
                    } 
                }
            }
            
            if(propertyIds != null && propertyIds.size()>0) {
                
                List<Property_Surrogate__c> propertySurrogates = [Select id,Property__c,Property__r.Property_Unit_House_Number__c,
                Property__r.Property_Street__c,Property__r.Property_Suburb_Town__c,Property__r.Property_State__c,
                Property__r.Property_PostCode__c,Loan_Surrogate__r.collect__Account__c,
                Loan_Surrogate__r.collect__Account__r.isPersonAccount,Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone,
                Loan_Surrogate__r.collect__Contact__c,Loan_Surrogate__r.ScCollection_Lender_Record__c,
                Loan_Surrogate__r.collect__Loan_Status__c,Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c,
                Loan_Surrogate__r.collect__Contact__r.MobilePhone,Loan_Surrogate__r.collect__External_ID__c,Registration_Status__c,
                DWH_Registration_date__c 
                from Property_Surrogate__c where Property__c in:propertyIds and Registration_Status__c='R' 
                and Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c not in:StatusTOExcludeForCOC__c.getall().keyset() 
                and Loan_Surrogate__r.ScCollection_Lender_Record__c in:lenderRecordsForCOC__c.getall().keyset()  
                order BY DWH_Registration_date__c DESC];
                
                if(propertySurrogates != null && propertySurrogates.size()>0) {
                    
                    for(Property_Surrogate__c prp:propertySurrogates) {
                        
                        if(!propertyIDToSurrogates.containskey(prp.Property__c))
                            propertyIDToSurrogates.put(prp.Property__c,new List<string>());
                        if(prp.Loan_Surrogate__r.collect__External_ID__c.contains(':') && prp.Loan_Surrogate__r.collect__External_ID__c.contains('_'))
                            propertyIDToSurrogates.get(prp.Property__c).add(prp.Loan_Surrogate__r.collect__External_ID__c.substring(prp.Loan_Surrogate__r.collect__External_ID__c.indexof(':')+1,prp.Loan_Surrogate__r.collect__External_ID__c.indexof('_')));
                    }
                }
            }
            if(insurancePropertiesIds != null && insurancePropertiesIds.size()>0 && notificationType !='DiaryNote') {
                
                List<Property_Insurance__c> lstPropertyInsurances = [
                    Select id,Property__r.Property_Number__c,DWH_Propert_Ins_Exp_Date__c,Property_Insurer__r.insurer__c,
                    Property_Ins_Policy_No__c,Property_Amount_Insured__c,Property_Replace_Sq_Mtrs__c,Public_Liability_Cover__c,
                    Insurance_Premium__c,Property__r.Insurance_Type__c,Mobile_Phone__c,Is_SMS_Send_Pending_Holiday_14_days__c,
                    Is_SMS_Send_Pending_Holiday_1_day_exp__c,Is_Letter_Send_Pending_Holiday_7_days__c    
                    from Property_Insurance__c where id in:insurancePropertiesIds];
                
                for(Property_Insurance__c prp : lstPropertyInsurances) {
                    
                    if(propertyIDToSurrogates.containskey(prp.Property__c) && notificationType!='DiaryNote') {
                        
                        if(prp.Is_SMS_Send_Pending_Holiday_14_days__c==True && !isHoliday) {
                            forteenDaySmsDiaryNote.add(prp.Id);
                        }
                        if(prp.Is_SMS_Send_Pending_Holiday_1_day_exp__c==True && !isHoliday) {
                            oneDayPostExpiryDiaryNote.add(prp.Id);
                        }
                           
                        if(prp.Is_Letter_Send_Pending_Holiday_7_days__c==True && !isHoliday) {
                            sevendayLetterDiaryNote.add(prp.Id);
                        }
                        
                        if(notificationType=='SMS' && !isHoliday) {
                            
                            String senderId = Label.senderId;
                            String templateText = prp.Is_SMS_Send_Pending_Holiday_14_days__c==True?SMSText__c.getinstance('Before14Days').SMS_Text__c:SMSText__c.getinstance('After1Day').SMS_Text__c;
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
                       
                        if(notificationType=='Letter' && !isHoliday) {
                            PropertyInsuranceHandling.invokeLetterGeneration(propertyIDToSurrogates.get(prp.Property__c),prp.Property__r.Property_Number__c,string.valueof(prp.id));
                        }
                    }
                    
                }
                if(smsObjectList!=null && smsObjectList.size()>0) {
                    String response = smagicinteract.ApexAPI.pushSMSCallout(smsObjectList);
                }
            }
            if(currentContextDiaryNotesId != null && currentContextDiaryNotesId.size()>0) {
                
                List<Diary_Notes__c> lstDiaryNotes = [
                    Select id,Property_Insurance__r.Property__c,Invoked_From_Batch__c,Comment__c 
                    from Diary_Notes__c where id in:currentContextDiaryNotesId];
                
                for(Diary_Notes__c drn :lstDiaryNotes){
                    PropertyInsuranceHandling.insertDiaryNotesfromBatch(PropertyIDtosurrogates.get(drn.Property_Insurance__r.Property__c),drn.Invoked_From_Batch__c==True?Label.JacksonGenericEmail:userinfo.getuseremail(),drn.Comment__c,string.valueof(drn.id));
                }
            }
            
        }
    }
    
     //This method is called at the end of  the Batch class to do the Final updates of the Diary Notes, Property Insurances and to invoke the Batch class again for diferent notification Type.
   
    Public void finish(DataBase.Batchablecontext context) {
        //Sending Email if any failure occurs in Batch Processing.
        AsyncApexJob a = [Select Id, Status, numberOfErrors, jobItemsProcessed,
                          totalJobItems, CreatedBy.Email, extendedStatus
                          from AsyncApexJob where Id = :context.getJobId()];
        
        // Email the COC Automatic Notification failure's if any to the .
        if(a.numberOfErrors != null && a.numberOfErrors>0) {
            
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
            
            List<Property_Insurance__c> propertyInsurances14DayUpdation = new List<property_Insurance__c>();
            List<Property_Insurance__c> propertyInsurancesPost1DayUpdation = new List<property_Insurance__c>();
            if(forteenDaySmsDiaryNote != null && forteenDaySmsDiaryNote.size()>0){
                
                for(Property_Insurance__c prIns:[Select id,SMS_Before_14_Days__c,Is_SMS_Send_Pending_Holiday_14_days__c 
                                                 from Property_Insurance__c where id in:forteenDaySmsDiaryNote]) {
                    
                    prIns.SMS_Before_14_Days__c=True;
                    prIns.Is_SMS_Send_Pending_Holiday_14_days__c=False;
                    propertyInsurances14DayUpdation.add(prIns);
                }
            }
            if(oneDayPostExpiryDiaryNote !=null && oneDayPostExpiryDiaryNote.size()>0) {
                
                for(Property_Insurance__c prIns:[Select id,SMS_1_Day_Post_Expiry__c,Is_SMS_Send_Pending_Holiday_1_day_exp__c 
                                                 from Property_Insurance__c where id in:oneDayPostExpiryDiaryNote]) {
                    
                    prIns.SMS_1_Day_Post_Expiry__c=True;
                    prIns.Is_SMS_Send_Pending_Holiday_1_day_exp__c=False;
                    propertyInsurancesPost1DayUpdation.add(prIns);
                }
            }
            
            if(propertyInsurances14DayUpdation!=null && propertyInsurances14DayUpdation.size()>0)
                update propertyInsurances14DayUpdation;
            if(propertyInsurancesPost1DayUpdation!=null && propertyInsurancesPost1DayUpdation.size()>0)
                update propertyInsurancesPost1DayUpdation;
            
            SendPendingNotifications SendPendingNotifications = new SendPendingNotifications('Letter',forteenDaySmsDiaryNote!=null&&forteenDaySmsDiaryNote.size()>0?forteenDaySmsDiaryNote:null,oneDayPostExpiryDiaryNote!=null&&oneDayPostExpiryDiaryNote.size()>0?oneDayPostExpiryDiaryNote:null,sevenDayLetterDiaryNote!=null&&sevenDayLetterDiaryNote.size()>0?sevenDayLetterDiaryNote:null,null);
            if(!Test.isRunningTest())
                DataBase.executeBatch(SendPendingNotifications,1);
        }
        if(notificationType=='Letter') {
            
            List<Diary_Notes__c> diaryNotes =new List<Diary_Notes__c>();
            set<ID> diaryNoteID = new set<ID>();
            List<Property_Insurance__c> propertyInsurancesLetterUpdation = new List<property_Insurance__c>();
            if(sevenDayLetterDiaryNote!=null && sevenDayLetterDiaryNote.size() > 0) {
                
                for(Property_Insurance__c propertyIns:[Select id,Letter_Sent_To_Customer__c,Is_Letter_Send_Pending_Holiday_7_days__c 
                                                       from Property_Insurance__c where id in:sevenDayLetterDiaryNote]) {

                    propertyIns.Letter_Sent_To_Customer__c=True;
                    propertyIns.Is_Letter_Send_Pending_Holiday_7_days__c=False;
                    propertyInsurancesLetterUpdation.add(propertyIns);
                }
            }
            if(propertyInsurancesLetterUpdation!=null && propertyInsurancesLetterUpdation.size()>0)
                update propertyInsurancesLetterUpdation;
            
            List<Property_Insurance__c> propertyInsurances=[Select id,Property__c  from Property_Insurance__c where id in:forteenDaySmsDiaryNote or id in:oneDayPostExpiryDiaryNote or id in:sevenDayLetterDiaryNote];
            
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
                for(Diary_Notes__c drnote:[Select id from Diary_Notes__c where id in:diaryNotes]) {
                    diaryNoteID.add(drnote.id);
                }
            }
            
            SendPendingNotifications SendPendingNotifications = new SendPendingNotifications('DiaryNote',forteenDaySmsDiaryNote!=null&&forteenDaySmsDiaryNote.size()>0?forteenDaySmsDiaryNote:null,oneDayPostExpiryDiaryNote!=null&&oneDayPostExpiryDiaryNote.size()>0?oneDayPostExpiryDiaryNote:null,sevenDayLetterDiaryNote!=null&&sevenDayLetterDiaryNote.size()>0?sevenDayLetterDiaryNote:null,diaryNoteID);
            if(!Test.isRunningTest())
                DataBase.executeBatch(SendPendingNotifications,1);
        }
        
    }
   
    /**
     * @Created By : Sushant Kumar
     * @Description : Method to retun whether same day is public holiday or not.
     **/
    Public Boolean isHoliday() {
        
        List<Holiday> holidayList = [Select Name, ActivityDate From Holiday Where ActivityDate =:System.today()];
        return (!holidayList.isEmpty());
    }
    
}