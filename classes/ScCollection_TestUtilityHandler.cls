// ----------------------------------------------------------------------------------------------------
// This class would be used as a tracker class for ScCollection_UtilityHandler class
// ----------------------------------------------------------------------------------------------------
// Created Date: 16-AUG-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
@isTest(seeAllData = false)
public class ScCollection_TestUtilityHandler
{   
    public static testMethod void myUnitTest()
    { 
        ScCollection_UtilityHandler ScColl = new ScCollection_UtilityHandler();
        ScCollection_UtilityHandler.isNotNull('abc');
        
        Lead Ld = new Lead();
        Ld.LastName='Test';
        Ld.Status='Working';
        insert Ld;
        ScCollection_UtilityHandler.isNotNull(Ld.id);
       
        Set<string> st = new Set<String>();
        st.add('a');
        st.add('b');
        ScCollection_UtilityHandler.isNotNull(st); 
       
        List<string> lst = new List<String>();
        lst.add('a');
        lst.add('b');
        ScCollection_UtilityHandler.isNotNull(lst);
       
        Set<id> sId = new Set<id>();
        sId.add(Ld.id);
        ScCollection_UtilityHandler.isNotNull(sId);
       
        List<Sobject> lstSobj = new List<Sobject>();
        lstSobj.add(Ld);
        ScCollection_UtilityHandler.isNotNull(lstSobj);
       
        Map<String,Sobject> mapObj = new Map<String,Sobject>();
        mapObj.put('ab',Ld);
        ScCollection_UtilityHandler.isNotNull(mapObj);
       
        ScCollection_UtilityHandler.get15DigitId(Ld.id);
       
        ScCollection_UtilityHandler.getPlainString('mno');
        ScCollection_UtilityHandler.getPlainString(null);   
       
        ScCollection_UtilityHandler.isValidEmail('mayankbhardwaj127@gmail.com');
        ScCollection_UtilityHandler.generateHash('mayankbhardwaj127@gmail.com'); 
       
        ScCollection_UtilityHandler.generateRandomHash();
       
        ScCollection_UtilityHandler.generateRandomString(6);
       
        ScCollection_UtilityHandler.isWeekend(Date.Today());
       
        ScCollection_UtilityHandler.parseTime('8:15:16');
        ScCollection_UtilityHandler.parseTime(null); 
       
        ScCollection_UtilityHandler.parseDate('1/12/2016');
       
        date dt = date.parse('1/10/2009');
        ScCollection_UtilityHandler.formatForIO(dt);
       
        Time dtime=Time.newInstance(8,10,20,500);
        ScCollection_UtilityHandler.formatForIO(dtime);
       
        Datetime datime=Datetime.newInstance(2,10,2016,9,16,16);
        ScCollection_UtilityHandler.formatForIO(datime);

        ScCollection_UtilityHandler.formatForDisplay(dt);
        ScCollection_UtilityHandler.formatForLongDisplay(dt); 
        ScCollection_UtilityHandler.formatForDisplay(dtime);
        ScCollection_UtilityHandler.formatDateForShortDisplay(dt); 
        ScCollection_UtilityHandler.formatDateForGrid(dt);
        ScCollection_UtilityHandler.roundHour(dtime);
        
        String []Objstring1 = new String[]{'a','b','c','d'};
        String objString2 = 'c';
        ScCollection_UtilityHandler.getIndex(Objstring1,objString2);
        String objString3 = 'f';
        ScCollection_UtilityHandler.getIndex(Objstring1,objString3);
        
        Double d = 3.14159;
        ScCollection_UtilityHandler.formatRound(d);
        ScCollection_UtilityHandler.formatCurrency(d);
        
        Map<id,Lead> mapSobject = new Map<id,Lead>();
        mapSobject.put(Ld.id,Ld);
        ScCollection_UtilityHandler.isNotNull(mapSobject);
    }    
}