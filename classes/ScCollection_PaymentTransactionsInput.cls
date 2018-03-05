//  -------------------------------------------------------------------------------------------------------
//  This class would act as a json serializer of input from the controller
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 12-OCT-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestPaymentTransactions
//  -------------------------------------------------------------------------------------------------------
public class ScCollection_PaymentTransactionsInput 
{
    public String countryCode{get;set;} //AU
    public Integer loanNumber{get;set;} //1231
    public Integer loanAccountNumber{get;set;}  //2
    public String transactionStartDate{get;set;}    //20161001
    public String transactionEndDate{get;set;}  //20161005
    public Integer recordCount{get;set;}    //100
    public Integer recordPosition{get;set;} //0
    public String lob{get;set;} //0

    // this method would serialize the input
    public  String parse()
    {
        return  System.JSON.serialize(this);
    }
}