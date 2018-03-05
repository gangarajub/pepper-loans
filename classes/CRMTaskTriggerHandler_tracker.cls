/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          CRMTaskTriggerHandler 
Company:       Saasfocus
Description:   This class is test classs for CRMTaskTriggerHandler
History
Date    :  28/11/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=False)
public class CRMTaskTriggerHandler_tracker{
    
    public Static Account acc;
    public Static Opportunity opp;
    public Static List<Task> lstTsk;
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          updateStageNameOnOpportunityTest
    Company:       Saasfocus
    Description:   This is use to test updateStageNameOnOpportunity method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    public static void updateStageNameOnOpportunityTest1(){
        createRecord();
        
        lstTsk[0].CRM_Mtg_Call_Outcome__c = 'Lead followed up';
        lstTsk[0].CallType = 'Outbound';
        lstTsk[0].Status = 'Completed';
        lstTsk[1].CRM_Mtg_Call_Outcome__c = 'No answer';
        lstTsk[1].CallType = 'Outbound';
        lstTsk[1].Status = 'Completed';
        lstTsk[2].CRM_Mtg_Call_Outcome__c = 'Application Proceeding';
        lstTsk[2].CallType = 'Outbound';
        lstTsk[2].Status = 'Completed';
        Test.StartTest();
            update lstTsk[0];
            Opportunity oppFirstUpdate = [Select Id,StageName From Opportunity Where Id=:opp.Id];
            update lstTsk[1];
            Opportunity oppSecondUpdate = [Select Id,StageName From Opportunity Where Id=:opp.Id];
            update lstTsk[2];
            Opportunity oppThirdUpdate = [Select Id,StageName From Opportunity Where Id=:opp.Id];
        Test.StopTest();
        
        
        system.assert(oppFirstUpdate.StageName ==  Label.Opportunity_First_Label);
        system.assert(oppSecondUpdate.StageName ==  Label.Opportunity_Second_Label);
        system.assert(oppThirdUpdate.StageName ==  Label.Opportunity_Third_Label);
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          updateStageNameOnOpportunityTest
    Company:       Saasfocus
    Description:   This is use to create test record.
    Inputs:        
    Returns:       void
    ------------------------------------------------------------------------------*/
    public static void createRecord(){
        acc = new Account();
        acc.Name = 'TestingAccount';
        insert acc;
        
        opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.CloseDate = System.Today()+3;
        opp.Name = 'Test Opp';
        insert opp;
        
        Task tsk;
        lstTsk = new List<Task>();
        for(Integer i=0;i<3;i++){
            tsk = new Task();
            tsk.WhatID = opp.id;
            tsk.Subject='testing';
            tsk.Status='New';
            tsk.Priority='High';
            lstTsk.add(tsk);
        }
        insert lstTsk;
    }
}