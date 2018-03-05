public class pepCmsHeaderComponentController{    
   public Boolean strFlag=false;
   public Integer IntCookiePageNo;
   Public String inputValue{get;set;}
   public List<pepCmsQuestion__c> lstQuestionsRetrieveApp{get;set;} 
   Public Map<string,List<pepCmsPage__c>> pageNameToCmsPages{get;set;}
   Public boolean showBlankretrieval{get;set;}
   public Boolean flag{
    get{
        return strFlag;
    }
    set;
    }
    public string email{get;set;}
    public string phone{set;get;}
    public string retrieveEmail{get;set;}
    public string retrievePhone{get;set;}
    public string strPopUp;
    public Map<id,string> MapOfPurposeIdToPurposeName;
    public boolean isdisplayRetrieve{get;set;}
    public boolean isdisplayPersonDetail{get;set;}
    public boolean isRetrieveApp{get;set;}
    public string strRetrieveCode{get;set;}
    public string strRetCodeFromOldApp{get;set;}
    public genesis__Applications__c objApplicationOld;
    public Account acc;
    public string errorMsg{get;set;}
    public boolean isError{get;set;}
   
    public PageReference EditLink() {
        return null;
    }

//public string strCreditRating {get;set;}
public String strPageName{get;set;}// page name
//public string strPurposeId  {get; set;}
public string strPurposeName{get;set;}
public Integer pageNo{get;set;}
public Integer intpreviousPageNo{get;set;}
public Integer intRedirectPage{get;set;}
public list<pepCmsSection__c >lstSS {get ;set;}
public list<pepCmsSection__c >lstSec{get ;set;}
public list<pepCmsSection__c >lstSection {get;set;}
public list<pepCmsSection__c >lstUpdatedSectionStory {get;set;}
public Attachment objAttachment{get;set;}
//public string test{get;set;}
public genesis__Applications__c objApplication;
public genesis__Applications__c getobjApplication()
{
    return objApplication;
    
}

public string strPurposeId;
public string getstrPurposeId()
{
    return strPurposeId;
    
}

public integer intCurrentPageNo;
public integer getintCurrentPageNo()
{
    return intCurrentPageNo;
    
}

public void setintCurrentPageNo(integer currentpageno)
{
    strpageName = 'Header';
    intCurrentPageNo = currentpageno;
    lstUpdatedSectionStory = new list<pepCmsSection__c > ();
    generateSectionStory(strpageName);
    getCookieData();
    
    
}

public void setobjApplication(genesis__Applications__c objApp)
{
    try{
    strpageName = 'Header';
    objApplication = objApp;
    lstUpdatedSectionStory = new list<pepCmsSection__c > ();
    MapOfPurposeIdToPurposeName = new Map<id,string>();
    if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
        for(clcommon__CL_Purpose__c objPurpose : [select id,name from clcommon__CL_Purpose__c order by Serial_No__c asc limit 1000])
            {                
                
                MapOfPurposeIdToPurposeName.put(objPurpose.Id,objPurpose.name);
            }  
    }
    else{
         PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
         throw new DMLException('This is a SOQL limit exception handling mechanism');
    }   
    generateSectionStory(strpageName);
    }
    Catch(exception ex){
    }
    
}

public void setstrPurposeId(string  PurposeId)
{
    
    strpageName = 'Header';
    strPurposeId = PurposeId;
    lstUpdatedSectionStory = new list<pepCmsSection__c > ();
     
    generateSectionStory(strpageName);
}



    public pepCmsHeaderComponentController(){
        try{
        strpageName = 'Header';
        lstSS = new list<pepCmsSection__c > ();
        //Creating Pages Map to dynamically access the Pages corresponding to 'Header' Page.
        List<pepCmsPage__c> cmsPages;
        if(Limits.getQueries()+1<=Limits.getLimitQueries()){
        cmsPages= [Select id, pepPageName__c,(select id,pepSectionBody__c,pepSectionStoryRich__c,pepSectionUniqueName__c ,pepPage__c from pepSection__r) from pepCmsPage__c LIMIT 50000];
        }
        else{
        pepUtilityClass.sendExceptionEmail(pepUtilityClass.getCurrrentString());
        throw new DMLException('This is SOQL Error Handling Mechanism.');
        }
        
        pageNameToCmsPages=new Map<string,List<pepCmsPage__c>>();
        if(cmsPages!= null && cmsPages.size()>0){
        for(pepCmsPage__c cmsPage:cmsPages){
        if(String.valueof(cmsPage.pepPageName__c)!='' && cmsPage.pepPageName__c!=null){
        if(!pageNameToCmsPages.containskey(cmsPage.pepPageName__c))
        pageNameToCmsPages.put(cmsPage.pepPageName__c,new List<pepCmsPage__c>());
        pageNameToCmsPages.get(cmsPage.pepPageName__c).add(cmsPage);
        }
       }
      }        
        Section(strpageName); 
        configure();
        showBlankretrieval=false;
       }
       Catch(Exception ex){
       }
    }
    
    public string getBackgroundImage(){
   
        System.debug('strPageName: ' + strPageName );
        
        List<pepCmsPage__c> lstCMSPage = pageNameToCmsPages.get(strPageName);
        system.debug('***** lstCMSPage   '+lstCMSPage );
        Attachment objAttachment;
        
        String strQuery = 'Select id, Name,ContentType, ParentId from Attachment where';
        if(strPurposeId != '' && strPurposeId != null)
        {
            strQuery = strQuery + ' ParentId = \''+strPurposeId +'\' OR';
        }
        
        strQuery = strQuery + ' ParentId =\''+lstCMSPage[0].Id +'\'';
        system.debug('***** strQuery   '+strQuery);
        list<Attachment> lstAtt;
       
        lstAtt = Database.query(strQuery);
       
        if(lstAtt != NULL && lstAtt.size() > 0)
        {
            for(Attachment att: lstAtt)
            {
                if(att.ParentId == strPurposeId){
                    objAttachment = att;
                    break;
                } else{
                    objAttachment = att;
                }
            }
        }
        if(objAttachment != NULL && objAttachment.id != null)
        {
            return '/servlet/servlet.FileDownload?file=' + objAttachment.id;
        }
    // Commented by Mitali Telang  - Code Optimization exercise - 28/06/2017    
     /*   if(strPurposeId != '' && strPurposeId != null){
            list<Attachment> lstAtt = [Select id, Name,ContentType FROM Attachment where ParentId =: strPurposeId limit 1];
            if(lstAtt.size() >0){
                objAttachment = lstAtt[0];
                return '/servlet/servlet.FileDownload?file=' + objAttachment.id;
            }
            
        }
        
      list<pepCmsPage__c> lstPage = [select Id, (Select id, Name,ContentType FROM Attachments) from pepCmsPage__c where pepPageName__c =: strPageName ];      
      
        
      if(lstPage.size() > 0 && lstPage[0].attachments != null && lstPage[0].attachments.size() > 0){
          objAttachment = lstPage[0].attachments[0]; 
          return '/servlet/servlet.FileDownload?file=' + objAttachment.id;
      } */

        
        return '';
        
        }
        
        
    
    
    
    
    public list<pepCmsSection__c> Section(string strpageName)
    {
        
        //1..
        list<pepCmsPage__c>lstPages = pageNameToCmsPages.get(strpageName);
        
        if(lstPages.size() > 0 && lstPages[0].pepSection__r != null && lstPages[0].pepSection__r.size() > 0)
        {
          lstSec = lstPages[0].pepSection__r ; 
          system.debug('lstSec :: '+lstSec);
          
          
          
        }
      return lstSec;
    }
    
   
    
     public pageReference redirectToPages()
    {
       System.debug('amit kumarrrr'+intCurrentPageNo);
       Pagereference p;
       String redircetPageName= pages_config__c.getinstance('peploandetails').Page_Label__c;  
       p=new Pagereference('/'+redircetPageName);
       p.setredirect(true);
       return p;
       
    }
    
   
    
    
    public list<pepCmsSection__c> generateSectionStory(String strPageName)
    {
        
        
        
        list<pepCmsPage__c>lstPages = pageNameToCmsPages.get(strPageName);
        List<pepCmsSection__c> bannerSectionList = new List<pepCmsSection__c>(); 
        
        if(lstPages.size() > 0 && lstPages[0].pepSection__r != null && lstPages[0].pepSection__r.size() > 0)
        {
        //Assigning the Section with unique name as 'Loan' to make the banner text.
         for(pepCmsSection__c section:lstPages[0].pepSection__r){
             if(section.pepSectionUniqueName__c=='Loan'){
                 bannerSectionList.add(section);
                 break;
             }
         }
          
          lstSS = bannerSectionList; 
          system.debug('lstSS :: '+lstSS );
        }
          
          if(lstSS != null && lstSS.size() > 0)
          {
          String strSS = lstSS[0].pepSectionStoryRich__c;
          String test1 = '';
          system.debug('objAppl'+ objApplication);
          system.debug('strPurposeId'+ strPurposeId);
          
          if(objApplication != null)
          {
              if(objApplication.genesis__Loan_Amount__c != null)
              {
                Decimal dollars;
                Decimal cents;
                dollars = objApplication.genesis__Loan_Amount__c.intValue();
                //cents = objApplication.Requested_Loan_Amount__c- objApplication.Requested_Loan_Amount__c.intValue();
                //cents = cents.setScale(2);          
                test1 = strSS.replace('LoanAmount', dollars.format() );
              }
              system.debug('test1'+ test1);
              if(objApplication.genesis__Interest_Rate__c != null)
              {          
                  test1 = test1.replace('Rate', String.valueOf(objApplication.genesis__Interest_Rate__c.setScale(2)));
              }
              system.debug('test1'+ test1);
              if(objApplication.Debit_Frequency__c!= null && objApplication.Debit_Frequency__c!= 'Bi-Weekly')
              {
                  
                 test1 = test1.replace('Frequency', String.valueOf(objApplication.Debit_Frequency__c).ToLowerCase()); 
                            
              }
               if(objApplication.Debit_Frequency__c != null && objApplication.Debit_Frequency__c == 'Bi-Weekly')
              {
                  
                 test1 = test1.replace('Frequency', 'fortnightly'); 
                            
              }
              
            /*  if(objApplication.Debit_Frequency__c!= null )
              {
                  
                 test1 = test1.replace('Frequency', 'Monthly'); 
                            
              }*/
              system.debug('test1'+ test1);
              if(objApplication.genesis__Term__c != null)
              {
                  test1 = test1.replace('Term', String.valueOf(objApplication.genesis__Term__c/12).substringBefore('.') );
              }
              system.debug('test1'+ test1);
              if(objApplication.Purpose_Name__c != null || ApexPages.currentPage().getcookies().get('clpurpose') != null )
              {              
                  
                  if(objApplication.Purpose_Name__c != null)
                  test1 = test1.replace('Purpose',objApplication.Purpose_Name__c);
                  else if(ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != null && ApexPages.currentPage().getcookies().get('clpurpose').getvalue() != ''){
                  if(MapOfPurposeIdToPurposeName.get(ApexPages.currentPage().getcookies().get('clpurpose').getvalue()) != null)
                  test1=test1.replace('Purpose',MapOfPurposeIdToPurposeName.get(ApexPages.currentPage().getcookies().get('clpurpose').getvalue()));
                  }
              }
              system.debug('test1'+ test1);
              if(objApplication.Debit_Amount__c!= null)    
              {
              
                Decimal dollars;
                Decimal cents;
                dollars = objApplication.Debit_Amount__c.intValue();
                cents = objApplication.Debit_Amount__c - objApplication.Debit_Amount__c.intValue();
                cents = cents.setScale(2);                  
                test1 = test1.replace('MMI', dollars.format() + cents.toPlainString().substring(1));
              }
              system.debug('test1'+ test1);
              
          }
          

          
           pepCmsSection__c objS = new pepCmsSection__c();       
           objS.pepSectionStoryRich__c = test1;
           lstUpdatedSectionStory.add(objS );
                  
                  
              system.debug('objS'+ objS); 
              system.debug('lstUpdatedSectionStory'+ lstUpdatedSectionStory);
              
              
          }
          

      return lstSS;
    }
    public PageReference EditMethod() 
    {
    
            system.debug('objAppication Swati' + objApplication);
            String redircetPageName= pages_config__c.getinstance('peploandetails').Page_Label__c;  
            pagereference objPage = new Pagereference('/'+redircetPageName);
            return objPage;
    }   
    
    public PageReference retrieveApplication()
    {       try{
            isError=false;
            showBlankretrieval=false;
            PageReference p;
            List<genesis__Applications__c> lstRetrieveApp= new List<genesis__Applications__c>();
            if(strRetrieveCode != null && strRetrieveCode != '')
            {
             showBlankretrieval=true;
             strRetrieveCode=strRetrieveCode.trim();
             RetrievalApplicationStatus__c ret=RetrievalApplicationStatus__c.getValues('Retrieval Status');
            string[] strStatus=ret.Retrieval_Status__c.split(',');
            loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
            Date systemDate;
             if(!Test.isrunningtest())
             systemDate = util .getCurrentSystemDate();
             else
             systemDate=System.Today();
            string querySubString;
                System.debug('==%%'+strRetrieveCode+'==='+systemDate);
            String queryString='select id,pepNavigation_Status__c,Serviceability_Status__c from genesis__Applications__c where Ret_Code__c != \'\' and Ret_Code__c != null and Ret_Code__c=:strRetrieveCode  and (genesis__Expected_Close_Date__c=null OR genesis__Expected_Close_Date__c > : systemDate) AND';
            for(String st: strStatus)
            {
                if(querySubString=='' || querySubString==null) querySubString=' genesis__Status__c != '+'\''+st+'\'';
                else querySubString+= ' AND' + ' genesis__Status__c !='+'\''+st+'\'';
            }
            if(querySubString!='' && querySubString!=null) queryString+=querySubString;
                if(Limits.getQueries()+1 <= Limits.getLimitQueries()){  
                lstRetrieveApp=database.Query(queryString);
                system.debug(lstRetrieveApp+'===%%$$');
                }
                else{
                    PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                    throw new DMLException('This is a SOQL limit exception handling mechanism');
                }
            }
            if(lstRetrieveApp.size()>0)
            {
                String idApplication=lstRetrieveApp[0].id;
                String navigatingStep=lstRetrieveApp[0].pepNavigation_Status__c;
                if(navigatingStep!=null)
                {
                    string redircetPageName=pages_config__c.getinstance(''+pepUtilityClass.navigateToPage(navigatingStep).tolowercase()).Page_Label__c;
                    p=new PageReference('/'+redircetPageName);
                }
                else
                {
                    String redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
                    p=new PageReference('/'+redircetPageName);
                }
                peputilityclass.updateRetrieval(idApplication);
                Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
                cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
                system.debug('cookieApplicationId2--'+cookieApplicationId2 );
                p.setCookies(new Cookie[]{cookieApplicationId2 });
                p.setRedirect(true);
                return p; 
            }
        else{
                system.debug('Inside error condition-2');
                isError=true;
        }
        return null;
        }
        Catch(Exception Ex){
        return null;
        }
    }
    
   
    
    public void resendCode()
    {
        try{
        List<Account> lsAcc = new List<Account>();
        //send retrieval code
        system.debug('--------'+retrieveEmail);
        if((retrieveEmail!=null && retrieveEmail!='') || (retrievePhone!=null && retrievePhone!=''))
        {
                if(inputvalue=='email'){
                if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                lsAcc=[select id,LastName,PersonMobilePhone,PersonContactId,PersonEmail from account where (PersonEmail!=null AND PersonEmail= :retrieveEmail) Limit 1];
                }
                else{
                     PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                     throw new DMLException('This is a SOQL limit exception handling mechanism');
                    }
                }
                if(inputvalue=='mobile'){
                if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                lsAcc=[select id,LastName,PersonMobilePhone,PersonContactId,PersonEmail from account where (PersonMobilePhone !=null AND PersonMobilePhone = :retrievePhone) Limit 1];
                }
                 else{
                 PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                 throw new DMLException('This is a SOQL limit exception handling mechanism');
                 }
               }
                system.debug('email=='+retrieveEmail);
                system.debug('lsAcc=='+lsAcc);
                if(lsAcc!=null && lsAcc.size()>0)
                {   
                    
                    Map<String,String> childObjects = new Map<String,String>();
                    List<genesis__Applications__c> lstApp;
                    try{
                    lstApp=pepInvokeCLMethodHelper.fetchApplications(lsAcc[0].id,null,null,null,childObjects);
                    }
                    catch(Exception ex){
                        isError=true;
                    }
                    system.debug('lstApp=='+lstApp);
                    String retrievalCode;
                    if(lstApp!=null && lstApp.size()>0)
                    {
                        isError=false;
                        for(integer i=0;i<lstApp.size();i++)
                        {
                        if(lstApp[i].genesis__Status__c!='Closed' && lstApp[i].Serviceability_Status__c!='Approved')
                        {
                            objApplicationOld=lstApp[i];
                            retrievalCode= lstApp[i].Ret_Code__c;
                            break;                          
                        }
                        }
                        system.debug('retrievalCode--'+retrievalCode);
                        if(retrievalCode!=null && retrievalCode!='')
                        {
                        //For email
                        if(inputvalue=='email'){
                        if(retrieveEmail!=null && retrieveEmail!='')
                        {
                         try
                        {
                       /* Messaging.SingleEmailMessage emailInstance = new Messaging.SingleEmailMessage();
                        List<string> toAddresses=new List<string>();
                        toAddresses.add(retrieveEmail); 
                        String subject=' Retrieval Code';
                        String body='';
                        // Sets the paramaters of the email
                        list<RetrievalCodeTemplateId__c> tempId=RetrievalCodeTemplateId__c.getall().values();
                        Id TemplateId = Id.valueOf(tempId[0].Name);
                        EmailTemplate objTemplate = [Select id,HtmlValue, body from EmailTemplate where id=: TemplateId ];
                        String htmlBody = objTemplate.HtmlValue;
                        body=htmlBody.replace('{!genesis__Applications__c.Ret_Code__c}',retrievalCode);
                        emailInstance.setTargetObjectId(lsAcc[0].PersonContactId);
                        //emailInstance.setTemplateId(objTemplate.Id);
                        emailInstance.setHTMLBody(body);
                        emailInstance.setSubject( subject );
                        emailInstance.setToAddresses( toAddresses );
                        emailInstance.setPlainTextBody( body );
                    
                        // Sends the email
                        Messaging.SendEmailResult [] r = 
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailInstance});*/
                            peputilityclass.sendEmailRetrievalcode(objApplicationOld);
                        }
                        catch(Exception ex)
                        {
                             isError=true;
                        }
                        }
                        }
                        if(inputvalue=='mobile'){
                        if(retrievePhone!=null && retrievePhone!=''){
                            system.debug('retrievalCode inside--'+retrievalCode);
                                try
                                {
                                    String receipentName = retrievePhone;
                                    String receipentNo = retrievePhone;
                                    String message = ('Your retrieval code is:'+retrievalCode);
                                //passing parameter values to the sms class
                                   String smsResponse = pepSMSmagicSendMessageHandler.sendSMS(receipentName, receipentNo, message);
                                // smsResponse contains value returned by the sms class
                                System.debug('Response for retrievePhone'+smsResponse);
                                }
                                 catch(Exception ex)
                                {
                                     isError=true;
                                }
                        }
                        }
                        }
                        else
                        {
                            system.debug('Inside error condition-1--');
                            isError=true;
                        }
                    }
                    else{
                    isError=True;
                    }
                }
                else
                {
                    system.debug('Inside error condition-1');
                    isError=true;
                }
                
            
            }
            else
            {
                system.debug('Inside error condition');
                isError=true;
            }
        }
        Catch(Exception Ex){
        }
    }
    
    public class CookieJar{
    
        
        
         public CookieJar(Integer intcurrentpageno)
         {
         system.debug('intcurrentpageno Swati' + intcurrentpageno);
         //system.debug('intcurrentpageno Swati1' + IntCookiePageNo );  
         Integer  IntCookiePageNo;
         
            
    
            if(intcurrentpageno > IntCookiePageNo )
            {
                Cookie PageNo =new Cookie('PageNo','',null,-1,false);
                PageNo = new Cookie('PageNo',String.valueof(intcurrentpageno),null,-1,false);  
                
                ApexPages.currentPage().setCookies(new Cookie[]{PageNo});
                system.debug('cookieApplicationId2--'+ PageNo); 
                system.debug('IntCookiePageNo Swati' + IntCookiePageNo );
            }
                                    
        }
    }
    
    public void getCookieData()
    {
            Cookie cookiePageNo = ApexPages.currentPage().getCookies().get('PageNo');
            system.debug('IntCookiePageNo Swati678' + cookiePageNo );
            
            if(cookiePageNo == null)
            {
                IntCookiePageNo = 0;
            }
            
            if(cookiePageNo  != null )
            {
                String strCookiePageNo = cookiePageNo.getValue();
                IntCookiePageNo = Integer.valueOf(strCookiePageNo );
                system.debug('IntCookiePageNo Swati345' + IntCookiePageNo );
            }
    }
     public PageReference configure(){
      return  null;   
   }
    
}