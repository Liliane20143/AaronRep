@isTest
private class BT_MailManagerTest
{
	@isTest static void getOfferPageAsAttachment() {
		Account a = BT_TestUtil.getAccount('name', '1');
		insert a;
		BT_Simulation__c s = BT_TestUtil.getSimulation(a.Id);
		insert s;

		Test.startTest();
		Messaging.EmailFileAttachment atch = BT_MailManager.getOfferPageAsAttachment(s.Id);
		Test.stopTest();

		System.assertNotEquals(null, atch.fileName);
		System.assertNotEquals(null, atch.body);
	}

	@isTest static void sendOfferVariationEmail() {
		Account a = BT_TestUtil.getAccount('name', '1');
		insert a;
		Contact c = BT_TestUtil.getContact(a.Id, 'Paolo', 'Oloap');
		insert c;
		BT_Simulation__c s = BT_TestUtil.getSimulation(a.Id);
		insert s;

		Test.startTest();
		BT_MailManager.Outcome result = BT_MailManager.sendOfferVariationEmail(s.Id, true, c.Id, true, false);
		Test.stopTest();

		System.assert(result.success);
	}

	@isTest static void sendOfferVariationEmail_KO() {
		Account a = BT_TestUtil.getAccount('name', '1');
		insert a;
		Contact c = BT_TestUtil.getContact(a.Id, 'Paolo', 'Oloap');
		insert c;
		BT_Simulation__c s = BT_TestUtil.getSimulation(a.Id);
		insert s;

		Test.startTest();
		BT_MailManager.Outcome result_NoId = BT_MailManager.sendOfferVariationEmail(null, false, c.Id, true, false);
		Test.stopTest();

		System.assert(!result_NoId.success);
	}
}