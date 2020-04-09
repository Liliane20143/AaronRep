@isTest
private class BT_SimulationDocumentExtensionTest {
	
	@isTest static void getConfigRecord() {
		String abi = '1234';
		Account a = BT_TestUtil.getAccount('john', abi);
		insert a;
		BT_ConfigSimulator__c c = BT_TestUtil.getSimulationConfig(a.Id, abi);
		insert c;
		BT_Simulation__c s = BT_TestUtil.getSimulation(a.Id);
		insert s;
		ApexPages.StandardController sc = new ApexPages.StandardController(s);
		BT_SimulationDocumentExtension ext = new BT_SimulationDocumentExtension(sc);

        Test.startTest();
        PageReference pageRef = Page.BT_SimulationDocument;
        pageRef.getParameters().put('id', String.valueOf(s.Id));
        Test.setCurrentPage(pageRef);
        Test.stopTest();

        System.assertEquals(c.BT_Disclaimer__c, ext.config.BT_Disclaimer__c);
	}
}