// --------------------------------------------------------------------------------------------------------
// This class handles the logic for the custom vf pages on console top component view for pepper collections
// --------------------------------------------------------------------------------------------------------
// Created Date: 18-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class :  ScCollection_TestCnslTopComponentHandler
// --------------------------------------------------------------------------------------------------------
public class ScCollection_CnslTopComponentHandler
{
    //variables to hold data for the current contract record
    public String strContractId {get;set;}
    public String strContractName {get;set;}
    public String strContractType {get;set;}
    public String strObjectName = '';
    
    //list of wrappers to bind data on visualforce page
    public transient List<wrapperForBorrowerDetails> lstWrapperForBorrowerDetails {get;set;}
    
    private static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    private static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
    private static final String VAR_ATT_NAME = 'Profile Pic%';
    private static final String VAR_IMAGE_BASE_URL = '/servlet/servlet.FileDownload?file=';
    
    public Map<Id,List<wrapperForLoanDetails>> mapothercontracts;
    
    //wrapper to hold info about all the contracts for a particular borrower
    public class wrapperForLoanDetails
    {
        public String strLoanId {get;set;}
        public String strLoanNo {get;set;}
        public String strLoanType {get;set;}
        public String strTitle {get;set;}
        public Boolean IsInArrear {get;set;}
        
        public wrapperForLoanDetails()
        {
            strLoanId = '';
            strLoanNo = '';
            strLoanType = '';
            strTitle = '';
            IsInArrear = false;
        }
    }
    
    //wrapper to hold info about all the borrower associated to current contract
    public class wrapperForBorrowerDetails
    {
        public String strContactId {get;set;}
        public String strContactType {get;set;}
        public String strContactImage {get;set;}
        public String strContactName {get;set;}
        public String strContactMobile {get;set;}
        public String strContactAddress {get;set;}
        public String strContactDOB {get;set;}
        public String strCustomerId {get;set;}
        public String strContactPreference {get;set;}
        public String strPassword {get;set;}
        public String strNoOfContracts {get;set;}
        
        public Boolean isVedaDefault {get;set;}
        public Boolean isATPFlag {get;set;}
        public Boolean isDeceasedFlag {get;set;}
        public Boolean isSkipFlag {get;set;}
        public Boolean isBankruptFlag {get;set;}
        public Boolean isBirthdayToday {get;set;}
        public Boolean isInvalidAddress {get;set;}
        public Boolean isInvalidNumber {get;set;}
        public Boolean isPrimary {get;set;}
        
        public List<wrapperForLoanDetails> lstWrapperForLoanDetails {get;set;} 

        public wrapperForBorrowerDetails()
        {
            strContactId = '';
            strContactType = '';
            strContactImage = 'null';
            strContactName = '';
            strContactMobile = '';
            strContactAddress = '';
            strContactDOB = '';
            strCustomerId = '';
            strContactPreference = '';
            strPassword = '';
            strNoOfContracts = '1';
            
            isVedaDefault = false;
            isATPFlag = false;
            isDeceasedFlag = false;
            isSkipFlag = false;
            isBankruptFlag = false;
            isBirthdayToday = false;
            isInvalidAddress = false; 
            isInvalidNumber = false;
            isPrimary = false;

            lstWrapperForLoanDetails = new List<wrapperForLoanDetails>();
        }
    }
    
    //constructor for variable initialization
    public ScCollection_CnslTopComponentHandler()
    {
        strContractId = '';
        strContractName = '';
        strContractType = '';
        lstWrapperForBorrowerDetails = new List<wrapperForBorrowerDetails>();
        mapothercontracts = new Map<Id,List<wrapperForLoanDetails>>();
        
        //get the Id from url parameter
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id')))
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
            
            //call common method to retrieve object name
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
        }
        
        //call methods to populate data on vf pages
        ProcessDataForTopComponent();
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the data process for console top component
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void ProcessDataForTopComponent()
    {
        if(ScCollection_UtilityHandler.isNotNull(strObjectName))
        {
            if(strObjectName == VAR_PLCONTRACT_API)
            {
                strContractType = 'CL Loan';

                //get the fields from pl contract to fill in wrapper list
                List<loan__Loan_Account__c> lstplcontract = [select Id, 
                                                                    ScCollection_Customer_Id__c, 
                                                                    ScCollection_Customer_Name__c,
                                                                    ScCollection_Customer_Contact_No__c,
                                                                    ScCollection_Customer_Birth_Date__c,
                                                                    ScCollection_Customer_External_Id__c,
                                                                    ScCollection_Customer_Preference__c,
                                                                    ScCollection_Customer_Password__c,
                                                                    ScCollection_is_Veda_Default__c,
                                                                    ScCollection_is_ATP__c,
                                                                    ScCollection_is_Deceased__c,
                                                                    ScCollection_is_Skip__c,
                                                                    ScCollection_is_Bankrupt__c,
                                                                    ScCollection_Is_Invalid_No__c,
                                                                    ScCollection_Is_Invalid_Address__c
                                                                    from loan__Loan_Account__c 
                                                                    where Id =: strContractId];
                
                if(ScCollection_UtilityHandler.isNotNull(lstplcontract))
                {
                    Set<String> setparentids = new Set<String>();
                    Map<Id,String> mapcontacttoimage = new Map<Id,String>();
                    Map<Id,String> mapContractToState = new Map<Id,String>();
                    
                    for(loan__Loan_Account__c obj : lstplcontract)
                    {
                        if(obj.ScCollection_Customer_Id__c != '' && obj.ScCollection_Customer_Id__c != Null)
                        {
                            setparentids.add(obj.ScCollection_Customer_Id__c);
                        }
                    }
                    
                    if(ScCollection_UtilityHandler.isNotNull(setparentids))
                    {
                        PopulateWrapperForLoanDetails(setparentids);

                        for(Attachment obj : [select Id, ParentId from Attachment where Name Like : VAR_ATT_NAME AND ParentId IN : setparentids])
                        {
                            String strurl = VAR_IMAGE_BASE_URL + obj.Id;
                            mapcontacttoimage.put(obj.ParentId,strurl);
                        }
                        
                        for(Account objacc : [select Id, (select Id, Address__c,Unit_Number__c,Street_Number__c,Street_Name__c,Street_Type__c,Suburb__c,State__c,Country__c,PostCode__c from Residential_Address__r where Current_Address__c = true limit 1) from Account where Id IN : setparentids])
                        {
                            if(objacc.Residential_Address__r != Null && objacc.Residential_Address__r.size() > 0)
                            {system.debug('objacc.Residential_Address__r'+objacc.Residential_Address__r);
                                for(Residential_Address__c objadd : objacc.Residential_Address__r)
                                {
                                    if(objadd.Address__c != Null)
                                    {
                                        mapContractToState.put(objacc.Id,objadd.Address__c);
                                    }
                                    else{
                                        String strAddress = '';
                                        if(objadd.Unit_Number__c != null){
                                            strAddress += objadd.Unit_Number__c +' ';
                                        }
                                        if(objadd.Street_Number__c != null){
                                            strAddress += objadd.Street_Number__c +' ';
                                        }
                                        if(objadd.Street_Name__c != null){
                                            strAddress += objadd.Street_Name__c +' ';
                                        }
                                        if(objadd.Street_Type__c != null){
                                            strAddress += objadd.Street_Type__c +' ';
                                        }
                                        if(objadd.Suburb__c != null){
                                            strAddress += objadd.Suburb__c+',';
                                        }
                                        else{
                                            strAddress +=',';
                                        }
                                        if(objadd.State__c != null){
                                            strAddress += objadd.State__c+',';
                                        }
                                        if(objadd.Country__c != null){
                                            strAddress += objadd.Country__c +',';
                                        }
                                        if(objadd.PostCode__c != null){
                                            strAddress += objadd.PostCode__c;
                                        }
                                        else{
                                            strAddress = strAddress.removeEnd(',');
                                        }
                                        
                                        strAddress = strAddress.Trim();
                                        mapContractToState.put(objacc.Id,strAddress);
                                    }
                                }
                            }
                        }
                    }
                    
                    for(loan__Loan_Account__c obj : lstplcontract)
                    {
                        wrapperForBorrowerDetails objwrapperforborrowerdetails = new wrapperForBorrowerDetails();
                        
                        objwrapperforborrowerdetails.strContactId = obj.ScCollection_Customer_Id__c;
                        objwrapperforborrowerdetails.strContactType = 'Primary Borrower';
                        objwrapperforborrowerdetails.isPrimary = true;
                        objwrapperforborrowerdetails.strContactName = obj.ScCollection_Customer_Name__c;
                        objwrapperforborrowerdetails.strContactMobile = obj.ScCollection_Customer_Contact_No__c;
                        
                        if(obj.ScCollection_Customer_Id__c != Null && mapContractToState.containsKey(obj.ScCollection_Customer_Id__c) && mapContractToState.get(obj.ScCollection_Customer_Id__c) != Null)
                        {
                            objwrapperforborrowerdetails.strContactAddress = mapContractToState.get(obj.ScCollection_Customer_Id__c);
                        }
                        
                        if(obj.ScCollection_Customer_Birth_Date__c != Null)
                        {
                            objwrapperforborrowerdetails.strContactDOB = obj.ScCollection_Customer_Birth_Date__c.format();    
                        }
                        
                        objwrapperforborrowerdetails.strCustomerId = obj.ScCollection_Customer_External_Id__c;
                        objwrapperforborrowerdetails.strContactPreference = obj.ScCollection_Customer_Preference__c;
                        objwrapperforborrowerdetails.strPassword = obj.ScCollection_Customer_Password__c;
                                                
                        objwrapperforborrowerdetails.isVedaDefault = obj.ScCollection_is_Veda_Default__c;
                        objwrapperforborrowerdetails.isATPFlag = obj.ScCollection_is_ATP__c;
                        objwrapperforborrowerdetails.isDeceasedFlag = obj.ScCollection_is_Deceased__c;
                        objwrapperforborrowerdetails.isSkipFlag = obj.ScCollection_is_Skip__c;
                        objwrapperforborrowerdetails.isBankruptFlag = obj.ScCollection_is_Bankrupt__c;
                        
                        if(obj.ScCollection_Customer_Birth_Date__c != Null && obj.ScCollection_Customer_Birth_Date__c.day() == System.Today().day() && obj.ScCollection_Customer_Birth_Date__c.month() == System.Today().month())
                        {
                            objwrapperforborrowerdetails.isBirthdayToday = true;
                        }
                        
                        objwrapperforborrowerdetails.isInvalidAddress = obj.ScCollection_Is_Invalid_Address__c;
                        objwrapperforborrowerdetails.isInvalidNumber = obj.ScCollection_Is_Invalid_No__c;
                        
                        if(mapcontacttoimage.containsKey(obj.ScCollection_Customer_Id__c) && mapcontacttoimage.get(obj.ScCollection_Customer_Id__c) != Null)
                        {
                            objwrapperforborrowerdetails.strContactImage = mapcontacttoimage.get(obj.ScCollection_Customer_Id__c);
                        }

                        if(mapothercontracts.containsKey(obj.ScCollection_Customer_Id__c) && mapothercontracts.get(obj.ScCollection_Customer_Id__c) != Null)
                        {
                            objwrapperforborrowerdetails.lstWrapperForLoanDetails = mapothercontracts.get(obj.ScCollection_Customer_Id__c);    
                            objwrapperforborrowerdetails.strNoOfContracts = String.valueof(objwrapperforborrowerdetails.lstWrapperForLoanDetails.size() + 1);
                        }
                        
                        lstWrapperForBorrowerDetails.add(objwrapperforborrowerdetails);
                    }
                }
            }
            else if(strObjectName == VAR_CLCONTRACT_API)
            {
                List<wrapperForBorrowerDetails> lstTempWrapper = new List<wrapperForBorrowerDetails>();
                List<wrapperForBorrowerDetails> lstPrimaryWrapper = new List<wrapperForBorrowerDetails>();
                List<collect__Loan_Account__c> lstOtherContracts = new List<collect__Loan_Account__c>();
                String strExternalId = '';
                
                for(collect__Loan_Account__c obj : [select Id, collect__External_ID__c, ScCollection_Source_System_Name__c from collect__Loan_Account__c where Id =: strContractId])
                {
                    if(obj.ScCollection_Source_System_Name__c != Null && obj.ScCollection_Source_System_Name__c == 'PAF')
                    {
                        strExternalId = obj.collect__External_ID__c;
                    }
                    else if(obj.ScCollection_Source_System_Name__c != Null && obj.ScCollection_Source_System_Name__c == 'MORTGAGE')
                    {
                        List<String> lstExternalId = obj.collect__External_ID__c.split('_');
                        String strMatch = lstExternalId[0] + '__';
                        
                        if(lstExternalId[1] == '0')
                        {
                            strExternalId = obj.collect__External_ID__c;  
                            lstOtherContracts = [select Id, Name, ScCollection_Arrears__c, ScCollection_Bucket__c from collect__Loan_Account__c where Id !=: strContractId AND collect__External_ID__c LIKE : strMatch];  
                        }
                        else
                        {
                            strExternalId = lstExternalId[0] + '_0';
                            lstOtherContracts = [select Id, Name, ScCollection_Arrears__c, ScCollection_Bucket__c from collect__Loan_Account__c where Id !=: strContractId AND collect__External_ID__c !=: strExternalId AND collect__External_ID__c LIKE : strMatch];  
                        }
                    }
                }
                
                //get the fields from cl contract to fill in wrapper list
                List<collect__Loan_Account__c> lstclcontract = [select Id, 
                                                                       ScCollection_Source_System_Name__c,
                                                                       (select Id,
                                                                               clcommon__Type__r.Name,
                                                                               clcommon__isPrimary__c,
                                                                               ScCollection_Customer_Id__c, 
                                                                               ScCollection_Customer_Name__c,
                                                                               ScCollection_Customer_Contact_No__c,
                                                                               ScCollection_Customer_Mailing_Address__c,
                                                                               ScCollection_Customer_Birth_Date__c,
                                                                               ScCollection_Customer_External_Id__c,
                                                                               ScCollection_Customer_Preference__c,
                                                                               ScCollection_Customer_Password__c,
                                                                               ScCollection_is_Veda_Default__c,
                                                                               ScCollection_is_ATP__c,
                                                                               ScCollection_is_Deceased__c,
                                                                               ScCollection_is_Skip__c,
                                                                               ScCollection_is_Bankrupt__c,
                                                                               ScCollection_Is_Invalid_No__c,
                                                                               ScCollection_Is_Invalid_Address__c
                                                                               from collect__Parties__r where ScCollection_Active__c = true)
                                                                       from collect__Loan_Account__c 
                                                                       where collect__External_ID__c =: strExternalId];
                
                if(ScCollection_UtilityHandler.isNotNull(lstclcontract))
                {
                    strContractType = lstclcontract[0].ScCollection_Source_System_Name__c;

                    Set<String> setparentids = new Set<String>();
                    Set<Id> setpartyids = new Set<Id>();
                    Map<Id,String> mapcontacttoimage = new Map<Id,String>();
                    Map<Id,collect__Contact_Preference__c> mappartytopreference = new Map<Id,collect__Contact_Preference__c>();
                    
                    for(collect__Loan_Account__c obj : lstclcontract)
                    {
                        for(clcommon__Party__c objparty : obj.collect__Parties__r)
                        {
                            setpartyids.add(objparty.Id);

                            if(objparty.ScCollection_Customer_Id__c != '' && objparty.ScCollection_Customer_Id__c != Null)
                            {
                                setparentids.add(objparty.ScCollection_Customer_Id__c);
                                
                                if(ScCollection_UtilityHandler.isNotNull(lstOtherContracts))
                                {
                                    for(collect__Loan_Account__c objcnt : lstOtherContracts)
                                    {
                                        wrapperForLoanDetails objwrapperforloandetails = new wrapperForLoanDetails();
                                        objwrapperforloandetails.strLoanId = objcnt.Id;
                                        objwrapperforloandetails.strLoanType = 'MORTGAGE';
                                        objwrapperforloandetails.strLoanNo = objcnt.Name;
                                        objwrapperforloandetails.strTitle = objparty.clcommon__Type__r.Name;
                
                                        if(objcnt.ScCollection_Bucket__c != Null && objcnt.ScCollection_Bucket__c > 0)
                                        {
                                            objwrapperforloandetails.strTitle += ', Bucket - ' + objcnt.ScCollection_Bucket__c;    
                                            
                                            if(objcnt.ScCollection_Arrears__c != Null && objcnt.ScCollection_Arrears__c > 0)
                                            {
                                                objwrapperforloandetails.IsInArrear = true;    
                                            }
                                        }
                                        else
                                        {
                                            objwrapperforloandetails.strTitle += ', Bucket - 0';    
                                        }
                                        
                                        if(objcnt.ScCollection_Arrears__c != Null && objcnt.ScCollection_Arrears__c > 0)
                                        {
                                            objwrapperforloandetails.strTitle += ', Arrear - $ ' + objcnt.ScCollection_Arrears__c;
                                        }
                                        else
                                        {
                                            objwrapperforloandetails.strTitle += ', Arrear - $ 0.00';
                                        }
                                                                
                                        List<wrapperForLoanDetails> lsttemp = new List<wrapperForLoanDetails>();
                        
                                        if(mapothercontracts.containsKey(objparty.ScCollection_Customer_Id__c) && mapothercontracts.get(objparty.ScCollection_Customer_Id__c) != Null)
                                        {
                                            lsttemp = mapothercontracts.get(objparty.ScCollection_Customer_Id__c);
                                        }
                        
                                        lsttemp.add(objwrapperforloandetails);
                                        mapothercontracts.put(objparty.ScCollection_Customer_Id__c, lsttemp);
                                    }
                                }
                            }
                        }
                    }
                    
                    if(ScCollection_UtilityHandler.isNotNull(setpartyids))
                    {
                        for(collect__Contact_Preference__c obj : [select Id, collect__Party__c, collect__Mode_of_Communication__c, collect__Start_Time__c, collect__End_Time__c from collect__Contact_Preference__c where collect__Preferred__c = true AND collect__Mode_of_Communication__c != Null AND collect__Party__c IN : setpartyids])
                        {
                            mappartytopreference.put(obj.collect__Party__c, obj);
                        }
                    }
                    
                    if(ScCollection_UtilityHandler.isNotNull(setparentids))
                    {
                        PopulateWrapperForLoanDetails(setparentids);
                        
                        for(Attachment obj : [select Id, ParentId from Attachment where Name Like : VAR_ATT_NAME AND ParentId IN : setparentids])
                        {
                            String strurl = VAR_IMAGE_BASE_URL + obj.Id;
                            mapcontacttoimage.put(obj.ParentId,strurl);
                        }
                    }
                    
                    for(collect__Loan_Account__c obj : lstclcontract)
                    {
                        for(clcommon__Party__c objparty : obj.collect__Parties__r)
                        {
                            wrapperForBorrowerDetails objwrapperforborrowerdetails = new wrapperForBorrowerDetails();
                        
                            objwrapperforborrowerdetails.strContactId = objparty.ScCollection_Customer_Id__c;
                            objwrapperforborrowerdetails.strContactType = objparty.clcommon__Type__r.Name;
                            objwrapperforborrowerdetails.isPrimary = objparty.clcommon__isPrimary__c;
                            objwrapperforborrowerdetails.strContactName = objparty.ScCollection_Customer_Name__c;
                            objwrapperforborrowerdetails.strContactMobile = objparty.ScCollection_Customer_Contact_No__c;
                            objwrapperforborrowerdetails.strContactAddress = objparty.ScCollection_Customer_Mailing_Address__c;

                            if(objparty.ScCollection_Customer_Birth_Date__c != Null)
                            {
                                objwrapperforborrowerdetails.strContactDOB = objparty.ScCollection_Customer_Birth_Date__c.format();    
                            }
                            
                            objwrapperforborrowerdetails.strCustomerId = objparty.ScCollection_Customer_External_Id__c;
                            objwrapperforborrowerdetails.strPassword = objparty.ScCollection_Customer_Password__c;

                            if(mappartytopreference.containsKey(objparty.Id) && mappartytopreference.get(objparty.Id) != Null)
                            {
                                objwrapperforborrowerdetails.strContactPreference = mappartytopreference.get(objparty.Id).collect__Mode_of_Communication__c;    

                                if(mappartytopreference.get(objparty.Id).collect__Start_Time__c != Null && mappartytopreference.get(objparty.Id).collect__End_Time__c != Null)
                                {
                                    objwrapperforborrowerdetails.strContactPreference += ' (' + mappartytopreference.get(objparty.Id).collect__Start_Time__c.format('hh a') + ' - ' + mappartytopreference.get(objparty.Id).collect__End_Time__c.format('hh a') + ')';
                                }
                            }
                                                    
                            objwrapperforborrowerdetails.isVedaDefault = objparty.ScCollection_is_Veda_Default__c;
                            objwrapperforborrowerdetails.isATPFlag = objparty.ScCollection_is_ATP__c;
                            objwrapperforborrowerdetails.isDeceasedFlag = objparty.ScCollection_is_Deceased__c;
                            objwrapperforborrowerdetails.isSkipFlag = objparty.ScCollection_is_Skip__c;
                            objwrapperforborrowerdetails.isBankruptFlag = objparty.ScCollection_is_Bankrupt__c;
                            
                            if(objparty.ScCollection_Customer_Birth_Date__c != Null && objparty.ScCollection_Customer_Birth_Date__c.day() == System.Today().day() && objparty.ScCollection_Customer_Birth_Date__c.month() == System.Today().month())
                            {
                                objwrapperforborrowerdetails.isBirthdayToday = true;
                            }
                            
                            objwrapperforborrowerdetails.isInvalidAddress = objparty.ScCollection_Is_Invalid_Address__c;
                            objwrapperforborrowerdetails.isInvalidNumber = objparty.ScCollection_Is_Invalid_No__c;
                            
                            if(mapcontacttoimage.containsKey(objparty.ScCollection_Customer_Id__c) && mapcontacttoimage.get(objparty.ScCollection_Customer_Id__c) != Null)
                            {
                                objwrapperforborrowerdetails.strContactImage = mapcontacttoimage.get(objparty.ScCollection_Customer_Id__c);
                            }

                            if(mapothercontracts.containsKey(objparty.ScCollection_Customer_Id__c) && mapothercontracts.get(objparty.ScCollection_Customer_Id__c) != Null)
                            {
                                objwrapperforborrowerdetails.lstWrapperForLoanDetails = mapothercontracts.get(objparty.ScCollection_Customer_Id__c);    
                                objwrapperforborrowerdetails.strNoOfContracts = String.valueof(objwrapperforborrowerdetails.lstWrapperForLoanDetails.size() + 1);
                            }

                            if(objparty.clcommon__isPrimary__c)
                            {
                                lstWrapperForBorrowerDetails.add(objwrapperforborrowerdetails);
                            }
                            else if(objparty.clcommon__Type__r.Name == 'Primary Borrower')
                            {
                                lstPrimaryWrapper.add(objwrapperforborrowerdetails);
                            }
                            else
                            {
                                lstTempWrapper.add(objwrapperforborrowerdetails);
                            }
                        }
                    }

                    if(lstPrimaryWrapper != Null && lstPrimaryWrapper.size() > 0)
                    {
                        lstWrapperForBorrowerDetails.addAll(lstPrimaryWrapper);
                    }
                    
                    if(lstWrapperForBorrowerDetails != Null && lstWrapperForBorrowerDetails.size() > 0)
                    {
                        if(lstTempWrapper != Null && lstTempWrapper.size() > 0)
                        {
                            lstWrapperForBorrowerDetails.addAll(lstTempWrapper);
                        }
                    }
                }
            }
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic to return list of other contracts for a borrower
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 23-SEP-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void PopulateWrapperForLoanDetails(Set<String> setborrowerid)
    {
        if(ScCollection_UtilityHandler.isNotNull(setborrowerid))
        {
            for(loan__Loan_Account__c obj : [select Id, 
                                                    Name,
                                                    loan__Number_of_Days_Overdue__c,
                                                    loan__Amount_to_Current__c,
                                                    ScCollection_Customer_Id__c
                                                    from loan__Loan_Account__c 
                                                    where Id !=: strContractId AND 
                                                    ScCollection_Customer_Id__c IN: setborrowerid])
            {
                wrapperForLoanDetails objwrapperforloandetails = new wrapperForLoanDetails();
                objwrapperforloandetails.strLoanId = obj.Id;
                objwrapperforloandetails.strLoanType = 'CL Loan';
                objwrapperforloandetails.strLoanNo = obj.Name;
                objwrapperforloandetails.strTitle = 'Primary Borrower';
                
                if(obj.loan__Number_of_Days_Overdue__c != Null && obj.loan__Number_of_Days_Overdue__c > 0)
                {
                    objwrapperforloandetails.strTitle += ', DPD - ' + obj.loan__Number_of_Days_Overdue__c;
                    
                    if(obj.loan__Amount_to_Current__c != Null && obj.loan__Amount_to_Current__c > 0)
                    {
                        objwrapperforloandetails.IsInArrear = true;
                    }
                }
                else
                {
                    objwrapperforloandetails.strTitle += ', DPD - 0';
                }
                
                if(obj.loan__Amount_to_Current__c != Null && obj.loan__Amount_to_Current__c > 0)
                {
                    objwrapperforloandetails.strTitle += ', Arrear - $ ' + obj.loan__Amount_to_Current__c;
                }
                else
                {
                    objwrapperforloandetails.strTitle += ', Arrear - $ 0.00';
                }
                
                List<wrapperForLoanDetails> lsttemp = new List<wrapperForLoanDetails>();

                if(mapothercontracts.containsKey(obj.ScCollection_Customer_Id__c) && mapothercontracts.get(obj.ScCollection_Customer_Id__c) != Null)
                {
                    lsttemp = mapothercontracts.get(obj.ScCollection_Customer_Id__c);
                }

                lsttemp.add(objwrapperforloandetails);
                mapothercontracts.put(obj.ScCollection_Customer_Id__c, lsttemp);
            }

            for(clcommon__Party__c obj : [select Id, 
                                                 ScCollection_Customer_Id__c,
                                                 clcommon__Type__r.Name,
                                                 collect__CL_Contract__c,
                                                 collect__CL_Contract__r.Name,
                                                 collect__CL_Contract__r.ScCollection_Source_System_Name__c,
                                                 collect__CL_Contract__r.ScCollection_Arrears__c,
                                                 collect__CL_Contract__r.ScCollection_Bucket__c
                                                 from clcommon__Party__c 
                                                 where ScCollection_Active__c = true AND
                                                 collect__CL_Contract__c != Null AND
                                                 collect__CL_Contract__c !=: strContractId AND 
                                                 ScCollection_Customer_Id__c IN: setborrowerid])
            {
                wrapperForLoanDetails objwrapperforloandetails = new wrapperForLoanDetails();
                objwrapperforloandetails.strLoanId = obj.collect__CL_Contract__c;
                objwrapperforloandetails.strLoanType = obj.collect__CL_Contract__r.ScCollection_Source_System_Name__c;
                objwrapperforloandetails.strLoanNo = obj.collect__CL_Contract__r.Name;
                objwrapperforloandetails.strTitle = obj.clcommon__Type__r.Name;
                
                if(obj.collect__CL_Contract__r.ScCollection_Bucket__c != Null && obj.collect__CL_Contract__r.ScCollection_Bucket__c > 0)
                {
                    objwrapperforloandetails.strTitle += ', Bucket - ' + obj.collect__CL_Contract__r.ScCollection_Bucket__c;    
                    
                    if(obj.collect__CL_Contract__r.ScCollection_Arrears__c != Null && obj.collect__CL_Contract__r.ScCollection_Arrears__c > 0)
                    {
                        objwrapperforloandetails.IsInArrear = true;    
                    }
                }
                else
                {
                    objwrapperforloandetails.strTitle += ', Bucket - 0';    
                }
                
                if(obj.collect__CL_Contract__r.ScCollection_Arrears__c != Null && obj.collect__CL_Contract__r.ScCollection_Arrears__c > 0)
                {
                    objwrapperforloandetails.strTitle += ', Arrear - $ ' + obj.collect__CL_Contract__r.ScCollection_Arrears__c;
                }
                else
                {
                    objwrapperforloandetails.strTitle += ', Arrear - $ 0.00';
                }
                
                List<wrapperForLoanDetails> lsttemp = new List<wrapperForLoanDetails>();

                if(mapothercontracts.containsKey(obj.ScCollection_Customer_Id__c) && mapothercontracts.get(obj.ScCollection_Customer_Id__c) != Null)
                {
                    lsttemp = mapothercontracts.get(obj.ScCollection_Customer_Id__c);
                }

                lsttemp.add(objwrapperforloandetails);
                mapothercontracts.put(obj.ScCollection_Customer_Id__c, lsttemp);
            }
        }
    }
}