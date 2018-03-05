// ------------------------------------------------------------------------------------------------
// This class acts as a controller to the pepchangeProfile page
// ------------------------------------------------------------------------------------------------
// Created Date: 5-may-2016 Created By: AMIT KUMAR Email: amit.kumar@saasfocus.com

public class pepchangeProfileController
{
    public list<wrapperQuestion> lstWrapperQuestionSection1 {get; set;}
    public list<wrapperQuestion> lstWrapperQuestionSection2 {get; set;}
    public list<wrapperQuestion> lstWrapperQuestionSection3 {get; set;}
    public list<wrapperQuestion> lstWrapperQuestionPwdSection {get; set;}
    public list<wrapperQuestion> lstWrapperQuestionEditPwdSection {get; set;}
    public Account objAccount;
    public Residential_Address__c objResAddress;
    public boolean isSection1Changed{get;set;}
    public boolean isSection2Changed{get;set;}
    public boolean isSection3Changed{get;set;}
    public boolean isPwdSectionChanged{get;set;}
   // public List<loan__Loan_Account__c> lstloanAccount{get;set;}
    public List<pepUtilityClass.contractWrapper> sideBarList;
    private  map<id, pepCmsQuestion__c> mapAllQuestions;
    private String changedSectionNo ;
    public User objUser;
    public boolean isPwdError{get;set;}
    public set<String> setCommunicationsType;
    public set<String> setMarketingCommunicationType;
    public String t{get;set;}
    public String strPwdErrorMsg{get;set;}
    public boolean showCommunicationTypeError {get;set;}
    public String Page_Name{get;set;}
    public String Page_Label{get;set;}
    public Boolean checkUserId{get;set;}
    public Boolean checkDupAcc{get;set;}
    public String externalId;
    public Account objAccountNew;
    public Id idAccount;
    //Constructor
    public pepchangeProfileController()
    {
        page_Name = 'pepchangeProfile';
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
        changedSectionNo = '';
        checkUserId =  false;
        t ='$20000';
        externalId ='';
        lstWrapperQuestionSection1  = new List<wrapperQuestion>();
        lstWrapperQuestionSection2  = new List<wrapperQuestion>();
        lstWrapperQuestionSection3  = new List<wrapperQuestion>();
        lstWrapperQuestionPwdSection= new List<wrapperQuestion>();
        sideBarList = new List<pepUtilityClass.contractWrapper>();
        lstWrapperQuestionEditPwdSection = new List<wrapperQuestion>();
        setCommunicationsType         = new set<String>();
        setMarketingCommunicationType = new set<String>();
        objAccount = new Account(); 
        objResAddress = new Residential_Address__c ();      
       // objUser = [select id,userName from User where id =:UserInfo.getUserId()];
        mapAllQuestions = fetchPageQuestions('Dashboard(My Profile)');
        fetchAccount();
        fetchContract(objAccount.id);
        loadCMSDataForSection1();
        loadCMSDataForSection2();
        loadCMSDataForSection3();
        loadCMSDataForPwdSection();
        loadCMSDataForEditPwdSection();
    }
    
    
    
    
    public void fetchAccount()
    {
        idAccount = pepUtilityClass.getAccountId();
        System.debug('idAccount******'+idAccount );    
        
        objAccount =[select id,firstName,personEmail,PersonBirthdate,pafss_Duplication_Check_Key__c,Name,pafss_PAF_Mailing_Address__c,collect__External_ID__c,Communication_Type__c ,Marketing_Communication__c,PersonMobilePhone,PersonOtherPhone,PersonHomePhone,lastname ,(select id,Address__c from Residential_Address__r where Current_Address__c = true)  from Account where id=:idAccount];
        if(objAccount.Residential_Address__r != null && objAccount.Residential_Address__r.size() > 0)
        {
            objResAddress = objAccount.Residential_Address__r[0];
        }
        if(string.isNotBlank(objAccount.collect__External_ID__c))
           externalId = objAccount.collect__External_ID__c;   // fetch external id of PAF Account
        System.debug('objAccount**amit'+objAccount);
    }
    public void fetchContract(Id idAccount)
    {
    
        pepUtilityClass.contractWrapper objWrapper = new pepUtilityClass.contractWrapper();
        sideBarList = objWrapper.getContract(idAccount);
       
    }
    
    
     public void loadCMSDataForSection1()
    {
    
         List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                                    pepSectionUniqueName__c, pepType__c, 
                                                    pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                                    (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , 
                                                    pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                                    from pepCmsSection__c                                                   
                                                    where pepSectionUniqueName__c='MyprofileSection1'
                                                    and pepPage__r.pepPageName__c='Dashboard(My Profile)'];
        objUser = [select id,userName from User where id =:UserInfo.getUserId()];
        
        if(lstSections != null && lstSections.size() > 0)
        {
            
             if(lstSections[0].pepQuestion__r != null && lstSections[0].pepQuestion__r.size() > 0)
             {
                for(pepCmsQuestion__c objMasterQuestion : lstSections[0].pepQuestion__r)

                {
                    String val ='';
                    if(objMasterQuestion.pepFieldApiName__c != null && objMasterQuestion.pepSObjectApiName__c =='User')
                    {
                        val = (String)objUser.get(objMasterQuestion.pepFieldApiName__c);
                    }
                    wrapperQuestion objWrapperQuestion = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAccount,val);
                    objWrapperQuestion.objAccount = objAccount;
                    if(objMasterQuestion.pepSObjectApiName__c == 'loan__Loan_Account__c')
                    {
                        system.debug('sideBarListIs'+sideBarList);
                        if(sideBarList != null && sideBarList.size()> 0 )
                        {
                            for(pepUtilityClass.contractWrapper  objLoanAccount :sideBarList)
                            {
                                wrapperLoanAccount objWrapperLoanAccount = new wrapperLoanAccount();
                                objWrapperLoanAccount.strLoanName =objLoanAccount.loanName;
                                objWrapperLoanAccount.strLoanNumber=objLoanAccount.loanNumber;
                                objWrapperQuestion.lstwrapperLoanAccount.add(objWrapperLoanAccount);
                            }
                        
                        }
                        
                      //  objWrapperQuestion.lstLoanAccount = lstLoanAccount;
                        
                    }
                    lstWrapperQuestionSection1.add(objWrapperQuestion);                
                }
             
             }
        
        
        }                                            
                                                    
    
    
    }
    
    
    public void loadCMSDataForSection2()
    {
        System.debug('method called');
        fetchAccount();
    
         List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                                    pepSectionUniqueName__c, pepType__c, 
                                                    pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                                    (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , 
                                                    pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                                    from pepCmsSection__c                                                   
                                                    where pepSectionUniqueName__c='MyprofileSection2'
                                                    and pepPage__r.pepPageName__c='Dashboard(My Profile)'];
        
        if(lstSections != null && lstSections.size() > 0)
        {
            
             if(lstSections[0].pepQuestion__r != null && lstSections[0].pepQuestion__r.size() > 0)
             {
                for(pepCmsQuestion__c objMasterQuestion : lstSections[0].pepQuestion__r)

                {
                  if(objMasterQuestion .pepSObjectApiName__c == 'Account')
                  {
                    wrapperQuestion objWrapperQuestion = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAccount,(String)objAccount.get(objMasterQuestion.pepFieldApiName__c));
                    objWrapperQuestion.objAccount = objAccount;
                    lstWrapperQuestionSection2.add(objWrapperQuestion);
                  } 
         // get residential address for PL Account        
                  if(objMasterQuestion.pepSObjectApiName__c == 'Residential_Address__c' && String.isBlank(objAccount.collect__External_ID__c))
                  {
                    wrapperQuestion objWrapperQuestion = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAccount,(String)objResAddress.get(objMasterQuestion.pepFieldApiName__c));
                    objWrapperQuestion.objAccount = objAccount;
                    lstWrapperQuestionSection2.add(objWrapperQuestion);
                  } 
                  
          // get mailing address for PAF Account       
                  if(objMasterQuestion.pepSObjectApiName__c == 'Residential_Address__c' && String.isNotBlank(objAccount.collect__External_ID__c))
                  { 
                    string strPAFAddress = objAccount.pafss_PAF_Mailing_Address__c;
                    system.debug('cityIs'+strPAFAddress);
                    wrapperQuestion objWrapperQuestion = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAccount,strPAFAddress);
                    objWrapperQuestion.objAccount = objAccount;
                    lstWrapperQuestionSection2.add(objWrapperQuestion);
                  } 
                                
                }
             
             }
        
        
        }                                            
                                                    
    
    
    }
    
    
    //This method get calls when we change any section 
    public void editSection()
    {
       
        String param =  ApexPages.currentPage().getParameters().get('sectionNo');
        System.debug('param***************'+param);
        if(param =='1')
        {
           isSection1Changed = true; 
           checkUserId = false;
        }
        if(param =='2')
        {
           isSection2Changed = true; 
        
        }
        if(param =='3')
        {
           isSection3Changed = true; 
           
        
        }
        if(param =='4')
        {
           isPwdSectionChanged = true; 
           strPwdErrorMsg ='';
        
        }
        
        
        
        
       
    }
    
     //This method get calls when we change any section 
    public void cancelSection()
    {
        String param =  ApexPages.currentPage().getParameters().get('sectionNo');
        System.debug('param***************'+param);
        if(param =='1')
        {
           isSection1Changed = false; 
           lstWrapperQuestionSection1.clear(); 
           loadCMSDataForSection1();
        
        }
        if(param =='2')
        {
           isSection2Changed = false;
           lstWrapperQuestionSection2.clear(); 
           System.debug('in 2');
           loadCMSDataForSection2();
        
        }
        if(param =='3')
        {
           lstWrapperQuestionSection3 .clear();
           loadCMSDataForSection3();
           isSection3Changed = false; 
           showCommunicationTypeError =false;
           
        
        }
        if(param =='4')
        {
           isPwdSectionChanged = false; 
           strPwdErrorMsg ='';
        
        }
        
        
       
    }
   
   public void loadCMSDataForPwdSection()
   {
        
    
         List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                                    pepSectionUniqueName__c, pepType__c, 
                                                    pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                                    (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , 
                                                    pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                                    from pepCmsSection__c                                                   
                                                    where pepSectionUniqueName__c='MyProfilePwdSection'
                                                    and pepPage__r.pepPageName__c='Dashboard(My Profile)'];
        
        if(lstSections != null && lstSections.size() > 0)
        {
            
             if(lstSections[0].pepQuestion__r != null && lstSections[0].pepQuestion__r.size() > 0)
             {
                for(pepCmsQuestion__c objMasterQuestion : lstSections[0].pepQuestion__r)

                {
                    wrapperQuestion objWrapperQuestion = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAccount,'');                    
                    lstWrapperQuestionPwdSection.add(objWrapperQuestion);                
                }
             
             }
        
        
        }                                            
                                                    
    
    
    } 
   
   public void loadCMSDataForEditPwdSection()
   {
        
    
         List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                                    pepSectionUniqueName__c, pepType__c, 
                                                    pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                                    (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , 
                                                    pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                                    from pepCmsSection__c                                                   
                                                    where pepSectionUniqueName__c='MyProfilePwdEditSection'
                                                    and pepPage__r.pepPageName__c='Dashboard(My Profile)'];
      
        
        if(lstSections != null && lstSections.size() > 0)
        {
            
             if(lstSections[0].pepQuestion__r != null && lstSections[0].pepQuestion__r.size() > 0)
             {
                for(pepCmsQuestion__c objMasterQuestion : lstSections[0].pepQuestion__r)

                {
                    wrapperQuestion objWrapperQuestion = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAccount,'');                    
                    lstWrapperQuestionEditPwdSection.add(objWrapperQuestion);                
                }
             
             }
        
        
        }                                            
                                                    
    
    
    }
    
    public void loadCMSDataForSection3()
    {
        
        fetchAccount();
        List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                                pepSectionUniqueName__c, pepType__c, 
                                                pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                                (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepGoogleApi__c,pepType__c , 
                                                pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                                from pepCmsSection__c                                                   
                                                where pepSectionUniqueName__c='MyprofileSection3'
                                                and pepPage__r.pepPageName__c='Dashboard(My Profile)'];
                                                
        List<String> lstCommunicationsType = new List<String>();
        List<String> lstmarketingCommunicationsType = new List<String>();
        if(objAccount.Communication_Type__c != null && objAccount.Communication_Type__c.contains(';'))
        {                                             
            lstCommunicationsType = objAccount.Communication_Type__c.split(';');
        }
        
        else if(objAccount.Communication_Type__c != null)
        {
            lstCommunicationsType.add(objAccount.Communication_Type__c);
        }
        
        else
        {
            Schema.DescribeFieldResult fieldResult = Account.Communication_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
           
              lstCommunicationsType.add(f.getValue());
            } 
        }
        
        
        if(objAccount.Marketing_Communication__c != null && objAccount.Marketing_Communication__c.contains(';'))
        {                                             
            lstmarketingCommunicationsType = objAccount.Marketing_Communication__c.split(';');
        }
        
        else if(objAccount.Marketing_Communication__c != null)
        {
            lstmarketingCommunicationsType.add(objAccount.Marketing_Communication__c);
        }
        
        system.debug('lstCommunicationsTypes**********'+lstCommunicationsType);
        setCommunicationsType.addAll(lstCommunicationsType);
        setMarketingCommunicationType.addAll(lstmarketingCommunicationsType);
       
        if(lstSections != null && lstSections.size() > 0)
        {
            
             if(lstSections[0].pepQuestion__r != null && lstSections[0].pepQuestion__r.size() > 0)
             {
                for(pepCmsQuestion__c objMasterQuestion : lstSections[0].pepQuestion__r)

                {
                    wrapperQuestion objWrapperQuestion = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAccount,'');
                    objWrapperQuestion.objAccount = objAccount;
                    lstWrapperQuestionSection3.add(objWrapperQuestion);                
                }
             
             }
        
        
        }                                            
                                                    
    
    
    }
    
     //This method saves 2nd section data
    public pagereference saveSection2Data()
    {
      // added by Rishabh (for PAF)
       
       String checkDuplicateAccount; 
       String inputMobile;
       String inputEmail;
       String dob;
       String firstName;
       checkDupAcc = false;
       Account accountObject =[select id,personEmail,PersonMobilePhone from Account where id=:idAccount];

       if(objAccount.PersonBirthdate!=null)
        dob = string.valueOf(objAccount.PersonBirthdate).split(' ')[0];  // remove time from dob
       if(objAccount.firstName!=null)
        firstName = (objAccount.firstName).trim().toLowerCase();          // hold first name
       
        for(wrapperQuestion  objQuestion : lstWrapperQuestionSection2)    // iterate over wrapper to get the values of email and mobile entered by user. 
        {
               if(objQuestion.objCmsQuestion.pepSObjectApiName__c == 'Account')
               {
                     if(objQuestion.objCmsQuestion.pepFieldApiName__c =='PersonMobilePhone')
                     {
                       inputMobile = objQuestion.objInputValue;                        // fetch mobile phone
                     }
                     if(objQuestion.objCmsQuestion.pepFieldApiName__c =='personEmail')
                     {  
                       inputEmail = (objQuestion.objInputValue).trim().toLowerCase();    // fetch email
                     }
              }  
        }
     // create string contains all five parameters(firstname,lastname,dob,email,moblieno)
     checkDuplicateAccount =  firstName+':'+objAccount.lastName.trim().toLowerCase()+':'+inputMobile+':'+inputEmail+':'+dob;
     list<account>accDupList = new list<account>();
    // fetch accounts contains same five values(firstname,lastname,dob,email,moblieno) as loggedin user account.
   if(inputMobile!=accountObject.personMobilePhone || inputEmail !=accountObject.personEmail)
      accDupList = [select id from account where id!=:objAccount.id and pafss_Duplication_Check_Key__c=:checkDuplicateAccount and Is_Portal_User_Created__c = true];
   system.debug('accountObject.personMobilePhoneIS'+accountObject.personMobilePhone);
   system.debug('accountObject.personEmailIS'+accountObject.personEmail);
   system.debug('accDupListIS'+accDupList);
   system.debug('inputMobileIS'+inputMobile);
   system.debug('inputEmailIS'+inputEmail);
     if(accDupList.size()>0) // if account exist then make a boolean variable true to show validation error on page
     {
        system.debug('aaya');
        checkDupAcc = true;
        return null;
     }
     
   // End here
     
     system.debug('dupKeyIs'+checkDuplicateAccount);
     system.debug('dupKeyIs1'+objAccount.pafss_Duplication_Check_Key__c);
        List<Account> lstAccount = new List<Account>();
        objAccountNew = new Account(id= lstWrapperQuestionSection2[0].objAccount.id);
       // objAccount = lstWrapperQuestionSection2[0].objAccount;
        Residential_Address__c objResAddress = new Residential_Address__c ();
        if(lstWrapperQuestionSection2[0].objAccount.Residential_Address__r != null
             && lstWrapperQuestionSection2[0].objAccount.Residential_Address__r.size() > 0)
        {
            objResAddress = lstWrapperQuestionSection2[0].objAccount.Residential_Address__r[0];
        }
        
        for(wrapperQuestion  objQuestion : lstWrapperQuestionSection2)
        {
           
           System.debug(objQuestion.objInputValue);
           System.debug('objQuestion.strGAPIAddress****'+objQuestion.strGAPIAddress);
           System.debug(objQuestion.objCmsQuestion.pepSObjectApiName__c);
           
           if(objQuestion.strGAPIAddress!=null && objQuestion.strGAPIAddress!='')
           {
              objResAddress  = saveGooGleApiAddress(objQuestion.strGAPIAddress,objResAddress);
           }
           
          if(objQuestion.objCmsQuestion.pepSObjectApiName__c == 'Account')
           {
             if(objQuestion.objCmsQuestion.pepFieldApiName__c =='Name')
             {
                 continue;
             }
              objAccountNew.put(objQuestion.objCmsQuestion.pepFieldApiName__c ,objQuestion.objInputValue);    
              
        
           }
           
           if(objQuestion.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c' && (String.isBlank(externalId) || String.isnotBlank(externalId)))
           {
                objResAddress.put(objQuestion.objCmsQuestion.pepFieldApiName__c ,objQuestion.objInputValue);    
           }
           
           /*if(objQuestion.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c' && String.isnotBlank(externalId))
           {
              System.debug('personmailingcity****'+objQuestion.objInputValue);
              objQuestion.strGAPIAddress = objQuestion.objInputValue;
              objResAddress  = saveGooGleApiAddress(objQuestion.strGAPIAddress,objResAddress);
              //objAccount.personmailingcity= objQuestion.objInputValue;
           }*/   
    
        }
        lstAccount.add(objAccountNew);
        System.debug('objAccountNew****'+objAccountNew);
        if(lstAccount.size() > 0)
        {
            update lstAccount;
        }
        if(objResAddress.Id != null)
        {
            update objResAddress;
        }
        
        
        User objUser = new User();
        objUser.id = this.objuser.id;
        objuser.firstname = objAccountNew.firstname;
        update objUser;
        System.debug('amit*****************');
        isSection2Changed = false;
        return null;
     }
     
     //This method save address using Google API
     public Residential_Address__c  saveGooGleApiAddress(String strGAPIAddress,Residential_Address__c objResAddress)
     {
        system.debug('strGAPIAddressIS'+strGAPIAddress);
        List<string> str1 = new List<string>();
        str1 = strGAPIAddress.split(',');
        Integer intAddressLength = str1.size();
        system.debug('addressIS'+intAddressLength);
         system.debug('externalIdIS'+objAccount.collect__External_ID__c);
        // put address in residential address object if loggedin user has account of PL 
        if(String.isBlank(objAccount.collect__External_ID__c))
        {
                    while(intAddressLength >0)
                    {
                        //Post code 
                        if(str1.size() == intAddressLength)
                        {
                            objResAddress.PostCode__c = '';
                            objResAddress.PostCode__c =  str1[intAddressLength-1];    
                        }//Country
                        else if(str1.size() == intAddressLength+1)
                        {
                            objResAddress.Country__c = '';
                            objResAddress.Country__c =  str1[intAddressLength-1]; 
                        }//State
                        else if(str1.size() == intAddressLength+2)
                        {
                            objResAddress.State__c= '';
                            objResAddress.State__c=  str1[intAddressLength-1]; 
                        }//Suburb
                        else if(str1.size() == intAddressLength+3)
                        {
                            objResAddress.Suburb__c = '';
                            objResAddress.Suburb__c =  str1[intAddressLength-1]; 
                        }//Street Name
                        else if(str1.size() == intAddressLength+4)
                        {
                            objResAddress.Street_Name__c = '';
                            objResAddress.Street_Name__c =  str1[intAddressLength-1]; 
                        }//Street Number
                        else if(str1.size() == intAddressLength+5)
                        {
                            objResAddress.Street_Number__c = '';
                            objResAddress.Street_Number__c =  str1[intAddressLength-1];
                            if(intAddressLength == 2)
                            {
                                 objResAddress.Street_Number__c =  str1[intAddressLength-2];
                                 objResAddress.Street_Number__c += '/' + str1[intAddressLength-1]; 
                            }
                        }
                        intAddressLength --;
                    }
           }         
      //  System.debug('objResAddress******'+objResAddress);
       // put address in mailing address field in account if loggedin user has account of PAF
           
           else if(String.isNotBlank(objAccount.collect__External_ID__c))
            {
                   
                         objAccountNew.personmailingpostalcode = '';
                        objAccountNew.personmailingcountry = '';
                        objAccountNew.personmailingstate = '';
                        objAccountNew.personmailingcity = '';
                        objAccountNew.personmailingstreet = '';
                    while(intAddressLength >0)
                    {
                        
                        //Post code 
                        if(str1.size() == intAddressLength)
                        {
                            
                            objAccountNew.personmailingpostalcode =  str1[intAddressLength-1];    
                        }//Country
                        else if(str1.size() == intAddressLength+1)
                        {
                            
                            objAccountNew.personmailingcountry =  str1[intAddressLength-1]; 
                        }//State
                        else if(str1.size() == intAddressLength+2)
                        {
                            
                            objAccountNew.personmailingstate =  str1[intAddressLength-1]; 
                        }//Suburb
                        else if(str1.size() == intAddressLength+3)
                        {
                            
                            objAccountNew.personmailingcity =  str1[intAddressLength-1]; 
                        }//Street Name
                        else if(str1.size() == intAddressLength+4)
                        {
                            
                            objAccountNew.personmailingstreet  =  str1[intAddressLength-1]; 
                        }//Street Number
                       /* else if(str1.size() == intAddressLength+5)
                        {
                            objAccount.Street_Number__c = '';
                            objAccount.Street_Number__c =  str1[intAddressLength-1];
                            if(intAddressLength == 2)
                            {
                                 objAccount.Street_Number__c =  str1[intAddressLength-2];
                                 objAccount.Street_Number__c += '/' + str1[intAddressLength-1]; 
                            }
                        }*/
                        intAddressLength --;
                    }
                    
           }     
        return objResAddress;
     }
     
     //This method makes set of communication method selected
     
     public void selectedCommuncationType()
     {
         
        String strval = Apexpages.currentpage().getparameters().get('strVal'); 
        System.debug('setCommunicationsType*****'+setCommunicationsType);
        System.debug('strVal*****'+strVal);
        String strChecked = Apexpages.currentpage().getparameters().get('strChecked');
        System.debug('strChecked*****'+strChecked);
        if(strval =='Email' || strval =='SMS')
        {        
            if(setCommunicationsType.contains(strval) && strChecked =='false' )
            {
                setCommunicationsType.remove(strval);
            }
            else
            {
                if(strChecked == 'true')
                {
                    setCommunicationsType.add(strval);
                }
            }
            
            System.debug('*********comm'+setCommunicationsType);
        }
        else
        {        
        
            if(setMarketingCommunicationType.contains(strval))
            {
                setMarketingCommunicationType.remove(strval);
            }
            else
            {
                setMarketingCommunicationType.add(strval);
            }
        }
     
     }
     
     //This method saves 3rd section data
     public pageReference savesection3Data()
     {
        System.debug('in Method save 3'); 
        showCommunicationTypeError  = false;
        List<Account> lstAccount = new List<Account>();
        Account objAccount = new Account(id = lstWrapperQuestionSection2[0].objAccount.id);        
        String strCommuncationTypeVal ='';
        String strmarketingCommunicationVal ='';
        if(setCommunicationsType.size() > 0)
        {
            for(String str : setCommunicationsType)
            {
                strCommuncationTypeVal += str+';';
            
            }
            strCommuncationTypeVal = strCommuncationTypeVal.removeEnd(';');
            
        }  
        else
        {
            showCommunicationTypeError = true;
            return null;
        }
        
        if(setMarketingCommunicationType.size() > 0)
        {
            for(String str : setMarketingCommunicationType)
            {
                strmarketingCommunicationVal += str+';';
            
            }
            strmarketingCommunicationVal = strmarketingCommunicationVal.removeEnd(';');
            
        }
            
        for(wrapperQuestion  objQuestion : lstWrapperQuestionSection3)
        {
           
           System.debug(objQuestion.objInputValue);
           System.debug(objQuestion.objCmsQuestion.pepSObjectApiName__c);
           if(objQuestion.objCmsQuestion.pepSObjectApiName__c == 'Account'
                && objQuestion.objCmsQuestion.pepFieldApiName__c =='Communication_Type__c')
           {
              objAccount.put(objQuestion.objCmsQuestion.pepFieldApiName__c ,strCommuncationTypeVal);                   
        
           }
           
           else if(objQuestion.objCmsQuestion.pepSObjectApiName__c == 'Account'
                && objQuestion.objCmsQuestion.pepFieldApiName__c =='Marketing_Communication__c')
           {
              objAccount.put(objQuestion.objCmsQuestion.pepFieldApiName__c ,strmarketingCommunicationVal);                   
        
           }
           
           else
           {
               objAccount.put(objQuestion.objCmsQuestion.pepFieldApiName__c ,objQuestion.objInputValue);                   
           }
        }
        lstAccount.add(objAccount); 
        if(lstAccount.size() > 0)
        {
            update lstAccount;
        
        }
     
     
     isSection3Changed = false;
      return null;
     
     }
     
    //This method saves first section data
    public void saveSection1Data()
    {
        List<User> lstUser = new List<User>();
        User objUser = new User();
        objUser.id = this.objuser.id;
        
        for(wrapperQuestion  objQuestion : lstWrapperQuestionSection1)
        {
           
           System.debug(objQuestion.objInputValue);
           System.debug(objQuestion.objCmsQuestion.pepSObjectApiName__c);
           if(objQuestion.objCmsQuestion.pepSObjectApiName__c == 'User')
           {
              objUser.put(objQuestion.objCmsQuestion.pepFieldApiName__c ,objQuestion.objInputValue);    
           }
    
        }
        lstUser.add(objUser);
        System.debug('lstUser****'+lstUser);
        try{
                if(lstUser.size() > 0)
                {
                    update lstUser;
                     isSection1Changed = false;
                }
          } 
          
          catch (Exception  e)
                {
                   checkUserId = true;
                }
       
     }
     
   //This method updates user password
   
    public void saveSectionPwdData()
    {
       
       String strNewPassword ='';
       String strConfirmPassword='';
       String strCurrentPassword='';
       strPwdErrorMsg = '';
       isPwdError = false;
       
       for(wrapperQuestion objquestion : lstWrapperQuestionEditPwdSection)
       {
           if(objQuestion.objCmsQuestion.pepFieldApiName__c =='Current Password')
           {
               strCurrentPassword = objquestion.objInputValue;
           }
           
           if(objQuestion.objCmsQuestion.pepFieldApiName__c =='New Password')
           {
               strNewPassword  = objquestion.objInputValue;
           }
           
           if(objQuestion.objCmsQuestion.pepFieldApiName__c =='Confirm Password')
           {
               strConfirmPassword = objquestion.objInputValue;
           }
       
       
       }
       
      
       
       if(strNewPassword !='' && strCurrentPassword !='')
       {
           
           pageReference p = site.changePassword(strNewPassword  ,strNewPassword ,strCurrentPassword );
           System.debug('pageReferecne**************'+p);
           if(p == null)
           {
               isPwdError = true;
               strPwdErrorMsg ='Your old password is incorrect';
               
           }
           
           else
           {
              isPwdError = false; 
              isPwdSectionChanged = false;
              
           }
       
       }
     
        
         
     }
     
     
     
     
     
        
    
    //Wrapper class
    
    public class wrapperQuestion
    {
        public pepCmsQuestion__c objCmsQuestion {get; set;} //main question      
        public List<wrapperAnswer> lstExpectedAnsers {get; set;}//answer of question
        public List<wrapperQuestion> lstSiblingQuestion {get; set;} //siblingquestion
        public Account objAccount{get;set;}
      //  public List<loan__Loan_Account__c> lstloanAccount{get;set;}
        public List<String> lstLoanContractName;
        public String strGAPIAddress{get;set;}
        public List<wrapperLoanAccount> lstwrapperLoanAccount{get;set;}    
        public String objInputValue
        {
           get { return objInputValue; }
           
           set {
                if(objCmsQuestion.pepType__c =='Currency')
                {
                    if(value != null)
                    {
                     objInputValue = value.replace(',','');
                    }
                    else
                    {
                       
                       objInputValue  = value;
                        
                    }
                }
                else
                {
                    objInputValue =value;
                }
                
             }
        }
        
        
        
        public list<selectOption> lstOptions {get; set;}
       
        public wrapperQuestion(){}
        public wrapperQuestion(pepCmsQuestion__c objQuestion,Account objAccounts, string InputAnswers)
        {
            objCmsQuestion = objQuestion;
           // lstloanAccount = new List<loan__Loan_Account__c>();
            objAccount = objAccounts;
                      
            lstExpectedAnsers = new List<wrapperAnswer>();
            lstSiblingQuestion = new List<wrapperQuestion>();            
            lstOptions = new list<selectOption>();            
            objInputValue = InputAnswers;
            lstwrapperLoanAccount = new List<wrapperLoanAccount>();
            system.debug('In wrapper :: '+objInputValue );
            
            if(objQuestion != null && objQuestion.pepCmsAnswer__r!=null && objQuestion.pepCmsAnswer__r.size()>0)
            {
                for(pepCmsAnswer__c objAnswer : objQuestion.pepCmsAnswer__r)
                {
                    wrapperAnswer objAns = new WrapperAnswer(objAnswer);
                    if(objAccount != null && ( ( objAccount.Communication_Type__c != null 
                        && objAccount.Communication_Type__c.contains(objAnswer.pepDisplayText__c)) ))
                    {
                        objAns.isCommunicationTypeExists =  true;
                    } 
                    else if(objAccount != null &&  ( objAccount.Communication_Type__c == null ) && objQuestion.pepFieldApiName__c =='Communication_Type__c')
                        
                    {
                        objAns.isCommunicationTypeExists =  true;
                    }
                    
                    if(objAccount.Marketing_Communication__c != null 
                        && objAccount.Marketing_Communication__c.contains(objAnswer.pepDisplayText__c))  
                    {
                             objAns.isCommunicationTypeExists =  true;
                    } 
                    lstExpectedAnsers.add(objAns);                   
                    if(objAnswer.pepDisplayText__c == objInputValue)
                    {
                         System.debug('objAnswer.pepDisplayText__c *** '+objAnswer.pepDisplayText__c);
                         System.debug('objAnswer.pepDisplayText__c *** '+objInputValue);
                        if(lstOptions != null && lstOptions.size() > 0)
                        {                        
                         lstOptions.add(new selectOption(objAnswer.Id, objAnswer.pepDisplayText__c));                      
                        }
                       
                    } 
                    
                             
                    
                   
                }
            }
            
           
     }
        
    }
    public class wrapperLoanAccount
    {
        public String strloanName{get;set;}
        public String strloanNumber{get;set;}
    
    }
    
    
    public class wrapperAnswer
    {
        public pepCmsAnswer__c objCmsAnswer {get; set;}
        public list<wrapperQuestion> lstChildQuestion {get; set;}
        public boolean isCommunicationTypeExists{get;set;}
        public wrapperAnswer(){}
        public wrapperAnswer(pepCmsAnswer__c objAns)
        {
            lstChildQuestion = new list<wrapperQuestion>();
            objCmsAnswer = objAns;           
           
        }
    }


    //This method fetches asll questions of a specific page
    public map<id,pepCmsQuestion__c> fetchPageQuestions(String strPageName)
    {
       map<id,pepCmsQuestion__c>  mapAllQuestions = new map<id,pepCmsQuestion__c>();
    
       mapAllQuestions = new map<id,pepCmsQuestion__c>( [SELECT  pepSection__c,pepGoogleApi__c,pepRecordSequence__c,pepSection__r.Name ,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                                    pepIsRequired__c, pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                                    pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, Id, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,
                                                                    (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                                            FROM pepCmsAnswer__r order by pepSequence__c ASC ), 
                                                                     (SELECT  pepSection__c,pepRecordSequence__c,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c ,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                                                              pepLabelPriorQuestion__c,pepGoogleApi__c ,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepRelatedCSS__c
                                                                            FROM CmsQuestion__r
                                                                            ORDER BY pepSequence__c ASC) 
                                                                    FROM pepCmsQuestion__c where pepPage__r.pepPageName__c =:strPageName
                                                                    ORDER BY pepSequence__c ASC]);



        return mapAllQuestions;
       }



}