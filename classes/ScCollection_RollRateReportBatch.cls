//  -------------------------------------------------------------------------------------------------------
//  This class would populate data to be used for roll rate report
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 08-JAN-2017   Created By: Pawan Mudgal        Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestRollRateReportBatch
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_RollRateReportBatch implements Database.Batchable<sObject>
{
    global String query;
    
    global ScCollection_RollRateReportBatch() 
    {
        query = 'select Id, ScCollection_Collector__c, ScCollection_Movement_Date__c, ScCollection_Bucket_1_Contract_Ids__c, ScCollection_30_Contract_Ids__c, ScCollection_30_Count__c, ScCollection_Bucket_1_Count__c, ScCollection_No_Movement_Balance__c, ScCollection_No_Movement_Count__c, ScCollection_Rolled_Down_Contract_Id__c , ScCollection_Rolled_Down_Balance__c, ScCollection_Rolled_Down_Count__c, ScCollection_Rolled_Up_Contract_Id__c, ScCollection_Rolled_Up_Balance__c, ScCollection_Rolled_Up_Count__c, ScCollection_Total_Balance__c from ScCollection_Bucket_Movement_Data__c where ScCollection_Movement_Date__c = YESTERDAY';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        List<ScCollection_Bucket_Movement_Data__c> lst = (List<ScCollection_Bucket_Movement_Data__c>)scope;
                        
        if(ScCollection_UtilityHandler.isNotNull(lst))
        {
            Integer bucket1count = 0;
            Integer bucket30count = 0;
            String bucket1ids = '';
            String bucket30ids = '';
            Integer rolledupcount = 0;
            Integer rolleddowncount = 0;
            Decimal rolledupbalance = 0.00;
            Decimal rolleddownbalance = 0.00;
            String rolledupids = '';
            String rolleddownids = '';
            Integer nomovementcount = 0;
            Decimal nomovementbalance = 0.00;
            Decimal TotalBalance =0.00;
            Set<Id> setBucket1ContractIds = new Set<Id>();
            Set<Id> setBucket30ContractIds = new Set<Id>();
            
            // reterive new assignment and assigning it in bucket 1 and 30+ count
            for(collect__Queue_Contract__c objqc : [select Id, ScCollection_Dev_Contract__c, ScCollection_Bucket__c, ScCollection_Balance_Amount__c from collect__Queue_Contract__c where collect__User__c =: lst[0].ScCollection_Collector__c AND collect__Status__c = 'Open' AND CreatedDate = TODAY])
            {
                if(objqc.ScCollection_Dev_Contract__c != Null && objqc.ScCollection_Bucket__c != Null && objqc.ScCollection_Bucket__c > 0)
                {
                    if(objqc.ScCollection_Bucket__c == 1)
                    {
                        if(!setBucket1ContractIds.contains(objqc.ScCollection_Dev_Contract__c)){
                            bucket1count += 1;
                            bucket1ids += objqc.ScCollection_Dev_Contract__c + ',';
                        }                           
                        setBucket1ContractIds.add(objqc.ScCollection_Dev_Contract__c);
                    }
                    else if(objqc.ScCollection_Bucket__c > 1)
                    {
                        if(!setBucket30ContractIds.contains(objqc.ScCollection_Dev_Contract__c)){
                            bucket30count += 1;
                            bucket30ids += objqc.ScCollection_Dev_Contract__c + ',';
                        }
                        setBucket30ContractIds.add(objqc.ScCollection_Dev_Contract__c);
                    }
                    
                    if(objqc.ScCollection_Balance_Amount__c != Null && objqc.ScCollection_Balance_Amount__c > 0)
                    {
                        TotalBalance += objqc.ScCollection_Balance_Amount__c;
                    }
                }
            }
            
            if(lst[0].ScCollection_Bucket_1_Contract_Ids__c != Null)
            {
                Set<String> setContractIds = new Set<String>();
                setContractIds.addAll(lst[0].ScCollection_Bucket_1_Contract_Ids__c.split(','));
                
                for(collect__Loan_Account__c objcon : [select Id, ScCollection_Bucket__c, ScCollection_Current_Principal__c from collect__Loan_Account__c where Id IN : setContractIds])
                {
                    if(objcon.ScCollection_Bucket__c > 1)
                    {
                        // increment rolled up count
                        rolledupcount += 1;
                        rolledupids += objcon.Id + ',';
                        
                        // increment 30+ count
                        bucket30count += 1;
                        bucket30ids += objcon.Id + ',';
                        
                        if(objcon.ScCollection_Current_Principal__c != Null && objcon.ScCollection_Current_Principal__c > 0)
                        {
                            rolledupbalance += objcon.ScCollection_Current_Principal__c;
                            TotalBalance += objcon.ScCollection_Current_Principal__c;
                        }
                    }
                    else if(objcon.ScCollection_Bucket__c == 1)
                    {
                        nomovementcount += 1;
                        bucket1count += 1;
                        bucket1ids += objcon.Id + ',';
                        
                        if(objcon.ScCollection_Current_Principal__c != Null && objcon.ScCollection_Current_Principal__c > 0)
                        {
                            nomovementbalance += objcon.ScCollection_Current_Principal__c;
                            TotalBalance += objcon.ScCollection_Current_Principal__c;
                        }
                    }
                }
            }
            
            if(lst[0].ScCollection_30_Contract_Ids__c != Null)
            {
                Set<String> setContractIds = new Set<String>();
                setContractIds.addAll(lst[0].ScCollection_30_Contract_Ids__c.split(','));
                
                for(collect__Loan_Account__c objcon : [select Id, ScCollection_Bucket__c, ScCollection_Current_Principal__c from collect__Loan_Account__c where Id IN : setContractIds])
                {
                    if(objcon.ScCollection_Bucket__c <= 1)
                    {
                        // increment rolled down count
                        rolleddowncount += 1;
                        rolleddownids += objcon.Id + ',';
                        
                        // increment bucket 1 count
                        if(objcon.ScCollection_Bucket__c == 1){
                            bucket1count += 1;
                            bucket1ids += objcon.Id + ',';
                        }
                        
                        if(objcon.ScCollection_Current_Principal__c != Null && objcon.ScCollection_Current_Principal__c > 0)
                        {
                            rolleddownbalance += objcon.ScCollection_Current_Principal__c;
                            TotalBalance += objcon.ScCollection_Current_Principal__c;
                        }
                    }
                    else if(objcon.ScCollection_Bucket__c > 1)
                    {
                        nomovementcount += 1;
                        bucket30count += 1;
                        bucket30ids += objcon.Id + ',';
                        
                        if(objcon.ScCollection_Current_Principal__c != Null && objcon.ScCollection_Current_Principal__c > 0)
                        {
                            nomovementbalance += objcon.ScCollection_Current_Principal__c;
                            TotalBalance += objcon.ScCollection_Current_Principal__c;
                        }
                    }
                }
            }
            
            List<ScCollection_Bucket_Movement_Data__c> lsttemp = [select Id, ScCollection_Collector__c, ScCollection_Movement_Date__c, ScCollection_Bucket_1_Contract_Ids__c, ScCollection_30_Contract_Ids__c, ScCollection_30_Count__c, ScCollection_Bucket_1_Count__c, ScCollection_No_Movement_Balance__c, ScCollection_No_Movement_Count__c, ScCollection_Rolled_Down_Balance__c, ScCollection_Rolled_Down_Count__c, ScCollection_Rolled_Up_Balance__c, ScCollection_Rolled_Up_Count__c, ScCollection_Total_Balance__c from ScCollection_Bucket_Movement_Data__c where ScCollection_Collector__c =: lst[0].ScCollection_Collector__c AND ScCollection_Movement_Date__c = TODAY];
            ScCollection_Bucket_Movement_Data__c objdata;
                        
            if(lsttemp != Null && lsttemp.size() > 0)
            {
                objdata = lsttemp[0];
            }
            else
            {
                objdata = new ScCollection_Bucket_Movement_Data__c();
            }
            
            objdata.ScCollection_Collector__c = lst[0].ScCollection_Collector__c;
            objdata.ScCollection_Movement_Date__c = System.Today();
            objdata.ScCollection_Bucket_1_Count__c = bucket1count;
            objdata.ScCollection_30_Count__c = bucket30count;
            objdata.ScCollection_Bucket_1_Contract_Ids__c = (bucket1ids != '' ? bucket1ids.subString(0,bucket1ids.length()-1) : '' );
            objdata.ScCollection_30_Contract_Ids__c = (bucket30ids != '' ? bucket30ids.subString(0,bucket30ids.length()-1) : '' );
            objdata.ScCollection_Rolled_Up_Contract_Id__c = (rolledupids != '' ? rolledupids.subString(0,rolledupids.length()-1) : '' );
            objdata.ScCollection_Rolled_Down_Contract_Id__c = (rolleddownids != '' ? rolleddownids.subString(0,rolleddownids.length()-1) : '' );
            objdata.ScCollection_No_Movement_Balance__c = nomovementbalance;
            objdata.ScCollection_No_Movement_Count__c = nomovementcount;
            objdata.ScCollection_Rolled_Down_Balance__c = rolleddownbalance;
            objdata.ScCollection_Rolled_Down_Count__c = rolleddowncount;
            objdata.ScCollection_Rolled_Up_Balance__c = rolledupbalance;
            objdata.ScCollection_Rolled_Up_Count__c = rolledupcount;
            objdata.ScCollection_Total_Balance__c = TotalBalance;
            
            try 
            {
                upsert objdata; 
            }
            catch(Exception e) 
            {
                system.debug('Error in Bucket Movement record insertion : ' + e.getMessage());
            }    
        }
    }
    
    global void finish(Database.BatchableContext BC) 
    {
        List<Messaging.SingleEmailMessage> lstemail = new List<Messaging.SingleEmailMessage>();
        
        AsyncApexJob objbatch = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems from AsyncApexJob where Id =: BC.getJobId()];
        
        if(objbatch.Status != 'Completed' || objbatch.NumberOfErrors > 0  || test.isrunningtest() )
        {
            //if any error comes in batch then send email to admins
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> toAddresses = new List<String>();
            
            ScCollection_System_Email_Settings__c cs = ScCollection_System_Email_Settings__c.getValues('Roll Rate Report Batch');
            
            if(cs != Null && cs.ScCollection_Email_Addressess__c != Null)
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
            htmlBody += 'The Roll Rate Report Batch has failed to run successfully for the day.';
            htmlBody += 'The batch was not processed successfully and there were some errors in batch processing. Please refer below details of the error occured : <br><br>';
            htmlBody += 'Batch Id : ' + objbatch.Id + '.<br>';
            htmlBody += 'Batch Status : ' + objbatch.Status + '.<br>';
            htmlBody += 'Total Job Items : ' + objbatch.TotalJobItems + '.<br>';
            htmlBody += 'Job Items Processed : ' + objbatch.JobItemsProcessed + '.<br>';
            htmlBody += 'No Of Errors : ' + objbatch.NumberOfErrors + '.<br><br>';
            htmlBody += 'Thanks<br>Salesforce Team';
            
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Salesforce Batch Processing Error');
            mail.setSubject('Roll Rate Report Batch Processing Failed');
            mail.setHtmlBody(htmlBody);
            lstemail.add(mail);
        }
        
        if(lstemail != Null && lstemail.size() > 0)
        {
            Messaging.sendEmail(lstemail);
        }
    }
}