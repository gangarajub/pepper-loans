// ---------------------------------------------------------------------------------------------------------
// This class is used to run stanadrd report(PepperOBSReport) and sent it into the email after converting it into csv fromat. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      10th Nov 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------

public class pepOBSReportingClass{

        @future(callout=true)
        public static void EmailReports()

        {
            List<String> emailList= new List<String>();
            String reportId = label.OBSReportId;        // fetch report id 
            String reportEmail = label.OBSReportEmail;  // fetch email id 
             for(String emailId : reportEmail.split(','))
             {
                 emailList.add(emailId);
             }
            String todayDate = date.today().day()+'-'+date.today().month()+'-'+date.today().year(); // bind today date in report name
            ApexPages.PageReference report = new ApexPages.PageReference('/'+reportId+'?csv=1'); // to convert report into csv format
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('Report('+ todayDate +').csv');
            if (!Test.isRunningTest()) 
                attachment.setBody(report.getContent());
            else
               attachment.setBody(blob.valueof('test'));
            attachment.setContentType('text/csv');
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();    // initialize email class to send report in email 
            message.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment } );
            message.setSenderDisplayName('OBS Daily Report');
            message.setSubject('Report');
            message.setPlainTextBody('The report is attached.');
            message.setToAddresses(emailList);
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );
        
        }
        
  }