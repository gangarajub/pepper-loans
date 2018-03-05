@isTest
public class TestBankStatementParser{
    
    public static testmethod void parseBankStatement(){
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application;         
        String str='<xml> ' + 
            '    <accounts> ' + 
            '        <nab> ' + 
            '            <accounts> ' + 
            '                <account> ' + 
            '                    <accountHolder>Mary Jones</accountHolder> ' + 
            '                    <name>Transaction Account</name> ' + 
            '                    <accountNumber>123456789</accountNumber> ' + 
            '                    <id>456789</id> ' + 
            '                    <bsb>789999</bsb> ' + 
            '                    <balance>123.45</balance> ' + 
            '                    <available>123.45</available> ' + 
            '                    <statementData> ' + 
            '                        <details> ' + 
            '                            <detail> ' + 
            '                                <dateObj> ' + 
            '                                    <date>2016-04-06 21:43:03.000000</date> ' + 
            '                                    <timezone_type>3</timezone_type> ' + 
            '                                    <timezone>Australia/Sydney</timezone> ' + 
            '                                </dateObj> ' + 
            '                                <date>07-04-2016</date> ' + 
            '                                <text>Interest - current rate is 1.05%</text> ' + 
            '                                <notes/> ' + 
            '                                <amount>0</amount> ' + 
            '                                <type>Credit</type> ' + 
            '                                <balance>123.45</balance> ' + 
            '                                <tags> ' + 
            '                                    <tag>Income</tag> ' + 
            '                                </tags> ' + 
            '                            </detail> ' + 
            '                            <detail> ' + 
            '                                <dateObj> ' + 
            '                                    <date>2016-04-06 21:43:03.000000</date> ' + 
            '                                    <timezone_type>3</timezone_type> ' + 
            '                                    <timezone>Australia/Sydney</timezone> ' + 
            '                                </dateObj> ' + 
            '                                <date>07-04-2016</date> ' + 
            '                                <text>Direct Debit 428198 FERRATUM 11813938</text> ' + 
            '                                <notes/> ' + 
            '                                <amount>199.14</amount> ' + 
            '                                <type>Debit</type> ' + 
            '                                <balance>123.45</balance> ' + 
            '                                <tags> ' + 
            '                                    <tag>Loans</tag> ' + 
            '                                    <tag>Short Term Lender</tag> ' + 
            '                                </tags> ' + 
            '                            </detail> ' + 
            '                            <detail> ' + 
            '                                <dateObj> ' + 
            '                                    <date>2016-04-05 21:43:03.000000</date> ' + 
            '                                    <timezone_type>3</timezone_type> ' + 
            '                                    <timezone>Australia/Sydney</timezone> ' + 
            '                                </dateObj> ' + 
            '                                <date>07-04-2016</date> ' + 
            '                                <text>A different loan payment</text> ' + 
            '                                <notes/> ' + 
            '                                <amount>35.25</amount> ' + 
            '                                <type>Debit</type> ' + 
            '                                <balance>322.59</balance> ' + 
            '                                <tags> ' + 
            '                                    <tag>Loans</tag> ' + 
            '                                    <tag>Rent</tag> ' + 
            '                                </tags> ' + 
            '                            </detail> ' + 
            '                        </details> ' + 
            '                        <totalCredits>19283.29</totalCredits> ' + 
            '                        <totalDebits>-17191.60</totalDebits> ' + 
            '                        <openingBalance>-1968.24</openingBalance> ' + 
            '                        <closingBalance>123.45</closingBalance> ' + 
            '                        <startDate>12-09-2015</startDate> ' + 
            '                        <endDate>07-04-2016</endDate> ' + 
            '                        <minBalance>-2935.54</minBalance> ' + 
            '                        <maxBalance>2427.56</maxBalance> ' + 
            '                        <dayEndBalances> ' + 
            '                            <dayEndBalance> ' + 
            '                                <date>2016-04-07</date> ' + 
            '                                <balance>123.45</balance> ' + 
            '                            </dayEndBalance> ' + 
            '                             ' + 
            '                        </dayEndBalances> ' + 
            '                        <minDayEndBalance>-2935.54</minDayEndBalance> ' + 
            '                        <daysInNegative>72</daysInNegative> ' + 
            '                        <errorMessage/> ' + 
            '                        <transactionObjects> ' + 
            '                            <transactionObject/> ' + 
            '                            <transactionObject/> ' + 
            '                            <transactionObject/> ' + 
            '                        </transactionObjects> ' + 
            '                        <analysis> ' + 
            '                            <Income> ' + 
            '                                <total> ' + 
            '                                    <transactionCount>39</transactionCount> ' + 
            '                                    <totalValue>9400.84</totalValue> ' + 
            '                                    <monthAvg>1342.9771428571</monthAvg> ' + 
            '                                </total> ' + 
            '                                <Wages> ' + 
            '                                    <transactionCount>31</transactionCount> ' + 
            '                                    <totalValue>7853.48</totalValue> ' + 
            '                                    <monthAvg>1121.9257142857</monthAvg> ' + 
            '                                    <minValue>50.85</minValue> ' + 
            '                                    <maxValue>497.35</maxValue> ' + 
            '                                    <firstTransaction>27-03-2016</firstTransaction> ' + 
            '                                    <lastTransaction>22-09-2015</lastTransaction> ' + 
            '                                    <period>6.0967741935484</period> ' + 
            '                                    <periodIsRegular>0</periodIsRegular> ' + 
            '                                    <transactions> ' + 
            '                                        <transaction> ' + 
            '                                            <dateObj> ' + 
            '                                                <date>2016-03-25 21:43:03.000000</date> ' + 
            '                                                <timezone_type>3</timezone_type> ' + 
            '                                                <timezone>Australia/Sydney</timezone> ' + 
            '                                            </dateObj> ' + 
            '                                            <date>27-03-2016</date> ' + 
            '                                            <text>EXT TRANS REF:1234 Payment for Wages 24/04/2015 - thanks for the great work number 24</text> ' + 
            '                                            <notes/> ' + 
            '                                            <amount>198</amount> ' + 
            '                                            <type>Credit</type> ' + 
            '                                            <balance>460.94</balance> ' + 
            '                                            <tags> ' + 
            '                                                <tag>Income</tag> ' + 
            '                                            </tags> ' + 
            '                                        </transaction> ' +
            '                                       </transactions> ' +  
            '                          </Wages> ' + 
            '                                  <Rent> ' + 
            '                                    <transactionCount>0</transactionCount> ' + 
            '                                    <totalValue>0</totalValue> ' + 
            '                                    <monthAvg>0</monthAvg> ' + 
            '                                    <minValue>0</minValue> ' + 
            '                                    <maxValue>0</maxValue> ' + 
            '                                    <firstTransaction/> ' + 
            '                                    <lastTransaction/> ' + 
            '                                    <period>0</period> ' + 
            '                                    <periodIsRegular>1</periodIsRegular> ' + 
            '                                    <transactions> ' + 
            '                                        <transaction> ' + 
            '                                            <dateObj> ' + 
            '                                                <date>2016-03-25 21:43:03.000000</date> ' + 
            '                                                <timezone_type>3</timezone_type> ' + 
            '                                                <timezone>Australia/Sydney</timezone> ' + 
            '                                            </dateObj> ' + 
            '                                            <date>27-03-2016</date> ' + 
            '                                            <text>EXT TRANS REF:1234 Payment for Wages 24/04/2015 - thanks for the great work number 24</text> ' + 
            '                                            <notes/> ' + 
            '                                            <amount>198</amount> ' + 
            '                                            <type>Credit</type> ' + 
            '                                            <balance>460.94</balance> ' + 
            '                                            <tags> ' + 
            '                                                <tag>Income</tag> ' + 
            '                                            </tags> ' + 
            '                                        </transaction> ' +
            '                                       </transactions> ' +  
            '                      </Rent> ' + 
            '                      </Income> ' + 
            '                       <Benefits> ' + 
            '                <total> ' + 
            '                  <transactionCount>0</transactionCount> ' + 
            '                  <totalValue>0</totalValue> ' + 
            '                  <monthAvg>0</monthAvg> ' + 
            '                </total> ' + 
            '                <MaternityPayment> ' + 
            '                  <transactionCount>0</transactionCount> ' + 
            '                  <totalValue>0</totalValue> ' + 
            '                  <monthAvg>0</monthAvg> ' + 
            '                  <minValue>0</minValue> ' + 
            '                  <maxValue>0</maxValue> ' + 
            '                  <firstTransaction/> ' + 
            '                  <lastTransaction/> ' + 
            '                  <period>0</period> ' + 
            '                  <periodIsRegular>1</periodIsRegular> ' + 
            '                  <transactions> ' + 
            '                                        <transaction> ' + 
            '                                            <dateObj> ' + 
            '                                                <date>2016-03-25 21:43:03.000000</date> ' + 
            '                                                <timezone_type>3</timezone_type> ' + 
            '                                                <timezone>Australia/Sydney</timezone> ' + 
            '                                            </dateObj> ' + 
            '                                            <date>27-03-2016</date> ' + 
            '                                            <text>EXT TRANS REF:1234 Payment for Wages 24/04/2015 - thanks for the great work number 24</text> ' + 
            '                                            <notes/> ' + 
            '                                            <amount>198</amount> ' + 
            '                                            <type>Credit</type> ' + 
            '                                            <balance>460.94</balance> ' + 
            '                                            <tags> ' + 
            '                                                <tag>Income</tag> ' + 
            '                                            </tags> ' + 
            '                                        </transaction> ' +
            '                                       </transactions> ' +   
            '                </MaternityPayment> ' + 
            '                <FamilyBenefits> ' + 
            '                  <transactionCount>0</transactionCount> ' + 
            '                  <totalValue>0</totalValue> ' + 
            '                  <monthAvg>0</monthAvg> ' + 
            '                  <minValue>0</minValue> ' + 
            '                  <maxValue>0</maxValue> ' + 
            '                  <firstTransaction/> ' + 
            '                  <lastTransaction/> ' + 
            '                  <period>0</period> ' + 
            '                  <periodIsRegular>1</periodIsRegular> ' + 
            '                  <transactions/> ' + 
            '                </FamilyBenefits> ' + 
            '              </Benefits> ' + 
            '<Dishonours>'+
            '<total>'+
            '<transactionCount>11</transactionCount>'+
            '<totalValue>2780.9</totalValue>'+
            '<monthAvg>397.27142857143</monthAvg>'+
            '</total>'+
            '<Overdrawn>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</Overdrawn>'+
            '<Dishonour>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</Dishonour>'+
            '<Return>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</Return>'+
            '<Reversal>'+
            '<transactionCount>11</transactionCount>'+
            '<totalValue>2780.9</totalValue>'+
            '<monthAvg>397.27142857143</monthAvg>'+
            '<minValue>70.37</minValue>'+
            '<maxValue>468.76</maxValue>'+
            '<firstTransaction>17-03-2016</firstTransaction>'+
            '<lastTransaction>12-10-2015</lastTransaction>'+
            '<period>14.909090909091</period>'+
            '<periodIsRegular>0</periodIsRegular>'+
            '<transactions>'+
            '<transaction>'+
            '<dateObj>'+
            '<date>2016-03-13 21:43:03.000000</date>'+
            '<timezone_type>3</timezone_type>'+
            '<timezone>Australia/Sydney</timezone>'+
            '</dateObj>'+
            '<date>17-03-2016</date>'+
            '<text>Direct RVSL 301500 Ferratum Austral Loan 419913</text>'+
            '<notes/>'+
            '<amount>234.96</amount>'+
            '<type>Credit</type>'+
            '<balance>1427.45</balance>'+
            '<tags>'+
            '<tag>Dishonours</tag>'+
            '</tags>'+
            '</transaction>'+
            '<transaction>'+
            '<dateObj>'+
            '<date>2016-03-09 21:43:03.000000</date>'+
            '<timezone_type>3</timezone_type>'+
            '<timezone>Australia/Sydney</timezone>'+
            '</dateObj>'+
            '<date>10-03-2016</date>'+
            '<text>Direct RVSL 301500 Ferratum Austral Loan 419913</text>'+
            '<notes/>'+
            '<amount>468.76</amount>'+
            '<type>Credit</type>'+
            '<balance>-3.83</balance>'+
            '<tags>'+
            '<tag>Dishonours</tag>'+
            '</tags>'+
            '</transaction>'+
            '</transactions>'+
            '</Reversal>'+
            '</Dishonours>'+
            '<Gambling>'+
            '<total>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '</total>'+
            '<AusBet>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</AusBet>'+
            '<Bet365>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</Bet365>'+
            '<BetFair>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</BetFair>'+
            '<BetStar>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</BetStar>'+
            '<Bookmaker>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</Bookmaker>'+
            '<Centrebet>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</Centrebet>'+
            '<ClassicBet>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</ClassicBet>'+
            '<CrownBet>'+
            '<transactionCount>0</transactionCount>'+
            '<totalValue>0</totalValue>'+
            '<monthAvg>0</monthAvg>'+
            '<minValue>0</minValue>'+
            '<maxValue>0</maxValue>'+
            '<firstTransaction/>'+
            '<lastTransaction/>'+
            '<period>0</period>'+
            '<periodIsRegular>1</periodIsRegular>'+
            '<transactions/>'+
            '</CrownBet>'+
            '</Gambling>'+
            '                        </analysis> ' + 
            '                    </statementData> ' + 
            '                    <institution>Commonwealth Bank</institution> ' + 
            '                </account> ' + 
            '            </accounts> ' + 
            '        </nab> ' + 
            '    </accounts> ' + 
            '    <user_token>yxZ1QZ2ryr8Oby9EJxGp0Q</user_token> ' + 
            '</xml> ';
        Test.startTest();
        BankStatementParser  bn = new BankStatementParser();
        bn.parseAndInsertStatement(str,application.Id,'nab');
        Test.stopTest();
        List<Bank_Statement__c> bankstmt = [select id,name from Bank_Statement__c]; 
        System.assertEquals(bankstmt.size(),1);
    }
    public static testmethod void DeclineApp(){
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application;       
        Test.startTest();
        DeclineApp.webDeclinel(application.Id);
        List<genesis__applications__c> loanapp = [select id,name,genesis__Status__c from genesis__applications__c]; 
        System.assertEquals(loanapp[0].genesis__Status__c,'DECLINED');
        
        DeclineApp.declineDudetoBadCreditReport(application.Id);
        List<genesis__applications__c> loanapp1 = [select id,name,Decline_Reason__c,genesis__Status__c from genesis__applications__c]; 
        System.assertEquals(loanapp1[0].genesis__Status__c,'DECLINED');
        System.assertEquals(loanapp1[0].Decline_Reason__c ,'CREDIT DECLINE');
       
        Test.stopTest();
    }
    public static testmethod void generateScoreCard(){
        Account ac = genesis.TestHelper.createAccount();
        RetrieveCode__c rc = new RetrieveCode__c();
        rc.Code__c = 'AAB37706';
        insert rc;
        genesis__applications__c application = genesis.TestHelper.createLoanApplication();
        //application.Status_to_convert__c = 'APPROVED - DOCUMENT SIGNED';
        application.genesis__Account__c=ac.Id;
        update application;       
        Test.startTest();
        GenerateScoreCard.generateScorecard(application.Id);
        Test.stopTest();
    }
 }