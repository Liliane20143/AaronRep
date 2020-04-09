global class OB_SendEmailToUsers implements Schedulable 
{
	global static void execute(SchedulableContext sc) 
	{
		list<User> lstUser = [	SELECT Id 
								FROM User 
								WHERE isActive = true 
								AND (UserRole.DeveloperName =: Label.OB_OperationalAMLManager 
									OR UserRole.DeveloperName =: Label.OB_OperationalAML)
								AND  Profile.Name =: Label.OB_AMLProfileName ];

		List<OrgWideEmailAddress> owea = [	SELECT Id 
											FROM OrgWideEmailAddress 
											WHERE Address =: Label.OB_AMLOrgWideEmailAddress ];
		for(User iterator : lstUser) 
		{
			EmailTemplate objTemp = [	SELECT Id 
										FROM EmailTemplate 
										WHERE DeveloperName =: Label.OB_AMLEmailTemplate  
										LIMIT 1 ];
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			if ( owea.size() > 0 )
			{
				mail.setOrgWideEmailAddressId(owea.get(0).Id);
			}
			mail.setTemplateId(objTemp.Id);
			mail.setTargetObjectId(iterator.Id);
			mail.setSaveAsActivity(false);
			if(!Test.isRunningTest())
			{
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
		}
	}
}