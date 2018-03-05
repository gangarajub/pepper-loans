public class EmailUtil {
    
    
    
    public static void sendEmail(Contact c,boolean referral,String loanAccountId) {  
        
        pepPepperCustomSetting__c pepCustomValues = pepPepperCustomSetting__c.getInstance();
        PepperEmailTemplates__c pepCustomTemplate = PepperEmailTemplates__c.getInstance();
        OrgWideEmailAddress[] owe = [SELECT ID,IsAllowAllProfiles,DisplayName,Address 
                                     FROM OrgWideEmailAddress WHERE IsAllowAllProfiles = TRUE and DisplayName=:pepCustomValues.displayname__c LIMIT 1];
        EmailTemplate et; 
        
        
        
        if(referral==true){
            if(pepCustomTemplate.referral_email_template__c!=null){
                et = [SELECT Id, Subject, Body FROM EmailTemplate WHERE developername =:pepCustomTemplate.referral_email_template__c  LIMIT 1];
            }
            
        }else{
            if(pepCustomTemplate.welcome_email_template__c!=null){
                et = [SELECT Id, Subject, Body FROM EmailTemplate WHERE developername =:pepCustomTemplate.welcome_email_template__c  LIMIT 1];
            }
        } 
       
        
        
       
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(et.Id!=null){
            mail.setTemplateID(et.Id);    
        }
         
        mail.setSaveAsActivity(false);
        if (owe.size() > 0 && owe.get(0).Id!=null) {
            mail.setOrgWideEmailAddressId(owe.get(0).Id);
        }
        
        if(pepCustomValues.replyemailId__c!=null){
            mail.setReplyTo(pepCustomValues.replyemailId__c);   
        }
        if(c.Id!=null){
            mail.setTargetObjectId(c.Id); 
        }
        
        if(loanAccountId!=null){
            mail.setWhatId(loanAccountId);
        }
        allmsg.add(mail);
        System.debug(LoggingLevel.ERROR, 'mail : '+ mail);
        Messaging.SendEmailResult[] results=Messaging.sendEmail(allmsg,false);  
       
    }
    
    public static void sendEmailByTemplate(Contact c,String loanAccountId,String templateName) {  
        
        pepPepperCustomSetting__c pepCustomValues = pepPepperCustomSetting__c.getInstance();
        
        OrgWideEmailAddress[] owe = [SELECT ID,IsAllowAllProfiles,DisplayName,Address 
                                     FROM OrgWideEmailAddress WHERE IsAllowAllProfiles = TRUE and DisplayName=:pepCustomValues.displayname__c LIMIT 1];
        EmailTemplate et; 
        
        
        et = [SELECT Id, Subject, Body FROM EmailTemplate WHERE developername =:templateName  LIMIT 1];
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(et.Id!=null){
            mail.setTemplateID(et.Id);    
        }
         
        mail.setSaveAsActivity(false);
        if (owe.size() > 0 && owe.get(0).Id!=null) {
            mail.setOrgWideEmailAddressId(owe.get(0).Id);
        }
        
        if(pepCustomValues.replyemailId__c!=null){
            mail.setReplyTo(pepCustomValues.replyemailId__c);   
        }
        if(c.Id!=null){
            mail.setTargetObjectId(c.Id); 
        }
        
        if(loanAccountId!=null){
            mail.setWhatId(loanAccountId);
        }
        allmsg.add(mail);
        System.debug(LoggingLevel.ERROR, 'mail : '+ mail);
        Messaging.sendEmail(allmsg,false);    
        
    }
    
    
    
}