@isTest
public class OB_UserTriggerHandler_Test
{ 
	//START - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Set constants with Account Record Types
	public static final Id BANKRT 	= Schema.SObjectType.Account.getRecordTypeInfosByName().get(OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId();
	public static final Id MERCHRT  = Schema.SObjectType.Account.getRecordTypeInfosByName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId();
	//END - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Set constants with Account Record Types

	@testSetup
	public static void setUp()
	{
		Account bank = new Account();
		bank.Name = 'bank';
		bank.NE__VAT__c = '12345678901';
		bank.OB_Employees_Number__c = 'Minore di 10';
		bank.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
		bank.OB_ABI__c = '05116';
		//START - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Set Account Record Type from constant
		bank.RecordTypeId = BANKRT;
		//END - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Set Account Record Type from constant
		insert bank;

		Account acc = new Account();
		acc.Name = 'acc';
		acc.NE__VAT__c = '12345678901';
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
		acc.OB_ABI__c = '05116';
		//START - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Set Account Record Type from constant
		acc.RecordTypeId = MERCHRT;
		//END - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Set Account Record Type from constant
		insert acc;

		Contact bankContact = new Contact();
		bankContact.LastName = 'bankContact';
		bankContact.AccountId = bank.id;
		insert bankContact;

		Contact con = new Contact();
		con.LastName = 'con';
		con.AccountId = acc.id;
		insert con;

		Group gp = new Group(Name = '05116 - Approvazione BIO', Type='Queue'); //R1F2_RP_004 21.03.2019 Z. Urban <z.urban@accenture.com> Change to available queue
		insert gp;

	}

	@isTest
	public static void addQUeueToPartnerCommunityUser_test1()
	{
		Map<Id, user> oldUserMap = new Map<Id, User>();
		Map<Id, user> newUserMap = new Map<Id, user>();

		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory
		User newPortalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
		insert newPortalAccountOwner;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		System.runAs(newPortalAccountOwner) {

			Account acc = [SELECT Id FROM Account WHERE Name = 'acc'];
			acc.ownerid = newPortalAccountOwner.id;
			update acc;


		}
		//16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Update test method
		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory=
		User user = OB_TestDataFactory.getUserL3();
		user.ContactId = [SELECT Id FROM Contact WHERE LastName = 'con' LIMIT 1].id;
		user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner Approver L3'].id;
		insert user;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		Id groupId = [SELECT Id FROM Group WHERE Type = 'Queue' and Name = '05116 - Approvazione BIO' LIMIT 1].Id; //R1F2_RP_004 21.03.2019 Z. Urban <z.urban@accenture.com> Change to available queue
		GroupMember member = new GroupMember(UserOrGroupId = user.id, GroupId = groupId);
		insert member;
		Test.startTest();
		newUserMap.put(user.Id, user);
		OB_UserTriggerHandler.addQueueToUser(oldUserMap, newUserMap, false);
		Test.stopTest();

	}

	@isTest
	public static void addQUeueToPartnerCommunityUser_test2()
	{
		Map<Id, user> oldUserMap = new Map<Id, User>();
		Map<Id, user> newUserMap = new Map<Id, user>();

		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory
		User newPortalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
		insert newPortalAccountOwner;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		System.runAs(newPortalAccountOwner) {

			Account bank = [SELECT Id FROM Account WHERE Name = 'bank'];
			bank.ownerid = newPortalAccountOwner.id;
			update bank;

		}

		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory
		User user = OB_TestDataFactory.getUser();
		user.ContactId = [SELECT Id FROM Contact WHERE LastName = 'bankContact' LIMIT 1].id;
		user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner Approver L1'].id;
		insert user;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		Test.startTest();
		newUserMap.put(user.Id, user);
		OB_UserTriggerHandler.addQueueToUser(oldUserMap, newUserMap, false);
		Test.stopTest();

	}


	/**
    * @author Z. Urban <z.urban@accenture.com>
    * @date 21/03/2019
    * @description R1F2_RP_004 Test to add Nexi Partner Approver L2 profile user to queue
    */
	@isTest
	public static void addQUeueToPartnerCommunityUser_test3()
	{
		Map<Id, user> oldUserMap = new Map<Id, User>();
		Map<Id, user> newUserMap = new Map<Id, user>();

		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory
		User newPortalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
		insert newPortalAccountOwner;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		System.runAs(newPortalAccountOwner) {

			Account bank = [SELECT Id FROM Account WHERE Name = 'bank'];
			bank.ownerid = newPortalAccountOwner.id;
			update bank;

		}

		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory
		User user = OB_TestDataFactory.getUser();
		user.ContactId = [SELECT Id FROM Contact WHERE LastName = 'bankContact' LIMIT 1].id;
		user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner Approver L2'].id;
		insert user;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		Test.startTest();
		newUserMap.put(user.Id, user);
		OB_UserTriggerHandler.addQueueToUser(oldUserMap, newUserMap, false);
		Test.stopTest();

	}

	/**
    * @author Z. Urban <z.urban@accenture.com>
    * @date 21/03/2019
    * @description R1F2_RP_004 Test to add Nexi Partner Approver L1 profile user to queue
    */
	@isTest
	public static void addQUeueToPartnerCommunityUser_test4()
	{
		Map<Id, user> oldUserMap = new Map<Id, User>();
		Map<Id, user> newUserMap = new Map<Id, user>();

		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory
		User newPortalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
		insert newPortalAccountOwner;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		System.runAs(newPortalAccountOwner) {

			Account acc = [SELECT Id FROM Account WHERE Name = 'acc'];
			acc.ownerid = newPortalAccountOwner.id;
			update acc;

		}

		//START, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory
		User user = OB_TestDataFactory.getUser();
		user.ContactId = [SELECT Id FROM Contact WHERE LastName = 'con' LIMIT 1].id;
		user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner Approver L1'].id;
		insert user;
		//STOP, R1F2_RP_004 22.03.2019 Z. Urban <z.urban@accenture.com> Use data factory

		Id groupId = [SELECT Id FROM Group WHERE Type = 'Queue' and Name = '05116 - Approvazione Pricing'].Id;
		GroupMember member = new GroupMember(UserOrGroupId = user.id, GroupId = groupId);
		insert member;
		Test.startTest();
		newUserMap.put(user.Id, user);
		OB_UserTriggerHandler.addQueueToUser(oldUserMap, newUserMap, false);
		Test.stopTest();

	}

    /*******************************************************************************
    Purpose:  Test to update a user and to add this into related queue
    Parameters: -
    Returns: Void
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Salvatore Pianura     16/04/2019        Created         /FixOnUserTrigger
    ********************************************************************************/
	@isTest
	public static void addQUeueToPartnerCommunityUser_test5()
	{
		Map<Id, user> oldUserMap = new Map<Id, User>();
		Map<Id, user> newUserMap = new Map<Id, user>();
		User newPortalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
		insert newPortalAccountOwner;
		System.runAs(newPortalAccountOwner)
		{
			Account acc = [SELECT Id FROM Account WHERE Name = 'acc'];
			acc.OwnerId = newPortalAccountOwner.id;
			update acc;
		}
		User user = OB_TestDataFactory.getUser();
		user.ContactId = [SELECT Id FROM Contact WHERE LastName = 'con' LIMIT 1].id;
		user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner Approver L1'].id;
		insert user;

		Id groupId = [SELECT Id FROM Group WHERE Type = 'Queue' and Name = '05116 - Approvazione Pricing'].Id;
		GroupMember member = new GroupMember(UserOrGroupId = user.id, GroupId = groupId);
		insert member;

		Id profileIdToUpdate = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner Approver L2'].id;
		user.ProfileId = profileIdToUpdate;
		update user;
		
		Test.startTest();
		newUserMap.put(user.Id, user);
		OB_UserTriggerHandler.addQueueToUser(oldUserMap, newUserMap, false);
		Test.stopTest();

	}

}