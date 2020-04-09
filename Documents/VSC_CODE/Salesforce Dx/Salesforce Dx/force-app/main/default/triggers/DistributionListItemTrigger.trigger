trigger DistributionListItemTrigger on Plc_DistributionListItem__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Plc_TriggerDispatcher.Run(new Plc_DistributionListItemHnd());
}