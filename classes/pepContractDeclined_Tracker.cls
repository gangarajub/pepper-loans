@isTest
public class pepContractDeclined_Tracker 
{
    @isTest static void Method_1() 
    {
           pages_config__c pg11 = new pages_config__c(Name='pepdeclinedcontract',Page_Label__c='DeclinedContract');
            insert pg11;
             genesis__Applications__c objApplication = new genesis__Applications__c();
            RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
            objApplication = genesis.TestHelper.createApplication();
            genesis.TestHelper.createApplication(); 
            objApplication.Debit_Frequency__c ='bi-weekly';
           // objApplication.genesis__Account__c = acc.id;
            objApplication.Serviceability_Status__c = 'Approved';
            objApplication.pepLastSaved__c = system.now();
            update objApplication; 
           
             Pagereference pd=Page.pepdeclinedcontract;
        Test.setcurrentPagereference(pd); 
            
             Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
                pd.setcookies(new cookie[]{Applicationid});

        
         pepContractDeclined objclass=new pepContractDeclined ();
         
          ApexPages.currentPage().getParameters().put('id', 'abc123');
          pepContractDeclined objclass1=new pepContractDeclined ();
          
    }
}