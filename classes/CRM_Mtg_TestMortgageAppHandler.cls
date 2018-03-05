//-----------------------------------------------------------------------------------------------------
// Description : This class is test class for CRM_Mtg_MortgageAppHandler class
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
// 1.0                            Sandip Bijlwan                sandip.bijlwan@saasfocus.com
// 2.0                Alex Humby       
//       Added Opportunity and Custom Setting to test CRMtrgMortageToOpportunityLookupHandler
//-----------------------------------------------------------------------------------------------------
@isTest(SeeAllData = false)
public class CRM_Mtg_TestMortgageAppHandler
{
    public static CRM_Mtg_BDM_Target__c objBdmTarget;
    public static CRM_Mtg_Application_Target__c objAppTarget;
    public static CRM_Mtg_Settlement_Target__c objSettTarget;
    public static CRM_Mortgage_Application_Data__c objMortData;
    public static CRM_Mortgage_Application_Data__c objMortData1;
    public static CRM_Mortgage_Application_Data__c objMortData2;
    public static Account acc;
    public static Contact con;
    public static Opportunity opp;
    public static Opportunity opp1;
    public static List<ApplicationStatusToOptyMapping__c> lstAppStatus;
    
    @isTest 
    static void updateOpportunityLookupTest()
    {
        createRecord();

        insert objMortData;
        
        objAppTarget.CRM_Mtg_Channel__c = 'Retail';
        objSettTarget.CRM_Mtg_Channel__c = 'Retail';
        update objAppTarget;
        update objSettTarget;
        insert objMortData1;
        
        objMortData1.CRM_Mtg_Settlement_Date__c = system.today();
        objMortData.CRM_Mtg_Settlement_Date__c = system.today();
        update objMortData;
        update objMortData1;
        
        CRM_Mortgage_Application_Data__c objMortDataQuery = [Select Id,CRM_Mtg_Opportunity__c,CRM_Mtg_Failure_Reason__c From CRM_Mortgage_Application_Data__c Where Id = :objMortData.Id];
        system.assertEquals(objMortDataQuery.CRM_Mtg_Failure_Reason__c,'Target record does not exist for BDM');
        
        
        opp.CRM_Lead_ID__c = '123';
        update opp;
        
        objMortData.Lead_ID__c = '123';
        objMortData.CRM_Mtg_Application_Id__c = '1110';
        objMortData.CRM_Mtg_Channel__c = 'Direct';
        update objMortData;
        
        opp.LeadSource = 'PPS';
        opp.CRM_Application_ID__c = '1110';
        opp.CRM_Lost_Reason__c ='Declined';
        update opp;
        
        objMortData1.Lead_ID__c = '123';
        objMortData1.CRM_Mtg_Application_Id__c = '1110';
        objMortData1.CRM_Mtg_Channel__c = 'Direct';
        update objMortData1;
        
        
        insert objMortData2;
        CRM_Mortgage_Application_Data__c objMortDataQuery1 = [Select Id,CRM_Mtg_Opportunity__c From CRM_Mortgage_Application_Data__c Where Id = :objMortData2.Id];
        system.assertEquals(objMortDataQuery1.CRM_Mtg_Opportunity__c,opp1.Id);
    }
    public static void createRecord()
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

        system.runas(u)
        {
            Date dt = system.today();
            
            objBdmTarget = new CRM_Mtg_BDM_Target__c(
                                    Name = '123456-Mar-2017',
                                    CRM_Mtg_BDM_Unique_Id__c = 111245,  
                                    CRM_Mtg_Month__c = 'Mar',
                                    CRM_Mtg_Year__c = String.valueOf(System.Today().Year()),
                                    CRM_Mtg_Default_Record__c = true);
                        
            insert objBdmTarget;
            
            objAppTarget = new CRM_Mtg_Application_Target__c(
                                    CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
                                    CRM_Mtg_Channel__c = 'White Label',
                                    CRM_Mtg_Product__c = 'Prime',
                                    CRM_Mtg_Target_Applications_Amt__c = 0.0,
                                    CRM_Mtg_Target_Applications__c = 0.0,
                                    CRM_Mtg_Unique_Identifier__c = '123111');
                
            insert objAppTarget;
              
            objSettTarget = new CRM_Mtg_Settlement_Target__c(
                                    CRM_Mtg_BDM_Target__c = objBdmTarget.Id,
                                    CRM_Mtg_Channel__c = 'White Label',
                                    CRM_Mtg_Product__c = 'Prime',
                                    CRM_Mtg_Target_Settlements_Amt__c = 0.0,
                                    CRM_Mtg_Target_Settlements__c = 0.0);
                    
            insert objSettTarget;
            
            acc = new Account(Name='testAccount',CRM_Mtg_Channel__c='White Label',CRM_Mtg_Unique_Id__c = 1211);
            insert acc;
            
            con = new Contact(LastName='testContact',AccountId = acc.Id,CRM_Mtg_Unique_Id__c = 1213);
            insert con;
            
            objMortData = new CRM_Mortgage_Application_Data__c(Name = '600040',
                                    CRM_Mtg_Doc_Header_Id__c = '123549',
                                    CRM_Mtg_Application_Target__c = objAppTarget.Id,
                                    CRM_Mtg_Settlement_Target__c = objSettTarget.Id,
                                    CRM_Mtg_Aggregator_Id__c = '1211',
                                    CRM_Mtg_Application_Date__c = Date.newInstance(dt.Year(),dt.Month(),dt.Day()-10),
                                    CRM_Mtg_Application_Id__c = '1211',
                                    CRM_Mtg_Broker_Id__c = '1213',
                                    //CRM_Mtg_Total_Loan_Amount__c = 1141000.0,
                                    CRM_Mtg_Channel__c = 'White Label',
                                    CRM_Mtg_Product__c = 'Specialist',
                                    CRM_Mtg_Application_Status__c = 'Conditionally Approved Awaiting Outstanding Conditions',
                                    CRM_Mtg_BDM_SF_Id__c = '111245',
                                    Lead_ID__c = '1231',
                                    Lead_Source_Type__c = 'Scenario',
                                    CRM_Mtg_Application_Amount__c = 300);
                                    
            objMortData1 = new CRM_Mortgage_Application_Data__c(Name = '600040',
                                    CRM_Mtg_Doc_Header_Id__c = '1235499',
                                    CRM_Mtg_Application_Target__c = objAppTarget.Id,
                                    CRM_Mtg_Settlement_Target__c = objSettTarget.Id,
                                    CRM_Mtg_Aggregator_Id__c = '1211',
                                    CRM_Mtg_Application_Date__c = Date.newInstance(dt.Year(),dt.Month(),dt.Day()-10),
                                    CRM_Mtg_Application_Id__c = '1211',
                                    CRM_Mtg_Broker_Id__c = '1213',
                                    CRM_Mtg_Total_Loan_Amount__c = 1141000.0,
                                    CRM_Mtg_Channel__c = 'Retail',
                                    CRM_Mtg_Product__c = 'Prime',
                                    CRM_Mtg_Application_Status__c = 'Withdrawn',
                                    CRM_Mtg_BDM_SF_Id__c = '111245',
                                    Lead_ID__c = '1231',
                                    Lead_Source_Type__c = 'PepperProductSelector',
                                    CRM_Mtg_Application_Amount__c = 300);   
                                    
            objMortData2 = new CRM_Mortgage_Application_Data__c(Name = '600040',
                                    CRM_Mtg_Doc_Header_Id__c = '1239',
                                    CRM_Mtg_Application_Target__c = objAppTarget.Id,
                                    CRM_Mtg_Settlement_Target__c = objSettTarget.Id,
                                    CRM_Mtg_Aggregator_Id__c = '1211',
                                    CRM_Mtg_Application_Date__c = Date.newInstance(dt.Year(),dt.Month(),dt.Day()-10),
                                    CRM_Mtg_Application_Id__c = '11111',
                                    CRM_Mtg_Broker_Id__c = '1213',
                                    CRM_Mtg_Total_Loan_Amount__c = 1141000.0,
                                    CRM_Mtg_Channel__c = 'Direct',
                                    CRM_Mtg_Product__c = 'Prime',
                                    CRM_Mtg_Application_Status__c = 'Withdrawn',
                                    CRM_Mtg_BDM_SF_Id__c = '111245',
                                    CRM_Mtg_Application_Amount__c = 300); 

            opp = new Opportunity(Name='opp', AccountId=acc.Id,CloseDate= System.today() +2, StageName='Application', CRM_Application_ID__c='1211',CRM_Lead_ID__c = '1231',LeadSource='Scenario');
            insert opp;
            
            opp1 = new Opportunity(Name='opp', AccountId=acc.Id,CloseDate= System.today() +2, StageName='Application', CRM_Application_ID__c='11111');
            insert opp1;
            
            ApplicationStatusToOptyMapping__c objAppStatus = new ApplicationStatusToOptyMapping__c(
                                                                        Application_Status__c = 'Withdrawn',
                                                                        Name = 'Application',
                                                                        Opportunity_Stage_Name__c = 'Closed',
                                                                        Order__c = 10,
                                                                        ShowRelatedToOpty__c = true,
                                                                        B2B_Oppty_Stage_Name__c = 'Closed Lost'
                                                                    );
          
            
            
            ApplicationStatusToOptyMapping__c objAppStatus1 = new ApplicationStatusToOptyMapping__c(
                                                                    Application_Status__c = 'Conditionally Approved Awaiting Outstanding Conditions',
                                                                    Name = 'Conditionally Approved Awaiting',
                                                                    Opportunity_Stage_Name__c = 'Conditionally Approved',
                                                                    Order__c = 20,
                                                                    ShowRelatedToOpty__c = true,
                                                                    B2B_Oppty_Stage_Name__c = 'Conditionally Approved'
                                                                );
            
            lstAppStatus = new List<ApplicationStatusToOptyMapping__c>();   
            lstAppStatus.add(objAppStatus);
            lstAppStatus.add(objAppStatus1);
            insert lstAppStatus;
        }
        
    }
}