/*------------------------------------------------------------------------
Author:        Sean Jolly
Name:          GenerateRandomStringTest
Company:       Pepper
Class Covered: GenerateRandomString
Description:   A test class created to validate the GenerateRandomString class returns a valid value 
              Tests executed:
              1 - testLength1()
              Requests a random string with a length of 1 and validates the returned value
              2 - testLength50()
              Requests a random string with a length of 50 and validates the returned value
History
2017-11-13    Sean Jolly     Created
----------------------------------------------------------------------------*/

@isTest
private class GenerateRandomStringTest {

  @isTest static void testLength1() {
    string result = GenerateRandomString.generateRandomString(1);
    System.assertNotEquals(null, result);
    integer size = result.length();
    System.assertEquals(1, size);                   
	}  
    
   @isTest static void testLength50() {
    string result = GenerateRandomString.generateRandomString(50);
    System.assertNotEquals(null, result);
    integer size = result.length();
    System.assertEquals(50, size);                   
   }     
    
}