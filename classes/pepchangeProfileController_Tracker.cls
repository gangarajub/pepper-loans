@isTest(SeeAllData=False)

private class pepchangeProfileController_Tracker 
{
    private static user objUser;
    private static  Account objAccount;
    private static Contact objContact;
    private static loan__Loan_Account__c objLoanAccount;
    private static pepCmsPage__c objPage;
    private static pepCmsSection__c objSection;
    private static pepCmsQuestion__c objQues;
    private static Residential_Address__c objRes;
    private static userRole objUserRole;
    public static void loadData()
    {
        User objUser1 =[Select id from user where userRoleId !=null and isactive=true and Profile.name='System Administrator' limit 1];
        System.runAs(objUser1 )
        {
       
        createAccount();
        createResidentialAddress();
        createLoanAccount();
        createContact();
        createPage();
        createSection();
        createQuestion();
        DashboardPAFSetting__c objDS = new DashboardPAFSetting__c();
        objDS.Name ='PAFDashboardSetting';
        objDS.PAF_Dashboard_Checkbox__c = true;
        insert objDS;
        
        clcommon__Party_Type__c oPT = new clcommon__Party_Type__c();
        oPT.Name = 'aaa';
        oPT.pafss_Is_Individual_Loan__c =true;
        oPT.ScCollection_is_ATP__c = true;
        oPT.ScCollection_Only_For_ESB__c =true;
        insert oPT;
        
        collect__Source_System__c  oSS = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c oLA = ScCollection_CommonTrackerClass.createTestContract(oSS.id);
        oLA.ScCollection_FP_Group_Name__c = 'Consumer Loan';
        update oLA;
        
        clcommon__Party__c objComParty = new clcommon__Party__c();
        objComParty.clcommon__Account__c = objAccount.id;
        objComParty.clcommon__Type__c = oPT.id;
        objComParty.collect__CL_Contract__c= oLA.id;
        insert objComPArty;
        }
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        User usr = new User();
        system.runas(usr1)
        {
             createUserRole();
             createUser();
        }
       
    }
     
    
    private static void createUserRole()
    {
        objUserRole = new UserRole(Name='Test Record');
        insert objUserRole ;
    }
    private static void createPage()
    {
        objPage = new pepCmsPage__c();
        objPage =pepCommonTrackerController.createPage('Dashboard(My Profile)');
    
    }
    
    private static  void createSection()
    {
        objSection = pepCommonTrackerController.createSection(objPage);
        objSection.pepSectionUniqueName__c='MyprofileSection1';
        update objSection;
    }
    
    private static void createQuestion()
    {
        objQues = pepCommonTrackerController.createCmsQuestion(objPage,objSection);
        objQues.pepFieldApiName__c ='Name';
        objQues.pepSObjectApiName__c='loan__Loan_Account__c';
        update objques;
    }
    
    private static void createLoanAccount()
    {
       objLoanAccount = pepCommonTrackerController.createLoanAccount();
       objLoanAccount.loan__Account__c = objAccount.id;
       update objLoanAccount;
    }
    
    
    //This method creates account
   private static void createAccount()
   {     
    objAccount=  new Account();
    objAccount.LastName ='testAcc';
    objAccount.PersonEmail ='sandip.bijlwan@saasfocus.com';
    objAccount.PersonBirthDate = system.today() - 4000;
    objAccount.PersonMobilePhone = '9090909090';
    objAccount.PersonMailingPostalCode='400101';
    objAccount.Is_Portal_User_Created__c =true;
    insert objAccount; 
       
   }
   
   private static void createResidentialAddress()
   {
       objRes = new Residential_Address__c();
       objRes.Account__c = objAccount.id;
       insert objRes;
   
   }
   
   private static void createContact()
   {
     objContact = [select id,Accountid from contact where Accountid = : objAccount.id];
   }
   
   private static void createUser()
   {
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner','Custom Customer Community Login user', 'PowerCustomerSuccess',   'CustomerSuccess'};
        Profile p = [select Id,name from Profile where name in :customerUserTypes limit 1];  
       
        objuser = new User();
       // objUser.userRoleId = objUserRole.id;
        objUser.profileId = p.id;
        objuser.userName ='newUser@yahoo.com';
        objUser.email ='amit@test.com';
        objUser.emailencodingkey ='UTF-8';
        objUser.localesidkey ='en_US';
        objUser.languagelocalekey ='en_US';
        objUser.timezonesidkey ='America/Los_Angeles';
        objUser.alias ='ak';
        objUser.lastname ='kumar';
        objUser.contactId =objContact.Id;
        insert objUser;
               
        
       
       
       
   }
    
    static testmethod void unitTest1() 
    {
    
        
         loadData();  
         pages_config__c obj = new pages_config__c();
         obj.name='pepchangeprofile';
         obj.page_label__c ='pepchangeprofile';  
         insert obj;
         System.runAs(objUser)
         { 
             
             pepchangeProfileController objClass = new pepchangeProfileController();         
             objClass.saveSection1Data();
             ApexPages.currentPage().getParameters().put('sectionNo','1');
             objClass.editSection();
             objClass.cancelSection();
             ApexPages.currentPage().getParameters().put('sectionNo','2');
             objClass.cancelSection();
             ApexPages.currentPage().getParameters().put('sectionNo','3');
             objClass.cancelSection();
             ApexPages.currentPage().getParameters().put('sectionNo','4');
             objClass.cancelSection();
             
         }
        
        
    }
    
    static testmethod void unitTest2() 
    {
       
         loadData(); 
         objSection.pepSectionUniqueName__c ='MyprofileSection2';
         update objsection; 
         objQues.pepSObjectApiName__c='Account';
         update objQues;
         pages_config__c obj = new pages_config__c();
         obj.name='pepchangeprofile';
         obj.page_label__c ='pepchangeprofile';  
         insert obj;
         System.runAs(objUser)
         { 
             
             pepchangeProfileController objClass = new pepchangeProfileController();
             objClass.lstWrapperQuestionSection2[0].strGAPIAddress ='test,t2,t1,t3,5';
             objClass.selectedCommuncationType();
             Apexpages.currentpage().getparameters().put('strVal','Email');
             Apexpages.currentpage().getparameters().put('strChecked','false');
             objClass.selectedCommuncationType();
             Apexpages.currentpage().getparameters().put('strChecked','true');
             objClass.selectedCommuncationType();
             objClass.saveSection2Data();             
             objClass.lstWrapperQuestionSection2[0].strGAPIAddress ='test:t2:t1:t3:5';
             
             objClass.saveSection2Data();
             objClass.saveSection3Data();
             
             objAccount.collect__External_ID__c = 'abcd';
             update objAccount;
             pepchangeProfileController objClass1 = new pepchangeProfileController();
             objClass1.lstWrapperQuestionSection2[0].strGAPIAddress ='test,t2,t1,t3,5';
             objClass1.saveSection2Data();
             
             
         }
         
        
    }
    
    
    static testmethod void unitTest3() 
    {
       
         loadData(); 
         objSection.pepSectionUniqueName__c ='MyProfilePwdSection';
         update objsection; 
         pages_config__c obj = new pages_config__c();
         obj.name='pepchangeprofile';
         obj.page_label__c ='pepchangeprofile';  
         insert obj;
         System.runAs(objUser)
         { 
             
             pepchangeProfileController objClass = new pepchangeProfileController();
             
             
             
         }
         
        
    }
    static testmethod void unitTest4() 
    {
        
         loadData(); 
         objSection.pepSectionUniqueName__c ='MyProfilePwdEditSection';
         update objsection; 
         pages_config__c obj = new pages_config__c();
         obj.name='pepchangeprofile';
         obj.page_label__c ='pepchangeprofile';  
         insert obj;
         System.runAs(objUser)
         { 
             
             pepchangeProfileController objClass = new pepchangeProfileController();
             objClass.saveSectionPwdData();
             
         }
         
        
    }
    
    static testmethod void unitTest5() 
    {
       
         loadData(); 
         objSection.pepSectionUniqueName__c ='MyprofileSection3';
         update objsection; 
         pages_config__c obj = new pages_config__c();
         obj.name='pepchangeprofile';
         obj.page_label__c ='pepchangeprofile';  
         insert obj;
         System.runAs(objUser)
         { 
             
             pepchangeProfileController objClass = new pepchangeProfileController();
         }
        
        
    }
    
    
    
    
}