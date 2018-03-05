@isTest(SeeAllData=False)
Private class COCSyncScheduler_Test{
Private Static User us;
Private static Account Accnt;
Private testmethod static void testmethod1(){
us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
loadcustomsetting();
System.runas(us){
loaddata();
}
Test.StartTest();
String hour = String.valueOf(Datetime.now().hour());
String min = String.valueOf(Datetime.now().minute() + 1); 
String ss = String.valueOf(Datetime.now().second());

//parse to cron expression
String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

String timeToSchedule=String.valueof(DateTime.now()+1);
CocSyncScheduler s = new CocSyncScheduler(); 
String jobId=System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);
// Get the information from the CronTrigger API object

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,

         NextFireTime

         FROM CronTrigger WHERE id = :jobId];

 

      // Verify the expressions are the same

      System.assertEquals(nextFireTime,

         ct.CronExpression);
     System.assertequals(0,ct.TimesTriggered);
Test.stopTest();
List<staging_Property__c> stagingPropertyList = [Select id from staging_Property__c];
System.assert(stagingpropertyList.size()>0,'Assertion testing here');
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

List<Staging_Property__c> stagingProperties = new List<Staging_Property__c>();
//insert source system
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');

        //Insert Object of Contract
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        System.debug('@@@@@@'+objContract);
        objContract.collect__External_Id__c='MORTGAGE:123456_0';
        objContract.ScCollection_Lender_Record__c='PEPPER-ARM';
        objContract.ScCollection_Originator_ID__c='0001636';
        objContract.ScCollection_Mortgage_Funding__c='ABC';
        objContract.collect__Account__c=Accnt.id;
        update ObjContract;
        //Insert Object of another Contract
        collect__Loan_Account__c objContract1 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract1.collect__External_Id__c='MORTGAGE:123457_0';
        objContract1.ScCollection_Lender_Record__c='PEPPER-MANUAL';
        objContract1.ScCollection_Originator_ID__c='0001636';
        objContract1.ScCollection_Mortgage_Funding__c='ABC';
        objContract1.collect__Account__c=Accnt.id;
        update ObjContract1;
        //Insert Object of another Contract
        collect__Loan_Account__c objContract2 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        objContract2.collect__External_Id__c='MORTGAGE:123458_0';
        objContract2.ScCollection_Lender_Record__c='PEPPER-NXG';
        objContract2.ScCollection_Originator_ID__c='0001636';
        objContract2.ScCollection_Mortgage_Funding__c='ABC';
        objContract2.collect__Account__c=Accnt.id;
        update ObjContract2;
        Staging_Property__c sp = new Staging_Property__c(Property_external_Id__c='0123451',Name='0123451',Source_Name__c='MORTGAGE');
        stagingProperties.add(sp);
        Staging_Property__c sp3 = new Staging_Property__c(Property_external_Id__c='0234511',Name='0234511',Source_Name__c='MORTGAGE');
        stagingProperties.add(sp3);
        Staging_Property__c sp4 = new Staging_Property__c(Property_external_Id__c='0234512',Name='0234512',Source_Name__c='MORTGAGE');
        stagingProperties.add(sp4);
        Staging_Property__c sp1 = new Staging_Property__c(Property_external_Id__c='0234513',Name='0234513',Source_Name__c='PAF');
        stagingProperties.add(sp1);
        Staging_Property__c sp2 = new Staging_Property__c(Property_external_Id__c='0876521',Name='0876521',Source_Name__c='');
        stagingProperties.add(sp2);
        insert stagingProperties;
        StagingProperty_Surrogate__c stagingPropSurrogate = new StagingProperty_Surrogate__c(name=stagingProperties[0].Property_external_Id__c+'_'+objContract.Collect__External_Id__c,Property_External_Id__c=stagingProperties[0].Property_external_Id__c,LoanSurrogateExternalID__c=objContract.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[0].Property_external_Id__c+'_'+objContract.Collect__External_Id__c,Registration_Status__c='R');
        insert stagingPropSurrogate;
        StagingProperty_Surrogate__c stagingPropSurrogate3 = new StagingProperty_Surrogate__c(name=stagingProperties[1].Property_external_Id__c+'_'+objContract1.Collect__External_Id__c,Property_External_Id__c=stagingProperties[1].Property_external_Id__c,LoanSurrogateExternalID__c=objContract1.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[1].Property_external_Id__c+'_'+objContract1.Collect__External_Id__c,Registration_Status__c='R');
        insert stagingPropSurrogate3;
        StagingProperty_Surrogate__c stagingPropSurrogate4 = new StagingProperty_Surrogate__c(name=stagingProperties[2].Property_external_Id__c+'_'+objContract2.Collect__External_Id__c,Property_External_Id__c=stagingProperties[2].Property_external_Id__c,LoanSurrogateExternalID__c=objContract2.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[2].Property_external_Id__c+'_'+objContract2.Collect__External_Id__c,Registration_Status__c='R');
        insert stagingPropSurrogate4;
        Staging_Property_Insurer__c stagPropertyInsurer = new Staging_Property_Insurer__c(Name='Insurer1',Property_Insurer_External_Id__c='Insurer1',Insurer__c='Insurer');
        insert  stagPropertyInsurer;
        Staging_Property_Valuation__c prpValuation=new Staging_Property_Valuation__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),Property_external_id__c=stagingProperties[1].Property_external_Id__c,Property_Valuation_external_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),DWH_Valuation_Date__c=System.today()-2);
        insert prpValuation;
        Staging_Property_Insurance__c stagingPropertyInsurance = new Staging_Property_Insurance__c(Name=stagingProperties[0].Property_external_Id__c+':'+System.Today()+14,Property_External_Id__c=stagingProperties[0].Property_external_Id__c,DWH_Propert_Ins_Exp_Date__c=System.Today()+14,Property_Insurer_External_ID__c='Insurer1',Property_Insurance_External_Id__c=stagingProperties[0].Property_external_Id__c+':'+System.Today()+14,Source_Name__c='MORTGAGE');
        insert stagingPropertyInsurance;
        StagingProperty_Surrogate__c stagingPropSurrogate1 = new StagingProperty_Surrogate__c(name=stagingProperties[1].Property_external_Id__c+'_'+objContract.Collect__External_Id__c,Property_External_Id__c='test',LoanSurrogateExternalID__c=objContract.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[0].Property_external_Id__c+'_'+objContract.Collect__External_Id__c);
        insert stagingPropSurrogate1;
        Staging_Property__c sp7 = new Staging_Property__c(Property_external_Id__c='9897865',Name='0123451',Source_Name__c='MORTGAGE');
        stagingProperties.add(sp7);
        Staging_Property_Valuation__c prpValuation1=new Staging_Property_Valuation__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),Property_external_id__c='8789068',Property_Valuation_external_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),DWH_Valuation_Date__c=System.today()-2);
        insert prpValuation1;
        Staging_Property_Insurance__c stagingPropertyInsurance1 = new Staging_Property_Insurance__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-1),Property_External_Id__c=stagingProperties[1].Property_external_Id__c,DWH_Propert_Ins_Exp_Date__c=System.Today()-1,Property_Insurer_External_ID__c='Insurer1',Property_Insurance_External_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-1),Source_Name__c='MORTGAGE');
        insert stagingPropertyInsurance1;
        Staging_Property_Insurance__c stagingPropertyInsurance2 = new Staging_Property_Insurance__c(Name=stagingProperties[2].Property_external_Id__c+':'+String.valueof(System.Today()+7),Property_External_Id__c=stagingProperties[2].Property_external_Id__c,DWH_Propert_Ins_Exp_Date__c=System.Today()+7,Property_Insurer_External_ID__c='Insurer1',Property_Insurance_External_Id__c=stagingProperties[2].Property_external_Id__c+':'+String.valueof(System.Today()+7),Source_Name__c='MORTGAGE');
        insert stagingPropertyInsurance2;
       
        
}
Private static void loadcustomsetting(){
PropertyInsuranceCredentials__c crd = new PropertyInsuranceCredentials__c(Name='Credentials',Username__c='pepper',Password__c='P3pp3rPa55',endpoint__c='https://pepperpropertyinsurance-sandbox.au.cloudhub.io');
insert crd;
List<StatusTOExcludeForCOC__c> statusesToexculde = new List<StatusTOExcludeForCOC__c>();
StatusTOExcludeForCOC__c ccostatus1 = new StatusTOExcludeForCOC__c(Name='Discharged');
statusesToexculde.add(ccostatus1);
StatusTOExcludeForCOC__c ccostatus2 = new StatusTOExcludeForCOC__c(Name='Discharge Pending');
statusesToexculde.add(ccostatus2);
StatusTOExcludeForCOC__c ccostatus3 = new StatusTOExcludeForCOC__c(Name='Claim');
statusesToexculde.add(ccostatus3);
StatusTOExcludeForCOC__c ccostatus4 = new StatusTOExcludeForCOC__c(Name='Mortgagee in Possession');
statusesToexculde.add(ccostatus4);
insert statusesToexculde;
List<SMSText__c> smsTexts = new List<SMSText__c>();
SMSText__c sms1 = new SMSText__c(Name='Before14Days',SMS_Text__c='Your insurance is getting expired within 14 days so please mail your updated COC on abc@gmail.com.');
smsTexts.add(sms1); 
SMSText__c sms2 = new SMSText__c(Name='After1Day',SMS_Text__c='Your Insurance has ben expired so please mail your updated COC at abc@gmail.com.');
smsTexts.add(sms2);
insert smsTexts; 
List<LenderRecordsForCOC__c> customsetting = new List<LenderRecordsForCOC__c>();
LenderRecordsForCOC__c lenderRecordsCoc1 = new LenderRecordsForCOC__c(Name='PEPPER-ARM');
customsetting.add(lenderRecordsCoc1);
LenderRecordsForCOC__c lenderRecordsCoc2 = new LenderRecordsForCOC__c(Name='PEPPER-NXG');
customsetting.add(lenderRecordsCoc2);
LenderRecordsForCOC__c lenderRecordsCoc3 = new LenderRecordsForCOC__c(Name='PEPPER-MANUAL');
customsetting.add(lenderRecordsCoc3);
LenderRecordsForCOC__c lenderRecordsCoc4 = new LenderRecordsForCOC__c(Name='PEPPER    ARM        -');
customsetting.add(lenderRecordsCoc4); 
LenderRecordsForCOC__c lenderRecordsCoc5 = new LenderRecordsForCOC__c(Name='PEPPER    NXG        -');
customsetting.add(lenderRecordsCoc5); 
LenderRecordsForCOC__c lenderRecordsCoc6 = new LenderRecordsForCOC__c(Name='PEPPER    MANUAL        -');
customsetting.add(lenderRecordsCoc6);
insert customsetting;
}
}