global class pepTimeBusinessHour implements Database.Batchable<sObject>,Database.Stateful{
    
    global Database.queryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator('select id,CreatedDate,genesis__New_Value__c,pepSLAinHour__c,Business_Hour__c,genesis__Application__c from genesis__Application_Status_History__c where pepSLAinHour__c=null ');
        
    }
    
    global void execute(Database.BatchableContext BC,List<sObject> scope){
        
        List<genesis__Application_Status_History__c> listOfApplicationStatus= (List<genesis__Application_Status_History__c>)scope;
        System.debug(listOfApplicationStatus+'%%%%%%%%');
        BusinessHours bh = [select id,name from businesshours where IsDefault=true];
        DateTime appStartDate;
        DateTime appEndDate;
        decimal Difference;
        decimal DifferenceHour;
        List<genesis__Application_Status_History__c> lstApplicationStatusHistory = new List<genesis__Application_Status_History__c>();
        Set<id> setID = new Set<id>();
        for(genesis__Application_Status_History__c objApplicationStatus : listOfApplicationStatus){
            
            if(objApplicationStatus.genesis__Application__c !=null){
                
                setID.add(objApplicationStatus.genesis__Application__c);   
            }
        }
        List<genesis__Applications__c> lstApp = new List<genesis__Applications__c>();
        if(setID.size()!=null && setID.size()>0){
            lstApp = [Select id,CreatedDate from genesis__Applications__c 
                                                           where id in : setID];
                                                           
        
            System.debug('%%%%%%%%%%55'+lstApp);
        }
        
                                                                        
        Map<id,DateTime> mapID = new Map<Id,DateTime>();
        if(lstApp.size()!=null && lstApp.size()>0){
            for(genesis__Applications__c objApplication : lstApp){
            
                    mapID.put(objApplication.id,objApplication.CreatedDate); 
                
            }   
        }
        
        if(mapId.size() !=null){
            for(genesis__Application_Status_History__c objApplicationStatus : listOfApplicationStatus){
                integer a =0;
                decimal b=0;
                decimal c=0;
                integer x =0;
                appStartDate=mapID.get(objApplicationStatus.genesis__Application__c);
                appEndDate=objApplicationStatus.CreatedDate;
                if(appStartDate != null && appEndDate !=null){
                Difference = BusinessHours.diff(bh.id, appStartDate, appEndDate);
                DifferenceHour=(difference/(1000*60*60));
                
               objApplicationStatus.pepSLAinHour__c=DifferenceHour;
                
                System.debug('DifferenceHour='+DifferenceHour);
                a = integer.valueof(DifferenceHour/8.50);
                System.debug('a='+a);
                b = a * 8.50;
                System.debug('b='+b);
                c = DifferenceHour - b ;
                System.debug('c='+c.SetScale(2));
                //System.debug(string.valueof(c.SetScale(2)).split('.'));
                string[] abc = string.valueof(c.SetScale(2)).split('\\.');
                system.debug(abc);
                
                if(abc.size() >=2){
                    x = (integer.valueof(abc[1]) * 60)/100;
                    System.debug('c='+c.SetScale(2));
                    system.debug('objApplicationStatus-----|'+a+':'+abc[0]+':'+x);
                    objApplicationStatus.Business_Hour__c=a+':'+abc[0]+':'+x;
                    objApplicationStatus.Business_Days__c=a;
                    
                    lstApplicationStatusHistory.add(objApplicationStatus);
                }
                else{                   
                    objApplicationStatus.Business_Hour__c=a+':'+0+':'+0;
                    objApplicationStatus.Business_Days__c=a;
                    lstApplicationStatusHistory.add(objApplicationStatus);              
                }
                
               // objApplicationStatus.Business_Hour__c = DifferenceHour;
                //lstApplicationStatusHistory.add(objApplicationStatus);
                //System.debug('deiffff'+DifferenceHour);
                }
            }
        }
        
        if(lstApplicationStatusHistory.size()!=null && lstApplicationStatusHistory.size()>0){
        System.debug(lstApplicationStatusHistory);
            update lstApplicationStatusHistory;
        }       
    }
    
    global void finish(Database.BatchableContext BC){
      pepTotalTimeStatusChange objpepTotalTimeStatusChangeBatch= new pepTotalTimeStatusChange();
      Id BatchTotalTimeStatusChange = Database.executeBatch(objpepTotalTimeStatusChangeBatch,50);
    }
}