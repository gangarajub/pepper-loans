public class ScCollection_MeetingNotesResponseSuccess{
        public APIStatus APIStatus{get;set;}
    public class PepperReferences{
        public PepperReference PepperReference{get;set;}
    }
    public class PepperReference{
        public String Reference{get;set;}
        public String ReferenceType{get;set;}
    }
    public class Messages{
        public Message Message{get;set;}
    }
    public class Message{
        public String MessageCode{get;set;}
        public String MessageId{get;set;}
        public String MessageDescription{get;set;}
    }
    public class ClientReferences{
        public ClientReference ClientReference{get;set;}
    }
    public class ClientReference{
        public String Reference{get;set;}
        public String ReferenceType{get;set;}
    }
    public class APIStatus{
        public list<PepperReferences> PepperReferences{get;set;}
        public list<ClientReferences> ClientReferences{get;set;}
        public String APIDescription{get;set;}
        public list<Messages> Messages{get;set;}
        public String APICode{get;set;}
        public String APIResponse{get;set;}
        
    }
    public static ScCollection_MeetingNotesResponseSuccess parse(String json)
    {
        return (ScCollection_MeetingNotesResponseSuccess) System.JSON.deserialize(json, ScCollection_MeetingNotesResponseSuccess.class);
    } 
}