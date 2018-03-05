// ---------------------------------------------------------------------------------------------------------
// This Tracker class is used to cover pepCongratulations class. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      14th June 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
@isTest(seeAllData= false)
Public Class pepCongratulations_Tracker
{
    
  private Static  pepCmsPage__c objPage;
  private Static  pepCmsSection__c objSection;
  private Static  Account objAccount;
  private Static  genesis__Applications__c objGenesisApp;
  private Static  Application__c objApp;
  private static pepCmsPage__c objcmspage;
  private static pepCmsSection__c objCMSSection;
  private static pepCmsSection__c objCMSSection1;
  private static pepCmsSection__c objCMSSection2;
  private static pepCmsSection__c objCMSSection3;
  
  private static List<pepCmsSection__c> lstPepCMS;
  
  static testMethod void testPepCongratulations() 
  {
      test.starttest();
      
        pages_config__c pg11 = new pages_config__c(Name='peploansetupverifyid',Page_Label__c='loansetupverifyid');
            insert pg11;

      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.CreateBusinessAcc();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepCongratulations;
      Test.setcurrentPagereference(pd);
      
       createpage();
      
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       
       
       pepCongratulations objPepCong = new pepCongratulations();
       objPepCong.checkcookie();
      
        Application__c pepApplication = new Application__c(Name= 'pepCongratulations',Navigation_Status__c='LoanSetup-Offer',RedirectPage__c='pepCongratulations');
        insert pepApplication;
        objPepCong.saveForLater();
        
        Application__c  pepApplication1  =  pepCommonTrackerController.createApplication();
        pepApplication1.Name = 'peploanSetupverifyid'; 
        pepApplication1.RedirectPage__c = 'peploanSetupverifyid';
        pepApplication1.Navigation_Status__c = 'LoanSetup-Jumio';
        update pepApplication1;
         
        objPepCong.redirectToNextPage();
        test.stoptest();
       
  }
  
  static void createpage()
   {
       objcmspage = new pepCmsPage__c();
       objcmspage.pepPageName__c = 'Congratulations';
       insert objcmspage;
       
       //CMS Section 1
       objCMSSection = new pepCmsSection__c();
       objCMSSection.pepPage__c = objcmspage.id;
       objCMSSection.pepCss_Class__c = 'mainCat_share';
       objCMSSection.pepHeader__c = 'Refer-a-friend';
       objCMSSection.Marketing_Link_1__c = '';
       objCMSSection.pepRedirect_to_Page__c = '';
       objCMSSection.pepSectionBody__c = '';
       objCMSSection.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection.pepSectionStory__c = '';
       objCMSSection.pepSectionStoryRich__c = '';
       objCMSSection.pepSectionUniqueName__c = 'Test1';
       objCMSSection.pepSequence__c = 0;
       objCMSSection.pepType__c = 'Help Text';
       insert objCMSSection;
       
       //CMS Section 1
       objCMSSection1 = new pepCmsSection__c();
       objCMSSection1.pepPage__c = objcmspage.id;
       objCMSSection1.pepCss_Class__c = 'mainCat_share';
       objCMSSection1.pepHeader__c = 'Refer-a-friend';
       objCMSSection1.Marketing_Link_1__c = '';
       objCMSSection1.pepRedirect_to_Page__c = '';
       objCMSSection1.pepSectionBody__c = '';
       objCMSSection1.pepSectionBodyRich__c = 'test body rich2';
       objCMSSection1.pepSectionStory__c = '';
       objCMSSection1.pepSectionStoryRich__c = '';
       objCMSSection1.pepSectionUniqueName__c = 'Test2';
       objCMSSection1.pepSequence__c = 1;
       objCMSSection1.pepType__c = 'Help Text';
       insert objCMSSection1;
       
       
       //CMS Section 2
       objCMSSection2 = new pepCmsSection__c();
       objCMSSection2.pepPage__c = objcmspage.id;
       objCMSSection2.pepCss_Class__c = 'mainCat_share';
       objCMSSection2.pepHeader__c = 'Refer-a-friend';
       objCMSSection2.Marketing_Link_1__c = '';
       objCMSSection2.pepRedirect_to_Page__c = '';
       objCMSSection2.pepSectionBody__c = '';
       objCMSSection2.pepSectionBodyRich__c = '{!genesis__Applications__c.genesis__Account__r.Id}';
       objCMSSection2.pepSectionStory__c = '';
       objCMSSection2.pepSectionStoryRich__c = '';
       objCMSSection2.pepSectionUniqueName__c = 'Test3';
       objCMSSection2.pepSequence__c = 2;
       objCMSSection2.pepType__c = 'Help Text';
       insert objCMSSection2;
       
       //CMS Section 3
       objCMSSection3 = new pepCmsSection__c();
       objCMSSection3.pepPage__c = objcmspage.id;
       objCMSSection3.pepCss_Class__c = 'mainCat_share';
       objCMSSection3.pepHeader__c = 'Refer-a-friend';
       objCMSSection3.Marketing_Link_1__c = '';
       objCMSSection3.pepRedirect_to_Page__c = '';
       objCMSSection3.pepSectionBody__c = '';
       objCMSSection3.pepSectionBodyRich__c = '{!genesis__Applications__c.Id}';
       objCMSSection3.pepSectionStory__c = '';
       objCMSSection3.pepSectionStoryRich__c = '';
       objCMSSection3.pepSectionUniqueName__c = 'Test4';
       objCMSSection3.pepSequence__c = 3;
       objCMSSection3.pepType__c = 'Help Text';
       insert objCMSSection3;
       
       
       lstPepCMS = new List<pepCmsSection__c>();
       lstPepCMS.add(objCMSSection);
       lstPepCMS.add(objCMSSection1);
       lstPepCMS.add(objCMSSection2);
       lstPepCMS.add(objCMSSection3);
       
   }
   
}