global class ACHDeedsReturnPaymentFileParser extends loan.ACHReturnPaymentProcessor{

     public List<loan.ACHReturn> achReturns = new List<loan.ACHReturn>();
     global override List<loan.ACHReturn> parseFile(String fileContent,String objectType){
         List<String> bodyLines = String.valueOf(fileContent).split('\r\n');
         system.debug('fileContent:'+ fileContent);
         system.debug('bodyLines:'+bodyLines);
         achReturns.clear();
         Map<String,String> objectNamingMap = new Map<String,String>();
         objectNamingMap.put('IFT','loan__Investor_Fund_Transaction__c');
         objectNamingMap.put('LPT','loan__Loan_Payment_Transaction__c');
         Map<String,String> iftNames = new Map<String,String>();
         Map<String,String> lptNames = new Map<String,String>();
         system.debug(bodyLines[0]);
             String StatusIndicator = '';
             for(String line:bodyLines){
                 line = line.trim();
                 Boolean returnFile  = false;
                 
                 if(line.startsWith('1') ){
                 String txnName = '';
                 
                 StatusIndicator = line.subString(120,121); 
                 
                 if(line.subString(62,65).equals('LPT')){ 
                    
                     txnName = line.subString(62,75); 
                     system.debug(LoggingLevel.ERROR, 'TXN:' + txnName);
                     
                      
                     if(StatusIndicator.equalsignorecase('R')){
                         System.debug('StatusIndicator '+StatusIndicator );
                         lptNames.put(txnName,StatusIndicator);
                         
                     }
                 
                 }
                 
                 }
                   
             }  
        
         
         System.debug('lptNames.keySet()'+lptNames.keySet());
         List<loan__Loan_Payment_Transaction__c> payments = [select id,Name from loan__Loan_Payment_Transaction__c where Name in:lptNames.keySet()];
         if(payments.size()>0){
            
         
             System.debug('payments'+payments);
             for(loan__Loan_Payment_Transaction__c obj:payments){
                loan.ACHReturn achRet = new loan.ACHReturn();
                achRet.payment = obj;
                
                
                achRet.returnCode = lptNames.get(String.valueOf(obj.get('Name')));
                
                
                
                achReturns.add(achRet);
             }
             System.debug('achReturns'+achReturns);
         }
         
         return achReturns;
     }
}