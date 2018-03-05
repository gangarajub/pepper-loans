/**
* @author Salesforce.org
* @group Utilities
* @description Controller for SLDS styled page messages component
*/
public class SCV_PageMessagesController {


    private static final String PAGEMESSAGES_CONFIRM = 'Success';
    private static final String PAGEMESSAGES_ERROR = 'Error';
    private static final String PAGEMESSAGES_FATAL = 'Fatal';
    private static final String PAGEMESSAGES_WARNING = 'Warning';


    /**
     * @description Get the current context's page messages in the form of a
     * container class that can be used within Visualforce
     *
     * @return List<Message>
     */
    public List<Message> getPageMessages() {
        List<Message> pageMessages = new List<Message>();

        for (ApexPages.Message m : ApexPages.getMessages()) {
            pageMessages.add(new Message(m));
        }

        return pageMessages;
    }

    /**
     * @author Salesforce.org
     * @group Utilities
     * @description A container class that maps fields from ApexPages.Message.
     * This allows this data to be accessed within a Visualforce page.
     */
    public class Message {
        public MessageSeverity severity {get; set;}
        public String summary {get; set;}
        public String detail {get; set;}
        public String componentLabel {get; set;}

        /**
         * @description Construct a Message data container object from a given
         * ApexPages.Message object.  This will extract out the data from the
         * ApexPages.Message object and store it in the new Message object
         * isntance.
         *
         * @param m The ApexPages.Message object to extract data from
         */
        public Message(ApexPages.Message m) {
            this.summary = m.getSummary();
            this.detail = m.getDetail();
            this.componentLabel = m.getComponentLabel();

            ApexPages.Severity s = m.getSeverity();

            if (ApexPages.Severity.CONFIRM == s) {
                this.severity = MessageSeverity.CONFIRM;
            } else if (ApexPages.Severity.ERROR == s) {
                this.severity = MessageSeverity.ERROR;
            } else if (ApexPages.Severity.FATAL == s) {
                this.severity = MessageSeverity.FATAL;
            } else if (ApexPages.Severity.INFO == s) {
                this.severity = MessageSeverity.INFO;
            } else if (ApexPages.Severity.WARNING == s) {
                this.severity = MessageSeverity.WARNING;
            }
        }

        /**
         * @description A helper method for use in Visualforce pages that
         * translates MessageSeverity enums into SLDS theme names.
         *
         * @return string
         */
        public String getSeverityTheme() {
            if (MessageSeverity.CONFIRM == severity) {
                return 'success';
            } else if (MessageSeverity.ERROR == severity) {
                return 'error';
            } else if (MessageSeverity.FATAL == severity) {
                return 'error';
            } else if (MessageSeverity.INFO == severity) {
                return 'info';
            } else if (MessageSeverity.WARNING == severity) {
                return 'warning';
            } else {
                return 'info';
            }
        }

        /**
         * @description A helper method for use in Visualforce pages that
         * translates MessageSeverity enums into localized text labels
         *
         * @return string
         */
        public String getSeverityLabel() {
            if (MessageSeverity.CONFIRM == severity) {
                return PAGEMESSAGES_CONFIRM;
            } else if (MessageSeverity.ERROR == severity) {
                return PAGEMESSAGES_ERROR;
            } else if (MessageSeverity.FATAL == severity) {
                return PAGEMESSAGES_FATAL;
            } else if (MessageSeverity.INFO == severity) {
                return '';
            } else if (MessageSeverity.WARNING == severity) {
                return PAGEMESSAGES_WARNING;
            } else {
                return '';
            }
        }
    }

    /**
     * @author Salesforce.org
     * @description A native Apex enum representing values that correspond to
     * the ApexPages.MessageSeverity enum.
     */
    public enum MessageSeverity {
        CONFIRM,
        ERROR,
        FATAL,
        INFO,
        WARNING
    }
}