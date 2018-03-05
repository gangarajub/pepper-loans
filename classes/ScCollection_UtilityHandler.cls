// ----------------------------------------------------------------------------------------------------
// This class would be used to host common utility methods that can be used throughout the org.
// ----------------------------------------------------------------------------------------------------
// Created Date: 08-JULY-2016    Created By: Pawan Mudgal    Email: pawan.mudgal@saasfocus.com
// ----------------------------------------------------------------------------------------------------
// Test Class : ScCollection_TestUtilityHandler
// ----------------------------------------------------------------------------------------------------
public class ScCollection_UtilityHandler
{
    //checks null for a string
    public static Boolean isNotNull(String s) 
    {
        return s != NULL && s != '';
    }
    
    //checks null for an Id
    public static Boolean isNotNull(Id s) 
    {
        return s != NULL;
    }
    
    //checks null for a set of string
    public static Boolean isNotNull(Set<String> s) 
    {
        return s != NULL && s.size() > 0;
    }
    
    //checks null for a list of string
    public static Boolean isNotNull(List<String> s) 
    {
        return s != NULL && s.size() > 0;
    }
    
    //checks null for a set of Ids
    public static Boolean isNotNull(Set<Id> s) 
    {
        return s != NULL && s.size() > 0;
    }
    
    //checks null for a list of sobjects
    public static Boolean isNotNull(List<SObject> s) 
    {
        return s != NULL && s.size() > 0;
    }
    
    //checks null for a map of id to sobjects
    public static Boolean isNotNull(Map<Id,SObject> s) 
    {
        return s != NULL && s.size() > 0;
    }
    
    //checks null for a map of string to sobjects
    public static Boolean isNotNull(Map<String,SObject> s) 
    {
        return s != NULL && s.size() > 0;
    }
    
    //convert a 18 digit id to 15 digits
    public static Id get15DigitId(Id strId)
    {
        return Id.valueof(String.valueof(strId).substring(0,15));
    }
    
    //remove special characters from string
    public static String getPlainString(String strValue)
    {
        if(ScCollection_UtilityHandler.isNotNull(strValue))
        {
            Pattern nonAlphanumeric = Pattern.compile('[^a-zA-Z0-9]');
            Matcher matcher = nonAlphanumeric.matcher(strValue);
            return(String.valueof(matcher.replaceAll('')));
        }
        else
        {
            return Null;
        }
    }

    //checs the validity of an email
    public static Boolean isValidEmail(String email) 
    {
        String InputString = email;
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(InputString);
        
        return MyMatcher.matches();
    }
    
    //generates a hash value
    public static String generateHash(String value) 
    {
        return EncodingUtil.convertToHex(Crypto.generateDigest('SHA-1', Blob.valueOf(value)));
    }
    
    //generates a random hash value
    public static String generateRandomHash() 
    {
        return generateHash(Datetime.now().format() + String.valueOf(Math.random()));
    }
    
    //generates a random string
    public static String generateRandomString(Integer length) 
    {
        return generateRandomHash().substring(0, length - 1);
    }
    
    //checks whether the given day is a weekend
    public static Boolean isWeekend(Date d) 
    {
        Datetime dt = Datetime.newInstance(d, Time.newInstance(0,0,0,0));
        String day = dt.format('E');
        
        return day == 'Sun' || day == 'Sat';
    }
    
    //returns a time object from a time string
    public static Time parseTime(String timeString) 
    {
        if(timeString != null) 
        {
           String[] timeParts = timeString.split(':');
           return Time.newInstance(Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), 0, 0);
        }
        else 
        {
            return null;
        }
    }
    
    //returns a date object from a date string
    public static Date parseDate(String dateString) 
    {
        return ScCollection_UtilityHandler.isNotNull(dateString) ? Date.parse(dateString) : null;
    }
    
    //returns a date in dd/mm/yyyy format
    public static String formatForIO(Date d) 
    {
        return d == null ? null : DateTime.newInstance(d, Time.newInstance(0, 0, 0, 0)).format('dd/MM/yyyy');
    }
    
    //returns a time in HH:mm:ss format
    public static String formatForIO(Time t) 
    {
        return t == null ? null : Datetime.newInstance(Date.today(), t).format('HH:mm:ss');
    }
    
    // returns a datetime in dd/MM/yyyy h:mm a format
    public static String formatForIO(Datetime dt) 
    {
        return dt == null ? null : dt.format('dd/MM/yyyy h:mm a');
    }
    
    //returns a time in h:mm a format
    public static String formatForDisplay(Time t) 
    {
        return t != null ? Datetime.newInstance(Date.today(), t).format('h:mm a') : null;
    }
    
    //returns a date in EEE M/d format
    public static String formatForDisplay(Date d) 
    {
        return d != null ? Datetime.newInstance(d, Time.newInstancE(0, 0, 0, 0)).format('EEE M/d') : null;
    }
    
    //returns a date in EEEE d \'of\' MMMM format
    public static String formatForLongDisplay(Date d) 
    {
        return d != null ? Datetime.newInstance(d, Time.newInstancE(0, 0, 0, 0)).format('EEEE d \'of\' MMMM') : null;
    }
    
    //returns a date in EEEE\',\' M/dd/yy format
    public static String formatDateForShortDisplay(Date d) 
    {
        return d != null ? Datetime.newInstance(d, Time.newInstancE(0, 0, 0, 0)).format('EEEE\',\' M/dd/yy') : null;
    }
    
    //returns a date in EEE\',\' M/dd/yy format
    public static String formatDateForGrid(Date d) 
    {
        return d != null ? Datetime.newInstance(d, Time.newInstancE(0, 0, 0, 0)).format('EEE\',\' M/dd/yy') : null;
    }
    
    //rounding off the time into the nearest hour time
    public static Time roundHour(Time t) 
    {
        return t.minute() > 29 ? Time.newInstance(t.hour() + 1, 0, 0, 0) : Time.newInstance(t.hour(), 0, 0, 0);
    }
    
    //get the index of an element in a list of string
    public static Integer getIndex(String[] elements, String e) 
    {
        for (Integer i = 0; i < elements.size(); i++) 
        {
            if(ScCollection_UtilityHandler.isNotNull(elements[i]) && elements[i].equals(e)) 
            {
                return i;
            } 
        } 
        return -1;
    }
    
    //rounding off a decimal value
    public static String formatRound(Double val)
    {
        Double abs = (val < 0 ? -val : val);
        return abs.intValue().format() + '.' + Decimal.valueOf(val).setScale(2).toPlainString().split('\\.')[1];     
    }
    
    //format a currency field
    public static String formatCurrency(Double val) 
    {    
        Double abs = (val < 0 ? -val : val);
        return (val < 0 ? '-' : '') + '$' + abs.intValue().format() + '.' + Decimal.valueOf(val).setScale(2).toPlainString().split('\\.')[1];        
    }
}