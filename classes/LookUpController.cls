/*------------------------------------------------------------
Author:        Varun Arora
Name:          AssociateSMS 
Company:       Saasfocus
Description:   This Class is use as the handler for the Lightning 
               Lookup component.
History
Date    :  18/05/2017     
------------------------------------------------------------*/
public class LookUpController {


    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          fetchAccount
    Company:       Saasfocus
    Description:   Fetching the Account record depending upon the keyword dynamically.
    Inputs:        List <CustomWrapp>
    Returns:       String
    -----------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List <CustomWrapp> fetchAccount(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List <CustomWrapp> returnList = new List <CustomWrapp> ();
        List < Contact> lstOfAccount = [select id, Name,mobilePhone from contact where Name LIKE: searchKey Limit 20];
        CustomWrapp wrapp;
        for (contact acc: lstOfAccount) {
            wrapp = new CustomWrapp();
            wrapp.Id=acc.id;
            wrapp.Name=acc.name;
            if(acc.mobilePhone != null){
                if(String.valueof(acc.mobilePhone).substring(0,1)=='6' && String.valueof(acc.mobilePhone).substring(1,2)=='1'){
                    wrapp.mobilePhone='0'+String.valueof(acc.mobilePhone).substring(2,String.valueof(acc.mobilePhone).length());
                }
                else{
                    wrapp.mobilePhone = acc.mobilePhone;
                }
            }
            
            wrapp.sobjecttype='Contact';
            returnList.add(wrapp);
        }system.debug(returnList);
        return returnList;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          fetchLead
    Company:       Saasfocus
    Description:   Fetching the Lead record depending upon the search keyword dynamically.
    Inputs:        List <CustomWrapp>
    Returns:       String
    -----------------------------------------------------------------------------------*/
    @AuraEnabled
    Public static List<CustomWrapp> fetchLead(String searchKeyWord){

        String searchKey = searchKeyWord + '%';
        List <CustomWrapp> returnList = new List <CustomWrapp> ();
        List <Lead> lstOfLead = [select id,Name,Phone,MobilePhone from Lead where FirstName LIKE: searchKey and isconverted=False Limit 20];
        CustomWrapp wrapp;
        for (Lead led: lstOfLead) {
            wrapp = new CustomWrapp();
            wrapp.Id=led.id;
            wrapp.Name=led.name;
            wrapp.mobilePhone=led.MobilePhone;
            wrapp.sobjecttype='Lead';
            returnList.add(wrapp);
        }
        return returnList;
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          fetchParty
    Company:       Saasfocus
    Description:   Fetching the Party record depending upon the SearchKeyWord dynamically.
    Inputs:        List <CustomWrapp>
    Returns:       String
    -----------------------------------------------------------------------------------*/
    
    @AuraEnabled
    Public static List<CustomWrapp> fetchParty(String searchKeyWord){
        String searchKey = searchKeyWord + '%';
        List <CustomWrapp> returnList = new List <CustomWrapp> ();
        List <Party__c> partyList = [select id,CRM_Name__c,CRM_Phone__c,CRM_Email__c from Party__c where CRM_Name__c LIKE: searchKey Limit 20];
        CustomWrapp wrapp;
        for (Party__c pty: partyList){
            wrapp = new CustomWrapp();
            wrapp.Id=pty.id;
            wrapp.Name=pty.CRM_Name__c;
            wrapp.mobilePhone=pty.CRM_Phone__c;
            wrapp.sobjecttype='Party__c';
            returnList.add(wrapp);
        }
        return returnList;
    }
    
    
    /*----------------------------------------------------------------------------------
    Author:        Varun Arora
    Name:          fetchPersonAccount
    Company:       Saasfocus
    Description:   Fetching the PersonAccount record depending upon the searchKeyword dynamically.
    Inputs:        List <CustomWrapp>
    Returns:       String
    -----------------------------------------------------------------------------------*/
    
    @AuraEnabled
    Public static List<CustomWrapp> fetchPersonAccount(String searchKeyWord){
        String searchKey = searchKeyWord + '%';
        List <CustomWrapp> returnList = new List <CustomWrapp> ();
        List <Account> partyList = [select id,name,Personmobilephone,personemail from Account  where isPersonAccount=True and name LIKE: searchKey Limit 20];
        CustomWrapp wrapp;
        for (Account pty: partyList){
            wrapp = new CustomWrapp();
            wrapp.Id=pty.id;
            wrapp.Name=pty.name;
            wrapp.mobilePhone=pty.Personmobilephone;
            wrapp.sobjecttype='Account';
            returnList.add(wrapp);
        }
        
        return returnList;
    }

}