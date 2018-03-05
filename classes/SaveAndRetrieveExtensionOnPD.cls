public class SaveAndRetrieveExtensionOnPD
{
    public pepPersonalDetailsController instancePDController;
    public pepPersonalDetailsController pdCon;
    public account OldAccountOnPD;    
    public boolean isCallFromContinue{get;set;}
    public String inputValue{get;set;}   
    public String inputValueemail{get;set;} 
    public String inputValuephone{get;set;} 
    Public Boolean showBlankretrieval{get;set;}
    private String  ReturnValue2; 
    private id idContact;
    
    //extension constructor
    public SaveAndRetrieveExtensionOnPD(pepPersonalDetailsController controller) 
    {
       
        inputvalue='email';
        isCallFromContinue=false;
        instancePDController = controller;
        isdisplayRetrieve=false;
        errorMsg=null;
        this.pdCon=controller;
        showBlankretrieval=false; 
        this.modelConInst=instancePDController.objModelContainer;
         list<Account> acc=[select personEmail,PersonMobilephone from Account where id= :modelConInst.objApplication.genesis__Account__c limit 1];
        if(acc.size()>0) {email=acc[0].personEmail;
        phone=acc[0].personmobilephone;
        }
        system.debug('Application::'+ this.modelConInst.objApplication);
        if(ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')!=null)
        {
           ReturnValue2 = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); 
           system.debug('ReturnValueIs'+ReturnValue2);
        } 
        
    }
    
    public pepCMSModelContainer_New modelConInst;
    public Boolean strFlag=false;
    public Boolean flag{
    get{
        return strFlag;
    }
    set;
    }
    public string idApplication;
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
    public list<genesis__Applications__c> listApplicationOld=new list<genesis__Applications__c>();
    public genesis__Applications__c updatedApplicationForContinue;
    public Account acc;
    public string errorMsg{get;set;}
    public id idAccount;
    public genesis__Applications__c result;
    
    //method is called on click on submit application
    public PageReference saveOnContinue()
    {   
        
        isCallFromContinue=true;
        if(pdCon.objModelcontainer.objApplication.id!=null){
        genesis__Applications__c genesisApplication=[Select id,Veda_Check__c,Veda_time_stamp__c from genesis__Applications__c where id=:pdCon.objModelcontainer.objApplication.id Limit 1];
        genesisApplication.Veda_Check__c=True;
        genesisApplication.Veda_time_stamp__c=DateTime.now();
        update genesisApplication;
        }
        
        PageReference p1=save();
        if(!isdisplayRetrieve)
        {
            this.pdCon.isSaveClicked = true;
            
            result=updatedApplicationForContinue;
            this.pdCon.result=result;
            system.debug('Inside saveOnContinue---'+result.Id);
            ServiceabilityCalcCtrl.doCreditCheckAndServiceability(result.id);
        
       }
        return null;
    }
    
    //method is called when user clicked on 'save now' button
    public PageReference save()
    {
        
        
        if(string.isNotBlank(inputValueemail))
          email = inputValueemail;
        if(string.isNotBlank(inputValuephone)) 
           phone = inputValuephone;
        system.debug('emailSaveIs'+email);
        system.debug('phoneSaveIs'+phone);
        this.modelConInst = pdCon.objModelContainer;
        this.modelConInst.retrieveAppChecker=False;
        //below code delete already created residentail and employment records
        list<Residential_Address__c> lstRdDel = [select id from Residential_Address__c where Application__c=:this.pdCon.objModelContainer.objApplication.ID];
        if(lstRdDel !=null && !lstRdDel.isEmpty()) delete lstRdDel ;
        list<genesis__Employment_Information__c> lstEIDel = [select id from genesis__Employment_Information__c where genesis__Application__c=:this.pdCon.objModelContainer.objApplication.ID];
        if(lstEIDel !=null && !lstEIDel.isEmpty()) delete lstEIDel ;
        
        modelConInst.lstEmploymentInformation =  new  list<genesis__employment_information__c>();
        modelConInst.lstResidentialAddress =  new list<residential_address__c>();
        modelConInst.SaveInputValuesToFields();
        
        //grab complete information from component
        this.modelConInst = pdCon.objModelContainer;
        
        if(email==null || email=='') email=this.modelConInst.ObjAccount.PersonEmail;
        if(phone==null || phone=='') phone=this.modelConInst.ObjAccount.PersonMobilePhone;
        system.debug('emailSaveIs'+email);
        system.debug('phoneSaveIs'+phone);
        strPopUp=saveControl(strFlag,modelConInst,email,phone);
        
        isdisplayPersonDetail=true;
       
        
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
        //refresh page
        if(!isdisplayRetrieve && !isCallFromContinue && !iserror) 
        {
            string redircetPageName=pages_config__c.getinstance('peppersonaldetails').Page_Label__c;
            PageReference p=new PageReference('/'+redircetPageName);
            Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
            cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
            system.debug('cookieApplicationId2--'+cookieApplicationId2 );
            p.setCookies(new Cookie[]{cookieApplicationId2 });
            p.setRedirect(true);
            return p;
        }
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
        List<genesis__Applications__c> lstRetrieveApp= new List<genesis__Applications__c>();
        System.debug('amit*****'+strRetrieveCode);
        if(strRetrieveCode!=null && strRetrieveCode!='') 
        {
            showBlankretrieval=true;
            strRetrieveCode=strRetrieveCode.trim();
            RetrievalApplicationStatus__c ret=RetrievalApplicationStatus__c.getValues('Retrieval Status');
            string[] strStatus=ret.Retrieval_Status__c.split(',');
            loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
            Date systemDate;
            if(!Test.isRunningTest()){
                systemDate = util .getCurrentSystemDate();
            }
            else
                systemDate=System.today();
            
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
            peputilityclass.updateretrieval(idApplication);
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
    //this method is called when user get override pop-up while going through submit application
    public PageReference retrieveNoOnContinue()
    {
        isCallFromContinue=true;
        
        retrieveNo();
        system.debug('Inside saveOnContinue---2');
        this.pdCon.isSaveClicked = true;
        
        result=updatedApplicationForContinue;
        this.pdCon.result=result;
        system.debug('Inside saveOnContinue---'+result.Id);
        ServiceabilityCalcCtrl.doCreditCheckAndServiceability(result.id);
        isCallFromContinue=false;
        return null;
    }
    //method called when user want to override new application with new one.
    public PageReference retrieveNo()
    {
        //below code delete already created residentail and employment records
        list<Residential_Address__c> lstRdDel = [select id from Residential_Address__c where Application__c=:this.pdCon.objModelContainer.objApplication.ID];
        if(lstRdDel !=null && !lstRdDel.isEmpty()) delete lstRdDel ;
        list<genesis__Employment_Information__c> lstEIDel = [select id from genesis__Employment_Information__c where genesis__Application__c=:this.pdCon.objModelContainer.objApplication.ID];
        if(lstEIDel !=null && !lstEIDel.isEmpty()) delete lstEIDel ;
        
        modelConInst.lstEmploymentInformation =  new  list<genesis__employment_information__c>();
        modelConInst.lstResidentialAddress =  new list<residential_address__c>();
        modelConInst.SaveInputValuesToFields();
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
            system.debug('objApplicationOld--'+objApplicationOld);
            if(listApplicationOld.size()>1) update listCloseOldApp;
            else genesis__Applications__c updateResult=pepInvokeCLMethodHelper.updateApplication(objApplicationOld,mapRelatedObjects,mapChildObjects);
        }
        if(modelConInst.objApplication!=null)
        {
            
             mapChildObjects.PUT('residential_address__c', modelConInst.lstResidentialAddress);
             mapChildObjects.PUT('genesis__employment_information__c', modelConInst.lstEmploymentInformation);
             
             genesis__Applications__c  genApp=modelConInst.objApplication;
             genApp.genesis__Account__c=idAccount;
             genApp.genesis__Contact__c=idContact;
             system.debug('old Account id--'+idAccount);
             update genApp;
             idApplication=genApp.id;
             
             if(email==null || email=='') email=this.modelConInst.ObjAccount.PersonEmail;
             if(phone==null || phone=='') phone=this.modelConInst.ObjAccount.PersonMobilePhone;
            
             updatedApplicationForContinue=pepInvokeCLMethodHelper.updateApplication(modelConInst.objApplication,mapRelatedObjects,mapChildObjects);
             //send retrieval code for email
             if(email != null && email !='')
             {
                 try
                 {
                     isError=false;
                     peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                 }
                 catch(Exception ex)
                 {
                     isError=true;
                 }
             }
             //send retrieval code through SMS
             else if(phone != null && phone != ''){
                 try
                 {
                     isError=false;
                     peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);

                 }
                 catch(Exception ex)
                 {
                     isError=true;
                 }
            }      
        }
        return null;    
    }
    //this method control conditional saving of application under new/old account    
    public String saveControl(Boolean flag,pepCMSModelContainer_New instanceOfModelCon,String email,String phone){
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
            System.debug('======'+email);
            if((email!=null && email.contains('@') && email.contains('.')) || (phone!=null && phone!=''))
            {
                 if(inputvalue=='email')
                lsAcc=[select id,LastName,PersonMobilePhone,PersonEmail from account where (PersonEmail != null AND PersonEmail =:email) Limit 1];
                if(inputvalue=='mobile')
                lsAcc=[select id,LastName,PersonMobilePhone,PersonEmail from account where (PersonMobilePhone !=null AND PersonMobilePhone = :phone) Limit 1];
                system.debug('email=='+email);
                system.debug('lsAcc=='+lsAcc);
                
                List<Account> lsAcc2;
                if(lsAcc!=null && !lsAcc.isEmpty())
                {
                    Account newAcc=instanceOfModelCon.objAccount;
                    // delete dummy account
                    if(newAcc.Id!=null && (newAcc.LastName=='DUMMY' || newAcc.Name=='DUMMY'))
                    {
                        delete [select id from Account where id=: newAcc.Id];
                    }
                    
                    if(newAcc.PersonMobilePhone=='' || newAcc.PersonMobilePhone==null) newAcc.PersonMobilePhone=phone;
                    if(email != null && email!='') newAcc.PersonEmail=email;
                    if(phone!=null && phone!='') newAcc.PersonMobilePhone=phone;
                    
                    //check five parameters in order to tag application
                    if(newAcc!=null && (newAcc.FirstName!=null && newAcc.FirstName!='') && (newAcc.LastName!=null && newAcc.LastName!='') && (newAcc.PersonBirthDate!=null) && (newAcc.PersonEmail!=null && newAcc.PersonEmail!='') && (newAcc.PersonMobilePhone!=null && newAcc.PersonMobilePhone!='')) 
                    {
                        lsAcc2=[select id,LastName,personcontactid,PersonMobilePhone,Middlename,PersonHomePhone,PersonEmail,PersonOtherPhone from account where FirstName=:newAcc.FirstName.toLowerCase() AND LastName=:newAcc.LastName.toLowerCase() 
                                    and PersonBirthDate=:newAcc.PersonBirthDate and PersonEmail=:newAcc.PersonEmail.toLowerCase() 
                                    and PersonMobilePhone=:newAcc.PersonMobilePhone limit 1];
                    }
                    if(lsAcc2!=null && !lsAcc2.isEmpty())
                    {
                        system.debug('testing inside--lsAcc2'+lsAcc2);
                        OldAccountOnPD=lsAcc2[0];
                        OldAccountOnPD.PersonHomePhone=newAcc.PersonHomePhone;
                        OldAccountOnPD.Middlename=newAcc.MiddleName;
                        if(instanceOfModelCon.objAccount.Relationship_Status__c!=null) OldAccountOnPD.Relationship_Status__c=instanceOfModelCon.objAccount.Relationship_Status__c;
                        if(instanceOfModelCon.objAccount.Number_of_Dependants__c!=null) OldAccountOnPD.Number_of_Dependants__c=instanceOfModelCon.objAccount.Number_of_Dependants__c;
                        if(instanceOfModelCon.objAccount.Gender__c!=null) OldAccountOnPD.Gender__c=instanceOfModelCon.objAccount.Gender__c;
                        update OldAccountOnPD;
                        
                        if(OldAccountOnPD!=null)
                        {
                            idContact=OldAccountOnPD.personcontactid;
                            strStepUpdates=saveControl2(instanceOfModelCon,OldAccountOnPD);                            
                            return strStepUpdates;
                        }
                    }
                    else
                    {
                        
                        Boolean isNotNull=false;
                        acc=new account();
                        acc.recordTypeId = pepUtilityClass.getRecordTypeId('Account','Person Account');
                        if((email!=null && email.contains('@') && email.contains('.')) || (phone!=null && phone.length()<11)) 
                        {
                            try
                            {
                                //conditions in order to initalize lastname, email, phone.
                                if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='') && (instanceOfModelCon.objAccount.PersonEmail!=null && instanceOfModelCon.objAccount.PersonEmail!=''))
                                    instanceOfModelCon.objAccount.LastName=instanceOfModelCon.objAccount.PersonEmail;
                                 if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='') && (instanceOfModelCon.objAccount.PersonMobilePhone!=null && instanceOfModelCon.objAccount.PersonMobilePhone!=''))
                                    instanceOfModelCon.objAccount.LastName=instanceOfModelCon.objAccount.PersonMobilePhone;
                                 if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='')  && email!=null  && email!='')
                                    {
                                        instanceOfModelCon.objAccount.LastName=email;
                                        instanceOfModelCon.objAccount.PersonEmail=email;
                                    }
                                if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='')  && phone!=null  && phone!='')
                                    {
                                        instanceOfModelCon.objAccount.LastName=phone;
                                        instanceOfModelCon.objAccount.PersonMobilePhone=phone;
                                    }
                                acc=instanceOfModelCon.objAccount;
                                upsert acc;
                                system.debug('New Account id--'+acc.id);
                                idContact =[Select id,personcontactid  from Account where id=:acc.id].personcontactid;
                                genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                                genApp.genesis__Account__c=acc.id;
                                genApp.genesis__Contact__c=idContact;
                                genApp.PepMerge_Account__c=true;
                                update genApp;
                                idApplication=genApp.id;
                                updatedApplicationForContinue=createApp(instanceOfModelCon,acc);
                             /*   Task task=new Task();
                                UserIdForTask__c assignedUser=UserIdForTask__c.getValues('UserIdToMergeAccount');
                                system.debug('++'+assignedUser.UserId__c);
                                task.OwnerId=assignedUser.UserId__c;
                                task.Subject = 'Merge Account with same email/phone';
                                task.priority= 'Medium';
                                task.status = 'Not Started';
                                task.WhatId = acc.id;
                                task.description = 'System find duplicate account with same email/phone.Please analyse and merge into one account.';
                                insert task;
                                system.debug('---'+task); */
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
                        if(email != null && email !='' && inputvalue=='email' && isCallFromContinue==false)
                         {
                             try
                             {
                                 isError=false;
                                 peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                             }
                             catch(Exception ex)
                             {
                                 isError=true;
                             }
                         }
                         //send retrieval code through SMS
                         if(phone != null && phone != ''  && inputvalue=='mobile' && isCallFromContinue==false){
                             try
                             {
                                 isError=false;
                                 peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);
            
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
                    Boolean isNotNull=false;
                    acc=new account();
                    acc.recordTypeId = pepUtilityClass.getRecordTypeId('Account','Person Account');
                    if((email!=null && email!='' && email.contains('@') && email.contains('.')) || (phone!=null && phone.length()<11)) 
                    {
                        try
                        {
                            //conditions in order to initalize lastname, email, phone.
                            
                             if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='')  && email!=null  && email!='')
                                {
                                    instanceOfModelCon.objAccount.LastName=email;
                                    instanceOfModelCon.objAccount.PersonEmail=email;
                                }
                            if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='')  && phone!=null  && phone!='')
                                {
                                    instanceOfModelCon.objAccount.LastName=phone;
                                    instanceOfModelCon.objAccount.PersonMobilePhone=phone;
                                }
                                if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='') && (instanceOfModelCon.objAccount.PersonEmail!=null && instanceOfModelCon.objAccount.PersonEmail!=''))
                                instanceOfModelCon.objAccount.LastName=instanceOfModelCon.objAccount.PersonEmail;
                             if((instanceOfModelCon.objAccount.LastName==null || instanceOfModelCon.objAccount.LastName=='') && (instanceOfModelCon.objAccount.PersonMobilePhone!=null && instanceOfModelCon.objAccount.PersonMobilePhone!=''))
                                instanceOfModelCon.objAccount.LastName=instanceOfModelCon.objAccount.PersonMobilePhone;
                            acc=instanceOfModelCon.objAccount;    
                            upsert acc;
                            system.debug('New Account id--'+acc.id);
                            idContact =[Select id,personcontactid  from Account where id=:acc.id].personcontactid;
                            genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                            genApp.genesis__Account__c=acc.id;
                            genApp.genesis__Contact__c=idContact;                            
                            update genApp;
                            idApplication=genApp.id;
                            updatedApplicationForContinue=createApp(instanceOfModelCon,acc);
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
                    if(email != null && email !='' && inputvalue=='email' && isCallFromContinue==false)
                     {
                         try
                         {
                             isError=false;
                             peputilityclass.sendEmailRetrievalcode(modelConInst.objApplication);
                         }
                         catch(Exception ex)
                         {
                             isError=true;
                         }
                     }
                     //send retrieval code through SMS
                     if(phone != null && phone != ''  && inputvalue=='mobile' && isCallFromContinue==false){
                         try
                         {
                             isError=false;
                             peputilityclass.sendSMSRetrievalcode(modelConInst.objApplication);
        
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
    //this method tag application under old account
    public string saveControl2(pepCMSModelContainer_New instanceOfModelCon,Account tempAcc)
    {
        idAccount=tempAcc.id;
        Map<String,String> childObjects = new Map<String,String>();
        List<genesis__Applications__c> lstApp;
        String strStepUpdates;
        try{
        lstApp=pepInvokeCLMethodHelper.fetchApplications(tempAcc.id,null,null,null,childObjects);
        
        }
        catch(Exception ex)
        {
            isError=true;
        }
        system.debug('lstApp=='+lstApp);
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
            if(instanceOfModelCon.objApplication.id!=lstAppTemp[i].id)
            {
                objApplicationOld=lstAppTemp[i];
                strRetCodeFromOldApp= lstAppTemp[i].Ret_Code__c;
                strStepUpdates='Application Found';
                isError=false;
                return strStepUpdates;             
            }
            }
            if(lstAppTemp.size()==1 && instanceOfModelCon.objApplication.id==lstAppTemp[0].id)
            {
                updatedApplicationForContinue=createApp(instanceOfModelCon,tempAcc);
                system.debug('updatedApplicationForContinue--'+updatedApplicationForContinue);
                isdisplayRetrieve=false;
                isdisplayPersonDetail=false;
                isError=false;
                idApplication=instanceOfModelCon.objApplication.id;
                //send retrieval code for email
                if(email != null && email !='' && inputvalue=='email' && isCallFromContinue==false)
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
                 //send retrieval code through SMS
                 if(phone != null && phone != ''  && inputvalue=='mobile' && isCallFromContinue==false){
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
                return null;
            }
            else if(lstAppTemp.isEmpty())
            {
                if((email!=null && email.contains('@') && email.contains('.')) || (phone!=null && phone.length()<11)) 
                {
                    try
                    {
                        system.debug('old Account id--'+tempAcc.id);
                        genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
                        genApp.genesis__Account__c=tempAcc.id;
                        genApp.genesis__Contact__c=idContact;
                        idApplication=instanceOfModelCon.objApplication.id;
                        update genApp; 
                        updatedApplicationForContinue=createApp(instanceOfModelCon,tempAcc);
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
                if(email != null && email !='' && inputvalue=='email' && isCallFromContinue==false)
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
                 //send retrieval code through SMS
                 if(phone != null && phone != ''  && inputvalue=='mobile' && isCallFromContinue==false){
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
            return null;
        }
        else
        {
            strStepUpdates='Application Not Found';
            genesis__Applications__c  genApp=instanceOfModelCon.objApplication;
            genApp.genesis__Account__c=tempAcc.id;
            genApp.genesis__Contact__c=idContact;
            update genApp;          
            updatedApplicationForContinue=createApp(instanceOfModelCon,tempAcc);
            idApplication=instanceOfModelCon.objApplication.id;
            isError=false;
            //send retrieval code for email
            if(email != null && email !='' && inputvalue=='email' && isCallFromContinue==false)
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
             //send retrieval code through SMS
             if(phone != null && phone != ''  && inputvalue=='mobile' && isCallFromContinue==false){
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
            return strStepUpdates;
        }
    }
    public genesis__Applications__c createApp(pepCMSModelContainer_New instanceOfModelCon,Account acc){
         genesis__Applications__c objApplication;
         Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
         Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
         if(ReturnValue2!=null && ReturnValue2!='')
            instanceOfModelCon.objApplication.IP_Address__c = ReturnValue2;
         if(acc!=null && acc.id==null)
         {
            mapRelatedObjects.put('genesis__account__c',acc);
         }          
          
         mapChildObjects.PUT('residential_address__c', instanceOfModelCon.lstResidentialAddress);
         mapChildObjects.PUT('genesis__employment_information__c', instanceOfModelCon.lstEmploymentInformation);
         mapRelatedObjects.PUT('account', instanceOfModelCon.objAccount);
           
         
         try
         {
             objApplication =  pepInvokeCLMethodHelper.updateApplication(instanceOfModelCon.objApplication,mapRelatedObjects ,mapChildObjects );
             
             return objApplication;
         }
         catch(Exception exp)
         {
            pepErrorLog.LogErrors(new pepErrorLog.Error[]{new pepErrorLog.Error('Account',exp)}) ;
         }
         return null;
    }
    
    public void resendCode()
    {
        //send retrieval code
        if((retrieveEmail!=null && retrieveEmail!='') || (retrievePhone!=null && retrievePhone!=''))
        {
            List<Account> lsAcc=[select id,LastName,PersonMobilePhone,PersonContactId,PersonEmail from account where (PersonEmail!=null AND PersonEmail= :retrieveEmail) Limit 1];
                system.debug('email=='+retrieveEmail);
                system.debug('lsAcc=='+lsAcc);
                if(lsAcc!=null && !lsAcc.isEmpty())
                {   
                    Map<String,String> childObjects = new Map<String,String>();
                    List<genesis__Applications__c> lstApp=pepInvokeCLMethodHelper.fetchApplications(lsAcc[0].id,null,null,null,childObjects);
                    system.debug('lstApp=='+lstApp);
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
    
}