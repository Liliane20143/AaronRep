/**
 * @author Tanzi Gabriele Giovanni
 * @date Creation 14/12/2018
 * @version 1.0
 * @description Scheduler Abstract Class - Every Scheduler must extend this class
 */
public abstract class Plc_MasterScheduledJob implements Schedulable {

	public abstract String getSchedulerName();

	/**
	 * @author Tanzi Gabriele Giovanni
	 * @date Creation 14/12/2018
	 * @version 1.0
	 * @description Execute the batch corresponding to the scheduler
	 *
	 * @param schedulableContext - The context of the scheduler
	 * @return void - Nothing
	 */
	public void execute(SchedulableContext schedulableContext) {

		Plc_BatchManagerService.executebatch(getSchedulerName());
	}
}