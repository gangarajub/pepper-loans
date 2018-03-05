/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          CRMTrgOnLead_Tracker
Company:       Saasfocus
Description:   This class is use to test the trigger behavious.  
------------------------------------------------------------*/
@isTest(SeeAllData=False)
public class CRMTrgOnLead_Tracker{
    
      /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          testLeadTrigger
    Company:       Saasfocus
    Description:   This method is used to test Trigger Working.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/

    @isTest static void testLeadTrigger(){
        
        Profile p = [SELECT Id FROM Profile WHERE Id = :userInfo.getProfileId()]; 
        User u = new User(Alias = 'testcrm', Email='testcrmuser@testpepper.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testcrmuser@testpepper.com');
        insert u;   
        CRM_Annual_KPI__c objAnualKpi;
        System.runAs(u){
            
            objAnualKpi= new CRM_Annual_KPI__c(
                            Name = 'test data',
                            CRM_User__c = u.Id,
                            CRM_Year__c = '2017-2018');
            insert objAnualKpi;
            
            Lead objLead = new Lead();
            objLead.LastName ='lastLeadName';
            objLead.Company = 'CompanyOfLead';
            objLead.CRM_Lead_Channel__c = 'Digital';
            objLead.CRM_Lead_Channel_Level_2__c = 'Email';
            objLead.OwnerId = u.Id;
            objLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('PAF').getRecordTypeId();
            insert objLead;
            
            Lead objLead1 = new Lead();
            objLead1.LastName ='lastLeadName1';
            objLead1.Company = 'CompanyOfLead1';
            objLead1.CRM_Lead_Channel__c = 'Digital';
            objLead1.CRM_Lead_Channel_Level_2__c = 'Email';
            objLead1.OwnerId = u.Id;
            objLead1.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('PAF').getRecordTypeId();
            insert objLead1;
            
            Account acc = new Account(Name= 'testAccount');
            insert acc;
            Account acc1 = new Account(Name= 'testAccount1');
            insert acc1;
            
            id reid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            Account perAcc = new Account(LastName = 'PerName' , personEmail ='per@email.com',recordtypeid = reid);
            insert perAcc;
            
            Contact objCon = new Contact(LastName = 'ConName' ,Accountid = acc.id , Email = 'test@email.com');
            insert objCon;
            Contact objCon1 = new Contact(LastName = 'ConName1' ,Accountid = acc1.id , Email = 'test1@email.com');
            insert objCon1;
            
            List<Party__c> lstParty = new List<Party__c>();
            
            Party__c objParty = new Party__c();
            objParty.CRM_Name__c = 'N';
            objParty.CRM_Email__c  = 'N@gmail.com';
            objParty.CRM_Phone__c  = '1';
            objParty.CRM_Type__c  = 'Co Borrower';
            objParty.CRM_Company__c  = 'C';
            objParty.Lead__c  = objLead.id;
            objParty.CRM_Create_New_Business_Account__c = True;
            objParty.CRM_Create_New_Contact__c  = True;
            objParty.CRM_Create_New_Person_Account__c = false;
            
            lstParty.add(objParty);
            
            Party__c objParty1 = new Party__c();
            objParty1.CRM_Name__c = 'N1';
            objParty1.CRM_Email__c  = 'N1@gmail.com';
            objParty1.CRM_Phone__c  = '2';
            objParty1.CRM_Type__c  = 'Co Borrower';
            objParty1.CRM_Company__c  = 'C1';
            objParty1.Lead__c  = objLead.id;
            objParty1.CRM_Create_New_Business_Account__c = false;
            objParty1.CRM_Create_New_Contact__c  = true;
            objParty1.CRM_Existing_Account__c = acc.id;
            lstParty.add(objParty1);
            
            Party__c objParty2 = new Party__c();
            objParty2.CRM_Name__c = 'N2';
            objParty2.CRM_Email__c  = 'N2@gmail.com';
            objParty2.CRM_Phone__c  = '3';
            objParty2.CRM_Type__c  = 'Co Borrower';
            objParty2.CRM_Company__c  = 'C2';
            objParty2.Lead__c  = objLead.id;
            objParty2.CRM_Create_New_Business_Account__c = true;
            objParty2.CRM_Create_New_Contact__c  = false;
            objParty2.CRM_Existing_Contact__c = objCon.id;
            
            lstParty.add(objParty2);
        
            Party__c objParty4 = new Party__c();
            objParty4.CRM_Name__c = 'N4';
            objParty4.CRM_Email__c  = 'N4@gmail.com';
            objParty4.CRM_Phone__c  = '14';
            objParty4.CRM_Type__c  = 'Co Borrower';
            objParty4.Lead__c  = objLead.id;
            objParty4.CRM_Create_New_Person_Account__c = true;
            
            lstParty.add(objParty4);
            
            Party__c objParty5 = new Party__c();
            objParty5.CRM_Name__c = 'N5';
            objParty5.CRM_Email__c  = 'N14@gmail.com';
            objParty5.CRM_Phone__c  = '145';
            objParty5.CRM_Type__c  = 'Co Borrower';
            objParty5.Lead__c  = objLead.id;
            objParty5.CRM_Create_New_Person_Account__c = false;
            objParty5.CRM_Existing_Account__c = perAcc.id;
            
            lstParty.add(objParty5);
            
            Party__c objParty6 = new Party__c();
            objParty6.CRM_Name__c = 'N6';
            objParty6.CRM_Email__c  = 'N6@gmail.com';
            objParty6.CRM_Phone__c  = '16';
            objParty6.CRM_Type__c  = 'Guarantor';
            objParty6.Lead__c  = objLead.id;
            objParty6.CRM_Create_New_Business_Account__c = true;
            objParty6.CRM_Create_New_Contact__c  = true;
            
            lstParty.add(objParty6);
            
            Party__c objParty7 = new Party__c();
            objParty7.CRM_Name__c = 'N7';
            objParty7.CRM_Email__c  = 'N7@gmail.com';
            objParty7.CRM_Phone__c  = '17';
            objParty7.CRM_Type__c  = 'Guarantor';
            objParty7.Lead__c  = objLead.id;
            objParty7.CRM_Create_New_Business_Account__c = true;
            objParty7.CRM_Create_New_Contact__c  = false;
            objParty7.CRM_Existing_Contact__c = objCon1.id; 
            
            lstParty.add(objParty7); 
           
            Party__c objParty9 = new Party__c();
            objParty9.CRM_Name__c = 'N';
            objParty9.CRM_Email__c  = 'N@gmail.com';
            objParty9.CRM_Phone__c  = '1';
            objParty9.CRM_Type__c  = 'Guarantor';
            objParty9.Lead__c  = objLead.id;
            objParty9.CRM_Create_New_Business_Account__c = false;
            objParty9.CRM_Create_New_Contact__c  = true;
            objParty9.CRM_Existing_Account__c = acc.id;
            
            lstParty.add(objParty9);
            
            insert lstParty;
            
             Test.StartTest();
               
                
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(objLead.id);
                lc.setDoNotCreateOpportunity(false);
                //LeadStatus convertStatus = [Select Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                lc.setConvertedStatus('Qualified');
                
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                
                Database.LeadConvert lc1 = new database.LeadConvert();
                lc1.setLeadId(objLead1.id);
                lc1.setDoNotCreateOpportunity(false);
                lc1.setConvertedStatus('Qualified');
                
            	Map<id,id> mapleadIdToOppId = new Map<id,id>();
                Database.LeadConvertResult lcr1 = Database.convertLead(lc1);
            test.stopTest();
            
            	Opportunity opp = [Select Id from Opportunity Limit 1];
            	mapleadIdToOppId.put(objLead.id,opp.Id);
                CRMTriggerOnLeadHandler objLeadController = new CRMTriggerOnLeadHandler();
            	objLeadController.mapleadIdToOppId = mapleadIdToOppId;
            	objLeadController.createExAccountAndExContact(new List<Party__c>{objParty9});
			  	List<CRM_Related_Party__c> lstRelatedParty = [Select Id,CRM_Related_Opportunity__c From CRM_Related_Party__c Limit 1];     
            	system.assertEquals(lstRelatedParty[0].CRM_Related_Opportunity__c,opp.Id,'Success test');
                                                   
        }
    
    }


}