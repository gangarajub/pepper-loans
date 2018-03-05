global class DeclineApp{
    
    public genesis__Applications__c app;
    String appId;
    
    webservice static String  webDeclinel(String appId){
        list<genesis__Applications__c> app = [select genesis__Product_Type__c,CL_Contract__c,genesis__Status__c,Decline_Reason__c,genesis__Lending_Product__r.Name from genesis__Applications__c where Id=:appId limit 1];
        
        if(app.size()>0){
            if(app[0].CL_Contract__c==null){
               app[0].genesis__Status__c='DECLINED';
               app[0].Decline_Reason__c = 'NORMAL DECLINE';
               update app[0];
            }else{
             return 'Application has already been converted into Contract';
         }
            
        }
        return 'Successfully Declined';
     }
    
    
    webservice static String  declineDudetoBadCreditReport(String appId){
        list<genesis__Applications__c> app = [select genesis__Product_Type__c,CL_Contract__c,genesis__Status__c,Decline_Reason__c,genesis__Lending_Product__r.Name from genesis__Applications__c where Id=:appId limit 1];
        
        if(app.size()>0){
            if(app[0].CL_Contract__c==null){
               app[0].genesis__Status__c='DECLINED';
               app[0].Decline_Reason__c = 'CREDIT DECLINE';
               update app[0];
            }else{
             return 'Application has already been converted into Contract';
         }
            
        }
        return 'Successfully Declined';
     }
    
  
      
    
 }