// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ViewNotificationController class
// ----------------------------------------------------------------------------------------------------
// Created Date: 25-NOV-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestNotificationController
{
    @isTest static void test0(){
    
        cnotify__Delivery_Detail__c obj = new cnotify__Delivery_Detail__c();
        obj.Name = 'test';
        insert obj;
        
        ApexPages.currentPage().getParameters().put('id',obj.id);
        ApexPages.currentPage().getParameters().put('notId',obj.id);
        ScCollection_ViewNotificationController objController = new ScCollection_ViewNotificationController();
    
    }
    
}