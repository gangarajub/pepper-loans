//  -------------------------------------------------------------------------------------------------------
//  This class handles all the trigger events on CRM_Mortgage_Application_Data__c Object
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 16-FEB-2016        Created By: Pawan Mudgal            Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : CRM_Mtg_TestMortgageAppHandler
//  -------------------------------------------------------------------------------------------------------
public class CRM_Mtg_MortgageAppHandler
{
    public Map<Integer,String> mapMonthName = new map<Integer,String>();
    
    public CRM_Mtg_MortgageAppHandler()
    {
        mapMonthName.put(1,'Jan');
        mapMonthName.put(2,'Feb');
        mapMonthName.put(3,'Mar');
        mapMonthName.put(4,'Apr');
        mapMonthName.put(5,'May');
        mapMonthName.put(6,'Jun');
        mapMonthName.put(7,'Jul');
        mapMonthName.put(8,'Aug');
        mapMonthName.put(9,'Sep');
        mapMonthName.put(10,'Oct');
        mapMonthName.put(11,'Nov');
        mapMonthName.put(12,'Dec');
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before insert events on mortgage application Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeInsert(List<CRM_Mortgage_Application_Data__c> lstNew)
    {
        //updating Application with opportunity lookup
        updateOpportunityLookup(lstNew,null);
        
        List<CRM_Mortgage_Application_Data__c> lstApps = new List<CRM_Mortgage_Application_Data__c>();
        
        for(CRM_Mortgage_Application_Data__c objapp : lstNew)
        {
            if(objapp.CRM_Mtg_Total_Loan_Amount__c != Null)
            {
                objapp.CRM_Mtg_Application_Amount__c = objapp.CRM_Mtg_Total_Loan_Amount__c;
            }
            else
            {
               objapp.CRM_Mtg_Total_Loan_Amount__c = 0;
               objapp.CRM_Mtg_Application_Amount__c = 0;
            }
            
            if(objapp.CRM_Mtg_Application_Id__c != Null)
            {
                objapp.Name = objapp.CRM_Mtg_Application_Id__c;
            }
            
            if(objapp.CRM_Mtg_Application_Date__c != Null)
            {
                objapp.CRM_Mtg_Application_Month__c = mapMonthName.get(objapp.CRM_Mtg_Application_Date__c.Month());
                objapp.CRM_Mtg_Application_Year__c = String.valueOf(objapp.CRM_Mtg_Application_Date__c.Year());
            }
            
            if(objapp.CRM_Mtg_Product__c != Null && objapp.CRM_Mtg_Product__c == 'Specialist')
            {
                objapp.CRM_Mtg_Product__c = 'Non Conforming';
            }
            
            if(objapp.CRM_Mtg_Broker_Id__c != Null && objapp.CRM_Mtg_Aggregator_Id__c != Null)
            {
                lstApps.add(objapp);
            }
            else
            {
                objapp.CRM_Mtg_Failure_Reason__c = 'Either of Broker Id or Aggregator Id is Null.';
            }
        }
        
        if(lstApps != Null && lstApps.size() > 0)
        {
            UpdateTargetVsAchieved(lstApps);
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after insert events on mortgage application Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<CRM_Mortgage_Application_Data__c> lstNew)
    {
        //AH 1/11/17 Added to update Opportunity when Mortgage Application records are created by DES
        //CRMtrgMortageToOpportunityLookupHandler.updateOptyFromMortgageApplication(lstNew);
        updateStatusOnOpportunity(lstNew,null);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before update events on mortgage application Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeUpdate(List<CRM_Mortgage_Application_Data__c> lstNew, Map<Id,CRM_Mortgage_Application_Data__c> mapOld)
    {
        //updating Application with opportunity lookup
        updateOpportunityLookup(lstNew,mapOld);
        
        List<CRM_Mortgage_Application_Data__c> lstApps = new List<CRM_Mortgage_Application_Data__c>();
        List<CRM_Mortgage_Application_Data__c> lstSettApps = new List<CRM_Mortgage_Application_Data__c>();
        
        for(CRM_Mortgage_Application_Data__c objapp : lstNew)
        {
            if(objapp.CRM_Mtg_Total_Loan_Amount__c != Null)
            {
                objapp.CRM_Mtg_Application_Amount__c = objapp.CRM_Mtg_Total_Loan_Amount__c;
            }
            else
            {
               objapp.CRM_Mtg_Total_Loan_Amount__c = 0;
               objapp.CRM_Mtg_Application_Amount__c = 0;
            }
            
            if(objapp.CRM_Mtg_Application_Id__c != Null)
            {
                objapp.Name = objapp.CRM_Mtg_Application_Id__c;
            }
            
            if(objapp.CRM_Mtg_Application_Date__c != Null)
            {
                objapp.CRM_Mtg_Application_Month__c = mapMonthName.get(objapp.CRM_Mtg_Application_Date__c.Month());
                objapp.CRM_Mtg_Application_Year__c = String.valueOf(objapp.CRM_Mtg_Application_Date__c.Year());
            }
            
            if(objapp.CRM_Mtg_Product__c != Null && objapp.CRM_Mtg_Product__c == 'Specialist')
            {
                objapp.CRM_Mtg_Product__c = 'Non Conforming';
            }
            
            if(objapp.CRM_Mtg_Broker_Id__c != Null && objapp.CRM_Mtg_Aggregator_Id__c != Null)
            {
                if(objapp.CRM_Mtg_Broker_Id__c != mapOld.get(objapp.Id).CRM_Mtg_Broker_Id__c || objapp.CRM_Mtg_BDM_SF_Id__c !=  mapOld.get(objapp.Id).CRM_Mtg_BDM_SF_Id__c || objapp.CRM_Mtg_Aggregator_Id__c != mapOld.get(objapp.Id).CRM_Mtg_Aggregator_Id__c || objapp.CRM_Mtg_Channel__c != mapOld.get(objapp.Id).CRM_Mtg_Channel__c || objapp.CRM_Mtg_Product__c != mapOld.get(objapp.Id).CRM_Mtg_Product__c || objapp.CRM_Mtg_Application_Date__c != mapOld.get(objapp.Id).CRM_Mtg_Application_Date__c || objapp.CRM_Mtg_Application_Target__c != mapOld.get(objapp.Id).CRM_Mtg_Application_Target__c || objapp.CRM_Mtg_Settlement_Target__c != mapOld.get(objapp.Id).CRM_Mtg_Settlement_Target__c || (objapp.CRM_Mtg_Channel__c == 'White Label' && objapp.CRM_Mtg_Application_State__c != Null && objapp.CRM_Mtg_Application_State__c != mapOld.get(objapp.Id).CRM_Mtg_Application_State__c) || (objapp.CRM_Mtg_Update_Record__c == true && mapOld.get(objapp.Id).CRM_Mtg_Update_Record__c != true))
                {
                    lstApps.add(objapp);    
                }
                
                if(objapp.CRM_Mtg_Settlement_Date__c != Null && objapp.CRM_Mtg_Settlement_Date__c != mapOld.get(objapp.Id).CRM_Mtg_Settlement_Date__c)
                {
                    objapp.CRM_Mtg_Settlement_Month__c = mapMonthName.get(objapp.CRM_Mtg_Settlement_Date__c.Month());
                    objapp.CRM_Mtg_Settlement_Year__c = String.valueOf(objapp.CRM_Mtg_Settlement_Date__c.Year());
                    lstSettApps.add(objapp);
                }
            }
            else
            {
                objapp.CRM_Mtg_Update_Record__c = false;
                objapp.CRM_Mtg_Error_Resolved__c = false;
                objapp.CRM_Mtg_Failure_Reason__c = 'Either of Broker Id or Aggregator Id is Null.';
            }
        }
        
        if(lstApps != Null && lstApps.size() > 0)
        {
            UpdateTargetVsAchieved(lstApps);
        }
        
        if(lstSettApps != Null && lstSettApps.size() > 0)
        {
            UpdateSettledTargetVsAchieved(lstSettApps);
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on mortgage application Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(List<CRM_Mortgage_Application_Data__c> lstNew, Map<Id,CRM_Mortgage_Application_Data__c> mapOld)
    {
        //AH 1/11/17 Added to update Opportunity when Mortgage Application records are updated by DES
        //CRMtrgMortageToOpportunityLookupHandler.updateOptyFromMortgageApplication(lstNew);        
        
        //VP Commenting Sandip's code 
        updateStatusOnOpportunity(lstNew,mapOld);
    }
    
    public void updateStatusOnOpportunity(List<CRM_Mortgage_Application_Data__c> lstNew,Map<Id,CRM_Mortgage_Application_Data__c> mapOld){
        
        map<String,CRM_Mortgage_Application_Data__c> mapOppIdToMortgageApplication = new map<String,CRM_Mortgage_Application_Data__c>();
        set<Id> setOpportunityId = new set<Id>();
        for(CRM_Mortgage_Application_Data__c objApplication : lstNew){
            
            if(
                (Trigger.isInsert && objApplication.CRM_Mtg_Opportunity__c != null) 
                || 
                (Trigger.isUpdate && objApplication.CRM_Mtg_Opportunity__c != null
                  && (objApplication.CRM_Mtg_Opportunity__c != mapOld.get(objApplication.Id).CRM_Mtg_Opportunity__c
                      ||
                      (objApplication.CRM_Mtg_Application_Status__c != mapOld.get(objApplication.Id).CRM_Mtg_Application_Status__c)
                      ||
                      (!String.isBlank(objApplication.CRM_Mtg_Product__c) && objApplication.CRM_Mtg_Product__c != mapOld.get(objApplication.Id).CRM_Mtg_Product__c)
                      ||
                      (objApplication.CRM_Mtg_Application_Amount__c != null && objApplication.CRM_Mtg_Application_Amount__c != mapOld.get(objApplication.Id).CRM_Mtg_Application_Amount__c)  
                    )
                )
            )
            {
                system.debug('updated');
                if(mapOppIdToMortgageApplication.get(objApplication.CRM_Mtg_Opportunity__c) == null){
                    mapOppIdToMortgageApplication.put(objApplication.CRM_Mtg_Opportunity__c,objApplication);
                    setOpportunityId.add(objApplication.CRM_Mtg_Opportunity__c);
                }
            }
        }
        
        if(setOpportunityId != null && setOpportunityId.Size() > 0){
            
            List<ApplicationStatusToOptyMapping__c> lstCustomSetting  =  ApplicationStatusToOptyMapping__c.getAll().values();
            Map<String, ApplicationStatusToOptyMapping__c> mapAppStatusToObject = new Map<String, ApplicationStatusToOptyMapping__c>();
            for(ApplicationStatusToOptyMapping__c objCustomSetting  : lstCustomSetting){
                mapAppStatusToObject.put(objCustomSetting.Application_Status__c, objCustomSetting);
            }
            List<Opportunity> lstOppToUpdate = new List<Opportunity>();
            for(String strOppId : setOpportunityId){
                Opportunity opp  = new Opportunity();
                opp.Id = strOppId;
                opp.CRM_Actual_loan_amount__c = mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Amount__c;
                opp.CRM_Product_Class_Name__c = mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Product__c;
                opp.CRM_Lost_Reason__c = '';
                if(!String.IsBlank(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c) 
                    && mapAppStatusToObject.containsKey(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c)
                    && mapAppStatusToObject.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c) != null){
                    
                    if(!String.IsBlank(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Channel__c) 
                        && mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Channel__c.equalsIgnoreCase('Direct')
                        && !String.IsBlank(mapAppStatusToObject.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c).Opportunity_Stage_Name__c)
                        && mapOppIdToMortgageApplication.get(opp.Id).Opportunity_Stage__c != 'Closed Lost'
                    )
                    {
                        opp.StageName = mapAppStatusToObject.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c).Opportunity_Stage_Name__c;
                    }
                    else if((
                                (!String.IsBlank(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Channel__c) 
                                && !mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Channel__c.equalsIgnoreCase('Direct')
                                )
                                ||
                                String.IsBlank(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Channel__c) 
                            )
                            && !String.IsBlank(mapAppStatusToObject.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c).B2B_Oppty_Stage_Name__c)
                        )
                    {
                        if(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c != 'Withdrawn' && mapAppStatusToObject.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c).B2B_Oppty_Stage_Name__c == 'Closed Lost'){
                            opp.CRM_Lost_Reason__c = 'Declined';
                        }
                        if(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c == 'Withdrawn' && mapAppStatusToObject.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c).B2B_Oppty_Stage_Name__c == 'Closed Lost'){
                            opp.CRM_Lost_Reason__c = 'Customer Withdrawn';
                        }
                        opp.StageName = mapAppStatusToObject.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c).B2B_Oppty_Stage_Name__c;
                    }
                }
                
                lstOppToUpdate.add(opp);
            }
            
            if(lstOppToUpdate != null && lstOppToUpdate.Size() >0){
                update lstOppToUpdate;
            }
        }
    }
    
    /*
    public void updateStatusOnOpportunity(List<CRM_Mortgage_Application_Data__c> lstNew,Map<Id,CRM_Mortgage_Application_Data__c> mapOld){
        
        map<String,CRM_Mortgage_Application_Data__c> mapOppIdToMortgageApplication = new map<String,CRM_Mortgage_Application_Data__c>();
        set<Id> setOpportunityId = new set<Id>();
        for(CRM_Mortgage_Application_Data__c objApplication : lstNew){
            if(objApplication.CRM_Mtg_Opportunity__c != null){
                if(((objApplication.CRM_Mtg_Application_Status__c != null && objApplication.CRM_Mtg_Application_Status__c != mapOld.get(objApplication.Id).CRM_Mtg_Application_Status__c) || (!String.isBlank(objApplication.CRM_Mtg_Product__c) && objApplication.CRM_Mtg_Product__c != mapOld.get(objApplication.Id).CRM_Mtg_Product__c) || (objApplication.CRM_Mtg_Application_Amount__c != null && objApplication.CRM_Mtg_Application_Amount__c != mapOld.get(objApplication.Id).CRM_Mtg_Application_Amount__c ) || (objApplication.CRM_Mtg_Application_Id__c != null && objApplication.CRM_Mtg_Application_Id__c != mapOld.get(objApplication.Id).CRM_Mtg_Application_Id__c)) || objApplication.CRM_Mtg_Opportunity__c != mapOld.get(objApplication.Id).CRM_Mtg_Opportunity__c){
                    
                    mapOppIdToMortgageApplication.put(objApplication.CRM_Mtg_Opportunity__c,objApplication);
                    setOpportunityId.add(objApplication.CRM_Mtg_Opportunity__c);
                }
            }
        }
        if(setOpportunityId != null && setOpportunityId.Size() > 0){
            
            Map<String, CRM_Status_Mapping__c> mapNameToCustomSetting = new map<String,CRM_Status_Mapping__c>();
            List<CRM_Status_Mapping__c> lstCustomSetting = CRM_Status_Mapping__c.getall().values();
            
            for(CRM_Status_Mapping__c objStatus : lstCustomSetting){
                mapNameToCustomSetting.put(objStatus.CRM_Application_Status__c,objStatus);
            }
                
            List<Opportunity> lstOppToUpdate = new List<Opportunity>();
            for(Opportunity opp : [Select Id,Amount,StageName,CRM_Product__c From Opportunity where Id In : setOpportunityId]){
                if(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c != null 
                && mapNameToCustomSetting.containsKey(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c) 
                && mapNameToCustomSetting.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c) != null){
                    opp.StageName = mapNameToCustomSetting.get(mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Status__c).CRM_Opportunity_Status__c;
                }
                opp.Amount = mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Amount__c;
                opp.CRM_Product__c = mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Product__c;
                opp.CRM_Application_ID__c = mapOppIdToMortgageApplication.get(opp.Id).CRM_Mtg_Application_Id__c;
                lstOppToUpdate.add(opp);
            }
            
            if(lstOppToUpdate != null && lstOppToUpdate.Size() >0){
                update lstOppToUpdate;
            }
        }
            
    }
    */
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for updating broker, aggregator and BDM on Application Record 
    // and tag the application to the BDM application target and BDM Settlement target record 
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void UpdateTargetVsAchieved(List<CRM_Mortgage_Application_Data__c> lstNew)
    {
        String defaultTgtIdentifier = '';
        String defaultSettIdentifier = '';
        
        Map<Decimal,Account> mapARMIdToAccount = new map<Decimal,Account>();
        Map<Decimal,Contact> mapARMIdToContact = new map<Decimal,Contact>();
        Map<String,CRM_Mtg_Application_Target__c> mapTargets = new map<String,CRM_Mtg_Application_Target__c>();
        Map<String,CRM_Mtg_Settlement_Target__c> mapSettlements = new map<String,CRM_Mtg_Settlement_Target__c>();
        Set<Decimal> setAggregatorId = new set<Decimal>();
        Set<Decimal> setBrokerId = new set<Decimal>();
        Set<Id> setBDMId = new Set<Id>();
        
        //Sandip -- added on 22/11/2017
        Set<Decimal> setBDMUniqueId = new set<Decimal>();
        
        String current_year = String.valueOf(System.Today().Year());
        String previous_year = String.valueOf(System.Today().Year() - 1);
        
        for(CRM_Mtg_Application_Target__c objtgt : [select Id from CRM_Mtg_Application_Target__c where CRM_Mtg_Is_Default__c = true Order By CreatedDate limit 1])
        {
            defaultTgtIdentifier = objtgt.Id;
        }
        
        for(CRM_Mtg_Settlement_Target__c objsett : [select Id from CRM_Mtg_Settlement_Target__c where CRM_Mtg_Is_Default__c = true Order By CreatedDate limit 1])
        {
            defaultSettIdentifier = objsett.Id;
        }
        
        for(CRM_Mortgage_Application_Data__c obj : lstNew)
        {
            try
            {
                
                setAggregatorId.add(Decimal.valueOf(obj.CRM_Mtg_Aggregator_Id__c));
                setBrokerId.add(Decimal.valueOf(obj.CRM_Mtg_Broker_Id__c));
                
                //Sandip -- added on 22/11/2017
                if(!String.isBlank(obj.CRM_Mtg_BDM_SF_Id__c)){
                    setBDMUniqueId.add(Decimal.valueOf(obj.CRM_Mtg_BDM_SF_Id__c));
                }
            }
            catch(Exception e)
            {
            }
        }
        
        for(Account obj : [select Id, CRM_Mtg_Unique_Id__c, (select Id, CRM_Mtg_BDM__c, CRM_Mtg_Aggregator_State__c from ChildAccounts) from Account where CRM_Mtg_Unique_Id__c IN : setAggregatorId])
        {
            mapARMIdToAccount.put(obj.CRM_Mtg_Unique_Id__c, obj);
        }
        
        for(Contact obj : [select Id, CRM_Mtg_Unique_Id__c, CRM_Mtg_Mortgage_BDM__c from Contact where CRM_Mtg_Unique_Id__c IN : setBrokerId])
        {
            mapARMIdToContact.put(obj.CRM_Mtg_Unique_Id__c, obj);
        }
        
        //Sandip -- added on 22/11/2017
        map<Decimal,Id> mapUniqueIdToUserId = new map<Decimal,Id>();
        
        for(User usr : [Select Id,CRM_Mtg_Unique_Id__c From User where CRM_Mtg_Unique_Id__c IN : setBDMUniqueId]){
            mapUniqueIdToUserId.put(usr.CRM_Mtg_Unique_Id__c,usr.Id);
            setBdmID.add(usr.Id);
        } 
        
        //Sandip -- changed setBDMId to setBDMUniqueId on 22/11/2017
        for(CRM_Mtg_Application_Target__c objtgt : [select Id, CRM_Mtg_Unique_Identifier__c from CRM_Mtg_Application_Target__c where CRM_Mtg_Month__c != Null AND (CRM_Mtg_Year__c =: current_year OR CRM_Mtg_Year__c =: previous_year) AND CRM_Mtg_BDM_Target__r.CRM_Mtg_BDM__c IN : setBdmID])
        {
            mapTargets.put(objtgt.CRM_Mtg_Unique_Identifier__c, objtgt);
        }
        //Sandip -- changed setBDMId to setBDMUniqueId on 22/11/2017
        for(CRM_Mtg_Settlement_Target__c objsett : [select Id, CRM_Mtg_Unique_Identifier__c from CRM_Mtg_Settlement_Target__c where CRM_Mtg_Month__c != Null AND (CRM_Mtg_Year__c =: current_year OR CRM_Mtg_Year__c =: previous_year) AND CRM_Mtg_BDM_Target__r.CRM_Mtg_BDM__c IN : setBdmID])
        {
            mapSettlements.put(objsett.CRM_Mtg_Unique_Identifier__c, objsett);
        }
        
        for(CRM_Mortgage_Application_Data__c obj : lstNew)
        {
            String appkey = '';
            String settkey = '';
            Boolean tagToDefault = false;
            
            obj.CRM_Mtg_Update_Record__c = false;
            obj.CRM_Mtg_Error_Resolved__c = false;
            
            Decimal aggregatorId = 0.0;
            Decimal brokerId = 0.0;
            Decimal bdmId = 0.0;
            try
            {
                aggregatorId = Decimal.valueOf(obj.CRM_Mtg_Aggregator_Id__c);
                brokerId = Decimal.valueOf(obj.CRM_Mtg_Broker_Id__c);
                
                //Sandip -- added on 22/11/2017
                if(!String.IsBlank(obj.CRM_Mtg_BDM_SF_Id__c))
                    bdmId = Decimal.valueOf(obj.CRM_Mtg_BDM_SF_Id__c);
            }
            catch(Exception e)
            {
            }
            
            if(mapARMIdToAccount.containsKey(aggregatorId) && mapARMIdToAccount.get(aggregatorId) != Null)
            {
                obj.CRM_Mtg_Aggregator__c = mapARMIdToAccount.get(aggregatorId).Id;
            }
            else
            {
                obj.CRM_Mtg_Failure_Reason__c = 'Aggregator Id is Invalid.';
            }
            
            if(mapARMIdToContact.containsKey(brokerId) && mapARMIdToContact.get(brokerId) != Null)
            {
                obj.CRM_Mtg_Broker__c = mapARMIdToContact.get(brokerId).Id;
            }
            else
            {
                obj.CRM_Mtg_Failure_Reason__c = 'Broker Id is Invalid.';
            }
            
            if(obj.CRM_Mtg_Channel__c != Null && obj.CRM_Mtg_Product__c != Null && obj.CRM_Mtg_Application_Date__c != Null)
            {
                if(obj.CRM_Mtg_Channel__c == 'Retail')
                {    
                    //Sandip -- added on 22/11/2017
                    if(bdmId != 0.0 && mapUniqueIdToUserId.containsKey(bdmId) && mapUniqueIdToUserId.get(bdmId) != Null){
                        obj.CRM_Mtg_BDM__c = mapUniqueIdToUserId.get(bdmId);
                        appkey = mapUniqueIdToUserId.get(bdmId) + '-' + obj.CRM_Mtg_Channel__c + '-' + obj.CRM_Mtg_Product__c;
                        settkey = mapUniqueIdToUserId.get(bdmId) + '-' + obj.CRM_Mtg_Channel__c + '-' + obj.CRM_Mtg_Product__c;
                    }
                    else{
                        tagToDefault = true;
                        obj.CRM_Mtg_Failure_Reason__c = 'Mortgage BDM does not exist on Broker';
                        if(String.IsBlank(obj.CRM_Mtg_BDM_SF_Id__c)){
                            obj.CRM_Mtg_Failure_Reason__c = 'BDM can\'t be found. Please check BDM SF ID';
                        }
                    }
                    
                    if(appkey != '' && settkey != '')
                    {
                        appkey += '-' + String.valueof(obj.CRM_Mtg_Application_Date__c.Month()) + '-' + String.valueof(obj.CRM_Mtg_Application_Date__c.Year());
                        
                        if(obj.CRM_Mtg_Settlement_Date__c != Null)
                        {
                            settkey += '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Month()) + '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Year());
                        }
                                                
                        if(mapTargets.containsKey(appkey) && mapTargets.get(appkey) != Null)
                        {
                            tagToDefault = false;
                            obj.CRM_Mtg_Application_Target__c = mapTargets.get(appkey).Id;    
                        }
                        else
                        {
                            tagToDefault = true;
                            obj.CRM_Mtg_Failure_Reason__c = 'Target record does not exist for BDM';
                        }   
                        
                        if(obj.CRM_Mtg_Settlement_Date__c != Null)
                        {
                            if(mapSettlements.containsKey(settkey) && mapSettlements.get(settkey) != Null)
                            {
                                tagToDefault = false;
                                obj.CRM_Mtg_Settlement_Target__c = mapSettlements.get(settkey).Id;
                            }
                            else
                            {
                                tagToDefault = true;
                                obj.CRM_Mtg_Failure_Reason__c = 'Target record does not exist for BDM';
                            }
                        }
                    }
                    
                    if(tagToDefault)
                    {
                        obj.CRM_Mtg_Application_Target__c = defaultTgtIdentifier; 
                        obj.CRM_Mtg_Settlement_Target__c = defaultSettIdentifier;
                    }
                    else
                    {
                        obj.CRM_Mtg_Failure_Reason__c = '';
                    }
                }
                else if(obj.CRM_Mtg_Channel__c == 'White Label')
                {
                    if(obj.CRM_Mtg_Application_State__c != Null)
                    {
                        if(mapARMIdToAccount.containsKey(aggregatorId) && mapARMIdToAccount.get(aggregatorId) != Null)
                        {
                            Account objacc = mapARMIdToAccount.get(aggregatorId);
                            
                            if(objacc.ChildAccounts != Null && objacc.ChildAccounts.size() > 0)
                            {
                                Boolean stateerror = true;
                                
                                for(Account objch : objacc.ChildAccounts)
                                {
                                    if(objch.CRM_Mtg_Aggregator_State__c != null && String.valueof(objch.CRM_Mtg_Aggregator_State__c).trim().toLowerCase() == String.valueof(obj.CRM_Mtg_Application_State__c).trim().toLowerCase())
                                    {
                                        stateerror = false;
                                        obj.CRM_Mtg_Aggregator__c = objch.Id;
                                    }
                                }
                                
                                if(stateerror)
                                {
                                    tagToDefault = true;
                                    obj.CRM_Mtg_Failure_Reason__c = 'State Aggregator does not exist for ' + obj.CRM_Mtg_Application_State__c;
                                }
                            }
                            else
                            {
                                tagToDefault = true;
                                obj.CRM_Mtg_Failure_Reason__c = 'State Aggregators does not exist in salesforce';
                            }
                        }
                        else
                        {
                            tagToDefault = true;
                            obj.CRM_Mtg_Failure_Reason__c = 'Aggregator does not exist in salesforce';
                        }
                    }
                    else
                    {
                        tagToDefault = true;
                        obj.CRM_Mtg_Failure_Reason__c = 'State does not exist on application';
                    }
                    
                    //Sandip -- added on 22/11/2017
                    if(mapUniqueIdToUserId.containsKey(bdmId) && mapUniqueIdToUserId.get(bdmId) != Null){
                        appkey = mapUniqueIdToUserId.get(bdmId) + '-' + obj.CRM_Mtg_Channel__c + '-' + obj.CRM_Mtg_Product__c; 
                        settkey = mapUniqueIdToUserId.get(bdmId) + '-' + obj.CRM_Mtg_Channel__c + '-' + obj.CRM_Mtg_Product__c; 
                        obj.CRM_Mtg_BDM__c = mapUniqueIdToUserId.get(bdmId);
                    }
                    else{
                        tagToDefault = true;
                        obj.CRM_Mtg_Failure_Reason__c = 'Mortgage Bdm does not exist for this state aggregator';
                        if(String.IsBlank(obj.CRM_Mtg_BDM_SF_Id__c)){
                            obj.CRM_Mtg_Failure_Reason__c = 'BDM can\'t be found. Please check BDM SF ID';
                        }
                    }
                    
                    if(appkey != '' && settkey != '')
                    {
                        appkey += '-' + String.valueof(obj.CRM_Mtg_Application_Date__c.Month()) + '-' + String.valueof(obj.CRM_Mtg_Application_Date__c.Year());
                        
                        if(obj.CRM_Mtg_Settlement_Date__c != Null)
                        {
                            settkey += '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Month()) + '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Year());
                        }
                        
                        if(mapTargets.containsKey(appkey) && mapTargets.get(appkey) != Null)
                        {
                            tagToDefault = false;
                            obj.CRM_Mtg_Application_Target__c = mapTargets.get(appkey).Id;
                        }
                        else
                        {
                            tagToDefault = true;
                            obj.CRM_Mtg_Failure_Reason__c = 'Target record does not exist for BDM';
                        }
                        
                        if(obj.CRM_Mtg_Settlement_Date__c != Null)
                        {
                            if(mapSettlements.containsKey(settkey) && mapSettlements.get(settkey) != Null)
                            {
                                tagToDefault = false;
                                obj.CRM_Mtg_Settlement_Target__c = mapSettlements.get(settkey).Id;
                            }
                            else
                            {
                                tagToDefault = true;
                                obj.CRM_Mtg_Failure_Reason__c = 'Target record does not exist for BDM';
                            }
                        }
                    }
                    
                    if(tagToDefault)
                    {
                        obj.CRM_Mtg_Application_Target__c = defaultTgtIdentifier; 
                        obj.CRM_Mtg_Settlement_Target__c = defaultSettIdentifier;
                    }
                    else
                    {
                        obj.CRM_Mtg_Failure_Reason__c = '';
                    }
                }
                else if(obj.CRM_Mtg_Channel__c == 'Direct')
                {
                    obj.CRM_Mtg_Failure_Reason__c = '';
                }
                else
                {
                    obj.CRM_Mtg_Failure_Reason__c = 'Incorrect Channel Name on Application.';
                }
            }
            else
            {
                obj.CRM_Mtg_Failure_Reason__c = 'Either of Channel, Product or Application Date is Null';
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for tagging the application to the BDM settlement target record 
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 16-FEB-2016        Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void UpdateSettledTargetVsAchieved(List<CRM_Mortgage_Application_Data__c> lstNew)
    {
        String defaultTgtIdentifier = '';
        String defaultSettIdentifier = '';
        
        Map<String,CRM_Mtg_Settlement_Target__c> mapSettlements = new map<String,CRM_Mtg_Settlement_Target__c>();
        set<Id> setBDMId = new set<Id>();
        
        String current_year = String.valueOf(System.Today().Year());
        String previous_year = String.valueOf(System.Today().Year() - 1);
        
        for(CRM_Mtg_Application_Target__c objtgt : [select Id from CRM_Mtg_Application_Target__c where CRM_Mtg_Is_Default__c = true Order By CreatedDate limit 1])
        {
            defaultTgtIdentifier = objtgt.Id;
        }
        
        for(CRM_Mtg_Settlement_Target__c objsett : [select Id from CRM_Mtg_Settlement_Target__c where CRM_Mtg_Is_Default__c = true Order By CreatedDate limit 1])
        {
            defaultSettIdentifier = objsett.Id;
        }
        
        for(CRM_Mortgage_Application_Data__c obj : lstNew)
        {
            if(obj.CRM_Mtg_BDM__c != Null){
                setBDMId.add(obj.CRM_Mtg_BDM__c);
            }
            
        }
        
        for(CRM_Mtg_Settlement_Target__c objsett : [select Id, CRM_Mtg_Unique_Identifier__c from CRM_Mtg_Settlement_Target__c where CRM_Mtg_Month__c != Null AND (CRM_Mtg_Year__c =: current_year OR CRM_Mtg_Year__c =: previous_year) AND CRM_Mtg_BDM_Target__r.CRM_Mtg_BDM__c IN : setBDMId])
        {
            mapSettlements.put(objsett.CRM_Mtg_Unique_Identifier__c, objsett);
        }
        
        for(CRM_Mortgage_Application_Data__c obj : lstNew)
        {
            String settkey = '';
            Boolean tagToDefault = false;
            
            if(obj.CRM_Mtg_Channel__c == 'Retail')
            {       
                if(obj.CRM_Mtg_BDM__c != Null ){
                    settkey = obj.CRM_Mtg_BDM__c + '-' + obj.CRM_Mtg_Channel__c;
                }
                else{
                    tagToDefault = true;
                    obj.CRM_Mtg_Failure_Reason__c = 'Mortgage BDM does not exist on Broker';
                    if(String.IsBlank(obj.CRM_Mtg_BDM_SF_Id__c)){
                        obj.CRM_Mtg_Failure_Reason__c = 'BDM can\'t be found. Please check BDM SF ID';
                    }
                }
                
                if(settkey != '')
                {
                    settkey += '-' + obj.CRM_Mtg_Product__c + '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Month()) + '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Year());
                                        
                    if(mapSettlements.containsKey(settkey) && mapSettlements.get(settkey) != Null)
                    {
                        tagToDefault = false;
                        obj.CRM_Mtg_Settlement_Target__c = mapSettlements.get(settkey).Id;
                    }
                    else
                    {
                        tagToDefault = true;
                        obj.CRM_Mtg_Failure_Reason__c = 'Target record does not exist for BDM';
                    }
                }
                
                if(tagToDefault)
                {
                    obj.CRM_Mtg_Settlement_Target__c = defaultSettIdentifier;
                }
                else
                {
                    obj.CRM_Mtg_Failure_Reason__c = '';
                }
            }
            else if(obj.CRM_Mtg_Channel__c == 'White Label')
            {
                
                if(obj.CRM_Mtg_BDM__c != Null){
                    settkey = obj.CRM_Mtg_BDM__c + '-' + obj.CRM_Mtg_Channel__c;
                }
                else{
                    tagToDefault = true;
                    obj.CRM_Mtg_Failure_Reason__c = 'Mortgage Bdm does not exist for this state aggregator';
                    if(String.IsBlank(obj.CRM_Mtg_BDM_SF_Id__c)){
                        obj.CRM_Mtg_Failure_Reason__c = 'BDM can\'t be found. Please check BDM SF ID';
                    }
                }
                
                
                if(settkey != '')
                {
                    settkey += '-' + obj.CRM_Mtg_Product__c + '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Month()) + '-' + String.valueof(obj.CRM_Mtg_Settlement_Date__c.Year());
                                        
                    if(mapSettlements.containsKey(settkey) && mapSettlements.get(settkey) != Null)
                    {
                        obj.CRM_Mtg_Settlement_Target__c = mapSettlements.get(settkey).Id;
                    }
                    else
                    {
                        tagToDefault = true;
                        obj.CRM_Mtg_Failure_Reason__c = 'Target record does not exist for BDM';
                    }
                }
                
                if(tagToDefault)
                {
                    obj.CRM_Mtg_Settlement_Target__c = defaultSettIdentifier;
                }
                else
                {
                    obj.CRM_Mtg_Failure_Reason__c = '';
                }
            }
            else if(obj.CRM_Mtg_Channel__c == 'Direct')
            {
                obj.CRM_Mtg_Failure_Reason__c = '';
            }
        }
    }
    
    public void updateOpportunityLookup(List<CRM_Mortgage_Application_Data__c> lstNew,Map<Id,CRM_Mortgage_Application_Data__c> mapOld){
        
        set<String> setScenarioLeadId = new set<String>();
        set<String> setPPSLeadId = new set<String>();
        set<String> setApplicationId = new set<String>();
        List<CRM_Mortgage_Application_Data__c> lstMortgageApplication = new List<CRM_Mortgage_Application_Data__c>();
        for(CRM_Mortgage_Application_Data__c objApplication : lstNew){
            if(
                (Trigger.isInsert && objApplication.CRM_Mtg_Opportunity__c == null 
                    && !String.isBlank(objApplication.Lead_ID__c) 
                    && !String.isBlank(objApplication.Lead_Source_Type__c) 
                    && (objApplication.Lead_Source_Type__c.equalsIgnoreCase('Scenario') 
                        || 
                        objApplication.Lead_Source_Type__c.equalsIgnoreCase('PepperProductSelector')
                        || 
                        objApplication.Lead_Source_Type__c.equalsIgnoreCase('Resolve')
                        )
                )   
                ||  
                (Trigger.IsUpdate && !String.isBlank(objApplication.Lead_ID__c) 
                    && objApplication.Lead_ID__c != mapOld.get(objApplication.ID).Lead_ID__c 
                    && !String.isBlank(objApplication.Lead_Source_Type__c) 
                    && (objApplication.Lead_Source_Type__c.equalsIgnoreCase('Scenario') 
                        || 
                        objApplication.Lead_Source_Type__c.equalsIgnoreCase('PepperProductSelector')
                        || 
                        objApplication.Lead_Source_Type__c.equalsIgnoreCase('Resolve')
                        )   
                )
            ){
                if(objApplication.Lead_Source_Type__c.equalsIgnoreCase('Scenario')){
                    setScenarioLeadId.add(objApplication.Lead_ID__c);
                }
                if(objApplication.Lead_Source_Type__c.equalsIgnoreCase('PepperProductSelector') || objApplication.Lead_Source_Type__c.equalsIgnoreCase('Resolve')){
                    setPPSLeadId.add(objApplication.Lead_ID__c);
                }
                lstMortgageApplication.add(objApplication);
            }
            else if(
                (Trigger.IsInsert && objApplication.CRM_Mtg_Opportunity__c == null
                    && !String.isBlank(objApplication.CRM_Mtg_Application_Id__c) 
                    && !String.IsBlank(objApplication.CRM_Mtg_Channel__c) 
                    && objApplication.CRM_Mtg_Channel__c.equalsIgnoreCase('Direct')
                ) 
                || 
                (Trigger.isUpdate && !String.isBlank(objApplication.CRM_Mtg_Application_Id__c) 
                    && objApplication.CRM_Mtg_Application_Id__c != mapOld.get(objApplication.Id).CRM_Mtg_Application_Id__c 
                    && !String.IsBlank(objApplication.CRM_Mtg_Channel__c) 
                    && objApplication.CRM_Mtg_Channel__c.equalsIgnoreCase('Direct')
                )
            ){
                
                setApplicationId.add(objApplication.CRM_Mtg_Application_Id__c);
                lstMortgageApplication.add(objApplication);
            }
        }
        system.debug('@@ set '+ setApplicationId);
        if((setScenarioLeadId != null && setScenarioLeadId.size() > 0 ) || (setPPSLeadId != null && setPPSLeadId.size() > 0 ) || (setApplicationId != null && setApplicationId.Size() > 0)){
            
            List<Opportunity> lstOpportunity = [Select Id,CRM_Lead_ID__c,CRM_Application_ID__c,LeadSource From Opportunity Where ((CRM_Lead_ID__c in : setScenarioLeadId and LeadSource = 'Scenario') or (CRM_Lead_ID__c in : setPPSLeadId and (LeadSource = 'PPS' or LeadSource = 'Resolve')) or CRM_Application_ID__c in : setApplicationId)];
            system.debug('@@ lstOpp '+ lstOpportunity);
            map<String,Opportunity> mapLeadIdToOpportunity = new map<String,Opportunity>();
            map<String,Opportunity> mapApplicationIdToOpportunity = new map<String,Opportunity>();
            
            for(Opportunity opp : lstOpportunity){
                if(!String.IsBlank(opp.CRM_Lead_ID__c) && setScenarioLeadId.contains(opp.CRM_Lead_ID__c) && opp.LeadSource.equalsIgnoreCase('Scenario')){
                    mapLeadIdToOpportunity.put(opp.CRM_Lead_ID__c,opp);
                }
                else if(!String.IsBlank(opp.CRM_Lead_ID__c) && setPPSLeadId.contains(opp.CRM_Lead_ID__c) && opp.LeadSource.equalsIgnoreCase('PPS')){
                    mapLeadIdToOpportunity.put(opp.CRM_Lead_ID__c,opp);
                }    
                else if(!String.IsBlank(opp.CRM_Lead_ID__c) && setPPSLeadId.contains(opp.CRM_Lead_ID__c) && opp.LeadSource.equalsIgnoreCase('Resolve')){
                    mapLeadIdToOpportunity.put(opp.CRM_Lead_ID__c,opp);
                }
                if(!String.IsBlank(opp.CRM_Application_ID__c) && setApplicationId.contains(opp.CRM_Application_ID__c)){
                    mapApplicationIdToOpportunity.put(opp.CRM_Application_ID__c,opp);
                }
            }
            
            for(CRM_Mortgage_Application_Data__c objApplication : lstMortgageApplication){
                if(
                    (Trigger.isInsert && objApplication.CRM_Mtg_Opportunity__c == null 
                        && !String.isBlank(objApplication.Lead_ID__c) 
                        && !String.isBlank(objApplication.Lead_Source_Type__c) 
                        && (objApplication.Lead_Source_Type__c.equalsIgnoreCase('Scenario') 
                            || 
                            objApplication.Lead_Source_Type__c.equalsIgnoreCase('PepperProductSelector')
                            || 
                            objApplication.Lead_Source_Type__c.equalsIgnoreCase('Resolve')
                            )
                    )   
                    ||  
                    (Trigger.IsUpdate && !String.isBlank(objApplication.Lead_ID__c) 
                        && objApplication.Lead_ID__c != mapOld.get(objApplication.ID).Lead_ID__c 
                        && !String.isBlank(objApplication.Lead_Source_Type__c) 
                        && (objApplication.Lead_Source_Type__c.equalsIgnoreCase('Scenario') 
                            || 
                            objApplication.Lead_Source_Type__c.equalsIgnoreCase('PepperProductSelector')
                            || 
                            objApplication.Lead_Source_Type__c.equalsIgnoreCase('Resolve')
                            )   
                    )
                ){
                    if(mapLeadIdToOpportunity.containsKey(objApplication.Lead_ID__c) && mapLeadIdToOpportunity.get(objApplication.Lead_ID__c) != null){
                        objApplication.CRM_Mtg_Opportunity__c = mapLeadIdToOpportunity.get(objApplication.Lead_ID__c).Id;
                    }
                }
                else if(
                    (Trigger.IsInsert && objApplication.CRM_Mtg_Opportunity__c == null
                        && !String.isBlank(objApplication.CRM_Mtg_Application_Id__c) 
                        && !String.IsBlank(objApplication.CRM_Mtg_Channel__c) 
                        && objApplication.CRM_Mtg_Channel__c.equalsIgnoreCase('Direct')
                    ) 
                    || 
                    (Trigger.isUpdate && !String.isBlank(objApplication.CRM_Mtg_Application_Id__c) 
                        && objApplication.CRM_Mtg_Application_Id__c != mapOld.get(objApplication.Id).CRM_Mtg_Application_Id__c 
                        && !String.IsBlank(objApplication.CRM_Mtg_Channel__c) 
                        && objApplication.CRM_Mtg_Channel__c.equalsIgnoreCase('Direct')
                    )
                ){
                    
                    if(mapApplicationIdToOpportunity.containsKey(objApplication.CRM_Mtg_Application_Id__c) && mapApplicationIdToOpportunity.get(objApplication.CRM_Mtg_Application_Id__c) != null){
                        objApplication.CRM_Mtg_Opportunity__c = mapApplicationIdToOpportunity.get(objApplication.CRM_Mtg_Application_Id__c).Id;
                    }
                }
            }
        }
        
    }
}