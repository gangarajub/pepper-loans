/*------------------------------------------------------------
Author:        Varun Arora
Name:          AssociateSMS 
Company:       Saasfocus
Description:   This is used to update the SMS History Records 
               and the Incomming Records to the newly converted 
               Account or Contact.
History
Date    :  18/05/2017     
------------------------------------------------------------*/
Public class AssociateSMS{
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          relatesms
    Company:       Saasfocus
    Description:   This is used to update the SMS History Records 
                   and the Incomming Records to the newly converted 
                   Account or Contact.
    Inputs:        List<Id>
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @Invocablemethod
    Public static void relatesms(List<Id> LeadIds){
        
        Map<id,id> leadToConvertedContact = new Map<Id,Id>();
        Map<id,id> leadToConvertedAccount = new Map<Id,Id>();
        List<smagicinteract__smsMagic__c> smsHistoryListtoUpdate = new List<smagicinteract__smsMagic__c>();
        List<smagicinteract__Incoming_SMS__c> incomingSMSListtoUpdate = new List<smagicinteract__Incoming_SMS__c>();
        
        List<Lead> convertedLeadLists =[Select id,convertedAccountid,convertedcontactid from Lead where id in:LeadIds];
        
        if(convertedLeadLists != null && convertedLeadLists.size()>0){
            for(Lead ld:convertedLeadLists){
                if(ld.convertedAccountid != null)
                    leadToConvertedAccount.put(ld.id,ld.convertedAccountId);
            
                if(ld.convertedcontactid != null)
                    leadToConvertedContact.put(ld.id,ld.convertedcontactid);
            }
                
            List<smagicinteract__smsMagic__c> smsHistoryList=[Select id,Account__c,smagicinteract__Account__c,smagicinteract__Lead__c,smagicinteract__deliveryStatus__c,smagicinteract__contact__c,smagicinteract__contact__r.name,smagicinteract__PhoneNumber__c,smagicinteract__Lead__r.name,smagicinteract__SMSText__c,smagicinteract__CreatedOn__c,Party__c,Party__r.CRM_name__c from smagicinteract__smsMagic__c where smagicinteract__Lead__c in:leadToConvertedContact.keyset()];
            
            List<smagicinteract__Incoming_SMS__c> incomingSMSList=[Select id,Account__c,smagicinteract__Inbound_Number__c,smagicinteract__Lead__c,smagicinteract__contact__c,smagicinteract__contact__r.name,smagicinteract__Lead__r.name,smagicinteract__Mobile_Number__c,smagicinteract__SMS_Text__c,CreatedDate,Party__c,Party__r.CRM_name__c from smagicinteract__Incoming_SMS__c  where smagicinteract__Lead__c in:leadToConvertedContact.keyset()];
            
            if(smsHistoryList!=null && smsHistoryList.size()>0){
                for(smagicinteract__smsMagic__c sms:smsHistoryList){
                    
                    if(leadToConvertedContact.get(sms.smagicinteract__Lead__c)!=null)
                        sms.smagicinteract__contact__c=leadToConvertedContact.get(sms.smagicinteract__Lead__c);
                    
                    if(leadToConvertedAccount.get(sms.smagicinteract__Lead__c)!=null)
                        sms.smagicinteract__Account__c=leadToConvertedAccount.get(sms.smagicinteract__Lead__c);
                    
                    if(sms.smagicinteract__contact__c!=null || sms.smagicinteract__Account__c!=null)
                        smsHistoryListtoUpdate.add(sms);
                }
            }
            
            if(incomingSMSList != null && incomingSMSList.size() > 0){
                for(smagicinteract__Incoming_SMS__c sms:incomingSMSList){
                    if(leadToConvertedContact.get(sms.smagicinteract__Lead__c)!=null)
                        sms.smagicinteract__contact__c=leadToConvertedContact.get(sms.smagicinteract__Lead__c);
                    
                    if(leadToconvertedAccount.get(sms.smagicinteract__Lead__c)!=null)
                        sms.Account__c=leadToconvertedAccount.get(sms.smagicinteract__Lead__c);
                        
                    if(sms.smagicinteract__contact__c!=null || sms.Account__c!=null)
                        incomingSMSListtoUpdate.add(sms);
                }
            }
        }
        
        if(smsHistoryListtoUpdate !=null && smsHistoryListtoUpdate.size()>0)
            update smsHistoryListtoUpdate;
        
        if(incomingSMSListtoUpdate!=null && incomingSMSListtoUpdate.size()>0)
            update incomingSMSListtoUpdate;
   }
}