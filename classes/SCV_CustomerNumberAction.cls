public class SCV_CustomerNumberAction {

	@InvocableMethod(label='Assign Unique Customer IDs' description='Assign 8-10 digits unique customer numbers.')
    public static void assignCustomerIds(List<Account> accountsToUpdate) {
        
        List<Account> accounts = [SELECT Id, Customer_Id__c
        						FROM Account 
            					WHERE Id IN :new Map<Id, Account>(accountsToUpdate).keySet()
            					AND Customer_Id__c = null
            					];

		for(Account acc : accounts) {
			if (acc.Customer_Id__c == null) {
                acc.Customer_Id__c = SCV_Utility.generateCustomerNumber(acc.Id);
			}
		}

        try {
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true;
            List<Database.SaveResult> sr = Database.update(accounts, dml);

            /*if (!sr.isSuccess()) {
                string strErr = 'Contact_Merge_Error_Merge_Failed' + ' Error: ';
                for (Database.Error err : sr.getErrors()) {
                    strErr += err.getMessage() + '\n';
                }
            }*/

        } catch (Exception ex) {
            //Handle exceptions
            System.debug('@Exception: ' + ex);

            //Log errors
            Error_Log__c error = new Error_Log__c();
            error.Error_Stacktrace__c = ex.getStackTraceString();
            error.Line__c = ex.getLineNumber();
            error.Type__c = ex.getTypeName();
            error.Error_Message__c = ex.getMessage();
            insert error;
        }

    }

}