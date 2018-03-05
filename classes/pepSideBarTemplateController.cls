public class pepSideBarTemplateController{
public Integer Step{get;set;}
public String call{get;set;}
public String needHelp{get;set;}
public List<String> lstSteps{get;set;}
public Map<String,String> mpStepName_Class{get;Set;}
public String PageName{get;set;}//Added by KG
public String Page_Label{get;set;}//Added by KG
List<genesis__Applications__c>  lstApplication;
public pepSideBarTemplateController()
{
    Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');
    
     Map<string,string> childobjects = new Map<string,string>();       
     if(cookieApplicationId != null && string.valueof(cookieApplicationId.getValue())!='')
     {
        lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,string.valueof(pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()))),null,null,childobjects );
     }

lstSteps=new List<String>();
Set<String> strExculdePages=new Set<String>();
Id idClPurpose = lstApplication[0].genesis__CL_Purpose__c;
List<clcommon__CL_Purpose__c> lstCLPurpose = new List<clcommon__CL_Purpose__c>  ();
 lstCLPurpose = [select id ,name,Is_Debt_Con__c,Number_of_Debts__c from clcommon__CL_Purpose__c where id =:idClPurpose and Is_Debt_Con__c = True];
if(lstApplication!=null && lstCLPurpose.size()==0)
{
strExculdePages.add('Debt consolidation');
}
if(lstApplication!=null && lstApplication[0].Is_Secured__c==false)
{
strExculdePages.add('Asset details');
}

mpStepName_Class=new Map<String,String>();
pageName=ApexPages.currentPage().getUrl();
pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
Step=pageStepNumber(pageName);

System.debug('pageNme***'+pageName);
Page_Label=pages_config__c.getValues(pageName.toLowerCase()).Page_Label__c;//Added by KG

Set<String> pages=new Set<String>();
pages.add('Header');pages.add('SideBarTemplate');
List<pepCmsPage__c>  lstPage=[Select id,pepPageName__c ,(Select id,pepHeader__c,pepSequence__c,pepSectionBody__c,pepSectionUniqueName__c from  pepSection__r where pepHeader__c Not IN:strExculdePages order by pepSequence__c asc) from pepCmsPage__c  where pepPageName__c IN :pages];
    for(pepCmsPage__c objPage:lstPage)
    {
        if(objPage.pepPageName__c=='SideBarTemplate')
        {
            for(pepCmsSection__c objSection:objPage.pepSection__r)
            {
             lstSteps.add(objSection.pepHeader__c);
             if(integer.valueof(objSection.pepSequence__c)<Step)
              mpStepName_Class.put(objSection.pepHeader__c,'done');
             else if(integer.valueof(objSection.pepSequence__c)==Step)
              mpStepName_Class.put(objSection.pepHeader__c,'active');
             else
              mpStepName_Class.put(objSection.pepHeader__c,'');
            }
        }
        else if(objPage.pepPageName__c=='Header')
        {
           for(pepCmsSection__c objSection:objPage.pepSection__r)
            {
              if(objSection.pepSectionUniqueName__c == 'Need help')
              {
              needHelp=objSection.pepSectionBody__c;
              }
              else if(objSection.pepSectionUniqueName__c == 'Call')
              {
              call=objSection.pepSectionBody__c;
              }
            }
        }
    }  
}

public pageReference checkNavigationStatus()
{
    
    pageName = pageName.toLowerCase();
    
  if(pageName!='pepthankyou')
   {
    if(lstApplication!=null && string.isNotBlank(lstApplication[0].pepNavigation_Status__c))
     {
         list<Application__c> navigationSetting = Application__c.getall().values();
         
            for(Application__c navigate : navigationSetting)
            {
               if((string.isNotBlank(pageName)) && (navigate.Navigation_Status__c == lstApplication[0].pepNavigation_Status__c) && ((navigate.Name).toLowerCase()==pageName))
               {
                  return null;
               }
               
            }
         return new PageReference('/'+pages_config__c.getinstance(pepUtilityClass.navigateToPage(lstApplication[0].pepNavigation_Status__c).toLowerCase()).Page_Label__c);
      } 
   }   
                   
                   return null;
                  
  //  Pagereference temp=Peputilityclass.HandleredirectSecurity();
   // return temp;
} 

private Integer pageStepNumber(String pageName)
{
Integer intStep=0;
  if(pageName=='pepCongratulations')
    {intStep=1;}
    else if(pageName =='peploanSetupverifyid')
    { intStep =2;}
    else if(pageName =='pepUploadFinancialDoc' || pageName =='pepBankInfoDetails' || pageName =='pepLoanSetupUploadedDocs')
   {intStep=3;}
   else if(pageName == 'pepAssetPage')
    {intStep=4;}
    else if(pageName == 'pepPaymentSetup')
    {intStep=5;}
     else if(pageName=='pepDebtConsolidation')
    { intStep=6;}
    else if(pageName=='pepFinaliseRepayment')
    {intStep=7;}
    else if(pageName=='pepLoanSetupCreditPolicy')
    {intStep=8;}
    else if(pageName=='pepContract')
    { intStep=9;}
      else if(pageName=='pepThankYou')
    { intStep=10;}
   
    return intStep;
}


}