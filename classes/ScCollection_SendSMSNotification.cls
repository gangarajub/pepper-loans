/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_SendSMSNotification 
Company:       Saasfocus
Description:   This class is invoked by trigegr handler which sends sms if any error in post sync job occure.
History
Date    :  23/06/2017     
------------------------------------------------------------*/
public class ScCollection_SendSMSNotification implements Queueable, Database.AllowsCallouts {
    
    public String strLstParsedSyncStatistics {get;set;}
    public String strLstPhoneNumbers {get;set;}
    public String strSMSTemplates {get;set;}
    
    //Constructor
    public ScCollection_SendSMSNotification(String strParsedSyncedStatictics,String strPhoneNumber,String strSmsTemplate){
        
        this.strLstParsedSyncStatistics = strParsedSyncedStatictics;
        this.strLstPhoneNumbers = strPhoneNumber;
        this.strSMSTemplates = strSmsTemplate;
        
    }   
    
    /*------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          execute
    Company:       Saasfocus
    Description:   This method is used to send sms when error occure.
    Inputs:        QueueableContext 
    Returns:       void            
    History
    23/06/2017       Sandip bijlwan     
    ------------------------------------------------------------*/
    
    public void execute(QueueableContext context){
        
        try{
            list<collect__Sync_Statistics__c> lstSyncedStatics = (list<collect__Sync_Statistics__c>)JSON.deserialize(strLstParsedSyncStatistics,List<collect__Sync_Statistics__c>.class);
            List<smagicinteract__smsmagic__c> lstSMSObject = new List<smagicinteract__smsmagic__c>();
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('CollectionSenderId');
            if(!String.isBlank(strLstPhoneNumbers)){
                List<String> lstPhoneNumber = strLstPhoneNumbers.split(',');
                for(collect__Sync_Statistics__c objSyncStatistics : lstSyncedStatics){
                    
                    for(String s : lstPhoneNumber){
                        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                        smsObject.smagicinteract__SenderId__c = objSetting.senderId__c;
                        smsObject.smagicinteract__PhoneNumber__c = s;
                        smsObject.smagicinteract__Name__c = (objSyncStatistics.Name != null ? String.valueof(objSyncStatistics.Name) : '' ); // records name
                        smsObject.smagicinteract__ObjectType__c = 'Sync Statistics'; // record type
                        smsObject.smagicinteract__disableSMSOnTrigger__c = 1; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
                        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                        smsObject.smagicinteract__SMSText__c = strSMSTemplates;
                        
                        lstSMSObject.add(smsObject);
                    }
                }
            }
            System.debug('lstSMSObject =='+lstSMSObject);
            String smsResponse = smagicinteract.ApexAPI.pushSMSCallout(lstSMSObject);
            system.debug('@@@@smsResponse'+smsResponse);
            Database.insert(lstSMSObject,false);
        }
        catch(Exception ex){
            System.debug('Error : '+ex.getMessage());
        }
    }  
}