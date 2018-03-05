public class ServiceabilityCalcCtrl{
    
    public static genesis__Applications__c app;
    static String  appId;
    public ServiceabilityCalcCtrl(String applicationId){
        appId = applicationId;
       
        app = [select id from genesis__Applications__c where Id=:appId];
    }

    public static genesis__Applications__c callVedaServices(){
        List<Residential_Address__c> resAdd = [select Id , postcode__c from Residential_Address__c where Application__c = :appId and Current_Address__c = true];
        
        if(resAdd.size()>0){
            List<Invalid_Postcodes__c> invPostcodeRecs = [select Id, post_code__c from Invalid_Postcodes__c where post_code__c = :resAdd[0].Postcode__c];
            if(invPostCodeRecs.size()>0){
                app.genesis__Status__c = 'Declined';
                app.Decline_Reason__c = 'POSTCODE_DECLINE';
                app.Serviceability_Status__C = 'Declined';
                update app;
                return app;
            }
        }
        
        
        
        try{
            List<Decisioning_Configuration__c> configs = [select id,Name,Active__c,Callout_Class_Name__c,
                                            Decision_Field_Name__c,Order__c,Parser_Class_Name__c,Response_Class_Name__c from Decisioning_Configuration__c
                                            where Active__c = true and Type__c = 'PRE-CONTRACT' order by Order__c asc ];
            Map<String,Decisioning_Configuration__c> configMap = new Map<String,Decisioning_Configuration__c>();
            VedaResponse resp = new VedaResponse();
            resp.app=app;
            
            // Here calling various services 
            if(configs.size()>0){
                for(Decisioning_Configuration__c config:configs){
                    Type t = Type.forName(null,config.Callout_Class_Name__c);
                    if(t == null){
                        //throw exception for invalid class name
                    }
                    IService impl = (IService)t.newInstance();
                    System.debug('resp'+resp);
                    impl.setRequest(config.id,resp);
                    resp = impl.getResponse();
                    System.debug('resp'+resp); 
                    configMap.put(config.id,config);  
                }
            }
            
            if(configs.size()>0 && resp.serviceIdToResponse.keySet().size()>0){
                for(String configId:resp.serviceIdToResponse.keySet()){
                    if(configMap.get(configId)!=null && resp.serviceIdToResponse.get(configId)!=null){
                        if(configMap.get(configId).Parser_Class_Name__c!=null && configMap.get(configId).Response_Class_Name__c!=null){
                            Type t = Type.forName(null,configMap.get(configId).Parser_Class_Name__c);
                            IParser impl = (IParser)t.newInstance();
                            impl.parseResponse(resp.serviceIdToResponse.get(configId),configMap.get(configId).Response_Class_Name__c,appId);
                        }
                        
                    }
                }
            }
            //give another status in case of credit not pulled or each status for each pull
            resp.app.genesis__Status__c = 'NEW - CREDIT PULLED';
            resp.app.Serviceability_Status__C = 'In-Progress';
            update resp.app;
            app = resp.app;
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        
        return app;
        
    }
    
    
    
    @future(callout=true)
    public static void doCreditCheckAndServiceability(String applicationId){
        appId = applicationId;
        
        app = [select id from genesis__Applications__c where Id=:appId];
        callVedaServices();
    }
    
    @future(callout=true)
    public static void doPostContractVedaCallout(String applicationId){
        appId = applicationId;
        
        app = [select id from genesis__Applications__c where Id=:appId];
        postContractCallVedaServices();
    }
    
    public static genesis__Applications__c postContractCallVedaServices(){
        
        try{
            List<Decisioning_Configuration__c> configs = [select id,Name,Active__c,Callout_Class_Name__c,
                                            Decision_Field_Name__c,Order__c,Parser_Class_Name__c,Response_Class_Name__c from Decisioning_Configuration__c
                                            where Active__c = true and Type__c = 'POST-CONTRACT' order by Order__c asc ];
            Map<String,Decisioning_Configuration__c> configMap = new Map<String,Decisioning_Configuration__c>();
            VedaResponse resp = new VedaResponse();
            resp.app=app;
            
            // Here calling various services 
            if(configs.size()>0){
                for(Decisioning_Configuration__c config:configs){
                    Type t = Type.forName(null,config.Callout_Class_Name__c);
                    if(t == null){
                        //throw exception for invalid class name
                    }
                    IService impl = (IService)t.newInstance();
                    System.debug('resp'+resp);
                    impl.setRequest(config.id,resp);
                    resp = impl.getResponse();
                    System.debug('resp'+resp); 
                    configMap.put(config.id,config);  
                }
            }
            
            if(configs.size()>0 && resp.serviceIdToResponse.keySet().size()>0){
                for(String configId:resp.serviceIdToResponse.keySet()){
                    if(configMap.get(configId)!=null && resp.serviceIdToResponse.get(configId)!=null){
                        if(configMap.get(configId).Parser_Class_Name__c!=null && configMap.get(configId).Response_Class_Name__c!=null){
                            Type t = Type.forName(null,configMap.get(configId).Parser_Class_Name__c);
                            IParser impl = (IParser)t.newInstance();
                            impl.parseResponse(resp.serviceIdToResponse.get(configId),configMap.get(configId).Response_Class_Name__c,appId);
                        }
                        
                    }
                }
            }
            //give another status in case of credit not pulled or each status for each pull
            //resp.app.genesis__Status__c = 'NEW - CREDIT PULLED';
            //resp.app.Serviceability_Status__C = 'In-Progress';
            update resp.app;
            app = resp.app;
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        
        return app;
        
    }
    
    
}