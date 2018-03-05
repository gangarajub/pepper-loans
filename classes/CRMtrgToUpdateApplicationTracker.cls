/*------------------------------------------------------------
Author:        sandip bijlwan  
Name:          CRMtrgToUpdateApplicationTracker
Company:       Saasfocus
Description:   This class is use to test opportunity trigger
               trigger
History     
------------------------------------------------------------*/
@isTest(SeeAllData=False) Private class CRMtrgToUpdateApplicationTracker{
    
    /*------------------------------------------------------------
    Author:        sandip bijlwan
    Name:          testpprtunityTrigger
    Company:       Saasfocus
    Description:   Changes the opportunity Id on Application data when Application Id on Oppty gets updated
    Inputs:        
    Returns:       void
    History
    ------------------------------------------------------------*/
    @isTest static void testpprtunityTrigger(){
        
        Account acc = new Account();
        acc.Name='Name';
        insert acc;
        
        ApplicationStatusToOptyMapping__c aSO = new ApplicationStatusToOptyMapping__c();
        aSO.Name = 'Settlement Booked';
        aSO.Application_Status__c = 'Settlement Booked';
        aSO.Opportunity_Stage_Name__c = 'Settled';
        aSO.Order__c = 120;
        aSO.ShowRelatedToOpty__c = true;
        
        insert aSO;
        
        test.startTest();      
        Opportunity opp = new Opportunity();
        opp.Name='Opp Name';
        opp.AccountID = acc.id;
        opp.CloseDate=System.today()+4;
        opp.StageName='Settled';
        opp.CRM_Application_ID__c='1';
        opp.CRM_Loan_Type__c = 'Asset Finance';
        insert opp; 
        
        Application_Data__c objApp = new Application_Data__c();
        objApp.ApplicationNumber__c='1';
        objApp.CRM_Opportunity__c = opp.Id;
        insert objApp;
        
        Application_Data__c objApp1 = new Application_Data__c();
        objApp1.ApplicationNumber__c='2';
        insert objApp1; 
        
        Pepper_Data__c objPepData = new Pepper_Data__c();
        objPepData.Mortgage_FK__c='1';
        objPepData.ApplicationID__c = '1';
        objPepData.Status_Detail__c = 'Settlement Booked';
        insert objPepData;
        
        Pepper_Data__c objPepData1 = new Pepper_Data__c();
        objPepData1.Mortgage_FK__c='2';
        objPepData1.ApplicationID__c = '2';
        objPepData1.Status_Detail__c = 'Settlement Booked';
        insert objPepData1;
        
        
        opp.CRM_Application_ID__c='2';
        update opp;
        
      
        test.stopTest();
        Application_Data__c obj = [Select Id,CRM_Opportunity__c from Application_Data__c  where Id=:objApp1.Id];
        system.assertequals(obj.CRM_Opportunity__c,opp.Id);
    
    }
    
    
   /*------------------------------------------------------------
    Author:        Mitali Telang
    Name:          testOpprtunityTrigger
    Company:       Pepper
    Description:   Creates 4 or 5 Weekly Target and Achievement For each Monthly Target and Achievement
    Inputs:        
    Returns:       void
    History
    ------------------------------------------------------------*/
    @isTest static void testOpprtunityTrigger(){
     
         Profile p = [SELECT Id FROM Profile WHERE Id = :userInfo.getProfileId()]; 
        User u = new User(Alias = 'testcrm', Email='testcrmuser@testpepper.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testcrmuser@testpepper.com');
        insert u;  
        Account acc = new Account();
        acc.Name='Name';
        insert acc;
        Test.startTest();
        System.runAs(u){ 
            CRM_Annual_KPI__c objAnualKpi;
            objAnualKpi= new CRM_Annual_KPI__c(
                                Name = 'test data',
                                CRM_User__c = u.Id,
                                CRM_Year__c = '2017-2018');
            insert objAnualKpi;
        
            Opportunity opp = new Opportunity();
            opp.Name='Opp Name';
            opp.AccountID = acc.id;
            opp.CloseDate=System.today()+4;
            opp.StageName='Settled';
            opp.CRM_Application_ID__c='1';
            opp.OwnerId = u.Id;
            opp.CRM_Loan_Type__c = 'Asset Finance';
            insert opp;    
        }
        test.stopTest();
        
        List <CRM_Weekly_Target_and_Achievement__c> lstWeekly = new List<CRM_Weekly_Target_and_Achievement__c>();
        lstWeekly = [Select CRM_Daily_Achievement__c, CRM_KPI_User__c from CRM_Weekly_Target_and_Achievement__c where CRM_KPI_User__c  =:u.id and CRM_From__c <= Today and CRM_To__c >= Today];
        system.assertEquals(lstWeekly[0].CRM_Daily_Achievement__c, 1 );
        
    }
}