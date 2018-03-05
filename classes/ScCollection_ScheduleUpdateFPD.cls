//  -------------------------------------------------------------------------------------------------------
//  This scheduler would call the batch class ScCollection_BatchUpdateFPD
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 4-NOV-2016         Created By: Deepak Dhingra         Email: deepak.dhingra@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestScheduleUpdateFPD
//  -------------------------------------------------------------------------------------------------------
global class ScCollection_ScheduleUpdateFPD implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        // for batch reference system "PAF"
        ScCollection_BatchUpdateFPD refPAF = new ScCollection_BatchUpdateFPD(System.today(),'PAF'); 
        database.executebatch(refPAF);
        // for batch reference system "MORTGAGE"
        ScCollection_BatchUpdateFPD refMortgage = new ScCollection_BatchUpdateFPD(System.today(),'MORTGAGE'); 
        database.executebatch(refMortgage);
    }
}