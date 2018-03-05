// --------------------------------------------------------------------------------------------------------
// This class handles the generic solution for capturing the results or the exception for various operations.
// --------------------------------------------------------------------------------------------------------
// Created Date: 7-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestResponseHandler
// --------------------------------------------------------------------------------------------------------
public class ScCollection_ResponseHandler
{
    // --------------------------------------------------------------------------------------------------------
    // This wrapper class handles the generic solution for capturing all dml results/exception responses.
    // --------------------------------------------------------------------------------------------------------
    // Created Date: 07-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    public class wrapperForDmlOperation
    {   
        public List<Sobject> lstResultSet;                    //list to hold success records
        public List<ScCollection_LogChild__c> lsterrorlog;    //list of log object to hold error
        
        public wrapperForDmlOperation()
        {
            lstResultSet = new List<Sobject>();
            lsterrorlog = new List<ScCollection_LogChild__c>();
        }
    }
    
    // --------------------------------------------------------------------------------------------------------
    // This wrapper class handles the generic solution for capturing all query results/exception responses.
    // --------------------------------------------------------------------------------------------------------
    // Created Date: 07-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // --------------------------------------------------------------------------------------------------------
    public class wrapperForQueryOperation
    {
        public String strqueryProcessed;                //the query string that was processed
        public ScCollection_LogChild__c objerrorlog;    //log object to hold error
        public List<Sobject> lstResultSet;              //result set if query is processed successfully 
        
        public wrapperForQueryOperation()
        {
            strqueryProcessed = '';
            objerrorlog = new ScCollection_LogChild__c();
            lstResultSet = new List<Sobject>();
        }
    }
}