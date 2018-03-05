@isTest
public class TestVedaIdMatrixImpl {
   
     	testMethod static void vedaIdMatrixTest(){ 
      	RetrieveCode__c mc =  new RetrieveCode__c();
     	mc.code__c='AAA14341';
     	insert mc;
    	Account ac = genesis.TestHelper.createAccount();
    	genesis__Applications__c app=TestHelper.createLoanApplication();
        
    	Residential_Address__c rs = new Residential_Address__c();
    	rs.Current_Address__c=true;
    	rs.Street_Number__c='123';
    	rs.Street_Name__c='Privet';
    	rs.Street_Type__c='ST';
    	rs.Suburb__c='Little Whinging';
    	rs.State__c='NSW';
    	rs.Property__c='Potter Manor';
    	rs.Unit_Number__c='3';
    	rs.PostCode__c='2999';
    	rs.Country_Code__c='AUS';
   	 	rs.Application__c=app.Id;
    	insert rs;
   
    	TestHelper.insertIDMatrixCustomSetting();
    	System.debug('app='+app.Id);
   	 	VedaResponse vr = new VedaResponse();
    	VedaIdMatrixImpl  v  = new VedaIdMatrixImpl();
    	Decisioning_Configuration__c c = new Decisioning_Configuration__c();
    	c.Name='Veda IdMatrix';
    	c.Active__c=true;
    	c.Callout_Class_Name__c='VedaIdMatrixImpl';
    	c.Order__c=1;
    	c.Parser_Class_Name__c='VedaIdMatrixParser';
    	c.Response_Class_Name__c='ints.IDMatrixResponse';
    	insert c;
    	vr.app=app;
    	Test.startTest();   
      	VedaServices.webServiceVedaIdMatrix(app.Id);   
        Test.stopTest();
    	List<Veda_IdMatrix__c> veda_matrix = [select id from Veda_IdMatrix__c where Application__c =: app.id];
        system.assertEquals(veda_matrix.size(), 1);
        List<IdMatrix_Rules_Result__c> rules_result = [select id from IdMatrix_Rules_Result__c where Veda_IdMatrix__c =: veda_matrix[0].id];
        system.assertEquals(rules_result.size(), 1);
        List<IdMatrix_Analysis_Result__c> analysis = [select id from IdMatrix_Analysis_Result__c where Veda_IdMatrix__c =: veda_matrix[0].id];
        system.assertEquals(analysis.size(), 1);
        List<IdMatrix_Search_Result__c> searchRes = [select id from IdMatrix_Search_Result__c where Veda_IdMatrix__c =: veda_matrix[0].id];
        system.assertEquals(searchRes.size(), 1);
        List<IdMatrix_Fraud_Assessment_Response__c> asses = [select id from IdMatrix_Fraud_Assessment_Response__c where Veda_IdMatrix__c =: veda_matrix[0].id];
        system.assertEquals(asses.size(), 1);
    	
    }
    
    
    
    

}