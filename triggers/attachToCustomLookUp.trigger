/*------------------------------------------------------------
Author:        Varun Arora
Name:          attachToCustomLookUp 
Company:       Saasfocus
Description:   This Trigger is use to tag the incomming msg with 
               the latest communicated record based on the 
               mobile number.
History
Date    :  21/05/2017     
------------------------------------------------------------*/
trigger attachToCustomLookUp on smagicinteract__Incoming_SMS__c (before insert){
    if(Trigger.isBefore && Trigger.isInsert){
        IncomingSMSTagger.tagsms(Trigger.new);
    }
}