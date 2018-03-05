@isTest(SeeAllData=False)

private class pepIterable_Tracker 
{
    
    @isTest static void pepIterableTest0() {
    
       test.StartTest();
        pepCommonTrackerController obj =new pepCommonTrackerController();
       
        List<WrpTransactionHistory> lstAccWr = new List<WrpTransactionHistory>();
        WrpTransactionHistory wrapTransaction = new WrpTransactionHistory('str','str2','str3','str4','str5','str1','str6');     
        lstAccWr.add(wrapTransaction);
        
        WrpTransactionHistory wrapTransaction1 = new WrpTransactionHistory('str','str2','str3','str4','str5','str1','str6');     
        lstAccWr.add(wrapTransaction1);
        
        pepIterable objClass = new pepIterable(lstAccWr);
        objClass.InnerList = lstAccWr;
        objClass.setPageNumber = 2;
        objClass.setPageSize = 1;
        objClass.hasNext();
        objClass.hasPrevious();
        objClass.goToPage(2);
        objClass.next();
        objClass.previous();
       test.stopTest();
    }
    
    @isTest static void PepDocumentInboxPaginationTest1() {
    
       test.StartTest();
        pepCommonTrackerController obj1 =new pepCommonTrackerController();
       
        List<WrpTransactionHistory> lstAccWr1 = new List<WrpTransactionHistory>();
        WrpTransactionHistory wrapTransaction2 = new WrpTransactionHistory('str','str2','str3','str4','str5','str1','str6');     
        lstAccWr1.add(wrapTransaction2);
       
        pepIterable objClass1 = new pepIterable(lstAccWr1);
        objClass1.InnerList = lstAccWr1;
        objClass1.setPageNumber = 2;
        objClass1.setPageSize = 5;
        objClass1.hasNext();
        objClass1.next();
       test.stopTest();
    }
}