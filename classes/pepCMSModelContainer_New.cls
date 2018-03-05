/**
*Refatored By : Sushant kumar (11/09/2017)
*This is a common class which contains data of Personal detail page as well Income page.
**/
public class pepCMSModelContainer_New{
    
    public list<wrapSection> lstSection {get; set;}
    Public Id Accountid{get;set;}
    Public Boolean retrieveAppChecker{get;set;}
    Public Boolean updateresidentialaddress=false;
    public genesis__Applications__c objApplication{get;set;}
    public Account objAccount{get;set;}
    public list<Income__c> lstIncome{get;set;}   
    public list<Residential_Address__c> lstResidentialAddress{get;set;}
    public list<genesis__Employment_Information__c> lstEmploymentInformation{get;set;}
    public map<Id,string> mpInputIdToVal{get;set;}  
    public string strPageName{get;set;}    
    public string strtest='123';
    public static List<Account> lstAppAccount;
    
	public pepCMSModelContainer_New(){
		
        retrieveAppChecker=True;
        lstSection = new list<wrapSection>();
        mpInputIdToVal =  new map<Id,string>();
        lstIncome =  new list<Income__c>();
        objApplication =  new genesis__Applications__c();
        objAccount =  new Account(); 
        lstAppAccount = new List<Account>();
        lstResidentialAddress =  new list<Residential_Address__c>();
        lstEmploymentInformation =  new list<genesis__Employment_Information__c>();
    }
    
    public class wrapSection{
		
        public pepCmsSection__c objCmsSection {get; set;}
        //showError and errorMessage added  by Varun
        public Boolean showError{get;set;}
        Public String errorMessage{get;set;}
        public list<wrapQuestion> lseQuestions {get; set;}
        public string strSectionStory {get; set;}
        public boolean isRenderSectionStory {get; set;}
        public wrapSection(){
            lseQuestions = new list<wrapQuestion>();
            objCmsSection=new pepCmsSection__c();
        }
        
        
        public String getHelpText(){
			
            if(objCmsSection.pepSectionBodyRich__c != null && objCmsSection.pepSectionBodyRich__c != ''){
                return objCmsSection.pepSectionBodyRich__c;
            }return null;
        }
    }
    
    public class wrapQuestion{
        public pepCmsQuestion__c objCmsQuestion {get; set;}
        public list<wrapAnswer> lstExpectedAnswers {get; set;}
        public list<wrapQuestion> lstSiblingQuestions {get; set;}
        public string objInputValue {get; set;}
        public list<SelectOption> lstOptions {get; set;}
        public boolean isRender {get; set;}
        public boolean isRunSelectedLogic {get; set;}
        public string strGAPIAddress{get;set;}
        //Added by Vipin
        public Id parentId;
        //Added by Varun to handle rerender thing on picklist level. 
        public Boolean handleRerender{
			get{
				Boolean temp=false;
				if(objinputvalue != null && objinputvalue != '' && objinputvalue !='null' && lstOptions != null && (!lstOptions.isEmpty())){
					for(System.Selectoption str:lstoptions)
					{
						if(str.getvalue().contains(objinputvalue)){
							if(str.getvalue().contains('true'))
								temp=true;
							break;
						}
					}
				}
				return temp;
			}set;
		}
        //Added by Varun to handle rerender thing at button level.
        Public Boolean handlererenderonButton{get;set;}
        //Added by Varun on October 20,2017 to handle the DVS checkbox.
        Public Boolean checkboxHandler{get;set;}
        
        public wrapQuestion(){
			
            objCmsQuestion = new pepCmsQuestion__c();
            lstExpectedAnswers = new list<wrapAnswer>();
            lstSiblingQuestions = new list<wrapQuestion>();
            lstOptions = new list<SelectOption>();
            isRunSelectedLogic = false;
            handlererenderonButton=false;
        }
        
        public wrapQuestion(pepCmsQuestion__c Q,Id questionParent){
			
            objCmsQuestion = Q;
            lstExpectedAnswers = new list<wrapAnswer>();
            lstSiblingQuestions = new list<wrapQuestion>();
            lstOptions = new list<SelectOption>();
            parentId=questionParent;
            isRender =true;
            isRunSelectedLogic = false;
            
            for(pepCmsAnswer__c A : Q.pepCmsAnswer__r)
            {
                lstExpectedAnswers.add(new wrapAnswer(A));
                // Added by IJ
                if(A.pepDisplayText__c == 'Choose one')
                {
                    lstOptions.add(new SelectOption('null', A.pepDisplayText__c));
                }
                else
                {
                    lstOptions.add(new SelectOption(A.ID+'/'+A.pepHasDependentQuestions__c, A.pepDisplayText__c));
                }    
            }
            lstSiblingQuestions = new list<wrapQuestion>();
        }
        Public string actualvalue{
			get{
				String toreturn ='null';
				if(objinputvalue != null && objinputvalue != '' && objinputvalue !='null' && lstOptions != null && (!lstOptions.isEmpty())){
					for(System.Selectoption str:lstoptions)
					{
						
						if(str.getvalue().contains(objinputvalue)){
							toreturn=str.getvalue();
							break;
						}
						
					}
					
				}
				return toreturn;
			}
			set{
				objinputvalue=value;
			}
		}
        
    }
    
    public class wrapAnswer{
        public pepCmsAnswer__c objCmsAnswer {get; set;}
        
        public wrapAnswer(){
            objCmsAnswer = new pepCmsAnswer__c();
        }
        
        public wrapAnswer(pepCmsAnswer__c A){
            objCmsAnswer = A;
        }
    }
    
	//This method is created for capturing Income and employment Info
    public void fetchDataToInputValue()
    {
        try{
            // map for Income
            map<integer, Income__c> mpIncomeIdToIncomeRecord =  new map<integer, Income__c>();
            map<integer, genesis__Employment_Information__c> mpEmpIdToEmpRec =  new map<integer, genesis__Employment_Information__c>();
            map<boolean, Residential_Address__c> mpIsCurrentAddressToRD =  new map<boolean, Residential_Address__c>();
            
            if(lstIncome!=null && (!lstIncome.isEmpty()))
            {
                for(Income__c objIncome : lstIncome)
                {
                    mpIncomeIdToIncomeRecord.put(integer.valueOf(objIncome.Sequence__c),objIncome ); 
                }
            }
            if(lstEmploymentInformation !=null && (!lstEmploymentInformation.isEmpty()))
            {
                for(genesis__Employment_Information__c objEmp : lstEmploymentInformation)
                {
                    mpEmpIdToEmpRec.put(integer.valueOf(objEmp.Sequence__c),objEmp);
                }
            }
            
            if(lstResidentialAddress !=null && (!lstResidentialAddress.isEmpty()))
            {
                if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                    for(Residential_Address__c objRD : [Select id,unit_number__c,Current_Address__c,street_number__c,street_name__c,street_type__c,suburb__c,state__c,country__c,postcode__c,What_is_Your_Residential_Status__c,Internal_Address__c,Address__c,How_Long_have_you_lived_here__c from residential_address__c where id in:lstResidentialAddress ])
                    {
                        if(mpIsCurrentAddressToRD.get(objRD.Current_Address__c) == null)
                            mpIsCurrentAddressToRD.put(objRD.Current_Address__c ,objRD);// if objRD.Current_Address__c == true then pick current address else pick second address
                    }
                }
                else{
                    PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                    throw new DMLException('This is a SOQL limit exception handling mechanism');
                }       
            }       
            
            // TO DO: map for expenses, residential and Employment details
            
            if(lstSection !=null && (!lstSection.isEmpty()))
            {
                for(wrapSection objSection: lstSection )
                {
                    
                    Income__c objTempIncome;
                    Account objTempAcc;
                    genesis__Applications__c objTempApp;
                    Residential_Address__c objTempRD;
                    genesis__Employment_Information__c objTempEI;
                    
                    for(wrapQuestion objWrapQuestion: objSection.lseQuestions)
                    {
                        // fetch income records related to sequence
                        if(objWrapQuestion.objCmsQuestion != null)
                        {
                            // get answer from all objects
                            string strInputValue ='';
                            // Depending upon the object API name of object get input value
                            if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Income__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                            {
                                if( mpIncomeIdToIncomeRecord !=null && (!mpIncomeIdToIncomeRecord.isEmpty())&& 
                                   mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c))!=null)
                                {
                                    objTempIncome =  mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c));
                                    strInputValue = string.valueOf(objTempIncome.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c) );
                                }                             
                            }
                            else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'genesis__Applications__c')
                            {
                                if(objApplication!=null && objWrapQuestion.objCmsQuestion.pepFieldApiName__c=='pepCheckProvideDVSAuthorization__c'){
                                    
                                    objWrapQuestion.checkboxHandler=(Boolean)objApplication.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c);
                                }
                                if(objApplication!=null && objApplication.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c)!=null)  
                                    strInputValue = string.valueOf(objApplication.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c) );
                            }
                            else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Account')
                            {
                                if(objAccount!=null && objAccount.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c)!=null)
                                {
                                    if(objWrapQuestion.objCmsQuestion.pepType__c == 'Date')
                                    {
                                        string dt =  string.valueOf(objAccount.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c));
                                        string[] breakDate = dt.split(' ');
                                        string[] breakDays = breakDate[0].split('-');
                                        Integer myIntDate = integer.valueOf(breakDays[0]);
                                        Integer myIntMonth = integer.valueOf(breakDays[1]);
                                        Integer myIntYear = integer.valueOf(breakDays[2]);
                                        DateTime d = DateTime.newInstance(myIntDate, myIntMonth, myIntYear);
                                        
                                        strInputValue =  d.format('dd/MM/yyyy') ; //string.valueOf(d) ;
                                    }else
                                        strInputValue = string.valueOf(objAccount.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c) );
                                }
                                
                            }
                            else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'genesis__Employment_Information__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                            {
                                if( mpEmpIdToEmpRec !=null && (!mpEmpIdToEmpRec.isEmpty()) && 
                                   mpEmpIdToEmpRec.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c))!=null)
                                {
                                    objTempEI =  mpEmpIdToEmpRec.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c));
                                    strInputValue = string.valueOf(objTempEI.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c) );
                                }                               
                            }
                            else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                            {
                                if( mpIsCurrentAddressToRD !=null && (!mpIsCurrentAddressToRD.isEmpty()))
                                {
                                    boolean isCurrent = true;
                                    //  assumging only two addresses
                                    if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 1) isCurrent=true; //if current address
                                    if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 2) isCurrent=false;// if previous address
                                    if(mpIsCurrentAddressToRD.get(isCurrent)!=null)
                                    {
                                        objTempRD =  mpIsCurrentAddressToRD.get(isCurrent);
                                        // TO DO: 
                                        if(objWrapQuestion.objCmsQuestion.pepFieldApiName__c!=null && objTempRD.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c)!=null)
                                        {                                                   
                                            if(objWrapQuestion.objCmsQuestion.pepFieldApiName__c =='Address__c'){
                                                if(string.valueof(objTempRD.get('Unit_Number__c'))!= null && string.valueof(objTempRD.get('Unit_Number__c'))!=''){
                                                    string tempstr=string.valueof(objTempRD.get('Unit_Number__c'))+'/'+string.valueof(objTempRD.get('Street_Number__c'))+' '+string.valueof(objTempRD.get('Street_Name__c'));
                                                    tempstr+=(string.valueof(objTempRD.get('street_Type__c'))!= null && string.valueof(objTempRD.get('street_Type__c'))!='')?' '+string.valueof(objTempRD.get('street_Type__c'))+',':',';
                                                    tempstr+=' '+string.valueof(objTempRD.get('Suburb__c'))+' '+string.valueof(objTempRD.get('state__c'))+' '+string.valueof(objTempRD.get('country__c'))+' '+string.valueof(objTempRD.get('postcode__c'));
                                                    strInputValue=tempStr;
                                                }
                                                else{
                                                    string tempstr=string.valueof(objTempRD.get('Street_Number__c'))+' '+string.valueof(objTempRD.get('Street_Name__c'));
                                                    tempstr+=(string.valueof(objTempRD.get('street_Type__c'))!= null && string.valueof(objTempRD.get('street_Type__c'))!='')?' '+string.valueof(objTempRD.get('street_Type__c'))+',':',';
                                                    tempstr+=' '+string.valueof(objTempRD.get('Suburb__c'))+' '+string.valueof(objTempRD.get('state__c'))+' '+string.valueof(objTempRD.get('country__c'))+' '+string.valueof(objTempRD.get('postcode__c'));
                                                    strInputValue=tempStr;
                                                }
                                                
                                                //As discussed with ishu,Commented by lokesh to populate internal address in GAPI address.
                                                objWrapQuestion.strGAPIAddress  = string.valueOf(objTempRD.get('Internal_Address__c'));
                                            }
                                            else{
                                                strInputValue=string.valueOf(objTempRD.get(objWrapQuestion.objCmsQuestion.pepFieldApiName__c) );
                                            }
                                        }
                                    }                               
                                }
                                
                            }      
                            if(objWrapQuestion.objCmsQuestion.pepType__c != 'Picklist' && objWrapQuestion.objCmsQuestion.pepType__c != 'Button'  )
                            {                                                                       
                                if(strInputValue !=null && strInputValue != '')
                                {                                       
                                    objWrapQuestion.objInputValue = strInputValue ;
                                }
                            }
                            // for button or picklist we have answers
                            else
                            {                                
                                // expected answers if question is of type button or picklist
                                if(objWrapQuestion.lstExpectedAnswers !=null && (!objWrapQuestion.lstExpectedAnswers.isEmpty())){
                                    // expected answers
                                    for(wrapAnswer objWrpAnswer : objWrapQuestion.lstExpectedAnswers)
                                    {
                                        // doubt
                                        if(objWrpAnswer.objCmsAnswer.pepActualValue__c == strInputValue )
                                            objWrapQuestion.objInputValue = objWrpAnswer.objCmsAnswer.Id;
                                    }
                                }
                            }
                            
                        }
                        
                        if(objWrapQuestion.lstSiblingQuestions !=null && (!objWrapQuestion.lstSiblingQuestions.isEmpty()))
                        {
                            for(wrapQuestion objWrapSQ: objWrapQuestion.lstSiblingQuestions)
                            {
                                if(objWrapSQ.objCmsQuestion != null && objWrapSQ.objCmsQuestion.pepRecordSequence__c!=null)
                                {
                                    // get
                                    string strInputValue='';
                                    // Depending upon the object API name on section get input value
                                    if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'Income__c'  && objWrapSQ.objCmsQuestion.pepRecordSequence__c!=null)
                                    {
                                        if( mpIncomeIdToIncomeRecord !=null && (!mpIncomeIdToIncomeRecord.isEmpty()) && 
                                           mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c))!=null)
                                        {
                                            objTempIncome =  mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c));
                                            strInputValue = string.valueOf(objTempIncome.get(objWrapSQ.objCmsQuestion.pepFieldApiName__c) );
                                        }                               
                                    }
                                    else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'genesis__Applications__c')
                                    {
                                        if(objApplication!=null && objApplication.get(objWrapSQ.objCmsQuestion.pepFieldApiName__c)!=null)  
                                            strInputValue = string.valueOf(objApplication.get(objWrapSQ.objCmsQuestion.pepFieldApiName__c) );
                                    }
                                    else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'Account')
                                    {
                                        if(objAccount!=null && objAccount.get(objWrapSQ.objCmsQuestion.pepFieldApiName__c)!=null)
                                            strInputValue = string.valueOf(objAccount.get(objWrapSQ.objCmsQuestion.pepFieldApiName__c) );
                                    }
                                    else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'genesis__Employment_Information__c'  && objWrapSQ.objCmsQuestion.pepRecordSequence__c!=null)
                                    {
                                        if( mpEmpIdToEmpRec !=null && (!mpEmpIdToEmpRec.isEmpty()) && 
                                           mpEmpIdToEmpRec.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c))!=null)
                                        {
                                            objTempEI =  mpEmpIdToEmpRec.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c));
                                            strInputValue = string.valueOf(objTempEI.get(objWrapSQ.objCmsQuestion.pepFieldApiName__c) );
                                        }                               
                                    }
                                    else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c'  && objWrapSQ.objCmsQuestion.pepRecordSequence__c!=null)
                                    {
                                        if( mpIsCurrentAddressToRD !=null && (!mpIsCurrentAddressToRD.isEmpty()))
                                        {
                                            boolean isCurrent = true;
                                            //  assumging only two addresses
                                            if(objWrapSQ.objCmsQuestion.pepRecordSequence__c == 1) isCurrent=true; //if current address
                                            if(objWrapSQ.objCmsQuestion.pepRecordSequence__c == 2) isCurrent=false;// if previous address
                                            if(mpIsCurrentAddressToRD.get(isCurrent)!=null)
                                            {
                                                objTempRD =  mpIsCurrentAddressToRD.get(isCurrent);
                                                strInputValue = string.valueOf(objTempRD.get(objWrapSQ.objCmsQuestion.pepFieldApiName__c) );
                                            }
                                        }                               
                                    }
                                    
                                    
                                    // if income record exists for a sequence then do not create new income record else create
                                    if(objWrapSQ.objCmsQuestion.pepType__c != 'Picklist' && objWrapSQ.objCmsQuestion.pepType__c != 'Button')
                                    {                                              
                                        if(strInputValue !=null && strInputValue != '')
                                        {
                                            objWrapSQ.objInputValue = strInputValue ;
                                        }
                                        
                                    }
                                    // for button or picklist we have answers
                                    else
                                    {                                
                                        // expected answers if question is of type button
                                        if(objWrapSQ.lstExpectedAnswers !=null && (!objWrapSQ.lstExpectedAnswers.isEmpty()))
                                        {
                                            // expected answers
                                            for(wrapAnswer objWrpAnswer : objWrapSQ.lstExpectedAnswers)
                                            {
                                                // doubt
                                                if(objWrpAnswer.objCmsAnswer.pepActualValue__c == strInputValue )
                                                    objWrapSQ.objInputValue = objWrpAnswer.objCmsAnswer.Id;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }  
        catch(Exception ex){
        } 
    }
    
    //This method fetchs Account Details of givven Account Id
    public static List<Account> fetchAccountDetails(String accId)
    {
       
        try{
            if(lstAppAccount == Null || ((!lstAppAccount.isEmpty()) && lstAppAccount[0].id != accId)){
                if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                    lstAppAccount = [Select id,personcontactid  from Account where id=: accId];
                }
                else{
                    PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                    throw new DMLException('This is a SOQL limit exception handling mechanism');
                }
            }
        }
        Catch(Exception ex){
        }
        return lstAppAccount;
    }
    
    // This method is used to create object records
    public void saveInputValuesToFields()
    {
        // map for Income
        map<integer, Income__c> mpIncomeIdToIncomeRecord =  new map<integer, Income__c>();
        map<integer, genesis__Employment_Information__c> mpEmpIdToEmpRec =  new map<integer, genesis__Employment_Information__c>();
        map<boolean, Residential_Address__c> mpIsCurrentAddressToRD =  new map<boolean, Residential_Address__c>();
        
        if(lstIncome!=null && (!lstIncome.isEmpty()))
        {
            for(Income__c objIncome : lstIncome)
            {
                mpIncomeIdToIncomeRecord.put(integer.valueOf(objIncome.Sequence__c),objIncome ); 
            }
        }
        
        if(lstEmploymentInformation !=null && (!lstEmploymentInformation.isEmpty()))
        {
            for(genesis__Employment_Information__c objEmp : lstEmploymentInformation)
            {
                mpEmpIdToEmpRec.put(integer.valueOf(objEmp.Sequence__c),objEmp);
            }
        }
        
        if(lstResidentialAddress !=null && (!lstResidentialAddress.isEmpty()))
        {
            for(Residential_Address__c objRD : lstResidentialAddress)
            {
                if(objApplication!=null){
                    List<Account> acc = fetchAccountDetails(objApplication.genesis__Account__c);
                    if(acc != null && (!acc.isEmpty()))
                    {
                        objRD.Account__c=acc[0].id;
                        objRD.Contact__c = acc[0].personcontactid ;
                    }
                }
                mpIsCurrentAddressToRD.put(objRD.Current_Address__c ,objRD);// if objRD.Current_Address__c == true then pick current address else pick second address
            }
        }         
        
        
        if(lstSection !=null && (!lstSection.isEmpty()))
        {
            for(wrapSection objSection: lstSection )
            {
                Income__c objTempIncome ;
                Account objTempAcc;
                genesis__Applications__c objTempApp;
                Residential_Address__c objTempRD;
                genesis__Employment_Information__c objTempEI;                    
                
                for(wrapQuestion objWrapQuestion: objSection.lseQuestions)
                {
                    // fetch income records related to sequence
                    if(objWrapQuestion.objCmsQuestion != null )
                    {
                        if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Income__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                        {                             
                            if(mpIncomeIdToIncomeRecord !=null && (!mpIncomeIdToIncomeRecord.isEmpty()) && 
                               mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c))!=null)
                            {
                                objTempIncome =  mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c));                                          
                            }
                            // if income records do not exists
                            else
                            {
                                objTempIncome = new Income__c(); 
                                lstIncome.add(objTempIncome);
                                objTempIncome.Sequence__c = objWrapQuestion.objCmsQuestion.pepRecordSequence__c;
                                mpIncomeIdToIncomeRecord.put(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c),objTempIncome); 
                            }
                            objTempIncome = (Income__c)updateIncome(objWrapQuestion, objTempIncome );   
                        }
                        else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'genesis__Applications__c')
                        {
                            if(objApplication!=null) 
                                objApplication = (genesis__Applications__c)updateIncome(objWrapQuestion, objApplication );   
                            else
                            {
                                objApplication = new genesis__Applications__c();
                                objApplication = (genesis__Applications__c)updateIncome(objWrapQuestion, objApplication );
                            }
                        } 
                        else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Account')
                        {
                            if(objAccount!=null) 
                                objAccount = (Account)updateIncome(objWrapQuestion, objAccount );   
                            else
                            {
                                objAccount = new Account();
                                objAccount = (Account)updateIncome(objWrapQuestion, objAccount );
                            }
                            
                        }                                
                        else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'genesis__Employment_Information__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                        {                             
                            if(mpEmpIdToEmpRec !=null && (!mpEmpIdToEmpRec.isEmpty()) && 
                               mpEmpIdToEmpRec.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c))!=null)
                            {
                                objTempEI =  mpEmpIdToEmpRec.get(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c));                                          
                            }
                            // if income records do not exists
                            else
                            {
                                objTempEI = new genesis__Employment_Information__c(); 
                                lstEmploymentInformation.add(objTempEI);
                                objTempEI.Sequence__c = objWrapQuestion.objCmsQuestion.pepRecordSequence__c;
                                mpEmpIdToEmpRec.put(integer.valueOf(objWrapQuestion.objCmsQuestion.pepRecordSequence__c),objTempEI); 
                            }
                            objTempEI = (genesis__Employment_Information__c)updateIncome(objWrapQuestion, objTempEI );  
                            if(objWrapQuestion.objCmsQuestion.pepFieldApiName__c =='Employment_Status__c' )
                            {
                                if(objTempEI.Employment_Status__c == 'Self Employed')
                                    objTempEI.genesis__Self_Employed__c = true;
                            } 
                        }
                        else if(objWrapQuestion.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c'  && objWrapQuestion.objCmsQuestion.pepRecordSequence__c!=null)
                        {                             
                            //  assumging only two addresses
                            boolean isCurrent ;
                            if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 1) isCurrent=true; //if current address
                            if(objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 2) isCurrent=false;// if previous address
                            if( mpIsCurrentAddressToRD !=null && (!mpIsCurrentAddressToRD.isEmpty()) && mpIsCurrentAddressToRD.get(isCurrent)!=null)
                            {                                            
                                
                                objTempRD =  mpIsCurrentAddressToRD.get(isCurrent);                                             
                            }
                            // if address records do not exists
                            else
                            { 
                                Id checkResidentialid;
                                objTempRD = new Residential_Address__c();
                                if(objApplication != null){
                                    List<Account> acc =fetchAccountDetails(objApplication.genesis__Account__c);
                                    if(acc != null && (!acc.isEmpty())){
                                        objTempRD.Account__c = acc[0].id;
                                        objTempRD.Contact__c = acc[0].personcontactid ;
                                        checkResidentialid=acc[0].id;
                                    }
                                }
                                
                                lstResidentialAddress.add(objTempRD);
                                
                                objTempRD.Current_Address__c = objWrapQuestion.objCmsQuestion.pepRecordSequence__c == 1 && checkAccount(checkResidentialid);
                                
                                mpIsCurrentAddressToRD.put(isCurrent,objTempRD); 
                            }
                            if(objWrapQuestion.objInputValue!=null && objWrapQuestion.objInputValue!='' && objWrapQuestion.objCmsQuestion.pepFieldApiName__c == 'Address__c')
                            {
                                string strCompleteAddress = '';
                                
                                List<string> str1 = new List<string>();
                                if(objWrapQuestion.strGAPIAddress!=null && objWrapQuestion.strGAPIAddress!='')
                                    str1 = objWrapQuestion.strGAPIAddress.split(':');
                                else
                                    objWrapQuestion.strGAPIAddress = objWrapQuestion.objInputValue;     
                                
                                if(str1 <> null && str1.size()>0)
                                {  
                                    Integer intAddressLength = str1.size();
                                    objTempRD.PostCode__c = '';
                                    objTempRD.Country__c = '';
                                    objTempRD.State__c= '';
                                    objTempRD.Suburb__c = '';
                                    objTempRD.Street_Name__c = '';
                                    objTempRD.Street_Number__c = '';
                                    objTempRD.Unit_Number__c = '';   
                                    objTempRD.street_Type__c='';                                              
                                    while(intAddressLength >0)
                                    {
                                        //Post code 
                                        if(str1.size() == intAddressLength)
                                        {
                                            
                                            objTempRD.PostCode__c =  str1[intAddressLength-1];    
                                        }//Country
                                        else if(str1.size() == intAddressLength+1)
                                        {
                                            
                                            objTempRD.Country__c =  str1[intAddressLength-1]; 
                                        }//State
                                        else if(str1.size() == intAddressLength+2)
                                        {
                                            
                                            objTempRD.State__c=  str1[intAddressLength-1]; 
                                        }//Suburb
                                        else if(str1.size() == intAddressLength+3)
                                        {
                                            
                                            objTempRD.Suburb__c =  str1[intAddressLength-1]; 
                                        }//Street Type
                                        else if(str1.size() == intAddressLength+4)
                                        {
                                            objTempRD.street_Type__c=str1[intAddressLength-1];
                                            
                                        }//Street Name
                                        else if(str1.size() == intAddressLength+5)
                                        {
                                            objTempRd.Street_Name__c=str1[intAddressLength-1];
                                        }
                                        else if(str1.size() == intAddressLength+6)
                                        {
                                            
                                            objTempRD.Street_Number__c =  str1[intAddressLength-1];
                                            if(intAddressLength == 2)
                                            {
                                                objTempRD.Street_Number__c =  str1[intAddressLength-1];
                                                objTempRD.Unit_Number__c   =  str1[intAddressLength-2]; 
                                            }
                                        }
                                        intAddressLength --;
                                    }
                                    string strCompleteAdd;
                                    if(objTempRD.street_Type__c != ''){
                                        strCompleteAdd = objTempRD.Unit_Number__c + ' '+objTempRD.Street_Number__c + ' ' + objTempRD.Street_Name__c + ' '+objTempRD.street_Type__c+' '+objTempRD.Suburb__c + ',' + objTempRD.State__c + ',' + objTempRD.Country__c + ','+objTempRD.PostCode__c;                                                                                      
                                        if(strCompleteAdd.contains('  '))
                                            strcompleteadd=strCompleteAdd.replaceall('  ',' ');
                                    }
                                    else{
                                        strCompleteAdd = objTempRD.Unit_Number__c + ' '+objTempRD.Street_Number__c + ' ' + objTempRD.Street_Name__c + ' '+ objTempRD.Suburb__c + ',' + objTempRD.State__c + ',' + objTempRD.Country__c + ','+objTempRD.PostCode__c;                                                                                      
                                        if(strCompleteAdd.contains('  '))
                                            strcompleteadd=strCompleteAdd.replaceall('  ',' ');
                                    }
                                    if(strCompleteAdd <> null && strCompleteAdd <> '')
                                    {
                                        objWrapQuestion.objInputValue = strCompleteAdd;
                                    }
                                }
                            }
                            objTempRD = (Residential_Address__c)updateIncome(objWrapQuestion, objTempRD );
                        } 
                    }
                    if(objWrapQuestion.lstSiblingQuestions !=null && (!objWrapQuestion.lstSiblingQuestions.isEmpty()))
                    {
                        for(wrapQuestion objWrapSQ: objWrapQuestion.lstSiblingQuestions)
                        {
                            if(objWrapSQ.objCmsQuestion != null )
                            {
                                if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'Income__c'  && objWrapSQ.objCmsQuestion.pepRecordSequence__c!=null)
                                {                             
                                    if(mpIncomeIdToIncomeRecord !=null && (!mpIncomeIdToIncomeRecord.isEmpty()) && 
                                       mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c))!=null)
                                    {
                                        objTempIncome =  mpIncomeIdToIncomeRecord.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c));                                          
                                    }
                                    // if income records do not exists
                                    else
                                    {
                                        objTempIncome = new Income__c();
                                        lstIncome.add(objTempIncome);
                                        objTempIncome.Sequence__c = objWrapSQ.objCmsQuestion.pepRecordSequence__c;
                                        mpIncomeIdToIncomeRecord.put(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c),objTempIncome); 
                                    }
                                    objTempIncome = (Income__c)updateIncome(objWrapSQ, objTempIncome );                                              
                                }
                                else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'genesis__Applications__c')
                                {
                                    if(objApplication!=null) 
                                        objApplication = (genesis__Applications__c)updateIncome(objWrapQuestion, objApplication );   
                                    else
                                    {
                                        objApplication = new genesis__Applications__c();
                                        objApplication = (genesis__Applications__c)updateIncome(objWrapQuestion, objApplication );
                                    }
                                } 
                                else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'Account')
                                {
                                    if(objAccount!=null) 
                                        objAccount = (Account)updateIncome(objWrapQuestion, objAccount );   
                                    else
                                    {
                                        objAccount = new Account();
                                        objAccount = (Account)updateIncome(objWrapQuestion, objAccount );
                                    }                                            
                                    
                                }
                                else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'genesis__Employment_Information__c'  && objWrapSQ.objCmsQuestion.pepRecordSequence__c!=null)
                                {                             
                                    if(mpEmpIdToEmpRec !=null && (!mpEmpIdToEmpRec.isEmpty()) && 
                                       mpEmpIdToEmpRec.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c))!=null)
                                    {
                                        objTempEI =  mpEmpIdToEmpRec.get(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c));                                          
                                    }
                                    // if income records do not exists
                                    else
                                    {
                                        objTempEI = new genesis__Employment_Information__c(); 
                                        lstEmploymentInformation.add(objTempEI);
                                        objTempEI.Sequence__c = objWrapSQ.objCmsQuestion.pepRecordSequence__c;
                                        mpEmpIdToEmpRec.put(integer.valueOf(objWrapSQ.objCmsQuestion.pepRecordSequence__c),objTempEI); 
                                    }
                                    objTempEI = (genesis__Employment_Information__c)updateIncome(objWrapQuestion, objTempEI ); 
                                    if(objWrapQuestion.objCmsQuestion.pepFieldApiName__c =='Employment_Status__c' )
                                    {
                                        if(objTempEI.Employment_Status__c == 'Self Employed')
                                            objTempEI.genesis__Self_Employed__c = true;
                                    }  
                                }
                                else if(objWrapSQ.objCmsQuestion.pepSObjectApiName__c == 'Residential_Address__c'  && objWrapSQ.objCmsQuestion.pepRecordSequence__c!=null)
                                {                             
                                    boolean isCurrent ;
                                    //  assumging only two addresses
                                    if(objWrapSQ.objCmsQuestion.pepRecordSequence__c == 1) isCurrent=true; //if current address
                                    if(objWrapSQ.objCmsQuestion.pepRecordSequence__c == 2) isCurrent=false;// if previous address                                          
                                    if( mpIsCurrentAddressToRD !=null && (!mpIsCurrentAddressToRD.isEmpty()) && mpIsCurrentAddressToRD.get(isCurrent)!=null)
                                    {
                                        objTempRD =  mpIsCurrentAddressToRD.get(isCurrent);                                                    
                                    }
                                    // if address records do not exists
                                    else
                                    {
                                        Id checkResidentialid;
                                        List<Account> acc =fetchAccountDetails(objApplication.genesis__Account__c);
                                        
                                        objTempRD = new Residential_Address__c(); 
                                        if(acc != null && (!acc.isEmpty())){
                                            objTempRD.Account__c = acc[0].id;
                                            objTempRD.Contact__c = acc[0].personcontactid ;
                                            checkResidentialid=acc[0].id;
                                        }
                                        lstResidentialAddress.add(objTempRD);
                                        
                                        objTempRD.Current_Address__c = objWrapSQ.objCmsQuestion.pepRecordSequence__c == 1 && checkAccount(checkResidentialid);
                                        mpIsCurrentAddressToRD.put(isCurrent,objTempRD); 
                                    }
                                    
                                    if(objWrapSQ.objInputValue!=null && objWrapSQ.objInputValue!='' && 
                                       objWrapSQ.objCmsQuestion.pepFieldApiName__c == 'Address__c')
                                    {
                                        // split and store in respective fields
                                        string[] str = objWrapSQ.objInputValue.split(',');
                                        string[] strStreet = str[0].split(' ');
                                        
                                        for(integer i = 1;i<strStreet.size();i++)
                                        {
                                            if(objTempRD.Street_Name__c != '')
                                            {
                                                objTempRD.Street_Name__c = objTempRD.Street_Name__c+' ' + strStreet[i];
                                            }else
                                                objTempRD.Street_Name__c = strStreet[i];
                                        }
                                        objTempRD.Street_Number__c = strStreet[0];
                                        
                                        objTempRD.City__c = str[1];
                                        objTempRD.Country__c = str[3];
                                        objTempRD.State__c =  str[2];
                                    }
                                    
                                    objTempRD = (Residential_Address__c)updateIncome(objWrapQuestion, objTempRD );                                            
                                    
                                }                                        
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
	//This method is created for updating Income details
	@testVisible
    private sObject updateIncome(wrapQuestion objWrapQ , sObject objSobject)
    {
        sObject obj = objSobject;
        if(objWrapQ.objCmsQuestion.pepType__c == 'Currency')
        { 
            if(objWrapQ.objInputValue!=null && objWrapQ.objInputValue!='')
            {
                decimal dcml  = decimal.valueOf(objWrapQ.objInputValue.replace(',',''));
                obj.put(objWrapQ.objCmsQuestion.pepFieldApiName__c,dcml);
            }
        }
        else if(objWrapQ.objCmsQuestion.pepType__c == 'Picklist' || objWrapQ.objCmsQuestion.pepType__c == 'Button')
        {         
            if(objWrapQ.lstExpectedAnswers!=null && (!objWrapQ.lstExpectedAnswers.isEmpty()))
            {
                for(wrapAnswer objTempAns: objWrapQ.lstExpectedAnswers )
                {
                    if(objWrapQ.objInputValue!=null && objWrapQ.objInputValue!='null')
                    {
                        if(objTempAns.objCmsAnswer.Id == (objWrapQ.objInputValue).substring(0,18))
                        {
                            if(objWrapQ.objCmsQuestion.pepFieldApiName__c=='Number_of_Dependants__c'){
                                Decimal temp=Decimal.valueof(objTempAns.objCmsAnswer.pepActualValue__c);
                                obj.put(objWrapQ.objCmsQuestion.pepFieldApiName__c,temp);
                            }
                            else{
                                obj.put(objWrapQ.objCmsQuestion.pepFieldApiName__c,objTempAns.objCmsAnswer.pepActualValue__c);
                            }
                        }
                    }
                }
            }                                   
        }
        else if(objWrapQ.objCmsQuestion.pepType__c == 'Date' )
        {         
            if(objWrapQ.objInputValue!=null && objWrapQ.objInputValue!= '')
            {
                string str =  objWrapQ.objInputValue;
                if(str.contains('/'))
                {
                    string[] breakDays = str.split('/');
                    Integer myIntDate = integer.valueOf(breakDays[0]);
                    Integer myIntMonth = integer.valueOf(breakDays[1]);
                    Integer myIntYear = integer.valueOf(breakDays[2]);
                    Date dt = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                    
                    obj.put(objWrapQ.objCmsQuestion.pepFieldApiName__c,dt);
                }
                
                if(str.contains('-'))
                {
                    string[] breakDays = str.split('-');
                    Integer myIntDate = integer.valueOf(breakDays[2]);
                    Integer myIntMonth = integer.valueOf(breakDays[1]);
                    Integer myIntYear = integer.valueOf(breakDays[0]);
                    Date dt = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                    
                    obj.put(objWrapQ.objCmsQuestion.pepFieldApiName__c,dt);
                }
            }                                  
        }
        else if(objWrapQ.objCmsQuestion.pepFieldApiName__c=='pepCheckProvideDVSAuthorization__c'){
            obj.put(objWrapQ.objCmsQuestion.pepFieldApiName__c,objWrapQ.checkboxHandler);
        }
        else
        {
            if(objWrapQ.objInputValue!=null && objWrapQ.objInputValue!='' || objWrapQ.objCmsQuestion.pepFieldApiName__c == 'PersonHomePhone' || objWrapQ.objCmsQuestion.pepFieldApiName__c=='MiddleName')
            {
                
                string str = objWrapQ.objInputValue;
                if((objWrapQ.objCmsQuestion.pepFieldApiName__c == 'PersonHomePhone' || objWrapQ.objCmsQuestion.pepFieldApiName__c=='MiddleName') && (objWrapQ.objInputValue==null || objWrapQ.objInputValue==''))
                    str=''; 
                
                if(objWrapQ.objCmsQuestion.pepFieldApiName__c!=null) 
                {   
                    if(objWrapQ.objCmsQuestion.pepFieldApiName__c=='Referred_By_Code__c' && retrieveAppChecker==False)
                    {
                        AddParty p = new AddParty();
                        clcommon__Party__c party = p.add(str,objApplication.id);
                    }
                    obj.put(objWrapQ.objCmsQuestion.pepFieldApiName__c,str);
                }   
            }
        } 
        
        return obj;  
    }
	
	//This method uncheck Current Address field of Residential Address record of related Account
    @testVisible
    Private Boolean checkAccount(Id Accountid){
        
		try{
            if(Accountid != null){
                List<Residential_Address__c> toupdatelist = new List<Residential_Address__c>();
                List<Residential_Address__c> residentialaddress;
                if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                    residentialaddress = [select id,unit_number__c,Current_Address__c,street_number__c,street_name__c,street_type__c,suburb__c,state__c,country__c,postcode__c,What_is_Your_Residential_Status__c,Internal_Address__c,Address__c,How_Long_have_you_lived_here__c from Residential_Address__c where Account__c=:Accountid and Current_Address__c=True];
                }
                else{
                    PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                    throw new DMLException('This is a SOQL limit exception handling mechanism');
                }
                if(residentialaddress != null && (!residentialaddress.isEmpty())){
                    for(Residential_Address__c rdd:residentialaddress){
                        rdd.Current_Address__c=False;
                        toupdatelist.add(rdd);
                    }
                    if(toupdatelist!=null && (!toupdatelist.isEmpty()) && updateresidentialaddress==true)
                        update toupdatelist;
                    return true;
                }
                else{
                    return true;
                }
            }
            else{
                return true;
            }
        }
        Catch(Exception ex){
            return true;
        }
    }
}