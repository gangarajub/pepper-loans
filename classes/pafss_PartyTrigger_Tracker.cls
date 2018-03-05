@isTest(SeeAllData=False) 
public class pafss_PartyTrigger_Tracker
{
    @isTest static void test0()
    {    
		Trigger_Bypass__c trgPass = new Trigger_Bypass__c(
            SetupOwnerId = UserInfo.getOrganizationId(),
            clcommonPartyTrigger__c = true
        );
        insert trgPass;
        

        ScCollection_TriggerExecutionSettings__c objCust = new ScCollection_TriggerExecutionSettings__c();
        objCust.Name = 'All Trigger Execution';
        objCust.pafss_PartyTrigger__c =true;
        objCust.Pafss_Send_Email_Consumer_Loan__c=true;
        objCust.Pafss_Send_Email_Commercial_Loan__c=true;
        insert objCust;
        
        clcommon__Party_Type__c objPartyType = new clcommon__Party_Type__c();
        objPartyType.Name = 'Primary Borrower';
        objPartyType.ScCollection_is_ATP__c = true;
        objPartyType.pafss_Is_Individual_Loan__c = true;
        objPartyType.ScCollection_Only_For_ESB__c = true;
        insert objPartyType;
        
        clcommon__Party_Type__c objPartyType1 = new clcommon__Party_Type__c();
        objPartyType1.Name = 'Co.Borrower';
        objPartyType1.ScCollection_is_ATP__c = true;
        objPartyType1.pafss_Is_Individual_Loan__c = true;
        objPartyType1.ScCollection_Only_For_ESB__c = true;
        insert objPartyType1;
        
        Account acc = new Account();
        acc.LastName ='testAcc';
        acc.FirstName = 'aa';
        acc.PersonEmail ='sandip.bijlwan@saasfocus.com';
        acc.PersonBirthDate = system.today() - 4000;
        acc.PersonMobilePhone = '9090909090';
        acc.PersonMailingPostalCode ='400101';
        acc.pafss_Duplication_Check_Key__c='abc';
        acc.pafss_Non_Duplication_Check_Key__c='pqr';
        acc.Is_Portal_User_Created__c =true;
        insert acc;
        
        Account acc1 = new Account();
        acc1.LastName ='testAcc';
        acc1.PersonEmail ='sandip.bijlwan@saasfocus.com';
        acc1.PersonBirthDate = system.today() - 4000;
        acc1.PersonMobilePhone = '9090909090';
        acc1.PersonMailingPostalCode ='400101';
        acc1.Is_Portal_User_Created__c =true;
        insert acc1;
        
        collect__Source_System__c objSourceSys = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        
        collect__Loan_Account__c objLoanAcc = ScCollection_CommonTrackerClass.createTestContract(objSourceSys.id);
        objLoanAcc.ScCollection_FP_Group_Name__c = 'Consumer Loan';
        update objLoanAcc;
        
        
        clcommon__Party__c objParty = new clcommon__Party__c();
        objParty.clcommon__Type__c = objPartyType.id;
        objParty.clcommon__Account__c = acc.id;
        objParty.collect__CL_Contract__c = objLoanAcc.id;
        objParty.pafss_Send_PAF_Portal_Email__c =true;
        
        insert objParty;
        
        clcommon__Party__c objParty1 = new clcommon__Party__c();
        objParty1.clcommon__Type__c = objPartyType1.id;
        objParty1.clcommon__Account__c = acc1.id;
        objParty1.collect__CL_Contract__c = objLoanAcc.id;
        objParty1.pafss_Send_PAF_Portal_Email__c =true;
        
        insert objParty1;   
    }
}