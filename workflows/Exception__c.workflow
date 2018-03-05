<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_SFCOE</fullName>
        <ccEmails>alex.humby@gmail.com</ccEmails>
        <description>Notify SFCOE</description>
        <protected>false</protected>
        <senderAddress>salesforcecoe@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SalesforceCOE/SyncJobFailed</template>
    </alerts>
    <rules>
        <fullName>Collections Sync Job Failure</fullName>
        <actions>
            <name>Notify_SFCOE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>BEGINS( Integration_Type__c , &apos;ESB&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
