// ---------------------------------------------------------------------------------------------------------
// This class is  used to implement the pagination for pepDocumentInboxController class. 
// 
//      Date                       Author                
// ---------------------------------------------------------------------------------------------------------
//      3rd June 2016           Rishabh Tyagi          
// ---------------------------------------------------------------------------------------------------------

public class  PepDocumentInboxPagination implements Iterator<list<Attachment>>
{ 
   public list<Attachment> InnerList{get; set;}
   public list<Attachment> ListRequested{get; set;}

   Integer i {get; set;} 
   public Integer setPageSize{get; set;}
   public Integer setPageNumber{get; set;}  

   public PepDocumentInboxPagination(List<Attachment> lstAccWr)
   {
       InnerList = new list<Attachment>(); 
       ListRequested = new list<Attachment>();     
       InnerList = lstAccWr;
       setPageSize = 5;
       i = 0; 
   }  
    
// This method returns true if list has more elements

   public boolean hasNext(){ 
       if(i >= InnerList.size()) {
           return false; 
       } else {
           return true; 
       }
   } 
   
  // This method returns true if list has Previous page's elements
   
   public boolean hasPrevious(){ 
       system.debug('I am in hasPrevious' + i);
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }   

// This method is used to set elements for specific page number

 public list<Attachment> goToPage(Integer PageNumber){       
      ListRequested = new list<Attachment>(); 
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

// This method is used to set next elements in list

   public list<Attachment> next(){       
       system.debug('i value is ' + i);
       ListRequested = new list<Attachment>(); 
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
 // This method is used to set previous elements in list
   
   public list<Attachment> previous(){      
       ListRequested = new list<Attachment>(); 
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