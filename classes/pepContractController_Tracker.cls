@isTest public class pepContractController_Tracker {
    
    
    @isTest static void pepContract_1(){
       pages_config__c pg17 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
            insert pg17;
         pepCommonTrackerController obj =new pepCommonTrackerController();
           Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
           list<pepCmsSection__c> lstSection = new list<pepCmsSection__c>();
            test.startTest();
                genesis__Applications__c objApplication = new genesis__Applications__c();
                RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
                objApplication = genesis.TestHelper.createApplication();
                objApplication.Debit_Frequency__c ='bi-weekly';
                objApplication.RedirectToContract__c = true;
                objApplication.genesis__Account__c = objAccount.id;
             //   objApplication.PepDocusignenvelopeId__c ='abcde';
                update objApplication; 
              test.stopTest();        
                
                    
                    String ID_DDP = Label.DDP_Name;
                    String ID_DOption = Label.DDP_Option;
                    
                    Loop__DDP__c objDDP = new Loop__DDP__c();
                    objDDP.name = ID_DDP;
                    insert objDDP;
                    
                    Loop__DDP_Integration_Option__c objDDPIntegration = new Loop__DDP_Integration_Option__c();
                    objDDPIntegration.name =  ID_DOption;
                    objDDPIntegration.Loop__DDP__c = objDDP.id;
                    insert objDDPIntegration;
                    
                 Pagereference pd=Page.pepContract;
                 Test.setcurrentPagereference(pd);
    
                
                 pepContractController objController = new pepContractController();
                 objController.checkcookie(); 
                 objController.saveForLater(); 
                 objController.retry();
                 
                 
       
       }       
       
    @isTest static void pepContract_2(){
       pages_config__c pg17 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
            insert pg17;
              pages_config__c pg18 = new pages_config__c(Name='pepsession',Page_Label__c='Session');
            insert pg18;
         pepCommonTrackerController obj =new pepCommonTrackerController();
           Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
           list<pepCmsSection__c> lstSection = new list<pepCmsSection__c>();
            test.startTest();

                genesis__Applications__c objApplication = new genesis__Applications__c();
                RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
                objApplication = genesis.TestHelper.createApplication();
                objApplication.Debit_Frequency__c ='bi-weekly';
                objApplication.RedirectToContract__c = true;
                objApplication.genesis__Account__c = objAccount.id;
            //    objApplication.PepDocusignenvelopeId__c ='abcde';
                update objApplication; 
            test.stopTest();          
                    Attachment attach = new Attachment();     
                    attach.Name ='Application Contract.pdf';
                    attach.ContentType = 'pdf';
                    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                    attach.body = bodyBlob;
                    attach.parentId=objApplication.id;
                    insert attach;
                
                    Drawloop_User_Setting__c  drawloopCustomSetting = new Drawloop_User_Setting__c ();  
                    drawloopCustomSetting.Name = 'DDP_User';
                    drawloopCustomSetting.Password__c = 'saasforce$6';
                    drawloopCustomSetting.Username__c = 'ddp_user@pepper.com';
                    insert drawloopCustomSetting;
                    
                    String ID_DDP = Label.DDP_Name;
                    String ID_DOption = Label.DDP_Option;
                    
                    Loop__DDP__c objDDP = new Loop__DDP__c();
                    objDDP.name = ID_DDP;
                    insert objDDP;
                    
                    Loop__DDP_Integration_Option__c objDDPIntegration = new Loop__DDP_Integration_Option__c();
                    objDDPIntegration.name =  ID_DOption;
                    objDDPIntegration.Loop__DDP__c = objDDP.id;
                    insert objDDPIntegration;
                    
                 Pagereference pd=Page.pepContract;
                 Test.setcurrentPagereference(pd);
    
                 Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
                 pd.setcookies(new cookie[]{Applicationid});
                 pepContractController objController = new pepContractController(); 
                 objController.startDDP();
                 objController.stopDDP();
                 objController.retry();
                 objController.checkcookie();
                  
    }
    
     @isTest static void pepContract_3(){
       pages_config__c pg17 = new pages_config__c(Name='pepgenericredirection',Page_Label__c='GenericRedirection');
            insert pg17;
           
         pepCommonTrackerController obj =new pepCommonTrackerController();
           Account objAccount = pepCommonTrackerController.CreateBusinessAcc();
           list<pepCmsSection__c> lstSection = new list<pepCmsSection__c>();
            test.startTest();

                genesis__Applications__c objApplication = new genesis__Applications__c();
                RetrieveCode__c objRetrieveCode = pepCommonTrackerController.createRetrieveCode();
                objApplication = genesis.TestHelper.createApplication();
                objApplication.Debit_Frequency__c ='bi-weekly';
                objApplication.RedirectToContract__c = true;
                objApplication.genesis__Account__c = objAccount.id;
                objApplication.pepNavigation_Status__c ='pepContract';
             //   objApplication.PepDocusignenvelopeId__c ='abcde';
                update objApplication; 
             test.stopTest();         
                Drawloop_User_Setting__c  drawloopCustomSetting = new Drawloop_User_Setting__c ();  
                    drawloopCustomSetting.Name = 'DDP_User';
                    drawloopCustomSetting.Password__c = 'saasforce$6';
                    drawloopCustomSetting.Username__c = 'ddp_user@pepper.com';
                    insert drawloopCustomSetting;
                    
                    String ID_DDP = Label.DDP_Name;
                    String ID_DOption = Label.DDP_Option;
                    
                    Loop__DDP__c objDDP = new Loop__DDP__c();
                    objDDP.name = ID_DDP;
                    insert objDDP;
                    
                    Loop__DDP_Integration_Option__c objDDPIntegration = new Loop__DDP_Integration_Option__c();
                    objDDPIntegration.name =  ID_DOption;
                    objDDPIntegration.Loop__DDP__c = objDDP.id;
                    insert objDDPIntegration;
                    
                 Pagereference pd=Page.pepContract;
                 Test.setcurrentPagereference(pd);
    
                 Cookie Applicationid=new Cookie('Applicationid',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.id)),'-1',null,false);
                 pd.setcookies(new cookie[]{Applicationid});
                 pepContractController objController = new pepContractController();
                 objController.saveForLater(); 
     }            
     
        
}