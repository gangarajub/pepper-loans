// --------------------------------------------------------------------------------------------------------
// This class handles the logic for the custom vf pages on console view for displaying Collector Report.
// --------------------------------------------------------------------------------------------------------
// Created Date: 17-Nov-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
//Test Class : ScCollection_TestCollectorReportHandler
// --------------------------------------------------------------------------------------------------------
public class ScCollection_CollectorReportHandler
{
    //variable declaration for the search data to be binded on page.
    public Task objStartDate {get;set;}
    public Task objEndDate {get;set;}
    public Task objPtpStartDate {get;set;}
    public Task objPtpEndDate {get;set;}
    public Task objPtpStartDateFilter {get;set;}
    public Task objPtpEndDateFilter {get;set;}
        
    public static List<wrapperForContractList> lstContracts;
    public static List<wrapperForContractDetail> lstContractDetail;
    public static List<wrapperForPTPList> lstPromiseToPay;
    public static List<wrapperForPTPDetail> lstPromiseToPayDetail;
    
    public Map<Id,String> mapQueueUsersList {get;set;}
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    
    public static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
    public static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    
    //wrapper to hold info about all contracts for a particular queue
    public class wrapperForContractList
    {
        public String strUserName;
        public Set<Id> setQueueAccountsAssigned;
        public Set<Id> setQueueAccountsActioned;
        public Set<Id> setInboundAccountsActioned;
        public Set<Id> setOtherAccountsActioned;
        public Set<Id> setTotalAccountsActioned;
        public Set<Id> setRightPartyContacts;
        public Set<Id> setPromisesTakenCount;
        public Set<String> setPromisesTakenCountAgainstParent;
        public Set<Id> setRPCNoPromises;
        public Decimal PromisesTakenAmount;        
        public Decimal PromisesLoanBalance;        
        
        public wrapperForContractList()
        {
            strUserName = '';
            setQueueAccountsAssigned = new Set<Id>();
            setQueueAccountsActioned = new Set<Id>();
            setInboundAccountsActioned = new Set<Id>();
            setOtherAccountsActioned = new Set<Id>();
            setTotalAccountsActioned = new Set<Id>();
            setRightPartyContacts = new Set<Id>();
            setPromisesTakenCount = new Set<Id>();
            setPromisesTakenCountAgainstParent = new Set<String>();
            setRPCNoPromises = new Set<Id>();
            PromisesTakenAmount = 0.00;
            PromisesLoanBalance = 0.00;
        }
    }
    
    //wrapper to hold info about all contracts for a particular queue
    public class wrapperForContractDetail
    {
        public String strContractId;
        public String strContractNo;
        public String strCustomerName;
        public String strDueDate;
        public Decimal ArrearAmount;      
        public Decimal BalanceAmount;     
        public String strBucket;
        public String strStatus;
        
        public wrapperForContractDetail()
        {
            strContractId = '';
            strContractNo = '';
            strCustomerName = '';
            strDueDate = '';
            ArrearAmount = 0.00;
            BalanceAmount = 0.00;
            strBucket = '';
            strStatus = '';
        }
    }
    
    //wrapper to hold info about all promise to pay
    public class wrapperForPTPList
    {
        public String strUserName;
        public Set<Id> setPromisesTakenCount;
        public Decimal PromisesTakenAmount;
        public Decimal PromisesTakenBalance;
        public Set<Id> setPromisesKeptCount;
        public Decimal PromisesKeptAmount;
        public Decimal PromisesKeptBalance;
        public Set<Id> setPromisesBrokenCount;
        public Decimal PromisesBrokenAmount;
        public Decimal PromisesBrokenBalance;
        
        public wrapperForPTPList()
        {
            strUserName = '';
            setPromisesTakenCount = new Set<Id>();
            PromisesTakenAmount = 0.00;
            PromisesTakenBalance = 0.00;
            setPromisesKeptCount = new Set<Id>();
            PromisesKeptAmount = 0.00;
            PromisesKeptBalance = 0.00;
            setPromisesBrokenCount = new Set<Id>();
            PromisesBrokenAmount = 0.00;
            PromisesBrokenBalance = 0.00;
        }
    }
    
    //wrapper to hold detailed info about all promise to pay
    public class wrapperForPTPDetail
    {
        public String strContractId;
        public String strContractNo;
        public String strCustomerName;
        public Decimal strPtpAmount;
        public String strPtpDate;
        public String strSPV;
        public String strBucket;
        public Decimal strBalance;
        
        public wrapperForPTPDetail()
        {
            strContractId = '';
            strContractNo = '';
            strCustomerName = '';
            strPtpAmount = 0.00;
            strPtpDate = '';
            strSPV = '';
            strBucket = '';
            strBalance = 0.00;
        }
    }
    
    //constructor definition        
    public ScCollection_CollectorReportHandler()
    {
        //variable initialization
        objStartDate = new Task();
        objEndDate = new Task();
        objPtpStartDate = new Task();
        objPtpEndDate = new Task();
        objPtpStartDateFilter = new Task();
        objPtpEndDateFilter = new Task();
        
        mapQueueUsersList = new Map<Id,String>();
        
        Set<Id> setUserId = new Set<Id>();
        
        for(collect__Queue_User__c ObjQuser : [Select collect__User__c, collect__User__r.Name from collect__Queue_User__c ORDER BY collect__User__r.Name])
        {
            if(!setUserId.contains(objQuser.collect__User__c))
            {
                mapQueueUsersList.put(ObjQuser.collect__User__c, ObjQuser.collect__User__r.Name);
                setUserId.add(objQuser.collect__User__c);
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to return the records of contractlistwrapper on the basis of search
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 17-Nov-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    @RemoteAction
    public static List<wrapperForContractList> getSearchResults(String UserIds, String StartDate, String EndDate)
    {
        lstContracts = new List<wrapperForContractList>();
        Set<Id> setUserId = new Set<Id>();
        Map<Id,String> mapUserIdToName = new Map<Id,String>();
        Map<Id,Set<Id>> mapQueueAccountsAssigned = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapQueueAccountsActioned = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapInboundAccountsActioned = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapOtherAccountsActioned = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapTotalAccountsActioned = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapRightPartyContacts = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapPromisesTakenCount = new Map<Id,Set<Id>>();
        Map<Id,Set<String>> mapPromiseTakenParentCount = new Map<Id,Set<String>>();
        Map<Id,Set<String>> mapPromisesTakenCountForRpc = new Map<Id,Set<String>>();
        Map<Id,Set<Id>> mapRPCNoPromises = new Map<Id,Set<Id>>();
        Map<Id,Decimal> mapPromisesTakenAmount = new Map<Id,Decimal>();
        Map<Id,Decimal> mapPromisesLoanBalance = new Map<Id,Decimal>();
        Map<String, Id> mapConExtIdConSFId = new Map<String, Id>();
                
        String strAsgQuery = '';
        String strLogQuery = '';
        String strPtpQuery = '';
        String strUserQuery = '';
        
        if(String.isNotEmpty(StartDate) && String.isNotEmpty(EndDate) && String.isNotEmpty(UserIds))
        {
            strAsgQuery = 'select Id, ScCollection_User__c, ScCollection_User__r.Name, ScCollection_Contract_Ids__c from ScCollection_User_Assignment__c where ScCollection_Review_Date__c >= ' + FormatDate(StartDate) + ' AND ScCollection_Review_Date__c <= ' + FormatDate(EndDate);
            strLogQuery = 'select Id, collect__Dev_Contract__c, collect__Dev_Contract__r.collect__External_ID__c, ScCollection_CL_Contract__c, collect__Action__r.ScCollection_Considered_Contact__c, collect__Action__r.ScCollection_Is_Inbound_Action__c, CreatedById from collect__Interaction_Log__c where ScCollection_Created_Date__c >= ' + FormatDate(StartDate) + ' AND ScCollection_Created_Date__c <= ' + FormatDate(EndDate);
            strPtpQuery = 'select Id, ScCollection_Contract_Id__c, ScCollection_Contract_External_Id__c, collect__Arrangement_Amount__c, ScCollection_Contract_Balance__c, CreatedById from collect__Payment_Arrangement__c where ScCollection_Created_Date__c >= ' + FormatDate(StartDate) + ' AND ScCollection_Created_Date__c <= ' + FormatDate(EndDate);
            
            if(UserIds != 'All')
            {
                strAsgQuery += ' AND ScCollection_User__c IN(' + UserIds + ')';
                strLogQuery += ' AND CreatedById IN(' + UserIds + ')';
                strPtpQuery += ' AND CreatedById IN(' + UserIds + ')';
                strUserQuery += ' Select Id, Name from User where Id IN(' + UserIds + ')';
            }
            
            
            if(ScCollection_UtilityHandler.isNotNull(strUserQuery))
            {
                List<User> lstUser = Database.Query(strUserQuery);
                
                if(ScCollection_UtilityHandler.isNotNull(lstUser))
                {
                    for(User u : lstUser)
                    {
                        setUserId.add(u.Id);
                        mapUserIdToName.put(u.Id, u.Name);
                    }
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(strAsgQuery))
            {
                List<ScCollection_User_Assignment__c> lstasg = Database.Query(strAsgQuery);
                
                if(ScCollection_UtilityHandler.isNotNull(lstasg))
                {
                    for(ScCollection_User_Assignment__c objasg : lstasg)
                    {
                        Set<Id> setContractId = new Set<Id>();
                        
                        if(mapQueueAccountsAssigned.containsKey(objasg.ScCollection_User__c) && mapQueueAccountsAssigned.get(objasg.ScCollection_User__c) != Null)
                        {
                            setContractId.addAll(mapQueueAccountsAssigned.get(objasg.ScCollection_User__c));    
                        }
                        
                        if(objasg.ScCollection_Contract_Ids__c != Null)
                        {
                            List<String> lstIds = objasg.ScCollection_Contract_Ids__c.split(',');
                            
                            if(ScCollection_UtilityHandler.isNotNull(lstIds))
                            {
                                for(String objid : lstIds)
                                {
                                    setContractId.add(objid);
                                }
                                
                                mapQueueAccountsAssigned.put(objasg.ScCollection_User__c,setContractId);
                            }   
                        }
                    }
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(strPtpQuery))
            {
                List<collect__Payment_Arrangement__c> lstptp = Database.Query(strPtpQuery);
                
                if(ScCollection_UtilityHandler.isNotNull(lstptp))
                {
                    Set<String> setContracts = new Set<String>();
                    
                    for(collect__Payment_Arrangement__c objptp : lstptp)
                    {
                        Set<Id> setPtpContracts = new Set<Id>();
                        Set<String> setConExtId = new Set<String>();
                        Set<String> setPtpContractsForRpc = new Set<String>();
                        Decimal PtpAmount = 0.00;
                        Decimal PtpLoanBalance = 0.00;
                        
                        if(mapPromisesTakenCount.containsKey(objptp.CreatedById) && mapPromisesTakenCount.get(objptp.CreatedById) != Null)
                        {
                            setPtpContracts.addAll(mapPromisesTakenCount.get(objptp.CreatedById));    
                        }
                        
                        setPtpContracts.add(objptp.ScCollection_Contract_Id__c);
                        mapPromisesTakenCount.put(objptp.CreatedById,setPtpContracts);
                        
                        if(objptp.ScCollection_Contract_External_Id__c != Null)
                        {
                            if(mapPromiseTakenParentCount.containsKey(objptp.CreatedById) && mapPromiseTakenParentCount.get(objptp.CreatedById) != Null)
                            {
                                setConExtId.addAll(mapPromiseTakenParentCount.get(objptp.CreatedById));    
                            }
                            if(objptp.ScCollection_Contract_External_Id__c.contains('_'))
                            {
                                setConExtId.add(objptp.ScCollection_Contract_External_Id__c.split('_')[0]);
                                mapPromiseTakenParentCount.put(objptp.CreatedById, setConExtId);
                            }
                            else{
                                setConExtId.add(objptp.ScCollection_Contract_External_Id__c);
                                mapPromiseTakenParentCount.put(objptp.CreatedById, setConExtId);
                            }
                            
                            if(mapPromisesTakenCountForRpc.containsKey(objptp.CreatedById) && mapPromisesTakenCountForRpc.get(objptp.CreatedById) != Null)
                            {
                                setPtpContractsForRpc.addAll(mapPromisesTakenCountForRpc.get(objptp.CreatedById));    
                            }
                            
                            if(objptp.ScCollection_Contract_External_Id__c.contains('_'))
                            {
                                String extid = objptp.ScCollection_Contract_External_Id__c;
                                List<String> lststr = extid.split('_');
                                
                                if(lststr.size() > 1 && lststr[1] != Null && lststr[1] != '0')
                                {
                                    extid = lststr[0] + '_0';
                                }
                                
                                setPtpContractsForRpc.add(extid);
                                mapPromisesTakenCountForRpc.put(objptp.CreatedById,setPtpContractsForRpc);
                            }
                            else
                            {
                                setPtpContractsForRpc.add(objptp.ScCollection_Contract_External_Id__c);
                                mapPromisesTakenCountForRpc.put(objptp.CreatedById,setPtpContractsForRpc);
                            }
                        }
                                                                        
                        if(mapPromisesTakenAmount.containsKey(objptp.CreatedById) && mapPromisesTakenAmount.get(objptp.CreatedById) != Null)
                        {
                            PtpAmount = mapPromisesTakenAmount.get(objptp.CreatedById);    
                        }
                        
                        if(objptp.collect__Arrangement_Amount__c > 0)
                        {
                            PtpAmount += objptp.collect__Arrangement_Amount__c;
                        }
                                                
                        mapPromisesTakenAmount.put(objptp.CreatedById,PtpAmount);
                        
                        if(mapPromisesLoanBalance.containsKey(objptp.CreatedById) && mapPromisesLoanBalance.get(objptp.CreatedById) != Null)
                        {
                            PtpLoanBalance = mapPromisesLoanBalance.get(objptp.CreatedById);    
                        }
                        
                        String key = objptp.ScCollection_Contract_Id__c + '-' + objptp.CreatedById;
                            
                        if(!setContracts.contains(key))
                        {
                            if(objptp.ScCollection_Contract_Balance__c > 0)
                            {
                                PtpLoanBalance += objptp.ScCollection_Contract_Balance__c; 
                                setContracts.add(key);
                            }
                        }
                        
                        mapPromisesLoanBalance.put(objptp.CreatedById,PtpLoanBalance);
                    }
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(strLogQuery))
            {
                List<collect__Interaction_Log__c> lstlog = Database.Query(strLogQuery);
                
                if(ScCollection_UtilityHandler.isNotNull(lstlog))
                {
                    for(collect__Interaction_Log__c objlog : lstlog)
                    {
                        Boolean isOther = true;
                        Set<Id> setQueueContracts = new Set<Id>();
                        Set<Id> setInboundContracts = new Set<Id>();
                        Set<Id> setOtherContracts = new Set<Id>();
                        Set<Id> setTotalContracts = new Set<Id>();
                        Set<Id> setRPCContracts = new Set<Id>();
                        Set<Id> setRPCNoPromiseContracts = new Set<Id>();
                        
                        if(mapQueueAccountsAssigned.containsKey(objlog.CreatedById) && mapQueueAccountsAssigned.get(objlog.CreatedById) != Null)
                        {
                            Set<Id> setContractAssigned = new Set<Id>();
                            setContractAssigned.addAll(mapQueueAccountsAssigned.get(objlog.CreatedById));
                            
                            if(setContractAssigned != Null && setContractAssigned.size() > 0)
                            {
                                if(objlog.collect__Dev_Contract__c != Null && setContractAssigned.contains(objlog.collect__Dev_Contract__c))
                                {
                                    if(mapQueueAccountsActioned.containsKey(objlog.CreatedById) && mapQueueAccountsActioned.get(objlog.CreatedById) != Null)
                                    {
                                        setQueueContracts.addAll(mapQueueAccountsActioned.get(objlog.CreatedById));    
                                    }
                                    
                                    setQueueContracts.add(objlog.collect__Dev_Contract__c); 
                                    isOther = false; 
                                    
                                    mapQueueAccountsActioned.put(objlog.CreatedById,setQueueContracts);
                                    
                                    if(objlog.collect__Action__r.ScCollection_Is_Inbound_Action__c)
                                    {
                                        if(mapInboundAccountsActioned.containsKey(objlog.CreatedById) && mapInboundAccountsActioned.get(objlog.CreatedById) != Null)
                                        {
                                            setInboundContracts.addAll(mapInboundAccountsActioned.get(objlog.CreatedById));    
                                        }
                                        setInboundContracts.add(objlog.collect__Dev_Contract__c); 
                                                                                    
                                        mapInboundAccountsActioned.put(objlog.CreatedById,setInboundContracts);
                                    }    
                                }
                                else if(objlog.ScCollection_CL_Contract__c != Null && setContractAssigned.contains(objlog.ScCollection_CL_Contract__c))
                                {
                                    if(mapQueueAccountsActioned.containsKey(objlog.CreatedById) && mapQueueAccountsActioned.get(objlog.CreatedById) != Null)
                                    {
                                        setQueueContracts.addAll(mapQueueAccountsActioned.get(objlog.CreatedById));    
                                    }
                                    
                                    setQueueContracts.add(objlog.ScCollection_CL_Contract__c);   
                                    isOther = false;  
                                    
                                    mapQueueAccountsActioned.put(objlog.CreatedById,setQueueContracts);   
                                    
                                    if(objlog.collect__Action__r.ScCollection_Is_Inbound_Action__c)
                                    {
                                        if(mapInboundAccountsActioned.containsKey(objlog.CreatedById) && mapInboundAccountsActioned.get(objlog.CreatedById) != Null)
                                        {
                                            setInboundContracts.addAll(mapInboundAccountsActioned.get(objlog.CreatedById));    
                                        }
                                        
                                        setInboundContracts.add(objlog.ScCollection_CL_Contract__c);
                                            
                                        mapInboundAccountsActioned.put(objlog.CreatedById,setInboundContracts);
                                    }
                                }
                            }    
                        }
                        
                        if(objlog.collect__Action__r.ScCollection_Considered_Contact__c == 'Yes')
                        {
                            Set<String> setTempPtpContract = new Set<String>();
                            
                            if(mapRightPartyContacts.containsKey(objlog.CreatedById) && mapRightPartyContacts.get(objlog.CreatedById) != Null)
                            {
                                setRPCContracts.addAll(mapRightPartyContacts.get(objlog.CreatedById));    
                            }
                            
                            if(objlog.collect__Dev_Contract__c != Null)
                            {
                                setRPCContracts.add(objlog.collect__Dev_Contract__c);  
                                mapRightPartyContacts.put(objlog.CreatedById,setRPCContracts);   
                            }
                            else if(objlog.ScCollection_CL_Contract__c != Null)
                            {
                                setRPCContracts.add(objlog.ScCollection_CL_Contract__c);
                                mapRightPartyContacts.put(objlog.CreatedById,setRPCContracts); 
                            }
                            
                            if(mapPromisesTakenCountForRpc.containsKey(objlog.CreatedById) && mapPromisesTakenCountForRpc.get(objlog.CreatedById) != Null)
                            {
                                setTempPtpContract.addAll(mapPromisesTakenCountForRpc.get(objlog.CreatedById));  
                                
                                if(mapRPCNoPromises.containsKey(objlog.CreatedById) && mapRPCNoPromises.get(objlog.CreatedById) != Null)
                                {
                                    setRPCNoPromiseContracts.addAll(mapRPCNoPromises.get(objlog.CreatedById));    
                                }
                                
                                if(objlog.collect__Dev_Contract__c != Null && !setTempPtpContract.contains(objlog.collect__Dev_Contract__r.collect__External_ID__c))
                                {
                                    setRPCNoPromiseContracts.add(objlog.collect__Dev_Contract__c);
                                    mapRPCNoPromises.put(objlog.CreatedById,setRPCNoPromiseContracts);
                                }  
                                else if(objlog.ScCollection_CL_Contract__c != Null && !setTempPtpContract.contains(objlog.ScCollection_CL_Contract__c))
                                {
                                    setRPCNoPromiseContracts.add(objlog.ScCollection_CL_Contract__c);
                                    mapRPCNoPromises.put(objlog.CreatedById,setRPCNoPromiseContracts);
                                }
                            }
                        }
                        
                        if(isOther)
                        {
                            if(mapOtherAccountsActioned.containsKey(objlog.CreatedById) && mapOtherAccountsActioned.get(objlog.CreatedById) != Null)
                            {
                                setOtherContracts.addAll(mapOtherAccountsActioned.get(objlog.CreatedById));    
                            }
                            
                            if(objlog.collect__Dev_Contract__c != Null)
                            {
                                setOtherContracts.add(objlog.collect__Dev_Contract__c); 
                                mapOtherAccountsActioned.put(objlog.CreatedById,setOtherContracts); 
                            }
                            else if(objlog.ScCollection_CL_Contract__c != Null)
                            {
                                setOtherContracts.add(objlog.ScCollection_CL_Contract__c);
                                mapOtherAccountsActioned.put(objlog.CreatedById,setOtherContracts); 
                            }
                        }
                        
                        if(mapTotalAccountsActioned.containsKey(objlog.CreatedById) && mapTotalAccountsActioned.get(objlog.CreatedById) != Null)
                        {
                            setTotalContracts.addAll(mapTotalAccountsActioned.get(objlog.CreatedById));    
                        }
                        
                        if(objlog.collect__Dev_Contract__c != Null)
                        {
                            setTotalContracts.add(objlog.collect__Dev_Contract__c); 
                            mapTotalAccountsActioned.put(objlog.CreatedById,setTotalContracts); 
                        }
                        else if(objlog.ScCollection_CL_Contract__c != Null)
                        {
                            setTotalContracts.add(objlog.ScCollection_CL_Contract__c);
                            mapTotalAccountsActioned.put(objlog.CreatedById,setTotalContracts); 
                        }
                    }
                }
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(setUserId))
        {
            for(Id objid : setUserId)
            {
                wrapperForContractList objwrapperForContractList = new wrapperForContractList();
                
                if(mapUserIdToName.containsKey(objid) && mapUserIdToName.get(objid) != Null)
                {
                    objwrapperForContractList.strUserName = mapUserIdToName.get(objid);
                }
                
                if(mapQueueAccountsAssigned.containsKey(objid) && mapQueueAccountsAssigned.get(objid) != Null)
                {
                    objwrapperForContractList.setQueueAccountsAssigned.addAll(mapQueueAccountsAssigned.get(objid));
                }
                
                if(mapQueueAccountsActioned.containsKey(objid) && mapQueueAccountsActioned.get(objid) != Null)
                {
                    objwrapperForContractList.setQueueAccountsActioned.addAll(mapQueueAccountsActioned.get(objid));
                }
                
                if(mapInboundAccountsActioned.containsKey(objid) && mapInboundAccountsActioned.get(objid) != Null)
                {
                    objwrapperForContractList.setInboundAccountsActioned.addAll(mapInboundAccountsActioned.get(objid));
                }
                
                if(mapOtherAccountsActioned.containsKey(objid) && mapOtherAccountsActioned.get(objid) != Null)
                {
                    objwrapperForContractList.setOtherAccountsActioned.addAll(mapOtherAccountsActioned.get(objid));
                }
                
                if(mapTotalAccountsActioned.containsKey(objid) && mapTotalAccountsActioned.get(objid) != Null)
                {
                    objwrapperForContractList.setTotalAccountsActioned.addAll(mapTotalAccountsActioned.get(objid));
                }
                
                if(mapRightPartyContacts.containsKey(objid) && mapRightPartyContacts.get(objid) != Null)
                {
                    objwrapperForContractList.setRightPartyContacts.addAll(mapRightPartyContacts.get(objid));
                }
                
                if(mapPromisesTakenCount.containsKey(objid) && mapPromisesTakenCount.get(objid) != Null)
                {
                    objwrapperForContractList.setPromisesTakenCount.addAll(mapPromisesTakenCount.get(objid));
                }
                
                if(mapPromiseTakenParentCount.containsKey(objid) && mapPromiseTakenParentCount.get(objid) != Null)
                {
                    objwrapperForContractList.setPromisesTakenCountAgainstParent.addAll(mapPromiseTakenParentCount.get(objid));
                }
                
                if(mapPromisesTakenAmount.containsKey(objid) && mapPromisesTakenAmount.get(objid) != Null)
                {
                    objwrapperForContractList.PromisesTakenAmount = mapPromisesTakenAmount.get(objid);
                }
                
                if(mapPromisesLoanBalance.containsKey(objid) && mapPromisesLoanBalance.get(objid) != Null)
                {
                    objwrapperForContractList.PromisesLoanBalance = mapPromisesLoanBalance.get(objid);
                }
                
                if(mapRPCNoPromises.containsKey(objid) && mapRPCNoPromises.get(objid) != Null)
                {
                    objwrapperForContractList.setRPCNoPromises.addAll(mapRPCNoPromises.get(objid));
                }
                
                lstContracts.add(objwrapperForContractList);
            }
        }
        
        return lstContracts;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to return the records of ptplistwrapper on the basis of search
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 17-Nov-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    @RemoteAction
    public static List<wrapperForPTPList> getPtpSearchResults(String UserIds, String StartDate, String EndDate, String StartDateFilter, String EndDateFilter)
    {
        lstPromiseToPay = new List<wrapperForPTPList>();
        Set<Id> setUserId = new Set<Id>();
        Map<Id,String> mapUserIdToName = new Map<Id,String>();
        Map<Id,Set<Id>> mapPromisesTakenCount = new Map<Id,Set<Id>>();
        Map<Id,Decimal> mapPromisesTakenAmount = new Map<Id,Decimal>();
        Map<Id,Decimal> mapPromisesTakenBalance = new Map<Id,Decimal>();
        Map<Id,Set<Id>> mapPromisesKeptCount = new Map<Id,Set<Id>>();
        Map<Id,Decimal> mapPromisesKeptAmount = new Map<Id,Decimal>();
        Map<Id,Decimal> mapPromisesKeptBalance = new Map<Id,Decimal>();
        Map<Id,Set<Id>> mapPromisesBrokenCount = new Map<Id,Set<Id>>();
        Map<Id,Decimal> mapPromisesBrokenAmount = new Map<Id,Decimal>();
        Map<Id,Decimal> mapPromisesBrokenBalance = new Map<Id,Decimal>();
                
        String strPtpQuery = '';
        
        if(String.isNotEmpty(StartDate) && String.isNotEmpty(EndDate) && String.isNotEmpty(UserIds))
        {
            strPtpQuery = 'select Id, collect__Promise_To_Pay_Amount__c, collect__Promise_Kept__c, collect__Promise_Broken__c, collect__Promise_To_Pay_Date__c, ScCollection_Promise_Kept_Broken_Date__c, ScCollection_Contract_Id__c, ScCollection_Contract_Balance__c, CreatedById, CreatedBy.Name from collect__Promise_To_Pay__c where ScCollection_Created_Date__c >= ' + FormatDate(StartDate) + ' AND ScCollection_Created_Date__c <= ' + FormatDate(EndDate);
            
            if(UserIds != 'All')
            {
                strPtpQuery += ' AND CreatedById IN(' + UserIds + ')';   
            }
            
            system.debug('query++ptp' + strPtpQuery);
            
            if(ScCollection_UtilityHandler.isNotNull(strPtpQuery))
            {
                List<collect__Promise_To_Pay__c> lstptp = Database.Query(strPtpQuery);
                
                if(ScCollection_UtilityHandler.isNotNull(lstptp))
                {
                    Set<String> setTakenContracts = new Set<String>();
                    Set<String> setKeptContracts = new Set<String>();
                    Set<String> setBrokenContracts = new Set<String>();
                    
                    for(collect__Promise_To_Pay__c objptp : lstptp)
                    {
                        setUserId.add(objptp.CreatedById);
                        mapUserIdToName.put(objptp.CreatedById, objptp.CreatedBy.Name);
                        
                        Set<Id> setPtpTaken = new Set<Id>();
                        Set<Id> setPtpKept = new Set<Id>();
                        Set<Id> setPtpBroken = new Set<Id>();
                        Decimal PtpTakenAmount = 0.00;
                        Decimal PtpKeptAmount = 0.00;
                        Decimal PtpBrokenAmount = 0.00;
                        Decimal PtpTakenBalance = 0.00;
                        Decimal PtpKeptBalance = 0.00;
                        Decimal PtpBrokenBalance = 0.00;
                        
                        if(mapPromisesTakenCount.containsKey(objptp.CreatedById) && mapPromisesTakenCount.get(objptp.CreatedById) != Null)
                        {
                            setPtpTaken.addAll(mapPromisesTakenCount.get(objptp.CreatedById));    
                        }
                        setPtpTaken.add(objptp.Id);
                        mapPromisesTakenCount.put(objptp.CreatedById,setPtpTaken);
                            
                        if(mapPromisesTakenAmount.containsKey(objptp.CreatedById) && mapPromisesTakenAmount.get(objptp.CreatedById) != Null)
                        {
                            PtpTakenAmount = mapPromisesTakenAmount.get(objptp.CreatedById);    
                        }
                        if(objptp.collect__Promise_To_Pay_Amount__c > 0)
                        {
                            PtpTakenAmount += objptp.collect__Promise_To_Pay_Amount__c;
                        }
                        mapPromisesTakenAmount.put(objptp.CreatedById,PtpTakenAmount);
                        
                        if(mapPromisesTakenBalance.containsKey(objptp.CreatedById) && mapPromisesTakenBalance.get(objptp.CreatedById) != Null)
                        {
                            PtpTakenBalance = mapPromisesTakenBalance.get(objptp.CreatedById);    
                        }
                        
                        String key = objptp.ScCollection_Contract_Id__c + '-' + objptp.CreatedById;
                            
                        if(!setTakenContracts.contains(key))
                        {
                            if(objptp.ScCollection_Contract_Balance__c > 0)
                            {
                                PtpTakenBalance += objptp.ScCollection_Contract_Balance__c; 
                                setTakenContracts.add(key);
                            }
                        }
                        
                        mapPromisesTakenBalance.put(objptp.CreatedById,PtpTakenBalance);
                        
                        if(objptp.collect__Promise_Kept__c)
                        {
                            Boolean consider = false;
                            
                            if(StartDateFilter != '' && EndDateFilter != '')
                            {
                                Date dtstartDate = Date.valueOf(FormatDate(StartDateFilter));
                                Date dtendDate = Date.valueOf(FormatDate(EndDateFilter));
                                
                                if(objptp.ScCollection_Promise_Kept_Broken_Date__c != Null)
                                {
                                    if(objptp.ScCollection_Promise_Kept_Broken_Date__c >= dtstartDate && objptp.ScCollection_Promise_Kept_Broken_Date__c <= dtendDate)
                                    {
                                        consider = true;
                                    }    
                                }    
                            }
                            else
                            {
                                consider = true;
                            }
                            
                            if(consider)
                            {
                                if(mapPromisesKeptCount.containsKey(objptp.CreatedById) && mapPromisesKeptCount.get(objptp.CreatedById) != Null)
                                {
                                    setPtpKept.addAll(mapPromisesKeptCount.get(objptp.CreatedById));    
                                }
                                setPtpKept.add(objptp.Id);
                                mapPromisesKeptCount.put(objptp.CreatedById,setPtpKept);
                                
                                if(mapPromisesKeptAmount.containsKey(objptp.CreatedById) && mapPromisesKeptAmount.get(objptp.CreatedById) != Null)
                                {
                                    PtpKeptAmount = mapPromisesKeptAmount.get(objptp.CreatedById);    
                                }
                                if(objptp.collect__Promise_To_Pay_Amount__c > 0)
                                {
                                    PtpKeptAmount += objptp.collect__Promise_To_Pay_Amount__c;
                                }
                                mapPromisesKeptAmount.put(objptp.CreatedById,PtpKeptAmount);
                                
                                if(mapPromisesKeptBalance.containsKey(objptp.CreatedById) && mapPromisesKeptBalance.get(objptp.CreatedById) != Null)
                                {
                                    PtpKeptBalance = mapPromisesKeptBalance.get(objptp.CreatedById);    
                                }
                                
                                String key1 = objptp.ScCollection_Contract_Id__c + '-' + objptp.CreatedById;
                                    
                                if(!setKeptContracts.contains(key1))
                                {
                                    if(objptp.ScCollection_Contract_Balance__c > 0)
                                    {
                                        PtpKeptBalance += objptp.ScCollection_Contract_Balance__c; 
                                        setKeptContracts.add(key1);
                                    }
                                }
                                
                                mapPromisesKeptBalance.put(objptp.CreatedById,PtpKeptBalance);
                            }
                        }
                        
                        if(objptp.collect__Promise_Broken__c)
                        {
                            Boolean consider = false;
                            
                            if(StartDateFilter != '' && EndDateFilter != '')
                            {
                                Date dtstartDate = Date.valueOf(FormatDate(StartDateFilter));
                                Date dtendDate = Date.valueOf(FormatDate(EndDateFilter));
                                
                                if(objptp.ScCollection_Promise_Kept_Broken_Date__c != Null)
                                {
                                    if(objptp.ScCollection_Promise_Kept_Broken_Date__c >= dtstartDate && objptp.ScCollection_Promise_Kept_Broken_Date__c <= dtendDate)
                                    {
                                        consider = true;
                                    }
                                }
                            }
                            else
                            {
                                consider = true;
                            }
                            
                            if(consider)
                            {
                                if(mapPromisesBrokenCount.containsKey(objptp.CreatedById) && mapPromisesBrokenCount.get(objptp.CreatedById) != Null)
                                {
                                    setPtpBroken.addAll(mapPromisesBrokenCount.get(objptp.CreatedById));    
                                }
                                setPtpBroken.add(objptp.Id);
                                mapPromisesBrokenCount.put(objptp.CreatedById,setPtpBroken);
                                
                                if(mapPromisesBrokenAmount.containsKey(objptp.CreatedById) && mapPromisesBrokenAmount.get(objptp.CreatedById) != Null)
                                {
                                    PtpBrokenAmount = mapPromisesBrokenAmount.get(objptp.CreatedById);    
                                }
                                if(objptp.collect__Promise_To_Pay_Amount__c > 0)
                                {
                                    PtpBrokenAmount += objptp.collect__Promise_To_Pay_Amount__c;
                                }
                                mapPromisesBrokenAmount.put(objptp.CreatedById,PtpBrokenAmount);
                                
                                if(mapPromisesBrokenBalance.containsKey(objptp.CreatedById) && mapPromisesBrokenBalance.get(objptp.CreatedById) != Null)
                                {
                                    PtpBrokenBalance = mapPromisesBrokenBalance.get(objptp.CreatedById);    
                                }
                                
                                String key2 = objptp.ScCollection_Contract_Id__c + '-' + objptp.CreatedById;
                                    
                                if(!setBrokenContracts.contains(key2))
                                {
                                    if(objptp.ScCollection_Contract_Balance__c > 0)
                                    {
                                        PtpBrokenBalance += objptp.ScCollection_Contract_Balance__c; 
                                        setBrokenContracts.add(key2);
                                    }
                                }
                                
                                mapPromisesBrokenBalance.put(objptp.CreatedById,PtpBrokenBalance);
                            }
                        }
                    }
                }
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(setUserId))
        {
            for(Id objid : setUserId)
            {
                wrapperForPTPList objwrapperForPTPList = new wrapperForPTPList();
                
                if(mapUserIdToName.containsKey(objid) && mapUserIdToName.get(objid) != Null)
                {
                    objwrapperForPTPList.strUserName = mapUserIdToName.get(objid);
                }
                
                if(mapPromisesTakenCount.containsKey(objid) && mapPromisesTakenCount.get(objid) != Null)
                {
                    objwrapperForPTPList.setPromisesTakenCount.addAll(mapPromisesTakenCount.get(objid));
                }
                
                if(mapPromisesTakenAmount.containsKey(objid) && mapPromisesTakenAmount.get(objid) != Null)
                {
                    objwrapperForPTPList.PromisesTakenAmount = mapPromisesTakenAmount.get(objid);
                }
                
                if(mapPromisesTakenBalance.containsKey(objid) && mapPromisesTakenBalance.get(objid) != Null)
                {
                    objwrapperForPTPList.PromisesTakenBalance = mapPromisesTakenBalance.get(objid);
                }
                
                if(mapPromisesKeptCount.containsKey(objid) && mapPromisesKeptCount.get(objid) != Null)
                {
                    objwrapperForPTPList.setPromisesKeptCount.addAll(mapPromisesKeptCount.get(objid));
                }
                
                if(mapPromisesKeptAmount.containsKey(objid) && mapPromisesKeptAmount.get(objid) != Null)
                {
                    objwrapperForPTPList.PromisesKeptAmount = mapPromisesKeptAmount.get(objid);
                }
                
                if(mapPromisesKeptBalance.containsKey(objid) && mapPromisesKeptBalance.get(objid) != Null)
                {
                    objwrapperForPTPList.PromisesKeptBalance = mapPromisesKeptBalance.get(objid);
                }
                
                if(mapPromisesBrokenCount.containsKey(objid) && mapPromisesBrokenCount.get(objid) != Null)
                {
                    objwrapperForPTPList.setPromisesBrokenCount.addAll(mapPromisesBrokenCount.get(objid));
                }
                
                if(mapPromisesBrokenAmount.containsKey(objid) && mapPromisesBrokenAmount.get(objid) != Null)
                {
                    objwrapperForPTPList.PromisesBrokenAmount = mapPromisesBrokenAmount.get(objid);
                }
                
                if(mapPromisesBrokenBalance.containsKey(objid) && mapPromisesBrokenBalance.get(objid) != Null)
                {
                    objwrapperForPTPList.PromisesBrokenBalance = mapPromisesBrokenBalance.get(objid);
                }
                
                lstPromiseToPay.add(objwrapperForPTPList);
            }
        }
        
        return lstPromiseToPay;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to return the details of contract records
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 17-Nov-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    @RemoteAction
    public static List<wrapperForContractDetail> getDetailResults(String ContractIds)
    {
        lstContractDetail = new List<wrapperForContractDetail>();
        Set<Id> setTotalCotractIds = new Set<Id>();
        Set<String> setExternalIds = new Set<String>();
        Map<String,String> mapExternalIdToName = new Map<String,String>();
        
        if(String.isNotEmpty(ContractIds))
        {
            List<String> lststr = ContractIds.split(',');
            
            for(String objstr : lststr)
            {
                if(String.isNotEmpty(objstr))
                {
                    setTotalCotractIds.add(objstr.trim());
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(setTotalCotractIds))
            {
                for(collect__Loan_account__c objcl : [select Id, collect__External_ID__c from collect__Loan_account__c where Id IN : setTotalCotractIds])
                {
                    if(objcl.collect__External_ID__c != Null)
                    {
                        if(objcl.collect__External_ID__c.contains('_'))
                        {
                            String extid = objcl.collect__External_ID__c;
                            List<String> templststr = extid.split('_');
                            
                            if(templststr.size() > 1 && templststr[1] != Null && templststr[1] != '0')
                            {
                                extid = templststr[0] + '_0';
                            }
                            
                            setExternalIds.add(extid);
                        }
                        else
                        {
                            setExternalIds.add(objcl.collect__External_ID__c);        
                        }
                    }    
                }
                
                if(ScCollection_UtilityHandler.isNotNull(setExternalIds))
                {
                    for(collect__Loan_account__c objcl : [select Id, collect__External_ID__c, ScCollection_Customer_Name__c from collect__Loan_account__c where collect__External_ID__c IN : setExternalIds])
                    {
                        mapExternalIdToName.put(objcl.collect__External_ID__c, objcl.ScCollection_Customer_Name__c);
                    }
                }
                
                for(collect__Loan_account__c objcl : [select Id, Name, collect__External_ID__c, ScCollection_Arrears__c, ScCollection_Current_Principal__c, ScCollection_Loan_Status_Description__c, ScCollection_Next_Installment_Date__c, ScCollection_Bucket__c, ScCollection_Customer_Name__c from collect__Loan_account__c where Id IN : setTotalCotractIds])
                {
                    wrapperForContractDetail objwrapperForContractDetail = new wrapperForContractDetail();
                    objwrapperForContractDetail.strContractId = objcl.Id;
                    objwrapperForContractDetail.strContractNo = objcl.Name;
                    
                    String extid = objcl.collect__External_ID__c;
                    
                    if(extid.contains('_'))
                    {
                        List<String> newtemplststr = extid.split('_');
                    
                        if(newtemplststr.size() > 1 && newtemplststr[1] != Null && newtemplststr[1] != '0')
                        {
                            extid = newtemplststr[0] + '_0';
                        }
                    }
                    
                    if(mapExternalIdToName.containsKey(extid) && mapExternalIdToName.get(extid) != Null)
                    {
                        objwrapperForContractDetail.strCustomerName = mapExternalIdToName.get(extid);
                    }
                    
                    if(objcl.ScCollection_Loan_Status_Description__c != Null)
                    {
                        objwrapperForContractDetail.strStatus = objcl.ScCollection_Loan_Status_Description__c;    
                    }
                    if(objcl.ScCollection_Arrears__c != Null)
                    {
                        objwrapperForContractDetail.ArrearAmount = objcl.ScCollection_Arrears__c;
                    }    
                    if(objcl.ScCollection_Current_Principal__c != Null)
                    {
                        objwrapperForContractDetail.BalanceAmount = objcl.ScCollection_Current_Principal__c;
                    }
                    if(objcl.ScCollection_Next_Installment_Date__c != Null)
                    {
                        objwrapperForContractDetail.strDueDate = objcl.ScCollection_Next_Installment_Date__c.format();
                    }
                    if(objcl.ScCollection_Bucket__c != Null)
                    {
                        objwrapperForContractDetail.strBucket = String.valueof(objcl.ScCollection_Bucket__c);
                    }
                                        
                    lstContractDetail.add(objwrapperForContractDetail);
                }
                
                for(loan__Loan_account__c objpl : [select Id, Name, loan__Amount_to_Current__c, loan__Loan_Balance__c, loan__Loan_Status__c, loan__Next_Installment_Date__c, ScCollection_Customer_Name__c from loan__Loan_account__c where Id IN : setTotalCotractIds])
                {
                    wrapperForContractDetail objwrapperForContractDetail = new wrapperForContractDetail();
                    objwrapperForContractDetail.strContractId = objpl.Id;
                    objwrapperForContractDetail.strContractNo = objpl.Name;
                    objwrapperForContractDetail.strCustomerName = objpl.ScCollection_Customer_Name__c;
                    
                    if(objpl.loan__Loan_Status__c != Null)
                    {
                        objwrapperForContractDetail.strStatus = objpl.loan__Loan_Status__c;    
                    }
                    if(objpl.loan__Amount_to_Current__c != Null)
                    {
                        objwrapperForContractDetail.ArrearAmount = objpl.loan__Amount_to_Current__c;
                    }    
                    if(objpl.loan__Loan_Balance__c != Null)
                    {
                        objwrapperForContractDetail.BalanceAmount = objpl.loan__Loan_Balance__c;
                    }
                    if(objpl.loan__Next_Installment_Date__c != Null)
                    {
                        objwrapperForContractDetail.strDueDate = objpl.loan__Next_Installment_Date__c.format();
                    }
                                                            
                    lstContractDetail.add(objwrapperForContractDetail);
                }
            }
        }
        
        return lstContractDetail;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to return the details of ptp records
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 17-Nov-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    @RemoteAction
    public static List<wrapperForPTPDetail> getPtpDetailResults(String PtpIds)
    {
        lstPromiseToPayDetail = new List<wrapperForPTPDetail>();
        Set<Id> setTotalPtpIds = new Set<Id>();
        Set<String> setExternalIds = new Set<String>();
        Map<String,String> mapExternalIdToName = new Map<String,String>();
        
        if(String.isNotEmpty(PtpIds))
        {
            List<String> lststr = PtpIds.split(',');
            
            for(String objstr : lststr)
            {
                if(String.isNotEmpty(objstr))
                {
                    setTotalPtpIds.add(objstr.trim());
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(setTotalPtpIds))
            {
                for(collect__Promise_To_Pay__c objptp : [select Id, ScCollection_Contract_External_Id__c from collect__Promise_To_Pay__c where Id IN : setTotalPtpIds])
                {
                    if(objptp.ScCollection_Contract_External_Id__c != Null)
                    {
                        if(objptp.ScCollection_Contract_External_Id__c.contains('_'))
                        {
                            String extid = objptp.ScCollection_Contract_External_Id__c;
                            List<String> templststr = extid.split('_');
                            
                            if(templststr.size() > 1 && templststr[1] != Null && templststr[1] != '0')
                            {
                                extid = templststr[0] + '_0';
                            }
                            
                            setExternalIds.add(extid);
                        }
                        else
                        {
                            setExternalIds.add(objptp.ScCollection_Contract_External_Id__c);        
                        }
                    }    
                }
                
                if(ScCollection_UtilityHandler.isNotNull(setExternalIds))
                {
                    for(collect__Loan_account__c objcl : [select Id, collect__External_ID__c, ScCollection_Customer_Name__c from collect__Loan_account__c where collect__External_ID__c IN : setExternalIds])
                    {
                        mapExternalIdToName.put(objcl.collect__External_ID__c, objcl.ScCollection_Customer_Name__c);
                    }
                }
                
                for(collect__Promise_To_Pay__c objptp : [select Id, ScCollection_Contract_Id__c, ScCollection_Contract_External_Id__c, ScCollection_Contract_Name__c, ScCollection_Customer_Name__c, collect__Promise_To_Pay_Amount__c, collect__Promise_To_Pay_Date__c, ScCollection_Contract_Bucket__c, ScCollection_Contract_Balance__c, ScCollection_Contract_SPV__c from collect__Promise_To_Pay__c where Id IN : setTotalPtpIds])
                {
                    wrapperForPTPDetail objwrapperForPTPDetail = new wrapperForPTPDetail();
                    objwrapperForPTPDetail.strContractId = objptp.ScCollection_Contract_Id__c;
                    objwrapperForPTPDetail.strContractNo = objptp.ScCollection_Contract_Name__c;
                    
                    if(objptp.ScCollection_Contract_External_Id__c != Null)
                    {
                        if(mapExternalIdToName.containsKey(objptp.ScCollection_Contract_External_Id__c) && mapExternalIdToName.get(objptp.ScCollection_Contract_External_Id__c) != Null)
                        {
                            objwrapperForPTPDetail.strCustomerName = mapExternalIdToName.get(objptp.ScCollection_Contract_External_Id__c);
                        }
                    }
                    else
                    {
                        objwrapperForPTPDetail.strCustomerName = objptp.ScCollection_Customer_Name__c;
                    }
                    
                    if(objptp.collect__Promise_To_Pay_Amount__c != Null)
                    {
                        objwrapperForPTPDetail.strPtpAmount = objptp.collect__Promise_To_Pay_Amount__c;
                    }
                    if(objptp.collect__Promise_To_Pay_Date__c != Null)
                    {
                        objwrapperForPTPDetail.strPtpDate = objptp.collect__Promise_To_Pay_Date__c.format();
                    }
                    if(objptp.ScCollection_Contract_Bucket__c != Null)
                    {
                        objwrapperForPTPDetail.strBucket = String.valueof(objptp.ScCollection_Contract_Bucket__c);
                    }
                    if(objptp.ScCollection_Contract_Balance__c != Null)
                    {
                        objwrapperForPTPDetail.strBalance = objptp.ScCollection_Contract_Balance__c;
                    }
                    if(objptp.ScCollection_Contract_SPV__c != Null)
                    {
                        objwrapperForPTPDetail.strSPV = objptp.ScCollection_Contract_SPV__c;
                    }
                    
                    lstPromiseToPayDetail.add(objwrapperForPTPDetail);
                }
            }
        }
        
        return lstPromiseToPayDetail;
    }
    
    public static String FormatDate(String strdatevalue)
    {
        String strformatteddate = '';
        
        if(ScCollection_UtilityHandler.isNotNull(strdatevalue))
        {
            List<String> lstdateparts = strdatevalue.trim().split('/');
            
            if(ScCollection_UtilityHandler.isNotNull(lstdateparts))
            {
                if(Integer.valueof(lstdateparts[0]) >=1 && Integer.valueof(lstdateparts[0]) <= 9)
                {
                    lstdateparts[0] = '0' + lstdateparts[0];
                }
                
                strformatteddate = lstdateparts[2] + '-' + lstdateparts[1] + '-' + lstdateparts[0];
            }
        }
        
        return strformatteddate;
    }
}