// --------------------------------------------------------------------------------------------------------
// This class handles the logic for the custom vf pages on console view for displaying all contracts in a user queue.
// --------------------------------------------------------------------------------------------------------
// Created Date: 06-Sep-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
//Test Class : ScCollection_TestContractListHandler
// --------------------------------------------------------------------------------------------------------
global class ScCollection_ContractListHandler
{
    //variable declaration for the search data to be binded on page.
    public String strActivityIndex {get;set;}
    public Task objSearchDate {get;set;}
    public String strUserType {get;set;}
        
    public Map<String,List<wrapperForActivityList>> mapWrapperForActivityList {get;set;}
    public static List<wrapperForContractList> lstContracts {get;set;}
    
    private static final String VAR_TODAY_FOLLOWUP = 'TODAYS FOLLOW-UP';
    private static final String VAR_ALL_CONTRACTS = 'ALL CONTRACTS';
    private static final String VAR_TODAY = 'Today';
    private static final String VAR_ALL = 'All';
    private static final String VAR_IMAGE_BASE_URL = '/servlet/servlet.FileDownload?file=';
    private static final String VAR_FOLLOW_UP = 'Follow Up';
    private static final String VAR_ATT_NAME = 'Profile Pic%';
    private static final String VAR_DD_MM_YYYY = 'dd/MM/yyyy';
    private static final String VAR_CONTRACTNO = 'ContractNo';
    private static final String VAR_CUSTOMERNAME = 'CustomerName';
    private static final String VAR_CUSTOMERSTATE = 'CustomerState';
    private static final String VAR_DUEDATE = 'DueDate';
    private static final String VAR_ARREARAMOUNT = 'ArrearAmount';
    private static final String VAR_BALANCEAMOUNT = 'BalanceAmount';
    private static final String VAR_BUCKET = 'Bucket';
    private static final String VAR_CONTRACTSTATUS = 'ContractStatus';
    private static final String VAR_ASSIGNDATE = 'AssignedDate';
    private static final String VAR_REVIEWDATE = 'ReviewDate';
    private static final String VAR_ASSIGNEE = 'Assignee';
    private static final String VAR_MANAGER = 'Manager';
    private static final String VAR_TL = 'TL';
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    
    //wrapper to hold info about all contracts for a particular queue
    public class wrapperForContractList
    {
        public Id strContractId;
        public String strContractNo;
        public String strCustomerName;
        public String strCustomerState;
        public String strNextDueDate;
        public String strArrearsAmount;
        public String strBalanceAmount;
        public String strBucket;
        public String strContractStatus;
        public String strReviewDate;
        public String strAssignDate;
        public String strAssignee;
        public String strQueueName;
        
        public wrapperForContractList()
        {
            strContractId = Null;
            strContractNo = '';
            strCustomerName = '';
            strCustomerState = '';
            strNextDueDate = '';
            strArrearsAmount = '0.00';
            strBalanceAmount = '0.00';
            strBucket = '';
            strContractStatus = '';
            strReviewDate = '';
            strAssignDate = '';
            strAssignee = '';
            strQueueName = '';
        }
    }

    //wrapper to hold info about all activities for today
    public class wrapperForActivityList
    {
        public Id strLogId {get;set;}
        public Id strContractId {get;set;}
        public String strContractNo {get;set;}
        public Id strContactId {get;set;}
        public String strContactName {get;set;}
        public String strContactMobile {get;set;}
        public String strContactAddress {get;set;}
        public String strContactImage {get;set;}
        public String strFollowupTime {get;set;}
        public String strFollowupDateTime {get;set;}
        public String strActivityDate {get;set;}
        
        public wrapperForActivityList()
        {
            strLogId = Null;
            strContractId  = Null;
            strContractNo = '';
            strContactId = Null;
            strContactName = '';
            strContactMobile = '';
            strContactAddress = '';
            strContactImage = 'null';
            strFollowupTime = '';
            strFollowupDateTime = '';
            strActivityDate = '';
        }
    }

    //constructor definition
    public ScCollection_ContractListHandler()
    {
        //variable initialization
        strActivityIndex = '';
        objSearchDate = new Task();
        strUserType = [select ScCollection_UserType__c from User where Id =: UserInfo.getUserId()].ScCollection_UserType__c;
        
        GenerateActivityList();
    }
    
    //method to get the list of queues where logged in user is assigned to show on page.
    public List<SelectOption> getQueueName()
    { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(VAR_TODAY, VAR_TODAY_FOLLOWUP));
        options.add(new SelectOption(VAR_ALL, VAR_ALL_CONTRACTS));
        
        for(collect__Queue_User__c ObjQuser : [Select collect__Queue__c, collect__Queue__r.Name from collect__Queue_User__c where collect__User__c =: UserInfo.getuserId() ORDER BY collect__Queue__r.Name])
        {
            options.add(new SelectOption(ObjQuser.collect__Queue__c, ObjQuser.collect__Queue__r.Name));
        }    
 
        return options;  
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to generate list of activities for list view page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-July-2016    Created By: Pawan Mudgal   Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    public void GenerateActivityList()
    {
        Set<Id> setparentids = new Set<Id>();
        Set<Id> setAccIds = new Set<Id>();
        Map<Id,String> mapContractToState = new Map<Id,String>();
        Map<Id,String> mapcontacttoimage = new Map<Id,String>();
        mapWrapperForActivityList = new Map<String,List<wrapperForActivityList>>();

        List<collect__Interaction_Log__c> lstactivities = [select Id, 
                                                           collect__Follow_Up_Date_Time__c,
                                                           collect__Dev_Contract__c,
                                                           collect__Dev_Contract__r.Name,
                                                           collect__Dev_Contract__r.ScCollection_Customer_Id__c,
                                                           collect__Dev_Contract__r.ScCollection_Customer_Name__c,
                                                           collect__Dev_Contract__r.ScCollection_Customer_Contact_No__c,
                                                           collect__Dev_Contract__r.ScCollection_Customer_Mailing_Address__c,
                                                           ScCollection_CL_Contract__c,
                                                           ScCollection_CL_Contract__r.Name,
                                                           ScCollection_CL_Contract__r.loan__Account__c,
                                                           ScCollection_CL_Contract__r.ScCollection_Customer_Id__c,
                                                           ScCollection_CL_Contract__r.ScCollection_Customer_Name__c,
                                                           ScCollection_CL_Contract__r.ScCollection_Customer_Contact_No__c
                                                           from collect__Interaction_Log__c
                                                           where 
                                                           collect__Collection_Activity__c != Null AND
                                                           collect__Follow_Up_Date_Time__c <= TODAY AND 
                                                           ScCollection_Activity_Completed__c = false AND 
                                                           ScCollection_Activity_Action__c =: VAR_FOLLOW_UP AND
                                                           collect__Collector__c =: UserInfo.getUserId() 
                                                           ORDER BY collect__Follow_Up_Date_Time__c ASC];
        
        if(ScCollection_UtilityHandler.isNotNull(lstactivities))
        {
            for(collect__Interaction_Log__c obj : lstactivities)
            {
                if(obj.collect__Dev_Contract__r.ScCollection_Customer_Id__c != '' && obj.collect__Dev_Contract__r.ScCollection_Customer_Id__c != Null)
                {
                    setparentids.add(obj.collect__Dev_Contract__r.ScCollection_Customer_Id__c);
                }
                else if(obj.ScCollection_CL_Contract__r.ScCollection_Customer_Id__c != '' && obj.ScCollection_CL_Contract__r.ScCollection_Customer_Id__c != Null)
                {
                    setparentids.add(obj.ScCollection_CL_Contract__r.ScCollection_Customer_Id__c);
                }
                
                if(obj.ScCollection_CL_Contract__c != Null && obj.ScCollection_CL_Contract__r.loan__Account__c != Null)
                {
                    setAccIds.add(obj.ScCollection_CL_Contract__r.loan__Account__c);    
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(setparentids))
            {
                for(Attachment obj : [select Id, ParentId from Attachment where Name Like : VAR_ATT_NAME AND ParentId IN : setparentids])
                {
                    String strurl = VAR_IMAGE_BASE_URL + obj.Id;
                    mapcontacttoimage.put(obj.ParentId,strurl);
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(setAccIds))
            {
                for(Account objacc : [select Id, (select Id, Address__c from Residential_Address__r where Current_Address__c = true limit 1) from Account where Id IN : setAccIds])
                {
                    if(objacc.Residential_Address__r != Null && objacc.Residential_Address__r.size() > 0)
                    {
                        for(Residential_Address__c objadd : objacc.Residential_Address__r)
                        {
                            if(objadd.Address__c != Null)
                            {
                                mapContractToState.put(objacc.Id,objadd.Address__c);
                            }
                        }
                    }
                }
            }
            
            for(collect__Interaction_Log__c obj : lstactivities)
            {
                wrapperForActivityList objwrapperforactivitylist = new wrapperForActivityList();
                objwrapperforactivitylist.strLogId = obj.Id;
                
                if(obj.collect__Follow_Up_Date_Time__c != Null)
                {
                    objwrapperforactivitylist.strFollowupTime = obj.collect__Follow_Up_Date_Time__c.format('hh:mm a');
                    objwrapperforactivitylist.strFollowupDateTime = obj.collect__Follow_Up_Date_Time__c.format('dd MMMM yyyy hh:mm a');
                    objwrapperforactivitylist.strActivityDate = String.valueof(obj.collect__Follow_Up_Date_Time__c.getTime());    
                }
                                
                if(obj.collect__Dev_Contract__c != Null)
                {
                    objwrapperforactivitylist.strContractId = obj.collect__Dev_Contract__c;
                    objwrapperforactivitylist.strContractNo = obj.collect__Dev_Contract__r.Name;
                    objwrapperforactivitylist.strContactId = obj.collect__Dev_Contract__r.ScCollection_Customer_Id__c;
                    objwrapperforactivitylist.strContactName = obj.collect__Dev_Contract__r.ScCollection_Customer_Name__c;
                    objwrapperforactivitylist.strContactMobile = obj.collect__Dev_Contract__r.ScCollection_Customer_Contact_No__c;
                    objwrapperforactivitylist.strContactAddress = obj.collect__Dev_Contract__r.ScCollection_Customer_Mailing_Address__c;
                    
                    if(mapcontacttoimage.containsKey(obj.collect__Dev_Contract__r.ScCollection_Customer_Id__c) && mapcontacttoimage.get(obj.collect__Dev_Contract__r.ScCollection_Customer_Id__c) != Null)
                    {
                        objwrapperforactivitylist.strContactImage = MapContactToImage.get(obj.collect__Dev_Contract__r.ScCollection_Customer_Id__c);
                    }
                }
                else if(obj.ScCollection_CL_Contract__c != Null)
                {
                    objwrapperforactivitylist.strContractId = obj.ScCollection_CL_Contract__c;
                    objwrapperforactivitylist.strContractNo = obj.ScCollection_CL_Contract__r.Name;
                    objwrapperforactivitylist.strContactId = obj.ScCollection_CL_Contract__r.ScCollection_Customer_Id__c;
                    objwrapperforactivitylist.strContactName = obj.ScCollection_CL_Contract__r.ScCollection_Customer_Name__c;
                    objwrapperforactivitylist.strContactMobile = obj.ScCollection_CL_Contract__r.ScCollection_Customer_Contact_No__c;
                                        
                    if(mapcontacttoimage.containsKey(obj.ScCollection_CL_Contract__r.ScCollection_Customer_Id__c) && mapcontacttoimage.get(obj.ScCollection_CL_Contract__r.ScCollection_Customer_Id__c) != Null)
                    {
                        objwrapperforactivitylist.strContactImage = MapContactToImage.get(obj.ScCollection_CL_Contract__r.ScCollection_Customer_Id__c);
                    }
                    
                    if(obj.ScCollection_CL_Contract__r.loan__Account__c != Null && mapContractToState.containsKey(obj.ScCollection_CL_Contract__r.loan__Account__c) && mapContractToState.get(obj.ScCollection_CL_Contract__r.loan__Account__c) != Null)
                    {
                        objwrapperforactivitylist.strContactAddress = mapContractToState.get(obj.ScCollection_CL_Contract__r.loan__Account__c);
                    }
                }
                
                List<wrapperForActivityList> lstwrpforact;
                
                if(obj.collect__Follow_Up_Date_Time__c != Null)
                {
                    if(mapWrapperForActivityList.containsKey(obj.collect__Follow_Up_Date_Time__c.format(VAR_DD_MM_YYYY)) && mapWrapperForActivityList.get(obj.collect__Follow_Up_Date_Time__c.format(VAR_DD_MM_YYYY)) != Null)
                    {
                        lstwrpforact = mapWrapperForActivityList.get(obj.collect__Follow_Up_Date_Time__c.format(VAR_DD_MM_YYYY));
                        lstwrpforact.add(objwrapperforactivitylist);
                    }
                    else
                    {
                        lstwrpforact = new List<wrapperForActivityList>();
                        lstwrpforact.add(objwrapperforactivitylist);
                    }
                    
                    mapWrapperForActivityList.put(obj.collect__Follow_Up_Date_Time__c.format(VAR_DD_MM_YYYY),lstwrpforact);
                }
            }
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to generate list of activities for list view page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-July-2016    Created By: Pawan Mudgal   Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    public void CompleteActivity()
    {
        if(ScCollection_UtilityHandler.isNotNull(strActivityIndex))
        {
            List<String> strvalues = strActivityIndex.split('-');
            List<wrapperForActivityList> lstact = mapWrapperForActivityList.get(strvalues[0]);
            
            Id strlogid = lstact[Integer.valueof(strvalues[1])].strlogid;
            
            //call cls api to complete activity
            api.completeFollowupActivities(new Set<Id>{strlogid}, false);
            
            lstact.remove(Integer.valueof(strvalues[1]));
            
            if(lstact != Null && lstact.size() > 0)
            {
                mapWrapperForActivityList.put(strvalues[0],lstact);
            }
            else
            {
                mapWrapperForActivityList.remove(strvalues[0]);
            }
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to return the records of contractlistwrapper on the basis of search
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 7-July-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    @RemoteAction
    public static List<wrapperForContractList> getSearchResults(String strselectedfield, String stringinput, String minamountinput, String maxamountinput)
    {
        String usertype = [select ScCollection_UserType__c from User where Id =: UserInfo.getUserId()].ScCollection_UserType__c;
        Set<Id> setqueueid = new Set<Id>();
        lstContracts = new List<wrapperForContractList>();
        Set<Id> setAccIds = new Set<Id>();
        Map<Id,String> mapContractToState = new Map<Id,String>();
            
        for(collect__Queue_User__c ObjQuser : [Select collect__Queue__c from collect__Queue_User__c where collect__User__c =: UserInfo.getuserId()])
        {
            setqueueid.add(ObjQuser.collect__Queue__c);
        }
        
        if(String.isNotEmpty(strselectedfield))
        {
            String strquery = '';
                        
            if(strselectedfield == VAR_CONTRACTNO && String.isNotEmpty(stringinput))
            {    
                List<collect__loan_account__c> lstclaccounts = new List<collect__loan_account__c>();
                List<loan__Loan_account__c> lstplaccounts = new List<loan__Loan_account__c>();
                
                lstclaccounts = [select Id,
                                        Name,
                                        ScCollection_Arrears__c,
                                        ScCollection_Current_Principal__c,
                                        ScCollection_Loan_Status_Description__c,
                                        ScCollection_Next_Installment_Date__c,
                                        ScCollection_Bucket__c,
                                        ScCollection_Customer_Name__c,
                                        collect__Collection_Status__r.ScCollection_Account__r.PersonMailingState,
                                        collect__Collection_Status__r.ScCollection_Contact__r.MailingState,
                                        (select collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Owner__c, collect__Queue__r.Name from Queue_Contracts__r where collect__Status__c = 'Open') 
                                        from
                                        collect__Loan_account__c
                                        where Name =: stringinput];
                
                if(ScCollection_UtilityHandler.isNotNull(lstclaccounts))
                {                                             
                    for(collect__Loan_account__c objcl : lstclaccounts)
                    {
                        if(ScCollection_UtilityHandler.isNotNull(objcl.Queue_Contracts__r) && objcl.Queue_Contracts__r.size() > 1)
                        {
                            for(collect__Queue_Contract__c objqc : objcl.Queue_Contracts__r)
                            {
                                wrapperForContractList objwrapperforcontractlist = new wrapperForContractList();
                            
                                objwrapperforcontractlist.strContractId = objcl.Id;
                                objwrapperforcontractlist.strContractNo = objcl.Name;
                                objwrapperforcontractlist.strCustomerName = objcl.ScCollection_Customer_Name__c;
                                
                                if(objcl.collect__Collection_Status__r.ScCollection_Account__r.PersonMailingState != Null)
                                {
                                    objwrapperforcontractlist.strCustomerState = objcl.collect__Collection_Status__r.ScCollection_Account__r.PersonMailingState;    
                                }
                                else if(objcl.collect__Collection_Status__r.ScCollection_Contact__r.MailingState != Null)
                                {
                                    objwrapperforcontractlist.strCustomerState = objcl.collect__Collection_Status__r.ScCollection_Contact__r.MailingState;    
                                }
                                
                                if(objqc.ScCollection_Follow_Up_Date__c != Null)
                                {
                                    objwrapperforcontractlist.strReviewDate = objqc.ScCollection_Follow_Up_Date__c.format();             
                                }
                                if(objqc.collect__Follow_Up_Date__c != Null)
                                {
                                    objwrapperforcontractlist.strAssignDate = objqc.collect__Follow_Up_Date__c.format();             
                                }
                                
                                objwrapperforcontractlist.strAssignee = objqc.ScCollection_Contract_Owner__c;
                                objwrapperforcontractlist.strQueueName = objqc.collect__Queue__r.Name;

                                if(objcl.ScCollection_Loan_Status_Description__c != Null)
                                {
                                    objwrapperforcontractlist.strContractStatus = objcl.ScCollection_Loan_Status_Description__c;    
                                }
                                if(objcl.ScCollection_Arrears__c != Null)
                                {
                                    objwrapperforcontractlist.strArrearsAmount = String.valueof(objcl.ScCollection_Arrears__c);
                                }    
                                if(objcl.ScCollection_Current_Principal__c != Null)
                                {
                                    objwrapperforcontractlist.strBalanceAmount = String.valueof(objcl.ScCollection_Current_Principal__c);
                                }
                                if(objcl.ScCollection_Next_Installment_Date__c != Null)
                                {
                                    objwrapperforcontractlist.strNextDueDate = String.valueOf(objcl.ScCollection_Next_Installment_Date__c.day());
                                }
                                if(objcl.ScCollection_Bucket__c != Null)
                                {
                                    objwrapperforcontractlist.strBucket = String.valueof(objcl.ScCollection_Bucket__c);
                                }
                                
                                lstContracts.add(objwrapperforcontractlist);
                            }
                        }    
                        else
                        {
                            wrapperForContractList objwrapperforcontractlist = new wrapperForContractList();
                            
                            objwrapperforcontractlist.strContractId = objcl.Id;
                            objwrapperforcontractlist.strContractNo = objcl.Name;
                            objwrapperforcontractlist.strCustomerName = objcl.ScCollection_Customer_Name__c;
                            
                            if(objcl.collect__Collection_Status__r.ScCollection_Account__r.PersonMailingState != Null)
                            {
                                objwrapperforcontractlist.strCustomerState = objcl.collect__Collection_Status__r.ScCollection_Account__r.PersonMailingState;    
                            }
                            else if(objcl.collect__Collection_Status__r.ScCollection_Contact__r.MailingState != Null)
                            {
                                objwrapperforcontractlist.strCustomerState = objcl.collect__Collection_Status__r.ScCollection_Contact__r.MailingState;    
                            }
                                                        
                            if(objcl.ScCollection_Loan_Status_Description__c != Null)
                            {
                                objwrapperforcontractlist.strContractStatus = objcl.ScCollection_Loan_Status_Description__c;    
                            }
                            if(objcl.ScCollection_Arrears__c != Null)
                            {
                                objwrapperforcontractlist.strArrearsAmount = String.valueof(objcl.ScCollection_Arrears__c);
                            }    
                            if(objcl.ScCollection_Current_Principal__c != Null)
                            {
                                objwrapperforcontractlist.strBalanceAmount = String.valueof(objcl.ScCollection_Current_Principal__c);
                            }
                            if(objcl.ScCollection_Next_Installment_Date__c != Null)
                            {
                                objwrapperforcontractlist.strNextDueDate = String.valueOf(objcl.ScCollection_Next_Installment_Date__c.day());
                            }
                            if(objcl.ScCollection_Bucket__c != Null)
                            {
                                objwrapperforcontractlist.strBucket = String.valueof(objcl.ScCollection_Bucket__c);
                            }
                            if(ScCollection_UtilityHandler.isNotNull(objcl.Queue_Contracts__r))
                            {
                                if(objcl.Queue_Contracts__r[0].ScCollection_Follow_Up_Date__c != Null)
                                {
                                    objwrapperforcontractlist.strReviewDate = objcl.Queue_Contracts__r[0].ScCollection_Follow_Up_Date__c.format();             
                                }
                                if(objcl.Queue_Contracts__r[0].collect__Follow_Up_Date__c != Null)
                                {
                                    objwrapperforcontractlist.strAssignDate = objcl.Queue_Contracts__r[0].collect__Follow_Up_Date__c.format();             
                                }
                                objwrapperforcontractlist.strAssignee = objcl.Queue_Contracts__r[0].ScCollection_Contract_Owner__c;
                                objwrapperforcontractlist.strQueueName = objcl.Queue_Contracts__r[0].collect__Queue__r.Name;
                            }
                            
                            lstContracts.add(objwrapperforcontractlist);
                        }
                    }
                }
                else
                {
                    lstplaccounts = [select Id,
                                            Name,
                                            loan__Account__c,
                                            ScCollection_Customer_Name__c,
                                            loan__Next_Installment_Date__c,
                                            loan__Amount_to_Current__c,
                                            loan__Loan_Balance__c,
                                            loan__Loan_Status__c,
                                            (select collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Owner__c, collect__Queue__r.Name from Queue_Contracts__r where collect__Status__c = 'Open') 
                                            from
                                            loan__Loan_account__c
                                            where Name =: stringinput];
                    
                    if(ScCollection_UtilityHandler.isNotNull(lstplaccounts))
                    {   
                        for(loan__Loan_account__c objpl : lstplaccounts)
                        {
                            if(objpl.loan__Account__c != Null)
                            {
                                setAccIds.add(objpl.loan__Account__c);    
                            }
                        }
                        
                        if(ScCollection_UtilityHandler.isNotNull(setAccIds))
                        {
                            for(Account objacc : [select Id, (select Id, State__c from Residential_Address__r where Current_Address__c = true limit 1) from Account where Id IN : setAccIds])
                            {
                                if(objacc.Residential_Address__r != Null && objacc.Residential_Address__r.size() > 0)
                                {
                                    for(Residential_Address__c objadd : objacc.Residential_Address__r)
                                    {
                                        if(objadd.State__c != Null)
                                        {
                                            mapContractToState.put(objacc.Id,objadd.State__c);
                                        }
                                    }
                                }
                            }
                        }
                                                                  
                        for(loan__Loan_account__c objpl : lstplaccounts)
                        {
                            if(ScCollection_UtilityHandler.isNotNull(objpl.Queue_Contracts__r) && objpl.Queue_Contracts__r.size() > 1)
                            {
                                for(collect__Queue_Contract__c objqc : objpl.Queue_Contracts__r)
                                {
                                    wrapperForContractList objwrapperforcontractlist = new wrapperForContractList();
                                
                                    objwrapperforcontractlist.strContractId = objpl.Id;
                                    objwrapperforcontractlist.strContractNo = objpl.Name;
                                    objwrapperforcontractlist.strCustomerName = objpl.ScCollection_Customer_Name__c;
                                    
                                    if(objpl.loan__Account__c != Null && mapContractToState.containsKey(objpl.loan__Account__c) && mapContractToState.get(objpl.loan__Account__c) != Null)
                                    {
                                        objwrapperforcontractlist.strCustomerState = mapContractToState.get(objpl.loan__Account__c);
                                    }
                                    
                                    if(objqc.ScCollection_Follow_Up_Date__c != Null)
                                    {
                                        objwrapperforcontractlist.strReviewDate = objqc.ScCollection_Follow_Up_Date__c.format();         
                                    }
                                    if(objqc.collect__Follow_Up_Date__c != Null)
                                    {
                                        objwrapperforcontractlist.strAssignDate = objqc.collect__Follow_Up_Date__c.format();         
                                    }
                                    objwrapperforcontractlist.strAssignee = objqc.ScCollection_Contract_Owner__c;
                                    objwrapperforcontractlist.strQueueName = objqc.collect__Queue__r.Name;
                                    
                                    if(objpl.loan__Loan_Status__c != Null)
                                    {
                                        objwrapperforcontractlist.strContractStatus = objpl.loan__Loan_Status__c;    
                                    }
                                    if(objpl.loan__Amount_to_Current__c != Null)
                                    {
                                        objwrapperforcontractlist.strArrearsAmount = String.valueof(objpl.loan__Amount_to_Current__c);
                                    }  
                                    if(objpl.loan__Loan_Balance__c != Null)
                                    {
                                        objwrapperforcontractlist.strBalanceAmount = String.valueof(objpl.loan__Loan_Balance__c);
                                    }
                                    if(objpl.loan__Next_Installment_Date__c != Null)
                                    {
                                        objwrapperforcontractlist.strNextDueDate = String.valueOf(objpl.loan__Next_Installment_Date__c.day());
                                    }
                                                                        
                                    lstContracts.add(objwrapperforcontractlist);
                                }
                            }    
                            else
                            {
                                wrapperForContractList objwrapperforcontractlist = new wrapperForContractList();
                                
                                objwrapperforcontractlist.strContractId = objpl.Id;
                                objwrapperforcontractlist.strContractNo = objpl.Name;
                                objwrapperforcontractlist.strCustomerName = objpl.ScCollection_Customer_Name__c;
                                
                                if(objpl.loan__Account__c != Null && mapContractToState.containsKey(objpl.loan__Account__c) && mapContractToState.get(objpl.loan__Account__c) != Null)
                                {
                                    objwrapperforcontractlist.strCustomerState = mapContractToState.get(objpl.loan__Account__c);
                                }
                                                                
                                if(objpl.loan__Loan_Status__c != Null)
                                {
                                    objwrapperforcontractlist.strContractStatus = objpl.loan__Loan_Status__c;    
                                }
                                if(objpl.loan__Amount_to_Current__c != Null)
                                {
                                    objwrapperforcontractlist.strArrearsAmount = String.valueof(objpl.loan__Amount_to_Current__c);
                                }  
                                if(objpl.loan__Loan_Balance__c != Null)
                                {
                                    objwrapperforcontractlist.strBalanceAmount = String.valueof(objpl.loan__Loan_Balance__c);
                                }
                                if(objpl.loan__Next_Installment_Date__c != Null)
                                {
                                    objwrapperforcontractlist.strNextDueDate = String.valueOf(objpl.loan__Next_Installment_Date__c.day());
                                }
                                if(ScCollection_UtilityHandler.isNotNull(objpl.Queue_Contracts__r))
                                {
                                    if(objpl.Queue_Contracts__r[0].ScCollection_Follow_Up_Date__c != Null)
                                    {
                                        objwrapperforcontractlist.strReviewDate = objpl.Queue_Contracts__r[0].ScCollection_Follow_Up_Date__c.format();         
                                    }
                                    if(objpl.Queue_Contracts__r[0].collect__Follow_Up_Date__c != Null)
                                    {
                                        objwrapperforcontractlist.strAssignDate = objpl.Queue_Contracts__r[0].collect__Follow_Up_Date__c.format();         
                                    }
                                    objwrapperforcontractlist.strAssignee = objpl.Queue_Contracts__r[0].ScCollection_Contract_Owner__c;
                                    objwrapperforcontractlist.strQueueName = objpl.Queue_Contracts__r[0].collect__Queue__r.Name;
                                }
                                
                                lstContracts.add(objwrapperforcontractlist);
                            }
                        }
                    }
                }
            }
            else if(strselectedfield == VAR_CUSTOMERNAME && String.isNotEmpty(stringinput))
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setqueueid';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND (ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c LIKE \'%' + stringinput + '%\' OR ScCollection_CL_Contract__r.ScCollection_Customer_Name__c LIKE \'%' + stringinput + '%\') ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';
            }
            else if(strselectedField == VAR_CUSTOMERSTATE && String.isNotEmpty(stringinput))
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                     strquery += ' AND collect__Queue__c IN : setqueueid'; 
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND (ScCollection_Dev_Contract__r.ScCollection_Customer_State__c LIKE \'%' + stringinput + '%\' OR ScCollection_CL_Contract__r.ScCollection_Customer_State__c LIKE \'%' + stringinput + '%\') ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';
            }
            else if(strselectedfield == VAR_DUEDATE && String.isNotEmpty(stringinput))
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                     strquery += ' AND collect__Queue__c IN : setqueueid';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND ScCollection_Due_Date__c = \'' + stringinput + '\' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';                    
            }
            else if(strselectedfield == VAR_ARREARAMOUNT && String.isNotEmpty(minamountinput) && String.isNotEmpty(maxamountinput))
            {
                String strminamount = minamountinput;
                String strmaxamount = maxamountinput;

                if(minamountinput.indexOf('.') == -1)
                {
                    strminamount += '.00';
                }
                else if(minamountinput.indexOf('.') == minamountinput.length()-1)
                {
                    strminamount += '00';
                }

                if(maxamountinput.indexOf('.') == -1)
                {
                    strmaxamount += '.00';
                }
                else if(maxamountinput.indexOf('.') == maxamountinput.length()-1)
                {
                    strmaxamount += '00';    
                }
                
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setQueueId';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND ScCollection_Arrears__c >= ' + strminamount + ' AND ScCollection_Arrears__c <= ' + strmaxamount + ' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';
            }
            else if(strselectedfield == VAR_BALANCEAMOUNT && String.isNotEmpty(minamountinput) && String.isNotEmpty(maxamountinput))
            {
                String strminamount = minamountinput;
                String strmaxamount = maxamountinput;

                if(minamountinput.indexOf('.') == -1)
                {
                    strminamount += '.00';
                }
                else if(minamountinput.indexOf('.') == minamountinput.length()-1)
                {
                    strminamount += '00';
                }

                if(maxamountinput.indexOf('.') == -1)
                {
                    strmaxamount += '.00';
                }
                else if(maxamountinput.indexOf('.') == maxamountinput.length()-1)
                {
                    strmaxamount += '00';    
                }

                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setQueueId';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND ScCollection_Balance_Amount__c >= ' + strminamount + ' AND ScCollection_Balance_Amount__c <= ' + strmaxamount + ' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';
            }
            else if(strselectedfield == VAR_BUCKET && String.isNotEmpty(stringinput))
            {   
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                 
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setQueueId';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND ScCollection_Bucket__c = ' + stringinput + ' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';                    
            }
            else if(strselectedfield == VAR_CONTRACTSTATUS && String.isNotEmpty(stringinput))
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setqueueid';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND ScCollection_Contract_Status__c LIKE \'%' + stringinput + '%\' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';
            }
            else if(strselectedfield == VAR_ASSIGNDATE && String.isNotEmpty(stringinput))
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setqueueid';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND collect__Follow_Up_Date__c = ' + FormatDate(stringinput) + ' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';                    
            }
            else if(strselectedfield == VAR_REVIEWDATE && String.isNotEmpty(stringinput))
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setqueueid';
                }
                else
                {
                    strquery += ' AND collect__User__c = \'' + UserInfo.getUserId() + '\'';
                }
                
                strquery += ' AND ScCollection_Follow_Up_Date__c = ' + FormatDate(stringinput) + ' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';                    
            }
            else if(strselectedfield == VAR_ASSIGNEE && String.isNotEmpty(stringinput))
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\'';
                
                if(usertype == VAR_MANAGER || usertype == VAR_TL)
                {
                    strquery += ' AND collect__Queue__c IN : setqueueid';
                }
                
                strquery += ' AND collect__User__c = \'' + stringinput + '\' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';                        
            }
            
            system.debug('query++' + strquery);
            List<collect__Queue_Contract__c> lstqc = new List<collect__Queue_Contract__c>();
            
            if(ScCollection_UtilityHandler.isNotNull(strquery))
            {
                lstqc = Database.Query(strquery);
            }
            
            if(ScCollection_UtilityHandler.isNotNull(lstqc))
            {
                for(collect__Queue_Contract__c obj : lstqc)
                {
                    if(obj.ScCollection_CL_Contract__c != Null && obj.ScCollection_CL_Contract__r.loan__Account__c != Null)
                    {
                        setAccIds.add(obj.ScCollection_CL_Contract__r.loan__Account__c);    
                    }
                }
                
                if(ScCollection_UtilityHandler.isNotNull(setAccIds))
                {
                    for(Account objacc : [select Id, (select Id, State__c from Residential_Address__r where Current_Address__c = true limit 1) from Account where Id IN : setAccIds])
                    {
                        if(objacc.Residential_Address__r != Null && objacc.Residential_Address__r.size() > 0)
                        {
                            for(Residential_Address__c objadd : objacc.Residential_Address__r)
                            {
                                if(objadd.State__c != Null)
                                {
                                    mapContractToState.put(objacc.Id,objadd.State__c);
                                }
                            }
                        }
                    }
                }
                
                for(collect__Queue_Contract__c obj : lstqc)
                {
                    wrapperForContractList objwrapperforcontractlist = new wrapperForContractList();
                    
                    if(obj.ScCollection_Follow_Up_Date__c != Null)
                    {
                        objwrapperforcontractlist.strReviewDate = obj.ScCollection_Follow_Up_Date__c.format();     
                    }
                    if(obj.collect__Follow_Up_Date__c != Null)
                    {
                        objwrapperforcontractlist.strAssignDate = obj.collect__Follow_Up_Date__c.format();     
                    }
                    objwrapperforcontractlist.strAssignee = obj.ScCollection_Contract_Owner__c;
                    objwrapperforcontractlist.strQueueName = obj.collect__Queue__r.Name;
                    objwrapperforcontractlist.strContractNo = obj.ScCollection_Contract_Name__c;
                    if(obj.ScCollection_Arrears__c != Null)
                    {
                        objwrapperforcontractlist.strArrearsAmount = String.valueof(obj.ScCollection_Arrears__c);
                    }
                    if(obj.ScCollection_Balance_Amount__c != Null)
                    {
                        objwrapperforcontractlist.strBalanceAmount = String.valueof(obj.ScCollection_Balance_Amount__c);
                    }
                    
                    if(obj.ScCollection_Contract_Status__c != Null)
                    {
                        objwrapperforcontractlist.strContractStatus = obj.ScCollection_Contract_Status__c;    
                    }
                    if(obj.ScCollection_Due_Date__c != Null)
                    {
                        objwrapperforcontractlist.strNextDueDate = obj.ScCollection_Due_Date__c;
                    }
                    if(obj.ScCollection_Bucket__c != Null)
                    {
                        objwrapperforcontractlist.strBucket = String.valueof(obj.ScCollection_Bucket__c);
                    }

                    if(obj.ScCollection_Dev_Contract__c != Null)
                    {
                        objwrapperforcontractlist.strContractId = obj.ScCollection_Dev_Contract__c;
                        objwrapperforcontractlist.strCustomerName = obj.ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c;
                        objwrapperforcontractlist.strCustomerState = obj.ScCollection_Dev_Contract__r.ScCollection_Customer_State__c;                        
                        
                        lstContracts.add(objwrapperforcontractlist);
                    }
                    else if(obj.ScCollection_CL_Contract__c != Null)
                    {
                        objwrapperforcontractlist.strContractId = obj.ScCollection_CL_Contract__c;
                        objwrapperforcontractlist.strCustomerName = obj.ScCollection_CL_Contract__r.ScCollection_Customer_Name__c;
                        
                        if(obj.ScCollection_CL_Contract__r.loan__Account__c != Null && mapContractToState.containsKey(obj.ScCollection_CL_Contract__r.loan__Account__c) && mapContractToState.get(obj.ScCollection_CL_Contract__r.loan__Account__c) != Null)
                        {
                            objwrapperforcontractlist.strCustomerState = mapContractToState.get(obj.ScCollection_CL_Contract__r.loan__Account__c);
                        }
                        
                        lstContracts.add(objwrapperforcontractlist);
                    }
                }
            }
        }
        
        return lstContracts;
    }

    @RemoteAction
    public static List<wrapperForContractList> getListOfContracts(String strqueueid)
    {
        lstContracts = new List<wrapperForContractList>();
        
        if(String.isNotEmpty(strqueueid))
        {    
            String strquery = '';
                               
            if(strqueueid == VAR_ALL)
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\' AND collect__User__c = \'' + UserInfo.getUserId() + '\' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';
            }
            else if(strqueueid == VAR_TODAY)
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\' AND collect__User__c = \'' + UserInfo.getUserId() + '\' AND ScCollection_Follow_Up_Date__c <= TODAY ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';
            }
            else
            {
                strquery += 'select Id, ScCollection_Contract_Owner__c, collect__Queue__r.Name, collect__Follow_Up_Date__c, ScCollection_Follow_Up_Date__c, ScCollection_Contract_Name__c, ScCollection_Balance_Amount__c, ScCollection_Arrears__c, ScCollection_Contract_Status__c, ScCollection_Due_Date__c, ScCollection_Bucket__c, ScCollection_Dev_Contract__c, ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c, ScCollection_Dev_Contract__r.ScCollection_Customer_State__c, ScCollection_CL_Contract__c, ScCollection_CL_Contract__r.ScCollection_Customer_Name__c, ScCollection_CL_Contract__r.loan__Account__c from collect__Queue_Contract__c where collect__Status__c = \'Open\' AND collect__Queue__c = \'' + strqueueid + '\' AND collect__User__c = \'' + UserInfo.getUserId() + '\' ORDER BY ScCollection_Follow_Up_Date__c desc limit 50000';   
            }
            
            system.debug('query++' + strquery);
            List<collect__Queue_Contract__c> lstqc = new List<collect__Queue_Contract__c>();
            Set<Id> setAccIds = new Set<Id>();
            Map<Id,String> mapContractToState = new Map<Id,String>();
            
            if(ScCollection_UtilityHandler.isNotNull(strquery))
            {
                lstqc = Database.Query(strquery);
            }
            
            if(ScCollection_UtilityHandler.isNotNull(lstqc))
            {
                for(collect__Queue_Contract__c obj : lstqc)
                {
                    if(obj.ScCollection_CL_Contract__c != Null && obj.ScCollection_CL_Contract__r.loan__Account__c != Null)
                    {
                        setAccIds.add(obj.ScCollection_CL_Contract__r.loan__Account__c);    
                    }
                }
                
                if(ScCollection_UtilityHandler.isNotNull(setAccIds))
                {
                    for(Account objacc : [select Id, (select Id, State__c from Residential_Address__r where Current_Address__c = true limit 1) from Account where Id IN : setAccIds])
                    {
                        if(objacc.Residential_Address__r != Null && objacc.Residential_Address__r.size() > 0)
                        {
                            for(Residential_Address__c objadd : objacc.Residential_Address__r)
                            {
                                if(objadd.State__c != Null)
                                {
                                    mapContractToState.put(objacc.Id,objadd.State__c);
                                }
                            }
                        }
                    }
                }
                
                for(collect__Queue_Contract__c obj : lstqc)
                {
                    wrapperForContractList objwrapperforcontractlist = new wrapperForContractList();
                    
                    if(obj.ScCollection_Follow_Up_Date__c != Null)
                    {
                        objwrapperforcontractlist.strReviewDate = obj.ScCollection_Follow_Up_Date__c.format();     
                    }
                    if(obj.collect__Follow_Up_Date__c != Null)
                    {
                        objwrapperforcontractlist.strAssignDate = obj.collect__Follow_Up_Date__c.format();     
                    }
                    
                    objwrapperforcontractlist.strAssignee = obj.ScCollection_Contract_Owner__c;
                    objwrapperforcontractlist.strQueueName = obj.collect__Queue__r.Name;
                    objwrapperforcontractlist.strContractNo = obj.ScCollection_Contract_Name__c;
                    
                    if(obj.ScCollection_Arrears__c != Null)
                    {
                        objwrapperforcontractlist.strArrearsAmount = String.valueof(obj.ScCollection_Arrears__c);
                    }
                    
                    if(obj.ScCollection_Balance_Amount__c != Null)
                    {
                        objwrapperforcontractlist.strBalanceAmount = String.valueof(obj.ScCollection_Balance_Amount__c);
                    }
                    
                    if(obj.ScCollection_Contract_Status__c != Null)
                    {
                        objwrapperforcontractlist.strContractStatus = obj.ScCollection_Contract_Status__c;    
                    }
                    
                    if(obj.ScCollection_Due_Date__c != Null)
                    {
                        objwrapperforcontractlist.strNextDueDate = obj.ScCollection_Due_Date__c;
                    }
                    
                    if(obj.ScCollection_Bucket__c != Null)
                    {
                        objwrapperforcontractlist.strBucket = String.valueof(obj.ScCollection_Bucket__c);
                    }

                    if(obj.ScCollection_Dev_Contract__c != Null)
                    {
                        objwrapperforcontractlist.strContractId = obj.ScCollection_Dev_Contract__c;
                        objwrapperforcontractlist.strCustomerName = obj.ScCollection_Dev_Contract__r.ScCollection_Customer_Name__c;
                        objwrapperforcontractlist.strCustomerState = obj.ScCollection_Dev_Contract__r.ScCollection_Customer_State__c;                        
                                                
                        lstContracts.add(objwrapperforcontractlist);
                    }
                    else if(obj.ScCollection_CL_Contract__c != Null)
                    {
                        objwrapperforcontractlist.strContractId = obj.ScCollection_CL_Contract__c;
                        objwrapperforcontractlist.strCustomerName = obj.ScCollection_CL_Contract__r.ScCollection_Customer_Name__c;
                        
                        if(obj.ScCollection_CL_Contract__r.loan__Account__c != Null && mapContractToState.containsKey(obj.ScCollection_CL_Contract__r.loan__Account__c) && mapContractToState.get(obj.ScCollection_CL_Contract__r.loan__Account__c) != Null)
                        {
                            objwrapperforcontractlist.strCustomerState = mapContractToState.get(obj.ScCollection_CL_Contract__r.loan__Account__c);
                        }
                        
                        lstContracts.add(objwrapperforcontractlist);
                    }
                }
            }
        }
        
        return lstContracts;
    }
    
    //method to set the options for the picklist used to filter seach criteria for queue users
    public List<SelectOption> getUserName()
    { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(UserInfo.getUserId(), UserInfo.getName()));
        
        String usertype = [select ScCollection_UserType__c from User where Id =: UserInfo.getUserId()].ScCollection_UserType__c;
        
        if(usertype == VAR_MANAGER || usertype == VAR_TL)
        {
            Set<Id> setqueueid = new Set<Id>();
            
            for(collect__Queue_User__c objquser : [Select collect__Queue__c from collect__Queue_User__c where collect__User__c =: UserInfo.getuserId()])
            {
                setqueueid.add(objquser.collect__Queue__c);
            }
            
            if(ScCollection_UtilityHandler.isNotNull(setqueueid))
            {
                Set<Id> setusers = new Set<Id>();
                
                for(collect__Queue_User__c objquser : [Select collect__User__c, collect__User__r.Name from collect__Queue_User__c where collect__Queue__c IN : setQueueId AND collect__Assignable__c = true])
                {
                    if(setusers.contains(objquser.collect__User__c))    
                    {
                        
                    }
                    else
                    {
                        setusers.add(ObjQuser.collect__User__c);
                        options.add(new SelectOption(objquser.collect__User__c, objquser.collect__User__r.Name));
                    }
                }
            }
        }
        
        return options;  
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