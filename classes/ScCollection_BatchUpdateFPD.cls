//  -------------------------------------------------------------------------------------------------------
//  This class would look for contracts that have passed their First Payment Due date after the tolerance 
//  period and no payments have been made against them with the due first payment amount
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 03-OCT-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestBatchUpdateFPD
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_BatchUpdateFPD implements Database.Batchable<sObject>
{    
    String QUERY ;
    Date PDP_Date ;                     
    Integer toleRanceDays;
    global ScCollection_BatchUpdateFPD(Date executionDate,String sourceSystem) 
    {
        Query = 'select id from  collect__Loan_Account__c where createddate = Null';    
        
        // if we have the date
        if(executionDate != NUll && String.isNotEmpty(sourceSystem))
        {
            // if the date is not Null Query the source System and fetch the tolerance days
            List<collect__Source_System__c> listSourceSystem = [select 
                                                                Name,
                                                                collect__Tolerance_Days__c
                                                                from collect__Source_System__c
                                                                where Name =: sourceSystem];

            // if we have some source System                                                    
            If(listSourceSystem != Null && listSourceSystem.size() > 0)
            {    
                toleRanceDays = 0;
                toleRanceDays = (Integer)listSourceSystem[0].collect__Tolerance_Days__c;
                
                // if we have some tolerance days
                if(toleRanceDays != Null )
                {
                    PDP_Date = executionDate.addDays(-(toleRanceDays+1));
                    QUERY = 'select id,collect__Collection_Status__c,ScCollection_First_Payment_Due_Amount__c,ScCollection_First_Payment_Due_Date__c,ScCollection_Settled_Date__c from collect__Loan_Account__c where ScCollection_First_Payment_Due_Date__c != Null and ScCollection_First_Payment_Due_Date__c > 2016-09-01 and ScCollection_First_Payment_Due_Date__c <=:PDP_Date and collect__Collection_Status__c != Null';
                }
            }
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {    
        List<collect__Contract_Status__c> updateContractStatus = new List<collect__Contract_Status__c>();
        map<Id, List<collect__Loan_Payment_Transaction__c>> mapConIdLstPayTrans = new map<Id, List<collect__Loan_Payment_Transaction__c>>();
        
        List<collect__Loan_Account__c> lstEligibleAccounts = (List<collect__Loan_Account__c>)scope;
        Date paymentEndDateEndInstance = system.today().addDays(-1);
        
        if(lstEligibleAccounts != null){
            For(collect__Loan_Payment_Transaction__c pt : [Select id,collect__Transaction_Amount__c,
                                                            collect__Transaction_Date__c,collect__Dev_Contract__c
                                                            from collect__Loan_Payment_Transaction__c 
                                                            where collect__Dev_Contract__c IN: lstEligibleAccounts
                                                            and collect__Transaction_Date__c <= :paymentEndDateEndInstance 
                                                            and collect__Cleared__c = true and collect__Reversed__c = false])
            {
                                                                           
                if(mapConIdLstPayTrans.get(pt.collect__Dev_Contract__c) == null){
                    mapConIdLstPayTrans.put(pt.collect__Dev_Contract__c, new List<collect__Loan_Payment_Transaction__c>());
                }
                mapConIdLstPayTrans.get(pt.collect__Dev_Contract__c).add(pt);
            }
        }
        system.debug('mapConIdLstPayTrans@@@@@'+mapConIdLstPayTrans);
        
        // iterate over the accounts 
        for(collect__Loan_Account__c tempAccount:lstEligibleAccounts)
        {
            // if we have transactions
            Date StartDt = tempAccount.ScCollection_Settled_Date__c;
            Date EndDt = tempAccount.ScCollection_First_Payment_Due_Date__c.addDays(toleRanceDays);
            
            if(mapConIdLstPayTrans != null && mapConIdLstPayTrans.get(tempAccount.Id) != null)
            {
                Decimal tempAmount = 0;
                for(collect__Loan_Payment_Transaction__c tempTransaction : mapConIdLstPayTrans.get(tempAccount.Id))
                {
                    if(tempTransaction.collect__Transaction_Date__c >= StartDt
                        && tempTransaction.collect__Transaction_Date__c <= EndDt){
                        if(tempTransaction.collect__Transaction_Amount__c != Null) 
                        {
                            tempAmount = (tempAmount + tempTransaction.collect__Transaction_Amount__c);
                        }
                    }
                }
                
                // if the total amount is less
                if(tempAccount.ScCollection_First_Payment_Due_Amount__c > tempAmount)
                {
                    // add contract status to update
                    updateContractStatus.add(new collect__Contract_Status__c(id=tempAccount.collect__Collection_Status__c,ScCollection_First_Payment_Default_Date__c=System.today(),ScCollection_First_Payment_Default__c = true,ScCollection_Arrears__c = 'First Payment Default'));
                }
            }
            else 
            {
                // no payment has been made 
                updateContractStatus.add(new collect__Contract_Status__c(id=tempAccount.collect__Collection_Status__c,ScCollection_First_Payment_Default_Date__c=System.today(),ScCollection_First_Payment_Default__c = true,ScCollection_Arrears__c = 'First Payment Default'));
            }
        }

        // if we have some Contract Status
        if(updateContractStatus.size() > 0) 
        {
            List<Database.SaveResult> VarSaveResult =  Database.update(updateContractStatus,false);
        } 
    }
    
    global void finish(Database.BatchableContext BC) 
    {
        
    }
}