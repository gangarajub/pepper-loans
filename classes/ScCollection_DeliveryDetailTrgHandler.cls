// --------------------------------------------------------------------------------------------------------
// This Class is use to fill look up on CL Contract and PL contract 
// --------------------------------------------------------------------------------------------------------
// Created Date : 31-JAN-2017   Created By: sandip bijlwan  Email: sandip.bijlwan@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : 
// --------------------------------------------------------------------------------------------------------   
public class ScCollection_DeliveryDetailTrgHandler{

    public static void UpdateContractLookup(List<cnotify__Delivery_Detail__c> lstNew){
    
    String cl_Contract = 'collect__Loan_Account__c';
    String pl_Contract = 'loan__Loan_Account__c';
    
    set<String> setCLContractId = new set<String>();
    set<String> setPLContractId = new set<String>();
        if(lstNew != null && lstNew.Size()>0){
        
            for(cnotify__Delivery_Detail__c objDeliveryDetail : lstNew){
                
                if(objDeliveryDetail.cnotify__Contract_Id__c != null){
                    
                    String contract_Id_Name = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(objDeliveryDetail.cnotify__Contract_Id__c);
                    
                    if(contract_Id_Name == cl_Contract){
                        objDeliveryDetail.ScCollection_CL_Contract__c = objDeliveryDetail.cnotify__Contract_Id__c;
                        objDeliveryDetail.ScCollection_PL_Contract__c = null;
                    }
                    else if(contract_Id_Name == pl_Contract){
                        objDeliveryDetail.ScCollection_PL_Contract__c = objDeliveryDetail.cnotify__Contract_Id__c;
                        objDeliveryDetail.ScCollection_CL_Contract__c = null;
                    }
                    else{
                        objDeliveryDetail.ScCollection_CL_Contract__c = null;
                        objDeliveryDetail.ScCollection_PL_Contract__c = null;
                    }                    
                }
                else{
                    objDeliveryDetail.ScCollection_CL_Contract__c = null;
                    objDeliveryDetail.ScCollection_PL_Contract__c = null;
                }                              
            }        
        }       
    }
}