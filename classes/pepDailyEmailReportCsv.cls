//This class sends daily summary report at 5.30 PM on business days.
global class pepDailyEmailReportCsv implements Schedulable,Database.AllowsCallouts {

    global void execute(SchedulableContext sc) {
    
        EmailReport();
    }
    
    @future(Callout=true)
    public static void EmailReport(){
        string urlPath = url.getsalesforcebaseurl().toexternalform();
        map<string,List<string>> mapEmailToReport = new map<String,List<String>>();
        string[] ReportID = system.label.Daily_Report_ID.split('\\,');
        
        for(String DailyReportID : ReportId){
            List<String> lstEmailCustomSetting = new List<String>();
            try{ 
              lstEmailCustomSetting =pepReportsToEmailAddress__c.getValues(DailyReportID).Email_Address__c.Split('\\,');
            }
            catch(exception e){
            }
            for(string emailString : lstEmailCustomSetting){
                
                 if(mapEmailToReport.get(emailString) ==null)
                    {
                        mapEmailToReport.put(emailString,new List<String>());
                    }
                  mapEmailToReport.get(emailString).add(DailyReportID);     
            }           
        }
        
        List<Report> objReport = [select id,Name from Report where id in : ReportID];
        map<id,String> mapReportIdtoName = new map<id,String>();
        for(Report objectReport : objReport){
            
            mapReportIdtoName.put(objectReport.id,objectReport.Name);
        }
        
      List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
        for(String EmailID : mapEmailToReport.keyset()){
            
             List<String> lstReportID = mapEmailToReport.get(EmailID);
             List<Messaging.EmailFileAttachment> Listattachment = new List<Messaging.EmailFileAttachment>();
             for(integer i=0;i<lstReportID.size();i++){
                 ApexPages.PageReference report = new ApexPages.PageReference('/'+lstReportID[i]+'?excel=1');
                 Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                 attachment.setFileName(mapReportIdtoName.get(lstReportID[i])+' '+System.today().day()+'-'+System.today().month()+'-'+System.today().year()+'.xls');
                 blob b;
                 if(test.isrunningTest()==false){
                      b = report.getContent();
                      attachment.setBody(b); 
                      system.debug(b);                               
                 } 
                  
                 attachment.setContentType('text/excel');
                 Listattachment.add(attachment);
             }
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             message.setFileAttachments(Listattachment);
             message.setSubject('Pepper Daily Reports');    
                
             String s='These are the links of the report<br/>';
             integer i=0;
             for(String r : lstReportID){
                i++;
                s +=String.ValueOf(i)+': To view your Reports <a href='+urlPath+'/'+r+'>'+mapReportIdtoName.get(r)+' '+System.today().format()+'.</a><br/>';
             } 
             message.setHtmlBody(s);
             string[] to=new string[]{EmailID};
             message.setToAddresses( to );
             message.setOrgWideEmailAddressId(System.label.peporgWideEmailAddressId);
             theEmails.add(message);
        }
        
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        for( Integer j = 0; j < theEmails.size(); j++ ){
            allMails.add(theEmails.get(j));
        }
        if(test.isrunningTest()==false){
             Messaging.SendEmailResult[] results = Messaging.sendEmail( allMails );
        }
    
    
    }
}