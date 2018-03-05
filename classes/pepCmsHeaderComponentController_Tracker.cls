@isTest(SeeAllData=False) public class pepCmsHeaderComponentController_Tracker {
    
    @isTest static void pepCmsHeaderComponentTest(){
        loan.testhelper.createSeedDataForTesting();
        
        pepCmsPage__c objPepCmsPage = pepCommonTrackerController.createPage('Header');
        
        pepCmsSection__c objPepCmsSection = pepCommonTrackerController.createSection1(objPepCmsPage);
        objPepCmsSection.pepSectionUniqueName__c='Loan';
        objPepCmsSection.pepSectionStoryRich__c='test stort rich';
        update objPepCmsSection;
        
        Account acc = new Account();
        acc = pepCommonTrackerController.createAccount();
        
        pages_config__c objConfig = new pages_config__c();
                   objConfig.Page_Label__c='IncomePage';
                   objConfig.Name='pepincomepage';
                   insert objConfig;
                   
                    pages_config__c objConfig1 = new pages_config__c();
                   objConfig1.Page_Label__c='loandetails';
                   objConfig1.Name='peploandetails';
                   insert objConfig1;
       Application__c objAppNav = new Application__c();
       objAppNav.Name='pepIncomePage';
       objAppNav.Navigation_Status__c='Income';
       objAppNav.RedirectPage__c='pepIncomePage';
       insert objAppNav;
        
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      
        genesis__Applications__c objApplication = new genesis__Applications__c();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Requested_Loan_Amount__c=10000;
        objApplication.Debit_Frequency__c ='bi-weekly';
        //objApplication.Purpose_Name__c='abc';
        objApplication.Debit_Amount__c=2000;
        objApplication.genesis__Status__c='APPROVE';
        objApplication.genesis__Account__c=acc.id;
        objApplication.Ret_Code__c='1111';
        objApplication.genesis__Expected_Close_Date__c=System.today()+1;
        objApplication.pepNavigation_Status__c='Income';
        update objApplication;
        
        RetrievalApplicationStatus__c objRetAppStatus = new RetrievalApplicationStatus__c(Name='Retrieval Status',Retrieval_Status__c='APPROVED - DOCUMENT SIGNED,APPROVED - CONVERTED TO CONTRACT,REJECTED,DECLINED,CLOSED');
        insert objRetAppStatus ;
 
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objPepCmsPage.id;
        insert attach;
        
        
       // ApexPages.currentPage().getCookies().put('PageNo',1);
       
       pepCmsHeaderComponentController.CookieJar objwrap = new pepCmsHeaderComponentController.CookieJar(2);
       
        pepCmsHeaderComponentController objCmsHeader1 = new pepCmsHeaderComponentController();
        objCmsHeader1.inputValue='email';
        objCmsHeader1.retrieveEmail='test@email.com';
        objCmsHeader1.strRetrieveCode='1111';
        objCmsHeader1.setobjApplication(objApplication);
        objCmsHeader1.getobjApplication();
        objCmsHeader1.retrieveApplication();
        objCmsHeader1.resendCode();
        objCmsHeader1.setintCurrentPageNo(1);
        objCmsHeader1.getintCurrentPageNo();
        objCmsHeader1.setstrPurposeId(objPepCmsPage.id);
        objCmsHeader1.getstrPurposeId();
        objCmsHeader1.EditLink();
        objCmsHeader1.getBackgroundImage();
        objCmsHeader1.redirectToPages();
        objCmsHEader1.EditMethod();
        
        
        
        
       
        pepCmsHeaderComponentController objCmsHeader = new pepCmsHeaderComponentController();
        
        
        objCmsHeader.strPurposeId = objPepCmsPage.id;
        objCmsHeader.inputValue='mobile';
        objCmsHeader.retrievePhone='0434567890';  
        objCmsHeader.strRetrieveCode='1111';
        objCmsHeader.setobjApplication(objApplication);
        objCmsHeader.getobjApplication();
        objCmsHeader.retrieveApplication();
        objCmsHeader.resendCode();
        //objCmsHeader.strPurposeId='';
        objCmsHEader.getBackgroundImage();
        
        objCmsHeader.email='jsdh@skjdv.com';
        objCmsHeader.phone='124356';
        objCmsHEader.isdisplayRetrieve=true;
        objCmsHEader.isdisplayPersonDetail=true;
        objCmsHEader.isRetrieveApp=true;
        objCmsHeader.errorMsg='shb';
        objCmsHeader.strPurposeName='ks';
        objCmsHeader.pageNo=1;
        objCmsHeader.intpreviousPageNo=1;
        objCmsHeader.intRedirectPage=1;
                
        
        
    }

}