/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          CRMTrgOnAnnualTrgtAndAchievement_Tracker
Company:       Saasfocus
Description:   This class is use to test the trigger behavious.  
------------------------------------------------------------*/
@isTest(SeeAllData=False)
Public class CRMTrgOnAnnualTrgtAndAchievement_Tracker{
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testQuarterlyTargetAndAchievement
    Company:       Saasfocus
    Description:   This method is used to test Trigger Working.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    Public static void testQuarterlyTargetAndAchievement(){
        
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
                                            Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Settled).getRecordTypeId()];
        System.assertEquals(lstQuarterlyKpi.Size(),4);
        
    }

}