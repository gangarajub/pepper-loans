// ----------------------------------------------------------------------------------------------------
// This class would be used to handle all functionality for display of Notification.
// ----------------------------------------------------------------------------------------------------
// Created Date: 25-NOV-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestNotificationController
// ----------------------------------------------------------------------------------------------------
public class ScCollection_ViewNotificationController
{
    //variable declaration for the data to be populated on page    
    public String strContractId {get;set;}
    public String strNotId {get;set;}
    
    public cnotify__Delivery_Detail__c objnotification {get;set;}
    
    //constructor for variable initialization
    public ScCollection_ViewNotificationController()
    {
        strContractId = '';
        strNotId = '';
        
        objnotification = new cnotify__Delivery_Detail__c();
        
        //get the Id from url parameter
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id')))
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
        }
        
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('notId')))
        {
            strNotId = ApexPages.currentPage().getParameters().get('notId');
            
            objnotification = [select Id, Name, cnotify__Subject__c, ScCollection_Letter_URL__c, ScCollection_Communication_Type_Formula__c, ScCollection_Send_To__c, cnotify__Sent__c, cnotify__Sent_Date__c, cnotify__Message__c, ScCollection_Is_Manual__c, cnotify__Error_Message__c from cnotify__Delivery_Detail__c where Id =: strNotId];
        }
    }
}