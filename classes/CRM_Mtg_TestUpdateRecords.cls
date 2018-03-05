// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for CRM_Mtg_UpdateRecords class
// ----------------------------------------------------------------------------------------------------
// Created Date: 22-APR-2017          Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class CRM_Mtg_TestUpdateRecords
{
    static testMethod void myUnitTest1() 
    {  
    
        CRM_Mtg_UpdateRecords.PostRequest  objPostReq = new CRM_Mtg_UpdateRecords.PostRequest();
        objPostReq.objectName = '';
        objPostReq.recordID = '';
        objPostReq.message = '';
        
        Test.startTest();
         String jsonData;
        //Invalid Input Please Specify Correct Values
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/UpdateSFRecords';
        req.httpMethod = 'POST';
        
        jsonData = JSON.serialize(objPostReq);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        
        Account acc = new Account(Name='test Account');
        insert acc;
        
        objPostReq.objectName = 'Account';
        objPostReq.recordID = acc.Id;
        objPostReq.message = 'success';
        jsonData = JSON.serialize(objPostReq);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        
        objPostReq.objectName = 'Account';
        objPostReq.recordID = acc.Id;
        objPostReq.message = 'fail';
        jsonData = JSON.serialize(objPostReq);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        
        Contact con = new Contact(LastName ='test LastName',AccountId = acc.Id);
        insert con;
        
        objPostReq.objectName = 'Contact';
        objPostReq.recordID = con.Id;
        objPostReq.message = 'success';
        jsonData = JSON.serialize(objPostReq);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        
        objPostReq.objectName = 'Contact';
        objPostReq.recordID = con.Id;
        objPostReq.message = 'fail';
        jsonData = JSON.serialize(objPostReq);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        Test.stopTest(); 
    }       
    
    static testMethod void myUnitTest2() 
    {  
       CRM_Mtg_UpdateRecords.PostRequest  objPostReq = new CRM_Mtg_UpdateRecords.PostRequest();
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
        LocaleSidKey = 'en_US',
        CRM_Mtg_Unique_Id__c = 121111
        );   
        
        insert u;
        Test.startTest();
        String jsonData;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/UpdateSFRecords';
        req.httpMethod = 'POST';
        
        objPostReq.objectName = 'User';
        objPostReq.recordID = u.Id;
        objPostReq.message = 'success';
        jsonData = JSON.serialize(objPostReq);
        req.requestBody = Blob.valueof(jsonData);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        
        objPostReq.objectName = 'User';
        objPostReq.recordID = u.Id;
        objPostReq.message = 'fail';
        jsonData = JSON.serialize(objPostReq);
        req.requestBody = Blob.valueof(jsonData);
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        
        jsonData = '{\"objectName\":"User", \"recordID\":u.Id ,\"message\":"fail"}';
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req;
        
        CRM_Mtg_UpdateRecords.UpdateRecordPostMethod();
        Test.stopTest(); 
    }       
}