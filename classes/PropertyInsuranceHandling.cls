Public Class  PropertyInsuranceHandling{

//Method to update Insurance details on ESB
    Public void updateInuranceDetailsonESB(string propertyInsuranceId,List<string> loanNumber,string propertyNumber,Date InsuranceExpiryDate,string insurerId,string insurancePolicyNo,string propertyAmountInsured,string propertyReplaceSqMtrs,string publicLiabilityCover,string insurancePremium,string insuranceType){
        
        String ApiLog;
        string expiryDate='';
        string username = PropertyInsuranceCredentials__c.getinstance('Credentials').Username__c;
        string password = PropertyInsuranceCredentials__c.getinstance('Credentials').Password__c;
        string endpoint = PropertyInsuranceCredentials__c.getinstance('Credentials').Endpoint__c;
        if(InsuranceExpiryDate != null && string.valueof(InsuranceExpiryDate) != '' && String.valueof(InsuranceExpiryDate).contains('-'))
        expiryDate=string.valueof(InsuranceExpiryDate).split('-')[0]+string.valueof(InsuranceExpiryDate).split('-')[1]+string.valueof(InsuranceExpiryDate).split('-')[2]; 
        //Creating Http request to the ESB API to pass the insurance details.
        Http http = new http();
        Httprequest req = new Httprequest();
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');
        req.setendpoint(endpoint+'/loan/property/insurance/v2');
        req.setmethod('POST');
        req.setTimeout(120000);
        req.setHeader('Authorization','Basic '+Encodingutil.base64encode(Blob.valueof(username+':'+password)));
        Jsongenerator jsg = Json.CreateGenerator(True);
        jsg.writestartobject();
        jsg.writestringfield('countryCode','AU');
        jsg.writestringfield('lob','mortgage');
        jsg.writestringfield('loanNumber',loanNumber!=null&&loanNumber.size()>0?loanNumber[0]:'');
        jsg.writestringfield('propertyNumber',propertyNumber!=null?propertyNumber:'');
        jsg.writestringfield('insuranceExpiryDate',expiryDate!=null?expiryDate:'');
        jsg.writestringfield('insurerId',insurerId!=null?insurerId:'');
        jsg.writestringfield('insurancePolicyNo',insurancePolicyNo!=null?insurancePolicyNo:'');
        jsg.writestringfield('propertyAmountInsured',propertyAmountInsured!=null?propertyAmountInsured:'');
        jsg.writestringfield('propertyReplaceSqMtrs',propertyReplaceSqMtrs!=null?propertyReplaceSqMtrs:'');
        jsg.writestringfield('publicLiabilityCover',publicLiabilityCover!=null?publicLiabilityCover:'');
        jsg.writestringfield('insurancePremium',insurancePremium!=null?insurancePremium:'');
        jsg.writestringfield('insuranceType',insuranceType!=null?insuranceType:'');
        jsg.writestringfield('sfPropertyValuationId',propertyInsuranceId!=null?string.valueof(propertyInsuranceId):'');
        jsg.writestringfield('usernEmailAddress',userinfo.getuseremail());//pepperesb@pepper.com.au
        jsg.writeendobject();
        system.debug('@@@@@@@@@@'+jsg.getasString());
        req.setbody(jsg.getasString());
        try{
        
          
            Httpresponse response =http.send(req);
            System.debug('responseDebug'+response);
            if(response.getstatuscode()==200){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
               if(deserealisedResponse.APIStatus.Messages[0].Message.MessageCode=='200'){
                  Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,ESB_API_Success_Error_Message__c=deserealisedResponse.APIStatus.Messages[0].Message.MessageDescription,Details_Sent_To_ESB__c=True,Insurance_API_Log__c=null);
                  update pInsurance;
                  }
            }
            else if(response.getstatuscode()==500 || response.getstatuscode()==401){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
             List<cls_PepperReferences> pepperreferenceslist =deserealisedResponse.APIStatus.PepperReferences;
                       if(pepperreferenceslist != null && pepperreferenceslist.size()>0){
                            for(cls_PepperReferences reference1:pepperreferenceslist){
                                  if(reference1.Pepperreference.ReferenceType=='apiLog'){
                                  ApiLog=reference1.Pepperreference.Reference;
                                  break;
                                  }
                             }
                        } 
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,ESB_API_Success_Error_Message__c='Please use the button Insurance Updation Error to recieve Proper Error.',Details_Sent_To_ESB__c=False,Insurance_API_Log__c=ApiLog,status__c='Open');
                         update pInsurance;
                  }
            else{
                 Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,ESB_API_Success_Error_Message__c='Unknown Exception',Details_Sent_To_ESB__c=False,Insurance_API_Log__c=null,status__c='Open');
                 update pInsurance;
            }
      }
      Catch(Exception ex){
         
          Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,ESB_API_Success_Error_Message__c=ex.getMessage(),Details_Sent_To_ESB__c=False,Insurance_API_Log__c=null,status__c='Open');
          update pInsurance;
          
      }  
}

//Method to insert Diary Notes on ESB
    @Future(Callout=True)
    Public static void insertDiaryNotes(List<string> loanNumber,string usernEmailAddress,string notes,string sfLoanNotesId){
        string ApiLog;
        string username = PropertyInsuranceCredentials__c.getinstance('Credentials').Username__c;
        string password = PropertyInsuranceCredentials__c.getinstance('Credentials').Password__c;
        string endpoint = PropertyInsuranceCredentials__c.getinstance('Credentials').Endpoint__c;
        
        //Creating Http request to the ESB API to pass the comment entered by Support Officer.
        Http http = new http();
        Httprequest req = new Httprequest();
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');
        req.setendpoint(endpoint+'/loan/diarynotes/v2');
        req.setmethod('POST');
        req.setTimeout(120000);
        req.setHeader('Authorization','Basic '+Encodingutil.base64encode(Blob.valueof(username+':'+password)));
        Jsongenerator jsg = Json.CreateGenerator(True);
        jsg.writestartobject();
        jsg.writestringfield('countryCode','AU');
        jsg.writestringfield('lob','mortgage');
        jsg.writestringfield('loanNumber',loanNumber!=null&&loanNumber.size()>0?loanNumber[0]:'');
        jsg.writestringfield('usernEmailAddress',usernEmailAddress!=null?usernEmailAddress:'');
        if(notes!=null){
        if(notes.contains('\n'))
        notes=notes.replaceall('\n','');
        if(notes.contains('\r'))
        notes=notes.replaceall('\r','');
        }
        jsg.writestringfield('notes',notes!=null?notes:'');
        jsg.writestringfield('sfLoanNotesId',sfLoanNotesId!=null?sfLoanNotesId:'');
        jsg.writeendobject();
        req.setbody(jsg.getasString());
        try{
            system.debug('8888888888'+jsg.getasString());
            Httpresponse response =http.send(req);
            System.debug('responseDebug'+response.getbody());
            if(response.getstatuscode()==200){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
               if(deserealisedResponse.APIStatus.Messages[0].Message.MessageCode=='200'){
                  Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c=deserealisedResponse.APIStatus.Messages[0].Message.MessageDescription,Submitted_to_ESB__c=True,Api_Log__c=null);
                        update diaryNotes;
                  }
            }
            else if(response.getstatuscode()==500 || response.getstatuscode()==401){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
             List<cls_PepperReferences> pepperreferenceslist =deserealisedResponse.APIStatus.PepperReferences;
                       if(pepperreferenceslist != null && pepperreferenceslist.size()>0){
                            for(cls_PepperReferences reference1:pepperreferenceslist){
                                  if(reference1.Pepperreference.ReferenceType=='apiLog'){
                                  ApiLog=reference1.Pepperreference.Reference;
                                  break;
                                  }
                             }
                        } 
                     Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c='Please use the Diary Note Creation error to get exact error.',Submitted_to_ESB__c=False,Api_Log__c=ApiLog);
                     update diaryNotes;
                  }
            else{
                 Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c='Unknown Exception',Submitted_to_ESB__c=False,Api_Log__c=null);
                 update diaryNotes;
            }
      }
      Catch(Exception ex){
  
          Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c=ex.getMessage(),Submitted_to_ESB__c=False,Api_Log__c=null);
          update diaryNotes;
          
      }  
}
//Method to invoke  Letter Generation on ESB
    //@Future(Callout=True)
    Public static void invokeLetterGeneration(List<string> loanNumber,string propertyNumber,string propertyInsuranceId){
        string ApiLog;
        string username = PropertyInsuranceCredentials__c.getinstance('Credentials').Username__c;
        string password = PropertyInsuranceCredentials__c.getinstance('Credentials').Password__c;
        string endpoint = PropertyInsuranceCredentials__c.getinstance('Credentials').Endpoint__c;
        //Creating Http request to the ESB API to pass the comment entered by Support Officer.
        Http http = new http();
        Httprequest req = new Httprequest();
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');
        req.setendpoint(endpoint+'/loan/lettergeneration/v2');
        req.settimeout(120000);
        req.setmethod('POST');
        req.setHeader('Authorization','Basic '+Encodingutil.base64encode(Blob.valueof(username+':'+password)));
        Jsongenerator jsg = Json.CreateGenerator(True);
        jsg.writestartobject();
        jsg.writestringfield('countryCode','AU');
        jsg.writestringfield('lob','mortgage');
        jsg.writestringfield('loanNumber',loanNumber!=null&&loanNumber.size()>0?loanNumber[0]:'');
        jsg.writestringfield('propertyNumber',propertyNumber!=null?propertyNumber:'');
        jsg.writestringfield('usernEmailAddress',Label.JacksonGenericEmail);
        jsg.writestringfield('sfPropertyValuationId',propertyInsuranceId!=null?string.valueof(propertyInsuranceId):'');
        jsg.writeendobject();
        system.debug(jsg.getasString());
        req.setbody(jsg.getasString());
         try{
            
            Boolean callErrorMessage=false;
            Httpresponse response =http.send(req);
            System.debug('responseDebug'+response);
            if(response.getstatuscode()==200){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
               if(deserealisedResponse.APIStatus.Messages[0].Message.MessageCode=='200'){
                  Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,Letter_Generation_Success_Error_Message__c=deserealisedResponse.APIStatus.Messages[0].Message.MessageDescription,Letter_Generation_Submitted__c=True,Letter_Generation_API_Log__c=null);
                   update pInsurance;
                  }
            }
            else if(response.getstatuscode()==500 || response.getstatuscode()==401){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
             List<cls_PepperReferences> pepperreferenceslist =deserealisedResponse.APIStatus.PepperReferences;
                       if(pepperreferenceslist != null && pepperreferenceslist.size()>0){
                            for(cls_PepperReferences reference1:pepperreferenceslist){
                                  
                                  if(reference1.Pepperreference.ReferenceType=='apiLog'){
                                  ApiLog=reference1.Pepperreference.Reference;
                                  break;
                                  }
                             }
                        }
                     
                   Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,Letter_Generation_Success_Error_Message__c=deserealisedResponse.APIStatus.Messages[0].Message.MessageDescription,Letter_Generation_Submitted__c=False,Letter_Generation_API_Log__c=ApiLog);
                   update pInsurance;
                   
            }
            else{
                 Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,Letter_Generation_Success_Error_Message__c='Unknown Exception',Letter_Generation_Submitted__c=False,Letter_Generation_API_Log__c=null);
                 update pInsurance;
            }
      }
      Catch(Exception ex){
         
          Property_Insurance__c pInsurance = new Property_Insurance__c(id=propertyInsuranceId,Letter_Generation_Success_Error_Message__c=ex.getMessage(),Letter_Generation_Submitted__c=False,Letter_Generation_API_Log__c=null);
          update pInsurance;
          
      } 
}
Public class Apiresponse{
    public cls_APIStatus APIStatus;
   }
  public class cls_APIStatus{
        public String APICode;  //INFO
        public String APIDescription;   //Success Response
        Public String APIResponse;
        public List<cls_ClientReferences> ClientReferences;
        Public List<cls_PepperReferences> PepperReferences;
        public List<cls_Messages> Messages;
    }
    Public class cls_PepperReferences{
    Public cls_PepperReference PepperReference;
    }
    Public class cls_PepperReference{
    Public string ReferenceType;
    Public String Reference;
    }
     public class cls_ClientReferences {
        public cls_ClientReference ClientReference;
    }
     public class cls_ClientReference {
        public String ReferenceType;    //Reference Id
        public String Reference;    //aa72b6c0-ad12-11e6-ab72-fe0f20524153
    }
     public class cls_Messages {
        public cls_Message Message;
    }
     public class cls_Message {
        public String MessageCode;  //INFO
        public String MessageId;    //200
        public String MessageDescription;   //Request processed successfully
    }
    //Method to assosciate the Diary Note with the Collection contract.
    Public static void loanContractAssignment(List<Diary_Notes__c> diaryNotes){
    set<id> propertyInsuranceids = new set<id>();
    set<Id> propertyIds = new set<Id>();
    Map<Id,Id> propertyInsuranceToProperty = new Map<Id,Id>();
    Map<Id,List<String>> PropertyIDtosurrogates = new Map<Id,List<String>>();
    for(Diary_Notes__c  drn:diaryNotes){
       if(drn.Property_Insurance__c != null)
       propertyInsuranceids.add(drn.Property_Insurance__c);
      }
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
         for(Diary_Notes__c drn:diarynotes){
         if(propertyInsuranceToProperty.containskey(drn.Property_Insurance__c) && drn.Invoked_From_batch__c==false){
          if(!PropertyIDtosurrogates.containskey(propertyInsuranceToProperty.get(drn.Property_Insurance__c)))
          drn.addError('Property is not registered or Loan Contract is not active or Property is not related to the COC Lenders.');
         }
        }

    }
    //Method to call api for writing back the notes to Jackson.
   
    Public static void writebacktoJackson(set<ID> diaryNotesID){
        set<id> diaryNotes = new set<id>();
        set<Id> propertyIds = new set<Id>();
        Map<id,List<String>> PropertyIDtosurrogates = new Map<id,List<String>>();
        diaryNotes.addall(diaryNotesID);
        List<Diary_Notes__c> diaryNotesList =[Select id,Property_Insurance__r.Property__c,Automated__c,Invoked_From_Batch__c from Diary_Notes__c where id in:diaryNotes];
        if(diaryNotesList != null && diaryNotesList.size()>0){
        for(Diary_Notes__c drn:diaryNotesList){
         if(drn.Property_Insurance__r.Property__c != null && drn.Invoked_From_Batch__c==false)
         propertyIds.add(drn.Property_Insurance__r.Property__c);
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
        List<Property_Insurance__c> propertyInsurances = new List<Property_Insurance__c>();
        
        for(Diary_Notes__c drn:[Select id,Source_Name__c,Property_Insurance__r.Property__c,Comment__c,Automated__c,Property_Insurance__c,Type__c,Invoked_From_Batch__c from Diary_Notes__c where id in:diaryNotes]){
                if(drn.Source_Name__c=='MORTGAGE' && PropertyIDtosurrogates.containskey(drn.Property_Insurance__r.Property__c) && drn.Invoked_From_Batch__c==false)
                PropertyInsuranceHandling.insertDiaryNotes(PropertyIDtosurrogates.get(drn.Property_Insurance__r.Property__c),drn.Automated__c==True?Label.JacksonGenericEmail:userinfo.getuseremail(),drn.Comment__c,string.valueof(drn.id));
                if(drn.Property_Insurance__c != null && drn.Type__c=='Call Created'){
                    Property_Insurance__c pri = new Property_Insurance__c(id=drn.Property_Insurance__c,Call_Created__c=True);
                    propertyInsurances.add(pri);
                }
              }   
              if(propertyInsurances != null && propertyInsurances.size()>0)
              update propertyInsurances;
        }
        
   Public static void insertDiaryNotesfromBatch(List<string> loanNumber,string usernEmailAddress,string notes,string sfLoanNotesId){
        string ApiLog;
        string username = PropertyInsuranceCredentials__c.getinstance('Credentials').Username__c;
        string password = PropertyInsuranceCredentials__c.getinstance('Credentials').Password__c;
        string endpoint = PropertyInsuranceCredentials__c.getinstance('Credentials').Endpoint__c;
        
        //Creating Http request to the ESB API to pass the comment entered by Support Officer.
        Http http = new http();
        Httprequest req = new Httprequest();
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept','application/json');
        req.setendpoint(endpoint+'/loan/diarynotes/v2');
        req.setmethod('POST');
        req.setTimeout(120000);
        req.setHeader('Authorization','Basic '+Encodingutil.base64encode(Blob.valueof(username+':'+password)));
        Jsongenerator jsg = Json.CreateGenerator(True);
        jsg.writestartobject();
        jsg.writestringfield('countryCode','AU');
        jsg.writestringfield('lob','mortgage');
        jsg.writestringfield('loanNumber',loanNumber!=null&&loanNumber.size()>0?loanNumber[0]:'');
        
        jsg.writestringfield('usernEmailAddress',usernEmailAddress!=null?usernEmailAddress:'');
        if(notes!=null){
        if(notes.contains('\n'))
        notes=notes.replaceall('\n','');
        if(notes.contains('\r'))
        notes=notes.replaceall('\r','');
        }
        jsg.writestringfield('notes',notes!=null?notes:'');
        jsg.writestringfield('sfLoanNotesId',sfLoanNotesId!=null?sfLoanNotesId:'');
        jsg.writeendobject();
        req.setbody(jsg.getasString());
        try{
            system.debug('8888888888'+jsg.getasString());
            Httpresponse response =http.send(req);
            System.debug('responseDebug'+response.getbody());
            if(response.getstatuscode()==200){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
               if(deserealisedResponse.APIStatus.Messages[0].Message.MessageCode=='200'){
                  Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c=deserealisedResponse.APIStatus.Messages[0].Message.MessageDescription,Submitted_to_ESB__c=True,Api_Log__c=null);
                        update diaryNotes;
                  }
            }
            else if(response.getstatuscode()==500 || response.getstatuscode()==401){
             string jsonbody=response.getbody();
             system.debug('@@@@@@'+jsonbody);
             PropertyInsuranceHandling.Apiresponse deserealisedResponse=(PropertyInsuranceHandling.Apiresponse)System.Json.deserialize(jsonbody,PropertyInsuranceHandling.Apiresponse.class);
             List<cls_PepperReferences> pepperreferenceslist =deserealisedResponse.APIStatus.PepperReferences;
                       if(pepperreferenceslist != null && pepperreferenceslist.size()>0){
                            for(cls_PepperReferences reference1:pepperreferenceslist){
                                  if(reference1.Pepperreference.ReferenceType=='apiLog'){
                                  ApiLog=reference1.Pepperreference.Reference;
                                  break;
                                  }
                             }
                        } 
                     Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c='Please use the Diary Note Creation error to get exact error.',Submitted_to_ESB__c=False,Api_Log__c=ApiLog);
                     update diaryNotes;
                  }
            else{
                 Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c='Unknown Exception',Submitted_to_ESB__c=False,Api_Log__c=null);
                 update diaryNotes;
            }
      }
      Catch(Exception ex){
  
          Diary_Notes__c diaryNotes = new Diary_Notes__c(id=sfLoanNotesId,ESB_API_Success_Error_Message__c=ex.getMessage(),Submitted_to_ESB__c=False,Api_Log__c=null);
          update diaryNotes;
          
      }  
}
Public static void preventUpdate(Map<Id,Diary_Notes__c> oldMap,Map<Id,Diary_Notes__c> newMap){
for(Id drn:Trigger.newMap.Keyset()){
if((oldMap.get(drn).Comment__c !=newMap.get(drn).Comment__c) || (oldMap.get(drn).Property_Insurance__c != newMap.get(drn).Property_Insurance__c) || (oldMap.get(drn).Source_Name__C!= newMap.get(drn).Source_Name__c) ||(oldMap.get(drn).Type__c!= newMap.get(drn).Type__c))
newMap.get(drn).addError('Diary Note can\'t be edited.');
}
} 
  
}