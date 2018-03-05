//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch class ScCollection_RollRateReportBatch
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 10-JAN-2017         Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestRollRateReportBatch
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_ScheduleRollRateReportBatch implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        Set<Id> setTotalUserIds = new Set<Id>();
        List<ScCollection_Bucket_Movement_Data__c> lstUpsertData = new List<ScCollection_Bucket_Movement_Data__c>();
        Map<Id,Set<Id>> mapUserToBucket1ContractIds = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapUserToBucket30ContractIds = new Map<Id,Set<Id>>();
        Map<Id,Decimal> mapContractToBalance = new Map<Id,Decimal>();
        Map<Id,ScCollection_Bucket_Movement_Data__c> mapTodaysExistingData = new Map<Id,ScCollection_Bucket_Movement_Data__c>();
        
        ScCollection_Roll_Rate_Batch_Settings__c myCS = ScCollection_Roll_Rate_Batch_Settings__c.getValues('Roll Rate Start Day');
        Integer startday = Integer.valueOf(myCS.ScCollection_Initial_Start_Date__c);
        
        System.debug('custom setting day' + startday);
        System.debug('custom setting day' + System.Today().day());
                
        if(startday != Null && startday == System.Today().day())
        {
            List<collect__Queue_Contract__c> lstQC = [select Id, collect__User__c, ScCollection_Dev_Contract__c, ScCollection_Bucket__c, ScCollection_Balance_Amount__c from collect__Queue_Contract__c where collect__Status__c = 'Open'];
                        
            if(ScCollection_UtilityHandler.isNotNull(lstQC))
            {
                for(collect__Queue_Contract__c objqc : lstQC)
                {
                    if(objqc.collect__User__c != Null && objqc.ScCollection_Dev_Contract__c != Null && objqc.ScCollection_Bucket__c != Null && objqc.ScCollection_Bucket__c > 0)
                    {
                        Set<Id> setBucket1ContractIds;
                        Set<Id> setBucket30ContractIds;
                        
                        if(objqc.ScCollection_Bucket__c == 1)
                        {
                            if(mapUserToBucket1ContractIds.containsKey(objqc.collect__User__c) && mapUserToBucket1ContractIds.get(objqc.collect__User__c) != Null)
                            {
                                setBucket1ContractIds = mapUserToBucket1ContractIds.get(objqc.collect__User__c);
                            }
                            else
                            {
                                setBucket1ContractIds = new Set<Id>();
                            }
                            
                            setBucket1ContractIds.add(objqc.ScCollection_Dev_Contract__c);
                            mapUserToBucket1ContractIds.put(objqc.collect__User__c, setBucket1ContractIds);
                        }
                        else if(objqc.ScCollection_Bucket__c > 1)
                        {
                            if(mapUserToBucket30ContractIds.containsKey(objqc.collect__User__c) && mapUserToBucket30ContractIds.get(objqc.collect__User__c) != Null)
                            {
                                setBucket30ContractIds = mapUserToBucket30ContractIds.get(objqc.collect__User__c);
                            }
                            else
                            {
                                setBucket30ContractIds = new Set<Id>();
                            }
                            
                            setBucket30ContractIds.add(objqc.ScCollection_Dev_Contract__c);
                            mapUserToBucket30ContractIds.put(objqc.collect__User__c, setBucket30ContractIds);
                        }
                        
                        Decimal contractbalance = 0.00;
                        
                        if(objqc.ScCollection_Balance_Amount__c != Null && objqc.ScCollection_Balance_Amount__c > 0)
                        {
                            contractbalance = objqc.ScCollection_Balance_Amount__c;
                        }
                        
                        mapContractToBalance.put(objqc.ScCollection_Dev_Contract__c, contractbalance);
                    }
                }
                
                for(ScCollection_Bucket_Movement_Data__c obj : [select Id, ScCollection_Collector__c, ScCollection_Movement_Date__c, ScCollection_Bucket_1_Contract_Ids__c, ScCollection_30_Contract_Ids__c, ScCollection_30_Count__c, ScCollection_Bucket_1_Count__c, ScCollection_No_Movement_Balance__c, ScCollection_No_Movement_Count__c, ScCollection_Rolled_Down_Balance__c, ScCollection_Rolled_Down_Count__c, ScCollection_Rolled_Up_Balance__c, ScCollection_Rolled_Up_Count__c, ScCollection_Total_Balance__c from ScCollection_Bucket_Movement_Data__c where ScCollection_Movement_Date__c = TODAY])
                {
                    mapTodaysExistingData.put(obj.ScCollection_Collector__c, obj);    
                }
                
                if(mapUserToBucket1ContractIds != Null && mapUserToBucket1ContractIds.size() > 0)
                {
                    setTotalUserIds.addAll(mapUserToBucket1ContractIds.keyset());
                }
                
                if(mapUserToBucket30ContractIds != Null && mapUserToBucket30ContractIds.size() > 0)
                {
                    setTotalUserIds.addAll(mapUserToBucket30ContractIds.keyset());
                }
                
                if(setTotalUserIds != Null && setTotalUserIds.size() > 0)
                {
                    for(Id objid : setTotalUserIds)
                    {
                        String strbucket1contractids = '';
                        String strbucket30contractids = '';
                        Decimal TotalBalance = 0.00;
                        
                        ScCollection_Bucket_Movement_Data__c objdata;
                        
                        if(mapTodaysExistingData.containsKey(objid) && mapTodaysExistingData.get(objid) != Null)
                        {
                            objdata = mapTodaysExistingData.get(objid);
                        }
                        else
                        {
                            objdata = new ScCollection_Bucket_Movement_Data__c();
                        }
                        
                        objdata.ScCollection_Collector__c = objid;
                        objdata.ScCollection_Movement_Date__c = System.Today();
                        
                        if(mapUserToBucket1ContractIds.containsKey(objid) && mapUserToBucket1ContractIds.get(objid) != Null)
                        {
                            Set<Id> setB1Ids = mapUserToBucket1ContractIds.get(objid);
                            objdata.ScCollection_Bucket_1_Count__c = setB1Ids.size();
                            
                            for(Id objb1id : setB1Ids)
                            {
                                strbucket1contractids += objb1id + ',';
                                
                                if(mapContractToBalance.containsKey(objb1id) && mapContractToBalance.get(objb1id) != Null)
                                {
                                    TotalBalance += mapContractToBalance.get(objb1id);
                                }
                            }
                        }
                        else
                        {
                            objdata.ScCollection_Bucket_1_Count__c = 0;
                        }
                        
                        if(mapUserToBucket30ContractIds.containsKey(objid) && mapUserToBucket30ContractIds.get(objid) != Null)
                        {
                            Set<Id> setB30Ids = mapUserToBucket30ContractIds.get(objid);
                            objdata.ScCollection_30_Count__c = setB30Ids.size();
                            
                            for(Id objb30id : setB30Ids)
                            {
                                strbucket30contractids += objb30id + ',';
                                
                                if(mapContractToBalance.containsKey(objb30id) && mapContractToBalance.get(objb30id) != Null)
                                {
                                    TotalBalance += mapContractToBalance.get(objb30id);
                                }
                            }                            
                        }
                        else
                        {
                            objdata.ScCollection_30_Count__c = 0;
                        }
                                                
                        objdata.ScCollection_No_Movement_Balance__c = 0.00;
                        objdata.ScCollection_No_Movement_Count__c = 0;
                        objdata.ScCollection_Rolled_Down_Balance__c = 0.00;
                        objdata.ScCollection_Rolled_Down_Count__c = 0;
                        objdata.ScCollection_Rolled_Up_Balance__c = 0.00;
                        objdata.ScCollection_Rolled_Up_Count__c = 0;
                        objdata.ScCollection_Total_Balance__c = TotalBalance;
                        
                        if(strbucket1contractids != '')
                        {
                            objdata.ScCollection_Bucket_1_Contract_Ids__c = strbucket1contractids.subString(0,strbucket1contractids.length()-1);
                        }
                        
                        if(strbucket30contractids != '')
                        {
                            objdata.ScCollection_30_Contract_Ids__c = strbucket30contractids.substring(0,strbucket30contractids.length()-1);
                        }
                        
                        lstUpsertData.add(objdata);
                    }
                }
                
                if(ScCollection_UtilityHandler.isNotNull(lstUpsertData))
                {
                    try 
                    {
                        upsert lstUpsertData; 
                    }
                    catch(Exception e) 
                    {
                        system.debug('Error in Bucket Movement record insertion : ' + e.getMessage());
                    }    
                }
            }
        }
        else
        {
            ScCollection_RollRateReportBatch b = new ScCollection_RollRateReportBatch(); 
            database.executebatch(b,1);
        }
    }
}