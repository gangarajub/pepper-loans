@isTest(SeeAllData=False)
private class pepDeclinedContractController_Tracker 
{
    
     @isTest static void pepDeclinedContractControllerTest0() {
     
    
           pepCommonTrackerController obj =new pepCommonTrackerController();
           Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
           list<pepCmsSection__c> lstSection = new list<pepCmsSection__c>();
            test.startTest();
                genesis__Applications__c objApplication = new genesis__Applications__c();
                RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
                objApplication = genesis.TestHelper.createApplication();
                objApplication.Debit_Frequency__c ='bi-weekly';
             //   objApplication.Decline_Reason__c ='some text';
                objApplication.genesis__Account__c = objAccount.id;
                update objApplication; 
             test.stopTest();  
             
           

                
                pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Application Close');
                    //Section Creation
                    pepCmsSection__c objSection1 = new pepCmsSection__c();
                    objSection1 = pepCommonTrackerController.createSection1(objPage1);
                    objSection1.pepSectionUniqueName__c = 'App Close Section2';
                    objSection1.pepType__c = 'Running Text';
                    objSection1.pepSectionBodyRich__c ='hi {!ACCOUNT_NAME}';
                    update objSection1;
                    lstSection.add(objSection1);
                    
                     pepCmsSection__c objSection2 = new pepCmsSection__c();
                    objSection2 = pepCommonTrackerController.createSection1(objPage1);
                    objSection2.pepSectionUniqueName__c = 'ThanksContent';
                    objSection2.pepType__c = 'Running Text';
                    objSection2.pepSectionBodyRich__c ='hi {!ACCOUNT_NAME}';
                    update objSection2;
                    lstSection.add(objSection2);
                    
                    pepCmsSection__c objSection3 = new pepCmsSection__c();
                    objSection3 = pepCommonTrackerController.createSection1(objPage1);
                    objSection3.pepSectionUniqueName__c = 'App Close Section12';
                    objSection3.pepType__c = 'Running Text';
                    objSection3.pepSectionBodyRich__c ='hi {!ACCOUNT_NAME}';
                    update objSection3;
                    lstSection.add(objSection3);
                    
                    
                    
                ApexPages.StandardController sc = new ApexPages.StandardController(objApplication);
               
                Pagereference pd=Page.pepDeclinedContract;
                pd.getParameters().put('id',String.valueOf(objApplication.Id));
                Test.setcurrentPagereference(pd);
                pages_config__c pg = new pages_config__c(Name='pepdeclinedcontract',Page_Label__c='DeclinedContract');
                insert pg;
                Cookie cookieApplicationId =new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
                pd.setcookies(new cookie[]{cookieApplicationId});
                
                pepDeclinedContractController objClass = new pepDeclinedContractController(sc);
                objClass.lstSection = lstSection;
                objClass.getRedirectToLandingPage();
                objClass.checkcookie();
                loan.testhelper.createSeedDataForTesting();
                objClass.rejectApplication();
                
               
           }
           
          
}