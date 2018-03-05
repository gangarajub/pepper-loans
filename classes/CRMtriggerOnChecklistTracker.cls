@isTest(SeeAllData=false) public class CRMtriggerOnChecklistTracker{

    @isTest static void test0(){
    
        Case cse = new Case ();
        cse.status = 'New';
        cse.CRM_Channel__c = 'Auto Broker';
        cse.CRM_Broker_Relationship__c = 'Direct';
        insert cse;
        
        Id directAutoBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Direct Auto Broker').getRecordTypeId();
        
        CRM_Checklist__c check = new CRM_Checklist__c();
        check.recordtypeid = directAutoBroker;
        check.CRM_Introducer_Agreement__c = 'Received complete full version';
        check.CRM_Deposit_Slip__c = 'Received - on file';
        check.CRM_ABN_Registered_for_past_24_months__c = 'Yes';
        check.CRM_GST_Registered__c = 'Registered';
        check.CRM_Comprehensive_Veda_Check__c = 'Nil Adverse history';
        check.CRM_ASIC_Banned_Disqualified__c = 'Clear B&D on Director/s';
        check.CRM_Department_of_Foreign_Affairs__c = 'No Listing';
        check.CRM_PAF_Black_List_Check__c = 'Nil Listings';
        check.CRM_Website_Search__c = 'Google Match';
        check.CRM_Australian_Credit_Licence_ACL__c = 'ACL details saved';
        check.CRM_Australian_Credit_Representive_ACR__c = 'ACL on file - NO ACR REQUIRED';
        check.CRM_External_Dispute_Resolution_EDR__c = 'CIO Membership';
        check.CRM_Personal_Indemnity_Insurance__c = 'On file - Minimum $5 million:';
        check.CRM_Police_Check_Directors_Only__c = 'Not Received**';
        check.CRM_Status__c = 'Completed';
        check.CRM_Case__c = cse.id;
        insert check;
        
        check.CRM_Status__c = 'Draft';
        update check;
        
        check.CRM_Status__c = 'Completed';
        update check;
    }

}