<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CRM_to_update_forecast_name</fullName>
        <field>Name</field>
        <formula>TEXT( CRM_Business_Unit__c ) + &quot;-&quot; +  CRM_Introducer__r.Name  + &quot;-&quot; + TEXT( CRM_Forecast_Year__c )</formula>
        <name>CRM to update forecast name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_update_total_target_volume</fullName>
        <field>CRM_Total_Target_Volume__c</field>
        <formula>IF(!ISBLANK(CRM_Target_January__c) , CRM_Target_January__c, 0) + 
IF(!ISBLANK(CRM_Target_February__c) , CRM_Target_February__c, 0) + 
IF(!ISBLANK(CRM_Target_March__c) , CRM_Target_March__c, 0) + 
IF(!ISBLANK(CRM_Target_April__c), CRM_Target_April__c, 0) + 
IF(!ISBLANK(CRM_Target_May__c) , CRM_Target_May__c, 0) + 
IF(!ISBLANK(CRM_Target_June__c) , CRM_Target_June__c, 0) + 
IF(!ISBLANK(CRM_Target_July__c) , CRM_Target_July__c, 0) + 
IF(!ISBLANK(CRM_Target_August__c) , CRM_Target_August__c, 0) + 
IF(!ISBLANK(CRM_Target_September__c) , CRM_Target_September__c, 0) + 
IF(!ISBLANK(CRM_Target_October__c) , CRM_Target_October__c, 0) + 
IF(!ISBLANK(CRM_Target_November__c) , CRM_Target_November__c, 0) + 
IF(!ISBLANK(CRM_Target_December__c) , CRM_Target_December__c, 0)</formula>
        <name>CRM update total target volume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Settled_Amount_field</fullName>
        <field>CRM_Total_Volume_Settled__c</field>
        <formula>IF(!ISBLANK(CRM_January__c) , CRM_January__c , 0) +
IF(!ISBLANK(CRM_February__c) , CRM_February__c , 0) +
IF(!ISBLANK(CRM_March__c) , CRM_March__c , 0) +
IF(!ISBLANK(CRM_April__c), CRM_April__c , 0) +
IF(!ISBLANK(CRM_May__c) , CRM_May__c , 0) +
IF(!ISBLANK(CRM_June__c) , CRM_June__c , 0) +
IF(!ISBLANK(CRM_July__c) , CRM_July__c , 0) +
IF(!ISBLANK(CRM_August__c) , CRM_August__c , 0) +
IF(!ISBLANK(CRM_September__c) , CRM_September__c , 0) +
IF(!ISBLANK(CRM_October__c) , CRM_October__c , 0) +
IF(!ISBLANK(CRM_November__c) , CRM_November__c , 0) +
IF(!ISBLANK(CRM_December__c) , CRM_December__c , 0)</formula>
        <name>Update Settled Amount field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateUniqueName</fullName>
        <field>CRM_Forecast_Name_Unique__c</field>
        <formula>TEXT( CRM_Business_Unit__c ) + &quot;-&quot; + CRM_Introducer__r.Name + &quot;-&quot; + TEXT( CRM_Forecast_Year__c )</formula>
        <name>updateUniqueName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CRM Update Total Settled Amount field</fullName>
        <actions>
            <name>CRM_to_update_forecast_name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CRM_update_total_target_volume</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Settled_Amount_field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>updateUniqueName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_Forecast__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
