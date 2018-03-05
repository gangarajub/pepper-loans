public class GenerateDirectDebitRequestDDP {
        
    
    public static  void  generateDirectDebitDocument(String loanId){
            
            
            List<loop__DDP__c> ddp = [select id,Name from Loop__DDP__c where Name = 'Direct Debit Request'];
            String ddpId = '';
            String deliveryId = '';
            if(ddp!=null && ddp.size()>0){
                ddpId = ddp[0].id;
                List<Loop__DDP_Integration_Option__c> deliveryIds= [select id , name from Loop__DDP_Integration_Option__c where Name = 'Attach' and Loop__DDP__c =:ddpId];
                if(deliveryIds.size()>0){
                    deliveryId = deliveryids[0].id;
                }
            }
            String sessionId = UserInfo.getSessionId();
            If(!String.isblank(ddpId) && !String.isBlank(deliveryId)){
                generateDDP(deliveryId,ddpId,loanId,sessionId);
            }
    }
    
    @future(callout = true)
    public static void generateDDP(String deployId,String templateId,String loanId,String sessionId){
        Map<string, string> variables = new Map<string,string>();
        variables = new Map<string, string> { 'deploy' => deployId };
        Loop.loopMessage lm = new Loop.loopMessage();
        lm.sessionId=sessionId;
        lm.requests.add(new Loop.loopMessage.loopMessageRequest(loanId,templateId,variables));
        lm.sendAllRequests();
    }
    
  
}