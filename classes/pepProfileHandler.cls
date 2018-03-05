public class pepProfileHandler{
    public cls_mfa mfa{get;set;}
    public String user_token{get;set;} 
    Public class cls_mfa {
        public String title{get;set;}   
        public cls_fields[] fields{get;set;}
    }
    Public class cls_fields {
        public String type{get;set;}
        public String value{get;set;}
        Public Map<string,string> options{get;set;}
        Public String id{get;set;}
        Public String label{get;set;}
        Public string name{get;set;}
        Public html_cls htmlAttrs{get;set;}
        Public cls_subelement[] subElements{get;set;}
        Public string script{get;set;}
    }
    Public class cls_subelement{
    Public string type{get;set;}
    Public string value{get;set;}
    Public string id{get;set;}
    Public boolean active{get;set;}
    Public string src{get;set;}
    Public html_subcls htmlAttrs{get;set;}
   }
    Public class html_cls{
    Public string autocomplete{get;set;}
    Public string value{get;set;}
    Public string onclick{get;set;}
    }
    Public class html_subcls{
    Public string onclick{get;set;}
    }
}