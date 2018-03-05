//  -------------------------------------------------------------------------------------------------------
//  This class handles all the trigger events on clcommon__Party__c Object for PAF Self Service Project
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 09-JAN-2017   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
//  Test Class : pafss_TestPartyHandler
//  -------------------------------------------------------------------------------------------------------
public class pafss_PartyHandler 
{
    public Id strBorrowerId;
    
    public pafss_PartyHandler()
    {
        strBorrowerId = Null;
        
        for(clcommon__Party_Type__c objPT : [select Id from clcommon__Party_Type__c where Name = 'Primary Borrower' limit 1])
        {
            strBorrowerId = objPT.Id;
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before insert events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 09-JAN-2017   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeInsert(List<clcommon__Party__c> lstNew)
    {
        
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after insert events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 09-JAN-2017   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<clcommon__Party__c> lstNew)
    {
        Set<Id> setPartyIds = new Set<Id>();
        
        for(clcommon__Party__c obj : lstNew)
        {            
            if(obj.clcommon__Type__c != Null && obj.clcommon__Account__c != Null && obj.collect__CL_Contract__c != Null && obj.ScCollection_Customer_Email__c != Null && obj.ScCollection_Customer_Birth_Date__c != Null && obj.ScCollection_Customer_Post_Code__c != Null && obj.ScCollection_Contract_Source_System__c == 'PAF' && obj.pafss_Is_Person_Account__c)
            {
                setPartyIds.add(obj.Id);
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(setPartyIds))
        {
            sendUserCreationEmails(setPartyIds);
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before update events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 09-JAN-2017   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeUpdate(List<clcommon__Party__c> lstNew, Map<Id,clcommon__Party__c> mapOld)
    {
        
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(List<clcommon__Party__c> lstNew, Map<Id,clcommon__Party__c> mapOld)
    {
        Set<Id> setPartyIds = new Set<Id>();
        Date startDate = Date.newInstance(2017,1,30);
        
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.clcommon__Type__c != Null && obj.clcommon__Account__c != Null && obj.collect__CL_Contract__c != Null && obj.ScCollection_Customer_Email__c != Null && obj.ScCollection_Customer_Birth_Date__c != Null && obj.ScCollection_Customer_Post_Code__c != Null && obj.ScCollection_Contract_Source_System__c == 'PAF' && obj.pafss_Is_Person_Account__c)
            {
                if((obj.pafss_Send_PAF_Portal_Email__c == true && mapOld.get(obj.Id).pafss_Send_PAF_Portal_Email__c != true) || (obj.CreatedDate > startDate && (mapOld.get(obj.Id).clcommon__Type__c != obj.clcommon__Type__c || mapOld.get(obj.Id).clcommon__Account__c != obj.clcommon__Account__c || mapOld.get(obj.Id).collect__CL_Contract__c != obj.collect__CL_Contract__c)))
                {
                    setPartyIds.add(obj.Id);
                }
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(setPartyIds))
        {
            sendUserCreationEmails(setPartyIds);
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is used to update party object for user creation and send emails to users
    // ---------------------------------------------------------------------------------------------------
    // created Date : 09-JAN-2017   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void sendUserCreationEmails(Set<Id> setPartyIds)
    {
        Set<Id> setContractIds = new Set<Id>();
        Set<Id> SetAccountIds = new Set<Id>();
        Set<String> setDupAccountKeys = new Set<String>();
        Set<String> setNonDupAccountKeys = new Set<String>();
        List<clcommon__Party__c> lstParty = new List<clcommon__Party__c>();
        
        Map<Id,clcommon__Party__c> mapPartyIdToPartyRecord = new Map<Id,clcommon__Party__c>();
        Map<Id,Account> mapAccountIdToAccountRecord = new Map<Id,Account>();
        Map<Id,List<clcommon__Party__c>> mapContractToParty = new Map<Id,List<clcommon__Party__c>>();
        Map<String,Set<Id>> mapDuplicationKeyToAccountId = new Map<String,Set<Id>>();
        Map<String,Set<Id>> mapNonDuplicationKeyToAccountId = new Map<String,Set<Id>>();
        
        OrgWideEmailAddress owa = [select Id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Pepper Money'];
        pepPepperCustomSetting__c plCustomSetting = pepPepperCustomSetting__c.getOrgDefaults();
        EmailTemplate ExistingUserTemplateId = [Select Id, Subject, HtmlValue from EmailTemplate where DeveloperName = 'pafss_Welcome_Email_For_Existing_User'];
        EmailTemplate NewUserTemplateId = [Select Id, Subject, HtmlValue from EmailTemplate where DeveloperName = 'pafss_Welcome_Email_For_New_User_Registration'];
        EmailTemplate firstTimeTemplateId = [Select Id, Subject, HtmlValue from EmailTemplate where DeveloperName = 'Pafss_Welcome_email_for_first_time'];

        List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();
        
        String encryptedId = '';
        
        lstParty = [select Id, 
                           clcommon__Account__c, 
                           ScCollection_Customer_Email__c, 
                           collect__CL_Contract__c, 
                           ScCollection_Customer_Name__c,
                           ScCollection_User_Name__c,   
                           collect__CL_Contract__r.Name, 
                           collect__CL_Contract__r.ScCollection_Initial_Principal__c, 
                           collect__CL_Contract__r.ScCollection_Interest_Rate__c, 
                           collect__CL_Contract__r.ScCollection_Interest_Rate_Type__c, 
                           collect__CL_Contract__r.ScCollection_Loan_Term_Months__c, 
                           collect__CL_Contract__r.ScCollection_Minimum_Monthly_Installment__c, 
                           collect__CL_Contract__r.ScCollection_Account_Number__c, 
                           collect__CL_Contract__r.ScCollection_BSB_Number__c, 
                           collect__CL_Contract__r.ScCollection_Account_Name__c, 
                           collect__CL_Contract__r.pafss_Payment_Frequency__c, 
                           collect__CL_Contract__r.ScCollection_Next_Installment_Date__c, 
                           collect__CL_Contract__r.ScCollection_Account_Keeping_Fees__c,
                           pafss_Account_Duplication_Key__c, 
                           pafss_Account_Non_Duplication_Key__c, 
                           pafss_Contract_Type__c, 
                           pafss_Is_Individual_Loan__c 
                           from clcommon__Party__c 
                           where Id IN : setPartyIds];
        
        for(clcommon__Party__c obj : lstParty)
        {
            setContractIds.add(obj.collect__CL_Contract__c);
            
            if(obj.pafss_Account_Duplication_Key__c != Null)
            {
                setDupAccountKeys.add(obj.pafss_Account_Duplication_Key__c);
            }
            if(obj.pafss_Account_Non_Duplication_Key__c != Null)
            {
                setNonDupAccountKeys.add(obj.pafss_Account_Non_Duplication_Key__c);
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(setContractIds))
        {
            for(collect__Loan_Account__c obj : [select Id, (select Id, ScCollection_Customer_Name__c from collect__Parties__r where clcommon__Account__c != Null) from collect__Loan_Account__c where Id IN : setContractIds])
            {
                if(obj.collect__Parties__r != Null && obj.collect__Parties__r.size() > 0)
                {
                    mapContractToParty.put(obj.Id,obj.collect__Parties__r);
                }
            }
        }
        
        for(Account objacc : [Select Id, pafss_Duplication_Check_Key__c from Account where pafss_Duplication_Check_Key__c IN : setDupAccountKeys AND Is_Portal_User_Created__c = true])
        {
            Set<Id> lstDupAcc = new Set<Id>();
                            
            if(mapDuplicationKeyToAccountId.containsKey(objacc.pafss_Duplication_Check_Key__c) && mapDuplicationKeyToAccountId.get(objacc.pafss_Duplication_Check_Key__c) != Null)
            {
                lstDupAcc.addAll(mapDuplicationKeyToAccountId.get(objacc.pafss_Duplication_Check_Key__c));
            }
                            
            lstDupAcc.add(objacc.Id);
            
            mapDuplicationKeyToAccountId.put(objacc.pafss_Duplication_Check_Key__c, lstDupAcc);
        }
        
        for(Account objacc : [Select Id, pafss_Non_Duplication_Check_Key__c from Account where pafss_Non_Duplication_Check_Key__c IN : setNonDupAccountKeys AND Is_Portal_User_Created__c = true])
        {
            Set<Id> lstNonDupAcc = new Set<Id>();
            
            if(mapNonDuplicationKeyToAccountId.containsKey(objacc.pafss_Non_Duplication_Check_Key__c) && mapNonDuplicationKeyToAccountId.get(objacc.pafss_Non_Duplication_Check_Key__c) != Null)
            {
                lstNonDupAcc.addAll(mapNonDuplicationKeyToAccountId.get(objacc.pafss_Non_Duplication_Check_Key__c));
            }
            
            lstNonDupAcc.add(objacc.Id);
            
            mapNonDuplicationKeyToAccountId.put(objacc.pafss_Non_Duplication_Check_Key__c, lstNonDupAcc);
        }
        
        for(clcommon__Party__c obj : lstParty)
        {
            encryptedId = pepEncryptDecryptData.EncryptData(obj.Id);
            
            clcommon__Party__c objparty = new clcommon__Party__c(Id = obj.Id);
            objparty.pafss_Encrypted_Id__c = encryptedId;
            mapPartyIdToPartyRecord.put(obj.Id,objparty);
            
            Boolean isValidRecord = false;
            ScCollection_TriggerExecutionSettings__c objTriggetSetting= ScCollection_TriggerExecutionSettings__c.getValues('All Trigger Execution');
            if(obj.pafss_Contract_Type__c != Null)   
            {
                if(obj.pafss_Contract_Type__c == 'Consumer Loan')
                {
                    if(objTriggetSetting != null && obj.pafss_Is_Individual_Loan__c && objTriggetSetting.Pafss_Send_Email_Consumer_Loan__c)
                    {
                        isValidRecord = true;
                    }
                }
                else if(objTriggetSetting.Pafss_Send_Email_Commercial_Loan__c)
                {
                    isValidRecord = true;
                }
            }
            
            if(isValidRecord)
            {
                if(obj.pafss_Account_Duplication_Key__c != Null && mapDuplicationKeyToAccountId.containsKey(obj.pafss_Account_Duplication_Key__c) && mapDuplicationKeyToAccountId.get(obj.pafss_Account_Duplication_Key__c) != Null)
                {
                    if(mapPartyIdToPartyRecord.containsKey(obj.Id) && mapPartyIdToPartyRecord.get(obj.Id) != Null)
                    {
                        clcommon__Party__c objparty1 = mapPartyIdToPartyRecord.get(obj.Id);
                        objparty1.pafss_Send_PAF_Portal_Email__c = false;
                        objparty1.pafss_Existing_User_Email_Sent_DateTime__c = System.Now();
                        mapPartyIdToPartyRecord.put(obj.Id,objparty1);                            
                    }
                    else
                    {
                        clcommon__Party__c objparty1 = new clcommon__Party__c(Id = obj.Id);
                        objparty1.pafss_Send_PAF_Portal_Email__c = false;
                        objparty1.pafss_Existing_User_Email_Sent_DateTime__c = System.Now();
                        mapPartyIdToPartyRecord.put(obj.Id,objparty1);                            
                    }
                    
                    if(mapAccountIdToAccountRecord.containsKey(obj.clcommon__Account__c) && mapAccountIdToAccountRecord.get(obj.clcommon__Account__c) != Null)
                    {
                        Account objacc1 = mapAccountIdToAccountRecord.get(obj.clcommon__Account__c);
                        objacc1.Is_Portal_User_Created__c = true;
                        mapAccountIdToAccountRecord.put(obj.clcommon__Account__c,objacc1);                            
                    }
                    else
                    {
                        Account objacc1 = new Account(Id = obj.clcommon__Account__c);
                        objacc1.Is_Portal_User_Created__c = true;
                        mapAccountIdToAccountRecord.put(obj.clcommon__Account__c,objacc1);
                    }  
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    List<String> sendTo = new List<String>();
                    sendTo.add(obj.ScCollection_Customer_Email__c);
                    mail.setToAddresses(sendTo);
                    
                    mail.setOrgWideEmailAddressId(owa.Id);
                    mail.setSubject(ExistingUserTemplateId.Subject);
                    String body = ExistingUserTemplateId.HtmlValue;
                    body = body.replace('{!ScCollection_Customer_Name__c}',obj.ScCollection_Customer_Name__c);
                    body = body.replace('{!Name}',obj.collect__CL_Contract__r.Name);
                    
                    if(obj.collect__CL_Contract__r.ScCollection_Initial_Principal__c != Null)
                    {
                        body = body.replace('{!ScCollection_Initial_Principal__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Initial_Principal__c));
                    }
                    else
                    {
                        body = body.replace('{!ScCollection_Initial_Principal__c}','0.00');
                    }
                    
                    if(obj.collect__CL_Contract__r.ScCollection_Interest_Rate__c != Null)
                    {
                        body = body.replace('{!ScCollection_Interest_Rate__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Interest_Rate__c));
                    }
                    else
                    {
                        body = body.replace('{!ScCollection_Interest_Rate__c}','0.00');
                    }
                    
                    if(obj.collect__CL_Contract__r.ScCollection_Account_Keeping_Fees__c != Null)
                    {
                        body = body.replace('{!ScCollection_Account_Keeping_Fees__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Account_Keeping_Fees__c));
                    }
                    else
                    {
                        body = body.replace('{!ScCollection_Account_Keeping_Fees__c}','0.00');
                    }
                    
                    if(obj.collect__CL_Contract__r.ScCollection_Loan_Term_Months__c != Null)
                    {
                        body = body.replace('{!ScCollection_Loan_Term_Months__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Loan_Term_Months__c));
                    }
                    else
                    {
                        body = body.replace('{!ScCollection_Loan_Term_Months__c}','0');
                    }
                    
                    if(obj.collect__CL_Contract__r.ScCollection_Minimum_Monthly_Installment__c != Null)
                    {
                        body = body.replace('{!ScCollection_Minimum_Monthly_Installment__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Minimum_Monthly_Installment__c));
                    }
                    else
                    {
                        body = body.replace('{!ScCollection_Minimum_Monthly_Installment__c}','0.00');
                    }
                    
                    if(obj.collect__CL_Contract__r.pafss_Payment_Frequency__c != Null)
                    {
                        body = body.replace('{!ScCollection_Repay_Frequency__c}',obj.collect__CL_Contract__r.pafss_Payment_Frequency__c);
                    }
                    else
                    {
                        body = body.replace('{!ScCollection_Repay_Frequency__c}','Monthly');
                    }
                    
                    if(obj.collect__CL_Contract__r.ScCollection_Next_Installment_Date__c != Null)
                    {
                        body = body.replace('{!ScCollection_Next_Installment_Date__c}',obj.collect__CL_Contract__r.ScCollection_Next_Installment_Date__c.format());
                    }
                    else
                    {
                        body = body.replace('{!ScCollection_Next_Installment_Date__c}','');
                    }
                    
                    if(mapContractToParty.containsKey(obj.collect__CL_Contract__c) && mapContractToParty.get(obj.collect__CL_Contract__c) != Null)
                    {
                        String borrowertable = '<table style="width:100%" cellpadding="2" cellspacing="0" class="actualTable">';
                        borrowertable += '<tbody><tr><td style="font-weight:bold;color:#df0024;" width="40%" rowspan="' + mapContractToParty.get(obj.collect__CL_Contract__c).size() + '"><font face="\'OpenSans\', Arial, sans-serif">Borrowers</font></td><td colspan="2" style="text-align:left;border-right: 1px solid #d5d5d5;" width="60%"><font face="\'OpenSans\', Arial, sans-serif">' + obj.ScCollection_Customer_Name__c + '</font></td></tr>';
                    
                        for(clcommon__Party__c objtempparty : mapContractToParty.get(obj.collect__CL_Contract__c))
                        {
                            if(obj.Id != objtempparty.Id)
                            {
                                borrowertable += '<tr><td style="text-align:left;border-right: 1px solid #d5d5d5;"><font face="\'OpenSans\', Arial, sans-serif">' + objtempparty.ScCollection_Customer_Name__c + '</font></td></tr>';
                            }
                        }
                        
                        borrowertable += '</tbody></table>';
                        
                        body = body.replace('{!borrower_details}',borrowertable);
                    }
                    
                    mail.setHtmlBody(body);
                    lstEmails.add(mail);
                }
                else
                { 
                    if(!SetAccountIds.contains(obj.clcommon__Account__c))
                    {
                        if(mapPartyIdToPartyRecord.containsKey(obj.Id) && mapPartyIdToPartyRecord.get(obj.Id) != Null)
                        {
                            clcommon__Party__c objparty1 = mapPartyIdToPartyRecord.get(obj.Id);
                            objparty1.pafss_Send_PAF_Portal_Email__c = false;
                            objparty1.pafss_New_User_Email_Sent_DateTime__c = System.Now();
                            mapPartyIdToPartyRecord.put(obj.Id,objparty1);                            
                        }
                        else
                        {
                            clcommon__Party__c objparty1 = new clcommon__Party__c(Id = obj.Id);
                            objparty1.pafss_Send_PAF_Portal_Email__c = false;
                            objparty1.pafss_New_User_Email_Sent_DateTime__c = System.Now();
                            mapPartyIdToPartyRecord.put(obj.Id,objparty1);                            
                        }
                        
                        if(obj.pafss_Account_Non_Duplication_Key__c != Null && mapNonDuplicationKeyToAccountId.containsKey(obj.pafss_Account_Non_Duplication_Key__c) && mapNonDuplicationKeyToAccountId.get(obj.pafss_Account_Non_Duplication_Key__c) != Null)
                        {
                            if(mapAccountIdToAccountRecord.containsKey(obj.clcommon__Account__c) && mapAccountIdToAccountRecord.get(obj.clcommon__Account__c) != Null)
                            {
                                Account objacc1 = mapAccountIdToAccountRecord.get(obj.clcommon__Account__c);
                                objacc1.pafss_Has_Duplicate_Accounts__c = true;
                                objacc1.pafss_Duplicate_Account_Ids__c = String.valueof(mapNonDuplicationKeyToAccountId.get(obj.pafss_Account_Non_Duplication_Key__c));
                                mapAccountIdToAccountRecord.put(obj.clcommon__Account__c,objacc1);                            
                            }
                            else
                            {
                                Account objacc1 = new Account(Id = obj.clcommon__Account__c);
                                objacc1.pafss_Has_Duplicate_Accounts__c = true;
                                objacc1.pafss_Duplicate_Account_Ids__c = String.valueof(mapNonDuplicationKeyToAccountId.get(obj.pafss_Account_Non_Duplication_Key__c));
                                mapAccountIdToAccountRecord.put(obj.clcommon__Account__c,objacc1);
                            }  
                        }
                        
                        SetAccountIds.add(obj.clcommon__Account__c);
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                        List<String> sendTo = new List<String>();
                        sendTo.add(obj.ScCollection_Customer_Email__c);
                        mail.setToAddresses(sendTo);
                        
                        mail.setOrgWideEmailAddressId(owa.Id);
                        mail.setSubject(NewUserTemplateId.Subject);
                        String body = NewUserTemplateId.HtmlValue;
                        body = body.replace('{!ScCollection_Customer_Name__c}',obj.ScCollection_Customer_Name__c);
                        body = body.replace('{!pafss_Encrypted_Id__c}',encryptedId);
                        body = body.replace('{!ScCollection_User_Name__c}',obj.ScCollection_User_Name__c);
                        
                        mail.setHtmlBody(body);
                        lstEmails.add(mail);
                        
                        Messaging.SingleEmailMessage mailFirst = new Messaging.SingleEmailMessage();
                    
                        List<String> sendToFirst = new List<String>();
                        sendToFirst.add(obj.ScCollection_Customer_Email__c);
                        mailFirst.setToAddresses(sendToFirst);
                        
                        mailFirst.setOrgWideEmailAddressId(owa.Id);
                        mailFirst.setSubject(firstTimeTemplateId.Subject);
                        String bodyFirst = firstTimeTemplateId.HtmlValue;
                        bodyFirst = bodyFirst.replace('{!ScCollection_Customer_Name__c}',obj.ScCollection_Customer_Name__c);
                        bodyFirst = bodyFirst.replace('{!Name}',obj.collect__CL_Contract__r.Name);
                        
                        if(obj.collect__CL_Contract__r.ScCollection_Initial_Principal__c != Null)
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Initial_Principal__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Initial_Principal__c));
                        }
                        else
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Initial_Principal__c}','0.00');
                        }
                        
                        if(obj.collect__CL_Contract__r.ScCollection_Account_Keeping_Fees__c != Null)
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Account_Keeping_Fees__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Account_Keeping_Fees__c));
                        }
                        else
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Account_Keeping_Fees__c}','0.00');
                        }
                        
                        if(obj.collect__CL_Contract__r.ScCollection_Loan_Term_Months__c != Null)
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Loan_Term_Months__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Loan_Term_Months__c));
                        }
                        else
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Loan_Term_Months__c}','0');
                        }
                        
                        if(obj.collect__CL_Contract__r.ScCollection_Minimum_Monthly_Installment__c != Null)
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Minimum_Monthly_Installment__c}',String.valueOf(obj.collect__CL_Contract__r.ScCollection_Minimum_Monthly_Installment__c));
                        }
                        else
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Minimum_Monthly_Installment__c}','0.00');
                        }
                        
                        if(obj.collect__CL_Contract__r.pafss_Payment_Frequency__c != Null)
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Repay_Frequency__c}',obj.collect__CL_Contract__r.pafss_Payment_Frequency__c);
                        }
                        else
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Repay_Frequency__c}','Monthly');
                        }
                        
                        if(obj.collect__CL_Contract__r.ScCollection_Next_Installment_Date__c != Null)
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Next_Installment_Date__c}',obj.collect__CL_Contract__r.ScCollection_Next_Installment_Date__c.format());
                        }
                        else
                        {
                            bodyFirst = bodyFirst.replace('{!ScCollection_Next_Installment_Date__c}','');
                        }
                        
                        if(mapContractToParty.containsKey(obj.collect__CL_Contract__c) && mapContractToParty.get(obj.collect__CL_Contract__c) != Null)
                        {
                            String borrowertable = '<table style="width:100%" cellpadding="2" cellspacing="0" class="actualTable">';
                        borrowertable += '<tbody><tr><td style="font-weight:bold;color:#df0024;" width="40%" rowspan="' + mapContractToParty.get(obj.collect__CL_Contract__c).size() + '"><font face="\'OpenSans\', Arial, sans-serif">Borrowers</font></td><td colspan="2" style="text-align:left;border-right: 1px solid #d5d5d5;" width="60%"><font face="\'OpenSans\', Arial, sans-serif">' + obj.ScCollection_Customer_Name__c + '</font></td></tr>';
                    
                        for(clcommon__Party__c objtempparty : mapContractToParty.get(obj.collect__CL_Contract__c))
                        {
                            if(obj.Id != objtempparty.Id)
                            {
                                borrowertable += '<tr><td style="text-align:left;border-right: 1px solid #d5d5d5;"><font face="\'OpenSans\', Arial, sans-serif">' + objtempparty.ScCollection_Customer_Name__c + '</font></td></tr>';
                            }
                        }
                        
                        borrowertable += '</tbody></table>';

                            
                            bodyFirst = bodyFirst.replace('{!borrower_details}',borrowertable);
                        }
                        
                        mailFirst.setHtmlBody(bodyFirst);
                        lstEmails.add(mailFirst);
                    }
                }   
            }
        }
        
        if(mapPartyIdToPartyRecord != Null && mapPartyIdToPartyRecord.size() > 0)
        {
            try
            {
                update(mapPartyIdToPartyRecord.values());
                
                if(mapAccountIdToAccountRecord != Null && mapAccountIdToAccountRecord.size() > 0)
                {
                    try
                    {
                        update(mapAccountIdToAccountRecord.values());
                        
                        if(lstEmails != Null && lstEmails.size() > 0)
                        {
                            try
                            {
                                Messaging.sendEmail(lstEmails);
                            }
                            catch(Exception e)
                            {
                                system.debug('Error in sending paf user registration emails from future job in party trigger : ' + e.getMessage());
                            }
                        }
                    }
                    catch(Exception e)
                    {
                        system.debug('Error in updating accounts from future job in party trigger : ' + e.getMessage());
                    }
                }
                else
                {
                    if(lstEmails != Null && lstEmails.size() > 0)
                    {
                        try
                        {
                            Messaging.sendEmail(lstEmails);
                        }
                        catch(Exception e)
                        {
                            system.debug('Error in sending paf user registration emails from future job in party trigger : ' + e.getMessage());
                        }
                    }
                }
            }
            catch(Exception e)
            {
                system.debug('Error in updating party from future job in party trigger: ' + e.getMessage());
            }
        }
    }
}