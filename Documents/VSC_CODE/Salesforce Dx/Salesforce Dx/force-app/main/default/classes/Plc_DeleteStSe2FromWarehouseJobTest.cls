/**
 * @author Emanuele Campese
 * @date Creation 20/03/2019
 * @description Plc_DeleteStSe2FromWarehouseJobTest - test of the Schedulable class for Batch 'Plc_DeleteStSe2FromWarehouseJobTest'.
 */
@isTest
public class Plc_DeleteStSe2FromWarehouseJobTest {

    @testSetup
    public static void setup(){
        Plc_ProcessSettings__c PROCESS_SETTINGS = new Plc_ProcessSettings__c();
        PROCESS_SETTINGS.Plc_DaysToDeleteStockSerial2New__c = 30;
        insert PROCESS_SETTINGS;
    }
    /**
     * @author Emanuele Campese
     * @date Creation 20/03/2019
     * @description test of the method execute.
     */
    @isTest
    static void runTest(){

        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new Plc_DeleteStockSerial2FromWarehouseJob());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}