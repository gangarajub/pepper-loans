Global class CocSyncScheduler implements Schedulable{
Global void execute(SchedulableContext context){
Cocsync sync = new CocSync('Staging_Property__c');
DataBase.executeBatch(sync,Integer.valueof(Label.COCBatchsize));
}
}