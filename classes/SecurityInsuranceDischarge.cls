/**
 * @Created By: Sushant Kumar
 * @Date : 26/09/2017
 * @Description : This class contains functionality for discharging Security Insurance In case of changing/updating 
 *                  value of 'Loan Sub Status Description' filed on Contract (collect__Loan_Account__c) object.
 **/

public class SecurityInsuranceDischarge {

    @InvocableMethod(label='Discharge related Security Insurances' description='This method find related Security Insurances and discharge them on specfic crietera')
    public static void dischargeRelatedSecurityInsurances(List<collect__Loan_Account__c> contractRecords) {
        
        List<Id> filteredRecordIds = new List<Id>();
        Set<String> specificValues = new Set<String>();
        List<Property_Insurance__c> dischargableSecurityInsurance;
        
        List<StatusTOExcludeForCOC__c> custmSettingRecords = StatusTOExcludeForCOC__c.getAll().values();
        
        if(custmSettingRecords != null && !custmSettingRecords.isEmpty()) {
            
            for(StatusTOExcludeForCOC__c cstmStngObj : custmSettingRecords) {
                specificValues.add(cstmStngObj.Name);
            }
        }
        for(collect__Loan_Account__c contractObj : contractRecords) {
            
            if(specificValues.contains(contractObj.ScCollection_Loan_Sub_status_description__c)) {
                filteredRecordIds.add(contractObj.Id);
            }
        }
        if(!filteredRecordIds.isEmpty()) {
            dischargableSecurityInsurance = getContractRelatedSecurityInsurances(filteredRecordIds);
        }
        if(dischargableSecurityInsurance != null && !dischargableSecurityInsurance.isEmpty()) {
            dischargeSecurityInsurances(dischargableSecurityInsurance);
        }
    }
    
    /**
     * @param : contractIds     Ids of Contract(collect__Loan_Account__c) records.
     * @return :                A List of Related Property_Insurance__c records.
     * @description :           This method is created for finding Property Insurance (Security Insurnace) records related to given
     *                          contract(collect__Loan_Account__c) ids.
     **/
    public Static List<Property_Insurance__c> getContractRelatedSecurityInsurances(List<Id> contractIds) {
        
        List<Property_Insurance__c> relatedPropertyInsurances = new List<Property_Insurance__c>();
        List<Property_Surrogate__c> relatedSecurityContracts;
        List<Id> securityIds;
        
        if(contractIds!=null && !contractIds.isEmpty()) {
            
            relatedSecurityContracts = [Select Id, Property__c from Property_Surrogate__c Where Loan_Surrogate__c IN :contractIds];
            if(!relatedSecurityContracts.isEmpty()) {
                
                securityIds = new List<Id>();
                for(Property_Surrogate__c securityContractObj : relatedSecurityContracts) {
                    
                    if(securityContractObj.Property__c != null) {
                        securityIds.add(securityContractObj.Property__c);
                    }
                }
            }
        }
        
        if(securityIds != null && !securityIds.isEmpty()) {
            relatedPropertyInsurances = [Select Id, Name, COC_Not_Applicable__c from Property_Insurance__c Where Property__c In : securityIds];
        }
        return relatedPropertyInsurances;
    }
    
    /**
     * @param : dischargableRecords     A list of records that needs to discharged
     * @description : This method discharges Security Insurance records
     **/
    private static void dischargeSecurityInsurances(List<Property_Insurance__c> dischargableRecords) {
        
        for(Property_Insurance__c dischargableRecord : dischargableRecords) {
            
            dischargableRecord.COC_Not_Applicable__c = true;
        }
        if(!dischargableRecords.isEmpty()) {
            update dischargableRecords;
        }
    }
}