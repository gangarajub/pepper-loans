/*------------------------------------------------------------
Author:        Varun Arora
Name:          CustomWrapp 
Company:       Saasfocus
Description:   This is used as the wrapper for the returning 
               the search object.
History
Date    :  18/05/2017     
------------------------------------------------------------*/
Public class CustomWrapp{
    @AuraEnabled
    Public string Id{get;set;}
     
    @AuraEnabled
    Public String Name{get;set;}
     
    @AuraEnabled
    Public String mobilePhone{get;set;}
     
    @AuraEnabled
    Public String sobjecttype{get;set;} 
}