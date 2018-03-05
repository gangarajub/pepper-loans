/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
global class pepMockHttpResBankInfo implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"accounts":[{"accountHolder":"Bob Smith","name":"Transaction Account","accountNumber":"423897","id":"423897","bsb":"123-456","balance":"3.45","available":"3.45"},{"accountHolder":"Robert Smith","name":"Savings Account","accountNumber":"7563435","id":"7563435","bsb":"123-456","balance":"23.45","available":"23.45"}],"user_token":"920b0adb1139a95bbf353c0f8a861c65"}');
        res.setStatusCode(200);
        return res;
    }
}