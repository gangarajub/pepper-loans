public class PepperChartcontroller
{
    public string strJSONData {get;set;}
    public PageReference getdata() 
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.google.com/finance?cid=659834927368951&output=json');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        strJSONData = res.getBody();
        strJSONData = strJSONData.replace('// [','[').replace(' ','');
        strJSONData = strJSONData.replaceAll('\\s+', '');
        return null;
    }

}