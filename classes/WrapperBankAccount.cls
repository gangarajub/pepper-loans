public class WrapperBankAccount{
    public String accountId;
    public String accountUsage;
    public String accountNo;
    public String bsbNo;
    public String financialIns;
    public String debtId;
    public String accountHolderName;
    public String loanAccountId;
    public Boolean isDefault;
    public Boolean isDebitAuthorizationProvided;
    public Boolean agreedtoTermsAndConditions;
    
    public String loanApplicationId;
       public void WrapperBankAccount(){}
       public void set(String accountId,String accountUsage,String accountNo,String bsbNo,String financialIns,String debtId,String accountHolderName,String loanAccountId,Boolean isDefault, String loanApplicationId,Boolean isDebitAuthorizationProvided,Boolean agreedtoTermsAndConditions){
           this.accountId=accountId;
           this.accountUsage=accountUsage;
           this.accountNo=accountNo;
           this.bsbNo=bsbNo;
           this.financialIns=financialIns;
           this.debtId=debtId;
           this.accountHolderName=accountHolderName;
           this.loanAccountid = loanAccountId;
           this.isDefault = isDefault;
           this.loanApplicationId = loanApplicationId;
           this.isDebitAuthorizationProvided = isDebitAuthorizationProvided;
           this.agreedtoTermsAndConditions = agreedtoTermsAndConditions;
           
          
       }
}