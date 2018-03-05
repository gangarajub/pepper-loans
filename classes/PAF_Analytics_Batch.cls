// This batch class is used as an Anlytics Snapshot for PAF data
// --------------------------------------------------------------------------------------------- 
// Version#     Date              Author                 Description
// ---------------------------------------------------------------------------------------------
// 1.0       6-May-2016      Sumit Banarji           Initial Version
// ---------------------------------------------------------------------------------------------

global class PAF_Analytics_Batch implements Database.Batchable<sObject>, Database.Stateful
{ 
	//-------- Defining Global Variables -----// 
    global Datetime lastSyncDateTime;
    global Datetime SyncStartDateTime;
	//----- End Defining Global Variables ----//

	/**
	* @Constructor
	* @Getting data from Custom Settings and initializing global variables.
	*/
    global PAF_Analytics_Batch() 
    {
        SyncStartDateTime = Datetime.now();
        List<Mulesoft_Configuration__c> lstMC = Mulesoft_Configuration__c.getall().values();
        if (lstMC != null && lstMC.size() > 0) lastSyncDateTime = lstMC[0].PAF_Last_Sync_Time__c;
    }

	/**
	* @Batch query locator
	* @param BC 
	* @return Database.QueryLocator 
	*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator('Select Name, CreatedDate, ApplicationDate__c, ApplicationNumber__c, ApplicationState__c, Channel__c, MileStone__c, NetFinancedAmount__c, Sub_Status__c, TotalFinancedAmount__c, AssetType__c FROM Application_Data__c where LastModifiedDate >=: lastSyncDateTime and LastModifiedDate <: SyncStartDateTime');
    }

	/**
	* @Execute Method used to process current context
	* @param BC 
	* @param scope 
	*/
    global void execute(Database.BatchableContext BC, List<Application_Data__c> scope)
    {
        List<PFA_Analytical_Snapshot__c> listPFAAnlyticalSnpst = new List<PFA_Analytical_Snapshot__c>();
        if(scope != null) for(Application_Data__c objAppdata : scope)
        {
			//------------ Creating new record for Analyics object ----------//
            PFA_Analytical_Snapshot__c objPFAAnlyticalSnpst = new PFA_Analytical_Snapshot__c();
            
            objPFAAnlyticalSnpst.ApplicationDate__c = objAppdata.ApplicationDate__c;
            objPFAAnlyticalSnpst.ApplicationNumber__c   = objAppdata.ApplicationNumber__c;
            objPFAAnlyticalSnpst.ApplicationState__c    = objAppdata.ApplicationState__c;
            objPFAAnlyticalSnpst.Channel__c = objAppdata.Channel__c;
            objPFAAnlyticalSnpst.MileStone__c   = objAppdata.MileStone__c;
            objPFAAnlyticalSnpst.NetFinancedAmount__c   = objAppdata.NetFinancedAmount__c;
            objPFAAnlyticalSnpst.Sub_Status__c  = objAppdata.Sub_Status__c;
            objPFAAnlyticalSnpst.TotalFinancedAmount__c = objAppdata.TotalFinancedAmount__c;
            objPFAAnlyticalSnpst.AssetType__c   = objAppdata.AssetType__c;
			//--------- End Creating new record for Analyics object ----------//
            
			//Adding in the list to insert
            listPFAAnlyticalSnpst.add(objPFAAnlyticalSnpst);
        }
        if (listPFAAnlyticalSnpst.size() > 0) insert listPFAAnlyticalSnpst;    
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
            lstMC[0].PAF_Last_Sync_Time__c = SyncStartDateTime;
            update lstMC;
        }
		//----- End Updating last run timestamp in custom settings --//

		//ChatterNotification.SendNotification(Label.PAF_Dashboard);
    }
}