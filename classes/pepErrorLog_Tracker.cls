@isTest(SeeAllData=False) private class pepErrorLog_Tracker{
    
   @isTest static void pepErrorLogTest(){
          
          List<pepErrorLog.Error> lstErrors = new List<pepErrorLog.Error>();
          DmlException actualException;
          Exception ex =actualException; 
        //  ex.setMessage('test');
          pepErrorLog.Error wrpError = new pepErrorLog.Error('Account',ex);
          pepErrorLog.Error wrpError1 = new pepErrorLog.Error();
          wrpError.object_Name = 'Account';
          wrpError.objException = ex;
          lstErrors.add(wrpError);
          pepErrorLog.LogErrors(lstErrors);
   }
}