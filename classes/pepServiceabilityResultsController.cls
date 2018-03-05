public class pepServiceabilityResultsController {

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
    public String PageName{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG

    public pepServiceabilityResultsController(ApexPages.StandardController controller) 
    {
    
        getCookieData();
        strThanksMsz = '';
        lstApp = new list<genesis__Applications__c>();
        lstAcc =  new list<account>();
        pageName=ApexPages.currentPage().getUrl();
        pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        Page_Label=pages_config__c.getValues(pageName.toLowerCase()).Page_Label__c;//Added by KG
        string strURL = ApexPages.currentPage().getUrl();          
        if(strURL.contains('?'))
        {
            strURL = strurl.substringBefore('?');
        }
        
        strURL= strurl.split('apex/')[1]; 
        system.debug('strurl' +strURL);
        
        //Decline
        if(strURL == 'pepServiceabilityDecline')
            strPageName = 'Decline';   
            
        if(strURL  == 'pepReferredPage')    
             strPageName = 'Referred';  
        
        lstsectionHeader  = [select id , pepSectionBodyRich__c , pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Header' order by pepSequence__c ASC];         
        fetchData();
     

    }
    
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
          if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
               idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        
    }
    
    public void fetchData()
    {
        Map<string,string> childobjects = new Map<string,string>();                                                
                                                
         system.debug('idApplication ::'+idApplication );                                       
                                                
        lstApp = pepInvokeCLMethodHelper.fetchApplications(null,idApplication,null,null,childobjects);  
        
        /*if(lstApp !=null && lstApp[0].Decline_Reason__c !=null)// replace name with Decline reason field
        {            
        system.debug('Decline reason:: '+lstApp[0].Decline_Reason__c);
        
            strDeclineReason = getLabelString(lstApp[0].Decline_Reason__c);
        }else
        {
            strDeclineReason = getLabelString('pepDefaultDeclineReason');
        }*/
        system.debug('strPageName ::'+strPageName );
        lstSection = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, pepSectionUniqueName__c, pepType__c, 
                                                pepSectionStory__c , Page_Name__c  ,pepSectionStoryRich__c,pepSectionBodyRich__c                                                                                          
                                                from pepCmsSection__c
                                                where pepPage__r.pepPageName__c=: strPageName 
                                                AND pepType__c = 'Running Text'
                                                order by pepSequence__c]; 
        if(lstApp!=null && lstApp[0].genesis__Account__c!=null)
        {
           lstAcc  = [select id, FirstName, Name, Phone, RecordType.Name from Account where Id=: lstApp[0].genesis__Account__c];
            // displayMsz = true;
            for(pepCmsSection__c objSection :lstSection )
            {
                if(objSection.pepSectionUniqueName__c == 'Decline2')
                {
                    
                    strTextReason =objSection.pepSectionBodyRich__c;
                }
                if(objSection.pepSectionUniqueName__c == 'ThanksContent')
                {
                   string strTemp1 = objSection.pepSectionBodyRich__c;
                   string str4 = strTemp1.replace('{!ACCOUNT_NAME}', lstAcc[0].Name );
                   strThanksMsz = str4;
                }
                
                 if(objSection.pepSectionUniqueName__c == 'ThanksContentDecline')
                {
                   string strTemp1 = objSection.pepSectionBodyRich__c;
                   string str4 = strTemp1.replace('{!ACCOUNT_NAME}', lstAcc[0].Name );
                   strThanksMsz = str4;
                }
                
            }            
            
            system.debug('Account-- '+  strThanksMsz);
            
        }
        
    }
    
    public void createTask()
    {          
        system.debug('lstApp:: '+lstApp);
        system.debug('lstApp[0].genesis__Account__c:: '+lstApp[0].genesis__Account__c);
        if(lstAcc !=null && lstAcc.size()>0)
        {
            //list<account> lstAcc = [select id, FirstName, Name, Phone, RecordType.Name from Account where Id=: lstApp[0].genesis__Account__c];
            String userId = UserInfo.getUserId();
            Task t = new Task();
            t.OwnerId = userId;
            t.Subject = 'Call me back';
            t.Status = 'Open';
            t.Priority = 'Normal';
            t.WhatId = lstAcc[0].Id ;
            t.ActivityDate = system.today().addDays(1);
            insert t;
            
            system.debug('tasks--'+ t.id);
            
           
        }
       
        
    }
    
    public pageReference getRedirectToLandingPage()
    {
        String redircetPageName=Label.LandingPageRedirect;
        PageReference ref = new Pagereference(redircetPageName);
      //  PageReference ref = Page.pepLandingPage;
        ref.setRedirect(true);
        return ref;
    }
    
    public String getLabelString(String labelName ){
        Component.Apex.OutputText output = new Component.Apex.OutputText();
        output.expressions.value = '{!$Label.' + labelName + '}';
        
        return String.valueOf(output.value);
    }
    
    Public Pagereference checkcookie(){
Pagereference pr=Peputilityclass.checkCookieAndRedirect();
Cookie ApplicationId = new cookie('ApplicationId','',null,0,false);
ApexPages.currentPage().setcookies(new cookie[]{ApplicationId});
return pr;
}

}