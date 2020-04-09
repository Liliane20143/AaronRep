/**
 * @author Abdoulaye & Moussa
 * @date Creation 14/12/2018
 * @version 1.0
 * @description Test of PLC BatchManagerUtl.
 */
@isTest
public class Plc_BatchManagerUtlTest {

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 14/12/2018
     * @version 1.0
     * @description Test of the method  isBatchRunning.
     */
    @isTest
    static void isBatchRunningTest(){
        Plc_BatchManagerUtl batchManagerUtl= new Plc_BatchManagerUtl();
        Test.startTest();
        Plc_BatchManagerUtl.isBatchRunning('batchName','jobId');
        Test.stopTest();
    }

}