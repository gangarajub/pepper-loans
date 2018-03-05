/**
*@Refactored By : Rishabh Tyagi (10/09/2017)
*@Descriptions : Used in pepcmscomponent_New Apex Component as controller
**/ 

public class pepCmsComponent_New {
    
    Public set<id> parentQuestionsQuestionIds;
    Public Map<id,List<pepCmsQuestion__c>> answerToQuestions;
    Public Map<id,pepCmsQuestion__c> answerToQuestionSiblingQuestions;
    public pepCMSModelContainer_New objModelContainer {get;set;}
    public string strPageName {get; set;}
    public string SelectedAnswer {get; set;}
    public string selectedQuestion {get; set;}
    public string selectedSection {get; set;}
    public string WhatToDo {get; set;}
    public String section{get; set;}
    public set<Id> setDeletedIds;
    public String consentScript {get; set;}
    public string instance {get; set;}
    private boolean isCalledFromDropDown;
    Public List<Residential_Address__c> tempResidentialAddressHolder;
    private boolean isdeleted=false;
    
    public pepCmsComponent_New(){
        
        try{
            
            AnswerToQuestions=new Map<Id,List<pepCmsQuestion__c>>();
            parentQuestionsQuestionIds=new set<Id>();
            answerToQuestionSiblingQuestions=new Map<id,pepCmsQuestion__c>();
            List<pepCmsQuestion__c> answerChildQuestions;
            
            answerChildQuestions=[SELECT Id, pepSection__c,pepSection__r.Name ,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, pepRecordSequence__c,
                                  pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                  pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, 
                                  pepGoogleApi__c ,Is_Date_to_Birth__c ,
                                  
                                  (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id,pepHasDependentQuestions__c 
                                   FROM pepCmsAnswer__r order by pepSequence__c ASC), 
                                  
                                  (SELECT pepSection__c,pepGenericErrorMessage__c,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                   pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepSubType__c, pepRecordSequence__c,
                                   pepRelatedCSS__c, Is_Date_to_Birth__c 
                                   FROM CmsQuestion__r
                                   ORDER BY pepSequence__c ASC),pepHasAnswers__c
                                  
                                  FROM pepCmsQuestion__c
                                  WHERE pepCMSAnswer__c !=null
                                  
                                  ORDER BY pepSequence__c ASC];
            
            if(answerChildQuestions != null && (!answerChildQuestions.isEmpty())){
                for(pepCmsQuestion__c answerChildQuestion:answerChildQuestions){
                    parentQuestionsQuestionIds.add(answerChildQuestion.Id);
                    if(!AnswerToQuestions.containskey(answerChildQuestion.pepCMSAnswer__c))
                        AnswerToQuestions.put(answerChildQuestion.pepCMSAnswer__c,new List<pepCmsQuestion__c>());
                    AnswerToQuestions.get(answerChildQuestion.pepCMSAnswer__c).add(answerChildQuestion);
                }
            }
            List<pepCmsQuestion__c> siblingQuestionsList;
            
            siblingQuestionsList=[SELECT Id, pepSection__c,pepSection__r.Name ,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                  pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, pepRecordSequence__c,
                                  pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, pepGoogleApi__c ,
                                  Is_Date_to_Birth__c,
                                  
                                  (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id,pepHasDependentQuestions__c 
                                   FROM pepCmsAnswer__r order by pepSequence__c ASC), 
                                  
                                  (SELECT pepSection__c,pepGenericErrorMessage__c,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                   pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepSubType__c, pepRecordSequence__c,
                                   pepRelatedCSS__c, Is_Date_to_Birth__c 
                                   FROM CmsQuestion__r
                                   ORDER BY pepSequence__c ASC),pepHasAnswers__c
                                  
                                  FROM pepCmsQuestion__c
                                  WHERE pepQuestion__c in:parentQuestionsQuestionIds 
                                  
                                  ORDER BY pepSequence__c ASC];
            
            if(siblingQuestionsList != null && (!siblingQuestionsList.isEmpty())){
                for(pepCmsQuestion__c siblingQuestion:siblingQuestionsList){
                    answerToQuestionSiblingQuestions.put(siblingQuestion.Id,siblingQuestion);
                }
            }
            isCalledFromDropDown=false;
            setDeletedIds=new set<Id>();
        }
        Catch(Exception Ex){
        }
    } 
    
    //This method is to render section story
    // Created By : Vipin Kumar
    public void parsedSectionStory(){
        
        try{
            objModelContainer.SaveInputValuesToFields();
            for(pepCMSModelContainer_New.wrapSection S : objModelContainer.lstSection) {
                
                if(strPageName == 'Income Details' && S.objCmsSection.pepSectionUniqueName__c=='Income Details')
                {
                    String strStory=S.objCmsSection.pepSectionStory__c;
                    String separator='</br>';
                    String strFirstStory=strStory.substringBefore(separator);
                    if((!objModelContainer.lstIncome.isEmpty()) && String.valueOf(objModelContainer.lstIncome[0].Gross_Income__c)!=null && String.valueOf(objModelContainer.lstIncome[0].Gross_Income__c)!='') 
                    {
                        Decimal dollars;
                        Decimal cents;
                        dollars = objModelContainer.lstIncome[0].Gross_Income__c.intValue();
                        cents = objModelContainer.lstIncome[0].Gross_Income__c- objModelContainer.lstIncome[0].Gross_Income__c.intValue();
                        cents = cents.setScale(2);
                        
                        strFirstStory=strFirstStory.replace('{Income__c.Gross_Income__c}',dollars.format() + cents.toPlainString().substring(1));
                        strFirstStory=strFirstStory.replace('{Income__c.Frequency__c}',objModelContainer.lstIncome[0].Frequency__c);
                    }
                    else
                    {
                        strFirstStory=null;
                    }
                    String strSecStory=null;
                    String strTempStory=strStory.substringAfter(separator);
                    if(objModelContainer.lstIncome.size()>1)
                    {
                        for(Integer i=1;i<objModelContainer.lstIncome.size();i++)
                        {
                            if((String.valueOf(objModelContainer.lstIncome[i].Gross_Income__c)!=null && String.valueOf(objModelContainer.lstIncome[i].Gross_Income__c)!='') && (objModelContainer.lstIncome[i].Frequency__c!=null && objModelContainer.lstIncome[i].Frequency__c!=''))
                            {
                                String temp2=null;
                                Decimal dollars;
                                Decimal cents;
                                dollars = objModelContainer.lstIncome[i].Gross_Income__c.intValue();
                                cents = objModelContainer.lstIncome[i].Gross_Income__c- objModelContainer.lstIncome[i].Gross_Income__c.intValue();
                                cents = cents.setScale(2);
                                temp2=strTempStory.replace('{Income__c.Gross_Income__c}',dollars.format() + cents.toPlainString().substring(1));
                                temp2=temp2.replace('{Income__c.Frequency__c}',objModelContainer.lstIncome[i].Frequency__c);
                                if(strSecStory==null) strSecStory=temp2;
                                else strSecStory=strSecStory+' '+temp2;
                                
                            }                       
                        }
                    }
                    else
                    {
                        strSecStory=null;
                    }
                    
                    if(strFirstStory!=null && strSecStory!=null)
                    {
                        S.strSectionStory =strFirstStory+' '+strSecStory;
                    }
                    else if(strFirstStory!=null && strSecStory==null)
                    {
                        S.strSectionStory=strFirstStory;
                    }
                    S.isRenderSectionStory=true;
                }
                else if(strPageName == 'Income Details' && S.objCmsSection.pepSectionUniqueName__c=='Financial Stability'){
                    String strStory=S.objCmsSection.pepSectionStory__c;
                    if(objModelContainer.objApplication!=null && objModelContainer.objApplication.Expecting_Financial_Loss__c!=null)
                    {
                        if(objModelContainer.objApplication.Expecting_Financial_Loss__c=='Yes') S.strSectionStory = strStory.replace('{genesis__Applications__c.Expecting_Financial_Loss__c} ',' do ');
                        else if(objModelContainer.objApplication.Expecting_Financial_Loss__c=='No') S.strSectionStory = strStory.replace('{genesis__Applications__c.Expecting_Financial_Loss__c} ',' don\'t ');  
                    }
                    S.isRenderSectionStory=true;
                }
                else if(strPageName == 'Personal Details' && S.objCmsSection.pepSectionUniqueName__c=='PersonalDetailsSec1'){
                    String strStory=S.objCmsSection.pepSectionStory__c;
                    if(objModelContainer.objAccount!=null 
                       && objModelContainer.objAccount.FirstName!=null 
                       && objModelContainer.objAccount.Relationship_Status__c!=null
                       && (objModelContainer.objAccount.Number_of_Dependants__c !=null && string.valueof(objModelContainer.objAccount.Number_of_Dependants__c) != ''))
                    {
                        strStory = strStory.replace('{Account.FirstName}', objModelContainer.objAccount.FirstName);
                        strStory = strStory.replace('{Account.Relationship_Status__c}',objModelContainer.objAccount.Relationship_Status__c);
                        strStory = strStory.replace('{Account.Number_of_Dependants__c}',String.valueof(objModelContainer.objAccount.Number_of_Dependants__c));
                        S.strSectionStory =strStory;
                    }
                    S.isRenderSectionStory=true;        
                }
                else if(strPageName == 'Personal Details' && S.objCmsSection.pepSectionUniqueName__c=='Residential Details'){
                    String separator='</br>';
                    String strStory=S.objCmsSection.pepSectionStory__c;
                    String strFirstStory=strStory.substringBefore(separator);
                    String strSecondStory=strStory.substringAfter(separator);
                    if(tempResidentialAddressHolder!=null && (!tempResidentialAddressHolder.isEmpty()))
                    {
                        integer lengthRAList=0;
                        String temp2=null;
                        String temp3=null;
                        
                        for(Integer i=0;i<tempResidentialAddressHolder.size();i++)
                        {
                            if(tempResidentialAddressHolder[i].Current_Address__c && (tempResidentialAddressHolder[i].What_is_Your_Residential_Status__c!=null && tempResidentialAddressHolder[i].What_is_Your_Residential_Status__c!='') && (tempResidentialAddressHolder[i].How_Long_have_you_lived_here__c!=null && tempResidentialAddressHolder[i].How_Long_have_you_lived_here__c!=''))
                            {
                                
                                temp2=strFirstStory.replace('{Residential_Address__c.What_is_Your_Residential_Status__c}',tempResidentialAddressHolder[i].What_is_Your_Residential_Status__c);
                                temp2=temp2.replace('{Residential_Address__c.How_Long_have_you_lived_here__c}',tempResidentialAddressHolder[i].How_Long_have_you_lived_here__c);
                                //if(tempResidentialAddressHolder[i].How_Long_have_you_lived_here__c!='Less than 2 years') temp3=null;
                                
                            }                    
                            else if(!tempResidentialAddressHolder[i].Current_Address__c && tempResidentialAddressHolder[i].How_Long_have_you_lived_here__c!=null && tempResidentialAddressHolder[i].How_Long_have_you_lived_here__c!='')
                            {
                                temp3=strSecondStory.replace('{Residential_Address__c.How_Long_have_you_lived_here__c}',tempResidentialAddressHolder[i].How_Long_have_you_lived_here__c);                            
                                
                            }                      
                        }
                        if(temp2!=null && temp3!=null)
                        {
                            S.strSectionStory =temp2+' '+temp3;
                        }
                        else if(temp2!=null && temp3==null)
                        {
                            S.strSectionStory=temp2;
                        }
                    }
                    else
                    {
                        S.strSectionStory=null;
                    }
                    S.isRenderSectionStory=true;        
                }
                else if(strPageName == 'Personal Details' && S.objCmsSection.pepSectionUniqueName__c=='Employment Details'){
                    String separator='</br>';
                    String strStory=S.objCmsSection.pepSectionStory__c;
                    String strFirstStory=strStory.substringBefore(separator);
                    String strSecondStory=strStory.substringAfter(separator);
                    if(!objModelContainer.lstEmploymentInformation.isEmpty())
                    {
                        integer lengthEDList=0;
                        String temp2=null;
                        String temp3=null;
                        String temp4=null;
                        if(objModelContainer.lstEmploymentInformation.size()>1)
                        {
                            AggregateResult[] lstCountED;
                            if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                                lstCountED=[SELECT count(Id) EDCount FROM genesis__Employment_Information__c where genesis__Application__c=:objModelContainer.objApplication.id];
                                
                                lengthEDList=(integer)lstCountED[0].get('EDCount');
                            }
                            else{
                                PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                                throw new DMLException('This is a SOQL limit exception handling mechanism');
                            }
                        }
                        for(Integer i=0;i<objModelContainer.lstEmploymentInformation.size();i++)
                        {                   
                            if(i<lengthEDList || lengthEDList ==0 || (i>=lengthEDList && objModelContainer.lstEmploymentInformation[i].id==null))
                            {
                                if(objModelContainer.lstEmploymentInformation[i].Sequence__c==1 && objModelContainer.lstEmploymentInformation[i].Employment_Status__c!=null && objModelContainer.lstEmploymentInformation[i].How_Long_have_you_worked__c!=null)
                                {
                                    
                                    temp2=strFirstStory.replace('{genesis__Employment_Information__c.Status}',objModelContainer.lstEmploymentInformation[i].Employment_Status__c);
                                    temp2=temp2.replace('{genesis__Employment_Information__c.Term}',objModelContainer.lstEmploymentInformation[i].How_Long_have_you_worked__c);
                                    temp4=null;
                                    
                                }
                                else if(objModelContainer.lstEmploymentInformation[i].Sequence__c>1 && objModelContainer.lstEmploymentInformation[i].Employment_Status__c!=null && objModelContainer.lstEmploymentInformation[i].How_Long_have_you_worked__c!=null)
                                {
                                    temp3=null;
                                    temp3=strSecondStory.replace('{genesis__Employment_Information__c.BeforeStatus}',objModelContainer.lstEmploymentInformation[i].Employment_Status__c);                            
                                    temp3=temp3.replace('{genesis__Employment__c.BeforeTerm}',objModelContainer.lstEmploymentInformation[i].How_Long_have_you_worked__c);
                                    if(temp4==null) temp4=temp3;
                                    else temp4=temp4 +' '+temp3;
                                }
                            }                       
                        }
                        if(temp2!=null && temp4!=null)
                        {
                            S.strSectionStory =temp2+' '+temp4;
                        }
                        else if(temp2!=null && temp4==null)
                        {
                            S.strSectionStory=temp2;
                        }
                    }
                    else
                    {
                        S.strSectionStory=null;
                    }
                    S.isRenderSectionStory=true;        
                }
            }
        }
        Catch(exception Ex){
        } 
    }
    
    //This method renders Questions and put it in pepCMSModelContainer_New
    public pepCMSModelContainer_New getRenderQuestions(){
        
        try{
            if(!objModelContainer.lstSection.isEmpty()){
                return objModelContainer;
            }
            map<id, pepCmsSection__c> mapSections;
            if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                mapSections = new map<id, pepCmsSection__c>([SELECT pepHeader__c,pepPage__c, pepSectionBody__c, Name, pepSectionUniqueName__c, pepType__c, 
                                                             pepSectionStory__c , Page_Name__c  ,pepSectionStoryRich__c,pepSectionBodyRich__c                                             
                                                             from pepCmsSection__c 
                                                             where pepPage__r.pepPageName__c=: strPageName
                                                             AND pepType__c = 'Form'
                                                             order by pepSequence__c]);
            }
            else{
                PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                
                throw new DMLException('This is a SOQL limit exception handling mechanism');
                
            }
            
            List<pepCmsQuestion__c> lstQuestions;
            if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                lstQuestions = [SELECT Id,Is_Date_to_Birth__c, pepSection__c,pepSection__r.Name ,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, pepRecordSequence__c,
                                pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, 
                                pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, 
                                pepGoogleApi__c,
                                
                                (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id,pepHasDependentQuestions__c 
                                 FROM pepCmsAnswer__r order by pepSequence__c ASC), 
                                
                                (SELECT pepSection__c,pepGenericErrorMessage__c,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,pepRecordSequence__c,
                                 pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepSubType__c, 
                                 pepRelatedCSS__c,Is_Date_to_Birth__c 
                                 FROM CmsQuestion__r
                                 ORDER BY pepSequence__c ASC),pepHasAnswers__c
                                
                                FROM pepCmsQuestion__c
                                WHERE pepSection__c in: mapSections.values()
                                
                                ORDER BY pepSequence__c ASC];
            }
            else{
                PeputilityClass.sendExceptionemail(Peputilityclass.getCurrrentString());
                throw new DMLException('This is a SOQL limit exception handling mechanism');
            }
            
            Map<id, List<pepCmsQuestion__c>> mapSectionAndQuestions = new Map<id, List<pepCmsQuestion__c>>();
            Map<id, List<pepCmsQuestion__c>> mapQuestionsAndSiblings = new Map<id, List<pepCmsQuestion__c>>();
            
            for(pepCmsQuestion__c Q : lstQuestions){
                if(mapSectionAndQuestions.get(Q.pepSection__c) == null){
                    mapSectionAndQuestions.put(Q.pepSection__c, new List<pepCmsQuestion__c>());
                }
                mapSectionAndQuestions.get(Q.pepSection__c).add(Q);
                for(pepCmsQuestion__c SQ : Q.CmsQuestion__r){
                    if(mapQuestionsAndSiblings.get(Q.Id) == null){
                        mapQuestionsAndSiblings.put(Q.Id, new List<pepCmsQuestion__c>());
                    }
                    mapQuestionsAndSiblings.get(Q.Id).add(SQ);
                }
            }
            Map<id, pepCmsQuestion__c> lstSiblingQuestions;
            if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
                lstSiblingQuestions = new Map<id, pepCmsQuestion__c>( [SELECT Id,Is_Date_to_Birth__c , pepSection__c,pepSection__r.Name ,CreatedById, CreatedDate, IsDeleted, pepDisplayDollar__c, pepDisplayPercent__c, pepFieldApiName__c, 
                                                                       pepIsRequired__c,pepGenericErrorMessage__c , pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c, pepLabelPriorQuestion__c, LastModifiedById, LastModifiedDate, pepRecordSequence__c, 
                                                                       pepNumbersOnly__c, OwnerId, pepQuestion__c, Name, pepSObjectApiName__c, pepSequence__c, pepType__c, pepValidEmail__c, pepCMSAnswer__c,pepRelatedCSS__c,pepSubType__c, pepGoogleApi__c ,
                                                                       
                                                                       (SELECT Name,pepCmsQuestion__c,pepActualValue__c,pepDisplayText__c,pepSequence__c,Id,pepHasDependentQuestions__c 
                                                                        FROM pepCmsAnswer__r order by pepSequence__c ASC), 
                                                                       
                                                                       (SELECT pepSection__c,pepGenericErrorMessage__c,pepDisplayDollar__c,pepDisplayPercent__c,pepFieldApiName__c,pepIsRequired__c,pepKeyPressNumbersOnly__c, pepLabelAfterQuestion__c,
                                                                        pepLabelPriorQuestion__c,pepNumbersOnly__c,pepQuestion__c,Name,pepSObjectApiName__c,pepSequence__c,pepType__c,Id,pepValidEmail__c,pepCMSAnswer__c ,pepSubType__c, pepRecordSequence__c,
                                                                        pepRelatedCSS__c, Is_Date_to_Birth__c 
                                                                        FROM CmsQuestion__r
                                                                        ORDER BY pepSequence__c ASC),pepHasAnswers__c
                                                                       
                                                                       FROM pepCmsQuestion__c
                                                                       WHERE pepQuestion__c in: mapQuestionsAndSiblings.keyset()
                                                                       
                                                                       ORDER BY pepSequence__c ASC] );
                
            }
            else{
                PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
                throw new DMLException('This is a SOQL limit exception handling mechanism');
            }
            for(pepCmsSection__c S : mapSections.values()){
                
                pepCMSModelContainer_New.wrapSection QS = new pepCMSModelContainer_New.wrapSection();
                QS.objCmsSection = S;
                if(mapSectionAndQuestions.get(S.id) != null){
                    for(pepCmsQuestion__c Q : mapSectionAndQuestions.get(S.id)){
                        pepCMSModelContainer_New.wrapQuestion objQ = new pepCMSModelContainer_New.wrapQuestion(Q,null);
                        QS.lseQuestions.add(objQ);
                        if(Q.CmsQuestion__r != null && (!Q.CmsQuestion__r.isEmpty())){
                            for(pepCmsQuestion__c SQ : Q.CmsQuestion__r){
                                if(lstSiblingQuestions.get(SQ.Id) != null){
                                    pepCMSModelContainer_New.wrapQuestion objSQ = new pepCMSModelContainer_New.wrapQuestion(lstSiblingQuestions.get(SQ.Id),null);
                                    objQ.lstSiblingQuestions.add(objSQ);
                                }
                            }
                        }
                    }
                }
                objModelContainer.lstSection.add(QS);
            }
            objModelContainer.FetchDataToInputValue();
            
            runSelectedLogic();
            
            return objModelContainer;
        }
        catch(Exception ex){
            return new pepcmsmodelcontainer_new();
        }                                            
    }
    
    //This method is created for getting 'selected Questions', 'Selected Answers', 'what to do' values
    public void runSelectedLogic(){
        
        list<list<String>> lstListQ = new list<list<String>>();
        
        for(pepCMSModelContainer_New.wrapSection WS : objModelContainer.lstSection){
            
            for(pepCMSModelContainer_New.wrapQuestion WQ : WS.lseQuestions){
                
                if(WQ.objInputValue != null && WQ.objInputValue != ''){
                    
                    if((WQ.objCmsQuestion.pepType__c == 'Button' || WQ.objCmsQuestion.pepType__c == 'Picklist') && WQ.isRunSelectedLogic == false){
                        
                        List<string> l = new list<string>();
                        WQ.isRunSelectedLogic = true;
                        SelectedAnswer =    WQ.objInputValue;
                        l.add(SelectedAnswer);
                        selectedQuestion = WQ.objCmsQuestion.id;
                        l.add(selectedQuestion);
                        selectedSection = WS.objCmsSection.id;
                        l.add(selectedSection);
                        
                        if(WQ.objCmsQuestion.pepSubType__c != null && WQ.objCmsQuestion.pepSubType__c == '+ / -'){
                            WhatToDo = 'ADD,ABOVE';
                            
                        }else{
                            WhatToDo = 'ADD,NEXT';
                        }
                        l.add(WhatToDo);
                        lstListQ.add(l);
                    }
                }
            }
        }
        
        for(list<string> lstL : lstListQ){
            
            SelectedAnswer = lstL[0];
            selectedQuestion = lstL[1];
            selectedSection = lstL[2];
            WhatToDo = lstL[3];
            instance = 'Loading';
            relatedQuestionsOfAnswers();
        }
    }
    
    //This method is used to remove questions when user click on '-' button
    public void removeQuestionOnMinus()
    {
        
        pepCMSModelContainer_New.wrapSection theSection;
        pepCMSModelContainer_New.wrapQuestion theQuestion;
        pepCMSModelContainer_New.wrapAnswer parentId;
        list<pepCMSModelContainer_New.wrapQuestion> newWrapQuestion=new list<pepCMSModelContainer_New.wrapQuestion>();
        List<income__c> lstTempInc=new List<income__c>();        
        
        integer QuestionIndex = 0;
        Boolean isSecondary=false;
        for(pepCMSModelContainer_New.wrapSection S : objModelContainer.lstSection){
            if(S.objCmsSection.Id == selectedSection){
                
                theSection = S;
                QuestionIndex = 0;
                if(S.lseQuestions.size()<7) isSecondary=true;
                for(pepCMSModelContainer_New.wrapQuestion Q : S.lseQuestions){                
                    QuestionIndex ++;                  
                    if(Q.objCmsQuestion.id==selectedQuestion) 
                    {
                        theQuestion = Q;
                        newWrapQuestion=removeQuestionWithThisParent(Q.parentId,S.lseQuestions,isSecondary);
                        break;
                    }
                }
                S.lseQuestions=newWrapQuestion;
                // for income
                if(objModelContainer.lstIncome!=null && (!objModelContainer.lstIncome.isEmpty()))
                {
                    
                    integer intLength=objModelContainer.lstIncome.size();
                    for(integer i=0;i<intLength-1;i++)
                    {
                        lstTempInc.add(objModelContainer.lstIncome[i]);
                    }
                    system.debug('Test Debug  objModelContainer.lstIncome  ' +objModelContainer.lstIncome);
                    system.debug('Test Debug  intLength  ' +intLength);
                    income__c incTemp=objModelContainer.lstIncome[intLength-1];
                    income__c incTemp2;
                    if(intLength-2 >= 0){
                        incTemp2=objModelContainer.lstIncome[intLength-2];
                    }
                    
                    if(incTemp!=null && incTemp.id!=null)
                    {
                        pepUtilityClass.safeDelete(incTemp, 'Income__c');
                    }
                    if(incTemp2!=null && incTemp2.id!=null)
                    {
                        incTemp2.Next_Income_Added__c ='-';
                        update incTemp2;
                    }
                }
                
                
            }
            break;
        }
        objModelContainer.lstIncome=new list<income__c>();
        objModelContainer.lstIncome=lstTempInc;
        objModelContainer.SaveInputValuesToFields();
        
    }
    
    //This method remove question with given parent id.
    public list<pepCMSModelContainer_New.wrapQuestion> removeQuestionWithThisParent(Id parentId,list<pepCMSModelContainer_New.wrapQuestion> ques,Boolean isSecondary)
    {
        list<pepCMSModelContainer_New.wrapQuestion> newWrapQuestionTemp=new list<pepCMSModelContainer_New.wrapQuestion>();        
        pepCMSModelContainer_New.wrapAnswer theAnswer;
        Boolean isChanged=false;
        for(pepCMSModelContainer_New.wrapQuestion Q : ques){
            if(isSecondary)
            {
                for(pepCMSModelContainer_New.wrapAnswer A : Q.lstExpectedAnswers){
                    if(SelectedAnswer != null && SelectedAnswer!='' && SelectedAnswer!= 'null')
                    {                            
                        if(A.objCmsAnswer.Name == 'No'){
                            Q.objInputValue = A.objCmsAnswer.id;
                            theAnswer = A;
                        } 
                    }
                }
            }
            if(Q.parentId!=parentId)
            {
                if(Q.objCmsQuestion.pepType__c=='Button' && Q.objCmsQuestion.pepSubType__c=='+ / -' && !isChanged)
                {
                    isChanged=true;
                    Q.isRender=true;
                }
                newWrapQuestionTemp.add(Q);
            }
        }
        return newWrapQuestionTemp;
    }
    
    //This method is to add parent id related to question need to be removed
    public Set<Id> removeQuestion(Set<Id> answerId,list<pepCMSModelContainer_New.wrapQuestion> ques)
    {
        Set<Id> setParentId=new Set<Id>();
        for(pepCMSModelContainer_New.wrapQuestion Q : ques){
            if(answerId.contains(Q.parentId))
            {
                setParentId.add(Q.parentId);
            }
        }
        return setParentId;
    }
    //This method is created for removing questions from dropdown
    public void removeQuesOnDropDownChange()
    {
        isCalledFromDropDown=true;
        removeQuestionFromWrapper();
        isCalledFromDropDown=false;
    }
    
    //This method is used to remove questions when user click on 'NO' button
    public void removeQuestionFromWrapper()
    {
        pepCMSModelContainer_New.wrapSection theSection;
        pepCMSModelContainer_New.wrapQuestion theQuestion;
        pepCMSModelContainer_New.wrapAnswer theAnswer;
        pepCMSModelContainer_New.wrapAnswer parentId; //Added by Vipin
        integer QuestionIndex = 0;
        Set<Id> setOtherAnswerId=new Set<Id>();
        Set<Id> setParentId=new Set<Id>();
        Set<Id> setFinalParentId=new Set<Id>();
        ID startingParentId;
        String strNullValue='Choose one';
        list<pepCMSModelContainer_New.wrapQuestion> newWrapQuestion=new list<pepCMSModelContainer_New.wrapQuestion>();
        list<pepCMSModelContainer_New.wrapQuestion> newWrapQuestionTemp=new list<pepCMSModelContainer_New.wrapQuestion>();
        pepCMSModelContainer_New.wrapQuestion q1;
        pepCMSModelContainer_New.wrapQuestion q2;
        string strURL;
        for(pepCMSModelContainer_New.wrapSection S : objModelContainer.lstSection){
            
            if(S.objCmsSection.Id == selectedSection){                                
                theSection = S;
                QuestionIndex = 0;
                strURL = ApexPages.currentPage().getUrl();          
                if(strURL.contains('?'))
                {
                    strURL= strurl.substringBefore('?');
                }
                strURL= strURL.split('apex/')[1];
                if(strURL != 'pepPersonaldetails' && !isCalledFromDropDown)
                {
                    if(S.lseQuestions.size()>16)
                    {
                        q1=S.lseQuestions[12];
                        q2=S.lseQuestions[13];
                        S.lseQuestions[12]=S.lseQuestions[17];
                        S.lseQuestions[13]=S.lseQuestions[16];
                        S.lseQuestions[16]=q1;
                        S.lseQuestions[17]=q2;
                    }
                    else if(S.lseQuestions.size()>12)
                    {
                        q1=S.lseQuestions[10];
                        q2=S.lseQuestions[11];
                        S.lseQuestions[10]=S.lseQuestions[13];
                        S.lseQuestions[11]=S.lseQuestions[12];
                        S.lseQuestions[12]=q1;
                        S.lseQuestions[13]=q2;
                    }
                    else if(S.lseQuestions.size()>10 && S.lseQuestions.size()<13)
                    {
                        q1=S.lseQuestions[8];
                        q2=S.lseQuestions[9];
                        S.lseQuestions[8]=S.lseQuestions[11];
                        S.lseQuestions[9]=S.lseQuestions[10];
                        S.lseQuestions[10]=q1;
                        S.lseQuestions[11]=q2;
                    }
                    
                }
                
                newWrapQuestionTemp.addAll(S.lseQuestions);
                for(pepCMSModelContainer_New.wrapQuestion Q : S.lseQuestions){                
                    QuestionIndex ++;
                    setOtherAnswerId=new Set<Id>();
                    if(Q.objCmsQuestion.id==selectedQuestion) 
                    {
                        theQuestion = Q;
                        
                        for(pepCMSModelContainer_New.wrapAnswer A : Q.lstExpectedAnswers){
                            
                            if(SelectedAnswer== 'null' && A.objCmsAnswer.pepActualValue__c.toLowerCase()==strNullValue.toLowerCase())
                            {
                                startingParentId=A.objCmsAnswer.id;
                            }
                            if(SelectedAnswer != null && SelectedAnswer!='')
                            {
                                String tempId=A.objCmsAnswer.id;
                                if(tempId != SelectedAnswer && A.objCmsAnswer.id!=startingParentId){
                                    setOtherAnswerId.add(A.objCmsAnswer.id);
                                }
                                if(tempId == SelectedAnswer){
                                    Q.objInputValue = SelectedAnswer;
                                    theAnswer = A;
                                }
                            }
                            
                        }
                    }
                    else
                        if(setParentId!=null && (!setParentId.isEmpty()) && setParentId.contains(Q.parentId))
                    {
                        for(pepCMSModelContainer_New.wrapAnswer A : Q.lstExpectedAnswers){
                            setOtherAnswerId.add(A.objCmsAnswer.id);                            
                        }
                    }
                    
                    if(!setOtherAnswerId.isEmpty())    
                    {
                        
                        Set<id> setTempId=new Set<id>();
                        setTempId=removeQuestion(setOtherAnswerId,newWrapQuestionTemp);
                        if(!setTempId.isEmpty()) setParentId=setTempId;
                        
                        setFinalParentId.addAll(setParentId);
                        
                    }
                    if(!setFinalParentId.contains(startingParentId) && startingParentId!=null) 
                    {
                        setFinalParentId.add(startingParentId);
                    }
                    
                }
                break;
            }
        }        
        
        //remove question from wrapper,if its parentId parameter is in setFinalParentId set
        if(setFinalParentId!=null && (!setFinalParentId.isEmpty()) || Test.isRunningTest()){
            list<Residential_Address__c> lstRATemp=new list<Residential_Address__c>();
            list<genesis__Employment_Information__c> lstEITemp=new list<genesis__Employment_Information__c>();
            for(pepCMSModelContainer_New.wrapSection S : objModelContainer.lstSection){
                if(S.objCmsSection.Id == selectedSection){
                    
                    for(pepCMSModelContainer_New.wrapQuestion Q : S.lseQuestions){
                        
                        if(!setFinalParentId.contains(Q.parentId)) {
                            newWrapQuestion.add(Q);
                        }
                    }
                    S.lseQuestions=newWrapQuestion;
                    if(objModelContainer.lstIncome!=null && (!objModelContainer.lstIncome.isEmpty()))
                    {
                        List<income__c> lstTempInc=new List<income__c>();
                        List<income__c> lstTempInc2=new List<income__c>();
                        for(income__c income:objModelContainer.lstIncome)
                        {
                            if(income.id!=null && income.Sequence__c!=1)
                            {
                                lstTempInc2.add(income);
                            }
                            else if(income.Sequence__c==1)
                            {
                                lstTempInc.add(income);
                            }                    
                        }
                        
                        objModelContainer.lstIncome=lstTempInc;
                        if(!lstTempInc2.isEmpty()) {
                            pepUtilityClass.safeDelete(lstTempInc2, 'Income__c');
                        }
                            
                    }
                    
                    if(strURL == 'pepPersonaldetails' || Test.isRunningTest())
                    {
                        
                        
                        list<Residential_Address__c> lstRATempDel=new list<Residential_Address__c>();
                        list<genesis__Employment_Information__c> lstEITempDel=new list<genesis__Employment_Information__c>();
                        if(S.objCmsSection.pepHeader__c=='Residential Details')
                        {
                            set<string> setSequence=new set<string>();
                            for(pepCMSModelContainer_New.wrapQuestion newQ:newWrapQuestion)
                            {
                                if(!setSequence.contains(String.valueOf(newQ.objCmsQuestion.pepRecordSequence__c))) setSequence.add(String.valueOf(newQ.objCmsQuestion.pepRecordSequence__c));  
                            }
                            Set<integer> setIndex=new Set<integer>();
                            Integer flag=0;   
                            for(Residential_Address__c rd:objModelContainer.lstResidentialAddress)
                            {
                                if((rd.Current_Address__c && setSequence.contains('1')) || (!rd.Current_Address__c && setSequence.contains('2')))
                                {
                                    lstRATemp.add(rd);
                                }
                                else if(rd.id!=null){
                                    lstRATempDel.add(rd);
                                    setIndex.add(flag);                                    
                                }
                                flag++;
                            }
                            if((!lstRATempDel.isEmpty()) && !isdeleted){
                                isdeleted=true;
                                pepUtilityClass.safeDelete(lstRATempDel, 'Residential_Address__c');
                            }
                            objModelContainer.strtest='567';
                            
                            objModelContainer.lstResidentialAddress= new List<Residential_Address__c>();
                            objModelContainer.lstResidentialAddress=lstRATemp;
                        }
                        else if(S.objCmsSection.pepHeader__c=='Employment Details')
                        {
                            set<string> setSequence=new set<string>();
                            for(pepCMSModelContainer_New.wrapQuestion newQ:newWrapQuestion)
                            {
                                if(!setSequence.contains(String.valueOf(newQ.objCmsQuestion.pepRecordSequence__c))) setSequence.add(String.valueOf(newQ.objCmsQuestion.pepRecordSequence__c));  
                            }
                            for(genesis__Employment_Information__c ei:objModelContainer.lstEmploymentInformation)
                            {
                                if(setSequence.contains(String.valueOf(ei.Sequence__c)))
                                {
                                    lstEITemp.add(ei);
                                }
                                else if(ei.id!=null && !setDeletedIds.contains(ei.id)){
                                    lstEITempDel.add(ei);
                                    setDeletedIds.add(ei.id);
                                }
                            }
                            
                            if(!lstEITempDel.isEmpty()) {
                                pepUtilityClass.safeDelete(lstEITempDel, 'genesis__Employment_Information__c');
                            }
                            objModelContainer.lstEmploymentInformation=lstEITemp;
                        }
                    }
                    
                    break;
                }
                
            }
        }
        //Code For Temperary Address Holding
        
        
        objModelContainer.SaveInputValuesToFields();
        tempResidentialAddressHolder = new List<Residential_Address__c>(objModelContainer.lstResidentialAddress);
    }
    
    //This method is created for putting values in pepCMSModelContainer_New object's wrapQuestion, wrapSection, wrapAnswer
    public void relatedQuestionsOfAnswers() {
        
        pepCMSModelContainer_New.wrapSection theSection;
        pepCMSModelContainer_New.wrapQuestion theQuestion;
        pepCMSModelContainer_New.wrapAnswer theAnswer;
        pepCMSModelContainer_New.wrapAnswer parentId; //Added by Vipin
        integer QuestionIndex = 0;
        String varSelected;
        if(!SelectedAnswer.contains('null'))
            varSelected=SelectedAnswer.substring(0,18);
        else
            varSelected='null';
        for(pepCMSModelContainer_New.wrapSection S : objModelContainer.lstSection){
            if(S.objCmsSection.Id == selectedSection){
                theSection = S;
                QuestionIndex = 0;
                for(pepCMSModelContainer_New.wrapQuestion Q : S.lseQuestions){
                    QuestionIndex ++;
                    if(Q.objCmsQuestion.Id == selectedQuestion){
                        
                        theQuestion = Q;
                        if(varSelected=='null')
                            Q.handleRerender=false;
                        for(pepCMSModelContainer_New.wrapAnswer A : Q.lstExpectedAnswers){
                            if(SelectedAnswer != null && SelectedAnswer!='' && SelectedAnswer!= 'null')
                            {
                                
                                if(SelectedAnswer.contains('true'))
                                    Q.handleRerender=true;
                                if(SelectedAnswer.contains('false'))
                                    Q.handleRerender=false;
                                if(!SelectedAnswer.Contains('true') && !SelectedAnswer.contains('false'))
                                    Q.handlererenderonButton=true;
                                if(A.objCmsAnswer.id == varSelected){
                                    Q.objInputValue = SelectedAnswer;
                                    theAnswer = A;
                                    
                                    break;
                                }
                            }
                        }
                        break;
                    }
                }
                break;
            }
        }
        
        if(WhatToDo.contains('ADD')){
            List<pepCmsQuestion__c> lstQuestions=new List<pepCmsQuestion__c>();

            //Modified by : Sushant Kumar, Date : 29/11/2017, 
            //Purpose : To fix 'choose one' value selection issue after rendering related question
            if(varSelected == 'null') {
                varSelected = null;
            }
            
            if(answerToQuestions.get(varSelected)!=null)
                lstQuestions = answerToQuestions.get(varSelected);
            
            Map<id, pepCmsQuestion__c> lstSiblingQuestions = answerToQuestionSiblingQuestions;
            
            if(WhatToDo.contains('ABOVE')){
                QuestionIndex --;
                theSection.lseQuestions[QuestionIndex].isRender=false;
            }
            
            if(lstQuestions!=null && (!lstQuestions.isEmpty()))
            {
                if(theQuestion!=null && theQuestion.objCmsQuestion!=null && theQuestion.objCmsQuestion.pepType__c == 'Picklist')
                {
                    removeQuesOnDropDownChange();
                }
                for(pepCmsQuestion__c Q : lstQuestions){
                    
                    pepCMSModelContainer_New.wrapQuestion theQue = new pepCMSModelContainer_New.wrapQuestion(Q,varselected);
                    if(Q.CmsQuestion__r != null && (!Q.CmsQuestion__r.isEmpty())){
                        for(pepCmsQuestion__c SQ : Q.CmsQuestion__r){
                            if(lstSiblingQuestions.get(SQ.Id) != null){
                                pepCMSModelContainer_New.wrapQuestion objSQ = new pepCMSModelContainer_New.wrapQuestion(lstSiblingQuestions.get(SQ.Id),null);
                                theQue.lstSiblingQuestions.add(objSQ);
                            }
                        }
                    }
                    
                    if(QuestionIndex < theSection.lseQuestions.size()){
                        theSection.lseQuestions.add(QuestionIndex, theQue);
                        QuestionIndex ++;
                    }else{
                        theSection.lseQuestions.add(theQue);
                        QuestionIndex ++;
                    }
                    
                }
            }else
            {
                if(theQuestion!=null && theQuestion.objCmsQuestion!=null && theQuestion.objCmsQuestion.pepType__c == 'Picklist')
                {
                    removeQuesOnDropDownChange();
                }
            }
            
        }else{
            if(WhatToDo.contains('ABOVE')){
                
                string AnswerIDToQuery = theQuestion.objCmsQuestion.pepCMSAnswer__c;
                List<string> lstAnswerIds = new List<string>();
                if(AnswerIDToQuery != ''){
                    lstAnswerIds.add(AnswerIDToQuery);
                }
                pepCMSModelContainer_New.wrapQuestion foundQuestion = new pepCMSModelContainer_New.wrapQuestion();
                
                for(pepCMSModelContainer_New.wrapQuestion Q : theSection.lseQuestions){
                    for(pepCMSModelContainer_New.wrapAnswer A : Q.lstExpectedAnswers){
                        if(A.objCmsAnswer.id == AnswerIDToQuery){
                            foundQuestion = Q;
                            break;
                        }
                    }
                }
                
                String QuestionParent = foundQuestion.objCmsQuestion.pepCMSAnswer__c;
                
                if(AnswerIDToQuery != ''){
                    lstAnswerIds.add(QuestionParent);
                }
                
                List<pepCmsQuestion__c> lstQuestions = new List<pepCmsQuestion__c>();
                if(lstAnswerIds!= null && (!lstAnswerIds.isEmpty())){

                    for(String answerId:lstAnswerIds){
                        
                        if(answerToQuestions.get(answerId)!=null && (!answerToQuestions.get(answerId).isEmpty()))
                            lstQuestions.addall(answerToQuestions.get(answerId));
                    }
                }
                
                if(lstQuestions != null && (!lstQuestions.isEmpty())){
                    Map<id,List<pepCmsQuestion__c>> mapAnsAndQues = new Map<id,List<pepCmsQuestion__c>>();
                    for(pepCmsQuestion__c Q : lstQuestions){
                        if(mapAnsAndQues.get(Q.pepCMSAnswer__c) == null){
                            mapAnsAndQues.put(Q.pepCMSAnswer__c, new List<pepCmsQuestion__c>());
                        }
                        mapAnsAndQues.get(Q.pepCMSAnswer__c).add(Q);
                    }
                    
                    integer count = 0;
                    for(pepCmsQuestion__c Q : mapAnsAndQues.get(AnswerIDToQuery)){
                        for(pepCMSModelContainer_New.wrapQuestion WQ : theSection.lseQuestions){
                            count ++;
                            if(WQ.objCmsQuestion.id == Q.Id){
                                count --;
                                break;
                            }
                        }
                        if(count > 0 && !Test.isrunningTest()){
                            theSection.lseQuestions[count].isRender=false;
                            count = 0;
                        }
                    }
                    
                    
                    for(pepCmsQuestion__c Q : mapAnsAndQues.get(QuestionParent)){
                        boolean found = false;
                        for(pepCMSModelContainer_New.wrapQuestion WQ : theSection.lseQuestions){
                            if(WQ.objCmsQuestion.id == Q.Id){
                                found = true; break;
                            }
                        }
                        
                        if(!found){
                            pepCMSModelContainer_New.wrapQuestion NewQuestion = new pepCMSModelContainer_New.wrapQuestion(Q,SelectedAnswer);  
                            theSection.lseQuestions.add(  NewQuestion );
                        }
                        
                    }
                }
            }
        }
        
        if(instance == 'Loading') {
            
            objModelContainer.FetchDataToInputValue();
            runSelectedLogic();
            instance = '';
        }
        
    }
    
}