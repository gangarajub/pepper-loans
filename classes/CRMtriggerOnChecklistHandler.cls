//-----------------------------------------------------------------------------------------------------
// Date        : 30/11/2016
// Description : This class is to update case status if checklist status in Completed
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------

public class CRMtriggerOnChecklistHandler{

    public static void updateCaseStatus(List<CRM_Checklist__c> triggernew,Map<Id,CRM_Checklist__c> triggerOldMap){
        
        List<Case> lstCase = new List<Case>();
        for(CRM_Checklist__c objCheckList : triggernew){
            
            if(objCheckList.CRM_Case__c != null){
                if(objCheckList.CRM_Status__c != null && objCheckList.CRM_Status__c == 'Completed'){
                
                    Case c = new Case();
                    c.id = objCheckList.CRM_Case__c;
                    c.Status = 'Verification Passed';
                    lstCase.add(c);
                }
                
            }     
        }
        
        if(lstCase != null && lstCase.size()>0){
        
            update lstCase;
        }
    
    }


}