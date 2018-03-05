/*------------------------------------------------------------------------
 Author:        Puneet Tyagi
 Company:       SaaSfocus
 Description:   Main class to get Duplicate customers for SCV

 Test Class:    
 History
 <Date>         <Authors Name>    <Brief Description of Change>
 25/Oct/2017     Puneet Tyagi      Initial creation
 --------------------------------------------------------------------------*/
public class SCV_DuplicateCustomersController{  
     
    //Method to return duplicate settings from the custom setting 
    @AuraEnabled
    public static SCV_Duplicate_Management__c getDuplicateSettings(){
        return SCV_Duplicate_Management__c.getOrgDefaults();
    } 
     
     
    /*------------------------------------------------------------
    Author:        Puneet Tyagi
    Company:       SaaSfocus
    Description:   Method to return duplicate customers

    Inputs:        
    Outputs:       Wrapper list containing info about duplicate customers 
    History
    <Date>         <Authors Name>     <Brief Description of Change>
    25-Oct-17      Puneet Tyagi      Created
    ------------------------------------------------------------*/               
    @AuraEnabled
    public static List<CustomerSummary> getDuplicateCustomers() {
    
        List<CustomerSummary> listWrapperAccounts = new List<CustomerSummary>();
        List<Id> mergeIds = new List<Id>();
        Map<String,DuplicateRule> mapIdToDupeRule  = SCV_Utility.getActiveDuplicateRules();
        Map<String,String> mapDupSetIdToDuplicateRuleName = new Map<String,String>();
        //For custom matching
        SCV_Duplicate_Management__c objDupeMgmt = SCV_Duplicate_Management__c.getOrgDefaults();
        
        //New Logic
        Map<String,Set<Id>> accIdToRecordsMap = new Map<String,Set<Id>>();
        Map<String,Set<Id>> accIdToDuplicateRecordsIdMap = new Map<String,Set<Id>>();
        Map<String,List<Account>> accIdToDuplicateRecordsMap = new Map<String,List<Account>>();
        Map<String,List<Account>> accIdToDuplicateAccountsMap = new Map<String,List<Account>>();
        
        //Set to exclude duplicate from the comparison
        Set<Id> dupAccIds = new Set<Id>();
        Map<String,String> accIdToRuleNameMap = new Map<String,String>();
        Set<Id> duplicateAccountIdsSet = new Set<Id>();
        System.debug('==objDupeMgmt ==== '+objDupeMgmt);

        //Limit duplicate records in query
        Integer maxLimit = 2000;
        if (objDupeMgmt.Duplicate_Records_Limit__c != null && objDupeMgmt.Duplicate_Records_Limit__c > 0) {
            maxLimit = (Integer)objDupeMgmt.Duplicate_Records_Limit__c;
        }

        List<Account> duplcateAccounts = new List<Account>();

        //Whether to enable First Pass filtering
        if (objDupeMgmt.Enable_First_Pass_Matching__c != null && objDupeMgmt.Enable_First_Pass_Matching__c) {
            //First pass duplicate checking by checking on name
            List<String> duplicateNames = new List<String>();

            //Business accounts
            AggregateResult[] groupedResults = [SELECT Name, COUNT(Id) FROM Account WHERE Name != 'DUMMY' GROUP BY Name HAVING COUNT(Id)>1];
            for (AggregateResult ar : groupedResults)  {
                String accName = String.valueOf(ar.get('Name'));
                if (accName != 'UNKNOWN UNKNOWN' &&
                        accName != 'DUMMY' &&
                        accName != 'pepauto@outlook.com') {
                    duplicateNames.add(accName);
                }
            }
            System.debug('duplicateNames = ' + duplicateNames);

            //Get List of duplicate accounts
            duplcateAccounts = [SELECT Id 
                                    FROM Account 
                                    WHERE Merged__c=false
                                    AND Private__c=false
                                    AND Name IN :duplicateNames
                                    ORDER BY Name
                                    LIMIT :maxLimit
                                ];
        }
        else {
            //Unfilter query
            duplcateAccounts = [SELECT Id 
                                    FROM Account 
                                    WHERE Merged__c=false 
                                    AND Private__c=false
                                    ORDER BY Name 
                                    LIMIT :maxLimit];
        }

        //
        for (Account acc : duplcateAccounts) {
                
            if(!accIdToRecordsMap.containsKey(acc.id) &!dupAccIds.contains(acc.id)){
                List<Id> accIds = new List<Id>();
                accIds.add(acc.id);
                
                //Pass account ids one by one to the datacloud and find possible duplicates
                for(Datacloud.FindDuplicatesResult obj :Datacloud.FindDuplicatesByIds.findDuplicatesByIds(accIds)){
                    if(obj.isSuccess()){
                        for(Datacloud.DuplicateResult dResult :obj.getDuplicateResults()){        
                            for(Datacloud.MatchResult matchResult :dResult.getMatchResults()){                    
                                if(matchResult != NULL && matchResult.isSuccess() && matchResult.getSize() >0){
                                    
                                    //Map to keep duplicate rule info
                                    if(!accIdToRuleNameMap.containsKey(acc.id))
                                    accIdToRuleNameMap.put(acc.id, matchResult.getRule());
                                    
                                    //Map to keep original and related duplicate records
                                    accIdToRecordsMap.put(acc.id,new Set<Id>());
                                    accIdToRecordsMap.get(acc.id).add(acc.id);                        
                                    for(Datacloud.MatchRecord mRecord :matchResult.getMatchRecords()){
                                        Account accObj = (Account)mRecord.getRecord();
                                        if(!accObj.Merged__c){
                                            accIdToRecordsMap.get(acc.id).add(accObj.id);                                            
                                            dupAccIds.add(accObj.Id);
                                        }                                        
                                    }                             
                                }
                            }        
                        }    
                    }
                }
                if(accIdToRecordsMap.containsKey(acc.id) && accIdToRecordsMap.get(acc.id).size() > 1) {               
                    accIdToDuplicateRecordsIdMap.put(acc.id,new Set<Id>());
                    accIdToDuplicateRecordsIdMap.get(acc.id).addAll(accIdToRecordsMap.get(acc.id));
                    duplicateAccountIdsSet.addAll(accIdToRecordsMap.get(acc.id));
                }
                
            }
        } 
        
        System.debug('==duplicateAccountIdsSet==== '+duplicateAccountIdsSet);
        
        Map<String,Account> idToAccountMap = new Map<String,Account>([SELECT Id,CRM_Legal_name__c,CRM_Trading_Name__c,Merged__c,ABN__c,ACN__c,AccountNumber, Name, FirstName, LastName, PersonBirthdate,
                                        PersonEmail,CRM_Business_Type__c, Phone, PersonMobilePhone, isPersonAccount, CRM_Mtg_Email__c, Customer_Id__c,
                                        (SELECT Id, Type__c, Value__c FROM Identifications__r)
                                        FROM Account WHERE Merged__c=false and id IN :duplicateAccountIdsSet]);
        
        
        for(Id accId :accIdToDuplicateRecordsIdMap.keyset()){
            accIdToDuplicateRecordsMap.put(accId,new List<Account>());
            for(Id accDupeId :accIdToDuplicateRecordsIdMap.get(accId)) {           
                accIdToDuplicateRecordsMap.get(accId).add(idToAccountMap.get(accDupeId));  
            }    
            
            //Custom Matching based on identifications for each account
            if(objDupeMgmt.Enable_Custom_Matching__c){
                List<Account> listDuplicateAccounts = findDuplicates(accIdToDuplicateRecordsMap.get(accId));
                System.debug('=====listDuplicateAccounts==== '+listDuplicateAccounts);
                if(listDuplicateAccounts != NULL && listDuplicateAccounts.size() > 1){
                    accIdToDuplicateAccountsMap.put(accId,listDuplicateAccounts);
                }
            }  
            else{
                accIdToDuplicateAccountsMap.put(accId,accIdToDuplicateRecordsMap.get(accId));
            }                         
        }
        
          
        System.debug('===accIdToRecordsMap==== '+accIdToRecordsMap);
        System.debug('===accIdToRuleNameMap=== '+accIdToRuleNameMap.size());      
                             
        //Add data & info to the final wrapper list
        for(String key :accIdToDuplicateAccountsMap.keySet()){ 
            CustomerSummary card = new CustomerSummary(); 
            for(Account objAcc :accIdToDuplicateAccountsMap.get(key)){
                mergeIds.add(objAcc.id);
            }
            card.mergeIds = String.join(mergeIds,','); 
            if(accIdToDuplicateAccountsMap.get(key).size() > 0 ){                
                card.isPerson = accIdToDuplicateAccountsMap.get(key)[0].isPersonAccount;
                card.name = SCV_Utility.toProperCase(accIdToDuplicateAccountsMap.get(key)[0].name);
                card.listOfDuplicates = accIdToDuplicateAccountsMap.get(key);
                card.total = accIdToDuplicateAccountsMap.get(key).size();
                card.duplicateRuleName = accIdToRuleNameMap.get(key);                
            } 
            listWrapperAccounts.add(card);
            mergeIds.clear();
        }        
        System.debug('====listWrapperAccounts==== '+listWrapperAccounts);
        return listWrapperAccounts;
    }
    
    /*------------------------------------------------------------
    Author:        Puneet Tyagi
    Company:       SaaSfocus
    Description:   Method to find duplicate customers

    Inputs:        List of Accounts related to a particular duplicate record set.
    Outputs:       Duplicate Accounts list within a duplicate record set based on the identifications 
    History
    <Date>         <Authors Name>     <Brief Description of Change>
    30-Oct-17      Puneet Tyagi      Created
    ------------------------------------------------------------*/  
    public static List<Account> findDuplicates(List<Account> listAccount){
        List<Account> listDuplicateAccounts = new List<Account>();
        Set<Id> setAccIds = new Set<id>();
        Map<String,List<Account>> mapDupeKeyToAccountList = new Map<String,List<Account>>();
        for(Account objAcc :listAccount){
            if(objAcc.Identifications__r != NULL && objAcc.Identifications__r.size() > 0){
                for(Identification__c objIdentity :objAcc.Identifications__r){
                    if(String.isNotBlank(objIdentity.Type__c) && String.isNotBlank(objIdentity.Value__c)){
                        String strKey = objIdentity.Type__c + objIdentity.Value__c;
                        if(!mapDupeKeyToAccountList.containsKey(strKey)){
                            mapDupeKeyToAccountList.put(strKey,new List<Account>());
                        } 
                        mapDupeKeyToAccountList.get(strKey).add(objAcc);
                    }                                    
                }
            }              
        }
        
        System.debug('====mapDupeKeyToAccountList==== '+mapDupeKeyToAccountList);
        
        for(String strKey :mapDupeKeyToAccountList.keyset()){
            if(mapDupeKeyToAccountList.get(strKey).size() > 1){
                for(Account objAcc :mapDupeKeyToAccountList.get(strKey)){
                    if(!setAccIds.contains(objAcc.id)){
                        listDuplicateAccounts.add(objAcc);                    
                        setAccIds.add(objAcc.id);
                    }
                }
            }        
        }
        System.debug('===listDuplicateAccounts=== '+listDuplicateAccounts);
        
        if(listDuplicateAccounts.size()>1)
        return listDuplicateAccounts;
        else return NULL;
    } 
 
    /******Wrapper Class************/
    public class CustomerSummary{
        @AuraEnabled public Boolean isPerson;
        @AuraEnabled public String name;
        @AuraEnabled public Integer total;
        @AuraEnabled public String mergeIds;
        @AuraEnabled public List<Account> listOfDuplicates; 
        @AuraEnabled public String duplicateRuleName;
               
        public CustomerSummary(){
            isPerson = false;
            name = '';
            total = 0;
            mergeIds = '';
            listOfDuplicates = new List<Account>();
            duplicateRuleName = '';
            
        }        
    }
}