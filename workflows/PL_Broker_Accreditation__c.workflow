<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PL_Broker_Accreditation_Request</fullName>
        <description>PL Broker Accreditation Request</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>accreditations@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Broker_Communications/Personal_Loans_Accreditation_Request</template>
    </alerts>
</Workflow>
