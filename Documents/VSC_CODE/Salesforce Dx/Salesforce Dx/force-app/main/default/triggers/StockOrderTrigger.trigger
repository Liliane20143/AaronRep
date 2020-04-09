/**
 * Created by Murru on 22/01/2019.
 */

trigger StockOrderTrigger on Bit2Shop__StockOrder__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Plc_TriggerDispatcher.Run(new Plc_StockOrderTriggerHnd()); 
}