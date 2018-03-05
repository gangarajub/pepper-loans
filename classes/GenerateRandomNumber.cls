public class GenerateRandomNumber{
    
    public String generateCRN(String loanId){
        System.debug('loanId'+loanId);
        Integer len = loanId.length();
        String subLoanId = loanId.subString(4,len);
       
        Integer [] wtArray=new Integer[]{01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};
        
        Integer i=0;
        Integer sum=0;
        do{
         if(i<subLoanId.length()){
             system.debug('='+subLoanId.substring(i,i+1));
            
             Integer a= Integer.valueOf(subLoanId.substring(i,i+1));
             Integer pr = a*wtArray[i];
             sum = sum+a*wtArray[i];
        }
           i=i+1;
       }while(i < subLoanId.length());
       
       Integer checkDigit = math.mod(sum, 10);
       String crnNumber = subLoanId +checkDigit;
       return crnNumber;
    }
    
    public String generateReferralCode(String loanName){
        String hashString = loanName+ String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
         
        String referelCode = hexDigest.subString(0,6);
        System.debug('hexDigest'+hexDigest.subString(0,6));
        return referelCode ;
    }

    
}