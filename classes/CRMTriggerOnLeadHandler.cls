//-----------------------------------------------------------------------------------------------------
// Date        : 6/10/2016
// Description : Convert related Party record in Account and Contact when lead converts
//-----------------------------------------------------------------------------------------------------
// Version                           Author                                Email
//-----------------------------------------------------------------------------------------------------
//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
//-----------------------------------------------------------------------------------------------------
public with sharing class CRMTriggerOnLeadHandler{
	
	set<id> setLeadId = new set<id>();
	set<id> opportunityId = new set<Id>();
	public Map<id,id> mapleadIdToOppId = new Map<id,id>();
	List<Party__c> lstNewAccAndNewContact = new List<Party__c>();
	List<Party__c> lstNewAccAndExistingContact = new List<Party__c>();
	List<Party__c> lstExistingAccAndNewContact = new List<Party__c>();
	List<Party__c> lstExistingAccAndExistingContact = new List<Party__c>();  
	List<Party__c> lstNewPersonAccount = new List<Party__c>();
	List<Party__c> lstExistingPersonAccount = new List<Party__c>();
	
	List<Party__c> lstNewAccountAndContactForCompanyNull = new List<Party__c>(); 
	List<Party__c> lstNewAccountAndExistingConForCompanyNull = new List<Party__c>();
	
	List<Party__c> lstParty = new List<Party__c>();

	//-----------------------------------------------------------------------------------------------------
	// Date        : 6/10/2016
	// Description : this method is used to convert related Party Record to Account and Contact
	//-----------------------------------------------------------------------------------------------------
	// Version                           Author                                Email
	//-----------------------------------------------------------------------------------------------------
	//   1.0                            sandip bijlwan                sandip.bijlwan@saasfocus.com
	//-----------------------------------------------------------------------------------------------------

	public void PartyAfterLeadConvert(List<Lead> lstLead,map<Id,Lead> oldmap){
		 
		List<Lead> lstLeadNew = new List<Lead>();
		for(Lead l : lstLead){
	
			if(l.isConverted == True && oldmap != null && oldmap.get(l.id) != null && 
			   l.isConverted != oldmap.get(l.Id).isConverted){
				   
				if(l.ConvertedOpportunityId != null){
				   opportunityId.add(l.ConvertedOpportunityId);           
				   mapleadIdToOppId.put(l.id,l.ConvertedOpportunityId);
				   lstLeadNew.add(l);
				}
			   setLeadId.add(l.id);
				
			}
		}
		 
		lstParty = [select id,CRM_Company__c,CRM_Name__c,CRM_Email__c,CRM_Create_New_Business_Account__c,CRM_Create_New_Contact__c,CRM_Create_New_Person_Account__c,
							   CRM_Existing_Account__c,CRM_Existing_Contact__c,CRM_Phone__c,CRM_Type__c,Lead__c from Party__c where Lead__c in : setLeadId];
	
		
		Map<Id,List<Party__c>> mapLeadIdToListOfParty = new Map<Id,List<Party__c>>();
		for(Party__c objPartyToMakeMap : lstParty){
			
			if(mapLeadIdToListOfParty.get(objPartyToMakeMap.Lead__c) == null){
				mapLeadIdToListOfParty.put(objPartyToMakeMap.Lead__c,new List<Party__c>());
			}
			mapLeadIdToListOfParty.get(objPartyToMakeMap.Lead__c).add(objPartyToMakeMap);
			
		}
	
		for(Lead objNewLead : lstLeadNew){
			
			if(mapLeadIdToListOfParty.ContainsKey(objNewLead.id) && mapLeadIdToListOfParty.get(objNewLead.id) != null){
				
				List<Party__c> lstPartyFromMap = mapLeadIdToListOfParty.get(objNewLead.id) ;
					if(lstPartyFromMap != null && lstPartyFromMap.Size()>0){
						for(Party__c objParty : lstPartyFromMap){
							
							if(objParty.CRM_Type__c == 'Co Borrower'){
								//Checking if the Party Record lies in one of the branch        
								if(objParty.CRM_Company__c != null){
								
									if(objParty.CRM_Create_New_Business_Account__c == True && objParty.CRM_Create_New_Contact__c == True){
										
									   // list for both new
									   lstNewAccAndNewContact.add(objParty);
									}
									else if(objParty.CRM_Create_New_Business_Account__c == True && objParty.CRM_Create_New_Contact__c == False && objParty.CRM_Existing_Contact__c != null){
										
										// list for Acc new and contact existing
										lstNewAccAndExistingContact.add(objParty);
									}
									
									else if(objParty.CRM_Create_New_Business_Account__c == False && objParty.CRM_Create_New_Contact__c == True && objParty.CRM_Existing_Account__c != null){
									
										// list for existing acc and new contact
										lstExistingAccAndNewContact.add(objParty);
									}
									else if(objParty.CRM_Existing_Contact__c != null && objParty.CRM_Existing_Account__c != null){
									
									   // list of existing acc and existing con
										lstExistingAccAndExistingContact.add(objParty);
									}
									else{
										//objNewLead.addError('Please Validate Related '+objParty.CRM_Type__c+ ' Detail for record name -' + objParty.CRM_Name__c);
										  objNewLead.addError('Please search for Party duplicates before converting lead');
									}
								
								}
						// Checking for Person Account       
								else{
								
									if(objParty.CRM_Create_New_Person_Account__c == true){
									
									   // create person acc
									   lstNewPersonAccount.add(objParty);
									
									}
									else if(objParty.CRM_Existing_Account__c != null){
										
									  //  existing person acc
									  lstExistingPersonAccount.add(objParty);
									}
									else{
										
										objNewLead.addError('Please search for Party duplicates before converting lead');
									}
								
								} 
							}
							else{
									if(objParty.CRM_Company__c != null){
										
										if(objParty.CRM_Create_New_Business_Account__c == True && objParty.CRM_Create_New_Contact__c == True){
											
										   // list for both new
										   lstNewAccAndNewContact.add(objParty);
										}
										else if(objParty.CRM_Create_New_Business_Account__c == True && objParty.CRM_Create_New_Contact__c == False && objParty.CRM_Existing_Contact__c != null){
											
											// list for Acc new and contact existing
											lstNewAccAndExistingContact.add(objParty);
										}
										
										else if(objParty.CRM_Create_New_Business_Account__c == False && objParty.CRM_Create_New_Contact__c == True && objParty.CRM_Existing_Account__c != null){
										
											// list for existing acc and new contact
											lstExistingAccAndNewContact.add(objParty);
										}
										else if(objParty.CRM_Existing_Contact__c != null && objParty.CRM_Existing_Account__c != null){
										
										   // list of existing acc and existing con
											lstExistingAccAndExistingContact.add(objParty);
										}
										else{
											objNewLead.addError('Please search for Party duplicates before converting lead');
										}
									}
									else{
										if(objParty.CRM_Create_New_Business_Account__c == True && objParty.CRM_Create_New_Contact__c == True){
											
										   // list for both new
										   lstNewAccountAndContactForCompanyNull.add(objParty);
										}
										else if(objParty.CRM_Create_New_Business_Account__c == True && objParty.CRM_Create_New_Contact__c == False && objParty.CRM_Existing_Contact__c != null){
											
											// list for Acc new and contact existing
											lstNewAccountAndExistingConForCompanyNull.add(objParty);
										}
										else if(objParty.CRM_Create_New_Business_Account__c == False && objParty.CRM_Create_New_Contact__c == True && objParty.CRM_Existing_Account__c != null){
										
											// list for existing acc and new contact
											lstExistingAccAndNewContact.add(objParty);
										}
										else if(objParty.CRM_Existing_Contact__c != null && objParty.CRM_Existing_Account__c != null){
										
										   // list of existing acc and existing con
											lstExistingAccAndExistingContact.add(objParty);
										}
										else{
											objNewLead.addError('Please search for Party duplicates before converting lead');
										}
										
									}
								
								}
						}
					}
			}
		}
		
	//For new Account and contact Type Not Co borrower and Company null--------------------------------------------------------------
		if(lstNewAccountAndContactForCompanyNull != null && lstNewAccountAndContactForCompanyNull.size()>0){
			notCoBorrowerCreateNewAccAndCon(lstNewAccountAndContactForCompanyNull);
		}
		
		if(lstNewAccountAndExistingConForCompanyNull != null && lstNewAccountAndExistingConForCompanyNull.size()>0){
			notCoBorCreateNewAccAndExiCon(lstNewAccountAndExistingConForCompanyNull);
		}
	//----------------------------------------------------------------------------------------------------------------------------------
	// For New Person Account and New Contact----------------------------------------------------------------------

		if(lstNewPersonAccount != null && lstNewPersonAccount.Size()>0){
			
			CreatePersonAccount(lstNewPersonAccount);
		
		}
	//For Existing Person Account-------------------------------------------------------------------------------------    
		if(lstExistingPersonAccount !=null && lstExistingPersonAccount.size()>0){
		
			updateToExistingPersonAccount(lstExistingPersonAccount);
		}
		
	//For New Business Account and New Contact -----------------------------------------------------------------------    
		if(lstNewAccAndNewContact != null && lstNewAccAndNewContact.size()>0){
		
			CreateNewBusinessAccountAndContact(lstNewAccAndNewContact);
		}
	 
	//For New Account and Existing Contact ---------------------------------------------------------------------------- 
		if(lstNewAccAndExistingContact != null && lstNewAccAndExistingContact.size()>0){
		
			CreateNewAccountAndExistingContact(lstNewAccAndExistingContact);
		
		}
	 
	// For Existing Account and New Contact --------------------------------------------------------------------------- 
		if(lstExistingAccAndNewContact != null && lstExistingAccAndNewContact.Size()>0){
			
			CreateExistingAccAndNewContact(lstExistingAccAndNewContact);
		}
	// For Existing Account and Existing Contact------------------------------------------------------------------------
		
		if(lstExistingAccAndExistingContact != null && lstExistingAccAndExistingContact.size()>0){
		
			createExAccountAndExContact(lstExistingAccAndExistingContact);
		
		}
		
	}

//For new Account and Existing contact Type Not Co borrower and Company null--------------------------------------------------------------  
	public void notCoBorCreateNewAccAndExiCon(List<Party__c> lstForNewAccAndExiCon){
		
		List<Account> lstDummyAccount = [select id,Name from Account where name = 'Dummy Account' and isPersonAccount = false limit 1 ];
		
		id dummyAccountID ;
		if(lstDummyAccount != null && lstDummyAccount.size()>0){
			
			dummyAccountID = lstDummyAccount[0].id; 
		}
		else{
			Account newDummyAccount = new Account();
			newDummyAccount.Name = 'Dummy Account';
			
			Database.DMLOptions dml = new Database.DMLOptions();
			dml.DuplicateRuleHeader.AllowSave = true; 
			Database.SaveResult sr = Database.insert(newDummyAccount, dml);
			//insert newDummyAccount;
			
			dummyAccountID = newDummyAccount.id;
		}
		
	//Create a Shared contact----------------------------------------------------------------------------------------------------   
		
		
		List<AccountContactRelation> lstsharedContact = new List<AccountContactRelation>();
		List<CRM_Related_Party__c> lstRelatedPartyToInsertCompanyNull = new List<CRM_Related_Party__c>();
		for(Party__c partyNewAccExiConCompanyNull: lstForNewAccAndExiCon){
			
			CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
			objRelatedParty.CRM_Related_Contact__c = partyNewAccExiConCompanyNull.CRM_Existing_Contact__c;
			objRelatedParty.CRM_Related_Account__c = dummyAccountID;
			if(mapleadIdToOppId.containsKey(partyNewAccExiConCompanyNull.Lead__c) && mapleadIdToOppId.get(partyNewAccExiConCompanyNull.Lead__c) != null){
				objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(partyNewAccExiConCompanyNull.Lead__c);
			}
			
			objRelatedParty.CRM_Type__c = partyNewAccExiConCompanyNull.CRM_Type__c;
			
			lstRelatedPartyToInsertCompanyNull.add(objRelatedParty);
			
			AccountContactRelation objsharedContact = new AccountContactRelation();
			objsharedContact.Accountid = dummyAccountID;
			objsharedContact.Contactid= partyNewAccExiConCompanyNull.CRM_Existing_Contact__c;
			lstsharedContact.add(objsharedContact);
			
		}
		
		if(lstRelatedPartyToInsertCompanyNull != null && lstRelatedPartyToInsertCompanyNull.size()>0){
				
			insert lstRelatedPartyToInsertCompanyNull;
		}
		
		if(lstsharedContact != null && lstsharedContact.Size()>0){
			
			insert lstsharedContact;    
		}
		
	}
	
	
//For new Account and contact Type Not Co borrower and Company null--------------------------------------------------------------
	public void notCoBorrowerCreateNewAccAndCon(List<Party__c> lstForNewAccAndNewCon){
		
		List<Account> lstDummyAccount = [select id,Name from Account where name = 'Dummy Account' and isPersonAccount = false limit 1 ];
		
		id dummyAccountID ;
		if(lstDummyAccount != null && lstDummyAccount.size()>0){
			
			dummyAccountID = lstDummyAccount[0].id; 
		}
		else{
			Account newDummyAccount = new Account();
			newDummyAccount.Name = 'Dummy Account';
			
			Database.DMLOptions dml = new Database.DMLOptions();
			dml.DuplicateRuleHeader.AllowSave = true; 
			Database.SaveResult sr = Database.insert(newDummyAccount, dml);
			//insert newDummyAccount;
			
			dummyAccountID = newDummyAccount.id;
		}
		
		
		List<Contact> lstNewContactForDummyAccount = new List<contact>();
		for(Party__c objParty : lstForNewAccAndNewCon){
		
			Contact con = new Contact();
			con.lastName = objParty.CRM_Name__c;
			con.AccountID = dummyAccountID;
			con.Email = objParty.CRM_Email__c;
			con.Phone = objParty.CRM_Phone__c;
			
			lstNewContactForDummyAccount.add(con);
		}
		
		if(lstNewContactForDummyAccount != null && lstNewContactForDummyAccount.size()>0){
			
			Database.DMLOptions dml = new Database.DMLOptions();
			dml.DuplicateRuleHeader.AllowSave = true; 
			List<Database.SaveResult> sr = Database.insert(lstNewContactForDummyAccount, dml);
			//insert lstNewContactForDummyAccount;
		}
		map<String,Contact> mapStringToContact = new map<String,Contact>();
		for(Contact conMap : lstNewContactForDummyAccount){
			
			mapStringToContact.put(conMap.LastName + conMap.Email,conMap); // + conMap.Phone
			
		}
		List<CRM_Related_Party__c> lstRelatedPartyToInsertCompanyNull = new List<CRM_Related_Party__c>();
		for(Party__c partyNewAccountCompanyNull: lstForNewAccAndNewCon){
			
			CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
			if(mapStringToContact.containsKey(partyNewAccountCompanyNull.CRM_Name__c + partyNewAccountCompanyNull.CRM_Email__c) && mapStringToContact.get(partyNewAccountCompanyNull.CRM_Name__c + partyNewAccountCompanyNull.CRM_Email__c) != null){ //+ partyNewAccountCompanyNull.CRM_Phone__c ''  + partyNewAccountCompanyNull.CRM_Phone__c
				objRelatedParty.CRM_Related_Contact__c = mapStringToContact.get(partyNewAccountCompanyNull.CRM_Name__c + partyNewAccountCompanyNull.CRM_Email__c).id; // + partyNewAccountCompanyNull.CRM_Phone__c
			}
			objRelatedParty.CRM_Related_Account__c = dummyAccountID;
			if(mapleadIdToOppId.containsKey(partyNewAccountCompanyNull.Lead__c) && mapleadIdToOppId.get(partyNewAccountCompanyNull.Lead__c) != null){
				objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(partyNewAccountCompanyNull.Lead__c);
			}
			
			objRelatedParty.CRM_Type__c = partyNewAccountCompanyNull.CRM_Type__c;
			
			lstRelatedPartyToInsertCompanyNull.add(objRelatedParty);
		}
		
		if(lstRelatedPartyToInsertCompanyNull != null && lstRelatedPartyToInsertCompanyNull.size()>0){
				
			insert lstRelatedPartyToInsertCompanyNull;
		}
		
	}
 
//Existing Account and Existing Contact--------------------------------------------------------------------------------------- 
	public void createExAccountAndExContact(List<Party__c> lstPartyExAccAndExCon){
	
		List<CRM_Related_Party__c> lstForExAccAndCon = new List<CRM_Related_Party__c>();
		for(Party__c objPartyExAccAndCon : lstPartyExAccAndExCon){
		
			CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
			objRelatedParty.CRM_Related_Account__c = objPartyExAccAndCon.CRM_Existing_Account__c;
			objRelatedParty.CRM_Related_Contact__c = objPartyExAccAndCon.CRM_Existing_Contact__c;
			if(mapleadIdToOppId.containsKey(objPartyExAccAndCon.Lead__c) && mapleadIdToOppId.get(objPartyExAccAndCon.Lead__c) != null){         
				objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(objPartyExAccAndCon.Lead__c);
			}
			objRelatedParty.CRM_Type__c = objPartyExAccAndCon.CRM_Type__c;
			
			lstForExAccAndCon.add(objRelatedParty);
			
		}
		
		if(lstForExAccAndCon != null  && lstForExAccAndCon.size()>0){
		
			insert lstForExAccAndCon;
		
		}
		
	} 
	
	
	
	
 //Create Existing Account and New Contact------------------------------------------------------------------------   
	public void CreateExistingAccAndNewContact(List<Party__c> lstExistingAccountAndNewCon){
	
		List<Contact> lstToInsertContact = new List<Contact>();
		For(Party__c objPartyForNewContact : lstExistingAccountAndNewCon){
	
			contact con = new Contact();
			con.AccountID = objPartyForNewContact.CRM_Existing_Account__c;
			con.LastName = objPartyForNewContact.CRM_Name__c;
			con.Email = objPartyForNewContact.CRM_Email__c;
			con.Phone = objPartyForNewContact.CRM_Phone__c;
			
			lstToInsertContact.add(con);
			
		}
		
		if(lstToInsertContact != null && lstToInsertContact.size()>0){
			Database.DMLOptions dml = new Database.DMLOptions();
			dml.DuplicateRuleHeader.AllowSave = true; 
			List<Database.SaveResult> sr = Database.insert(lstToInsertContact, dml);
			//insert lstToInsertContact;
		
		}
	 
		Map<ID,ID> mapAccIDToConID = new Map<ID,ID>();   
		for(Contact newContact : lstToInsertContact){
		
			mapAccIDToConID.put(newContact.AccountID,newContact.id);
		}
	 
		List<CRM_Related_Party__c> lstExAccAndNewCon = new List<CRM_Related_Party__c>();   
		for(Party__c objExAccAndNewCon : lstExistingAccountAndNewCon){
		
			CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
			objRelatedParty.CRM_Related_Account__c = objExAccAndNewCon.CRM_Existing_Account__c;
			if(mapAccIDToConID.containsKey(objExAccAndNewCon.CRM_Existing_Account__c) && mapAccIDToConID.get(objExAccAndNewCon.CRM_Existing_Account__c) != null){   
				objRelatedParty.CRM_Related_Contact__c = mapAccIDToConID.get(objExAccAndNewCon.CRM_Existing_Account__c);
			}
			if(mapleadIdToOppId.containsKey(objExAccAndNewCon.Lead__c) && mapleadIdToOppId.get(objExAccAndNewCon.Lead__c) != null){ 
				objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(objExAccAndNewCon.Lead__c);
			}
			objRelatedParty.CRM_Type__c = objExAccAndNewCon.CRM_Type__c;
		
			lstExAccAndNewCon.add(objRelatedParty);
		}
		
		if(lstExAccAndNewCon != null && lstExAccAndNewCon.Size()>0){
			insert lstExAccAndNewCon;
		}
	
	}
	
	
	
 //Create New Account and Existing Contact----------------------------------------------------------   
	public void CreateNewAccountAndExistingContact(List<Party__c> lstNewAccAndExContact){
		List<Account> lstNewBusinessAcc = new List<Account>();
		for(Party__c objPartyForNewAcc : lstNewAccAndExContact){
			Account newAcc = new Account();
		   
			newAcc.name = objPartyForNewAcc.CRM_Company__c;
			lstNewBusinessAcc.add(newAcc);
		}
		
		if(lstNewBusinessAcc != null && lstNewBusinessAcc.size()>0){
			Database.DMLOptions dml = new Database.DMLOptions();
			dml.DuplicateRuleHeader.AllowSave = true; 
			List<Database.SaveResult> sr = Database.insert(lstNewBusinessAcc, dml);
			//insert lstNewBusinessAcc;
		}
	 
		Map<String,ID> mapStringToAccountID = new Map<String,ID>();   
		for(Account objAccount : lstNewBusinessAcc){
		
			mapStringToAccountID.put(objAccount.Name,objAccount.ID);
		}
		
		List<AccountContactRelation> lstsharedContact = new List<AccountContactRelation>();
		List<CRM_Related_Party__c> lstRelatedPartyInsert = new List<CRM_Related_Party__c>();
			for(Party__c objToInsertNewAccExCon : lstNewAccAndExContact){
			
				CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
				if(mapStringToAccountID.containsKey(objToInsertNewAccExCon.CRM_Company__c) && mapStringToAccountID.get(objToInsertNewAccExCon.CRM_Company__c) != null){
					objRelatedParty.CRM_Related_Account__c = mapStringToAccountID.get(objToInsertNewAccExCon.CRM_Company__c);
				}
				objRelatedParty.CRM_Related_Contact__c = objToInsertNewAccExCon.CRM_Existing_Contact__c;
				if(mapleadIdToOppId.containsKey(objToInsertNewAccExCon.Lead__c) && mapleadIdToOppId.get(objToInsertNewAccExCon.Lead__c) != null){
					objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(objToInsertNewAccExCon.Lead__c);
				}   
				objRelatedParty.CRM_Type__c = objToInsertNewAccExCon.CRM_Type__c;
				
				lstRelatedPartyInsert.add(objRelatedParty);
				
				AccountContactRelation objsharedContact = new AccountContactRelation();
				if(mapStringToAccountID.containsKey(objToInsertNewAccExCon.CRM_Company__c) && mapStringToAccountID.get(objToInsertNewAccExCon.CRM_Company__c) != null){
					objsharedContact.Accountid = mapStringToAccountID.get(objToInsertNewAccExCon.CRM_Company__c);
				}
				objsharedContact.Contactid= objToInsertNewAccExCon.CRM_Existing_Contact__c;
				lstsharedContact.add(objsharedContact);
			}
			
			if(lstRelatedPartyInsert != null && lstRelatedPartyInsert.size()>0){
			
				insert lstRelatedPartyInsert;
			}
			if(lstsharedContact != null && lstsharedContact.size()>0){
			
				insert lstsharedContact;
			}

	}
	
	
	
	
	
 //Create New Business Account and Contact-------------------------------------------------------------------   
	public void CreateNewBusinessAccountAndContact(List<Party__c> lstNewBussAccAndContact){
		List<Account> lstBusinessAccount = new List<Account>();
		Map<String,Party__c> mapCompanyNameToParty = new Map<String,Party__c>();
			for(Party__c objPartyForNewAccAndCon : lstNewBussAccAndContact){
				Account newAcc = new Account();
				newAcc.name = objPartyForNewAccAndCon.CRM_Company__c;
				lstBusinessAccount.add(newAcc);
				mapCompanyNameToParty.put(objPartyForNewAccAndCon.CRM_Company__c,objPartyForNewAccAndCon);
			}
			
			if(lstBusinessAccount != null && lstBusinessAccount.size()>0){
				Database.DMLOptions dml = new Database.DMLOptions();
				dml.DuplicateRuleHeader.AllowSave = true; 
				List<Database.SaveResult> sr = Database.insert(lstBusinessAccount, dml);
				//insert lstBusinessAccount;
			}
		   
			
			List<Contact> lstInsertContact = new List<Contact>();
			for(Account acc : lstBusinessAccount){
				
				Contact con = new Contact();
				con.AccountID = acc.id;
				if(mapCompanyNameToParty.containsKey(acc.name) && mapCompanyNameToParty.get(acc.name) != null){
					con.LastName = mapCompanyNameToParty.get(acc.name).CRM_Name__c;
					con.Email = mapCompanyNameToParty.get(acc.name).CRM_Email__c;
					con.Phone = mapCompanyNameToParty.get(acc.name).CRM_Phone__c;
					lstInsertContact.add(con);
				}
			}
			
			if(lstInsertContact != null && lstInsertContact.size()>0){
				Database.DMLOptions dml = new Database.DMLOptions();
				dml.DuplicateRuleHeader.AllowSave = true; 
				List<Database.SaveResult> sr = Database.insert(lstInsertContact, dml);
				//insert lstInsertContact;
			}
		 
			Map<String,Contact> mapStringToContactID = new Map<String,Contact>();   
			for(Contact insertedContact : lstInsertContact){
				
				mapStringToContactID.put(insertedContact.LastName + insertedContact.Email, insertedContact); // + insertedContact.Phone
				
			}
			system.debug(mapStringToContactID);
			List<CRM_Related_Party__c> lstRelatedPartyToInsert = new List<CRM_Related_Party__c>();
			for(Party__c objToInsertRelatedRecord : lstNewBussAccAndContact){
			system.debug(objToInsertRelatedRecord);
				CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
				if(mapStringToContactID.containsKey(objToInsertRelatedRecord.CRM_Name__c + objToInsertRelatedRecord.CRM_Email__c) && mapStringToContactID.get(objToInsertRelatedRecord.CRM_Name__c + objToInsertRelatedRecord.CRM_Email__c) != null){ // + objToInsertRelatedRecord.CRM_Phone__c ''  + objToInsertRelatedRecord.CRM_Phone__c
					objRelatedParty.CRM_Related_Account__c = mapStringToContactID.get(objToInsertRelatedRecord.CRM_Name__c + objToInsertRelatedRecord.CRM_Email__c).AccountID; // + objToInsertRelatedRecord.CRM_Phone__c
					objRelatedParty.CRM_Related_Contact__c = mapStringToContactID.get(objToInsertRelatedRecord.CRM_Name__c + objToInsertRelatedRecord.CRM_Email__c).ID; // + objToInsertRelatedRecord.CRM_Phone__c
				}
				if(mapleadIdToOppId.containsKey(objToInsertRelatedRecord.Lead__c) && mapleadIdToOppId.get(objToInsertRelatedRecord.Lead__c) != null){
					objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(objToInsertRelatedRecord.Lead__c);
				}
				objRelatedParty.CRM_Type__c = objToInsertRelatedRecord.CRM_Type__c;
				
				lstRelatedPartyToInsert.add(objRelatedParty);
			}
			
			if(lstRelatedPartyToInsert != null && lstRelatedPartyToInsert.size()>0){
			
				insert lstRelatedPartyToInsert;
			}
	}
	
//FOR PERSON ACCOUNT---------*******************************************------------------------------------    
	
 // update Existing person Account----------------------------------------------------------------------------   
	public void updateToExistingPersonAccount(List<Party__c > lstExistingPerson){
	List<CRM_Related_Party__c> lsttoInsert = new List<CRM_Related_Party__c>();
		for(Party__c objParty : lstExistingPerson){
		   
		   CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
			if(mapleadIdToOppId.containsKey(objParty.Lead__c) && mapleadIdToOppId.get(objParty.Lead__c) != null){
				objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(objParty.Lead__c);
			}
		   objRelatedParty.CRM_Type__c = objParty.CRM_Type__c;
		   objRelatedParty.CRM_Related_Account__c = objParty.CRM_Existing_Account__c;
		   
		   lsttoInsert.add(objRelatedParty);
			
		
		}
		if(lsttoInsert != null && lsttoInsert.size()>0){
			insert lsttoInsert;
		}
	
	}
	
	
//Create Person Account and add the lookup in related object-------------------------------------------- 
   public void CreatePersonAccount(List<Party__c> lstNewPersonAccountCreate){
		id personID = [select id,name from RecordType where name ='Person Account'].Id;
		List<Account> lstAcc = new List<Account>();
		for(Party__c objParty : lstNewPersonAccountCreate){
	   
			Account acc = new Account();
			acc.recordTypeId = personID ;
			acc.LastName = objParty.CRM_Name__c;
			acc.PersonEmail = objParty.CRM_Email__c;
			acc.PersonMobilePhone = objParty.CRM_Phone__c;
		   
			lstAcc.add(acc);
		   
		}
	   
		if(lstAcc != null && lstAcc.size()>0){
			Database.DMLOptions dml = new Database.DMLOptions();
			dml.DuplicateRuleHeader.AllowSave = true; 
			List<Database.SaveResult> sr = Database.insert(lstAcc, dml);
			//insert lstAcc;
		}
	   
		Map<String,ID> mapOfStringToAccountID = new Map<String,Id>();
	   
		for(Account objectAccount : lstAcc){
	   
			mapOfStringToAccountID.put(objectAccount.LastName + objectAccount.PersonEmail + objectAccount.PersonMobilePhone,objectAccount.id);
	   
		}
	   
		List<CRM_Related_Party__c> lstRelatedParty = new List<CRM_Related_Party__c>();
		for(Party__c objParty : lstNewPersonAccountCreate){
	   
			CRM_Related_Party__c objRelatedParty = new CRM_Related_Party__c();
			if(mapleadIdToOppId.containsKey(objParty.Lead__c) && mapleadIdToOppId.get(objParty.Lead__c) != null){
				objRelatedParty.CRM_Related_Opportunity__c = mapleadIdToOppId.get(objParty.Lead__c);
			}
			objRelatedParty.CRM_Type__c = objParty.CRM_Type__c;
			if(mapOfStringToAccountID.containsKey(objParty.CRM_Name__c + objParty.CRM_Email__c + objParty.CRM_Phone__c) && mapOfStringToAccountID.get(objParty.CRM_Name__c + objParty.CRM_Email__c + objParty.CRM_Phone__c) != null){
				objRelatedParty.CRM_Related_Account__c = mapOfStringToAccountID.get(objParty.CRM_Name__c + objParty.CRM_Email__c + objParty.CRM_Phone__c);
			}
			lstRelatedParty.add(objRelatedParty);
		}
	   
		if(lstRelatedParty != null && lstRelatedParty.size()>0){
	   
			insert lstRelatedParty;
		}
	 
	}
	
	//  -------------------------------------------------------------------------------------------------------
	//  This method updates daily achievement on Weekly Target and Achievement Records on Lead Conversion
	//  -------------------------------------------------------------------------------------------------------
	//  Created Date: 14/06/2017       Created By: Chayan Batabyal         Email: chayan.batabyal@saasfocus.com
	//  -------------------------------------------------------------------------------------------------------
	public void updateDailyAchievement(list<Lead> lstTriggerNew,
										map<id,Lead> triggerOldMap)
	{
		Set<ID> setOfUserIDs = new Set<ID>();
		List<CRM_Weekly_Target_and_Achievement__c> lstWeeklyToUpdate;
		Map<id, List<Lead>> mapOfOwnerIdToLeadsConverted = new Map<id, List<Lead>>();
		
		if(lstTriggerNew != NULL && lstTriggerNew.size() > 0)
		{
			for(Lead eachLead : lstTriggerNew)
			{
				if(eachLead.isConverted && (triggerOldMap == NULL ||
					(triggerOldMap != NULL && !triggerOldMap.get(eachLead.id).isConverted)))
				{
					setOfUserIDs.add(eachLead.OwnerId);
					
					if(!mapOfOwnerIdToLeadsConverted.containsKey(eachLead.OwnerId))
						mapOfOwnerIdToLeadsConverted.put(eachLead.OwnerId, new List<Lead>());
					
					mapOfOwnerIdToLeadsConverted.get(eachLead.OwnerId).add(eachLead);
				}
			}
			
			if(setOfUserIDs != NULL && setOfUserIDs.size() > 0 &&
				mapOfOwnerIdToLeadsConverted != NULL && mapOfOwnerIdToLeadsConverted.size() > 0)
			{
				
				Id idLeadsConverted = Schema.SObjectType.CRM_KPI__c.getRecordTypeInfosByName().get(Label.CRM_RT_Leads_Conversion).getRecordTypeId();
				
				lstWeeklyToUpdate = new List<CRM_Weekly_Target_and_Achievement__c>();
				lstWeeklyToUpdate = [Select id, Name, CRM_Daily_Achievement__c, CRM_From__c,
									CRM_KPI_User__c, CRM_To__c, CRM_KPI_Record_Type_Id__c
									from CRM_Weekly_Target_and_Achievement__c
									where CRM_KPI_User__c in : setOfUserIDs and
									CRM_KPI_Record_Type_Id__c =: idLeadsConverted and
									CRM_From__c <= Today and
									CRM_To__c >= Today];
				
				if(lstWeeklyToUpdate != NULL && lstWeeklyToUpdate.size() > 0)
				{
					for(CRM_Weekly_Target_and_Achievement__c eachWeekly : lstWeeklyToUpdate)
					{
						
						if(mapOfOwnerIdToLeadsConverted.containsKey(eachWeekly.CRM_KPI_User__c) &&
							mapOfOwnerIdToLeadsConverted.get(eachWeekly.CRM_KPI_User__c) != NULL &&
							mapOfOwnerIdToLeadsConverted.get(eachWeekly.CRM_KPI_User__c).size() > 0)
						{
							if(eachWeekly.CRM_Daily_Achievement__c == NULL ||
								eachWeekly.CRM_Daily_Achievement__c == 0)
							{
								eachWeekly.CRM_Daily_Achievement__c =
									mapOfOwnerIdToLeadsConverted.get(eachWeekly.CRM_KPI_User__c).size();
							}
							
							else
							{
							   eachWeekly.CRM_Daily_Achievement__c +=
									mapOfOwnerIdToLeadsConverted.get(eachWeekly.CRM_KPI_User__c).size();
							}
						}
						
					}
					
					update lstWeeklyToUpdate;
				}
			}
		}
	}
	
}