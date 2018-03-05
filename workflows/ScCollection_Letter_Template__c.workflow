<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ScCollection_Update_Letter_Template_Name</fullName>
        <field>Name</field>
        <formula>TEXT(ScCollection_Letter_Type__c) &amp; IF(TEXT(ScCollection_Letter_Sub_Type__c) != &apos;&apos;, &apos; - &apos; &amp;  TEXT(ScCollection_Letter_Sub_Type__c), &apos;&apos;)</formula>
        <name>Update Letter Template Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ScCollection_Update_Unique_Name</fullName>
        <field>Letter_Unique_Name__c</field>
        <formula>TEXT(ScCollection_Letter_Type__c) &amp; IF(TEXT(ScCollection_Letter_Sub_Type__c) != &apos;&apos;, &apos;-&apos; &amp; TEXT(ScCollection_Letter_Sub_Type__c), &apos;&apos;) &amp; &apos;-&apos; &amp;  ScCollection_Source_System__r.Name</formula>
        <name>Update Unique Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Letter Template Name</fullName>
        <actions>
            <name>ScCollection_Update_Letter_Template_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ScCollection_Update_Unique_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ScCollection_Letter_Template__c.ScCollection_Is_Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
