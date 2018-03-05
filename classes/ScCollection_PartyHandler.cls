//  -------------------------------------------------------------------------------------------------------
//  This class handles all the trigger events on clcommon__Party__c Object
//  -------------------------------------------------------------------------------------------------------
//  Created Date : 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
//  Revisions:
//  12/12/17: Alex Humby: update to allow ESB User to set the Party Type to whatever is in Source System
//  -------------------------------------------------------------------------------------------------------
//  Test Class : ScCollection_TestPartyHandler
//  -------------------------------------------------------------------------------------------------------
public class ScCollection_PartyHandler 
{
    public Id strBorrowerId;
    public Id strCoBorrowerId;
    public Id strGuarantor;
    public ScCollection_PartyHandler()
    {
        String primary_borrower = 'Primary Borrower';
        String co_borrower = 'Co.Borrower';
        String guarantor = 'Guarantor';
        set<String> setPartyTypeName = new set<String>();
        setPartyTypeName.add(primary_borrower);
        setPartyTypeName.add(co_borrower);
        setPartyTypeName.add(guarantor);
        
        strBorrowerId = Null;
        strCoBorrowerId = Null;
        strGuarantor = Null;
        
        for(clcommon__Party_Type__c objPT : [select Id,Name from clcommon__Party_Type__c where Name in : setPartyTypeName])
        {
            if(objPT.Name == primary_borrower){
                strBorrowerId = objPT.Id;
            }
            else if(objPT.Name == co_borrower){
                strCoBorrowerId = objPT.Id;
            }
            else if(objPT.Name == guarantor){
                strGuarantor = objPT.Id;
            }
                
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after insert events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<clcommon__Party__c> lstNew)
    {
        List<clcommon__Party__c> lstUpdateList = new List<clcommon__Party__c>();
        List<clcommon__Party__c> lstUpdateCSList = new List<clcommon__Party__c>();
        List<clcommon__Party__c> lstUpdateContractList = new List<clcommon__Party__c>();
        
        map<Id,List<clcommon__Party__c>> mapContractStatusIdtoListParty = new map<Id,List<clcommon__Party__c>>();
        set<Id> setContractId = new set<Id>();
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.clcommon__isPrimary__c)
            {
                lstUpdateList.add(obj);
            }
            if(obj.clcommon__Type__c != Null && obj.clcommon__Type__c == strBorrowerId)
            {
                lstUpdateCSList.add(obj);
                
                if(obj.ScCollection_Contract_Source_System__c == 'PAF')
                {
                    lstUpdateContractList.add(obj);
                }
            }
            
            if(obj.clcommon__Type__c != Null && obj.clcommon__Type__c == strGuarantor){
                setContractId.add(obj.collect__CL_Contract__c);
            }
            
            if(obj.ScCollection_Contract_Status_Id__c != null){
                if(mapContractStatusIdtoListParty.get(obj.ScCollection_Contract_Status_Id__c) == null){
                    mapContractStatusIdtoListParty.put(obj.ScCollection_Contract_Status_Id__c,new List<clcommon__Party__c>());
                }
                mapContractStatusIdtoListParty.get(obj.ScCollection_Contract_Status_Id__c).add(obj);
            }
        }
        
        map<Id,Boolean> mapConIdToBoolean = new map<Id,Boolean>();
        if(setContractId != null && setContractId.size()>0){
            List<clcommon__Party__c> lstConStatus = [select id,ScCollection_Contract_Status_Id__c,collect__CL_Contract__c,clcommon__Type__c from clcommon__Party__c where collect__CL_Contract__c in : setContractId and clcommon__Type__c =: strCoBorrowerId];
            
            if(lstConStatus != null && lstConStatus.size()>0){
                for(clcommon__Party__c objParty : lstConStatus){
                    if(objParty.clcommon__Type__c != null && objParty.ScCollection_Contract_Status_Id__c != null && objParty.clcommon__Type__c == strCoBorrowerId){
                        mapConIdToBoolean.put(objParty.collect__CL_Contract__c,true);
                    }
                        
                }
            }
        }
        
        
        if(mapContractStatusIdtoListParty != null && mapContractStatusIdtoListParty.Keyset() != null && mapContractStatusIdtoListParty.keyset().size()>0){
            updateContractStatus(mapContractStatusIdtoListParty,mapConIdToBoolean);
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdateList))
        {
            updateParty(lstUpdateList);
        }
       
        if(ScCollection_UtilityHandler.isNotNull(lstUpdateContractList))
        {
            updateContract(lstUpdateContractList);
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(List<clcommon__Party__c> lstNew, Map<Id,clcommon__Party__c> mapOld)
    {
        List<clcommon__Party__c> lstUpdateList = new List<clcommon__Party__c>();
        List<clcommon__Party__c> lstUpdateCSList = new List<clcommon__Party__c>();
        List<clcommon__Party__c> lstUpdateContractList = new List<clcommon__Party__c>();
        
        map<Id,List<clcommon__Party__c>> mapContractStatusIdtoListParty = new map<Id,List<clcommon__Party__c>>();
        set<Id> setContractId = new set<Id>();
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.clcommon__isPrimary__c && mapOld.get(obj.Id).clcommon__isPrimary__c != true)
            {
                lstUpdateList.add(obj);
            }
            if(obj.clcommon__Type__c != Null && obj.clcommon__Type__c == strBorrowerId && ((mapOld.get(obj.Id).clcommon__Type__c != strBorrowerId) || (obj.clcommon__Account__c != Null && obj.clcommon__Account__c != mapOld.get(obj.Id).clcommon__Account__c) || (obj.clcommon__Contact__c != Null && obj.clcommon__Contact__c != mapOld.get(obj.Id).clcommon__Contact__c) || (obj.collect__CL_Contract__c != Null && obj.collect__CL_Contract__c != mapOld.get(obj.Id).collect__CL_Contract__c)))
            {
                lstUpdateCSList.add(obj);
                
                if(obj.ScCollection_Contract_Source_System__c == 'PAF')
                {
                    lstUpdateContractList.add(obj);
                }
            }
            
            if(obj.clcommon__Type__c != Null && obj.ScCollection_Contract_Status_Id__c != null && ((obj.clcommon__Type__c != mapOld.get(obj.Id).clcommon__Type__c) || 
                (obj.clcommon__Account__c != Null && obj.clcommon__Account__c != mapOld.get(obj.Id).clcommon__Account__c) || 
                (obj.clcommon__Contact__c != Null && obj.clcommon__Contact__c != mapOld.get(obj.Id).clcommon__Contact__c) || 
                (obj.collect__CL_Contract__c != Null && obj.collect__CL_Contract__c != mapOld.get(obj.Id).collect__CL_Contract__c)))
            {
                if(mapContractStatusIdtoListParty.get(obj.ScCollection_Contract_Status_Id__c) == null){
                    mapContractStatusIdtoListParty.put(obj.ScCollection_Contract_Status_Id__c,new List<clcommon__Party__c>());
                }
                mapContractStatusIdtoListParty.get(obj.ScCollection_Contract_Status_Id__c).add(obj);
                
            }
            if(obj.clcommon__Type__c != Null  && obj.clcommon__Type__c == strGuarantor && ((mapOld.get(obj.Id).clcommon__Type__c != strGuarantor) || (obj.clcommon__Account__c != Null && obj.clcommon__Account__c != mapOld.get(obj.Id).clcommon__Account__c) || (obj.clcommon__Contact__c != Null && obj.clcommon__Contact__c != mapOld.get(obj.Id).clcommon__Contact__c) || (obj.collect__CL_Contract__c != Null && obj.collect__CL_Contract__c != mapOld.get(obj.Id).collect__CL_Contract__c)))
            {
                setContractId.add(obj.collect__CL_Contract__c);
                
            }   
            
            
        }
        system.debug(setContractId);
        map<Id,Boolean> mapConIdToBoolean = new map<Id,Boolean>();
        if(setContractId != null && setContractId.size()>0){
            List<clcommon__Party__c> lstConStatus = [select id,ScCollection_Contract_Status_Id__c,collect__CL_Contract__c,clcommon__Type__c from clcommon__Party__c where collect__CL_Contract__c in : setContractId and clcommon__Type__c =: strCoBorrowerId];
            
            if(lstConStatus != null && lstConStatus.size()>0){
                for(clcommon__Party__c objParty : lstConStatus){
                    if(objParty.clcommon__Type__c != null && objParty.ScCollection_Contract_Status_Id__c != null && objParty.clcommon__Type__c == strCoBorrowerId){
                        mapConIdToBoolean.put(objParty.collect__CL_Contract__c,true);
                    }
                        
                }
            }
        }
        /*
        map<Id,collect__Contract_Status__c> mapConIdToConStatus = new map<Id,collect__Contract_Status__c>();
        if(setContractStatusId != null && setContractStatusId.size()>0){
            List<collect__Contract_Status__c> lstConStatus = [select id,ScCollection_Secondary_Account__c,ScCollection_Secondary_Contact__c from collect__Contract_Status__c where id in : setContractStatusId];
            
            if(lstConStatus != null && lstConStatus.size()>0){
                for(collect__Contract_Status__c objConStatus : lstConStatus){
                        mapConIdToConStatus.put(objConStatus.Id,objConStatus);
                }
            }
        }
        */
        if(mapContractStatusIdtoListParty != null && mapContractStatusIdtoListParty.Keyset() != null && mapContractStatusIdtoListParty.keyset().size()>0){
            updateContractStatus(mapContractStatusIdtoListParty,mapConIdToBoolean);
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdateList))
        {
            updateParty(lstUpdateList);
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdateContractList))
        {
            updateContract(lstUpdateContractList);
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before insert events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeInsert(List<clcommon__Party__c> lstNew)
    {

        User usr = [select id,ScCollection_UserType__c from user where id =: UserInfo.getUserId()];

        if(usr.ScCollection_UserType__c != 'ESB User'){
        
            List<clcommon__Party__c> lstUpdateList = new List<clcommon__Party__c>();
            
            for(clcommon__Party__c obj : lstNew)
            {
                if(obj.clcommon__Type__c != Null && obj.clcommon__Type__c == strBorrowerId)
                {
                    lstUpdateList.add(obj);
                }
            }
    
            if(ScCollection_UtilityHandler.isNotNull(lstUpdateList))
            {
                ValidatePartyType(lstUpdateList);
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before update events on party Object
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 20-SEP-2016   Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeUpdate(List<clcommon__Party__c> lstNew, Map<Id,clcommon__Party__c> mapOld)
    {
        User usr = [select id,ScCollection_UserType__c from user where id =: UserInfo.getUserId()];

        if(usr.ScCollection_UserType__c != 'ESB User'){
            List<clcommon__Party__c> lstUpdateList = new List<clcommon__Party__c>();
            
            for(clcommon__Party__c obj : lstNew)
            {
                if(obj.clcommon__Type__c != Null && mapOld.get(obj.Id).clcommon__Type__c != obj.clcommon__Type__c)
                {
                    if(obj.clcommon__Type__c == strBorrowerId)
                    {
                        lstUpdateList.add(obj);
                    }
                }
            }
    
            if(ScCollection_UtilityHandler.isNotNull(lstUpdateList))
            {
                ValidatePartyType(lstUpdateList);
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to update party object
    // ---------------------------------------------------------------------------------------------------
    // created Date : 20-SEP-2016   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void updateParty(List<clcommon__Party__c> lstNew)
    {
        Map<Id,List<clcommon__Party__c>> mapContractToParty = new Map<Id,List<clcommon__Party__c>>();
        Set<Id> setIds = new Set<Id>();
        List<clcommon__Party__c> lstUpdate = new List<clcommon__Party__c>();
        
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.collect__CL_Contract__c != Null)
            {
                setIds.add(obj.collect__CL_Contract__c);
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(setIds))
        {
            for(collect__Loan_Account__c obj : [select Id, (select Id, clcommon__isPrimary__c from collect__Parties__r) from collect__Loan_Account__c where Id IN : setIds])
            {
                if(obj.collect__Parties__r != Null && obj.collect__Parties__r.size() > 0)
                {
                    mapContractToParty.put(obj.Id,obj.collect__Parties__r);
                }
            }
        }
        
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.collect__CL_Contract__c != Null && mapContractToParty.containsKey(obj.collect__CL_Contract__c) && mapContractToParty.get(obj.collect__CL_Contract__c) != Null)
            {
                for(clcommon__Party__c objp : mapContractToParty.get(obj.collect__CL_Contract__c))
                {
                    if(objp.Id != obj.Id && objp.clcommon__isPrimary__c)
                    {
                        objp.clcommon__isPrimary__c = false;
                        lstUpdate.add(objp);
                    }
                }
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdate))
        {
            try
            {
                update lstUpdate;
            }
            catch(Exception e)
            {
                system.debug('Error in updating party : ' + e.getMessage());
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to update bank account on contract object
    // ---------------------------------------------------------------------------------------------------
    // created Date : 20-SEP-2016   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void updateContract(List<clcommon__Party__c> lstNew)
    {
        Map<Id,collect__Bank_Account__c> mapAccountToBank = new Map<Id,collect__Bank_Account__c>();
        Set<Id> setAccountIds = new Set<Id>();
        List<collect__loan_account__c> lstUpdate = new List<collect__loan_account__c>();
        
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.clcommon__Account__c != Null)
            {
                setAccountIds.add(obj.clcommon__Account__c);
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(setAccountIds))
        {
            for(collect__Bank_Account__c obj : [select Id, collect__Account__c, collect__Bank_Account_Number__c from collect__Bank_Account__c where collect__Account__c IN : setAccountIds])
            {
                mapAccountToBank.put(obj.collect__Account__c,obj);
            }
        }
        
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.clcommon__Account__c != Null && mapAccountToBank.containsKey(obj.clcommon__Account__c) && mapAccountToBank.get(obj.clcommon__Account__c) != Null)
            {
                collect__loan_account__c objcontract = new collect__loan_account__c(Id = obj.collect__CL_Contract__c);
                objcontract.ScCollection_Bank_Account__c = mapAccountToBank.get(obj.clcommon__Account__c).Id;
                objcontract.ScCollection_Account_Number__c = mapAccountToBank.get(obj.clcommon__Account__c).collect__Bank_Account_Number__c;
                lstUpdate.add(objcontract);
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(lstUpdate))
        {
            try
            {
                update lstUpdate;
            }
            catch(Exception e)
            {
                system.debug('Error in updating contract record with bank account : ' + e.getMessage());
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to update contract status on contract
    // ---------------------------------------------------------------------------------------------------
    // created Date : 20-SEP-2016   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void updateContractStatus(map<Id,List<clcommon__Party__c>> mapConStatusIdtoLstParty,map<Id,Boolean> mapConIdToBoolean)
    {
        List<collect__Contract_Status__c> lstContractStatusUpdate = new List<collect__Contract_Status__c>();
        
        for(Id contractStatusId : mapConStatusIdtoLstParty.keySet()){
            boolean temp = false;
            collect__Contract_Status__c objStatus = new collect__Contract_Status__c();
            objStatus.Id = contractStatusId;
            
            if(mapConStatusIdtoLstParty.get(contractStatusId) != null){
                List<clcommon__Party__c> lstNew = mapConStatusIdtoLstParty.get(contractStatusId);
                
                if(lstNew != null && lstNew.size()>0){
                    for(clcommon__Party__c obj : lstNew){
                        if(obj.clcommon__Type__c == strBorrowerId){
                            if(obj.clcommon__Account__c != Null)
                            {
                                objstatus.ScCollection_Account__c = obj.clcommon__Account__c;
                                objstatus.ScCollection_Contact__c = Null;
                                
                                if(obj.clcommon__Contact__c != Null)
                                {
                                    objstatus.ScCollection_Contact__c = obj.clcommon__Contact__c;
                                }
                                
                                //lstContractStatusUpdate.add(objstatus);
                            }
                        }
                        else{
                            if(obj.clcommon__Type__c == strCoBorrowerId){
                                if(obj.clcommon__Account__c != Null)
                                {
                                    
                                    objstatus.ScCollection_Secondary_Account__c = obj.clcommon__Account__c;
                                    objstatus.ScCollection_Secondary_Contact__c = Null;
                                    
                                    if(obj.clcommon__Contact__c != Null)
                                    {
                                        objstatus.ScCollection_Secondary_Contact__c = obj.clcommon__Contact__c;
                                    }
                                    temp = true;
                                    //lstContractStatusUpdate.add(objstatus);
                                }
                            }
                            else if(obj.clcommon__Type__c == strGuarantor && !mapConIdToBoolean.containsKey(obj.collect__CL_Contract__c) && temp == false){
                                if(obj.clcommon__Account__c != Null)
                                {
                                
                                    objstatus.ScCollection_Secondary_Account__c = obj.clcommon__Account__c;
                                    objstatus.ScCollection_Secondary_Contact__c = Null;
                                    
                                    if(obj.clcommon__Contact__c != Null)
                                    {
                                        objstatus.ScCollection_Secondary_Contact__c = obj.clcommon__Contact__c;
                                    }
                                    
                                   // lstContractStatusUpdate.add(objstatus);
                                }
                            }
                        }
                    }
                    lstContractStatusUpdate.add(objstatus);
                }
            }
        }
        
        
        if(ScCollection_UtilityHandler.isNotNull(lstContractStatusUpdate))
        {
            try
            {
                update lstContractStatusUpdate;
            }
            catch(Exception e)
            {
                system.debug('Error in updating status record : ' + e.getMessage());
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------
    // This method is created to check the party type on insert and update and stop duplicacy of borrower party type
    // ---------------------------------------------------------------------------------------------------
    // created Date : 10-OCT-2016   Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
    // ---------------------------------------------------------------------------------------------------
    public void ValidatePartyType(List<clcommon__Party__c> lstNew)
    {
        Map<Id,List<clcommon__Party__c>> mapContractToParty = new Map<Id,List<clcommon__Party__c>>();
        Set<Id> setIds = new Set<Id>();
        
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.collect__CL_Contract__c != Null)
            {
                setIds.add(obj.collect__CL_Contract__c);
            }
        }
        
        if(ScCollection_UtilityHandler.isNotNull(setIds))
        {
            for(collect__Loan_Account__c obj : [select Id, (select Id, clcommon__Type__c from collect__Parties__r) from collect__Loan_Account__c where Id IN : setIds])
            {
                if(obj.collect__Parties__r != Null && obj.collect__Parties__r.size() > 0)
                {
                    mapContractToParty.put(obj.Id,obj.collect__Parties__r);
                }
            }
        }
        
        for(clcommon__Party__c obj : lstNew)
        {
            if(obj.collect__CL_Contract__c != Null && mapContractToParty.containsKey(obj.collect__CL_Contract__c) && mapContractToParty.get(obj.collect__CL_Contract__c) != Null)
            {
                for(clcommon__Party__c objp : mapContractToParty.get(obj.collect__CL_Contract__c))
                {
                    if(objp.Id != obj.Id && objp.clcommon__Type__c == obj.clcommon__Type__c)
                    {
                        obj.addError('Sorry! you cant add multiple parties with type Borrower under a single contract.');
                    }
                }
            }
        }
    }
}