/*------------------------------------------------------------
Author:        Varun Arora
Name:          IncomingSmsTagger 
Company:       Saasfocus
Description:   This class the the Incomming SMS trigger handler 
               used to tag the Incomming msg with the last 
               communicated Record from the system based on 
               the mobile number.
History
Date    :  21/05/2017     
------------------------------------------------------------*/
Public class IncomingSmsTagger{
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          tagSms
    Company:       Saasfocus
    Description:   This method is use to tag the Incomming SMS to the Record.
    Inputs:        List<smagicinteract__Incoming_SMS__c>
    Returns:       void
    -----------------------------------------------------------------------------------*/
    Public static void tagSms(List<smagicinteract__Incoming_SMS__c> newList){
        
        set<string> mobileNumber = new set<string>();
        set<string> mobileNumberAdded = new set<string>();
        Map<string,smagicinteract__smsMagic__c> mobileNumberToSMSHistory = new Map<string,smagicinteract__smsMagic__c>();
        
        for(smagicinteract__Incoming_SMS__c inSms:newList){
            
            if(inSms.smagicinteract__Mobile_Number__c != null){
                //replacing 61 with 0.
                if(String.valueof(inSms.smagicinteract__Mobile_Number__c).substring(0,1)=='6' && String.valueof(inSms.smagicinteract__Mobile_Number__c).substring(1,2)=='1'){
                    inSms.smagicinteract__Mobile_Number__c=String.valueof(inSms.smagicinteract__Mobile_Number__c).substring(2,String.valueof(inSms.smagicinteract__Mobile_Number__c).length());
                    inSms.smagicinteract__Mobile_Number__c='0'+inSms.smagicinteract__Mobile_Number__c;
                }
                mobilenumber.add(inSms.smagicinteract__Mobile_Number__c);
            }
        }
        
        //search the latest SMS record with the Mobile number.
        List<smagicinteract__smsMagic__c> smsHistoryLatest =[Select id,smagicinteract__Account__c,smagicinteract__Contact__c,smagicinteract__Lead__c,Party__c,smagicinteract__PhoneNumber__c from smagicinteract__smsMagic__c where smagicinteract__PhoneNumber__c in:mobilenumber order by CreatedDate DESC];
        
        set<Id> setLeadId = new set<Id>();
        map<string,Lead> mapNumtoObject = new map<string,Lead>();
        
        if(smsHistoryLatest !=null && smsHistoryLatest.size()>0){
        for(smagicinteract__smsMagic__c smsLatest:smsHistoryLatest){
            
            //create the set and the map for the last communicated record.
            if(!mobileNumberAdded.contains(smsLatest.smagicinteract__PhoneNumber__c)){
                
                //If Lead lookup is filled in the SMS record...check if the Lead is already converted or not.
                if(smsLatest.smagicinteract__Lead__c != null){
                    setLeadId.add(smsLatest.smagicinteract__Lead__c);
                }
                mobileNumberToSMSHistory.put(smsLatest.smagicinteract__PhoneNumber__c,smsLatest);
                mobileNumberAdded.add(smsLatest.smagicinteract__PhoneNumber__c);
            }
        }
    }
    
        //Checking if the Lead is Converted or not.
        
        if(setLeadId != null && setLeadId.Size() < 0){
            for(Lead objLead : [Select convertedAccountId, convertedContactId From lead where IsConverted = true and id in : setLeadId]){
                
                mapNumtoObject.put(objLead.Id,objLead);
            }
        }
        
        //Updating the record with the record loopup.       
        for(smagicinteract__Incoming_SMS__c inSms:newList){
            if(inSms.smagicinteract__Mobile_Number__c != null){
                
               
                if(mobileNumberToSMSHistory.get(inSms.smagicinteract__Mobile_Number__c) != null){
                  smagicinteract__smsMagic__c smsHistoryRecord=mobileNumberToSMSHistory.get(inSms.smagicinteract__Mobile_Number__c);
                    if(smsHistoryRecord.smagicinteract__Account__c!=null){
                        inSms.Account__c=smsHistoryRecord.smagicinteract__Account__c;
                    }
                   
                    if(smsHistoryRecord.smagicinteract__Contact__c!=null){
                        inSms.smagicinteract__Contact__c=smsHistoryRecord.smagicinteract__Contact__c;
                    }
                   
                    if(smsHistoryRecord.smagicinteract__Lead__c!=null){
                       
                        if(mapNumtoObject.containsKey(smsHistoryRecord.smagicinteract__Lead__c) && mapNumtoObject.get(smsHistoryRecord.smagicinteract__Lead__c) != null){
                            inSms.Account__c = (mapNumtoObject.get(smsHistoryRecord.smagicinteract__Lead__c)).convertedAccountId;
                            inSms.smagicinteract__Contact__c = (mapNumtoObject.get(smsHistoryRecord.smagicinteract__Lead__c)).convertedContactId;
                        }
                        inSms.smagicinteract__Lead__c=smsHistoryRecord.smagicinteract__Lead__c;
                    }
                   
                    if(smsHistoryRecord.Party__c!=null){
                       inSMS.Party__c=smsHistoryRecord.Party__c;
                    }
                }
            }
        }
      
    }
}