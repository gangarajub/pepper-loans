/**
* @author Salesforce.org
* @date 2017
* @group Utilities
* @description SOQL Builder
*/
public with sharing class SCV_Query {
    /** @description Exception raised by the Query builder */
    public class SCV_QueryException extends Exception {} 

    /** @description Error message when no SELECT field is provided */
    private static final String SELECT_FIELDS_REQUIRED = 'At least one SELECT field is required.';
    /** @description Error message when provided SELECT field is empty or null */
    private static final String SELECT_FIELD_CANNOT_BE_EMPTY = 'SELECT field cannot be empty or null.';
    /** @description Error message when FROM value is not provided */
    private static final String FROM_ENTITY_REQUIRED = 'The FROM value is required.';
    /** @description Error message when provided WHERE clause is empty or null */
    private static final String WHERE_CLAUSE_CANNOT_BE_EMPTY = 'WHERE clause cannot be empty or null.';

    /** @description Operator AND used in the WHERE clause */
    private static final String AND_OPERATOR = ' AND ';

    /** @description Contains field names used in the SOQL' SELECT segment */
    private String[] selectFields = new String[0];
    /** @description An Sobject name or a relationship name used in the SOQL's FROM segment */
    private String entity = null;
    /** @description WHERE clauses used in the SOQL's WHERE segment */ 
    private String[] whereClauses = new String[0];
    /** @description Indicates if toLabel() should be used on the Salutation field  */ 
    private Boolean isToLabelSalutation = false;

    /*********************************************************************************************************
    * @description The constructor
    */
    public SCV_Query() {
    }

    /*********************************************************************************************************
    * @description Registers SELECT fields
    * @param fieldNames Set of field names
    * @return SCV_Query The instance of the Query builder
    */
    public SCV_Query withSelectFields(Set<String> fieldNames) {
        return withSelectFields(new List<String>(fieldNames));     
    } 
    
    /*********************************************************************************************************
    * @description Registers SELECT fields
    * @param fieldNames List of field names
    * @return SCV_Query The instance of the Query builder
    */
    public SCV_Query withSelectFields(String[] fieldNames) {
        selectFields.addAll(fieldNames);            
        return this;
    }  

    /*********************************************************************************************************
    * @description Indicates to use toLabel() on the Salutation field
    * @return SCV_Query The instance of the Query builder
    */
    public SCV_Query withToLabelSalutation() {
        isToLabelSalutation = true;
        return this;
    }     
    
    /*********************************************************************************************************
    * @description Registers the FROM Sobject
    * @param sobjectType Type of the Sobject
    * @return SCV_Query The instance of the Query builder
    */
    public SCV_Query withFrom(Schema.SObjectType sobjectType) {           
        return withFrom(sobjectType.getDescribe().getName());
    }
    
    /*********************************************************************************************************
    * @description Registers FROM entity
    * @param entity An Sobject name or a relationship name
    * @return SCV_Query The instance of the Query builder
    */
    public SCV_Query withFrom(String entity) {
        this.entity = entity;            
        return this;
    }        
    
    /*********************************************************************************************************
    * @description Registers a clause to be used in the SOQL's WHERE clause
    * @param whereClause A WHERE clause
    * @return SCV_Query The instance of the Query builder
    */
    public SCV_Query withWhere(String whereClause) {
        return withWhere(new String[]{ whereClause });  
    }
    
    /*********************************************************************************************************
    * @description Registers WHERE clauses
    * @param whereClauses A list of WHERE clauses
    * @return SCV_Query The instance of the Query builder
    */
    public SCV_Query withWhere(String[] whereClauses) {
        if (whereClauses != null && !whereClauses.isEmpty()) {
            this.whereClauses.addAll(whereClauses);    
        }
        return this;
    } 
    
    /*********************************************************************************************************
    * @description Validates and builds a SOQL 
    * @return String The SOQL
    */
    public String build() {
        if (String.isBlank(entity)) {
            throw new SCV_QueryException(FROM_ENTITY_REQUIRED);
        }

        String[] uniqueSelectFields = buildSelectFields();
        if (uniqueSelectFields.isEmpty()) {
            throw new SCV_QueryException(SELECT_FIELDS_REQUIRED);
        }

        return String.format(
            'SELECT {0} FROM {1} {2}',
            new String[] { String.join(uniqueSelectFields, ', '), entity, buildWhereClause() }
        ).trim();
    }

    /*********************************************************************************************************
    * @description Validates SELECT fields and removes duplicates
    * @return String[] List of field names.
    */
    private String[] buildSelectFields() {
        String[] fields = new String[0];

        Set<String> collectedFields = new Set<String>();
        for (String fieldName : selectFields) {
            if (String.isBlank(fieldName)) {
                throw new SCV_QueryException(SELECT_FIELD_CANNOT_BE_EMPTY);
            } 
            
            if (collectedFields.contains(fieldName.toLowerCase())) {
                continue;
            }

            fields.add(buildField(fieldName));
            collectedFields.add(fieldName.toLowerCase());
        }

        return fields;
    }

    /*********************************************************************************************************
    * @description Prepares a field to be used in the SOQL's SELECT segment
    * @param fieldName A field name
    * @return String The field name
    */
    private String buildField(String fieldName) {
        if (isToLabelSalutation && fieldName.equalsIgnoreCase('Salutation')) {
            return String.format('toLabel({0})', new String[] { fieldName });
        }

        return fieldName;
    }           

    /*********************************************************************************************************
    * @description Validates and builds the WHERE clause
    * @return String The WHERE clause
    */
    private String buildWhereClause() {
        if (whereClauses.isEmpty()) {
            return '';
        }
        
        String soqlWhere = ''; 
        
        for (String clause : whereClauses) {
            if (String.isBlank(clause)) {
                throw new SCV_QueryException(WHERE_CLAUSE_CANNOT_BE_EMPTY);
            }

            soqlWhere += String.isBlank(soqlWhere) ? '' : AND_OPERATOR;
            soqlWhere += clause;
        }
        
        return String.isBlank(soqlWhere) ? '' : 'WHERE ' + soqlWhere;
    }  
}