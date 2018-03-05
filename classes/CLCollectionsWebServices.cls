/*
 * Copyright: 2016, Cloud Lending Solutions
 * 
 * class: CLCollectionsSyncService
 * 
 * description: Implements webservice for
 *              1. Initiating CL Collections sync batch job
 *              2. Reproting progress of sync batch job
 *              
 * usage:
 *        1. POST on /SyncJobService intiates batch job and returns batch id of parent batch job
 *        2. GET on /SyncJobService/<jobId> returns status/progress of batch job in execution             
 */
@RestResource(urlMapping='/SyncJobService/*')
global with sharing class CLCollectionsWebServices {
    //
    // Get Handler
    //
    global class GetResponse {
        public String errorCode;
        public String status;
        public String batchStatus;

        public GetResponse() {
            errorCode = 'NO_ERROR';
            status = null;
            batchStatus = null;
        }
    }

    @HttpGet
    global static GetResponse getBatchStatus() {
        RestRequest req = RestContext.request;
        GetResponse res = new GetResponse();

        String input = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        Id batchId;

        try {
            batchId = Id.valueOf(input);
        }
        catch (Exception ex) {
            res.errorCode = 'INVALID_INPUT';
            res.status = 'Please provide correct batch id';
            return res;
        }

        Integer numErrors = 0;

        List<collect__Sync_Statistics__c> ss = [SELECT Id,
                                                       collect__Batch_Id__c,
                                                       collect__Source_Table__c,
                                                       collect__Target_Table__c,
                                                       collect__Records_Read__c,
                                                       collect__Records_Processed__c,
                                                       collect__Records_Inserted__c,
                                                       collect__Records_Updated__c,
                                                       collect__Records_Deleted__c,
                                                       collect__Num_Errors__c
                                                  FROM collect__Sync_Statistics__c
                                                 WHERE collect__Parent_Batch_Id__c = :batchId];

        if (ss != null && !ss.isEmpty()) {
            Set<ID> batchIdList = new Set<Id>();

            for (collect__Sync_Statistics__c s : ss) {
                if (s.collect__Batch_Id__c != null) {
                    batchIdList.add(s.collect__Batch_Id__c);

                    if (s.collect__Num_Errors__c != null) {
                        numErrors += s.collect__Num_Errors__c.intValue();
                    }
                }
            }

            if (!batchIdList.isEmpty()) {
                List<sObject> batchStatuses = [SELECT Status, COUNT(ID) NumJobs
                                                 FROM AsyncApexJob
                                                WHERE Id IN :batchIdList
                                             GROUP BY Status];

                if (batchStatuses != null && !batchStatuses.isEmpty()) {
                    Integer numCompletedJobs = 0;
                    Integer numFailedJobs = 0;
                    Integer numInProgressJobs = 0;

                    for (sObject batchStatus : batchStatuses) {
                        String jobStatus = (String) batchStatus.get('Status');
                        if (jobStatus.equals('Holding') ||
                            jobStatus.equals('Queued') ||
                            jobStatus.equals('Preparing') ||
                            jobStatus.equals('Processing')) {
                            numInProgressJobs = (Integer) batchStatus.get('NumJobs');
                        } else if (jobStatus.equals('Failed') ||
                                   jobStatus.equals('Aborted')) {
                            numFailedJobs = (Integer) batchStatus.get('NumJobs');
                        } else if (jobStatus.equals('Completed')) {
                            numCompletedJobs = (Integer) batchStatus.get('NumJobs');
                        }
                    }

                    if (numFailedJobs > 0) {
                        res.batchStatus = 'Job failed. Check \'Sync Error\' table for error details.';
                        return res;
                    } else if (numCompletedJobs > 0 && numInProgressJobs == 0 && numErrors == 0) {
                        res.batchStatus = 'Successful';
                        return res;
                    } else if (numCompletedJobs > 0 && numInProgressJobs == 0 && numErrors > 0) {
                        res.batchStatus = 'Successful with errors. Check \'Sync Error\' table for error details.';
                        return res;
                    } else if (numInProgressJobs > 0) {
                        res.batchStatus = 'In Progress';
                        return res;
                    }
                } else {
                    res.errorCode = 'BATCH_STATUS_NOT_AVAILABLE';
                    res.status = 'Batch status is not available in AsyncApexJob';
                    return res;
                }
            }
        } else {
            res.errorCode = 'INVALID_INPUT';
            res.status = 'Batch id is not present in statistics table';
            return res;
        }

        return res;
    }


    //
    // Post Handler
    //
    public class PostRequest {
        public Integer batchSize;
        public Boolean CreateActivity;
        public Boolean submitNextJob;
        public String parentTable;
        public Boolean checkDataExists;
    }


    global class PostResponse {
        public String status;
        public String errorCode;
        public String batchId;

        public PostResponse() {
            status = null;
            errorCode = 'NO_ERROR';
            batchId = null;
        }
    }

    private static Collections_Sync_Job_Settings__c syncSettings = Collections_Sync_Job_Settings__c.getInstance();

    @HttpPost
    global static PostResponse startBatch() {
        RestRequest rReq = RestContext.request;
        PostResponse res = new PostResponse();
        String jsonData = rReq.requestBody.toString();
        PostRequest req;
	
        
        Boolean overrideAPISettings = syncSettings == null ? false : syncSettings.Override_Sync_Job_API_Settings__c;
        
        String table = '';
        Boolean submitNextJobs = false;
        Boolean submitCreateActivity = false;
        Integer iBatchSize = 2000;     
        Boolean checkSyncDataExists = true;
        
        if (jsonData != null && jsonData.length() > 0 && !overrideAPISettings) {
            system.debug('Input: ' + jsonData);

            try {
                req = (PostRequest) JSON.deserializeStrict(jsonData, PostRequest.class);
            } catch (Exception e) {
                System.debug('e.getMessage: ' + e.getMessage());
                res.errorCode = 'INVALID_INPUT';
                res.status = e.getMessage() + ', Input: ' + jsonData;
                return res;
            }           
            
            if (req.batchSize < 1 || req.batchSize > 2000) {
                res.errorCode = 'INVALID_INPUT';
                res.status = 'BatchSize must be between 1 and 2000';
                return res;             
            }
            
            if (req.batchSize  == null){
                iBatchSize  = 2000;
            }else{
                iBatchSize = req.batchSize;                
            }
            
            if (req.submitNextJob == null){
                submitNextJobs = false;
            }else{
                submitNextJobs = req.submitNextJob;
            }
            
            if (req.parentTable == null){
                table = 'staging__Interface_Bank_Account__c';
            }else{
                table = req.parentTable;
            }
            
            if (req.CreateActivity == null){
                submitCreateActivity = false;
            }else{
                submitCreateActivity = req.CreateActivity;
            }
            
            if (req.checkDataExists == null){
                checkSyncDataExists = true;
            }else{
                checkSyncDataExists = req.checkDataExists;
            }
            
            
//            system.debug('BatchSize: ' + req.batchSize);
  //          system.debug('CreateActivity: ' + req.CreateActivity);
        } else{
            System.debug('Override!');
            table = syncSettings.Sync_Job_Parent_Table__c;
            submitNextJobs = syncSettings.Sync_Job_Submit_Next_Job__c;
            submitCreateActivity = syncSettings.Sync_Job_Invokes_Create_Activity_Job__c;
            iBatchSize = (Integer)syncSettings.Sync_Job_Batch_Size__c;    
            checkSyncDataExists = syncSettings.Check_Sync_Job_Data_Exists__c;
        }

        System.debug('SyncJob2: table: ' + table);
        System.debug('SyncJob2: submitNextJobs: ' + submitNextJobs);
        System.debug('SyncJob2: submitCreateActivity: ' + submitCreateActivity);
        System.debug('SyncJob2: iBatchSize: ' + iBatchSize);
        System.debug('SyncJob2: checkSyncDataExists: ' + checkSyncDataExists);
        
        Boolean checkFiles = true;
        Boolean checkExceptionOccur = false;
        String strExceptionMsg = '';
        
        if(checkSyncDataExists){
            
            try{
                checkFiles = CheckTodaysFiles();    
            }
            catch(exception ex){
                checkExceptionOccur = true;
                strExceptionMsg = ex.getMessage();
                res.errorCode = 'INVALID_INPUT';
                res.status = 'SYNC JOB DIDN\'T EXECUTE TODAY :'+ex.getMessage();
                return res;
            }
            finally{
                if(checkExceptionOccur || Test.isRunningTest()){
                    List<String> lstEmailAddress;
                    List<String> lstPhoneNumber;
                    if(syncSettings.EmailsToGetFilesMissingAlert__c != null){
                        lstEmailAddress = syncSettings.EmailsToGetFilesMissingAlert__c.split(',');
                    }
                    if(syncSettings.SMS_Recipients_For_Sync_Data_Failures__c != null){
                        lstPhoneNumber = syncSettings.SMS_Recipients_For_Sync_Data_Failures__c.split(',');
                    }
                    SendExceptionNotification(lstEmailAddress,lstPhoneNumber,strExceptionMsg,syncSettings.Enable_SMS_Alerts__c);
                }
            }
            
        }
            
        if(checkFiles){
            
            String query = collect.SyncHelper.getBatchQuery(table, true, true);
           
            if (Test.isRunningTest()) {
                res.batchId = 'test00000000000';
            } else {            
	            System.debug('SyncJob2: query: ' + query);

                collect.SyncJob2 job = new collect.SyncJob2((String) null,
                        query,
                        table,
                        submitNextJobs,
                        submitCreateActivity,
                        iBatchSize);

                Id jobId = Database.ExecuteBatch(job, iBatchSize);

                res.batchId = String.valueOf(jobId);            
            }
            /*
            if(objErrorControl != null && objErrorControl.ScCollectionEnabeRecordMisCntVerificatio__c== true){
                CheckESBSalesforceRecordCountMismatch();  
            }*/
                
            return res;
            
        }
        else{
            res.errorCode = 'INVALID_INPUT';
            res.status = 'FILES ARE MISSING IN SALESFORCE';
            return res; 
        }   
    }
    
    public static void SendExceptionNotification(List<String> lstEmailAddress,List<String> lstPhoneNumber,String strExceptionMsg,Boolean sendEmail){
        System.debug('Inside SendExceptionNotification');
        String body = 'Hi All, <br/><br/>';
        body +=  'Today Sync Job didn\'t run because of following issue -<br/><br/> ';
        body += '<b>ERROR :</b> '+strExceptionMsg+'.<br/><br/>';
        body += 'Thanks,<br/>';
        body += 'Pepper Admin.';
        if(lstEmailAddress != null && lstEmailAddress.Size() > 0){
        
            List<Messaging.SingleEmailMessage> lstAllmail = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new  Messaging.SingleEmailMessage();
            mail.setToAddresses(lstEmailAddress);
            mail.setSubject('Exception in Sync Process');
            mail.setHtmlBody(body);
            lstAllmail.add(mail);
            Messaging.sendEmail(lstAllmail );
        
        }
        if(lstPhoneNumber != null && lstPhoneNumber.Size() > 0 && sendEmail){
            System.debug('Inside Phone');
            body = body.replace('<br/>','\n');
            body = body.replace('<b>','');
            body = body.replace('</b>','');
            List<smagicinteract__smsmagic__c> lstSMSObjectList = new List<smagicinteract__smsmagic__c>();
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('CollectionSenderId');
            for(String strPhoneNumber : lstPhoneNumber){
                
                smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                smsObject.smagicinteract__SenderId__c = objSetting.senderId__c;
                smsObject.smagicinteract__PhoneNumber__c = strPhoneNumber;
                smsObject.smagicinteract__Name__c = 'Exception NOTIFICATION '+ System.TODAY(); // records name
                smsObject.smagicinteract__ObjectType__c = 'ESB Batch Job Stat'; // record type
                smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
                smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                smsObject.smagicinteract__SMSText__c = body;
                
                lstSMSObjectList.add(smsObject);
                
            }
            
            Database.insert(lstSMSObjectList,false);
        }
        
    }
    
    public static List<ESB_Batch_Load_Stat__c> lstTodaysBatchLoadStat;
    public static Boolean CheckTodaysFiles(){
        String strPAFFilesName = 'Contracts,Transactions,Bank-Accounts,Party';
        String strMORTGAGEFilesName = 'Contracts,Transactions,Bank-Accounts,Party';
        List<String> lstProcessNamePAF ;
        List<String> lstProcessNameMORTGAGE;
        
        //Query Batch Load Stat for TODAY's Data
        lstTodaysBatchLoadStat = [Select Id,Entity__c,LOB__c,CreatedDate,Batch_Job_Instance_Id__c,Loaded_Records__c 
                                    From ESB_Batch_Load_Stat__c 
                                    Where CreatedDate = TODAY];
            
        if(syncSettings.Processes_Names_PAF__c != null){
            lstProcessNamePAF = syncSettings.Processes_Names_PAF__c.split(','); 
        }
        else{
            lstProcessNamePAF = strPAFFilesName.split(',');
            
        }
        if(syncSettings.Processes_Names_Mortgage__c != null){
            lstProcessNameMORTGAGE = syncSettings.Processes_Names_Mortgage__c.split(',');
        }
        else{
            lstProcessNameMORTGAGE = strMORTGAGEFilesName.split(',');
        }
        
        map<String,set<String>> mapLOBtoSetOfEntity = new map<String,set<String>>();
        if(lstTodaysBatchLoadStat != null && lstTodaysBatchLoadStat.Size() > 0){
            for(ESB_Batch_Load_Stat__c objBatchLoadStat : lstTodaysBatchLoadStat){
                
                if(!String.isBlank(objBatchLoadStat.LOB__c)){
                    if(mapLOBtoSetOfEntity.get(objBatchLoadStat.LOB__c) == null){
                        mapLOBtoSetOfEntity.put(objBatchLoadStat.LOB__c,new set<String>());
                    }
                    mapLOBtoSetOfEntity.get(objBatchLoadStat.LOB__c).add(objBatchLoadStat.Entity__c);
                }
                    
            }
        }
       
        system.debug(mapLOBtoSetOfEntity);
        List<String> lstOfMissingPAFFiles = new List<String>();
        if(lstProcessNamePAF != null && lstProcessNamePAF.Size() > 0){
            String strLOBforPAF = 'PAF';
            for(String str : lstProcessNamePAF){
                if(mapLOBtoSetOfEntity.ContainsKey(strLOBforPAF) && mapLOBtoSetOfEntity.get(strLOBforPAF) != null 
                    && mapLOBtoSetOfEntity.get(strLOBforPAF).Contains(str)){
                    continue;
                }
                else{
                    lstOfMissingPAFFiles.add(str);
                }
            }
        }
        system.debug(lstOfMissingPAFFiles);
        List<String> lstOfMissingMORTGAGEFiles = new List<String>();
        if(lstProcessNameMORTGAGE != null && lstProcessNameMORTGAGE.Size() > 0){
            String strLOBforMortgage = 'Mortgage';
            for(String str : lstProcessNameMORTGAGE){
                if(mapLOBtoSetOfEntity.ContainsKey(strLOBforMortgage) && mapLOBtoSetOfEntity.get(strLOBforMortgage) != null 
                    && mapLOBtoSetOfEntity.get(strLOBforMortgage).Contains(str)){
                    continue;
                }
                else{
                    lstOfMissingMORTGAGEFiles.add(str);
                }
            }
        }
        
        List<Messaging.SingleEmailMessage> lstAllmail = new List<Messaging.SingleEmailMessage>();
        if((lstOfMissingPAFFiles != null && lstOfMissingPAFFiles.Size() > 0) || (lstOfMissingMORTGAGEFiles != null && lstOfMissingMORTGAGEFiles.Size() > 0)){
            
            if(syncSettings.Enable_Email_Alerts__c || syncSettings.Enable_SMS_Alerts__c){
                
                if(syncSettings.Enable_Email_Alerts__c){
                    
                    
                    List<EmailTemplate> lstTemplate = [Select Id,Body,HtmlValue,Subject,DeveloperName 
                                                        From EmailTemplate 
                                                        Where DeveloperName = 'ScCollection_ESB_Salesforce_Sync_File_Missing_Notification'];
                                                        
                    if(lstTemplate != null && lstTemplate.Size() > 0){
                        
                        if(syncSettings.EmailsToGetFilesMissingAlert__c != null){
                            
                            List<String> lstEmailAddress = syncSettings.EmailsToGetFilesMissingAlert__c.split(',');
                            if(lstEmailAddress != null && lstEmailAddress.Size() >0){
                                
                                Messaging.SingleEmailMessage mail = new  Messaging.SingleEmailMessage();
                                
                                String strhtmlBody = '';
                                strhtmlBody = lstTemplate[0].HtmlValue;
                                
                                String strPAFFilesList = '<ul>';
                                if(lstOfMissingPAFFiles != null && lstOfMissingPAFFiles.Size() > 0){
                                    for(String strPAFFiles : lstOfMissingPAFFiles){
                                        strPAFFilesList += '<li>' + strPAFFiles + '</li>';  
                                    }   
                                }
                                strPAFFilesList +='</ul>';
                                
                                String strMORTGAGEFilesList = '<ul>';
                                if(lstOfMissingMORTGAGEFiles != null && lstOfMissingMORTGAGEFiles.Size() > 0){
                                    for(String strMORTGAGEFiles : lstOfMissingMORTGAGEFiles){
                                        strMORTGAGEFilesList += '<li>' + strMORTGAGEFiles + '</li>';    
                                    }   
                                }
                                strMORTGAGEFilesList +='</ul>';
                                
                                strhtmlBody = strhtmlBody.replace('{paffiles}',(strPAFFilesList));
                                strhtmlBody = strhtmlBody.replace('{mortgagefiles}',(strMORTGAGEFilesList));
                                
                                mail.setToAddresses(lstEmailAddress);
                                mail.setSubject(lstTemplate[0].Subject);
                                mail.setHtmlBody(strhtmlBody);
                                lstAllmail.add(mail);   
                            }
                                
                        }
                    }
                    if(lstAllmail != null && lstAllmail.size()>0){
                        Messaging.sendEmail(lstAllmail );
                    }
                                                        
                }
                if(syncSettings.Enable_SMS_Alerts__c){
                    
                    if(syncSettings.SMS_Recipients_For_Sync_Data_Failures__c != null){
                        
                        List<String> lstPhoneNumberToSendSMS = syncSettings.SMS_Recipients_For_Sync_Data_Failures__c.split(',');
                        List<smagicinteract__smsmagic__c> lstSMSObjectList = new List<smagicinteract__smsmagic__c>();
                        Sms_Magic__c objSetting = Sms_Magic__c.getValues('CollectionSenderId');
                        for(String strPhoneNumber : lstPhoneNumberToSendSMS){
                            
                            smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
                            smsObject.smagicinteract__SenderId__c = objSetting.senderId__c;
                            smsObject.smagicinteract__PhoneNumber__c = strPhoneNumber;
                            smsObject.smagicinteract__Name__c = 'SYNC FILE MISSING NOTIFICATION '+ System.TODAY(); // records name
                            smsObject.smagicinteract__ObjectType__c = 'ESB Batch Job Stat'; // record type
                            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
                            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                            smsObject.smagicinteract__SMSText__c = syncSettings.SMS_Recipients_For_Sync_Data_Failures__c;
                            
                            lstSMSObjectList.add(smsObject);
                            
                        }
                        Database.insert(lstSMSObjectList,false);
                            
                    }
                }               
            }
            return false;
        }
        else{
            return true;
        }
    }
    
}