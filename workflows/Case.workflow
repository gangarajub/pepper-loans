<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approved</fullName>
        <description>Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CRM_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>CRM_Case_Assignment_Email_Send</fullName>
        <description>CRM Case Assignment Email Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All/CRM_Case_Assignment_Rule_Email</template>
    </alerts>
    <alerts>
        <fullName>CRM_Mtg_Case_Assignment_Email</fullName>
        <description>CRM_Mtg Case Assignment Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_Mortgage_Templates/CRM_Mtg_Case_Assignment_Email</template>
    </alerts>
    <alerts>
        <fullName>CRM_Mtg_Send_Quiz_Email_to_Broker_for_Accreditation_Process</fullName>
        <ccEmails>accreditations@pepper.com.au</ccEmails>
        <description>CRM_Mtg Send Quiz Email to Broker for Accreditation Process</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>accreditations@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CRM_Mortgage_User_Templates/CRM_Mtg_Quiz_Email_to_Brokers</template>
    </alerts>
    <alerts>
        <fullName>CRM_Notify_Case_owner_about_system_login</fullName>
        <description>CRM Notify Case owner about system login</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All/CRM_System_Login_Created</template>
    </alerts>
    <alerts>
        <fullName>CRM_Send_email_to_activate_user</fullName>
        <description>CRM Send email to activate user</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CRM_Contact_Activation_Template</template>
    </alerts>
    <alerts>
        <fullName>Delay_Email_Alert</fullName>
        <description>Delay Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>cstest@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/Delay_Template</template>
    </alerts>
    <alerts>
        <fullName>Email_To_customer_for_the_case_Closure</fullName>
        <description>Email To customer for the case Closure.</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>cstest@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/Case_Closure_COC</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_for_PAF_BDM_on_Case_closure</fullName>
        <description>Email notification for PAF BDM on Case closure</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_PAF_BDM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CRM_PAF_Case_Closure</template>
    </alerts>
    <alerts>
        <fullName>Notify_The_Case_Owner</fullName>
        <ccEmails>salesforcecoe@pepper.com</ccEmails>
        <description>Notify The Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SalesforceCOE/Vendor_Access_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Reject_notification</fullName>
        <description>Reject notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CRM_Reject_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Laure</fullName>
        <description>Send Email to Laure</description>
        <protected>false</protected>
        <recipients>
            <recipient>lmallez@pepper.com.au.crm</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All/CRM_Case_Assignment_Email_to_Sales_Support_queue</template>
    </alerts>
    <alerts>
        <fullName>pafss_Loan_Statement_Request_PAF</fullName>
        <description>pafss_Loan Statement Request</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>plservicing@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PAF_Self_Service_Templates/pafss_Loan_Statement_Request</template>
    </alerts>
    <alerts>
        <fullName>pafss_Payment_Detail_Change_Request</fullName>
        <description>pafss_Payment Detail Change Request</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>plservicing@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PAF_Self_Service_Templates/pafss_Payment_Detail_Change_Request</template>
    </alerts>
    <alerts>
        <fullName>pafss_Payout_Figure_Request</fullName>
        <description>pafss_Payout Figure Request</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>plservicing@pepper.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PAF_Self_Service_Templates/pafss_Payout_Figure_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>AssignedTounAllocatedQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>UnAllocated_Insurance</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AssignedTounAllocatedQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssignedTounAllocatedQueue1</fullName>
        <field>OwnerId</field>
        <lookupValue>UnAllocated_Insurance</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AssignedTounAllocatedQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Case_Status_Change</fullName>
        <field>Status</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>CRM Case Status Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Change_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>PAF_Accreditation_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CRM Change Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Status_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>CRM Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Status_Reject</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>CRM Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MakeReopenfalse</fullName>
        <field>Escalation_Reopen__c</field>
        <literalValue>0</literalValue>
        <name>MakeReopenfalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_date</fullName>
        <field>pepDueDate__c</field>
        <formula>IF(
(text(Type) = &quot;Default Listing - Veda&quot; )|| 
(text(Type) = &quot;Hardship&quot;) ||
(text(Type) = &quot;Legal Action - Default Notice&quot;) ||
(text(Type) = &quot;Legal Action - Default Notice&quot;),  Datevalue(CreatedDate) + 21,

IF(
(text(Type) = &quot;Privacy&quot; ),
Datevalue(CreatedDate) + 30,
IF(text(Type) = &quot;FSCL Complaint&quot;,
Datevalue(CreatedDate) + 10,Datevalue(CreatedDate) + 40)
))</formula>
        <name>Update Due date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CRM Case Assignment rule</fullName>
        <actions>
            <name>CRM_Case_Assignment_Email_Send</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CRM_Change_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>On Boarding,Off Boarding</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CRM On Status Setup In Progress</fullName>
        <actions>
            <name>Send_Email_to_Laure</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Setup in Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>On Boarding</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CRM PAF Case Assignment Notification</fullName>
        <actions>
            <name>CRM_Send_email_to_activate_user</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Activation</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CaseClosureEmail</fullName>
        <actions>
            <name>Email_To_customer_for_the_case_Closure</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Building Insurance Expiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CaseReopen</fullName>
        <actions>
            <name>AssignedTounAllocatedQueue1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(AND(ISPICKVAL(PRIORVALUE(Status),&quot;Closed&quot;),ISPICKVAL(Status,&quot;Open&quot;),RecordType.DeveloperName==&apos;Building_Insurance_Expiry&apos;),true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check if system login is created</fullName>
        <actions>
            <name>CRM_Notify_Case_owner_about_system_login</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>On Boarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CRM_System_logins_created__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Delaymail</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Building Insurance Expiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Delay_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MakeReopenFalse</fullName>
        <actions>
            <name>MakeReopenfalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Enforcement</value>
        </criteriaItems>
        <description>This worjkflow will make the enforcement related cases to have escalation Reopen checkbox as false upon closure.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Due date</fullName>
        <actions>
            <name>Update_Due_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateOpen status</fullName>
        <actions>
            <name>Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Building Insurance Expiry</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>User Deactivation Case Closure</fullName>
        <actions>
            <name>Email_notification_for_PAF_BDM_on_Case_closure</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>User Activation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Vendor Access Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Salesforce COE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RootCauseCategory__c</field>
            <operation>equals</operation>
            <value>User Access</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting On 3rd Party</value>
        </criteriaItems>
        <description>Sends a reminder to the Case Owner, 24 hours after the Case is saved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_The_Case_Owner</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>pafss_Loan Statement Request</fullName>
        <actions>
            <name>pafss_Loan_Statement_Request_PAF</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Loan Statement Request – PAF</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>pafss_Payment Detail Change Request</fullName>
        <actions>
            <name>pafss_Payment_Detail_Change_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Payment Detail Change Request – PAF</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>pafss_Payout Figure Request</fullName>
        <actions>
            <name>pafss_Payout_Figure_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Payout Figure Request - PAF</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
