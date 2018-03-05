//-----------------------------------------------------------------------------------------------------
// Description : This class is test class for CRM_Mtg_UpdateContactAppCount, CRM_Mtg_UpdateAccountAppCount
// and CRM_Mtg_ScheduleBatchToUpdateAppCount classes
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
// 1.0                            Sandip Bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
@isTest(SeeAllData = false)
public class CRM_Mtg_TestBatchToUpdateAppCount
{
    @isTest static void test0()
    {
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
        LastName = 'last',
        Email = 'puser000@amamama.com',
        Username = 'puser000@amamama.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        CRM_Mtg_Unique_Id__c =111245
        );   
        
        insert u; 
        
        system.runAs(u)
        {
            CRM_Mtg_BDM_Target__c objBdmTarget = 
            new CRM_Mtg_BDM_Target__c(
            Name = '123456-Mar-2017',
            CRM_Mtg_BDM_Unique_Id__c = 111245,
            CRM_Mtg_BDM__c = u.id,
            CRM_Mtg_Month__c = 'Mar',
            CRM_Mtg_Unique_Id__c = '123456-Mar-2017',
            CRM_Mtg_Year__c = '2017',
            CRM_Mtg_Default_Record__c = true);
            
            insert objBdmTarget;
            
            CRM_Mtg_Application_Target__c objAppTarget = 
            new CRM_Mtg_Application_Target__c(
            CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
            CRM_Mtg_Channel__c = 'White Label',
            CRM_Mtg_Product__c = 'Prime',
            CRM_Mtg_Target_Applications_Amt__c = 0.0,
            CRM_Mtg_Target_Applications__c = 0.0);

            insert objAppTarget;
            
            CRM_Mtg_Settlement_Target__c objSettTarget = 
            new CRM_Mtg_Settlement_Target__c(
            CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
            CRM_Mtg_Channel__c = 'White Label',
            CRM_Mtg_Product__c = 'Prime',
            CRM_Mtg_Target_Settlements_Amt__c = 0.0,
            CRM_Mtg_Target_Settlements__c = 0.0);
            insert objSettTarget;
            
            Account acc = new Account(Name='testAccount',CRM_Mtg_Channel__c='White Label',CRM_Mtg_Unique_Id__c =111);
            insert acc;
            
            Contact con = new Contact(LastName = 'testContact',AccountId=acc.Id,CRM_Mtg_Unique_Id__c = 112);
            insert con;
            
            Date dt = System.Today();
            
            
            Map<Integer,String> mapMonthName = new map<Integer,String>();
            mapMonthName.put(1,'Jan');
            mapMonthName.put(2,'Feb');
            mapMonthName.put(3,'Mar');
            mapMonthName.put(4,'Apr');
            mapMonthName.put(5,'May');
            mapMonthName.put(6,'Jun');
            mapMonthName.put(7,'Jul');
            mapMonthName.put(8,'Aug');
            mapMonthName.put(9,'Sep');
            mapMonthName.put(10,'Oct');
            mapMonthName.put(11,'Nov');
            mapMonthName.put(12,'Dec');
            
            CRM_Mortgage_Application_Data__c objMortData = 
            new CRM_Mortgage_Application_Data__c(
            Name = '600039',
            CRM_Mtg_Application_Target__c = objAppTarget.Id,
            CRM_Mtg_Settlement_Target__c = objSettTarget.Id,
            CRM_Mtg_Doc_Header_Id__c = '123549',
            CRM_Mtg_Aggregator_Id__c = '29681',
            CRM_Mtg_Aggregator_Name__c = 'United Mortgage Services Pty Ltd',
            CRM_Mtg_Application_Amount__c = 1141000.0,
            CRM_Mtg_Application_Date__c = Date.newInstance(dt.Year(),dt.Month()-2,dt.Day()-10),
            CRM_Mtg_Settlement_Date__c = Date.newInstance(dt.Year(),dt.Month()-2,dt.Day()-10),
            CRM_Mtg_Application_Id__c = '﻿600039',
            CRM_Mtg_Application_Status__c = 'Post-Settlement',
            CRM_Mtg_Broker_Application_Id__c = '600039',
            CRM_Mtg_Broker_Id__c = '30319',
            CRM_Mtg_Broker_Name__c = 'Richard Wilson',
            CRM_Mtg_Total_Loan_Amount__c = 1141000.0,
            CRM_Mtg_Aggregator__c =acc.Id,
            CRM_Mtg_Application_Year__c = String.valueOf(dt.Year()),
            CRM_Mtg_Application_Month__c =mapMonthName.get(System.today().Month()) ,
            CRM_Mtg_Settlement_Month__c=mapMonthName.get(System.today().Month()),
            CRM_Mtg_Settlement_Year__c = String.valueOf(dt.Year()),
            CRM_Mtg_Settlement_Amount__c = 100000,
            CRM_Mtg_Broker__c = con.Id);

            insert objMortData;
            
            CRM_Mtg_UpdateAccountAppCount objAccountBatch = new CRM_Mtg_UpdateAccountAppCount();
            database.ExecuteBatch(objAccountBatch);
            CRM_Mtg_UpdateContactAppCount objContactBatch = new CRM_Mtg_UpdateContactAppCount ();
            database.executeBatch(objContactBatch);
            CRM_Mtg_ScheduleBatchToUpdateAppCount objSchedule = new CRM_Mtg_ScheduleBatchToUpdateAppCount();
            objSchedule.execute(null);
        }
    }
}