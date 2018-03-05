public class FetchAppDocCatAttachmentJunction{

    public static Map<genesis__Application_Document_Category__c,List<genesis__AppDocCatAttachmentJunction__c>>  fetchAllDoc(List<genesis__Application_Document_Category__c> DocIds){
        
        
        
       
        Map<genesis__Application_Document_Category__c,List<genesis__AppDocCatAttachmentJunction__c>> docToAttch = new Map<genesis__Application_Document_Category__c,List<genesis__AppDocCatAttachmentJunction__c>>();
        
        for(genesis__Application_Document_Category__c DocId:DocIds){
        //System.debug('DocId'+DocId);
        List<genesis__AppDocCatAttachmentJunction__c> allJnObject = new List<genesis__AppDocCatAttachmentJunction__c>();
        if(DocId!=null){
            
            allJnObject = [select id,name,genesis__Application_Document_Category__c,genesis__AttachmentId__c 
                            from genesis__AppDocCatAttachmentJunction__c
                            where genesis__Application_Document_Category__c=:DocId.Id];
           
                           
                        
        }
            //mapping Application Document Category to listo of genesis__AppDocCatAttachmentJunction__c
            docToAttch.put(DocId,allJnObject);  
       }
            
        return docToAttch;
        
    }
}