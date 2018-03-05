@isTest public class pepCmsFooterComponentController_Tracker {
    
    @isTest static void pepCmsFooterTest(){
        
        pepCmsPage__c objPepCmsPage = pepCommonTrackerController.createPage('Footer');
        pepCmsSection__c objPepCmsSection = pepCommonTrackerController.createSection1(objPepCmsPage);
        pepCmsFooterComponentController objpepCmsFooter = new pepCmsFooterComponentController();
    }

}