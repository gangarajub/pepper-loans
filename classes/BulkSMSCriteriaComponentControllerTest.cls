@isTest(SeeAllData=false)
public class BulkSMSCriteriaComponentControllerTest{
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getSourceTypeListTest
    Company:       Saasfocus
    Description:   This method is use test getSourceTypeList method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest 
    static void getSourceTypeListTest(){
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        String returnString = BulkSMSCriteriaComponentController.getSourceTypeList();
        List<BulkSMSCriteriaComponentController.SourceTypeWraper> lstSourceType = (List<BulkSMSCriteriaComponentController.SourceTypeWraper>)System.JSON.deserializeStrict(returnString,List<BulkSMSCriteriaComponentController.SourceTypeWraper>.class);
        
        System.assert(lstSourceType[0].Name == 'MORTGAGE','worked');
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getFilterRowsListTest
    Company:       Saasfocus
    Description:   This method is use test getFilterRowsList method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest 
    static void getFilterRowsListTest(){
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        String sourceIdName = objSourceSystem.id+'-'+objSourceSystem.Name;
        String returnString = BulkSMSCriteriaComponentController.getFilterRowsList(sourceIdName);
        List<BulkSMSCriteriaComponentController.FilterWrapper> lstFilterWrapper = (List<BulkSMSCriteriaComponentController.FilterWrapper>)System.JSON.deserializeStrict(returnString,List<BulkSMSCriteriaComponentController.FilterWrapper>.class);
        String returnStringFields = BulkSMSCriteriaComponentController.getAllFields('Account-Account');
        System.assert(lstFilterWrapper[0].sequenceNo == 1,'worked');
        
        collect__Source_System__c objSourceSystemClLoan = ScCollection_CommonTrackerClass.createTestSourceSystem('CL Loan');
        String returnStringCl = BulkSMSCriteriaComponentController.getFilterRowsList(objSourceSystemClLoan.Id+'-'+objSourceSystemClLoan.Name);
        List<BulkSMSCriteriaComponentController.FilterWrapper> lstFilterWrapperCl = (List<BulkSMSCriteriaComponentController.FilterWrapper>)System.JSON.deserializeStrict(returnStringCl,List<BulkSMSCriteriaComponentController.FilterWrapper>.class);
        System.assert(lstFilterWrapperCl[0].sequenceNo == 1,'worked');
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getRowResultTest
    Company:       Saasfocus
    Description:   This method is use test getRowResult method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest 
    static void getRowResultTest(){
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        collect__Loan_Account__c objLoanAccount = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        
        Account objAccount = new Account();
        objAccount.Name='test';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact = new Contact();
        objContact.AccountId = objAccount.Id;
        objContact.Salutation = 'Ms';
        objContact.LastName = 'Test';
        objContact.MobilePhone = '9867436729';
        objContact.HomePhone = '01207428737' ;
        insert objContact;
        
        clcommon__Party_Type__c objPType = new clcommon__Party_Type__c();
        objPType.Name = 'Primary Borrower';
        insert objPType;
        
        clcommon__Party__c objParty = new clcommon__Party__c();
        objParty.clcommon__Account__c = objAccount.Id;
        objParty.collect__CL_Contract__c = objLoanAccount.Id;
        objParty.clcommon__Contact__c = objContact.Id;
        objParty.clcommon__Type__c = objPType.Id;
        objParty.ScCollection_Active__c = true;
        objParty.clcommon__isPrimary__c = true;
        insert objParty;
        
        collect__Contract_Status__c objStatus = new collect__Contract_Status__c(
                                                                        Main_Status__c = 'Current',
                                                                        ScCollection_Is_New_Arrears__c = false,
                                                                        ScCollection_Account__c = objAccount.Id ,
                                                                        ScCollection_Contact__c = objContact.Id,
                                                                        ScCollection_Out_With_Agent_Start_Date__c = System.Today());
        insert objStatus;
        objLoanAccount.collect__Collection_Status__c = objStatus.Id;
        update objLoanAccount;
        //creating specific format for date.
        Date dt = System.Today() + 5;
        Integer day = dt.Day();
        Integer month = dt.Month();
        Integer year = dt.Year();
        String dayStr = String.valueOf(day);
        String monthStr = String.valueOf(month);
        if(day < 10){
            dayStr = '0'+String.valueOf(day);
        }
        if(month < 10){
            monthStr = '0'+String.valueOf(month);
        }
        String dtStr = String.valueOf(year)+'-'+monthStr+'-'+dayStr;
        
        String sourceIdName = objSourceSystem.id+'-'+objSourceSystem.Name;
        
        List<BulkSMSCriteriaComponentController.FilterWrapper> lstFilterWrapper = new List<BulkSMSCriteriaComponentController.FilterWrapper>();
        lstFilterWrapper.add(createFilterWrapper('Account-Account','Name','STRING','=',objAccount.Name,1));
        lstFilterWrapper.add(createFilterWrapper('Contact-Contact','LastName','STRING','=',objContact.LastName,2));
        lstFilterWrapper.add(createFilterWrapper('collect__Loan_Account__c-Contract','Name','STRING','=',objLoanAccount.Name,3));
        lstFilterWrapper.add(createFilterWrapper('clcommon__Party__c-Party','clcommon__isPrimary__c','BOOLEAN','=','true',4));
        lstFilterWrapper.add(createFilterWrapper('collect__Contract_Status__c-collect__Collection_Status__c-Collection Status','ScCollection_Out_With_Agent_Start_Date__c','DATE','<',dtStr,5));
        
        String responseStr = BulkSMSCriteriaComponentController.getRowResult(sourceIdName,JSON.serialize(lstFilterWrapper[0]));
        
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr,BulkSMSCriteriaComponentController.ErrorWrapper.class); 
        
        system.assert(objErrorWrapper.isError == false,'worked');
        
        String responseStr1 = BulkSMSCriteriaComponentController.getRowResult(sourceIdName,JSON.serialize(lstFilterWrapper[1]));
        
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper1 = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr1,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        
        system.assert(objErrorWrapper1.isError == false,'worked');
        
        String responseStr2 = BulkSMSCriteriaComponentController.getRowResult(sourceIdName,JSON.serialize(lstFilterWrapper[2]));
        
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper2 = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr2,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        
        system.assert(objErrorWrapper2.isError == false,'worked');
        
        String responseStr3 = BulkSMSCriteriaComponentController.getRowResult(sourceIdName,JSON.serialize(lstFilterWrapper[3]));
        
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper3 = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr3,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        
        system.assert(objErrorWrapper3.isError == false,'worked');
        
        String responseStr4 = BulkSMSCriteriaComponentController.getRowResult(sourceIdName,JSON.serialize(lstFilterWrapper[4]));
        
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper4 = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr4,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        
        system.assert(objErrorWrapper4.isError == false,'worked');
        
        //error if sourcesystem is passed blank
        String responseStr5 = BulkSMSCriteriaComponentController.getRowResult('','');
        
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper5 = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr5,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        
        system.assert(objErrorWrapper5.isError == true,'worked');
        
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getSearchResultTest
    Company:       Saasfocus
    Description:   This method is use test getSearchResult method.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @isTest
    static void getSearchResultTest(){
        collect__Source_System__c objSourceSystem = ScCollection_CommonTrackerClass.createTestSourceSystem('MORTGAGE');
        collect__Loan_Account__c objLoanAccount = ScCollection_CommonTrackerClass.createTestContract(objSourceSystem.Id);
        String sourceIdName = objSourceSystem.id+'-'+objSourceSystem.Name;
        
        List<BulkSMSCriteriaComponentController.SelectedFilterRowResultWrapper> lstWrapper = new List<BulkSMSCriteriaComponentController.SelectedFilterRowResultWrapper>();
        BulkSMSCriteriaComponentController.SelectedFilterRowResultWrapper objSelectedFilter = new BulkSMSCriteriaComponentController.SelectedFilterRowResultWrapper();
        objSelectedFilter.sequenceNo = 1;
        objSelectedFilter.value = 'Id In (\''+ objLoanAccount.Id +'\')';
        lstWrapper.add(objSelectedFilter);
        
        BulkSMSCriteriaComponentController.SelectedFilterRowResultWrapper objSelectedFilter1 = new BulkSMSCriteriaComponentController.SelectedFilterRowResultWrapper();
        objSelectedFilter1.sequenceNo = 2;
        objSelectedFilter1.value = 'Id In (\''+ objLoanAccount.Id +'\')';
        lstWrapper.add(objSelectedFilter1);
        
        
        String responseStr = BulkSMSCriteriaComponentController.getSearchResult(sourceIdName,'1 AND 2',JSON.serialize(lstWrapper));
        BulkSMSCriteriaComponentController.ErrorWrapper objWrapper= (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        
        system.assert(objWrapper.isError == false,'worked');
        
        lstWrapper[0].value = 'Name = TestAccount ';
        lstWrapper[1].value = 'Name = TestAccount1 ';
        
        //no rows retrieve test
        String responseStr1 = BulkSMSCriteriaComponentController.getSearchResult(sourceIdName,'1 AND 2',JSON.serialize(lstWrapper));
        BulkSMSCriteriaComponentController.ErrorWrapper objWrapper1 = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr1,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        system.debug('objWrapper1'+objWrapper1);
        system.assert(objWrapper1.isError == true,'worked');
        
        //Exception in Filter Criteria -- Invalid - 1AND2
        String responseStr2 = BulkSMSCriteriaComponentController.getSearchResult(sourceIdName,'1AND2',JSON.serialize(lstWrapper));
        BulkSMSCriteriaComponentController.ErrorWrapper objWrapper2 = (BulkSMSCriteriaComponentController.ErrorWrapper)System.JSON.deserializeStrict(responseStr2,BulkSMSCriteriaComponentController.ErrorWrapper.class);
        
        system.assert(objWrapper2.isError == true,'worked');
        
    }
    
    /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          createFilterWrapper
    Company:       Saasfocus
    Description:   This method is use create filterwrapper.
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    public static BulkSMSCriteriaComponentController.FilterWrapper createFilterWrapper(String objectName,String fieldName,String type,String operator,String value,Integer seq){
        BulkSMSCriteriaComponentController.FilterWrapper objFilterWrap = new BulkSMSCriteriaComponentController.FilterWrapper();
        objFilterWrap.sequenceNo = seq;
        objFilterWrap.objectList = new List<BulkSMSCriteriaComponentController.APINameWrapper>();
        objFilterWrap.fieldList = new List<BulkSMSCriteriaComponentController.APINameTypeWrapper>();
        objFilterWrap.operatorList = new List<BulkSMSCriteriaComponentController.APINameWrapper>();
        objFilterWrap.value = value;
        objFilterWrap.selectedObject = objectName;
        objFilterWrap.selectedField = fieldName;
        objFilterWrap.selectedFieldType = type;
        objFilterWrap.selectedOperator = operator;
        return objFilterWrap;
    }
}