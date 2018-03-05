public class CarHistorySearchAPI{
    public Map<String,String> requestMap =new Map<String,String>();    
    Summary__c sumObj= new Summary__c();
    Registration__c regObj= new Registration__c();
    clcommon__collateral__c collObj = new clcommon__collateral__c();
    ints.IntegrationRequestObject requestObj =new ints.IntegrationRequestObject();
    
    ints.CarHistoryIntegration carInt = new ints.CarHistoryIntegration();
    ints.CarHistoryResponse res = null;
    /*Input parameters are VIN and Application ID for API*/
    public CarHistorySearchAPI(String vin, String  appId, String vehicleType){
        ints__CarHistory__c setting = ints__CarHistory__c.getInstance(); 
        if(Setting == null || (Setting.ints__username__c== null || Setting.ints__password__c==null || Setting.ints__endpoint__c==null)){
            throw new ints.IntegrationException('Car history setting has not been set.'); 
        }if(vin==null|| vin==''){
            throw new ints.IntegrationException('VIN cant be blank or null');
        }if(appId== null|| appId==''){
            throw new ints.IntegrationException('Application Id cant be blank or null');
        }else{
            requestObj.requestMap.put('ved1:VIN', vin);
            requestObj.requestMap.put('ved1:Password', setting.ints__password__c);
            requestObj.requestMap.put('ved1:Username',setting.ints__username__c);
            System.debug('vehicleType : ' + vehicleType);
            if(vehicleType != null)
                requestObj.requestMap.put('ved1:VehicleType',vehicleType);
            requestObj.requestMap.put('ved1:ReportFormat', 'Xml'); 
            collObj.genesis__Application__c=appId;    
            collObj.active__c=false;
        }
    }
    
    /*API will return the collateral object wrt to VIN number*/
    public clcommon__collateral__c getCarDetails(){
        if(!Test.isRunningTest()){
            res=(ints.CarHistoryResponse) carInt.integrate(requestObj);          
        }else{
            res= new ints.CarHistoryResponse();
            ints.CarHistoryResponse.summary sumObj= new ints.CarHistoryResponse.summary();
            sumObj.stolen='Pass';
            sumObj.encumbrance='true';
            sumObj.odometer='Pass';
            sumObj.insurance='true';
            sumObj.registration='Pass';
            sumObj.writtenOff='True';
            ints.CarHistoryResponse.Registration regObj= new ints.CarHistoryResponse.Registration();
            regObj.registrationPlate='X76JK';
            regObj.registrationExpiryDate='19-11-2016';
            regObj.registrationState='SA';       
            res.sum.add(sumObj);
            res.reg.add(regObj);
            res.rawResponse='testResponse';
            res.rawRequest='testRequest';            
        }                
         /*Summary Object Information*/       
        sumObj.stolen__c=res.sum[0].stolen.trim();
        sumObj.writtenOff__c=res.sum[0].writtenOff.trim();       
        sumObj.encumbrance__c= res.sum[0].encumbrance.trim();
        sumObj.odometer__c = res.sum[0].odometer.trim();
        sumObj.insurance__c = res.sum[0].insurance.trim();
        sumObj.registration__c= res.sum[0].registration.trim();        
        upsert sumObj;
        /*registration object information*/        
        regObj.registration_Plate__c=res.reg[0].registrationPlate;
        regObj.registration_Expiry_Date__c=res.reg[0].registrationExpiryDate;
        regObj.registration_State__c=res.reg[0].registrationState;       
        insert regObj;
        collObj.Summary__c=sumObj.id;
        collObj.clcommon__Vehicle_ID_Number__c=res.vin;
        collObj.clcommon__Make__c=res.make;
        collObj.clcommon__Model__c=res.model;
        collObj.clcommon__Style__c=res.body;
        collObj.clcommon__Year__c=res.firstRetailYear;
        collObj.clcommon__Vehicle_Color__c=res.colour;
        collObj.clcommon__Collateral_Name__c='My Vehicle';
        collObj.Vehicle_Series__c=res.series;
        collObj.Vehicle_Type__c=res.vehicleType;
        collObj.transmission__c=res.transmission;        
        collObj.integration_Error_Status__c=res.integrationErrorStatus;
        collObj.integration_Error_Status_Code__c=res.integrationErrorStatusCode;
        collObj.ppsr_Search_Certificate_Number__c=res.ppsrSearchCertificateNumber;
        collObj.message__c=res.message;
        collObj.Variant__c=res.variant;      
        
        
       
        
        collObj.Registration__c=regObj.id;
         upsert collObj;
        //system.debug(collObj.id);
        /*attachment for response*/
        Attachment attachRes = new Attachment();
        attachRes.Body = Blob.valueOf((String)res.rawResponse);
        attachRes.name =  'Car History response body - ' + datetime.now() + '.xml';
        attachRes.parentId = collObj.id;
        attachRes.contentType = 'text/xml';
        insert attachRes;
        /*attachment for request*/
        Attachment attachReq = new Attachment();
        attachReq.Body = Blob.valueOf((String)res.rawRequest);
        attachReq.name =  'Car History request body - ' + datetime.now() + '.xml';
        attachReq.parentId = collObj.id;
        attachReq.contentType = 'text/xml';
        insert attachReq; 
        collObj = [select Id,clcommon__Vehicle_ID_Number__c,clcommon__Make__c,clcommon__Model__c,
                     clcommon__Style__c,clcommon__Year__c,clcommon__Collateral_Name__c,
                     Vehicle_Series__c,Vehicle_Type__c,transmission__c,integration_Error_Status__c,
                     integration_Error_Status_Code__c,ppsr_Search_Certificate_Number__c,
                     message__c,Variant__c,Registration__c,Summary__c,pep_Registration_Number__c,
                     pep_State_of_Registration__c,Red_Book_Vehicle_Series__c,Is_Dealer_Purchased__c,
                     pep_User_Selected_Vehicle__c,pep_User_Selected_Make__c,pep_User_Selected_Model__c from clcommon__Collateral__c where id=:collObj.id];    
        return collObj;
    }
}