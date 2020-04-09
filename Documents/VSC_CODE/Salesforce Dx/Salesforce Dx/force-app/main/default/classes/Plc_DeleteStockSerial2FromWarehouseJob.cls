/**
 * @author Emanuele Campese
 * @date Creation 14/03/2019
 * @description Plc_DeleteStockSerial2FromWarehouseJob - Schedulable class for Batch 'Plc_DeleteStockSerial2FromWarehouseJob'.
 */
public class Plc_DeleteStockSerial2FromWarehouseJob implements Schedulable {

    /**
     * @author Emanuele Campese
     * @date 15/03/2019
     * @description retrieves the current Scheduler ClassName
     * @return String - retrieves the current Scheduler ClassName
     */
    public String getSchedulerName() {
        
        return Plc_DeleteStockSerial2FromWarehouseJob.class.getName();
    }

    public void execute(SchedulableContext schedulableContext) {

		Plc_BatchManagerService.executebatch(getSchedulerName());
	}
}