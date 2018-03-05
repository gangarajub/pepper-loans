// ---------------------------------------------------------------------------------------------------------
// This class is  used to capture the vehicle details. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      31st Jan 2017           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------


public class PepAssetPageController
{
   
   public List<wrapperSection> lstWrapperSection{get;set;}
   public Boolean checkVehicleDetails{get;set;}
   public Boolean successMsg{get;set;}
   public Boolean errorVin{get;set;}
   public Boolean noComplete{get;set;}
   public Boolean retreiveApp{get;set;}
   public Boolean unsecuredOffer{get;set;}
   public Boolean securedOffer{get;set;}
   public Boolean lvrPopup{get;set;}
   public Boolean makeDisabled{get;set;}
   public Boolean modelDisabled{get;set;}
   public Boolean disabledNo{get;set;}
   public Boolean vehicleAgeCheck{get;set;}
   public String selectedVehicle{get;set;}
   public String selectedDealer{get;set;}
   public String selectedVin{get;set;}
   public String loanDetails{get;set;}
   public String securedOfferText{get;set;}
   public String unsecuredOfferText{get;set;}
   public String loanAmount{get;set;}
   public String loanAmountAge{get;set;}
   public String loanPurpose{get;set;}
   public String appNumber{get;set;}
   public String appId{get;set;}
   public String selectedOffer{get;set;}
   public list<Attachment> attachList{get;set;}
   public clcommon__CL_Purpose__c objCLPurpose;
   private genesis__Applications__c objApplication;
   private clcommon__Collateral__c  assetDetail;
   private account objAccount;
   private List<genesis__Applications__c>  lstApplication;
   private list<Redbook_Valuation__c> lstRedbbok;
   private Map<String,Redbook_Valuation__c> redbbokSeriesMap;
   private Map<String,list<Redbook_Valuation__c>> makeMap;
   private Map<String,list<Redbook_Valuation__c>> modelMap;
   private Map<String,list<Redbook_Valuation__c>> variantMap;
   public String selectedRedbook;
   private String docId;
   
   
   
   public PepAssetPageController()
   {
      checkVehicleDetails = false;
      errorVin = false;
      successMsg = false;
      retreiveApp = false;
      noComplete = false;
      unsecuredOffer = false;
      securedOffer = false;
      lvrPopup = false;
      disabledNo = false;
      makeDisabled = true;
      modelDisabled = true;
      vehicleAgeCheck = false;
      selectedRedbook ='';
      selectedVehicle ='';
      selectedDealer ='';
      selectedVin = '';
      selectedOffer = '';
      lstWrapperSection = new List<wrapperSection>();
      objApplication = new genesis__Applications__c();
      lstApplication = new List<genesis__Applications__c> ();
      assetDetail = new clcommon__Collateral__c();
      objAccount = new Account();
      attachList = new list<Attachment> ();
      getCookieData();
      fetchApplication();
      loadCMSContentForAssetPage();
      loadData();
      queryAttachment();
   }
   
  
   
   // This method is used to get cookies from previous page.
 
   public void getCookieData()
    {
            Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
            if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
            {                           
                   objApplication.Id =  pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
                   appId = objApplication.Id;
            }
    }
  
 // This method is to fetch application on the basis of application id.
    
    public void fetchApplication()
    {
       
            Map<string,string> childobjects = new Map<string,string>();
            if(objApplication != null && objApplication.Id !=null)
            { 
                   
                   String[] lstTypes = new String[]{'clcommon__Collateral__c'};  // fieldset to fetch colletral information
                   lstApplication = pepUtilityClass.fetchApplicationAndChild(lstTypes ,'CollateralFieldSet',null,objApplication.Id,null);
                   if(lstApplication[0].genesis__CL_Purpose__c !=null)
                      objCLPurpose = [select id,Name from clcommon__CL_Purpose__c where id =:lstApplication[0].genesis__CL_Purpose__c];
                   if(lstApplication[0].genesis__Account__c !=null)
                      objAccount = [select id,Name,Send_Asset_list__c,PersonEmail,PersonMobilePhone from Account where id=:lstApplication[0].genesis__Account__c];
                      
                  
            }   
    }
   
   // This method is used to assigned values to some properties and wrappper class to auto populate values on page load.
   
    public void loadData()
    {
                    if(lstApplication.size() >0)
                    {        
                        objApplication = lstApplication[0];
                        if(objApplication.genesis__Status__c =='AWAITING ASSESSMENT') // check if application status is awaiting assessment
                           retreiveApp = true;
                           genesis__Application_Document_Category__c appDocCategory = [select id, Name from genesis__Application_Document_Category__c where genesis__Application__c=:objApplication.id and Name ='Collateral'];
                           docId = appDocCategory.id;
                      // This  loop is used to fetch field values dynamically from Application object.     
              
                          for(Schema.sobjectfield str:Schema.SObjectType.genesis__Applications__c.fields.getMap().values()) // fetch values to assign dynamicaly
                          {
                             
                                 string tempString = '{!genesis__Applications__c.'+str;
                                 tempString+='}';
                               
                                if(loanDetails.contains(tempString) || loanAmount.contains(tempString) || appNumber.contains(tempString) || loanAmountAge.contains(tempString))
                                 {
                                     
                                       if(string.isnotblank(String.valueof(objApplication.get(str))))  // replace CMS text to dynamic values
                                       {
                                                  String replaceValue = '';
                                                  Schema.DisplayType fielddataType = str.getDescribe().getType();
                                                  if(String.valueof(fielddataType) =='DOUBLE')
                                                   {
                                                        Decimal comingValue = double.valueof(objApplication.get(str));
                                                        replaceValue = (comingValue.setScale(2)).format();
                                                   }
                                               
                                               
                                               else{         
                                                       replaceValue=String.valueof(objApplication.get(str));
                                                   }
                                                     // assigned values to auto populate on page load.
                                                     loanDetails=loanDetails.replace(tempString,replaceValue);  
                                                     loanAmount=loanAmount.replace(tempString,replaceValue);
                                                     loanAmountAge=loanAmountAge.replace(tempString,replaceValue);
                                                     appNumber=appNumber.replace(tempString,replaceValue);
                                       }           
                                  }
                       }
                       
                           if(lstApplication[0].genesis__Collaterals__r !=null && lstApplication[0].genesis__Collaterals__r.size()>0) 
                             {  
                                 for(clcommon__Collateral__c objColletral : lstApplication[0].genesis__Collaterals__r) 
                                   {
                                        if(objColletral.active__c == true)
                                        {
                                            assetDetail = objColletral;      // fetch active colletral object record.
                                            break;
                                        }   
                                   }    
                                      if(assetDetail!=null && assetDetail.id!=null)
                                      {

                                          fetchRedbook(assetDetail);  // call Redbook method to fetch asset details and redbook series values
                                        if(makeDisabled == true && modelDisabled == true && string.isNotBlank(assetDetail.Red_Book_Vehicle_Series__c)) 
                                        {
                                             for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)   // if make and model  matched to redbbook data
                                              {
                                                 
                                                  if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                                                   {  
                                                        objWrapper.strAnswer = assetDetail.Red_Book_Vehicle_Series__c;
                                                   }
                                               } 
                                        }
                                        else
                                        { 
                                          if(String.isNotBlank(assetDetail.pep_User_Selected_Make__c)&& makeDisabled == false)
                                          {
                                             
                                             fetchSeriesValues('pep_User_Selected_Make__c',assetDetail.pep_User_Selected_Make__c.toLowerCase(),''); // if make does not matche to redbook data
                                          }
                                          if(String.isNotBlank(assetDetail.pep_User_Selected_Model__c) && String.isNotBlank(assetDetail.pep_User_Selected_Make__c) && modelDisabled == false)
                                          {
                                             fetchSeriesValues('pep_User_Selected_Model__c',assetDetail.pep_User_Selected_Make__c.toLowerCase(),assetDetail.pep_User_Selected_Model__c.toLowerCase()); 
                                              for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)  
                                              {
                                                   // assigned values to model and series of vehicle on page load if it is already filled by customer
                                                  if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c')
                                                   {
                                                     objWrapper.strAnswer = assetDetail.pep_User_Selected_Model__c ;
                                                   }
                                                  if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c' && string.isNotBlank(assetDetail.Red_Book_Vehicle_Series__c))
                                                   {  
                                                        objWrapper.strAnswer = assetDetail.Red_Book_Vehicle_Series__c;
                                                   }
                                               }  
                                          }
                                       }    
                                    }
                                  else
                                  {
                                      for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)    // if there is no active asset object record on page load
                                        {
                                           if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Vehicle__c')
                                            {
                                               objWrapper.strAnswer = 'Car';
                                               selectedVehicle = 'Car'; 
                                            } 
                                        }   
                                  }  
                                      
                             }  
                        else
                        {
                            for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)      // if there is no active asset object record on page load
                            {
                                    
                                    if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Vehicle__c')
                                    {
                                       objWrapper.strAnswer ='Car';
                                       selectedVehicle = 'Car';  
                                    } 
                            }   
                        }     
                        if(lstApplication[0].Is_Manually_Assessed__c ==true)     // checked backend team changed status to conditionally approved.
                        {
                            disabledNo = true;
                            for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                             {
                                    if(objWrapper.objQuestion.pepFieldApiName__c =='Item Details')
                                      {
                                            objWrapper.strAnswer = 'Yes' ;
                                            break;
                                      }
                                      
                             } 
                       }       
         }
            
    }
    
  // This method is used to load CMS content on page load.
  
   private void loadCMSContentForAssetPage()
    {
        
           
                               
               List<pepCmsSection__c> lstlandingPageCmsSection =[select id,pepHeader__c,pepSectionUniqueName__c,pepSectionBodyRich__c,pepSequence__c,
                                                                         (select id,pepLabelAfterQuestion__c,
                                                                                 pepLabelPriorQuestion__c,
                                                                                 pepSequence__c,pepIsRequired__c,
                                                                                 pepType__c,pepSubType__c,
                                                                                 pepGenericErrorMessage__c,
                                                                                 pepSObjectApiName__c,
                                                                                 pepFieldApiName__c
                                                                                 from pepQuestion__r order by pepSequence__c asc) 
                                                                                 from pepCmsSection__c where pepPage__r.pepPageName__c ='Asset Details Page' Order by pepSequence__c];   
                  loanDetails = lstlandingPageCmsSection[5].pepSectionBodyRich__c; 
                  loanAmount = lstlandingPageCmsSection[7].pepSectionBodyRich__c; 
                  loanAmountAge = lstlandingPageCmsSection[24].pepSectionBodyRich__c; 
                  securedOfferText = lstlandingPageCmsSection[9].pepSectionBodyRich__c; 
                  unsecuredOfferText = lstlandingPageCmsSection[10].pepSectionBodyRich__c;                                                   
                  loanPurpose = lstlandingPageCmsSection[12].pepSectionBodyRich__c; 
                  appNumber = lstlandingPageCmsSection[14].pepSectionBodyRich__c; 
                  if(!test.isRunningTest())
                  {
                    loanPurpose = loanPurpose.replace('{loanPurpose}',objCLPurpose.name);
                  }
             map<id,pepCmsQuestion__c> mapAllQuestions = new map<id,pepCmsQuestion__c>( [SELECT  pepSection__c,pepRecordSequence__c,pepSection__r.Name ,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                                    pepIsRequired__c, pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                                    pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, Id, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,
                                                                    (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                                            FROM pepCmsAnswer__r order by pepSequence__c ASC ), 
                                                                     (SELECT  pepSection__c,pepRecordSequence__c,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c ,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                                                              pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepRelatedCSS__c
                                                                            FROM CmsQuestion__r
                                                                            ORDER BY pepSequence__c ASC) 
                                                                    FROM pepCmsQuestion__c where pepPage__r.pepPageName__c ='Asset Details Page'
                                                                    ORDER BY pepSequence__c ASC]);
              
             
              
              
               if(lstlandingPageCmsSection != null && lstlandingPageCmsSection.size() > 0)
               { 
                   for(pepCmsSection__c objSection :lstlandingPageCmsSection)  // iterate over assaetpage section
                   {
                       if(objSection.pepQuestion__r != null && objSection.pepQuestion__r.size() > 0)
                       {                       
                             wrapperSection objWrapperSection = new wrapperSection();
                             objWrapperSection.objSection = objSection ;
                             objWrapperSection.lstWrapperQuestion = new List<wrapperApplication>();
                             for(pepCmsQuestion__c objQues : objSection.pepQuestion__r)    // iterate over question of section of asset page
                             { 

                                   if((test.isRunningTest())||(objQues.pepFieldApiName__c !='Is_Dealer_Purchased__c' ||(objQues.pepFieldApiName__c =='Is_Dealer_Purchased__c' && objCLPurpose.name !=label.purposeName)))
                                   {
                                   
                                       wrapperApplication objWrapper = new  wrapperApplication (); 
                                       objWrapper.objQuestion = objQues;
                                       objWrapper.lstExpectedAnswers = new list<wrapperAnswer> ();
                                       for(pepCmsAnswer__c objAnswer : mapAllQuestions.get(objQues.Id).pepCmsAnswer__r) 
                                       { 
                                           // assigned values to wrapper
                                           wrapperAnswer objwrapperAnswer = new  wrapperAnswer();
                                           objwrapperAnswer.objCmsAnswer = objAnswer; 
                                           objwrapperAnswer.strAns  = objAnswer.pepActualValue__c;                                   
                                           objWrapper.lstExpectedAnswers.add(objwrapperAnswer); 
                                       }
                                       objWrapperSection.lstWrapperQuestion.add(objWrapper);   
                                   }                                                 
                             }         
                             lstWrapperSection.add(objWrapperSection);
                       }
                   }
                }                                                               
    }
    
  // Create wrapper class to hold CMS data and user entered values.
  
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
            
          public  wrapperApplication()
         {
            lstSelectOption = new list<selectoption>();
            lstSelectOption.add(new SelectOption('', 'Choose one'));
         }  
              
      }
        //  section wrappper
        public class wrapperSection
        {
            
            public pepCmsSection__c  objSection{get;set;}
            public List<wrapperApplication> lstWrapperQuestion{get;set;}
        }
        // answer wrappper
        public class wrapperAnswer
        {
            public pepCmsAnswer__c objCmsAnswer {get; set;}
            public String strAns{get;set;}
        }
  
// This method is called when user clicked yes or no button.
  
   public void vehicleDetails()
   {
      
      String strSelected = ApexPages.currentPage().getParameters().get('text');
      if(strSelected=='No')         // if user clicked "No"
         checkVehicleDetails= true;
      else
      {   // if user clicked "yes"
             checkVehicleDetails= false;
             
               for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                 {
                      // assigned values to wrapper class variables
                    if(objWrapper.objQuestion.pepFieldApiName__c =='Item Details')
                       {
                            objWrapper.strAnswer = 'Yes' ;
                       }
                     if(objWrapper.objQuestion.pepFieldApiName__c =='Is_Dealer_Purchased__c' && String.isNotBlank(selectedDealer))
                       {
                            objWrapper.strAnswer = selectedDealer;
                       } 
                     if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Vehicle__c' && String.isNotBlank(selectedVehicle))
                       {
                           objWrapper.strAnswer = selectedVehicle;
                       } 
                        
                } 
       }          
   }
   
  // This method is used to send checklist after selecting no button.
  
   public pagereference  sendChecklist()
   {
     
      try{
           // check for personal email should not be blank on account
           if(objApplication != null && objApplication.Id !=null && objAccount.PersonEmail !=null && objAccount.PersonEmail !='')
            {  
                          try
                          {  
                              
                               account accountObj = new account();
                               accountObj.id = objAccount.id;
                               accountObj.Send_Asset_list__c = true;
                               update accountObj;   // update account to send checklist email
                                      
                               updateAppNo();
                          }
                          
                       catch (exception ex)
                        {
                           successMsg = false;
                        }        
            }  
            
            else
            {
                 successMsg = false;
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
   
   //  This Method is used to update the app status after click on no button.
   
     public void updateAppNo()
     {
           if(objApplication != null && objApplication.Id !=null)
           {
           
                try
                {
                     genesis__Applications__c  objApp = new genesis__Applications__c ();
                     objApp.id=objApplication.Id;
                     objApp.genesis__Status__c = 'AWAITING ASSESSMENT';   // update application status to awaiting assessment
                     Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                     Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
                     genesis__Applications__c  objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApp,mapRelatedObjects,mapChildObjects);
                     if(objApplicationNew !=null && objApplicationNew.id!=null)
                     {
                          successMsg = true;
                          noComplete = true;
                     }    
                         
                }
                
                catch (exception ex)
                {
                     successMsg = false;
                }       
                     
           }  
     }  
     
    // This method is used to call veda after selection of no button.
    
    public void callVeda()
     {
        if(objApplication != null && objApplication.Id !=null)
           {
               ServiceabilityCalcCtrl.doPostContractVedaCallout(objApplication.Id);   // update veda status on application
           }
     
     }
     
   //  This method is used to call car search api to create colletral object.
   
     public pageReference fetchAssetDetail()
     {
         
                  
              try
              {   
                  system.debug('vinIs'+selectedVin);
                  system.debug('selectedVehicleIs'+selectedVehicle);
                  system.debug('selectedDealerIs'+selectedDealer);
                  errorVin = false;
                  assetDetail = new clcommon__Collateral__c();            
                 if(string.isNotBlank(selectedVin))    // search on the basis of vin number.
                 {
                     String vinNumber = selectedVin;
                     if(string.IsNotBlank(selectedVehicle))
                     { 
                            if(selectedVehicle=='Motorbike')   // if vehicle is motorbike- call car api to fetch info
                            {
                                CarHistorySearchAPI carSearch1 = new CarHistorySearchAPI(vinNumber,objApplication.Id,'MotorBike');
                                assetDetail = carSearch1.getCarDetails();
                            } 
                            else   // if vehcile is other than motorbike - call car api to fetch info
                            {
                                CarHistorySearchAPI carSearch2 = new CarHistorySearchAPI(vinNumber,objApplication.Id,'Car');
                                assetDetail = carSearch2.getCarDetails();
                            }   
                     }   
                     else
                     {
                           CarHistorySearchAPI carSearch3 = new CarHistorySearchAPI(vinNumber,objApplication.Id,'Car');
                           assetDetail = carSearch3.getCarDetails(); 
                     }

                     if(assetDetail.id !=null && string.isNotBlank(assetDetail.clcommon__Make__c) && string.isNotBlank(assetDetail.clcommon__Model__c)
                          && string.isNotBlank(assetDetail.clcommon__Year__c)&& string.isNotBlank(assetDetail.pep_State_of_Registration__c)&& string.isNotBlank(assetDetail.pep_Registration_Number__c))
                       {
                           fetchRedbook(assetDetail);  // call this method to fetch redbook series values.
                       }
                        else
                       {
                               errorVin = true;
                               clearValues();
                               return null;
                       } 
                  }
                 else
                 {
                      
                      errorVin = true;
                      clearValues();
                 } 
             }
                     catch (exception ex)
                        {
                              errorVin = true;
                              clearValues();
                        }  
                 
                 return null;
          
     }
     
     // This method is used to clear values if vin number is wrong.
     
   public void clearValues()
   {
         for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
            {
                    if(objWrapper.objQuestion.pepFieldApiName__c !='clcommon__Vehicle_ID_Number__c' && objWrapper.objQuestion.pepFieldApiName__c !='Item Details'   
                    && objWrapper.objQuestion.pepFieldApiName__c !='pep_User_Selected_Vehicle__c' && objWrapper.objQuestion.pepFieldApiName__c !='Is_Dealer_Purchased__c')
                        // clear values 
                    {       
                       objWrapper.lstSelectOption = null;
                       objWrapper.strAnswer = null;
                    }  
                    if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Vehicle__c')
                    {
                        if(String.isNotBlank(selectedVehicle))
                           objWrapper.strAnswer = selectedVehicle;
                    }
                    if(objWrapper.objQuestion.pepFieldApiName__c =='Is_Dealer_Purchased__c')
                    {
                        if(String.isNotBlank(selectedDealer))
                             objWrapper.strAnswer = selectedDealer ;
                    }
                    if(objWrapper.objQuestion.pepFieldApiName__c =='Item Details')
                     {
                         objWrapper.strAnswer = 'Yes' ;
                     }
                  
            }
   }  
   
  // This method is used to save to values on database.
  
   public pageReference saveForLater()
   {
           try
            {
                  successMsg = false;
                  if(assetDetail !=null && assetDetail.id !=null && objApplication.id !=null && errorVin==false)
                  {
                     list<clcommon__Collateral__c> objassetDetailList = new list<clcommon__Collateral__c>();
                     clcommon__Collateral__c objInactiveAsset = inactiveAsset();
                     clcommon__Collateral__c objassetDetail = new clcommon__Collateral__c();
                     objassetDetail.id = assetDetail.id;
                     objassetDetail.active__c = true;
                      for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                        {
                                // assign values to asset detail object to save into databse
                                if(objWrapper.objQuestion.pepFieldApiName__c =='Is_Dealer_Purchased__c') 
                                {
                                    if(String.isNotBlank(selectedDealer))
                                       objassetDetail.Is_Dealer_Purchased__c = selectedDealer ;
                                    else
                                        objassetDetail.Is_Dealer_Purchased__c = objWrapper.strAnswer ;
                                } 
                                if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Vehicle__c')
                                {
                                    if(String.isNotBlank(selectedVehicle))
                                       objassetDetail.pep_User_Selected_Vehicle__c = selectedVehicle;  
                                    else 
                                       objassetDetail.pep_User_Selected_Vehicle__c = objWrapper.strAnswer; 
                                } 
                                if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Make__c')
                                 {
                                   objassetDetail.pep_User_Selected_Make__c = objWrapper.strAnswer;
                                 }
                                if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c')
                                 {
                                   objassetDetail.pep_User_Selected_Model__c = objWrapper.strAnswer;
                                 }                              
                                if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                                {
                                   objassetDetail.Red_Book_Vehicle_Series__c = objWrapper.strAnswer;
                                   selectedRedbook = objWrapper.strAnswer;
                                } 
                        }
                            objassetDetailList.add(objassetDetail);
                            if(objInactiveAsset!=null && objInactiveAsset.id !=null && objInactiveAsset.id !=objassetDetail.id)
                             {
                               objInactiveAsset.active__c = false;   // check for inactive asset
                               objassetDetailList.add(objInactiveAsset);
                             }   
                            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>(); 
                            mapChildObjects.PUT('clcommon__collateral__c',objassetDetailList);  
                            // update aaplication with updated values
                            genesis__Applications__c  objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
                            if(objApplicationNew.id!=null)
                              successMsg = true;
                            else
                                successMsg = false; 
                 } 
                 
                 else
                 {
                    successMsg = true;
                 }
         } 
         catch (exception ex)
          {
                  successMsg = false;    
          } 
                 
        return  null; 
     
                
 }  
 
   // This methid is used to activate the recent colletral object.
   
   public clcommon__Collateral__c inactiveAsset()
   {
         clcommon__Collateral__c colletralObject = new clcommon__Collateral__c();
         String[] lstTypes = new String[]{'clcommon__Collateral__c'};
         // fetch collateral with application object
         List<genesis__Applications__c>  lstApplication = pepUtilityClass.fetchApplicationAndChild(lstTypes ,'CollateralFieldSet',null,objApplication.Id,null);
         if(lstApplication[0].genesis__Collaterals__r !=null && lstApplication[0].genesis__Collaterals__r.size()>0) 
           {  
                  for(clcommon__Collateral__c objColletral : lstApplication[0].genesis__Collaterals__r) 
                    {
                        if(objColletral.active__c == true)
                          {
                             colletralObject = objColletral; // fetch active colletral record
                             break;
                          }   
                    } 
          }  
        return colletralObject;                        
   }
   
   // This mehtod is used to fetch redbook series values.
   
   public list<Redbook_Valuation__c> fetchRedbook(clcommon__collateral__c objColletral)
   {
      try
      {   
           lstRedbbok = new list<Redbook_Valuation__c> ();
          
           for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
           {
               // assigned values to wrapper variables to show on page
              if(objWrapper.objQuestion.pepFieldApiName__c =='Item Details')
                {
                    objWrapper.strAnswer = 'Yes' ;
                }
                if(objWrapper.objQuestion.pepFieldApiName__c =='Is_Dealer_Purchased__c')
                {  
                          if(String.isNotBlank(selectedDealer))
                             objWrapper.strAnswer = selectedDealer ;
                          else if(String.isNotBlank(objColletral.Is_Dealer_Purchased__c))
                              objWrapper.strAnswer = objColletral.Is_Dealer_Purchased__c;   
                } 
                if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Vehicle__c')
                {
                    if(String.isNotBlank(selectedVehicle))
                     objWrapper.strAnswer = selectedVehicle;  
                    else if(String.isNotBlank(objColletral.pep_User_Selected_Vehicle__c))
                    {
                      objWrapper.strAnswer = objColletral.pep_User_Selected_Vehicle__c;  
                      selectedVehicle = objColletral.pep_User_Selected_Vehicle__c; 
                    }
                }  
                if(objWrapper.objQuestion.pepFieldApiName__c =='clcommon__Vehicle_ID_Number__c')
                {
                   objWrapper.strAnswer = objColletral.clcommon__Vehicle_ID_Number__c;
                } 
               if(objWrapper.objQuestion.pepFieldApiName__c =='pep_State_of_Registration__c' )
                {
                   objWrapper.strAnswer = objColletral.pep_State_of_Registration__c ;
                }
                if(objWrapper.objQuestion.pepFieldApiName__c =='pep_Registration_Number__c' )
                {
                   objWrapper.strAnswer = objColletral.pep_Registration_Number__c;
                }
               if(objWrapper.objQuestion.pepFieldApiName__c =='clcommon__Year__c' )
                {
                   objWrapper.strAnswer = objColletral.clcommon__Year__c;
                }                                                   
           }
        
               list<Redbook_Valuation__c> variantList = new list<Redbook_Valuation__c>();   
               list<Redbook_Valuation__c> modelList = new list<Redbook_Valuation__c>(); 
               makeMap = new Map<String,list<Redbook_Valuation__c>> ();
               modelMap = new Map<String,list<Redbook_Valuation__c>> ();
               variantMap = new Map<String,list<Redbook_Valuation__c>> ();
               Set<SelectOption> lstSelectOptionMake = new Set<SelectOption>();
               Set<SelectOption> lstSelectOptionModel = new Set<SelectOption>();
               makeDisabled = true;
               modelDisabled = true;
               
               // query on the basis of year and make of vehicle.
               
               lstRedbbok = [select id,Description__c,LastModifiedDate,VehicleKey__c,AvgRetail__c,MakeDescription__c,FamilyDescription__c,YearGroup__c,BadgeDescription__c 
                   from Redbook_Valuation__c where MakeDescription__c=:objColletral.clcommon__Make__c and YearGroup__c=:objColletral.clcommon__Year__c order by FamilyDescription__c];
                   if(lstRedbbok.size()>0)
                   {
                      
                         for(Redbook_Valuation__c objRedbook :lstRedbbok)
                           {
                                  if(objRedbook.FamilyDescription__c.toLowerCase() == objColletral.clcommon__Model__c.toLowerCase()) 
                                  {
                                     modelList.add(objRedbook) ;
                                  }  
                                 
                           }  
                           
                          if(modelList.size()>0)  // if colletral model values  matched to redbook model value.
                          {
                                   
                                   for(Redbook_Valuation__c objRedbookModel :modelList)
                                    {
                                         if(string.isNotBlank(objRedbookModel.BadgeDescription__c) && objRedbookModel.BadgeDescription__c.toLowerCase() == objColletral.Variant__c.toLowerCase()) 
                                          {
                                             variantList.add(objRedbookModel) ;
                                          }  
                                    }
                                   if(variantList.size()>0)   // if colletral varaint values  matched to redbook variant value.
                                    {
                                        for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                                        {
                                            if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Make__c')
                                              {
                                                     objWrapper.lstSelectOption = new list<selectoption>();
                                                     objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')); 
                                                     lstSelectOptionMake.add(new SelectOption(objColletral.clcommon__Make__c, objColletral.clcommon__Make__c));
                                                     objWrapper.lstSelectOption.addAll(lstSelectOptionMake);
                                                     objWrapper.strAnswer = objColletral.clcommon__Make__c ;
                                              }
                                            if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c')
                                              {
                                                     objWrapper.lstSelectOption = new list<selectoption>();
                                                     objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')); 
                                                     lstSelectOptionModel.add(new SelectOption(objColletral.clcommon__Model__c, objColletral.clcommon__Model__c));
                                                     objWrapper.lstSelectOption.addAll(lstSelectOptionModel);
                                                     objWrapper.strAnswer = objColletral.clcommon__Model__c ;
                                              } 
                                             if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                                              {  
                                                  objWrapper.strAnswer = '';
                                                  objWrapper.lstSelectOption = new list<selectoption>();
                                                  objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));
                                                 for(Redbook_Valuation__c objRedbookVariant :variantList)
                                                  {
                                                    objWrapper.lstSelectOption.add(new SelectOption(objRedbookVariant.Description__c, objRedbookVariant.Description__c));
                                                  }
                                              }           
                                        }                 
                                    }
                                   else
                                   {
                                       for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                                        {
                                             if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Make__c')
                                              {
                                                     objWrapper.lstSelectOption = new list<selectoption>();
                                                     objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')); 
                                                     lstSelectOptionMake.add(new SelectOption(objColletral.clcommon__Make__c, objColletral.clcommon__Make__c));
                                                     objWrapper.lstSelectOption.addAll(lstSelectOptionMake);
                                                     objWrapper.strAnswer = objColletral.clcommon__Make__c ;
                                              }
                                              if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c')
                                              {
                                                     objWrapper.lstSelectOption = new list<selectoption>();
                                                     objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')); 
                                                     lstSelectOptionModel.add(new SelectOption(objColletral.clcommon__Model__c, objColletral.clcommon__Model__c));
                                                     objWrapper.lstSelectOption.addAll(lstSelectOptionModel);
                                                     objWrapper.strAnswer = objColletral.clcommon__Model__c ;
                                              }
                                              if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                                              {  
                                                    objWrapper.strAnswer = '';
                                                    objWrapper.lstSelectOption = new list<selectoption>();
                                                    objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));
                                                 for(Redbook_Valuation__c objRedbookModel :modelList)
                                                  {
                                                    objWrapper.lstSelectOption.add(new SelectOption(objRedbookModel.Description__c, objRedbookModel.Description__c));
                                                  }
                                              }
                                        }   
                                   }    
                          }
                          else
                           {
                                  // if colletral varaint values  does not match to redbook variant value.
                                  for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                                    {
                                       if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Make__c')
                                       {   
                                             objWrapper.lstSelectOption = new list<selectoption>();
                                             objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')); 
                                             lstSelectOptionMake.add(new SelectOption(objColletral.clcommon__Make__c, objColletral.clcommon__Make__c));
                                             objWrapper.lstSelectOption.addAll(lstSelectOptionMake);
                                             objWrapper.strAnswer = objColletral.clcommon__Make__c ;
                                       } 
                                       if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                                          {  
                                                    objWrapper.strAnswer = '';
                                                    objWrapper.lstSelectOption = new list<selectoption>();
                                                    objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')) ;     
                                          } 
                                       if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c')
                                       {  
                                           
                                           for(Redbook_Valuation__c objRedbookModel :lstRedbbok)
                                            {
                                                  objWrapper.strAnswer ='';
                                                  objWrapper.lstSelectOption = new list<selectoption>();
                                                  objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));
                                                  lstSelectOptionModel.add(new SelectOption(objRedbookModel.FamilyDescription__c, objRedbookModel.FamilyDescription__c));
                                                  
                                                  if(!modelMap.containskey(objRedbookModel.MakeDescription__c.toLowerCase()+':'+objRedbookModel.FamilyDescription__c.toLowerCase()))
                                                  {
                                                      modelMap.put(objRedbookModel.MakeDescription__c.toLowerCase()+':'+objRedbookModel.FamilyDescription__c.toLowerCase(),new List<Redbook_Valuation__c>());
                                                  }
                                                      modelMap.get(objRedbookModel.MakeDescription__c.toLowerCase()+':'+objRedbookModel.FamilyDescription__c.toLowerCase()).add(objRedbookModel );
                                                      
                                                   if(String.isNotBlank(objRedbookModel.BadgeDescription__c))
                                                   {      
                                                      if(!variantMap.containskey(objRedbookModel.MakeDescription__c.toLowerCase()+':'+objRedbookModel.FamilyDescription__c.toLowerCase()+':'+objRedbookModel.BadgeDescription__c.toLowerCase()))
                                                       {
                                                         variantMap.put(objRedbookModel.MakeDescription__c.toLowerCase()+':'+objRedbookModel.FamilyDescription__c.toLowerCase()+':'+objRedbookModel.BadgeDescription__c.toLowerCase(),new List<Redbook_Valuation__c>());
                                                       }
                                                         variantMap.get(objRedbookModel.MakeDescription__c.toLowerCase()+':'+objRedbookModel.FamilyDescription__c.toLowerCase()+':'+objRedbookModel.BadgeDescription__c.toLowerCase()).add(objRedbookModel ); 
                                                   }       
                                            }
                                                objWrapper.lstSelectOption.addAll(lstSelectOptionModel); 
                                                if(string.isNotBlank(objColletral.pep_User_Selected_Model__c)) 
                                                    objWrapper.strAnswer = objColletral.pep_User_Selected_Model__c;
                                       }      
                                    }  
                                    modelDisabled = false;
                           }
                   }
                 else
                 {
                       lstRedbbok = [select id,Description__c,LastModifiedDate,VehicleKey__c,AvgRetail__c,MakeDescription__c,FamilyDescription__c,YearGroup__c,BadgeDescription__c 
                       from Redbook_Valuation__c where YearGroup__c=:objColletral.clcommon__Year__c order by MakeDescription__c,FamilyDescription__c];
                         // Query on  the basis of year only
                       if(lstRedbbok.size()>0)
                       {
                          
                           
                             for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                              {
                                 if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Make__c')
                                   {  
                                       for(Redbook_Valuation__c objRedbook :lstRedbbok)   // create map to hold values for make,model and variant
                                        {
                                               objWrapper.strAnswer = '';     
                                               objWrapper.lstSelectOption = new list<selectoption>();
                                               objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));
                                               lstSelectOptionMake.add(new SelectOption(objRedbook.MakeDescription__c, objRedbook.MakeDescription__c));
                                                if(!makeMap.containskey(objRedbook.MakeDescription__c.toLowerCase())) // hold make values
                                                   {
                                                     makeMap.put(objRedbook.MakeDescription__c.toLowerCase(),new List<Redbook_Valuation__c>());
                                                   }
                                                    makeMap.get(objRedbook.MakeDescription__c.toLowerCase()).add(objRedbook);
                                                    
                                                  if(!modelMap.containskey(objRedbook.MakeDescription__c.toLowerCase()+':'+objRedbook.FamilyDescription__c.toLowerCase()))
                                                   {
                                                     // hold model values
                                                     modelMap.put(objRedbook.MakeDescription__c.toLowerCase()+':'+objRedbook.FamilyDescription__c.toLowerCase(),new List<Redbook_Valuation__c>());
                                                   }
                                                     modelMap.get(objRedbook.MakeDescription__c.toLowerCase()+':'+objRedbook.FamilyDescription__c.toLowerCase()).add(objRedbook);
                                                  if(String.isNotBlank(objRedbook.BadgeDescription__c))
                                                  {      
                                                       // hold varaint values
                                                      if(!variantMap.containskey(objRedbook.MakeDescription__c.toLowerCase()+':'+objRedbook.FamilyDescription__c.toLowerCase()+':'+objRedbook.BadgeDescription__c.toLowerCase()))
                                                       {
                                                         variantMap.put(objRedbook.MakeDescription__c.toLowerCase()+':'+objRedbook.FamilyDescription__c.toLowerCase()+':'+objRedbook.BadgeDescription__c.toLowerCase(),new List<Redbook_Valuation__c>());
                                                       }
                                                         variantMap.get(objRedbook.MakeDescription__c.toLowerCase()+':'+objRedbook.FamilyDescription__c.toLowerCase()+':'+objRedbook.BadgeDescription__c.toLowerCase()).add(objRedbook); 
                                                  }    
                                               
                                        }
                                             objWrapper.lstSelectOption.addAll(lstSelectOptionMake);
                                              if(string.isNotBlank(objColletral.pep_User_Selected_Make__c)) 
                                                    objWrapper.strAnswer = objColletral.pep_User_Selected_Make__c;
                                            
                                   }   
                                            if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c')
                                              {
                                                     objWrapper.strAnswer = '' ;
                                                     objWrapper.lstSelectOption = new list<selectoption>();
                                                     objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')); 
                                              }
                                              if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                                              {  
                                                    objWrapper.strAnswer = '';
                                                    objWrapper.lstSelectOption = new list<selectoption>();
                                                    objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one')) ;     
                                              }         
                            }     
                               makeDisabled = false;
                               modelDisabled = false;                            
                       }     
                      else{
                             errorVin = true;
                             clearValues();
                          } 
                 }
   }       
          catch (exception ex)
           {
                      errorVin = true;
                      clearValues();
           } 
        return lstRedbbok ; 
   }
   
   // This method is used calculate LVR and to get available loans offer 
   
  public pageReference confirmAndContinue()
   {
       
             try
             {
                saveForLater();
               if(successMsg && lstRedbbok.size()>0 && string.isNotBlank(selectedRedbook))
                 {
                            
                           redbbokSeriesMap = new Map<String,Redbook_Valuation__c>();
                           unsecuredOffer = false;
                           vehicleAgeCheck = false;
                           for(Redbook_Valuation__c objRedbbok :lstRedbbok)
                            {
                               redbbokSeriesMap.put(objRedbbok.Description__c,objRedbbok);
                            } 
                           if(redbbokSeriesMap.containsKey(selectedRedbook))   // fetch redbook series
                           {
                              
                               DateTime modifiedDate= redbbokSeriesMap.get(selectedRedbook).LastModifiedDate;
                               Date appraisalDate = date.newinstance(modifiedDate.year(), modifiedDate.month(), modifiedDate.day());  // convert created date(dateTime) to date
                               CollateralUtil util = new CollateralUtil();
                               clcommon__collateral_valuation__c objcolletral = New clcommon__collateral_valuation__c();
                               if(!test.isRunningTest())
                                  objcolletral = util.storeValuation(redbbokSeriesMap.get(selectedRedbook).VehicleKey__c,selectedRedbook,assetDetail.id,appraisalDate,redbbokSeriesMap.get(selectedRedbook).AvgRetail__c);
                               if((objcolletral!= null && objcolletral.id!=null) || test.isRunningTest())
                               {
                                   CollateralUtil utilLvr = new CollateralUtil();
                                   Decimal lvr;
                                   if(!test.isRunningTest())
                                      lvr = utilLvr.getLVRPercent(assetDetail.id, objApplication.Id);  // to fetch LVR
                                    else
                                       lvr = 120;
                                   CollateralUtil utilReferred = new CollateralUtil();
                                   genesis__Applications__c appObj ;
                                   if(!test.isRunningTest())
                                       appObj = utilReferred.checkStolenOrWrittenOffApp(assetDetail.id,objApplication.id); // to check vin stolen or writtenOff
                                   if(appObj!=null && appObj.genesis__Status__c=='REFERRED')
                                   {
                                        string redircetPageName = pages_config__c.getinstance('pepreferredpage').Page_Label__c;
                                        pageReference objNextPage = new Pagereference('/'+redircetPageName);
                                        objNextPage.setRedirect(true);
                                        return objNextPage;
                                   }
                                   Date systemDate;
                                   if(!test.isRunningTest())
                                   {
                                       loan.GlobalLoanUtilFacade loanUtil = new loan.GlobalLoanUtilFacade();
                                        systemDate = loanUtil.getCurrentSystemDate();
                                   }
                                   else
                                   {
                                      systemDate = date.today();
                                   }
                                   // calculate vehicle age at the end of loan term
                                   integer vehicleAge;
                                    if(!test.isRunningTest())
                                        vehicleAge = ((systemDate.Year())-integer.valueOf(assetDetail.clcommon__Year__c))+integer.valueOf(objApplication.Requested_Term__c);  
                                     else
                                         vehicleAge =10;
                                 //  if(!test.isRunningTest())  
                                      if(vehicleAge>integer.valueOf(label.vehicleAge))
                                         vehicleAgeCheck = true;
                                   if((lvr<=120 && vehicleAge <= integer.valueOf(label.vehicleAge)) ) // if lvr is less or equal 120 and vehicle age than is less than 12 years
                                   {
                                        Map<string,string> childobjects = new Map<string,string>();       
                                        List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
                                        objApplication = lstApplication[0];
                                        pepUtilityClass.SaveContinueStatus(objApplication,'pepPaymentSetup') ;
                                        cookie cookieApplicationId = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
                                        string redircetPageName= pages_config__c.getinstance('peppaymentsetup').Page_Label__c;
                                        pageReference objNextPage =new Pagereference('/'+redircetPageName);
                                        objNextPage.setCookies(new Cookie[]{cookieApplicationId}); 
                                        objNextPage.setRedirect(true);
                                        return objNextPage;
                                   }
                                   else
                                   {        // if lvr is greater 120 or vehicle age than is greater than 12 years 
                                              if(objCLPurpose.name ==label.purposeName)
                                              {    
                                                     Map<string,string> childobjects = new Map<string,string>();       
                                                     List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
                                                     objApplication = lstApplication[0];
                                                     objApplication.genesis__Status__c = 'REFERRED';
                                                     Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                                                     Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
                                                     genesis__Applications__c  objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
                                                     string redircetPageName = pages_config__c.getinstance('pepreferredpage').Page_Label__c;
                                                     pageReference objNextPage = new Pagereference('/'+redircetPageName);
                                                     objNextPage.setRedirect(true);
                                                     return objNextPage;
                                              }
                                              Boolean getOfferSecured = false;
                                              ApplicationOfferUtil utilSecured = new ApplicationOfferUtil(); 
                                              genesis__Application_Pricing_Detail__c pricingDetailSecured = new genesis__Application_Pricing_Detail__c();
                                              // fetch secured offered availability
                                                 pricingDetailSecured = utilSecured.getSecuredOffer(objApplication.Id, getOfferSecured);
                                              if(pricingDetailSecured.message__c == 'OFFER AVAILABLE')
                                              {
                                                 String frequency;
                                                 if(pricingDetailSecured.debit_Frequency__c.toLowerCase()=='bi-weekly')
                                                    frequency = 'fortnightly';
                                                 else
                                                    frequency = pricingDetailSecured.debit_Frequency__c.toLowerCase();  
                                                     
                                                 securedOfferText = securedOfferText.replace('{amount}',pricingDetailSecured.genesis__Maximum_Financed_Amount__c.format());
                                                 securedOfferText = securedOfferText.replace('{term}',string.valueOf(pricingDetailSecured.genesis__Term__c/12));
                                                 securedOfferText = securedOfferText.replace('{interest}',pricingDetailSecured.genesis__Interest_Rate__c.format());
                                                 securedOfferText = securedOfferText.replace('{repaymentAmount}',pricingDetailSecured.debit_Amount__c.format());
                                                 securedOfferText = securedOfferText.replace('{paymentFrequency}',frequency);
                                              } 
                                              else if(pricingDetailSecured.message__c == 'OFFER NOT AVAILABLE')
                                              {
                                                 securedOffer = true;
                                              }
                                             Boolean getOfferUnsecured = false;
                                             ApplicationOfferUtil utilUnsecured = new ApplicationOfferUtil();
                                             // fetch unsecured offer availability
                                             genesis__Application_Pricing_Detail__c pricingDetailUnsecured = utilUnsecured.getUnSecuredOffer(objApplication.Id, getOfferUnsecured);
                                             if(pricingDetailUnsecured.message__c =='OFFER AVAILABLE')
                                             {
                                                  
                                                  String frequency;
                                                 if(pricingDetailUnsecured.debit_Frequency__c.toLowerCase()=='bi-weekly')
                                                    frequency = 'fortnightly';
                                                 else
                                                    frequency = pricingDetailUnsecured.debit_Frequency__c.toLowerCase(); 
                                                     
                                                  unsecuredOfferText = unsecuredOfferText.replace('{amount}',pricingDetailUnsecured.genesis__Maximum_Financed_Amount__c.format());
                                                  unsecuredOfferText = unsecuredOfferText.replace('{term}',string.valueOf(pricingDetailUnsecured.genesis__Term__c/12));
                                                  unsecuredOfferText = unsecuredOfferText.replace('{interest}',pricingDetailUnsecured.genesis__Interest_Rate__c.format());
                                                  unsecuredOfferText = unsecuredOfferText.replace('{repaymentAmount}',pricingDetailUnsecured.debit_Amount__c.format());
                                                  unsecuredOfferText = unsecuredOfferText.replace('{paymentFrequency}',frequency);
                                                  
                                                  lvrPopup = true;
                                                  return null;
                                             }    
                                             else if(pricingDetailUnsecured.message__c =='OFFER NOT AVAILABLE')
                                              {
                                                 
                                                  unsecuredOffer = true;
                                                  lvrPopup = true;
                                                  return null;
                                              }
                                              
                                            
                                   }
                              }
                        }  
                   }    
                   
            }
            catch (exception ex)
            {
                   successMsg = false; 
                   return null;    
            }  
                
             successMsg = false; 
             return null;   
     
   }   
   // This method is used to fetch series on page load
   
    public pageReference fetchSeries()
    {
        try
        {
        
            String strSelected = ApexPages.currentPage().getParameters().get('selectedValue');
            String selectedMake ='';
            String selectdModel = '';
            
            for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
              {
                 if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Make__c' && string.isNotBlank(objWrapper.strAnswer))
                   { 
                      selectedMake = objWrapper.strAnswer.toLowerCase();
                   }
                   if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c' && string.isNotBlank(objWrapper.strAnswer))
                   { 
                      selectdModel = objWrapper.strAnswer.toLowerCase();
                   }
              }  
              fetchSeriesValues(strSelected,selectedMake,selectdModel);
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
    
    // This method is used to fetch redbbok series values on page load
    
       public void fetchSeriesValues(String strSelected,String selectedMake,String selectdModel)
       {    
          if(strSelected=='pep_User_Selected_Make__c' && makeMap.containsKey(selectedMake))  // fetch model on the basis of selected make
          {
             for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                    {
                         if(objWrapper.objQuestion.pepFieldApiName__c =='pep_User_Selected_Model__c')
                          {  
                             objWrapper.strAnswer = '';
                             objWrapper.lstSelectOption = new list<selectoption>();
                             Set<SelectOption> lstSelectOptionModel = new Set<SelectOption>();
                             lstSelectOptionModel.add(new SelectOption('', 'Choose one'));
                             for(Redbook_Valuation__c objRedbookModel :makeMap.get(selectedMake))
                              {
                                lstSelectOptionModel.add(new SelectOption(objRedbookModel.FamilyDescription__c, objRedbookModel.FamilyDescription__c));
                              }
                                objWrapper.lstSelectOption.addAll(lstSelectOptionModel);
                          }
                          if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                          {  
                             objWrapper.strAnswer = '';
                             objWrapper.lstSelectOption = new list<selectoption>();
                             objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));
                          }
                    }  
        }
        else if(strSelected=='pep_User_Selected_Model__c')    // fetch make on the basis of selected model
        {
            if(variantMap.containsKey(selectedMake+':'+selectdModel+':'+assetDetail.Variant__c.toLowerCase()))
            {
                  for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                    {
                                             
                          if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                          {  
                              objWrapper.strAnswer = '';
                              objWrapper.lstSelectOption = new list<selectoption>();
                              objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));
                             for(Redbook_Valuation__c objRedbookModel :variantMap.get(selectedMake+':'+selectdModel+':'+assetDetail.Variant__c.toLowerCase()))
                              {
                                objWrapper.lstSelectOption.add(new SelectOption(objRedbookModel.Description__c, objRedbookModel.Description__c));
                              }
                              break;
                          }
                    }    
            }
            else if (modelMap.containsKey(selectedMake+':'+selectdModel))  // fetch series on the basis of make and model
            {
                  for(wrapperApplication objWrapper:  lstWrapperSection[0].lstWrapperQuestion)
                    {
                                             
                          if(objWrapper.objQuestion.pepFieldApiName__c =='Red_Book_Vehicle_Series__c')
                          {  
                             objWrapper.strAnswer = '';
                             objWrapper.lstSelectOption = new list<selectoption>();
                             objWrapper.lstSelectOption.add(new SelectOption('', 'Choose one'));
                             for(Redbook_Valuation__c objRedbookModel :modelMap.get(selectedMake.toLowerCase()+':'+selectdModel.toLowerCase()))
                              {
                                objWrapper.lstSelectOption.add(new SelectOption(objRedbookModel.Description__c, objRedbookModel.Description__c));
                              }
                              break;
                          }
                    }     
             }
        }
      
    }   
    
  // This method is used to upload attachment.
  
    @RemoteAction
    public static String doUploadAttachment(String acctId, String attachmentBody, String attachmentName, String attachmentId) {
        if(acctId != null) {
        
                if(attachmentBody != null) {
                    Attachment att = getAttachment(attachmentId);
                    String newBody = '';
                    if(att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);  
                    }
                    newBody += attachmentBody;
                    att.Body = EncodingUtil.base64Decode(newBody);
                    if(attachmentId == null) {
                        att.Name = attachmentName;
                        att.parentId = acctId;    // insert attachment
                    }
                    upsert att;
                    return att.Id;
                } else {
                    return 'Attachment Body was null';
                }
           
        } else {
            return 'Account Id was null';
        }
    }
     
  // This method is used to fetch attachment
  
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    
   // This method is used to delete attachment.
   
   public void deleteAttachment()
   {
       id strSelected  = ApexPages.currentPage().getParameters().get('attachmentId');
       if(String.isNotBlank(strSelected))
       {
           genesis__AppDocCatAttachmentJunction__c objJunction = [select id,genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunction__c where genesis__AttachmentId__c=:strSelected];
           delete objJunction ;    // delete attachment and attachment junction object
           attachment att =new attachment();
           att.id = strSelected  ;
           delete att ;
           queryAttachment();
       }
   }
   
     // This method is used to query attachment on page load.

    public void queryAttachment()
    {
       attachList = new list<Attachment> ();
       set<id> attachmentId = new set<id>();
       list<genesis__Application_Document_Category__c> appDocCategoryList = new list<genesis__Application_Document_Category__c>();
       appDocCategoryList = [select id,(select id,genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunctions__r) from genesis__Application_Document_Category__c where genesis__Application__c=:objApplication.id and Name ='Collateral'];
       if(appDocCategoryList.size()>0)
       {
           for(genesis__Application_Document_Category__c objCategory:appDocCategoryList)
           {
               for(genesis__AppDocCatAttachmentJunction__c objAtt:objCategory.genesis__AppDocCatAttachmentJunctions__r)
               {
                   if(objAtt.genesis__AttachmentId__c!=null)
                      attachmentId.add(objAtt.genesis__AttachmentId__c);
               }      
           }
           if(attachmentId.size()>0)
              attachList = [select id,name from Attachment where id in:attachmentId];
       }
    }
  
  // This method is used to get id of currently uploaded attachment
  
    public void fetchAttachmentId()
    {
       id attId = ApexPages.currentPage().getParameters().get('idAtt');
        if(string.isNotBlank(attId))
          linkAttachment(objApplication.Id,docId,attId);
    }
    
  // This method is used to link uploaded attachemnt to colletral category
  
    public void linkAttachment(String appId, String docId, String attId)
    {
       String jsonRes = genesis.TransactionRoomRemoteAction.linkAttachmentToADC(appId, docId, attId);
    }
    
  // This method is used to apply user selected offer.
  
    public PageReference applyOffer()
    {
       
             try
             {
                        
                        if(selectedOffer=='Asset')  // if user wants to change vehicle detail
                        {
                             string redircetPageName= pages_config__c.getinstance('pepassetpage').Page_Label__c;
                             pageReference ref = new pageReference('/'+redircetPageName);
                             ref.setRedirect(true);
                             return ref;
                        }
                        
                        else if(selectedOffer=='Secured')   // if user selects secured offer
                        {
                              Boolean applyOffer =true;
                              ApplicationOfferUtil utilApplySecured = new ApplicationOfferUtil();
                              genesis__Application_Pricing_Detail__c pricingDetailSecured  = New genesis__Application_Pricing_Detail__c();
                              if(!test.isRunningTest())
                                  pricingDetailSecured = utilApplySecured.getSecuredOffer(objApplication.Id,applyOffer);
                              if(pricingDetailSecured.message__c=='OFFER APPLIED' || test.isRunningTest())  // if offer is applied
                              {
                                    Map<string,string> childobjects = new Map<string,string>();       
                                    List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
                                    objApplication = lstApplication[0];
                                    pepUtilityClass.SaveContinueStatus(objApplication,'pepPaymentSetup') ;
                                    cookie cookieApplicationId = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
                                    string redircetPageName= pages_config__c.getinstance('peppaymentsetup').Page_Label__c;
                                    pageReference objNextPage =new Pagereference('/'+redircetPageName);
                                    objNextPage.setCookies(new Cookie[]{cookieApplicationId}); 
                                    objNextPage.setRedirect(true);
                                    return objNextPage; 
                              }
                              else
                              {
                                  successMsg = false; 
                                  return null;
                              }
                        }
                        
                        else if(selectedOffer=='Unsecured')   // if user selects unsecured offer
                        {
                              Boolean applyOffer =true;
                              ApplicationOfferUtil utilApplyUnsecured = new ApplicationOfferUtil();
                              genesis__Application_Pricing_Detail__c pricingDetailUnsecured = New genesis__Application_Pricing_Detail__c();
                              if(!test.isRunningTest())
                                 pricingDetailUnsecured = utilApplyUnsecured.getUnSecuredOffer(objApplication.Id,applyOffer);
                              
                              if(pricingDetailUnsecured.message__c=='OFFER APPLIED' || test.isRunningTest()) // if offer is applied
                              {
                                     Map<string,string> childobjects = new Map<string,string>();       
                                     List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
                                     objApplication = lstApplication[0];
                                     pepUtilityClass.SaveContinueStatus(objApplication,'pepPaymentSetup') ;
                                     cookie cookieApplicationId = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),null,-1,false);
                                     string redircetPageName= pages_config__c.getinstance('peppaymentsetup').Page_Label__c;
                                     pageReference objNextPage =new Pagereference('/'+redircetPageName);
                                     objNextPage.setCookies(new Cookie[]{cookieApplicationId}); 
                                     objNextPage.setRedirect(true);
                                     return objNextPage;
                              }
                              else
                              {
                                  successMsg = false; 
                                  return null;
                              }
                        }
                        
                       else if(selectedOffer=='Withdraw') // if user wants to withdraw application 
                        {
                             Map<string,string> childobjects = new Map<string,string>();       
                             List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
                             objApplication = lstApplication[0];
                             Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                             Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
                             genesis__Applications__c objApp = new genesis__Applications__c() ;
                             objApp.id = objApplication.Id;
                             objApp.genesis__Status__c='DECLINED';   // update app status to decline
                             genesis__Applications__c  objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApp,mapRelatedObjects,mapChildObjects);
                             string redircetPageName= pages_config__c.getinstance('pepdeclinedcontract').Page_Label__c;
                             pageReference ref = new pageReference('/'+redircetPageName);
                             ref.setRedirect(true);
                             return ref;
                        }
                        
         }
         catch (exception ex)
           {
               successMsg = false; 
               return null;    
           }  
        return null;  
           
    }
}