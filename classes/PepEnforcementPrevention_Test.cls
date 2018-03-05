@isTest(SeeAllData=False)
Private class PepEnforcementPrevention_Test{

Private Static User us;
Private static Account Accnt;
Private static Account Accnt1;
Private static Case enforcementcase;
Private static collect__Loan_Account__c objContract;
Private static collect__Loan_Account__c objContract1;
//Testmethod for testing the wrong Account/Contract tagging Relationship 
Private testmethod static void testMethod1(){
us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
System.runas(us){
loaddata();
}
User plservicinguser=[Select id from User where Profile.Name='Admin - Customer Service' and Isactive=True Limit 1];
System.runas(plservicinguser){
RecordType rt =[Select id from RecordType where sobjectType='Case' and Developername='Enforcement' Limit 1];
enforcementcase = new case(RecordtypeId=rt.id,Status='Open',Origin='Email',Subject='Test Case',Description='Please respond to my enforcement related query.');
insert enforcementcase;
EmailMessage[] newEmail = new EmailMessage[0];
 
newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = enforcementcase.Id)); 
 
insert newEmail;
delete newEmail;
}
Account_LoanContract__c accLoanContract = new Account_LoanContract__c(Loan_Contract__c=objContract.id,Account__c=Accnt.id,case__c=enforcementcase.id);
insert accLoanContract;

clcommon__Party__c party = new clcommon__Party__c(collect__CL_Contract__c=objContract1.id,clcommon__Account__c=Accnt1.id,ScCollection_Relationship__c='Primary');
insert party;
Account_LoanContract__c accLoanContract1 = new Account_LoanContract__c(Loan_Contract__c=objContract1.id,Account__c=Accnt1.id,case__c=enforcementcase.id);
insert accLoanContract1;
List<Account_LoanContract__c> accountContractRelations =[Select id from Account_LoanContract__c];
System.assert(accountContractRelations.size()>0,'Assertion here');


}
Private static void loaddata(){
String RecTypeId= [select Id from RecordType where (DeveloperName='ScCollection_Person_Account_CL') and (SobjectType='Account')].Id;
 
  Accnt = new Account(
  RecordTypeID=RecTypeId,
  FirstName='Test FName',
  LastName='Test LName',
  PersonMailingStreet='test@yahoo.com',
  PersonMailingPostalCode='12345',
  PersonMailingCity='SFO',
  PersonEmail='test@yahoo.com',
  PersonHomePhone='1234567',
  PersonMobilePhone='0414136952' 
);
 
insert Accnt;
 Accnt1 = new Account(
  RecordTypeID=RecTypeId,
  FirstName='Test FName1',
  LastName='Test LName1',
  PersonMailingStreet='test11@yahoo.com',
  PersonMailingPostalCode='112345',
  PersonMailingCity='SFO',
  PersonEmail='tes1t@yahoo.com',
  PersonHomePhone='12341567',
  PersonMobilePhone='04141369522' 
);
 
insert Accnt1;


//insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');

        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract.collect__External_Id__c='MORTGAGE:123456_0';
        objContract.ScCollection_Lender_Record__c='PEPPER-ARM';
        objContract.ScCollection_Originator_ID__c='0001636';
        objContract.ScCollection_Mortgage_Funding__c='ABC';
        objContract.collect__Account__c=Accnt.id;
        update ObjContract;
        
      

        //Insert Object of Contract
        objContract1 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract1.collect__External_Id__c='MORTGAGE:123457_0';
        objContract1.ScCollection_Lender_Record__c='PEPPER-ARM';
        objContract1.ScCollection_Originator_ID__c='0001636';
        objContract1.ScCollection_Mortgage_Funding__c='ABC';
        update ObjContract1;
       
}
}