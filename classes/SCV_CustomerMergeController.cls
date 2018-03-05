/*------------------------------------------------------------
Author:         Vincent Vuong
Company:        SaaSfocus
Description:    
Test Class:     TODO

History
<Date>      <Authors Name>      <Brief Description of Change>
12-Oct-17   Vincent Vuong       Created
------------------------------------------------------------*/
public with sharing class SCV_CustomerMergeController {

    //TODO: Move these Constants to custom labels
    private static final String CUSTOMER_MERGE_ERROR_TOO_FEW_ACCOUNTS = 'You must select minimum 2 records';
    private static final String CUSTOMER_MERGE_ERROR_TOO_MANY_ACCOUNTS = '';
    
    public List<Account> listMergeAccounts {get; set;}

    private static final String MASTER_KEY = '$MASTER$';
    
    public String strQueryFieldSet = '';
    
    public Map<String,Map<Id,List<Sobject>>> mapEntityNameTolistChildRecords1;
    
    /******Map to display fieldSets dynamically on vf page*****/
    public Map<String,List<Schema.FieldSetMember>> relatedEntityTofsMemberMap {get; set;}
         
    /*******************************************************************************************************
    * @description Search text entered by user.
    */
    public String searchText { get { return searchText; } set { searchText = value; } }
    
    /*******************************************************************************************************
    * @description List of contactWrapper objects for display in search results pane.
    */
    public List<CustomerWrapper> searchResults {get; private set;}
    
    /*******************************************************************************************************
    * @description List of contactWrapper objects for display in search results pane.
    */
    private Map<String, Account> selectedRecords;
    
    /*******************************************************************************************************
    * @description Number of selected records.
    */
    public Integer selectedRecordsCount {get; private set;} {this.selectedRecordsCount = 0;}
    
    /*******************************************************************************************************
    * @description Max number of Contacts returned by a query.
    */
    private final Integer SOSL_LIMIT = 100;
    
    /*******************************************************************************************************
    * @description The contact merge step user is in. (The process has multiple steps.)
    */
    public Integer step {get; private set;}
    
    /*******************************************************************************************************
    * @description Wraps a contact together with a checkbox, to allow contact selection.
    */
    public class CustomerWrapper {
        /*******************************************************************************************************
        * @description The contact.
        */
        public Account acc {get; set;}
        /*******************************************************************************************************
        * @description The checkbox.
        */
        public Boolean selected {get; set;}
        
        /*******************************************************************************************************
        * @description Constructor that initializes instance properties.
        * @c The contact to wrap.
        */ 
        public CustomerWrapper(Account c) {
            acc = c;
            selected = false;
        }
    }

    public Boolean personAccount {get; private set;}

    /*******************************************************************************************************
    * @description The rows to merge.
    */
    public List<FieldRow> fieldRows {get; private set;}
    
    /*******************************************************************************************************
    * @description The struct to save all the information belonging to each contact field, including values for 
    * all the contacts to merge.
    */
    public class FieldRow {
        /*******************************************************************************************************
        * @description Stores the field Label.
        */
        public String fieldLabel {get; private set;}
        /*******************************************************************************************************
        * @description Stores the field api name.
        */
        public String fieldName {get; private set;} 
        /*******************************************************************************************************
        * @description Property to tell whether UI must should a radio to select the field value.
        */
        public boolean showRadio {get; private set;}
        /*******************************************************************************************************
        * @description  List of values for each contact record.
        */
        public List<Cell> values {get; private set;}
        /*******************************************************************************************************
        * @description Selected record.
        */
        public String selectedValue {get; set;}
        /*******************************************************************************************************
        * @description The class style.
        */
        public String styleClass {get; private set;}
        
        /**********************************************************/
        public Map<String,List<Sobject>> mapEntityNameTolistChildRecords {get; set;}
        
        
        /*******************************************************************************************************
        * @description Constructor that initializes the values property.
        */
        public FieldRow() {
            this.values = new List<Cell>();
            this.mapEntityNameTolistChildRecords = new Map<String,List<Sobject>>();
            
        }
        
        /*******************************************************************************************************
        * @description Constructor that initializes the values property.
        * @param fieldName The name of the field.
        * @param fieldLabel The field label.
        * @param showRadio Wether a radio button should be displayed for the row.
        * @param styleClass The style class.
        */
        public FieldRow(String fieldName, String fieldLabel, boolean showRadio, String styleClass) {
            this();
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.showRadio = showRadio;
            this.styleClass = styleClass;
        }
    }
    
    /*******************************************************************************************************
    * @description The cell for a corresponding field row in the UI table.
    */
    public class Cell {
        /*******************************************************************************************************
        * @description Id of the record to which this value belongs.
        */
        public String objId {get; private set;} 
        /*******************************************************************************************************
        * @description The actual value.
        */
        public String value {get; private set;}
        
        public List<Sobject> listChildRecords {get; set;}
        
        /*******************************************************************************************************
        * @description Constructor that sets instance properties.
        * @param objectId The ID of the object whose field represented by the cell.
        * @param value The value of the field represented by the cell.
        */
        public Cell(String objectId, String value) {
            this.objId = objectId;
            this.value = value;
        }
        public Cell(String objectId, String value, List<Sobject> listSobjects){
            this.objId = objectId;
            this.value = value;
            listChildRecords = new List<Sobject>();
            this.listChildRecords = listSobjects;
        }
    }
    
    public Set<Id> mergeAccountIds;

    /*******************************************************************************************************
    * @description Constructor for StandardSetController to allow invocation from list views.
    * @param controller The default list controller for contact. It allows us to do pagination on the page.
    */
    public SCV_CustomerMergeController(ApexPages.StandardSetController controller){
        searchText='';
        searchResults = new List<CustomerWrapper>();
        selectedRecords = new Map<String, Account>();
        step = 1;
        fieldRows = new List<FieldRow>();
        relatedEntityTofsMemberMap = new Map<String,List<Schema.FieldSetMember>>();
        
        Set<Id> mergeIds = new Set<Id>();
        mergeAccountIds  = new Set<Id>();
        listMergeAccounts = new List<Account>();        
        mapEntityNameTolistChildRecords1 = new Map<String,Map<Id,List<Sobject>>>();

        //Get type from 
        personAccount = false;
        if (ApexPages.CurrentPage().getParameters().containsKey('person') && ApexPages.CurrentPage().getParameters().get('person') != '') {
            Integer person = Integer.valueOf(ApexPages.CurrentPage().getParameters().get('person'));
            if (person == 1) {
                personAccount = true;
            }
        }

        //if any selected records were passed the standard set controller show the merge page with those records
        for(Account c : (List<Account>)controller.getSelected()) {
            mergeIds.add(c.Id);
        }
        
        if(!mergeIds.isEmpty()) {
            loadMergeCandidates(mergeIds);
        }
        
        //otherwise, check for a search parameter for the SOSL query and use that
        else if(ApexPages.CurrentPage().getParameters().containsKey('srch')) {
            searchText = ApexPages.CurrentPage().getParameters().get('srch');
            search();
        }
        //otherwise, check for a mergeIds parameter, which should contain a comma separated list of Ids to merge
        else if(ApexPages.CurrentPage().getParameters().containsKey('mergeIds') && ApexPages.CurrentPage().getParameters().get('mergeIds') != '') {
            try {
                //attempt to deserialise the comma separated Ids into a list and then a set
                mergeIds = new Set<Id>((list<Id>)ApexPages.CurrentPage().getParameters().get('mergeIds').split(','));
                //if we got any ids, use to try and enter the merge selected records page
                if (mergeIds != null) {
                    loadMergeCandidates(mergeIds);
                }
            }
            catch(StringException e){
                ApexPages.addMessages(e);
            }
        }
    }
    

    /*******************************************************************************************************
    * @description Selects all the values of a certain record. Used by the "Select All" command link on the page.
    * @return void
    */
    public void selectDefaultRecord() {
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        //UTIL_Debug.debug('Selected Record: ' + recordId);
        if (recordId != null && selectedRecords.keySet().contains(recordId)) {
            for (FieldRow row : fieldRows) {
                if (row.showRadio) {
                    row.selectedValue = recordId; 
                }
            }
        }
    }
    
    /*******************************************************************************************************
    * @description Shows the next step of the wizard where user can see the diff of the records before merge.
    */
    public void nextStep() {
        Set<Id> mergeIds = new Set<Id>(); 
        for (CustomerWrapper c : searchResults) {
            if (c.selected) {
                mergeIds.add(c.acc.Id);
            }
        }
        loadMergeCandidates(mergeIds);
    }
    
    /*******************************************************************************************************
    * @description Shows the next step of the wizard where user can see the diff of the records before merge.
    */
    private void loadMergeCandidates(Set<Id> mergeCandidates) {
        
        // Check we have atleast 2 and not more than 3 records selected for merge. If not throw an error. 
        if (mergeCandidates.size() <=1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Contact_Merge_Error_Too_Few_Contacts'));
            return;
        }
        
        if (mergeCandidates.size() >3 ) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Contact_Merge_Error_Too_Many_Contacts'));
            //return;
        }
        
        selectedRecordsCount = mergeCandidates.size();
        
        Map<String, Schema.SObjectField> accountFields = Schema.SObjectType.Account.fields.getMap();
        Map<String, Schema.DescribeFieldResult> standardFieldMap = new Map<String, Schema.DescribeFieldResult>();
        Map<String, Schema.DescribeFieldResult> customFieldMap = new Map<String, Schema.DescribeFieldResult>();
        Map<String, Schema.DescribeFieldResult> accountFieldMap = new Map<String, Schema.DescribeFieldResult>();
        
        // Construct the query string
        String query = 'SELECT Id, ';
        for (String fieldName : accountFields.keySet()) {

            Schema.SobjectField f = accountFields.get(fieldName);
            Schema.DescribeFieldResult fResult = f.getDescribe();
            
            accountFieldMap.put(fieldName, fResult);

            // Ignore fields that have an identical API name as an npsp prefixed field
            // This is due to a bug in dynamic SOQL, quich causes querying for two real fields, 
            // e.g. npsp__foo__c and foo__c, to throw a duplicate field selected error.
            // Only select the NPSP namespaced field and ignore the same field without namespace
            if (!String.isBlank(SCV_Namespace.getNamespace()) && !fieldName.startsWith(SCV_Namespace.getNamespace()+'__') && 
                accountFields.containsKey(SCV_Namespace.StrTokenNSPrefix(fieldName))) {
                continue;
            }

            // Only include the fields which are updateable and accessible
            if (fResult.isUpdateable() && fResult.isAccessible() && !isHiddenField(fieldname)) {
                // If the field is type lookup, select the parent name  
                String relName = fResult.getRelationshipName();
                if (String.isBlank(relName)) {
                    query += (fieldName + ',');
                } else {
                    //find the Name field for the related object
                    String nameField = getRelatedObjNameField(fResult);

                    if (nameField!=null) {
                        query += (relName + '.' + nameField + ',');
                    }
                }
                // Collect the standard and custom fields separately for sorting
                if(fResult.isCustom()) {
                    customFieldMap.put(fieldName, fResult);
                } else {
                    standardFieldMap.put(fieldName, fResult);
                }
            }
        }

        // Adding some non-updateable system fields which we need to add to the record diff table.
        query +=  'Createdby.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate';
        // Finally completing the query by appending the table name and the filter clause
        query += ' FROM Account WHERE Id IN :mergeCandidates';
        System.debug('Query: ' + query);

        List<Account> accounts;
        try {
            accounts = Database.query(query); // Query the records
            // Ensure we got back the same number of records as expected. In case any record got deleted/moved since last search.
            if (accounts == null || accounts.size() != mergeCandidates.size()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Contact_Merge_Error_Query_Failed' + ' ' + 'Label.npe01.Contact_Merge_Error_please_retry'));
                return;
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Contact_Merge_Error_Contact_not_found' + ' Error: ' + e));
            return;
        }
        
        // Update the list of searched records with only the ones selected
        searchResults.clear();
        for (Account acc : accounts) {
            this.selectedRecords.put(acc.id, acc);
            listMergeAccounts.add(acc); 
            mergeAccountIds.add(acc.id);   
        }
        

        // Sort the standard fields list by name before creating the list of FieldRow for merge UI
        List<String> standardFieldList = new List<String>();
        standardFieldList.addAll(standardFieldMap.keySet());
        standardFieldList.sort();
        
        // Sort the custom fields list by name before creating the list of FieldRow for merge UI
        List<String> customFieldList = new List<String>();
        customFieldList.addAll(customFieldMap.keySet());
        customFieldList.sort();
        

        /***--- OUTPUT ROWS & COLUMNS ---***/
        //FIRST ROW - Add the first row of type header with account names as titles
        FieldRow temp = new FieldRow('', '', false, 'header');
        for (Sobject c : accounts) {
            Account acc = (Account) c;
            temp.values.add(new Cell(c.id, acc.name));  
        }
        fieldRows.add(temp);

        //SECOND ROW - Add second row to select the master record. Select the one which is last modified
        temp = new FieldRow(MASTER_KEY, 'Select Master Record', true, null);
        {
            DateTime lastModifiedDate;
            for (Sobject c: accounts) {
                temp.values.add(new Cell(c.id, null));
                if (lastModifiedDate == null || 
                    (lastModifiedDate != null && (DateTime)c.get('lastModifiedDate') > lastModifiedDate)) {
                    temp.selectedValue = c.id;
                    lastModifiedDate = (DateTime)c.get('lastModifiedDate');
                }   
            }
        }
        fieldRows.add(temp);
        

        //SYSTEM FIELDS//        
        // Add a dummy row to add a 'System Fields' header before the list of system fields
        fieldRows.add(new FieldRow('System Fields', 'System Fields', false, 'separator'));
        
        // Add created by and last modified by system fields to the list of FieldRow
        FieldRow ownerIdRow = new FieldRow('Owner.Name', 'Owner Name', false, null);
        FieldRow createdByRow = new FieldRow('CreatedById', 'Created By', false, null);
        FieldRow lastModifiedByRow = new FieldRow('LastModifiedById', 'Last Modified By', false, null);

        for (Sobject c: accounts) {
            SObject createdBy = c.getSObject('createdby');
            SObject modifiedBy = c.getSObject('lastModifiedBy');
            SObject ownerId = c.getSObject('owner');

            createdByRow.values.add(new Cell(c.id, (createdBy != null ? createdBy.get('name') : '') + ' ' + c.get('createdDate')));
            lastModifiedByRow.values.add(new Cell(c.id, (modifiedBy != null ? modifiedBy.get('name') : '') + ' ' + c.get('LastModifiedDate'))); 
            ownerIdRow.values.add(new Cell(c.id, (ownerId != null ? ownerId.get('name') : '') + ''));
        }
        fieldRows.add(createdByRow);
        fieldRows.add(lastModifiedByRow);
        fieldRows.add(ownerIdRow);

        //Owner Name
        //addFieldComparisonRows('ownerid', accountFieldMap.get('ownerid'), accounts);

        //Filter Fieldset types
        Set<String> mergeFieldSetTypes = new Set<String>();
        mergeFieldSetTypes.add(SCV_Constants.MERGE_FIELDSET_TYPE_COMMON);
        if (personAccount) {
            mergeFieldSetTypes.add(SCV_Constants.MERGE_FIELDSET_TYPE_PERSON);
        }
        else {
            mergeFieldSetTypes.add(SCV_Constants.MERGE_FIELDSET_TYPE_BUSINESS);
        }


        //TODO: Get FieldSets from Custom Metadata Types and display in correct order
        List<SCV_Merge_Field_Set__mdt> fieldsets = [SELECT Type__c, Object__c, 
                                                    Fieldset_Display_Name__c, Fieldset_API_Name__c, Read_Only__c
                                                    FROM SCV_Merge_Field_Set__mdt
                                                    WHERE Type__c IN :mergeFieldSetTypes
                                                    ORDER BY Display_Order__c ASC];
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

        //Map of
        Map<String, Map<String, Schema.DescribeFieldResult>> dfresultsMap = new Map<String, Map<String, Schema.DescribeFieldResult>>();
        for(SCV_Merge_Field_Set__mdt fs : fieldsets) {
            String objectName = fs.Object__c;
            if (dfresultsMap.get(objectName) == null) {
                Map<String, Schema.DescribeFieldResult> dfresults = SCV_Describe.getAllFieldsDescribe(objectName);
                dfresultsMap.put(objectName, dfresults);
            }
        }

        Set<String> dynamicQueryFieldsSet = new Set<String>();

        //Loop through fieldsets
        for (SCV_Merge_Field_Set__mdt fs : fieldsets) {

            String objectName = fs.Object__c;
            Map<String, Schema.FieldSet> fsMap = schemaMap.get(objectName).getDescribe().FieldSets.getMap();
            Map<String, Schema.DescribeFieldResult> dfresults = dfresultsMap.get(objectName);
            
            //Added to display details of each field set
            fieldRows.add(new FieldRow(fs.Fieldset_Display_Name__c, fs.Fieldset_Display_Name__c, false, 'separator'));

            if (fsMap.containsKey(fs.Fieldset_API_Name__c)) {
                List<Schema.FieldSetMember> fsMember = fsMap.get(fs.Fieldset_API_Name__c).getFields();
                for(Schema.FieldSetMember f : fsMember) {
                    String fLabel = f.getLabel();
                    String fApiName = f.getFieldPath();
                    
                    //Build query string
                    //strQueryFieldSet  = strQueryFieldSet + fApiName + ',';
                    
                    //TODO: Ignore AccountId field
                    if (!dynamicQueryFieldsSet.contains(fApiName)) {
                        dynamicQueryFieldsSet.add(fApiName);
                    }

                    Schema.SobjectField ff = accountFields.get(fApiName);
                    Schema.DescribeFieldResult fResult = ff.getDescribe();
                    
                    //Check field accessibility.
                    Boolean isDisplayRadio = false;

                    //Do not display radio if Fieldset is set to Read-Only
                    if (!fs.Read_Only__c) {
                        isDisplayRadio = fResult.isUpdateable() && fResult.isAccessible() && !isHiddenField(fApiName);
                    }
                    FieldRow fr = new FieldRow(fApiName, fLabel, isDisplayRadio, null);
                    
                    //Check for relationship field like owner etc.                    
                    String relName = fResult.getRelationshipName();
                    Boolean isRelationship = String.isNotBlank(relName) ? true : false;            
                    
                    //Feed data to cells for each row
                    Boolean isDifferent = false; // flag to indicate whether atleast one pair of field values is different across all contacts
                    Boolean isNull = true; // flag to indicate whether all the field values are null
                    Integer idx = 0;
        
                    List<String> values = new List<String>();
                    DateTime lastModifiedDate = null;
                    String prev;

                    //Feed data to cells for each row
                    for (Account c : accounts) {
                        //Auto-select first record
                        fr.selectedValue = c.Id;

                        if (isRelationship) {
                            SObject fName = c.getSObject(relName);
                            fr.values.add(new Cell(c.id, ''+(fName != null ? fName.get('name') : '' )));
                        }
                        else {
                            fr.values.add(new Cell(c.id, ''+c.get(fApiName) ));
                        }

                        isNull &= (c.get(fApiName) == null); // Check if the value is null
                        
                        if (idx == 0) {
                            prev = String.valueOf(c.get(fApiName));
                        }
                        if (idx > 0 && !isNull) {
                            // Check if atleast one of the values is different. If yes then update the isDifferent flag
                            String current = String.valueOf(c.get(fApiName));
                            if ((prev != null && !prev.equals(current)) || 
                                (current != null && !current.equals(prev))) {
                                isDifferent = true;
                            }
                            prev = current;
                        }

                        // Select the default value for the field. A non-null value on the latest modified record 
                        if (c.get(fApiName) != null && (lastModifiedDate == null || 
                            (lastModifiedDate != null && (DateTime)c.get('lastModifiedDate') > lastModifiedDate))) {
                            fr.selectedValue = c.Id;
                            lastModifiedDate = (DateTime)c.get('lastModifiedDate');
                        }

                        idx++;
                    }
                    
                    if (!isNull) {
                        fieldRows.add(fr);
                    }
                } 
            }
        }
        
        //Create a list based on a set
        List<String> dynamicQueryFieldsList = new List<String>(dynamicQueryFieldsSet);
        strQueryFieldSet = String.join(dynamicQueryFieldsList, ',');
        //strQueryFieldSet = strQueryFieldSet.removeEnd(',');

        //THIRD ROW -- Show key fields to assist identifying Master record:
        //Source system
        //External IDs and Customer Number (if known)
        //Introducer – Primary/Secondary

        //fieldRows.add(new FieldRow('EXTERNAL IDs', 'EXTERNAL IDs', false, 'separator'));
        //addFieldComparisonRows(fieldName, standardFieldMap.get(fieldName), accounts);

        //Record Ownership (Default to Survivor)


        //STANDARD FIELDS//
        // Add a dummy row to add a 'Standard Fields' header before the list of standard fields
        //fieldRows.add(new FieldRow('Standard Fields', 'Standard Fields', false, 'separator'));
        // Add all standard fields to the list of FieldRow in sorted manner
        //for (String fieldName: standardFieldList) {
        //    addFieldComparisonRows(fieldName, standardFieldMap.get(fieldName), accounts);
        //}

        
        //CUSTOM FIELDS//
        // Add a dummy row to add a 'Custom Fields' header before the list of custom fields
        //fieldRows.add(new FieldRow('Custom Fields', 'Custom Fields', false, 'separator'));
        // Add all custom fields to the list of FieldRow in sorted manner
        //for (String fieldName: customFieldList) {
            //addFieldComparisonRows(fieldName, customFieldMap.get(fieldName), accounts);
        //}
        
        
        /******Map to keep related entity and their field set members query*****/     
        Map<String,String> objectApiNameToQueryMap  = new Map<String,String>(); 
        Map<String, Boolean> partyMergeCustomSetting = new Map<String, Boolean>();
        Map<String,String> mapApiNameToObjectName = new Map<String,String>();
        
        //Loop through all related entities field sets
        //Build ObjectVsQuery map        
        for (SCV_Merge_Related_Entity_Field_Set__mdt fs : getRelatedEntitiesFieldSets()) {
            //Ignore empty fieldset name
            if (fs.Fieldset_API_Name__c == null) {
                continue;
            }


            String strRelatedEntityQuery = '';
            Set<String> fieldApiNameSet = new Set<String>();
            
            String objectName = fs.Object_Api_Names__c;
            Map<String, Schema.FieldSet> fsMap = schemaMap.get(objectName).getDescribe().FieldSets.getMap();
            List<Schema.FieldSetMember> fsMember = fsMap.get(fs.Fieldset_API_Name__c).getFields();
            
            relatedEntityTofsMemberMap.put(fs.MasterLabel,fsMember);
            
            for(Schema.FieldSetMember f : fsMember) {
                String fLabel = f.getLabel();
                String fApiName = f.getFieldPath();
                fieldApiNameSet.add(fApiName);            
            }
            
            List<String> fieldApiNameList = new List<String>(fieldApiNameSet);
            strRelatedEntityQuery = String.join(fieldApiNameList,',');
            objectApiNameToQueryMap.put(objectName,strRelatedEntityQuery);
            
            //Added to remove party merge setting usage
            partyMergeCustomSetting.put((fs.Object_Api_Names__c + '-' + fs.Lookup_Field_Name__c).toLowerCase(), fs.isPersonContactId__c);
            mapApiNameToObjectName.put(fs.Object_API_Names__c.toLowerCase(),fs.MasterLabel);

        }
        System.debug('===objectApiNameToQueryMap=== '+objectApiNameToQueryMap);
        
        
        //Bind data related to the child objects
        //get child relationship based on custom settings
        
        for(Party_Merge__c childCustomSetting: Party_Merge__c.getAll().Values()){
          if(childCustomSetting.Active__c) {                  
              //partyMergeCustomSetting.put((childCustomSetting.Object_API_Name__c + '-' + childCustomSetting.Lookup_Field_Name__c).toLowerCase(), childCustomSetting.isPersonContactId__c);
              //mapApiNameToObjectName.put(childCustomSetting.Object_API_Name__c.toLowerCase(),childCustomSetting.Name);
          }
        }

        //build query based on all child relationship object in partyMergeCustomSetting
        List<Schema.ChildRelationship> relationShips = new List<Schema.ChildRelationship>();

        String queryStr = 'SELECT Id,'+strQueryFieldSet;
        for(Schema.ChildRelationship childRelation: Account.sObjectType.getDescribe().getChildRelationships()){
          System.Debug('====childRelation=== '+childRelation);              
          if(childRelation.getRelationshipName() != null && partyMergeCustomSetting.containsKey((childRelation.getChildSObject() + '-' + childRelation.getField()).toLowerCase()) 
                              && !childRelation.getRelationshipName().contains('__pr')
                              && objectApiNameToQueryMap.containsKey(toStr(childRelation.getChildSObject()))){
              
              String queryChildObject = '';
              queryChildObject = objectApiNameToQueryMap.get(toStr(childRelation.getChildSObject()));
              if(String.isNotBlank(queryChildObject)){
                  queryStr +=',(SELECT ' + queryChildObject + ' FROM '+ childRelation.getRelationshipName() + ')';                 
                  relationShips.add(childRelation);
              }
          }
        }
        queryStr += ' FROM Account WHERE ID IN: mergeAccountIds ';
        System.Debug('====queryStr=== '+queryStr);
        
        
        for (Account existingAccount : Database.Query(queryStr)) {
            //System.debug('===existingAccount=== '+existingAccount.getSobjects('contacts'));

            for(Schema.ChildRelationship childRelation: relationShips){
                  //Check if it's defined in custom setting.
                  if(childRelation != NULL && mapApiNameToObjectName.containsKey(toStr(childRelation.getChildSObject()).toLowerCase())){
                      
                      String entityNameToDisplay = mapApiNameToObjectName.get(toStr(childRelation.getChildSObject()).toLowerCase());
                      String strRelName = childRelation.getRelationshipName();
                      
                      if(!mapEntityNameTolistChildRecords1.containsKey(entityNameToDisplay)){
                          mapEntityNameTolistChildRecords1.put(entityNameToDisplay,new Map<Id,List<Sobject>>());
                      }
                      if(strRelName != NULL && existingAccount.getSobjects(strRelName) != NULL){
                          mapEntityNameTolistChildRecords1.get(entityNameToDisplay).put(existingAccount.id,new List<Sobject>());
                          mapEntityNameTolistChildRecords1.get(entityNameToDisplay).get(existingAccount.id).addAll(existingAccount.getSobjects(strRelName));
                      }
                  }
            } 
        }
        System.debug('==mapEntityNameTolistChildRecords1==== '+mapEntityNameTolistChildRecords1);
        
        //Build the row for each related entity.  
        for(String strEntityName :mapEntityNameTolistChildRecords1.keyset()){
            System.debug('====strEntityName==== '+strEntityName);
            FieldRow entityRow = new FieldRow(strEntityName,strEntityName, false, 'relEntity');            
            fieldRows.add(entityRow);
            
            FieldRow entityDataRow = new FieldRow(strEntityName,strEntityName,false,'relEntityData');
            Integer totalChildRecords = 0;
            for(String accId :mapEntityNameTolistChildRecords1.get(strEntityName).keyset()){
                if(mapEntityNameTolistChildRecords1.get(strEntityName).get(accId).size() > 0){                    
                    entityDataRow.values.add(new Cell(accId,null,mapEntityNameTolistChildRecords1.get(strEntityName).get(accId)));
                }   
                totalChildRecords += mapEntityNameTolistChildRecords1.get(strEntityName).get(accId).size();                    
            } 
            if(totalChildRecords != 0)  
            fieldRows.add(entityDataRow);              
        }
        
        /*SHOW KEY CHILD OBJECTS
        //FieldRow contactsRow = new FieldRow('CONTACTS', 'CONTACTS', false, 'relEntity');

        //fieldRows.add(new FieldRow('APPLICATIONS', 'APPLICATIONS', false, 'separator'));

        fieldRows.add(new FieldRow('OPPORTUNITIES', 'OPPORTUNITIES', false, 'separator'));

        fieldRows.add(new FieldRow('PAF', 'PAF', false, 'separator'));

        fieldRows.add(new FieldRow('MORTGAGES', 'MORTGAGES', false, 'separator'));

        fieldRows.add(new FieldRow('CONTRACTS', 'CONTRACTS', false, 'separator'));
        */
        
        // If everything looks good go to "choose winning contact" step
        this.step = 3;
    }
    
     private List<SCV_Merge_Related_Entity_Field_Set__mdt> getRelatedEntitiesFieldSets(){
       return [SELECT DeveloperName,MasterLabel, Fieldset_API_Name__c,Lookup_Field_Name__c ,isPersonContactId__c,Fieldset_Display_Name__c,Object_Api_Names__c 
                FROM SCV_Merge_Related_Entity_Field_Set__mdt];
    }
            
    private static String toStr (Object obj){
        return String.ValueOf(obj);
    }
    
    /*******************************************************************************************************
    * @description Returns a referenced object's name field.
    * @param controller The default list controller for contact. It allows us to do pagination on the page.
    * @return string The name of the name field, or null if we couldn't find one.
    */
    private string getRelatedObjNameField(Schema.DescribeFieldResult fieldDesc) {
        string nameField = 'Name';
        Map<String, Schema.SObjectField> mapRelatedObjectFields = fieldDesc.getReferenceTo()[0].getDescribe().fields.getMap();

        //if Name isn't the correct name field, find it
        if (!mapRelatedObjectFields.containsKey(nameField)) {
            nameField = null;
            for (String relatedFieldName : mapRelatedObjectFields.keySet()) {
                if (mapRelatedObjectFields.get(relatedFieldName).getDescribe().isNameField())
                    return relatedFieldName;
            }
        }
        return nameField;
    }
    
    /*******************************************************************************************************
    * @description Adds field information and field values to the list of field rows.
    */
    private void addFieldComparisonRows(String fieldName, Schema.DescribeFieldResult fieldDesc, List<SObject> objs) {
        // Create a new FieldRow item
        FieldRow row = new FieldRow();
        row.fieldName = fieldName;
        
        // For standrd lookup type fields, use the relationship name as the field label
        if (!fieldDesc.isCustom() && fieldDesc.getRelationshipName() != null) {
            row.fieldLabel = fieldDesc.getRelationshipName();
        } else {
            row.fieldLabel = fieldDesc.getLabel();
        }
        
        row.values = new List<Cell>();
        
        boolean isDifferent = false; // flag to indicate whether atleast one pair of field values is different across all contacts
        boolean isNull = true; // flag to indicate whether all the field values are null
        Integer idx = 0;
        
        List<String> values = new List<String>();
        DateTime lastModifiedDate = null;
        String prev;
        
        // Iterate over all contacts to find the field values and add them to row values
        for (SObject c : objs) {
            // For lookup fields set the name as the values
            if (fieldDesc.getRelationshipName() != null) {
                Sobject obj = c.getSObject(fieldDesc.getRelationshipName());
                if (obj != null) {
                    values.add(String.valueOf(obj.get(getRelatedObjNameField(fieldDesc))));
                } else {
                    values.add(null);
                }   
            } else {
                values.add(String.valueOf(c.get(fieldName)));
            }
            
            isNull &= (c.get(fieldName) == null); // Check if the value is null
            
            if (idx == 0) {
                prev = String.valueOf(c.get(fieldName));
            }
            if (idx > 0 && !isNull) {
                // Check if atleast one of the values is different. If yes then update the isDifferent flag
                String current = String.valueOf(c.get(fieldName));
                if ((prev != null && !prev.equals(current)) || 
                    (current != null && !current.equals(prev))) {
                    isDifferent = true;
                }
                prev = current;
            }
            
            // Select the default value for the field. A non-null value on the latest modified record 
            if (c.get(fieldName) != null && (lastModifiedDate == null || 
                (lastModifiedDate != null && (DateTime)c.get('lastModifiedDate') > lastModifiedDate))) {
                row.selectedValue = c.id;
                lastModifiedDate = (DateTime)c.get('lastModifiedDate');
            }
            
            idx++;
        }

        // If atleast one record has a non-null field value, then add it to the list of fieldRows.
        if (!isNull) {
            for (Integer i=0; i < values.size(); i++) {
                String val = values[i];
                if (val != null && val.length() > 255) {
                    val = val.substring(0, 251) + ' ...';
                }
                row.values.add(new Cell(objs[i].id, val));
            }
            // Show the select radio only if the field values are different. 
            // Dont let user choose the account as you dont want users to assign a differnt account in One to One case.
            row.showRadio = (isDifferent && !fieldName.equalsIgnoreCase('accountId') && !isReadOnlyField(fieldName));
            fieldRows.add(row);
        }
    }
    
    /*******************************************************************************************************
    * @description returns whether the field should be treated as an NPSP read only field, typically one
    * of our rollup fields that get automatically populated by rollups, and users should not direclty modify.
    * @return boolean true if should be treated as readonly, false if not.
    */
    private boolean isReadOnlyField(string strField) {
        // we have to maintain our own set of readonly fields, because 
        // RLLP_OppRollup_UTIL.ContactFields doesn't include them all!
        list<string> listStrField = new list<string>{
            'Customer_Id__c', 
            'collect__External_ID__c'
        };

        for (string strF : listStrField) {
           if (strField.equalsIgnoreCase(strF))
               return true;
        }
        return false;
    }
    
    
    /*******************************************************************************************************
    * @description returns whether the field should be treated as an NPSP hidden field, typically one
    * of our deprecated or system fields
    * @return boolean true if should be treated as hidden, false if not.
    */
    private boolean isHiddenField(string strField) {
        list<string> listStrField = new list<string>{
            'clcommon__Legal_Entity_Type__pc',
            'CommunityUser__pc',
            'CRM_Mtg_Mortgage_BDM__pc',
            'geopointe__Geocode__pc',
            'ints__Coborrower__pc',
            'loan__Branch__pc',
            ''
        };

        for (string strF : listStrField) {
           if (strField.equalsIgnoreCase(strF))
               return true;
        }
        return false;
    }
    
    /*******************************************************************************************************
    * @description Searches for contacts.
    * @return PageReference The page that it redirects to. Same page user is in.
    */
    public PageReference search() {
        Try {           
            if(searchText != null && searchText.length()>0){
                step = 2;
                this.searchResults = wrapSOSLResults(mySOSL());
            }
        } catch (exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));         
        }
        return null;
    }
    
    /*******************************************************************************************************
    * @description Runs SOSL query to find contacts according to the search text entered by the user.
    * @return PageReference The page that it redirects to. Same page user is in.
    */
    public List<List<SObject>> mySOSL() {
        searchResults.clear();    
        
        //build the SOSL query and execute - NOTE: * wildcard will only have effect at the middle or end of the search term
        String searchquery = 'FIND \'' + String.escapeSingleQuotes(searchText) + 
            '*\' IN ALL FIELDS RETURNING Account(';
            
        string strComma = '';
        for (string strField : listStrAccountField) {
            searchquery += strComma + strField;
            strComma = ',';
        }
        
        searchquery += ' ORDER BY Name LIMIT ' + SOSL_LIMIT + ')';
        //SCV_Debug.debug('Search Query: ' + searchquery);
        
        return search.query(searchquery);
        //List<List<SObject>> searchList = new List<List<SObject>>();
    }
    
    /*******************************************************************************************************
    * @description The list of account field names that are used in search and displayed in Found Accounts.
    */
    private list<string> listStrAccountField {
        get {
            if (listStrAccountField == null) {
                listStrAccountField = SCV_Describe.listStrFromFieldSet('Account', SCV_Namespace.StrTokenNSPrefix('SCV_AccountMergeFound'));
                set<string> setStr = new set<string>(listStrAccountField);
                // now add additional fields we know we need
                setStr.add('Id');
                setStr.add('Name');
                listStrAccountField.clear();
                listStrAccountField.addAll(setStr);
            }
            return listStrAccountField;
        }
        set;
    }
    
    /*******************************************************************************************************
    * @description Wraps the SOSL results.
    * @param mySearchList The list of SObjects to wrap. It contains a list per Sobject type.
    * @return List<ContactWrapper> Those records from the passed parameter that are of type Account are returned
    * in this list, inside wrappers.
    */
    public List<CustomerWrapper> wrapSOSLResults(List<List<SObject>> mySearchList){
        
        List<CustomerWrapper> res = new List<CustomerWrapper>();
        //loop through the accounts putting them in an array of wrappers
        if(mySearchList.size()>0){
            for (List<SObject> returnedObjects : mySearchList) {
                //SCV_Debug.debug('List size' + returnedObjects.size());
                for (SObject returnedObject : returnedObjects){
                    //if the returned object is a account, add it to the Account list
                    if(returnedObject.getSObjectType() == Account.sObjectType){
                        CustomerWrapper thisResult = new CustomerWrapper((Account) returnedObject);   
                        //SCV_Debug.debug('Account Id: ' + returnedObject.id);
                        //SCV_Debug.debug('Account: ' + returnedObject);         
                        res.add(thisResult);   
                    }
                }
            }
        }
        //SCV_Debug.debug('Search Results Map Size: ' + res.size());
        return res;       
    }
    
    /*******************************************************************************************************
    * @description Merges the winner and losers.
    * @return PageReference The page that it redirects to. Same page user is in.
    */
    public PageReference mergeAccounts() {
        SObject master;

        // Find the master record based the selected value of the Master FieldRow
        for (FieldRow row : fieldRows) {
            if (row.showRadio && row.fieldName.equals(MASTER_KEY)) {
                //TODO: Deep clone master record??

                master = new Account(Id = row.selectedValue);

                System.debug('MASTER_KEY = ' + row.selectedValue);
                if (personAccount) {
                    master.put('RecordTypeId', SCV_Constants.RECORDTYPE_ID_PERSON_ACCOUNT);
                }
                else {
                    master.put('RecordTypeId', SCV_Constants.RECORDTYPE_ID_BUSINESS_ACCOUNT);
                }
                break;
            }
        }
        System.debug('Master Account = ' + master);

        if (master != null) {
            // Update the field values of master record based on the selected value for each field.
            for (FieldRow row : fieldRows) {
                if (row.showRadio != null && row.selectedValue != null && master.Id != null &&
                    row.showRadio && !row.fieldName.equals(MASTER_KEY) && 
                    row.selectedValue != master.Id) 
                {
                    SObject selectedRecord = this.selectedRecords.get(row.selectedValue);
                    System.debug('Assigning field: ' + row.fieldName);
                    
                    // Sobject.put is not happy when sobject.get returns null. It throws an exception System.SObjectException: Illegal assignment from Object to String.
                    // But instead when you pass a null directly to put, it works fine. And hence, this if statement.
                    if (selectedRecord.get(row.fieldName) == null) {
                        master.put(row.fieldName, null);
                    } else {
                        Object val = selectedRecord.get(row.fieldName);
                        master.put(row.fieldName, val);
                        //System.debug('Setting value: ' + val);                        
                        //System.debug('Set value: ' + master.get(row.fieldName));
                    }
                }
            }
            
            // Group all the loosing records separately.
            List<Account> losers = new List<Account>();
            for (Account acc : this.selectedRecords.values()) {
                if (acc.Id != master.Id) {
                    losers.add(acc);
                }   
            }
        
            // before proceeding further first lock the records for change
            List<Account> allAccounts = new List<Account>();
            allAccounts.add((Account)master);
            allAccounts.addAll(losers);
            List<Account> lock = [SELECT Id FROM Account WHERE Id IN :allAccounts FOR UPDATE];
            
            if (lock == null || lock.size() != allAccounts.size()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Contact_Merge_Error_Lock_failed'  + ' ' + 'Contact_Merge_Error_please_retry') );
                return null;
            }


            System.SavePoint sp = Database.setSavepoint();
            try {
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                
                /*Database.SaveResult sr = Database.update(master, dml);
                
                if (!sr.isSuccess()) {
                    string strErr = 'Contact_Merge_Error_Merge_Failed' + ' Error: ';
                    for (Database.Error err : sr.getErrors()) {
                        strErr += err.getMessage() + '\n';
                    }
                    Database.rollback(sp);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, strErr));
                    return null;
                }*/

                
                //TODO
                //SCV_CustomerMerge.mergeAccounts((Account)master, losers);

                Boolean reparent = true;
                Account mergedAccount = SCV_Utility.mergeAccounts((Account)master, losers, personAccount, reparent);

                // Update the master with the selected values
                //return new PageReference('/' + master.id);
                return new PageReference('/' + mergedAccount.Id);

            } catch (Exception ex) {
                Database.rollback(sp);
                //TODO: Log errors
                Error_Log__c error = new Error_Log__c();
                error.Error_Message__c = ex.getMessage();
                error.Error_Stacktrace__c = ex.getStackTraceString();
                error.Line__c = ex.getLineNumber();
                error.Type__c = ex.getTypeName();
                insert error;

                //ERR_Handler.processError(e, ERR_Handler_API.Context.CON);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'label.npe01.Contact_Merge_Error_Merge_Failed' + ' Error: ' + ex));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'label.npe01.Contact_Merge_Error_No_Master'));
        }
        
        return null;
    }
}