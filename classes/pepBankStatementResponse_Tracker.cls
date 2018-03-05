@isTest(SeeAllData=False)

private class pepBankStatementResponse_Tracker 
{
    @isTest static void pepBankStatementResponseTest0() 
    {
        pepBankStmtAPIResponse objBankStmt = new pepBankStmtAPIResponse();
        Map<String,Object> mapStr = new Map<String,Object>();
        mapStr.put('str',null);
        pepBankStatementResponse objClass = new pepBankStatementResponse();
        pepBankStatementResponse.bankSatementResponseSuccessorFailure wrpclass = new pepBankStatementResponse.bankSatementResponseSuccessorFailure(objBankStmt,false,'str');
        pepBankStatementResponse.bankStatemtnResponseStatemtnsresponse wrapClass1 = new pepBankStatementResponse.bankStatemtnResponseStatemtnsresponse(mapStr,false,'str1');
    }
}