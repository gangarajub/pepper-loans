//  ------------------------------------------------------------------------------------------------------------------------------
//  This class is created to handle view all functionality for the left component objects
//  ------------------------------------------------------------------------------------------------------------------------------
//  Created Date : 12-July-2016         Created By: Pawan Mudgal              Email: pawan.mudgal@saasfocus.com
//  ------------------------------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestViewAllLeftController
//  ------------------------------------------------------------------------------------------------------------------------------
public class ScCollection_ViewAllLeftController
{
    public String strContractId {get;set;}
    public Boolean showPtp {get;set;}
    public transient List<collect__Promise_To_Pay__c> lstOldPtp {get;set;}
    public transient List<collect__Promise_To_Pay__c> lstNewPtp {get;set;}
    
    private static final String VAR_PTP = 'PTP';
    
    public ScCollection_ViewAllLeftController()
    {
        showPtp = false;
        
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id'))) 
        {
            strContractId = ApexPages.currentPage().getParameters().get('Id');
            
            if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('display')))
            {
                if(ApexPages.currentPage().getParameters().get('display') == VAR_PTP)
                {
                    //call method to retrive records from PTP object
                    RetrivePtpData();
                    showPtp = true;
                }
            }
        }
    }

    // Method to retrive records of PTP for the contract for which user called for 
    public void RetrivePtpData()
    {
        lstOldPtp = [select Id, 
                            Name, 
                            collect__Promise_To_Pay_Date__c, 
                            collect__Promise_To_Pay_Amount__c, 
                            collect__Promise_Kept__c, 
                            collect__Promise_Broken__c, 
                            collect__Promise_Made_On__c,
                            ScCollection_PTP_AutoNumberFormula__c,
                            ScCollection_Payment_Method__c 
                            from collect__Promise_To_Pay__c 
                            where collect__Promise_To_Pay_Date__c < TODAY AND
                            (collect__Dev_Contract__c =: strContractId OR ScCollection_CL_Contract__c =: strContractId)
                            ORDER BY collect__Promise_To_Pay_Date__c DESC limit 50000];

        lstNewPtp = [select Id, 
                            Name, 
                            collect__Promise_To_Pay_Date__c, 
                            collect__Promise_To_Pay_Amount__c, 
                            collect__Promise_Kept__c, 
                            collect__Promise_Broken__c, 
                            collect__Promise_Made_On__c,
                            ScCollection_PTP_AutoNumberFormula__c,
                            ScCollection_Payment_Method__c 
                            from collect__Promise_To_Pay__c 
                            where collect__Promise_To_Pay_Date__c >= TODAY AND
                            (collect__Dev_Contract__c =: strContractId OR ScCollection_CL_Contract__c =: strContractId)
                            ORDER BY collect__Promise_To_Pay_Date__c ASC limit 50000];
    }
}