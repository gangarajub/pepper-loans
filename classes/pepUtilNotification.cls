// ---------------------------------------------------------------------------------------------------------
// This class is  used to create a common functionality to send email and SMS notification. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      1st June 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
public class pepUtilNotification
{


  // This method is used to send email notification.
  
   public static void SendEmailNotification(String email, String body,String subject)
   {
           if(email !='' && body !='' && subject !='')
            {
                        
                  try{
                     
                        Messaging.SingleEmailMessage emailInstance = new Messaging.SingleEmailMessage();
                        List<string> toAddresses=new List<string>();
                        toAddresses.add(email); 
                        emailInstance.setHTMLBody(body);
                        emailInstance.setSubject(subject);
                        emailInstance.setToAddresses(toAddresses);
                        emailInstance.setPlainTextBody(body);
                    
                        // Sends the email
                            Messaging.SendEmailResult [] r = 
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailInstance});
                     }
                     
                    catch(Exception ex)
                     {
                               ex.getMessage();
                     }
            }
   
   }

   // This method is used to send SMS notification.
   
   public static void SendSMSNotification(String receipentName,String receipentNo,String message)
   {
         if(receipentName !='' && receipentNo !='' && message !='')
            {
            
                    try{
                    
                            //passing parameter values to the sms class
                            String smsResponse = pepSMSmagicSendMessageHandler.sendSMS(receipentName, receipentNo, message);
                            //smsResponse contains value returned by the sms class
                            System.debug('Response for phone is:'+smsResponse );
                       }
                    catch(Exception ex)
                     {
                         ex.getMessage();
                     }
            }   
    
    }

 }