/**
 * TriggerDispatcherTest - Test for TriggerDispatcher
 *
 * @author EM
 * @date Creation 28/12/2018
 * @description
 * @source http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 */
@IsTest
private class Plc_TriggerDispatcherTest {

    @testSetup
    private static void testSetup(){
        //init PGov
        Plc_TestFactory.initProcessClickPackage();
    }

    static testMethod void unit_test_1() {
    
        Account acc = Plc_TestFactory.createAccountSupplier('Test');
        //acc.Name='Test';
        insert acc;
        Contact cnt = Plc_TestFactory.createContactGeneric('Test');
        cnt.AccountId =acc.id;
        //cnt.LastName='Test';
        insert cnt;
        WorkOrder wo = new WorkOrder();
        wo.Plc_FiscalCode__c='02345';

        Test.startTest();
        insert wo;
        update wo;
        delete wo;
        undelete wo;
        //disabled trigger
        insert new TriggerSettings__c(WorkOrderTrigger__c = System.now().addDays(1));
        //system.assertEquals(System.now().addDays(1), wo);
        delete wo;
        test.stopTest();
        String stringQuery = 'SELECT Id FROM WorkOrder';
        system.assertEquals(0, Database.query(stringQuery).size());
    }
}