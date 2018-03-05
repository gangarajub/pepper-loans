// --------------------------------------------------------------------------------------------------------
// This class handles the logic for the custom vf pages on console right side section view for pepper collections
// --------------------------------------------------------------------------------------------------------
// Created Date: 18-JUN-2016      Created By: Pawan Mudgal     Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestCnslRightComponentHand
// --------------------------------------------------------------------------------------------------------
public class ScCollection_CnslRightComponentHandler 
{
    //variable declaration for the data to be populated on components
    public String strLogIndex {get;set;}
    
    //variables to hold data for the current contract record
    public String strContractId {get;set;}
    public String strContractName {get;set;}
    public String strObjectName = '';
    
    // variables for profile permission created by deepak dhingra
    public boolean interactionLogRead {get;set;}
    public boolean interactionLogDelete {get;set;}
    public boolean interactionLogCreate {get;set;}
    
    public List<collect__Interaction_Log__c> lstLog {get;set;}
    public List<cnotify__Delivery_Detail__c> lstNotifications {get;set;}
    public List<wrapperForAuditHistory> lstWrapperForAuditHistory {get;set;}
    public Map<String,Decimal> mapContractAgsintCont {get;set;}
    
    public Map<Id,SObject> mapObjectData = new Map<Id,SObject>();

    //map to hold labels for all the fields of PL and Cl Contract to be used fot audit history data
    public static final Map<String, Schema.SObjectField> VAR_PLCONTRACT_FIELDMAP = Schema.SObjectType.loan__Loan_Account__c.fields.getMap();
    public static final Map<String, Schema.SObjectField> VAR_CLCONTRACT_FIELDMAP = Schema.SObjectType.collect__Loan_Account__c.fields.getMap();
    public static final Map<String, Schema.SObjectField> VAR_STATUS_FIELDMAP = Schema.SObjectType.collect__Contract_Status__c.fields.getMap();
    
    public static final String VAR_LOG_API = 'collect__Interaction_Log__c';
    public static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
    public static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    
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
    
    //constructor for variable initialization
    public ScCollection_CnslRightComponentHandler() 
    {
        //variable initialization for the data to be populated on component
        strLogIndex = '';
        strContractId = '';
        strContractName = '';
        interactionLogRead = false;
        interactionLogDelete = false;
        interactionLogCreate = false;
        
        lstLog = new List<collect__Interaction_Log__c>();
        lstNotifications = new List<cnotify__Delivery_Detail__c>();
        lstWrapperForAuditHistory = new List<wrapperForAuditHistory>();
        mapContractAgsintCont = new Map<String,Decimal>();
        
        //add object api name to get the permission
        List<String> lstobjects = new List<String>();
        lstobjects.add(VAR_LOG_API);
       
        Map<Id,Map<String,Map<String,Boolean>>> mappermissions = new Map<Id,Map<String,Map<String,Boolean>>>();
        Map<Id,List<String>> mapprofileidtoobjectsrequired = new Map<Id,List<String>>();
        mapprofileidtoobjectsrequired.put(UserInfo.getProfileId(),lstobjects);
        
        mappermissions = ScCollection_CommonCodeHandler.getCrudPermissions(mapprofileidtoobjectsrequired);
        
        // set permissions for objects
        if(mappermissions.containsKey(UserInfo.getProfileId()))
        {
            if(mappermissions.get(UserInfo.getProfileId()).containskey(VAR_LOG_API))
            {
                interactionLogRead = mappermissions.get(UserInfo.getProfileId()).get(VAR_LOG_API).get('read');
                interactionLogDelete = mappermissions.get(UserInfo.getProfileId()).get(VAR_LOG_API).get('delete');
                interactionLogCreate = mappermissions.get(UserInfo.getProfileId()).get(VAR_LOG_API).get('create');
            }
        }
        
        mapContractAgsintCont.put('noanswer',0);
        mapContractAgsintCont.put('holddays',0);
        mapContractAgsintCont.put('brokenpromise',0);
        mapContractAgsintCont.put('nocommitment',0);
        mapContractAgsintCont.put('maxdaysnopromise',0);
        mapContractAgsintCont.put('maxdayswithpromise',0);
        mapContractAgsintCont.put('dailyrefercap',0);
        mapContractAgsintCont.put('maxpromisedayscount',0);
        mapContractAgsintCont.put('minimumacceptablecommitment',0);
        mapContractAgsintCont.put('maxpromisedayscountfor1st',0); 
        
        //get the Id from url parameter
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id'))) 
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
            
            //call common method to retrieve object name
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            Set<Id> setContractId = new Set<Id>();
            setContractId.add(strContractId);
            
            //call api method of cls to get current open contract record
            mapObjectData = api.getContracts(setContractId);
            
            //call the get notification data
            Integer notificationlimit = 20;
            
            if(Label.ScCollection_Notification_Size != Null)
            {
                notificationlimit = Integer.valueof(Label.ScCollection_Notification_Size);
            }
                
            lstNotifications = [select Id, Name, cnotify__Subject__c, ScCollection_Letter_URL__c, ScCollection_Communication_Type_Formula__c, ScCollection_Send_To__c, cnotify__Sent__c, cnotify__Sent_Date__c, cnotify__Message__c, ScCollection_Is_Manual__c from cnotify__Delivery_Detail__c where (ScCollection_CL_Contract__c =: strContractId OR ScCollection_PL_Contract__c =: strContractId) ORDER BY cnotify__Sent_Date__c desc NULLS LAST limit: notificationlimit];
        }
        
        //call methods to populate data on vf pages
        ProcessDataForRightComponent();
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the data process for console right component
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void ProcessDataForRightComponent() 
    {
        if(ScCollection_UtilityHandler.isNotNull(strObjectName)) 
        {
            //code to populate the count againset the setting
            for(ScCollection_ContractSettings__c obj : [select ScCollection_BrokenPromiseCount__c,
                                                               ScCollection_HoldDaysCount__c,
                                                               ScCollection_NoAnswerCount__c,
                                                               ScCollection_NoCommitmentCount__c 
                                                               from ScCollection_ContractSettings__c 
                                                               where (ScCollection_CLContract__c =: strContractId OR
                                                               ScCollection_DevContract__c =: strContractId) AND 
                                                               ScCollection_UserLookup__c =: UserInfo.getUserId() limit 1])
            {
                mapContractAgsintCont.put('noanswer',obj.ScCollection_NoAnswerCount__c == Null ? 0 : obj.ScCollection_NoAnswerCount__c);
                mapContractAgsintCont.put('holddays',obj.ScCollection_HoldDaysCount__c == Null ? 0 : obj.ScCollection_HoldDaysCount__c);
                mapContractAgsintCont.put('brokenpromise',obj.ScCollection_BrokenPromiseCount__c == Null ? 0 : obj.ScCollection_BrokenPromiseCount__c);
                mapContractAgsintCont.put('nocommitment',obj.ScCollection_NoCommitmentCount__c == Null ? 0 : obj.ScCollection_NoCommitmentCount__c);
                mapContractAgsintCont.put('maxdaysnopromise',0);
                mapContractAgsintCont.put('maxdayswithpromise',0);
                mapContractAgsintCont.put('dailyrefercap',0);
                mapContractAgsintCont.put('mapromisedayscount',0);
                mapContractAgsintCont.put('minimumacceptablecommitment',0);
                mapContractAgsintCont.put('maxpromisedaysCountfor1st',0);
            }
            
            Integer loglimit = 20;
            if(Label.ScCollection_Interaction_Log_Size != Null)
            {
                loglimit = Integer.valueof(Label.ScCollection_Interaction_Log_Size);
            }
            
            //code to populate interaction log list
            lstLog = [select Id, 
                             Name, 
                             collect__Follow_Up_Date_Time__c, 
                             collect__Action__c, 
                             collect__Action__r.Name,
                             ScCollection_Synced__c,
                             ScCollection_Error_Message__c, 
                             collect__Description__c,
                             CreatedBy.Name,
                             CreatedDate
                             from collect__Interaction_Log__c 
                             where (ScCollection_CL_Contract__c =: strContractId OR
                                    collect__Dev_Contract__c =: strContractId) 
                             ORDER BY CreatedDate DESC limit : loglimit];
        
            PrepareAuditHistory();
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method prepared the audit history on basis for contract record
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void PrepareAuditHistory() 
    {
        if(ScCollection_UtilityHandler.isNotNull(strContractId)) 
        {
            String strcontractstatusid = '';
            
            if(strObjectName == VAR_PLCONTRACT_API) 
            {
                loan__Loan_Account__c objplcontract = (loan__Loan_Account__c) mapObjectData.get(strContractId);
                
                strContractName = objplcontract != Null ? objplcontract.Name : '';
                
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
                                                                         ORDER BY CreatedDate DESC limit 20];
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
                            objwrapperforaudithistory.strEditedDate = obj.CreatedDate.format('dd/MM/yyyy h:mm a');
                            objwrapperforaudithistory.editTime = obj.CreatedDate;
                            
                            lstWrapperForAuditHistory.add(objwrapperforaudithistory);
                        }
                    }
                }
            } 
            else if(strObjectName == VAR_CLCONTRACT_API) 
            {
                collect__Loan_Account__c objclcontract = (collect__Loan_Account__c) mapObjectData.get(strContractId);
                strContractName = objclcontract != Null ? objclcontract.Name : '';
                
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
                                                                            ORDER BY CreatedDate DESC limit 20];
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
                            objwrapperforaudithistory.strEditedDate = obj.CreatedDate.format('dd/MM/yyyy h:mm a');
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
                                                                                   ORDER BY CreatedDate DESC limit 20];
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
                            objwrapperforstatushistory.strEditedDate = obj.CreatedDate.format('dd/MM/yyyy h:mm a');
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
        List<WrapperForAuditHistory> lstFinalWrapper = new List<WrapperForAuditHistory>();
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
        
        Integer size = 20;
        Integer i = 0;
        
        if(String.isNotEmpty(Label.ScCollection_Audit_History_Size))
        {
            size = Integer.valueof(Label.ScCollection_Audit_History_Size);
        }
        
        for(wrapperForAuditHistory obj : lstWrapperForAuditHistory)
        {
            if(i < size)
            {
                if(String.isNotEmpty(String.valueOf(obj.strNewValue)) || String.isNotEmpty(String.valueOf(obj.strOldValue)))
                {
                    obj.strAction = 'Changed ' + '<b>' + obj.strFieldName + '</b>' + (String.valueOf(obj.strOldValue) != Null ? ' from ' + String.valueOf(obj.strOldValue) : ' from  None') + (String.valueOf(obj.strNewValue) != Null ? ' to ' + String.valueOf(obj.strNewValue) : ' to None');
                }
                
                if (obj.strOldOwnerName != Null && obj.strNewOwnerName != Null) 
                {
                    obj.strAction = obj.strAction + ' and User from ' + obj.strOldOwnerName + ' to ' + obj.strNewOwnerName;
                }
                
                lstFinalWrapper.add(obj);
            }
            else
            {
                break;     
            }
            
            i++;
        }
        
        lstWrapperForAuditHistory.clear();
        lstWrapperForAuditHistory.addAll(lstFinalWrapper);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles deletion of Interaction Log records on console
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void DeleteLog() 
    {
        if(strLogIndex != '') 
        {
            collect__Interaction_Log__c obj = lstLog[Integer.valueof(strLogIndex)];
            
            try
            {
                delete obj;
            }
            catch(Exception e)
            {
                system.debug('Error in Interaction Log deletion : ' + e.getMessage());
            }
        }
    }
}