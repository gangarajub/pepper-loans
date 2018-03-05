// ----------------------------------------------------------------------------------------------------
// This class would be used to host common methods that can be used throughout the org.
// ----------------------------------------------------------------------------------------------------
// Created Date: 07-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Modified Dare: 8-Aug-2016    Modified By: Deepak Dhingra   Email:deepak.dhingra@saasfocus.com
// Overloaded method : retriveSalesforceObjectType() , bulkified the method as per requirement.
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestCommonCodeHandler
// ----------------------------------------------------------------------------------------------------
public class ScCollection_CommonCodeHandler
{    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as generic method to retun list of sobjects on the basis of a dynamic query.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 08-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static ScCollection_ResponseHandler.wrapperForQueryOperation executeDynamicQuery(String strquery)
    {
        //initialize the result set wrapper object
        ScCollection_ResponseHandler.wrapperForQueryOperation obj = new ScCollection_ResponseHandler.wrapperForQueryOperation();
            
        if(ScCollection_UtilityHandler.isNotNull(strquery))
        {
            //set data in result set object
            obj.strqueryProcessed = strquery;
            
            try
            {
                List<Sobject> lstRecords = Database.Query(strquery);
                
                if(ScCollection_UtilityHandler.isNotNull(lstRecords))
                {
                    obj.lstResultSet = lstRecords;   
                }
            }
            catch(QueryException qe)
            {
                obj.objerrorlog.ScCollection_Exception_Message__c = qe.getMessage();
                obj.objerrorlog.ScCollection_Exception_Type__c = 'QueryException';
            }
        }
        
        return obj;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as generic method to retun list of sobjects on the basis of salesforce object.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 21-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static ScCollection_ResponseHandler.wrapperForQueryOperation retriveSalesforceRecords(String strObjectApi, String strFieldNames, String strWhereClause, String strOrderBy, String strLimit)
    {
        //initialize the result set wrapper object
        ScCollection_ResponseHandler.wrapperForQueryOperation obj = new ScCollection_ResponseHandler.wrapperForQueryOperation();
                
        if(ScCollection_UtilityHandler.isNotNull(strObjectApi))
        {
            try
            {
                //Get schema information
                Map<String,Schema.SObjectType> schemaMap =  Schema.getGlobalDescribe(); 
                
                //get all the fields of this object in a map
                Map<String,Schema.SObjectField> fieldMap = schemaMap.get(strObjectApi).getDescribe().fields.getMap();
                 
                //generate query string from the list of fields
                String querystring = 'select ';
                    
                //if only few selected fields needs to be retrieved
                if(ScCollection_UtilityHandler.isNotNull(strFieldNames))
                {
                    querystring += strFieldNames;
                }
                else //if all fields need to be retrieved
                {
                    for(Schema.SObjectField sfield : fieldMap.Values())
                    {
                        querystring += String.valueOf(sfield) + ', ';
                    } 
                    querystring = querystring.removeEnd(', ');
                }
                    
                querystring += ' from ' + strObjectApi;
                
                //append where clause in query    
                if(ScCollection_UtilityHandler.isNotNull(strWhereClause))
                {
                    querystring += ' where ' + strWhereClause;
                }
                
                //append order by clause in query    
                if(ScCollection_UtilityHandler.isNotNull(strOrderBy))
                {
                    querystring += ' ORDER BY ' + strOrderBy;
                }
                
                //append limit clause in query
                if(ScCollection_UtilityHandler.isNotNull(strLimit))
                {
                    querystring += ' limit ' + strLimit;
                }
                else
                {
                    querystring += ' limit 999';
                }
                System.debug('querystring+++' + querystring);
                
                //call the execute dynamic query mathod to process data
                obj = executeDynamicQuery(querystring);
            }
            catch(Exception e)
            {
                obj.objerrorlog.ScCollection_Exception_Message__c = e.getMessage();
                obj.objerrorlog.ScCollection_Exception_Type__c = 'GeneralException';
            }
        }
        
        return obj;
    } 
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as a generic method to retun object type on basis of salesforce id
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 21-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static String retriveSalesforceObjectType(String strRecordId)
    {
        String objectName = '';
        
        if(ScCollection_UtilityHandler.isNotNull(strRecordId))
        {
            try
            {
                //Get prefix from record Id, this assumes that you have passed at least 3 characters
                String myIdPrefix = String.valueOf(strRecordId).substring(0,3);
                
                if(myIdPrefix == collect__Loan_Account__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'collect__Loan_Account__c';
                }
                else if(myIdPrefix == loan__Loan_Account__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'loan__Loan_Account__c';
                }
                else if(myIdPrefix == collect__Promise_To_Pay__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'collect__Promise_To_Pay__c';
                }
                else if(myIdPrefix == ScCollection_Hardship__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'ScCollection_Hardship__c';
                }
                else if(myIdPrefix == ScCollection_Recovery__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'ScCollection_Recovery__c';
                }
                else if(myIdPrefix == Profile.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'Profile';
                }
                else if(myIdPrefix == collect__Interaction_Log__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'collect__Interaction_Log__c';
                }
                else if(myIdPrefix == clcommon__Party__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'clcommon__Party__c';
                }
                else if(myIdPrefix == Property__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'Property__c';
                }
                else if(myIdPrefix == Property_Surrogate__c.sobjecttype.getDescribe().getKeyPrefix())
                {
                    objectName = 'Property_Surrogate__c';
                }
                else
                {
                    //Get schema information
                    Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
                     
                    //Loop through all the sObject types returned by Schema
                    for(Schema.SObjectType stype : gd.values())
                    {
                        Schema.DescribeSObjectResult objDescribe = stype.getDescribe();
                        String prefix = objDescribe.getKeyPrefix();
                         
                        //Check if the prefix matches with requested prefix
                        if(prefix != null && prefix.equals(myIdPrefix))
                        {
                            objectName = objDescribe.getName();
                            break;
                        }
                    }
                }
            }
            catch(Exception e)
            {
                return('Error : ' + e.getMessage());
            }   
            
            return objectName;
        }
                
        return('Error : Id passed to ScCollection_retriveSalesforceObjectType() is empty...');
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as a generic method to retun object prefix on basis of object api name
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 22-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static String retriveSalesforceObjectPrefix(String strObjectApi)
    {
        String objectPrefix = '';
        
        if(ScCollection_UtilityHandler.isNotNull(strObjectApi))
        {
            try
            {
                if(strObjectApi == 'collect__Loan_Account__c')
                {
                    objectPrefix = collect__Loan_Account__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'loan__Loan_Account__c')
                {
                    objectPrefix = loan__Loan_Account__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'collect__Promise_To_Pay__c')
                {
                    objectPrefix = collect__Promise_To_Pay__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'ScCollection_Hardship__c')
                {
                    objectPrefix = ScCollection_Hardship__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'ScCollection_Recovery__c')
                {
                    objectPrefix = ScCollection_Recovery__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'Profile')
                {
                    objectPrefix = Profile.sobjecttype.getDescribe().getKeyPrefix();
                }
                 else if(strObjectApi == 'collect__Interaction_Log__c')
                {
                    objectPrefix = collect__Interaction_Log__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'clcommon__Party__c')
                {
                    objectPrefix = clcommon__Party__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'Property__c')
                {
                    objectPrefix = Property__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else if(strObjectApi == 'Property_Surrogate__c')
                {
                    objectPrefix = Property_Surrogate__c.sobjecttype.getDescribe().getKeyPrefix();
                }
                else
                {
                    //Get schema information
                    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                     
                    //Loop through all the sObject types returned by Schema
                    for(Schema.SObjectType stype : gd.values())
                    {
                        Schema.DescribeSObjectResult objDescribe = stype.getDescribe();
                        String objectapi = objDescribe.getName();
                         
                        //Check if the prefix matches with requested prefix
                        if(objectapi != null && objectapi.equals(strObjectApi))
                        {
                            objectPrefix = objDescribe.getKeyPrefix();
                            break;
                        }
                    }
                }
            }
            catch(Exception e)
            {
                return('Error : ' + e.getMessage());
            }   
            
            return objectPrefix;
        }
                
        return('Error : Api passed to retriveSalesforceObjectPrefix() is invalid...');
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as a generic method to retun map of object type on basis of salesforce id
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 8-Aug-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static Map<id,String> retriveSalesforceObjectType(List<id> lstId)
    {
        Map<id,String> responseMap = new Map<id,String>();
        Map<String,string> mapPrefixToName = new Map<String,string>();
        //Get schema information
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
         
        //Loop through all the sObject types returned by Schema
        for(Schema.SObjectType stype : gd.values())
        {
            Schema.DescribeSObjectResult objDescribe = stype.getDescribe();
            // create map of key prefix and name
            mapPrefixToName.put(objDescribe.getKeyPrefix(),objDescribe.getName());
        }
        
        if(!lstId.isEmpty())
        {
            try
            {           
                //iterate over each element
                for(Id tempid:lstId)
                {
                    //Get prefix from record Id, this assumes that you have passed at least 3 characters
                    String myIdPrefix = String.valueOf(tempid).substring(0,3);
                    if(mapPrefixToName.containskey(myIdPrefix))
                    {
                        responseMap.put(tempid,mapPrefixToName.get(myIdPrefix));
                    }
                }
            }
            catch(Exception e)
            {
                System.debug('#### Exception Occured -'+e.getMessage());
            }   
            
            return responseMap;
        }
                
        return responseMap;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as generic method to retun contract settings data for a contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 7-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static ScCollection_ContractSettings__c retriveContractSettingsData(String strContractId, String strUserId)
    {
        if(ScCollection_UtilityHandler.isNotNull(strContractId) && ScCollection_UtilityHandler.isNotNull(strUserId))
        {
            String strContractType = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            
            if(ScCollection_UtilityHandler.isNotNull(strContractType))
            {
                //check whether a record for contact settings exist for given contract
                List<ScCollection_ContractSettings__c> lstCS = [select Id from ScCollection_ContractSettings__c where (ScCollection_DevContract__c =: strContractId OR ScCollection_CLContract__c =: strContractId) AND ScCollection_UserLookup__c =: strUserId];
                ScCollection_ResponseHandler.wrapperForQueryOperation objObjectData = new ScCollection_ResponseHandler.wrapperForQueryOperation();
                
                if(ScCollection_UtilityHandler.isNotNull(lstCS))
                {
                    //call common method to retrieve object recod with all/specific fields
                    String strWhereClause = 'Id=\'' + lstCS[0].Id + '\'';
                    objObjectData = ScCollection_CommonCodeHandler.retriveSalesforceRecords('ScCollection_ContractSettings__c','',strWhereClause,'','');
                }
                else
                {
                    ScCollection_ContractSettings__c objData = new ScCollection_ContractSettings__c();
                    objData.ScCollection_UserLookup__c = strUserId;
                    
                    if(strContractType == 'loan__Loan_Account__c')
                    {
                        objData.ScCollection_CLContract__c = strContractId;     
                    }
                    else if(strContractType == 'collect__Loan_Account__c')
                    {
                        objData.ScCollection_DevContract__c = strContractId;
                    }   
                    
                    insert objData;
                    
                    //call common method to retrieve object recod with all/specific fields
                    String strWhereClause = 'Id=\'' + objData.Id + '\'';
                    objObjectData = ScCollection_CommonCodeHandler.retriveSalesforceRecords('ScCollection_ContractSettings__c','',strWhereClause,'','');
                }
                
                if(objObjectData.lstResultSet != Null && objObjectData.lstResultSet.size() > 0)
                {
                    return(ScCollection_ContractSettings__c)objObjectData.lstResultSet[0];
                }
                else
                {
                    //prepare the error result log
                }
            }
        }
        
        return Null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as generic method to retun contract status data for a contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 7-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static collect__Contract_Status__c retriveContractStatusData(String strContractId)
    {
        if(ScCollection_UtilityHandler.isNotNull(strContractId))
        {
            String strContractType = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            
            if(ScCollection_UtilityHandler.isNotNull(strContractType))
            {
                String strCSId = '';
                ScCollection_ResponseHandler.wrapperForQueryOperation objObjectData = new ScCollection_ResponseHandler.wrapperForQueryOperation();
                                
                if(strContractType == 'loan__Loan_Account__c')
                {
                    List<loan__Loan_Account__c> lstPL = [select Id, ScCollection_Collection_Status__c from loan__Loan_Account__c where Id =: strContractId];
                    
                    if(ScCollection_UtilityHandler.isNotNull(lstPL))
                    {
                        if(lstPL[0].ScCollection_Collection_Status__c != null)
                        {
                            strCSId = lstPL[0].ScCollection_Collection_Status__c;   
                        }
                        else
                        {
                            collect__Contract_Status__c obj = new collect__Contract_Status__c();
                            insert obj;
                                
                            lstPL[0].ScCollection_Collection_Status__c = obj.Id;
                            update lstPL;
                            strCSId = obj.Id;
                        }
                    }  
                }
                else if(strContractType == 'collect__Loan_Account__c')
                {
                    List<collect__Loan_Account__c> lstCL = [select Id, collect__Collection_Status__c from collect__Loan_Account__c where Id =: strContractId];
                    
                    if(ScCollection_UtilityHandler.isNotNull(lstCL))
                    {
                        if(lstCL[0].collect__Collection_Status__c != null)
                        {
                            strCSId = lstCL[0].collect__Collection_Status__c;
                        }
                        else
                        {
                            collect__Contract_Status__c obj = new collect__Contract_Status__c();
                            insert obj;
                                
                            lstCL[0].collect__Collection_Status__c = obj.Id;
                            update lstCL;
                            strCSId = obj.Id;
                        }
                    }
                }
                
                if(ScCollection_UtilityHandler.isNotNull(strCSId))
                {                       
                    String strWhereClause = 'Id=\'' + strCSId + '\'';
                    objObjectData = ScCollection_CommonCodeHandler.retriveSalesforceRecords('collect__Contract_Status__c','',strWhereClause,'','');
                    
                    if(objObjectData.lstResultSet != Null && objObjectData.lstResultSet.size() > 0)
                    {
                        return(collect__Contract_Status__c)objObjectData.lstResultSet[0];
                    }
                    else
                    {
                        //prepare the error result log
                    }
                }
            }
        }
        
        return Null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as generic method to retun the result of cls api methods
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 7-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static String processApiResult(collect.Result objresult)
    {
        return('ok');
    }
    
    //  ----------------------------------------------------------------------------------------------------------------------------------
    //  This future method is called to update the user's daily refer count to controll the number of contracts he can refer to supervisor
    //  ----------------------------------------------------------------------------------------------------------------------------------
    //  Created Date: 05-July-2016          Created By: Kripa Sindhu Singh                  Email: kripa.sindhu@saasfocus.com
    //  ----------------------------------------------------------------------------------------------------------------------------------
    @future
    public static void updateUserReferCount(Set<Id> SetID)
    {
        List<User> lstUserUp = new list<User>();
        List<User> lstUser = new list<User>([select Id, ScCollection_Daily_Refer_Count__c, ScCollection_Daily_Refer_Counter_Date__c from User where Id IN: SetID]);
        
        for(User ObjUser: lstUser)
        {
            if(objUser.ScCollection_Daily_Refer_Count__c != null)
            {
                objUser.ScCollection_Daily_Refer_Count__c += 1; 
            }
            else
            {
                objUser.ScCollection_Daily_Refer_Count__c = 1;
            }
                        
            if(objUser.ScCollection_Daily_Refer_Counter_Date__c != null && objUser.ScCollection_Daily_Refer_Counter_Date__c != System.Today())
            {
                objUser.ScCollection_Daily_Refer_Counter_Date__c = System.Today();
            }
            
            lstUserUp.add(objUser);
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUserUp))
        {
            try
            {
                update lstUserUp;
            }
            catch(Exception e)
            {
                system.debug('Error Message during update of the user' + e.getMessage());
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method would serve as generic method to retun contract settings data for a contract in Mass
    // --------------------------------------------------------------------------------------------------------
    // Created Date: 14-JULY-2016    Created By: Kripa Sindhu Singh    Email: kripa.sindhu@saasfocus.com 
    // --------------------------------------------------------------------------------------------------------
    public static Map<String,ScCollection_ContractSettings__c> retriveMapContractSettingsData(set<String> setContractUser)
    {
        if(ScCollection_UtilityHandler.isNotNull(setContractUser))
        {
            Set<String> setInsertRecords = new Set<String>();
            Map<String, ScCollection_ContractSettings__c> mapCS = new Map<String, ScCollection_ContractSettings__c>();
            List<ScCollection_ContractSettings__c> lstCSinsert = new List<ScCollection_ContractSettings__c>();
             
            for(ScCollection_ContractSettings__c objCS : [Select Id, Name, ScCollection_ContracttoUser__c From ScCollection_ContractSettings__c where ScCollection_ContracttoUser__c IN : setContractUser])
            {
               mapCS.put(objCS.ScCollection_ContracttoUser__c,objCS);
            }
             
            for(String Key: setContractUser)
            {
               if(!mapCS.containsKey(Key))
               {
                   setInsertRecords.add(key);
               }
            }
             
            if(ScCollection_UtilityHandler.isNotNull(setInsertRecords))
            {
                for(String key: SetInsertRecords)
                {
                    ScCollection_ContractSettings__c objCSInsert = new ScCollection_ContractSettings__c();
                    String[] Part = key.split('\\-');
                   
                    if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(Part[0]) == 'loan__Loan_Account__c')
                    {
                        objCSInsert.ScCollection_CLContract__c = Id.valueOf(Part[0]);
                    }
                    else if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(Part[0]) == 'collect__Loan_Account__c')
                    {
                        objCSInsert.ScCollection_DevContract__c = Id.valueOf(Part[0]);
                    }
                    else
                    {
                        system.debug('RecordId is not for either of the contract');
                        return null;
                    }
                    
                    objCSInsert.ScCollection_UserLookup__c = Id.valueOf(Part[1]);
                    lstCSInsert.add(objCSInsert);
                }
            }
             
            if(ScCollection_UtilityHandler.isNotNull(lstCSInsert))
            {
                try
                {
                    insert lstCSInsert;
                }
                catch(Exception e)
                {
                    system.debug('Insert Failed due to following Reason : '+e.getMessage());
                }
            }
            
            List<ScCollection_ContractSettings__c> lstCSReturn = new list<ScCollection_ContractSettings__c>();
            
            lstCSReturn = [Select Id,
                           ScCollection_BrokenPromiseCount__c, 
                           ScCollection_BrokenPromiseCountDate__c,
                           ScCollection_DevContract__c, 
                           ScCollection_ContracttoUser__c, 
                           ScCollection_HoldDaysCount__c,
                           ScCollection_NoAnsCounterDate__c, 
                           ScCollection_NoAnswerCount__c, 
                           ScCollection_NoCommitmentCount__c,
                           ScCollection_NoCommitmentCountDate__c, 
                           ScCollection_CLContract__c, 
                           ScCollection_UserLookup__c
                           from ScCollection_ContractSettings__c 
                           where ScCollection_ContracttoUser__c IN : setContractUser];
            
            if(ScCollection_UtilityHandler.isNotNull(lstCSReturn))
            {
                for(ScCollection_ContractSettings__c ObjCS : lstCSReturn)
                {
                    mapCS.put(ObjCS.ScCollection_ContractToUser__c, ObjCS);
                }
            }
            if(ScCollection_UtilityHandler.isNotNull(mapCS))
            {
               return mapCS;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Something went wrong Please contact your administrator "ScCollection_CommonCodeHandler.retriveMapContractSettingsData " : '));
                return null;
            }
        }
        else
        {
            system.debug('No data Retrieved for the set Contract User');
            return Null;
        } 
    }
    
    // ----------------------------------------------------------------------------------------------------------------------------
    // This method is written for handling exception on any class and store it in Log Master object and Log Child object
    // ----------------------------------------------------------------------------------------------------------------------------
    // Created Date: 15-july-2016       Created By: Kripa Sindhu Singh          Email : kripa.sindhu@saasfocus.com
    // ----------------------------------------------------------------------------------------------------------------------------
    public static void exceptionHandler(Map<String,List<ScCollection_LogChild__c>> mapProcessError)
    {
        if(mapProcessError != null && mapProcessError.size() > 0)
        {
                
        }
    }

    // ----------------------------------------------------------------------------------------------------------------------------
    // This method is written to control the execution of triggers on production environment
    // ----------------------------------------------------------------------------------------------------------------------------
    // Created Date: 24-August-2016       Created By: Deepak Dhingra          Email : deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------------------------------
    public static Boolean triggerExectionCheck(String nameOfTrigger)
    {
        if(String.isNotEmpty(nameOfTrigger))
        {
            // bring the setting 
            Map<string,ScCollection_TriggerExecutionSettings__c> executionSetting = new Map<string,ScCollection_TriggerExecutionSettings__c>();
            executionSetting = ScCollection_TriggerExecutionSettings__c.getAll();
            
            if(executionSetting.containsKey('All Trigger Execution'))
            {
                ScCollection_TriggerExecutionSettings__c tempObj = executionSetting.get('All Trigger Execution');
                
                // appending __c to make it api name
                nameOfTrigger = nameOfTrigger + '__c';
                
                try
                {
                    Boolean returnValue = false;
                    if(tempObj.get(nameOfTrigger) != Null)
                    {
                        returnValue = (boolean)tempObj.get(nameOfTrigger);
                    }
                    return returnValue;
                }
                catch (Exception e)
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        
        return false;
    }
    
    // ----------------------------------------------------------------------------------------------------------------------------
    // This method is written to get the CRUD permissions of required objects against the asked profiles
    // ----------------------------------------------------------------------------------------------------------------------------
    // Created Date: 20-july-2016       Created By: Deepak Dhingra          Email : deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------------------------------
    public static Map<Id,Map<String,Map<String,boolean>>> getCrudPermissions(map<id,List<string>> mapProfileIdtoObjects)
    {
        // Prepare the returning map
        Map<id,Map<String,Map<String,boolean>>> mapProfileIdToMapObjectPermission = new Map<id,Map<String,Map<String,boolean>>>();
        
        if(mapProfileIdtoObjects.keyset().size() > 0)
        {   
            // create set of profile ids
            Set<Id> setProfileId = new Set<Id>();
            Set<String> setObjctApi = new Set<String>();    
                        
            for(Id tempProfileId : mapProfileIdtoObjects.keyset())
            {
                if(retriveSalesforceObjectType(tempProfileId) == 'Profile')
                {
                    setProfileId.add(tempProfileId);
                    setObjctApi.addAll(mapProfileIdtoObjects.get(tempProfileId));
                    Map<String,Map<string,boolean>> mapObjectApiNametoPermissions = new Map<String,Map<string,boolean>>();
                    
                    for(String apiName : mapProfileIdtoObjects.get(tempProfileId))
                    {
                        mapObjectApiNametoPermissions.put(apiName,new Map<string,boolean>());
                        mapObjectApiNametoPermissions.get(apiName).put('read',false);
                        mapObjectApiNametoPermissions.get(apiName).put('create',false);
                        mapObjectApiNametoPermissions.get(apiName).put('edit',false);
                        mapObjectApiNametoPermissions.get(apiName).put('delete',false);    
                    }
                    mapProfileIdToMapObjectPermission.put(tempProfileId,mapObjectApiNametoPermissions);
                }
            }
            
            // if we have some profiles
            if(setProfileId.size() > 0 && setObjctApi.size() > 0)
            {    
                // fix made ono august 30 for permission set assignment
                List<PermissionSetAssignment> lstPermissionSets = new List<PermissionSetAssignment>();
                // look for the permission sets assigned to the current user
                // not bulkified , just a quick fix
                lstPermissionSets = [select AssigneeId,PermissionSetId from PermissionSetAssignment where AssigneeId = :UserInfo.getUserId()];
                Set<id> SetTemppermissionId = new Set<id>();
                if(lstPermissionSets.size() > 0)
                {
                    for(PermissionSetAssignment tempId:lstPermissionSets)
                    {
                        SetTemppermissionId.add(tempId.PermissionSetId);
                    }
                }
 
                List<permissionset> lstPermissionSet = new List<permissionset>();
 
                lstPermissionSet = [select Id, Profile.Id from permissionset where (Profile.Id IN : setProfileId) or (id in :SetTemppermissionId)];
                
                if(lstPermissionSet.size() > 0)
                {
                    Map<Id,Id> mapPermissionSetToProfile = new Map<Id,Id>();
                    
                    for(permissionset tempPermissionSet:lstPermissionSet)
                    {
                        if(tempPermissionSet.Profile.id != Null)
                        {
                            mapPermissionSetToProfile.put(tempPermissionSet.id,tempPermissionSet.Profile.id);
                        }
                        else
                        {
                            mapPermissionSetToProfile.put(tempPermissionSet.id,UserInfo.getProfileId());
                        }
                    }
                    
                    // query the permissions
                    List<ObjectPermissions> lstPermissions  = new List<ObjectPermissions>();
                    lstPermissions  = [select Id, 
                                              SObjectType,
                                              PermissionsRead,
                                              PermissionsCreate,
                                              PermissionsDelete,
                                              PermissionsEdit,
                                              ParentId
                                              from ObjectPermissions
                                              where ParentId IN : mapPermissionSetToProfile.keyset()
                                              AND SObjectType IN : setObjctApi];    
                
                    if(lstPermissions.size() > 0)
                    {
                        for(ObjectPermissions permission : lstPermissions)
                        {
                            if(mapProfileIdToMapObjectPermission.get(mapPermissionSetToProfile.get(permission.parentid)).containsKey(permission.SObjectType))
                            {
                                // set the permission
                                if(permission.PermissionsRead == true)
                                    mapProfileIdToMapObjectPermission.get(mapPermissionSetToProfile.get(permission.parentid)).get(permission.SObjectType).put('read',permission.PermissionsRead);
                                if(permission.PermissionsCreate == true)
                                    mapProfileIdToMapObjectPermission.get(mapPermissionSetToProfile.get(permission.parentid)).get(permission.SObjectType).put('create',permission.PermissionsCreate);
                                if(permission.PermissionsDelete == true)
                                    mapProfileIdToMapObjectPermission.get(mapPermissionSetToProfile.get(permission.parentid)).get(permission.SObjectType).put('delete',permission.PermissionsDelete);
                                if(permission.PermissionsEdit== true)
                                    mapProfileIdToMapObjectPermission.get(mapPermissionSetToProfile.get(permission.parentid)).get(permission.SObjectType).put('edit',permission.PermissionsEdit);
                            }
                        }    
                    }
                }   
            }    
        }
        
        return mapProfileIdToMapObjectPermission;
    }
    
    
    
    // ----------------------------------------------------------------------------------------------------
    // method to generate a unique random number
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 22-feb-2017    Created By: Sandip bijlwam    Email: sandip.bijlwan@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public Static string GenerateUniqueRandomNumber()
    {
        Integer random_integer = Crypto.getRandomInteger();
        
        if(random_integer < 0)
        {
            random_integer = Math.abs(random_integer);
        }
        
        String hashString = random_integer  + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        
        if(!String.IsBlank(hexDigest) && hexDigest.length() > 50){
           hexDigest = hexDigest.substring(0,50);
        }
        return hexDigest;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // method to replace all space from String
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 22-feb-2017    Created By: Sandip bijlwam    Email: sandip.bijlwan@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public static String RemoveSpace(String str){
        if(!String.isBlank(str)){
            str= str.replaceAll( '\\s+', '');
            return  str;
        }
        else 
            return '';
            
    }
    

    // ----------------------------------------------------------------------------------------------------
    // method to replace dynamic values in letter xml
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 22-feb-2017    Created By: Sandip bijlwam    Email: sandip.bijlwan@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public Static String ProcessLetterXml(String initialXml, ScCollection_Letter_Template__c objtemplate, SObject objContract, Id strPartyId,String channel)
    {   
        map<Integer,String> mapIntegerToString = new map<Integer,String>();
        mapIntegerToString.put(1,'January');
        mapIntegerToString.put(2,'February');
        mapIntegerToString.put(3,'March');
        mapIntegerToString.put(4,'April');
        mapIntegerToString.put(5,'May');
        mapIntegerToString.put(6,'June');
        mapIntegerToString.put(7,'July');
        mapIntegerToString.put(8,'August');
        mapIntegerToString.put(9,'September');
        mapIntegerToString.put(10,'October');
        mapIntegerToString.put(11,'November');
        mapIntegerToString.put(12,'December');
        
        String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
        String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
        String sobjectName ='';
        
        collect__loan_Account__c objCLLoanContract = new collect__loan_Account__c();
        loan__Loan_Account__c objPLLoanContract = new loan__Loan_Account__c();
        Account accnt = new Account();
        Residential_Address__c objResidentialAddress = new Residential_Address__c();
        String accntID = '';
        
        if(objContract != null){
            sobjectName = retriveSalesforceObjectType(objContract.Id);
            
            if(sobjectName == VAR_CLCONTRACT_API){
                objCLLoanContract = (collect__loan_Account__c)objContract;
            }
            else if(sobjectName == VAR_PLCONTRACT_API){
                objPLLoanContract = (loan__Loan_Account__c)objContract;
                accntID = objPLLoanContract.loan__Account__c;
            }
        }
        
            
        
        String strFinalXml = '';
           
        List<ScCollection_Hardship__c> lstHardship = new List<ScCollection_Hardship__c>();
        ScCollection_Hardship__c objHardship;
        
        List<clcommon__Party__c> lstParty = new List<clcommon__Party__c>();
        clcommon__Party__c objParty;
        
        Boolean is_preview_check = false;
        Boolean is_archive_check = false;
        String random_number='';
        
        //Check XML is Valid
        if(initialXml == null || String.isBlank(initialXml))
        {
            return 'Provide Valid XML';
        }
        else
        {
            strFinalXml = initialXml;
            
            //Check if all values are valid---------------------
            if(channel == null || String.isBlank(channel))
            {
                return 'Provide Channel';
            }
            else
            {
                if(channel.toLowerCase() == 'preview')
                {
                    is_preview_check = true;
                    is_archive_check = false;
                    
                    //Check if partyId is null------------------------------
                    if(strPartyId == null && sobjectName == VAR_CLCONTRACT_API)
                    {
                        return 'Party Id is null';
                    }
                    else
                    {
                        if(sobjectName == VAR_CLCONTRACT_API){
                            lstParty = [Select Id,ScCollection_Account_Name__c,clcommon__Account__r.collect__External_ID__c,ScCollection_Related_MailingAddress__c,ScCollection_Related_MailingCity__c,ScCollection_Related_MailingPostalCode__c,
                                        ScCollection_Related_MailingState__c,ScCollection_Related_Title__c,ScCollection_Related_Lastname__c 
                                        From clcommon__Party__c where Id =: strPartyId];
                            if(lstParty != null && lstParty.Size() > 0)
                            {
                                objParty = lstParty[0];
                            }
                            else
                            {
                                return 'No Party Found';
                            }
                        }
                        else if(sobjectName == VAR_PLCONTRACT_API){
                            if(accntID != ''){
                                List<Account> lstAcc = [Select Id,Name,Salutation,collect__External_ID__c,LastName,
                                                         PersonMailingCity,PersonMailingState,PersonMailingPostalCode 
                                                         From Account Where Id = : accntID];
                                if(lstAcc != null && lstAcc.Size()>0){
                                    accnt = lstAcc[0]; 
                                    List<Residential_Address__c> lstResidential = [Select Id,City__c,Street_Number__c,Street_Name__c,Street_Type__c,Suburb__c,State__c,PostCode__c  
                                                                                    from Residential_Address__c where Account__c in :lstAcc and Current_Address__c = true 
                                                                                    Order By LastModifiedDate desc limit 1];
                                    if(lstResidential != null && lstResidential.Size()>0){
                                        objResidentialAddress = lstResidential[0];
                                    }
                                        
                                }  
                            }
                            else{
                                return 'No Party Found';
                            }
                                
                        }
                            
                    }
                    
                    //Check if ScCollection_Letter_Template__c is null------------------------------
                    if(objtemplate == null)
                    {
                        return 'Letter Template is NULL';
                    }
                    
                    //Check if collect__loan_Account__c is null------------------------------
                    if(objContract == null)
                    {
                        return 'Contract is NULL';
                    }
                    else
                    {
                        //Query latest modified hardship ---------------------------------------------
                        if(sobjectName == VAR_CLCONTRACT_API){
                            lstHardship = [Select Id,ScCollection_HardshipRequestedDate__c,ScCollection_HardshipCommencementDate__c,                         ScCollection_HardshipExpiryDate__c,
                                            ScCollection_Reduced_interest_Rate__c,ScCollection_Reassessment_Date__c,ScCollection_Reduced_payment_amount__c,
                                            ScCollection_Proposed_Repayment_Plan__c,ScCollection_Letter_of_finance_approval__c,ScCollection_Judgement_Obtained__c,
                                            ScCollection_BSB_1__c,ScCollection_EREF_Account_number__c,ScCollection_COS_Date__c,ScCollection_Contract__c,ScCollection_Date_docs_to_be_returned__c,
                                            ScCollection_Date_payments_to_recommence__c,ScCollection_SOFP_Date__c,ScCollection_Followed_up_Date__c,ScCollection_Frequency_of_arrangement__c,
                                            ScCollection_Number_of_payments__c,ScCollection_Resumed_payment_frequency__c,ScCollection_Ad_Hoc_Instalment__c,ScCollection_Ad_Hoc_Date_1__c,
                                            ScColletion_Ad_Hoc_Date_2__c,ScCollection_Account_Number_Direct_Debit__c,ScCollection_BSB_Number_Direct_Debit_1__c                           
                                            From ScCollection_Hardship__c 
                                            Where ScCollection_Contract__c =: objCLLoanContract.Id Order By LastModifiedDate desc limit 1];

                        }
                        else if(sobjectName == VAR_PLCONTRACT_API){
                            lstHardship = [Select Id,ScCollection_HardshipRequestedDate__c,ScCollection_HardshipCommencementDate__c,ScCollection_HardshipExpiryDate__c,
                                            ScCollection_Reduced_interest_Rate__c,ScCollection_Reassessment_Date__c,ScCollection_Reduced_payment_amount__c,
                                            ScCollection_Proposed_Repayment_Plan__c,ScCollection_Letter_of_finance_approval__c,ScCollection_Judgement_Obtained__c,
                                            ScCollection_BSB_1__c,ScCollection_EREF_Account_number__c,ScCollection_COS_Date__c,scCollection_Loan_Account__c,ScCollection_Date_docs_to_be_returned__c,
                                            ScCollection_Date_payments_to_recommence__c,ScCollection_SOFP_Date__c,ScCollection_Followed_up_Date__c,ScCollection_Frequency_of_arrangement__c,
                                            ScCollection_Number_of_payments__c,ScCollection_Resumed_payment_frequency__c,ScCollection_Ad_Hoc_Instalment__c,ScCollection_Ad_Hoc_Date_1__c,
                                            ScColletion_Ad_Hoc_Date_2__c,ScCollection_Account_Number_Direct_Debit__c,ScCollection_BSB_Number_Direct_Debit_1__c                           
                                            From ScCollection_Hardship__c 
                                            Where scCollection_Loan_Account__c =: objPLLoanContract.Id Order By LastModifiedDate desc limit 1];

                        }
                        
                        if(lstHardship != null && lstHardship.Size()>0)
                        {
                            objHardship = lstHardship[0];
                        }
                        else
                        {
                            return 'No Hardhip Found';
                        }                       
                    }
                }
                else if(channel.toLowerCase() == 'archive')
                {
                    is_preview_check = false;
                    is_archive_check = true;
                    random_number = GenerateUniqueRandomNumber();
                    system.debug(random_number);
                }
                else
                {
                    return 'Please Provide Correct Channel';
                }
            }
            
            //Replace Preview,Archive,Email and outputmethod values-----------------------
            if(is_preview_check && !is_archive_check)
            {    
                strFinalXml = strFinalXml.replace('{preview}','Yes');
                strFinalXml = strFinalXml.replace('{outputmethod}',channel.toUpperCase());
                strFinalXml = strFinalXml.replace('{archive}','No');
             
                strFinalXml = strFinalXml.replace('{email}','No');

                //Replace Date and Time----------------------------------------
                strFinalXml = strFinalXml.replace('{today}',String.valueOf(System.Today()));
                Date dt =System.Today();
                strFinalXml = strFinalXml.replace('{formattedtodaydt}',String.valueOf(dt.Day() +' '+ mapIntegerToString.get(dt.Month()) +' '+ dt.Year()));
                strFinalXml = strFinalXml.replace('{now}',String.valueOf(System.Now()));

                //Replace Letter Template Starts------------
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Letter_Type__c}',(objtemplate.ScCollection_Letter_Type__c != null ? RemoveSpace(String.valueof(objtemplate.ScCollection_Letter_Type__c)) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Process__c}',(objtemplate.ScCollection_Process__c != null ? String.valueof(objtemplate.ScCollection_Process__c) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Country_Code__c}',(objtemplate.ScCollection_Country_Code__c != null ? String.valueof(objtemplate.ScCollection_Country_Code__c) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Application__c}',(objtemplate.ScCollection_Application__c != null ? String.valueof(objtemplate.ScCollection_Application__c) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Signatory_Name__c}',(objtemplate.ScCollection_Signatory_Name__c != null ? String.valueof(objtemplate.ScCollection_Signatory_Name__c) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Signatory__c}',(objtemplate.ScCollection_Signatory__c != null ? String.valueof(objtemplate.ScCollection_Signatory__c) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Letter_Sub_Type__c}',(objtemplate.ScCollection_Letter_Sub_Type__c != null ? String.valueof(objtemplate.ScCollection_Letter_Sub_Type__c) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Category__c}',(objtemplate.ScCollection_Category__c != null ? String.valueof(objtemplate.ScCollection_Category__c) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Letter_Template__c.ScCollection_Aggregator_Name__c}',(objtemplate.ScCollection_Aggregator_Name__c != null ? String.valueof(objtemplate.ScCollection_Aggregator_Name__c) : '' ));
                
                /*if(sobjectName == VAR_PLCONTRACT_API){
                    strFinalXml = strFinalXml.replace('{aggregatorname}',(objtemplate.ScCollection_Aggregator_Name__c != null ? String.valueof(objtemplate.ScCollection_Aggregator_Name__c) : '' ));

                }
                else if(sobjectName == VAR_CLCONTRACT_API){
                    if(objtemplate.ScCollection_Source_System__c != null && objtemplate.ScCollection_Source_System__r.Name == 'MORTGAGE'){
                        strFinalXml = strFinalXml.replace('{aggregatorname}',(objtemplate.ScCollection_Aggregator_Name_Mortgage__c != null ? String.valueof(objtemplate.ScCollection_Aggregator_Name_Mortgage__c) : '' ));
                    }
                    else if(objtemplate.ScCollection_Source_System__c != null && objtemplate.ScCollection_Source_System__r.Name == 'PAF'){
                        strFinalXml = strFinalXml.replace('{aggregatorname}',(objtemplate.ScCollection_Aggregator_Name_PAF__c != null ? String.valueof(objtemplate.ScCollection_Aggregator_Name_PAF__c) : '' ));
                    }
                }*/
                
                //Replace Contract fields starts-----------------------------
                
                if(sobjectName == VAR_CLCONTRACT_API){
                
                    strFinalXml = strFinalXml.replace('{contractname}',(objCLLoanContract.Name != null ? (objCLLoanContract.Name.Contains('_') ? objCLLoanContract.Name.Split('_')[0] : objCLLoanContract.Name) : '' ));
                    strFinalXml = strFinalXml.replace('{contractmmi}',(objCLLoanContract.ScCollection_Minimum_Monthly_Installment__c != null ? String.valueof(objCLLoanContract.ScCollection_Minimum_Monthly_Installment__c) : '' ));
                    strFinalXml = strFinalXml.replace('{contractamounttocurrent}',(objCLLoanContract.collect__Amount_to_Current__c != null ? String.valueof(objCLLoanContract.collect__Amount_to_Current__c) : '' ));
                    strFinalXml = strFinalXml.replace('{contractredrawavailable}',(objCLLoanContract.ScCollection_Redraw_Available__c != null ? String.valueof(objCLLoanContract.ScCollection_Redraw_Available__c) : '' ));
                    strFinalXml = strFinalXml.replace('{contractrepayday}',(objCLLoanContract.ScCollection_Repayment_Day__c != null ? String.valueof(objCLLoanContract.ScCollection_Repayment_Day__c) : '' ));
                    strFinalXml = strFinalXml.replace('{department}',(objCLLoanContract.ScCollection_Source_System_Name__c != null ? String.valueof(objCLLoanContract.ScCollection_Source_System_Name__c) : '' ));
                    strFinalXml = strFinalXml.replace('{contractinterestrate}',(objCLLoanContract.ScCollection_Interest_Rate__c != null ? String.valueof(objCLLoanContract.ScCollection_Interest_Rate__c) : '' ));                    
                    /*
                    if(objCLLoanContract.ScCollection_Next_Installment_Date__c != null)
                    {
                        Date tempDate = objCLLoanContract.ScCollection_Next_Installment_Date__c ;
                        String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                        strFinalXml = strFinalXml.replace('{contractnextduedate}',tempString);
                    }
                    else
                    {
                        strFinalXml = strFinalXml.replace('{contractnextduedate}','');
                    }
                    */
                }
                else if(sobjectName == VAR_PLCONTRACT_API){
                
                    strFinalXml = strFinalXml.replace('{contractname}',(objPLLoanContract.Name != null ? (objPLLoanContract.Name.Contains('_') ? objPLLoanContract.Name.Split('_')[0] : objPLLoanContract.Name) : '' ));
                    strFinalXml = strFinalXml.replace('{contractmmi}',(objPLLoanContract.loan__Payment_Amount__c != null ? String.valueof(objPLLoanContract.loan__Payment_Amount__c) : '' ));
                    strFinalXml = strFinalXml.replace('{contractamounttocurrent}',(objPLLoanContract.loan__Amount_to_Current__c != null ? String.valueof(objPLLoanContract.loan__Amount_to_Current__c) : '' ));
                    strFinalXml = strFinalXml.replace('{contractredrawavailable}',(objPLLoanContract.loan__Reserve_Amount_for_Next_Due__c != null ? String.valueof(objPLLoanContract.loan__Reserve_Amount_for_Next_Due__c) : '' ));
                    strFinalXml = strFinalXml.replace('{contractrepayday}',(objPLLoanContract.loan__Next_Installment_Date__c != null ? String.valueof(objPLLoanContract.loan__Next_Installment_Date__c.Day()) : '' ));
                    strFinalXml = strFinalXml.replace('{department}','PL');
                    strFinalXml = strFinalXml.replace('{contractinterestrate}',(objPLLoanContract.loan__Interest_Rate__c != null ? String.valueof(objPLLoanContract.loan__Interest_Rate__c.setscale(2)) : '' ));                    
                    
                    /*
                    if(objPLLoanContract.loan__Next_Installment_Date__c != null)
                    {
                        Date tempDate = objPLLoanContract.loan__Next_Installment_Date__c ;
                        String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                        strFinalXml = strFinalXml.replace('{contractnextduedate}',tempString);
                    }
                    else
                    {
                        strFinalXml = strFinalXml.replace('{contractnextduedate}','');
                    }
                    */
                }
                    
                
                //Replace Hardhip Fields Starts-----------------------------
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Reduced_interest_Rate__c}',(objHardship.ScCollection_Reduced_interest_Rate__c != null ? String.valueof(objHardship.ScCollection_Reduced_interest_Rate__c) + '%' : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Reduced_payment_amount__c}',(objHardship.ScCollection_Reduced_payment_amount__c != null ? String.valueof(objHardship.ScCollection_Reduced_payment_amount__c ) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Proposed_Repayment_Plan__c}',(objHardship.ScCollection_Proposed_Repayment_Plan__c != null ? String.valueof(objHardship.ScCollection_Proposed_Repayment_Plan__c ) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_BSB_1__c}',(objHardship.ScCollection_BSB_1__c != null ? String.valueof(objHardship.ScCollection_BSB_1__c ) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_EREF_Account_number__c}',(objHardship.ScCollection_EREF_Account_number__c != null ? String.valueof(objHardship.ScCollection_EREF_Account_number__c ) : '' ));
                    
                //Formatting date fields------
                if(objHardship.ScCollection_HardshipRequestedDate__c != null)
                {
                    Date tempDate = objHardship.ScCollection_HardshipRequestedDate__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_HardshipRequestedDate__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_HardshipRequestedDate__c}','');
                }
                if(objHardship.ScCollection_HardshipCommencementDate__c != null)
                {
                    Date tempDate = objHardship.ScCollection_HardshipCommencementDate__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_HardshipCommencementDate__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_HardshipCommencementDate__c}','');
                }
                if(objHardship.ScCollection_HardshipExpiryDate__c != null)
                {
                    Date tempDate = objHardship.ScCollection_HardshipExpiryDate__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_HardshipExpiryDate__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_HardshipExpiryDate__c}','');
                }
                if(objHardship.ScCollection_Reassessment_Date__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Reassessment_Date__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Reassessment_Date__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Reassessment_Date__c}','');
                }
                if(objHardship.ScCollection_Letter_of_finance_approval__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Letter_of_finance_approval__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Letter_of_finance_approval__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Letter_of_finance_approval__c}','');
                }
                if(objHardship.ScCollection_Judgement_Obtained__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Judgement_Obtained__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Judgement_Obtained__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Judgement_Obtained__c}','');
                }
                if(objHardship.ScCollection_COS_Date__c != null)
                {
                    Date tempDate = objHardship.ScCollection_COS_Date__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_COS_Date__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_COS_Date__c}','');
                }            
                if(objHardship.ScCollection_Date_docs_to_be_returned__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Date_docs_to_be_returned__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Date_docs_to_be_returned__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Date_docs_to_be_returned__c}','');
                }
                if(objHardship.ScCollection_Date_payments_to_recommence__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Date_payments_to_recommence__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Date_payments_to_recommence__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Date_payments_to_recommence__c}','');
                }
                if(objHardship.ScCollection_SOFP_Date__c != null)
                {
                    Date tempDate = objHardship.ScCollection_SOFP_Date__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_SOFP_Date__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_SOFP_Date__c}','');
                }
                if(objHardship.ScCollection_Followed_up_Date__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Followed_up_Date__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Followed_up_Date__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Followed_up_Date__c}','');
                }
                
                //added on 21/07/2017 --- letter changes
                if(objHardship.ScCollection_Date_payments_to_recommence__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Date_payments_to_recommence__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{contractnextduedate}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{contractnextduedate}','');
                }
                
                
                //added on 15/03/2017----------
                
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Frequency_of_arrangement__c}',(objHardship.ScCollection_Frequency_of_arrangement__c != null ? String.valueof(objHardship.ScCollection_Frequency_of_arrangement__c ) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Number_of_payments__c}',(objHardship.ScCollection_Number_of_payments__c != null ? String.valueof(objHardship.ScCollection_Number_of_payments__c ) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Resumed_payment_frequency__c}',(objHardship.ScCollection_Resumed_payment_frequency__c != null ? String.valueof(objHardship.ScCollection_Resumed_payment_frequency__c ) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Ad_Hoc_Instalment__c}',(objHardship.ScCollection_Ad_Hoc_Instalment__c != null ? String.valueof(objHardship.ScCollection_Ad_Hoc_Instalment__c ) : '' ));
                
                if(objHardship.ScCollection_Ad_Hoc_Date_1__c != null)
                {
                    Date tempDate = objHardship.ScCollection_Ad_Hoc_Date_1__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Ad_Hoc_Date_1__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Ad_Hoc_Date_1__c}','');
                }
                if(objHardship.ScColletion_Ad_Hoc_Date_2__c != null)
                {
                    Date tempDate = objHardship.ScColletion_Ad_Hoc_Date_2__c ;
                    String tempString = String.ValueOf(tempDate.Day() +' '+ mapIntegerToString.get(tempDate.Month()) +' '+ tempDate.Year());
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScColletion_Ad_Hoc_Date_2__c}',tempString);
                }
                else
                {
                    strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScColletion_Ad_Hoc_Date_2__c}','');
                }
                
                //added 31/03/2017
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_Account_Number_Direct_Debit__c}',(objHardship.ScCollection_Account_Number_Direct_Debit__c != null ? String.valueof(objHardship.ScCollection_Account_Number_Direct_Debit__c ) : '' ));
                strFinalXml = strFinalXml.replace('{ScCollection_Hardship__c.ScCollection_BSB_Number_Direct_Debit_1__c}',(objHardship.ScCollection_BSB_Number_Direct_Debit_1__c != null ? String.valueof(objHardship.ScCollection_BSB_Number_Direct_Debit_1__c ) : '' ));
                
                //Replace Account and Contact Fields Starts----------------------------
                
                if(sobjectName == VAR_CLCONTRACT_API){
                    strFinalXml = strFinalXml.replace('{Account.Name}',(objParty.ScCollection_Account_Name__c != null ? String.valueof(objParty.ScCollection_Account_Name__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Account.collect__External_ID__c}',(objParty.clcommon__Account__r.collect__External_ID__c != null ? String.valueof(objParty.clcommon__Account__r.collect__External_ID__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Account.Title}',(objParty.ScCollection_Related_Title__c != null ? String.valueof(objParty.ScCollection_Related_Title__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Account.LastName}',(objParty.ScCollection_Related_Lastname__c  != null ? String.valueof(objParty.ScCollection_Related_Lastname__c  ) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingAddress}',(objParty.ScCollection_Related_MailingAddress__c != null ? String.valueof(objParty.ScCollection_Related_MailingAddress__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingCity}',(objParty.ScCollection_Related_MailingCity__c != null ? String.valueof(objParty.ScCollection_Related_MailingCity__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingState}',(objParty.ScCollection_Related_MailingState__c != null ? String.valueof(objParty.ScCollection_Related_MailingState__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingPostalCode}',(objParty.ScCollection_Related_MailingPostalCode__c != null ? String.valueof(objParty.ScCollection_Related_MailingPostalCode__c ) : '' ));     
                }
                else if(sobjectName == VAR_PLCONTRACT_API){
                    String mailingAddress ='';
                    mailingAddress += (objResidentialAddress.Street_Number__c != null ? String.valueof(objResidentialAddress.Street_Number__c) : '' );
                    mailingAddress += (objResidentialAddress.Street_Name__c != null ? ' '+ String.valueof(objResidentialAddress.Street_Name__c) : '' );
                    mailingAddress += (objResidentialAddress.Street_Type__c != null ? ' '+ String.valueof(objResidentialAddress.Street_Type__c) : '' );
                    
                    strFinalXml = strFinalXml.replace('{Account.Name}',(accnt.Name != null ? String.valueof(accnt.Name ) : '' ));
                    strFinalXml = strFinalXml.replace('{Account.collect__External_ID__c}',(accnt.collect__External_ID__c != null ? String.valueof(accnt.collect__External_ID__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Account.Title}',(accnt.Salutation != null ? String.valueof(accnt.Salutation ) : '' ));
                    strFinalXml = strFinalXml.replace('{Account.LastName}',(accnt.LastName  != null ? String.valueof(accnt.LastName  ) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingAddress}',(mailingAddress != null ? String.valueof(mailingAddress) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingCity}',(objResidentialAddress.Suburb__c != null ? String.valueof(objResidentialAddress.Suburb__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingState}',(objResidentialAddress.State__c != null ? String.valueof(objResidentialAddress.State__c ) : '' ));
                    strFinalXml = strFinalXml.replace('{Contact.MailingPostalCode}',(objResidentialAddress.PostCode__c != null ? String.valueof(objResidentialAddress.PostCode__c ) : '' ));
                }
            }
            else
            {    
                //Replace value for channel equals Archive
                Dom.Document doc = new Dom.Document();
                doc.load(strFinalXml);
                for(Dom.XmlNode node :doc.getRootElement().getChildElements())
                {
                    if(node.getName() == 'Channels')
                    {
                        for(Dom.XmlNode objchannel : node.getChildElements())
                        {
                            if(objchannel.getAttributeValue('name',null) == 'PREVIEW')
                            {
                                objchannel.setAttribute('enabled','No');
                            }
                            if(objchannel.getAttributeValue('name',null) == 'ARCHIVE')
                            {
                                objchannel.setAttribute('enabled','Yes');
                            }
                        }
                    }
                    if(node.getName() == 'Recordset')
                    {
                        for(Dom.XmlNode recSet : node.getChildElements())
                        {
                            for(Dom.XmlNode rec : recSet.getChildElements())
                            {
                                if(rec.getName() == 'Indexes')
                                {
                                    for(Dom.XmlNode indx : rec.getChildElements())
                                    {    
                                        if(indx.getName() == 'OutputMethod')
                                        {    
                                            indx.getParent().removeChild(indx);
                                        }
                                        if(indx.getName() == 'LEADID')
                                        {
                                            if(random_number != '')
                                            {
                                                indx.addTextNode(random_number);
                                            }                       
                                        }
                                    }
                                    rec.addChildElement('OutputMethod', null, null).addTextNode(channel.toUpperCase());
                                }
                            }           
                        }
                    }           
                }
                
                strFinalXml = doc.toXmlString();
                system.debug('@@@strFinalXml'+strFinalXml);
            }
            return strFinalXml;
        }
    } 
    
    // ----------------------------------------------------------------------------------------------------
    // This method user REST API to generate letter 
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 22-feb-2017    Created By: Sandip bijlwam    Email: sandip.bijlwan@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public Static ScCollection_ApiResponse SendLetter(String strFinalXml,String channel)
    {
        system.debug('@@strFinalXml'+strFinalXml);
        String file_content = '';
        String message_desc = '';
        String api_custsetting_name = '';
        
        if(channel != null)
        {
            if(channel.toLowerCase() == 'preview')
            {
                api_custsetting_name = 'PreviewLetter';
            }
            else if(channel.toLowerCase() == 'archive')
            {
                api_custsetting_name = 'ArchiveLetter';
            }
            else
            {
                ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
                ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                objApiResponse.Status = 'ERROR';
                objApiResponse.Description = '';
                
                ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                objMgs.MessageDescription = 'Please Provide Valid Channel.';
                objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                objApiResponse.Messages.add(objMgs);
                
                objResponse.APIStatus = objApiResponse;
                return objResponse;
            }
        }
        else
        {
            ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
            ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
            objApiResponse.Status = 'ERROR';
            objApiResponse.Description = '';
            
            ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
            objMgs.MessageDescription = 'Please Provide Valid Channel.';
            objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
            objApiResponse.Messages.add(objMgs);
            
            objResponse.APIStatus = objApiResponse;
            return objResponse;
        }
         
        try
        {
            if(strFinalXml != null)
            {    
                strFinalXml = strFinalXml.replace('&','&amp;');
                system.debug('@@strFinalXml'+strFinalXml);
                ScCollection_PaymentAPIParameters__c objcred = ScCollection_PaymentAPIParameters__c.getValues(api_custsetting_name);
                String api_url = objcred.Endpoint__c;
                Http objhttp = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(api_url);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objcred.Username__c + ':' + objcred.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/xml');
                req.setTimeout(120000);
                req.setBody(strFinalXml );
                
                if(!test.isRunningTest())
                {
                    HttpResponse res = objhttp.send(req);
                    dom.Document resDoc = res.getBodyDocument();
                    Dom.XmlNode parentNode = resDoc.getRootElement();
                    
                    if(resDoc != null)
                    {
                        for(Dom.XmlNode childnodes : resDoc.getRootElement().getChildElements())
                        {
                            if(childnodes.getName() == 'Messages')
                            {
                                for(Dom.XmlNode apiResChild : childnodes.getChildElements())
                                {
                                    for(Dom.XmlNode messageResChild : apiResChild.getChildElements())
                                    {
                                        if(messageResChild.getName() == 'MessageDescription')
                                        {
                                            message_desc = messageResChild.getText();
                                        }
                                    }
                                }
                            } 
                            
                            if(childnodes.getName() == 'APIResponse')
                            {
                                for(Dom.XmlNode apiResChild : childnodes.getChildElements())
                                {
                                    for(Dom.XmlNode generateDocResChild : apiResChild.getChildElements())
                                    {
                                        if(generateDocResChild.getName() == 'FileContent')
                                        {
                                            file_content = generateDocResChild.getText();
                                        }
                                    }
                                }
                            }                            
                        }
                    }
                     system.debug('Letter Response'+res);   
                    if(res.getStatusCode() == 200)
                    {
                        if(api_custsetting_name == 'ArchiveLetter')
                        {
                            ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                            objApiResponse.Status = 'ARCHIVESUCCESS';
                            objApiResponse.Description ='';
                            
                            ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                            objMgs.MessageDescription = message_desc;
                            objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                            objApiResponse.Messages.add(objMgs);
                            
                            objResponse.APIStatus = objApiResponse;
                            system.debug(objResponse);
                            return objResponse;
                        }
                        else if(api_custsetting_name == 'PreviewLetter')
                        {
                            ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
                            ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                            objApiResponse.Status = 'PREVIEWSUCCESS';
                            objApiResponse.Description = file_content;
                            
                            ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                            objMgs.MessageDescription = message_desc;
                            objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                            objApiResponse.Messages.add(objMgs);
                            
                            objResponse.APIStatus = objApiResponse;
                            system.debug(objResponse);
                            return objResponse;
                            
                        }
                        else
                        {
                            ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
                            ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                            objApiResponse.Status = 'ERROR';
                            objApiResponse.Description = '';
                            
                            ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                            objMgs.MessageDescription = 'Please Provide Valid Channel.';
                            objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                            objApiResponse.Messages.add(objMgs);
                            
                            objResponse.APIStatus = objApiResponse;
                            system.debug(objResponse);
                            return objResponse;
                        }
                    }
                    else if(res.getStatusCode() == 500){
                       
                        ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
                        ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                        objApiResponse.Status = 'ERROR';
                        objApiResponse.Description = '';
                        ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                        objMgs.MessageDescription = 'Request hasn\'t been processed because provided xml is malformed. Kindly contact administrator to correct the xml\'s.';
                        objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                        objApiResponse.Messages.add(objMgs);
                        
                        objResponse.APIStatus = objApiResponse;
                        system.debug(objResponse);
                        return objResponse;
                    
                    }
                    else
                    {
                        ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
                        ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                        objApiResponse.Status = 'ERROR';
                        objApiResponse.Description = '';
                        ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                        objMgs.MessageDescription = message_desc;
                        objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                        objApiResponse.Messages.add(objMgs);
                        
                        objResponse.APIStatus = objApiResponse;
                        system.debug(objResponse);
                        return objResponse;
                    }
                }
                else
                {
                    ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
                    ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                    objApiResponse.Status = channel.toUpperCase()+'SUCCESS';
                    objApiResponse.Description = '';
                    ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                    objMgs.MessageDescription = '';
                    objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                    objApiResponse.Messages.add(objMgs);
                    
                    objResponse.APIStatus = objApiResponse;
                    system.debug(objResponse);
                    return objResponse;
                }
            }
            else
            {
                ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
                ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                objApiResponse.Status = 'ERROR';
                objApiResponse.Description = '';
                ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
                objMgs.MessageDescription = 'Provide XML String';
                objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
                objApiResponse.Messages.add(objMgs);
                
                objResponse.APIStatus = objApiResponse;
                system.debug(objResponse);
                return objResponse;
            }    
         }
         catch(Exception ex)
         {
             ScCollection_ApiResponse objResponse = new ScCollection_ApiResponse();
                            
             ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
             objApiResponse.Status = 'ERROR';
             objApiResponse.Description = '';
             ScCollection_ApiResponse.Messages objMgs = new ScCollection_ApiResponse.Messages();
             objMgs.MessageDescription = ex.getMessage() +'--'+ ex.getStackTraceString();
             objApiResponse.Messages = new List<ScCollection_ApiResponse.Messages>();
             objApiResponse.Messages.add(objMgs);
            
             objResponse.APIStatus = objApiResponse;
             system.debug(objResponse);
             return objResponse;
         }
    }
    
    
    Public Static String GetErrorResponse(String errorCode){
        
        String responseString ='';
        
        String api_parameter_Error = 'GetErrorLog';
        ScCollection_PaymentAPIParameters__c objcredError = ScCollection_PaymentAPIParameters__c.getValues(api_parameter_Error);
        String api_url_error = objcredError.Endpoint__c; 
               api_url_error += errorCode;
        Http objhttpreq = new Http();
        HttpRequest reqst = new HttpRequest();
        reqst.setEndpoint(api_url_error);
        reqst.setMethod('GET');
        Blob headerValueError = Blob.valueOf(objcredError.Username__c+ ':' + objcredError.Password__c);
        String authorizationHeaderError = 'Basic ' + EncodingUtil.base64Encode(headerValueError);
        reqst.setHeader('Authorization', authorizationHeaderError); 
        reqst.setTimeout(120000);
        HttpResponse resp = objhttpreq.send(reqst);
        String apiResponseError =  resp.getBody();
       system.debug('Error Response='+apiResponseError);
        if(resp.getStatusCode() == 200){
            ScCollection_MeetingNotesResponseSuccess responseApiError = ScCollection_MeetingNotesResponseSuccess.parse(apiResponseError);
            if(responseApiError != null){
                if(responseApiError.APIStatus != null){
                /*
                    if(responseApiError.APIStatus.Messages != null && responseApiError.APIStatus.Messages.size()>0){
                 
                        for(ScCollection_MeetingNotesResponseSuccess.Messages objErrMessage: responseApiError.APIStatus.Messages){
                            
                            responseString = objErrMessage.Message.MessageDescription;
                            
                        }
                    }
                    */
                    responseString = responseApiError.APIStatus.APIResponse;
                }
            } 
            return responseString;
        }
        else{
            
             responseString = 'Record saved in ICM successfully but sync request didn\'t reach to source system successfully. Please try again or contact with System Administrator.';
             return responseString;
        }
    }
}