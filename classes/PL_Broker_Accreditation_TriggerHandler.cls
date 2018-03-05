/*------------------------------------------------------------
    Author:        	Sean Jolly
    Name:          	PLBrokerAccreditationController
    Company:       	Pepper
    Description:   	Handles all trigger related operations of the PL_Broker_Accreditation_Trigger trigger on PL_Broker_Accreditation__c
	Test Class : 	PL_Broker_Accreditation_TriggerTest
    History
    20171113     	Sean Jolly     Class Created
    ------------------------------------------------------------*/


public class PL_Broker_Accreditation_TriggerHandler {

        /*------------------------------------------------------------
        Author:        Sean Jolly
        Name:          onBeforeInsert
        Company:       Pepper
        Description:   Handles all actions to be done before insert of records
        Inputs:        List of PL_Broker_Accreditation__c objects
        Returns:       void
        History
        20171113     	Sean Jolly     Method Created
        ------------------------------------------------------------*/ 
    
    public void onBeforeInsert(List<PL_Broker_Accreditation__c> lstNew)
    {        
        populateP1RandomString(lstNew);
    }
 
        /*------------------------------------------------------------
        Author:        Sean Jolly
        Name:          onBeforeInsert
        Company:       Pepper
        Description:   Calls the generate random string method for each object in the list, and sets P1 on each object to the returned random string.
        Inputs:        List of PL_Broker_Accreditation__c objects
        Returns:       void
        History
        20171113     	Sean Jolly     Method Created
        ------------------------------------------------------------*/     
    
    public void populateP1RandomString(List<PL_Broker_Accreditation__c> lstNew){
        for(PL_Broker_Accreditation__c obj : lstNew)
        {
            obj.P1__c = GenerateRandomString.generateRandomString(20);
        }
    }
}