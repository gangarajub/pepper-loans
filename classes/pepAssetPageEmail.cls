public class pepAssetPageEmail
{
    public static void sendEmail(String pricingId)
    {
       if(string.isNotBlank(pricingId))
       {
          genesis__Application_Pricing_Detail__c pricingDetail= [select id,genesis__Application__c,genesis__Application__r.genesis__Contact__c
          from genesis__Application_Pricing_Detail__c where id=:pricingId];
          if(pricingDetail !=null && pricingDetail.id !=null && pricingDetail.genesis__Application__r.genesis__Contact__c !=null)
          {
             contact objContact = [select id,Email from contact where id=:pricingDetail.genesis__Application__r.genesis__Contact__c];
             EmailUtil.sendEmailByTemplate(objContact,pricingId,'Send_Email_on_Conditional_Approval');
          }
       }
    }
}