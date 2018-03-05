//-----------------------------------------------------------------------------------------------------
// Description : This class is test class for CRM_Mtg_SendNewEmailController
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
// 1.0                            Sandip Bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
@isTest(SeeAllData = false)
public class CRM_Mtg_TestSendNewEmailController
{
    @isTest static void test0()
    {
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
        
        system.runAs(u)
        {    
            Account acc = new Account(Name='testAccount',CRM_Mtg_Channel__c='White Label',CRM_Mtg_Unique_Id__c = 1211);
            insert acc;
            Contact con = new Contact(LastName = 'testContact',AccountId=acc.Id,CRM_Mtg_Unique_Id__c = 1213,CRM_Mtg_Mortgage_BDM__c = u.id,Email='abc@pqr.com');
            insert con;
                     
            Case cse= new Case(
                            ContactId = con.Id,
                            AccountId = acc.Id,
                            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mortgage Broker Scenario').getRecordTypeId(),
                            Status = 'New',
                            Origin = 'Email',
                            Priority = 'Medium',
                            Description = 'Hi ',
                            CRM_Mtg_ARM_Id__c = '81402');
            insert cse;
             
            Folder objFolder = [Select id from Folder where name = 'CRM Mortgage User Templates'];
            EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = objFolder.Id, TemplateType= 'Text', Name = 'test', Subject = 'Test Subject', IsActive = true); // plus any other fields that you want to set
            insert e;
            
            ContentVersion testContentInsert = new ContentVersion(); 
            testContentInsert.PathOnClient = 'Test.jpg';
            testContentInsert.VersionData = Blob.valueOf('Test Content');
            testContentInsert.Title ='Google.com'; 
            testContentInsert.isMajorVersion = true;
            testContentInsert.Origin = 'H';
            insert testContentInsert; 
            
            ContentVersion testContent = [SELECT ContentDocumentId FROM ContentVersion where Id =: testContentInsert.Id]; 
            ContentWorkspace testWorkspace = [SELECT Id FROM ContentWorkspace limit 1]; 
            
            ContentWorkspaceDoc newWorkspaceDoc = new ContentWorkspaceDoc(); 
            newWorkspaceDoc.ContentWorkspaceId = testWorkspace.Id; 
            newWorkspaceDoc.ContentDocumentId = testContent.ContentDocumentId; 
            insert newWorkspaceDoc;
            
            CRM_Mtg_Email_Template_Attachments__c obj = new CRM_Mtg_Email_Template_Attachments__c();
            obj.Name = '1';
            obj.CRM_Mtg_Email_Template_Id__c = e.Id;
            obj.CRM_Mtg_Content_Document_Id__c = testContent.ContentDocumentId;
            insert obj;
            
            ApexPages.currentPage().getParameters().put('id',cse.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(cse);
            CRM_Mtg_SendNewEmailController objController = new CRM_Mtg_SendNewEmailController(sc);
            objController.strSelectedTemplate = e.Id;
            objController.getEmailTemplateList();
            objController.selectTemplate();
            objController.SendEmail(); 
        }
    }
}