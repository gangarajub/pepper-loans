/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          CRMTrgOnQuarterlyTrgtAndAchmnt_Tracker
Company:       Saasfocus
Description:   This class is use to test the trigger behavious.  
------------------------------------------------------------*/
@isTest(SeeAllData=False)
Public class CRMTrgOnQuarterlyTrgtAndAchmnt_Tracker{
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testWeeklyTargetAndAchievement
    Company:       Saasfocus
    Description:   This method is used to test Trigger Working.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    Public static void testMonthlyTargetAndAchievement(){
        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Id = :userInfo.getProfileId()]; 
        User u = new User(Alias = 'testcrm', Email='testcrmuser@testpepper.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testcrmuser@testpepper.com');
        insert u;   
        CRM_Annual_KPI__c objAnualKpi;
        Test.startTest();
        System.runAs(u){
            objAnualKpi= new CRM_Annual_KPI__c(
                            Name = 'test data',
                            CRM_User__c = u.Id,
                            CRM_Year__c = '2017-2018');
            insert objAnualKpi;
            
        }
        Test.stopTest();
        List<CRM_KPI__c> lstQuarterlyKpi = [Select Id From CRM_KPI__c where CRM_Annual_KPI__c = :objAnualKpi.Id and RecordTypeId= : 
                                            Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Settled).getRecordTypeId() and CRM_Quarter__c = '1'];
        List<CRM_Monthly_Target_and_Achievement__c> lstMonthly = [Select Id from CRM_Monthly_Target_and_Achievement__c Where 
                                                                CRM_KPI__c = :lstQuarterlyKpi[0].Id];  
        
        
                                                                       
        System.assertEquals(lstMonthly.Size(),3);
        
    }

}