// ---------------------------------------------------------------------------------------------------------
// This class is  used to update the repayment amount of users. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      28th Apr 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------

public class pepAdjustRepaymentsController
{

public String minimumRepayment{get;set;}
public String additionalAmountLabel{get;set;}
public String enterAdditionalAmount{get;set;}
public String Section3{get;set;}
public String totalRepayment{get;set;}
public Decimal loanTerm{get;set;}
public Boolean showAdditionalAmount{get;set;}
public Boolean showUpdateButton{get;set;}
public Boolean successMsg{get;set;}
public Boolean errorMsg{get;set;}
loan__Loan_Account__c objLoanAccount;
loan__Automated_Payment_Setup__c objAutomatedPayment;
public List<Data> data {get;set;}
List<decimal> onloadDataList;
List<loan__Loan_Account__c> loanContractList ;
List<loan__Automated_Payment_Setup__c> APSList;
List<date> apsDateList;
Map<date,loan__Automated_Payment_Setup__c> apsMap;
String duplicateSection3;
Decimal totalAdditionalAmt;
String additionalAmount;
String total;
String loanAccountId;
Decimal monthlyAmount = 0;
integer counter = 0;
public String Page_Name{get;set;}
public String Page_Label{get;set;}
public  String paymentFrequency{get;set;}

 // This is used to call API methods to get loan contract and to assign values to some variables.
 
  public pepAdjustRepaymentsController()
  {
  
         page_Name = 'pepAdjustRepayments';
         Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
         minimumRepayment = '0';
         additionalAmount = '0';
         totalRepayment = '0';
         loanTerm = 0;
         enterAdditionalAmount = '';
         additionalAmountLabel ='0';
         totalAdditionalAmt = 0;
         Section3 ='';
         duplicateSection3 = '';
        // paymentFrequency = '';
         showAdditionalAmount = false;
         errorMsg = false;
         showUpdateButton = true;
         loanContractList = new List<loan__Loan_Account__c>();
         APSList = new List<loan__Automated_Payment_Setup__c>();
         apsDateList = new list<date>();
         apsMap = new Map<date,loan__Automated_Payment_Setup__c>();
         objLoanAccount = new loan__Loan_Account__c();
         objAutomatedPayment = new loan__Automated_Payment_Setup__c();
         data = new List<Data>();
         onloadDataList = new List<decimal>();
         String idAccount = pepUtilityClass.getAccountId(); // To get account id of currently logged in user.
         if(string.isNotBlank(idAccount))
            loanAccountId = pepUtilityClass.getLoanAccountId(idAccount); // To get the id of current contract
         if(string.isNotBlank(loanAccountId))
             loanContractList = pepUtilityClass.getLoanContract(loanAccountId); // To get data corresponding to current contract id.
        
    if(loanContractList.size()>0)
     {
             
              for (loan__Loan_Account__c instanceLoanAccount:loanContractList)
                {
                        objLoanAccount = instanceLoanAccount;
                        system.debug('loanAccountIs'+objLoanAccount);
                        for(loan__Automated_Payment_Setup__c automated : instanceLoanAccount.loan__Automated_Payment_Setup__r) 
                         {
                             if(automated.loan__Type__c =='RECURRING')
                                apsMap.put(automated.loan__Debit_Date__c,automated);      
                         }
                }
              
                if(apsMap.keySet().size()>0)
                  {
                       apsDateList.addAll(apsMap.keySet());
                       apsDateList.sort();
                  }
                   
                 if(apsDateList.size()>0)
                  {
                      objAutomatedPayment  =  apsMap.get(apsDateList.get(apsDateList.size()-1));
                  }
              system.debug('objAutomatedPaymentIs'+objAutomatedPayment);
                if(objLoanAccount.loan__Pmt_Amt_Cur__c!=null && String.isNotBlank(objAutomatedPayment.loan__Frequency__c))
                {
                     //  minimumRepayment = ((objLoanAccount.loan__Pmt_Amt_Cur__c).setScale(2)).format();
                         paymentFrequency = objAutomatedPayment.loan__Frequency__c.toLowerCase();
                         total = ((objLoanAccount.loan__Pmt_Amt_Cur__c).setScale(2)).format();
                         if((objAutomatedPayment.loan__Frequency__c).toLowerCase()=='bi-weekly')
                         {
                            paymentFrequency = 'fortnightly';
                         }
                              minimumRepayment = ((objLoanAccount.loan__Pmt_Amt_Cur__c).setScale(2)).format() ;
                              totalRepayment = minimumRepayment;
                              getData(objLoanAccount.loan__Pmt_Amt_Cur__c);
                }
              
               if(objAutomatedPayment.loan__Transaction_Amount__c!=null && String.isNotBlank(objAutomatedPayment.loan__Frequency__c))
               {
                    
                    if(objAutomatedPayment.loan__Frequency__c=='weekly')
                       monthlyAmount= (objAutomatedPayment.loan__Transaction_Amount__c)*4;
                    else if(objAutomatedPayment.loan__Frequency__c=='bi-weekly')
                       monthlyAmount= (objAutomatedPayment.loan__Transaction_Amount__c)*2;
                    else if(objAutomatedPayment.loan__Frequency__c=='monthly')
                       monthlyAmount= (objAutomatedPayment.loan__Transaction_Amount__c);
                       
                       if(monthlyAmount-objLoanAccount.loan__Pmt_Amt_Cur__c>1)
                       {
                           system.debug('Notcome');
                           additionalAmount = ((monthlyAmount-objLoanAccount.loan__Pmt_Amt_Cur__c).setScale(2)).format(); 
                           additionalAmount = additionalAmount.replace(',','');
                           totalRepayment = totalRepayment.replace(',','');
                           system.debug('additionalAmount' + decimal.valueof(additionalAmount) );
                           system.debug('totalRepayment Swati' + decimal.valueof(totalRepayment));
                           Decimal additionalAmt =0;
                           
                           if(objAutomatedPayment.loan__Frequency__c=='weekly')
                           additionalAmt  = (monthlyAmount-objLoanAccount.loan__Pmt_Amt_Cur__c)/4;
                           else if(objAutomatedPayment.loan__Frequency__c=='bi-weekly')
                           additionalAmt = (monthlyAmount-objLoanAccount.loan__Pmt_Amt_Cur__c)/2;
                           else if(objAutomatedPayment.loan__Frequency__c=='monthly')
                           additionalAmt = (monthlyAmount-objLoanAccount.loan__Pmt_Amt_Cur__c);
                           
                           
                           totalRepayment = ((decimal.valueof(totalRepayment)+additionalAmt).setScale(2)).format();
                           showAdditionalAmount = true;
                           counter=1;
                           additionalAmountLabel = (additionalAmt.setScale(2)).format();
                           total = string.valueof((decimal.valueof(additionalAmount))+objLoanAccount.loan__Pmt_Amt_Cur__c);
                           system.debug('totalConsIs2'+total);
                           getData(decimal.valueof(total));
                        
                       }
                       
                     
              } 
                
     }
     
           
            loadCmsData(); 
  }
  
  // This method is used to load CMS data.
  
  public void loadCmsData()
  {
       List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name,pepSequence__c,
                                                                    pepSectionUniqueName__c, pepType__c,pepSectionBodyRich__c, 
                                                                    pepSectionStory__c ,pepPage__r.pepPageName__c 
                                                                    from pepCmsSection__c  where pepPage__r.pepPageName__c='Adjust repayments' order by pepSequence__c DESC];
                                                                    
                 Section3 = lstSections[0].pepSectionBodyRich__c; 
                 duplicateSection3 = Section3 ;
                 if(String.isnotblank(objAutomatedPayment.loan__Frequency__c))
                    Section3=Section3.replace('{frequency}',(objAutomatedPayment.loan__Frequency__c).toLowerCase());
                 if(objLoanAccount.loan__Pmt_Amt_Cur__c!=null)  
                    Section3=Section3.replace('{total}',totalRepayment);
              
  }  
  
  // This method is used to calculate repayment amount after entering the additional amount.
  
    public void calculateRepaymentAmount()
    {
        errorMsg = false;
        enterAdditionalAmount = enterAdditionalAmount.replace(',','');
        if(string.isnotblank(enterAdditionalAmount) && decimal.valueof(enterAdditionalAmount)>0 && objLoanAccount !=null && objLoanAccount.id !=null)
        {
              
             additionalAmount = additionalAmount.replace(',','');
             //if(additionalAmountLabel.contains(',')
                additionalAmountLabel = additionalAmountLabel.replace(',','');
             if((decimal.valueof(enterAdditionalAmount))+(decimal.valueOf(additionalAmountLabel))+objLoanAccount.loan__Pmt_Amt_Cur__c> objLoanAccount.loan__Principal_Remaining__c)
              {
                      errorMsg = true;
              }
             else{
                        
                        totalAdditionalAmt += decimal.valueof(enterAdditionalAmount).setScale(2);
                        if(objAutomatedPayment.loan__Frequency__c=='weekly')
                           totalAdditionalAmt = (totalAdditionalAmt)*4;
                        else if(objAutomatedPayment.loan__Frequency__c=='bi-weekly')
                            totalAdditionalAmt = (totalAdditionalAmt)*2;
                        else if(objAutomatedPayment.loan__Frequency__c=='monthly')
                            totalAdditionalAmt = (totalAdditionalAmt);
                        additionalAmount = additionalAmount.replace(',','');
                        additionalAmountLabel = additionalAmountLabel.replace(',','');
                        additionalAmountLabel = ((decimal.valueOf(additionalAmountLabel)+decimal.valueof(enterAdditionalAmount)).setScale(2)).format(); 
                        showAdditionalAmount = true;
                        showUpdateButton = false;
                        counter=1;
                        additionalAmountLabel = additionalAmountLabel.replace(',','');
                        minimumRepayment = minimumRepayment.replace(',','');
                        totalRepayment = (((decimal.valueof(minimumRepayment))+(decimal.valueOf(additionalAmountLabel))).setScale(2)).format() ;
                        system.debug('totalAdditionalAmt Is'+totalAdditionalAmt);
                        system.debug('additionalAmount' + decimal.valueof(additionalAmount) );
                        system.debug('clAmountIs'+objLoanAccount.loan__Pmt_Amt_Cur__c);
                        total = ((decimal.valueOf(additionalAmount)+totalAdditionalAmt +objLoanAccount.loan__Pmt_Amt_Cur__c).setScale(2)).format() ;
                        additionalAmount = (decimal.valueOf(additionalAmount)).setScale(2).format();
                        minimumRepayment = (decimal.valueOf(minimumRepayment)).setScale(2).format();
                        Section3 = duplicateSection3;
                        if(String.isNotBlank(objAutomatedPayment.loan__Frequency__c)&&(objAutomatedPayment.loan__Frequency__c).toLowerCase()=='bi-weekly')
                          Section3=Section3.replace('{frequency}','fortnightly');
                        else if(String.isNotBlank(objAutomatedPayment.loan__Frequency__c))
                          Section3=Section3.replace('{frequency}',(objAutomatedPayment.loan__Frequency__c).toLowerCase());  
                        Section3=Section3.replace('{total}',totalRepayment);
                        total = total.replace(',','');
                        
                        system.debug('totalIs'+total);
                        getData(decimal.valueof(total));
                    
                 }   
        }
    }
  
  // This mmethod id used to remove applied additional amount.
    
    public void removeAdditionalAmount()
    {
        
        additionalAmount = '0'; 
        additionalAmountLabel ='0';
        totalAdditionalAmt =0;
       // additionalAmt =0;
        total = ((objLoanAccount.loan__Pmt_Amt_Cur__c).setScale(2)).format();
        totalRepayment = minimumRepayment;
        showAdditionalAmount = false;
        enterAdditionalAmount = '';
        showUpdateButton = false;
        errorMsg = false;
        counter=0;
        Section3 = duplicateSection3;
        if(String.isNotBlank(objAutomatedPayment.loan__Frequency__c))
          Section3=Section3.replace('{frequency}',(objAutomatedPayment.loan__Frequency__c).toLowerCase());
        Section3=Section3.replace('{total}',minimumRepayment);
        if(objLoanAccount.loan__Pmt_Amt_Cur__c!=null && monthlyAmount-objLoanAccount.loan__Pmt_Amt_Cur__c>1)
          showUpdateButton = false;
        else 
        showUpdateButton = true;  
        getData(objLoanAccount.loan__Pmt_Amt_Cur__c);
    }
  
  // This method is used to get the list of data on the basis of Amount.
    
  public void getData(Decimal Amount)
   {
        system.debug('AmountIs'+Amount);
        data = new List<Data>();
        LoanActions action = new LoanActions();
        List<clcommon.FinancialCalculator.RepaymentSchedule> emiLIst =
        action.calculateSchedule(loanAccountId,Amount);
        system.debug('listValIs'+emiLIst.size());
        
        if(!emiLIst.isEmpty())
        {
                   decimal totalRepaymentAmount = 0;
                   list<decimal> tempList = new list<decimal>();
                   for(clcommon.FinancialCalculator.RepaymentSchedule dataList:emiLIst)  
                    {
                         tempList.add((dataList.balance).setScale(2));
                        
                    }  
               
                   tempList.add((loanContractList[0].loan__Loan_Amount__c).setScale(2)) ;  
                   tempList.Sort();
                   system.debug('counterIs'+counter);
                   if(counter==0)
                   {
                      system.debug('aaya');
                      onloadDataList = tempList;
                      
                   }   
                    if(onloadDataList.size()>0 && !tempList.isEmpty())
                    {
                            system.debug('yesIn');
                            loanTerm = tempList.size()-1;
                            integer j = 0;
                            integer k = tempList.size()-1;
                             for(Integer i = onloadDataList.size()-1; i>=0;i--)
                              {
                                     
                                     if(counter==0 || k<0)
                                     {
                                        data.add(new Data(j,integer.valueOf(tempList.size()-1),onloadDataList.get(i),0));
                                     }
                                     else
                                     { 
                                       data.add(new Data(j,j,onloadDataList.get(i),tempList.get(k)));
                                     }
                                     j++;
                                     k--;
                             }
                             
                    }
           } 
           system.debug('DataIs'+Data);
    
   } 
 
 // This wrapper class is used to create data list to show dashboard in page.
 
  public class Data {
        
        public Integer data1 {get; set;}
        public Integer data2 {get; set;}
        public Decimal data3 {get; set;}
        public Decimal data4 {get; set;}
       
       public Data(Integer data1,Integer data2,Decimal data3,Decimal data4) {
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
            this.data4 = data4;
        }
    }
    
       
  // This method id used to navigate on home page after cancelation.
  
      public pageReference cancelRedirection()
      {
          string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
          Pagereference pr = new pageReference('/'+redircetPageName).setredirect(True);
        //  Pagereference pr = new Pagereference('/apex/pepViewMyLoanPage').setredirect(True);
          return pr;
      }
  
  // This method is used to update repayment amount.
  
  public void updateRepayment()
  {
      try
      {
          LoanActions action = new LoanActions();
          total = total.replace(',','');
          system.debug('apsIsValue'+total);
          loan__Automated_Payment_Setup__c aps = action.changePaymentAmount(decimal.valueof(total),loanAccountId);
          system.debug('apsIsValue'+aps);
          if(aps.id!=null){
                        successMsg = true;
                        system.debug('idIssssssss'+aps.id);
                        system.debug('successMsgIssssssss'+successMsg);
                  }
     }
     catch (exception  ex)
     {
         successMsg = false;
     }
  }
}