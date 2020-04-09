/**
 * *************************************************
 *     * @Author marco.lebellini@/webresults.it
 *     * @date  31/01/2019 17:26
 *     * @description Wizard Controller for Plc_GoodsReceiving Aura Component
 *     * @Modified by
 *   ***********************************************
 **/
public without sharing class Plc_GoodsReceivingCnt {


    public class goodWrapper {

        @AuraEnabled
        public String sliId { get; set; }

        @AuraEnabled
        public String goodId { get; set; }

        @AuraEnabled
        public String productSKU { get; set; }

        @AuraEnabled
        public String model { get; set; }

        @AuraEnabled
        public String manufacturer { get; set; }

        @AuraEnabled
        public String catalogName { get; set; }

        @AuraEnabled
        public String encodedSerialNumber { get; set; }

        @AuraEnabled
        public String manufacturerSerialNumber { get; set; }

        @AuraEnabled
        public String dllSerialNumber { get; set; }

        @AuraEnabled
        public String status { get; set; }

        @AuraEnabled
        public String selectedQuantity { get; set; }

        @AuraEnabled
        public String requestedQuantity { get; set; }

        @AuraEnabled
        public String availableQuantity { get; set; }

        @AuraEnabled
        public String acceptedQuantity { get; set; }

        @AuraEnabled
        public String rejectedQuantity { get; set; }

        @AuraEnabled
        public Boolean locked { get; set; }

        @AuraEnabled
        public Boolean closed { get; set; }

        public goodWrapper(String sliId, String goodId, String status, String productSKU, String model, String catalogName, String manufacturer, String encodedSerialNumber, String manufacturerSerialNumber, String dllSerialNumber, String requestedQuantity, String availableQuantity, String acceptedQuantity, String rejectedQuantity, String selectedQuantity, Boolean closed) {
            this.sliId = sliId;
            this.goodId = goodId;
            this.status = status;
            this.productSKU = productSKU;
            this.model = model;
            this.catalogName = catalogName;
            this.manufacturer = manufacturer;
            this.encodedSerialNumber = encodedSerialNumber;
            this.manufacturerSerialNumber = manufacturerSerialNumber;
            this.dllSerialNumber = dllSerialNumber;
            this.locked = String.isBlank(availableQuantity) || availableQuantity == '0';
            this.requestedQuantity = requestedQuantity;
            this.availableQuantity = availableQuantity;
            this.acceptedQuantity = acceptedQuantity;
            this.rejectedQuantity = rejectedQuantity;
            this.selectedQuantity = locked ? '0' : selectedQuantity;
            this.closed = closed;
        }
    }
    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  05/02/2019 13:44
     *     * @description feed SLI Data on Wrapper
     *     * @Modified by
     *   ***********************************************
Integer requestedQuantity, Integer availableQuantity, Integer acceptedQuantity, Integer rejectedQuantity,
     **/
    private static goodWrapper feedWrapper(Bit2Shop__Shipment_Line_Item__c sli, String itemType) {

        try {

            Integer requestedQt = sli.Bit2Shop__Requested_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Requested_Quantity__c) : 1;
            Integer receivedQt = sli.Bit2Shop__Received_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Received_Quantity__c) : 0;
            Integer notReceivedQt = sli.Plc_NotReceivedQty__c != null ? Integer.valueOf(sli.Plc_NotReceivedQty__c) : 0;
            Integer availableQuantity = requestedQt - receivedQt - notReceivedQt;

            if (itemType == Plc_Constants.GoodsManagement.PlcGoodAvailable) {
                receivedQt = 0;
                notReceivedQt = 0;
            } else if (itemType == Plc_Constants.GoodsManagement.PlcGoodAccepted) {
                availableQuantity = 0;
                notReceivedQt = 0;
            } else if (itemType == Plc_Constants.GoodsManagement.PlcGoodRejected) {
                receivedQt = 0;
                availableQuantity = 0;
            }

            System.debug(' ######## Goods Receiving APEX Controller --> requestedQt ' + requestedQt);
            System.debug(' ######## Goods Receiving APEX Controller --> receivedQt ' + receivedQt);
            System.debug(' ######## Goods Receiving APEX Controller --> notReceivedQt ' + notReceivedQt);

            if (sli.RecordType.DeveloperName == Plc_Constants.B2S_ShipmentLineItem.RecordType_Serial) {
                return new goodWrapper(sli.Id,
                        sli.Plc_StockSerial__c,
                        sli.Bit2Shop__Status__c,
                        sli.Plc_StockSerial__r.Plc_ProductSku__c,
                        sli.Plc_StockSerial__r.Plc_Model__c,
                        sli.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                        sli.Plc_StockSerial__r.Plc_Manufacturer__c,
                        sli.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                        sli.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                        sli.Plc_StockSerial__r.Plc_DllSerialNumber__c,
                        String.valueOf(requestedQt),
                        String.valueOf(availableQuantity),
                        String.valueOf(receivedQt),
                        String.valueOf(notReceivedQt),
                        '1',
                        sli.Bit2Shop__Status__c == Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Closed);
            } else if (sli.RecordType.DeveloperName == Plc_Constants.B2S_ShipmentLineItem.RecordType_Product) {
                return new goodWrapper(sli.Id,
                        sli.Bit2Shop__Product_Stock_Id__c,
                        sli.Bit2Shop__Status__c,
                        '',
                        sli.Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c,
                        sli.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                        sli.Bit2Shop__Product_Stock_Id__r.Plc_Manufacturer__c,
                        '',
                        '',
                        '',
                        String.valueOf(requestedQt),
                        String.valueOf(availableQuantity),
                        String.valueOf(receivedQt),
                        String.valueOf(notReceivedQt),
                        '0',
                        sli.Bit2Shop__Status__c == Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Closed);
            }
        } catch (Exception error) {

            String errorMessage = 'Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }

        return null;
    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  02/02/2019 12:08
     *     * @description
     *     * @Modified by
     *   ***********************************************
     **/
    @AuraEnabled
    public static Object initData(String objectId) {

        try {
            Map<String, Object> result = new Map<String, Object>();

            String inboundShipmentRTId = Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_ShipmentLineItem.RecordType_InboundShipments).getRecordTypeId();

            Id sourceId = objectId;
            String shipmentId;
            String stockOrderId;
            //FB 22-08-2019: NEXIPLC-673 [START]
            Boolean isFromWorkOrder = false;
            //FB 22-08-2019: NEXIPLC-673 [END]

            if (sourceId.getSobjectType() == Schema.Bit2Shop__StockOrder__c.SObjectType) {
                stockOrderId = objectId;
            } else if (sourceId.getSobjectType() == Schema.Bit2Shop__Shipment__c.SObjectType) {
                shipmentId = objectId;
            }

            List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItems = new List<Bit2Shop__Shipment_Line_Item__c>();

            if (String.isNotBlank(stockOrderId)) {
                shipmentLineItems = [
                        SELECT Id, RecordTypeId, RecordType.DeveloperName,Bit2Shop__Shipment_Id__r.Name,
                                Bit2Shop__Target_Line_Item__c,Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Name,
                                Bit2Shop__Requested_Quantity__c, Bit2Shop__Received_Quantity__c,
                                Plc_NotReceivedQty__c, Plc_StockSerial__r.Plc_ProductSku__c, 
                                Plc_StockSerial__r.Plc_Model__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                                Plc_StockSerial__r.Plc_Manufacturer__c, Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c, Plc_StockSerial__r.Plc_DllSerialNumber__c,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Name,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__c,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Name,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__c,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Name,
                                Plc_StockSerial__c, Bit2Shop__Product_Stock_Id__c, Bit2Shop__Status__c,
                                /** [START MOD 05/03/2019 17:26]@Author:nunzio.capasso@/webresults.it @Description:  hide "no data found" popup when process is in read-only mode**/
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Status__c
                                 /** [END MOD 05/03/2019 17:26]@Author:nunzio.capasso@/webresults.it @Description:  hide "no data found" popup when process is in read-only mode**/
                        FROM Bit2Shop__Shipment_Line_Item__c
                        WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c = :stockOrderId
                        AND Bit2Shop__Shipment_Id__r.RecordTypeId = :inboundShipmentRTId
                ];

                //FB 22-08-2019: NEXIPLC-673 [START]
                Bit2Shop__StockOrder__c stockOrder = [SELECT id, Plc_WorkOrder__c 
                                                      FROM Bit2Shop__StockOrder__c 
                                                      WHERE Id = :stockOrderId LIMIT 1];
                isFromWorkOrder = String.isNotBlank(stockOrder.Plc_WorkOrder__c);
                //FB 22-08-2019: NEXIPLC-673 [END]

            } else if (String.isNotBlank(shipmentId)) {
                shipmentLineItems = [
                        SELECT Id, RecordTypeId, RecordType.DeveloperName,Bit2Shop__Shipment_Id__r.Name,
                                Bit2Shop__Target_Line_Item__c,Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Name,
                                Bit2Shop__Requested_Quantity__c, Bit2Shop__Received_Quantity__c,
                                Plc_NotReceivedQty__c, Plc_StockSerial__r.Plc_ProductSku__c, 
                                Plc_StockSerial__r.Plc_Model__c, Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                                Plc_StockSerial__r.Plc_Manufacturer__c, Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c, Plc_StockSerial__r.Plc_DllSerialNumber__c,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Name,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__c,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Name,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__c,
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Name,
                                Plc_StockSerial__c, Bit2Shop__Product_Stock_Id__c, Bit2Shop__Status__c,
                                /** [START MOD 05/03/2019 17:26]@Author:nunzio.capasso@/webresults.it @Description:  hide "no data found" popup when process is in read-only mode**/
                                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Status__c
                                /** [END MOD 05/03/2019 17:26]@Author:nunzio.capasso@/webresults.it @Description:  hide "no data found" popup when process is in read-only mode**/
                        FROM Bit2Shop__Shipment_Line_Item__c
                        WHERE Bit2Shop__Shipment_Id__c = :shipmentId
                        AND Bit2Shop__Shipment_Id__r.RecordTypeId = :inboundShipmentRTId
                ];

                //FB 22-08-2019: NEXIPLC-673 [START]
                Bit2Shop__Shipment__c shipment = [SELECT id, Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__c 
                                                  FROM Bit2Shop__Shipment__c 
                                                  WHERE Id = :shipmentId 
                                                  LIMIT 1];
                isFromWorkOrder = String.isNotBlank(shipment.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__c);
                //FB 22-08-2019: NEXIPLC-673 [END]
            }

            String wizTitle = System.Label.Plc_GoodsReceiving;

            if (String.isNotBlank(stockOrderId)) {
                wizTitle += ' - ' + System.Label.Plc_StockOrder + ' : ' + shipmentLineItems[0].Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Name;
            } else {
                wizTitle += ' - ' + System.Label.Plc_Shipment + ' : ' + shipmentLineItems[0].Bit2Shop__Shipment_Id__r.Name;
            }

            List<String> idsList = new List<String>();

            String queryFilterForStockSerials = 'Id IN (';
            String queryFilterForProductStocks = 'Id IN (';

            Integer serialsQueryInitialLength = queryFilterForStockSerials.length();
            Integer productsQueryInitialLength = queryFilterForProductStocks.length();

            Set<String> productSliIdsSet = new Set<String>();

            List<Bit2Shop__Shipment_Line_Item__c> sliStockSerials = new List<Bit2Shop__Shipment_Line_Item__c>();
            List<Bit2Shop__Shipment_Line_Item__c> sliProductStocks = new List<Bit2Shop__Shipment_Line_Item__c>();

            for (Bit2Shop__Shipment_Line_Item__c sli : shipmentLineItems) {

                if (sli.RecordType.DeveloperName == Plc_Constants.B2S_ShipmentLineItem.RecordType_Serial
                        && String.isNotBlank(sli.Plc_StockSerial__c)
                        ) {
                    sliStockSerials.add(sli);
                    productSliIdsSet.add(sli.Bit2Shop__Target_Line_Item__c);
                    queryFilterForStockSerials += '\'' + sli.Id + '\',';
                }
                idsList.add(sli.id);
            }

            for (Bit2Shop__Shipment_Line_Item__c sli : shipmentLineItems) {

                if (!productSliIdsSet.contains(sli.Id)
                        && sli.RecordType.DeveloperName == Plc_Constants.B2S_ShipmentLineItem.RecordType_Product
                        && String.isNotBlank(sli.Bit2Shop__Product_Stock_Id__c)
                        ) {
                    sliProductStocks.add(sli);
                    queryFilterForProductStocks += '\'' + sli.Id + '\',';
                }
                idsList.add(sli.id);
            }

            result.put('sliStockSerials', sliStockSerials);
            result.put('sliProductStocks', sliProductStocks);

            if (queryFilterForStockSerials.length() > serialsQueryInitialLength) {
                queryFilterForStockSerials = queryFilterForStockSerials.removeEnd(',') + ')';
            } else {
                queryFilterForStockSerials = '';
            }

            if (queryFilterForProductStocks.length() > productsQueryInitialLength) {
                queryFilterForProductStocks = queryFilterForProductStocks.removeEnd(',') + ')';
            } else {
                queryFilterForProductStocks = '';
            }

            /** [START MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/
            result.put('stockOrderStatus', shipmentLineItems[0].Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Status__c);
            /** [END MOD 05/03/2019 17:20]@Author:nunzio.capasso@/webresults.it @Description: hide "no data found" popup when process is in read-only mode **/

            result.put('sourceWH', shipmentLineItems[0].Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Name);
            result.put('sourceDealer', shipmentLineItems[0].Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Name);
            result.put('transferDetail', shipmentLineItems[0].Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Name);
            result.put('sourceShipment', shipmentLineItems[0].Bit2Shop__Shipment_Id__r.Name);

            result.put('idsList', idsList);
            result.put('queryFilterForStockSerials', queryFilterForStockSerials);
            result.put('queryFilterForProductStocks', queryFilterForProductStocks);
            result.put('wizardTitle', wizTitle);

            System.debug('idsList > ' + idsList);
            System.debug('queryFilterForStockSerials > ' + queryFilterForStockSerials);
            System.debug('queryFilterForProductStocks > ' + queryFilterForProductStocks);
            //System.debug('dataGridsColumns > ' + Plc_WizardsConstants.GOODSRECEIVING_WIZ_GRIDSCOLUMNS);

            System.debug('Apex Controller - Init Data -- Result --> ' + result);

            //FB 22-08-2019: NEXIPLC-673 [START]
            System.debug('### isFromWorkOrder: ' + isFromWorkOrder);
            result.put('Plc_GoodsRecevingAcceptAll', !isFromWorkOrder && FeatureManagement.checkPermission(Plc_Constants.customPermission.PlcGoodsReceivingEnhanced));
            //FB 22-08-2019: NEXIPLC-673 [END]

            return result;

        } catch (Exception error) {
            String errorMessage = 'Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }

        return null;
    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  04/02/2019 18:37
     *     * @description fetch data retrieved from the filter query result to feed Wizard Goods Management Tables
     *     * @Modified by
     *   ***********************************************
     **/
    @AuraEnabled
    public static Object fetchDataForTables(String shipmentStockSerials,
            String shipmentProductStocks,
            String availableGoodsFromWizard,
            String acceptedGoodsFromWizard,
            String rejectedGoodsFromWizard) {

        try {

            System.debug('GoodsReceivingCnt --> fetchDataForTables Invoked');

            System.debug('shipmentStockSerials > ' + shipmentStockSerials);
            System.debug('shipmentProductStocks > ' + shipmentProductStocks);
            System.debug('availableGoodsFromWizard > ' + availableGoodsFromWizard);
            System.debug('acceptedGoodsFromWizard > ' + acceptedGoodsFromWizard);
            System.debug('rejectedGoodsFromWizard > ' + rejectedGoodsFromWizard);

            Map<String, Object> result = new Map<String, Object>();

            List<Bit2Shop__Shipment_Line_Item__c> sliStockSerials = new List<Bit2Shop__Shipment_Line_Item__c>();
            List<Bit2Shop__Shipment_Line_Item__c> sliProductStocks = new List<Bit2Shop__Shipment_Line_Item__c>();

            List<goodWrapper> availableGoods = new List<goodWrapper>();
            List<goodWrapper> wizardAvailableGoods = new List<goodWrapper>();

            List<goodWrapper> acceptedGoods = new List<goodWrapper>();
            List<goodWrapper> wizardAcceptedGoods = new List<goodWrapper>();

            List<goodWrapper> rejectedGoods = new List<goodWrapper>();
            List<goodWrapper> wizardRejectedGoods = new List<goodWrapper>();

            Map<String, goodWrapper> availableGoodsMapFromDB = new Map<String, goodWrapper>();

            Map<String, goodWrapper> wizardAvailableGoodsMap = new Map<String, goodWrapper>();
            Map<String, goodWrapper> wizardAcceptedGoodsMap = new Map<String, goodWrapper>();
            Map<String, goodWrapper> wizardRejectedGoodsMap = new Map<String, goodWrapper>();

            if (String.isNotBlank(shipmentStockSerials)) {
                sliStockSerials = (List<Bit2Shop__Shipment_Line_Item__c>) JSON.deserialize(shipmentStockSerials, List<Bit2Shop__Shipment_Line_Item__c>.class);
            }

            if (String.isNotBlank(shipmentProductStocks)) {
                sliProductStocks = (List<Bit2Shop__Shipment_Line_Item__c>) JSON.deserialize(shipmentProductStocks, List<Bit2Shop__Shipment_Line_Item__c>.class);
            }

            if (String.isNotBlank(availableGoodsFromWizard)) {
                wizardAvailableGoods = (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(availableGoodsFromWizard, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

                for (goodWrapper availableGood : wizardAvailableGoods) {
                    wizardAvailableGoodsMap.put(availableGood.sliId, availableGood);
                }
            }

            if (String.isNotBlank(acceptedGoodsFromWizard)) {
                wizardAcceptedGoods = (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(acceptedGoodsFromWizard, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

                for (goodWrapper acceptedGood : wizardAcceptedGoods) {
                    wizardAcceptedGoodsMap.put(acceptedGood.sliId, acceptedGood);
                }
            }

            if (String.isNotBlank(rejectedGoodsFromWizard)) {
                wizardRejectedGoods = (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(rejectedGoodsFromWizard, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

                for (goodWrapper rejectedGood : wizardRejectedGoods) {
                    wizardRejectedGoodsMap.put(rejectedGood.sliId, rejectedGood);
                }
            }

            Integer receivedQt, notReceivedQt, requestedQt, availableQt;

            for (Bit2Shop__Shipment_Line_Item__c sli : sliStockSerials) {

                requestedQt = sli.Bit2Shop__Requested_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Requested_Quantity__c) : 1;
                receivedQt = sli.Bit2Shop__Received_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Received_Quantity__c) : 0;
                notReceivedQt = sli.Plc_NotReceivedQty__c != null ? Integer.valueOf(sli.Plc_NotReceivedQty__c) : 0;
                availableQt = requestedQt - receivedQt - notReceivedQt;


                if (availableQt > 0) {

                    System.debug('Serial SLI Put on available --> ' + sli);
                    availableGoods.add(feedWrapper(sli, Plc_Constants.GoodsManagement.PlcGoodAvailable));
                }

                if (receivedQt > 0) {
                    System.debug('Serial SLI Put on accepted --> ' + sli);
                    acceptedGoods.add(feedWrapper(sli, Plc_Constants.GoodsManagement.PlcGoodAccepted));
                }

                if (notReceivedQt > 0) {
                    System.debug('Serial SLI Put on rejected --> ' + sli);
                    rejectedGoods.add(feedWrapper(sli, Plc_Constants.GoodsManagement.PlcGoodRejected));
                }

                //old logic to remove
                /*if (sli.Bit2Shop__Status__c == Plc_WizardsConstants.PLC_SLI_STATUS_CLOSED
                        || (requestedQt == receivedQt + notReceivedQt)) {

                    if (sli.Bit2Shop__Received_Status__c == Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_RECEIVED) {

                        acceptedGoods.add(feedWrapper(sli, true));
                    } else if (sli.Bit2Shop__Received_Status__c == Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_NOTRECEIVED) {

                        rejectedGoods.add(feedWrapper(sli, true));
                    }
                } else if (sli.Bit2Shop__Status__c != Plc_WizardsConstants.PLC_SLI_STATUS_CLOSED) {

                    availableGoods.add(feedWrapper(sli, false));
                }

                if (sli.Bit2Shop__Status__c == Plc_WizardsConstants.PLC_SLI_STATUS_CLOSED
                        || (requestedQt == receivedQt + notReceivedQt)) {

                    if (sli.Bit2Shop__Received_Status__c == Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_RECEIVED) {

                        acceptedGoods.add(feedWrapper(sli, true));
                    } else if (sli.Bit2Shop__Received_Status__c == Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_NOTRECEIVED) {

                        rejectedGoods.add(feedWrapper(sli, true));
                    }
                } else if (sli.Bit2Shop__Status__c != Plc_WizardsConstants.PLC_SLI_STATUS_CLOSED) {

                    availableGoods.add(feedWrapper(sli, false));
                }*/

            }

            for (Bit2Shop__Shipment_Line_Item__c sli : sliProductStocks) {


                requestedQt = sli.Bit2Shop__Requested_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Requested_Quantity__c) : 1;
                receivedQt = sli.Bit2Shop__Received_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Received_Quantity__c) : 0;
                notReceivedQt = sli.Plc_NotReceivedQty__c != null ? Integer.valueOf(sli.Plc_NotReceivedQty__c) : 0;
                availableQt = requestedQt - receivedQt - notReceivedQt;

                if (availableQt > 0) {
                    System.debug('Product SLI Put on available --> ' + sli);
                    availableGoods.add(feedWrapper(sli, Plc_Constants.GoodsManagement.PlcGoodAvailable));
                }

                if (receivedQt > 0) {
                    System.debug('Product SLI Put on accepted --> ' + sli);
                    acceptedGoods.add(feedWrapper(sli,Plc_Constants.GoodsManagement.PlcGoodAccepted));
                }

                if (notReceivedQt > 0) {
                    System.debug('Product SLI Put on rejected --> ' + sli);
                    rejectedGoods.add(feedWrapper(sli, Plc_Constants.GoodsManagement.PlcGoodRejected));
                }

                //old logic to remove
                /*if (sli.Bit2Shop__Received_Quantity__c != null && sli.Bit2Shop__Received_Quantity__c > 0) {
                    acceptedGoods.add(feedWrapper(sli, true));
                }

                if (sli.Plc_NotReceivedQty__c != null && sli.Plc_NotReceivedQty__c > 0) {
                    rejectedGoods.add(feedWrapper(sli, true));
                }
                if (sli.Bit2Shop__Status__c != Plc_WizardsConstants.PLC_SLI_STATUS_CLOSED) {
                    availableGoods.add(feedWrapper(sli, false));
                }*/

            }

            for (goodWrapper availableGood : availableGoods) {
                availableGoodsMapFromDB.put(availableGood.sliId, availableGood);
            }


            goodWrapper availableGood;
            for (String sliId : availableGoodsMapFromDB.keySet()) {

                availableGood = availableGoodsMapFromDB.get(sliId);
                if (wizardAvailableGoodsMap.containsKey(sliId)) {
                    System.debug('available good found on wizard available list > ' + wizardAvailableGoodsMap.get(sliId));
                    availableGoodsMapFromDB.put(sliId, wizardAvailableGoodsMap.get(sliId));
                } else if (wizardAcceptedGoodsMap.containsKey(sliId) || wizardRejectedGoodsMap.containsKey(sliId)) {
                    System.debug('available good found on wizard accepted / rejected list > ' + availableGoodsMapFromDB.get(sliId));
                    availableGoodsMapFromDB.remove(sliId);
                }
            }

            result.put('availableGoods', availableGoodsMapFromDB.values());
            result.put('acceptedGoods', acceptedGoods);
            result.put('rejectedGoods', rejectedGoods);

            System.debug('availableGoods > ' + availableGoods);
            System.debug('acceptedGoods > ' + acceptedGoods);
            System.debug('rejectedGoods > ' + rejectedGoods);

            return result;

        } catch (Exception error) {
            String errorMessage = 'Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }

        return null;
    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  17/02/2019 08:10
     *     * @description Save On Db Accepted and Rejected Goods from Wizard
     *     * @Modified by
     *   ***********************************************
     **/
    @AuraEnabled
    public static object saveGoods(String serializedAvailableGoods, String serializedAcceptedGoods, String serializedRejectedGoods, String sourceRecordId) {

        System.debug('GoodsReceivingCnt --> saveGoods Invoked');

        Savepoint sp = Database.setSavepoint();
        Map<String, Object> result = new Map<String, Object>();

        try {

            String sourceOrderId;
            String sourceShipmentId;

            Id sourceId = sourceRecordId;

            Bit2Shop__StockOrder__c sourceStockOrder = new Bit2Shop__StockOrder__c();
            List<Bit2Shop__Shipment__c> sourceShipments = new List<Bit2Shop__Shipment__c>();

            String inboundShipmentRTId =
                    Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_ShipmentLineItem.RecordType_InboundShipments).getRecordTypeId();

            if (sourceId.getSobjectType() == Schema.Bit2Shop__StockOrder__c.SObjectType) {

                sourceOrderId = sourceId;
                sourceStockOrder = [
                        SELECT Id
                        FROM Bit2Shop__StockOrder__c
                        WHERE Id = :sourceOrderId
                ];

                sourceShipments = [
                        SELECT Id, RecordTypeId, RecordType.DeveloperName
                        FROM Bit2Shop__Shipment__c
                        WHERE Bit2Shop__Stock_Order_Id__c = :sourceOrderId
                        AND RecordTypeId = :inboundShipmentRTId
                ];

            } else if (sourceId.getSobjectType() == Schema.Bit2Shop__Shipment__c.SObjectType) {

                sourceShipmentId = sourceId;
                sourceShipments = [
                        SELECT Id, Bit2Shop__Stock_Order_Id__c
                        FROM Bit2Shop__Shipment__c
                        WHERE Id = :sourceShipmentId
                        AND RecordTypeId = :inboundShipmentRTId
                ];

                sourceOrderId = sourceShipments[0].Bit2Shop__Stock_Order_Id__c;
                sourceStockOrder = [
                        SELECT Id
                        FROM Bit2Shop__StockOrder__c
                        WHERE Id = :sourceOrderId
                ];
            }

            system.debug('Apex Save Goods --> AvailableGoods --> ' + serializedRejectedGoods);
            system.debug('Apex Save Goods --> AcceptedGoods --> ' + serializedAcceptedGoods);
            system.debug('Apex Save Goods --> RejectedGoods --> ' + serializedRejectedGoods);

            List<Plc_GoodsReceivingCnt.goodWrapper> availableGoods =
                    (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(serializedAvailableGoods, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

            List<Plc_GoodsReceivingCnt.goodWrapper> acceptedGoods =
                    (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(serializedAcceptedGoods, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

            List<Plc_GoodsReceivingCnt.goodWrapper> rejectedGoods =
                    (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(serializedRejectedGoods, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

            List<String> sliIdsList = new List<String>();
            for (goodWrapper good : acceptedGoods) {
                /** [START MOD 2019-06-27]@Author:Luca Belometti @Description: Add a filter to only goods with selected quantity
                is equal 1 **/
                if (good.selectedQuantity == '1') {
                    sliIdsList.add(good.sliId);
                }
               /** [END MOD 2019-06-27]@Author:Luca Belometti @Description: Add a filter to only goods with selected quantity
               is equal 1 */
            }

            for (goodWrapper good : rejectedGoods) {
                //sliIdsList.add(good.sliId);

                /** [START MOD 2019-06-27]@Author:Luca Belometti @Description: Add a filter to only goods with selected quantity
                is equal 1 **/
                if (good.selectedQuantity == '1') {
                    sliIdsList.add(good.sliId);
                }
               /** [END MOD 2019-06-27]@Author:Luca Belometti @Description: Add a filter to only goods with selected quantity
               is equal 1 */
            }


            System.debug('Apex Save Goods --> sliIdsList --> ' + sliIdsList);

            Map<ID, Bit2Shop__Shipment_Line_Item__c> sliToSaveMap =
                    new Map<ID, Bit2Shop__Shipment_Line_Item__c>([
                            SELECT Id,
                                    Bit2Shop__Received_Quantity__c,
                                    Plc_NotReceivedQty__c,
                                    Bit2Shop__Requested_Quantity__c,
                                    Bit2Shop__Target_Line_Item__c,
                                    Bit2Shop__Target_Line_Item__r.Bit2Shop__Received_Quantity__c,
                                    Bit2Shop__Target_Line_Item__r.Plc_NotReceivedQty__c
                            FROM Bit2Shop__Shipment_Line_Item__c
                            WHERE Id IN :sliIdsList
                    ]);

            Integer acceptedQuantity, rejectedQuantity;
            Integer requestedQt, receivedQt, notReceivedQt;
            Integer parentReceivedQt, parentNotReceivedQt;

            String parentSLIId;
            Map<String, Bit2Shop__Shipment_Line_Item__c> parentSliToSaveMap = new Map<String, Bit2Shop__Shipment_Line_Item__c>();

            for (goodWrapper good : acceptedGoods) {
                /** [START MOD 2019-06-27]@Author:Luca Belometti @Description: Add a filter to only goods with selected quantity
                is equal 1 **/
                if (String.isNotBlank(good.selectedQuantity)&& good.selectedQuantity == '1') {
                /** [END MOD 2019-06-27]@Author:Luca Belometti @Description: Add a filter to only goods with selected quantity
                is equal 1 **/

                    requestedQt = sliToSaveMap.get(good.sliId).Bit2Shop__Requested_Quantity__c != null ? Integer.valueOf(sliToSaveMap.get(good.sliId).Bit2Shop__Requested_Quantity__c) : 1;
                    receivedQt = sliToSaveMap.get(good.sliId).Bit2Shop__Received_Quantity__c != null ? Integer.valueOf(sliToSaveMap.get(good.sliId).Bit2Shop__Received_Quantity__c) : 0;

                    acceptedQuantity = receivedQt + Integer.valueOf(good.selectedQuantity);
                    sliToSaveMap.get(good.sliId).Bit2Shop__Received_Quantity__c = acceptedQuantity;

                    parentSLIId = sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__c;
                    if (String.isNotBlank(sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__c)) {

                        if (parentSliToSaveMap.containsKey(parentSLIId)) {
                            parentReceivedQt = parentSliToSaveMap.get(parentSLIId).Bit2Shop__Received_Quantity__c != null ?
                                                Integer.valueOf(parentSliToSaveMap.get(parentSLIId).Bit2Shop__Received_Quantity__c) : 0;
                        } else {
                            parentReceivedQt = sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__r.Bit2Shop__Received_Quantity__c != null ?
                                    Integer.valueOf(sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__r.Bit2Shop__Received_Quantity__c) : 0;
                        }


                        parentReceivedQt += Integer.valueOf(good.selectedQuantity);
                        //sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__r.Bit2Shop__Received_Quantity__c = parentReceivedQt;
                        parentSliToSaveMap.put(parentSLIId, new Bit2Shop__Shipment_Line_Item__c(Id = parentSLIId, Bit2Shop__Received_Quantity__c = parentReceivedQt));
                    }
                }
            }

            for (goodWrapper good : rejectedGoods ) {

                if (String.isNotBlank(good.selectedQuantity)&& good.selectedQuantity == '1') {

                    requestedQt = sliToSaveMap.get(good.sliId).Bit2Shop__Requested_Quantity__c != null ? Integer.valueOf(sliToSaveMap.get(good.sliId).Bit2Shop__Requested_Quantity__c) : 1;
                    notReceivedQt = sliToSaveMap.get(good.sliId).Plc_NotReceivedQty__c != null ? Integer.valueOf(sliToSaveMap.get(good.sliId).Plc_NotReceivedQty__c) : 0;

                    rejectedQuantity = notReceivedQt + Integer.valueOf(good.selectedQuantity);
                    sliToSaveMap.get(good.sliId).Plc_NotReceivedQty__c = rejectedQuantity;

                    parentSLIId = sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__c;
                    if (String.isNotBlank(parentSLIId)) {
                        if (parentSliToSaveMap.containsKey(parentSLIId)) {
                            parentNotReceivedQt = parentSliToSaveMap.get(parentSLIId).Plc_NotReceivedQty__c != null ?
                                    Integer.valueOf(parentSliToSaveMap.get(parentSLIId).Plc_NotReceivedQty__c) : 0;
                        } else {
                            parentNotReceivedQt = sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__r.Plc_NotReceivedQty__c != null ?
                                    Integer.valueOf(sliToSaveMap.get(good.sliId).Bit2Shop__Target_Line_Item__r.Plc_NotReceivedQty__c) : 0;
                        }
                        
                        parentNotReceivedQt += Integer.valueOf(good.selectedQuantity);
                        parentSliToSaveMap.put(parentSLIId, new Bit2Shop__Shipment_Line_Item__c(Id = parentSLIId, Plc_NotReceivedQty__c = parentNotReceivedQt));
                    }
                }
            }

            Boolean closeSLI;

            for (Bit2Shop__Shipment_Line_Item__c sli : sliToSaveMap.values()) {

                requestedQt = sli.Bit2Shop__Requested_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Requested_Quantity__c) : 1;
                receivedQt = sli.Bit2Shop__Received_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Received_Quantity__c) : 0;
                notReceivedQt = sli.Plc_NotReceivedQty__c != null ? Integer.valueOf(sli.Plc_NotReceivedQty__c) : 0;

                closeSLI = requestedQt - receivedQt - notReceivedQt == 0;
                String receivedStatus = closeSLI && (receivedQt > notReceivedQt) ?
                        Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_Received :
                        closeSLI && (receivedQt < notReceivedQt) ? Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_NotReceived :
                                null;

                sli.Bit2Shop__Status__c = closeSLI ? 'Closed' : 'Pending';
                sli.Bit2Shop__Received_Status__c = receivedStatus;
            }

            System.debug('Apex Save Goods --> sliToSaveMap --> ' + sliToSaveMap);
            System.debug('Apex Save Goods --> parentSliToSaveMap --> ' + parentSliToSaveMap);

            System.debug('#### Current time Plc_GoodsReceiving Start : ' + Datetime.now());
            DateTime start = Datetime.now();

            upsert sliToSaveMap.values();
            upsert parentSliToSaveMap.values();
            
            System.debug('#### Current time Plc_GoodsReceiving End : ' + Datetime.now());

            result.put('errorMessage', '');
            return result;

        } catch (Exception error) {

            Database.rollback(sp);
            String errorMessage = 'Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);

            result.put('errorMessage', errorMessage);
            return result;
        }

    }

    /**
     * Checks whether current user has access to the component
     * @param  inputStockOrder Target stock order
     * @return                 An error message if the user has no access
     */
    public static String grantAccess(Bit2Shop__StockOrder__c inputStockOrder) {

        String response = '';

        try {
            //Checks whether current user can skip group check
            Bit2Shop__StockOrder__c stockOrder = [
                    SELECT Id, Bit2Shop__Destination_Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c
                    FROM Bit2Shop__StockOrder__c
                    WHERE Id = :inputStockOrder.Id
                    LIMIT 1
            ];

            //If current user does not belong to the input dealer group then do not grant access
            if (FeatureManagement.checkPermission(Plc_Constants.CustomPermission.PlcConfirmGoodsReceiving) 
                || Plc_Utils.isCurrentUserDealerGroupMember(stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c)) {
                response = null;
            } else {
                response = Label.Plc_ApexClassGoodsReceivingCntForbiddenHandleMessage;
            }

            return response;

        } catch (Exception e) {
            String error = '\n\n@@@@@grantAccess Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, error);
            response = error;
            return response;
        }

    }

    /**
     * Checks whether current user has access to the component (through Shipment)
     * 
     * @param  inputShipment  Target shipment
     * @return                An error message if the user has no access
     */
    public static String grantAccess(Bit2Shop__Shipment__c inputShipment) {

        String response = '';

        try {
            //Checks whether current user can skip group check
            Bit2Shop__Shipment__c shipment = [
                    SELECT Id, Bit2Shop__Stock_Order_Id__c
                    FROM Bit2Shop__Shipment__c
                    WHERE Id = :inputShipment.Id
                    LIMIT 1
            ];

            return grantAccess(new Bit2Shop__StockOrder__c(Id = shipment.Bit2Shop__Stock_Order_Id__c));

        } catch (Exception e) {
            String error = '\n\n@@@@@grantAccess Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, error);
            response = error;
            return response;
        }

    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  07/02/2019 05:32
     *     * @description Save On Db Accepted and Rejected Goods from Wizard
     *     * @Modified by
     *   ***********************************************
     **/
    /*@AuraEnabled
    public static object saveGoods_old(String serializedAvailableGoods, String serializedAcceptedGoods, String serializedRejectedGoods, String sourceRecordId) {

        System.debug('GoodsReceivingCnt --> saveGoods Invoked');

        Savepoint sp = Database.setSavepoint();
        Map<String, Object> result = new Map<String, Object>();

        try {

            String sourceOrderId;
            String sourceShipmentId;

            Id sourceId = sourceRecordId;

            Bit2Shop__StockOrder__c sourceStockOrder = new Bit2Shop__StockOrder__c();
            List<Bit2Shop__Shipment__c> sourceShipments = new List<Bit2Shop__Shipment__c>();

            String inboundShipmentRTId = Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_WizardsConstants.PLC_INBOUND_SHIPMENTS_RT_DEVNAME).getRecordTypeId();

            if (sourceId.getSobjectType() == Schema.Bit2Shop__StockOrder__c.SObjectType) {

                sourceOrderId = sourceId;
                sourceStockOrder = [
                        SELECT Id
                        FROM Bit2Shop__StockOrder__c
                        WHERE Id = :sourceOrderId
                ];

                sourceShipments = [
                        SELECT Id, RecordTypeId, RecordType.DeveloperName
                        FROM Bit2Shop__Shipment__c
                        WHERE Bit2Shop__Stock_Order_Id__c = :sourceOrderId
                        AND RecordTypeId = :inboundShipmentRTId
                ];

            } else if (sourceId.getSobjectType() == Schema.Bit2Shop__Shipment__c.SObjectType) {

                sourceShipmentId = sourceId;
                sourceShipments = [
                        SELECT Id, Bit2Shop__Stock_Order_Id__c
                        FROM Bit2Shop__Shipment__c
                        WHERE Id = :sourceShipmentId
                        AND RecordTypeId = :inboundShipmentRTId
                ];

                sourceOrderId = sourceShipments[0].Bit2Shop__Stock_Order_Id__c;
                sourceStockOrder = [
                        SELECT Id
                        FROM Bit2Shop__StockOrder__c
                        WHERE Id = :sourceOrderId
                ];
            }

            system.debug('Apex Save Goods --> AvailableGoods --> ' + serializedRejectedGoods);
            system.debug('Apex Save Goods --> AcceptedGoods --> ' + serializedAcceptedGoods);
            system.debug('Apex Save Goods --> RejectedGoods --> ' + serializedRejectedGoods);

            List<Plc_GoodsReceivingCnt.goodWrapper> availableGoods =
                    (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(serializedAvailableGoods, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

            List<Plc_GoodsReceivingCnt.goodWrapper> acceptedGoods =
                    (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(serializedAcceptedGoods, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

            List<Plc_GoodsReceivingCnt.goodWrapper> rejectedGoods =
                    (List<Plc_GoodsReceivingCnt.goodWrapper>) JSON.deserialize(serializedRejectedGoods, List<Plc_GoodsReceivingCnt.goodWrapper>.class);

            Map<Id, Bit2Shop__Shipment_Line_Item__c> sliMapToSave = new Map<Id, Bit2Shop__Shipment_Line_Item__c>();

            for (goodWrapper good : acceptedGoods) {

                Boolean closeSLI = (Integer.valueOf(good.acceptedQuantity) + Integer.valueOf(good.rejectedQuantity)) == Integer.valueOf(good.requestedQuantity)
                        || Integer.valueOf(good.availableQuantity) == 0;

                Boolean receiveSLI = Integer.valueOf(good.acceptedQuantity) > Integer.valueOf(good.rejectedQuantity);

                sliMapToSave.put(good.sliId, new Bit2Shop__Shipment_Line_Item__c(Id = good.sliId,
                        Bit2Shop__Status__c = closeSLI ? 'Closed' : 'Pending',
                        Bit2Shop__Received_Status__c = receiveSLI ?
                                Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_RECEIVED :
                                Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_NOTRECEIVED,
                        Bit2Shop__Received_Quantity__c = Integer.valueOf(good.acceptedQuantity),
                        Plc_NotReceivedQty__c = Integer.valueOf(good.rejectedQuantity))
                );
            }

            for (goodWrapper good : rejectedGoods) {

                Boolean closeSLI = (Integer.valueOf(good.acceptedQuantity) + Integer.valueOf(good.rejectedQuantity)) == Integer.valueOf(good.requestedQuantity) || Integer.valueOf(good.availableQuantity) == 0;
                Boolean receiveSLI = Integer.valueOf(good.acceptedQuantity) > Integer.valueOf(good.rejectedQuantity);

                sliMapToSave.put(good.sliId, new Bit2Shop__Shipment_Line_Item__c(Id = good.sliId,
                        Bit2Shop__Status__c = closeSLI ? 'Closed' : 'Pending',
                        Bit2Shop__Received_Status__c = receiveSLI ?
                                Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_RECEIVED :
                                Plc_WizardsConstants.PLC_SLI_RECEIVEDSTATUS_NOTRECEIVED,
                        Bit2Shop__Received_Quantity__c = Integer.valueOf(good.acceptedQuantity),
                        Plc_NotReceivedQty__c = Integer.valueOf(good.rejectedQuantity))
                );
            }

            System.debug('Apex Save Goods --> sliMapToSave --> ' + sliMapToSave);
            upsert sliMapToSave.values();

            result.put('errorMessage', '');
            return result;

        } catch (Exception error) {

            Database.rollback(sp);
            String errorMessage = 'Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);

            result.put('errorMessage', errorMessage);
            return result;
        }

    }*/

}