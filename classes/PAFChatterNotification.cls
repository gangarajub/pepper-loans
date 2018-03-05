global class PAFChatterNotification implements Schedulable,  Database.AllowsCallouts 
{
    global void execute(SchedulableContext sc) 
    {
        ChatterNotification.SendNotification(ChatterNotification.DashBoardType.PAF);
    }
}