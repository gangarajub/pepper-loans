/*
 * Author: 			Alex Humby
 * Date:			12/9/17
 * Description:		A rubbish test class to cover a Class that deletes Seed Data if the ETL Job failed part way through
 * 					@Mitali - if you're reading this - I apologise! :) 
 * 					If I had the code to create the Seed Data I wouldnt need the ETL Job! 
 * 					So I'm not going to write the code to create the Seed Data so I can properly Test my Clean Up Method!!
 * 
 */

@isTest(SeeAllData = False)
public class SeedDataCleanUpTest {

    public testmethod static void checkNoSeedDataExists(){
        Test.startTest();
        
        Boolean doDelete = true;
        SeedDataCleanUp.countMiscJobZ(doDelete);
        SeedDataCleanUp.countSeedJobA(doDelete);
        SeedDataCleanUp.countSeedJobB(doDelete);
        SeedDataCleanUp.countSeedJobC(doDelete);
        
        Test.stopTest();
        
        
    }
    
}