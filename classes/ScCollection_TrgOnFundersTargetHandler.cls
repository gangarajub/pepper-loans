public class ScCollection_TrgOnFundersTargetHandler{

    public static void CreateContractSummary(List<ScCollection_Funders_Target__c> lstNew){
        String today = 'TODAY';
        String yesterday = 'YESTERDAY';
        String month_end = 'MONTHEND';
        
        if(lstNew != null && lstNew.size()>0){
            
            ScCollection_Bucket_Configuration__c CS = ScCollection_Bucket_Configuration__c.getInstance();
            Integer total_bucket = (Integer)CS.ScCollection_Number_of_Buckets__c;
            
            List<ScCollection_Contract_Summary__c > lstToInsertConSumm = new List<ScCollection_Contract_Summary__c >();
            set<ID> setSourceSystem = new set<ID>();
            for(ScCollection_Funders_Target__c objFunder : lstNew){
            
                 ScCollection_Contract_Summary__c objConSummary = new ScCollection_Contract_Summary__c();
                 objConSummary.ScCollection_Source_System__c = objFunder.ScCollection_Source_System__c;
                 objConSummary.ScCollection_Funders_Target__c = objFunder.Id;
                 objConSummary.ScCollection_Day__c = yesterday;
                 lstToInsertConSumm.add(objConSummary);
                 
                 ScCollection_Contract_Summary__c objConSummary1 = new ScCollection_Contract_Summary__c();
                 objConSummary1.ScCollection_Source_System__c = objFunder.ScCollection_Source_System__c;
                 objConSummary1.ScCollection_Funders_Target__c = objFunder.Id;
                 objConSummary1.ScCollection_Day__c = month_end;
                 lstToInsertConSumm.add(objConSummary1);
                 
                 setSourceSystem.add(objFunder.ScCollection_Source_System__c);
            }
            //Insert Yesterdat and Todays Contract Summary--------------------------------------------
            if(lstToInsertConSumm != null && lstToInsertConSumm.Size()>0){
                insert lstToInsertConSumm;
            }
            
            map<Id,collect__Source_System__c> mapIdToSource = new Map<Id,collect__Source_System__c>([Select Id,Name from collect__Source_System__c where Id in : setSourceSystem]);
            
            //Inserted Bucket Summary wrt Contract Summary---------------------------------------------
            Map<String,ScCollection_Contract_Summary__c> mapStringToConSummary = new Map<String,ScCollection_Contract_Summary__c>();
            List<ScCollection_Bucket_Summary__c > lstBukSumm = new List<ScCollection_Bucket_Summary__c >();
            
            if(lstToInsertConSumm != null && lstToInsertConSumm.Size()>0){
                
                for(ScCollection_Contract_Summary__c objConsumm : lstToInsertConSumm ){
                    
                    if(total_bucket != null){
                        if(objConsumm.ScCollection_Source_System__c != null && 
                            mapIdToSource.ContainsKey(objConsumm.ScCollection_Source_System__c) && 
                            mapIdToSource.get(objConsumm.ScCollection_Source_System__c) != null && 
                            mapIdToSource.get(objConsumm.ScCollection_Source_System__c).Name == 'PAF'){
                                
                            integer temp = total_bucket + 1;
                            for(Integer i=0;i<temp;i++){
                            
                                ScCollection_Bucket_Summary__c objBuckSumm = new ScCollection_Bucket_Summary__c();
                                objBuckSumm.ScCollection_Contract_Summary__c = objConsumm.Id ;
                                objBuckSumm.ScCollection_BucketName__c = i;
                                lstBukSumm.add(objBuckSumm);
                            }
                        }
                        else{
                            for(Integer i=0;i<total_bucket;i++){
                            
                                ScCollection_Bucket_Summary__c objBuckSumm = new ScCollection_Bucket_Summary__c();
                                objBuckSumm.ScCollection_Contract_Summary__c = objConsumm.Id ;
                                objBuckSumm.ScCollection_BucketName__c = i;
                                lstBukSumm.add(objBuckSumm);
                            }
                        }
                        
                    
                    }
                    
                    //Creating map of SourceSyatem + FunderTarget + Day to the Contract Summary
                    mapStringToConSummary.put(objConsumm.ScCollection_Source_System__c+'-'+objConsumm.ScCollection_Funders_Target__c +'-'+objConsumm.ScCollection_Day__c ,objConsumm);
                   
                }
            
            }
            //Insert bucket summary
            if(lstBukSumm != null && lstBukSumm.Size()>0){
                insert lstBukSumm;
            
            }
            
            List<ScCollection_Contract_Summary__c > lstToInsertConSummToday = new List<ScCollection_Contract_Summary__c >();
            //Insert Todays Contract summary with Yesterday and Today lookup-------------------------------------------------
            for(ScCollection_Funders_Target__c objFunToday : lstNew){
                ScCollection_Contract_Summary__c objConSummary = new ScCollection_Contract_Summary__c();
                objConSummary.ScCollection_Source_System__c = objFunToday.ScCollection_Source_System__c;
                objConSummary.ScCollection_Funders_Target__c = objFunToday.Id;
                objConSummary.ScCollection_Day__c = today;
                if(mapStringToConSummary.containsKey(objFunToday.ScCollection_Source_System__c+'-'+objFunToday.Id+'-'+yesterday) &&
                   mapStringToConSummary.get(objFunToday.ScCollection_Source_System__c+'-'+objFunToday.Id+'-'+yesterday) != null){
                   
                   objConSummary.ScColllection_YesterdayContractSummary__c = mapStringToConSummary.get(objFunToday.ScCollection_Source_System__c+'-'+objFunToday.Id+'-'+yesterday).Id;
                }
                if(mapStringToConSummary.containsKey(objFunToday.ScCollection_Source_System__c+'-'+objFunToday.Id+'-'+month_end ) &&
                   mapStringToConSummary.get(objFunToday.ScCollection_Source_System__c+'-'+objFunToday.Id+'-'+month_end ) != null){
                   
                   objConSummary.ScCollection_MonthEndContract_Summary__c= mapStringToConSummary.get(objFunToday.ScCollection_Source_System__c+'-'+objFunToday.Id+'-'+month_end ).Id;
                }
                
                lstToInsertConSummToday.add(objConSummary);
            
            }
            
            //Insert Todays Record for Contract Summary---------------------------------------------------  
            if(lstToInsertConSummToday != null && lstToInsertConSummToday.Size()>0){
                insert lstToInsertConSummToday;
            }
            
            //Creating map of ContractSummary + BucketName to Bucket object--------------------------------
            Map<String,ScCollection_Bucket_Summary__c> mapStringToBuckSumm = new Map<String,ScCollection_Bucket_Summary__c>();
            if(lstBukSumm != null && lstBukSumm.Size()>0){
                
                for(ScCollection_Bucket_Summary__c  objBukSum :lstBukSumm ){
                
                    mapStringToBuckSumm.put(objBukSum.ScCollection_Contract_Summary__c+'-'+objBukSum.ScCollection_BucketName__c ,objBukSum);
                }
            
            }
            
            //Inserting Bucket for Todays Record------------------------------------------------------------
            List<ScCollection_Bucket_Summary__c> lstNewtodayBucSum = new List<ScCollection_Bucket_Summary__c>();
            if(lstToInsertConSummToday != null && lstToInsertConSummToday.Size()>0){
            
                for(ScCollection_Contract_Summary__c objTodayConSummary : lstToInsertConSummToday  ){
                    if(total_bucket != null){
                        if(objTodayConSummary.ScCollection_Source_System__c != null && 
                            mapIdToSource.ContainsKey(objTodayConSummary.ScCollection_Source_System__c) && 
                            mapIdToSource.get(objTodayConSummary.ScCollection_Source_System__c) != null && 
                            mapIdToSource.get(objTodayConSummary.ScCollection_Source_System__c).Name == 'PAF'){
                            integer temp = total_bucket + 1;
                            for(Integer i=0;i<temp;i++){
                            
                                ScCollection_Bucket_Summary__c objBuckSumm = new ScCollection_Bucket_Summary__c();
                                objBuckSumm.ScCollection_Contract_Summary__c = objTodayConSummary.Id ;
                                objBuckSumm.ScCollection_BucketName__c = i;
                                
                                if(mapStringToBuckSumm.ContainsKey(objTodayConSummary.ScColllection_YesterdayContractSummary__c+'-'+i) &&
                                   mapStringToBuckSumm.get(objTodayConSummary.ScColllection_YesterdayContractSummary__c+'-'+i) != null){
                                    objBuckSumm.ScCollection_Yesterday_Bucket_Summary__c = mapStringToBuckSumm.get(objTodayConSummary.ScColllection_YesterdayContractSummary__c+'-'+i).Id;
                                }
                                if(mapStringToBuckSumm.ContainsKey(objTodayConSummary.ScCollection_MonthEndContract_Summary__c+'-'+i) &&
                                   mapStringToBuckSumm.get(objTodayConSummary.ScCollection_MonthEndContract_Summary__c+'-'+i) != null){
                                    objBuckSumm.ScCollection_Month_s_End_Bucket_Summary__c = mapStringToBuckSumm.get(objTodayConSummary.ScCollection_MonthEndContract_Summary__c+'-'+i).Id;
                                }
                                lstNewtodayBucSum.add(objBuckSumm);
                            }
                        }
                        else{
                            for(Integer i=0;i<total_bucket;i++){
                                
                                ScCollection_Bucket_Summary__c objBuckSumm = new ScCollection_Bucket_Summary__c();
                                objBuckSumm.ScCollection_Contract_Summary__c = objTodayConSummary.Id ;
                                objBuckSumm.ScCollection_BucketName__c = i;
                                
                                if(mapStringToBuckSumm.ContainsKey(objTodayConSummary.ScColllection_YesterdayContractSummary__c+'-'+i) &&
                                   mapStringToBuckSumm.get(objTodayConSummary.ScColllection_YesterdayContractSummary__c+'-'+i) != null){
                                    objBuckSumm.ScCollection_Yesterday_Bucket_Summary__c = mapStringToBuckSumm.get(objTodayConSummary.ScColllection_YesterdayContractSummary__c+'-'+i).Id;
                                }
                                if(mapStringToBuckSumm.ContainsKey(objTodayConSummary.ScCollection_MonthEndContract_Summary__c+'-'+i) &&
                                   mapStringToBuckSumm.get(objTodayConSummary.ScCollection_MonthEndContract_Summary__c+'-'+i) != null){
                                    objBuckSumm.ScCollection_Month_s_End_Bucket_Summary__c = mapStringToBuckSumm.get(objTodayConSummary.ScCollection_MonthEndContract_Summary__c+'-'+i).Id;
                                }
                                lstNewtodayBucSum.add(objBuckSumm);
                            }
                        }
                        
                    }
                }
            
            }
            if(lstNewtodayBucSum != null && lstNewtodayBucSum.Size()>0){
                insert lstNewtodayBucSum;
            }
        }
            
    
    }
}