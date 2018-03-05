// --------------------------------------------------------------------------------------------------------
// This class would handle all trigger relaged operations of the User trigger
// --------------------------------------------------------------------------------------------------------
// Created Date : 06-SEPT-2016         Created By: Deepak Dhingra        Email: depak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestUserTriggerHandler
// -------------------------------------------------------------------------------------------------------- 
public  class ScCollection_UserTriggerHandler 
{ 
    //This method will handle all before insert operations 
    public void onBeforeInsert(List<user> lstNew)
    {
        List<User> lstUser = new List<User>();
        
        for(User obj : lstNew)
        {
            if(obj.CRM_Mtg_Is_Mortgage_BDM__c && obj.CRM_Mtg_Unique_Id__c == Null)
            {
                lstUser.add(obj);
            }
        }
        
        if(lstUser != Null && lstUser.size() > 0)
        {
            populateUniqueId(lstUser);
        }
    }
    
    //This method will handle all before update operations 
    public void onAfterInsert(List<user> lstNew)
    {
        populateCommunityUserName(lstNew);   

    }
    
    //This method will handle all before update operations 
    public void onBeforeUpdate(List<user> lstNew, Map<id,User> newMap, Map<id,User> oldMap)
    {
        List<User> lstUser = new List<User>();
        
        for(User obj : lstNew)
        {
            if(obj.CRM_Mtg_Is_Mortgage_BDM__c && obj.CRM_Mtg_Unique_Id__c == Null && obj.CRM_Mtg_Is_Mortgage_BDM__c != oldMap.get(obj.Id).CRM_Mtg_Is_Mortgage_BDM__c)
            {
                lstUser.add(obj);
            }
        }
        
        if(lstUser != Null && lstUser.size() > 0)
        {
            populateUniqueId(lstUser);
        }
        
        // add error if there are some still contracts assigned and an attemt has been made to deactivate the user
        addErrorToActiveContractUsers(lstNew, newMap, oldMap);
    }
    
    //This method will handle all before update operations 
    public void onAfterUpdate(List<user> lstNew, Map<id,User> newMap, Map<id,User> oldMap)
    {
        
    }
    
    //this method populates unique id on newly created user record for mortgage bdms
    public void populateUniqueId(List<User> lstUser)
    {
        Decimal maxValue = 1000;
        
        AggregateResult[] groupedResults = [select MAX(CRM_Mtg_Unique_Id__c) maxId from User where CRM_Mtg_Unique_Id__c != Null];
        
        for(AggregateResult ar : groupedResults)  
        {
            if(ar.get('maxId') != Null)
            {
                maxValue = Decimal.valueof(ar.get('maxId') + '');
            }
        }
        
        for(User obj : lstUser)
        {
            obj.CRM_Mtg_Unique_Id__c = maxValue + 1;
            maxValue += 1;
        }
    }
    
    //This method would add error to record if there are some active contracts agaisn the user
    public void addErrorToActiveContractUsers(List<user> lstNew, Map<id,User> newMap, Map<id,User> oldMap)
    {           
        // if the user is being deactivated
        Set<id> setInavtiveUsers = new Set<id>();
        Set<id> setProcessedUsers = new Set<id>();
        
        for(User tempUser : lstNew)
        {
            // if the user is made inavtive
            if((tempUser.isActive) == false && (oldMap.get(tempUser.id).isActive == true))
            {
                setInavtiveUsers.add(tempUser.id);
            }
        }

        // if we have some status and some users that have been inactivated
        if(setInavtiveUsers.size() > 0)
        {
            //look for status and error msg
            String OpenStatus = Label.ScCollection_ActiveContractsStatus; 
            String errMsg = Label.ScCollecition_UerErrMsg; 
            String errMsgQueue = Label.ScCollecition_UerErrMsgQueue;
            
            //if any of above is not there return and dont execute the process
            if(!(String.isNotEmpty(OpenStatus) && String.isNotEmpty(errMsg))) return;
            
            List<string>  lstOpenStatus  = new List<string>();
            lstOpenStatus = OpenStatus.split(';');
            
            if(lstOpenStatus.size() > 0)
            {
                // make an aggreate query on queue contract
                List<AggregateResult> groupedResults = new List<AggregateResult>();
                groupedResults = [select count(id) countofContracts,
                                         collect__User__c uid 
                                         from collect__Queue_Contract__c
                                         where collect__Status__c IN : lstOpenStatus 
                                         AND collect__User__c IN : setInavtiveUsers
                                         Group By collect__User__c];

                for (AggregateResult ar : groupedResults)  
                {
                    if((Decimal)ar.get('countofContracts') > 0)
                    {
                        newMap.get((ID)ar.get('uid')).addError(errMsg.replace('{!numberOfCont}','' + (Decimal)ar.get('countofContracts')));
                        setProcessedUsers.add((ID)ar.get('uid'));
                    }
                }
                
                if(!setProcessedUsers.containsAll(setInavtiveUsers))
                {
                    // all the users that have been inactivated look for unprocessed inactiveUsers
                    setInavtiveUsers.removeAll(setProcessedUsers);
                    
                    // look for remaning users on Queue Users
                    List<AggregateResult> groupedResultsqueue = new List<AggregateResult>();
                    groupedResultsqueue = [select count(collect__Queue__c) countofQueue,
                                                  collect__User__c uid 
                                                  from collect__Queue_User__c
                                                  where collect__User__c IN : setInavtiveUsers
                                                  Group By collect__User__c];
                                                                            
                    for (AggregateResult ar : groupedResultsqueue)  
                    {
                        if((Decimal)ar.get('countofQueue') > 0)
                        {
                            newMap.get((ID)ar.get('uid')).addError(errMsgQueue.replace('{!numOfQueue}','' + (Decimal)ar.get('countofQueue')));
                        }
                    }                                                                                
                }
            }
        }
    }
    
    /*-----------------------------------------------------------------------------
    Author:        Mitali Telang
    Name:          ScCollection_UserTriggerHandler
    Company:       Pepper
    Description:   The function will stamp the community user on the corresponding person account record.
                   This will help decide whether a community user already exists for the customer
    Inputs:        List of User 
    Returns:       void
    History
    <Date>      <Authors Name>     <Brief Description of Change>
    -----------------------------------------------------------------------------*/ 
    public void populateCommunityUserName(List<user> lstUserNew)
    {
        Id profileId = [Select Id from Profile where Name = 'Custom Customer Community Login user'].Id; // Profile Id of the Community User profile
        List<User> lstCommunityUsers = new List<User>();
        Map<Id, Contact> mapContacts;
        List<Contact> lstContactsUpdated = new List<Contact>();
        Set<Id> setContactIds = new Set<Id>();

        for(User u: lstUserNew)
        {
            // Filtering the users based on profile Ids
            if(u.ProfileId == profileId)
            {
                lstCommunityUsers.add(u);
                setContactIds.add(u.ContactId);
            }
        }

        // Quering the Contact records for the community users created.
        if(setContactIds != NULL && setContactIds.size() > 0)
        {
            mapContacts = new Map<Id, Contact>([Select Id, CommunityUser__c from Contact where Id in: setContactIds]);
        }

        // Mapping the Person Account / Contact with the associated Community User 
        if(mapContacts != NULL && mapContacts.size() > 0 && lstCommunityUsers != Null && lstCommunityUsers.size() > 0)
        {
            Contact con;
            for(User u: lstCommunityUsers)
            {
                if(mapContacts.containsKey(u.ContactId) && mapContacts.get(u.ContactId) != Null)
                {
                    con = new Contact();
                    con = mapContacts.get(u.ContactId);
                    con.CommunityUser__c = u.Id;
                    lstContactsUpdated.add(con);
                }
            }
        }

        //Updating the contacts
        if(lstContactsUpdated != null && lstContactsUpdated.size() > 0)
        {
            update lstContactsUpdated;
        }

    }
}