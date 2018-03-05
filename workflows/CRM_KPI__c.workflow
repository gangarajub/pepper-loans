<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_KPI_Name</fullName>
        <description>Update KPI Name</description>
        <field>Name</field>
        <formula>CRM_User__r.FirstName + &apos; &apos; +CRM_User__r.MiddleName + &apos; &apos; + CRM_User__r.LastName + &apos; &apos; + TEXT(CRM_Year__c) + &apos; &apos; + &apos;Q&apos; + TEXT(CRM_Quarter__c)</formula>
        <name>Update KPI Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Unique_KPI_field</fullName>
        <field>CRM_Unique_KPI__c</field>
        <formula>CRM_User__r.FirstName + &apos; &apos; +CRM_User__r.MiddleName + &apos; &apos; + CRM_User__r.LastName + &apos; &apos; + TEXT(CRM_Year__c) + &apos; &apos; + &apos;Q&apos; + TEXT(CRM_Quarter__c) + &apos; &apos; +  RecordTypeId</formula>
        <name>Update Unique KPI field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update KPI Name</fullName>
        <actions>
            <name>Update_KPI_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_KPI__c.CRM_Quarter__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_KPI__c.CRM_Year__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_KPI__c.CRM_User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update KPI Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Unique KPI</fullName>
        <actions>
            <name>Update_Unique_KPI_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_KPI__c.CRM_User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_KPI__c.CRM_Quarter__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_KPI__c.RecordTypeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_KPI__c.CRM_Year__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Unique KPI field as Name + Year + Quarter + Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
