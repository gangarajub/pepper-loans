// --------------------------------------------------------------------------------------------------------
// This class would handle all trigger relaged operations of the Contact trigger
// --------------------------------------------------------------------------------------------------------
// Created Date : 25-APR-2017         Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : CRM_Mtg_TestContactTriggerHandler
// -------------------------------------------------------------------------------------------------------- 
public  class CRM_Mtg_ContactTriggerHandler 
{ 
    //This method will handle all before insert operations 
    public void onBeforeInsert(List<Contact> lstNew)
    {
        List<Contact> lstContact = new List<Contact>();
        List<Contact> lstContactMobilePhone = new List<Contact>();
        for(Contact obj : lstNew)
        {
            if(obj.AccountId != Null)
            {
                obj.CRM_Mtg_Aggregator_Relationship_Created__c = System.Now();
            }
            
            if(obj.CRM_Mtg_Mortgage_BDM__c != Null)
            {
                obj.CRM_Mtg_BDM_Relationship_Created__c = System.Now();
            }
            
            if((obj.CRM_Mtg_Accreditation_Status__c == 'Active' || obj.PL_Accreditation_Status__c == 'Active') && obj.CRM_Mtg_Unique_Id__c == Null)
            {
                lstContact.add(obj);
            }
            
            if(obj.mobilephone != NULL && obj.CRM_Mtg_Unique_Id__c != Null)
            {
                lstContactMobilePhone.add(obj);
            }
        }
        
        if(lstContact != Null && lstContact.size() > 0)
        {
            populateUniqueId(lstContact);
        }
        
        if(lstContactMobilePhone != Null && lstContactMobilePhone.size() > 0)
        {
            updateMobilePhone(lstContactMobilePhone);
        }
    }
    
    //This method will handle all after insert operations 
    public void onAfterInsert(List<Contact> lstNew)
    {
        
    }
    
    //This method will handle all before update operations 
    public void onBeforeUpdate(List<Contact> lstNew, Map<Id,Contact> oldMap)
    {
        List<Contact> lstContact = new List<Contact>();
        List<Contact> lstContactMobilePhone = new List<Contact>();
        
        for(Contact obj : lstNew)
        {
            if((obj.CRM_Mtg_Accreditation_Status__c == 'Active' || obj.PL_Accreditation_Status__c == 'Active') && obj.CRM_Mtg_Unique_Id__c == Null && oldMap.get(obj.Id).CRM_Mtg_Accreditation_Status__c != 'Active')
            {
                lstContact.add(obj);
            }
            
            if(obj.mobilephone != NULL && obj.mobilephone != oldMap.get(obj.Id).mobilephone && obj.CRM_Mtg_Unique_Id__c != Null)
            {
                lstContactMobilePhone.add(obj);
            }
        }
        
        if(lstContact != Null && lstContact.size() > 0)
        {
            populateUniqueId(lstContact);
        }
        
        if(lstContactMobilePhone != Null && lstContactMobilePhone.size() > 0)
        {
            updateMobilePhone(lstContactMobilePhone);
        }
    }
    
    //This method will handle all after update operations 
    public void onAfterUpdate(List<Contact> lstNew, Map<Id,Contact> oldMap)
    {
        
    }
    
    //this method populates unique id on newly created contact record for mortgage bdms
    public void populateUniqueId(List<Contact> lstContact)
    {
        Decimal maxValue = 1000;
        
        AggregateResult[] groupedResults = [select MAX(CRM_Mtg_Unique_Id__c) maxId from Contact where CRM_Mtg_Unique_Id__c != Null];
        
        for(AggregateResult ar : groupedResults)  
        {
            if(ar.get('maxId') != Null)
            {
                maxValue = Decimal.valueof(ar.get('maxId') + '');
            }
        }
        
        for(Contact obj : lstContact)
        {
            obj.CRM_Mtg_Unique_Id__c = maxValue + 1;
            obj.CRM_Mtg_Accreditation_Id__c = String.valueOf(obj.CRM_Mtg_Unique_Id__c);
            maxValue += 1;
        }
    }
    
    public void updateMobilePhone(List<Contact> lstContactNew)
    {
        String mobilenumber = '';
        for(Contact c: lstContactNew)
        {
            mobilenumber = c.mobilephone;
            mobilenumber = mobilenumber.deleteWhitespace();
            if(mobilenumber.startsWith('0'))
            {
                mobilenumber = mobilenumber.removeStart('0');
                mobilenumber = '61'+mobilenumber;
                c.mobilephone = mobilenumber;
                system.debug('c.mobilephone     '+c.mobilephone);
              //  listContactsUpdated.add(c);
            } else if(mobilenumber.startsWith('+61'))
            {
                mobilenumber = c.MobilePhone;
                mobilenumber  = mobilenumber .replace('+','');
                c.MobilePhone = mobilenumber;
              //  lstContactUpdated.add(c);
            }
        }
    }
}