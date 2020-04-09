/**
 * @author Emanuele Campese
 * @date Creation 14/03/2019
 * @description Plc_ProductStockSnapshotJob - Schedulable class for Batch 'Plc_ProductStockSnapshotBtc'.
 */
public class Plc_ProductStockSnapshotJob implements Schedulable {

    /**
     * @author Emanuele Campese
     * @date 14/03/2019
     * @description retrieves the current Scheduler ClassName
     * @return String - retrieves the current Scheduler ClassName
     */
    public String getSchedulerName() {
        
        return Plc_ProductStockSnapshotJob.class.getName();
    }

    public void execute(SchedulableContext schedulableContext) {

		Plc_BatchManagerService.executebatch(getSchedulerName());
	}
}