public class pepRetrieveApplication
{
    Public string retrievalError{get;set;}
    Public Boolean showBlankretrieval{get;set;}
    public Boolean strFlag=false;
    Public String inputValue{get;set;}
    public Boolean flag{
    get{
        return strFlag;
    }
    set;
    }
    public string email{get;set;}
    public string phone{get;set;}
    public string retrieveEmail{get;set;}
    public string retrievePhone{get;set;}
    public string strPopUp;
    public boolean isdisplayRetrieve{get;set;}
    public boolean isdisplayPersonDetail{get;set;}
    public boolean isRetrieveApp{get;set;}
    public string strRetrieveCode{get;set;}
    public string strRetCodeFromOldApp{get;set;}
    public genesis__Applications__c objApplicationOld;
    public Account acc;
    public string errorMsg{get;set;}
    public boolean isError{get;set;} 
    Public string page_Name{get;set;}
    Public string Page_Label{get;set;}  
    public void pepRetrieveApplication(){
    showBlankretrieval=false;
    
    }
    public PageReference retrieveApplication()
    {
        page_Name=ApexPages.currentPage().getUrl();
        page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
        PageReference p;
        showBlankretrieval=false;
        isError=false;
        List<genesis__Applications__c> lstRetrieveApp= new List<genesis__Applications__c>();
        if(strRetrieveCode!=null && strRetrieveCode!='') 
        {
            showBlankretrieval=true;
           
            strRetrieveCode=strRetrieveCode.trim();
            RetrievalApplicationStatus__c ret=RetrievalApplicationStatus__c.getValues('Retrieval Status');
            string[] strStatus=ret.Retrieval_Status__c.split(',');
            loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
            Date systemDate = util .getCurrentSystemDate();
            string querySubString;
            String queryString='select id,pepNavigation_Status__c,Serviceability_Status__c from genesis__Applications__c where Ret_Code__c != \'\' and Ret_Code__c != null and Ret_Code__c=:strRetrieveCode  and (genesis__Expected_Close_Date__c=null OR genesis__Expected_Close_Date__c > : systemDate) AND';
            for(String st: strStatus)
            {
                if(querySubString=='' || querySubString==null) querySubString=' genesis__Status__c != '+'\''+st+'\'';
                else querySubString+= ' AND' + ' genesis__Status__c !='+'\''+st+'\'';
            }
            if(querySubString!='' && querySubString!=null) queryString+=querySubString;
            lstRetrieveApp=database.Query(queryString);
            System.debug('====='+lstRetrieveApp);
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
                 string redircetPageName=pages_config__c.getinstance('pepincomepage').Page_Label__c;
                 p=new PageReference('/'+redircetPageName);
            }
            peputilityclass.updateRetrieval(idApplication);
            Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
            
            //added by : Sushant Kumar, purpose : to include apllication source information on creation of new application
            Map<String,SObject> relatedObjects = new Map<String,SObject>();
            Map<String,List<SObject>> childObjects = new Map<String,List<SObject>>();      
            genesis__Applications__c objApplication = pepUtilityClass.fillApplicationSourceInfo(lstRetrieveApp[0]);
            pepInvokeCLMethodHelper.updateApplication(objApplication,relatedObjects ,childObjects);
            //modification ends here -- sushant kumar
            
            
            cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idapplication)),null,-1,false);
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
    
   
    
    public void resendCode()
    {
        //send retrieval code
        System.debug('==========='+inputValue);
        system.debug('--------'+retrieveEmail);
        if((retrieveEmail!=null && retrieveEmail!='') || (retrievePhone!=null && retrievePhone!=''))
        {
           
           List<Account> lsAcc = new list<Account>();
           if(inputvalue=='email')
           lsAcc=[select id,LastName,PersonMobilePhone,PersonContactId,PersonEmail from account where (PersonEmail!=null AND PersonEmail= :retrieveEmail)  Limit 1];
           if(inputvalue=='mobile') 
           lsAcc=[select id,LastName,PersonMobilePhone,PersonContactId,PersonEmail from account where (PersonMobilePhone!=null AND PersonMobilePhone= :retrievePhone)  Limit 1];
           
                system.debug('email=='+retrieveEmail);
                system.debug('lsAcc=='+lsAcc);
                RetrievalApplicationStatus__c ret=RetrievalApplicationStatus__c.getValues('Retrieval Status');
                string[] strStatus=ret.Retrieval_Status__c.split(',');
                loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
                Date systemDate = util .getCurrentSystemDate();
                set<String> setApplicationStatus = new set<String>();
                setApplicationStatus.addAll(strStatus);
                if(lsAcc!=null && lsAcc.size()>0)
                {   
                    
                    Map<String,String> childObjects = new Map<String,String>();
                    
                    List<genesis__Applications__c> lstApp;
                    try{
                    lstApp=pepInvokeCLMethodHelper.fetchApplications(lsAcc[0].id,null,null,null,childObjects);
                    }
                    catch(Exception ex)
                    {
                        System.debug('@@@@@@@@@@@@@@@@@@@@@@');
                        isError=true;
                    }
                    system.debug('lstApp=='+lstApp);
                    String retrievalCode;
                    if(lstApp!=null && lstApp.size()>0)
                    {
                        isError=false;
                        for(integer i=0;i<lstApp.size();i++)
                        {
                        if(!setApplicationStatus.contains(lstApp[i].genesis__Status__c) && (lstApp[i].genesis__Expected_Close_Date__c==null || lstApp[i].genesis__Expected_Close_Date__c >  systemDate ) )
                        {
                            objApplicationOld=lstApp[i];
                            System.debug('objApplication&&&&&&&&&'+objApplicationOld.id);
                            retrievalCode= lstApp[i].Ret_Code__c;
                            break;                          
                        }
                        }
                        system.debug('retrievalCode--'+retrievalCode);
                        if(retrievalCode!=null && retrievalCode!='')
                        {
                            //For email
                            if(inputvalue=='email'){
                            if(retrieveEmail!=null && retrieveEmail!=''){
                            try{
                            /*Messaging.SingleEmailMessage emailInstance = new Messaging.SingleEmailMessage();
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
                           //For phone
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
                                    System.debug('Response for retrievePhone is'+smsResponse);
                                  
                               
                                }
                                 catch(Exception ex)
                                {
                                     System.debug('++++++++++++++++');
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
                    isError=true;
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
}