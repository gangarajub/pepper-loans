public class AttachmentHandler{

    public String deleteAttachments(List<String> attachmentsId){
        
       
        List<Attachment> toBeRemoved = [select id,name from Attachment where id=:attachmentsId];
        if(toBeRemoved!=null && toBeRemoved.size()>0){
            try{
                delete toBeRemoved;
                return 'Successful';
            }catch(Exception e){
                return 'Unsuccessfull'+e.getMessage();
            }
        }else{
            return 'No attachment Records Found';
        }
   
   }

}