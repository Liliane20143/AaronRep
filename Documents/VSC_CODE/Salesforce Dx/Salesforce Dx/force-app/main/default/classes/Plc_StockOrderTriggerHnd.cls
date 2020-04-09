/**
 * Plc_StockOrderTriggerHnd - Stock Order Trigger handler
 *
 * @author EM
 * @date Creation 22/01/2019
 * @description
 * @testedIn Plc_StockOrderTriggerHndTest
 */

public with sharing class Plc_StockOrderTriggerHnd implements ITriggerHandler{

    public Boolean IsDisabled(){

        TriggerSettings__c setting = TriggerSettings__c.getInstance();
        return setting.StockOrderTrigger__c != null
                && setting.StockOrderTrigger__c > System.now();
    }

    public void BeforeInsert(List<SObject> newItems){

    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){

    }

    public void BeforeDelete(Map<Id, SObject> oldItems){

    }

    public void AfterInsert(Map<Id, SObject> newItems){
        /*List<ID> stockOrderIdsForActions = new List<ID>();
        //looks for shipment status change to trigger its actions
        for (Bit2Shop__StockOrder__c newItem : (List<Bit2Shop__StockOrder__c>) newItems.values()) {
            stockOrderIdsForActions.add(newItem.Id);
        }

        if(!stockOrderIdsForActions.isEmpty()) {
            Plc_StockActionsHnd.executeActions(stockOrderIdsForActions, null);
        }*/
    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        List<ID> stockOrderIdsForActions = new List<ID>();
        //looks for shipment status change to trigger its actions
        for (Bit2Shop__StockOrder__c newItem : (List<Bit2Shop__StockOrder__c>) newItems.values()) {
            Bit2Shop__StockOrder__c oldItem = (Bit2Shop__StockOrder__c) oldItems.get(newItem.Id);
            if (newItem.Bit2Shop__Status__c != oldItem.Bit2Shop__Status__c) {
                if(Plc_StockActionsHnd.alreadyCalculated.contains(newItem.Id+'_'+newItem.Bit2Shop__Status__c)) {
                    continue;
                }
                stockOrderIdsForActions.add(newItem.Id);
                Plc_StockActionsHnd.alreadyCalculated.add(newItem.Id+'_'+newItem.Bit2Shop__Status__c);
            }
        }
        System.debug('### stockOrderIdsForActions: '+stockOrderIdsForActions);
        System.debug('### newItems: '+newItems);
        System.debug('### oldItems: '+oldItems);
        System.debug('### Plc_StockActionsHnd.alreadyCalculated: '+Plc_StockActionsHnd.alreadyCalculated);
        if(!stockOrderIdsForActions.isEmpty()) {
            Plc_StockActionsHnd.executeActions(stockOrderIdsForActions, null);
        }
    }

    public void AfterDelete(Map<Id, SObject> oldItems){

    }

    public void AfterUndelete(Map<Id, SObject> oldItems){

    }

}