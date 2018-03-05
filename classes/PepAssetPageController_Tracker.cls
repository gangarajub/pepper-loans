// ---------------------------------------------------------------------------------------------------------
// This Tracker class is used to cover PepAssetPageController class. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      1st March 2017          Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
@isTest(seeAllData= false)
Public Class PepAssetPageController_Tracker
{
    
  private Static  pepCmsPage__c objPage;
  private Static  pepCmsSection__c objSection;
  private Static  Account objAccount;
  private Static  genesis__Applications__c objGenesisApp;
  private Static  Application__c objApp;
  private Static pepCmsPage__c objcmspage;
  private Static Attachment attach;
  
  private static List<pepCmsSection__c> lstPepCMS;
  
  
  
  
  // This method is used to create CMS content
  
  static void createpage()
   {
       objcmspage = new pepCmsPage__c();
       objcmspage.pepPageName__c = 'Asset Details Page';
       insert objcmspage;
       
             pepCmsSection__c objCMSSection1 = new pepCmsSection__c();
       objCMSSection1.pepPage__c = objcmspage.id;
       objCMSSection1.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection1.pepSequence__c = 1;
       objCMSSection1.pepType__c = 'Running Text';
       objCMSSection1.pepSectionUniqueName__c='AssetDetailsSection1';
       insert objCMSSection1;
       
       pepCmsSection__c objCMSSection2 = new pepCmsSection__c();
       objCMSSection2.pepPage__c = objcmspage.id;
       objCMSSection2.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection2.pepSequence__c = 2;
       objCMSSection2.pepType__c = 'Running Text';
       objCMSSection2.pepSectionUniqueName__c='AssetDetailsSection2';
       insert objCMSSection2;
       
       pepCmsSection__c objCMSSection3 = new pepCmsSection__c();
       objCMSSection3.pepPage__c = objcmspage.id;
       objCMSSection3.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection3.pepSequence__c = 3;
       objCMSSection3.pepType__c = 'Form';
       objCMSSection3.pepSectionUniqueName__c='AssetDetailsSection3';
       insert objCMSSection3;
       
       pepCmsSection__c objCMSSection4 = new pepCmsSection__c();
       objCMSSection4.pepPage__c = objcmspage.id;
       objCMSSection4.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection4.pepSequence__c = 4;
       objCMSSection4.pepType__c = 'Running Text';
       objCMSSection4.pepSectionUniqueName__c='AssetDetailsSection4';
       insert objCMSSection4;
       
       pepCmsSection__c objCMSSection5 = new pepCmsSection__c();
       objCMSSection5.pepPage__c = objcmspage.id;
       objCMSSection5.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection5.pepSequence__c = 5;
       objCMSSection5.pepType__c = 'Running Text';
       objCMSSection5.pepSectionUniqueName__c='AssetDetailsSection5';
       insert objCMSSection5;
       
       pepCmsSection__c objCMSSection6 = new pepCmsSection__c();
       objCMSSection6.pepPage__c = objcmspage.id;
       objCMSSection6.pepSectionBodyRich__c = '${!genesis__Applications__c.genesis__Loan_Amount__c} at an interest rate of {!genesis__Applications__c.genesis__Interest_Rate__c}%p.a. over {!genesis__Applications__c.Requested_Term__c} years ';
       objCMSSection6.pepSequence__c = 6;
       objCMSSection6.pepType__c = 'Running Text';
       objCMSSection6.pepSectionUniqueName__c='AssetDetailsSection6';
       insert objCMSSection6;
       
       pepCmsSection__c objCMSSection7 = new pepCmsSection__c();
       objCMSSection7.pepPage__c = objcmspage.id;
       objCMSSection7.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection7.pepSequence__c = 7;
       objCMSSection7.pepType__c = 'Running Text';
       objCMSSection7.pepSectionUniqueName__c='AssetDetailsSection7';
       insert objCMSSection7;
       
       pepCmsSection__c objCMSSection8 = new pepCmsSection__c();
       objCMSSection8.pepPage__c = objcmspage.id;
       objCMSSection8.pepSectionBodyRich__c = 'We have done a few checks and unfortunately we are unable to offer you a secured loan of ${!genesis__Applications__c.genesis__Loan_Amount__c} for the asset you are seeking to buy. Although this is the case, we have had a look at all the other options available to you and these are:';
       objCMSSection8.pepSequence__c = 8;
       objCMSSection8.pepType__c = 'Running Text';
       objCMSSection8.pepSectionUniqueName__c='AssetDetailsSection8';
       insert objCMSSection8;
       
       pepCmsSection__c objCMSSection9 = new pepCmsSection__c();
       objCMSSection9.pepPage__c = objcmspage.id;
       objCMSSection9.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection9.pepSequence__c = 9;
       objCMSSection9.pepType__c = 'Running Text';
       objCMSSection9.pepSectionUniqueName__c='AssetDetailsSection9';
       insert objCMSSection9;
       
       pepCmsSection__c objCMSSection10 = new pepCmsSection__c();
       objCMSSection10.pepPage__c = objcmspage.id;
       objCMSSection10.pepSectionBodyRich__c = 'We can offer you a secured loan amount of ${amount} at an interest rate of {interest}% at payments of ${repaymentAmount} on a {paymentFrequency} basis.';
       objCMSSection10.pepSequence__c = 10;
       objCMSSection10.pepType__c = 'Running Text';
       objCMSSection10.pepSectionUniqueName__c='AssetDetailsSection10';
       insert objCMSSection10;
       
       pepCmsSection__c objCMSSection11 = new pepCmsSection__c();
       objCMSSection11.pepPage__c = objcmspage.id;
       objCMSSection11.pepSectionBodyRich__c = 'We can offer you a unsecured loan amount of ${amount} at an interest rate of {interest}% at payments of ${repaymentAmount} on a {paymentFrequency} basis.';
       objCMSSection11.pepSequence__c = 11;
       objCMSSection11.pepType__c = 'Running Text';
       objCMSSection11.pepSectionUniqueName__c='AssetDetailsSection11';
       insert objCMSSection11;
       
       pepCmsSection__c objCMSSection12 = new pepCmsSection__c();
       objCMSSection12.pepPage__c = objcmspage.id;
       objCMSSection12.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection12.pepSequence__c = 12;
       objCMSSection12.pepType__c = 'Running Text';
       objCMSSection12.pepSectionUniqueName__c='AssetDetailsSection12';
       insert objCMSSection12;
       
       pepCmsSection__c objCMSSection13 = new pepCmsSection__c();
       objCMSSection13.pepPage__c = objcmspage.id;
       objCMSSection13.pepSectionBodyRich__c = 'By continuing I confirm that the option I have selected is sufficient in meeting the purpose required for {loanPurpose} I am applying.';
       objCMSSection13.pepSequence__c = 13;
       objCMSSection13.pepType__c = 'Running Text';
       objCMSSection13.pepSectionUniqueName__c='AssetDetailsSection13';
       insert objCMSSection13;
       
       pepCmsSection__c objCMSSection14 = new pepCmsSection__c();
       objCMSSection14.pepPage__c = objcmspage.id;
       objCMSSection14.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection14.pepSequence__c = 14;
       objCMSSection14.pepType__c = 'Running Text';
       objCMSSection14.pepSectionUniqueName__c='AssetDetailsSection14';
       insert objCMSSection14;
       
       pepCmsSection__c objCMSSection15 = new pepCmsSection__c();
       objCMSSection15.pepPage__c = objcmspage.id;
       objCMSSection15.pepSectionBodyRich__c = 'If at any of the steps you require assistance please call 1300 659 430 and quote your application number {!genesis__Applications__c.Name}';
       objCMSSection15.pepSequence__c = 15;
       objCMSSection15.pepType__c = 'Running Text';
       objCMSSection15.pepSectionUniqueName__c='AssetDetailsSection15';
       insert objCMSSection15;
       
       pepCmsSection__c objCMSSection16 = new pepCmsSection__c();
       objCMSSection16.pepPage__c = objcmspage.id;
       objCMSSection16.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection16.pepSequence__c = 16;
       objCMSSection16.pepType__c = 'Running Text';
       objCMSSection16.pepSectionUniqueName__c='AssetDetailsSection16';
       insert objCMSSection16;
       
       pepCmsSection__c objCMSSection17 = new pepCmsSection__c();
       objCMSSection17.pepPage__c = objcmspage.id;
       objCMSSection17.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection17.pepSequence__c = 17;
       objCMSSection17.pepType__c = 'Running Text';
       objCMSSection17.pepSectionUniqueName__c='AssetDetailsSection17';
       insert objCMSSection17;
       
       pepCmsSection__c objCMSSection18 = new pepCmsSection__c();
       objCMSSection18.pepPage__c = objcmspage.id;
       objCMSSection18.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection18.pepSequence__c = 18;
       objCMSSection18.pepType__c = 'Running Text';
       objCMSSection18.pepSectionUniqueName__c='AssetDetailsSection18';
       insert objCMSSection18;
       
       pepCmsSection__c objCMSSection19 = new pepCmsSection__c();
       objCMSSection19.pepPage__c = objcmspage.id;
       objCMSSection19.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection19.pepSequence__c = 19;
       objCMSSection19.pepType__c = 'Running Text';
       objCMSSection19.pepSectionUniqueName__c='AssetDetailsSection19';
       insert objCMSSection19;
       
       pepCmsSection__c objCMSSection20 = new pepCmsSection__c();
       objCMSSection20.pepPage__c = objcmspage.id;
       objCMSSection20.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection20.pepSequence__c = 20;
       objCMSSection20.pepType__c = 'Running Text';
       objCMSSection20.pepSectionUniqueName__c='AssetDetailsSection20';
       insert objCMSSection20;
       
       pepCmsSection__c objCMSSection21 = new pepCmsSection__c();
       objCMSSection21.pepPage__c = objcmspage.id;
       objCMSSection21.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection21.pepSequence__c = 21;
       objCMSSection21.pepType__c = 'Running Text';
       objCMSSection21.pepSectionUniqueName__c='AssetDetailsSection21';
       insert objCMSSection21;
       
       pepCmsSection__c objCMSSection22 = new pepCmsSection__c();
       objCMSSection22.pepPage__c = objcmspage.id;
       objCMSSection22.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection22.pepSequence__c = 22;
       objCMSSection22.pepType__c = 'Running Text';
       objCMSSection22.pepSectionUniqueName__c='AssetDetailsSection22';
       insert objCMSSection22;
       
       pepCmsSection__c objCMSSection23 = new pepCmsSection__c();
       objCMSSection23.pepPage__c = objcmspage.id;
       objCMSSection23.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection23.pepSequence__c = 23;
       objCMSSection23.pepType__c = 'Running Text';
       objCMSSection23.pepSectionUniqueName__c='AssetDetailsSection23';
       insert objCMSSection23;
       
       pepCmsSection__c objCMSSection24 = new pepCmsSection__c();
       objCMSSection24.pepPage__c = objcmspage.id;
       objCMSSection24.pepSectionBodyRich__c = 'test body rich1';
       objCMSSection24.pepSequence__c = 24;
       objCMSSection24.pepType__c = 'Running Text';
       objCMSSection24.pepSectionUniqueName__c='AssetDetailsSection24';
       insert objCMSSection24;
       
       pepCmsSection__c objCMSSection25 = new pepCmsSection__c();
       objCMSSection25.pepPage__c = objcmspage.id;
       objCMSSection25.pepSectionBodyRich__c = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       objCMSSection25.pepSequence__c = 25;
       objCMSSection25.pepType__c = 'Running Text';
       objCMSSection25.pepSectionUniqueName__c='AssetDetailsSection25';
       insert objCMSSection25;

       
        pepCmsQuestion__c objQuestion1 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion1.pepFieldApiName__c='Item Details';
        objQuestion1.pepType__c='Button';
        update objQuestion1;
        
        pepCmsQuestion__c objQuestion2 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion2.pepFieldApiName__c='pep_User_Selected_Vehicle__c';
        objQuestion2.pepType__c='Button';
        update objQuestion2;
        
        pepCmsQuestion__c objQuestion3 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion3.pepFieldApiName__c='Is_Dealer_Purchased__c';
        objQuestion3.pepType__c='Button';
        update objQuestion3;
        
        pepCmsQuestion__c objQuestion4 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion4.pepFieldApiName__c='clcommon__Vehicle_ID_Number__c';
        objQuestion4.pepType__c='Text';
        update objQuestion4;
        
        pepCmsQuestion__c objQuestion5 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion5.pepFieldApiName__c='pep_State_of_Registration__c';
        objQuestion5.pepType__c='Text';
        update objQuestion5;
        
        pepCmsQuestion__c objQuestion6 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion6.pepFieldApiName__c='pep_Registration_Number__c';
        objQuestion6.pepType__c='Text';
        update objQuestion6;
        
        pepCmsQuestion__c objQuestion7 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion7.pepFieldApiName__c='clcommon__Year__c';
        objQuestion7.pepType__c='Text';
        update objQuestion7;
        
        pepCmsQuestion__c objQuestion8 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion8.pepFieldApiName__c='pep_User_Selected_Make__c';
        objQuestion8.pepType__c='Picklist';
        update objQuestion8;
        
        pepCmsQuestion__c objQuestion9 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion9.pepFieldApiName__c='pep_User_Selected_Model__c';
        objQuestion9.pepType__c='Picklist';
        update objQuestion9;
        
        pepCmsQuestion__c objQuestion10 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion10.pepFieldApiName__c='Red_Book_Vehicle_Series__c';
        objQuestion10.pepType__c='Picklist';
        update objQuestion10;
        
        pepCmsQuestion__c objQuestion11 = pepCommonTrackerController.createCmsQuestion(objcmspage,objCMSSection3);   
        objQuestion11.pepFieldApiName__c='abcd';
        objQuestion11.pepType__c='Currency';
        update objQuestion11;
        
        pepCmsAnswer__c objAnswer1 = new pepCmsAnswer__c();
        objAnswer1 = pepCommonTrackerController.createCmsAnswer(objQuestion1);
        pepCmsAnswer__c objAnswer2 = new pepCmsAnswer__c();
        objAnswer2 = pepCommonTrackerController.createCmsAnswer(objQuestion2);
        pepCmsAnswer__c objAnswer3 = new pepCmsAnswer__c();
        objAnswer3 = pepCommonTrackerController.createCmsAnswer(objQuestion3);
        
        genesis__Application_Document_Category__c appDocCategory  = new genesis__Application_Document_Category__c();
        appDocCategory.Name = 'Collateral';
        appDocCategory.genesis__Application__c = objGenesisApp.id;
        insert appDocCategory;
        
        attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objAccount.id;
        insert attach;
        
        genesis__AppDocCatAttachmentJunction__c junctionDoc = new genesis__AppDocCatAttachmentJunction__c();
        junctionDoc.genesis__AttachmentId__c = attach.id;
        insert junctionDoc ;
        
        pages_config__c pg = new pages_config__c(Name='pepassetpage',Page_Label__c='AssetDetails');
        insert pg;
        
        pages_config__c pg1 = new pages_config__c(Name='peppaymentsetup',Page_Label__c='PaymentSetup');
        insert pg1;
        
        pages_config__c pg2 = new pages_config__c(Name='pepdeclinedcontract',Page_Label__c='DeclinedContract');
        insert pg2;
        
        pages_config__c pg3 = new pages_config__c(Name='pepreferredpage',Page_Label__c='ReferredPage');
        insert pg3;
        Application__c appObject = new Application__c(Name='pepPaymentSetup',Navigation_Status__c ='pepPaymentSetup',RedirectPage__c='LoanSetup-PaymentSetup');
        insert appObject;
        ApexPages.currentPage().getParameters().put('strSelected','yes');

     
   }
   
   
   // This method is used to create active colletral
   
   static void loadActiveColletralData()
   {
        Registration__c objregistration = new Registration__c();
        objregistration.registration_Plate__c ='XRO408';
        objregistration.registration_State__c ='SA';
        insert objregistration;
        
        Redbook_Valuation__c objRedbook = new Redbook_Valuation__c ();
        objRedbook.MakeDescription__c = 'HONDA';
        objRedbook.FamilyDescription__c = 'CR-V';
        objRedbook.YearGroup__c = '2008';
        objRedbook.Type__c = 'Car';
        objRedbook.Description__c= 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objRedbook.VehicleKey__c = 'AUVABAR2011AEAA';
        objRedbook.BadgeDescription__c = 'abcd';
        insert objRedbook;
        
        clcommon__Collateral__c objColletral = new clcommon__Collateral__c();
        objColletral.clcommon__Collateral_Name__c ='My Vehicle';
        objColletral.Vehicle_Type__c ='CAR / SMALL PASSENGER VEHICLE';
        objColletral.pep_User_Selected_Make__c =  'HONDA';
        objColletral.clcommon__Year__c =  '2008';
        objColletral.Red_Book_Vehicle_Series__c =  'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objColletral.clcommon__Vehicle_ID_Number__c =  'AUVABAR2011AEAA';
        objColletral.pep_User_Selected_Model__c =  'CR-V';
        objColletral.Is_Dealer_Purchased__c =  'Yes';
        objColletral.pep_User_Selected_Vehicle__c =  'Car';
        objColletral.Variant__c=  'abcd';
        objColletral.Registration__c =  objregistration.id;
        objColletral.active__c = true;
        objColletral.clcommon__Make__c = 'HONDA';
        objColletral.clcommon__Year__c = '2008';
        objColletral.clcommon__Model__c = 'CR-V';
        insert objColletral;
   
   }
   
   // This method is used to load inactive colletral
   
   static void loadInactiveColletralData()
   {
       Registration__c objregistration = new Registration__c();
        objregistration.registration_Plate__c ='XRO408';
        objregistration.registration_State__c ='SA';
        insert objregistration;
        
        Redbook_Valuation__c objRedbook = new Redbook_Valuation__c ();
        objRedbook.MakeDescription__c = 'HONDA';
        objRedbook.FamilyDescription__c = 'CR-V';
        objRedbook.YearGroup__c = '2008';
        objRedbook.Type__c = 'Car';
        objRedbook.Description__c= 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objRedbook.VehicleKey__c = 'AUVABAR2011AEAA';
        objRedbook.BadgeDescription__c = 'abcd';
        insert objRedbook;
        
        clcommon__Collateral__c objColletral = new clcommon__Collateral__c();
        objColletral.clcommon__Collateral_Name__c ='My Vehicle';
        objColletral.Vehicle_Type__c ='CAR / SMALL PASSENGER VEHICLE';
        objColletral.pep_User_Selected_Make__c =  'HONDA';
        objColletral.clcommon__Year__c =  '2008';
        objColletral.Red_Book_Vehicle_Series__c =  'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objColletral.clcommon__Vehicle_ID_Number__c =  'AUVABAR2011AEAA';
        objColletral.pep_User_Selected_Model__c =  'CR-V';
        objColletral.Is_Dealer_Purchased__c =  'Yes';
        objColletral.pep_User_Selected_Vehicle__c =  'Car';
        objColletral.Variant__c=  'abcd';
        objColletral.genesis__Application__c =  objGenesisApp.id;
        objColletral.Registration__c =  objregistration.id;
        objColletral.clcommon__Make__c = 'HONDA';
        objColletral.clcommon__Year__c = '2008';
        objColletral.clcommon__Model__c = 'CR-V';
        insert objColletral;
   
   }
   
  // load redbook data where colletral has no make and model
  
   static void loadRedbokData1()
   {
       Registration__c objregistration = new Registration__c();
        objregistration.registration_Plate__c ='XRO408';
        objregistration.registration_State__c ='SA';
        insert objregistration;
        
        Redbook_Valuation__c objRedbook = new Redbook_Valuation__c ();
        objRedbook.MakeDescription__c = 'HONDA';
        objRedbook.FamilyDescription__c = 'CR-V';
        objRedbook.YearGroup__c = '2008';
        objRedbook.Type__c = 'Car';
        objRedbook.Description__c= 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objRedbook.VehicleKey__c = 'AUVABAR2011AEAA';
        objRedbook.BadgeDescription__c = 'abcd';
        insert objRedbook;
        
        clcommon__Collateral__c objColletral = new clcommon__Collateral__c();
        objColletral.clcommon__Collateral_Name__c ='My Vehicle';
        objColletral.Vehicle_Type__c ='CAR / SMALL PASSENGER VEHICLE';
        objColletral.pep_User_Selected_Make__c =  'HONDA';
        objColletral.clcommon__Year__c =  '2008';
        objColletral.Red_Book_Vehicle_Series__c =  'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objColletral.clcommon__Vehicle_ID_Number__c =  'AUVABAR2011AEAA';
        objColletral.pep_User_Selected_Model__c =  'CR-V';
        objColletral.Is_Dealer_Purchased__c =  'Yes';
        objColletral.pep_User_Selected_Vehicle__c =  'Car';
        objColletral.Variant__c=  'abcd';
        objColletral.genesis__Application__c =  objGenesisApp.id;
        objColletral.Registration__c =  objregistration.id;
        objColletral.active__c = true;
        insert objColletral;
   
   }
   
   // load red book data with same colletral info
   
   static void loadRedbokData2()
   {
       Registration__c objregistration = new Registration__c();
        objregistration.registration_Plate__c ='XRO408';
        objregistration.registration_State__c ='SA';
        insert objregistration;
        
        Redbook_Valuation__c objRedbook = new Redbook_Valuation__c ();
        objRedbook.MakeDescription__c = 'HONDA';
        objRedbook.FamilyDescription__c = 'CR-V';
        objRedbook.YearGroup__c = '2008';
        objRedbook.Type__c = 'Car';
        objRedbook.Description__c= 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objRedbook.VehicleKey__c = 'AUVABAR2011AEAA';
        objRedbook.BadgeDescription__c = 'abcd';
        insert objRedbook;
        
        clcommon__Collateral__c objColletral = new clcommon__Collateral__c();
        objColletral.clcommon__Collateral_Name__c ='My Vehicle';
        objColletral.Vehicle_Type__c ='CAR / SMALL PASSENGER VEHICLE';
        objColletral.pep_User_Selected_Make__c =  'HONDA';
        objColletral.clcommon__Year__c =  '2008';
        objColletral.Red_Book_Vehicle_Series__c =  'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objColletral.clcommon__Vehicle_ID_Number__c =  'AUVABAR2011AEAA';
        objColletral.pep_User_Selected_Model__c =  'CR-V';
        objColletral.Is_Dealer_Purchased__c =  'Yes';
        objColletral.pep_User_Selected_Vehicle__c =  'Car';
        objColletral.Variant__c=  'abcd';
        objColletral.genesis__Application__c =  objGenesisApp.id;
        objColletral.Registration__c =  objregistration.id;
        objColletral.active__c = true;
        objColletral.clcommon__Make__c = 'HONDA';
        objColletral.clcommon__Year__c = '2008';
        objColletral.clcommon__Model__c = 'CR-V';
        insert objColletral;
   
   }
  
   // load redbbok data where colletral has different variant 
  
   static void loadRedbokData3()
   {
       Registration__c objregistration = new Registration__c();
        objregistration.registration_Plate__c ='XRO408';
        objregistration.registration_State__c ='SA';
        insert objregistration;
        
        Redbook_Valuation__c objRedbook = new Redbook_Valuation__c ();
        objRedbook.MakeDescription__c = 'HONDA';
        objRedbook.FamilyDescription__c = 'CR-V';
        objRedbook.YearGroup__c = '2008';
        objRedbook.Type__c = 'Car';
        objRedbook.Description__c= 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objRedbook.VehicleKey__c = 'AUVABAR2011AEAA';
        objRedbook.BadgeDescription__c = 'abcd';
        insert objRedbook;
        
        clcommon__Collateral__c objColletral = new clcommon__Collateral__c();
        objColletral.clcommon__Collateral_Name__c ='My Vehicle';
        objColletral.Vehicle_Type__c ='CAR / SMALL PASSENGER VEHICLE';
        objColletral.pep_User_Selected_Make__c =  'HONDA';
        objColletral.clcommon__Year__c =  '2008';
        objColletral.Red_Book_Vehicle_Series__c =  'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objColletral.clcommon__Vehicle_ID_Number__c =  'AUVABAR2011AEAA';
        objColletral.pep_User_Selected_Model__c =  'CR-V';
        objColletral.Is_Dealer_Purchased__c =  'Yes';
        objColletral.pep_User_Selected_Vehicle__c =  'Car';
        objColletral.Variant__c=  'abc';
        objColletral.genesis__Application__c =  objGenesisApp.id;
        objColletral.Registration__c =  objregistration.id;
        objColletral.active__c = true;
        objColletral.clcommon__Make__c = 'HONDA';
        objColletral.clcommon__Year__c = '2008';
        objColletral.clcommon__Model__c = 'CR-V';
        insert objColletral;
   
   }
   
   // load red book data where colletral has different model
   
   static void loadRedbokData4()
   {
       Registration__c objregistration = new Registration__c();
        objregistration.registration_Plate__c ='XRO408';
        objregistration.registration_State__c ='SA';
        insert objregistration;
        
        Redbook_Valuation__c objRedbook = new Redbook_Valuation__c ();
        objRedbook.MakeDescription__c = 'HONDA';
        objRedbook.FamilyDescription__c = 'CR-VV';
        objRedbook.YearGroup__c = '2008';
        objRedbook.Type__c = 'Car';
        objRedbook.Description__c= 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objRedbook.VehicleKey__c = 'AUVABAR2011AEAA';
        objRedbook.BadgeDescription__c = 'abcd';
        insert objRedbook;
        
        clcommon__Collateral__c objColletral = new clcommon__Collateral__c();
        objColletral.clcommon__Collateral_Name__c ='My Vehicle';
        objColletral.Vehicle_Type__c ='CAR / SMALL PASSENGER VEHICLE';
        objColletral.pep_User_Selected_Make__c =  'HONDA';
        objColletral.clcommon__Year__c =  '2008';
        objColletral.Red_Book_Vehicle_Series__c =  'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objColletral.clcommon__Vehicle_ID_Number__c =  'AUVABAR2011AEAA';
        objColletral.pep_User_Selected_Model__c =  'CR-V';
        objColletral.Is_Dealer_Purchased__c =  'Yes';
        objColletral.pep_User_Selected_Vehicle__c =  'Car';
        objColletral.Variant__c=  'abcd';
        objColletral.genesis__Application__c =  objGenesisApp.id;
        objColletral.Registration__c =  objregistration.id;
        objColletral.active__c = true;
        objColletral.clcommon__Make__c = 'HONDA';
        objColletral.clcommon__Year__c = '2008';
        objColletral.clcommon__Model__c = 'CR-V';
        insert objColletral;
   
   }
   
   // load red book data where colletral has different make
   
   static void loadRedbokData5()
   {
       Registration__c objregistration = new Registration__c();
        objregistration.registration_Plate__c ='XRO408';
        objregistration.registration_State__c ='SA';
        insert objregistration;
        
        Redbook_Valuation__c objRedbook = new Redbook_Valuation__c ();
        objRedbook.MakeDescription__c = 'HONDA';
        objRedbook.FamilyDescription__c = 'CR-V';
        objRedbook.YearGroup__c = '2008';
        objRedbook.Type__c = 'Car';
        objRedbook.Description__c= 'RE MY2007 Sport Wagon 5dr Man 6sp 4WDhhhhh';
        objRedbook.VehicleKey__c = 'AUVABAR2011AEAA';
        objRedbook.BadgeDescription__c = 'abcd';
        insert objRedbook;
        
        clcommon__Collateral__c objColletral = new clcommon__Collateral__c();
        objColletral.clcommon__Collateral_Name__c ='My Vehicle';
        objColletral.Vehicle_Type__c ='CAR / SMALL PASSENGER VEHICLE';
        objColletral.pep_User_Selected_Make__c =  'HONDA';
        objColletral.clcommon__Year__c =  '2008';
        objColletral.Red_Book_Vehicle_Series__c =  'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
        objColletral.clcommon__Vehicle_ID_Number__c =  'AUVABAR2011AEAA';
        objColletral.pep_User_Selected_Model__c =  'CR-V';
        objColletral.Is_Dealer_Purchased__c =  'Yes';
        objColletral.pep_User_Selected_Vehicle__c =  'Car';
        objColletral.Variant__c = 'abcdbb';
        objColletral.genesis__Application__c =  objGenesisApp.id;
        objColletral.Registration__c =  objregistration.id;
        objColletral.active__c = true;
        objColletral.clcommon__Make__c = 'HONDAA';
        objColletral.clcommon__Year__c = '2008';
        objColletral.clcommon__Model__c = 'CR-V';
        insert objColletral;
   
   }
   
   // This method is used to cover basic info to cover constructor calling methods
  
  Static testMethod void loadBasicInfo() 
  {
      test.starttest();
      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      objGenesisApp.Is_Manually_Assessed__c = true;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepAssetPage;
      Test.setcurrentPagereference(pd);
      
       createpage();
       loadRedbokData1();
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       PepAssetPageController objPepCong = new PepAssetPageController();
       objPepCong.selectedVin = 'AUVABAR2011AEAA';
       objPepCong.selectedOffer = 'Asset';
       objPepCong.selectedDealer = 'Dealer';
       objPepCong.selectedRedbook = 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
       objPepCong.loanAmountAge = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       objPepCong.successMsg = true;
       objPepCong.errorVin = false;
       objPepCong.vehicleDetails();
       objPepCong.sendChecklist();
       objPepCong.callVeda();
       objPepCong.saveForLater();
       objPepCong.fetchAssetDetail();
       objPepCong.inactiveAsset();
       PepAssetPageController.doUploadAttachment(objAccount.id,'blobValue','attName',attach.id);
       ApexPages.currentPage().getParameters().put('attachmentId',attach.id);
       ApexPages.currentPage().getParameters().put('selectedValue','HONDA');
       objPepCong.deleteAttachment();
       ApexPages.currentPage().getParameters().put('idAtt',attach.id);
       objPepCong.fetchAttachmentId();
       objPepCong.fetchSeries();
       objPepCong.applyOffer();
       objPepCong.confirmAndContinue();
       PepAssetPageController objPepCong1 = new PepAssetPageController();
       objPepCong1.selectedOffer = 'Secured';
       objPepCong1.applyOffer();
       PepAssetPageController objPepCong2 = new PepAssetPageController();
       objPepCong2.selectedOffer = 'Unsecured';
       objPepCong2.applyOffer();
       PepAssetPageController objPepCong3 = new PepAssetPageController();
       objPepCong3.selectedOffer = 'Withdraw';
       objPepCong3.applyOffer();
       
        test.stoptest();
         
          System.assertNotEquals(objPepCong3.applyOffer(),null);

       
  }
  
  // This method is used to cover active colletral info part
  
   Static testMethod void coverActiveColletralInfo() 
  {
      test.starttest();
      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      objGenesisApp.Is_Manually_Assessed__c = true;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepAssetPage;
      Test.setcurrentPagereference(pd);
      
       createpage();
       loadActiveColletralData();
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       PepAssetPageController objPepCong = new PepAssetPageController();
       objPepCong.selectedVin = 'AUVABAR2011AEAA';
       objPepCong.selectedOffer = 'Asset';
       objPepCong.selectedRedbook = 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
       objPepCong.loanAmountAge = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       objPepCong.successMsg = true;
       objPepCong.errorVin = false;

       test.stoptest();
       System.assertEquals(objGenesisApp.Is_Manually_Assessed__c,true);
       
  }
  
   //This method is used to cover inactive colletral info part
   
   Static testMethod void coverInactiveColletralInfo() 
  {
      test.starttest();
      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      objGenesisApp.Is_Manually_Assessed__c = true;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepAssetPage;
      Test.setcurrentPagereference(pd);
      
       createpage();
       loadInactiveColletralData();
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       PepAssetPageController objPepCong = new PepAssetPageController();
       objPepCong.selectedVin = 'AUVABAR2011AEAA';
       objPepCong.selectedOffer = 'Asset';
       objPepCong.selectedRedbook = 'RE MY2007 Sport Wagon 5dr Man 6sp 4WD';
       objPepCong.loanAmountAge = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       objPepCong.successMsg = true;
       objPepCong.errorVin = false;
      
       test.stoptest();
       system.assertEquals(objPepCong.selectedVehicle,'Car');

  }
  
 // This method is used to cover fetchRedbook method where redbook data has same data as coletral data
 
  static testMethod void callRedbokData2() 
  {
       test.starttest();
      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      objGenesisApp.Is_Manually_Assessed__c = true;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepAssetPage;
      Test.setcurrentPagereference(pd);
      
       createpage();
       loadRedbokData2();
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       PepAssetPageController objPepCong = new PepAssetPageController();
       objPepCong.loanAmountAge = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       test.stoptest();   
       system.assertEquals(objPepCong.makeDisabled,true);

  }
   // This method is used to cover fetchRedbook method where collateral has different variant as compare to redbook

   
  static testMethod void callRedbokData3() 
  {
       test.starttest();
      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      objGenesisApp.Is_Manually_Assessed__c = true;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepAssetPage;
      Test.setcurrentPagereference(pd);
      
       createpage();
       loadRedbokData3();
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       PepAssetPageController objPepCong = new PepAssetPageController();
       objPepCong.loanAmountAge = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       test.stoptest();   
       system.assertEquals(objPepCong.modelDisabled,true);

  }
   // This method is used to cover fetchRedbook method where colletral has different model as compare to redbook

  static testMethod void callRedbokData4() 
  {
       test.starttest();
      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      objGenesisApp.Is_Manually_Assessed__c = true;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepAssetPage;
      Test.setcurrentPagereference(pd);
      
       createpage();
       loadRedbokData4();
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       PepAssetPageController objPepCong = new PepAssetPageController();
       objPepCong.loanAmountAge = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       test.stoptest();   
       system.assertEquals(objPepCong.modelDisabled,false);

  }
   // This method is used to cover fetchRedbook method where colletral has different make as compare to redbook

  static testMethod void callRedbokData5() 
  {
       test.starttest();
      
      RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
      objAccount = pepCommonTrackerController.createAccount();
      objGenesisApp = genesis.TestHelper.createApplication();
      objGenesisApp.genesis__Account__c = objAccount.id;
      objGenesisApp.Is_Manually_Assessed__c = true;
      update objGenesisApp;
     
      
      //Instance of page Reference
      pagereference pd=Page.pepAssetPage;
      Test.setcurrentPagereference(pd);
      
       createpage();
       loadRedbokData5();
       //Set cookies 
       Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesisApp.id)),'-1',null,false);
       pd.setcookies(new cookie[]{Applicationid});
       PepAssetPageController objPepCong = new PepAssetPageController();
       objPepCong.loanAmountAge = 'Your application has been assessed for ${!genesis__Applications__c.genesis__Loan_Amount__c}.';
       test.stoptest();   
       system.assertEquals(objPepCong.makeDisabled,false);

  }
   
}