<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Broker_Email_Missing1</fullName>
        <description>Broker Email Missing</description>
        <protected>false</protected>
        <recipients>
            <recipient>mtelang@pepper.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Pepper/Broker_Email_Missing</template>
    </alerts>
    <alerts>
        <fullName>Broker_Mobile_Missing1</fullName>
        <description>Broker Mobile Missing</description>
        <protected>false</protected>
        <recipients>
            <recipient>mtelang@pepper.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Pepper/Broker_Mobile_Missing</template>
    </alerts>
    <alerts>
        <fullName>PL_Broker_Accreditation_Resend</fullName>
        <description>PL Broker Accreditation Resend</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>accreditations@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Broker_Communications/Personal_Loans_Accreditation_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Send_Broker_Accreditation_Email</fullName>
        <ccEmails>sjolly@pepper.com.au</ccEmails>
        <description>Send Broker Accreditation Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>accreditations@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Broker_Communications/Personal_Loans_Accreditation_Confirmation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Last_Data_Push_Date_Time</fullName>
        <field>CRM_Mtg_Data_Push_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Last Data Push Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Manual_Sync_Mortgages_False</fullName>
        <description>Sets Manual_Sync_Mortgages__c= false</description>
        <field>Manual_Sync_Mortgages__c</field>
        <literalValue>0</literalValue>
        <name>Set Manual Sync Mortgages False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>CRM_Mtg_Send_Broker_Data</fullName>
        <apiVersion>39.0</apiVersion>
        <description>This outbound mesage is used to send mortgage brokers data to ESB to be further populated in Nextgen, Pepper Online and Jackson.</description>
        <endpointUrl>https://sfarmwebprod.pepper.com.au/ContactNotificationService.svc</endpointUrl>
        <fields>CRM_Mtg_Accreditation_Status_Formula__c</fields>
        <fields>CRM_Mtg_Aggregator_ARM_Id__c</fields>
        <fields>CRM_Mtg_BDM_ARM_Id__c</fields>
        <fields>CRM_Mtg_Nextgen_Login__c</fields>
        <fields>CRM_Mtg_Unique_Id_Formula__c</fields>
        <fields>Email</fields>
        <fields>Fax</fields>
        <fields>FirstName</fields>
        <fields>Id</fields>
        <fields>LastName</fields>
        <fields>MailingCity</fields>
        <fields>MailingPostalCode</fields>
        <fields>MailingState</fields>
        <fields>MailingStreet</fields>
        <fields>MiddleName</fields>
        <fields>MobilePhone</fields>
        <fields>Phone</fields>
        <fields>Salutation</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>armintegrationuser@pepper.com.au</integrationUser>
        <name>CRM_Mtg_Send Broker Data</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CRM_Mtg_Update Mortgage Broker Details in External System</fullName>
        <actions>
            <name>Set_Last_Data_Push_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Manual_Sync_Mortgages_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CRM_Mtg_Send_Broker_Data</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(   NOT(ISBLANK(CRM_Mtg_Unique_Id_Formula__c)),     NOT(ISBLANK(CRM_Mtg_Accreditation_Status_Formula__c)),    NOT(ISBLANK(FirstName)), NOT(ISBLANK(LastName)),    NOT(ISBLANK(Email)),    NOT(ISBLANK(CRM_Mtg_Aggregator_ARM_Id__c)),    NOT(ISBLANK(CRM_Mtg_BDM_ARM_Id__c)),    NOT(ISBLANK(CRM_Mtg_Nextgen_Login__c)),    OR(     ISNEW(),       ISCHANGED(CRM_Mtg_Unique_Id__c),       ISCHANGED(Salutation),       ISCHANGED(FirstName),       ISCHANGED(MiddleName),       ISCHANGED(LastName),       ISCHANGED(Email),       ISCHANGED(CRM_Mtg_Accreditation_Status__c),       ISCHANGED(MobilePhone),       ISCHANGED(Phone),       ISCHANGED(Fax),       ISCHANGED(MailingStreet),      ISCHANGED(MailingCity),       ISCHANGED(MailingState),       ISCHANGED(MailingPostalCode),       ISCHANGED(CRM_Mtg_Aggregator_ARM_Id__c),       ISCHANGED(CRM_Mtg_BDM_ARM_Id__c),       ISCHANGED(CRM_Mtg_Nextgen_Login__c),     Manual_Sync_Mortgages__c = true   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send PL Accreditation Email</fullName>
        <actions>
            <name>Send_Broker_Accreditation_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends email to broker when their accreditation is created successfully.</description>
        <formula>AND(    
    ISPICKVAL(PL_Accreditation_Result__c, &quot;Success&quot;),      
    DATEVALUE(PL_Accreditation_Date_Time__c) =  TODAY(),    
        OR(ISCHANGED(PL_Accreditation_Result__c),
           ISNEW()
          )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
