@isTest
private class BT_PartnerUsersManagementTest {
	private static final String TEST_ACCOUNTNAME = 'petrucci';
	private static final String TEST_CONTACTLASTNAME = 'last';

	@testSetup
	static void setup() {
		Account a = BT_TestUtil.getAccount(TEST_ACCOUNTNAME, '1');
		insert a;
	}

	@isTest static void queryComposition() {
		String obj = BT_PartnerUsersManagement.ACC;
		String whereCondition = 'name != null';
		BT_PartnerUsersManagement b = new BT_PartnerUsersManagement(obj, whereCondition, false, null, null);
		BT_PartnerUsersManagement.mapFields = new Map<String, List<String>>{obj => new String[]{'id','name'}};
		
		Test.startTest();
		String query = b.queryComposition();
		Test.stopTest();

		System.assertNotEquals(null, query);
		System.assert(query.contains(obj));
		System.assert(query.contains('name'));
		System.assert(query.contains(whereCondition));
	}

	@isTest static void convertAccount() {
		Account a = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNTNAME];
		BT_PartnerUsersManagement b = new BT_PartnerUsersManagement(BT_PartnerUsersManagement.ACC, 'name = \''+TEST_ACCOUNTNAME+'\'', false, null, null);
		
		Test.startTest();
		Database.executeBatch(b, 1);
		Test.stopTest();

		a = [SELECT Id, IsPartner FROM Account WHERE Id = :a.Id];
		System.assert(a.IsPartner);
	}

	@isTest static void convertContact() {
		Account a = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNTNAME];
		a.IsPartner= true;
		update a;
		Profile p = [SELECT Id FROM Profile WHERE UserLicense.Name = 'partner community' LIMIT 1];
		BT_PartnerUsersManagement b = new BT_PartnerUsersManagement(BT_PartnerUsersManagement.CTC, 'lastname = \''+TEST_CONTACTLASTNAME+'\'', false, p.Id, null);
		Contact c = BT_TestUtil.getContact(a.Id, 'fir', TEST_CONTACTLASTNAME);
		Datetime dt =  Datetime.now();
		Integer ms = dt.millisecond();
		c.Email = 'mailmail'+ms+'@mailtest.com';
		insert c;

		Test.startTest();
		Database.executeBatch(b, 1);
		Test.stopTest();

		List<User> users = [SELECT Id, ContactId FROM User WHERE UserName = :c.email];
        System.debug('users: '+users);
		System.assert(!users.isEmpty());
		System.assertEquals(1, users.size());
		System.assertEquals(c.Id, users.get(0).ContactId);
	}

	@isTest static void generateAliasFromContact() {
		Account a = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNTNAME];
		Contact c = BT_TestUtil.getContact(a.Id, 'fir', TEST_CONTACTLASTNAME);

		Test.startTest();
		String alias = BT_PartnerUsersManagement.generateAliasFromContact(c);
		Test.stopTest();

		System.assertEquals('firlast', alias);
	}

}