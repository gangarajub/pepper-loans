/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          BulkSMSBatch 
Company:       Saasfocus
Description:   This is the batch class which is use to send the SMS to the user.
History
Date    :  24/09/2017     
------------------------------------------------------------*/
public class BulkSMSBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{

    public final String Query;
    public String clContract = 'collect__Loan_Account__c';
    
    //constructor
    public BulkSMSBatch(String jobId){

        Query='Select ScCollection_Action_Code_Id__c ,ScCollection_Job_Id__c ,ScCollection_Review_Date__c ,ScCollection_SMS_Text__c ,ScCollection_Contract_Id_s__c From ScCollection_Bulk_Scheduled_SMS__c where ScCollection_Job_Id__c =\'' + jobId + '\' Limit 1'; 

    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          start
    Company:       Saasfocus
    Description:   This is the start method use to return result based on the query.
    Inputs:        Database.BatchableContext
    Returns:       Database.QueryLocator
    -----------------------------------------------------------------------------------*/
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          execute
    Company:       Saasfocus
    Description:   This method is use to process the query records and create the 
                    wrapper and calls the generic method to sends the SMS.
    Inputs:        Database.BatchableContext,List<sObject>
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<ScCollection_Bulk_Scheduled_SMS__c> lstBulkSMS = (List<ScCollection_Bulk_Scheduled_SMS__c>)scope;
        
        if(lstBulkSMS != null && lstBulkSMS.Size() > 0){
            
            try{
                
                set<String> setContractId = new set<String>();
                for(ScCollection_Bulk_Scheduled_SMS__c objSchedule : lstBulkSMS){
                    if(!String.IsBlank(objSchedule.ScCollection_Contract_Id_s__c)){
                        List<String> lstContractIds = objSchedule.ScCollection_Contract_Id_s__c.Split('\\,');
                        for(String contractIds : lstContractIds){
                            setContractId.add(contractIds);
                        }
                    }       
                }
                
                if(setContractId != null && setContractId.Size() > 0){
                    
                    List<BulkSMSContractListHandler.ContractListWrapper> lstWrapper = new List<BulkSMSContractListHandler.ContractListWrapper>();
                    
                    String strContractId = (new List<String>(setContractId)[0]);
                    String sObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId );
                    if(sObjectName == clContract){
                        List<collect__Loan_Account__c> lstClContract = [Select Id,Name,collect__Collection_Status__r.ScCollection_Primary_Borrower_Name__c,collect__Collection_Status__r.ScCollection_Primary_Borrower_Mobile_No__c,collect__Collection_Status__r.ScCollection_Account__c,collect__Collection_Status__r.ScCollection_Contact__c,ScCollection_Bucket__c From collect__Loan_Account__c Where Id In : setContractId];
                        
                        for(collect__Loan_Account__c  objLoanAccnt : lstClContract){
                            BulkSMSContractListHandler.ContractListWrapper objContractWrapper = new BulkSMSContractListHandler.ContractListWrapper();
                            objContractWrapper.strContractName  = objLoanAccnt.Name;
                            objContractWrapper.strRecordId = objLoanAccnt.Id;
                            objContractWrapper.strAccountID = objLoanAccnt.collect__Collection_Status__r.ScCollection_Account__c;
                            objContractWrapper.strBorrowerNo = objLoanAccnt.collect__Collection_Status__r.ScCollection_Primary_Borrower_Mobile_No__c;
                            objContractWrapper.strBorrower = objLoanAccnt.collect__Collection_Status__r.ScCollection_Primary_Borrower_Name__c;
                            objContractWrapper.strContactID = objLoanAccnt.collect__Collection_Status__r.ScCollection_Contact__c;
                            objContractWrapper.sendSMS = true;
                            lstWrapper.add(objContractWrapper);
                        }
                    }
                    else{
                        List<loan__Loan_Account__c> lstPlContracts = [Select Id,Name,loan__Account__r.Name,loan__Account__r.PersonMobilePhone,loan__Account__c From loan__Loan_Account__c Where Id in : setContractId];
                        
                        for(loan__Loan_Account__c objLoanAccnt : lstPlContracts){
                            BulkSMSContractListHandler.ContractListWrapper objContractWrapper = new BulkSMSContractListHandler.ContractListWrapper();
                            objContractWrapper.strContractName  = objLoanAccnt.Name;
                            objContractWrapper.strRecordId = objLoanAccnt.Id;
                            objContractWrapper.strAccountID = objLoanAccnt.loan__Account__c;
                            objContractWrapper.strBorrowerNo = objLoanAccnt.loan__Account__r.PersonMobilePhone;
                            objContractWrapper.strBorrower = objLoanAccnt.loan__Account__r.Name;
                            objContractWrapper.sendSMS = true;
                            lstWrapper.add(objContractWrapper);
                        }
                    }
                    if(lstWrapper != null && lstWrapper.Size() > 0){
                        String strListContract = JSON.serialize(lstWrapper);
                        
                        //this method is use to send the SMS to the user and create the delivery detail to track the send SMS on ICM.
                        String strResponse = BulkSMSContractListHandler.sendBulkSMS(strListContract,lstBulkSMS[0].ScCollection_Action_Code_Id__c,String.ValueOf(lstBulkSMS[0].ScCollection_Review_Date__c),lstBulkSMS[0].ScCollection_SMS_Text__c,1);
                        
                        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper = (BulkSMSCriteriaComponentController.ErrorWrapper)JSON.deserialize(strResponse,BulkSMSCriteriaComponentController.ErrorWrapper.class);
                        
                        ScCollection_Bulk_Scheduled_SMS__c objBulkScheduleSms = lstBulkSMS[0];
                        if(objErrorWrapper != null && objErrorWrapper.isError){
                            objBulkScheduleSms.ScCollection_Error_Message__c = objErrorWrapper.message;
                            objBulkScheduleSms.ScCollection_IsSuccess__c = false;
                        }
                        else{
                            objBulkScheduleSms.ScCollection_Error_Message__c = '';
                            objBulkScheduleSms.ScCollection_IsSuccess__c = true;
                        }
                        update objBulkScheduleSms;
                    }
                }
            }
            catch(exception ex){
                ScCollection_Bulk_Scheduled_SMS__c objBulkScheduleSms = lstBulkSMS[0];
                objBulkScheduleSms.ScCollection_Error_Message__c = ex.getMessage();
                objBulkScheduleSms.ScCollection_IsSuccess__c = false;
                update objBulkScheduleSms;
            }
        }
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          finish
    Company:       Saasfocus
    Description:   This is the finish method.
    Inputs:        Database.BatchableContext
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public void finish(Database.BatchableContext BC){
        
    }
}