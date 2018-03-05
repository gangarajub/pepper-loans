//  -------------------------------------------------------------------------------------------------------
//  This class would look for contracts that do not have any activity performed today and update/create the 
//  contract setting against them
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 01-AUG-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_testScheduleDailySummary
//  -------------------------------------------------------------------------------------------------------
Global class ScCollection_BatchDailyContractSummary implements Database.Batchable<sObject>,Database.Stateful   
{
    /*Date processDateInstance;
    String QUERY;
    Map<String,Map<Decimal,Decimal>> mapSourceSystemtoMapBucketandTotal; 
    Map<String,Map<Decimal,List<collect__Loan_Account__c>>> mapSourceSystemtoMapBucketToContracts; 
    Set<String> setSourceSystems;   
    Set<Decimal> setBuckets;   
    Map<String,ScCollection_Targer_Arrears_Index__c> mcs = new Map<String,ScCollection_Targer_Arrears_Index__c>();
    */
    // constructor to set the date and query string
    public ScCollection_BatchDailyContractSummary(Date processDate)
    {
        /*setSourceSystems = new Set<String>();  
        
        List<collect__Source_System__c> lstSourceSystem = new List<collect__Source_System__c>();
        lstSourceSystem = [select id, name from collect__Source_System__c];    
    
        for(collect__Source_System__c SourceSystem : lstSourceSystem)
        {
            setSourceSystems.add(SourceSystem.name);
        }

        setBuckets = new Set<Decimal>();
        ScCollection_Bucket_Configuration__c tempSet = ScCollection_Bucket_Configuration__c.getInstance();
        
        if(tempSet != Null)
        {
            if(tempSet.ScCollection_Number_of_Buckets__c != Null)
            {
                Decimal counter = tempSet.ScCollection_Number_of_Buckets__c;
                while(counter >= 0)
                {
                    setBuckets.add(counter);
                    --counter;
                }
            }
        }

        mcs = ScCollection_Targer_Arrears_Index__c.getall();
        processDateInstance = processDate;
        Query = 'Select id,ScCollection_Bucket__c,ScCollection_OldBucket__c,collect__Source_System__r.name,ScCollection_Current_Principal__c,ScCollection_Movement_Date__c from collect__Loan_Account__c where ScCollection_Bucket__c != Null and collect__Source_System__c != Null';
        */
    }

    // ----------------------------------------------------------------------------------------------------
    // This method will query the sobject as per string passed by the constructor
    // ----------------------------------------------------------------------------------------------------
    // Created Date:   August 2,2016     Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would be used to query the sobject   and initialize the variables        
    // ----------------------------------------------------------------------------------------------------
    Global Database.QueryLocator start(Database.BatchableContext BC)
    {
        /*mapSourceSystemtoMapBucketandTotal = new Map<String,Map<Decimal,Decimal>>();
        mapSourceSystemtoMapBucketToContracts = new Map<String,Map<Decimal,List<collect__Loan_Account__c>>>();
        */
        string QUERY = 'Select Id from collect__Loan_Account__c  limit 1';
        return Database.getQueryLocator(QUERY);
    }

    // ----------------------------------------------------------------------------------------------------
    // This method will process the contract records in batches
    // ----------------------------------------------------------------------------------------------------
    // Created Date :   August 2,2016      Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  : this method will calucute the number and total of balances
    // ----------------------------------------------------------------------------------------------------
    global void execute(Database.BatchableContext info, List<Sobject> scope)
    {
        /*Decimal balanceCount = 0;
        List<collect__Loan_Account__c> lstContracts = (List<collect__Loan_Account__c>)scope;
        // iterate over the list
        for(collect__Loan_Account__c tempAccount:lstContracts)
        {
            if(!mapSourceSystemtoMapBucketandTotal.containsKey(tempAccount.collect__Source_System__r.name))
            {
                mapSourceSystemtoMapBucketandTotal.put(tempAccount.collect__Source_System__r.name,new Map<Decimal,Decimal>());
                mapSourceSystemtoMapBucketToContracts.put(tempAccount.collect__Source_System__r.name,new Map<Decimal,List<collect__Loan_Account__c>>());
            }
            if(!mapSourceSystemtoMapBucketandTotal.get(tempAccount.collect__Source_System__r.name).containsKey(tempAccount.ScCollection_Bucket__c))
            {
                mapSourceSystemtoMapBucketandTotal.get(tempAccount.collect__Source_System__r.name).put(tempAccount.ScCollection_Bucket__c,0);
                mapSourceSystemtoMapBucketToContracts.get(tempAccount.collect__Source_System__r.name).put(tempAccount.ScCollection_Bucket__c,new List<collect__Loan_Account__c>());
            }
            
            // adding the balance assuming every thing has been take care
            mapSourceSystemtoMapBucketToContracts.get(tempAccount.collect__Source_System__r.name).get(tempAccount.ScCollection_Bucket__c).add(tempAccount);
            balanceCount = mapSourceSystemtoMapBucketandTotal.get(tempAccount.collect__Source_System__r.name).get(tempAccount.ScCollection_Bucket__c);
            Decimal tempAmount = tempAccount.ScCollection_Current_Principal__c != Null ? tempAccount.ScCollection_Current_Principal__c : 0;
            balanceCount =  tempAmount  + balanceCount;
            mapSourceSystemtoMapBucketandTotal.get(tempAccount.collect__Source_System__r.name).put(tempAccount.ScCollection_Bucket__c,balanceCount);
        }
        
        //  look for the pending sourcesystems
        for(String crossCheck:setSourceSystems)
        {
            if(!mapSourceSystemtoMapBucketandTotal.containsKey(crossCheck))
            {
                mapSourceSystemtoMapBucketandTotal.put(crossCheck,new Map<Decimal,Decimal>());
                mapSourceSystemtoMapBucketToContracts.put(crossCheck,new Map<Decimal,List<collect__Loan_Account__c>>());
                // obviously there is no buket
                for(Decimal bucket:setBuckets)
                {
                    mapSourceSystemtoMapBucketandTotal.get(crossCheck).put(bucket,0);
                    mapSourceSystemtoMapBucketToContracts.get(crossCheck).put(bucket,new List<collect__Loan_Account__c>());
                }
            }
            else
            {
                // cross check all the buckets
                for(Decimal CrossCheckBucket:setBuckets)
                {
                    if(!mapSourceSystemtoMapBucketandTotal.get(crossCheck).containsKey(CrossCheckBucket))
                    {
                        mapSourceSystemtoMapBucketandTotal.get(crossCheck).put(CrossCheckBucket,0);
                        mapSourceSystemtoMapBucketToContracts.get(crossCheck).put(CrossCheckBucket,new List<collect__Loan_Account__c>());
                    }
                }
            }        
        }*/
    }  
 
    // ----------------------------------------------------------------------------------------------------
    // Created Date :   August 2,2016     Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // Description  :  this method would insert the contract summary and bucket summary
    // ----------------------------------------------------------------------------------------------------
    global void finish(Database.BatchableContext BC)
    {
        // put a save point
        /*Savepoint sp   = Database.setSavepoint();
        try
        {    
            List<ScCollection_Contract_Summary__c> lstPreviousSummary = new List<ScCollection_Contract_Summary__c>();
            lstPreviousSummary = [select id,
                                         ScCollection_SourceName__c,
                                         (select id,
                                                 ScCollection_BucketName__c 
                                                 from Bucket_Summary__r) 
                                        from ScCollection_Contract_Summary__c 
                                        where ScCollection_Process_Date__c = yesterday];
            
            List<ScCollection_Contract_Summary__c> lstPreviousSummaryMonth = new List<ScCollection_Contract_Summary__c>();
            lstPreviousSummaryMonth = [select id,
                                              ScCollection_SourceName__c,
                                              ScCollection_Process_Date__c,
                                              (select id,
                                                      ScCollection_BucketName__c 
                                                      from Bucket_Summary__r) 
                                            from ScCollection_Contract_Summary__c 
                                            where ScCollection_Process_Date__c = LAST_MONTH 
                                            order by ScCollection_Process_Date__c desc Nulls last];
            
            Map<String,ScCollection_Contract_Summary__c>  mapSouceSystemtoSummaryLastMonth = new Map<String,ScCollection_Contract_Summary__c>();
            for(ScCollection_Contract_Summary__c lastMonthSummary:lstPreviousSummaryMonth)
            {
                if(!mapSouceSystemtoSummaryLastMonth.containsKey(lastMonthSummary.ScCollection_SourceName__c))
                {
                    mapSouceSystemtoSummaryLastMonth.put(lastMonthSummary.ScCollection_SourceName__c,lastMonthSummary);
                }
            }
            
            Map<String,ScCollection_Contract_Summary__c>  mapSouceSystemtoSummaryLastMonthPreviousDay = new Map<String,ScCollection_Contract_Summary__c>();
            for(ScCollection_Contract_Summary__c lastMonthSummary:lstPreviousSummary)
            {
                if(!mapSouceSystemtoSummaryLastMonthPreviousDay.containsKey(lastMonthSummary.ScCollection_SourceName__c))
                {
                    mapSouceSystemtoSummaryLastMonthPreviousDay.put(lastMonthSummary.ScCollection_SourceName__c,lastMonthSummary);
                }
            }
        
            // Create contract summary
            list<ScCollection_Contract_Summary__c>  lstContractSumamry = new list<ScCollection_Contract_Summary__c>();
            for(String SourceName:mapSourceSystemtoMapBucketandTotal.keySet())
            {
                ScCollection_Contract_Summary__c tempSummary = new ScCollection_Contract_Summary__c();
                tempSummary.ScCollection_SourceName__c          =   SourceName;
                tempSummary.ScCollection_Process_Date__c    =   processDateInstance;
            
                if(mcs.containsKey(SourceName))
                {
                    if(processDateInstance.month() == 1)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_Jan_Target__c;
                    } 
                    if(processDateInstance.month() == 2)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_Feb_Arrears_Index__c;
                    } 
                    if(processDateInstance.month() == 3)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_March_Target_Arrears_Index__c;
                    } 
                    if(processDateInstance.month() == 4)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_April_Target_Arrears_Index__c;
                    }
                    if(processDateInstance.month() == 5)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_May_Target_Arrears_Index__c;
                    }     
                    if(processDateInstance.month() == 6)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_June_Arrears_Index_Target__c;
                    } 
                    if(processDateInstance.month() == 7)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_July_Arrears_Index__c;
                    }
                    if(processDateInstance.month() == 8)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_August_Arrears_Index__c;
                    } 
                    if(processDateInstance.month() == 9)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_Sep_Arrears_Index__c;
                    }
                    if(processDateInstance.month() == 10)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_Oct_Arrears_Index__c;
                    } 
                    if(processDateInstance.month() == 11)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_Nov_Arrears_Index__c;
                    }
                    if(processDateInstance.month() == 12)
                    {
                        tempSummary.ScCollection_Target_Arrear_Index__c =   mcs.get(SourceName).ScCollection_Dec_Arrears_Index__c;
                    }    
                }
                 
                if(lstPreviousSummary.size() > 0)
                {
                    for(ScCollection_Contract_Summary__c tempSummaryprevious:lstPreviousSummary)
                    {
                        if(tempSummaryprevious.ScCollection_SourceName__c  == SourceName)
                        {
                            tempSummary.ScColllection_YesterdayContractSummary__c = tempSummaryprevious.id;
                        }
                    }    
                }

                if(mapSouceSystemtoSummaryLastMonth.containsKey(SourceName))
                {
                    tempSummary.ScCollection_MonthEndContract_Summary__c    =   mapSouceSystemtoSummaryLastMonth.get(SourceName).id;
                }

                lstContractSumamry.add(tempSummary);
            }

            if(lstContractSumamry.size() > 0)
            {
                // insert the contract summayr
                insert lstContractSumamry;
                // prepare the bucket summary
                List<ScCollection_Bucket_Summary__c> lstBucketSummary = new List<ScCollection_Bucket_Summary__c> ();
                // prepare the bucket summary
                for(ScCollection_Contract_Summary__c tempSummary:lstContractSumamry)
                {
                    if(mapSourceSystemtoMapBucketandTotal.containsKey(tempSummary.ScCollection_SourceName__c))
                    {
                        for(Decimal bucket:mapSourceSystemtoMapBucketandTotal.get(tempSummary.ScCollection_SourceName__c).keySet())
                        {
                            ScCollection_Bucket_Summary__c objSummary = new ScCollection_Bucket_Summary__c();
                            objSummary.ScCollection_BucketName__c = bucket;
                            objSummary.ScCollection_Contract_Summary__c = tempSummary.id; 
                            objSummary.ScCollection_Count_of_Contracts__c = mapSourceSystemtoMapBucketToContracts.get(tempSummary.ScCollection_SourceName__c).get(bucket).size();
                            objSummary.ScCollection_Current_Balance_Sum__c = mapSourceSystemtoMapBucketandTotal.get(tempSummary.ScCollection_SourceName__c).get(bucket);
                            objSummary.ScCollection_Number_of_Contracts_Moved__c = 0;
                            objSummary.ScCollection_SumofContractsMovedfrom1to2__c = 0;
                    
                            if(mapSouceSystemtoSummaryLastMonth.containsKey(tempSummary.ScCollection_SourceName__c))
                            {
                                for(ScCollection_Bucket_Summary__c tempSummaryLastMonth:mapSouceSystemtoSummaryLastMonth.get(tempSummary.ScCollection_SourceName__c).Bucket_Summary__r)
                                {
                                    if(tempSummaryLastMonth.ScCollection_BucketName__c == bucket)
                                    {
                                        objSummary.ScCollection_Month_s_End_Bucket_Summary__c = tempSummaryLastMonth.id;
                                    }
                                }
                            }

                            if(mapSouceSystemtoSummaryLastMonthPreviousDay.containsKey(tempSummary.ScCollection_SourceName__c))
                            {
                                for(ScCollection_Bucket_Summary__c tempSummaryPreviousDay:mapSouceSystemtoSummaryLastMonthPreviousDay.get(tempSummary.ScCollection_SourceName__c).Bucket_Summary__r)
                                {
                                    if(tempSummaryPreviousDay.ScCollection_BucketName__c == bucket)
                                    {
                                        objSummary.ScCollection_Yesterday_Bucket_Summary__c = tempSummaryPreviousDay.id;
                                    }
                                }
                            }
                    
                            lstBucketSummary.add(objSummary);
                        }
                    }
                }

                if(lstBucketSummary.size() > 0)
                {
                    insert lstBucketSummary;
                }
            }
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            System.debug('#### -'+e.getMessage());
        }*/
    }
}