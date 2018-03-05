/**
* @author  Krishnanand Gupta(SaaSfocus)
* @version 1.0
* @since   2016-05-10 
* @Desc This is a helping class for Transaction history wrapper pagination
*/
public class  pepIterable implements Iterator<list<WrpTransactionHistory>>
{ 
   public list<WrpTransactionHistory> InnerList{get; set;}
   public list<WrpTransactionHistory> ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize{get; set;}
   public Integer setPageNumber{get; set;}  

   public pepIterable(List<WrpTransactionHistory> lstAccWr)
   {
       InnerList = new list<WrpTransactionHistory>(); 
       ListRequested = new list<WrpTransactionHistory>();     
       InnerList = lstAccWr;
       setPageSize = 10;
       i = 0; 
   }   

   public boolean hasNext(){ 
       if(i >= InnerList.size()) {
           return false; 
       } else {
           return true; 
       }
   } 
   
   public boolean hasPrevious(){ 
       system.debug('I am in hasPrevious' + i);
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

 public list<WrpTransactionHistory> goToPage(Integer PageNumber){       
      ListRequested = new list<WrpTransactionHistory>(); 
       integer startNumber;
       integer size = InnerList.size();
       //startNumber=
        startNumber=((PageNumber-1)*setPageSize);
       Integer TotalPages=integer.valueof(size/setPageSize);
       
       
        startNumber = startNumber;
         i =(startNumber + setPageSize);   
       
        for(integer start = startNumber ; start < i; start++)
           {
             if(start<size)
               ListRequested.add(InnerList[start]);
           }
     
       return ListRequested;
   } 


   public list<WrpTransactionHistory> next(){       
       system.debug('i value is ' + i);
       ListRequested = new list<WrpTransactionHistory>(); 
       integer startNumber;
       integer size = InnerList.size();
       if(hasNext())
       {  
           if(size <= (i + setPageSize))
           {
               startNumber = i;
               i = size;
           }
           else
           {
               i = (i + setPageSize);
               startNumber = (i - setPageSize);
           }
           
           system.debug('i value is =====' + i);
           system.debug('i value is 2==== ' + (i - setPageSize));
           
           for(integer start = startNumber; start < i; start++)
           {
               ListRequested.add(InnerList[start]);
           }
       } 
       return ListRequested;
   } 
   
   public list<WrpTransactionHistory> previous(){      
       ListRequested = new list<WrpTransactionHistory>(); 
       system.debug('i value is previous before =====' + i);
       integer size = InnerList.size(); 
       if(i == size)
       {
           if(math.mod(size, setPageSize) > 0)
           {    
               i = size - math.mod(size, setPageSize);
           }
           else
           {
               i = (size - setPageSize);
           } 
       }
       else
       {
           i = (i - setPageSize);
       }
       
      for(integer start = (i - setPageSize); start < i; ++start)
       {
           ListRequested.add(InnerList[start]);
       } 
       return ListRequested;
   }   
}