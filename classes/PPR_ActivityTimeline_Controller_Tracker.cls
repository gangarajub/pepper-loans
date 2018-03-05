/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          PPR_ActivityTimeline_Controller_Tracker 
Company:       Saasfocus
Description:   This is the Test Class for PPR_ActivityTimeline_Controller
History
Date    :  29/09/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
Public class PPR_ActivityTimeline_Controller_Tracker{
    
    
    public static Lead objLead;
    public static Party__c objParty;
    public static Account acc;
    public static Contact objContact;
    public static Account objAccount;
    public static smagicinteract__smsMagic__c objSMS;
    public static smagicinteract__Incoming_SMS__c objIncommingSMS;
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createSMSRecords
    Company:       Saasfocus
    Description:   creating data for test class
    Inputs:        String
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static void createSMSRecords(String sObjectName){
        
        if(sObjectName == 'Contact'){
            objSMS.smagicinteract__Contact__c = objContact.Id ;
            objSMS.smagicinteract__Lead__c = null;
            update objSMS;
            
            objIncommingSMS.smagicinteract__Contact__c = objContact.Id;
            objIncommingSMS.smagicinteract__Lead__c = null;
            update objIncommingSMS;
            
        }   
        if(sObjectName == 'Party__c'){
            objSMS.Party__c = objParty.Id;
            objSMS.smagicinteract__Contact__c = null ;
            objSMS.smagicinteract__Lead__c = null;
            update objSMS;
            
            objIncommingSMS.Party__c = objParty.Id;
            objIncommingSMS.smagicinteract__Contact__c = null;
            objIncommingSMS.smagicinteract__Lead__c = null;
            update objIncommingSMS;
        }
        if(sObjectName == 'Account'){
            objSMS.smagicinteract__Account__c = objAccount.Id;
            objSMS.Party__c = null;
            objSMS.smagicinteract__Contact__c = null ;
            objSMS.smagicinteract__Lead__c = null;
            update objSMS;
            
            objIncommingSMS.Account__c = objAccount.Id;
            objIncommingSMS.Party__c = null;
            objIncommingSMS.smagicinteract__Contact__c = null;
            objIncommingSMS.smagicinteract__Lead__c = null;
            update objIncommingSMS;
        }
    }
    
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getDefaultContactDetailsTest
    Company:       Saasfocus
    Description:   testing getDefaultContactDetails
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    Public static void getDefaultContactDetailsTest(){
                
        objLead = CRM_CommonTrackerClassSMS.createLead();
        objParty = CRM_CommonTrackerClassSMS.createParty(objLead.Id);
        acc = CRM_CommonTrackerClassSMS.createAccount();
        objContact = CRM_CommonTrackerClassSMS.createContact(acc.Id);
        objAccount = CRM_CommonTrackerClassSMS.createPersonAccount();
        objSMS = CRM_CommonTrackerClassSMS.ceateSmsHistory(objLead.Id);
        objIncommingSMS = CRM_CommonTrackerClassSMS.createIncomSMS(objLead.Id);
        
        Test.StartTest();
        
        PPR_ActivityTimeline_Controller.ContactDetails leadResult =  PPR_ActivityTimeline_Controller.getDefaultContactDetails('Lead',objLead.Id);
        PPR_ActivityTimeline_Controller.ContactDetails contactResult =  PPR_ActivityTimeline_Controller.getDefaultContactDetails('Contact',objContact.Id);
        PPR_ActivityTimeline_Controller.ContactDetails partyResult = PPR_ActivityTimeline_Controller.getDefaultContactDetails('Party__c',objParty.Id);
        PPR_ActivityTimeline_Controller.ContactDetails accountResult = PPR_ActivityTimeline_Controller.getDefaultContactDetails('Account',objAccount.Id);
        
        Test.StopTest();
        
        system.assert(leadResult.phone == '9999999999','woked');
        system.assert(contactResult.phone == '1234567890','woked');
        system.assert(partyResult.phone == '1111111111','woked');
        system.assert(accountResult.phone == '90909090909','woked');
        
   }
   
   /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getActivityTimelineTest
    Company:       Saasfocus
    Description:   testing getActivityTimeline, addSMS method
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    Public static void getActivityTimelineTest(){
        
        objLead = CRM_CommonTrackerClassSMS.createLead();
        objParty = CRM_CommonTrackerClassSMS.createParty(objLead.Id);
        acc = CRM_CommonTrackerClassSMS.createAccount();
        objContact = CRM_CommonTrackerClassSMS.createContact(acc.Id);
        objAccount = CRM_CommonTrackerClassSMS.createPersonAccount();
        objSMS = CRM_CommonTrackerClassSMS.ceateSmsHistory(objLead.Id);
        objIncommingSMS = CRM_CommonTrackerClassSMS.createIncomSMS(objLead.Id);
        
        Test.StartTest();
                
        List<PPR_ActivityTimeline_Model> lstLead = PPR_ActivityTimeline_Controller.getActivityTimeline('Lead',objLead.Id);
        
        PPR_ActivityTimeline_Controller_tracker.createSMSRecords('Contact');
        List<PPR_ActivityTimeline_Model> lstContact = PPR_ActivityTimeline_Controller.getActivityTimeline('Contact',objContact.Id);
        
        PPR_ActivityTimeline_Controller_tracker.createSMSRecords('Party__c');
        List<PPR_ActivityTimeline_Model> lstParty = PPR_ActivityTimeline_Controller.getActivityTimeline('Party__c',objParty.Id);
        
        PPR_ActivityTimeline_Controller_tracker.createSMSRecords('Account');
        List<PPR_ActivityTimeline_Model> lstAccount = PPR_ActivityTimeline_Controller.getActivityTimeline('Account',objAccount.Id);
        
        
        PPR_ActivityTimeline_Controller.addSMS(objLead.Id,'Lead','','12345','testing lead');
        PPR_ActivityTimeline_Controller.addSMS(objContact.Id,'Contact','','12345','testing lead');
        PPR_ActivityTimeline_Controller.addSMS(objParty.Id,'Party__c','','12345','testing lead');
        PPR_ActivityTimeline_Controller.addSMS(objAccount.Id,'Account','','12345','testing lead');
        
        
        Test.StopTest();
        system.assert(lstLead[0].parentRecordId == objLead.Id,'woked');
        system.assert(lstContact[0].parentRecordId == objContact.Id,'woked');
        system.assert(lstParty[0].parentRecordId == objParty.Id,'woked');
        system.assert(lstAccount[0].parentRecordId == objAccount.Id,'woked');
        
    }
}