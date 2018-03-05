@isTest(SeeAllData=False) public class ScCollection_TestUpdateLetterURL{


    @isTest static void test0(){
        
        collect__Source_System__c  obSource = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Loan_Account__c  objClContract =  ScCollection_CommonTrackerClass.createTestContract(obSource.id);
                
        cnotify__Delivery_Detail__c objDelivery = new cnotify__Delivery_Detail__c();
        objDelivery.Name = 'abc';
        objDelivery.cnotify__Contract_Id__c = null;
        objDelivery.ScCollection_Letter_Key__c='1212';
        objDelivery.ScCollection_CL_Contract__c = objClContract.id;
        insert objDelivery;
        
        system.debug(objDelivery.ScCollection_Contract_Name__c);
        system.debug(objClContract.collect__Source_System__c);
        system.debug(obSource.name);
        system.debug(objDelivery.ScCollection_CL_Contract__c);
        system.debug('debugggg'+objDelivery.ScCollection_CL_Contract__r.collect__Source_System__r.Name);
        
        ScCollection_UpdateLetterParse objParse = new ScCollection_UpdateLetterParse();
        ScCollection_UpdateLetterParse.indexes objIndex = new ScCollection_UpdateLetterParse.indexes();
        objIndex.CreationTime='a';
        objIndex.RecipientIdentifier='a';
        objIndex.AccountIdentifier='a';
        objIndex.RecipientName='a';
        objIndex.LetterDate='a';
        objIndex.RecipientAddress='a';
        objIndex.CreationDate='a';
        objIndex.DPID='a';
        objIndex.LetterFormIdentifier='a';
        objIndex.OutputMethod='a';
        objIndex.Category='a';
        objIndex.OutputLocation='a';
        objIndex.Application='a';
        objIndex.AggregatorShortName='a';
        objIndex.Region='a';
        objIndex.Format='a';
        objIndex.CountryCode='a';
        objIndex.DocumentType='a';
        objIndex.FileDate='a';
        objIndex.DocumentTypeIdentifier='a';
        objIndex.ItemID=1;
        objIndex.BarcodeLinkage='a';
        objIndex.APPID='a';
        objIndex.Status='a';
        objIndex.BCUID='a';
        objIndex.ErrorHandler='a';
        objIndex.Filedby='a';
        objIndex.LeadID='a';
        
        
        ScCollection_UpdateLetterParse.ids objId = new ScCollection_UpdateLetterParse.ids();
        objId.value='';
        objId.description='Account Identifier';
        objId.type='AccountIdentifier';
        
        
        
        ScCollection_UpdateLetterParse.ids objId1 = new ScCollection_UpdateLetterParse.ids();
        objId1.value='';
        objId1.description='LeadID';
        objId1.type='LeadID';
        
        
        ScCollection_UpdateLetterParse.document objDoc = new ScCollection_UpdateLetterParse.document();
        objDoc.path='www.google.com';
        objDoc.description='a';
        objDoc.linktype='a';
        objDoc.name=1;
        objDoc.indexes=objIndex;
        objDoc.type='a';
        
        
        
        List<ScCollection_UpdateLetterParse.ids> lstId = new List<ScCollection_UpdateLetterParse.ids>();
        lstId.add(objId);
        lstId.add(objId1);
        
        objParse.ids = lstId;
        objParse.document = objDoc;
        objParse.business = 'SALESFORCE';
        String str = JSON.serialize(objParse);
        
        str = str.replace('LetterFormIdentifier','Letter/Form Identifier');
        str = str.replace('AccountIdentifier','Account Identifier');
        str = str.replace('RecipientIdentifier','Recipient Identifier');
        str = str.replace('RecipientName','Recipient Name');
        str = str.replace('RecipientAddress','Recipient Address');
        
        str = str.replace('OutputMethod','Output Method');
        str = str.replace('OutputLocation','Output Location');
        str = str.replace('AggregatorShortName','Aggregator Short Name');
        str = str.replace('BCUID','BCU ID');
        str = str.replace('ErrorHandler','Error Handler');
        str = str.replace('LeadID','Lead ID');
        str = str.replace('Filedby','Filed by');
        str = str.replace('FileDate','File Date');
        
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/col/letter/updateURL';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(str);
        RestContext.request = req;
        RestContext.response= res;
        
        ScCollection_UpdateLetterURL.UpdateURL();
        
        ScCollection_UpdateLetterURL.indexes  objIndexs= new ScCollection_UpdateLetterURL.indexes();
        objIndexs.CreationTime='a';
        objIndexs.RecipientIdentifier='a';
        objIndexs.AccountIdentifier='a';
        objIndexs.RecipientName='a';
        objIndexs.LetterDate='a';
        objIndexs.RecipientAddress='a';
        objIndexs.CreationDate='a';
        objIndexs.DPID='a';
        objIndexs.LetterFormIdentifier='a';
        objIndexs.OutputMethod='a';
        objIndexs.Category='a';
        objIndexs.OutputLocation='a';
        objIndexs.Application='a';
        objIndexs.AggregatorShortName='a';
        objIndexs.Region='a';
        objIndexs.Format='a';
        objIndexs.CountryCode='a';
        objIndexs.DocumentType='a';
        objIndexs.FileDate='a';
        objIndexs.DocumentTypeIdentifier='a';
        objIndexs.ItemID=1;
        objIndexs.BarcodeLinkage='a';
        objIndexs.APPID='a';
        objIndexs.Status='a';
        objIndexs.BCUID='a';
        objIndexs.ErrorHandler='a';
        objIndexs.Filedby='a';
        objIndexs.LeadID='a';
        
        ScCollection_UpdateLetterURL.ids objIdss = new ScCollection_UpdateLetterURL.ids();
        objIdss.value = 'a';
        objIdss.description = 'a';
        objIdss.type='nn';
        
        ScCollection_UpdateLetterURL.document objdoccumnt = new ScCollection_UpdateLetterURL.document();
        objdoccumnt.path='www.google.com';
        objdoccumnt.description='a';
        objdoccumnt.linktype='a';
        objdoccumnt.name=1;
        objdoccumnt.indexes=objIndexs;
        objdoccumnt.type='a';
        
        
        /*
        ScCollection_UpdateLetterURL.UpdateURL('type','desc','destination',lstId,'business',objDoc,'com');
        
        objDelivery.ScCollection_Letter_Key__c ='1';
        update objDelivery;
        ScCollection_UpdateLetterURL.UpdateURL('type','desc','destination',lstId,'business',objDoc,'com');
        
        objId1.value='';
        List<ScCollection_UpdateLetterURL.ids> lstId1 = new List<ScCollection_UpdateLetterURL.ids>();
        lstId1.add(objId);
        lstId1.add(objId1);
        ScCollection_UpdateLetterURL.UpdateURL('type','desc','destination',lstId1,'business',objDoc,'com');
        */
        
    }
    
    @isTest static void test1(){
    
        
        collect__Source_System__c  obSource = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Loan_Account__c  objClContract =  ScCollection_CommonTrackerClass.createTestContract(obSource.id);
                
        cnotify__Delivery_Detail__c objDelivery = new cnotify__Delivery_Detail__c();
        objDelivery.Name = 'abc';
        objDelivery.cnotify__Contract_Id__c = null;
        objDelivery.ScCollection_Letter_Key__c='1212';
        objDelivery.ScCollection_CL_Contract__c = objClContract.id;
        insert objDelivery;
        cnotify__Delivery_Detail__c oD = [Select Id,cnotify__Contract_Id__c,ScCollection_Letter_Key__c,ScCollection_CL_Contract__c,Name
                                            ,ScCollection_Contract_Name__c from cnotify__Delivery_Detail__c Where Id = :objDelivery.Id];
        
        ScCollection_UpdateLetterParse objParse = new ScCollection_UpdateLetterParse();
        ScCollection_UpdateLetterParse.indexes objIndex = new ScCollection_UpdateLetterParse.indexes();
        objIndex.CreationTime='a';
        objIndex.RecipientIdentifier='a';
        objIndex.AccountIdentifier='a';
        objIndex.RecipientName='a';
        objIndex.LetterDate='a';
        objIndex.RecipientAddress='a';
        objIndex.CreationDate='a';
        objIndex.DPID='a';
        objIndex.LetterFormIdentifier='a';
        objIndex.OutputMethod='a';
        objIndex.Category='a';
        objIndex.OutputLocation='a';
        objIndex.Application='a';
        objIndex.AggregatorShortName='a';
        objIndex.Region='a';
        objIndex.Format='a';
        objIndex.CountryCode='a';
        objIndex.DocumentType='a';
        objIndex.FileDate='a';
        objIndex.DocumentTypeIdentifier='a';
        objIndex.ItemID=1;
        objIndex.BarcodeLinkage='a';
        objIndex.APPID='a';
        objIndex.Status='a';
        objIndex.BCUID='a';
        objIndex.ErrorHandler='a';
        objIndex.Filedby='a';
        objIndex.LeadID='a';
        
        
        ScCollection_UpdateLetterParse.ids objId = new ScCollection_UpdateLetterParse.ids();
        objId.value=objClContract.Name;
        objId.description='Account Identifier';
        objId.type='AccountIdentifier';
        
        
        
        ScCollection_UpdateLetterParse.ids objId1 = new ScCollection_UpdateLetterParse.ids();
        objId1.value='1212';
        objId1.description='LeadID';
        objId1.type='LeadID';
        
        
        ScCollection_UpdateLetterParse.document objDoc = new ScCollection_UpdateLetterParse.document();
        objDoc.path='www.google.com';
        objDoc.description='a';
        objDoc.linktype='a';
        objDoc.name=1;
        objDoc.indexes=objIndex;
        objDoc.type='a';
        
        
        
        List<ScCollection_UpdateLetterParse.ids> lstId = new List<ScCollection_UpdateLetterParse.ids>();
        lstId.add(objId);
        lstId.add(objId1);
        
        objParse.ids = lstId;
        objParse.document = objDoc;
         objParse.business = 'SALESFORCE';
        String str = JSON.serialize(objParse);
        
        str = str.replace('LetterFormIdentifier','Letter/Form Identifier');
        str = str.replace('AccountIdentifier','Account Identifier');
        str = str.replace('RecipientIdentifier','Recipient Identifier');
        str = str.replace('RecipientName','Recipient Name');
        str = str.replace('RecipientAddress','Recipient Address');
        
        str = str.replace('OutputMethod','Output Method');
        str = str.replace('OutputLocation','Output Location');
        str = str.replace('AggregatorShortName','Aggregator Short Name');
        str = str.replace('BCUID','BCU ID');
        str = str.replace('ErrorHandler','Error Handler');
        str = str.replace('LeadID','Lead ID');
        str = str.replace('Filedby','Filed by');
        str = str.replace('FileDate','File Date');
        
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/col/letter/updateURL';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(str);
        RestContext.request = req;
        RestContext.response= res;
        
        ScCollection_UpdateLetterURL.UpdateURL();
    
    
    }
    @isTest static void test2(){
    
        
        collect__Source_System__c  obSource = ScCollection_CommonTrackerClass.createTestSourceSystem('PAF');
        collect__Loan_Account__c  objClContract =  ScCollection_CommonTrackerClass.createTestContract(obSource.id);
                
        cnotify__Delivery_Detail__c objDelivery = new cnotify__Delivery_Detail__c();
        objDelivery.Name = 'abc_0';
        objDelivery.cnotify__Contract_Id__c = null;
        objDelivery.ScCollection_Letter_Key__c='1212';
        objDelivery.ScCollection_CL_Contract__c = objClContract.id;
        insert objDelivery;
        
        
        ScCollection_UpdateLetterParse objParse = new ScCollection_UpdateLetterParse();
        ScCollection_UpdateLetterParse.indexes objIndex = new ScCollection_UpdateLetterParse.indexes();
        objIndex.CreationTime='a';
        objIndex.RecipientIdentifier='a';
        objIndex.AccountIdentifier='a';
        objIndex.RecipientName='a';
        objIndex.LetterDate='a';
        objIndex.RecipientAddress='a';
        objIndex.CreationDate='a';
        objIndex.DPID='a';
        objIndex.LetterFormIdentifier='a';
        objIndex.OutputMethod='a';
        objIndex.Category='a';
        objIndex.OutputLocation='a';
        objIndex.Application='a';
        objIndex.AggregatorShortName='a';
        objIndex.Region='a';
        objIndex.Format='a';
        objIndex.CountryCode='a';
        objIndex.DocumentType='a';
        objIndex.FileDate='a';
        objIndex.DocumentTypeIdentifier='a';
        objIndex.ItemID=1;
        objIndex.BarcodeLinkage='a';
        objIndex.APPID='a';
        objIndex.Status='a';
        objIndex.BCUID='a';
        objIndex.ErrorHandler='a';
        objIndex.Filedby='a';
        objIndex.LeadID='a';
        
        
        ScCollection_UpdateLetterParse.ids objId = new ScCollection_UpdateLetterParse.ids();
        objId.value='abcdef';
        objId.description='Account Identifier';
        objId.type='AccountIdentifier';
        
        
        
        ScCollection_UpdateLetterParse.ids objId1 = new ScCollection_UpdateLetterParse.ids();
        objId1.value='1212';
        objId1.description='LeadID';
        objId1.type='LeadID';
        
        
        ScCollection_UpdateLetterParse.document objDoc = new ScCollection_UpdateLetterParse.document();
        objDoc.path='www.google.com';
        objDoc.description='a';
        objDoc.linktype='a';
        objDoc.name=1;
        objDoc.indexes=objIndex;
        objDoc.type='a';
        
        
        
        List<ScCollection_UpdateLetterParse.ids> lstId = new List<ScCollection_UpdateLetterParse.ids>();
        lstId.add(objId);
        lstId.add(objId1);
        
        objParse.ids = lstId;
        objParse.document = objDoc;
        objParse.business = 'Jackson';
        String str = JSON.serialize(objParse);
        
        str = str.replace('LetterFormIdentifier','Letter/Form Identifier');
        str = str.replace('AccountIdentifier','Account Identifier');
        str = str.replace('RecipientIdentifier','Recipient Identifier');
        str = str.replace('RecipientName','Recipient Name');
        str = str.replace('RecipientAddress','Recipient Address');
        
        str = str.replace('OutputMethod','Output Method');
        str = str.replace('OutputLocation','Output Location');
        str = str.replace('AggregatorShortName','Aggregator Short Name');
        str = str.replace('BCUID','BCU ID');
        str = str.replace('ErrorHandler','Error Handler');
        str = str.replace('LeadID','Lead ID');
        str = str.replace('Filedby','Filed by');
        str = str.replace('FileDate','File Date');
        
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/col/letter/updateURL';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(str);
        RestContext.request = req;
        RestContext.response= res;
        
        ScCollection_UpdateLetterURL.UpdateURL();
        
        objClContract.Name = 'abcdef_0';
        update objClContract;
        
        //str.replace('abcdef',objClContract.Name);
        
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();

        req1.requestURI = '/services/apexrest/col/letter/updateURL';  //Request URL
        req1.httpMethod = 'POST';//HTTP Request Type
        req1.requestBody = Blob.valueof(str);
        RestContext.request = req1;
        RestContext.response= res1;
        
        ScCollection_UpdateLetterURL.UpdateURL();
        
        str = str.replace('abcdef','');
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();

        req2.requestURI = '/services/apexrest/col/letter/updateURL';  //Request URL
        req2.httpMethod = 'POST';//HTTP Request Type
        req2.requestBody = Blob.valueof(str);
        RestContext.request = req2;
        RestContext.response= res2;
        
        ScCollection_UpdateLetterURL.UpdateURL();
    }
    
}