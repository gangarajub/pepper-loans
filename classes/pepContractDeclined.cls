public class pepContractDeclined 
{
    public string idApplication{get;set;}
    public pagereference pg;
    public string redirecturl{get;set;}
    Public string page_Name{get;set;}
    Public string Page_Label{get;set;}
    public pepContractDeclined ()
    {        page_Name=ApexPages.currentPage().getUrl();
             page_Name=page_Name.substring(page_Name.contains('/apex')?6:1,page_Name.contains('?')?page_Name.indexof('?'):page_Name.length());
             Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
            redirecturl=Label.Site_URL+getfriendlyurl('pepdeclinedcontract');
            Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');  
            System.debug('cookieApplicationId **************'+cookieApplicationId);      
            if (cookieApplicationId == null)
            {
                //cookieApplicationId = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
                
            }        
            else if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
            {                           
               idApplication = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
            }
            
        
    }
    Private string getfriendlyurl(String str){
    return Pages_config__c.getinstance(str).Page_Label__c;
    }
    
}