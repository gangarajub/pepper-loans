/*
This class is used to schedule the sendAutomaticNotifications Batch class on Daily Basis.
Author:Varun Arora
LastModifiedDate:October 9,2017
*/
Public class SendAutomaticNotificationsScheduler implements Schedulable{
//This method will be used to execute the Batch class.
Public void execute(SchedulableContext scontext){
sendAutomaticNotifications sAutomatic = new sendAutomaticNotifications('SMS',null,null,null,null);
DataBase.executeBatch(sAutomatic,50);
}
}