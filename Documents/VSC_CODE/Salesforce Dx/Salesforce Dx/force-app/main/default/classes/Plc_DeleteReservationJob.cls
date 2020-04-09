/**
 * @author Pietro Santochirico
 * @date Creation 28/02/2019
 * @description Plc_DeleteReservationJob - Schedulable class for Batch 'Plc_DeleteReservationBtc'.
 */
public class Plc_DeleteReservationJob implements Schedulable {

    /**
     * @author Pietro Santochirico
     * @date 28/02/2019
     * @description retrieves the current Scheduler ClassName
     * @return String - retrieves the current Scheduler ClassName
     */
    public String getSchedulerName() {
        
        return Plc_DeleteReservationJob.class.getName();
    }

    public void execute(SchedulableContext schedulableContext) {

		Plc_BatchManagerService.executebatch(getSchedulerName());
	}
}