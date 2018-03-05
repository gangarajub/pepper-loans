public class GenerateBorrowerStatementInBulk implements Schedulable,Database.Batchable<sobject>,Database.stateful,Database.AllowsCallouts  {

    private Integer batchSize = 500;

    private static String NAME = 'Generate Borrower Statement';
    
    //public static String  sessionId = '';
    String query;
    public GenerateBorrowerStatementInBulk() {
        
    }
    
    public GenerateBorrowerStatementInBulk(String query){
        this.query = query;
    }
    
    public void execute(SchedulableContext sc) {
        GenerateBorrowerStatementInBulk j = new GenerateBorrowerStatementInBulk();
        Database.executeBatch(j, 1);
    }
    
    public Database.queryLocator Start(Database.BatchableContext bc) {
        loan.GlobalLoanUtilFacade loanUtil;
        Date systemDate;
        Date lastoneMonth;
        if(String.isBlank(query)){
            loanUtil = new loan.GlobalLoanUtilFacade();
            systemDate = loanUtil.getCurrentSystemDate();
            //sessionId = UserInfo.getSessionId();
            lastoneMonth=systemDate -31;
            String allowabledLoanStatuses = '\'' + loan.LoanConstants.LOAN_STATUS_ACTIVE_GOOD_STANDING + '\'' + ',' +
                                            '\''+ loan.LoanConstants.LOAN_STATUSACTIVE_BAD_STANDING + '\'' + ',' +
                                            '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_OBLIGATIONS_MET + '\'' + ',' +
                                            '\''+ loan.LoanConstants.LOAN_STATUS_CLOSED_WRITTEN_OFF + '\'' + ',' +
                                            '\''+ loan.LoanConstants.LOAN_STATUS_ACTIVE_MATURED + '\'';
            query = 'select id,name,SPV__c,loan__Account__c,loan__Contact__c from loan__Loan_Account__c' +
                    ' WHERE loan__Loan_Status__c ' +
                    'IN (' + allowabledLoanStatuses + ')  and loan__Last_Transaction_Timestamp__c>=:lastoneMonth';
        }
        
        system.debug(query);
        return Database.getQueryLocator(query);
    } // do nothing
    
    public  void Execute(Database.BatchableContext bc, List<sObject> scope) {
        
        try {
            BorrowersStatement__c  bSt = BorrowersStatement__c.getInstance();
            
            String LOGIN_DOMAIN = 'test'; //other options: test, prerellogin.pre
            if(bSt.Login_Domain__c!=null){
                LOGIN_DOMAIN = bSt.Login_Domain__c;
            }
            
            String USERNAME  = 'manuj@cloudlendinginc.com.au.uat';
            if(bSt.username__c!=null){
                USERNAME = bSt.username__c;
            }
            String PASSWORD  = 'qwert@1234LlHid0NWXPRAdE8iIGhegfzrF';
            
            if(bSt.Password__c!=null){
                PASSWORD= bSt.Password__c;
            }
            
            //----------------------------------------------------------------------
            // Login via SOAP/XML web service api to establish session
            //----------------------------------------------------------------------
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://' + LOGIN_DOMAIN + '.salesforce.com/services/Soap/u/22.0');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            request.setHeader('SOAPAction', 'login');
            //not escaping username and password because we're setting those variables above
            //in other words, this line "trusts" the lines above
            //if username and password were sourced elsewhere, they'd need to be escaped below
            request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + USERNAME + '</username><password>' + PASSWORD + '</password></login></Body></Envelope>');
            Dom.XmlNode resultElmt ;
            if(!Test.isRunningTest()){
              resultElmt  = (new Http()).send(request).getBodyDocument().getRootElement().getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('loginResponse','urn:partner.soap.sforce.com').getChildElement('result','urn:partner.soap.sforce.com');
            }
            
              
              
           
            //----------------------------------------------------------------------
            // Grab session id and server url (ie the session)
            //----------------------------------------------------------------------
            final String SERVER_URL;
            final String SESSION_ID;
            if(!Test.isRunningTest()){
                 SERVER_URL = resultElmt.getChildElement('serverUrl','urn:partner.soap.sforce.com').getText().split('/services')[0];
                 SESSION_ID = resultElmt.getChildElement('sessionId','urn:partner.soap.sforce.com').getText();
            }else{
                SERVER_URL='https://cs31.salesforce.com';
                SESSION_ID='00Dp00000000oT7!AQEAQMk5p7sqw0_TY2JApGVGoIsRLNhpzpW6.OdV0KNY_tTGYjBqKU4B7QkMhDr039m2Z0ny4S9fXHzXUwLuHYd0GNn9gRAl';
            } 
            List<loop__DDP__c> ddp = [select id,Name from Loop__DDP__c where Name = 'Loan Account Statement'];
            String ddpId = '';
            String deliveryId = '';
            if(ddp!=null && ddp.size()>0){
                ddpId = ddp[0].id;
                List<Loop__DDP_Integration_Option__c> deliveryIds= [select id , name from Loop__DDP_Integration_Option__c where Name = 'Attach' and Loop__DDP__c =:ddpId];
                if(deliveryIds.size()>0){
                    deliveryId = deliveryids[0].id;
                }
            }
            PepperEmailTemplates__c pepCustomTemplate = PepperEmailTemplates__c.getInstance();
            String statement = pepCustomTemplate.Borrower_Statement__c;
            If(!String.isblank(ddpId) && !String.isBlank(deliveryId)){
                generateDDP(deliveryId,ddpId,scope[0].id,SESSION_ID);
                loan__Loan_Account__C lc = (loan__Loan_Account__c)scope[0];
                System.debug('lc='+lc.loan__contact__C);
                Contact c = [select id from contact where id=:lc.loan__contact__C];
                if(!bSt.Disable_Email__c){
                    EmailUtil.sendEmailByTemplate(c,scope[0].id,statement);
                }
            }
          
        } catch (Exception e) {
            throw e;
        }
    }
    
    public void Finish(Database.BatchableContext bc) {
        
    }
    public static void generateDDP(String deployId,String templateId,String loanAccId, String sessionId){
        Map<string, string> variables = new Map<string,string>();
        variables = new Map<string, string> { 'deploy' => deployId };
        Loop.loopMessage lm = new Loop.loopMessage();
        lm.sessionId=sessionId;
        lm.requests.add(new Loop.loopMessage.loopMessageRequest(loanAccId,templateId,variables));
        lm.sendAllRequests();
    }

}