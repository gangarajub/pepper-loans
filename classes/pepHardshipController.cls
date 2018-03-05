public class pepHardshipController {
    
public string loanAccountId{get;set;}
public string strSectionStoryEmail {get;set;}
public String idLoanAccount{get;set;}
public string AccountId{get;set;}
Public List<Integer> templist{get;set;}
public Integer Step{get;set;}
public Attachment objAttachment{get;set;}
public String selectedtype{ get; set; }
public String selectedassistance{ get; set; }
public String selectedHardshipReason{ get; set; }
public String selectedBestTime{ get; set; }
public list<selectOption> lstassistanceOptions{get; set;}
public Boolean successMsg{get;set;}
public list<selectOption> lstTypeOptions{get; set;}
public list<selectOption> lstBestTimeOptions{get; set;}
public list<selectOption> lstHardshipReasonOptions{get; set;}
public list<pepCmsSection__c>lstSection;
public List<loan__Loan_Account__c> loanContractList;
public string strsectionstory{get;set;}
public string caseid{get;set;}
public case objCase{get;set;}
public boolean booltype{get;set;}
public boolean boolBestTime {get;set;}
public boolean boolHardshipReason{get;set;}
public boolean boolAssistance{get;set;}
public List<pepUtilityClass.contractWrapper> sideBarList{get;set;}
Public Case Case1{get;set;}
public list<Attachment>lstAttachment {get;set;}
public String Page_Name{get;set;}
public String Page_Label{get;set;}
Set<String> contractStatusSet ;
public List<pepCmsSection__c> lstLeftSideBarSections{get;set;}
Public Map<String,String> retUrlMap{get;set;}
Public String jsonretUrlMap{get{return JSON.serialize(retUrlMap);}set;}

public pepHardshipController ()
{
        retUrlMap=new Map<String,String>();
        retUrlMap.put('pepwelcomepage',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepwelcomepage').Page_Label__c);
        retUrlMap.put('pepreferafriend',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepreferafriend').Page_Label__c);
        retUrlMap.put('pepcontactcentre',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepcontactcentre').Page_Label__c);
        retUrlMap.put('pepchangeprofile',Url.getSalesforcebaseurl().toExternalForm()+'/'+pages_config__c.getinstance('pepchangeprofile').Page_Label__c);
    page_Name = 'pepHardship';
    contractStatusSet = New Set<String> ();
    Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
    AccountId = pepUtilityClass.getAccountId();
    Case1=new case();
    loanContractList= new List<loan__Loan_Account__c> ();
    templist=new List<Integer>();
    templist.add(0); 
    templist.add(1);    
    templist.add(2);    
    templist.add(3);    
    templist.add(4);       
    system.debug('accountid' +AccountId);
    successMsg = false;
    sideBarList = new List<pepUtilityClass.contractWrapper>();
    objAttachment = new Attachment(); 
    objCase = new Case();
    lstassistanceOptions= new list<selectOption>();
    lstTypeOptions = new list<selectOption>();
    lstBestTimeOptions = new list<selectOption>();
    lstHardshipReasonOptions = new list<selectOption>();
    AccountId = pepUtilityClass.getAccountId();    
    system.debug('accountid' +AccountId);
    lstSection = new list<pepCmsSection__c> ();
    boolType = false;
    boolAssistance = false;
    boolHardshipReason = false;
    boolBestTime = false;
    String strObjectName;
    lstAttachment = new list<Attachment> ();
    Map<String,String> ChildObjectMap = new Map<String,String>();
    contractStatusSet.addall(Label.CLContractStatus.split(','));
     String Child = 'loan__Transaction_Amount__c,loan__Debit_Date__c,loan__Active__c,loan__Type__c ';
     ChildObjectMap.put('loan__Automated_Payment_Setup__r',child);
    
    
     
     if(string.isNotBlank(AccountId))
     {
        loanAccountId = pepUtilityClass.getLoanAccountId(AccountId);
     } 
    
     system.debug('loanAccountId Swati' +loanAccountId );
     
     if(string.isNotBlank(loanAccountId))
     {
        strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(loanAccountId);
           if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
               loanContractList = pepUtilityClass.getLoanContract(loanAccountId);                
     }
     
     If (AccountId != null)
     {         
         pepUtilityClass.contractWrapper objWrapper = new pepUtilityClass.contractWrapper();  // intilalize the contractwapper class object of  utility class
         sideBarList = objWrapper.getContract(AccountId);   // after passing accountId add all contract(both PAF and PL) in sidebar list to show in sidebar menu.
     }
       
        loadCmscontent();
    
    
}

public pageReference checkClosedLoan()
{
  if(loanContractList.size()>0)
  {
    if(contractStatusSet.contains(loanContractList[0].loan__Loan_Status__c))
    {
         String redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;  
         Pagereference ref = new Pagereference('/'+redircetPageName); 
         Return ref.setRedirect(true);
    
    }
  } 
   return null; 

}

public void loadCMSContent()
    {
       lstSection = [Select id,pepSectionBodyRich__c,pepSectionStoryRich__c,pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c = 'Hardship' and pepSectionUniqueName__c = 'Hardship Section 19' limit 1];
       
       lstLeftSideBarSections =[select id,pepHeader__c,pepCss_Class__c,pepRedirect_to_Page__c from pepCmsSection__c where Page_Name__c='DashboardSideBarTemplate' order by pepSequence__c asc];

       if(lstSection != null && lstSection.size() > 0)
       {
           strSectionStory = lstSection[0].pepSectionBodyRich__c;
           strSectionStoryEmail = lstSection[0].pepSectionStoryRich__c;
           
        /*   if(loanContractList != null && loanContractList[0].Name != null)
           {
               strSectionStory = strSectionStory.replace('LoanNumber',loanContractList[0].Name);
           } */
       }
       
     //  system.debug('strSectionStory Swati' + strSectionStory );
        
    lstBestTimeOptions.add(new selectOption('Best time to call me','Best time to call me'));   
    lstBestTimeOptions.add(new selectOption('Morning (9am – 12pm)','Morning (9am – 12pm)'));
    lstBestTimeOptions.add(new selectOption('Afternoon (2pm – 5pm)','Afternoon (2pm – 5pm)'));
    lstBestTimeOptions.add(new selectOption('Midday (12pm – 2pm)','Midday (12pm – 2pm)'));
    lstassistanceOptions.add(new selectOption('Length of time needed for assistance','Length of time needed for assistance')); 
    lstassistanceOptions.add(new selectOption('Less than 1 month','Less than 1 month'));
    lstassistanceOptions.add(new selectOption('1- 3 months','1- 3 months'));
    lstassistanceOptions.add(new selectOption('Other','Other'));
    lstHardshipReasonOptions.add(new selectOption('Reason for hardship','Reason for hardship'));
    lstHardshipReasonOptions.add(new selectOption('Unemployment','Unemployment'));
    lstHardshipReasonOptions.add(new selectOption('Natural Disaster','Natural Disaster'));
    lstHardshipReasonOptions.add(new selectOption('Relationship Breakdown','Relationship Breakdown'));
    lstHardshipReasonOptions.add(new selectOption('Bereavement','Bereavement'));
    lstHardshipReasonOptions.add(new selectOption('Maternity Leave','Maternity Leave'));
    lstHardshipReasonOptions.add(new selectOption('Health Reasons','Health Reasons'));
    lstHardshipReasonOptions.add(new selectOption('Under Employment','Under Employment'));
    lstHardshipReasonOptions.add(new selectOption('Other','Other'));
    lstTypeOptions.add(new selectOption('Type of assistance requested','Type of assistance requested'));
    lstTypeOptions.add(new selectOption('Reduced Payments','Reduced Payments'));
    lstTypeOptions.add(new selectOption('Payment Freeze','Payment Freeze'));
    lstTypeOptions.add(new selectOption('Other','Other'));
       
       
       
       
}

 public Pagereference Saveenquiry()
    {
        
        system.debug('idIssssssss'+selectedBestTime);
        system.debug('idIssssssss'+selectedHardshipReason);
        system.debug('idIssssssss'+selectedtype);
        system.debug('idIssssssss'+selectedassistance);
        
        
        if(String.IsNotBlank(selectedBestTime) && String.IsNotBlank(selectedHardshipReason) && String.IsNotBlank(selectedtype) && String.IsNotBlank(selectedassistance ))
        {
            if(selectedBestTime != 'Best time to call me')
            {
                objCase.Best_time_to_call_Hardship__c = selectedBestTime ;
            }
            
            if(selectedHardshipReason != 'Reason for hardship')
            {
                objCase.Reason_for_hardship__c = selectedHardshipReason ; 
            } 
            
            if(selectedtype != 'Type of assistance requested')  
            {       
                objCase.Type_of_assistance__c = selectedtype ;
            }
            
            if(selectedassistance != 'Length of time needed for assistance')
            {
                objCase.Length_of_time_needed_for_assistance__c = selectedassistance ;
            }
            objCase.RecordTypeId = [Select Id From RecordType where sobjecttype = 'Case' and name = 'Hardship' limit 1].id;
            
            if(objCase != null )
            {
                insert objCase;
                successMsg = true;
                caseid = objCase.Id;
                
            }
            system.debug('idIssssssss'+caseid);
            
            if(objCase.id!=null && String.IsNotBlank(objCase.id))
            {
               
                successMsg = true;
                system.debug('idIssssssss'+objCase.id);
                system.debug('successMsgIssssssss'+successMsg);
                    
            }
            
            
        }
        return null;
        
    }
    
    public pagereference Cancel()
    {
        string redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;
        Pagereference objPageRef = new pageReference('/'+redircetPageName);
      //  Pagereference objPageRef = Page.pepWelcomePage;
        objPageRef.setredirect(true);
        return objPageRef ;
        
    }
    
// This method is used to update the contract id in account object after clicked from sidebar menu list.

    public pageReference updateAccount()
    {
       // String idLoanAccount = Apexpages.currentPage().getParameters().get('loanContractid');
        System.debug('idLoanAccount ****** '+idLoanAccount);
        if(string.isNotBlank(AccountId) && string.isNotBlank(idLoanAccount))
        {
            Account objAccount = new Account(id =AccountId);
            objAccount.Loan_Account_Id__c = idLoanAccount;
            update  objAccount;
             // Added by Rishabh (for PAF)
            //fetch using the common method whether it is PAF contract or PL contract
            String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(idLoanAccount);
                     if(string.isnotBlank(strObjectName) && strObjectName=='loan__Loan_Account__c')
                     {
                         // redirect to PL view my loan page if user clicked on PL contract 
                        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                     }
                   else if(string.isnotBlank(strObjectName) && strObjectName=='collect__Loan_Account__c')
                   {
                         // redirect to PAF view my loan page if user clicked on PAF contract 
                        string redircetPageName= pages_config__c.getinstance('pafviewmyassetloanpage').Page_Label__c;
                        pagereference objpage = new pagereference('/'+redircetPageName);
                        return objpage.setRedirect(true);
                   } 
             // end here        
         } 
         return null;
    }
@TestVisible
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
        
       
        if(pageName=='pepPaymentDetails')
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
    
   public pageReference redirectToPage()
    {
       String pageName = Apexpages.currentPage().getParameters().get('pageNameValue');
       String redircetPageName= pages_config__c.getinstance(pageName).Page_Label__c;  
       Pagereference ref = new Pagereference('/'+redircetPageName); 
       Return ref.setRedirect(true);
    }
    
    public void upload()
    {
    }
}