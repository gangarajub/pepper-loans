/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          ScCollection_BatchToUpdateRecordCount 
Company:       Saasfocus
Description:   This is the batch class which is use create the 
               record with the count of records for 
               LOB Mortgage and PAF.
History
Date    :  13/11/2017     
------------------------------------------------------------*/
public class ScCollection_BatchToUpdateRecordCount implements Database.Batchable<sObject>,Database.Stateful{

    public final String Query;
    public List<ESB_Batch_Load_Stat__c> lstEsbBatchLoadStat = new List<ESB_Batch_Load_Stat__c>();
    
    //constructor
    public ScCollection_BatchToUpdateRecordCount(){

        Query='Select Name,ScCollection_Query__c from ScCollection_Record_Count__c'; 

    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          start
    Company:       Saasfocus
    Description:   This is the start method use to return result based on the query.
    Inputs:        Database.BatchableContext
    Returns:       Database.QueryLocator
    -----------------------------------------------------------------------------------*/
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          execute
    Company:       Saasfocus
    Description:   This method is use to process the query records and create the 
                   ESB batch job stat object for LOB PAF and Mortgage
    Inputs:        Database.BatchableContext,List<sObject>
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<ScCollection_Record_Count__c> lstCustomSetting = (List<ScCollection_Record_Count__c>)scope;
        ESB_Batch_Load_Stat__c objBatchJobStat;
        if(lstCustomSetting != null && lstCustomSetting.Size() > 0){
            try{
                ScCollection_Record_Count__c objCustomSetting = lstCustomSetting[0];
                for(AggregateResult obj : database.query(objCustomSetting.ScCollection_Query__c)){
                    if(obj.get('lob') != null && (String.valueOf(obj.get('lob')).equalsignorecase('Mortgage') || String.ValueOf(obj.get('lob')).equalsignorecase('PAF'))){
                        objBatchJobStat = new ESB_Batch_Load_Stat__c();
                        objBatchJobStat.LOB__c = String.valueOf(obj.get('lob'));
                        objBatchJobStat.Total_Records__c = Integer.valueof(obj.get('cnt'));
                        objBatchJobStat.Entity__c = objCustomSetting.Name;
                        objBatchJobStat.Batch_Job_Instance_Id__c = BC.getJobId();
                        lstEsbBatchLoadStat.add(objBatchJobStat);
                    }
                }
                
            }
            catch(exception ex){
                objBatchJobStat = new ESB_Batch_Load_Stat__c();
                objBatchJobStat.Input_Phase_Exception__c = ex.getMessage();
                objBatchJobStat.Entity__c = lstCustomSetting[0].Name;
                objBatchJobStat.Batch_Job_Instance_Id__c = BC.getJobId();
                lstEsbBatchLoadStat.add(objBatchJobStat);
            }
        }
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          finish
    Company:       Saasfocus
    Description:   This is the finish method.
    Inputs:        Database.BatchableContext
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public void finish(Database.BatchableContext BC){
        if(lstEsbBatchLoadStat != null && lstEsbBatchLoadStat.Size() > 0){
            insert lstEsbBatchLoadStat;
        }
    }
}