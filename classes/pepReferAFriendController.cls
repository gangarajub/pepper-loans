public without sharing class pepReferAFriendController{
public list<wrapperQuestion> lstWrapperQuestionSection2 {get; set;}
public genesis__Applications__c application {get; set;}
public Id idApplication;
public pepCmsSection__c sections1 {get; set;}
public boolean isError{get;set;} 
@TestVisible private string email='';
@TestVisible private string phone='';
@TestVisible private string friendName;
@TestVisible private string referredName;
@TestVisible private string referralCode;
@TestVisible private List<Account> referredByAcc;
@TestVisible String idAccount;
public String idLoanAccount{get;set;}
public List<loan__Loan_Account__c> lstloancontract{get;set;}
public Integer Step{get;set;}
public String Page_Name{get;set;}
public String Page_Label{get;set;}
public list<pepUtilityClass.sideBarWrapper> sideBarList{get;set;}
public List<pepCmsSection__c> lstLeftSideBarSections{get;set;}
public String loanAccountId{get;set;}
Public Map<String,String> retUrlMap{get;set;}
Public String jsonretUrlMap{get{return JSON.serialize(retUrlMap);}set;}


  
public pepReferAFriendController()
{
    retUrlMap=new Map<String,String>();
    retUrlMap.put('pepwelcomepage',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepwelcomepage').Page_Label__c);
    retUrlMap.put('pepreferafriend',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepreferafriend').Page_Label__c);
    retUrlMap.put('pepcontactcentre',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepcontactcentre').Page_Label__c);
    retUrlMap.put('pepchangeprofile',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepchangeprofile').Page_Label__c);
    page_Name = 'pepReferAFriend';
    sideBarList = new list<pepUtilityClass.sideBarWrapper>();
    Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;   
    lstWrapperQuestionSection2 = new list<wrapperQuestion>();
    system.debug('UserInfo.getUserId()--'+UserInfo.getUserId());
    List<User> lstUser = [Select Id,AccountId from User where Id = : UserInfo.getUserId()];
    String pageName=ApexPages.currentPage().getUrl();
    pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
    Step=pageStepNumber(pageName);
    
        idAccount = pepUtilityClass.getAccountId();        
        lstloancontract = pepUtilityClass.getAllLoanContract(idAccount); 
        
        if(string.isNotBlank(idAccount))
          loanAccountId = pepUtilityClass.getLoanAccountId(idAccount); // To get the id of current contract.
          
    if(lstloancontract.size()>0) 
     {
           for (loan__Loan_Account__c objClContract: lstloancontract)
            {
                sideBarList.add(new pepUtilityClass.sideBarWrapper(objClContract.id,objClContract.Loan_Name__c));
            }
     }
    
    if(lstUser != null && lstUser.size() > 0 && lstUser[0].AccountId!=null )
    {
        System.debug('lstUser[0].AccountId::' + lstUser[0].AccountId);
        referredByAcc=[select id,Referral_Code__c,FirstName,LastName from account where id= :lstUser[0].AccountId];
        system.debug('list of acc  '+referredByAcc);
        referralCode= referredByAcc[0].Referral_Code__c;
        if(referredByAcc[0].FirstName!=null && referredByAcc[0].FirstName!='')
            referredName= referredByAcc[0].FirstName + ' ' +referredByAcc[0].LastName;
        else
            referredName= referredByAcc[0].LastName;
    }
    loadCMSDataForSection1();
    loadCMSDataForSection2();
}

    public void loadCMSDataForSection1()
    {  
      sections1 = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                                    pepSectionUniqueName__c, pepType__c, 
                                                    pepSectionStory__c ,pepSectionBodyRich__c,pepPage__r.pepPageName__c 
                                                    from pepCmsSection__c                                                   
                                                    where pepSectionUniqueName__c='ReferAFriendSection1'
                                                    and pepPage__r.pepPageName__c='Refer A Friend' limit 1];
                                                    
     lstLeftSideBarSections =[select id,pepHeader__c,pepCss_Class__c,pepRedirect_to_Page__c from pepCmsSection__c where Page_Name__c='DashboardSideBarTemplate' order by pepSequence__c asc];

     
    }

    public void loadCMSDataForSection2()
    {     
        
        List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                                    pepSectionUniqueName__c, pepType__c, 
                                                    pepSectionStory__c ,pepSectionBodyRich__c, pepPage__r.pepPageName__c ,(select  Id,Is_Date_to_Birth__c, pepSection__c,pepSection__r.Name ,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, pepRecordSequence__c,
                                                pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, 
                                                pepGoogleApi__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                                    from pepCmsSection__c                                                   
                                                    where pepSectionUniqueName__c='ReferAFriendSection2'
                                                    and pepPage__r.pepPageName__c='Refer A Friend'];
        
        System.debug('lstsections****'+lstSections);
        if(lstSections != null && lstSections.size() > 0)
        {
            if(lstSections[0].pepQuestion__r != null && lstSections[0].pepQuestion__r.size() > 0)
            {
                for(pepCmsQuestion__c objMasterQuestion : lstSections[0].pepQuestion__r)
                {
                    if(objMasterQuestion.pepSObjectApiName__c =='Account' && objMasterQuestion.pepFieldApiName__c =='Referral_Code__c')
                    {
                         if(referralCode!=null && referralCode!='') 
                         {
                             lstWrapperQuestionSection2.add(new wrapperQuestion(objMasterQuestion,null,referralCode));
                         }
                         else lstWrapperQuestionSection2.add(new wrapperQuestion(objMasterQuestion,null,null));
                    }
                    else
                    {
                        lstWrapperQuestionSection2.add(new wrapperQuestion(objMasterQuestion,null,null));
                    }
                }
            }
         }   
     
    }
    public pageReference referFriend()
    {
        for(wrapperQuestion quesWrap: lstWrapperQuestionSection2)
        {
            if(quesWrap.objCmsQuestion.pepType__c=='Text' && quesWrap.objCmsQuestion.pepFieldApiName__c == 'LastName')
            {
                
                friendName=quesWrap.objInputValue;
                
            }
            else if(quesWrap.objCmsQuestion.pepType__c== 'Email' && quesWrap.objInputValue !='')
            {
                email=quesWrap.objInputValue;
            }
            else if(quesWrap.objCmsQuestion.pepType__c=='Phone' && quesWrap.objInputValue !='')
            {
                phone=quesWrap.objInputValue;
            }
           
        }
        
        if(referredByAcc != null && referredByAcc.size()>0)
        {
            String firstName='';
            String lastName='';
            if(!Test.isRunningTest()){
            friendName=friendName.trim();
            if(friendName.contains(' '))
            {
                list<string> str=friendName.split(' ');
                for(Integer i=0;i<str.size();i++)
                {
                    if(i==0) firstName=str[0];
                    else lastName+=str[i]+' ';
                }
            }
            else
            {
                lastName=friendName;
            }
            }
            Contact newContact=new Contact();
            newContact.FirstName=firstName;
            newContact.LastName=lastName;
            newContact.Email=email;
            newContact.MobilePhone=phone;
            newContact.Referred_By_Code__c=referralCode;
            list<ReferralCodeTemplateId__c> tempId=ReferralCodeTemplateId__c.getall().values();
            String referralLink = tempId[0].Referral_link__c + '?Ref='+referralCode;
            newContact.Referral_Link__c=referralLink ;
            newContact.Is_Referred_Friend__c=true;
            if(!test.isRunningTest())
              insert newContact;
            system.debug('friend account++++'+newContact);
        }
        string redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;
        PageReference p = new pageReference('/'+redircetPageName);
       // PageReference p=new PageReference('/apex/pepWelcomepage');
        p.setRedirect(true);
        return p;
        }
    
    public pageReference cancel()
    {
        string redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;
        PageReference p = new pageReference('/'+redircetPageName);
        p.setRedirect(true);
        return p;
    }
    
    public class wrapperQuestion
    {
        public pepCmsQuestion__c objCmsQuestion {get; set;} //main question      
        public pepCmsAnswer__c objCmsAnswer {get; set;}//answer of question        
        public String objInputValue
        {
           get { return objInputValue; }
           set {
                objInputValue=value;                
             }
        }
        public wrapperQuestion(pepCmsQuestion__c objCmsQuestion,pepCmsAnswer__c objCmsAnswer,String objInputValue)
        {
                system.debug('****2 '+objInputValue);
            this.objCmsQuestion=objCmsQuestion;
            this.objCmsAnswer=objCmsAnswer;
            this.objInputValue=objInputValue;
        }
    }
    
    private Integer pageStepNumber(String pageName)
    {
        Integer intStep=0;
        if(pageName =='pepchangeProfile' )
        {
           
            intStep = -3;
        }
        
        if(pageName =='pepWelcomePage')
        {
            intStep = -1;
        }
        
        if(pageName =='pepReferAFriend')
        {
            intStep = -2;
        }
        
        if(pageName =='pepContactCentre')
        {
            intStep = -4;
        }
        
       
        if(pageName=='pepPaymentDetails' || pageName=='pepPaymentSetting')
        {
            intStep=1;
        }        
        else if(pageName =='pepTransactionHistory')
        {
            intStep =2;
        }
        
        else if(pageName =='pepmakeoneoffpayments')
        {
            intStep =3;
        }
        
        else if(pageName =='pepAdjustRepayments')
        {
            intStep =4;
        }
        
        else if(pageName =='pepChangePaymentsFrequency')
        {
            intStep =5;
        }
        
        else if(pageName =='pepPaymentHolidayDashBoard')
        {
            intStep =6;
        }
        
        else if(pageName =='peppayoutloanpage')
        {
            intStep =7;
        }
        
        
        
        return intStep;
    }
    public pageReference updateAccount()
    {
       // String idLoanAccount = Apexpages.currentPage().getParameters().get('loanContractid');
        System.debug('idLoanAccount ****** '+idLoanAccount);
        Account objAccount = new Account(id=idAccount);
        objAccount.Loan_Account_Id__c   =idLoanAccount;
        update  objAccount;
        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
        pageReference objPageRef = new pageReference('/'+redircetPageName);
        objPageRef.setRedirect(true);
        return objPageRef ;
    }
    
    public pageReference redirectToPage()
    {
       String pageName = Apexpages.currentPage().getParameters().get('pageNameValue');
       String redircetPageName= pages_config__c.getinstance(pageName).Page_Label__c;  
       Pagereference ref = new Pagereference('/'+redircetPageName); 
       Return ref.setRedirect(true);
    }
    
}