/**
    * @Giampaolo Mei
    * @date 12/02/2019
    * @description Controller componente lightning Plc_GoodsHandlingEditStock
 */

public with sharing class Plc_GoodsHandlingEditStockCnt {
    /**
    * @Giampaolo Mei
    * @date 30/01/2019
    * @description Initialize lightning component
    * @Param DealerId context record (Dealer Id)
    * @Return Map<String, Object> containing wrapper data to initialize lightning component
    */
    @AuraEnabled
    public static Map<String, Object> initComponent(String stockOrderId){
        System.debug('Plc_GoodsHandlingCnt initComponent start');
        System.debug('Plc_GoodsHandlingCnt stockOrderId: '+stockOrderId);
        Map<String, Object> result = new Map<String, Object>();

        /*
        //recupero lo stock order e il configuration
        List<Bit2Shop__StockOrder__c> stockOrderToUpdate = [SELECT Id, Bit2Shop__Status__c, Bit2Shop__Destination_Warehouse_Id__c, Bit2Shop__Warehouse_Id__c, Bit2Shop__Transfer_Type__c, Plc_TransferDetail__c, Bit2Shop__Point_Of_Sales_Id__c, Bit2Shop__Holding_Id__c, Bit2Shop__Destination_Point_Of_Sales_Id__c, OwnerId, RecordtypeId, Bit2Shop__Note__c, (SELECT Id FROM Bit2Shop__Configurations__r LIMIT 1) FROM Bit2Shop__StockOrder__c WHERE Id =: stockOrderId];
        result.put('stockOrder', stockOrderToUpdate.get(0));
        //result.put('configuration', stockOrderToUpdate.get(0).Bit2Shop__Configurations__r[0]);

        //recupero i configuration Item e gli shipment
        List<NE__OrderItem__c> configurationItemToUpdate = [SELECT Id, NE__Qty__c, Bit2Shop__Required_Serial__c, (SELECT Id, Bit2Shop__Shipped_Quantity__c FROM Bit2Shop__ShipmentOrders__r LIMIT 2) FROM NE__OrderItem__c WHERE NE__OrderId__c =: result.get('configuration').Id];
        */

        //recupero il dealer per l'header del wizard, il filtro sulla causale e il warehouse di origine
        Bit2Shop__StockOrder__c stockOrderToUpdate = [SELECT Plc_TransferDetail__r.Bit2Shop__Code__c, Plc_TransferDetail__r.Name, Plc_TransferDetail__r.Plc_FilterSerialStatus__c, Bit2Shop__Warehouse_Id__c, Bit2Shop__Point_Of_Sales_Id__r.Name, Bit2Shop__Warehouse_Id__r.Name, Bit2Shop__Destination_Warehouse_Id__r.Name, Bit2Shop__Destination_Point_Of_Sales_Id__r.Name FROM Bit2Shop__StockOrder__c WHERE Id =: stockOrderId];
        result.put('dealer', stockOrderToUpdate.Bit2Shop__Point_Of_Sales_Id__r.Name);
        result.put('transferFilter', stockOrderToUpdate.Plc_TransferDetail__r.Plc_FilterSerialStatus__c);
        result.put('originWarehouse', stockOrderToUpdate.Bit2Shop__Warehouse_Id__c);

        result.put('transferFilterHeader', stockOrderToUpdate.Plc_TransferDetail__r.Bit2Shop__Code__c);
        result.put('originTransferFilterHeader', stockOrderToUpdate.Plc_TransferDetail__r.Name);
        result.put('originWarehouseHeader', stockOrderToUpdate.Bit2Shop__Warehouse_Id__r.Name);
        result.put('destinationDealerHeader', stockOrderToUpdate.Bit2Shop__Destination_Point_Of_Sales_Id__r.Name);
        result.put('destinationWarehouseHeader', stockOrderToUpdate.Bit2Shop__Destination_Warehouse_Id__r.Name);

        //recupero gli shipment e gli SLI
        List<Bit2Shop__Shipment__c> shipments = [SELECT Id, RecordTypeId, Bit2Shop__Shipped_Quantity__c, Bit2Shop__Stock_Order_Id__c, Bit2Shop__Sub_Type__c, Bit2Shop__Type__c, Bit2Shop__Configuration_Item_Id__c, Bit2Shop__Shipment_Document_Number__c, Bit2Shop__Date__c, OwnerId, (SELECT Id, RecordTypeId, Bit2Shop__Type__c, Bit2Shop__Requested_Quantity__c, Bit2Shop__Shipment_Id__c, Bit2Shop__Product_Stock_Id__c, Plc_StockSerial__c FROM Bit2Shop__Shipment_Line_Items__r) FROM Bit2Shop__Shipment__c WHERE Bit2Shop__Stock_Order_Id__c =: stockOrderId];

        //recupero i prodotti a quantità e quelli a seriale
        Set<Id> quantityProductId = new Set<Id>();
        Set<Id> serialProductId = new Set<Id>();
        Map<Id, Decimal> mapIdProductQuantityToRequestedQuantity = new Map<Id, Decimal>();
        for(Bit2Shop__Shipment__c sh : shipments){
            if(sh.Bit2Shop__Shipment_Line_Items__r.size() == 1 && sh.Bit2Shop__Sub_Type__c == Plc_Constants.B2S_Shipment.B2S_Subtype_Outbound){
                quantityProductId.add(sh.Bit2Shop__Shipment_Line_Items__r[0].Bit2Shop__Product_Stock_Id__c);
                mapIdProductQuantityToRequestedQuantity.put(sh.Bit2Shop__Shipment_Line_Items__r[0].Bit2Shop__Product_Stock_Id__c, sh.Bit2Shop__Shipment_Line_Items__r[0].Bit2Shop__Requested_Quantity__c);
            }else{
                if(sh.Bit2Shop__Shipment_Line_Items__r.size() > 1 && sh.Bit2Shop__Sub_Type__c == Plc_Constants.B2S_Shipment.B2S_Subtype_Outbound){
                    for(Bit2Shop__Shipment_Line_Item__c sli : sh.Bit2Shop__Shipment_Line_Items__r){
                        if(sli.Bit2Shop__Type__c == Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Serial){
                            serialProductId.add(sli.Plc_StockSerial__c);
                        }
                    }
                }
            }
        }
        List<Bit2Shop__Product_Stock__c> productQuantity = [SELECT Id, Plc_ProductSku__c,Plc_Manufacturer__c, Bit2Shop__Product_Description__c, Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c, Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c, Plc_AvailableQty__c,Bit2Shop__Warehouse_Id__c,Plc_Required_Serial__c,Bit2Shop__Shipped_Qty__c FROM Bit2Shop__Product_Stock__c WHERE Id IN: quantityProductId];
        //setto la quantità selezionata per mostrarla a wizard
        for(Bit2Shop__Product_Stock__c pS : productQuantity){
            pS.Bit2Shop__Shipped_Qty__c = mapIdProductQuantityToRequestedQuantity.get(pS.Id);
        }
        result.put('productQuantity', productQuantity);

        List<Bit2Shop__Stock_Serials2__c> productSerial = [SELECT Plc_ProductSKU__c,Plc_Manufacturer__c, Bit2Shop__Status__c,Plc_DllSerialNumber__c,Plc_Model__c, Bit2Shop__Product_Stock_Id__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c, Bit2Shop__Shipment_Line_Item_Id__r.Bit2Shop__Status__c,Bit2Shop__Shipment_Line_Item_Id__r.Bit2Shop__Received_Status__c, Bit2Shop__Shipment_Line_Item_Id__r.Bit2Shop__Shipment_Status__c, Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c,Bit2Shop__Warehouse_Id__c,Plc_WithdrawnBy__c FROM Bit2Shop__Stock_Serials2__c WHERE Id IN: serialProductId];
        result.put('productSerial', productSerial);
        return result;
    }

    /**
    * @Giampaolo Mei
    * @date 13/02/2019
    * @description update Stock order and objects related
    * @Param transferDetail Status of serial product
    * @Param originWarehouse warehouse of product
    * @Param destinationWarehouse warehouse of product
    * @Return Map<String, Object> Serial and quantity type products retrieved
    */
    @AuraEnabled
    public static Id save(List<Bit2Shop__Stock_Serials2__c> selectedProductSerial, List<Bit2Shop__Product_Stock__c> selectedProductQuantity, Id StockOrderId) {
        System.debug('Plc_GoodsHandlingCnt save start');
        System.debug('Plc_GoodsHandlingCnt selectedProductSerial: ' + selectedProductSerial);
        System.debug('Plc_GoodsHandlingCnt selectedProductQuantity: ' + selectedProductQuantity);
        System.debug('Plc_GoodsHandlingCnt StockOrderId: ' + StockOrderId);

        //recupero lo stock order
        Bit2Shop__StockOrder__c stockOrder = [SELECT Id, Plc_TransferDetail__c,Bit2Shop__Destination_Warehouse_Id__c, Bit2Shop__Holding_Id__c, OwnerId FROM Bit2Shop__StockOrder__c WHERE Id =: StockOrderId];
        //recupero il configuration
        NE__Order__c configuration = [SELECT Id FROM NE__Order__c WHERE Bit2Shop__StockOrder__c =: StockOrderId].get(0);
        //recupero i configuration Items
        List<NE__OrderItem__c> configurationItems = [SELECT Id FROM NE__OrderItem__c WHERE NE__OrderId__c =: configuration.Id];
        //recupero gli shipment
        Map<Id, Bit2Shop__Shipment__c> shipments = new Map<Id, Bit2Shop__Shipment__c>([SELECT Id FROM Bit2Shop__Shipment__c WHERE Bit2Shop__Stock_Order_Id__c =: StockOrderId]);
        List<Bit2Shop__Shipment__c> shipmentsToDelete = shipments.values();
        //recupero tutti gli SLI
        List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItems = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c WHERE Bit2Shop__Shipment_Id__c IN: shipments.keySet()];
        //Elimino la struttura esistente
        delete shipmentLineItems;
        delete shipmentsToDelete;
        delete configurationItems;

        //ricreo la struttura da configuration item in giu per i prodotti a seriale
        Plc_Utils.shipmentsUtils.createProductSerialStructure(selectedProductSerial, configuration, stockOrder,false);

        //ricreo la struttura da configuration item in giu per i prodotti a quantità
        Plc_Utils.shipmentsUtils.createProductQuantityStructure(selectedProductQuantity,configuration, stockOrder,false);
        return stockOrder.id;
    }
}