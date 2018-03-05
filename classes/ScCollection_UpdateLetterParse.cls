global class ScCollection_UpdateLetterParse{


        global String type{get;set;}
        public String description{get;set;}
        public String destination{get;set;}
        public list<ids> ids{get;set;}
        public String business{get;set;}
        public document document{get;set;}
        public String company{get;set;}
    global class indexes{
        public String CreationTime{get;set;}
        public String RecipientIdentifier{get;set;}
        public String AccountIdentifier{get;set;}
        public String RecipientName{get;set;}
        public String LetterDate{get;set;}
        public String RecipientAddress{get;set;}
        public String CreationDate{get;set;}
        public String DPID{get;set;}
        public String LetterFormIdentifier{get;set;}
        public String OutputMethod{get;set;}
        public String Category{get;set;}
        public String OutputLocation{get;set;}
        public String Application{get;set;}
        public String AggregatorShortName{get;set;}
        public String Region{get;set;}
        public String Format{get;set;}
        public String CountryCode{get;set;}
        public String DocumentType{get;set;}
        public String FileDate{get;set;}
        public String DocumentTypeIdentifier{get;set;}
        public Integer ItemID{get;set;}
        public String BarcodeLinkage{get;set;}
        public String APPID{get;set;}
        public String Status{get;set;}
        public String BCUID{get;set;}
        public String ErrorHandler{get;set;}
        public String Filedby{get;set;}
        public String LeadID{get;set;}
    }
    global class ids{
        public String value{get;set;}
        public String description{get;set;}
        public String type{get;set;}
    }
    global class document{
        public String path{get;set;}
        public String description{get;set;}
        public String linktype{get;set;}
        public Integer name{get;set;}
        public indexes indexes{get;set;}
        public String type{get;set;}
    }
    
    
   global ScCollection_UpdateLetterParse parse(String jsonString){
   
       return (ScCollection_UpdateLetterParse)JSON.deserialize(jsonString, ScCollection_UpdateLetterParse.class);
   }


}