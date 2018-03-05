global class RetrieveLoanAccounts{
    
 
    
    private static String nsPrefix = 'loan__';
    
    public static String constructWhere(String fieldName, String val) {
        return fieldName + ' = :' + val;
    }
   
    public static List<loan__Loan_Account__c> getLoanContracts(Id borrowerId, Id contractId, String allowedStatuses, String additionalFields, 
                                                Map<String, String> childObjects) {
        if(borrowerId == null && contractId == null) {
            System.debug(LoggingLevel.ERROR, 'In BorrowerAPIImpl.getApplications method : both applicationId and borrowerId null');
            throw new MyException('Borrower and Application both are missing');
                        
        }
        Set<Id> contractIds = new Set<Id>();
        if(contractId!= null) {
            List<loan__Loan_Account__c> loan= [SELECT Id, Name
                                             FROM loan__Loan_Account__c
                                             WHERE Id = :contractId];
            if(loan!= null && loan.size() == 0) {
                System.debug(LoggingLevel.ERROR, 'In BorrowerAPIImpl.getApplications method : Application with applicationId not found');
                throw new MyException('Application Id not Found');
            }
            contractIds.add(contractId);
        }
        else {
            List<Account> accounts = [SELECT Id, Name,
                                        (SELECT Id, Name
                                            FROM loan__Loan_Accounts__r)
                                     FROM Account 
                                     WHERE Id = :borrowerId];
            if(accounts.size() == 0) {
                List<Contact> contacts = [SELECT Id, Name,
                                        (SELECT Id, Name
                                            FROM loan__Loan_Accounts__r)
                                     FROM Contact
                                     WHERE Id = :borrowerId];    
                if(contacts.size() == 0) {
                     throw new MyException('Borrower id not found');
                }
                Contact con = contacts.get(0);
                for(loan__Loan_Account__c loan: con.loan__Loan_Accounts__r) {
                    contractIds.add(loan.Id);
                }
                
            } else {
                Account account = accounts.get(0);
                for(loan__Loan_Account__c  loan: account.loan__Loan_Accounts__r) {
                    contractIds.add(loan.Id);
                }
            }
            if(contractIds.size() == 0) {
               throw new MyException('Contract Id is missing');
            }            
        }
        return getLoanContracts(contractIds, allowedStatuses, additionalFields, childObjects);
        return null;
    }
    
    /**
    * Returns an application or all the applications for a borrower with given statuses and additionalFields along 
    * with specified child objects 
    * @applicationId        Id of the application
    * @borrowerId           Id of the borrower (contact or account)
    * @allowedStatus        A comma, separated list of desired application statuses
    * @additionalFields     A comma separated list of fields (other than direct application fields)
    * @childObjects         A Map with key as Child Relationship Name (with __r) and namespace and value as 
    *                           comma separated list of fields of this object with namespace.
    * @return List of Applications__c with given child objects.
    */ 
    
    private static List<loan__Loan_Account__c> getLoanContracts(Set<Id> contractIds, String allowedStatuses, String additionalFields, 
                                                Map<String, String> childObjects) {
        if(contractIds== null || contractIds.size() == 0) {
            return null;
        }
        try {
            String whereClause = '';
            mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();     
            mfiflexUtil.ObjectCache appOc = ec.createObject('AllContracts', nsPrefix + 'Loan_Account__c');
            String allFields = null;
            appOc.addFields(allFields);
            appOc.addFields(nsPrefix + 'Contact__r.FirstName, ' + nsPrefix + 'Contact__r.LastName');
            if(additionalFields != null) {
                appOc.addFields(additionalFields);
            }
            appOc.addNamedParameter('Ids', contractIds);
            whereClause += 'Id in :Ids';
            for(String childObj : childObjects.keySet()) {
                 mfiflexUtil.ObjectCache relatedOc = ec.createRelationship(childObj);
                 relatedOc.addFields(childObjects.get(childObj));                 
                 relatedOc.setOrderClause('CreatedDate DESC');
                 //relatedOc.setLimitClause('20'); //to limit payload data
                 appOc.addRelationShip(relatedOc);
                 System.debug('relatedOc '+relatedOc );
            }
            
           
          
            if(allowedStatuses != null) {
                Set<String> status = new Set<String>();
                List<String> temp = allowedStatuses.split(',', -1);
                for(String s : temp) {
                    status.add(s);
                }
                if(status.size() > 0) {
                    appOc.addNamedParameter('status', status);
                    whereClause += ' AND ' + nsPrefix + 'Loan_Status__c in :status';
                }                
            }
            appOC.SetWhereClause(whereClause);
            System.debug('appOC'+appOC);
            System.debug('appOC.executeQuery()'+appOC.executeQuery());
            List<loan__Loan_Account__c> contracts= (List<loan__Loan_Account__c>)appOC.getRecords();
            return contracts;
        } catch(Exception e) {
            System.debug(LoggingLevel.Error, 'Exception querying application : ' + e.getMessage());
             throw new MyException('Exception'+e.getMessage());
        }            
        return null;
    }
}