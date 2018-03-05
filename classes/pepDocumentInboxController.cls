// ---------------------------------------------------------------------------------------------------------
// This class is  used to show the all documents related to loan of user. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      3rd June 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------
public without sharing class  pepDocumentInboxController
{
 public String selectedPageSize {get; set;}
 PepDocumentInboxPagination obj;
 list<Attachment> attachmentList;
 public List<Attachment> lstSetController{get;set;}
 public List<Integer> lstIntBar{get;set;}
 public Integer intPageNumber{get;set;}
 Integer Page_Size;//defining total elements for one page default is 5
 public Integer Total_Pages{get;set;}//storing total pages for loan transactions
 Integer Bar_Size;//defining  number bar size default is 5
 String loanAccountId;
 List<loan__Loan_Account__c> loanContractList ;
 Set<id> attachmentIdSet;
 public String Page_Name{get;set;}
 public String Page_Label{get;set;}
 
    public pepDocumentInboxController()
    {
        page_Name = 'pepDocumentInbox';
        Page_Label=pages_config__c.getValues(page_Name.toLowerCase()).Page_Label__c;
       
        attachmentList = new list<Attachment>();
        loanContractList = new List<loan__Loan_Account__c>();
        attachmentIdSet = new  Set<id>();
        String idAccount = pepUtilityClass.getAccountId();
        if(string.isNotBlank(idAccount))
           loanAccountId = pepUtilityClass.getLoanAccountId(idAccount); // to get loan account id
        if(string.isNotBlank(loanAccountId))
        {
             
                  Map<String,String> ChildObjectMap = new Map<String,String>();
                  String ChildObjectFields='Attachment_ID__c,Document_Category__c,CL_Contract__c';
                  ChildObjectMap.put('CL_Contract_Document_Junction__r',ChildObjectFields);
                  loanContractList = RetrieveLoanAccounts.getLoanContracts(null,loanAccountId,null,null,ChildObjectMap); // to fetch loan account and their child object(CL contract document junction)
                       
                
                  if(loanContractList.size()>0)
                  {
                           
                           if(loanContractList[0].Application__c != null)
                             {
                                   
                                   List<genesis__Application_Document_Category__c> ListOfApplicationDocuments = new list <genesis__Application_Document_Category__c>();
                                   List<genesis__AppDocCatAttachmentJunction__c> lstAppDocCat = new List<genesis__AppDocCatAttachmentJunction__c>();
                                   List<genesis__Applications__c>  lstApplication = new List<genesis__Applications__c>();
                                   List<genesis__AppDocCatAttachmentJunction__c>lstAttachment = new List<genesis__AppDocCatAttachmentJunction__c>();
                                   Map<genesis__Application_Document_Category__c,List<genesis__AppDocCatAttachmentJunction__c>> documentCategoryMap = New Map<genesis__Application_Document_Category__c,List<genesis__AppDocCatAttachmentJunction__c>>();
                                   Map<string,string> childobjects = new Map<string,string>();
                                   Set<String> listAtt = new set<String>();
                                   listAtt.addall(label.ApplicationAttachment.split(','));
                                   String ChildObjectField='Name,id'; 
                                   childobjects.put('genesis__Application_Document_Category__r',ChildObjectField);
                                   lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,loanContractList[0].Application__c,null,null,childobjects);
                                   for(genesis__Applications__c instanceApp : lstApplication)
                                      {
                                        for(genesis__Application_Document_Category__c InstanceDocCategory :instanceApp.genesis__Application_Document_Category__r)
                                          {
                                             if(listAtt.contains(InstanceDocCategory.name))
                                                ListOfApplicationDocuments.add(InstanceDocCategory);
                                          }
                                      }  
                                     
                                     if(ListOfApplicationDocuments.size()>0) 
                                         documentCategoryMap = FetchAppDocCatAttachmentJunction.fetchAllDoc(ListOfApplicationDocuments); 
                                     if(documentCategoryMap.keyset().size()>0) 
                                     {                                                                       
                                            for(list<genesis__AppDocCatAttachmentJunction__c> instanceAttList : documentCategoryMap.values()) 
                                            {
                                               for(genesis__AppDocCatAttachmentJunction__c instanceAtt:instanceAttList )
                                               {
                                                    attachmentIdSet.add(instanceAtt.genesis__AttachmentId__c) ; 
                                               }
                                            }
                                     }  
                                 
                             }
                  
                            for (loan__Loan_Account__c instanceLoanAccount:loanContractList)
                            {       
                                     set<String> labelAttachment = new set<String>();
                                     labelAttachment.addall(Label.CLContractAttachment.split(','));
                                    for(CL_Contract_Document_Junction__c documentJunction: instanceLoanAccount.CL_Contract_Document_Junction__r) 
                                     {
                                         
                                              if(labelAttachment.contains(documentJunction.Document_Category__c))
                                                 attachmentIdSet.add(documentJunction.Attachment_ID__c);
                                              
                                     }
                            }
                            
                   }
                   
                   
         }
  }       
           public void updateDocument()
           {
                  system.debug('attachmentIdSetIs'+attachmentIdSet);
                   Map<String,String> mimeTypeMap = new Map<String,String>
            {'application/pdf'=>'pdf','application/msword'=>'doc','application/vnd.openxmlformats-officedocument.wordprocessingml.document'=>'docx',
            'image/x-pict'=>'pic','image/png'=>'png','image/gif'=>'gif','image/jpeg'=>'jpeg','application/vnd.ms-excel'=>'xls',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'=>'xlsx','text/csv'=>'csv',
            'application/x-rar-compressed'=>'rar','application/zip'=>'zip','application/xhtml+xml'=>'xhtml',
            'text/html'=>'html','application/vnd.ms-powerpoint'=>'ppt','video/mp4'=>'mp4'};
                        if(attachmentIdSet.size()>0)
                        {
                                   list <attachment> attList = new List<attachment>();
                                   
                                   attList =[Select Id, name,createdDate,contentType from attachment where id in:attachmentIdSet order by createdDate desc]; // to fetch attachment
                                   for(attachment objAtt:attList)
                                   {
                                      if(mimeTypeMap.containsKey(objAtt.contentType) && (!objAtt.name.contains('.'+mimeTypeMap.get(objAtt.contentType))))
                                      {
                                         objAtt.name =objAtt.name+'.'+mimeTypeMap.get(objAtt.contentType);
                                      }
                                         attachmentList.add(objAtt);
                                  }
                                   if(attachmentList.size()>0)
                                        update attachmentList;
                        }
                           
                      
                        obj = new PepDocumentInboxPagination (attachmentList); // to call pagination class
                        lstIntBar=new List<Integer>();
                        lstSetController = new List<Attachment>();
                        Page_Size=5;
                        Bar_Size=5;
                        intPageNumber=1;
                        obj.setPageSize = Page_Size;
                        Total_Pages=integer.valueof(attachmentList.size()/Page_Size)+(math.mod(attachmentList.size(),Page_Size)!=0?1:0);
                        Bar_Size=Total_Pages>Bar_Size?Bar_Size:Total_Pages;
                        numberBar(intPageNumber);
                        lstSetController=  obj.next();
       }
                
  
    // This method returns true if list has more elements
    
         public Boolean hasNext {
            get 
            {
                return obj.hasNext();
            }
            set;
        }
        
    // This method returns true if list has Previous page's elements
        
        public Boolean hasPrevious {
            get 
            {
                return obj.hasPrevious();
            }
            set;
        } 
   
   // This method is used to set next elements in list
       
        public void next() 
        {
                lstSetController = obj.next();
                intPageNumber++;
                if(intPageNumber>5)
                {
                    numberBar(intPageNumber);
                }
            
        }
  // This method is used to set previous elements in list
        
        public void previous() 
        {
                lstSetController = obj.previous();
                intPageNumber--;
                if(intPageNumber>=5)
                {
                 numberBar(intPageNumber);
                }
        }
        
  // This method is used to set elements for specific page number
    
    public void GoTo() 
    {
            lstSetController = obj.goToPage(intPageNumber);
            if(intPageNumber==5)
            {
             numberBar(intPageNumber);
            }
    }
    
    // This method is used to set Number Bar list
  //  intPageNumber-This is the  paramter to  define the specific page number

    public void numberBar(Integer intPageNumber)
    {
        lstIntBar.clear(); 
        integer loopVar=1;
           for(integer start =(intPageNumber>Bar_Size?intPageNumber-Bar_Size+1:1);loopVar<=Bar_Size;start++)
             {
               lstIntBar.add(start);
               loopVar++;
             }
    } 

     
}