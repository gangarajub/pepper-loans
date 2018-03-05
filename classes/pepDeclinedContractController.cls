public class pepDeclinedContractController{

    // Variable Declaration
    public id idApplication{get;set;} 
    public list<genesis__Applications__c> lstApp{get;set;}
    public list<pepCmsSection__c> lstSection{get;set;}
    string strPageName;
    public list<pepCmsSection__c> lstsectionHeader{get;set;}
    public string strDeclineReason{get;set;}
    public string strThanksMsz{get;set;}
    public list<account> lstAcc{get;set;}
    public string strTextReason{get;set;}
    Public string page_Name{get;set;}
    Public string Page_Label{get;set;}
    
    public pepDeclinedContractController(ApexPages.StandardController controller) 
    {
        try{
        page_Name=ApexPages.currentPage().getUrl();
        page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
        getCookieData();
        strThanksMsz = '';
        lstApp = new list<genesis__Applications__c>();
        lstAcc =  new list<account>();
        
        lstsectionHeader  = [select id , pepSectionBodyRich__c , pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Header' order by pepSequence__c ASC];         
        fetchData();
         }
         Catch(Exception ex){
         String str='';
         str=ex.getmessage();
         system.debug('=='+ex.getmessage());
         //Peputilityclass.CreateExceptionRecord(str,'Docusign Declined but error in CL method');
         throw ex;//throwing the exception for not interupting the normal flow.
         }       
    }
    
    public void getCookieData()
    {
          Cookie cookieApplicationId = ApexPages.currentPage().getcookies().get('Applicationid');  
          if(cookieApplicationId != null  && cookieApplicationId.getvalue()  != '' && cookieApplicationId.getvalue()!=null)
        {                           
               idApplication =  pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        
    }
    
    public void fetchData()
    {
        
        Map<string,string> childobjects = new Map<string,string>();                                                
                                                
         system.debug('idApplication ::'+idApplication );                                       
                                                
        lstApp = pepInvokeCLMethodHelper.fetchApplications(null,idApplication,null,null,childobjects);  
        System.debug('@@@@@lstapp'+lstapp);
        if(lstApp !=null && lstApp[0].Decline_Reason__c != null)// replace name with Decline reason field
        {            
        system.debug('Decline reason:: '+lstApp[0].Decline_Reason__c);
        
            strDeclineReason = getLabelString(lstApp[0].Decline_Reason__c);
        }else
        {
            strDeclineReason = getLabelString('pepDefaultDeclineReason');
        }
        system.debug('strPageName ::'+strPageName );
        lstSection = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, pepSectionUniqueName__c, pepType__c, 
                                                pepSectionStory__c , Page_Name__c  ,pepSectionStoryRich__c,pepSectionBodyRich__c                                                                                          
                                                from pepCmsSection__c
                                                where pepPage__r.pepPageName__c= 'Application Close'
                                                AND pepType__c = 'Running Text'
                                                order by pepSequence__c]; 
        if(lstApp!=null && lstApp[0].genesis__Account__c!=null)
        {
           lstAcc  = [select id, FirstName, Name, Phone, RecordType.Name from Account where Id =: lstApp[0].genesis__Account__c];
            // displayMsz = true;
            
            if(lstSection != null && lstSection.size() > 0)
            {
                for(pepCmsSection__c objSection :lstSection )
                {
                    if(objSection.pepSectionUniqueName__c == 'App Close Section2')
                    {
                        strTextReason = objSection.pepSectionBodyRich__c;
                    }
                    if(objSection.pepSectionUniqueName__c == 'ThanksContent')
                    {
                       string strTemp1 = objSection.pepSectionBodyRich__c;
                       string str4 = strTemp1.replace('{!ACCOUNT_NAME}', lstAcc[0].Name );
                       strThanksMsz = str4;
                    }
                    
                     if(objSection.pepSectionUniqueName__c == 'App Close Section12')
                    {
                       string strTemp1 = objSection.pepSectionBodyRich__c;
                       string str4 = strTemp1.replace('{!ACCOUNT_NAME}', lstAcc[0].Name );
                       strThanksMsz = str4;
                    }
                    
                }
            }            
            
            system.debug('Account-- '+  strThanksMsz);
            
        }
        
   }
    
 
     
    public pageReference getRedirectToLandingPage()
    {
        PageReference ref = new Pagereference(Label.LandingPageRedirection);
        ref.setRedirect(true);
        return ref;
    }
    
    public String getLabelString(String labelName ){
        Component.Apex.OutputText output = new Component.Apex.OutputText();
        output.expressions.value = '{!$Label.' + labelName + '}';
        
        return String.valueOf(output.value);
    }
    
    Public Pagereference checkcookie()
    {
        Pagereference pr=Peputilityclass.checkCookieAndRedirect();
        return pr;
    }
    public void rejectApplication()
    {
        Date pepsystemDate;
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        if(cookieApplicationId!=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')
        {            
            idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        else
        {
            idApplication=ApexPages.currentPage().getParameters().get('id');
        }
        
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
         if(!test.isrunningtest())
            pepsystemDate = util.getCurrentSystemDate();
        
        List<genesis__Applications__c> lstapplication =[Select id,genesis__Status__c,genesis__Expected_Close_Date__c,pepLastSaved__c from genesis__Applications__c where id=:idApplication];
        
        if(lstapplication != null && lstapplication.size() > 0)
        {
            lstapplication[0].genesis__Status__c ='CONTRACT REJECTED';
            
            if(pepsystemDate != null)
            {
                lstapplication[0].genesis__Expected_Close_Date__c = pepsystemDate;
            }
            
            update lstapplication[0];
            Cookie ApplicationId = new cookie('ApplicationId','',null,0,false);
            ApexPages.currentPage().setcookies(new cookie[]{ApplicationId});
        }          
    }
}