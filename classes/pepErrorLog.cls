public without sharing class pepErrorLog {
 public static void LogErrors(Error[] Errors)
     {
      List<Error_Log__c> lstErrors = new List<Error_Log__c>();

       for(Error objError: Errors)
          {
            Error_Log__c objLog = new Error_Log__c();
            objLog.Object_Name__c=objError.object_Name;
           
            if(objError.objException!=null)
            {
                objLog.Error_Message__c=objError.objException.getMessage(); objLog.Error_Stacktrace__c=objError.objException.getStackTraceString();
                objLog.Type__c=objError.objException.getTypeName(); objLog.Line__c=objError.objException.getLineNumber();
            }
            
            lstErrors.add(objLog);
          }
        
         if(lstErrors!=null && lstErrors.size()>0)
         {
            insert lstErrors;
         }
       } 
  public class Error
    {
        public String object_Name;
        public Exception objException;
        public Error(){}
        public Error(String object_Name,Exception objException)
        {
        this.object_Name=object_Name;
        this.objException=objException;
        }
        
    }       
}