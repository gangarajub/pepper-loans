public class CRMtrgPAFtoOpportunityLookupHandler {
    
    /*
        public static void CreateOpportunityLookup(List<Application_Data__c> lstBeforeInsertApplicationRecords){
    
        Set<String> setString = new Set<String>();   
        for(Application_Data__c objApplicationData : lstBeforeInsertApplicationRecords){   
            if(!String.isBlank(objApplicationData.ApplicationNumber__c)){       
                setString.add(objApplicationData.ApplicationNumber__c);      
            }   
        }
        
        List<Opportunity> lstOpportunity = [select id,CRM_Application_ID__c from Opportunity where CRM_Application_ID__c in : setString];
        Map<String,ID> mapStringToOpportunityID = new Map<String,ID>();
        if(lstOpportunity != null && lstOpportunity.size()>0){
            for(Opportunity objOpp : lstOpportunity){      
                if(!String.isBlank(objOpp.CRM_Application_ID__c)){           
                    mapStringToOpportunityID.put(objOpp.CRM_Application_ID__c,objOpp.id);          
                }       
            }
        }
        list<Opportunity> lstToUpdateOpportunity = new List<Opportunity>();
        for(Application_Data__c objApplicationData : lstBeforeInsertApplicationRecords){   
            if(!String.isBlank(objApplicationData.ApplicationNumber__c)){ 
                if(mapStringToOpportunityID.get(objApplicationData.ApplicationNumber__c) !=null){
                    objApplicationData.CRM_Opportunity__c = mapStringToOpportunityID.get(objApplicationData.ApplicationNumber__c);
                    opportunity opp = new opportunity();
                    opp.id =  mapStringToOpportunityID.get(objApplicationData.ApplicationNumber__c);
                    opp.CRM_Actual_loan_amount__c = objApplicationData.NetFinancedAmount__c;
                    lstToUpdateOpportunity.add(opp);
                 } 
            }   
        }
    
        if(lstToUpdateOpportunity != null && lstToUpdateOpportunity.Size()>0){
            
            update lstToUpdateOpportunity;
        
        }
    
    }
    
    */
    Public static boolean temp = false;
    public static void UpdateOpportunityStatus(List<Application_Data__c> lstAfterUpdateApplicationRecords,Map<id,Application_Data__c> MapPAfOldValues){      
        List<Opportunity> lstToUpdateopp = new List<Opportunity>();
        for(Application_Data__c objApplication : lstAfterUpdateApplicationRecords){
            if(objApplication.CRM_Opportunity__c != null){
                Opportunity oppToUpdate = new Opportunity();
                oppToUpdate.id = objApplication.CRM_Opportunity__c;
                
                if(objApplication.Sub_Status__c == 'Approved'){
          
                    oppToUpdate.StageName = 'Formally Approved';                   
                    temp = true;
                }  
                
                if(objApplication.NetFinancedAmount__c != MapPAfOldValues.get(objApplication.id).NetFinancedAmount__c || objApplication.CRM_Opportunity__c != MapPAfOldValues.get(objApplication.id).CRM_Opportunity__c){
                   
                    oppToUpdate.CRM_Actual_loan_amount__c = objApplication.NetFinancedAmount__c;
                    temp = true;
                
                }  
                lstToUpdateopp.add(oppToUpdate);
            }        
        }
        
        if(lstToUpdateopp != null && lstToUpdateopp.Size()>0 && temp == true){
            update lstToUpdateopp;
        }
    
    }

}