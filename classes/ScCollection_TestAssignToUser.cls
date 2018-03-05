// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_AssignToUser class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestAssignToUser 
{
    /*------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          myUnitTest
    Company:       Saasfocus
    Description:   This method is used to test the user assignment for CL and PL contract.
    Inputs:        no input.
    Returns:       void
    ------------------------------------------------------------*/
    static testMethod void myUnitTest() 
    {  
        //Inserting Profile
        Profile p = [select Id from Profile where Name = 'System Administrator'];
        
        //Inserting User
        User u = ScCollection_CommonTrackerClass.createTestUser('testuser123@pepper.com',p.id);
        u.ScCollection_UserType__c = 'CO';
        update u;
         
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        // Insert object of collect__Queue__c
        collect__Queue__c objQue = ScCollection_CommonTrackerClass.createTestQueue('Loss Recoveries');
        objQue.collect__Enabled__c= true;       
        update objQue;        
        //Insert Queue User
        collect__Queue_User__c objUser = ScCollection_CommonTrackerClass.createTestQueueUser(objQue.id, u.id);
        objUser.collect__Assignable__c = true;
        update objUser;
           
        //Insert Object of Contract
        collect__Loan_Account__c objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        
        ApexPages.currentPage().getParameters().put('Id',objContract.id);
          
        //Insert Queue Contract         
        collect__Queue_Contract__c objQueueContract = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.Id, objContract.Id, UserInfo.getUserId());
              
        //Calling Class Constructor and methods
        ScCollection_AssignToUser ObjAssignToUser = new ScCollection_AssignToUser();
        ObjAssignToUser.UserId = String.valueOf(u.id);
        ObjAssignToUser.QueueId = String.valueOf(objQue.id);
        ObjAssignToUser.createMapQueueToUserlist();
        ObjAssignToUser.UserAssignment();
        
       
        collect__Loan_Account__c objContractforAsset = [Select Id,collect__Collection_Status__r.ScCollection_IsRefered__c 
                                                   from collect__Loan_Account__c where Id=:objContract.Id];
        
                                                    
        system.assert(objContractforAsset.collect__Collection_Status__r.ScCollection_IsRefered__c==false,'worked');
        
        ObjAssignToUser.getQueue();
        ObjAssignToUser.getUsers();
        
        u.ScCollection_UserType__c = null;
        update u;
        loan__Loan_Account__c objLoan = pepCommonTrackerController.createLoanAccount();
        collect__Queue_Contract__c objQueueContract1 = ScCollection_CommonTrackerClass.createTestQueueContract(objQue.Id, objLoan.Id, UserInfo.getUserId());
        
        ApexPages.currentPage().getParameters().put('Id',objLoan.id);
        ApexPages.currentPage().getParameters().put('tabid','tabid');
        ApexPages.currentPage().getParameters().put('refresh','refresh');
        ScCollection_AssignToUser ObjAssignToUser1 = new ScCollection_AssignToUser();
        ObjAssignToUser1.UserId = String.valueOf(u.id);
        ObjAssignToUser1.QueueId = String.valueOf(objQue.id);
        ObjAssignToUser1.createMapQueueToUserlist();
        ObjAssignToUser1.UserAssignment();
        ObjAssignToUser1.getQueue();
        ObjAssignToUser1.getUsers();
        
        
        u.ScCollection_UserType__c = 'CO';
        update u;
        ObjAssignToUser1.UserAssignment();
        loan__Loan_Account__c objContractforAsset1 = [Select Id,ScCollection_Collection_Status__r.ScCollection_IsRefered__c 
                                                       from loan__Loan_Account__c where Id=:objLoan.Id];
            
                                                        
        system.assert(objContractforAsset1.ScCollection_Collection_Status__r.ScCollection_IsRefered__c==false,'worked');
        
    }       
}