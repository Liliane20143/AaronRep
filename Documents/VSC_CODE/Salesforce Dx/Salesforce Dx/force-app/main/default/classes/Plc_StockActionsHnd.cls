/**
 * Plc_StockActionsHnd - Trasfer Detail action's handler
 *
 * @author EM
 * @date Creation 17/01/2019
 * @description
 * @testedIn Plc_StockActionsHndTest
 */
public without sharing class Plc_StockActionsHnd {
    //skips a shipment line items if already executed
    public static Set<String> alreadyCalculated = new Set<String>();

    //action enum
    public enum UpdatedObject {StockOrder, ShipmentLineItem}

    //Stock Action Detail
    public static final String STOCK_ACTION_DETAIL_PRODUCT_TYPE_PRODUCT         { get { return Plc_Constants.B2S_StockActionsDetail.PlcProductType_Product; } }//'Product';
    public static final String STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL          { get { return Plc_Constants.B2S_StockActionsDetail.PlcProductType_Serial; } }//'Serial';
    public static final String STOCK_ACTION_DETAIL_PRODUCT_TYPE_BOTH            { get { return Plc_Constants.B2S_StockActionsDetail.PlcProductType_Both; } }//'Both';
    public static final String STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER    { get { return Plc_Constants.B2S_StockActionsDetail.PlcStatusTrigger_StockOrder; } }//'StockOrder';
    public static final String STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM  { get { return Plc_Constants.B2S_StockActionsDetail.PlcStatusTrigger_ShipmentLineItem; } }//'ShipmentLineItem';
    public static final String STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK          { get { return Plc_Constants.B2S_StockActionsDetail.B2S_TargetObject_ProductStock; } }//'Product_Stock__c';
    public static final String STOCK_ACTION_TARGET_OBJECT_STOCKERIAL            { get { return Plc_Constants.B2S_StockActionsDetail.B2S_TargetObject_StockSerials2; } }//'Stock_Serials2__c';
    public static final String STOCK_ACTION_TARGET_ACTION_INCREASE              { get { return Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_IncreaseQty; } }//'Increase Qty';
    public static final String STOCK_ACTION_TARGET_ACTION_DECREASE              { get { return Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_DecreaseQty; } }//'Decrease Qty';
    public static final String STOCK_ACTION_TARGET_ACTION_UPDATEFIELD           { get { return Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_UpdateField; } }//'Update Field';
    public static final String STOCK_ACTION_TARGET_ACTION_MOVETOWAREHOUSE       { get { return Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_MoveToWarehouse; } }//'Move To Warehouse';

    //FB 20-09-2019: Optimizing [START] 
    private static Schema.DescribeSObjectResult stockSerial2Schema = Bit2Shop__Stock_Serials2__c.SObjectType.getDescribe();
    private static Schema.DescribeSObjectResult productStockSchema = Bit2Shop__Product_Stock__c.SObjectType.getDescribe();
    //FB 20-09-2019: Optimizing [END] 
    
    /**
     * Given a set of Stock Order Ids, checks if there are applicable actions.
     * Stock Orders should already be filtered by status change (i.e. they shouldn't be sent to this method if
     * the status has not changed before this call)
     *
     * Given a set of Shipment Line Item Ids, checks if there are applicable actions.
     * Shipment Line Items should already be filtered by status change (i.e. they shouldn't be sent to this method if
     * the status has not changed before this call)
     *
     * Only INBOUND Shipment LIne Items trigger the actions.
     *
     * @param stockOrdersIds - Id of the Stock Orders that have changed status: can be null or empty
     * @param shipmentItemsIds - Id of the Shipment Line Items that have changed status: can be null or empty
     */
    public static void executeActions(List<ID> stockOrdersIds, List<ID> shipmentItemsIds){

        LogTracker.debugLogBegin('Plc_StockActionsHnd', 'executeActions '+stockOrdersIds+' '+shipmentItemsIds);

        //maps Stock Order ID with its outbound shipment line items
        Map<ID, List<Bit2Shop__Shipment_Line_Item__c>> outboundShipItemsMap = new Map<ID, List<Bit2Shop__Shipment_Line_Item__c>>();
        //maps Stock Order ID with its inbound shipment line items
        Map<ID, List<Bit2Shop__Shipment_Line_Item__c>> inboundShipItemsMap = new Map<ID, List<Bit2Shop__Shipment_Line_Item__c>>();
        // Map of Shipment Line Item IDs (of type Product) to Shipment Line Items child (of type serial)
        Map<ID, List<Bit2Shop__Shipment_Line_Item__c>> childShipmentItemsMap = new Map<ID, List<Bit2Shop__Shipment_Line_Item__c>>();
        //maps Serial Stock 2 ID with Serial Stock 2
        Map<ID, Bit2Shop__Stock_Serials2__c> serialStock2Map = new Map<ID, Bit2Shop__Stock_Serials2__c>();
        //maps Product Stock ID with Product Stock
        Map<ID, Bit2Shop__Product_Stock__c> productStockMap = new Map<ID, Bit2Shop__Product_Stock__c>();
        //maps Parent Stock Action with children stock actions
        Map<ID, List<Bit2Shop__Stock_Action__c>> parentActionToChildren = new Map<ID, List<Bit2Shop__Stock_Action__c>>();

        if(stockOrdersIds == null){
            stockOrdersIds = new List<ID>();
        }
        if(shipmentItemsIds == null) {
            shipmentItemsIds = new List<ID>();
        }

        if(stockOrdersIds.isEmpty()
                && shipmentItemsIds.isEmpty()){
            throw new Plc_Exception('Invalid parameters on executeActions: no stock orders nor shipment line items');
        }

        //formalize triggering object type (Stock Order or Shipment Line Items)
        UpdatedObject sourceObject = UpdatedObject.StockOrder;

        //in case of shipment line items, we'll query for all stock orders related
        if(!shipmentItemsIds.isEmpty()){
            sourceObject = UpdatedObject.ShipmentLineItem;
            for(Bit2Shop__Shipment_Line_Item__c shipItem : [Select Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c
            From Bit2Shop__Shipment_Line_Item__c
            WHERE Id IN :shipmentItemsIds]){

                if(shipItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c == null) {
                    continue;
                }

                stockOrdersIds.add(shipItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c);
            }
        }

        //get all stock orders that are moved
        Map<ID, Bit2Shop__StockOrder__c> stockOrderMap = new Map<ID, Bit2Shop__StockOrder__c>(
        [Select Id, Bit2Shop__Status__c,
                Plc_TransferDetail__c,
                Plc_TransferDetail__r.Plc_SourceWarehouseStockAction__c,
                Plc_TransferDetail__r.Plc_DestinationWarehouseStockAction__c,
                Plc_WorkOrder__c,
                Bit2Shop__Point_Of_Sales_Id__c,
                Bit2Shop__Holding_Id__c,
                Bit2Shop__Warehouse_Id__c,
                Bit2Shop__Destination_Point_Of_Sales_Id__c,
                Bit2Shop__Destination_Warehouse_Id__c
        From Bit2Shop__StockOrder__c
        Where Id IN : stockOrdersIds]);
        List<ID> actionsId = new List<ID>();
        for(Bit2Shop__StockOrder__c so : stockOrderMap.values()){
            if(so.Plc_TransferDetail__r.Plc_SourceWarehouseStockAction__c != null) {
                actionsId.add(so.Plc_TransferDetail__r.Plc_SourceWarehouseStockAction__c);
            }

            if(so.Plc_TransferDetail__r.Plc_DestinationWarehouseStockAction__c  != null) {
                actionsId.add(so.Plc_TransferDetail__r.Plc_DestinationWarehouseStockAction__c );
            }
        }

        //get all Trasfer Detail'actions and details
        Map<ID, Bit2Shop__Stock_Action__c> stockActionsMap = new Map<ID, Bit2Shop__Stock_Action__c>(
            [Select Id, Plc_StatusTrigger__c,
                    Plc_ParentAction__c,
            (Select Id, Bit2Shop__Target_Object__c,
                    Plc_TargetField__c,
                    Bit2Shop__Target_Field_Value__c,
                    Bit2Shop__Target_Counter__c,
                    Plc_ProductType__c,
                    Bit2Shop__Target_Action__c,
                    Bit2Shop__Used_Value__c
            From Bit2Shop__StockActionsDetails__r)
            From Bit2Shop__Stock_Action__c
            Where Plc_ParentAction__c IN :actionsId]);

        //creates a map of Stock Action Parent ID to Stock Action Childrens
        for(Bit2Shop__Stock_Action__c sa : stockActionsMap.values()){
            List<Bit2Shop__Stock_Action__c> actList = parentActionToChildren.get(sa.Plc_ParentAction__c);
            if(actList == null){
                actList = new List<Bit2Shop__Stock_Action__c>();
                parentActionToChildren.put(sa.Plc_ParentAction__c, actList);
            }
            actList.add(sa);
        }

        LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## stockOrderMap: '+stockOrderMap);
        LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## stockOrderMap.keyset(): '+stockOrderMap.keyset());

        List<ID> soIds = new List<ID>();
        soIds.addAll(stockOrderMap.keyset());

        /*if(Test.isrunningtest()) {
            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## [Select Id from Bit2Shop__Shipment_Line_Item__c]: '
                    + soIds
                    + ' >>>' + [
                    Select Id, Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c
                    from Bit2Shop__Shipment_Line_Item__c

            ]);
        }*/

        //query all shipment line items related to the incoming stock orders
        //Gets the "Product" Shipment Line Items and their child "Serial" shipment line items (that are not present if the shipment
        //is only of type "Product")
        for(Bit2Shop__Shipment_Line_Item__c shipItem : [Select Id, Bit2Shop__Type__c, Bit2Shop__Status__c, Bit2Shop__Transfer_Detail_Id__c,
                Bit2Shop__Received_Quantity__c, Bit2Shop__Shipment_Id__c,
                Bit2Shop__Requested_Quantity__c, Plc_ShipmentType__c,
                Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Product_Stock_Id__r.Id,
                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c,
                Bit2Shop__Target_Line_Item__c,
                Bit2Shop__Shipment_Id__r.RecordTypeId, Bit2Shop__Received_Status__c,
                Bit2Shop__Shipment_Id__r.RecordType.DeveloperName,
        (Select Id, Plc_StockSerial__c,
                Plc_StockSerial__r.Id, Bit2Shop__Received_Status__c,
                Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Received_Quantity__c, Plc_ShipmentType__c,
                Bit2Shop__Requested_Quantity__c,
                Bit2Shop__Status__c From Bit2Shop__Shipment_Line_Items__r)
        From Bit2Shop__Shipment_Line_Item__c
        Where Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c IN :soIds
        and RecordTypeId = :Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_ITEM_RECORDTYPE_PRODUCT,
                Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name) FOR UPDATE]){

            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## shipItem: '+shipItem);
            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## shipmentItemsIds: '+shipmentItemsIds);
            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## shipItem.Bit2Shop__Shipment_Id__r.RecordType.DeveloperName: '+shipItem.Bit2Shop__Shipment_Id__r.RecordType.DeveloperName);
            //List<Bit2Shop__Shipment_Line_Item__c> childShipments = new List<Bit2Shop__Shipment_Line_Item__c>(shipItem.Bit2Shop__Shipment_Line_Items__r);
            List<Bit2Shop__Shipment_Line_Item__c> childShipments = new List<Bit2Shop__Shipment_Line_Item__c>();
            for (Bit2Shop__Shipment_Line_Item__c sli : shipItem.Bit2Shop__Shipment_Line_Items__r) {
                childShipments.add(sli);
            }

            //filters out current Shipment if it is not on the source IDs list
            //Match if Product Shipment or Child Serial Shipment found on the *shipmentItemsIds* incoming list
            if(sourceObject == UpdatedObject.ShipmentLineItem){
                Boolean shipmentMatch = false;


                if(childShipments.isEmpty() && shipmentItemsIds.contains(shipItem.Id)){
                    //if is a Product shipment line item and has no children, than we can elaborate it
                    shipmentMatch = true;
                }else if(!childShipments.isEmpty() /*&& !shipmentItemsIds.contains(shipItem.Id)*/){
                    //if it is a Product shipment that has children and is not contained in the input shipment list
                    //check if one of the children is in the list to elaborate it
                    shipmentMatch = false;
                    for (Integer i = childShipments.size() - 1; i >= 0; i--) {
                        Bit2Shop__Shipment_Line_Item__c serialShipItem = childShipments[i];
                        if (shipmentItemsIds.contains(serialShipItem.Id)) {
                            shipmentMatch = true;
                        } else {
                            childShipments.remove(i);
                        }
                    }
                }

                if(!shipmentMatch){
                    continue;
                }
            }

            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## shipItem.Bit2Shop__Shipment_Id__r.RecordType.DeveloperName (2): '+shipItem.Bit2Shop__Shipment_Id__r.RecordType.DeveloperName);

            //add the child shipments to the map only if they are not filtered out
            //if for a given shipment id there is no list of child shipment (null value)
            //this means that the shipment should not been considered
            childShipmentItemsMap.put(shipItem.Id, childShipments);

            //creates the map Product Stock ID => List of child Shipment Line Items of Product Type (with their childer of type Serial)
            Map<Id, List<Bit2Shop__Shipment_Line_Item__c>> searchMap = null;
            if(shipItem.Bit2Shop__Shipment_Id__r.RecordTypeId == Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND,
                    Bit2Shop__Shipment__c.SObjectType.getDescribe().name)){
                searchMap = outboundShipItemsMap;
            }else if(shipItem.Bit2Shop__Shipment_Id__r.RecordTypeId == Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_INBOUND,
                    Bit2Shop__Shipment__c.SObjectType.getDescribe().name)){
                searchMap = inboundShipItemsmap;
            }
            List<Bit2Shop__Shipment_Line_Item__c> shItLst = searchMap.get(shipItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c);
            if(shItLst == null){
                shItLst = new List<Bit2Shop__Shipment_Line_Item__c>();
                searchMap.put(shipItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c, shItLst);
            }
            shItLst.add(shipItem);

            //add the product stock to the map: this way we can increment/decrement the same quantity record
            productStockMap.put(shipItem.Bit2Shop__Product_Stock_Id__c, shipItem.Bit2Shop__Product_Stock_Id__r);

            //add the stock serial 2 to the map: this way we can change status to the same serial record
            for(Bit2Shop__Shipment_Line_Item__c serialShipItem : childShipments){
                serialStock2Map.put(serialShipItem.Plc_StockSerial__c, serialShipItem.Plc_StockSerial__r);
            }
        }

        System.debug('### outboundShipItemsMap: '+outboundShipItemsMap);
        System.debug('### inboundShipItemsmap: '+inboundShipItemsmap);

        //makes another query on the Stock Serial 2 and Product Stock objects to lock the records
        //the **FOR UPDATE** is necessary to avoid race conditions on the update of Product Stokc and Serial Stock 2
        for(Bit2Shop__Product_Stock__c pStock : [Select Id, Bit2Shop__Stock_Qty__c, Bit2Shop__Warehouse_Id__c,
                Plc_UsableQty__c, Plc_WithdrawnQty__c, Plc_OrderedQty__c,
                Bit2Shop__Inventory_ConfirmedQty__c, Bit2Shop__Inventory_PreviousQty__c,
                Bit2Shop__Inventory_QtyToJustify__c, Bit2Shop__Inventory_QtyUnjustified__c,
                Bit2Shop__Reserved_Qty__c, Bit2Shop__Shipped_Qty__c
        From Bit2Shop__Product_Stock__c
        Where Id IN :productStockMap.keyset() FOR UPDATE]){
            productStockMap.put(pStock.Id, pStock);
        }
        for(Bit2Shop__Stock_Serials2__c stSerial : [Select Id From Bit2Shop__Stock_Serials2__c
        Where Id IN :serialStock2Map.keyset() FOR UPDATE]){
            serialStock2Map.put(stSerial.Id, stSerial);
        }

        //Product Stocks and Serial Stock2 objects to be updated:
        //Map is used to avoid putting the same object on an update list
        Map<ID, Bit2Shop__Product_Stock__c> productStockUpdateMap = new Map<Id, Bit2Shop__Product_Stock__c>();
        Map<ID, Bit2Shop__Stock_Serials2__c> stockSerialUpdateMap = new Map<Id, Bit2Shop__Stock_Serials2__c>();

        //iterates through the Stock Orders
        for(Bit2Shop__StockOrder__c stockOrder : stockOrderMap.values()){

            //gets the shipment line items
            List<Bit2Shop__Shipment_Line_Item__c> inShipItems = inboundShipItemsMap.get(stockOrder.Id);
            List<Bit2Shop__Shipment_Line_Item__c> outShipItems = outboundShipItemsMap.get(stockOrder.Id);

            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## outboundShipItemsMap: '+outboundShipItemsMap);

            List<Bit2Shop__Stock_Action__c> originChildrenActions       = parentActionToChildren.get(stockOrder.Plc_TransferDetail__r.Plc_SourceWarehouseStockAction__c);
            List<Bit2Shop__Stock_Action__c> destinationChildrenActions  = parentActionToChildren.get(stockOrder.Plc_TransferDetail__r.Plc_DestinationWarehouseStockAction__c);

            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## outShipItems: ' + outShipItems);
            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## childShipmentItemsMap: ' + childShipmentItemsMap);


            if(originChildrenActions != null && outShipItems != null) {
                for (Bit2Shop__Stock_Action__c originAction : originChildrenActions){

                    LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## Source Action Detail: ' + JSON.serialize(originAction));

                    //iterate through the outbound shipment line items
                    for (Bit2Shop__Shipment_Line_Item__c shipItem : outShipItems) {

                        //if(!shipmentItemsIds.isEmpty() && !shipmentItemsIds.contains(shipItem.Id)) continue;

                        //check if shipment and his children have been filtered out
                        //if (childShipmentItemsMap.get(shipItem.Id) == null) {
                        //    continue;
                        //}

                        LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## Applying originAction: [' + originAction + '] to shipItem [' + shipItem + ']');
                        applyAllActions(sourceObject, stockOrder, productStockMap, serialStock2Map, shipItem,
                                childShipmentItemsMap.get(shipItem.Id), originAction, productStockUpdateMap,
                                stockSerialUpdateMap, stockOrder.Bit2Shop__Warehouse_Id__c);
                    }

                }
            }

            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## inShipItems: '+inShipItems);
            LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## childShipmentItemsMap: '+childShipmentItemsMap);

            if(destinationChildrenActions != null && inShipItems != null) {
                for (Bit2Shop__Stock_Action__c destinationAction : destinationChildrenActions) {

                    LogTracker.debugLog('Plc_StockActionsHnd', 'executeActions', '## Destination Action Detail:\n\n'+JSON.serialize(destinationAction));

                    //iterate through the outbound shipment line items
                    for (Bit2Shop__Shipment_Line_Item__c shipItem : inShipItems) {

                        //if(!shipmentItemsIds.isEmpty() && !shipmentItemsIds.contains(shipItem.Id)) continue;

                        //check if shipment and his children have been filtered out
                        //if (childShipmentItemsMap.get(shipItem.Id) == null) {
                        //    continue;
                        //}

                        applyAllActions(sourceObject, stockOrder, productStockMap, serialStock2Map, shipItem,
                                childShipmentItemsMap.get(shipItem.Id), destinationAction, productStockUpdateMap,
                                stockSerialUpdateMap, stockOrder.Bit2Shop__Destination_Warehouse_Id__c);
                    }
                }
            }
        }

        //updates stock serials and product stockrs
        //if (!Schema.sObjectType.Bit2Shop__Stock_Serials2__c.updateable){ throw new Plc_Exception('User does not have right to update Stock Serials2 objects.');}
        update stockSerialUpdateMap.values();
        //if (!Schema.sObjectType.Bit2Shop__Product_Stock__c.updateable){ throw new Plc_Exception('User does not have right to update Product Stock objects.');}
        update productStockUpdateMap.values();

        /*if(UserInfo.getUserId() == '0051j000000lNxVAAU' ) {
            system.assert(false, productStockUpdateMap+'');
        }*/

        /*
        * @author Emanuele Campese
        * @date Creation 23/01/2019
        * @description
        */
        //<
        compileRegisterData(stockOrdersIds,shipmentItemsIds);
        //<
        //
        LogTracker.debugLogEnd('Plc_StockActionsHnd', 'executeActions');
    }

    /**
     * Applies all Stock action details on a given Shipment Line Item
     *
     * @param stockOrder - Main stock order
     * @param productStockMap - Map of all product stocks
     * @param serialStock2Map - Map of all stock serials
     * @param shipItem - current shipment line item (product type(
     * @param childShipItems - current shipment line items children ship items (serial type)
     * @param action - current main action (master of its stock action details)
     * @param productStockUpdateMap - utility map to handle massive update on product stocks
     * @param stockSerialUpdateMap - utility map to handle massive update on stock serials
     */
    private static void applyAllActions(UpdatedObject sourceObject,
            Bit2Shop__StockOrder__c stockOrder,
            Map<ID, Bit2Shop__Product_Stock__c> productStockMap,
            Map<ID, Bit2Shop__Stock_Serials2__c> serialStock2Map,
            Bit2Shop__Shipment_Line_Item__c shipItem,
            List<Bit2Shop__Shipment_Line_Item__c> childShipItems,
            Bit2Shop__Stock_Action__c action,
            Map<ID, Bit2Shop__Product_Stock__c> productStockUpdateMap,
            Map<ID, Bit2Shop__Stock_Serials2__c> stockSerialUpdateMap,
            ID warehouseId
    ){

        LogTracker.debugLogBegin('Plc_StockActionsHnd', 'applyAllActions');

        //this method is triggered by the Stock Order Update
        Boolean isStockOrderUpdate = sourceObject == UpdatedObject.StockOrder;
        //easy to read condition (ShipmentItem update): this is here to allow for future objects
        Boolean isShipmentItemUpdate = !isStockOrderUpdate;

        LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## isStockOrderUpdate: '+isStockOrderUpdate);
        LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## isShipmentItemUpdate: '+isShipmentItemUpdate);
        //String tmp = '';
        Boolean executedTmp = false;
        //iterate through the action details to apply actions
        for (Bit2Shop__StockActionsDetail__c actDetail : action.Bit2Shop__StockActionsDetails__r) {

            LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## actDetail: '+JSON.serialize(actDetail));

            //Applying only the Stock Order/Shipment Item status check on Plc_StatusTrigger__c
            if (String.isBlank(action.Plc_StatusTrigger__c)) {
                continue;
            }

            //"Serial" action (on Product stock) but the shipment is of type Product
            // (no child shipments of type serial found)
            if (actDetail.Plc_ProductType__c == STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL
                    && childShipItems.isEmpty()){
                continue;
            }

            //checks stock order status
            List<String> statusTriggerSplit = action.Plc_StatusTrigger__c.split('\\.');

            if(statusTriggerSplit.size() != 2
                    && statusTriggerSplit.size() != 3 ){
                throw new Plc_Exception('Invalid Stock Action Details configuration ['+actDetail.Id+']');
            }

            String statusObject = statusTriggerSplit[0];
            String statusValue = statusTriggerSplit[1];
            String receivedValue = (statusTriggerSplit.size() == 3)?statusTriggerSplit[2]:null;

            //tmp+='  '+statusObject+' '+statusValue+' '+receivedValue+'\n';

            LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## (statusObject, statusValue, receivedValue) = ('+statusObject+', '+ statusValue+', '+ receivedValue+')');
            //actions are not triggered by status change of the current object
            if((isStockOrderUpdate
                    && statusObject != STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER)
                    || (isShipmentItemUpdate
                    && statusObject != STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM)) {
                continue;
            }

            //skip if stock order status is wrong
            if(isStockOrderUpdate
                    && statusObject == STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER
                    && stockOrder.Bit2Shop__Status__c != statusValue) {
                continue;
            }

            if(actDetail.Plc_ProductType__c == STOCK_ACTION_DETAIL_PRODUCT_TYPE_PRODUCT
                    || (actDetail.Plc_ProductType__c == STOCK_ACTION_DETAIL_PRODUCT_TYPE_BOTH
                    && childShipItems.isEmpty())){
                //product action

                Bit2Shop__Product_Stock__c prodStock = productStockMap.get(shipItem.Bit2Shop__Product_Stock_Id__c);

                LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## prodStock (before): '+prodStock);
                LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '#### isShipmentItemUpdate: '+isShipmentItemUpdate);
                LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '#### statusObject: '+statusObject);
                LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '#### shipItem.Bit2Shop__Status__c: '+shipItem.Bit2Shop__Status__c);
                LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '#### shipItem.Bit2Shop__Received_Status__c: '+shipItem.Bit2Shop__Received_Status__c);

                //skip if shipment line items status is wrong
                if(isShipmentItemUpdate
                        && statusObject == STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                        && (shipItem.Bit2Shop__Status__c != statusValue
                        /*|| shipItem.Bit2Shop__Received_Status__c != receivedValue*/)) {
                    continue;
                }

                executedTmp = true;
                //tmp+=actDetail.id+' - '+actDetail.Plc_ProductType__c+'>'+actDetail.Bit2Shop__Target_Object__c+' '+shipItem.Plc_ShipmentType__c+'\n';
                prodStock = applyProductStockAction(shipItem, prodStock, actDetail);

                LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## prodStock (after): '+prodStock);

                //product stock has not been elaborated by the action
                if(prodStock == null){
                    throw new Plc_Exception('Invalid stock order [0]');
                    //continue;
                }

                productStockUpdateMap.put(prodStock.Id, prodStock);

            }else if(actDetail.Plc_ProductType__c == STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL
                    || (actDetail.Plc_ProductType__c == STOCK_ACTION_DETAIL_PRODUCT_TYPE_BOTH
                    && !childShipItems.isEmpty())){
                //serial action

                //iterates on shipment line items of type Serial (children of main shipment)
                for(Bit2Shop__Shipment_Line_Item__c serialShipItem : childShipItems) {

                    Bit2Shop__Stock_Serials2__c serStock = serialStock2Map.get(serialShipItem.Plc_StockSerial__c);

                    //skip if shipment line items status is wrong
                    if (isShipmentItemUpdate
                            && statusObject == STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                            && (serialShipItem.Bit2Shop__Status__c != statusValue
                            || serialShipItem.Bit2Shop__Received_Status__c != receivedValue)) {
                        continue;
                    }

                    executedTmp = true;


                    Bit2Shop__Product_Stock__c prodStock = productStockMap.get(shipItem.Bit2Shop__Product_Stock_Id__c);

                    //action on stock serial
                    if (actDetail.Bit2Shop__Target_Object__c == STOCK_ACTION_TARGET_OBJECT_STOCKERIAL){

                        serStock = applyStockSerialAction(serialShipItem, serStock, actDetail, prodStock);

                        //stock serial object has not been elaborated by the action
                        if (serStock == null){
                            throw new Plc_Exception('Invalid serial stock [1]');
                            //continue;
                        }

                        stockSerialUpdateMap.put(serStock.Id, serStock);

                    }else if(actDetail.Bit2Shop__Target_Object__c == STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK){
                        //action on related product stock (of the parent Shipment line item)

                        LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## prodStock for before (after): '+prodStock);

                        prodStock = applyProductStockAction(serialShipItem, prodStock, actDetail);

                        LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '## prodStock for serial (after): '+prodStock);

                        //product stock has not been elaborated by the action
                        if(prodStock == null){
                            throw new Plc_Exception('Invalid stock order [1]');
                            //continue;
                        }

                        //tmp+=actDetail.id+' '+actDetail.Plc_ProductType__c+' '+actDetail.Bit2Shop__Target_Object__c+' '+shipItem.Plc_ShipmentType__c+'\n';

                        productStockUpdateMap.put(prodStock.Id, prodStock);
                    }
                }
            }
        }
        //Plc_ShipmentLineItemTriggerHnd.TMP += ('\n'+tmp);
        /*if(UserInfo.getUserId() == '0051j000000lNxVAAU' &&  executedTmp ) {
            system.assert(false, isStockOrderUpdate+' > '+tmp+' '+productStockUpdateMap);
        }*/

        LogTracker.debugLogEnd('Plc_StockActionsHnd', 'applyAllActions');
    }

    /**
     * Applies a stock action of type "Product"
     */
    private static Bit2Shop__Product_Stock__c applyProductStockAction(Bit2Shop__Shipment_Line_Item__c shipItem,
            Bit2Shop__Product_Stock__c prodStock,
            Bit2Shop__StockActionsDetail__c actDetail){

        LogTracker.debugLogBegin('Plc_StockActionsHnd', 'applyProductStockAction');
        //invalid target object name
        if(actDetail.Bit2Shop__Target_Object__c != STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK) {
            return null;
        }

        //product stock field where new value should be applied
        String targetField = actDetail.Bit2Shop__Target_Counter__c;
        String action = actDetail.Bit2Shop__Target_Action__c;
        Integer quantity = null;
        if(shipItem.Plc_ShipmentType__c == Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_INBOUND){
            quantity = (Integer)shipItem.Bit2Shop__Received_Quantity__c;
            //"removal" could have only the "Bit2Shop__Requested_Quantity__c" and not the "Bit2Shop__Received_Quantity__c"
            if(quantity == null){
                quantity = (Integer)shipItem.Bit2Shop__Requested_Quantity__c;
            }
        }else{
            quantity = (Integer)shipItem.Bit2Shop__Requested_Quantity__c;
        }
        if(quantity == null) {
            quantity = 0;
        }

        if(String.isBlank(targetField) || String.isBlank(action)){
            throw new Plc_Exception('Invalid Stock Action Details configuration: missing target field or action ['+actDetail.Id+']');
        }

        //gets current quantity
        Integer currentQty = 0;
        try{
            Decimal tmp = (Decimal)prodStock.get(targetField);
            if(tmp == null) {
                tmp = 0;
            }
            currentQty = Integer.valueOf(tmp);
        }catch(Exception ex){
            throw new Plc_Exception('Cannot read Stock Action\'s counter on Product Stock ['+actDetail.Id+', '+prodStock.Id+']. Details: '+ex.getMessage());
        }

        //applies different actions on quantity
        if(action == STOCK_ACTION_TARGET_ACTION_INCREASE){
            currentQty += quantity;
        }else if(action == STOCK_ACTION_TARGET_ACTION_DECREASE){
            currentQty -= quantity;
        }else{
            throw new Plc_Exception('Stock Action Details with Target Action ('+action+') is unsupported for Product Stock ['+actDetail.Id+']');
        }
        prodStock.put(targetField, currentQty);



        LogTracker.debugLogEnd('Plc_StockActionsHnd', 'applyProductStockAction');
        return prodStock;
    }

    /**
     * Applies a stock action of type "Serial"
     */
    private static Bit2Shop__Stock_Serials2__c applyStockSerialAction(Bit2Shop__Shipment_Line_Item__c shipItem,
            Bit2Shop__Stock_Serials2__c serStock,
            Bit2Shop__StockActionsDetail__c actDetail,
            Bit2Shop__Product_Stock__c prodStock){

        //LogTracker.debugLogBegin('Plc_StockActionsHnd', 'applyStockSerialAction');
        //invalid target object name
        if(actDetail.Bit2Shop__Target_Object__c != STOCK_ACTION_TARGET_OBJECT_STOCKERIAL) {
            return null;
        }

        //stock serial2 field where new value should be applied
        String targetField = actDetail.Plc_TargetField__c;
        String targetValue = actDetail.Bit2Shop__Target_Field_Value__c;
        String action = actDetail.Bit2Shop__Target_Action__c;

        //custom action: this moves the serial to the specific warehouse
        if(action == STOCK_ACTION_TARGET_ACTION_MOVETOWAREHOUSE){
            serStock.Bit2Shop__Warehouse_Id__c = prodStock.Bit2Shop__Warehouse_Id__c;
            serStock.Bit2Shop__Product_Stock_Id__c = prodStock.Id;
        }else if(action.startsWith(STOCK_ACTION_TARGET_ACTION_UPDATEFIELD)) {
            if (String.isBlank(targetField)) {
                throw new Plc_Exception('Invalid Stock Action Details configuration: missing target field [' + actDetail.Id + ']');
            }

            //applies new field's value
            try {
            /** [START MOD 20/03/2019 13:46]@Author:marco.lebellini@/webresults.it @Description: NEXIPLC-452**/
                //serStock.put(targetField, targetValue);
                //LogTracker.debugLog('Plc_StockActionsHnd', 'applyStockSerialAction', ' targetValue >> ' + targetValue);
                Object parsedTargetValue = parseValue(STOCK_ACTION_TARGET_OBJECT_STOCKERIAL, targetField, targetValue);
                //LogTracker.debugLog('Plc_StockActionsHnd', 'applyStockSerialAction', ' parsedTargetValue >> ' + parsedTargetValue);
                serStock.put(targetField, parsedTargetValue);
            /** [END MOD 20/03/2019 13:47]@Author:marco.lebellini@/webresults.it @Description: NEXIPLC-452**/

                //stockSerialUpdateMap.put(serStock.Id, serStock);
            } catch (Exception ex) {
                throw new Plc_Exception('Cannot apply Stock Action on Serial Stock 2 [' + actDetail.Id + ', ' + serStock.Id + ']. Details: ' + ex.getMessage());
            }

        }else{
            throw new Plc_Exception('Stock Action Details with Target Action ('+action+') unsupported for Stock Serial 2 ['+actDetail.Id+']');
        }

        //LogTracker.debugLogEnd('Plc_StockActionsHnd', 'applyStockSerialAction');
        return serStock;
    }

    /*
     * @author Emanuele Campese
     * @date Creation 23/01/2019
     * @description
     */
    public static void compileRegisterData(List<ID> stockOrderIdsForActions, List<Id> shipmentItemsIds){

        LogTracker.debugLogBegin('Plc_StockActionsHnd', 'compileRegisterData');
        try{
            List<Bit2Shop__Stock_Serials2__c> listStockSerialToUpdate = new List<Bit2Shop__Stock_Serials2__c>();

            Set<Id> stockSerialShipDate = new Set<Id>();
            Set<Id> stockSerialApprov = new Set<Id>();
            Set<Id> stockSerialResoDaRip = new Set<Id>();
            Set<Id> stockSerialRip = new Set<Id>();
            Map<Id,Date> stockSerialShippingDate = new Map<Id,Date>();
            Map<Id,Date> stockOrderTakeInChargeDate = new Map<Id,Date>();
            Plc_SystemSettings__c settings = Plc_SystemSettings__c.getOrgDefaults();
            system.debug('==SettingsData=='+settings);
            if(settings.Plc_PurchaseWarrantyMonthsDelay__c==null){
                throw new Plc_Exception('Plc_PurchaseWarrantyMonthsDelay__c is Null');
            }
            Double x = double.valueOf(settings.Plc_PurchaseWarrantyMonthsDelay__c);
            Integer monthNumber = x.intValue();

            //retrieve all stock serial where Stock Order status = 'Taken in charge'
            LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', 'stockOrderIdsForActions=  '+stockOrderIdsForActions);
            LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', 'shipmentItemsIds= '+shipmentItemsIds);

            if(!stockOrderIdsForActions.isEmpty()){

                for(Bit2Shop__Shipment_Line_Item__c tempShipLineItem : [SELECT Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_ShippingDate__c,Bit2Shop__Type__c,
                        Plc_StockSerial__c//,Plc_StockSerial__r.Bit2Shop__Shipment_Date__c

                FROM Bit2Shop__Shipment_Line_Item__c
                WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c IN:stockOrderIdsForActions AND
                //FB 14-06-2019: Filtering sli
                      Id IN :shipmentItemsIds
                AND Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Status__c ='Taken in charge'
                AND Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c = 'APPR'
                AND Bit2Shop__Type__c='Serial' ]){

                    stockSerialShipDate.add(tempShipLineItem.Plc_StockSerial__c);
                    stockSerialShippingDate.put(tempShipLineItem.Plc_StockSerial__c,tempShipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_ShippingDate__c);

                }

                for(Bit2Shop__Stock_Serials2__c tempStockSerial: [SELECT Id,Bit2Shop__Shipment_Date__c,Plc_PurchaseDate__c,Plc_PurchaseWarrantyStartDate__c,Plc_PurchaseWarrantyEndDate__c,Plc_RepairWarrantyStartDate__c
                FROM Bit2Shop__Stock_Serials2__c
                WHERE Id IN:stockSerialShipDate]){

                    if(stockSerialShipDate.contains(tempStockSerial.Id)){

                        tempStockSerial.Bit2Shop__Shipment_Date__c = stockSerialShippingDate.get(tempStockSerial.Id);
                        listStockSerialToUpdate.add(tempStockSerial);

                    }
                }

                if(listStockSerialToUpdate.size()>0){
                    //if (!Schema.sObjectType.Bit2Shop__Stock_Serials2__c.updateable){ throw new Plc_Exception('User does not have right to update Stock Serials2 objects.');}
                    update listStockSerialToUpdate;
                }

            }

            listStockSerialToUpdate.clear();

            System.debug('ShipmentIds: '+shipmentItemsIds);
            if(!shipmentItemsIds.isEmpty()){

                for(Bit2Shop__Shipment_Line_Item__c shipLineItem : [SELECT Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c,Bit2Shop__Status__c,Bit2Shop__Received_Status__c,
                        Bit2Shop__Type__c,Plc_StockSerial__c,Bit2Shop__Shipment_Id__r.Bit2Shop__Sub_Type__c,Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TakenInChargeDate__c,Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_ShippingDate__c

                FROM Bit2Shop__Shipment_Line_Item__c
                WHERE ID IN:shipmentItemsIds
                AND (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c ='APPR' OR 
                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c = 'RESO_RIP' OR 
                Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c = 'C_RIP')
                AND Bit2Shop__Type__c='Serial']){

                    if(shipLineItem.Bit2Shop__Status__c == 'Closed' && shipLineItem.Bit2Shop__Received_Status__c=='Received' && shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Sub_Type__c == 'Inbound'){
                        if(shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c=='APPR'){
                            System.debug('#APPR#');
                            stockOrderTakeInChargeDate.put(shipLineItem.Plc_StockSerial__c,shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TakenInChargeDate__c);
                            stockSerialApprov.add(shipLineItem.Plc_StockSerial__c);
                        }
                    }else if(shipLineItem.Bit2Shop__Status__c == 'Closed' && shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Sub_Type__c == 'Outbound'){
                        if (shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c=='RESO_RIP'){
                            System.debug('#RESO_RIP#');
                            stockOrderTakeInChargeDate.put(shipLineItem.Plc_StockSerial__c,shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_ShippingDate__c);
                            stockSerialResoDaRip.add(shipLineItem.Plc_StockSerial__c);
                        }else if (shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_TransferDetail__r.Bit2Shop__Code__c=='C_RIP'){
                            System.debug('#C_RIP#');
                            stockOrderTakeInChargeDate.put(shipLineItem.Plc_StockSerial__c,shipLineItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_ShippingDate__c);
                            stockSerialRip.add(shipLineItem.Plc_StockSerial__c);
                        }
                    }
                }

                System.debug('StockSerialTakeInChargeDate: '+stockOrderTakeInChargeDate);
                System.debug('stockSerialApprov: '+stockSerialApprov);
                System.debug('stockSerialResoDaRip: '+stockSerialResoDaRip);
                System.debug('stockSerialRip: '+stockSerialRip);

                for(Bit2Shop__Stock_Serials2__c tempStockSerial: [SELECT Id,Bit2Shop__Shipment_Date__c,Plc_PurchaseDate__c,Plc_PurchaseWarrantyStartDate__c,Plc_PurchaseWarrantyEndDate__c,Plc_RepairWarrantyStartDate__c,Plc_RepairWarrantyEndDate__c
                FROM Bit2Shop__Stock_Serials2__c
                WHERE Id IN:stockSerialApprov
                OR Id IN:stockSerialResoDaRip OR Id IN:stockSerialRip]){

                    if(stockSerialApprov.contains(tempStockSerial.Id)){

                        tempStockSerial.Plc_PurchaseDate__c = stockOrderTakeInChargeDate.get(tempStockSerial.Id);
                        Date oldDate = stockOrderTakeInChargeDate.get(tempStockSerial.Id).addMonths(monthNumber);
                        Date newDate = date.newInstance(oldDate.year(),oldDate.month(),1);
                        tempStockSerial.Plc_PurchaseWarrantyStartDate__c = newDate;
                        listStockSerialToUpdate.add(tempStockSerial);

                    }
                    else if(stockSerialResoDaRip.contains(tempStockSerial.Id)){

                        if((tempStockSerial.Plc_PurchaseWarrantyEndDate__c == null) || (tempStockSerial.Plc_PurchaseWarrantyEndDate__c < System.TODAY() && (tempStockSerial.Plc_RepairWarrantyEndDate__c < System.TODAY() || tempStockSerial.Plc_RepairWarrantyEndDate__c==null)) ){
                            tempStockSerial.Plc_RepairWarrantyStartDate__c = stockOrderTakeInChargeDate.get(tempStockSerial.Id);
                            listStockSerialToUpdate.add(tempStockSerial);
                        }

                    }else if(stockSerialRip.contains(tempStockSerial.Id)){
                        System.debug('RIPARAZIONE: '+stockSerialRip);
                        tempStockSerial.Plc_SentForRepairDate__c = stockOrderTakeInChargeDate.get(tempStockSerial.Id);
                        listStockSerialToUpdate.add(tempStockSerial);
                        
                    }
                }
                System.debug('LISTTOUPDATE: '+listStockSerialToUpdate);
                if(listStockSerialToUpdate.size()>0){
                    //if (!Schema.sObjectType.Bit2Shop__Stock_Serials2__c.updateable){ throw new Plc_Exception('User does not have right to update Stock Serials2 objects.');}
                    update listStockSerialToUpdate;
                }

            }



        }catch(Exception ex){

            throw new Plc_Exception(ex.getMessage() + ' ' + ex.getStackTraceString());
        }

        LogTracker.debugLogEnd('Plc_StockActionsHnd', 'compileRegisterData');
    }

    /**
     * Gets the Shipment line Items Outbound for the given Shipment Line Items Inbound
     * Outbound line items are identified by:
     *  -   Same Shipment
     *  -   Same Product SKU (for Producta)
     *  -   Same Unique Serial (for Serial shipments)
     *
     * @param List of inbound shipment line items
     *
     */
    public static List<Bit2Shop__Shipment_Line_Item__c> moveOutboundShipments(List<ID> inboundItems){

        LogTracker.debugLogBegin('Plc_StockActionsHnd', 'moveOutboundShipments');

        Map<ID, Bit2Shop__Shipment_Line_Item__c> outboundItems = new Map<ID, Bit2Shop__Shipment_Line_Item__c>();
        if(inboundItems == null || inboundItems.isEmpty()) return null;

        //map of the inbound shipments queried again
        Map<ID, Bit2Shop__Shipment_Line_Item__c> inboundShipmentsMap = new Map<ID, Bit2Shop__Shipment_Line_Item__c>();

        //list of Stock Order IDs
        List<ID> stockOrderIds = new List<ID>();

        for(Bit2Shop__Shipment_Line_Item__c shipItem : [Select Id, Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c,
                Bit2Shop__Product_Stock_Id__c,
                Plc_StockSerial__c,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_SKU__c,
                Plc_StockSerial__r.Plc_DllSerialNumberUnique__c,
                Plc_StockSerial__r.Plc_EncodedSerialNumberUnique__c,
                Plc_StockSerial__r.Plc_ManufacturerSerialNumberUnique__c,
                Bit2Shop__Received_Status__c
        From Bit2Shop__Shipment_Line_Item__c Where ID IN :inboundItems]){

            inboundShipmentsMap.put(shipItem.Id, shipItem);
            stockOrderIds.add(shipItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c);

        }
        
        // Store outboundItems before the removal
        Map<ID, Bit2Shop__Shipment_Line_Item__c> inboundShipmentsMapCopy = inboundShipmentsMap.deepClone();

        //gets all outbounds of the same shipments
        for(Bit2Shop__Shipment_Line_Item__c outItem : [Select Id, Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c,
                Bit2Shop__Product_Stock_Id__c,
                Plc_StockSerial__c,
                Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_SKU__c,
                Plc_StockSerial__r.Plc_DllSerialNumberUnique__c,
                Plc_StockSerial__r.Plc_EncodedSerialNumberUnique__c,
                Plc_StockSerial__r.Plc_ManufacturerSerialNumberUnique__c
        From Bit2Shop__Shipment_Line_Item__c
        Where Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c IN :stockOrderIds
        AND Bit2Shop__Shipment_Id__r.RecordTypeId
                = :Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND,
                        Bit2Shop__Shipment__c.SObjectType.getDescribe().name)]){

            //iterate through all shipment items looking for a match: if found removes it from the map
            for(Bit2Shop__Shipment_Line_Item__c inItem : inboundShipmentsMap.values()){

                //matching stock order
                if(inItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c
                        != outItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c) {
                    continue;
                }

                if(inItem.Plc_StockSerial__c != null){
                    //Serial Type: matches any of the unique serials
                    if( /*(inItem.Plc_StockSerial__r.Plc_DllSerialNumberUnique__c != null
                            && inItem.Plc_StockSerial__r.Plc_DllSerialNumberUnique__c == outItem.Plc_StockSerial__r.Plc_DllSerialNumberUnique__c)
                            || (inItem.Plc_StockSerial__r.Plc_EncodedSerialNumberUnique__c != null
                            && inItem.Plc_StockSerial__r.Plc_EncodedSerialNumberUnique__c == outItem.Plc_StockSerial__r.Plc_EncodedSerialNumberUnique__c)
                            || (inItem.Plc_StockSerial__r.Plc_DllSerialNumberUnique__c != null
                            && inItem.Plc_StockSerial__r.Plc_ManufacturerSerialNumberUnique__c == outItem.Plc_StockSerial__r.Plc_ManufacturerSerialNumberUnique__c)*/
                            inItem.Plc_StockSerial__c == outItem.Plc_StockSerial__c){
                        inboundShipmentsMap.remove(inItem.Id);
                        outboundItems.put(inItem.Id, outItem);
                        break;
                    }
                }else if(inItem.Bit2Shop__Product_Stock_Id__c != null){
                    //Product Type: matches the product stock SKU
                    if(inItem.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_SKU__c == outItem.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_SKU__c){
                        inboundShipmentsMap.remove(inItem.Id);
                        outboundItems.put(inItem.Id, outItem);
                        break;
                    }
                }
            }
        }

        LogTracker.debugLog('Plc_StockActionsHnd', 'moveOutboundShipments', '### outboundItems'+outboundItems);
        
        List<Bit2Shop__Shipment_Line_Item__c> returnOutputsIs = new List<Bit2Shop__Shipment_Line_Item__c>();
        for(ID inboundId : outboundItems.keySet()){
            Bit2Shop__Shipment_Line_Item__c outboundItem = outboundItems.get(inboundId);
            outboundItem.Bit2Shop__Status__c = Plc_WorkOrderApxAct.SHIPMENT_STATUS_CLOSED;
            outboundItem.Bit2Shop__Received_Status__c = inboundShipmentsMapCopy.get(inboundId).Bit2Shop__Received_Status__c;
            
            returnOutputsIs.add(outboundItem);
        }

        if(!outboundItems.isEmpty()){
            //if (!Schema.sObjectType.Bit2Shop__Shipment_Line_Item__c.updateable){ throw new Plc_Exception('User does not have right to update Shipment line item objects.');}
            update outboundItems.values();
        }

        LogTracker.debugLogEnd('Plc_StockActionsHnd', 'moveOutboundShipments');
        return returnOutputsIs;

    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  20/03/2019 13:23
     *     * @description Convert targetFieldValue to fit correctly in targetField Data Type
     *     * @param targetObject - Parent Object of field
     *     * @param targetField - Target field API Name
     *     * @param targetValue - Value to update on it
     *     * @Modified by
     * *************************************************
     **/
    private static object parseValue(String targetObject, String targetField, String targetValue) {

        String targetObjectApiName;
        Object result;

        //FB 20-09-2019: Optimizing [START] 
        //LogTracker.debugLog('Plc_StockActionsHnd', 'parseValue', ' targetObject >> ' + targetObject);
        //LogTracker.debugLog('Plc_StockActionsHnd', 'parseValue', ' targetField >> ' + targetField);
        //LogTracker.debugLog('Plc_StockActionsHnd', 'parseValue', ' targetValue >> ' + targetValue);

        Schema.DescribeFieldResult field; 

        if (targetObject == STOCK_ACTION_TARGET_OBJECT_STOCKERIAL) {
            field = stockSerial2Schema.fields.getMap().get(targetField).getDescribe();
            //Older version
            //targetObjectApiName = 'Bit2Shop__Stock_Serials2__c'; 
        } else if (targetObject == STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK) {
            field = productStockSchema.fields.getMap().get(targetField).getDescribe();
            //Older version
            //targetObjectApiName = 'Bit2Shop__Product_Stock__c'; 
        } else {
            //in case of other target objects needed in future
        }

        //Older version
        //Schema.DescribeFieldResult field = Schema.getGlobalDescribe().get(targetObjectApiName).getDescribe().fields.getMap().get(targetField).getDescribe();

        //FB 20-09-2019: Optimizing [END] 
        
        if (field.getType() == Schema.DisplayType.DATE) {
            if (targetValue == Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Blank) {
                result = null;
            } else if (targetValue == Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Yesterday) {
                result = Date.today() - 1;
            } else if (targetValue == Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Today) {
                result = Date.today();
            } else if (targetValue == Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Tomorrow) {
                result = Date.today() + 1;
            } else if (targetValue == Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Next_Week) {
                result = Date.today() + 7;
            } else if (targetValue == Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Next_Month) {
                result = Date.today().addMonths(1);
            } else if (targetValue == Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Next_Year) {
                result = Date.today().addYears(1);
            }
        } else {
            result = targetValue;
        }

        return result;
    }

}