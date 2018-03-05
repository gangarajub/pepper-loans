//  -------------------------------------------------------------------------------------------------------
//  This class handles the logic of sending a manual email to paf customer from a button on party
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 01-FEB-2017          Created By: Pawan Mudgal         Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : pafss_TestSendNewUserEmailController
//  -------------------------------------------------------------------------------------------------------
global class pafss_SendNewUserEmailController
{
    webService static String sendNewUserEmail(Id RecordId) 
    {      
        String result = '';
        Map<Id,clcommon__Party__c> mapPartyIdToPartyRecord = new Map<Id,clcommon__Party__c>();
                
        OrgWideEmailAddress owa = [select Id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Pepper Money'];
        pepPepperCustomSetting__c plCustomSetting = pepPepperCustomSetting__c.getOrgDefaults();
        EmailTemplate NewUserTemplateId = [Select Id, Subject, HtmlValue from EmailTemplate where DeveloperName = 'pafss_Existing_Customer_New_to_Portal'];
        List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
                
        String encryptedId = '';
        
        clcommon__Party__c obj = [select Id, 
                                 ScCollection_Customer_Email__c, 
                                 ScCollection_Customer_Name__c,
                                 ScCollection_User_Name__c   
                                 from clcommon__Party__c 
                                 where Id = : RecordId];
        
        encryptedId = pepEncryptDecryptData.EncryptData(obj.Id);
                    
        clcommon__Party__c objparty = new clcommon__Party__c(Id = obj.Id);
        objparty.pafss_Encrypted_Id__c = encryptedId;
        objparty.pafss_New_User_Email_Sent_DateTime__c = System.Now();
        mapPartyIdToPartyRecord.put(obj.Id,objparty);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            
        List<String> sendTo = new List<String>();
        sendTo.add(obj.ScCollection_Customer_Email__c);
        mail.setToAddresses(sendTo);
                                
        mail.setOrgWideEmailAddressId(owa.Id);
        mail.setSubject(NewUserTemplateId.Subject);
        String body = NewUserTemplateId.HtmlValue;
        body = body.replace('{!loan__Loan_Account__c.Account_Name__c}',obj.ScCollection_Customer_Name__c);
        body = body.replace('{!loan__Loan_Account__c.pepUser_Name__c}',obj.ScCollection_User_Name__c);
        body = body.replace('{!pafss_Encrypted_Id__c}',encryptedId);
        
        if(plCustomSetting.pepCall__c != Null)
        {
            body = body.replace('{!$Setup.pepPepperCustomSetting__c.pepCall__c}',plCustomSetting.pepCall__c);
        }
        else
        {
            body = body.replace('{!$Setup.pepPepperCustomSetting__c.pepCall__c}','');
        }
        //Added by : Sushant Kumar (embeded sendToEmail)   
        if(!sendTo.isEmpty())
            body = body.replace('{!sendToEmail}', pepEncryptDecryptData.EncryptData(sendTo[0]));
        
        mail.setHtmlBody(body);
        lstEmails.add(mail);
                
        if(mapPartyIdToPartyRecord != Null && mapPartyIdToPartyRecord.size() > 0)
        {
            try
            {
                update(mapPartyIdToPartyRecord.values());
                
                if(lstEmails != Null && lstEmails.size() > 0)
                {
                    try
                    {
                        Messaging.sendEmail(lstEmails);
                        result = 'Email Sent Successfully.';
                    }
                    catch(Exception e)
                    {
                        system.debug('Error : ' + e.getMessage());
                        result = 'Error : ' + e.getMessage();
                    }
                }
            }
            catch(Exception e)
            {
                system.debug('Error : ' + e.getMessage());
                result = 'Error : ' + e.getMessage();
            }
        }
    
        return result;
    }
}