@isTest(SeeAllData=False)
private class pepBankInfoDetailscontroller_Tracker
{
 static testMethod void validate()
    {
         pepBank_Statement_Credential__c objBankStatement = new pepBank_Statement_Credential__c();
        objBankStatement.name = 'Credential';
        objBankStatement.pepEndPoint_Url__c = 'https://test.bankstatements.com.au/api/v1';
        objBankStatement.pepX_API_KEY__c = 'BKZYR9ACQMMUVYHVCLEN1B6AUOJLATYRXQO1PIKF'; 
        insert objBankStatement;
  pepBankInfoDetailscontroller objClass = new pepBankInfoDetailscontroller();
  objClass.updatebank();
}
}