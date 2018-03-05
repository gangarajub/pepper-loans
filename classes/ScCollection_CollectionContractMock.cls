/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_CollectionContractMock
Company:       Saasfocus
Description:   This class is use to create a dummy response for integration testing.
History
2/08/2017      Sandip Bijlwan     
------------------------------------------------------------*/
@isTest
global class ScCollection_CollectionContractMock implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String bodyAsString;
        protected Map<String, String> responseHeaders;
        
        //Constructor
        public ScCollection_CollectionContractMock (Integer code, String status, String body,
                                         Map<String, String> responseHeaders) {
            this.code = code;
            this.status = status;
            this.bodyAsString = body;
            this.responseHeaders = responseHeaders;
        }
        
        /*------------------------------------------------------------
        Author:        Sandip Bijlwan
        Name:          respond
        Company:       Saasfocus
        Description:   This method is used to creates dummy response for integration testing.
        Inputs:        HTTPRequest req
        Returns:       HTTPResponse
        ------------------------------------------------------------*/
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(code);
            resp.setBody(bodyAsString);
            if (responseHeaders != null) {
                 for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
                 }
            }
            return resp;
        }

}