global with sharing class BPayFileParser implements peer.IBankStatementParser{
    
    global List<peer.BTransaction> getTrasactions(String fileContent){
        List<peer.BTransaction> retVal = new List<peer.BTransaction>();
        peer.BTransaction bTxn;
        Set<String> referenceNumbers = new Set<String>();
        String referenceNumber, bankAccountNumber;
        Decimal amount;
        DateTime transactionDatetime;
        String header = '';
        String targetBankAccountNumber = '';
        Integer year1 = 0,month1= 0,day1= 0;
        Date statementDate;
        String particulars = '';
        Map<String,loan__Loan_Account__c> lAccMap = new Map<String,loan__Loan_Account__c>();
        //List<String> stackOfLines = new LargeFileLineSplitter().getLines(fileContent);
        loan__Payment_Mode__c pMode  = [select Id,Name from loan__Payment_Mode__c where Name='BPAY' limit 1];
        List<String> stackOfLines = String.valueOf(fileContent).split('\r\n');
        system.debug(stackOfLines);
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate = util.getCurrentSystemDate();
        Integer i = 0;
        System.debug(LoggingLevel.ERROR, 'Before WHILE');
        while(!stackOfLines[i].startsWith('9')){
            System.debug(LoggingLevel.ERROR, 'Inside WHILE');
            header = stackOfLines[i];
            system.debug(header.subString(50,60));
            year1 = Integer.valueOf(header.subString(56,60));
            month1 = Integer.valueOf(header.subString(54, 56));
            day1 = Integer.valueOf(header.subString(52, 54));
            statementDate = Date.newInstance(year1, month1, day1);
            System.debug(LoggingLevel.Error,'statementDate'+statementDate); 
            
            /*transactionDatetime = DateTime.newInstanceGMT(Integer.valueOf(year1),
                                                       Integer.valueOf(month1),
                                                       Integer.valueOf(day1),
                                                       0,0,0);*/

            //Changed by chirag for BPAY transaction posting
            //Earlier posting the transaction basis date coming in the bpay file
            //Now posting the transaction as and when the file comes into the syetem.
            Datetime actual =  Datetime.now();
            Integer offset = UserInfo.getTimezone().getOffset(actual);
            actual = actual.addSeconds(offset/1000);
            System.debug('actual : ' + actual);
            transactionDatetime = actual;

            if(transactionDateTime.date()<systemDate){
                    
                BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
                Datetime nextDay = BusinessHours.nextStartDate(bh.id, transactionDateTime);
                while (!BusinessHours.isWithin(bh.id, transactionDateTime)) {
                    transactionDateTime = BusinessHours.nextStartDate(bh.id, transactionDateTime);
                }
                    
            }
            system.debug(LoggingLevel.Error, transactionDateTime);
            i++;
            system.debug(stackOfLines);
            while(!stackOfLines[i].startsWith('9')){
                
                
                referenceNumber = stackOfLines[i].substring(1, 30).trim().toUpperCase();
                
                System.debug(LoggingLevel.ERROR,' Reference: '+referenceNumber); 
                referenceNumber = referenceNumber.trim();
                referenceNumbers.add(referenceNumber);
                
                i++;
            }
            
            List<loan__Loan_Account__c> lAcc = [select id,CRN__c,loan__Loan_Amount__c,loan__Expected_Disbursal_Date__c from loan__Loan_Account__c where CRN__c in:referenceNumbers];
            for(loan__Loan_Account__c l:lAcc){
                lAccMap.put(l.CRN__c,l);
            }
            Integer loanCancellationPeriod = (Integer)peer__Bank_Recon_Configuration__c.getInstance().peer__Loan_Cancellation_Period__c;
            if(loanCancellationPeriod == null){
                loanCancellationPeriod = 0;
            }
            i=1;
            while(!stackOfLines[i].startsWith('9')){
                
                System.debug('stackOfLines[i]'+stackOfLines[i]);
                peer.BTransaction.TransactionType transactionType;
                Boolean IsDishonor = false;
                //get transaction code
                
                String txnCodeStr = stackOfLines[i].subString(69,89).trim();
                System.debug('txnCodeStr'+txnCodeStr); 
               
                
                System.debug(LoggingLEvel.ERROR,' Transaction code '+txnCodeStr);
                
                
                
                //get Reference number from file.
                referenceNumber = stackOfLines[i].substring(1, 30).trim().toUpperCase();
                
                System.debug(LoggingLevel.ERROR,' Reference: '+referenceNumber); 
                referenceNumber = referenceNumber.trim();
                
                
                //get amount from file line.
                amount = Decimal.valueOf(stackOfLines[i].subString(32,42).trim());
                System.debug(LoggingLevel.ERROR,'  Amount: '+amount);
                amount = amount/100; 
                Date lastDateForCancellation = lAccMap.get(referenceNumber).loan__Expected_Disbursal_Date__c.addDays(loanCancellationPeriod);
                if(Date.valueOf(transactionDateTime)<=lastDateForCancellation && Math.abs(amount-lAccMap.get(referenceNumber).loan__Loan_Amount__c)>0.1){
                    transactionDateTime = DateTime.newInstance(lAccMap.get(referenceNumber).loan__Expected_Disbursal_Date__c,transactionDateTime.time());
                }
                bankAccountNumber = '';
                System.debug(LoggingLevel.ERROR,'  bank account number: '+bankAccountNumber );
                
                transactionType = peer.BTransaction.TransactionType.CREDIT;
                //create BTransaction record.
                String reference2  ;
                String reference3 ; 
                
                System.debug('referenceNumber'+referenceNumber);
                System.debug('amount'+amount);
                System.debug('bankAccountNumber'+bankAccountNumber);
                System.debug('transactionDatetime'+transactionDatetime);
                System.debug('targetBankAccountNumber'+targetBankAccountNumber);
                System.debug('statementDate'+statementDate);
                System.debug('IsDishonor'+IsDishonor);
                System.debug('String.valueOf(System.today())'+String.valueOf(System.today()));
                System.debug('reference2'+reference2);
                System.debug('reference3'+reference3);
                IsDishonor=false;
                //String.valueOf(System.today())
                
                bTxn = new peer.BTransaction(referenceNumber,
                                             amount,
                                             targetBankAccountNumber,
                                             transactionType,
                                             transactionDatetime,
                                             targetBankAccountNumber,
                                             statementDate,
                                             IsDishonor,
                                             String.valueOf(System.today()),
                                             reference2,
                                             reference3,
                                             false,
                                             pMode.Name);
                
                retVal.add(bTxn); 
                
                i++;
            }
            
        }
        System.debug(LoggingLevel.ERROR, 'Parser Works!');
        System.debug(retVal);
        return retVal;
    }
    
}