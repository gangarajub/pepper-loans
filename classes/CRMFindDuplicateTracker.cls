@isTest Public class CRMFindDuplicateTracker{

    @isTest Static void loadData(){
    
        Lead objLead = new Lead(LastName = 'T' , FirstName='f',Email='s@nn.com',company='c',CRM_Lead_Channel__c='Digital',CRM_Lead_Channel_Level_2__c='Email');
        insert objLead;
        
        Account acc = new Account(Name= 'testAccount');
        insert acc;
        
        Account perAcc = new Account(LastName = 'PerName' , personEmail ='per@email.com');
        insert perAcc;
        
        Contact objCon = new Contact(LastName = 'ConName' ,Accountid = acc.id , Email = 'test@email.com');
        insert objCon;
        
        
        // For CoBorrower ----Company not null  Guarantor 
        List<Party__c> lstParty = new List<Party__c>();
        Party__c objParty = new Party__c(CRM_Name__c='ConName' , CRM_Email__c = 'test@email.com' , CRM_Phone__c = '1' ,
                                      CRM_Type__c = 'Co Borrower' , CRM_Company__c = 'testAccount' , Lead__c = objLead.id,
                                      CRM_Create_New_Business_Account__c= true , CRM_Create_New_Contact__c = true);
        
        lstParty.add(objParty);     
        
        Party__c objParty7 = new Party__c(CRM_Name__c='ConName' , CRM_Email__c = 'test@email.com' , CRM_Phone__c = '1' ,
                                      CRM_Type__c = 'Co Borrower' , CRM_Company__c = 'testAccount' , Lead__c = objLead.id,
                                      CRM_Existing_Account__c = acc.id, CRM_Create_New_Contact__c = true);
        
        lstParty.add(objParty7);                          
       
       Party__c objParty8 = new Party__c(CRM_Name__c='ConName' , CRM_Email__c = 'test@email.com' , CRM_Phone__c = '1' ,
                                      CRM_Type__c = 'Co Borrower' , CRM_Company__c = 'testAccount' , Lead__c = objLead.id,
                                      CRM_Create_New_Business_Account__c= true , CRM_Existing_Contact__c = objCon.id);
        
        lstParty.add(objParty8);  
       // company ==null
        Party__c objParty1 = new Party__c(CRM_Name__c='PerName' , CRM_Email__c = 'per@email.com' , CRM_Phone__c = '2' ,
                                      CRM_Type__c = 'Co Borrower' , Lead__c = objLead.id , CRM_Create_New_Person_Account__c =true 
                                     );
        
    
        lstParty.add(objParty1);
         
        Party__c objParty11 = new Party__c(CRM_Name__c='PerName' , CRM_Email__c = 'per@email.com' , CRM_Phone__c = '2' ,
                                      CRM_Type__c = 'Co Borrower' , Lead__c = objLead.id  ,
                                       CRM_Existing_Account__c = perAcc.id);
        
        lstParty.add(objParty11);
       // company !=null
        Party__c objParty2 = new Party__c(CRM_Name__c='ConName' , CRM_Email__c = 'test@email.com' , CRM_Phone__c = '1' ,
                                      CRM_Type__c = 'Guarantor' , CRM_Company__c = 'testAccount' , Lead__c = objLead.id , 
                                      CRM_Existing_Account__c = acc.id , CRM_Existing_Contact__c = objCon.id);
        
        lstParty.add(objParty2);                              
        //company =null
        Party__c objParty3 = new Party__c(CRM_Name__c='ConName' , CRM_Email__c = 'test@email.com' , CRM_Phone__c = '1' ,
                                      CRM_Type__c = 'Guarantor' , Lead__c = objLead.id,
                                      CRM_Existing_Account__c = acc.id , CRM_Existing_Contact__c = objCon.id);
    
        lstParty.add(objParty3);
        
        Party__c objParty4 = new Party__c(CRM_Name__c='ConName' , CRM_Email__c = 'test@email.com' , CRM_Phone__c = '1' ,
                                      CRM_Type__c = 'Guarantor' , Lead__c = objLead.id,
                                      CRM_Create_New_Business_Account__c = True , CRM_Existing_Contact__c = objCon.id);
    
        lstParty.add(objParty4);
        
        Party__c objParty5 = new Party__c(CRM_Name__c='ConName' , CRM_Email__c = 'test@email.com' , CRM_Phone__c = '1' ,
                                      CRM_Type__c = 'Guarantor' , Lead__c = objLead.id,
                                      CRM_Create_New_Business_Account__c = True ,CRM_Create_New_Contact__c = true);
    
        lstParty.add(objParty5);
       
        insert lstParty;
        
        Apexpages.StandardController sc = new ApexPages.StandardController(objParty1);
         ApexPages.currentPage().getParameters().put('lid',objLead.id);
        CRMFindDuplicate objController = new CRMFindDuplicate(sc);
        objcontroller.onload();
        
        objController.UpdateParty();
        

    }



}