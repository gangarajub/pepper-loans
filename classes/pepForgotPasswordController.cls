public class pepForgotPasswordController
{
    public String userId{get;set;}
    public Boolean userExist{get;set;}
    user objUser;
    public pepForgotPasswordController()
    {
      userExist=false;
      userId = '';
    }
 public void checkPassword()
 {
      if(String.isNotBlank(userId))
       {
           objUser=[select id ,username from user where username=:userId limit 1] ;
           
            if(objUser.id!= null)
            {
             
            }
             else
             {
                userExist = true;
             }
       }
       else{
              userExist = true;
       }
 }
}