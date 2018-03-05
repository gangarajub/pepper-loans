global class UncheckShowDetailsFlag{
            
            
            webservice static void uncheckShowDetaislFlagOfVedaFraud(String VedaFraudID,String AppId){
                
                List<Veda_Fraud__c> VedaFraudList = new List<Veda_Fraud__c>();
                List<Veda_Fraud__c> currentVedaFraud = new List<Veda_Fraud__c>();
                currentVedaFraud = [select id,name,Application__c from Veda_Fraud__c where Id=:VedaFraudID];
                currentVedaFraud[0].Show_Details__c=true;
                update currentVedaFraud[0];
                system.debug('currentVedaFraud'+currentVedaFraud);
                if(currentVedaFraud.size()==1){
                
                List<Veda_Fraud__c> VedaFraudListToBeUpdated = new List<Veda_Fraud__c>();
                VedaFraudList = [select id,name from Veda_Fraud__c where Id!=:VedaFraudID and Application__c=:currentVedaFraud[0].Application__c];
                
                for(Veda_Fraud__c IdMatx:VedaFraudList){
                    IdMatx.Show_Details__c=false;
                    VedaFraudListToBeUpdated.add(IdMatx); 
                
                }
                update  VedaFraudListToBeUpdated;
                }else{
                
                }  
                
            }
            
            webservice static void uncheckShowDetailsFlagForCollateral(String colID){
                
                List<clcommon__Collateral__c> colList = new List<clcommon__Collateral__c>();
                List<clcommon__Collateral__c> currentCol = new List<clcommon__Collateral__c>();
                currentCol = [select id,
                                     name,
                                     genesis__Application__c 
                              from clcommon__Collateral__c
                              where Id =: colID];
                
                if(currentCol.size() == 1){
                    currentCol[0].Show_Details__c = true;
                    update currentCol[0];
                
                    system.debug('currentCol : ' + currentCol);
                     List<clcommon__Collateral__c> colListTBU = new List<clcommon__Collateral__c>();
                    colList = [select id,
                                      name,
                                      Show_Details__c 
                               from clcommon__Collateral__c 
                               where Id != :colID 
                               and genesis__Application__c =: currentCol[0].genesis__Application__c];
                
                    for(clcommon__Collateral__c IdMatx : colList){
                        IdMatx.Show_Details__c=false;
                        colListTBU.add(IdMatx); 
                    }
                    update colListTBU;
                }else{
                
                }  
                
            }
            
                webservice static void uncheckShowDetaislOfIdMatrix(String IdMatrixID,String AppId){
                
                List<Veda_IdMatrix__c> IdMatrixList = new List<Veda_IdMatrix__c>();
                List<Veda_IdMatrix__c> currentIdMatrix = new List<Veda_IdMatrix__c>();
                currentIdMatrix = [select id,name,Application__c from Veda_IdMatrix__c where Id=:IdMatrixID];
                currentIdMatrix[0].Show_Details__c=true;
                update currentIdMatrix[0];
                system.debug('currentIdMatrix'+currentIdMatrix);
                if(currentIdMatrix.size()==1){
                
                List<Veda_IdMatrix__c> IdMatrixListToBeUpdated = new List<Veda_IdMatrix__c>();
                IdMatrixList = [select id,name from Veda_IdMatrix__c where Id!=:IdMatrixID and Application__c=:currentIdMatrix[0].Application__c];
                
                for(Veda_IdMatrix__c IdMatx:IdMatrixList){
                    IdMatx.Show_Details__c=false;
                    IdMatrixListToBeUpdated.add(IdMatx); 
                
                }
                update  IdMatrixListToBeUpdated;
                }else{
                
                }  
                
            }
            webservice static void uncheckShowDetaislOfVedaComprehensive(String vedaComprehensiveId,String AppId){
                
                List<Veda_Comprehensive__c> vedaIdComprehensive = new List<Veda_Comprehensive__c>();
                List<Veda_Comprehensive__c> currentVedaComp = new List<Veda_Comprehensive__c>();
                currentVedaComp = [select id,name,Application__c from Veda_Comprehensive__c where Id=:vedaComprehensiveId];
                currentVedaComp[0].Show_Details__c=true;
                update currentVedaComp[0];
                system.debug('currentVedaComp '+currentVedaComp );
                if(currentVedaComp.size()==1){
                
                List<Veda_Comprehensive__c> vedaComprehenisveToBeUpdated = new List<Veda_Comprehensive__c>();
                vedaIdComprehensive = [select id,name from Veda_Comprehensive__c where Id!=:vedaComprehensiveId and Application__c=:currentVedaComp[0].Application__c];
                
                for(Veda_Comprehensive__c veda: vedaIdComprehensive ){
                    veda.Show_Details__c=false;
                    vedaComprehenisveToBeUpdated.add(veda); 
                
                }
                update  vedaComprehenisveToBeUpdated;
                }else{
                
                }  
                
            }
               webservice static void uncheckShowDetaislOfDanB(String DanBId,String AppId){
                
                List<DandB__c> DandBList = new List<DandB__c>();
                List<DandB__c> currentDandB = new List<DandB__c>();
                currentDandB = [select id,name,Application__c from DandB__c where Id=:DanBId];
                currentDandB[0].showDetails__c=true;
                update currentDandB[0];
                system.debug('currentDandB '+currentDandB );
                if(currentDandB.size()==1){
                
                List<DandB__c> currentDndBepdated = new List<DandB__c>();
                DandBList = [select id,name from DandB__c where Id!=:DanBId and Application__c=:currentDandB[0].Application__c];
                
                for(DandB__c veda: DandBList ){
                    veda.showDetails__c=false;
                    currentDndBepdated.add(veda); 
                
                }
                update  currentDndBepdated;
                }else{
                
                }  
                
            }
            
}