// ----------------------------------------------------------------------------------------------------
// This class would be used to show contract status and other important stuff on pl contract inline page section
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestViewStatusPlController
// ----------------------------------------------------------------------------------------------------
public class ScCollection_ViewStatusPlController 
{
    //variable declaration    
    public String statuCreated{get;set;} 
    public String strLoanId;
    public loan__Loan_Account__c objContract;
    public collect__Contract_Status__c objStatus {get;set;}
    public List<wrapperForStatusFields> lstWrapperForStatusFields {get;set;}
    
    // get the map  for the fls
    private static final Map<String,Schema.SObjectField> VAR_STATUSFIELDMAP = Schema.SObjectType.collect__Contract_Status__c.fields.getMap();
    
    private static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    
    public Integer intMonthlyCounter {get;set;}
    public String strMonthlyColorCode {get;set;}
    public Integer intWeeklyCounter {get;set;}
    public String strWeeklyColorCode {get;set;}

    //constructor defined
    public ScCollection_ViewStatusPlController(ApexPages.StandardController controller) 
    {
        //look for contract 
        
        if(!Test.isRunningTest())
        {
            controller.addFields(new string[]{'ScCollection_Collection_Status__c'});
        }
        
        objContract = (loan__Loan_Account__c)controller.getRecord();
        strLoanId = objContract.Id;
        system.debug('@@@strLoanId'+strLoanId);
    }
    
    //this wrapper holds the data for contract status picklist fields
    public class wrapperForStatusFields
    {
        public collect__Status_Config__c objConfig {get;set;}
        public String strSelectedStatus {get;set;}
        public boolean isVisible {get;set;}

        public wrapperForStatusFields()
        {
            objConfig = new collect__Status_Config__c();
            strSelectedStatus = '';
            isVisible = false;
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for inserting status and other data on contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void LookForRelateEntities()
    {
        system.debug('strLoanId'+strLoanId);
        if(String.isNotEmpty(strLoanId))
        {
            if(objContract.ScCollection_Collection_Status__c == Null)
            {
                //insert the collection status
                objStatus = InsertContractStatus(strLoanId);
                statuCreated = 'created'; 
                system.debug('objStatus'+objStatus);
            }
            else
            {
                objStatus = ScCollection_CommonCodeHandler.retriveContractStatusData(strLoanId);
            }
            
            //insert contract setings if not already present
            ScCollection_CommonCodeHandler.retriveContractSettingsData(strLoanId,UserInfo.getUserId());
            
            //call method to populate status data to be shown on page
            PopulateContractStatus();
            
            // showcase counter
            CalculateContactCounter();
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for populating relevant status fields on inline page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void PopulateContractStatus()
    {
        lstWrapperForStatusFields = new List<wrapperForStatusFields>();
        
        List<collect__Status_Config__c> lstconfig = [select Id, 
                                                            collect__Status__c, 
                                                            collect__Status_API_Name__c 
                                                            from collect__Status_Config__c 
                                                            where ScCollection_Source_System_Name__c = 'CL Loan'];
            
        if(ScCollection_UtilityHandler.isNotNull(lstconfig))
        {
            for(collect__Status_Config__c obj : lstconfig)
            {
                wrapperForStatusFields objwrapperforstatusfields = new wrapperForStatusFields();

                objwrapperforstatusfields.objConfig = obj; 
                
                if(VAR_STATUSFIELDMAP.get(obj.collect__Status_API_Name__c).getDescribe().isAccessible())
                {
                    objwrapperforstatusfields.isVisible = true;
                } 

                if(objStatus.get(obj.collect__Status_API_Name__c) != Null)
                {
                    objwrapperforstatusfields.strSelectedStatus = String.valueOf(objStatus.get(obj.collect__Status_API_Name__c));
                }
                else
                {
                    objwrapperforstatusfields.strSelectedStatus = 'None';
                }
                    
                lstWrapperForStatusFields.add(objwrapperforstatusfields);
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for inserting contract status
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public collect__Contract_Status__c InsertContractStatus(String strcontractid)
    {
        if(ScCollection_UtilityHandler.isNotNull(strcontractid))
        {
            ScCollection_ResponseHandler.wrapperForQueryOperation objobjectdata = new ScCollection_ResponseHandler.wrapperForQueryOperation();

            List<loan__Loan_Account__c> lstpl = [select Id,Name,
                                                        loan__Loan_Status__c
                                                        from loan__Loan_Account__c
                                                        where Id =: strcontractid];
            
            if(ScCollection_UtilityHandler.isNotNull(lstpl))
            {
                collect__Contract_Status__c obj = new collect__Contract_Status__c();

                if(ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Active - Bad Standing'))
                {
                    obj.ScCollection_Arrears__c = 'Overdue';
                }
                else if(ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Active - Good Standing') || ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Approved'))
                {
                    obj.Main_Status__c = 'Current';
                }
                else if(ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Active - Matured') || ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Written Off'))
                {
                    obj.ScCollection_Loss_Recoveries__c = 'Loss Recoveries';
                }
                else if(ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Obligations Met'))
                {
                    obj.ScCollection_Misc_Status__c = 'Closed - Maturity';
                }
                else if(ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Premature') || ScCollection_UtilityHandler.getPlainString(lstpl[0].loan__Loan_Status__c) == ScCollection_UtilityHandler.getPlainString('Closed - Refinanced'))
                {
                    obj.ScCollection_Misc_Status__c = 'Closed Early Payout';
                }
                
                obj.ScCollection_LOB_Identifier__c = 'CL Loan';
                obj.ScCollection_Contract_Name__c = lstpl[0].Name;
                system.debug(obj);
                insert obj;
                                
                lstpl[0].ScCollection_Collection_Status__c = obj.Id;
                update lstpl;

                String strWhereClause = 'Id=\'' + obj.Id + '\'';

                objobjectdata = ScCollection_CommonCodeHandler.retriveSalesforceRecords('collect__Contract_Status__c','',strWhereClause,'','');
                    
                if(objobjectdata.lstResultSet != Null && objobjectdata.lstResultSet.size() > 0)
                {
                    return(collect__Contract_Status__c)objobjectdata.lstResultSet[0];
                }
            }                                               
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for updating management notes on contract status on inline page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void UpdateStatus()
    {System.debug('Inside update');
        update objStatus;
    }
    
     // ----------------------------------------------------------------------------------------------------
    // This method showcase weekly/monthly contact counter against contract.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 26-Jan-2017    Created By: Kashish Dwivedi    Email: kashish.dwivedi@saasfocus.com Version: 1.0
    // ----------------------------------------------------------------------------------------------------
    public void CalculateContactCounter()
    {
        system.debug('*****method enter*****'+strLoanId);
        
        // variables intilizing
        map<String, collect__Contract_Collections_Metrics__c> mapIdCounterRecord = new map<String, collect__Contract_Collections_Metrics__c>();
        List<ScCollection_ContactCounterSetting__c> lstCCS = new List<ScCollection_ContactCounterSetting__c>();
        List<collect__Collections_Metrics_Settings__c> lstCMS = new List<collect__Collections_Metrics_Settings__c>();
        Set<String> setCMSName = new Set<String>();
        map<String, Integer> mapCounterTypeCounter = new map<String, Integer>();
        
        // fetch counter records from contract APIs
        collect.API api = collect.APIFactory.getAPI();
        Set<Id> setContractId = new Set <Id>();
        List<collect__Loan_Account__c> lstcon = new List<collect__Loan_Account__c>();
        lstcon = [Select Id from collect__Loan_Account__c where collect__External_ID__c =: strLoanId];
        
        List<collect__Contract_Collections_Metrics__c> lstCCM = new list<collect__Contract_Collections_Metrics__c>();
        if(!lstcon.isEmpty()){
            setContractId.add(lstcon[0].Id);
            Map<Id,SObject> mapObjectData = api.getContracts(setContractId);
            SObject loanContract = mapObjectData.get(lstcon[0].Id);
            lstCCM = (List<collect__Contract_Collections_Metrics__c>)loanContract.getSObjects('collect__Contract_Collections_Metrics__r');
        }
        
        
        if(lstCCM != null){
            for(collect__Contract_Collections_Metrics__c objCCM : lstCCM){
                mapIdCounterRecord.put(objCCM.Name, objCCM);
            }
        }
        
        // fetch values from custom setting 'Collection Metrics Setting'
        lstCMS = collect__Collections_Metrics_Settings__c.getall().values();
        if(lstCMS.size() > 0){
            for(collect__Collections_Metrics_Settings__c objCMS : lstCMS){
                setCMSName.add(objCMS.Name);
            }
        }
        
        // fetch values from custom setting 'Contact Counter Setting'
        lstCCS = ScCollection_ContactCounterSetting__c.getall().values();
        
        if(mapIdCounterRecord.size() > 0){
            if(setCMSName.size() > 0){
                for(string s : setCMSName){
                    boolean isExist = false;
                    for(string str : mapIdCounterRecord.keySet()){
                        String strCCMName = mapIdCounterRecord.get(str).Name.split(':')[1];
                        if(s.containsIgnoreCase(strCCMName)){
                            mapCounterTypeCounter.put(s,integer.valueOf(mapIdCounterRecord.get(str).collect__Contact_Count__c));
                            isExist = true;
                        }
                    }
                    
                    if(!isExist){
                        mapCounterTypeCounter.put(s,0);
                    }
                }
            }
        }
        else{
            if(setCMSName.size() > 0){
                for(string s : setCMSName){
                    mapCounterTypeCounter.put(s,0);
                    mapCounterTypeCounter.put(s,0);
                }
            }
        }
        
        if(mapCounterTypeCounter.size() > 0){
            for(string strCounterType : mapCounterTypeCounter.keyset()){
                if(strCounterType.containsIgnoreCase('Month')){
                    intMonthlyCounter = mapCounterTypeCounter.get(strCounterType);
                    strMonthlyColorCode = '#515F6b'; // default color code
                    if(lstCCS.size() > 0){
                        for(ScCollection_ContactCounterSetting__c obj : lstCCS){
                            if(strCounterType.contains(obj.ScCollection_Counter_Type__c)){
                                if(obj.ScCollection_MaxRange__c != null){
                                    if(mapCounterTypeCounter.get(strCounterType) >= obj.ScCollection_MinRange__c &&
                                        mapCounterTypeCounter.get(strCounterType) <= obj.ScCollection_MaxRange__c){
                                        strMonthlyColorCode = obj.ScCollection_Color_Code__c;
                                    }
                                }
                                else if(mapCounterTypeCounter.get(strCounterType) >= obj.ScCollection_MinRange__c){
                                    strMonthlyColorCode = obj.ScCollection_Color_Code__c;
                                }
                            }
                        }
                    }
                }
                if(strCounterType.containsIgnoreCase('Week')){
                    intWeeklyCounter = mapCounterTypeCounter.get(strCounterType);
                    strWeeklyColorCode = '#515F6b'; // default color code
                    if(lstCCS.size() > 0){
                        for(ScCollection_ContactCounterSetting__c obj : lstCCS){
                            if(strCounterType.contains(obj.ScCollection_Counter_Type__c)){
                                if(obj.ScCollection_MaxRange__c != null){
                                    if(mapCounterTypeCounter.get(strCounterType) >= obj.ScCollection_MinRange__c &&
                                        mapCounterTypeCounter.get(strCounterType) <= obj.ScCollection_MaxRange__c){
                                        strWeeklyColorCode = obj.ScCollection_Color_Code__c;
                                    }
                                }
                                else if(mapCounterTypeCounter.get(strCounterType) >= obj.ScCollection_MinRange__c){
                                    strWeeklyColorCode = obj.ScCollection_Color_Code__c;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}