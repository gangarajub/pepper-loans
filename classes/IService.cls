public interface IService{
    
    void setRequest(String configId,VedaResponse vResp);
    
    VedaResponse getResponse();
    
}