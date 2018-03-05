// ----------------------------------------------------------------------------------------------------
// This class would host all the code required for the view all links on right hand side
// ----------------------------------------------------------------------------------------------------
// Created Date: 14-Sept-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestViewAllRightController 
// --------------------------------------------------------------------------------------------------------
public class ScCollection_ViewAllRightController 
{
    public transient List<collect__Interaction_Log__c> lstLog {get;set;}
    public transient List<cnotify__Delivery_Detail__c> lstSms {get;set;}
    public transient List<cnotify__Delivery_Detail__c> lstEmail {get;set;}
    public transient List<cnotify__Delivery_Detail__c> lstLetter {get;set;}
    public transient List<wrapperForAuditHistory> lstWrapperForAuditHistory {get;set;}
    
    //variables to hold data for the current contract record
    public String strContractId {get;set;}
    
    public Boolean showAudit {get;set;}
    public Boolean showLog {get;set;}
    public Boolean showNot {get;set;}
    
    public String strObjectName = '';
    
    public static final String VAR_AUDIT = 'Audits';
    public static final String VAR_LOG = 'Interaction Logs';
    public static final String VAR_NOT = 'Notifications';
    public static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
    public static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    
    //map to hold labels for all the fields of PL and Cl Contract to be used fot audit history data
    public static final Map<String, Schema.SObjectField> VAR_PLCONTRACT_FIELDMAP = Schema.SObjectType.loan__Loan_Account__c.fields.getMap();
    public static final Map<String, Schema.SObjectField> VAR_CLCONTRACT_FIELDMAP = Schema.SObjectType.collect__Loan_Account__c.fields.getMap();
    public static final Map<String, Schema.SObjectField> VAR_STATUS_FIELDMAP = Schema.SObjectType.collect__Contract_Status__c.fields.getMap();
    
    public Map<Id,SObject> mapObjectData = new Map<Id,SObject>();

    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    
    //wrapper to hold info about the standard history records for a particular contract.
    public class wrapperForAuditHistory 
    {
        public String strOldValue {get;set;}
        public String strNewValue {get;set;}
        public String strFieldName {get;set;}
        public String strEditedBy {get;set;}
        public String strEditedDate {get;set;}
        public String strAction {get;set;}
        public String strOldOwnerName {get;set;}
        public String strNewOwnerName {get;set;}
        public DateTime editTime;
        
        public wrapperForAuditHistory() 
        {
            strOldValue = '';
            strNewValue = '';
            strFieldName = '';
            strEditedBy = '';
            strEditedDate = '';
            strAction = '';
            strOldOwnerName = Null;
            strNewOwnerName = Null;
            editTime = Null;
        }
    }
    
    public ScCollection_ViewAllRightController() 
    {
        strContractId = '';
        showAudit = false;
        showLog = false;
        showNot = false;
        
        lstLog = new List<collect__Interaction_Log__c>();
        lstSms = new List<cnotify__Delivery_Detail__c>();
        lstEmail = new List<cnotify__Delivery_Detail__c>();
        lstLetter = new List<cnotify__Delivery_Detail__c>();
        lstWrapperForAuditHistory = new List<wrapperForAuditHistory>();
        
        //get the Id from url parameter
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id'))) 
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
            
            //call common method to retrieve object name
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            Set<Id> setContractId = new Set <Id> ();
            setContractId.add(strContractId);
            
            //call api method of cls to get current open contract record
            mapObjectData = api.getContracts(setContractId);
            
            if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('display')))
            {
                if(ApexPages.currentPage().getParameters().get('display') == VAR_AUDIT)
                {
                    //call method to retrive records for audit history 
                    RetriveAuditHistoryData();
                    showAudit = true;
                }
                else if(ApexPages.currentPage().getParameters().get('display') == VAR_LOG)
                {
                    //call method to retrive records from interaction log object
                    RetriveLogData();
                    showLog = true;
                }
                else if(ApexPages.currentPage().getParameters().get('display') == VAR_NOT)
                {
                    //call method to retrive records from notification
                    for(cnotify__Delivery_Detail__c objnotify : [select Id, Name, cnotify__Subject__c, ScCollection_Letter_URL__c, ScCollection_Communication_Type_Formula__c, ScCollection_Send_To__c, cnotify__Sent__c, cnotify__Sent_Date__c, cnotify__Message__c, ScCollection_Is_Manual__c from cnotify__Delivery_Detail__c where (ScCollection_CL_Contract__c =: strContractId OR ScCollection_PL_Contract__c =: strContractId) ORDER BY cnotify__Sent_Date__c desc])
                    {
                        if(objnotify.ScCollection_Communication_Type_Formula__c == 'Message')
                        {    
                            lstSms.add(objnotify);
                        }
                        else if(objnotify.ScCollection_Communication_Type_Formula__c == 'Email')
                        {    
                            lstEmail.add(objnotify);
                        }
                        else if(objnotify.ScCollection_Communication_Type_Formula__c == 'Letter')
                        {    
                            lstLetter.add(objnotify);
                        }
                    }
                    
                    showNot = true;
                }
            }
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method will Query the logs to display on the screen
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 15-JUN-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void RetriveLogData()
    {
        lstLog = [select Id,
                         Name, 
                         collect__Follow_Up_Date_Time__c, 
                         collect__Action__c, 
                         collect__Action__r.Name, 
                         collect__Description__c,
                         CreatedBy.Name,
                         CreatedDate
                         from collect__Interaction_Log__c 
                         where (ScCollection_CL_Contract__c =: strContractId OR
                                collect__Dev_Contract__c =: strContractId) 
                         ORDER BY CreatedDate DESC limit 50000];
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method will Query different objects to populate audit history data
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 15-JUN-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void RetriveAuditHistoryData()
    {
        if(ScCollection_UtilityHandler.isNotNull(strContractId)) 
        {
            String strcontractstatusid = '';
            
            if(strObjectName == VAR_PLCONTRACT_API) 
            {
                loan__Loan_Account__c objplcontract = (loan__Loan_Account__c) mapObjectData.get(strContractId);
                
                if(objplcontract != Null && objplcontract.ScCollection_Collection_Status__c != Null)
                {
                    strcontractstatusid = objplcontract.ScCollection_Collection_Status__c;
                }
                
                List<loan__Loan_Account__History> lstplhistory = [select ParentId, 
                                                                         OldValue, 
                                                                         NewValue, 
                                                                         Field, 
                                                                         CreatedBy.Name, 
                                                                         CreatedDate 
                                                                         from loan__Loan_Account__History 
                                                                         where parentId =: strContractId 
                                                                         ORDER BY CreatedDate DESC limit 50000];
                if(ScCollection_UtilityHandler.isNotNull(lstplhistory)) 
                {
                    for(loan__Loan_Account__History obj: lstplhistory) 
                    {
                        if(obj.Field != 'created')
                        {
                            wrapperForAuditHistory objwrapperforaudithistory = new wrapperForAuditHistory();
                            
                            if(obj.Field.contains('Date')) 
                            {
                                if(obj.OldValue != Null) 
                                {
                                    objwrapperforaudithistory.strOldValue = Date.valueOf(obj.OldValue).format();
                                } 
                                else 
                                {
                                    objwrapperforaudithistory.strOldValue = 'blank';
                                }
                                if(obj.NewValue != Null) 
                                {
                                    objwrapperforaudithistory.strNewValue = Date.valueOf(obj.NewValue).format();
                                } 
                                else 
                                {
                                    objwrapperforaudithistory.strNewValue = 'blank';
                                }
                            } 
                            else 
                            {
                                objwrapperforaudithistory.strOldValue = String.valueof(obj.OldValue);
                                objwrapperforaudithistory.strNewValue = String.valueof(obj.NewValue);
                            }
    
                            if(VAR_PLCONTRACT_FIELDMAP.containsKey(obj.Field)) 
                            {
                                objwrapperforaudithistory.strFieldName = VAR_PLCONTRACT_FIELDMAP.get(String.valueof(obj.Field)).getDescribe().getLabel();
                            }
                            
                            objwrapperforaudithistory.strEditedBy = String.valueof(obj.CreatedBy.Name);
                            objwrapperforaudithistory.strEditedDate = obj.CreatedDate.format('dd/MM/yyyy h:mm a', 'GMT+10:00');
                            objwrapperforaudithistory.editTime = obj.CreatedDate;
                            
                            lstWrapperForAuditHistory.add(objwrapperforaudithistory);
                        }
                    }
                }
            } 
            else if(strObjectName == VAR_CLCONTRACT_API) 
            {
                collect__Loan_Account__c objclcontract = (collect__Loan_Account__c) mapObjectData.get(strContractId);
                                
                if(objclcontract != Null && objclcontract.collect__Collection_Status__c != Null)
                {
                    strcontractstatusid = objclcontract.collect__Collection_Status__c;
                }
                
                List<collect__Loan_Account__History> lstclhistory = [select ParentId, 
                                                                            OldValue, 
                                                                            NewValue, 
                                                                            Field, 
                                                                            CreatedBy.Name, 
                                                                            CreatedDate 
                                                                            from collect__Loan_Account__History 
                                                                            where parentId =: strContractId 
                                                                            ORDER BY CreatedDate DESC limit 50000];
                if(ScCollection_UtilityHandler.isNotNull(lstclhistory)) 
                {
                    for(collect__Loan_Account__History obj: lstclhistory) 
                    {
                        if(obj.Field != 'created')
                        {
                            wrapperForAuditHistory objwrapperforaudithistory = new wrapperForAuditHistory();
                 
                            if(obj.Field.contains('Date')) 
                            {
                                if(obj.OldValue != Null) 
                                {
                                    objwrapperforaudithistory.strOldValue = Date.valueOf(obj.OldValue).format();
                                } 
                                else 
                                {
                                    objwrapperforaudithistory.strOldValue = 'blank';
                                }
                                if(obj.NewValue != Null) 
                                {
                                    objwrapperforaudithistory.strNewValue = Date.valueOf(obj.NewValue).format();
                                } 
                                else 
                                {
                                    objwrapperforaudithistory.strNewValue = 'blank';
                                }
                            } 
                            else 
                            {
                                objwrapperforaudithistory.strOldValue = String.valueof(obj.OldValue);
                                objwrapperforaudithistory.strNewValue = String.valueof(obj.NewValue);
                            }
    
                            if(VAR_CLCONTRACT_FIELDMAP.containsKey(obj.Field)) 
                            {
                                objwrapperforaudithistory.strFieldName = VAR_CLCONTRACT_FIELDMAP.get(String.valueof(obj.Field)).getDescribe().getLabel();
                            }
                            
                            objwrapperforaudithistory.strEditedBy = String.valueof(obj.CreatedBy.Name);
                            objwrapperforaudithistory.strEditedDate = obj.CreatedDate.format('dd/MM/yyyy h:mm a', 'GMT+10:00');
                            objwrapperforaudithistory.editTime = obj.CreatedDate;
                            
                            lstWrapperForAuditHistory.add(objwrapperforaudithistory);
                        }
                    }
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(strcontractstatusid)) 
            {
                List<collect__Contract_Status__History> lststatushistory = [select ParentId, 
                                                                                   OldValue, 
                                                                                   NewValue, 
                                                                                   Field, 
                                                                                   CreatedBy.Name, 
                                                                                   CreatedDate 
                                                                                   from collect__Contract_Status__History 
                                                                                   where parentId =: strcontractstatusid
                                                                                   ORDER BY CreatedDate DESC limit 50000];
                //prepare the wrapper
                if(ScCollection_UtilityHandler.isNotNull(lststatushistory)) 
                {
                    for(collect__Contract_Status__History obj: lststatushistory) 
                    {
                        if(obj.Field != 'created')
                        {
                            wrapperForAuditHistory objwrapperforstatushistory = new wrapperForAuditHistory();
                            
                            if(obj.Field.contains('Date')) 
                            {
                                if (obj.OldValue != Null) 
                                {
                                    objwrapperforstatushistory.strOldValue = Date.valueOf(obj.OldValue).format();
                                } 
                                else 
                                {
                                    objwrapperforstatushistory.strOldValue = 'blank';
                                }
                                if (obj.NewValue != Null) 
                                {
                                    objwrapperforstatushistory.strNewValue = Date.valueOf(obj.NewValue).format();
                                } 
                                else 
                                {
                                    objwrapperforstatushistory.strNewValue = 'blank';
                                }
                            } 
                            else 
                            {
                                objwrapperforstatushistory.strOldValue = String.valueof(obj.OldValue);
                                objwrapperforstatushistory.strNewValue = String.valueof(obj.NewValue);
                            }
                            
                            if(VAR_STATUS_FIELDMAP.containsKey(obj.Field)) 
                            {
                                objwrapperforstatushistory.strFieldName = VAR_STATUS_FIELDMAP.get(String.valueof(obj.Field)).getDescribe().getLabel();
                            }
                            
                            objwrapperforstatushistory.strEditedBy = String.valueof(obj.CreatedBy.Name);
                            objwrapperforstatushistory.strEditedDate = obj.CreatedDate.format('dd/MM/yyyy h:mm a', 'GMT+10:00');
                            objwrapperforstatushistory.editTime = obj.CreatedDate;
                            
                            lstWrapperForAuditHistory.add(objwrapperforstatushistory);
                        }
                    }
                }
            }
            
            if(lstWrapperForAuditHistory != Null && lstWrapperForAuditHistory.size() > 0)
            {
                SortAuditHistoryList();
            }
        }
    }
    
    // this method would sort the audit history list as per created date
    public void SortAuditHistoryList()
    {
        Integer n = lstWrapperForAuditHistory.size();
        Integer k;
        
        for(Integer m = n; m > 0; m--) 
        {
            for(Integer i = 0; i < n - 1; i++) 
            {
                k = i + 1;
                if(lstWrapperForAuditHistory[i].editTime < lstWrapperForAuditHistory[k].editTime) 
                {
                    wrapperForAuditHistory tmep;
                    tmep = lstWrapperForAuditHistory[i];
                    lstWrapperForAuditHistory[i] = lstWrapperForAuditHistory[k];
                    lstWrapperForAuditHistory[k] = tmep;
                }
            }
        }
        
        for(wrapperForAuditHistory obj : lstWrapperForAuditHistory)
        {
            if(String.isNotEmpty(String.valueOf(obj.strNewValue)) || String.isNotEmpty(String.valueOf(obj.strOldValue)))
            {
                obj.strAction = 'Changed ' + '<b>' + obj.strFieldName + '</b>' + (String.valueOf(obj.strOldValue) != Null ? ' from ' + String.valueOf(obj.strOldValue) : ' from  None') + (String.valueOf(obj.strNewValue) != Null ? ' to ' + String.valueOf(obj.strNewValue) : ' to None');
            }
                
            if (obj.strOldOwnerName != Null && obj.strNewOwnerName != Null) 
            {
                obj.strAction = obj.strAction + ' and User from ' + obj.strOldOwnerName + ' to ' + obj.strNewOwnerName;
            } 
        }
    }
}