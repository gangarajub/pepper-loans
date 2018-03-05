// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CnslRightComponentHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestCnslRightComponentHand 
{
    static testMethod void CollectLoanAccountTest() 
    {
        collect__Contract_Status__c objContractStatus = new collect__Contract_Status__c();
        objContractStatus.ScCollection_default_Notice_Issue_Date__c = System.today()-1;
        insert objContractStatus ;
          
        collect__Contract_Status__History objContractHistory = new collect__Contract_Status__History(parentid=objContractStatus.id,field='ScCollection_default_Notice_Issue_Date__c');          
        insert objContractHistory ;
        
        //insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');

        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.ScCollection_Next_Installment_Date__c = date.today().addDays(10);
        objContract.collect__Collection_Status__c = objContractStatus.id;
        objContract.ScCollection_Arrears__c = 2000;
        objContract.collect__Last_Payment_Date__c = System.today()+2;
        update objContract;
          
        collect__Loan_Account__History objHistory = new collect__Loan_Account__History(parentid = objContract .id, field = 'collect__Last_Payment_Date__c');
        insert objHistory;
        
        ScCollection_ContractSettings__c objContractSetting = new ScCollection_ContractSettings__c();
        objContractSetting.ScCollection_DevContract__c = objContract.id;
        objContractSetting.ScCollection_UserLookup__c = UserInfo.getUserId();
        insert objContractSetting;
          
        collect__Queue__c objQue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');

        collect__Queue_Contract__c objQueueContract = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.Id, objContract.Id, UserInfo.getUserId());
          
        dateTime sendDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        String strTypeNotification= 'Test Notification'; 
        String message ='Test Message';
         
        ApexPages.currentPage().getParameters().put('Id',objContract.id);
      //  ScCollection_CnslRightComponentHandler.wrapperForNotification objwrapper = new ScCollection_CnslRightComponentHandler.wrapperForNotification(sendDate,strTypeNotification,message);          
        ScCollection_CnslRightComponentHandler  objCnslRightComponentHandler = new ScCollection_CnslRightComponentHandler();
    }
        
    static testMethod void loanAccountTest() 
    {
        //Creating loan account
        loan__loan_account__c  objloanAccount = new loan__loan_account__c();
        objloanAccount = pepCommonTrackerController.createLoanAccount();
        objloanAccount.loan__ACH_Next_Debit_Date__c = System.today();
        update objloanAccount;
        
        //Creating loan account history       
        loan__loan_account__history objLoanAccountHistory = new loan__loan_account__history(ParentId = objloanaccount.id,Field = 'loan__ACH_Next_Debit_Date__c');
        insert objLoanAccountHistory; 
          
        objloanAccount.loan__ACH_Next_Debit_Date__c=System.today()+1;
        update objloanAccount;
          
        loan__loan_account__history objLoanAccountHistory1 = new loan__loan_account__history(ParentId = objloanaccount.id,Field = 'loan__ACH_Next_Debit_Date__c');
        insert objLoanAccountHistory1; 
          
        ScCollection_ContractSettings__c objContractSetting = new ScCollection_ContractSettings__c();
        objContractSetting.ScCollection_CLContract__c = objloanAccount.id;
        objContractSetting.ScCollection_UserLookup__c = UserInfo.getUserId();
        insert objContractSetting;
          
        collect__Interaction_Log__c objInteractionLog = new collect__Interaction_Log__c();
        objInteractionLog.collect__Loan_Account_Id__c = objloanAccount.id;
        objInteractionLog.collect__Follow_Up_Date_Time__c = System.Now();
        objInteractionLog.collect__Description__c = 'Test Log Comments';
        objInteractionLog.ScCollection_CL_Contract__c = objloanAccount.id;
        insert objInteractionLog;
          
        collect__Queue__c objQue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
          
        collect__Queue_Contract__c objQueueContract = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.Id, objloanAccount.Id, UserInfo.getUserId());
          
        collect__Queue_Contract__history objQueuehistory = new collect__Queue_Contract__history(parentid = objQueueContract.id,field = 'collect__Status__c');
        insert objQueuehistory;
          
        collect__Queue_Contract__c objQueueContract1 = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.Id, objloanAccount.Id, UserInfo.getUserId());
        objQueueContract1.collect__Status__c ='Closed';
        update objQueueContract1;
          
        collect__Queue_Contract__history objQueuehistory1 = new collect__Queue_Contract__history(parentid = objQueueContract.id,field = 'collect__Status__c');
        insert objQueuehistory1;
          
        collect__Queue_Contract__c objQueueContract2 = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.Id, objloanAccount.Id, UserInfo.getUserId());
        objQueueContract2.collect__Status__c ='Closed';
        update objQueueContract2;
          
        collect__Queue_Contract__history objQueuehistory2 = new collect__Queue_Contract__history(parentid = objQueueContract.id,field = 'collect__Status__c');
        insert objQueuehistory2 ;
          
        ApexPages.currentPage().getParameters().put('Id',objloanAccount.id);
        ScCollection_CnslRightComponentHandler objCnslRightComponentHandler = new ScCollection_CnslRightComponentHandler();
        objCnslRightComponentHandler.strLogIndex = '0';
        objCnslRightComponentHandler.DeleteLog();

        cnotify__Configuration__c objconfig = new cnotify__Configuration__c();
        objconfig.cnotify__Text_Notification__c = true;
        objconfig.cnotify__Text_Message__c = 'Test Message';
        insert objconfig;

        cnotify__Notification__c objnotify = new cnotify__Notification__c();
        objnotify.cnotify__Configuration__c = objconfig.Id;
        insert objnotify;

       // objCnslRightComponentHandler.mapNotificationResponse.put(objloanAccount.Id, new List<cnotify__Notification__c>{objnotify});
        //objCnslRightComponentHandler.populateNotifications();
    }    
}