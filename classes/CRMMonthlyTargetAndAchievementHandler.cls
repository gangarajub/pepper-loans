/*------------------------------------------------------------
Author:        Chayan Batabyal  
Name:          CRMMonthlyTargetAndAchievementHandler
Company:       Saasfocus
Description:   A utility class for the CRMTrgOnMonthlyTargetAndAchievement
               trigger
History     
------------------------------------------------------------*/
public class CRMMonthlyTargetAndAchievementHandler
{
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          runTrigger
    Company:       Saasfocus
    Description:   This method is called from trigger when 
    handler had been initialized, and used to call the other handler methods. 
    Inputs:        
    Returns:       void
    History
    ------------------------------------------------------------*/
    public void runTrigger()
    {
        // Method will be called to handle After Insert events
        if (Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<CRM_Monthly_Target_and_Achievement__c>) trigger.new, (map<id, CRM_Monthly_Target_and_Achievement__c>) trigger.NewMap);
        }
    }
    
    /*------------------------------------------------------------
    Author:        Chayan Batabyal
    Name:          onAfterInsert
    Company:       Saasfocus
    Description:   This method is is called if the event is after insert from runTrigger method.
    Inputs:        list<CRM_Monthly_Target_and_Achievement__c,map<id,CRM_Monthly_Target_and_Achievement__c>
    Returns:       void
    History
    ------------------------------------------------------------*/
    public void onAfterInsert(list<CRM_Monthly_Target_and_Achievement__c> lstTriggerNew,map<id,CRM_Monthly_Target_and_Achievement__c> triggerNewMap)
    {
        createWeeklyTargetAndAchievement(lstTriggerNew);
    }
    
    public static List<CRM_Weekly_Target_and_Achievement__c> lstWeeklyToInsert = new List<CRM_Weekly_Target_and_Achievement__c>();
    
    /*------------------------------------------------------------
    Author:        Sandip R Bijlwan
    Name:          createWeeklyTargetAndAchievement
    Company:       Saasfocus
    Description:   Creates 4 or 5 Weekly Target and Achievement For each Monthly Target and Achievement
    Inputs:        list<CRM_Monthly_Target_and_Achievement__c>
    Returns:       void
    History
    ------------------------------------------------------------*/
    
    private static void createWeeklyTargetAndAchievement(list<CRM_Monthly_Target_and_Achievement__c> lstTriggerNew)
    {
        Integer i;
        Integer intStart;
        Integer intEnd;
        String strYear;
        String strStartYear;
        String strEndYear;
        Set<ID> setOfMonthlyIDs = new Set<ID>();
        CRM_Weekly_Target_and_Achievement__c objToInsert;
        List<CRM_Monthly_Target_and_Achievement__c> lstMonthly = new List<CRM_Monthly_Target_and_Achievement__c>();
        
        Integer fiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        
        if(lstTriggerNew != NULL && lstTriggerNew.size() > 0)
        {
            for(CRM_Monthly_Target_and_Achievement__c eachMonthly : lstTriggerNew)
            {
                if(eachMonthly.CRM_Month__c != NULL && eachMonthly.CRM_Month__c != '')
                    setOfMonthlyIDs.add(eachMonthly.id);
            }
            
            if(setOfMonthlyIDs != NULL && setOfMonthlyIDs.size() > 0)
            {
                lstMonthly = [Select id, CRM_Month__c, CRM_KPI__c, CRM_KPI__r.CRM_Year__c 
                    from CRM_Monthly_Target_and_Achievement__c
                    where id in : setOfMonthlyIDs];
                
                for(CRM_Monthly_Target_and_Achievement__c eachMonthly : lstMonthly)
                {
                    if(!String.IsBlank(eachMonthly.CRM_KPI__r.CRM_Year__c)){
                        strYear = eachMonthly.CRM_KPI__r.CRM_Year__c;
                        strStartYear = (eachMonthly.CRM_KPI__r.CRM_Year__c.split('\\-')[0]).trim();
                        strEndYear = (eachMonthly.CRM_KPI__r.CRM_Year__c.split('\\-')[1]).trim();
                    }
                    
                    // Monthly Records are created from Quarterly Trigger... 
                    //so created branches for different months...and with every month records weekly records are created.   
                    if(eachMonthly.CRM_Month__c.equalsIgnoreCase('JANUARY'))
                    {
                        if(fiscalYearStartMonth <= 1 ){
                            createWeeklyRecords(1,strStartYear,31,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(1,strEndYear,31,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('FEBRUARY')){
                        Integer intLastDayOfMonth = 28;
                        
                        if(fiscalYearStartMonth <= 2 ){                     
                            if(Date.isLeapYear(Integer.valueOf(strStartYear))){
                                intLastDayOfMonth = 29;
                            }    
                            createWeeklyRecords(2,strStartYear,intLastDayOfMonth,eachMonthly.id);
                        }
                        else{
                            if(Date.isLeapYear(Integer.valueOf(strEndYear))){
                                intLastDayOfMonth = 29;
                            }   
                            createWeeklyRecords(2,strEndYear,intLastDayOfMonth,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('MARCH'))
                    {
                        if(fiscalYearStartMonth <= 3 ){
                            createWeeklyRecords(3,strStartYear,31,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(3,strEndYear,31,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('APRIL'))
                    {
                        if(fiscalYearStartMonth <= 4 ){
                            createWeeklyRecords(4,strStartYear,30,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(4,strEndYear,30,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('MAY'))
                    {
                        if(fiscalYearStartMonth <= 5 ){
                            createWeeklyRecords(5,strStartYear,31,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(5,strEndYear,31,eachMonthly.id);
                        }
                        
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('JUNE'))
                    {
                        if(fiscalYearStartMonth <= 6 ){
                            createWeeklyRecords(6,strStartYear,30,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(6,strEndYear,30,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('JULY'))
                    {
                        if(fiscalYearStartMonth <= 7 ){
                            createWeeklyRecords(7,strStartYear,31,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(7,strEndYear,31,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('AUGUST'))
                    {
                        if(fiscalYearStartMonth <= 8 ){
                            createWeeklyRecords(8,strStartYear,31,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(8,strEndYear,31,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('SEPTEMBER'))
                    {
                        if(fiscalYearStartMonth <= 9 ){
                            createWeeklyRecords(9,strStartYear,30,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(9,strEndYear,30,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('OCTOBER'))
                    {
                        if(fiscalYearStartMonth <= 10 ){
                            createWeeklyRecords(10,strStartYear,31,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(10,strEndYear,31,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('NOVEMBER'))
                    {
                        if(fiscalYearStartMonth <= 11 ){
                            createWeeklyRecords(11,strStartYear,30,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(11,strEndYear,30,eachMonthly.id);
                        }
                            
                    }
                    
                    else if(eachMonthly.CRM_Month__c.equalsIgnoreCase('DECEMBER'))
                    {
                        if(fiscalYearStartMonth <= 12 ){
                            createWeeklyRecords(12,strStartYear,31,eachMonthly.id);
                        }
                        else{
                            createWeeklyRecords(12,strEndYear,31,eachMonthly.id);
                        }
                            
                    }
                }
                
                if(lstWeeklyToInsert != NULL && lstWeeklyToInsert.size() > 0)
                    insert lstWeeklyToInsert;
            }
        }
    }
    /*------------------------------------------------------------
    Author:        Sandip R Bijwan
    Name:          calculateFirstWeekEndDateDay
    Company:       Saasfocus
    Description:   This method is use to create the Weekly Record.
    Inputs:       Integer, Integer
    Returns:       void
    History
    ------------------------------------------------------------*/
    private static Integer calculateFirstWeekEndDateDay(Integer strYear,Integer strMonth){

        DateTime dtTimeFirstDayOfYearMonth = DateTime.newInstanceGMT(Integer.valueOf(strYear),strMonth, 1);
        
        String strDayOfWeekName = dtTimeFirstDayOfYearMonth.format('EEEE');
        
        Integer intEndWeekNumber;
        if(strDayOfWeekName.equalsIgnoreCase('sunday')){
            intEndWeekNumber = 7;
        }
        else if(strDayOfWeekName.equalsIgnoreCase('monday')){
            intEndWeekNumber = 6;
        }
        else if(strDayOfWeekName.equalsIgnoreCase('tuesday')){
            intEndWeekNumber = 5;
        }
        else if(strDayOfWeekName.equalsIgnoreCase('wednesday')){
            intEndWeekNumber = 4;
        }
        else if(strDayOfWeekName.equalsIgnoreCase('thursday')){
            intEndWeekNumber = 3;
            
        }
        else if(strDayOfWeekName.equalsIgnoreCase('friday')){
            intEndWeekNumber = 2;
        }
        else{
            intEndWeekNumber = 1;
        }
        return intEndWeekNumber;
    }
    
    /*------------------------------------------------------------
    Author:        Sandip R Bijwan
    Name:          createWeeklyRecords
    Company:       Saasfocus
    Description:   This method is use to create the Weekly Record.
    Inputs:       Integer, String,Integer,String
    Returns:       void
    History
    ------------------------------------------------------------*/
    private static void createWeeklyRecords(Integer intMonthNumber,String strEndYear,Integer intMonthEndDate,String strParentId){
    
        Integer weekNumber = 1;
                            
        //Calculate the First End Week Number
        Integer firstEndDate = calculateFirstWeekEndDateDay(Integer.valueOf(strEndYear),intMonthNumber);
        
        //Creating First Week Data
        CRM_Weekly_Target_and_Achievement__c objToInsertFirstWeek = new CRM_Weekly_Target_and_Achievement__c();
        objToInsertFirstWeek.Name = 'Week ' + weekNumber + ' Target and Achievement';
        objToInsertFirstWeek.CRM_From__c = Date.newInstance(Integer.valueOf(strEndYear), intMonthNumber, 1);
        objToInsertFirstWeek.CRM_To__c = Date.newInstance(Integer.valueOf(strEndYear), intMonthNumber, firstEndDate);
        objToInsertFirstWeek.CRM_Monthly_Target_and_Achievement__c = strParentId;
        lstWeeklyToInsert.add(objToInsertFirstWeek);
        
        for(Integer startWeekNumber = firstEndDate + 1; startWeekNumber <= intMonthEndDate ; startWeekNumber += 7){
            weekNumber +=1;
            CRM_Weekly_Target_and_Achievement__c objToInsert = new CRM_Weekly_Target_and_Achievement__c();
            objToInsert.Name = 'Week ' + weekNumber + ' Target and Achievement';
            objToInsert.CRM_From__c = Date.newInstance(Integer.valueOf(strEndYear), intMonthNumber, startWeekNumber);
            
            Integer intEndWeekNumber = startWeekNumber + 6;
            if(intEndWeekNumber <= intMonthEndDate){
                objToInsert.CRM_To__c = Date.newInstance(Integer.valueOf(strEndYear), intMonthNumber, intEndWeekNumber);
            }
            else{
                objToInsert.CRM_To__c = Date.newInstance(Integer.valueOf(strEndYear), intMonthNumber, intMonthEndDate);
            }
            objToInsert.CRM_Monthly_Target_and_Achievement__c = strParentId;
            lstWeeklyToInsert.add(objToInsert);
        }

    }
}