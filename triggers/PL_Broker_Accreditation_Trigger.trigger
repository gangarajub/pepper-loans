/*------------------------------------------------------------
Author:        Sean Jolly
Name:          PL_Broker_Accreditation_Trigger
Company:       Pepper
Description:   This trigger handles automations to be done on PL Broker Accreditation object
Events:        before insert
Test Class:    PL_Broker_Accreditation_TriggerTest
History
2017-11-13      Sean Jolly     Created
------------------------------------------------------------*/


trigger PL_Broker_Accreditation_Trigger on PL_Broker_Accreditation__c (before insert) {

PL_Broker_Accreditation_TriggerHandler handler = new PL_Broker_Accreditation_TriggerHandler();

    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            handler.onBeforeInsert(Trigger.new);
        }
    }
}