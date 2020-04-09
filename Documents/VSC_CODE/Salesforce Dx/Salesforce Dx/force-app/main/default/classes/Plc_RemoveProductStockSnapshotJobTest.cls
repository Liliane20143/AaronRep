/**
 * @author Abdoulaye DIOP
 * @date Creation 22/03/2019
 * @version 1.0
 * @description Test of the class Plc_RemoveProductStockSnapshotJob.
 */
@isTest
public class Plc_RemoveProductStockSnapshotJobTest {

    @TestSetup
    static  void makeData(){
        Plc_SystemSettings__c PROCESS_SETTINGS = new Plc_SystemSettings__c();
        PROCESS_SETTINGS.Plc_MonthsToRemovePrdSnpShot__c=3;
        PROCESS_SETTINGS.Plc_DaysForCalculatingConsumption__c = 30;
        PROCESS_SETTINGS.Plc_PurchaseWarrantyMonthsDelay__c   = 5;
        insert PROCESS_SETTINGS;
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 22/03/2019
     * @version 1.0
     */
    @isTest
    static void removeProductStockSnapshotJobTest(){

        String CRON_EXP = '0 0 0 15 3 ? *';

        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new Plc_RemoveProductStockSnapshotJob());
            CronTrigger cr = [SELECT CronExpression, NextFireTime, TimesTriggered FROM CronTrigger WHERE id =: jobId];
            System.assertEquals(CRON_EXP, cr.CronExpression);
            System.assertEquals(0, cr.TimesTriggered);
        Test.stopTest();
    }
}