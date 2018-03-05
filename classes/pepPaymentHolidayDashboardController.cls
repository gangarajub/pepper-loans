public class pepPaymentHolidayDashboardController
{
        
    public List<pepCmsSection__c> lstCMSSection1{get;set;}
    public List<pepCmsSection__c> lstCMSSection2{get;set;}
    public List<Wrapper> lstWrapper{get;set;}
    public Set<Integer> setCheckedMonths{get;set;}
    public Integer intSize{get;set;}
    public Map<String,Decimal> mapOfMonthsToData {get;set;}
    public List<String> lstMonthsName{get;set;}
    public String strData{get;set;}
    public Decimal decMaxValue{get;set;}
    public Decimal decMinValue{get;set;}
    public Decimal decMaxValueForChart{get;set;}
    public List<Chartwrapper> lstChartWrapper{get;set;}
    public Map<Id,Automated_Repayment_Schedule__c> mapOfIdToPaymentHoliday;
    public set<Date> setMonths;
    public Date startDate;
    public Date endDate;
    public List<LoanActions.HolidayPeriod> lstHolidayPeriod{get;set;}
    public Id idLoanAccount;
    public boolean isRecurring{get;set;}
    public List<Wrapper> lstPaymentHolidayMonthsWrapper;
    public boolean isRecurringDisable {get;set;}
    public List<Automated_Repayment_Schedule__c > lstHolidaySchedule = New List<Automated_Repayment_Schedule__c > ();
    public boolean showText{get;set;}
    public Boolean holidayError{get;set;}
    public Integer noOfMonths{get;set;}
    public String selectedCheckbox{get;set;}
    List<loan__Loan_Account__c> loanContractList;
    Map<date,date> apsMap;
    Map<Date,Integer> mapOfMonthsToCheckedHoliday;
    Map<Date,boolean> mapOfMonthsToSavedHoliday;
    Account objAccount;
    public String Page_Name{get;set;}
    public String Page_Label{get;set;}
    public List<loan__Loan_Account__c> lstLoanAccount;
    public Decimal decLoanContractPaymentAmount;
    public set<date> setTotalMonths;
    public set<Integer> setRecurringCheckedMonths;
    public pepPaymentHolidayDashboardController()
    {
    
        page_Name = 'pepPaymentHolidayDashBoard';
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
        mapOfMonthsToSavedHoliday = new Map<Date,boolean>();
        isRecurring = false;
        isRecurringDisable = false;
        mapOfIdToPaymentHoliday = new Map<Id,Automated_Repayment_Schedule__c>();  
        mapOfMonthsToCheckedHoliday = new Map<Date,Integer>();
        lstHolidayPeriod = new List<LoanActions.HolidayPeriod>();  
        lstLoanAccount = new List<loan__Loan_Account__c>();
        apsMap = new Map<date,date>();   
        setCheckedMonths = new set<Integer>();
        setMonths = new set<Date>(); 
        setTotalMonths = new set<date>();
        noOfMonths = 0;  
        decLoanContractPaymentAmount = 0; 
        setRecurringCheckedMonths = new set<Integer>();     
        fetchAPS();       
        fetchAccount();    
        lstLoanAccount = pepUtilityClass.getLoanContract(objAccount.Loan_Account_Id__c);
        calcualteSchduleDate();       
        lstHolidaySchedule = getHolidaySchedule(objAccount.Loan_Account_Id__c);
        calculateMonths();
        fetchContractAndHolidaySchedule(objAccount.Loan_Account_Id__c);        
        loadSection1();
        loadSection2();         
       
       
    }
    
    public void MakeChartData()
    {       
        decMinValue =0;
        decMaxValue =0;
        lstChartWrapper = new List<Chartwrapper>();   
        decMinValue = decLoanContractPaymentAmount;     
        for(String str : lstMonthsName)
        {
           /* if(decMinValue  == 0 && mapOfMonthsToData.get(str) !=0)
            {
                decMinValue  = mapOfMonthsToData.get(str);
            }
            
            else if(mapOfMonthsToData.get(str) < decMinValue && mapOfMonthsToData.get(str) !=0)
            {
                decMinValue = mapOfMonthsToData.get(str);
            
            } */ 
            
            System.debug(decMinValue);
            
            if(decMaxValue  == 0 && mapOfMonthsToData.get(str) !=0)
            {
                decMaxValue  = mapOfMonthsToData.get(str);
            }
            
            else if(mapOfMonthsToData.get(str)  > decMaxValue   && mapOfMonthsToData.get(str) !=0)
            {
                decMaxValue  = mapOfMonthsToData.get(str);
            
            }            
        
        
        }
        
        System.debug('MIn Value******'+decMinValue );
        System.debug('Max Value******'+decMaxValue );
        
        decMaxValueForChart =decMaxValue  +(decMaxValue*20)/100;
        for(String str : lstMonthsName)
        {
            Chartwrapper objWrapper = new Chartwrapper();
            objWrapper.strMonthName = str ;
            if(mapOfMonthsToData.get(str) == 0)
            {
                objWrapper.decMinValue = 0;
            }
            
            else
            {
                 objWrapper.decMinValue = decMinValue ;
            }
            
             if((mapOfMonthsToData.get(str) - decMinValue ) > 0 && mapOfMonthsToData.get(str) !=0)
             {
                 objWrapper.strMinValue = '' ;
             }
             else if(mapOfMonthsToData.get(str) == 0)
             {
                 objWrapper.strMinValue = '$0' ;
             }
             else if((mapOfMonthsToData.get(str) - decMinValue ) ==0 && mapOfMonthsToData.get(str) !=0)
             {
                 objWrapper.strMinValue = '$'+String.valueOf(decMinValue);
             }
             
             if(mapOfMonthsToData.get(str) == 0)
             {
                  objWrapper.decDifferenceVal =0;
             }
             else
             {
                 objWrapper.decDifferenceVal = mapOfMonthsToData.get(str) - decMinValue;
             }
             
             if(((mapOfMonthsToData.get(str) - decMinValue ) == 0 ) || (mapOfMonthsToData.get(str) - decMinValue ) <0)
             {
                 objWrapper.decMonthVal = '';
             }
             else
             {
                 objWrapper.decMonthVal ='$'+String.valueof(mapOfMonthsToData.get(str));
             }
             System.debug(objWrapper);
             lstChartWrapper.add(objWrapper);
        
        }
     
    
    }
    
    //This method fetched logged in user Account
    public void fetchAccount()
    {
        Id idAccount = pepUtilityClass.getAccountId();
        System.debug('idAccount******'+idAccount );
       
        objAccount =[select id,firstName,Loan_Account_Id__c,Communication_Type__c ,
                                    Marketing_Communication__c,PersonMobilePhone,
                                    PersonOtherPhone,lastname 
                                         from Account where id=:idAccount];
        System.debug('objAccount.Loan_Account_Id__c***'+objAccount.Loan_Account_Id__c);                                 
         
    }
    
    //This method fetches loan contract and its child holiday schedule
    public void fetchContractAndHolidaySchedule(Id idLoanAccount)
    {
        this.idLoanAccount = idLoanAccount;
        System.debug('this.idLoanAccount***'+this.idLoanAccount);
          
        
        System.debug('lstLoanAccount ******'+lstLoanAccount[0].loan__Automated_Payment_Setup__r);
        
        if(lstLoanAccount != null && lstLoanAccount.size() > 0)
        {
           System.debug('*&*&*'+lstLoanAccount[0].pepis_recurring__c);
           isRecurring = lstLoanAccount[0].pepis_recurring__c;
           
           
           if(lstLoanAccount[0].loan__Last_Installment_Date__c != null && lstLoanAccount[0].loan__Next_Installment_Date__c != null)
           {
               loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
               Date systemDate = lstLoanAccount[0].loan__Next_Installment_Date__c;
               Integer intmonthDiff = systemDate.monthsBetween(lstLoanAccount[0].loan__Last_Installment_Date__c);
               System.debug('intmonthDiff ***********'+intmonthDiff );
               System.debug('maturity date ***********'+lstLoanAccount[0].loan__Last_Installment_Date__c);
               System.debug('end date ***********'+lstLoanAccount[0].loan__Last_Installment_Date__c);
               if(intmonthDiff < 12)
               {
                   isRecurringDisable = true;
               }
               
               
           }
           
        }       
        
        LoanActions action = new LoanActions();       
        
        System.debug('lstHolidaySchedule *****'+lstHolidaySchedule );
        if(lstHolidaySchedule != null && lstHolidaySchedule.size() > 0)
        {        
            calculateHolidaySchedule(lstHolidaySchedule);
        }
        
        /*else
        {
             List<loan__Automated_Payment_Setup__c> lstAPS = lstLoanAccount[0].loan__Automated_Payment_Setup__r;
             calculateHolidayScheduleAPS(lstAPS );
        } */   
       
       
    }
    
    
    public void calculateHolidayScheduleAPS(List<loan__Automated_Payment_Setup__c> lstHolidayScheduleASP)
    {
        System.debug('lstHolidayScheduleASP*****'+lstHolidayScheduleASP);
        System.debug('lstHolidayScheduleASP*****'+lstHolidayScheduleASP.size());        
        Date startDate = System.Date.today().toStartOfMonth(); 
        Date endDate = startDate.addMonths(14).addDays(-1);
        lstMonthsName = new List<String>();
        mapOfMonthsToData = new Map<String,Decimal>();
         lstWrapper = new List<Wrapper>();
        for(loan__Automated_Payment_Setup__c obj : lstHolidayScheduleASP)
        {
            for(startDate = startDate ; startDate < endDate ; startDate = startDate.addmonths(1))
            { 
                    Datetime dtime = datetime.newInstance(startDate .year(), startDate.month(),startDate .day());
                    wrapper objWrapper  = new Wrapper();
                    objWrapper.startDate = startDate;
                    objWrapper.endDate   = startDate.addMonths(1).addDays(-1);
                    objWrapper.decRepaymentAmount = obj.loan__Transaction_Amount__c;
                    System.debug('StartDATe'+objWrapper.startDate);
                    System.debug('endDate  '+objWrapper.endDate  );
                    objWrapper.strMonth = dtime.format('MMM');
                    objWrapper.strYear  = dtime.format('yyyy');                         
                    lstWrapper.add(objWrapper);
                    lstMonthsName.add(objWrapper.strMonth +' ' +objWrapper.strYear); 
                    mapOfMonthsToData.put(objWrapper.strMonth +' ' +objWrapper.strYear,obj.loan__Transaction_Amount__c.setscale(2));
    
            }
        }
        
        System.debug('mapOfMonthsToData****'+mapOfMonthsToData);
        System.debug('lstWrapper****'+lstWrapper.size());
        System.debug('lstWrapper****'+lstWrapper);
        MakeChartData();
    
    
    }
    
    
    
    public void calculateHolidaySchedule(List<Automated_Repayment_Schedule__c> lstHolidaySchedule)
    {
        Integer i =0;
        lstMonthsName = new List<String>();
        mapOfMonthsToData = new Map<String,Decimal>();        
        lstWrapper = new List<Wrapper>();
        lstPaymentHolidayMonthsWrapper = new List<Wrapper>();
        System.debug('lstHolidaySchedule******'+lstHolidaySchedule);
        Integer j = 0;
        Integer noOfChecked = 0;
        
        
        
        System.debug('mapOfMonthsToCheckedHoliday****'+mapOfMonthsToCheckedHoliday);
        
        for(Automated_Repayment_Schedule__c obj : lstHolidaySchedule)
        {
           SYStem.debug('obj***'+obj);
           //loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
           //Date systemDate = util.getCurrentSystemDate();
           Date DatestartDate = obj.Repayment_Date__c.toStartOfMonth();
           Date DateendDate =  DatestartDate.addMonths(Integer.valueOf(obj.Number_of_Payments__c));
           
           for(Date mydate = DatestartDate; mydate < DateendDate ; mydate = mydate.addmonths(1))
           {
                System.debug('mydate *******'+mydate );
                System.debug('objRepayment****'+obj.Repayment_Amount__c);         
                if(setMonths.contains(mydate) )
                {

                    
                        
                
                    
                    Datetime dtime = datetime.newInstance(mydate.year(), mydate.month(),mydate.day());                    
                    wrapper objWrapper  = new Wrapper();
                    System.debug('****mapOfMonthsToCheckedHoliday'+mapOfMonthsToCheckedHoliday.get(mydate));
                   
                    if(mapOfMonthsToCheckedHoliday.get(mydate) ==3)
                    {
                        objWrapper.isDisabled = true;
                    }
                    else
                    {
                        objWrapper.isDisabled = false;
                        
                    }
                    
                    if(obj.Repayment_Amount__c == 0 && !mapOfMonthsToCheckedHoliday.containsKey(objWrapper.startDate))
                    {
                    
                        noOfChecked ++;
                        
                    }
                    if(obj.Repayment_Amount__c ==0)
                    {
                        System.debug('i*************'+i);
                        setCheckedMonths.add(i);  
                        objWrapper.isChecked = true; 
                        System.debug('mydate*******'+mydate);
                        
                        mapOfMonthsToSavedHoliday.put(mydate,true);
                        System.debug('mapOfMonthsToSavedHoliday*****'+mapOfMonthsToSavedHoliday);
                    }
                    System.debug('noOfChecked******'+noOfChecked );
                    objWrapper.disableCounter = mapOfMonthsToCheckedHoliday.get(mydate);
                   // objWrapper.disableCounter += noOfChecked ;
                    objWrapper.startDate = mydate;
                    objWrapper.endDate   = mydate.addMonths(1).addDays(-1);
                    objWrapper.decRepaymentAmount = obj.Repayment_Amount__c;
                    System.debug('StartDATe'+objWrapper.startDate);
                    System.debug('endDate  '+objWrapper.endDate  );
                    objWrapper.strMonth = dtime.format('MMM');
                    objWrapper.strYear  = dtime.format('yyyy');                         
                    lstWrapper.add(objWrapper);
                    
                  //  if(i >1)
                   // {
                        
                        lstMonthsName.add(objWrapper.strMonth +' ' +objWrapper.strYear); 
                        mapOfMonthsToData.put(objWrapper.strMonth +' ' +objWrapper.strYear,obj.Repayment_Amount__c.setScale(2));   
                   // }
                    
                    if(obj.Repayment_Amount__c == 0)
                    {
                       
                        
                    
                    }
                    i++;
                    }
                    setTotalMonths.add(mydate);
               
               
                     
               j++;  
           }
           
           System.debug('lstWrapper********'+lstWrapper);
           
           
          
            j++;
        
        }
        
       
        
            
        
        System.debug('setCheckedMonths********'+setCheckedMonths);
        System.debug('mapOfMonthsToCheckedHoliday********'+mapOfMonthsToCheckedHoliday);
        MakeChartData();      
          
                  
    }
    
    //This method call the calculateHolidaySchedule Method to 
    //calculate data based on payment holiday selected months
    public void calculate()
    {
       System.debug('setCheckedMonths****'+setCheckedMonths);
       showText = true;
       List<Integer> lstInteger = new List<Integer>();
       lstInteger.addAll(setCheckedMonths);
       lstInteger.sort();
       System.debug('lstInteger****'+lstInteger);
        if(lstHolidayPeriod != null && lstHolidayPeriod.size() > 0)
        {
           lstHolidayPeriod.clear();
        }
       if(lstInteger.size() > 0)
       {
           
           for(Integer i : lstInteger)
           {
               System.debug('I****'+i);
              if(lstWrapper.size() > i)
              {
               LoanActions.HolidayPeriod objHoliday = new LoanActions.HolidayPeriod();
               System.debug(lstWrapper[i]);
               objHoliday.startDate = lstWrapper[i].StartDate; 
               objHoliday.endDate   = lstWrapper[i].EndDate; 
               lstHolidayPeriod.add(objHoliday);
             }
               
           
           }           
       
       }
       
       System.debug('lstHolidayPeriod*****'+lstHolidayPeriod.size());
        System.debug('lstHolidayPeriod*****'+lstHolidayPeriod);
       System.debug('lstHolidayPeriod*****'+startDate );
       System.debug('lstHolidayPeriod*****'+endDate );
       System.debug('lstHolidayPeriod*****'+isRecurring);
       LoanActions action = new LoanActions();
       List<Automated_Repayment_Schedule__c> lstHolidaySchedule = action.generateScheduleWithHolidays(idLoanAccount,lstHolidayPeriod, startDate ,endDate , isRecurring);
       System.debug('lstHolidaySchedule ********'+lstHolidaySchedule.size());
       System.debug('lstHolidaySchedule ***************'+lstHolidaySchedule );
       calculateHolidaySchedule(lstHolidaySchedule); 
    
    }
    
    
    
    
    public void calcualteSchduleDate()
    {
        if(lstLoanAccount !=null && lstLoanAccount.size() >0)
        {       
        
        Date systemDate = lstLoanAccount[0].loan__Next_Installment_Date__c;
        System.debug('systemDate *********'+systemDate );
        startDate = systemDate.toStartOfMonth(); 
        endDate = startDate.addMonths(14).addDays(-1);
        }
    }
    
    
    public void loadSection1()
    {
        lstCMSSection1 = [select id,pepHeader__c from pepCmsSection__c 
                                             where  pepSectionUniqueName__c ='PaymentHolidayDBSection1' 
                                             AND Page_Name__c ='Dashboard(Payment Holiday)'];
    }
    public void loadSection2()
    {
        lstCMSSection2 = [select id,pepHeader__c from pepCmsSection__c
                                                 where pepSectionUniqueName__c ='PaymentHolidayDBSection2'
                                                 AND Page_Name__c ='Dashboard(Payment Holiday)'];
        
    }
    
    
    
    //This method make set of current months to 14 months
    public void  calculateMonths()
    {
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate = lstLoanAccount[0].loan__Next_Installment_Date__c;
        System.debug('systemDate *********'+systemDate );
        List<Wrapper> lstWrapper = new List<Wrapper>();
        Date myDate = systemDate;
        Date newDate = myDate.addMonths(14);
        Date startDate = systemDate.toStartOfMonth(); 
        Date endDate = startDate.addMonths(14).addDays(-1);
        
        for(startDate = startDate ; startDate < endDate ; startDate = startDate.addmonths(1))
        { 
            
           setMonths.add(startDate);  
           System.debug('startDate******'+startDate);
           paymentHolidayValidation(startDate);     
        }
        
        System.debug('setMonths*****'+setMonths);
        
       
    
    }
    
    public void selectedData()
    {
      if( setCheckedMonths== null)
      {
           setCheckedMonths = new set<Integer>();
      } 
      
       boolean isMonthChecked = false;
       Integer checkedRowNo =0;
       System.debug('setCheckedMonths****'+setCheckedMonths);
       System.debug(Apexpages.currentpage().getparameters().get('rowNo'));
       if(Apexpages.currentpage().getparameters().get('rowNo') != null 
           && Apexpages.currentpage().getparameters().get('rowNo') !='')
       {
           System.debug(checkedRowNo-1);
           System.debug(setCheckedMonths);
           checkedRowNo = Integer.valueOf(Apexpages.currentpage().getparameters().get('rowNo'));
           if(setCheckedMonths.contains(checkedRowNo-1))
           {
               setCheckedMonths.remove(checkedRowNo-1);
               isMonthChecked = false;
           }
           else
           {
               setCheckedMonths.add(checkedRowNo-1);
               isMonthChecked =true;
           }
           
           //System.debug('wrapperval**&*'+lstWrapper[checkedRowNo-1]);
           if(isMonthChecked == true)
           {
               lstWrapper[checkedRowNo-1].isChecked = true;
               
               Date dt = lstWrapper[checkedRowNo-1].startDate;
               
               for(Wrapper objWrapper : lstWrapper)
               {
                 //  if(objWrapper.StartDate > dt  )
                  // {
                       objWrapper.disableCounter =objWrapper.disableCounter+1;
                       mapOfMonthsToCheckedHoliday.put(objWrapper.startDate,objWrapper.disableCounter);
                   //}
               
               }
               
               
               
           }
           else
           {
               Date dt = lstWrapper[checkedRowNo-1].startDate;
               
               for(Wrapper objWrapper : lstWrapper)
               {
                  // if(objWrapper.StartDate > dt  )
                  // {
                       objWrapper.disableCounter =objWrapper.disableCounter-1;
                       mapOfMonthsToCheckedHoliday.put(objWrapper.startDate,objWrapper.disableCounter);
                   //}
               
               }
               lstWrapper[checkedRowNo-1].isChecked = false;
           }
           
           //lstWrapper[checkedRowNo-1].isDisabled = true;
       
       }
       
       
       
       System.debug('list rows'+setCheckedMonths);
        
    }
    
    public PageReference SavepaymentHoliday()
    {
        showText  = false;
       if(setCheckedMonths.size() > 0)
       {
            List<Integer> lstInteger = new List<Integer>();
            lstInteger.addAll(setCheckedMonths);
            lstInteger.sort();
            System.debug('lstInteger****'+lstInteger);
            if(lstHolidayPeriod != null && lstHolidayPeriod.size() > 0)
            lstHolidayPeriod.clear();
           for(Integer i : lstInteger)
           {
               if(lstWrapper.size() > i)
               {
               LoanActions.HolidayPeriod objHoliday = new LoanActions.HolidayPeriod();
               objHoliday.startDate = lstWrapper[i].StartDate; 
               objHoliday.endDate   = lstWrapper[i].EndDate; 
               lstHolidayPeriod.add(objHoliday);
              }
               
           
           }           
       
       }
       System.debug('lstHolidayPeriod**************'+lstHolidayPeriod.size());
       System.debug('isRecurring**************'+isRecurring);
       System.debug('idLoanAccount**************'+idLoanAccount);
       LoanActions action = new LoanActions();
       action.saveScheduleWithHolidays(idLoanAccount, lstHolidayPeriod, startDate,endDate, isRecurring);
       Map<String, String> mapchild = new Map<String, String>();
       mapchild.put('pepis_Recurring__c',String.valueof(isRecurring));
       
       action.updateLoanAccount(idLoanAccount,mapchild );
       //PageReference objNextPage = Page.peppayoutloanpage;
       //objNextPage.setRedirect(true);
       return null;
       
       
    }
    
    public pageReference cancelpaymentHoliday()
    {
        string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
        Pagereference objPageref = new pageReference('/'+redircetPageName);
        objPageref.setRedirect(true);
        return objPageref;
    
    }
    
    public class wrapper
    {
        public String strMonth{get;set;}
        public String strYear{get;set;}
        public decimal decRepaymentAmount{get;set;} 
        public Date StartDate{get;set;}
        public Date EndDate{get;set;} 
        public boolean isDisabled{get;set;} 
        public Integer disableCounter{get;set;}
        public Boolean isChecked{get;set;} 
    
    }
    
    public class Chartwrapper
    {
        public String strMonthName{get;set;}
        public Decimal decMinValue{get;set;}
        public String strMinValue{get;set;}
        public Decimal decDifferenceVal{get;set;}   
        public String decMonthVal{get;set;}   
    
    }
    
    public List<Automated_Repayment_Schedule__c > getHolidaySchedule(Id idLoanAccount)
    {
      
       lstHolidaySchedule = [select id,Repayment_Date__c,Repayment_Amount__c ,Number_of_Payments__c,CL_Contract__r.loan__Pmt_Amt_Cur__c from Automated_Repayment_Schedule__c where CL_Contract__c =:idLoanAccount AND Is_Primary__c = true order by Sequence__c asc]; // hardcode as of now
       if(lstHolidaySchedule != null && lstHolidaySchedule.size() > 0)
       {
            decLoanContractPaymentAmount = lstHolidaySchedule[0].CL_Contract__r.loan__Pmt_Amt_Cur__c;
       }
      
      return lstHolidaySchedule ;
    }
    
  public void paymentHolidayValidation(date comingDate)
  {
  
     // noOfMonths = 0;
    //  apsMap = new Map<date,date>();
      system.debug('comingDateIs'+comingDate);
      date firstDate = (comingDate.addmonths(-11));
      system.debug('firstDateIs'+firstDate);
      List<loan__Automated_Payment_Setup__c> APSList;
      APSList = new List<loan__Automated_Payment_Setup__c>();
      
        
    if(loanContractList!=null  && !loanContractList.isEmpty() )
     {
      for (loan__Loan_Account__c instanceLoanAccount:loanContractList)
      {
        System.debug('loanContractList*****'+instanceLoanAccount.loan__Automated_Payment_Setup__r);        
        for(loan__Automated_Payment_Setup__c automated : instanceLoanAccount.loan__Automated_Payment_Setup__r) 
         {
              if(automated.loan__Type__c == 'RECURRING' && firstDate <= automated.loan__Recurring_ACH_End_Date__c && automated.loan__Transaction_Amount__c ==0)
                APSList.add(automated);
         }
       }
     
     }
   Integer noOfMonthsPaymentHoliday = 0;
   System.debug('APSLIST***'+APSList);
   Integer j =0;
   
   for(Automated_Repayment_Schedule__c obj : lstHolidaySchedule)
   {
           SYStem.debug('obj***'+obj);
           //j = 0;
           Date DatestartDate = obj.Repayment_Date__c.toStartOfMonth();
           Date DateendDate =  DatestartDate.addMonths(Integer.valueOf(obj.Number_of_Payments__c));
           Integer i =0;
           loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
           Date systemDate = lstLoanAccount[0].loan__Next_Installment_Date__c;
           SystemDate = Systemdate.toStartOfMonth();
           System.debug('systemDate ******'+systemDate );
           System.debug('StartDateAMIT****'+DatestartDate);
           System.debug('ENDDateAMIT****'+DateendDate );
           for(Date mydate = DatestartDate; mydate < DateendDate ; mydate = mydate.addmonths(1))
           {
                   
                  System.debug('obj.Repayment_Amount__c**'+obj.Repayment_Amount__c);
                
              
                   if(obj.Repayment_Amount__c == 0 && DatestartDate >= systemDate.addMonths(2) && Date.Today().monthsBetween(DatestartDate)<=12)
                   {
                        
                            
                            j++;
                       
                      
                   } 
                
                   
                  // 
                
                    System.debug('mapOfMonthsToCheckedHoliday*****'+mapOfMonthsToCheckedHoliday);             
               
           }
           System.debug('j************'+j);
          
           
    }
    
   
    mapOfMonthsToCheckedHoliday.put(comingdate,j);
    
   
    setRecurringCheckedMonths.add(comingdate.month());
    System.debug('setRecurringCheckedMonths****'+setRecurringCheckedMonths);
           
   System.debug('j************'+j);
   if(APSList.size()>0)  
   {
                 system.debug('APSListIs'+APSList);                  
                 for(loan__Automated_Payment_Setup__c automated : APSList)
                 {
                         Integer Months= (automated.loan__Recurring_ACH_Start_Date__c).monthsBetween(automated.loan__Recurring_ACH_End_Date__c)+1;
                         if(Months == 1 && !apsMap.containsKey((automated.loan__Recurring_ACH_Start_Date__c).toStartOfMonth()))
                         {
                            apsMap.put((automated.loan__Recurring_ACH_Start_Date__c).toStartOfMonth(),automated.loan__Recurring_ACH_Start_Date__c);
                            noOfMonths++;
                            noOfMonthsPaymentHoliday++;
                         }   
                         else if(Months >1) 
                         {
                                date startDate = (automated.loan__Recurring_ACH_Start_Date__c).toStartOfMonth();
                                date endDate =  automated.loan__Recurring_ACH_End_Date__c;
                                
                                for(startDate = startDate ; startDate < endDate ; startDate = startDate.addmonths(1))
                                {
                                    if(firstDate <= startDate)
                                    {
                                        noOfMonthsPaymentHoliday++;
                                    }
                                }
                                
                                
                               
                         }
                 }
                 
      }
      System.debug('mapOfMonthsToCheckedHoliday*****'+mapOfMonthsToCheckedHoliday.get(comingDate));
      System.debug('noOfMonthsPaymentHoliday****'+noOfMonthsPaymentHoliday);
       //mapOfMonthsToCheckedHoliday.put(comingDate,noOfMonthsPaymentHoliday);
      Integer k = mapOfMonthsToCheckedHoliday.get(comingDate);
      System.debug('k*****'+k);
      if(k != null )
      {
          if(noOfMonthsPaymentHoliday != null)
          {
              k+= noOfMonthsPaymentHoliday;
          }
          mapOfMonthsToCheckedHoliday.put(comingDate,k);
         
          
      }
      /*else{
           mapOfMonthsToCheckedHoliday.put(comingDate,j);
          
      }*/
      
      
      
      
       System.debug('comingDate*****'+comingDate);
       System.debug('comingDate*****'+noOfMonthsPaymentHoliday);
       System.debug('mapOfMonthsToSavedHoliday********'+mapOfMonthsToSavedHoliday);
      
       System.debug('mapOfMonthsToCheckedHoliday***********'+mapOfMonthsToCheckedHoliday);
       
  }

 public void fetchAPS()
 {
 
      loanContractList  = new List<loan__Loan_Account__c>();
      String loanAccountId;
      String idAccount = pepUtilityClass.getAccountId();
         if(string.isNotBlank(idAccount))
           loanAccountId = pepUtilityClass.getLoanAccountId(idAccount);
         if(string.isNotBlank(loanAccountId)) //
            loanContractList = pepUtilityClass.getLoanContract(loanAccountId);
            System.debug('loanContractList *****'+loanContractList );
 
 }
 
Public Pagereference redirectOK()
{
          string redircetPageName= pages_config__c.getinstance('pepviewmyloanpage').Page_Label__c;
          Pagereference pr = new pageReference('/'+redircetPageName).setredirect(True);
        //  Pagereference pr = new Pagereference('/apex/pepViewMyLoanPage').setredirect(True);
          return pr;
}
 /* Public Pagereference temporaryRedirection()
  {
          string redircetPageName= pages_config__c.getinstance('pepwelcomepage').Page_Label__c;
          Pagereference pr = new pageReference('/'+redircetPageName).setredirect(True);
          return pr;
  } */

}