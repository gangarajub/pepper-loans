// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_ResponseHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestResponseHandler 
{
    static testMethod void myUnitTest() 
    { 
        ScCollection_ResponseHandler objResponseHandler = new ScCollection_ResponseHandler();
        ScCollection_ResponseHandler.wrapperForDmlOperation objWrapperclass = new ScCollection_ResponseHandler.wrapperForDmlOperation();
        ScCollection_ResponseHandler.wrapperForQueryOperation objWrapclass = new ScCollection_ResponseHandler.wrapperForQueryOperation();
    }
}