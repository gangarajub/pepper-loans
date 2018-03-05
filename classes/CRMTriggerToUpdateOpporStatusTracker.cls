@IsTest(SeeAllData=False) Private class CRMTriggerToUpdateOpporStatusTracker{


    @isTest static void CRMTriggerToUpdateOpporStatusTest(){
    
    
        Account acc = new Account(Name='test');
        insert acc;
        
        opportunity opp = new Opportunity(Name='opp',CloseDate=System.Today()+2,Accountid=acc.id,StageName='Open');
        insert opp;
        task tsk = new task(Subject = 'Send Formal Approved Email' , Status = 'Open' , whatid = opp.id);
        insert tsk;
        
        EmailMessage emess = New EmailMessage(FromAddress ='dsacks@control4.com.dev', ToAddress= 'testingit@gmail.com', Subject ='Loan Particulars',
                                              TextBody = 'this his the message of the email', RelatedToID=opp.id);
        Insert emess;
        
        EmailMessage emess1 = New EmailMessage(FromAddress ='dsacks@control4.com.dev', ToAddress= 'testingit@gmail.com', Subject ='Conditional Approval',
                                              TextBody = 'this his the message of the email', RelatedToID=opp.id);
        Insert emess1;
        
        EmailMessage emess3 = New EmailMessage(FromAddress ='dsacks@control4.com.dev', ToAddress= 'testingit@gmail.com', Subject ='Final Approval',
                                              TextBody = 'this his the message of the email', RelatedToID=opp.id);
        Insert emess3;
    
    }


}