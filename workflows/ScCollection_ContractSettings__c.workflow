<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Contract_To_User</fullName>
        <field>ScCollection_ContracttoUser__c</field>
        <formula>IF( ScCollection_DevContract__c != NULL,  CASESAFEID(ScCollection_DevContract__c)+&apos;-&apos;+ CASESAFEID( ScCollection_UserLookup__c),IF( ScCollection_CLContract__c != NULL,CASESAFEID(ScCollection_CLContract__c )+&apos;-&apos;+ CASESAFEID( ScCollection_UserLookup__c),&apos;User/Contract not Available&apos; ))</formula>
        <name>Update Contract To User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update concatenated value of Contract and User Id</fullName>
        <actions>
            <name>Update_Contract_To_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ScCollection_ContractSettings__c.ScCollection_UserLookup__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow is Used to concatenate the Contract ID and User Id on the contract Setting</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
