global class BrokerTxnPepperFileGen extends loan.FileGenerator {

    Map<Id,List<loan__Bank_Account__c>> brokerBankMap = new Map<id,List<loan__Bank_Account__c>>();
    List<loan__Bank_Account__c> bankAccs = new List<loan__Bank_Account__c>();
    List<loan__Broker_Transactions__c> brokerTxns  = new List<loan__Broker_Transactions__c>();
    String account = '';
    String tracebsb = '';
    String traceaccount = '';
    String orgbsb = '';
    String orgaccount = '';
    String numberofuser = '';
    String pMode = 'Direct Debit';
    loan__Automated_Payment_Configuration__c autoPmtConfig = new loan__Automated_Payment_Configuration__c();
    Boolean flag=false;
    private loan__Bank_Account__c bank;
    List<String> tracerec = new List<String>();
    loan.GlobalLoanUtilFacade systemDateTime = new loan.GlobalLoanUtilFacade();
   
    Integer totalentryrecords = 0;
    Decimal totalAmount = 0;
    
    Map<id,loan__Broker_Transactions__c> brokerTxnsMap = new Map<id,loan__Broker_Transactions__c>();
    private static String[] abc = new String[] {'A','B','C','D','E','F','G','H','I','J','K',
                                    'L','M','N','O','P','Q','R','S','T','U','V',
                                    'W','X','Y','Z'};
                                    
    private List<loan__Broker_Transactions__c> requeryScope(List<SObject> scope) {
        Set<ID> ids = new Set<ID>();
        Set<Id> brokerTxnIds = new Set<Id>();
        for (loan__Broker_Transactions__c s : (List<loan__Broker_Transactions__c>)scope) {
            ids.add(s.loan__Contact__r.AccountId);
            brokerTxnIds.add(s.id);
        }                   
        try{
            bankAccs = [select Id,loan__Bank_Account_Number__c,
                    loan_Bank_Account_Name__c,
                    BSB__c,
                    Account_Holder_Name__c, 
                    loan__Account__c,   
                    Name
                    from loan__Bank_Account__c where loan__Account__c in :ids
                    and loan__Active__c = true
                    and loan__Account_Usage__c = 'Broker Account'
                    ];
        
            if(bankAccs.size()>0){
                for(loan__Bank_Account__c bAcc:bankAccs){
                    if(!brokerBankMap.keySet().contains(bAcc.loan__Account__c)){  
                        brokerBankMap.put(bAcc.loan__Account__c, new List<loan__bank_Account__c>());                   
                    }
                    brokerBankMap.get(bAcc.loan__Account__c).add(bAcc); 
                }
            }
            
            brokerTxns = [select id,Name,loan__Sent_To_ACH__c,loan__Sent_To_ACH_On__c,
                        Payment_Mode__r.name,loan__ACH_Filename__c,loan__Contact__c,
                        loan__Contact__r.AccountId,loan__Contact__r.Name,
                        loan__Transaction_Amount__c,
                        Commission_Amount_Including_GST__c 
                        from loan__broker_transactions__c where Id in:brokerTxnIds];
            
            
            if(brokerTxns.size()>0){
                if(brokerTxns[0].Payment_mode__r.Name!=null){
                    pMode = brokerTxns[0].Payment_mode__r.Name; 
                }
            }
            autoPmtConfig = [select Id,loan__Bank_Account__r.loan__Bank_Account_Number__c,
                                    loan__Bank_Account__r.loan__Account__c,
                                    loan__Bank_Account__r.loan__Account__r.Name,
                                    loan__Bank_Account__r.loan__Account_Type__c,
                                    loan__Bank_Account__r.loan__Account_usage__c,
                                    loan__Bank_Account__r.loan__Bank_name__c,
                                    loan__Bank_Account__r.loan__Routing_Number__c,
                                    loan__Bank_Account__r.BSB__c,
                                    loan__Bank_Account__r.User_Id__c,
                                    Name_of_User_Supplying_File__c,
                                    Name_of_User_Financial_Institution__c,
                                    Number_of_User_Supplying_file__c,
                                    Trace_BSB__c,
                                    Trace_Account_Number__c,
                                    Organization_Name__c
                                from loan__Automated_Payment_Configuration__c where loan__Active__c = true and loan__Bank_Account__r.loan__Account_usage__c INCLUDES  (:loan.FractionalizationConstants.ADVANCE_TRUST_ACCOUNT)
                                                                            and loan__Bank_account__r.loan__Active__c = true and loan__Payment_Mode__r.Name =:pMode 
                                                                            and loan__Event__c INCLUDES (:loan.LoanConstants.BROKER_TRANSACTION) limit 1];
          tracebsb = autoPmtConfig.loan__Bank_Account__r.BSB__c;
          traceAccount = autoPmtConfig.loan__Bank_Account__r.loan__Bank_Account_Number__c;
           // System.debug('loan bank account:'+dsch);
        }
        catch(Exception e) {
        
            System.debug('Error msg: '+e.getMessage());
            
            System.debug('Error msg: '+e.getLineNumber());
        }              
        
        return (List<loan__Broker_Transactions__c >) brokerTxns;
    }

    public override String getSimpleFileName() {
        return 'wibs_pl_de_cr_';
    }
    
    public override List<String> getEntries(loan.TransactionSweepToACHState state, List<SObject> scope) { 
        List<String> retVal = new List<String>();
        List<loan__Broker_Transactions__c > diss = requeryScope(scope);        
               
        List<SObject> objects = new List<SObject>();
        bank = autoPmtConfig.loan__Bank_Account__r;
        numberofuser = bank.user_id__c;
        /*if (bank.loan__Routing_Number__c != null) {
            
            orgbsb = bank.loan__Routing_Number__c;
            
        }
        orgaccount = bank.loan__Bank_Account_Number__c;*/
        
        for (loan__Broker_Transactions__c bTxn : diss) {
            loan__Bank_Account__c brokerBank = new loan__Bank_Account__c();
            if(brokerBankMap.get(bTxn.loan__Contact__r.AccountId).size()>0){
                brokerBank = brokerBankMap.get(bTxn.loan__Contact__r.AccountId)[0];
            }
            
            if (brokerBank.loan__Bank_Account_Number__c != null && bTxn.Commission_Amount_Including_GST__c != null) {     
            flag=true;           
                String sub =  brokerBank.loan__Bank_Account_Number__c;
                System.debug('account number:'+sub);
                Integer result = sub.indexOf('-',0);
                    //To check number of digits in account number
                if (sub.length()>9 && result != -1) {
                    account = sub.substring(0,result);
                    account += sub.substring(result+1,sub.length());
                    System.debug('account'+account);
                }else if (sub.length()>9 && result == -1) {
                    addToInvalidScope(bTxn,'Account number is greater than 9 digits');
                }                    
                if ( sub.length()<=9 || account.length()<=9) {
                    account = sub;
                    addToValidScope(bTxn);
                    totalentryrecords++;
                    objects.add(generateDetailrecord(bTxn,brokerBank));
                } else {
                    addToInvalidScope(bTxn,'account number is greater than 9 digits');
                }                  
            } else {
                addToInvalidScope(bTxn,'Bank Account or broker commission amount is missing');
            }
        }
        
        
       
        
        system.debug('object'+objects);
        filegen.CreateSegments segments = new filegen.CreateSegments(objects);
        system.debug('segment'+segments);
        retVal = segments.retString();
        system.debug('value of retval is:'+retval);
        for (String line : retVal) {
            line = line+'\r\n';
            addEntry(line);
        }
        System.debug('Return Values retval in standard details'+ retval);
        return retVal;    
    }
    
    public override String getHeader(loan.TransactionSweepToACHState state, List<SObject> scope) {
        List<SObject> objects = new List<SObject>();
        objects = getValidScope();
        Map<String,Integer> countMap = (Map<String,Integer>)state.o2;
        if(countMap.get(pMode)==null){
            countMap.put(pMode,0);
            state.o2 = countMap;
        }
        if (objects.size()!= 0) {
            String header = '';
            List<String> retVal = new List<String>();
            system.debug('first value of retval'+retVal);
            List<SObject> headerRecs = new List<SObject>();
            headerRecs.add(generateDescriptiverecordHeader(state));
            system.debug('headerRecs'+headerRecs);
            filegen.CreateSegments segments =new filegen.CreateSegments(headerRecs);
            retVal = segments.retString();
            system.debug('header ret'+retval);
            try{
            header =retVal[0]+'\r\n';
            }catch(Exception e){
            
            }
            
            system.debug('header'+header);            
            return header;
        } else {
           //throw new FilegenException('No object in Valid Scope.');
           return null;
        }
    }
    public override String getTrailer(loan.TransactionSweepToACHState state, LIST<SObject> scope) { 
        List<SObject> objects = new List<SObject>();
        objects = getValidScope();
        if (objects.size()!= 0) {
            String trailer = '';
            String achFileTrailerContent = '';
            List<String> retVal = new List<String>();
            List<SObject> trailerRecs = new List<SObject>();
            trailerRecs.add(generateFiletotalrecordtrailer(scope));
            filegen.CreateSegments segments =new filegen.CreateSegments(trailerRecs);
            retVal = segments.retString();
           
            for (String s : retVal) {
                achFileTrailerContent = achFileTrailerContent + s + '\r\n';
            }
            /*
            try{
            achFileTrailerContent=retVal[0]+'\r\n';
            }catch(Exception e){
            
            }*/
            System.debug('Return value: '+ achFileTrailerContent);
            return achFileTrailerContent;
        } else {
            //throw new FilegenException ('No object in Valid Scope.');
            return null;
        }
            
    }  
    //Site header
    
    private Descriptive_record_header__c generateDescriptiverecordHeader(loan.TransactionSweepToACHState state){
        
        
        Descriptive_record_header__c drH = new Descriptive_record_header__c();
        Datetime currentSystemDateTime = systemDateTime.getCurrentSystemDate();
        DateTime currentSystemDateTime1 =currentSystemDateTime;
        Integer year = currentSystemDateTime1.year();
        Integer ye = math.mod(year,100);
        Date csd = Date.newInstance(currentSystemDateTime1.day(), currentSystemDateTime1.month(),ye );
        String datee = String.valueOf(csd);
        String val = datee.substring(2,datee.length());
        drH.Date_to_be_processed__c = val.substring(0,2)+val.substring(3,5)+val.substring(6,8);
        drH.blank__c = '';
        drH.Blank2__c = '';
        drH.Blank3__c = '';
        drH.Name_of_User_s_Financial_Institution__c = autoPmtConfig.Name_of_User_Financial_Institution__c;   
        String nameofuser = autoPmtConfig.Name_of_User_Supplying_File__c;
        String numberOfUserSupplyFile = autoPmtConfig.Number_of_User_Supplying_file__c;
        drH.Name_of_User_Supplying_File__c = loan.StringUtils.rightPadString(nameofuser ,26, ' '); 
        drH.Number_of_User_Supplying_File__c = loan.StringUtils.leftPadString(numberOfUserSupplyFile,6,'0') ;
        String entrydescription = 'PAYMENT';
        drH.Description_of_entries__c = loan.StringUtils.rightPadString(entrydescription,12,'');
        System.debug('Descriptive record header: ');
        System.debug('object: '+drH);        
        return drH;
    }
     
  
    
    
    //Standard Application Detail 
    private Detail_record__c generateDetailrecord (loan__Broker_Transactions__c bTxn,loan__Bank_Account__c bAcc) {
        Detail_record__c dR = new Detail_record__c();
        String fullname = '';
        //System.debug('dis.loan__Bank_Account__r.loan_Bank_Account_Name__c'+dis.loan__Bank_Account__c);
        if (bAcc.Account_Holder_Name__c!= null) {
            fullname = bAcc.Account_Holder_Name__c;
        } 
        System.debug('full name'+fullname);
        dR.Title_of_Account__c = fullname; 
        dR.Transaction_code__c = '50';
        
        String bankbranch = LoanDisbursalTxnPepperFileGen.validateBsb(bAcc.BSB__c);
        Integer length = bankbranch.length();
        
        //
        dR.bank_state_branch_number__c = bankbranch;
        String tracebsbnew = '';
        if(!String.isBlank(autoPmtConfig.Trace_BSB__c)){
            tracebsbnew= LoanDisbursalTxnPepperFileGen.validateBsb((autoPmtConfig.Trace_BSB__c!=null?autoPmtConfig.Trace_BSB__c:''));
        }
        
        dR.Trace_Record_BSB_number__c = tracebsbnew;
        String reference = bTxn.name;
        
        
        dR.Lodgement_Reference__c = loan.StringUtils.rightPadString(reference,18,'');
        dR.Indicator__c = '';
        dR.Amount_of_Withholding_Tax__c = loan.StringUtils.leftPadString('0',8,'0');
        dR.Name_of_Remitter__c = autoPmtConfig.Organization_Name__c;
        totalAmount += bTxn.Commission_Amount_Including_GST__c.setscale(2);
        dR.Account_number__c = account;
        dR.Trace_Record_Account_number__c = (autoPmtConfig.Trace_Account_Number__c!=null?autoPmtConfig.Trace_Account_Number__c:'');
       
        Decimal amount = bTxn.Commission_Amount_Including_GST__c.setscale(2);
        system.debug(amount);
        dR.Amount__c = loan.StringUtils.leftPadString(String.valueof(amount),10,'0');
        System.debug('amount: '+ dR.Amount__c);
        System.debug('Standard Application details' +dR);
        return dR;
    } 
    

  
    //Site Footer
   private File_Total_Record_Trailer__c generateFiletotalrecordtrailer(LIST<SObject> scope){
       File_Total_Record_Trailer__c ftrT = new File_Total_Record_Trailer__c();
       ftrT.blank__c = '';
       ftrT.Blank2__c = '';
       ftrT.Blank3__c = '';
       ftrT.BSB_Format_Filler__c = '999-999';
       ftrT.File_count_of_Records_Type_1__c = loan.StringUtils.leftPadString(String.valueof(totalentryrecords),6,'0');
       ftrT.File_Debit_Total_Amount__c = loan.StringUtils.leftPadString('0',10,'0');
       ftrT.File_Credit_Total_Amount__c = loan.StringUtils.leftPadString(String.valueof(totalAmount.setscale(2)),10,'0');
       ftrT.File_Net_Total_Amount__c = loan.StringUtils.leftPadString(String.valueof(totalAmount.setscale(2)),10,'0');
       system.debug(ftrT);
       return ftrT;
    } 
    
    String rightPadString(String str, Integer size, String padString) {    
        if (str == null) {
            return null;
        }
        Integer len = str.length();
        if(len>size){
            //If string length is greater than 'size', truncate
            return str.mid(0,size);
        }
        return str.rightPad(size,padString);
    }
    
      

}