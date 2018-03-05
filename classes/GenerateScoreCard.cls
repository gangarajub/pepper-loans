global with sharing class GenerateScoreCard{

webservice static String generateScorecard(String applicationId){
        if(applicationId != null){
            try{
                genesis.ScorecardAPI.generateScorecard(applicationId);
                genesis__Applications__c loanApp = [select id,name,genesis__Status__c, Recalculated_Total_Score__c, Stored_Total_Score__c from genesis__Applications__c where id=:applicationId];
                System.debug('loanApp'+loanApp);
                
                loanApp.genesis__Status__c='NEW - SCORECARD GENERATED';
                loanApp.Stored_Total_Score__c = loanApp.Recalculated_Total_Score__c;
                update loanApp;
                
                /*genesis__Applications__c App = [select id,name,genesis__Status__c from genesis__Applications__c where id=:applicationId];
                App.genesis__Status__c='NEW - SCORECARD GENERATED';
                update App;
                System.debug('App'+App); */
                
                return 'Successfully generated scorecard';
            }catch(Exception e){
                System.debug('Exception'+e.getMessage());
                return e.getMessage();
            }
                                               
        }
        return 'Application Id found null';
    }   
}