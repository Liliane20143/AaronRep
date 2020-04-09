/**
 * Plc_StockOrderApxAct - Apex Action for Stock Order actions
 *
 * @author EM
 * @date Creation 08/02/2019
 * @description
 * @testedIn Plc_StockOrderApxActTest
 */
global without sharing class Plc_StockOrderApxAct implements wrts_prcgvr.Interfaces_1_0.IApexAction {
    //stock order
    global static final String STOCK_ORDER_STATUS_TAKECHARGE = 'Taken in charge';
    global static final String STOCK_ORDER_STATUS_ASSIGNED = 'Assigned';
/** [START MOD 20/02/2019 17:33]@Author:marco.lebellini@/webresults.it @Description: **/
    global static final String STOCK_ORDER_STATUS_CLOSED = 'Closed';
/** [END MOD 20/02/2019 17:33]@Author:marco.lebellini@/webresults.it @Description: **/
    //shipment
    global static final String SHIPMENT_STATUS_CLOSED = 'Closed';
    //shipment line item
    global static final String SHIPMENT_LINEITEM_STATUS_CLOSED = 'Closed';
    //methods
    global static final String METHOD_TAKE_CHARGE = 'takeCharge';
    global static final String METHOD_ASSIGN = 'assign';

/** [START MOD 20/02/2019 17:17]@Author:marco.lebellini@/webresults.it @Description: **/
    global static final String TRANSFER_DETAIL_DISMISSIONE = 'DISM_DL';
    global static final String TRANSFER_DETAIL_RESO_DA_VENDITA = 'RES_VEN';
    global static final String TRANSFER_DETAIL_INVIO_C_NEXI = 'C_NEX';
    global static final String TRANSFER_DETAIL_INVIO_C_NEXI_DISP = 'C_NEX_DISP';
    global static final String TRANSFER_DETAIL_RESO_INVIO_C_NEXI = 'RESO_NEX';
    global static final String SLI_STATUS2_NONE = 'None';
    global static final String ASSIGNMENT_PRECHECKS_ERROR_MESSAGE = Label.Plc_SO_Assign_Error;
/** [END MOD 20/02/2019 17:17]@Author:marco.lebellini@/webresults.it @Description: **/

    /** [START MOD 06/03/2019 17:17]@Author:andrea.liverani@/webresults.it @Description: **/
    global static final String ASSIGNMENT_PRECHECKS_DLI_QUANTITY_EXCEEDED_ERROR_MESSAGE = Label.Plc_SO_Assign_QuantityExceeded_Error;
    global static final String ASSIGNMENT_PRECHECKS_DLI_RDA_ERROR_MESSAGE = Label.Plc_SO_Assign_PrecheckRda;
    /** [END MOD 06/03/2019 17:17]@Author:andrea.liverani@/webresults.it @Description: **/

    /**
     * wrts_prcgvr.Interfaces_1_0.IApexAction implementation
     *
     * @param Object params
     *
     * @return Boolean (not required at the moment)
     */
    global Object execute(Object params) {

        //gets
        Map<String, Object> paramMap = (Map<String, Object>) params;

        if (paramMap == null) {
            throw new Plc_Exception('Unexpected null parameters [paramMap]');
        }

        String method = (String) paramMap.get('method');
        if (method == null) {
            throw new Plc_Exception('Unexpected null parameters [method]');
        }

        Bit2Shop__StockOrder__c stockOrder = (Bit2Shop__StockOrder__c) paramMap.get('sender');
        if (stockOrder == null) {
            throw new Plc_Exception('Unexpected null parameters [sender]');
        }

        Map<String, String> parameters = (Map<String, String>) paramMap.get('parameters');


        if (method == METHOD_TAKE_CHARGE) {
            return takeCharge(stockOrder, parameters);
        } else if (method == METHOD_ASSIGN) {
            return assign(stockOrder, parameters);
        }

        //unsupported method
        throw new Plc_Exception('Unsupported method in ApexAction [' + method + ']');
    }

    /**
     * Moves the stock order so take in charge
     *
     * @param stockOrder Target stock order
     * @param parameters Additional parameters
     * @return           An error message if the user has no access
     */
    global static String takeCharge(Bit2Shop__StockOrder__c stockOrder, Map<String, String> parameters) {

        System.debug('Plc_StockOrderApxAct :: Taken In Charge Stock Order >> ' + stockOrder);

        stockOrder = [
                SELECT Id, Bit2Shop__Destination_Point_Of_Sales_Id__c
                FROM Bit2Shop__StockOrder__c
                WHERE Id = :stockOrder.Id
        ];

        stockOrder.Bit2Shop__Status__c = STOCK_ORDER_STATUS_TAKECHARGE;
        //Checks whether current user can skip group check
        Boolean hasCustomPermission = FeatureManagement.checkPermission(Plc_Constants.CustomPermission.PlcTakeInChargeStockOrder);

        if (FeatureManagement.checkPermission(Plc_Constants.CustomPermission.PlcConfirmGoodsReceiving) 
            || Plc_Utils.isCurrentUserDealerGroupMember(stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c)) {
            update stockOrder;
            return null;
        } else {
            return Label.Plc_ApexClassGoodsReceivingCntForbiddenHandleMessage;
        }
    }

/**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  21/02/2019 12:06
     *     * @description method called when assign button is clicked from Stock Order Layout
     *     * @Modified by
     *   ***********************************************
     **/
    global static Object assign(Bit2Shop__StockOrder__c stockOrder, Map<String, String> parameters) {

        try {

            String transferDetailCode;

            stockOrder = [
                    Select Id, Bit2Shop__Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                            Plc_TransferDetail__c, Plc_TransferDetail__r.Bit2Shop__Code__c
                    From Bit2Shop__StockOrder__c
                    Where Id = :stockOrder.Id
            ];

            transferDetailCode = stockOrder.Plc_TransferDetail__r.Bit2Shop__Code__c;

            if (transferDetailCode == TRANSFER_DETAIL_DISMISSIONE
                    || transferDetailCode == TRANSFER_DETAIL_INVIO_C_NEXI
                    || transferDetailCode == TRANSFER_DETAIL_INVIO_C_NEXI_DISP
                    || transferDetailCode == TRANSFER_DETAIL_RESO_DA_VENDITA
                    || transferDetailCode == TRANSFER_DETAIL_RESO_INVIO_C_NEXI) {

                assignOrderAndCloseReceived(stockOrder);
            } else {

                assignOrder(stockOrder, parameters);
            }

        } catch (Exception e) {
            throw new Plc_Exception('Unexpected exception : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString());
        }

        return true;
    }

    /**
     * Makes the needed actions for the assignment of a stock order
     *
     * @param stockOrder
     * @param parameters
     *
     * @return
     */
/** [START MOD 21/02/2019 12:09]@Author:marco.lebellini@/webresults.it @Description: **/
    //global static Object assign(Bit2Shop__StockOrder__c stockOrder, Map<String,String> parameters){
    global static Object assignOrder(Bit2Shop__StockOrder__c stockOrder, Map<String, String> parameters) {
/** [END MOD 21/02/2019 12:09]@Author:marco.lebellini@/webresults.it @Description: **/
        Savepoint sp = Database.setSavepoint();

        //list of all inbound shipments
        List<Bit2Shop__Shipment__c> inboundShipments = new List<Bit2Shop__Shipment__c>();
        try {

            //query the stock order for related fields
            stockOrder = [
                    Select Id,
                            Bit2Shop__Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                            Bit2Shop__Destination_Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c
                    From Bit2Shop__StockOrder__c
                    Where Id = :stockOrder.Id
            ];

            ID shipmentOutboundId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND,
                    Bit2Shop__Shipment__c.SObjectType.getDescribe().name);

            stockOrder.Bit2Shop__Status__c = STOCK_ORDER_STATUS_ASSIGNED;
            stockOrder.Plc_ShippingDate__c = System.today();
            update stockOrder;

            //query all shipments related to the stock order
            List<Bit2Shop__Shipment__c> shipments = [
                    Select Id, RecordTypeId
                    From Bit2Shop__Shipment__c
                    Where Bit2Shop__Stock_Order_Id__c = :stockOrder.Id
            ];

            //get all the children of the outbound shipments
            List<Bit2Shop__Shipment_Line_Item__c> shipmentItems = [
                    Select Id
                    From Bit2Shop__Shipment_Line_Item__c
                    Where Bit2Shop__Shipment_Id__c IN :shipments
                    and Bit2Shop__Shipment_Id__r.RecordTypeId = :shipmentOutboundId
            ];

            //close the outbound shipment items
            for (Bit2Shop__Shipment_Line_Item__c shItem : shipmentItems) {
                shItem.Bit2Shop__Status__c = SHIPMENT_LINEITEM_STATUS_CLOSED;
            }
            //if (!Schema.sObjectType.Bit2Shop__Shipment_Line_Item__c.updateable){ throw new Plc_Exception('User does not have right to update Shipment line item objects.');}
            update shipmentItems;

            //sets the date of each shipment and close the outbound shipments
            for (Bit2Shop__Shipment__c sh : shipments) {
                sh.Bit2Shop__Date__c = System.today();

                if (sh.RecordTypeId == shipmentOutboundId) {
                    sh.Bit2Shop__Status__c = SHIPMENT_STATUS_CLOSED;
                } else {
                    inboundShipments.add(sh);
                }
            }
            //if (!Schema.sObjectType.Bit2Shop__Shipment__c.updateable){ throw new Plc_Exception('User does not have right to update Shipment objects.');}
            update shipments;

            //creates the share objects
            List<Bit2Shop__StockOrder__share> stockOrderShareList = new List<Bit2Shop__StockOrder__share>();
            Bit2Shop__StockOrder__share stockOrderShare = new Bit2Shop__StockOrder__share(
                    ParentId = stockOrder.Id,
                    UserOrGroupId = stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                    AccessLevel = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT,
                    RowCause = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL
            );
            Bit2Shop__StockOrder__share stockOrderShare2 = new Bit2Shop__StockOrder__share(
                    ParentId = stockOrder.Id,
                    UserOrGroupId = stockOrder.Bit2Shop__Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                    AccessLevel = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT,
                    RowCause = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL
            );
            stockOrderShareList.add(stockOrderShare);
            stockOrderShareList.add(stockOrderShare2);
            //if (!Schema.sObjectType.Bit2Shop__StockOrder__share.createable){ throw new Plc_Exception('User does not have right to insert Stock Order Share objects.');}
            insert stockOrderShareList;

            //shares the inbound shipments
            List<Bit2Shop__Shipment__share> shipmentShares = new List<Bit2Shop__Shipment__share>();
            for (Bit2Shop__Shipment__c sh : inboundShipments) {
                Bit2Shop__Shipment__share shShare = new Bit2Shop__Shipment__share(
                        ParentId = sh.Id,
                        UserOrGroupId = stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                        AccessLevel = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT,
                        RowCause = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL
                );
                shipmentShares.add(shShare);
            }
            //if (!Schema.sObjectType.Bit2Shop__Shipment__share.createable){ throw new Plc_Exception('User does not have right to insert Shipment Share objects.');}
            insert shipmentShares;


        } catch (Exception ex) {
            Database.rollback(sp);
            throw new Plc_Exception('Unexpected exception: ' + ex.getMessage());
        }

        return true;
    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  26/02/2019 10:22
     *     * @description Assign Prechecks Validation Method
     *     * @Modified by
     *   ***********************************************
     **/
    global static String precheckOrderBeforeAssign(Bit2Shop__StockOrder__c stockOrder) {
        System.debug(' ######## Plc_StockOrderApxAct --> precheckOrderBeforeAssign Invoked ');

        try {
            ID inboundShipmentRTId = Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_Shipment.RecordType_InboundShipment).getRecordTypeId();

            List<Bit2Shop__Shipment_Line_Item__c> shipmentItems = [
                    SELECT Id,
                            Bit2Shop__Shipment_Id__r.RecordTypeId,
                            Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__c,
                            Plc_StockSerial__r.Bit2Shop__Warehouse_Id__c,
                            Plc_StockSerial__r.Plc_Status2__c,
                            Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__c
                    FROM Bit2Shop__Shipment_Line_Item__c
                    WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c = :stockOrder.Id
            ];

            for (Bit2Shop__Shipment_Line_Item__c sli : shipmentItems) {

                if (sli.Plc_StockSerial__c != null
                        &&
                        (sli.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__c != sli.Plc_StockSerial__r.Bit2Shop__Warehouse_Id__c
                                || (sli.Plc_StockSerial__r.Plc_Status2__c != null && sli.Plc_StockSerial__r.Plc_Status2__c != SLI_STATUS2_NONE))
                        ) {

                    System.debug('######## Validtion Error : SLI List >> ' + shipmentItems);
                    return ASSIGNMENT_PRECHECKS_ERROR_MESSAGE;

                }
            }

                        /** START FIX [#20190305AL] - 05 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
            //query the stock order for related fields
            stockOrder = [
                    Select Id,
                            Plc_DistributionList__c,
                            /** [START MOD 08/03/2019 18:13]@Author:marco.lebellini@/webresults.it @Description: **/
                            Plc_PurchaseOrder__r.Plc_RdaNumber__c,
                            /** [END MOD 08/03/2019 18:13]@Author:marco.lebellini@/webresults.it @Description: **/ (
                            SELECT Id, Bit2Shop__Sub_Type__c,
                                    Bit2Shop__Shipped_Quantity__c,
                                    Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c
                            FROM Bit2Shop__ShipmentOrders__r
                    )
                    From Bit2Shop__StockOrder__c
                    Where Id = :stockOrder.Id
            ];

            List<Bit2Shop__Shipment__c> shipmentList = stockOrder.Bit2Shop__ShipmentOrders__r;
            Map<String, Bit2Shop__Shipment_Line_Item__c> shipmentIdToSli = new Map<String, Bit2Shop__Shipment_Line_Item__c>();
            List<String> externalCatalogItemNameList = new List<String>();
            List<String> shipmentIdsList = new List<String>();

            //START FIX [#20190313AL] - 13 mar 2019 15:39 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            List<String> stockSerialIdsList = new List<String>();
            List<String> purchaseOrderIdsList = new List<String>();
            //END FIX [#20190313AL] - 13 mar 2019 15:39 - Andrea Liverani (WR) - andrea.liverani@webresults.it

            Boolean quantityExceeded = false;

            for (Bit2Shop__Shipment__c shipment : shipmentList) {
                shipmentIdsList.add(shipment.Id);
            }

            List<Bit2Shop__Shipment_Line_Item__c> sliList = [SELECT Id, Bit2Shop__Shipment_Id__c, Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__c, 
                                                                    Plc_PurchaseOrder__r.Plc_RdaNumber__c, Bit2Shop__Requested_Quantity__c, Bit2Shop__Type__c, Plc_StockSerial__c 
                                                             FROM Bit2Shop__Shipment_Line_Item__c 
                                                             WHERE Bit2Shop__Shipment_Id__c IN :shipmentIdsList];

            if (!shipmentList.isEmpty()) {
                for (Bit2Shop__Shipment_Line_Item__c sli : sliList) {
                    if (sli.Bit2Shop__Type__c == 'Product') {
                        for (Bit2Shop__Shipment__c shipment : shipmentList) {
                            if (shipment.Bit2Shop__Sub_Type__c == 'Outbound' && sli.Bit2Shop__Shipment_Id__c == shipment.Id) {
                                System.debug('shipment.Id >>' + shipment.Id);
                                System.debug('Plc_PurchaseOrder__r.Plc_RdaNumber__c >>' + sli.Plc_PurchaseOrder__r.Plc_RdaNumber__c);
                                shipmentIdToSli.put(shipment.Id, sli);
                            }
                        }
                    } else if(sli.Bit2Shop__Type__c == 'Serial') {
                        stockSerialIdsList.add(sli.Plc_StockSerial__c);
                    }
                }
            }

            System.debug('shipmentIdToSli >> ' + shipmentIdToSli);

            if (String.isNotBlank(stockOrder.Plc_DistributionList__c)) {
                List<Plc_DistributionListItem__c> dliList = [
                        SELECT Id,
                                Plc_DestinationWarehouse__c,
                                Plc_ShippedQty__c,
                                Plc_RequestedQty__c,
                                Plc_PurchaseOrder__c,
                                Plc_Product__r.B2WExtCat__External_Catalog_Item_Name__c,
                                /** [START MOD 08/03/2019 18:12]@Author:marco.lebellini@/webresults.it @Description: **/
                                Plc_RdaNumber__c
                        /** [END MOD 08/03/2019 18:12]@Author:marco.lebellini@/webresults.it @Description: **/
                        FROM Plc_DistributionListItem__c
                        WHERE Plc_DistributionList__c = :stockOrder.Plc_DistributionList__c AND
                              Plc_Status__c != 'Closed'

                ];


                /** [START MOD 10/04/2019 12:14]@Author:FB @Description: **/

                //Boolean checkRdaPassed = false;

                //if (!shipmentList.isEmpty()) {
                //    for (Bit2Shop__Shipment__c shipment : shipmentList) {
                //        if (!dliList.isEmpty()) {
                //            for (Plc_DistributionListItem__c dli : dliList) {
                //                /** START FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                //                /*if (dli.Plc_Product__r.B2WExtCat__External_Catalog_Item_Name__c == shipment.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c) {*/

                //                if (dli.Plc_Product__r.B2WExtCat__External_Catalog_Item_Name__c == shipment.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c 
                //                         && shipmentIdToSli.get(shipment.Id) != null && shipmentIdToSli.get(shipment.Id).Plc_PurchaseOrder__r.Plc_RdaNumber__c == dli.Plc_RdaNumber__c) {
                //                    /** END FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                //                    checkRdaPassed = true;

                //                    if (dli.Plc_ShippedQty__c == null) {
                //                        dli.Plc_ShippedQty__c = shipmentIdToSli.get(shipment.Id).Bit2Shop__Requested_Quantity__c;
                //                    } else {
                //                        dli.Plc_ShippedQty__c = dli.Plc_ShippedQty__c + shipmentIdToSli.get(shipment.Id).Bit2Shop__Requested_Quantity__c;
                //                    }

                //                    /** [START MOD 08/03/2019 18:13]@Author:marco.lebellini@/webresults.it @Description: **/
                //                    /** START FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                //                    if (dli.Plc_ShippedQty__c > dli.Plc_RequestedQty__c) {
                //                        /*if (stockOrder.Plc_PurchaseOrder__r.Plc_RdaNumber__c == dli.Plc_RdaNumber__c
                //                            && (dli.Plc_ShippedQty__c > dli.Plc_RequestedQty__c || dli.Plc_RequestedQty__c < 0)) {*/
                //                        /** END FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                //                        /** [END MOD 08/03/2019 18:13]@Author:marco.lebellini@/webresults.it @Description: **/
                //                        quantityExceeded = true;
                //                    }
                //                }

                //                if (checkRdaPassed == false) {
                //                    return ASSIGNMENT_PRECHECKS_DLI_RDA_ERROR_MESSAGE;
                //                }
                //            }
                //        }
                //    }
                //}

                Boolean checkRdaPassed;

                if (!shipmentList.isEmpty()) {
                    for (Bit2Shop__Shipment__c shipment : shipmentList) {
                        if (!dliList.isEmpty() && shipment.Bit2Shop__Sub_Type__c == 'Outbound') {

                            checkRdaPassed = false;

                            for (Plc_DistributionListItem__c dli : dliList) {
                                /** START FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                                /*if (dli.Plc_Product__r.B2WExtCat__External_Catalog_Item_Name__c == shipment.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c) {*/

                                if (dli.Plc_Product__r.B2WExtCat__External_Catalog_Item_Name__c == shipment.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c 
                                         && shipmentIdToSli.get(shipment.Id) != null && shipmentIdToSli.get(shipment.Id).Plc_PurchaseOrder__r.Plc_RdaNumber__c == dli.Plc_RdaNumber__c
                                         && shipmentIdToSli.get(shipment.Id).Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__c == dli.Plc_DestinationWarehouse__c) {
                                    /** END FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                                    checkRdaPassed = true;

                                    if (dli.Plc_ShippedQty__c == null) {
                                        dli.Plc_ShippedQty__c = shipmentIdToSli.get(shipment.Id).Bit2Shop__Requested_Quantity__c;
                                    } else {
                                        dli.Plc_ShippedQty__c = dli.Plc_ShippedQty__c + shipmentIdToSli.get(shipment.Id).Bit2Shop__Requested_Quantity__c;
                                    }

                                    /** [START MOD 08/03/2019 18:13]@Author:marco.lebellini@/webresults.it @Description: **/
                                    /** START FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                                    if (dli.Plc_ShippedQty__c > dli.Plc_RequestedQty__c) {
                                        /*if (stockOrder.Plc_PurchaseOrder__r.Plc_RdaNumber__c == dli.Plc_RdaNumber__c
                                            && (dli.Plc_ShippedQty__c > dli.Plc_RequestedQty__c || dli.Plc_RequestedQty__c < 0)) {*/
                                        /** END FIX [#20190312AL] - 12 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/
                                        /** [END MOD 08/03/2019 18:13]@Author:marco.lebellini@/webresults.it @Description: **/
                                        quantityExceeded = true;
                                    }
                                }
                            }

                            if (checkRdaPassed == false) {
                                return ASSIGNMENT_PRECHECKS_DLI_RDA_ERROR_MESSAGE;
                            }
                        }
                    }
                }

                /** [END MOD 10/04/2019 12:14]@Author:FB @Description: **/

                if (quantityExceeded) {
                    return ASSIGNMENT_PRECHECKS_DLI_QUANTITY_EXCEEDED_ERROR_MESSAGE;
                } else {
                    update dliList;
                }

                //START FIX [#20190313AL] - 13 mar 2019 15:38 - Andrea Liverani (WR) - andrea.liverani@webresults.it
                if(!dliList.isEmpty()) {
                    for(Plc_DistributionListItem__c dli : dliList) {
                        purchaseOrderIdsList.add(dli.Plc_PurchaseOrder__c);
                    }
                }

                System.debug('purchaseOrderIdsList >> ' + purchaseOrderIdsList);

                List<Bit2Shop__Stock_Serials2__c > stockSerialList = [SELECT Id, Plc_Model__c, Plc_Manufacturer__c, Bit2Shop__Shipment_Line_Item_Id__c, Bit2Shop__Shipment_Line_Item_Id__r.Plc_PurchaseOrder__c FROM Bit2Shop__Stock_Serials2__c WHERE Id IN:stockSerialIdsList];
                List<Plc_PurchaseOrderItem__c> purchaseOrderItemsList = [SELECT Id, Plc_PurchaseOrder__c, Plc_Model__c, Plc_Model__r.B2WExtCat__External_Catalog_Item_Name__c, Plc_Manufacturer__c FROM Plc_PurchaseOrderItem__c WHERE Plc_PurchaseOrder__c IN :purchaseOrderIdsList];

                System.debug('stockSerialList >> ' + stockSerialList);
                System.debug('purchaseOrderItemsList >> ' + purchaseOrderItemsList);

                if(!stockSerialList.isEmpty()) {
                    for(Bit2Shop__Stock_Serials2__c stockSerial : stockSerialList) {
                        System.debug('stockSerial.Bit2Shop__Shipment_Line_Item_Id__r.Plc_PurchaseOrder__c >>' + stockSerial.Bit2Shop__Shipment_Line_Item_Id__r.Plc_PurchaseOrder__c);
                        if(!purchaseOrderItemsList.isEmpty()) {
                            for(Plc_PurchaseOrderItem__c purchaseOrderItem : purchaseOrderItemsList) {
                                if(stockSerial.Bit2Shop__Shipment_Line_Item_Id__c != null && stockSerial.Bit2Shop__Shipment_Line_Item_Id__r.Plc_PurchaseOrder__c == purchaseOrderItem.Plc_PurchaseOrder__c && purchaseOrderItem.Plc_Model__c != null && stockSerial.Plc_Model__c == purchaseOrderItem.Plc_Model__r.B2WExtCat__External_Catalog_Item_Name__c && stockSerial.Plc_Manufacturer__c == purchaseOrderItem.Plc_Manufacturer__c) {
                                    System.debug('hello >> ');
                                    stockSerial.Plc_PurchaseOrderItem__c = purchaseOrderItem.Id;
                                }
                            }
                        }
                    }
                }

                System.debug('stockSerialList >> ' + stockSerialList);

                update stockSerialList;
                //END FIX [#20190313AL] - 13 mar 2019 15:38 - Andrea Liverani (WR) - andrea.liverani@webresults.it
            }
            /** END FIX [#20190305AL] - 05 mar 2019 14:47 - Andrea Liverani (WR) - andrea.liverani@webresults.it **/

            System.debug('######## Validtion Successful : SLI List >> ' + shipmentItems);
            return null;

        } catch (Exception e) {
            throw new Plc_Exception('Unexpected exception : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString());
        }

    }

    /**
      * *************************************************
      *     * @Author marco.lebellini@/webresults.it
      *     * @date  21/02/2019 12:01
      *     * @description method to receive and close order in batch mode
      *     * @Modified by
      *   ***********************************************
      **/
    global static Boolean assignOrderAndCloseReceived(Bit2Shop__StockOrder__c stockOrder) {
        System.debug(' ######## Plc_StockOrderApxAct --> assignOrderAndCloseReceived Invoked ');

        Savepoint sp = Database.setSavepoint();

        try {

            //query the stock order for related fields
            stockOrder = [
                    Select Id, Bit2Shop__Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                            Bit2Shop__Destination_Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c
                    From Bit2Shop__StockOrder__c
                    Where Id = :stockOrder.Id
            ];

            ID inboundShipmentRTId = Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_Shipment.RecordType_InboundShipment).getRecordTypeId();

            stockOrder.Bit2Shop__Status__c = STOCK_ORDER_STATUS_CLOSED;
            stockOrder.Plc_ShippingDate__c = System.today();
            stockOrder.Plc_TakenInChargeDate__c = System.today();
            stockOrder.Plc_CloseDate__c = System.today();
            //if (!Schema.sObjectType.Bit2Shop__StockOrder__c.updateable){ throw new Plc_Exception('User does not have right to update Stock Order objects.');}
            update stockOrder;

            System.debug('######## Stock Order Updated --> ' + stockOrder);

            List<Bit2Shop__Shipment__c> shipments = [
                    Select Id, RecordTypeId
                    From Bit2Shop__Shipment__c
                    Where Bit2Shop__Stock_Order_Id__c = :stockOrder.Id
            ];

            for (Bit2Shop__Shipment__c shipment : shipments) {

                shipment.Bit2Shop__Status__c = SHIPMENT_STATUS_CLOSED;
                shipment.Bit2Shop__Date__c = System.today();
            }

            List<Bit2Shop__Shipment_Line_Item__c> shipmentItems = [
                    Select Id,
                            Bit2Shop__Shipment_Id__r.RecordTypeId,
                            Bit2Shop__Requested_Quantity__c,
                            Bit2Shop__Received_Quantity__c,
                            Bit2Shop__Received_Status__c
                    From Bit2Shop__Shipment_Line_Item__c
                    Where Bit2Shop__Shipment_Id__c IN :shipments
            ];

            Integer requestedQt;
            for (Bit2Shop__Shipment_Line_Item__c sli : shipmentItems) {

                sli.Bit2Shop__Status__c = SHIPMENT_LINEITEM_STATUS_CLOSED;
                sli.Bit2Shop__Received_Status__c = Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_Received;

                if (sli.Bit2Shop__Shipment_Id__r.RecordTypeId == inboundShipmentRTId) {
                    requestedQt = sli.Bit2Shop__Requested_Quantity__c != null ? Integer.valueOf(sli.Bit2Shop__Requested_Quantity__c) : 1;
                    sli.Bit2Shop__Received_Quantity__c = requestedQt;
                }
            }
            //if (!Schema.sObjectType.Bit2Shop__Shipment_Line_Item__c.updateable){ throw new Plc_Exception('User does not have right to update Shipment line item objects.');}
            update shipmentItems;
            System.debug('######## Shipments Line Items Updated --> ' + shipmentItems);

            //if (!Schema.sObjectType.Bit2Shop__Shipment__c.updateable){ throw new Plc_Exception('User does not have right to update Shipment objects.');}
            update shipments;
            System.debug('######## Shipments Updated --> ' + shipments);

            //creates the share objects
            List<Bit2Shop__StockOrder__share> stockOrderShareList = new List<Bit2Shop__StockOrder__share>();
            Bit2Shop__StockOrder__share stockOrderShare = new Bit2Shop__StockOrder__share(
                    ParentId = stockOrder.Id,
                    UserOrGroupId = stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                    AccessLevel = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT,
                    RowCause = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL
            );
            Bit2Shop__StockOrder__share stockOrderShare2 = new Bit2Shop__StockOrder__share(
                    ParentId = stockOrder.Id,
                    UserOrGroupId = stockOrder.Bit2Shop__Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                    AccessLevel = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT,
                    RowCause = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL
            );
			stockOrderShareList.add(stockOrderShare);
            stockOrderShareList.add(stockOrderShare2);
            //if (!Schema.sObjectType.Bit2Shop__StockOrder__share.createable){ throw new Plc_Exception('User does not have right to insert Stock Order Share objects.');}
            insert stockOrderShareList;
            System.debug('######## Stock Order Share 1 created --> ' + stockOrderShare);
            System.debug('######## Stock Order Share 2 created --> ' + stockOrderShare2);

            //shares the inbound shipments
            List<Bit2Shop__Shipment__share> shipmentShares = new List<Bit2Shop__Shipment__share>();
            for (Bit2Shop__Shipment__c shipment : shipments) {

                Bit2Shop__Shipment__share shShare;
                if (shipment.RecordTypeId == inboundShipmentRTId) {

                    shShare = new Bit2Shop__Shipment__share(
                            ParentId = shipment.Id,
                            UserOrGroupId = stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                            AccessLevel = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT,
                            RowCause = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL);
                } else {

                    shShare = new Bit2Shop__Shipment__share(
                            ParentId = shipment.Id,
                            UserOrGroupId = stockOrder.Bit2Shop__Point_Of_Sales_Id__r.Bit2Shop__Group_Id__c,
                            AccessLevel = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT,
                            RowCause = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL);
                }
                shipmentShares.add(shShare);
            }
            //if (!Schema.sObjectType.Bit2Shop__Shipment__share.createable){ throw new Plc_Exception('User does not have right to insert Shipment Share objects.');}
            insert shipmentShares;
            System.debug('######## Shipment Share created --> ' + stockOrderShare);


        } catch (Exception e) {
            Database.rollback(sp);
            throw new Plc_Exception('Unexpected exception : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString());
        }

        return true;

    }

}