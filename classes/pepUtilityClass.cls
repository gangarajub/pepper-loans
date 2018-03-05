//-------------------------------------------------------------------------------------------------
// This class Contains utility methods
// -------------------------------------------------------------------------------------------------
// Created Date: 23-FEB-2016 Created By: Amit Kumar Email: amit.kumar@saasfocus.com
// -------------------------------------------------------------------------------------------------
public  class pepUtilityClass 
{
    //This method takes Loan Amount ,interest rate,tenure and payment frequecny as Input
    //This method calls a method takes interest rate and payment frequency as input and then 
    //calculates the interest rate for that period
    //This method calls a method loan tenure and payment freqency and then calculate number of payments for that tenure
    //It then calculates EMI based on the above input
    public static decimal calculateLoanEmi(Decimal decLoanAmount,Decimal decInterestRate, decimal decTenure,String strPaymentFrequency)
    {
        Decimal decLoanEmiAmount =  0;      
        Integer intNoOfpayments  =  0;    
        decInterestRate = calculateInterestRateBasedOnPaymentFrequency(decInterestRate,strPaymentfrequency);       
        intNoOfpayments = calculateNoOfPaymentsBasedOnpaymentFrequency(decTenure,strPaymentFrequency);    
        System.debug('decInterestRate '+decInterestRate );
        System.debug('intNoOfpayments  '+intNoOfpayments  );
        
        if(decLoanAmount != null && decInterestRate  != null && intNoOfpayments !=null)
        {
            decLoanEmiAmount  = (decLoanAmount*decInterestRate*(1+decInterestRate).pow(intNoOfpayments))/((1+decInterestRate).pow(intNoOfpayments)-1);
        }
        
        return decLoanEmiAmount;
    }
    
    private  static decimal calculateInterestRateBasedOnPaymentFrequency(decimal decInterestRate,string strPaymentfrequency)
    {
        decimal decInterestRateForPeriod;
        if(strPaymentFrequency != null && decInterestRate != null)
        {
            if(strPaymentFrequency.toLowercase() == 'daily')
            {               
                decInterestRateForPeriod  = decInterestRate/(365*100);
            } 
            if(strPaymentFrequency.toLowercase() == 'quarterly')
            {               
                decInterestRateForPeriod    = decInterestRate/(4*100);
            } 
            if(strPaymentFrequency.toLowercase() == 'monthly')
            {               
                decInterestRateForPeriod    = decInterestRate/(12*100);
            }
            if(strPaymentFrequency.toLowercase() == 'weekly')
            {               
                decInterestRateForPeriod  = decInterestRate/(52*100);
            }       
            if(strPaymentFrequency.toLowercase() == 'fortnightly')
            {               
                decInterestRateForPeriod  = decInterestRate/(26*100);
            }
            if(strPaymentFrequency.toLowercase() == 'annually')
            {               
                decInterestRateForPeriod  = decInterestRate/(1*100);
            }   
        }
        return decInterestRateForPeriod;
    }
    
    
    public static Integer calculateNoOfPaymentsBasedOnpaymentFrequency(decimal decTenure,string strPaymentfrequency)
    {
        Integer intNoOfpayments;
        if(strPaymentFrequency.toLowercase() == 'daily')
        {               
            intNoOfpayments    = Integer.valueOF(decTenure*365);
        } 
        if(strPaymentFrequency.toLowercase() == 'quarterly')
        {
            intNoOfpayments    = Integer.valueOF(decTenure*4);            
        } 
        if(strPaymentFrequency.toLowercase() == 'monthly')
        {
            intNoOfpayments    = Integer.valueOF(decTenure*12);            
        }
        if(strPaymentFrequency.toLowercase() == 'weekly')
        {
            intNoOfpayments  = Integer.valueOF(decTenure*52);            
        }       
        if(strPaymentFrequency.toLowercase() == 'fortnightly')
        {
            intNoOfpayments  = Integer.valueOF(decTenure*26);            
        }
        if(strPaymentFrequency.toLowercase() == 'annually')
        {
            intNoOfpayments  = Integer.valueOF(decTenure*1);            
        }
        return intNoOfpayments;
    }
    
    //Below method will fetch fields API list as per object list passed on to method parameter
    //And after that it will fetch applications/contact/account and all child object data from the system.
    // -------------------------------------------------------------------------------------------------
    // Created Date: 24-FEB-2016 Created By: Vipin Kumar Email: vipin.kumar@saasfocus.com
    // -------------------------------------------------------------------------------------------------
    
    public static list<genesis__Applications__c> fetchApplicationAndChild(String[] lstTypes,String fieldSetName,String borrowerId,String applicationId,String allowedStatuses){
        
        list<genesis__Applications__c> lstAppication=new list<genesis__Applications__c>();
        
        if((applicationId!=null && applicationId!='') || (borrowerId!=null && borrowerId!=''))
        {
            
            set<String> setTypes=new set<String>();
            setTypes.addAll(lstTypes);
            
            Map<String,String> mapAPIList=new Map<String,String>();
            
            
            // For each object, get field API
            for(integer i=0;i<lstTypes.size();i++) {
                
                String strAPIs=readFieldSet(fieldSetName,lstTypes[i]);
                mapAPIList.put(lstTypes[i],strAPIs);
            }
            system.debug('mapAPIList=='+mapAPIList);    
            
            Map<String,String> childObjects = new Map<String,String>();
            for(Schema.ChildRelationship cr : genesis__Applications__c.SObjectType.getDescribe().getChildRelationships()){
                if(setTypes.contains((String.valueOf(cr.getChildSObject()))))
                {
                    System.debug(cr.getChildSObject() + '.' + cr.getField() + ' reversed is: ' + cr.getRelationshipName());
                    childObjects.put(String.valueOf(cr.getRelationshipName()),mapAPIList.get(String.valueOf(cr.getChildSObject())));
                }
                
            }
            system.debug('childObjects=='+childObjects);
            lstAppication=pepInvokeCLMethodHelper.fetchApplications(borrowerId,applicationId,allowedStatuses,mapAPIList.get('genesis__Applications__c'),childObjects);
            system.debug('app=='+lstAppication[0].Residential_Address__r);
        }
        return lstAppication;
    }
    
    //It fetch Field API related to a fieldset and object name.
    // -------------------------------------------------------------------------------------------------
    // Created Date: 28-FEB-2016 Created By: Vipin Kumar Email: vipin.kumar@saasfocus.com
    // -------------------------------------------------------------------------------------------------
    public  static String readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
        List<String> lstFieldAPI=new List<String>();
        string strAPI;
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        {
            lstFieldAPI.add(fieldSetMemberObj.getFieldPath());
        }        
        if (lstFieldAPI.size()>0) strAPI = string.join(lstFieldAPI,',');
        system.debug('strAPI=='+strAPI);
        
        return strAPI;
    }
    //This method generate retrieve code
    public static string createRetrievalCode(String strPreviousCode)
    {
        string strStartInt='1';
        string strStartChar='A';
        string strNewCodeInt;
        string strNewCodeString;
        string strPreviousCodeInt;
        string strPreviousCodeString;
        string strNewCode;
        string strTemp;
        Integer intPrevious;
        if(strPreviousCode!=null && strPreviousCode!='')
        {
            strPreviousCode=strPreviousCode.substring(0,strPreviousCode.length() - 2);
            strPreviousCodeInt=strPreviousCode.substring(3,6);
            system.debug('strPreviousCodeInt--'+strPreviousCodeInt);
            
            strPreviousCodeString=strPreviousCode.substring(0,3);
            system.debug('strPreviousCodeString--'+strPreviousCodeString);
        }
        else
        {
            strNewCode='AAA000';
        }
        if(strPreviousCodeInt!=null &&strPreviousCodeString!=null)
        {
            intPrevious=Integer.valueOf(strPreviousCodeInt);
            system.debug('intPrevious--'+intPrevious);
            if(intPrevious!=999) 
            {
                Integer len=String.valueOf(intPrevious+1).length();
                if(len==1) strNewCodeInt='00'+String.valueOf(intPrevious+1);
                else if(len==2) strNewCodeInt='0'+String.valueOf(intPrevious+1);
                else if(len==3) strNewCodeInt=String.valueOf(intPrevious+1);
                strNewCode=strPreviousCodeString + strNewCodeInt;
            }
            else if(intPrevious==999)
            {   
                strNewCodeInt='000';
                Integer charLast=strPreviousCodeString.charAt(2);
                Integer charSec=strPreviousCodeString.charAt(1);
                Integer charFirst=strPreviousCodeString.charAt(0);
                if(charLast<90) 
                {
                    strNewCodeString=strPreviousCodeString.subString(0,2)+ String.fromCharArray( new List<integer> { charLast+1 } );
                }
                else if(charSec<90 && charLast==90)
                {
                    strNewCodeString=strPreviousCodeString.subString(0,1)+ String.fromCharArray( new List<integer> { charSec+1 } )+'A';
                }
                else if(charFirst<90 && charSec==90 && charLast==90)
                {
                    strNewCodeString=String.fromCharArray( new List<integer> { charFirst+1 } )+'AA';
                }
                strNewCode=strNewCodeString+strNewCodeInt;
            }
        }
        String strTimeStamp=String.valueOf(DateTime.now().getTime());
        String strStamp=strTimeStamp.substring(strTimeStamp.length() - 2,strTimeStamp.length());
        system.debug('timestamp : '+ strStamp);
        strNewCode=strNewCode+strStamp;
        return strNewCode;
    }
    
    
    public static id getRecordTypeId(string strObjectApiName, string strRecordTypeName)
    {
        Map<String, Schema.SObjectType> mapSObjectSchema;
        // if the object API name is blank or the record type name is blank, return null
        if(IsNullOrEmptyString(strObjectApiName) || IsNullOrEmptyString(strRecordTypeName)){
            return null;
        }
        // if sobjectSchemaMap is null then assign values to it by getGloblaDescribe()
        if(mapSObjectSchema == null) {
            mapSObjectSchema = Schema.getGlobalDescribe();
        }
        // get the describe object result based on given object API Name
        Schema.SObjectType sObjType = mapSObjectSchema.get(strObjectApiName) ;
        Schema.DescribeSObjectResult cfrSchema = sObjType.getDescribe() ;
        // get the map of recordtype info
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        // get the record type id based on given record type name
        Id idRecordType = RecordTypeInfo.get(strRecordTypeName).getRecordTypeId();
        return idRecordType;
    }
    
    // This Static method is used to validate null or Empty String 
    // -----------------------------------------------------------------------------------------------------------------
    // INPUT PARAMETERS:    - string    - strInput
    // -----------------------------------------------------------------------------------------------------------------
    // RETURNS:             - boolean   - true/false
    // -----------------------------------------------------------------------------------------------------------------
    // Version#     Date                    Author                          Description
    // -----------------------------------------------------------------------------------------------------------------
    // 1.0         16-Mar-2016              Amit Kumar                   Initial Version
    // -----------------------------------------------------------------------------------------------------------------
    public static boolean IsNullOrEmptyString(string strInput)
    {
        if(strInput == null || strInput.equals('')){
            return true;
        }
        return false;
    }
    
    // This method is used to get the account id of currently logged in user.
    
    public static String getAccountId()
    {
        String accountId;
        List<User> lstUser = [Select Id,AccountId from User where Id = :UserInfo.getUserId()];
        if(lstUser != null && lstUser.size() > 0 && lstUser[0].AccountId!=null )
        {
            System.debug('lstUser[0].AccountId::' + lstUser[0].AccountId);
            List<Account> referredByAcc=[select id,Name from account where id= :lstUser[0].AccountId];
            accountId = referredByAcc[0].id;
        } 
        return accountId;
    }
    
    // This method is used to get the loan account id from Account.
    
    public static String getLoanAccountId(String accountId)
    {
        String loanAccountId;
        if (string.isNotBlank(accountId))
        {
            loanAccountId=[select id,Loan_Account_Id__c from account where id=:accountId][0].Loan_Account_Id__c;
        } 
        return loanAccountId;
    }
    
    // This method is used to get the specific loan account and their child object(APS)  corresponding to account id.
    
    public static List<loan__Loan_Account__c> getLoanContract(String loanAccountId)
    {
        List<loan__Loan_Account__c> loanContractList = new List<loan__Loan_Account__c>();
        
        if (string.isNotBlank(loanAccountId))
        {
            Map<String,String> ChildObjectMap = new Map<String,String>();
            String ChildObjectFields='loan__Transaction_Amount__c,loan__Debit_Date__c,loan__Active__c,loan__Frequency__c,loan__Amount_Type__c,loan__Bank_Account__c,';
            ChildObjectFields +='loan__CL_Contract__c,loan__Debit_Day__c,loan__Frequency_Cycle__c,loan__Payment_Mode__c,loan__Recurring_ACH_End_Date__c,loan__Recurring_ACH_Start_Date__c,';
            ChildObjectFields +='loan__Second_Debit_Date__c,loan__Setup_Date__c,loan__Type__c';
            ChildObjectMap.put('loan__Automated_Payment_Setup__r',ChildObjectFields);
            loanContractList = RetrieveLoanAccounts.getLoanContracts(null,loanAccountId,null,null,ChildObjectMap );
            system.debug('listValueIs'+loanContractList);
        }
        return loanContractList ;      
    }
    
    // This method is used to get loan account and their child object(APS)  corresponding to account id. 
    
    public static List<loan__Loan_Account__c> getAllLoanContract(String accountId)
    {
        List<loan__Loan_Account__c> loanContractList = new List<loan__Loan_Account__c>();
        
        if (string.isNotBlank(accountId))
        {
            Map<String,String> ChildObjectMap = new Map<String,String>();
            String ChildObjectFields='loan__Transaction_Amount__c,loan__Debit_Date__c,loan__Active__c,loan__Frequency__c,loan__Amount_Type__c,loan__Bank_Account__c,';
            ChildObjectFields +='loan__CL_Contract__c,loan__Debit_Day__c,loan__Frequency_Cycle__c,loan__Payment_Mode__c,loan__Recurring_ACH_End_Date__c,loan__Recurring_ACH_Start_Date__c,';
            ChildObjectFields +='loan__Second_Debit_Date__c,loan__Setup_Date__c,loan__Type__c';
            ChildObjectMap.put('loan__Automated_Payment_Setup__r',ChildObjectFields);
            loanContractList = RetrieveLoanAccounts.getLoanContracts(accountId,null,null,null,ChildObjectMap );
            system.debug('listValueIs'+loanContractList);
        }
        return loanContractList ;      
    }
    
    public static List<loan__Automated_Payment_Setup__c> getActiveAutomatedPaymentSetup(String ContractId)
    {
        List<loan__Automated_Payment_Setup__c> lstAPS = new List<loan__Automated_Payment_Setup__c>();
        List<loan__Automated_Payment_Setup__c> lstActiveAPS = new List<loan__Automated_Payment_Setup__c>();
        LoanActions action = new LoanActions();
        Boolean isActive = true;
        
        if (string.isNotBlank(ContractId))
        {
            lstAPS = action.getAPSHistory(ContractId,isActive);
            
            if(lstAPS != null && lstAPS.size() > 0)
            {
                for(loan__Automated_Payment_Setup__c objAPS: lstAPS)
                {
                    if(objAPS.loan__Type__c == 'ONE TIME')
                    {
                        lstActiveAPS.add(objAPS);
                    }
                }
            }
            system.debug('listValueIs'+lstActiveAPS);
        }
        
        return lstActiveAPS ;      
    }
    
    Public Static Pagereference checkCookieAndRedirect(){
        if(ApexPages.currentPage().getcookies().get('ApplicationId') != null){
            
            if(ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != null && ApexPages.currentPage().getcookies().get('ApplicationId').getvalue() != '')
                return null;
            return new Pagereference(''+Label.CookieRedirect).setRedirect(True);
        } 
        else{
            return new Pagereference(''+Label.CookieRedirect).setRedirect(True);
        }
    }
    
    // This method is used to page name from custom setting.
    
    public static String getNavigationPageName(String strName)
    {
        System.debug('sandip=='+strName);
        Application__c objCustomsettings = Application__c.getInstance(strName);
        System.debug('sandip=='+objCustomsettings);
        return objCustomsettings.Navigation_Status__c;
    }
    
    public static string navigateToPage(String navigationStatus)
    {
        list<Application__c> navigationSetting = Application__c.getall().values();       
        for(Application__c navigate : navigationSetting)
        {
            if((navigationStatus!=null && navigationStatus!='' ) && (navigate.Navigation_Status__c.toLowerCase()==navigationStatus.toLowerCase()))
            {
                return navigate.RedirectPage__c;
            }
        }
        return null;   
    }
    
    // This method is called after click on continue button of loan aet up pages to update navigation status of application.
    
    public static genesis__Applications__c  SaveContinueStatus(genesis__Applications__c  objApplication,String pageName)
    {
        Account objAccount = new Account();
        String strNavigationStatusPageName = ''; 
        genesis__Applications__c objApplicationNew;
        //    String pageName=ApexPages.currentPage().getUrl();
        //    pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        if(String.isNotBlank(pageName))
            strNavigationStatusPageName = pepUtilityClass.getNavigationPageName(pageName);
        if(objApplication != null && objApplication.id !=null && string.isnotBlank(strNavigationStatusPageName))
        {
            objApplication.pepNavigation_Status__c = strNavigationStatusPageName; 
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            if(!test.isrunningtest())
                objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
            system.debug('objApplicationResponseIs'+objApplication );
        } 
        
        return objApplicationNew;
        
    }
    
    // This method is called after click on save for later on loan aet up pages to update navigation status of application.
    
    public static genesis__Applications__c  SaveForLater(genesis__Applications__c  objApplication,String pageName)
    {
        Account objAccount = new Account();
        String strNavigationStatusPageName = ''; 
        genesis__Applications__c objApplicationNew;
        //    String pageName=ApexPages.currentPage().getUrl();
        //    pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        if(String.isNotBlank(pageName))
            strNavigationStatusPageName = pepUtilityClass.getNavigationPageName(pageName);
        if(objApplication != null && objApplication.id !=null && string.isnotBlank(strNavigationStatusPageName))
        {
            objApplication.pepNavigation_Status__c = strNavigationStatusPageName; 
            objApplication.Send_SMS__c = True; 
            objApplication.Send_Retrieval_Code__c = True; 
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
            system.debug('objApplicationResponseIs'+objApplication );
        } 
        
        return objApplicationNew;
        
    }
    
    //Added by Varun to update the Last retrieved time each time the Application is retrieved corresponding to the Retrieval code.
    Public static void updateRetrieval(Id Applicationid){
        if(Applicationid != null && String.valueof(Applicationid) != ''){
            genesis__Applications__c app = new genesis__Applications__c(id=Applicationid,pepLastRetrieved__c=System.now());
            update app;
        }
    }
    //Added by Varun to update the Last saved time each time the Aplication is processed or save For Later functionality is used.
    Public static void updateLastsaved(Id Applicationid){
        if(Applicationid != null && String.valueof(Applicationid) != ''){
            genesis__Applications__c app = new genesis__Applications__c(id=Applicationid,pepLastSaved__c=System.now());
            update app;
        }
    }
    //Added by Varun to update the Send Retrieval code checkbox so that retrieval code can be sent through Workflow.
    Public static void sendEmailRetrievalcode(genesis__Applications__c objApplication){
        
        if(objApplication != null && objApplication.id !=null)
        {
            genesis__Applications__c objApplicationNew;
            objApplication.Send_Retrieval_Code__c = True; 
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
        }
        
    }
    
    //Added by Rishabh to update the Send SMS code checkbox so that retrieval code can be sent through Workflow.
    Public static void sendSMSRetrievalcode(genesis__Applications__c objApplication){
        
        if(objApplication != null && objApplication.id !=null)
        {
            genesis__Applications__c objApplicationNew;
            objApplication.Send_SMS__c = True; 
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            objApplicationNew = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
        }
        
    }
    
    Public static void CreateExceptionRecord(String reason,String IntegrationType){
        Exception__c exc = new Exception__c();
        if(reason != null && reason != '')
            exc.Exception_Reason__c=reason;
        if(IntegrationType != null && IntegrationType != '')
            exc.Integration_Type__c=IntegrationType;
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        if(cookieApplicationId !=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')            
            exc.Application__c=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        insert exc;
    }
    
    public class sideBarWrapper
    {
        public  String loanId{get;set;}
        public Transient String loanName{get;set;}
        Public sideBarWrapper(string LoanId,String loanName){
            this.loanId=LoanId;
            this.loanName=loanName;
        }
        Public sideBarWrapper(){
        }
        
    }
    //This method validates the BSB by calling the webservice
    public static String callBSBvalidationWebService(String strBSB)
    {
        
        String strResponse ='';
        try
        {
            if(strBSB != null)
            {
                
                
                strBSB = strbsb.substring(0, 3) + '-' + strbsb.substring(3, strbsb.length());
                pepBSB_WebService_Credentials__c objBSBCreds = pepBSB_WebService_Credentials__c.getValues('Credential');   
                String strEndpoint = objBSBCreds.pepBSB_End_Point__c;
                String strReqKey = objBSBCreds.peprequest_key__c;
                HttpRequest req = new HttpRequest();
                req.setEndpoint(strEndpoint+'?Method=DataTools.Verify.Bsb.AuApca.VerifyBsb&BSB='+strBSB+'&ResultLimit=&RequestId=&RequestKey='+strReqKey+'&DepartmentCode=');
                System.debug('endpoint***'+strEndpoint+'?Method=DataTools.Verify.Bsb.AuApca.VerifyBsb&BSB='+strbsb+'&ResultLimit=&RequestId=&RequestKey='+strReqKey+'&DepartmentCode=');
                req.setMethod('GET');
                req.setHeader('content-type', 'application/json');
                //String body = 'Method=DataTools.Verify.Bsb.AuApca.VerifyBsb&BSB=062-001&ResultLimit=&RequestId=&RequestKey='+strReqKey+'&DepartmentCode=';
                //req.setbody(strBody);
                Http http = new Http();
                String Statuscode;
                HTTPResponse res = new HTTPResponse ();
                if(!test.isRunningTest())
                    res = http.send(req);
                Statuscode = String.valueOf(res.getStatusCode()); 
                strResponse = res.getBody();        
                
                
            }
            else
            {
                strResponse ='BSB is null';
            }
        }
        
        catch(Exception e)
        {
            strResponse = e.getMessage();
        }
        return strResponse;
        
    }
    
    public Static pepBSBWebserviceResponse readBSBXMlResponse(String strResponse)
    {
        pepBSBWebserviceResponse objresponse = new pepBSBWebserviceResponse();
        Xmlstreamreader reader = new Xmlstreamreader(strResponse);
        while(reader.hasNext()) 
        {
            if (reader.getEventType() == XmlTag.START_ELEMENT)
            {
                if ('Result' == reader.getLocalName()) 
                {
                    objresponse.BSB = reader.getAttributeValue(null, 'BSB');
                    objresponse.FinancialInstitutionCode = reader.getAttributeValue(null, 'FinancialInstitutionCode');
                    objresponse.BsbName = reader.getAttributeValue(null, 'BsbName');
                    objresponse.AddressLine = reader.getAttributeValue(null, 'AddressLine');
                    objresponse.Locality= reader.getAttributeValue(null, 'Locality');
                    objresponse.State= reader.getAttributeValue(null, 'State');
                    objresponse.Postcode= reader.getAttributeValue(null, 'Postcode');
                    objresponse.PaymentSystem= reader.getAttributeValue(null, 'PaymentSystem');                   
                    
                }
            }
            reader.next();
        } 
        
        return objresponse;
        
        
    }
    
    Public Static Pagereference HandleRedirectSecurity(){
        
        String pageName=ApexPages.currentPage().getUrl();
        pageName=pageName.substring(pageName.contains('/apex')?6:1,pageName.contains('?')?pageName.indexof('?'):pageName.length());
        pageName = pageName.toLowerCase();
        List<genesis__Applications__c>  lstApplication = new List<genesis__Applications__c>();
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');
        Map<string,string> childobjects = new Map<string,string>();       
        if(cookieApplicationId != null && string.valueof(cookieApplicationId.getValue())!='')
        {
            lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,string.valueof(pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()))),null,null,childobjects );
        }
        
        if(lstApplication!=null && string.isNotBlank(lstApplication[0].pepNavigation_Status__c))
        {
            list<Application__c> navigationSetting = Application__c.getall().values();
            
            for(Application__c navigate : navigationSetting)
            {
                if((string.isNotBlank(pageName)) && (navigate.Navigation_Status__c == lstApplication[0].pepNavigation_Status__c) && ((navigate.Name).toLowerCase()==pageName))
                {
                    return null;
                }
            }
            return new PageReference('/'+pages_config__c.getinstance(pepUtilityClass.navigateToPage(lstApplication[0].pepNavigation_Status__c).toLowerCase()).Page_Label__c);
        } 
        
        //   String redircetPageName= pages_config__c.getinstance('peplandingpage').Page_Label__c;  
        //    Pagereference ref = new Pagereference('/'+redircetPageName); 
        //    return ref.setRedirect(true);
        
        return null;
    }
    
    public static string returnPageName(String pagetoredirect)
    {
        string redircetPageName = '';
        if(pagetoredirect=='1'){
            redircetPageName = pepUtilityClass.getNavigationPageName('pepLoanDetails');
            return redircetPageName;
        }
        else if(pagetoredirect=='2'){
            redircetPageName = pepUtilityClass.getNavigationPageName('pepIncomePage');
            return redircetPageName;
        }
        else if(pagetoredirect=='3'){
            redircetPageName=pepUtilityClass.getNavigationPageName('pepExpensePage');
            return redircetPageName;
        }
        else{
            return redircetPageName ;
        }
        
    }  
    
    Public static void updatebank(){
        Map<string,pepBank_API_Details__c> bankNametoSlugname = new Map<String,pepBank_API_Details__c>();
        List<pepBankinstitution> bankinstitutions = new List<pepBankinstitution>();
        List<pepBank_API_Details__c> newToInsert = new List<pepBank_API_Details__c>();
        List<pepBank_API_Details__c> bankToUpdate = new List<pepBank_API_Details__c>();
        List<pepBank_API_Details__c> lstBank = [select id,pepBank_Name__c,pepBank_Slug_Name__c,pepBank_Short_Name__c,pepImage_URL__c from pepBank_API_Details__c];
        if(lstBank != null && lstBank.size()>0){
            for(pepBank_API_Details__c apiDetail :lstBank){
                if(apidetail.pepBank_Name__c != null){
                    if(!bankNametoSlugname.containskey(apidetail.pepBank_Name__c.tolowercase()))
                        bankNametoSlugname.put(apidetail.pepBank_Name__c.tolowercase(),apiDetail);
                }
            }
        }
        //fetch the login details from custom settings
        pepBank_Statement_Credential__c objBankStatement = pepBank_Statement_Credential__c.getValues('Credential');
        string strEndpoint = objBankStatement.pepEndPoint_Url__c;
        string strApiKey = objBankStatement.pepX_API_KEY__c;
        //create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndpoint+'/institutions');
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('X-API-KEY', strApiKey);
        
        //getting Response     
        Http http = new Http(); 
        HTTPResponse objresponse = new HTTPResponse (); 
        if(!test.isRunningTest())      
            objresponse= http.send(req);
        
        system.debug('objresponse?????' + objresponse.getBody()); 
        string jsonstring=objresponse.getBody();
        jsonstring = objresponse.getBody().replace('"values":""','"values":{"one":1,"two":2,"three":3,"four":4}'); 
        
        jsonstring= jsonstring.replace('"values":{"1":1,"2":2,"3":3,"4":4}','"values":{"one":1,"two":2,"three":3,"four":4}'); 
        System.JSONParser parser = JSON.createParser(jsonstring);
        
        
        
        while (parser.nextToken() != null) 
        {
            system.debug('KKKKKKK***'+parser.getText()); 
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) 
            {
                while (parser.nextToken() != null) 
                {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
                    {
                        
                        pepBankInstitution inv = (pepBankInstitution)parser.readValueAs(pepBankInstitution.class);
                        bankinstitutions.add(inv);
                        
                        
                    }
                }
            }
        }
        if(bankinstitutions != null && bankinstitutions.size()>0){
            for(pepBankinstitution bankInstitution:bankinstitutions){
                if(bankNametoSlugname.containskey(bankInstitution.name.tolowercase())){
                    System.debug('|||||||||||||||||||'+bankInstitution.name.tolowercase());
                    bankNametoSlugname.get(bankInstitution.name.tolowercase()).pepBank_Slug_Name__c=bankInstitution.slug;
                    bankNametoSlugname.get(bankInstitution.name.tolowercase()).Preload_Required__c=bankInstitution.requires_preload=='1'?true:false;
                    bankToUpdate.add(bankNametoSlugname.get(bankInstitution.name.tolowercase()));
                }
                else{
                    System.debug('temp'+bankInstitution.name);
                    pepBank_API_Details__c bankApiDetail = new pepBank_API_Details__c(pepBank_Name__c=bankInstitution.name,pepBank_Slug_Name__c=bankInstitution.slug,pepBank_Short_Name__c=bankInstitution.name);
                    newToInsert.add(bankApiDetail);
                }
            }
        }
        if(bankToUpdate != null && bankToUpdate.size()>0){
            update bankToUpdate;
        }
        if(newToInsert != null && newToInsert.size()>0){
            //insert newToInsert;
        }
    }
    
    // This is used to get the both PAF and PL contract to show in sidebar menu list 
    //and in the contract list of change profile page and contract center page.
    
    public class contractWrapper
    {
        public String loanId{get;set;}
        public String loanName{get;set;}
        public String loanNumber{get;set;}
        public String loanStatus;
        public Date settleDate;
        public Set<id> contractPAF;
        public list<contractWrapper> contractList;
        public Map<date,list<pepUtilityClass.contractWrapper>> cotractMap;
        public List<date>sortList;
        
        // This method returns the wrapper list of PAF and PL contract.
        
        public list<contractWrapper> getContract(String accountId)
        {
            
            contractPAF = new Set<id>();
            String contractPLId  = '';
            contractList = new list<contractWrapper> ();
            cotractMap = new Map<date,list<pepUtilityClass.contractWrapper>>();
            sortList = new List<date>(); 
            DashboardPAFSetting__c PAFSetting= DashboardPAFSetting__c.getValues('PAFDashboardSetting'); // maintain custom setting to show or hide PAF Contract on Dashbord
            Account accObj = [select id,name,pafss_Duplication_Check_Key__c from account where id=:accountId]; //fetch account detais of loggedin user.
            
            // fetch accounts(with Pl contract and Party object) contains same five values(firstname,lastname,dob,email,moblieno) as loggedin user account.
            list<account> listAccount = new List<account> ();
            if(String.isNotBlank(accObj.pafss_Duplication_Check_Key__c)) 
                listAccount = [select id,name,(select id,pafss_Is_Individual_Loan__c,collect__CL_Contract__c,pafss_Contract_Type__c from clcommon__Parties__r where ScCollection_Contract_Source_System__c='PAF'),(select id from loan__Loan_Accounts__r) from Account where isPersonaccount=true and Is_Portal_User_Created__c=true and pafss_Duplication_Check_Key__c=:accObj.pafss_Duplication_Check_Key__c]; 
            else
                listAccount = [select id,name,(select id,pafss_Is_Individual_Loan__c,collect__CL_Contract__c,pafss_Contract_Type__c from clcommon__Parties__r where ScCollection_Contract_Source_System__c='PAF'),(select id from loan__Loan_Accounts__r) from Account where isPersonaccount=true and Is_Portal_User_Created__c=true and id=:accObj.id];
            
            for(Account objAccount:listAccount)
            {
                if(PAFSetting.PAF_Dashboard_Checkbox__c==true)
                {
                    for(clcommon__Party__c objParty :objAccount.clcommon__Parties__r ) // iterate over parties and hold PAF contract in a set.
                    {
                        
                        if((objParty.pafss_Is_Individual_Loan__c==true && objParty.pafss_Contract_Type__c=='Consumer Loan') || (objParty.pafss_Contract_Type__c!='Consumer Loan')) 
                        {
                            contractPAF.add(objParty.collect__CL_Contract__c);
                        }
                    }   
                }
                
                
                for(loan__Loan_Account__c objLoanAccount : objAccount.loan__Loan_Accounts__r) // iterate over Pl contract and hold the respective account id.
                {
                    contractPLId  = objAccount.id;
                }
            }
            
            
            
            if(contractPAF.size()>0 && contractPAF.size()!=null)  // iterate over PAF contract
            {
                collect.API api = collect.APIFactory.getAPI();         // use Api to get the values of PAF contract.
                Map<Id,SObject> mapObjectData = new Map<Id,SObject>();
                mapObjectData = api.getContracts(contractPAF);
                for(Id contractId : mapObjectData.keySet())
                {
                    collect__Loan_Account__c objclcontract = (collect__Loan_Account__c) mapObjectData.get(contractId);
                    
                    // hit wrapper class to hold the values for each contract.
                    contractList.add(new contractWrapper(objclcontract.id,objclcontract.pafss_Loan_Name_Formula__c ,objclcontract.Name,objclcontract.collect__Loan_Status__c,objclcontract.ScCollection_Settled_Date__c));
                }
            } 
            
            If (string.isNotBlank(contractPLId))   // iterate over the account id of Pl contract.
            {
                Map<String,String> ChildObjectMap = new Map<String,String>();    
                List<loan__Loan_Account__c> lstLoanAccount = new List<loan__Loan_Account__c> ();
                lstLoanAccount  = RetrieveLoanAccounts.getLoanContracts(contractPLId,null,null,null,ChildObjectMap); //use Api to get the values of PL contract.
                if(lstLoanAccount.size() > 0)
                {
                    for (loan__Loan_Account__c objLoanAccount : lstLoanAccount)
                    {
                        DateTime creationDate= objLoanAccount.createdDate;
                        Date contractDate= date.newinstance(creationDate.year(), creationDate.month(), creationDate.day());  // convert created date(dateTime) to date
                        // hit wrapper class to hold the values for each contract.
                        contractList.add(new contractWrapper(objLoanAccount.id,objLoanAccount.Loan_Name__c,objLoanAccount.Name,objLoanAccount.loan__Loan_Status__c,contractDate)); 
                    }
                }   
            }
            if(contractList.size()>0)  
            { 
                for(pepUtilityClass.contractWrapper objContract:contractList) // iterate over wrapper list to create a map
                    // to sort this list on the basis of settle date.
                {
                    if(!cotractMap.containskey(objContract.settleDate))
                    {
                        cotractMap.put(objContract.settleDate,new List<pepUtilityClass.contractWrapper>());
                    }
                    cotractMap.get(objContract.settleDate).add(objContract);
                    
                }
                if(cotractMap.keySet().size()>0)             // iterate over map
                {
                    sortList.addAll(cotractMap.keySet());         // create a list of all settle date
                    sortList.sort();                              // sort list in ascending order.
                    contractList.clear();
                }
                if(sortList.size()>0)                                     // iterate over the ascending order list
                {   
                    List<date>finalList= new List<date>() ;      
                    for(Integer i = sortList.size()-1; i>=0;i--)
                    {
                        finalList.add(sortList.get(i));             // sort list in descending over.
                    }
                    
                    for(date dateValue : finalList)                  // iterate over the descending order list
                    {
                        for(pepUtilityClass.contractWrapper contractObj:cotractMap.get(dateValue))
                        {
                            contractList.add(contractObj);           // add the of wrappper object in wrapper list.
                        } 
                    }
                }
            }
            return contractList;
        }
        
        //This is used to store the four values of PAF contract and PL contract.
        
        Public contractWrapper(String loanId,String loanName,String loanNumber,String loanStatus,Date settleDate){
            this.loanId = loanId;
            this.loanName = loanName;
            this.loanNumber = loanNumber;
            this.loanStatus = loanStatus;
            this.settleDate = settleDate;
            
        }
        Public contractWrapper(){
        }
        
    } 
    /**
    * @Created By : Sushant Kumar
    * @Date : 24/08/2017
    * @Description : This method is created for handling page Exception
    **/
    public static pageReference handlePageException(Exception ex) {
        
        Cookie objCookieEx = new Cookie('ExceptionId',pepEncryptDecryptData.EncryptData(ex.getMessage() + String.valueof(ex.getStackTraceString())),null,-1,false);
        string redircetPageName= pages_config__c.getinstance('pepTechnicalException').Page_Label__c;
        Pagereference objNextPage = new Pagereference('/'+redircetPageName); 
        objNextPage.setCookies(new Cookie[]{objCookieEx});
        return  objNextPage;
    }
    
    /**
    * @Description : This method is used to send retrievel code
    **/
    public static ResendCodeResultWrapper resendCode(String retrieveEmail, String retrievePhone, Id modelConInstObjApplicationId, genesis__Applications__c objApplicationOld, Boolean isError)
    {
        //Variable Decleration
        List<Account> lsAcc;
        Map<String,String> childObjects = new Map<String,String>();
        List<genesis__Applications__c> lstApp;
        String retrievalCode;
        
        //send retrieval code
        
        if((retrieveEmail!=null && retrieveEmail!='') || (retrievePhone!=null && retrievePhone!=''))
        {
            lsAcc=[select id,LastName,PersonMobilePhone,PersonContactId,PersonEmail from account where (PersonEmail!=null AND PersonEmail= :retrieveEmail) Limit 1];
            if(lsAcc!=null && !lsAcc.isEmpty())
            {   
                lstApp=pepInvokeCLMethodHelper.fetchApplications(lsAcc[0].id,null,null,null,childObjects);
                
                if(lstApp!=null && !lstApp.isEmpty())
                {
                    for(integer i=0;i<lstApp.size();i++)
                    {
                        if(lstApp[i].genesis__Status__c!='Closed' && modelConInstObjApplicationId !=lstApp[i].id)
                        {
                            objApplicationOld=lstApp[i];
                            retrievalCode= lstApp[i].Ret_Code__c;
                            break;                          
                        }
                    }
                    if(retrievalCode!=null && retrievalCode!='')
                    {
                        //For email
                        if(retrieveEmail != null && retrieveEmail !='')
                        {
                            try
                            {
                                isError=false;
                                sendEmailRetrievalcode(objApplicationOld);
                            }
                            catch(Exception ex)
                            {
                                isError=true;
                            }
                        }
                        if(retrievePhone!=null && retrievePhone!=''){
                            try
                            {
                                isError=false;
                                sendSMSRetrievalcode(objApplicationOld);
                                
                            }
                            catch(Exception ex)
                            {
                                isError=true;
                            }
                        }                             
                    }
                    else {
                        
                        isError=true;
                    }
                }
            }
            else
            {
                isError=true;
            }           
            
        }
        else
        {
            isError=true;
        }
        
        ResendCodeResultWrapper resultObj = new ResendCodeResultWrapper();
        resultObj.isError = isError;
        resultObj.objApplicationOld = objApplicationOld;
        return resultObj;
    }
    
    //this wrapper class will store result of resend code method
    public class ResendCodeResultWrapper{
        
        public genesis__Applications__c objApplicationOld {get;set;} 
        public Boolean isError {get;set;}
    }
    
    /**
* @Created By : Sushant Kumar (Originally copied from pepCmsHeaderComponentController in refactoring)
* @Date : 1/9/2017
* @Description : This method is used to retrieve application
**/
    public static RetrieveApplicationResultWrapper retrieveApplication(Boolean isError, Boolean showBlankretrieval, String strRetrieveCode)
    {
        //variable declaration  
        PageReference p;
        RetrievalApplicationStatus__c ret;
        Date systemDate;
        List<genesis__Applications__c> lstRetrieveApp;
        Id idApplication;
        
        try{
            isError=false;
            showBlankretrieval=false;
            lstRetrieveApp= new List<genesis__Applications__c>();
            if(strRetrieveCode != null && strRetrieveCode != '')
            {
                showBlankretrieval=true;
                strRetrieveCode=strRetrieveCode.trim();
                ret=RetrievalApplicationStatus__c.getValues('Retrieval Status');
                string[] strStatus=ret.Retrieval_Status__c.split(',');
                loan.GlobalLoanUtilFacade util = new loan.GlobalLoanUtilFacade();
                
                if(!Test.isrunningtest())
                    systemDate = util .getCurrentSystemDate();
                else
                    systemDate=System.Today();
                string querySubString;
                String queryString='select id,pepNavigation_Status__c,Serviceability_Status__c from genesis__Applications__c where Ret_Code__c != \'\' and Ret_Code__c != null and Ret_Code__c=:strRetrieveCode  and (genesis__Expected_Close_Date__c=null OR genesis__Expected_Close_Date__c > : systemDate) AND';
                for(String st: strStatus)
                {
                    if(querySubString=='' || querySubString==null) 
                        querySubString=' genesis__Status__c != '+'\''+st+'\'';
                    else 
                        querySubString+= ' AND' + ' genesis__Status__c !='+'\''+st+'\'';
                }
                if(querySubString!='' && querySubString!=null) 
                    queryString+=querySubString;
                if(Limits.getQueries()+1 <= Limits.getLimitQueries()){  
                    lstRetrieveApp=database.Query(queryString);
                }
                else{
                    PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                    throw new DMLException('This is a SOQL limit exception handling mechanism');
                }
            }
            if(!lstRetrieveApp.isEmpty())
            {
                idApplication=lstRetrieveApp[0].id;
                String navigatingStep=lstRetrieveApp[0].pepNavigation_Status__c;
                if(navigatingStep!=null)
                {
                    string redircetPageName=pages_config__c.getinstance(''+pepUtilityClass.navigateToPage(navigatingStep).tolowercase()).Page_Label__c;
                    p=new PageReference('/'+redircetPageName);
                }
                else
                {
                    String redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
                    p=new PageReference('/'+redircetPageName);
                }
                peputilityclass.updateRetrieval(idApplication);
                Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
                cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
                p.setCookies(new Cookie[]{cookieApplicationId2 });
                p.setRedirect(true);
            }
            else{
                isError=true;
            }
        }
        catch(Exception ex){
            p = pepUtilityClass.handlePageException(ex);
        }
        
        RetrieveApplicationResultWrapper returnWrapper = new RetrieveApplicationResultWrapper();
        returnWrapper.returnPage = p;
        returnWrapper.idApplication = idApplication;
        returnWrapper.isError = isError;
        returnWrapper.showBlankretrieval = showBlankretrieval;
        
        return returnWrapper;
    }
    
    //Wrapper class for retrieveApplication results
    public class RetrieveApplicationResultWrapper {
        
        public pageReference returnPage         {get;set;}
        public Id            idApplication      {get;set;}
        public Boolean       isError            {get;set;}
        public Boolean       showBlankretrieval {get;set;}
    }
    
    //Added By Varun on July 5,2017 to return exact Stack Trace for the SOQL Limit Exception
    public static String getCurrrentString()
    {             
        return new LimitException().getStackTraceString().substringAfter('\n');
    }
    //Added By Varun on Ju1y 10,2017 to send the exception email.
    Public static void sendExceptionEmail(String reason){
        String Subject='DML Exception Error';
        
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setsubject(Subject);
        msg.setplaintextbody(reason);
        msg.settoaddresses(new String[]{Label.COCSyncErrorEmail});
        Messaging.Sendemail(new Messaging.SingleEmailMessage[]{msg});
        
    }
    
    public static void safeDelete(sObject obj, String sObjectAPIName) {
        
        List<sObject> sObjList = new List<sObject>();
        sObjList.add(obj);
        safeDelete(sObjList, sObjectAPIName);
    }
    
    /**
     * @Created By : Sushant Kumar
     * @Date : 28-09-2017
     * @Description : This method safely delete a sObject List taking care of already deleted items
     **/
    public static void safeDelete(List<sObject> lstSObject, String sObjectAPIName) {
        
        Set<Id> deleteReocrdIds = new Set<Id>();
        List<sObject> queriedSobjects = new List<sObject>();
        
        String query = 'Select Id From ' + sObjectAPIName + ' Where Id IN :deleteReocrdIds AND isDeleted = false';        
        
        for(sObject sObj : lstSObject) {
            
            if(sObj != null && sObj.Id != null ) {
                deleteReocrdIds.add(sObj.Id);
            }
        }
        
        if(!deleteReocrdIds.isEmpty()) {
            
            queriedSobjects = Database.query(query);
            if(!queriedSobjects.isEmpty()) {
                
                Database.delete(queriedSobjects, false);
            }
        }
    }
    
    /**
     * @Created By : Sushant Kuamr
     * @Param : This method accepts instance genesis application
     * @Return : This method will return same instance of genesis application object after putting source related information
     * @Description : Method is created for filling genessis apllication source information
     **/
    public static genesis__Applications__c fillApplicationSourceInfo(genesis__Applications__c applicationObj) {
        
        if(applicationObj != null) {
            
            String utm_source   = ApexPages.currentPage().getParameters().get('utm_source'); 
            String utm_medium   = ApexPages.currentPage().getParameters().get('utm_medium');
            String utm_campaign = ApexPages.currentPage().getParameters().get('utm_campaign');
            String utm_content  = ApexPages.currentPage().getParameters().get('utm_content');
            String utm_term     = ApexPages.currentPage().getParameters().get('utm_term');
            String utm_referrer = ApexPages.currentPage().getParameters().get('utm_referrer');
            
            if(String.isNotBlank(utm_source))
                applicationObj.Web_Analytics_Source__c = utm_source;
            
            if(String.isNotBlank(utm_medium))
                applicationObj.Web_Analytics_Medium__c = utm_medium;
            
            if(String.isNotBlank(utm_campaign))
                applicationObj.Web_Analytics_Campaign__c = utm_campaign;
            
            if(String.isNotBlank(utm_content))
                applicationObj.Web_Analytics_Content__c = utm_content;
            
            if(String.isNotBlank(utm_term))
                applicationObj.Web_Analytics_Term__c = utm_term;
            
            if(String.isNotBlank(utm_referrer))
                applicationObj.Web_Analytics_Referrer__c = utm_referrer;
            
        }
        
        return applicationObj;
    }
    
    /**
     * @Created By : Sushant kumar
     * @Description : This method will set parameters in the cookie. Method will be used on 'landing page' and 'applynow' page
     *                  for the case when application is not being created and values will be used on loandetails page 
     *                  for creating application.
     **/
    public static void setParametersInCookie(){
        
        List<Cookie> cookies = new List<Cookie>();
        //application source information 
        String utm_source   = ApexPages.currentPage().getParameters().get('utm_source'); 
        String utm_medium   = ApexPages.currentPage().getParameters().get('utm_medium');
        String utm_campaign = ApexPages.currentPage().getParameters().get('utm_campaign');
        String utm_content  = ApexPages.currentPage().getParameters().get('utm_content');
        String utm_term     = ApexPages.currentPage().getParameters().get('utm_term');
        String utm_referrer = ApexPages.currentPage().getParameters().get('utm_referrer');
        
        //when coming from epi server
        String apex_Debit_Frequency_c       = ApexPages.currentPage().getParameters().get('apex_Debit_Frequency_c'); 
        String apex_Requested_Loan_Amount_c = ApexPages.currentPage().getParameters().get('apex_Requested_Loan_Amount_c');
        String apex_Requested_Term_c        = ApexPages.currentPage().getParameters().get('apex_Requested_Term_c');
        String apex_genesisCredit_Rating_c  = ApexPages.currentPage().getParameters().get('apex_genesisCredit_Rating_c');
        String apex_genesisCL_Product_c     = ApexPages.currentPage().getParameters().get('apex_genesisCL_Product_c');
        String apex_genesisCL_Purpose_c     = ApexPages.currentPage().getParameters().get('apex_genesisCL_Purpose_c');
        
        if(String.isNotBlank(utm_source))
            cookies.add(new cookie('utm_source',utm_source,null,-1,false));
        
        if(String.isNotBlank(utm_medium))
            cookies.add(new cookie('utm_medium',utm_medium,null,-1,false));
        
        if(String.isNotBlank(utm_campaign))
            cookies.add(new cookie('utm_campaign',utm_campaign,null,-1,false));
        
        if(String.isNotBlank(utm_content))
            cookies.add(new cookie('utm_content',utm_content,null,-1,false));
        
        if(String.isNotBlank(utm_term))
            cookies.add(new cookie('utm_term',utm_term,null,-1,false));
        
        if(String.isNotBlank(utm_referrer))
            cookies.add(new cookie('utm_referrer',utm_referrer,null,-1,false));
        
        //setting cookies for parameters coming from epi server     
        if(String.isNotBlank(apex_Debit_Frequency_c))
            cookies.add(new cookie('Debit_Frequency__c',apex_Debit_Frequency_c,null,-1,false));
        
        if(String.isNotBlank(apex_Requested_Loan_Amount_c))
            cookies.add(new cookie('Requested_Loan_Amount__c',apex_Requested_Loan_Amount_c,null,-1,false));
        
        if(String.isNotBlank(apex_Requested_Term_c))
            cookies.add(new cookie('Requested_Term__c',apex_Requested_Term_c,null,-1,false));
        
        if(String.isNotBlank(apex_genesisCredit_Rating_c))
            cookies.add(new cookie('genesis__Credit_Rating__c',apex_genesisCredit_Rating_c,null,-1,false));
        
        if(String.isNotBlank(apex_genesisCL_Product_c))
            cookies.add(new cookie('genesis__CL_Product__c',apex_genesisCL_Product_c,null,-1,false));
        
        if(String.isNotBlank(apex_genesisCL_Purpose_c))
            cookies.add(new cookie('genesis__CL_Purpose__c',apex_genesisCL_Purpose_c,null,-1,false));
        
        
        //setting cookies
        if(!cookies.isEmpty()) {
            ApexPages.currentPage().setcookies(cookies);
        }
    }
    
    /**
    * @Created By : Sushant Kumar
    * @Date : 03/11/2017
    * @Description : This method is created for handling page Exception and putting some additional information if required
    **/
    public static pageReference handlePageException(Exception ex, String additionalInformation) {
        
        String emailBody = ex.getMessage() + String.valueof(ex.getStackTraceString());
        
        if(String.isNotBlank(additionalInformation)) {
            emailBody += '\nAdditional Info :-\n'+ additionalInformation;
        }
        
        Cookie objCookieEx = new Cookie('ExceptionId',pepEncryptDecryptData.EncryptData(emailBody),null,-1,false);
        string redircetPageName= pages_config__c.getinstance('pepTechnicalException').Page_Label__c;
        Pagereference objNextPage = new Pagereference('/'+redircetPageName); 
        objNextPage.setCookies(new Cookie[]{objCookieEx});
        return  objNextPage;
    }
}