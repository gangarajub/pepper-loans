// ----------------------------------------------------------------------------------------------------
// This class would be used to handle all functionality for creating interaction logs and updating contract status.
// ----------------------------------------------------------------------------------------------------
// Created Date: 10-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestCreateLogController  
// ----------------------------------------------------------------------------------------------------
public with sharing class ScCollection_CreateLogController
{ 
    //variable declaration for the data to be populated on page  
    public String strContractId {get;set;}
    public String strTabId {get;set;}
    public String strSelectedAction {get;set;}
    public String strSelectedTemplate {get;set;}
    public String strNextAction {get;set;}
    public String strRFD {get;set;}
    public String strObjectName = '';
    public String strCollectionUser = '';
    
    //added 17/05/2017
    public Boolean showRequestedBy {get;set;}
    public Boolean showRequestedVia {get;set;}
    public Boolean showDateAllReceived {get;set;}
    
    //added to avoid duplicate record insert
    public Boolean isSubmit = false;
    
    public Boolean createActivity {get;set;}
    public Boolean showSubmit {get;set;}
    public Boolean editStatus {get;set;}
    public Boolean showSmsSent {get;set;}
    
    public collect__Interaction_Log__c objLog {get;set;}
    public collect__Contract_Status__c objStatus {get;set;}
    public List<wrapperForStatusFields> lstwrapperForStatusFields {get;set;}
    
    public Map<Id,collect__Action_Code_Config__c> mapActionIdToActionRecord = new Map<Id,collect__Action_Code_Config__c>();
    public Map<Id,Sobject> mapResult = new Map<Id,Sobject>();
    
    // get the map  for the fls of contract status object
    public Map<String,Schema.SObjectField> mapFields = Schema.SObjectType.collect__Contract_Status__c.fields.getMap();
    
    // variable to show the assign to user button 
    public boolean displayAssignToUser{get;set;}
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();

    public static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    public static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
    public static final String VAR_CONTRACTSETTING_API = 'ScCollection_ContractSettings__c';
    public static final String VAR_CONTRACTSTATUS_API = 'collect__Contract_Status__c';

    public static final String VAR_NONE = '--None--';
    
    
    //this wrapper holds the data for contract status picklist fields
    public class wrapperForStatusFields
    {
        public collect__Status_Config__c objconfig {get;set;}
        public String strSelectedStatus {get;set;}
        public String strSelectedStatusView {get;set;}
        public List<SelectOption> lstStatusOptions {get;set;}
        public boolean read {get;set;}
        public boolean write {get;set;}

        public wrapperForStatusFields()
        {
            objconfig = new collect__Status_Config__c();
            strSelectedStatus = '';
            strSelectedStatusView = '';
            lstStatusOptions = new List<SelectOption>();
            read = false;
            write = false;
        }
    }
    
    //constructor for variable initialization
    public ScCollection_CreateLogController()
    {
        strContractId = '';
        strTabId = '';
        strSelectedAction = '';
        strSelectedTemplate = '';
        strNextAction = '';
        strRFD = '';
        createActivity = false;
        editStatus = false;
        displayAssignToUser = false;
        showSmsSent = false;
        
        //added 17/05/2017
        showRequestedBy = false;
        showRequestedVia = false;
        showDateAllReceived = false;

        //get the Id from url parameter
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id')))
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
            
            Set<Id> setqueue = new Set<Id>();
            Set<Id> setqueueusers = new set<Id>();
            String strAssignedUser = '';
            
            //get all the queue contracts for the opened contract
            for(collect__Queue_Contract__c queuecont : [Select Id, 
                                                               collect__User__c,
                                                               collect__Queue__c 
                                                               from collect__Queue_Contract__c 
                                                               where collect__Status__c = 'Open' AND
                                                               (ScCollection_CL_Contract__c =: strContractId OR
                                                               ScCollection_Dev_Contract__c =: strContractId)])
            {
                setqueue.add(queuecont.collect__Queue__c);
                if(UserInfo.getUserId() == queuecont.collect__User__c)
                {
                    strAssignedUser = queuecont.collect__User__c;
                }
                else
                {
                    strCollectionUser = queuecont.collect__User__c;
                }
            }
            
            if(strAssignedUser != '')
            {
                strCollectionUser = strAssignedUser;
            }
            
            for(collect__Queue_User__c tempqueueuser : [select Id, collect__User__c from collect__Queue_User__c where collect__Queue__c IN : setqueue])
            {
                setqueueusers.add(tempqueueuser.collect__User__c);
            }

            if(setqueueusers != Null && setqueueusers.contains(Userinfo.getUserId()))
            {
                displayAssignToUser = true;
            }
            
            //call common method to retrieve object name
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            
            Set<Id> setcontractid = new Set<Id>();
            setcontractid.add(strContractId);
            
            //call api method of cls to get current open contract record
            mapResult = api.getContracts(setcontractid);
            
            //call common method to retrieve collection status record.
            objStatus = ScCollection_CommonCodeHandler.retriveContractStatusData(strContractId);
        }
        
        //get interaction log id from url parameter for log view page
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('logid')))
        {
            showSubmit = false;
            List<collect__Interaction_Log__c> lstlog = new List<collect__Interaction_Log__c>();

            // code modified by deepak dhingra to fix the query exception
            lstlog = [select Id, 
                             Name, 
                             collect__Action__c, 
                             collect__Action__r.Name, 
                             collect__Action__r.ScCollection_Next_Action__c, 
                             collect__Follow_Up_Date_Time__c,
                             collect__Action__r.ScCollection_Available_for_Sync__c, 
                             collect__Description__c,
                             collect__Collection_Activity__c, 
                             ScCollection_Reason_For_Default__c,
                             CreatedDate,
                             CreatedBy.Name,
                             collect__Dev_Contract__r.ScCollection_Source_System_Name__c,
                             ScCollection_Synced__c,ScCollection_Date_all_documents_received__c,
                             ScCollection_Error_Message__c,ScCollection_Requested_Via__c,ScCollection_Requested_by__c 
                             from collect__Interaction_Log__c 
                             where Id =: ApexPages.currentPage().getParameters().get('logid')];
            
            if(ScCollection_UtilityHandler.isNotNull(lstlog))
            {
                objLog = lstlog[0];
                
                if(objLog.collect__Collection_Activity__c != Null)
                {
                    createActivity = true;
                }
            }
            else
            {
                showSubmit = true;
                objLog = new collect__Interaction_Log__c();
            }
        }
        else
        {
            showSubmit = true;
            objLog = new collect__Interaction_Log__c();
        }
        
        //get the parent tab id for console refresh functionality
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('tabid')))
        {
            strTabId = ApexPages.currentPage().getParameters().get('tabid');
        }
        
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('smssent')))
        {
            if(ApexPages.currentPage().getParameters().get('smssent') == '1')
            {
                showSmsSent = true;
            }
        }
        
        //call method to generate contract status fields in vf page
        PopulateContractStatus();
    }
    
    //method to get the list of actions on the basis of source system
    public List<SelectOption> getActionName()
    { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',VAR_NONE));
        
        String sourcesystemname = '';

        if(strObjectName == VAR_PLCONTRACT_API)
        {
            sourcesystemname = 'CL Loan';
        }
        else if(strObjectName == VAR_CLCONTRACT_API)
        {
            for(collect__Loan_Account__c obj : [select Id, 
                                                       collect__Source_System__r.Name 
                                                       from collect__Loan_Account__c 
                                                       where Id =: strContractId])
            {
                if(obj.collect__Source_System__r.Name != Null)
                {
                    sourcesystemname = obj.collect__Source_System__r.Name;
                }
            }    
        }

        if(sourcesystemname != '')
        {
            for(collect__Action_Code_Config__c obj : [select Id, 
                                                             collect__Action_Code__c, 
                                                             collect__Action_Code__r.Name, 
                                                             collect__Action_Code__r.ScCollection_Next_Action__c, 
                                                             collect__Action_Code__r.ScCollection_RFD__c, 
                                                             collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c, 
                                                             collect__Action_Code__r.ScCollection_Status_Field_Values__c,
                                                             collect__Action_Code__r.ScCollection_Available_for_Sync__c   
                                                             from collect__Action_Code_Config__c 
                                                             where collect__Action_Code__c != Null AND 
                                                             collect__Source_System__r.Name =: sourcesystemname
                                                             ORDER BY collect__Action_Code__r.Name ASC])
            {        
                options.add(new SelectOption(obj.collect__Action_Code__c, obj.collect__Action_Code__r.Name));
                mapActionIdToActionRecord.put(obj.collect__Action_Code__c, obj);
            }
        }
        
        return options;  
    }

    //method to get the list of actions on the basis of source system
    public List<SelectOption> getTemplateName()
    { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',VAR_NONE));
        
        for(ScCollection_Log_Template__c obj : [select Id, 
                                                       ScCollection_Template_Name__c, 
                                                       ScCollection_Source_System__r.Name
                                                       from ScCollection_Log_Template__c
                                                       where ScCollection_Is_Active__c = true 
                                                       and RecordType.DeveloperName = 'ScCollection_Interaction_Log'
                                                       ORDER BY ScCollection_Template_Name__c ASC])
        {   
            String strname = obj.ScCollection_Template_Name__c + ' (' + obj.ScCollection_Source_System__r.Name + ')';     
            options.add(new SelectOption(obj.Id, strname));
        }
        
        return options;  
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for interaction log creation
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public PageReference SubmitData()
    {
        
        if(!isSubmit){
            isSubmit = true;
            String sourceSystemName = '';
            string loanNumber = '';
            if(ScCollection_UtilityHandler.isNotNull(strSelectedAction) && objLog.collect__Follow_Up_Date_Time__c != Null && objLog.collect__Description__c != Null)
            {
                if(objLog.collect__Follow_Up_Date_Time__c >= System.Now().addMinutes(-1))
                {
                    String FollowUpDateStatus = ValidateFollowUpDate();
                    
                    if(FollowUpDateStatus == 'ok')
                    {
                        objLog.collect__Action__c = strSelectedAction;
                        objLog.collect__Interaction_Date__c = System.Today();
                        
                        if(strCollectionUser != Null && strCollectionUser != '')
                        {
                            objLog.collect__Collector__c = strCollectionUser;
                        }
                        
                        if(strObjectName == VAR_PLCONTRACT_API && !Test.isRunningTest())
                        {
                            loan__Loan_Account__c objcnt = (loan__Loan_Account__c)mapResult.get(strContractId);
                            List<collect__Loan_Account__c> lstCLContractforPL = [Select Id,Name From collect__Loan_Account__c Where collect__External_ID__c =:objcnt.Id and Name =: objcnt.Name Limit 1];
                            if(lstCLContractforPL != null && lstCLContractforPL.Size() > 0){
                                objLog.collect__Loan_Account_Id__c = objcnt.Id;
                                objLog.ScCollection_CL_Contract__c = objcnt.Id;
                                objLog.collect__Dev_Contract__c = lstCLContractforPL[0].Id;
                            }
                            else{
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is no matching collection contract for this PL contract.'));
                                return Null;
                            }
                            
                        }
                        else if(strObjectName == VAR_CLCONTRACT_API && !Test.isRunningTest())
                        {
                            collect__Loan_Account__c objcnt = (collect__Loan_Account__c)mapResult.get(strContractId); 
                            objLog.collect__Dev_Contract__c = objcnt.Id;
                            
                            sourceSystemName = objcnt.ScCollection_Source_System_Name__c;
                            loanNumber = objcnt.Name;
                        }
                        
                        String apiresult = 'ok';
                        system.debug('objLog '+objLog);
                        //call api of cls to insert interaction log record
                        if(!Test.isRunningTest())
                        {
                            collect.Result objresult = api.createInteractionLogs(new List<collect__Interaction_Log__c>{objLog}, createActivity);
                            
                            //process the result from api
                            apiresult = ScCollection_CommonCodeHandler.processApiResult(objresult);
                            
                            //Added 10/04/2017 for async call -----
                            if(mapActionIdToActionRecord.ContainsKey(strSelectedAction) && mapActionIdToActionRecord.get(strSelectedAction) != null){
                                String actionCodeName = mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.Name;
                                Boolean ifAvailableForSync = mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Available_for_Sync__c;
                                if(sourceSystemName != '' && ifAvailableForSync && sourceSystemName != 'CL Loan'){
                                    SyncInteractionLog(actionCodeName,objLog.collect__Description__c,sourceSystemName,loanNumber,objLog.Id,objLog.ScCollection_Requested_by__c,objLog.ScCollection_Requested_Via__c,objLog.ScCollection_Date_all_documents_received__c,objLog.collect__Follow_Up_Date_Time__c);
                                }
                                    
                            }
                        }                  
                        
                        if(apiresult == 'ok')
                        {
                            //update status and followup date time on contract status object
                            String statusupdatestatus = UpdateStatusAndCounterOnContractStatus();
                            
                            if(statusupdatestatus != 'ok')
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,statusUpdateStatus));
                                return Null;
                            }

                            //update counter on contract settings object                
                            String counterupdatestatus = UpdateCounterOnContractSetting();
                            
                            if(counterupdatestatus != 'ok')
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,counterUpdateStatus));
                                return Null;
                            }
                            
                            PageReference pr = new PageReference('/apex/ScCollection_CreateInteractionLog?id=' + strContractId + '&logId=' + objLog.Id + '&tabId=' + strTabId);
                            pr.setRedirect(true);
                            return pr;
                        }
                        else
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult));
                            return Null;
                        }
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,FollowUpDateStatus));
                        return Null;
                    }
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Follow_Up_Date_Error));
                    return Null;
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Required_Field_Error));
                return Null;
            }
            
            return Null;
        }
        else{
            return null;
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the validation check for the followup date based on global settings.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public String ValidateFollowUpDate()
    {
        Map<String,ScCollection_Status_Counter_Settings__c> mapcustomsettings = ScCollection_Status_Counter_Settings__c.getAll();
        
        if(ScCollection_UtilityHandler.isNotNull(mapcustomsettings))
        {
            if(mapcustomsettings.containsKey('Max Days Setting') && mapcustomsettings.get('Max Days Setting') != Null && mapcustomsettings.get('Max Days Setting').ScCollection_Values__c != Null)
            {
                ScCollection_Settings__c cs = ScCollection_Settings__c.getInstance(UserInfo.getUserId());
                
                if(cs != Null && cs.ScCollection_MaxDaysWithPromise__c != Null && cs.ScCollection_MaxDaysNoPromise__c != Null)
                {
                    List<String> lststatus = mapcustomsettings.get('Max Days Setting').ScCollection_Values__c.split(',');
                    Boolean isptpstatus = false;
                    Integer maxdays = 0;
                    
                    collect__Action_Code_Config__c objac = mapActionIdToActionRecord.get(strSelectedAction);
                    
                    for(String obj : lststatus)
                    {   
                        if(obj.replaceAll(' ','').equalsIgnoreCase(objAC.collect__Action_Code__r.Name.replaceAll(' ','')))
                        {
                            isptpstatus = true;
                            break;
                        }    
                    }
                    
                    if(isptpstatus)
                    {                    
                        maxdays = Integer.valueof(cs.ScCollection_MaxDaysWithPromise__c);
                    }
                    else
                    {
                        List<collect__Promise_To_Pay__c> lstptp = [select Id from collect__Promise_To_Pay__c where collect__Promise_To_Pay_Date__c > TODAY AND (collect__Dev_Contract__c =: strContractId OR ScCollection_CL_Contract__c =: strContractId)];
                        
                        if(ScCollection_UtilityHandler.isNotNull(lstptp))
                        {
                            maxdays = Integer.valueof(cs.ScCollection_MaxDaysWithPromise__c);
                        }
                        else
                        {
                            maxdays = Integer.valueof(cs.ScCollection_MaxDaysNoPromise__c);
                        }
                    }
                    
                    if(objLog.collect__Follow_Up_Date_Time__c.date() > System.Today().addDays(maxdays))
                    {
                        String errorlbl = Label.ScCollection_Follow_Up_Date_Cap_Error;
                        
                        if(errorlbl.contains('{dynamic}'))
                        {
                            errorlbl = errorlbl.replace('{dynamic}', String.valueOf(maxdays));
                        }
    
                        return(errorlbl);
                    }
                    else
                    {
                        return('ok');
                    }
                }
                else
                {
                    return('Error : global counter seetings dont exist for your user, contact administrator...');    
                }
            }
            else
            {
                return('Error : record for max days settings cap does not exist in status counter settings.');
            }
        }
        else
        {
            return('Error : custom setting (Status Counter Setting) not defined for contract counter fields.');
        }
               
        return null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method updates the counter for various action of interaction log into contract settings objects.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 13-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public String UpdateCounterOnContractSetting()
    {
        List<ScCollection_Status_Counter_Settings__c> lstcustomsettings = ScCollection_Status_Counter_Settings__c.getAll().values();
        
        if(ScCollection_UtilityHandler.isNotNull(lstcustomsettings))
        {
            ScCollection_ContractSettings__c objcs = ScCollection_CommonCodeHandler.retriveContractSettingsData(strContractId, UserInfo.getUserId());
            Boolean updatecs = false;
            
            for(ScCollection_Status_Counter_Settings__c obj : lstcustomsettings)
            {
                if(ScCollection_UtilityHandler.isNotNull(obj.ScCollection_Values__c))
                {
                    List<String> lstactions = obj.ScCollection_Values__c.trim().split(',');
                    Boolean updatecounter = false;
                    collect__Action_Code_Config__c objac = mapActionIdToActionRecord.get(strSelectedAction);
                    
                    if(obj.ScCollection_Include__c)
                    {
                        for(String objstr : lstactions)
                        {
                            if(objstr.replaceAll(' ','').equalsIgnoreCase(objAC.collect__Action_Code__r.Name.replaceAll(' ','')))
                            {
                                updatecounter = true;
                                break;
                            }
                        }
                    }
                    else
                    {
                        updatecounter = true;
                        
                        for(String objstr : lstactions)
                        {
                            if(objstr.replaceAll(' ','').equalsIgnoreCase(objAC.collect__Action_Code__r.Name.replaceAll(' ','')))
                            {
                                updatecounter = false;
                                break;
                            }
                        }
                    }
                    
                    if(updatecounter)
                    {
                        if(obj.scCollection_Object_Api_Name__c == VAR_CONTRACTSETTING_API)
                        {
                            updatecs = true;
                            
                            if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('na'))
                            {
                                if(objcs.get(obj.ScCollection_Counter_Field_Api_Name__c) != Null)
                                {
                                    Integer counter = Integer.valueof(objcs.get(obj.ScCollection_Counter_Field_Api_Name__c));
                                    objcs.put(obj.ScCollection_Counter_Field_Api_Name__c, counter + 1);
                                }
                                else
                                {
                                    objcs.put(obj.ScCollection_Counter_Field_Api_Name__c, 1);
                                }
                            }
                            else if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('zero'))
                            {
                                objcs.put(obj.ScCollection_Counter_Field_Api_Name__c, 0);
                            }
                            else if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('true'))
                            {
                                objcs.put(obj.ScCollection_Checkbox_Field_Api_Name__c, true);
                            }
                            else if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('false'))
                            {
                                objcs.put(obj.ScCollection_Checkbox_Field_Api_Name__c, false);
                            }
                            else
                            {
                                if(objcs.get(obj.ScCollection_Date_Field_Api_Name__c) != Null && objcs.get(obj.ScCollection_Date_Field_Api_Name__c) == System.Today())
                                {
                                    Integer counter = Integer.valueof(objcs.get(obj.ScCollection_Counter_Field_Api_Name__c));
                                    objcs.put(obj.ScCollection_Counter_Field_Api_Name__c, counter+1);
                                }
                                else
                                {
                                    objcs.put(obj.ScCollection_Date_Field_Api_Name__c, System.Today());
                                    objcs.put(obj.ScCollection_Counter_Field_Api_Name__c, 1);
                                }
                            }
                        }
                    }
                }
            }  
            
            if(updatecs)
            {
                try
                {
                    update objcs;       
                }
                catch(DMLException e)
                {
                    System.debug('GOTCHA: UpdateCounterOnContractSetting: ' + e.getMessage());
                    return('Error : ' + e.getMessage());
                }
            }
        }
        else
        {
            return('Error : custom setting (Status Counter Setting) not defined for contract counter fields.');
        }
        
        return('ok');
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method updates the status for various action of interaction log into Contract Status object.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 7-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public String UpdateStatusAndCounterOnContractStatus()
    {
        objStatus = ScCollection_CommonCodeHandler.retriveContractStatusData(strContractId);
        if(strSelectedAction != '')
        {
            if(mapActionIdToActionRecord.containsKey(strSelectedAction) && mapActionIdToActionRecord.get(strSelectedAction) != Null) 
            {
                if(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c != Null)
                {
                    if(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Field_Values__c != Null)
                    {
                        objStatus.put(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c,mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Field_Values__c);
                    }
                    else
                    {
                        objStatus.put(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c,'');
                    }
                }
            }
            
            //update counters on contract status record if the criteria matches
            List<ScCollection_Status_Counter_Settings__c> lstcustomsettings = ScCollection_Status_Counter_Settings__c.getAll().values();
            
            if(ScCollection_UtilityHandler.isNotNull(lstcustomsettings))
            {
                for(ScCollection_Status_Counter_Settings__c obj : lstcustomsettings)
                {
                    if(ScCollection_UtilityHandler.isNotNull(obj.ScCollection_Values__c))
                    {
                        List<String> lstactions = obj.ScCollection_Values__c.trim().split(',');
                        Boolean updatecounter = false;
                        collect__Action_Code_Config__c objac = mapActionIdToActionRecord.get(strSelectedAction);
                                
                        if(obj.ScCollection_Include__c)
                        {
                            for(String objstr : lstactions)
                            {
                                if(objstr.replaceAll(' ','').equalsIgnoreCase(objAC.collect__Action_Code__r.Name.replaceAll(' ','')))
                                {
                                    updatecounter = true;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            updatecounter = true;
                            
                            for(String objstr : lstActions)
                            {
                                if(objstr.replaceAll(' ','').equalsIgnoreCase(objAC.collect__Action_Code__r.Name.replaceAll(' ','')))
                                {
                                    updatecounter = false;
                                    break;
                                }
                            }
                        }
                        
                        if(updatecounter)
                        {
                            if(obj.scCollection_Object_Api_Name__c == VAR_CONTRACTSTATUS_API)
                            {
                                if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('na'))
                                {
                                    if(objStatus.get(obj.ScCollection_Counter_Field_Api_Name__c) != Null)
                                    {
                                        Integer counter = Integer.valueof(objStatus.get(obj.ScCollection_Counter_Field_Api_Name__c));
                                        objStatus.put(obj.ScCollection_Counter_Field_Api_Name__c, counter + 1);
                                    }
                                    else
                                    {
                                        objStatus.put(obj.ScCollection_Counter_Field_Api_Name__c, 1);
                                    }
                                }
                                else if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('zero'))
                                {
                                    objStatus.put(obj.ScCollection_Counter_Field_Api_Name__c, 0);
                                }
                                else if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('true'))
                                {
                                    objStatus.put(obj.ScCollection_Checkbox_Field_Api_Name__c, true);
                                }
                                else if(obj.ScCollection_Date_Field_Api_Name__c.replaceAll(' ','').equalsIgnoreCase('false'))
                                {
                                    objStatus.put(obj.ScCollection_Checkbox_Field_Api_Name__c, false);
                                }
                                else
                                {
                                    if(objStatus.get(obj.ScCollection_Date_Field_Api_Name__c) != Null && objStatus.get(obj.ScCollection_Date_Field_Api_Name__c) == System.Today())
                                    {
                                        Integer counter = Integer.valueof(objStatus.get(obj.ScCollection_Counter_Field_Api_Name__c));
                                        objStatus.put(obj.ScCollection_Counter_Field_Api_Name__c, counter+1);
                                    }
                                    else
                                    {
                                        objStatus.put(obj.ScCollection_Date_Field_Api_Name__c, System.Today());
                                        objStatus.put(obj.ScCollection_Counter_Field_Api_Name__c, 1);
                                    }
                                }
                            }
                        }
                    }
                }  
            }
            
            if(editStatus && lstwrapperForStatusFields != Null && lstwrapperForStatusFields.size() > 0)
            {
                for(wrapperForStatusFields obj : lstwrapperForStatusFields)
                {
                    if(obj.strSelectedStatus != 'None')
                    {
                        objStatus.put(obj.objconfig.collect__Status_API_Name__c,obj.strSelectedStatus);
                    }
                    else
                    {
                        objStatus.put(obj.objconfig.collect__Status_API_Name__c,'');
                    }
                }
                
                if(mapActionIdToActionRecord.containsKey(strSelectedAction) && mapActionIdToActionRecord.get(strSelectedAction) != Null) 
                {
                    if(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c != Null)
                    {
                        if(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Field_Values__c != Null)
                        {
                            objStatus.put(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c,mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Field_Values__c);
                        }
                        else
                        {
                            objStatus.put(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c,'');
                        }
                    }
                }
            }
            
            if(objLog.ScCollection_Reason_For_Default__c != Null)
            {
                objStatus.ScCollection_Reason_For_Default__c = objLog.ScCollection_Reason_For_Default__c;
            }
            
            try
            {
                objStatus.ScCollection_Follow_Up_Date_Time__c = objLog.collect__Follow_Up_Date_Time__c;
                objStatus.ScCollection_Log_Created_Date__c = System.Today();
                update objStatus;
            }
            catch(DMLException e)
            {
                System.debug('GOTCHA: UpdateStatusAndCounterOnContractStatus:  ' + e.getMessage());
                return('Error : ' + e.getMessage());
            }
        }
        
        return('ok');
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic for action change on vf page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 13-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void changeAction()
    {
        strNextAction = '';
        strRFD = '';
        //added 17/05/2017
        showRequestedBy = false;
        showRequestedVia = false;
        showDateAllReceived = false;

        if(ScCollection_UtilityHandler.isNotNull(strSelectedAction))
        {
            if(mapActionIdToActionRecord.containsKey(strSelectedAction) && mapActionIdToActionRecord.get(strSelectedAction) != Null)
            {
                collect__Action_Code_Config__c objAC = mapActionIdToActionRecord.get(strSelectedAction);
                
                strNextAction = objAC.collect__Action_Code__r.ScCollection_Next_Action__c;
                strRFD = objAC.collect__Action_Code__r.ScCollection_RFD__c;
                
                if(objAC.collect__Action_Code__r.Name.equalsIgnoreCase('Hardship Requested')){
                    showRequestedBy = true;
                    showRequestedVia = true;
                }
                else if(objAC.collect__Action_Code__r.Name.equalsIgnoreCase('Hardship all documents received')){
                    showDateAllReceived = true;
                }
                else if(objAC.collect__Action_Code__r.Name.equalsIgnoreCase('Hardship Request withdrawn by Customer')){ 
                    showRequestedBy = true;
                }
            }
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic for template change on vf page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 21-SEP-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void changeTemplate()
    {
        objLog.collect__Description__c = '';

        if(ScCollection_UtilityHandler.isNotNull(strSelectedTemplate))
        {
            List<ScCollection_Log_Template__c> lsttemplate = [select ScCollection_Description__c from ScCollection_Log_Template__c where Id =: strSelectedTemplate AND ScCollection_Is_Active__c = true];

            if(ScCollection_UtilityHandler.isNotNull(lsttemplate))
            {
                objLog.collect__Description__c = lsttemplate[0].ScCollection_Description__c;
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for populating relevant status fields on interaction log page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void PopulateContractStatus()
    {
        lstwrapperForStatusFields = new List<wrapperForStatusFields>();
        
        String strsourcesystem = '';
                
        if(strObjectName == VAR_PLCONTRACT_API)
        {
            strsourcesystem = 'CL Loan';
        }
        else if(strObjectName == VAR_CLCONTRACT_API)
        {
            for(collect__Loan_Account__c obj : [select collect__Source_System__r.Name from collect__Loan_Account__c where Id =: strContractId])
            {
                if(obj.collect__Source_System__r.Name != Null)
                {
                    strsourcesystem = obj.collect__Source_System__r.Name;
                }
            }
        }
        
        if(strsourcesystem != '')
        {
            for(collect__Status_Config__c obj : [select Id, 
                                                        collect__Status__c, 
                                                        collect__Status_API_Name__c, 
                                                        collect__Allowed_Statuses__c 
                                                        from collect__Status_Config__c 
                                                        where ScCollection_Source_System_Name__c =: strsourcesystem])
            {
                wrapperForStatusFields objwrapperforstatusfields = new wrapperForStatusFields();
                
                // statement for write access
                if(mapFields.get(obj.collect__Status_API_Name__c).getDescribe().isAccessible() && mapFields.get(obj.collect__Status_API_Name__c).getDescribe().isUpdateable() &&  mapFields.get(obj.collect__Status_API_Name__c).getDescribe().isCreateable()) 
                { 
                    objwrapperforstatusfields.write = true; 
                    objwrapperforstatusfields.read = true;
                }
                
                // statement for read access
                if(mapFields.get(obj.collect__Status_API_Name__c).getDescribe().isAccessible() && !mapFields.get(obj.collect__Status_API_Name__c).getDescribe().isUpdateable() &&  !mapFields.get(obj.collect__Status_API_Name__c).getDescribe().isCreateable())
                {
                    objwrapperforstatusfields.read = true;
                } 

                objwrapperforstatusfields.objconfig = obj; 
                
                if(objStatus.get(obj.collect__Status_API_Name__c) != Null)
                {
                    objwrapperforstatusfields.strSelectedStatus = String.valueof(objStatus.get(obj.collect__Status_API_Name__c));
                    objwrapperforstatusfields.strSelectedStatusView = String.valueof(objStatus.get(obj.collect__Status_API_Name__c));
                }
                else
                {
                    objwrapperforstatusfields.strSelectedStatusView = 'None';
                }
                
                if(obj.collect__Allowed_Statuses__c != Null)
                {
                    List<String> lststatus = obj.collect__Allowed_Statuses__c.split(';');
                    
                    if(ScCollection_UtilityHandler.isNotNull(lststatus))
                    {
                        objwrapperforstatusfields.lstStatusOptions.add(new SelectOption('None',VAR_NONE));
                        
                        for(String objstr : lststatus)
                        {
                            objwrapperforstatusfields.lstStatusOptions.add(new SelectOption(objstr.trim(), objstr.trim()));
                        }
                    }
                } 
                
                lstwrapperForStatusFields.add(objwrapperforstatusfields);
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic for showing/hiding status edit screen on vf page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 13-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void changeStatus()
    {
        if(editStatus){
            String fieldName = '';
            String fieldValue = '';
            if(strSelectedAction != '')
            {
                if(mapActionIdToActionRecord.containsKey(strSelectedAction) && mapActionIdToActionRecord.get(strSelectedAction) != Null) 
                {
                    if(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c != Null)
                    {
                        fieldName = mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Fiels_Api_Name__c;
                        
                        if(mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Field_Values__c != Null)
                        {
                            fieldValue = mapActionIdToActionRecord.get(strSelectedAction).collect__Action_Code__r.ScCollection_Status_Field_Values__c;
                        }
                        else
                        {
                            fieldValue = '';
                        }
                        
                    }
                }
            }
            if(fieldName != '' && lstwrapperForStatusFields != null && lstwrapperForStatusFields.Size() >0){
                for(wrapperForStatusFields obj : lstwrapperForStatusFields){
                    if(obj.objconfig.collect__Status_API_Name__c == fieldName){
                        obj.strSelectedStatus = fieldValue;
                    }
                }
            }
        }
    }
    
    //Wrapper for Integration Mortgage
    public class InteractionLogWrapper{
        public String countryCode{get;set;}
        public String lob{get;set;}
        public String loanNumber{get;set;}
        public String usernEmailAddress{get;set;}
        public String collectionsActivityDescription{get;set;}
        public String commentSurrogate{get;set;}
        public String commentSequenceSGT{get;set;}
        public String commentRecordNumber{get;set;}
        public String commentSequenceNumber{get;set;}
        public String commentDetailLine{get;set;}
        public String commentF{get;set;}
        public String hardshipRequestedBy{get;set;}
        public String hardshipCommunicatedBy{get;set;}
        public String hardshipDocsRecvdDate{get;set;}
        public String icmReviewDate{get;set;} // added COL-1663
        
        public String parse(){
            return  System.JSON.serialize(this);
        }
    }
    
    //Wrapper for Integration PAF
    public class InteractionLogPAF{
        
        public String contractNumber{get;set;}
        public String auditUser{get;set;}
        public String auditDate{get;set;}
        public String comments{get;set;}
        public String eventDescription{get;set;}
        public String reason{get;set;}
        public String userId{get;set;}
        public String authKey{get;set;}
        
        public String parse(){
            return  System.JSON.serialize(this);
        }
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SyncInteractionLog
    Company:       Saasfocus
    Description:   This method is used to sync interaction log to the source system when log is created.
    Inputs:        String,String,String,String,String,String,String,Date,DateTime
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @future(callout=true)
    public static void SyncInteractionLog(String strSelectedActionName,String comments,String sourceSystemName,String loanNumber,String recordId,String strhardshipRequestedBy,String strhardshipCommunicatedBy,Date strhardshipDocsRecvdDate,DateTime strReviewDate){
        
        if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Sync_Interaction_Log')){
            return;
        }
        
        String mortgage = 'MORTGAGE';
        String paf = 'PAF';
        string loanNumb = '';
        String apiParameterName = 'InteractionLogSyncMortgage';
        String apiParameterNamePaf = 'InteractionLogSyncPAF'; 
        String apiParameterError = 'GetErrorLog';
        string apiResponse;
        string apiResponseError ;
        String responseString ;
        String errorCode;
        Boolean isError = false;
            
        ScCollection_MeetingNotesResponseSuccess responseApi;
        ScCollection_MeetingNotesResponseSuccess responseApiError;
        
        User ObjUsr = [Select Id,Email,Name,FirstName,LastName From User where Id = :UserInfo.GetUserID()];
        String usrName = '';
        if(!String.IsBlank(ObjUsr.FirstName)){
            usrName = ObjUsr.FirstName.substring(0,1);
        }
        usrName += ObjUsr.LastName;
        Integer userNameSize = usrName.Length();
        if(userNameSize > 20){
            usrName = usrName.substring(0,20);
        }

        String reviewDate = '';
        if(strReviewDate != null){
            if(strReviewDate.Day() < 10){
                reviewDate = '0'+String.ValueOf(strReviewDate.Day());
            }
            else{
                reviewDate = String.ValueOf(strReviewDate.Day());
            }
            if(strReviewDate.Month() < 10){
                reviewDate += '0'+String.valueOf(strReviewDate.Month());
            }
            else{
                reviewDate += String.valueOf(strReviewDate.Month());
            }
            reviewDate += String.ValueOf(strReviewDate.Year());
        }
        
        ScCollection_PaymentAPIParameters__c objcred;
        String str;
        if(sourceSystemName == mortgage){
            if(!String.isBlank(loanNumber)){
                loanNumb = loanNumber.split('\\_')[0];
            }
            
            ScCollection_CreateLogController.InteractionLogWrapper objWrapper = new ScCollection_CreateLogController.InteractionLogWrapper();
            objWrapper.countryCode = 'AU';
            objWrapper.lob = sourceSystemName.toLowerCase();
            objWrapper.loanNumber = loanNumb;
            objWrapper.usernEmailAddress =objUsr.Email; //'pepperesb@pepper.com.au';
            objWrapper.collectionsActivityDescription = strSelectedActionName;
            objWrapper.commentSurrogate = '';
            objWrapper.commentSequenceSGT = '';
            objWrapper.commentRecordNumber = '0';
            objWrapper.commentSequenceNumber = '0';
            if(!String.isBlank(comments)){
                comments = comments.replace('\r\n', ' ');
                comments = comments.replace('<', '&lt;');
                comments = comments.replace('>', '&gt;');
            }    
            objWrapper.commentDetailLine = comments;
            objWrapper.commentF = 'H';
            if(strhardshipRequestedBy != null){
                objWrapper.hardshipRequestedBy = strhardshipRequestedBy;
            }
            else{
                objWrapper.hardshipRequestedBy = '';
            }
            if(strhardshipCommunicatedBy != null){
                objWrapper.hardshipCommunicatedBy = strhardshipCommunicatedBy;
            }
            else{
                objWrapper.hardshipCommunicatedBy = '';
            }
            if(strhardshipDocsRecvdDate != null){
                String receivedDate = String.valueOf(strhardshipDocsRecvdDate.day())+String.valueOf(strhardshipDocsRecvdDate.Month())+String.valueOf(strhardshipDocsRecvdDate.Year());
                objWrapper.hardshipDocsRecvdDate = receivedDate;
            }
            else{
                objWrapper.hardshipDocsRecvdDate = '';
            }
            
            objWrapper.icmReviewDate = reviewDate.trim();
            
            
            objcred = ScCollection_PaymentAPIParameters__c.getValues(apiParameterName);
            str = objWrapper.parse(); 
            system.debug('str =='+str );
        }
        
        else if(sourceSystemName == paf){
            
            objcred = ScCollection_PaymentAPIParameters__c.getValues(apiParameterNamePaf);
          
            Date d = System.today();
            Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
            String myDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            
            InteractionLogPAF objInteractionLogPAF = new InteractionLogPAF();
            objInteractionLogPAF.contractNumber = loanNumber;
            objInteractionLogPAF.auditUser = usrName;
            objInteractionLogPAF.auditDate= myDate ;
            objInteractionLogPAF.comments = comments;
            objInteractionLogPAF.eventDescription= '';
            objInteractionLogPAF.reason= '';
            objInteractionLogPAF.userId = objcred.ScCollection_CMS_User_Id__c;
            objInteractionLogPAF.authKey = objcred.ScCollection_CMS_Auth_Key__c;
            
            str = objInteractionLogPAF.parse(); 
            system.debug('str PAF Request=='+str );
        }
        else{
            return;
        }
          
            
        if(str != null && objcred != null){
            
            try{
                String apiUrl = objcred.Endpoint__c;
                Http objhttp = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(apiUrl);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objcred.Username__c+ ':' + objcred.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setTimeout(120000);
                req.setBody(str);
                HttpResponse res = objhttp.send(req);
                apiResponse =  res.getBody();
                system.debug('responseApi SUCCESS==='+apiResponse );
                
                if(apiResponse != null)
                    responseApi = ScCollection_MeetingNotesResponseSuccess.parse(apiResponse);
                    
                if(sourceSystemName == paf){
                    collect__Interaction_Log__c objInteraction = new collect__Interaction_Log__c();
                    objInteraction.Id = recordId;
                    objInteraction.ScCollection_Exception_Type__c = '';
                    objInteraction.ScCollection_Request_Endpoint__c = apiUrl;
                    objInteraction.ScCollection_Request_Message__c = str;
                    objInteraction.ScCollection_Response_Message__c = 'Response Status Code ==> ' +res.getStatusCode()+' || API Response ==> '+ apiResponse;
                    if(res.getStatusCode() == 200){
                        objInteraction.ScCollection_Synced__c = true;
                        objInteraction.ScCollection_Error_Message__c =null;
                        objInteraction.ScCollection_Error_Message_Exist__c =false;
                        
                    }
                    else{
                        objInteraction.ScCollection_Exception_Type__c = 'Technical Exception';
                        objInteraction.ScCollection_Error_Message__c = 'We have received again an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                        objInteraction.ScCollection_Synced__c = false; 
                        objInteraction.ScCollection_Error_Message_Exist__c = true;
                        if(responseApi != null && responseApi.APIStatus != null){
                            
                            for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                if(objApiResponseMsg.Message != null){
                                    system.debug('objApiResponseMsg'+objApiResponseMsg);
                                    objInteraction.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                }
                                
                            }
                        }
                    }
                    update objInteraction;
                }
                if(sourceSystemName == mortgage){
                    collect__Interaction_Log__c objInteraction = new collect__Interaction_Log__c();
                    objInteraction.Id = recordId;
                    objInteraction.ScCollection_Exception_Type__c = '';
                    objInteraction.ScCollection_Request_Endpoint__c = apiUrl;
                    objInteraction.ScCollection_Request_Message__c = str;
                    objInteraction.ScCollection_Response_Message__c = 'Response Status Code ==> ' +res.getStatusCode()+' || API Response ==> '+ apiResponse;
                    
                    if(responseApi != null){    
                        if(res.getStatusCode() == 200){
                            
                            if(responseApi.APIStatus != null){
                                if(responseApi.APIStatus.APICode =='200'){
                                    
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences objPageRef: responseApi.APIStatus.PepperReferences){
                                            if(objPageRef.PepperReference.ReferenceType == 'apiStatus'){
                                                if(objPageRef.PepperReference.Reference == '99'){
                                                    objInteraction.ScCollection_Synced__c = true;
                                                    objInteraction.ScCollection_Error_Message__c = null;
                                                    objInteraction.ScCollection_Error_Message_Exist__c = false;
                                                }
                                                else{
                                                    isError = True;
                                                }
                                            }
                                            //ApiLog Code needs to get error msg
                                            if(objPageRef.PepperReference.ReferenceType == 'apiLog'){
                                                errorCode =  objPageRef.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                                else{
                                    objInteraction.ScCollection_Exception_Type__c = 'Technical Exception';
                                    isError = True;
                                    objInteraction.ScCollection_Error_Message__c = 'We have received again an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                                    objInteraction.ScCollection_Synced__c = false; 
                                    objInteraction.ScCollection_Error_Message_Exist__c = true;
                                    
                                    for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                        if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                            objInteraction.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        else if(res.getStatusCode() == 500){
                            objInteraction.ScCollection_Exception_Type__c = 'Technical Exception';
                            objInteraction.ScCollection_Error_Message__c = 'We have received an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                            objInteraction.ScCollection_Error_Message_Exist__c = true;
                            
                            if(responseApi.APIStatus !=null){
                                if(responseApi.APIStatus.APICode =='500'){
                                    
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences objPageRef: responseApi.APIStatus.PepperReferences){
                                            if(objPageRef.PepperReference.ReferenceType == 'apiStatus'){
                                                if(objPageRef.PepperReference.Reference != '99'){
                                                    isError = True;
                                                }
                                            }
                                            //ApiLog Code needs to get error msg
                                            if(objPageRef.PepperReference.ReferenceType == 'apiLog'){
                                                errorCode =  objPageRef.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if(res.getStatusCode() == 401){
                            objInteraction.ScCollection_Exception_Type__c = 'Technical Exception';
                            if(responseApi.APIStatus !=null){
                                if(responseApi.APIStatus.APICode =='401'){
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                            if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                                if(tempresponse.PepperReference.Reference != '99'){
                                                    //objContract.ScCollection_Error_Occurred__c = true;
                                                    //objContract.ScCollection_API_Call_Not_Process__c = false;
                                                    isError = True;
                                                }
                                            }
                                            if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                                errorCode = tempresponse.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            objInteraction.ScCollection_Exception_Type__c = 'Technical Exception';
                            objInteraction.ScCollection_Synced__c = false;
                            objInteraction.ScCollection_Error_Message__c = 'We have received an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                            objInteraction.ScCollection_Error_Message_Exist__c = true;
                            if(responseApi != null && responseApi.APIStatus != null){
                                if(responseApi.APIStatus.Messages != null && responseApi.APIStatus.Messages.size()>0){
                                    for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                        if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                            objInteraction.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                        }
                                    }
                                }
                            }
                        }
                        
                        if(isError && !String.isBlank(errorCode)){
                            String strErrorResponse = ScCollection_CommonCodeHandler.GetErrorResponse(errorCode);
                            
                            objInteraction.ScCollection_Synced__c = false;
                            objInteraction.ScCollection_Error_Message__c = strErrorResponse;
                            objInteraction.ScCollection_Error_Message_Exist__c = true;
                            String respnseWithErrorCode = 'Response Status Code ==> ' +res.getStatusCode()+' || API LOG ==> '+errorCode +' || API Response ==> '+  apiResponse;
                            objInteraction.ScCollection_Response_Message__c = respnseWithErrorCode;
                            
                        }
                    }
                update objInteraction;  
                }
            }
            catch(Exception e){
                responseString = 'Record saved in ICM successfully but received following error in sync process. Please try again with Sync Log button or contact with System Administrator.: ' + e.getMessage();
                collect__Interaction_Log__c objInteraction = new collect__Interaction_Log__c();
                objInteraction.Id = recordId;
                objInteraction.ScCollection_Synced__c = false;
                objInteraction.ScCollection_Error_Message_Exist__c = true;
                objInteraction.ScCollection_Error_Message__c = responseString;
                
                objInteraction.ScCollection_Exception_Type__c = 'Technical Exception';
                
                
                update objInteraction;
            }
        }   
            
        
        
    }
    
    /*------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SyncData
    Company:       Saasfocus
    Description:   This method is used to sync interaction log to the source system.
    Inputs:        no input.
    Returns:       void
    ------------------------------------------------------------*/
    public void SyncData(){
        if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Sync_Interaction_Log') && !objLog.collect__Action__r.ScCollection_Available_for_Sync__c){
            return;
        }
        
       String sourceSystemName ; 
       String loanNumber;
       
       String strSelectedActionName = objLog.collect__Action__r.Name;
       String comments = objLog.collect__Description__c;
       //String recordId = objLog.Id;
       
       if(strObjectName == VAR_CLCONTRACT_API)
       {
            collect__Loan_Account__c objcnt = (collect__Loan_Account__c)mapResult.get(strContractId); 
            
            sourceSystemName = objcnt.ScCollection_Source_System_Name__c;
            loanNumber = objcnt.Name;
       }
       
        String mortgage = 'MORTGAGE';
        String paf = 'PAF';
        string loanNumb = '';
        String apiParameterName = 'InteractionLogSyncMortgage';
        String apiParameterNamePaf = 'InteractionLogSyncPAF';
        String apiParameterError = 'GetErrorLog';
        string apiResponse;
        string apiResponseError ;
        String responseString ;
        String errorCode;
        Boolean isError = false;
            
        ScCollection_MeetingNotesResponseSuccess responseApi;
        ScCollection_MeetingNotesResponseSuccess responseApiError;
        
        User ObjUsr = [Select Id,Email,Name,FirstName,LastName From User where Id = :UserInfo.GetUserID()];
        
        //creating username First 2 char of FirstName and LastName not more than 20 char
        String usrName = '';
        if(!String.IsBlank(ObjUsr.FirstName)){
            usrName = ObjUsr.FirstName.substring(0,1);
        }
        usrName += ObjUsr.LastName;
        Integer userNameSize = usrName.Length();
        if(userNameSize > 20){
            usrName = usrName.substring(0,20);
        }

        ScCollection_PaymentAPIParameters__c objcred;
        String str;
        if(sourceSystemName == mortgage){
            if(!String.isBlank(loanNumber)){
                loanNumb = loanNumber.split('\\_')[0];
            }
            ScCollection_CreateLogController.InteractionLogWrapper objWrapper = new ScCollection_CreateLogController.InteractionLogWrapper();
            objWrapper.countryCode = 'AU';
            objWrapper.lob = sourceSystemName.toLowerCase();
            objWrapper.loanNumber = loanNumb;
            objWrapper.usernEmailAddress = ObjUsr.Email;//'pepperesb@pepper.com.au';
            objWrapper.collectionsActivityDescription = strSelectedActionName;
            objWrapper.commentSurrogate = '';
            objWrapper.commentSequenceSGT = '';
            objWrapper.commentRecordNumber = '0';
            objWrapper.commentSequenceNumber = '0';
            if(objLog.ScCollection_Requested_by__c != null){
                objWrapper.hardshipRequestedBy = objLog.ScCollection_Requested_by__c;
            }
            else{
                objWrapper.hardshipRequestedBy = '';
            }
            if(objLog.ScCollection_Requested_Via__c != null){
                objWrapper.hardshipCommunicatedBy = objLog.ScCollection_Requested_Via__c;
            }
            else{
                objWrapper.hardshipCommunicatedBy = '';
            }if(objLog.ScCollection_Date_all_documents_received__c != null){
                objWrapper.hardshipDocsRecvdDate = String.ValueOf(objLog.ScCollection_Date_all_documents_received__c.Day())+String.ValueOf(objLog.ScCollection_Date_all_documents_received__c.Month())+String.ValueOf(objLog.ScCollection_Date_all_documents_received__c.Year());
            }
            else{
                objWrapper.hardshipDocsRecvdDate = '';
            }
            
            
            if(!String.isBlank(comments)){
                comments = comments.replace('\r\n', ' ');
                comments = comments.replace('<', '&lt;');
                comments = comments.replace('>', '&gt;');
            }    
            objWrapper.commentDetailLine = comments;
            objWrapper.commentF = 'H';
            
            if(objLog.collect__Follow_Up_Date_Time__c != null){
                 String reviewDate = '';
                
                if(objLog.collect__Follow_Up_Date_Time__c.Day() < 10){
                    reviewDate = '0'+String.ValueOf(objLog.collect__Follow_Up_Date_Time__c.Day());
                }
                else{
                    reviewDate = String.ValueOf(objLog.collect__Follow_Up_Date_Time__c.Day());
                }
                if(objLog.collect__Follow_Up_Date_Time__c.Month() < 10){
                    reviewDate += '0'+String.ValueOf(objLog.collect__Follow_Up_Date_Time__c.Month());
                }
                else{
                    reviewDate += String.ValueOf(objLog.collect__Follow_Up_Date_Time__c.Month());
                }
                reviewDate += String.ValueOf(objLog.collect__Follow_Up_Date_Time__c.Year());
                objWrapper.icmReviewDate = reviewDate.trim();
            }
            else{
                objWrapper.icmReviewDate ='';
            }
                
            
            objcred = ScCollection_PaymentAPIParameters__c.getValues(apiParameterName);
            str = objWrapper.parse(); 
        }
        else if(sourceSystemName == paf){
            
            objcred = ScCollection_PaymentAPIParameters__c.getValues(apiParameterNamePaf);
           
            Date d = System.today();
            Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
            String myDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            
            InteractionLogPAF objInteractionLogPAF = new InteractionLogPAF();
            objInteractionLogPAF.contractNumber = loanNumber;
            objInteractionLogPAF.auditUser = usrName;
            objInteractionLogPAF.auditDate= myDate;
            objInteractionLogPAF.comments = comments;
            objInteractionLogPAF.eventDescription= '';
            objInteractionLogPAF.reason= '';
            objInteractionLogPAF.userId = objcred.ScCollection_CMS_User_Id__c;
            objInteractionLogPAF.authKey = objcred.ScCollection_CMS_Auth_Key__c;
            
            str = objInteractionLogPAF.parse(); 
        }
        else{
            return;
        } 
            
        if(objcred != null && str != null){
            try{
                String apiUrl = objcred.Endpoint__c;
                Http objhttp = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(apiUrl);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objcred.Username__c+ ':' + objcred.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setTimeout(120000);
                req.setBody(str);
                HttpResponse res = objhttp.send(req);
                apiResponse =  res.getBody();
                
                //Debug Request and Response
                System.debug('request ='+str);
                system.debug('responseApi SUCCESS==='+apiResponse );
                
                objLog.ScCollection_Exception_Type__c = '';
                objLog.ScCollection_Request_Endpoint__c = apiUrl;
                objLog.ScCollection_Request_Message__c = str;
                objLog.ScCollection_Response_Message__c = 'Response Status Code ==> ' +res.getStatusCode()+' || API Response ==> '+apiResponse;
                
                if(apiResponse != null)
                    responseApi = ScCollection_MeetingNotesResponseSuccess.parse(apiResponse);
                
                if(sourceSystemName == paf){
                    
                    if(res.getStatusCode() == 200){
                        
                        objLog.ScCollection_Error_Message__c = null;
                        objLog.ScCollection_Synced__c = true;
                        objLog.ScCollection_Error_Message_Exist__c =false;
                        
                    }
                    else{
                        objLog.ScCollection_Exception_Type__c = 'Technical Exception';
                        objLog.ScCollection_Error_Message__c = 'We have received again an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                        objLog.ScCollection_Synced__c = false; 
                        objLog.ScCollection_Error_Message_Exist__c = true;
                        
                        if(responseApi != null && responseApi.APIStatus != null){
                            
                            for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                if(objApiResponseMsg.Message != null){
                                    
                                    objLog.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                } 
                            }
                        }
                    }
                   
                    update objLog;
                }
                if(sourceSystemName == mortgage){
                    
                    if(responseApi != null){    
                        if(res.getStatusCode() == 200){
                            
                            if(responseApi.APIStatus != null){
                                if(responseApi.APIStatus.APICode =='200'){
                                    
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences objPageRef: responseApi.APIStatus.PepperReferences){
                                            if(objPageRef.PepperReference.ReferenceType == 'apiStatus'){
                                                if(objPageRef.PepperReference.Reference == '99'){
                                                    
                                                    objLog.ScCollection_Synced__c = true;
                                                    objLog.ScCollection_Error_Message__c = null;
                                                    objLog.ScCollection_Error_Message_Exist__c = false;
                                                    
                                                }
                                                else{
                                                    isError = True;
                                                }
                                            }
                                            //ApiLog Code needs to get error msg
                                            if(objPageRef.PepperReference.ReferenceType == 'apiLog'){
                                                errorCode =  objPageRef.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                                else{
                                    objLog.ScCollection_Exception_Type__c = 'Technical Exception';
                                    isError = True;
                                    objLog.ScCollection_Error_Message__c = 'We have received again an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                                    objLog.ScCollection_Synced__c = false; 
                                    objLog.ScCollection_Error_Message_Exist__c = true;
                                    if(responseApi.APIStatus.Messages != null && responseApi.APIStatus.Messages.Size() > 0){
                                        for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                            if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                                
                                                objLog.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                        else if(res.getStatusCode() == 500){
                            objLog.ScCollection_Exception_Type__c = 'Technical Exception';
                            if(responseApi.APIStatus !=null){
                                if(responseApi.APIStatus.APICode =='500'){
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences objPageRef: responseApi.APIStatus.PepperReferences){
                                            if(objPageRef.PepperReference.ReferenceType == 'apiStatus'){
                                                if(objPageRef.PepperReference.Reference != '99'){
                                                    isError = True;
                                                }
                                            }
                                            //ApiLog Code needs to get error msg
                                            if(objPageRef.PepperReference.ReferenceType == 'apiLog'){
                                                errorCode =  objPageRef.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        else if(res.getStatusCode() == 401){
                            objLog.ScCollection_Exception_Type__c = 'Technical Exception';
                            if(responseApi.APIStatus !=null){
                                if(responseApi.APIStatus.APICode =='401'){
                                    if(responseApi.APIStatus.PepperReferences != null && responseApi.APIStatus.PepperReferences.size()>0){
                                        for(ScCollection_MeetingNotesResponseSuccess.PepperReferences tempresponse: responseApi.APIStatus.PepperReferences){
                                            if(tempresponse.PepperReference.ReferenceType == 'apiStatus'){
                                                if(tempresponse.PepperReference.Reference != '99'){
                                                    //objContract.ScCollection_Error_Occurred__c = true;
                                                    //objContract.ScCollection_API_Call_Not_Process__c = false;
                                                    isError = True;
                                                }
                                            }
                                            if(tempresponse.PepperReference.ReferenceType == 'apiLog'){
                                                errorCode = tempresponse.PepperReference.Reference;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            objLog.ScCollection_Exception_Type__c = 'Technical Exception';
                            objLog.ScCollection_Synced__c = false;
                            objLog.ScCollection_Error_Message__c = 'We have received again an issue (i.e. API request didn\'t reach to source system) in sync to source system process. Please contact with System Administrator.';
                            objLog.ScCollection_Error_Message_Exist__c = true;
                            if(responseApi != null && responseApi.APIStatus != null){
                                if(responseApi.APIStatus.Messages != null && responseApi.APIStatus.Messages.size()>0){
                                    for(ScCollection_MeetingNotesResponseSuccess.Messages objApiResponseMsg : responseApi.APIStatus.Messages){
                                        if(objApiResponseMsg.Message != null && objApiResponseMsg.Message.MessageCode == 'ERROR'){
                                            objLog.ScCollection_Error_Message__c = objApiResponseMsg.Message.MessageDescription;
                                        }
                                    }
                                }
                            }
                        }
                        
                        if(isError && !String.isBlank(errorCode)){
                            String strErrorResponse = ScCollection_CommonCodeHandler.GetErrorResponse(errorCode);
                            objLog.ScCollection_Synced__c = false;
                            objLog.ScCollection_Error_Message__c = strErrorResponse;
                            objLog.ScCollection_Error_Message_Exist__c = true;
                            String respnseWithErrorCode = 'Response Status Code ==> ' +res.getStatusCode()+'|| API LOG ==> '+errorCode +' || API Response ==> '+  apiResponse;
                            objLog.ScCollection_Response_Message__c = respnseWithErrorCode;
                        }
                    }
                
                    update objLog;
                }
            }
            catch(Exception e){
                responseString = 'We have received following error in sync process : ' + e.getMessage() + ' Please contact with System Administrator.';
                objLog.ScCollection_Exception_Type__c = 'Technical Exception';
                objLog.ScCollection_Synced__c = false;
                objLog.ScCollection_Error_Message__c = responseString;
                objLog.ScCollection_Error_Message_Exist__c = true;
                system.debug(e.getStackTraceString());
                update objLog;
            }
        }    
    }
}