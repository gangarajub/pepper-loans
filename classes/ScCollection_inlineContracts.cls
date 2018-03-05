// ----------------------------------------------------------------------------------------------------
// This class would be used to handle all functionality for displaying related contracts in inline page layout of account and contact
// ----------------------------------------------------------------------------------------------------
// Created Date: 10-JUN-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestinlineContracts
// ----------------------------------------------------------------------------------------------------
public class ScCollection_inlineContracts 
{
    public String idOfObject;
    public String ObjectType;
    public Account objAcc;
    public Contact objCon;
    public wrapper objWrapp {get;set;}
    
    public Set<Id> setClIds;
    public List<loan__Loan_Account__c> personalContracts;
    public List<collect__Loan_Account__c> clContracts;
    
    public ScCollection_inlineContracts(ApexPages.StandardController controller) 
    {
        idOfObject = '';
        ObjectType = '';
        setClIds = new Set<Id>();
        personalContracts = new List<loan__Loan_Account__c>();
        clContracts = new List<collect__Loan_Account__c>();
        
        idOfObject = Apexpages.currentpage().getparameters().get('id');
        
        // check the object type
        If(String.isNotEmpty(idOfObject))
        {
            ObjectType = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(idOfObject);
            
            if(String.isNotEmpty(ObjectType) && ObjectType == 'Account')
            {
                objAcc = new Account();
                
                for(clcommon__Party__c obj : [select collect__CL_Contract__c from clcommon__Party__c where ScCollection_Active__c = true AND clcommon__Account__c =: idOfObject])
                {
                    if(obj.collect__CL_Contract__c != Null)
                    {
                        setClIds.add(obj.collect__CL_Contract__c);
                    }
                }
                
                if(!Test.isRunningTest())
                {
                    controller.addfields(new String[]{'name'});
                }
                
                objAcc = (Account)controller.getRecord();
                
                //look for related personal contracts
                personalContracts = [select Id,
                                            Name,
                                            loan__Loan_Amount__c,
                                            loan__Loan_Product_Name__r.Name,
                                            loan__Loan_Status__c 
                                            from loan__Loan_Account__c 
                                            where loan__Account__c =: idOfObject];
                
                clContracts = [select Id,
                                      Name,
                                      collect__Delinquent_Amount__c,
                                      collect__Loan_Status__c,
                                      collect__Loan_Product_Name__c 
                                      from collect__Loan_Account__c 
                                      where Id IN : setClIds];
                
                //initialize the wrapper
                objWrapp = new wrapper(objAcc,new Contact(),personalContracts,clContracts);
            }
            else if(ObjectType == 'Contact')
            {
                objCon = new Contact();
                
                for(clcommon__Party__c obj : [select collect__CL_Contract__c from clcommon__Party__c where ScCollection_Active__c = true AND clcommon__Contact__c =: idOfObject])
                {
                    if(obj.collect__CL_Contract__c != Null)
                    {
                        setClIds.add(obj.collect__CL_Contract__c);
                    }
                }
                
                if(!Test.isRunningTest())
                {
                    controller.addfields(new String[]{'name'});
                }
                
                objCon = (Contact)controller.getRecord();
                
                //look for related personal contracts
                personalContracts = [select Id,
                                            Name,
                                            loan__Loan_Amount__c,
                                            loan__Loan_Product_Name__r.Name,
                                            loan__Loan_Status__c 
                                            from loan__Loan_Account__c 
                                            where loan__Contact__c =: idOfObject];
                                            
                clContracts = [select Id,
                                      Name,
                                      collect__Delinquent_Amount__c,
                                      collect__Loan_Status__c,
                                      collect__Loan_Product_Name__c 
                                      from collect__Loan_Account__c 
                                      where Id IN : setClIds];
                 
                //initialize the wrapper
                objWrapp = new wrapper(new Account(),objCon,personalContracts,clContracts);
            }
        }
    }

    // this wrapper would be used to display data 
    public class wrapper
    {
        public Account Acc {get;set;}
        public Contact Con {get;set;}
        public List<loan__Loan_Account__c> personalLoans {get;set;}
        public list<collect__Loan_Account__c> collectionLoans {get;set;}
        
        public wrapper(Account acc, Contact Con, List<loan__Loan_Account__c> personalLoans, List<collect__Loan_Account__c> collectionLoans)
        {       
            this.Acc = acc;
            this.Con = Con;
            this.personalLoans = personalLoans;
            this.collectionLoans = collectionLoans;
        }    
    }
}