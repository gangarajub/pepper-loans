@isTest(SeeAllData=False) public class ScCollection_TestSendSmsController{
    
    @isTest static void test0(){
        
        ScCollection_Status_Counter_Settings__c objCust = new ScCollection_Status_Counter_Settings__c();
        objCust.ScCollection_Include__c = true;
        //objCust.ScCollection_Object_Api_Name__c = 'ScCollection_ContractSettings__c';
        objCust.ScCollection_Values__c ='INBOUND - PTP - One-off,INBOUND - PTP Arrangement,OUTBOUND - PTP Arrangement,OUTBOUND PTP - one-off,3 Payment cap processed';
        objCust.Name = 'Max Days Setting';
        objCust.ScCollection_Date_Field_Api_Name__c = 'zero';
        objCust.ScCollection_Counter_Field_Api_Name__c = 'ScCollection_Daysincealldocumentreceived__c';
        objCust.scCollection_Object_Api_Name__c ='collect__Contract_Status__c';
       // update objCust;
        insert objCust;
        
        
        ScCollection_Settings__c objSetting= new ScCollection_Settings__c();
        objSetting.SetupOwnerId=Userinfo.getUserId();
        objSetting.ScCollection_MaxDaysWithPromise__c=16;
        objSetting.ScCollection_MaxDaysNoPromise__c=15;
        insert objSetting;
        
        Sms_Magic__c objMagic = new Sms_Magic__c();
        objMagic.senderId__c='PepperMoneyDev';
        objMagic.Name='CollectionSenderId';
        insert objMagic;
        
        
        
        collect__Queue__c  objQueue = ScCollection_CommonTrackerClass.createTestQueue('Name');
        collect__Source_System__c objSource = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        ScCollection_Log_Template__c objLogTemp = new ScCollection_Log_Template__c();
        objLogTemp.ScCollection_Source_System__c = objSource.id;
        objLogTemp.ScCollection_Is_Active__c = true;
        objLogTemp.ScCollection_Template_Name__c = 'abc';
        objLogTemp.recordtypeId = Schema.SObjectType.ScCollection_Log_Template__c.getRecordTypeInfosByName().get('Manual SMS').getRecordTypeId();
        objLogTemp.ScCollection_Description__c = 'desc';
        insert objLogTemp; 
        
        collect__Loan_Account__c objCollectLoan = ScCollection_CommonTrackerClass.createTestContract(objSource.id);
        collect__Queue_Contract__c objQueueCon = ScCollection_CommonTrackerClass.createTestQueueContract(objQueue.id,objCollectLoan.id,null);
        objQueueCon.ScCollection_Dev_Contract__c = objCollectLoan.id;
        update objQueueCon;
        
        
        collect__Collection_Activity__c objActivity = ScCollection_CommonTrackerClass.createTestActivity(objCollectLoan.id);
        
        
        collect__Interaction_Log__c objLog =  new collect__Interaction_Log__c();
        objlog.collect__Loan_Account_Id__c = objCollectLoan.id ;
        objlog.collect__Follow_Up_Date_Time__c = System.Now();
        objlog.collect__Description__c = 'Test Log Comments';
        objlog.collect__Collection_Activity__c = objactivity.Id;
        insert objlog;
        
        collect__Action_Code__c objAction = ScCollection_CommonTrackerClass.createTestActionCode('3 Payment cap processed');
        objAction.ScCollection_Status_Field_Values__c = 'New Work';
      // objAction.ScCollection_Status_Fiels_Api_Name__c =null;
        update objAction;
        collect__Action_Code_Config__c objActionCode = ScCollection_CommonTrackerClass.createTestCodeConfig(objAction.id,objSource.id);
        
      
        collect__Contact_Preference__c objConPref = new collect__Contact_Preference__c();
        objConPref.collect__Mode_of_Communication__c = 'Message';
        objConPref.collect__Start_Time__c = system.now();
        objConPref.collect__End_Time__c =system.now()+1;
        objConPref.collect__Time_Zone__c = 'Australia/Sydney';
        insert objConPref;
        
        Map<id,collect__Contact_Preference__c> mapIdPref = new Map<Id,collect__Contact_Preference__c >();
        mapIdPref.put(objConPref.id,objConPref);
        
        
        ApexPages.currentPage().getParameters().put('id',objCollectLoan.id);
        ApexPages.currentPage().getParameters().put('smssent','1');
        ApexPages.currentPage().getParameters().put('tabid','1');
        ScCollection_SendSmsController objSendSms = new ScCollection_SendSmsController();
        objSendSms.Initialize();
        //objSendSms.objLog = objlog;
        
        objSendSms.strSelectedTemplate = objLogTemp.id;
        
        objSendSms.strSelectedParty = 'asd-sd';
        objSendSms.strSelectedAction = objAction.id;
        
        objSendSms.strObjectName='collect__Loan_Account__c';
        
        objSendSms.getTemplateName();
        objSendSms.changeTemplate();
        
        objSendSms.SubmitSmsData();
       
        objSendSms.strSelectedOption = 'sms';
        objSendSms.selectOption();
        
        objSendSms.strSelectedOption = 'email';
        objSendSms.selectOption();
        
        objSendSms.strSelectedOption = 'letter';
        objSendSms.selectOption();
        objSendSms.strSelectedParty = objConPref.id +':61 - 98989898';
        objSendSms.selectParty();
        objSendSms.mapPartyToName = new Map<id,string>();
        objSendSms.mapPartyToName.put(objConPref.id,'Name');
        objSendSms.mapPartyToPreference = mapIdPref;
        objSendSms.strSelectedParty = objConPref.id +':61 - 98989898';
        objSendSms.selectParty();
        
        
        //NEw code--------------------------------------------------------
        
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
                                    +'<AccountIdentifier>{collect__Loan_Account__c.Name}</AccountIdentifier>'
                                    +'<RecipientIdentifier>{Account.collect__External_ID__c}</RecipientIdentifier>'
                                    +'<RecipientName>{Account.Name}</RecipientName>'
                                    +'<RecipientAddress>{Contact.MailingAddress}</RecipientAddress>'
                                    +'<DPID></DPID>'
                                    +'<APPID></APPID>'
                                    +'<BCUID></BCUID>'
                                    +'<LEADID></LEADID>'
                                    +'<SALEFORCEID>{collect__Loan_Account__c.Id}</SALEFORCEID>'
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
                                    +'<AggregatorName>{ScCollection_Letter_Template__c.ScCollection_Aggregator_Name__c}</AggregatorName>'
                                    +'<LoanReferenceNumber>{collect__Loan_Account__c.Name}</LoanReferenceNumber>'           
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
                                    +'<ContractName>{collect__Loan_Account__c.Name}</ContractName>'
                                    +'<HardshipRequestedDate>{ScCollection_Hardship__c.ScCollection_HardshipRequestedDate__c}</HardshipRequestedDate>'
                                    +'<HardshipCommencementDate>{ScCollection_Hardship__c.ScCollection_HardshipCommencementDate__c}</HardshipCommencementDate>'
                                    +'<HardshipExpiryDate>{ScCollection_Hardship__c.ScCollection_HardshipExpiryDate__c}</HardshipExpiryDate>'
                                    +'<BSBnumber>{collect__Loan_Account__c.ScCollection_BSB_Number__c}</BSBnumber>'
                                    +'<AccountNumber>{collect__Loan_Account__c.ScCollection_Account_Number__c}</AccountNumber>'
                                    +'<MinimumMonthlyInstallment>{collect__Loan_Account__c.ScCollection_Minimum_Monthly_Installment__c}</MinimumMonthlyInstallment>'
                                    +'<AmountToCurrent>{collect__Loan_Account__c.collect__Amount_to_Current__c}</AmountToCurrent>'
                                    +'<RedrawAvailable>{collect__Loan_Account__c.ScCollection_Redraw_Available__c}</RedrawAvailable>'
                                    +'<RepaymentDay>{collect__Loan_Account__c.ScCollection_Repayment_Day__c}</RepaymentDay>'
                                    +'<NextDueDate>{collect__Loan_Account__c.ScCollection_Next_Installment_Date__c}</NextDueDate>'
                                    +'<ReducedInterestRate>{ScCollection_Hardship__c.ScCollection_Reduced_interest_Rate__c}</ReducedInterestRate> '
                                    +'<ReassessmentDate>{ScCollection_Hardship__c.ScCollection_Reassessment_Date__c}</ReassessmentDate>'
                                    +'<ReducedPaymentAmount>{ScCollection_Hardship__c.ScCollection_Reduced_payment_amount__c}</ReducedPaymentAmount>'
                                    +'<ProposedRepaymentPlan>{ScCollection_Hardship__c.ScCollection_Proposed_Repayment_Plan__c}</ProposedRepaymentPlan> '
                                    +'<LetterofFinanceApproval>{ScCollection_Hardship__c.ScCollection_Letter_of_finance_approval__c}</LetterofFinanceApproval>'
                                    +'<JudgementObtained>{ScCollection_Hardship__c.ScCollection_Judgement_Obtained__c}</JudgementObtained>'
                                    +'<BSB>{ScCollection_Hardship__c.ScCollection_BSB__c}</BSB>'
                                    +'<EREFAccountNumber>{ScCollection_Hardship__c.ScCollection_EREF_Account_number__c}</EREFAccountNumber>'
                                    +'<COSDate>{ScCollection_Hardship__c.ScCollection_COS_Date__c}</COSDate>'
                                +'</Correspondence>'
                                +'<HardshipParagraphs DataFlag="CoreData">'
                                +'{bulletpoints}'
                                +'</HardshipParagraphs>'
                            +'</Record>'
                        +'</Recordset>'
                    +'</Job>';
        
                
        
        ScCollection_Hardship__c sccollection_hardship = new ScCollection_Hardship__c(
        ScCollection_Arrears_to_be_capped__c = 877.33,
        ScCollection_Contract__c = objCollectLoan.id,
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
        collect__CL_Contract__c = objCollectLoan.Id);
        insert objComParty;
    
        Id devRecordTypeId = Schema.SObjectType.ScCollection_Letter_Template__c.getRecordTypeInfosByName().get('Hardship').getRecordTypeId();
        
        ScCollection_Letter_Template__c objTemplate = new ScCollection_Letter_Template__c(
        Name = 'HARDSHIP APPROVAL - REDUCE PAYMENT MORATORIUM',
        ScCollection_Source_System__c = objSource.id,
        ScCollection_Is_Active__c = true,
        ScCollection_Letter_Type__c = 'HARDSHIP APPROVAL',
        ScCollection_Letter_Sub_Type__c = 'REDUCE PAYMENT MORATORIUM',
        Letter_Unique_Name__c = 'HARDSHIP APPROVAL - REDUCE PAYMENT MORATORIUM',
        ScCollection_Process__c = 'Hardship',
        ScCollection_Country_Code__c = 'AUS',
        ScCollection_Application__c = 'Collections',
        ScCollection_Signatory_Name__c = 'Hardship',
        ScCollection_Signatory__c = 'DavidHolmes',
        ScCollection_Aggregator_Name__c = 'Pepper Group Limited',
        RecordTypeId = devRecordTypeId);
        
        insert objTemplate;
        
        ScCollection_Paragraph_Config__c objPar = new ScCollection_Paragraph_Config__c();
        objPar.ScCollection_Letter_Template__c = objTemplate.id;
        objPar.ScCollection_Paragraph_Id__c ='PARID';
        objPar.ScCollection_Selected__c = true;
        insert objPar;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf(str);
        attach.body=bodyBlob;
        attach.ParentId = objTemplate.Id;
        insert attach;  
        
        ApexPages.currentPage().getParameters().put('id',objCollectLoan.id);
        ScCollection_SendSmsController objSendSms1 = new ScCollection_SendSmsController();
        
        objSendSms1.strSelectedOption = 'letter';
        
        objSendSms1.selectOption();
        objSendSms1.strSelectedLetter = objTemplate.id;
        
        objSendSms1.selectLetter();
        objSendSms1.strSelectedParty = objComParty.id;
        objSendSms1.SubmitLetterPreview();
        
         ScCollection_PaymentAPIParameters__c  objCustset = new ScCollection_PaymentAPIParameters__c ();
        objCustset.Name = 'PreviewLetter';
        objCustset.Endpoint__c='www.google.com';
        objCustset.Username__c='usr';
        objCustset.Password__c='passwd';
        insert objCustset;
        
        ScCollection_PaymentAPIParameters__c  objCust1 = new ScCollection_PaymentAPIParameters__c ();
        objCust1.Name = 'ArchiveLetter';
        objCust1.Endpoint__c='www.google.com';
        objCust1.Username__c='usr';
        objCust1.Password__c='passwd';
        insert objCust1;
        
        
        objSendSms1.SubmitLetterData();
        objSendSms1.ClosePopUp();
        
        
        loan__Loan_Account__c objLoanAcc = pepCommonTrackerController.CreateLoanAccount();
        objSource.Name = 'CL Loan';
        update objSource;
        
        ApexPages.currentPage().getParameters().put('id',objLoanAcc.id);
        ScCollection_SendSmsController objSendSms11 = new ScCollection_SendSmsController();
        objSendSms1.strSelectedOption = 'letter';
        
        objSendSms1.selectOption();
    }
    
}