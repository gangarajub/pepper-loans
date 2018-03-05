/**
* @author  Krishnanand Gupta(SaaSfocus)
* @version 1.0
* @since   2016-05-10 
* @Desc this is a wrapper class for transaction history
*/

public class WrpTransactionHistory
{
public String strPaymentStatus{get;set;}//Scheduled,Paid,Failed
public String strPaymentDate{get;set;}//Scheduled Date,Paid Date,Failed Date
public String strNextPaymentDate{get;set;}//Scheduled Date,Paid Date,Failed Date
public String strPaymentType{get;set;}//Recurring,One Off
public String strAmount{get;set;}
public String strRemaining{get;set;}
public String strRate{get;set;}
public WrpTransactionHistory(String strPaymentStatus,String strPaymentDate,String strNextPaymentDate,String strPaymentType,String strAmount,String strRemaining,String strRate)
{
  this.strPaymentStatus=strPaymentStatus;
  this.strPaymentDate=strPaymentDate;
  this.strNextPaymentDate=strNextPaymentDate;
  this.strPaymentType=strPaymentType;
  this.strAmount=strAmount;
  this.strRemaining=strRemaining;
  this.strRate=strRate;
}

}