global class FlowDebugger
{
    @InvocableMethod
    global static void debugFlowVariables(List<String> listVariables)
    {
        String var = listVariables[0];
        List<String> listVariableValues = var.split(',');
        for(integer i=0; i< listVariableValues.size();)
        {   
            system.debug('The value of variable : ' + listVariableValues[i] + ' is : '+listVariableValues [i+1] );
            i=i+2;
        }
    }
}