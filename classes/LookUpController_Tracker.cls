/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          LookUpController_Tracker 
Company:       Saasfocus
Description:   This is the Test Class for LookUpController
History
Date    :  29/09/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
Public class LookUpController_Tracker{
    
    public static Lead objLead;
    public static Party__c objParty;
    public static Account acc;
    public static Contact objContact;
    public static Account objAccount;
    
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createData
    Company:       Saasfocus
    Description:   creating data for test class
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static void createData(){
        objLead = new Lead();
        objLead.FirstName = 'test';
        objLead.LastName ='lastLeadName';
        objLead.Company = 'CompanyOfLead';
        objLead.CRM_Lead_Channel__c = 'Digital';
        objLead.CRM_Lead_Channel_Level_2__c = 'Email';
        objLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('PAF').getRecordTypeId();
        objLead.CRM_Status_Reason__c = 'Credit History';
        objLead.MobilePhone = '9999999999';
        insert objLead;
        
        objParty = new Party__c();
        objParty.CRM_Name__c = 'Name';
        objParty.CRM_Email__c  = 'N@gmail.com';
        objParty.CRM_Phone__c  = '1111111111';
        objParty.CRM_Type__c  = 'Co Borrower';
        objParty.CRM_Company__c  = 'C';
        objParty.Lead__c  = objLead.id;
        objParty.CRM_Create_New_Business_Account__c = True;
        objParty.CRM_Create_New_Contact__c  = True;
        objParty.CRM_Create_New_Person_Account__c = false;
        insert objParty;
        
        acc = new Account();
        acc.Name='WAT Automation Pty Ltd';
        insert acc;
        
        objContact = new Contact(
                            AccountId = acc.Id,
                            LastName = 'AutoContact kWemA27986',
                            FirstName = 'Test',
                            Email ='test@test.com',
                            MobilePhone='1234567890');

        insert objContact;
        
        objAccount = new Account();
        objAccount.LastName='testAcc';
        objAccount.Personmobilephone = '90909090909';
        insert objAccount;
           
    }
    
    
   /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          lookupClassTest
    Company:       Saasfocus
    Description:   testing fetchAccount,fetchLead,fetchParty,fetchPersonAccount method
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    Public static void lookupClassTest(){
        
        LookUpController_Tracker.createData();
        
        Test.StartTest();
            List<CustomWrapp> lstContact = LookUpController.fetchAccount('Test AutoContact kWemA27986');
            List<CustomWrapp> lstLead = LookUpController.fetchLead('test');
            List<CustomWrapp> lstParty = LookUpController.fetchParty('Name');
            List<CustomWrapp> lstAccount = LookUpController.fetchPersonAccount('testAcc');
        Test.StopTest();
        
        system.assert(lstContact[0].mobilePhone == objContact.MobilePhone, 'worked');
        system.assert(lstLead[0].mobilePhone == objLead.MobilePhone , 'worked');
        system.assert(lstParty[0].mobilePhone == objParty.CRM_Phone__c , 'worked');
        system.assert(lstAccount[0].mobilePhone == objAccount.Personmobilephone , 'worked');
    }
    
    
}