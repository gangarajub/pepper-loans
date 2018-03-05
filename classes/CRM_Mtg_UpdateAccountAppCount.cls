//  -------------------------------------------------------------------------------------------------------
//  This batch class handles all the logic to roll up MTD, YTD and Last Year counts for Applications and 
//  Settlements on Account for CRM Mortgages
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 16-FEB-2016        Created By: Pawan Mudgal            Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : CRM_Mtg_TestBatchToUpdateAppCount
//  -------------------------------------------------------------------------------------------------------
global class CRM_Mtg_UpdateAccountAppCount implements Database.Batchable<sObject>
{
    global String strQuery;
    
    public CRM_Mtg_UpdateAccountAppCount()     
    {
        strQuery = 'select Id from Account where CRM_Mtg_Unique_Id__c != Null';
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {       
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {    
        Map<Id,Account> mapAggregator = new Map<Id,Account>();
        Set<Id> setAccountId = new Set<Id>();
        
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
        
        for(Account obj : (List<Account>)scope)
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
            
            setAccountId.add(obj.Id);            
            mapAggregator.put(obj.Id,obj);
        }
            
        //aggregate query to calculate no of applications and Application Amount for MTD, YTD and the last 12 months for each aggregator
        for(AggregateResult objagg : [select CRM_Mtg_Aggregator__c, CRM_Mtg_Application_Month__c, CRM_Mtg_Application_Year__c, Count(Id) totalapps, Sum(CRM_Mtg_Application_Amount__c) totalamt from CRM_Mortgage_Application_Data__c where CRM_Mtg_Aggregator__c != Null AND CRM_Mtg_Aggregator__c IN : setAccountId AND CRM_Mtg_Application_Month__c != Null AND CRM_Mtg_Application_Year__c != Null AND CRM_Mtg_Application_Date__c >=: startDate AND CRM_Mtg_Application_Date__c <=: endDate Group By CRM_Mtg_Aggregator__c,CRM_Mtg_Application_Year__c,CRM_Mtg_Application_Month__c])
        {
            Account objaccount;
            
            Id accountId = Id.valueOf(objagg.get('CRM_Mtg_Aggregator__c') + '');
            String strMonth = String.valueOf(objagg.get('CRM_Mtg_Application_Month__c') + '');
            String strYear = String.valueOf(objagg.get('CRM_Mtg_Application_Year__c') + '');
            Decimal totalapplications = 0;
            Decimal totalamount = 0;
            
            if(String.valueOf(objagg.get('totalapps') + '') != Null && String.valueOf(objagg.get('totalapps') + '') != '')
            {
                totalapplications = Decimal.valueOf(objagg.get('totalapps') + '');
            }
            
            if(String.valueOf(objagg.get('totalamt') + '') != Null && String.valueOf(objagg.get('totalamt') + '') != '')
            {
                totalamount = Decimal.valueOf(objagg.get('totalamt') + '');
            }
            
            if(mapAggregator.containsKey(accountId) && mapAggregator.get(accountId) != Null)
            {
                objaccount = mapAggregator.get(accountId);
                
                if(strYear == String.valueOf(System.Today().Year()))
                {
                    if(strMonth == mapMonthName.get(System.Today().Month()))
                    {
                        objaccount.CRM_Mtg_Apps_MTD__c += totalapplications;
                        objaccount.CRM_Mtg_Apps_MTD_Amt__c += totalamount;
                    }
                    else
                    {
                        objaccount.CRM_Mtg_Apps_Last_Year__c += totalapplications;
                    }
                    
                    objaccount.CRM_Mtg_Apps_YTD__c += totalapplications;
                    objaccount.CRM_Mtg_Apps_YTD_Amt__c += totalamount;
                    
                    if(mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())))
                    {
                        objaccount.CRM_Mtg_Apps_QTD__c += totalapplications;
                    }
                }
                else
                {
                    objaccount.CRM_Mtg_Apps_Last_Year__c += totalapplications;
                }
                
                if(mapQuarterName.get(mapMonthName.get(System.Today().Month())) == 1)
                {
                    if(strYear == String.valueOf(System.Today().Year() - 1) && mapQuarterName.get(strMonth) == 4)
                    {
                        objaccount.CRM_Mtg_Apps_Last_Quarter__c += totalapplications;
                    }
                }
                else
                {
                    if(strYear == String.valueOf(System.Today().Year()) && mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())) - 1)
                    {
                        objaccount.CRM_Mtg_Apps_Last_Quarter__c += totalapplications;
                    }
                }
                
                mapAggregator.put(accountId,objaccount);
            }
        }
        
        //aggregate query to calculate no of settlements and settled Amount for MTD, YTD and the last 12 months for each aggregator
        for(AggregateResult objagg : [select CRM_Mtg_Aggregator__c, CRM_Mtg_Settlement_Month__c, CRM_Mtg_Settlement_Year__c, Count(Id) totalapps, Sum(CRM_Mtg_Settlement_Amount__c) totalamt from CRM_Mortgage_Application_Data__c where CRM_Mtg_Aggregator__c != Null AND CRM_Mtg_Aggregator__c IN : setAccountId AND CRM_Mtg_Settlement_Month__c != Null AND CRM_Mtg_Settlement_Year__c != Null AND CRM_Mtg_Settlement_Date__c >=: startDate AND CRM_Mtg_Settlement_Date__c <=: endDate Group By CRM_Mtg_Aggregator__c,CRM_Mtg_Settlement_Year__c,CRM_Mtg_Settlement_Month__c])
        {
            Account objaccount;             
            
            Id accountId = Id.valueOf(objagg.get('CRM_Mtg_Aggregator__c') + '');
            String strMonth = String.valueOf(objagg.get('CRM_Mtg_Settlement_Month__c') + '');
            String strYear = String.valueOf(objagg.get('CRM_Mtg_Settlement_Year__c') + '');
            Decimal totalsettlements = 0;
            Decimal totalamount = 0;
            
            if(String.valueOf(objagg.get('totalapps') + '') != Null && String.valueOf(objagg.get('totalapps') + '') != '')
            {
                totalsettlements = Decimal.valueOf(objagg.get('totalapps') + '');
            }
            
            if(String.valueOf(objagg.get('totalamt') + '') != Null && String.valueOf(objagg.get('totalamt') + '') != '')
            {
                totalamount = Decimal.valueOf(objagg.get('totalamt') + '');
            }
            
            if(mapAggregator.containsKey(accountId) && mapAggregator.get(accountId) != Null)
            {
                objaccount = mapAggregator.get(accountId);
                
                if(strYear == String.valueOf(System.Today().Year()))
                {
                    if(strMonth == mapMonthName.get(System.Today().Month()))
                    {
                        objaccount.CRM_Mtg_Setts_MTD__c += totalsettlements;
                        objaccount.CRM_Mtg_Setts_MTD_Amt__c += totalamount;
                    }
                    else
                    {
                        objaccount.CRM_Mtg_Setts_Last_Year__c += totalsettlements;
                    }
                    
                    objaccount.CRM_Mtg_Setts_YTD__c += totalsettlements;
                    objaccount.CRM_Mtg_Setts_YTD_Amt__c += totalamount;
                    
                    if(mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())))
                    {
                        objaccount.CRM_Mtg_Setts_QTD__c += totalsettlements;
                    }
                }
                else
                {
                    objaccount.CRM_Mtg_Setts_Last_Year__c += totalsettlements;
                }
                
                if(mapQuarterName.get(mapMonthName.get(System.Today().Month())) == 1)
                {
                    if(strYear == String.valueOf(System.Today().Year() - 1) && mapQuarterName.get(strMonth) == 4)
                    {
                        objaccount.CRM_Mtg_Setts_Last_Quarter__c += totalsettlements;
                    }
                }
                else
                {
                    if(strYear == String.valueOf(System.Today().Year()) && mapQuarterName.get(strMonth) == mapQuarterName.get(mapMonthName.get(System.Today().Month())) - 1)
                    {
                        objaccount.CRM_Mtg_Setts_Last_Quarter__c += totalsettlements;
                    }
                }
                
                mapAggregator.put(accountId,objaccount);
            }
        }
        
        if(mapAggregator != Null && mapAggregator.size() > 0)
        {
            try
            {
                update mapAggregator.values();
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