global class pepCreateFriendsAccount_Batch implements Database.Batchable<sObject>,Schedulable{
 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select id,accountid,Name,FirstName,LastName,Email,MobilePhone,Referred_By_Code__c,Referral_link__c from contact where Is_Referred_Friend__c=true]);
    }
    
    global void execute(SchedulableContext SC){
        pepCreateFriendsAccount_Batch  accBatch= new pepCreateFriendsAccount_Batch();
        String cronStr = '0 0,30 * * * *';
        System.schedule('Process contacts', cronStr, accBatch);
        database.executebatch(accBatch);
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account>   listNewAccount=new List<Account>();
        List<Account>   listUpdateAccount=new List<Account>();
        List<Id>    listNewAccountId=new List<Id>();
        List<Contact>   listUpdateContact=new List<Contact>();
        for(sobject s : scope)
        {
            Contact newContact=(Contact)s;
            Account A = new Account();
            A.Name = newContact.Name;
            A.Referred_By_Code__c=newContact.Referred_By_Code__c;
            A.Referral_link__c=newContact.Referral_link__c;
            A.ownerid=Portal_OwnerId__c.getinstance('First').Owner_Id__c;
            listNewAccount.add(A);        
        }
        if(listNewAccount.size()>0) insert listNewAccount;
        Integer i=0;    
        for(sobject s : scope)
        {
            Contact newContact=(Contact)s;
            Contact C = new Contact(id=newContact.id,ownerid=Portal_OwnerId__c.getinstance('First').Owner_Id__c);
            C.AccountID = listNewAccount[i].Id;
            C.Is_Referred_Friend__c=false;
            listUpdateContact.add(C);
           listNewAccountId.add(listNewAccount[i].Id);
            
            //listNewAccountId.add(C.Accountid);
            i++;
        }
        if(listUpdateContact.size()>0) update listUpdateContact;
        //Id AccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id personAccRecordTypeId =[Select id from RecordType where sobjectType='Account' and isPersonType=True and isActive=True Limit 1].id;
        //Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Account>  listAccount= [Select Id from Account where Id IN : listNewAccountId];
        for(Account A1 : listAccount)
        {
            //Account A2 = new Account(id=A1.id);
            A1.recordTypeId = personAccRecordTypeId;
            listUpdateAccount.add(A1);
        }
        if(listUpdateAccount.size()>0) update listUpdateAccount;
        system.debug('listUpdateAccount--'+listUpdateAccount);
    }

   global void finish(Database.BatchableContext BC){
   }
}