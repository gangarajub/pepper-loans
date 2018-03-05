public class BankStatementParser  {
    String accountHolder, accountNumber, bsbNumber, bankName;
    String totalCredits, totalDebits, openingBalance, closingBalance;
    String startDate, endDate, minBalance, maxBalance, minDayEndBalance, daysInNegative;
    String datex, text, notes, amount, type, balance, tag;
    String timestamp, timezonetype, timezone;
    String transactionCount, totalValue, monthAvg;
    String dayEndBalanceDate, dayEndBalanceDateBalance;
    String fieldName;
    String minValue, maxValue, firstTransaction, lastTransaction, period, periodIsRegular;
    String alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Map<Bank_Common_Transaction__c, Bank_details__c> detailMap = new Map<Bank_Common_Transaction__c, Bank_details__c>();
    
    Map<Bank_DayEndBalances__c, Bank_statementdata__c> dayEndBalanceMap = new Map<Bank_DayEndBalances__c, Bank_statementdata__c>();
    
    Map<Bank_Common_Transaction__c, Bank_transactionObjects__c> bankTransactionObjectMap = new Map<Bank_Common_Transaction__c, Bank_transactionObjects__c>();
    Map<Bank_Income__c, Bank_analysis__c> BankIncomeAnalysisMap = new Map<Bank_Income__c, Bank_analysis__c>();
    Map<Bank_Benefits__c, Bank_analysis__c> BankBenefitsAnalysisMap = new Map<Bank_Benefits__c, Bank_analysis__c>();
    Map<Bank_Dishonours__c, Bank_analysis__c> BankDishonoursAnalysisMap = new Map<Bank_Dishonours__c, Bank_analysis__c>();
    Map<Bank_Loans__c, Bank_analysis__c> BankLoansAnalysisMap = new Map<Bank_Loans__c, Bank_analysis__c>();
    Map<Bank_Rent__c, Bank_analysis__c> BankRentAnalysisMap = new Map<Bank_Rent__c, Bank_analysis__c>();
    Map<Bank_Gambling__c, Bank_analysis__c> BankGamblingAnalysisMap = new Map<Bank_Gambling__c, Bank_analysis__c>();
    Map<Bank_Other_Debits__c, Bank_analysis__c> BankOtherDebitsAnalysisMap = new Map<Bank_Other_Debits__c, Bank_analysis__c>();
    
    Map<Bank_total__c, Bank_Income__c> BankTotalIncomeMap = new Map<Bank_total__c, Bank_Income__c>();
    Map<Bank_total__c, Bank_Benefits__c> BankTotalBenefitsMap = new Map<Bank_total__c, Bank_Benefits__c>();
    Map<Bank_total__c, Bank_Dishonours__c> BankTotalDishnoursMap = new Map<Bank_total__c, Bank_Dishonours__c>();
    Map<Bank_total__c, Bank_Loans__c> BankTotalLoansMap = new Map<Bank_total__c, Bank_Loans__c>();
    Map<Bank_total__c, Bank_Rent__c> BankTotalRentMap = new Map<Bank_total__c, Bank_Rent__c>();
    Map<Bank_total__c, Bank_Gambling__c> BankTotalGamblingMap = new Map<Bank_total__c, Bank_Gambling__c>();
    Map<Bank_total__c, Bank_Other_Debits__c> BankTotalOtherDebitMap = new Map<Bank_total__c, Bank_Other_Debits__c>();
    
    Map<Bank_analysis_txn__c, Bank_Income__c> BankAnalysisTxnIncomeMap = new Map<Bank_analysis_txn__c, Bank_Income__c>();
    Map<Bank_analysis_txn__c, Bank_Benefits__c> BankAnalysisTxnBenefitsMap = new Map<Bank_analysis_txn__c, Bank_Benefits__c>();
    Map<Bank_analysis_txn__c, Bank_Dishonours__c> BankAnalysisTxnDishonourMap = new Map<Bank_analysis_txn__c, Bank_Dishonours__c>();
    Map<Bank_analysis_txn__c, Bank_Loans__c> BankAnalysisTxnLoansMap = new Map<Bank_analysis_txn__c, Bank_Loans__c>();
    Map<Bank_analysis_txn__c, Bank_Rent__c> BankAnalysisTxnRentMap = new Map<Bank_analysis_txn__c, Bank_Rent__c>();
    Map<Bank_analysis_txn__c, Bank_Gambling__c> BankAnalysisTxnGambletMap = new Map<Bank_analysis_txn__c, Bank_Gambling__c>();
    Map<Bank_analysis_txn__c, Bank_Other_Debits__c> BankAnalysisTxnOtherDebitsMap = new Map<Bank_analysis_txn__c, Bank_Other_Debits__c>();
    
    Map<String, Bank_Common_Transaction__c> BankCommonDetailsAnalysisTxnMap = new Map<String, Bank_Common_Transaction__c>();
    Map<String,Bank_analysis_txn__c> fieldMaptoAnalysis = new  Map<String,Bank_analysis_txn__c>();
    List<sObject> listStmtRecords = new List<sObject>();
    Set<sObject> listDetailsRecords = new Set<sObject>();
    List<sObject> listOfDetailAndTxn = new List<sObject>();
    List<Bank_Common_Transaction__c> listofCommon = new List<Bank_Common_Transaction__c>();  
    public Bank_Common_Transaction__c insertCommonTxnRecords(String datex, String text, String notes, String amount,
                                                             String type, String balance, String tag, String timestamp, String timezone, String timezonetype) {
                                                                 Bank_Common_Transaction__c bankCommonDetails = new Bank_Common_Transaction__c();
                                                                 
                                                                 bankCommonDetails.datex__c = datex;
                                                                 bankCommonDetails.text__c = text;
                                                                 bankCommonDetails.notes__c = notes;
                                                                 bankCommonDetails.amount__c = amount;
                                                                 bankCommonDetails.type__c = type;
                                                                 bankCommonDetails.balance__c = balance;
                                                                 bankCommonDetails.tag__c = tag;
                                                                 bankCommonDetails.TimeStamp__c = timestamp;
                                                                 bankCommonDetails.timezone__c = timezone;
                                                                 bankCommonDetails.timezonetype__c = timezonetype;
                                                                 
                                                                 return bankCommonDetails;
                                                             }
    
    public Bank_total__c insertTotalBankRecords(String transactionCount, String totalValue, String monthAvg) {
        Bank_total__c bankTotal = new Bank_total__c();
        bankTotal.transactionCount__c = transactionCount;
        bankTotal.totalValue__c = totalValue;
        bankTotal.monthAvg__c = monthAvg;
        return bankTotal;
    }
    
    public Bank_analysis_txn__c insertAnalysisRecord(String fieldName, String transactionCount, String totalValue,
                                                     String monthAvg, String minValue, String maxValue, String firstTransaction, String lastTransaction,
                                                     String period, String periodIsRegular) {
                                                         
                                                         Bank_analysis_txn__c txn = new Bank_analysis_txn__c();
                                                         txn.FieldName__c = fieldName;
                                                         txn.transactionCount__c = transactionCount;
                                                         txn.totalValue__c = totalValue;
                                                         txn.monthAvg__c = monthAvg;
                                                         txn.minValue__c = minValue;
                                                         txn.maxValue__c = maxValue;
                                                         txn.firstTransaction__c = firstTransaction;
                                                         txn.lastTransaction__c = lastTransaction;
                                                         txn.period__c = period;
                                                         txn.periodIsRegular__c = periodIsRegular;
                                                         return txn;
                                                         
                                                     }
    
    public void insertAnalysisCommonMethod(Dom.XMLNode parentNode,sObject parent,String typeOfRecord){
        
        
        for (Dom.XMLNode child8 : parentNode.getChildElements()){
            system.debug('type2'+type);
            if(child8.getName().trim().equalsIgnoreCase('total')){
                for (Dom.XMLNode child9: child8.getChildElements()){
                    if(child9.getName().trim().equalsIgnoreCase('transactionCount')){
                        transactionCount = child9.getText();
                    }else if(child9.getName().trim().equalsIgnoreCase('totalValue')){
                        totalValue = child9.getText();
                    }else if(child9.getName().trim().equalsIgnoreCase('monthAvg')){
                        monthAvg = child9.getText();
                    }
                }
                Bank_total__c bankTotal=insertTotalBankRecords(transactionCount,totalValue,monthAvg);
                
                if(typeOfRecord.equalsIgnoreCase('Income')){
                    BankTotalIncomeMap.put(bankTotal,(Bank_Income__c)parent);
                }
                
                if(typeOfRecord.equalsIgnoreCase('Benefits')){
                    BankTotalBenefitsMap.put(bankTotal,(Bank_Benefits__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Dishonours')){
                    BankTotalDishnoursMap.put(bankTotal,(Bank_Dishonours__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Loans')){
                    BankTotalLoansMap.put(bankTotal,(Bank_Loans__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Rent')){
                    BankTotalRentMap.put(bankTotal,(Bank_Rent__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Gambling')){
                    BankTotalGamblingMap.put(bankTotal,(Bank_Gambling__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('OtherDebits')){
                    BankTotalOtherDebitMap.put(bankTotal,(Bank_Other_Debits__c)parent);
                }
                
                listDetailsRecords.add(parent);
            }else{
                system.debug('type1'+type);
                fieldName=child8.getName();
                Bank_analysis_txn__c analysisTxn = new Bank_analysis_txn__c();
                system.debug('child8'+child8.getName());
                for (Dom.XMLNode child9: child8.getChildElements()){
                    system.debug('child9'+child9);
                    if(child9.getName().trim().equalsIgnoreCase('transactionCount')){
                        transactionCount = child9.getText();
                        
                    }else if(child9.getName().trim().equalsIgnoreCase('totalValue')){
                        totalValue = child9.getText();
                        
                    }else if(child9.getName().trim().equalsIgnoreCase('monthAvg')){
                        monthAvg = child9.getText();
                        
                    }
                    else if(child9.getName().trim().equalsIgnoreCase('minValue')){
                        minValue = child9.getText();
                        
                    }
                    else if(child9.getName().trim().equalsIgnoreCase('maxValue')){
                        maxValue = child9.getText();
                        
                    }
                    else if(child9.getName().trim().equalsIgnoreCase('firstTransaction')){
                        firstTransaction = child9.getText();
                        
                    }
                    else if(child9.getName().trim().equalsIgnoreCase('lastTransaction')){
                        lastTransaction = child9.getText();
                        
                    }
                    else if(child9.getName().trim().equalsIgnoreCase('period')){
                        period = child9.getText();
                        
                    }
                    else if(child9.getName().trim().equalsIgnoreCase('periodIsRegular')){
                        periodIsRegular = child9.getText();
                        
                    }
                    else if(child9.getName().trim().equalsIgnoreCase('transactions')){
                        for (Dom.XMLNode child10: child9.getChildElements()){
                            if(child10.getName().trim().equalsIgnoreCase('transaction')){
                                for (Dom.XMLNode child11: child10.getChildElements()){
                                    if(child11.getName().trim().equalsIgnoreCase('date')){
                                        datex=child11.getText();
                                    }
                                    if(child11.getName().trim().equalsIgnoreCase('text')){
                                        text=child11.getText();
                                    }
                                    if(child11.getName().trim().equalsIgnoreCase('notes')){
                                        notes=child11.getText();
                                    }
                                    if(child11.getName().trim().equalsIgnoreCase('amount')){
                                        amount=child11.getText();
                                    }
                                    if(child11.getName().trim().equalsIgnoreCase('type')){
                                        type=child11.getText();
                                    }
                                    if(child11.getName().trim().equalsIgnoreCase('balance')){
                                        balance=child11.getText();
                                    }
                                    
                                    if(child11.getName().trim().equalsIgnoreCase('tags')){
                                        for (Dom.XMLNode child12: child11.getChildElements()){
                                            if(child12.getName().trim().equalsIgnoreCase('tag')){
                                                tag=child12.getText();  
                                            }
                                        }
                                    }
                                    
                                    if(child11.getName().trim().equalsIgnoreCase('dateObj')){
                                        
                                        for (Dom.XMLNode child12: child11.getChildElements()){
                                            
                                            if(child12.getName().trim().equalsIgnoreCase('date')){
                                                timestamp=child12.getText();  
                                            }
                                            if(child12.getName().trim().equalsIgnoreCase('timezone')){
                                                timezone=child12.getText();  
                                            }
                                            if(child12.getName().trim().equalsIgnoreCase('timezone_type')){
                                                timezonetype=child12.getText();  
                                            }
                                        }
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            Bank_Common_Transaction__c  bankCommonDetails=insertCommonTxnRecords(datex,text,notes,amount,type,balance,tag,timestamp,timezone,timezonetype);
                            BankCommonDetailsAnalysisTxnMap.put(fieldName,bankCommonDetails);   
                            
                            //System.debug('BankCommonDetailsAnalysisTxnMap'+BankCommonDetailsAnalysisTxnMap);
                            
                            
                            
                            
                        }
                    }
                }
                analysisTxn  = insertAnalysisRecord(fieldName,transactionCount,totalValue,monthAvg,minValue,maxValue,firstTransaction,lastTransaction,period,periodIsRegular);
                listDetailsRecords.add(parent);
                fieldMaptoAnalysis.put(fieldName,analysisTxn);
                system.debug('type123'+type);
                if(typeOfRecord.equalsIgnoreCase('Income')){
                    
                    BankAnalysisTxnIncomeMap.put(analysisTxn,(Bank_Income__c)parent);
                    system.debug('BankAnalysisTxnIncomeMap'+BankAnalysisTxnIncomeMap);
                }
                
                if(typeOfRecord.equalsIgnoreCase('Benefits')){
                    BankAnalysisTxnBenefitsMap.put(analysisTxn,(Bank_Benefits__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Dishonours')){
                    BankAnalysisTxnDishonourMap.put(analysisTxn,(Bank_Dishonours__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Loans')){
                    BankAnalysisTxnLoansMap.put(analysisTxn,(Bank_Loans__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Rent')){
                    BankAnalysisTxnRentMap.put(analysisTxn,(Bank_Rent__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('Gambling')){
                    BankAnalysisTxnGambletMap.put(analysisTxn,(Bank_Gambling__c)parent);
                }
                if(typeOfRecord.equalsIgnoreCase('OtherDebits')){
                    BankAnalysisTxnOtherDebitsMap.put(analysisTxn,(Bank_Other_Debits__c)parent);
                }
                
            }
        }
        listDetailsRecords.add(parent);
        
        
    }
    
    public boolean parseAndInsertStatement(String xmlString,String app,String slugName){
        System.debug('requestxml'+xmlString);
        DOM.Document doc = new DOM.Document();      
        
        try {
            doc.load(xmlString);    
            DOM.XMLNode root = doc.getRootElement();
            
            for (Dom.XMLNode child1: root.getChildElements()) {
                if (child1.getName().trim().equalsIgnoreCase('accounts')) {
                    for (Dom.XMLNode child2: child1.getChildElements()){
                        if (child2.getName().trim().equalsIgnoreCase(slugName)) {
                            for (Dom.XMLNode child3: child2.getChildElements()){
                                if (child3.getName().trim().equalsIgnoreCase('accounts')) {
                                    for (Dom.XMLNode child4: child3.getChildElements()){
                                        if (child4.getName().trim().equalsIgnoreCase('account')){
                                            list<loan__Bank_Account__c> existingbankAccount = new list<loan__Bank_Account__c>();
                                            list<loan__Bank_Account__c> existingbankAccountWithDifferentAccount = new list<loan__Bank_Account__c>();
                                            loan__Bank_Account__c bankAccount = new loan__Bank_Account__c(); 
                                            Bank_Statement__c bankStmtJn = new Bank_Statement__c();
                                            for (Dom.XMLNode child5: child4.getChildElements()){
                                                if (child5.getName().trim().equalsIgnoreCase('accountHolder')){
                                                    accountHolder= child5.getText();
                                                }else if(child5.getName().trim().equalsIgnoreCase('accountNumber')){
                                                    accountNumber=child5.getText();
                                                    accountNumber = accountNumber.replace(' ','');
                                                    accountNumber = accountNumber.replace('-','');
                                                }else if(child5.getName().trim().equalsIgnoreCase('bsb')){
                                                    bsbNumber=child5.getText().trim();
                                                    bsbNumber = bsbNumber.replace(' ','');
                                                    bsbNumber = bsbNumber.replace('-','');
                                                }else if(child5.getName().trim().equalsIgnoreCase('institution')){
                                                    bankName=child5.getText();
                                                }
                                            }
                                            List<genesis__Applications__c> ac = [select id,genesis__Account__c from genesis__Applications__c where id=:app];
                                            
                                            if(ac.size()>0){
                                                existingbankAccount = [select id,name from loan__Bank_Account__c where
                                                                       Account_Holder_Name__c=:accountHolder AND
                                                                       Bank_Account_Number__c=:accountNumber AND
                                                                       BSB__c=:bsbNumber AND
                                                                       loan__Bank_Name__c=:bankName AND loan__Account__c=:ac[0].genesis__Account__c limit 1];
                                                if(existingbankAccount.size()>0){
                                                    bankStmtJn.Bank_Account__c=existingbankAccount[0].Id;
                                                    bankStmtJn.Application__c=App;
                                                    
                                                    insert bankStmtJn;
                                                    System.debug('bankStmtJn'+bankStmtJn);
                                                }else{
                                                    bankAccount.Account_Holder_Name__c=accountHolder;
                                                    bankAccount.Bank_Account_Number__c=accountNumber;
                                                    bankAccount.loan__Bank_Account_Number__c=accountNumber;
                                                    bankAccount.BSB__c=bsbNumber;
                                                    bankAccount.loan__Account_Usage__c='Borrower/Investor Account';
                                                    bankAccount.loan__Bank_Name__c=bankName;
                                                    bankAccount.loan__Account__c=ac[0].genesis__Account__c;
                                                    if(bsbNumber.containsAny(alphabet)){
                                                        bankAccount.Invalid__c = true;
                                                    }
                                                    if(accountNumber.containsAny(alphabet)){
                                                        bankAccount.Invalid__c = true;
                                                    }
                                                    System.debug('bankAccount'+bankAccount);
                                                    insert bankAccount;
                                                    bankStmtJn.Bank_Account__c=bankAccount.Id;
                                                    bankStmtJn.Application__c=App;
                                                    insert bankStmtJn;
                                                    
                                                }
                                                
                                            }
                                            
                                            
                                            
                                            for (Dom.XMLNode child5: child4.getChildElements()){
                                                if (child5.getName().trim().equalsIgnoreCase('statementData')){
                                                    Bank_statementdata__c stmtDate = new Bank_statementdata__c();
                                                    for (Dom.XMLNode child6: child5.getChildElements()){
                                                        
                                                        
                                                        if(child6.getName().trim().equalsIgnoreCase('totalCredits')){
                                                            totalCredits=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('totalDebits')){
                                                            totalDebits=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('openingBalance')){
                                                            openingBalance=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('closingBalance')){
                                                            closingBalance=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('startDate')){
                                                            startDate=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('endDate')){
                                                            endDate=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('minBalance')){
                                                            minBalance=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('maxBalance')){
                                                            maxBalance=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('minDayEndBalance')){
                                                            minDayEndBalance=child6.getText();
                                                        }
                                                        if(child6.getName().trim().equalsIgnoreCase('daysInNegative')){
                                                            daysInNegative=child6.getText();
                                                        }
                                                        
                                                    }
                                                    
                                                    stmtDate.totalDebits__c=totalDebits;
                                                    stmtDate.totalCredits__c=totalCredits;
                                                    stmtDate.openingBalance__c=openingBalance;
                                                    stmtDate.closingBalance__c=closingBalance;
                                                    stmtDate.startDate__c=startDate;
                                                    stmtDate.endDate__c=endDate;
                                                    stmtDate.minBalance__c=minBalance;
                                                    stmtDate.maxBalance__c=maxBalance;
                                                    stmtDate.minDayEndBalance__c=minDayEndBalance;
                                                    stmtDate.daysInNegative__c=daysInNegative;
                                                    stmtDate.Bank_Statement__c=bankStmtJn.Id;
                                                    //listStmtRecords.add(stmtDate);
                                                    insert stmtDate;
                                                    Bank_details__c bankDetails = new Bank_details__c();
                                                    Bank_transactionObjects__c bankTransactionObj = new Bank_transactionObjects__c();
                                                    bankDetails.Bank_statementdata__c=stmtDate.Id;
                                                    bankTransactionObj.Bank_statementdata__c=stmtDate.Id;
                                                    Bank_DayEndBalances__c dayEndBalanceParent = new Bank_DayEndBalances__c();
                                                    dayEndBalanceParent.Bank_statementdata__c=stmtDate.Id;
                                                    insert dayEndBalanceParent;
                                                    insert bankDetails;
                                                    insert bankTransactionObj;
                                                    Bank_analysis__c bankAnalysis = new Bank_analysis__c();
                                                    bankAnalysis.statementdata__c=stmtDate.Id;
                                                    insert bankAnalysis;  
                                                    for (Dom.XMLNode child6: child5.getChildElements()){
                                                        
                                                        
                                                        if(child6.getName().trim().equalsIgnoreCase('details')){
                                                            
                                                            for (Dom.XMLNode child7: child6.getChildElements()){
                                                                if(child7.getName().trim().equalsIgnoreCase('detail')){
                                                                    for (Dom.XMLNode child8: child7.getChildElements()){
                                                                        if(child8.getName().trim().equalsIgnoreCase('date')){
                                                                            datex=child8.getText();
                                                                        }
                                                                        if(child8.getName().trim().equalsIgnoreCase('text')){
                                                                            text=child8.getText();
                                                                        }
                                                                        if(child8.getName().trim().equalsIgnoreCase('notes')){
                                                                            notes=child8.getText();
                                                                        }
                                                                        if(child8.getName().trim().equalsIgnoreCase('amount')){
                                                                            amount=child8.getText();
                                                                        }
                                                                        if(child8.getName().trim().equalsIgnoreCase('type')){
                                                                            type=child8.getText();
                                                                        }
                                                                        if(child8.getName().trim().equalsIgnoreCase('balance')){
                                                                            balance=child8.getText();
                                                                        }
                                                                        
                                                                        if(child8.getName().trim().equalsIgnoreCase('tags')){
                                                                            for (Dom.XMLNode child9: child8.getChildElements()){
                                                                                if(child9.getName().trim().equalsIgnoreCase('tag')){
                                                                                    tag=child9.getText();  
                                                                                }
                                                                            }
                                                                        }
                                                                        
                                                                        if(child8.getName().trim().equalsIgnoreCase('dateObj')){
                                                                            for (Dom.XMLNode child9: child8.getChildElements()){
                                                                                
                                                                                if(child9.getName().trim().equalsIgnoreCase('date')){
                                                                                    timestamp=child9.getText();  
                                                                                }
                                                                                if(child9.getName().trim().equalsIgnoreCase('timezone')){
                                                                                    timezone=child9.getText();  
                                                                                }
                                                                                if(child9.getName().trim().equalsIgnoreCase('timezone_type')){
                                                                                    timezonetype=child9.getText();  
                                                                                }
                                                                            }
                                                                            
                                                                        }
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                                Bank_Common_Transaction__c  bankCommonDetails=insertCommonTxnRecords(datex,text,notes,amount,type,balance,tag,timestamp,timezone,timezonetype);
                                                                bankCommonDetails.Bank_Details__c=bankDetails.Id;
                                                                listDetailsRecords.add(bankCommonDetails); 
                                                                //detailMap.put(bankCommonDetails,bankDetails);
                                                                
                                                            }   
                                                        }
                                                        else if(child6.getName().trim().equalsIgnoreCase('dayEndBalances')){
                                                            
                                                            
                                                            
                                                            for (Dom.XMLNode child7: child6.getChildElements()){
                                                                Bank_DayEndBalanceRecords__c dayEndBalance = new Bank_DayEndBalanceRecords__c(); 
                                                                if(child7.getName().trim().equalsIgnoreCase('dayEndBalance')){
                                                                    for (Dom.XMLNode child8: child7.getChildElements()){
                                                                        if(child8.getName().trim().equalsIgnoreCase('date')){
                                                                            dayEndBalanceDate=child8.getText();  
                                                                        }
                                                                        if(child8.getName().trim().equalsIgnoreCase('balance')){
                                                                            dayEndBalanceDateBalance=child8.getText();
                                                                        }
                                                                        
                                                                        
                                                                    }
                                                                }
                                                                dayEndBalance.datex__c= dayEndBalanceDate;
                                                                dayEndBalance.balance__c=dayEndBalanceDateBalance;
                                                                dayEndBalance.BankEndDayBalance__c=dayEndBalanceParent.Id;
                                                                listDetailsRecords.add(dayEndBalance); 
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        else if(child6.getName().trim().equalsIgnoreCase('transactionObjects')){
                                                            
                                                            
                                                            for (Dom.XMLNode child7: child6.getChildElements()){
                                                                if(child7.getName().trim().equalsIgnoreCase('transactionObject')){
                                                                    for (Dom.XMLNode child8: child7.getChildElements()){
                                                                        if(child8!=null){
                                                                            
                                                                            if(child8.getName().trim().equalsIgnoreCase('date')){
                                                                                datex=child8.getText();
                                                                            }
                                                                            if(child8.getName().trim().equalsIgnoreCase('text')){
                                                                                text=child8.getText();
                                                                            }
                                                                            if(child8.getName().trim().equalsIgnoreCase('notes')){
                                                                                notes=child8.getText();
                                                                            }
                                                                            if(child8.getName().trim().equalsIgnoreCase('amount')){
                                                                                amount=child8.getText();
                                                                            }
                                                                            if(child8.getName().trim().equalsIgnoreCase('type')){
                                                                                type=child8.getText();
                                                                            }
                                                                            if(child8.getName().trim().equalsIgnoreCase('balance')){
                                                                                balance=child8.getText();
                                                                            }
                                                                            
                                                                            if(child8.getName().trim().equalsIgnoreCase('tags')){
                                                                                for (Dom.XMLNode child9: child8.getChildElements()){
                                                                                    if(child8.getName().trim().equalsIgnoreCase('tag')){
                                                                                        tag=child9.getText();  
                                                                                    }
                                                                                }
                                                                            }
                                                                            
                                                                            if(child8.getName().trim().equalsIgnoreCase('dateObj')){
                                                                                
                                                                                for (Dom.XMLNode child9: child8.getChildElements()){
                                                                                    if(child8.getName().trim().equalsIgnoreCase('date')){
                                                                                        timestamp=child9.getText();  
                                                                                    }
                                                                                    if(child8.getName().trim().equalsIgnoreCase('timezone')){
                                                                                        timezone=child9.getText();  
                                                                                    }
                                                                                    if(child8.getName().trim().equalsIgnoreCase('timezone_type')){
                                                                                        timezonetype=child9.getText();  
                                                                                    }
                                                                                }
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                
                                                                Bank_Common_Transaction__c  bankCommonDetails=insertCommonTxnRecords(datex,text,notes,amount,type,balance,tag,timestamp,timezone,timezonetype);
                                                                bankCommonDetails.Bank_transactionObjects__c=bankTransactionObj.Id;
                                                                listDetailsRecords.add(bankCommonDetails); 
                                                                //bankTransactionObjectMap.put(bankCommonDetails,bankTransactionObj);
                                                                
                                                            }
                                                            
                                                        }
                                                        else if(child6.getName().trim().equalsIgnoreCase('analysis')){   
                                                            
                                                            for (Dom.XMLNode child7: child6.getChildElements()){
                                                                System.debug('child7'+child7.getName());
                                                                if(child7.getName().trim().equalsIgnoreCase('Income')){
                                                                    Bank_Income__c bIncom = new Bank_Income__c();
                                                                    
                                                                    bIncom.Bank_analysis__c=bankAnalysis.Id;
                                                                    
                                                                    insertAnalysisCommonMethod(child7,bIncom,'Income');
                                                                } else if(child7.getName().trim().equalsIgnoreCase('Benefits')){
                                                                    Bank_Benefits__c bankBenefits =  new Bank_Benefits__c();
                                                                    
                                                                    bankBenefits.Bank_analysis__c=bankAnalysis.Id;
                                                                    
                                                                    insertAnalysisCommonMethod(child7,bankBenefits,'Benefits'); 
                                                                    
                                                                } else if(child7.getName().trim().equalsIgnoreCase('Dishonours')){
                                                                    Bank_Dishonours__c bankDish = new Bank_Dishonours__c();
                                                                    
                                                                    bankDish.Bank_analysis__c=bankAnalysis.Id;
                                                                    
                                                                    insertAnalysisCommonMethod(child7,bankDish,'Dishonours'); 
                                                                    
                                                                } else if(child7.getName().trim().equalsIgnoreCase('Loans')){
                                                                    Bank_Loans__c bnkLoans = new Bank_Loans__c();
                                                                    //BankLoansAnalysisMap.put(bnkLoans,bankAnalysis); 
                                                                    bnkLoans.Bank_analysis__c=bankAnalysis.Id;
                                                                    //listDetailsRecords.add(bnkLoans);
                                                                    insertAnalysisCommonMethod(child7,bnkLoans,'Loans'); 
                                                                    
                                                                } else if(child7.getName().trim().equalsIgnoreCase('Rent')){
                                                                    Bank_Rent__c bankRent = new Bank_Rent__c();
                                                                    System.debug('child7'+child7);
                                                                    bankRent.Bank_analysis__c=bankAnalysis.Id;
                                                                    
                                                                    insertAnalysisCommonMethod(child7,bankRent,'Rent'); 
                                                                    
                                                                } else if(child7.getName().trim().equalsIgnoreCase('Gambling')){
                                                                    Bank_Gambling__c bankGamble = new Bank_Gambling__c();
                                                                    
                                                                    bankGamble.Bank_analysis__c=bankAnalysis.Id;
                                                                    
                                                                    insertAnalysisCommonMethod(child7,bankGamble,'Gambling'); 
                                                                    
                                                                } else if(child7.getName().trim().equalsIgnoreCase('Other Debits')){
                                                                    Bank_Other_Debits__c bankOther = new Bank_Other_Debits__c();
                                                                    
                                                                    bankOther.Bank_analysis__c=bankAnalysis.Id;
                                                                    
                                                                    insertAnalysisCommonMethod(child7,bankOther,'OtherDebits'); 
                                                                }                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
            }//end of parser
            
            system.debug('BankAnalysisTxnIncomeMap'+BankAnalysisTxnIncomeMap);
            List<SObject> m = new List<sObject>();
            saveSobjectSet(listDetailsRecords);
            
            Map<sObject,Id> mp = new Map<sObject,Id>();
            for(sobject s : listDetailsRecords){
                mp.put(s,s.Id);
                
            }
            Set<sObject> child = new Set<sObject>();
            for(Bank_total__c bs:BankTotalIncomeMap.keySet()){
                sObject o =BankTotalIncomeMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Income__c=p;
                child.add(bs);
            }
            for(Bank_total__c bs: BankTotalBenefitsMap.keySet()){
                sObject o =BankTotalBenefitsMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Benefits__c=p;
                child.add(bs);
            }
            for(Bank_total__c bs: BankTotalDishnoursMap.keySet()){
                sObject o =BankTotalDishnoursMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Dishonours__c=p;
                child.add(bs);
            }
            for(Bank_total__c bs:BankTotalLoansMap.keySet()){
                sObject o =BankTotalLoansMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_loans__c=p;
                child.add(bs);
            }
            for(Bank_total__c bs:BankTotalRentMap.keySet()){
                sObject o =BankTotalRentMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Rent__c=p;
                child.add(bs);
            }
            for(Bank_total__c bs:BankTotalGamblingMap.keySet()){
                sObject o =BankTotalGamblingMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Gambling__c=p;
                child.add(bs);
            }
            for(Bank_total__c bs:BankTotalOtherDebitMap.keySet()){
                sObject o =BankTotalOtherDebitMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Other_Debit__c=p;
                child.add(bs);
            }
            for(Bank_analysis_txn__c bs:BankAnalysisTxnIncomeMap.keySet()){
                sObject o =BankAnalysisTxnIncomeMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Income__c=p;
                child.add(bs);
            }
            
            for(Bank_analysis_txn__c bs:BankAnalysisTxnBenefitsMap.keySet()){
                sObject o =BankAnalysisTxnBenefitsMap.get(bs);
                Id p = mp.get(o);
                bs.Benefits__c=p;
                child.add(bs);
            }
            
            for(Bank_analysis_txn__c bs:BankAnalysisTxnDishonourMap.keySet()){
                sObject o =BankAnalysisTxnDishonourMap.get(bs);
                Id p = mp.get(o);
                bs.dishonours__c=p;
                child.add(bs);
            }
            
            for(Bank_analysis_txn__c bs:BankAnalysisTxnLoansMap.keySet()){
                sObject o =BankAnalysisTxnLoansMap.get(bs);
                Id p = mp.get(o);
                bs.Loans__c=p;
                child.add(bs);
            }
            
            for(Bank_analysis_txn__c bs:BankAnalysisTxnRentMap.keySet()){
                sObject o =BankAnalysisTxnRentMap.get(bs);
                Id p = mp.get(o);
                bs.Rent__c =p;
                child.add(bs);
            }
            
            for(Bank_analysis_txn__c bs:BankAnalysisTxnGambletMap.keySet()){
                sObject o =BankAnalysisTxnGambletMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Gambling__c=p;
                child.add(bs);
            }
            
            for(Bank_analysis_txn__c bs:BankAnalysisTxnOtherDebitsMap.keySet()){
                sObject o =BankAnalysisTxnOtherDebitsMap.get(bs);
                Id p = mp.get(o);
                bs.Bank_Other_Debits__c=p;
                child.add(bs);
            }
            
            
            
           
            saveSobjectSet(child);
            
            Map<sObject,Id> mp2 = new Map<sObject,Id>();
            for(sobject s : child){
                mp2.put(s,s.Id);
                system.debug('mp2'+mp2);
            }
            Set<sObject> child2 = new Set<sObject>();
            system.debug('BankCommonDetailsAnalysisTxnMap'+BankCommonDetailsAnalysisTxnMap);
            
            for(String bs:BankCommonDetailsAnalysisTxnMap.keySet()){
                Bank_analysis_txn__c  P =fieldMaptoAnalysis.get(bs);
                Bank_Common_Transaction__c  z = BankCommonDetailsAnalysisTxnMap.get(bs);
                z.Bank_analysis_txn__c=P.Id;
                child2.add(z);
                system.debug('child2'+child2);
            }
            
            //child2.sort();
            //insert child2;
            saveSobjectSet(child2);     
            
        }
        
        catch (System.XMLException e) {  
            System.debug('Ex'+e.getMessage());
            return false;
        }
        return true;    
    }
    static void saveSobjectSet(Set <Sobject> setToUpdate) {
       Integer SFDC_CHUNK_LIMIT = 5;
    
       // Developed this part due to System.TypeException: Cannot have more than 10 chunks in a single operation
       Map<Schema.SObjectType, List<Sobject>> sortedMapPerObjectType = new Map<Schema.SObjectType, List<Sobject>>();
       for (Sobject obj : setToUpdate) {
        Schema.SObjectType objType = obj.getSObjectType();
        if (! sortedMapPerObjectType.containsKey(objType)) {
                sortedMapPerObjectType.put(objType, new List<Sobject>());
        }
        sortedMapPerObjectType.get(objType).add(obj);
       }
       List<Schema.SObjectType> keyListSobjectType = new List<Schema.SObjectType>(sortedMapPerObjectType.keySet());
       System.debug('sortedMapPerObjectType.size='+sortedMapPerObjectType.size());
       decimal d = (decimal)sortedMapPerObjectType.size() /5;   
         
       decimal numberOfListsToBeCreated=(decimal)d.round(system.RoundingMode.CEILING);
       System.debug('numberOfListsToBeCreated='+numberOfListsToBeCreated);
       while(numberOfListsToBeCreated!=0) {
        // Create a new list, which can contain a max of chunking limit, and sorted, so we don't get any errors 
       List<Sobject> safeListForChunking = new List<Sobject>();
        System.debug('counter='+numberOfListsToBeCreated);
        for (Integer i = 0;i<SFDC_CHUNK_LIMIT && !sortedMapPerObjectType.isEmpty();i++) {
               List<Sobject> listSobjectOfOneType = sortedMapPerObjectType.remove(keyListSobjectType.remove(0));
               System.debug('listSobjectOfOneType.size='+listSobjectOfOneType.size());
               System.debug('listSobjectOfOneType='+listSobjectOfOneType);  
               safeListForChunking.addAll((List<sObject>)listSobjectOfOneType);
        }
        System.debug('safeListForChunking.size()='+safeListForChunking.size());
        System.debug('safeListForChunking='+safeListForChunking);
        safeListForChunking.sort();
        insertInBatch(safeListForChunking,200);
        safeListForChunking.clear();
        numberOfListsToBeCreated--;
       }
  }
   static void insertInBatch(List<sObject> batchList,Integer totallimit){
        if(batchList.size()>0){
          Integer start=0;
          Integer endlist = totallimit-1;
          System.debug('size='+batchList.size());
          List<Sobject> safeListForChunking = new List<Sobject>();
         
          for(start=0;start<endlist && start<batchList.size();start++){
           //   safeListForChunking.add();
              System.debug('sizeof='+batchList.size());
              System.debug('='+ start);
              
              if(batchList.get(start)!=null){
                 System.debug('batchList.get(start)'+batchList.get(start));
                 safeListForChunking.add(batchList.get(start)); 
              }
             
          }
          
           Integer count=0;
           for(start=0;start<endlist && start<safeListForChunking.size();start++){
           System.debug('remove='+batchList.remove(count));
             
          }
          
          insert safeListForChunking;
          safeListForChunking.clear();
          insertInBatch(batchList,totallimit);
      }
   }
  
  
    
}