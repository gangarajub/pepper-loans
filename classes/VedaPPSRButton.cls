global class VedaPPSRButton {
    webservice static void getHist(String collId){
        List<VPPSR_Registration_Detail__c> regDet= new List<VPPSR_Registration_Detail__c>();
        List<VPPSR_Address_For_Service__c> addSer= new List<VPPSR_Address_For_Service__c>();
        List<VPPSR_Change_History__c> chgHist=new List<VPPSR_Change_History__c>();
        Integer i;
        VedaPPSRSearchAPI hist= new VedaPPSRSearchAPI(collId);
        try{
        VPPSR_Serial_Number_Search_Response__c vPSRes= hist.getSearchRes();
        upsert vPSRes;  
         try{
        VPPSR_Search_By_Serial_Num_Resp_Type__c restype=hist.getresTyp();
       
        restype.Veda_PPSR_SerialNumber_Search_Response__c=vPSRes.id;
        insert resType;
           
          
        VPPSR_Search_Summary__c searchSum=hist.getSrcSum();
             
        searchSum.Search_By_Serial_Num_Resp_Type__c=resType.id;
        insert searchSum;
          
        VPPSR_Search_Result__c searchRes= new VPPSR_Search_Result__c();
       
               searchRes=hist.getsrchRes();
         
        searchRes.Search_By_Serial_Num_Resp_Type__c=resType.id;
        insert searchRes;
         
        
        VPPSR_Search_Criteria__c searchCri= hist.getSrcCr();
        
        searchCri.Search_By_Serial_Num_Resp_Type__c=resType.id;
        insert searchCri;
        
        List<VPPSR_Result_Detail__c> resDet= new List<VPPSR_Result_Detail__c>();
       
               resDet.addAll(hist.getResDet());      
        
        for(VPPSR_Result_Detail__c res: resDet){
            
            res.Search_Result__c=searchRes.id;
        }
        insert resDet;
        
       
        chgHist.addAll(hist.getChgHist());   
        
         i= resDet.size();
        integer j=0;
        for(VPPSR_Change_History__c chg:chghist){          
            
            
            chg.Result_Detail__c=resDet[j++].id ;      
            
            
        }
        
        insert chgHist;
        
            
        regdet.addAll(hist.getRegDet());
        
        integer ji=0;
        for(VPPSR_Registration_Detail__c chgg:regdet){  
            
            chgg.Result_Detail__c=resDet[ji++].id;  
            
            
        }        
        
        insert regDet;
        
            
        addSer.addAll(hist.getAddSer()) ;
        
        integer jj=0;
        for(VPPSR_Address_For_Service__c add:addser){
            
            add.Registration_Detail__c=regDet[jj++].id;
            
        }
        insert addSer;
        
            
        List<VPPSR_Mailing_Address__c> mailAdd= new list<VPPSR_Mailing_Address__c>();
        mailAdd.addAll(hist.getMailAdd());
        
        i=0;
        for(VPPSR_Mailing_Address__c mail:mailAdd){
            mail.Address_For_Service__c=addSer[i++].id;
        }
        insert mailAdd;
  
        List<attachment> attList=new List<Attachment>();
            
        attList.addAll(hist.getAttachments());
        
        upsert attList;
  
        List<VPPSR_Grantor__c> gr= new List<VPPSR_Grantor__c>();
  
        gr.addAll(hist.getGrant()) ;
  
        i=0;
        for(VPPSR_Grantor__c g:gr){
            g.Registration_Detail__c=regDet[i++].id;
        }
        insert gr;
  
        List<VPPSR_Individual__c> indList= new List<VPPSR_Individual__c>();
        
        indList.addAll(hist.getInd());
  
        i=0;
        for(VPPSR_Individual__c ind:indList){
            ind.VPPSR_Grantor__c=gr[i++].id;
        }
        insert indList;
  
        List<VPPSR_Organisation__c> orgList= new List<VPPSR_Organisation__c>();
       
        orgList.addAll(hist.getOrg());
  
        i=0;
        for(VPPSR_Organisation__c org:orgList){
            org.VPPSR_Grantor__c=gr[i++].id;
        }
        insert orgList;
  
        List<VPPSR_Secured_Party__c> secParty= new List<VPPSR_Secured_Party__c>();
        
        secParty.addAll(hist.getSecParty());
  
        i=0;
        for(VPPSR_Secured_Party__c sec:secParty){
            sec.Registration_Detail__c=regDet[i++].id;
        }
        insert secParty;
  
        List<VPPSR_Individual__c> indList1= new List<VPPSR_Individual__c>();
       
        indList1.addAll(hist.getInd1());
  
        i=0;
        for(VPPSR_Individual__c ind:indList1){
            ind.VPPSR_Secured_Party__c=secParty[i++].id;
        }
        insert indList1;
  
        List<VPPSR_Organisation__c> orgList1= new List<VPPSR_Organisation__c>();
       
        orgList1.addAll(hist.getOrg1());
  
        i=0;
        for(VPPSR_Organisation__c org:orgList1){
            org.VPPSR_Secured_Party__c=secParty[i++].id;
        }
        insert orgList1;
  
        List<VPPSR_Serial_Number_Detail__c> serList=new List<VPPSR_Serial_Number_Detail__c>();
  
        serList.addAll(hist.getSrNbDt());
        i=0;
        for(VPPSR_Serial_Number_Detail__c srn:serList ){
            srn.Registration_Detail__c=regDet[i++].id;
        }
        insert serList;
  
        VPPSR_Retrieve_Search_Cert_Resp_Type__c retList= new VPPSR_Retrieve_Search_Cert_Resp_Type__c();
       
        retList=(hist.getResponseTyp());
  
        
        retList.Veda_PPSR_SerialNumber_Search_Response__c=vPSRes.id;
        
        insert retList;
  
        VPPSR_NevdisData__c colData=new VPPSR_NevdisData__c();
       
        colData=hist.getColData();
  
        colData.Search_Result__c=searchRes.id;
        insert colData;
  
        VPPSR_Vehicle_Detail__c colSet=new VPPSR_Vehicle_Detail__c();
      
        colSet=hist.getColSet();
  
        colSet.NevdisData__c=colData.id;
        insert colSet;
  
        Registration__c reg= new Registration__c();
     
        reg=hist.getReg();
  
        reg.Collateral_Detail__c=colset.id;
        insert reg;
  
        VPPSR_Vehicle_Description__c vehDesc=new VPPSR_Vehicle_Description__c();
      
        vehDesc=hist.getVehDisc();
  
        vehDesc.Collateral_Detail__c=colset.id;
        insert vehDesc;
  
        VPPSR_Vehicle_Identifier__c vehIden= new VPPSR_Vehicle_Identifier__c();
      
        vehIden=hist.getVehIden();
  
        VEHiDEN.NevdisData__c=colData.id;
        insert vehIden;
         }catch(Exception ex){
              
            }
        vPSRes =[Select id,Collateral__c,search_Certificate_Number__c,integrationErrorStatusCode__c,integrationErrorStatus__c from VPPSR_Serial_Number_Search_Response__c where id=:vPSRes.id];
        system.debug('<-------OUTPUT QUERY---------------->'+ vPSRes);
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
        
    }
    
    
}