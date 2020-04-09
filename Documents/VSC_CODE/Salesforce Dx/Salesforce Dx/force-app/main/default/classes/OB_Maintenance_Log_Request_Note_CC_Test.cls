@isTest
public with sharing class OB_Maintenance_Log_Request_Note_CC_Test
{
	//START - salvatore.pianura 27/03/2019 - R1F2_GDCR_001 - Test methods of OB_Maintenance_Log_Request_Note_CC
	@isTest
	public static void retrieveLogRequestTest() 
	{
		OB_LogRequest__c logReq = new OB_LogRequest__c();
		insert logReq;
		Id logReqId = logReq.Id;

		Test.startTest(); 
		OB_Maintenance_Log_Request_Note_CC.retrieveLogRequest(logReqId);
		Test.stopTest();
	}

	@isTest 
	public static void checkProfileTest1() 
	{
		Test.startTest(); 
		OB_Maintenance_Log_Request_Note_CC.checkProfile(); 
		Test.stopTest();
	}

	// @isTest
	// public static void checkProfileTest2()
	// {
	// 	Contact cont = new Contact(LastName = 'Test');
	// 	insert cont;

	// 	Profile parterUserProfile 	= new Profile();
	// 	List<Profile> listOfProfile = [	SELECT 	Id
	// 									FROM	Profile
	// 									WHERE	Name = 'Nexi Partner User'
	// 									LIMIT 	1];

	// 	if(!listOfProfile.isEmpty())
	// 	{
	// 		parterUserProfile 	= listOfProfile.get(0);
	// 		if(parterUserProfile!=null)
	// 		{
	// 			UserRole portalRole = [	SELECT 	Id
	// 									FROM 	UserRole
	// 									WHERE 	PortalType = 'None'
	// 									LIMIT 	1];

	// 			User operation 	= new User(	alias 				= 'ops'					,
	// 										email				= 'operation@test.com'	,
	// 										emailencodingkey	= 'UTF-8'				,
	// 										lastname			= 'Test'				,
	// 										languagelocalekey	= 'en_US'				,
	// 										localesidkey		= 'en_US'				,
	// 										profileid 			= parterUserProfile.Id	,
	// 										timezonesidkey		= 'America/Los_Angeles'	,
	// 										username			= 'operation@test.com' 	,
	// 										ContactId			= cont.Id				,
	// 										OB_CAB__c			= '12345'				,
	// 										UserRoleId       	= portalRole.id);
	// 			insert operation;

	// 			Test.startTest();
	// 			System.runas(operation)
	// 			{
	// 				OB_Maintenance_Log_Request_Note_CC.checkProfile();
	// 			}
	// 			Test.stopTest();
	// 		}
	// 	}
	// }


	@isTest
	public static void saveNotesTest()
	{
		OB_LogRequest__c logReq = new OB_LogRequest__c();
		insert logReq;

		Id logRequestId = logReq.Id;
		String notes  = 'Test';

		Test.startTest();
		OB_Maintenance_Log_Request_Note_CC.saveNotes(logRequestId,notes);
		Test.stopTest();
	}
	//END - salvatore.pianura 27/03/2019 - R1F2_GDCR_001 - Test methods of OB_Maintenance_Log_Request_Note_CC

	/*******************************************************************************
       Purpose:  Method tests OB_Maintenance_Log_Request_Note_CC.checkProfileOnLogRequest
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0      Michał Targiel           18/06/2019        Created             ---
       ********************************************************************************/
/*
	@isTest
	public static void checkProfileOnLogRequest1()
	{
		Map<String,Object> expected = new Map<String,Object>();
		Map<String,Object> actual;
		Test.startTest();
		actual = OB_Maintenance_Log_Request_Note_CC.checkProfileOnLogRequest('1');
		Test.stopTest();
		System.assertEquals(expected, actual);
	}


	/*******************************************************************************
       Purpose:  Method tests OB_Maintenance_Log_Request_Note_CC.checkProfileOnLogRequest
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0      Michał Targiel           18/06/2019        Created             ---
	********************************************************************************/
/*
	@isTest
	public static void checkProfileOnLogRequest()
	{
		Profile p = [SELECT Id
		FROM Profile
		WHERE Name='Standard User'];

		User u = OB_TestDataFactory.getUser();
		u.ProfileId = p.Id;

		OB_LogRequestFieldsVisibility__mdt ob_logRequestFieldsVisibility = new OB_LogRequestFieldsVisibility__mdt();
		ob_logRequestFieldsVisibility.OB_Profiles__c = u.Profile.Name;
		ob_logRequestFieldsVisibility.OB_NotSameProfileOwner__c = true;

		Map<String,Object> expected = new Map<String,Object>();
		Map<String,Object> actual;
		System.runAs(u) {
			Test.startTest();
			actual = OB_Maintenance_Log_Request_Note_CC.checkProfileOnLogRequest(u.Id);
			Test.stopTest();
		}
		System.assertEquals(expected, actual);
	}
*/
}