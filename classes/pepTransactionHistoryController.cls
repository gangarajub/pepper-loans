/**
* @author  Krishnanand Gupta(SaaSfocus)
* @version 1.0
* @since   2016-05-10 
* @Desc this class is used to generate loan transaction history
*/
public class pepTransactionHistoryController 
{
//public String test{get;set;}

public Integer intPageNumber{get;set;}
public List<WrpTransactionHistory> lstSetController{get;set;}
public List<Integer> lstIntBar{get;set;}

Integer Page_Size;//defining total elements for one page default is 10
public Integer Total_Pages{get;set;}//storing total pages for loan transactions
Integer Bar_Size;//defining  number bar size default is 5
pepIterable obj;
public String Page_Name{get;set;}
public String Page_Label{get;set;}
  public pepTransactionHistoryController()
  {
      
      page_Name = 'pepTransactionHistory';
      Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
      lstSetController = new List<WrpTransactionHistory>();
      lstIntBar=new List<Integer>();
      
      List<WrpTransactionHistory>  lstWrapper =  new List<WrpTransactionHistory>();
      Page_Size=10;
      Bar_Size=5;
     String  ID_Contract=pepUtilityClass.getLoanAccountId(pepUtilityClass.getAccountId());
     if(ID_Contract==null || ID_Contract=='')
     ID_Contract=apexpages.currentpage().getParameters().get('id');//a3iN0000000gzpv
     
     // peer.BorrowerAPI12 b = peer.FractionalizationAPIFactory.getBorrowerAPI12();
      //loan__Loan_Account__c  loanAccount = b.getLoanAccountWithStatements(ID_Contract, 'loan__Interest_Rate__c,loan__Account_Type__c, loan__Accrual_Start_Date__c',new Set<String>{'Active - Good Standing'}, 'loan__Balance__c,loan__Automated_Payment_Setup__r.loan__Type__c','','', '','');
     System.debug('HelloI='+ID_Contract);
     peer.BorrowerAPI12 b = peer.FractionalizationAPIFactory.getBorrowerAPI12();
      loan__Loan_Account__c  loanAccount = b.getLoanAccountWithStatements(ID_Contract, 'loan__Interest_Rate__c,loan__Account_Type__c, loan__Accrual_Start_Date__c',new Set<String>{'Active - Bad Standing','Active - Good Standing','Active - Matured','Approved','Canceled','Closed - Obligations met','Closed - Premature','Closed - Refinanced','Closed- Written Off','Invalid','Partial Application','Pending Approval','Hardship'}, 'loan__Balance__c,loan__Automated_Payment_Setup__r.loan__Type__c','','', '','');
     
  
       LoanActions action = new LoanActions();
        List<loan__Automated_Payment_Setup__c> aps = action.getAPSHistory(ID_Contract,true);
        String rate=string.valueof([Select id,loan__Interest_Rate__c from loan__Loan_Account__c where id=:ID_Contract].loan__Interest_Rate__c.setscale(2));
        for(loan__Automated_Payment_Setup__c objPaymentSetup: aps)
        {
        String pType=objPaymentSetup.loan__Type__c!=null?strPaymentType(objPaymentSetup.loan__Type__c):'null';
        Date paymentDate=pType=='nextPay'?objPaymentSetup.loan__Recurring_ACH_Start_Date__c:objPaymentSetup.loan__Debit_Date__c;
        //lstWrapper.add(new WrpTransactionHistory('schedule',paymentDate!=null?strPaymentDate(paymentDate):'null',objPaymentSetup.loan__Debit_Date__c!=null?strPaymentDate(objPaymentSetup.loan__Debit_Date__c):'null',pType,string.valueof(objPaymentSetup.loan__Transaction_Amount__c!=null?objPaymentSetup.loan__Transaction_Amount__c.format():'null'),'TBD',(string.valueof(loanAccount.loan__Interest_Rate__c)!=null?string.valueof(loanAccount.loan__Interest_Rate__c.setscale(2)):'null')+'%'));//string.valueof(objPaymentSetup.loan__CL_Contract__r.loan__Interest_Rate__c)
       System.debug('HelloI='+loanAccount);
        lstWrapper.add(new WrpTransactionHistory('schedule',paymentDate!=null?strPaymentDate(paymentDate):'null',objPaymentSetup.loan__Debit_Date__c!=null?strPaymentDate(objPaymentSetup.loan__Debit_Date__c):'null',pType,amount_format(objPaymentSetup.loan__Transaction_Amount__c),'TBD',rate+'%'));//string.valueof(objPaymentSetup.loan__CL_Contract__r.loan__Interest_Rate__c)
        
        }

      //test=loanAccount.loan__Loan_Payment_Transactions__r[0].loan__Automated_Payment_Setup__r.loan__Type__c;
     if(loanAccount!=null && loanAccount.loan__Loan_Payment_Transactions__r!=null)
     { 
      for(loan__Loan_Payment_Transaction__c objPayment: loanAccount.loan__Loan_Payment_Transactions__r)
      {
      
       //for(Integer i=0;i<50;i++)
       //{
        lstWrapper.add(new WrpTransactionHistory(paymentStatus(objPayment.loan__Cleared__c,objPayment.loan__Rejected__c,objPayment.loan__Reversed__c),objPayment.loan__Transaction_Date__c!=null?strPaymentDate(objPayment.loan__Transaction_Date__c):'null','TBD',objPayment.loan__Automated_Payment_Setup__r.loan__Type__c!=null?strPaymentType(objPayment.loan__Automated_Payment_Setup__r.loan__Type__c):'null',amount_format(objPayment.loan__Transaction_Amount__c),amount_format(objPayment.loan__Balance__c),'TBD'));
      // }
      }
     }
    
      if(lstWrapper.size()==0)
       lstWrapper.add(new WrpTransactionHistory('null','','','','','',''));
       
      
     obj = new pepIterable(lstWrapper); 
     obj.setPageSize = Page_Size;
     Total_Pages=integer.valueof(lstWrapper.size()/Page_Size)+(math.mod(lstWrapper.size(),Page_Size)!=0?1:0);
     intPageNumber=1;
     Bar_Size=Total_Pages>Bar_Size?Bar_Size:Total_Pages;
     numberBar(intPageNumber);
     lstSetController = obj.next();
     
   
  
  }
 
String paymentStatus(Boolean cleared,Boolean rejected,Boolean reversed)
{
 return ((!cleared && !rejected && !reversed)?'process':((!rejected  && reversed && cleared)||(rejected && !reversed && !cleared)?'fail':(cleared && !rejected  && !reversed?'paid':'')));
}
String strPaymentDate(Date paymentDate)
{
 return paymentDate.day()+'/'+paymentDate.month()+'/'+paymentDate.year();
}
String strPaymentType(String pType)
{
 return pType=='RECURRING'?'nextPay':'offPayment';
}

String amount_format(Decimal amount)
{
 String strAMT=string.valueof(amount!=null?amount.setscale(2).format():'null');
 return strAMT!='null' &&strAMT.contains('.')?strAMT:(strAMT+'.00');
}
 
 
/**
* @return This method returns true if list has more elements
*/
  public Boolean hasNext {
        get 
        {
            return obj.hasNext();
        }
        set;
    }
    
/**
* @return This method returns true if list has Previous page's elements
*/       
    public Boolean hasPrevious {
        get 
        {
            return obj.hasPrevious();
        }
        set;
    }
/**
* This method is used to set next elements in wrapper
*/        
    public void next() 
    {
        lstSetController = obj.next();
        intPageNumber++;
        if(intPageNumber>5)
        {
         numberBar(intPageNumber);
        }
    }
/**
* This method is used to set previous elements in wrapper
*/         
    public void previous() 
    {
        lstSetController = obj.previous();
        intPageNumber--;
        if(intPageNumber>=5)
        {
         numberBar(intPageNumber);
        }
    }
/**
* This method is used to set elements for specific page number
*/ 
    public void GoTo() 
    {
        lstSetController = obj.goToPage(intPageNumber);
        if(intPageNumber==5)
        {
         numberBar(intPageNumber);
        }
    }
 /**
   * This method is used to set Number Bar list
   * @param intPageNumber This is the  paramter to  define the specific page number
   * @return void 
   */      
    public void numberBar(Integer intPageNumber)
    {
    lstIntBar.clear(); 
    integer loopVar=1;
       for(integer start =(intPageNumber>Bar_Size?intPageNumber-Bar_Size+1:1);loopVar<=Bar_Size;start++)
         {
           lstIntBar.add(start);
           loopVar++;
         }
    } 
}