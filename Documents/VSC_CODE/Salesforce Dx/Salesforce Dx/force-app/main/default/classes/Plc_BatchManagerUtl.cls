/**
 * @author Tanzi Gabriele Giovanni 
 * @date Creation 14/12/2018
 * @version 1.0
 * @description Batch utility Manager - Utility class used by batch classes
 */
public with sharing class Plc_BatchManagerUtl {

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 14/12/2018
     * @version 1.0 
     * @description Checks if batch is running
     * 
     * @param batchName - Name of the batch to check
     * @param jobId - Id of the batch to check
     * @return Boolean - True if is running
     */
    public static Boolean isBatchRunning(String batchName, String jobId) {

        // Retrirve batch to check
        List<AsyncApexJob> asyncApexJobs = [SELECT Id, Status
                                            FROM AsyncApexJob
                                            WHERE JobType = 'BatchApex' 
                                            AND MethodName = :batchName 
                                            AND Id != :jobId];
        return asyncApexJobs.isEmpty() ? false : true;
    }

}