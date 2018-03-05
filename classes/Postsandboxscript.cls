/************************************************************************************
 * Author: 			Alex Humby
 * Date:			12/9/17
 * Description:		
 * 
 * This class is referenced when creating or refreshing Sandboxes 
 * >Email Addresses are scrambled for Accounts, Applications and Contacts in the ScrambleAccounts class
 * >Lead Details are scrambled
 * >Drawloop Community User is created if it doesnt exist
 * >Seed Data is created if it doesnt exist
 * 
 * Revision December 17 - Alex Humby
 * Added method to scramble customer data
 * *****************************************************************************/

global class Postsandboxscript implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) {
        
        Postsandboxscript_Utility.ScrambleCustomerData();
        
        Postsandboxscript_Utility.createDefaultPepCorp();
        Postsandboxscript_Utility.createDrawLoopUser();
    }
}