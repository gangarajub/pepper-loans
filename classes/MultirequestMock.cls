@isTest
Public class MultirequestMock implements HttpcalloutMock{
    Public Map<string,HttpcalloutMock> requests;
    public MultiRequestMock(Map<String,HttpCalloutMock> requests){
                this.requests = requests;
            }
    Public Httpresponse respond(Httprequest req){
            HttpcalloutMock mock = requests.get('httpresponse');
            return mock.respond(req);
          }
}