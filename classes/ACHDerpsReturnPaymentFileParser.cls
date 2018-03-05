global class ACHDerpsReturnPaymentFileParser extends loan.ACHReturnPaymentProcessor{

     public List<loan.ACHReturn> achReturns = new List<loan.ACHReturn>();
     global override List<loan.ACHReturn> parseFile(String fileContent,String objectType){
         List<String> bodyLines = String.valueOf(fileContent).split('\n');
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
                 
                 if(line.startsWith('2')){
                 String txnName = '';
                 String returnCode = '';
                  
                 if(line.subString(62,65).equals('LPT')){ 
                    
                     txnName = line.subString(62,75); 
                     system.debug(LoggingLevel.ERROR, 'TXN:' + txnName);
                     
                     returnCode = line.subString(17,18); 
                     System.debug('returncode'+returnCode);
                     
                     lptNames.put(txnName,returnCode);
                     
                     
                 }
                 
                 }
                   
             }  
        
         List<SObject> payments =new List<Sobject>();
         System.debug('lptNames.keySet()'+lptNames.keySet());
         payments.addAll((List<SObject>)[select id,Name from loan__Loan_Payment_Transaction__c where Name in:lptNames.keySet()]);
         
         System.debug('payments'+payments);
         for(SObject obj:payments){
            loan.ACHReturn achRet = new loan.ACHReturn();
            achRet.payment = obj;
            
            if(obj instanceof loan__Loan_Payment_Transaction__c){
                achRet.returnCode = lptNames.get(String.valueOf(obj.get('Name')));
            }
            
            
            achReturns.add(achRet);
         }
         System.debug('achReturns'+achReturns);
         return achReturns;
     }
}