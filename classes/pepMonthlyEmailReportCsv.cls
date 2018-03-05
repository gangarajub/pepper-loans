//This class sends every First Day of Month.
global class pepMonthlyEmailReportCsv implements Schedulable,Database.AllowsCallouts {

    global void execute(SchedulableContext sc) {
    
        EmailMonthlyReport();
    }
    
    @future(Callout=true)
    public static void EmailMonthlyReport(){
        
        Date selectedDate =  System.today().addMonths(-1); //Give your date
        Date firstDateOfMonth = selectedDate.toStartOfMonth();
        Date lastDateOfMonth = firstDateOfMonth.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
               
        string urlPath = url.getsalesforcebaseurl().toexternalform();
        map<string,List<string>> mapEmailToReport = new map<String,List<String>>();
        string[] ReportID = system.label.Monthly_Report_ID.split('\\,');
        
        for(String MonthlyReportID : ReportId){
            List<String> lstEmailCustomSetting = new List<String>();
            try{ 
              lstEmailCustomSetting =pepReportsToEmailAddress__c.getValues(MonthlyReportID).Email_Address__c.Split('\\,');
            }
            catch(exception e){
            }
            for(string emailString : lstEmailCustomSetting){
                
                 if(mapEmailToReport.get(emailString) ==null)
                    {
                        mapEmailToReport.put(emailString,new List<String>());
                    }
                  mapEmailToReport.get(emailString).add(MonthlyReportID);     
            }           
        }
        
        List<Report> objReport = [select id,Name from Report where id in : ReportID];
        map<id,String> mapReportIdtoName = new map<id,String>();
        for(Report objectReport : objReport){
            
            mapReportIdtoName.put(objectReport.id,objectReport.Name);
        }
        
      List<Messaging.SingleEmailMessage> theMonthlyEmails = new List<Messaging.SingleEmailMessage>();
        for(String EmailID : mapEmailToReport.keyset()){
            
             List<String> lstReportID = mapEmailToReport.get(EmailID);
             List<Messaging.EmailFileAttachment> Listattachment = new List<Messaging.EmailFileAttachment>();
             for(integer i=0;i<lstReportID.size();i++){
                 ApexPages.PageReference report = new ApexPages.PageReference('/'+lstReportID[i]+'?excel=1');
                 Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                 attachment.setFileName(mapReportIdtoName.get(lstReportID[i])+' '+firstDateOfMonth.day()+'-'+firstDateOfMonth.month()+'-'+firstDateOfMonth.year()+' - '+lastDateOfMonth.day()+'-'+lastDateOfMonth.month()+'-'+lastDateOfMonth.year()+'.xls');
                 if(test.isrunningTest()==false){
                 System.debug(report.getContent());
                      attachment.setBody(report.getContent());            
                 } 
                 attachment.setContentType('text/excel');
                 Listattachment.add(attachment);
             }
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.setFileAttachments(Listattachment);
             message.setSubject('Pepper Monthly Reports');    
                
             String s='These are the links of the report<br/>';
             integer i=0;
             for(String r : lstReportID){
                i++;
                s +=String.ValueOf(i)+': To view your Reports <a href='+urlPath+'/'+r+'>'+mapReportIdtoName.get(r)+' '+firstDateOfMonth.day()+'-'+firstDateOfMonth.month()+'-'+firstDateOfMonth.year()+' - '+lastDateOfMonth.day()+'-'+lastDateOfMonth.month()+'-'+lastDateOfMonth.year()+'.</a><br/>';
             } 
             message.setHtmlBody(s);
             string[] to=new string[]{EmailID};
             message.setToAddresses( to );
             message.setOrgWideEmailAddressId(System.label.peporgWideEmailAddressId);
             theMonthlyEmails.add(message);
        }
        
        List<Messaging.Email> allMonthlyMails = new List<Messaging.Email>();
        for( Integer j = 0; j < theMonthlyEmails.size(); j++ ){
            allMonthlyMails.add(theMonthlyEmails.get(j));
        }
        if(test.isrunningTest()==false){
            Messaging.SendEmailResult[] results = Messaging.sendEmail( allMonthlyMails );
        }
    
    
    }
}