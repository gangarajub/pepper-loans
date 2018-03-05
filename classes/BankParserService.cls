public class BankParserService{

    public String fetchAndInsertBankStatement(String xmlResponse,String appId,String slugName){
        boolean status=true;
        BankStatementParser parser  = new BankStatementParser();
        status=parser.parseAndInsertStatement(xmlResponse,appId,slugName);
        
        if(status){
            return 'Successful';
        }else{
            return 'Not Successful';
        }
    
    }
    
    public List<loan__Bank_Account__c> getBankAccountsForAccount(String accId){
    
        List<loan__Bank_Account__c> bankAccountList = new List<loan__Bank_Account__c>();
        if(!String.isBlank(accId)){
            bankAccountList = [select Id, Name,loan__Active__c,invalid__c,loan__Account_usage__c,loan__Bank_Name__c,Bank_Account_Number__c,BSB__c,Account_Holder_Name__c  
                            from loan__Bank_Account__c where loan__Account__c=:accId order By createdDate desc];
        }
        
        return bankAccountList;
    }
    
    public List<loan__Bank_Account__c> getBankAccountsForApplication(String appId){
        List<Bank_Statement__c> bankStatements = new List<Bank_Statement__c>();
        if(!String.isBlank(appId)){
            bankStatements = [select id , Application__c,Bank_Account__c from Bank_Statement__c where Application__c=:appId and Bank_Account__c!=null];
        }
        Set<Id> bankAccountIds = new Set<Id>();
        if(bankStatements.size()>0){
            for(Bank_Statement__c statement:bankStatements){
                bankAccountIds.add(statement.Bank_Account__c);
            }
        }
        
        
        List<loan__Bank_Account__c> bankAccountList = new List<loan__Bank_Account__c>();
        if(bankAccountIds.size()>0){
             bankAccountList = [select Id , Name,loan__Active__c,invalid__c,loan__Account_usage__c,loan__Bank_Name__c,Bank_Account_Number__c,BSB__c,Account_Holder_Name__c 
                            from loan__Bank_Account__c where Id In:bankAccountIds order by createdDate desc];
        }
        return bankAccountList;
    }

}