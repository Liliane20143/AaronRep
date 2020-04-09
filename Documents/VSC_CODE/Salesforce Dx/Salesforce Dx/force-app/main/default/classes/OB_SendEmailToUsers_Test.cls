@isTest
public class OB_SendEmailToUsers_Test
{
	@isTest
	public static void execute_Test()
	{
		UserRole portalRole = [SELECT Id FROM UserRole Where PortalType = 'None' Limit 1];
    	Profile pAdmin      = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	
    	User user1 = new User();
    	user1.ProfileId        = pAdmin.id;
    	user1.Username         ='newPortalAccountOwner1@test.com';
    	user1.Alias            = 'alias';
    	user1.Email            ='portalAccountOwner@test.com';
    	user1.EmailEncodingKey ='UTF-8';
    	user1.Firstname        ='firstName';
    	user1.Lastname         ='lastName';
    	user1.LanguageLocaleKey='en_US';
    	user1.LocaleSidKey     ='en_US';
    	user1.TimeZoneSidKey   ='America/Chicago';
    	user1.UserRoleId       = portalRole.id;
	    insert user1;
		SchedulableContext sc;
        
		Test.startTest();

		System.runAs(user1) {
		
			OB_SendEmailToUsers.execute(sc);
            
		}
        //Integer invocations = Limits.getEmailInvocations();
		Test.stopTest();
	}

}