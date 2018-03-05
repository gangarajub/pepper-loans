global class ExportCapaignReportAsExcel implements Database.Batchable<sobject>,Database.AllowsCallouts,Schedulable{
Global DataBase.QueryLocator start(DataBase.Batchablecontext batchableContext){
return Database.getqueryLocator('Select id ,name from Account Limit 1');
}
global void execute(DataBase.Batchablecontext batchablecontext,List<sobject> sobjectList) {
}    
Global void finish(Database.BatchableContext bc){    
List<Messaging.SingleEmailMessage> emsList = new List<Messaging.SingleEmailMessage>();
List<pepCampaignReportIDs__c> reportInstances=pepCampaignReportIDs__c.getall().values();
for(pepCampaignReportIDs__c rpId:reportInstances){
ApexPages.PageReference report = new ApexPages.PageReference('/'+rpId.ReportId__c+'?csv=1');
        
Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();

attachment.setFileName(rpId.Report_Name__c+'.xls');
String x;
If(!Test.isRunningTest())
x= report.getContent().tostring();
else
x=Blob.valueof('finals').tostring()+'\n'+','+'"';
String header =x.substring(0,x.indexof('\n'));
header=header.replaceall('","','\t');
header=header.replaceall('"','');
string rest = x.substring(x.indexof('\n'),x.length()-1);
rest=rest.replaceall('","','\t');
rest=rest.replaceall('"','');
string finals = header+rest;
If(!Test.isRunningTest())
attachment.setBody(Blob.valueof(finals));
else
attachment.setBody(Blob.valueof('finals'));
attachment.setContentType('application/vnd.ms-excel#'+rpId.Report_Name__c+'.xls');

Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

message.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment } );

message.setSubject(rpId.Report_Name__c+' '+'run at' +' '+ DateTime.Now());

message.setPlainTextBody('See'+' ' +rpId.Report_Name__c+' '+'attached run today.');

//message.setToAddresses( new String[] { 'varun.arora@saasfocus.com' } );
List<string> emailaddresses = new List<string>();
emailaddresses.addall(Campaignemails__c.getall().keyset());    
message.setToAddresses( emailaddresses);
emsList.add(message);
}
Messaging.sendEmail(emsList);

        
}
Global void execute(Schedulablecontext schedulableContext){
ExportCapaignReportAsExcel expReportasExcel = new ExportCapaignReportAsExcel();
DataBase.executeBatch(expReportasExcel,200);
}
}