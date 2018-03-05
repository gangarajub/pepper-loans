@isTest(SeeAllData = False) Public class CRMScheduleBatchClassToCreateTaskTracker{
    
    @isTest static void test0(){
        
        User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
        );   
        insert u; 
        
        system.runAs(u){
        
            Account acc = new Account();
            acc.Name = 'testData';
            acc.CRM_PAF_BDM__c = u.id;
            insert acc;
            
            Event eve= new Event();
            eve.Type = 'Email';
            eve.Description = 'meeting'; //string Meeting
            eve.Subject='Meeting';
            eve.OwnerId = u.id; //user id
            eve.WhatId = acc.id; //record id
            eve.EndDateTime=DateTime.newInstance(2016,12,12);
            eve.StartDateTime=DateTime.newInstance(2016,12,12);
            insert eve;
            
            Task t = new Task();
            t.OwnerId = u.id;
            t.Subject='Donni';
            t.Status='Open';
            t.Priority='Normal';
            t.whatId = acc.id;
            insert t;  
        CRMScheduleBatchClassToCreateTask objSchedule = new CRMScheduleBatchClassToCreateTask();
        objSchedule.execute(null);
            
        }
    }
    
    
}