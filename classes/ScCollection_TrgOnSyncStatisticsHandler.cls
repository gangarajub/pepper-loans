public class ScCollection_TrgOnSyncStatisticsHandler{

    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          StagingActualSyncProcess
    Company:       Saasfocus
    Description:   This method is used to check if error occure in sync job and notify user via email and sms.
    Inputs:        List<collect__Sync_Statistics__c>
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static void StagingActualSyncProcess(List<collect__Sync_Statistics__c> lstNew){
        
        Boolean checkIfSendEmail = false;
        Boolean checkIfSendSMS = false;
        EmailTemplate objTemplate;
        List<String> lstEmailAddress ;
        String strPhoneNumber ='';
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        List<Messaging.SingleEmailMessage> lstAllmail = new List<Messaging.SingleEmailMessage>();
        
        Collections_Sync_Job_Settings__c syncSettings = Collections_Sync_Job_Settings__c.getInstance();
        
        List<collect__Sync_Statistics__c> lstSyncStatictics = new List<collect__Sync_Statistics__c>();

        Sms_Magic__c objSetting = Sms_Magic__c.getValues('CollectionSenderId');
        
        if(syncSettings != null && (syncSettings.Enable_SMS_Alerts__c || 
                                                syncSettings.Enable_Email_Alerts__c)){
            
            if(syncSettings.Enable_Email_Alerts__c){
                
                List<EmailTemplate> lstTemplate = [Select Id,Body,HtmlValue,Subject,DeveloperName from emailTemplate where DeveloperName = 'ScCollection_StagingActualSyncTemplate'];               
                if(lstTemplate != null && lstTemplate.Size() > 0){
                    objTemplate = lstTemplate[0];
                    
                    
                    checkIfSendEmail = true;
                    if(syncSettings.EmailStagingActualSyncProcess__c != null){
                        lstEmailAddress = syncSettings.EmailStagingActualSyncProcess__c.split(',');
                    }
                }       
            }
            if(syncSettings.Enable_SMS_Alerts__c){
                if(syncSettings.SMS_Recipients_For_Sync_Data_Failures__c != null){
                    strPhoneNumber = syncSettings.SMS_Recipients_For_Sync_Data_Failures__c;
                }
                checkIfSendSMS = true;
            }
            
            
            
            for(collect__Sync_Statistics__c objSyncStatistics : lstNew){
                
                if(objSyncStatistics.collect__Num_Errors__c != null && objSyncStatistics.collect__Num_Errors__c > 0){
                    
                    if(checkIfSendEmail){
                        if(objTemplate != null){
                            Messaging.SingleEmailMessage mail = new  Messaging.SingleEmailMessage();
                            String strhtmlBody = '';
                            String recId = String.valueOf(objSyncStatistics.Id);
                            //string urlLink = '<a href=\"'+baseUrl+'/'+recId.substring(0,3)+'\">'+objSyncStatistics.Name+'</a>';
                            string urlLink = '<a>'+ baseUrl+'/'+recId.substring(0,3)+'</a>';
                            strhtmlBody = objTemplate.HtmlValue;
                            strhtmlBody = strhtmlBody.replace('{url}',urlLink);
                            system.debug(strhtmlBody);
                            
                            mail.setToAddresses(lstEmailAddress);
                            mail.setSubject(objTemplate.Subject);
                            mail.setHtmlBody(strhtmlBody);
                            lstAllmail.add(mail);
                        }
                        
                    } 
                    if(checkIfSendSMS){  
                        lstSyncStatictics.add(objSyncStatistics);    
                    }                   
                } 
            }
        }
        
        if(lstAllmail != null && lstAllmail.size()>0){
            
            Messaging.sendEmail(lstAllmail );
        }
        
        if(lstSyncStatictics != null && lstSyncStatictics.Size()>0 && !string.IsBlank(strPhoneNumber) && syncSettings.SMS_Template_AllFilesReceivedProcess__c != null ){
            String strSyncedStatistics = JSON.serialize(lstSyncStatictics);

            Id jobId = System.enqueueJob(new ScCollection_SendSMSNotification (strSyncedStatistics,strPhoneNumber,syncSettings.SMS_Template_AllFilesReceivedProcess__c));
            system.debug('JOB ID :'+jobId);
            
        }
    
    }
    
}