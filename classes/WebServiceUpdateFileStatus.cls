@RestResource(urlMapping='/updateFileStatus')
global with sharing class WebServiceUpdateFileStatus{
   
    global class Response{
        public String status;
        public String errorCode;
        
        public Response(){
            errorCode = 'No_Error';
            status =null;
        }
    }
    public class Request{
        public String fileName;
        public String status;
    }
    
    @HttpPost
    global static Response doPost(){
        RestRequest req = RestContext.request;
        
        Response r = new Response();
        String jsonData = req.requestBody.toString();
        Request doc;
        try{
           doc = (Request)JSON.deserialize(jsondata, Request.class);
        }catch (Exception e){
           r.status=e.getMessage();
           r.errorCode='INVALID_INPUT';
           return r;
        }
        List<Document> d = new List<Document>();
        if(doc.filename!=null){
            d = [select id,folderId from Document where Name =:doc.filename];
        }
        Boolean success =false;
        Folder failedTOSendToWestpac = [select id from Folder where Name = 'Failed To Send To Westpac'];
        Folder failedTOSendToSFTP = [select id from Folder where Name = 'Failed To Send To SFTP'];
        if(d.size()>0){
            if(doc.status!=null && doc.status.equalsIgnoreCase('FAILED_TO_SEND_TO_WESTPAC')){
                d[0].folderId = failedTOSendToWestpac.id;
                success  =true;
            }else{
                r.status = 'Invalid file status.';
            }
            
            if(doc.status!=null && doc.status.equalsIgnoreCase('FAILED_TO_SEND_TO_SFTP')){
                d[0].folderId = failedTOSendToSFTP.id;
                success  = true;
            }else{
                r.status = 'Invalid file status.';
            }
        }else{
            r.status = 'File not found.';
        }
        
        
        update d;
        if(success){
            r.status = 'Success';
            
        }
        
        return r;
    }
}