// ---------------------------------------------------------------------------------------------------------
// This Controller is used to get old info of customer and to show terms and condition. 
//Code Refactoring done by Varun on August 26,2017 
// ---------------------------------------------------------------------------------------------------------

public  class PepApplyNowController
{         
    public Boolean strSelectedValue1;       
    public String strSelectedValue   { get; set;}      
    public List<wrapperSection> lstWrapperSection{get;set;}
    public Integer sectionNumber;
    @TestVisible private List<selectOption> lstclPurposeSelectOption; 
    @TestVisible public string strUrl;
    public boolean isError{get;set;}  
    public genesis__Applications__c objApplication{get;set;} 
    public pepCmsModelContainer  modelConInstance{get;set;}
    public pepCmsModelContainer_new  modelConInstance_New{get;set;}
    public String purposeName {get;set;}
    Public Pagereference  objNextPage; 
    public String sectionName {get;set;}
    public Integer intCurrentPageNumber;
    public Integer intPreviousPageNumber{get;set;}      
    public Id idDefaultCompany;
    public id idBusinessAccount;
    @TestVisible private String  returnValue;
    @TestVisible private String referralCode;        
    @TestVisible private Map<Id,String> mapOfPurposeIdToPurposeName;
    @TestVisible List<genesis__Rate_Card_Setup_Detail__c> lstRateCardSetupDetail;
    public String strMinLoanAmount{get;set;}
    public String strMaxLoanAmount{get;set;}       
    public String page_Name{get;set;}
    public String page_Label{get;set;}
    
    //Added by IJ These parameters would be fetched from the URL and saved against the application for staff loans and other purposes
    public string p1;
    public string p2;
    public string p3;
    public string p4;
    
    //   This Constructor is used to get the parameters thorough cookies.
    public pepApplyNowController()
    {
        strurl = ApexPages.currentPage().getUrl(); 
        if(strurl.contains('?'))
        {
            strurl = strurl.substringBefore('?');
        }
        
        strurl = strurl.split('apex/')[1]; 
        page_Name=ApexPages.currentPage().getUrl();
        page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
        
        
        objApplication = new  genesis__Applications__c(); 
        
        //added by : Sushant Kumar, purpose : to include apllication source information on creation of new application
        objApplication = pepUtilityClass.fillApplicationSourceInfo(objApplication);                                                                                                           
        
        MapOfPurposeIdToPurposeName = new Map<id,String>();                      
        referralCode= apexpages.currentpage().getparameters().get('Ref');
        modelConInstance_new = new pepCmsModelContainer_new();
        if(ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')!=null)
        {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); 
        }    
        
        lstRateCardSetupDetail = new List<genesis__Rate_Card_Setup_Detail__c>();
        modelConInstance = new pepCmsModelContainer();         
        if( ApexPages.currentPage().getParameters().get('redirectFromPageNo') != null 
           &&  ApexPages.currentPage().getParameters().get('redirectFromPageNo') !='')
        {
            intPreviousPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('redirectFromPageNo'));     
            
        }
        
        intCurrentPageNumber =  1;              
        sectionNumber=1;                           
        lstWrapperSection = new List<wrapperSection>();
        loadClPurpose(); 
        if(strurl == 'pepApplyNow')
        { 
            //entered by varun to load the Application through cookies.
            getcookiedata();
            fetchApplication();
            loadCMSContentForApplyPage();
            p1 = ApexPages.currentPage().getParameters().get('p1');
            p2 = ApexPages.currentPage().getParameters().get('p2');         
            p3 = ApexPages.currentPage().getParameters().get('p3');
            p4 = ApexPages.currentPage().getParameters().get('p4');
            
            if(p1 != null)
            {
                if(p1.length()>255)
                {
                    p1 = p1.substring(0,255);
                }
                Cookie param1 = new cookie('param1',p1,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param1});
            }
            else
            {
                p1 = '';
                
            }
            
            if(p2 != null)
            {
                if(p2.length()>255)
                {
                    p2 = p2.substring(0,255);
                }
                Cookie param2 = new cookie('param2',p2,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param2});
            }
            
            else
            {
                p2 = '';
                
            }            
            
            if(p3 != null)
            {
                if(p3.length()>255)
                {
                    p3 = p3.substring(0,255);
                }
                Cookie param3 = new cookie('param3',p3,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param3});
            }
            else
            {
                p3 = '';
                
            }            
            
            if(p4 != null)
            {
                if(p4.length()>255)
                {
                    p4 = p4.substring(0,255);
                }
                Cookie param4 = new cookie('param4',p4,null,-1,false);
                ApexPages.currentPage().setcookies(new cookie[]{param4});
            }
            else
            {
                p4 = '';
                
            }            
            
        }
        loadDefaultCompany();     
        
        //Modified By : Sushant Kumar, purpose : this code will put application source information in cookies and these values
        //will be used on loan detail page for putting apllication source information in genesis application in case of application
        //instance is not created already on landing page.
        pepUtilityClass.setParametersInCookie();
    }
    
    // This method is used to get application id from cookies.
    
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
        if (cookieApplicationId == null)
        {
            //cookieApplicationId = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
            
        }        
        else if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
            objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        
    }
    
    // This method is used to fetch Application
    
    public void fetchApplication()
    {
        
        Map<string,string> childobjects = new Map<string,string>();       
        String[] lstTypes = new String[]{'Expense_and_Debt__c'};
            if(objApplication != null && objApplication.Id !=null)
        {
            
            List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
            if(lstApplication != null && lstApplication.size() >0)
            {        
                objApplication = lstApplication[0];
                //added by : Sushant Kumar, purpose : to include apllication source information on creation of new application
                objApplication = pepUtilityClass.fillApplicationSourceInfo(objApplication);                                                                                                             
            }
            
            
        }
    }
    
    // This method is used to load default company
    
    public void loadDefaultCompany()
    {
        pepDefaultCompany__c  objDefaultCompany = pepDefaultCompany__c.getInstance('Company Id');
        IdDefaultCompany = objDefaultCompany.pepDefault_Company_Id__c;
        idBusinessAccount = objDefaultCompany.pepBusinessAccount__c;
    }
    
    // This method is used to load CL purpose Object.
    
    public void loadClPurpose()
    {
        lstclPurposeSelectOption = new List<selectOption>(); 
        if(strurl == 'peplandingpage')
            lstclPurposeSelectOption.add(new SelectOption('', ''));
        else
            lstclPurposeSelectOption.add(new SelectOption('', 'choose one'));
        for(clcommon__CL_Purpose__c objPurpose : [select id,name from clcommon__CL_Purpose__c order by Serial_No__c asc limit 1000])
        {                
            lstclPurposeSelectOption.add(new SelectOption(objPurpose.Id, objPurpose.Name));
            MapOfPurposeIdToPurposeName.put(objPurpose.Id,objPurpose.name);
        }        
        
    }
    
    // This method is used to load CMS for aaply now page
    
    private void loadCMSContentForApplyPage()
    {
        
        List<pepCmsSection__c> lstlandingPageCmsSection =[select id,pepHeader__c,pepSectionUniqueName__c,
                                                          (select id,pepLabelAfterQuestion__c,
                                                           pepLabelPriorQuestion__c,
                                                           pepSequence__c,pepIsRequired__c,
                                                           pepType__c,pepSubType__c,
                                                           pepGenericErrorMessage__c,
                                                           pepSObjectApiName__c,
                                                           pepFieldApiName__c
                                                           from pepQuestion__r order by pepSequence__c asc) 
                                                          from pepCmsSection__c where pepPage__r.pepPageName__c ='Apply Page'];   
        
        map<id,pepCmsQuestion__c> mapAllQuestions = new map<id,pepCmsQuestion__c>( [SELECT  pepSection__c,pepRecordSequence__c,pepSection__r.Name ,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                                                    pepIsRequired__c, pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                                                    pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, Id, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,
                                                                                    (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                                                     FROM pepCmsAnswer__r order by pepSequence__c ASC ), 
                                                                                    (SELECT  pepSection__c,pepRecordSequence__c,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c ,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                                                                     pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepRelatedCSS__c
                                                                                     FROM CmsQuestion__r
                                                                                     ORDER BY pepSequence__c ASC) 
                                                                                    FROM pepCmsQuestion__c where pepPage__r.pepPageName__c ='Apply Page'
                                                                                    ORDER BY pepSequence__c ASC]);
        
        if(lstlandingPageCmsSection != null && lstlandingPageCmsSection.size() > 0)
        { 
            for(pepCmsSection__c objSection :lstlandingPageCmsSection)
            {
                if(objSection.pepQuestion__r != null && objSection.pepQuestion__r.size() > 0)
                {                       
                    wrapperSection objWrapperSection = new wrapperSection();
                    objWrapperSection.objSection = objSection ;
                    objWrapperSection.lstWrapperQuestion = new List<wrapperApplication>();
                    for(pepCmsQuestion__c objQues : objSection.pepQuestion__r)
                    { 
                        wrapperApplication objWrapper = new  wrapperApplication ();
                        objWrapper.objQuestion = objQues;
                        objWrapper.lstExpectedAnswers = new list<wrapperAnswer> ();
                        for(pepCmsAnswer__c objAnswer : mapAllQuestions.get(objQues.Id).pepCmsAnswer__r)
                        {
                            wrapperAnswer objwrapperAnswer = new  wrapperAnswer();
                            objwrapperAnswer.objCmsAnswer = objAnswer;                                       
                            objWrapper.lstExpectedAnswers.add(objwrapperAnswer); 
                        }
                        objWrapperSection.lstWrapperQuestion.add(objWrapper);                                                    
                    }         
                    lstWrapperSection.add(objWrapperSection);
                }
                
            }
            
            
            
        }                                                               
        
    }
    
    // This wrapper is used to capture CMS data
    
    public class wrapperApplication
    {
        public pepCmsQuestion__c objQuestion{get;set;} 
        public List<wrapperAnswer> lstExpectedAnswers {get; set;}//answer of question    
        public List<selectoption> lstSelectOption{get;set;}
        public String strAnswer
        {
            get { return strAnswer; }
            
            set {
                if(objQuestion.pepType__c =='Currency')
                {
                    if(value != null)
                    {
                        strAnswer= value.replace(',','');
                    }
                    else
                    {
                        strAnswer = value;
                    }
                }
                else
                {
                    strAnswer =value;
                }
                
            }
        }
        
    }
    
    public class wrapperSection
    {
        
        public pepCmsSection__c  objSection{get;set;}
        public List<wrapperApplication> lstWrapperQuestion{get;set;}
    }
    
    public class wrapperAnswer
    {
        public pepCmsAnswer__c objCmsAnswer {get; set;}
    }
    
    
    //This method is used to update application from 2nd page.
    
    public PageReference continueApply()
    {
        
        try
        {
            if(objApplication != null)
            {
                if(ReturnValue!=null && ReturnValue!='')
                    objApplication.IP_Address__c =  ReturnValue;        
                
                if(objApplication.id != null || ApexPages.currentPage().getcookies().get('ApplicationId') != null)
                {
                    
                    Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();
                    Map<String,SObject> relatedObjects = new Map<String,SObject>();
                    String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepIncomePage');
                    Map<string,string> childobjects1 = new Map<string,string>();       
                    
                    if(ApexPages.currentPage().getcookies().get('ApplicationId') != null &&  ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != null)
                    {
                        
                        List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null,PepEncryptDecryptData.DecryptData(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue()),null,null,childobjects1);
                        if(lstApplication != null && lstApplication.size() >0)
                        {        
                            objApplication = lstApplication[0];
                            
                        }
                        
                        
                    }
                    
                    //added by : Sushant Kumar, purpose : to include apllication source information on creation of new application
                    objApplication = pepUtilityClass.fillApplicationSourceInfo(objApplication);                                                                                                           
                    objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                    
                    if(p1 !=null && p1 !='')
                        objApplication.pepP1__c = P1;
                    if(P2 !=null && p2 !='') 
                        objApplication.pepP2__c = P2; 
                    if(P3 !=null && p3 !='')   
                        objApplication.pepP3__c = P3; 
                    if(P4 !=null && p4 !='')    
                        objApplication.pepP4__c = P4;
                    loadApplicationfromcookie();
                    objApplication.Apply_page_policy__c =  true;
                    objApplication.Apply_page_policy_time_stamp__c =  dateTime.Now();                           
                    objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
                    string redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
                    objNextPage =new Pagereference('/'+redircetPageName);
                    objNextPage.setRedirect(true);
                    return objNextPage;
                }
                
                else
                {
                    
                    String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepLoanDetails');
                    objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                    string redircetPageName= pages_config__c.getinstance('peploandetails').Page_Label__c;
                    objNextPage =new Pagereference('/'+redircetPageName);                      
                    objNextPage.setRedirect(True);
                    return objNextPage;
                }
            }
            
            
            return null;
        }
        catch(Exception ex)
        {
            
            Cookie objCookieEx = new Cookie('ExceptionId',pepEncryptDecryptData.EncryptData(String.valueof(ex.getStackTraceString())),null,-1,false);
            string redircetPageName= pages_config__c.getinstance('pepTechnicalException').Page_Label__c;
            
            Pagereference objNextPage = new Pagereference('/'+redircetPageName); 
            objNextPage.setCookies(new Cookie[]{objCookieEx});
            return  objNextPage;
        }
    }
    
    //This method is used to call the Landing Page on the click of Edit link on second page.   
    
    public PageReference backOnLandingPage() {
        try
        {
            string redircetPageName= pages_config__c.getinstance('peplandingpage').Page_Label__c;
            pageReference objPreviousPage = new Pagereference('/'+redircetPageName); 
            objPreviousPage.setRedirect(false);
            return objPreviousPage ;
        }
        catch(Exception ex)
        {
            Cookie objCookieEx = new Cookie('ExceptionId',pepEncryptDecryptData.EncryptData(String.valueof(ex.getStackTraceString())),null,-1,false);
            string redircetPageName= pages_config__c.getinstance('pepTechnicalException').Page_Label__c;
            
            Pagereference objNextPage = new Pagereference('/'+redircetPageName); 
            objNextPage.setCookies(new Cookie[]{objCookieEx});
            return  objNextPage;
        }
    } 
    
    // This method is used to Redirect the application on the basis of page name
    
    public pageReference retrieveAppCode()
    {
        try{    
            string redircetPageName= pages_config__c.getinstance('pepretrieveapp').Page_Label__c;
            pageReference p1 = new Pagereference('/'+redircetPageName);
            p1.setRedirect(true); 
            return p1;   
        }
        catch(Exception ex)
        {
            Cookie objCookieEx = new Cookie('ExceptionId',pepEncryptDecryptData.EncryptData(String.valueof(ex.getStackTraceString())),null,-1,false);
            string redircetPageName= pages_config__c.getinstance('pepTechnicalException').Page_Label__c;
            
            Pagereference objNextPage = new Pagereference('/'+redircetPageName); 
            objNextPage.setCookies(new Cookie[]{objCookieEx});
            return  objNextPage;
        }
    }
    
    // This method is used to save the value for existing customer  
    
    public void applyNowQuery()
    {
        String strSelected = ApexPages.currentPage().getParameters().get('text');
        String rowNo = ApexPages.currentPage().getParameters().get('rowIndex');
        
        if(rowNo != null)
        {
            Integer intRowNo = Integer.valueOf(rowNo);
            for(WrapperApplication objWrapper: lstWrapperSection[intRowNo -1].lstWrapperQuestion)
            {
                
                
                if(objWrapper.objQuestion.pepFieldApiName__c =='Existing_Customer__c' && objWrapper.objQuestion.pepType__c == 'Button' )
                {
                    objApplication.put(objWrapper.objQuestion.pepFieldApiName__c,strSelected);
                    Cookie existingcustomer = new cookie('existingcustomer',strSelected,null,-1,false);
                    ApexPages.currentPage().setcookies(new cookie[]{existingcustomer});
                    
                }
            }
            
        }
        
    }
    
    // This method is used to load values from cookies
    
    Public void loadApplicationFromCookie(){
        if(ApexPages.currentPage().getcookies().get('existingcustomer') != null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue() != null && ApexPages.currentPage().getcookies().get('existingcustomer').getvalue() != '')
            objApplication.Existing_Customer__c=ApexPages.currentPage().getcookies().get('existingcustomer').getvalue();
        
    }   
}