global class MortgageChatterNotification implements Schedulable,  Database.AllowsCallouts 
{
    global void execute(SchedulableContext sc) 
    {
        ChatterNotification.SendNotification(ChatterNotification.DashBoardType.Mortgage);
    }
}