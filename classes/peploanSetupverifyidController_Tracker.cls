/*
This tracker class is used to reference peploanSetupverifyidController
Created By : Sudipta Samal
Created On : 22/06/2016
*/
@isTest(seeAllData = false)
public class peploanSetupverifyidController_Tracker
{
    private static genesis__Applications__c  objGenesis;
    private static Account objAccount;
    private static user objUser;
    private string siteUrl;
    public static user objUser1; 
    
    static testmethod void testVerifiedCon()
    {
        //We need to query user and run as system to avoid Mixed DML Opeartion 
        RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
        objGenesis = genesis.TestHelper.createApplication();
        pepJumio_Credentials__c objJumio = new pepJumio_Credentials__c();
        objJumio  = pepCommonTrackerController.createJumioCredential();
        
        Application__c objApp1 = new Application__c();
        objApp1=pepCommonTrackerController.createApplication();
        objApp1.Name='peploanSetupverifyid';
        objApp1.Navigation_Status__c='LoanSetup-Jumio';
        update objApp1;
        
        pages_config__c pg1 = new pages_config__c(Name='peploansetupmanualupload',Page_Label__c='loanSetupManualUpload');
        insert pg1;
        
        pages_config__c pg11 = new pages_config__c(Name='peploansetupverifyid',Page_Label__c='loansetupverifyid');
        insert pg11;
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        User us;
        
        System.runas(thisUser){
            if(userinfo.getuserroleid() == null){
            UserRole usr = new UserRole(Name='Test Record');
            insert usr;
            us = new user(id=userinfo.getuserid(),userRoleId=usr.id);
            update us;
            objUser = pepCommonTrackerController.createUser();
            }
            }
             
            //Instance of page Reference
             pagereference pd=Page.peploanSetupverifyid;
             Test.setcurrentPagereference(pd);
            
            //Set cookies 
            Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objGenesis.id)),'-1',null,false);
            pd.setcookies(new cookie[]{Applicationid});
            
        peploanSetupverifyidController objpeploanSetupverifyidController = new peploanSetupverifyidController();
        
        
        system.runas(thisuser){
       
        objpeploanSetupverifyidController.displayIframe();
        objpeploanSetupverifyidController.SaveForLater();
        objpeploanSetupverifyidController.redirect();
        objpeploanSetupverifyidController.refreshpage();
        objpeploanSetupverifyidController.checkcookie();
        
    }     
    
}
}