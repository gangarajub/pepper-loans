<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Last_Data_Push_Date_Time</fullName>
        <field>CRM_Mtg_Data_Push_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Last Data Push Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>CRM_Mtg_Send_BDM_Data</fullName>
        <apiVersion>39.0</apiVersion>
        <description>This outbound mesage is used to send mortgage bdm data to ESB to be further populated in Nextgen, Pepper Online and Jackson.</description>
        <endpointUrl>https://sfarmwebprod.pepper.com.au/UserNotificationService.svc</endpointUrl>
        <fields>CRM_Mtg_Unique_Id_Formula__c</fields>
        <fields>CRM_Mtg_User_Active_Formula__c</fields>
        <fields>Email</fields>
        <fields>FirstName</fields>
        <fields>Id</fields>
        <fields>LastName</fields>
        <fields>MiddleName</fields>
        <fields>State</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>armintegrationuser@pepper.com.au</integrationUser>
        <name>CRM_Mtg_Send BDM Data</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CRM_Mtg_Update Mortgage BDM Details in External System</fullName>
        <actions>
            <name>Set_Last_Data_Push_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CRM_Mtg_Send_BDM_Data</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(CRM_Mtg_Unique_Id_Formula__c)), NOT(ISBLANK(FirstName)), NOT(ISBLANK(LastName)), NOT(ISBLANK(Email)), CRM_Mtg_Is_Mortgage_BDM__c, OR(IsActive = true, PRIORVALUE(IsActive) = true), OR(ISNEW(),  ISCHANGED(CRM_Mtg_Unique_Id__c),   ISCHANGED(FirstName), ISCHANGED(MiddleName), ISCHANGED(LastName), ISCHANGED(IsActive),  ISCHANGED(Email),  ISCHANGED(State), ISCHANGED(CRM_Mtg_Is_Mortgage_BDM__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
