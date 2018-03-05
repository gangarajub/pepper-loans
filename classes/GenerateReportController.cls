public with sharing class GenerateReportController {
    
    public String selectedReport {get;set;}
    
    public GenerateReportController() {

    }
    
    public List<SelectOption> getReportOptions() {
        List<SelectOption> reportOptions = new List<SelectOption>();
        List<Report_Configuration__c> reportConfigs = [select Id, Name , Folder_name__c from Report_Configuration__c where Name!=null and Folder_name__c!=null];
        for(Report_Configuration__c repConfig:reportConfigs){
            reportOptions.add(new SelectOption(repConfig.Name,repConfig.name));
        }
        return reportOptions;
    }

    public PageReference generateReport() {
        if(selectedReport.equalsIgnoreCase('Transaction Listing')){
            GenerateTransactionListing txn = new GenerateTransactionListing(startDate,endDate);
            Database.executeBatch(txn,1);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Request for report generation has been submitted.Please check the report folder in some time for generated report.');
            ApexPages.addMessage(myMsg);
        }
        if(selectedReport.equalsIgnoreCase('Servicer Statement')){
            ServicerStatement txn = new ServicerStatement(startDate,endDate);
            Database.executeBatch(txn,1);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Request for report generation has been submitted.Please check the report folder in some time for generated report.');
            ApexPages.addMessage(myMsg);
        }
        
        
        return null;
    }


    public Date endDate { get; set; }

    public Date startDate { get; set; }
}