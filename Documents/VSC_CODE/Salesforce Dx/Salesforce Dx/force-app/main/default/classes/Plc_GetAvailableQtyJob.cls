/**
 * @author Emanuele Campese
 * @date Creation 16/03/2019
 * @description Plc_GetAvailableQtyJob - Schedulable class for Batch 'Plc_GetAvailableQtyJob'.
 */
public class Plc_GetAvailableQtyJob implements Schedulable {

    /**
     * @author Emanuele Campese
     * @date 16/03/2019
     * @description retrieves the current Scheduler ClassName
     * @return String - retrieves the current Scheduler ClassName
     */
    public String getSchedulerName() {
        
        return Plc_GetAvailableQtyJob.class.getName();
    }

    public void execute(SchedulableContext schedulableContext) {

		Plc_BatchManagerService.executebatch(getSchedulerName());
	}
}