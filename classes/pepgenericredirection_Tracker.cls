@isTest(SeeAllData=False) private class pepgenericredirection_Tracker{
    
   @isTest static void pepgenericredirectionTest(){
                    pepCommonTrackerController obj =new pepCommonTrackerController();
                    Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
                    list<pepCmsSection__c> lstSection = new list<pepCmsSection__c>();
                test.startTest();     
                    genesis__Applications__c objApplication = new genesis__Applications__c();
                    RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
                    objApplication = genesis.TestHelper.createApplication();
                    objApplication.Debit_Frequency__c ='bi-weekly';
                    objApplication.RedirectToContract__c = true;
                    objApplication.genesis__Account__c = objAccount.id;
                    update objApplication; 
                 test.stopTest();     
                    Application__c objApp = new Application__c();
                    objApp=pepCommonTrackerController.createApplication();
                    pages_config__c pg1 = new pages_config__c(Name='pepgenericredirection',Page_label__c='GenericRedirection');
                    insert pg1;
                    Pagereference pd=Page.pepGenericRedirection;
                    Test.setcurrentPagereference(pd);
                    
                    Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
                    pd.setcookies(new cookie[]{Applicationid});
                    
                    pepgenericredirection objController = new pepgenericredirection();
                    Technical_Error_Email_Group__c terEmailGrp = new Technical_Error_Email_Group__c(Name='TechnicalErrorGroup',Email__c='varun.arora@saasfocus.com',Mobile__c='04141369952');
                    insert terEmailGrp;
                    Technical_Error_Email_Group__c terEmailGrp1 = new Technical_Error_Email_Group__c(Name='AutomaticEmail/SMS',Email__c='varun.arora@saasfocus.com',Mobile__c='04141369952',Disable_Automatic_Notification__c=False,Email_SMS_count__c=0);
                    insert terEmailGrp1;
                    objcontroller.sendTechnicalerroremail();
    
    }
    
 }