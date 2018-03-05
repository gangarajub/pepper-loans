@isTest public class pepBankInstitution_Tracker {
    
    @isTest static void pepBankInstitutionTest(){
        
        
        pepBankInstitution.Value objValue = new pepBankInstitution.Value();
        objValue.one=1;
        objValue.two=2;
        objValue.three=3;
        objValue.four=4;
        objvalue.with='with';
        objvalue.without='without';
        objvalue.device='device';
        objvalue.passwords='passwords';
        
        pepBankInstitution.Credential objWrapCredential = new pepBankInstitution.Credential();
        objWrapCredential.name ='test';
        objWrapCredential.type='testType';
        objWrapCredential.Values = objValue;
        
        
        
        List<pepBankInstitution.Credential> lstCredential = new List<pepBankInstitution.Credential>();
        lstCredential.add(objWrapCredential);
        
        pepBankInstitution objpepBankInstitution = new pepBankInstitution('slug1','name1','status1','searchable1','display1','searchVal1','region1','ewp1','es1','tls1','rp1','rm1','ua1','md1',lstCredential);
        
        
        
        
    }

}