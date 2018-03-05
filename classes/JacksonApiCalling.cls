Global Class JacksonApiCalling{

Webservice static string submitLetterInvocation(ID insuranceID){
set<id> insuranceIds = new set<id>();
insuranceIds.add(insuranceID);
if(checkValidity(insuranceIds,insuranceIds,'PropertyInsurance')=='true'){
InsuranceEmailToCaseManagement.writingLetterDetails(insuranceIds);
return 'true';
}
else{
return 'false';
}
}
Webservice static String submitDiaryNote(ID diaryNoteID){
    set<id> diaryNotesid= new set<id>();
    set<id> propertyInsuranceids = new set<id>();
    diaryNotesid.add(diaryNoteID);
    for(Diary_Notes__c  drn:[Select id,Property_Insurance__c from Diary_Notes__c where id in:diaryNotesid]){
           if(drn.Property_Insurance__c != null)
           propertyInsuranceids.add(drn.Property_Insurance__c);
          }
          if(checkValidity(propertyInsuranceids,diaryNotesid,'DiaryNote')=='true'){
    PropertyInsuranceHandling.writebacktoJackson(diaryNotesid);
    return 'true';
    }
    else{
    return 'false';
    }
}
Private static string checkValidity(set<ID> propertyInsuranceids,set<ID> diaryorInsuranceIds,string entity){
set<Id> propertyIds = new set<Id>();
Map<Id,Id> propertyInsuranceToProperty = new Map<Id,Id>();
Map<Id,List<String>> PropertyIDtosurrogates = new Map<Id,List<String>>();
if(propertyInsuranceids != null && propertyInsuranceids.size()>0){
          List<Property_Insurance__c> propertyInsurances = [Select id,Property__c from Property_Insurance__c where id in:propertyInsuranceids];
          for(Property_Insurance__c prp:propertyInsurances){
              if(prp.Property__c !=null){
              propertyIds.add(prp.Property__c);
              propertyInsuranceToProperty.put(prp.id,prp.Property__c);
              }   
          }
          if(propertyIds != null && propertyIds.size()>0){
                    
                    List<Property_Surrogate__c> propertySurrogates =[Select id,Property__c,Property__r.Property_Unit_House_Number__c,Property__r.Property_Street__c,Property__r.Property_Suburb_Town__c,Property__r.Property_State__c,Property__r.Property_PostCode__c,Loan_Surrogate__r.collect__Account__c,Loan_Surrogate__r.collect__Account__r.isPersonAccount,Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone,Loan_Surrogate__r.collect__Contact__c,Loan_Surrogate__r.ScCollection_Lender_Record__c,Loan_Surrogate__r.collect__Loan_Status__c,Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c,Loan_Surrogate__r.collect__Contact__r.MobilePhone,Loan_Surrogate__r.collect__External_ID__c,Registration_Status__c,DWH_Registration_date__c from Property_Surrogate__c where Property__c in:propertyIds and Registration_Status__c='R' and Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c not in:StatusTOExcludeForCOC__c.getall().keyset() and Loan_Surrogate__r.ScCollection_Lender_Record__c in:LenderRecordsForCOC__c.getall().keyset()  order BY DWH_Registration_date__c DESC];
                    
                    if(propertySurrogates != null && propertySurrogates.size()>0){
                        for(Property_Surrogate__c prp:propertySurrogates){
                            if(!PropertyIDtosurrogates.containskey(prp.Property__c))
                            PropertyIDtosurrogates.put(prp.Property__c,new List<string>());
                            if(prp.Loan_Surrogate__r.collect__External_ID__c.contains(':') && prp.Loan_Surrogate__r.collect__External_ID__c.contains('_'))
                            PropertyIDtosurrogates.get(prp.Property__c).add(prp.Loan_Surrogate__r.collect__External_ID__c.substring(prp.Loan_Surrogate__r.collect__External_ID__c.indexof(':')+1,prp.Loan_Surrogate__r.collect__External_ID__c.indexof('_')));
                       }
                }
            }
         }
         if(entity=='DiaryNote'){
         for(Diary_Notes__c drn:[Select id,Property_Insurance__c from Diary_Notes__c where id in:diaryorInsuranceIds]){
         if(propertyInsuranceToProperty.containskey(drn.Property_Insurance__c)){
          if(!PropertyIDtosurrogates.containskey(propertyInsuranceToProperty.get(drn.Property_Insurance__c)))
          return 'false';
         }
        }
       }
       else{
       for(Property_Insurance__c propInsurance:[Select id,Property__c from Property_Insurance__c where id in:propertyInsuranceids]){
        if(propertyInsuranceToProperty.containskey(propInsurance.id)){
          if(!PropertyIDtosurrogates.containskey(propertyInsuranceToProperty.get(propInsurance.id)))
          return 'false';
       }
       }
       }
        return 'true';
}
Webservice static void updateError(string apilog,string entity,ID recordID){
string username = PropertyInsuranceCredentials__c.getinstance('Credentials').Username__c;
string password = PropertyInsuranceCredentials__c.getinstance('Credentials').Password__c;
string endpoint = PropertyInsuranceCredentials__c.getinstance('Credentials').Endpoint__c;
Http http = new http();
Httprequest req = new Httprequest();
req.setHeader('Content-Type','application/json');
req.setHeader('Accept','application/json');
req.setendpoint(endpoint+'/errors/v2?apiLog='+apiLog);
req.setmethod('GET');
req.setTimeout(120000);
req.setHeader('Authorization','Basic '+Encodingutil.base64encode(Blob.valueof(username+':'+password)));
Httpresponse response=http.send(req);
if(response.getstatuscode()==200){
             string jsonbody=response.getbody();
            
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
               if(deserealisedResponse.APIStatus.Messages[0].Message.MessageCode=='200'){
                   if(entity=='Insurance'){
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=recordId,ESB_API_Success_Error_Message__c=deserealisedResponse.APIStatus.Apiresponse);
                   update pInsurance;
                   }
                   else if(entity=='Letter'){
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=recordId,Letter_Generation_Success_Error_Message__c=deserealisedResponse.APIStatus.Apiresponse);
                   update pInsurance;
                   }
                  else{
                   Diary_Notes__c drn = new Diary_Notes__c(id=recordID,ESB_API_Success_Error_Message__c=deserealisedResponse.APIStatus.Apiresponse);
                   update drn;
                   }
                 }
                  else{
                        if(entity=='Insurance'){
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=recordId,ESB_API_Success_Error_Message__c='There is some problem with apiLog API.');
                   update pInsurance;
                   }
                   else if(entity=='Letter'){
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=recordId,Letter_Generation_Success_Error_Message__c='There is some problem with apiLog API.');
                   update pInsurance;
                   }
                  else{
                   Diary_Notes__c drn = new Diary_Notes__c(id=recordID,ESB_API_Success_Error_Message__c='There is some problem with apiLog API.');
                   update drn;
                   }                
              }
            }
            else{
                 if(entity=='Insurance'){
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=recordId,ESB_API_Success_Error_Message__c='There is some problem with apiLog API.');
                   update pInsurance;
                   }
                   else if(entity=='Letter'){
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=recordId,Letter_Generation_Success_Error_Message__c='There is some problem with apiLog API.');
                   update pInsurance;
                   }
                  else{
                   Diary_Notes__c drn = new Diary_Notes__c(id=recordID,ESB_API_Success_Error_Message__c='There is some problem with apiLog API.');
                   update drn;
                   }          
            }
}
}