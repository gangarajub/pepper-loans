//  -------------------------------------------------------------------------------------------------------
//  This class would be used as an errorResponse handler for payment transactions page
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 19-OCT-2016   Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestPaymentTransactions
//  -------------------------------------------------------------------------------------------------------
public class ScCollection_PaymentTransactionErr
{
    public cls_APIStatus APIStatus;
    
    public class cls_APIStatus 
    {
        public String APICode;  //ERROR
        public String APIDescription;   //Error Response
        public cls_PepperReferences PepperReferences;
        public cls_Messages Messages;
    }
    
    public class cls_PepperReferences 
    {
        public cls_PepperReference PepperReference;
    }
    
    public class cls_PepperReference 
    {
        public String ReferenceType;    //Correlation Id
        public String Reference;    ///transactions:POST:fe35c5b0-95cd-11e6-988e-0637afd39011
    }
    
    public class cls_Messages 
    {
        public cls_Message Message;
    }
    
    public class cls_Message 
    {
        public String MessageCode;  //ERROR
        public Integer MessageId;   //400
        public String MessageDescription;   
    }

    // this method would parse the output of the api
    public static ScCollection_PaymentTransactionErr parse(String json)
    {
        return (ScCollection_PaymentTransactionErr) System.JSON.deserialize(json, ScCollection_PaymentTransactionErr.class);
    }
}