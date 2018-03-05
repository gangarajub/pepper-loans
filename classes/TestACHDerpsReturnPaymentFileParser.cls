@isTest
public class TestACHDerpsReturnPaymentFileParser {
   
    public static testmethod void testAnnually(){
        String fileContent = '0                 01WBC       WESTPAC BANKING CORP.     500145            230817032-797208496 \n'
                              + '2032-797208496   6130000011102TANYA NICOLE ROBERTS            LPT-000011160     062-544 10357133PEPPER GROUP    21500145PEPPER FINANCE CORPORATION210817\n'
                              + '7999-999            000042483900000000000000424839                        000008';
                              
        ACHDerpsReturnPaymentFileParser achh = new ACHDerpsReturnPaymentFileParser();
        achh.parseFile(fileContent, '');

    }

}