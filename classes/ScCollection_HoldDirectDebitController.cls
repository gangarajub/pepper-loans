/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_HoldDirectDebitController 
Company:       Saasfocus
Description:   This class is use to sync hold DD payments.
History
Date    :  22/12/2017     
------------------------------------------------------------*/
public class ScCollection_HoldDirectDebitController{
    
    public collect__Contract_Status__c objStatus{get;set;}
    public String strContractId{get;set;}
    public String strObjectName{get;set;}
    public String strSourceSystem{get;set;}
    public String strContractName{get;set;}
    public String strTabId {get;set;}
    public String strRefresh {get;set;}
    public String strUnhold {get;set;}
    
    public Boolean showSubmit {get;set;}
    public Boolean disableButton {get;set;}
    public Map<Id,Sobject> mapResult = new Map<Id,Sobject>();
    public Set<Id> setContractId = new Set<Id>();
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    collect.API1 api1 = collect.APIFactory.getAPI1();
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          actionFunc
    Company:       Saasfocus
    Description:   This method is use to get parameter from url and assign the values to the variables.
    Inputs:        no input
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public void actionFunc(){
        strContractId = '';
        strObjectName = '';
        strSourceSystem = '';
        strContractName = '';
        strTabId = '';
        strRefresh = '';
        strUnhold = '';
        showSubmit = true;
        
        strContractId = ApexPages.currentPage().getParameters().get('conId');
        
        //get the parent tab id for console refresh functionality
        if(ApexPages.currentPage().getParameters().get('tabid') != Null && ApexPages.currentPage().getParameters().get('tabid') != '')
        {
            strTabId = ApexPages.currentPage().getParameters().get('tabid');
        }
        if(ApexPages.currentPage().getParameters().get('refresh') != Null && ApexPages.currentPage().getParameters().get('refresh') != '')
        {
            strRefresh = ApexPages.currentPage().getParameters().get('refresh');
            showSubmit = false;
        }
        if(ApexPages.currentPage().getParameters().get('unhold') != Null && ApexPages.currentPage().getParameters().get('unhold') != ''){
            strUnhold = ApexPages.currentPage().getParameters().get('unhold');
            showSubmit = false;
        }
        
        system.debug(strContractId );
        strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            
        setContractId.add(strContractId);
        
        if(strObjectName == 'loan__Loan_Account__c'){
            strSourceSystem = 'CL Loan';
        }
        else if(strObjectName == 'collect__Loan_Account__c'){
            //call api method of cls to get current open contract record
            mapResult = api.getContracts(setContractId);
            
            collect__Loan_Account__c objcnt = (collect__Loan_Account__c)mapResult.get(strContractId); 
                    
            //assign contract name
            strContractName = objcnt.Name;
            
            if(objcnt != Null && objcnt.collect__Source_System__c != Null)
            {
                strSourceSystem = [select Id, Name from collect__Source_System__c where Id =: objcnt.collect__Source_System__c].Name;
            }
        }
    }
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          actionFunc
    Company:       Saasfocus
    Description:   This method is use to get the extension constructor initializes the private member.
    Inputs:        ApexPages.StandardController
    Returns:       
    -----------------------------------------------------------------------------------*/
    public ScCollection_HoldDirectDebitController(ApexPages.StandardController stdController) {
        disableButton = false;
        if(stdController != null){
            this.objStatus = (collect__Contract_Status__c)stdController.getRecord();
            if(ApexPages.currentPage().getParameters().get('unhold') != Null && ApexPages.currentPage().getParameters().get('unhold') != ''){
                strUnhold = ApexPages.currentPage().getParameters().get('unhold');
                showSubmit = false;
            }
        
            if(objStatus.ScCollection_Promise_Hold_From__c == null && String.isBlank(strUnhold)){
                objStatus.ScCollection_Promise_Hold_From__c = System.today() +1;
                
                if(objStatus.ScCollection_Promise_Hold_To__c == null){
                    
                    disableButton = true;
                    system.debug('disableButton ='+disableButton);
                }
            }
        }
            
        
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SubmitData
    Company:       Saasfocus
    Description:   This method is use to validate the data and make a sync call.
    Inputs:        
    Returns:       PageReference
    -----------------------------------------------------------------------------------*/
    public PageReference SubmitData(){
        
        if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Hold_Direct_Debit')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Execution Custom Setting is disabled. Contact your System Admin.'));
            return Null; 
        }
        
        if(!String.isBlank(strSourceSystem) && strSourceSystem.equalsIgnoreCase('PAF')){
            
            //calling method which has the API request
            String strResponse = submitHold();
            if(!String.isBlank(strResponse) && strResponse == 'Success'){
                update objStatus;
                PageReference pr = new PageReference('/apex/ScCollection_HoldDirectDebit?id=' +objStatus.Id + '&conId=' +strContractId +'&tabid=' + strTabId + '&refresh=1');
                pr.setRedirect(true);
                return pr;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strResponse));
                return Null;
            }
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Source System is is Not PAF.'));
        return Null;
        
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          UnholdData
    Company:       Saasfocus
    Description:   This method is use to update the dates to null.
    Inputs:        
    Returns:       PageReference
    -----------------------------------------------------------------------------------*/
    public PageReference UnholdData(){
        if(!String.isBlank(strSourceSystem) && strSourceSystem.equalsIgnoreCase('PAF')){
            if(objStatus.ScCollection_Promise_Hold_From__c != null || objStatus.ScCollection_Promise_Hold_To__c != null){
                objStatus.ScCollection_Promise_Hold_From__c = null;
                objStatus.ScCollection_Promise_Hold_To__c = null;
                update objStatus;
            }
            PageReference pr = new PageReference('/apex/ScCollection_HoldDirectDebit?id=' +objStatus.Id + '&conId=' +strContractId +'&tabid=' + strTabId + '&refresh=1'+'&unhold=1');
            pr.setRedirect(true);
            return pr;
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Source System is is Not PAF.'));
        return Null;
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          submitHold
    Company:       Saasfocus
    Description:   This method is use to make an API request and process the response.
    Inputs:        
    Returns:       Sting
    -----------------------------------------------------------------------------------*/
    public String submitHold(){
        
        String strHoldDD = 'HoldDirectDebitPAF';
        ScCollection_PaymentAPIParameters__c objCredential;
        
        User ObjUsr = [Select Id,Email,Name,FirstName,LastName From User where Id = :UserInfo.GetUserID()];
        
        String strUserName = '';
        if(!String.IsBlank(ObjUsr.FirstName)){
            strUserName = ObjUsr.FirstName.substring(0,1);
        }
        strUserName += ObjUsr.LastName;
        Integer userNameSize = strUserName.Length();
        if(userNameSize > 20){
            strUserName = strUserName.substring(0,20);
        }
        
        String strTodaysdate = System.Now().format('yyyy-MM-dd');
        
        String strFromDate = DateTime.newInstance(objStatus.ScCollection_Promise_Hold_From__c.Year(), objStatus.ScCollection_Promise_Hold_From__c.Month(),objStatus.ScCollection_Promise_Hold_From__c.Day()).format('yyyy-MM-dd');
        
         String strToDate = DateTime.newInstance(objStatus.ScCollection_Promise_Hold_To__c.Year(), objStatus.ScCollection_Promise_Hold_To__c.Month(),objStatus.ScCollection_Promise_Hold_To__c.Day()).format('yyyy-MM-dd');
         
        //creating wrapper obj
        DirectDebitCreateWrapper.AuditInformation objAuditInfo = new DirectDebitCreateWrapper.AuditInformation(strUserName,strTodaysdate);
        
        DirectDebitCreateWrapper.PaymentInformation objPaymentInfo = new DirectDebitCreateWrapper.PaymentInformation(null,null,null,null,strFromDate,strToDate,null); 
        
        DirectDebitCreateWrapper objSyncDDWrapper = new DirectDebitCreateWrapper();
        objSyncDDWrapper.auditInformation = objAuditInfo;
        objSyncDDWrapper.paymentInformation = objPaymentInfo;
        
        String strRequestBody = JSON.serialize(objSyncDDWrapper);
        
        System.debug('strRequestBody '+strRequestBody);
        objCredential = ScCollection_PaymentAPIParameters__c.getValues(strHoldDD);
        if(!String.IsBlank(strRequestBody) && objCredential != null){
            try{
                String strEndPoint = objCredential.Endpoint__c;
                strEndPoint = strEndPoint.replace('{loanID}',strContractName);
                Http objhttp = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(strEndPoint);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objCredential.Username__c+ ':' + objCredential.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('request-id', ScCollection_CommonCodeHandler.GenerateUniqueRandomNumber());
                req.setTimeout(120000);
                req.setBody(strRequestBody);
                HttpResponse res = objhttp.send(req);
                System.debug('req '+req);
                system.debug('res.getStatusCode() '+res.getStatusCode());
                if(res.getStatusCode() == 200){
                    
                    return 'Success';
                    
                }
                else{
                    if(res.getStatusCode() == 504){
                        return 'Critical Error – Sync Failure';
                    }
                    if(res.getStatusCode() == 404){
                        return '404 resource not found.';
                    }
                    else{
                        system.debug('response Error Body =='+res.getBody());
                        String apiResponse =  res.getBody();
                        
                        ScCollection_CreatePTPController objErrorResponse = ScCollection_CreatePTPController.parse(apiResponse);
                        if(objErrorResponse != null && objErrorResponse.errors != null && objErrorResponse.errors.Size() > 0){
                            String strResError = 'Error !! ';
                            for(ScCollection_CreatePTPController.Error objError : objErrorResponse.errors){
                                strResError += objError.description + ' ';
                            }
                            return strResError;
                            
                        }
                    }
                        
                    return 'Error !! Response Code '+res.getStatusCode();
                    
                }
                
            }
            catch(Exception ex){
                system.debug(ex.getMessage() + '-' +ex.getStackTraceString());
                return ex.getMessage();
            }
        }
        
        return 'Some Error has occurred in the process. Please check the Custom setting or contact system admin.';
    }
    
}