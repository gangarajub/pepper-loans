@isTest
public class TestCarHistorySearchAPI {   
    @isTest static void carHistPositiveMethod(){
    	insert new ints__CarHistory__c(ints__endpoint__c ='https://www.vedaauto.com/VedaAutoServicesTest.svc',ints__username__c='pepper.carhistory',ints__password__c='Carhistory1');        
        RetrieveCode__c rc= RetrieveCode__c.getOrgDefaults();
        insert rc;
        clcommon__collateral__c collObj =new clcommon__collateral__c();
        genesis__applications__c app= new genesis__applications__c();
        insert app;
        
        String appId=app.id;
        string data='abc';
        collObj.clcommon__Vehicle_ID_Number__c='12345678900987';
        collObj.clcommon__Make__c=data;
        collObj.clcommon__Model__c=data;
        collObj.clcommon__Style__c=data;
        collObj.clcommon__Year__c=data;
        collObj.clcommon__Vehicle_Color__c=data;
        collObj.clcommon__Collateral_Name__c=data;
        insert colLObj;
        
        Test.startTest();        
        CarHistorySearchAPI chs = new CarHistorySearchAPI(colLObj.clcommon__Vehicle_ID_Number__c,appId, 'Car');
        clcommon__collateral__c colObj=chs.getCarDetails();
        system.assertNotEquals(null, colObj);
        Test.stopTest();
    }  
   
}