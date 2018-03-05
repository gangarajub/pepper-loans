<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Loan_Portal_User_Creation_Complete</fullName>
        <description>Loan Portal User Creation Complete</description>
        <protected>false</protected>
        <recipients>
            <field>pepOTP_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>plservicing@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PAF_Self_Service_Templates/Loan_Portal_Setup_Complete</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_for_1st_OTP</fullName>
        <description>Send Email for 1st OTP</description>
        <protected>false</protected>
        <recipients>
            <field>pepOTP_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/Your_Pepper_Money_Verification_Code</template>
    </alerts>
    <alerts>
        <fullName>Send_Secure_Loans_Checklist_Email</fullName>
        <description>Send Secure Loans Checklist Email</description>
        <protected>false</protected>
        <recipients>
            <field>pepOTP_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Secure_Loans_Templates/Secured_Personal_Loan_Checklist_email</template>
    </alerts>
    <alerts>
        <fullName>pafss_Send_Otp_Email</fullName>
        <description>Send Otp Email</description>
        <protected>false</protected>
        <recipients>
            <field>pepOTP_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>plservicing@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PAF_Self_Service_Templates/pafss_Send_OTP_Email</template>
    </alerts>
    <alerts>
        <fullName>pafss_Send_Otp_Emaill</fullName>
        <description>Send Otp Email</description>
        <protected>false</protected>
        <recipients>
            <field>pepOTP_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>plservicing@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PAF_Self_Service_Templates/pafss_Send_OTP_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Last_Data_Push_Date_Time</fullName>
        <field>CRM_Mtg_Data_Push_Date_Time__pc</field>
        <formula>NOW()</formula>
        <name>Set Last Data Push Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Data_Push_Date_Time_Acct</fullName>
        <field>CRM_Mtg_Data_Push_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Last Data Push Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Send_Asset_List_Field</fullName>
        <field>Send_Asset_list__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Send Asset List Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Birthdate_Timestamp</fullName>
        <field>SCV_Person_Birthdate_Timestamp__c</field>
        <formula>TEXT(PersonBirthdate)</formula>
        <name>Update Birthdate Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Duplication_Key_Field</fullName>
        <field>pafss_Duplication_Check_Key__c</field>
        <formula>LOWER(TRIM(FirstName)) + &apos;:&apos; + LOWER(TRIM(LastName)) + &apos;:&apos; + TRIM(PersonMobilePhone) + &apos;:&apos; + LOWER(TRIM(PersonEmail)) + &apos;:&apos; + TRIM(TEXT(PersonBirthdate))</formula>
        <name>Update Duplication Key Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Push_Date</fullName>
        <description>Test (2nd Field)</description>
        <field>CRM_Mtg_Data_Push_Date_Time__pc</field>
        <formula>NOW()</formula>
        <name>Update Last Push Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Non_Duplication_Key_Field</fullName>
        <field>pafss_Non_Duplication_Check_Key__c</field>
        <formula>LOWER(TRIM(FirstName)) + &apos;:&apos; + LOWER(TRIM(LastName)) + &apos;:&apos; + TRIM(PersonMobilePhone) + &apos;:&apos; + LOWER(TRIM(PersonEmail))</formula>
        <name>Update Non Duplication Key Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_OTP_Email</fullName>
        <field>pepOTP_Email__c</field>
        <formula>PersonEmail</formula>
        <name>Update OTP Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Push_Date</fullName>
        <field>CRM_Mtg_Data_Push_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Push Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>pafss_Update_Portal_User_CreatedDateTime</fullName>
        <field>pafss_Portal_User_Created_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Portal User Created Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>CRM_Mtg_Send_Aggregator_Data</fullName>
        <apiVersion>39.0</apiVersion>
        <description>This outbound mesage is used to send mortgage aggregators data to ESB to be further populated in Nextgen, Pepper Online and Jackson.</description>
        <endpointUrl>https://sfarmwebprod.pepper.com.au/AccountNotificationService.svc</endpointUrl>
        <fields>BillingCity</fields>
        <fields>BillingPostalCode</fields>
        <fields>BillingState</fields>
        <fields>BillingStreet</fields>
        <fields>CRM_ABN__c</fields>
        <fields>CRM_Mtg_Accreditation_Status_Formula__c</fields>
        <fields>CRM_Mtg_Email__c</fields>
        <fields>CRM_Mtg_Mortgage_Manager__c</fields>
        <fields>CRM_Mtg_Nextgen_Role_Code__c</fields>
        <fields>CRM_Mtg_PI_Expiry_Date__c</fields>
        <fields>CRM_Mtg_Unique_Id_Formula__c</fields>
        <fields>CRM_Trading_Name__c</fields>
        <fields>Fax</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>Phone</fields>
        <fields>ShippingCity</fields>
        <fields>ShippingPostalCode</fields>
        <fields>ShippingState</fields>
        <fields>ShippingStreet</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>armintegrationuser@pepper.com.au</integrationUser>
        <name>CRM_Mtg_Send Aggregator Data</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>RCTI</fullName>
        <apiVersion>38.0</apiVersion>
        <endpointUrl>https://apps.drawloop.com/package/111</endpointUrl>
        <fields>Drawloop_Next__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>sfcoe@pepper.com.au</integrationUser>
        <name>RCTI</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CRM_Mtg_Update Mortgage Aggregator Details in External System</fullName>
        <actions>
            <name>Set_Last_Data_Push_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Last_Data_Push_Date_Time_Acct</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CRM_Mtg_Send_Aggregator_Data</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(CRM_Mtg_Unique_Id_Formula__c)), NOT(ISBLANK(CRM_Mtg_Accreditation_Status_Formula__c)), NOT(ISBLANK(CRM_Mtg_Mortgage_Manager__c)), OR(ISNEW(), ISCHANGED(CRM_Mtg_Unique_Id__c), ISCHANGED(Name), ISCHANGED(CRM_Mtg_Channel__c), ISCHANGED(CRM_Mtg_Email__c), ISCHANGED(Phone), ISCHANGED(Fax), ISCHANGED(CRM_Trading_Name__c), ISCHANGED(CRM_ABN__c), ISCHANGED(ShippingStreet), ISCHANGED(ShippingCity), ISCHANGED(ShippingState), ISCHANGED(ShippingPostalCode), ISCHANGED(BillingStreet), ISCHANGED(BillingCity), ISCHANGED(BillingState), ISCHANGED(BillingPostalCode), ISCHANGED(CRM_Mtg_Accreditation_Status__c), ISCHANGED(CRM_Mtg_Nextgen_Role_Code__c), ISCHANGED(CRM_Mtg_PI_Expiry_Date__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Gen RCTI</fullName>
        <actions>
            <name>RCTI</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>Latest_RCTI_Sent_On__c = $User.loan__Current_Branch_s_System_Date__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Personal Details Submit OTP</fullName>
        <actions>
            <name>Send_Email_for_1st_OTP</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SMS_Notification_VL</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(OTP__c )),ISCHANGED(OTP__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SCV Populate Person Birthdate Timestamp</fullName>
        <actions>
            <name>Update_Birthdate_Timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.PersonBirthdate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SCV - Copy PersonBirthdate value to Text field in order to use Duplicate matching rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Secure Loan Checklist Email</fullName>
        <actions>
            <name>Send_Secure_Loans_Checklist_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Uncheck_Send_Asset_List_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Send_Asset_list__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Setup Loan Portal Complete</fullName>
        <actions>
            <name>Loan_Portal_User_Creation_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow is created for sending setup completion email on successful portal user creation.</description>
        <formula>AND(  NOT(ISBLANK(CommunityUser__pc)),  NOT(ISBLANK(collect__External_ID__c)),  CONTAINS(collect__External_ID__c , &apos;PAF&apos;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Duplication Check Key</fullName>
        <actions>
            <name>Update_Duplication_Key_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(IsPersonAccount = true,  FirstName != null, LastName  != null ,PersonMobilePhone != null ,  PersonEmail != null, NOT  (ISBLANK(PersonBirthdate)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Non Duplication Check Key</fullName>
        <actions>
            <name>Update_Non_Duplication_Key_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(IsPersonAccount = true,  FirstName != null, LastName  != null ,  PersonMobilePhone != null ,  PersonEmail != null )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update OTP Email</fullName>
        <actions>
            <name>Update_OTP_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(),ISCHANGED(PersonEmail))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Portal User Created Date Time</fullName>
        <actions>
            <name>pafss_Update_Portal_User_CreatedDateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(IsPersonAccount, Is_Portal_User_Created__c, ISCHANGED(Is_Portal_User_Created__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Verify Login OTP</fullName>
        <actions>
            <name>pafss_Send_Otp_Emaill</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SMS_Notification</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(Second_OTP__c)),ISCHANGED(Second_OTP__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>SMS_Notification</fullName>
        <assignedTo>sfcoe@pepper.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>SMS-Notification-Account-f5f8</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>SMS Notification</subject>
    </tasks>
    <tasks>
        <fullName>SMS_Notification_VL</fullName>
        <assignedTo>sfcoe@pepper.com.au</assignedTo>
        <assignedToType>user</assignedToType>
        <description>SMS-Notification-Account-2c04</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>SMS Notification</subject>
    </tasks>
</Workflow>
