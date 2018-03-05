// --------------------------------------------------------------------------------------------------------
// This class handles all the trigger events on collect__Promise_To_Pay__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 9-June-2016         Created By: Deepak Dhingra        Email: deepak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// User Story   :   Global Settings: Minimum acceptable Commitment % - Custom Label and Validation Message on P2P
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestPromiseTopayHandler
// --------------------------------------------------------------------------------------------------------
public class ScCollection_PromiseTopayHandler 
{
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the After insert events on Promise to pay Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-June-2016   Created By: Kripa Sindhu Singh  Email: kripa.sindhu@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(list<collect__Promise_To_Pay__c> lstNew)
    {
        updateContractStatus(lstNew);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the After Delete events on Promise to pay Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-June-2016   Created By: Kripa Sindhu Singh  Email: kripa.sindhu@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterDelete(list<collect__Promise_To_Pay__c> lstold)
    {
        updateContractStatus(lstold);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the After update events on Promise to pay Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 10-JUN-2016    Created By: Kripa Sindhu Singh  Email: kripa.sindhu@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    // Description : this method update the count of the promise broken on the Contract setting for Contract according to the User.
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(list<collect__Promise_To_Pay__c> lstNew)
    {
        addAndUpdatecontractSetting(lstNew);
        updateContractStatus(lstNew);
    }
    
    public void addAndUpdatecontractSetting(list<collect__Promise_To_Pay__c> lstNew)
    {
        List<ScCollection_ContractSettings__c> lstCSToUpdate = new List<ScCollection_ContractSettings__c>();
        List<ScCollection_ContractSettings__c> lstCSToInsert = new List<ScCollection_ContractSettings__c>();
        List<collect__Queue_Contract__c> lstQueueContract = new List<collect__Queue_Contract__c>();
        
        Set<String> setContract = new Set<String>();
        Set<String> setContractUser = new Set<String>();
        Set<Id> setStatusIds = new Set<Id>();
        Set<Id> setUserId = new Set<Id>();
        Set<Id> setQContract = new Set<Id>();
        
        Map<String, ScCollection_ContractSettings__c> mapQUContractSetting = new Map<String, ScCollection_ContractSettings__c>();
        List<ScCollection_ContractSettings__c> lstContractSetting = new list<ScCollection_ContractSettings__c>();
        
        // Creating set of Id's which needs to be processed on contract Setting
        for(collect__Promise_To_Pay__c objPTP : lstNew)
        {
            if(objPTP.collect__Promise_Broken__c)
            {
                if(objPTP.collect__Loan_Account_Id__c != null && objPTP.collect__Loan_Account_Id__c != '')
                {
                    setContract.add(objPTP.collect__Loan_Account_Id__c);
                    setContractUser.add(objPTP.collect__Loan_Account_Id__c+'-'+objPTP.CreatedByID);
                }
                if(objPTP.collect__Dev_Contract__c != null)
                {
                    setContract.add(objPTP.collect__Dev_Contract__c);
                    setContractUser.add(objPTP.collect__Dev_Contract__c+'-'+objPTP.CreatedByID);
                }

                setStatusIds.add(objPTP.ScCollection_Contract_Status_Id__c);
            }
        }
        
        if(setContractUser != null && setContractUser.size() > 0)
        {
            mapQUContractSetting = ScCollection_CommonCodeHandler.retriveMapContractSettingsData(setContractUser);  
        }

        if((mapQUContractSetting.size() > 0 && mapQUContractSetting != null) && (setContractUser.size() > 0 && setContractUser != null))
        {
            for(String setsId: setContractUser)
            {
                ScCollection_ContractSettings__c objContractSetting = new ScCollection_ContractSettings__c();
                if(mapQUContractSetting.containsKey(setsId))
                {
                    objContractSetting = mapQUContractSetting.get(setsId);
                    
                    // Check added for checking Variable is initialized or not
                    if(objContractSetting.ScCollection_BrokenPromiseCount__c != null && objContractSetting.ScCollection_BrokenPromiseCount__c > 0)
                    {
                         objContractSetting.ScCollection_BrokenPromiseCount__c = objContractSetting.ScCollection_BrokenPromiseCount__c + 1;
                    }
                    else
                    {
                        objContractSetting.ScCollection_BrokenPromiseCount__c = 1;
                    }
                    lstCSToUpdate.add(objContractSetting);
                }
                else
                {
                    String[] Part = setsId.split('\\-');
                    
                    if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(Part[0]) == 'loan__Loan_Account__c')
                    {
                        objContractSetting.ScCollection_CLContract__c = Id.valueOf(Part[0]);
                        
                        if(Part[1] != '' && Part[1] != null)
                        {
                            objContractSetting.ScCollection_UserLookup__c = Id.valueOf(Part[1]);
                        }
                        else
                        {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'User is not present on the queue in relation with Contract, Please contact your administrator');
                            ApexPages.addMessage(myMsg);
                        }

                        objContractSetting.ScCollection_BrokenPromiseCount__c = 1;
                    }
                    else if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(Part[0]) == 'collect__Loan_Account__c')
                    {
                        objContractSetting.ScCollection_DevContract__c = Id.valueOf(Part[0]);
                        
                        if(Part[1] != '' && Part[1] != null)
                        {
                            objContractSetting.ScCollection_UserLookup__c = Id.valueOf(Part[1]);
                        }
                        else
                        {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'User is not present on the queue in relation with Contract, Please contact your administrator');
                            ApexPages.addMessage(myMsg);
                        }

                        objContractSetting.ScCollection_BrokenPromiseCount__c = 1;
                    }

                    lstCSToInsert.add(objContractSetting);
                }
            }
        }

        if(setStatusIds != Null && setStatusIds.size() > 0)
        {
            List<collect__Contract_Status__c> lstUpdateStatus = [select Id,
                                                                          ScCollection_Promise_to_Pay__c
                                                                          from collect__Contract_Status__c
                                                                          where Id IN : setStatusIds];

            if(lstUpdateStatus != Null && lstUpdateStatus.size() > 0)
            {
                for(collect__Contract_Status__c obj : lstUpdateStatus)
                {
                    obj.ScCollection_Promise_to_Pay__c = 'Broken Promise';
                }

                update lstUpdateStatus;
            }
        }

        if(lstCSToInsert.size() > 0 && lstCSToInsert != null)
        {
            Insert lstCSToInsert;
        }
        
        if(lstCSToUpdate.size() > 0 && lstCSToUpdate != null)
        {
            update lstCSToUpdate;
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to update counts on the contract status object when Promise Kept/broken
    // ---------------------------------------------------------------------------------------------------
    // created Date : 13-July-2016   Created By: Kripa Sindhu Singh    Email: kripa.sindhu@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void updateContractStatus(List<collect__Promise_To_Pay__c> lstPTP)
    {
        // Set to hold Collection Contract ID for making aggregate query on PTP
        Set<Id> setIds = new Set<Id>();
        Map<Id,Boolean> mapContractToPtp = new Map<Id,Boolean>();
        
        // List of PTP records which are retrieved from Cl and PL Contract Set
        List<AggregateResult> lstCLPTP = new List<AggregateResult>();
        List<AggregateResult> lstPLPTP = new List<AggregateResult>();
        
        // List to make Update on the contract status
        List<collect__Contract_Status__c> lstCSUpdate = new list<collect__Contract_Status__c>();
        Map<Id, wrapperforAggregate> mapContractSummary = new map<Id, wrapperforAggregate>();
        
        for(collect__Promise_To_Pay__c objPTP : lstPTP)
        {
            if(objPTP.ScCollection_CL_Contract__c != Null && objPTP.ScCollection_Contract_Status_Id__c != Null)
            {
                setIds.add(objPTP.ScCollection_CL_Contract__c);
            }
            else if(objPTP.collect__Dev_Contract__c != Null && objPTP.ScCollection_Contract_Status_Id__c != Null)
            {
                setIds.add(objPTP.collect__Dev_Contract__c);
            }
        }
        
        if(setIds != null && setIds.size() > 0)
        {
            // Retrive aggregated result for the Cl Contracts
            lstCLPTP = [Select Count(Id) PTPRecordnumber, 
                               SUM(collect__Promise_To_Pay_Amount__c) totalAmount, 
                               SUM(ScCollection_PromiseKeptN__c) KeptCount, 
                               SUM(ScCollection_PromiseBrokenN__c) BrokenCount, 
                               collect__Dev_Contract__c 
                               from collect__Promise_To_Pay__c 
                               where collect__Dev_Contract__c IN : setIds  
                               Group By collect__Dev_Contract__c];
            
            // Retrive aggregated result for the PL Contracts
            lstPLPTP = [Select Count(Id) PTPRecordnumber, 
                               SUM(collect__Promise_To_Pay_Amount__c) totalAmount, 
                               SUM(ScCollection_PromiseKeptN__c) KeptCount, 
                               SUM(ScCollection_PromiseBrokenN__c) BrokenCount, 
                               ScCollection_CL_Contract__c
                               from collect__Promise_To_Pay__c 
                               where ScCollection_CL_Contract__c IN : setIds  
                               Group By ScCollection_CL_Contract__c];
                               
            // Adding CL Aggregate to Map of contractId To PTP result
            if(lstCLPTP != null && lstCLPTP.size() > 0)
            {
                for(AggregateResult objAg : lstCLPTP)
                {
                    wrapperforAggregate objWRP = new wrapperforAggregate();
                    objWRP.ContractId = string.valueOf(objAg.get('collect__Dev_Contract__c'));
                    objWRP.TotalAmount = Decimal.valueOf(string.valueOf(objAg.get('totalAmount')));
                    objWRP.BrokenCount = Decimal.valueOf(string.valueOf(objAg.get('BrokenCount')));
                    objWRP.KeptCount = Decimal.valueOf(string.valueOf(objAg.get('KeptCount')));
                    objWRP.PTPRecordNumber = Decimal.valueOf(string.valueOf(objAg.get('PTPRecordnumber')));
                    mapContractSummary.put(Id.ValueOf(objWRP.ContractId), objWRP);
                }
            }
            
            // Adding PL Aggregate to Map Of ContractID to PTP result
            if(lstPLPTP != null && lstPLPTP.size() > 0)
            {
                for(AggregateResult objAg: lstPLPTP)
                {
                    wrapperforAggregate objWRP = new wrapperforAggregate();
                    objWRP.ContractId = String.valueOf(objAg.get('ScCollection_CL_Contract__c'));
                    objWRP.TotalAmount = Decimal.valueOf(string.valueOf(objAg.get('totalAmount')));
                    objWRP.BrokenCount = Decimal.valueOf(string.valueOf(objAg.get('BrokenCount')));
                    objWRP.KeptCount = Decimal.valueOf(string.valueOf(objAg.get('KeptCount')));
                    objWRP.PTPRecordNumber = Decimal.valueOf(string.valueOf(objAg.get('PTPRecordnumber')));
                    mapContractSummary.put(Id.ValueOf(objWRP.ContractId), objWRP);
                }
            }
            
            for(collect__Loan_Account__c objcnt : [select Id, (select Id from collect__Promise_To_Pay__r where collect__Promise_Kept__c != true AND collect__Promise_Broken__c != true) from collect__Loan_Account__c where Id IN : setIds])
            {    
                if(objcnt.collect__Promise_To_Pay__r != Null && objcnt.collect__Promise_To_Pay__r.size() > 0)
                {
                    mapContractToPtp.put(objcnt.Id,True);
                }
                else
                {
                    mapContractToPtp.put(objcnt.Id,False);
                }
            } 
            
            for(loan__Loan_Account__c objcnt : [select Id, (select Id from Promise_To_Pay__r where collect__Promise_Kept__c != true AND collect__Promise_Broken__c != true) from loan__Loan_Account__c where Id IN : setIds])
            {    
                if(objcnt.Promise_To_Pay__r != Null && objcnt.Promise_To_Pay__r.size() > 0)
                {
                    mapContractToPtp.put(objcnt.Id,True);
                }
                else
                {
                    mapContractToPtp.put(objcnt.Id,False);
                }
            }    
        }
        
        Set<Id> setContractId = new Set<Id>();
        
        for(collect__Promise_To_Pay__c objPTP : lstPTP)
        {
            if(objPTP.ScCollection_CL_Contract__c != Null && objPTP.ScCollection_Contract_Status_Id__c != Null)
            {
                if(!setContractId.contains(objPTP.ScCollection_CL_Contract__c))
                {
                    collect__Contract_Status__c objCS = new collect__Contract_Status__c(Id = objPTP.ScCollection_Contract_Status_Id__c);
                    
                    if(mapContractSummary.containsKey(objPTP.ScCollection_CL_Contract__c) && mapContractSummary.get(objPTP.ScCollection_CL_Contract__c) != Null)
                    {
                        //Creating Aggregate object to update the Contract Status
                        if(Trigger.isInsert)
                        {
                            objCS.ScCollection_Promise_to_Pay__c = 'PTP';
                        }
                        else if(Trigger.IsUpdate && objPTP.collect__Promise_Kept__c)
                        {
                            if(mapContractToPtp.containsKey(objPTP.ScCollection_CL_Contract__c) && mapContractToPtp.get(objPTP.ScCollection_CL_Contract__c) != True)
                            {
                                objCS.ScCollection_Promise_to_Pay__c = '';
                            }
                        }
                        else if(Trigger.IsDelete)
                        {
                            if(mapContractToPtp.containsKey(objPTP.ScCollection_CL_Contract__c) && mapContractToPtp.get(objPTP.ScCollection_CL_Contract__c) != True)
                            {
                                objCS.ScCollection_Promise_to_Pay__c = '';
                            }
                        }
                        objCS.ScCollection_PromiseToPayAmount__c = mapContractSummary.get(objPTP.ScCollection_CL_Contract__c).totalAmount;
                        objCS.ScCollection_CountPromiseBroken__c = mapContractSummary.get(objPTP.ScCollection_CL_Contract__c).BrokenCount;
                        objCS.ScCollection_CountPromiseKept__c = mapContractSummary.get(objPTP.ScCollection_CL_Contract__c).KeptCount;
                        objCS.ScCollection_NumberofPromiseTaken__c = mapContractSummary.get(objPTP.ScCollection_CL_Contract__c).PTPRecordnumber;
                        lstCSUpdate.add(objCS);
                        setContractId.add(objPTP.ScCollection_CL_Contract__c);
                    }
                    else
                    {
                        //Creating Aggregate object to update the Contract Status
                        objCS.ScCollection_Promise_to_Pay__c = Null;
                        objCS.ScCollection_PromiseToPayAmount__c = 0;
                        objCS.ScCollection_CountPromiseBroken__c = 0;
                        objCS.ScCollection_CountPromiseKept__c = 0;
                        objCS.ScCollection_NumberofPromiseTaken__c = 0;
                        lstCSUpdate.add(objCS);
                        setContractId.add(objPTP.ScCollection_CL_Contract__c);
                    }
                }
            }
            else if(objPTP.collect__Dev_Contract__c != Null && objPTP.ScCollection_Contract_Status_Id__c != Null)
            {
                if(!setContractId.contains(objPTP.collect__Dev_Contract__c))
                {
                    collect__Contract_Status__c objCS = new collect__Contract_Status__c(Id = objPTP.ScCollection_Contract_Status_Id__c);
                    
                    if(mapContractSummary.containsKey(objPTP.collect__Dev_Contract__c) && mapContractSummary.get(objPTP.collect__Dev_Contract__c) != Null)
                    {
                        //Creating Aggregate object to update the Contract Status
                        if(Trigger.isInsert)
                        {
                            objCS.ScCollection_Promise_to_Pay__c = 'PTP';
                        }
                        else if(Trigger.IsUpdate && objPTP.collect__Promise_Kept__c)
                        {
                            if(mapContractToPtp.containsKey(objPTP.collect__Dev_Contract__c) && mapContractToPtp.get(objPTP.collect__Dev_Contract__c) != True)
                            {
                                objCS.ScCollection_Promise_to_Pay__c = '';
                            }
                        }
                        else if(Trigger.IsDelete)
                        {
                            if(mapContractToPtp.containsKey(objPTP.collect__Dev_Contract__c) && mapContractToPtp.get(objPTP.collect__Dev_Contract__c) != True)
                            {
                                objCS.ScCollection_Promise_to_Pay__c = '';
                            }
                        }
                        
                        objCS.ScCollection_PromiseToPayAmount__c = mapContractSummary.get(objPTP.collect__Dev_Contract__c).totalAmount;
                        objCS.ScCollection_CountPromiseBroken__c = mapContractSummary.get(objPTP.collect__Dev_Contract__c).BrokenCount;
                        objCS.ScCollection_CountPromiseKept__c = mapContractSummary.get(objPTP.collect__Dev_Contract__c).KeptCount;
                        objCS.ScCollection_NumberofPromiseTaken__c = mapContractSummary.get(objPTP.collect__Dev_Contract__c).PTPRecordnumber;
                        lstCSUpdate.add(objCS);
                        setContractId.add(objPTP.collect__Dev_Contract__c);
                    }
                    else
                    {
                        //Creating Aggregate object to update the Contract Status
                        objCS.ScCollection_Promise_to_Pay__c = Null;
                        objCS.ScCollection_PromiseToPayAmount__c = 0;
                        objCS.ScCollection_CountPromiseBroken__c = 0;
                        objCS.ScCollection_CountPromiseKept__c = 0;
                        objCS.ScCollection_NumberofPromiseTaken__c = 0;
                        lstCSUpdate.add(objCS);
                        setContractId.add(objPTP.collect__Dev_Contract__c);
                    }
                }
            }
        }
        
        // Call to update Contract Status values
        if(lstCSUpdate != null && lstCSUpdate.size() > 0)
        {
            try
            {
                update lstCSUpdate;
            }
            catch(Exception e)
            {
                system.debug('Failure During Contract Status Update : '+e.getMessage());
            }
        }
    }
    
    // Added wrapper Class to hold Data from Aggregate Result which is Comming from updateContractStatus added 14-july-2016
    public class wrapperforAggregate
    {
        public String ContractId {get; set;}
        public Decimal TotalAmount {get; set;}
        public Decimal BrokenCount {get; set;}
        public Decimal keptCount {get; set;}
        public Decimal PTPRecordNumber {get; set;}  
    }
}