@isTest(SeeAllData=False) Public class CRMTriggerOnCaseTracker{

     @isTest static void test0(){
         List<Case> lstAcc = new List<Case>();
         Case cse = new Case ();
         cse.status = 'New';
         cse.CRM_Channel__c = 'Auto Broker';
         cse.CRM_Broker_Relationship__c = 'Direct';
         lstAcc.add(cse);
         
         Case cse1= new Case();
         cse1.status = 'New';
         cse1.CRM_Channel__c = 'Commercial Broker';
         cse1.CRM_Broker_Relationship__c = 'Direct';
         lstAcc.add(cse1);
         
         Case cse2= new Case();
         cse2.status = 'New';
         cse2.CRM_Channel__c = 'Mortgage Broker';
         cse2.CRM_Broker_Relationship__c = 'Direct';
         lstAcc.add(cse2);
         
         Case cse3= new Case();
         cse3.status = 'New';
         cse3.CRM_Channel__c = 'Dealer Channel';
         cse3.CRM_Broker_Relationship__c = 'Direct';
         lstAcc.add(cse3);
         
         Case cse4 = new Case();
         cse4.status = 'New';
         cse4.CRM_Channel__c = 'Auto Broker';
         cse4.CRM_Broker_Relationship__c = 'Indirect/via Aggregator';
         lstAcc.add(cse4);
         
         Case cse5= new Case();
         cse5.status = 'New';
         cse5.CRM_Channel__c = 'Commercial Broker';
         cse5.CRM_Broker_Relationship__c = 'Indirect/via Aggregator';
         lstAcc.add(cse5);
         
         Case cse6= new Case();
         cse6.status = 'New';
         cse6.CRM_Channel__c = 'Mortgage Broker';
         cse6.CRM_Broker_Relationship__c = 'Indirect/via Aggregator';
         lstAcc.add(cse6);
         
         insert lstAcc;
     }



}