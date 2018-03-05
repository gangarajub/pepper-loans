@isTest(SeeAllData=false)
Private class pepCmsComponent_New_Tracker{
    Static Captcha_Settings__c captchaSetting;
    static genesis__Applications__c objApplication;
    static pepCmsPage__c objPage;
    Static pepCmsSection__c objCmsSection;
    Static pepCmsSection__c objCmsSection1;
    Static pepCmsSection__c objCmsSection2;
    Static pepCmsSection__c PersonalDetailsSec1;
    Static pepCmsSection__c  PersonalDetailsSec2;
    Static pepCmsSection__c  PersonalDetailsSec3;
    static pepCmsQuestion__c cmssection1question1; 
    static pepCmsQuestion__c cmssection1question2;
    static pepCmsQuestion__c cmssection2question1;
    static pepCmsQuestion__c cmssection2question2;
    static pepCmsQuestion__c answerquestion1;
    static pepCmsQuestion__c answerquestion2;
    static pepCmsQuestion__c answerquestion3;
    static pepCmsQuestion__c answerquestion4;
    static pepCmsQuestion__c section1question1sibling1;
    static pepCmsQuestion__c section1question1sibling;
    static pepCmsAnswer__c  section1siblingquestionanswer1;
    static pepCmsAnswer__c  section1siblingquestionanswer2;
    static pepCmsAnswer__c  section1siblingquestionanswer3;
    static pepCmsAnswer__c  section1siblingquestionanswer4;
    static pepCmsAnswer__c  section1siblingquestionanswer5;
    static pepCmsAnswer__c section1question2answer1;
    static pepCmsAnswer__c section1question2answer2;
    static pepCmsAnswer__c section2question1answer1;
    static pepCmsAnswer__c section2question1answer2;
    static pepCmsAnswer__c section2question2answer1;
    static pepCmsAnswer__c section2question2answer2;
    static pepCmsAnswer__c plusanswer;
    static pepCmsAnswer__c minusanswer;
    static pepCmsQuestion__c answerquestion;
    static pepCmsQuestion__c objQuestion1;
    static pepCmsQuestion__c objQuestion2;
    static pepCmsQuestion__c objQuestion3;
    static pepCmsQuestion__c objQuestion4;
    static pepCmsQuestion__c objQuestion5;
    static pepCmsQuestion__c objQuestion6;
    static pepCmsQuestion__c objQuestion7;
    static pepCmsAnswer__c objAnswer1;
    static pepCmsAnswer__c objAnswer2;
    static pepCmsAnswer__c objAnswer3;
    static pepCmsAnswer__c objAnswer4;
    static pepCmsAnswer__c objAnswer5;
    static pepCmsAnswer__c objAnswer6;
    static pepCmsAnswer__c objAnswer7;
    
    Testmethod static void test1() {
        Loaddata();
        Pagereference pt =Page.pepincomepage;
        Test.setcurrentPagereference(pt);
        pepcmscomponent_new pcmnew = new pepcmscomponent_new();
        Pepcmsmodelcontainer_new modelcontainer = new pepcmsmodelcontainer_new();
        pcmnew.objmodelcontainer=modelcontainer;
        pcmnew.strPageName = 'Income Details';
        Test.startTest();
        System.assertNotEquals(null,pcmnew.getRenderQuestions());
        pcmnew.parsedSectionStory();
        Test.StopTest();
    }
    
    Testmethod static void test2(){
        Loaddata();
        Pagereference pt =Page.pepincomepage;
        Test.setcurrentPagereference(pt);
        objapplication.Expecting_Financial_Loss__c='No';
        objApplication.Experienced_bankruptcy_in_past__c='No';
        update objapplication;
        List<Income__c> incomelist = new List<Income__c>();
        Income__c objIncome = new Income__c();
        objIncome.Application__c=objApplication.id;
        objIncome.Gross_Income__c=123456;
        objincome.Frequency__c='weekly';
        objincome.Sequence__c=1;
        incomelist.add(objincome);
        Income__c objIncome1 = new Income__c();
        objIncome1.Application__c=objApplication.id;
        objIncome1.Gross_Income__c=123456;
        objincome1.Frequency__c='weekly';
        objincome1.Sequence__c=1;
        objincome1.Type__c='Part-time employment';
        incomelist.add(objincome1);
        insert incomelist;
        pepcmscomponent_new pcmnew = new pepcmscomponent_new();
        Pepcmsmodelcontainer_new modelcontainer = new pepcmsmodelcontainer_new();
        modelcontainer.lstincome=incomelist;
        modelcontainer.objapplication=objapplication;
        pcmnew.objmodelcontainer=modelcontainer;
        pcmnew.strPageName = 'Income Details';
        pcmnew.SelectedAnswer=String.valueof(section2question1answer1.id);
        pcmnew.selectedSection=String.valueof(objCmssection2.id);
        pcmnew.selectedQuestion=String.valueof(cmssection2question1.id);
        pcmnew.WhatToDo='ADD';
        Test.startTest();
        System.assertNotEquals(null, pcmnew.getRenderQuestions());
        pcmnew.parsedSectionStory();
        pcmnew.instance='loading';
        pcmnew.RelatedQuestionsOfAnswers();
        pcmnew.SelectedAnswer=String.valueof(section2question1answer1.id);
        pcmnew.selectedSection=String.valueof(objCmssection2.id);
        pcmnew.selectedQuestion=String.valueof(cmssection2question1.id);
        pcmnew.WhatToDo='ABOVE';
        //pcmnew.RelatedQuestionsOfAnswers();
        pcmnew.SelectedAnswer=String.valueof(section1question2answer2.id);
        pcmnew.selectedSection=String.valueof(objCmsSection1.id);
        pcmnew.selectedQuestion=String.valueof(cmssection1question2.id);
        pcmnew.WhatToDo='REMOVE,NEXT';
        pcmnew.removeQuesOnDropDownChange();
        //pcmnew.removeQuestionFromWrapper();
        pcmnew.SelectedAnswer=String.valueof(minusanswer.id);
        pcmnew.selectedSection=String.valueof(objCmsSection1.id);
        pcmnew.selectedQuestion=String.valueof(answerquestion3.id);
        pcmnew.WhatToDo='REMOVE,ABOVE';
        pcmnew.removeQuestionOnMinus();
        Test.StopTest();
    }
    
    Static Testmethod void test3(){
        Loaddata();
        Pagereference pt =Page.pepincomepage;
        Test.setcurrentPagereference(pt);
        objapplication.Expecting_Financial_Loss__c='No';
        objApplication.Experienced_bankruptcy_in_past__c='No';
        update objapplication;
        List<Income__c> incomelist = new List<Income__c>();
        Income__c objIncome = new Income__c();
        objIncome.Application__c=objApplication.id;
        objIncome.Gross_Income__c=123456;
        objincome.Frequency__c='weekly';
        objincome.Sequence__c=1;
        incomelist.add(objincome);
        Income__c objIncome1 = new Income__c();
        objIncome1.Application__c=objApplication.id;
        objIncome1.Gross_Income__c=123456;
        objincome1.Frequency__c='weekly';
        objincome1.Sequence__c=1;
        objincome1.Type__c='Part-time employment';
        incomelist.add(objincome1);
        insert incomelist;
        pepcmscomponent_new pcmnew = new pepcmscomponent_new();
        Pepcmsmodelcontainer_new modelcontainer = new pepcmsmodelcontainer_new();
        modelcontainer.lstincome=incomelist;
        pcmnew.objmodelcontainer=modelcontainer;
        pcmnew.strPageName = 'Income Details';
        
        Test.startTest();
        System.assertNotEquals(null, pcmnew.getRenderQuestions());
        pcmnew.parsedSectionStory();
        pcmnew.instance='loading';
        //pcmnew.RelatedQuestionsOfAnswers();
        pcmnew.SelectedAnswer=String.valueof(section2question1answer1.id);
        pcmnew.selectedSection=String.valueof(objCmssection2.id);
        pcmnew.selectedQuestion=String.valueof(cmssection2question1.id);
        pcmnew.WhatToDo='ABOVE';
        
        pcmnew.relatedQuestionsOfAnswers();
        List<pepCMSModelContainer_New.wrapQuestion> tempList = new List<pepCMSModelContainer_New.wrapQuestion>();
        pepCMSModelContainer_New.wrapQuestion wrq = new pepCMSModelContainer_New.wrapQuestion(answerquestion3,null);
        tempList.add(wrq);
        System.assertNotEquals(0, pcmnew.removeQuestionWithThisParent(cmssection1question2.id,tempList,true).size());
        Test.StopTest();
    }
    
    Testmethod static void test4(){
        Loaddatapd();
        Pagereference pt =Page.PepPersonalDetails;
        Test.setcurrentPagereference(pt);
        pepcmscomponent_new pcmnew = new pepcmscomponent_new();
        Pepcmsmodelcontainer_new modelcontainer = new pepcmsmodelcontainer_new();
        List<Residential_Address__c> residentialAddress = new List<Residential_Address__c>();
        Residential_Address__c rdd = pepCommonTrackerController.createResidential();
        rdd.What_is_Your_Residential_Status__c='abc';
        rdd.how_long_have_you_lived_here__c='more than 8 years';
        rdd.Application__c = objApplication.id;
        rdd.Address__c='78, Captain Vijyant Thapar Marg, Arun Vihar, Noida, Uttar Pradesh, India';
        update rdd;
        residentialAddress.add(rdd);
        modelcontainer.lstResidentialAddress=residentialAddress;
        pcmnew.objmodelcontainer=modelcontainer;
        pcmnew.strPageName = 'Personal Details';
        Account acc = new Account();
        acc=pepCommonTrackerController.CreateAccount();
        acc.relationship_status__c='single';
        acc.firstname='test';
        acc.Lastname='Arora';
        acc.number_of_dependants__c=2;
        update acc;
        objApplication.genesis__Account__c=acc.id;
        pcmnew.objmodelcontainer.objaccount=acc;
        pcmnew.objmodelcontainer.objapplication.genesis__Account__c=acc.id;
        Test.startTest();
        System.assertNotEquals(null, pcmnew.getRenderQuestions());
        pcmnew.removeQuestionFromWrapper();
        pcmnew.parsedSectionStory();
        List<Residential_Address__c> residentialAddress1 = new List<Residential_Address__c>();
        Residential_Address__c rdd1 = pepCommonTrackerController.createResidential();
        rdd1.What_is_Your_Residential_Status__c='abc';
        rdd1.current_address__c=false;
        rdd1.how_long_have_you_lived_here__c='more than 8 years';
        rdd1.Application__c = objApplication.id;
        rdd1.Account__c=acc.id;
        rdd1.Current_Address__c=True;
        rdd1.Address__c='78, Captain Vijyant Thapar Marg, Arun Vihar, Noida, Uttar Pradesh, India';
        update rdd1;
        residentialAddress1.add(rdd1);
        modelcontainer.lstResidentialAddress=residentialAddress1;
        pcmnew.objmodelcontainer.checkaccount(acc.id);
        pcmnew.objmodelcontainer.updateresidentialaddress=True;
        pcmnew.objmodelcontainer.checkaccount(acc.id);
        rdd1.Current_Address__c=False;
        update rdd1;
        pcmnew.objmodelcontainer.checkaccount(acc.id);
        
        Pepcmsmodelcontainer_new.wrapsection wrs = new Pepcmsmodelcontainer_new.wrapsection();
        wrs.objCmsSection=PersonalDetailsSec1;
        wrs.gethelptext();
        Pepcmsmodelcontainer_new.wrapAnswer objAns = new Pepcmsmodelcontainer_new.wrapAnswer();
        
        Pepcmsmodelcontainer_new.wrapQuestion objques = new Pepcmsmodelcontainer_new.wrapQuestion(objQuestion5,null);
        objques.objinputvalue =objAnswer6.id;
        objques.actualvalue=objAnswer6.id+'true';
        objques.lstOptions.add(new selectoption(objAnswer6.id+'true',objAnswer6.id+'true'));
        objques.handleRerender=True;
        Boolean temp=objques.handleRerender;
        
        string s = objques.actualvalue;
        pcmnew.removeQuestionFromWrapper();
        pcmnew.parsedSectionStory();
        List<genesis__Employment_Information__c> genesisemploymentinformationList = new List<genesis__Employment_Information__c>();
        genesis__Employment_Information__c empInfo = pepCommonTrackerController.employmentInformation();
        empInfo.genesis__Application__c = objApplication.id;
        empinfo.how_long_have_you_worked__c='more than 8 years';
        empinfo.Employment_Status__c='part time';
        empInfo.pepCompany_Address__c='aghf gkjghjlhljk';
        empInfo.sequence__c=1;
        update empInfo;
        genesisemploymentinformationList.add(empInfo);
        genesis__Employment_Information__c empInfo1 = pepCommonTrackerController.employmentInformation();
        empInfo1.genesis__Application__c = objApplication.id;
        empinfo1.how_long_have_you_worked__c='more than 8 years';
        empinfo1.Employment_Status__c='part time';
        empinfo1.pepCompany_Address__c='sdgfj hgkgjkfy';
        empInfo1.sequence__c=2;
        update empInfo1;
        genesisemploymentinformationList.add(empInfo1);
        modelcontainer.lstEmploymentInformation=genesisemploymentinformationList;
        pcmnew.objmodelcontainer=modelcontainer;
        pcmnew.objmodelcontainer.objAccount.PersonBirthDate=System.Today()-365;
        pcmnew.objmodelcontainer.FetchDataToInputValue();
        pcmnew.removeQuestionFromWrapper();
        pcmnew.parsedSectionStory();
        empInfo1.Employment_Status__c=null;
        update empinfo1;
        pcmnew.parsedSectionStory();
        pcmnew.objmodelcontainer.objaccount=null;
        pcmnew.objmodelcontainer.objapplication=null;
        pcmnew.objmodelcontainer.SaveInputValuesToFields();
        Test.stopTest();
        
    }
    
    public static testMethod void test5(){
        Insert_Gensis_Application();
        removeQuestionFromWrapper(18, 'Residential Details');
        removeQuestionFromWrapper(12, 'Employment Details');
        removeQuestionFromWrapper(14, 'Residential Details');
        List<Income__c> lstIncome = [Select Id, Sequence__c from Income__c Where Application__c=:objApplication.id];
        System.assertEquals(3, lstIncome.size());
    }
    
    public static void removeQuestionFromWrapper(Integer noOfQues, String pepHeader) {
        
        PageReference testPageReference = new PageReference('apex/pepIncomePage');
        Test.setCurrentPage(testPageReference);
        pepCMSComponent_New controllerObj = new pepCMSComponent_New();
        
        pepCMSModelContainer_New modelContainerNewObj = new pepCMSModelContainer_New();
        
        pepCMSModelContainer_New.wrapSection wrapSectionObj = new pepCMSModelContainer_New.wrapSection();
        wrapSectionObj.errorMessage = 'This is error msg';
        wrapSectionObj.isRenderSectionStory = true;
        wrapSectionObj.showError = false;
        wrapSectionObj.lseQuestions = createWrapperQuestion(noOfQues);
        wrapSectionObj.objCmsSection.pepHeader__c = pepHeader;
        modelContainerNewObj.lstSection.add(wrapSectionObj);
        modelContainerNewObj.lstIncome.add(createIncomeObj(1));
        modelContainerNewObj.lstIncome.add(createIncomeObj(0));
        controllerObj.objModelContainer = modelContainerNewObj;
        controllerObj.removeQuestionFromWrapper();
    }
    
    public static List<pepCMSModelContainer_New.wrapQuestion> createWrapperQuestion(Integer noOfQues) {
        
        List<pepCMSModelContainer_New.wrapQuestion> lstQues = new List<pepCMSModelContainer_New.wrapQuestion>();
        
        for(Integer i=0; i<noOfQues;i++) {
            lstQues.add(new pepCMSModelContainer_New.wrapQuestion());
        }
        return lstQues;
    }
    
    public static Income__c createIncomeObj(Integer seqNo) {
        Income__c incomeObj = new Income__c();
        incomeObj.Sequence__c = seqNo;
        incomeObj.Application__c = objApplication.id;
        insert incomeObj;
        return incomeObj;
    }
    Static void Loaddatapd(){
        pepCommonTrackerController obj =new pepCommonTrackerController();
        List<pages_config__c> pageConfig = pepCommonTrackerController.createPagesConfig();
        //Inserting Application
        Insert_Gensis_Application();
        //creating cookies
        Cookies();
        //CreatePdPage
        CreatePdPage();
        //CreatecmssectionforPd
        Createcmssectionpd();
    }
    Static void CreatePdPage(){
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', 'www.google.com');
        apexpages.currentpage().getparameters().put('redirectFromPageNo' , '1');
        objPage = pepCommonTrackerController.createPage('Personal Details');
    }
    Static void Loaddata(){
        pepCommonTrackerController obj =new pepCommonTrackerController();
        List<pages_config__c> pageConfig = pepCommonTrackerController.createPagesConfig();
        //Inserting Application
        Insert_Gensis_Application();
        //creating cookies
        Cookies();
        //creatingPagedata
        pageContent();
        //Creating sections
        Createsections();
        //createsectionwisequestions///
        Createcmsquestions();
        //Create sibling Questions.
        Createsiblingquestions();
        //CreatesiblingAnswers
        Createsiblingquestionanswers();
        //Create asnswer questions.
        Createanswerquestions();
    }
    static void Insert_Gensis_Application()
    {
        /******************Application Insertion****************/
        objApplication = new genesis__Applications__c();
        RetrieveCode__c objRetrieveCode1 = pepCommonTrackerController.createRetrieveCode();
        objApplication = genesis.TestHelper.createApplication();
        objApplication .genesis__Interest_Rate__c=12.10;
        objApplication .genesis__Loan_Amount__c=50;
        objApplication .genesis__Term__c=4;
        objApplication.genesis__Term__c=3;
        objApplication.Total_Monthly_Expense_Exc_Mortgage__c=1;
        
        update objApplication ;
    }
    static void Cookies()
    {
        /************************Cookies Setting****************/
        Pagereference pd1=Page.PepincomePage;
        Test.setcurrentPagereference(pd1);
        Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
        pd1.setcookies(new cookie[]{Applicationid});
    }
    static void pageContent()
    {        
        /***************Page Headers and parameters**************/
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', 'www.google.com');
        apexpages.currentpage().getparameters().put('redirectFromPageNo' , '1');
        objPage = pepCommonTrackerController.createPage('Income Details');
        
    } 
    static void Createsections(){
        List<pepCmsSection__c> cmsSections = new List<pepCmsSection__c>();
        //Creating Section 1/////
        objCmsSection = new pepCmsSection__c();
        objCmsSection.pepPage__c = objPage.id;
        objCmsSection.pepSectionUniqueName__c = 'IncomeSection3';
        objCmsSection.pepType__c='Running Text';
        objCmssection.pepSectionBodyRich__c='Text Data';
        cmsSections.add(objCmssection);
        //creating section 2/////
        objCmsSection1 = new pepCmsSection__c();
        objCmsSection1.pepPage__c = objPage.id;
        objCmsSection1.pepSectionUniqueName__c = 'Income Details';
        objCmsSection1.pepType__c='Form';
        objCmsSection1.pepSequence__c=1;
        objCmssection1.pepSectionBodyRich__c='Net income: how much you earn after tax.Other income: any other recurring source of income such as a second job or rental income.';
        objcmssection1.pepHeader__c='Income Details';
        objcmssection1.pepSectionStoryRich__c='My primary income is ${Income__c.Gross_Income__c} (net) {Income__c.Frequency__c}.';
        objcmssection1.pepSectionStory__c='My primary income is ${Income__c.Gross_Income__c} (net) {Income__c.Frequency__c}.';
        cmsSections.add(objCmssection1);
        //creating section3//
        objCmsSection2 = new pepCmsSection__c();
        objCmsSection2.pepPage__c = objPage.id;
        objCmsSection2.pepSectionUniqueName__c = 'Financial Stability';
        objCmsSection2.pepType__c='Form';
        objCmsSection2.pepSequence__c=2;
        objCmssection2.pepSectionBodyRich__c='Significant change: this might include a decrease in your income or an upcoming large expenditure.';
        objcmssection2.pepHeader__c='Financial Circumstances, Requirements and Objectives';
        objcmssection2.pepSectionStoryRich__c='I {genesis__Applications__c.Expecting_Financial_Loss__c} expect changes to my finances in the near future.';
        objcmssection2.pepSectionStory__c='I {genesis__Applications__c.Expecting_Financial_Loss__c} expect changes to my finances in the near future.';
        cmsSections.add(objCmssection2);
        insert cmsSections;
    }
    static void Createcmsquestions(){
        List<pepCmsQuestion__c> cmsquestions = new List<pepCmsQuestion__c>();
        cmssection1question1 = new pepCmsQuestion__c();
        cmssection1question1.pepSection__c = objCmsSection1.id;
        cmssection1question1.pepPage__c=objPage.id;
        cmssection1question1.pepLabelPriorQuestion__c='Primary Net Income';
        cmssection1question1.pepType__c = 'Currency'; 
        cmssection1question1.pepFieldApiName__c='Gross_Income__c';
        cmssection1question1.pepSequence__c=1; 
        cmssection1question1.pepSObjectApiName__c='Income__c';
        cmssection1question1.pepRecordSequence__c=1;
        cmssection1question1.pepGenericErrorMessage__c='Please enter your income (numbers only e.g. 2000)';
        cmssection1question1.pepRelatedCSS__c='form-cntrls';
        cmssection1question1.pepIsRequired__c=true;
        cmssection1question1.pepKeyPressNumbersOnly__c=true;
        cmssection1question1.pepNumbersOnly__c=true;
        cmssection1question1.pepDisplayPercent__c=true;
        cmsquestions.add(cmssection1question1);
        //create section 1 question2
        cmssection1question2 = new pepCmsQuestion__c();
        cmssection1question2.pepSection__c = objCmsSection1.id;
        cmssection1question2.pepPage__c=objPage.id;
        cmssection1question2.pepLabelPriorQuestion__c='Do you earn other income?';
        cmssection1question2.pepType__c = 'Button';
        cmssection1question2.pepSubType__c='Yes/No';    
        cmssection1question2.pepFieldApiName__c='Other_Income__c';
        cmssection1question2.pepSequence__c=2; 
        cmssection1question2.pepSObjectApiName__c='Income__c';
        cmssection1question2.pepRecordSequence__c=1;
        cmssection1question2.pepGenericErrorMessage__c='Please select yes or no';
        cmssection1question2.pepRelatedCSS__c='form-cntrls';
        cmssection1question2.pepIsRequired__c=true;
        cmssection1question2.pepHasAnswers__c=true;
        cmsquestions.add(cmssection1question2);
        //Create Section 2 Question 1
        cmssection2question1 = new pepCmsQuestion__c();
        cmssection2question1.pepSection__c = objCmsSection2.id;
        cmssection2question1.pepPage__c=objPage.id;
        cmssection2question1.pepLabelPriorQuestion__c='Do you expect any significant change to your financial situation over the term of your loan which may impact on your ability to repay the loan?';
        cmssection2question1.pepType__c = 'Button';
        cmssection2question1.pepSubType__c='Yes/No';    
        cmssection2question1.pepFieldApiName__c='Expecting_Financial_Loss__c';
        cmssection2question1.pepSequence__c=1; 
        cmssection2question1.pepSObjectApiName__c='genesis__Applications__c';
        cmssection2question1.pepRecordSequence__c=1;
        cmssection2question1.pepGenericErrorMessage__c='Please select yes or no.';
        cmssection2question1.pepIsRequired__c=true;
        cmssection2question1.pepHasAnswers__c=true;
        cmsquestions.add(cmssection2question1);
        //create Setion 2 question 2
        cmssection2question2 = new pepCmsQuestion__c();
        cmssection2question2.pepSection__c = objCmsSection2.id;
        cmssection2question2.pepPage__c=objPage.id;
        cmssection2question2.pepLabelPriorQuestion__c='Have you previously been declared bankrupt, insolvent, been a shareholder or officer of a company to which a manager, receiver and/or liquidator has been appointed, have any unsatisfied judgements or similar?';
        cmssection2question2.pepType__c = 'Button';
        cmssection2question2.pepSubType__c='Yes/No';    
        cmssection2question2.pepFieldApiName__c='Experienced_bankruptcy_in_past__c';
        cmssection2question2.pepSequence__c=2; 
        cmssection2question2.pepSObjectApiName__c='genesis__Applications__c';
        cmssection2question2.pepRecordSequence__c=1;
        cmssection2question2.pepGenericErrorMessage__c='Please select yes or no.';
        cmssection2question2.pepIsRequired__c=true;
        cmsquestions.add(cmssection2question2);
        insert cmsquestions;
    }
    static void Createsiblingquestions(){
        List<pepCmsQuestion__c> cmssiblingquestions = new List<pepCmsQuestion__c>();
        //Create Section 1 Question 1 Sibling Question
        section1question1sibling = new pepCmsQuestion__c();
        section1question1sibling.pepType__c = 'Picklist';
        section1question1sibling.pepFieldApiName__c='Frequency__c';
        section1question1sibling.pepSequence__c=1; 
        section1question1sibling.pepSObjectApiName__c='Income__c';
        section1question1sibling.pepRecordSequence__c=1;
        section1question1sibling.pepRelatedCSS__c='form-cntrls';
        section1question1sibling.pepQuestion__c=cmssection1question1.id;
        section1question1sibling.pepGenericErrorMessage__c='Please select yes or no.';
        section1question1sibling.pepIsRequired__c=true;
        cmssiblingquestions.add(section1question1sibling);
        
        insert cmssiblingquestions;
    }
    static void Createsiblingquestionanswers(){
        List<pepCmsAnswer__c> siblingquestionanswers = new List<pepCmsAnswer__c>();
        //Create section 1 sibling question's answer 1  
        section1siblingquestionanswer1 = new pepCmsAnswer__c ();
        section1siblingquestionanswer1.Name='weekly';
        section1siblingquestionanswer1.pepCmsQuestion__c=section1question1sibling.id;
        section1siblingquestionanswer1.pepActualValue__c='weekly';
        section1siblingquestionanswer1.pepDisplayText__c='weekly';
        section1siblingquestionanswer1.pepSequence__c=2;
        siblingquestionanswers.add(section1siblingquestionanswer1);
        //Create section 1 sibling question's answer 2  
        section1siblingquestionanswer2 = new pepCmsAnswer__c ();
        section1siblingquestionanswer2.Name='fortnightly';
        section1siblingquestionanswer2.pepCmsQuestion__c=section1question1sibling.id;
        section1siblingquestionanswer2.pepActualValue__c='fortnightly';
        section1siblingquestionanswer2.pepDisplayText__c='fortnightly';
        section1siblingquestionanswer2.pepSequence__c=3;
        siblingquestionanswers.add(section1siblingquestionanswer2);
        //Create section 1 sibling question's answer 3  
        section1siblingquestionanswer3 = new pepCmsAnswer__c ();
        section1siblingquestionanswer3.Name='monthly';
        section1siblingquestionanswer3.pepCmsQuestion__c=section1question1sibling.id;
        section1siblingquestionanswer3.pepActualValue__c='monthly';
        section1siblingquestionanswer3.pepDisplayText__c='monthly';
        section1siblingquestionanswer3.pepSequence__c=4;
        siblingquestionanswers.add(section1siblingquestionanswer3);
        //Create section 1 sibling question's answer 4  
        section1siblingquestionanswer4 = new pepCmsAnswer__c ();
        section1siblingquestionanswer4.Name='yearly';
        section1siblingquestionanswer4.pepCmsQuestion__c=section1question1sibling.id;
        section1siblingquestionanswer4.pepActualValue__c='yearly';
        section1siblingquestionanswer4.pepDisplayText__c='yearly';
        section1siblingquestionanswer4.pepSequence__c=5;
        siblingquestionanswers.add(section1siblingquestionanswer4);
        //Create section 1 sibling question's answer 5  
        section1siblingquestionanswer5 = new pepCmsAnswer__c ();
        section1siblingquestionanswer5.Name='choose one';
        section1siblingquestionanswer5.pepCmsQuestion__c=section1question1sibling.id;
        section1siblingquestionanswer5.pepActualValue__c='choose one';
        section1siblingquestionanswer5.pepDisplayText__c='choose one';
        section1siblingquestionanswer5.pepSequence__c=1;
        siblingquestionanswers.add(section1siblingquestionanswer5);
        //create section 1 Question 2's Answer 1
        section1question2answer1 = new pepCmsAnswer__c ();   
        section1question2answer1.Name='Yes';
        section1question2answer1.pepCmsQuestion__c=cmssection1question2.id;
        section1question2answer1.pepActualValue__c='Yes';
        section1question2answer1.pepDisplayText__c='Yes';
        section1question2answer1.pepSequence__c=1;
        siblingquestionanswers.add(section1question2answer1);
        //Create section 1 question 2's Answer 2
        section1question2answer2 = new pepCmsAnswer__c ();   
        section1question2answer2.Name='No';
        section1question2answer2.pepCmsQuestion__c=cmssection1question2.id;
        section1question2answer2.pepActualValue__c='No';
        section1question2answer2.pepDisplayText__c='No';
        section1question2answer2.pepSequence__c=2;
        siblingquestionanswers.add(section1question2answer2);
        //Create section 2 Qusestion 1' answer1
        section2question1answer1 = new pepCmsAnswer__c ();   
        section2question1answer1.Name='Yes';
        section2question1answer1.pepCmsQuestion__c=cmssection2question1.id;
        section2question1answer1.pepActualValue__c='Yes';
        section2question1answer1.pepDisplayText__c='Yes';
        section2question1answer1.pepSequence__c=1;
        siblingquestionanswers.add(section2question1answer1);
        //Create section 2 Question 1 's answer2  
        section2question1answer2 = new pepCmsAnswer__c ();   
        section2question1answer2.Name='No';
        section2question1answer2.pepCmsQuestion__c=cmssection2question1.id;
        section2question1answer2.pepActualValue__c='No';
        section2question1answer2.pepDisplayText__c='No';
        section2question1answer2.pepSequence__c=2;
        siblingquestionanswers.add(section2question1answer2);
        //Create section 2 Qusestion 2' answer1
        section2question2answer1 = new pepCmsAnswer__c ();   
        section2question2answer1.Name='Yes';
        section2question2answer1.pepCmsQuestion__c=cmssection2question2.id;
        section2question2answer1.pepActualValue__c='Yes';
        section2question2answer1.pepDisplayText__c='Yes';
        section2question2answer1.pepSequence__c=1;
        siblingquestionanswers.add(section2question2answer1);
        //Create section 2 Question 2 's answer2  
        section2question2answer2 = new pepCmsAnswer__c ();   
        section2question2answer2.Name='No';
        section2question2answer2.pepCmsQuestion__c=cmssection2question2.id;
        section2question2answer2.pepActualValue__c='No';
        section2question2answer2.pepDisplayText__c='No';
        section2question2answer2.pepSequence__c=2;
        siblingquestionanswers.add(section2question2answer2);
        insert siblingquestionanswers;
    }
    static void Createanswerquestions(){
        //Creating answerquestion
        List<pepCmsQuestion__c> answerquestions = new List<pepCmsQuestion__c>();
        answerquestion = new pepCmsQuestion__c();
        answerquestion.pepLabelPriorQuestion__c='If yes, please provide further information';
        answerquestion.pepType__c = 'Text area';
        answerquestion.pepFieldApiName__c='Tell_us_about_it__c';
        answerquestion.pepSequence__c=1; 
        answerquestion.pepSObjectApiName__c='genesis__Applications__c';
        answerquestion.pepGenericErrorMessage__c='This field is required';
        answerquestion.pepIsRequired__c=true;
        answerquestion.pepCMSAnswer__c=section2question1answer1.id;
        answerquestions.add(answerquestion);
        //Creating answer question corresponding to section 1 Question 2's Answer 1 Question 1
        answerquestion1 = new pepCmsQuestion__c();
        answerquestion1.pepLabelPriorQuestion__c='Secondary Income Type';
        answerquestion1.pepType__c = 'Picklist';
        answerquestion1.pepFieldApiName__c='Type__c';
        answerquestion1.pepSequence__c=2; 
        answerquestion1.pepSObjectApiName__c='Income__c';
        answerquestion1.pepGenericErrorMessage__c='This field is required';
        answerquestion1.pepIsRequired__c=true;
        answerquestion1.pepRecordSequence__c=2;
        answerquestion1.pepRelatedCSS__c='form-cntrls-lg';
        answerquestion1.pepCMSAnswer__c=section1question2answer1.id;//has 4 answers
        answerquestions.add(answerquestion1);
        //Creating answer question to section 1 Question 2's answer 1 Question 2
        answerquestion2 = new pepCmsQuestion__c();
        answerquestion2.pepLabelPriorQuestion__c='Secondary Net Income';
        answerquestion2.pepType__c = 'Currency';
        answerquestion2.pepFieldApiName__c='Gross_Income__c';
        answerquestion2.pepSequence__c=3; 
        answerquestion2.pepSObjectApiName__c='Income__c';
        answerquestion2.pepGenericErrorMessage__c='This field is required';
        answerquestion2.pepIsRequired__c=true;
        answerquestion2.pepRecordSequence__c=2;
        answerquestion2.pepRelatedCSS__c='form-cntrls-lg';
        answerquestion2.pepDisplayDollar__c=true;
        answerquestion2.pepCMSAnswer__c=section1question2answer1.id;
        answerquestions.add(answerquestion2);
        //Creating answer question to section 1 Question 2's answer 1 Question 3
        answerquestion3 = new pepCmsQuestion__c();
        answerquestion3.pepLabelPriorQuestion__c='Next_Income_Added__c';
        answerquestion3.pepType__c = 'Button';
        answerquestion3.pepFieldApiName__c='Gross_Income__c';
        answerquestion3.pepSubType__c='+/-';
        answerquestion3.pepSequence__c=4; 
        answerquestion3.pepSObjectApiName__c='Income__c';
        answerquestion3.pepGenericErrorMessage__c='This field is required';
        answerquestion3.pepIsRequired__c=true;
        answerquestion3.pepRecordSequence__c=2;
        answerquestion3.pepHasAnswers__c=true;
        answerquestion3.pepCMSAnswer__c=section1question2answer1.id;
        answerquestions.add(answerquestion3);
        insert answerquestions;
        createplusminusquestions();
    }
    static void createplusminusquestions(){
        List<pepCmsAnswer__c> anslists = new List<pepCmsAnswer__c>();
        //create plus answer corresponding to Question
        plusanswer= new pepCmsAnswer__c ();   
        plusanswer.Name='+';
        plusanswer.pepCmsQuestion__c=answerquestion3.id;
        plusanswer.pepActualValue__c='+';
        plusanswer.pepDisplayText__c='+';
        plusanswer.pepSequence__c=1;
        anslists.add(plusanswer);
        //Create minus answer corresponding to Question
        minusanswer= new pepCmsAnswer__c ();   
        minusanswer.Name='-';
        minusanswer.pepCmsQuestion__c=answerquestion3.id;
        minusanswer.pepActualValue__c='-';
        minusanswer.pepDisplayText__c='-';
        minusanswer.pepSequence__c=2;
        anslists.add(minusanswer);
        insert anslists;
    }
    Static void Createcmssectionpd(){
        //create PersonalDetailssection1
        List<pepCmsSection__c> cmsPdSections = new List<pepCmsSection__c>();
        PersonalDetailsSec1 = new pepCmsSection__c();
        PersonalDetailsSec1.pepPage__c = objPage.id;
        PersonalDetailsSec1.pepSectionUniqueName__c = 'PersonalDetailsSec1';
        PersonalDetailsSec1.pepType__c='Form';
        PersonalDetailsSec1.pepSequence__c=1;
        PersonalDetailsSec1.pepSectionBodyRich__c='Your personal information will help us identify you when we submit your application for the bureau credit check.Relationship status: De Facto means you are currently living with your partner.Dependants: Any individuals who fall under your financial care.Identification type: Your identification is required to perform the bureau credit check. Is you do not have any of these forms of identification please save your application and call 1300 659 430.';
        PersonalDetailsSec1.pepHeader__c='Personal Details';
        PersonalDetailsSec1.pepSectionStoryRich__c='I\'m {Account.FirstName}! I am {Account.Relationship_Status__c} and I have {Account.Number_of_Dependants__c} dependants.';
        PersonalDetailsSec1.pepSectionStory__c='I\' m {Account.FirstName}! I am {Account.Relationship_Status__c} and I have {Account.Number_of_Dependants__c} dependants.';
        cmsPdSections.add(PersonalDetailsSec1);
        //Creating residentialsection
        PersonalDetailsSec2 = new pepCmsSection__c();
        PersonalDetailsSec2.pepPage__c = objPage.id;
        PersonalDetailsSec2.pepSectionUniqueName__c = 'Residential Details';
        PersonalDetailsSec2.pepType__c='Form';
        PersonalDetailsSec2.pepSequence__c=2;
        PersonalDetailsSec2.pepSectionBodyRich__c='Your personal information will help us identify you when we submit your application for the bureau credit check.Relationship status: De Facto means you are currently living with your partner.Dependants: Any individuals who fall under your financial care.Identification type: Your identification is required to perform the bureau credit check. Is you do not have any of these forms of identification please save your application and call 1300 659 430.';
        PersonalDetailsSec2.pepHeader__c='Residential Details';
        PersonalDetailsSec2.pepSectionStoryRich__c='Residential status: Renting means your name is on the lease. Boarding means your name is not on the lease.Current residential address: If you have lived at your current address for less than 3 years you will be asked for prior addresses.We cannot accept a PO Box.';
        PersonalDetailsSec2.pepSectionStory__c='I am {Residential_Address__c.What_is_Your_Residential_Status__c} and have been for {Residential_Address__c.How_Long_have_you_lived_here__c}. </br> I lived in my previous home for {Residential_Address__c.How_Long_have_you_lived_here__c}.';
        cmsPdSections.add(PersonalDetailsSec2);
        //Creating Employment Section
        PersonalDetailsSec3 = new pepCmsSection__c();
        PersonalDetailsSec3.pepPage__c = objPage.id;
        PersonalDetailsSec3.pepSectionUniqueName__c = 'Employment Details';
        PersonalDetailsSec3.pepType__c='Form';
        PersonalDetailsSec3.pepSequence__c=3;
        PersonalDetailsSec3.pepSectionBodyRich__c='Your personal information will help us identify you when we submit your application for the bureau credit check.Relationship status: De Facto means you are currently living with your partner.Dependants: Any individuals who fall under your financial care.Identification type: Your identification is required to perform the bureau credit check. Is you do not have any of these forms of identification please save your application and call 1300 659 430.';
        PersonalDetailsSec3.pepHeader__c='Employment Details';
        PersonalDetailsSec3.pepSectionStoryRich__c='I am {genesis__Employment_Information__c.Status} and have been in my current role for {genesis__Employment_Information__c.Term}. </br>Before that I was {genesis__Employment_Information__c.BeforeStatus} for {genesis__Employment__c.BeforeTerm}.';
        PersonalDetailsSec3.pepSectionStory__c='I am {genesis__Employment_Information__c.Status} and have been in my current role for {genesis__Employment_Information__c.Term}. </br>Before that I was {genesis__Employment_Information__c.BeforeStatus} for {genesis__Employment__c.BeforeTerm}.';
        cmsPdSections.add(PersonalDetailsSec3);
        insert cmsPdSections;
        createPersonalDetailssection1Question();
    }
    Static void createPersonalDetailssection1Question(){
        
        
        objQuestion1 = pepCommonTrackerController.createCmsQuestion(objPage,PersonalDetailsSec1);
        objQuestion1.pepLabelPriorQuestion__c='Date of birth';
        objQuestion1.pepSObjectApiName__c='Account';
        objQuestion1.pepFieldApiName__c='PersonBirthDate';
        objQuestion1.pepType__c='Date';
        objQuestion1.Is_Date_to_Birth__c=true;
        objQuestion1.pepSequence__c=5;
        objQuestion1.pepRecordSequence__c=1;
        update objQuestion1;
        
        objQuestion3 = pepCommonTrackerController.createCmsQuestion(objPage,PersonalDetailsSec2);
        objQuestion3.pepLabelPriorQuestion__c='Residential status';
        objQuestion3.pepSObjectApiName__c='Residential_Address__c';
        objQuestion3.pepFieldApiName__c='What_is_Your_Residential_Status__c';
        objQuestion3.pepType__c='Picklist';
        objQuestion3.pepSequence__c=1;
        objQuestion3.pepRecordSequence__c=1;
        update objQuestion3;
        
        objQuestion5 = pepCommonTrackerController.createCmsQuestion(objPage,PersonalDetailsSec2);
        objQuestion5.pepLabelPriorQuestion__c='How long have you lived here?';
        objQuestion5.pepSObjectApiName__c='Residential_Address__c';
        objQuestion5.pepFieldApiName__c='How_Long_have_you_lived_here__c';
        objQuestion5.pepType__c='Picklist';
        objQuestion5.pepSequence__c=1;
        objQuestion5.pepRecordSequence__c=3;
        update objQuestion5;
        
        objQuestion6 = pepCommonTrackerController.createCmsQuestion(objPage,PersonalDetailsSec2);
        objQuestion6.pepLabelPriorQuestion__c='Current residential address';
        objQuestion6.pepSObjectApiName__c='Residential_Address__c';
        objQuestion6.pepFieldApiName__c='Address__c';
        objQuestion6.pepType__c='Text';
        objQuestion6.pepSequence__c=1;
        objQuestion6.pepRecordSequence__c=2;
        update objQuestion6 ;
        
        
        objQuestion4 = pepCommonTrackerController.createCmsQuestion(objPage,PersonalDetailsSec3);
        objQuestion4.pepLabelPriorQuestion__c='Employment status';
        objQuestion4.pepSObjectApiName__c='genesis__Employment_Information__c';
        objQuestion4.pepFieldApiName__c='Employment_Status__c';
        objQuestion4.pepType__c='Picklist';
        objQuestion4.pepSequence__c=1;
        objQuestion4.pepRecordSequence__c=1;
        update objQuestion4;
        
        objAnswer7= new pepCmsAnswer__c();
        objAnswer7= pepCommonTrackerController.createCmsAnswer(objQuestion4);
        objAnswer7.Name='self employed';
        objAnswer7.pepDisplayText__c='self employed';
        objAnswer7.pepActualValue__c='self employed';
        objAnswer7.pepSequence__c=6;
        objAnswer7.pepHasDependentQuestions__c=True;
        update objAnswer7;
        
        
        objQuestion7 = pepCommonTrackerController.createCmsQuestion(objPage,PersonalDetailsSec3);
        objQuestion7.pepLabelPriorQuestion__c='Company Address';
        objQuestion7.pepSObjectApiName__c='genesis__Employment_Information__c';
        objQuestion7.pepFieldApiName__c='pepCompany_Address__c';
        objQuestion7.pepType__c='Text';
        objQuestion7.pepSequence__c=3;
        objQuestion7.pepRecordSequence__c=1;
        objQuestion7.pepCMSAnswer__c=objAnswer7.id;
        objQuestion7.pepSection__c=null;
        update objQuestion7;
               
        objAnswer6= new pepCmsAnswer__c();
        objAnswer6= pepCommonTrackerController.createCmsAnswer(objQuestion5);
        objAnswer6.Name='between 1 and 2 years';
        objAnswer6.pepDisplayText__c='between 1 and 2 years';
        objAnswer6.pepActualValue__c='between 1 and 2 years';
        objAnswer6.pepSequence__c=3;
        objAnswer6.pepHasDependentQuestions__c=True;
        update objAnswer6;
        
        
    }
}