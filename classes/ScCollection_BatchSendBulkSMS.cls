//  -------------------------------------------------------------------------------------------------------
//  This class would look for all the collection activities of SMS types which are required to be process on daily basis.
//  It will collect all thos acitvites and relvant delivery records and send the SMS for all those activites through
//  SMS Magic 'PushSMSCallout' feature.
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 19-Jan-2017   Created By: Kashish Dwivedi  Email: kashish.dwivedi@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestBatchSendBulkSMS
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_BatchSendBulkSMS implements Database.Batchable<sObject>, Database.AllowsCallouts
{    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        string queryDeliveryDetail = 'Select Id,cnotify__Sent_Date__c,cnotify__Sent__c,cnotify__Account__c,' +
                                        'cnotify__Contact__c,cnotify__Message__c,cnotify__Error_Message__c,' +
                                        'cnotify__Account__r.isPersonAccount,cnotify__Account__r.PersonMobilePhone,cnotify__Contact__r.MobilePhone,'+
                                        'cnotify__Account__r.Name '+
                                        'from cnotify__Delivery_Detail__c '+
                                        'where cnotify__Sent__c = false and CreatedDate = TODAY and ScCollection_Template_Type__c = \'Message\'';
        return Database.getQueryLocator(queryDeliveryDetail);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {    
        try{    
            List<cnotify__Delivery_Detail__c> lstDeliveryDetails = new List<cnotify__Delivery_Detail__c>();
            List<smagicinteract__smsmagic__c> lstSMSObjectList = new List<smagicinteract__smsmagic__c>();
            
            //Type cast list to delivery detail object list
            lstDeliveryDetails = (List<cnotify__Delivery_Detail__c>)scope;
            
            //Fetch SMS Magic Sender Id value from custom setting
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('CollectionSenderId');
            
            if(!lstDeliveryDetails.isEmpty())
            {
                for(cnotify__Delivery_Detail__c objDD : lstDeliveryDetails)
                {
                    // capturing the borrower contact number
                    string contactNumber = (objDD.cnotify__Account__c != null && objDD.cnotify__Account__r.isPersonAccount) ? objDD.cnotify__Account__r.PersonMobilePhone : objDD.cnotify__Contact__r.MobilePhone;
                    
                    // setting up records to send the sms
                    smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                    smsObject.smagicinteract__SenderId__c = objSetting.senderId__c;
                    smsObject.smagicinteract__PhoneNumber__c = contactNumber;
                    smsObject.smagicinteract__Name__c = objDD.cnotify__Account__r.Name; // records name
                    smsObject.smagicinteract__ObjectType__c = 'Contact'; // record type
                    smsObject.smagicinteract__disableSMSOnTrigger__c = 1; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
                    smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                    smsObject.smagicinteract__SMSText__c = objDD.cnotify__Message__c;
                    smsObject.ScCollection_Delivery_Detail__c = objDD.Id;
                    lstSMSObjectList.add(smsObject);
                }
            }
            system.debug('lstSMSObjectList@@@@'+lstSMSObjectList);
            
            // invoking pushsmscallout to send out the sms
            String smsResponse = smagicinteract.ApexAPI.pushSMSCallout(lstSMSObjectList);
            system.debug('@@@@smsResponse'+smsResponse);
            Database.insert(lstSMSObjectList,false);
        }
        catch(Exception e){
            throw e;
        }
    }
    
    global void finish(Database.BatchableContext BC) 
    {
        
    }
}