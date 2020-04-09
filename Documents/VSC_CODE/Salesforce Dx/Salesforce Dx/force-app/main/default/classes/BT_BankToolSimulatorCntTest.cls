@isTest
private class BT_BankToolSimulatorCntTest {

    @TestSetup
    static void setup(){
        List<Account> testAccounts = new List<Account>();

        testAccounts.add(BT_TestUtil.getAccount('Banca Cieli', '1234'));
        testAccounts.add(BT_TestUtil.getAccount('Banca Onirico Teatro', '9876', true));
        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(BT_TestUtil.getContact(testAccounts[0].Id, 'test', 'admin'));
        testContacts.add(BT_TestUtil.getContact(testAccounts[1].Id, 'test', 'admin2'));
        insert testContacts;

        List<User> testUsers = new List<User>();
        testUsers.add(BT_TestUtil.getUser(testContacts[0].Id, 'operator', 'btadmin@testbancacieli.com', 'BT_Admin', 0));
        testUsers.add(BT_TestUtil.getUser(testContacts[1].Id, 'operator2', 'opreferral@testbancaoniricoteatro.com', 'BT_Operatore', 1));
        insert testUsers;

        List<BT_ConfigSimulator__c> testConfigs = new List<BT_ConfigSimulator__c>();

        BT_ConfigSimulator__c testConfigLicensing = BT_TestUtil.getSimulationConfig(testAccounts[0].Id, '1234');
        testConfigLicensing.BT_Altri_VisaConsumerCredit__c = 0.3;
        testConfigLicensing.BT_Oneri_VisaConsumerCredit__c = 0.2;
        testConfigLicensing.BT_IF_VisaConsumerCredit__c = 0.6;
        testConfigLicensing.BT_Costo_VisaConsumerCredit__c = 0.2;
        testConfigLicensing.BT_Bench_VisaCommercial__c = 30;
        testConfigLicensing.BT_Bench_VisaCommercialEEA__c = 35;
        testConfigLicensing.BT_MarginalitaDesiderataTOTPreventivo__c = 1;
        testConfigs.add(testConfigLicensing);

        BT_ConfigSimulator__c testConfigReferral = BT_TestUtil.getSimulationConfig(testAccounts[1].Id, '9876', 'ReferralOffer');
        testConfigReferral.BT_NegoziatoAnnuoMin__c = 0;
        testConfigReferral.BT_NegoziatoAnnuoMax__c = 60000;
        testConfigReferral.BT_Altri_VisaConsumerCredit__c = 0.3;
        testConfigReferral.BT_Oneri_VisaConsumerCredit__c = 0.2;
        testConfigReferral.BT_IF_VisaConsumerCredit__c = 0.6;
        testConfigReferral.BT_Costo_VisaConsumerCredit__c = 0.2;
        testConfigReferral.BT_MarginalitaDesiderataTOTPreventivo__c = 1.5;
        testConfigReferral.BT_Tipo__c = 'packages';

        testConfigs.add(testConfigReferral);
        insert testConfigs;
    }

    @isTest
    static void testLoadConfigurationBasic() {
        Test.setMock(HttpCalloutMock.class, new BT_HerokuGetDataMock());

        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];
        Map<String, Object> configs;


        System.runAs(testUser) {
            Test.startTest();
                configs = BT_BankToolSimulatorCnt.loadConfiguration('{ "mcc": "1234", "fatturato": "60000", "cap": "20100" }', 'basic');
            Test.stopTest();
        }

        System.assert(configs.containsKey('mfeevisacommercial'));
        System.assertEquals(0.0149, configs.get('mfeevisacommercial'));

    }

    @isTest
    static void testLoadConfigurationAdvanced() {
        Test.setMock(HttpCalloutMock.class, new BT_HerokuGetDataMock());

        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];
        Map<String, Object> configs;


        System.runAs(testUser) {
            Test.startTest();
                configs = BT_BankToolSimulatorCnt.loadConfiguration('{ "mcc": "1234", "fatturato": "60000", "cap": "20100" }', 'advanced');
            Test.stopTest();
        }

        System.assert(configs.containsKey('deltabenchvisacommercialeea'));
        System.assertEquals(0.05, configs.get('deltabenchvisacommercialeea'));
    }

    @isTest
    static void testLoadReferralConfigurations() {
        Test.setMock(HttpCalloutMock.class, new BT_HerokuGetDataMock());

        User testUser = [SELECT Id FROM User WHERE Email='opreferral@testbancaoniricoteatro.com' LIMIT 1];
        Map<String, Object> configs;

        System.runAs(testUser) {
            Test.startTest();
                configs = BT_BankToolSimulatorCnt.loadReferralConfigurations('{ "mcc": "1234", "negoziato": "50000", "cap": "20100" }', 'packages');
            Test.stopTest();
        }

        System.assert(configs.containsKey('offers'));
    }

    @isTest
    static void testIsReferralTrue() {
        User testUser = [SELECT Id FROM User WHERE Email='opreferral@testbancaoniricoteatro.com' LIMIT 1];
        Boolean isReferral = false;

        System.runAs(testUser) {
            Test.startTest();
                isReferral = BT_BankToolSimulatorCnt.isReferral();
            Test.stopTest();
        }

        System.assert(isReferral);
    }

    @isTest
    static void testIsReferralFalse() {
        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];
        Boolean isReferral = false;

        System.runAs(testUser) {
            Test.startTest();
                isReferral = BT_BankToolSimulatorCnt.isReferral();
            Test.stopTest();
        }

        System.assert(!isReferral);
    }

    @isTest
    static void testSaveSimulationOK() {
        User testUser = [SELECT Id, AccountId FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];

        String simId = null;
        BT_Simulation__c record = new BT_Simulation__c(BT_CAP__c = '20100');

        System.runAs(testUser) {
            Test.startTest();
                simId = BT_BankToolSimulatorCnt.saveSimulation(record);
            Test.stopTest();
        }

        System.assert(String.isNotBlank(simId));
        System.assertEquals(testUser.AccountId, record.BT_Account__c);
    }

    @isTest
    static void testSaveSimulationKO() {
        User testUser = [SELECT Id, AccountId FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];

        String simId = null;
        BT_Simulation__c record = new BT_Simulation__c(BT_CAP__c = '20100', BT_CanMensSmartPosCassa__c=1200010);

        System.runAs(testUser) {
            Test.startTest();
                try {
                    BT_BankToolSimulatorCnt.saveSimulation(record);
                    System.assert(false);
                } catch (Exception e) {
                    System.assert(true);
                }
            Test.stopTest();
        }
    }
}