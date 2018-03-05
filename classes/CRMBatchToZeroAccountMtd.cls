//-----------------------------------------------------------------------------------------------------
// Date        : 19/12/2016
// Description : This Batch class is to update achieved and target MTD to 0 at every start of month 
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
global class CRMBatchToZeroAccountMtd implements Database.Batchable<sObject>{

    global String Query;
    global final datetime now;
    
    //constructor
    global CRMBatchToZeroAccountMtd(){
        now = system.now();
        
        //Query changed by Chayan Batabyal on 26.5.17
        //included CRM_Achieved_QTD__c & CRM_Target_QTD__c in the query.
        Query = 'select id,CRM_Achieved_MTD__c,CRM_Target_MTD__c, CRM_Achieved_QTD__c, ';
        Query += 'CRM_Target_QTD__c from  account where ispersonAccount = false and ';
        Query += '((CRM_Achieved_MTD__c != null and CRM_Achieved_MTD__c != 0) or ';
        Query += '(CRM_Target_MTD__c != null and CRM_Target_MTD__c  != 0) or (CRM_Achieved_QTD__c != null and CRM_Achieved_QTD__c != 0) or (CRM_Target_QTD__c != null and CRM_Target_QTD__c != 0)) order by createdDate desc';
    }
    
    
     /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          start
    Company:       Saasfocus
    Description:   This method returns the result of the query.
    Inputs:        Database.BatchableContext
    Returns:       Database.QueryLocator
    -----------------------------------------------------------------------------------*/
    global Database.QueryLocator start(Database.BatchableContext BC){
     
       return Database.getQueryLocator(Query);
    }
    
     /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          execute
    Company:       Saasfocus
    Description:   This method process the results from the start method.
    Inputs:        Database.BatchableContext, List<sObject>
    Returns:       void
    -----------------------------------------------------------------------------------*/
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Account> lstAccount = (List<Account>)scope;
         
        set<Id> setAccId = new set<Id>();
        
        for(Account acc : lstAccount){
            setAccId.add(acc.Id);
        }
        
        String currentYear = String.valueOf(System.Today().Year());
        Integer currMonth = System.Today().Month();
         
        List<CRM_Forecast__c> lstForecast = [Select Id,CRM_Target_January__c ,CRM_Target_February__c ,CRM_Target_March__c ,
                                                CRM_Target_April__c, CRM_Target_May__c ,CRM_Target_June__c ,CRM_Target_July__c,
                                                CRM_Target_August__c ,CRM_Target_September__c, CRM_Target_October__c,
                                                CRM_Target_November__c ,CRM_Target_December__c ,CRM_Forecast_Year__c ,
                                                CRM_Business_Unit__c ,CRM_Introducer__c 
                                                From CRM_Forecast__c Where CRM_Business_Unit__c = 'PAF' and 
                                                CRM_Introducer__c in : setAccId and CRM_Forecast_Year__c = :currentYear];
        
        map<Id,map<Integer,Double>> mapAccIdToCurrentMonthToAmount = new map<Id,map<Integer,Double>>();
        map<Id,Double> mapAccIdToCurrentQuarterToAmount = new map<Id,Double>();
        
        Integer startMonth = 0;
        Integer midMonth = 0;
        Integer endMonth = 0;
        Double dblSum = 0;
        
        if(currMonth >= 1 && currMonth <=3)
        {
            startMonth = 1;
            midMonth = 2;
            endMonth = 3;
        }
        
        else if(currMonth >= 4 && currMonth <=6)
        {
            startMonth = 4;
            midMonth = 5;
            endMonth = 6;
        }
        
        else if(currMonth >= 7 && currMonth <=9)
        {
            startMonth = 7;
            midMonth = 8;
            endMonth = 9;
        }
        
        else
        {
            startMonth = 10;
            midMonth = 11;
            endMonth = 12;
        }
        
        for(CRM_Forecast__c objForecast : lstForecast)
        {
            map<integer,double> mapMonthToSum = new map<integer,double>();
            
            if(objforecast.CRM_Target_January__c != null)
                mapMonthToSum.put(1,objforecast.CRM_Target_January__c);
            else
                mapMonthToSum.put(1,0);
            if(objforecast.CRM_Target_February__c != null)
                mapMonthToSum.put(2,objforecast.CRM_Target_February__c);
            else
                mapMonthToSum.put(2,0);
            if(objforecast.CRM_Target_March__c != null)
                mapMonthToSum.put(3,objforecast.CRM_Target_March__c);
            else
                mapMonthToSum.put(3,0);
            if(objforecast.CRM_Target_April__c != null)
                mapMonthToSum.put(4,objforecast.CRM_Target_April__c);
            else
                mapMonthToSum.put(4,0);
            if(objforecast.CRM_Target_May__c != null)
                mapMonthToSum.put(5,objforecast.CRM_Target_May__c);
            else
                mapMonthToSum.put(5,0);
            if(objforecast.CRM_Target_June__c != null)
                mapMonthToSum.put(6,objforecast.CRM_Target_June__c);
            else
                mapMonthToSum.put(6,0);
            if(objforecast.CRM_Target_July__c != null)
                mapMonthToSum.put(7,objforecast.CRM_Target_July__c);
            else
                mapMonthToSum.put(7,0);
            if(objforecast.CRM_Target_August__c != null)
                mapMonthToSum.put(8,objforecast.CRM_Target_August__c);
            else
                mapMonthToSum.put(8,0);
            if(objforecast.CRM_Target_September__c != null)
                mapMonthToSum.put(9,objforecast.CRM_Target_September__c);
            else
                mapMonthToSum.put(9,0);
            if(objforecast.CRM_Target_October__c != null)
                mapMonthToSum.put(10,objforecast.CRM_Target_October__c);
            else
                mapMonthToSum.put(10,0);
            if(objforecast.CRM_Target_November__c != null)
                mapMonthToSum.put(11,objforecast.CRM_Target_November__c);
            else
                mapMonthToSum.put(11,0);
            if(objforecast.CRM_Target_December__c != null)
                mapMonthToSum.put(12,objforecast.CRM_Target_December__c);
            else
                mapMonthToSum.put(12,0);
            
            if(mapMonthToSum.ContainsKey(startMonth) && mapMonthToSum.get(startMonth) != null)
                dblSum += mapMonthToSum.get(startMonth);
            
            if(mapMonthToSum.ContainsKey(midMonth) && mapMonthToSum.get(midMonth) != null)
                dblSum += mapMonthToSum.get(midMonth);
            
            if(mapMonthToSum.ContainsKey(endMonth) && mapMonthToSum.get(endMonth) != null)
                dblSum += mapMonthToSum.get(endMonth);
            
            
            mapAccIdToCurrentMonthToAmount.put(objForecast.CRM_Introducer__c,mapMonthToSum);
            mapAccIdToCurrentQuarterToAmount.put(objForecast.CRM_Introducer__c,dblSum);
            
            dblSum = 0;
        }
            
        List<Account> lstupdateAccount = new List<Account>();
        
        for(Account acc : lstAccount)
        {
        system.debug(acc);
            if(mapAccIdToCurrentMonthToAmount.containsKey(acc.Id) && mapAccIdToCurrentMonthToAmount.get(acc.Id) != null
                && mapAccIdToCurrentMonthToAmount.get(acc.Id).containsKey(currMonth) && 
                mapAccIdToCurrentMonthToAmount.get(acc.Id).get(currMonth) != null)
            {
                acc.CRM_Target_MTD__c = mapAccIdToCurrentMonthToAmount.get(acc.Id).get(currMonth);
            }
            
            else
            {
                acc.CRM_Target_MTD__c = 0;
            }
             
            acc.CRM_Achieved_MTD__c = 0;
            if(currMonth == 1 || currMonth == 4 || currMonth == 7 || currMonth == 10){
                 acc.CRM_Achieved_QTD__c = 0;
            }
                
            if(mapAccIdToCurrentQuarterToAmount.containsKey(acc.Id) && 
                mapAccIdToCurrentQuarterToAmount.get(acc.Id) != null)
            {        
               acc.CRM_Target_QTD__c = mapAccIdToCurrentQuarterToAmount.get(acc.Id);
            }
            
            else
            {
                acc.CRM_Target_QTD__c = 0;
            }
            
            lstupdateAccount.add(acc);
        }
         
        if(lstupdateAccount != null && lstupdateAccount.size() > 0){
            database.update(lstupdateAccount,false) ;
        }
            
    
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          finish
    Company:       Saasfocus
    Description:   This method is executed when the batch execute method is completed.
    Inputs:        Database.BatchableContext
    Returns:       void
    -----------------------------------------------------------------------------------*/
    global void finish(Database.BatchableContext BC){}
}