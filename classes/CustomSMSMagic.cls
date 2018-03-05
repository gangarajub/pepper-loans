global class CustomSMSMagic implements cnotify.NotifySms{
   global Boolean sendSMS(String recepientNumber, String textMessage, cnotify__Sms_Detail__c sc){
            String msg='';
            List<contact> con = [select id,name,MobilePhone from Contact where MobilePhone=:recepientNumber ];
            if(con.size()>0){
              String res=pepSMSmagicSendMessageHandler.sendSMS(con[0].name ,recepientNumber,textMessage);
            if(res!=null)
            {
                return false;
            }else{
                return true;
            } 
            }
            return false;
            
    }
}