/**
 * StockSerials2Trigger - Generic trigger for Stock Serial 2 object
 *
 * @author AP
 * @date Creation 15/01/2019
 * @description
 */
trigger StockSerials2Trigger on Bit2Shop__Stock_Serials2__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Plc_TriggerDispatcher.Run(new Plc_StockSerials2Hnd());
}