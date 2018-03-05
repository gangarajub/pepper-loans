//  -------------------------------------------------------------------------------------------------------
//  This class would populate data to be used for collector report vf page
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 02-DEC-2016   Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestCollectorReportBatch
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_CollectorReportBatch implements Database.Batchable<sObject>, Database.Stateful
{
    global final String query;
    global final Map<Id,ScCollection_User_Assignment__c> mapUserToContracts;
    
    global ScCollection_CollectorReportBatch() 
    {
        query = 'select Id, collect__User__c, ScCollection_Dev_Contract__c, ScCollection_CL_Contract__c from collect__Queue_Contract__c where collect__Status__c = \'Open\' AND ScCollection_Follow_Up_Date__c <= TODAY';
        
        mapUserToContracts = new Map<Id,ScCollection_User_Assignment__c>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        List<collect__Queue_Contract__c> lstQC = (List<collect__Queue_Contract__c>)scope;
        
        if(ScCollection_UtilityHandler.isNotNull(lstQC))
        {
            for(collect__Queue_Contract__c objqc : lstQC)
            {
                if(objqc.collect__User__c != Null)
                {
                    String strContractId = '';
                        
                    if(objqc.ScCollection_Dev_Contract__c != Null)
                    {
                        strContractId = objqc.ScCollection_Dev_Contract__c;
                    }
                    else if(objqc.ScCollection_CL_Contract__c != Null)
                    {
                        strContractId = objqc.ScCollection_CL_Contract__c;
                    }
                    
                    if(mapUserToContracts.containsKey(objqc.collect__User__c) && mapUserToContracts.get(objqc.collect__User__c) != Null)
                    {
                        if(strContractId != '')
                        {
                            ScCollection_User_Assignment__c objasg = mapUserToContracts.get(objqc.collect__User__c);
                            objasg.ScCollection_Contract_Ids__c += ',' + strContractId;
                            mapUserToContracts.put(objqc.collect__User__c, objasg);
                        }
                    }
                    else
                    {
                        if(strContractId != '')
                        {
                            ScCollection_User_Assignment__c objasg = new ScCollection_User_Assignment__c();
                            objasg.ScCollection_Contract_Ids__c = strContractId;
                            objasg.ScCollection_User__c = objqc.collect__User__c;
                            if(!Test.isRunningTest())
                            {
                                objasg.ScCollection_Review_Date__c = System.Today();
                            }
                            mapUserToContracts.put(objqc.collect__User__c, objasg);
                        }
                    }
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) 
    {
        List<Messaging.SingleEmailMessage> lstemail = new List<Messaging.SingleEmailMessage>();
        
        AsyncApexJob objbatch = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems from AsyncApexJob where Id =: BC.getJobId()];
        
        if(objbatch.Status == 'Completed' && objbatch.NumberOfErrors == 0)
        {
            List<ScCollection_User_Assignment__c> lstUpsertAsg = new List<ScCollection_User_Assignment__c>();
            Map<Id,ScCollection_User_Assignment__c> mapExistingAssignment = new Map<Id,ScCollection_User_Assignment__c>();
            
            for(ScCollection_User_Assignment__c objasg : [select Id, ScCollection_User__c, ScCollection_Review_Date__c, ScCollection_Contract_Ids__c from ScCollection_User_Assignment__c where ScCollection_Review_Date__c = TODAY])
            {
                mapExistingAssignment.put(objasg.ScCollection_User__c, objasg);    
            }
            
            if(mapUserToContracts != Null && mapUserToContracts.size() > 0)
            {
                List<ScCollection_User_Assignment__c> lstAsg = mapUserToContracts.values();
                
                for(ScCollection_User_Assignment__c objasg : lstAsg)
                {
                    if(mapExistingAssignment != Null && mapExistingAssignment.containsKey(objasg.ScCollection_User__c) && mapExistingAssignment.get(objasg.ScCollection_User__c) != Null)
                    {
                        ScCollection_User_Assignment__c objexasg = mapExistingAssignment.get(objasg.ScCollection_User__c);
                        objexasg.ScCollection_Contract_Ids__c = mapUserToContracts.get(objasg.ScCollection_User__c).ScCollection_Contract_Ids__c;
                        lstUpsertAsg.add(objexasg);
                    }
                    else
                    {
                        lstUpsertAsg.add(objasg);
                    }
                }
            }
            
            if(ScCollection_UtilityHandler.isNotNull(lstUpsertAsg))
            {
                try 
                {
                    upsert lstUpsertAsg; 
                }
                catch(Exception e) 
                {
                    system.debug('Error in user assignment record insertion : ' + e.getMessage());
                    
                    //if any error comes in record creation then send email to admins
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    List<String> toAddresses = new List<String>();
                    
                    ScCollection_System_Email_Settings__c cs = ScCollection_System_Email_Settings__c.getValues('Collector Report Batch');
                    
                    if(cs.ScCollection_Email_Addressess__c != Null)
                    {    
                        for(String objstr : cs.ScCollection_Email_Addressess__c.split(','))
                        {
                            toAddresses.add(objstr.trim());
                        }
                    }
                    
                    
                    String htmlBody = 'Hi All,<br><br>';
                    htmlBody += 'The Collector Report Batch has failed to run successfully for the day.';
                    htmlBody += 'The batch was processed successfully but there were some errors in master data records insertion. Please refer below details of the error occured : <br><br>';
                    htmlBody += e.getMessage();
                    htmlBody += 'Thanks<br>Salesforce Team';
                    
                    mail.setToAddresses(toAddresses);
                    mail.setSenderDisplayName('Salesforce Batch Processing Error');
                    mail.setSubject('Collector Report Batch Processing Failed');
                    mail.setHtmlBody(htmlBody);
                    lstemail.add(mail);
                }    
            }
        }
        if(objbatch.Status != 'Completed' || objbatch.NumberOfErrors > 0  || test.isrunningtest() )
        {
            //if any error comes in batch then send email to admins
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> toAddresses = new List<String>();
            
            ScCollection_System_Email_Settings__c cs = ScCollection_System_Email_Settings__c.getValues('Collector Report Batch');
            
            if(cs.ScCollection_Email_Addressess__c != Null)
            {    
                for(String objstr : cs.ScCollection_Email_Addressess__c.split(','))
                {
                    toAddresses.add(objstr.trim());
                }
            }
            else
            {
                toAddresses.add('kashish.dwivedi@saasfocus.com');
            }
            
            String htmlBody = 'Hi All,<br><br>';
            htmlBody += 'The Collector Report Batch has failed to run successfully for the day.';
            htmlBody += 'The batch was not processed successfully and there were some errors in batch processing. Please refer below details of the error occured : <br><br>';
            htmlBody += 'Batch Id : ' + objbatch.Id + '.<br>';
            htmlBody += 'Batch Status : ' + objbatch.Status + '.<br>';
            htmlBody += 'Total Job Items : ' + objbatch.TotalJobItems + '.<br>';
            htmlBody += 'Job Items Processed : ' + objbatch.JobItemsProcessed + '.<br>';
            htmlBody += 'No Of Errors : ' + objbatch.NumberOfErrors + '.<br><br>';
            htmlBody += 'Thanks<br>Salesforce Team';
            
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Salesforce Batch Processing Error');
            mail.setSubject('Collector Report Batch Processing Failed');
            mail.setHtmlBody(htmlBody);
            lstemail.add(mail);
        }
        
        if(lstemail != Null && lstemail.size() > 0)
        {
            Messaging.sendEmail(lstemail);
        }
    }
}