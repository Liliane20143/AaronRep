/**
 * @author Emanuele Campese
 * @date Creation 18/12/2018
 * @description Plc_WarehouseSolutionConsumedQtyJob - Schedulable class for Batch 'Plc_WarehouseSolutionConsumedQtyBtc'.
 */
public class Plc_WarehouseSolutionConsumedQtyJob implements Schedulable {

    /**
     * @author Emanuele Campese
     * @date 18/12/2018
     * @description retrieves the current Scheduler ClassName
     * @return String - retrieves the current Scheduler ClassName
     */
    public String getSchedulerName() {
        
        return Plc_WarehouseSolutionConsumedQtyJob.class.getName();
    }

    public void execute(SchedulableContext schedulableContext) {

		Plc_BatchManagerService.executebatch(getSchedulerName());
	}
}