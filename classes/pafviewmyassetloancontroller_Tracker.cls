@isTest
public class pafviewmyassetloancontroller_Tracker 
{
    @isTest static void pafviewmyassetloancontrollerTest0() 
    {
        
        UserRole portalRole1;
        user objUser1;
        collect__Loan_Account__c objLoanAccount;
        case cse;
        case cse1;
        case cse2;
        case cse3;
        Account objAccount;
        
         
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
            pages_config__c objPageConfig = new pages_config__c();
            objPageConfig.Page_Label__c = 'ViewMyAssetLoanPage';
            objPageConfig.Name = 'pafviewmyassetloanpage';
            insert objPageConfig;
            
            collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
            
            objLoanAccount = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
            objLoanAccount.pafss_Loan_Name__c = 'loan name';
            objLoanAccount.ScCollection_Minimum_Monthly_Installment__c = 2000;
            objLoanAccount.ScCollection_Next_Installment_Date__c = system.Today()+40;
            objLoanAccount.ScCollection_All_Cash_Received__c = 2000;
            objLoanAccount.ScCollection_Current_Principal__c = 200;
            objLoanAccount.ScCollection_Settled_Date__c = system.today()+50;
            objLoanAccount.ScCollection_Contract_End_Date__c = system.today()+50;
            objLoanAccount.collect__Last_Payment_Amount__c = 2000;
            objLoanAccount.ScCollection_Residual_Amount__c = 30000;
            objLoanAccount.ScCollection_Introducer__c = 'introducer';
            objLoanAccount.ScCollection_All_Cash_Received__c =5000;
            update objLoanAccount;
            
            pepCmsPage__c objPage = pepCommonTrackerController.createPage('PAFLoanDetails');
            pepCmsSection__c  sect = pepCommonTrackerController.createSection(objPage);
            sect.pepSectionUniqueName__c='PAFLoanDetailsSection11';
            update sect;  
            
            pepCmsQuestion__c objQues = pepCommonTrackerController.createCmsQuestion(objPage,sect);
            objQues.pepType__c ='Button';
            update objQues;
            
            pepCmsPage__c objPage1 = pepCommonTrackerController.createPage('DashboardSideBarTemplate');
            pepCmsSection__c  sect1 = pepCommonTrackerController.createSection(objPage1);
            
            pepCmsQuestion__c objQues1 = pepCommonTrackerController.createCmsQuestion(objPage1,sect);
            objQues1.pepType__c ='Button';
            update objQues1;
           
           objAccount= new Account();
           objAccount.name = 'testAcc';
           objAccount.Loan_Account_Id__c = objLoanAccount.id;
           insert objAccount;
           
            cse = new case ();
            cse.accountid = objAccount.id;
            cse.pafss_Contract__c = objLoanAccount.id;
            cse.status = 'Open';
            cse.subject = 'Bank and Payment Details Request';
            insert cse;
       /*     
            cse2 = new case ();
            cse2.accountid = objAccount.id;
            cse2.pafss_Contract__c = objLoanAccount.id;
            cse2.status = 'Open';
            cse2.subject = 'Bank and Payment ';
            insert cse;
         */   
            
          
     
           contact objContact1 = new contact();
           objContact1.LastName ='test';
           objContact1.accountId = objAccount.id;
           insert objContact1;    
           Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner','Custom Customer Community Login user', 'PowerCustomerSuccess',   'CustomerSuccess'};
           profile  p = [select Id,name from Profile where name in :customerUserTypes limit 1];
           
            objuser1 = new User();
            objUser1.profileId = p.id;
            objuser1.userName ='newUser@yahoo.com';
            objUser1.email ='amit@test.com';
            objUser1.emailencodingkey ='UTF-8';
            objUser1.localesidkey ='en_US';
            objUser1.languagelocalekey ='en_US';
            objUser1.timezonesidkey ='America/Los_Angeles';
            objUser1.alias ='ak';
            objUser1.lastname ='kumar';
            objUser1.contactId =objContact1.Id;
            insert objUser1;
           
           
           
        }
        
         system.runas(objUser1)     
        {
             PageReference pageRef = Page.pafviewmyassetloanpage;
            Test.setCurrentPagereference(pageRef);
            pafviewmyassetloancontroller objLoans = new pafviewmyassetloancontroller();
            objLoans.idLoanAccount = objLoanAccount.id;
            objLoans.changeloanName();
            objLoans.updateAccount();
            
            
            objLoans.assignedPage = 'updatePayment';
            objLoans.checkCase();
            
            objLoans.assignedPage = 'RequestStatement';
            cse.subject = 'Statement Request';
            update cse;
            objLoans.checkCase();
            objLoans.createCase();
            
            objLoans.assignedPage = 'payoutFigure';
            cse.subject = 'Payout Figure Request';
            update cse;
            objLoans.checkCase();
            objLoans.createCase();
            
            cse1 = new case ();
            cse1.accountid = objAccount.id;
            cse1.pafss_Contract__c = objLoanAccount.id;
            cse1.status = 'RequestStatement';
            cse1.subject = 'Statement Request';
            insert cse1;
            
            cse3 = new case ();
            cse3.accountid = objAccount.id;
            cse3.pafss_Contract__c = objLoanAccount.id;
            cse3.status = 'payoutFigure';
            cse3.subject = 'Payout Figure Request';
            insert cse3;
            
            
           objLoanAccount.ScCollection_Next_Installment_Date__c = system.Today();
           update objLoanAccount;
           
            pafviewmyassetloancontroller objLoans1 = new pafviewmyassetloancontroller();
            objLoans1.assignedPage = 'payoutFigure';
            objLoans1.checkCase();
            objLoans1.assignedPage = 'RequestStatement';
            objLoans1.checkCase();
             objLoans1.assignedPage = 'updatePayment';
            objLoans1.checkCase();
            objLoans1.Step =1;
            objLoans1.strName='ahha';
            objLoans1.hideHeader =false;
            objLoans1.caseDate='ah';
            objLoans1.caseMonth='1';
            objLoans1.assetDescription='aka';
            objLoans1.registeredInsurer='ja';
            objLoans1.loanStatus='a';
            objLoans1.headerLoanNo='a';
                
            
        }
        }
}