// -------------------------------------------------------------------------------------------------------
// This class handles all the logic to handle any errors in the DES bulk data load job run via ESB
// -------------------------------------------------------------------------------------------------------
// Created Date : 25-APR-2017          Created By: Pawan Mudgal          Email: pawan.mudgal@saasfocus.com
// -------------------------------------------------------------------------------------------------------
// Test Class : TestESB_To_SF_ErrorHandling
// -------------------------------------------------------------------------------------------------------
@RestResource(urlMapping='/ESBReconciliationService')
global without sharing class ESB_To_SF_ErrorHandling
{
    global class PostRequest 
    {
        public String ServiceType;
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
                //deserealize the request and get the request data
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
                if(String.IsBlank(req.ServiceType))
                {
                    res.errorCode = 'INVALID_INPUT';
                    res.status = 'Please Specify Correct Values';
                    return res;
                }
                
                //code block for 
                if(req.ServiceType.equalsIgnoreCase('DES_Extract'))
                {
                    List<ESB_Batch_Load_Stat__c> lstStats = new List<ESB_Batch_Load_Stat__c>();
                    List<CRM_Mortgage_Application_Data__c> lstApplication = new List<CRM_Mortgage_Application_Data__c>();
                    List<CRM_Mortgage_Applicant_Data__c> lstApplicant = new List<CRM_Mortgage_Applicant_Data__c>();
                    List<CRM_Mortgage_Fees_Data__c> lstFees = new List<CRM_Mortgage_Fees_Data__c>();
                    List<CRM_Mortgage_Securities_Data__c> lstSecurity = new List<CRM_Mortgage_Securities_Data__c>();
                    List<CRM_Mortgage_Loan_Split_Data__c> lstSplits = new List<CRM_Mortgage_Loan_Split_Data__c>();
                    Integer Application = 0;
                    Integer Applicant = 0;
                    Integer Fees = 0;
                    Integer Security = 0;
                    Integer Splits = 0;
                    List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
                    
                    EmailTemplate TemplateId = [Select Id, Subject, HtmlValue from EmailTemplate where DeveloperName = 'CRM_Mtg_Error_Email_To_COE'];
                    
                    Set<String> setEntityName = new Set<String>();
                    setEntityName.add('application');
                    setEntityName.add('loansplit');
                    setEntityName.add('party');
                    setEntityName.add('security');
                    setEntityName.add('fees');
                    
                    Boolean sendEmail = false;
                    String strErrorMessage = '';
                    
                    try
                    {
                        //get the statistics table records to identify the data updated by esb
                        lstStats = [select Id, Name, Entity__c, Batch_Job_Instance_Id__c, Processed_Records__c from ESB_Batch_Load_Stat__c where LOB__c = 'Mortgage' AND Entity__c IN : setEntityName AND CreatedDate = TODAY];
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<String> sendTo = new List<String>();
                        
                        sendTo = System.Label.ESB_Error_Reporting_Email_Ids.split(';');
                        
                        mail.setToAddresses(sendTo);
                        mail.setSubject('Error in DES daily extract from ESB to Salesforce');
                        String body = TemplateId.HtmlValue;
                        String error_msg = '';
                                                
                        if(lstStats != Null && lstStats.size() > 0)
                        {
                            //query the actual objects to identify the actual records updated in salesforce
                            for(AggregateResult agr : [SELECT count(Id) cnt from CRM_Mortgage_Application_Data__c where LastModifiedDate=TODAY])
                            {
                                Application = (Integer)agr.get('cnt');
                            }
                            
                            for(AggregateResult agr : [SELECT count(Id) cnt from CRM_Mortgage_Applicant_Data__c where LastModifiedDate=TODAY])
                            {
                                Applicant = (Integer)agr.get('cnt');
                            }
                            
                            for(AggregateResult agr : [SELECT count(Id) cnt from CRM_Mortgage_Fees_Data__c where LastModifiedDate=TODAY])
                            {
                                Fees = (Integer)agr.get('cnt');
                            }
                            
                            for(AggregateResult agr : [SELECT count(Id) cnt from CRM_Mortgage_Securities_Data__c where LastModifiedDate=TODAY])
                            {
                                Security = (Integer)agr.get('cnt');
                            }
                            
                            for(AggregateResult agr : [SELECT count(Id) cnt from CRM_Mortgage_Loan_Split_Data__c where LastModifiedDate=TODAY])
                            {
                                Splits = (Integer)agr.get('cnt');
                            }
                            
                            Integer i = 1;
                            
                            for(ESB_Batch_Load_Stat__c obj : lstStats)
                            {
                                if(obj.Entity__c == 'application')
                                {
                                    if(obj.Processed_Records__c > 0 && obj.Processed_Records__c > Application)
                                    {
                                        error_msg += '<br/><br/>' + i + '. <b>' + (obj.Processed_Records__c - Application) + '</b> records of Mortgage Applications failed to update out of <b>' + obj.Processed_Records__c + '</b> records sent by ESB.';
                                        sendEmail = true;
                                        i++;
                                    }
                                }
                                else if(obj.Entity__c == 'loansplit')
                                {
                                    if(obj.Processed_Records__c > 0 && obj.Processed_Records__c > Splits)
                                    {
                                        error_msg += '<br/><br/>' + i + '. <b>' + (obj.Processed_Records__c - Splits) + '</b> records of Mortgage Loan Splits failed to update out of <b>' + obj.Processed_Records__c + '</b> records sent by ESB.';
                                        sendEmail = true;
                                        i++;
                                    }
                                }
                                else if(obj.Entity__c == 'party')
                                {
                                    if(obj.Processed_Records__c > 0 && obj.Processed_Records__c > Applicant)
                                    {
                                        error_msg += '<br/><br/>' + i + '. <b>' + (obj.Processed_Records__c - Applicant) + '</b> records of Mortgage Applicants failed to update out of <b>' + obj.Processed_Records__c + '</b> records sent by ESB.';
                                        sendEmail = true;
                                        i++;
                                    }
                                }
                                else if(obj.Entity__c == 'security')
                                {
                                    if(obj.Processed_Records__c > 0 && obj.Processed_Records__c > Security)
                                    {
                                        error_msg += '<br/><br/>' + i + '. <b>' + (obj.Processed_Records__c - Security) + '</b> records of Mortgage Security failed to update out of <b>' + obj.Processed_Records__c + '</b> records sent by ESB.';
                                        sendEmail = true;
                                        i++;
                                    }
                                }
                                else if(obj.Entity__c == 'fees')
                                {
                                    if(obj.Processed_Records__c > 0 && obj.Processed_Records__c > Fees)
                                    {
                                        error_msg += '<br/><br/>' + i + '. <b>' + (obj.Processed_Records__c - Fees) + '</b> records of Mortgage Fees failed to update out of <b>' + obj.Processed_Records__c + '</b> records sent by ESB.';
                                        sendEmail = true;
                                        i++;
                                    }
                                }
                            }
                        }
                        else
                        {
                            error_msg += '<br/>1. No records were found in ESB_Batch_Load_Stat__c table for today to compare the statistics.';
                            sendEmail = true;
                        }
                        
                        if(sendEmail)
                        {
                            body = body.replace('{!Error_Description}',error_msg);
                            mail.setHtmlBody(body);
                            lstEmails.add(mail);
                        }
                        
                        res.errorCode = '';
                        res.status = 'Success'; 
                    }
                    catch(Exception ex)
                    {
                        res.errorCode = 'INVALID_INPUT';
                        res.status = ex.getMessage();
                        return res;
                    }
                    
                    if(lstEmails != Null && lstEmails.size() > 0)
                    {
                        try
                        {
                            Messaging.sendEmail(lstEmails);
                        }
                        catch(Exception e)
                        {
                            system.debug('Error in sending DES Error emails : ' + e.getMessage());
                        }
                    }
                    
                    lstApplicant = [select Id from CRM_Mortgage_Applicant_Data__c where LastModifiedDate = TODAY AND CRM_Mtg_DESRecordActiveFlag__c = false];
                    lstFees = [select Id from CRM_Mortgage_Fees_Data__c where LastModifiedDate = TODAY AND CRM_Mtg_DESRecordActiveFlag__c = false]; 
                    lstSecurity = [select Id from CRM_Mortgage_Securities_Data__c where LastModifiedDate = TODAY AND CRM_Mtg_DESRecordActiveFlag__c = false];
                    lstSplits = [select Id from CRM_Mortgage_Loan_Split_Data__c where LastModifiedDate = TODAY AND CRM_Mtg_DESRecordActiveFlag__c = false];
                    
                    try
                    {
                        if(lstApplicant != null && lstApplicant.size() > 0)
                        {
                            delete lstApplicant;
                        }
                        if(lstFees != null && lstFees.size() > 0)
                        {
                            delete lstFees;
                        }
                        if(lstSecurity != null && lstSecurity.size() > 0)
                        {
                            delete lstSecurity;
                        }
                        if(lstSplits != null && lstSplits.size() > 0)
                        {
                            delete lstSplits;
                        }
                    }
                    catch(Exception ex)
                    {
                        system.debug('Exception in record deletion : ' + ex.getMessage());
                    }
                }
            }
        }
        
        return res;
    }
}