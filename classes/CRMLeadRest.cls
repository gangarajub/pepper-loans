@RestResource(urlMapping='/CRM_GetServicibalityCalculation')
global with sharing class CRMLeadRest{

    global class ResponseHandler {
        
        public String status {get; set;}
        public String message {get;set;}
        public decimal calculation {get ; set;}
        public decimal finalLoanAmount {get ; set;}
        public boolean flag {get ; set;}
    } 
    public Static string ex ;

    @HttpPut
    global static ResponseHandler getBorrPowerFromLeadID(String leadid , String partyid)
    {
//-------------------------Read the Request from the URL----------------------------------------------------------

        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        ResponseHandler response = new ResponseHandler();
        crmCalculatingBorrowingPower.CalculationResponse result = new crmCalculatingBorrowingPower.CalculationResponse();
        try{
            if(partyid != null){
                result = crmCalculatingBorrowingPower.fetchBorrowingPower(leadid, partyid);
            }
            else{
                result = crmCalculatingBorrowingPower.fetchBorrowingPower(leadid, null);
            }
        }
        catch(exception e){
            ex = String.valueof(e);
            response.status = 'failed';
            response.message = ex;
            response.calculation = 0;
            response.finalLoanAmount = 0;
            response.flag = false;
        }
        
        
        if(result != null){
            response.status = 'success';
            response.message = 'calculation retrieved successfully';
            response.calculation=result.wrapBorrPower;
            response.finalLoanAmount = result.wrapLoanAmount;
            response.flag = result.wrapQualify;
        }
        else{
            response.status = 'failed';
            response.message = ex;
            response.calculation = 0;
            response.finalLoanAmount = 0;
            response.flag = false;
        }
        
        return response;
    }
    

}