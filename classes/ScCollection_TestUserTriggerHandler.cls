// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_UserTriggerHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 10-OCT-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestUserTriggerHandler
{
    static testMethod void myUnitTest() 
    {  
        //Inserting Profile
        Profile p = [select Id from Profile where Name = 'System Administrator'];
        
        //Inserting User
        User u = ScCollection_CommonTrackerClass.createTestUser('testuserfortrigger@gmail.com',p.id);
        u.ScCollection_UserType__c = 'CO';
        update u;
         
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        // Insert object of collect__Queue__c
        collect__Queue__c objQue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
                       
        //Insert Queue User
        collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQue.id, u.id);
              
        inactiveTheUser(u.id);
    }       
    
    static testMethod void myUnitTest_inactivewithQueueContract() 
    {  
         //Inserting Profile
        Profile p = [select Id from Profile where Name = 'System Administrator'];
        
        //Inserting User
        User u = ScCollection_CommonTrackerClass.createTestUser('testuserfortriggerqueuecont@gmail.com',p.id);
        u.ScCollection_UserType__c = 'CO';
        update u;
         
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        // Insert object of collect__Queue__c
        collect__Queue__c objQue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
                       
        //Insert Queue User
        collect__Queue_Contract__c objQueueContract1 = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.id, Null, u.id);
              
        inactiveTheUser(u.id);
    }       
        
    @future
    public static void inactiveTheUser(id userToInactive)
    {
        User tempUser = new user(id=userToInactive);
        tempUser.isActive = false;
        
        try
        {
            update tempUser;
        }
        catch(Exception e)
        {    
        }
    }
    
    /*------------------------------------------------------------
    Author:        Mitali Telang
    Name:          ScCollection_TestUserTriggerHandler
    Company:       Pepper
    Description:   This is a test method for ScCollection_UserTriggerHandler.populateCommunityUserName
    Returns:      Void
    History
    <Date>      <Authors Name>     <Brief Description of Change>
    ------------------------------------------------------------*/
   static testmethod void communityUserInfoOnAccount()
   {
        
         
        Profile p = [select Id from Profile where Name = 'Custom Customer Community Login user'];
     //   UserRole  r = [Select Id from UserRole where developername='CEO' limit 1];
    //    User user = ScCollection_CommonTrackerClass.createTestUserRole('testuserfortrigger@gmail.com',p.id, r.Id);
     //   insert user;
        Account acc = ScCollection_CommonTrackerClass.createTestPersonAccount();
      //  acc.OwnerId = user.Id;
      //  update acc;      
        Contact con = [Select Id from Contact where AccountId =: acc.id];
        test.startTest(); 
        // Create a community user
        User u = ScCollection_CommonTrackerClass.createTestUser('testuserfortrigger@gmail.com',p.id, con.id);
        test.stopTest();
        
        Contact conResult = [Select CommunityUser__c from Contact where id =: con.id];
        //Assert to check if the user details are stamped on the Person Account / Contact record
        system.assertEquals(conResult.CommunityUser__c, u.Id);
   }
}