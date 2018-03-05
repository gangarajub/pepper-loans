public class MulesoftBatchJobHandler 
{
    public string strPageMessage {get;Set;}
    public string strPageErrors {get;Set;}
	
	List<Mulesoft_Configuration__c> lstMulesoftConfig;

    public MulesoftBatchJobHandler()
    {
        lstMulesoftConfig = Mulesoft_Configuration__c.getAll().values();
        strPageMessage = '';
        strPageErrors = '';   
    }

    public void processResult()
    {
	
		if(lstMulesoftConfig != null && lstMulesoftConfig.size() > 0) if(lstMulesoftConfig[0].Result_Batch_Class_Id__c != null)
		{
			List<AsyncApexJob> runningJobs = [select id from AsyncApexJob 
												where 
												(
													status = 'Processing' Or
													status = 'Queued' Or
													status = 'Preparing' Or
													status = 'Holding' 
												) 
												AND ApexClassId =: lstMulesoftConfig[0].Result_Batch_Class_Id__c 
												AND JobType = 'BatchApex'];
			strPageMessage = '';
			if(runningJobs != null && runningJobs.size() >0 )
			{
				strPageMessage += 'Result processing already in process. We\'ll notify you once result processing completed.';
			}
			else
			{
				List<Mule_Batch_Job__c> lstMBatchJob = new List<Mule_Batch_Job__c>(); 
				lstMBatchJob = [select id, Batch_Id__c, Job_Id__c from Mule_Batch_Job__c where Job_Id__c != null and Batch_Id__c != null limit 10000];
				system.debug(lstMBatchJob);
				if(lstMBatchJob != null && lstMBatchJob.size() > 0)
				{
					Database.executeBatch(new MulesoftBatchJobResult(), 1);
					strPageMessage += 'Result processing started. We\'ll notify you once result processing completed.';
				}
				else strPageMessage += 'No pending result found to process. Please check your mail box for previous results.';
			}
		}
    }

    public void initMulesoftProcess()
    {
        strPageMessage = '';
        strPageErrors = '';
        
        try
        {
            if(lstMulesoftConfig != null && lstMulesoftConfig.size() > 0)
            {
                if(lstMulesoftConfig[0].Mulesoft_Job_Url__c != null)
                {
                    HttpRequest httpreq = new HttpRequest();
                    httpreq.setEndpoint(lstMulesoftConfig[0].Mulesoft_Job_Url__c); 
                    httpreq.setMethod('GET');
                
                    if(lstMulesoftConfig[0].Mulesoft_User_Name__c != null && lstMulesoftConfig[0].Mulesoft_Password__c != null)
                    {
                        Blob headerValue = Blob.valueOf(lstMulesoftConfig[0].Mulesoft_User_Name__c + ':' + lstMulesoftConfig[0].Mulesoft_Password__c);
                        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                        httpreq.setHeader('Authorization', authorizationHeader);
                    }

                    Http httpCallout = new Http();
                    HTTPResponse httpRes = httpCallout.send(httpreq);
                    if(httpRes.getStatusCode() == 200)
                    { 
                        strPageMessage = 'Mulesoft batch process startup success. Response from server :  <br/>' + httpRes.getBody();
                    }
                    else strPageErrors = 'Mulesoft batch process startup failed. Response from server :  ' + httpRes.getBody();
                }
            }
        }
        catch (exception e)
        {
            strPageErrors = 'Error :  ' + e;
        }
    }
}