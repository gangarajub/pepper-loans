public class pepBankStmtAPIResponse
{
    public cls_accounts[] accounts;
    public String user_token;   //920b0adb1139a95bbf353c0f8a861c65
    public class cls_accounts {
        public String accountHolder;    //Bob Smith
        public String name; //Transaction Account
        public String accountNumber;    //423897
        public String id;   //423897
        public String bsb;  //123-456
        public String balance;  //3.45
        public String available;    //3.45
    }
    public static pepBankStmtAPIResponse parse(String json){
        return (pepBankStmtAPIResponse) System.JSON.deserialize(json, pepBankStmtAPIResponse.class);
    }
/*
    static testMethod void testParse() {
        String json=        '{"accounts":[{"accountHolder":"Bob Smith","name":"Transaction Account","accountNumber":"423897","id":"423897","bsb":"123-456","balance":"3.45","available":"3.45"},{"accountHolder":"Robert Smith","name":"Savings Account","accountNumber":"7563435","id":"7563435","bsb":"123-456","balance":"23.45","available":"23.45"}],"user_token":"920b0adb1139a95bbf353c0f8a861c65"}';
        pepBankStmtAPIResponse obj = parse(json);
        System.assert(obj != null);
    }
*/
}