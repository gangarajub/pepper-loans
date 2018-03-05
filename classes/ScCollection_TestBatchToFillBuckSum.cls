@isTest(SeeAllData = False) Public Class ScCollection_TestBatchToFillBuckSum{


    @istest static void test0(){
    
         collect__Source_System__c objSource  = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
         
         ScCollection_Bucket_Configuration__c  cs = ScCollection_CommonTrackerClass.createTestBucketConfig();
         
         
         List<ScCollection_Contract_Summary__c> lstToInsertConSumm = new List<ScCollection_Contract_Summary__c>();
         List<ScCollection_Bucket_Summary__c > lstBukSumm= new List<ScCollection_Bucket_Summary__c >();
         
         ScCollection_Funders_Target__c objFundTransfer = new ScCollection_Funders_Target__c();
         objFundTransfer.ScCollection_Source_System__c=objSource.id;
         objFundTransfer.ScCollection_Bank_Name__c = 'Hdfc';
         objFundTransfer.ScCollection_Target__c = 20;
         insert objFundTransfer;
         
         //Contract summary Yesterday--------------------------------------------------------------------
         
         ScCollection_Contract_Summary__c objConSummary = new ScCollection_Contract_Summary__c();
         objConSummary.ScCollection_Source_System__c = objSource.Id;
         objConSummary.ScCollection_Funders_Target__c = objFundTransfer.Id;
         objConSummary.ScCollection_Day__c = 'YESTERDAY';
         lstToInsertConSumm.add(objConSummary);
         
         //Contract summary MONTHEND--------------------------------------------------------------------
         ScCollection_Contract_Summary__c objConSummary1 = new ScCollection_Contract_Summary__c();
         objConSummary1.ScCollection_Source_System__c = objSource.Id;
         objConSummary1.ScCollection_Funders_Target__c = objFundTransfer.Id;
         objConSummary1.ScCollection_Day__c = 'MONTHEND';
         lstToInsertConSumm.add(objConSummary1);
         
         insert lstToInsertConSumm;
         
         ScCollection_Bucket_Summary__c objBuckSumm = new ScCollection_Bucket_Summary__c();
         objBuckSumm.ScCollection_Contract_Summary__c= objConSummary.Id ;
         objBuckSumm.ScCollection_BucketName__c = 0;
         lstBukSumm.add(objBuckSumm);
         
         ScCollection_Bucket_Summary__c objBuckSumm1 = new ScCollection_Bucket_Summary__c();
         objBuckSumm1.ScCollection_Contract_Summary__c= objConSummary1.Id ;
         objBuckSumm1.ScCollection_BucketName__c = 0;
         lstBukSumm.add(objBuckSumm1);
         
         
         
         insert lstBukSumm;
         
         ScCollection_Contract_Summary__c objConSummary2 = new ScCollection_Contract_Summary__c();
         objConSummary2.ScCollection_Source_System__c = objSource.Id;
         objConSummary2.ScCollection_Funders_Target__c = objFundTransfer.Id;
         objConSummary2.ScCollection_Day__c = 'TODAY';
         objConSummary2.ScColllection_YesterdayContractSummary__c  = objConSummary.Id;
         objConSummary2.ScCollection_MonthEndContract_Summary__c = objConSummary1.Id;
         
         insert objConSummary2;
         
         ScCollection_Bucket_Summary__c objBuckSumm2 = new ScCollection_Bucket_Summary__c();
         objBuckSumm2.ScCollection_Contract_Summary__c = objConSummary2.Id ;
         objBuckSumm2.ScCollection_BucketName__c = 0;
         objBuckSumm2.ScCollection_Yesterday_Bucket_Summary__c = objBuckSumm.id;
         objBuckSumm2.ScCollection_Month_s_End_Bucket_Summary__c = objBuckSumm1.id;
         
         insert objBuckSumm2;
         
         collect__Loan_Account__c objLoanAcc = ScCollection_CommonTrackerClass.createTestContract(objSource.id);
         objLoanAcc.ScCollection_Mortgage_Funding__c ='Hdfc';
         objLoanAcc.ScCollection_Current_Principal__c = 1;
         objLoanAcc.ScCollection_Bucket__c =0;
         update objLoanAcc;
         
         ScCollection_BatchToFillBucketSummary o = new ScCollection_BatchToFillBucketSummary ();
         database.ExecuteBatch(o);
         
         ScCollection_ScheduleBucketSummary objSch = new ScCollection_ScheduleBucketSummary();
         objSch.Execute(null);
         
         
         
         
    
    }
    @isTest static void test1(){
        
        collect__Source_System__c objSource  = ScCollection_CommonTrackerClass.createTestSourceSystem('CL Loan');
        ScCollection_Bucket_Configuration__c  cs = ScCollection_CommonTrackerClass.createTestBucketConfig();
         
         
        List<ScCollection_Contract_Summary__c> lstToInsertConSumm = new List<ScCollection_Contract_Summary__c>();
        List<ScCollection_Bucket_Summary__c > lstBukSumm= new List<ScCollection_Bucket_Summary__c >();
         
        ScCollection_Funders_Target__c objFundTransfer = new ScCollection_Funders_Target__c();
        objFundTransfer.ScCollection_Source_System__c=objSource.id;
        objFundTransfer.ScCollection_Bank_Name__c = 'Hdfc';
        objFundTransfer.ScCollection_Target__c = 20;
        insert objFundTransfer;
         
        //Contract summary Yesterday--------------------------------------------------------------------
         
        ScCollection_Contract_Summary__c objConSummary = new ScCollection_Contract_Summary__c();
        objConSummary.ScCollection_Source_System__c = objSource.Id;
        objConSummary.ScCollection_Funders_Target__c = objFundTransfer.Id;
        objConSummary.ScCollection_Day__c = 'YESTERDAY';
        lstToInsertConSumm.add(objConSummary);
         
        //Contract summary MONTHEND--------------------------------------------------------------------
        ScCollection_Contract_Summary__c objConSummary1 = new ScCollection_Contract_Summary__c();
        objConSummary1.ScCollection_Source_System__c = objSource.Id;
        objConSummary1.ScCollection_Funders_Target__c = objFundTransfer.Id;
        objConSummary1.ScCollection_Day__c = 'MONTHEND';
        lstToInsertConSumm.add(objConSummary1);
         
        insert lstToInsertConSumm;
         
        ScCollection_Bucket_Summary__c objBuckSumm = new ScCollection_Bucket_Summary__c();
        objBuckSumm.ScCollection_Contract_Summary__c= objConSummary.Id ;
        objBuckSumm.ScCollection_BucketName__c = 0;
        lstBukSumm.add(objBuckSumm);
         
        ScCollection_Bucket_Summary__c objBuckSumm1 = new ScCollection_Bucket_Summary__c();
        objBuckSumm1.ScCollection_Contract_Summary__c= objConSummary1.Id ;
        objBuckSumm1.ScCollection_BucketName__c = 0;
        lstBukSumm.add(objBuckSumm1);
         
         
         
        insert lstBukSumm;
         
        ScCollection_Contract_Summary__c objConSummary2 = new ScCollection_Contract_Summary__c();
        objConSummary2.ScCollection_Source_System__c = objSource.Id;
        objConSummary2.ScCollection_Funders_Target__c = objFundTransfer.Id;
        objConSummary2.ScCollection_Day__c = 'TODAY';
        objConSummary2.ScColllection_YesterdayContractSummary__c  = objConSummary.Id;
        objConSummary2.ScCollection_MonthEndContract_Summary__c = objConSummary1.Id;
         
        insert objConSummary2;
         
        ScCollection_Bucket_Summary__c objBuckSumm2 = new ScCollection_Bucket_Summary__c();
        objBuckSumm2.ScCollection_Contract_Summary__c = objConSummary2.Id ;
        objBuckSumm2.ScCollection_BucketName__c = 0;
        objBuckSumm2.ScCollection_Yesterday_Bucket_Summary__c = objBuckSumm.id;
        objBuckSumm2.ScCollection_Month_s_End_Bucket_Summary__c = objBuckSumm1.id;
         
        insert objBuckSumm2;
        
        loan__Loan_Account__c objLoan = pepCommonTrackerController.createLoanAccount();
        objLoan.SPV__c  = 'Hdfc';
        objLoan.loan__Number_of_Days_Overdue__c = 1;
        update objLoan;
        
        loan__Loan_Account__c objLoan1 = objLoan;
        
        objLoan1.id = null;
        insert objLoan1;
        
        ScCollection_BatchToFillBucketSummary o = new ScCollection_BatchToFillBucketSummary ();
        database.ExecuteBatch(o);
    }
}