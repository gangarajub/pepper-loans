// --------------------------------------------------------------------------------------------------------
// This class would serve as the controller for the hardship page
// --------------------------------------------------------------------------------------------------------
// Created Date: 18-JUN-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestnewHardshipController
// --------------------------------------------------------------------------------------------------------
public class ScCollection_newHardshipController 
{
    // variable declaraton
    public string contractId;
    public string errorMsg {get;set;}
    public string recordsaved {get;set;}
    public integer PreviousCount {get;set;}
    public boolean hardshipread {get;set;}
    public boolean hardshipedit {get;set;}
    public boolean hardshipdelete {get;set;}
    public boolean hardshipcreate {get;set;}
        
    public ScCollection_Hardship__c objPreviosHardship {get;set;}
    public List<collect__Loan_Account__c> lstContract {get;set;}
    public wrapObjContract objContract {get;set;}
    public ScCollection_Hardship__c objToInsert {get;set;}
    
    // constructor initialization
    public ScCollection_newHardshipController(ApexPages.StandardController controller) 
    {
        errorMsg = '';
        recordsaved = '';
        hardshipread = false;
        hardshipedit = false;
        hardshipdelete = false;
        hardshipcreate = false;
        
        objToInsert = (ScCollection_Hardship__c)controller.getRecord();
        objContract = new wrapObjContract();
        contractId = Apexpages.currentpage().getparameters().get('contractId');
        lstContract = new List<collect__Loan_Account__c>();
        objPreviosHardship = new ScCollection_Hardship__c();
        objPreviosHardship.ScCollection_Hardhsip_Decision__c = Null;
        
        // logic for edit or read of the hardhip add object api name to get the permission
        List<string> lstObjects = new List<string>();
        lstObjects.add('collect__Promise_To_Pay__c');
        lstObjects.add('ScCollection_Recovery__c');
        lstObjects.add('ScCollection_Hardship__c');
        
        // this map should be used to get the reuired objects access
        Map<id,Map<String,Map<String,boolean>>> mapPermissions = new Map<id,Map<String,Map<String,boolean>>>();
        Map<id,List<string>> mapProfileIDToobjectsRequired = new Map<id,List<string>>();
        mapProfileIDToobjectsRequired.put(UserInfo.getProfileId(),lstObjects);
        
        mapPermissions = ScCollection_CommonCodeHandler.getCrudPermissions(mapProfileIDToobjectsRequired);
        
        // set hardhip permissions
        if(mapPermissions.containsKey(UserInfo.getProfileId()))
        {
            // if we have the object
            if(mapPermissions.get(UserInfo.getProfileId()).containskey('ScCollection_Hardship__c'))
            {
                hardshipread = mapPermissions.get(UserInfo.getProfileId()).get('ScCollection_Hardship__c').get('read');
                hardshipedit = mapPermissions.get(UserInfo.getProfileId()).get('ScCollection_Hardship__c').get('edit');  
                hardshipdelete = mapPermissions.get(UserInfo.getProfileId()).get('ScCollection_Hardship__c').get('delete');
                hardshipcreate = mapPermissions.get(UserInfo.getProfileId()).get('ScCollection_Hardship__c').get('create');
            }
        }
        
        if(String.isNotEmpty(contractId))
        {
            //no need as per discussion with kashish
            /*
            // remove the edit rights in case the hardship has been approved or declined
            if(objToInsert.id != Null)
            {
                if(objToInsert.ScCollection_Hardhsip_Decision__c == 'Approved' || objToInsert.ScCollection_Hardhsip_Decision__c == 'Declined')
                {
                    hardshipedit = false ;
                }
            } 
            */
            
            if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'collect__Loan_Account__c')
            {
                lstContract = [select Id,
                                      collect__Amount_to_Current__c,
                                      ScCollection_Current_Principal__c,
                                      collect__Collection_Status__r.ScCollection_Hardship_Requested_Date__c,
                                      ScCollection_Total_Balance__c,
                                      collect__Delinquent_Amount__c,
                                      (select Id,
                                              Name,
                                              ScCollection_Hardhsip_Decision__c,
                                              ScCollection_Hardship_Approval__c,
                                              ScCollection_Hardship_Decline__c 
                                              from Hardship__r order by createddate desc) 
                                      from collect__Loan_Account__c where id =: contractId];
                
                if(lstContract.size() > 0)
                {
                    objContract.Arrears = lstContract[0].collect__Amount_to_Current__c != Null ? lstContract[0].collect__Amount_to_Current__c.setScale(2): 0.00 ;
                    objContract.Balance = lstContract[0].ScCollection_Current_Principal__c != Null ? lstContract[0].ScCollection_Current_Principal__c.setScale(2): 0.00 ;
                    
                    if(objToInsert.ScCollection_Arrears_to_be_capped__c == Null)
                    {
                        objToInsert.ScCollection_Arrears_to_be_capped__c = objContract.Arrears != Null ? objContract.Arrears : 0;
                        objToInsert.ScCollection_HardshipRequestedDate__c = lstContract[0].collect__Collection_Status__r.ScCollection_Hardship_Requested_Date__c!= Null ? lstContract[0].collect__Collection_Status__r.ScCollection_Hardship_Requested_Date__c: Null ;
                    }
                    
                    if(lstContract[0].Hardship__r.size() > 0)
                    {
                        objPreviosHardship = lstContract[0].Hardship__r[0];
                        PreviousCount = lstContract[0].Hardship__r.size();
                    }
                    else 
                    {
                        PreviousCount = 0;
                    }
                }
            }
            else if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'loan__Loan_Account__c')
            {
                List<Loan__Loan_Account__c> lstPLContract = new List<Loan__Loan_Account__c>();
                lstPLContract = [select loan__Principal_Remaining__c,
                                        loan__Interest_Accrued_Not_Due__c,
                                        loan__Amount_to_Current__c,
                                        (select Id,
                                                Name,
                                                ScCollection_Hardhsip_Decision__c,
                                                ScCollection_Hardship_Approval__c,
                                                ScCollection_Hardship_Decline__c 
                                                from Hardship__r Order By CreatedDate desc)
                                        from Loan__Loan_Account__c where Id =: contractId];
                
                if(lstPLContract.size() > 0)
                {
                    objContract.Arrears = lstPLContract[0].loan__Amount_to_Current__c == Null ? 0.00 :lstPLContract[0].loan__Amount_to_Current__c.setScale(2); 
                    objContract.Balance = (lstPLContract[0].loan__Principal_Remaining__c == Null ? 0.00 :lstPLContract[0].loan__Principal_Remaining__c.setScale(2)) + (lstPLContract[0].loan__Interest_Accrued_Not_Due__c == Null ? 0.00 :lstPLContract[0].loan__Interest_Accrued_Not_Due__c.setScale(2));
                    
                    if(lstPLContract[0].Hardship__r.size() > 0)
                    {
                        objPreviosHardship = lstPLContract[0].Hardship__r[0];
                        PreviousCount = lstPLContract[0].Hardship__r.size();
                    }
                    else
                    {
                        PreviousCount = 0;
                    }
                }                                                                        
            }
        }
    }
    
    public pagereference cancelCustom()
    {
        String pgref = '/apex/ScCollection_newHardhip?contractid=' + contractId + '&id=' + objToInsert.id + '&view=edit';
        pagereference pageref = new pagereference(pgref);
        pageref.setredirect(true);
        return pageref;
    }
    
    public pagereference insertHardship()
    {
        if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'collect__Loan_Account__c')
        {
            objToInsert.ScCollection_Contract__c = contractId;
        }
        else if(ScCollection_CommonCodeHandler.retriveSalesforceObjectType(contractId) == 'loan__Loan_Account__c')
        {
            objToInsert.scCollection_Loan_Account__c = contractId;
        }
        
        try
        {
            recordsaved = 'Recordsaved';
            upsert objToInsert;
        }
        catch(Exception e)
        {
            recordsaved = '';
            errorMsg = e.getMessage();
        }
        
        String pgref = '/apex/ScCollection_newHardhip?contractid=' + contractId + '&id=' + objToInsert.id + '&view=view&recsaved=' + recordsaved;
        PageReference pageref = new PageReference(pgref);
        pageref.setredirect(true);
        return pageref;
    }
    
    public class wrapObjContract
    {
        public decimal Arrears {get;set;}
        public decimal Balance {get;set;}
    }
}