@isTest
public class TestFetchAppDocCatAttachmentJunction {
    
    public static testmethod void fetchDocTest(){
    	loan.TestHelper.createSeedDataForTesting();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
    	List<genesis__Application_Document_Category__c> DocIds = new List<genesis__Application_Document_Category__c>();
        genesis__Applications__c application = genesis.TestHelper.createApplication();
    	genesis__Application_Document_Category__c AppDoc = new genesis__Application_Document_Category__c();
        AppDoc.genesis__Application__c = application.id;
        insert AppDoc;
    	DocIds.add(AppDoc);
        List<genesis__AppDocCatAttachmentJunction__c> allJnObject = new List<genesis__AppDocCatAttachmentJunction__c>();
        genesis__AppDocCatAttachmentJunction__c AppDocCat = new genesis__AppDocCatAttachmentJunction__c();
        AppDocCat.genesis__Application_Document_Category__c = AppDoc.Id;
        insert AppDocCat;
        allJnObject.add(AppDocCat);
        genesis__Conversion_Mapping__c con_map = new genesis__Conversion_Mapping__c();
        con_map.genesis__Application_Field_Name__c = 'genesis__Loan_Amount__c';
        con_map.genesis__Contract_Field_Name__c = 'loan__Loan_Amount__c';
        con_map.genesis__Product_Type__c = 'loan';
        con_map.genesis__Contract_Object_Name__c = 'loan__Loan_Account__c';
        insert con_map;
        Test.startTest();
        system.debug('hello'+AppDocCat.name);
        Map<genesis__Application_Document_Category__c,List<genesis__AppDocCatAttachmentJunction__c>> map1 = FetchAppDocCatAttachmentJunction.fetchAllDoc(DocIds);
        system.assert(map1.containsKey(DocIds[0]));
        Test.stopTest();
    }
}