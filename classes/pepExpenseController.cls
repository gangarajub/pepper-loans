/*
This class is used to handle the working of the PepExpensePage.
Added BY Varun(Code Refactoring on Aug 26,2017)
*/
public class pepExpenseController
{   
    Public Boolean SaveData{get;set;}
    Public Id accountId{get;set;}
    Public Boolean formattedamount{get;set;}
    Public String sectionmessage{get;set;}
    Public String pagetoredirect{get;set;}
    public String str1{get;set;}
    Public Decimal amountAfterDebt{get;set;}
    Public Decimal initialAmount{get;set;}
    public List<sobject> lstSObjectForSave {get;set;}
    public pepCmsModelContainer objModelContainer{get;set;}
    public boolean isdisplayServPositive{get;set;}
    public boolean isdisplayServNegative{get;set;}
    public integer debtConLimit{get;set;}       
    public boolean showDebtLimit{get;set;}      
    Public integer MaxnumberofDebts{get;set;}
    Public Decimal requiredLoanAmount;
    public list<wrapperQuestion> lstWrapperQuestionSection1 {get; set;}  
    public list<wrapperQuestion> lstWrapperQuestionSection2 {get; set;}    //For What you Section
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection1 {get;set;}  //This is used for HouseHold Section
    
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection1Clone {get;set;}  //This is used for HouseHold Section
    
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection2 ;  //This is used for Food and Living Section  
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection2Clone {get;set;}  //This is used for HouseHold Section
    
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection3 ;  //This is used for Entertainment Section 
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection3Clone{get;set;}
    
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection4 ;  //This is used for Food and Living Section
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection4Clone{get;set;}
    
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection5 ;  //This is used for Food and Living Section
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection5Clone{get;set;}
    
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection6 ; //This is used for Food and Living Section
    public list<wrapperQuestion> lstWrapperQuestionPopUpSection6Clone{get;set;}    
    
    //added by sushant
    Map<String, pepCmsSection__c> mapOfAllCMSExpensesData;
    
    @testVisible private  map<id, pepCmsQuestion__c> mapAllQuestions;
    public decimal totalMonthlyExpense{get;set;}
    public String strSectionStorySection1{get;set;}
    public String strSectionStorySection2{get;set;}
    public genesis__Applications__c objApplication{get;set;}
    public Integer intCurrentPageNumber{get;set;}
    public Integer intPreviousPageNumber{get;set;}
    @testVisible Map<String,List<Expense_and_Debt__c>>  MapOfExpenseTypeToExpense; 
    String strDebtType                   ='Debt'; 
    String strLivingExpenseType          ='Mortgage Expense'; 
    String strHouseHoldExpenseType       ='Household Expense';  
    String strFoodAndLivingExpenseTpe    ='Food and Living Expense';  
    String strEntertainmentExpenseType   ='Entertainment and Services Expense';  
    String strEducationExpenseType       ='Education Expense';  
    String strVTExpenseType              = 'Vehicle and Transport Expense';  
    String strInsuranceExpenseType       ='Insurance Expense'; 
    public boolean isConsolidatingDebt{get;set;} 
    public Integer DebtRecordsNo{get;set;}
    @testVisible Map<Id,string> mapofIdAnswerToLabel = new Map<Id,string>(); 
    public Decimal decsectionStory1Amount;
    public Map<Integer,Boolean> MapOfRecordNoToConsolidatedDebt {get;set;}
    @testVisible Map<Id,List<pepCmsQuestion__c>> MapOfAnswerIdToQuestion;
    @testVisible private String  ReturnValue; 
    public boolean isEdit{get;set;}
    public string totalMonthlyExpenseExcMortgage;
    @testVisible List<Expense_and_Debt__c> lstExpenseToDelete;
    
    public String Page_Name{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    //This is the constructor for loading the schema of the CMS Questions and Answers setted up against the pepExpensePage at the backend.
    public pepExpenseController()
    {
        MaxnumberofDebts=Integer.valueof(Label.Max_Number_of_Debts);
        page_Name='pepexpensepage';//Added by KG
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
        debtConLimit =0;
        
        lstExpenseToDelete = new List<Expense_and_Debt__c>();
        isConsolidatingDebt = false;
        isEdit = false;
        showDebtLimit = false;
        MapOfRecordNoToConsolidatedDebt = new Map<Integer,Boolean>();
        MapOfAnswerIdToQuestion = new Map<Id,List<pepCmsQuestion__c>>();
        objApplication = new genesis__Applications__c ();
        mapAllQuestions = fetchPageQuestions('Expenses'); 
        MapOfExpenseTypeToExpense = new  Map<String,List<Expense_and_Debt__c>>();   
        if(ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')!=null)
        {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); 
        } 
        if( ApexPages.currentPage().getParameters().get('redirectFromPageNo') != null 
           &&  ApexPages.currentPage().getParameters().get('redirectFromPageNo') !='')
        {
            intPreviousPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('redirectFromPageNo'));   
        }
        
        intCurrentPageNumber =  3;         
        getCookieData();
        fetchApplication();
        //Loading all CMS data for expense page -- added by sushant kumar
        
        loadAllCMSDataForExpenses();
        
        lstWrapperQuestionSection1 = new list<wrapperQuestion>();
        lstWrapperQuestionSection2 = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection1 = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection2 = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection3 = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection4 = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection5 = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection6 = new list<wrapperQuestion>();
        
        lstWrapperQuestionPopUpSection1Clone = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection2Clone = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection3Clone = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection4Clone = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection5Clone = new list<wrapperQuestion>();
        lstWrapperQuestionPopUpSection6Clone = new list<wrapperQuestion>();
        loadCMSDataForPopUpSection1();
        loadCMSDataForSection1();
        loadCMSDataForSection2();
        
        loadCMSDataForPopUpSection2();
        loadCMSDataForPopUpSection3();
        loadCMSDataForPopUpSection4();
        loadCMSDataForPopUpSection5();
        loadCMSDataForPopUpSection6();
        lstWrapperQuestionPopUpSection1Clone = cloneData(lstWrapperQuestionPopUpSection1 ,lstWrapperQuestionPopUpSection1Clone);
        lstWrapperQuestionPopUpSection2Clone = cloneData(lstWrapperQuestionPopUpSection2 ,lstWrapperQuestionPopUpSection2Clone); 
        lstWrapperQuestionPopUpSection3Clone = cloneData(lstWrapperQuestionPopUpSection3 ,lstWrapperQuestionPopUpSection3Clone); 
        lstWrapperQuestionPopUpSection4Clone = cloneData(lstWrapperQuestionPopUpSection4 ,lstWrapperQuestionPopUpSection4Clone); 
        lstWrapperQuestionPopUpSection5Clone = cloneData(lstWrapperQuestionPopUpSection5 ,lstWrapperQuestionPopUpSection5Clone); 
        lstWrapperQuestionPopUpSection6Clone = cloneData(lstWrapperQuestionPopUpSection6 ,lstWrapperQuestionPopUpSection6Clone); 
        
    }
    
    @testVisible
    private pepExpenseController(String testStr){
        //this constructor is created for validating and writing test case of small independent method
    }
    
    //This method is used to retrieve the application Id from cookie.
    public void getCookieData()
    {
        Cookie cookieApplicationId = ApexPages.currentPage().getCookies().get('ApplicationId');       
        
        if(cookieApplicationId !=null && cookieApplicationId.getValue() !=null && cookieApplicationId.getValue() !='')
        {                           
            objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        }
        
    }
    //This method is used to retrieve the application depending upon the cookie Id.
    public void fetchApplication()
    {
        //hardcode application Id
        Map<string,string> childobjects = new Map<string,string>();       
        String[] lstTypes = new String[]{'Expense_and_Debt__c'};
            
            List<genesis__Applications__c>  lstApplication = pepUtilityClass.fetchApplicationAndChild(lstTypes ,'ExpenseFieldSet',null,objApplication.Id,null);
        if(lstApplication != null && (!lstApplication.isEmpty()))
        {        
            objApplication = lstApplication[0];
            accountId=[Select id,genesis__Account__c from genesis__Applications__c where id=:objApplication.id].genesis__Account__c;
            Id idClPurpose = objApplication.genesis__CL_Purpose__c;
            requiredLoanAmount=objApplication.Requested_Loan_Amount__c;
            List<clcommon__CL_Purpose__c> lstCLPurpose = [select id ,name,Is_Debt_Con__c,Number_of_Debts__c from clcommon__CL_Purpose__c where id =:idClPurpose and Is_Debt_Con__c = True];           
            if(lstCLPurpose != null && (!lstCLPurpose.isEmpty()))
            {
                isConsolidatingDebt = true;
                if(lstCLPurpose[0].Number_of_Debts__c!=null)       
                    debtConLimit = integer.valueOf(lstCLPurpose[0].Number_of_Debts__c);
            }            
            
            if(objApplication.Expenses_and_Debts__r != null && (!objApplication.Expenses_and_Debts__r.isEmpty()))
            {
                isEdit = true;          
                for(Expense_and_Debt__c objExpense : objApplication.Expenses_and_Debts__r)
                {
                    if(objExpense.Type__c == null)
                    {
                        objExpense.Type__c = '';
                    }
                    if(objExpense.Type_of_Expense_Debt__c== null)
                    {
                        objExpense.Type_of_Expense_Debt__c = '';
                    }
                    
                    if(MapOfExpenseTypeToExpense.get(objExpense.Type__c+objExpense.Type_of_Expense_Debt__c) == null) 
                    {
                        MapOfExpenseTypeToExpense.put(objExpense.Type__c+objExpense.Type_of_Expense_Debt__c,new List<Expense_and_Debt__c>());
                    }
                    MapOfExpenseTypeToExpense.get(objExpense.Type__c+objExpense.Type_of_Expense_Debt__c).add(objExpense);
                    
                }
            }
            
        } 
        
    }
    
    /*
* Created By : Sushant Kumar
* Description : This class will load all CMS data for Expenses in single transaction
*/
    public void loadAllCMSDataForExpenses() {
        
        mapOfAllCMSExpensesData = new Map<String, pepCmsSection__c>();
        
        List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                              pepSectionUniqueName__c, pepType__c, 
                                              pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                              (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , 
                                               pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                              from pepCmsSection__c where pepPage__r.pepPageName__c='Expenses'];
        
        if(lstSections != null && (!lstSections.isEmpty())) {
            
            for(pepCmsSection__c pepSectionObj : lstSections) {
                
                mapOfAllCMSExpensesData.put(pepSectionObj.pepSectionUniqueName__c, pepSectionObj);
            }
        }
        
    }
    //This method is used for loading the data for share of living section.
    public void loadCMSDataForSection1()
    {
        //Modified By - Sushant Kumar
        //anyList.size() > 0 is replaced with (!anyList.isEmpty()) method
        
        //variable declaration and initialization
        String debtValue; 
        String frequency;
        wrapperQuestion objMasterQuestionWrap;
        list<wrapperQuestion> lstSiblingWrap;
        
        pepCmsSection__c pepCMSSectionObj = mapOfAllCMSExpensesData.get('Your share of living expenses');
        
        if(pepCMSSectionObj != null) 
        {
            strSectionStorySection1 = pepCMSSectionObj.pepSectionStory__c;
            
            if(pepCMSSectionObj.pepQuestion__r != null && (!pepCMSSectionObj.pepQuestion__r.isEmpty()))
            {
                for(pepCmsQuestion__c objMasterQuestion : pepCMSSectionObj.pepQuestion__r)
                {
                    List<Expense_and_Debt__c> lstExpense = MapOfExpenseTypeToExpense.get(strLivingExpenseType+objMasterQuestion.pepLabelPriorQuestion__c);
                    Expense_and_Debt__c objExpense;
                    debtValue = '';
                    frequency = '';
                    if(lstExpense != null && (!lstExpense.isEmpty()))
                    {
                        objExpense =lstExpense[0];
                        if(objExpense != null) 
                        {
                            debtValue = (objExpense.Expense_Debt_Value__c  != null)? String.valueOf(objExpense.Expense_Debt_Value__c) : '';
                            frequency = (objExpense.Frequency__c!= null)? String.valueOf(objExpense.Frequency__c) : '';
                        }
                    }
                    
                    if(objMasterQuestion.pepSObjectApiName__c =='genesis__Applications__c' && objMasterQuestion.pepFieldApiName__c =='Total_Monthly_Expense__c')
                    {
                        objMasterQuestionWrap = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),String.valueOf(objApplication.Total_Monthly_Expense_Exc_Mortgage__c));
                        totalMonthlyExpenseExcMortgage = String.valueOf(objApplication.Total_Monthly_Expense_Exc_Mortgage__c);
                    }
                    else if(objMasterQuestion.pepSObjectApiName__c =='genesis__Applications__c' && objMasterQuestion.pepFieldApiName__c =='Percentage_of_Expense_Contribution__c')
                    {
                        objMasterQuestionWrap = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),String.valueOf(objApplication.Percentage_of_Expense_Contribution__c));
                        
                    }
                    else
                    {
                        objMasterQuestionWrap = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),debtValue );
                        if(lstExpense != null && objExpense != null)
                        {
                            objMasterQuestionWrap.objExpense = objExpense;
                        }
                    }
                    
                    lstSiblingWrap = new list<wrapperQuestion>();
                    for(pepCmsQuestion__c objTempQues: mapAllQuestions.Values() )
                    {
                        if(objTempQues.pepQuestion__c == objMasterQuestion.Id)// get sibling ques
                        { 
                            wrapperQuestion objQuestionWrapTemp = new wrapperQuestion(objTempQues,frequency);
                            lstSiblingWrap.add(objQuestionWrapTemp );
                        }
                    }
                    if(lstSiblingWrap != null && (!lstSiblingWrap.isEmpty()))
                    {
                        objMasterQuestionWrap.lstSiblingQuestion =lstSiblingWrap;
                    }
                    lstWrapperQuestionSection1.add(objMasterQuestionWrap);
                }
            }
            
        }   
        
    }
    //This method is used for loading the data for the 'What you owe (debt) section'.
    public void loadCMSDataForSection2()
    {   
        pepCmsSection__c pepCMSSectionObj = mapOfAllCMSExpensesData.get('What you owe (debts)');
        
        if(pepCMSSectionObj != null)
        {
            strSectionStorySection2 = pepCMSSectionObj.pepSectionStory__c;
            
            if(pepCMSSectionObj.pepQuestion__r != null && (!pepCMSSectionObj.pepQuestion__r.isEmpty()))
            {
                
                for(pepCmsQuestion__c objMasterQuestion : pepCMSSectionObj.pepQuestion__r)
                {
                    Integer i = 1;
                    if(mapAllQuestions.get(objMasterQuestion.Id) != null 
                       && mapAllQuestions.get(objMasterQuestion.Id).pepCmsAnswer__r !=null
                       && (!mapAllQuestions.get(objMasterQuestion.Id).pepCmsAnswer__r.isEmpty()))
                    {
                        
                        for(pepCmsAnswer__c objAnswer : mapAllQuestions.get(objMasterQuestion.Id).pepCmsAnswer__r)
                        {
                            List<Expense_and_Debt__c> lstExpense = MapOfExpenseTypeToExpense.get(strDebtType+objAnswer.pepDisplayText__c);
                            if(lstExpense != null && (!lstExpense.isEmpty()))
                            { 
                                for(Expense_and_Debt__c objExpense  :  lstExpense)
                                {
                                    
                                    if(objExpense != null)
                                    {
                                        string strTypeOfExpense ='';
                                        String debtValue = (objExpense.Expense_Debt_Value__c  != null)? String.valueOf(objExpense.Expense_Debt_Value__c) : '';
                                        String frequency = (objExpense.Frequency__c != null)? String.valueOf(objExpense.Frequency__c) : '';
                                        
                                        wrapperQuestion objMasterQuestionWrap = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),objAnswer.pepDisplayText__c);                                
                                        objMasterQuestionWrap.objExpense = objExpense;
                                        
                                        list<wrapperQuestion> lstSiblingWrap = new list<wrapperQuestion>();
                                        list<wrapperQuestion> lstSiblingWrapDebt = new list<wrapperQuestion>();
                                        list<wrapperQuestion> lstAnswersQuestions = new list<wrapperQuestion>();
                                        if(MapOfAnswerIdToQuestion.get(objAnswer.Id) != null)
                                        {
                                            for(pepCmsQuestion__c objAnsQues : MapOfAnswerIdToQuestion.get(objAnswer.Id))
                                            {
                                                wrapperQuestion objQuestionAnswer = new wrapperQuestion(objAnsQues,String.valueOf(objExpense.get(objAnsQues.pepFieldApiName__c))); 
                                                lstAnswersQuestions.add(objQuestionAnswer);   
                                            }
                                            if(!lstAnswersQuestions.isEmpty())
                                            {
                                                objMasterQuestionWrap.lstAnswersQuestions =lstAnswersQuestions;
                                            }
                                        }
                                        
                                        for(pepCmsQuestion__c objTempQues: mapAllQuestions.Values() )
                                        {
                                            if(objTempQues.pepQuestion__c == objMasterQuestion.Id 
                                               && objTempQues.pepis_Consolidated_Debt__c == false)// get sibling ques
                                            {
                                                wrapperQuestion objQuestionWrapTemp =  new wrapperQuestion();
                                                if(objTempQues.pepType__c =='Picklist')
                                                    objQuestionWrapTemp = new wrapperQuestion(objTempQues,frequency);
                                                else
                                                    objQuestionWrapTemp = new wrapperQuestion(objTempQues,debtValue );
                                                lstSiblingWrap.add(objQuestionWrapTemp );                               
                                            }
                                            if(objTempQues.pepQuestion__c == objMasterQuestion.Id 
                                               && objTempQues.pepis_Consolidated_Debt__c == true)// get sibling ques//&& objExpense.Consolidate_As_A_Debt__c ==true
                                            {
                                                wrapperQuestion objQuestionWrapTemp = new wrapperQuestion(objTempQues,'true');
                                                lstSiblingWrapDebt.add(objQuestionWrapTemp );
                                                //MapOfRecordNoToConsolidatedDebt.put(i,true);
                                            }
                                            
                                        }
                                        if(!lstSiblingWrap.isEmpty())
                                        {
                                            objMasterQuestionWrap.lstSiblingQuestion =lstSiblingWrap;
                                        }
                                        
                                        if(!lstSiblingWrapDebt.isEmpty())
                                        {
                                            objMasterQuestionWrap.lstSiblingQuestionDebt =lstSiblingWrapDebt;
                                        }
                                        lstWrapperQuestionSection2.add(objMasterQuestionWrap); 
                                    }
                                }
                            } 
                        }
                        
                    }
                    i++;
                }
                if(lstWrapperQuestionSection2.isEmpty())
                {
                    loadCMSDataSection1New();        
                } 
            }
        }
    }
    //This method is used to manipulate data in the What you owe (debt) section.
    public void loadCMSDataSection1New()
    {
        //removed query for single record and used a consolidated query for all expenses section -- modified by Sushant Kumar 
        pepCmsSection__c pepCMSSectionObj = mapOfAllCMSExpensesData.get('What you owe (debts)');
        
        for(pepCmsQuestion__c objMasterQuestion : pepCMSSectionObj.pepQuestion__r)                
        {                            
            wrapperQuestion objMasterQuestionWrap = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),'' );
            list<wrapperQuestion> lstSiblingWrap = new list<wrapperQuestion>();
            list<wrapperQuestion> lstSiblingWrapDebt = new list<wrapperQuestion>();
            for(pepCmsQuestion__c objTempQues: mapAllQuestions.Values() )
            {
                if(objTempQues.pepQuestion__c == objMasterQuestion.Id && objTempQues.pepis_Consolidated_Debt__c == false)// get sibling ques
                { 
                    wrapperQuestion objQuestionWrapTemp = new wrapperQuestion(objTempQues,'');
                    lstSiblingWrap.add(objQuestionWrapTemp );
                }
                if(objTempQues.pepQuestion__c == objMasterQuestion.Id && objTempQues.pepis_Consolidated_Debt__c == true)// get sibling ques
                {
                    wrapperQuestion objQuestionWrapTemp = new wrapperQuestion(objTempQues,'false');
                    lstSiblingWrapDebt.add(objQuestionWrapTemp );
                }
            }
            if(!lstSiblingWrap.isEmpty())
            {
                objMasterQuestionWrap.lstSiblingQuestion =lstSiblingWrap;
            }
            
            if(!lstSiblingWrapDebt.isEmpty())
            {
                objMasterQuestionWrap.lstSiblingQuestionDebt =lstSiblingWrapDebt;
            }
            lstWrapperQuestionSection2.add(objMasterQuestionWrap);
            
        }
    }
    
    //Created By: Sushant Kumar
    //Description : created for reusable method for loadCMSDataForPopUpSection prefixed methods 
    
    private List<wrapperQuestion> loadCMSDataForPopUpSections(String papSectionUniqueName, String expenseType)
    {
        List<Expense_and_Debt__c> lstExpense;
        Expense_and_Debt__c objExpense;
        String debtValue;
        String frequency;
        wrapperQuestion objMasterQuestionWrap;
        list<wrapperQuestion> lstSiblingWrap;
        List<wrapperQuestion> returnList = new List<wrapperQuestion>();
        
        pepCmsSection__c pepCMSSectionObj = mapOfAllCMSExpensesData.get(papSectionUniqueName);
        
        if(pepCMSSectionObj != null)
        {
            if(pepCMSSectionObj.pepQuestion__r != null && (!pepCMSSectionObj.pepQuestion__r.isEmpty()))
            {
                for(pepCmsQuestion__c objMasterQuestion : pepCMSSectionObj.pepQuestion__r)
                {
                    lstExpense = MapOfExpenseTypeToExpense.get(expenseType + objMasterQuestion.pepLabelPriorQuestion__c);
                    objExpense = new Expense_and_Debt__c();
                    debtValue = '';
                    frequency = '';
                    if(lstExpense != null && (!lstExpense.isEmpty()))
                    {
                        objExpense =lstExpense[0]; 
                        if(objExpense != null) 
                        {
                            debtValue = (objExpense.Expense_Debt_Value__c  != null)? String.valueOf(objExpense.Expense_Debt_Value__c) : '';
                            frequency = (objExpense.Frequency__c!= null)? String.valueOf(objExpense.Frequency__c) : '';
                        }
                    }
                    objMasterQuestionWrap = new wrapperQuestion(mapAllQuestions.get(objMasterQuestion.Id),debtValue);
                    if(lstExpense != null && objExpense != null)
                    {
                        objMasterQuestionWrap.objExpense = objExpense;
                    }
                    lstSiblingWrap = new list<wrapperQuestion>();
                    for(pepCmsQuestion__c objTempQues: mapAllQuestions.Values() )
                    {
                        if(objTempQues.pepQuestion__c == objMasterQuestion.Id)// get sibling ques
                        { 
                            wrapperQuestion objQuestionWrapTemp = new wrapperQuestion(objTempQues,frequency);
                            lstSiblingWrap.add(objQuestionWrapTemp );
                        }
                    }
                    
                    if(!lstSiblingWrap.isEmpty())
                    {
                        objMasterQuestionWrap.lstSiblingQuestion =lstSiblingWrap;
                    }
                    returnList.add(objMasterQuestionWrap);
                }
            }
            
        }   
        return returnList;
    }
    
    //modified by : Sushant Kumar
    public void loadCMSDataForPopUpSection1()
    {    
        lstWrapperQuestionPopUpSection1.addAll(loadCMSDataForPopUpSections('Household', strHouseHoldExpenseType));
    }
    
    //modified by : sushant kumar
    public void loadCMSDataForPopUpSection2()
    {
        lstWrapperQuestionPopUpSection2.addAll(loadCMSDataForPopUpSections('Food and living', strFoodAndLivingExpenseTpe));
    }
    
    //modified by : sushant kumar
    public void loadCMSDataForPopUpSection3()
    {
        lstWrapperQuestionPopUpSection3.addAll(loadCMSDataForPopUpSections('Entertainment and services', strEntertainmentExpenseType));
    }
    
    //modified by : sushant Kumar
    public void loadCMSDataForPopUpSection4()
    {
        lstWrapperQuestionPopUpSection4.addAll(loadCMSDataForPopUpSections('Education', strEducationExpenseType)); 
    }
    
    //modified by : sushant Kumar
    public void loadCMSDataForPopUpSection5()
    {
        lstWrapperQuestionPopUpSection5.addAll(loadCMSDataForPopUpSections('Vehicle and Transport', strVTExpenseType));
    }
    
    //modified by : sushant Kumar
    public void loadCMSDataForPopUpSection6()
    {
        lstWrapperQuestionPopUpSection6.addAll(loadCMSDataForPopUpSections('Insurance', strInsuranceExpenseType));
    }
    
    public class wrapperQuestion
    {
        public pepCmsQuestion__c objCmsQuestion {get; set;} //main question      
        public List<wrapperAnswer> lstExpectedAnsers {get; set;}//answer of question
        public List<wrapperQuestion> lstSiblingQuestion {get; set;} //siblingquestion
        public List<wrapperQuestion> lstSiblingQuestionDebt {get; set;} //siblingquestion        
        public String objInputValue
        {
            get { return objInputValue; }
            
            set {
                if(objCmsQuestion.pepType__c =='Currency')
                {
                    if(value != null)
                    {
                        objInputValue = value.replace(',','');
                    }
                    else
                    {
                        objInputValue  = value;
                    }
                }
                else
                {
                    objInputValue =value;
                }
                
            }
        }
        
        
        public string selectedRadio {get; set;} //input Value For Consolidated debt
        public list<selectOption> lstOptions {get; set;}
        public List<wrapperQuestion> lstAnswersQuestions{get;set;}
        public Expense_and_Debt__c objExpense{get;set;}
        Public Boolean requiredCheck{get;set;}
        public wrapperQuestion(){}
        public wrapperQuestion(pepCmsQuestion__c objQuestion, string InputAnswers)
        {
            objCmsQuestion = objQuestion;            
            lstExpectedAnsers = new List<wrapperAnswer>();
            lstSiblingQuestion = new List<wrapperQuestion>();
            lstSiblingQuestionDebt = new List<wrapperQuestion>();
            lstAnswersQuestions = new List<wrapperQuestion>();
            lstOptions = new list<selectOption>();            
            objInputValue = InputAnswers;
            if(objInputValue != '')
                requiredCheck=true;
            
            if(objQuestion != null && objQuestion.pepCmsAnswer__r!=null && objQuestion.pepCmsAnswer__r.size()>0)
            {
                for(pepCmsAnswer__c objAnswer : objQuestion.pepCmsAnswer__r)
                {
                    lstExpectedAnsers.add(new wrapperAnswer(objAnswer));
                    if(objAnswer.pepActualValue__c == null)
                    {
                        objAnswer.pepActualValue__c ='';
                    }
                    
                    if(objAnswer.pepDisplayText__c == objInputValue)
                    {
                        if(lstOptions != null && lstOptions.size() > 0)
                        {                        
                            lstOptions.add(new selectOption(objAnswer.Id, objAnswer.pepDisplayText__c));
                            // lstOptions.add((new selectOption()).setValue(objAnswer.pepDisplayText__c));
                        }
                        
                    }
                    else
                    {
                        if(objAnswer.pepDisplayText__c == 'Select other')
                        {
                            lstOptions.add(new selectOption('', objAnswer.pepDisplayText__c));
                        }
                        else if(objAnswer.pepDisplayText__c == 'Choose one')
                        {
                            lstOptions.add(new selectOption('', objAnswer.pepDisplayText__c));
                        }
                        else
                        {
                            lstOptions.add(new selectOption(objAnswer.Id, objAnswer.pepDisplayText__c));
                        }
                    }
                }
            }
        }
        
    }
    
    public class wrapperAnswer
    {
        public pepCmsAnswer__c objCmsAnswer {get; set;}
        public list<wrapperQuestion> lstChildQuestion {get; set;}
        
        public wrapperAnswer(){}
        public wrapperAnswer(pepCmsAnswer__c objAns)
        {
            lstChildQuestion = new list<wrapperQuestion>();
            objCmsAnswer = objAns;           
        }
    }
    //This method is used by save and retrieve extension in order to grab expense list.
    public void createExpenseList()
    {
        AssignClonedValue();
        
        lstSObjectForSave = new List<sobject>();          
        lstSObjectForSave.addAll(makeSection1Data());
        lstSObjectForSave.addAll(makeSection2Data());
        lstSObjectForSave.addAll(makepop1SectionData());       
        lstSObjectForSave.addAll(makepop2SectionData());
        lstSObjectForSave.addAll(makepop3SectionData());
        lstSObjectForSave.addAll(makepop4SectionData());
        lstSObjectForSave.addAll(makepop5SectionData());
        lstSObjectForSave.addAll(makepop6SectionData());
        
        pepUtilityClass.safeDelete(lstExpenseToDelete, 'Expense_and_Debt__c');
    }
    
    public pageReference continueApplication()
    {
        pageReference objNextPage;
        
        //Modified By -Sushant Kumar
        //Exception handling added to this code.
        try {
            
            AssignClonedValue(); 
            
            List<sobject> lstSobject = new List<sobject>();          
            List<wrapperQuestion> lstLivingExpenseWrapper= new List<wrapperQuestion>();
            List<wrapperQuestion> lstdebtWrapper= new List<wrapperQuestion>(); 
            
            lstSobject.addAll(makeSection1Data());
            lstSobject.addAll(makeSection2Data());
            lstSobject.addAll(makepop1SectionData());       
            lstSobject.addAll(makepop2SectionData());
            lstSobject.addAll(makepop3SectionData());
            lstSobject.addAll(makepop4SectionData());
            lstSobject.addAll(makepop5SectionData());
            lstSobject.addAll(makepop6SectionData());
            
            pepUtilityClass.safeDelete(lstExpenseToDelete, 'Expense_and_Debt__c');
            
            if(objApplication.pepCurrent_Page__c != null && objApplication.pepCurrent_Page__c < 4)
            {
                objApplication.pepCurrent_Page__c = 4;
            }
            
            objApplication = UpdateApplication(objApplication,lstSobject); 
            AffordabilityCalcCtrl ctrl = new AffordabilityCalcCtrl(objApplication.Id); 
            genesis__Applications__c objAffordabiltyApplication  = ctrl.doAffordabilityCalc(); 
            Cookie objCookie =new Cookie('ApplicationId','',null,-1,false);
            objCookie = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objApplication.Id)),null,-1,false);
            String strNavigationStatusPageName ='';
            
            if(String.isBlank(objAffordabiltyApplication.Affordability_Status__c)
               || (objAffordabiltyApplication.Affordability_Status__c != 'Yes'
                   && objAffordabiltyApplication.Affordability_Status__c != 'Maybe'
                   && objAffordabiltyApplication.Affordability_Status__c != 'No')
              )
            {
                throw new ExpensePageException('objAffordabiltyApplication.Affordability_Status__c : '+objAffordabiltyApplication.Affordability_Status__c
                                              +'\nAffordabilityCalcCtrl state : '+ JSON.serialize(ctrl));
            }
            
            if(objAffordabiltyApplication.Affordability_Status__c =='Yes')
            {
                strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepServiceabilityPositve');
                
                isdisplayServPositive=true;
                string redircetPageName= pages_config__c.getinstance('pepserviceabilitypositve').Page_Label__c;
                objNextPage = new Pagereference('/'+redircetPageName); 
                objNextPage.setCookies(new Cookie[]{objCookie});
                
            }
            
            if(objAffordabiltyApplication.Affordability_Status__c =='Maybe')
            {
                strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepServiceabilityNegative');    
                string redircetPageName= pages_config__c.getinstance('pepserviceabilitynegative').Page_Label__c;
                objNextPage = new Pagereference('/'+redircetPageName);            
                objNextPage.setCookies(new Cookie[]{objCookie});
            }
            
            if(objAffordabiltyApplication.Affordability_Status__c =='No')
            {
                strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepServiceabilityNegative1');           
                isdisplayServNegative=true;
                string redircetPageName= pages_config__c.getinstance('pepserviceabilitynegative1').Page_Label__c;
                objNextPage = new Pagereference('/'+redircetPageName);
                objNextPage.setCookies(new Cookie[]{objCookie});
            }
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            Map<string,string> childobjects = new Map<string,string>();
            if(objApplication != null && objApplication.id != null)
            {
                List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,objApplication.id,null,null,childobjects );
                if(lstApplication != null && lstApplication.size() > 0)
                {
                    
                    objApplication = lstApplication[0];
                    objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                    
                }
            }
            
            objApplication = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);         
            return  objNextPage;
        }
        catch(Exception ex)
        {
            return pepUtilityClass.handlePageException(ex);
        }   
    }
    
    public pageReference saveCallFromHeader()
    { 
        pageReference objNextPage;
        //Modified By -Sushant Kumar
        //Exception handling added to this code.
        try {
            
            AssignClonedValue();
            List<sobject> lstSobject = new List<sobject>();          
            List<wrapperQuestion> lstLivingExpenseWrapper= new List<wrapperQuestion>();
            List<wrapperQuestion> lstdebtWrapper= new List<wrapperQuestion>();          
            lstSobject.addAll(makeSection1Data());
            lstSobject.addAll(makeSection2Data());
            
            lstSobject.addAll(makepop1SectionData());       
            lstSobject.addAll(makepop2SectionData());
            lstSobject.addAll(makepop3SectionData());
            lstSobject.addAll(makepop4SectionData());
            lstSobject.addAll(makepop5SectionData());
            lstSobject.addAll(makepop6SectionData());
            
            pepUtilityClass.safeDelete(lstExpenseToDelete, 'Expense_and_Debt__c');
            
            Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
            cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(objapplication.id)),null,-1,false);
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            objApplication.pepNavigation_Status__c=pepUtilityClass.returnPageName(pagetoredirect);
            objApplication = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
            if(pagetoredirect=='1'){
                string redircetPageName= pages_config__c.getinstance('peploandetails').Page_Label__c;
                //  pageReference objNextPage = new Pagereference('/'+redircetPageName);
                Pagereference per=new pagereference('/'+redircetPageName).setRedirect(True);
                per.setCookies(new Cookie[]{cookieApplicationId2 });
                return per;
            }
            else if(pagetoredirect=='2'){
                string redircetPageName= pages_config__c.getinstance('pepincomepage').Page_Label__c;
                Pagereference per=new pagereference('/'+redircetPageName).setRedirect(True);
                per.setCookies(new Cookie[]{cookieApplicationId2 });
                return per;
            }
            else if(pagetoredirect=='3'){
                return null;
            }
            else{
                return null;
            }
            
        }
        catch(Exception ex)
        {
            return pepUtilityClass.handlePageException(ex);
        }
        
    }
    //Thsi method is used to update the Application.
    public genesis__Applications__c UpdateApplication(genesis__Applications__c ObjApplication,List<sobject> lstSobject)
    {
        if(ReturnValue!=null && ReturnValue!='')
            objApplication.IP_Address__c =  ReturnValue; 
        Id idApplication;
        Map<string,string> childobjects = new Map<string,string>();         
        Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
        Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
        mapChildObjects.put('expense_and_debt__c',lstSobject);
        objApplication = pepInvokeCLMethodHelper.updateApplication(objApplication,mapRelatedObjects,mapChildObjects);
        return objApplication;
        
        
    }
    //This method is used to update the Total monthly expense.
    public void updateTotalmonthlyExpense()
    {
        if(lstWrapperQuestionSection1 != null && lstWrapperQuestionSection1.size() > 0)
        {
            if(totalMonthlyExpense != null)
                lstWrapperQuestionSection1[1].objInputValue = String.ValueOF(totalMonthlyExpense);
        }
        
    }
    
    public void updateExpenseData()
    {   
        if(lstWrapperQuestionSection1[1].objInputValue != totalMonthlyExpenseExcMortgage && isEdit == true)
        {
            lstExpenseToDelete =[select id from Expense_and_Debt__c where Type__c !='Mortgage Expense' and Type__c !='Debt' AND Application__c =:objApplication.Id];
        }
    }
    
    //this method queries questions for the Expense Page.
    public map<id,pepCmsQuestion__c> fetchPageQuestions(String strPageName)
    {
        map<id,pepCmsQuestion__c>  mapAllQuestions = new map<id,pepCmsQuestion__c>();
        
        mapAllQuestions = new map<id,pepCmsQuestion__c>( [SELECT  pepSection__c,pepRecordSequence__c,pepSection__r.pepHeader__c,pepSection__r.Name ,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                          pepIsRequired__c, pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                          pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, Id, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,
                                                          (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                           FROM pepCmsAnswer__r order by pepSequence__c ASC ), 
                                                          (SELECT  pepSection__c,pepRecordSequence__c,pepis_Consolidated_Debt__c,pepSubType__c ,pepGenericErrorMessage__c ,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                                           pepLabelPriorQuestion__c,pepSection__r.pepHeader__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepRelatedCSS__c
                                                           FROM CmsQuestion__r
                                                           ORDER BY pepSequence__c ASC) 
                                                          FROM pepCmsQuestion__c where pepPage__r.pepPageName__c =:strPageName
                                                          ORDER BY pepSequence__c ASC]);
        for(pepCmsQuestion__c objQues :mapAllQuestions.values())
        {
            if(objQues.pepCmsAnswer__r  != null && objQues.pepCmsAnswer__r.size() > 0 )
            {
                
                for(pepCmsAnswer__c objAnswer : objQues.pepCmsAnswer__r)
                {
                    mapofIdAnswerToLabel.put(objAnswer.Id,objAnswer.pepDisplayText__c);
                }
                
                
            }
            if(objQues.pepCMSAnswer__c != null)
            {
                if(MapOfAnswerIdToQuestion.get(objQues.pepCMSAnswer__c) == null)
                {
                    MapOfAnswerIdToQuestion.put(objQues.pepCMSAnswer__c,new List<pepCmsQuestion__c>());
                }
                MapOfAnswerIdToQuestion.get(objQues.pepCMSAnswer__c).add(objQues);
            }
            
        }                                                            
        
        return mapAllQuestions; 
    }
    //This method is used to query the Question if any like if somebody select the picklist option and there exist some question against that answer.
    public void callRelatedQuestionOfAnswers()
    {
        if(DebtRecordsNo != null && lstWrapperQuestionSection2.size() >= DebtRecordsNo
           && lstWrapperQuestionSection2[DebtRecordsNo].objInputValue != null 
           && lstWrapperQuestionSection2[DebtRecordsNo].objInputValue != '')
        {
            lstWrapperQuestionSection2[DebtRecordsNo].requiredCheck=true;
            List<pepCmsQuestion__c> lstQuestions = [SELECT Id, pepSection__c,pepis_Consolidated_Debt__c ,pepRecordSequence__c,pepSection__r.Name ,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                    pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                                    pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, 
                                                    
                                                    (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id 
                                                     FROM pepCmsAnswer__r order by pepSequence__c ASC), 
                                                    
                                                    (SELECT pepSection__c,pepis_Consolidated_Debt__c,pepRecordSequence__c,pepGenericErrorMessage__c,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                                     pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepSubType__c, 
                                                     pepRelatedCSS__c
                                                     FROM CmsQuestion__r
                                                     ORDER BY pepSequence__c ASC)
                                                    
                                                    FROM pepCmsQuestion__c
                                                    WHERE pepCMSAnswer__c =: lstWrapperQuestionSection2[DebtRecordsNo].objInputValue                                                 
                                                    ORDER BY pepSequence__c ASC];
            
            
            
            
            lstWrapperQuestionSection2[DebtRecordsNo].lstAnswersQuestions.clear();
            if(lstQuestions  != null && lstQuestions.size() > 0)
            {                               
                for(pepCmsQuestion__c objMasterQuestion : lstQuestions )
                {
                    wrapperQuestion objMasterQuestionWrap = new wrapperQuestion(objMasterQuestion,'');    
                    lstWrapperQuestionSection2[DebtRecordsNo].lstAnswersQuestions.add(objMasterQuestionWrap);
                }
            }
            
        }
        else
        {   
            lstWrapperQuestionSection2[DebtRecordsNo].requiredCheck=False;
            lstWrapperQuestionSection2[DebtRecordsNo].lstAnswersQuestions.clear();
        }
        
    }
    
    public void addRow()
    {
        loadCMSDataSection1New();
    }
    
    public void removeRow()
    {
        if(lstWrapperQuestionSection2.size() > 0)
        {
            Integer intListSize = lstWrapperQuestionSection2.size();
            if(intListSize  > 1)
            {
                Expense_and_Debt__c objExpenseToDelete = lstWrapperQuestionSection2[intListSize-1].objExpense;
                if(objExpenseToDelete != null && objExpenseToDelete.id != null)
                {
                    lstExpenseToDelete.add(objExpenseToDelete);
                }
                lstWrapperQuestionSection2.remove(intListSize-1);
            }
        }
        
    }
    //This method is used for working with data in first section of the page.
    public List<Sobject> makeSection1Data()
    {
        List<sobject> lstSobject = new List<sobject>();
        Decimal inputDecimal = 0;
        if(lstWrapperQuestionSection1.size() > 0)
        {
            Decimal TotalExpense =0;
            for(wrapperQuestion objWrapper : lstWrapperQuestionSection1)
            {
                if((objWrapper.objInputValue != null && objWrapper.objInputValue.trim() !=''))
                {
                    if(objWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c' && objWrapper.objCmsQuestion.pepFieldApiName__c =='Expense_Debt_Value__c')
                    {  
                        for(wrapperQuestion wp: objWrapper.lstSiblingQuestion)
                        {
                            for(wrapperAnswer EA: wp.lstExpectedAnsers)
                            {
                                If(wp.objInputValue == EA.objCmsAnswer.id)
                                {
                                    if(EA.objCmsAnswer.pepActualValue__c == 'weekly')
                                    {
                                        inputDecimal  += Decimal.ValueOf(objWrapper.objInputValue)*52/12;
                                    }
                                    
                                    if(EA.objCmsAnswer.pepActualValue__c == 'fortnightly')
                                    {
                                        inputDecimal  += Decimal.ValueOf(objWrapper.objInputValue)*26/12;
                                    }
                                    
                                    if(EA.objCmsAnswer.pepActualValue__c == 'monthly')
                                    {
                                        inputDecimal  += Decimal.ValueOf(objWrapper.objInputValue);
                                    }
                                    
                                    if(EA.objCmsAnswer.pepActualValue__c == 'quarterly')
                                    {
                                        inputDecimal  += Decimal.ValueOf(objWrapper.objInputValue)/3;
                                    }
                                    
                                    if(EA.objCmsAnswer.pepActualValue__c == 'yearly')
                                    {
                                        inputDecimal  += Decimal.ValueOf(objWrapper.objInputValue)/12;
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    
                    if(objWrapper.objCmsQuestion.pepType__c =='Percent'
                       && objWrapper.objCmsQuestion.pepFieldApiName__c != null
                       && objWrapper.objCmsQuestion.pepSObjectApiName__c =='genesis__Applications__c')
                    {
                        objapplication.put(objWrapper.objCmsQuestion.pepFieldApiName__c,Decimal.valueOf(objWrapper.objInputValue));
                        continue;
                    }
                    
                    
                    
                    
                    
                    if(objWrapper.objCmsQuestion.pepType__c =='Currency'
                       && objWrapper.objCmsQuestion.pepFieldApiName__c != null
                       && objWrapper.objCmsQuestion.pepSObjectApiName__c =='genesis__Applications__c')
                    {
                        TotalExpense += Decimal.ValueOF(objWrapper.objInputValue);
                        objapplication.put(objWrapper.objCmsQuestion.pepFieldApiName__c,TotalExpense);
                        objapplication.put('Total_Monthly_Expense_Exc_Mortgage__c',Decimal.valueOF(objWrapper.objInputValue));
                        
                        continue;
                    }
                    
                    Expense_and_Debt__c objExpenseDebt = new Expense_and_Debt__c(); 
                    if(objWrapper.objExpense != null)
                    {
                        objExpenseDebt = objWrapper.objExpense;
                    }
                    
                    objExpenseDebt.put('Type__c',strLivingExpenseType);
                    objExpenseDebt.put('Type_of_Expense_Debt__c',objWrapper.objCmsQuestion.pepLabelPriorQuestion__c);
                    if(objWrapper.objCmsQuestion.pepType__c =='Currency'
                       && objWrapper.objCmsQuestion.pepFieldApiName__c != null
                       && objWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                    {
                        TotalExpense +=inputDecimal;
                        objExpenseDebt.put(objWrapper.objCmsQuestion.pepFieldApiName__c,Decimal.valueOF(objWrapper.objInputValue));
                    }
                    if(objWrapper.objCmsQuestion.pepType__c =='Picklist'
                       && objWrapper.objCmsQuestion.pepFieldApiName__c != null
                       && objWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                    {
                        objExpenseDebt.put(objWrapper.objCmsQuestion.pepFieldApiName__c,mapofIdAnswerToLabel.get(objWrapper.objInputValue)); 
                    }  
                    
                    
                    if(objWrapper.lstSiblingQuestion != null && objWrapper.lstSiblingQuestion.size() > 0)
                    {
                        for(wrapperQuestion objChildWrapper : objWrapper.lstSiblingQuestion)
                        {
                            if(objChildWrapper.objInputValue != null )
                            {
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Currency' 
                                   && objChildWrapper.objCmsQuestion.pepFieldApiName__c != null
                                   && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,inputDecimal);
                                }
                                
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Picklist'
                                   && objChildWrapper.objCmsQuestion.pepFieldApiName__c != null 
                                   && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,mapofIdAnswerToLabel.get(objChildWrapper.objInputValue));
                                }
                                
                                
                            }
                            
                            
                        }
                    }
                    objExpenseDebt.Account__c=accountid;
                    lstSobject.add(objExpenseDebt);    
                }
                
            }
        }
        return lstSobject;
    }
    
    private List<Sobject> makePopUpSectionData(List<wrapperQuestion> lstWrapperQuestionPopUpSection, String expenseType)
    {
        List<sobject> lstSobject = new List<sobject>();
        Expense_and_Debt__c objExpenseDebt;
        
        if(!lstWrapperQuestionPopUpSection.isEmpty())
        {
            for(wrapperQuestion objWrapper : lstWrapperQuestionPopUpSection)
            {
                if((objWrapper.objInputValue != null && objWrapper.objInputValue.trim() !=''))
                {                      
                    objExpenseDebt = new Expense_and_Debt__c();
                    
                    if(objWrapper.objExpense != null)
                    {
                        objExpenseDebt = objWrapper.objExpense;
                    }
                    objExpenseDebt.put('Type__c', expenseType);
                    objExpenseDebt.put('Type_of_Expense_Debt__c',objWrapper.objCmsQuestion.pepLabelPriorQuestion__c);
                    
                    //same expression used multiple times so evaluated once
                    Boolean isFieldApiAvlAndSObjectAPIName = objWrapper.objCmsQuestion.pepFieldApiName__c != null 
                        && objWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c';
                    
                    if(objWrapper.objCmsQuestion.pepType__c =='Currency' && isFieldApiAvlAndSObjectAPIName)
                    {
                        objExpenseDebt.put(objWrapper.objCmsQuestion.pepFieldApiName__c,Decimal.ValueOF(objWrapper.objInputValue));
                    }
                    if(objWrapper.objCmsQuestion.pepType__c =='Picklist' && isFieldApiAvlAndSObjectAPIName)
                    {
                        objExpenseDebt.put(objWrapper.objCmsQuestion.pepFieldApiName__c,
                                           (expenseType != strEducationExpenseType)? mapofIdAnswerToLabel.get(objWrapper.objInputValue) : objWrapper.lstOptions[0].getLabel()); 
                    }  
                    
                    
                    if(objWrapper.lstSiblingQuestion != null && (!objWrapper.lstSiblingQuestion.isEmpty()))
                    {
                        for(wrapperQuestion objChildWrapper : objWrapper.lstSiblingQuestion)
                        {
                            //re evaluating for sibling question's child wrapper
                            isFieldApiAvlAndSObjectAPIName = objChildWrapper.objCmsQuestion.pepFieldApiName__c != null
                                && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c';
                            
                            if(objChildWrapper.objInputValue != null && objChildWrapper.objInputValue.trim() !='')
                            {
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Currency' && isFieldApiAvlAndSObjectAPIName)
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,Decimal.ValueOF(objChildWrapper.objInputValue));
                                }
                                
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Picklist' && isFieldApiAvlAndSObjectAPIName)
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,mapofIdAnswerToLabel.get(objChildWrapper.objInputValue));
                                }
                            }
                        }
                    }
                    objExpenseDebt.Account__c=accountid;     
                    lstSobject.add(objExpenseDebt);
                } 
                
                else
                {
                    if(objWrapper.objExpense != null && objWrapper.objExpense .id != null)
                    {
                        lstExpenseToDelete.add(objWrapper.objExpense );
                    }
                } 
            }
        }
        return lstSobject ;
    }
    //All makpopxsectiondata methods are used to fill or hjandle the working of the sections which gets open when soemone clicks on Go button on the expense page.
    //modified by : sushant kumar
    public List<Sobject> makePop1SectionData()
    {
        return makePopUpSectionData(lstWrapperQuestionPopUpSection1, strHouseHoldExpenseType);
    }
    
    //modified by : sushant kumar
    public List<Sobject> makePop2SectionData()
    {
        return makePopUpSectionData(lstWrapperQuestionPopUpSection2, strFoodAndLivingExpenseTpe);
    }  
    
    //modified by : sushant kumar
    public List<Sobject> makePop3SectionData()
    {
        return makePopUpSectionData(lstWrapperQuestionPopUpSection3, strEntertainmentExpenseType);
    }
    
    //modified by : sushant kumar
    public List<Sobject> makePop4SectionData()
    {
        return makePopUpSectionData(lstWrapperQuestionPopUpSection4, strEducationExpenseType);
    }
    
    //modified by : sushant kumar
    public List<Sobject> makePop5SectionData()
    {
        return makePopUpSectionData(lstWrapperQuestionPopUpSection5, strVTExpenseType);
    }
    
    //modified by : sushant kumar
    public List<Sobject> makePop6SectionData()
    {
        return makePopUpSectionData(lstWrapperQuestionPopUpSection6, strInsuranceExpenseType);
    }
    //this methos is used to hndle the data fo the second section of the main page.
    public List<Sobject> makeSection2Data()
    {
        
        List<Sobject> lstSobject = new List<sobject>();
        Integer i =1; 
        if(lstWrapperQuestionSection2.size() > 0)
        {
            for(wrapperQuestion objWrapper : lstWrapperQuestionSection2 )
            {
                if((objWrapper.objInputValue != null && objWrapper.objInputValue.trim() !=''))
                {                      
                    
                    Expense_and_Debt__c objExpenseDebt = new Expense_and_Debt__c(); 
                    if(objWrapper.objExpense != null)
                    {
                        objExpenseDebt = objWrapper.objExpense;
                        if(isConsolidatingDebt == false)
                        {
                            boolean boolval = false;
                            objExpenseDebt.put('Consolidate_As_A_Debt__c',boolval);
                            objExpenseDebt.put('Are_you_Consolidating_your_Debt__c','');
                        }
                    }                       
                    objExpenseDebt.put('Type__c',strDebtType);
                    objExpenseDebt.put('Type_of_Expense_Debt__c',objWrapper.objInputValue);
                    If(mapofIdAnswerToLabel.get(objWrapper.objInputValue) =='Credit card')
                    {
                        objExpenseDebt.put('Is_Revolving_Credit__c',true);                        
                    }
                    else
                    {
                        objExpenseDebt.put('Is_Revolving_Credit__c',false);                        
                    }
                    if(objWrapper.objCmsQuestion.pepType__c =='Currency'
                       && objWrapper.objCmsQuestion.pepFieldApiName__c != null
                       && objWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                    {
                        objExpenseDebt.put(objWrapper.objCmsQuestion.pepFieldApiName__c,Decimal.ValueOF(objWrapper.objInputValue));
                    }
                    if(objWrapper.objCmsQuestion.pepType__c =='Picklist'
                       && objWrapper.objCmsQuestion.pepFieldApiName__c != null
                       && objWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                    {
                        objExpenseDebt.put(objWrapper.objCmsQuestion.pepFieldApiName__c,mapofIdAnswerToLabel.get(objWrapper.objInputValue)); 
                    }  
                    
                    
                    if(objWrapper.lstSiblingQuestion != null && objWrapper.lstSiblingQuestion.size() > 0)
                    {
                        for(wrapperQuestion objChildWrapper : objWrapper.lstSiblingQuestion)
                        {
                            if(objChildWrapper.objInputValue != null &&  objChildWrapper.objInputValue!='')
                            {
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Currency' 
                                   && objChildWrapper.objCmsQuestion.pepFieldApiName__c != null
                                   && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,Decimal.ValueOF(objChildWrapper.objInputValue));
                                }
                                
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Picklist'
                                   && objChildWrapper.objCmsQuestion.pepFieldApiName__c != null 
                                   && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,mapofIdAnswerToLabel.get(objChildWrapper.objInputValue));
                                }
                                
                                
                            }
                            
                            
                        }
                    }
                    
                    
                    if(objWrapper.lstAnswersQuestions != null && objWrapper.lstAnswersQuestions.size() > 0)
                    {
                        for(wrapperQuestion objChildWrapper : objWrapper.lstAnswersQuestions)
                        {
                            if(objChildWrapper.objInputValue != null && objChildWrapper.objInputValue.trim() !='')
                            {
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Currency' 
                                   && objChildWrapper.objCmsQuestion.pepFieldApiName__c != null
                                   && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,Decimal.ValueOF(objChildWrapper.objInputValue));
                                }
                                
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Picklist'
                                   && objChildWrapper.objCmsQuestion.pepFieldApiName__c != null 
                                   && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c')
                                {
                                    objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,mapofIdAnswerToLabel.get(objChildWrapper.objInputValue));
                                }
                                
                                
                                if(objChildWrapper.objCmsQuestion.pepType__c =='Button' 
                                   && objChildWrapper.objCmsQuestion.pepFieldApiName__c != null
                                   && objChildWrapper.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c'  && isConsolidatingDebt)
                                {
                                    boolean boolValue = false;
                                    if(objChildWrapper.objInputValue =='true')
                                    {
                                        boolValue = true;
                                        objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,boolValue);
                                    } 
                                    else if(objChildWrapper.objInputValue =='false')
                                    {
                                        boolValue  =false;
                                        objExpenseDebt.put(objChildWrapper.objCmsQuestion.pepFieldApiName__c,boolValue);
                                        
                                    }                                       
                                    
                                    if(objWrapper.selectedRadio =='no')
                                    {
                                        objExpenseDebt.put('Are_you_Consolidating_your_Debt__c','no');
                                    } 
                                    
                                    
                                    
                                    
                                }
                                
                                
                            }                                
                            
                        }
                    }
                    objExpenseDebt.Account__c=accountid;    
                    lstSobject.add(objExpenseDebt);
                }  
                i++;  
            }
        }
        return lstSobject ;
    }
    
    //This method is used for generating the dynamic header line per section
    public void renderSectionStory1()
    {
        List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                              pepSectionUniqueName__c, pepType__c, 
                                              pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                              (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , 
                                               pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                              from pepCmsSection__c                                                   
                                              where pepSectionUniqueName__c='Your share of living expenses'
                                              and pepPage__r.pepPageName__c='Expenses'];
        
        if(lstSections != null && lstSections.size() > 0)
        {
            strSectionStorySection1 = lstSections[0].pepSectionStory__c; 
        }   
        decsectionStory1Amount = 0;
        for(wrapperQuestion obj :lstWrapperQuestionSection1)
        { 
            if(obj.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c' && obj.objCmsQuestion.pepFieldApiName__c =='Expense_Debt_Value__c')
            {
                if(obj.objInputValue != null && obj.objInputValue !='') 
                    //decsectionStory1Amount  +=Decimal.ValueOf(obj.objInputValue);    
                    
                    for(wrapperQuestion wp: obj.lstSiblingQuestion)
                {
                    for(wrapperAnswer EA: wp.lstExpectedAnsers)
                    {
                        If(wp.objInputValue == EA.objCmsAnswer.id)
                        {
                            if(EA.objCmsAnswer.pepActualValue__c == 'weekly')
                            {
                                decsectionStory1Amount  += Decimal.ValueOf(obj.objInputValue)*52/12;
                            }
                            
                            if(EA.objCmsAnswer.pepActualValue__c == 'fortnightly')
                            {
                                decsectionStory1Amount  += Decimal.ValueOf(obj.objInputValue)*26/12;
                            }
                            
                            if(EA.objCmsAnswer.pepActualValue__c == 'monthly')
                            {
                                decsectionStory1Amount  += Decimal.ValueOf(obj.objInputValue);
                            }
                            
                            if(EA.objCmsAnswer.pepActualValue__c == 'quarterly')
                            {
                                decsectionStory1Amount  += Decimal.ValueOf(obj.objInputValue)/3;
                            }
                            
                            if(EA.objCmsAnswer.pepActualValue__c == 'yearly')
                            {
                                decsectionStory1Amount  += Decimal.ValueOf(obj.objInputValue)/12;
                            }
                            
                        }
                    }
                }
                
            }
            if(obj.objCmsQuestion.pepSObjectApiName__c =='genesis__Applications__c' && obj.objCmsQuestion.pepFieldApiName__c =='Total_Monthly_Expense__c')
            {
                if(obj.objInputValue != null && obj.objInputValue !='') 
                    decsectionStory1Amount  +=Decimal.ValueOf(obj.objInputValue);
            }
        }
        Decimal dollars;
        Decimal cents;
        dollars = decsectionStory1Amount.intValue();
        cents = decsectionStory1Amount - decsectionStory1Amount.intValue();
        cents = cents.setScale(2);
        
        
        strSectionStorySection1 = strSectionStorySection1.replace('{}',  dollars.format() + cents.toPlainString().substring(1));
    }
    //This method is used for generating the dynamic header line per section
    public void renderSectionStory2()
    {
        List<pepCmsSection__c> lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, 
                                              pepSectionUniqueName__c, pepType__c, 
                                              pepSectionStory__c ,pepPage__r.pepPageName__c ,
                                              (select id, Name,pepSObjectApiName__c, pepFieldApiName__c, pepType__c , 
                                               pepLabelPriorQuestion__c from pepQuestion__r order by pepSequence__c ASC)                                             
                                              from pepCmsSection__c                                                   
                                              where pepSectionUniqueName__c='What you owe (debts)'
                                              and pepPage__r.pepPageName__c='Expenses'];
        
        
        if(lstSections != null && lstSections.size() > 0)
        {
            strSectionStorySection2 = lstSections[0].pepSectionStory__c;
        }
        Decimal decsectionStory2Amount  = 0;
        for(wrapperQuestion obj :lstWrapperQuestionSection2)
        {   
            String InputValue;
            for(wrapperQuestion wp: obj.lstSiblingQuestion)
            {
                
                if(wp.objCmsQuestion.pepSObjectApiName__c =='Expense_and_Debt__c' && wp.objCmsQuestion.pepFieldApiName__c =='Expense_Debt_Value__c')
                {
                    InputValue = wp.objInputValue;
                }
                
                for(wrapperAnswer EA: wp.lstExpectedAnsers)
                {
                    If(wp.objInputValue == EA.objCmsAnswer.id)
                    {
                        if(EA.objCmsAnswer.pepActualValue__c == 'weekly')
                        {
                            decsectionStory2Amount   += Decimal.ValueOf(InputValue)*52/12;
                        }
                        
                        if(EA.objCmsAnswer.pepActualValue__c == 'fortnightly')
                        {
                            decsectionStory2Amount   += Decimal.ValueOf(InputValue)*26/12;
                        }
                        
                        if(EA.objCmsAnswer.pepActualValue__c == 'monthly')
                        {
                            decsectionStory2Amount   += Decimal.ValueOf(InputValue);
                        }
                        
                        if(EA.objCmsAnswer.pepActualValue__c == 'quarterly')
                        {
                            decsectionStory2Amount   += Decimal.ValueOf(InputValue)/3;
                        }
                        
                        if(EA.objCmsAnswer.pepActualValue__c == 'yearly')
                        {
                            decsectionStory2Amount   += Decimal.ValueOf(InputValue)/12;
                        }
                        
                    }
                }
            }
            
        }
        Decimal dollars;
        Decimal cents;
        dollars = decsectionStory2Amount.intValue();
        cents = decsectionStory2Amount  - decsectionStory2Amount.intValue();
        cents = cents.setScale(2);
        strSectionStorySection2 = strSectionStorySection2.replace('{}', dollars.format() + cents.toPlainString().substring(1));
    }
    //This method is used to handle the rendering of yes/No button.
    public void handleYesNoButton()
    {  
        if(ApexPages.currentPage().getParameters().get('text') != null){
            if(ApexPages.currentPage().getParameters().get('text') == 'yes')
                sectionmessage='';
        }
        String strSelected = ApexPages.currentPage().getParameters().get('text');
        String rowNo = ApexPages.currentPage().getParameters().get('rowIndex');
        String quesAnsRowNo = ApexPages.currentPage().getParameters().get('QuesAnsrowIndex');
        lstWrapperQuestionSection2[Integer.valueOf(rowNo)-1].selectedRadio = strSelected;
        if(strSelected =='yes')
        {
            lstWrapperQuestionSection2[Integer.valueOf(rowNo)-1].lstAnswersQuestions[Integer.valueOf(quesAnsRowNo)-1].objInputValue= 'true';
        }
        if(strSelected =='no')
        {
            lstWrapperQuestionSection2[Integer.valueOf(rowNo)-1].lstAnswersQuestions[Integer.valueOf(quesAnsRowNo)-1].objInputValue= 'false';
        }
        
    }
    
    public list<wrapperQuestion> cloneData(List<wrapperQuestion> lstSourceList ,List<wrapperQuestion> lstTargetList)
    {
        if(lstSourceList .size() > 0)
        {
            
            for(wrapperQuestion objWrapperQues : lstSourceList)
            {
                wrapperQuestion objWrapperQues1 = new wrapperQuestion (objWrapperQues.objCmsQuestion,objWrapperQues.objInputValue);
                objWrapperQues1.objExpense = objWrapperQues.objExpense ;
                
                //objWrapperQues1.lstSiblingQuestion = new List<wrapperQuestion >();
                //objWrapperQues1.lstSiblingQuestion.addAll(objWrapperQues.lstSiblingQuestion);
                list<wrapperQuestion> lstSiblingWrap = new list<wrapperQuestion>();
                for(wrapperQuestion objSibling : objWrapperQues.lstSiblingQuestion)
                {
                    wrapperQuestion objQuestionWrapTemp = new wrapperQuestion(objSibling.objCmsQuestion,objSibling.objInputValue);
                    lstSiblingWrap.add(objQuestionWrapTemp );
                } 
                
                if(lstSiblingWrap != null && lstSiblingWrap.size() > 0)
                {
                    objWrapperQues1.lstSiblingQuestion =lstSiblingWrap;
                }                               
                lstTargetList.add(objWrapperQues1);
            }
        }
        return lstTargetList;
    }
    
    
    public void AssignOriginalValue()
    {
        lstWrapperQuestionPopUpSection1Clone  = new List<WrapperQuestion>();      
        lstWrapperQuestionPopUpSection1Clone = cloneData(lstWrapperQuestionPopUpSection1 ,lstWrapperQuestionPopUpSection1Clone); 
        lstWrapperQuestionPopUpSection2Clone  = new List<WrapperQuestion>();                          
        lstWrapperQuestionPopUpSection2Clone = cloneData(lstWrapperQuestionPopUpSection2 ,lstWrapperQuestionPopUpSection2Clone);
        lstWrapperQuestionPopUpSection3Clone  = new List<WrapperQuestion>();                           
        lstWrapperQuestionPopUpSection3Clone = cloneData(lstWrapperQuestionPopUpSection3 ,lstWrapperQuestionPopUpSection3Clone);
        lstWrapperQuestionPopUpSection4Clone  = new List<WrapperQuestion>();                            
        lstWrapperQuestionPopUpSection4Clone = cloneData(lstWrapperQuestionPopUpSection4 ,lstWrapperQuestionPopUpSection4Clone);
        lstWrapperQuestionPopUpSection5Clone  = new List<WrapperQuestion>();                             
        lstWrapperQuestionPopUpSection5Clone = cloneData(lstWrapperQuestionPopUpSection5 ,lstWrapperQuestionPopUpSection5Clone);
        lstWrapperQuestionPopUpSection6Clone  = new List<WrapperQuestion>();                              
        lstWrapperQuestionPopUpSection6Clone = cloneData(lstWrapperQuestionPopUpSection6 ,lstWrapperQuestionPopUpSection6Clone);
        
        
    }
    
    public void AssignClonedValue()
    {
        lstWrapperQuestionPopUpSection1  = new List<WrapperQuestion>();        
        lstWrapperQuestionPopUpSection1 = cloneData(lstWrapperQuestionPopUpSection1Clone,lstWrapperQuestionPopUpSection1);         
        lstWrapperQuestionPopUpSection2  = new List<WrapperQuestion>();      
        lstWrapperQuestionPopUpSection2 = cloneData(lstWrapperQuestionPopUpSection2Clone ,lstWrapperQuestionPopUpSection2); 
        lstWrapperQuestionPopUpSection3  = new List<WrapperQuestion>();         
        lstWrapperQuestionPopUpSection3 = cloneData(lstWrapperQuestionPopUpSection3Clone ,lstWrapperQuestionPopUpSection3 ); 
        lstWrapperQuestionPopUpSection4  = new List<WrapperQuestion>();
        lstWrapperQuestionPopUpSection4 = cloneData(lstWrapperQuestionPopUpSection4Clone,lstWrapperQuestionPopUpSection4 ); 
        lstWrapperQuestionPopUpSection5  = new List<WrapperQuestion>();
        lstWrapperQuestionPopUpSection5 = cloneData(lstWrapperQuestionPopUpSection5Clone,lstWrapperQuestionPopUpSection5 );
        lstWrapperQuestionPopUpSection6  = new List<WrapperQuestion>(); 
        lstWrapperQuestionPopUpSection6 = cloneData(lstWrapperQuestionPopUpSection6Clone ,lstWrapperQuestionPopUpSection6 );
        // str1=lstWrapperQuestionPopUpSection1Clone[0].objInputValue ;         
        
    }
    
    
    
    Public Pagereference checkvalidation(){
        //Modified By -Sushant Kumar
        //Exception handling added to this code.
        
        try 
        {
            sectionmessage='';
            SaveData=True;
            formattedamount=false;
            showDebtLimit = false;
            SaveData=basicvalidations();
            Decimal remainingAmount=0;
            integer debtLimit =0;
            Boolean containsOneYes=True;
            if(isConsolidatingDebt==True && SaveData==True){
                containsOneYes=False;
                SaveData=False;
                if(lstWrapperQuestionSection2 != null && lstWrapperQuestionSection2.size()>0){
                    for(wrapperQuestion masterquestion:lstWrapperQuestionSection2){
                        Boolean containsinnerOneYes=false;
                        if(masterquestion.lstAnswersQuestions != null && masterquestion.lstAnswersQuestions.size()>0){
                            for(wrapperQuestion answerQuestion:masterquestion.lstAnswersQuestions){
                                if(answerQuestion.objinputvalue!=''){
                                    if(answerQuestion.objCmsQuestion.pepFieldApiName__c=='Consolidate_As_A_Debt__c'){
                                        
                                        if(answerQuestion.objinputvalue=='true'){
                                            containsinnerOneYes=True;
                                            debtLimit++;
                                        }
                                    }
                                }
                            }
                            if(containsinnerOneYes==True){
                                containsOneYes=True;
                                for(wrapperQuestion answerQuestion:masterquestion.lstAnswersQuestions){
                                    if(answerQuestion.objinputvalue !=''){
                                        if(answerQuestion.objCmsQuestion.pepFieldApiName__c=='Amount_Remaining_as_Debt__c'){
                                            
                                            remainingAmount+=Decimal.valueof(answerQuestion.objinputvalue);
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                if(containsOneYes==True){
                    Decimal PercenttoSubtract=0;
                    initialAmount=requiredLoanAmount;
                    initialAmount=initialAmount.setscale(2);
                    if(DebtPercentComparison__c.getinstance('DebtPercent').Debt_Percent__c != null)
                        PercenttoSubtract=DebtPercentComparison__c.getinstance('DebtPercent').Debt_Percent__c;
                    Decimal amounttosubtract=(PercenttoSubtract*requiredLoanAmount)/100;
                    amountAfterDebt=initialAmount-amounttosubtract;
                    amountAfterDebt=amountAfterDebt.setscale(2);
                    if(remainingAmount>=amountAfterDebt && remainingAmount<=initialAmount){
                        Savedata=True;
                        
                    }
                    else{
                        Savedata=False;
                        formattedamount=True;
                        return null;
                        //sectionmessage='Sum of Remaining Amount should be between'+' '+'$'+amountAfterDebt+' '+'and'+' '+'$'+initialAmount;
                    }
                    
                    
                    
                }
                else{
                    Savedata=False;
                    if(debtConLimit==0){
                        sectionmessage=Label.enforcingConsolidate;
                    }
                    else{
                        showDebtLimit = true;
                    }
                    return null;
                }
                if(debtConLimit !=debtLimit && Savedata==True && debtConLimit!=0)        
                {      
                    Savedata=False;     
                    showDebtLimit = true;       
                    //  sectionmessage='you have to select'+' '+string.valueOf(debtConLimit)+' '+'debt con';      
                }
            }
            return null;
        }
        catch(Exception ex)
        {
            return pepUtilityClass.handlePageException(ex);
        }
        
    }
    @testvisible Private Boolean basicvalidations(){
        Boolean toreturn=True;
        if(lstWrapperQuestionSection2 != null && lstWrapperQuestionSection2.size()>0){
            for(wrapperQuestion masterquestion:lstWrapperQuestionSection2){
                if(masterquestion.lstAnswersQuestions != null && masterquestion.lstAnswersQuestions.size()>0){
                    Decimal amountRemaining=0;
                    Decimal creditRemaining=0;
                    Boolean creditExist=False;
                    for(wrapperQuestion answerQuestion:masterquestion.lstAnswersQuestions){
                        if(answerQuestion.objinputValue != ''){
                            if(answerQuestion.objCmsQuestion.pepFieldApiName__c=='Amount_Remaining_as_Debt__c'){
                                
                                if(Decimal.valueof(answerQuestion.objinputValue)<=0){
                                    toreturn=False;
                                    sectionmessage='Amount Remaining cannot be equal to'+' '+'$'+Decimal.valueof(answerQuestion.objinputValue);
                                    break;
                                }
                                else{
                                    amountRemaining=Decimal.valueof(answerQuestion.objinputValue);
                                }
                                
                            }
                            
                            if(answerQuestion.objCmsQuestion.pepFieldApiName__c=='Credit_Limit__c'){
                                
                                if(Decimal.valueof(answerQuestion.objinputValue)<=0){
                                    toreturn=False;
                                    sectionmessage='Credit Limit cannot be equal to'+' '+'$'+Decimal.valueof(answerQuestion.objinputValue);
                                    break;
                                }
                                else{
                                    creditExist=True;
                                    creditRemaining=Decimal.valueof(answerQuestion.objinputValue);
                                }
                            }
                        }
                    }
                    if(toreturn==False)
                        break;
                }
                if(toreturn==False)
                    break;
            }
        }
        return toreturn;
    }  
    
    Public Pagereference checkcookie(){
        //Modified By -Sushant Kumar
        //Exception handling added to this code.
        try
        {
            Pagereference pr=Peputilityclass.checkCookieAndRedirect();
            if(pr == null){
                Pagereference temp=PeputilityClass.HandleRedirectSecurity();
                return temp;
            }
            else{
                return pr;
            }
        }
        catch(Exception ex)
        {
            return pepUtilityClass.handlePageException(ex);
        }   
    }
    
    public class ExpensePageException extends Exception{}
}