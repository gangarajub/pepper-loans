Public Class PLCaseManagement{
     Public static void manageCase(List<EmailMessage> newList){
          set<Id> CaseId = new set<Id>();
          List<Case> caseTolinked = new List<Case>();
          Map<String,string> emailToname = new Map<string,string>();
          List<Case> casesToUpdate = new List<Case>();
          List<Account> PersonAccounts = new List<Account>();
          Map<String,Account> emailToPersonAccount = new Map<string,Account>();
          for(EmailMessage emsg:newList){
              if(emsg.incoming){
                  CaseId.add(emsg.parentid);
                  emailToname.put(emsg.FromAddress,emsg.FromName);
              }
         }
         if(CaseId != null && caseId.size()>0){
             RecordType builInsuranceRecordtype=[Select id,Developername,sobjectType from RecordType where Developername='Building_Insurance_Expiry' AND sobjecttype='Case'  Limit 1];
             caseTolinked=[Select id,contactid,SuppliedEmail from case where id in:CaseId and Contactid=null and RecordTypeid=:builInsuranceRecordtype.id];
             Recordtype rt=[Select id from RecordType where sobjectType='Account' and IsPersonType=True Limit 1];
             if(caseTolinked != null && caseTolinked.size()>0){
                 for(Case cs:caseTolinked){
                       Account acc = new Account(RecordTypeid=rt.id,lastname=emailToname.get(cs.SuppliedEmail),Personemail=cs.SuppliedEmail);
                       PersonAccounts.add(acc);
                   }
                   if(PersonAccounts != null && PersonAccounts.size()>0){
                       insert PersonAccounts;
                          for(Account acc:[Select id,Personemail,Personcontactid from Account where id in :PersonAccounts]){
                           emailToPersonAccount.put(acc.PersonEmail,acc);
                          }
                        for(Case csd:caseTolinked){
                            csd.contactid=emailToPersonAccount.get(csd.SuppliedEmail).Personcontactid;
                            casesToUpdate.add(csd);
                        }
                   }
                   if(casesToUpdate != null && casesToUpdate.size()>0){
                     update casesToUpdate;
                    }
              }
         } 
    }
}