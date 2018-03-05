public class UploadDailyFilesBatch implements Schedulable,Database.Batchable<sobject>,Database.stateful,Database.AllowsCallouts  {

    private Integer batchSize = 500;

    private static String NAME = 'Upload Daily files';
    
    
    public UploadDailyFilesBatch(){
        
    }
    
    public void execute(SchedulableContext sc) {
        UploadDailyFilesBatch  j = new UploadDailyFilesBatch();
        Database.executeBatch(j, 1);
    }
    
    public Database.queryLocator Start(Database.BatchableContext bc) {
        Set<String> folderNames = new Set<String>();
        folderNames.add(Label.Disbursal_Folder);
        folderNames.add(Label.Payment_Folder);
        Set<Id> folderIds = new Set<Id>();
        List<Folder> folders = [select Id from Folder where Name In:folderNames ];
        
        for(Folder f:folders){
             folderIds.add(f.id);
        }
        
        
        String query = 'select id, name,body from Document' +
                ' WHERE folderId ' +
                'IN:folderIds';
        system.debug(query);
        return Database.getQueryLocator(query);
    } // do nothing
    
    public  void Execute(Database.BatchableContext bc, List<sObject> scope) {
          List<Document> d= (List<Document>)scope;
          system.debug(d);
          String filename = d[0].Name;
          String fileContent = d[0].Body.toString();
          system.debug(fileContent);
          List<Westpac_Parameters__c> wsp= [select id,name,username__c,password__c,EndUrl__c from Westpac_Parameters__c limit 1];
      
                HTTP h = new HTTP();
                HTTPRequest r = new HTTPRequest();
              
                String first=fileName.substring(0,18);
                integer len = fileName.length();
                
                String sb=fileName.substring(19, len);
                system.debug('first'+first);
                system.debug('sb'+sb);
                
                String s2 = sb.replaceAll('-','');
                String s3 = s2.replaceAll(':','');
                String s4 = s3.replaceAll(' ','_');    
                String s5='';
                Boolean isDisbursal = false;
                if(filename.contains('wibs_pl_de_cr')){
                         s5='wibs_pl_de_cr_'+s4+'00'+'.txt';
                         isDisbursal = true;
                 }else if(filename.contains('wibs_pl_de_mx')){
                         s5='wibs_pl_de_mx_'+s4+'00'+'.txt';
                         isDisbursal = false;
                 }
                    
                
                system.debug(s5);
                JsonRequestBody json1 = new JsonRequestBody();
                json1.source='sf-pl';
                json1.target='westpac';
                json1.filename=s5;
                json1.content=fileContent;
                
                
                
                String JSONString = JSON.serialize(json1);
                
                
                r.setEndpoint(wsp[0].EndUrl__c);
                Blob headerValue = Blob.valueOf(wsp[0].username__c + ':' + wsp[0].password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                r.setHeader('Authorization', authorizationHeader);
                r.setHeader('content-type', 'application/json');
                r.setMethod('POST');
                r.setTimeout(60000);
                r.setBody(JSONString);
                HTTPResponse resp = h.send(r);
        System.debug(resp.getBody());
                if(isDisbursal){
                      Folder f = [select id from Folder where Name='Disbursal Files Sent to Westpac'] ;
                      d[0].Name = s5;
                      d[0].folderId = f.Id;
                }else{
                      Folder f = [select id from Folder where name = 'Payment Files Sent to Westpac'];
                      d[0].Name = s5;
                      d[0].folderId = f.Id;
                 }
                update d;
        
    }
    
    public void Finish(Database.BatchableContext bc) {
        
    }
    

}