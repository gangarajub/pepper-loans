public class pepCmsFooterComponentController {

public pepCmsSection__c objSection { get; set; }
public string strGetPageName{get;set;}

public pepCmsFooterComponentController() {
    
    strGetPageName = 'Footer';
    DisplayFooter(strGetPageName);
    
}

      public void DisplayFooter(string strGetPageName)
    {
        objSection  = [Select id,pepSectionBodyRich__c,pepSectionUniqueName__c from pepCmsSection__c where pepPage__r.pepPageName__c =: strGetPageName limit 1];
        system.debug('objSectionSwati ' +objSection.pepSectionBodyRich__c );
        
    }
}