public class pepcmscomponent_Text{

    public string strPageName{get; set;}
    public string strSectionName{get; set;}
    public List<String> lstHelpText{get; set;}
    public string strSectionBody{get; set;}
    public string SectionType{get; set;}
    public id idApplication{get;set;}
    public list<genesis__Applications__c> lstApp;
    public boolean getRenderSection(){
        try{
        list<pepCmsSection__c> lstSections;
        if(Limits.getQueries()+1 <= Limits.getLimitQueries()){
        lstSections = [SELECT pepHeader__c, pepPage__c, pepSectionBody__c, Name, pepSectionUniqueName__c, pepType__c, 
                                                pepSectionStory__c ,pepPage__r.pepPageName__c ,pepSectionStoryRich__c,pepSectionBodyRich__c
                                                                                           
                                                from pepCmsSection__c 
                                                //where pepSectionUniqueName__c=:'Income Details Help Text'
                                                //and pepPage__r.pepPageName__c=: 'Income Details'];
                                                where pepSectionUniqueName__c=:strSectionName
                                                and pepPage__r.pepPageName__c=: strPageName];
      }
      else{
             PeputilityClass.sendExceptionEmail(Peputilityclass.getCurrrentString());
             throw new DMLException('This is a SOQL limit exception handling mechanism');
      }
        
        if(lstSections.size() == 0){
            return false;
        }
        
        SectionType  = lstSections[0].pepType__c;
        
        if(SectionType == 'Help Text'){
            strSectionBody = lstSections[0].pepSectionBodyRich__c;
            String str = lstSections[0].pepSectionBodyRich__c;
            System.debug('Sanjeeb str ' + str);
            lstHelpText = str.split('\r\n');
            return true;
        }else if(SectionType  == 'Running Text'){
            if(lstSections[0].pepSectionUniqueName__c!='Decline2'){
             strSectionBody = lstSections[0].pepSectionBodyRich__c;
            }
            else{
                getcookiedata();
                if(lstApp != null){
                 strSectionBody=DeclineReason__c.getinstance(lstApp[0].Decline_Reason__c) != null?DeclineReason__c.getinstance(lstApp[0].Decline_Reason__c).reason__c:DeclineReason__c.getinstance('DEFAULT').reason__c; 
                }
                else{
                 strSectionBody=lstSections[0].pepSectionBodyRich__c;
                }
            }
            return true;
        }
        return false;
       }
       Catch(Exception Ex){
       return true;
       } 
    }
    Private void getcookiedata(){
    
   
        
        Map<string,string> childobjects = new Map<string,string>();                                                
                                                
         system.debug('idApplication ::'+idApplication );                                       
        if(idApplication !=null)                                        
        lstApp = pepInvokeCLMethodHelper.fetchApplications(null,idApplication,null,null,childobjects);  
    }
}