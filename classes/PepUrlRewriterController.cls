// ----------------------------------------------------------------------------------
//This class is used to generate friendly URL for all of the pages of Site. 
//-----------------------------------------------------------------------------------
// Version#       Date            Author                 Description
// ----------------------------------------------------------------------------------
// 1.0        1'st july 2016        Rishabh Tyagi         Initial Version
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------


global class PepUrlRewriterController implements Site.UrlRewriter
 {   
 
 // This method is used to map the friendly page name to original page name. 
 
   global PageReference mapRequestUrl(PageReference myFriendlyUrl)
    { 
        
          Set<string> pageLabels = new Set<string>();
          String  myFriendlyUrlNew=String.valueof(myFriendlyUrl);
          String redirectURL ='';
        //  system.debug('myFriendlyUrlIs'+myFriendlyUrl);
          for(pages_config__c  pgf:pages_config__c.getall().values()){
          
           pageLabels.add(pgf.name);
           }
          if(myFriendlyUrlNew.contains('/apexremote'))    // for javascript remoting method.
          {
          
              return null; 
          }
          else if(myFriendlyUrlNew.contains('pep'))       // after performing some action on same page it's return null.
          {
               return null;
          }
          else if(myFriendlyUrlNew.contains(System.label.pepCommunity_url))
          {
              return null;
              //return new Pagereference('/GenericRedirection');
          }
          else{                                          // to match friendly page name to original page name
              
                              if(myFriendlyUrlNew.contains('?') && !myFriendlyUrlNew.contains('instance'))
                              {
                                 myFriendlyUrlNew= string.valueOf(myFriendlyUrl).substringBetween('/','?');
                              }   
                              else
                              {    
                                  myFriendlyUrlNew= string.valueOf(myFriendlyUrl).substringBetween('/',']');
                              }
                              
                              list< pages_config__c> navigationSetting = pages_config__c.getall().values();       
                               for(pages_config__c navigate : navigationSetting)
                               {
                                   if(navigate.Page_Label__c==myFriendlyUrlNew)     // fetch original page name from custom setting.
                                   {
                                       redirectURL = navigate.Name;
                                       break;
                                   }
                               }
                               if(redirectURL =='') { 
                              return null;
                              }
              }
        
         return new Pagereference('/'+redirectURL);
   }
   
   // This method is used to generate friendly url for original page name.
   
          global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) 
          {
              //  system.debug('my URLs'+mySalesforceUrls);
                return mySalesforceUrls;
          }
 }