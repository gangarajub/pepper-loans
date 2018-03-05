@isTest public class pepForgotPasswodController_Tracker {
    
    @isTest static void pepeForgotPasswodTest(){
        
         User usr1 =[Select id from user where id=:userinfo.getuserid()];
         User usr = new User();
         system.runas(usr1){
 
          usr=pepCommonTrackerController.createUser();
         }
        
        pepForgotPasswordController objpepForgotPassword = new pepForgotPasswordController();
        objpepForgotPassword.userId=usr.username;
        objpepForgotPassword.checkPassword();
        
        pepForgotPasswordController objpepForgotPassword1 = new pepForgotPasswordController();
        objpepForgotPassword1.checkPassword();
             
         
    }

}