@isTest
private class BT_AdminCntTest {

    @testSetup
    static void setup() {
        List<Account> testAccounts = new List<Account>();

        testAccounts.add(BT_TestUtil.getAccount('Banca Cieli', '1234'));
        testAccounts.add(BT_TestUtil.getAccount('Banca Onirico Teatro', '9876'));
        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(BT_TestUtil.getContact(testAccounts[0].Id, 'test', 'admin'));
        testContacts.add(BT_TestUtil.getContact(testAccounts[1].Id, 'test', 'admin2'));
        insert testContacts;

        List<User> testUsers = new List<User>();
        testUsers.add(BT_TestUtil.getUser(testContacts[0].Id, 'operator', 'btadmin@testbancacieli.com', 'BT_Admin', 0));
        testUsers.add(BT_TestUtil.getUser(testContacts[1].Id, 'operator2', 'btadmin@testbancaoniricoteatro.com', 'BT_Admin', 1));
        insert testUsers;

        BT_ConfigSimulator__c testConfig = BT_TestUtil.getSimulationConfig(testAccounts[0].Id, '1234');
        testConfig.BT_Altri_VisaConsumerCredit__c = 0.3;
        testConfig.BT_Oneri_VisaConsumerCredit__c = 0.2;
        testConfig.BT_IF_VisaConsumerCredit__c = 0.6;
        testConfig.BT_Costo_VisaConsumerCredit__c = 0.2;
        insert testConfig;
    }

    @isTest
    static void testLoadRecordLightningOK() {
        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];

        System.runAs(testUser) {
            BT_ConfigSimulator__c testConfig = BT_AdminCnt.loadRecord();
            System.assertEquals('1234', testConfig.BT_ABI__c);
        }
    }

    @isTest
    static void testLoadRecordLightningKO() {
        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancaoniricoteatro.com' LIMIT 1];

        System.runAs(testUser) {
            try {
                BT_ConfigSimulator__c testConfig = BT_AdminCnt.loadRecord();
                System.assert(false);
            } catch (AuraHandledException e) {
                System.assertEquals('Nessun record di configurazione trovato per questo ABI!', e.getMessage());
            }
        }
    }

    @isTest
    static void testLoadRecordGenericOK() {
        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];

        System.runAs(testUser) {
            BT_ConfigSimulator__c testConfig = BT_AdminCnt.loadRecord(true);
            System.assertEquals(1.3, testConfig.BT_Min_VisaConsumerCredit__c);
            System.assertEquals('1234', testConfig.BT_ABI__c);
        }
    }

    @isTest
    static void testLoadRecordGenericKO() {
        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancaoniricoteatro.com' LIMIT 1];

        System.runAs(testUser) {
            try {
                BT_ConfigSimulator__c testConfig = BT_AdminCnt.loadRecord(true);
                System.assert(false);
            } catch (AuraHandledException e) {
                System.assertEquals('Nessun record di configurazione trovato per questo ABI!', e.getMessage());
            }
        }
    }

    @isTest
    static void testSaveRecordOK() {
        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];

        System.runAs(testUser) {
            Test.startTest();
            BT_ConfigSimulator__c testConfig = BT_AdminCnt.loadRecord();
            testConfig.BT_Consigliato_PosPortatile3gPremium__c = 13;
            BT_AdminCnt.saveRecord(testConfig);
            Test.stopTest();

            testConfig = BT_AdminCnt.loadRecord();
            System.assertEquals(13, testConfig.BT_Consigliato_PosPortatile3gPremium__c);
        }
    }

    @isTest
    static void testSaveRecordKO() {
        User testUser = [SELECT Id FROM User WHERE Email='btadmin@testbancacieli.com' LIMIT 1];

        System.runAs(testUser) {
            Test.startTest();
            try {
                BT_ConfigSimulator__c testConfig = BT_AdminCnt.loadRecord();
                testConfig.BT_MarginalitaDesiderataTOTPreventivo__c = 1000000;
                BT_AdminCnt.saveRecord(testConfig);
                System.assert(false);
            } catch(Exception e) {
                Test.stopTest();
            }
        }
    }
}