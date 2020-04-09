/**
 * Plc_DistributionListItemManager - Manage post process logic for Distribution List Item entity
 *
 * @author MZ
 * @author FB
 * @date Creation 31/01/2019
 * @description 
 * @testedIn Plc_DistributionListItemManagerTest
 *
 * 2019-03-04 FB - Adding status check
 * 2019-03-04 FB - Adding Purchase Order Item Update
 */
public without sharing class Plc_DistributionListItemManager {
	// Entry point for AfterUpdate trigger scenario
	public static void manageUpdateOperation(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        performUpdateOperation(oldItems, newItems, 'AFTER UPDATE');
	}

    private static void performUpdateOperation(Map<Id, SObject> oldItems, Map<Id, SObject> newItems, String sourceOperation) {
        System.debug('## Plc_StockSerial2HistoryManager ##:' + sourceOperation);
        System.debug('## Plc_StockSerial2HistoryManager:HOWMANY ##:' + newItems.size());
        System.debug('## Plc_StockSerial2HistoryManager:ITEMS ##:' + newItems.keyset());
        updateProductStocks(oldItems, newItems);
    }

    // Update product stocks related to Distribution List Items
    private static void updateProductStocks(Map<Id, SObject> oldItems, Map<Id, SObject> newItems) {
        Set<Id> destinationWarehousesSet = new Set<Id>();
        Set<Id> modelsSet = new Set<Id>();
        Set<Id> purchaseOrdersSet = new Set<Id>(); 
        
        //Filter on distribution list items whose status goes to 'Requested' from 'Draft'
        //Only These distribution list items will cause a Product Stock/Purchase Order Item update
        List<Plc_DistributionListItem__c> dliList = new List<Plc_DistributionListItem__c>();
        //Getting distribution list items according to status change
        for (String key : newItems.keySet()) {
            if (oldItems.containsKey(key) && 
                ((Plc_DistributionListItem__c) newItems.get(key)).Plc_Status__c == 'Requested' && 
                ((Plc_DistributionListItem__c) oldItems.get(key)).Plc_Status__c == 'Draft') {
                dliList.add((Plc_DistributionListItem__c)newItems.get(key));
            }
        }

        //Building sets in order to query data
        for (Plc_DistributionListItem__c dli : dliList) {
            destinationWarehousesSet.add(dli.Plc_DestinationWarehouse__c);
            modelsSet.add(dli.Plc_Product__c);
            purchaseOrdersSet.add(dli.Plc_PurchaseOrder__c);
        }

        //Getting Product Stock related to distribution list items
        List<Bit2Shop__Product_Stock__c> productStocksList = [SELECT Id, Plc_OrderedQty__c, Bit2Shop__Warehouse_Id__c, 
                                                                     Bit2Shop__External_Catalog_Item_Id__c
                                                              FROM Bit2Shop__Product_Stock__c 
                                                              WHERE Bit2Shop__External_Catalog_Item_Id__c IN :modelsSet 
                                                              AND Bit2Shop__Warehouse_Id__c IN :destinationWarehousesSet 
                                                              FOR UPDATE];

        List<Plc_PurchaseOrderItem__c> purchaseOrderItemsList = [SELECT Id, Plc_Model__c, Plc_OrderedQty__c,
                                                                        Plc_PurchaseOrder__c
                                                                 FROM Plc_PurchaseOrderItem__c
                                                                 WHERE Plc_Model__c IN :modelsSet AND
                                                                       Plc_PurchaseOrder__c IN :purchaseOrdersSet
                                                                 FOR UPDATE];

        for (Plc_DistributionListItem__c dli : dliList) {
            //Updating ordered quantity on Product Stock
            for (Bit2Shop__Product_Stock__c ps : productStocksList) {
                if (dli.Plc_DestinationWarehouse__c == ps.Bit2Shop__Warehouse_Id__c && 
                    dli.Plc_Product__c == ps.Bit2Shop__External_Catalog_Item_Id__c) {

                    ps.Plc_OrderedQty__c = ps.Plc_OrderedQty__c == null ? 
                                           dli.Plc_RequestedQty__c : 
                                           ps.Plc_OrderedQty__c + dli.Plc_RequestedQty__c;
                }
            }
            //Updating ordered quantity on Purchase Order Item
            for (Plc_PurchaseOrderItem__c poi : purchaseOrderItemsList) {
                if (dli.Plc_PurchaseOrder__c == poi.Plc_PurchaseOrder__c && 
                    dli.Plc_Product__c == poi.Plc_Model__c) {

                    poi.Plc_OrderedQty__c = poi.Plc_OrderedQty__c == null ? 
                                            dli.Plc_RequestedQty__c : 
                                            poi.Plc_OrderedQty__c + dli.Plc_RequestedQty__c;
                }
            }
        }

        if (!productStocksList.isEmpty()) {
            update productStocksList;
        }

        if (!purchaseOrderItemsList.isEmpty()) {
            update purchaseOrderItemsList;
        }
    }
}