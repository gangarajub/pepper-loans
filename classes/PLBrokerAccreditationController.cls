/*------------------------------------------------------------
    Author:        	Sean Jolly
    Name:          	PLBrokerAccreditationController
    Company:       	Pepper
    Description:   	A controller class for PL Broker Accreditation pages - PLBrokerAccreditation and PLBrokerAccreditationInvalid
	Test Class : 	PLBrokerAccreditationControllerTest
    History
    20171113     	Sean Jolly     Class Created
    ------------------------------------------------------------*/

public class PLBrokerAccreditationController{  
    
    //calculate expiry date => links older than now minus number of hours (stored in custom label) are invalid
    private Integer expiryHours = integer.valueof(System.Label.PL_Accreditation_Code_Expiry_Hours);
    private Datetime nowGMT = Datetime.now();
    private Integer offset = UserInfo.getTimezone().getOffset(nowGMT);
    private Datetime local = nowGMT.addSeconds(offset/1000);    
    private Datetime expiryDate = local.addHours(expiryHours * -1);
    public Boolean refreshPage {get; set;}
    
    public PL_Broker_Accreditation__c Broker{get;set;}
    
    public PLBrokerAccreditationController(ApexPages.StandardController sc) {
    }

        /*------------------------------------------------------------
        Author:        Sean Jolly
        Name:          SaveBrokers
        Company:       Pepper
        Description:   Method to update broker details when submit button clicked on VF page
        Inputs:        None
        Returns:       PageReference to redirect to.
        History
        20171113     	Sean Jolly     Method Created
        ------------------------------------------------------------*/  
    
    public PageReference SaveBrokers() {
        
        Broker.Opt_In__c = True;
        //update details
        update Broker;
        //redirect to Thank You page
        PageReference pageRef = new PageReference('/apex/PLBrokerAccreditationThanks');
        pageRef.setRedirect(true);
        return pageRef;  
    }
    
        /*------------------------------------------------------------
        Author:        Sean Jolly
        Name:          Router
        Company:       Pepper
        Description:   Method determine which VF page is displayed to the broker based on their URL parameters.
        Inputs:        None
        Returns:       PageReference to redirect to.
        History
        20171113     	Sean Jolly     Method Created
        ------------------------------------------------------------*/     
    
    public PageReference Router(){
                   
        //get URL parameters
        id bId = ApexPages.currentPage().getParameters().get('id');
        string p1 = ApexPages.currentPage().getParameters().get('p1');
        
        Broker = [SELECT Aggregator__c,
                        City__c,
                        Country__c,
                        Email__c,
                        Estimated_Submissions_Per_Month__c,
                        First_Name__c,
                        Id,
                        If_so_with_who__c,
                        Last_Name__c,
                        Name,
                        Opt_In__c,
                        Phone__c,
                        Postcode__c,
                        State__c,
                        Street__c,
                        Submitted_PL_Before__c,
                        P1__c,
                        P1_Timestamp__c
                    FROM PL_Broker_Accreditation__c 
                    WHERE Id =:bId];
        
        //URL valid and broker hasn't previously opted in = no redirect
        if (Broker.P1__c == p1 && Broker.P1_Timestamp__c >= expiryDate && Broker.Opt_In__c == false){
            return null;
        }
        //URL expired or P1 Invalid 
        else if (Broker.P1_Timestamp__c < expiryDate || Broker.P1__c <> p1) {
            PageReference pageRef = new PageReference('/apex/PLBrokerAccreditationInvalid'); 
            pageRef.getParameters().put('id',bId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        //Broker Previously Opted in
        else if (Broker.Opt_In__c == true){
            PageReference pageRef = new PageReference('/apex/PLBrokerAccreditationThanks');
            pageRef.setRedirect(true);
            return pageRef;  
        }
        //e.g. bID invalid or unhandled error
        else {
            PageReference pageRef = new PageReference('/apex/PLBrokerAccreditationError'); 
            pageRef.setRedirect(true);
            return pageRef;           
        }
                
    }

        /*------------------------------------------------------------
        Author:        Sean Jolly
        Name:          RequestURL
        Company:       Pepper
        Description:   Sets a new P1 code on the broker accreditation record, 
						which triggers sending them a new email with a new URL.
        Inputs:        None
        Returns:       PageReference to redirect to.
        History
        20171113     	Sean Jolly     Method Created
        ------------------------------------------------------------*/  
    
    public PageReference RequestURL(){
        
            id rId = ApexPages.currentPage().getParameters().get('id');
            PL_Broker_Accreditation__c P1 = [SELECT P1__c FROM PL_Broker_Accreditation__c 
                      WHERE Id =:rId];
            P1.P1__c = GenerateRandomString.generateRandomString(20);
            update P1;  
        
            PageReference pageRef = new PageReference('/apex/PLBrokerAccreditationEmailSent'); 
            pageRef.setRedirect(true);
            return pageRef;          
    }
      
}