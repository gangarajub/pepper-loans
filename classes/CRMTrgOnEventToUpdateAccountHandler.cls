//-----------------------------------------------------------------------------------------------------
// Description : This class is for all insert and update functionalities for Event Trigger
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
// 1.0                            Sandip Bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
// 1.1                            Pawan Mudgal                  pawan.mudgal@saasfocus.com
//-----------------------------------------------------------------------------------------------------
// Test Class : CRMTrgOnEventToUpdateAccounTracker
//-----------------------------------------------------------------------------------------------------
public class CRMTrgOnEventToUpdateAccountHandler
{   
    //This method is used to update last visited datetime on account and contact record tagged to event.
    //Updates Account for CRM PAF functionality and Contact for CRM Mortgages Functionality.
    public static void updateLastVisitedDate(List<Event> lstEvent)
    {
        set<Id> setEventId = new Set<Id>();
        List<Account> lstToUpdateAccount = new List<Account>();
        List<Contact> lstToUpdateContact = new List<Contact>();
        
        //creating map of AccID to Event EndDateDate
        Map<Id,DateTime> mapAccIdToEndDate = new map<Id,DateTime>();
        Map<Id,DateTime> mapConIdToEndDate = new map<Id,DateTime>();
        Map<Id,set<Id>> mapEventIdToContactIdSet = new Map<Id,set<Id>>();
        
        String crm_admin = 'System Administrator-CRM';
        String mortgage_Profile = 'CRM Mortgage';
        String crm_Profile = 'CRM PAF';
        String profileId = UserInfo.getProfileId();
        String profileName = '';
        
        If(profileId != Null)
        {
            profileName = [Select Id, Name from Profile where Id =: profileId].Name;
        }
        
        for(Event eve : lstEvent)
        {
            if(eve.CRM_Status__c == 'Completed' && (profileName == mortgage_Profile || profileName == crm_admin))
            {
                setEventID.add(eve.Id);
            }
        }
        
        List<EventRelation> lstEveRelation = [Select Id, EventId, RelationId from EventRelation where EventId IN : setEventID];
                
        if(lstEveRelation != Null && lstEveRelation.Size() > 0)
        {
            for(EventRelation eveWho : lstEveRelation)
            {    
                if(eveWho.RelationId != null && String.valueOf(eveWho.RelationId).subString(0,3) == Contact.sobjectType.getDescribe().getKeyPrefix())
                {
                    if(mapEventIdToContactIdSet.get(eveWho.EventId) == Null)
                    {
                        mapEventIdToContactIdSet.put(eveWho.EventId,new set<Id>());
                    }
                    
                    mapEventIdToContactIdSet.get(eveWho.EventId).add(eveWho.RelationId);
                }
            }
        }
        
        for(Event eve : lstEvent)
        {    
            if(eve.WhatId != Null)
            {
                if(String.valueOf(eve.WhatId).subString(0,3) == Account.sobjectType.getDescribe().getKeyPrefix() && eve.CRM_Status__c == 'Completed' && (profileName == crm_Profile || profileName == crm_admin))
                {
                    if(mapAccIdToEndDate.get(eve.WhatId) == null)
                    {
                        mapAccIdToEndDate.put(eve.WhatId,eve.EndDateTime);
                    }
                }   
            }
            
            if(mapEventIdToContactIdSet.ContainsKey(eve.Id) && mapEventIdToContactIdSet.get(eve.Id) != null)
            {
                set<Id> setContactId = mapEventIdToContactIdSet.get(eve.Id);
                
                for(Id setConId : setContactId)
                {
                    if(mapConIdToEndDate.get(setConId) == null)
                    {
                        mapConIdToEndDate.put(setConId,eve.EndDateTime);
                    }
                }
            }
        }
        
        if(mapAccIdToEndDate.KeySet().Size() > 0)
        {
            for(Id accid : mapAccIdToEndDate.KeySet())
            {
                datetime dT = mapAccIdToEndDate.get(accid);
                Account acc = new Account();
                acc.Id = accid;
                acc.CRM_Last_Visited_Date__c = date.newinstance(dT.year(), dT.month(), dT.day());
                lstToUpdateAccount.add(acc);
            }
        }
        
        if(mapConIdToEndDate.KeySet().Size() > 0)
        {
            for(Id conid : mapConIDToEndDate.KeySet())
            {
                datetime dT = mapConIDToEndDate.get(conid);
                Contact con = new Contact();
                con.Id = conid;
                con.CRM_Mtg_Last_Visited_Date__c = date.newinstance(dT.year(),dT.month(),dT.day());
                lstToUpdateContact.add(con);
            }
        }
        
        if(lstToUpdateAccount != null && lstToUpdateAccount.size() > 0)
        {
            update lstToUpdateAccount;
        }
        
        if(lstToUpdateContact != null && lstToUpdateContact.size() > 0)
        {
            update lstToUpdateContact;
        }
    }
    
    // method to send Minutes of Meeting email to the brokers
    //build for BDM's in CRM Mortgages functionality
    public static void sendMOMEmail(List<Event> lstEvent, Map<Id, Event> mapEvent)
    {
        Set<Id> setEventId = new Set<Id>();
        Set<Id> setContactId = new Set<Id>();
        Set<Id> setUserId = new Set<Id>();
        Map<Id,Contact> mapContact = new Map<Id,Contact>();
        Map<Id,User> mapUser = new Map<Id,User>();
        
        EmailTemplate TemplateId = [Select Id, Subject, HtmlValue from EmailTemplate where DeveloperName = 'CRM_Mtg_Minutes_Email_to_Broker_Aggregator'];
        
        List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> lstEmailMessage = new List<EmailMessage>();
        List<EmailMessageRelation> lstRelation = new List<EmailMessageRelation>();
        
        for(Event eve : lstEvent)
        {
            setEventId.add(eve.Id);
                        
            if(eve.OwnerId != Null)
            {
                setUserId.add(eve.ownerId);
            }
        }
        
        if(setEventId.size() > 0)
        {
            for(EventRelation obj : [select Id, RelationId from EventRelation where EventId IN : setEventId])
            {
                if(obj.RelationId != null && String.valueOf(obj.RelationId).subString(0,3) == Contact.sobjectType.getDescribe().getKeyPrefix())
                {
                    setContactId.add(obj.RelationId);
                }
            }
        }
        
        if(setContactId.size() > 0)
        {
            for(Contact obj : [select Id, Email, FirstName, Account.CRM_Mtg_Minutes_Email_Header_Image_Url__c from Contact where Id IN : setContactId])
            {
                mapContact.put(obj.Id,obj);
            }
        }
        
        if(setUserId.size() > 0)
        {
            for(User obj : [select Id, Name, MobilePhone, Email, ManagerId, Manager.Email from User where Id IN : setUserId])
            {
                mapUser.put(obj.Id,obj);
            }
        }
                
        for(Event eve : lstEvent)
        {    
            if(eve.CRM_Mtg_Send_MoM_Email__c && eve.CRM_Status__c == 'Completed')
            {
                if(Trigger.isInsert || (Trigger.isUpdate && (mapEvent.get(eve.Id).CRM_Status__c != 'Completed' || mapEvent.get(eve.Id).CRM_Mtg_Send_MoM_Email__c != true)))
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    EmailMessage msg = New EmailMessage();
                    
                    List<String> sendTo = new List<String>();
                    List<String> ccTo = new List<String>();
                    List<String> sendToId = new List<String>();
                    
                    ccTo.add(mapUser.get(eve.ownerId).Email);
                    msg.CcAddress = mapUser.get(eve.ownerId).Email;
                    
                    if(mapUser.get(eve.ownerId).ManagerId != Null && mapUser.get(eve.ownerId).Manager.Email != Null)
                    {
                        ccTo.add(mapUser.get(eve.ownerId).Manager.Email);
                        msg.CcAddress += '; ' + mapUser.get(eve.ownerId).Manager.Email; 
                    }
                    
                    for(EventRelation obj : [select Id, RelationId from EventRelation where EventId =: eve.Id])
                    {
                        if(mapContact.containsKey(obj.RelationId) && mapContact.get(obj.RelationId) != Null)
                        {
                            if(mapContact.get(obj.RelationId).Email != Null)
                            {
                                sendTo.add(mapContact.get(obj.RelationId).Email);
                                sendToId.add(obj.RelationId); 
                            }
                        }
                    }
                    
                    mail.setToAddresses(sendTo);
                    mail.setCCAddresses(ccTo);
                    mail.setSubject(TemplateId.Subject);
                    
                    msg.ToIds = sendToId;
                    msg.Subject = TemplateId.Subject;
                    
                    String body = TemplateId.HtmlValue;
                    
                    if(mapContact.get(eve.whoId).Account.CRM_Mtg_Minutes_Email_Header_Image_Url__c != Null)
                    {
                        body = body.replace('http://pepperonline.com.au/edm/pepper_bdm_template_sf_header.jpg',mapContact.get(eve.whoId).Account.CRM_Mtg_Minutes_Email_Header_Image_Url__c);
                    }
                    
                    if(mapContact.get(eve.whoId).FirstName != Null)
                    {
                        body = body.replace('{!Contact.FirstName}',mapContact.get(eve.whoId).FirstName);
                    }
                    else
                    {
                        body = body.replace('{!Contact.FirstName}','');
                    }
                    
                    if(eve.CRM_Mtg_Meeting_Email_Body__c != Null)
                    {
                        body = body.replace('{!Event.CRM_Mtg_Meeting_Email_Body__c}',eve.CRM_Mtg_Meeting_Email_Body__c);
                    }
                    
                    String strObjective = '';
                    String strOutcome = '';
                    String strBDMName = '';
                    String strBDMMobile = '';
                    String strBDMEmail = '';
                    
                    List<String> lstObjective = new List<String>();
                    List<String> lstOutcome = new List<String>();
                        
                    if(eve.CRM_Mtg_Meeting_Objectives__c != Null)
                    {
                        lstObjective = eve.CRM_Mtg_Meeting_Objectives__c.split(';');
                    }
                    
                    if(eve.CRM_Mtg_Other_Objectives__c != Null)
                    {
                        lstObjective.add(eve.CRM_Mtg_Other_Objectives__c);
                    }
                    
                    if(lstObjective != Null && lstObjective.size() > 0)
                    {
                        strObjective = '<ul>';
                        
                        for(String obj : lstObjective)
                        {
                            if(obj != Null && obj != '')
                            {
                                strObjective += '<li>' + obj.trim() + '</li>';    
                            }
                        }
                        
                        strObjective += '</ul>';
                    }
                    
                    if(eve.CRM_Mtg_Meeting_Outcomes__c != Null)
                    {
                        strOutcome = eve.CRM_Mtg_Meeting_Outcomes__c;
                        strOutcome = strOutcome.replace('\r\n', ';;');
                        strOutcome = strOutcome.replace('\n', ';;');
                        strOutcome = strOutcome.replace('\r', ';;');
                        
                        lstOutcome = strOutcome.split(';;');
                    }
                    
                    if(lstOutcome != Null && lstOutcome.size() > 0)
                    {
                        strOutcome = '';
                        
                        for(String obj : lstOutcome)
                        {
                            if(obj != Null && obj != '')
                            {
                                strOutcome += obj.trim() + '<br>';    
                            }
                        }
                    }
                    
                    body = body.replace('{!Event.CRM_Mtg_Meeting_Objectives__c}',strObjective);
                    body = body.replace('{!Event.CRM_Mtg_Meeting_Outcomes__c}',strOutcome);
                    
                    if(mapUser.containsKey(eve.ownerId) && mapUser.get(eve.ownerId) != Null)
                    {
                        if(mapUser.get(eve.ownerId).Name != Null)
                        {
                            strBDMName = mapUser.get(eve.ownerId).Name;
                        }
                        
                        if(mapUser.get(eve.ownerId).MobilePhone != Null)
                        {
                            strBDMMobile = mapUser.get(eve.ownerId).MobilePhone;
                        }
                        
                        if(mapUser.get(eve.ownerId).Email != Null)
                        {
                            strBDMEmail = mapUser.get(eve.ownerId).Email;
                        }
                    }
                    
                    body = body.replace('{!Event.CRM_Mtg_Owner_Name__c}',strBDMName);
                    body = body.replace('{!Event.CRM_Mtg_Owner_Mobile__c}',strBDMMobile);
                    body = body.replace('{!Event.CRM_Mtg_Owner_Email__c}',strBDMEmail);
                    
                    mail.setHtmlBody(body);
                    msg.HtmlBody = body;
                    msg.FromName = strBDMName;
                    msg.FromAddress = strBDMEmail;
                    msg.MessageDate = System.Now();
                    msg.Status = '3';
                    msg.CRM_Mtg_Contact_Id__c = eve.WhoId;
                    
                    lstEmails.add(mail);
                    lstEmailMessage.add(msg);
                }
            }
        }
        
        if(lstEmails != Null && lstEmails.size() > 0)
        {
            try
            {
                Messaging.sendEmail(lstEmails);
                
                if(lstEmailMessage != Null && lstEmailMessage.size() > 0)
                {
                    insert lstEmailMessage;
                    
                    for(EmailMessage obj : lstEmailMessage)
                    {
                        EmailMessageRelation objrel = new EmailMessageRelation();
                        objrel.EmailMessageId = obj.Id;
                        objrel.RelationId = obj.CRM_Mtg_Contact_Id__c;
                        objrel.RelationType = 'ToAddress';
                        
                        lstRelation.add(objrel);
                    }
                    
                    if(lstRelation != Null && lstRelation.size() > 0)
                    {
                        insert lstRelation;
                    }
                }
            }
            catch(Exception e)
            {
                system.debug('Error in sending MoM emails : ' + e.getMessage());
            }
        }
    }
}