// ----------------------------------------------------------------------------------------------------
    // This class would be used to show contract status and other important stuff on cl contract inline page section
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    // Test Class : ScCollection_TestViewStatusClController
    // ----------------------------------------------------------------------------------------------------
    public class ScCollection_ViewStatusClController 
    {
        //variable declaration    
        public String statuCreated {get;set;}   
        public String strSourceSystem;

        public String strLoanId;
        public collect__Loan_Account__c objContract {get;set;}
        
        public collect__Contract_Status__c objStatus {get;set;}
        public List<wrapperForStatusFields> lstWrapperForStatusFields {get;set;}
        
        // get the map  for the fls
        private static final Map<String,Schema.SObjectField> VAR_STATUSFIELDMAP = Schema.SObjectType.collect__Contract_Status__c.fields.getMap();
        
        private static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
        
        public Integer intMonthlyCounter {get;set;}
        public String strMonthlyColorCode {get;set;}
        public Integer intWeeklyCounter {get;set;}
        public String strWeeklyColorCode {get;set;}
        public string error_msg {get;set;}
        public boolean isShowSyncError {get;set;}
        
        //constructor defined
        public ScCollection_ViewStatusClController(ApexPages.StandardController controller) 
        {
            isShowSyncError = false;
            //look for contract 
            if(!Test.isRunningTest())
            {
                controller.addFields(new string[]{'ScCollection_Management_Notes__c','collect__Collection_Status__c','collect__Source_System__r.Name','ScCollection_Source_System_Name__c','Name','Id','ScCollection_Error_Occurred__c','ScCollection_API_log__c','ScCollection_API_Call_Not_Process__c','ScCollection_Error_Message__c'});
            }

            objContract = (collect__Loan_Account__c)controller.getRecord();
            strLoanId = objContract.Id;
            System.debug(objContract);
            if(!Test.isRunningTest())
            {
                strSourceSystem = objContract.collect__Source_System__r.Name;
            }
            error_msg ='';
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
            if(String.isNotEmpty(strLoanId))
            {
                if(objContract.collect__Collection_Status__c == Null)
                {
                    //insert the collection status
                    objStatus = InsertContractStatus(strLoanId);
                    statuCreated = 'created';
                }
                else
                {
                    objStatus = ScCollection_CommonCodeHandler.retriveContractStatusData(strLoanId);
                }
                
                //insert contract setings if not already present
                ScCollection_CommonCodeHandler.retriveContractSettingsData(strLoanId,UserInfo.getUserId());
                
                //call method to populate status data to be shown on page
                PopulateContractStatus();
                
                // initiate method to showcase current weekly/monthly contact counter
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
                    
            if(strSourceSystem != '')
            {
                List<collect__Status_Config__c> lstconfig = [select Id, 
                                                                    collect__Status__c, 
                                                                    collect__Status_API_Name__c 
                                                                    from collect__Status_Config__c 
                                                                    where ScCollection_Source_System_Name__c =: strSourceSystem];
                
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

                List<collect__Loan_Account__c> lstcl = [select Id,
                                                               collect__Source_System__r.Name,
                                                               collect__External_ID__c,
                                                               Name,
                                                               ScCollection_Country_Code__c,
                                                               ScCollection_Contract_Split_Number__c,
                                                               ScCollection_Loan_Status_Description__c,
                                                               ScCollection_Loan_Sub_status_description__c
                                                               from collect__Loan_Account__c
                                                               where Id =: strcontractid];
                
                if(ScCollection_UtilityHandler.isNotNull(lstcl))
                {
                    collect__Contract_Status__c obj = new collect__Contract_Status__c();

                    if(ScCollection_UtilityHandler.getPlainString(lstcl[0].collect__Source_System__r.Name) == ScCollection_UtilityHandler.getPlainString('MORTGAGE'))
                    {
                        if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Misc Status'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Settled'))
                            {
                                obj.ScCollection_Misc_Status__c = 'Settled';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Dis Pending'))
                            {
                                obj.ScCollection_Misc_Status__c = 'Dis Pending';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Discharged'))
                            {
                                obj.ScCollection_Misc_Status__c = 'Discharged';
                            }
                        }
                        //added for EDW ----
                        obj.ScCollection_LOB_Identifier__c = 'MORTGAGE';
                    } 
                    else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].collect__Source_System__r.Name) == ScCollection_UtilityHandler.getPlainString('PAF'))
                    {
                        if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Arrears'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Overdue'))
                            {
                                obj.ScCollection_Arrears__c = 'Overdue';    
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Default-Collection Officer'))
                            {
                                obj.ScCollection_Arrears__c = 'Default - Collections Officer';
                            }
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Remarketing'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Default-External Agent'))
                            {
                                obj.ScCollection_Remarketing__c = 'Out with Agent';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Repossessed'))
                            {
                                obj.ScCollection_Remarketing__c = 'Repossessed';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Redemption Expired'))
                            {
                                obj.ScCollection_Remarketing__c = 'Redemption Expired';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Early Payout-Sale of Asset'))
                            {
                                obj.ScCollection_Remarketing__c = 'Early Payout-Sale of Asset';
                            }
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Misc Status'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Current'))
                            {
                                obj.Main_Status__c = 'Current';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Closed - Early Payout'))
                            {
                                obj.ScCollection_Misc_Status__c = 'Closed - Early Payout';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Closed - Maturity'))
                            {
                                obj.ScCollection_Misc_Status__c = 'Closed - Maturity';
                            }
                        }
                        //added for EDW ----
                        obj.ScCollection_LOB_Identifier__c = 'PAF';
                    }
                     else if(ScCollection_UtilityHandler.getPlainString(lstcl[0].collect__Source_System__r.Name) == ScCollection_UtilityHandler.getPlainString('CL Loan')){
                        
                        obj.ScCollection_LOB_Identifier__c = 'CL Loan';
                    }
                    
                    //added for EDW ------------
                    obj.ScCollection_External_Id__c = lstcl[0].collect__External_ID__c ;
                    obj.ScCollection_Contract_Name__c = (lstcl[0].Name != null ? (lstcl[0].Name.contains('_') ? lstcl[0].Name.split('\\_')[0] : lstcl[0].Name) : '' );
                    obj.ScCollection_Country_Code__c = lstcl[0].ScCollection_Country_Code__c ;
                    obj.ScCollection_Split_Number__c = String.ValueOf(lstcl[0].ScCollection_Contract_Split_Number__c);
            
                    insert obj; 
                                    
                    lstcl[0].collect__Collection_Status__c = obj.Id;
                    update lstcl;

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
        {
            
            
            
            if(objContract.ScCollection_Source_System_Name__c.equalsIgnoreCase('PAF')){
            
                SyncPAFManagementNotes(objStatus.ScCollection_Management_Notes__c,objContract.Name,objContract.Id);
            }
            update objStatus;
        }
        
        // ----------------------------------------------------------------------------------------------------
        // This method showcase weekly/monthly contact counter against contract.
        // ----------------------------------------------------------------------------------------------------
        // Created Date: 24-Nov-2016    Created By: Kashish Dwivedi    Email: kashish.dwivedi@saasfocus.com Version: 1.0
        // ----------------------------------------------------------------------------------------------------
        public void CalculateContactCounter()
        {
            // variables intilizing
            map<String, collect__Contract_Collections_Metrics__c> mapIdCounterRecord = new map<String, collect__Contract_Collections_Metrics__c>();
            List<ScCollection_ContactCounterSetting__c> lstCCS = new List<ScCollection_ContactCounterSetting__c>();
            List<collect__Collections_Metrics_Settings__c> lstCMS = new List<collect__Collections_Metrics_Settings__c>();
            Set<String> setCMSName = new Set<String>();
            map<String, Integer> mapCounterTypeCounter = new map<String, Integer>();
            
            // fetch counter records from contract APIs
            collect.API api = collect.APIFactory.getAPI();
            Set<Id> setContractId = new Set <Id>();
            setContractId.add(strLoanId);
            Map<Id,SObject> mapObjectData = api.getContracts(setContractId);
            SObject loanContract = mapObjectData.get(strLoanId);
            List<collect__Contract_Collections_Metrics__c> lstCCM = (List<collect__Contract_Collections_Metrics__c>)loanContract.getSObjects('collect__Contract_Collections_Metrics__r');
            
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
        
        public void executeSyncMgmtNotes(){
            if(objContract.ScCollection_Source_System_Name__c.equalsIgnoreCase('MORTGAGE'))
            {
                SyncManagementNotes(objContract.ScCollection_Management_Notes__c, objContract.ScCollection_Source_System_Name__c, objContract.Name, objContract.Id, objContract.collect__Collection_Status__c);
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This process is not working for PAF.'));
            }
        }
        
        /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          SyncManagementNotes
        Company:       Saasfocus
        Description:   This method is used to sync management notes integration.
        Inputs:        String,String,String,String,String
        Returns:       void
        ------------------------------------------------------------*/
        public void SyncManagementNotes(String managementNotes ,String lob,String loanNumber,String loanId,String collection_status_id )
        {
            ScCollection_MeetingNotesResponseSuccess responseApi;
            String usrEmail = [select id,Email from User where id = : userInfo.getUserID()].Email;
            string apiResponse;
            List<collect__Contract_Status__c> lstCollectionStatus = new List<collect__Contract_Status__c>();
            String api_custsetting_name = 'MortgageManagementNotes';
            try{
                    string notes1 ='';
                    string notes2 ='';
                    string notes3 ='';
                    string notes4 ='';
                    if(managementNotes != null){
                        managementNotes = managementNotes.replace('&','and');
                        Integer stringLength = managementNotes.length();
                        if(stringLength <= 50){
                            notes1 = managementNotes;
                        }
                        else if(stringLength <= 100 && stringLength > 50){
                            notes1 = managementNotes.substring(0,50);
                            notes2 = managementNotes.substring(50,stringLength);
                        }
                        else if(stringLength <= 150 && stringLength > 100){
                            notes1 = managementNotes.substring(0,50);
                            notes2 = managementNotes.substring(50,100);
                            notes3 = managementNotes.substring(100,stringLength);
                        }
                        else{
                            notes1 = managementNotes.substring(0,50);
                            notes2 = managementNotes.substring(50,100);
                            notes3 = managementNotes.substring(100,150);
                            if(stringLength > 200){
                                notes4 = managementNotes.substring(150,200);
                            }
                            else{
                                notes4 = managementNotes.substring(150,stringLength);
                            }
                                  
                        }
                    }   
                    
                    notes1 = notes1.replace('<','&lt');
                    notes1 = notes1.replace('>', '&gt;');
                    notes2 = notes2.replace('<','&lt');
                    notes2 = notes2.replace('>', '&gt;');
                    notes3 = notes3.replace('<','&lt');
                    notes3 = notes3.replace('>', '&gt;');
                    notes4 = notes4.replace('<','&lt');
                    notes4 = notes4.replace('>', '&gt;');
                    
                    ScCollection_PaymentAPIParameters__c objCredential = ScCollection_PaymentAPIParameters__c.getValues(api_custsetting_name);
                    String apiUrl = objCredential.Endpoint__c;
                    
                    RequestBody objReqBody = new RequestBody();
                    objReqBody.countryCode = 'AU';
                    objReqBody.lob = lob.toLowerCase();
                    objReqBody.loanNumber =loanNumber.split('_')[0];
                   
                    objReqBody.usernEmailAddress = usrEmail ;
                    objReqBody.notes1= notes1;
                    objReqBody.notes2= notes2;
                    objReqBody.notes3= notes3;
                    objReqBody.notes4= notes4;
                    objReqBody.sfLoanNotesId= loanId;
                    
                    String str = objReqBody.parse();
                    Http objhttp = new Http();
                    HttpRequest req = new HttpRequest();
                    system.debug('apiRequest management notes == '+str);
                    req.setEndpoint(apiUrl);
                    req.setMethod('POST');
                    Blob headerValue = Blob.valueOf(objCredential.Username__c+ ':' + objCredential.Password__c);
                    String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                    req.setHeader('Authorization', authorizationHeader);
                    req.setHeader('Content-Type', 'application/json');
                    req.setTimeout(120000);
                    req.setBody(str);
                    HttpResponse res = objhttp.send(req);
                    apiResponse =  res.getBody();
                    system.debug('apiResponse management notes== '+apiResponse);
                    
                    
                    if(apiResponse != null){
                        responseApi = ScCollection_MeetingNotesResponseSuccess.parse(apiResponse);
                        if(res.getStatusCode() == 200){
                            if(responseApi.APIStatus != null){
                                if(responseApi.APIStatus.APICode =='200'){
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                            if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                                if(tempresponse.PepperReference.Reference != '99'){
                                                    objContract.ScCollection_Error_Occurred__c = true;
                                                    objContract.ScCollection_API_Call_Not_Process__c = false;
                                                }
                                                else{
                                                    objContract.ScCollection_Error_Occurred__c = false;
                                                    objContract.ScCollection_API_Call_Not_Process__c = false;
                                                    objContract.ScCollection_Error_Message_Exist__c = false;
                                                    objContract.ScCollection_Error_Message__c = null;
                                                }
                                            }
                                            if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                                objContract.ScCollection_API_log__c = tempresponse.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                                else{
                                    objContract.ScCollection_Error_Occurred__c = true;
                                    objContract.ScCollection_API_Call_Not_Process__c = false;
                                    objContract.ScCollection_Error_Message__c = 'We have received again an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                                    objContract.ScCollection_Error_Message_Exist__c = true;
                                    
                                    if(responseApi.APIStatus.Messages != null && responseApi.APIStatus.Messages.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                            if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                                objContract.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        else if(res.getStatusCode() == 500){
                            if(responseApi.APIStatus !=null){
                                if(responseApi.APIStatus.APICode =='500'){
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                            if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                                if(tempresponse.PepperReference.Reference != '99'){
                                                    objContract.ScCollection_Error_Occurred__c = true;
                                                    objContract.ScCollection_API_Call_Not_Process__c = false;
                                                }
                                            }
                                            if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                                objContract.ScCollection_API_log__c = tempresponse.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if(res.getStatusCode() == 401){
                            if(responseApi.APIStatus !=null){
                                if(responseApi.APIStatus.APICode =='401'){
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                            if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                                if(tempresponse.PepperReference.Reference != '99'){
                                                    objContract.ScCollection_Error_Occurred__c = true;
                                                    objContract.ScCollection_API_Call_Not_Process__c = false;
                                                }
                                            }
                                            if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                                objContract.ScCollection_API_log__c = tempresponse.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            objContract.ScCollection_Error_Occurred__c = true;
                            objContract.ScCollection_API_Call_Not_Process__c = false;
                            error_msg = 'Some error occured during the sync process. Request you to please try again.';
                            objContract.ScCollection_Error_Message__c = error_msg ;
                            objContract.ScCollection_Error_Message_Exist__c = true;
                            if(responseApi.APIStatus !=null){
                                if(responseApi.APIStatus.Messages != null && responseApi.APIStatus.Messages.size()>0){
                                    for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                        if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                            objContract.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                        }
                                    }
                                }
                            }
                        }
                        update objContract;
                    }
            }
            catch(Exception e){
                string errorMsg = 'Error: ' + e.getMessage() + '-----' + e.getStackTraceString();
                system.debug('Exception message'+errorMsg);
                objContract.ScCollection_Error_Occurred__c = false;
                objContract.ScCollection_API_Call_Not_Process__c = true;
                objContract.ScCollection_Error_Message__c = errorMsg ;
                objContract.ScCollection_Error_Message_Exist__c = true;
                update objContract;
            }
        }
        
        //wrapper for Mortgage request
        public class RequestBody
        {
            public String countryCode{get;set;}
            public String lob{get;set;}
            public String loanNumber{get;set;}
            public String usernEmailAddress{get;set;}
            public String notes1{get;set;}
            public String notes2{get;set;}
            public String notes3{get;set;}
            public String notes4{get;set;}
            public String sfLoanNotesId{get;set;}
            
            public String parse(){
                return  System.JSON.serialize(this);
            }
        }
        
        /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          GetError
        Company:       Saasfocus
        Description:   This method is used to fetch error on basis of error 
                       log when any error occure during management notes integration.
        Inputs:        no input
        Returns:       void
        ------------------------------------------------------------*/
        public void GetError(){
            
            if(objContract.ScCollection_API_log__c != null){
                String strErrorResponse = ScCollection_CommonCodeHandler.GetErrorResponse(objContract.ScCollection_API_log__c);
                system.debug('inside error block'+strErrorResponse );
                objContract.ScCollection_Error_Message__c = strErrorResponse;
                objContract.ScCollection_Error_Message_Exist__c = true;
                update objContract;
            }
            
        }
        
        //Wrapper for PAF request
        public class PAFRequestBody{
            public String contractNumber{get;set;}
            public String auditUser{get;set;}
            public String auditDate{get;set;}
            public String comments{get;set;}
            public String userId{get;set;}
            public String authKey{get;set;}
            
            public String parse(){
                return  System.JSON.serialize(this);
            }
        }
        
        /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          SyncPAFManagementNotes
        Company:       Saasfocus
        Description:   This method is used to fetch error on basis of error 
                       log when any error occure during management notes integration.
        Inputs:        String,String,String
        Returns:       void
        ------------------------------------------------------------*/
        //@Future(CallOut=True)
        public Static void SyncPAFManagementNotes(String management_Notes,String loan_number,String contractId){
            User ObjUsr = [Select Id,Email,Name,FirstName,LastName From User where Id = :UserInfo.GetUserID()];
            String usr_name = '';
            if(!String.IsBlank(ObjUsr.FirstName)){
                usr_name = ObjUsr.FirstName.substring(0,1);
            }
            usr_name += ObjUsr.LastName;
            Integer userNameSize = usr_name.Length();
            if(userNameSize > 20){
                usr_name = usr_name.substring(0,20);
            }
            system.debug('usr_name'+usr_name);
            String api_custsetting_name = 'PAFManagementNotes';
            try{
                Date d = System.today();
                Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
                String myDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
                if(!String.isBlank(management_Notes)){
                    management_Notes = management_Notes.stripHtmlTags();
                }
                else{
                    management_Notes = '';
                }
                ScCollection_PaymentAPIParameters__c objcred = ScCollection_PaymentAPIParameters__c.getValues(api_custsetting_name);
                String api_url = objcred.Endpoint__c;
                PAFRequestBody objPAFReqBody = new PAFRequestBody();
                objPAFReqBody.contractNumber = loan_number;
                objPAFReqBody.auditUser = usr_name;
                objPAFReqBody.auditDate = myDate;
                objPAFReqBody.comments = management_Notes;
                objPAFReqBody.userId = objcred.ScCollection_CMS_User_Id__c;
                objPAFReqBody.authKey= objcred.ScCollection_CMS_Auth_Key__c;
                system.debug('management_Notes@@'+management_Notes);
                String str = objPAFReqBody.parse();
                System.debug('str PAF ==' +str);
                Http objhttp = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(api_url);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objcred.Username__c+ ':' + objcred.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setTimeout(120000);
                
                req.setBody(str);
                HttpResponse res = objhttp.send(req);
                string apiResponse =  res.getBody();
                System.debug('Inside PAF apiResponse =='+ apiResponse);
                
                if(apiResponse != null){
                    ScCollection_MeetingNotesResponseSuccess responseApi = ScCollection_MeetingNotesResponseSuccess.parse(apiResponse);
                    collect__Loan_Account__c objContract = new collect__Loan_Account__c();
                    objContract.Id = contractId;
                    if(res.getStatusCode() == 200){
                        objContract.ScCollection_Error_Occurred__c = false;
                        objContract.ScCollection_Error_Message__c = null;
                        objContract.ScCollection_API_Call_Not_Process__c = false;
                        objContract.ScCollection_Error_Message_Exist__c = false;
                        
                    }
                    else{
                        objContract.ScCollection_Error_Occurred__c = true;
                        objContract.ScCollection_Error_Message_Exist__c = true;
                        objContract.ScCollection_API_Call_Not_Process__c = false;
                        objContract.ScCollection_Error_Message__c ='Record saved in ICM successfully but sync request didn\'t reach to source system successfully. Please try again or contact with System Administrator.';
                        if(responseApi.APIStatus != null){
                            
                            for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                if(objApiResponseMsg.Message != null){
                                    objContract.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                }
                                
                            }
                        }
                    }
                    update objContract;
                }
            }
            catch(Exception e){
                string errorMsg = 'We have received following error in sync process : ' + e.getMessage() + ' Please contact with System Administrator.';
                collect__Loan_Account__c objContract = new collect__Loan_Account__c();
                objContract.Id = contractId;
                objContract.ScCollection_Error_Occurred__c = false;
                objContract.ScCollection_API_Call_Not_Process__c = true;
                objContract.ScCollection_Error_Message__c = errorMsg;
                objContract.ScCollection_Error_Message_Exist__c = true;
                update objContract;
            }
        }
    }