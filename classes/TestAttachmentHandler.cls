@isTest
public class TestAttachmentHandler {
    public static testmethod void deleteAttachmentTest(){
        loan.TestHelper.createSeedDataForTesting();
        Veda_Comprehensive__c veda_comp = new Veda_Comprehensive__c();
        insert veda_comp;
        Attachment attach = new Attachment();
        attach.Name = 'Attachment';
        attach.Body = Blob.valueOf('Attachment Body');
        attach.ParentId = veda_comp.id;
        insert attach;
        List<String> attachmentsId =new List<String>();
        attachmentsId.add(attach.id);
        Test.startTest();
        AttachmentHandler hand = new AttachmentHandler();
        String ret = hand.deleteAttachments(attachmentsId);
        system.assertEquals('Successful', ret);
        Test.stopTest();
    }
    public static testmethod void noAttachment(){
        loan.TestHelper.createSeedDataForTesting();
        Veda_Comprehensive__c veda_comp = new Veda_Comprehensive__c();
        insert veda_comp;
        
        List<String> attachmentsId =new List<String>();
        attachmentsId.add(null);
        Test.startTest();
        AttachmentHandler hand = new AttachmentHandler();
        String ret = hand.deleteAttachments(attachmentsId);
        system.assertEquals('No attachment Records Found', ret);
        Test.stopTest();
    }
    

}