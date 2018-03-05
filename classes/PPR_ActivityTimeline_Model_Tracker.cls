/*------------------------------------------------------------
Author:        Sandip Bijlwan
Name:          PPR_ActivityTimeline_Model_Tracker 
Company:       Saasfocus
Description:   This is the Test Class for PPR_ActivityTimeline_Model
History
Date    :  29/09/2017     
------------------------------------------------------------*/
@isTest(SeeAllData=false)
Public class PPR_ActivityTimeline_Model_Tracker{
    
    
   /*----------------------------------------------------------------------------------
    Author:        Sandip Bijlwan
    Name:          compareToTest
    Company:       Saasfocus
    Description:   testing compareTo method
    Inputs:        
    Returns:       void
    -----------------------------------------------------------------------------------*/
    
    @isTest
    Public static void compareToTest(){
        
        PPR_ActivityTimeline_Model objClass = new PPR_ActivityTimeline_Model();
        objClass.RecordId = null;
        objClass.ActivityTimelineType = 'SMS';
        objClass.Subject = 'subjetc';
        objClass.Detail = 'Detail';
        objClass.ShortDate = 'ShortDate';
        objClass.Recipients= 'Recipients';
        objClass.ActualDate = system.now();
        objClass.formatteddate = 'formatteddate';
        objClass.messagetype = 'messagetype';
        objClass.parentRecordId = 'parentRecordId';
        objClass.delieveryStatus = 'delieveryStatus';
        
        PPR_ActivityTimeline_Model obj = new PPR_ActivityTimeline_Model();
        Integer intNum = obj.compareTo(objClass);
        system.debug(intnum); 
        
        system.assert(intNum == -1 , 'worked');
    }
    
    
}