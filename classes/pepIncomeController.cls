/*
This Class is used to handle the working of the PepincomePage.
Code Refactoring by Varun on August 26,2017 
*/
public class pepIncomeController
{
    // -------------------------------------------------------------------------------------------------
    // This class is used as a controller for Community Income&Expense page.
    // -------------------------------------------------------------------------------------------------
    // Created Date: 23-FEB-2016 Created By: Vipin Kumar Email: vipin.kumar@saasfocus.com
    // -------------------------------------------------------------------------------------------------
     public pepCMSModelContainer_New objModelContainer {get; set;}
     Public string pagetoredirect{get;set;}
     public String minimiseFlag{
    get{
        String strFlag=Apexpages.currentPage().getParameters().get('minFlag');
        return strFlag;
    }
    set;
    }
     
    public String strIncomeStoryProperty{
    get;set;
    }
    private String strIncomeStory;
    public String strFinanceStoryProperty{
    get;
    set;
    }
    public Integer intCookiePageNo{get;set;}
    private genesis__Applications__c ap;
    private Id idApplication;
    public string strCookieNo;
    private list<Income__c> lstInc;
    private integer count;
    private boolean isTemp=false;
    public decimal decEMI{get;set;}
    public decimal decIndicativeInterestrate{get;set;} 
    public Integer intCurrentPageNumber{get;set;}
    public Integer intPreviousPageNumber{get;set;}
    public string strPageName {get; set;}
    private list<Income__c> lstIncomeDelete=new list<Income__c>();
    public pepCmsModelContainer modelConInst {
    get;set;}
    public pepCmsModelContainer modelConInst1 {get; set;}
    private String  ReturnValue; 
    //default constructor
    
    public String Page_Name{get;set;}//Added by KG
    public String Page_Label{get;set;}//Added by KG
    //Constructor to load values from Page headers as well as from cookies.
    public pepIncomeController(){
    
      page_Name='pepincomepage';//Added by KG
      Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;//Added by KG
        
        objModelContainer = new pepCMSModelContainer_New();
        strPageName = 'Income Details';
        
        modelConInst = new pepCmsModelContainer();
        modelConInst1 = new pepCmsModelContainer();
        if(ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP')!=null)
           {
               ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'); 
             
           } 
           
        if( ApexPages.currentPage().getParameters().get('redirectFromPageNo') != null 
        &&  ApexPages.currentPage().getParameters().get('redirectFromPageNo') !='')
        {
            intPreviousPageNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('redirectFromPageNo'));   
        }
        
        intCurrentPageNumber =  2;
        
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        if(cookieApplicationId != null && cookieApplicationId.getValue() !='')
        idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
       
        
    }
    
    
   
    
    //This method is getting referenced in Visualforce Page just to provide the rerender thing using Actionfunction(Comment added by Varun)
    // -------------------------------------------------------------------------------------------------
    //This method parse section story
    // -------------------------------------------------------------------------------------------------
    // Created Date: 25-FEB-2016 Created By: Vipin Kumar Email: vipin.kumar@saasfocus.com
    // -------------------------------------------------------------------------------------------------
    public void parsedSectionStory()
    {
        
    }
    
   
       
    // -------------------------------------------------------------------------------------------------
    // This method is used to save changes in application and other child/related objects, 
    // called from continue button on page
    // -------------------------------------------------------------------------------------------------
    // Created Date: 23-FEB-2016 Created By: Vipin Kumar Email: vipin.kumar@saasfocus.com
    // -------------------------------------------------------------------------------------------------
    
    public pagereference continueLoanApp(){
       //   Added by Rishabh Tyagi to handle the Exception Management
      try
      {
            genesis__Applications__c result;
            genesis__Applications__c updateAppFromUI;        
            
            //*****************************************//
            //income detail section logic start here
            //*****************************************//
            
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            List<SObject> lstSobject=new List<SObject>();
            modelConInst.strPageName='Income Details';
            modelConInst.strSectionName='Income Details';
            modelConInst.ReadControlValue();
             
            if(modelConInst.lstIncome!=null)
            {
            for(Income__c inc:modelConInst.lstIncome)
            {
                Income__c income;
                if(inc.id!=null)
                {
                    income=new Income__c(id=inc.id,Frequency__c=inc.Frequency__c,Gross_Income__c=inc.Gross_Income__c,Other_Income__c=inc.Other_Income__c,Sequence__c=inc.Sequence__c,Type__c=inc.Type__c);
                    
                }
                else{
                    income=new Income__c(id=null,Frequency__c=inc.Frequency__c,Gross_Income__c=inc.Gross_Income__c,Other_Income__c=inc.Other_Income__c,Sequence__c=inc.Sequence__c,Type__c=inc.Type__c);
                    
                }            
                if(income.Gross_Income__c!=null) lstSobject.add(income);
            
            }        
            mapChildObjects.put('income__c',lstSobject);
         
}     
            
            //call CL API for updating application
           
            if(modelConInst.lstIncome!=null && modelConInst1.objApplication!=null) 
                if(!Test.isRunningTest())
                result=pepInvokeCLMethodHelper.updateApplication(updateAppFromUI,mapRelatedObjects,mapChildObjects);
            string redircetPageName= pages_config__c.getinstance('pepexpensepage').Page_Label__c;
            PageReference p=new PageReference('/'+redircetPageName).setredirect(True);
            
            //Added by Swati
                Cookie objCookiePage =new Cookie('Page','',null,-1,false);
                objCookiePage = new Cookie('Page',String.valueOf(intCurrentPageNumber),null,-1,false); 
                  
            Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
            cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
            p.setCookies(new Cookie[]{cookieApplicationId2 });
            p.setCookies(new Cookie[]{objCookiePage });
            
            return p;
      }
       catch(Exception ex)
        {
           return peputilityclass.handlePageException(ex);
        }
    }
    //This metod is used to save the data in the Income object for the related Application.
    public PageReference saveData() {
       //   Added by Rishabh Tyagi
       try{
             
                set<id> setTemp=new set<id>();
                if(lstIncomeDelete.size()>0) 
                {
                    pepUtilityClass.safeDelete(lstIncomeDelete, 'Income__c');
                }
                 if(ReturnValue!=null && ReturnValue!='')
                     objModelContainer.objApplication.IP_Address__c =  ReturnValue;
                objModelContainer.SaveInputValuesToFields();
                Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
                Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
                List<income__c> listIncome=new List<income__c>();
                if(objModelContainer.lstIncome!=null)
                {
                for(income__c inc: objModelContainer.lstIncome)
                {
                      inc.id=null;
                      inc.Income_agreement_time_stamp__c = dateTime.Now();
                     if(inc.Other_Income__c=='No')
                     {
                         listIncome.add(inc);
                         break;
                     }
                     else{
                          listIncome.add(inc);   
                     }
                }
                }
             
                String strNavigationStatusPageName = pepUtilityClass.getNavigationPageName('pepExpensePage');
                objModelContainer.objApplication.pepNavigation_Status__c = strNavigationStatusPageName;
                
                if(objModelContainer.objApplication.pepCurrent_Page__c != null && objModelContainer.objApplication.pepCurrent_Page__c < 3)
                {
                    objModelContainer.objApplication.pepCurrent_Page__c = 3;
                }
                
                mapChildObjects.PUT('income__c', listIncome);
                genesis__Applications__c result = pepInvokeCLMethodHelper.updateApplication(objModelContainer.objApplication,mapRelatedObjects,mapChildObjects);
                string redircetPageName= pages_config__c.getinstance('pepexpensepage').Page_Label__c;
                PageReference p=new PageReference('/'+redircetPageName);
                Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
                cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
                p.setCookies(new Cookie[]{cookieApplicationId2 });
                p.setRedirect(true);
                return p;
       }
        catch(Exception ex)
        {
           return peputilityclass.handlePageException(ex);
        } 
    }
    //This method gets called when the person moves from one page to another using tabs functionality.
    public PageReference saveCallFromHeader() {
    //  Added by Rishabh Tyagi
     try
       {
            set<id> setTemp=new set<id>();
            list<Income__c> tempIncomes = new List<Income__c>();
            if(lstIncomeDelete.size()>0) 
            {
                for(Income__c inc:lstIncomeDelete){
                if(inc.id != null)
                tempIncomes.add(inc);
                }
                if(tempIncomes != null && tempIncomes.size()>0)
                	pepUtilityClass.safeDelete(tempIncomes, 'Income__c');
            }
             if(ReturnValue!=null && ReturnValue!='')
                 objModelContainer.objApplication.IP_Address__c =  ReturnValue;
                 objModelContainer.objApplication.pepNavigation_Status__c=pepUtilityClass.returnPageName(pagetoredirect);   
                 objModelContainer.SaveInputValuesToFields();
         
            Map<String,List<SObject>> mapChildObjects = new Map<String,List<SObject>>();
            Map<String,SObject> mapRelatedObjects = new Map<String,SObject>();
            List<income__c> listIncome=new List<income__c>();
            List<income__c> updateListIncome=new List<income__c>();
            if(objModelContainer.lstIncome!=null)
            {
            for(income__c inc: objModelContainer.lstIncome)
            {
                  inc.Income_agreement_time_stamp__c = dateTime.Now();
                  inc.id=null;
                 if(inc.Other_Income__c=='No')
                 {
                     listIncome.add(inc);
                     break;
                 }
                 else{
                      listIncome.add(inc);   
                 }
            }
            if(listIncome.size()>0)
            {
                for(integer i=0;i<=listIncome.size()-1;i++)
                  {
                      if(i==listIncome.size()-1)
                         listIncome[i].Next_Income_Added__c ='';
                      updateListIncome.add(listIncome[i]);
                  }
            }
         }
       
          
            mapChildObjects.PUT('income__c', updateListIncome);
            
            genesis__Applications__c result = pepInvokeCLMethodHelper.updateApplication(objModelContainer.objApplication,mapRelatedObjects,mapChildObjects);
            
            
            Cookie myCookies=new Cookie('ApplicationId','',null,-1,false);
            cookie cookieApplicationId2 = new Cookie('ApplicationId',pepEncryptDecryptData.EncryptData(String.valueof(idApplication)),null,-1,false);
            
            if(pagetoredirect=='1'){
            string redircetPageName= pages_config__c.getinstance('peploandetails').Page_Label__c;
            PageReference per=new PageReference('/'+redircetPageName);
             per.setCookies(new Cookie[]{cookieApplicationId2 });
             return per;
             }
            else if(pagetoredirect=='2'){
             return null;
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
          return peputilityclass.handlePageException(ex);
        }
        
    }
    //This method  is called during the load of the Pepincomepage
    public pageReference onLoading()
    {
        //  Added by Rishabh Tyagi
      try{
            Pagereference pr=Peputilityclass.checkCookieAndRedirect();
            if(pr==null){
             
            objModelContainer=getpopulateValues();
             Pagereference temp=Peputilityclass.HandleRedirectSecurity();
             return temp;
           
            }
            else
            return pr;
         }
        catch(Exception ex)
        {
            return peputilityclass.handlePageException(ex);
        }
    }
    //This method is to bind the Values from  the database back to the income page upon load of the pepincomePage. 
    public pepCMSModelContainer_New getpopulateValues(){
        
       
        Cookie cookieApplicationId= ApexPages.currentPage().getCookies().get('ApplicationId');
        if(cookieApplicationId!=null && cookieApplicationId.getValue()!=null && cookieApplicationId.getValue()!='')
        {            
            idApplication=pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId.getValue()));
        
            String[] lstTypes = new String[]{'genesis__Applications__c','Income__c'};
            String FieldSetName='pepIncomePage';
            list<genesis__Applications__c> lstApplication=pepUtilityClass.fetchApplicationAndChild(lstTypes,FieldSetName,null,idApplication,null);
            objModelContainer.objApplication=lstApplication.get(0);
            if(lstApplication.get(0).incomes__r!=null && lstApplication.get(0).incomes__r.size()>0)
            {                
                //sorting of income
                Map<Decimal,income__c> mapIncome=new Map<Decimal,income__c>(); 
                for(income__c inc:lstApplication.get(0).incomes__r)
                {
                    mapIncome.put(inc.Sequence__c,inc);    
                }
                List<Decimal> lstTemp=new List<Decimal>();
                List<Income__c> lstIncomeToDisplay=new List<Income__c>();
                lstTemp.addAll(mapIncome.keyset());
                lstTemp.sort();
                for(Decimal i:lstTemp)
                {
                    lstIncomeToDisplay.add(mapIncome.get(i));
                }
                
            
                objModelContainer.lstIncome=new list<Income__c>();
                objModelContainer.lstIncome.addAll(lstIncomeToDisplay);
           
                lstIncomeDelete=new List<income__c>();
                lstIncomeDelete.addAll(lstIncomeToDisplay);
           
                objModelContainer.strPageName='Income Details';                 
         
                
                
            }
        }
        return objModelContainer;
    }
    
    
}