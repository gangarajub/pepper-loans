public class AddParty{


    public clcommon__Party__c  add(String referralCode,String appId){
        
        clcommon__Party__c party= new clcommon__Party__c();
        clcommon__Party__c partyType= new clcommon__Party__c();
        RecordType personAccount = [select id,name from RecordType where name='Person Account'];
        RecordType businessAccount = [select id,name from RecordType where name='Business Account'];
        List<clcommon__Party_Type__c> type= [select id,name from clcommon__Party_Type__c where name='REFERRAL'];
        List<clcommon__Party_Type__c> Brokertype= [select id,name from clcommon__Party_Type__c where name='Broker'];
        List<String> recordType = new List<String>();
        recordType.add(type[0].Id);
        recordType.add(Brokertype[0].Id);
        Boolean codeFound = false;
        //MODIFIED BY CJJOYA 181120161509 ADDED Account ID in the query
        List<Contact> cont =[select id, AccountID, loan__Contact_Type__c from Contact where Referral_Code__c=:referralCode];  
        //END OF MODIFICATION 181120161509 
        List<Account> accnt = [select id,RecordTypeId,loan__Broker__c,loan__Contact_Type__pc from Account where Referral_Code__c=:referralCode];    
        List<genesis__Applications__c> app1=[select id,name,aggregator__c, broker__c, genesis__Contact__c from genesis__Applications__c where id=:appId]; 
        
        if(cont.size()==0 && accnt.size() == 0){
            //REMOVED BY CJJOYA 
            //List<genesis__Applications__c> app1=[select id,name,genesis__Contact__c from genesis__Applications__c where id=:appId]; 
            List<Contact> con1 = [select id,name,Email from Contact where id=:app1[0].genesis__Contact__c];   
                 if(con1.size()>0){
                 loan__Loan_Account__c cl = new loan__Loan_Account__c();
                 System.debug('Invalid referral code');
                 EmailUtil.sendEmail(con1[0],true,cl.Id);
                 }
        }
        if(cont.size()>0){
           
            List<clcommon__Party__c> existingparty11=[select id,name from clcommon__Party__c where genesis__Application__c=:appId and clcommon__Type__c IN : recordType];
            if(existingparty11.size()==0){
            if((cont[0].loan__Contact_Type__c==null) || (cont[0].loan__Contact_Type__c=='Broker')){
       
                    partyType.clcommon__Contact__c = cont[0].Id;
                    partyType.genesis__Application__c = appId;
                    partyType.clcommon__Type__c = Brokertype[0].Id;   
                    cont[0].loan__Contact_Type__c='Broker';
                    app1[0].aggregator__c = cont[0].AccountID;
                    app1[0].broker__c = cont[0].id;
                    update cont[0];
                    
                    insert partyType; 
                    update app1[0];
                    codeFound = true; 
                      
                }
            
        }
        }
        
        
        if(accnt.size()>0){
            RecordType recordofReferral=[select id,name from RecordType where id=:accnt[0].RecordTypeId];
                
            List<clcommon__Party__c> existingparty1=[select id,name from clcommon__Party__c where genesis__Application__c=:appId and clcommon__Type__c IN : recordType];
            if(existingparty1.size()==0){
            if(accnt[0].loan__Contact_Type__pc==null && accnt[0].loan__Broker__c==false){
                    partyType.clcommon__Account__c = accnt[0].Id;
                    partyType.genesis__Application__c = appId;
                    partyType.clcommon__Type__c = type[0].Id;   
                    accnt[0].loan__Contact_Type__pc='Broker';
                    update accnt[0];
                    insert partyType;    
                }
            }   
            List<clcommon__Party__c> existingparty=[select id,name from clcommon__Party__c where genesis__Application__c=:appId and clcommon__Type__c IN : recordType];
           
            if(existingparty.size()==0){
                System.debug('recordofReferral.name'+recordofReferral.name);
               
                if(recordofReferral.name.equalsIgnoreCase('Person Account')){
                if((accnt[0].loan__Contact_Type__pc!=null && accnt[0].loan__Contact_Type__pc.equalsIgnoreCase('Broker')) || (accnt[0].loan__Broker__c!=null && accnt[0].loan__Broker__c==true)){
                    partyType.clcommon__Account__c = accnt[0].Id;
                    partyType.genesis__Application__c = appId;
                    partyType.clcommon__Type__c = type[0].Id;   
                     
                }
                
                 
            }
            
            if(recordofReferral.name.equalsIgnoreCase('Business Account')){
               
                 if((accnt[0].loan__Contact_Type__pc!=null && accnt[0].loan__Contact_Type__pc.equalsIgnoreCase('Broker')) || (accnt[0].loan__Broker__c!=null && accnt[0].loan__Broker__c==true)){
                     partyType.clcommon__Account__c = accnt[0].Id;
                     partyType.genesis__Application__c = appId;
                     partyType.clcommon__Type__c = Brokertype[0].Id;
                
                }
                accnt[0].loan__Broker__c=true; 
            }
            
            update accnt[0];
            insert partyType;
            }else{
                
            }
        }
         return partyType;
    }
}