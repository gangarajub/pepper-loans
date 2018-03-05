public class ACHDerpsReturnDisbursalFileParser{

    public List<Disbursal_Exception__c> parseReturnFile(String fileContent){
       
         List<String> bodyLines = String.valueOf(fileContent).split('\r\n');
         system.debug('fileContent:'+ fileContent);
         system.debug('bodyLines:'+bodyLines);
        
         Map<String,String> objectNamingMap = new Map<String,String>();
         List<Disbursal_Exception__c> disbExp = new List<Disbursal_Exception__c>();
         Map<String,String> iftNames = new Map<String,String>();
         Map<String,String> lptNames = new Map<String,String>();
         String StatusIndicator = '';
         system.debug(bodyLines[0]);
             Boolean returnFile  = false;
             for(String line:bodyLines){
                 line = line.trim();
                 if(line.startsWith('0')){
                     StatusIndicator = line.subString(121,122); 
                     if(StatusIndicator.equalsignorecase('R')){
                          
                         returnFile = true;
                     }
                 }
                 
                 if(line.startsWith('2')&& returnFile){
                 String txnName = '';
                 
                 
                 txnName = line.subString(63,80); 
                 system.debug(LoggingLevel.ERROR, 'TXN:' + txnName);
                 Disbursal_Exception__c excp = new Disbursal_Exception__c();
                 excp.reference__C = txnName;
                 disbExp.add(excp); 
                 }
                  
             }  
    return disbExp;    
    }
}