/*
    This trigger is used to update bankdetails when attachment is created
    =============================================================================
    Name                             Date                                version
    =============================================================================
    Sushant Kumar                  13-04-2016                                1.0
    =============================================================================
*/


trigger AutoUpdateBankdetails on Attachment (after insert) {
    public list<pepBank_API_Details__c> lstBankdetails = new list<pepBank_API_Details__c>();
    Map<String,String> objectMap = new Map<String,String>(); 
    public string bnkObjPrefix = '';
    List<Schema.SObjectType> lstSObject = Schema.getGlobalDescribe().Values();
    Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType sObjType = sobjectSchemaMap.get('pepBank_API_Details__c');
    bnkObjPrefix = sObjType.getDescribe().getKeyPrefix(); 
    /*for(Schema.SObjectType sObjType : lstSObject){
       if(sObjType.getDescribe().getName() == 'acfBank_Detail__c')
       {
           bnkObjPrefix = sObjType.getDescribe().getKeyPrefix();
       }
        //objectMap.put(sObjType.getDescribe().getName(),sObjType.getDescribe().getKeyPrefix());
    }*/
    for(Attachment attchObj : Trigger.New)
    {
       If(attchObj != null && attchObj.ParentId != null && bnkObjPrefix != null && bnkObjPrefix <> ''){ 
        string strTempId = attchObj.ParentId;
        String prefix =  strTempId.substring(0,3);
        //string objectAPIName = objectMap.get(prefix);
        //System.debug('objectAPIName ----------- '+objectAPIName);
        If(prefix == bnkObjPrefix){
           pepBank_API_Details__c objBankdetails = new pepBank_API_Details__c(id = attchObj.ParentId,pepAttachmentId__c = attchObj.Id); 
           lstBankdetails.add(objBankdetails);
        }
      }
    }
    If(lstBankdetails != null && lstBankdetails.size()>0){
         Update lstBankdetails;
    }
}