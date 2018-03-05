/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          BulkSMSContractListHandler 
Company:       Saasfocus
Description:   This is the Lightning Component handler use to 
               populate data required in the component and use 
               to send SMS to the selected Contract.
History
Date    :  19/09/2017     
------------------------------------------------------------*/
global class BulkSMSContractListHandler{

    //Wrapper Class use to show the table data in the lightning component
    public class ContractListWrapper{
        @auraEnabled
        public Boolean sendSMS{get;set;}
        
        @auraEnabled
        public String strRecordId{get;set;}
        
        @auraEnabled
        public String strContractName{get;set;}
        
        @auraEnabled
        public String strBorrower{get;set;}
        
        @auraEnabled
        public String strBorrowerNo{get;set;}
        
        @auraEnabled
        public String strBucket{get;set;}
        
        @auraEnabled
        public String strAccountID{get;set;}
        
        @auraEnabled
        public String strContactID{get;set;}
    }
    
    //Wrapper class use to show the Action Code in the picklist on lightning component.
    public class ActionCodeWrapper{
        @auraEnabled
        public String strActionCodeId{get;set;}
        
        @auraEnabled
        public String strActionCodeName{get;set;}
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getActions
    Company:       Saasfocus
    Description:   This method is use to get all the Action Code on the basis of Source System.
    Inputs:        String
    Returns:       List<BulkSMSContractListHandler.ActionCodeWrapper>
    -----------------------------------------------------------------------------------*/
    
    @auraEnabled
    public static List<BulkSMSContractListHandler.ActionCodeWrapper> getActions(String strSourceSystem){
        
        List<ActionCodeWrapper> lstActionCodeWrapper = new List<ActionCodeWrapper>();
        
        if(!String.IsBlank(strSourceSystem))
        {
            for(collect__Action_Code_Config__c obj : [select Id, 
                                                             collect__Action_Code__c, 
                                                             collect__Action_Code__r.Name 
                                                             from collect__Action_Code_Config__c 
                                                             where collect__Action_Code__c != Null AND 
                                                             collect__Source_System__r.Name =: strSourceSystem
                                                             ORDER BY collect__Action_Code__r.Name ASC])
            { 
                ActionCodeWrapper objWrapper = new ActionCodeWrapper();
                objWrapper.strActionCodeId = obj.collect__Action_Code__c;
                objWrapper.strActionCodeName = obj.collect__Action_Code__r.Name;
                lstActionCodeWrapper.add(objWrapper);
            }
        }
        return lstActionCodeWrapper;
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          getLogTemplate
    Company:       Saasfocus
    Description:   This method is use to get all the SMS Template based on the basis of Source System.
    Inputs:        String
    Returns:       List<ScCollection_Log_Template__c>
    -----------------------------------------------------------------------------------*/
    
    @auraEnabled
    public static List<ScCollection_Log_Template__c> getLogTemplate(String strSourceSystem){
        
        List<ScCollection_Log_Template__c> lstLogTemplate= new List<ScCollection_Log_Template__c>();
        if(!String.IsBlank(strSourceSystem))
        {
            for(ScCollection_Log_Template__c obj : [select Id, 
                                                             ScCollection_Description__c, 
                                                             ScCollection_Is_Active__c,
                                                             ScCollection_Template_Name__c  
                                                             from ScCollection_Log_Template__c
                                                             where RecordTypeId = : Schema.SObjectType.ScCollection_Log_Template__c.getRecordTypeInfosByName().get('Manual SMS').getRecordTypeId() AND 
                                                             ScCollection_Source_System__r.Name =: strSourceSystem
                                                             ORDER BY ScCollection_Template_Name__c ASC])
            { 
                lstLogTemplate.add(obj);
            }
        }
        return lstLogTemplate;
    }
    
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          updateSchedule
    Company:       Saasfocus
    Description:   This method is use Schedule the BulkSMSScheduler based on the user 
                   input and then update the selected values into the Bulk Scheduled 
                   SMS Object 
    Inputs:        String,String,String,String,String,DateTime,Boolean
    Returns:       void
    -----------------------------------------------------------------------------------*/
    @auraEnabled
    public static String updateSchedule(String lstConListWrapper,String strActionCodeId,String reviewDate,String strSMSText,String strScheduleName,DateTime scheduleDateTime,Boolean checkRecuringSchedule){
        Savepoint sp = Database.setSavepoint();
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper = new BulkSMSCriteriaComponentController.ErrorWrapper();
        
        try{
            List<BulkSMSContractListHandler.ContractListWrapper> lstContractListWrapper = (List<BulkSMSContractListHandler.ContractListWrapper>)JSON.deserialize(
                  lstConListWrapper , List<BulkSMSContractListHandler.ContractListWrapper>.class);  
                          
            String strSec = '00';
            String strMin = String.valueOf(scheduleDateTime.minute());
            String strHour = String.valueOf(scheduleDateTime.hour());
            String strDay = String.valueOf(scheduleDateTime.day());
            String strMonth = String.valueOf(scheduleDateTime.month());
            String strDayOfWeek = '?';
            String strYear = String.valueOf(scheduleDateTime.year());
            
            String sch = strSec + ' ' + strMin + ' ' + strHour + ' ' + strDay + ' ' + strMonth + ' ' + strDayOfWeek + ' ' + strYear ;
            
            String bulkScheduleName = strScheduleName + ' ' + scheduleDateTime.format();
                        
            datetime dtNow = system.now();
            
            strScheduleName += ' ' + dtNow.format();
            
            
            BulkSMSScheduler  objScheduler = new BulkSMSScheduler();
            String jobID = system.schedule(strScheduleName, sch, objScheduler);
            
            Date convertedDate= Date.valueOf(reviewDate);
            Integer day = convertedDate.day();
            Integer month = convertedDate.month();
            Integer year = convertedDate.year();
            DateTime convertedDateTime = DateTime.newInstance(year, month, day);
            
            ScCollection_Bulk_Scheduled_SMS__c objScheduleSMS = new ScCollection_Bulk_Scheduled_SMS__c();
            
            objScheduleSMS.ScCollection_Action_Code_Id__c = strActionCodeId;
            objScheduleSMS.ScCollection_Job_Id__c = jobID;
            objScheduleSMS.ScCollection_Review_Date__c = convertedDateTime ;
            objScheduleSMS.ScCollection_SMS_Text__c = strSMSText;
            objScheduleSMS.ScCollection_Scheduler_Name__c = bulkScheduleName;
            String strConRecordIds = '';
            String strFirstContractId = '';
            for(BulkSMSContractListHandler.ContractListWrapper objContractWrapper : lstContractListWrapper){
                if(objContractWrapper.sendSMS != null && objContractWrapper.sendSMS == true){
                    if(strConRecordIds == ''){
                        strConRecordIds += objContractWrapper.strRecordId;
                        strFirstContractId = objContractWrapper.strRecordId;
                    }
                    else{
                        strConRecordIds += ',' + objContractWrapper.strRecordId;
                    }
                    
                }
            }
            
            String strSourceSystemName = '';
            if(!String.IsBlank(strFirstContractId)){
                String strObjectName = ScCollection_CommonCodeHandler.retriveSalesforceObjectType(strFirstContractId);
                if(!String.IsBlank(strObjectName) && strObjectName == 'collect__Loan_Account__c'){
                    List<collect__Loan_Account__c> lstContracts = [Select Id,ScCollection_Source_System_Name__c From collect__Loan_Account__c Where Id = : strFirstContractId];
                    if(lstContracts != null && lstContracts.Size() > 0){
                        strSourceSystemName = lstContracts[0].ScCollection_Source_System_Name__c;
                    }
                }
                else if(!String.IsBlank(strObjectName) && strObjectName == 'loan__Loan_Account__c'){
                    strSourceSystemName = 'CL Loan';
                }
            }
            objScheduleSMS.ScCollection_Source_System_Name__c = strSourceSystemName;
            objScheduleSMS.ScCollection_Contract_Id_s__c = strConRecordIds;
            
            insert objScheduleSMS;
            
            objErrorWrapper.isError = false;
            objErrorWrapper.message = 'SUCCESS';
            objErrorWrapper.strResults  = '';
            return JSON.serialize(objErrorWrapper);
        }
        catch(exception ex){
            Database.rollback(sp);
            objErrorWrapper.isError = true;
            objErrorWrapper.message = 'Error !!' + ex.getMessage();
            objErrorWrapper.strResults  = '';
            return JSON.serialize(objErrorWrapper);
        }
    }
    
    /*------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          sendBulkSMS
    Company:       Saasfocus
    Description:   This method is use to send SMS from the Lightning Component and 
                   create the Delivery detail records so that it can be viewed under 
                   Contract in ICM
    Inputs:        String,String,String,String
    Returns:       BulkSMSCriteriaComponentController.ErrorWrapper
    -----------------------------------------------------------------------------------*/
    
    @auraEnabled
    webservice static String sendBulkSMS(String lstConListWrapper,String strActionCodeId,String reviewDate,String strSMSText,decimal disableTrigger){
        Savepoint sp;
        BulkSMSCriteriaComponentController.ErrorWrapper objErrorWrapper = new BulkSMSCriteriaComponentController.ErrorWrapper();
        try{
            
            List<BulkSMSContractListHandler.ContractListWrapper> lstContractListWrapper = (List<BulkSMSContractListHandler.ContractListWrapper>)JSON.deserialize(
                  lstConListWrapper , List<BulkSMSContractListHandler.ContractListWrapper>.class);
                                 
            Date convertedDate= Date.valueOf(reviewDate);
            Integer day = convertedDate.day();
            Integer month = convertedDate.month();
            Integer year = convertedDate.year();
            DateTime convertedDateTime = DateTime.newInstance(year, month, day);
            
            List<smagicinteract__smsmagic__c> lstSms = new List<smagicinteract__smsmagic__c>();
            Sms_Magic__c objSetting = Sms_Magic__c.getValues('CollectionSenderId');
            String senderId = objSetting.senderId__c;
            
            List<cnotify__Delivery_Detail__c> lstDeliveryDetail = new List<cnotify__Delivery_Detail__c>();
            
            if(objSetting != Null){
                cnotify__Delivery_Detail__c objdetail;
                smagicinteract__smsMagic__c objsms;
                for(BulkSMSContractListHandler.ContractListWrapper objContractWrapper : lstContractListWrapper){
                    if(objContractWrapper.sendSMS != null && objContractWrapper.sendSMS == true){
                        objdetail = new cnotify__Delivery_Detail__c();
                        objdetail.cnotify__Contract_Id__c = objContractWrapper.strRecordId;
                        objdetail.cnotify__Message__c = strSMSText;
                        objdetail.ScCollection_Communication_Type__c = 'Message';
                        objdetail.ScCollection_Is_Manual__c = true;
                        objdetail.cnotify__Account__c = objContractWrapper.strAccountID;
                        objdetail.cnotify__Contact__c = objContractWrapper.strContactID;
                        objdetail.cnotify__Sent_Date__c = System.Now();
                        objdetail.cnotify__Subject__c = 'BULK SMS';
                        String strDeliveryDetailName = (objContractWrapper.strContractName + '-' + objContractWrapper.strBorrower + '-BULK SMS');
                        if(strDeliveryDetailName.length() > 80){
                            strDeliveryDetailName = strDeliveryDetailName.substring(0,80);
                        }
                        objdetail.Name = strDeliveryDetailName;
                        lstDeliveryDetail.add(objdetail);
                        
                        objsms = new smagicinteract__smsMagic__c();
                        objsms.smagicinteract__SenderId__c = senderId;
                        objsms.smagicinteract__PhoneNumber__c = objContractWrapper.strBorrowerNo;
                        String strBorrowerName = objContractWrapper.strBorrower;
                        if(!String.IsBlank(strBorrowerName) && strBorrowerName.length() > 50){
                            strBorrowerName = strBorrowerName.substring(0,50);
                        }
                        objsms.smagicinteract__Name__c = strBorrowerName; // records name
                        objsms.smagicinteract__ObjectType__c = 'cnotify__Delivery_Detail__c'; // record type
                        objsms.smagicinteract__disableSMSOnTrigger__c = disableTrigger; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
                        objsms.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                        objsms.smagicinteract__SMSText__c = strSMSText;
                        objsms.ScCollection_Delivery_Detail__c = null;
                        objsms.ScCollection_Action_Code_Id__c = strActionCodeId;
                        objsms.ScCollection_Review_Date__c = convertedDateTime;
                        lstSms.add(objsms);
                    }
                }
                
                if(disableTrigger == 1){
                    String response = smagicinteract.ApexAPI.pushSMSCallout(lstsms);
                    system.debug(response );
                }
                sp = Database.setSavepoint();
                try{
                    insert lstDeliveryDetail;
                    integer i =0 ;
                    for(smagicinteract__smsMagic__c objSMSMagic : lstSms){
                        objSMSMagic.ScCollection_Delivery_Detail__c = lstDeliveryDetail[i].Id;
                        i++;
                    }
                    insert lstsms;
                }
                catch(exception e){
                    Database.rollback(sp);
                    system.debug(e.getStackTraceString());
                    objErrorWrapper.isError = true;
                    objErrorWrapper.message = 'Error !! ' + e.getMessage();
                    objErrorWrapper.strResults  = '';
                    return JSON.serialize(objErrorWrapper);
                }
                
                objErrorWrapper.isError = false;
                objErrorWrapper.message = 'Success';
                objErrorWrapper.strResults  = '';
                return JSON.serialize(objErrorWrapper);
                
            }
            else{
                objErrorWrapper.isError = true;
                objErrorWrapper.message = 'Error !! No Sender Id found.';
                objErrorWrapper.strResults  = '';
                return JSON.serialize(objErrorWrapper);
            }
        }
        catch(exception ex){
            system.debug(ex.getStackTraceString());
            objErrorWrapper.isError = true;
            objErrorWrapper.message = 'Error !! ' + ex.getMessage();
            objErrorWrapper.strResults  = '';
            return JSON.serialize(objErrorWrapper);
        }
    }
}