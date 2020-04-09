/**
 * DealerTrigger - Generic trigger for Dealer object
 *
 * @author CE
 * @date Creation 05/09/2019
 * @description
 */

trigger DealerTrigger on Bit2Shop__Dealer__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Plc_TriggerDispatcher.Run(new Plc_DealerTriggerHnd());
}