public class pepOfferScreen {

    public list<pepCmsSection__c> lstSection{get;set;}
    public string strSectionHeader{get;set;}
    public transient Cookie cookieApplicationId;
    public Id idApplication{get;set;} 
    Public string timevar{get;set;}
    //public genesis__Applications__c app{get;set;}
    public string strPurpose{get;set;}
    public List<genesis__Applications__c> lstApp{get;set;}
    //public decimal dcmlEMI{get;set;}
    public string strSectionBody{get;set;}
    public string strSectionBody2{get;set;}
    public string strSectionBody3{get;set;}
    public Boolean isError{get;set;}
    public string YesOrNo{get;set;}
    public Id accountId{get;set;}
    public string strAppNumber {get;set;}
    public list<pepCmsSection__c> lstsectionHeader{get;set;}
    public String Page_Name{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    public genesis__Applications__c objApplication;
    list<Account> lstAcc   =  new list<Account>();
    
    public pepOfferScreen () { 
    
    objApplication = new genesis__Applications__c ();
    page_Name=ApexPages.currentPage().getUrl();//Added by KG
    page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());//Added by KG
    Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
        timevar=String.valueof(System.now());
             
        lstsectionHeader =  new list<pepCmsSection__c>();
         isError =false;
        lstSection =  new list<pepCmsSection__c>();
        
        string strURL = ApexPages.currentPage().getUrl();          
        if(strURL.contains('?'))
        {
            strURL = strurl.substringBefore('?');
        }
        
        lstsectionHeader  = [select id , pepSectionBodyRich__c , pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Header' order by pepSequence__c ASC ];
       
     
        strAppNumber ='';
        strSectionHeader='';
       
        
       //lstSection();     
       getCookieData();
       fetchAffordibikityCheck();
    } 
    
   
    // This method is used to get cookies from previous page.
 
   public void getCookieData()
    {
             cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
             if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
            {                           
                   objApplication.Id =  pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
                   System.debug('CookieValueIs'+cookieApplicationId);
            }
    }
  
 // This method is to fetch application on the basis of application id.
    
  
    
    
    public void fetchAffordibikityCheck()
    {    
        Decimal decAmount;
        decimal decyear;
        String strpaymentFreQuency;
        string strcreditRating;
        Id idClPurpose;
        decimal decIndicativeInterestrate;
        isError =false;
        
       
            Map<string,string> childobjects = new Map<string,string>();       
            if(objApplication != null && objApplication.Id !=null)
            {
                
               List<genesis__Applications__c>  lstApp  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.Id,null,null,childobjects );
               System.debug('lstApplication  *********'+lstApp  );
                if(lstApp != null && lstApp.size() >0)
                {        
                    objApplication = lstApp[0];
                }
            
        
         genesis__Applications__c objApp = [select id, genesis__CL_Purpose__c, genesis__CL_Purpose__r.Name,genesis__Account__c from genesis__Applications__c where Id=: objApplication.id];
       
        strPurpose = objApp.genesis__CL_Purpose__r.Name;                                      
       
        accountId = lstApp[0].genesis__Account__c; 
        
       
        list<clcommon__CL_Product__c> lstCLP = [select id,clcommon__Product_Name__c from clcommon__CL_Product__c where Id=: lstApp[0].genesis__CL_Product__c];
       
        list<pepCmsSection__c> lstSection=[select Id, Name, pepSectionUniqueName__c, pepSectionStoryRich__c, pepSectionStory__c,pepSectionBodyRich__c,pepSectionBody__c,
                                                pepHeader__c ,pepSequence__c from pepCmsSection__c  where pepPage__r.pepPageName__c='Offer Screen' and (pepSectionUniqueName__c='OfferScreen4' OR pepSectionUniqueName__c='OfferScreen5' ) order by pepSequence__c ASC];
                                                
      string roundedwithdollar = '$' + string.valueOf((lstApp[0].debit_amount__c).setScale(2));
   
           if(lstSection[0].pepSectionUniqueName__c == 'OfferScreen4')
           {
                                               
               string str1 = lstSection[0].pepSectionBodyRich__c;
               string str2 = str1.replace('{!genesis__Applications__c.genesis__Loan_Amount__c}', lstApp[0].genesis__Loan_Amount__c.format());
               str2 = str2.replace('{!genesis__Applications__c.pep_Loan_Type__c}', lstCLP[0].clcommon__Product_Name__c);
               str2 = str2.replace('{!genesis__Applications__c.genesis__CL_Purpose__r.Name}', strPurpose);
               str2 = str2.replace('{!objApplication.genesis__Interest_Rate__c}', String.valueOF(lstApp[0].genesis__Interest_Rate__c.setscale(2)));
               
               Decimal toround = lstApp[0].debit_amount__c;
               Decimal rounded = toround.setScale(2);
               system.debug('rounded ::'+rounded );
                     
                  
                 
               str2 = str2.replace('{!genesis__Applications__c.Debit_amount__c}', roundedwithdollar);
               
               if(lstApp[0].Debit_Frequency__c == 'BI-WEEKLY')
               {    
                   lstApp[0].Debit_Frequency__c = 'fortnightly';
               } 
               
              
                if(lstApp[0].Debit_Frequency__c != null && lstApp[0].Debit_Frequency__c != '')
                {
                    string frequency = lstApp[0].Debit_Frequency__c.tolowercase();
         //           frequency = frequency.substring(0,1).toUpperCase() + frequency.substring(1).toLowerCase();
                    lstApp[0].Debit_Frequency__c = frequency;
                }
        
                           
                str2 = str2.replace('{!genesis__Applications__c.Debit_Frequency__c}', lstApp[0].Debit_Frequency__c);
               
                str2 = str2.replace('{!genesis__Applications__c.Requested_Term__c}', string.valueOf(lstApp[0].genesis__Term__c));
               
               strSectionBody = str2 ;
            }
            if(lstSection[1].pepSectionUniqueName__c == 'OfferScreen5')
           {  
               string term = '';
               if(lstApp[0].genesis__Term__c != null)
               {
                   term = string.valueOf(lstApp[0].genesis__Term__c/12);
                   //term = term.left(1);
               }
               
                   string str3 = lstSection[1].pepSectionBodyRich__c;
                   string str4 = str3.replace('${!genesis__Applications__c.Debit_amount__c}', roundedwithdollar);
                   str4 = str4 .replace('{!genesis__Applications__c.Debit_Frequency__c}', lstApp[0].Debit_Frequency__c);
                   System.debug('TERM*****'+term);
                   str4 = str4 .replace('{!genesis__Applications__c.Requested_Term__c}', term);
                 
                   System.debug('str4*****'+str4);
                   
                   strSectionBody2 = str4 ;
           }
           
          
               
               
           
         
       }    
        
    }
    
    public pageReference RedirectToNegative()
    {
        system.debug('YesOrNo :'+ YesOrNo );
     
        PageReference ref;
           
         if(YesOrNo == 'no')
        {
              if(objApplication.Debit_Frequency__c == 'fortnightly')
               {    
                   objApplication.Debit_Frequency__c = 'BI-WEEKLY';
               }
              objApplication.pepNavigation_Status__c = pepUtilityClass.getNavigationPageName('pepServiceabilityNegative2');  
              Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
              Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
              objApplication = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
              string redircetPageName= pages_config__c.getinstance('pepserviceabilitynegative2').Page_Label__c;
              ref = new Pagereference('/'+redircetPageName); 
              ref.setRedirect(true);
        
        }
        
      if(YesOrNo == 'yes')
       {
              
          if(objApplication!= null && objApplication.id !=null)
          {
             
               if(objApplication.Debit_Frequency__c == 'fortnightly')
               {    
                   objApplication.Debit_Frequency__c = 'BI-WEEKLY';
               }
                    Account objAccount = [Select id,PersonEmail,PersonContactId,phone,PersonMobilePhone from Account where id=: objApplication.genesis__Account__c limit 1];
                    String PIN = String.valueOf(system.now().getTime()).substring(String.valueOf(system.now().getTime()).length() - 6);
                    system.debug('Account::'+objAccount );
                    system.debug('PIN::'+PIN + 'Email:: '+objAccount.PersonEmail);
                       
                        if(objAccount.PersonEmail != null)
                        {
                                if(PIN != '')
                                {
                                    objAccount.OTP__c = PIN;
                                    objAccount.PepOTP__c = PIN;
                                    objAccount.Retrieval_Code__c = objApplication.Ret_Code__c;
                                    update objAccount;
                                    system.debug('Account:: '+objAccount);
                                    objApplication.pepNavigation_Status__c = pepUtilityClass.getNavigationPageName('pepOTP');
                                    Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                                    Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
                                    objApplication = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
                               }
                                
                                 string redircetPageName= pages_config__c.getinstance('pepotp').Page_Label__c;
                                 ref=new Pagereference('/'+redircetPageName); 
                                 ref.setRedirect(true);
                        }  
              
          
                }
             
        }
        
        return ref;
    }
    
    
    
 Public Pagereference checkcookie(){
     Pagereference pr=Peputilityclass.checkCookieAndRedirect();
    if(pr == null){
     Pagereference temp = Peputilityclass.HandleRedirectSecurity();
     return temp;
    }
    else{
    return pr;
    }
}
}