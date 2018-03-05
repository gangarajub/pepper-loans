public class pepExpenseSaveAndRetrieveExt
{

    public pepExpenseController pepEx;
    public String inputValue{get;set;}
    Public Boolean showBlankretrieval{get;set;}
    
    //extension constructor
    public pepExpenseSaveAndRetrieveExt(pepExpenseController controller) {
        
        isdisplayRetrieve=false;
        errorMsg=null;
        this.pepEx=controller;
        showBlankretrieval=false;
        modelConInst=new expenseContainer();
        modelConInst.objApplication=pepEx.objApplication;
        list<Account> acc=[select personEmail,PersonMobilephone from Account where id= :modelConInst.objApplication.genesis__Account__c limit 1];
        if(acc.size()>0) {email=acc[0].personEmail;
        phone=acc[0].personmobilephone;
        }                
        incCon=controller;
    }     
    public String idApplication;
    public pepExpenseController incCon;
    public expenseContainer modelConInst;
    public Boolean strFlag=false;
    public Boolean flag{
    get{
        return strFlag;
    }
    set;
    }
    public boolean isError{get;set;} 
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
    public id idAccount;    
    public list<genesis__Applications__c> listApplicationOld=new list<genesis__Applications__c>();
    
    //method called when user click on 'Save Now' button
    public PageReference save()
    {
        modelConInst=new expenseContainer();
        pepEx.createExpenseList();      
        modelConInst.objApplication=pepEx.objApplication;
        modelConInst.lstExpense=pepEx.lstSObjectForSave;
        PageReference p;
         
        system.debug('email--'+email);
        system.debug('phone--'+phone);
        
        strPopUp=saveControl(strFlag,modelConInst,email,phone);
        
        //isdisplayRetrieve=false;
        isdisplayPersonDetail=true;
       
        
        if(strPopUp=='Already Saved' || strPopUp=='Application Not Found')
        {
            isdisplayPersonDetail=false;
            isdisplayRetrieve=false;
            if(!isError)
            {
                string redircetPageName=pages_config__c.getinstance('pepexpensepage').Page_Label__c;
                p=new PageReference('/'+redircetPageName);
                Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
                cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idapplication)),null,-1,false);
                system.debug('cookieApplicationId2--'+cookieApplicationId2 );
                p.setCookies(new Cookie[]{cookieApplicationId2 });
                p.setRedirect(true);
                return p;
            }
        }
        else if(strPopUp=='Application Found')
        {   
            isdisplayPersonDetail=false;
            system.debug('isdisplayRetrieve==='+isdisplayRetrieve);
            isdisplayRetrieve=true;
        }
        else if(strPopUp=='Account Not Found')
        {
            isdisplayRetrieve=false;
            isdisplayPersonDetail=false;
            if(!isError)
            {
                string redircetPageName=pages_config__c.getinstance('pepexpensepage').Page_Label__c;
                p=new PageReference('/'+redircetPageName);
                Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
                cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
                system.debug('cookieApplicationId2--'+cookieApplicationId2 );
                p.setCookies(new Cookie[]{cookieApplicationId2 });
                p.setRedirect(true);
                return p;
            }
        }
        system.debug('strPopUp==='+strPopUp);
        system.debug('isdisplayRetrieve==='+isdisplayRetrieve);
        return null;
    }
    //Called when user don't want to override old application
    public void retrieveYes()
    {
        isRetrieveApp=true;
        system.debug('inside retireve Yes--');
    }
    
    //retrieved old application.
    public PageReference retrieveApplication()
    {
            PageReference p;
            showBlankretrieval=false;
            isError=false;
            system.debug('modelConInst.objApplication----'+modelConInst.objApplication);
            List<genesis__Applications__c> lstRetrieveApp= new List<genesis__Applications__c>();
            if(strRetrieveCode!=null && strRetrieveCode!='') 
            {
                showBlankretrieval=true;
                strRetrieveCode=strRetrieveCode.trim();
                RetrievalApplicationStatus__c ret=RetrievalApplicationStatus__c.getValues('Retrieval Status');
            string[] strStatus=ret.Retrieval_Status__c.split(',');
            loan.GlobalLoanUtilFacade util;
            Date systemDate;
            if(!test.isRunningTest())
            {
            
                util = new loan.GlobalLoanUtilFacade();
                systemDate = util .getCurrentSystemDate();
            }
            string querySubString;
            String queryString='select id,pepNavigation_Status__c,Serviceability_Status__c from genesis__Applications__c where Ret_Code__c != \'\' and Ret_Code__c != null and Ret_Code__c=:strRetrieveCode  and (genesis__Expected_Close_Date__c=null OR genesis__Expected_Close_Date__c > : systemDate) AND';
            for(String st: strStatus)
            {
                if(querySubString=='' || querySubString==null) querySubString=' genesis__Status__c != '+'\''+st+'\'';
                else querySubString+= ' AND' + ' genesis__Status__c !='+'\''+st+'\'';
            }
            if(querySubString!='' && querySubString!=null) queryString+=querySubString;
            lstRetrieveApp=database.Query(queryString);
            }
            if(lstRetrieveApp.size()>0)
            {
                idApplication=lstRetrieveApp[0].id;
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
    //method called when user want to override new application with new one.
    public pageReference retrieveNo()
    {
        PageReference p;
        pepEx.createExpenseList();      
        modelConInst.objApplication=pepEx.objApplication;
        modelConInst.lstExpense=pepEx.lstSObjectForSave;
        isRetrieveApp=false;
        Map<String,Sobject> mapRelatedObjects = new map<String,Sobject>();
        Map<String,List<SObject>> mapChildObjects= new Map<String,List<SObject>>();
        List<genesis__Applications__c> listCloseOldApp=new List<genesis__Applications__c>();
        set<Id> setOldApp=new set<Id>();
        if(objApplicationOld!=null && modelConInst.objApplication.id!=objApplicationOld.id)
        {
            for(genesis__Applications__c gapp: listApplicationOld)
            {
                gapp.genesis__Status__c='Closed';
                gapp.Application_Overriden__c=true;
                if(!setOldApp.contains(gapp.id) || setOldApp.size()==0)
                { 
                    setOldApp.add(gapp.id);
                    listCloseOldApp.add(gapp);
                }
            }
            idAccount= objApplicationOld.genesis__Account__c;
            system.debug('objApplicationOld--'+listCloseOldApp);
            if(listApplicationOld.size()>1) update listCloseOldApp;
            else genesis__Applications__c updateResult=pepInvokeCLMethodHelper.updateApplication(objApplicationOld,mapRelatedObjects,mapChildObjects);
        }
        if(modelConInst.objApplication!=null)
        {
            
            if(modelConInst.lstExpense!=null)
            {
                mapChildObjects.put('expense_and_debt__c',modelConInst.lstExpense);
            }
             system.debug('objApplicationOld--'+modelConInst.objApplication);
             Id idContact =[Select id,personcontactid  from Account where id=:idAccount].personcontactid;
             genesis__Applications__c  genApp=modelConInst.objApplication;
             genApp.genesis__Account__c=idAccount;
             genApp.genesis__Contact__c=idContact;
             update genApp;
             idApplication=modelConInst.objApplication.id;
             genesis__Applications__c updateResult=pepInvokeCLMethodHelper.updateApplication(modelConInst.objApplication,mapRelatedObjects,mapChildObjects);
             if(email != null && email !='')
             {
                 try
                 {
                     isError=false;
                     peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                     system.debug('123456--'+modelConInst.objApplication.id);
                     system.debug('isError---'+isError);
                 }
                 catch(Exception ex)
                 {
                     isError=true;
                     system.debug('isError---'+ex);
                 }
             }
             else if(phone != null && phone != ''){
                 try
                 {
                     isError=false;
                     peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);
                     system.debug('isError---'+isError);

                 }
                 catch(Exception ex)
                 {
                     isError=true;
                     system.debug('isError---'+ex);
                 }
            }      
        }
        
        //refresh page once application is updated
        string redircetPageName=pages_config__c.getinstance('pepexpensepage').Page_Label__c;
        p=new PageReference('/'+redircetPageName);
        Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
        cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
        system.debug('cookieApplicationId2--'+cookieApplicationId2 );
        p.setCookies(new Cookie[]{cookieApplicationId2 });
        p.setRedirect(true);
        return p;
    }
    //this method control conditional saving of application under new/old account
    public String saveControl(Boolean flag,expenseContainer instanceOfModelCon,String email,String phone){
        String strStepUpdates;
        //this condition check if application is already saved.
        if(flag==true)
        {
            createApp(instanceOfModelCon,null);
            strStepUpdates='Already Saved';
            return strStepUpdates;
        }
        else
        {
            List<Account> lsAcc = new List<Account>();
            if((email !=null && email.contains('@') && email.contains('.')) || (phone !=null && phone !=''))
            {
                if(inputvalue=='email')
                lsAcc=[select id,LastName,PersonMobilePhone,PersonEmail from account where (PersonEmail != null AND PersonEmail =:email) Limit 1];
                if(inputvalue=='mobile')
                lsAcc=[select id,LastName,PersonMobilePhone,PersonEmail from account where (PersonMobilePhone !=null AND PersonMobilePhone = :phone) Limit 1];
                system.debug('email=='+email);
                system.debug('lsAcc=='+lsAcc);
                
                if(lsAcc!=null && lsAcc.size()>0)
                {   
                    idAccount=lsAcc[0].id;
                    Map<String,String> childObjects = new Map<String,String>();
                    List<genesis__Applications__c> lstApp;
                    try{
                        //check for application under searched account.
                        lstApp=pepInvokeCLMethodHelper.fetchApplications(lsAcc[0].id,null,null,null,childObjects);
                    
                    }
                    catch(Exception ex)
                    {
                        isError=true;
                    }
                    //check for old applications
                    if(lstApp!=null && lstApp.size()>0)
                    {
                        List<genesis__Applications__c> lstAppTemp=new List<genesis__Applications__c>();
                        for(integer i=0;i<lstApp.size();i++)
                        {
                            System.debug('Status*******************'+lstApp[i].genesis__Status__c);
                            if(lstApp[i].genesis__Status__c!='Closed' && lstApp[i].genesis__Status__c!='APPROVED - DOCUMENT SIGNED' && lstApp[i].genesis__Status__c!='APPROVED - CONVERTED TO CONTRACT' && lstApp[i].genesis__Status__c!='REJECTED' && lstApp[i].genesis__Status__c!='DECLINED') lstAppTemp.add(lstApp[i]);
                        }
                        listApplicationOld.addAll(lstAppTemp);
                        for(integer i=0;i<lstAppTemp.size();i++)
                        {
                            //find old application for closing or retrieving in next steps of save for later
                            if(this.modelConInst.objApplication.id!=lstAppTemp[i].id)
                            {
                                objApplicationOld=lstAppTemp[i];
                                strRetCodeFromOldApp= lstAppTemp[i].Ret_Code__c;
                                strStepUpdates='Application Found';
                                isError=false;
                                return strStepUpdates;             
                            }
                        }
                        //condition to check if queried application is same as lastest one
                        if(lstAppTemp.size()==1 && this.modelConInst.objApplication.id==lstAppTemp[0].id)
                        {
                            createApp(this.modelConInst,null);
                            isdisplayRetrieve=false;
                            isdisplayPersonDetail=false;
                            isError=false;
                            idApplication=this.modelConInst.objApplication.id;
                            
                            //send retrieval code email using workflow through field update
                            if(email != null && email !='' && inputvalue=='email')
                             {
                                 try
                                 {
                                     isError=false;
                                     peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                                     system.debug('123456--'+modelConInst.objApplication.id);
                                 }
                                 catch(Exception ex)
                                 {
                                     isError=true;
                                     system.debug('isError---'+ex);
                                 }
                             }
                             //send retireval code through SMS
                             if(phone != null && phone != '' && inputvalue=='mobile'){
                                 try
                                 {
                                     isError=false;
                                     peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);
                                     system.debug('isError---'+isError);

                                 }
                                 catch(Exception ex)
                                 {
                                     isError=true;
                                     system.debug('isError---'+ex);
                                 }
                            }      
                            return 'Application Not Found';
                        }
                        //check for application not found under searched account
                        else if(lstAppTemp.size()==0)
                        {
                            if((email!=null && email.contains('@') && email.contains('.')) || (phone!=null && phone.length()<11)) 
                            {
                                try
                                {
                                    system.debug('old Account id--'+lsAcc[0].id);
                                    Id idContact =[Select id,personcontactid  from Account where id=:lsAcc[0].id].personcontactid;
                                    genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                                    genApp.genesis__Account__c=lsAcc[0].id;
                                    genApp.genesis__Contact__c=idContact;
                                    
                                    idApplication=genApp.id;
                                    update genApp; 
                                    createApp(instanceOfModelCon,lsAcc[0]);
                                }
                                catch(Exception ex)
                                {
                                    isError=true;
                                }
                            }
                            else
                            {
                                system.debug('Inside error condition-save control');
                                isError=true;
                            }
                            //send retrieval code for email
                             if(email != null && email !='' && inputvalue=='email')
                             {
                                 try
                                 {
                                     isError=false;
                                     peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                                     system.debug('123456--'+modelConInst.objApplication.id);
                                 }
                                 catch(Exception ex)
                                 {
                                     isError=true;
                                     system.debug('isError---'+ex);
                                 }
                             }
                             //send retrieval code through SMS
                             if(phone != null && phone != '' && inputvalue=='mobile'){
                                 try
                                 {
                                     isError=false;
                                     peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);
                                     system.debug('isError---'+isError);

                                 }
                                 catch(Exception ex)
                                 {
                                     isError=true;
                                     system.debug('isError---'+ex);
                                 }
                            }      
                            return 'Application Not Found';
                        }
                    }
                    //if application is not found under given account
                    else
                    {
                        strStepUpdates='Application Not Found';
                        system.debug('Account id--'+lsAcc[0].id);
                        Id idContact =[Select id,personcontactid  from Account where id=:lsAcc[0].id].personcontactid;
                        genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                        genApp.genesis__Account__c=lsAcc[0].id;
                        genApp.genesis__Contact__c=idContact;
                        idApplication=genApp.id;
                        update genApp; 
                        createApp(instanceOfModelCon,lsAcc[0]);
                        isError=false;
                        
                        idApplication=instanceOfModelCon.objApplication.id;
                         if(email != null && email !='' && inputvalue=='email')
                         {
                             try
                             {
                                 isError=false;
                                 peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                                 system.debug('123456--'+modelConInst.objApplication.id);
                             }
                             catch(Exception ex)
                             {
                                 isError=true;
                                 system.debug('isError---'+ex);
                             }
                         }
                         if(phone != null && phone != '' && inputvalue=='mobile'){
                             try
                             {
                                 isError=false;
                                 peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);
                                 system.debug('isError---'+isError);

                             }
                             catch(Exception ex)
                             {
                                 isError=true;
                                 system.debug('isError---'+ex);
                             }
                        }      
                        return strStepUpdates;
                        
                    }
                }
                //condition for new account creation and tag application under it.
                else
                {
                    Boolean isNotNull=false;
                    acc=new account();
                    
                    //Add dummy to account lastname as it is mandatory and not supplied by front end
                    if(phone !=null && phone !='')
                    {
                        acc.PersonMobilePhone=phone;
                        acc.LastName='DUMMY';
                        acc.pepIsDummyAccount__c = true;
                        isNotNull=true;
                    }
                    if(email !=null && email !='')
                    {
                        acc.PersonEmail=email;
                        acc.LastName='DUMMY';
                        acc.pepIsDummyAccount__c = true;
                        acc.LastName=email;
                        isNotNull=true;
                    }
                    if(instanceOfModelCon.objApplication != null && instanceOfModelCon.objApplication.Id != null)
                    {
                        idApplication = instanceOfModelCon.objApplication.Id;
                    }
                    if(instanceOfModelCon.objApplication.genesis__Account__c!=null)
                    {
                        acc.id=instanceOfModelCon.objApplication.genesis__Account__c;
                    }
                    if((email !=null && email.contains('@') && email.contains('.')) || (phone !=null && phone.length()<11)) 
                    {
                        try
                        {
                            upsert acc;
                            system.debug('New Account id--'+acc.id);
                            Id idContact =[Select id,personcontactid  from Account where id=:acc.id].personcontactid;
                            genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                            genApp.genesis__Contact__c=idContact;
                            genApp.genesis__Account__c=acc.id;
                            idApplication=instanceOfModelCon.objApplication.id;
                            update genApp; 
                            createApp(instanceOfModelCon,acc);
                        }
                        catch(Exception ex)
                        {
                            isError=true;
                        }
                    }
                    else
                    {
                        system.debug('Inside error condition-save control');
                        isError=true;
                    }
                    //send retrieval code for email
                     if(email != null && email !='' && inputvalue=='email')
                     {
                         try
                         {
                             isError=false;
                             peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                             system.debug('123456--'+modelConInst.objApplication.id);
                             system.debug('isError---'+isError);
                         }
                         catch(Exception ex)
                         {
                             isError=true;
                             system.debug('isError---'+ex);
                         }
                     }
                     //send retrieval code through SMS
                     if(phone != null && phone != '' && inputvalue=='mobile'){
                         try
                         {
                             isError=false;
                             peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);
                             system.debug('isError---'+isError);

                         }
                         catch(Exception ex)
                         {
                             isError=true;
                             system.debug('isError---'+ex);
                         }
                    }      
                    
                    strStepUpdates='Account Not Found';
                    return strStepUpdates;
                }
            }
            else
            {
                system.debug('Inside error condition-save control');
                isError=true;
            }
        }
        return null;
    }
    //method update created application and its related objects
    public genesis__Applications__c createApp(expenseContainer instanceOfModelCon,Account acc){
         genesis__Applications__c objApplication;
         Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
         Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
         if(acc!=null && acc.id==null)
         {
            mapRelatedObjects.put('genesis__account__c',acc);
         }
         
         if(instanceOfModelCon.lstExpense!=null)
         {
            mapChildObjects.put('expense_and_debt__c',instanceOfModelCon.lstExpense);
         }
         
         try
         {
             system.debug('account updated---'+acc);
             objApplication =  pepInvokeCLMethodHelper.updateApplication(instanceOfModelCon.objApplication,mapRelatedObjects ,mapChildObjects );
             
             return objApplication;
         }
         catch(Exception exp)
         {
          pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('Application',exp)}) ;  
         }
         return null;
    }
    //method resend retrieval code
    public void resendCode()
    {
        //resend retrieval code
        List<Account> lsAcc = new List<Account>();
        if((retrieveEmail !=null && retrieveEmail !='') || (retrievePhone!=null && retrievePhone!=''))
        {
                lsAcc=[select id,LastName,PersonMobilePhone,personcontactid,PersonEmail from account where (PersonEmail != null AND PersonEmail =:retrieveEmail) OR (PersonMobilePhone !=null AND PersonMobilePhone = :retrievePhone) Limit 1];
                
                if(lsAcc!=null && lsAcc.size()>0)
                {   
                    Map<String,String> childObjects = new Map<String,String>();
                    List<genesis__Applications__c> lstApp=pepInvokeCLMethodHelper.fetchApplications(lsAcc[0].id,null,null,null,childObjects);
                    system.debug('lstApp=='+lstApp);
                    String retrievalCode;
                    if(lstApp!=null && lstApp.size()>0)
                    {
                        for(integer i=0;i<lstApp.size();i++)
                        {
                        if(lstApp[i].genesis__Status__c!='Closed' && this.modelConInst.objApplication.id!=lstApp[i].id)
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
                             if(retrieveEmail != null && retrieveEmail !='')
                             {
                                 try
                                 {
                                     isError=false;
                                     peputilityclass.sendEmailRetrievalcode(objApplicationOld);
                                     system.debug('123456--'+objApplicationOld);
                                 }
                                 catch(Exception ex)
                                 {
                                     isError=true;
                                 }
                             }
                             if(retrievePhone!=null && retrievePhone!=''){
                                 try
                                 {
                                     isError=false;
                                     peputilityclass.sendSMSRetrievalcode(objApplicationOld);

                                 }
                                 catch(Exception ex)
                                 {
                                     isError=true;
                                 }
                            }      
                        }
                        else{
                            system.debug('Inside error condition-1--');
                            isError=true;
                        }
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
    public class expenseContainer
    {
        public List<sobject> lstExpense{get;set;}
        public genesis__Applications__c objApplication{get;set;}
    
    }
    
}