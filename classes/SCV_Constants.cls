/*------------------------------------------------------------
Author:         Vincent Vuong
Company:        SaaSfocus
Description:    Global class to hold all constants
Test Class:     TODO

History
<Date>      <Authors Name>      <Brief Description of Change>
16-Nov-17   Vincent Vuong       Created
------------------------------------------------------------*/
public without sharing class SCV_Constants {

	//Record Type IDs
	public static final Id RECORDTYPE_ID_PERSON_ACCOUNT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	//public static final Id RECORDTYPE_ID_PERSON_ACCOUNT_CL = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account(CL)').getRecordTypeId();

	public static final Id RECORDTYPE_ID_BUSINESS_ACCOUNT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
	//public static final Id RECORDTYPE_ID_BUSINESS_ACCOUNT_CL = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account(CL)').getRecordTypeId();


	//Max. digits for CIS generation
    public static final Integer MAX_CUSTOMER_ID_DIGIT 	= 8;
    public static final String CUSTOMER_ID_PREFIX 		= '9';

    //Constants for Customer Merge
    public static final String CUSTOMER_MERGE_ERROR_TOO_FEW_ACCOUNTS = 'You must select minimum 2 records';
    private static final String CUSTOMER_MERGE_ERROR_TOO_MANY_ACCOUNTS = '';


    //Merge Fieldset Types
    public static final String MERGE_FIELDSET_TYPE_COMMON  		= 'Common';
    public static final String MERGE_FIELDSET_TYPE_PERSON  		= 'Person';
    public static final String MERGE_FIELDSET_TYPE_BUSINESS  	= 'Business';
    
}