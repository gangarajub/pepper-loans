@isTest private class pepCreateFriendsAccount_Batch_Tracker {
    
   @isTest static void pepCreateFriendsAccount_BatchTest(){
       
       // Account acc = pepCommonTrackerController.createAccount();
       
        UserRole portalRole1;
        user objuser;
        Contact objCon;
        Account objAccount;
   
        Loan__loan_Account__c objLoanAccount;
       Test.startTest(); 
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
       Test.StopTest(); 
        User usr = new User();
     /*   
        system.runas(usr1)     
        {
                  
           objAccount=pepCommonTrackerController.createAccount1();
           
           loan__Bank_Account__c objBankAccount = pepCommonTrackerController.createLoanBankAccount(objAccount.id);
                 
           objLoanAccount = pepCommonTrackerController.createLoanAccount1();                  
          
           objAccount.Loan_Account_Id__c=objLoanAccount.id;
           update objAccount;
                                  
           Contact con= pepCommonTrackerController.createContact1();
           con.Is_Referred_Friend__c =True;
           con.Referred_By_Code__c='testCode';
           update con;
       
           objuser = pepCommonTrackerController.createUser1();
        } */
         
         system.runas(usr1)     
        {  
 
        Portal_OwnerId__c portalId = new Portal_OwnerId__c();

        portalId  = pepCommonTrackerController.createPortalOwnerID(usr1);
         objAccount=pepCommonTrackerController.createAccount1();
         Contact con= pepCommonTrackerController.createContact1();
           con.Is_Referred_Friend__c =True;
           con.Referred_By_Code__c='testCode';
           update con;
        
        
       

       
        
        //String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new pepCreateFriendsAccount_Batch());  
        pepCreateFriendsAccount_Batch uca = new pepCreateFriendsAccount_Batch ();
        Id batchId = Database.executeBatch(uca);
        

        }
       
    }

}