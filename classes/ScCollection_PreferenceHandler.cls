//  -------------------------------------------------------------------------------------------------------
//  This class handles all the trigger events on collect__Contact_Preference__c Object
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 06-OCT-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestPreferenceHandler
//  -------------------------------------------------------------------------------------------------------
public class ScCollection_PreferenceHandler 
{
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after insert events on contact preference Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 06-OCT-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<collect__Contact_Preference__c> lstNew)
    {
        List<collect__Contact_Preference__c> lstUpdateList = new List<collect__Contact_Preference__c>();

        for(collect__Contact_Preference__c obj : lstNew)
        {
            if(obj.collect__Preferred__c)
            {
                lstUpdateList.add(obj);
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(lstUpdateList))
        {
            updateContactPreference(lstUpdateList);
            updateContractStatus(lstUpdateList);
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on contact preference Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(List<collect__Contact_Preference__c> lstNew, Map<Id,collect__Contact_Preference__c> mapOld)
    {
        List<collect__Contact_Preference__c> lstUpdateCPList = new List<collect__Contact_Preference__c>();
        List<collect__Contact_Preference__c> lstUpdateCSList = new List<collect__Contact_Preference__c>();
        
        for(collect__Contact_Preference__c obj : lstNew)
        {
            if(obj.collect__Preferred__c && mapOld.get(obj.Id).collect__Preferred__c != true)
            {
                lstUpdateCPList.add(obj);
                lstUpdateCSList.add(obj);
            }
            else if(obj.collect__Preferred__c && (obj.collect__Start_Time__c != mapOld.get(obj.Id).collect__Start_Time__c || obj.collect__End_Time__c != mapOld.get(obj.Id).collect__End_Time__c))
            {
                lstUpdateCSList.add(obj);
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(lstUpdateCPList))
        {
            updateContactPreference(lstUpdateCPList);
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdateCSList))
        {
            updateContractStatus(lstUpdateCSList);
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to update prefered on contract preference
    // ---------------------------------------------------------------------------------------------------
    // created Date : 06-OCT-2016   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void updateContactPreference(List<collect__Contact_Preference__c> lstNew)
    {
        Map<Id,List<collect__Contact_Preference__c>> mapPartyToContactPreference = new Map<Id,List<collect__Contact_Preference__c>>();
        Set<Id> setIds = new Set<Id>();
        List<collect__Contact_Preference__c> lstUpdateCP = new List<collect__Contact_Preference__c>();
        
        for(collect__Contact_Preference__c obj : lstNew)
        {
            if(obj.collect__Party__c != Null)
            {
                setIds.add(obj.collect__Party__c);
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(setIds))
        {
            for(clcommon__Party__c obj : [select Id, (select Id, collect__Preferred__c from collect__Contact_Preferences__r) from clcommon__Party__c where Id IN : setIds])
            {
                if(obj.collect__Contact_Preferences__r != Null && obj.collect__Contact_Preferences__r.size() > 0)
                {
                    mapPartyToContactPreference.put(obj.Id,obj.collect__Contact_Preferences__r);
                }
            }
        }
        
        for(collect__Contact_Preference__c obj : lstNew)
        {
            if(obj.collect__Party__c != Null && mapPartyToContactPreference.containsKey(obj.collect__Party__c) && mapPartyToContactPreference.get(obj.collect__Party__c) != Null)
            {
                for(collect__Contact_Preference__c objcp : mapPartyToContactPreference.get(obj.collect__Party__c))
                {
                    if(objcp.Id != obj.Id && objcp.collect__Preferred__c)
                    {
                        objcp.collect__Preferred__c = false;
                        lstUpdateCP.add(objcp);
                    }
                }
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdateCP))
        {
            try
            {
                update lstUpdateCP;
            }
            catch(Exception e)
            {
                system.debug('Error in updating contact preference : ' + e.getMessage());
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to update contract status on contract
    // ---------------------------------------------------------------------------------------------------
    // created Date : 06-OCT-2016   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void updateContractStatus(List<collect__Contact_Preference__c> lstNew)
    {
        List<collect__Contract_Status__c> lstContractStatusUpdate = new List<collect__Contract_Status__c>();
        
        for(collect__Contact_Preference__c obj : lstNew)
        {
            if(obj.ScCollection_Contract_Status_Id__c != Null)
            {
                collect__Contract_Status__c objstatus = new collect__Contract_Status__c(Id=obj.ScCollection_Contract_Status_Id__c);
                
                if(obj.collect__Start_Time__c != Null && obj.collect__End_Time__c != Null)
                {
                    objstatus.ScCollection_Preferred_Start_Time__c = obj.collect__Start_Time__c.format('hh:mm a');
                    objstatus.ScCollection_Preferred_End_Time__c = obj.collect__End_Time__c.format('hh:mm a');
                    lstContractStatusUpdate.add(objstatus);
                }
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(lstContractStatusUpdate))
        {
            try
            {
                update lstContractStatusUpdate;
            }
            catch(Exception e)
            {
                system.debug('Error in updating contract status with preferred time : ' + e.getMessage());
            }    
        }
    }
}