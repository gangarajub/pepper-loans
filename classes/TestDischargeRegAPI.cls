@isTest
public class TestDischargeRegAPI {    
    @isTest static void EDXCreatePositiveMethod(){
        insert new ints__EDXDisInt__c(ints__endpoint__c ='http://api.esis.mhi.nz/b2bapi/dischargeregistration',ints__username__c='pldev',ints__password__c='pplb2b',securedPartyGroupNumber__c='100135254');       
        Test.startTest();    
        string dummy ='abc';  
        /* create Collateral object*/
        clcommon__collateral__c collObj = new clcommon__collateral__c();
        collObj.active__c=false;
        Summary__c sumObj= new Summary__c();
        Registration__c regObj= new Registration__c();        
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
        collObj.clcommon__Vehicle_Serial_Number__c='6G1FA8E58GL217424';
        collObj.message__c=dummy;
        collObj.Variant__c=dummy;  
        collObj.EDXRegNumber__c='20192744422';
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
        EDXDischargeRegistrationAPI chs = new EDXDischargeRegistrationAPI(collObj.id);
        ints.EDXDischargeResponse res= new ints.EDXDischargeResponse();  
        chs.disReg();
        system.debug(chs.getData());    
        system.debug(chs.getColl());
        EDX_Discharge_Response__c searchRes= chs.getDis();          
        system.debug(searchRes);
        Test.stopTest();
    }  
}