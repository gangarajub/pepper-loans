global class ConditionallyApproveSecApp {
    static List<genesis__Applications__c> gen = new List<genesis__Applications__c>();    
    global  ConditionallyApproveSecApp(){   }
    webService static  String statusChange(String appId){
        gen.add([select id,genesis__status__c,Is_Secured__c,is_manually_Assessed__c from genesis__Applications__c where id=:appId]);
        if(gen[0].genesis__status__c=='AWAITING ASSESSMENT' && gen[0].Is_Secured__c==true){
            gen[0].genesis__status__c='CONDITIONALLY APPROVED';
            gen[0].is_manually_Assessed__c = true;
            upsert gen;
            Boolean applyOffer = false;
            ApplicationOfferUtil util = new ApplicationOfferUtil();
            genesis__Application_Pricing_Detail__c pricingDetail = util.getUnSecuredOffer( appId, applyoffer);
            pepAssetPageEmail.sendEmail(pricingDetail.id);
            return ('Status Changed to CONDITIONALLY APPROVED');
        }
        else{
            return ('Check the status it should be AWAITING ASSESSMENT and is_secured as true'+' current status and isSecured is : '+gen[0].genesis__status__c+gen[0].Is_Secured__c);
        }
    }
}