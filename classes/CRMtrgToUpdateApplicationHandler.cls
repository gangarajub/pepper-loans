//-------------------------------------------------------------------------------------------------
// Date        : 28/09/2016
// Description : This class is use to update lookup of Opportunity on Application objects
//-------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-------------------------------------------------------------------------------------------------

public class CRMtrgToUpdateApplicationHandler {

    public static void updateApplicationLookup(List<Opportunity> triggerNew , map<id,Opportunity> triggerOldMap){
    
        set<String> setMortgageAppNumber = new set<String>();
        set<String> setPAFAppNum = new Set<String>();
        
        set<String> setMortgageOLDAppNumber = new set<String>();
        set<String> setOLDAppNumber = new set<String>();
        //creating set of PAF and Mortgage applidationid.
        if(triggerNew != null && triggerNew.size()>0){
            for(Opportunity opp : triggerNew){
                if(!String.isBlank(opp.CRM_Application_ID__c)){
                    if(opp.CRM_Loan_Type__c == 'Mortgage'){
                        if(opp.CRM_Application_ID__c != triggerOldMap.get(opp.id).CRM_Application_ID__c){
                            setMortgageAppNumber.add(opp.CRM_Application_ID__c);
                            
                            if(triggerOldMap.get(opp.id).CRM_Application_ID__c != null){
                                setOLDAppNumber.add(triggerOldMap.get(opp.id).CRM_Application_ID__c);
                            }
                        }           
                    }
                    else{
                        if(opp.CRM_Application_ID__c != triggerOldMap.get(opp.id).CRM_Application_ID__c){
                            setPAFAppNum.add(opp.CRM_Application_ID__c);
                            if(triggerOldMap.get(opp.id).CRM_Application_ID__c != null){
                                setOLDAppNumber.add(triggerOldMap.get(opp.id).CRM_Application_ID__c);
                            }
                        }
                        
                    }
                }   
            }
        }
            
        
        List<Pepper_Data__c> lstPepperData = [select id,ApplicationID__c,Mortgage_FK__c,CRM_Opportunity__c from Pepper_Data__c where ApplicationID__c in : setMortgageAppNumber For Update];
        
        Map<string,Pepper_Data__c> mapMortgageIDtoApp = new Map<string,Pepper_Data__c>();
        if(lstPepperData != null && lstPepperData.Size()>0){
            for(Pepper_Data__c objPepperData : lstPepperData ){
                
                if(objPepperData.ApplicationID__c != null){
                    mapMortgageIDtoApp.put(objPepperData.ApplicationID__c,objPepperData); 
                }
                   
            }
        }
        
        List<Application_Data__c> lstApplicationData = [select id,ApplicationNumber__c,CRM_Opportunity__c from Application_Data__c where ApplicationNumber__c in : setPAFAppNum For Update];
        
        Map<string,Application_Data__c> mapPAFIDtoApp = new Map<string,Application_Data__c>();
        if(lstApplicationData != null && lstApplicationData.Size()>0){
            for(Application_Data__c objAppData : lstApplicationData){
            
                if(objAppData.ApplicationNumber__c != null){
                    mapPAFIDtoApp.put(objAppData.ApplicationNumber__c,objAppData); 
                }        
            }
        }
        
        //update the lookup of opportunity 
        List<Pepper_Data__c> lstToUpdatePepperData = new List<Pepper_Data__c>();
        List<Application_Data__c> lstToUpdatePAFData = new List<Application_Data__c>();
        if(triggerNew != null && triggerNew.size()>0){
            for(Opportunity opp : triggerNew){
                if(!String.isBlank(opp.CRM_Application_ID__c)){
                    if(opp.CRM_Loan_Type__c == 'Mortgage' && opp.CRM_Application_ID__c != triggerOldMap.get(opp.id).CRM_Application_ID__c){
                        
                        if(mapMortgageIDtoApp.ContainsKey(opp.CRM_Application_ID__c)){
                            Pepper_Data__c objPepApp = new Pepper_Data__c();
                            objPepApp.id = mapMortgageIDtoApp.get(opp.CRM_Application_ID__c).id;
                            objPepApp.CRM_Opportunity__c = opp.id;
                            lstToUpdatePepperData.add(objPepApp);
                        }
                        else{
                            opp.CRM_Application_ID__c.addError('Invalid application ID');
                        }
                    }
                    if(opp.CRM_Loan_Type__c == 'Asset Finance' && opp.CRM_Application_ID__c != triggerOldMap.get(opp.id).CRM_Application_ID__c){
                        if(mapPAFIDtoApp.ContainsKey(opp.CRM_Application_ID__c)){
                            Application_Data__c objPAFData = new Application_Data__c();
                            objPAFData.id = mapPAFIDtoApp.get(opp.CRM_Application_ID__c).id;
                            objPAFData.CRM_Opportunity__c = opp.id;
                            lstToUpdatePAFData.add(objPAFData);
                        }
                        else{
                            opp.CRM_Application_ID__c.addError('Invalid application ID');
                        }
                    }   
                }   
            }
        }
            
        
        
    //To Remove Lookup from previous Application-----------------------------------------------------------------------------   
        
        List<Application_Data__c> lstChangedApplicationData = [select id,ApplicationNumber__c,CRM_Opportunity__c from Application_Data__c where ApplicationNumber__c in : setOLDAppNumber for update];
        List<Application_Data__c> listToClearOpportunityLookup = new List<Application_Data__c>();
        if(lstChangedApplicationData != null && lstChangedApplicationData.size()>0){
            For(Application_Data__c objApplication : lstChangedApplicationData){
            
                if(objApplication.CRM_Opportunity__c != null){
                
                    objApplication.CRM_Opportunity__c=null;
                }
                listToClearOpportunityLookup.add(objApplication);
            }  
        }
        
        if(listToClearOpportunityLookup !=null && listToClearOpportunityLookup.size()>0){
        
            update listToClearOpportunityLookup;
        
        }
        
        List<Pepper_Data__c> lstChangedPepperData = [select id,ApplicationID__c,Mortgage_FK__c,CRM_Opportunity__c from Pepper_Data__c where ApplicationID__c in : setOLDAppNumber For Update];
        List<Pepper_Data__c> listPepperDataToClearOpportunityLookup = new List<Pepper_Data__c>();
        if(lstChangedPepperData != null && lstChangedPepperData.size()>0){
            For(Pepper_Data__c objPepperData : lstChangedPepperData){
            
                if(objPepperData.CRM_Opportunity__c != null){
                
                    objPepperData.CRM_Opportunity__c=null;
                }
                listPepperDataToClearOpportunityLookup.add(objPepperData);
            }  
        }
        
        if(listPepperDataToClearOpportunityLookup !=null && listPepperDataToClearOpportunityLookup.size()>0){
        
            update listPepperDataToClearOpportunityLookup;
        
        }
        
        //update new lookup
        if(lstToUpdatePepperData != null && lstToUpdatePepperData.Size()>0){
            
            update lstToUpdatePepperData;
        }
        if(lstToUpdatePAFData != null && lstToUpdatePAFData.Size()>0){
            
            update lstToUpdatePAFData;
        } 
    }
    
    //-------------------------------------------------------------------------------------------------
    // Date        : 10/3/2017
    // Description : This method is use to create opportunity stage tracking record if stage changes of opportunity
    //-------------------------------------------------------------------------------------------------
    // Version                           Author                                Email
    //-------------------------------------------------------------------------------------------------
    //   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
    //-------------------------------------------------------------------------------------------------
    
    public static void CreateOpportunityStageTrackingRecord(List<Opportunity> lstnew , Map<Id,Opportunity> oldmap){
        List<CRM_Opportunity_Stage_Tracking__c> lstStageTracking = new List<CRM_Opportunity_Stage_Tracking__c>();
        if(lstnew != null && lstnew.size()>0){
            for(Opportunity opp : lstnew){
                CRM_Opportunity_Stage_Tracking__c objStageTracking = new CRM_Opportunity_Stage_Tracking__c();
                if(Trigger.isInsert){
                    if(opp.StageName != null){
                        objStageTracking.CRM_Old_Value__c = '';
                        objStageTracking.CRM_New_Value__c = opp.StageName;
                        objStageTracking.CRM_Changed_Date__c = System.Today();
                        objStageTracking.CRM_Opportunity__c = opp.Id;
                        lstStageTracking.add(objStageTracking);
                    }
                }
                else if(Trigger.isUpdate && oldmap.ContainsKey(opp.Id) && oldmap.get(opp.Id).StageName != opp.StageName){
                    objStageTracking.CRM_Old_Value__c = oldmap.get(opp.Id).StageName;
                    objStageTracking.CRM_New_Value__c = opp.StageName;
                    objStageTracking.CRM_Changed_Date__c = System.Today();
                    objStageTracking.CRM_Opportunity__c = opp.Id;
                    lstStageTracking.add(objStageTracking);
                }
            }
        }
        
        if(lstStageTracking != null && lstStageTracking.Size()>0){
            try{
                insert lstStageTracking;
            }
            catch(Exception ex){
                system.debug('Message-'+ex.getMessage());
                system.debug('Stack Trace-'+ex.getStackTraceString());
            }
        }
    }




}