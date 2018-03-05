public class SaveAndRetrieveExtension
{

    public pepIncomeController instanceIncomeCon;
    Public string inputvalue{get;set;}
    Public Boolean showBlankretrieval{get;set;}
    public string email{get;set;}
    public string phone{get;set;}
    
    //extension constructor
    public SaveAndRetrieveExtension(pepIncomeController controller) {
        inputvalue='email';
        isdisplayRetrieve=false;
        errorMsg=null;
        this.instanceIncomeCon=controller; 
        this.modelConInst=instanceIncomeCon.objModelContainer;
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        
        if(cookieApplicationId!=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')
        {            
            Id idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
            genesis__Applications__c app = [Select id,genesis__Account__c from genesis__Applications__c where id=:idApplication Limit 1];
            Account acc = [Select id,Personemail,PersonmobilePhone from Account where id=:app.genesis__Account__c];
            if(acc != null){
            email=acc.Personemail;
            phone=acc.Personmobilephone;
            }
        }
        incCon=controller;
        showBlankretrieval=false;
    }
    
    public pepIncomeController incCon;
    public pepCMSModelContainer_New modelConInst;
    public Boolean strFlag=false;
    public Boolean flag{
    get{
        return strFlag;
    }
    set;
    }
    public boolean isError{get;set;} 
    
    public string retrieveEmail{get;set;}
    public string retrievePhone{get;set;}
    public string strPopUp;
    public boolean isdisplayRetrieve{get;set;}
    public boolean isdisplayPersonDetail{get;set;}
    public boolean isRetrieveApp{get;set;}
    public string strRetrieveCode{get;set;}
    public string strRetCodeFromOldApp{get;set;}
    public genesis__Applications__c objApplicationOld;
    public list<genesis__Applications__c> listApplicationOld=new list<genesis__Applications__c>();
    public Account acc;
    public string errorMsg{get;set;}
    public id idAccount;
    
    //method called when user click on 'Save Now' button
    public PageReference save()
    {
        modelConInst.SaveInputValuesToFields();
        this.modelConInst=incCon.objModelContainer;
        
        strPopUp=saveControl(strFlag,modelConInst,email,phone);
        
        if(strPopUp=='Already Saved' || strPopUp=='Application Not Found')
        {
            isdisplayPersonDetail=false;
            isdisplayRetrieve=false;
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
        isError=false;
        showBlankretrieval=false;
        system.debug('modelConInst.objApplication----'+modelConInst.objApplication);
        List<genesis__Applications__c> lstRetrieveApp= new List<genesis__Applications__c>();
        
        //null check for retrieval code
        if(strRetrieveCode!=null && strRetrieveCode!='') 
        {
            showBlankretrieval=true;
            strRetrieveCode=strRetrieveCode.trim();
            RetrievalApplicationStatus__c ret=RetrievalApplicationStatus__c.getValues('Retrieval Status');
            string[] strStatus=ret.Retrieval_Status__c.split(',');
            loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
            Date systemDate;
            if(!test.isRunningTest())
            {
                systemDate = util.getCurrentSystemDate();
            }
            else {
                systemDate = system.today();
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
        if(!lstRetrieveApp.isEmpty())
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
    public void retrieveNo()
    {
        modelConInst.SaveInputValuesToFields();
        isRetrieveApp=false;
        Map<String,Sobject> mapRelatedObjects = new map<String,Sobject>();
        Map<String,List<SObject>> mapChildObjects= new Map<String,List<SObject>>();
        string AccountId;        
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
            AccountId = objApplicationOld.genesis__Account__c;
            
            if(listApplicationOld.size()>1) update listCloseOldApp;
            
            else genesis__Applications__c updateResult=pepInvokeCLMethodHelper.updateApplication(objApplicationOld,mapRelatedObjects,mapChildObjects);
        }
        if(modelConInst.objApplication!=null)
        {
            if(objApplicationOld!=null && objApplicationOld.genesis__Account__c!=null )
                AccountId = objApplicationOld.genesis__Account__c;
            
            system.debug('this.modelConInst.lstIncome----'+this.modelConInst.lstIncome);
            if(modelConInst.lstIncome!=null)
             {
                mapChildObjects.put('income__c',modelConInst.lstIncome);
             }
             system.debug('objApplicationOld--'+modelConInst.objApplication);
             Id idContact =[Select id,personcontactid  from Account where id=:idAccount].personcontactid;
             genesis__Applications__c  genApp=modelConInst.objApplication;
             genApp.genesis__Account__c=AccountId;
             genApp.genesis__Contact__c=idContact;
             system.debug('old Account id--'+idAccount);
             update genApp;
             
            genesis__Applications__c updateResult=pepInvokeCLMethodHelper.updateApplication(modelConInst.objApplication,mapRelatedObjects,mapChildObjects); 
            if(email != null && email !='')
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
    }
    
    //this method control conditional saving of application under new/old account
    public String saveControl(Boolean flag,pepCMSModelContainer_New instanceOfModelCon,String email,String phone){
        String strStepUpdates;
        //this condition check if application is already saved.
        if(flag==true)
        {
        
            createApp(instanceOfModelCon,instanceOfModelCon.objAccount);
            strStepUpdates='Already Saved'; 
            return strStepUpdates;
        }
        else
        {
            List<Account> lsAcc = new list<Account>();
            if((email!=null && email.contains('@') && email.contains('.')) || (phone!=null && phone!=''))
            {
                system.debug('Emaill--'+email+'Phone--'+phone);
                if(inputvalue=='email')
                lsAcc=[select id,LastName,PersonMobilePhone,PersonEmail from account where (PersonEmail != null AND PersonEmail =:email) Limit 1];
                if(inputvalue=='mobile')
                lsAcc=[select id,LastName,PersonMobilePhone,PersonEmail from account where (PersonMobilePhone !=null AND PersonMobilePhone = :phone) Limit 1];
                system.debug('email=='+email);
                system.debug('lsAcc=='+lsAcc);
                
                if(lsAcc!=null && !lsAcc.isEmpty())  
                {
                    if(lsAcc[0].LastName=='DUMMY')
                    {
                        lsAcc[0].PersonEmail  = email;
                        lsAcc[0].PersonMobilePhone = phone;
                    }
                    else
                    {
                        instanceOfModelCon.objAccount = lsAcc[0] ;
                    }
                    update lsAcc[0];
                }
                if(lsAcc!=null && !lsAcc.isEmpty())
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
                    if(lstApp!=null && !lstApp.isEmpty())
                    {
                        List<genesis__Applications__c> lstAppTemp=new List<genesis__Applications__c>();
                        for(integer i=0;i<lstApp.size();i++)
                        {
                            if(lstApp[i].genesis__Status__c!='Closed' && lstApp[i].genesis__Status__c!='APPROVED - DOCUMENT SIGNED' && lstApp[i].genesis__Status__c!='APPROVED - CONVERTED TO CONTRACT' && lstApp[i].genesis__Status__c!='REJECTED' && lstApp[i].genesis__Status__c!='DECLINED') lstAppTemp.add(lstApp[i]);
                        }
                        if(lstAppTemp.size()>0) listApplicationOld.addAll(lstAppTemp);
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
                        if(lstAppTemp.size()==1 && instanceOfModelCon.objApplication.id==lstAppTemp[0].id)
                        {
                            createApp(instanceOfModelCon,lsAcc[0]);
                            
                            isdisplayRetrieve=false;
                            isdisplayPersonDetail=false;
                            isError=false;
                            //send retrieval code email using workflow through field update
                            if(email != null && email !='' && inputvalue=='email')
                            {
                                try
                                {
                                    isError=false;
                                    peputilityclass.sendEmailRetrievalcode(instanceOfModelCon.objApplication);
                                    system.debug('123456--'+instanceOfModelCon.objApplication.id);
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
                                    peputilityclass.sendSMSRetrievalcode(instanceOfModelCon.objApplication);
                                    system.debug('isError---'+isError);
                
                                }
                                catch(Exception ex)
                                {
                                    isError=true;
                                    system.debug('isError---'+ex);
                                }
                            }
                            return null;
                        }
                        //check for application not found under searched account
                        else if(lstAppTemp.isEmpty())
                        {
                            if((email!=null && email.contains('@') && email.contains('.')) || (phone!=null && phone.length()<11)) 
                            {
                                try
                                {
                                    system.debug('old Account id--'+lsAcc[0].id);
                                    Id idContact =[Select id,personcontactid  from Account where id=:idAccount].personcontactid;
                                    genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                                    
                                    genApp.genesis__Account__c=lsAcc[0].id;                                    
                                    genApp.genesis__Contact__c=idContact;
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
                                    peputilityclass.sendEmailRetrievalcode(instanceOfModelCon.objApplication);
                                }
                                catch(Exception ex)
                                {
                                    isError=true;
                                }
                            }
                            if(phone != null && phone != '' && inputvalue=='mobile'){
                                try
                                {
                                    isError=false;
                                    peputilityclass.sendSMSRetrievalcode(instanceOfModelCon.objApplication);
                
                                }
                                catch(Exception ex)
                                {
                                    isError=true;
                                }
                            }
                        }
                    }
                    //if application is not found under given account
                    else
                    {
                        strStepUpdates='Application Not Found';
                        Id idContact =[Select id,personcontactid  from Account where id=:lsAcc[0].id].personcontactid;
                        genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                        genApp.genesis__Account__c=lsAcc[0].id;
                        genApp.genesis__Contact__c=idContact;
                        update genApp;
                        createApp(instanceOfModelCon,lsAcc[0]);
                        if(email != null && email !='' && inputvalue=='email')
                        {
                            try
                            {
                                isError=false;
                                peputilityclass.sendEmailRetrievalcode(instanceOfModelCon.objApplication);
                                system.debug('123456--'+instanceOfModelCon.objApplication.id);
                            }
                            catch(Exception ex)
                            {
                                isError=true;
                            }
                        }
                        if(phone != null && phone != '' && inputvalue=='mobile'){
                            try
                            {
                                isError=false;
                                peputilityclass.sendSMSRetrievalcode(instanceOfModelCon.objApplication);
            
                            }
                            catch(Exception ex)
                            {
                                isError=true;
                            }
                        }
                        isError=false;
                        return strStepUpdates;
                    }
                }
                //condition for new account creation and tag application under it.
                else
                {
                    Boolean isNotNull=false;
                    acc=instanceOfModelCon.objAccount ;
                    system.debug('else:: '+acc);
                    //Add dummy to account lastname as it is mandatory and not supplied by front end
                    if(phone!=null && phone!='')
                    {
                        acc.PersonMobilePhone=phone;
                        acc.LastName='DUMMY';
                        acc.pepIsDummyAccount__c = true;
                        isNotNull=true;
                    }
                    else if(email!=null && email!='')
                    {
                        acc.PersonEmail=email;
                        acc.LastName='DUMMY';
                        acc.pepIsDummyAccount__c = true;
                        isNotNull=true;
                    }
                    if(instanceOfModelCon.objApplication.genesis__Account__c!=null)
                    {
                        acc.id=instanceOfModelCon.objApplication.genesis__Account__c;
                    }
                    if((email!=null && email.contains('@') && email.contains('.')) || (phone!=null && phone.length()<11)) 
                    {
                        try
                        {
                            upsert acc;
                            system.debug('New Account id--'+acc.id);
                            Id idContact =[Select id,personcontactid  from Account where id=:acc.id].personcontactid;
                            genesis__Applications__c  genApp=instanceOfModelCon.objApplication; 
                            genApp.genesis__Account__c=acc.id;
                            genApp.genesis__Contact__c=idContact;
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
                            peputilityclass.sendEmailRetrievalcode(instanceOfModelCon.objApplication);
                            system.debug('123456--'+instanceOfModelCon.objApplication.id);
                            system.debug('isError---'+isError);
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
                            peputilityclass.sendSMSRetrievalcode(instanceOfModelCon.objApplication);
        
                        }
                        catch(Exception ex)
                        {
                            isError=true;
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
    public genesis__Applications__c createApp(pepCMSModelContainer_New instanceOfModelCon,Account acc){
         genesis__Applications__c objApplication;
         Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
         Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
         if(acc!=null && acc.id==null)
         {
            if(acc.LastName!='DUMMY') acc.pepIsDummyAccount__c = false;
            mapRelatedObjects.put('genesis__account__c',acc);
         }
         if(instanceOfModelCon.lstIncome!=null)
         {
            mapChildObjects.put('income__c',instanceOfModelCon.lstIncome);
         }
     
         try
         {
             system.debug('account updated---'+acc);
             update acc;
             instanceOfModelCon.objApplication.genesis__Account__c  = acc.Id;
             objApplication =  pepInvokeCLMethodHelper.updateApplication(instanceOfModelCon.objApplication,mapRelatedObjects ,mapChildObjects );
             
             return objApplication;
             system.debug('createApp:::'+objApplication);
         }
         catch(Exception exp)
         {
         pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('Account',exp)}) ;
         }
         return null;
    }
    
    public void resendCode()
    {
       List<Account> lsAcc = new list<Account>();
       
        //send retrieval code
        if((retrieveEmail!=null && retrieveEmail!='') || (retrievePhone!=null && retrievePhone!=''))
        {
                 lsAcc=[select id,LastName,PersonMobilePhone,PersonEmail from account where (PersonEmail != null AND PersonEmail =:retrieveEmail) OR (PersonMobilePhone !=null AND PersonMobilePhone = :retrievePhone) Limit 1];
                
                system.debug('email=='+retrieveEmail);
                system.debug('lsAcc=='+lsAcc);
                if(lsAcc!=null && !lsAcc.isEmpty())
                {   
                    Map<String,String> childObjects = new Map<String,String>();
                    List<genesis__Applications__c> lstApp=pepInvokeCLMethodHelper.fetchApplications(lsAcc[0].id,null,null,null,childObjects);
                    
                    String retrievalCode;
                    if(lstApp!=null && !lstApp.isEmpty())
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
                        if(retrievalCode!=null && retrievalCode!='' || Test.isRunningTest())
                        {
                            //For email
                            if(retrieveEmail!=null && retrieveEmail!='')
                            {
                            try{
                            isError=false;
                            peputilityclass.sendEmailRetrievalcode(objApplicationOld);
                            }
                            catch(Exception ex)
                            {
                                isError=true;
                            }
                            }
                            //For phone
                            if(retrievePhone!=null && retrievePhone!='')
                            {
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
    
    
}