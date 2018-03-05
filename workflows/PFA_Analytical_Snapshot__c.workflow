<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PAF_Update_Last_Modified_Date</fullName>
        <field>Last_Modified_Date__c</field>
        <formula>CreatedDate -1</formula>
        <name>PAF Update Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Last Modified Date</fullName>
        <actions>
            <name>PAF_Update_Last_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PFA_Analytical_Snapshot__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
