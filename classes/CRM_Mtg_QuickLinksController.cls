// ----------------------------------------------------------------------------------------------------
// This class would be used to handle all functionality for Quick Links on Home Page.
// ----------------------------------------------------------------------------------------------------
// Created Date: 18-MAY-2017    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : CRM_Mtg_TestQuickLinksController
// ----------------------------------------------------------------------------------------------------
public class CRM_Mtg_QuickLinksController
{
    public List<CRM_Mtg_Quick_Links__c> lstLinks {get;set;}
    
    public CRM_Mtg_QuickLinksController()
    {
         lstLinks = new List<CRM_Mtg_Quick_Links__c>();
         
         lstLinks = CRM_Mtg_Quick_Links__c.getall().values();
    }
}