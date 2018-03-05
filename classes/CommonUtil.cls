public class CommonUtil{
    
    public CommonUtil(){}
    
    //Prerequisite for application
      //Should have CL product
      //Should have Credit rating
      //Should have all widget parameters populated
    
    public static Decimal getInterestRateByAppId(String appId){
        List<genesis__Applications__c> apps = new List<genesis__Applications__c>();
        Decimal interestRate = 0;
        apps = queryApplication(appId);
        if(apps.size()==1){
            interestRate = getInterestRate(apps[0]);
        }
        return interestRate;
    }
    
    @InvocableMethod 
    public static list<boolean> getInterestRateByAppId(List<Id> appIds){
        Decimal interestRate = 0;
        if(appIds.size()>0){
            interestRate = CommonUtil.getInterestRateByAppId(String.valueOf(appIds[0]));
        }
        genesis__Applications__c app = [select id,genesis__Status__c,genesis__Interest_Rate__c from genesis__Applications__c where Id=:appIds[0] ];
        app.genesis__Interest_Rate__c = interestRate;
        app.genesis__Status__C = 'RATE CARD APPLIED';
        update app;
        system.debug(LoggingLevel.error,app.genesis__Status__c);
        List<boolean> retVal = new List<boolean>();
        return retVal;
    }
    
    public static Decimal getInterestRate(genesis__Applications__c app){
        Decimal interestRate = 0;
        mfiflexUtil.VOLog voLogInstance = mfiflexUtil.VOLog.getInstance('Neon');
        try{
        genesis__Applications__c applications = new genesis__Applications__c();
        List<Credit_Rating_Product_Junction__c> ratingProductJunctions = new List<Credit_Rating_Product_Junction__c>();
        
        if(app.genesis__CL_Product__c!=null && app.genesis__Credit_Rating__c!=null){
            ratingProductJunctions = [select id,Interest_Rate__c from Credit_Rating_Product_Junction__c where CL_Product__c=:app.genesis__Cl_Product__C and Credit_Rating_Matrix__c=: app.genesis__Credit_Rating__c limit 1];
        }
        if(ratingProductJunctions.size()>0){
            for(Credit_Rating_Product_Junction__c ratingJunc:ratingProductJunctions ){
                if(ratingJunc.Interest_Rate__c!=null){
                    interestRate += ratingJunc.Interest_Rate__c;
                }  
            }
        }
        
        System.debug('My Interest 1 : ' + interestRate );
        Schema.DescribeFieldResult dfr = Interest_Rate_Matrix__c.Field_API_Name__c.getDescribe();
        List<Schema.PicklistEntry> desFieldResults= dfr.getPicklistValues();
        
        System.debug('My Interest 2 : ' + desFieldResults);
        Map<String, Schema.SObjectField> fieldMapSchema = Schema.SObjectType.genesis__Applications__c.fields.getMap();
        
        Set<String> paramFields = new Set<String>();
        for(Schema.PicklistEntry entry:desFieldResults){
            if(fieldMapSchema.get(entry.getValue())!=null){
                paramFields.add(entry.getValue());
            }
        }
        System.debug('My Interest 3 : ' + paramFields);
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        if(ec.getObject('InterestRateMatrix')!=null){
            ec.deleteObject('InterestRateMatrix');
        }
        mfiflexUtil.ObjectCache intRateMatrix= ec.createObject('InterestRateMatrix',
                                                                 'Interest_Rate_Matrix__C',' ');
        intRateMatrix.addFields('Active__c,Credit_Rating_Matrix__c,Default_Interest_Rate__c,Field_API_Name__c,Field_Value__c,Interest_Rate_Delta__c');
        
        String whereClause='';
        //To store key and value for application's Interest rate parameters
        Map<String,String> fieldValueMap = new Map<String,String>();
        Set<String> finalFields = new Set<String>();
        Set<String> finalValues = new Set<String>();
        for(String field:paramFields){
            if(app.get(field)!=null){
                fieldValueMap.put(field,String.valueOf(app.get(field)));
                finalFields.add(field);
                finalValues.add(String.valueof(app.get(field)));
            }
        }
        intRateMatrix.addNamedParameter('finalFields',finalFields);
        intRateMatrix.addNamedParameter('finalValues',finalValues);
        whereClause = 'Field_API_Name__c IN:finalFields '+ 'AND' + ' Field_Value__c IN:finalValues'+' AND'+' Active__c=true';
         
        
        
        intRateMatrix.setWhereClause(whereClause);
        intRateMatrix.buildQuery();
        String query = intRateMatrix.getQuery();
        System.debug('query='+query);
         
        voLogInstance.logError(9001, 'query='+query);
        voLogInstance.committodb();
        List<Interest_Rate_Matrix__c> matrixRes= (List<Interest_Rate_Matrix__c>) intRateMatrix.executeQuery().getRecords();
        System.debug('My Interest 4 : ' + matrixRes);
        System.debug('My Interest 5 : ' + app);
        for(Interest_Rate_Matrix__c rateMatrix:matrixRes){
            
            if(String.valueOf(app.get(rateMatrix.Field_API_Name__c)).equalsIgnoreCase(fieldValueMap.get(rateMatrix.Field_API_Name__c))){
                if((rateMatrix.Credit_Rating_Matrix__c!=null && String.valueOf(app.genesis__Credit_Rating__c).equalsIgnoreCase(String.valueOf(rateMatrix.Credit_Rating_Matrix__c)))||(rateMatrix.Credit_Rating_Matrix__c == null)){
                    if(rateMatrix.Default_Interest_Rate__c != null){
                        interestRate = rateMatrix.Default_Interest_Rate__c;
                    }
                    else{
                        interestRate += rateMatrix.Interest_Rate_Delta__c;
                    }
                }
            }
        }
        voLogInstance.logError(9001, 'interestRate ='+interestRate );
        voLogInstance.committodb();
        }
        catch(Exception e){
           
           voLogInstance.logError(9001, 'Exception e' + e.getMessage() + ', ' + e.getLineNumber() + ', ' + e.getStackTraceString());
           voLogInstance.committodb();
        }
        return interestRate;   
    }
    
    public static List<genesis__Applications__c> queryApplication(String appId){
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        if(ec.getObject('ApplicationIR')!=null){
            ec.deleteObject('ApplicationIR');
        }
        mfiflexUtil.ObjectCache loanApplication= ec.createObject('ApplicationIR',
                                                                 'genesis__Applications__c',' ');
        String whereClause='';
        loanApplication.addNamedParameter('loanAppId',appId);
        SObjectType accountType = Schema.getGlobalDescribe().get('genesis__Applications__c');
        Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
        for(String field:mfields.keyset()){  
            loanApplication.addFields(field);
        }
        whereClause = 'Id=:loanAppId';
        loanApplication.setWhereClause(whereClause);
       
        loanApplication.buildQuery();
        String loansQuery = loanApplication.getQuery();
        System.debug('loansQuery='+loansQuery);
        List<genesis__Applications__c> loanApplicationRes= (List<genesis__Applications__c>) loanApplication.executeQuery().getRecords();
        
        return loanApplicationRes;
    }
    
    
    
}