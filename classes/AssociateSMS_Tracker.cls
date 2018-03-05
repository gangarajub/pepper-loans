/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          AssociateSMS 
Company:       Saasfocus
Description:   This is the Test Class for AssociateSMS
History
Date    :  29/09/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
Public class AssociateSMS_Tracker{
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          relatesms
    Company:       Saasfocus
    Description:   This method is use to test the apex class working
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    Public static void unitTest0(){
       
        Lead objLead = CRM_CommonTrackerClassSMS.createLead();
        smagicinteract__smsMagic__c objSMS = CRM_CommonTrackerClassSMS.ceateSmsHistory(objLead.Id);
        smagicinteract__Incoming_SMS__c objIncommingSMS = CRM_CommonTrackerClassSMS.createIncomSMS(objLead.Id);
        
        Test.StartTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Qualified');
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        List<Id> lstId = new List<Id>();
        lstId.add(objLead.Id);
        AssociateSMS objClass = new AssociateSMS();
        AssociateSMS.relatesms(lstId);
        Test.StopTest();
        
        smagicinteract__Incoming_SMS__c objInccSMS = [Select Id,Account__c From smagicinteract__Incoming_SMS__c Where Id = : objIncommingSMS.Id];
        Lead objConvertedLead = [Select ConvertedAccountId From Lead where Id = : objLead.Id];
        system.assert(objInccSMS.Account__c == objConvertedLead.ConvertedAccountId,'worked');
   }
}