@isTest(SeeAllData=False)

private class PepUrlRewriterController_Tracker 
{
    @isTest

       static void testGenerateUrlFor() {
        PepUrlRewriterController rewriter = new PepUrlRewriterController();
         System.assert(rewriter.generateUrlFor(null) == null);
   }
  
    @isTest

    static void testMapUrl() {
 
        PepUrlRewriterController rewriter = new PepUrlRewriterController();
        pages_config__c pageConfig = new pages_config__c();
        pageConfig.name = 'pepwelcomepage';
        pageConfig.Page_Label__c = 'welcomepage';
        insert pageConfig ;
        String actualResult = String.valueof(rewriter.mapRequestUrl(new PageReference('/welcomepage')));
    } 

 @isTest

    static void testMapUrl1() {
 
        PepUrlRewriterController rewriter = new PepUrlRewriterController();
        String actualResult = String.valueof(rewriter.mapRequestUrl(new PageReference('/pepwelcomepage')));
    } 
    
     @isTest

    static void testMapUrl2() {
 
        PepUrlRewriterController rewriter = new PepUrlRewriterController();
        String actualResult = String.valueof(rewriter.mapRequestUrl(new PageReference('/apexremotewelcomepage')));
    } 

}