@isTest
public class FlowDebuggerTest
{
    public static testmethod void checkFLowDebugger()
    {
        List<String> listVar = new List<String>();
        String var = 'test,testVal';
        listVar.add(var);
        FlowDebugger.debugFlowVariables(listVar);
    }
}