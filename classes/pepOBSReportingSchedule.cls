// ---------------------------------------------------------------------------------------------------------
// This class is used to schedule pepOBSReportingClass  controller to send report on daily basis.
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      10th Nov 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------

global class pepOBSReportingSchedule implements System.Schedulable {
    global void execute(SchedulableContext sc) {
           pepOBSReportingClass.EmailReports();
    }
}