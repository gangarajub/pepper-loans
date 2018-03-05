<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Unique_Monthly_Budget_Check</fullName>
        <field>Budget_Month_Year__c</field>
        <formula>TEXT(MONTH(Date__c))+&quot;/&quot;+TEXT(YEAR(Date__c))</formula>
        <name>Unique Monthly Budget Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique Monthly Budget</fullName>
        <actions>
            <name>Unique_Monthly_Budget_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Monthly_Budget__c.Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
