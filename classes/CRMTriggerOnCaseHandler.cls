//-----------------------------------------------------------------------------------------------------
// Date        : 30/11/2016
// Description : This class is to create checklist
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------

public class CRMTriggerOnCaseHandler{

    public Static void insertChecklist(List<Case> triggerNew){
        Id directAutoBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Direct Auto Broker').getRecordTypeId();
        Id aggregatorAutoBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Auto Broker via Aggregator').getRecordTypeId();
        Id directCommercialBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Commercial Broker Direct').getRecordTypeId();
        Id aggregatorCommercialBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Commercial Broker via Aggregator').getRecordTypeId();
        Id directMortgageBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Mortgage Broker Direct').getRecordTypeId();
        Id aggregatorMortgageBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Mortage Broker via Aggregator').getRecordTypeId();
        Id DealerChannelBroker= Schema.SObjectType.CRM_Checklist__c.getRecordTypeInfosByName().get('Dealer channel').getRecordTypeId();
        
        List<CRM_Checklist__c> lstChecklistToInsert = new list<CRM_Checklist__c>();
        for(Case cse : triggerNew){
            
            if(cse.CRM_Channel__c != null && cse.CRM_Broker_Relationship__c != null){
               CRM_Checklist__c objchecklist = new CRM_Checklist__c();
               if(cse.CRM_Channel__c == 'Auto Broker' && cse.CRM_Broker_Relationship__c == 'Direct'){
            
                    objchecklist.CRM_Case__c = cse.id;
                    if(directAutoBroker != null){
                        objchecklist.RecordTypeId = directAutoBroker;
                    }
                    lstChecklistToInsert.add(objchecklist);
                 
               }
               else if(cse.CRM_Channel__c == 'Auto Broker' && cse.CRM_Broker_Relationship__c == 'Indirect/via Aggregator'){
                    
                    objchecklist.CRM_Case__c = cse.id;
                    if(aggregatorAutoBroker != null){
                        objchecklist.RecordTypeId = aggregatorAutoBroker;
                    }
                    lstChecklistToInsert.add(objchecklist);
               
               }
               else if(cse.CRM_Channel__c == 'Commercial Broker' && cse.CRM_Broker_Relationship__c == 'Direct'){
                  
                   objchecklist.CRM_Case__c = cse.id;
                   if(directCommercialBroker != null){
                       objchecklist.RecordTypeId = directCommercialBroker;
                   }
                   lstChecklistToInsert.add(objchecklist);
                   
               }
               else if(cse.CRM_Channel__c == 'Commercial Broker' && cse.CRM_Broker_Relationship__c == 'Indirect/via Aggregator'){
                   
                   objchecklist.CRM_Case__c = cse.id;
                   if(aggregatorCommercialBroker != null){
                       objchecklist.RecordTypeId = aggregatorCommercialBroker;
                   }
                   lstChecklistToInsert.add(objchecklist);
                
               } 
               else if(cse.CRM_Channel__c == 'Mortgage Broker' && cse.CRM_Broker_Relationship__c == 'Direct'){
                   system.debug('inside');
                   objchecklist.CRM_Case__c = cse.id;
                   if(directMortgageBroker != null){
                       objchecklist.RecordTypeId = directMortgageBroker;
                   }
                   lstChecklistToInsert.add(objchecklist);
                
               }
               else if(cse.CRM_Channel__c == 'Mortgage Broker' && cse.CRM_Broker_Relationship__c == 'Indirect/via Aggregator'){
                   
                   objchecklist.CRM_Case__c = cse.id;
                   if(aggregatorMortgageBroker != null){
                       objchecklist.RecordTypeId = aggregatorMortgageBroker;
                   }
                   lstChecklistToInsert.add(objchecklist);
                
               }
               else if(cse.CRM_Channel__c == 'Dealer Channel'){
                   
                   objchecklist.CRM_Case__c = cse.id;
                   if(DealerChannelBroker!= null){
                       objchecklist.RecordTypeId = DealerChannelBroker;
                   }
                   lstChecklistToInsert.add(objchecklist);
                
               }
            
            }
        
        }
        
        if(lstChecklistToInsert != null && lstChecklistToInsert.Size()>0){
            insert lstChecklistToInsert;
        }
        
    
    }


}