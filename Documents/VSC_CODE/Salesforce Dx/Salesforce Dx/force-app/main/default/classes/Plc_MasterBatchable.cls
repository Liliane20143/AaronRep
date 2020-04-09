/**
 * @author Tanzi Gabriele Giovanni
 * @date Creation 14/12/2018
 * @version 1.0
 * @description Master Batchable - Abstract class extended by all batch classes
 */
public abstract class Plc_MasterBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    private static final Integer TEST_QUERY_LIMITS = 1000;
    public abstract String getDynamicQuery();
    public abstract String getBatchName();

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 14/12/2018
     * @version 1.0
     * @description Retrieve the limit set for this scheduler, can be null
     * 
     * @return Integer The limit to set the querylocator query
     */
    public Integer getBatchLimit () {

        return Plc_BatchManagerService.getBatchQueryLimit(getBatchName());
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 14/12/2018
     * @version 1.0
     * @description Preparation of the query to scroll on records
     * 
     * @param batchableContext The context of the batch
     * @return Database.getQueryLocator Recprds corresponding to the parsed query
     */
    public Database.QueryLocator start(Database.BatchableContext batchableContext) {

        String dynamicQuery = getDynamicQuery();
        String batchName = getBatchName();
        Integer batchLimits = getBatchLimit();

        LogTracker.debugLogBegin(batchName, 'start');

        //In test context, we should limit the number of record parsed by the query
        if (Test.isRunningTest()) {

            batchLimits = TEST_QUERY_LIMITS;
        }
        if (batchLimits != null && batchLimits > 0) {

            dynamicQuery += ' LIMIT ' + batchLimits;
            LogTracker.debugLog(batchName, 'start', 'DynamicQuery: ' + dynamicQuery);
        }
        if (Plc_BatchManagerUtl.isBatchRunning(batchName, (String)batchableContext.getJobId())) {

            LogTracker.debugLogEnd(batchName, 'start', 'Aborting because previous one is still running.');
            Plc_BatchManagerService.abortCurrentJob(new List<String> {(String)batchableContext.getJobId()});
        }

        LogTracker.debugLogEnd(batchName, 'start', 'Calling getQueryLocator.');
        System.debug('MyDynamicQuery: '+dynamicQuery );
        return Database.getQueryLocator(dynamicQuery);
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 14/12/2018
     * @version 1.0
     * @description Logs results of the batch process at the end of the processing
     * 
     * @param batchableContext The context of the batch
     * @return void
     */
    

}