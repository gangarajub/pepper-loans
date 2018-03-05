global class GenerateContract {
        webservice static String generate(String loanAccountId){
        List<genesis__Applications__c> app = [select id,name,Is_Secured__c from genesis__Applications__c where id=:loanAccountId];
        System.debug('app='+app);
        boolean isSecured = false;
        if(app.size()>0 && app[0].Is_Secured__c == true){
            isSecured = true;           
        }        
        String status = '';
        try { 
            status='Generating Contract..';
            List<loop__DDP__c> ddp;
            if(isSecured){
                 ddp = [select id,Name from Loop__DDP__c where Name = 'Secured Contract DDP'];    
            }else{
                 ddp = [select id,Name from Loop__DDP__c where Name = 'Contract DDP'];
            }
            
            System.debug('ddp='+ddp);
            String ddpId = '';
            String deliveryId = '';
            if(ddp!=null && ddp.size()>0){
                ddpId = ddp[0].id;
                List<Loop__DDP_Integration_Option__c> deliveryIds;
                //if(isSecured){
                deliveryIds= [select id , name from Loop__DDP_Integration_Option__c where  Loop__DDP__c =:ddpId AND Name='Email'];
                //}else{
                //     deliveryIds= [select id , name from Loop__DDP_Integration_Option__c where  Loop__DDP__c =:ddpId AND Name='Application Contract'];
                //}
                if(deliveryIds.size()>0){
                    deliveryId = deliveryids[0].id;
                }
            }
            System.debug('deliveryId '+deliveryId );
            String sessionId = UserInfo.getSessionId();
            If(!String.isblank(ddpId) && !String.isBlank(deliveryId)){
                generateDDP(deliveryId,ddpId,loanAccountId,sessionId);
            }
        } catch(Exception e) {
            status = e.getMessage();
            return status;
        
       
    }
     return status;
}


@future(callout = true)
    public static void generateDDP(String deployId,String templateId,String loanAccId,String sessionId){
        Map<string, string> variables = new Map<string,string>();
        variables = new Map<string, string> { 'deploy' => deployId };
        Loop.loopMessage lm = new Loop.loopMessage();
        lm.sessionId=sessionId;
        lm.requests.add(new Loop.loopMessage.loopMessageRequest(loanAccId,templateId,variables));
        lm.sendAllRequests();
    }

}