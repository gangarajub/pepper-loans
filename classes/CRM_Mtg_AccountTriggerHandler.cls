// --------------------------------------------------------------------------------------------------------
// This class would handle all trigger relaged operations of the Account trigger
// --------------------------------------------------------------------------------------------------------
// Created Date : 25-APR-2017         Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : CRM_Mtg_TestAccountTriggerHandler
// -------------------------------------------------------------------------------------------------------- 
public  class CRM_Mtg_AccountTriggerHandler 
{ 
    //This method will handle all before insert operations 
    public void onBeforeInsert(List<Account> lstNew)
    {
        List<Account> lstAccount = new List<Account>();
        
        for(Account obj : lstNew)
        {
            if(obj.CRM_Mtg_Accreditation_Status__c == 'Active' && obj.CRM_Mtg_Unique_Id__c == Null)
            {
                lstAccount.add(obj);
            }
        }
        
        if(lstAccount != Null && lstAccount.size() > 0)
        {
            populateUniqueId(lstAccount);
        }
    }
    
    //This method will handle all before update operations 
    public void onAfterInsert(List<Account> lstNew)
    {
        
    }
    
    //This method will handle all before update operations 
    public void onBeforeUpdate(List<Account> lstNew, Map<Id,Account> oldMap)
    {
        List<Account> lstAccount = new List<Account>();
        
        for(Account obj : lstNew)
        {
            if(obj.CRM_Mtg_Accreditation_Status__c == 'Active' && obj.CRM_Mtg_Unique_Id__c == Null && oldMap.get(obj.Id).CRM_Mtg_Accreditation_Status__c != 'Active')
            {
                lstAccount.add(obj);
            }
        }
        
        if(lstAccount != Null && lstAccount.size() > 0)
        {
            populateUniqueId(lstAccount);
        }
    }
    
    //This method will handle all before update operations 
    public void onAfterUpdate(List<Account> lstNew, Map<Id,Account> oldMap)
    {
        
    }
    
    //this method populates unique id on newly created contact record for mortgage bdms
    public void populateUniqueId(List<Account> lstAccount)
    {
        Decimal maxValue = 1000;
        
        AggregateResult[] groupedResults = [select MAX(CRM_Mtg_Unique_Id__c) maxId from Account where CRM_Mtg_Unique_Id__c != Null];
        
        for(AggregateResult ar : groupedResults)  
        {
            if(ar.get('maxId') != Null)
            {
                maxValue = Decimal.valueof(ar.get('maxId') + '');
            }
        }
        
        for(Account obj : lstAccount)
        {
            obj.CRM_Mtg_Unique_Id__c = maxValue + 1;
            maxValue += 1;
        }
    }
}