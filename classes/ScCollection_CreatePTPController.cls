// ----------------------------------------------------------------------------------------------------
// This class would be used to handle all functionality for creating and updating promise to pay.
// ----------------------------------------------------------------------------------------------------
// Created Date: 10-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestCreatePTPController
// ----------------------------------------------------------------------------------------------------
public class ScCollection_CreatePTPController 
{
    //variable declaration for the data to be populated on page
    public String strContractId {get;set;}
    public String strTabId {get;set;}
    public String strRefresh {get;set;}
    public String strSourceSystem {get;set;}
    public String strObjectName = '';
    
    public String strTotalArrears {get;set;}
    public String strTotalBalance {get;set;}
    public String strBSBNo {get;set;}
    public String strAccountNo {get;set;}
    public String strAccountName {get;set;}
    public String strPaymentAmount {get;set;}
    public String strPromiseCount {get;set;}
    public String strPromiseAmount {get;set;}
    public String strIndex {get;set;}
    public String strRentalAmount {get;set;}
    public String strAccountKeepingFees {get;set;}
    
    public Boolean showSubmit {get;set;}
    public Boolean showUpdate {get;set;}
    public Boolean showOnlyUpdate {get;set;}
    public Boolean showOneOff {get;set;}
    public Boolean showRecurring {get;set;}
    
    public Boolean showPaymentAmount{get;set;}
    
    public collect__Payment_Arrangement__c objarrangement {get;set;}
    public collect__Promise_To_Pay__c objptp {get;set;}
    public List<collect__Promise_To_Pay__c> lstptp {get;set;}
    public Map<Id,collect__Promise_To_Pay__c> mapexistingptp = new Map<Id,collect__Promise_To_Pay__c>();
    public collect__Promise_To_Pay__c objexistingptp = new collect__Promise_To_Pay__c();
    public Set<Id> setdeleteptp = new Set<Id>();
    
    public Set<Id> setContractId = new Set<Id>();
    public Map<Id,Sobject> mapResult = new Map<Id,Sobject>();
    
    public List<collect__Promise_To_Pay__c> lstptpToRemove {get;set;}
    public List<collect__Promise_To_Pay__c> lstPtpDeleted {get;set;}
    public List<collect__Promise_To_Pay__c> lspPTPNotDeleted {get;set;}
    
    public collect__Contract_Status__c objStatus{get;set;}
    public Date dtFromDate{get;set;}
    public Date dtToDate{get;set;}
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    collect.API1 api1 = collect.APIFactory.getAPI1();
    
    //
    public String strContractName;
    
    //constructor for variable initialization
    public ScCollection_CreatePTPController()
    {
        strContractId = '';
        strTabId = '';
        strRefresh = '';
        strSourceSystem = '';
        
        strTotalArrears = '';
        strTotalBalance = '';
        strBSBNo = '';
        strAccountNo = '';
        strAccountName = '';
        strPaymentAmount = '0.00';
        strPromiseCount = '0';
        strPromiseAmount = '0.00';
        strRentalAmount = '0.00';
        strAccountKeepingFees = '0.00';
        
        showSubmit = false;
        showUpdate = false;
        showOnlyUpdate = false;
        showOneOff = false;
        showRecurring = false;
        
        showPaymentAmount = false;
        
        strContractName = '';
        
        lstptpToRemove = new List<collect__Promise_To_Pay__c>();
        lstPtpDeleted = new List<collect__Promise_To_Pay__c>();
        lspPTPNotDeleted = new List<collect__Promise_To_Pay__c>();
        
        
        //get the Id from url parameter
        if(ApexPages.currentPage().getParameters().get('id') != Null && ApexPages.currentPage().getParameters().get('id') != '')
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
                        
            //call common method to retrieve object name
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            
            setContractId.add(strContractId);
            
            //call api method of cls to get current open contract record
            mapResult = api.getContracts(setContractId);
                       
            if(Test.isRunningTest() || ScCollection_UtilityHandler.isNotNull(mapResult))
            {
                if(strObjectName == 'loan__Loan_Account__c')
                {
                    strSourceSystem = 'CL Loan';
                    loan__Loan_Account__c objcnt = (loan__Loan_Account__c)mapResult.get(strContractId);
                    
                    //assign contract name
                    strContractName = objcnt.Name;
                    
                    //initialize values in the static variables
                    if(objcnt != Null && objcnt.loan__Amount_to_Current__c != Null && objcnt.loan__Amount_to_Current__c > 0)
                    {
                        strTotalArrears = String.valueof(objcnt.loan__Amount_to_Current__c.setScale(2));
                    }
                    else
                    {    
                        strTotalArrears = '0.00';
                    }
                    if(objcnt != Null && objcnt.loan__Loan_Balance__c != Null && objcnt.loan__Loan_Balance__c > 0)
                    {
                        strTotalBalance = String.valueof(objcnt.loan__Loan_Balance__c.setScale(2));
                    }
                    else
                    {
                        strTotalBalance = '0.00';
                    }
                    if(objcnt != Null && objcnt.loan__ACH_Routing_Number__c != Null)
                    {
                        strBSBNo = String.valueof(objcnt.loan__ACH_Routing_Number__c);
                    }
                    if(objcnt != Null && objcnt.loan__ACH_Account_Number__c != Null)
                    {
                        strAccountNo = String.valueof(objcnt.loan__ACH_Account_Number__c);
                    }
                    if(objcnt != Null && objcnt.loan__ACH_Bank_Name__c != Null)
                    {
                        strAccountName = String.valueof(objcnt.loan__ACH_Bank_Name__c);
                    }
                }
                else if(strObjectName == 'collect__Loan_Account__c')
                {   
                    collect__Loan_Account__c objcnt = (collect__Loan_Account__c)mapResult.get(strContractId); 
                    
                    //assign contract name
                    strContractName = objcnt.Name;
                    
                    if(objcnt != Null && objcnt.collect__Source_System__c != Null)
                    {
                        strSourceSystem = [select Id, Name from collect__Source_System__c where Id =: objcnt.collect__Source_System__c].Name;
                    }
                    
                    if(!String.isBlank(strSourceSystem) && strSourceSystem.equalsIgnoreCase('PAF') && objcnt.collect__Collection_Status__c != null){
                        objStatus = [Select Id,ScCollection_Promise_Hold_From__c,ScCollection_Promise_Hold_To__c From collect__Contract_Status__c Where Id=:objcnt.collect__Collection_Status__c];
                        dtFromDate = objStatus.ScCollection_Promise_Hold_From__c;
                        dtToDate = objStatus.ScCollection_Promise_Hold_To__c;
                        
                    }
                    
                    //initialize values in the static variables                    
                    if(objcnt != Null && objcnt.ScCollection_Arrears__c != Null && objcnt.ScCollection_Arrears__c > 0)
                    {
                        strTotalArrears = String.valueof(objcnt.ScCollection_Arrears__c.setScale(2));
                    }
                    else
                    {
                        strTotalArrears = '0.00';
                    }
                    if(objcnt != Null && objcnt.ScCollection_Current_Principal__c != Null && objcnt.ScCollection_Current_Principal__c > 0)
                    {
                        strTotalBalance = String.valueof(objcnt.ScCollection_Current_Principal__c.setScale(2));
                    }
                    else
                    {
                        strTotalBalance = '0';
                    }
                    if(objcnt != Null && objcnt.ScCollection_BSB_Number__c != Null)
                    {
                        strBSBNo = String.valueof(objcnt.ScCollection_BSB_Number__c);
                    }
                    if(objcnt != Null && objcnt.ScCollection_Account_Number__c != Null)
                    {
                        strAccountNo = String.valueof(objcnt.ScCollection_Account_Number__c);
                    }
                    if(objcnt != Null && objcnt.ScCollection_Account_Name__c != Null)
                    {
                        strAccountName = String.valueof(objcnt.ScCollection_Account_Name__c);
                    }
                    if(objcnt != Null && objcnt.ScCollection_Rental_Amount__c != Null){
                        strRentalAmount = String.valueof(objcnt.ScCollection_Rental_Amount__c.setScale(2));
                    }
                    if(objcnt != Null && objcnt.ScCollection_Account_Keeping_Fees__c != Null){
                        strAccountKeepingFees = String.valueof(objcnt.ScCollection_Account_Keeping_Fees__c.setScale(2));
                    }
                }    
            }
            
            //check if any existing ptp exists
            List<collect__Promise_To_Pay__c> lstAlreadyPromised = [select Id, 
                                                                          collect__Promise_To_Pay_Amount__c 
                                                                          from collect__Promise_To_Pay__c 
                                                                          where collect__Promise_Kept__c != true AND 
                                                                          collect__Promise_Broken__c != true AND 
                                                                          (collect__Dev_Contract__c =: strContractId OR 
                                                                          collect__Loan_Account_Id__c =: strContractId)];
            
            if(ScCollection_UtilityHandler.isNotNull(lstAlreadyPromised))
            {
                Integer count = 0;
                Decimal amount = 0.0;
                
                for(collect__Promise_To_Pay__c obj : lstAlreadyPromised)
                {
                    amount += obj.collect__Promise_To_Pay_Amount__c;
                    count++;
                }
                
                strPromiseCount = String.valueof(count);
                strPromiseAmount = String.valueof(amount);
            }
            else
            {
                strPromiseCount = '0';
                strPromiseAmount = '0.0';
            }
        }
        
        //get ptp id from url parameter for ptp view page
        if(ApexPages.currentPage().getParameters().get('ptpid') != Null && ApexPages.currentPage().getParameters().get('ptpid') != '')
        {
            showSubmit = false;
            showPaymentAmount = false;
            
            List<collect__Promise_To_Pay__c> lsttempptp = [select Id, collect__Payment_Arrangement__c from collect__Promise_To_Pay__c where Id =: ApexPages.currentPage().getParameters().get('ptpid')];
            
            //retrieve the whole arrangement on the basis of ptp id
            if(ScCollection_UtilityHandler.isNotNull(lsttempptp) && ScCollection_UtilityHandler.isNotNull(lsttempptp[0].collect__Payment_Arrangement__c))
            {
                objarrangement = [select Id, 
                                         collect__Arrangement_Amount__c, 
                                         collect__Start_Date__c, 
                                         collect__End_Date__c,
                                         collect__Frequency__c, 
                                         collect__Occurence__c, 
                                         ScCollection_Payment_Method__c, 
                                         ScCollection_PTP_Type__c,
                                         ScCollection_Is_error__c,
                                         ScCollection_Error_message__c,
                                         (select Id, 
                                                 Name,
                                                 collect__Payment_Arrangement__c, 
                                                 ScCollection_Promise_To_Pay_Amount__c, 
                                                 ScCollection_Promise_To_Pay_Date__c, 
                                                 collect__Promise_To_Pay_Amount__c, 
                                                 collect__Promise_To_Pay_Date__c, 
                                                 collect__Promise_Kept__c, 
                                                 collect__Promise_Broken__c, 
                                                 collect__Promise_Made_On__c 
                                                 from collect__Promise_To_Pay__r)
                                         from collect__Payment_Arrangement__c 
                                         where Id =: lsttempptp[0].collect__Payment_Arrangement__c];
                
                if(objarrangement.ScCollection_PTP_Type__c == 'One-Off')
                {
                    showOneOff = true;
                    objptp = objarrangement.collect__Promise_To_Pay__r[0];
                    objexistingptp = objptp.clone(false,true,false,false);

                    if(objptp.collect__Promise_Kept__c != true && objptp.collect__Promise_Broken__c != true)
                    {
                        showUpdate = true;
                    }
                    if(objptp.ScCollection_Promise_To_Pay_Date__c <= system.Today()){
                        showOnlyUpdate = true;
                    }
                }
                else if(objarrangement.ScCollection_PTP_Type__c == 'Recurring')
                {
                    if(objarrangement.ScCollection_Payment_Method__c == 'Direct Debit' && strSourceSystem == 'PAF'){
                        showPaymentAmount = true;
                    }
                    showRecurring = true;
                    lstptp = objarrangement.collect__Promise_To_Pay__r;
                    sortPTPList();
                    for(collect__Promise_To_Pay__c obj : lstptp)
                    {
                        if(obj.collect__Promise_Kept__c != true && obj.collect__Promise_Broken__c != true)
                        {
                            showUpdate = true;
                        }
                        
                        if(obj.collect__Promise_Kept__c || obj.collect__Promise_Broken__c || obj.ScCollection_Promise_To_Pay_Date__c <= system.Today())
                        {
                            showOnlyUpdate = true;
                        }
                        
                        mapexistingptp.put(obj.Id,obj.clone(false,true,false,false));
                    }
                }
            }
        }
        else
        {
            showSubmit = true;
            showPaymentAmount = true;
            
            objarrangement = new collect__Payment_Arrangement__c();
            objptp = new collect__Promise_To_Pay__c();
            lstptp = new List<collect__Promise_To_Pay__c>();
        }
        
        //get the parent tab id for console refresh functionality
        if(ApexPages.currentPage().getParameters().get('tabid') != Null && ApexPages.currentPage().getParameters().get('tabid') != '')
        {
            strTabId = ApexPages.currentPage().getParameters().get('tabid');
        }
        
        if(ApexPages.currentPage().getParameters().get('refresh') != Null && ApexPages.currentPage().getParameters().get('refresh') != '')
        {
            strRefresh = ApexPages.currentPage().getParameters().get('refresh');
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for p2p list creation for recurring type
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 08-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void ProcessData()
    {
        lstptp = new List<collect__Promise_To_Pay__c>();
        
        //check required fields
        if(objarrangement.collect__Frequency__c > 0 && Decimal.valueof(strPaymentAmount) > 0 && objarrangement.collect__Occurence__c != Null && objarrangement.collect__Start_Date__c != null)
        {
            objarrangement.collect__Arrangement_Amount__c = Decimal.valueof(strPaymentAmount) * objarrangement.collect__Frequency__c;
            
            //check the start date validation            
            if(objarrangement.collect__Start_Date__c >= System.Today())
            {
                String strPTPDateStatus = ValidatePTPDate();
                            
                if(strPTPDateStatus == 'ok')
                {
                    String strPTPAmountStatus = ValidatePTPAmount();
                                    
                    if(strPTPAmountStatus == 'ok')
                    {
                        Date startdate = objarrangement.collect__Start_Date__c;
                                    
                        Boolean isLastDay = false;
                        Integer firstDate;
                        for(Integer i = 0; i < objarrangement.collect__Frequency__c; i++)
                        {    
                            collect__Promise_To_Pay__c obj = new collect__Promise_To_Pay__c();
                                    
                            obj.ScCollection_Promise_To_Pay_Amount__c = Decimal.valueof(strPaymentAmount);
                            obj.ScCollection_Promise_To_Pay_Date__c = startdate;
                            objarrangement.collect__End_Date__c = startdate;
                            lstptp.add(obj);
                                    
                            if(objarrangement.collect__Occurence__c == 'Monthly')
                            {
                                if(i == 0){
                                    Integer numberOfDays = Date.daysInMonth(startdate.year(), startdate.month());
                                    firstDate = startdate.day();
                                    if(numberOfDays == startdate.day()){
                                        isLastDay = true;
                                    }
                                }
                                if(isLastDay){
                                    Integer intMonth = startdate.month() + 1;
                                    Integer numberOfDays = Date.daysInMonth(startdate.year(), intMonth);
                                    startdate = Date.newInstance(startdate.year(), intMonth, numberOfDays);
                                }
                                else{
                                    Date addDates = startdate.addMonths(1);
                                    if(addDates.Day() != firstDate && addDates.Month() != 2){
                                        startdate = Date.newInstance(addDates.year(), addDates.Month(), firstDate);
                                    }
                                    else{
                                        startdate = addDates;
                                    }
                                    
                                }
                            }
                            else if(objarrangement.collect__Occurence__c == 'Fortnightly')
                            {
                                startdate = startdate.addDays(14);
                            }
                            else if(objarrangement.collect__Occurence__c == 'Weekly')
                            {
                                startdate = startdate.addDays(7);
                            }
                        }
                        
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strPTPAmountStatus));  
                    }
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strPTPDateStatus));  
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_PTP_Date_Error));        
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Required_Field_Error));
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for p2p creation
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 08-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public PageReference SubmitData()
    {
        if(objarrangement.ScCollection_PTP_Type__c != Null && objarrangement.ScCollection_Payment_Method__c != Null)
        {
            if(objarrangement.ScCollection_PTP_Type__c == 'One-Off')
            {
                String result = createOneOffPTP();
                
                if(result == 'ok')
                {
                    PageReference pr = new PageReference('/apex/ScCollection_CreatePTP?id=' + strContractId + '&ptpid=' + objptp.Id + '&tabid=' + strTabId + '&refresh=1');
                    pr.setRedirect(true);
                    return pr;
                }
                else
                {    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,result));    
                    return Null;
                }
            }
            else if(objarrangement.ScCollection_PTP_Type__c == 'Recurring')
            {
                if(objarrangement.collect__Frequency__c > 0 && Decimal.valueof(strPaymentAmount) > 0 && objarrangement.collect__Occurence__c != Null && objarrangement.collect__Start_Date__c != null)
                {
                    objarrangement.collect__Arrangement_Amount__c = Decimal.valueof(strPaymentAmount) * objarrangement.collect__Frequency__c;
                        
                    if(objarrangement.collect__Start_Date__c >= System.Today())
                    {
                        if(lstptp.size() > 0)
                        {
                            Decimal PtpAmount = 0.0;
                            
                            for(collect__Promise_To_Pay__c obj : lstptp)
                            {
                                PtpAmount = obj.ScCollection_Promise_To_Pay_Amount__c;
                                break;
                            }
                            
                            if(PtpAmount == Decimal.valueof(strPaymentAmount) && objarrangement.collect__Frequency__c == lstptp.size() && objarrangement.collect__Start_Date__c == lstptp[0].ScCollection_Promise_To_Pay_Date__c)
                            {
                                String strPTPDateStatus = ValidatePTPDate();
                                                                    
                                if(strPTPDateStatus == 'ok')
                                {
                                    String strPTPAmountStatus = ValidatePTPAmount();
                                                    
                                    if(strPTPAmountStatus == 'ok')
                                    {
                                        if(lstptp.size() == 1)
                                        {
                                            objarrangement.ScCollection_PTP_Type__c = 'One-Off';
                                            objarrangement.collect__Frequency__c = 1;
                                        }
                                        
                                        Sobject objcontract = mapResult.get(strContractId);
                                        
                                        if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                                        {
                                            objarrangement.collect__Loan_Account_Id__c = objcontract.Id;
                                            objarrangement.ScCollection_CL_Contract__c = objcontract.Id;
                                        }
                                        else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                                        {
                                            objarrangement.collect__Contract__c = objcontract.Id;
                                        }
                                        
                                        Integer counter = 1;
                                                                                
                                        for(collect__Promise_To_Pay__c objtempptp : lstptp)
                                        {
                                            objtempptp.collect__Promise_To_Pay_Amount__c = objtempptp.ScCollection_Promise_To_Pay_Amount__c;
                                            objtempptp.collect__Promise_To_Pay_Date__c = objtempptp.ScCollection_Promise_To_Pay_Date__c;
                                            //objtempptp.collect__Promise_Made_On__c = System.Today();
                                            objtempptp.ScCollection_PTP_AutoNumber__c = 'P' + String.valueof(counter);
                                            if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                                            {
                                                objtempptp.collect__Loan_Account_Id__c = objcontract.Id;
                                                objtempptp.ScCollection_CL_Contract__c = objcontract.Id;
                                            }
                                            else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                                            {
                                                objtempptp.collect__Dev_Contract__c = objcontract.Id;
                                            }
                                            counter++;
                                        }
                                        
                                        String ApiResult = 'ok';
                                        Boolean checkHoldSuccess = false;
                                        
                                        if(strSourceSystem.equalsIgnoreCase('PAF') && ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Hold_Direct_Debit')
                                            && (objStatus.ScCollection_Promise_Hold_From__c != dtFromDate  || objStatus.ScCollection_Promise_Hold_To__c != dtToDate)){
                                            if(objStatus.ScCollection_Promise_Hold_From__c == null && objStatus.ScCollection_Promise_Hold_To__c == null){
                                                checkHoldSuccess = true;
                                            }
                                            else{
                                                ScCollection_HoldDirectDebitController objHoldDD = new ScCollection_HoldDirectDebitController(null);
                                                objHoldDD.objStatus = objStatus;
                                                objHoldDD.strContractId = '';
                                                objHoldDD.strObjectName = '';
                                                objHoldDD.strContractName = strContractName;
                                                objHoldDD.strTabId = '';
                                                objHoldDD.strRefresh = '';
                                                
                                                String strHoldResponse = objHoldDD.submitHold();
                                                if(!String.isBlank(strHoldResponse) && strHoldResponse == 'Success'){
                                                    checkHoldSuccess = true;
                                                }
                                                else{
                                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strHoldResponse));
                                                    return Null;
                                                }
                                            }
                                        }
                                        
                                        //Create Direct Debit Sync Call for PAF.
                                        if(objarrangement.ScCollection_Payment_Method__c.equalsIgnoreCase('Direct Debit') && ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Create_Direct_Debit') && strSourceSystem.equalsIgnoreCase('PAF')){
                                            ApiResult  = SyncDirectDebit(objarrangement,lstptp);
                                        }
                                        system.debug('ApiResult Recurring '+ApiResult);
                                        
                                        if(checkHoldSuccess){
                                            update objStatus;
                                        }
                                        
                                        if(!Test.isRunningTest() && ApiResult == 'ok')
                                        {
                                            
                                            //call the cls api to create payment arrangement and ptp records
                                            collect.Result objresult  = api1.createPaymentArrangement(objarrangement, lstptp, objcontract, true);
                                           
                                            //process result object to get error if any
                                            ApiResult = ScCollection_CommonCodeHandler.processApiResult(objresult);
                                        }
                                                                                
                                        if(ApiResult == 'ok')
                                        {
                                            
                                            if(ScCollection_UtilityHandler.isNotNull(lstptp[0].Id) && ScCollection_UtilityHandler.isNotNull(objarrangement.Id))
                                            {
                                                PageReference pr = new PageReference('/apex/ScCollection_CreatePTP?id=' + strContractId + '&ptpid=' + lstptp[0].Id + '&tabid=' + strTabId + '&refresh=1');
                                                pr.setRedirect(true);
                                                return pr;
                                            }
                                        }
                                        else
                                        {
                                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult));    
                                            return Null;    
                                        }
                                    }
                                    else
                                    {
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strPTPAmountStatus));    
                                        return Null;
                                    }
                                }
                                else
                                {
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strPTPDateStatus));    
                                    return Null;
                                }    
                            }
                            else
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Schedule_Mismatch_Error));
                                return Null;
                            }
                        }
                        else
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Payment_Schedule_Error));
                            return Null;
                        }
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_PTP_Date_Error));        
                        return Null;
                    }
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Required_Field_Error));
                    return Null;
                }
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Required_Field_Error));
            return Null;
        }
        
        return Null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for p2p updation
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 08-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public PageReference UpdateData()
    {
        if(objarrangement.ScCollection_PTP_Type__c == 'One-Off')
        {
            if(objptp.ScCollection_Promise_To_Pay_Date__c != Null && objptp.ScCollection_Promise_To_Pay_Amount__c != Null)
            {
                if((objexistingptp.ScCollection_Promise_To_Pay_Date__c == objptp.ScCollection_Promise_To_Pay_Date__c) || (objexistingptp.ScCollection_Promise_To_Pay_Date__c != objptp.ScCollection_Promise_To_Pay_Date__c && objptp.ScCollection_Promise_To_Pay_Date__c >= System.Today()))
                {
                    String strPTPDateStatus = ValidatePTPDate();
                        
                    if((objexistingptp.ScCollection_Promise_To_Pay_Date__c == objptp.ScCollection_Promise_To_Pay_Date__c) || (objexistingptp.ScCollection_Promise_To_Pay_Date__c != objptp.ScCollection_Promise_To_Pay_Date__c && strPTPDateStatus == 'ok'))
                    {
                        ScCollection_Settings__c cs = ScCollection_Settings__c.getInstance(UserInfo.getUserId());
                        
                        Decimal minpercent = 0.0;
                        Decimal minamount = 0.0;
                        
                        minpercent = cs.ScCollection_MinAcceptCommitment__c;
                        minamount = (minpercent/100)*((Decimal.valueof(strTotalArrears)-Decimal.valueof(strPromiseAmount)) + objptp.collect__Promise_To_Pay_Amount__c);
                        minamount = minamount.setScale(2);
                        
                        if((objexistingptp.ScCollection_Promise_To_Pay_Amount__c == objptp.ScCollection_Promise_To_Pay_Amount__c) || (objexistingptp.ScCollection_Promise_To_Pay_Amount__c != objptp.ScCollection_Promise_To_Pay_Amount__c && objptp.ScCollection_Promise_To_Pay_Amount__c >= minamount))
                        {
                            if(objptp.collect__Promise_Kept__c && objptp.collect__Promise_Broken__c)
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Promise_Kept_Broken_Error));
                                return Null;
                            }
                            else
                            {
                                Sobject objcontract = mapResult.get(strContractId);
                                
                                objarrangement.collect__Start_Date__c = objptp.ScCollection_Promise_To_Pay_Date__c;
                                objarrangement.collect__End_Date__c = objptp.ScCollection_Promise_To_Pay_Date__c;
                                objarrangement.collect__Frequency__c = 1;
                                objarrangement.collect__Arrangement_Amount__c = objptp.ScCollection_Promise_To_Pay_Amount__c;
                                if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                                {
                                    objarrangement.collect__Loan_Account_Id__c = objcontract.Id;
                                    objarrangement.ScCollection_CL_Contract__c = objcontract.Id;
                                }
                                else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                                {
                                    objarrangement.collect__Contract__c = objcontract.Id;
                                }
                                                            
                                objptp.collect__Promise_To_Pay_Amount__c = objptp.ScCollection_Promise_To_Pay_Amount__c;
                                objptp.collect__Promise_To_Pay_Date__c = objptp.ScCollection_Promise_To_Pay_Date__c;
                                //objptp.collect__Promise_Made_On__c = System.Today();
                                                                
                                if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                                {
                                    objptp.collect__Loan_Account_Id__c = objcontract.Id;
                                    objptp.ScCollection_CL_Contract__c = objcontract.Id;
                                }
                                else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                                {
                                    objptp.collect__Dev_Contract__c = objcontract.Id;
                                }
                                
                                String ApiResult = 'ok';

                                if(!Test.isRunningTest())
                                {
                                    //call the cls api to create payment arrangement and ptp records
                                    collect.Result objresult  = api1.createPaymentArrangement(objarrangement, new List<collect__Promise_To_Pay__c>{objptp}, objcontract, true);
                                    
                                    ApiResult = ScCollection_CommonCodeHandler.processApiResult(objresult);    
                                }
                                                            
                                if(ApiResult == 'ok')
                                {
                                    PageReference pr = new PageReference('/apex/ScCollection_CreatePTP?id=' + strContractId + '&ptpid=' + objptp.Id + '&tabid=' + strTabId + '&refresh=1');
                                    pr.setRedirect(true);
                                    return pr;
                                }
                                else
                                {    
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult));    
                                    return Null;
                                }
                            }
                        }
                        else
                        {
                            String errorlbl = Label.ScCollection_PTP_Min_Amount_Error;
                            if(errorlbl.contains('{dynamic}'))
                            {
                                errorlbl = errorlbl.replace('{dynamic}', String.valueOf(minamount));
                            }
                            
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorlbl));
                            return Null;  
                        }
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strPTPDateStatus));        
                        return Null;  
                    }
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_PTP_Date_Error));    
                    return Null;  
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Required_Field_Error));    
                return Null;
            }
        }
        else if(objarrangement.ScCollection_PTP_Type__c == 'Recurring')
        {
            if(objarrangement.collect__Frequency__c > 0 && objarrangement.collect__Occurence__c != Null && objarrangement.collect__Start_Date__c != null)
            {
                if(lstptp.size() > 0)
                {
                    Decimal PtpNewAmount = 0.0;
                    Decimal PtpOldAmount = 0.0;
                    Boolean isKeptBrokenError = false;
                                
                    for(collect__Promise_To_Pay__c obj : lstptp)
                    {
                        PtpNewAmount += obj.ScCollection_Promise_To_Pay_Amount__c;
                        PtpOldAmount += obj.collect__Promise_To_Pay_Amount__c;
                        
                        if(obj.collect__Promise_Kept__c && obj.collect__Promise_Broken__c)
                        {
                            isKeptBrokenError = true;
                        }
                    }
                    
                    ScCollection_Settings__c cs = ScCollection_Settings__c.getInstance(UserInfo.getUserId());
                    
                    Decimal minpercent = 0.0;
                    Decimal minamount = 0.0;
                    
                    minpercent = cs.ScCollection_MinAcceptCommitment__c;
                    minamount = (minpercent/100)*((Decimal.valueof(strTotalArrears)-Decimal.valueof(strPromiseAmount)) + PtpOldAmount);
                    minamount = minamount.setScale(2);

                    if(PtpNewAmount >= minamount)
                    {
                        if(isKeptBrokenError)
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Promise_Kept_Broken_Error));
                            return Null;
                        }
                        else
                        {
                            String ApiResult = 'ok';
                            //Delete Direct Debit Call for PAF.
                            if(objarrangement.ScCollection_Payment_Method__c.equalsIgnoreCase('Direct Debit') && strSourceSystem.equalsIgnoreCase('PAF') && lstptpToRemove.size() > 0){
                                ErrorResponse objResponse  = deleteDirectDebit(objarrangement,lstptpToRemove);
                                system.debug('objResponse == '+objResponse);
                                if(objResponse.isTrue){
                                    lstptp.addAll(lstptpToRemove);
                                    
                                    sortPTPList();
                                    
                                    lstptpToRemove.clear();
                                    setdeleteptp = new set<Id>();
                                    ApiResult = objResponse.message;
                                    objarrangement.ScCollection_Is_error__c = false;
                                    objarrangement.ScCollection_Error_message__c = '';
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult));
                                    return Null;
                                }
                                else{
                                    if(objResponse.message != 'ok'){
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objResponse.message));
                                        setdeleteptp = new set<Id>();
                                        for(collect__Promise_To_Pay__c objPtpDeleted : lstPtpDeleted){
                                            setdeleteptp.add(objPtpDeleted.Id);
                                        }
                                        if(lspPTPNotDeleted.size() > 0){
                                            lstptp.addAll(lspPTPNotDeleted);
                                            
                                            sortPTPList();
                                            
                                    
                                            PtpNewAmount = 0.0;
                                            PtpOldAmount = 0.0;
                                            for(collect__Promise_To_Pay__c obj : lstptp)
                                            {
                                                PtpNewAmount += obj.ScCollection_Promise_To_Pay_Amount__c;
                                                PtpOldAmount += obj.collect__Promise_To_Pay_Amount__c;
                                                
                                            }
                                        }
                                    }
                                    else{
                                        objarrangement.ScCollection_Is_error__c = false;
                                        objarrangement.ScCollection_Error_message__c = '';
                                    }
                                }
                            }
                    
                            if(ScCollection_UtilityHandler.isNotNull(setdeleteptp))
                            {
                                if(!Test.isRunningTest())
                                {
                                    collect.Result objresult = api1.deleteP2P(setdeleteptp,true);
                                
                                    ApiResult = ScCollection_CommonCodeHandler.processApiResult(objresult);
                                }
                                                            
                                if(ApiResult != 'ok')
                                {
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult));
                                    return Null;    
                                }
                            }
                            
                            if(lstptp.size() == 1)
                            {
                                objarrangement.ScCollection_PTP_Type__c = 'One-Off';
                            }
                            
                            Sobject objcontract = mapResult.get(strContractId);
                            objarrangement.collect__Frequency__c = lstptp.size();
                            objarrangement.collect__Arrangement_Amount__c = PtpNewAmount;
                            if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                            {
                                objarrangement.collect__Loan_Account_Id__c = objcontract.Id;
                                objarrangement.ScCollection_CL_Contract__c = objcontract.Id;
                            }
                            else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                            {
                                objarrangement.collect__Contract__c = objcontract.Id;
                            }
                            
                            Integer counter = 1;
                            
                            for(collect__Promise_To_Pay__c objtempptp : lstptp)
                            {
                                objarrangement.collect__End_Date__c = objtempptp.collect__Promise_To_Pay_Date__c;
                                objtempptp.collect__Promise_To_Pay_Amount__c = objtempptp.ScCollection_Promise_To_Pay_Amount__c;
                                //objtempptp.collect__Promise_Made_On__c = System.Today();
                                objtempptp.ScCollection_PTP_AutoNumber__c = 'P' + String.valueof(counter);
                                if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                                {
                                    objtempptp.collect__Loan_Account_Id__c = objcontract.Id;
                                    objtempptp.ScCollection_CL_Contract__c = objcontract.Id;
                                }
                                else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                                {
                                    objtempptp.collect__Dev_Contract__c = objcontract.Id;
                                }
                                counter++;
                            }
                            
                            String ApiResult1 = 'ok';

                            if(!Test.isRunningTest())
                            {
                                //call the cls api to create payment arrangement and ptp records
                                collect.Result objresult1  = api1.createPaymentArrangement(objarrangement, lstptp, objcontract, true);
                            
                                ApiResult1 = ScCollection_CommonCodeHandler.processApiResult(objresult1);
                            }
                                
                            if(ApiResult1 == 'ok')
                            {
                                PageReference pr = new PageReference('/apex/ScCollection_CreatePTP?id=' + strContractId + '&ptpid=' + lstptp[0].Id + '&tabid=' + strTabId + '&refresh=1');
                                pr.setRedirect(true);
                                return pr;
                            }
                            else
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult1));
                                return Null;    
                            }
                        }
                    }
                    else
                    {
                        for(collect__Promise_To_Pay__c objnewptp : lstptp)
                        {
                            if(mapexistingptp.containsKey(objnewptp.Id) && mapexistingptp.get(objnewptp.id) != Null && mapexistingptp.get(objnewptp.Id).collect__Promise_Kept__c != true)
                            {
                                objnewptp.collect__Promise_Kept__c = false;
                            }
                        }
                        
                        String errorlbl = Label.ScCollection_PTP_Min_Amount_Error;
                        if(errorlbl.contains('{dynamic}'))
                        {
                            errorlbl = errorlbl.replace('{dynamic}', String.valueOf(minamount));
                        }
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorlbl));
                        return Null;                            
                    }    
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Payment_Schedule_Error));
                    return Null;
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_Required_Field_Error));
                return Null;
            }
        }
        
        return Null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method used as common method to validate one-off p2p creation/updation
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 08-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public String createOneOffPTP()
    {
        if(objptp.ScCollection_Promise_To_Pay_Date__c != Null && objptp.ScCollection_Promise_To_Pay_Amount__c != Null)
        {
            if(objptp.ScCollection_Promise_To_Pay_Date__c >= System.Today())
            {
                String strPTPDateStatus = ValidatePTPDate();
                    
                if(strPTPDateStatus == 'ok')
                {
                    String strPTPAmountStatus = ValidatePTPAmount();
                            
                    if(strPTPAmountStatus == 'ok')
                    {
                        Sobject objcontract = mapResult.get(strContractId);
                        
                        objarrangement.collect__Start_Date__c = objptp.ScCollection_Promise_To_Pay_Date__c;
                        objarrangement.collect__End_Date__c = objptp.ScCollection_Promise_To_Pay_Date__c;
                        objarrangement.collect__Frequency__c = 1;
                        objarrangement.collect__Arrangement_Amount__c = objptp.ScCollection_Promise_To_Pay_Amount__c;
                        if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                        {
                            objarrangement.collect__Loan_Account_Id__c = objcontract.Id;
                            objarrangement.ScCollection_CL_Contract__c = objcontract.Id;
                        }
                        else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                        {
                            objarrangement.collect__Contract__c = objcontract.Id;
                        }
                                                    
                        objptp.collect__Promise_To_Pay_Amount__c = objptp.ScCollection_Promise_To_Pay_Amount__c;
                        objptp.collect__Promise_To_Pay_Date__c = objptp.ScCollection_Promise_To_Pay_Date__c;
                        //objptp.collect__Promise_Made_On__c = System.Today();
                        objptp.ScCollection_PTP_AutoNumber__c = 'P1';
                        
                        if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                        {
                            objptp.collect__Loan_Account_Id__c = objcontract.Id;
                            objptp.ScCollection_CL_Contract__c = objcontract.Id;
                        }
                        else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                        {
                            objptp.collect__Dev_Contract__c = objcontract.Id;
                        }
                        
                        String ApiResult = 'ok';
                        Boolean checkHoldSuccess = false;
                        
                        if(strSourceSystem.equalsIgnoreCase('PAF') && ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Hold_Direct_Debit')
                            && (objStatus.ScCollection_Promise_Hold_From__c != dtFromDate  || objStatus.ScCollection_Promise_Hold_To__c != dtToDate)){
                            if(objStatus.ScCollection_Promise_Hold_From__c == null && objStatus.ScCollection_Promise_Hold_To__c == null){
                                checkHoldSuccess = true;
                            }
                            else{
                                ScCollection_HoldDirectDebitController objHoldDD = new ScCollection_HoldDirectDebitController(null);
                                objHoldDD.objStatus = objStatus;
                                objHoldDD.strContractId = '';
                                objHoldDD.strObjectName = '';
                                objHoldDD.strContractName = strContractName;
                                objHoldDD.strTabId = '';
                                objHoldDD.strRefresh = '';
                                
                                String strHoldResponse = objHoldDD.submitHold();
                                if(!String.isBlank(strHoldResponse) && strHoldResponse == 'Success'){
                                    checkHoldSuccess = true;
                                }
                                else{
                                    // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strHoldResponse));
                                    // return Null;
                                    return strHoldResponse;
                                }
                            }   
                        }
                        
                        //Create Direct Debit Sync Call for PAF.
                        if(objarrangement.ScCollection_Payment_Method__c.equalsIgnoreCase('Direct Debit') && ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Create_Direct_Debit') && strSourceSystem.equalsIgnoreCase('PAF')){
                            ApiResult  = SyncDirectDebit(objarrangement,new List<collect__Promise_To_Pay__c>{objptp});
                        }
                        system.debug('ApiResult One Off'+ApiResult);
                        
                        if(checkHoldSuccess){
                            update objStatus;
                        }
                        
                        if(!Test.isRunningTest() && ApiResult == 'ok')
                        {
                            //call the cls api to create payment arrangement and ptp records
                            collect.Result objresult  = api1.createPaymentArrangement(objarrangement, new List<collect__Promise_To_Pay__c>{objptp}, objcontract, true);
                            
                            ApiResult = ScCollection_CommonCodeHandler.processApiResult(objresult);    
                        }
                                                    
                        return(ApiResult);
                    }
                    else
                    {
                        return(strPTPAmountStatus);
                    }
                }
                else
                {
                    return(strPTPDateStatus);    
                }
            }
            else
            {
                return(Label.ScCollection_PTP_Date_Error);    
            }
        }
        else
        {
            return(Label.ScCollection_Required_Field_Error);
        }
        
        return('Error...');
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for p2p deletion
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 10-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public PageReference DeleteData()
    {
        if(objarrangement.ScCollection_PTP_Type__c == 'One-Off')
        {
            if(objptp.collect__Promise_Kept__c != true && objptp.collect__Promise_Broken__c != true)    
            {
                if(objptp.ScCollection_Promise_To_Pay_Date__c != System.Today())
                {
                    String ApiResult = 'ok';
                    
                    //Delete Direct Debit Call for PAF.
                    if(objarrangement.ScCollection_Payment_Method__c.equalsIgnoreCase('Direct Debit') && strSourceSystem.equalsIgnoreCase('PAF')){
                        ErrorResponse objResponse  = deleteDirectDebit(objarrangement,new List<collect__Promise_To_Pay__c>{objptp});
                        system.debug('objResponse == '+objResponse);
                        if(objResponse.isTrue){
                            ApiResult = objResponse.message;
                        }
                        else{
                            if(objResponse.message != 'ok'){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objResponse.message));
                            }
                        }
                    }
                    
                    if(!Test.isRunningTest() && ApiResult == 'ok')
                    {
                        //call the cls api to delete payment arrangement and ptp record
                        collect.Result objresult = api1.deletePaymentArrangement(objarrangement, true);
                    
                        ApiResult = ScCollection_CommonCodeHandler.processApiResult(objresult);    
                    }
                                    
                    if(ApiResult == 'ok')
                    {
                        PageReference pr = new PageReference('/apex/ScCollection_CreatePTP?id=' + strContractId + '&tabid=' + strTabId + '&refresh=0');
                        pr.setRedirect(true);
                        return pr;
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult));    
                        return Null;    
                    }
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_PTP_Same_Date_Deletion_Error));
                    return Null;
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_PTP_Delete_Error));    
                return Null;
            }
        }
        else if(objarrangement.ScCollection_PTP_Type__c == 'Recurring')
        {
            Boolean candelete = true;
            
            for(collect__Promise_To_Pay__c obj : lstptp)
            {
                if(obj.collect__Promise_Kept__c || obj.collect__Promise_Broken__c)
                {
                    candelete = false;
                    break;
                }

                if(obj.collect__Promise_To_Pay_Date__c == System.Today())
                {
                    candelete = false;
                    break;    
                }
            }
            
            if(candelete)
            {
                Decimal PtpNewAmount = 0.0;
                Decimal PtpOldAmount = 0.0;
                String ApiResult1 = 'ok';
                setdeleteptp = new set<Id>();
                if(lstptpToRemove != null && lstptpToRemove.Size() > 0){
                    lstptp.addAll(lstptpToRemove);
                    sortPTPList();
                    lstptpToRemove.clear();
                    
                }
                //Delete Direct Debit Call for PAF.
                if(objarrangement.ScCollection_Payment_Method__c.equalsIgnoreCase('Direct Debit') && strSourceSystem.equalsIgnoreCase('PAF')){
                    ErrorResponse objResponse  = deleteDirectDebit(objarrangement,lstptp);
                    system.debug('objResponse == '+objResponse);
                    if(objResponse.isTrue){
                        ApiResult1 = objResponse.message;
                        objarrangement.ScCollection_Is_error__c = false;
                        objarrangement.ScCollection_Error_message__c = '';
                    }
                    else{
                        if(objResponse.message != 'ok'){
                            
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objResponse.message));
                            objarrangement.ScCollection_Is_error__c = true;
                            objarrangement.ScCollection_Error_message__c = objResponse.message;
                            
                            for(collect__Promise_To_Pay__c objPtpDeleted : lstPtpDeleted){
                                setdeleteptp.add(objPtpDeleted.Id);
                                
                            }system.debug(lspPTPNotDeleted);
                            if(lspPTPNotDeleted != null && lspPTPNotDeleted.size() > 0){
                                lstptp = lspPTPNotDeleted;
                                if(lstptp != null && lstptp.Size() > 0){
                                    sortPTPList();
                                }
                                for(collect__Promise_To_Pay__c obj : lstptp)
                                {
                                    PtpNewAmount += obj.ScCollection_Promise_To_Pay_Amount__c;
                                    PtpOldAmount += obj.collect__Promise_To_Pay_Amount__c;
                                    
                                }
                            }
                        }
                        else{
                            objarrangement.ScCollection_Is_error__c = false;
                            objarrangement.ScCollection_Error_message__c = '';
                        }
                    }
                }
                if(setdeleteptp != null && setdeleteptp.size() > 0){
                    
                    if(!Test.isRunningTest() && ApiResult1 == 'ok')
                    {
                        collect.Result objresult = api1.deleteP2P(setdeleteptp,true);
                    
                        ApiResult1 = ScCollection_CommonCodeHandler.processApiResult(objresult);
                    }
                                                
                    if(ApiResult1 != 'ok')
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult1));
                        return Null;    
                    }
                    
                    if(lstptp.size() == 1)
                    {
                        objarrangement.ScCollection_PTP_Type__c = 'One-Off';
                    }
                    
                    Sobject objcontract = mapResult.get(strContractId);
                    objarrangement.collect__Frequency__c = lstptp.size();
                    objarrangement.collect__Arrangement_Amount__c = PtpNewAmount;
                    if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                    {
                        objarrangement.collect__Loan_Account_Id__c = objcontract.Id;
                        objarrangement.ScCollection_CL_Contract__c = objcontract.Id;
                    }
                    else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                    {
                        objarrangement.collect__Contract__c = objcontract.Id;
                    }
                    
                    Integer counter = 1;
                            
                    for(collect__Promise_To_Pay__c objtempptp : lstptp)
                    {
                        objarrangement.collect__End_Date__c = objtempptp.collect__Promise_To_Pay_Date__c;
                        objtempptp.collect__Promise_To_Pay_Amount__c = objtempptp.ScCollection_Promise_To_Pay_Amount__c;
                        //objtempptp.collect__Promise_Made_On__c = System.Today();
                        objtempptp.ScCollection_PTP_AutoNumber__c = 'P' + String.valueof(counter);
                        if(objcontract != Null && strObjectName == 'loan__Loan_Account__c')
                        {
                            objtempptp.collect__Loan_Account_Id__c = objcontract.Id;
                            objtempptp.ScCollection_CL_Contract__c = objcontract.Id;
                        }
                        else if(objcontract != Null && strObjectName == 'collect__Loan_Account__c')
                        {
                            objtempptp.collect__Dev_Contract__c = objcontract.Id;
                        }
                        counter++;
                    }

                    if(!Test.isRunningTest())
                    {
                        //call the cls api to create payment arrangement and ptp records
                        collect.Result objresult1  = api1.createPaymentArrangement(objarrangement, lstptp, objcontract, true);
                    
                        ApiResult1 = ScCollection_CommonCodeHandler.processApiResult(objresult1);
                    }
                        
                    if(ApiResult1 == 'ok')
                    {
                        PageReference pr = new PageReference('/apex/ScCollection_CreatePTP?id=' + strContractId + '&ptpid=' + lstptp[0].Id + '&tabid=' + strTabId + '&refresh=1');
                        pr.setRedirect(true);
                        return pr;
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult1));
                        return Null;    
                    }
                            
                }
                else{
                    if(!Test.isRunningTest() && ApiResult1 == 'ok')
                    {
                        //call the cls api to delete payment arrangement and ptp record
                        collect.Result objresult = api1.deletePaymentArrangement(objarrangement, true);
                    
                        ApiResult1 = ScCollection_CommonCodeHandler.processApiResult(objresult);    
                    }
                                    
                    if(ApiResult1 == 'ok')
                    {
                        PageReference pr = new PageReference('/apex/ScCollection_CreatePTP?id=' + strContractId + '&tabid=' + strTabId + '&refresh=0');
                        pr.setRedirect(true);
                        return pr;
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ApiResult1));    
                        return Null;    
                    }
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_PTP_Same_Date_Deletion_Error));    
                return Null;
            }
        }
        
        return Null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the validation checks for promise to pay date
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 11-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public String ValidatePTPDate()
    {
        ScCollection_Settings__c cs = ScCollection_Settings__c.getInstance(UserInfo.getUserId());
        
        Integer maxdays = 0;
        Integer maxfirstday = 0;
        
        if(cs != Null && cs.ScCollection_MaxPromiseDaysCount__c != Null && cs.ScCollection_MaxPromiseDaysCountPromise1__c != Null)
        {
            maxdays = Integer.valueof(cs.ScCollection_MaxPromiseDaysCount__c);
            maxfirstday = Integer.valueof(cs.ScCollection_MaxPromiseDaysCountPromise1__c);
            
            if(objarrangement.ScCollection_PTP_Type__c == 'One-Off')
            {
                if(objptp.ScCollection_Promise_To_Pay_Date__c > System.Today().addDays(maxdays))
                {
                    String errorlbl = Label.ScCollection_PTP_Date_Cap_Error;

                    if(errorlbl.contains('{dynamic}'))
                    {
                        errorlbl = errorlbl.replace('{dynamic}', String.valueOf(maxdays));
                    }
                    
                    return(errorlbl);
                }
                else
                {
                    return('ok');
                }           
            }   
            else if(objarrangement.ScCollection_PTP_Type__c == 'Recurring')
            {
                if(objarrangement.collect__Start_Date__c <= System.Today().addDays(maxfirstday))
                {
                    Date startdate = objarrangement.collect__Start_Date__c;
                    Boolean isLastDay = false;                 
                    Integer firstDate = startdate.day();
                    Integer numberOfDaysFirst = Date.daysInMonth(startdate.year(), startdate.month());
                    if(numberOfDaysFirst == startdate.day()){
                        isLastDay = true;
                    }
                                
                    for(Integer i = 1; i < objarrangement.collect__Frequency__c; i++)
                    {    
                        if(objarrangement.collect__Occurence__c == 'Monthly')
                        {
                            if(isLastDay){
                                Integer intMonth = startdate.month() + 1;
                                Integer numberOfDays = Date.daysInMonth(startdate.year(), intMonth);
                                startdate = Date.newInstance(startdate.year(), intMonth, numberOfDays);
                            }
                            else{
                                //startdate = startdate.addMonths(1);
                                Date addDates = startdate.addMonths(1);
                                if(addDates.Day() != firstDate && addDates.Month() != 2){
                                    startdate = Date.newInstance(addDates.year(), addDates.Month(), firstDate);
                                }
                                else{
                                    startdate = addDates;
                                }
                            }
                        }
                        else if(objarrangement.collect__Occurence__c == 'Fortnightly')
                        {
                            startdate = startdate.addDays(14);
                        }
                        else if(objarrangement.collect__Occurence__c == 'Weekly')
                        {
                            startdate = startdate.addDays(7);
                        }
                    }
                    
                    if(startdate <= system.Today().addDays(maxdays))
                    {
                        objarrangement.collect__End_Date__c = startdate;
                        
                        return('ok');
                    }
                    else
                    {
                        String errorlbl = Label.ScCollection_PTP_Last_Date_Cap_Error;

                        if(errorlbl.contains('{dynamic}'))
                        {
                            errorlbl = errorlbl.replace('{dynamic}', String.valueOf(maxdays));
                        }
                        
                        return(errorlbl);
                    }
                }
                else
                {
                    String errorlbl = Label.ScCollection_PTP_First_Date_Cap_Error;

                    if(errorlbl.contains('{dynamic}'))
                    {
                        errorlbl = errorlbl.replace('{dynamic}', String.valueOf(maxfirstday));
                    }
                    
                    return(errorlbl);
                }
            }   
        }
        else
        {
            return('Error :  Global settings not defined for Max Days Promise settings.');    
        }
                 
        return null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles the validation checks for promise to pay amount
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 11-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public String ValidatePTPAmount()
    {
        ScCollection_Settings__c cs = ScCollection_Settings__c.getInstance(UserInfo.getUserId());
        
        Decimal minpercent = 0.0;
        Decimal minamount = 0.0;
        
        if(cs != Null && cs.ScCollection_MinAcceptCommitment__c != Null)
        {
            minpercent = cs.ScCollection_MinAcceptCommitment__c;
            minamount = (minpercent/100)*(Decimal.valueof(strTotalArrears)-Decimal.valueof(strPromiseAmount));
            minamount = minamount.setScale(2);
            
            if(objarrangement.ScCollection_PTP_Type__c == 'One-Off')
            {
                if(objptp.ScCollection_Promise_To_Pay_Amount__c < minamount)
                {
                    String errorlbl = Label.ScCollection_PTP_Amount_Cap_Error;

                    if(errorlbl.contains('{dynamic}'))
                    {
                        errorlbl = errorlbl.replace('{dynamic}', String.valueOf(minamount));
                    }
                    
                    return(errorlbl);
                }
                else
                {
                    return('ok');
                }           
            }   
            else if(objarrangement.ScCollection_PTP_Type__c == 'Recurring')
            {
                if(objarrangement.collect__Arrangement_Amount__c < minamount)
                {
                    String errorlbl = Label.ScCollection_PTP_Amount_Cap_Error;

                    if(errorlbl.contains('{dynamic}'))
                    {
                        errorlbl = errorlbl.replace('{dynamic}', String.valueOf(minamount));
                    }
                    
                    return(errorlbl);
                }
                else
                {
                    return('ok');
                }
            }   
        }
        else
        {
            return('Error :  Global settings not defined for Min Commitment % settings.');    
        }
                 
        return null;
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for p2p type change on vf page.
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void changePTPType()
    {
        showOneOff = false;
        showRecurring = false;
        objarrangement.ScCollection_Payment_Method__c = null;
        objarrangement.collect__Frequency__c = null;
        objarrangement.collect__Arrangement_Amount__c = null;
        objarrangement.collect__Occurence__c = null;
        objarrangement.collect__Start_Date__c = null;
        objptp.ScCollection_Promise_To_Pay_Date__c = null;
        objptp.ScCollection_Promise_To_Pay_Amount__c = null;
        lstptp = new List<collect__Promise_To_Pay__c>();
        
        if(objarrangement.ScCollection_PTP_Type__c == 'One-Off')
        {
            showOneOff = true;
        }
        else if(objarrangement.ScCollection_PTP_Type__c == 'Recurring')
        {
            showRecurring = true;
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the logic for deleting p2p record
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void DeletePTP()
    {
        if(strIndex != '' && lstptp.size() > 1)
        {
            if(lstptp[Integer.valueof(strIndex)].Id != null)
            {
                if(lstptp[Integer.valueof(strIndex)].ScCollection_Promise_To_Pay_Date__c != System.Today())
                {
                    Decimal PtpNewAmount = 0.0;
                    Decimal PtpOldAmount = 0.0;
                    Date startDate = System.Today();
                    Date endDate = System.Today();

                    Integer counter = 0;

                    for(collect__Promise_To_Pay__c obj : lstptp)
                    {
                        if(strIndex == '0')
                        {
                            if(counter == 1)
                            {
                                startDate = obj.ScCollection_Promise_To_Pay_Date__c;
                            }
                        }
                        else
                        {
                            if(counter == 0)
                            {
                                startDate = obj.ScCollection_Promise_To_Pay_Date__c;    
                            }
                        }

                        if(Integer.valueof(strIndex) != counter)
                        {
                            PtpNewAmount += obj.ScCollection_Promise_To_Pay_Amount__c;    
                            endDate = obj.ScCollection_Promise_To_Pay_Date__c;
                        }
                        
                        PtpOldAmount += obj.collect__Promise_To_Pay_Amount__c;
                        counter++;
                    }
                    
                    Decimal minpercent = 0.0;
                    Decimal minamount = 0.0;
                    Integer maxfirstday = 0;

                    ScCollection_Settings__c cs = ScCollection_Settings__c.getInstance(UserInfo.getUserId());
                    
                    minpercent = cs.ScCollection_MinAcceptCommitment__c;
                    maxfirstday = Integer.valueof(cs.ScCollection_MaxPromiseDaysCountPromise1__c);

                    if(startDate <= System.Today().addDays(maxfirstday))
                    {
                        minamount = (minpercent/100)*((Decimal.valueof(strTotalArrears)-Decimal.valueof(strPromiseAmount)) + PtpOldAmount);
                        minamount = minamount.setScale(2);

                        if(PtpNewAmount >= minamount)
                        {
                            lstptpToRemove.add(lstptp[Integer.valueof(strIndex)]);
                            setdeleteptp.add(lstptp[Integer.valueof(strIndex)].Id);
                            lstptp.remove(Integer.valueof(strIndex));
                            objarrangement.collect__Start_Date__c = startDate;
                            objarrangement.collect__Frequency__c = lstptp.size();
                            objarrangement.collect__Arrangement_Amount__c = PtpNewAmount;
                            objarrangement.collect__End_Date__c = endDate;
                        }
                        else
                        {
                            String errorlbl = Label.ScCollection_PTP_Min_Amount_Error;
                            if(errorlbl.contains('{dynamic}'))
                            {
                                errorlbl = errorlbl.replace('{dynamic}', String.valueOf(minamount));
                            }
                            
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorlbl));
                        }
                    }
                    else
                    {
                        String errorlbl = Label.ScCollection_PTP_First_Date_Cap_Error;

                        if(errorlbl.contains('{dynamic}'))
                        {
                            errorlbl = errorlbl.replace('{dynamic}', String.valueOf(maxfirstday));
                        }
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorlbl));
                    }
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ScCollection_PTP_Same_Date_Deletion_Error));
                }
            }
            else
            {
                Decimal PtpNewAmount = 0.0;
                Date startDate = System.Today();
                Date endDate = System.Today();

                Integer counter = 0;

                for(collect__Promise_To_Pay__c obj : lstptp)
                {
                    if(strIndex == '0')
                    {
                        if(counter == 1)
                        {
                            startDate = obj.ScCollection_Promise_To_Pay_Date__c;
                        }
                    }
                    else
                    {
                        if(counter == 0)
                        {
                            startDate = obj.ScCollection_Promise_To_Pay_Date__c;    
                        }
                    }

                    if(Integer.valueof(strIndex) != counter)
                    {
                        PtpNewAmount += obj.ScCollection_Promise_To_Pay_Amount__c;    
                        endDate = obj.ScCollection_Promise_To_Pay_Date__c;
                    }

                    counter++;
                }
                
                Decimal minpercent = 0.0;
                Decimal minamount = 0.0;
                Integer maxfirstday = 0;
                
                ScCollection_Settings__c cs = ScCollection_Settings__c.getInstance(UserInfo.getUserId());

                minpercent = cs.ScCollection_MinAcceptCommitment__c;
                maxfirstday = Integer.valueof(cs.ScCollection_MaxPromiseDaysCountPromise1__c);
                
                if(startDate <= System.Today().addDays(maxfirstday))
                {
                    minamount = (minpercent/100)*(Decimal.valueof(strTotalArrears)-Decimal.valueof(strPromiseAmount));
                    minamount = minamount.setScale(2);
                    
                    if(PtpNewAmount >= minamount)
                    {
                        lstptp.remove(Integer.valueof(strIndex));
                        objarrangement.collect__Start_Date__c = startDate;
                        objarrangement.collect__Frequency__c = lstptp.size();
                        objarrangement.collect__Arrangement_Amount__c = PtpNewAmount;
                        objarrangement.collect__End_Date__c = endDate;
                    }
                    else
                    {
                        String errorlbl = Label.ScCollection_PTP_Min_Amount_Error;
                        if(errorlbl.contains('{dynamic}'))
                        {
                            errorlbl = errorlbl.replace('{dynamic}', String.valueOf(minamount));
                        }
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorlbl));
                    }
                }
                else
                {
                    String errorlbl = Label.ScCollection_PTP_First_Date_Cap_Error;

                    if(errorlbl.contains('{dynamic}'))
                    {
                        errorlbl = errorlbl.replace('{dynamic}', String.valueOf(maxfirstday));
                    }
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorlbl));
                }
            }
        }
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          SyncDirectDebit
    Company:       Saasfocus
    Description:   This method is used to sync Promise to Pay record in the source system.
    Inputs:        String,String,String,String,String,String,String,Date,DateTime
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    public String SyncDirectDebit(collect__Payment_Arrangement__c objPaymentArrangement,List<collect__Promise_To_Pay__c> lstPromiseToPay){
        
        String strPafDD = 'CreateDirectDebitPAF';
        ScCollection_PaymentAPIParameters__c objCredential;
        
        User ObjUsr = [Select Id,Email,Name,FirstName,LastName From User where Id = :UserInfo.GetUserID()];
        
        String strUserName = '';
        if(!String.IsBlank(ObjUsr.FirstName)){
            strUserName = ObjUsr.FirstName.substring(0,1);
        }
        strUserName += ObjUsr.LastName;
        Integer userNameSize = strUserName.Length();
        if(userNameSize > 20){
            strUserName = strUserName.substring(0,20);
        }
        
        String strTodaysdate = System.Now().format('yyyy-MM-dd');
        
        Decimal paymentAmount = lstPromiseToPay[0].ScCollection_Promise_To_Pay_Amount__c;
        
        String frequencyType = 'Monthly';
        if(objPaymentArrangement.ScCollection_PTP_Type__c == 'Recurring'){
            frequencyType = objPaymentArrangement.collect__Occurence__c;
        }
        
        String effectiveDate = DateTime.newInstance(objPaymentArrangement.collect__Start_Date__c.Year(), objPaymentArrangement.collect__Start_Date__c.Month(),objPaymentArrangement.collect__Start_Date__c.Day()).format('yyyy-MM-dd');
        
        Integer numberOfPayments = Integer.valueOf(objPaymentArrangement.collect__Frequency__c);
        
        
        //creating wrapper obj
        DirectDebitCreateWrapper.AuditInformation objAuditInfo = new DirectDebitCreateWrapper.AuditInformation(strUserName,strTodaysdate);
        
        DirectDebitCreateWrapper.PaymentInformation objPaymentInfo = new DirectDebitCreateWrapper.PaymentInformation(paymentAmount,frequencyType,effectiveDate,numberOfPayments,null,null,null);      
        
        DirectDebitCreateWrapper objSyncDDWrapper = new DirectDebitCreateWrapper();
        objSyncDDWrapper.auditInformation = objAuditInfo;
        objSyncDDWrapper.paymentInformation = objPaymentInfo;
        
        String strRequestBody = JSON.serialize(objSyncDDWrapper);
        
        System.debug('strRequestBody '+strRequestBody);
        
        objCredential = ScCollection_PaymentAPIParameters__c.getValues(strPafDD);
        
        if(!String.IsBlank(strRequestBody) && objCredential != null){
            try{
                String strEndPoint = objCredential.Endpoint__c;
                strEndPoint = strEndPoint.replace('{loanID}',strContractName);
                Http objhttp = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(strEndPoint);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objCredential.Username__c+ ':' + objCredential.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('request-id', ScCollection_CommonCodeHandler.GenerateUniqueRandomNumber());
                req.setTimeout(120000);
                req.setBody(strRequestBody);
                HttpResponse res = objhttp.send(req);
                
                system.debug('Response =='+res);
                if(res.getStatusCode() == 200){
                    return 'ok';
                }
                else{
                    if(res.getStatusCode() == 504){
                        return 'Critical Error – Sync Failure';
                    }
                    if(res.getStatusCode() == 404){
                        return '404 resource not found.';
                    }
                    else{
                        system.debug('response Error Body =='+res.getBody());
                        String apiResponse =  res.getBody();
                        String strResError = 'Some error has occurred, please contact you\'r System Admin.';
                        ScCollection_CreatePTPController objErrorResponse = ScCollection_CreatePTPController.parse(apiResponse);
                        if(objErrorResponse != null && objErrorResponse.errors != null && objErrorResponse.errors.Size() > 0){
                            
                            String strErrorMess = '';
                            for(Error objError : objErrorResponse.errors){
                                strErrorMess += objError.description + ' ';
                            }
                            if(!String.isBlank(strErrorMess)){
                                strResError = 'Error !! '+strErrorMess;
                            }
                            return strResError;
                        }
                        return strResError;
                    }
                }
            }
            catch(Exception ex){
                system.debug(ex.getStackTraceString());
                return ex.getMessage();
            }
        }
        
        return 'Some Error has occured in the process. Please check the Custom setting or contact system admin.';
    }
    
    
    public ErrorResponse deleteDirectDebit(collect__Payment_Arrangement__c objPaymentArrangement,List<collect__Promise_To_Pay__c> lstPromiseToPay){
        
        ErrorResponse objErrorRes = new ErrorResponse();
        if(!ScCollection_CommonCodeHandler.triggerExectionCheck('ScCollection_Delete_Direct_Debit_Paf')){
            objErrorRes.isTrue = true;
            objErrorRes.message = 'Execution Custom Setting is disabled. Contact your System Admin.';
            return objErrorRes;
        }
        
        String strDeleteDD = 'DeleteDirectDebitPAF';
        ScCollection_PaymentAPIParameters__c objCredential;
        
        User ObjUsr = [Select Id,Email,Name,FirstName,LastName From User where Id = :UserInfo.GetUserID()];
        String strUserName = '';
        if(!String.IsBlank(ObjUsr.FirstName)){
            strUserName = ObjUsr.FirstName.substring(0,1);
        }
        strUserName += ObjUsr.LastName;
        Integer userNameSize = strUserName.Length();
        if(userNameSize > 20){
            strUserName = strUserName.substring(0,20);
        }
        
        
        String strTodaysdate = System.Now().format('yyyy-MM-dd');
        
        map<String,collect__Promise_To_Pay__c> mapDateToPTP = new map<String,collect__Promise_To_Pay__c>();
        lspPTPNotDeleted = new List<collect__Promise_To_Pay__c>();
        
        List<String> lstStrDates = new List<String>();
        for(collect__Promise_To_Pay__c objPromiseToPay : lstPromiseToPay){
            String strdates = DateTime.newInstance(objPromiseToPay.collect__Promise_To_Pay_Date__c.Year(), objPromiseToPay.collect__Promise_To_Pay_Date__c.Month(),objPromiseToPay.collect__Promise_To_Pay_Date__c.Day()).format('yyyy-MM-dd');
            lstStrDates.add(strdates);
            mapDateToPTP.put(strdates,objPromiseToPay);
        }
        
        Decimal paymentAmount = lstPromiseToPay[0].ScCollection_Promise_To_Pay_Amount__c;
        //creating wrapper obj
        DirectDebitCreateWrapper.AuditInformation objAuditInfo = new DirectDebitCreateWrapper.AuditInformation(strUserName,strTodaysdate);
        
        DirectDebitCreateWrapper.PaymentInformation objPaymentInfo = new DirectDebitCreateWrapper.PaymentInformation(paymentAmount,null,null,null,null,null,lstStrDates); 
        
        DirectDebitCreateWrapper objSyncDDWrapper = new DirectDebitCreateWrapper();
        objSyncDDWrapper.auditInformation = objAuditInfo;
        objSyncDDWrapper.paymentInformation = objPaymentInfo;
        
        String strRequestBody = JSON.serialize(objSyncDDWrapper);
        
        System.debug('strRequestBody '+strRequestBody);
        objCredential = ScCollection_PaymentAPIParameters__c.getValues(strDeleteDD);
        
        if(!String.IsBlank(strRequestBody) && objCredential != null){
            try{
                String strEndPoint = objCredential.Endpoint__c;
                strEndPoint = strEndPoint.replace('{loanID}',strContractName);
                Http objhttp = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(strEndPoint);
                req.setMethod('POST');
                Blob headerValue = Blob.valueOf(objCredential.Username__c+ ':' + objCredential.Password__c);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('request-id', ScCollection_CommonCodeHandler.GenerateUniqueRandomNumber());
                req.setTimeout(120000);
                req.setBody(strRequestBody);
                HttpResponse res = objhttp.send(req);
                System.debug('req '+req);
                
                String apiResponse =  res.getBody();
                system.debug('apiResponse == '+apiResponse);
                
                
                String strMessage = '';
                if(res.getStatusCode() == 207){
                    List<ScCollection_CreatePTPController> lstResponse = ScCollection_CreatePTPController.parseList(apiResponse);
                    Integer intCount = 0;
                    
                    for(ScCollection_CreatePTPController objResponse : lstResponse){
                        if(!objResponse.success){
                            lspPTPNotDeleted.add(mapDateToPTP.get(objResponse.paymentDate));
                            strMessage = objResponse.errors[0].description + '\n';
                        }
                        else{
                            intCount ++;
                            lstPtpDeleted.add(mapDateToPTP.get(objResponse.paymentDate));
                        }
                        
                    }
                    if(intCount == 0){
                        objErrorRes.isTrue = true;
                        objErrorRes.message = strMessage;
                    }
                    else if(lspPTPNotDeleted.size() > 0){
                        objErrorRes.isTrue = false;
                        objErrorRes.message = String.valueOf (intCount) +' out of '+ String.valueof(lstPromiseToPay.Size())+' Payments were deleted.';
                    }
                    else{
                        objErrorRes.isTrue = false;
                        objErrorRes.message = 'ok';
                    }
                }
                else{
                    objErrorRes.isTrue = true;
                    if(res.getStatusCode() == 504){
                        strMessage = 'Critical Error – Sync Failure';
                    }
                    if(res.getStatusCode() == 404){
                        strMessage = '404 resource not found.';
                    }
                    else{
                        ScCollection_CreatePTPController objSingleResponse = ScCollection_CreatePTPController.parse(apiResponse);
                        
                        for(Error err : objSingleResponse.errors){
                            strMessage = err.description + '\n';
                        }
                    }
                    objErrorRes.message = strMessage;
                }
            }
            catch(Exception ex){
                system.debug(ex.getStackTraceString());
                objErrorRes.isTrue = true;
                objErrorRes.message = ex.getMessage();
            }   
        }
        else{
            objErrorRes.isTrue = true;
            objErrorRes.message = 'Some Error has occured in the process. Please check the Custom setting or contact system admin.';
        }
        return objErrorRes;
        
    }
    
    public class ErrorResponse{
        public boolean isTrue;
        public String message;
    }
    
    
    
    public String paymentDate;
    public Boolean success;
    public String errorType;    //inputValidation
    public Error[] errors;
    public class Error {
        public String category;   ///definitions/paymentInformationDef/properties/effectiveDate
        public String description;  //pattern
        public String pointerToViolation;
    }
    public static ScCollection_CreatePTPController parse(String json){
        return (ScCollection_CreatePTPController) System.JSON.deserialize(json, ScCollection_CreatePTPController.class);
    }
    
    public static List<ScCollection_CreatePTPController> parseList(String json){
        return (List<ScCollection_CreatePTPController>) System.JSON.deserialize(json, List<ScCollection_CreatePTPController>.class);
    }
    
    // this method would sort the audit history list as per created date
    public void sortPTPList()
    {
        Integer n = lstptp.size();
        Integer k;
        
        for(Integer m = n; m > 0; m--) 
        {
            for(Integer i = 0; i < n - 1; i++) 
            {
                k = i + 1;
                if(lstptp[i].ScCollection_Promise_To_Pay_Date__c > lstptp[k].ScCollection_Promise_To_Pay_Date__c) 
                {
                    collect__Promise_To_Pay__c tmep;
                    tmep = lstptp[i];
                    lstptp[i] = lstptp[k];
                    lstptp[k] = tmep;
                }
            }
        }
        
    }
}