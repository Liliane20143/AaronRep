/**
 * @author Pietro Santochirico
 * @date Creation 15/01/2019
 * @version 1.0
 * @description Test of the Class  Plc_DeleteReservationJob.
 */
@isTest
public class Plc_DeleteReservationJobTest {

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 15/01/2019
     * @version 1.0
     * @description Test of the method  execute.
     */
    public static testMethod void testschedule() {

        Plc_ProcessSettings__c csMaxDays = new Plc_ProcessSettings__c();
        csMaxDays.Plc_MaxDaysToRetainReservations__c = 10;
        insert csMaxDays;

        Test.StartTest();
        Plc_DeleteReservationJob deleteReservationJob = new Plc_DeleteReservationJob();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, deleteReservationJob);
        Test.stopTest();
        String stringQuery = 'SELECT ApexClassId, Id FROM AsyncApexJob';
        system.assertEquals(2, Database.query(stringQuery).size());
    }
}