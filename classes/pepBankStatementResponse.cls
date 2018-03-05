public  class pepBankStatementResponse 
{
    public class bankSatementResponseSuccessorFailure
    {
        public pepBankStmtAPIResponse response;
        Public pepProfileHandler responseProfile;
        public Boolean success;
        public String message;
        Public Boolean ismfa;
        public bankSatementResponseSuccessorFailure(pepBankStmtAPIResponse response,Boolean success,String Message){
            this.response = response;
            this.success = success;
            this.message = message;
            this.ismfa=false;
        }
        public bankSatementResponseSuccessorFailure(pepProfileHandler responseProfile,Boolean success,String Message,String mfa){
        this.responseProfile=responseProfile;
        this.success = success;
        this.message = message;
        this.ismfa=True;
        }
    }
    public class bankStatemtnResponseStatemtnsresponse{
        public Map<String,Object> mapResponse;
        public Boolean success;
        public String message;
        
        public bankStatemtnResponseStatemtnsresponse(Map<String,Object> mapResponse,Boolean success,String Message){
            this.mapResponse = mapResponse;
            this.success = success;
            this.message = message;
        }
    }
}