/**
 * @author Emanuele Campese
 * @date Creation 14/03/2019
 * @description Plc_RemoveProductStockSnapshotJob - Schedulable class for Batch 'Plc_RemoveProductStockSnapshotJob'.
 */
public class Plc_RemoveProductStockSnapshotJob implements Schedulable {

    /**
     * @author Emanuele Campese
     * @date 14/03/2019
     * @description retrieves the current Scheduler ClassName
     * @return String - retrieves the current Scheduler ClassName
     */
    public String getSchedulerName() {
        
        return Plc_RemoveProductStockSnapshotJob.class.getName();
    }

    public void execute(SchedulableContext schedulableContext) {

		Plc_BatchManagerService.executebatch(getSchedulerName());
	}
}