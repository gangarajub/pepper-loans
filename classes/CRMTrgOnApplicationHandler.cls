//-----------------------------------------------------------------------------------------------------
// Date        : 5/12/2016
// Description : This class is to update forecast achieved values and update achieved value on account
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
public class CRMTrgOnApplicationHandler {
    //-----------------------------------------------------------------------------------------------------
    // Date        : 5/12/2016
    // Description : This method is to update forecast achieved values and update achieved value on account
    //-----------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-----------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-----------------------------------------------------------------------------------------------------
    public static void updateForecast(List<CRM_Application__c> lstTriggerNew,Map<Id,CRM_Application__c> oldMap){
        
        map<id,map<integer,map<integer,double>>> mapAccountIdtoMonthAmount = new map<id,map<integer,map<integer,double>>>();
        set<Id> setAccID = new set<Id>();
        //create set of Accountid
        if(lstTriggerNew != null && lstTriggerNew.Size()>0){
            
            for(CRM_Application__c objNewApplication : lstTriggerNew){
                
                if(Trigger.IsInsert && objNewApplication.CRM_Primary_Introducer__c != null){
                    setAccID.add(objNewApplication.CRM_Primary_Introducer__c); 
                }
                if(
                (Trigger.IsUpdate && objNewApplication.CRM_Primary_Introducer__c != null && 
                   (objNewApplication.CRM_Net_Amount_Financed_Amount__c != oldMap.get(objNewApplication.Id).CRM_Net_Amount_Financed_Amount__c
                 || objNewApplication.CRM_Settlement_Date__c != oldMap.get(objNewApplication.Id).CRM_Settlement_Date__c
                 || objNewApplication.CRM_Primary_Introducer__c != oldMap.get(objNewApplication.Id).CRM_Primary_Introducer__c ))){

                        setAccID.add(objNewApplication.CRM_Primary_Introducer__c); 
                    
                    if(objNewApplication.CRM_Primary_Introducer__c != oldMap.get(objNewApplication.Id).CRM_Primary_Introducer__c && 
                        oldMap.get(objNewApplication.Id).CRM_Primary_Introducer__c != null){
                        setAccID.add(oldMap.get(objNewApplication.Id).CRM_Primary_Introducer__c);
                    }
                    
                }       
            }
        }
            
        integer currentYear = System.Today().Year();
        integer currentMonth = System.Today().Month();
        system.debug(setAccID);
        List<CRM_Application__c> lstApplication = [select CRM_Settlement_Date__c,CRM_Primary_Introducer__c,CRM_Net_Amount_Financed_Amount__c from CRM_Application__c where
                                                    CRM_Primary_Introducer__c in : setAccID and CRM_Settlement_Date__c != null];
                                        
        List<CRM_Forecast__c> lstOfforecast = [select id,CRM_Introducer__c,CRM_Forecast_Year__c from CRM_Forecast__c where CRM_Introducer__c in : setAccID and CRM_Business_Unit__c = 'PAF'];
       
        map<Id,double> mapAccountidToYearSum = new map<Id,double>();
        map<Id,double> mapAccountIdToCurrentMonthSum = new map<Id,double>();
        set<Id> setAccountID = new set<Id>();
        
        Date todaysDate = System.Today();
        map<Id,double> mapAccountIdToQuarterSum = new map<Id,double>();
        
        if(lstApplication != null && lstApplication.size()>0){
            for(CRM_Application__c objApplication : lstApplication){
            
                if(objApplication.CRM_Primary_Introducer__c != null && objApplication.CRM_Settlement_Date__c != null){
                    
                    setAccountID.add(objApplication.CRM_Primary_Introducer__c);
                    //create Map of accountid and achieved month amount and map of achieved year amount
                    if(objApplication.CRM_Settlement_Date__c.year() == currentYear){
                        if(mapAccountidToYearSum.get(objApplication.CRM_Primary_Introducer__c) == null){
                            if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                mapAccountidToYearSum.put(objApplication.CRM_Primary_Introducer__c,objApplication.CRM_Net_Amount_Financed_Amount__c);
                            }
                            else{
                                mapAccountidToYearSum.put(objApplication.CRM_Primary_Introducer__c,0);
                            }
                        }
                        else{
                            double tempYear = mapAccountidToYearSum.get(objApplication.CRM_Primary_Introducer__c);
                            if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                tempYear = tempYear + objApplication.CRM_Net_Amount_Financed_Amount__c;
                            }
                            else{
                                tempYear = tempYear + 0;
                            }
                            mapAccountidToYearSum.put(objApplication.CRM_Primary_Introducer__c,tempYear);
                        }
                        if(objApplication.CRM_Settlement_Date__c.month() == currentMonth){
                            if(mapAccountIdToCurrentMonthSum.get(objApplication.CRM_Primary_Introducer__c) == null){
                                if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                    mapAccountIdToCurrentMonthSum.put(objApplication.CRM_Primary_Introducer__c,objApplication.CRM_Net_Amount_Financed_Amount__c);
                                }
                                else{
                                    mapAccountIdToCurrentMonthSum.put(objApplication.CRM_Primary_Introducer__c,0);
                                }
                            }
                            else{
                                double tempMonth = mapAccountIdToCurrentMonthSum.get(objApplication.CRM_Primary_Introducer__c);
                                if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                    tempMonth = tempMonth + objApplication.CRM_Net_Amount_Financed_Amount__c;                                   
                                }
                                else{
                                    tempMonth = tempMonth + 0;
                                }
                                mapAccountIdToCurrentMonthSum.put(objApplication.CRM_Primary_Introducer__c,tempMonth);
                            }
                        }
                        
                        //added 7-4-2017 --- to calculate fiscal year amount
                        if(getFiscalStartDate(objApplication.CRM_Settlement_Date__c)){
                            
                            if(mapAccountIdToQuarterSum.get(objApplication.CRM_Primary_Introducer__c) == null){
                                if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                    mapAccountIdToQuarterSum.put(objApplication.CRM_Primary_Introducer__c,objApplication.CRM_Net_Amount_Financed_Amount__c);
                                }
                                else{
                                    mapAccountIdToQuarterSum.put(objApplication.CRM_Primary_Introducer__c,0);
                                }
                            }
                            else{
                                double tempQuarterSum = mapAccountIdToQuarterSum.get(objApplication.CRM_Primary_Introducer__c);
                                if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                    tempQuarterSum = tempQuarterSum + objApplication.CRM_Net_Amount_Financed_Amount__c;
                                }
                                else{
                                    tempQuarterSum = tempQuarterSum + 0;
                                }
                                mapAccountIdToQuarterSum.put(objApplication.CRM_Primary_Introducer__c,tempQuarterSum);
                            }
                        }
                    }
                        
                    //creating map of accountid to amount map to year and month      
                    if(mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c) == null){
                        map<integer,double> innerMap = new map<integer,double>();
                        map<integer,map<integer,double>> innerMapYeartoMap = new map<integer,map<integer,double>>();
                        
                        
                        if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                            innerMap.put(objApplication.CRM_Settlement_Date__c.month(),objApplication.CRM_Net_Amount_Financed_Amount__c);
                        }
                        else{
                            innerMap.put(objApplication.CRM_Settlement_Date__c.month(),0);
                        }
                        innerMapYeartoMap.put(objApplication.CRM_Settlement_Date__c.year(),innerMap);
                        
                        mapAccountIdtoMonthAmount.put(objApplication.CRM_Primary_Introducer__c,innerMapYeartoMap);
                    }
                    else{
                    
                        if(mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c).get(objApplication.CRM_Settlement_Date__c.year()) == null ){
                            
                            map<integer,double> innerMap = new map<integer,double>();
                            
                            if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                innerMap.put(objApplication.CRM_Settlement_Date__c.month(),objApplication.CRM_Net_Amount_Financed_Amount__c);
                            }
                            else{
                                innerMap.put(objApplication.CRM_Settlement_Date__c.month(),0);
                            }
                            
                            mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c).put(objApplication.CRM_Settlement_Date__c.year(),innerMap);
                            
                        }
                        else{
                            if(mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c).get(objApplication.CRM_Settlement_Date__c.year()).get(objApplication.CRM_Settlement_Date__c.month()) == null){
                                if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                    mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c).get(objApplication.CRM_Settlement_Date__c.year()).put(objApplication.CRM_Settlement_Date__c.month(),objApplication.CRM_Net_Amount_Financed_Amount__c);
                                }
                                else{
                                    mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c).get(objApplication.CRM_Settlement_Date__c.year()).put(objApplication.CRM_Settlement_Date__c.month(),0);
                                }
                                
                            }
                            else{
                                    double temp = mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c).get(objApplication.CRM_Settlement_Date__c.year()).get(objApplication.CRM_Settlement_Date__c.month());
                                    if(objApplication.CRM_Net_Amount_Financed_Amount__c != null){
                                        temp = temp + objApplication.CRM_Net_Amount_Financed_Amount__c;
                                    }
                                    else{
                                        temp = temp + 0;
                                    }
                                    
                                    mapAccountIdtoMonthAmount.get(objApplication.CRM_Primary_Introducer__c).get(objApplication.CRM_Settlement_Date__c.year()).put(objApplication.CRM_Settlement_Date__c.month(),temp);
                                }
                            
                        } 
                    
                    }   
                
                }


            }
        }
        //this is to update Forecast wrt Account related to application
        if(lstOfforecast != null && lstOfforecast.size()>0){
            updateForecastWrtAccount(mapAccountIdtoMonthAmount,lstOfforecast);
        }
        //this is to update Account Achieved YTD and MTD field
        if(setAccountID != null && setAccountID.size()>0){
            updateAccountYTDandMTDfield(setAccId,mapAccountidToYearSum ,mapAccountIdToCurrentMonthSum,mapAccountIdToQuarterSum );
        }
        
        system.debug('%%%%mapAccountIdtoMonthAmount'+mapAccountIdtoMonthAmount);
        system.debug('%%%%mapAccountidToYearSum'+mapAccountidToYearSum);
        system.debug('%%%%mapAccountIdToCurrentMonthSum'+mapAccountIdToCurrentMonthSum);
    }
    
    //-----------------------------------------------------------------------------------------------------
    // Date        : 5/12/2016
    // Description : This method is to update Forecast wrt Account related to application
    //-----------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-----------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-----------------------------------------------------------------------------------------------------
    public static void updateForecastWrtAccount(map<id,map<integer,map<integer,double>>> mapAccountIdToMapofMonthAndAmount,List<CRM_Forecast__c> existingForecast){
      
        system.debug('inside');
        system.debug('mapAccountIdToMapofMonthAndAmount&& '+mapAccountIdToMapofMonthAndAmount);
        
        
        List<CRM_Forecast__c> newListToUpdate = new List<CRM_Forecast__c>();
        for(CRM_Forecast__c updateForecast : existingForecast){
            
            if(mapAccountIdToMapofMonthAndAmount.containskey(updateForecast.CRM_Introducer__c) && mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c) != null){
                
                if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).containskey(integer.valueof(updateForecast.CRM_Forecast_Year__c)) && 
                mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)) != null){
                    
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(1) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(1) != null){
                        updateForecast.CRM_January__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(1);
                    }
                    else{
                        updateForecast.CRM_January__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(2) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(2) != null){
                        updateForecast.CRM_February__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(2);
                    }
                    else{
                        updateForecast.CRM_February__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(3) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(3) != null){
                        updateForecast.CRM_March__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(3);
                    }
                    else{
                        updateForecast.CRM_March__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(4) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(4) != null){
                        updateForecast.CRM_April__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(4);
                    }
                    else{
                        updateForecast.CRM_April__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(5) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(5) != null){
                        updateForecast.CRM_May__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(5);
                    }
                    else{
                        updateForecast.CRM_May__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(6) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(6) != null){
                        updateForecast.CRM_June__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(6);
                    }
                    else{
                        updateForecast.CRM_June__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(7) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(7) != null){
                        updateForecast.CRM_July__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(7);
                    }
                    else{
                        updateForecast.CRM_July__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(8) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(8) != null){
                        updateForecast.CRM_August__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(8);
                    }
                    else{
                        updateForecast.CRM_August__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(9) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(9) != null){
                        updateForecast.CRM_September__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(9);
                    }
                    else{
                        updateForecast.CRM_September__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(10) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(10) != null){
                        updateForecast.CRM_October__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(10);
                    }
                    else{
                        updateForecast.CRM_October__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(11) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(11) != null){
                        updateForecast.CRM_November__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(11);
                    }
                    else{
                        updateForecast.CRM_November__c = 0;
                    }
                    if(mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).containskey(12) && 
                    mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(12) != null){
                        updateForecast.CRM_December__c = mapAccountIdToMapofMonthAndAmount.get(updateForecast.CRM_Introducer__c).get(integer.valueof(updateForecast.CRM_Forecast_Year__c)).get(12);
                    }
                    else{
                        updateForecast.CRM_December__c = 0;
                    }
                    
                    if(updateForecast.id != null){
                        newListToUpdate.add(updateForecast);
                    }
                        
                    
                }
                
            }
            
        }

        if(newListToUpdate != null && newListToUpdate.size()>0){
            update newListToUpdate;
        }
        
    }
    
    //-----------------------------------------------------------------------------------------------------
    // Date        : 5/12/2016
    // Description : This method is to update Account Achieved YTD and MTD field
    //-----------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-----------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-----------------------------------------------------------------------------------------------------
    public static void updateAccountYTDandMTDfield(set<id> setAccId , map<Id,double> mapAccToYearSum , map<Id,double> mapAccToMonthSum,map<Id,double> mapAccountIdToQuarterSum){
        List<Account> lstAccountToUpdate = new List<Account>();
        if(setAccId != null && setAccId.Size()>0){
            
            for(Id accId : setAccId){
                Account objAccountToUpdate = new Account();
                if(( mapAccToYearSum.containsKey(accId) && mapAccToYearSum.get(accId) != null) ||
                   (mapAccToMonthSum.containsKey(accId) && mapAccToMonthSum.get(accId) != null)){
                      
                    objAccountToUpdate.Id = accId;
                    
                    if(mapAccToYearSum.containsKey(accId) && mapAccToYearSum.get(accId) != null){
                        objAccountToUpdate.CRM_Achieved_YTD__c = mapAccToYearSum.get(accId);
                    }
                    if(mapAccToMonthSum.containsKey(accId) && mapAccToMonthSum.get(accId) != null){
                        objAccountToUpdate.CRM_Achieved_MTD__c = mapAccToMonthSum.get(accId);
                    }
                    if(mapAccountIdToQuarterSum.containsKey(accId) && mapAccountIdToQuarterSum.get(accId) != null){
                        objAccountToUpdate.CRM_Achieved_QTD__c = mapAccountIdToQuarterSum.get(accId);
                    }
                    lstAccountToUpdate.add(objAccountToUpdate);                   
                       
                }
                    
            }
            
        }
        
        if(lstAccountToUpdate != null && lstAccountToUpdate.size()>0){
            update lstAccountToUpdate;
        }
        
    }
    
    //-----------------------------------------------------------------------------------------------------
    // Date        : 7/4/2017
    // Description : This method is to check if the application lies in current fiscal year
    //-----------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-----------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-----------------------------------------------------------------------------------------------------
    
    public static boolean getFiscalStartDate(date dt){
    
        boolean checkCurrentFiscalYear = false;
        date todaysDate = System.Today();
        integer mth = todaysDate.Month();
        integer startMonth = 0;
        integer endMonth = 0;
        if(mth >= 1 && mth <=3){
            startMonth = 1;
            endMonth = 3;
        }
        else if(mth >= 4 && mth <=6){
            startMonth = 4;
            endMonth = 6;
        }
        else if(mth >= 7 && mth <=9){
            startMonth = 7;
            endMonth = 9;
        }
        else{
            startMonth = 10;
            endMonth = 12;
        }
        
        if(dt != null){
            //current year ----- 
            if(dt.Year() == todaysDate.Year()){
                if(dt.Month() >= startMonth && dt.Month() <= endMonth){
                    checkCurrentFiscalYear = true;
                }
            }
        }
        return checkCurrentFiscalYear;
    }
        
}