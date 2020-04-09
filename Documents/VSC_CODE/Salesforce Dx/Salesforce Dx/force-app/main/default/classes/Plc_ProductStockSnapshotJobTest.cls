/**
 * @author Emanuele Campese
 * @date Creation 20/03/2019
 * @description Plc_ProductStockSnapshotJobTest - test of the Schedulable class for Batch 'Plc_ProductStockSnapshotJob'.
 */
@isTest
public class Plc_ProductStockSnapshotJobTest {

    /**
     * @author Emanuele Campese
     * @date Creation 20/03/2019
     * @description test of the method execute.
     */
    @isTest
    static void runTest(){

        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new Plc_ProductStockSnapshotJob());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}