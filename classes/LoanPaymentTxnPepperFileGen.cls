global class LoanPaymentTxnPepperFileGen extends loan.FileGenerator {
    
    private loan__Bank_Account__c bank;
    
    Integer lineCount=0;
    Double blocks =0.0;
    Decimal debitTotal = 0;
    String account = '';
    String traceAccount = '';
    String traceBsb = '';
    String orgBsb = '';
    String orgAccount = '';
    String numberOfUser = '';
    List <loan__Loan_Payment_Transaction__c> loanPmts;
    loan.GlobalLoanUtilFacade systemDateTime = new loan.GlobalLoanUtilFacade();
    List<String> traceRec = new List<String>();
    Integer totalEntryRecords = 0;
    Decimal totalAmount = 0;
    //BankFileGenUtil banks = new BankFileGenUtil();
    Boolean flag=false;
    Map < id, loan__Loan_Payment_Transaction__c > pmtsMap = new Map < id, loan__Loan_Payment_Transaction__c > ();
    private static String[] abc = new String[] {'A','B','C','D','E','F','G','H','I','J','K',
                                    'L','M','N','O','P','Q','R','S','T','U','V',
                                    'W','X','Y','Z'};
    String pMode = 'ACH';
   
    loan__Automated_Payment_Configuration__c autoPmtConfig = new loan__Automated_Payment_Configuration__c();
                                    
    private List<loan__Loan_Payment_Transaction__c> requeryScope(List<SObject> scope) {
        Set < ID > ids = new Set < ID > ();
        for (SObject s: scope) {
            ids.add(s.Id);
        }

        try {
            loanPmts = [Select id, Name, loan__Transaction_Amount__c,
                            loan__Loan_Account__r.name,
                            loan__Loan_Account__c,
                            loan__Payment_Mode__r.Name,
                            loan__Automated_Payment_Setup__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Name,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__ACH_Code__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Routing_Number__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Account__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Account_Type__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Account_Usage__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Active__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_Account_Number__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_name__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Contact__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan_Bank_Account_Name__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Account_Holder_Name__c,
                            loan__Automated_Payment_Setup__r.loan__Bank_Account__r.BSB__c,
                            loan__Loan_Account__r.loan__Contact__c,    
                            loan__Loan_Account__r.loan__Account__r.Name,
                            loan__Loan_Account__r.loan__Contact__r.firstname,
                            loan__Loan_Account__r.loan__Contact__r.lastname,
                            loan__Loan_Account__r.loan__Contact__r.Mailingstreet,
                            loan__Loan_Account__r.loan__Contact__r.mailingState,
                            loan__Loan_Account__r.loan__Contact__r.mailingpostalcode
                            from loan__Loan_Payment_Transaction__c
                            where ID in : ids];

            System.debug('loan pmt txn: ' + loanPmts);
            if(loanPmts.size()>0){
                if(loanPmts[0].loan__Payment_Mode__r.Name!=null){
                    pMode = loanPmts[0].loan__Payment_Mode__r.Name;
                }
            }
            
            autoPmtConfig = [select Id,
                                    loan__Bank_Account__r.loan__Bank_Account_Number__c,
                                    loan__Bank_Account__r.loan__Account__c,
                                    loan__Bank_Account__r.loan__Account__r.Name,
                                    loan__Bank_Account__r.loan__Account_Type__c,
                                    loan__Bank_Account__r.loan__Account_usage__c,
                                    loan__Bank_Account__r.loan__Bank_name__c,
                                    loan__Bank_Account__r.loan__Routing_Number__c,
                                    loan__Bank_Account__r.user_id__c,
                                    loan__Bank_Account__r.BSB__c,
                                    loan__Bank_Account__r.Account_Holder_Name__c,
                                    Name_of_User_Supplying_File__c,
                                    Name_of_User_Financial_Institution__c,
                                    Number_of_User_Supplying_file__c,
                                    Trace_BSB__c,
                                    Trace_Account_Number__c,
                                    Organization_Name__c
                                from loan__Automated_Payment_Configuration__c where loan__Active__c = true and loan__Bank_Account__r.loan__Account_usage__c INCLUDES  (:loan.FractionalizationConstants.COLLECTIONS_TRUST_ACCOUNT)
                                                                            and loan__Bank_account__r.loan__Active__c = true and loan__Payment_Mode__r.Name =:pMode 
                                                                            and loan__Event__c INCLUDES (:loan.LoanConstants.LOAN_PAYMENT) limit 1];
            bank = autoPmtConfig.loan__Bank_Account__r;
            numberOfUser = bank.user_id__c;
            if (bank.loan__Routing_Number__c != null) {
                
                orgbsb = bank.loan__Routing_Number__c;
                
            }
            orgAccount = bank.loan__Bank_Account_Number__c; 
            tracebsb = autoPmtConfig.loan__Bank_Account__r.loan__Routing_Number__c;
            traceAccount = autoPmtConfig.loan__Bank_Account__r.loan__Bank_Account_Number__c;
            system.debug(tracerec);
        } catch (Exception e) {
            System.debug('Error msg: ' + e.getMessage());
        }
        
        System.debug('loan pmt txn: ' + loanPmts);
        for (loan__Loan_Payment_Transaction__c pmt: loanPmts) {
            pmtsMap.put(pmt.id, pmt);
        System.debug('loan__Automated_Payment_Setup__c'+pmt.loan__Automated_Payment_Setup__c);    
        System.debug('loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Name'+ pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Name);
        System.debug('pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Routing_Number__c'+pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Routing_Number__c);
        System.debug('pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_Account_Number__c'+pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_Account_Number__c);
        System.debug('pmt.loan__Transaction_Amount__c'+pmt.loan__Transaction_Amount__c);
        }

        return (List < loan__Loan_Payment_Transaction__c > ) loanPmts;
    }

    public override String getSimpleFileName() {
        if(loan.CustomSettingsUtil.getACHParameters().loan__Multiple_Payment_Method_Support__c == true){
            return 'wibs_pl_de_mx_';
        }
        return 'wibs_pl_de_mx_';
    }
    
    public override List<String> getEntries(loan.TransactionSweepToACHState state, List<SObject> scope) {
        
        List < String > retVal = new List < String > ();
        List < loan__Loan_Payment_Transaction__c > pmts = requeryScope(scope);

        System.debug('Pmts : ' + pmts);

        List < SObject > objects = new List < SObject > ();
       
        for (loan__Loan_Payment_Transaction__c pmt: pmts) {
       
        System.debug(' loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Name'+ pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Name);
        System.debug('pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Routing_Number__c'+pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Routing_Number__c);
        System.debug('pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_Account_Number__c'+pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_Account_Number__c);
        System.debug('pmt.loan__Transaction_Amount__c'+pmt.loan__Transaction_Amount__c);
            if (pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_Account_Number__c != null && pmt.loan__Transaction_Amount__c != null) {
                String sub = pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.loan__Bank_Account_Number__c;
                 flag=true;
                System.debug('account number:' + sub);
                Integer result = sub.indexOf('-', 0);
                if (sub.length() > 9 && result != -1) {
                    System.debug('inside');
                    account = sub.substring(0, result);
                    account += sub.substring(result + 1, sub.length());
                } else if (sub.length() > 9 && result == -1) {
                    System.debug('hello world');
                    system.debug('sub.length()'+sub.length()+'result'+result);
                    addToInvalidScope(pmtsMap.get(pmt.id), 'Bank Account number is greater than 9 digits');
                }

                if (sub.length() <= 9 || account.length() <= 9) {
                    System.debug('inside hello');
                    account = sub;
                    totalentryrecords++;
                    system.debug(totalentryrecords);
                    Detail_record__c dt= generateDetailRecord(pmt);
                    system.debug('dt'+dt); 
                    addToValidScope(pmtsMap.get(pmt.id));
                    objects.add(dt);
                } else {
                    addToInvalidScope(pmtsMap.get(pmt.id), 'Bank Account number is greater than 9 digits');
                }
            }
        } 
        
        
        
        system.debug(objects);
       
            filegen.CreateSegments segments = new filegen.CreateSegments(objects);
       
        
        system.debug('segments:' + segments);
       
        try{
            retVal = segments.retString();
        }catch(Exception e){
            System.debug('msg'+e.getMessage());
            System.debug('line'+e.getLineNumber());
        }
        
        system.debug('value of retval is:' + retval);
        for (String line: retVal) {
            line = line + '\r\n';
            addEntry(line);
        }
        System.debug('Return Values retval in standard details' + retval);
        return retVal;
    }
    
    public override String getHeader(loan.TransactionSweepToACHState state, List<SObject> scope) {
        String header = '';
        Map<String,Integer> countMap = (Map<String,Integer>)state.o2;
        if(countMap.get(pMode)==null){
            countMap.put(pMode,0);
            state.o2 = countMap;
        }
        List<String> retVal = new List<String>();
        List<SObject> headerRecs = new List<SObject>();
        if(getValidScope().size()>0){
            headerRecs.add(generateDescriptiverecordHeader(state));
            filegen.CreateSegments segments =new filegen.CreateSegments(headerRecs);
            retVal = segments.retString();
            try{
                header =retVal[0]+'\r\n';
            }catch(Exception e){
            
            }
            
            //header+=retVal[1] + '\r\n';
        }
        
        return header;
    }
    
    public override String getTrailer(loan.TransactionSweepToACHState state, LIST<SObject> scope) {
       
        String achFileTrailerContent = '';
        List<String> retVal = new List<String>();
        List<SObject> trailerRecs = new List<SObject>();
        if(getValidScope().size()>0){
        
            trailerRecs.add(generateFiletotalrecordtrailer(scope));
           
            filegen.CreateSegments segments =new filegen.CreateSegments(trailerRecs);
            retVal = segments.retString();
            //retVal[0] =retVal[0]+'\n';
            for(String s : retVal){
            achFileTrailerContent = achFileTrailerContent + s + '\r\n';
            }
            /*
            Integer fillersToAdd = Integer.valueOf( blocks * 10 ) - linecount;
            achFileTrailerContent = achFileTrailerContent.subString( 0 , achFileTrailerContent.length());
                 
            //fillers are added to make number of characters in generated file multiple of 940
            for(Integer i = 0 ; i < fillersToAdd ; i++ ) {
                achFileTrailerContent = achFileTrailerContent + '\r\n'+ rightPadString('', 94,'9');
            }
            achFileTrailerContent = achFileTrailerContent + '\r\n';
            */
        }
        System.debug('achFileTrailerContent'+achFileTrailerContent);
        return achFileTrailerContent;
    }
    
    //File header
    
    private Descriptive_record_header__c generateDescriptiverecordHeader(loan.TransactionSweepToACHState state){
        
        Descriptive_record_header__c drH = new Descriptive_record_header__c();
        Datetime currentSystemDateTime = systemDateTime.getCurrentSystemDate();
        Datetime currentSystemDateTime1 = currentSystemDateTime;
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
     
     
    //Batch Control
    private File_Total_Record_Trailer__c generateFiletotalrecordtrailer(LIST<SObject> scope){
        File_Total_Record_Trailer__c ftrT = new File_Total_Record_Trailer__c();
        ftrT.blank__c = '';
        ftrT.Blank2__c = '';
        ftrT.Blank3__c = '';
        //ftrT.BSB_Format_Filler__c = autoPmtConfig.loan__Bank_Account__r.loan__Routing_Number__c;
        ftrT.BSB_Format_Filler__c = '999-999';
        //ftrT.File_count_of_Records_Type_1__c = String.valueof(totalentryrecords);
        //ftrT.File_Credit_Total_Amount__c = String.valueof(totalAmount.setscale(2));
        //ftrT.File_Debit_Total_Amount__c = String.valueof(totalAmount.setscale(2));
        //ftrT.File_Net_Total_Amount__c = String.valueof('0');
        
        ftrT.File_count_of_Records_Type_1__c = loan.StringUtils.leftPadString(String.valueof(totalentryrecords),6,'0');
        ftrT.File_Debit_Total_Amount__c =  loan.StringUtils.leftPadString(String.valueof(totalAmount.setscale(2)),10,'0');
        ftrT.File_Credit_Total_Amount__c = loan.StringUtils.leftPadString('0',10,'0');
        ftrT.File_Net_Total_Amount__c = loan.StringUtils.leftPadString(String.valueof(totalAmount.setscale(2)),10,'0'); 
        system.debug(ftrT);

        return ftrT;    
    }
    
    
    //Entry Detail
    private Detail_record__c generateDetailRecord(loan__Loan_Payment_Transaction__c pmt){
        
        
        Detail_record__c dR = new Detail_record__c();
        String fullname = '';
        if(pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Account_Holder_Name__c!=null){
            fullname = pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.Account_Holder_Name__c;
        }
        
        dR.Title_of_Account__c = fullname;
        dR.Transaction_code__c = '13'; 
        system.debug(tracerec);       
        String tracebsbnew = '';
        if(!String.isBlank(autoPmtConfig.Trace_BSB__c)){
            tracebsbnew= LoanPaymentTxnPepperFileGen.validateBsb((autoPmtConfig.Trace_BSB__c!=null?autoPmtConfig.Trace_BSB__c:''));
        }
        dR.Trace_Record_BSB_number__c = tracebsbnew;
        dR.Lodgement_Reference__c = loan.StringUtils.rightPadString(pmt.name, 18, '');
        dR.Indicator__c = '';
        dR.Amount_of_Withholding_Tax__c = loan.StringUtils.leftPadString('0', 8, '0');
        dR.Name_of_Remitter__c = 'Pepper Group';

        
        totalAmount += pmt.loan__Transaction_Amount__c.setscale(2);
        system.debug('total amount:' + totalAmount);
        dR.Account_number__c = account;
        dR.Trace_Record_Account_number__c = (autoPmtConfig.Trace_Account_Number__c!=null?autoPmtConfig.Trace_Account_Number__c:'');
        system.debug('account number:' + dR.Account_number__c);
        System.debug('pmt amount: ' + pmt.loan__Transaction_Amount__c);
        Decimal amount = pmt.loan__Transaction_Amount__c.setscale(2);
        
        String bankbranchstate = LoanPaymentTxnPepperFileGen.validateBsb(pmt.loan__Automated_Payment_Setup__r.loan__Bank_Account__r.BSB__c);
        System.debug(bankbranchstate);
        dR.bank_state_branch_number__c = bankbranchstate;
        dR.Amount__c = String.valueof(amount);
         
        System.debug('amount: ' + dR.Amount__c);
        System.debug('Standard Application details' + dR);
        return dR;
        
       
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
    
    public static String validateBsb(String str){
        Boolean b = str.contains('-');
        if(b){
            return  str;
        }else{
        
            String left = str.subString(0,3);
            String right = str.subString(3,6);
            String newbsb = left+'-'+right;
            return newbsb;
        }
    }

}