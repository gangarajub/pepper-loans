// This batch class is used for Chatternotifications
// --------------------------------------------------------------------------------------------- 
// Version#     Date              Author                 Description
// ---------------------------------------------------------------------------------------------
// 1.0       3-June-2016      Sumit Banarji           Initial Version
// ---------------------------------------------------------------------------------------------
public class ChatterNotification 
{
	/**
	* @Method used to insert chatter feed and send email to group members
	* @param dbType 
	*/
	public static void SendNotification(DashBoardType dbType)
	{
		if(dbType != null)
		{
			List<Mulesoft_Configuration__c> lstMulesoftConfig = Mulesoft_Configuration__c.getAll().values();
			if(lstMulesoftConfig != null && lstMulesoftConfig.size() > 0) if(lstMulesoftConfig[0].Chatter_Notification_Body__c != null && ((lstMulesoftConfig[0].PAF_User_Groups__c != null && dbType == DashBoardType.PAF) || (lstMulesoftConfig[0].Mortgage_User_Group__c != null && dbType == DashBoardType.Mortgage)))
			{
				List<String> lstUserGroup = dbType == DashBoardType.PAF ? lstMulesoftConfig[0].PAF_User_Groups__c.split('\n') : dbType == DashBoardType.Mortgage ? lstMulesoftConfig[0].Mortgage_User_Group__c.split('\n') : null;
				if(lstUserGroup != null && lstUserGroup.size() > 0)
				{
					set<Id> lstUserId = new  set<Id>();
					
					if((lstMulesoftConfig[0].NotificationTemplete_PAF__c != null && dbType == DashBoardType.PAF) || (lstMulesoftConfig[0].NotificationTemplete_Mortgage__c != null && dbType == DashBoardType.Mortgage))
					{
						List<Messaging.SingleEmailMessage> lstEmailsMessages = new List<Messaging.SingleEmailMessage>();
						For(CollaborationGroupMember objGrpMem : [SELECT Id, MemberId From CollaborationGroupMember where CollaborationGroupId in: lstUserGroup])
						{
							if(objGrpMem.MemberId != null)
							{ 
								Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
								mail.setTargetObjectId(objGrpMem.MemberId);
								mail.setTemplateId(dbType == DashBoardType.PAF ? lstMulesoftConfig[0].NotificationTemplete_PAF__c : lstMulesoftConfig[0].NotificationTemplete_Mortgage__c);
								mail.setSaveAsActivity(false);
								lstEmailsMessages.add(mail);
							}
						}
						if(lstEmailsMessages.size() > 0) Messaging.sendEmail(lstEmailsMessages);
					}
					
					for(string objstr : lstUserGroup) 
					{ 
						if(objstr != '' && !Test.isRunningTest())
						ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, objstr.trim(), ConnectApi.FeedElementType.FeedItem, dbType == DashBoardType.PAF ? lstMulesoftConfig[0].Chatter_Notification_Body__c : lstMulesoftConfig[0].Chatter_Notification_Body_Mortgage__c);
					}
				}
			}
		}
	}

	/**
	* @author Sumit Banarji
	* @description : Used as Enumrator
	*/
	public enum DashBoardType
	{
		PAF,
		Mortgage
	}
}