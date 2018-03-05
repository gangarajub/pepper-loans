//  -------------------------------------------------------------------------------------------------------
//  This class serves as the test class for pafss_SendNewUserEmailController
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 01-FEB-2017          Created By: Sandeep Bijlwan         Email: sandeep.bijlwan@saasfocus.com
//  -------------------------------------------------------------------------------------------------------
@isTest(SeeAllData=False) 
public class pafss_TestSendNewUserEmailController
{
    @isTest static void test0()
    {    
        collect__Source_System__c objSource = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Loan_Account__c objLoanAcc = ScCollection_CommonTrackerClass.createTestContract(objSource.id);
        
        Account acc = new Account();
        acc.LastName = 'testAc';
        acc.PersonEmail = 'san@bijlwan.com';
        insert acc;
        
        pepPepperCustomSetting__c objCust = new pepPepperCustomSetting__c ();
        objCust.acn__c = '094317665';
        objCust.pepCall__c = '13 73 77';
        objCust.Company_Name__c= 'Pepper Group Ltd';
        objCust.creditbodyname__c= 'veda';
        objCust.creditbodyurl__c= 'http://www.veda.com.au';
        objCust.displayname__c= 'Pepper Money';
        objCust.Operating_Hours__c= '8:30 AM to 5:30 PM';
        objCust.pepAppEmailId__c= 'plapplications@pepper.com.au';
        objCust.PepperMoneyContact__c= '1300 659 620';
        objCust.replyemailId__c = 'noreply@pepper.com.au';
        objCust.SetupOwnerId=UserInfo.getOrganizationId();
        insert objCust;
        
        clcommon__Party__c objParty = new clcommon__Party__c ();
        objParty.collect__CL_Contract__c = objLoanAcc.id;
        objParty.clcommon__Account__c = acc.id;
        insert objParty;
        
        pafss_SendNewUserEmailController obj = new pafss_SendNewUserEmailController();
        pafss_SendNewUserEmailController.sendNewUserEmail(objParty.id);
    }
}