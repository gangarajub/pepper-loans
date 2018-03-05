//  -------------------------------------------------------------------------------------------------------
//  This batch class handles all the logic to roll up MTD, YTD and Last Year counts for Applications and 
//  Settlements on Contact for CRM Mortgages
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 16-FEB-2016        Created By: Pawan Mudgal            Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : CRM_Mtg_TestBatchToUpdateAppCount
//  -------------------------------------------------------------------------------------------------------
global class CRM_Mtg_UpdateContactAppCount implements Database.Batchable<sObject>
{
    global String strQuery;
    
    public CRM_Mtg_UpdateContactAppCount()     
    {
        strQuery = 'select Id from Contact where CRM_Mtg_Unique_Id__c != Null';
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {       
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {    
        Map<Id,Contact> mapBroker = new Map<Id,Contact>();
        Set<Id> setContactId = new Set<Id>();
        
        Map<Integer,String> mapMonthName = new map<Integer,String>();
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
        
        Map<String,Integer> mapQuarterName = new map<String,Integer>();
        mapQuarterName.put('Jan',1);
        mapQuarterName.put('Feb',1);
        mapQuarterName.put('Mar',1);
        mapQuarterName.put('Apr',2);
        mapQuarterName.put('May',2);
        mapQuarterName.put('Jun',2);
        mapQuarterName.put('Jul',3);
        mapQuarterName.put('Aug',3);
        mapQuarterName.put('Sep',3);
        mapQuarterName.put('Oct',4);
        mapQuarterName.put('Nov',4);
        mapQuarterName.put('Dec',4);
        
        Date startDate = date.newinstance(System.Today().Year() - 1, System.Today().Month(), 01);
        Date endDate = date.newinstance(System.Today().Year(), System.Today().Month(), System.Today().Day());
               
        for(Contact obj : (List<Contact>)scope)
        {
            obj.CRM_Mtg_Apps_MTD_Amt__c = 0;
            obj.CRM_Mtg_Apps_YTD_Amt__c = 0;
            obj.CRM_Mtg_Setts_MTD_Amt__c = 0;
            obj.CRM_Mtg_Setts_YTD_Amt__c = 0;
            obj.CRM_Mtg_Apps_MTD__c = 0;
            obj.CRM_Mtg_Apps_YTD__c = 0;
            obj.CRM_Mtg_Setts_MTD__c = 0;
            obj.CRM_Mtg_Setts_YTD__c = 0;
            obj.CRM_Mtg_Apps_Last_Year__c = 0;
            obj.CRM_Mtg_Setts_Last_Year__c = 0;
            obj.CRM_Mtg_Apps_QTD__c = 0;
            obj.CRM_Mtg_Setts_QTD__c = 0;
            obj.CRM_Mtg_Apps_Last_Quarter__c = 0;
            obj.CRM_Mtg_Setts_Last_Quarter__c = 0;
            
            setContactId.add(obj.Id);
            mapBroker.put(obj.Id,obj);
        }
            
        //aggregate query to calculate no of applications and Application Amount for MTD, YTD and the last 12 months for each broker
        for(AggregateResult objbrk : [select CRM_Mtg_Broker__c, CRM_Mtg_Application_Month__c, CRM_Mtg_Application_Year__c, Count(Id) totalapps, Sum(CRM_Mtg_Application_Amount__c) totalamt from CRM_Mortgage_Application_Data__c where CRM_Mtg_Broker__c != Null AND CRM_Mtg_Broker__c IN : setContactId AND CRM_Mtg_Application_Month__c != Null AND CRM_Mtg_Application_Year__c != Null AND CRM_Mtg_Application_Date__c >=: startDate AND CRM_Mtg_Application_Date__c <=: endDate Group By CRM_Mtg_Broker__c,CRM_Mtg_Application_Year__c,CRM_Mtg_Application_Month__c])
        {
            Contact objcontact;             
            
            Id contactId = Id.valueOf(objbrk.get('CRM_Mtg_Broker__c') + '');
            String strMonth = String.valueOf(objbrk.get('CRM_Mtg_Application_Month__c') + '');
            String strYear = String.valueOf(objbrk.get('CRM_Mtg_Application_Year__c') + '');
            Decimal totalapplications = 0;
            Decimal totalamount = 0;
            
            if(String.valueOf(objbrk.get('totalapps') + '') != Null && String.valueOf(objbrk.get('totalapps') + '') != '')
            {
                totalapplications = Decimal.valueOf(objbrk.get('totalapps') + '');
            }
            
            if(String.valueOf(objbrk.get('totalamt') + '') != Null && String.valueOf(objbrk.get('totalamt') + '') != '')
            {
                totalamount = Decimal.valueOf(objbrk.get('totalamt') + '');
            }
            
            if(mapBroker.containsKey(contactId) && mapBroker.get(contactId) != Null)
            {
                objcontact = mapBroker.get(contactId);
                
                if(strYear == String.valueOf(System.Today().Year()))
                {
                    if(strMonth == mapMonthName.get(System.Today().Month()))
                    {
                        objcontact.CRM_Mtg_Apps_MTD__c += totalapplications;
                        objcontact.CRM_Mtg_Apps_MTD_Amt__c += totalamount;
                    }
                    else
                    {
                        objcontact.CRM_Mtg_Apps_Last_Year__c += totalapplications;
                    }
                    
                    objcontact.CRM_Mtg_Apps_YTD__c += totalapplications;
                    objcontact.CRM_Mtg_Apps_YTD_Amt__c += totalamount;
                    
                    if(mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())))
                    {
                        objcontact.CRM_Mtg_Apps_QTD__c += totalapplications;
                    }
                }
                else
                {
                    objcontact.CRM_Mtg_Apps_Last_Year__c += totalapplications;
                }
                
                if(mapQuarterName.get(mapMonthName.get(System.Today().Month())) == 1)
                {
                    if(strYear == String.valueOf(System.Today().Year() - 1) && mapQuarterName.get(strMonth) == 4)
                    {
                        objcontact.CRM_Mtg_Apps_Last_Quarter__c += totalapplications;
                    }
                }
                else
                {
                    if(strYear == String.valueOf(System.Today().Year()) && mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())) - 1)
                    {
                        objcontact.CRM_Mtg_Apps_Last_Quarter__c += totalapplications;
                    }
                }
                
                mapBroker.put(contactId,objcontact);
            }
        }
        
        //aggregate query to calculate no of settlements and settled Amount for MTD, YTD and the last 12 months for each broker
        for(AggregateResult objbrk : [select CRM_Mtg_Broker__c, CRM_Mtg_Settlement_Month__c, CRM_Mtg_Settlement_Year__c, Count(Id) totalapps, Sum(CRM_Mtg_Settlement_Amount__c) totalamt from CRM_Mortgage_Application_Data__c where CRM_Mtg_Broker__c != Null AND CRM_Mtg_Broker__c IN : setContactId AND CRM_Mtg_Settlement_Month__c != Null AND CRM_Mtg_Settlement_Year__c != Null AND CRM_Mtg_Settlement_Date__c >=: startDate AND CRM_Mtg_Settlement_Date__c <=: endDate Group By CRM_Mtg_Broker__c,CRM_Mtg_Settlement_Year__c,CRM_Mtg_Settlement_Month__c])
        {
            Contact objcontact;             
            
            Id contactId = Id.valueOf(objbrk.get('CRM_Mtg_Broker__c') + '');
            String strMonth = String.valueOf(objbrk.get('CRM_Mtg_Settlement_Month__c') + '');
            String strYear = String.valueOf(objbrk.get('CRM_Mtg_Settlement_Year__c') + '');
            Decimal totalsettlements = 0;
            Decimal totalamount = 0;
            
            if(String.valueOf(objbrk.get('totalapps') + '') != Null && String.valueOf(objbrk.get('totalapps') + '') != '')
            {
                totalsettlements = Decimal.valueOf(objbrk.get('totalapps') + '');
            }
            
            if(String.valueOf(objbrk.get('totalamt') + '') != Null && String.valueOf(objbrk.get('totalamt') + '') != '')
            {
                totalamount = Decimal.valueOf(objbrk.get('totalamt') + '');
            }
            
            if(mapBroker.containsKey(contactId) && mapBroker.get(contactId) != Null)
            {
                objcontact = mapBroker.get(contactId);
                
                if(strYear == String.valueOf(System.Today().Year()))
                {
                    if(strMonth == mapMonthName.get(System.Today().Month()))
                    {
                        objcontact.CRM_Mtg_Setts_MTD__c += totalsettlements;
                        objcontact.CRM_Mtg_Setts_MTD_Amt__c += totalamount;
                    }
                    else
                    {
                        objcontact.CRM_Mtg_Setts_Last_Year__c += totalsettlements;
                    }
                    
                    objcontact.CRM_Mtg_Setts_YTD__c += totalsettlements;
                    objcontact.CRM_Mtg_Setts_YTD_Amt__c += totalamount;
                    
                    if(mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())))
                    {
                        objcontact.CRM_Mtg_Setts_QTD__c += totalsettlements;
                    }
                }
                else
                {
                    objcontact.CRM_Mtg_Setts_Last_Year__c += totalsettlements;
                }
                
                if(mapQuarterName.get(mapMonthName.get(System.Today().Month())) == 1)
                {
                    if(strYear == String.valueOf(System.Today().Year() - 1) && mapQuarterName.get(strMonth) == 4)
                    {
                        objcontact.CRM_Mtg_Setts_Last_Quarter__c += totalsettlements;
                    }
                }
                else
                {
                    if(strYear == String.valueOf(System.Today().Year()) && mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())) - 1)
                    {
                        objcontact.CRM_Mtg_Setts_Last_Quarter__c += totalsettlements;
                    }
                }
                
                mapBroker.put(contactId,objcontact);
            }
        }
        
        if(mapBroker != Null && mapBroker.size() > 0)
        {
            try
            {
                update mapBroker.values();
            }
            catch(Exception ex)
            {
                System.debug('Message == : ' + ex.getMessage());
                System.debug('Stack Trace == : ' + ex.getStackTraceString());
            }
        }
    }

    global void finish(Database.BatchableContext BC)
    {
    }
}