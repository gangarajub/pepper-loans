@isTest

public class pepJumioCallBackUrlControllerTracker
{

       private static  Account objAccount;
       private static genesis__Applications__c objApplication;
       private static pepJumio_Credentials__c objCredentials;  
       private static  void loadData()
       {
           createJumioCreds();
           createApplication();
           createAccount();       
       }
           
       
       
       //This method creates Jumio creds
       
       private static void createJumioCreds()
       {
           objCredentials = new pepJumio_Credentials__c();
           objCredentials.name ='Credential';
           objCredentials.pepActive_API_secret_c__c ='2RslQEASMgyoUMyGZzHVvmYWUXVI1BuC';
           objCredentials.pepEnd_Point__c ='https://netverify.com/api/netverify/v2/initiateNetverify';
           objCredentials.pepMerchant_API_token__c ='26ecb510-5d33-4b25-822f-ab8c6baf8d1b';
           insert objCredentials;
       }
           
       //This method creates account
       private static void createAccount()
       {     
         objAccount=  pepCommonTrackerController.createAccount();
         objAccount.Current_Application_Id__c = objApplication.id;
         objAccount.Tracking_Id__c  ='1234';
         update objAccount;     
           
       }
       //This method creates Application
       private static void createApplication()
       {
           RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();      
           objApplication =genesis.TestHelper.createApplication();
           
       }
       
       static testmethod void unitTest1()
       {
            Test.startTest();
            loadData();
            
            ApexPages.Currentpage().getParameters().put('jumioIdScanReference','1234');           
            pepJumioCallBackUrlController  objController = new pepJumioCallBackUrlController();
            
            ApexPages.Currentpage().getParameters().put('idScanImage','https://test.com');
            ApexPages.Currentpage().getParameters().put('idScanImageBackside','https://test.com');
            ApexPages.Currentpage().getParameters().put('idScanImageFace','https://test.com');
            ApexPages.Currentpage().getParameters().put('rejectReasonDescription','test'); 
            ApexPages.Currentpage().getParameters().put('strverificationStatus','APPROVED_VERIFIED');
             ApexPages.Currentpage().getParameters().put('strDob','10-03-1989');
              ApexPages.Currentpage().getParameters().put('idFaceMatch','92'); 
               ApexPages.Currentpage().getParameters().put('idFirstName','Test Example');
                ApexPages.Currentpage().getParameters().put('idScanSource','WEB_CAM');
            Test.setMock(HttpCalloutMock.class, new pepMockHttpResBankInfoGenerators());
            objController.saveData();
            Test.stopTest();
           
       }
       
       static testmethod void unitTest2()
       {
            
            createJumioCreds();            
            
            ApexPages.Currentpage().getParameters().put('rejectReasonDetails','test'); 
            ApexPages.Currentpage().getParameters().put('jumioIdScanReference','1234');           
            pepJumioCallBackUrlController  objController = new pepJumioCallBackUrlController();
            
            
            ApexPages.Currentpage().getParameters().put('idScanImage','https://test.com');
            ApexPages.Currentpage().getParameters().put('idScanImageBackside','https://test.com');
            ApexPages.Currentpage().getParameters().put('idScanImageFace','https://test.com');
            Test.setMock(HttpCalloutMock.class, new pepMockHttpResBankInfoGenerators());
            try
            {
                Test.startTest();
                objController.saveData();
                Test.stoptest();
            }
            catch(Exception e)
            {}
            
           
       }
       
        static testmethod void unitTest3()
       {
          createJumioCreds(); 
          loadData();
          ApexPages.Currentpage().getParameters().put('jumioIdScanReference','1234'); 
          ApexPages.Currentpage().getParameters().put('idScanImage','https://test.com');
          ApexPages.Currentpage().getParameters().put('idScanImageBackside','https://test.com');
          ApexPages.Currentpage().getParameters().put('idScanImageFace','https://test.com');
          pepJumioCallBackUrlController  objController = new pepJumioCallBackUrlController();
          ApexPages.Currentpage().getParameters().put('verificationStatus','APPROVED_VERIFIED');
          ApexPages.Currentpage().getParameters().put('idDob',String.ValueOf(System.today()));
          objController.saveData();
       
       }

    
}