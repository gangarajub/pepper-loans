public class CRMTriggerToUpdateOpporStatusHandler{

    public static void changeOpportunityStatus(List<EmailMessage> lstEmailMessage){
    
        Set<ID> setRelatedID = new Set<ID>();
        Map<ID,String> mapIDToSubject = new Map<ID,String>();
        for(EmailMessage objEmail : lstEmailMessage){
        
            if(objEmail.RelatedToID != null){
            
                setRelatedID.add(objEmail.RelatedToID);
                mapIDToSubject.put(objEmail.RelatedToID,objEmail.Subject);
            }
        }
        set<ID> setOpportunityIdForFinalApproval = new Set<ID>();
        List<Opportunity> lstOpportunity = [select id,Name,StageName from Opportunity where id in : setRelatedID];
        List<Opportunity> lstToUpdateOpportunity = new List<Opportunity>();
        if(lstOpportunity != null && lstOpportunity.Size()>0){
        
            for(Opportunity opp : lstOpportunity){
                if(mapIDToSubject.containsKey(opp.id)){
                    
                    if(mapIDToSubject.get(opp.id) != null && mapIDToSubject.get(opp.id) == 'Loan Particulars'){
                        opp.StageName = 'Pack Out';
                        lstToUpdateOpportunity.add(opp);
                    }
                    
                    else if(mapIDToSubject.get(opp.id) != null && mapIDToSubject.get(opp.id) == 'Conditional Approval'){
                        opp.StageName = 'Conditionally Approved';
                        lstToUpdateOpportunity.add(opp);
                    }
                    
                    else if(mapIDToSubject.get(opp.id) != null && mapIDToSubject.get(opp.id) == 'Final Approval'){
                        setOpportunityIdForFinalApproval.add(opp.id);
                    }
                    
                }
                 
            }
            
            if(lstToUpdateOpportunity !=null && lstToUpdateOpportunity.size()>0){
            
                update lstToUpdateOpportunity;
            }
            
            List<Task> lstOfTaskToBeClosed = [select id,Status,Subject,whatid from Task where whatid in : setOpportunityIdForFinalApproval  and Status = 'open' and Subject = 'Send Formal Approved Email'];
            List<Task> lstNewTaskToUpdateStatus = new List<Task>();
            if(lstOfTaskToBeClosed != null && lstOfTaskToBeClosed.Size()>0){
                
                for(Task objTask : lstOfTaskToBeClosed){
                    
                    objTask.Status = 'Completed';
                    lstNewTaskToUpdateStatus.add(objTask);
                }
                
            }
            
            if(lstNewTaskToUpdateStatus != null && lstNewTaskToUpdateStatus.Size()>0){
                
                update lstNewTaskToUpdateStatus;
            }
        
        }
        
    }
    
}