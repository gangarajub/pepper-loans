// ----------------------------------------------------------------------------------------------------
// This class would be used to handle all functionality for Send New Email page.
// ----------------------------------------------------------------------------------------------------
// Created Date: 05-APR-2017    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : CRM_Mtg_TestSendNewEmailController
// ----------------------------------------------------------------------------------------------------
public class CRM_Mtg_SendNewEmailController
{ 
    public String strSelectedTemplate {get;set;}
    public String strBaseUrl {get;set;}
    public String strFromAddress {get;set;}
    public String strSubject {get;set;}
    public String strCCAddress {get;set;}
    public String strIframeSrc {get;set;}
    public String strCaseId {get;set;}
    public String strErrorMsg {get;set;}
    public Boolean showEmailPreview {get;set;}
    public Boolean isClosed {get;set;}
    public Boolean isError {get;set;}
    public Boolean emailSent {get;set;}
    
    public List<AttachmentWrapper> lstWrapper {get;set;}
    
    public List<OrgWideEmailAddress> lstOrgAddress = new List<OrgWideEmailAddress>();
    public Map<Id,String> mapSubject = new Map<Id,String>();
    public Map<String,String> mapContent = new Map<String,String>();
    public Map<String,String> mapExtension = new Map<String,String>();
    
    public Case objcase;
    
    //constructor for variable initialization
    public CRM_Mtg_SendNewEmailController(ApexPages.StandardController controller)
    {
        strSelectedTemplate = '';
        strBaseUrl = '';
        strFromAddress = '';
        strSubject = '';
        strCCAddress = '';
        strIframeSrc = '';
        strCaseId = '';
        strErrorMsg = '';
        showEmailPreview = false;
        isClosed = false;
        isError = false;
        emailSent = false;
        
        lstWrapper = new List<AttachmentWrapper>();
        
        strBaseUrl = System.URL.getSalesforceBaseUrl().toExternalForm().replace('visual','content');    
        
        lstOrgAddress = [Select Id, DisplayName, Address from OrgWideEmailAddress where DisplayName = 'Pepper Accreditations' limit 1];
        
        if(lstOrgAddress != Null && lstOrgAddress.Size() > 0)
        {
            strFromAddress = lstOrgAddress[0].DisplayName + ' <' + lstOrgAddress[0].Address + '>';
        }
        else
        {
            isError = true;
            strErrorMsg = 'Please configure an Org Wide Email Address for Pepper Accreditations.';
        }
        
        if(ApexPages.currentPage().getParameters().get('id') != '' && ApexPages.currentPage().getParameters().get('id') != Null)
        {
            objcase = [select id, ContactId, ContactEmail, Contact.Name, Contact.CRM_Mtg_Unique_Id__c, Contact.CRM_Mtg_Unique_Id_Formula__c, CRM_Mtg_BDM_Email__c, isClosed from Case where Id =: ApexPages.currentPage().getParameters().get('id')];
            
            strCaseId = objcase.Id;
            isClosed = objcase.isClosed;
            
            if(objcase.ContactEmail == Null || objcase.ContactEmail == '')
            {
                isError = true;
                strErrorMsg = 'Please add a broker to the case for sending emails.';
            }
            
            if(objcase.CRM_Mtg_BDM_Email__c != Null)
            {
                strCCAddress = objcase.CRM_Mtg_BDM_Email__c;
            }
        }
        
        mapExtension.put('png','image/png');   
        mapExtension.put('jpg','image/jpeg');   
        mapExtension.put('jpeg','image/jpeg');   
        mapExtension.put('pdf','application/pdf');   
        mapExtension.put('xls','application/vnd.ms-excel');   
        mapExtension.put('xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');   
        mapExtension.put('ppt','application/vnd.ms-powerpoint');   
        mapExtension.put('pptx','application/vnd.openxmlformats-officedocument.presentationml.presentation');
        mapExtension.put('doc','application/msword');
        mapExtension.put('docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document');     
    }
    
    public class AttachmentWrapper
    {
        public String strFileId {get;set;}
        public String strFileName {get;set;}
        public String strFileType {get;set;}
        public String strFileSize {get;set;}
        
        public AttachmentWrapper()
        {
            strFileId = '';
            strFileName = '';
            strFileType = '';
            strFileSize = '';
        }
    }
    
    //method to get the list of actions on the basis of source system
    public List<SelectOption> getEmailTemplateList()
    { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        
        for(EmailTemplate obj : [Select Id, Name, Subject From EmailTemplate Where IsActive = true AND Folder.Name = 'CRM Mortgage User Templates' ORDER BY Name ASC])
        {   
            options.add(new SelectOption(obj.Id, obj.Name));
            mapSubject.put(obj.Id,obj.Subject);
        }
        
        for(CRM_Mtg_Email_Template_Attachments__c  obj : CRM_Mtg_Email_Template_Attachments__c.getall().values())
        {
            mapContent.put(obj.CRM_Mtg_Email_Template_Id__c.subString(0,15), obj.CRM_Mtg_Content_Document_Id__c);
        }
        
        return options;  
    }
    
    public void selectTemplate()
    {
        showEmailPreview = false;
        lstWrapper = new List<AttachmentWrapper>();
        
        if(strSelectedTemplate != '' && strSelectedTemplate != Null)
        {
            showEmailPreview = true;
            strIframeSrc = '';
            
            if(mapSubject.containsKey(strSelectedTemplate) && mapSubject.get(strSelectedTemplate) != Null)
            {
                strSubject = mapSubject.get(strSelectedTemplate);
                strSubject = strSubject.replace('{!Contact.Name}',objcase.Contact.Name);
                
                if(objcase.Contact.CRM_Mtg_Unique_Id__c != Null)
                {
                    strSubject = strSubject.replace('{!Contact.CRM_Mtg_Unique_Id_Formula__c}',String.valueof(objcase.Contact.CRM_Mtg_Unique_Id_Formula__c));
                }
                else
                {
                    strSubject = strSubject.replace('{!Contact.CRM_Mtg_Unique_Id_Formula__c}','');
                }                
            }
            
            strIframeSrc = strBaseUrl + '/email/templaterenderer?id=' + strSelectedTemplate + '&recipient_type_id=' + objcase.ContactId + '&related_to_id=' + objcase.Id + '&base_href=' + strBaseUrl + '&preview_frame=contentFrame&render_type=REPLACED_HTML_BODY';
            
            if(mapContent.containsKey(strSelectedTemplate.subString(0,15)) && mapContent.get(strSelectedTemplate.subString(0,15)) != Null)
            {
                try
                {
                    List<String> lstContentIds = mapContent.get(strSelectedTemplate.subString(0,15)).split(';');
                    
                    if(lstContentIds != Null && lstContentIds.size() > 0)
                    {
                        for(ContentVersion obj : [Select Id, Title, ContentSize, FileExtension, ContentDocumentId From ContentVersion where ContentDocumentId IN : lstContentIds AND IsLatest = true])
                        {
                            AttachmentWrapper objwrapper = new AttachmentWrapper();
                            objwrapper.strFileId = obj.ContentDocumentId;
                            objwrapper.strFileName = obj.Title;
                            objwrapper.strFileType = obj.FileExtension;
                            
                            if(obj.ContentSize < 1048576)
                            {
                                objwrapper.strFileSize = String.valueOf(obj.ContentSize/1024) + ' Kb';
                            }
                            else
                            {
                                objwrapper.strFileSize = String.valueOf(obj.ContentSize/1048576) + ' Mb';
                            }
                            
                            lstWrapper.add(objwrapper);
                        }
                    }
                }
                catch(Exception e)
                {
                    system.debug('error in fetching content : ' + e.getMessage());
                }
            }
        }
    }
    
    public void SendEmail()
    {
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{objcase.ContactEmail});
        
        if(strCCAddress != Null)
        {
            List<String> lstCC = strCCAddress.split(';');
            mail.setCcAddresses(lstCC);
        }
        
        mail.setTargetObjectId(objcase.ContactId);
        mail.setWhatId(objcase.Id);
        mail.setTemplateID(strSelectedTemplate); 
        mail.setSaveAsActivity(true);
        mail.setOrgWideEmailAddressId(lstOrgAddress[0].id);
        system.debug('==='+strSelectedTemplate);
        system.debug('}}'+mapContent);
        List<String> lstContentIds = mapContent.get(strSelectedTemplate.subString(0,15)).split(';');
                    
        if(lstContentIds != Null && lstContentIds.size() > 0)
        {
            for(ContentVersion obj : [Select Title, FileExtension, VersionData From ContentVersion where ContentDocumentId IN : lstContentIds AND IsLatest = true])
            {
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(obj.Title);
                efa.setBody(obj.VersionData);
                if(mapExtension.containsKey(obj.FileExtension) && mapExtension.get(obj.FileExtension) != Null)
                {
                    efa.contenttype = mapExtension.get(obj.FileExtension);
                }
                
                fileAttachments.add(efa);
            }
        }
        
        if(fileAttachments != Null && fileAttachments.size() > 0)
        {
            mail.setFileAttachments(fileAttachments);
        }
        
        allmsg.add(mail);
        
        try
        {
            Messaging.sendEmail(allmsg);
            strSelectedTemplate = '';
            showEmailPreview = false;
            emailSent = true;
        }
        catch(Exception e)
        {
            system.debug('Exception : ' + e.getMessage());
        }
    }
}