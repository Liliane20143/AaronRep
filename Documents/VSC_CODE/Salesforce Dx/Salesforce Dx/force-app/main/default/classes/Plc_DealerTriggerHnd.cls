/**
 * Plc_DealerTriggerHnd - Dealer Trigger Handler
 * @author Andrea Liverani
 * @date Creation 15/03/2019
 * @description
 */

public with sharing class Plc_DealerTriggerHnd implements ITriggerHandler {

    public Boolean isDisabled() {
        LogTracker.debugLogBegin('Plc_DealerTriggerHnd', 'IsDisabled');
        TriggerSettings__c setting = TriggerSettings__c.getInstance();
        Boolean disabled = setting.DealerTrigger__c != null
                && setting.DealerTrigger__c > System.now();
        LogTracker.debugLog('Plc_DealerTriggerHnd', 'IsDisabled', '## disabled: ' + disabled);
        LogTracker.debugLogEnd('Plc_DealerTriggerHnd', 'IsDisabled');
        return disabled;
    }

    public void beforeInsert(List<SObject> newItems) {
        for(Bit2Shop__Dealer__c dealerNew : (List<Bit2Shop__Dealer__c>) newItems){
            if(dealerNew.Plc_WarehouseForSpecificConsumption__c != null){
                dealerNew.addError('There are not any warehouses for this dealer');
            }
        }
    }

    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('DealerTrigger BeforeUpdate');
        Plc_Utils Utility = new Plc_Utils();
        Set<Id> dealerToSearch = new Set<Id>();
        Map<String,Bit2Shop__Dealer__c> warehouseToDealer = new Map<String,Bit2Shop__Dealer__c>();
        Map<String,Bit2Shop__Dealer__c> dealerIdToDealer = new Map<String,Bit2Shop__Dealer__c>();

        for(Bit2Shop__Dealer__c dealerUpdated : (List<Bit2Shop__Dealer__c>) newItems.values() ){
            System.debug('recordType: '+Utility.getRecordTypeNameById('Bit2Shop__Dealer__c',dealerUpdated.RecordTypeId) );
            if(Utility.getRecordTypeNameById('Bit2Shop__Dealer__c',dealerUpdated.RecordTypeId) == 'Child Dealer' && dealerUpdated.Plc_WarehouseForSpecificConsumption__c != null){
                System.debug('InDebug');
                Bit2Shop__Dealer__c dealerOld = (Bit2Shop__Dealer__c) oldItems.get(dealerUpdated.Id);
                if(dealerUpdated.Plc_WarehouseForSpecificConsumption__c != dealerOld.Plc_WarehouseForSpecificConsumption__c){
                    warehouseToDealer.put(dealerUpdated.Plc_WarehouseForSpecificConsumption__c,dealerUpdated);
                }
            }
        }
        System.debug('warehouseToDealer: '+warehouseToDealer);
        for(Bit2Shop__Warehouse__c warehouse : [SELECT Id,Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c WHERE Id IN: warehouseToDealer.keySet() ]){
            System.debug('InDebug2');
            if(warehouseToDealer.get(warehouse.id).Id != warehouse.Bit2Shop__Dealer_Id__c){
                warehouseToDealer.get(warehouse.id).addError('The Warehouse indicated , is not a warehouse of this dealer');
            }
        }
    }

    public void beforeDelete(Map<Id, SObject> oldItems) {}

    public void afterInsert(Map<Id, SObject> newItems) {/*Plc_DealerUserManager.manageInsertOperation(newItems);*/}

    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('### Plc_StockSerials2Hnd.BeforeUpdate');

        List<String> dealerIdsList = new List<String>();
        Map<Id, Bit2Shop__Dealer__c> oldDealerMap = (Map<Id, Bit2Shop__Dealer__c>) oldItems;
        Map<Id, Bit2Shop__Dealer__c> newDealerMap = (Map<Id, Bit2Shop__Dealer__c>) newItems;

        System.debug('oldDealerMap >> ' + oldDealerMap);
        System.debug('newDealerMap >> ' + newDealerMap);

        System.debug('newDealerMap >> ' + newDealerMap.values());

        for (Bit2Shop__Dealer__c newDealer : newDealerMap.values()) {
            System.debug('oldDealerMap.get(newDealer.Id).OwnerId >> ' + oldDealerMap.get(newDealer.Id).OwnerId);
            System.debug('newDealer.RecordType.DeveloperName >> ' + newDealer.RecordType.DeveloperName);

            if(oldDealerMap.get(newDealer.Id).OwnerId != newDealer.OwnerId && newDealer.RecordTypeId == Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c')) {
                dealerIdsList.add(newDealer.Id);
            }
        }
        System.debug('dealerIdsList >> ' + dealerIdsList);

        List<Bit2Shop__StockOrder__c> stockOrderList = [SELECT Id, Bit2Shop__Destination_Point_Of_Sales_Id__c FROM Bit2Shop__StockOrder__c WHERE Bit2Shop__Status__c NOT IN('Closed','Closed with residual lines') AND Bit2Shop__Destination_Point_Of_Sales_Id__c IN :dealerIdsList];

        System.debug('stockOrderList >> ' + stockOrderList);

        if(!stockOrderList.isEmpty()) {
            for(Bit2Shop__StockOrder__c stockOrder : stockOrderList) {
                stockOrder.Plc_DestinationDealerOwner__c = newDealerMap.get(stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c).OwnerId;
            }
            update stockOrderList;
        }

        System.debug('stockOrderList >> ' + stockOrderList);
    }

    public void afterDelete(Map<Id, SObject> oldItems) {}

    public void afterUndelete(Map<Id, SObject> oldItems) {}
}