trigger preventEnforcementAssociation  on Account_LoanContract__c (Before Insert,Before Update) {
If(Trigger.isBefore && (Trigger.IsUpdate || Trigger.isInsert)){
pepEnforcementprevention.preventcustomerAccountAssociation(Trigger.new);
}
}