public class CRMtrgMortageToOpportunityLookupHandler{

    //AH 29/03/17 Jira = SFC-96 - Test Class = CRM_Mtg_TestMortgageAppHandler/CRM_Mtg_MortgageAppHandlerTracker
    	//This method checks through the CRM_Mortgage_Application_Data__c records which are going to be inserted
    	//links them to the appropriate Opportunity, then updates the Opportunity with new Stage, Amount and Product if needed
    public static void updateOptyFromMortgageApplication(List<CRM_Mortgage_Application_Data__c> lstNewMortgageData){
        
        //get the list of Application Status's that mpa to Opty Stage 
        List<String> statusList = new List<String>();                
        List<ApplicationStatusToOptyMapping__c> listAppStatusToOptyStage  =  ApplicationStatusToOptyMapping__c.getAll().values();
        Map<String, ApplicationStatusToOptyMapping__c> mapAppStatusToOptyStage = new Map<String, ApplicationStatusToOptyMapping__c>();
        
        for(ApplicationStatusToOptyMapping__c a  : listAppStatusToOptyStage){
            mapAppStatusToOptyStage.put(a.Application_Status__c, a);
        }
                
        //if the new CRM_Mortgage_Application_Data__c records have an applicationId 
        Set<String> setApplicationIds = new Set<String>();  
		Integer i = 0;
        for(CRM_Mortgage_Application_Data__c mortgageApp : lstNewMortgageData){   
            if(!String.isBlank(mortgageApp.CRM_Mtg_Application_Id__c) ){       
                
                    setApplicationIds.add(mortgageApp.CRM_Mtg_Application_Id__c);     
                    i++;
            }   
        }

		//query any Opportunities related to these new Application records and store the applicationId and OptyId in a Map && check if the StageName = Closed Lost already
        integer existingApplications = 0;
        Map<String, Id> mapAppIdToOptyId = new Map<String, Id>();
        Map<Id, Opportunity> closedLostOptyMap = new Map<Id, Opportunity>();
        List<Opportunity> existingAppOptyList = [select Id, CRM_Application_ID__c, StageName from Opportunity where CRM_Application_ID__c in : setApplicationIds];
        if(existingAppOptyList != null && existingAppOptyList.size() > 0){
			for(Opportunity appOpty : existingAppOptyList){
                mapAppIdToOptyId.put(appOpty.CRM_Application_ID__c, appOpty.Id );
                existingApplications++;
                
				//build a map of Closed Lost ones - so we can link up the Applciation Records but NOT update the Stage
                if(appOpty.StageName == 'Closed Lost'){
                    closedLostOptyMap.put(appOpty.Id, appOpty);
                }
            }
        }
        
        if(existingApplications>0){
            Integer p = 0;
            Integer o1 = 0;
            Map<String, Decimal> appIdToHighestStage = new Map<String, Decimal>(); //this is used for multiple mortgageApplication records per day for 1 application because we only want the most recent Status to update the Opty
            Map <Id, Opportunity> optyToUpdate = new Map<Id, Opportunity>(); //keeps a unique list of the Optys to update if there are multiple new mortgageApplication records
            list<Opportunity> lstToUpdateOpty = new List<Opportunity>();
            
            for(CRM_Mortgage_Application_Data__c mortgageApplication : lstNewMortgageData){   
                //if we have an App Id and a matching Opty for the application...
                p++;
                //System.debug('>>>>>>>>>>> p : ' + p);
                //System.debug('mapAppIdToOptyId.get('+mortgageApplication.CRM_Mtg_Application_Id__c+'): ' + mapAppIdToOptyId.get(mortgageApplication.CRM_Mtg_Application_Id__c));
                   
                if(!String.isBlank(mortgageApplication.CRM_Mtg_Application_Id__c) && mapAppIdToOptyId.get(mortgageApplication.CRM_Mtg_Application_Id__c)!=null)
                {
					
                    //System.debug ('closedLostOptyMap('+mapAppIdToOptyId.get(mortgageApplication.CRM_Mtg_Application_Id__c)+') : ' + closedLostOptyMap.get( mapAppIdToOptyId.get(mortgageApplication.CRM_Mtg_Application_Id__c) ));
                    //if the Opty Id is NOT in the Closed Lost Opty List then DO update the Opty Record... OR if new Status is Settled (in which case we want to Overite the Closed Lost Stage)
                    if(closedLostOptyMap.get( mapAppIdToOptyId.get(mortgageApplication.CRM_Mtg_Application_Id__c) ) == null || mortgageApplication.CRM_Mtg_Application_Status__c == 'Settlement Booked' ){
						
                        //IF the Status Detail value exists in the Custom Setting AND the StageName to set is not null AND
                        // if we havent added this appId to the appIdToHighestStage map yet, OR if this mortgageApplication record has a HIGHER Order than the appId in appIdToHighestStage then we want to update the Opty
                        if(mapAppStatusToOptyStage.get(mortgageApplication.CRM_Mtg_Application_Status__c)!=null && mapAppStatusToOptyStage.get(mortgageApplication.CRM_Mtg_Application_Status__c).Opportunity_Stage_Name__c != null && 
                            (appIdToHighestStage.get(mortgageApplication.CRM_Mtg_Application_Id__c)==null || mapAppStatusToOptyStage.get(mortgageApplication.CRM_Mtg_Application_Status__c).Order__c > appIdToHighestStage.get(mortgageApplication.CRM_Mtg_Application_Id__c)) ){

                            //System.debug('Update the Opty: Id = ' + mapAppIdToOptyId.get(mortgageApplication.CRM_Mtg_Application_Id__c) +', StageName = ' + mapAppStatusToOptyStage.get(mortgageApplication.CRM_Mtg_Application_Status__c).Opportunity_Stage_Name__c );
                            Opportunity o = new Opportunity();
                            o.Id = mapAppIdToOptyId.get(mortgageApplication.CRM_Mtg_Application_Id__c);

                            o.StageName = mapAppStatusToOptyStage.get(mortgageApplication.CRM_Mtg_Application_Status__c).Opportunity_Stage_Name__c ;

                            o.CRM_Actual_loan_amount__c = mortgageApplication.CRM_Mtg_Application_Amount__c != o.CRM_Actual_loan_amount__c ? mortgageApplication.CRM_Mtg_Application_Amount__c : o.CRM_Actual_loan_amount__c ;
                            o.CRM_Product_Class_Name__c = mortgageApplication.CRM_Mtg_Product__c != o.CRM_Product_Class_Name__c ? mortgageApplication.CRM_Mtg_Product__c : o.CRM_Product_Class_Name__c;

                            optyToUpdate.put(o.Id, o);

                            appIdToHighestStage.put(mortgageApplication.CRM_Mtg_Application_Id__c, mapAppStatusToOptyStage.get(mortgageApplication.CRM_Mtg_Application_Status__c).Order__c );
                        }
                    }                        

                }
                   
            }
            //System.debug(p + ' Mortgage Application records linked to an Opty');
            //System.debug(lstToUpdateOpty.Size() + ' Opportunities updated');
			if(optyToUpdate.size()>0){
                lstToUpdateOpty = optyToUpdate.values();
            }
            
            if(lstToUpdateOpty != null && lstToUpdateOpty.Size()>0){

                update lstToUpdateOpty;

            }

        }
    }
      
        
}