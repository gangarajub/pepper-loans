public class DirectDebitCreateWrapper{
    //Wrapper and Variable use for Create Direct Debit call.
    
    public AuditInformation auditInformation;
    public PaymentInformation paymentInformation;
    
    public class AuditInformation {
        public String audituser; //sandip
        public String auditdate;    //2017-12-18
        
        public AuditInformation(String audituser, String auditdate){
            this.audituser = audituser;
            this.auditdate = auditdate;
        }
        
    }
    public class PaymentInformation {
        public Decimal paymentAmount;   //8500
        public String frequencyType;    //Fortnightly
        public String effectiveDate;    //2017-12-25
        public Integer numberOfPayments;    //3
        public String startHoldDate;
        public String endHoldDate;
        public List<String> paymentDates;
        
        public PaymentInformation(Decimal paymentAmount,String frequencyType,String effectiveDate,
                                    Integer numberOfPayments,String startHoldDate,String endHoldDate,List<String> paymentDates){
            this.paymentAmount = paymentAmount;
            this.frequencyType = frequencyType;
            this.effectiveDate = effectiveDate;
            this.numberOfPayments = numberOfPayments;
            this.startHoldDate= startHoldDate;
            this.endHoldDate = endHoldDate;
            this.paymentDates = paymentDates;
        }
        
    }
    
}