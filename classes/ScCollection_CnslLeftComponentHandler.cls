// --------------------------------------------------------------------------------------------------------
// This class handles the logic for the custom vf pages on console left component view for pepper collections
// --------------------------------------------------------------------------------------------------------
// Created Date: 18-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// --------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestCnslLeftComponentHand
// --------------------------------------------------------------------------------------------------------
public class ScCollection_CnslLeftComponentHandler 
{
    //variable declaration for the data to be populated on left components
    public String strCollateralIndex {get;set;}
    public String strRecoveryIndex {get;set;}
    public String strHardshipIndex {get;set;}
    public String strCollateralRecordType {get;set;}
    public String strRecoveryRecordType {get;set;}
    public String strCollateralPrefix {get;set;}
    public String strRecoveryPrefix {get;set;}
    
    public collect__Contract_Status__c objStatus {get;set;}
    public List<collect__Promise_To_Pay__c> lstPtp {get;set;}
    public List<Property_Surrogate__c> lstCollateral {get;set;}
    public List<scCollection_Recovery__c> lstRecovery {get;set;}
    public List<ScCollection_Hardship__c> lstHardship {get;set;}
        
    // variables for profile permission created by deepak dhingra
    public Boolean p2pRead {get;set;}
    public Boolean p2pDelete {get;set;}
    public Boolean p2pCreate {get;set;}
    public Boolean collateralRead {get;set;}
    public Boolean collateralDelete {get;set;}
    public Boolean collateralCreate {get;set;}
    public Boolean recoveryRead {get;set;}
    public Boolean recoveryDelete {get;set;}
    public Boolean recoveryCreate {get;set;}
    public Boolean hardshipRead {get;set;}
    public Boolean hardshipEdit {get;set;}
    public Boolean hardshipDelete {get;set;}
    public Boolean hardshipCreate {get;set;}
    
    //variables to hold data for the current contract record
    public String strContractId {get;set;}
    public String strContractName {get;set;}
    public String strSourceSystem {get;set;}
    public String strObjectName = '';
    
    private static final String VAR_PTP_API = 'collect__Promise_To_Pay__c';
    private static final String VAR_COLLATERAL_API = 'Property__c';
    private static final String VAR_RECOVERY_API = 'ScCollection_Recovery__c';
    private static final String VAR_HARDSHIP_API = 'ScCollection_Hardship__c';
    private static final String VAR_PLCONTRACT_API = 'loan__Loan_Account__c';
    private static final String VAR_CLCONTRACT_API = 'collect__Loan_Account__c';
    public Map<Id,SObject> mapObjectData = new Map<Id,SObject>();
    
    //initialise cls collect api to be used in class
    collect.API api = collect.APIFactory.getAPI();
    
    //constructor for variable initialization
    public ScCollection_CnslLeftComponentHandler()
    {
        //variable initialization for the data to be populated on left and right console component
        strCollateralIndex = '';
        strRecoveryIndex = '';
        strHardshipIndex = '';
        strCollateralRecordType = '';
        strRecoveryRecordType = '';
        strCollateralPrefix = ScCollection_CommonCodeHandler.retriveSalesforceObjectPrefix(VAR_COLLATERAL_API); 
        strRecoveryPrefix = ScCollection_CommonCodeHandler.retriveSalesforceObjectPrefix(VAR_RECOVERY_API);
        
        strContractId = '';
        strContractName = '';
        strSourceSystem = '';
        
        p2pRead = false;
        p2pDelete = false;
        p2pCreate = false;
        collateralRead = false;
        collateralDelete = false;
        collateralCreate = false;
        recoveryRead = false;
        recoveryDelete = false;
        recoveryCreate = false;
        hardshipRead = false;
        hardshipEdit = false;
        hardshipDelete = false;
        hardshipCreate = false;
        
        // add object api name to get the permission
        List<String> lstObjects = new List<String>();
        lstObjects.add(VAR_PTP_API);
        lstObjects.add(VAR_COLLATERAL_API);
        lstObjects.add(VAR_RECOVERY_API);
        lstObjects.add(VAR_HARDSHIP_API);
        
        // this map should be used to get the reuired objects access
        Map<Id,Map<String,Map<String,boolean>>> mapPermissions = new Map<Id,Map<String,Map<String,boolean>>>();
        Map<Id,List<String>> mapProfileIdToObjectsRequired = new Map<Id,List<String>>();
        mapProfileIdToObjectsRequired.put(UserInfo.getProfileId(),lstObjects);
        
        mapPermissions = ScCollection_CommonCodeHandler.getCrudPermissions(mapProfileIdToObjectsRequired);
        
        //set object permissions
        if(mapPermissions.containsKey(UserInfo.getProfileId()))
        {
            if(mapPermissions.get(UserInfo.getProfileId()).containskey(VAR_PTP_API))
            {
                p2pRead = mapPermissions.get(UserInfo.getProfileId()).get(VAR_PTP_API).get('read');
                p2pDelete = mapPermissions.get(UserInfo.getProfileId()).get(VAR_PTP_API).get('delete');
                p2pCreate = mapPermissions.get(UserInfo.getProfileId()).get(VAR_PTP_API).get('create');
            }
            if(mapPermissions.get(UserInfo.getProfileId()).containskey(VAR_COLLATERAL_API))
            {
                collateralRead = mapPermissions.get(UserInfo.getProfileId()).get(VAR_COLLATERAL_API).get('read');
                collateralDelete = mapPermissions.get(UserInfo.getProfileId()).get(VAR_COLLATERAL_API).get('delete');
                collateralCreate = mapPermissions.get(UserInfo.getProfileId()).get(VAR_COLLATERAL_API).get('create');
            }
            if(mapPermissions.get(UserInfo.getProfileId()).containskey(VAR_RECOVERY_API))
            {
                recoveryRead = mapPermissions.get(UserInfo.getProfileId()).get(VAR_RECOVERY_API).get('read');
                recoveryDelete = mapPermissions.get(UserInfo.getProfileId()).get(VAR_RECOVERY_API).get('delete');
                recoveryCreate = mapPermissions.get(UserInfo.getProfileId()).get(VAR_RECOVERY_API).get('create');
            }
            if(mapPermissions.get(UserInfo.getProfileId()).containskey(VAR_HARDSHIP_API))
            {
                hardshipRead = mapPermissions.get(UserInfo.getProfileId()).get(VAR_HARDSHIP_API).get('read');
                hardshipEdit = mapPermissions.get(UserInfo.getProfileId()).get(VAR_HARDSHIP_API).get('edit');  
                hardshipDelete = mapPermissions.get(UserInfo.getProfileId()).get(VAR_HARDSHIP_API).get('delete');
                hardshipCreate = mapPermissions.get(UserInfo.getProfileId()).get(VAR_HARDSHIP_API).get('create');
            }
        }
        
        lstPtp = new List<collect__Promise_To_Pay__c>();
        lstCollateral = new List<Property_Surrogate__c>();
        lstRecovery = new List<scCollection_Recovery__c>();
        lstHardship = new List<ScCollection_Hardship__c>();
        
        //get the Id from url parameter
        if(ScCollection_UtilityHandler.isNotNull(ApexPages.currentPage().getParameters().get('id')))
        {
            strContractId = ApexPages.currentPage().getParameters().get('id');
            
            //call common method to retrieve object name
            strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strContractId);
            
            Set<Id> setcontractid = new Set<Id>();
            setcontractid.add(strContractId);
            
            //call api method of cls to get current open contract record
            mapObjectData = api.getContracts(setcontractid);
            
            objStatus = ScCollection_CommonCodeHandler.retriveContractStatusData(strContractId);
            
            if(strObjectName == VAR_PLCONTRACT_API)
            {
                strSourceSystem = 'CL Loan';
            }
            else if(strObjectName == VAR_CLCONTRACT_API)
            {
                try
                {
                    collect__Loan_Account__c objcnt = (collect__Loan_Account__c)mapObjectData.get(strContractId); 
                    
                    if(objcnt != Null && objcnt.collect__Source_System__c != Null)
                    {
                        strSourceSystem = [select Id, Name from collect__Source_System__c where Id =: objcnt.collect__Source_System__c].Name;
                    }
                }
                catch(Exception e)
                {
                    system.debug(e.getMessage());
                }
            }
                
            List<RecordType> lstrecordtype = new List<RecordType>();
            set<string> setdevelopername = new set<string>();
            setdevelopername.add('PAF_Property');
            setdevelopername.add('Mortgage_Property');
            setdevelopername.add('ScCollection_PAF_Recovery');
            setdevelopername.add('ScCollection_Mortgage_Recovery');
            
            lstrecordtype = [select Id, DeveloperName from RecordType where DeveloperName In : setdevelopername];
                
            if(lstrecordtype != Null && lstrecordtype.size() > 0)
            {
                for(Recordtype rectype : lstrecordtype)
                {
                    if(strSourceSystem == 'PAF' && rectype.DeveloperName == 'PAF_Property')
                    {
                        strCollateralRecordType = rectype.id;
                    }
                    else if(strSourceSystem == 'MORTGAGE' && rectype.DeveloperName == 'Mortgage_Property')
                    {
                        strCollateralRecordType = rectype.id;
                    }
                    else if(strSourceSystem == 'PAF' && rectype.DeveloperName == 'ScCollection_PAF_Recovery')
                    {
                        strRecoveryRecordType = rectype.id;
                    }
                    else if(strSourceSystem == 'MORTGAGE' && rectype.DeveloperName == 'ScCollection_Mortgage_Recovery')
                    {
                        strRecoveryRecordType = rectype.id;
                    }
                }
            }
        }
        
        //call methods to populate data on vf pages
        ProcessDataForLeftComponent();
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the data process for console left components
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void ProcessDataForLeftComponent()
    {
        if(ScCollection_UtilityHandler.isNotNull(strObjectName))
        {
            if(strObjectName == VAR_PLCONTRACT_API)
            {
                loan__Loan_Account__c objplcontract = (loan__Loan_Account__c)mapObjectData.get(strContractId);
                
                strContractName = objplcontract != Null ? objplcontract.Name : '';
            }
            else if(strObjectName == VAR_CLCONTRACT_API)
            {
                collect__Loan_Account__c objclcontract = (collect__Loan_Account__c)mapObjectData.get(strContractId);          
                
                strContractName = objclcontract != Null ? objclcontract.Name : '';
                
                lstCollateral = [select Id, 
                                        Property__c,
                                        Property__r.Name,
                                        Property__r.RecordTypeId,
                                        Property__r.RecordType.DeveloperName,
                                        Property__r.Asset_Make_Description__c,
                                        Property__r.Asset_Model_Description__c,
                                        Property__r.Vehicle_Registration_Number__c,
                                        Property__r.Property_Unit_House_Number__c, 
                                        Property__r.Property_Street__c, 
                                        Property__r.Property_Suburb_Town__c, 
                                        Property__r.Property_State__c, 
                                        Property__r.Property_PostCode__c,
                                        Property__r.Property_Type__c,
                                        Property__r.OccupancyType__c,
                                        Property__r.Property_Address__c
                                        from Property_Surrogate__c
                                        where Loan_Surrogate__c =: strContractId limit 50000];
                                       
                lstRecovery = [select Id,
                                      Name,
                                      RecordTypeId,
                                      RecordType.DeveloperName,
                                      ScCollection_Solicitor_Appointed__c,
                                      ScCollection_Valuation_Amount__c,
                                      ScCollection_Judgement_Obtained__c,
                                      ScCollection_Provision_Amount__c,
                                      ScCollection_Agent_Appointed__c,
                                      ScCollection_Date_Appointed__c,
                                      ScCollection_Auction_House__c,
                                      ScCollection_Form_14_Issue_Date__c,
                                      ScCollection_Form_14_Expiry_Date__c
                                      from ScCollection_Recovery__c
                                      where ScCollection_Contract__c =: strContractId limit 50000];     
            }
            
            lstPtp = [select Id, 
                             Name, 
                             collect__Promise_To_Pay_Date__c, 
                             collect__Promise_To_Pay_Amount__c, 
                             collect__Promise_Made_On__c, 
                             collect__Promise_Kept__c, 
                             collect__Promise_Broken__c, 
                             ScCollection_Payment_Method__c,
                             ScCollection_PTP_AutoNumber__c,
                             ScCollection_PTP_AutoNumberFormula__c
                             from collect__Promise_To_Pay__c 
                             where collect__Promise_To_Pay_Date__c >= TODAY AND 
                             (collect__Dev_Contract__c =: strContractId OR ScCollection_CL_Contract__c =: strContractId) 
                             ORDER BY collect__Promise_To_Pay_Date__c ASC limit 50000];
                    
            lstHardship = [select Id, 
                                  Name, 
                                  ScCollection_Reason_for_Hardship__c, 
                                  ScCollection_HardshipRequestedDate__c, 
                                  ScCollection_Hardship_Approval_Date__c, 
                                  ScCollection_Hardship_Decline_Date__c, 
                                  ScCollection_Hardhsip_Decision__c 
                                  from ScCollection_Hardship__c 
                                  where (ScCollection_Contract__c =: strContractId OR scCollection_Loan_Account__c =: strContractId) 
                                  ORDER BY ScCollection_HardshipRequestedDate__c DESC Nulls first limit 50000];
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles deletion of Recovery records on console
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void DeleteCollateral()
    {
        if(strCollateralIndex != '')
        {
            Property_Surrogate__c obj = lstCollateral[Integer.valueof(strCollateralIndex)];
            
            try
            {
                delete obj;
            }
            catch(Exception e)
            {
                system.debug(e.getMessage());
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles deletion of Recovery records on console
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 14-JUN-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void DeleteRecovery()
    {
        if(strRecoveryIndex != '')
        {
            scCollection_Recovery__c obj = lstRecovery[Integer.valueof(strRecoveryIndex)];
            
            try
            {
                delete obj;
            }
            catch(Exception e)
            {
                system.debug(e.getMessage());
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles deletion of hardhsip records on console
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 4-July-2016    Created By: Deepak Dhingra    Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void DeleteHardship()
    {
        if(strHardshipIndex != '')
        {
            ScCollection_Hardship__c obj = lstHardship[Integer.valueof(strHardshipIndex)];
            
            try
            {
                delete obj;
            }
            catch(Exception e)
            {
                system.debug(e.getMessage());
            }
        }
    }
}