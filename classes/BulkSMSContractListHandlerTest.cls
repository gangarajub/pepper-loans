@isTest(SeeAllData=false)
public class BulkSMSContractListHandlerTest{
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getActionsTest
    Company:       Saasfocus
    Description:   This method is use test getActions method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest 
    static void getActionsTest(){
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1'
                                                            );
                                                    
        insert objActioncode ;
        
        collect__Action_Code_Config__c objConfig = new collect__Action_Code_Config__c();
        objConfig.collect__Action_Code__c = objActioncode.Id;
        objConfig.collect__Source_System__c =objSourceSystem.Id;
        insert objConfig;
        
        collect__Action_Code_Config__c objCode = [Select id,collect__Source_System__r.Name,collect__Action_Code__r.Name from collect__Action_Code_Config__c where id = :objConfig.Id ];
        Test.startTest();
        List<BulkSMSContractListHandler.ActionCodeWrapper> lstResponse = BulkSMSContractListHandler.getActions('MORTGAGE');
        Test.stopTest();
        system.assert(lstResponse[0].strActionCodeName == 'Other','worked');
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getLogTemplateTest
    Company:       Saasfocus
    Description:   This method is use test getLogTemplate method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest 
    static void getLogTemplateTest(){
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        ScCollection_Log_Template__c objTemplate = new ScCollection_Log_Template__c();
        objTemplate.ScCollection_Source_System__c = objSourceSystem.Id;
        objTemplate.RecordTypeId = Schema.SObjectType.ScCollection_Log_Template__c.getRecordTypeInfosByName().get('Manual SMS').getRecordTypeId();
        objTemplate.ScCollection_Template_Name__c = 'Template 1';
        objTemplate.ScCollection_Is_Active__c = true;
        insert objTemplate;
        
        ScCollection_Log_Template__c objLogTemp = [Select id,ScCollection_Source_System__r.Name from ScCollection_Log_Template__c where id = :objTemplate.Id];
        Test.startTest();
        List<ScCollection_Log_Template__c> lstResponse = BulkSMSContractListHandler.getLogTemplate('MORTGAGE');
        Test.stopTest();
        system.assert(lstResponse[0].ScCollection_Template_Name__c == 'Template 1','worked');
    }
    
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          updateScheduleTest
    Company:       Saasfocus
    Description:   This method is use test updateSchedule and sendBulkSMS method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest 
    static void scheduleAndSendTest(){
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        collect__Loan_Account__c objLoanAccount = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        Account objAccount = new Account();
        objAccount.Name='test';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact = new Contact();
        objContact.AccountId = objAccount.Id;
        objContact.Salutation = 'Ms';
        objContact.LastName = 'Test';
        objContact.MobilePhone = '9867436729';
        objContact.HomePhone = '01207428737' ;
        insert objContact;
        
        collect__Action_Code__c objActioncode = new collect__Action_Code__c(
                                                            Name = 'Other',
                                                            ScCollection_Is_Inbound_Action__c = false,
                                                            ScCollection_Action_Code_Old_Value__c = 'Other1'
                                                            );
                                                    
        insert objActioncode ;
        
        Sms_Magic__c objCustomSetting = new Sms_Magic__c();
        objCustomSetting.senderId__c ='PepperMoney';
        objCustomSetting.Name = 'CollectionSenderId';
        insert objCustomSetting;
        
        List<BulkSMSContractListHandler.ContractListWrapper> lstWrapper = new List<BulkSMSContractListHandler.ContractListWrapper>();
        BulkSMSContractListHandler.ContractListWrapper objWrapper = new BulkSMSContractListHandler.ContractListWrapper();
        objWrapper.sendSMS = true;
        objWrapper.strRecordId = objLoanAccount.Id;
        objWrapper.strContractName = objLoanAccount.Name;
        objWrapper.strBorrower = 'Borrower';
        objWrapper.strBorrowerNo = '9999999999';
        objWrapper.strBucket = '4';
        objWrapper.strAccountID = objAccount.Id;
        objWrapper.strContactID = objContact.Id;
        lstWrapper.add(objWrapper);
        
        BulkSMSContractListHandler.ContractListWrapper objWrapper1 = new BulkSMSContractListHandler.ContractListWrapper();
        objWrapper1.sendSMS = true;
        objWrapper1.strRecordId = objLoanAccount.Id;
        objWrapper1.strContractName = objLoanAccount.Name;
        objWrapper1.strBorrower = 'Borrower';
        objWrapper1.strBorrowerNo = '9999999999';
        objWrapper1.strBucket = '4';
        objWrapper1.strAccountID = objAccount.Id;
        objWrapper1.strContactID = objContact.Id;
        lstWrapper.add(objWrapper1);
        
        String strWrapper = JSON.serialize(lstWrapper);
        
        //Success
        String str1 = BulkSMSContractListHandler.updateSchedule(strWrapper,objActioncode.Id,'2017-10-05','text sms','strScheduleName',System.Now()+4,false);
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrap = (BulkSMSCriteriaComponentController.ErrorWrapper)JSON.deserializeStrict(str1,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        system.debug(objErrorWrap);
        system.assert(objErrorWrap.message == 'SUCCESS','worked');
        
        //Error
        String str2= BulkSMSContractListHandler.updateSchedule(strWrapper,objActioncode.Id,'2017-10-05','text sms','strScheduleName',System.Now(),false);
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapErr = (BulkSMSCriteriaComponentController.ErrorWrapper)JSON.deserializeStrict(str2 ,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        system.assert(objErrorWrapErr.message.Contains('Error') == true,'worked');
        
        
        String str3 = BulkSMSContractListHandler.sendBulkSMS(strWrapper,objActioncode.Id,'2017-10-05','text sms',0);
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapSendSMS = (BulkSMSCriteriaComponentController.ErrorWrapper)JSON.deserializeStrict(str3 , BulkSMSCriteriaComponentController.ErrorWrapper.class);
        system.assert(objErrorWrapSendSMS.message == 'SUCCESS','worked');
    }
}