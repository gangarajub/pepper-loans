Public Class PepEnforcementPrevention{
    //Method to prevent the tagging of customer with wrong Loan Contract
        Public static void preventCustomerAccountAssociation(List<Account_LoanContract__c> newList){
            Map<id,set<id>> contractToAccountIds = new Map<id,Set<id>>();
            set<id> loanContractIds = new set<id>();
            for(Account_LoanContract__c accContract:newList){
                if(accContract.Loan_Contract__c != null)
                loanContractIds.add(accContract.Loan_Contract__c);
            }
            if(loanContractIds != null && loanContractIds.size()>0){
                   //Querying the Account directly linked with Contract or via Party.
                   List<collect__Loan_Account__c> contracts = [Select id,collect__Account__c,(Select id,clcommon__Account__c from collect__Parties__r) from collect__Loan_Account__c where id in:loanContractIds];
                   if(contracts != null && contracts.size()>0){
                   for(collect__Loan_Account__c loanContract:contracts){
                       if(loanContract.collect__Account__c != null){
                         if(!ContractToAccountIds.containskey(loanContract.id))
                         ContractToAccountIds.put(loanContract.id,new set<id>());
                         ContractToAccountIds.get(loanContract.id).add(loanContract.collect__Account__c);
                       }
                       if(loanContract.collect__Parties__r != null && loanContract.collect__Parties__r.size()>0){
                       for(clcommon__Party__c cmParty:loanContract.collect__Parties__r){
                          if(cmParty.clcommon__Account__c != null){
                              if(!ContractToAccountIds.containskey(loanContract.id))
                                ContractToAccountIds.put(loanContract.id,new set<id>());
                                ContractToAccountIds.get(loanContract.id).add(cmParty.clcommon__Account__c);       
                           }           
                         }
                       } 
                    }
                   }
                   for(Account_LoanContract__c loanContractAssociation:newList){
                   if(loanContractAssociation.Loan_Contract__c != null && loanContractAssociation.Account__c != null){
                      if(ContractToAccountIds.containskey(loanContractAssociation.Loan_Contract__c)){
                             if(ContractToAccountIds.get(loanContractAssociation.Loan_Contract__c) != null && ContractToAccountIds.get(loanContractAssociation.Loan_Contract__c).size()>0){
                                 if(!ContractToAccountIds.get(loanContractAssociation.Loan_Contract__c).contains(loanContractAssociation.Account__c))
                                 loanContractAssociation.addError('Loan Contract is not related with the Selected Customer');
                             }
                        }
                        else{
                         loanContractAssociation.addError('Loan Contract is associated with no Customer');
                         }
                    }
               }
            }
        }
          //Method to prevent assignment of Case in a wrong way
        Public static void preventAssignment(Map<id,Case> oldMap,Map<id,Case> newMap){
        
        set<id> allowedMembersId = new set<id>();
        set<id> enforcementTeamMemberIds = new set<id>();
        RecordType enforcementRecordType =[Select id from recordType where developername='Enforcement' and sobjectType='Case'];
        Group unallocatedEnforcementQueue = [Select id from Group where developername='Unallocated_Enforcement_Queue' and Type='Queue'];
        List<groupMember> enforcementTeamMembers=[Select id,UserorgroupId from GroupMember where Group.developername='Enforcement_Team_Member'];
        if(EnforcementTeamMembers != null && EnforcementTeamMembers.size()>0){
        for(groupMember grpMember:EnforcementTeamMembers){
        enforcementTeamMemberids.add(grpMember.UserorgroupId);
        }
        }
        allowedMembersid.add(unallocatedEnforcementQueue.id);
        List<groupMember> enforcementTeam =[Select id,UserorgroupId from GroupMember where Group.developername='Enforcement_Team_Leader' OR Group.Developername='Enforcement_Team_Member'];
        if(enforcementTeam != null && enforcementTeam.size()>0){
        for(groupMember grpMember:enforcementTeam){
        allowedMembersid.add(grpMember.UserorgroupId);
        }
        }
        for(Id caseId:newMap.keyset())                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           {
           if(newMap.get(caseId).ownerid != oldMap.get(caseId).ownerid && newMap.get(caseId).RecordTypeid==enforcementRecordType.id && !allowedmembersid.contains(newMap.get(caseId).ownerid)){
           newMap.get(caseId).addError('Person or Queue is not authorised to handle the Enforcement related Cases.');
           return;
           }
           if(newMap.get(caseId).ownerid != oldMap.get(caseId).ownerid && newMap.get(caseId).RecordTypeid==enforcementRecordType.id && enforcementTeammemberids.contains(Userinfo.getuserid())){
             if((oldMap.get(caseId).ownerid==Userinfo.getuserid() || (oldMap.get(caseId).ownerid==UnallocatedEnforcementQueue.id)) && newMap.get(caseId).ownerid!=UnallocatedEnforcementQueue.id){
             }
             else{
             newMap.get(caseId).addError('Cases owned by Queue can only be assigned to other Enforcement officers or Cases cant be assigned back to Queue.');
             }
           
           }
           if(newMap.get(caseId).Status=='Open' && oldMap.get(caseId).Status=='Closed' && newMap.get(caseId).RecordtypeId==enforcementRecordType.id)
           newMap.get(caseId).ownerid=UnallocatedEnforcementQueue.Id;
           if(newMap.get(caseId).ownerId != oldMap.get(caseId).ownerId && oldMap.get(caseId).ownerId==UnallocatedEnforcementQueue.id && newMap.get(caseId).Sub_category__c==null && newMap.get(caseId).RecordtypeId==enforcementRecordType.id)
           newMap.get(caseId).addError('Case must be Categorized before Allocation');
           if(newMap.get(caseId).Accountid != null && newMap.get(caseId).RecordtypeId==enforcementRecordType.id)
           newMap.get(caseId).Accountid=null;
           if(newMap.get(caseId).ContactID!= null && newMap.get(caseId).RecordtypeId==enforcementRecordType.id)
           newMap.get(caseId).contactid=null;
        }
      }
      //Method to prevent deletion of Email message associated with the Enforcement related Case/Building Insurance Related Case. 
      Public static void preventDeletion(List<Emailmessage> oldlist){
          set<Id> caseChilds = new set<Id>(); 
          set<Id> enforcementEmailMessagesset = new set<Id>();
          for(Emailmessage msg:oldList){
              if(msg.Parentid != null){
                  if(String.valueof(msg.ParentId).startswith('500'))
                  caseChilds.add(msg.Id);
              }
           }
           if(caseChilds != null && caseChilds.size()>0){
           List<Emailmessage> enforcementemailmessages = [Select id,Parent.Recordtype.developername from Emailmessage where (Parent.RecordType.developername='Enforcement' or Parent.RecordType.developername='Building_Insurance_Expiry') and id in:caseChilds];
           if(enforcementemailmessages != null && enforcementemailmessages.size()>0){
               for(EmailMessage emsg:enforcementemailmessages){
                   enforcementEmailMessagesset.add(emsg.Id);
               }
           }
      }
      for(EmailMessage msg:oldList){
          if(enforcementEmailMessagesset.contains(msg.id) && !Test.isRunningTest())
          msg.addError('You are not allowed to delete related email messages');
      }
    }
}