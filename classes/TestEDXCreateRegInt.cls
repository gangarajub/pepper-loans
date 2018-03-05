@isTest
public class TestEDXCreateRegInt {    
    @isTest static void EDXCreatePositiveMethod(){
        insert new ints__EDXCrtReg__c(ints__endpoint__c ='https://api.uat.esisweb.com.au/b2bapi/createregistrationbycontractyype',ints__username__c='pldev',ints__password__c='pplb2b',securedPartyGroupNumber__c='100135254' ,vehicleContractTypeCode__c='C10',refinanceContractTypeCode__c = 'C15',givingOfNoticeIdentifier__c='Equip ID or Vehicle Ref',sequenceNumber__c='1',serialNumberType__c='2');       
        Test.startTest();    
        string dummy ='abc';  
        /* create Collateral object*/
        clcommon__collateral__c collObj = new clcommon__collateral__c();
        collObj.active__c=false;
        Summary__c sumObj= new Summary__c();
        Registration__c regObj= new Registration__c();        
        collObj.clcommon__Vehicle_ID_Number__c='JT712YR2105100426';
        collObj.clcommon__Make__c=dummy;
        collObj.clcommon__Model__c=dummy;
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
        collObj.clcommon__Vehicle_Serial_Number__c='6G1FA8E58GL217424';
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
        EDXCreateRegIntegAPI chs = new EDXCreateRegIntegAPI(collObj.id);
        ints.EDXCreateRegIntegrationRes res= new ints.EDXCreateRegIntegrationRes();  
        chs.disReg();
        system.assertNotEquals(null,chs.getData());        
        system.assertNotEquals(null,chs.getColl());
        EDX_Register_Interest__c searchRes= chs.getInt();          
        system.assertNotEquals(null, searchRes);
        Test.stopTest();
    }  
}