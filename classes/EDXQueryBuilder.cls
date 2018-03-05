public  class EDXQueryBuilder {   
    public static String createInterestQuery()
    {           
        return 'SELECT ID, name,' +  
            'Collateral__r.sent_for_registration__c,'+
            'Collateral__r.isDischarged__c, '+
            'loan__Loan__r.loan__Loan_Status__c,' +
            'loan__Loan__r.Is_Secured__c, '+
            'Collateral__c ' +                     
            'FROM loan__Loan_Collateral__c ' +            
            'WHERE Collateral__r.isDischarged__c=false and Collateral__r.active__c=true '+
            'and Collateral__r.sent_for_registration__c =false and '+               
            'loan__Loan__r.Is_Secured__c = true and '+
            'loan__Loan__r.loan__Loan_Status__c LIKE '+ '\''+ 'Active%' +'\'';            
        
    }
    public static String createDisQuery(){
        return 'SELECT ID, name,' +  
            'Collateral__r.sent_for_registration__c,'+
            'Collateral__r.isDischarged__c, '+
            'loan__Loan__r.loan__Loan_Status__c,' +
            'Collateral__c ' +                     
            'FROM loan__Loan_Collateral__c ' +            
            'WHERE Collateral__r.isDischarged__c=false and Collateral__r.active__c=true '+
            'and Collateral__r.sent_for_registration__c =true and '+      
            'loan__Loan__r.Is_Secured__c = true and '+
            'loan__Loan__r.loan__Loan_Status__c = '+ '\''+ 'Closed - Obligations met' +'\'';            
        
    }
 /*   public static String createStatQuery(){
        return 'SELECT ID, name,' +  
            'registrationIds__c, '+
            'EDX_Register_Interest__r.Collateral__r.EDXRegNumber__c, '+
            'EDX_Register_Interest__r.Collateral__r.sent_for_registration__c, '+
            'EDX_Register_Interest__r.Collateral__r.isDischarged__c,' +
            'EDX_Register_Interest__r.Collateral__c ' +                     
            'FROM Edx_Register_Data__c ' +            
            'WHERE EDX_Register_Interest__r.Collateral__r.EDXRegNumber__c =null '+
            '  and registrationIds__c !=null '+
            'and EDX_Register_Interest__r.Collateral__r.sent_for_registration__c =true'; 
    }*/
    public static String createStatQuery(){
        return 'SELECT ID, name,' +  
            'Collateral__r.sent_for_registration__c,'+
            'Collateral__r.isDischarged__c, '+
            'loan__Loan__r.loan__Loan_Status__c,' +
            'Collateral__c ' +                     
            'FROM loan__Loan_Collateral__c ' +            
            'WHERE Collateral__r.isDischarged__c=false and Collateral__r.active__c=true '+
            'and Collateral__r.sent_for_registration__c =true and '+  
            'loan__Loan__r.Is_Secured__c = true and '+
            'Collateral__r.EDXRegNumber__c=NULL and '+
            'loan__Loan__r.loan__Loan_Status__c LIKE '+ '\''+ 'Active%' +'\'';     
    }
    
}