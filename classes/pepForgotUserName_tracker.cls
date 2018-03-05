@isTest(Seealldata=false) private class pepForgotUserName_tracker{


    @isTest static void Test0(){
        UserRole portalRole1;
        user objuser1;
        Contact objContact1;
        
        pepCmsPage__c objPage1;
        pepCmsSection__c objSection1;
        pepCmsQuestion__c objQuest1;
        Account objAccount1;
        portalRole1 = [Select Id From UserRole Where Name = 'Senior Credit Assessor' Limit 1];
        User usr1 =[Select id from user where id=:userinfo.getuserid()];
        usr1.UserRoleId = portalRole1.id;
        update usr1;
        User usr = new User();
        system.runas(usr1)     
        {
        objPage1 = pepCommonTrackerController.createPage('Forgot UserID');
        objSection1 = new pepCmsSection__c();
        objSection1 = pepCommonTrackerController.createSection1(objPage1);
        objSection1.pepSectionUniqueName__c = 'Forgot userId section 3';
        objSection1.pepSectionBodyRich__c='test story';
        update objSection1;
        objQuest1 = pepCommonTrackerController.createCmsQuestion(objPage1,objSection1);
        
        
        
        objAccount1= new Account();
        objAccount1.LastName = 'Last';
        objAccount1.FirstName ='First';
        objAccount1.PersonEmail ='test@email.com';
        objAccount1.PersonBirthDate = date.parse(System.today().format());
        objAccount1.PersonMobilePhone = '0434567890';
        objAccount1.RecordTypeid=[Select id from RecordType where SobjectType='Account' and IsPersonType=True  limit 1].id;
        insert objAccount1;
        User thisUser = [select Id from User where Profile.Name='System Administrator' and isActive=true and userroleid != null order by createdDate ASC Limit 1];
        objAccount1.ownerid=thisUser.id;
        update objAccount1;
       
        contact c = [select id from contact where accountid =: objAccount1.id];
        
        id f = [select id from folder where name = 'Pepper' limit 1].id;
       // EmailTemplate e = new EmailTemplate (Name = 'Send Username email',DeveloperName = 'unique_name',folderid=f,TemplateType= 'Text'); 
       // insert e;
        
       // EmailTemplate e = new EmailTemplate (developerName = 'Send_Username_email', FolderId = f, TemplateType= 'Text', Name = 'Send Username email');
       // insert e;
        
        Account a = new account();
        a.name='test';
        insert a;
        
        objContact1 = new Contact(); 
        objContact1.LastName ='test';
        objContact1.accountId = a.id;
        insert objContact1;
        
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner','Custom Customer Community Login user', 'PowerCustomerSuccess',   'CustomerSuccess'};
        Profile p =[select Id,name from Profile where name in :customerUserTypes limit 1];
       // pepCommonTrackerController.createRoleAndProfile();
        objuser1 = new User();
        objUser1.profileId = p.id;
        objuser1.userName ='newUser@yahoo.com';
        objUser1.email ='amit@test.com';
        objUser1.emailencodingkey ='UTF-8';
        objUser1.localesidkey ='en_US';
        objUser1.languagelocalekey ='en_US';
        objUser1.timezonesidkey ='America/Los_Angeles';
        objUser1.alias ='ak';
        objUser1.lastname ='kumar';
        objUser1.contactid =c.id;
        insert objUser1;
        
        pepPepperCustomSetting__c o = new pepPepperCustomSetting__c(pepCall__c='1300 659 430');
        insert o;
        
       // objuser = pepCommonTrackerController.createUser1();
        }
        
         system.runas(objUser1)     
        {  
        pepForgotUserName objForgUser = new pepForgotUserName();
        objForgUser.email='test@email.com';
        objForgUser.dob=(System.today()+1).format();
        objForgUser.checkUserName();
        
        pepForgotUserName objForgUser1 = new pepForgotUserName();
        objForgUser1.email='test@email.com';
        objForgUser1.dob=(System.today()).format();
        objForgUser1.checkUserName();
        
    }
    }



}