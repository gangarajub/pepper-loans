//  -------------------------------------------------------------------------------------------------------
//  This class handles all the trigger events on CRM_Mtg_BDM_Target__c Object
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 16-FEB-2016        Created By: Pawan Mudgal            Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : CRM_Mtg_TestBDMTargetHandler
//  -------------------------------------------------------------------------------------------------------
public class CRM_Mtg_BDMTargetHandler
{
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before insert events on bdm target Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeInsert(List<CRM_Mtg_BDM_Target__c> lstNew)
    {
        TagBDMLookup(lstNew);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after insert events on bdm target Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<CRM_Mtg_BDM_Target__c> lstNew)
    {
        UpsertTargetChildRecords(lstNew);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before update events on bdm target Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeUpdate(List<CRM_Mtg_BDM_Target__c> lstNew, Map<Id,CRM_Mtg_BDM_Target__c> mapOld)
    {
        
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on bdm target Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(List<CRM_Mtg_BDM_Target__c> lstNew, Map<Id,CRM_Mtg_BDM_Target__c> mapOld)
    {
        UpsertTargetChildRecords(lstNew);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to tag BDm Lookup for BDM Target object record.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void TagBDMLookup(List<CRM_Mtg_BDM_Target__c> lstNew)
    {
        Set<Decimal> setBDMId = new Set<Decimal>();
        Map<Decimal,Id> mapBDMIdToUser = new Map<Decimal,Id>();
        
        for(CRM_Mtg_BDM_Target__c obj : lstNew)
        {
            if(obj.CRM_Mtg_BDM_Unique_Id__c != Null)
            {
                setBDMId.add(obj.CRM_Mtg_BDM_Unique_Id__c);
            }
        }
        
        if(setBDMId != Null && setBDMId.size() > 0)
        {
            for(User obju : [select Id, CRM_Mtg_Unique_Id__c from User where IsActive = true AND CRM_Mtg_Unique_Id__c IN : setBDMId])    
            {
                mapBDMIdToUser.put(obju.CRM_Mtg_Unique_Id__c, obju.Id);
            }
        }
        
        for(CRM_Mtg_BDM_Target__c obj : lstNew)
        {
            if(obj.CRM_Mtg_BDM_Unique_Id__c != Null && mapBDMIdToUser.containsKey(obj.CRM_Mtg_BDM_Unique_Id__c) && mapBDMIdToUser.get(obj.CRM_Mtg_BDM_Unique_Id__c) != Null)
            {
                obj.CRM_Mtg_BDM__c = mapBDMIdToUser.get(obj.CRM_Mtg_BDM_Unique_Id__c);
                obj.Name = obj.CRM_Mtg_BDM_Unique_Id__c + '-' + obj.CRM_Mtg_Month__c + '-' + obj.CRM_Mtg_Year__c;
                obj.CRM_Mtg_Unique_Id__c = obj.CRM_Mtg_BDM_Unique_Id__c + '-' + obj.CRM_Mtg_Month__c + '-' + obj.CRM_Mtg_Year__c;
            }
            else
            {
                obj.addError('Error : Broker Id is not valid.');
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic to insert child records for the BDM Target object record.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void UpsertTargetChildRecords(List<CRM_Mtg_BDM_Target__c> lstNew)
    {
        Map<String,Integer> mapMonthNameToInteger = new map<String,Integer>();
        
        mapMonthNameToInteger.put('Jan',1);
        mapMonthNameToInteger.put('Feb',2);
        mapMonthNameToInteger.put('Mar',3);
        mapMonthNameToInteger.put('Apr',4);
        mapMonthNameToInteger.put('May',5);
        mapMonthNameToInteger.put('Jun',6);
        mapMonthNameToInteger.put('Jul',7);
        mapMonthNameToInteger.put('Aug',8);
        mapMonthNameToInteger.put('Sep',9);
        mapMonthNameToInteger.put('Oct',10);
        mapMonthNameToInteger.put('Nov',11);
        mapMonthNameToInteger.put('Dec',12);
        
        List<CRM_Mtg_Application_Target__c> lstApplications = new List<CRM_Mtg_Application_Target__c>();
        List<CRM_Mtg_Settlement_Target__c> lstSettlements = new List<CRM_Mtg_Settlement_Target__c>();
        List<String> lstChannels = new List<String>();
        List<String> lstProducts = new List<String>();
        
        lstChannels.add('Retail');
        lstChannels.add('White Label');
        
        lstProducts.add('Non Conforming');
        lstProducts.add('Near Prime');
        lstProducts.add('Prime');
        
        for(CRM_Mtg_BDM_Target__c obj : lstNew)
        {
            for(String objchannel : lstChannels)
            {
                for(String objproduct : lstProducts)
                {
                    CRM_Mtg_Application_Target__c objApp = new CRM_Mtg_Application_Target__c();
                    CRM_Mtg_Settlement_Target__c objSett = new CRM_Mtg_Settlement_Target__c();
                    
                    objApp.CRM_Mtg_BDM_Target__c = obj.Id;
                    objApp.CRM_Mtg_Unique_Id__c = obj.Id + '-' + objchannel + '-' + objproduct;
                    objApp.CRM_Mtg_Unique_Identifier__c = obj.CRM_Mtg_BDM__c + '-' + objchannel + '-' + objproduct + '-' + mapMonthNameToInteger.get(obj.CRM_Mtg_Month__c) + '-' + obj.CRM_Mtg_Year__c;
                    
                    objSett.CRM_Mtg_BDM_Target__c = obj.Id;
                    objSett.CRM_Mtg_Unique_Id__c = obj.Id + '-' + objchannel + '-' + objproduct;
                    objSett.CRM_Mtg_Unique_Identifier__c = obj.CRM_Mtg_BDM__c + '-' + objchannel + '-' + objproduct + '-' + mapMonthNameToInteger.get(obj.CRM_Mtg_Month__c) + '-' + obj.CRM_Mtg_Year__c;
                    
                    if(objchannel == 'Retail')
                    {
                        objApp.CRM_Mtg_Channel__c = 'Retail';
                        objSett.CRM_Mtg_Channel__c = 'Retail';
                        
                        if(objproduct == 'Non Conforming')
                        {
                            objApp.CRM_Mtg_Product__c = 'Non Conforming';
                            objApp.CRM_Mtg_Target_Applications__c = obj.CRM_Mtg_NC_Retail_Application_No__c;
                            objApp.CRM_Mtg_Target_Applications_Amt__c = obj.CRM_Mtg_NC_Retail_Application_Amt__c;
                            
                            objSett.CRM_Mtg_Product__c = 'Non Conforming';
                            objSett.CRM_Mtg_Target_Settlements__c = obj.CRM_Mtg_NC_Retail_Settlement_No__c;
                            objSett.CRM_Mtg_Target_Settlements_Amt__c = obj.CRM_Mtg_NC_Retail_Settlement_Amt__c;
                        }
                        else if(objproduct == 'Near Prime')
                        {
                            objApp.CRM_Mtg_Product__c = 'Near Prime';
                            objApp.CRM_Mtg_Target_Applications__c = obj.CRM_Mtg_NP_Retail_Application_No__c;
                            objApp.CRM_Mtg_Target_Applications_Amt__c = obj.CRM_Mtg_NP_Retail_Application_Amt__c;
                            
                            objSett.CRM_Mtg_Product__c = 'Near Prime';
                            objSett.CRM_Mtg_Target_Settlements__c = obj.CRM_Mtg_NP_Retail_Settlement_No__c;
                            objSett.CRM_Mtg_Target_Settlements_Amt__c = obj.CRM_Mtg_NP_Retail_Settlement_Amt__c;
                        }
                        else
                        {
                            objApp.CRM_Mtg_Product__c = 'Prime';
                            objApp.CRM_Mtg_Target_Applications__c = obj.CRM_Mtg_Prime_Retail_Application_No__c;
                            objApp.CRM_Mtg_Target_Applications_Amt__c = obj.CRM_Mtg_Prime_Retail_Application_Amt__c;
                            
                            objSett.CRM_Mtg_Product__c = 'Prime';
                            objSett.CRM_Mtg_Target_Settlements__c = obj.CRM_Mtg_Prime_Retail_Settlement_No__c;
                            objSett.CRM_Mtg_Target_Settlements_Amt__c = obj.CRM_Mtg_Prime_Retail_Settlement_Amt__c;
                        }
                    }
                    else
                    {
                        objApp.CRM_Mtg_Channel__c = 'White Label';
                        objSett.CRM_Mtg_Channel__c = 'White Label';
                        
                        if(objproduct == 'Non Conforming')
                        {
                            objApp.CRM_Mtg_Product__c = 'Non Conforming';
                            objApp.CRM_Mtg_Target_Applications__c = obj.CRM_Mtg_NC_WL_Application_No__c;
                            objApp.CRM_Mtg_Target_Applications_Amt__c = obj.CRM_Mtg_NC_WL_Application_Amt__c;
                            
                            objSett.CRM_Mtg_Product__c = 'Non Conforming';
                            objSett.CRM_Mtg_Target_Settlements__c = obj.CRM_Mtg_NC_WL_Settlement_No__c;
                            objSett.CRM_Mtg_Target_Settlements_Amt__c = obj.CRM_Mtg_NC_WL_Settlement_Amt__c;
                        }
                        else if(objproduct == 'Near Prime')
                        {
                            objApp.CRM_Mtg_Product__c = 'Near Prime';
                            objApp.CRM_Mtg_Target_Applications__c = obj.CRM_Mtg_NP_WL_Application_No__c;
                            objApp.CRM_Mtg_Target_Applications_Amt__c = obj.CRM_Mtg_NP_WL_Application_Amt__c;
                            
                            objSett.CRM_Mtg_Product__c = 'Near Prime';
                            objSett.CRM_Mtg_Target_Settlements__c = obj.CRM_Mtg_NP_WL_Settlement_No__c;
                            objSett.CRM_Mtg_Target_Settlements_Amt__c = obj.CRM_Mtg_NP_WL_Settlement_Amt__c;
                        }
                        else
                        {
                            objApp.CRM_Mtg_Product__c = 'Prime';
                            objApp.CRM_Mtg_Target_Applications__c = obj.CRM_Mtg_Prime_WL_Application_No__c;
                            objApp.CRM_Mtg_Target_Applications_Amt__c = obj.CRM_Mtg_Prime_WL_Application_Amt__c;
                            
                            objSett.CRM_Mtg_Product__c = 'Prime';
                            objSett.CRM_Mtg_Target_Settlements__c = obj.CRM_Mtg_Prime_WL_Settlement_No__c;
                            objSett.CRM_Mtg_Target_Settlements_Amt__c = obj.CRM_Mtg_Prime_WL_Settlement_Amt__c;
                        }
                    }
                    
                    lstApplications.add(objApp);
                    lstSettlements.add(objSett);
                }
            }
        }
        
        if(lstApplications != Null && lstApplications.size() > 0)
        {
            upsert lstApplications CRM_Mtg_Unique_Id__c;
        }
        
        if(lstSettlements != Null && lstSettlements.size() > 0)
        {
            upsert lstSettlements CRM_Mtg_Unique_Id__c;
        }
    }
}