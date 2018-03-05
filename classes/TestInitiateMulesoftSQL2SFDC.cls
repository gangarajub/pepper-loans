@isTest
public class TestInitiateMulesoftSQL2SFDC
{
    public static testMethod void Test1() 
    {
        Test.startTest();
        InitiateMulesoftSQL2SFDC  MuleSoft =New InitiateMulesoftSQL2SFDC ();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, MuleSoft);
        InitiateMulesoftSQL2SFDC.startMuleProcess();
        
        Test.stopTest();
        
    }
    

}