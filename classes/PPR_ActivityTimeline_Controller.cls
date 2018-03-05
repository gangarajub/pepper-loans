/*------------------------------------------------------------
Author:        Varun Arora
Name:          PPR_ActivityTimeline_Controller 
Company:       Saasfocus
Description:   This Class is used to get all the SMS History 
               and use to send the new SMS.
History
Date    :  18/05/2017     
------------------------------------------------------------*/
public with sharing class PPR_ActivityTimeline_Controller{

    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          getDefaultContactDetails
    Company:       Saasfocus
    Description:   Fetching the record details depending upon the scenario if the custom 
                   component gets open in the record detail view.
    Inputs:        String,ID
    Returns:       ContactDetails
    -----------------------------------------------------------------------------------*/
    
    @AuraEnabled
    public static ContactDetails getDefaultContactDetails(String objectName, ID recordId)
    {

        objectName = String.isEmpty(objectName) ? '' : objectName;

        ContactDetails conDetails = new ContactDetails();

        if(objectName == 'Lead'){
            Lead thisLead = [SELECT id, name, Phone,MobilePhone, email FROM Lead WHERE id =: recordId];
            conDetails.name = thisLead.name;
            conDetails.phone = thisLead.MobilePhone;
            conDetails.email = thisLead.email;
        }
        else if(objectName == 'Contact'){
            Contact thisContact = [SELECT id, name, mobilePhone, email FROM Contact WHERE id =: recordId];
            conDetails.name = thisContact.name;
            if(thisContact.mobilePhone != null){
                if(String.valueof(thisContact.mobilePhone).substring(0,1)=='6' && String.valueof(thisContact.mobilePhone).substring(1,2)=='1'){
                    conDetails.phone='0'+String.valueof(thisContact.mobilePhone).substring(2,String.valueof(thisContact.mobilePhone).length());
                }
                else{
                    conDetails.phone = thisContact.mobilePhone;
                }
            }
            //conDetails.phone = thisContact.mobilePhone;
            conDetails.email = thisContact.email;
        }
        else if(objectName =='Party__c'){
            Party__c  thisParty = [SELECT id,CRM_Name__c,CRM_Phone__c,CRM_Email__c  FROM Party__c WHERE id =: recordId];
            conDetails.name = thisParty.CRM_Name__c;
            conDetails.phone = thisParty.CRM_Phone__c ;
            conDetails.email = thisParty.CRM_Email__c  ;
        }
        else if(objectName=='Account'){
            Account acc=[Select id,name,Personmobilephone,Personemail from Account where isPersonAccount=True and id=:recordId];
            conDetails.name = acc.name;
            conDetails.phone = acc.Personmobilephone ;
            conDetails.email = acc.Personemail;
        }
        return conDetails;

    }
    
    //Wrapper Class for Contact Details.
    public class ContactDetails{
        @AuraEnabled public String name { get;set; }
        @AuraEnabled public String phone { get;set; }
        @AuraEnabled public String email { get;set; }
        Public ContactDetails(){
        this.phone='';
        }
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          getActivityTimeline
    Company:       Saasfocus
    Description:   Fetching the ActivityTimeline for the Incoming/Outgoing SMS for record
                   detail page custom component scenario.
    Inputs:        String,ID
    Returns:       List<PPR_ActivityTimeline_Model>
    -----------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<PPR_ActivityTimeline_Model> getActivityTimeline(String objectName, ID recordId)
    {
        // Create a return List
        List<PPR_ActivityTimeline_Model> returnList = new List<PPR_ActivityTimeline_Model>();
        List<PPR_ActivityTimeline_Model> returnListwithminimumRecords = new List<PPR_ActivityTimeline_Model>();
        
        // Add Tasks Types
        //getEmails(returnList, objectName, recordId);
        getSMS(returnList, objectName, recordId);

        // Sort List
        returnList.sort();
        Integer i=0;
        if(returnList != null && returnList.size() > 0){
            for(PPR_ActivityTimeline_Model actModel:returnList){
                if(i<=199){
                    returnListwithminimumRecords.add(actModel);
                    i++;
                }
                else{
                break;
                }
            }
        }
        return returnListwithminimumRecords ;

    }
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          getActivityTimeline
    Company:       Saasfocus
    Description:   Fetching the ActivityTimeline for the Incoming/Outgoing SMS for  
                   StandAlone lightning app scenario.
    Inputs:        
    Returns:       List<PPR_ActivityTimeline_Model>
    -----------------------------------------------------------------------------------*/
    
    @AuraEnabled
    public static List<PPR_ActivityTimeline_Model> getActivityTimeline()
    {
        // Create a return List
        List<PPR_ActivityTimeline_Model> returnList = new List<PPR_ActivityTimeline_Model>();
        List<PPR_ActivityTimeline_Model> returnListwithminimumRecords = new List<PPR_ActivityTimeline_Model>();
        // Add Tasks Types
       
        getSMS(returnList, '', '');

        // Sort List
        returnList.sort();
        Integer i=0;
        if(returnList != null && returnList.size() > 0){
            for(PPR_ActivityTimeline_Model actModel:returnList){
                if(i<=199){
                    returnListwithminimumRecords.add(actModel);
                    i++;
                }
                else{
                break;
                }
            }
        }
        return returnListwithminimumRecords ;

    }

    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          getSMS
    Company:       Saasfocus
    Description:   Fetching the Incoming/Outgoing SMS against the particular record if 
                   the component gets rendered on the record's detail page.
    Inputs:        List<PPR_ActivityTimeline_Model>,String,ID
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @AuraEnabled
    public static void getSMS(List<PPR_ActivityTimeline_Model> returnList, String objectName, ID recordId)
    {

        List<smagicinteract__smsMagic__c> smsHistoryList = new List<smagicinteract__smsMagic__c>();
        List<smagicinteract__Incoming_SMS__c> incomingSMSList = new List<smagicinteract__Incoming_SMS__c>();
        objectName = String.isEmpty(objectName) ? '' : objectName;
        
        //Querying the SMS History and the Incomming Msg Object basid on the Record Id.
        if(objectName == 'Lead'){
            smsHistoryList =[Select id,smagicinteract__Account__c,smagicinteract__Account__r.name,smagicinteract__Lead__c,smagicinteract__deliveryStatus__c,smagicinteract__contact__c,smagicinteract__contact__r.name,smagicinteract__PhoneNumber__c,smagicinteract__Lead__r.name,smagicinteract__SMSText__c,smagicinteract__CreatedOn__c,Party__c,Party__r.CRM_name__c from smagicinteract__smsMagic__c where smagicinteract__Lead__c=:recordid order By CreaTedDate DESC  LIMIT 2000];

            incomingSMSList =[Select id,Account__c,Account__r.name,smagicinteract__Inbound_Number__c,smagicinteract__Lead__c,smagicinteract__contact__c,smagicinteract__contact__r.name,smagicinteract__Lead__r.name,smagicinteract__Mobile_Number__c,smagicinteract__SMS_Text__c,CreatedDate,Party__c,Party__r.CRM_name__c from smagicinteract__Incoming_SMS__c  where smagicinteract__Lead__c=:recordId order By CreaTedDate DESC  LIMIT 2000]; 
            
        }
        else if(objectName == 'Contact'){
            smsHistoryList =[Select id,smagicinteract__Account__c,smagicinteract__Account__r.name,smagicinteract__Lead__c,smagicinteract__Lead__r.name,smagicinteract__deliveryStatus__c,smagicinteract__PhoneNumber__c,smagicinteract__Contact__r.name,smagicinteract__SMSText__c,smagicinteract__CreatedOn__c,smagicinteract__Contact__c,Party__c,Party__r.CRM_name__c from smagicinteract__smsMagic__c where smagicinteract__Contact__c=:recordid order By CreaTedDate DESC  LIMIT 2000];
            
            incomingSMSList =[Select id,Account__c,Account__r.name,smagicinteract__Inbound_Number__c,smagicinteract__Lead__c,smagicinteract__Contact__c,smagicinteract__Contact__r.name,smagicinteract__Mobile_Number__c,smagicinteract__SMS_Text__c,createdDate,Party__c,Party__r.CRM_name__c,smagicinteract__Lead__r.name  from smagicinteract__Incoming_SMS__c where smagicinteract__Contact__c=:recordId order By CreaTedDate DESC  LIMIT 2000]; 
                
        }
        else if(objectName=='Party__c'){
            smsHistoryList =[Select id,smagicinteract__Account__c,smagicinteract__Account__r.name,smagicinteract__Contact__c,smagicinteract__deliveryStatus__c,smagicinteract__Contact__r.name,smagicinteract__Lead__c,smagicinteract__Lead__r.name,smagicinteract__PhoneNumber__c,smagicinteract__SMSText__c,smagicinteract__CreatedOn__c,Party__c,Party__r.CRM_name__c from smagicinteract__smsMagic__c where Party__c=:recordid order By CreaTedDate DESC  LIMIT 2000];
            
            incomingSMSList =[Select id,Account__c,Account__r.name,smagicinteract__Inbound_Number__c,smagicinteract__Lead__c,smagicinteract__Lead__r.name,smagicinteract__Contact__c,smagicinteract__Contact__r.name,smagicinteract__Mobile_Number__c,smagicinteract__SMS_Text__c,CreatedDate,Party__c,Party__r.CRM_name__c from smagicinteract__Incoming_SMS__c where Party__c=:recordid order By CreaTedDate DESC  LIMIT 2000]; 
            
        }
        else if(objectname=='Account'){
            smsHistoryList =[Select id,smagicinteract__Account__c,smagicinteract__Account__r.name,smagicinteract__Contact__c,smagicinteract__deliveryStatus__c,smagicinteract__Contact__r.name,smagicinteract__Lead__c,smagicinteract__Lead__r.name,smagicinteract__PhoneNumber__c,smagicinteract__SMSText__c,smagicinteract__CreatedOn__c,Party__c,Party__r.CRM_name__c from smagicinteract__smsMagic__c where smagicinteract__Account__c=:recordId order By CreaTedDate DESC  LIMIT 2000];
            
            incomingSMSList =[Select id,Account__c,Account__r.name,smagicinteract__Inbound_Number__c,smagicinteract__Lead__c,smagicinteract__Lead__r.name,smagicinteract__Contact__c,smagicinteract__Contact__r.name,smagicinteract__Mobile_Number__c,smagicinteract__SMS_Text__c,CreatedDate,Party__c,Party__r.CRM_name__c from smagicinteract__Incoming_SMS__c where Account__c=:recordId order By CreaTedDate DESC  LIMIT 2000]; 
            
        }
        else{
            smsHistoryList =[Select id,smagicinteract__Account__c,smagicinteract__Account__r.name,smagicinteract__Contact__c,smagicinteract__deliveryStatus__c,smagicinteract__Contact__r.name,smagicinteract__Lead__c,smagicinteract__Lead__r.name,smagicinteract__PhoneNumber__c,smagicinteract__SMSText__c,smagicinteract__CreatedOn__c,Party__c,Party__r.CRM_name__c from smagicinteract__smsMagic__c order By CreaTedDate DESC  LIMIT 2000];
            
            incomingSMSList =[Select id,Account__c,Account__r.name,smagicinteract__Inbound_Number__c,smagicinteract__Lead__c,smagicinteract__Lead__r.name,smagicinteract__Contact__c,smagicinteract__Contact__r.name,smagicinteract__Mobile_Number__c,smagicinteract__SMS_Text__c,CreatedDate,Party__c,Party__r.CRM_name__c from smagicinteract__Incoming_SMS__c order By CreaTedDate DESC  LIMIT 2000]; 
                
        }
        
        //Preparing the Wrapper Data for the SMS object.
        if(smsHistoryList.size() > 0)
        {
            PPR_ActivityTimeline_Model activityItem;
            for(smagicinteract__smsMagic__c cl: smsHistoryList)
            {
                activityItem = new PPR_ActivityTimeline_Model();
                activityItem.RecordId = cl.Id;
                activityItem.ActivityTimelineType = 'SMS';
                activityItem.Subject = cl.smagicinteract__PhoneNumber__c;
                activityItem.Detail = cl.smagicinteract__SMSText__c;
                activityItem.ActualDate = cl.smagicinteract__CreatedOn__c;
                activityItem.formatteddate=activityItem.ActualDate.format();
                activityItem.ShortDate = cl.smagicinteract__CreatedOn__c.format('dd MMMM');
                activityItem.delieveryStatus=cl.smagicinteract__deliveryStatus__c;
                if(cl.smagicinteract__Lead__c !=null){
                    activityItem.Recipients = cl.smagicinteract__Lead__r.name;
                    activityItem.parentRecordId=cl.smagicinteract__Lead__c;
                }
                if(cl.smagicinteract__Account__c!= null && activityItem.Recipients==null && objectName!='Party__c'){
                    activityItem.Recipients=cl.smagicinteract__Account__r.name;
                    activityItem.parentRecordId=cl.smagicinteract__Account__c;
                }
                if(cl.smagicinteract__contact__c != null  && activityItem.Recipients==null && objectName!='Party__c'){
                    activityItem.Recipients=cl.smagicinteract__contact__r.name;
                    activityItem.parentRecordId=cl.smagicinteract__contact__c;
                }
               
                if(cl.Party__c != null && activityItem.Recipients==null ){
                    activityItem.Recipients=cl.Party__r.CRM_name__c;
                    activityItem.parentRecordId=cl.Party__c;
                }
                activityItem.messagetype='Out-Bound';
                returnList.add(activityItem);
            }
        }
        //Wrapper data for the incomming object.
        if(incomingSMSList.size() > 0)
        {
            PPR_ActivityTimeline_Model activityItem;
            for(smagicinteract__Incoming_SMS__c cl: incomingSMSList)
            {
                activityItem = new PPR_ActivityTimeline_Model();
                activityItem.RecordId = cl.Id;
                activityItem.ActivityTimelineType = 'SMS';
                activityItem.Subject = cl.smagicinteract__Mobile_Number__c;
                activityItem.Detail = cl.smagicinteract__SMS_Text__c;
                activityItem.ActualDate = cl.createdDate;
                activityItem.formatteddate=activityItem.ActualDate.format();
                activityItem.ShortDate = cl.createdDate.format('dd MMMM');
                if(cl.smagicinteract__Lead__c !=null ){
                    activityItem.Recipients = cl.smagicinteract__Lead__r.name;
                    activityItem.parentRecordId=cl.smagicinteract__Lead__c;  
                }
                if(cl.Account__c!= null &&  activityItem.Recipients==null && objectname!='Party__c'){
                    activityItem.Recipients=cl.Account__r.name;
                    activityItem.parentRecordId=cl.Account__c; 
                }
                if(cl.smagicinteract__contact__c != null &&  activityItem.Recipients==null && objectname!='Party__c'){
                    activityItem.Recipients=cl.smagicinteract__contact__r.name;
                    activityItem.parentRecordId=cl.smagicinteract__contact__c; 
                }
               
                if(cl.Party__c != null && activityItem.Recipients==null && objectname=='Party__c'){
                    activityItem.Recipients=cl.Party__r.CRM_name__c;
                    activityItem.parentRecordId=cl.Party__c;  
                }
                activityItem.messagetype='In-Bound';
                returnList.add(activityItem);
            }
                
        }
    }
    

   
   /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          addSMS
    Company:       Saasfocus
    Description:   Sending SMS once the person clicks on Send button on the Lightning 
                   component(CommunicationPublisher_SMS) component.
    Inputs:        ID,String,String,String,String
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @AuraEnabled
    public static void addSMS(ID recordId, String objectName, String contactName, String mobileNumber, String SMSText)
    {

        String senderId = Label.InboundSenderId;
        String templateText=SMSText;
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        if(objectName=='Contact')
            smsObject.smagicinteract__Contact__c = recordId;
      
        if(objectname=='Lead')
            smsObject.smagicinteract__Lead__c = recordId;
      
        if(objectName=='Party__c')
            smsObject.Party__c = recordId;
      
        if(objectName=='Account')
            smsObject.smagicinteract__Account__c=recordid;
      
        smsObject.smagicinteract__SenderId__c = senderId;
        smsObject.smagicinteract__PhoneNumber__c =mobileNumber;
        smsObject.smagicinteract__Name__c ='Pepper'; // records name
        smsObject.smagicinteract__ObjectType__c ='Contact'; // record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; 
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        smsObject.smagicinteract__SMSText__c = templateText;
        insert smsObject;
    }
}