/* @author  Krishnanand Gupta(SaaSfocus)
* @version 1.0
* @since   2016-05-10 
* @Desc This Class is for contract generation for Application object
*/
public class pepContractController{
    public Loop.ProcessDdpParameters DDP{ get; set; }
    public Boolean processDDP{get;set;}
    public Boolean isError{get;set;}
    public String ID_Application{get;set;}
    public Boolean isDDP_User_LoggedIn{get;set;}
    public  List<genesis__Applications__c> lstApp{get;set;}
    public Boolean successSaveForLater{get;set;}
    public genesis__Applications__c objApplication;
    public pepContractController()
    {
    //
    try{
     isDDP_User_LoggedIn=false;
     isError=false;
     processDDP=false;
     lstApp=new List<genesis__Applications__c>();
     objApplication = new genesis__Applications__c ();
   
      Cookie cookieApplicationId1= ApexPages.currentPage().getCookies().get('ApplicationId');
       if(cookieApplicationId1!=null && cookieApplicationId1.getValue()!=null && cookieApplicationId1.getValue()!='')
        {  ID_Application =pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId1.getValue()));
           objApplication.Id = pepEncryptDecryptData.DecryptData(String.valueof(cookieApplicationId1.getValue()));
        }  
        else{ ID_Application =ApexPages.currentPage().getParameters().get('id');} 
      if(ID_Application != null && ID_Application != ''){
         lstApp=[Select id,RedirectToContract__c,DDP_Processed__c,PepDocusignenvelopeId__c,Is_Secured__c,DDP_Exception__c from genesis__Applications__c where id=:ID_Application ];
    
          if(lstApp[0].PepDocusignenvelopeId__c !=null && lstApp[0].PepDocusignenvelopeId__c !='' )// attachment!=null && attachment.size()>0
          {
            Cookie myCookies = new Cookie('isContractAttached','',null,0,true);
            myCookies = new Cookie('isContractAttached','true',null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{myCookies});
            processDDP=false;
         
          }
          else
          {
           Cookie myCookies = new Cookie('isContractAttached','',null,0,true);
           myCookies = new Cookie('isContractAttached','false',null,-1,false);
           ApexPages.currentPage().setCookies(new Cookie[]{myCookies});
           if(lstApp[0].DDP_Exception__c==True)
           {
           processDDP=false;
           isError=true;
           }
           else
           {
           if(lstApp[0].DDP_Processed__c==false)
           processDDP=true;
           }
           
          }
     
    if(UserInfo.getUserName()==Drawloop_User_Setting__c.getinstance('DDP_User').Username__c)
     {
      isDDP_User_LoggedIn=true;
     }
     //String ID_DDP=[Select id,Name from Loop__DDP__c where Name=:Label.DDP_Name].id;
     //String ID_DOption=[Select id,Name from Loop__DDP_Integration_Option__c where name=:Label.DDP_Option].id;
     String ID_DDP=[Select id,Name from Loop__DDP__c where Name=:lstApp[0].is_secured__c?Label.Secured_DDP:Label.DDP_Name].id;
     String ID_DOption=[Select id,Name from Loop__DDP_Integration_Option__c where name=:lstApp[0].is_secured__c?Label.Secured_DDP_Option:Label.DDP_Option].id;
     if (!String.isBlank(ID_Application)) 
     {
        DDP= new Loop.ProcessDdpParameters(ID_DDP, ID_DOption, ID_Application, new List<Id>());
        DDP.theme = Loop.ProcessDdpParameters.ThemeStyle.BOOTSTRAP_3_2;
        DDP.onCompleteCallback='DDPResponse';
        DDP.onProgressCallback='progress';
        DDP.onErrorCallback='Error';
     }
     
     fetchApplication();
     }
    }
     catch(Exception ex){
     String str='';
     str=ex.getmessage();
     System.debug('=='+ex.getmessage());
     //PeputilityClass.CreateExceptionrecord(str,'Drawloop/Docusign');
     throw ex;//Throwing exception to move the flow to the Generic Exception Page.
     }
   }
   
    public void fetchApplication()
    {
         Map<string,string> childobjects = new Map<string,string>();
         if(ID_Application != null)
         {
             List<genesis__Applications__c>  lstApplication  =pepInvokeCLMethodHelper.fetchApplications(null ,ID_Application,null,null,childobjects );
             if(lstApplication != null && lstApplication.size() > 0)
             {
                 
                 objApplication = lstApplication[0];
                
             }
         }
    }
    
public void startDDP(){processDDP=true;} 
public void stopDDP(){processDDP=false;}
    public PageReference retry()
   {
       try{
           if(lstApp[0].RedirectToContract__c)
            lstApp[0].RedirectToContract__c=false;
            if(lstApp[0].DDP_Exception__c)
            lstApp[0].DDP_Exception__c=false;
            update lstApp;
           
           
            String redircetPageName= pages_config__c.getinstance('pepsession').Page_Label__c;
            PageReference pg=new PageReference('/'+redircetPageName);
            pg.setRedirect(true);
            return pg;
        }
        Catch(Exception ex){
            String str='';
            str=ex.getmessage();
            PeputilityClass.createExceptionRecord(str,'Drawloop');
            String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
            return new Pagereference('/'+redircetPageName);
        }
    }
Public Pagereference checkcookie(){
try{
List<Attachment> attachment = [select id, Name, body, ContentType from Attachment where parentid=:ID_Application and name='Application Contract.pdf' order by LastModifiedDate DESC limit 1];            
          if(attachment!=null && attachment.size()>0)
          {
          //Added by Varun on discussion with Ishu Jain
            string strCreditCategory = system.label.PepCreditCategory;
            list<genesis__Application_Document_Category__c> lstappDocCategory = [select id, Name from genesis__Application_Document_Category__c where genesis__Application__c=:ID_Application AND Name =:strCreditCategory];
            if(lstappDocCategory != null && lstappDocCategory.size()>0)
            String jsonRes = genesis.TransactionRoomRemoteAction.linkAttachmentToADC(ID_Application,lstappDocCategory[0].id,attachment[0].id); 
            //Varun Code ends.
          
          }
         

Pagereference pr=Peputilityclass.checkCookieAndRedirect();
return pr;
} 
catch(Exception ex){
string str='';
str=ex.getmessage();
PeputilityClass.CreateExceptionrecord(str,'DrawLoop/Docusign');
String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
return new Pagereference('/'+redircetPageName);
}  
}
 //  This method is used to save the page name of current page in navigation status of application and sent notification(retrieval code)
  //  through SMS and Email to related account of respected application.

     public pagereference saveForLater()
     {
            try{
            system.debug('aplicationIdIs'+objApplication);
            successSaveForLater=false;
           if(objApplication!=null && objApplication.id!=null)  
             {
                       
                         genesis__Applications__c objApplicationReturn = new  genesis__Applications__c ();
                         objApplicationReturn = pepUtilityClass.SaveForLater(objApplication,'pepContract') ; 
             
                        if(objApplicationReturn!=null && objApplicationReturn.id!=null)
                         {  
                                  successSaveForLater = true;
                                  system.debug('aplicationIs'+objApplicationReturn);
                                   system.debug('objApplicationIs'+objApplication.genesis__Account__c);
                                  
                         }     
              return null;
              }
              else{
            Peputilityclass.CreateExceptionRecord('Application id returns null','DrawLoop/Docusign');
             String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
             return new Pagereference('/'+redircetPageName);
            }           
          }
          Catch(Exception ex){
          String str='';
          str=ex.getmessage();
          PeputilityClass.CreateExceptionRecord(str,'Save For Later Error');
          String redircetPageName= pages_config__c.getinstance('pepgenericredirection').Page_Label__c;
          return new Pagereference('/'+redircetPageName);
          }       
      
     }

}