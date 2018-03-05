// This batch class is used as an Anlytics Snapshot for PAF data
// --------------------------------------------------------------------------------------------- 
// Version#     Date              Author                 Description
// ---------------------------------------------------------------------------------------------
// 1.0       3-May-2016      Sumit Banarji           Initial Version
// ---------------------------------------------------------------------------------------------
global class MulesoftBatchJobResult implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts
{
	//-------- Defining Global Variables -----//
    global Integer TotalJobs;
    global Integer NumberBatchesFailed;
    global Integer NumberBatchesInProgress;
    global Integer TotalRecords;
    global Integer TotalFailedRecords;
    global string FailedRecInfo;
    global string sessionId;
    global string EndPointUrl;
    global string APIver; 
    global List<Mulesoft_Configuration__c> lstMulesoftConfig;
    global List<Mule_Batch_Job__c> lstMuleBatchJobtodel;
    //----- End Defining Global Variables ----//

	/**
	* @Constructor
	* @Getting data from Custom Settings and initializing global variables.
	*/
    global MulesoftBatchJobResult()
    {
        TotalJobs = 0;
        NumberBatchesFailed = 0;
        NumberBatchesInProgress = 0;
        TotalRecords = 0;
        TotalFailedRecords = 0;
        FailedRecInfo = '';
        lstMuleBatchJobtodel = new List<Mule_Batch_Job__c>();
        lstMulesoftConfig = Mulesoft_Configuration__c.getAll().values();
        APIver = '36.0'; 
    }
    
	/**
	* @Batch query locator
	* @param BC 
	* @return Database.QueryLocator 
	*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator('select id, Batch_Id__c, Job_Id__c from Mule_Batch_Job__c where Job_Id__c != null and Batch_Id__c != null');
    }

    /**
	* @Execute Method used to process current context
	* @param BC 
	* @param scope 
	*/
    global void execute(Database.BatchableContext BC, List<Mule_Batch_Job__c> scope)
    {
        if(scope != null) for(Mule_Batch_Job__c objMBatchJob : scope)
        {
            if(sessionId == null || sessionId == '') createSession();
            fetchResult(objMBatchJob.Job_Id__c, objMBatchJob.Batch_Id__c, objMBatchJob.Id);
        }
    }

    /**
    * @Method used to run a process after finishing of batch
    * @param BC 
    */
    global void finish(Database.BatchableContext BC)
    {
        if(lstMulesoftConfig != null && lstMulesoftConfig.size() > 0)
        {
            List<string> successRecipients;
            List<string> errorRecipients; 

			//--------- Getting data from custom settings ---------//
            if(lstMulesoftConfig[0].Success_Recipients__c != null) successRecipients = lstMulesoftConfig[0].Success_Recipients__c.trim().split('\n');
            if(lstMulesoftConfig[0].Error_Recipient__c != null) errorRecipients = lstMulesoftConfig[0].Error_Recipient__c.trim().split('\n');
            if(lstMulesoftConfig[0].API_ver__c != null) APIver = lstMulesoftConfig[0].API_ver__c;
            //-------- End Getting data from custom settings ------//

            if(TotalFailedRecords > 0 && NumberBatchesInProgress == 0 && TotalRecords > 0)
            {
				//-------  Sending failed report mail ----------//
                string msgBody = 'Hi there,';
                msgBody += '<br/> '+ TotalFailedRecords +' records failed to upsert while upserting records from Data Warehouse to Salesforce Org.';
                msgBody += '<br/> Information of failed records given below.';
                msgBody += '<br/> ' + FailedRecInfo.replace('\n', '<br/>').replace(' ', '&nbsp;');

                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                semail.setToAddresses(errorRecipients);
                semail.setSubject('Mulesoft failed records info.');
                semail.setHtmlbody(msgBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
                //------ End Sending failed report mail ---------//

				//Deleting processed job detail records
                if ( lstMuleBatchJobtodel.size() > 0 ) delete lstMuleBatchJobtodel;
				
            }
            else if(NumberBatchesInProgress == 0 && TotalRecords > 0)
            {
				//-------  Sending success report mail ----------//
                string msgBody = 'Hi there,';
                msgBody += '<br/> '+ TotalRecords +' records successfully upserted Salesforce Org from data warehouse.';
                msgBody += '<br/> Dashboards are now updated.';

                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                semail.setToAddresses(errorRecipients);
                semail.setSubject('Dashboard updated & Data sync completed.');
                semail.setHtmlbody(msgBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
				//------ End Sending success report mail ---------//
                
				//Deleting processed job detail records
                if ( lstMuleBatchJobtodel.size() > 0 ) delete lstMuleBatchJobtodel;
            }
            else if (NumberBatchesInProgress == 0 && TotalRecords > 0)
            {
				//-------  Sending status mail ----------//
                string msgBody = 'Hi there,';
                msgBody += '<br/> Mulesoft bulk upsert jobs stil in process, process will be re-initiated automatically after some time and you will receive a report over a mail.';

                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                semail.setToAddresses(errorRecipients);
                semail.setSubject('Jobs currently in process.');
                semail.setHtmlbody(msgBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
                //------ End  Sending status mail --------//
            }
        }
    }
    
	/**
	* @Method Used to fetch result from salesforce.
	* @param jobId 
	* @param batchId 
	* @param mBatchJobId 
	*/
    public void fetchResult(string jobId, string batchId, string mBatchJobId)
    { 
        if(jobId != null && jobId != '' && batchId != null && batchId != '')
        {
            TotalJobs += 1;

			//---------- Getting Job Details -----------//
            HttpRequest jobInfo = new HttpRequest();
            jobInfo.setEndpoint(EndPointUrl +'/services/async/'+APIver+'/job/'+ jobId);
            jobInfo.setMethod('GET');
            jobInfo.setHeader('X-SFDC-Session',sessionId);
            Http httpjobInfo = new Http();
			HTTPResponse resjobInfo;
            if(!Test.isRunningTest()) 
			{
				resjobInfo = httpjobInfo.send(jobInfo);
			}
			else
			{
				//------------- Creating a fake response ----------------//
				resjobInfo = new HttpResponse();
				resjobInfo.setHeader('Content-Type', 'application/xml');
				resjobInfo.setStatusCode(200);

				string strResponseBody = '';
				strResponseBody += '<?xml version="1.0" encoding="UTF-8"?>';
				strResponseBody += '<jobInfo xmlns="http://www.force.com/2009/06/asyncapi/dataload">';
				strResponseBody += '  <id>750x000000009tvAAA</id>';
				strResponseBody += '  <operation>upsert</operation>';
				strResponseBody += '  <object>Application_Data__c</object>';
				strResponseBody += '  <createdById>005x0000001WR0lAAG</createdById>';
				strResponseBody += '  <createdDate>2016-01-10T00:53:19.000Z</createdDate>';
				strResponseBody += '  <systemModstamp>2016-01-10T00:53:19.000Z</systemModstamp>';
				strResponseBody += '  <state>Open</state>';
				strResponseBody += '  <concurrencyMode>Parallel</concurrencyMode>';
				strResponseBody += '  <contentType>CSV</contentType>';
				strResponseBody += '  <numberBatchesQueued>0</numberBatchesQueued>';
				strResponseBody += '  <numberBatchesInProgress>0</numberBatchesInProgress>';
				strResponseBody += '  <numberBatchesCompleted>1</numberBatchesCompleted>';
				strResponseBody += '  <numberBatchesFailed>0</numberBatchesFailed>';
				strResponseBody += '  <numberBatchesTotal>1</numberBatchesTotal>';
				strResponseBody += '  <numberRecordsProcessed>10</numberRecordsProcessed>';
				strResponseBody += '  <numberRetries>0</numberRetries>';
				strResponseBody += '  <apiVersion>36.0</apiVersion>';
				strResponseBody += '  <numberRecordsFailed>0</numberRecordsFailed>';
				strResponseBody += '  <totalProcessingTime>0</totalProcessingTime>';
				strResponseBody += '  <apiActiveProcessingTime>0</apiActiveProcessingTime>';
				strResponseBody += '  <apexProcessingTime>0</apexProcessingTime>';
				strResponseBody += '</jobInfo>';

				resjobInfo.setBody(strResponseBody);
				//----------- End Creating a fake response ---------------//

			}
            //-------- End Getting Job Details ---------//

			//Processing job response
            if(resjobInfo.getStatusCode() == 200)
            {
                Dom.Document docjobInfo = new Dom.Document();
                docjobInfo.load(refineXMLData(resjobInfo.getBody()));
                Dom.XMLNode xmlJobinfo = docjobInfo.getRootElement();
                
                
                NumberBatchesFailed += Integer.valueOf(xmlJobinfo.getChildElement('numberBatchesFailed', null).getText());
                String objectName = xmlJobinfo.getChildElement('object', null).getText();
                NumberBatchesInProgress += Integer.valueOf(xmlJobinfo.getChildElement('numberBatchesInProgress', null).getText());
                Integer numberProcessedRec = Integer.valueOf(xmlJobinfo.getChildElement('numberRecordsProcessed', null).getText());
                
                TotalRecords += numberProcessedRec;
    
                if(NumberBatchesInProgress == 0 && numberProcessedRec > 0)
                {
                    lstMuleBatchJobtodel.add(new Mule_Batch_Job__c(Id = mBatchJobId));
                    HttpRequest batchInfo = new HttpRequest();
                    batchInfo.setEndpoint(EndPointUrl +'/services/async/'+APIver+'/job/'+ jobId +'/batch/'+ batchId);
                    batchInfo.setMethod('GET');
                    batchInfo.setHeader('X-SFDC-Session',sessionId);
                    Http httpbatchInfo = new Http();

                    HTTPResponse resBatchInfo;
                    
					if(!Test.isRunningTest()) 
					{
						resBatchInfo = httpbatchInfo.send(jobInfo);
					}
					else
					{
						//------------- Creating a fake response ----------------//
						resBatchInfo = new HttpResponse();
						resBatchInfo.setHeader('Content-Type', 'application/xml');
						resBatchInfo.setStatusCode(200);

						string strResponseBody = '';
						strResponseBody += '<?xml version="1.0" encoding="UTF-8"?>';
						strResponseBody += '<batchInfo xmlns="http://www.force.com/2009/06/asyncapi/dataload">';
						strResponseBody += '  <id>751x000000009vwAAA</id>';
						strResponseBody += '  <jobId>750x000000009tvAAA</jobId>';
						strResponseBody += '  <state>Completed</state>';
						strResponseBody += '  <createdDate>2016-01-10T00:59:47.000Z</createdDate>';
						strResponseBody += '  <systemModstamp>2016-01-10T01:00:19.000Z</systemModstamp>';
						strResponseBody += '  <numberRecordsProcessed>10</numberRecordsProcessed>';
						strResponseBody += '  <numberRecordsFailed>4</numberRecordsFailed>';
						strResponseBody += '  <totalProcessingTime>0</totalProcessingTime>';
						strResponseBody += '  <apiActiveProcessingTime>0</apiActiveProcessingTime>';
						strResponseBody += '  <apexProcessingTime>0</apexProcessingTime>';
						strResponseBody += '</batchInfo>';

						resBatchInfo.setBody(strResponseBody);
						//----------- End Creating a fake response ---------------//
					}


					Dom.Document docbatchInfo = new Dom.Document();
                    docbatchInfo.load(refineXMLData(resBatchInfo.getBody()));
                    Dom.XMLNode xmlbatchinfo = docbatchInfo.getRootElement();
    
                    String state = xmlbatchinfo.getChildElement('state', null).getText(); 
                    integer numberRecordsProcessed = 0; 
                    integer numberRecordsFailed = 0;
    
                    if(xmlbatchinfo.getChildElement('numberRecordsProcessed', null) != null) numberRecordsProcessed = Integer.valueOf(xmlbatchinfo.getChildElement('numberRecordsProcessed', null).getText());
                    if(xmlbatchinfo.getChildElement('numberRecordsFailed', null) != null) numberRecordsFailed = Integer.valueOf(xmlbatchinfo.getChildElement('numberRecordsFailed', null).getText());
    
                    if(numberRecordsFailed > 0)
                    {
                        TotalFailedRecords +=  numberRecordsFailed;
                        HttpRequest request = new HttpRequest();
                        request.setEndpoint(EndPointUrl +'/services/async/'+APIver+'/job/'+ jobId +'/batch/'+ batchId +'/request');
                        request.setMethod('GET');
                        request.setHeader('X-SFDC-Session', sessionId);
                        Http httprequest = new Http();
                       
					    HTTPResponse resrequest;
                        
						if(!Test.isRunningTest()) 
						{
							resrequest = httprequest.send(request);
						}
						else
						{
							//------------- Creating a fake response ----------------//
							resrequest = new HttpResponse();
							resrequest.setHeader('Content-Type', 'application/xml');
							resrequest.setStatusCode(200);

							string strResponseBody = '';
							strResponseBody += '<sObjects xmlns="http://www.force.com/2009/06/asyncapi/dataload" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
							strResponseBody += '<sObject>';
							strResponseBody += '<MileStone__c>Approved in Principle</MileStone__c>';
							strResponseBody += '<ApplicationState__c>NSW</ApplicationState__c>';
							strResponseBody += '<Sub_Status__c>Approved With Condition(s)</Sub_Status__c>';
							strResponseBody += '<AssetType__c>Motor Vehicle</AssetType__c>';
							strResponseBody += '<NetFinancedAmount__c>28769.2</NetFinancedAmount__c>';
							strResponseBody += '<ApplicationDate__c>2015-07-31T00:00:00.000Z</ApplicationDate__c>';
							strResponseBody += '<TotalFinancedAmount__c>24169.2</TotalFinancedAmount__c>';
							strResponseBody += '<Channel__c>PAF - Auto Broker</Channel__c>';
							strResponseBody += '<ApplicationNumber__c>P-20150731000200</ApplicationNumber__c>';
							strResponseBody += '</sObject>';
							strResponseBody += '<sObject>';
							strResponseBody += '<MileStone__c>Approved in Principle</MileStone__c>';
							strResponseBody += '<ApplicationState__c>QLD</ApplicationState__c>';
							strResponseBody += '<Sub_Status__c>Approved With Condition(s)</Sub_Status__c>';
							strResponseBody += '<AssetType__c>Others</AssetType__c>';
							strResponseBody += '<NetFinancedAmount__c>105855.92</NetFinancedAmount__c>';
							strResponseBody += '<ApplicationDate__c>2015-07-31T00:00:00.000Z</ApplicationDate__c>';
							strResponseBody += '<TotalFinancedAmount__c>105855.92</TotalFinancedAmount__c>';
							strResponseBody += '<Channel__c>PAF - Commercial Broker</Channel__c>';
							strResponseBody += '<ApplicationNumber__c>P-20150731001000</ApplicationNumber__c>';
							strResponseBody += '</sObject>';
							strResponseBody += '</sObjects>';

							resrequest.setBody(strResponseBody);
							//----------- End Creating a fake response ---------------//
						}
											    
                        Dom.Document docRequest = new Dom.Document();
                        System.debug(LoggingLevel.Info, 'Response :' + refineXMLData1(resrequest.getBody()));
                        docRequest.load(refineXMLData1(resrequest.getBody()));
                        Dom.XMLNode xmlRequest = docRequest.getRootElement();
                        Dom.XMLNode[] childReqNodes = xmlRequest.getChildElements();
    
                        HttpRequest result = new HttpRequest();
                        result.setEndpoint(EndPointUrl +'/services/async/'+APIver+'/job/'+ jobId +'/batch/'+ batchId +'/result');
                        result.setMethod('GET');
                        result.setHeader('X-SFDC-Session',sessionId);
                        Http httpresult = new Http();
                        
						HTTPResponse resresult;

						if(!Test.isRunningTest()) 
						{
							resresult = httpresult.send(result);
						}
						else
						{
							//------------- Creating a fake response ----------------//
							resresult = new HttpResponse();
							resresult.setHeader('Content-Type', 'application/xml');
							resresult.setStatusCode(200);

							string strResponseBody = '';
							strResponseBody += '<results xmlns="http://www.force.com/2009/06/asyncapi/dataload">';
							strResponseBody += '<result>';
							strResponseBody += '<id>a7Lp00000008YlYEAU</id>';
							strResponseBody += '<success>true</success>';
							strResponseBody += '<created>false</created>';
							strResponseBody += '</result>';
							strResponseBody += '<result>';
							strResponseBody += '<errors>';
							strResponseBody += '<message>storage limit exceeded</message>';
							strResponseBody += '<statusCode>STORAGE_LIMIT_EXCEEDED</statusCode>';
							strResponseBody += '</errors>';
							strResponseBody += '<success>false</success>';
							strResponseBody += '<created>true</created>';
							strResponseBody += '</result>';
							strResponseBody += '</results>';
							resresult.setBody(strResponseBody);
							//----------- End Creating a fake response ---------------//
						}

                        Dom.Document docResult = new Dom.Document();
                        docResult.load(refineXMLData2(resresult.getBody()));
                        Dom.XMLNode xmlResult = docResult.getRootElement();
                        Dom.XMLNode[] childResultNodes = xmlResult.getChildElements();
    
                        for(integer i = 0; i < childResultNodes.size(); i++) 
                        {
                            Dom.XMLNode childResult = childResultNodes[i];
                            Dom.XMLNode childRequest = childReqNodes[i];
    
                            if(childResult.getChildElement('success', null).getText() == 'false')
                            {
                                FailedRecInfo += '\n';
                                if(objectName == 'Application_Data__c')
                                {
                                    FailedRecInfo += '\n ApplicationNumber : ' + childRequest.getChildElement('ApplicationNumber__c', null).getText();
                                }
                                else if(objectName == 'Pepper_Data__c')
                                {
                                    FailedRecInfo += '\n ApplicationID : ' + childRequest.getChildElement('ApplicationID__c', null).getText();
                                }
    
                                for(Dom.XMLNode objChildErrors : childResult.getChildElements()) if(objChildErrors.getName()=='errors')
                                {
                                    FailedRecInfo += '\n message : ' + objChildErrors.getChildElement('message', null).getText();
                                    FailedRecInfo += '\n statusCode : ' + objChildErrors.getChildElement('statusCode', null).getText();
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                System.debug( 'Get job detail failed. Status Code :'+ resjobInfo.getStatusCode()+'\n Response Body : '+ resjobInfo.getBody());
            }
        }
    }
    
	/**
	* @Method used to create salesforce session 	
	*/
    public void createSession()
    {
        if(lstMulesoftConfig != null && lstMulesoftConfig.size() >0)
        {
            if
            (
                lstMulesoftConfig[0].SF_User_Name__c != null && lstMulesoftConfig[0].SF_Password__c != null && 
                lstMulesoftConfig[0].Client_Id__c != null && lstMulesoftConfig[0].Client_Secret__c != null
            )
            {
                if(lstMulesoftConfig[0].API_ver__c != null) APIver = lstMulesoftConfig[0].API_ver__c;
                if(lstMulesoftConfig[0].Salesforce_Instance_URL__c != null) EndPointUrl = lstMulesoftConfig[0].Salesforce_Instance_URL__c;

                HttpRequest req = new HttpRequest();
                req.setEndpoint(lstMulesoftConfig[0].SF_Token_Endpoint__c);
                req.setMethod('POST');
                req.setBody(buildHttpQuery(new Map<String, String> {
                    'grant_type' => 'password',
                    'username' => lstMulesoftConfig[0].SF_User_Name__c,
                    'password' => lstMulesoftConfig[0].SF_Password__c,
                    'client_id' => lstMulesoftConfig[0].Client_Id__c,
                    'client_secret' => lstMulesoftConfig[0].Client_Secret__c
                }));

                Http http = new Http();
                if(!Test.isRunningTest()) 
				{
					HttpResponse resp = http.send(req);
					Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
					if(m.containsKey('access_token')) sessionId = (String) m.get('access_token');
				}
				else sessionId = 'testSessionId';                
            }
        }
    }

	/**
	* @Method is used to refine XML data 
	* @param strXLData 
	* @return string 
	*/
    public string refineXMLData(string strXLData)
    {
        strXLData = strXLData.replace('\n','').replace('> <','><');
        strXLData = strXLData.replaceAll('\\<\\?xml(.+?)\\?\\>', '').trim();
        strXLData = strXLData.replaceAll('xmlns="http://www.force.com/2009/06/asyncapi/dataload"', '').trim();
        try{strXLData = strXLData.remove('xsi:nil="true"');}catch(exception e){System.debug(e);}
        return strXLData;
    }

	/**
	* @Method is used to refine XML data 
	* @param strXLData 
	* @return string 
	*/
    public string refineXMLData1 (string strXLData)
    {
        strXLData = '<sObjects>' + strXLData.substring(strXLData.indexOf('<sObject>'),strXLData.length());
        strXLData = strXLData.trim();
        try{strXLData = strXLData.remove('xsi:nil="true"');}catch(exception e){System.debug(e);}
        return strXLData;
    }
    
	/**
	* @Method is used to refine XML data 
	* @param strXLData 
	* @return string 
	*/
    public string refineXMLData2 (string strXLData)
    {
        strXLData = '<results>' + strXLData.substring(strXLData.indexOf('<result>'),strXLData.length());
        strXLData = strXLData.trim();
        try{strXLData = strXLData.remove('xsi:nil="true"');}catch(exception e){System.debug(e);}
        return strXLData;
    }

	/**
	* @Method used to build HTTP query
	* @param queryParams 
	* @return String 
	*/
    static String buildHttpQuery(Map<String, String> queryParams) 
    {
        if (queryParams.isEmpty()) {
            return '';
        }
        String[] params = new String[] {};
        for (String k : queryParams.keySet()) {
            String v = EncodingUtil.urlEncode(queryParams.get(k), 'UTF-8');

            params.add(String.format('{0}={1}', new String[] { k, v }));
        }
        return String.join(params, '&');
    }
}