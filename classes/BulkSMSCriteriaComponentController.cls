/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          BulkSMSCriteriaComponentController
Company:       Saasfocus
Description:   This is the Lightning Component handler use to 
               populate data and filter out the Contract based 
               on the Conditions.
History
Date    :  05/11/2017     
------------------------------------------------------------*/
global class BulkSMSCriteriaComponentController{
    
    
    public static map<String,String> mapParentObjectApiNameToLabel = new map<String,String>();
    public static map<String,String> mapChildObjectApiNameToLabel = new map<String,String>();
    public static map<String,String> mapObjectNameToSourceSystemField = new map<String,String>();
    
    
     //Wrapper Class for Source System Id to the name.
    Public class SourceTypeWraper{
        @AuraEnabled
        Public String id;
        
        @AuraEnabled
        Public String name;
        
        Public SourceTypeWraper(String id, string name){
            this.id = id;
            this.name = name;
        }
    }
    
    
    //Wrapper Class to holds the Object Name and API Name. 
    global class APINameWrapper implements Comparable{
        @AuraEnabled 
        public String name;
        
        @AuraEnabled 
        public String apiName;
        
        Public APINameWrapper(String name, String apiName){
            this.name = name;
            this.apiName = apiName;
        }
        
        //Comparable method to sort the List.
        global Integer compareTo(Object objToCompare) {
          return name.compareTo(((APINameWrapper)objToCompare).name);
        }
    }
    
    //Wrapper Class for the Field label, Field Api Name and Type of the Field.
    global class APINameTypeWrapper implements Comparable{
        @AuraEnabled 
        public String name;
        
        @AuraEnabled 
        public String apiName;
        
        @AuraEnabled 
        public String apiType; 
        
        Public APINameTypeWrapper(String name, String apiName, String apiType){
            this.name = name;
            this.apiName = apiName;
            this.apiType = apiType;
        }
        
        //Comparable method to sort the List.
        global Integer compareTo(Object objToCompare) {
          return name.compareTo(((APINameTypeWrapper)objToCompare).name);
        }
    }
    
     //Wrapper Class to create the Filter Row filter criteria.
    public class FilterWrapper{
        @AuraEnabled
        Public integer sequenceNo;
        
        @AuraEnabled
        Public List<APINameWrapper> objectList;
        
        @AuraEnabled
        Public  String selectedObject;     
        
        @AuraEnabled
        Public List<APINameTypeWrapper> fieldList;
        
        @AuraEnabled
        Public String selectedField;
        
        @AuraEnabled
        Public String selectedFieldType;
        
        @AuraEnabled
        Public List<APINameWrapper> operatorList;
        
        @AuraEnabled
        Public String selectedOperator;
        
        @AuraEnabled
        Public String value;
    }
    
    //Wrapper Class to create the Filter Row filter criteria.
    public class SelectedFilterWrapper{
        @AuraEnabled
        Public integer sequenceNo;
        
        @AuraEnabled
        Public  String selectedObject;     
        
        @AuraEnabled
        Public String selectedField;
        
        @AuraEnabled
        Public String selectedOperator;
        
        @AuraEnabled
        Public String value;
    }
    
    //Wrapper Class to create the Filter Row filter criteria.
    public class SelectedFilterRowResultWrapper{
        @AuraEnabled
        Public integer sequenceNo;
        
        @AuraEnabled
        Public String value;
    }
    
    //Wrapper Class to show the Error or Success in the Lightning Component.
    public class ErrorWrapper{

        @AuraEnabled
        public boolean isError{get;set;}
        
        @AuraEnabled
        public string message{get;set;}
        
        @AuraEnabled
        public string strResults{get;set;}
    }
    
     /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getSourceTypeList
    Company:       Saasfocus
    Description:   This method is use to get all the Source System and returns the 
                   Serialize Wrapper String.
    Inputs:        
    Returns:       string
    -----------------------------------------------------------------------------------*/

    @AuraEnabled
    Public static string getSourceTypeList(){
        List<SourceTypeWraper> sourceTypeList = new List<SourceTypeWraper>();
        for(collect__Source_System__c srcSystem:[Select id, Name FROM collect__Source_System__c WHERE Name != 'CL Lease']){
            sourceTypeList.add(new SourceTypeWraper(srcSystem.id+'-'+srcSystem.Name, srcSystem.Name));
        }
        
        String jsonSource = JSON.serialize(sourceTypeList);
        return jsonSource;
    }
    
     /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getFilterRowsList
    Company:       Saasfocus
    Description:   This method is use to create the First Row defalut in the Lightning Component.
    Inputs:        String , Integer 
    Returns:       string
    -----------------------------------------------------------------------------------*/
     @AuraEnabled
    Public static string getFilterRowsList(String sourceId){
        List<FilterWrapper> filterWrapList = new List<FilterWrapper>(); 
        FilterWrapper filterWrap = new FilterWrapper();
        filterWrap.sequenceNo = 1;
        filterWrap.objectList = getRelatedObjects(sourceId);
        filterWrap.fieldList = new List<APINameTypeWrapper>();
        filterWrap.operatorList = getOperatorList();
        filterWrap.value = '';
        filterWrap.selectedObject = '';
        filterWrap.selectedField = '';
        filterWrap.selectedFieldType = '';
        filterWrap.selectedOperator = '';
        filterWrapList.add(filterWrap); 
        
        String filterWrapJSON = JSON.serialize(filterWrapList); 
        return filterWrapJSON;
    }
    
     /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getRelatedObjects
    Company:       Saasfocus
    Description:   This method is use to get all the Objects i.e Child and Parent 
                   related to Contract Based on Source System.
    Inputs:        String 
    Returns:       List<APINameWrapper>
    -----------------------------------------------------------------------------------*/
     @AuraEnabled 
    public static List<APINameWrapper> getRelatedObjects(String strSourceSystem){
        
        List<APINameWrapper> lstWrapper = new List<APINameWrapper>();
        List<Schema.SobjectField> lstSobjectFields ;
        Schema.DescribeSObjectResult descResult;
        String sourceSystemId = '';
        String sourceSystemName = '';
        String sObjectName = '';    
        lstWrapper.add(new APINameWrapper('',''));
        
        if(!String.IsBlank(strSourceSystem)){
            sourceSystemId = strSourceSystem.Split('\\-')[0];
            sourceSystemName = strSourceSystem.Split('\\-')[1];
            
            if((!String.IsBlank(sourceSystemName))){
                if(sourceSystemName.equalsIgnoreCase('CL Loan')){
                    //Parent object-------
                    lstSobjectFields = loan__Loan_Account__c.SobjectType.getDescribe().fields.getMap().Values();
                    //Child Object
                    descResult = loan__Loan_Account__c.SObjectType.getDescribe();
                    sObjectName = 'loan__Loan_Account__c';
                    lstWrapper.add(new APINameWrapper('CL Contract','loan__Loan_Account__c-CL Contract'));
                }
                else{
                    //Parent object-------
                    lstSobjectFields = collect__Loan_Account__c.SobjectType.getDescribe().fields.getMap().Values();
                    //Child Object
                    descResult = collect__Loan_Account__c.SObjectType.getDescribe();
                    sObjectName = 'collect__Loan_Account__c';
                    lstWrapper.add(new APINameWrapper('Contract','collect__Loan_Account__c-Contract'));
                }   
            }
        }
       
       
          
        //Get all Parent Objects
        for(Schema.SobjectField strFld: lstSobjectFields)
        {
            if(strFld.getDescribe().getType() == Schema.DisplayType.REFERENCE)
            {
                for(Schema.SObjectType reference : strFld.getDescribe().getReferenceTo()) {
                    
                    lstWrapper.add(new APINameWrapper(reference.getDescribe().getLabel(), reference.getDescribe().getName()+'-'+strFld.getDescribe().getName()+'-'+reference.getDescribe().getLabel()));
                    
                    mapParentObjectApiNameToLabel.put(reference.getDescribe().getName(),reference.getDescribe().getLabel());
                    
                    if(reference.getDescribe().getName() == 'collect__Source_System__c'){
                        mapObjectNameToSourceSystemField.put(sObjectName,strFld.getDescribe().getName());
                    }
                }
            } 
        }
        
        set<String> setChildObjectNames = new set<String>();
        //Get all Child Objects
        for (Schema.ChildRelationship cr: descResult.getChildRelationships()) 
        {
            if(!setChildObjectNames.Contains(cr.getChildSObject().getDescribe().getLabel())){
                string name = cr.getChildSObject().getDescribe().getLabel();
                string apiName = cr.getChildSObject().getDescribe().getName()+'-'+cr.getChildSObject().getDescribe().getLabel();
                
                lstWrapper.add(new APINameWrapper(name , apiName));      
                setChildObjectNames.add(cr.getChildSObject().getDescribe().getLabel());
                mapChildObjectApiNameToLabel.put(cr.getChildSObject().getDescribe().getName(),cr.getChildSObject().getDescribe().getLabel());
            }
                
        }
        lstWrapper.sort();
        return lstWrapper;
    }
    
     //Wrapper Class to show the Conditions in the Lightning Component.
    public static List<APINameWrapper> getOperatorList(){
        List<APINameWrapper> apiWrapLst = new List<APINameWrapper>();
        apiWrapLst.add(new APINameWrapper('--None--',''));
        apiWrapLst.add(new APINameWrapper('=-Equals','Equals'));
        apiWrapLst.add(new APINameWrapper('>-Greater Than','Greater Than'));
        apiWrapLst.add(new APINameWrapper('<-Less Than','Less Than'));
        apiWrapLst.add(new APINameWrapper('!=-Not Equals','Not Equals'));
        apiWrapLst.add(new APINameWrapper('>=-Greater Than Equals','Greater Than Equals'));
        apiWrapLst.add(new APINameWrapper('<=-Less Than Equals','Less Than Equals'));
        return apiWrapLst;
    }
    
     /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getAllFields
    Company:       Saasfocus
    Description:   This method is use to get all the Fields when the user Select Object
                   from the Filters.
    Inputs:        String 
    Returns:       String
    -----------------------------------------------------------------------------------*/
    @AuraEnabled 
    public static String getAllFields(String sObjName){
        
        String strSelectedObject = sObjName;
        if(!String.IsBlank(sObjName) && (sObjName).Contains('-')){
            strSelectedObject = (sObjName).Split('\\-')[0];
        }
        
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        List<APINameTypeWrapper> apiNameWraplst = new List<APINameTypeWrapper>();
        apiNameWraplst.add(new APINameTypeWrapper('' , '', ''));
        Schema.sObjectType sObjType = globalDescription.get(strSelectedObject); 
        sObject sObjectToBind = sObjType.newSObject(); 
        Schema.DescribeSObjectResult r1 = sObjType.getDescribe(); 
        Map<String , Schema.SObjectField> mapFieldList = r1.fields.getMap();
        
        for(Schema.SobjectField strFld: mapFieldList.values()){
            if(strFld.getDescribe().getType() != Schema.DisplayType.REFERENCE && strFld.getDescribe().getType() != Schema.DisplayType.ID && strFld.getDescribe().getType() != Schema.DisplayType.TextArea){ 
                schema.describefieldresult dfield = strFld.getDescribe();
                
                string name = dfield.getLabel();
                string apiName = dfield.getName();
                string apiType = dfield.getName()+'-'+String.valueOf(dfield.getType())+'-'+dfield.getLabel();
                apiNameWraplst.add(new APINameTypeWrapper(name , apiName, apiType));
            } 
        }
        apiNameWraplst.sort();
        String apiName = JSON.serialize(apiNameWraplst);
        return apiName;
    }
    
    
    @auraEnabled
    public static String getRowResult(String strSourceSystem,String strFilterRow){
        ErrorWrapper objWrapper = new ErrorWrapper();
        
        try{
            if(!String.IsBlank(strFilterRow) && !String.IsBlank(strSourceSystem)){
                String sourceSystemId = strSourceSystem.Split('\\-')[0];
                String sourceSystemName = strSourceSystem.Split('\\-')[1];
                
                String strResultValue = '';
                
                //Prepare the Map for the Object and there API name.
                getRelatedObjects(strSourceSystem);
                
                Map<String, Schema.SObjectField> sObjectType;
                
                String bulksmsfilterRow = ' And ';
                
                
                FilterWrapper objFilterCondition = (FilterWrapper)JSON.deserialize(
                       strFilterRow, FilterWrapper.class);
                system.debug(objFilterCondition);
                String strObjectName ='';   
                if(!String.IsBlank(sourceSystemName) && sourceSystemName.equalsIgnoreCase('CL Loan')){
                    strObjectName = 'loan__Loan_Account__c';
                }
                else{
                    strObjectName = 'collect__Loan_Account__c';
                    try{
                         
                        String strFilterCriteriaSS = [Select Id,Bulk_SMS_Criteria__c From collect__Source_System__c where Id = :sourceSystemId].Bulk_SMS_Criteria__c;
                        bulksmsfilterRow += ' ' +strFilterCriteriaSS;
                    }
                    catch(Exception ex){
                        system.debug('Exception bulksmsfilterRow ' + ex.getMessage());
                    }
                    
                }
                
                String strSelectedObject = objFilterCondition.selectedObject.Split('\\-')[0];
                String strSelectedObjectFieldInContract = '';
                if(!String.IsBlank(objFilterCondition.selectedObject) && (objFilterCondition.selectedObject).Contains('-')){
                    String[] strSplitSize = (objFilterCondition.selectedObject).Split('\\-');
                    if(strSplitSize.Size() > 2){
                        strSelectedObject = (objFilterCondition.selectedObject).Split('\\-')[0];
                        strSelectedObjectFieldInContract = (objFilterCondition.selectedObject).Split('\\-')[1];
                    }
                    
                }
                
                String strQueryFromConditions = '';
                String fieldValue = '';
                boolean checkDateTime = false;
                String strParentField = '';
                String strField = objFilterCondition.selectedField.split('\\-')[0];
                String strSelectedOperatorValue = objFilterCondition.selectedOperator.split('\\-')[0];
                //Check if the Selected Condition is Account,Contact or the Contract it self.
                if(!String.IsBlank(sourceSystemName)  && (((strSelectedObject == 'Account' || strSelectedObject == 'Contact') && !sourceSystemName.equalsIgnoreCase('CL Loan')) || strSelectedObject == strObjectName)){
                    //If Account Or Contact then query on Party Record for the Source System PAF and Mortgage.
                    if(strSelectedObject == 'Account' && !sourceSystemName.equalsIgnoreCase('CL Loan')){
                        sObjectType = Schema.SObjectType.Account.fields.getMap();
                        
                        Schema.SObjectField field = sObjectType.get(strField);
                        Schema.DisplayType fldType = field.getDescribe().getType();
                        
                        if(String.valueOf(fldType) == 'STRING' || String.valueOf(fldType) == 'PICKLIST'){
                            fieldValue = '\''+objFilterCondition.value+'\''; 
                        }
                        else{
                            if(objFilterCondition.value == null || objFilterCondition.value==''){
                                fieldValue = 'null';
                            }
                            else if(String.valueOf(fldType) == 'DATETIME'){
                                checkDateTime = true;
                                fieldValue = objFilterCondition.value;
                            }
                            else{
                                fieldValue = objFilterCondition.value;
                            }
                        }
                        if(!String.isBlank(bulksmsfilterRow) && bulksmsfilterRow.Contains('{parentfield}')){
                            bulksmsfilterRow = bulksmsfilterRow.replace('{parentfield}','collect__CL_Contract__r.');
                        }
                        else{
                            bulksmsfilterRow = '';
                        }
                        if(checkDateTime){
                            strQueryFromConditions = 'Select collect__CL_Contract__c from clcommon__Party__c where (DAY_ONLY(clcommon__Account__r.' + strField + ') ' + strSelectedOperatorValue+ ' ' + fieldValue + ') And collect__CL_Contract__c != null And collect__CL_Contract__r.collect__Source_System__c = :sourceSystemId ' +bulksmsfilterRow+ ' Limit 50000 ';
                        }
                        else{
                            strQueryFromConditions = 'Select collect__CL_Contract__c from clcommon__Party__c where (clcommon__Account__r.' + strField + ' ' + strSelectedOperatorValue+ ' ' + fieldValue + ') And collect__CL_Contract__c != null And collect__CL_Contract__r.collect__Source_System__c = :sourceSystemId ' +bulksmsfilterRow+ ' Limit 50000 ';
                        }
                        system.debug(strQueryFromConditions );
                        //List<clcommon__Party__c> lstSobject = Database.query(strQueryFromConditions);
                        String strIds = '';
                        Boolean checkFirstIndex = true;
                        set<String> setConIds = new set<String>();
                        for(clcommon__Party__c objParty : Database.query(strQueryFromConditions)){
                            if(!setConIds.Contains(objParty.collect__CL_Contract__c)){
                                if(checkFirstIndex){
                                    strIds += '\''+objParty.collect__CL_Contract__c+'\'';
                                    checkFirstIndex = false;
                                }
                                else{
                                    strIds += ','+'\''+objParty.collect__CL_Contract__c+'\'';
                                }
                                setConIds.add(objParty.collect__CL_Contract__c);
                            }
                        }
                        if(!String.IsBlank(strIds)){
                            strIds = ' Id In ( '+strIds+' ) ';
                        }
                        else{
                            strIds = 'Id In (NULL) ';
                        }
                        system.debug(strIds );
                        strResultValue = strIds;
                    }
                    else if(strSelectedObject == 'Contact' && !sourceSystemName.equalsIgnoreCase('CL Loan')){
                            
                        sObjectType = Schema.SObjectType.Contact.fields.getMap();
                        Schema.SObjectField field = sObjectType.get(strField);
                        Schema.DisplayType fldType = field.getDescribe().getType();
                        
                        if(String.valueOf(fldType) == 'STRING' || String.valueOf(fldType) == 'PICKLIST'){
                            fieldValue = '\''+objFilterCondition.value+'\''; 
                        }
                        else{
                            if(objFilterCondition.value == null || objFilterCondition.value==''){
                                fieldValue = 'null';
                            }
                            else if(String.valueOf(fldType) == 'DATETIME'){
                                checkDateTime = true;
                                fieldValue = objFilterCondition.value;
                            }
                            else{
                                fieldValue = objFilterCondition.value;
                            }
                        }
                        
                        if(!String.isBlank(bulksmsfilterRow) && bulksmsfilterRow.Contains('{parentfield}')){
                            bulksmsfilterRow = bulksmsfilterRow.replace('{parentfield}','collect__CL_Contract__r.');
                        }
                        else{
                            bulksmsfilterRow = '';
                        }
                        if(checkDateTime){
                            strQueryFromConditions = 'Select collect__CL_Contract__c from clcommon__Party__c where (DAY_ONLY(clcommon__Contact__r.' + strField + ') ' + strSelectedOperatorValue+ ' ' + fieldValue + ') And collect__CL_Contract__c != null And collect__CL_Contract__r.collect__Source_System__c = :sourceSystemId ' +bulksmsfilterRow+ ' Limit 50000 ';
                        }
                        else{
                            strQueryFromConditions = 'Select collect__CL_Contract__c from clcommon__Party__c where (clcommon__Contact__r.' + strField + ' ' + strSelectedOperatorValue+ ' ' + fieldValue + ') And collect__CL_Contract__c != null And collect__CL_Contract__r.collect__Source_System__c = :sourceSystemId ' +bulksmsfilterRow+ ' Limit 50000 ';
                        }
                        
                        //List<clcommon__Party__c> lstSobject = Database.query(strQueryFromConditions);
                        String strIds = '';
                        Boolean checkFirstIndex = true;
                        set<String> setConIds = new set<String>();
                        for(clcommon__Party__c objParty : Database.query(strQueryFromConditions)){
                            if(!setConIds.Contains(objParty.collect__CL_Contract__c)){
                                if(checkFirstIndex){
                                    strIds += '\''+objParty.collect__CL_Contract__c+'\'';
                                    checkFirstIndex = false;
                                }
                                else{
                                    strIds += ','+'\''+objParty.collect__CL_Contract__c+'\'';
                                }
                                setConIds.add(objParty.collect__CL_Contract__c);
                            }
                            
                        }
                        if(!String.IsBlank(strIds)){
                            strIds = ' Id In ( '+strIds+' ) ';
                        }
                        else{
                            strIds = 'Id In (NULL) ';
                        }
                        strResultValue = strIds;
                    }
                    else if(strSelectedObject == strObjectName){
                        if(strObjectName == 'collect__Loan_Account__c'){
                            sObjectType = Schema.SObjectType.collect__Loan_Account__c.fields.getMap();
                        }
                        else{
                            sObjectType = Schema.SObjectType.loan__Loan_Account__c.fields.getMap();
                        }
                        
                        Schema.SObjectField field = sObjectType.get(strField);
                        Schema.DisplayType fldType = field.getDescribe().getType();
                        
                        if(String.valueOf(fldType) == 'STRING' || String.valueOf(fldType) == 'PICKLIST'){
                            fieldValue = '\''+objFilterCondition.value+'\''; 
                        }
                        else{
                            if(objFilterCondition.value == null || objFilterCondition.value==''){
                                fieldValue = 'null';
                            }
                            else if(String.valueOf(fldType) == 'DATETIME'){
                                checkDateTime = true;
                                fieldValue = objFilterCondition.value;
                            }
                            else{
                                fieldValue = objFilterCondition.value;
                            }
                        }
                        
                        if(checkDateTime){
                            strQueryFromConditions = ' DAY_ONLY(' + strField+ ') ' + strSelectedOperatorValue + ' ' + fieldValue + ' ';
                        }
                        else{
                            strQueryFromConditions = ' ' + strField+ ' ' + strSelectedOperatorValue + ' ' + fieldValue + ' ';
                        }
                        strResultValue = strQueryFromConditions;
                    }
                }
                else{
                    //logic to create the dynamic Query for all the Object other then (Account,Contact for Collection sObject) and Contract.
                    Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
                    Schema.sObjectType sObjType = globalDescription.get(strSelectedObject); 
                    sObject sObjectToBind = sObjType.newSObject(); 
                    Schema.DescribeSObjectResult r1 = sObjType.getDescribe(); 
                    Map<String , Schema.SObjectField> mapFieldList = r1.fields.getMap();
                    
                    //Check if the selected object is Child of Contract.
                    if(mapChildObjectApiNameToLabel.containsKey(strSelectedObject) && String.isBlank(strSelectedObjectFieldInContract)){
                        
                        for(Schema.SobjectField strFld: mapFieldList.values())
                        {
                            if(strFld.getDescribe().getType() == Schema.DisplayType.REFERENCE){
                              
                                for(Schema.SObjectType reference : strFld.getDescribe().getReferenceTo()) {
                                    if(reference.getDescribe().getName() == strObjectName){
                                        strParentField = strFld.getDescribe().getName();
                                    }
                                }
                            }
                            else{
                                if(strFld.getDescribe().getName().trim() == strField.trim()){
                                    if(String.valueOf(strFld.getDescribe().getType()) == 'STRING' || String.valueOf(strFld.getDescribe().getType()) == 'PICKLIST' || String.valueOf(strFld.getDescribe().getType()) == 'TEXTAREA'){
                                        fieldValue = '\''+objFilterCondition.value+'\''; 
                                        
                                    }
                                    else{
                                        if(objFilterCondition.value == null || objFilterCondition.value==''){
                                            fieldValue = 'null';
                                        }
                                        else if(String.valueOf(strFld.getDescribe().getType()) == 'DATETIME'){
                                            checkDateTime = true;
                                            fieldValue = objFilterCondition.value;
                                        }
                                        else{
                                            fieldValue = objFilterCondition.value;
                                        }
                                    }
                                }
                            } 
                        }
                        
                        //if Collection Contract...creating the query with the source system check.
                        if(strObjectName == 'collect__Loan_Account__c' && !String.IsBlank(strParentField) && mapObjectNameToSourceSystemField.ContainsKey(strObjectName) && mapObjectNameToSourceSystemField.get(strObjectName) != null && !String.Isblank(sourceSystemId)){
                            if(!String.isBlank(bulksmsfilterRow) && bulksmsfilterRow.Contains('{parentfield}')){
                                String strParentFieldReplace = strParentField.substring(0,strParentField.length()-1) +'r.';
                                bulksmsfilterRow = bulksmsfilterRow.replace('{parentfield}',strParentFieldReplace);
                            }
                            else{
                                bulksmsfilterRow = '';
                            }
                            if(checkDateTime){
                                strQueryFromConditions = 'Select '+strParentField + ' from ' + strSelectedObject + ' Where (DAY_ONLY(' + strField + ') ' + strSelectedOperatorValue + ' ' + fieldValue + ') And '+ strParentField.substring(0,strParentField.length()-1) +'r.'+ mapObjectNameToSourceSystemField.get(strObjectName) + ' = :sourceSystemId ' +bulksmsfilterRow+ ' Limit 50000 ';
                            }
                            else{
                                strQueryFromConditions = 'Select '+strParentField + ' from ' + strSelectedObject + ' Where (' + strField + ' ' + strSelectedOperatorValue + ' ' + fieldValue + ') And '+ strParentField.substring(0,strParentField.length()-1) +'r.'+ mapObjectNameToSourceSystemField.get(strObjectName) + ' = :sourceSystemId ' +bulksmsfilterRow+ ' Limit 50000 ';
                            }
                            
                            
                        }
                        else{
                            if(checkDateTime){
                                strQueryFromConditions = 'Select '+strParentField + ' from ' + strSelectedObject + ' Where (DAY_ONLY(' + strField + ') ' + strSelectedOperatorValue + ' ' + fieldValue + ') Limit 50000 ';
                            }
                            else{
                                strQueryFromConditions = 'Select '+strParentField + ' from ' + strSelectedObject + ' Where (' + strField + ' ' + strSelectedOperatorValue + ' ' + fieldValue + ') Limit 50000 ';
                            }
                        }
                        system.debug('strQueryFromConditions Child '+ strQueryFromConditions);
                        String strIds = '';
                        if(!String.IsBlank(strQueryFromConditions)){
                            //List<sObject> lstSobject = Database.query(strQueryFromConditions);
                            Boolean checkFirstIndex = true;
                            //set<String> setConIds = new set<String>();
                            for(sObject objResults : Database.query(strQueryFromConditions)){
                                if(objResults.get(strParentField) != null){
                                    if(!strIds.Contains(String.ValueOf(objResults.get(strParentField)))){
                                        if(checkFirstIndex){
                                            strIds += '\''+String.ValueOf(objResults.get(strParentField))+'\'';
                                            checkFirstIndex = false;
                                        }
                                        else{
                                            strIds += ','+'\''+String.ValueOf(objResults.get(strParentField))+'\'';
                                        }
                                        //setConIds.add(String.ValueOf(objResults.get(strParentField)));
                                    }
                                }
                                    
                            }
                            if(!String.IsBlank(strIds)){
                                strIds = ' Id In ( '+strIds+' ) ';
                            }
                            else{
                                strIds = 'Id In (NULL) ';
                            }
                            strResultValue = strIds;
                        }
                        
                    }
                    else if(mapParentObjectApiNameToLabel.containsKey(strSelectedObject) && !String.isBlank(strSelectedObjectFieldInContract)){
                       system.debug('inside parent');
                        //For Parent Object.
                        for(Schema.SobjectField strFld: mapFieldList.values()){
                            if(strFld.getDescribe().getName().trim() == strField.trim()){
                                if(String.valueOf(strFld.getDescribe().getType()) == 'STRING' || String.valueOf(strFld.getDescribe().getType()) == 'PICKLIST'){
                                    fieldValue = '\''+objFilterCondition.value+'\''; 
                                }
                                else{
                                    if(objFilterCondition.value == null || objFilterCondition.value==''){
                                        fieldValue = 'null';
                                    }
                                    else if(String.valueOf(strFld.getDescribe().getType()) == 'DATETIME'){
                                        checkDateTime = true;
                                        fieldValue = objFilterCondition.value;
                                    }
                                    else {
                                        fieldValue = objFilterCondition.value;
                                    }
                                }
                            }
                        }
                        
                        
                        if(!String.IsBlank(strSelectedObjectFieldInContract)){
                            
                            String strFieldNameFromMap = strSelectedObjectFieldInContract;
                            if(checkDateTime){
                                if(strFieldNameFromMap.contains('__c')){
                                    strQueryFromConditions = ' DAY_ONLY('+ strFieldNameFromMap.substring(0,strFieldNameFromMap.length()-1) + 'r.'+strField + ') ' + strSelectedOperatorValue + ' ' + fieldValue + ' ';
                                }
                                else{
                                    strQueryFromConditions = ' DAY_ONLY('+ strFieldNameFromMap.substring(0,strFieldNameFromMap.length()-2) + '.'+strField + ') ' + strSelectedOperatorValue + ' ' + fieldValue + ' ';
                                }
                                
                            }
                            else{
                                if(strFieldNameFromMap.contains('__c')){
                                    strQueryFromConditions = ' '+ strFieldNameFromMap.substring(0,strFieldNameFromMap.length()-1) + 'r.'+strField + ' ' + strSelectedOperatorValue + ' ' + fieldValue + ' ';
                                }
                                else{
                                    strQueryFromConditions = ' '+ strFieldNameFromMap.substring(0,strFieldNameFromMap.length()-2) + '.'+strField + ' ' + strSelectedOperatorValue + ' ' + fieldValue + ' ';
                                }
                            }
                           system.debug('strQueryFromConditions'+strQueryFromConditions) ;
                           strResultValue = strQueryFromConditions;
                        }
                        
                    }
                }
                system.debug('strQueryFromConditions'+strResultValue);
                objWrapper.isError = false;
                objWrapper.message = 'SUCCESS';
                objWrapper.strResults = strResultValue;
                return JSON.serialize(objWrapper);
            }
            objWrapper.isError = true;
            objWrapper.message = 'Error !! Please Contact your System Admin !';
            objWrapper.strResults = '';
            
            return JSON.serialize(objWrapper); 
        }
        catch(Exception ex){
            system.debug(ex.getStackTraceString());
            objWrapper.isError = true;
            objWrapper.message = 'Error !! '+ex.getMessage();
            objWrapper.strResults = '';
            
            return JSON.serialize(objWrapper);
        }
    }
    
    @auraEnabled
    public static String getSearchResult(String strSourceSystem,String strFilterCriteria,String strWrapperRows){
        ErrorWrapper objWrapper = new ErrorWrapper();
        try{
            if(!String.IsBlank(strSourceSystem) && !String.IsBlank(strFilterCriteria) && !String.IsBlank(strWrapperRows)){
                String sourceSystemId = strSourceSystem.Split('\\-')[0];
                String sourceSystemName = strSourceSystem.Split('\\-')[1];
                
                List<SelectedFilterRowResultWrapper> objFilterCondition = (List<SelectedFilterRowResultWrapper>)JSON.deserialize(
                       strWrapperRows, List<SelectedFilterRowResultWrapper>.class);
                
                map<String,String> mapSequencNumToQueryString = new map<String,String>();
                for(SelectedFilterRowResultWrapper objRowWrapper : objFilterCondition){
                    mapSequencNumToQueryString.put(String.valueof(objRowWrapper.sequenceNo),objRowWrapper.value);
                }
                
                List<String> lstCriteriaSplit = strFilterCriteria.Split(' ');
                String strFinalCriteria = '';
                for(String splitCriteria : lstCriteriaSplit){ 
                    if(splitCriteria.isNumeric()){
                        strFinalCriteria += mapSequencNumToQueryString.get(String.valueOf(splitCriteria));
                    }
                    else{
                        strFinalCriteria += splitCriteria;
                    }
                    strFinalCriteria += ' ';
                }
                String strFinalQuery = 'Select Id ';
                system.debug('strFinalCriteria'+strFinalCriteria);
                if(!String.IsBlank(sourceSystemName) && sourceSystemName.equalsIgnoreCase('CL Loan')){
                    strFinalQuery += ',Name,loan__Account__r.Name,loan__Account__r.PersonMobilePhone,loan__Account__c From loan__Loan_Account__c Where ('+ strFinalCriteria + ') Limit 1001';
                }
                else{
                    strFinalQuery += ',Name,collect__Collection_Status__r.ScCollection_Primary_Borrower_Name__c,collect__Collection_Status__r.ScCollection_Primary_Borrower_Mobile_No__c,collect__Collection_Status__r.ScCollection_Account__c,collect__Collection_Status__r.ScCollection_Contact__c,ScCollection_Bucket__c,ScCollection_Contract_Split_Number__c,collect__External_ID__c From collect__Loan_Account__c  Where (collect__Source_System__c = : sourceSystemId) AND ('+ strFinalCriteria +') Limit 1001';
                }
                //To check the Final Query String.
                System.debug('@@@Query =='+strFinalQuery);
                system.debug('strFinalCriteria'+strFinalCriteria);
                List<sObject> lstSobject = Database.query(strFinalQuery);
                system.debug('lstSobject '+lstSobject);
                //If the Retrieved List is more than 1000 then error to be displayed.
                if(lstSobject != null){
                    if(lstSobject.Size() > 1000){
                        objWrapper.isError = true;
                        objWrapper.message = 'More than 1000 rows retrieved. Please change the filter criteria.';
                        objWrapper.strResults = '';
                        return JSON.serialize(objWrapper);
                    } 
                    if(lstSobject.Size() == 0){
                        objWrapper.isError = true;
                        objWrapper.message = 'No rows Retrieved. Please change the filter criteria...';
                        objWrapper.strResults = '';
                        return JSON.serialize(objWrapper);
                    }  
                }
                
                List<BulkSMSContractListHandler.ContractListWrapper> lstContractListWrapper = new List<BulkSMSContractListHandler.ContractListWrapper>();
                BulkSMSContractListHandler.ContractListWrapper objContractWrapper;
                //Preparing the wrapper data which is use to display the retrieved rows into the Lightning Component. 
                if(sourceSystemName.equalsIgnoreCase('CL Loan')){
                    List<loan__Loan_Account__c> listPlContract= (List<loan__Loan_Account__c>)lstSobject;
                    for(loan__Loan_Account__c objLoanAccount : listPlContract){
                        objContractWrapper = new BulkSMSContractListHandler.ContractListWrapper();
                        objContractWrapper.strRecordId = objLoanAccount.Id;
                        objContractWrapper.strContractName = objLoanAccount.Name;
                        objContractWrapper.strBorrower = objLoanAccount.loan__Account__r.Name;
                        objContractWrapper.strBorrowerNo = String.ValueOf(objLoanAccount.loan__Account__r.PersonMobilePhone);
                        objContractWrapper.strAccountID = String.ValueOf(objLoanAccount.loan__Account__c);
                        objContractWrapper.sendSMS = false;
                        lstContractListWrapper.add(objContractWrapper);
                    }
                }
                else{
                    List<collect__Loan_Account__c> listClContract= (List<collect__Loan_Account__c>)lstSobject;
                    map<String,collect__Loan_Account__c> mapExternalIdtoContract = new map<String,collect__Loan_Account__c>();
                    
                    if(!String.isBlank(sourceSystemName) && sourceSystemName.equalsIgnoreCase('Mortgage')){
                        set<String> strExternalId = new set<String>();
                        for(collect__Loan_Account__c objLoanAccount : listClContract){
                            if(objLoanAccount.ScCollection_Contract_Split_Number__c > 0 && !String.isBlank(objLoanAccount.collect__External_ID__c)){
                                List<String> lstExternalId = objLoanAccount.collect__External_ID__c.split('_');
                                String strMatch = lstExternalId[0]+'_0';
                                strExternalId.add(strMatch);
                            }
                        }
                        if(strExternalId != null && strExternalId.size() > 0){
                            for(collect__Loan_Account__c objParentLoanAcc : [Select Id,Name,collect__Collection_Status__r.ScCollection_Primary_Borrower_Name__c,collect__Collection_Status__r.ScCollection_Primary_Borrower_Mobile_No__c,collect__Collection_Status__r.ScCollection_Account__c,collect__Collection_Status__r.ScCollection_Contact__c,ScCollection_Bucket__c,collect__External_ID__c From collect__Loan_Account__c where collect__External_ID__c in : strExternalId]){
                                
                                mapExternalIdtoContract.put(objParentLoanAcc.collect__External_ID__c,objParentLoanAcc);
                            }
                        }
                    }
                    
                    
                    for(collect__Loan_Account__c objLoanAccount : listClContract){
                        objContractWrapper = new BulkSMSContractListHandler.ContractListWrapper();
                        objContractWrapper.strRecordId = objLoanAccount.Id;
                        objContractWrapper.strContractName = objLoanAccount.Name;
                        objContractWrapper.strBucket = String.ValueOf(objLoanAccount.ScCollection_Bucket__c);
                        objContractWrapper.sendSMS = false;
                        
                        String strMatch = '';
                        
                        if(objLoanAccount.ScCollection_Contract_Split_Number__c > 0 && !String.isBlank(objLoanAccount.collect__External_ID__c)){
                            List<String> lstExternalId = objLoanAccount.collect__External_ID__c.split('_');
                            strMatch = lstExternalId[0]+'_0';
                        }   
                        if(!String.isBlank(strMatch) && mapExternalIdtoContract.containsKey(strMatch) && mapExternalIdtoContract.get(strMatch) != null){
                            objContractWrapper.strBorrower = mapExternalIdtoContract.get(strMatch).collect__Collection_Status__r.ScCollection_Primary_Borrower_Name__c;
                            objContractWrapper.strBorrowerNo = String.ValueOf(mapExternalIdtoContract.get(strMatch).collect__Collection_Status__r.ScCollection_Primary_Borrower_Mobile_No__c);
                            objContractWrapper.strAccountID = String.ValueOf(mapExternalIdtoContract.get(strMatch).collect__Collection_Status__r.ScCollection_Account__c);
                            objContractWrapper.strContactID = String.ValueOf(mapExternalIdtoContract.get(strMatch).collect__Collection_Status__r.ScCollection_Contact__c);
                        }
                        else{
                            objContractWrapper.strBorrower = objLoanAccount.collect__Collection_Status__r.ScCollection_Primary_Borrower_Name__c;
                            objContractWrapper.strBorrowerNo = String.ValueOf(objLoanAccount.collect__Collection_Status__r.ScCollection_Primary_Borrower_Mobile_No__c);
                            objContractWrapper.strAccountID = String.ValueOf(objLoanAccount.collect__Collection_Status__r.ScCollection_Account__c);
                            objContractWrapper.strContactID = String.ValueOf(objLoanAccount.collect__Collection_Status__r.ScCollection_Contact__c);
                        }
                        
                        lstContractListWrapper.add(objContractWrapper);
                    }
                }
                objWrapper.isError = false;
                objWrapper.message = 'SUCCESS';
                objWrapper.strResults = JSON.serialize(lstContractListWrapper);
                return JSON.serialize(objWrapper);
            }
            objWrapper.isError = true;
            objWrapper.message = 'Error !! Please Contact your System Admin !';
            objWrapper.strResults = '';
            return JSON.serialize(objWrapper); 
        }
        catch(Exception ex){
            system.debug(ex.getStackTraceString());
            objWrapper.isError = true;
            objWrapper.message = 'Error !! '+ex.getMessage();
            objWrapper.strResults = '';
            return JSON.serialize(objWrapper);
        }
    }

}