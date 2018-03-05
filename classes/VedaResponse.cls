public class VedaResponse{
    public genesis__Applications__c app;
    public Map<String,ints.IntegrationResponseObject> serviceIdToResponse;
    public VedaResponse(){
        app = new genesis__Applications__c();
        serviceIdToResponse = new Map<String,ints.IntegrationResponseObject>();
    }
}