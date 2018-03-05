//  -------------------------------------------------------------------------------------------------------
//  This class handles all the logic to update external system ids in SF from Nextgen etc
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 25-APR-2017        Created By: Pawan Mudgal            Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : CRM_Mtg_TestUpdateRecords 
//  -------------------------------------------------------------------------------------------------------
@RestResource(urlMapping='/UpdateSFRecords')
global without sharing class CRM_Mtg_UpdateRecords 
{
    global class PostRequest 
    {
        public String objectName;
        public String recordID;
        public String message;
    }
    
    global class PostResponse 
    {
        public String status;
        public String errorCode;

        public PostResponse() 
        {
            status = null;
            errorCode = 'NO_ERROR';
        }
    }
    
    @HttpPost
    global static PostResponse UpdateRecordPostMethod() 
    {
        RestRequest rReq = RestContext.request;
        String jsonData = rReq.requestBody.toString();
        
        PostResponse res = new PostResponse();
        
        PostRequest req;
        
        if(jsonData != null && jsonData.length() > 0)
        {
            try
            {
                req = (PostRequest) JSON.deserializeStrict(jsonData, PostRequest.class);
            }
            catch(Exception ex)
            {
                res.errorCode = 'INVALID_INPUT';
                res.status = ex.getMessage() + ', Input: ' + jsonData;
                return res;
            }
                
            if(req != null)
            {
                if(String.IsBlank(req.objectName) || String.IsBlank(req.recordID))
                {
                    res.errorCode = 'INVALID_INPUT';
                    res.status = 'Please Specify Correct Values';
                    return res;
                }
                
                if(req.objectName.equalsIgnoreCase('Account'))
                {
                    Account acc = new Account(Id = req.recordID);
                                        
                    if(req.message != Null && req.message != '')
                    {
                        if(req.message == 'success')
                        {
                            acc.CRM_Mtg_Data_Synced__c = true;
                            acc.CRM_Mtg_Data_Sync_Date_Time__c = System.Now();
                            acc.CRM_Mtg_Data_Push_Date_Time__c = System.Now();
                            acc.CRM_Mtg_Data_Sync_Errors__c = '';
                            acc.CRM_Mtg_Is_Data_Sync_Error__c = false;
                        }
                        else
                        {
                            acc.CRM_Mtg_Data_Synced__c = true;
                            acc.CRM_Mtg_Data_Push_Date_Time__c = System.Now();
                            acc.CRM_Mtg_Data_Sync_Errors__c = req.message;    
                            acc.CRM_Mtg_Is_Data_Sync_Error__c = true;
                        }
                        
                        update acc; 
                        
                        res.errorCode = '';
                        res.status = 'Success';   
                    }
                }
                else if(req.objectName.equalsIgnoreCase('User'))
                {
                    User objuser = new User(Id = req.recordID);
                    
                    if(req.message != Null && req.message != '')
                    {
                        if(req.message == 'success')
                        {
                            objuser.CRM_Mtg_Data_Synced__c = true;
                            objuser.CRM_Mtg_Data_Sync_Date_Time__c = System.Now();
                            objuser.CRM_Mtg_Data_Push_Date_Time__c = System.Now();
                            objuser.CRM_Mtg_Data_Sync_Errors__c = '';
                            objuser.CRM_Mtg_Is_Data_Sync_Error__c = false;
                        }
                        else
                        {
                            objuser.CRM_Mtg_Data_Synced__c = true;
                            objuser.CRM_Mtg_Data_Push_Date_Time__c = System.Now();
                            objuser.CRM_Mtg_Data_Sync_Errors__c = req.message;
                            objuser.CRM_Mtg_Is_Data_Sync_Error__c = true;
                        }
                        
                        update objuser;    
                        
                        res.errorCode = '';
                        res.status = 'Success';
                    }
                }
                else if(req.objectName.equalsIgnoreCase('Contact'))
                {
                    Contact cnt = new Contact(Id = req.recordID);
                                        
                    if(req.message != Null && req.message != '')
                    {
                        if(req.message == 'success')
                        {
                            cnt.CRM_Mtg_Data_Synced__c = true;
                            cnt.CRM_Mtg_Data_Sync_Date_Time__c = System.Now();
                            cnt.CRM_Mtg_Data_Push_Date_Time__c = System.Now();
                            cnt.CRM_Mtg_Data_Sync_Errors__c = '';
                            cnt.CRM_Mtg_Is_Data_Sync_Error__c = false;
                        }
                        else
                        {
                            cnt.CRM_Mtg_Data_Synced__c = true;
                            cnt.CRM_Mtg_Data_Push_Date_Time__c = System.Now();
                            cnt.CRM_Mtg_Data_Sync_Errors__c = req.message;
                            cnt.CRM_Mtg_Is_Data_Sync_Error__c = true;
                        }
                        
                        update cnt;    
                        
                        res.errorCode = '';
                        res.status = 'Success';
                    }
                }
            }
        }
        return res;
    }
}