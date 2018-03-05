public class pepCmsModelContainer
{
    public genesis__Applications__c objApplication{get;set;}
    public Account objAccount{get;set;}
    public list<Income__c> lstIncome{get;set;}
    public list<Expense_and_Debt__c> lstExpenses{get;set;}
    public list<wrapperQuestion> lstWrapperQuestion{get;set;}
    public list<wrapperQuestion> lstWrapperQuestion_Combine{get;set;} 
    public wrapperQuestion objWrapperQuestion{get;set;}
    public wrapperAnswer objWrapperAnswer{get;set;}
    public string strPageName{get;set;}
    public string strSectionName{get;set;}
    public boolean isInitialized {get; set;}
    public map<Id,string> mpAnswerIdToVal{get;set;}    
    public list<Residential_Address__c> lstResidentialAddress{get;set;}
    public list<genesis__Employment_Information__c> lstEmploymentInformation{get;set;}
    
    public pepCmsModelContainer()
    {
         isInitialized = false;
         lstWrapperQuestion = new list<wrapperQuestion>();
         objWrapperQuestion =  new wrapperQuestion();
         objWrapperAnswer =   new wrapperAnswer();
         lstIncome = new list<Income__c>();
         lstExpenses = new list<Expense_and_Debt__c>();
         objAccount = new Account();
         objApplication = new genesis__Applications__c();
         lstWrapperQuestion_Combine = new list<wrapperQuestion>();
         mpAnswerIdToVal =  new map<Id, string>();
         lstResidentialAddress = new list<Residential_Address__c>();
         lstEmploymentInformation =  new list<genesis__Employment_Information__c>();
    }
    
    public class wrapperQuestion{
        public pepCmsQuestion__c objCmsQuestion {get; set;}
        public decimal intQuestionSequence {get; set;}
        public List<wrapperAnswer> lstExpectedAnsers {get; set;}
        public List<wrapperQuestion> lstSiblingQuestion {get; set;} // sibling Question
        public string objInputValue {get; set;} 
        public list<selectOption> lstOptions {get; set;}
        public List<wrapperQuestion> lstAnswersQuestions{get;set;}
        public Date dateValue {get;set;}
        
        public wrapperQuestion(){}
        public wrapperQuestion(pepCmsQuestion__c objQuestion, string InputAnswers){
            objCmsQuestion = objQuestion;
            intQuestionSequence = objQuestion.pepSequence__c;
            lstExpectedAnsers = new List<wrapperAnswer>();
            lstSiblingQuestion = new List<wrapperQuestion>();
            lstOptions = new list<selectOption>();
            objInputValue = InputAnswers; 
            
            
            if(objQuestion.pepCmsAnswer__r!=null && objQuestion.pepCmsAnswer__r.size()>0)
            {
                for(pepCmsAnswer__c objAnswer : objQuestion.pepCmsAnswer__r){
                    lstExpectedAnsers.add(new wrapperAnswer(objAnswer));
                   // if(objAnswer.pepCmsQuestion__r.pepType__c == 'Picklist')
                    //    lstOptions.add(new selectOption(objAnswer.pepDisplayText__c, objAnswer.pepDisplayText__c));
                    //else
                        if(objAnswer.pepDisplayText__c == 'Choose one')
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
    
    public class wrapperAnswer{
        public pepCmsAnswer__c objCmsAnswer {get; set;}
        public list<wrapperQuestion> lstChildQuestion {get; set;}        
        
        public wrapperAnswer(){}
        public wrapperAnswer(pepCmsAnswer__c objAns){
            lstChildQuestion = new list<wrapperQuestion>();
            objCmsAnswer = objAns;          
        }
    }
    
    // -----------------------------------------------------------------------------------------------
    // This method will pass values to component
    // -------------------------------------------------------------------------------------------------
    // Created Date: 03-Mar-2016 Created By: Bhawna Pipal Email: bhawna.pipal@saasfocus.com
    // -------------------------------------------------------------------------------------------------
    
    map<Integer, Income__c> mpSequenceToIncome =  new  map<Integer, Income__c>();
    list<Income__c> lstIncomeTemp = new list<Income__c>();
    set<Income__c> setIncome =  new set<Income__c>();
    
    public void ReadControlValue ()
    {  
        //strPageName  = 'Income Details'; 
        //strSectionName = 'Income Details';
        system.debug('PageName::'+strPageName);
        system.debug('Section Name::'+strPageName);
        lstIncome=new List<Income__c>();
        if((strPageName  == 'Income Details' && strSectionName == 'Income Details'))
        {
             Income__c objTempIncome; 
            for(wrapperQuestion objWrapQues: lstWrapperQuestion)
            {    
                // 1. work for Main Ques and Answer
                 //Income__c objTempIncome;
                 system.debug('Initial:: '+objWrapQues.objInputValue);
                 if(objWrapQues.objInputValue ==  null) break;              
                
                 
                funcToCreateIncomeRecords(objWrapQues,objTempIncome);
                //lstIncome.add(objI );
                
               
                // 3. work for Questions under ansers
                if(objWrapQues.lstAnswersQuestions!=null && objWrapQues.lstAnswersQuestions.size()>0)
                {
                    for(wrapperQuestion objChildWrapQues: objWrapQues.lstAnswersQuestions)
                    {
                        
                        funcToCreateIncomeRecords(objChildWrapQues,objTempIncome)   ;            
                    }
                }
                
            }
            
            system.debug('mpSequenceToIncome::'+mpSequenceToIncome);
            system.debug('Bhawna setIncome::-- '+setIncome);
            system.debug('setIncome::'+setIncome.size());
            system.debug('Bhawna Income::size '+lstIncome.size());
            lstIncome.addAll(setIncome);
            system.debug('Bhawna Income:: '+lstIncome);
            system.debug('Bhawna Income::size '+lstIncome.size());
           
            //lstIncome =  new list<Income__c>();
           
        }else
        {
            for(wrapperQuestion objWrap : lstWrapperQuestion)
            {
                if(objWrap.objCmsQuestion.pepSObjectApiName__c == 'genesis__Applications__c')
                {
                    if(objWrap.objInputValue!=null && objWrap.objInputValue!='')
                    {                       
                        genesis__Applications__c objApp = new genesis__Applications__c();
                        decimal dcml = 0;
                        string str='';
                        if(objWrap.objCmsQuestion.pepType__c == 'Currency')
                        {
                            dcml  = decimal.valueOf(objWrap.objInputValue);
                            objApp.put(objWrap.objCmsQuestion.pepFieldApiName__c,dcml);
                        }
                        else if(objWrap.objCmsQuestion.pepType__c == 'Picklist' || objWrap.objCmsQuestion.pepType__c == 'Button')
                        {
                            system.debug('mpAnswerIdToVal.get(objWrap.objInputValue)::'+mpAnswerIdToVal.get(objWrap.objInputValue));
                            str = mpAnswerIdToVal.get(objWrap.objInputValue); 
                            objApp.put(objWrap.objCmsQuestion.pepFieldApiName__c,str);                       
                        }else
                        {
                            str = objWrap.objInputValue; 
                            objApp.put(objWrap.objCmsQuestion.pepFieldApiName__c,str);  
                        }
                        
                        objApplication = objApp;
                    }
                }
                
                if(objWrap.objCmsQuestion.pepSObjectApiName__c == 'Account')
                {    
                    if(objWrap.objInputValue!=null && objWrap.objInputValue!='')
                    {   
                        system.debug('Ques-Api Name:: '+objWrap.objCmsQuestion.pepFieldApiName__c);
                        Account objAcc;
                        if(objAccount ==  null)
                        {
                            objAcc =  new Account();
                        }else
                            objAcc = objAccount;                
                        
                        
                        if(objWrap.objCmsQuestion.pepType__c == 'Currency')
                        {
                            decimal dcml  = decimal.valueOf(objWrap.objInputValue);
                             objAcc.put(objWrap.objCmsQuestion.pepFieldApiName__c,dcml);
                        }
                        else if(objWrap.objCmsQuestion.pepType__c == 'Picklist' || objWrap.objCmsQuestion.pepType__c == 'Button')
                        {
                            system.debug('mpAnswerIdToVal.get(objWrap.objInputValue)::'+mpAnswerIdToVal.get(objWrap.objInputValue));
                            string str = mpAnswerIdToVal.get(objWrap.objInputValue); 
                            objAcc.put(objWrap.objCmsQuestion.pepFieldApiName__c,str);                       
                        }
                        else
                        {   
                            if(objWrap.objCmsQuestion.pepType__c =='Date')
                            {
                                string str = objWrap.objInputValue; 
                                objAcc.put(objWrap.objCmsQuestion.pepFieldApiName__c,Date.valueOf(str)); 
                            } 
                            else
                            {
                                string str = objWrap.objInputValue; 
                                objAcc.put(objWrap.objCmsQuestion.pepFieldApiName__c,str); 
                            
                            }
                                                 
                        }
                        
                        objAccount = objAcc;
                        system.debug('Account-Container:: '+objAccount);
                    }
                }                
            }
        }
    }
     
    private void funcToCreateIncomeRecords(wrapperQuestion objWrapQues, Income__c  objTempIncome  )
    {       
            system.debug('objWrapQues:: '+objWrapQues.objInputValue);
            system.debug('objWrapQues-label:: '+objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c);
            
            
            system.debug('mpAnswerIdToVal:: '+mpAnswerIdToVal);
            // 1. work for Main Ques and Answer
            integer i=0;
            if(objWrapQues!=null && objWrapQues.objCmsQuestion!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c.contains('Primary')) i= i+1;
            if(objWrapQues!=null && objWrapQues.objCmsQuestion!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c.contains('Secondary')) i= i+2;
            if(objWrapQues!=null && objWrapQues.objCmsQuestion!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c.contains('Third')) i= i+3;
            if(objWrapQues!=null && objWrapQues.objCmsQuestion!=null  && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c.contains('Fourth')) i= i+4;
            if(objWrapQues!=null && objWrapQues.objCmsQuestion!=null  &&objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c!=null &&  objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c.contains('Fifth')) i= i+5;
            
            // if Income record is already there for a sequence then update same income record 
            if(objWrapQues!=null && objWrapQues.objCmsQuestion!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c!=null && objWrapQues.objCmsQuestion.pepLabelPriorQuestion__c.contains('other')) i= i+1;
            
             if(i!=0)
             {
                system.debug('i::'+i);
                system.debug('mpSequenceToIncome.get(i):: '+mpSequenceToIncome.get(i));
                
                
                if(objWrapQues.objInputValue!=null && objWrapQues.objInputValue!='')
                { 
                    if(mpSequenceToIncome!=null && mpSequenceToIncome.size()>0 && mpSequenceToIncome.get(i)!=null )
                    {
                        setIncome.remove( mpSequenceToIncome.get(i));   
                        objTempIncome  =  mpSequenceToIncome.get(i);
                    }else{
                        system.debug('Count---');
                        objTempIncome =  new Income__c();
                        objTempIncome.Sequence__c = i;   
                    }
                    system.debug('type:;'+objWrapQues.objCmsQuestion.pepType__c);
                    if(objWrapQues.objCmsQuestion.pepType__c == 'Currency')
                    {
                        system.debug('objWrapQues.objInputValue--'+objWrapQues.objInputValue);
                        
                            decimal dcml  = decimal.valueOf(objWrapQues.objInputValue);
                             objTempIncome.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,dcml);
                         
                    }
                    else if(objWrapQues.objCmsQuestion.pepType__c == 'Picklist' || objWrapQues.objCmsQuestion.pepType__c == 'Button')
                    {
                        system.debug('objWrapQues.objInputValue::'+objWrapQues.objInputValue);
                        system.debug('mpAnswerIdToVal.get(objWrap.objInputValue)::'+mpAnswerIdToVal.get(objWrapQues.objInputValue));
                        string str = mpAnswerIdToVal.get(objWrapQues.objInputValue); 
                        objTempIncome.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,str);                       
                    }
                    else
                    {
                        string str = objWrapQues.objInputValue; 
                         if(objWrapQues.objCmsQuestion.pepFieldApiName__c!=null) 
                             objTempIncome.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,str);                       
                    }
                
                 
                 system.debug('income--befre sib::'+objTempIncome); 
              }      
                //objTempIncome.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,objWrapQues.objCmsQuestion.pepType__c == 'Currency'? decimal.valueOf(objWrapQues.objInputValue) :objWrapQues.objInputValue  );
               // left for button
                // 2. work for SQ            
                
                if(objTempIncome==null) objTempIncome =  new Income__c();
                for(wrapperQuestion objSQ: objWrapQues.lstSiblingQuestion )
                {
                    system.debug('Sibling value:: '+objSQ.objInputValue);
                    system.debug('sibling Type:: '+objSQ.objCmsQuestion.pepType__c);
                    if(objSQ.objInputValue !=null && objSQ.objInputValue!= '' && objSQ.objCmsQuestion!=null && objSQ.objCmsQuestion.pepFieldApiName__c!=null )
                    {
                        if(objSQ.objCmsQuestion.pepType__c == 'Currency')
                        {
                            decimal dcml  = decimal.valueOf(objSQ.objInputValue);
                            objTempIncome.put(objSQ.objCmsQuestion.pepFieldApiName__c,dcml);
                        }
                        else if(objSQ.objCmsQuestion.pepType__c == 'Picklist' || objSQ.objCmsQuestion.pepType__c == 'Button')
                        {                      
                            system.debug('mpAnswerIdToVal ::'+ mpAnswerIdToVal);
                            
                            string str = mpAnswerIdToVal.ContainsKey(objSQ.objInputValue) && mpAnswerIdToVal.get(objSQ.objInputValue) != '' ? mpAnswerIdToVal.get(objSQ.objInputValue) : objSQ.objInputValue; 
                            system.debug(' str :::' + str );
                            if(str != null && str!='')
                                objTempIncome.put(objSQ.objCmsQuestion.pepFieldApiName__c,str);                       
                        }
                        else
                        {
                            string str = objSQ.objInputValue; 
                            objTempIncome.put(objSQ.objCmsQuestion.pepFieldApiName__c,str);                       
                        }
                    }
                    system.debug('income--after sib::'+objTempIncome);   
                    // objTempIncome.put(objSQ.objCmsQuestion.pepFieldApiName__c,objSQ.objCmsQuestion.pepType__c == 'Currency'? decimal.valueOf(objSQ.objInputValue) :objSQ.objInputValue  );
                }
                
                 mpSequenceToIncome.put(integer.valueOf(objTempIncome.Sequence__c), objTempIncome); 
                
                system.debug('objTempIncome::'+objTempIncome);
                //lstIncomeTemp.add(objTempIncome);                   
                setIncome.add(objTempIncome);                   
                            
               
                system.debug('setIncome:: '+setIncome);
                
              } 
           // return objTempIncome;    
       
    }
    
    list<Expense_and_Debt__c> lstED =  new list<Expense_and_Debt__c>();
    list<Residential_Address__c> lstAD =  new list<Residential_Address__c>();
    Expense_and_Debt__c objED;
    Residential_Address__c residentialAddress;
    genesis__Employment_Information__c employmentInformation;
    
    public void functionToReadValueForObjects()
    {
        
        for(wrapperQuestion objWrapQues: lstWrapperQuestion)
        {    
            // 1. work for Main Ques and Answer
            if(lstExpenses!=null && lstExpenses.size()>0)
            {
                for(Expense_and_Debt__c objTempED : lstExpenses )
                {
                    objED = objTempED;
                }
            }else
            {
                objED = new Expense_and_Debt__c();
            }
            
            if(lstResidentialAddress!=null && lstResidentialAddress.size()>0)
            {
                for(Residential_Address__c objED : lstResidentialAddress )
                {
                    residentialAddress = objED;
                } 
            }else
            {
                residentialAddress =  new Residential_Address__c();
            }
            
            if(lstEmploymentInformation!=null && lstEmploymentInformation.size()>0)
            {
                for(genesis__Employment_Information__c objED : lstEmploymentInformation )
                {
                    employmentInformation = objED;
                } 
            }else
            {
                employmentInformation =  new genesis__Employment_Information__c();
            }           
            
            if(objWrapQues.objInputValue ==  null) break;
                functionToReadValueForObjects_inner(objWrapQues,objED);
            //lstIncome.add(objI );
            
           
            // 3. work for Questions under ansers
            if(objWrapQues.lstAnswersQuestions!=null && objWrapQues.lstAnswersQuestions.size()>0)
            {
                for(wrapperQuestion objChildWrapQues: objWrapQues.lstAnswersQuestions)
                {
                   functionToReadValueForObjects_inner(objChildWrapQues,objED)   ;            
                }
            }
            
            lstED.add(objED);
            lstAD.add(residentialAddress);
            
        }
    }
    
    public void functionToReadValueForObjects_inner(wrapperQuestion objWrapQues, Expense_and_Debt__c objED)
    {
        
            //if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Expense_and_Debt__c')          
            //  Expense_and_Debt__c objED =  new Expense_and_Debt__c();
            
            //if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'loan__Address__c')
            //  loan__Address__c loanAddress =  new loan__Address__c();
            
             
            if(objWrapQues.objInputValue!=null && objWrapQues.objInputValue!='')
            { 
                if(objWrapQues.objCmsQuestion.pepType__c == 'Currency')
                {
                    system.debug('objWrapQues.objInputValue--'+objWrapQues.objInputValue);
                    
                        decimal dcml  = decimal.valueOf(objWrapQues.objInputValue);
                        if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Expense_and_Debt__c')
                            objED.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,dcml);
                        if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c')
                            residentialAddress.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,dcml);
                         if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'genesis__Employment_Information__c')
                            employmentInformation.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,dcml);
                     
                }
                else if(objWrapQues.objCmsQuestion.pepType__c == 'Picklist' || objWrapQues.objCmsQuestion.pepType__c == 'Button')
                {
                    system.debug('objWrapQues.objInputValue::'+objWrapQues.objInputValue);
                    system.debug('mpAnswerIdToVal.get(objWrap.objInputValue)::'+mpAnswerIdToVal.get(objWrapQues.objInputValue));
                    string str = mpAnswerIdToVal.get(objWrapQues.objInputValue); 
                    
                    if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Expense_and_Debt__c')
                    {   
                        if(str!=null && str!= '' && objWrapQues.objCmsQuestion.pepFieldApiName__c!=null &&
                            objWrapQues.objCmsQuestion.pepFieldApiName__c!= '')
                            objED.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,str);
                    }
                    if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c')
                            residentialAddress.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,str);
                                          
                }
                else
                {
                    string str = objWrapQues.objInputValue; 
                    
                    if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Expense_and_Debt__c' && objWrapQues.objCmsQuestion.pepFieldApiName__c!=null)
                            objED.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,str);
                    if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c' && objWrapQues.objCmsQuestion.pepFieldApiName__c!=null)
                            residentialAddress.put(objWrapQues.objCmsQuestion.pepFieldApiName__c,str);                                        
                }
            }
            
            for(wrapperQuestion objSQ: objWrapQues.lstSiblingQuestion )
            {
                system.debug('objSQ.objInputValue:: '+objSQ.objInputValue);
                system.debug('sibling currency:: '+objSQ.objCmsQuestion.pepType__c);
                if(objSQ.objInputValue !=null && objSQ.objInputValue!= '')
                {
                    if(objSQ.objCmsQuestion.pepType__c == 'Currency')
                    {
                        decimal dcml  = decimal.valueOf(objSQ.objInputValue);
                        if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Expense_and_Debt__c')
                            objED.put(objSQ.objCmsQuestion.pepFieldApiName__c,dcml);
                        if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c')
                            residentialAddress.put(objSQ.objCmsQuestion.pepFieldApiName__c,dcml);
                        
                    }
                    else if(objSQ.objCmsQuestion.pepType__c == 'Picklist' || objSQ.objCmsQuestion.pepType__c == 'Button')
                    {                      
                        system.debug('mpAnswerIdToVal ::'+ mpAnswerIdToVal);
                        
                        string str = mpAnswerIdToVal.ContainsKey(objSQ.objInputValue) && mpAnswerIdToVal.get(objSQ.objInputValue) != '' ? mpAnswerIdToVal.get(objSQ.objInputValue) : objSQ.objInputValue; 
                        system.debug(' str :::' + str );
                        if(str != null)
                        {                           
                            if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Expense_and_Debt__c')
                                objED.put(objSQ.objCmsQuestion.pepFieldApiName__c,str);
                            if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c')
                                residentialAddress.put(objSQ.objCmsQuestion.pepFieldApiName__c,str);
                        }
                    }
                    else
                    {
                        string str = objSQ.objInputValue; 
                        if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Expense_and_Debt__c')
                            objED.put(objSQ.objCmsQuestion.pepFieldApiName__c,str);
                        if(objWrapQues.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c')
                            residentialAddress.put(objSQ.objCmsQuestion.pepFieldApiName__c,str);
                                              
                    }
                }
                system.debug('objED::'+objED);   
               
            }
             
        
    }
    
}