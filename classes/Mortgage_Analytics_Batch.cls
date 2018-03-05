// This batch class is used as an Anlytics Snapshot for Mortgage data
// --------------------------------------------------------------------------------------------- 
// Version#     Date              Author                 Description
// ---------------------------------------------------------------------------------------------
// 1.0       6-May-2016      Sumit Banarji           Initial Version
// ---------------------------------------------------------------------------------------------

global class Mortgage_Analytics_Batch implements Database.Batchable<sObject>, Database.Stateful
{ 
    //-------- Defining Global Variables -----//
	global Datetime lastSyncDateTime;
    global Datetime SyncStartDateTime;
	//----- End Defining Global Variables ----//

	/**
	* @Constructor
	* @Getting data from Custom Settings and initializing global variables.
	*/
    global Mortgage_Analytics_Batch()
    {
        SyncStartDateTime = Datetime.now();
        List<Mulesoft_Configuration__c> lstMC = Mulesoft_Configuration__c.getall().values();
        if (lstMC != null && lstMC.size() > 0) lastSyncDateTime = lstMC[0].Mortgage_Last_Sync_Time__c;
    }

	/**
	* @Batch query locator
	* @param BC 
	* @return Database.QueryLocator 
	*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator('Select CreatedDate, Amount__c, ApplicationID__c, Application_Date__c, Borrower_State__c, Channel__c, Product_class_name__c, Status_Detail__c, Status__c FROM Pepper_Data__c where LastModifiedDate >=: lastSyncDateTime and LastModifiedDate <: SyncStartDateTime ');
      
    }

	/**
	* @Execute Method used to process current context
	* @param BC 
	* @param scope 
	*/
    global void execute(Database.BatchableContext BC, List<Pepper_Data__c> scope)
    {
        List<Pepper_Analytical_Snapshot__c> listMortgAnlyticalSnpst = new List<Pepper_Analytical_Snapshot__c>();
        if(scope != null) for(Pepper_Data__c objAppdata : scope)
        {
			//------------ Creating new record for Analyics object ----------//
            Pepper_Analytical_Snapshot__c objMortgAnlyticalSnpst = new Pepper_Analytical_Snapshot__c();
            
            objMortgAnlyticalSnpst.Amount_as__c = objAppdata.Amount__c;
            objMortgAnlyticalSnpst.ApplicationID_as__c  = objAppdata.ApplicationID__c;
            objMortgAnlyticalSnpst.Application_Date_as__c   = objAppdata.Application_Date__c;
            objMortgAnlyticalSnpst.Borrower_State_as__c = objAppdata.Borrower_State__c;
            objMortgAnlyticalSnpst.Channel_as__c    = objAppdata.Channel__c;
            objMortgAnlyticalSnpst.Product_class_name_as__c = objAppdata.Product_class_name__c;
            objMortgAnlyticalSnpst.Status_Detail__c = objAppdata.Status_Detail__c;
            objMortgAnlyticalSnpst.Status_as__c     = objAppdata.Status__c;
			//--------- End Creating new record for Analyics object ----------//

			//Adding in the list to insert
            listMortgAnlyticalSnpst.add(objMortgAnlyticalSnpst);
        }
        if (listMortgAnlyticalSnpst.size() > 0) insert listMortgAnlyticalSnpst;    
    }

    /**
    * @Method used to run a process after finishing of batch
    * @param BC 
    */
    global void finish(Database.BatchableContext BC)
    {  
		//------- Updating last run timestamp in custom settings -----//
        List<Mulesoft_Configuration__c> lstMC = Mulesoft_Configuration__c.getall().values();
        if (lstMC != null && lstMC.size() > 0)
        { 
            lstMC[0].Mortgage_Last_Sync_Time__c = SyncStartDateTime;
            update lstMC;
        }
		//----- End Updating last run timestamp in custom settings --//
		//ChatterNotification.SendNotification(Label.Mortgage_Dashboard);
    }
}