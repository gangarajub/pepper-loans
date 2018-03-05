/*
AH 31/03/2017 THIS TRIGGER IS OBSOLETE AND REPLACED BY OpportunityTrigger.trigger

*/
trigger CRMtrgToUpdateApplication on Opportunity (after update) {
/*    
    set<String> setMortgageAppNumber = new set<String>();
    set<String> setPAFAppNum = new Set<String>();
    
    set<String> setMortgageOLDAppNumber = new set<String>();
    set<String> setOLDAppNumber = new set<String>();
    for(Opportunity opp : Trigger.new){
        if(!String.isBlank(opp.CRM_Application_ID__c)){
            if(opp.CRM_Loan_Type__c == 'Mortgage'){
                if(opp.CRM_Application_ID__c != Trigger.oldMap.get(opp.id).CRM_Application_ID__c){
                    setMortgageAppNumber.add(opp.CRM_Application_ID__c);
                    
                    if(Trigger.oldMap.get(opp.id).CRM_Application_ID__c != null){
                        setOLDAppNumber.add(Trigger.oldMap.get(opp.id).CRM_Application_ID__c);
                    }
                }
                
                    
            }
            else{
                if(opp.CRM_Application_ID__c != Trigger.oldMap.get(opp.id).CRM_Application_ID__c){
                    setPAFAppNum.add(opp.CRM_Application_ID__c);
                    if(Trigger.oldMap.get(opp.id).CRM_Application_ID__c != null){
                        setOLDAppNumber.add(Trigger.oldMap.get(opp.id).CRM_Application_ID__c);
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
    
    
    List<Pepper_Data__c> lstToUpdatePepperData = new List<Pepper_Data__c>();
    List<Application_Data__c> lstToUpdatePAFData = new List<Application_Data__c>();
    for(Opportunity opp : Trigger.new){
        if(!String.isBlank(opp.CRM_Application_ID__c)){
            if(opp.CRM_Loan_Type__c == 'Mortgage' && opp.CRM_Application_ID__c != Trigger.oldMap.get(opp.id).CRM_Application_ID__c){
                
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
            if(opp.CRM_Loan_Type__c == 'Asset Finance' && opp.CRM_Application_ID__c != Trigger.oldMap.get(opp.id).CRM_Application_ID__c){
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
    
    
    if(lstToUpdatePepperData != null && lstToUpdatePepperData.Size()>0){
        
        update lstToUpdatePepperData;
    }
    if(lstToUpdatePAFData != null && lstToUpdatePAFData.Size()>0){
        
        update lstToUpdatePAFData;
    }
        
 */   
}