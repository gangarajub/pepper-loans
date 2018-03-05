//-----------------------------------------------------------------------------------------------------
// Date        : 6/12/2016
// Description : This class is to update forecast achieved values,update Account Acheived YTD and MTD
// and create or update Forecast Reporting record
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
public class CRMtrgOnForecastHandler{
    public static boolean firstRun = true;
    //-----------------------------------------------------------------------------------------------------
    // Date        : 6/12/2016
    // Description : This method is to update forecast Acheived value from already present application
    //-----------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-----------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-----------------------------------------------------------------------------------------------------
    public static void updateFieldsFromApplication(List<CRM_Forecast__c> lstTriggerNew){
        
        set<Id> setOfAccId = new set<Id>();
        map<id,map<integer,map<integer,double>>> mapAccountIdtoMonthAmount = new map<id,map<integer,map<integer,double>>>();
        
        
        if(lstTriggerNew != null && lstTriggerNew.size()>0){
            
            for(CRM_Forecast__c objforecast : lstTriggerNew){
                if(objforecast.CRM_Introducer__c != null){
                    if(objforecast.CRM_Business_Unit__c == 'PAF'){
                        setOfAccId.add(objforecast.CRM_Introducer__c);
                        
                        
                    }
                }   
            }
            
            List<CRM_Application__c> lstApplication = [select CRM_Settlement_Date__c,CRM_Primary_Introducer__c,CRM_Net_Amount_Financed_Amount__c from CRM_Application__c where
                                                       CRM_Primary_Introducer__c in : setOfAccId];
            //creating map of accountid to amount from existing application
            if(lstApplication != null && lstApplication.size()>0){
                
                for(CRM_Application__c objApplication : lstApplication){
            
                    if(objApplication.CRM_Primary_Introducer__c != null && objApplication.CRM_Settlement_Date__c != null){
        
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
            //this calls the CRMTrgOnApplicationHandler to update the forecast Achieved Value
            CRMTrgOnApplicationHandler.updateForecastWrtAccount(mapAccountIdtoMonthAmount,lstTriggerNew);
        }
        
    }
    
    //-----------------------------------------------------------------------------------------------------
    // Date        : 6/12/2016
    // Description : This method is to update forecast reporting record related to forecast and MTD,YTD 
    // on Account 
    //-----------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-----------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-----------------------------------------------------------------------------------------------------

    public static void createOrUpdateForecastReporting(List<CRM_Forecast__c> lstForcast,Map<Id,CRM_Forecast__c> oldMap){
        //creating map of Year to its respective year number
        map<string,integer> mapMonthNameToInteger = new map<string,Integer>();
        mapMonthNameToInteger.put('January',1);
        mapMonthNameToInteger.put('February',2);
        mapMonthNameToInteger.put('March',3);
        mapMonthNameToInteger.put('April',4);
        mapMonthNameToInteger.put('May',5);
        mapMonthNameToInteger.put('June',6);
        mapMonthNameToInteger.put('July',7);
        mapMonthNameToInteger.put('August',8);
        mapMonthNameToInteger.put('September',9);
        mapMonthNameToInteger.put('October',10);
        mapMonthNameToInteger.put('November',11);
        mapMonthNameToInteger.put('December',12);
        
        map<Id,map<integer,map<integer,double>>> mapIdYearMonthDouble = new map<Id,map<Integer,map<integer,double>>>();
        map<id,map<integer,double>> mapIdToYearSum = new map<id,map<integer,double>>();
        integer currentYear = System.Today().Year();
        integer currentMonth = System.Today().Month();
        
        set<Id> setForecastID = new set<Id>();
        if(lstForcast != null && lstForcast.size()>0){
            for(CRM_Forecast__c objForecast : lstForcast){
                
                setForecastID.add(objForecast.id);
                
                if( (Trigger.IsInsert)||
                    ( (Trigger.IsUpdate) && (objForecast.CRM_Target_January__c != oldMap.get(objForecast.id).CRM_Target_January__c || 
                    objForecast.CRM_Target_February__c != oldMap.get(objForecast.id).CRM_Target_February__c || 
                    objForecast.CRM_Target_March__c != oldMap.get(objForecast.id).CRM_Target_March__c || 
                    objForecast.CRM_Target_April__c != oldMap.get(objForecast.id).CRM_Target_April__c || 
                    objForecast.CRM_Target_May__c != oldMap.get(objForecast.id).CRM_Target_May__c || 
                    objForecast.CRM_Target_June__c != oldMap.get(objForecast.id).CRM_Target_June__c || 
                    objForecast.CRM_Target_July__c != oldMap.get(objForecast.id).CRM_Target_July__c || 
                    objForecast.CRM_Target_August__c != oldMap.get(objForecast.id).CRM_Target_August__c || 
                    objForecast.CRM_Target_September__c != oldMap.get(objForecast.id).CRM_Target_September__c || 
                    objForecast.CRM_Target_October__c != oldMap.get(objForecast.id).CRM_Target_October__c || 
                    objForecast.CRM_Target_November__c != oldMap.get(objForecast.id).CRM_Target_November__c || 
                    objForecast.CRM_Target_December__c != oldMap.get(objForecast.id).CRM_Target_December__c ))){
                        
                        if(objforecast.CRM_Introducer__c != null){
                            if(objforecast.CRM_Business_Unit__c == 'PAF'){
                                
                                if(objforecast.CRM_Forecast_Year__c == string.valueOf(currentYear)){
                                    if(mapIdYearMonthDouble.get(objforecast.CRM_Introducer__c) == null){
                                        //map of acc id to current year and total target volume
                                        Map<integer,double> mapYearToSum = new map<integer,double>();
                                        if(objforecast.CRM_Total_Target_Volume__c != null){
                                            //mapYearToSum.put(currentYear,objforecast.CRM_Total_Target_Volume__c);
                                        }
                                        else{
                                            //mapYearToSum.put(currentYear,0);
                                        }
                                        
                                        double yearsum = 0;
                                        //map of acc id to current year to current month to target volume
                                        Map<integer,double> mapMonthToSum = new map<integer,double>();
                                        if(objforecast.CRM_Target_January__c != null){
                                            mapMonthToSum.put(1,objforecast.CRM_Target_January__c);
                                            yearsum += objforecast.CRM_Target_January__c;
                                            }
                                        else
                                            mapMonthToSum.put(1,0);
                                        if(objforecast.CRM_Target_February__c != null){
                                            mapMonthToSum.put(2,objforecast.CRM_Target_February__c);
                                            yearsum += objforecast.CRM_Target_February__c;
                                            }
                                        else
                                            mapMonthToSum.put(2,0);
                                        if(objforecast.CRM_Target_March__c != null){
                                            mapMonthToSum.put(3,objforecast.CRM_Target_March__c);
                                            yearsum += objforecast.CRM_Target_March__c;
                                        }  
                                        else
                                            mapMonthToSum.put(3,0);
                                        if(objforecast.CRM_Target_April__c != null){
                                            mapMonthToSum.put(4,objforecast.CRM_Target_April__c);
                                            yearsum += objforecast.CRM_Target_April__c;
                                        }   
                                        else
                                            mapMonthToSum.put(4,0);
                                        if(objforecast.CRM_Target_May__c != null){
                                             mapMonthToSum.put(5,objforecast.CRM_Target_May__c);
                                            yearsum += objforecast.CRM_Target_May__c;
                                        }  
                                        else
                                            mapMonthToSum.put(5,0);
                                        if(objforecast.CRM_Target_June__c != null){
                                            mapMonthToSum.put(6,objforecast.CRM_Target_June__c);
                                            yearsum += objforecast.CRM_Target_June__c;
                                        }  
                                        else
                                            mapMonthToSum.put(6,0);
                                        if(objforecast.CRM_Target_July__c != null){
                                            mapMonthToSum.put(7,objforecast.CRM_Target_July__c);
                                            yearsum += objforecast.CRM_Target_July__c;
                                        }   
                                        else
                                            mapMonthToSum.put(7,0);
                                        if(objforecast.CRM_Target_August__c != null){
                                            mapMonthToSum.put(8,objforecast.CRM_Target_August__c);
                                            yearsum += objforecast.CRM_Target_August__c;
                                        }   
                                        else
                                            mapMonthToSum.put(8,0);
                                        if(objforecast.CRM_Target_September__c != null){
                                            mapMonthToSum.put(9,objforecast.CRM_Target_September__c);
                                            yearsum += objforecast.CRM_Target_September__c;
                                        }
                                            
                                        else
                                            mapMonthToSum.put(9,0);
                                        if(objforecast.CRM_Target_October__c != null){
                                            mapMonthToSum.put(10,objforecast.CRM_Target_October__c);
                                            yearsum += objforecast.CRM_Target_October__c;
                                        }
                                            
                                        else
                                            mapMonthToSum.put(10,0);
                                        if(objforecast.CRM_Target_November__c != null){
                                            mapMonthToSum.put(11,objforecast.CRM_Target_November__c);
                                            yearsum += objforecast.CRM_Target_November__c;
                                        }   
                                        else
                                            mapMonthToSum.put(11,0);
                                        if(objforecast.CRM_Target_December__c != null){
                                            mapMonthToSum.put(12,objforecast.CRM_Target_December__c);
                                            yearsum += objforecast.CRM_Target_December__c;
                                        }   
                                        else
                                            mapMonthToSum.put(12,0);
                                        
                                        mapYearToSum.put(currentYear,yearsum);    
                                        mapIdToYearSum.put(objforecast.CRM_Introducer__c,mapYearToSum);
                                        Map<integer,map<integer,double>> mapTemp = new map<integer,map<integer,double>>();
                                        mapTemp.put(currentYear,mapMonthToSum);
                                        mapIdYearMonthDouble.put(objforecast.CRM_Introducer__c,mapTemp);
                                    }
                                }
                            }
                        }
                        
                        
                    }
                 
            }
        }
        if(mapIdYearMonthDouble != null && mapIdYearMonthDouble.Size()>0 && mapIdYearMonthDouble.KeySet() != null && mapIdYearMonthDouble.KeySet().Size()>0){
            //update account Target Month ToDate and yeartoDate------------------------
            updateMTDonAccount(mapIdYearMonthDouble,mapIdToYearSum,currentYear,currentMonth);
        }
              
        
        List<Forecast_Reporting__c> lstForecastReporting = [select id,Forecast__c,Month__c,Year__c,Date__c,Actual__c,Target__c from Forecast_Reporting__c 
                                                            where Forecast__c in : setForecastID];
        
        map<id,map<integer,Forecast_Reporting__c>> mapForecastIdtoMonthObject = new map<id,map<integer,Forecast_Reporting__c>>();
        //Map of forcastId to forecastReporting wrt month
        if(lstForecastReporting != null && lstForecastReporting.size()>0){
            
            for(Forecast_Reporting__c objForReporting : lstForecastReporting){
                
                if(objForReporting.Forecast__c != null && objForReporting.Month__c != null){
                    if(mapForecastIdtoMonthObject.get(objForReporting.Forecast__c) == null){
                        
                        mapForecastIdtoMonthObject.put(objForReporting.Forecast__c,new map<integer,Forecast_Reporting__c>());
                    }
                    mapForecastIdtoMonthObject.get(objForReporting.Forecast__c).put(mapMonthNameToInteger.get(objForReporting.Month__c),objForReporting);
                }
            }
        }
        
        List<Forecast_Reporting__c> lstToUpdateForecast = new List<Forecast_Reporting__c>();
        List<Forecast_Reporting__c> lstToInsertForecast = new List<Forecast_Reporting__c>();
        List<Forecast_Reporting__c> lstToDeleteForecast = new List<Forecast_Reporting__c>();
        if(lstForcast != null && lstForcast.size()>0){
            
            for(CRM_Forecast__c objforecastUpdate : lstForcast){
                //Check january reporting value--------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_January__c != null && objforecastUpdate.CRM_Target_January__c != 0){
                    //update existing forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(1) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(1) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(1);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_January__c || objReporting.Actual__c != objforecastUpdate.CRM_January__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_January__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_January__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 1, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }   
                    }
                    //insert existing forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'January';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_January__c;
                        objForReporting.Name = 'January-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 1, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete existing forecast record for which no Target is set--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(1) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(1) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(1);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check February reporting value----------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_February__c != null && objforecastUpdate.CRM_Target_February__c != 0){
                    //update existing forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(2) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(2) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(2);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_February__c ||objReporting.Actual__c != objforecastUpdate.CRM_February__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_February__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_February__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 2, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert existing forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'February';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_February__c;
                        objForReporting.Name = 'February-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 2, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete existing forecast record for which no Target is set--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(2) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(2) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(2);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check march --------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_March__c != null && objforecastUpdate.CRM_Target_March__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(3) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(3) != null ){
                            
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(3);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_March__c || objReporting.Actual__c != objforecastUpdate.CRM_March__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_March__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_March__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 3, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'March';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_March__c;
                        objForReporting.Name = 'March-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 3, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                // delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(3) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(3) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(3);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check April-----------------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_April__c != null && objforecastUpdate.CRM_Target_April__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(4) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(4) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(4);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_April__c || objReporting.Actual__c != objforecastUpdate.CRM_April__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_April__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_April__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 4, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'April';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_April__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        objForReporting.Name = 'April-'+objforecastUpdate.CRM_Forecast_Year__c;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 4, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(4) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(4) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(4);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check May ----------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_May__c != null && objforecastUpdate.CRM_Target_May__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(5) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(5) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(5);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_May__c || objReporting.Actual__c != objforecastUpdate.CRM_May__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_May__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_May__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 5, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'May';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_May__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        objForReporting.Name = 'May-'+objforecastUpdate.CRM_Forecast_Year__c;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 5, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(5) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(5) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(5);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check june -------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_June__c != null && objforecastUpdate.CRM_Target_June__c != 0){
                    //updateforecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(6) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(6) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(6);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_June__c || objReporting.Actual__c != objforecastUpdate.CRM_June__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_June__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_June__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 6, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'June';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_June__c;
                        objForReporting.Name = 'June-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 6, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(6) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(6) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(6);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check July ---------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_July__c != null && objforecastUpdate.CRM_Target_July__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(7) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(7) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(7);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_July__c || objReporting.Actual__c != objforecastUpdate.CRM_July__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_July__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_July__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 7, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'July';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_July__c;
                        objForReporting.Name = 'July-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 7, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(7) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(7) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(7);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check August -------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_August__c != null && objforecastUpdate.CRM_Target_August__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(8) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(8) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(8);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_August__c || objReporting.Actual__c != objforecastUpdate.CRM_August__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_August__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_August__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 8, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'August';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_August__c;
                        objForReporting.Name = 'August-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 8, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(8) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(8) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(8);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check September -----------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_September__c != null && objforecastUpdate.CRM_Target_September__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(9) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(9) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(9);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_September__c || objReporting.Actual__c != objforecastUpdate.CRM_September__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_September__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_September__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 9, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'September';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_September__c;
                        objForReporting.Name = 'September-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 9, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(9) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(9) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(9);   
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check October ----------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_October__c != null && objforecastUpdate.CRM_Target_October__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(10) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(10) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(10);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_October__c || objReporting.Actual__c != objforecastUpdate.CRM_October__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_October__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_October__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 10, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'October';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_October__c;
                        objForReporting.Name = 'October-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 10, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(10) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(10) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(10);  
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check November ---------------------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_November__c != null && objforecastUpdate.CRM_Target_November__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(11) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(11) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(11);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_November__c || objReporting.Actual__c != objforecastUpdate.CRM_November__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_November__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_November__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 11, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    // insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'November';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_November__c;
                        objForReporting.Name = 'November-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 11, 1);
                        }
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(11) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(11) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(11);  
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
                //Check December ----------------------------------------------------------------------------------------------------
                //update or insert forecast record--------
                if(objforecastUpdate.CRM_Target_December__c != null && objforecastUpdate.CRM_Target_December__c != 0){
                    //update forecast record--------
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(12) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(12) != null ){
                          
                            Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(12);
                            if(objReporting.Target__c != objforecastUpdate.CRM_Target_December__c || objReporting.Actual__c != objforecastUpdate.CRM_December__c){
                                objReporting.Target__c = objforecastUpdate.CRM_Target_December__c;
                                objReporting.Actual__c = objforecastUpdate.CRM_December__c;
                                if(objforecastUpdate.CRM_Forecast_Year__c != null){
                                    objReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 12, 1);
                                }
                                lstToUpdateForecast.add(objReporting);
                            }
                            
                        
                    }
                    //insert forecast record--------
                    else{
                        Forecast_Reporting__c objForReporting = new Forecast_Reporting__c();
                        objForReporting.Account__c = objforecastUpdate.CRM_Introducer__c;
                        objForReporting.Month__c = 'December';
                        objForReporting.Year__c = objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Target__c = objforecastUpdate.CRM_Target_December__c;
                        objForReporting.Name = 'December-'+objforecastUpdate.CRM_Forecast_Year__c;
                        objForReporting.Forecast__c = objforecastUpdate.id;
                        if(objforecastUpdate.CRM_Forecast_Year__c != null){
                            objForReporting.Date__c = Date.newInstance(integer.valueof(objforecastUpdate.CRM_Forecast_Year__c), 12, 1);
                        }
                            
                        lstToInsertForecast.add(objForReporting);
                        
                    }
                }
                //delete forecast record--------
                else{
                    if(mapForecastIdtoMonthObject.containsKey(objforecastUpdate.id) && mapForecastIdtoMonthObject.get(objforecastUpdate.id) != null &&
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).containsKey(12) && 
                        mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(12) != null ){
                        
                        Forecast_Reporting__c objReporting = mapForecastIdtoMonthObject.get(objforecastUpdate.id).get(12);  
                        lstToDeleteForecast.add(objReporting);
                    }
                }
                
            }
            
        }
        if(lstToInsertForecast != null && lstToInsertForecast.size()>0){
            insert lstToInsertForecast;
        }
        if(lstToUpdateForecast != null && lstToUpdateForecast.size()>0){
            update lstToUpdateForecast;
        }
        if(lstToDeleteForecast != null && lstToDeleteForecast.size()>0){
            delete lstToDeleteForecast;
        }
    
    }
    
    //-----------------------------------------------------------------------------------------------------
    // Date        : 6/12/2016
    // Description : This method is to update Account Target YTD and MTD
    //-----------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-----------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-----------------------------------------------------------------------------------------------------
    public static void updateMTDonAccount(map<Id,map<integer,map<integer,double>>> mapForMonthToDate,map<id,map<integer,double>> mapForYearTotalTarget,integer currYear , integer currMonth){
        List<Account> lstAccountToUpdate = new List<Account>();
        System.debug('inside account');
        
        //Calculation for QTD
        date todaysDate = System.Today();
        integer mth = todaysDate.Month();
        integer startMonth = 0;
        integer midMonth = 0;
        integer endMonth = 0;
        
        if(mth >= 1 && mth <=3){
            startMonth = 1;
            midMonth = 2;
            endMonth = 3;
        }
        else if(mth >= 4 && mth <=6){
            startMonth = 4;
            midMonth = 5;
            endMonth = 6;
        }
        else if(mth >= 7 && mth <=9){
            startMonth = 7;
            midMonth = 8;
            endMonth = 9;
        }
        else{
            startMonth = 10;
            midMonth = 11;
            endMonth = 12;
        }
        
        map<Id,double> mapAccIdToQuarterAmount = new map<Id,double>();
        if(mapForMonthToDate != null && mapForMonthToDate.keySet().Size()>0){
            for(id accID : mapForMonthToDate.keySet()){
                if(mapForMonthToDate.get(accID).containsKey(currYear) && mapForMonthToDate.get(accID).get(currYear) != null){
                    double tempAmount = 0;
                    if(mapForMonthToDate.get(accID).get(currYear).containsKey(startMonth) && mapForMonthToDate.get(accID).get(currYear).get(startMonth) != null){
                        tempAmount = tempAmount + mapForMonthToDate.get(accID).get(currYear).get(startMonth);
                    }
                    if(mapForMonthToDate.get(accID).get(currYear).containsKey(midMonth) && mapForMonthToDate.get(accID).get(currYear).get(midMonth) != null){
                        tempAmount = tempAmount + mapForMonthToDate.get(accID).get(currYear).get(midMonth);
                    }
                    if(mapForMonthToDate.get(accID).get(currYear).containsKey(endMonth) && mapForMonthToDate.get(accID).get(currYear).get(endMonth) != null){
                        tempAmount = tempAmount + mapForMonthToDate.get(accID).get(currYear).get(endMonth);
                    }
                    mapAccIdToQuarterAmount.put(accId,tempAmount);
                }
            }
        }
        //QTD map ends----------------
        
        system.debug(mapAccIdToQuarterAmount);
        system.debug(mapForYearTotalTarget);
        if(mapForMonthToDate != null && mapForMonthToDate.keySet().Size()>0){
            for(id accID : mapForMonthToDate.keySet()){
                
                Account acc = new Account();
                acc.id = accID;
                if(mapForMonthToDate.get(accID) != null && mapForMonthToDate.get(accID).containsKey(currYear) && mapForMonthToDate.get(accID).get(currYear) != null &&
                mapForMonthToDate.get(accID).get(currYear).containsKey(currMonth) && mapForMonthToDate.get(accID).get(currYear).get(currMonth) != null ){
                    acc.CRM_Target_MTD__c = mapForMonthToDate.get(accID).get(currYear).get(currMonth);
                }
                if(mapForYearTotalTarget.containsKey(accID) && mapForYearTotalTarget.get(accID) != null && mapForYearTotalTarget.get(accID).containsKey(currYear) &&
                mapForYearTotalTarget.get(accID).get(currYear) != null){
                    acc.CRM_Target_YTD__c = mapForYearTotalTarget.get(accID).get(currYear) ;
                }
                if(mapAccIdToQuarterAmount.containsKey(accID) && mapAccIdToQuarterAmount.get(accID) != null){
                    acc.CRM_Target_QTD__c = mapAccIdToQuarterAmount.get(accID);
                }
                lstAccountToUpdate.add(acc);     
            }
        }
        
        if(lstAccountToUpdate != null && lstAccountToUpdate.size()>0){
        System.debug('updating account');
            update lstAccountToUpdate;
        }
    }

}