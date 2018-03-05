public class pepPersonalDetailsController{

    //private pepCmsModelContainer objModel;
    public pepCMSModelContainer_New objModelContainer{get;set;}
    public pepCmsModelContainer objModel {get; set;}
    Public string pagetoredirect{get;set;}
    public pepCmsModelContainer objModel1 {get; set;}
    public pepCmsModelContainer objModel2 {get; set;}
    public pepCmsModelContainer objModel3 {get; set;}
    public genesis__Applications__c objApplication{get;set;}
    list<genesis__Applications__c> lstApplicationOld;
    public genesis__Applications__c result;
    public list<String> lstEmailAddress;
    public date strDate{get;set;}
    public string strPageName {get; set;}
    list<genesis__Applications__c> lstApplication;
    private static String baseUrl;
    private static String secret;
    public String sitekey{set;get;}
    private String  ReturnValue; 
    public Integer intCurrentPageNumber{get;set;}
    public Integer intPreviousPageNumber{get;set;}
    private Id idApplication;
    public Date systemDate;
    public boolean isSaveClicked{get;set;}//Changes by AMIT K
    /*
    list<OTP_Template__c> LstOTPTemplate;
    Id TemplateId;
    EmailTemplate objTemplate;
    */
    public static Account objAppAccount;
    
    public String response{ 
        get { return ApexPages.currentPage().getParameters().get('g-recaptcha-response'); }
    }
    public String Page_Name{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    
    public pepPersonalDetailsController()
    {
      
     page_Name='peppersonaldetails';//Added by KG
     Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
     //Commented By Varun to reduce the Query call to capture the System Date on June 30,2017.
     /*loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();//Added by Swati*/
     objAppAccount = new Account();
     //Commented By Varun to reduce the Query call to capture the System Date on June 30,2017.
      /*if(Test.isRunningTest()==False){
          systemDate = util.getCurrentSystemDate();//Added by Swati
        }
        else{
            systemDate =System.today();
        }*/
        isSaveClicked = false;
        if(ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')!=null)
        {
           ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); 
           system.debug('ReturnValueIs'+ReturnValue);
        } 
        
        /*Commented By Varun on June 30,2017 to reduce the unnecessary Query.
        LstOTPTemplate = OTP_Template__c.getAll().Values();
        TemplateId = Id.valueOf(LstOTPTemplate[0].Template_Id__c);
        objTemplate = [Select id, body from EmailTemplate where id=: TemplateId ];*/
        lstApplication = new list<genesis__Applications__c>();
        lstApplicationOld = new list<genesis__Applications__c>();
        objModelContainer =  new pepCMSModelContainer_New();
        objModel = new pepCmsModelContainer();
        objModel1 = new pepCmsModelContainer();
        objModel2 =  new pepCmsModelContainer();
        objModel3 = new pepCmsModelContainer();
        objApplication = new genesis__Applications__c();
        
        Captcha_Settings__c objrecaptcha = Captcha_Settings__c.getValues('Google recaptcha');//calling the google recaptcha custom setting
        baseUrl=objrecaptcha.url__c;
        secret=objrecaptcha.secret_Key__c;
        sitekey=objrecaptcha.site_key__c;
        result = new genesis__Applications__c();
        lstEmailAddress = new list<String> ();
        strPageName = 'Personal Details';
        if( ApexPages.currentPage().getParameters().get('redirectFromPageNo') != null 
            &&  ApexPages.currentPage().getParameters().get('redirectFromPageNo') !='')
        {
            intPreviousPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('redirectFromPageNo'));   
        }
        
        
        intCurrentPageNumber =  4;
        getCookieData();
        
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        if(cookieApplicationId != null && cookieApplicationId.getValue()!= null && cookieApplicationId.getValue()!= '')
        {
            idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
           
            system.debug('ApplicationId:: '+ idApplication);
            
            String[] lstTypes = new String[]{'genesis__Applications__c','Residential_Address__c','genesis__Employment_Information__c','Account'};
            String FieldSetName='pepGeneral';
                    
            lstApplication=pepUtilityClass.fetchApplicationAndChild(lstTypes,FieldSetName,null,idApplication,null);
            System.debug('ppppppppppp'+lstApplication[0].Residential_Address__r);
            if(lstApplication!=null && lstApplication.size()>0)
            {
               objModelContainer.objApplication=lstApplication[0];
               lstApplicationOld = lstApplication;
            }
        }
        
             
       
    }
    
    public pepCMSModelContainer_New getpopulateValues(){     
           
            try{
            if(lstApplication!=null && lstApplication.size()>0 )
            {   
                if(lstApplication.get(0).Residential_Address__r!=null && lstApplication.get(0).Residential_Address__r.size()>0)  
                {           
                    //sorting of Residential address
                    Map<Decimal,Residential_Address__c> mapRD = new Map<Decimal,Residential_Address__c>(); 
                    
                    List<Decimal> lstTemp=new List<Decimal>();
                    objModelContainer.lstResidentialAddress =new list<Residential_Address__c>();
                    objModelContainer.lstResidentialAddress.addAll(lstApplication.get(0).Residential_Address__r);                
                }
                
                if(lstApplication.get(0).genesis__Employment_Information__r!=null && lstApplication.get(0).genesis__Employment_Information__r.size()>0)  
                {
                    // Employment details
                    Map<Decimal,genesis__Employment_Information__c> mapEI = new Map<Decimal,genesis__Employment_Information__c>(); 
                    for(genesis__Employment_Information__c inc:lstApplication.get(0).genesis__Employment_Information__r)
                    {
                        mapEI.put(inc.Sequence__c,inc);    
                    }
                    List<Decimal> lstTemp1 =new List<Decimal>();
                    List<genesis__Employment_Information__c> lstEIToDisplay=new List<genesis__Employment_Information__c>();
                    lstTemp1.addAll(mapEI.keyset());
                    lstTemp1.sort();
                    for(Decimal i: lstTemp1)
                    {
                        lstEIToDisplay.add(mapEI.get(i));
                    }
                    
                    
                    objModelContainer.lstEmploymentInformation=new list<genesis__Employment_Information__c>();
                    objModelContainer.lstEmploymentInformation.addAll(lstEIToDisplay);
                }
                
               /* Account objAccount = [Select id,Referred_By_Code__c,PersonEmail,PersonHomePhone,FirstName, MiddleName,PersonMobilePhone,Relationship_Status__c, Phone,PersonOtherPhone ,PersonBirthdate, LastName, Gender__c, Number_of_Dependants__c,
                                            PersonContactId , pepIsDummyAccount__c
                                            from Account 
                                            where id=: lstApplication.get(0).genesis__Account__c 
                                            limit 1]; */
                Account objAccount = fetchAccountDetails(lstApplication.get(0).genesis__Account__c );
                system.debug('Email:: '+objAccount.PersonEmail);
                if(objAccount.pepIsDummyAccount__c== true && objAccount.LastName=='DUMMY')
                    objAccount.LastName = '';
                if(objAccount.Personemail==Objaccount.Lastname)
                    objAccount.Lastname='';
                objModelContainer.objAccount = objAccount ;
                
                objModelContainer.objApplication = lstApplication.get(0);
                
                objModelContainer.strPageName='Personal Details';                 
                system.debug('modelConInst=='+objModelContainer);
                
                
            }
     
        return objModelContainer;
    }
        Catch(Exception ex){
        
        return new pepCMSModelContainer_New();
      }
    }

    //Added by Mitali Telang - Code Optimisation 
    public static Account fetchAccountDetails(String accId)
    {
        if(objAppAccount == Null || objAppAccount.id != accId){
            if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
            objAppAccount = [Select id,Referred_By_Code__c,PersonEmail,PersonHomePhone,FirstName, MiddleName,PersonMobilePhone,Relationship_Status__c, Phone,PersonOtherPhone ,PersonBirthdate, LastName, Gender__c, Number_of_Dependants__c,
                            PersonContactId , pepIsDummyAccount__c
                            from Account 
                            where id=: accId
                            limit 1];
            }
           else{
                  PeputilityClass.sendexceptionemail(Peputilityclass.getCurrrentString());
                  throw new DMLException('This is a SOQL limit exception handling mechanism');
            
            }
        }
        return objAppAccount;
    }
    
    public pagereference SaveValues()
    {
        try{
        genesis__Applications__c updateAppFromUI;
        
        objModel.strPageName='Personal Details';
        objModel.strSectionName='PersonalDetailsSec1';
        objModel.ReadControlValue();
        Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
        Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
        List<SObject> lstSobject=new List<SObject>();
        
        objModel.objAccount.pepIsDummyAccount__c = false;
        update objModel.objAccount;
        update objModel3.objAccount;
        updateAppFromUI=objModel.objApplication;
        
        result=pepInvokeCLMethodHelper.updateApplication(updateAppFromUI,mapRelatedObjects,mapChildObjects);
        system.debug('Result:: '+result);
        
        return null;
        }
        Catch(Exception ex){
        string redircetPageName=pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
        return new Pagereference('/'+redircetPageName);
        }
    }
    
    public Pagereference saveData(){
        try{
        isSaveClicked = true;
        if(ReturnValue!=null && ReturnValue!='')
          objModelContainer.objApplication.IP_Address__c = ReturnValue;
          list<Residential_Address__c> lstRdDel;
          if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
          lstRdDel = [select id,unit_number__c from Residential_Address__c where Application__c=:objModelContainer.objApplication.ID  ];
          }
          else{
              PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
             throw new DMLException('This is a SOQL limit exception handling mechanism');
          }
          if(lstRdDel !=null && lstRdDel.size()>0) delete lstRdDel ;
          list<genesis__Employment_Information__c> lstEIDel;
          if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
          lstEIDel = [select id from genesis__Employment_Information__c where genesis__Application__c=:objModelContainer.objApplication.ID  ];
          }
          else{
               PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
               throw new DMLException('This is a SOQL limit exception handling mechanism');
          }
          if(lstEIDel !=null && lstEIDel.size()>0) delete lstEIDel ;
        
        objModelContainer.lstEmploymentInformation =  new  list<genesis__employment_information__c>();
        objModelContainer.lstResidentialAddress =  new list<residential_address__c>();
        
        objModelContainer.SaveInputValuesToFields();
        system.debug('Application Id:: '+objModelContainer.objApplication);
        System.debug('Bhawna-Address::' + objModelContainer.lstResidentialAddress.size());
        Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
        Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
        
        system.debug('after removing');
        system.debug('RD---::'+ objModelContainer.lstResidentialAddress.size());
        system.debug('EI---::'+ objModelContainer.lstEmploymentInformation.size());
        
        mapChildObjects.PUT('residential_address__c', objModelContainer.lstResidentialAddress);
        mapChildObjects.PUT('genesis__employment_information__c', objModelContainer.lstEmploymentInformation);
        system.debug('objModelContainer.objAccount:: '+objModelContainer.objAccount);
        Account objA =  new Account();
        // check if account already exists
        if((objModelContainer.objAccount.PersonEmail!=null && objModelContainer.objAccount.PersonEmail!='' )||
            objModelContainer.objAccount.PersonMobilePhone != null && objModelContainer.objAccount.PersonMobilePhone!='')
        {
           // list<Account> lstA = fetchExistingAccount(objModelContainer.objAccount.PersonEmail, objModelContainer.objAccount.PersonMobilePhone);
          //  if(lstA !=null && lstA.size()>0)
           //     objModelContainer.objAccount.ID = lstA[0].Id;
        }
        
        objA  = objModelContainer.objAccount;
        objA.pepIsDummyAccount__c = false;
        upsert objA ;
        objModelContainer.objApplication.genesis__Account__c = objA.Id;
        mapRelatedObjects.PUT('account', objModelContainer.objAccount);
        result = pepInvokeCLMethodHelper.updateApplication(objModelContainer.objApplication,mapRelatedObjects,mapChildObjects);
        
        system.debug('result ::'+result );
        ServiceabilityCalcCtrl.doCreditCheckAndServiceability(result.id);
       
        
         return null;
       }
       Catch(Exception e){
       string redircetPageName=pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
       return new Pagereference('/'+redircetPageName);
       }
    }
    
    
    
    
    public pageReference checkVedaStausAndRedirect()
    {
        try{
        Map<string,string> childobjects = new Map<string,string>();
        Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
        Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
        pageReference ref;
        genesis__Applications__c objApp = new genesis__Applications__c() ;
                
        if(idApplication != null)
        {
             List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,idApplication,null,null,childobjects );
             if(lstApplication != null && lstApplication.size() > 0)
             {
                 objApp = lstApplication[0];
            }
        }
        system.debug('statusIs'+objApp.Serviceability_Status__c);
        if(objApp.Serviceability_Status__c == 'Approved' && objApp.genesis__Status__c=='CONDITIONALLY APPROVED' )
        { 
           System.debug('$$$$$$$$$$$'+objApp.genesis__Status__c);
            mapRelatedObjects.PUT('account', objModelContainer.objAccount); 
            if(lstApplicationOld[0].genesis__Interest_Rate__c!=objApp.genesis__Interest_Rate__c && lstApplicationOld[0].genesis__Interest_Rate__c<objApp.genesis__Interest_Rate__c || Test.isrunningTest())
             {
                //objApp.Veda_Check__c = true;
                //objApp.Veda_Time_Stamp__c = dateTime.Now();
                objApp.pepNavigation_Status__c = pepUtilityClass.getNavigationPageName('pepofferscreen');
                pepInvokeCLMethodHelper.updateApplication(objApp,mapRelatedObjects,mapChildObjects);
                string redircetPageName= pages_config__c.getinstance('pepofferscreen').Page_Label__c;
                ref=new Pagereference('/'+redircetPageName); 
                ref.setRedirect(true);
                return ref;
             }
                   
            // Account objAccount = [Select id,PersonEmail,PersonContactId,phone,PersonMobilePhone from Account where id=: result.genesis__Account__c limit 1];
            Account objAccount = fetchAccountDetails(result.genesis__Account__c);
            String PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
            
            system.debug('Account::'+objAccount );
            
            system.debug('PIN::'+PIN + 'Email:: '+objAccount.PersonEmail);
               
                if(objAccount.PersonEmail != null)
                {
                    if(PIN != '')
                    {
                        objAccount.OTP__c = PIN;
                        objAccount.PepOTP__c = PIN;
                        objAccount.Retrieval_Code__c = objApp.Ret_Code__c;
                        update objAccount;
                        system.debug('Account:: '+objAccount);
                        //objApp.Veda_Check__c = true;
                        //objApp.Veda_Time_Stamp__c = dateTime.Now();
                        objApp.pepNavigation_Status__c = pepUtilityClass.getNavigationPageName('pepOTP');
                        pepInvokeCLMethodHelper.updateApplication(objApp,mapRelatedObjects,mapChildObjects);
                        
                    }
                    
                   string redircetPageName= pages_config__c.getinstance('pepotp').Page_Label__c;
                   ref=new Pagereference('/'+redircetPageName); 
                   ref.setRedirect(true);
               }
               
        }      
        
        if(objApp.Serviceability_Status__c == 'Declined' && objApp.genesis__Status__c=='DECLINED' )
        {
           System.debug('$$$$$$$$$$$'+objApp.genesis__Status__c);
           loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
           if(Test.isRunningTest()==False){
          systemDate = util.getCurrentSystemDate();//Added by Swati
        }
        else{
            systemDate =System.today();
        }
           objApp.genesis__Expected_Close_Date__c =systemDate;
           //objApp.Veda_Check__c = true;
           //objApp.Veda_Time_Stamp__c = dateTime.Now();
           pepInvokeCLMethodHelper.updateApplication(objApp,mapRelatedObjects,mapChildObjects);
           string redircetPageName= pages_config__c.getinstance('pepserviceabilitydecline').Page_Label__c;
           ref = new pageReference('/'+redircetPageName);
           ref.setRedirect(true);
        }
        
        if(objApp.Serviceability_Status__c == 'Referred' && objApp.genesis__Status__c=='REFERRED' )
        {
           System.debug('$$$$$$$$$$$'+objApp.genesis__Status__c);
           loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
             if(Test.isRunningTest()==False){
          systemDate = util.getCurrentSystemDate();//Added by Swati
        }
        else{
            systemDate =System.today();
        }
           objApp.genesis__Expected_Close_Date__c =systemDate;
           //objApp.Veda_Check__c = true;
           //objApp.Veda_Time_Stamp__c = dateTime.Now();
           pepInvokeCLMethodHelper.updateApplication(objApp,mapRelatedObjects,mapChildObjects);
           string redircetPageName= pages_config__c.getinstance('pepreferredpage').Page_Label__c;
           ref = new pageReference('/'+redircetPageName);
           ref.setRedirect(true);
        }
        
       
       return ref;
    
    }
  Catch(Exception ex){
  
  string redircetPageName=pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
  return new Pagereference('/'+redircetPageName);
  }  
 }
    public Pagereference saveDataFromExt() {
        isSaveClicked = true;
        if(ReturnValue!=null && ReturnValue!='')
          objModelContainer.objApplication.IP_Address__c = ReturnValue;         
          
        // delete Extra EI
        system.debug('EI-Size::'+objModelContainer.lstEmploymentInformation.size());
        map<integer, genesis__Employment_Information__c> mpEmpIdToEmpRec =  new map<integer, genesis__Employment_Information__c>();
        if(objModelContainer.lstEmploymentInformation !=null && objModelContainer.lstEmploymentInformation.size()>0)
        {
            for(genesis__Employment_Information__c objEmp : objModelContainer.lstEmploymentInformation)
            {
                mpEmpIdToEmpRec.put(integer.valueOf(objEmp.Sequence__c),objEmp);
            }
        }

        set<integer> setRecordsSequence =  new set<integer>();
        if(objModelContainer.lstSection !=null && objModelContainer.lstSection.size()>0)
        {
            for(pepCMSModelContainer_New.wrapSection objSection: objModelContainer.lstSection )
            {
                for(pepCMSModelContainer_New.wrapQuestion objWrapQuestion: objSection.lseQuestions)
                {
                  // fetch Employment records related to sequence
                    if(objWrapQuestion.objCmsQuestion != null )
                    {
                        if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'genesis__Employment_Information__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                        {                             
                            setRecordsSequence.add(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c));
                        }
                    }
                }
            }
        }
        list<genesis__Employment_Information__c> lstEIToDelete =  new list<genesis__Employment_Information__c>();
        if(setRecordsSequence!=null && mpEmpIdToEmpRec!= null)
        {   
            for(Integer i:mpEmpIdToEmpRec.keyset() )
            {
                if(!setRecordsSequence.contains(i))
                {
                    if(mpEmpIdToEmpRec.get(i)!=null && mpEmpIdToEmpRec.get(i).Id!=null)
                    lstEIToDelete.add(mpEmpIdToEmpRec.get(i));
                }
            }
        }
        
       // if(lstEIToDelete!=null && lstEIToDelete.size()>0) delete lstEIToDelete;
        
        // deleteing extra EI ends here  
        
        // delete Extra RD
        map<boolean, Residential_Address__c> mpIsCurrentAddressToRD=  new map<boolean, Residential_Address__c>();
        if(objModelContainer.lstResidentialAddress !=null && objModelContainer.lstResidentialAddress.size()>0)
        {
            for(Residential_Address__c objRD : objModelContainer.lstResidentialAddress)
            {
                mpIsCurrentAddressToRD.put(objRD.Current_Address__c ,objRD);// if objRD.Current_Address__c == true then pick current address else pick second address
            }
        }

        set<integer> setRecordsSequenceRD =  new set<integer>();
        boolean isPrevious = false;
        if(objModelContainer.lstSection !=null && objModelContainer.lstSection.size()>0)
        {
            for(pepCMSModelContainer_New.wrapSection objSection: objModelContainer.lstSection )
            {
                for(pepCMSModelContainer_New.wrapQuestion objWrapQuestion: objSection.lseQuestions)
                {                  
                    if(objWrapQuestion.objCmsQuestion != null )
                    {
                        if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                        {  
                               // if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 1) isCurrent=true; //if current address
                            if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 2) isPrevious =true;// if previous address                         
                           // setRecordsSequenceRD.add(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c));
                        }
                    }
                }
            }
        }
        list<Residential_Address__c> lstRDToDelete =  new list<Residential_Address__c>();
        if(isPrevious == false && mpIsCurrentAddressToRD!= null &&  mpIsCurrentAddressToRD.size()>0 )
        {   
            if(mpIsCurrentAddressToRD.get(isPrevious)!=null && mpIsCurrentAddressToRD.get(isPrevious).Id!=null)
            lstRDToDelete.add(mpIsCurrentAddressToRD.get(isPrevious));
        }
        
        
        // deleteing extra RD ends here  
        list<residential_address__c> lstrdTemp =  objModelContainer.lstResidentialAddress;
        
        list<genesis__employment_information__c> lsteiTemp = objModelContainer.lstEmploymentInformation;
        
        if(lstEIToDelete!=null && lstEIToDelete.size()>0)
        {
            objModelContainer.lstEmploymentInformation.clear();
            objModelContainer.lstEmploymentInformation =  new  list<genesis__employment_information__c>();
        }
        
        if(lstRDToDelete !=null && lstRDToDelete.size()>0)
        {
            objModelContainer.lstResidentialAddress.clear();
            objModelContainer.lstResidentialAddress =  new list<residential_address__c>();
        }
        
        for(residential_address__c objRDMain: lstrdTemp )
        {
            for(residential_address__c objDel: lstRDToDelete)
            {
                
                    objModelContainer.lstResidentialAddress.add(objRDMain);

            }
        }
        
        for(genesis__employment_information__c objEIMain: lsteiTemp )
        {
            for(genesis__employment_information__c objDel: lstEIToDelete)
            {
                
                    objModelContainer.lstEmploymentInformation.add(objEIMain);

            }
        }
        
         return null;
      
    }
    
    
    public Pagereference saveCallFromHeader() {
     try{
        if(ReturnValue!=null && ReturnValue!='')
          objModelContainer.objApplication.IP_Address__c = ReturnValue;
          objModelContainer.objApplication.pepNavigation_Status__c=  pepUtilityClass.returnPageName(pagetoredirect);
          objModelContainer.SaveInputValuesToFields();
          
        // delete Extra EI
        map<integer, genesis__Employment_Information__c> mpEmpIdToEmpRec =  new map<integer, genesis__Employment_Information__c>();
        if(objModelContainer.lstEmploymentInformation !=null && objModelContainer.lstEmploymentInformation.size()>0)
        {
            for(genesis__Employment_Information__c objEmp : objModelContainer.lstEmploymentInformation)
            {
                mpEmpIdToEmpRec.put(integer.valueOf(objEmp.Sequence__c),objEmp);
            }
        }

        set<integer> setRecordsSequence =  new set<integer>();
        if(objModelContainer.lstSection !=null && objModelContainer.lstSection.size()>0)
        {
            for(pepCMSModelContainer_New.wrapSection objSection: objModelContainer.lstSection )
            {
                for(pepCMSModelContainer_New.wrapQuestion objWrapQuestion: objSection.lseQuestions)
                {
                            // fetch income records related to sequence
                    if(objWrapQuestion.objCmsQuestion != null )
                    {
                        if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'genesis__Employment_Information__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                        {                             
                            setRecordsSequence.add(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c));
                        }
                    }
                }
            }
        }
        list<genesis__Employment_Information__c> lstEIToDelete =  new list<genesis__Employment_Information__c>();
        if(setRecordsSequence!=null && mpEmpIdToEmpRec!= null)
        {   
            for(Integer i:mpEmpIdToEmpRec.keyset() )
            {
                if(!setRecordsSequence.contains(i))
                {
                    if(mpEmpIdToEmpRec.get(i)!=null && mpEmpIdToEmpRec.get(i).Id!=null)
                    lstEIToDelete.add(mpEmpIdToEmpRec.get(i));
                }
            }
        }
        
       
        map<boolean, Residential_Address__c> mpIsCurrentAddressToRD=  new map<boolean, Residential_Address__c>();
        if(objModelContainer.lstResidentialAddress !=null && objModelContainer.lstResidentialAddress.size()>0)
        {
            for(Residential_Address__c objRD : objModelContainer.lstResidentialAddress)
            {
                mpIsCurrentAddressToRD.put(objRD.Current_Address__c ,objRD);// if objRD.Current_Address__c == true then pick current address else pick second address
            }
        }

        set<integer> setRecordsSequenceRD =  new set<integer>();
        boolean isPrevious = false;
        if(objModelContainer.lstSection !=null && objModelContainer.lstSection.size()>0)
        {
            for(pepCMSModelContainer_New.wrapSection objSection: objModelContainer.lstSection )
            {
                for(pepCMSModelContainer_New.wrapQuestion objWrapQuestion: objSection.lseQuestions)
                {                  
                    if(objWrapQuestion.objCmsQuestion != null )
                    {
                        if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                        {  
                               // if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 1) isCurrent=true; //if current address
                            if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 2) isPrevious =true;// if previous address                         
                          
                        }
                    }
                }
            }
        }
        list<Residential_Address__c> lstRDToDelete =  new list<Residential_Address__c>();
        if(isPrevious == false && mpIsCurrentAddressToRD!= null &&  mpIsCurrentAddressToRD.size()>0 )
        {   
            if(mpIsCurrentAddressToRD.get(isPrevious)!=null && mpIsCurrentAddressToRD.get(isPrevious).Id!=null)
            lstRDToDelete.add(mpIsCurrentAddressToRD.get(isPrevious));
        }
        
       // if(lstRDToDelete !=null && lstRDToDelete .size()>0) delete lstRDToDelete ;
        
        // deleteing extra RD ends here  
        
        
        objModelContainer.SaveInputValuesToFields();
        system.debug('Application Id:: '+objModelContainer.objApplication);
        System.debug('Bhawna-Address::' + objModelContainer.lstResidentialAddress.size());
        Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
        Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
        
        mapChildObjects.PUT('residential_address__c', objModelContainer.lstResidentialAddress);
        mapChildObjects.PUT('genesis__employment_information__c', objModelContainer.lstEmploymentInformation);
        system.debug('objModelContainer.objAccount:: '+objModelContainer.objAccount);
        Account objA =  new Account();
        // check if account already exists
        if((objModelContainer.objAccount.PersonEmail!=null && objModelContainer.objAccount.PersonEmail!='' )||
            objModelContainer.objAccount.PersonMobilePhone != null && objModelContainer.objAccount.PersonMobilePhone!='')
        {
            list<Account> lstA = fetchExistingAccount(objModelContainer.objAccount.PersonEmail, objModelContainer.objAccount.PersonMobilePhone, objModelContainer.objAccount.PersonBirthdate, objModelContainer.objAccount.FirstName, objModelContainer.objAccount.LastName);
            if(lstA !=null && lstA.size()>0)
                objModelContainer.objAccount.ID = lstA[0].Id;
        }
        
        objA  = objModelContainer.objAccount;
        objA.pepIsDummyAccount__c = false;
        if(objA.Lastname != null && string.valueof(objA.Lastname)!='')
        upsert objA ;
        if(objA.id != null)
        objModelContainer.objApplication.genesis__Account__c = objA.Id;
        mapRelatedObjects.PUT('account', objModelContainer.objAccount);
        result = pepInvokeCLMethodHelper.updateApplication(objModelContainer.objApplication,mapRelatedObjects,mapChildObjects);
        
        system.debug('result ::'+result );
        
         if(lstEIToDelete!=null && lstEIToDelete.size()>0) delete lstEIToDelete;
         if(lstRDToDelete !=null && lstRDToDelete.size()>0) delete lstRDToDelete ;
       
       
        ServiceabilityCalcCtrl ctrl = new ServiceabilityCalcCtrl(result.Id);
        system.debug('ctrl :: '+ctrl );
        genesis__Applications__c objApp = new genesis__Applications__c() ;

        if(ctrl !=null)
        {         

            system.debug('objApplicationFromVeda :: '+objApp.Serviceability_Status__c);
        }
        
         pageReference ref; 
        if(objApp.Serviceability_Status__c == 'Approved')
        {
            system.debug('result.genesis__Account__c:: '+result.genesis__Account__c);
        
            //Account objAccount = [Select id,PersonEmail,PersonContactId from Account where id=: result.genesis__Account__c limit 1];
            Account objAccount = fetchAccountDetails(result.genesis__Account__c);
            String PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
            
            system.debug('Account::'+objAccount );
            
            system.debug('PIN::'+PIN + 'Email:: '+objAccount.PersonEmail);
               
                if(objAccount.PersonEmail != null)
                {
                    if(PIN != '')
                    {
                        objAccount.OTP__c = PIN;
                        objAccount.PepOTP__c = PIN;
                        update objAccount;
                        system.debug('Account:: '+objAccount);
                       
                        result.OTP__c = PIN;
                        result = pepInvokeCLMethodHelper.updateApplication(result,mapRelatedObjects,mapChildObjects);
                    }
                    
                    
               }
           }
           
           system.debug('status:::'+objApp.Serviceability_Status__c);
           
           if(objApp.Serviceability_Status__c == 'Declined')
           { 
           
                string redircetPageName= pages_config__c.getinstance('pepserviceabilitydecline').Page_Label__c;
                ref = new pageReference('/'+redircetPageName);
               system.debug('Redirect ::'+ref);
               //ref.setRedirect(true);
              //  return Redirect;
           }
           
           if(objApp.Serviceability_Status__c == 'Referred')
           {
               string redircetPageName= pages_config__c.getinstance('pepreferredpage').Page_Label__c;
               ref= new Pagereference('/'+redircetPageName);
               //ref.setRedirect(true);
           }
               
          
         Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
        cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objapplication.id)),null,-1,false);
        
        if(pagetoredirect=='1'){
         string redircetPageName= pages_config__c.getinstance('peploandetails').Page_Label__c;
               
         Pagereference per=new pagereference('/'+redircetPageName).setRedirect(True);
         per.setCookies(new Cookie[]{cookieApplicationId2 });
         return per;
         }
        else if(pagetoredirect=='2'){
          string redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
           
         Pagereference per=new pagereference('/'+redircetPageName).setRedirect(True);
         per.setCookies(new Cookie[]{cookieApplicationId2 });
         return per;
         }
        else if(pagetoredirect=='3'){
        string redircetPageName= pages_config__c.getinstance('pepexpensepage').Page_Label__c;
           
         Pagereference per=new pagereference('/'+redircetPageName).setRedirect(True);
         per.setCookies(new Cookie[]{cookieApplicationId2 });
         return per;
         }
        else{
        return null;
        }
    }
    catch(Exception ex){
    string redircetPageName=pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
    return new Pagereference('/'+redircetPageName);
    }
    }
    
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
         
             
         if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
               objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
    }
    
    // method not in use
    public void fetchResidentialAddress()
    {
        //hardcode application Id
        System.debug('Residential Address');
       
        Id idAccount;
                
        Map<string,string> childobjects = new Map<string,string>();       
        String[] lstTypes = new String[]{'Residential_Address__c'};
        
        List<genesis__Applications__c>  lstApplication = pepUtilityClass.fetchApplicationAndChild(lstTypes ,'ResidentialAdressFieldSet',null,lstApplication[0].Id,null);
        System.debug('lstApplication ******'+lstApplication);
        if(lstApplication != null && lstApplication.size() >0 )
        {        
            objApplication = lstApplication[0];             
            objModel1.objApplication = objApplication;
            idAccount = lstApplication[0].genesis__Account__c; 
            
            if(objApplication.Residential_Address__r!= null && objApplication.Residential_Address__r.size() > 0)
            {
               objModel1.lstResidentialAddress= new list<Residential_Address__c>();                
               objModel1.lstResidentialAddress.addAll(objApplication.Residential_Address__r);
            }
            
            
        } 
        
                        
    }
    
    //Changed parameters - Mitali Telang- to avoid overwriting of the account information
    private list<Account> fetchExistingAccount(string email, string phone, date birthdate, string fname, string lname)
    {
        List<Account> lsAcc;
        if(Limits.getQueries()+1<=Limits.getLimitQueries()){
        lsAcc=[select id,FirstName, PersonBirthdate, LastName,PersonMobilePhone,PersonEmail from account where FirstName = :fname AND LastName =: lname AND PersonBirthdate =:birthdate AND ((PersonEmail!=null AND PersonEmail= :email) OR (PersonMobilePhone!=null AND PersonMobilePhone= :phone)) Limit 1];
        }
        else{
                  PeputilityClass.sendexceptionemail(Peputilityclass.getCurrrentString());
                  throw new DMLException('This is a SOQL limit exception handling mechanism');
        }
        return lsAcc;
    }
    
    public PageReference doVerify () {
        String responseBody = makeRequest(baseUrl,
                'secret=' + secret +
                '&response='+ response
        );
        
        System.debug(responseBody);
        
        return null;
    }
    
    /**
     * Make request to verify captcha
     * @return      response message from google
     */
    private static String makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            return response.getBody();
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return '{"success":false}';
    }
    
    Public Pagereference checkcookie(){
    Pagereference pr=Peputilityclass.checkCookieAndRedirect();
    if(pr==null){
    Pagereference temp=PeputilityClass.HandleRedirectSecurity();
    return temp;
    }
    else{
    return pr;
    }
}
}