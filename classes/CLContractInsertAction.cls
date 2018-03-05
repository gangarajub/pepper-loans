public class CLContractInsertAction {
  @InvocableMethod(label='Insert CL contract' description='Inserts the CL contract and update Encrypted SF ID value')
  public static void insertAccounts(List<String> name) {
      List<loan__Loan_Account__c> contract = [select id,Encrypted_SF_ID__c from loan__Loan_Account__c where name=:name];
      if(contract.size()==0){
      
      }else{
          String id = contract[0].Id;
          String encryptedId = pepEncryptDecryptData.EncryptData(id);
          contract[0].Encrypted_SF_ID__c=encryptedId; 
          update contract[0];
      }
  
  }
}