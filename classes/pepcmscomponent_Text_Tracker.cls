@isTest public class pepcmscomponent_Text_Tracker {
    
    
    @isTest static void pepcmscomponent_TextTest(){
      test.startTest();  
         pepCmsPage__c objPage1 = new pepCmsPage__c();
         objPage1 = pepCommonTrackerController.createPage('Loan Details');
        
        
         pepCmsSection__c objSection2 = new pepCmsSection__c();
         objSection2 = pepCommonTrackerController.createSection1(objPage1);
         objSection2.pepSectionUniqueName__c ='pqr';
         objSection2.pepType__c='Help Text';
         objSection2.pepSectionBodyRich__c='test body rich';
         update objSection2;
      
         pepCmsSection__c objSection3 = new pepCmsSection__c();
         objSection3 = pepCommonTrackerController.createSection1(objPage1);
         objSection3.pepSectionUniqueName__c ='lmn';
         objSection3.pepType__c='Running Text';
         update objSection3;
        
         pepCmsSection__c objSection4 = new pepCmsSection__c();
         objSection4 = pepCommonTrackerController.createSection1(objPage1);
         objSection4.pepSectionUniqueName__c ='lmno';
         objSection4.pepType__c='Running';
         update objSection4;
        
         pepCmsSection__c objSection5 = new pepCmsSection__c();
         objSection5 = pepCommonTrackerController.createSection1(objPage1);
         objSection5.pepSectionUniqueName__c ='lmnop';
         objSection5.pepType__c='Running';
         update objSection5;
         
         pepCmsSection__c objSection6 = new pepCmsSection__c();
         objSection6 = pepCommonTrackerController.createSection1(objPage1);
         objSection6.pepSectionUniqueName__c ='Decline2';
         objSection6.pepType__c='Running Text';
         update objSection6;

//instance of class        
         pepcmscomponent_Text objpapcmscomponent = new pepcmscomponent_Text();
         objpapcmscomponent.strSectionName='pqr';
         objpapcmscomponent.strPageName='Loan Details';
         objpapcmscomponent.getRenderSection();
        
         pepcmscomponent_Text objpapcmscomponent1 = new pepcmscomponent_Text();
         objpapcmscomponent1.strSectionName='lmn';
         objpapcmscomponent1.strPageName='Loan Details';
         objpapcmscomponent1.getRenderSection();
        
         pepcmscomponent_Text objpapcmscomponent2 = new pepcmscomponent_Text();
         objpapcmscomponent2.strSectionName='lmno';
         objpapcmscomponent2.strPageName='Loan Details';
         objpapcmscomponent2.getRenderSection();
        
         pepcmscomponent_Text objpapcmscomponent3 = new pepcmscomponent_Text();
         objpapcmscomponent3.strSectionName='lmnopp';
         objpapcmscomponent3.strPageName='Loan Details';
         objpapcmscomponent3.getRenderSection();
         
         pepcmscomponent_Text objpapcmscomponent4 = new pepcmscomponent_Text();
         objpapcmscomponent4.strSectionName='Decline2';
         objpapcmscomponent4.strPageName='Loan Details';
         objpapcmscomponent4.getRenderSection();
     test.stopTest();    
    }
    
    

}