//  -------------------------------------------------------------------------------------------------------
//  This class would be used to deserialize the out parameters from the response
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 13-OCT-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestPaymentTransactions
//  -------------------------------------------------------------------------------------------------------
public class ScCollection_PaymentTransactionOutput 
{
    public String loanNumber;   //2000061
    public String loanAccountNumber;    //1
    public Integer transactionStartDate;    //20160601
    public Integer transactionEndDate;  //20161005

    public cls_transactions[] transactions{get;set;}
    
    public class cls_transactions 
    {
        public String transactionGroupCode{get;set;}    //PAY
        public String transactionGroupDescription{get;set;} //Payments
        public String transactionGroupClass{get;set;}   //F
        public String transactionType{get;set;} //PDR
        public String transactionTypeDescription{get;set;}  //Payment
        public String loanVariationNumber{get;set;} //00000
        public Integer transactionDate{get;set;}    //20160915
        public String str_transactionDate{get;set;} //20160915
        public Datetime     date_transactionDate{get;set;}  //20160915
        public Decimal transactionAmount{get;set;}  //0000002242O
        public String transactionBalance{get;set;}  //00006525587
        public Decimal INT_transactionBalance{get;set;}
        public Decimal Debit{get;set;}  //0000002242O
        public Decimal Credit{get;set;} //00006525587
        public Decimal paymentDue{get;set;}
        public Decimal totalArrears{get;set;}
        public String transactionStatus{get;set;}   //
        public Decimal interestRate{get;set;}   //00000
        public Integer createAuditDate; //20160915
        public String createAuditTime{get;set;} //143002
        public String reversalReasonCode{get;set;}  //
        public String reversalSystemUser{get;set;}  //
    }
    
    public static ScCollection_PaymentTransactionOutput parse(String json)
    {
        return (ScCollection_PaymentTransactionOutput) System.JSON.deserialize(json, ScCollection_PaymentTransactionOutput.class);
    }   
}