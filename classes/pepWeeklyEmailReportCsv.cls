//This class sends weekly summary report at every friday 5.30 PM on business days.
global class pepWeeklyEmailReportCsv implements Schedulable,Database.AllowsCallouts {

    global void execute(SchedulableContext sc) {
    
        EmailWeeklyReport();
    }
    
    @future(Callout=true)
    public static void EmailWeeklyReport(){
        date weekStartDate = system.today().toStartofWeek().adddays(1);
        date weekEndDate = system.today().toStartofWeek().adddays(5);
        string urlPath = url.getsalesforcebaseurl().toexternalform();
        map<string,List<string>> mapEmailToReport = new map<String,List<String>>();
        string[] ReportID = system.label.Weekly_Report_ID.split('\\,');
        
        for(String WeeklyReportID : ReportId){
            List<String> lstEmailCustomSetting = new List<String>();
            try{ 
              lstEmailCustomSetting =pepReportsToEmailAddress__c.getValues(WeeklyReportID).Email_Address__c.Split('\\,');
            }
            catch(exception e){
            }
            for(string emailString : lstEmailCustomSetting){
                
                 if(mapEmailToReport.get(emailString) ==null)
                    {
                        mapEmailToReport.put(emailString,new List<String>());
                    }
                  mapEmailToReport.get(emailString).add(WeeklyReportID);     
            }           
        }
        
        List<Report> objReport = [select id,Name from Report where id in : ReportID];
        map<id,String> mapReportIdtoName = new map<id,String>();
        for(Report objectReport : objReport){
            
            mapReportIdtoName.put(objectReport.id,objectReport.Name);
        }
        
      List<Messaging.SingleEmailMessage> theWeeklyEmails = new List<Messaging.SingleEmailMessage>();
        for(String EmailID : mapEmailToReport.keyset()){
            
             List<String> lstReportID = mapEmailToReport.get(EmailID);
             List<Messaging.EmailFileAttachment> Listattachment = new List<Messaging.EmailFileAttachment>();
             for(integer i=0;i<lstReportID.size();i++){
                 ApexPages.PageReference report = new ApexPages.PageReference('/'+lstReportID[i]+'?excel=1');
                 Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                 attachment.setFileName(mapReportIdtoName.get(lstReportID[i])+' '+weekStartDate.day()+'-'+weekStartDate.month()+'-'+weekStartDate.year()+' - '+weekEndDate.day()+'-'+weekEndDate.month()+'-'+weekEndDate.year()+'.xls');
                 if(test.isrunningTest()==false){
                      attachment.setBody(report.getContent());            
                 } 
                 attachment.setContentType('text/excel');
                 Listattachment.add(attachment);
             }
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.setFileAttachments(Listattachment);
             message.setSubject('Pepper Weekly Reports');    
                
             String s='These are the links of the report<br/>';
             integer i=0;
             for(String r : lstReportID){
                i++;
                s +=String.ValueOf(i)+': To view your Reports <a href='+urlPath+'/'+r+'>'+mapReportIdtoName.get(r)+' '+weekStartDate.day()+'-'+weekStartDate.month()+'-'+weekStartDate.year()+' - '+weekEndDate.day()+'-'+weekEndDate.month()+'-'+weekEndDate.year()+'.</a><br/>';
             } 
             message.setHtmlBody(s);
             string[] to=new string[]{EmailID};
             message.setToAddresses( to );
             message.setOrgWideEmailAddressId(System.label.peporgWideEmailAddressId);
             theWeeklyEmails.add(message);
        }
        
        List<Messaging.Email> allWeeklyMails = new List<Messaging.Email>();
        for( Integer j = 0; j < theWeeklyEmails.size(); j++ ){
            allWeeklyMails.add(theWeeklyEmails.get(j));
        }
        if(test.isrunningTest()==false){
            Messaging.SendEmailResult[] results = Messaging.sendEmail( allWeeklyMails );
        }
    
    }
}