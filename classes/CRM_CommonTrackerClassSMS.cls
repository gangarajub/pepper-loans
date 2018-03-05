/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          CRM_CommonTrackerClassSMS 
Company:       Saasfocus
Description:   This is the common class to creaate record.
History
Date    :  29/09/2017     
------------------------------------------------------------*/
@isTest public class CRM_CommonTrackerClassSMS{
    public static Lead objLead;
    public static Party__c objParty;
    public static smagicinteract__Incoming_SMS__c objIncommingSMS;
    public static smagicinteract__smsMagic__c objSMS;
    public static Account acc;
    public static Account objAccount;
    public static Contact objContact;
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createLead
    Company:       Saasfocus
    Description:   creating Lead record
    Inputs:        
    Returns:       Lead
    -----------------------------------------------------------------------------------*/
    public static Lead createLead(){
        objLead = new Lead();
        objLead.LastName ='lastLeadName';
        objLead.Company = 'CompanyOfLead';
        objLead.CRM_Lead_Channel__c = 'Digital';
        objLead.CRM_Lead_Channel_Level_2__c = 'Email';
        objLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('PAF').getRecordTypeId();
        objLead.CRM_Status_Reason__c = 'Credit History';
        objLead.MobilePhone = '9999999999';
        insert objLead;
        return objLead;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createParty
    Company:       Saasfocus
    Description:   creating Party__c record
    Inputs:        Id
    Returns:       Party__c
    -----------------------------------------------------------------------------------*/
    public static Party__c createParty(Id leadId){
        objParty = new Party__c();
        objParty.CRM_Name__c = 'N';
        objParty.CRM_Email__c  = 'N@gmail.com';
        objParty.CRM_Phone__c  = '1111111111';
        objParty.CRM_Type__c  = 'Co Borrower';
        objParty.CRM_Company__c  = 'C';
        objParty.Lead__c  = leadId;
        objParty.CRM_Create_New_Business_Account__c = True;
        objParty.CRM_Create_New_Contact__c  = True;
        objParty.CRM_Create_New_Person_Account__c = false;
        insert objParty;
        return objParty;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createAccount
    Company:       Saasfocus
    Description:   creating Business Account record
    Inputs:        Id
    Returns:       Account
    -----------------------------------------------------------------------------------*/
    public static Account createAccount(){
        acc = new Account();
        acc.Name='WAT Automation Pty Ltd';
        insert acc;
        return acc;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createContact
    Company:       Saasfocus
    Description:   creating Contact record
    Inputs:        Id
    Returns:       Contact
    -----------------------------------------------------------------------------------*/
    public static Contact createContact(Id accountId){
        objContact = new Contact(
                            AccountId = accountId,
                            LastName = 'AutoContact kWemA27986',
                            FirstName = 'Test',
                            Email ='test@test.com',
                            MobilePhone='1234567890');

        insert objContact;
        return objContact;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createPersonAccount
    Company:       Saasfocus
    Description:   creating Person Account record
    Inputs:        
    Returns:       Account
    -----------------------------------------------------------------------------------*/
    public static Account createPersonAccount(){
        objAccount = new Account();
        objAccount.LastName='testAcc';
        objAccount.Personmobilephone = '90909090909';
        insert objAccount;
        return objAccount;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          ceateSmsHistory
    Company:       Saasfocus
    Description:   creating SMS history record
    Inputs:        Id
    Returns:       smagicinteract__smsMagic__c
    -----------------------------------------------------------------------------------*/
    public static smagicinteract__smsMagic__c ceateSmsHistory(Id leadId){
        objSMS = new smagicinteract__smsMagic__c(
                                        smagicinteract__CreatedOn__c = DateTime.newInstance(2016,4,12,12,726,43587),
                                        smagicinteract__Name__c = '0410282787',
                                        smagicinteract__ObjectType__c = 'Mobile',
                                        smagicinteract__PhoneNumber__c = '0410282787',
                                        smagicinteract__SMSText__c = 'Your Pepper verification code is:AAA16224',
                                        smagicinteract__SenderId__c = 'Pep-Code',
                                        smagicinteract__Source__c = '1150',
                                        smagicinteract__Type__c = 'Outgoing',
                                        smagicinteract__disableSMSOnTrigger__c = 0.0,
                                        smagicinteract__external_field__c = '00111122',
                                        smagicinteract__Lead__c = leadId);

        insert objSMS;
        return objSMS;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createIncomSMS
    Company:       Saasfocus
    Description:   creating Incomming SMS record
    Inputs:        Id
    Returns:       smagicinteract__Incoming_SMS__c
    -----------------------------------------------------------------------------------*/
    public static smagicinteract__Incoming_SMS__c createIncomSMS(Id leadId){
        

        
        objIncommingSMS = new smagicinteract__Incoming_SMS__c(
                                            smagicinteract__Inbound_Number__c = '919282159481',
                                            smagicinteract__Mobile_Number__c = '917875471177',
                                            smagicinteract__SMS_Text__c = 'Pepper Test incoming message from screen magic',
                                            smagicinteract__external_field__c = 'd8948729b4d03ac523245c2786911046',
                                            smagicinteract__MMS_Type__c = 'SMS',
                                            smagicinteract__Lead__c = leadId);

        insert objIncommingSMS;
        return objIncommingSMS;
    }
}