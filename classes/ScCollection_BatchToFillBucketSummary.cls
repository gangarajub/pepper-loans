global class ScCollection_BatchToFillBucketSummary implements Database.Batchable<sObject>{
    
    global final String Query;
    global Integer day = System.Today().day();
    global String today = 'TODAY';
    global String yesterday = 'YESTERDAY';
    global String month_end = 'MONTHEND';
    
    global ScCollection_BatchToFillBucketSummary(){
    
        Query = 'Select Id,ScCollection_Bank_Name__c,ScCollection_Source_System__c,ScCollection_Source_System__r.Name,ScCollection_Target__c from ScCollection_Funders_Target__c where ScCollection_Bank_Name__c != null and ScCollection_Source_System__c != null';
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
     
       return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject>scope){
        
        List<ScCollection_Funders_Target__c > lstFundersTarget = (List<ScCollection_Funders_Target__c>)scope;
        
        set<Id> setFundersTarget =  new set<Id>();
        set<String> setFundersName = new set<String>();
        set<Id> setSourceSystem = new set<Id>();
        
        for(ScCollection_Funders_Target__c objFundersTarget : lstFundersTarget){
            setFundersTarget.add(objFundersTarget.Id);
            if(objFundersTarget.ScCollection_Bank_Name__c != null){
                setFundersName.add(objFundersTarget.ScCollection_Bank_Name__c);
            }
            if(objFundersTarget.ScCollection_Source_System__c != null){
                setSourceSystem.add(objFundersTarget.ScCollection_Source_System__c);
            }
            
        }
        
        List<ScCollection_Contract_Summary__c> lstContractSummary = [select id,ScCollection_Source_System__c,ScCollection_Funders_Target__c,                                                            ScCollection_Funders_Target__r.ScCollection_Bank_Name__c,ScCollection_Day__c,
                                                                    (Select id,ScCollection_Contract_Summary__c,ScCollection_Count_of_Contracts__c,ScCollection_Current_Balance_Sum__c,
                                                                    ScCollection_BucketName__c,ScCollection_Yesterday_Bucket_Summary__c,ScCollection_Month_s_End_Bucket_Summary__c from Bucket_Summary__r)
                                                                    from ScCollection_Contract_Summary__c where ScCollection_Funders_Target__c in : setFundersTarget];
        
        List<ScCollection_Bucket_Summary__c> lstBkt = new List<ScCollection_Bucket_Summary__c>();
        
        Map<String,ScCollection_Bucket_Summary__c > mapStringToBucketSummary= new Map<String,ScCollection_Bucket_Summary__c >();
        
        for(ScCollection_Contract_Summary__c objConSumm : lstContractSummary){
            if(objConSumm.ScCollection_Day__c == today){
                if(objConSumm.Bucket_Summary__r != null && objConSumm.Bucket_Summary__r.Size()>0){
                    for(ScCollection_Bucket_Summary__c objBucketToday : objConSumm.Bucket_Summary__r){
                        
                        mapStringToBucketSummary.put(objBucketToday.ScCollection_Yesterday_Bucket_Summary__c+'-'+objBucketToday.ScCollection_BucketName__c,objBucketToday);
                        mapStringToBucketSummary.put(objBucketToday.ScCollection_Month_s_End_Bucket_Summary__c+'-'+objBucketToday.ScCollection_BucketName__c,objBucketToday);
                    
                    }   
                }
            }
        }
    
        for(ScCollection_Contract_Summary__c objConSumm : lstContractSummary){
            if(objConSumm.ScCollection_Day__c == yesterday){
                if(objConSumm.Bucket_Summary__r != null && objConSumm.Bucket_Summary__r.Size()>0){
                    for(ScCollection_Bucket_Summary__c objBucketYesterday : objConSumm.Bucket_Summary__r){
                        
                        if(mapStringToBucketSummary.ContainsKey(objBucketYesterday.Id+'-'+objBucketYesterday.ScCollection_BucketName__c)
                            && mapStringToBucketSummary.get(objBucketYesterday.Id+'-'+objBucketYesterday.ScCollection_BucketName__c) != null){
                            
                            objBucketYesterday.ScCollection_Count_of_Contracts__c = mapStringToBucketSummary.get(objBucketYesterday.Id+'-'+objBucketYesterday.ScCollection_BucketName__c).ScCollection_Count_of_Contracts__c;
                            objBucketYesterday.ScCollection_Current_Balance_Sum__c = mapStringToBucketSummary.get(objBucketYesterday.Id+'-'+objBucketYesterday.ScCollection_BucketName__c).ScCollection_Current_Balance_Sum__c;
                            lstBkt.add(objBucketYesterday);
                        }
                         
                    }
                }
                
            }
            else if((objConSumm.ScCollection_Day__c == month_end && day == 1)){
                if(objConSumm.Bucket_Summary__r != null && objConSumm.Bucket_Summary__r.Size()>0){
                    for(ScCollection_Bucket_Summary__c objBucketEnd : objConSumm.Bucket_Summary__r){
                        
                        if(mapStringToBucketSummary.ContainsKey(objBucketEnd.Id+'-'+objBucketEnd.ScCollection_BucketName__c)
                            && mapStringToBucketSummary.get(objBucketEnd.Id+'-'+objBucketEnd.ScCollection_BucketName__c) != null){
                            
                            objBucketEnd.ScCollection_Count_of_Contracts__c = mapStringToBucketSummary.get(objBucketEnd.Id+'-'+objBucketEnd.ScCollection_BucketName__c).ScCollection_Count_of_Contracts__c;
                            objBucketEnd.ScCollection_Current_Balance_Sum__c = mapStringToBucketSummary.get(objBucketEnd.Id+'-'+objBucketEnd.ScCollection_BucketName__c).ScCollection_Current_Balance_Sum__c;
                            lstBkt.add(objBucketEnd);
                        }
                         
                    }
                }
                
            }
        }
        
        
        Map<String,Decimal> mapStringToAmount = new Map<String,Decimal>();
        Map<String,Integer> mapStringToCount = new Map<String,Integer>();
        Boolean checkSSMortPAF = false;
        if(lstFundersTarget != null && lstFundersTarget.Size()>0){
            
            if(lstFundersTarget[0].ScCollection_Source_System__r.Name == 'CL Loan'){
                checkSSMortPAF = false;
                ScCollection_BatchToFillBucketSummary.WrapperMap objWrapper = PlBucketCalculation(setFundersName);
                mapStringToAmount = objWrapper.mapStringToAmount;
                mapStringToCount = objWrapper.mapStringToCount;
            }
            else{
                checkSSMortPAF = true;
                ScCollection_BatchToFillBucketSummary.WrapperMap objWrapper = ClBucketCalculation(setSourceSystem,setFundersName);
                mapStringToAmount = objWrapper.mapStringToAmount;
                mapStringToCount = objWrapper.mapStringToCount;
            }
        }
        
        if(checkSSMortPAF){
            for(ScCollection_Contract_Summary__c objConSumm : lstContractSummary){
                if(objConSumm.ScCollection_Day__c == today){
                    if(objConSumm.Bucket_Summary__r != null && objConSumm.Bucket_Summary__r.Size()>0){
                        for(ScCollection_Bucket_Summary__c objBucketToday : objConSumm.Bucket_Summary__r){
                            
                            if(mapStringToAmount.containsKey(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objConSumm.ScCollection_Source_System__c+'-'+objBucketToday.ScCollection_BucketName__c) &&
                                mapStringToAmount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objConSumm.ScCollection_Source_System__c+'-'+objBucketToday.ScCollection_BucketName__c) != null){
                                
                                objBucketToday.ScCollection_Current_Balance_Sum__c = mapStringToAmount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objConSumm.ScCollection_Source_System__c+'-'+objBucketToday.ScCollection_BucketName__c);
                            }
                            else{
                                objBucketToday.ScCollection_Current_Balance_Sum__c = null;
                            }
                            if(mapStringToCount.containsKey(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objConSumm.ScCollection_Source_System__c+'-'+objBucketToday.ScCollection_BucketName__c) &&
                                mapStringToCount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objConSumm.ScCollection_Source_System__c+'-'+objBucketToday.ScCollection_BucketName__c) != null){
                                
                                objBucketToday.ScCollection_Count_of_Contracts__c = mapStringToCount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objConSumm.ScCollection_Source_System__c+'-'+objBucketToday.ScCollection_BucketName__c);
                            }
                            else{
                                objBucketToday.ScCollection_Count_of_Contracts__c = null;
                            }
                            lstBkt.add(objBucketToday);
                            
                        }   
                    }
                }
            }
        }
        else{
            for(ScCollection_Contract_Summary__c objConSumm : lstContractSummary){
                if(objConSumm.ScCollection_Day__c == today){
                    if(objConSumm.Bucket_Summary__r != null && objConSumm.Bucket_Summary__r.Size()>0){
                        for(ScCollection_Bucket_Summary__c objBucketToday : objConSumm.Bucket_Summary__r){
                            
                            if(mapStringToAmount.containsKey(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objBucketToday.ScCollection_BucketName__c) &&
                                mapStringToAmount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objBucketToday.ScCollection_BucketName__c) != null){
                                
                                objBucketToday.ScCollection_Current_Balance_Sum__c = mapStringToAmount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objBucketToday.ScCollection_BucketName__c);
                            }
                            else{
                                objBucketToday.ScCollection_Current_Balance_Sum__c = null;
                            }
                            if(mapStringToCount.containsKey(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objBucketToday.ScCollection_BucketName__c) &&
                                mapStringToCount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objBucketToday.ScCollection_BucketName__c) != null){
                                
                                objBucketToday.ScCollection_Count_of_Contracts__c = mapStringToCount.get(objConSumm.ScCollection_Funders_Target__r.ScCollection_Bank_Name__c+'-'+objBucketToday.ScCollection_BucketName__c);
                            }
                            else{
                                objBucketToday.ScCollection_Count_of_Contracts__c = null;
                            }
                            lstBkt.add(objBucketToday);
                            
                        }   
                    }
                }
            }
        }
            
        
        
        if(lstBkt != null && lstBkt.Size()>0){
            update lstBkt;
        }
      
    }
    
    global void finish(Database.BatchableContext BC){
            
    }
    
    global class WrapperMap{

        Map<String,Decimal> mapStringToAmount{get;set;}
        Map<String,Integer> mapStringToCount{get;set;}
        
        
        global WrapperMap(){
            mapStringToAmount = new Map<String,Decimal>();
            mapStringToCount = new Map<String,Integer>();
        }
    }
    
    global ScCollection_BatchToFillBucketSummary.WrapperMap PlBucketCalculation(set<String> setFundersName){
        
        ScCollection_BatchToFillBucketSummary.WrapperMap objWrapper = new ScCollection_BatchToFillBucketSummary.WrapperMap();
        
        List<loan__Loan_Account__c> lstPlLoanAccount = [Select Id,loan__Amount_to_Current__c,SPV__c,ScCollection_Bucket__c from loan__Loan_Account__c where SPV__c in : setFundersName limit 50000];
        
        for(loan__Loan_Account__c objPLLoan : lstPlLoanAccount){
            if(objWrapper.mapStringToAmount.get(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c) == null){
                
                objWrapper.mapStringToCount.put(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c,1);
                if(objPLLoan.loan__Amount_to_Current__c == null){
                    objWrapper.mapStringToAmount.put(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c,0);
                }
                else{
                    objWrapper.mapStringToAmount.put(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c,objPLLoan.loan__Amount_to_Current__c);
                }
            }
            else{
                Integer temp_count = objWrapper.mapStringToCount.get(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c);
                temp_count += 1;
                objWrapper.mapStringToCount.put(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c,temp_count);
                
                Decimal total_amount = objWrapper.mapStringToAmount.get(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c);
                if(objPLLoan.loan__Amount_to_Current__c != null){
                    total_amount += objPLLoan.loan__Amount_to_Current__c;
                    objWrapper.mapStringToAmount.put(objPLLoan.SPV__c+'-'+objPLLoan.ScCollection_Bucket__c,total_amount);
                }
            }
        }
        return objWrapper;
            
    }
    
    global ScCollection_BatchToFillBucketSummary.WrapperMap ClBucketCalculation(set<Id> setSourceSystem, set<String> setFundersName){
        
        List<collect__Loan_Account__c> lstContract = [select Id,ScCollection_Funder_Bank_Name__c,ScCollection_Bucket__c,ScCollection_Current_Principal__c,                                            collect__Source_System__c 
                                                    from collect__Loan_Account__c where ScCollection_Funder_Bank_Name__c in : setFundersName and 
                                                    collect__Source_System__c in : setSourceSystem and ScCollection_Considered_for_Portfolio__c = true];

        ScCollection_BatchToFillBucketSummary.WrapperMap objWrapper = new ScCollection_BatchToFillBucketSummary.WrapperMap();
    
        if(lstContract != null && lstContract.Size()>0){
            for(collect__Loan_Account__c objContract : lstContract){
                if(objWrapper.mapStringToAmount.get(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c) == null){
                    
                    objWrapper.mapStringToCount.put(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c,1);
                    if(objContract.ScCollection_Current_Principal__c == null){
                        objWrapper.mapStringToAmount.put(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c,0);
                    }
                    else{
                        objWrapper.mapStringToAmount.put(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c,objContract.ScCollection_Current_Principal__c);
                    }
                }
                else{
                    Integer temp_count = objWrapper.mapStringToCount.get(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c);
                    temp_count += 1;
                    objWrapper.mapStringToCount.put(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c,temp_count);
                    
                    Decimal total_amount = objWrapper.mapStringToAmount.get(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c);
                    if(objContract.ScCollection_Current_Principal__c != null){
                        total_amount += objContract.ScCollection_Current_Principal__c;
                        objWrapper.mapStringToAmount.put(objContract.ScCollection_Funder_Bank_Name__c+'-'+objContract.collect__Source_System__c+'-'+objContract.ScCollection_Bucket__c,total_amount);
                    }
                }
            }
        }
        return objWrapper;

    }
    
    
}