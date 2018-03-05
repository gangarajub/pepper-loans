trigger AttachmentTrigger on Attachment (after insert) {
    List<Attachment> atts = trigger.new;
    Set<Id> contractIds = new Set<Id>();
    for(Attachment att:atts){
        List<loan__Loan_Account__c> lAcc= [select Id from loan__Loan_Account__c where Id=:att.parentId];
        if(lAcc.size()>0){
            if(att.Name.contains('Statement')){
                     CL_Contract_Document_Junction__c  docJnc = new CL_Contract_Document_Junction__c ();
                     docJnc.Attachment_ID__c = att.id;
                     docJnc.CL_Contract__c = lAcc[0].id;
                     docJnc.Document_Category__c = 'BORROWER STATEMENT';
                     insert docJnc;
            }
            if(att.Name.contains('Direct Debit Request')){
                     CL_Contract_Document_Junction__c  docJnc = new CL_Contract_Document_Junction__c ();
                     docJnc.Attachment_ID__c = att.id;
                     docJnc.CL_Contract__c = lAcc[0].id;
                     docJnc.Document_Category__c = 'DDR';
                     insert docJnc;
            }
           
        }
    }
}