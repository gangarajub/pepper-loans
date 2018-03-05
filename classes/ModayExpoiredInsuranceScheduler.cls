Global class ModayExpoiredInsuranceScheduler implements Schedulable,Database.AllowsCallouts{
Global void execute(SchedulableContext Sc){
MondayExpiredInsuranceReport.SendExpiredInsuranceReport();
}
}