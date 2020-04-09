/**
 * @author Tanzi Gabriele Giovanni
 * @date Creation 14/12/2018
 * @version 1.0
 * @description Batch Manager Service - Every Scheduler must call this class to execute its proper batch.
 */
public with sharing class Plc_BatchManagerService {

	/**
	 * @author Tanzi Gabriele Giovanni
	 * @date Creation 14/12/2018
	 * @version 1.0
	 * @description Execute the batch corresponding to the scheduler.
	 *
	 * @param schedulerName - Scheduler's name
	 * @return void - Nothing
	 */
	public static void executeBatch(String schedulerName) {
		System.debug('schedulerName= '+schedulerName);
		String thisMethod = 'executeBatch';
		LogTracker.debugLogBegin(schedulerName, thisMethod);
		try {

			//Getting the Batch name from the Custom Metadata.
			Plc_BatchSettings__mdt batchSettings = [SELECT Plc_BatchClassName__c, Plc_ScopeSize__c
			                                        FROM Plc_BatchSettings__mdt
			                                        WHERE Plc_SchedulerClassName__c = :schedulerName LIMIT 1];

			//Instantiate the type.
			Type signedBatch = Type.forName(batchSettings.Plc_BatchClassName__c);
			LogTracker.debugLog(schedulerName, thisMethod, 'Going to launch batch ' + batchSettings.Plc_BatchClassName__c);

			Plc_MasterBatchable batchable = (Plc_MasterBatchable)signedBatch.newInstance();
			System.debug('SCOPRESIZE: '+ batchSettings.Plc_ScopeSize__c.intValue());
			Database.executeBatch(batchable, batchSettings.Plc_ScopeSize__c.intValue());

		} catch (Exception ex) {

			String message = 'EXCEPTION - Message: ' + ex.getMessage() + 'Cause: ' + ex.getCause();
			LogTracker.debugLog(schedulerName, thisMethod, message);
		}
		LogTracker.debugLogEnd(schedulerName, thisMethod);
		System.debug('HERE OF COURSE');
	}

	/**
	 * @author Tanzi Gabriele Giovanni
	 * @date Creation 14/12/2018
	 * @version 1.0
	 * @description Aborts the job.
	 *
	 * @param jobIds - list of ids
	 * @return void - Nothing
	 */
	public static void abortCurrentJob(List<String> jobIds) {
        
        String thisMethod = 'abortCurrentJob';
        LogTracker.debugLogBegin('Plc_BatchManagerService', thisMethod);
		
        if (!jobIds.isEmpty()) {

            LogTracker.debugLog('Plc_BatchManagerService', thisMethod, 'Aborting Job: ' + jobIds[0]);
			System.AbortJob(jobIds[0]);
		}
		LogTracker.debugLogEnd('Plc_BatchManagerService', thisMethod);
	}

	/**
	 * @author Tanzi Gabriele Giovanni
	 * @date Creation 14/12/2018
	 * @version 1.0
	 * @description The maximum elements retrieved in query.
	 *
	 * @param batchName - Batch's name
	 * @return Integer - Limit clause on Query
	 */
	public static Integer getBatchQueryLimit(String batchName) {

		Plc_BatchSettings__mdt batchSettings = [SELECT Plc_QueryLimit__c
		                                        FROM Plc_BatchSettings__mdt
		                                        WHERE Plc_BatchClassName__c = :batchName LIMIT 1];
		return batchSettings.Plc_QueryLimit__c != null ? batchSettings.Plc_QueryLimit__c.intValue() : null;
	}

	/**
	* @author Tanzi Gabriele Giovanni
	* @date Creation 14/12/2018
	* @version 1.0
	* @description Checks if batch is running
	*
	* @param String Name of the batch to check
	* @param Boolean isTestRunning
	* @return void - Nothing
	*/
	public static void scheduleNextBatchs(String batchName, Boolean isTestRunning) {
		//TODO : implement logic
	}
}