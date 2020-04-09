public with sharing class Plc_DistributionListItemHnd implements ITriggerHandler {

    public Boolean isDisabled() {
        TriggerSettings__c setting = TriggerSettings__c.getInstance();
        return setting.DistributionListItemTrigger__c!= null
                && setting.DistributionListItemTrigger__c > System.now();
    }

    public void beforeInsert(List<SObject> newItems) {}
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    public void beforeDelete(Map<Id, SObject> oldItems) {}
    public void afterInsert(Map<Id, SObject> newItems) {}

    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        Plc_DistributionListItemManager.manageUpdateOperation(newItems, oldItems);
    }
    
    public void afterDelete(Map<Id, SObject> oldItems) {}
    public void afterUndelete(Map<Id, SObject> oldItems) {}
}