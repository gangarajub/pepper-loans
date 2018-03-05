global with sharing class BilatFileParser implements peer.IBankStatementParser{
    
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
        loan__Payment_Mode__c pMode  = [select Id,Name from loan__Payment_Mode__c where Name='OFF BSB' limit 1];
        List<String> stackOfLines = String.valueOf(fileContent).split('\r\n');
        system.debug(stackOfLines);
        Integer numberOfSegments = 0;
        Integer numberOfEntries = 0;
        for(Integer j=0;j<stackOfLines.size();j++){
            if(stackOfLines[j].startsWith('7999')){
                numberofSegments++;
            }
            
            if(stackOfLines[j].startsWith('1')){
                numberOfEntries++;
                referenceNumber = stackOfLines[j].substring(8,18).trim().toUpperCase();
                    
                System.debug(LoggingLevel.ERROR,' Reference: '+referenceNumber); 
                referenceNumber = referenceNumber.trim();
                referenceNumbers.add(referenceNumber);
            }
        }
        loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
        Date systemDate = util.getCurrentSystemDate();
        List<loan__Loan_Account__c> lAcc = [select id,CRN__c,loan__Expected_Disbursal_Date__c,loan__Loan_Amount__c from loan__Loan_Account__c where CRN__c in:referenceNumbers];
        for(loan__Loan_Account__c l:lAcc){
            lAccMap.put(l.CRN__c,l);
        }
        Integer loanCancellationPeriod = (Integer)peer__Bank_Recon_Configuration__c.getInstance().peer__Loan_Cancellation_Period__c;
        if(loanCancellationPeriod == null){
            loanCancellationPeriod = 0;
        }
        Integer i =0;
        for(Integer k=0;k<numberOfSegments;k++){
            
            
            System.debug(LoggingLevel.ERROR, 'Before WHILE');
            while((i<stackOfLines.size()) && !stackOfLines[i].startsWith('7999')){
                System.debug(LoggingLevel.ERROR, 'Inside WHILE');
                header = stackOfLines[i];
                system.debug(header.subString(78,80));
                year1 = Integer.valueOf('20'+header.subString(78,80));
                month1 = Integer.valueOf(header.subString(76,78));
                day1 = Integer.valueOf(header.subString(74,76));
                statementDate = Date.newInstance(year1, month1, day1);
                System.debug(LoggingLevel.Error,'statementDate'+statementDate); 
                
                transactionDatetime = DateTime.newInstance(Integer.valueOf(year1),
                                                           Integer.valueOf(month1),
                                                           Integer.valueOf(day1),
                                                           0,0,0);
                
                
                system.debug(LoggingLevel.Error, transactionDateTime);
                i++;
                system.debug(stackOfLines);
                
                
                if(transactionDateTime.date()<systemDate){
                  BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
                  Datetime nextDay = BusinessHours.nextStartDate(bh.id, transactionDateTime);
                  while (!BusinessHours.isWithin(bh.id, transactionDateTime)) {
                      transactionDateTime = BusinessHours.nextStartDate(bh.id, transactionDateTime);
                  }
                    
                }
                
                while((i<stackOfLines.size()) && !stackOfLines[i].startsWith('7999')){
                    
                    System.debug('stackOfLines[i]'+stackOfLines[i]);
                    peer.BTransaction.TransactionType transactionType;
                    Boolean IsDishonor = false;
                    //get transaction code
                    
                    
                    //get Reference number from file.
                    referenceNumber = stackOfLines[i].substring(8,18).trim().toUpperCase();
                    
                    System.debug(LoggingLevel.ERROR,' Reference: '+referenceNumber); 
                    referenceNumber = referenceNumber.trim();
                    
                    
                    //get amount from file line.
                    amount = Decimal.valueOf(stackOfLines[i].subString(21,30).trim());
                    System.debug(LoggingLevel.ERROR,'  Amount: '+amount);
                    amount = amount/100;
                    
                    
                    
                    if(lAccMap.get(referenceNumber) != null){
                        Date lastDateForCancellation = lAccMap.get(referenceNumber).loan__Expected_Disbursal_Date__c.addDays(loanCancellationPeriod);
                        if(Date.valueOf(transactionDateTime)<=lastDateForCancellation && Math.abs(amount-lAccMap.get(referenceNumber).loan__Loan_Amount__c)>0.1){
                            transactionDateTime = DateTime.newInstance(lAccMap.get(referenceNumber).loan__Expected_Disbursal_Date__c,transactionDateTime.time());
                        }
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
                i++;
            }
        }
        
        System.debug(LoggingLevel.ERROR, 'Parser Works!');
        System.debug(retVal);
        return retVal;
    }
    
}