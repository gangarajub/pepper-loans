// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_CommonCodeHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData=False)
public class  ScCollection_TestCommonCodeHandler
{
    public static collect__Source_System__c objSourceSystem;
    public static collect__Loan_Account__c objContract;
    public static loan__Loan_Account__c objplcontract;
    
    static testMethod void Mytest() 
    {
        //insert source system
        objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
                
        //Insert Object of Contract
        objContract = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        //insert pl contract
        objplcontract = pepCommonTrackerController.createLoanAccount();
               
        ScCollection_CommonCodeHandler scColl = new ScCollection_CommonCodeHandler();
        ScCollection_CommonCodeHandler.executeDynamicQuery('abc'); 
        ScCollection_CommonCodeHandler.executeDynamicQuery('select Id from Account limit 1');
         
        ScCollection_CommonCodeHandler.retriveSalesforceRecords('Account','Id, Name','Id != null','Name','10');
        ScCollection_CommonCodeHandler.retriveSalesforceRecords('Account','','Id != null','Name','10');
        ScCollection_CommonCodeHandler.retriveSalesforceRecords('Account','Ids, Name','Id != null','Name','10');
        
        ScCollection_CommonCodeHandler.retriveSalesforceObjectType('001p000000CL5io');
        ScCollection_CommonCodeHandler.retriveSalesforceObjectType('');
        ScCollection_CommonCodeHandler.retriveSalesforceObjectType(new List<Id>{'001p000000CL5io','001p000000CL5io'});
        ScCollection_CommonCodeHandler.retriveSalesforceObjectPrefix('Account');
        
        ScCollection_CommonCodeHandler.retriveContractSettingsData(objContract.Id,UserInfo.getUserId());
        
        ScCollection_CommonCodeHandler.retriveContractStatusData(objContract.Id);
        ScCollection_CommonCodeHandler.retriveContractStatusData(objplcontract.Id);
        
        objContract.collect__Collection_Status__c = Null;
        update objContract;
        ScCollection_CommonCodeHandler.retriveContractStatusData(objContract.Id);
        
        Profile objprofile = [select Id from Profile where Name = 'System Administrator'];
        User objUser1 = ScCollection_CommonTrackerClass.createTestUser('testuser1@pepper.com',objprofile.Id);
        ScCollection_CommonCodeHandler.updateUserReferCount(new Set<Id>{objuser1.id});
        
        objuser1.ScCollection_Daily_Refer_Counter_Date__c = System.Today().addDays(-1);
        objuser1.ScCollection_Daily_Refer_Count__c = 2;
        update objuser1;
        ScCollection_CommonCodeHandler.updateUserReferCount(new Set<Id>{objuser1.id});
        
        String key = String.valueof(objContract.Id) + '-' + String.valueof(objuser1.Id);
        ScCollection_CommonCodeHandler.retriveMapContractSettingsData(new Set<String>{key});
        
        ScCollection_ContractSettings__c objsetting = ScCollection_CommonTrackerClass.createTestContractSettings();
        objsetting.ScCollection_ContracttoUser__c = String.valueof(objContract.Id) + '-' + String.valueof(objuser1.Id);
        update objsetting;
        ScCollection_CommonCodeHandler.retriveMapContractSettingsData(new Set<String>{key});
        
        ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_BankAccountTrigger');

        Map<Id,List<String>> mapProfileIdtoObjects = new Map<Id,List<String>>();
        mapProfileIdtoObjects.put(objprofile.Id,new List<String>{'Account'});
        ScCollection_CommonCodeHandler.getCrudPermissions(mapProfileIdtoObjects);
        
        //new Code---------------------------------------------------
        
        ScCollection_CommonCodeHandler.GenerateUniqueRandomNumber();
       
        ScCollection_CommonCodeHandler.RemoveSpace('abc a');
        ScCollection_CommonCodeHandler.RemoveSpace('');
        
        
        ScCollection_Letter_Template__c objTemplate = new ScCollection_Letter_Template__c(
        Name = 'HARDSHIP APPROVAL - REDUCE PAYMENT MORATORIUM',
        ScCollection_Source_System__c = objSourceSystem.id,
        ScCollection_Is_Active__c = true,
        ScCollection_Letter_Type__c = 'HARDSHIP APPROVAL',
        ScCollection_Letter_Sub_Type__c = 'REDUCE PAYMENT MORATORIUM',
        Letter_Unique_Name__c = 'HARDSHIP APPROVAL - REDUCE PAYMENT MORATORIUM',
        ScCollection_Process__c = 'Hardship',
        ScCollection_Country_Code__c = 'AUS',
        ScCollection_Application__c = 'Collections',
        ScCollection_Signatory_Name__c = 'Hardship',
        ScCollection_Signatory__c = 'DavidHolmes',
        ScCollection_Aggregator_Name__c = 'Pepper Group Limited');
        
        insert objTemplate;
        
        
        Account acc = new Account();
        acc.LastName = 'lastname';
        acc.PersonMailingStreet = 'abc';
        acc.PersonMailingCity = 'city';
        acc.PersonMailingState = 'NWS';
        acc.PersonMailingPostalCode = '7878';
        acc.PersonTitle='Mr';
        insert acc;
        
        clcommon__Party_Type__c objComPartyType= new clcommon__Party_Type__c(
        Name = 'Guarantor',
        ScCollection_is_ATP__c = false,
        ScCollection_Only_For_ESB__c = true);
        insert objComPartyType;
        
        clcommon__Party__c objComParty= new clcommon__Party__c(
        clcommon__Account__c = acc.id,
        clcommon__Type__c = objComPartyType.id,
        genesis__Is_Internal_User__c = false,
        ScCollection_Active__c = true,
        ScCollection_Created_from_ESB__c = true,
        collect__CL_Contract__c = objContract.Id);
        insert objComParty;
        
        ScCollection_Hardship__c sccollection_hardship = new ScCollection_Hardship__c(
        ScCollection_Arrears_to_be_capped__c = 877.33,
        ScCollection_Contract__c = objContract.id,
        ScCollection_Hardhsip_Decision__c = 'Declined',
        ScCollection_HardshipCommencementDate__c = Date.newInstance(2016,11,13),
        ScCollection_HardshipExpiryDate__c = Date.newInstance(2016,11,30),
        ScCollection_HardshipRequestedDate__c = Date.newInstance(2016,11,11),
        ScCollection_Hardship_Assistance_Period__c = '17 day(s)',
        ScCollection_Hardship_Decline_Date__c = Date.newInstance(2016,11,11),
        ScCollection_Hardship_Decline__c = 'No capacity to pay',
        ScCollection_Reason_for_Hardship__c = 'Unemployment',
        ScCollection_Total_Expenses__c = 86079.0,
        ScCollection_Total_Surplus__c = -83079.0,
        ScCollection_Total_income__c = 3000.0,
        ScCollection_Mortgage_1__c = 50000.0,
        ScCollection_Telephone_Internet__c = 1000.0,
        ScCollection_Mobile_Phone__c = 34979.0,
        ScCollection_Petrol__c = 100.0,
        ScCollection_Market_Value_ofThisProperty__c = 570000.0,
        ScCollection_After_Tax_Wages_Borrower_1__c = 1000.0,
        ScCollection_After_Tax_Wages_Borrower_2__c = 2000.0,
        ScCollection_Amount__c = 400.0,
        ScCollection_Frequency__c = 'Weekly',
        ScCollection_Monthly_Amount__c = 1733.33,
        ScCollection_SOFP_Date__c = Date.newInstance(2016,11,11));

        insert sccollection_hardship;
        
     
        
        
        
        string str='<?xml version="1.0" encoding="ISO-8859-1"?>'
                    +'<Job name="{ScCollection_Letter_Template__c.ScCollection_Letter_Type__c}" parms="-gpdf">'
                    +'<Channels>'
                    +'<Channel name="PREVIEW" enabled="{preview}"/>'
                            +'<Channel name="EMAIL" enabled="{email}">'
                                    +'<To/>'
                                    +'<From></From>'
                            +'</Channel>'
                            +'<Channel name="ARCHIVE" enabled="{archive}"/>'
                        +'</Channels>'
                        +'<Recordset>'
                            +'<Record type="{ScCollection_Letter_Template__c.ScCollection_Process__c}" tagName="DOC">'
                                +'<ChannelData>'
                                    +'<Channel name="PREVIEW">'
                                        +'<Filename/>'
                                        +'<Location/>'
                                    +'</Channel>'
                                +'</ChannelData>'
                                +'<Indexes DataFlag="CoreData">'
                                    +'<CountryCode>{ScCollection_Letter_Template__c.ScCollection_Country_Code__c}</CountryCode>'
                                    +'<Application>{ScCollection_Letter_Template__c.ScCollection_Application__c}</Application>'
                                    +'<Category>{ScCollection_Letter_Template__c.ScCollection_Process__c}</Category>'
                                    +'<LetterFormIdentifier>{ScCollection_Letter_Template__c.ScCollection_Letter_Type__c}</LetterFormIdentifier>'
                                    +'<CreationDate>{today}</CreationDate>'
                                    +'<CreationTime>{now}</CreationTime>'
                                    +'<LetterDate>{today}</LetterDate>'
                                    +'<AccountIdentifier>{contractname}</AccountIdentifier>'
                                    +'<RecipientIdentifier>{Account.collect__External_ID__c}</RecipientIdentifier>'
                                    +'<RecipientName>{Account.Name}</RecipientName>'
                                    +'<RecipientAddress>{Contact.MailingAddress}</RecipientAddress>'
                                    +'<DPID></DPID>'
                                    +'<APPID></APPID>'
                                    +'<BCUID></BCUID>'
                                    +'<LEADID></LEADID>'
                                    +'<OutputMethod>{outputmethod}</OutputMethod>'
                                    +'<OutputLocation></OutputLocation>'
                                    +'<AggregatorShortName></AggregatorShortName>'
                                    +'<Format>PDF</Format>'
                                    +'<VersionNumner>1</VersionNumner>'
                                    +'<RevisionNumber>0</RevisionNumber>'           
                                +'</Indexes>'
                                +'<Originator DataFlag="CoreData">'
                                    +'<OriginatorCode></OriginatorCode>'
                                    +'<OriginatorLabel>PE</OriginatorLabel>'
                                    +'<Department>{ScCollection_Letter_Template__c.ScCollection_Application__c}</Department>'
                                    +'<BusinessOwner></BusinessOwner>'
                                    +'<SignatoryName>{ScCollection_Letter_Template__c.ScCollection_Signatory_Name__c}</SignatoryName>'
                                    +'<Signatory>{ScCollection_Letter_Template__c.ScCollection_Signatory__c}</Signatory>'
                                    +'<AggregatorName>{aggregatorname}</AggregatorName>'
                                    +'<LoanReferenceNumber>{contractname}</LoanReferenceNumber>'           
                                +'</Originator>'
                                +'<Correspondence DataFlag="CoreData">'
                                    +'<DocumentType>{ScCollection_Letter_Template__c.ScCollection_Process__c}</DocumentType>'
                                    +'<ApprovalType>{ScCollection_Letter_Template__c.ScCollection_Letter_Sub_Type__c}</ApprovalType>'
                                    +'<Date>{correspondencetoday}</Date>'
                                    +'<AccountName>{Account.Name}</AccountName>'
                                    +'<MailingAddress>{Contact.MailingAddress}</MailingAddress> '
                                    +'<Town>{Contact.MailingCity}</Town>'
                                    +'<State>{Contact.MailingState}</State> '
                                    +'<Postcode>{Contact.MailingPostalCode}</Postcode>'
                                    +'<Title>{Account.Title}</Title> '
                                    +'<LastName>{Account.LastName}</LastName>'
                                    +'<ContractName>{contractname}</ContractName>'
                                    +'<HardshipRequestedDate>{ScCollection_Hardship__c.ScCollection_HardshipRequestedDate__c}</HardshipRequestedDate>'
                                    +'<HardshipCommencementDate>{ScCollection_Hardship__c.ScCollection_HardshipCommencementDate__c}</HardshipCommencementDate>'
                                    +'<HardshipExpiryDate>{ScCollection_Hardship__c.ScCollection_HardshipExpiryDate__c}</HardshipExpiryDate>'
                                    +'<BSBnumber>{contractbsbnumber}</BSBnumber>'
                                    +'<AccountNumber>{contractacctnumber}</AccountNumber>'
                                    +'<MinimumMonthlyInstallment>{contractmmi}</MinimumMonthlyInstallment>'
                                    +'<AmountToCurrent>{contractamounttocurrent}</AmountToCurrent>'
                                    +'<RedrawAvailable>{contractredrawavailable}</RedrawAvailable>'
                                    +'<RepaymentDay>{contractrepayday}</RepaymentDay>'
                                    +'<NextDueDate>{contractnextduedate}</NextDueDate>'
                                    +'<ReducedInterestRate>{ScCollection_Hardship__c.ScCollection_Reduced_interest_Rate__c}</ReducedInterestRate> '
                                    +'<ReassessmentDate>{ScCollection_Hardship__c.ScCollection_Reassessment_Date__c}</ReassessmentDate>'
                                    +'<ReducedPaymentAmount>{ScCollection_Hardship__c.ScCollection_Reduced_payment_amount__c}</ReducedPaymentAmount>'
                                    +'<ProposedRepaymentPlan>{ScCollection_Hardship__c.ScCollection_Proposed_Repayment_Plan__c}</ProposedRepaymentPlan> '
                                    +'<LetterofFinanceApproval>{ScCollection_Hardship__c.ScCollection_Letter_of_finance_approval__c}</LetterofFinanceApproval>'
                                    +'<JudgementObtained>{ScCollection_Hardship__c.ScCollection_Judgement_Obtained__c}</JudgementObtained>'
                                    +'<BSB>{ScCollection_Hardship__c.ScCollection_BSB_1__c}</BSB>'
                                    +'<EREFAccountNumber>{ScCollection_Hardship__c.ScCollection_EREF_Account_number__c}</EREFAccountNumber>'
                                    +'<COSDate>{ScCollection_Hardship__c.ScCollection_COS_Date__c}</COSDate>'
                                +'</Correspondence>'
                                +'<HardshipParagraphs DataFlag="CoreData">'
                                +'{bulletpoints}'
                                +'</HardshipParagraphs>'
                            +'</Record>'
                        +'</Recordset>'
                    +'</Job>';
        
        String abc = ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objContract,objComParty.Id,'preview');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objContract,objComParty.Id,'archive');
        
        ScCollection_CommonCodeHandler.ProcessLetterXml(null,objTemplate,objContract,objComParty.Id,'preview');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,null,objContract,objComParty.Id,'preview');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,null,objComParty.Id,'preview');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objContract,null,'preview');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objContract,null,'archiveq');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objContract,objComParty.Id,'preview');
        
        ScCollection_PaymentAPIParameters__c  objCust = new ScCollection_PaymentAPIParameters__c ();
        objCust.Name = 'PreviewLetter';
        objCust.Endpoint__c='www.google.com';
        objCust.Username__c='usr';
        objCust.Password__c='passwd';
        insert objCust;
        
        ScCollection_PaymentAPIParameters__c  objCust1 = new ScCollection_PaymentAPIParameters__c ();
        objCust1.Name = 'ArchiveLetter';
        objCust1.Endpoint__c='www.google.com';
        objCust1.Username__c='usr';
        objCust1.Password__c='passwd';
        insert objCust1;
        
        ScCollection_CommonCodeHandler.SendLetter(abc,'preview');
        ScCollection_CommonCodeHandler.SendLetter(abc,'archive');
        ScCollection_CommonCodeHandler.SendLetter(null,'archive');
        ScCollection_CommonCodeHandler.SendLetter(abc,null);
        ScCollection_CommonCodeHandler.SendLetter(abc,'abc');
        
        ScCollection_CommonCodeHandler.processApiResult(null);
        
        ScCollection_TriggerExecutionSettings__c objCustcheck = new ScCollection_TriggerExecutionSettings__c();
        objCustcheck.Name = 'All Trigger Execution';
        objCustcheck.ScCollection_BankAccountTrigger__c = true;
        insert objCustcheck;
        ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_BankAccountTrigger');
        
        
        sccollection_hardship.scCollection_Loan_Account__c = objplcontract.id;
        update sccollection_hardship;
        Account objPersonAccount = new Account(
                                            LastName = 'Abajo',
                                            FirstName = 'Tirso',
                                            Salutation = 'Mr',
                                            PersonMailingStreet = '6 Tyndale Turn WELLARD WA 6170',
                                            PersonMailingState = 'WA',
                                            PersonMailingPostalCode = '6170',
                                            PersonMailingCountry = 'Australia',
                                            PersonBirthdate = Date.newInstance(1970,04,28)
                                            );
        insert objPersonAccount;
        
        Residential_Address__c objResidentialAddress= new Residential_Address__c(
                                                                    Account__c = objPersonAccount.id,
                                                                    Current_Address__c = true,
                                                                    How_Long_have_you_lived_here__c = 'between 2 and 5 years',
                                                                    PostCode__c = '2067',
                                                                    State__c = 'NSW',
                                                                    Street_Name__c = 'Elizabeth',
                                                                    Street_Number__c = '26',
                                                                    Street_Type__c = 'Rd',
                                                                    Suburb__c = 'Kirribilli',
                                                                    What_is_Your_Residential_Status__c = 'living in my own home (no mortgage)');

        insert objResidentialAddress;
        
        loan__Bank_Account__c objbankacc= new loan__Bank_Account__c(
                                                                    loan__Account_Usage__c = 'Borrower/Investor Account',
                                                                    loan__Active__c = false,
                                                                    loan__Bank_Account_Number__c = '12345',
                                                                    loan__Bank_Name__c = 'Bank of Statements',
                                                                    peer__Allow_for_Direct_Credit__c = false,
                                                                    peer__Savings_No__c = false,
                                                                    peer__Savings_Other__c = false,
                                                                    peer__Savings_Pensions__c = false,
                                                                    Account_Holder_Name__c = 'Mary Jones and Tom Jones',
                                                                    Agreed_to_Terms_and_Conditions__c = false,
                                                                    BSB__c = '125649',
                                                                    Bank_Account_Number__c = '945315',
                                                                    Is_Debit_Authorization_Provided__c = false);
        insert objbankacc;
        
        
        objplcontract.loan__Account__c = objPersonAccount.Id  ;
        update objplcontract;                          
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objplcontract,null,'preview');
        
        objplcontract.loan__Next_Installment_Date__c = null;
        objplcontract.Default_Bank_Account__c = objbankacc.id;
        update objplcontract;
        
        
        
        sccollection_hardship.ScCollection_HardshipRequestedDate__c = null;
        sccollection_hardship.ScCollection_HardshipCommencementDate__c = null;
        sccollection_hardship.ScCollection_HardshipExpiryDate__c = null;
        sccollection_hardship.ScCollection_Reassessment_Date__c = System.today();
        sccollection_hardship.ScCollection_Letter_of_finance_approval__c = system.today();
        sccollection_hardship.ScCollection_Judgement_Obtained__c = system.today();
        sccollection_hardship.ScCollection_COS_Date__c = system.today();
        sccollection_hardship.ScCollection_Date_docs_to_be_returned__c = system.today();
        sccollection_hardship.ScCollection_Date_payments_to_recommence__c = system.today();
        sccollection_hardship.ScCollection_SOFP_Date__c = null;
        sccollection_hardship.ScCollection_Followed_up_Date__c = System.today();
        sccollection_hardship.ScCollection_Ad_Hoc_Date_1__c = System.today();
        sccollection_hardship.ScColletion_Ad_Hoc_Date_2__c = System.today();
        update sccollection_hardship;
        objContract.ScCollection_Next_Installment_Date__c = System.Today()+1;
        update objContract;
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objplcontract,null,'preview');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objplcontract,null,'');
        
        delete sccollection_hardship;
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objContract,objComParty.Id,'preview');
        ScCollection_CommonCodeHandler.ProcessLetterXml(str,objTemplate,objContract,objContract.Id,'preview');
        
        
        
        ScCollection_CommonCodeHandler.exceptionHandler(null);
        
        
    }
    
    @isTest Static void test1(){
        
        ScCollection_CollectionContractMock  successMortgageTest = new ScCollection_CollectionContractMock (200,'complete','{"APIStatus": {"APICode": "200","APIDescription": "Request received successfully.","APIResponse": "Request received successfully.","ClientReferences": [{"ClientReference": {"ReferenceType": "loanNumber","Reference": "1213984"}},{"ClientReference": {"ReferenceType": "propertyValuationId","Reference": "a1r28000000TYXIAA4"}}],"PepperReferences": [{"PepperReference": {"ReferenceType": "apiStatus","Reference": "99"}},{"PepperReference": {"ReferenceType": "apiLog","Reference": "3784"}},{"PepperReference": {"ReferenceType": "messageId","Reference": "3784"}}],"Messages": [{"Message": {"MessageId": "3784","MessageCode": "202","MessageDescription": "Request received successfully."}}]}}',null);
        Test.setMock(HttpcalloutMock.class,successMortgageTest);
        
        ScCollection_PaymentAPIParameters__c  objCustGetErrorLog = new ScCollection_PaymentAPIParameters__c ();
        objCustGetErrorLog.Name = 'GetErrorLog';
        objCustGetErrorLog.Endpoint__c='www.google.com';
        objCustGetErrorLog.Username__c='usr';
        objCustGetErrorLog.Password__c='passwd';
        insert objCustGetErrorLog;
        
        test.StartTest();
            ScCollection_CommonCodeHandler.GetErrorResponse('1');
         test.stopTest();
    }
}