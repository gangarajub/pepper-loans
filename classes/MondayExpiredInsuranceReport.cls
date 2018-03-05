Global class MondayExpiredInsuranceReport{
@Future(Callout=True)
Public static void SendExpiredInsuranceReport(){
        List<Messaging.SingleEmailMessage> emailLists = new List<Messaging.SingleEmailMessage>();
        List<Report> reportLists = new List<Report>();
        reportLists  = [Select id,developername from Report where Developername='HomeLoans' or Developername='FutureFinancials'];
        for(Report report:reportLists){
            List<Messaging.EmailFileAttachment> Listattachment = new List<Messaging.EmailFileAttachment>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            List<string> toAddresses = new List<string>();
            toAddresses.add(report.developername=='HomeLoans'?Label.HomeLoansLimitEmail:Label.FutureFinancialsEmail);
            email.setToaddresses(toAddresses);
            email.setSubject('Insurance Expiry Report');
            email.sethtmlbody('<p>Please find the attached list of the Property Insurances getting expired.<p>');
            ApexPages.Pagereference pg = new ApexPages.Pagereference('/'+report.id+'?csv=1');
            if(Test.isRunningTest()){
            attachment.setBody(Blob.valueof('abcText'));
            }
            else{
            attachment.setBody(pg.getcontent());
            }
            attachment.setContentType('application/csv');
            attachment.setFilename('Insurances tO Expired as of'+ ' ' +System.Today().Day()+System.Today().month()+System.Today().year()+'.csv');
            Listattachment.add(attachment);
            email.setFileAttachments(Listattachment);
            emailLists.add(email);
        }
        if(emailLists != null && emailLists.size()>0)
        Messaging.Sendemail(emailLists);
}

}