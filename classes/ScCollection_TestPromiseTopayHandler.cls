// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_PromiseTopayHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestPromiseTopayHandler
{   
    public static collect__Promise_To_Pay__c objPromisetoPayNew = null;
    public static collect__Promise_To_Pay__c objPromisetoPayOld = null;
    public static  collect__Source_System__c objSourceSystem = null;
    public static collect__Loan_Account__c objContract = null;
    public static loan__Loan_Account__c objplcontract = null;
    public static collect__Promise_To_Pay__c objPtp =null;
   
    public static void loadData()
    {
        objSourceSystem = new collect__Source_System__c();
        objSourceSystem.Name = 'PAF' ;
        insert objSourceSystem;
         
        //Insert Object of Contract
        objContract = new collect__Loan_Account__c();
        objContract.Name ='Contract-001';
        objContract.collect__Source_System__c = objSourceSystem.id ;
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Delinquent_Amount__c =80;
        insert objContract ;
            
        objPromisetoPayOld = new  collect__Promise_To_Pay__c();
        objPromisetoPayOld.collect__Loan_Account_Id__c = String.valueOf(objContract.id); 
        objPromisetoPayOld.collect__Promise_To_Pay_Date__c =date.today();
        objPromisetoPayOld.collect__Promise_To_Pay_Amount__c = 32732;
        objPromisetoPayOld.collect__Promise_Broken__c = true;
        objPromisetoPayOld.collect__Dev_Contract__c = objContract.id ;
         
        objPtp = new  collect__Promise_To_Pay__c();
        objPtp.collect__Promise_To_Pay_Date__c =date.today();
        objPtp.collect__Promise_To_Pay_Amount__c = 32732;
        objPtp.collect__Promise_Broken__c = false;
         
        objPromisetoPayNew = new  collect__Promise_To_Pay__c(id = objPromisetoPayOld.id);
        objPromisetoPayNew.collect__Promise_To_Pay_Amount__c = 32732;   
        
         
    }
    
    static testMethod void myUnitTest() 
    {
        loadData();
        
        
        
        list<collect__Promise_To_Pay__c> lstPTP = new list<collect__Promise_To_Pay__c>();
        lstPTP.add(objPromisetoPayOld);
        lstPTP.add(objPtp);
        insert lstPTP ;
        
        objPtp.collect__Promise_Kept__c = true;
        update objPtp;
        
        
        update lstPTP ;
        delete lstptp;
        
        
        
        //delete objPtp; 
        //ScCollection_PromiseTopayHandler objPromiseTopayHandler = new ScCollection_PromiseTopayHandler(); 
    } 
    
    static testMethod void myUnitTest1() 
    {
        //insert pl contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
        
        objPromisetoPayOld = new  collect__Promise_To_Pay__c();
        objPromisetoPayOld.collect__Loan_Account_Id__c = String.valueOf(objplcontract.id); 
        objPromisetoPayOld.collect__Promise_To_Pay_Date__c =date.today();
        objPromisetoPayOld.collect__Promise_To_Pay_Amount__c = 32732;
        objPromisetoPayOld.collect__Promise_Broken__c = true;
        objPromisetoPayOld.ScCollection_CL_Contract__c = objplcontract.id ;
         
        objPtp = new  collect__Promise_To_Pay__c();
        objPtp.collect__Promise_To_Pay_Date__c =date.today();
        objPtp.collect__Promise_To_Pay_Amount__c = 32732;
        objPtp.collect__Promise_Broken__c = false;
         
        objPromisetoPayNew = new  collect__Promise_To_Pay__c(id = objPromisetoPayOld.id);
        objPromisetoPayNew.collect__Promise_To_Pay_Amount__c = 32732; 
        
        list<collect__Promise_To_Pay__c> lstPTP = new list<collect__Promise_To_Pay__c>();
        lstPTP.add(objPromisetoPayOld);
        lstPTP.add(objPtp);
        insert lstPTP ;
        update lstPTP ;
        
        
        objPromisetoPayOld.collect__Promise_Kept__c = true;
        update objPromisetoPayOld;
        
        delete objPromisetoPayOld;
         
        //ScCollection_PromiseTopayHandler objPromiseTopayHandler = new ScCollection_PromiseTopayHandler(); 
    }        
}