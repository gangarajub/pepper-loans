public class AutoContractGenerator {
    @InvocableMethod
    public static list<boolean> generate(List<Id> applicationIds) {
        String retMsg = '';
        genesis.ConvertApplicationCtrl ctrl = new genesis.ConvertApplicationCtrl();
        if(applicationIds.size()>0){
            retMsg = ctrl.convertApplication(applicationIds[0]);
        }
        
        List<boolean> retVal = new List<boolean>();
        retVal.add(true);
        return retVal;
            
        
    }
    
}