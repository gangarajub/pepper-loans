@isTest
global class ScCollection_TestPaymentTransactionsMock implements HttpCalloutMock {
    public Integer code;
    public ScCollection_TestPaymentTransactionsMock(Integer code) {
            this.code = code;
           
        }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        ScCollection_PaymentTransactionOutput.cls_transactions objInnerOutput = new ScCollection_PaymentTransactionOutput.cls_transactions();
        objInnerOutput.transactionGroupCode='PAY';
        objInnerOutput.transactionGroupDescription='Payments';
        objInnerOutput.transactionGroupClass='F';
        objInnerOutput.transactionType='PDR';
        objInnerOutput.transactionTypeDescription='Payment';
        objInnerOutput.loanVariationNumber='00000';
        objInnerOutput.transactionDate=20160915;
        objInnerOutput.str_transactionDate='20160915';
        objInnerOutput.date_transactionDate = System.now();
        objInnerOutput.transactionAmount = 0000002242;
        objInnerOutput.transactionBalance = '00006525587';
        objInnerOutput.INT_transactionBalance=0;
        objInnerOutput.Debit = 0000002242;
        objInnerOutput.Credit = 00006525587;
        objInnerOutput.paymentDue = 11;
        objInnerOutput.totalArrears = 2222;
        objInnerOutput.transactionStatus = 'OK';
        objInnerOutput.createAuditTime = '143002';
        objInnerOutput.reversalReasonCode = '143002';
        objInnerOutput.reversalSystemUser = '143002';
        objInnerOutput.interestRate = 00000;
        objInnerOutput.createAuditDate =20160915;

        List<ScCollection_PaymentTransactionOutput.cls_transactions> lst = new List<ScCollection_PaymentTransactionOutput.cls_transactions>();
        lst.add(objInnerOutput);
        ScCollection_PaymentTransactionOutput objOutput = new ScCollection_PaymentTransactionOutput();
        objOutput.loanNumber = '2000061';
        objOutput.loanAccountNumber='1';
        objOutput.transactionStartDate=20160601;
        objOutput.transactionEndDate=20161005;

        objOutput.transactions = lst;

        String str = JSON.serialize(objOutput); 
        
        
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(str);
        res.setStatusCode(code);
        return res;
    }
}