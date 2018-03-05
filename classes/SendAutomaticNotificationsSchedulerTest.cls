@isTest(SeeAllData=False)
/*This test Class covers the whole COC Testing
Author:Varun Arora
Last Modified Date:October 9,2017.

*/
Private class SendAutomaticNotificationsSchedulerTest{
    Private Static User us;
    Private static Property_insurance__c propertyInsurance;
    Private static Account Accnt;
    Private static Diary_Notes__c diaryNote;
    Private static Property_Insurance__c propertyInsurance14Day;
    Private static Property_Insurance__c propertyInsurance1Day;
    Private static Property_Insurance__c propertyInsurance7Day;
    //This test method is used to test the letterinvocation Api. 
    Private testmethod static void testmethod1(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 1); 
        String ss = String.valueOf(Datetime.now().second());
        String year=String.valueof(System.today().year());
        string day=string.valueof(System.today().day());
        string month=String.valueof(System.Today().month());
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+day+' '+month+' '+'?'+' '+year;
        
        sendAutomaticNotificationsScheduler  s = new sendAutomaticNotificationsScheduler(); 
        String jobId=System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);
        Test.stopTest();
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,

         NextFireTime

         FROM CronTrigger WHERE id = :jobId];

 

      // Verify the expressions are the same

      System.assertEquals(nextFireTime,

         ct.CronExpression);
     System.assertequals(0,ct.TimesTriggered);
    }
    //This test method is used to test the SMS Apis. 
    Private testmethod static void testmethod2(){
        
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        
        Test.StartTest();
        set<Id> fourteendaysms= new set<Id>();
        set<Id> onedayPostExpirysms = new set<Id>();
        Diary_Notes__c drn = new Diary_Notes__c(comment__c='Test',Property_insurance__c=PropertyInsurance.id,invoked_from_Batch__c=True);
        insert drn;
        fourteendaysms.add(PropertyInsurance.id);
        Diary_Notes__c drn1 = new Diary_Notes__c(comment__c='Test',Property_insurance__c=PropertyInsurance.id,invoked_from_Batch__c=True);
        insert drn1;
        onedayPostExpirysms.add(PropertyInsurance.id);
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        sendAutomaticNotifications sAutomaticNotifications = new sendAutomaticNotifications('Letter',fourteendaysms,onedaypostexpirysms,null,null);
        DataBase.executeBatch(sAutomaticNotifications,50);
        Test.stopTest();
        Property_Insurance__c prp=[Select id,Letter_Generation_Success_Error_Message__c from Property_Insurance__c where DWH_Propert_Ins_Exp_Date__c=:System.Today()+7];
        
        system.assert(prp != null ,'Assertion');
    }
    //This test method is used to test the letterinvocation Api. 
    Private testmethod static void testmethod3(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        set<Id> diaryNotesId = new set<Id>();
        Diary_Notes__c drn = new Diary_Notes__c(comment__c='Test',Property_insurance__c=PropertyInsurance.id,invoked_from_Batch__c=True);
        insert drn;
        diaryNotesId.add(drn.id);
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        sendAutomaticNotifications sAutomaticNotifications = new sendAutomaticNotifications('DiaryNote',null,null,null,diaryNotesId);
        DataBase.executeBatch(sAutomaticNotifications,50);
        Test.stopTest();
        Diary_Notes__c drn1 =[Select id from Diary_Notes__c where id=:drn.id and (Submitted_to_ESB__c!=null)];
        system.Assert(drn1!=null,'Assertion');
    }
    //This test method is used to test the Diary Note Api.
   Private testmethod static void testmethod4(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        User usr =[Select id from User where isActive=True and id=:Userinfo.getuserid()];
        System.runas(usr){
        
        
        Groupmember member = new Groupmember(GroupId=[Select id from Group where developername='COC_Team'].Id,UserorGroupId=Userinfo.getuserid());
        insert member;
        }
        
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(500,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
         Diary_notes__c gy = new Diary_notes__c(comment__c='Test',Property_Insurance__c=propertyInsurance.id,Invoked_from_batch__c=true);
         insert gy;
       
        Test.stopTest();
        system.assert(gy.Id != null,'Assert');
    }
    //This test method is used to test the LetterInvocation APi response.
    Private testmethod static void testmethod5(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        JacksonApicalling.submitletterinvocation(propertyInsurance.id);
        JacksonApicalling.submitdiarynote(diaryNote.id);
        
        Test.stopTest();
         Diary_Notes__c drn1 =[Select id from Diary_Notes__c where id=:diaryNote.id ];
        system.Assert(drn1!=null,'Assertion');
    }
    //This test method is used to test the SMS Apis
    Private testmethod static void testmethod6(){
    us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
    loadcustomsetting();
    System.runas(us){
    loaddata();
    }
    Test.StartTest();
    SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
    endpointTocallout.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts);
    JacksonApicalling.updateerror('99','Letter',propertyinsurance.id);
    Test.stopTest();
    Property_Insurance__c propIns=[Select id from Property_Insurance__c where id=:propertyinsurance.Id];
    system.assert(propIns!=null,'Assertion');
    }
    Private testmethod static void testmethod7(){
    us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
    loadcustomsetting();
    System.runas(us){
    loaddata();
    }
    Test.StartTest();
    SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
    endpointTocallout.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts);
    JacksonApicalling.updateerror('99','Diarynote',diaryNote.id);
    Test.stopTest();
       Diary_Notes__c drn1 =[Select id from Diary_Notes__c where id=:diaryNote.id ];
        system.Assert(drn1!=null,'Assertion');
    }
    //This test method is used to test the APi of getting back the error form Jackson in case of Insurance Updation failure.
    Private testmethod static void testmethod8(){
    us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
    loadcustomsetting();
    System.runas(us){
    loaddata();
    }
    Test.StartTest();
    SingleRequestMock letterinvocationRequest = new SingleRequestMock(400,'complete','{"APIStatus": {"APICode": "202","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
    endpointTocallout.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts);
    JacksonApicalling.updateerror('9','Insurance',propertyinsurance.id);
    
    Test.stopTest();
      Property_Insurance__c propIns=[Select id from Property_Insurance__c where id=:propertyInsurance.Id];
    system.assert(propIns!=null,'Assertion');
    }
     //This test method is used to test the APi of getting back the error form Jackson in case of Letter Invocation failure.
    Private testmethod static void testmethod9(){
    us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
    loadcustomsetting();
    System.runas(us){
    loaddata();
    }
    Test.StartTest();
    SingleRequestMock letterinvocationRequest = new SingleRequestMock(400,'complete','{"APIStatus": {"APICode": "202","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
    endpointTocallout.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts);
    JacksonApicalling.updateerror('9','Letter',propertyinsurance.id);
    Test.stopTest();
    Property_Insurance__c propIns=[Select id from Property_Insurance__c where id=:propertyInsurance.id];
    system.assert(propIns!=null,'Assertion');
    }
    Private testmethod static void testmethod10(){
    us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
    loadcustomsetting();
    System.runas(us){
    loaddata();
    }
    Test.StartTest();
    SingleRequestMock letterinvocationRequest = new SingleRequestMock(400,'complete','{"APIStatus": {"APICode": "202","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
    endpointTocallout.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts);
    JacksonApicalling.updateerror('9','Diarynote',diaryNote.id);
    Test.stopTest();
    Diary_Notes__c drn1 =[Select id from Diary_Notes__c where id=:diaryNote.id];
        system.Assert(drn1!=null,'Assertion');
    }
     //This test method is used to test the APi of getting back the error form Jackson in case of Insurance Updation failure.
    Private testmethod static void testmethod11(){
    us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
    loadcustomsetting();
    System.runas(us){
    loaddata();
    }
    Test.StartTest();
    SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "202","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
    endpointTocallout.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts);
    JacksonApicalling.updateerror('99','Insurance',propertyInsurance.id);
    Test.stopTest();
    Property_Insurance__c propIns=[Select id from Property_Insurance__c where id=:PropertyInsurance.id];
    system.assert(propIns!=null,'Assertion');
    }
     //This test method is used to test the Case Escalation Scenarios in case of COC Process.
    Private testmethod static void testmethod12(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        
        loadcustomsetting();
        System.runas(us){
            loaddata();
        }
       
            Test.StartTest();
              
            RecordType rt =[Select id from RecordType where Developername='Building_Insurance_Expiry' and sobjecttype='Case'];
            Case cs = new Case(RecordTypeId=rt.id,subject='Test case',Description='Hi Creating test case',Status='New',suppliedemail='test@abc.org');
            insert cs;
            EmailMessage[] newEmail = new EmailMessage[0];
     
            newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId =cs.id,Fromname='Test')); 
     
            insert newEmail;
            User usd=[Select id from User where id=:userinfo.getuserid()];
            system.runas(usd){
            SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
            Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
            endpointTocallout.put('httpresponse',letterinvocationRequest);
            HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
            Test.setMock(HttpcalloutMock.class,multiplecallouts);
            Case cs1 = new Case(id=cs.id,Property_Insurance__c=propertyInsurance.id);
            update cs1;
            
            Case cs2 = new Case(id=cs.id,EscalatedLevel1__c=True);
            update cs2;
            Case cs3 = new Case(id=cs.id,EscalatedLevel2__c=True);
            update cs3;
            }
            
            Test.stopTest();
            system.assert([Select id from case where Property_Insurance__c != null]!=null,'Assertion');
        
    }
     //This test method is used to check the Diary Notes Api.
    Private testmethod static void testmethod13(){
    us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
    loadcustomsetting();
    System.runas(us){
    loaddata();
    }
    Test.StartTest();
    SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
    endpointTocallout.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts);
    set<Id> propertyInsurances = new set<Id>();
    propertyInsurances.add(propertyInsurance.Id);
    user usd =[Select id from User where id=:Userinfo.getuserid()];
    system.runas(usd){
     Groupmember grpMember = new Groupmember(userorGroupid=usd.id,GroupId=[Select id from Group where developername='COC_Team'].id);
    insert grpMember;
    Property_Insurance__c propInsurance =[Select id from Property_Insurance__c where id=:propertyinsurance.id];
    propInsurance.ownerid=usd.id;
    update propInsurance;
    InsuranceEmailToCaseManagement.createDiaryNotes(propertyInsurances,'comment');
    
    }
    SingleRequestMock letterinvocationRequest1 = new SingleRequestMock(400,'complete','{"APIStatus": {"APICode": "202","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
    Map<string,httpcalloutmock> endpointTocallout1 = new map<string,Httpcalloutmock>();
    endpointTocallout1.put('httpresponse',letterinvocationRequest);
    HttpcalloutMock multiplecallouts1 = new MultirequestMock(endpointTocallout);
    Test.setMock(HttpcalloutMock.class,multiplecallouts1);
    set<Id> propertyInsurances1 = new set<Id>();
    propertyInsurances1.add(propertyInsurance.Id);
    user usd1 =[Select id from User where id=:Userinfo.getuserid()];
    system.runas(usd1){
    Groupmember grpMember = new Groupmember(userorGroupid=usd1.id,GroupId=[Select id from Group where developername='COC_Team'].id);
    insert grpMember;
    Property_Insurance__c propInsurance =[Select id from Property_Insurance__c where id=:propertyinsurance.id];
    propInsurance.ownerid=usd1.id;
    update propInsurance;
    InsuranceEmailToCaseManagement.createDiaryNotes(propertyInsurances1,'comment');
    }
    //
    Test.stopTest();
     Diary_Notes__c drn=[Select id from Diary_Notes__c where Property_Insurance__c=:propertyInsurance.id limit 1];
    system.assert(drn!=null,'Assertion');
    }
     //This test method is used to test the APi of getting back the error form Jackson in case of Insurance Updation failure.
    Public testmethod static void testmethod14() {
         us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.startTest();
       SingleRequestMock letterinvocationRequesttemp = new SingleRequestMock(500,'complete','{"APIStatus": {"APICode": "500","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallouttemp = new map<string,Httpcalloutmock>();
        endpointTocallouttemp.put('httpresponse',letterinvocationRequesttemp);
        HttpcalloutMock multiplecalloutstemp = new MultirequestMock(endpointTocallouttemp);
        Test.setMock(HttpcalloutMock.class,multiplecalloutstemp);
        JacksonApicalling.submitletterinvocation(propertyInsurance.id);
        JacksonApicalling.submitdiarynote(diaryNote.id);
        Test.stopTest();
        Diary_Notes__c drn1 =[Select id from Diary_Notes__c where Property_Insurance__c=:propertyInsurance.id];
        system.Assert(drn1!=null,'Assertion');
    }
     //This test method is used to test the APi invocations in case of Pending notifications if Batch job SendPendingNotifications runs on a public Holiday.
     Private testmethod static void testmethod15(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 1); 
        String ss = String.valueOf(Datetime.now().second());
        String year=String.valueof(System.today().year());
        string day=string.valueof(System.today().day());
        string month=String.valueof(System.Today().month());
        User usr=[Select id from User where id=:Userinfo.getuserid()];
        System.runas(usr){
        Holiday hol = new Holiday();
        hol.Name='Test holiday';
        hol.activitydate = System.Today();
        insert hol;
        }
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+day+' '+month+' '+'?'+' '+year;
        
        SendPendingNotificationsScheduler s = new SendPendingNotificationsScheduler(); 
        String jobId=System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s);
        Test.stopTest();
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,

         NextFireTime

         FROM CronTrigger WHERE id = :jobId];

 

      // Verify the expressions are the same

      System.assertEquals(nextFireTime,

         ct.CronExpression);
     System.assertequals(0,ct.TimesTriggered);
    }
    //This test method is used to test the SMS APi invocations in case of Pending notifications if Batch job SendPendingNotifications runs on a non-public Holiday.
    
     Private testmethod static void testmethod16(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 1); 
        String ss = String.valueOf(Datetime.now().second());
        String year=String.valueof(System.today().year());
        string day=string.valueof(System.today().day());
        string month=String.valueof(System.Today().month());
        List<Property_Insurance__c> propertyInsurancesToUpdate = new List<Property_Insurance__c>();
        Property_insurance__c prIns = new Property_insurance__c(Id=propertyInsurance14Day.id,Is_SMS_Send_Pending_Holiday_14_days__c=True);
        propertyInsurancesToUpdate.add(prIns);
        Property_insurance__c prIns1 = new Property_insurance__c(Id=propertyInsurance1Day.id,Is_SMS_Send_Pending_Holiday_1_day_exp__c=True);
        propertyInsurancesToUpdate.add(prIns1);
        Property_insurance__c prIns2 = new Property_insurance__c(Id=propertyInsurance7Day.id,Is_Letter_Send_Pending_Holiday_7_days__c=True);
        propertyInsurancesToUpdate.add(prIns2);
        update propertyInsurancesToUpdate;
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+day+' '+month+' '+'?'+' '+year;
        
        sendPendingNotifications sendPendingNotifications = new sendPendingNotifications('SMS',null,null,null,null); 
         DataBase.executeBatch(sendPendingNotifications,50);
        Test.stopTest();
        

    
    }
    //This test method is used to test the Letter APi invocations in case of Pending notifications if Batch job SendPendingNotifications runs on a public Holiday.
    
    Private testmethod static void testmethod17(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 1); 
        String ss = String.valueOf(Datetime.now().second());
        String year=String.valueof(System.today().year());
        string day=string.valueof(System.today().day());
        string month=String.valueof(System.Today().month());
        List<Property_Insurance__c> propertyInsurancesToUpdate = new List<Property_Insurance__c>();
        Property_insurance__c prIns = new Property_insurance__c(Id=propertyInsurance14Day.id,Is_SMS_Send_Pending_Holiday_14_days__c=True);
        propertyInsurancesToUpdate.add(prIns);
        Property_insurance__c prIns1 = new Property_insurance__c(Id=propertyInsurance1Day.id,Is_SMS_Send_Pending_Holiday_1_day_exp__c=True);
        propertyInsurancesToUpdate.add(prIns1);
        Property_insurance__c prIns2 = new Property_insurance__c(Id=propertyInsurance7Day.id,Is_Letter_Send_Pending_Holiday_7_days__c=True);
        propertyInsurancesToUpdate.add(prIns2);
        update propertyInsurancesToUpdate;
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+day+' '+month+' '+'?'+' '+year;
        
        sendPendingNotifications sendPendingNotifications = new sendPendingNotifications('Letter',null,null,null,null); 
         DataBase.executeBatch(sendPendingNotifications,50);
        Test.stopTest();
        
}
//This test method is used to test the Diary Note APi invocations in case of Pending notifications if Batch job SendPendingNotifications runs on a non-public Holiday.
    
Private testmethod static void testmethod19(){
        us =[Select id from User where Profile.name='System Admin Integration' and isactive=True Limit 1];
        loadcustomsetting();
        System.runas(us){
        loaddata();
        }
        Test.StartTest();
        SingleRequestMock letterinvocationRequest = new SingleRequestMock(200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "200","MessageDescription": "Request received successfully."}}]}}',null);
        Map<string,httpcalloutmock> endpointTocallout = new map<string,Httpcalloutmock>();
        endpointTocallout.put('httpresponse',letterinvocationRequest);
        HttpcalloutMock multiplecallouts = new MultirequestMock(endpointTocallout);
        Test.setMock(HttpcalloutMock.class,multiplecallouts);
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute() + 1); 
        String ss = String.valueOf(Datetime.now().second());
        String year=String.valueof(System.today().year());
        string day=string.valueof(System.today().day());
        string month=String.valueof(System.Today().month());
        List<Property_Insurance__c> propertyInsurancesToUpdate = new List<Property_Insurance__c>();
        Property_insurance__c prIns = new Property_insurance__c(Id=propertyInsurance14Day.id,Is_SMS_Send_Pending_Holiday_14_days__c=True);
        propertyInsurancesToUpdate.add(prIns);
        Property_insurance__c prIns1 = new Property_insurance__c(Id=propertyInsurance1Day.id,Is_SMS_Send_Pending_Holiday_1_day_exp__c=True);
        propertyInsurancesToUpdate.add(prIns1);
        Property_insurance__c prIns2 = new Property_insurance__c(Id=propertyInsurance7Day.id,Is_Letter_Send_Pending_Holiday_7_days__c=True);
        propertyInsurancesToUpdate.add(prIns2);
        update propertyInsurancesToUpdate;
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' '+day+' '+month+' '+'?'+' '+year;
         set<Id> diaryNotesId = new set<Id>();
        Diary_Notes__c drn = new Diary_Notes__c(comment__c='Test',Property_insurance__c=prIns.id,invoked_from_Batch__c=True);
        insert drn;
        diaryNotesId.add(drn.id);
        sendPendingNotifications sendPendingNotifications = new sendPendingNotifications('DiaryNote',null,null,null,diaryNotesId); 
         DataBase.executeBatch(sendPendingNotifications,1);
        Test.stopTest();
        

    }
    
    
    Private static void loaddata(){
    propertyInsurance14Day=new Property_insurance__c();
    propertyInsurance1Day=new Property_insurance__c();
    propertyInsurance7Day=new Property_insurance__c();
    String RecTypeId= [select Id from RecordType where (DeveloperName='ScCollection_Person_Account_CL') and (SobjectType='Account')].Id;
     
      Accnt = new Account(
      RecordTypeID=RecTypeId,
      FirstName='Test FName',
      LastName='Test LName',
      PersonMailingStreet='test@yahoo.com',
      PersonMailingPostalCode='12345',
      PersonMailingCity='SFO',
      PersonEmail='test@yahoo.com',
      PersonHomePhone='1234567',
      PersonMobilePhone='0414136952' 
    );
     
    insert Accnt;
    
    List<Property__c> stagingProperties = new List<Property__c>();
    //insert source system
            collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
    
            //Insert Object of Contract
            collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
            System.debug('@@@@@@'+objContract);
            objContract.collect__External_Id__c='MORTGAGE:123456_0';
            objContract.ScCollection_Lender_Record__c='PEPPER-ARM';
            objContract.ScCollection_Originator_ID__c='0001636';
            objContract.ScCollection_Mortgage_Funding__c='ABC';
            objContract.collect__Account__c=Accnt.id;
            update ObjContract;
            //Insert Object of another Contract
            collect__Loan_Account__c objContract1 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
            objContract1.collect__External_Id__c='MORTGAGE:123457_0';
            objContract1.ScCollection_Lender_Record__c='PEPPER-MANUAL';
            objContract1.ScCollection_Originator_ID__c='0001636';
            objContract1.ScCollection_Mortgage_Funding__c='ABC';
            objContract1.collect__Account__c=Accnt.id;
            update ObjContract1;
            //Insert Object of another Contract
            collect__Loan_Account__c objContract2 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
            objContract2.collect__External_Id__c='MORTGAGE:123458_0';
            objContract2.ScCollection_Lender_Record__c='PEPPER-NXG';
            objContract2.ScCollection_Originator_ID__c='0001636';
            objContract2.ScCollection_Mortgage_Funding__c='ABC';
            objContract2.collect__Account__c=Accnt.id;
            update ObjContract2;
            Property__c sp = new Property__c(Property_external_Id__c='0123451',Name='0123451',Source_Name__c='MORTGAGE');
            stagingProperties.add(sp);
            Property__c sp3 = new Property__c(Property_external_Id__c='0234511',Name='0234511',Source_Name__c='MORTGAGE');
            stagingProperties.add(sp3);
            Property__c sp4 = new Property__c(Property_external_Id__c='0234512',Name='0234512',Source_Name__c='MORTGAGE');
            stagingProperties.add(sp4);
            Property__c sp1 = new Property__c(Property_external_Id__c='0234513',Name='0234513',Source_Name__c='PAF');
            stagingProperties.add(sp1);
            Property__c sp2 = new Property__c(Property_external_Id__c='0876521',Name='0876521',Source_Name__c='');
            stagingProperties.add(sp2);
            insert stagingProperties;
            Property_Surrogate__c stagingPropSurrogate = new Property_Surrogate__c(name=stagingProperties[0].Property_external_Id__c+'_'+objContract.Collect__External_Id__c,Property_External_Id__c=stagingProperties[0].Property_external_Id__c,Property__c=stagingProperties[0].id,Loan_surrogate__c=Objcontract.id,LoanSurrogateExternalID__c=objContract.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[0].Property_external_Id__c+'_'+objContract.Collect__External_Id__c,Registration_Status__c='R');
            insert stagingPropSurrogate;
            Property_Surrogate__c stagingPropSurrogate3 = new Property_Surrogate__c(name=stagingProperties[1].Property_external_Id__c+'_'+objContract1.Collect__External_Id__c,Property_External_Id__c=stagingProperties[1].Property_external_Id__c,Property__c=stagingProperties[1].id,Loan_surrogate__c=ObjContract1.id,LoanSurrogateExternalID__c=objContract1.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[1].Property_external_Id__c+'_'+objContract1.Collect__External_Id__c,Registration_Status__c='R');
            insert stagingPropSurrogate3;
            Property_Surrogate__c stagingPropSurrogate4 = new Property_Surrogate__c(name=stagingProperties[2].Property_external_Id__c+'_'+objContract2.Collect__External_Id__c,Property_External_Id__c=stagingProperties[2].Property_external_Id__c,Property__c=stagingProperties[2].id,Loan_surrogate__c=Objcontract2.id,LoanSurrogateExternalID__c=objContract2.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[2].Property_external_Id__c+'_'+objContract2.Collect__External_Id__c,Registration_Status__c='R');
            insert stagingPropSurrogate4;
            Property_Insurer__c stagPropertyInsurer = new Property_Insurer__c(Name='Insurer1',Property_Insurer_External_Id__c='Insurer1',Insurer__c='Insurer');
            insert  stagPropertyInsurer;
            Property_Valuation__c prpValuation=new Property_Valuation__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),Property_external_id__c=stagingProperties[1].Property_external_Id__c,Property__c=stagingProperties[1].id,Property_Valuation_external_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),DWH_Valuation_Date__c=System.today()-2);
            insert prpValuation;
            Property_Insurance__c stagingPropertyInsurance = new Property_Insurance__c(Name=stagingProperties[0].Property_external_Id__c+':'+System.Today()+14,Property_External_Id__c=stagingProperties[0].Property_external_Id__c,DWH_Propert_Ins_Exp_Date__c=System.Today()+14,Property_Insurer_External_ID__c='Insurer1',Property__c=stagingProperties[0].id,Property_Insurance_External_Id__c=stagingProperties[0].Property_external_Id__c+':'+System.Today()+14,Source_Name__c='MORTGAGE',Property_Insurer__c=stagPropertyInsurer.id);
            insert stagingPropertyInsurance;
            propertyInsurance=stagingPropertyInsurance;
            propertyInsurance14Day=stagingPropertyInsurance;
            Property_Valuation__c prpValuation1=new Property_Valuation__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),Property_external_id__c='8789068',Property_Valuation_external_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),DWH_Valuation_Date__c=System.today()-2,Property__c=stagingProperties[1].id);
            insert prpValuation1;
            Property_Insurance__c stagingPropertyInsurance1 = new Property_Insurance__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-1),Property_External_Id__c=stagingProperties[1].Property_external_Id__c,Property__c=stagingProperties[1].id,Property_Insurer__c=stagPropertyInsurer.id,DWH_Propert_Ins_Exp_Date__c=System.Today()-1,Property_Insurer_External_ID__c='Insurer1',Property_Insurance_External_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-1),Source_Name__c='MORTGAGE');
            insert stagingPropertyInsurance1;
            propertyInsurance1Day=stagingPropertyInsurance1;
            Property_Insurance__c stagingPropertyInsurance2 = new Property_Insurance__c(Name=stagingProperties[2].Property_external_Id__c+':'+String.valueof(System.Today()+7),Property_External_Id__c=stagingProperties[2].Property_external_Id__c,Property__c=stagingProperties[2].id,Property_Insurer__c=stagPropertyInsurer.id,DWH_Propert_Ins_Exp_Date__c=System.Today()+7,Property_Insurer_External_ID__c='Insurer1',Property_Insurance_External_Id__c=stagingProperties[2].Property_external_Id__c+':'+String.valueof(System.Today()+7),Source_Name__c='MORTGAGE');
            insert stagingPropertyInsurance2;
            propertyInsurance7Day=stagingPropertyInsurance2;
            Diary_notes__c gy = new Diary_notes__c(comment__c='Test',Property_Insurance__c=propertyInsurance.id,Type__c='Call Created',Invoked_from_batch__c=true);
            insert gy;
            diaryNote=gy;
           
            
    }
    //This method is used to set up the basic data required by the private test methods for basic data.
     Private static void loaddata1(){
     
    String RecTypeId= [select Id from RecordType where (DeveloperName='ScCollection_Person_Account_CL') and (SobjectType='Account')].Id;
     
      Accnt = new Account(
      RecordTypeID=RecTypeId,
      FirstName='Test FName',
      LastName='Test LName',
      PersonMailingStreet='test@yahoo.com',
      PersonMailingPostalCode='12345',
      PersonMailingCity='SFO',
      PersonEmail='test@yahoo.com',
      PersonHomePhone='1234567',
      PersonMobilePhone='0414136952' 
    );
     
    insert Accnt;
    
    List<Property__c> stagingProperties = new List<Property__c>();
    //insert source system
            collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
    
            //Insert Object of Contract
            collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
            System.debug('@@@@@@'+objContract);
            objContract.collect__External_Id__c='MORTGAGE:123456_0';
            objContract.ScCollection_Lender_Record__c='PEPPER-ARM';
            objContract.ScCollection_Originator_ID__c='0001636';
            objContract.ScCollection_Mortgage_Funding__c='ABC';
            objContract.collect__Account__c=Accnt.id;
            update ObjContract;
            //Insert Object of another Contract
            collect__Loan_Account__c objContract1 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
            objContract1.collect__External_Id__c='MORTGAGE:123457_0';
            objContract1.ScCollection_Lender_Record__c='PEPPER-MANUAL';
            objContract1.ScCollection_Originator_ID__c='0001636';
            objContract1.ScCollection_Mortgage_Funding__c='ABC';
            objContract1.collect__Account__c=Accnt.id;
            update ObjContract1;
            //Insert Object of another Contract
            collect__Loan_Account__c objContract2 = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
            objContract2.collect__External_Id__c='MORTGAGE:123458_0';
            objContract2.ScCollection_Lender_Record__c='PEPPER-NXG';
            objContract2.ScCollection_Originator_ID__c='0001636';
            objContract2.ScCollection_Mortgage_Funding__c='ABC';
            objContract2.collect__Account__c=Accnt.id;
            update ObjContract2;
            Property__c sp = new Property__c(Property_external_Id__c='0123451',Name='0123451',Source_Name__c='MORTGAGE');
            stagingProperties.add(sp);
            Property__c sp3 = new Property__c(Property_external_Id__c='0234511',Name='0234511',Source_Name__c='MORTGAGE');
            stagingProperties.add(sp3);
            Property__c sp4 = new Property__c(Property_external_Id__c='0234512',Name='0234512',Source_Name__c='MORTGAGE');
            stagingProperties.add(sp4);
            Property__c sp1 = new Property__c(Property_external_Id__c='0234513',Name='0234513',Source_Name__c='PAF');
            stagingProperties.add(sp1);
            Property__c sp2 = new Property__c(Property_external_Id__c='0876521',Name='0876521',Source_Name__c='');
            stagingProperties.add(sp2);
            insert stagingProperties;
            Property_Surrogate__c stagingPropSurrogate = new Property_Surrogate__c(name=stagingProperties[0].Property_external_Id__c+'_'+objContract.Collect__External_Id__c,Property_External_Id__c=stagingProperties[0].Property_external_Id__c,Property__c=stagingProperties[0].id,Loan_surrogate__c=Objcontract.id,LoanSurrogateExternalID__c=objContract.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[0].Property_external_Id__c+'_'+objContract.Collect__External_Id__c,Registration_Status__c='R');
            insert stagingPropSurrogate;
            Property_Surrogate__c stagingPropSurrogate3 = new Property_Surrogate__c(name=stagingProperties[1].Property_external_Id__c+'_'+objContract1.Collect__External_Id__c,Property_External_Id__c=stagingProperties[1].Property_external_Id__c,Property__c=stagingProperties[1].id,Loan_surrogate__c=ObjContract1.id,LoanSurrogateExternalID__c=objContract1.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[1].Property_external_Id__c+'_'+objContract1.Collect__External_Id__c,Registration_Status__c='R');
            insert stagingPropSurrogate3;
            Property_Surrogate__c stagingPropSurrogate4 = new Property_Surrogate__c(name=stagingProperties[2].Property_external_Id__c+'_'+objContract2.Collect__External_Id__c,Property_External_Id__c=stagingProperties[2].Property_external_Id__c,Property__c=stagingProperties[2].id,Loan_surrogate__c=Objcontract2.id,LoanSurrogateExternalID__c=objContract2.Collect__External_Id__c,Property_SurrogateExternalID__c=stagingProperties[2].Property_external_Id__c+'_'+objContract2.Collect__External_Id__c,Registration_Status__c='R');
            insert stagingPropSurrogate4;
            Property_Insurer__c stagPropertyInsurer = new Property_Insurer__c(Name='Insurer1',Property_Insurer_External_Id__c='Insurer1',Insurer__c='Insurer');
            insert  stagPropertyInsurer;
            Property_Valuation__c prpValuation=new Property_Valuation__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),Property_external_id__c=stagingProperties[1].Property_external_Id__c,Property__c=stagingProperties[1].id,Property_Valuation_external_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),DWH_Valuation_Date__c=System.today()-2);
            insert prpValuation;
            Property_Insurance__c stagingPropertyInsurance = new Property_Insurance__c(Name=stagingProperties[0].Property_external_Id__c+':'+System.Today()+14,Property_External_Id__c=stagingProperties[0].Property_external_Id__c,DWH_Propert_Ins_Exp_Date__c=System.Today()+14,Property_Insurer_External_ID__c='Insurer1',Property__c=stagingProperties[0].id,Property_Insurance_External_Id__c=stagingProperties[0].Property_external_Id__c+':'+System.Today()+14,Source_Name__c='MORTGAGE',Property_Insurer__c=stagPropertyInsurer.id);
            insert stagingPropertyInsurance;
            
            propertyInsurance=stagingPropertyInsurance;
            
            Property_Valuation__c prpValuation1=new Property_Valuation__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),Property_external_id__c='8789068',Property_Valuation_external_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-2),DWH_Valuation_Date__c=System.today()-2,Property__c=stagingProperties[1].id);
            insert prpValuation1;
            Property_Insurance__c stagingPropertyInsurance1 = new Property_Insurance__c(Name=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-1),Property_External_Id__c=stagingProperties[1].Property_external_Id__c,Property__c=stagingProperties[1].id,Property_Insurer__c=stagPropertyInsurer.id,DWH_Propert_Ins_Exp_Date__c=System.Today()-1,Property_Insurer_External_ID__c='Insurer1',Property_Insurance_External_Id__c=stagingProperties[1].Property_external_Id__c+':'+String.valueof(System.Today()-1),Source_Name__c='MORTGAGE');
            insert stagingPropertyInsurance1;
            
            Property_Insurance__c stagingPropertyInsurance2 = new Property_Insurance__c(Name=stagingProperties[2].Property_external_Id__c+':'+String.valueof(System.Today()+7),Property_External_Id__c=stagingProperties[2].Property_external_Id__c,Property__c=stagingProperties[2].id,Property_Insurer__c=stagPropertyInsurer.id,DWH_Propert_Ins_Exp_Date__c=System.Today()+7,Property_Insurer_External_ID__c='Insurer1',Property_Insurance_External_Id__c=stagingProperties[2].Property_external_Id__c+':'+String.valueof(System.Today()+7),Source_Name__c='MORTGAGE');
            insert stagingPropertyInsurance2;
           
            
           
            
    }
     //This method is used to set up the basic data(Metadata) required by the private test methods for basic data.
    Private static void loadcustomsetting(){
    PropertyInsuranceCredentials__c crd = new PropertyInsuranceCredentials__c(Name='Credentials',Username__c='pepper',Password__c='P3pp3rPa55',endpoint__c='https://pepperpropertyinsurance-sandbox.au.cloudhub.io');
    insert crd;
    List<StatusTOExcludeForCOC__c> statusesToexculde = new List<StatusTOExcludeForCOC__c>();
    StatusTOExcludeForCOC__c ccostatus1 = new StatusTOExcludeForCOC__c(Name='Discharged');
    statusesToexculde.add(ccostatus1);
    StatusTOExcludeForCOC__c ccostatus2 = new StatusTOExcludeForCOC__c(Name='Discharge Pending');
    statusesToexculde.add(ccostatus2);
    StatusTOExcludeForCOC__c ccostatus3 = new StatusTOExcludeForCOC__c(Name='Claim');
    statusesToexculde.add(ccostatus3);
    StatusTOExcludeForCOC__c ccostatus4 = new StatusTOExcludeForCOC__c(Name='Mortgagee in Possession');
    statusesToexculde.add(ccostatus4);
    insert statusesToexculde;
    List<SMSText__c> smsTexts = new List<SMSText__c>();
    SMSText__c sms1 = new SMSText__c(Name='Before14Days',SMS_Text__c='Your insurance is getting expired within 14 days so please mail your updated COC on abc@gmail.com.');
    smsTexts.add(sms1); 
    SMSText__c sms2 = new SMSText__c(Name='After1Day',SMS_Text__c='Your Insurance has ben expired so please mail your updated COC at abc@gmail.com.');
    smsTexts.add(sms2);
    insert smsTexts; 
    List<LenderRecordsForCOC__c> customsetting = new List<LenderRecordsForCOC__c>();
    LenderRecordsForCOC__c lenderRecordsCoc1 = new LenderRecordsForCOC__c(Name='PEPPER-ARM');
    customsetting.add(lenderRecordsCoc1);
    LenderRecordsForCOC__c lenderRecordsCoc2 = new LenderRecordsForCOC__c(Name='PEPPER-NXG');
    customsetting.add(lenderRecordsCoc2);
    LenderRecordsForCOC__c lenderRecordsCoc3 = new LenderRecordsForCOC__c(Name='PEPPER-MANUAL');
    customsetting.add(lenderRecordsCoc3);
    LenderRecordsForCOC__c lenderRecordsCoc4 = new LenderRecordsForCOC__c(Name='PEPPER    ARM        -');
    customsetting.add(lenderRecordsCoc4); 
    LenderRecordsForCOC__c lenderRecordsCoc5 = new LenderRecordsForCOC__c(Name='PEPPER    NXG        -');
    customsetting.add(lenderRecordsCoc5); 
    LenderRecordsForCOC__c lenderRecordsCoc6 = new LenderRecordsForCOC__c(Name='PEPPER    MANUAL        -');
    customsetting.add(lenderRecordsCoc6);
    insert customsetting;
    EscalationLevel2emails__c esc2 = new EscalationLevel2emails__c(Name='Insurance Testing',Email__c='abc@gmail.com');
    insert esc2;
    CarbonCopyEscalation1emails__c ccesc1 = new CarbonCopyEscalation1emails__c(Name='Lavenia',email__c='test@gmail.com');
    insert ccesc1 ;
    CarbonCopyEscalation2emails__c ccesc2 = new CarbonCopyEscalation2emails__c(Name='CCEscalation2',Email__c='test@gmail.com');
    insert ccesc2;
    EscalationLevel1emails__c esc1 = new EscalationLevel1emails__c(Name='Test',Email_Address__c='test@gmail.com');
    insert esc1;
    List<BendigoStrings__c> bendigocustomers = new List<BendigoStrings__c>();
    BendigoStrings__c bend161 = new BendigoStrings__c(Name='BEND161');
    bendigocustomers.add(bend161);
    BendigoStrings__c bend162 = new BendigoStrings__c(Name='BEND162');
    bendigocustomers.add(bend162);
    insert bendigocustomers;
    SwitchoffCoC__c cc = new SwitchoffCoC__c(setupownerId=UserInfo.getOrganizationId(),switch__c=True);
    insert cc;
    
    }
}