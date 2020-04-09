/**
 * WorkOrderTrigger - Generic trigger for Work Order object 
 *
 * @author EM
 * @date Creation 28/12/2018
 * @description
 */
trigger WorkOrderTrigger on WorkOrder (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Plc_TriggerDispatcher.run(new Plc_WorkOrderHnd());
}