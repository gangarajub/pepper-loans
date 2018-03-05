public class BankApi {

    public class Response {
        public loan__Bank_Account__c bankAccount;
        public String status;
        public String debtId;
    }

    public List<Response> addNewBanks(List<WrapperBankAccount> listOfBankAccount){
        
        List<Response> listResp  = new  List<Response>();
        List<loan__Bank_Account__c> bankList= new List<loan__Bank_Account__c>();
        List<loan__Bank_Account__c> bankListwithoutDebtId= new List<loan__Bank_Account__c>();  
        List<Expense_and_Debt__c> listofExpDebtRec = new List<Expense_and_Debt__c>();
        List<Expense_and_Debt__c> listofExpDebtRecToBeupdated = new List<Expense_and_Debt__c>();
        Map<Id,loan__Bank_Account__c> loanAppIdToBankAccounts = new Map<Id,loan__Bank_Account__c>();
        Map<Id,loan__Bank_Account__c> loanAccIdToBankAccounts = new Map<Id,loan__Bank_Account__c>();
        Set<Id> loanAppIds = new Set<Id>();
        Set<Id> loanAccIds = new Set<Id>();
        List<genesis__Applications__c> applications = new List<genesis__Applications__c>();
        List<loan__Loan_Account__c> loanAccounts = new List<loan__Loan_Account__c>();
        
        Set<Id> setOfExpIds = new Set<Id>();
        Map<String,loan__Bank_Account__c   > bankMap = new Map<String,loan__Bank_Account__c>();
        
        Set<Id> borrowerBankAccountIds = new Set<Id>();
        String accountId = '';
        
        //Code by Chirag Gupta on 21-03-2017, explicitly for Dealer Account not hampering existing functionaliity
        Set<Id> accountIds = new Set<Id>();     
        for(WrapperBankAccount bank : listOfBankAccount){
            if('Dealer Account'.equalsIgnoreCase(bank.accountUsage)){
                accountIds.add(bank.accountId);
            }   
        }
        
        disableOtherBankAccounts(accountIds, 'Dealer Account', null);
        
        for(WrapperBankAccount bank : listOfBankAccount){
            
            loan__Bank_Account__c   newbankAccount = new loan__Bank_Account__c(); 
            newbankAccount.loan__Account__c=bank.accountId;
            newbankAccount.loan__Account_Usage__c=bank.accountUsage;
            newbankAccount.Bank_Account_Number__c=bank.accountNo;
            newbankAccount.loan__Bank_Account_number__c = bank.accountNo;
            newbankAccount.BSB__c=bank.bsbNo;  
            newbankAccount.loan__Bank_Name__c=bank.financialIns;
            newbankAccount.loan__Active__c = true;
            newbankAccount.Account_Holder_Name__c=bank.accountHolderName;
            newbankAccount.Agreed_to_Terms_and_Conditions__c = bank.agreedToTermsAndConditions;
            newbankAccount.Is_Debit_Authorization_Provided__c = bank.isDebitAuthorizationProvided;
            /*if(bank.loanApplicationId!=null){
                newbankaccount.Application__c = bank.loanApplicationId;
            }*/
            
            if(!String.isEmpty(bank.debtId)){
                bankMap.put(bank.debtId,newbankAccount);
                setOfExpIds.add(bank.debtId); 
                
            }else{
                bankListwithoutDebtId.add(newbankAccount);
            }
            
            insert newbankAccount;
            bankList.add(newbankAccount);
            
            if(bank.loanApplicationId != null && bank.IsDefault != null && bank.isDefault == true){
                
                if(loanAppIdToBankAccounts.get(bank.loanApplicationId)!=null){
                    loanAppIdToBankAccounts.put(bank.loanApplicationId, newBankAccount);
                    loanAppIds.add(bank.loanApplicationId);
                }else{
                    loanAppIdToBankAccounts.put(bank.loanApplicationId, newBankAccount);
                    loanAppIds.add(bank.loanApplicationId);
                }
            }
            
            if(bank.loanAccountId != null && bank.IsDefault != null && bank.isDefault == true){
                
                if(loanAccIdToBankAccounts.get(bank.loanAccountId)!=null){
                    loanAccIdToBankAccounts.put(bank.loanAccountId, newBankAccount);
                    loanAccids.add(bank.loanAccountid);
                }else{
                    loanAccIdToBankAccounts.put(bank.loanAccountId, newBankAccount);
                    loanAccids.add(bank.loanAccountid);
                }
            }
        }
        try{
            
            //insert bankList;
            for(String bank :bankMap.keyset()){
                 Response resp = new Response();
                 resp.bankAccount =bankMap.get(bank);
                 resp.debtId= bank;
                 resp.status='Successful';
                 listResp.add(resp);
                 
            
            }
            listofExpDebtRec = [select id,name from Expense_and_Debt__c where id=:setOfExpIds];
            if(listofExpDebtRec.size()>0){
                for(Expense_and_Debt__c expRec : listofExpDebtRec){
                    //String strExpr = String.valueof();
                    expRec.Bank_Account__c= bankMap.get(expRec.Id).Id;
                    
                    listofExpDebtRecToBeupdated.add(expRec); 
                
                }
                update  listofExpDebtRecToBeupdated;
            } 
            if(bankListwithoutDebtId.size()>0){
                for(loan__Bank_Account__c bank : bankListwithoutDebtId){
                    Response resp = new Response();
                    resp.bankAccount = bank;
                    resp.debtId='';
                    resp.status='Successful';
                    listResp.add(resp);
                    if(bank.loan__Account_Usage__c.equalsIgnoreCase('Borrower/Investor Account')){
                        borrowerBankAccountids.add(bank.id);
                        accountid = bank.loan__Account__c;
                    }
                    
                }
            }
            
            if(loanAppIds.size()>0){
                applications = [select id , Default_bank_Account__c from genesis__Applications__c where 
                                Id in:loanAppIds];
                for(genesis__Applications__c app:applications){
                    if('Borrower/Investor Account'.equalsIgnoreCase(loanAppIdToBankAccounts.get(app.id).loan__Account_Usage__c)){
                        app.Default_Bank_Account__c = loanAppIdToBankAccounts.get(app.id).id;
                    }
                }
            }
            List<loan__Automated_Payment_Setup__c> apsList = new List<loan__Automated_Payment_Setup__c>();
            if(loanAccIds.size()>0){
                loanAccounts = [select id, Default_Bank_Account__c,
                (select id,loan__Active__C,loan__Bank_Account__c 
                from loan__Automated_Payment_Setup__r where loan__Active__c = true)
                 from loan__Loan_Account__c where Id in:loanAccIds];
                 
                for(loan__Loan_Account__c lAcc:loanAccounts){
                    
                    if('Borrower/Investor Account'.equalsIgnoreCase(loanAccIdToBankAccounts.get(lAcc.id).loan__Account_Usage__c)){
                        lAcc.Default_Bank_Account__c = loanAccIdToBankAccounts.get(lAcc.id).id;
                    }
                    
                    for(loan__Automated_Payment_Setup__c aps:lAcc.loan__Automated_Payment_Setup__r){
                        aps.loan__Bank_Account__c = lAcc.Default_Bank_Account__c;
                        apsList.add(aps);
                    }
                }
                
               
            }
            update loanAccounts;
            update applications;
            update apsList;
            disableOtherBankAccounts(borrowerBankAccountIds,accountId);
            return listResp;
        }catch(Exception e){
        System.debug('e'+e.getMessage());
            Response resp = new Response();
            resp.status='Unsuccessful';
            listResp.add(resp);
            return listResp;
        }
      return listResp ;
     
    }

    public Response activateBankAccount(String bankAccountId,String loanApplicationId, String loanAccountId){
        
        Response resp  = new  Response();
        loan__Bank_Account__c  activeBankAccount = [select id,name,loan__Active__c from loan__Bank_Account__c    
                                                where id=:bankAccountId];
        genesis__Applications__c app = new genesis__Applications__c();
        loan__Loan_Account__c lAcc = new loan__Loan_Account__c();
        if(!String.isBlank(loanApplicationId)){
            app = [select id , default_bank_account__c from genesis__Applications__c where Id = : loanApplicationId];
            app.default_bank_Account__c = bankAccountId;
            update app;
        }
        List<loan__Automated_Payment_Setup__c> apsList = new List<loan__Automated_Payment_Setup__c>();
        if(!String.isBlank(loanAccountId)){
            lAcc = [select id , default_bank_account__c,(select id,loan__Active__C,loan__Bank_Account__c 
                from loan__Automated_Payment_Setup__r where loan__Active__c = true) from loan__loan_account__c where id = : loanAccountId];
            lAcc.default_bank_account__c = bankAccountId;
            for(loan__Automated_Payment_Setup__c aps:lAcc.loan__Automated_Payment_Setup__r){
                aps.loan__Bank_Account__c = lAcc.Default_Bank_Account__c;
                apsList.add(aps);
            }
            update lAcc;
        }
        update apsList;
        Set<Id> borrowerBankAccountIds = new Set<Id>();
        String accountId = activeBankAccount.Id;
        if(activeBankAccount.loan__Active__c==true){
            resp.bankAccount= activeBankAccount ;
            resp.status='Successful';
            borrowerBankAccountIds.add(activeBankAccount.id);
            disableOtherBankAccounts(borrowerBankAccountIds,accountId);
        }else{
            disableOtherBankAccounts(borrowerBankAccountIds,accountId);
            activeBankAccount.loan__Active__c = true;
            resp.bankAccount = activeBankAccount ;
            resp.status='Successful';
        }
        
        try{
            update activeBankAccount;
            resp.bankAccount= activeBankAccount ;
            resp.status='Successful';
            return resp;
        }catch(Exception e){
            resp.status = 'Unsuccessful';
            return resp;
        }    
    }
    
    private void disableOtherBankAccounts(Set<Id> activatedBankAccountIds, String accountId){
        List<loan__Bank_Account__c> bankAccounts = [select Id,loan__Active__c from loan__Bank_Account__c where loan__Account__c=:accountId and loan__Account_Usage__c ='Borrower/Investor Account'];
        Set<Id> IdOfBankAccToBeDisabled = new Set<id>();
        for(loan__Bank_Account__c bank:bankAccounts){
            if(!activatedBankAccountIds.contains(bank.id)){
                bank.loan__Active__c = false;
            }
        }
        update bankAccounts;
        
        
    }
    
    private void disableOtherBankAccounts(Set<Id> accountIds, String accountUsage, String dummy){
        List<loan__Bank_Account__c> bankAccounts = [select Id,loan__Active__c from loan__Bank_Account__c where loan__Account__c IN :accountIds and loan__Account_Usage__c = :accountUsage];
        
        for(loan__Bank_Account__c bank : bankAccounts){
            bank.loan__Active__c = false;
        }
        update bankAccounts;
        
        
    }

}