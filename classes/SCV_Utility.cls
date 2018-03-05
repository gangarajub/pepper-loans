/*------------------------------------------------------------
Author:         Vincent Vuong
Company:        SaaSfocus
Description:    
Test Class:     TODO

History
<Date>      <Authors Name>      <Brief Description of Change>
26-Oct-17   Vincent Vuong       Created
------------------------------------------------------------*/
public with sharing class SCV_Utility {

    //Translate Hexa character to numeric
    public static Map<String, String> hexCharMaps = new Map<String, String>{'a'=>'1','b'=>'2','c'=>'3','d'=>'4','e'=>'5','f'=>'6'};


    /*------------------------------------------------------------
    Description:    Return string in proper case
    Inputs:         String in mixed cases eg.
    Outputs:        String in Proper Case eg. Proper Case
    History
    <Date>      <Authors Name>      <Brief Description of Change>
    26-Oct-17   Vincent Vuong       Created
    ------------------------------------------------------------*/
    public static String toProperCase(String value) {
        // Normalize - Convert to lowercase
        value = value.toLowerCase();
        // Hold each word
        List<String> pieces = new List<String>();
        // Split
        for(String s : value.split(' ')) {
            // Capitalize each piece
            s = s.capitalize();
            // Add to pieces
            pieces.add(s);
        }

        // Join
        return String.join(pieces, ' ');
    }
    
    
    //Get Active Duplicate Rules in the system
    public static Map<String,DuplicateRule> getActiveDuplicateRules(){    
        return new Map<String,DuplicateRule>([SELECT id,isActive,masterLabel FROM DuplicateRule WHERE isActive=true]);
    }


    /*------------------------------------------------------------
    Description:    Method to return unique 8-10 digits customer number
    Inputs:         String to use for seeding such as 18-digits Salesforce Account ID
    Outputs:        8-10 digits unique customer number using Luhn's algorithm

    TODO: Test bulk number generation with full data to ensure unique number all the time!

        Set<String> numbers = new Set<String>();
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for(Account acc : accounts) {
            numbers.add(SCV_Utility.generateCustomerNumber(acc.Id));
            //System.debug(SCV_Utility.generateCustomerNumber(acc.Id));
        }
        System.debug('Expected = ' + accounts.size() + ', Actual = ' + numbers.size());

    History
    <Date>      <Authors Name>      <Brief Description of Change>
    01-Nov-17   Vincent Vuong       Created
    ------------------------------------------------------------*/
    public static String generateCustomerNumber(String seed) {

        //Generate unique has string based on current timestamp if not set
        String hashString = seed;
        if (hashString == null) {
            hashString = String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        }

        //Create MD5 digest string
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        //This will generate 32-chars hexadecimal digest string
        String hexDigest = EncodingUtil.convertToHex(hash);
        //System.debug('##########' + hexDigest);

        //Go through generated string and converted alpha-characters to numeric digits eg. a -> 1 
        String hexDigestTruncate = hexDigest.left(SCV_Constants.MAX_CUSTOMER_ID_DIGIT);
        Integer hexDigestLen = hexDigestTruncate.length();
        
        //Add customer ID prefix
        String customerNumber = SCV_Constants.CUSTOMER_ID_PREFIX;
        for(Integer i=0; i<hexDigestLen; i++){
            String ch = hexDigestTruncate.substring(i,i+1);
            if (SCV_Utility.hexCharMaps.get(ch) != null) {
                customerNumber += SCV_Utility.hexCharMaps.get(ch);
            }
            else {
                customerNumber += ch;
            }
        }

        //Generate check digit using Luhn's Algorithm checksum digit
        customerNumber += SCV_Utility.generateLuhnCheckDigit(customerNumber);
        return customerNumber;
    }


    /*------------------------------------------------------------
    Description:    Method to merge person or business accounts

    Inputs:         winner - This is the winning Account to clone from
                    losers - List of losing Accounts to reparent and hide
    Outputs:        Master Account
    History
    <Date>      <Authors Name>      <Brief Description of Change>
    01-Nov-17   Vincent Vuong       Created
    ------------------------------------------------------------*/
    public static Account mergeAccounts(Account winner, List<Account> losers, Boolean isPersonAccount, Boolean reparent) {

        //Create new Account for new master
        Id recordTypeId = (isPersonAccount) ? SCV_Constants.RECORDTYPE_ID_PERSON_ACCOUNT : SCV_Constants.RECORDTYPE_ID_BUSINESS_ACCOUNT;
        Account master = new Account( RecordTypeId = recordTypeId );
        Savepoint sp = Database.SetSavePoint();
        
        List<Sobject> chunkUpdate = new List<Sobject>();

        try {
            if (winner != null) {

                //master = winner;
                //Add winner to losers list
                losers.add(winner);

                //Query key fields from winning Account
                if (isPersonAccount) {
                    winner = [SELECT Name, FirstName, LastName, PersonBirthDate FROM Account WHERE Id = :winner.Id LIMIT 1];

                    master.FirstName = winner.FirstName;
                    master.LastName = winner.LastName;
                    master.PersonBirthDate = winner.PersonBirthDate;
                }
                else {
                    winner = [SELECT Name FROM Account WHERE Id = :winner.Id LIMIT 1];
                    master.Name = winner.Name;
                }

                //Remove ID field
                if (master.Id != null) {
                    master.Id = null;
                }
                //Remove all External IDs and Source
            }


            //Set master record to Merged flag
            master.Merged__c = true;
            
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult sr = Database.insert(master, dml);
                
            if (!sr.isSuccess()) {
                string strErr = 'Contact_Merge_Error_Merge_Failed' + ' Error: ';
                for (Database.Error err : sr.getErrors()) {
                    strErr += err.getMessage() + '\n';
                }
                Database.rollback(sp);
            }
            System.debug('@master insert = ' + master);


            //TODO: Generate 8-10 digits customer number
            if (master.Customer_Id__c == null) {
                master.Customer_Id__c = SCV_Utility.generateCustomerNumber(master.Id);
            }
            sr = Database.update(master, dml);

            if (!sr.isSuccess()) {
                string strErr = 'Contact_Merge_Error_Merge_Failed' + ' Error: ';
                for (Database.Error err : sr.getErrors()) {
                    strErr += err.getMessage() + '\n';
                }
                Database.rollback(sp);
            }
            System.debug('@master update = ' + master);


            //map it depending on sobject to for order purposes to avoid eror: Cannot have more than 10 chunks in a single operation. Please rearrange the data to reduce chunking.
            Map<String, Map<Id, Sobject>> childRecordsForUpdateMap = new Map<String, Map<Id, Sobject>>();
            //List<Sobject> customerGroupMemberShipForDeletion = new List<Sobject>();

            //get child relationship based on custom settings
            Map<String, Boolean> partyMergeCustomSetting = new Map<String, Boolean>();
            for (Party_Merge__c childCustomSetting: Party_Merge__c.getAll().Values()) {
                
                if (childCustomSetting.Active__c) {
                    String csKey =childCustomSetting.Object_API_Name__c + '-' + childCustomSetting.Lookup_Field_Name__c;
                    
                    //partyMergeCustomSetting.put(childCustomSetting.Object_API_Name__c + '-' + childCustomSetting.Lookup_Field_Name__c, childCustomSetting.isPersonContactId__c);
                    partyMergeCustomSetting.put(csKey, childCustomSetting.isPersonContactId__c);
                }
            }
            System.debug('partyMergeCustomSetting = ' + partyMergeCustomSetting);


            //Build query based on all child relationship object in partyMergeCustomSetting
            List<Schema.ChildRelationship> relationShips = new List<Schema.ChildRelationship>();

            //String queryStr = 'SELECT Id, Active__c, Master_Party__c, OwnerId, Status__c';
            String queryStr = 'SELECT Id, Private__c, Master_Account__c, OwnerId ';

            for (Schema.ChildRelationship childRelation: Account.sObjectType.getDescribe().getChildRelationships()) {
                String relationshipKey = childRelation.getChildSObject() + '-' + childRelation.getField();

                //Ignore Empty relationship, include only those child entities defined in the Party Merge custom settings
                if (childRelation.getRelationshipName() != null && 
                    partyMergeCustomSetting.containsKey(relationshipKey) && 
                    !childRelation.getRelationshipName().contains('__pr'))
                {
                    System.debug('Child-Object = ' + childRelation.getChildSObject());
                    System.debug('Child-Field = ' + childRelation.getField());

                    //Ignore converted Lead records
                    if (SCV_Utility.toStringValue(childRelation.getChildSObject()).equalsIgnoreCase('lead')) {
                        queryStr += ',(SELECT Id, ' + childRelation.getField() + ' FROM '+ childRelation.getRelationshipName() + ' WHERE isConverted = false)';
                    }
                    else {
                        queryStr += ',(SELECT Id, ' + childRelation.getField() + ' FROM '+ childRelation.getRelationshipName() + ')';
                    }

                    relationShips.add(childRelation);
                }
            }
            queryStr += ' FROM Account WHERE ID IN :losers';
            System.debug('query = ' + queryStr);
            System.debug('losers = ' + losers);


            //set losing partys to inactive and transfer owner to integration user
            Id integrationUserId;
            /*for(User usr: RecordFinderUser.getIntegrationUsers()){
                if(toStr(usr.UserName).contains('mergeuser@macbfs.com')){
                    integrationUserId = usr.Id;
                }
            }*/


            //reparent all child records to winner party
            for (Account existingAccount : Database.Query(queryStr))
            {
                for (Schema.ChildRelationship childRelation : relationShips)
                {
                    //Ignore null relationship
                    if (existingAccount.getSobjects(childRelation.getRelationshipName()) == null) {
                        continue;
                    }

                    String relationshipName = childRelation.getRelationshipName();
                    String childSObject = SCV_Utility.toStringValue(childRelation.getChildSObject());
                    String childField = SCV_Utility.toStringValue(childRelation.getField());

                    //map it depending on sobject to for order purposes to avoid eror: Cannot have more than 10 chunks in a single operation. Please rearrange the data to reduce chunking.
                    if (!childRecordsForUpdateMap.containsKey(childSObject)) {
                        childRecordsForUpdateMap.put( childSObject, new Map<Id, Sobject>() );
                    }

                    Map<Id, Sobject> tempchildRecordsForUpdateMap = childRecordsForUpdateMap.get(childSObject);


                    //
                    for (Sobject childRecord : existingAccount.getSobjects(childRelation.getRelationshipName())) {

                        String relationshipKey = childRelation.getChildSObject() + '-' + childRelation.getField();
                        String parentId = partyMergeCustomSetting.get(relationshipKey) ? master.PersonContactId : master.Id;


                        if (tempchildRecordsForUpdateMap.containsKey(childRecord.Id)) {
                            
                            tempchildRecordsForUpdateMap.get(childRecord.Id).put(
                                childRelation.getField(), parentId
                            );
                        }
                        else {
                            //Reparent child object to new master ID
                            childRecord.put( childRelation.getField(), parentId );
                            tempchildRecordsForUpdateMap.put(childRecord.Id, childRecord);
                        }

                        //TODO: Store mappings of child record original IDs


                    }

                    childRecordsForUpdateMap.put(
                        SCV_Utility.toStringValue(childRelation.getChildSObject()), tempchildRecordsForUpdateMap
                    );

                }

                //map it depending on sobject to for order purposes to avoid eror: Cannot have more than 10 chunks in a single operation. Please rearrange the data to reduce chunking.
                if (!childRecordsForUpdateMap.containsKey('Account')){
                    childRecordsForUpdateMap.put('Account', new Map<Id, Sobject>());
                }

                //Update losing party to inactive. owner to integration user and make master party the winner part
                existingAccount.Private__c = true;
                existingAccount.Master_Account__c = master.Id;
                
                //existingAccount.Active__c = false;
                //existingAccount.OwnerId = integrationUserId;
                //existingAccount.Master_Party__c = targetAcc.Id;
                //existingAccount.Status__c = 'Inactive';

                childRecordsForUpdateMap.get('Account').put(existingAccount.Id, existingAccount);

                //Move External IDs to System Links object
                //
            }

            Boolean noError = true;
            Integer chunkcounter = 1;
            Integer totalcounter = 0;

            //update every 10 kinds of Sobject //LIMIT for Generic Sobject DML
            for (String objName : childRecordsForUpdateMap.keyset()) {

                if (chunkcounter != 10){
                    chunkUpdate.addAll(childRecordsForUpdateMap.get(objName).values());
                    chunkcounter++;
                    totalcounter++;
                }

                if (totalcounter == childRecordsForUpdateMap.size()) {
                    for(Sobject obs: chunkUpdate){
                        //System.Debug(obs);
                    }
                    System.Debug('@chunkUpdate = ' + chunkUpdate);
                    update chunkUpdate;
                    break;
                }

                if (chunkcounter == 10){
                    for(Sobject obs: chunkUpdate){
                        //System.Debug(obs);
                    }

                    chunkcounter = 1;
                    
                    System.Debug('@chunkUpdate = ' + chunkUpdate);
                    update chunkUpdate;
                    chunkUpdate = new List<Sobject>();
                }
            }

        } catch (Exception ex) {
            //Handle exceptions
            Database.rollback(sp);
            System.debug('@Exception: ' + ex);

            //Log errors
            Error_Log__c error = new Error_Log__c();
            error.Error_Stacktrace__c = ex.getStackTraceString();
            error.Line__c = ex.getLineNumber();
            error.Type__c = ex.getTypeName();
            error.Error_Message__c = ex.getMessage() + '\n' + String.join(chunkUpdate, '\n');
            insert error;

            /*
            ApplicationLogUtility.logError('SVC_SyncEntities', 'mergeParty', e, '', '', '', infoLog , '', 0);
            ApplicationLogUtility.commitLog();
            */
        }

        //Go through all losers records and store External Ids into system link object and associate with the master
        //Combine all the identifiers and link to master

        //

        //Reparent child objects from losers and store mappings of original parent Ids
        //Hide losers

        return master;
    }


    /*------------------------------------------------------------
    Description:    Method to merge person or business accounts
    Inputs:         winner - This is the winning Account to clone from
                    losers - List of losing Accounts to reparent and hide
    Outputs:        Master Account
    History
    <Date>      <Authors Name>      <Brief Description of Change>
    01-Nov-17   Vincent Vuong       Created
    ------------------------------------------------------------*/
    public static List<Account> unmergeAccounts(Account master) {
        List<Account> accounts = new List<Account>();
        try {


        }
        catch(Exception ex) {

        }
        return accounts;
    }


    /*------------------------------------------------------------
    Description:    Get string value of an object
    Inputs:         Object
    Outputs:        String
    History
    <Date>      <Authors Name>      <Brief Description of Change>
    01-Nov-17   Vincent Vuong       Created
    ------------------------------------------------------------*/
    public static String toStringValue(Object obj) {
        return String.ValueOf(obj);
    }


    //https://en.wikipedia.org/wiki/Luhn_algorithm
    public static boolean isValidCheckSum(List<Integer> numbers) {
        Integer sum = 0;
        Integer len = numbers.size();
    
        for (Integer i = len - 1; i >= 0; i--)
        {
            if (math.mod(i , 2) == math.mod(len,  2) )
            {
                Integer n = numbers[i] * 2;
                sum += (n / 10) + ( math.mod(n, 10));
            }
            else
                sum += numbers[i];
        }
        return ( math.mod( sum, 10) == 0 );
    }

    //Luhn algorithm - Validate check digit
    public static boolean checkLuhnCheckDigit(String numbers){
        Integer sum = 0;
        Integer len = numbers.length();
        
        for (Integer i=len-1; i>=0; i--){
            Integer num = Integer.ValueOf(numbers.substring(i,i+1));
            if ( Math.mod(i , 2) == Math.mod(len, 2) ) {
                Integer n = num * 2;
                sum += (n / 10) + ( Math.mod(n, 10));
            }
            else {
                sum += num;
            }
        }
        return ( Math.mod( sum, 10) == 0 );
    }

    //Luhn algorithm - Generate check digit
    public static Integer generateLuhnCheckDigit(String numbers){
        Integer sum = 0;
        Integer len = numbers.length();
        
        for(Integer i=len-1;i>=0;i--){
            Integer num = Integer.ValueOf(numbers.substring(i,i+1));
            if ( Math.mod(i , 2) == Math.mod(len, 2) ) {
                Integer n = num * 2;
                sum += (n / 10) + ( Math.mod(n, 10));
            }
            else {
                sum += num;
            }
        }
        return Math.mod(sum, 10);
    }

    public static String getNumeric(String text) {
        Map<String, String> alphaMaps = new Map<String, String>();
        alphaMaps.put('a', '1');
        alphaMaps.put('b', '2');
        alphaMaps.put('c', '3');
        alphaMaps.put('d', '4');
        alphaMaps.put('e', '5');
        alphaMaps.put('f', '6');

        String value = '';
        Integer len = text.length();

        for(Integer i=0; i<len; i++){
            String ch = text.substring(i,i+1);
            if (alphaMaps.get(ch) != null) {
                value += alphaMaps.get(ch);
            }
            else {
                value += ch;
            }
        }

        return value + '-' + SCV_Utility.generateLuhnCheckDigit(value);
    }
    
    //Method to return Duplicate records Map - recordIdVsListOfDuplicates
    public Map<String,List<Account>> findDuplicateAccounts(){return NULL;}

}