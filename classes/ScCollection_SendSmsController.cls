// ----------------------------------------------------------------------------------------------------
// This class would be used to handle all functionality for sending manual sms from service console
// ----------------------------------------------------------------------------------------------------
// Created Date: 21-JAN-2017    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestSendSmsController  
// ----------------------------------------------------------------------------------------------------
public class ScCollection_SendSmsController
{ 
    //variable declaration for the data to be populated on page    
    public String strContractId {get;set;}
    public String strSelectedParty {get;set;}
    public String strSelectedOption {get;set;}
    public String strSelectedAction {get;set;}
    public String strName {get;set;}
    public String strMobileNo {get;set;}
    public String strPrefMethod {get;set;}
    public String strPrefTime {get;set;}
    public String strMessage {get;set;}
    public String strSelectedPartyId = '';
    public String strSelectedTemplate {get;set;}
    public String strSelectedLetter {get;set;}
    public String strPreviewContent {get;set;}
    public String strPdfContent {get;set;}
    public String strTabId {get;set;}
    
    public Boolean showSmsOption {get;set;}
    public Boolean showEmailOption {get;set;}
    public Boolean showLetterOption {get;set;}
    public Boolean showSendSms {get;set;}
    public Boolean showPreviewLetter {get;set;}
    public Boolean showParagraphs {get;set;}
    public Boolean showMobileError {get;set;}
    public Boolean showHardshipError {get;set;}
    public Boolean showPreviewWindow {get;set;}
    public Boolean showLetterSent {get;set;}
    
    public boolean showLetterError {get;set;}            
    public String strObjectName = '';
    
    public static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    public static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
    public static final String VAR_CONTRACTSETTING_API = 'ScCollection_ContractSettings__c';
    public static final String VAR_CONTRACTSTATUS_API = 'collect__Contract_Status__c';
    public Map<Id,Sobject> mapResult = new Map<Id,Sobject>();
    
    public static final String VAR_NONE = '--None--';
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    
    public List<SelectOption> options {get;set;} 
    public List<SelectOption> letteroptions {get;set;} 
    public Map<Id,collect__Contact_Preference__c> mapPartyToPreference {get;set;}
    public Map<Id,ScCollection_Letter_Template__c> mapLetterToParagraph {get;set;}
    public Map<Id,String> mapPartyToName;
    public Map<Id,clcommon__Party__c> mapPartyData;
    public Boolean checkLetterExecution {get;set;}
    //constructor for variable initialization
    public ScCollection_SendSmsController()
    {
        strContractId = '';
        strSelectedOption = '';
        strSelectedTemplate = '';  
        showLetterSent = false;
        
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id')))
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
            
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            
            Initialize();
            
            Set<Id> setcontractid = new Set<Id>();
            setcontractid.add(strContractId);
            
            //call api method of cls to get current open contract record
            mapResult = api.getContracts(setcontractid);
        }
        
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('tabid')))
        {
           strTabId = ApexPages.currentPage().getParameters().get('tabid'); 
        }
        
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('lettersent')))
        {
            if(ApexPages.currentPage().getParameters().get('lettersent') == '1')
            {
                showLetterSent = true;
            }
        }
        
        checkLetterExecution = ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Enable_Letter_Functionality');
    }

    public void Initialize()
    {
        strSelectedParty = '';
        strSelectedAction = '';
        strSelectedLetter = '';
        strPreviewContent = '';
        strPdfContent = '';
        strName = '';
        strMobileNo = '';
        strPrefMethod = '';
        strPrefTime = '';
        strMessage = '';
        showSmsOption = false;
        showEmailOption = false;
        showLetterOption = false;
        showSendSms = false;
        showPreviewLetter = false;
        showParagraphs = false;
        showMobileError = false;
        showHardshipError = false;
        showPreviewWindow = false;
        showLetterSent = false;
        
        options = new List<SelectOption>();
        letteroptions = new List<SelectOption>();
        mapPartyToPreference = new Map<Id,collect__Contact_Preference__c>();
        mapLetterToParagraph = new Map<Id,ScCollection_Letter_Template__c>();
        mapPartyToName = new Map<Id,String>();
        mapPartyData = new Map<Id,clcommon__Party__c>();
    }
    
    //method to get the list of actions on the basis of source system
    public List<SelectOption> getTemplateName()
    { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',VAR_NONE));
        
        for(ScCollection_Log_Template__c obj : [select Id, 
                                                       ScCollection_Template_Name__c, 
                                                       ScCollection_Source_System__r.Name
                                                       from ScCollection_Log_Template__c
                                                       where ScCollection_Is_Active__c = true 
                                                       and RecordType.DeveloperName = 'ScCollection_Manual_SMS'
                                                       ORDER BY ScCollection_Template_Name__c ASC])
        {   
            String strname = obj.ScCollection_Template_Name__c + ' (' + obj.ScCollection_Source_System__r.Name + ')';     
            options.add(new SelectOption(obj.Id, strname));
        }
        
        return options;  
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the logic for template change on vf page
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 21-SEP-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void changeTemplate()
    {
        strMessage = '';

        if(ScCollection_UtilityHandler.isNotNull(strSelectedTemplate))
        {
            List<ScCollection_Log_Template__c> lsttemplate = [select ScCollection_Description__c from ScCollection_Log_Template__c where Id =: strSelectedTemplate AND ScCollection_Is_Active__c = true];

            if(ScCollection_UtilityHandler.isNotNull(lsttemplate))
            {
                strMessage = lsttemplate[0].ScCollection_Description__c;
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for sending sms
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 07-NOV-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public PageReference SubmitSmsData()
    {
        if(ScCollection_UtilityHandler.isNotNull(strSelectedParty) && ScCollection_UtilityHandler.isNotNull(strMessage))
        {
            List<smagicinteract__smsmagic__c> lstSms = new List<smagicinteract__smsmagic__c>();
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('CollectionSenderId');
            
            if(objSetting != Null)
            {   
                cnotify__Delivery_Detail__c objdetail = new cnotify__Delivery_Detail__c();
                    
                if(strObjectName == VAR_PLCONTRACT_API)
                {
                     loan__Loan_Account__c objcnt = (loan__Loan_Account__c)mapResult.get(strContractId);
                     objdetail.cnotify__Account__c = objcnt.loan__Account__c;
                     objdetail.cnotify__Contact__c = objcnt.loan__Contact__c;
                }
                else if(strObjectName == VAR_CLCONTRACT_API)
                {
                    if(ScCollection_UtilityHandler.isNotNull(strSelectedPartyId) && mapPartyData.containsKey(strSelectedPartyId) && mapPartyData.get(strSelectedPartyId) != Null)
                    {
                        objdetail.cnotify__Account__c = mapPartyData.get(strSelectedPartyId).clcommon__Account__c;
                        objdetail.cnotify__Contact__c = mapPartyData.get(strSelectedPartyId).clcommon__Contact__c;
                    }
                }
                    
                objdetail.cnotify__Contract_Id__c = strContractId;
                objdetail.cnotify__Message__c = strMessage;
                objdetail.ScCollection_Communication_Type__c = 'Message';
                objdetail.ScCollection_Is_Manual__c = true;
                    
                insert objdetail;
                    
                String senderId = objSetting.senderId__c;
                    
                smagicinteract__smsMagic__c objsms = new smagicinteract__smsMagic__c();
                objsms.smagicinteract__SenderId__c = senderId;
                objsms.smagicinteract__PhoneNumber__c = strMobileNo;
                objsms.smagicinteract__Name__c = strName; // records name
                objsms.smagicinteract__ObjectType__c = 'Mobile'; // record type
                objsms.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
                objsms.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                objsms.smagicinteract__SMSText__c = strMessage;
                objsms.ScCollection_Delivery_Detail__c = objdetail.Id;
                lstSms.add(objsms);
                    
                try
                {
                    Database.insert(lstSms,false);
                    
                    PageReference pr = new PageReference('/apex/ScCollection_CreateInteractionLog?id=' + strContractId + '&smssent=1&tabid=' + strTabId);
                    pr.setRedirect(true);
                    return pr;
                }
                catch(Exception e)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error in sending sms : ' + e.getMessage());
                    ApexPages.addMessage(myMsg);
                    return null;    
                }                        
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Sender ID not found in custom settings.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Required_Field_Error));
            return Null;
        }
        
        return Null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for letter preview
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 21-FEB-2017    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void SubmitLetterPreview()
    {
        showPreviewWindow = false;
        strPreviewContent = '';
        strPdfContent = '';
        showLetterError = false;
        if(strSelectedLetter != '' && strSelectedLetter != '--None--')
        {
            List<Attachment> lstAtt = [select Id, Body from Attachment where ParentId =: strSelectedLetter limit 1];
            
            if(lstAtt != Null && lstAtt.size() > 0)
            {
                strPreviewContent = EncodingUtil.base64Decode(EncodingUtil.base64Encode(lstAtt[0].Body)).toString();
                
                if(mapLetterToParagraph != Null && mapLetterToParagraph.containsKey(strSelectedLetter) && mapLetterToParagraph.get(strSelectedLetter) != Null)
                {
                    ScCollection_Letter_Template__c objtemp = mapLetterToParagraph.get(strSelectedLetter);
                    
                    if(strObjectName == VAR_PLCONTRACT_API && strContractId != '')
                    {
                        loan__Loan_Account__c objcnt = (loan__Loan_Account__c)mapResult.get(strContractId);
                        strPreviewContent = ScCollection_CommonCodeHandler.ProcessLetterXml(strPreviewContent, objtemp, objcnt, null, 'preview');
                    }
                    else if(strObjectName == VAR_CLCONTRACT_API && strContractId != '')
                    {
                        collect__Loan_Account__c objcnt = (collect__Loan_Account__c)mapResult.get(strContractId);
                        strPreviewContent = ScCollection_CommonCodeHandler.ProcessLetterXml(strPreviewContent, objtemp, objcnt, strSelectedParty, 'preview');   
                    }
                                        
                    if(objtemp.Template_Paragraphs__r != Null && objtemp.Template_Paragraphs__r.size() > 0)
                    {
                        String paraxml = '';
                        
                        for(ScCollection_Paragraph_Config__c obj : objtemp.Template_Paragraphs__r)    
                        {
                            paraxml += '<' + obj.ScCollection_Paragraph_Id__c + '>' + obj.ScCollection_Selected__c + '</' + obj.ScCollection_Paragraph_Id__c + '>';
                        }
                        
                        strPreviewContent = strPreviewContent.replace('{bulletpoints}',paraxml);
                    }
                    
                    ScCollection_ApiResponse objresponse = new ScCollection_ApiResponse();
                    ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
                    List<ScCollection_ApiResponse.Messages> lstMsgs = new List<ScCollection_ApiResponse.Messages>();
                    
                    objresponse = ScCollection_CommonCodeHandler.SendLetter(strPreviewContent, 'preview');
                    objApiResponse = objResponse.APIStatus;
                    
                    if(objApiResponse != Null)
                    {
                        if(objApiResponse.Status == 'PREVIEWSUCCESS')
                        {
                            strPdfContent = objApiResponse.Description;
                            showPreviewWindow = true;
                        }
                        else
                        {
                            lstMsgs = objApiResponse.Messages;
                            
                            for(ScCollection_ApiResponse.Messages obj : lstMsgs)
                            {
                                system.debug(obj.MessageDescription);
                                strPdfContent += obj.MessageDescription;
                                showLetterError = true;
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for sending final letter to user
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 20-FEB-2017    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public PageReference SubmitLetterData()
    {
        if(strPreviewContent != Null)
        {
            strPreviewContent = ScCollection_CommonCodeHandler.ProcessLetterXml(strPreviewContent, null, null, null, 'archive');  
              
            ScCollection_ApiResponse objresponse = new ScCollection_ApiResponse();
            ScCollection_ApiResponse.APIStatus objApiResponse = new ScCollection_ApiResponse.APIStatus();
            List<ScCollection_ApiResponse.Messages> lstMsgs = new List<ScCollection_ApiResponse.Messages>();
            
            objresponse = ScCollection_CommonCodeHandler.SendLetter(strPreviewContent, 'archive');
            objApiResponse = objResponse.APIStatus;
            
            if(objApiResponse != Null)
            {
                if(objApiResponse.Status == 'ARCHIVESUCCESS')
                {
                    String uniqueId = strPreviewContent.substringBetween('<LEADID>','</LEADID>');
                    
                    if(uniqueId != Null)
                    {
                        cnotify__Delivery_Detail__c objdetail = new cnotify__Delivery_Detail__c();
                        
                        if(strObjectName == VAR_PLCONTRACT_API)
                        {
                             loan__Loan_Account__c objcnt = (loan__Loan_Account__c)mapResult.get(strContractId);
                             objdetail.cnotify__Account__c = objcnt.loan__Account__c;
                             objdetail.cnotify__Contact__c = objcnt.loan__Contact__c;
                        }
                        else if(strObjectName == VAR_CLCONTRACT_API)
                        {
                            if(ScCollection_UtilityHandler.isNotNull(strSelectedParty) && mapPartyData.containsKey(strSelectedParty) && mapPartyData.get(strSelectedParty) != Null)
                            {
                                objdetail.cnotify__Account__c = mapPartyData.get(strSelectedParty).clcommon__Account__c;
                                objdetail.cnotify__Contact__c = mapPartyData.get(strSelectedParty).clcommon__Contact__c;
                            }
                        }
                            
                        objdetail.cnotify__Contract_Id__c = strContractId;
                        objdetail.ScCollection_Communication_Type__c = 'Letter';
                        objdetail.ScCollection_Is_Manual__c = true;
                        objdetail.ScCollection_Letter_Key__c = uniqueId;
                        objdetail.cnotify__Sent__c = true;
                        objdetail.cnotify__Sent_Date__c = System.Now();
                        
                        if(mapLetterToParagraph != Null && mapLetterToParagraph.containsKey(strSelectedLetter) && mapLetterToParagraph.get(strSelectedLetter) != Null)
                        {
                            objdetail.cnotify__Subject__c = mapLetterToParagraph.get(strSelectedLetter).Letter_Unique_Name__c;
                        }
                        
                        insert objdetail;
                        
                        PageReference pr = new PageReference('/apex/ScCollection_CommunicationCenter?id=' + strContractId + '&lettersent=1&tabid=' + strTabId);
                        pr.setRedirect(true);
                        return pr;
                    }
                }
                else
                {
                    lstMsgs = objApiResponse.Messages;
                    String message = '';
                    
                    for(ScCollection_ApiResponse.Messages obj : lstMsgs)
                    {
                        message += obj.MessageDescription;    
                    }
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + message);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }
        }
        
        return Null;
    }
    
    public void ClosePopUp()
    {
        showPreviewWindow = false;
        strPreviewContent = '';
        strPdfContent = '';
    }
    
    public void selectParty()
    {
        strName = '';
        strMobileNo = '';
        strPrefMethod = '';
        strPrefTime = '';
        showSendSms = false;
        showMobileError = false;
        
        if(ScCollection_UtilityHandler.isNotNull(strSelectedParty))
        {
            List<String> lststr = strSelectedParty.split(':');
            strSelectedPartyId = lststr[0];
            
            if(ScCollection_UtilityHandler.isNotNull(lststr[1]) && lststr[1] != 'null')
            {
                strMobileNo = lststr[1].removeStart('61 - ');
                showSendSms = true;
            }
            else
            {
                showMobileError = true;
                return;
            }
                
            if(ScCollection_UtilityHandler.isNotNull(strSelectedPartyId) && mapPartyToName.containsKey(strSelectedPartyId) && mapPartyToName.get(strSelectedPartyId) != Null)
            {
                strName = mapPartyToName.get(strSelectedPartyId);
            }
            else
            {
                strName = 'NA';
            }
                
            if(mapPartyToPreference.containsKey(strSelectedPartyId) && mapPartyToPreference.get(strSelectedPartyId) != Null)
            {
                if(mapPartyToPreference.get(strSelectedPartyId).collect__Mode_of_Communication__c != Null)
                {
                    strPrefMethod = mapPartyToPreference.get(strSelectedPartyId).collect__Mode_of_Communication__c;
                }
                else
                {
                    strPrefMethod = 'NA';
                }
                 
                if(mapPartyToPreference.get(strSelectedPartyId).collect__Start_Time__c != Null && mapPartyToPreference.get(strSelectedPartyId).collect__End_Time__c != Null)
                {
                    strPrefTime = mapPartyToPreference.get(strSelectedPartyId).collect__Start_Time__c.format('hh:mm a') + ' - ' + mapPartyToPreference.get(strSelectedPartyId).collect__End_Time__c.format('hh:mm a');
                        
                    if(mapPartyToPreference.get(strSelectedPartyId).collect__Time_Zone__c != Null)
                    {
                        strPrefTime += ' (' + mapPartyToPreference.get(strSelectedPartyId).collect__Time_Zone__c + ')';    
                    }
                }
                else
                {
                    strPrefTime = 'NA';
                }
            }
            else
            {
                strPrefMethod = 'NA';
                strPrefTime = 'NA';
            }
        }
    }
    
    public void selectLetter()
    {
        showPreviewLetter = false;
        showHardshipError = false;
        showParagraphs = false;
        showLetterError = false;
        if(strSelectedLetter != '' && strSelectedLetter != '--None--')
        {
            List<ScCollection_Hardship__c> lstHardship = [select Id from ScCollection_Hardship__c where ScCollection_Contract__c =: strContractId OR scCollection_Loan_Account__c =: strContractId ORDER BY LastModifiedDate Desc limit 1];
            
            if(lstHardship != Null && lstHardship.size() > 0)
            {
                showPreviewLetter = true;
                
                if(mapLetterToParagraph != Null && mapLetterToParagraph.containsKey(strSelectedLetter) && mapLetterToParagraph.get(strSelectedLetter) != Null)
                {
                    ScCollection_Letter_Template__c objtemp = mapLetterToParagraph.get(strSelectedLetter);
                    
                    if(objtemp.Template_Paragraphs__r != Null && objtemp.Template_Paragraphs__r.size() > 0)
                    {
                        showParagraphs = true;
                    }
                }
            }
            else
            {
                showHardshipError = true;
            }
        }
    }
    
    public void selectOption()
    {
        Initialize();
        
        if(strSelectedOption != '')
        {
            if(strSelectedOption == 'sms')
            {
                showSmsOption = true;
                
                options.add(new SelectOption('',VAR_NONE));
        
                if(strObjectName == VAR_PLCONTRACT_API && strContractId != '')
                {
                     loan__Loan_Account__c objcnt = (loan__Loan_Account__c)mapResult.get(strContractId);
                     options.add(new SelectOption(objcnt.Id + ':' + objcnt.ScCollection_Customer_Contact_No__c, objcnt.ScCollection_Customer_Name__c + ' (Primary Borrower)'));
                     mapPartyToName.put(objcnt.Id,objcnt.ScCollection_Customer_Name__c);
                }
                else if(strObjectName == VAR_CLCONTRACT_API && strContractId != '')
                {
                    for(clcommon__Party__c objparty : [select Id, clcommon__isPrimary__c, ScCollection_Customer_Name__c, clcommon__Account__c, clcommon__Account__r.isPersonAccount, clcommon__Account__r.PersonMobilePhone, clcommon__Contact__c, clcommon__Contact__r.MobilePhone, clcommon__Type__r.Name, (select collect__Start_Time__c, collect__End_Time__c, collect__Time_Zone__c, collect__Mode_of_Communication__c from collect__Contact_Preferences__r where collect__Preferred__c = true) from clcommon__Party__c where ScCollection_Active__c = true AND collect__CL_Contract__c =: strContractId])
                    {
                        String customerContactNo = (objparty.clcommon__Account__c != Null && objparty.clcommon__Account__r.isPersonAccount) ? objparty.clcommon__Account__r.PersonMobilePhone : objparty.clcommon__Contact__r.MobilePhone;
                        
                        if(objparty.clcommon__isPrimary__c)
                        {
                            options.add(new SelectOption(objparty.Id + ':' + customerContactNo, objparty.ScCollection_Customer_Name__c + ' (' + objparty.clcommon__Type__r.Name + ') (P)'));                        
                        }
                        else
                        {
                            options.add(new SelectOption(objparty.Id + ':' + customerContactNo, objparty.ScCollection_Customer_Name__c + ' (' + objparty.clcommon__Type__r.Name + ')'));
                        }
                        
                        mapPartyToName.put(objparty.Id,objparty.ScCollection_Customer_Name__c);
                        mapPartyData.put(objparty.Id,objparty);
                        
                        for(collect__Contact_Preference__c objcp : objparty.collect__Contact_Preferences__r)
                        {
                            mapPartyToPreference.put(objparty.Id, objcp);
                        }
                    }
                }
            }    
            else if(strSelectedOption == 'email')
            {
                showEmailOption = true;
            }
            else if(strSelectedOption == 'letter')
            {
                showLetterOption = true;
                
                options.add(new SelectOption('',VAR_NONE));
                letteroptions.add(new SelectOption('--None--',VAR_NONE));
                
                if(strObjectName == VAR_PLCONTRACT_API && strContractId != '')
                {
                    for(ScCollection_Letter_Template__c obj : [select Id, 
                                                                      ScCollection_Aggregator_Name__c,
                                                                      ScCollection_Application__c,
                                                                      ScCollection_Country_Code__c,
                                                                      ScCollection_Letter_Type__c,
                                                                      ScCollection_Letter_Sub_Type__c,
                                                                      ScCollection_Process__c,
                                                                      ScCollection_Signatory__c,
                                                                      ScCollection_Signatory_Name__c,
                                                                      ScCollection_Source_System__r.Name,
                                                                      Letter_Unique_Name__c,
                                                                      ScCollection_Category__c,
                                                                      (select ScCollection_Sequence__c,
                                                                      ScCollection_Selected__c,
                                                                      ScCollection_Paragraph_Id__c,
                                                                      ScCollection_Paragraph__c from Template_Paragraphs__r ORDER BY ScCollection_Sequence__c ASC)
                                                                      from ScCollection_Letter_Template__c
                                                                      where ScCollection_Is_Active__c = true
                                                                      and RecordType.DeveloperName = 'ScCollection_Hardship'
                                                                      ORDER BY Letter_Unique_Name__c ASC])
                    {
                        if(obj.ScCollection_Source_System__r.Name == 'CL Loan')
                        {
                            mapLetterToParagraph.put(obj.Id, obj);
                            letteroptions.add(new selectOption(obj.Id, obj.Letter_Unique_Name__c));
                        }
                    } 
                    
                    loan__Loan_Account__c objcnt = (loan__Loan_Account__c)mapResult.get(strContractId);
                    options.add(new SelectOption(objcnt.Id, objcnt.ScCollection_Customer_Name__c + ' (Primary Borrower)'));
                    //mapPartyToName.put(objcnt.Id,objcnt.ScCollection_Customer_Name__c);
                }
                else if(strObjectName == VAR_CLCONTRACT_API && strContractId != '')
                {
                    collect__Loan_Account__c objcnt = (collect__Loan_Account__c)mapResult.get(strContractId);
                    
                    for(clcommon__Party__c objparty : [select Id, clcommon__isPrimary__c, ScCollection_Customer_Name__c, clcommon__Account__c, clcommon__Contact__c, clcommon__Type__r.Name from clcommon__Party__c where ScCollection_Active__c = true AND collect__CL_Contract__c =: strContractId])
                    {
                        if(objparty.clcommon__isPrimary__c)
                        {
                            options.add(new SelectOption(objparty.Id, objparty.ScCollection_Customer_Name__c + ' (' + objparty.clcommon__Type__r.Name + ') (P)'));
                        }
                        else
                        {
                            options.add(new SelectOption(objparty.Id, objparty.ScCollection_Customer_Name__c + ' (' + objparty.clcommon__Type__r.Name + ')'));
                        }
                        
                        mapPartyData.put(objparty.Id,objparty);
                    }
                    
                    for(ScCollection_Letter_Template__c obj : [select Id, 
                                                                      ScCollection_Aggregator_Name__c,
                                                                      ScCollection_Application__c,
                                                                      ScCollection_Country_Code__c,
                                                                      ScCollection_Letter_Type__c,
                                                                      ScCollection_Letter_Sub_Type__c,
                                                                      ScCollection_Process__c,
                                                                      ScCollection_Signatory__c,
                                                                      ScCollection_Signatory_Name__c,
                                                                      ScCollection_Source_System__r.Name,
                                                                      Letter_Unique_Name__c,
                                                                      ScCollection_Category__c,
                                                                      (select ScCollection_Sequence__c,
                                                                      ScCollection_Selected__c,
                                                                      ScCollection_Paragraph_Id__c,
                                                                      ScCollection_Paragraph__c from Template_Paragraphs__r ORDER BY ScCollection_Sequence__c ASC)
                                                                      from ScCollection_Letter_Template__c
                                                                      where ScCollection_Is_Active__c = true
                                                                      and RecordType.DeveloperName = 'ScCollection_Hardship'
                                                                      ORDER BY Letter_Unique_Name__c ASC])
                    {
                        if(obj.ScCollection_Source_System__r.Name == objcnt.ScCollection_Source_System_Name__c)
                        {
                            mapLetterToParagraph.put(obj.Id, obj);
                            letteroptions.add(new selectOption(obj.Id, obj.Letter_Unique_Name__c));
                        }
                    } 
                }
            }
        }
    }
}