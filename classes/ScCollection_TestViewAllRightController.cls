// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ViewAllRightController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestViewAllRightController
{ 
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static loan__Loan_Account__c objplcontract;
    public static collect__Interaction_Log__c objlog;
       
    public static void loadData()
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id); 
        
        //Insert pl contract
        objplcontract = pepCommonTrackerController.createLoanAccount();   
        
        // Insert Interaction Log
        objlog = new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objContract.id ;
        objlog.collect__Dev_Contract__c = objContract.id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now().addDays(-1);
        objlog.collect__Collector__c = UserInfo.getUserId();
        insert objlog;
    }
    
    public static testMethod void myUnittest()
    {  
        loaddata();
        
        objContract.ScCollection_Arrears__c = 100;
        objContract.ScCollection_Bucket__c = 100;
        objContract.ScCollection_Next_Installment_Date__c = System.Today().addDays(10);
        update objContract;
        
        String ContractStatusId = [select collect__Collection_Status__c from collect__Loan_Account__c where Id =: objContract.Id].collect__Collection_Status__c;
        
        collect__Contract_Status__c objstatus = [select Id, ScCollection_Arrears__c, ScCollection_Log_Created_Date__c from collect__Contract_Status__c where Id =: ContractStatusId];
        objstatus.ScCollection_Log_Created_Date__c = System.Today().addDays(10);
        objstatus.ScCollection_Arrears__c = 'New Work';
        update objstatus;
        
        collect__Loan_Account__History objhis = new collect__Loan_Account__History(ParentId = objContract.Id, Field = 'ScCollection_Arrears__c');
        insert objhis;
        
        collect__Loan_Account__History objhis1 = new collect__Loan_Account__History(ParentId = objContract.Id, Field = 'ScCollection_Bucket__c');
        insert objhis1;
        
        collect__Loan_Account__History objhis2 = new collect__Loan_Account__History(ParentId = objContract.Id, Field = 'ScCollection_Next_Installment_Date__c');
        insert objhis2;
        
        collect__Contract_Status__History objhis3 = new collect__Contract_Status__History(ParentId = objstatus.Id, Field = 'ScCollection_Log_Created_Date__c');
        insert objhis3;
        
        collect__Contract_Status__History objhis4 = new collect__Contract_Status__History(ParentId = objstatus.Id, Field = 'ScCollection_Arrears__c');
        insert objhis4;
        
        ApexPages.currentPage().getParameters().put('Id', objContract.id);
        ApexPages.currentPage().getParameters().put('display', 'Audits');
        ScCollection_ViewAllRightController obj = new ScCollection_ViewAllRightController();
    }
    
    public static testMethod void myUnittest1()
    {  
        loaddata();
        
        objplcontract.loan__ACH_Debit_Amount__c = 100;
        objplcontract.loan__Disbursal_Date__c = System.Today().addDays(10);
        update objplcontract;
        
        String ContractStatusId = [select ScCollection_Collection_Status__c from loan__Loan_Account__c where Id =: objplcontract.Id].ScCollection_Collection_Status__c;
        
        collect__Contract_Status__c objstatus = [select Id, ScCollection_Arrears__c, ScCollection_Log_Created_Date__c from collect__Contract_Status__c where Id =: ContractStatusId];
        objstatus.ScCollection_Log_Created_Date__c = System.Today().addDays(10);
        objstatus.ScCollection_Arrears__c = 'New Work';
        update objstatus;
        
        loan__Loan_Account__History objhis1 = new loan__Loan_Account__History(ParentId = objplcontract.Id, Field = 'loan__ACH_Debit_Amount__c');
        insert objhis1;
        
        loan__Loan_Account__History objhis2 = new loan__Loan_Account__History(ParentId = objplcontract.Id, Field = 'loan__Disbursal_Date__c');
        insert objhis2;
        
        collect__Contract_Status__History objhis3 = new collect__Contract_Status__History(ParentId = objstatus.Id, Field = 'ScCollection_Log_Created_Date__c');
        insert objhis3;
        
        collect__Contract_Status__History objhis4 = new collect__Contract_Status__History(ParentId = objstatus.Id, Field = 'ScCollection_Arrears__c');
        insert objhis4;
        
        ApexPages.currentPage().getParameters().put('Id', objplcontract.id);
        ApexPages.currentPage().getParameters().put('display', 'Audits');
        ScCollection_ViewAllRightController obj = new ScCollection_ViewAllRightController();
    }
     
    public static testMethod void myUnittest2()
    {  
        loadData();
        ApexPages.currentPage().getParameters().put('Id', objContract.id);
        ApexPages.currentPage().getParameters().put('display', 'Interaction Logs');
        ScCollection_ViewAllRightController obj = new ScCollection_ViewAllRightController();
    }
}