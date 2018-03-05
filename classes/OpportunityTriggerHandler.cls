/*
 * AH 31/03/2017 - Opportunity Trigger processing Class
 * Code changed to the Mortgage Application sections, not the other Application_Data__c tables
 * 
 * AH 01/11/17 - linkMortgageApplicationData is now OBSOLETE for Mortgages - the data feed from Next Gen has changed from 1:m to 1:1 and so there are no records to link up
 * 					the business have a tight process in place to enter the Application Number on the Opportunity as soon as its submitted so it should always be in place
 * 					
 */
public class OpportunityTriggerHandler
{
    public static void linkMortgageApplicationData(List<Opportunity> triggerNewOptyList, Map<Id, Opportunity> oldOptyMap)
    {
     //   set<String> setMortgageAppNumber = new set<String>();
        set<String> setPAFAppNum = new Set<String>();

//        set<String> setMortgageOLDAppNumber = new set<String>();
        set<String> setOLDAppNumber = new set<String>();

  //      Map<String, Id> appIdToOptyId = new Map<String, Id>();

        //ONLY INTERESTED IN OPTYs WHERE THE APPLICATION ID HAS CHANGED...    
        for(Opportunity opp : triggerNewOptyList){
            if(!String.isBlank(opp.CRM_Application_ID__c)){
                if(opp.CRM_Loan_Type__c == 'Mortgage'){
/*                    if(opp.CRM_Application_ID__c != oldOptyMap.get(opp.id).CRM_Application_ID__c){
                        //build a set of Application Ids to link with the Opty
                        setMortgageAppNumber.add(opp.CRM_Application_ID__c);

                        //map the opty Id to the Application Id
                        appIdToOptyId.put(opp.CRM_Application_ID__c, opp.Id);

						//build a set of OLD application Ids that should no longer be linked to the opty
                        if(oldOptyMap.get(opp.id).CRM_Application_ID__c != null){
                            setOLDAppNumber.add(oldOptyMap.get(opp.id).CRM_Application_ID__c);
                        }
                    }*/
                }
                else{
                    if(opp.CRM_Application_ID__c != oldOptyMap.get(opp.id).CRM_Application_ID__c){
                        setPAFAppNum.add(opp.CRM_Application_ID__c);
                        if(oldOptyMap.get(opp.id).CRM_Application_ID__c != null){
                            setOLDAppNumber.add(oldOptyMap.get(opp.id).CRM_Application_ID__c);
                        }
                    }
                }
            }
        }
/*
        //if Mortgage Opty's have changed...
        if(setMortgageAppNumber.size()>0){
            //get the list of Application Status's that will update the Opportunity...
            List<String> relatedStatusDetailList = new List<String>();                
            for(ApplicationStatusToOptyMapping__c AppStatusToRelateToOpty  : ApplicationStatusToOptyMapping__c.getAll().values()){
                if(AppStatusToRelateToOpty.ShowRelatedToOpty__c){
                       relatedStatusDetailList.add(AppStatusToRelateToOpty.Application_Status__c);
                }
            }
            
            //query the Pepper_Data__c records to be realted to the affected Oppty update
            List<Pepper_Data__c> lstUpdatePepperData = [select id,ApplicationID__c,Mortgage_FK__c,CRM_Opportunity__c, Status_Detail__c from Pepper_Data__c where ApplicationID__c in : setMortgageAppNumber AND Status_Detail__c in : relatedStatusDetailList For Update];
            if(lstUpdatePepperData != null && lstUpdatePepperData.Size()>0){
                for(Pepper_Data__c objPepperData : lstUpdatePepperData ){
    
                    //set the opty id on the related Pepper_Data__c records
                    if(objPepperData.ApplicationID__c != null){
                        objPepperData.CRM_Opportunity__c = appIdToOptyId.get(objPepperData.ApplicationID__c);
                    }
    
                }
            }            

        }
        
*/        
		//if PAF Opty's have changed...
        if(setPAFAppNum.size()>0){
            
            List<Application_Data__c> lstApplicationData = [select id,ApplicationNumber__c,CRM_Opportunity__c from Application_Data__c where ApplicationNumber__c in : setPAFAppNum For Update];
            Map<string,Application_Data__c> mapPAFIDtoApp = new Map<string,Application_Data__c>();
            if(lstApplicationData != null && lstApplicationData.Size()>0){
                for(Application_Data__c objAppData : lstApplicationData){
    
                    if(objAppData.ApplicationNumber__c != null){
                        mapPAFIDtoApp.put(objAppData.ApplicationNumber__c,objAppData); 
                    }        
                }
            }
            
            List<Application_Data__c> lstToUpdatePAFData = new List<Application_Data__c>();
            for(Opportunity opp : triggerNewOptyList){
                if(!String.isBlank(opp.CRM_Application_ID__c)){
                    if(opp.CRM_Loan_Type__c == 'Asset Finance' && opp.CRM_Application_ID__c != oldOptyMap.get(opp.id).CRM_Application_ID__c){
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

            if(lstToUpdatePAFData != null && lstToUpdatePAFData.Size()>0){
    
                update lstToUpdatePAFData;
            }
            
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
            
        }




    }
    
    //  -------------------------------------------------------------------------------------------------------
    //  This method updates daily achievement on Weekly Target and Achievement Records on Opp Stage Update
    //  -------------------------------------------------------------------------------------------------------
    //  Created Date: 14/06/2017       Created By: Chayan Batabyal         Email: chayan.batabyal@saasfocus.com
    //  -------------------------------------------------------------------------------------------------------
    public static void updateDailyAchievement(list<Opportunity> lstTriggerNew,
                                        map<id,Opportunity> triggerOldMap)
    {
        Set<ID> setOfSubmittedUserIDs = new Set<ID>();
        Set<ID> setOfSettledUserIDs = new Set<ID>();
        List<CRM_Weekly_Target_and_Achievement__c> lstWeeklyToUpdate;
        Map<id, List<Opportunity>> mapOfOwnerIdToOpportunitiesSubmitted = new Map<id, List<Opportunity>>();
        Map<id, List<Opportunity>> mapOfOwnerIdToOpportunitiesSettled = new Map<id, List<Opportunity>>();
        
        if(lstTriggerNew != NULL && lstTriggerNew.size() > 0)
        {
            for(Opportunity eachOpportunity : lstTriggerNew)
            {
                if((eachOpportunity.stageName == 'Application Submitted' || eachOpportunity.stageName == 'Settled' ) &&
                    (triggerOldMap == NULL || (triggerOldMap != NULL &&
                    triggerOldMap.get(eachOpportunity.id).stageName != eachOpportunity.stageName)))
                {
                    if(eachOpportunity.stageName == 'Application Submitted')
                    {
                        setOfSubmittedUserIDs.add(eachOpportunity.OwnerId);
                        
                        if(!mapOfOwnerIdToOpportunitiesSubmitted.containsKey(eachOpportunity.OwnerId))
                            mapOfOwnerIdToOpportunitiesSubmitted.put(eachOpportunity.OwnerId, new List<Opportunity>());
                        
                        mapOfOwnerIdToOpportunitiesSubmitted.get(eachOpportunity.OwnerId).add(eachOpportunity);
                    }
                    
                    else if(eachOpportunity.stageName == 'Settled')
                    {
                        setOfSettledUserIDs.add(eachOpportunity.OwnerId);
                        
                        if(!mapOfOwnerIdToOpportunitiesSettled.containsKey(eachOpportunity.OwnerId))
                            mapOfOwnerIdToOpportunitiesSettled.put(eachOpportunity.OwnerId, new List<Opportunity>());
                        
                        mapOfOwnerIdToOpportunitiesSettled.get(eachOpportunity.OwnerId).add(eachOpportunity);
                    }
                }
            }
            
            if((setOfSubmittedUserIDs != NULL && setOfSubmittedUserIDs.size() > 0 &&
                mapOfOwnerIdToOpportunitiesSubmitted != NULL && mapOfOwnerIdToOpportunitiesSubmitted.size() > 0) ||
                (setOfSettledUserIDs != NULL && setOfSettledUserIDs.size() > 0 &&
                mapOfOwnerIdToOpportunitiesSettled != NULL && mapOfOwnerIdToOpportunitiesSettled.size() > 0))
            {
                System.debug(mapOfOwnerIdToOpportunitiesSubmitted.keySet());
                System.debug(mapOfOwnerIdToOpportunitiesSettled.keySet());
                
                Id idOpportunitiesSubmitted = Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Applications_Submitted).getRecordTypeId();
                Id idOpportunitiesSettled = Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Settled).getRecordTypeId();
                
                lstWeeklyToUpdate = new List<CRM_Weekly_Target_and_Achievement__c>();
                lstWeeklyToUpdate = [Select id, Name, CRM_Daily_Achievement__c, CRM_From__c,
                                    CRM_KPI_User__c, CRM_To__c, CRM_KPI_Record_Type_Id__c
                                    from CRM_Weekly_Target_and_Achievement__c
                                    where (CRM_KPI_User__c in : setOfSubmittedUserIDs or
                                    CRM_KPI_User__c in : setOfSettledUserIDs) and
                                    (CRM_KPI_Record_Type_Id__c =: idOpportunitiesSubmitted or
                                    CRM_KPI_Record_Type_Id__c =: idOpportunitiesSettled) and
                                    CRM_From__c <= Today and
                                    CRM_To__c >= Today];
                
                if(lstWeeklyToUpdate != NULL && lstWeeklyToUpdate.size() > 0)
                {
                    for(CRM_Weekly_Target_and_Achievement__c eachWeekly : lstWeeklyToUpdate)
                    {
                        System.debug('eachWeekly ID:: ' + eachWeekly.id);
                        System.debug('eachWeekly KPI User ID:: ' + eachWeekly.CRM_KPI_User__c);
                        
                        if(eachWeekly.CRM_KPI_Record_Type_Id__c == idOpportunitiesSubmitted &&
                            mapOfOwnerIdToOpportunitiesSubmitted.containsKey(eachWeekly.CRM_KPI_User__c) &&
                            mapOfOwnerIdToOpportunitiesSubmitted.get(eachWeekly.CRM_KPI_User__c) != NULL &&
                            mapOfOwnerIdToOpportunitiesSubmitted.get(eachWeekly.CRM_KPI_User__c).size() > 0)
                        {
                            if(eachWeekly.CRM_Daily_Achievement__c == NULL ||
                                eachWeekly.CRM_Daily_Achievement__c == 0)
                            {
                                eachWeekly.CRM_Daily_Achievement__c =
                                    mapOfOwnerIdToOpportunitiesSubmitted.get(eachWeekly.CRM_KPI_User__c).size();
                            }
                            
                            else
                            {
                               eachWeekly.CRM_Daily_Achievement__c +=
                                    mapOfOwnerIdToOpportunitiesSubmitted.get(eachWeekly.CRM_KPI_User__c).size();
                            }
                        }
                        
                        else if(eachWeekly.CRM_KPI_Record_Type_Id__c == idOpportunitiesSettled &&
                            mapOfOwnerIdToOpportunitiesSettled.containsKey(eachWeekly.CRM_KPI_User__c) &&
                            mapOfOwnerIdToOpportunitiesSettled.get(eachWeekly.CRM_KPI_User__c) != NULL &&
                            mapOfOwnerIdToOpportunitiesSettled.get(eachWeekly.CRM_KPI_User__c).size() > 0)
                        {
                            if(eachWeekly.CRM_Daily_Achievement__c == NULL ||
                                eachWeekly.CRM_Daily_Achievement__c == 0)
                            {
                                eachWeekly.CRM_Daily_Achievement__c =
                                    mapOfOwnerIdToOpportunitiesSettled.get(eachWeekly.CRM_KPI_User__c).size();
                            }
                            
                            else
                            {
                               eachWeekly.CRM_Daily_Achievement__c +=
                                    mapOfOwnerIdToOpportunitiesSettled.get(eachWeekly.CRM_KPI_User__c).size();
                            }
                        }
                        
                        System.debug('eachWeekly Daily Achieved:: ' + eachWeekly.CRM_Daily_Achievement__c);
                    }
                    
                    update lstWeeklyToUpdate;
                }
            }
        }
    }    
}