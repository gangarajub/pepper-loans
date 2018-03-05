global class VedaServices{
    
    public genesis__Applications__c app;
    String appId;
    
    public VedaServices(String applicationId){
        this.appId = applicationId;
        System.debug('app'+this.appId);
        app = [select id from genesis__Applications__c where Id=:appId];
    }
    public genesis__Applications__c  vedaComprehensive(){
        List<Decisioning_Configuration__c> configs = [select id,Name,Active__c,Callout_Class_Name__c,
                                            Decision_Field_Name__c,Order__c,Parser_Class_Name__c,Response_Class_Name__c from Decisioning_Configuration__c
                                            where name='Veda Comprehensive'];
            VedaResponse resp = new VedaResponse();
            Map<String,Decisioning_Configuration__c> configMap = new Map<String,Decisioning_Configuration__c>();
              
            resp.app=app;
       if(configs.size()>0){
                    Type t = Type.forName(null,configs[0].Callout_Class_Name__c);
                    if(t == null){
                        //throw exception for invalid class name
                    }
                    IService impl = (IService)t.newInstance();
                   
                    impl.setRequest(configs[0].id,resp);
                    resp = impl.getResponse();
                    System.debug('resp'+resp);  
                    configMap.put(configs[0].id,configs[0]);
                    Type t2 = Type.forName(null,configs[0].Parser_Class_Name__c);
                    IParser impl2 = (IParser)t2.newInstance();
                    impl2.parseResponse(resp.serviceIdToResponse.get(configs[0].Id),configMap.get(configs[0].Id).Response_Class_Name__c,appId);
       }
         update resp.app;
         app = requeryApplication(appId);
         
       return app;
    }
    
       public genesis__Applications__c  vedaFraud(){
        List<Decisioning_Configuration__c> configs = [select id,Name,Active__c,Callout_Class_Name__c,
                                            Decision_Field_Name__c,Order__c,Parser_Class_Name__c,Response_Class_Name__c from Decisioning_Configuration__c
                                            where name='Veda Fraud'];
            VedaResponse resp = new VedaResponse();
            Map<String,Decisioning_Configuration__c> configMap = new Map<String,Decisioning_Configuration__c>();
              
            resp.app=app;
       if(configs.size()>0){
                    Type t = Type.forName(null,configs[0].Callout_Class_Name__c);
                    if(t == null){
                        //throw exception for invalid class name
                    }
                    IService impl = (IService)t.newInstance();
                   
                    impl.setRequest(configs[0].id,resp);
                    resp = impl.getResponse();
                    System.debug('resp'+resp);  
                    configMap.put(configs[0].id,configs[0]);
                    Type t2 = Type.forName(null,configs[0].Parser_Class_Name__c);
                    IParser impl2 = (IParser)t2.newInstance();
                    impl2.parseResponse(resp.serviceIdToResponse.get(configs[0].Id),configMap.get(configs[0].Id).Response_Class_Name__c,appId);
       }
       update resp.app;
         app = requeryApplication(appId);
       return app;
    }
     public genesis__Applications__c  vedaIdMatrix(){
        List<Decisioning_Configuration__c> configs = [select id,Name,Active__c,Callout_Class_Name__c,
                                            Decision_Field_Name__c,Order__c,Parser_Class_Name__c,Response_Class_Name__c from Decisioning_Configuration__c
                                            where name='Veda IdMatrix'];
            VedaResponse resp = new VedaResponse();
            Map<String,Decisioning_Configuration__c> configMap = new Map<String,Decisioning_Configuration__c>();
              
            resp.app=app;
       if(configs.size()>0){
                    Type t = Type.forName(null,configs[0].Callout_Class_Name__c);
                    if(t == null){
                        //throw exception for invalid class name
                    }
                    IService impl = (IService)t.newInstance();
                   
                    impl.setRequest(configs[0].id,resp);
                    resp = impl.getResponse();
                    System.debug('resp'+resp);  
                    configMap.put(configs[0].id,configs[0]);
                    Type t2 = Type.forName(null,configs[0].Parser_Class_Name__c);
                    IParser impl2 = (IParser)t2.newInstance();
                    impl2.parseResponse(resp.serviceIdToResponse.get(configs[0].Id),configMap.get(configs[0].Id).Response_Class_Name__c,appId);
       }
       update resp.app;
         app = requeryApplication(appId);
       return app;
    }
    
    
    
     public genesis__Applications__c  dandBInt(){
        List<Decisioning_Configuration__c> configs = [select id,Name,Active__c,Callout_Class_Name__c,
                                            Decision_Field_Name__c,Order__c,Parser_Class_Name__c,Response_Class_Name__c from Decisioning_Configuration__c
                                            where name='DandB'];
            VedaResponse resp = new VedaResponse();
            Map<String,Decisioning_Configuration__c> configMap = new Map<String,Decisioning_Configuration__c>();
              
            resp.app=app;
       if(configs.size()>0){
                    Type t = Type.forName(null,configs[0].Callout_Class_Name__c);
                    if(t == null){
                        //throw exception for invalid class name
                    }
                    IService impl = (IService)t.newInstance();
                   
                    impl.setRequest(configs[0].id,resp);
                    resp = impl.getResponse();
                    System.debug('resp'+resp);  
                    configMap.put(configs[0].id,configs[0]);
                    Type t2 = Type.forName(null,configs[0].Parser_Class_Name__c);
                    IParser impl2 = (IParser)t2.newInstance();
                    impl2.parseResponse(resp.serviceIdToResponse.get(configs[0].Id),configMap.get(configs[0].Id).Response_Class_Name__c,appId);
       }
       update resp.app;
         app = requeryApplication(appId);
       return app;
    }
    webservice static String webServiceVedaComprehensive(String appId){
     VedaServices v = new VedaServices(appId);
         genesis__Applications__c  f = v.vedaComprehensive();
        System.debug('fcompre'+f);
       return 'successful';
       
      }
      
      webservice static String webServiceVedaFraud(String appId){
     VedaServices v = new VedaServices(appId);
         genesis__Applications__c  f = v.vedaFraud();
        System.debug('fraud'+f);
       return 'successful';
       
      }
      webservice static String webServiceVedaIdMatrix(String appId){
     VedaServices v = new VedaServices(appId);
         genesis__Applications__c  f = v.vedaIdMatrix();
        System.debug('fidmatrix'+f);
       return 'successful';
       
      }
      
       webservice static String webServiceDanB(String appId){
         VedaServices v = new VedaServices(appId);
       
          genesis__Applications__c  f = v.dandBInt();
        
        System.debug('fcompre'+f);
      return 'successful';
       
      }

     webservice static String  webServiceVedall(String appId){
     ServiceabilityCalcCtrl.doCreditCheckAndServiceability(appId);
        
       return 'Serviceability is in Progress.';
       
      }
      
      
       public genesis__Applications__c requeryApplication(String appId){
        return app;
    }
    
    
 }