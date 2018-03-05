public class pepInvokeCLMethodHelper
{
    // -------------------------------------------------------------------------------------------------
    // This class is used as a helper for Community pages that call CL method.
    // -------------------------------------------------------------------------------------------------
    // Created Date: 22-FEB-2016 Created By: Vipin Kumar Email: vipin.kumar@saasfocus.com
    // -------------------------------------------------------------------------------------------------
    
    //default constructor
    //public pepInvokeCLMethodHelper(){}
    
    //Method make call to CL API and return already existing application.
    //Note: Here child Object can have master-detail/look up relation with application
    //borrowerId is person account Id, pass value of allowedStatuses,additionalFields to null.
    public static List<genesis__Applications__c> fetchApplications(String borrowerId, String applicationId, String allowedStatuses, String additionalFields, Map<String,String> childObjects)
    {
        //call CL API
        genesis.BorrowerAPI3 bApi = genesis.APIFactory.getBorrowerAPI3();
        List<genesis__Applications__c> lstApps = bApi.getApplications(borrowerId,applicationId, allowedStatuses, additionalFields, 
                                                    childObjects);
        return lstApps;
    }
    
    //Method call CL API to insert application, related object and child object
    //Note: Here related object is object having look up on application 
    //And child object is object having master-detail/look up relation to application
    public static genesis__Applications__c insertApplication(genesis__Applications__c application,Map<String,Sobject> relatedObjects, Map<String,List<SObject>> childObjects)
    {
        genesis.BorrowerAPI3 bApi = genesis.APIFactory.getBorrowerAPI3();
        genesis__Applications__c app = bApi.createApplication(application, relatedObjects, childObjects);
        pepUtilityClass.updateLastsaved(app.id);
        return app;
    }
    
    //Method call CL API to update application & insert/update related object and child object
    //Note: Here related object is object having look up on application 
    //And child object is object having master-detail/look up relation to application
    public static genesis__Applications__c updateApplication(genesis__Applications__c application,Map<String,Sobject> relatedObjects, Map<String,List<SObject>> childObjects)
    {
        genesis.BorrowerAPI3 bApi = genesis.APIFactory.getBorrowerAPI3();
        genesis__Applications__c app = bApi.updateApplication(application, relatedObjects, childObjects);
        pepUtilityClass.updateLastsaved(app.id);
        return app;
        
    }
    
 
}