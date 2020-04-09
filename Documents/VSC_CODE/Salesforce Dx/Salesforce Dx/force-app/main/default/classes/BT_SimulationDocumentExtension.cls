public with sharing class BT_SimulationDocumentExtension {

	private final BT_Simulation__c simulation;
    public BT_ConfigSimulator__c config {get; private set;}

    public BT_SimulationDocumentExtension(ApexPages.StandardController stdController) {
        this.simulation = (BT_Simulation__c)stdController.getRecord();
        getConfigRecord();
    }

    public BT_ConfigSimulator__c getConfigRecord() {
        config = new BT_ConfigSimulator__c();
        List<BT_ConfigSimulator__c> configs = [SELECT BT_Disclaimer__c, BT_Logo__c FROM BT_ConfigSimulator__c WHERE BT_Account__c = :simulation.BT_Account__c ORDER BY SystemModstamp DESC];
        if (!configs.isEmpty()) {
            if (configs.size() > 1 ) {
                System.debug(LoggingLevel.WARN, 'More than 1 record found for object BT_ConfigSimulator__c for the account: '+simulation.BT_Account__c+'. Actually page will take the most recent one');
            }
            config = configs.get(0);
        } else {
            System.debug(LoggingLevel.ERROR, 'No record found for object BT_ConfigSimulator__c for the account: '+simulation.BT_Account__c);
        }

        System.debug('config: '+config);
        return config;
    }
}