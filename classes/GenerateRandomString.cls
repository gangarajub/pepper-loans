/*------------------------------------------------------------
    Author:        	Sean Jolly
    Name:          	GenerateRandomString
    Company:       	Pepper
    Description:   	Generates a random string with a length per the input parameter
	Test Class : 	GenerateRandomStringTest
    History
    20171113     	Sean Jolly     Class Created
    ------------------------------------------------------------*/

public class GenerateRandomString {
    
        /*------------------------------------------------------------
        Author:        Sean Jolly
        Name:          generateRandomString
        Company:       Pepper
        Description:   Method to generate a random string
        Inputs:        Integer len - represents the length of the requested string
        Returns:       Randomly generated String
        History
        20171113     	Sean Jolly     Method Created
        ------------------------------------------------------------*/      
    
    
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
	}
}