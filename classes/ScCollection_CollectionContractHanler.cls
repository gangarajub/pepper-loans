// -------------------------------------------------------------------------------------------------------- 
// This class handles all the trigger events on collect__loan_account__c Object
// --------------------------------------------------------------------------------------------------------
// Created Date : 30-June-2016  Created By: Deepak Dhingra  Email: deepak.dhingra@saasfocus.com
// Revisions:
// AH 2017-12-18
// Added createContractCollectionsMetrics
// --------------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestCollectionContractHan
// --------------------------------------------------------------------------------------------------------
public class ScCollection_CollectionContractHanler 
{
    public Map<Id,String> mapSourceSystemName = new Map<Id,String>();
    
    public ScCollection_CollectionContractHanler()
    {
        for(collect__Source_System__c obj : [select Id, Name from collect__Source_System__c])
        {
            mapSourceSystemName.put(obj.Id,obj.Name);
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before insert events on Queue Contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date: 30-June-2016   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeInsert(list<collect__loan_account__c> lstNew) 
    {
        //create new contract status and tag it to the contract
        createContractStatus(lstNew);    

        //finds the relevant bank account record and tags it with the contract record
        updateBankAccount(lstNew);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after insert events on  Contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date : 05-Aug-2016  Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterInsert(List<collect__loan_account__c> lstNew) 
    {
        //input vars for UpdateMortgageApplication()
        Set<String> setApplicationId = new Set<String>();
        Map<String,collect__Loan_Account__c> mapAppIdToContract = new Map<String,collect__Loan_Account__c>();

        //input var for UpdateContractCountOnCollectionMatrix()
        Map<Id,collect__loan_account__c> mapIdToContractNumber = new Map<Id,collect__loan_account__c>();
        
        for(collect__loan_account__c obj : lstNew)
        {
            //if the application Id is not null build up the vars for UpdateMortgageApplication()
            if(obj.ScCollection_Application_Id__c != Null)
            {    
                setApplicationId.add(obj.ScCollection_Application_Id__c);
                mapAppIdToContract.put(obj.ScCollection_Application_Id__c,obj);
            }
            
            //if the counter is > 0 for PAF
            if(obj.ScCollection_Daily_Contact_Counter__c != null && obj.ScCollection_Daily_Contact_Counter__c > 0){
                if(obj.ScCollection_Source_System_Name__c == 'PAF' || (obj.ScCollection_Source_System_Name__c == 'MORTGAGE' && obj.Name.contains('_0'))){
                    mapIdToContractNumber.put(obj.Id,obj);
                  }
            }
            
        }
        
        createContractCollectionsMetrics(lstNew);
        
        //update contract id on application
        UpdateMortgageApplication(setApplicationId,mapAppIdToContract);
        
        //Added 12/4/2017 -- to update Contract Count
        UpdateContractCountOnCollectionMatrix(mapIdToContractNumber);
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method handles all the before update events on  Contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date : 01-Aug-2016  Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onBeforeUpdate(Map<id,collect__loan_account__c> newMap,Map<id,collect__loan_account__c> oldMap) 
    {
        User usr = [select id,ScCollection_UserType__c from user where id =: UserInfo.getUserId()];

        if(usr.ScCollection_UserType__c == 'ESB User'){
                
                // populate the old bucket 
                populateBucket(newMap.values(),oldMap);
            
        }else{
                
                // populate the old bucket 
                populateBucket(newMap.values(),oldMap);
                
                //Created By: Sandip bijlwan to update MOD Date value 
                PopulateMDOdate(newMap.values(),oldMap, usr);
                
                //Created By: Sandip bijlwan to perform exlcude from strategy fucnitonality
                CheckExcludeFromStrategy(newMap.values(),oldMap);
            
        }
    }


    // ----------------------------------------------------------------------------------------------------
    // This method handles all the after update events on  Contract
    // ----------------------------------------------------------------------------------------------------
    // Created Date : 05-Aug-2016  Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void onAfterUpdate(List<collect__loan_account__c> lstNew,Map<id,collect__loan_account__c> oldMap) 
    {
        //input vars for updateContractStatus()
        Set<Id> setStatusIds = new Set<Id>();
        list<collect__loan_account__c> lstContractsStatusHasChanged = new list<collect__loan_account__c>();

        //input vars for UpdateMortgageApplication()
        Set<String> setApplicationId = new Set<String>();
        Map<String,collect__Loan_Account__c> mapAppIdToContract = new Map<String,collect__Loan_Account__c>();

        //input var for UpdateContractCountOnCollectionMatrix()
        map<Id,collect__loan_account__c> mapIdToContractNumber = new map<Id,collect__loan_account__c>();
        
        //AH One loop, rather than one in each child method
        for(collect__loan_account__c obj : lstNew)
        {
            //check for change in Status and build vars for updateContractStatus()
            if(obj.ScCollection_Loan_Status_Description__c != oldMap.get(obj.Id).ScCollection_Loan_Status_Description__c || obj.ScCollection_Loan_Sub_status_description__c != oldMap.get(obj.Id).ScCollection_Loan_Sub_status_description__c)
            {
                if(obj.collect__Collection_Status__c != Null && obj.collect__Source_System__c != Null)
                {
                    setStatusIds.add(obj.collect__Collection_Status__c);
                    lstContractsStatusHasChanged.add(obj);
                }
            }
            
            //check if the application id / settlement date / principle have changed and build vars for UpdateMortgageApplication()
            if(obj.ScCollection_Application_Id__c != Null && 
               (obj.ScCollection_Application_Id__c != oldMap.get(obj.Id).ScCollection_Application_Id__c || 
                obj.ScCollection_Settled_Date__c != oldMap.get(obj.Id).ScCollection_Settled_Date__c || 
                obj.ScCollection_Initial_Principal__c!= oldMap.get(obj.Id).ScCollection_Initial_Principal__c))
            {    
                setApplicationId.add(obj.ScCollection_Application_Id__c);
                mapAppIdToContract.put(obj.ScCollection_Application_Id__c,obj);
            }
            
            
            //check if the counter is > 0 and build map for UpdateContractCountOnCollectionMatrix()
            if(obj.ScCollection_Daily_Contact_Counter__c != null  && oldMap.ContainsKey(obj.Id) && oldMap.get(obj.Id) != null){
                
                if(obj.ScCollection_Daily_Contact_Counter__c != oldMap.get(obj.Id).ScCollection_Daily_Contact_Counter__c &&
                   obj.ScCollection_Counter_Processed_Date__c != oldMap.get(obj.Id).ScCollection_Counter_Processed_Date__c && 
                   obj.ScCollection_Daily_Contact_Counter__c > 0){
                       
                       if(obj.ScCollection_Source_System_Name__c == 'PAF' || (obj.ScCollection_Source_System_Name__c == 'MORTGAGE' && obj.Name.contains('_0'))){
                           mapIdToContractNumber.put(obj.Id,obj);
                       }
                   }
                
            }            
        }
        
        //populate the status on contract status
        updateContractStatus(setStatusIds, lstContractsStatusHasChanged);
        
        //update contract id on application
        UpdateMortgageApplication(setApplicationId, mapAppIdToContract);
        
        //Added 12/4/2017 -- to update Contract Count
        UpdateContractCountOnCollectionMatrix(mapIdToContractNumber);
    }
        
    // ---------------------------------------------------------------------------------------------------------
    // This method will populate the old bucket field on change of bucket on contract/Only for reporting purpose
    // ---------------------------------------------------------------------------------------------------------
    // Created Date :  01-Aug-2016   Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // ---------------------------------------------------------------------------------------------------------
    private void populateBucket(List<collect__loan_account__c> lstNew,Map<id,collect__loan_account__c> oldMap)
    {    
        // check if the bucket has changed 
        for(collect__Loan_Account__c objLoanAccount : lstNew){
            if(objLoanAccount.ScCollection_Bucket__c != oldMap.get(objLoanAccount.Id).ScCollection_Bucket__c)
            {    
                // put value in the old bucket field
                objLoanAccount.ScCollection_OldBucket__c = oldMap.get(objLoanAccount.Id).ScCollection_Bucket__c;
                objLoanAccount.ScCollection_Movement_Date__c = System.today();
            }   
        }
    }
    
    // ----------------------------------------------------------------------------------------------------
    // This method is use to fill MOD Start Date and MOD End Date 
    // ----------------------------------------------------------------------------------------------------
    // Created Date : 30-Jan-2017  Created By: Sandip Bijlwan  
    // ----------------------------------------------------------------------------------------------------
    public void PopulateMDOdate(List<collect__loan_account__c> lstNew , Map<id,collect__loan_account__c> oldMap, User usr)
    {
        
        String user_type_manager = 'Manager';
        String user_type_tl = 'TL';
        String user_type_user = 'CO';
        Id queueId;
        Boolean tempCheck = false;
            
            set<Id> setConIdChecked = new set<Id>();
            set<Id> setConIdtoValidateUserPermission = new set<Id>();
            if(lstNew != null && lstNew.size()>0){
                for(collect__loan_account__c objLoanAccount : lstNew){
                    if(oldMap.containsKey(objLoanAccount.id) && oldMap.get(objLoanAccount.id) != null){
                        if(objLoanAccount.ScCollection_MDO__c != oldMap.get(objLoanAccount.id).ScCollection_MDO__c){
                            if(objLoanAccount.ScCollection_MDO__c == true){
                                if(usr.ScCollection_UserType__c == user_type_manager || usr.ScCollection_UserType__c == user_type_tl || 
                                    usr.ScCollection_UserType__c == user_type_user){
                                        objLoanAccount.ScCollection_MDO_Start_Date__c = System.Today();
                                        tempCheck = True;
                                        setConIdChecked.add(objLoanAccount.id);
                                    }
                            }
                            else{
                                setConIdtoValidateUserPermission.add(objLoanAccount.id);
                            }
                        }   
                    }           
                }
            }
            
            if(setConIdtoValidateUserPermission != null && setConIdtoValidateUserPermission.size()>0){
                List<collect__Queue_Contract__c> lstQueueContract = [select id,ScCollection_Dev_Contract__c,collect__Status__c,collect__User__c from                                                    collect__Queue_Contract__c
                                                                    where ScCollection_Dev_Contract__c in : setConIdtoValidateUserPermission and collect__Status__c = 'Open' and
                                                                    collect__User__c = : UserInfo.getUserId()];
                
                map<String,collect__Queue_Contract__c > mapUserIdToQueCon = new map<String,collect__Queue_Contract__c >();
                if(lstQueueContract != null && lstQueueContract.size()>0){
                    for(collect__Queue_Contract__c objQueueCon : lstQueueContract){
                        if(!mapUserIdToQueCon.containsKey(objQueueCon.collect__User__c+'-'+objQueueCon.ScCollection_Dev_Contract__c)){
                            mapUserIdToQueCon.put(objQueueCon.collect__User__c+'-'+objQueueCon.ScCollection_Dev_Contract__c,objQueueCon );
                        }
                    }
                }
                set<Id> setQueueContractID = new set<Id>();
                if(lstNew != null && lstNew.size()>0){
                    for(collect__loan_account__c objLoanAccount : lstNew){
                        if(oldMap.containsKey(objLoanAccount.id) && oldMap.get(objLoanAccount.id) != null){
                            if(objLoanAccount.ScCollection_MDO__c != oldMap.get(objLoanAccount.id).ScCollection_MDO__c){
                                if(objLoanAccount.ScCollection_MDO__c == false){
                                    if(usr.ScCollection_UserType__c == user_type_user){
                                        if(mapUserIdToQueCon.containsKey(usr.Id+'-'+objLoanAccount.Id) && mapUserIdToQueCon.get(usr.Id+'-'+objLoanAccount.Id) != null){
                                            objLoanAccount.ScCollection_MDO_End_Date__c = System.Today();
                                            setQueueContractID.add(mapUserIdToQueCon.get(usr.Id+'-'+objLoanAccount.Id).Id);
                                        }
                                        else{
                                            objLoanAccount.addError('You are not current assignee for this contract so you do not have permission to edit MDO flag.');
                                        }
                                    }
                                    else if(usr.ScCollection_UserType__c == user_type_manager || usr.ScCollection_UserType__c == user_type_tl){
                                        objLoanAccount.ScCollection_MDO_End_Date__c = System.Today();
                                        
                                        if(mapUserIdToQueCon.containsKey(usr.Id+'-'+objLoanAccount.Id) && mapUserIdToQueCon.get(usr.Id+'-'+objLoanAccount.Id) != null)
                                            setQueueContractID.add(mapUserIdToQueCon.get(usr.Id+'-'+objLoanAccount.Id).Id);
                                    }
                                }
                            }  
                        }
                    }
                }
                List<collect__Queue_Contract__c> lstQueuConToUpdate = new List<collect__Queue_Contract__c>();
                if(setQueueContractID != null && setQueueContractID.size()>0){
                
                    for(Id queueConID : setQueueContractID){
                    
                        collect__Queue_Contract__c objQueueContract = new collect__Queue_Contract__c ();
                        objQueueContract.Id = queueConID;
                        objQueueContract.collect__Status__c = 'Closed';
                        objQueueContract.collect__Date_Closed__c= System.Today();
                        objQueueContract.collect__User__c = null;
                        lstQueuConToUpdate.add(objQueueContract); 
                    }
                }
                
                if(lstQueuConToUpdate != null && lstQueuConToUpdate.size()>0){
                    update lstQueuConToUpdate;
                }
            }
            
            if(tempCheck){
                List<collect__Queue__c> lstQueue = [Select Id from collect__Queue__c where collect__Permanent__c = true and collect__Enabled__c = true limit 1];
                if(lstQueue != null && lstQueue.size()>0){
                    queueId = lstQueue[0].Id;
                }
                else{
                    lstNew[0].addError('There is no queue exist with enabled or permanent attribute. Kindly setup atleast one queue with these attributes.');
                }
            }
                
            try{
                if(tempCheck){
                
                    collect.API4 api = collect.APIFactory.getAPI4();
                    collect.Result res = api.userAssignment(setConIdChecked, usr.Id, queueId, 'Permanent', null, null);
                    system.debug(res );
                }
                      
            }
            catch(Exception ex){
                system.debug(ex.getMessage());
            }       

    }

    // ----------------------------------------------------------------------------------------------------
    // This method is use to create User Assignment when Exclude from Strategy is true
    // ----------------------------------------------------------------------------------------------------
    // Created Date : 5-April-2017  Created By: Sandip Bijlwan  
    // ----------------------------------------------------------------------------------------------------
    public void CheckExcludeFromStrategy(List<collect__loan_account__c> lstNew , Map<id,collect__loan_account__c> oldMap)
    {    
        set<Id> setConIdChecked = new set<Id>();
        set<Id> setFalseStrategy = new set<Id>();
        Boolean varTocheckActiveQueue = false;
        Id queueId;
        
        for(collect__loan_account__c objLoanAccount : lstNew){
            if(Trigger.IsUpdate && oldMap.containsKey(objLoanAccount.Id) && oldMap.get(objLoanAccount.Id) != null){
                
                if(oldMap.get(objLoanAccount.Id).ScCollection_Exclude_from_strategy__c != objLoanAccount.ScCollection_Exclude_from_strategy__c)
                {
                    if(objLoanAccount.ScCollection_Exclude_from_strategy__c == true){
                        setConIdChecked.add(objLoanAccount.Id); 
                        varTocheckActiveQueue = true;
                    }
                    else
                    {
                        setFalseStrategy.add(objLoanAccount.Id);
                    }
                }
            }
        }
        
        if(setFalseStrategy != null && setFalseStrategy.Size()>0){
            List<collect__Queue_Contract__c> lstQueueContract = [select id,ScCollection_Dev_Contract__c,collect__Status__c,collect__User__c from                                                    collect__Queue_Contract__c
                                                                where ScCollection_Dev_Contract__c in : setFalseStrategy and collect__Status__c = 'Open' and
                                                                collect__User__c = : UserInfo.getUserId()];
            
            
            List<collect__Queue_Contract__c> lstToUpdateQueueContract = new List<collect__Queue_Contract__c>();
            for(collect__Queue_Contract__c objQueue : lstQueueContract){
                
                objQueue.collect__Status__c = 'Closed';
                objQueue.collect__Date_Closed__c= System.Today();
                objQueue.collect__User__c = null;
                lstToUpdateQueueContract.add(objQueue);
            }
            
            if(lstToUpdateQueueContract != null && lstToUpdateQueueContract.Size()>0){
                update lstToUpdateQueueContract;
            }
        }
        
        
        if(varTocheckActiveQueue){
            List<collect__Queue__c> lstQueue = [Select Id from collect__Queue__c where collect__Permanent__c = true and collect__Enabled__c = true limit 1];
            if(lstQueue != null && lstQueue.size()>0){
                queueId = lstQueue[0].Id;
            }
            else{
                lstNew[0].addError('There is no queue exist with enabled or permanent attribute. Kindly setup atleast one queue with these attributes.');
            }
        }
        
        try{
            if(varTocheckActiveQueue){
                Id usrId = UserInfo.getUserId();
                collect.API4 api = collect.APIFactory.getAPI4();
                collect.Result res = api.userAssignment(setConIdChecked, usrId, queueId, 'Permanent', null, null);
            }
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        } 
    }

    
    // ----------------------------------------------------------------------------------------------------
    // This method will insert new contract status against the contract when a contact is created
    // ----------------------------------------------------------------------------------------------------
    // Created Date:   30-June-2016     Created By: Deepak Dhignra  Email: deepak.dhingra@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void createContractStatus(list<collect__loan_account__c> lstNew)
    {
        List<wrapperForMapping> lstWrapp = new list<wrapperForMapping>();
        List<collect__Contract_Status__c> tempListtoInsert = new list<collect__Contract_Status__c>();
                
        // create new contract for each contract
        for(collect__loan_account__c obj : lstNew)
        {   
            collect__Contract_Status__c objstatus = new collect__Contract_Status__c();
                        
            if(obj.collect__Source_System__c != Null && obj.ScCollection_Loan_Status_Description__c != Null && obj.ScCollection_Loan_Sub_status_description__c != Null)
            {
                if(mapSourceSystemName.containsKey(obj.collect__Source_System__c) && mapSourceSystemName.get(obj.collect__Source_System__c) != Null)
                {
                    if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('MORTGAGE'))
                    {
                        if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Misc Status'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Settled'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Settled';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Dis Pending'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Dis Pending';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Discharged'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Discharged';
                            }
                        }
                    } 
                    else if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('PAF'))
                    {
                        if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Arrears'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Overdue'))
                            {
                                objstatus.ScCollection_Arrears__c = 'Overdue';    
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Default-Collection Officer'))
                            {
                                objstatus.ScCollection_Arrears__c = 'Default - Collections Officer';
                            }
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Remarketing'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Early Payout-Sale of Asset'))
                            {
                                objstatus.ScCollection_Remarketing__c = 'Early Payout-Sale of Asset';
                            }
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Misc Status'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Current'))
                            {
                                objstatus.Main_Status__c = 'Current';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Closed - Early Payout'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Closed - Early Payout';
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Closed - Maturity'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Closed - Maturity';
                            }
                        }
                    }
                }
            }
            
            if(obj.collect__Source_System__c != Null && mapSourceSystemName.containsKey(obj.collect__Source_System__c) && mapSourceSystemName.get(obj.collect__Source_System__c) != Null){
                if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('MORTGAGE')){
                    //added for EDW ----
                    objstatus.ScCollection_LOB_Identifier__c = 'MORTGAGE';
                }
                else if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('PAF')){
                    //added for EDW ----
                    objstatus.ScCollection_LOB_Identifier__c = 'PAF';
                }
                else if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('CL Loan')){
                    objstatus.ScCollection_LOB_Identifier__c = 'CL Loan';
                }
            }
                
            //added for EDW ------------
            objstatus.ScCollection_External_Id__c = obj.collect__External_ID__c ;
            objstatus.ScCollection_Contract_Name__c = (obj.Name != null ? (obj.Name.contains('_') ? obj.Name.split('\\_')[0] : obj.Name) : '' );
            objstatus.ScCollection_Country_Code__c = obj.ScCollection_Country_Code__c ;
            objstatus.ScCollection_Split_Number__c = String.ValueOf(obj.ScCollection_Contract_Split_Number__c);
            
            tempListtoInsert.add(objstatus);
            lstWrapp.add(new wrapperForMapping(objstatus,obj));
        }
        
        if(tempListtoInsert.size() > 0)
        {
            insert tempListtoInsert;
        }
        
        for(wrapperForMapping tempLoanAccount: lstWrapp)
        {
            tempLoanAccount.contract.collect__Collection_Status__c = tempLoanAccount.status.id;
        }
    }
    
    public class wrapperForMapping
    {
        public collect__Contract_Status__c status;
        public collect__loan_account__c contract;
        public wrapperForMapping(collect__Contract_Status__c status,collect__loan_account__c contract)
        {
            this.status = status;
            this.contract = contract;
        }
    }

    // ----------------------------------------------------------------------------------------------------
    // This method will tag bank account record with contract when a contact is created
    // ----------------------------------------------------------------------------------------------------
    // Created Date:   04-Aug-2016     Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void updateBankAccount(list<collect__loan_account__c> lstNew)
    {
        Set<String> setExternalIds = new Set<String>();
        Map<String,collect__Bank_Account__c> mapExternalIdToBankAccountRecord = new Map<String,collect__Bank_Account__c>();
        list<collect__loan_account__c> lstContracts = new list<collect__loan_account__c>();
        
        for(collect__loan_account__c obj : lstNew)
        {
            if(obj.collect__Source_System__c != Null && mapSourceSystemName.containsKey(obj.collect__Source_System__c) && mapSourceSystemName.get(obj.collect__Source_System__c) != Null)
            {
                if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('MORTGAGE'))
                {
                    if(obj.collect__External_ID__c != Null)
                    {
                        setExternalIds.add(obj.collect__External_ID__c);
                        lstContracts.add(obj);
                    }
                }
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(setExternalIds))
        {
            for(collect__Bank_Account__c obj : [select Id, collect__External_ID__c, collect__Bank_Account_Number__c from collect__Bank_Account__c where collect__External_ID__c IN : setExternalIds])
            {
                mapExternalIdToBankAccountRecord.put(obj.collect__External_ID__c, obj);
            }
        

            for(collect__loan_account__c obj : lstContracts)
            {
                if(obj.collect__External_ID__c != Null && mapExternalIdToBankAccountRecord.containsKey(obj.collect__External_ID__c) && mapExternalIdToBankAccountRecord.get(obj.collect__External_ID__c) != Null)
                {
                    obj.ScCollection_Bank_Account__c = mapExternalIdToBankAccountRecord.get(obj.collect__External_ID__c).Id;
                    obj.ScCollection_Account_Number__c = mapExternalIdToBankAccountRecord.get(obj.collect__External_ID__c).collect__Bank_Account_Number__c;
                }
            }
        }
    }



    // ----------------------------------------------------------------------------------------------------
    // This method will update contract status against the contract when a contact is updated
    // ----------------------------------------------------------------------------------------------------
    // Created Date:   5-Aug-2016     Created By: Pawan Mudgal  Email: pawan.mudgal@saasfocus.com
    // ----------------------------------------------------------------------------------------------------
    public void updateContractStatus( Set<Id> setStatusIds, list<collect__loan_account__c> lstContractsStatusHasChanged)
    {
        List<collect__Contract_Status__c> lstUpdateStatus = new List<collect__Contract_Status__c>();
        Map<Id,collect__Contract_Status__c> MapContractStatus = new Map<Id,collect__Contract_Status__c>();
        
        if(ScCollection_UtilityHandler.isNotNull(setStatusIds) && lstContractsStatusHasChanged.size()>0)
        {
            for(collect__Contract_Status__c objstat : [select Id from collect__Contract_Status__c where Id IN : setStatusIds])
            {
                MapContractStatus.put(objstat.Id, objstat);
            }
        

            for(collect__loan_account__c obj : lstContractsStatusHasChanged)
            {
                if(mapSourceSystemName.containsKey(obj.collect__Source_System__c) && mapSourceSystemName.get(obj.collect__Source_System__c) != Null && MapContractStatus.containsKey(obj.collect__Collection_Status__c) && MapContractStatus.get(obj.collect__Collection_Status__c) != Null)
                {
                    collect__Contract_Status__c objstatus = MapContractStatus.get(obj.collect__Collection_Status__c);
                    
                    if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('MORTGAGE'))
                    {
                        if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Misc Status'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Settled'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Settled';
                                lstUpdateStatus.add(objstatus);
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Dis Pending'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Dis Pending';
                                lstUpdateStatus.add(objstatus);
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Discharged'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Discharged';
                                lstUpdateStatus.add(objstatus);
                            }
                        }
                    } 
                    else if(ScCollection_UtilityHandler.getPlainString(mapSourceSystemName.get(obj.collect__Source_System__c)) == ScCollection_UtilityHandler.getPlainString('PAF'))
                    {
                        if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Arrears'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Overdue'))
                            {
                                objstatus.ScCollection_Arrears__c = 'Overdue';    
                                lstUpdateStatus.add(objstatus);
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Default-Collection Officer'))
                            {
                                objstatus.ScCollection_Arrears__c = 'Default - Collections Officer';
                                lstUpdateStatus.add(objstatus);
                            }
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Remarketing'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Early Payout-Sale of Asset'))
                            {
                                objstatus.ScCollection_Remarketing__c = 'Early Payout-Sale of Asset';
                                lstUpdateStatus.add(objstatus);
                            }
                        }
                        else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Status_Description__c) == ScCollection_UtilityHandler.getPlainString('Misc Status'))
                        {
                            if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Current'))
                            {
                                objstatus.Main_Status__c = 'Current';
                                lstUpdateStatus.add(objstatus);
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Closed - Early Payout'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Closed - Early Payout';
                                lstUpdateStatus.add(objstatus);
                            }
                            else if(ScCollection_UtilityHandler.getPlainString(obj.ScCollection_Loan_Sub_status_description__c) == ScCollection_UtilityHandler.getPlainString('Closed - Maturity'))
                            {
                                objstatus.ScCollection_Misc_Status__c = 'Closed - Maturity';
                                lstUpdateStatus.add(objstatus);
                            }
                        }
                    }
                }
            }
        }

        if(ScCollection_UtilityHandler.isNotNull(lstUpdateStatus))
        {
            try
            {
                update lstUpdateStatus;
            }
            catch(Exception e)
            {
                system.debug('contract status update error : ' + e.getMessage());
            }
        }        
    }
    
    
    public void UpdateMortgageApplication(Set<String> setApplicationId, Map<String,collect__Loan_Account__c> mapAppIdToContract)
    {
        
        List<CRM_Mortgage_Application_Data__c> lstToUpsert = new List<CRM_Mortgage_Application_Data__c>();
            
        if(setApplicationId != Null && setApplicationId.Size() > 0)
        {
            for(CRM_Mortgage_Application_Data__c objApp : [select Id, CRM_Mtg_Application_Id__c from CRM_Mortgage_Application_Data__c where CRM_Mtg_Application_Id__c IN : setApplicationId])
            {    
                if(mapAppIdToContract.containsKey(objApp.CRM_Mtg_Application_Id__c) && mapAppIdToContract.get(objApp.CRM_Mtg_Application_Id__c) != Null)
                {        
                    objApp.CRM_Mtg_Loan_Contract__c = mapAppIdToContract.get(objApp.CRM_Mtg_Application_Id__c).Id;
                    
                    if(mapAppIdToContract.get(objApp.CRM_Mtg_Application_Id__c).ScCollection_Settled_Date__c != Null)
                    {
                        objApp.CRM_Mtg_Settlement_Date__c = mapAppIdToContract.get(objApp.CRM_Mtg_Application_Id__c).ScCollection_Settled_Date__c;
                    }
                    
                    if(mapAppIdToContract.get(objApp.CRM_Mtg_Application_Id__c).ScCollection_Initial_Principal__c != Null)
                    {
                        objApp.CRM_Mtg_Settlement_Amount__c = mapAppIdToContract.get(objApp.CRM_Mtg_Application_Id__c).ScCollection_Initial_Principal__c;
                    }
                    
                    lstToUpsert.add(objApp);
                }    
            }                    
        }
        
        try
        {
            Schema.SObjectField externalfield = CRM_Mortgage_Application_Data__c.Fields.CRM_Mtg_Application_Id__c;
            List<Database.UpsertResult> results = database.Upsert(lstToUpsert,externalfield,false);
            
            if(results != Null)
            {
                for(Database.UpsertResult result : results) 
                {
                    if(!result.isSuccess()) 
                    {
                        Database.Error[] errs = result.getErrors();
                        
                        for(Database.Error err : errs)
                        {
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            System.debug(ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage());
        }
        
    }
    
    
    // ----------------------------------------------------------------------------------------------------
    // This method is use to update Contract Count on Collection Matrix
    // ----------------------------------------------------------------------------------------------------
    // Created Date : 12-April-2017  Created By: Sandip Bijlwan  
    // ----------------------------------------------------------------------------------------------------
    public void UpdateContractCountOnCollectionMatrix(Map<Id,collect__loan_account__c> mapIdToContractNumber)
    {    
        
        
        //for PAF----------
        if(mapIdToContractNumber != null && mapIdToContractNumber.KeySet() != null && mapIdToContractNumber.KeySet().Size() > 0){
            List<collect__Interaction_Log__c> lstLogToInsert = new List<collect__Interaction_Log__c>();
            
            List<collect__Action_Code__c> lstActionCode = [Select Id,ScCollection_Head_Status__c From collect__Action_Code__c Where ScCollection_Head_Status__c ='CollectionLetterCountActivity'];
            
            if(lstActionCode != null && lstActionCode.Size() == 0){
                
                collect__Action_Code__c objActioncode = new collect__Action_Code__c();
                objActioncode.ScCollection_Head_Status__c = 'CollectionLetterCountActivity';
                objActioncode.Name = 'Collection Letter Count Activity';
                objActioncode.ScCollection_Considered_Contact__c = 'Yes';
                objActioncode.ScCollection_Is_Inbound_Action__c = false;
                insert objActioncode;
                
                lstActionCode.add(objActioncode);
    
            }
            
            for(Id recId : mapIdToContractNumber.KeySet()){
                
                if(mapIdToContractNumber.get(recId) != null && mapIdToContractNumber.get(recId).ScCollection_Daily_Contact_Counter__c > 0){
                    Integer counterCount = Integer.ValueOf(mapIdToContractNumber.get(recId).ScCollection_Daily_Contact_Counter__c);
                    for(Integer i=0;i<counterCount;i++){
                        collect__Interaction_Log__c objLog = new collect__Interaction_Log__c();
                        objLog.collect__Dev_Contract__c = recId;
                        objLog.collect__Action__c = lstActionCode[0].Id;
                        
                        if(mapIdToContractNumber.get(recId).ScCollection_Counter_Processed_Date__c != null){
                            objLog.collect__Description__c = mapIdToContractNumber.get(recId).ScCollection_Source_System_Name__c+'-Collection Letter-'+mapIdToContractNumber.get(recId).ScCollection_Counter_Processed_Date__c.format();
                            objLog.collect__Follow_Up_Date_Time__c = mapIdToContractNumber.get(recId).ScCollection_Counter_Processed_Date__c;   
                        }
                        else{
                            objLog.collect__Description__c = mapIdToContractNumber.get(recId).ScCollection_Source_System_Name__c+'-Collection Letter-'+System.Today().format();
                            objLog.collect__Follow_Up_Date_Time__c = System.Today();
                        }

                        lstLogToInsert.add(objLog);
                    }
                }
            }
            
            try{
                if(lstLogToInsert != null && lstLogToInsert.Size()>0 && lstLogToInsert.Size() < 10000){
                    insert lstLogToInsert;
                }
            }
            catch(Exception ex){
                system.debug('Error Message:'+ex.getMessage());
                system.debug('Error Stack Trace:'+ex.getStackTraceString());
            }
        }
    }
 
    
    public static void createContractCollectionsMetrics(list<collect__loan_account__c> lstNew){
        
        List<collect__Collections_Metrics_Settings__c> thresholds = collect__Collections_Metrics_Settings__c.getAll().Values();
        
        List<collect__Contract_Collections_Metrics__c> newMetrics = new List<collect__Contract_Collections_Metrics__c>();
        
        for(collect__loan_account__c thisContract : lstNew){
            
            for (collect__Collections_Metrics_Settings__c thisThreshold : thresholds){
                
                collect__Contract_Collections_Metrics__c contractMetric = new collect__Contract_Collections_Metrics__c(
                    
                    Name = thisContract.Name + ':' + thisThreshold.Name,
					collect__Threshold_Days__c = thisThreshold.collect__Threshold_Days__c,
                    collect__Dev_Contract__c = thisContract.Id,
                    collect__Contact_Count__c = 0
                );
	            newMetrics.add(contractMetric);
            }            
        }
        
        insert newMetrics;
        
    }
}