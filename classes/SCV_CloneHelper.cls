/*------------------------------------------------------------
Author:         Vincent Vuong
Company:        SaaSfocus
Description:    Helper Class that generalises the deep clone functionality for 1-level only
Test Class:     TODO

History
<Date>      <Authors Name>      <Brief Description of Change>
20-Nov-17   Vincent Vuong       Created
------------------------------------------------------------*/
public with sharing class SCV_CloneHelper {

	/*------------------------------------------------------------
	Description: Function that performs deep clone
    Inputs: 		Parameters to pass:
				    1.recordIdToClone: Id of parent record to clone or to graft
				    2.childObjectAPIName: Child object records to clone
				    3.parentFieldAPIName : API Name of the parent record in the child object
				    4.parentFieldstoOverride: Parent fields to default (Whether we default all types vs just String is TBA)
				    5.childFieldstoOverride: Child fields to default (Whether we default all types vs just String is TBA)
				    6.cloneParentFlag: Whether to clone the Parent record or graft to Parent Id (First Parameter)    

	Outputs:		Id
	History
	<Date> 		<Authors Name> 		<Brief Description of Change>
	20-Nov-17   Vincent Vuong    	Created
	------------------------------------------------------------*/
    public static Id cloneRecord(Id recordIdToClone, String childObjectAPIName, String parentFieldAPIName, Map<String, String>parentFieldstoOverride, Map<String, String> childFieldstoOverride, Boolean cloneParentFlag){
        Id oldParentRecId,newParentRecId;
        String childQuery;
        List<sObject> newChildRecsToCreate = new List<sObject>();
        Map<String,String> fieldAPINameDataTypes = new Map<String,String>();
        Schema.SObjectType parentRecType;
        String parentObjName;
        SObject parentRecordToClone;
        SObject newParentRecord;
        //identify sObject (parent record)
        parentRecType = recordIdToClone.getSObjectType();
        parentObjName = parentRecType.getDescribe().getName();		
        
        /*** Clone Parent record only if flag = true ***/
        if(cloneParentFlag){
            oldParentRecId = recordIdToClone;
            parentRecordToClone = Database.query(queryBuilder(parentObjName,'Id =:oldParentRecId'));
            //clone sObject
            newParentRecord = parentRecordToClone.clone(false,true,false,false);
            //override fields logic goes here
            fieldAPINameDataTypes = fieldsAndDataType(parentObjName);
            if(parentFieldstoOverride != null){
                for(String field :parentFieldstoOverride.keySet()){
                    String dataType = fieldAPINameDataTypes.get(field);
                    Object fieldValue = retrieveFieldValue(dataType,parentFieldstoOverride.get(field));
                    newParentRecord.put(field,fieldValue);
                }
            }
            system.debug('newParentRecord to be inserted ' + newParentRecord);
            Database.SaveResult sr = Database.insert(newParentRecord);
            if(sr.isSuccess()){
                newParentRecId = sr.getId();
            }
        }
        /* do not clone parent record if flag = false 
         * this condition is useful when you want to clone a 2nd level of objects*/
        else{
            oldParentRecId = newParentRecId = recordIdToClone;
        }
        //get related child Object record(s) and clone them
        //build query to fetch records i.e. [select id from child_ob where ParentId =:oldParentRecId]
        if(childObjectAPIName != null){
            childQuery = queryBuilder(childObjectAPIName,parentFieldAPIName + ' =:oldParentRecId ');
            //List<SObject> oldchildRecords= database.query(childQuery);
            for(sObject child :database.query(queryBuilder(childObjectAPIName,parentFieldAPIName + ' =:oldParentRecId '))){
                sObject newChildRec = child.clone(false,true,false,false);
                newChildRec.put(parentFieldAPIName,newParentRecId);
                //for fields to be overridden logic goes here
                fieldAPINameDataTypes = fieldsAndDataType(childObjectAPIName);
                if(childFieldstoOverride != null){
                    for(String field :childFieldstoOverride.keySet()){
                        String dataType = fieldAPINameDataTypes.get(field);
                        Object fieldValue = retrieveFieldValue(dataType,childFieldstoOverride.get(field));
                        newChildRec.put(field,fieldValue);
                    }
                }
                newChildRecsToCreate.add(newChildRec);
            }
            system.debug('newChildRecsToCreate ' + newChildRecsToCreate);
            if(!newChildRecsToCreate.isEmpty()){
                insert newChildRecsToCreate;
            } 
        }
        return newParentRecId;
    }
    
	/*------------------------------------------------------------
	Description: 	Function to build SOQL query based on object name and where clause
	Inputs: 		1. String - 
					2. String - 
	Outputs:		String, returns full SOQL query
	History
	<Date> 		<Authors Name> 		<Brief Description of Change>
	20-Nov-17   Vincent Vuong    	Created
	------------------------------------------------------------*/
    static String queryBuilder(String objName, String whereClause) {
        String queryString = 'SELECT ';
        List<String> selectFields = new List<String>();
        //select only createable fields
        for (Schema.SObjectField ft : Schema.getGlobalDescribe().get(objName).getDescribe().Fields.getMap().values()){ // loop through all field tokens (ft)
            Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
            if (fd.isCreateable() ){ // field is creatable
                selectFields.add(fd.getName());
            }
        }        
        if (!selectFields.isEmpty()){
            queryString += String.join(selectFields, ',');
        }
        //from objName
        queryString += ' from '+ objName;
        //where clause
        if(whereClause != null){
            queryString += ' where '+whereClause;
        }
        return queryString;
    }
    
	/*------------------------------------------------------------
	Description: 	Function to get the data types given field API Names
	Inputs: 		1. String - 
	Outputs:		Map of field API Names and their data types
	History
	<Date> 		<Authors Name> 		<Brief Description of Change>
	20-Nov-17   Vincent Vuong    	Created
	------------------------------------------------------------*/
    static Map<String,String> fieldsAndDataType(String objName) {
        Map<String,String> nameDataTypeMap = new Map<String,String>();
        for (Schema.SObjectField ft : Schema.getGlobalDescribe().get(objName).getDescribe().Fields.getMap().values()){ // loop through all field tokens (ft)
            Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
            if (fd.isCreateable()){ // field is creatable
                nameDataTypeMap.put(fd.getName(),String.valueOf(fd.getSoapType()));
            }
        }
        return nameDataTypeMap;
    }
    
	/*------------------------------------------------------------
	Description: 	Function to get the field values in the data type required. Type casting dynamically
	Inputs: 		1. String - 
					2. String - 
	Outputs:		Returns typecasted value to be inserted
	History
	<Date> 		<Authors Name> 		<Brief Description of Change>
	20-Nov-17   Vincent Vuong    	Created
	------------------------------------------------------------*/
    static Object retrieveFieldValue(String dataType, String value) {
        if (value == null || value == 'null') {
            return null;
        }
        if(dataType == 'Integer') {
            return Integer.valueOf(value);
        }
        else if(dataType == 'Double') {
            return Double.valueOf(value);
        }
        else if(dataType == 'Date') {
            return Date.valueOf(value);
        }
        else if(dataType == 'DateTime') {
            return DateTime.valueOf(value);
        }
        else if(dataType == 'Boolean') {
            return (value == 'true' ? true : false);
        }
        else {
            return value;
        }
    }

}