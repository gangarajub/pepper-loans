Global class COCSync implements DataBase.Batchable<sobject>,DataBase.Stateful{
Global String query;
Global String apiName;
Global set<String> fieldsToQuery;
Global COCSync(String objectApiName){
    apiName=objectApiName;
    fieldsToQuery = new set<string>();
    //Getting all the fields depending upon the Sobject's API name.
    Map<String,Schema.SObjectField> fieldsMap=Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
    //Adding api names of the fields which are createable.
    for(Sobjectfield field:fieldsMap.values()){
        Schema.DescribefieldResult dsr=field.getDescribe();
        if(dsr.iscreateable())
        fieldstoQuery.add(dsr.getname());    
    }
    //Building a Dynamic query to fetch the existing records from the Staging Object. 
    query='Select'+' ';
    for(String str:fieldstoQuery){
     query+=str+',';
    }
    query+='Id'+',';
    query=query.removeend(',');
    query=query+' '+'From'+' ';
    query+=objectApiName;
}
Global DataBase.queryLocator Start(Database.batchablecontext context){
 return DataBase.getqueryLocator(query);
}
Global void execute(Database.batchablecontext context,List<sobject> scope){
    Id mortgageRecordTypeId;
    Id pafRecordTypeId;
    Id propertyInsuranceMortgage;
    Id propertyInsurancePAF;
    mortgageRecordTypeId=[Select id from RecordType where sObjectType='Property__c' and developerName='Mortgage_Property'].id;
    pafRecordTypeId=[Select id from RecordType where sObjectType='Property__c' and developerName='PAF_Property'].id;
    propertyInsuranceMortgage=[Select id from RecordType where sObjectType='Property_Insurance__c' and developerName='Mortgage_Insurance'].id;
    propertyInsurancePAF=[Select id from RecordType where sObjectType='Property_Insurance__c' and developerName='PAF_Insurance'].id;
    
    string errorMessage;
    string finalString;
    errorMessage='';
    finalString='JacksonID,Error \n';
    set<string> stagingPropertiesID = new set<string>();
    set<string> stagingPropertySurrogateIDs = new set<string>();
    set<string> stagingPropertiesInsurerIDs = new set<string>();
    set<string> stagingPropertyValuationIds = new set<string>();
    set<string> stagingPropertyInsuranceIds = new set<string>();
    //Map to put Actual Object against the staging Object.
    Map<string,String> stagingTOMainObject = new Map<string,string>();
    stagingTOMainObject.put('Staging_Property__c','Property__c');
    stagingTOMainObject.put('StagingProperty_Surrogate__c','Property_Surrogate__c');
    stagingTOMainObject.put('Staging_Property_Insurer__c','Property_Insurer__c');
    stagingTOMainObject.put('Staging_Property_Valuation__c','Property_Valuation__c');
    stagingTOMainObject.put('Staging_Property_Insurance__c','Property_Insurance__c');
    List<Property__c> propertyList=new List<Property__c>();
    List<Property_Surrogate__c> propertySurrogates = new List<Property_Surrogate__c>();
    List<Property_Insurer__c> propertyInsurers = new List<Property_Insurer__c>();
    List<Property_Valuation__c> propertyValuations= new List<Property_Valuation__c>();
    List<Property_Insurance__c> propertyInsurances= new List<Property_Insurance__c>();
    if(scope != null && scope.size()>0){
        List<sobject> sobjectList=(List<sobject>)scope;
        for(sobject obj:sobjectList){
           //Processing the Staging Property Records.
            if(apiName=='Staging_Property__c'){
                Staging_Property__c prp = (Staging_Property__c)obj;
                sObject sObj = Schema.getGlobalDescribe().get(stagingTOMainObject.get(Apiname)).newSObject();
                Property__c property=(Property__c)sObj;
                for(String str:fieldstoQuery){
                 property.put(str,prp.get(str));
                }
                if(property.get('Source_Name__c')!=null){
                    if(property.get('Source_Name__c')=='MORTGAGE')
                    property.put('RecordTypeId',mortgageRecordTypeId);
                    if(property.get('Source_Name__c')=='PAF')
                    property.put('RecordTypeId',pafRecordTypeId);
                }
                else{
                 property.put('RecordTypeId',pafRecordTypeId);
                }
                  propertyList.add(property);
            }
            //Processing the Staging Property Surrogates
            if(Apiname == 'StagingProperty_Surrogate__c'){
                StagingProperty_Surrogate__c stagingPropertySurrogate=(StagingProperty_Surrogate__c)obj;
                collect__Loan_Account__c collectioContract = new collect__Loan_Account__c(collect__External_ID__c=(String)stagingPropertySurrogate.LoanSurrogateExternalID__c!=null?stagingPropertySurrogate.LoanSurrogateExternalID__c:' ');
                Property__c propertyReference = new Property__c(Property_External_Id__c=stagingPropertySurrogate.Property_External_Id__c!=null?stagingPropertySurrogate.Property_External_Id__c:' ');
                sObject sObj = Schema.getGlobalDescribe().get(stagingTOMainObject.get(Apiname)).newSObject();
                Property_Surrogate__c pSurrogate =(Property_Surrogate__c)sobj;
                for(String str:fieldstoQuery){
                 if(str.tolowercase()!='ownerid')
                 pSurrogate.put(str,stagingPropertySurrogate.get(str));
                }
                pSurrogate.Loan_Surrogate__r=collectioContract;
                pSurrogate.Property__r=propertyReference;
                PropertySurrogates.add(pSurrogate);
            } 
            //Processing the Staging Property Insurer Records.
            if(Apiname=='Staging_Property_Insurer__c'){
                Staging_Property_Insurer__c stagingPropertyInsurer=(Staging_Property_Insurer__c)obj;
                sObject sObj = Schema.getGlobalDescribe().get(stagingTOMainObject.get(Apiname)).newSObject();
                Property_Insurer__c pInsurer =(Property_Insurer__c)sobj;
                for(String str:fieldstoQuery){
                     pInsurer.put(str,stagingPropertyInsurer.get(str));
                    }
                    propertyInsurers.add(pInsurer);
            }
            //Processing the Staging Property Valuation Records.
            if(Apiname=='Staging_Property_Valuation__c'){
                Staging_Property_Valuation__c stagValuation = (Staging_Property_Valuation__c)obj;
                sObject sObj = Schema.getGlobalDescribe().get(stagingTOMainObject.get(Apiname)).newSObject();
                Property__c prp = new Property__c(Property_External_Id__c=(String)stagValuation.Property_External_Id__c!=null?stagValuation.Property_External_Id__c:' ');
                Property_Valuation__c pValuation=(Property_Valuation__c)sObj;
                for(String str:fieldsToQuery){
                    pValuation.put(str,stagValuation.get(str));
                    }
                    pValuation.Property__r=prp;
                    propertyValuations.add(pValuation);
            }
            //Processing the Staging Property Insurance Records.
            if(Apiname=='Staging_Property_Insurance__c'){
                Staging_Property_Insurance__c stagPropertyInsurance = (Staging_Property_Insurance__c)obj;
                sObject sObj = Schema.getGlobalDescribe().get(stagingTOMainObject.get(Apiname)).newSObject();
                Property__c prp = new Property__c(Property_External_Id__c=(String)stagPropertyInsurance.Property_External_Id__c!=null?stagPropertyInsurance.Property_External_Id__c:' ');
                Property_Insurer__c pInsurer = new Property_Insurer__c(Property_Insurer_External_Id__c=(String)stagPropertyInsurance.Property_Insurer_External_Id__c!=null?stagPropertyInsurance.Property_Insurer_External_Id__c:' ');
                Property_Insurance__c pInsurance=(Property_Insurance__c)sObj;
                 for(String str:fieldsToQuery){
                     if(str.tolowercase()!='ownerid')
                     pInsurance.put(str,stagPropertyInsurance.get(str));
                    }
                    if(stagPropertyInsurance.get('Source_Name__c') != null){
                    if(stagPropertyInsurance.get('Source_Name__c')=='MORTGAGE'){
                    pInsurance.put('RecordTypeId',propertyInsuranceMortgage);
                    }
                    else{
                    pInsurance.put('RecordTypeId',PropertyInsurancePAF);
                    }
                    }
                    else{
                    pInsurance.put('RecordTypeId',propertyInsurancePAF);
                    }
                     pInsurance.Property__r=prp;
                     if(stagPropertyInsurance.Property_Insurer_External_Id__c != null && String.valueof(stagPropertyInsurance.Property_Insurer_External_Id__c)!='')
                     pInsurance.Property_Insurer__r=pInsurer;
                     propertyInsurances.add(pInsurance);
            }
        }
    }
    Schema.SObjectField f;
    if(Apiname=='Staging_Property__c')
    f= Property__c.Fields.Property_External_Id__c;
    if(Apiname=='StagingProperty_Surrogate__c')
    f=Property_Surrogate__c.Fields.Property_SurrogateExternalID__c;
    if(Apiname=='Staging_Property_Insurer__c')
    f=Property_Insurer__c.Fields.Property_Insurer_External_Id__c;
    if(Apiname=='Staging_Property_Valuation__c')
    f=Property_Valuation__c.Fields.Property_Valuation_external_Id__c;
    if(Apiname=='Staging_Property_Insurance__c')
    f=Property_Insurance__c.Fields.Property_Insurance_External_Id__c;
    DataBase.upsertResult[] upsertResultList;
if(propertyList != null && propertyList.size()>0){
    //Upserting the records using externalid's concept.
    upsertResultList = DataBase.upsert(propertyList,f,false);
    }
if(propertySurrogates != null && propertySurrogates.size()>0){
   //Upserting the records using externalid's concept.
    upsertResultList = DataBase.upsert(propertySurrogates,f,false);
}
if(propertyInsurers != null && propertyInsurers.size()>0){
   //Upserting the records using externalid's concept.
    upsertResultList = DataBase.upsert(propertyInsurers,f,false);
}
if(propertyValuations != null && propertyValuations.size()>0){
   //Upserting the records using externalid's concept.
    upsertResultList = DataBase.upsert(propertyValuations,f,false);
}
if(propertyInsurances != null && propertyInsurances.size()>0){
   //Upserting the records using externalid's concept.
    upsertResultList = DataBase.upsert(propertyInsurances,f,false);
}
    Integer  i=0;
    for(DataBase.UpsertResult upsertResult:upsertResultList){
    if(upsertResult.getErrors()!= null && upsertResult.getErrors().size()>0){
    for(DataBase.Error error:upsertResult.getErrors()){
    
    if(errorMessage=='')
    errorMessage='Namewise Errors;';
    if(apiName=='Staging_Property__c'){
    finalString+=propertyList[i].Property_External_Id__c+','+error.getmessage()+'\n';
    errorMessage+=' '+propertyList[i].Property_External_Id__c+'==>'+error.getmessage()+';';
    }
     if(apiName=='StagingProperty_Surrogate__c'){
    finalString+=PropertySurrogates[i].Property_SurrogateExternalID__c+','+error.getmessage()+'\n';
    errorMessage+=' '+PropertySurrogates[i].Property_SurrogateExternalID__c+'==>'+error.getmessage()+';';
    }
    
    if(apiName=='Staging_Property_Insurer__c'){
    finalString+=propertyInsurers[i].Property_Insurer_External_Id__c+','+error.getmessage()+'\n';
    errorMessage+=' '+propertyInsurers[i].Property_Insurer_External_Id__c+'==>'+error.getmessage()+';';
    }
    if(apiName=='Staging_Property_Valuation__c'){
    finalString+=propertyValuations[i].Property_Valuation_external_Id__c+','+error.getmessage()+'\n';
    errorMessage+=' '+propertyValuations[i].Property_Valuation_external_Id__c+'==>'+error.getmessage()+';';
    }
    if(apiName=='Staging_Property_Insurance__c'){
    finalString+=propertyInsurances[i].Property_Insurance_External_Id__c+','+error.getmessage()+'\n';
    errorMessage+=' '+propertyInsurances[i].Property_Insurance_External_Id__c+'==>'+error.getmessage()+';';
    }
    }
    }
    else{
    if(apiName=='Staging_Property__c'){
    if(propertyList[i].Property_External_Id__c != null && String.valueof(propertyList[i].Property_External_Id__c)!='')  
    stagingPropertiesID.add(propertyList[i].Property_External_Id__c);
    }
    if(apiName=='StagingProperty_Surrogate__c'){
    if(PropertySurrogates[i].Property_SurrogateExternalID__c != null && String.valueof(PropertySurrogates[i].Property_SurrogateExternalID__c)!='')  
    stagingPropertySurrogateIDs.add(PropertySurrogates[i].Property_SurrogateExternalID__c);
    }
    if(apiName=='Staging_Property_Insurer__c'){
    if(propertyInsurers[i].Property_Insurer_External_Id__c != null && String.valueof(propertyInsurers[i].Property_Insurer_External_Id__c)!='')  
    stagingPropertiesInsurerIDs.add(propertyInsurers[i].Property_Insurer_External_Id__c);
    }
    if(apiName=='Staging_Property_Valuation__c'){
    if(propertyValuations[i].Property_Valuation_external_Id__c != null && String.valueof(propertyValuations[i].Property_Valuation_external_Id__c)!='')  
    stagingPropertyValuationIds.add(propertyValuations[i].Property_Valuation_external_Id__c);
    }
    if(apiName=='Staging_Property_Insurance__c'){
    if(propertyInsurances[i].Property_Insurance_External_Id__c != null && String.valueof(propertyInsurances[i].Property_Insurance_External_Id__c)!='')  
    stagingPropertyInsuranceIds.add(propertyInsurances[i].Property_Insurance_External_Id__c);
    }
    }
    i=i+1;
    }
    //Deleting the records from staging which are successfully synced.
    if(stagingPropertiesID!=null && stagingPropertiesID.size()>0)
    delete [Select id,Property_External_Id__c from Staging_Property__c where Property_External_Id__c in:stagingPropertiesID];
    if(stagingPropertiesInsurerIDs != null && stagingPropertiesInsurerIDs.size()>0)
    delete [Select id,Property_Insurer_External_Id__c from Staging_Property_Insurer__c where Property_Insurer_External_Id__c in:stagingPropertiesInsurerIDs];
    if(stagingPropertyValuationIds!= null && stagingPropertyValuationIds.size()>0)
    delete [Select id,Property_Valuation_external_Id__c from Staging_Property_Valuation__c where Property_Valuation_external_Id__c in:stagingPropertyValuationIds];
    if(stagingPropertyInsuranceIds!=null && stagingPropertyInsuranceIds.size()>0)
    delete [Select id,Property_Insurance_External_Id__c from Staging_Property_Insurance__c where Property_Insurance_External_Id__c in:stagingPropertyInsuranceIds];
    if(stagingPropertySurrogateIDs != null && stagingPropertySurrogateIDs.size()>0)
    delete [Select id,Property_SurrogateExternalID__c from StagingProperty_Surrogate__c where Property_SurrogateExternalID__c in:stagingPropertySurrogateIDs];
    
    List<COCSyncError__c> cocSyncErrors = new List<COCSyncError__c>();
    String type='';
    if(apiName=='Staging_Property__c')
    type='Property';
    if(apiName=='StagingProperty_Surrogate__c')
    type='Property/Surrogate';
    if(apiName=='Staging_Property_Insurer__c')
    type='Property Insurer';
    if(apiName=='Staging_Property_Valuation__c')
    type='Property Valuation';
    if(apiName=='Staging_Property_Insurance__c')
    type='Property Insurance';
    //Generating htmlbody for sending the EmailMessage to  the particular email address.
    String htmlBody='<html>'+'<body>'+'Please find the attached list of '+Apiname+' '+'error files.'+'</body>'+'</html>';
    If(errorMessage != ''){
        Messaging.EmailFileAttachment eAttachment = new Messaging.EmailFileAttachment();
        eAttachment.setFileName(Apiname+'.csv');
        eAttachment.setcontentType('text/csv');
        eAttachment.setBody(Blob.valueof(finalString));
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSubject(''+Apiname+' '+'Sync Errors');
        msg.setHtmlBody(htmlbody);
        msg.setToAddresses(new String[]{Label.COCSyncErrorEmail});
        msg.setFileAttachments(new Messaging.EmailFileAttachment[]{eAttachment});
        Messaging.Sendemail(new Messaging.SingleEmailMessage[]{msg});
            system.debug('}}}}}}}}'+errormessage.length());
            while(errorMessage.length()>50000){
                    system.debug('131072sezaada'+errorMessage.substring(0,50000).length());
                    COCSyncError__c syncError = new COCSyncError__c(DataSyncDate_Time__c=system.now(),ErrorMessages__c=errormessage.substring(0,50000),SyncType_del__c=type);
                    cocSyncerrors.add(syncError);
                    errorMessage=errormessage.substring(50000,errormessage.length());
                }
                system.debug('errormessage'+errormessage.length());
                COCSyncError__c syncError = new COCSyncError__c(DataSyncDate_Time__c=system.now(),ErrorMessages__c=errormessage,SyncType_del__c=type);
                cocSyncerrors.add(syncError);
      
        if(cocSyncerrors!=null && cocSyncerrors.size()>0)
        insert cocSyncerrors;
    }
    
}
Global void finish(Database.batchableContext Bcontext){
    //Sending Email if any failure occurs in Batch Processing.
            asyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus
            from asyncApexJob where Id = :Bcontext.getJobId()];
  
             // Email the COC Automatic Notification failure's if any to the .
             if(a.numberOfErrors!= null && a.numberOfErrors>0){
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             List<String> toAddresses = new List<String>();
             for(String str:Label.AutomaticNotificationFailureEmails.split(',')){
             toAddresses.add(str);
             }
             mail.setToAddresses(toAddresses);
             mail.setSubject('Collateral Sync batch Status: ' + a.Status);
             mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
              ' batches with '+ a.NumberOfErrors + ' failures.' + 'for'+' ' +Apiname+' '+'Sync');
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
             } 
    if(apiName=='Staging_Property__c'){
    CocSync Sync = new CocSync('StagingProperty_Surrogate__c');
    DataBase.executeBatch(Sync,Integer.valueof(Label.CocBatchSize));
    }
    
    if(Apiname=='StagingProperty_Surrogate__c'){
    CocSync Sync = new CocSync('Staging_Property_Insurer__c');
    DataBase.executeBatch(Sync,Integer.valueof(Label.CocBatchSize));
    }
    if(apiName=='Staging_Property_Insurer__c'){
    CocSync Sync = new CocSync('Staging_Property_Valuation__c');
    DataBase.executeBatch(Sync,Integer.valueof(Label.CocBatchSize));
    }
    if(apiName=='Staging_Property_Valuation__c'){
    CocSync Sync = new CocSync('Staging_Property_Insurance__c');
    DataBase.executeBatch(Sync,Integer.valueof(Label.CocBatchSize));
    }
              
}
}