/*
This Class is used to handle the working of pepserviceabilityPositive/pepservicebilityNegative1/2/3 Pages.
Added by Varun(Code Refactoring) on August 26,2017
*/
public class pepServiceabilityController {
    
    public list<pepCmsSection__c> lstSection{get;set;}
    public string strSectionHeader{get;set;}
    public Id idApplication{get;set;} 
    public string strPurpose{get;set;}
    public List<genesis__Applications__c> lstApp{get;set;}
    public string strSectionBody{get;set;}
    public string strSectionBody2{get;set;}
    public string strSectionBody3{get;set;}
    
    public string YesOrNo{get;set;}
    private ApexPages.StandardController stdController;
    public pepCmsModelContainer objModel {get; set;}
    public string strFirstName{get;set;}
    public string strMobileNo{get;set;}
    public Id accountId{get;set;}
    public string strAppNumber {get;set;}
    public string strThanksMsz{get;set;}
    
    public pepCmsModelContainer modelConInst {get; set;}
    public boolean isError{get;set;}
    public boolean displayMsz{get;set;}
    public list<pepCmsQuestion__c> lstQuestion{get;set;}
    public static string strMsz{get;set;}
    list<pepCmsSection__c> lstSection1;
    public string strPageName{get;set;}
    public list<pepCmsSection__c> lstsectionHeader{get;set;}
    
    public String Page_Name{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    //Constructor to load the prerequisites  for various methods used in the page ahead.
    public pepServiceabilityController(ApexPages.StandardController controller) { 
    
        page_Name=ApexPages.currentPage().getUrl();//Added by KG
        page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());//Added by KG
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
        
        modelConInst = new pepCmsModelContainer();           
        lstsectionHeader =  new list<pepCmsSection__c>();
        isError =false;
        displayMsz = false;
        lstSection1 = new list<pepCmsSection__c>();
        lstSection =  new list<pepCmsSection__c>();
        
        string strURL = ApexPages.currentPage().getUrl();          
        if(strURL.contains('?'))
        {
            strURL = strurl.substringBefore('?');
        }
        
        lstsectionHeader  = [select id , pepSectionBodyRich__c , pepSectionUniqueName__c,pepSequence__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Header' order by pepSequence__c ASC];
        
        //Decline
        if(strURL == '/apex/pepServiceabilityPositve' || strURL == '/pepServiceabilitypositve' )
        {
            strPageName = 'Serviceability';    
        }   
        if(strURL == '/apex/pepServiceabilitynegative2' || strURL == 'pepServiceabilitynegative2' || strURL == '/apex/pepServiceabilitynegative1' || strURL == 'pepServiceabilitynegative1' || strURL=='/apex/pepServiceabilitynegative3' || strURL=='pepServiceabilitynegative3')      
            strPageName = 'Serviceability Negative2'; 
        
        if(strURL == '/apex/pepServiceabilityNegative' || strURL == 'pepServiceabilityNegative')    
            strPageName = 'Serviceability';  
        
        strAppNumber ='';
        strSectionHeader='';
        lstQuestion = new list<pepCmsQuestion__c>();
           
        getCookieData();
        fetchAffordibikityCheck();
    } 
    //Method to redirect the flow to PersonalDetailsPage.
    public pageReference getRedirect()
    {   
        //Modified by : Sushant Kumar -- added exception handling
        try {
            genesis__Applications__c  aps = new genesis__Applications__c(id=idApplication);
            genesis__Applications__c  app=peputilityclass.savecontinuestatus(aps,'pepPersonalDetails');
            string redircetPageName= pages_config__c.getinstance('peppersonaldetails').Page_Label__c;
            PageReference ref = new Pagereference('/'+redircetPageName); 
            ref.setRedirect(true);
            return ref;
        }
        catch(Exception ex) {
            
            return pepUtilityClass.handlePageException(ex);
        }

    }
    //method to reditrect the flow to landing Page.
    public pageReference getRedirectToLandingPage()
    {
        //Modified by : Sushant Kumar -- added exception handling
        try {
            string redircetPageName= Label.LandingPageRedirect;
            PageReference ref = new Pagereference(redircetPageName);
            ref.setRedirect(true);
            return ref;
        }
        catch(Exception ex) {
            
            return pepUtilityClass.handlePageException(ex);
        }

    }
    //This method will be used to get the cookie data.
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
        
        if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
            idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        
    }
    
    //Calling Api of CloudLending for affordability check. 
    public void fetchAffordibikityCheck()
    {    
        Decimal decAmount;
        decimal decyear;
        String strpaymentFreQuency;
        string strcreditRating;
        Id idClPurpose;
        decimal decIndicativeInterestrate;
        isError = false;
        Map<string,string> childobjects = new Map<string,string>();
        list<Account> lstAcc =  new list<Account>();
        list<clcommon__CL_Product__c> lstCLP;
        list<pepCmsSection__c> lstSection;
        
        genesis.BorrowerAPI3 bApi = genesis.APIFactory.getBorrowerAPI3();
        genesis__Applications__c objApp = [select id, genesis__CL_Purpose__c, genesis__CL_Purpose__r.Name,genesis__Account__c from genesis__Applications__c where Id=: idApplication];
        
        strPurpose = objApp .genesis__CL_Purpose__r.Name;                                      
        lstApp  = pepInvokeCLMethodHelper.fetchApplications(null,idApplication,null,null,childobjects); 
        accountId = lstApp[0].genesis__Account__c; 
        
        if(lstApp!=null && lstApp[0].genesis__Account__c!=null)
        {
            lstAcc  = [select id, FirstName, Name, Phone, RecordType.Name from Account where Id=: lstApp[0].genesis__Account__c];
            
        }
        lstCLP = [select id,clcommon__Product_Name__c from clcommon__CL_Product__c where Id=: lstApp[0].genesis__CL_Product__c];
        
        lstSection = [select Id, Name, pepSectionUniqueName__c, pepSectionStoryRich__c, pepSectionStory__c,pepSectionBodyRich__c,pepSectionBody__c,
                                           pepHeader__c ,pepSequence__c,
                                           (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , pepLabelPriorQuestion__c,
                                            pepGenericErrorMessage__c
                                            from pepQuestion__r order by pepSequence__c ASC)                                             
                                           from pepCmsSection__c
                                           where pepPage__r.pepPageName__c=:strPageName order by pepSequence__c ASC];
        
        string roundedwithdollar = '$' + string.valueOf((lstApp[0].debit_amount__c).setScale(2));
        for(pepCmsSection__c objSection: lstSection)
        {
            //modified by : sushant kumar
            //replace multiple if with else if because all comparisons have only logical check on objSection.pepSectionUniqueName__c
            if(objSection.pepSectionUniqueName__c == 'ThanksMsz')
            {
                string strTemp1 = objSection.pepSectionBodyRich__c;
                strThanksMsz = strTemp1 ;
            }
            
            else if(objSection.pepSectionUniqueName__c =='Serviceabiltylast')
            {
                strSectionBody3 = objSection.pepSectionBodyRich__c;
                strSectionBody3 = strSectionBody3.replace('{!genesis__Applications__c.genesis__CL_Purpose__r.Name}', strPurpose);
            }
            else if(objSection.pepSectionUniqueName__c == 'Greeting') {
                strSectionHeader = objSection.pepHeader__c;
            }   
            
            else if(objSection.pepSectionUniqueName__c == 'Let See What we can do')
            {
                strSectionHeader = objSection.pepHeader__c;
            }
            
            else if(objSection.pepSectionUniqueName__c == 'Serviceability Section 2')
            {
                
                string str1 = objSection.pepSectionBodyRich__c;
                string str2 = str1.replace('{!genesis__Applications__c.genesis__Loan_Amount__c}', lstApp[0].genesis__Loan_Amount__c.format());
                str2 = str2.replace('{!genesis__Applications__c.pep_Loan_Type__c}', lstCLP[0].clcommon__Product_Name__c);
                str2 = str2.replace('{!genesis__Applications__c.genesis__CL_Purpose__r.Name}', strPurpose);
                str2 = str2.replace('{!objApplication.genesis__Interest_Rate__c}', String.valueOF(lstApp[0].genesis__Interest_Rate__c.setscale(2)));
                
                Decimal toround = lstApp[0].debit_amount__c;
                Decimal rounded = toround.setScale(2);
                
                str2 = str2.replace('{!genesis__Applications__c.Debit_amount__c}', roundedwithdollar);
                
                if(lstApp[0].Debit_Frequency__c == 'BI-WEEKLY')
                {    
                    lstApp[0].Debit_Frequency__c = 'fortnightly';
                }
                             
                if(lstApp[0].Debit_Frequency__c != null && lstApp[0].Debit_Frequency__c != '')
                {
                    string frequency = lstApp[0].Debit_Frequency__c.tolowercase();
                    lstApp[0].Debit_Frequency__c = frequency;
                }

                str2 = str2.replace('{!genesis__Applications__c.Debit_Frequency__c}', lstApp[0].Debit_Frequency__c);
                strSectionBody = str2.replace('{!genesis__Applications__c.Requested_Term__c}', string.valueOf(lstApp[0].genesis__Term__c));
            }
            else if(objSection.pepSectionUniqueName__c == 'Serviceability Section 2a')
            {  
                string term = '';
                if(lstApp[0].genesis__Term__c != null)
                {
                    term = string.valueOf(lstApp[0].genesis__Term__c/12);
                }
                
                string str3 = objSection.pepSectionBodyRich__c;
                string str4 = str3.replace('${!genesis__Applications__c.Debit_amount__c}', roundedwithdollar);
                str4 = str4 .replace('{!genesis__Applications__c.Debit_Frequency__c}', lstApp[0].Debit_Frequency__c);
                strSectionBody2 = str4 .replace('{!genesis__Applications__c.Requested_Term__c}', term);
            }
            
            else if(objSection.pepSectionUniqueName__c == 'AppNumber')
            {
                string str7 = objSection.pepSectionBodyRich__c;
                strAppNumber = str7.replace('{!genesis__Applications__c.Name}',lstApp[0].Name  );             
            }
        }
    }
    
    public pageReference RedirectToEnd()
    {
        return null;
    }
    //This method will redirect the flow to Loan Details Page.
    public pageReference RedirectToLoanDetail()
    {
        YesOrNo = 'yes';
        PageReference ref;
        if(YesOrNo == 'yes')
        {
            string redircetPageName= pages_config__c.getinstance('peppersonaldetails').Page_Label__c;
            ref = new Pagereference('/'+redircetPageName); 
            ref.setRedirect(true);
        }       
        
        return ref;
    }
    //This method will be used to redirect the flow to pepServiceabilityNegative.
    public pageReference RedirectToNegative()
    {
        //modified by : sushant kumar
        //declared variable on top of the class
        PageReference ref;
        Map<String,SObject> relatedObjects = new Map<String,SObject>();
        Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();
        string redircetPageName;
        genesis__Applications__c objApplication;
        
        if(YesOrNo == 'no')
        {
            
            if(idApplication != null && String.valueof(idApplication) !='') {
                
                objApplication = new genesis__Applications__c(id=idApplication,genesis__Status__c='Closed'); 
                if(objApplication.Debit_Frequency__c == 'fortnightly')
                {    
                    objApplication.Debit_Frequency__c = 'BI-WEEKLY';
                }  
                objApplication.pepNavigation_Status__c = pepUtilityClass.getNavigationPageName('pepServiceabilityNegative3');  
                objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
            }
            redircetPageName = pages_config__c.getinstance('pepServiceabilityNegative3').Page_Label__c;
        }
        if(YesOrNo == 'yes') {
            
            if(idApplication != null && String.valueof(idApplication) !='') {
                
                String navigationStatus = pepUtilityClass.getNavigationPageName('pepPersonalDetails');
                objApplication=new genesis__Applications__c(id=idApplication,genesis__Status__c='AWAITING PERSONAL INFORMATION',pepNavigation_Status__c=navigationStatus); 
                if(objApplication.Debit_Frequency__c == 'fortnightly')
                {    
                    objApplication.Debit_Frequency__c = 'BI-WEEKLY';
                }    
                objApplication =  pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
            }
            redircetPageName = pages_config__c.getinstance('peppersonaldetails').Page_Label__c;
        }
        
        ref = new Pagereference('/'+redircetPageName); 
        ref.setRedirect(true);
        return ref;
    }
    
    public void setParam()
    {
        YesOrNo = 'yes';
    }
    //Assigning a Task for the user(credit officer currently working with the customer) to follow up the customer on flow going to ServiceabilityNegative.
    public void createTask()
    {
        modelConInst.strPageName='Serviceability';
        modelConInst.strSectionName='AccountInfo';
        modelConInst.ReadControlValue();   
        list<account> lstAcc;
        
        if(accountId !=null)
        {
           lstAcc = [select id, FirstName,LastName, Phone, RecordType.Name from Account where Id=: accountId limit 1];
            
            if( lstAcc[0].RecordType.Name == 'Person Account')
            {
                lstAcc[0].LastName = strFirstName;
            }
            
            lstAcc[0].PersonMobilePhone= strMobileNo;
            strThanksMsz = strThanksMsz.replace('{name}', strFirstName);
            try {
                update lstAcc;
            }
            catch(exception e) {
                
            }
            
            ServiceabilityNegativeTask__c assignedUser=ServiceabilityNegativeTask__c.getValues('userIdtoTask');
            Task t = new Task();
            t.OwnerId = assignedUser.User_Id__c;
            t.Subject = 'Call me back';
            t.Status = 'Open';
            t.Priority = 'Normal';
            t.WhatId = accountId ;
            t.ActivityDate = system.today().addDays(1);
            insert t;
        }
    }
    //This method will be used to check the cookie.
    Public Pagereference checkcookie(){
        //modified by : sushant Kumar
        //changed if-else cunstructs to turnery operator and added exception handling
        try {
            Pagereference pr = Peputilityclass.checkCookieAndRedirect();
            return (pr==null)? Peputilityclass.HandleRedirectSecurity() : pr;
        }
        catch(Exception ex) {
            return pepUtilityClass.handlePageException(ex);
        } 
    }
    
}