Public Class InsuranceEmailToCaseManagement{
     //Method to have the Expiry Date in A.M format and to have the mobile number to use in the SMS Magic App.
    Public static void updateExpiryDateTime(List<Property_Insurance__c> newList,Boolean isInsert,Map<Id,Property_Insurance__c> newmap,Map<id,Property_Insurance__c> oldmap){
            set<id> cocTeamMemberIds = new set<id>();
            set<id> propertids = new set<id>();
            Map<id,string> propertyTonumber = new Map<id,string>();
            Map<id,string> propertyIdtoAddress = new Map<id,string>();
            Map<id,string> propertyTooriginatorID = new Map<id,string>();
            Map<id,string> propertyIdtoOriginatorShortname = new Map<id,string>();
            Map<id,String> propertyToMortgageFunding = new Map<id,string>();
            Map<id,String> propertyToRiskentity = new Map<id,String>();
            Map<id,String> propertyToLoanNumber = new Map<id,String>();
            Map<id,List<Property_Surrogate__c>> PropertyIDtosurrogates= new Map<id,List<Property_Surrogate__c>>();
            List<GroupMember> cocTeamMembersList =[Select id,UserOrGroupId from GroupMember where Group.DeveloperName='COC_Team'];
            if(cocTeamMembersList != null && cocTeamMembersList.size()>0){
            for(GroupMember member:cocTeamMembersList){
            cocTeamMemberIds.add(member.UserorGroupId);
            }
            }
            List<Group> allowedQueues=[Select id from Group where (DeveloperName='Sydney_Queue' OR DeveloperName ='UnAllocated_Insurance') and Type='Queue'];
            if(allowedQueues!= null && allowedQueues.size()>0){
            for(Group grp:allowedQueues){
            cocTeamMemberIds.add(grp.Id);
            }
            }
            
                  
            for(Property_Insurance__c buildExp:newList){
                 if(buildExp.Source_Name__c=='MORTGAGE'){
                    if(buildExp.DWH_Propert_Ins_Exp_Date__c != null){
                        DateTime dt =DateTime.newinstance(buildExp.DWH_Propert_Ins_Exp_Date__c.year(),buildExp.DWH_Propert_Ins_Exp_Date__c.month(),buildExp.DWH_Propert_Ins_Exp_Date__c.day(),8,0,0);
                        buildExp.Expiry_Date_Time__c=dt;
                        if(buildExp.Status__c==null)
                        buildExp.Status__c='Open';
                        if(buildExp.Insurance_Premium__c==null)
                        buildExp.Insurance_Premium__c=0;
                    }
                    if(buildExp.Property__c != null)
                    propertids.add(buildExp.Property__c);
                }   
            }
            
            if(propertids != null && propertids.size()>0){
                List<Property_Surrogate__c> propertySurrogates;
                
                propertySurrogates =[Select id,Loan_Surrogate__r.collect__External_ID__c,Loan_Surrogate__r.collect__Account__r.name,Loan_Surrogate__r.collect__Contact__r.name,Property__c,Property__r.Property_Unit_House_Number__c,Property__r.Property_Street__c,Property__r.Property_Suburb_Town__c,Property__r.Property_State__c,Property__r.Property_PostCode__c,Loan_Surrogate__r.collect__Account__c,Loan_Surrogate__r.collect__Account__r.isPersonAccount,Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone,Loan_Surrogate__r.collect__Contact__c,Loan_Surrogate__r.ScCollection_Lender_Record__c,Loan_Surrogate__r.collect__Loan_Status__c,Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c,Loan_Surrogate__r.collect__Contact__r.MobilePhone,Registration_Status__c,DWH_Registration_date__c,Loan_Surrogate__r.ScCollection_Originator_ID__c,Loan_Surrogate__r.ScCollection_Originator_Short_Name__c,Loan_Surrogate__r.ScCollection_Mortgage_Funding__c from Property_Surrogate__c where Property__c in:propertids and Registration_Status__c='R' and Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c not in:StatusTOExcludeForCOC__c.getall().keyset() and Loan_Surrogate__r.ScCollection_Lender_Record__c in:LenderRecordsForCOC__c.getall().keyset()  order BY DWH_Registration_date__c DESC];
               
                system.debug('LLLLL'+LenderRecordsForCOC__c.getall().keyset());
                set<Id> processesProperties = new set<Id>();
                if(propertySurrogates != null && propertySurrogates.size()>0){
                for(Property_Surrogate__c prp:propertySurrogates){
                if(!PropertyIDtosurrogates.containskey(prp.Property__c))
                PropertyIDtosurrogates.put(prp.Property__c,new List<Property_Surrogate__c>());
                PropertyIDtosurrogates.get(prp.Property__c).add(prp);
                if(!processesProperties.contains(prp.Property__c)){
                string originatorid='';
                string originatorshortName='';
                string propertyAddress='';
                propertyAddress+=prp.Property__r.Property_Unit_House_Number__c!=null?prp.Property__r.Property_Unit_House_Number__c+ ' ':'';
                propertyAddress+=prp.Property__r.Property_Street__c!=null?prp.Property__r.Property_Street__c+',':'';
                propertyAddress+=prp.Property__r.Property_Suburb_Town__c!=null?prp.Property__r.Property_Suburb_Town__c+' ':'';
                propertyAddress+=prp.Property__r.Property_State__c!=null?prp.Property__r.Property_State__c+' ':'';
                propertyAddress+=prp.Property__r.Property_PostCode__c!=null?prp.Property__r.Property_PostCode__c:'';
                propertyIdtoAddress.put(prp.Property__c,propertyAddress);
                if(prp.Loan_Surrogate__r.collect__Account__c != null && prp.Loan_Surrogate__r.collect__Account__r.isPersonAccount==TRUE && prp.Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone != null && string.valueof(prp.Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone).startswith('04')){
                 propertyTonumber.put(prp.Property__c,string.valueof(prp.Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone)); 
                }
                else{
                if(prp.Loan_Surrogate__r.collect__Contact__c != null && prp.Loan_Surrogate__r.collect__Contact__r.MobilePhone != null && string.valueof(prp.Loan_Surrogate__r.collect__Contact__r.MobilePhone).startswith('04'))
                 propertyTonumber.put(prp.Property__c,string.valueof(prp.Loan_Surrogate__r.collect__Contact__r.MobilePhone));
                }
                if(prp.Loan_Surrogate__r.collect__Account__c != null && prp.Loan_Surrogate__r.collect__Account__r.isPersonAccount==TRUE){
                 propertyToRiskentity.put(prp.Property__c,string.valueof(prp.Loan_Surrogate__r.collect__Account__r.name)); 
                }
                else{
                if(prp.Loan_Surrogate__r.collect__Contact__c != null && prp.Loan_Surrogate__r.collect__Contact__r.name != null)
                 propertyToRiskentity.put(prp.Property__c,string.valueof(prp.Loan_Surrogate__r.collect__Contact__r.name));
                }
                if(prp.Loan_Surrogate__r.ScCollection_Originator_ID__c != null){
                propertyTooriginatorID.put(prp.Property__c,prp.Loan_Surrogate__r.ScCollection_Originator_ID__c);
                }
                if(prp.Loan_Surrogate__r.ScCollection_Originator_Short_Name__c != null){
                propertyIdtoOriginatorShortname.put(prp.Property__c,prp.Loan_Surrogate__r.ScCollection_Originator_Short_Name__c);
                }
                if(prp.Loan_Surrogate__r.ScCollection_Mortgage_Funding__c != null){
                propertyToMortgageFunding.put(prp.Property__c,prp.Loan_Surrogate__r.ScCollection_Mortgage_Funding__c); 
                }
                if(prp.Loan_Surrogate__r.collect__External_ID__c != null && prp.Loan_Surrogate__r.collect__External_ID__c.contains(':') && prp.Loan_Surrogate__r.collect__External_ID__c.contains('_')){
                propertyToLoanNumber.put(prp.Property__c,prp.Loan_Surrogate__r.collect__External_ID__c.substring(prp.Loan_Surrogate__r.collect__External_ID__c.indexof(':')+1,prp.Loan_Surrogate__r.collect__External_ID__c.indexof('_')));
                }
                processesProperties.add(prp.Property__c);
                }
            }
            }
        }
         for(Property_Insurance__c prt:newList){
            if(prt.Source_Name__c=='MORTGAGE'){
             if(prt.Property__c != null && propertyTonumber.get(prt.Property__c)!=null)
             prt.Mobile_Phone__c= propertyTonumber.get(prt.Property__c);
             if(prt.Property__c != null && propertyIdtoAddress.get(prt.Property__c) != null)
             prt.Security_Property_Address__c=propertyIdtoAddress.get(prt.Property__c);
             if(prt.Property__c != null && propertyTooriginatorID.get(prt.Property__c)!=null)
             prt.OriginatorID__c=propertyTooriginatorID.get(prt.Property__c);
             if(prt.Property__c != null && propertyIdtoOriginatorShortname.get(prt.Property__c)!=null)
             prt.OriginatorShortName__c=propertyIdtoOriginatorShortname.get(prt.Property__c);
             if(prt.Property__c != null && propertyToMortgageFunding.get(prt.Property__c) != null)
             prt.MotgageFunding__c= propertyToMortgageFunding.get(prt.Property__c);
             if(prt.Property__c != null && propertyToRiskentity.get(prt.Property__c) != null)
             prt.Risk_entity__c= propertyToRiskentity.get(prt.Property__c);
             if(prt.Property__c != null && propertyToLoanNumber.get(prt.Property__c) != null)
             prt.Loan_Surrogate__c= propertyToLoanNumber.get(prt.Property__c);
             if(prt.Property__c != null && !PropertyIDtosurrogates.containskey(prt.Property__c)){
             if(isInsert==True){
             prt.Not_Applicable_For_coc_Process__c=True;
             }
             else{
             prt.Not_Applicable_For_coc_Process__c=True;
             if(newMap.get(prt.id).Status__c=='Closed' && oldmap.get(prt.id).Status__c!='Closed')
             prt.addError('Property is not registered or Loan contract is not active or Property is not associated with CoC Lenders.');
             }
            }
            else{
            prt.Not_Applicable_For_coc_Process__c=False;
            }
               if(isinsert==False){
              if(newMap.get(prt.Id).ownerId != null && newMap.get(prt.Id).ownerId != oldMap.get(prt.id).ownerId && !cocTeamMemberIds.contains(newMap.get(prt.Id).ownerId)){
              
              prt.addError('Any record related to COC Process sholud only be handled by COC Team.');
              }
            }
           }
          } 
              
    }
   
   //Method to check whether the Insurance is associated with the case to make it close or to get it assigned.  
   Public static void checkAssociatedCases(Map<id,Property_Insurance__c> newMap,Map<id,Property_Insurance__c> oldMap){
   
        set<Id> buildingInsuranceIds = new set<Id>();
        Map<Id,List<Case>> InstoCases = new Map<Id,List<Case>>();
        Map<Id,List<Diary_Notes__c>> propertyInsuranceToDiaryNotes = new Map<id,List<Diary_Notes__c>>();
        for(Id InsId:newMap.keyset()){
            if(newmap.get(InsId).Status__c !=null && newmap.get(InsId).Source_Name__c=='MORTGAGE'){
                if(newmap.get(InsId).Status__c!=oldMap.get(InsId).Status__c && newmap.get(InsId).Status__c=='Closed')
                buildingInsuranceIds.add(InsId);
            }
        }
        if(buildingInsuranceIds != null && buildingInsuranceIds.size()>0){
            for(Property_Insurance__c pepBldIns:[Select id,(Select id,status from Cases__r),(Select id from DiaryNotes__r where Type__c='Call Created') from Property_Insurance__c where id in:buildingInsuranceIds]){
             InstoCases.put(pepBldIns.id,pepBldIns.Cases__r);
             propertyInsuranceToDiaryNotes.put(pepBldIns.Id,pepBldIns.DiaryNotes__r);
            }
        }


        for(Property_Insurance__c pepbldIns:newMap.values()){
            if(InstoCases != null && InstoCases.size()>0){
                if(InstoCases.get(pepbldIns.id).size()==0){
                  if(propertyInsuranceToDiaryNotes.get(pepbldIns.Id).size()==0)
                  pepbldIns.addError('This must be associated with any case to get it close or create a Diary Note with Type as "Call Created"');
                }
            }
        }
        
    }
  //Method to call API of writing back the insurance details.
 @Future(Callout=True)
 Public static void writingInsuranceDetails(set<id> newList){
 
       set<Id> insurancePropertiesIds = new set<Id>();
       set<Id> propertyIds = new set<Id>();
       Map<id,List<String>> PropertyIDtosurrogates = new Map<Id,List<String>>();
       insurancePropertiesIds.addall(newList);
       List<Property_Insurance__c> propertyInsurancesToClosed = new List<Property_Insurance__c>();
       propertyInsurancesToClosed=[Select id,Property__c from Property_Insurance__c where id in:insurancePropertiesIds];
       if(propertyInsurancesToClosed != null && propertyInsurancesToClosed.size()>0){
          for(Property_Insurance__c propertyInsurance:propertyInsurancesToClosed){
           propertyIds.add(propertyInsurance.Property__c);
          }
      }
       if(propertyIds != null && propertyIds.size()>0){
                    System.debug('insidethis');
                    List<Property_Surrogate__c> propertySurrogates =[Select id,Property__c,Property__r.Property_Unit_House_Number__c,Property__r.Property_Street__c,Property__r.Property_Suburb_Town__c,Property__r.Property_State__c,Property__r.Property_PostCode__c,Loan_Surrogate__r.collect__Account__c,Loan_Surrogate__r.collect__Account__r.isPersonAccount,Loan_Surrogate__r.collect__Account__r.Personcontact.mobilePhone,Loan_Surrogate__r.collect__Contact__c,Loan_Surrogate__r.ScCollection_Lender_Record__c,Loan_Surrogate__r.collect__Loan_Status__c,Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c,Loan_Surrogate__r.collect__Contact__r.MobilePhone,Loan_Surrogate__r.collect__External_ID__c,Registration_Status__c,DWH_Registration_date__c from Property_Surrogate__c where Property__c in:propertyIds and Registration_Status__c='R' and Loan_Surrogate__r.ScCollection_Loan_Sub_status_description__c not in:StatusTOExcludeForCOC__c.getall().keyset() and Loan_Surrogate__r.ScCollection_Lender_Record__c in:LenderRecordsForCOC__c.getall().keyset()  order BY DWH_Registration_date__c DESC];
                    system.debug('&&&&&'+propertySurrogates);
                    if(propertySurrogates != null && propertySurrogates.size()>0){
                        for(Property_Surrogate__c prp:propertySurrogates){
                            if(!PropertyIDtosurrogates.containskey(prp.Property__c))
                            PropertyIDtosurrogates.put(prp.Property__c,new List<string>());
                            if(prp.Loan_Surrogate__r.collect__External_ID__c.contains(':') && prp.Loan_Surrogate__r.collect__External_ID__c.contains('_'))
                            PropertyIDtosurrogates.get(prp.Property__c).add(prp.Loan_Surrogate__r.collect__External_ID__c.substring(prp.Loan_Surrogate__r.collect__External_ID__c.indexof(':')+1,prp.Loan_Surrogate__r.collect__External_ID__c.indexof('_')));
                       }
                }
            }
         if(insurancepropertiesids != null && insurancepropertiesids.size()>0){
            for(Property_Insurance__c prp : [Select id,Property__r.Property_Number__c,DWH_Propert_Ins_Exp_Date__c,Property_Insurer__r.insurer__c,Property_Ins_Policy_No__c,Property_Amount_Insured__c,Property_Replace_Sq_Mtrs__c,Public_Liability_Cover__c,Insurance_Premium__c,Property__r.Insurance_Type__c    from Property_Insurance__c where id in:insurancepropertiesids]){
                 PropertyInsuranceHandling prHandling = new PropertyInsuranceHandling();
                 if(PropertyIDtosurrogates.containskey(prp.Property__c)){
                 
                 system.debug('calling this');
                 prHandling.updateInuranceDetailsonESB(string.valueof(prp.id),PropertyIDtosurrogates.get(prp.Property__c),prp.Property__r.Property_Number__c,prp.DWH_Propert_Ins_Exp_Date__c,prp.Property_Insurer__r.insurer__c,prp.Property_Ins_Policy_No__c,String.valueof(prp.Property_Amount_Insured__c),string.valueof(prp.Property_Replace_Sq_Mtrs__c),string.valueof(prp.Public_Liability_Cover__c),String.valueof(prp.Insurance_Premium__c),prp.Property__r.Insurance_Type__c);
                 }
          }
        }
        
} 
 //Method to call API of writing back the Letter Generation Process.
 Public static void writingLetterDetails(set<id> newList){
 
       set<Id> insurancePropertiesIds = new set<Id>();
       set<Id> propertyIds = new set<Id>();
       Map<id,List<String>> PropertyIDtosurrogates = new Map<Id,List<String>>();
       insurancePropertiesIds.addall(newList);
       List<Property_Insurance__c> propertyInsurancesToClosed = new List<Property_Insurance__c>();
       propertyInsurancesToClosed=[Select id,Property__c from Property_Insurance__c where id in:insurancePropertiesIds];
       if(propertyInsurancesToClosed != null && propertyInsurancesToClosed.size()>0){
          for(Property_Insurance__c propertyInsurance:propertyInsurancesToClosed){
           propertyIds.add(propertyInsurance.Property__c);
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
    if(insurancePropertiesIds != null && insurancePropertiesIds.size()>0){
    for(Property_Insurance__c insP:[Select id,Property__r.Property_Number__c from Property_Insurance__c where id in:insurancePropertiesIds]){
      PropertyInsuranceHandling prHandling = new PropertyInsuranceHandling();
      if(PropertyIDtosurrogates.containskey(insP.Property__c)){
      PropertyInsuranceHandling.invokeLetterGeneration(PropertyIDtosurrogates.get(insP.Property__c),insP.Property__r.Property_Number__c,string.valueof(insP.id));
        }
      }
    }
    
 }
 
 
 //Updating Case owner with the logged in user.
 Public static void updateOwner(Map<id,Case> newMap,Map<id,case> oldMap){
  set<id> cocTeamMemberIds = new set<id>();
  List<GroupMember> cocTeamMembersList =[Select id,UserOrGroupId from GroupMember where Group.DeveloperName='COC_Team'];
            if(cocTeamMembersList != null && cocTeamMembersList.size()>0){
            for(GroupMember member:cocTeamMembersList){
            cocTeamMemberIds.add(member.UserorGroupId);
            }
            }
            List<Group> allowedQueues=[Select id from Group where (DeveloperName ='UnAllocated_Insurance') and Type='Queue'];
            if(allowedQueues!= null && allowedQueues.size()>0){
            for(Group grp:allowedQueues){
            cocTeamMemberIds.add(grp.Id);
            }
            }
  RecordType builInsuranceRecordtype=[Select id,Developername,sobjectType from RecordType where Developername='Building_Insurance_Expiry' AND sobjecttype='Case'  Limit 1];
  set<Id> casesId = new set<Id>();
  for(Id caseId:newMap.keyset()){
  if(newMap.get(caseId).recordTypeid==builInsuranceRecordtype.id && newMap.get(caseId).ownerId!=oldMap.get(caseId).ownerId && (!cocTeamMemberIds.contains(newMap.get(caseId).ownerId) || (newMap.get(caseId).ownerId==allowedQueues[0].id &&  cocTeamMemberIds.contains(Userinfo.getuserid())))){
  newMap.get(caseId).addError('Case can be worked upon by COC Team member only or not assigned back to Unallocated Queue');
  return;
  }
  
  if((newMap.get(caseId).Property_Insurance__c != oldMap.get(caseId).Property_Insurance__c  && newMap.get(caseId).Property_Insurance__c != null && newMap.get(caseId).recordTypeid==builInsuranceRecordtype.id) || (newMap.get(caseId).Status=='Closed' && newMap.get(caseId).Status != oldMap.get(caseId).Status && newMap.get(caseId).recordTypeid==builInsuranceRecordtype.id))
  casesId.add(caseId);
  }
  for(Case cse:newMap.values()){
  if(casesId.contains(cse.id))
  cse.ownerId=Userinfo.getuserid();
  }
  
 }
 
 Public static void handleAssignment(Map<id,Case> newMap,Map<id,case> oldMap){
 
  List<Property_Insurance__c> propertyInsurancestoUpdate = new List<Property_Insurance__c>();
  RecordType builInsuranceRecordtype=[Select id,Developername,sobjectType from RecordType where Developername='Building_Insurance_Expiry' AND sobjecttype='Case'  Limit 1];
  set<Id> casesToEscalateLevel1 = new set<Id>();
  set<Id> casesToEscalateLevel2 = new set<Id>();
  set<Id> casesId = new set<Id>();
  for(Id caseId:newMap.keyset()){
  if(newMap.get(caseId).ownerid != oldMap.get(caseId).ownerid && newMap.get(caseId).ownerid != null && newMap.get(caseId).recordTypeid==builInsuranceRecordtype.id && newMap.get(caseId).ownerid==Userinfo.getuserid())
  casesId.add(caseId);
  if(newMap.get(caseId).EscalatedLevel1__c != oldMap.get(caseId).EscalatedLevel1__c && newMap.get(caseId).EscalatedLevel1__c == True && newMap.get(caseId).recordTypeid==builInsuranceRecordtype.id)
  casesToEscalateLevel1.add(caseId);
  if(newMap.get(caseId).EscalatedLevel2__c != oldMap.get(caseId).EscalatedLevel2__c && newMap.get(caseId).EscalatedLevel2__c == True && newMap.get(caseId).recordTypeid==builInsuranceRecordtype.id)
  casesToEscalateLevel2.add(caseId);
  }
  If(casesId != null && casesId.size()>0){
  List<Case> caseesgettingassigned = [Select id,Property_Insurance__c from Case where id in:casesId];
  for(Case cs:caseesgettingassigned){
      if(cs.Property_Insurance__c != null){
              Property_Insurance__c proptpUpdate = new Property_Insurance__c(id=cs.Property_Insurance__c,ownerid=Userinfo.getuserid());
              propertyInsurancestoUpdate.add(proptpUpdate); 
         }
     }
     if(propertyInsurancestoUpdate != null && propertyInsurancestoUpdate.size()>0)
     update propertyInsurancestoUpdate;
  }
  if(casesToEscalateLevel1 != null && casesToEscalateLevel1.size()>0){
      List<Messaging.singleEmailMessage> msgList = new List<Messaging.singleEmailMessage>();
      EmailTemplate et =[Select id,HtmlValue from EmailTemplate where Developername ='Case_Escalation_Level_1'];
      for(Case cs:[Select id,CaseNumber from Case where id in:casesToEscalateLevel1]){
          for(EscalationLevel1emails__c escEmail:EscalationLevel1emails__c.getall().values()){
          Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
          msg.setSubject('Case Escalated Level 1');
          String htmlbody=et.HtmlValue;
          if(htmlbody.contains('{!Recipient}'))
          htmlbody=htmlbody.replace('{!Recipient}',escEmail.Name);
          if(htmlbody.contains('{!Casenumber}'))
          htmlbody=htmlbody.replace('{!Casenumber}',cs.CaseNumber);
          msg.sethtmlbody(htmlbody);
          msg.settoaddresses(new string[]{escEmail.Email_Address__c});
          List<string> ccemails = new List<string>();
          for(CarbonCopyEscalation1emails__c ccemail:CarbonCopyEscalation1emails__c.getall().values()){
          ccemails.add(ccemail.email__c);
          }
          msg.setccAddresses(ccemails);
          msgList.add(msg);
          }
      }
      if(msgList != null && msgList.size()>0)
      Messaging.sendEmail(msgList);
 }
 if(casesToEscalateLevel2 != null && casesToEscalateLevel2.size()>0){
      List<Messaging.singleEmailMessage> msgList = new List<Messaging.singleEmailMessage>();
      EmailTemplate et =[Select id,HtmlValue from EmailTemplate where Developername ='Case_Escalation_Level_1'];
      for(Case cs:[Select id,CaseNumber from Case where id in:casesToEscalateLevel2]){
          for(EscalationLevel2emails__c escEmail:EscalationLevel2emails__c.getall().values()){
          Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
          msg.setSubject('Case Escalated Level 2');
          String htmlbody=et.HtmlValue;
          if(htmlbody.contains('{!Recipient}'))
          htmlbody=htmlbody.replace('{!Recipient}',escEmail.Name);
          if(htmlbody.contains('{!Casenumber}'))
          htmlbody=htmlbody.replace('{!Casenumber}',cs.CaseNumber);
          msg.sethtmlbody(htmlbody);
          msg.settoaddresses(new string[]{escEmail.Email__c});
          List<string> ccemails = new List<string>();
          for(CarbonCopyEscalation2emails__c ccemail:CarbonCopyEscalation2emails__c.getall().values()){
          ccemails.add(ccemail.email__c);
          }
          msg.setccAddresses(ccemails);
          msgList.add(msg);
          }
      }
      if(msgList != null && msgList.size()>0)
      Messaging.sendEmail(msgList);
 }
 
 }
 Public static void createDiaryNotes(set<Id> propertyInsuranceIds,String comment){
 
 List<Property_Insurance__c> propertyInsurances = [Select id,Property__r.CL_Contract__c from Property_Insurance__c where id in:propertyInsuranceIds];
 List<Diary_Notes__c> diaryNotes = new List<Diary_Notes__c>();
 for(Property_Insurance__c prI:propertyInsurances){
  Diary_Notes__c drn = new Diary_Notes__c(Automated__c=True,Comment__c=comment,Property_Insurance__c=prI.id);
  diaryNotes.add(drn);
 } 
 if(diaryNotes != null && diaryNotes.size()>0)
 insert diaryNotes; 
 
 }
 
}