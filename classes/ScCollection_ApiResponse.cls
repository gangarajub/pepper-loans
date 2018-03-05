global class ScCollection_ApiResponse{
        public APIStatus APIStatus{get;set;}
    global class Messages{
        public String MessageDescription{get;set;}
    }
    global class APIStatus{
        public Messages[] Messages{get;set;}
        public String Description{get;set;}
        public String Status{get;set;}
    }
}