global class pepTotalTimeStatusChange implements Database.Batchable<sObject>,Database.Stateful{
    
    global Database.queryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator('select id,CreatedDate,isStatusDoccumentSigned__c,pepApprovedDoccuSignedDate__c,turnArroundtimeDoccSigned__c,Credit_Pulled_Date__c,pepCredit_Pulled_To_Settelmet__c,pepBusiness_Time__c,pepBusiness_Days__c from genesis__Applications__c ');
        
    }
    
    global void execute(Database.BatchableContext BC,List<sObject> scope){
        
        List<genesis__Applications__c> lstApplication = (List<genesis__Applications__c>)scope;
        System.debug('%%%%Application'+lstApplication );
        set<ID> setID = new set<ID>();
        for(genesis__Applications__c objApp : lstApplication){
            
            if(objApp.id !=null){
                setID.add(objApp.id);
            
            }
        }
        
        List<genesis__Application_Status_History__c> lstStatusHistory= new List<genesis__Application_Status_History__c>();
        List<genesis__Applications__c> lstAppln = new List<genesis__Applications__c>();
        lstStatusHistory =  [Select id,genesis__Total_Time__c,CreatedDate,genesis__Application__c,genesis__New_Value__c,genesis__Old_value__c,Current_Status__c from genesis__Application_Status_History__c where genesis__Application__c in:setId order By Name asc];
        List<genesis__Application_Status_History__c> lstHistory = new List<genesis__Application_Status_History__c>();
        List<genesis__Application_Status_History__c> lstHistory1 = new List<genesis__Application_Status_History__c>();
        BusinessHours bh = [select id,name from businesshours where IsDefault=true];
        DateTime appStartDate;
        DateTime appEndDate;
        decimal Difference;
        decimal DifferenceHour;
        Map<Id,List<genesis__Application_Status_History__c>> MapApplicationIdToHistory = new Map<Id,List<genesis__Application_Status_History__c>>();
        for(genesis__Application_Status_History__c objStatusHistory :lstStatusHistory)
        {
            if(MapApplicationIdToHistory.get(objStatusHistory.genesis__Application__c) ==null)
            {
                MapApplicationIdToHistory.put(objStatusHistory.genesis__Application__c,new List<genesis__Application_Status_History__c >());
            }
            
            MapApplicationIdToHistory.get(objStatusHistory.genesis__Application__c).add(objStatusHistory);
        }
        
        List<genesis__Applications__c> lstApplicationtoUpdate = new List<genesis__Applications__c>();
        for(Id idApplication: MapApplicationIdToHistory.keyset())
        {       
                boolean isStatusDoccumentSigned=false;
                integer a =0;
                decimal b=0;
                decimal c=0;
                integer x =0;
                DateTime CreditPulledDate;
                DateTime ApprovedToContractDate;
                decimal DiffBwtCreditPulledAndContract;
                decimal DiffBtwCreditPulledAndContractHour;
           Boolean checkStatusCreditPulled=True;
           
           DateTime approvedDoccsignedDate;
           DateTime currentStatusDate;
           decimal DiffBwtDoccSignedAndCurrentStatus;
           decimal DiffBwtDoccSignedAndCurStatusinHour;
           boolean checkStatusDoccSigned = True;
           List<genesis__Application_Status_History__c> lstTempStatusHistory = MapApplicationIdToHistory.get(idApplication);
            for(Integer i=0;i<lstTempStatusHistory.Size();i++){
          //Calculating the time between status new credit pulled to approved doccument signed                    
                if(lstTempStatusHistory[i].genesis__New_Value__c =='NEW - CREDIT PULLED' && checkStatusCreditPulled==True)
                {
                    CreditPulledDate=lstTempStatusHistory[i].CreatedDate;
                    checkStatusCreditPulled=false;
                }
                if(lstTempStatusHistory[i].genesis__New_Value__c =='APPROVED - CONVERTED TO CONTRACT')
                {
                    ApprovedToContractDate=lstTempStatusHistory[i].CreatedDate;
                }
          //Calculating the time between status approved Doccument signed to current status       
                if(lstTempStatusHistory[i].genesis__New_Value__c =='APPROVED - DOCUMENT SIGNED' && checkStatusDoccSigned==True)
                {     
                    System.debug(lstTempStatusHistory[i].CreatedDate)  ;            
                    approvedDoccsignedDate=lstTempStatusHistory[i].CreatedDate;
                    isStatusDoccumentSigned= true;
                    checkStatusDoccSigned =False;
                }
                
                    if(i<lstTempStatusHistory.Size()-1){
                        appStartDate=lstTempStatusHistory[i].CreatedDate;
                        appEndDate=lstTempStatusHistory[i+1].CreatedDate;
                        if(appStartDate != null && appEndDate !=null){
                            Difference = BusinessHours.diff(bh.id, appStartDate, appEndDate);
                            DifferenceHour=(difference/(1000*60*60));
                            genesis__Application_Status_History__c obj = lstTempStatusHistory[i];
                            obj.Total_Time_Business_Hour__c = DifferenceHour;
                            obj.Current_Status__c=False;
                            genesis__Application_Status_History__c obj1 = lstTempStatusHistory[i+1];
                            obj1.Status_Movement_Time__c=DifferenceHour;
                            lstHistory.add(obj);
                            lstHistory1.add(obj1);
                        }                       
                    }    
                else{
                        currentStatusDate=lstTempStatusHistory[i].CreatedDate;
                        appEndDate= System.now();
                        appStartDate=lstTempStatusHistory[i].CreatedDate;
                    if(appStartDate != null && appEndDate !=null){
                            Difference = BusinessHours.diff(bh.id, appStartDate, appEndDate);
                            DifferenceHour=(difference/(1000*60*60));
                            genesis__Application_Status_History__c obj = lstTempStatusHistory[i];
                            obj.Total_Time_Business_Hour__c = DifferenceHour;
                            obj.Current_Status__c=True;
                            lstHistory.add(obj);
                        }      
                }
                   
            }
            
        if( isStatusDoccumentsigned ==True || CreditPulledDate != null && ApprovedToContractDate !=null && ApprovedToContractDate > =CreditPulledDate){ 
           
            genesis__Applications__c objApplication= new genesis__applications__c();
            objApplication.id=idApplication;
            system.debug(isStatusDoccumentsigned );
           
            if(isStatusDoccumentsigned == True){               
                  objApplication.isStatusDoccumentSigned__c=True;
                  
            }
            else{
                  objApplication.isStatusDoccumentSigned__c=False;
                  
            }
            
            if(approvedDoccsignedDate != null && currentStatusDate !=null && currentStatusDate> =approvedDoccsignedDate  ) 
            {
                System.debug(approvedDoccsignedDate+'&&&&&&'+currentStatusDate);
                DiffBwtDoccSignedAndCurrentStatus = BusinessHours.diff(bh.id, approvedDoccsignedDate, currentStatusDate);
                DiffBwtDoccSignedAndCurStatusinHour= (DiffBwtDoccSignedAndCurrentStatus/(1000*60*60));
                objApplication.pepApprovedDoccuSignedDate__c=approvedDoccsignedDate;
                objApplication.turnArroundtimeDoccSigned__c=DiffBwtDoccSignedAndCurStatusinHour;
            }  
            
            if(CreditPulledDate != null && ApprovedToContractDate !=null && ApprovedToContractDate > =CreditPulledDate){        
                            DiffBwtCreditPulledAndContract= BusinessHours.diff(bh.id, CreditPulledDate, ApprovedToContractDate);
                            DiffBtwCreditPulledAndContractHour=(DiffBwtCreditPulledAndContract/(1000*60*60));
                            a = integer.valueof(DiffBtwCreditPulledAndContractHour/9);
                            b = a * 9;
                            c = DiffBtwCreditPulledAndContractHour- b ;
                            string[] abc = string.valueof(c.SetScale(2)).split('\\.');
                            
                            objApplication.Credit_Pulled_Date__c=CreditPulledDate;
                            if(abc.size() >=2){
                                x = (integer.valueof(abc[1]) * 60)/100;
                                System.debug('c='+c.SetScale(2));
                                system.debug('objApplicationStatus-----|'+a+':'+abc[0]+':'+x);
                                objApplication.pepBusiness_Time__c=a+':'+abc[0]+':'+x;
                                objApplication.pepBusiness_Days__c=a;
                            }
                            else{                   
                                objApplication.pepBusiness_Time__c=a+':'+0+':'+0;
                                objApplication.pepBusiness_Days__c=a;
                                             
                            }
                                                       
                            objApplication.pepCredit_Pulled_To_Settelmet__c=DiffBtwCreditPulledAndContractHour;
                            
                        }
                            
                        lstApplicationtoUpdate.add(objApplication);
                   }                                   
        }
        if(lstHistory.Size()>0 && lstHistory.Size()!=null){
            update lstHistory;
        }
       
        
        if(lstApplicationtoUpdate.Size()>0 && lstApplicationtoUpdate.Size()!=null){
            update lstApplicationtoUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){
      pepMonthlyBudget objpepMonthlyBudgetBatch= new pepMonthlyBudget();
      Id BatchMonthlyBudget = Database.executeBatch(objpepMonthlyBudgetBatch,50);
    }
}