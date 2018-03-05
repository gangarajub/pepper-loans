<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_notification_for_Pack_Out_Stage</fullName>
        <description>Email notification for Pack Out Stage</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All/Pack_Out_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Settled_Email</fullName>
        <description>Settled Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All/Settlement_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>CRM_update_direct_rectype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Direct_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CRM update direct rectype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_update_paf_rectype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PAF</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CRM update paf rectype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_update_status</fullName>
        <field>StageName</field>
        <literalValue>Discovery</literalValue>
        <name>CRM update status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Application_Submitted</fullName>
        <field>StageName</field>
        <literalValue>Application Submitted</literalValue>
        <name>Update Application Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CRM Pack Out Email Notification</fullName>
        <actions>
            <name>Pack_Out_completed_Follow_up_with_Borrower</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pack Out</value>
        </criteriaItems>
        <description>Email to Opportunity owner after 48 hrs of stage updated to Pack out to follow up with Borrower</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_notification_for_Pack_Out_Stage</name>
                <type>Alert</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CRM Settlement Notification</fullName>
        <actions>
            <name>Settled_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Settlement Notification on stage</description>
        <formula>AND(ISPICKVAL( StageName , &quot;Settled&quot;),  RecordType.DeveloperName   =  &quot;Direct_Sales&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CRM Task for Order Evaluation</fullName>
        <actions>
            <name>Order_Evaluation</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Formal_Approved_Email</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>At stage Conditional Approved, task needs to be created for Support Queue</description>
        <formula>AND(ISPICKVAL( StageName , &quot;Conditionally Approved&quot;), RecordType.DeveloperName = &quot;Direct_Sales&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CRM Update Application Submitted</fullName>
        <actions>
            <name>Update_Application_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CRM_Application_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Stage to Application Submitted if Application ID has value</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CRM update direct recordtype on opp</fullName>
        <actions>
            <name>CRM_update_direct_rectype</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CRM_update_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CRM_Opportunity_RecordType__c</field>
            <operation>equals</operation>
            <value>Direct_Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator-CRM</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CRM update paf recordtype on opp</fullName>
        <actions>
            <name>CRM_update_paf_rectype</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CRM_Opportunity_RecordType__c</field>
            <operation>equals</operation>
            <value>PAF</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator-CRM</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CRM_Loan Docs Issued Email</fullName>
        <actions>
            <name>Loan_Docs_Issued_Follow_up_with_Borrower</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send Email Notification to Opportunity Owner for Loan Docs Issued stage</description>
        <formula>AND(ISPICKVAL( StageName , &quot;Loan Docs Issued&quot;), RecordType.DeveloperName = &quot;Direct_Sales&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Loan_Docs_Issued</name>
                <type>Task</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Task for Opportunity Owner</fullName>
        <actions>
            <name>New_Opportunity_Assigned</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Loan_Docs_Issued</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Loan Docs Issued</subject>
    </tasks>
    <tasks>
        <fullName>Loan_Docs_Issued_Follow_up_with_Borrower</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Loan Docs Issued- Follow up with Borrower</subject>
    </tasks>
    <tasks>
        <fullName>New_Opportunity_Assigned</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>New Opportunity Assigned</subject>
    </tasks>
    <tasks>
        <fullName>Order_Evaluation</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Order Evaluation</subject>
    </tasks>
    <tasks>
        <fullName>Pack_Out_completed_Follow_up_with_Borrower</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Pack Out completed- Follow up with Borrower</subject>
    </tasks>
    <tasks>
        <fullName>Send_Formal_Approved_Email</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Send Formal Approved Email</subject>
    </tasks>
</Workflow>
