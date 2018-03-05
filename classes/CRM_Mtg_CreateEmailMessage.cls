// --------------------------------------------------------------------------------------------------------
// This class handles the logic for creating email message records for quiz email from process builder
// --------------------------------------------------------------------------------------------------------
// Created Date: 28-FEB-2017    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class :  CRM_Mtg_TestCreateEmailMessage
// --------------------------------------------------------------------------------------------------------
public class CRM_Mtg_CreateEmailMessage
{
    @InvocableMethod
    public static void CreateEmailMessageRecord(List<Id> caseIds)
    {
        if(caseIds != Null && caseIds.size() > 0)
        {
            List<Case> lstCase = [Select Id, ContactEmail, Contact.Name, Contact.FirstName from Case where Id IN : caseIds];
            List<EmailMessage> lstEmailMessage = new List<EmailMessage>();
                        
            if(lstCase != Null && lstCase.Size() > 0)
            {    
                List<EmailTemplate> lstEmailTemplate = [Select Id, Body, Subject, HtmlValue from EmailTemplate where DeveloperName = 'CRM_Mtg_Quiz_Email_to_Brokers' limit 1];
                List<OrgWideEmailAddress> lstOrgAddress = [Select Id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Pepper Accreditations' limit 1];
                
                if(lstEmailTemplate != Null && lstEmailTemplate.size() > 0 && lstOrgAddress != Null && lstOrgAddress.Size() > 0)
                {
                    for(Case objcase : lstCase)
                    {
                        EmailMessage mail = New EmailMessage();
                        mail.FromName = lstOrgAddress[0].DisplayName;
                        mail.FromAddress = lstOrgAddress[0].Address; 
                        mail.ToAddress = objcase.ContactEmail; 
                        mail.CcAddress = lstOrgAddress[0].Address; 
                        mail.Subject = lstEmailTemplate[0].Subject.replace('{!Contact.Name}',(objcase.Contact.Name != null ? String.valueof(objcase.Contact.Name) : ''));
                        mail.TextBody = lstEmailTemplate[0].Body.replace('{!Contact.FirstName}',(objcase.Contact.FirstName != null ? String.valueof(objcase.Contact.FirstName) : '')); 
                        mail.RelatedToID = objcase.Id;
                        mail.HtmlBody = lstEmailTemplate[0].HtmlValue.replace('{!Contact.FirstName}',(objcase.Contact.FirstName != null ? String.valueof(objcase.Contact.FirstName) : ''));
                        lstEmailMessage.add(mail);
                    }
                    
                    if(lstEmailMessage != null && lstEmailMessage.Size() > 0)
                    {    
                        insert lstEmailMessage;
                    }
                } 
            }
        }
    }
}