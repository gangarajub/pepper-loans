@isTest
public class TestVedaPPSRSearch {   
    
    @isTest static void vedaPPSRPositiveMethod(){
        insert new ints__VedaPPSRSetting__c(ints__endpoint__c ='https://ctaau.vedaxml.com/cta/sys2/ppsr',ints__username__c='PH4uWcfNLF',ints__password__c='wP35jERuYe',ints__version__c='123',ints__clientReference__c='9251155753');        
        Test.startTest();    
        /* create Collateral object*/
        Summary__c sumObj= new Summary__c();
        Registration__c regObj= new Registration__c();
        
        clcommon__collateral__c collObj = new clcommon__collateral__c();
        collObj.active__c=false;
        string dummy ='abc';        
        collObj.clcommon__Vehicle_ID_Number__c='JT712YR2105100426';
        collObj.clcommon__Make__c='acb';
        collObj.clcommon__Model__c='asd';
        collObj.clcommon__Style__c=dummy;
        collObj.clcommon__Year__c=dummy;
        collObj.clcommon__Vehicle_Color__c=dummy;
        collObj.clcommon__Collateral_Name__c='My Vehicle';
        collObj.Vehicle_Series__c=dummy;
        collObj.Vehicle_Type__c=dummy;
        collObj.transmission__c=dummy;        
        collObj.integration_Error_Status__c=dummy;
        collObj.integration_Error_Status_Code__c=dummy;
        collObj.ppsr_Search_Certificate_Number__c=dummy;
        collObj.message__c=dummy;
        collObj.Variant__c=dummy;             
        upsert collObj;   
        
        sumObj.stolen__c='Pass';
        sumObj.encumbrance__c='true';
        sumObj.odometer__c='Pass';
        sumObj.insurance__c='true';
        sumObj.registration__c='Pass';
        sumObj.writtenOff__C='True';  
        
        insert sumObj;
        
        regObj.registration_Plate__c='X76JK';
        regObj.registration_Expiry_Date__c='19-11-2016';
        regObj.registration_State__c='SA';       
        
        insert regObj;
        
        
        VedaPPSRSearchAPI chs = new VedaPPSRSearchAPI(collObj.id);
        ints.VedaPPSRSearchRes res= new ints.VedaPPSRSearchRes();        
        VPPSR_Serial_Number_Search_Response__c searchRes= chs.getSearchRes();        
        system.assertNotEquals(null, searchRes);
        Test.stopTest();
    }  
}