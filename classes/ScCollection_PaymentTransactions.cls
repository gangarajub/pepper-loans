//  -------------------------------------------------------------------------------------------------------
//  This class would be used as a controller for the transaction page
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 13-OCT-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestPaymentTransactions
//  -------------------------------------------------------------------------------------------------------
public class ScCollection_PaymentTransactions 
{
    public ScCollection_PaymentTransactionsInput inputApi {get;set;}
    public ScCollection_PaymentTransactionOutput responseFromApi {get;set;}
    public ScCollection_PaymentTransactionErr errResponseFromApi {get;set;}
    
    public Task startTask {get;set;}
    public Task endTask {get;set;}
    
    public String strContractId {get;set;}
    public String apiResponse {get;set;}
    public String errMsg {get;set;}
    public Decimal totalDebits {get;set;}
    public Decimal totalCredits {get;set;}
    public Decimal closingBalance {get ;set;}
    public Decimal openingBalance {get;set;}
    public Boolean showPdf {get;set;}
    public String sourceSystem {get;set;}
    
    public List<collect__Loan_Account__c> Var_Contract {get;set;}
    public Map<Id,SObject> mapObjectData = new Map<Id,SObject>();
    
    // Variables for Address And Name --- Added by Vikas
    // For Mortgage Address Logic
    public String BorrowerAddress {get;set;}
    public String BorrowerName {get;set;}
    private List<collect__Loan_Account__c> Var_Address_Contract ;
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    
    public ScCollection_PaymentTransactions() 
    {    
        inputApi = new ScCollection_PaymentTransactionsInput();
        Var_Contract = new List<collect__Loan_Account__c>();
        startTask = new task();
        endTask = new task();
        errMsg = '';
        showPdf = false;
        sourceSystem = '';
        
        BorrowerAddress = '';
        BorrowerName = '';
        Var_Address_Contract = new List<collect__Loan_Account__c>();
        
        
        //get the Id from url parameter
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id'))) 
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
            
            //call common method to retrieve object name
            Set<Id> setContractId = new Set<Id>();
            setContractId.add(strContractId);
            
            //call api method of cls to get current open contract record
            mapObjectData = api.getContracts(setContractId);
            
            collect__Loan_Account__c objclcontract = (collect__Loan_Account__c) mapObjectData.get(strContractId);
            
            if(objclcontract != Null)
            {
                Var_Contract.add(objclcontract);
                
                inputApi.countryCode = 'AU';
                inputApi.recordPosition = 0;
                inputApi.recordCount = 1000;
                
                // Added by Vikas -- Address Logic
                BorrowerAddress = Var_Contract[0].ScCollection_Customer_Mailing_Address__c;
                BorrowerName = Var_Contract[0].ScCollection_Customer_Name__c;
                
                if(objclcontract.ScCollection_Source_System_Name__c == 'MORTGAGE')
                {
                    sourceSystem = 'mortgage';
                    //inputApi.lob = 'mortgage';    
                    inputApi.loanNumber = Integer.valueOf(objclcontract.Name.split('_')[0]);
                    inputApi.loanAccountNumber = Integer.valueOf(objclcontract.ScCollection_Contract_Split_Number__c);
                    
                    // Logic Added for Mortgage Address Logic -- Added by Vikas
                    if(inputApi.loanNumber != 0)
                    {
                        String AddressExternalID = objclcontract.Name.split('_')[0]+'_0';
                        Var_Address_Contract = [Select Id,Name,ScCollection_Customer_Mailing_Address__c,ScCollection_Customer_Name__c From collect__Loan_Account__c Where Name =:AddressExternalID];
                        if(Var_Address_Contract != Null && Var_Address_Contract.size() >0 )
                        {
                            BorrowerAddress = Var_Address_Contract [0].ScCollection_Customer_Mailing_Address__c;
                            BorrowerName = Var_Address_Contract [0].ScCollection_Customer_Name__c;
                        } 
                    }
                }
                else if(objclcontract.ScCollection_Source_System_Name__c == 'PAF')
                {
                    sourceSystem = 'paf';
                    //inputApi.lob = 'paf';    
                    inputApi.loanNumber = Integer.valueOf(objclcontract.collect__External_ID__c.split(':')[1]);
                    inputApi.loanAccountNumber = 0;
                }
            }
            
            
        }
    }

    public void fetchTransactions()
    {
        try
        {
            totalDebits = 0.00;
            totalCredits = 0.00;
            closingBalance = 0.00;
            openingBalance = 0.00;
            showPdf = true;
            errMsg = '';
            
                        
            if(startTask.ActivityDate == Null || endTask.ActivityDate == Null)
            {
                errMsg = 'Please provide values for start date and end date.';
                return;
            }   
            if(startTask.ActivityDate > System.Today() || endTask.ActivityDate > System.Today())
            {
                errMsg = 'Please enter the date value less than Today.';
                return;
            }
            if(startTask.ActivityDate > endTask.ActivityDate)
            {
                errMsg = 'Please enter a valid date range.';
                return;
            }
            
            Integer difference = startTask.ActivityDate.daysBetween(endTask.ActivityDate);
            if(difference >= 365)
            {
                errMsg = 'Date range can\'t be greater than 365 days.';
                return ;
            }

            String[] startArray = startTask.ActivityDate.format().split('/');
            String[] endArray   = endTask.ActivityDate.format().split('/');
            
            // setting the input as per the api
            inputApi.transactionStartDate = startArray[2] + startArray[1];
            inputApi.transactionEndDate = endArray[2] + endArray[1];
            if(startArray[0].length() == 1)
            {
                inputApi.transactionStartDate = inputApi.transactionStartDate + '0' + startArray[0];
            }
            else
            {
                inputApi.transactionStartDate = inputApi.transactionStartDate + startArray[0];
            }
            if(endArray[0].length() == 1)
            {
                inputApi.transactionEndDate = inputApi.transactionEndDate + '0' + endArray[0];
            }
            else
            {
                inputApi.transactionEndDate = inputApi.transactionEndDate + endArray[0];
            }
            
            String inputToApi = inputApi.parse();
            
            ScCollection_PaymentAPIParameters__c objScCollectionPaymentAPIParameters = ScCollection_PaymentAPIParameters__c.getInstance('ScCollection_PaymentAPIParameters');
            
            if(objScCollectionPaymentAPIParameters != null)
            {
                // make the request
                HttpRequest req = new HttpRequest();
                string endPoint = objScCollectionPaymentAPIParameters.Endpoint__c + '?lob=' + sourceSystem;
                system.debug('endpoint@@@'+endPoint);
                req.setEndpoint(endPoint);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objScCollectionPaymentAPIParameters.Username__c + ':' + objScCollectionPaymentAPIParameters.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setTimeout(120000);
                req.setbody(inputToApi);
                system.debug('response body@@@'+inputToApi);
                system.debug('request@@'+req);

                Http http = new Http();  
                HTTPResponse res = http.send(req);
                apiResponse = res.getBody();
                system.debug('apiResponse@@@'+apiResponse);
                if(res.getStatusCode() == 200)
                {
                    try
                    {
                        responseFromApi = ScCollection_PaymentTransactionOutput.parse(apiResponse);
                    }
                    catch(Exception e)
                    {
                        errMsg = 'Error Occured : Invalid response from API.' + e.getMessage() + '\n -Trace ' + e.getStackTraceString();
                        return ;
                    }

                    if(responseFromApi != Null)
                    {
                        // if we have some transactions
                        if(responseFromApi.transactions != NUll && responseFromApi.transactions.size() > 0)
                        {
                            // modify the date of transaction
                            for(ScCollection_PaymentTransactionOutput.cls_transactions tempTransaction:responseFromApi.transactions)
                            {
                                try
                                {
                                    String transactionDate = '' + tempTransaction.transactionDate;
                                    
                                    if(String.isNotEmpty(transactionDate))
                                    {
                                        if(transactionDate.trim().length() == 8)
                                        {
                                            // assuming the first four be the year
                                            String year_Temp = transactionDate.trim().left(4);
                                            String day_Temp = transactionDate.trim().right(2);
                                            Integer month_Temp = Integer.valueOf(transactionDate.trim().mid(4,2));
                                            datetime   Formatted_Date  ;
                                            Formatted_Date = datetime.newInstance(Integer.valueOf(year_Temp),Integer.valueOf(month_Temp),Integer.valueOf(day_Temp),00,00,00); 
                                            tempTransaction.date_transactionDate = Formatted_Date;
                                            
                                            if(sourceSystem == 'mortgage')
                                            {
                                                tempTransaction.str_transactionDate = Formatted_Date.format('dd-MMM-yyyy');
                                            }
                                            else if(sourceSystem == 'paf')
                                            {
                                                tempTransaction.str_transactionDate = Formatted_Date.format('EEEE ,dd MMMM yyyy');
                                            }
                                        }
                                    }

                                    tempTransaction.INT_transactionBalance = String.isNotEmpty(tempTransaction.transactionBalance)?Decimal.valueOf(tempTransaction.transactionBalance):Null;  

                                    if(tempTransaction.Debit != null)
                                    {
                                        totalDebits = totalDebits + tempTransaction.Debit;
                                    }
                                    if(tempTransaction.Credit != null)
                                    {
                                        totalCredits = totalCredits + tempTransaction.Credit;
                                    }
                                    if(responseFromApi.transactions[responseFromApi.transactions.size()-1] == tempTransaction && responseFromApi.transactions[responseFromApi.transactions.size()-1]!=null 
                                    && responseFromApi.transactions[responseFromApi.transactions.size()-1].INT_transactionBalance != null)
                                    {                                        
                                        openingBalance = responseFromApi.transactions[responseFromApi.transactions.size()-1].INT_transactionBalance;
                                    }
                                    if(responseFromApi.transactions[0] == tempTransaction && responseFromApi.transactions[0] != null 
                                    && responseFromApi.transactions[0].INT_transactionBalance != null)
                                    {
                                        closingBalance = responseFromApi.transactions[0].INT_transactionBalance;
                                    }
                                }
                                catch(Exception e)
                                {
                                    errMsg = 'Error Occured : ' + e.getMessage() + '\n -Trace ' + e.getStackTraceString();
                                    System.debug('@@@ - ' + e.getLineNumber()+'-- ' + e.getCause());
                                    return ;
                                }                             
                            }
                        } 
                        // Added Else condition 0n 1/12/2016, When no data is retrieved -- Added by Vikas
                        else{
                            errMsg = 'No transactions found for given criteria.';
                            return ;
                        }
                    }                    
                }
                else if(res.getStatusCode() == 404)
                {
                    errMsg = 'No transactions found for given criteria.';
                    return ;
                }
                else
                {
                    // assuming the error response
                    try
                    {
                        errResponseFromApi  = ScCollection_PaymentTransactionErr.parse(apiResponse);  
                        system.debug('errResponseFromApi@@@@'+errResponseFromApi);
                        
                        if(errResponseFromApi != Null)
                        {
                            if(errResponseFromApi.APIStatus != Null && errResponseFromApi.APIStatus.Messages != Null && errResponseFromApi.APIStatus.Messages.Message != Null )
                            {
                                errMsg = errMsg + errResponseFromApi.APIStatus.Messages.Message.MessageDescription;
                                return ;  
                            }
                            else
                            {
                                errMsg = 'Error Occured : '+apiResponse;
                                return;
                            }
                        }
                        else
                        {
                            // un handeled response
                            errMsg = 'Error Occured : '+apiResponse;
                            return;
                        }
                    }
                    catch(Exception e)
                    {
                        errMsg = 'Error Occured : '+e.getMessage()+'\n -Trace '+e.getStackTraceString();
                        return ;
                    }
                }
            }        
        }
        catch(Exception e)
        {
            errMsg = 'Error Occured : '+e.getMessage()+'\n -Trace '+e.getStackTraceString();
            return ;
        }
    }
    
    public PageReference OpenPdf()
    {
        PageReference pr = new PageReference('/apex/ScCollection_TransactionPDF');
        pr.setRedirect(false);
        return pr;
    }
}