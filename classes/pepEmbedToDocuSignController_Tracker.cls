@isTest public class pepEmbedToDocuSignController_Tracker {
    
  
  @isTest static void pepEmbedToDocuSignController_3(){
       
         pepCommonTrackerController obj =new pepCommonTrackerController();
           Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
            string strCreditCategory = system.label.PepCreditCategory;
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
               
                    
                    pages_config__c objConfig = new pages_config__c();
                   objConfig.Page_Label__c='ThankYou';
                   objConfig.Name='pepthankyou';
                   insert objConfig;
                    pages_config__c objConfig1 = new pages_config__c();
                   objConfig1.Page_Label__c='GenericRedirection';
                   objConfig1.Name='pepgenericredirection';
                   insert objConfig1; 
                    
                    pepCmsPage__c objPage2 = pepCommonTrackerController.createPage('Application Complete');
                    //Section Creation
                    pepCmsSection__c objSection2 = new pepCmsSection__c();
                    objSection2 = pepCommonTrackerController.createSection1(objPage2);
                    update objSection2;
                    
                    pepCmsQuestion__c objQuestion=pepCommonTrackerController.createCmsQuestion(objPage2,objSection2);
                    
                    DocuSignCredentials__c objDocusignCredential = New DocuSignCredentials__c();
                    objDocusignCredential.Name  = 'DocuSignCreds';
                    objDocusignCredential.API_Account_ID__c = 'e727d211-5879-4106-8a1e-db6db8b51c34';
                    objDocusignCredential.API_Username__c = 'a5a260ff-e2ab-4542-a443-33729b4dd552';
                    objDocusignCredential.API_Password__c = 'Apr@2016';
                    objDocusignCredential.Integrated_Key__c = 'e1dbbae7-0e67-4dad-92a8-af0060b095e7';
                    objDocusignCredential.Webservice_URL__c = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
                    insert objDocusignCredential;
                    
                    Attachment attach = new Attachment();     
                    attach.Name ='Application Contract.pdf';
                    attach.ContentType = 'pdf';
                    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                    attach.body = bodyBlob;
                    attach.parentId=objApplication.id;
                    insert attach;
                    
                    genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
                    appDocCat =pepCommonTrackerController.createApplicationDocCat();
                    appDocCat.genesis__Application__c = objApplication.id;
                    appDocCat.Name  = strCreditCategory ;
                    update appDocCat ;
                    
                    
                 pepContractController  sc = new pepContractController();
                 Pagereference pd=Page.pepContract;
                 Test.setcurrentPagereference(pd);
                 pepEmbedToDocuSignController objController = new pepEmbedToDocuSignController(sc);
                 pepEmbedToDocuSignController objControllerNew = new pepEmbedToDocuSignController();
                 pepEmbedToDocuSignController.saveAttachmentPDF('test','text body',objApplication.id);
                 objControllerNew.configure();
                 pepEmbedToDocuSignController.updateEnvelopeId('12345',objApplication.id);
               //  pepEmbedToDocuSignController.rejectApplication();
              //   objControllerNew.checkcookie();
                 objControllerNew.updatecontractredirect();
                 
                
                
      
       }    
         
    @isTest static void pepEmbedToDocuSignController_1(){
       
         pepCommonTrackerController obj =new pepCommonTrackerController();
           Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
            string strCreditCategory = system.label.PepCreditCategory;
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
                  pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('Contract');
                    //Section Creation
                    pepCmsSection__c objSection1 = new pepCmsSection__c();
                    objSection1 = pepCommonTrackerController.createSection(objPage1);
                  //  update objSection1;
                    
                    pepCmsPage__c objPage2 = pepCommonTrackerController.createPage('Application Complete');
                    //Section Creation
                    pepCmsSection__c objSection2 = new pepCmsSection__c();
                    objSection2 = pepCommonTrackerController.createSection1(objPage2);
                    
                    //update objSection2;
                    
                    pages_config__c objConfig = new pages_config__c();
                   objConfig.Page_Label__c='ThankYou';
                   objConfig.Name='pepthankyou';
                   insert objConfig;
                    pages_config__c objConfig1 = new pages_config__c();
                   objConfig1.Page_Label__c='GenericRedirection';
                   objConfig1.Name='pepgenericredirection';
                   insert objConfig1; 
                   pages_config__c objConfig2 = new pages_config__c();
                   objConfig2.Page_Label__c='ContractDeclined';
                   objConfig2.Name='pepcontractdeclined';
                   insert objConfig2; 
                     pages_config__c objConfig21 = new pages_config__c();
                   objConfig21.Page_Label__c='ContractSigned';
                   objConfig21.Name='pepcontractsigned';
                   insert objConfig21; 
                                       
                    DocuSignCredentials__c objDocusignCredential = New DocuSignCredentials__c();
                    objDocusignCredential.Name  = 'DocuSignCreds';
                    objDocusignCredential.API_Account_ID__c = 'e727d211-5879-4106-8a1e-db6db8b51c34';
                    objDocusignCredential.API_Username__c = 'a5a260ff-e2ab-4542-a443-33729b4dd552';
                    objDocusignCredential.API_Password__c = 'Apr@2016';
                    objDocusignCredential.Integrated_Key__c = 'e1dbbae7-0e67-4dad-92a8-af0060b095e7';
                    objDocusignCredential.Webservice_URL__c = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
                    insert objDocusignCredential;
                    
                    Attachment attach = new Attachment();     
                    attach.Name ='Application Contract.pdf';
                    attach.ContentType = 'pdf';
                    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                    attach.body = bodyBlob;
                    attach.parentId=objApplication.id;
                    insert attach;
                    
                    genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
                    appDocCat =pepCommonTrackerController.createApplicationDocCat();
                    appDocCat.genesis__Application__c = objApplication.id;
                    appDocCat.Name  = strCreditCategory ;
                    update appDocCat ;
                    
                    
                 pepContractController  sc = new pepContractController();
                 Pagereference pd=Page.pepContract;
                 Test.setcurrentPagereference(pd);
                 Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
                 pd.setcookies(new cookie[]{Applicationid});
                 pepEmbedToDocuSignController objController = new pepEmbedToDocuSignController(sc);
                 pepEmbedToDocuSignController objControllerNew = new pepEmbedToDocuSignController();
                 objControllerNew.getPopURL();
                 objControllerNew.fetchSignedPDF();
                 objControllerNew.embedDocuSignOpen();
                 pepEmbedToDocuSignController.saveAttachmentPDF('test','text body',objApplication.id);
                 objControllerNew.configure();
                
                
      
       }       
       
       @isTest static void pepEmbedToDocuSignController_2(){
       
         pepCommonTrackerController obj =new pepCommonTrackerController();
           Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
            string strCreditCategory = system.label.PepCreditCategory;
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
                 
                    
                    pepCmsPage__c objPage2 = pepCommonTrackerController.createPage('Application Complete');
                    //Section Creation
                    pepCmsSection__c objSection2 = new pepCmsSection__c();
                    objSection2 = pepCommonTrackerController.createSection1(objPage2);
                    update objSection2;
                    
                    pages_config__c objConfig = new pages_config__c();
                   objConfig.Page_Label__c='ThankYou';
                   objConfig.Name='pepthankyou';
                   insert objConfig;
                    pages_config__c objConfig1 = new pages_config__c();
                   objConfig1.Page_Label__c='GenericRedirection';
                   objConfig1.Name='pepgenericredirection';
                   insert objConfig1;        
                            
                    pepCmsQuestion__c objQuestion=pepCommonTrackerController.createCmsQuestion(objPage2,objSection2);
                    
                    DocuSignCredentials__c objDocusignCredential = New DocuSignCredentials__c();
                    objDocusignCredential.Name  = 'DocuSignCreds';
                    objDocusignCredential.API_Account_ID__c = 'e727d211-5879-4106-8a1e-db6db8b51c34';
                    objDocusignCredential.API_Username__c = 'a5a260ff-e2ab-4542-a443-33729b4dd552';
                    objDocusignCredential.API_Password__c = 'Apr@2016';
                    objDocusignCredential.Integrated_Key__c = 'e1dbbae7-0e67-4dad-92a8-af0060b095e7';
                    objDocusignCredential.Webservice_URL__c = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
                    insert objDocusignCredential;
                    
                    Attachment attach = new Attachment();     
                    attach.Name ='Application Contract.pdf';
                    attach.ContentType = 'pdf';
                    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                    attach.body = bodyBlob;
                    attach.parentId=objApplication.id;
                    insert attach;
                    
                    genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
                    appDocCat =pepCommonTrackerController.createApplicationDocCat();
                    appDocCat.genesis__Application__c = objApplication.id;
                    appDocCat.Name  = strCreditCategory ;
                    update appDocCat ;
                    
                    
                 pepContractController  sc = new pepContractController();
                 Pagereference pd=Page.pepContract;
                 Test.setcurrentPagereference(pd);
                 Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
                 pd.setcookies(new cookie[]{Applicationid});
                 pepEmbedToDocuSignController objController = new pepEmbedToDocuSignController(sc);
                 pepEmbedToDocuSignController objControllerNew = new pepEmbedToDocuSignController();
                 pepEmbedToDocuSignController.saveAttachmentPDF('test','text body',objApplication.id);
                 objControllerNew.configure();
                 pepEmbedToDocuSignController.updateEnvelopeId('12345',objApplication.id);
                 pepEmbedToDocuSignController.rejectApplication();
                 objControllerNew.checkcookie();
                 objControllerNew.updatecontractredirect();
                 
                
                
      
       }       
 }