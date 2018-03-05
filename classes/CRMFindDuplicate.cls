public Class CRMFindDuplicate{
    
    public Id LeadID {get;set;}
    public boolean ifNoMatch {get;set;}
    public Set<String> setPartyName = new set<String>();
    public Set<String> setEmailId = new Set<String>();
    public Set<String> setPhone = new Set<String>();
    public Set<String> setCompany = new Set<String>();
     public String NewCompanyName {get;set;}
    public boolean isCheckboxForBusiness {get;set;}
    public boolean isCheckboxForPerson {get;set;}
    public boolean isCheckboxForContact {get;set;}
    public boolean isCheckIfCompanyName {get;set;}
    public List<wrapBorrower> lstBorrower {get;set;}
    
    public class wrapBorrower{
        public String PartyID{get;set;}
        public String Name{get;set;}
        public String Email{get;set;}
        public String Company{get;set;}
        public String Phone {get;set;}
        public String type{get;set;}
        public boolean CreateNewPerson{get;set;}
        public Boolean CreateNewContact{get;set;}
        public Boolean CreateNewAccount{get;set;}
        public List<wrapMatchningRecord> lstMatchingRecord {get;set;}
        public List<wrapMatchningContactRecord> lstMatchingContactRecord {get;set;}
        public List<wrapMatchningBusinessAccount> lstMatchingBusinessRecord {get;set;}
        
        
        
    }
    public class wrapMatchningRecord{
        public boolean check{get;set;}
        public Id recordID{get;set;}
        public String Name{get;set;} 
        public String Phone{get;set;}
        public String Email{get;set;}
 
    }
    
     public class wrapMatchningContactRecord{
        public boolean check{get;set;}
        public Id recordID{get;set;}
        public String Name{get;set;} 
        public String Phone{get;set;}
        public String Email{get;set;}
 
    }
    
    public class wrapMatchningBusinessAccount{
        public boolean check{get;set;}
        public Id recordID{get;set;}
        public String Name{get;set;} 
        public String ContactName {get;set;}
        
 
    }
    public String theme{get;set;}
    public boolean isDesktopView {get ; set;}
    public CRMFindDuplicate(ApexPages.StandardController sc){
         theme = UserInfo.getUiTheme();
        if(theme == 'Theme3'|| theme == 'Theme4d'){
            isDesktopView = True;
        }
        else{
            isDesktopView = False;
        }
        LeadID = ApexPages.currentPage().getParameters().get('lid');
        system.debug(LeadID );
        lstBorrower =new List<wrapBorrower>();
       ifNoMatch =True;
        
       // onload();
        
    }
    
    public void onLoad(){
    
        List<Party__c> lstParty =[select id,CRM_Name__c,CRM_Email__c,CRM_Phone__c,CRM_Company__c,CRM_Type__c,CRM_Create_New_Business_Account__c,CRM_Create_New_Contact__c,CRM_Create_New_Person_Account__c,CRM_Existing_Account__c,CRM_Existing_Contact__c,Lead__c from  Party__c where Lead__c =: LeadID];
        system.debug(lstParty);
         for(Party__c objParty : lstParty){
              if(objParty.CRM_Name__c != null){
                    setPartyName.add(objParty.CRM_Name__c);                         
               } 
                if(objParty.CRM_Email__c !=null){
                    setEmailId.add(objParty.CRM_Email__c);                
               } 
                if(objParty.CRM_Phone__c != null){
                 //   setPhone.add(objParty.CRM_Phone__c);
               } 
                if(objParty.CRM_Company__c != null){
                    setCompany.add(objParty.CRM_Company__c);
                
               }               
        }
        
        List<Account> lstAccount = [select id,Name,Phone,isPersonAccount from Account where Name in : setCompany and isPersonAccount =false];
        List<Account> lstPersonAccount = [select id,Name,personEmail,Phone,PersonMobilePhone,isPersonAccount from Account where name in : setPartyName and personEmail in : setEmailId]; //and PersonMobilePhone in : setPhone
        List<Contact> lstContact = [select id,Name,Email,AccountID,Account.Name,Phone,isPersonAccount,MobilePhone from Contact where name in : setPartyName and Email in : setEmailId];   //and Phone in : setPhone
       
        Map<String,list<Account>> mapStringAccount = new Map<String,list<Account>>();
        Map<String,list<Account>> mapStringPersonAccount = new Map<String,list<Account>>();
        Map<String,list<Contact>> mapStringContact = new Map<String,list<Contact>>();
         
        if(lstAccount.Size()>0){
            for(Account objAccount : lstAccount){
                if(!String.isBlank(objAccount.Name) && objAccount.Name != null){
                    if(mapStringAccount.get(objAccount.Name.toLowerCase())==null){
                        mapStringAccount.put(objAccount.Name.toLowerCase(),new List<Account>());
                    }
                    mapStringAccount.get(objAccount.Name.toLowerCase()).add(objAccount);  
                }
                               
            }   
        }
        
        if(lstPersonAccount.Size()>0 && lstPersonAccount.Size() != null){
            for(Account objAccount : lstPersonAccount){
             if(!String.isBlank(objAccount.Name) && objAccount.Name != null && !String.isBlank(objAccount.personEmail) && objAccount.personEmail != null){  // && !String.isBlank(objAccount.PersonMobilePhone) && objAccount.PersonMobilePhone != null
                    if(mapStringPersonAccount.get(objAccount.Name.toLowerCase() + objAccount.personEmail.toLowerCase())==null){ // + objAccount.PersonMobilePhone
                        mapStringPersonAccount.put(objAccount.Name.toLowerCase() + objAccount.personEmail.toLowerCase(),new List<Account>()); // + objAccount.PersonMobilePhone
                    }
                    mapStringPersonAccount.get(objAccount.Name.toLowerCase() + objAccount.PersonEmail.toLowerCase()).add(objAccount); // + objAccount.PersonMobilePhone                
             }
             }   
        }
       Set<ID> setContactAccountID = new Set<ID>(); 
    //Adding Combination of Name and Email to Map Corresponding to List of Contact   
        if(lstContact != null && lstContact.Size()>0){
            for(Contact objContact: lstContact){
              if(!String.isBlank(objContact.Name) && objContact.Name != null && !String.isBlank(objContact.Email) && objContact.Email != null){ // && !String.isBlank(objContact.Phone) && objContact.Phone != null                
                    if(mapStringContact.get(objContact.Name.toLowerCase() + objContact.Email.toLowerCase())==null){// + objContact.Phone
                        mapStringContact.put(objContact.Name.toLowerCase() + objContact.Email.toLowerCase(),new List<Contact>()); // + objContact.Phone
                    }
                    mapStringContact.get(objContact.Name.toLowerCase() + objContact.Email.toLowerCase()).add(objContact); // + objContact.Phone  
                    if(objContact.AccountID != null){
                        setContactAccountID.add(objContact.AccountID);
                    }
              } 
            }   
                
        }
        
        List<Account> lstParentContactAccount = [select id,Name from Account where id in : setContactAccountID];
        
        
         for(Party__c objParty : lstParty){
             wrapBorrower objWrap = new wrapBorrower();
             objWrap.PartyID = objParty.Id;
             objWrap.Name = objParty.CRM_Name__c;
             objWrap.Email =objParty.CRM_Email__c;
             objWrap.Company = objParty.CRM_Company__c;
             objWrap.Phone = objParty.CRM_Phone__c;
             if(objParty.CRM_Create_New_Business_Account__c == True){
                 objWrap.CreateNewAccount = True;
             }
             else{
                 objWrap.CreateNewAccount = false;
             }
             
             if(objParty.CRM_Create_New_Contact__c == True){
                 objWrap.CreateNewContact = true;
             }
             else{
                 objWrap.CreateNewContact = false;
             }
             if(objParty.CRM_Create_New_Person_Account__c == True){
                 objWrap.CreateNewPerson = True;
             
             }
             else{
                 objWrap.CreateNewPerson = false;
             }
             objWrap.Type= objParty.CRM_Type__c;
             
            
                List<Account> lstAccountFromMap= new List<Account>();  
                List<Account> lstPersonAccountFromMap= new List<Account>();
                List<Contact> lstContactFromMap = new List<Contact>();
             if(!string.isBlank(objParty.CRM_Company__c) && objParty.CRM_Company__c != null){
                 if(mapStringAccount.ContainsKey(objParty.CRM_Company__c.toLowerCase()) && mapStringAccount.get(objParty.CRM_Company__c.toLowerCase())!= null){
                    lstAccountFromMap= mapStringAccount.get(objParty.CRM_Company__c.toLowerCase());
                }
             }                
                
             if(!string.isBlank(objParty.CRM_Name__c) && objParty.CRM_Name__c != null && !string.isBlank(objParty.CRM_Email__c) && objParty.CRM_Email__c != null)  { // && !string.isBlank(objParty.CRM_Phone__c) && objParty.CRM_Phone__c != null
                 if(mapStringPersonAccount.ContainsKey(objParty.CRM_Name__c.toLowerCase() + objParty.CRM_Email__c.toLowerCase()) && mapStringPersonAccount.get(objParty.CRM_Name__c.toLowerCase() + objParty.CRM_Email__c.toLowerCase())!= null){ // + objParty.CRM_Phone__c ''  + objParty.CRM_Phone__c
                    lstPersonAccountFromMap= mapStringPersonAccount.get(objParty.CRM_Name__c.toLowerCase() + objParty.CRM_Email__c.toLowerCase()); // + objParty.CRM_Phone__c
                }
                
                if(mapStringContact.ContainsKey(objParty.CRM_Name__c.toLowerCase() + objParty.CRM_Email__c.toLowerCase()) && mapStringContact.get(objParty.CRM_Name__c.toLowerCase() + objParty.CRM_Email__c.toLowerCase())!= null){ // + objParty.CRM_Phone__c ''  + objParty.CRM_Phone__c
                    lstContactFromMap = mapStringContact.get(objParty.CRM_Name__c.toLowerCase() + objParty.CRM_Email__c.toLowerCase()); // + objParty.CRM_Phone__c
                }
                 
             }
                 
            
            if(objParty.CRM_Type__c == 'Co Borrower')
            {   
               
               List<wrapMatchningRecord> lstDuplicate = new List<wrapMatchningRecord>();
               List<wrapMatchningContactRecord> lstDuplicateContact = new List<wrapMatchningContactRecord>();
               List<wrapMatchningBusinessAccount> lstBusinessAcc = new List<wrapMatchningBusinessAccount>();
               if(lstAccountFromMap.size()>0){ 
                    for(Account objAcc : lstAccountFromMap){
                        wrapMatchningBusinessAccount objWrapMatchingBusinessAccount = new wrapMatchningBusinessAccount();
                        
                        objWrapMatchingBusinessAccount.recordID = objAcc.id;
                        objWrapMatchingBusinessAccount.Name = objAcc.Name;
                       // objWrapMatchingBusinessAccount.Company = objAcc.Company;
                       if(objParty.CRM_Existing_Account__c == objAcc.id){
                           objWrapMatchingBusinessAccount.Check=True;
                       }
                       else{
                           objWrapMatchingBusinessAccount.Check=False;
                       }
                        
                        lstBusinessAcc.add(objWrapMatchingBusinessAccount);
                    }
                }
               
               objWrap.lstMatchingBusinessRecord = lstBusinessAcc;
               
               if(lstPersonAccountFromMap.size()>0){ 
                    for(Account objPerAcc : lstPersonAccountFromMap){
                        wrapMatchningRecord objWrapMatchingPersonAcc = new wrapMatchningRecord();
                        
                        objWrapMatchingPersonAcc.recordID = objPerAcc.id;
                        objWrapMatchingPersonAcc.Name = objPerAcc.Name;
                        objWrapMatchingPersonAcc.Email = objPerAcc.personEmail;
                        objWrapMatchingPersonAcc.Phone = objPerAcc.PersonMobilePhone;
                        
                        if(objParty.CRM_Existing_Account__c == objPerAcc.id){
                            objWrapMatchingPersonAcc.check = True;
                        }
                        else{
                            objWrapMatchingPersonAcc.check=False;
                        }
                        
                        lstDuplicate.add(objWrapMatchingPersonAcc);
                    }
               }
               
               if(lstContactFromMap.size()>0){ 
                    for(Contact objCon : lstContactFromMap){
                        wrapMatchningContactRecord objWrapMatchingContact = new wrapMatchningContactRecord();
                        
                        objWrapMatchingContact.recordID = objCon.id;
                        objWrapMatchingContact.Name = objCon.Name;
                        objWrapMatchingContact.Email = objCon.Email;
                        objWrapMatchingContact.Phone = objCon.Phone;
                        
                        if(objParty.CRM_Existing_Contact__c == objCon.id){
                            objWrapMatchingContact.check = true;
                        }
                        else{
                            objWrapMatchingContact.check = False;
                        }
                        
                        lstDuplicateContact.add(objWrapMatchingContact);
                    }
               }
               objWrap.lstMatchingContactRecord = lstDuplicateContact;
               
               objWrap.lstMatchingRecord = lstDuplicate;
               system.debug(objWrap);
               lstBorrower.add(objWrap);
               
            }
//For Guarantor --------------------------------------------------------------------------------------------------------------          
            else{
                
                List<wrapMatchningRecord> lstDuplicate = new List<wrapMatchningRecord>();
                List<wrapMatchningContactRecord> lstDuplicateContact = new List<wrapMatchningContactRecord>();
                List<wrapMatchningBusinessAccount> lstBusinessAcc = new List<wrapMatchningBusinessAccount>();
                
                if(objParty.CRM_Company__c != null){
                    if(lstAccountFromMap.size()>0){ 
                        for(Account objAcc : lstAccountFromMap){
                            wrapMatchningBusinessAccount objWrapMatchingBusinessAccount = new wrapMatchningBusinessAccount();
                            
                            objWrapMatchingBusinessAccount.recordID = objAcc.id;
                            objWrapMatchingBusinessAccount.Name = objAcc.Name;
                           // objWrapMatchingBusinessAccount.Company = objAcc.Company;
                           if(objParty.CRM_Existing_Account__c == objAcc.id){
                               objWrapMatchingBusinessAccount.Check=True;
                           }
                           else{
                               objWrapMatchingBusinessAccount.Check=False;
                           }
                            
                            lstBusinessAcc.add(objWrapMatchingBusinessAccount);
                        }
                    }
                    
                    objWrap.lstMatchingBusinessRecord = lstBusinessAcc;
                    
                    if(lstContactFromMap.size()>0){ 
                        for(Contact objCon : lstContactFromMap){
                            if(objCon.isPersonAccount != true){
                                wrapMatchningContactRecord objWrapMatchingContact = new wrapMatchningContactRecord();
                                
                                objWrapMatchingContact.recordID = objCon.id;
                                objWrapMatchingContact.Name = objCon.Name;
                                objWrapMatchingContact.Email = objCon.Email;
                                objWrapMatchingContact.Phone = objCon.Phone;
                                
                                if(objParty.CRM_Existing_Contact__c == objCon.id){
                                    objWrapMatchingContact.check = true;
                                }
                                else{
                                    objWrapMatchingContact.check = False;
                                }
                                
                                lstDuplicateContact.add(objWrapMatchingContact);
                            }
                        }
                    }
                    objWrap.lstMatchingContactRecord = lstDuplicateContact;
                    objWrap.lstMatchingRecord = lstDuplicate;
                    lstBorrower.add(objWrap);
                    
                }
                else{
                    
                    if(lstContactFromMap.size()>0){ 
                        for(Contact objCon : lstContactFromMap){
                            if(objCon.isPersonAccount != True){
                                wrapMatchningContactRecord objWrapMatchingContact = new wrapMatchningContactRecord();
                                
                                objWrapMatchingContact.recordID = objCon.id;
                                objWrapMatchingContact.Name = objCon.Name;
                                objWrapMatchingContact.Email = objCon.Email;
                                objWrapMatchingContact.Phone = objCon.Phone;
                                
                                if(objParty.CRM_Existing_Contact__c == objCon.id){
                                    objWrapMatchingContact.check = true;
                                }
                                else{
                                    objWrapMatchingContact.check = False;
                                }
                                
                                wrapMatchningBusinessAccount objWrapMatchingBusinessAccount = new wrapMatchningBusinessAccount();
                                
                                objWrapMatchingBusinessAccount.recordID = objCon.Accountid;
                                objWrapMatchingBusinessAccount.Name = objCon.Account.Name;
                                objWrapMatchingBusinessAccount.ContactName = objCon.Name;
                               // objWrapMatchingBusinessAccount.Company = objAcc.Company;
                               if(objParty.CRM_Existing_Account__c == objCon.Accountid){
                                   objWrapMatchingBusinessAccount.Check=True;
                               }
                               else{
                                   objWrapMatchingBusinessAccount.Check=False;
                               }
                                
                                
                                lstBusinessAcc.add(objWrapMatchingBusinessAccount);
                                lstDuplicateContact.add(objWrapMatchingContact);
                           }
                        }
                    }
                    objWrap.lstMatchingContactRecord = lstDuplicateContact;
                    objWrap.lstMatchingBusinessRecord = lstBusinessAcc;
                    objWrap.lstMatchingRecord = lstDuplicate;
                    lstBorrower.add(objWrap);
                }
                
                
            }           
               
               
        }
        
        
    
    }
    
//-------------------------------------------------------------------------------------------------------    
    public pageReference UpdateParty(){
    list<Party__c> lstParty = new List<Party__c>();
        for(wrapBorrower objWrap : lstBorrower ){
            isCheckboxForBusiness = False;
            isCheckboxForPerson = False;
            isCheckboxForContact = False;
            isCheckIfCompanyName = False;
            Party__c objParty = new Party__c();
            objParty.id = objWrap.PartyID;
            
            if(objWrap.Type == 'Co Borrower'){
                    if(objWrap.Company != null){  
                        if(objWrap.CreateNewContact == true || objWrap.lstMatchingContactRecord.size()==0 ){                  
                            objParty.CRM_Create_New_Contact__c = True;
                            objParty.CRM_Existing_Contact__c = null;
                            isCheckboxForContact =True;
                        }
                        else{
                            if(objWrap.lstMatchingContactRecord.size()>0){
                                for(wrapMatchningContactRecord objWrapContactRecord : objWrap.lstMatchingContactRecord){
                                
                                    if(objWrapContactRecord.check == True){
                                        
                                        objParty.CRM_Existing_Contact__c = objWrapContactRecord.recordID;
                                        objParty.CRM_Create_New_Contact__c = false;
                                        isCheckboxForContact = True;
                                        break;
                                    }                   
                                }
                                if(isCheckboxForContact == false){
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'please select create New Contact or Select Existing Contact for '+objWrap.Name));  
                                    return null;
                                }
                            }
                             
                        }
                    }  
                   
                    if(objWrap.Company == null){
                            if(objWrap.CreateNewPerson == true || objWrap.lstMatchingRecord.size()==0){
                            
                                objParty.CRM_Create_New_Person_Account__c = True;
                                objParty.CRM_Existing_Account__c = null;
                                objParty.CRM_Create_New_Business_Account__c = False;
                                objParty.CRM_Existing_Contact__c =null;
                                objParty.CRM_Create_New_Contact__c = false;
                                isCheckboxForPerson = True;
                            }
                            else{
                                if(objWrap.lstMatchingRecord !=null && objWrap.lstMatchingRecord.size()>0){
                                    for(wrapMatchningRecord objWrapPersonAccount : objWrap.lstMatchingRecord){
                                    
                                        if(objWrapPersonAccount.check == True){
                                        
                                            objParty.CRM_Existing_Account__c = objWrapPersonAccount.recordID;
                                            objParty.CRM_Create_New_Person_Account__c = false;  
                                            objParty.CRM_Create_New_Business_Account__c =False;    
                                            objParty.CRM_Existing_Contact__c =null;
                                            objParty.CRM_Create_New_Contact__c = false;                     
                                            isCheckboxForPerson = True;
                                            break;
                                        }                  
                                    }
                                    if(isCheckboxForPerson == false){
                                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'please select create New Person Account or Select Existing Account for '+objWrap.Name));  
                                        return null;
                                    }
                                }
                              
                            
                            }
                    } 
                    
                    if(objWrap.Company != null){
                            if(objWrap.CreateNewAccount == true || objWrap.lstMatchingBusinessRecord.size()==0){
                            
                                objParty.CRM_Create_New_Business_Account__c = True;
                                objParty.CRM_Existing_Account__c = null;
                                objParty.CRM_Create_New_Person_Account__c = False;
                                isCheckboxForBusiness = True;
                            }
                            else{
                                if(objWrap.lstMatchingBusinessRecord != null && objWrap.lstMatchingBusinessRecord.Size()>0){
                                    for(wrapMatchningBusinessAccount objWrapBusiness : objWrap.lstMatchingBusinessRecord){
                                    
                                        if(objWrapBusiness.check == True){
                                            objParty.CRM_Existing_Account__c = objWrapBusiness.recordID;
                                            objParty.CRM_Create_New_Business_Account__c = False;
                                            objParty.CRM_Create_New_Person_Account__c =False;
                                            isCheckboxForBusiness = true;
                                            break;
                                        }
                                        
                                    }
                                    system.debug(isCheckboxForBusiness);
                                    if(isCheckboxForBusiness == false){
                                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'please select create New Business Account or Select Existing Account for '+objWrap.Name));  
                                        return null;
                                    }
                                }
                            
                            }
                    } 
                lstParty.add(objParty);
                
            }
//For Guarantor ----------------------------------------------------------------------------------------------------            
            else{
                
                 //updating Contact ---------------------------------------------------------------------------------   
                    if(objWrap.CreateNewContact== true || objWrap.lstMatchingContactRecord.size()==0 ){                  
                        objParty.CRM_Create_New_Contact__c = True;
                        objParty.CRM_Existing_Contact__c = null;
                        isCheckboxForContact =True;
                    }
                    else{
                        if(objWrap.lstMatchingContactRecord != null && objWrap.lstMatchingContactRecord.size()>0){
                            for(wrapMatchningContactRecord objWrapContactRecord : objWrap.lstMatchingContactRecord){
                            
                                if(objWrapContactRecord.check == True){
                                    
                                    objParty.CRM_Existing_Contact__c = objWrapContactRecord.recordID;
                                    objParty.CRM_Create_New_Contact__c = false;
                                    isCheckboxForContact = True;
                                    break;
                                }                   
                            }
                            if(isCheckboxForContact == false){
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'please select create New Contact or Select Existing Contact for '+objWrap.Name));  
                                return null;
                            }
                        }
                         
                    }
                    
                    if(objWrap.Company != null){                    
                        if(objWrap.CreateNewAccount == true || objWrap.lstMatchingBusinessRecord.size()==0){
                            
                                objParty.CRM_Create_New_Business_Account__c = True;
                                objParty.CRM_Existing_Account__c = null;
                                objParty.CRM_Create_New_Person_Account__c = False;
                                isCheckboxForBusiness = True;
                        }
                        else{
                            if(objWrap.lstMatchingBusinessRecord != null && objWrap.lstMatchingBusinessRecord.Size()>0){
                                for(wrapMatchningBusinessAccount objWrapBusiness : objWrap.lstMatchingBusinessRecord){
                                
                                    if(objWrapBusiness.check == True){
                                        objParty.CRM_Existing_Account__c = objWrapBusiness.recordID;
                                        objParty.CRM_Create_New_Business_Account__c = False;
                                        objParty.CRM_Create_New_Person_Account__c =False;
                                        isCheckboxForBusiness = true;
                                        break;
                                    }
                                    
                                }
                                system.debug(isCheckboxForBusiness);
                                if(isCheckboxForBusiness == false){
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'please select create New Business Account or Select Existing Account for '+objWrap.Name));  
                                    return null;
                                }
                            }
                        
                        }
                    }
                    else{
                        
                        if(objWrap.CreateNewAccount == true || objWrap.lstMatchingBusinessRecord.size()==0){
                            system.debug('inside new Account without company ');
                            system.debug(NewCompanyName);
                            system.debug(isCheckIfCompanyName );
                                objParty.CRM_Create_New_Business_Account__c = True;
                                objParty.CRM_Existing_Account__c = null;
                                objParty.CRM_Create_New_Person_Account__c = False;
   
                                isCheckboxForBusiness = True;
                        }
                        else{
                            for(wrapMatchningBusinessAccount objWrapBusiness : objWrap.lstMatchingBusinessRecord){
                            
                                if(objWrapBusiness.check == True){
                                    objParty.CRM_Existing_Account__c = objWrapBusiness.recordID;
                                    objParty.CRM_Create_New_Business_Account__c = False;
                                    objParty.CRM_Create_New_Person_Account__c =False;
                                    isCheckboxForBusiness = true;
                                    break;
                                }
                                
                            }
                            system.debug(isCheckboxForBusiness);
                            if(isCheckboxForBusiness == false){
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'please select create New Business Account or Select Existing Account for '+objWrap.Name));  
                                return null;
                            }
                        }
                   
                    }
                lstParty.add(objParty);
                
            }       
        
        }
        
        
        if(lstParty != null && lstParty.size()>0){
            update lstParty;
        }
        
        pagereference p = new Pagereference('/'+LeadID );
        p.setRedirect(true);
        
        return p;
        
    
    }
    
    public pagereference cancel(){
        
        pagereference p = new Pagereference('/'+LeadID );
        p.setRedirect(true);
        
        return p;
    
    }
    
    
    


}