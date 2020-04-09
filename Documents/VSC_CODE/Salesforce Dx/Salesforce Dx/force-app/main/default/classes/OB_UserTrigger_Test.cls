/*******************************************************************************
Purpose:    Test class for OB_UserTrigger

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Wojciech Szuba          04/10/2019      Refactored      NEXI-107
********************************************************************************/
@isTest
private class OB_UserTrigger_Test
{
	/*******************************************************************************
	Purpose:    Test method for User Trigger, insert

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         ?                       ?               Created         ?
	1.1         Wojciech Szuba          04/10/2019      Refactored      NEXI-107
	********************************************************************************/
	@isTest
	private static void userTriggerInsertTest( )
	{
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
		triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableUserTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        
		Account testAccount = OB_TestDataFactory.getAccount( );
		insert testAccount;

		Contact testContact = OB_TestDataFactory.getContact( testAccount );
		insert testContact;

		User testUser = OB_TestDataFactory.getUser( );
		testUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
		testUser.ContactId = testContact.Id;

		Test.startTest( );
		Database.SaveResult testResult = Database.insert( testUser, false );
		Test.stopTest( );

		System.assert( testResult.isSuccess( ) );
	}
}