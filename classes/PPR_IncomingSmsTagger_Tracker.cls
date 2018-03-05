/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          PPR_IncomingSmsTagger_Tracker 
Company:       Saasfocus
Description:   This is the Test Class for PPR_IncomingSmsTagger
History
Date    :  29/09/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
Public class PPR_IncomingSmsTagger_Tracker{
    
    public static Lead objLead;
    public static Party__c objParty;
    public static Account acc;
    public static Contact objContact;
    public static Account objAccount;
    public static smagicinteract__smsMagic__c objSMS;
    public static smagicinteract__Incoming_SMS__c objIncommingSMS;
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testIncommingTrigger
    Company:       Saasfocus
    Description:   Testing the incomming trigger
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void testIncommingTrigger(){
        
        objLead = CRM_CommonTrackerClassSMS.createLead();
        objParty = CRM_CommonTrackerClassSMS.createParty(objLead.Id);
        acc = CRM_CommonTrackerClassSMS.createAccount();
        objContact = CRM_CommonTrackerClassSMS.createContact(acc.Id);
        objAccount = CRM_CommonTrackerClassSMS.createPersonAccount();
        objSMS = CRM_CommonTrackerClassSMS.ceateSmsHistory(objLead.Id);
        objSMS.smagicinteract__PhoneNumber__c = '04123456789';
        objSMS.smagicinteract__Name__c = '04123456789';
        objSMS.smagicinteract__Contact__c = objContact.Id;
        objSMS.Party__c = objParty.Id;
        objSMS.smagicinteract__Account__c = objAccount.Id;
        update objSMS;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Qualified');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        Test.StartTest();
        //creaating Incomming SMS without lookup
        objIncommingSMS = new smagicinteract__Incoming_SMS__c(
                                            smagicinteract__Inbound_Number__c = '919282159481',
                                            smagicinteract__Mobile_Number__c = '614123456789',
                                            smagicinteract__SMS_Text__c = 'Pepper Test incoming message from screen magic',
                                            smagicinteract__external_field__c = 'd8948729b4d03ac523245c2786911046',
                                            smagicinteract__MMS_Type__c = 'SMS');

        insert objIncommingSMS;
        Test.StopTest();
        smagicinteract__Incoming_SMS__c objIncSMS = [Select id,Account__c,Party__c,smagicinteract__Contact__c,smagicinteract__Lead__c From smagicinteract__Incoming_SMS__c where Id = : objIncommingSMS.Id];
        System.assert(objIncSMS.smagicinteract__Lead__c == objLead.Id,'worked');
    }
}