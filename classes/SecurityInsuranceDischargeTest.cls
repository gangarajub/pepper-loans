/**
 * @Created By : Sushant kumar
 * @Date : 27/09/2017
 * @Description : This Class is created as Tracker of SecurityInsuranceDischarge class
 **/

@isTest(seeAllData=false)
public class SecurityInsuranceDischargeTest {

    private static testMethod void dischargeRelatedSecurityInsurances() {
        
        Id recordTypeIdContract = Schema.SObjectType.collect__Loan_Account__c.getRecordTypeInfosByName().get('Mortgage').getRecordTypeId();
        //creating Contract record
        collect__Loan_Account__c contractObj = new collect__Loan_Account__c();
        contractObj.RecordTypeId = recordTypeIdContract;
        contractObj.Name = 'testContract';
        contractObj.ScCollection_Loan_Sub_status_description__c = 'settled';
        insert contractObj;
        
        Id recordTypeIdSecurity = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Mortgage').getRecordTypeId();
        Property__c securityObj = new Property__c();
        securityObj.RecordTypeId = recordTypeIdSecurity;
        securityObj.Name = 'testSecurityRecord';
        insert securityObj;
        
        Id recordTypeIdSecurityIsurance = Schema.SObjectType.Property_Insurance__c.getRecordTypeInfosByName().get('Mortgage').getRecordTypeId();
        Property_Insurance__c securityInsuranceObj = new Property_Insurance__c();
        securityInsuranceObj.RecordTypeId = recordTypeIdSecurityIsurance;
        securityInsuranceObj.Property__c = securityObj.Id;
        securityInsuranceObj.Name = 'testSecurityInsurance';
        
        insert securityInsuranceObj;
        
        Property_Surrogate__c securityContractObj = new Property_Surrogate__c();
        securityContractObj.Name = 'testSecurityContract';
        securityContractObj.Property__c = securityObj.Id;
        securityContractObj.Loan_Surrogate__c = contractObj.Id;
        insert securityContractObj;
        
        StatusTOExcludeForCOC__c cstmSettingObj = new StatusTOExcludeForCOC__c();
        cstmSettingObj.Name = 'Discharged';
        insert cstmSettingObj;
        
        contractObj.ScCollection_Loan_Sub_status_description__c = 'Discharged';
        update contractObj;
        List<collect__Loan_Account__c> dichargedContracts = new List<collect__Loan_Account__c >();
        dichargedContracts.add(contractObj);
        SecurityInsuranceDischarge.dischargeRelatedSecurityInsurances(dichargedContracts);
        List<Property_Insurance__c> securityInsuranceResultLst = [Select Id, Name, COC_Not_Applicable__c from Property_Insurance__c where Id =:securityInsuranceObj.Id];
        
        System.assertEquals(true, securityInsuranceResultLst[0].COC_Not_Applicable__c);
    }
}