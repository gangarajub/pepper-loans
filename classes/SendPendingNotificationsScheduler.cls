Global class SendPendingNotificationsScheduler implements Schedulable{
Global void execute(SchedulableContext scontext){
sendPendingNotifications sAutomatic = new sendPendingNotifications('SMS',null,null,null,null);
DataBase.executeBatch(sAutomatic,50);
}
}