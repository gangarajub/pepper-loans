@isTest(SeeAllData=False)
private class pepBankInformationDetails_Tracker
{

    static testMethod void validate()
    {
          pages_config__c pg = new pages_config__c(Name='pepuploadfinancialdoc',Page_Label__c='UploadFinancialDoc');
        insert pg;  
        
         pages_config__c pg1 = new pages_config__c(Name='peploansetupuploadeddocs',Page_Label__c='LoanSetupUploadedDocs');
        insert pg1;  
        Application__c app = new Application__c(Name='pepLoanSetupUploadedDocs',RedirectPage__c='pepLoanSetupUploadedDocs',Navigation_status__c='LoanSetup-BankStatementDocuments');
        insert app;
     
        genesis__Applications__c objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication.Debit_Frequency__c ='bi-weekly';
        update objApplication;
        Pagereference pd=Page.pepLoanSetupUploadedDocs;
        Test.setcurrentPagereference(pd);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd.setcookies(new cookie[]{Applicationid});
        
        
        genesis__Application_Document_Category__c appDocCat = new genesis__Application_Document_Category__c();
        appDocCat = pepCommonTrackerController.createApplicationDocCat();
        appDocCat.Name = 'BankStatement.com.au';
        appDocCat.genesis__Application__c = objApplication.Id;
        update appDocCat;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        attach.ContentType = 'image/jpeg';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=appDocCat.id;
        insert attach;
        
        
        //Insert custom setting data
        pepBank_Statement_Credential__c objBankstmtCredential = new pepBank_Statement_Credential__c();
        objBankstmtCredential.name='Credential';
        objBankstmtCredential.pepEndPoint_Url__c='https://test.bankstatements.com.au/api/v1';
        objBankstmtCredential.pepX_API_KEY__c='BKZYR9ACQMMUVYHVCLEN1B6AUOJLATYRXQO1PIKF';
        insert objBankstmtCredential; 
        
        
        //Call the Bank statement Request class
        pepBankStatementRequest objrequest = new pepBankStatementRequest();
        List<pepBankInstitution.Credential> clList1 = new List<pepBankInstitution.Credential>();
        list<String> lstUserCredentials = new list<String>();
        lstUserCredentials.add('strTest');
        list<string> lstUserQuearyType = new list<String>();
        lstUserQuearyType.add('str1Test');
        objrequest.initiate('str', lstUserCredentials, lstUserQuearyType,false, objApplication.id, 'str2');
        objrequest.PreloadFetchCaptcha('HDFC');
        
       
        pepBankStmtAPIResponse responseCls = new pepBankStmtAPIResponse();
        List<pepBankStmtAPIResponse.cls_accounts> responseCls1 = new List<pepBankStmtAPIResponse.cls_accounts>();
        pepBankStmtAPIResponse.cls_accounts resPonseWrap = new pepBankStmtAPIResponse.cls_accounts ();
           // resPonseWrap.chk_box = true;
            resPonseWrap.accountHolder='testholder';
            resPonseWrap.name='test'; 
            resPonseWrap.accountNumber='123456'; 
            resPonseWrap.id='423897';
            resPonseWrap.bsb='test';
            resPonseWrap.balance='987654';  
            resPonseWrap.available='testavl';
          responseCls1.add(resPonseWrap);
        
        pepBankStatementResponse bankRes = new pepBankStatementResponse();
        pepBankStatementResponse.bankSatementResponseSuccessorFailure wrpclass = new pepBankStatementResponse.bankSatementResponseSuccessorFailure(responseCls,true,'Successful Hit.');
        wrpclass.success = true;
        
        //call Bank Institution class
        List<pepBankInstitution.Credential> clList2 = new List<pepBankInstitution.Credential>();
        pepBankInstitution.Credential objCredWrap = new pepBankInstitution.Credential();
        clList2.add(objCredWrap) ;
        pepBankInstitution objBankInstitute = new pepBankInstitution('str', 'str1', 'str2', 'str3', 'str4', 'str5', 'str6', 'str7', 'str8', 'str9', 'one', 'str11', 'str12', 'str13',clList2);
        objBankInstitute.requires_preload = '1';
        
        
        /******************call the BankInformationDetails class ******************/
        pepBankInformationDetails  objwlbankinfo = new pepBankInformationDetails ();
        
        List<pepBankInformationDetails.AllAccountsClass> clsobjacc1 = new List<pepBankInformationDetails.AllAccountsClass>();
        pepBankInformationDetails.AllAccountsClass clsobjacc=new pepBankInformationDetails.AllAccountsClass();
        clsobjacc.chk_box = true;
        clsobjacc.accountHolder='testholder';
        clsobjacc.name='test'; 
        clsobjacc.accountNumber='123456'; 
        clsobjacc.id='423897';
        clsobjacc.bsb='test';
        clsobjacc.balance='987654';  
        clsobjacc.available='testavl';
        clsobjacc1.add(clsobjacc); 
        
        
        //objwlbankinfo.lstBankAccounts=clsobjacc1;
        objwlbankinfo.lstCredentials = clList2;
       objwlbankinfo.SelectBankName();
        objwlbankinfo.strBankSlugName='bank_of_statements';
       test.starttest();
        Test.setMock(HttpCalloutMock.class, new pepMockHttpResBankInfoGenerators());
        objwlbankinfo.SelectBankName();
        
        pepBankInformationDetails.ErrorMessage clsobjerror=new pepBankInformationDetails.ErrorMessage();
        clsobjerror.error='error';
        clsobjerror.errorcode=123;
        clsobjerror.user_token='usertoken';
                
        Test.setMock(HttpCalloutMock.class, new pepMockHttpResBankInfo());
        objwlbankinfo.BankLogin();
        
       objwlbankinfo.lstBankAccounts=clsobjacc1;
       Test.stoptest(); 
        objwlbankinfo.FetchStatements();
     
        objwlbankinfo.gobackmethod();
        objwlbankinfo.getCookieData();
        objwlbankinfo.redirectToNextPage();
        pepBank_API_Details__c bankApiDet = new pepBank_API_Details__c();
        bankApiDet.pepBank_Name__c = 'str';
        bankApiDet.pepBank_Short_Name__c = 'str';
        insert bankApiDet;
        pepBankInformationDetails.AutoCompleteBanklList('str');
        objwlbankinfo.loginType = 'testLoginType';
        objwlbankinfo.strSelectedOption = 'selectTestOption';
        objwlbankinfo.captchaImgUrl = 'testImgUrl';
         
    }
    
}