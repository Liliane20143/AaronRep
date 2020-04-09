/**
 * Plc_WorkOrderApxActTest - Apex Action for Work Order phase manager actions
 *
 * @author EM
 * @date Creation 28/12/2018
 * @testedIn Plc_WorkOrderApxActTest 
 * @errorcode [ERR:CL-03903ZZ]
 * 
 * @history
 * 2018-12-28 - EM - first implementation
 * 2019-04-15 - CM - NEXIPLC-513 implementation of 2 new operation type: ToReconfigureCorr and ToSubstituteCorr
 */
public without sharing class Plc_WorkOrderApxAct { //implements wrts_prcgvr.Interfaces_1_2.IApexActionBulk{

    private static final String CLASS_NAME = 'Plc_WorkOrderApxAct';

    //skips a shipment line items if already executed
    public static Set<ID> alreadyCalculated = new Set<ID>();

    //static context
    private static List<Bit2Shop__TransferDetail__c> staticTransferDetailsVal;
    public static List<Bit2Shop__TransferDetail__c> staticTransferDetails {
        get {
            if(staticTransferDetailsVal == null) {

                staticTransferDetailsVal = [
                    SELECT Id, Bit2Shop__Code__c
                    FROM Bit2Shop__TransferDetail__c
                    WHERE Bit2Shop__Code__c IN (:STOCK_ORDER_TRANSDETAIL_MESSAINCAMPO,
                                                :STOCK_ORDER_TRANSDETAIL_RITIRODALCAMPO,
                                                :STOCK_ORDER_TRANSDETAIL_DISATTIVAZIONE)
                ];
            }
            return staticTransferDetailsVal;
        }
        set;
    }

    private static List<Bit2Shop__Warehouse__c> staticWarehousesVal;
    public static List<Bit2Shop__Warehouse__c> staticWarehouses {
        get {
            if(staticWarehousesVal == null) {

                staticWarehousesVal = [
                    SELECT Id,
                           Plc_Alias__c,
                           Plc_Tipology__c,
                           Plc_LogisticDivision__c,
                           Bit2Shop__Dealer_Id__c,
                           Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                           Bit2Shop__Dealer_Id__r.OwnerId,
                           Bit2Shop__Inventory_CurrentPeriodAtConfirmation__c,
                           Bit2Shop__Dealer_Id__r.Bit2Shop__Group_Id__c,
                           Bit2Shop__Dealer_Id__r.Bit2Shop__Approver_Group_Id__c
                    FROM Bit2Shop__Warehouse__c
                    WHERE Plc_Tipology__c IN (:WAREHOUSE_TIPOLOGY_INSTALLED, 
                                              :WAREHOUSE_TIPOLOGY_IRRECOVERABLE)
                ];
            }
            return staticWarehousesVal;
        }
        set;
    }

    private static Map<String, Plc_TermId__c> termIdsByCodeMapVal = new Map<String, Plc_TermId__c>();
    public static Map<String, Plc_TermId__c> termIdsByCodeMap{
        get{
            return termIdsbyCodeMapVal;
        }
    }

    private static Map<String, Bit2Shop__Warehouse__c> warehousesByAliasMapVal = new Map<String, Bit2Shop__Warehouse__c>();
    public static Map<String, Bit2Shop__Warehouse__c> warehousesByAliasMap{
        get{
            return warehousesByAliasMapVal;
        }
    }

    //Represent the kind of flow for a given WO (Installation, Uninstallation and Deactivation are simple,
    //while Substitution has 2 different processes inside)
    public enum FlowType {
        Installation,
        Removal,
        Deactivation
    }

    //Apex Action constants
    //public static final String METHOD_CLOSE = 'close';
    //public static final String METHOD_CANCEL = 'cancel';
    //WorkOrderLineItems constants
    public static final String WOLI_OPERATION_TYPE_TO_INSTALL       { get { return Plc_Constants.WorkOrderLineItems.PlcOperationType_ToInstall; } }//'ToInstall';
    public static final String WOLI_OPERATION_TYPE_TO_REMOVE        { get { return Plc_Constants.WorkOrderLineItems.PlcOperationType_ToRemove; } }//'ToRemove';
    public static final String WOLI_OPERATION_TYPE_TO_SUBSTITUTE    { get { return Plc_Constants.WorkOrderLineItems.PlcOperationType_ToSubstitute; } }//'ToSubstitute';
    public static final String WOLI_OPERATION_TYPE_TO_DEACTIVATE    { get { return Plc_Constants.WorkOrderLineItems.PlcOperationType_ToDeactivate; } }//'ToDeactivate';
    public static final String WOLI_OPERATION_TYPE_TO_RECONFCORR    { get { return Plc_Constants.WorkOrderLineItems.PlcOperationType_ToReconfigureCorr; } }//'ToReconfigureCorr';
    public static final String WOLI_OPERATION_TYPE_TO_SUBSTCORR     { get { return Plc_Constants.WorkOrderLineItems.PlcOperationType_ToSubstituteCorr; } }//'ToSubstituteCorr';
    public static final String WOLI_OPERATION_TYPE_NO_OPERATION     { get { return Plc_Constants.WorkOrderLineItems.PlcOperationType_NoOperation; } }//'NoOperation';
    
    public static final String WOLI_STATUS_EXECUTED                 { get { return Plc_Constants.WorkOrderLineItems.Status_Executed; } }//'Executed';
    public static final String WOLI_STATUS_NOT_EXECUTED             { get { return Plc_Constants.WorkOrderLineItems.Status_NotExecuted; } }//'NotExecuted';
    //Asset constants
    public static final String ASSET_RECORDTYPE_TECHNICAL_ASSET { get { return Plc_Constants.Asset.RecordType_PlcTechnicalAsset; } }//'Plc_TechnicalAsset';
    public static final String ASSET_STATUS_INSTALLED           { get { return Plc_Constants.Asset.Status_Installed; } }//'Installed';
    public static final String ASSET_STATUS_UNINSTALLED         { get { return Plc_Constants.Asset.Status_Uninstalled; } }//'Uninstalled';
    //Plc_Reservation__c constants
    public static final String RESERVATION_STATUS_NOT_RESERVED { get { return Plc_Constants.PLC_Reservation.PlcStatus_NotReserved; } }//'NotReserved';
    //Bit2Shop__StockOrder__c
    public static final String STOCK_ORDER_STATUS_GENERATED             { get { return Plc_Constants.B2S_StockOrder.B2S_Status_Generated; } }//'Generated';
    public static final String STOCK_ORDER_STATUS_CLOSED                { get { return Plc_Constants.B2S_StockOrder.B2S_Status_Closed; } }//'Closed';
    public static final String STOCK_ORDER_STATUS_ASSIGNED              { get { return Plc_Constants.B2S_StockOrder.B2S_Status_Assigned; } }//'Assigned';
    public static final String STOCK_ORDER_RECORDTYPE_TRANSFER          { get { return Plc_Constants.B2S_StockOrder.RecordType_Transfer; } }//'Transfer';
    public static final String STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP { get { return Plc_Constants.B2S_TransferDetail.B2S_TranferType_Stock2OtherShop; } }//'Stock2OtherShop';
    public static final String STOCK_ORDER_TRANSDETAIL_MESSAINCAMPO     { get { return Plc_Constants.B2S_TransferDetail.B2S_Code_MessaInCampo; } }//'MESSAINCAMPO';
    public static final String STOCK_ORDER_TRANSDETAIL_RITIRODALCAMPO   { get { return Plc_Constants.B2S_TransferDetail.B2S_Code_Ritiro; } }//'RITIRO';
    public static final String STOCK_ORDER_TRANSDETAIL_DISATTIVAZIONE   { get { return Plc_Constants.B2S_TransferDetail.B2S_Code_Disatt; } }//'DISATT';
    //Work Order
    //public static final String WO_RECORDTYPE_INSTALLATION   { get { return Plc_Constants.WorkOrder.RecordType_Installation; } }//'Installation';
    //public static final String WO_RECORDTYPE_UNINSTALLATION { get { return Plc_Constants.WorkOrder.RecordType_Uninstallation; } }//'Uninstallation';
    //public static final String WO_RECORDTYPE_DEACTIVATION   { get { return Plc_Constants.WorkOrder.RecordType_Deactivation; } }//'Deactivation';
    //public static final String WO_RECORDTYPE_SUBSTITUTION   { get { return Plc_Constants.WorkOrder.RecordType_Substitution; } }//'Substitution';
    //Product Stock
    public static final String PRODUCT_STOCK_RECORDTYPE_CURRENT     { get { return Plc_Constants.B2S_ProductStock.RecordType_Current; } }//'Current';
    public static final String PRODUCT_STOCK_INVENTORY_LEVEL_NEW    { get { return Plc_Constants.B2S_ProductStock.B2S_InventoryLevel_New; } }//'New';
    //Warehouse
    public static final String WAREHOUSE_TIPOLOGY_INSTALLED     { get { return Plc_Constants.B2S_Warehouse.PlcTipology_Installed; } }//'Installed';
    public static final String WAREHOUSE_TIPOLOGY_IRRECOVERABLE { get { return Plc_Constants.B2S_Warehouse.PlcTipology_Irrecoverable; } }//'Irrecoverable';
    //Configuration (NE__Order__c)
    public static final String CONFIGURATION_RECORDTYPE_STOCK_ORDER { get { return Plc_Constants.NE_Order.RecordType_StockOrder; } }//'Stock_Order';
    public static final String CONFIGURATION_ORDER_STATUS_COMPLETED { get { return Plc_Constants.NE_Order.NE_OrderStatus_Completed; } }//'Completed';
    public static final String CONFIGURATION_STATUS_INPROGRESS      { get { return Plc_Constants.NE_Order.NE_ConfigurationStatus_InProgress; } }//'In progress';
    //Configuration Item (NE__OrderItem__c)
    public static final String CONFIG_ITEM_RECORDTYPE_STANDARD  { get { return Plc_Constants.NE_OrderItem.RecordType_Standard; } }//'StanStandarddard';
    public static final String CONFIG_ITEM_STATUS_COMPLETED     { get { return Plc_Constants.NE_OrderItem.NE_Status_Completed; } }//'Completed';
    //Shipment
    public static final String SHIPMENT_RECORDTYPE_INBOUND  { get { return Plc_Constants.B2S_Shipment.RecordType_InboundShipment; } }//'Inbound_Shipment';
    public static final String SHIPMENT_RECORDTYPE_OUTBOUND { get { return Plc_Constants.B2S_Shipment.RecordType_OutboundShipment; } }//'Outbound_Shipment';
    public static final String SHIPMENT_STATUS_CLOSED       { get { return Plc_Constants.B2S_Shipment.B2S_Status_Closed; } }//'Closed';
    public static final String SHIPMENT_STATUS_PENDING      { get { return Plc_Constants.B2S_Shipment.B2S_Status_Pending; } }//'Pending';
    public static final String SHIPMENT_SUBTYPE_INBOUND     { get { return Plc_Constants.B2S_Shipment.B2S_Subtype_Inbound; } }//'Inbound';
    public static final String SHIPMENT_SUBTYPE_OUTBOUND    { get { return Plc_Constants.B2S_Shipment.B2S_Subtype_Outbound; } }//'Outbound';
    public static final String SHIPMENT_TYPE_FINAL          { get { return Plc_Constants.B2S_Shipment.B2S_Type_Final; } }//'Final';
    //Shipment Line Item
    public static final String SHIPMENT_ITEM_RECORDTYPE_PRODUCT          { get { return Plc_Constants.B2S_ShipmentLineItem.RecordType_Product; } }//'Shipment_Line_Item_Product';
    public static final String SHIPMENT_ITEM_RECORDTYPE_SERIAL           { get { return Plc_Constants.B2S_ShipmentLineItem.RecordType_Serial; } }//'Shipment_Line_Item_Serial';
    public static final String SHIPMENT_ITEM_TYPE_PRODUCT                { get { return Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Product; } }//'Product';
    public static final String SHIPMENT_ITEM_TYPE_SERIAL                 { get { return Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Serial; } }//'Serial';
    public static final String SHIPMENT_ITEM_STATUS_CLOSED               { get { return Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Closed; } }//'Closed';
    public static final String SHIPMENT_ITEM_STATUS_PENDING              { get { return Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Pending; } }//'Pending';
    public static final String SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED    { get { return Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_Received; } }//'Received';
    public static final String SHIPMENT_ITEM_REVEICED_STATUS_NOTRECEIVED { get { return Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_NotReceived; } }//'Not Received';
    //__share
    public static final String SHARE_ACCESS_LEVEL_EDIT  { get { return Plc_Constants.ObjectShare.AccessLevel_Edit; } }//'Edit';
    public static final String SHARE_ROW_CAUSE_MANUAL   { get { return Plc_Constants.ObjectShare.RowClause_Manual; } }//'Manual';
    //external catalog item
    public static final String EXT_CATALOG_ITEM_CATEGORY_PRODUCT { get { return Plc_Constants.B2WExtCat_ExternalCatalogItem.PlcCategoryProduct; } }//'Product';

    //Serial stock
    public static final String SERIAL_STOCK_STATUS_TOBEVERIFIED { get { return Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeVerified; } }//'To be verified';

    //Internal
    //installation recordtype (for internal logic)
    //public static final ID woRtypeInstallationId = Plc_Utils.getRecordTypeId(WO_RECORDTYPE_INSTALLATION, WorkOrder.SObjectType.getDescribe().name);
    //public static final ID woRtypeUninstallationId = Plc_Utils.getRecordTypeId(WO_RECORDTYPE_UNINSTALLATION, WorkOrder.SObjectType.getDescribe().name);
    //public static final ID woRtypeDeactivationId = Plc_Utils.getRecordTypeId(WO_RECORDTYPE_DEACTIVATION, WorkOrder.SObjectType.getDescribe().name);
    //public static final ID woRtypeSubstitutionId = Plc_Utils.getRecordTypeId(WO_RECORDTYPE_SUBSTITUTION, WorkOrder.SObjectType.getDescribe().name);


    public class ClassContext {
        //maps new TermIds to WOli
        public Map<ID, Plc_TermId__c> woliToTermId = new Map<ID, Plc_TermId__c>();
        //maps new Assets to WOli
        public Map<String, Asset> woliToAsset = new Map<String, Asset>();
        //reservations list to chage status (NEXIPLC-210)
        public Map<Id, Plc_Reservation__c> woliToReservation = new Map<Id, Plc_Reservation__c>();
        //maps stock orders to WO (one per Work Order)
        public Map<String,Bit2Shop__StockOrder__c> woToStockOrders = new Map<String,Bit2Shop__StockOrder__c>();
        //warehouses to aliases
        public Map<String, Bit2Shop__Warehouse__c> aliasToWarehouses = new  Map<String, Bit2Shop__Warehouse__c>();
        //map of needed transfer details
        public Map<String, Bit2Shop__TransferDetail__c> transferDetailsMap = new Map<String, Bit2Shop__TransferDetail__c>();
        //map of catalog items to their aliases
        public Map<String, B2WExtCat__External_Catalog_Item__c> extCatalogItemsMap = new Map<String, B2WExtCat__External_Catalog_Item__c>();
        //map product stock to WOLI (destination and origin)
        public Map<String, Bit2Shop__Product_Stock__c> woliToProductStocksOrigMap = new Map<String, Bit2Shop__Product_Stock__c>();
        public Map<String, Bit2Shop__Product_Stock__c> woliToProductStocksDestMap = new Map<String, Bit2Shop__Product_Stock__c>();
        //installed warehouses by Logistic Division
        public Map<String, Bit2Shop__Warehouse__c> divisionToInstalledWarehousesMap = new Map<String, Bit2Shop__Warehouse__c>();
        //irrecoverable warehouses by Logic Division
        public Map<String, Bit2Shop__Warehouse__c> divisionToIrrecoverableWarehousesMap = new Map<String, Bit2Shop__Warehouse__c>();
        //all warehouses by ID
        public Map<ID, Bit2Shop__Warehouse__c> allWareshousesMap = new Map<Id, Bit2Shop__Warehouse__c>();
        //Configuration (NE__Order__c) mapped to WO
        public Map<String, NE__Order__c> woToConfigurationsMap = new Map<String, NE__Order__c>();
        //maps SKU+Warehouse to Product Stock: SKU+Warehouse is the key for a given Product Stock
        public Map<String, Bit2Shop__Product_Stock__c> skuWHtoProductStockMap = new Map<String, Bit2Shop__Product_Stock__c>();
        public Map<String, String > skuWHtoProductStockMapToRetrieve = new Map<String, String>();

        public List<ID> extCatItemForProdStockList = new List<ID>();//all ExtcatItem found on woli

        //maps Work Order ID to its list of Configuration Items: the list of Config.Items is
        //actually a map that maps Product Stock ID with the actual configuration item
        public Map<String, Map<ID, NE__OrderItem__c>> woToConfigItems = new Map<String, Map<ID, NE__OrderItem__c>>();
        //maps Work Order ID to its list of Shipments: the list of Shipments is
        //actually a map that maps Product Stock ID with the actual configuration item
        public Map<String, Map<ID, Bit2Shop__Shipment__c>> woToShipmentsInbound = new Map<String, Map<ID, Bit2Shop__Shipment__c>>();
        public Map<String, Map<ID, Bit2Shop__Shipment__c>> woToShipmentsOutbound = new Map<String, Map<ID, Bit2Shop__Shipment__c>>();
        //maps Shipment ID to the Shipment Line Item related to the Product Stock (and not the serial)
        public Map<ID, Bit2Shop__Shipment_Line_Item__c> shipmentToShipmentLineItemProductInbound = new Map<ID, Bit2Shop__Shipment_Line_Item__c>();
        public Map<ID, Bit2Shop__Shipment_Line_Item__c> shipmentToShipmentLineItemProductOutbound = new Map<ID, Bit2Shop__Shipment_Line_Item__c>();
        //maps Serial Numbers to Stock Serial 2
        public Map<String, Bit2Shop__Stock_Serials2__c> serialsToSerialStock2 = new Map<String, Bit2Shop__Stock_Serials2__c>();
        //maps serial numbers to TermIds (for uninstall)
        public Map<String, Plc_TermId__c> codeToTermIds = new Map<String, Plc_TermId__c>();
        //maps TermId code with all its assets
        public Map<Id, List<Asset>> termIdToAssetMap = new Map<Id, List<Asset>>();
        //maps WOLI to Serial Stock 2
        public Map<String, Bit2Shop__Stock_Serials2__c> woliToStockSerialsMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
        //id to stock serials
        public Map<ID, Bit2Shop__Stock_Serials2__c> stockSerialsMap = new Map<ID, Bit2Shop__Stock_Serials2__c>();
        //Asset id to Asset
        public Map<Id, Asset> assetsMap = new Map<Id, Asset>();
        //this map is used to trigger the correct status transition for Stock Orders
        public Map<String, String> stockOrdersTransitionsMap = new Map<String, String>();
        //this map is used to trigger the correct status transition for Shipment Line Items
        public List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItemsTransitions = new List<Bit2Shop__Shipment_Line_Item__c>();

        // This list is used to insert all new termId
        public List<Plc_TermId__c> termIdToInsertList = new  List<Plc_TermId__c>();
        //
        //FB 13-02-2019
        public Map<String, String> subAssetToNewAsset = new Map<String, String>();

        //Added by Dam (this is actually no more needed because the overall method has been
        //moved to afterUpdate, but let's avoid unnecessary refactoring)
        //maps woAlias to wo
        //this is used because some fields are setup in the current "before update" event and so the following
        //query on WorkOrderLineItem.WorkOrder does not have the field set up
        public Map<String, Workorder> woMap = new Map<String, Workorder>();
        //Added by Dam

        //all line items associated with the incoming Work Orders
        public Map<ID, WorkOrderLineItem> lineItemsMap = new Map<ID, WorkOrderLineItem>();
        //FB 28062019 - Adding substitute Corr accessories management [START]
        //Used to match asset id with the its termId
        public Map<String, String> assetToTermId = new Map<String, String>();
        //FB 28062019 - Adding substitute Corr accessories management [END]
        //FB 03072019 - NEXIPLC-613: Adding match from serial to asset [START]
        public Map<String, String> serialToAssetMap = new Map<String, String>();
        //FB 03072019 - NEXIPLC-613 [END]
        //FB 20190711 NEXIPLC-661: Workaround in order to decoupling stock order warehouse 
        //to Shipment/Shipment Line Items warehouses from which products are sent [START]
        public Map<String, String> sliProductOutToProductStockMap = new Map<String, String>();
        public Map<String, String> shipmentOutToProductStockMap = new Map<String, String>();
        //FB 20190711 NEXIPLC-661 [END] 
    }

    /**
     * wrts_prcgvr.Interfaces_1_2.IApexActionBulk implementation
     * @code 01
     *
     * @param Object params
     *
     * @return Boolean (not required at the moment)
     */
//    global Object execute(Object params){
//
//        LogTracker.debugLogBegin(CLASS_NAME, 'execute');
//        //gets
//        Map<String, Object> paramMap = (Map<String, Object>)params;
//
//        //System.debug('Plc_WorkOrderApxAct.execute::paramMap\n'+ JSON.serializePretty(paramMap));
//
//        if(paramMap == null){
//            throw new Plc_Exception('Unexpected null parameters [paramMap]');
//        }
//        Map<String, Object> parameter = (Map<String, Object>) paramMap.get('parameter');
//        if(parameter == null ){
//            throw new Plc_Exception('Unexpected null parameters [parameter]');
//        }
//        String method = (String) paramMap.get('method');
//        if(method == null ){
//            throw new Plc_Exception('Unexpected null parameters [method]');
//        }
//
//        List<sObject> records = (List<sObject>) parameter.get('records');
//        if(records == null ){
//            throw new Plc_Exception('Unexpected null parameters [records]');
//        }
//
//        Map<Id, wrts_prcgvr__PhaseTransition__c> transitionsMap
//                = (Map<Id, wrts_prcgvr__PhaseTransition__c>) parameter.get('transitionsMap');
//
//        if(transitionsMap == null ){
//            throw new Plc_Exception('Unexpected null parameters [transitionsMap]');
//        }
//
//        if(method == METHOD_CLOSE){
//            return oncloseWorkOrder(records, transitionsMap);
//        }else if(method == METHOD_CANCEL){
//            return oncancelWorkOrder(records, transitionsMap);
//        }
//
//        //unsupported method
//        throw new Plc_Exception('Unsupported method in ApexAction ['+method+']');
//
//        LogTracker.debugLogEnd(CLASS_NAME, 'execute');
//        throw new Plc_Exception('[ERR:CL-0390101] Unsupported ApexAction');
//    }

    /**
     * Actual implementation of the "after close" Work Order logic (should be called by the afterUpdate trigger)
     * @code 02
     *
     * @param workOrdersList
     *
     * @return
     */
    public static Object onCloseWorkOrder(List<WorkOrder> workOrdersList){

        LogTracker.debugLogBegin(CLASS_NAME, 'oncloseWorkOrder');

        Object result = oncloseWorkOrderWithFilters(workOrdersList, null);

        LogTracker.debugLogEnd(CLASS_NAME, 'oncloseWorkOrder');
        return result;
    }

    /**
     * Elaborates the "close" action of Work Orders
     * This method can be called adding a filtered list of WO line items (e.g. called outside a trigger)
     * @code 03
     *
     * @param records List<sObject>
     *
     * @return Boolean (not required at the moment)
     */
    public static Object onCloseWorkOrderWithFilters(List<WorkOrder> workOrdersList, List<WorkOrderLineItem> lineItemsList){

        LogTracker.debugLogBegin(CLASS_NAME, 'oncloseWorkOrderWithFilters');

        Savepoint sp = Database.setSavepoint();
        try{
            ClassContext context = new ClassContext();


            //Added by Dam (this is actually no more needed because the overall method has been
            //moved to afterUpdate, but let's avoid unnecessary refactoring)
            //maps woAlias to wo
            //this is used because some fields are setup in the current "before update" event and so the following
            //query on WorkOrderLineItem.WorkOrder does not have the field set up*/
            context.woMap = new Map<String, Workorder>((List<Workorder>)workOrdersList);
            //Added by Dam

            //get all line items associated with the incoming Work Orders
            context.lineItemsMap = new Map<ID, WorkOrderLineItem>([Select Id,
                    WorkOrderId, AssetId, Status, Plc_TermId__c, Plc_TermId__r.Plc_TermIdCode__c,Plc_Closed__c,
                    Plc_ExternalTermId__c, Plc_OperationType__c,
                    Plc_SerialNumber__c, Plc_ReferenceExternalCatalogItem__c,
                    Plc_Reservation__r.Id,
                    Plc_Reservation__r.Plc_Status__c,
                    //FB 03072019 - NEXIPLC-613 [START]
                    WorkOrder.Street, WorkOrder.City, WorkOrder.PostalCode, Plc_Parent__r.Plc_StockSerial__c,
                    //FB 03072019 - NEXIPLC-613 [END]
                    Plc_Parent__c, Plc_Parent__r.AssetId, Plc_Parent__r.Asset.Plc_TermId__c,
                    Plc_Parent__r.Asset.Plc_StockSerial__c,
                    //Plc_Reservation__r.Plc_ProductStock__c,
                    //Plc_Reservation__r.Plc_ProductStock__r.Bit2Shop__Warehouse_Id__r.Plc_Contact__c,
                    //Plc_Reservation__r.Plc_ProductStock__r.Bit2Shop__Warehouse_Id__r.Plc_Contact__r.AccountId,
                    WorkOrder.AccountId, WorkOrder.Plc_ExternalAccount__c, WorkOrder.RecordTypeId,
                    WorkOrder.Plc_LegacyServicePointId__c, WorkOrder.Plc_LegacyWarehouseId__c,
                    WorkOrder.Id, WorkOrder.Plc_Alias__c, WorkOrder.Plc_LegacyAccountId__c,
                    WorkOrder.Plc_Abi__c, WorkOrder.Plc_FiscalCode__c, WorkOrder.Plc_SiaCode__c,
                    WorkOrder.Plc_SourceLegacySystem__c
            From WorkOrderLineItem Where WorkOrderId IN :workOrdersList and Plc_Closed__c = false]);

            //if there are incoming line items on this method, all other line items are filtered out
            if(lineItemsList !=null && !lineItemsList.isEmpty()){
                Map<ID, WorkOrderLineItem> tempMap = new Map<ID, WorkOrderLineItem>(lineItemsList);
                for(WorkOrderLineItem woli : context.lineItemsMap.values()){
                    if(!tempMap.containsKey(woli.Id)){
                        context.lineItemsMap.remove(woli.Id);
                    }
                }
            }
            LogTracker.debugLog(CLASS_NAME, 'execute', '## lineItemsMap: ' + context.lineItemsMap);

            //list of all warehouse aliases (for massive query)
            List<String> warehouseAliasesList = new List<String>();
            //** get needed transfer details **
            for(Bit2Shop__TransferDetail__c td : staticTransferDetails){
                context.transferDetailsMap.put(td.Bit2Shop__Code__c, td);
            }
            LogTracker.debugLog(CLASS_NAME, 'execute', '## transferDetailsMap: ' + context.transferDetailsMap);

            //** Installed/Irrecoverable Warehouses **
            //get all installed warehouses mapped to their logistic division
            for(Bit2Shop__Warehouse__c wh : staticWarehouses){
                if(wh.Plc_Tipology__c == WAREHOUSE_TIPOLOGY_INSTALLED) {
                    context.divisionToInstalledWarehousesMap.put('Installed', wh);
                }else if(wh.Plc_Tipology__c == WAREHOUSE_TIPOLOGY_IRRECOVERABLE){
                    context.divisionToIrrecoverableWarehousesMap.put('Irrecoverable', wh);
                }
                context.aliasToWarehouses.put(wh.Plc_Alias__c, wh);
                context.allWareshousesMap.put(wh.id, wh);
                warehousesByAliasMap.put(wh.Plc_Alias__c, wh);
            }
            LogTracker.debugLog(CLASS_NAME, 'execute', '## staticWarehouses: ' + staticWarehouses);
            LogTracker.debugLog(CLASS_NAME, 'execute', '## divisionToInstalledWarehousesMap: ' + context.divisionToInstalledWarehousesMap);
            LogTracker.debugLog(CLASS_NAME, 'execute', '## divisionToIrrecoverableWarehousesMap: ' + context.divisionToIrrecoverableWarehousesMap);
            LogTracker.debugLog(CLASS_NAME, 'execute', '## aliasToWarehouses: ' + context.aliasToWarehouses);
            LogTracker.debugLog(CLASS_NAME, 'execute', '## allWareshousesMap: ' + context.allWareshousesMap);
            LogTracker.debugLog(CLASS_NAME, 'execute', '## warehousesByAliasMap: ' + warehousesByAliasMap);

            //** get all external catalog items from WOLI**
            //list of all ext catalog items aliases
            List<String> extCatItemsList = new List<String>();
            //query for TermIds and Assets (useful for uninstallation/deactivation)
            List<String> termIdsList = new List<String>();
            List<ID> extAssetList = new List<ID>();
            //FB 03072019 - NEXIPLC-613 [START]
            Set<String> foundParentSerialsSet = new Set<String>();
            //FB 03072019 - NEXIPLC-613 [END]
            //Map<Id, Set<String>> workOrderWithWorkOrderLineItemTypes = new Map<Id, Set<String>>();
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                if(skipWorkOrderLineItem(woli)){ continue; }

                /*if (workOrderWithWorkOrderLineItemTypes.containsKey(woli.WorkOrderId)) {

                    workOrderWithWorkOrderLineItemTypes.get(woli.WorkOrderId).add(woli.Plc_OperationType__c);
                } else {

                    workOrderWithWorkOrderLineItemTypes.put(woli.WorkOrderId, new Set<String>{woli.Plc_OperationType__c});
                }*/

                extCatItemsList.add(woli.Plc_ReferenceExternalCatalogItem__c);
                //FB 03072019 - NEXIPLC-613: Adding match from serial to asset [START]
                if(woli.Plc_Parent__r.Plc_StockSerial__c!=null){
                    foundParentSerialsSet.add(woli.Plc_Parent__r.Plc_StockSerial__c);
                }
                //FB 03072019 - NEXIPLC-613: Adding match from serial to asset [END]
                
                if (String.isNotBlank(woli.Plc_ExternalTermId__c)) {
                    Plc_TermId__c tid = termIdsByCodeMap.get(woli.Plc_ExternalTermId__c);
                    if(tid != null) {
                        context.codeToTermIds.put(tid.Plc_TermIdCode__c, tid);
                    }else{
                        termIdsList.add(woli.Plc_ExternalTermId__c);
                    }
                }
                if(woli.AssetId != null){
                    extAssetList.add(woli.AssetId);
                }
                if(woli.Plc_Parent__r.AssetId != null){
                    extAssetList.add(woli.Plc_Parent__r.AssetId);
                }
                if(woli.Plc_TermId__c != null){
                    Plc_TermId__c tid = termIdsByCodeMap.get(woli.Plc_TermId__r.Plc_TermIdCode__c);
                    if(tid != null) {
                        context.codeToTermIds.put(tid.Plc_TermIdCode__c, tid);
                    }else{
                        termIdsList.add(woli.Plc_TermId__r.Plc_TermIdCode__c);
                    }
                }
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### extCatItemsList: ' + extCatItemsList);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### extAssetList: ' + extAssetList);

            if(!termIdsList.isEmpty()) {

                for (Plc_TermId__c tid : [SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c 
                                          WHERE Plc_TermIdCode__c IN :termIdsList]) {
                    context.codeToTermIds.put(tid.Plc_TermIdCode__c, tid);
                    termIdsByCodeMap.put(tid.Plc_TermIdCode__c, tid);
                }
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### termIdsList: ' + termIdsList);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### codeToTermIds: ' + context.codeToTermIds);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### termIdsByCodeMap: ' + termIdsByCodeMap);

            //search for Assets that are related to the TermId
            //in case of deactivation we search for Assets related to the coming TermId, with the same legacy point
            //and with Plc_Category__c on its External Catalog Item equal to "Product"
            for(Asset ast : 
                [SELECT Id, Bit2Shop__Serial_Number__c, NE__SerialNum__c, SerialNumber, Plc_TermId__c,
                        Status, NE__Status__c,
                        Plc_StockSerial__r.Plc_TermId__r.Plc_TermIdCode__c,
                        Plc_StockSerial__c, Plc_StockSerial__r.Id,
                        Plc_StockSerial__r.Bit2Shop__Warehouse_Id__c,
                        Plc_StockSerial__r.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
                        Plc_ProductStock__c,
                        Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__c,
                        Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Alias__c,
                        Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Product_Description__c
                FROM Asset
                WHERE ((Plc_TermId__c IN :context.codeToTermIds.values() AND 
                        Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = :EXT_CATALOG_ITEM_CATEGORY_PRODUCT)
                   OR Id IN :extAssetList
                   //FB 03072019 - NEXIPLC-613 [START]
                   OR Plc_StockSerial__c IN :foundParentSerialsSet)]) 
                   //FB 03072019 - NEXIPLC-613 [END]
                {

                List<Asset> astList = context.termIdToAssetMap.get(ast.Plc_TermId__c);
                if(astList == null){
                    astList = new List<Asset>();
                    if(ast.Plc_TermId__c != null) {
                        context.termIdToAssetMap.put(ast.Plc_TermId__c, astList);
                    }
                }
                astList.add(ast);

                if(ast.Plc_StockSerial__c != null){
                    context.stockSerialsMap.put(ast.Plc_StockSerial__c, ast.Plc_StockSerial__r);
                }
                //get current WH of the Asset
                warehouseAliasesList.add(ast.Plc_StockSerial__r.Bit2Shop__Warehouse_Id__r.Plc_Alias__c);
                //query of external catalog items
                extCatItemsList.add(ast.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Alias__c);
                //map of assets
                context.assetsMap.put(ast.Id, ast);
                //FB 03072019 - NEXIPLC-613 [START]
                context.serialToAssetMap.put(ast.Plc_StockSerial__c, ast.Id);
                //FB 03072019 - NEXIPLC-613 [END]

                //EC
                context.extCatItemForProdStockList.add(ast.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__c);
                //EC
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### stockSerialsMap: ' + context.stockSerialsMap);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### warehouseAliasesList: ' + warehouseAliasesList);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### extCatItemsList: ' + extCatItemsList);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### assetsMap: ' + context.assetsMap);

            for(B2WExtCat__External_Catalog_Item__c eci : 
                [SELECT Id, Plc_Alias__c, Bit2Shop__Product_Description__c,
                        Plc_ProductSku__c, Plc_Manufacturer__r.Plc_Alias__c
                 FROM B2WExtCat__External_Catalog_Item__c
                 WHERE Plc_Alias__c IN :extCatItemsList
                   AND Plc_Alias__c != NULL]) {

                context.extCatalogItemsMap.put(eci.Plc_Alias__c, eci);
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### extCatalogItemsMap: '+context.extCatalogItemsMap);

            //** All Warehouses from the Work Order **
            //get warehouses aliases (for massive query)
            for(WorkOrder wo : (List<WorkOrder>)workOrdersList) {
                Bit2Shop__Warehouse__c wh = warehousesByAliasMap.get(wo.Plc_LegacyWarehouseId__c);
                if(wh == null) {
                    warehouseAliasesList.add(wo.Plc_LegacyWarehouseId__c);
                }else{
                    context.aliasToWarehouses.put(wh.Plc_Alias__c, wh);
                    context.allWareshousesMap.put(wh.id, wh);
                }
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### warehouseAliasesList: '+warehouseAliasesList);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### aliasToWarehouses: '+context.aliasToWarehouses);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### allWareshousesMap: '+context.allWareshousesMap);

            //warehouses to aliases
            if(!warehouseAliasesList.isEmpty()) {
                for (Bit2Shop__Warehouse__c wh : 
                    [SELECT Id,
                            Plc_Alias__c,
                            Bit2Shop__Dealer_Id__c,
                            Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                            Plc_LogisticDivision__c,
                            Bit2Shop__Inventory_CurrentPeriodAtConfirmation__c,
                            Bit2Shop__Dealer_Id__r.Bit2Shop__Group_Id__c,
                            Bit2Shop__Dealer_Id__r.Bit2Shop__Approver_Group_Id__c,
                            Bit2Shop__Dealer_Id__r.OwnerId,
                            Plc_Tipology__c
                     FROM Bit2Shop__Warehouse__c
                     WHERE Plc_Alias__c IN :warehouseAliasesList
                ]) {
                    context.aliasToWarehouses.put(wh.Plc_Alias__c, wh);
                    context.allWareshousesMap.put(wh.id, wh);
                    warehousesByAliasMap.put(wh.Plc_Alias__c, wh);
                }
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### aliasToWarehouses: '+context.aliasToWarehouses);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### allWareshousesMap: '+context.allWareshousesMap);
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### warehousesByAliasMap: '+warehousesByAliasMap);

            // end collection initializations for bulk processing -----------------------------------------------------
            
            

            // here starts WO lifecicle algoritm ----------------------------------------------------------------------

            //** create a Stock Order for each woli operation type (up to 3)**
            for(WorkOrder wo : (List<WorkOrder>) workOrdersList) {

                Boolean hasSubstitution = hasSubstitution(wo, context.lineItemsMap);
                Boolean hasSubstCorr    = hasSubstitutionCorr(wo, context.lineItemsMap);
                Boolean hasInstallation = hasInstallation(wo, context.lineItemsMap);
                Boolean hasRemoval      = hasRemoval(wo, context.lineItemsMap);
                Boolean hasDeactivation = hasDeactivation(wo, context.lineItemsMap);

                if (hasDeactivation) {
                    newDeactivationStockOrder(wo, context);
                }

                if (hasInstallation || hasSubstitution || hasSubstCorr) {
                    newInstallationStockOrder(wo, context);
                }

                if (hasRemoval || hasSubstitution || hasSubstCorr) {
                    newRemovalStockOrder(wo, context);
                }

                // no trasfer is required for ToRiconfigureCorr operation type
            }

            //inserts stock orders
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### woToStockOrders: ' + context.woToStockOrders);
            insert context.woToStockOrders.values();

            for(WorkOrder wo : (List<WorkOrder>) workOrdersList){

                Boolean hasSubstitution = hasSubstitution(wo, context.lineItemsMap);
                Boolean hasSubstCorr    = hasSubstitutionCorr(wo, context.lineItemsMap);
                Boolean hasInstallation = hasInstallation(wo, context.lineItemsMap);
                Boolean hasRemoval = hasRemoval(wo, context.lineItemsMap);
                Boolean hasDeactivation = hasDeactivation(wo, context.lineItemsMap);

                if(hasInstallation || hasSubstitution || hasSubstCorr) {
                    String key = getKey(FlowType.Installation, wo.Id);
                    Bit2Shop__StockOrder__c stockOrder = context.woToStockOrders.get(key);
                    NE__Order__c config = createConfiguration(stockOrder);
                    context.woToConfigurationsMap.put(key, config);
                }
                if(hasRemoval || hasSubstitution || hasSubstCorr) {
                    String key = getKey(FlowType.Removal, wo.Id);
                    Bit2Shop__StockOrder__c stockOrder = context.woToStockOrders.get(key);
                    NE__Order__c config = createConfiguration(stockOrder);
                    context.woToConfigurationsMap.put(key, config);
                }
                if(hasDeactivation) {
                    String key = getKey(FlowType.Deactivation, wo.Id);
                    Bit2Shop__StockOrder__c stockOrder = context.woToStockOrders.get(key);
                    NE__Order__c config = createConfiguration(stockOrder);
                    context.woToConfigurationsMap.put(key, config);
                }

                // no trasfer is required for ToRiconfigureCorr operation type
            }

            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### woToConfigurationsMap: '+context.woToConfigurationsMap);
            //insert configurations
            insert context.woToConfigurationsMap.values();

            //** Query existent Product Stocks **
            //query all available product stocks for the given external catalog items and warehouses
            List<ID> wareHousesForProdStockList = new List<ID>();//all WH found on woli (both origin and destination)
            //List<ID> extCatItemForProdStockList = new List<ID>();//all ExtcatItem found on woli
            List<String> woliSerialNumbers = new List<String>();//to get the Stock Serial 2
            Set<String> allowedWHToExtCatProdCombinations = new Set<String>();//set to allow specific combinations of WH+ExtCatItem
            
            System.debug('#### lineItemsMap 781 ' + JSON.serializePretty(context.lineItemsMap.values()));
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                if(skipWorkOrderLineItem(woli)){ continue; }

                String extCatItemAlias = woli.Plc_ReferenceExternalCatalogItem__c;
                LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### extCatItemAlias pre asset:'+extCatItemAlias);

                //deactivation should search for the active asset of category "Product" for the given TermId
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE) {
                    Asset ast = getAssetForWoli(woli, context.codeToTermIds, context.termIdToAssetMap, context.assetsMap);
                    LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### Asset trovato :'+JSON.serializePretty(ast));
                    if(ast == null){
                        throw new Plc_Exception('[ERR:CL-0390306] Cannot find an active Asset to deactivate for Work Order Line Item['+woli.Id+']');
                    }
                    extCatItemAlias = ast.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Alias__c;
                }

                LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### extCatItemAlias:'+extCatItemAlias);
                LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### extCatalogItemsMap:'+JSON.serializepretty(context.extCatalogItemsMap));
                //LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### key/woToStockOrders:'+key+' '+woToStockOrders);

                String key;
                //String woliKey;
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {
                    key = getKey(FlowType.Installation, woli.WorkOrderId);
                    //woliKey = getKey(FlowType.Installation, woli.Id);
                } else if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE) {
                    key = getKey(FlowType.Deactivation, woli.WorkOrderId);
                    //woliKey = getKey(FlowType.Deactivation, woli.Id);
                } else if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE) {
                    key = getKey(FlowType.Removal, woli.WorkOrderId);
                    //woliKey = getKey(FlowType.Removal, woli.Id);
                }

                B2WExtCat__External_Catalog_Item__c catItem = context.extCatalogItemsMap.get(extCatItemAlias);
                if(catItem == null){
                    throw new Plc_Exception('[ERR:CL-0390311] Cannot find external catalog item with alias ['+extCatItemAlias+']');
                }
                context.extCatItemForProdStockList.add(catItem.Id);

                LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### woli.Plc_SerialNumber__c:' + woli.Plc_SerialNumber__c);
                if (String.isNotBlank(woli.Plc_SerialNumber__c)) {
                    woliSerialNumbers.add(
                        getStockSerial2Key(catItem.Plc_Manufacturer__r.Plc_Alias__c, woli.Plc_SerialNumber__c)
                    );
                }

                Id destinationWarehouseId = getWhDestination(woli, key, context);
                Id originWarehouseId      = getWhOrigin(woli, key, context);
                
                wareHousesForProdStockList.add(destinationWarehouseId);
                wareHousesForProdStockList.add(originWarehouseId);

                allowedWHToExtCatProdCombinations.add(destinationWarehouseId + '' + catItem.Id);
                allowedWHToExtCatProdCombinations.add(originWarehouseId + '' + catItem.Id);

                for(String extItem : context.extCatItemForProdStockList){
                    allowedWHToExtCatProdCombinations.add(destinationWarehouseId + '' + extItem);
                    allowedWHToExtCatProdCombinations.add(originWarehouseId + '' + extItem);
                }
                allowedWHToExtCatProdCombinations.add(destinationWarehouseId + '' + catItem.Id);
                allowedWHToExtCatProdCombinations.add(originWarehouseId + '' + catItem.Id);
                

                //Substitution is the only Operation Type with 2 different moves
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {

                    //gets the Asset to be uninstalled
                    Asset ast = getAssetForWoli(woli, context.codeToTermIds, context.termIdToAssetMap, context.assetsMap);
                    if(ast == null){
                        throw new Plc_Exception('[ERR:CL-0390307] Cannot find an active Asset to deactivate for Work Order ['+key+']');
                    }
                    LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### isSubstitution.ast: '+ast);
                    extCatItemAlias = ast.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Alias__c;

                    catItem = context.extCatalogItemsMap.get(extCatItemAlias);
                    if(catItem == null){
                        throw new Plc_Exception('[ERR:CL-0390312] Cannot find external catalog item with alias ['+extCatItemAlias+']');
                    }
                    context.extCatItemForProdStockList.add(catItem.Id);

                    woliSerialNumbers.add(
                        getStockSerial2Key(catItem.Plc_Manufacturer__r.Plc_Alias__c, ast.SerialNumber)
                    );

                    //uninstallation part works as a normal uninstallation
                    //but needs to get the uninstalling Asset (and its data like ext.cat.item)
                    key = getKey(FlowType.Removal, woli.WorkOrderId);

                    destinationWarehouseId = getWhDestination(woli, key, context);
                    originWarehouseId      = getWhOrigin(woli, key, context);

                    wareHousesForProdStockList.add(destinationWarehouseId);
                    wareHousesForProdStockList.add(originWarehouseId);

                    allowedWHToExtCatProdCombinations.add(destinationWarehouseId + '' + catItem.Id);
                    allowedWHToExtCatProdCombinations.add(originWarehouseId + '' + catItem.Id);
                }
            }

            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '#### woliSerialNumbers: ' + woliSerialNumbers);

            //query all Stock Serial 2
            //There are 3 systems that hold different serial counters: we need to query for all
            //possibile systems given a serial in the WOLI
            for(Bit2Shop__Stock_Serials2__c ss2 : 
                [SELECT Id, Bit2Shop__Status__c, Bit2Shop__Serial_Number__c,
                        Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_Description__c,
                        Bit2Shop__Warehouse_Id__c,
                        Plc_FirstInstallationDate__c,
                        Plc_DllSerialNumberUnique__c,
                        Plc_EncodedSerialNumberUnique__c,
                        Plc_ManufacturerSerialNumberUnique__c,
                        Plc_TermId__c,
                        Plc_TermId__r.Plc_TermIdCode__c
                FROM Bit2Shop__Stock_Serials2__c
                WHERE (Plc_DllSerialNumberUnique__c IN :woliSerialNumbers
                   OR Plc_EncodedSerialNumberUnique__c IN :woliSerialNumbers
                   OR Plc_ManufacturerSerialNumberUnique__c IN :woliSerialNumbers
                   OR ID IN :context.stockSerialsMap.keyset())]) {
                //serialsToSerialStock2.put(ss2.Bit2Shop__Serial_Number__c, ss2);
                if(String.isNotBlank(ss2.Plc_DllSerialNumberUnique__c)) {
                    context.serialsToSerialStock2.put(ss2.Plc_DllSerialNumberUnique__c, ss2);
                }
                if(String.isNotBlank(ss2.Plc_EncodedSerialNumberUnique__c)) {
                    context.serialsToSerialStock2.put(ss2.Plc_EncodedSerialNumberUnique__c, ss2);
                }
                if(String.isNotBlank(ss2.Plc_ManufacturerSerialNumberUnique__c)) {
                    context.serialsToSerialStock2.put(ss2.Plc_ManufacturerSerialNumberUnique__c, ss2);
                }
                context.stockSerialsMap.put(ss2.Id, ss2);
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### stockSerialsMap: ' + context.stockSerialsMap);

            //query all Product Stock
            //removes unwanted combinations of Warehouses and Ext Cat.Items (it is easy and more performant
            //to query "IN AND IN" than query all the right combinations of warehouses and ext.catalog items)

            System.debug('context.extCatItemForProdStockList : '+context.extCatItemForProdStockList);
            System.debug('context.wareHousesForProdStockList : '+wareHousesForProdStockList);
            for(Bit2Shop__Product_Stock__c pStock : 
                [SELECT Id,
                        Bit2Shop__External_Catalog_Item_Id__c,
                        Bit2Shop__Product_Description__c,
                        Bit2Shop__Period_Id__c,
                        Bit2Shop__Warehouse_Id__c,
                        RecordTypeId,
                        Bit2Shop__Stock_Qty__c,
                        Plc_AvailableQty__c,
                        Plc_WithdrawnQty__c,
                        Plc_OrderedQty__c,
                        Plc_ReservedQty__c,
                        Plc_UsableQty__c,
                        Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c
                FROM Bit2Shop__Product_Stock__c
                WHERE Bit2Shop__Warehouse_Id__c IN :wareHousesForProdStockList
                  AND Bit2Shop__External_Catalog_Item_Id__c IN :context.extCatItemForProdStockList ]) {

                //skips unwanted product stocks
                if(!allowedWHToExtCatProdCombinations
                        .contains(pStock.Bit2Shop__Warehouse_Id__c+''+pStock.Bit2Shop__External_Catalog_Item_Id__c)){
                            System.debug('onit');
                    continue;
                }

                String pStockKey = '' + pStock.Bit2Shop__Warehouse_Id__c
                                      + pStock.Bit2Shop__External_Catalog_Item_Id__c;
                context.skuWHtoProductStockMap.put(pStockKey, pStock);
                System.debug('sad: '+pStock.Bit2Shop__Warehouse_Id__c+'_'+ pStock.Bit2Shop__External_Catalog_Item_Id__c+' '+pStock.id);
            }
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '#### allowedWHToExtCatProdCombinations ' + JSON.serializePretty(allowedWHToExtCatProdCombinations));
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '#### skuWHtoProductStockMap: ' + JSON.serializePretty(context.skuWHtoProductStockMap));
            //** Product Stock creation **
            //There can be only one product stock per SKU per warehouse (origin and destination)
            List<Bit2Shop__Product_Stock__c> newPStocks = new List<Bit2Shop__Product_Stock__c>();
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '#### woli map: ' + JSON.serializePretty(context.lineItemsMap));
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                if(skipWorkOrderLineItem(woli)){ continue; }
                //Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);
                //Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {

                    productStockElaboration(FlowType.Installation,
                            woli,
                            null,
                            context,
                            newPStocks);
                }

                //Put logic of substitution
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    Asset existingAst = getAssetForWoli(woli, context.codeToTermIds, context.termIdToAssetMap, context.assetsMap);
                    System.debug('exass: '+existingAst);
                    productStockElaboration(FlowType.Removal,
                            woli,
                            existingAst,
                            context,
                            newPStocks);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE) {

                    Asset existingAst = getAssetForWoli(woli, context.codeToTermIds, context.termIdToAssetMap, context.assetsMap);
                    productStockElaboration(FlowType.Deactivation,
                            woli,
                            existingAst,
                            context,
                            newPStocks);
                }
            }

            //insert only new product stocks
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '##### newPStocks: ' + newPStocks);
    
            //if (!Schema.sObjectType.Bit2Shop__Product_Stock__c.createable){ throw new Plc_Exception('User does not have right to insert Product Stock objects.');}
            insert newPStocks;

            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '##### woliToproductStocksDestMap: ' + JSON.serializePretty(context.woliToproductStocksDestMap));

            //recalculates formulas for created Product Stock
            List<Bit2Shop__Product_Stock__c> allPStocks = new List<Bit2Shop__Product_Stock__c>();
            allPStocks.addAll(context.woliToproductStocksOrigMap.values());
            allPStocks.addAll(context.woliToproductStocksDestMap.values());
            Map<Id, Bit2Shop__Product_Stock__c> psReloadedMap = new Map<ID, Bit2Shop__Product_Stock__c>(
                [SELECT Id,
                        Bit2Shop__External_Catalog_Item_Id__c,
                        Bit2Shop__Product_Description__c,
                        Bit2Shop__Period_Id__c,
                        Bit2Shop__Warehouse_Id__c,
                        RecordTypeId,
                        Bit2Shop__Stock_Qty__c,
                        Plc_AvailableQty__c,
                        Plc_WithdrawnQty__c,
                        Plc_OrderedQty__c,
                        Plc_ReservedQty__c,
                        Plc_UsableQty__c,
                        Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c
                FROM Bit2Shop__Product_Stock__c 
                WHERE Id IN :allPStocks]);
            for(String woId : context.woliToproductStocksDestMap.keySet()){
                Bit2Shop__Product_Stock__c newPS = context.woliToProductStocksDestMap.get(woId);
                Bit2Shop__Product_Stock__c reloadedPS = psReloadedMap.get(newPS.Id);
                context.woliToproductStocksDestMap.put(woId, reloadedPS);
            }
            for(String woId : context.woliToproductStocksOrigMap.keySet()){
                Bit2Shop__Product_Stock__c newPS = context.woliToProductStocksOrigMap.get(woId);
                Bit2Shop__Product_Stock__c reloadedPS = psReloadedMap.get(newPS.Id);
                context.woliToproductStocksOrigMap.put(woId, reloadedPS);
            }


            //** Creazione Configuration Line Item **
            //list for the inserting order items: speeds up the insert operation
            List<NE__OrderItem__c> configItemsInsertList = new List<NE__OrderItem__c>();
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                /*Boolean isInstall = (woli.WorkOrder.RecordTypeId == woRtypeInstallationId);
                Boolean isDeactivation = (woli.WorkOrder.RecordTypeId == woRtypeDeactivationId);*/
                //Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);
                //Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);
                LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### Creating Config.Item for woli '+woli);

                if(skipWorkOrderLineItem(woli)){ continue; }


                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    createConfigurationItem(FlowType.Installation,
                            woli,
                            context,
                            configItemsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    createConfigurationItem(FlowType.Removal,
                            woli,
                            context,
                            configItemsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE){

                    createConfigurationItem(FlowType.Deactivation,
                            woli,
                            context,
                            configItemsInsertList);
                }
            }
            //creates all Config.Items
            //if (!Schema.sObjectType.NE__OrderItem__c.createable){ throw new Plc_Exception('User does not have right to insert Config.Item objects.');}
            insert configItemsInsertList;

            //** Creazione Shipments**
            //list for the inserting shipments: speeds up the insert operation
            List<Bit2Shop__Shipment__c> shipmentsInsertList = new List<Bit2Shop__Shipment__c>();
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                if(skipWorkOrderLineItem(woli)){ continue; }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    createShipments(FlowType.Installation,
                            woli,
                            context,
                            shipmentsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    createShipments(FlowType.Removal,
                            woli,
                            context,
                            shipmentsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE) {

                    createShipments(FlowType.Deactivation,
                            woli,
                            context,
                            shipmentsInsertList);
                }
            }

            //creates all shipments
            //if (!Schema.sObjectType.Bit2Shop__Shipment__c.createable){ throw new Plc_Exception('User does not have right to insert Shipment objects.');}
            Plc_ShipmentTriggerHnd.disableTemporary = true;
            insert shipmentsInsertList;
            Plc_ShipmentTriggerHnd.disableTemporary = false;


            //** Shipments Line Items, Stock History 2 **
            //list for the inserting shipment line items: speeds up the insert operation
            List<Bit2Shop__Shipment_Line_Item__c> shipmentsItemsInsertList = new List<Bit2Shop__Shipment_Line_Item__c>();
            //1 Stock History 2 per Product Stock
            //List<Bit2Shop__StockHistory2__c> stockHistoriesList = new List<Bit2Shop__StockHistory2__c>();
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                /*Boolean isInstall = (woli.WorkOrder.RecordTypeId == woRtypeInstallationId);
                Boolean isDeactivation = (woli.WorkOrder.RecordTypeId == woRtypeDeactivationId);*/
                //Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);
                //Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);

                if(skipWorkOrderLineItem(woli)){ continue; }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {
                    createShipmentLineItemsProduct(FlowType.Installation,
                            woli,
                            context,
                            shipmentsItemsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {
                    createShipmentLineItemsProduct(FlowType.Removal,
                            woli,
                            context,
                            shipmentsItemsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE) {
                    createShipmentLineItemsProduct(FlowType.Deactivation,
                            woli,
                            context,
                            shipmentsItemsInsertList);
                }
            }

            //creates the shipment line items (product)
            //if (!Schema.sObjectType.Bit2Shop__Shipment_Line_Item__c.createable){ throw new Plc_Exception('User does not have right to insert Shipment line item objects.');}
            insert shipmentsItemsInsertList;

            //create stock histories
            //insert stockHistoriesList;

            //insert list is cleared to insert new ship line items of Serial type
            shipmentsItemsInsertList.clear();

            //** Shipment Line Item (Serial) and Serial Stock History 2 **
            //1 Serial Stock History 2 per Serial (1 per WOLI)
            //List<Bit2Shop__Serial_Stock_History2__c> serialStockHistoriesList = new List<Bit2Shop__Serial_Stock_History2__c>();
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                /*Boolean isInstall = (woli.WorkOrder.RecordTypeId == woRtypeInstallationId);
                Boolean isDeactivation = (woli.WorkOrder.RecordTypeId == woRtypeDeactivationId);*/
                //Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);
                //Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);

                if(skipWorkOrderLineItem(woli)){ continue; }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    createShipmentLineItemsSerial(FlowType.Installation,
                            woli,
                            context,
                            shipmentsItemsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    createShipmentLineItemsSerial(FlowType.removal,
                            woli,
                            context,
                            shipmentsItemsInsertList);
                }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE){

                    createShipmentLineItemsSerial(FlowType.Deactivation,
                            woli,
                            context,
                            shipmentsItemsInsertList);
                }
            }

            //FB 20190711 NEXIPLC-661 [START]
            System.debug('## sliProductOutToProductStockMap ' + context.sliProductOutToProductStockMap);
            System.debug('## shipmentOutToProductStockMap ' + context.shipmentOutToProductStockMap);

            if (!context.sliProductOutToProductStockMap.keySet().isEmpty()) {
                List<sObject> sliAndShToUpdateList = new List<sObject>();

                for (String id : context.sliProductOutToProductStockMap.keySet()) {

                    String originPsId = context.sliProductOutToProductStockMap.get(id);

                    sliAndShToUpdateList.add(
                        new Bit2Shop__Shipment_Line_Item__c(
                            Id = id,
                            Bit2Shop__Product_Stock_Id__c = originPsId
                        )
                    );
                }

                for (String id : context.shipmentOutToProductStockMap.keySet()) {

                    String originPsId = context.shipmentOutToProductStockMap.get(id);

                    sliAndShToUpdateList.add(
                        new Bit2Shop__Shipment__c(
                            Id = id,
                            Plc_ProductStock__c = originPsId
                        )
                    );

                }

                Plc_ShipmentTriggerHnd.disableTemporary = true;
                update sliAndShToUpdateList;
                Plc_ShipmentTriggerHnd.disableTemporary = false;
            }
            //FB 20190711 NEXIPLC-661 [END]
            
            //creates the shipment line items (serial)
            //if (!Schema.sObjectType.Bit2Shop__Shipment_Line_Item__c.createable){ throw new Plc_Exception('User does not have right to insert Shipment line item objects.');}
            insert shipmentsItemsInsertList;

            //create serial stock histories
            //insert serialStockHistoriesList;

            //** Share to Stock Order **
            List<Bit2Shop__StockOrder__share> stockOrderShares = new List<Bit2Shop__StockOrder__share>();
            for(WorkOrder wo : (List<WorkOrder>) workOrdersList) {

                Boolean hasSubstitution = hasSubstitution(wo, context.lineItemsMap);
                Boolean hasSubstCorr    = hasSubstitutionCorr(wo, context.lineItemsMap);
                Boolean hasInstallation = hasInstallation(wo, context.lineItemsMap);
                Boolean hasRemoval = hasRemoval(wo, context.lineItemsMap);
                Boolean hasDeactivation = hasDeactivation(wo, context.lineItemsMap);

                if(hasSubstitution || hasInstallation || hasSubstCorr) {
                    createStockOrderShare(FlowType.Installation,
                            wo,
                            context,
                            stockOrderShares);
                }

                if(hasSubstitution || hasRemoval || hasSubstCorr) {
                    createStockOrderShare(FlowType.Removal,
                            wo,
                            context,
                            stockOrderShares);
                }

                if(hasDeactivation) {
                    createStockOrderShare(FlowType.Deactivation,
                            wo,
                            context,
                            stockOrderShares);
                }
            }

            //insert stock order shares
            //if (!Schema.sObjectType.Bit2Shop__StockOrder__share.createable){ throw new Plc_Exception('User does not have right to insert Stock Order Share objects.');}
            insert stockOrderShares;

            //** Share to Shipments inbound & Outbound**
            List<Bit2Shop__Shipment__share> shipmentShares = new List<Bit2Shop__Shipment__share>();
            for(String woId : context.woToShipmentsInbound.keyset()){
                createShipmentShare(woId,
                        context,
                        context.woToShipmentsInbound,
                        shipmentShares,
                        true);
            }
            for(String woId : context.woToShipmentsOutbound.keyset()){
                createShipmentShare(woId,
                        context,
                        context.woToShipmentsOutbound,
                        shipmentShares,
                        false);
            }

            //insert shipment shares
            //if (!Schema.sObjectType.Bit2Shop__Shipment__share.createable){ throw new Plc_Exception('User does not have right to insert Shipment Share objects.');}
            insert shipmentShares;


            //creates Asset and TermId objects
            Map<String, Asset> mainWoliToAsset = new Map<String, Asset>();
            Map<String, Asset> assetToInstall = new Map<String, Asset>();
            Map<String, Asset> assetToUninstall = new Map<String, Asset>();

            for(WorkOrderLineItem woli : context.lineItemsMap.values()){
                //Added by Emanuele Campese - Temporary Fix
                Boolean needTermIdCreation = true;
                //Added by Emanuele Campese - Temporary Fix

                //handles the "NoOperation" operation type, by
                //releasing the reservation (if any)
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_NO_OPERATION && woli.Plc_Closed__c==false && woli.Status == 'Executed') {
                    //mark all elaborated wolis as closed
                    woli.Plc_Closed__c = true;
                }

                if(skipWorkOrderLineItem(woli)) { continue; }

                //mark all elaborated wolis as closed
                woli.Plc_Closed__c = true;

                //installation part
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    //reservations change status (if any) (NEXIPLC-210)
                    Plc_Reservation__c res = woli.Plc_Reservation__r;
                    if(res != null) {
                        res.Plc_Status__c = RESERVATION_STATUS_NOT_RESERVED;
                        context.woliToReservation.put(woli.id, res);
                    }

                    //creates the new TermId object (only if the external term id is set)
                    if(String.isNotBlank(woli.Plc_ExternalTermId__c)) {
                        //Added by Emanuele Campese - Temporary Fix
                        for(Plc_TermId__c tempTermId : context.woliToTermId.values()) {
                            if(woli.Plc_ExternalTermId__c == tempTermId.Plc_TermIdCode__c) {
                                context.woliToTermId.put(woli.Id, tempTermId);
                                needTermIdCreation = false;
                            }
                        }
                        if(needTermIdCreation == true){
                            Plc_TermId__c tid = new Plc_TermId__c(Plc_TermIdCode__c = woli.Plc_ExternalTermId__c);
                            context.woliToTermId.put(woli.Id, tid);
                            context.termIdToInsertList.add(tid);
                        }
                        //Added by Emanuele Campese - Temporary Fix
                    }

                    String key = getKey(FlowType.Installation, woli.Id);

                    Bit2Shop__Stock_Serials2__c stockSerial = null;

                    B2WExtCat__External_Catalog_Item__c extCatItem = context.extCatalogItemsMap.get(woli.Plc_ReferenceExternalCatalogItem__c);
                    Bit2Shop__Product_Stock__c pStockDest = context.woliToproductStocksDestMap.get(key);
                    Bit2Shop__Warehouse__c destWarehouse = context.allWareshousesMap.get(pStockDest.Bit2Shop__Warehouse_Id__c);

                    if(String.isNotBlank(woli.Plc_SerialNumber__c)) {
                        String stockSerialKey = getStockSerial2Key(extCatItem.Plc_Manufacturer__r.Plc_Alias__c, woli.Plc_SerialNumber__c);
                        stockSerial = context.serialsToSerialStock2.get(stockSerialKey);
                    }

                    Asset ast = null;   //the new asset to install

                    Date endDateVar;
                    if(context.woMap.get(woli.WorkOrder.Id).EndDate != null ) {
                        endDateVar = context.woMap.get(woli.WorkOrder.Id).EndDate.date();
                    } else {
                        endDateVar = System.now().date();
                    }

                    if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR ||
                       woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {
                        //CM20190415.NEXIPLC-516

                        // get old asset to reconfigure
                        Asset astOld = context.assetsMap.get(woli.AssetId);
                        //Asset astOld = context.woliToAsset.get(key);    //???
                        // and validate it
                        if(astOld == null) 
                            throw new Plc_Exception('[ERR:CL-0390313] Cannot find Asset to reconfig for WOLI [' + key + ']');

                        // create new asset to install by cloning the old one
                        ast = astOld.clone(false, true, false, false);
                        System.debug('cloned old asset:\n'+JSON.serializePretty(ast));
                        System.debug('woli ToRiconfigureCorr:\n'+JSON.serializePretty(woli));

                        // ovewrite new values coming from reconfiguration woli
                        ast.RecordTypeId                = Plc_Utils.getRecordTypeId(ASSET_RECORDTYPE_TECHNICAL_ASSET, 
                                                                                    Asset.SObjectType.getDescribe().name);
                        ast.Name                        = pStockDest.Bit2Shop__Product_Description__c;
                        ast.InstallDate                 = endDateVar;
                        //FB 29-05-2019 - NEXIPLC-622 [START]
                        ast.Plc_InstallationDate__c     = endDateVar;
                        //FB 29-05-2019 - NEXIPLC-622 [END]
                        ast.Quantity                    = 1;
                        ast.Status                      = ASSET_STATUS_INSTALLED;
                        ast.Plc_TermId__c               = null;     // populated later
                        ast.Plc_ProductStock__c         = pStockDest.Id;    //woliToproductStocksDestMap.get(key).Id;
                        if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {
                            ast.Plc_StockSerial__c      = (stockSerial != null) ? stockSerial.Id : null;
                            ast.SerialNumber                = woli.Plc_SerialNumber__c;
                            ast.NE__SerialNum__c            = woli.Plc_SerialNumber__c;
                            ast.Bit2Shop__Serial_Number__c  = woli.Plc_SerialNumber__c;
                        }
                        ast.Plc_ServicePointLegacyId__c = woli.WorkOrder.Plc_LegacyServicePointId__c;
                        ast.Plc_AccountLegacyId__c      = woli.WorkOrder.Plc_LegacyAccountId__c;
                        ast.AccountId                   = destWarehouse.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c;
                        ast.Plc_Abi__c                  = woli.WorkOrder.Plc_Abi__c;
                        ast.Plc_FiscalCode__c           = woli.WorkOrder.Plc_FiscalCode__c;
                        ast.Plc_SiaCode__c              = woli.WorkOrder.Plc_SiaCode__c;
                        ast.Plc_Street__c               = woli.WorkOrder.Street;
                        ast.Plc_PostalCode__c           = woli.WorkOrder.PostalCode;
                        ast.Plc_City__c                 = woli.WorkOrder.City;
                        ast.Plc_SourceLegacySystem__c   = woli.WorkOrder.Plc_SourceLegacySystem__c;
                        ast.Plc_ExternalAccountId__c    = woli.WorkOrder.Plc_ExternalAccount__c;
                        ast.Plc_ExternalTermId__c       = woli.Plc_ExternalTermId__c;
                        ast.ParentId                    = (woli.Plc_Parent__c != null) ? woli.Plc_Parent__r.AssetId : null;
                        
                        System.debug('new asset:\n'+JSON.serializePretty(ast));
                    }
                    else {
                        ast = new Asset(
                            RecordTypeId                = Plc_Utils.getRecordTypeId(ASSET_RECORDTYPE_TECHNICAL_ASSET,
                                                                                    Asset.SObjectType.getDescribe().name),
                            Name                        = pStockDest.Bit2Shop__Product_Description__c,
                            InstallDate                 = endDateVar,
                            //FB 29-05-2019 - NEXIPLC-622 [START]
                            Plc_InstallationDate__c     = endDateVar,
                            //FB 29-05-2019 - NEXIPLC-622 [END]
                            Quantity                    = 1,
                            Status                      = ASSET_STATUS_INSTALLED,
                            Plc_TermId__c               = null,
                            Plc_ProductStock__c         = pStockDest.Id, //woliToproductStocksDestMap.get(key).Id,
                            Plc_StockSerial__c          = (stockSerial != null) ? stockSerial.Id : null,
                            SerialNumber                = woli.Plc_SerialNumber__c,
                            NE__SerialNum__c            = woli.Plc_SerialNumber__c,
                            Bit2Shop__Serial_Number__c  = woli.Plc_SerialNumber__c,
                            Plc_ServicePointLegacyId__c = woli.WorkOrder.Plc_LegacyServicePointId__c,
                            Plc_AccountLegacyId__c      = woli.WorkOrder.Plc_LegacyAccountId__c,
                            AccountId                   = destWarehouse.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                            Plc_Abi__c                  = woli.WorkOrder.Plc_Abi__c,
                            Plc_FiscalCode__c           = woli.WorkOrder.Plc_FiscalCode__c,
                            Plc_SiaCode__c              = woli.WorkOrder.Plc_SiaCode__c,
                            Plc_Street__c               = woli.WorkOrder.Street,
                            Plc_PostalCode__c           = woli.WorkOrder.PostalCode,
                            Plc_City__c                 = woli.WorkOrder.City,
                            Plc_SourceLegacySystem__c   = woli.WorkOrder.Plc_SourceLegacySystem__c,
                            Plc_ExternalAccountId__c    = woli.WorkOrder.Plc_ExternalAccount__c,
                            Plc_ExternalTermId__c       = woli.Plc_ExternalTermId__c,
                            ParentId                    = (woli.Plc_Parent__c != null) ? woli.Plc_Parent__r.AssetId : null
                        );
                    }

                    System.debug('##### context.serialToAssetMap ' + context.serialToAssetMap);

                    if (woli.Plc_Parent__c == null) {
                        mainWoliToAsset.put('' + woli.Id, ast);
                    }
                    //FB 03072019 - NEXIPLC-613 [START]
                    else {

                        if (context.serialToAssetMap.containsKey(woli.Plc_Parent__r.Plc_StockSerial__c)) {
                            ast.ParentId = context.serialToAssetMap.get(woli.Plc_Parent__r.Plc_StockSerial__c);
                        }
                    }
                    //FB 03072019 - NEXIPLC-613 [END]

                    assetToInstall.put(key, ast);
                    context.woliToAsset.put(key, ast);
                }

                //deactivation/removal part
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {

                    String key = woli.Id;
                    if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE) {
                        key = getKey(FlowType.Deactivation, woli.Id);
                    } else if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE || 
                              woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE ||
                              woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR ||
                              woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {
                        key = getKey(FlowType.Removal, woli.Id);
                    }

                    Asset ast = null; // the asset to uninstall

                    if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {

                        // get the old asset to uninstall
                        ast = context.assetsMap.get(woli.AssetId);

                        context.woliToAsset.put(key, ast);
                    }
                    else {
                        ast = context.woliToAsset.get(key);
                        if(ast == null) {
                            throw new Plc_Exception('[ERR:CL-0390308] Cannot find Asset for WOLI [' + key + ']');
                        }
                        LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### ast.Plc_StockSerial__c: '+ast.Plc_StockSerial__c);

                        LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### codeToTermIds:'+context.codeToTermIds);
                        String termIdCodeUsed;

                        Plc_TermId__c tid = context.codeToTermIds.get(woli.Plc_ExternalTermId__c);
                        termIdCodeUsed = woli.Plc_ExternalTermId__c;

                        if(tid == null && woli.Plc_TermId__c != null) {
                            tid = context.codeToTermIds.get(woli.Plc_TermId__r.Plc_TermIdCode__c);
                            termIdCodeUsed = woli.Plc_TermId__r.Plc_TermIdCode__c;
                        }
                        if(tid == null && woli.Plc_Parent__c != null && woli.Plc_Parent__r.AssetId != null) {
                            tid = context.codeToTermIds.get(woli.Plc_Parent__r.Asset.Plc_TermId__c);
                            termIdCodeUsed = woli.Plc_Parent__r.Asset.Plc_TermId__c;
                        }
                        //termId can be null if it's a "point of sales" asset
                        /*if(tid == null) {
                            throw new Plc_Exception('Cannot find TermId ['+woli.Plc_ExternalTermId__c+'|'+woli.Plc_TermId__c+'] for WOLI [' + woli.Id + ']');
                        }*/

                        Bit2Shop__Stock_Serials2__c stockSerial = context.woliToStockSerialsMap.get(key);
                        //EC - 20190603 - Added skip for ToSubstituteCorr [START]
                        if(stockSerial != null && tid != null && woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_SUBSTCORR){
                            if (stockSerial.Plc_TermId__c != tid.Id) {
                                throw new Plc_Exception('[ERR:CL-0390309] Invalid Stock Serial 2, TermId and Asset not matching [Serial Stock ID: ' + stockSerial.Id + ',Serial TermId: '+ stockSerial.Plc_TermId__r.Plc_TermIdCode__c +' TermId Indicated: '+ termIdCodeUsed + ', WOLI Id: ' + woli.Id + ']');
                            }
                        }
                        //EC - 20190603 - Added skip for ToSubstituteCorr [END]
                    }

                    assetToUninstall.put(key, ast);

                    //FB 29-05-2019 - NEXIPLC-622 [START]
                    Date endDateVar;
                    if(context.woMap.get(woli.WorkOrder.Id).EndDate != null ) {
                        endDateVar = context.woMap.get(woli.WorkOrder.Id).EndDate.date();
                    } else {
                        endDateVar = System.now().date();
                    }
                    ast.Plc_UninstallationDate__c = endDateVar;
                    //FB 29-05-2019 - NEXIPLC-622 [END]
                    
                    //deactivate Asset
                    ast.Status = ASSET_STATUS_UNINSTALLED;
                }
            }

            //upserts TermId
            upsert context.termIdToInsertList Plc_TermIdCode__c;
            //upsert mainWoliToAsset.values() Id;
            
            //System.debug('### context.woliToAsset.values():\n\n'+JSON.serializePretty(context.woliToAsset.values()));
            //upsert context.woliToAsset.values();

            System.debug('updating asset to uninstall:\n'+JSON.serializePretty(assetToUninstall.values()));
            upsert assetToUninstall.values();
            System.debug('updating asset to install:\n'+JSON.serializePretty(assetToInstall.values()));
            upsert assetToInstall.values();

            System.debug('########## mainWoliToAsset.values(): ' + JSON.serializePretty(mainWoliToAsset));
            //updates Assets' termid - installation
            //for(ID woliId : woliToAsset.keySet()){
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    String key = getKey(FlowType.Installation, woli.Id);

                    Asset ast = context.woliToAsset.get(key);

                    //asset already on workorder lineitem
                    if (ast == null){ continue; }

                    if (woli.Plc_Parent__c != null && mainWoliToAsset.containsKey(woli.Plc_Parent__c)) {
                        ast.ParentId = mainWoliToAsset.get(woli.Plc_Parent__c).Id;
                    }

                    //gets previously created TermId, if any (accessories couldn't have a TermId, because
                    //they may be associated to the Point of Sales)
                    Plc_TermId__c termId = context.woliToTermId.get(woli.Id);
                    if(termId == null) {
                        //sets the termId if not present in the woli, taking it from the parent Asset
                        if(ast.Plc_TermId__c == null
                                && woli.Plc_Parent__c != null
                                && woli.Plc_Parent__r.Asset.Plc_TermId__c != null){
                            ast.Plc_TermId__c = woli.Plc_Parent__r.Asset.Plc_TermId__c;
                        }
                    } else {
                        ast.Plc_TermId__c = termId.Id;
                    }
                    //FB 28062019 - Adding substitute Corr accessories management [START]
                    if (termId != null) {
                        context.assetToTermId.put(ast.Id, termId.Id);
                    }
                    //FB 28062019 - Adding substitute Corr accessories management [END]
                }
            }

            //insert new Assets
            upsert context.woliToAsset.values();

            System.debug('########## woliToAsset.values(): ' + JSON.serializePretty(context.woliToAsset));

            //updates reservation statuses
            update context.woliToReservation.values();

            //updates Asset on WoLi and Serial Stock 2
            Map<ID, Bit2Shop__Stock_Serials2__c> serialsStockToUpdateMap = new Map<ID, Bit2Shop__Stock_Serials2__c>();
            for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

                if(skipWorkOrderLineItem(woli)){ continue; }

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_INSTALL || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {

                    /*asset already on workorder lineitem
                    if (woli.AssetId != null){ continue; }
                    */
                    String key = getKey(FlowType.Installation, woli.Id);
                    // FB 28062019 - Adding substitute Corr accessories management [START]
                    if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE ||
                       woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {
                    // FB 28062019 - Adding substitute Corr accessories management [END]
                        /***************************/
                        String subKey = getKey(FlowType.Removal, woli.Id);
                        //Substituting the chain of assets
                        if (woli.Plc_Parent__c == null
                                && context.woliToAsset.containsKey(key)
                                && context.woliToAsset.containsKey(subKey)) {

                            context.subAssetToNewAsset.put('' + context.woliToAsset.get(subKey).Id, 
                                                           '' + context.woliToAsset.get(key).Id);
                        }
                        /**************************/
                    }

                    LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '### subAssetToNewAsset: ' + JSON.serializePretty(context.subAssetToNewAsset));

                    B2WExtCat__External_Catalog_Item__c extCatItem = context.extCatalogItemsMap.get(woli.Plc_ReferenceExternalCatalogItem__c);

                    Asset ast = context.woliToAsset.get(key);

                    if(woli.AssetId == null) {
                        woli.AssetId = ast.Id;
                    } 

                    if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR &&
                       String.isBlank(woli.Plc_SerialNumber__c)) {
                        woli.Plc_SerialNumber__c = ast.SerialNumber;
                    }

                    if(String.isNotBlank(woli.Plc_SerialNumber__c)) {

                        String woKey = getKey(FlowType.Installation, woli.WorkOrderId);
                        String stockSerialKey = getStockSerial2Key(extCatItem.Plc_Manufacturer__r.Plc_Alias__c, woli.Plc_SerialNumber__c);
                        Bit2Shop__Stock_Serials2__c serialStock = context.serialsToSerialStock2.get(stockSerialKey);

                        woli.Plc_StockSerial__c = serialStock.Id;

                        //Stock Serials 2 can be updates by the shipment line items, so we just update the needed fields
                        Bit2Shop__Stock_Serials2__c serialStockToUpdate = new Bit2Shop__Stock_Serials2__c(
                            Id = serialStock.Id,
                            Plc_TermId__c = ast.Plc_TermId__c,
                            Plc_ComeFromProcess__c = true //MZ 20199213 - Populate process flag on Stock Serial 2
                        );
                        
                        if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_RECONFCORR) {    
                            //CM20190415 do this only if a trasfer is required... 

                            //MZ 20199213 - Populate stock order reference on Stock Serial 2
                            serialStockToUpdate.Bit2Shop__Transfer_Order_Id__c = context.woToStockOrders.get(woKey).Id; //.values()[0].Id, 
                        }

                        if (serialStock.Plc_FirstInstallationDate__c == null) {
                            Date endDateVar;
                            if(context.woMap.get(woli.WorkOrder.Id).EndDate != null) {
                                endDateVar = context.woMap.get(woli.WorkOrder.Id).EndDate.date();
                            } else {
                                endDateVar = System.now().date();
                            }
                            serialStockToUpdate.Plc_FirstInstallationDate__c = endDateVar;
                        }

                        if (!serialsStockToUpdateMap.containsKey(serialStockToUpdate.Id)) {
                            serialsStockToUpdateMap.put(serialStockToUpdate.Id, serialStockToUpdate);
                        }
                    }

                    //Added by Dam
                    //assignment of termid to woli
                    if(context.woliToTermId.containsKey(woli.id)){

                        woli.Plc_TermId__c = context.woliToTermId.get(woli.id).Id;
                    }else{
                        woli.Plc_TermId__c = ast.Plc_TermId__c;
                    }
                    //Added by Dam
                }
                // FB 28052019 - NEXIPLC-613: Populating stock serial 2 lookup on unistallation and deactivation Work Order Line Item [START]
                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_DEACTIVATE) {

                    B2WExtCat__External_Catalog_Item__c extCatItem = context.extCatalogItemsMap.get(woli.Plc_ReferenceExternalCatalogItem__c);

                    if (String.isNotBlank(woli.Plc_SerialNumber__c)) {
                        String stockSerialKey = getStockSerial2Key(extCatItem.Plc_Manufacturer__r.Plc_Alias__c, woli.Plc_SerialNumber__c);

                        if (context.serialsToSerialStock2.containsKey(stockSerialKey)) {
                            woli.Plc_StockSerial__c = context.serialsToSerialStock2.get(stockSerialKey).Id;
                        }
                    }
                }
                // FB 28052019 - NEXIPLC-613: Populating stock serial 2 lookup on unistallation and deactivation Work Order Line Item [END]

                if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_REMOVE || 
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTITUTE ||
                   woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_SUBSTCORR) {

                    String woKey   = getKey(FlowType.Removal, woli.WorkOrderId);
                    String woliKey = getKey(FlowType.Removal, woli.Id);

                    Bit2Shop__Stock_Serials2__c serialStock = context.woliToStockSerialsMap.get(woliKey);

                    if(serialStock != null) {
                        //Stock Serials 2 can be updates by the shipment line items, so we just update the needed fields
                        Bit2Shop__Stock_Serials2__c serialStockToUpdate = new Bit2Shop__Stock_Serials2__c(
                            Id = serialStock.Id,
                            Bit2Shop__Status__c = SERIAL_STOCK_STATUS_TOBEVERIFIED,
                            Bit2Shop__Transfer_Order_Id__c = context.woToStockOrders.get(woKey).Id,//.values()[0].Id, //MZ 20199213 - Populate stock order reference on Stock Serial 2
                            Plc_ComeFromProcess__c = true //MZ 20199213 - Populate process flag on Stock Serial 2
                        );

                        if (!serialsStockToUpdateMap.containsKey(serialStockToUpdate.Id)) {
                            serialsStockToUpdateMap.put(serialStockToUpdate.Id, serialStockToUpdate);
                        }
                    }
                }
            }

            //updates woli
            update context.lineItemsMap.values();
            System.debug('updated woli:\n' + JSON.serializePretty(context.lineItemsMap.values()));

            //transition for Stock Orders
            for(String key : context.stockOrdersTransitionsMap.keySet()) {
                Bit2Shop__StockOrder__c so = context.woToStockOrders.get(key);
                so.Bit2Shop__Status__c = context.stockOrdersTransitionsMap.get(key);
            }

            //transition for Shipment Line Items
            Map<String, Bit2Shop__Shipment__c> shipmentsInsertMap = new Map<String, Bit2Shop__Shipment__c>(shipmentsInsertList);
            System.debug('shipmentsInsertMap\n' + JSON.serializePretty(shipmentsInsertMap));

            System.debug('shipmentLineItemsTransitions:\n' + JSON.serializePretty(context.shipmentLineItemsTransitions));
            for(Bit2Shop__Shipment_Line_Item__c shItem : context.shipmentLineItemsTransitions) {
                if (!(shItem.Bit2Shop__Transfer_Detail_Id__c == context.transferDetailsMap.get(STOCK_ORDER_TRANSDETAIL_RITIRODALCAMPO).Id &&
                        shipmentsInsertMap.containsKey(shItem.Bit2Shop__Shipment_Id__c) &&
                        shipmentsInsertMap.get(shItem.Bit2Shop__Shipment_Id__c).Bit2Shop__Sub_Type__c == SHIPMENT_SUBTYPE_INBOUND)){
                    shItem.Bit2Shop__Status__c = SHIPMENT_ITEM_STATUS_CLOSED;
                }
            }

            //if (!Schema.sObjectType.Bit2Shop__StockOrder__c.updateable){ throw new Plc_Exception('User does not have right to update Stock Order objects.');}
            update context.woToStockOrders.values();
            //if (!Schema.sObjectType.Bit2Shop__Shipment_Line_Item__c.updateable){ throw new Plc_Exception('User does not have right to update Shipment Line Item objects.');}
            update context.shipmentLineItemsTransitions;

            System.debug('### context.subAssetToNewAsset ' + context.subAssetToNewAsset);
            System.debug('### context.assetToTermId ' + context.assetToTermId);

            /* FB 13-02-2019
             * Substitution: Swapping accessories to new product
             * ------------------------------------------------------------------------------------------------------------------------- */
            if (context.subAssetToNewAsset.keySet().size() > 0) {
                List<Asset> assetToUpdate = new List<Asset>();
                for (Asset ast : [SELECT Id, ParentId, Plc_TermId__c, Plc_StockSerial__c 
                                  FROM Asset
                                  WHERE ParentId IN :context.subAssetToNewAsset.keySet()]) {

                    ast.ParentId = context.subAssetToNewAsset.get(ast.ParentId);
                    //FB 28062019 - Adding substitute Corr accessories management [START]
                    //Getting termId from new Asset installed
                    String newTermId = context.assetToTermId.get(ast.ParentId);

                    if (newTermId != null && newTermId != ast.Plc_TermId__c) {
                        ast.Plc_TermId__c = newTermId;
                        if (serialsStockToUpdateMap.containsKey(ast.Plc_StockSerial__c)) {
                            serialsStockToUpdateMap.get(ast.Plc_StockSerial__c).Plc_TermId__c = newTermId;
                        } else {
                            serialsStockToUpdateMap.put(ast.Plc_StockSerial__c, new Bit2Shop__Stock_Serials2__c(Id = ast.Plc_StockSerial__c, Plc_TermId__c = newTermId));
                        }
                    }
                    //FB 28062019 - Adding substitute Corr accessories management [START]
                    assetToUpdate.add(ast);
                }

                if (assetToUpdate.size() > 0) {
                    update assetToUpdate;
                }
            }

            /* START
             * Substitution: Swapping accessories to new product
             * ------------------------------------------------------------------------------------------------------------------------- */

            //updates serial stock 2
            update serialsStockToUpdateMap.values();
            System.debug('serialStockUpdated\n' + JSON.serializePretty(serialsStockToUpdateMap.values()));

            //System.assert(!(workOrdersList.size() == 1 && workOrdersList[0].Plc_LegacyServicePointId__c == 'B456_new8'),'break point here');

        } catch(DmlException ex) {
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '[ERR:CL-0390310] DMLEXCEPTION: '+ex.getMessage()+' \\n '+ex.getStackTraceString());
            Database.rollback(sp);            
            throw ex;   //throws the exception back to the engine of Phase Manager
        } catch(Exception ex) {
            LogTracker.debugLog(CLASS_NAME, 'oncloseWorkOrderWithFilters', '[ERR:CL-0390310] EXCEPTION: '+ex.getMessage()+' \\n '+ex.getStackTraceString());
            Database.rollback(sp);            
            throw ex;   //throws the exception back to the engine of Phase Manager
        }

        LogTracker.debugLogEnd(CLASS_NAME, 'oncloseWorkOrderWithFilters');
        return true;
    }

    /**
     * Elaborates the "cancel" action of Work Orders
     * @code 04
     *
     * @param records List<sObject>
     * @param transitionsMap Map<Id, wrts_prcgvr__PhaseTransition__c>
     *
     * @return Boolean (not required at the moment)
     */
    public static Object onCancelWorkOrder(List<WorkOrder> workOrdersList){

        LogTracker.debugLogBegin(CLASS_NAME, 'onCancelWorkOrder');
        Savepoint sp = Database.setSavepoint();
        try{
            //get all line items associated with the incoming Work Orders
            Map<ID, WorkOrderLineItem> lineItemsMap = new Map<ID, WorkOrderLineItem>(
                [SELECT Id, Plc_Reservation__r.Id
                 FROM WorkOrderLineItem 
                 WHERE WorkOrderId IN :workOrdersList]);

            //reservations list to chage status (NEXIPLC-210)
            Map<Id, Plc_Reservation__c> woliToReservation = new Map<Id, Plc_Reservation__c>();

            for(WorkOrderLineItem woli : lineItemsMap.values()){
                woli.Plc_Closed__c = true;
                if(woli.Plc_Reservation__r != null) {
                    //reservations change status
                    Plc_Reservation__c res = woli.Plc_Reservation__r;
                    res.Plc_Status__c = RESERVATION_STATUS_NOT_RESERVED;
                    woliToReservation.put(woli.id, res);
                }
            }

            //updates reservation statuses
            update woliToReservation.values();
            //close wolis
            update lineItemsMap.values();
        } 
        catch(Exception ex) {
            LogTracker.debugLog(CLASS_NAME, 'onCancelWorkOrder', '[ERR:CL-0390314] EXCEPTION: '+ex.getMessage()+' \\n '+ex.getStackTraceString());
            Database.rollback(sp);            
            throw ex;   //throws the exception back to the engine of Phase Manager
        }
        LogTracker.debugLogEnd(CLASS_NAME, 'onCancelWorkOrder');
        return true;
    }

    /**
     * Returns trus if the current WOLI should not be elaborated in current context
     *
     * @param woli => Work Order Line Item record
     *
     * @return true to Skip elaboration
     */
    private static boolean skipWorkOrderLineItem(WorkOrderLineItem woli){

        LogTracker.debugLogBegin(CLASS_NAME, 'skipWorkOrderLineItem');
        /*Boolean isInstall = (woli.WorkOrder.RecordTypeId == woRtypeInstallationId);
        Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);
        Boolean isDeactivation = (woli.WorkOrder.RecordTypeId == woRtypeDeactivationId);
        Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);

        if(!isInstall && !isUninstall && !isDeactivation && !isSubstitution) return true;

            if ( (isInstall
                    && (woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_INSTALL
                    || woli.Status != WOLI_STATUS_EXECUTED) )
                || (isUninstall
                    && (woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_REMOVE
                    || woli.Status != WOLI_STATUS_EXECUTED))
                || (isDeactivation
                    && (woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_DEACTIVATE
                    || woli.Status != WOLI_STATUS_EXECUTED))
                || (isSubstitution
                    && (woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_SUBSTITUTE
                    || woli.Status != WOLI_STATUS_EXECUTED))) return true;
        return false;*/

        LogTracker.debugLogEnd(CLASS_NAME, 'skipWorkOrderLineItem');
        return woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_NO_OPERATION || 
               woli.Status != WOLI_STATUS_EXECUTED;
    }

    /**
     * Returns true if the woli for the given WO has at least 1 substitution
     *
     * @param woli => Work Order Line Item record
     */
    private static boolean hasSubstitution(WorkOrder wo, Map<ID, WorkOrderLineItem> lineItemMap){

        LogTracker.debugLogBegin(CLASS_NAME, 'hasSubstitution');
        for(WorkOrderLineItem woli : lineItemMap.values()) {
            if(woli.WorkOrderId != wo.Id){ continue; }
            if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_SUBSTITUTE){ continue; }
            if(woli.Status != WOLI_STATUS_EXECUTED){ continue; }
            return true;
        }
        LogTracker.debugLogEnd(CLASS_NAME, 'hasSubstitution');
        return false;
    }

    /**
     * Returns true if the woli for the given WO has at least 1 substitution corr.
     *
     * @param woli => Work Order Line Item record
     */
    private static boolean hasSubstitutionCorr(WorkOrder wo, Map<ID, WorkOrderLineItem> lineItemMap){
        for(WorkOrderLineItem woli : lineItemMap.values()) {
            if(woli.WorkOrderId != wo.Id) { continue; }
            if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_SUBSTCORR) { continue; }
            if(woli.Status != WOLI_STATUS_EXECUTED) { continue; }
            return true;
        }
        return false;
    }

    /**
     * Returns true if the woli for the given WO has at least 1 uninstallation
     *
     * @param woli => Work Order Line Item record
     */
    private static boolean hasRemoval(WorkOrder wo, Map<ID, WorkOrderLineItem> lineItemMap){
        for(WorkOrderLineItem woli : lineItemMap.values()) {
            if(woli.WorkOrderId != wo.Id) { continue; }
            if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_REMOVE) { continue; }
            if(woli.Status != WOLI_STATUS_EXECUTED) { continue; }
            return true;
        }
        return false;
    }

    /**
     * Returns true if the woli for the given WO has at least 1 installation
     *
     * @param woli => Work Order Line Item record
     */
    private static boolean hasInstallation(WorkOrder wo, Map<ID, WorkOrderLineItem> lineItemMap){
        for(WorkOrderLineItem woli : lineItemMap.values()) {
            if(woli.WorkOrderId != wo.Id) { continue; }
            if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_INSTALL) { continue; }
            if(woli.Status != WOLI_STATUS_EXECUTED) { continue; }
            return true;
        }
        return false;
    }

    /**
     * Returns true if the woli for the given WO has at least 1 deactivation
     *
     * @param woli => Work Order Line Item record
     *
     */
    private static boolean hasDeactivation(WorkOrder wo, Map<ID, WorkOrderLineItem> lineItemMap){
        for(WorkOrderLineItem woli : lineItemMap.values()) {
            if(woli.WorkOrderId != wo.Id) { continue; }
            if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_DEACTIVATE) { continue; }
            if(woli.Status != WOLI_STATUS_EXECUTED) { continue; }
            return true;
        }
        return false;
    }

    private static String getStockSerial2Key(String manifacturerAlias, String serial){
        System.debug('#### getStockSerial2Key:'+manifacturerAlias+'_'+serial);
        return manifacturerAlias+'_'+serial;
    }

    /**
     * This method is used to get the correct key for the status maps
     * depending on the kind of flow we are elaborating:
     * Eg. Installation => WorkOrder.Id
     *     Replacement (Installation) => WorkOrder.Id + _installation
     *     Replacement (Deactivation) => WorkOrder.Id + _deactivation
     *
     * @return
     */
    private static String getKey(FlowType t, ID objectId){
        /*if(t == FlowType.Substitution_Installation){
            return objectId + '_inst';
        }else if(t == FlowType.Uninstallation_Deactivation){
            return objectId + '_uninst';
        }*/
        String suffix = (t == null)?'':t.name();
        return objectId+'_'+suffix;
    }

    /**
     * Search into the Asset list for a given TermId and looks for
     *
     * @param woli - Work Order Line Item
     * @param codeToTermIds - map of TermId Code to TermId object
     * @param termIdToAssetMap - Map of TermId.ID to all its assets
     */
    private static Asset getAssetForWoli(
            WorkOrderLineItem woli,
            Map<String, Plc_TermId__c> codeToTermIds,
            Map<Id, List<Asset>> termIdToAssetMap,
            Map<ID, Asset> assetsMap) {

        Asset woliAsset = null;

        if(woli.AssetId != null) {
            return assetsMap.get(woli.AssetId);
        }

        ID termId = woli.Plc_TermId__c;
        if(termId == null) {
            Plc_TermId__c tmpTermId = codeToTermIds.get(woli.Plc_ExternalTermId__c);
            termId = tmpTermId != null ? tmpTermId.Id : null;
        }
        if(termId == null) {
            termId = woli.Plc_Parent__r.Asset.Plc_TermId__c;
        }
        System.debug('#### woli.assetId ' + woli.AssetId);
        List<Asset> tmpAssetLst = termIdToAssetMap.get(termId);
        if(tmpAssetLst == null || tmpAssetLst.isEmpty()) return woliAsset;

        for (Asset ast : tmpAssetLst) {
            if (ast.Status == ASSET_STATUS_INSTALLED && woli.AssetId == ast.Id) {
                woliAsset = ast;
                break;
            } else if (ast.Status == ASSET_STATUS_INSTALLED && codeToTermIds.get(woli.Plc_ExternalTermId__c).Id == ast.Plc_TermId__c) {
                woliAsset = ast;
                break;
            }
        }
        return woliAsset;
    }

    /**
     * Creates a Product Stock object
     *
     * @param woli
     * @param warehouse
     * @param extCatItem
     */
    private static Bit2Shop__Product_Stock__c createProductStock(WorkOrderLineItem woli,
            Bit2Shop__Warehouse__c warehouse,
            B2WExtCat__External_Catalog_Item__c extCatItem){

        LogTracker.debugLogBegin(CLASS_NAME, 'createProductStock');
        LogTracker.debugLogEnd(CLASS_NAME, 'createProductStock');
        return new Bit2Shop__Product_Stock__c(
                //description of the external catalog item
                Name                                    = extCatItem.Bit2Shop__Product_Description__c,
                //destination warehouse
                Bit2Shop__Warehouse_Id__c               = warehouse.Id,
                RecordTypeId                            = Plc_Utils.getRecordTypeId(PRODUCT_STOCK_RECORDTYPE_CURRENT,
                        Bit2Shop__Product_Stock__c.SObjectType.getDescribe().name),
                //external catalog reference from the WOLI
                Bit2Shop__External_Catalog_Item_Id__c   = extCatItem.Id,
                Bit2Shop__Inventory_Level__c            = PRODUCT_STOCK_INVENTORY_LEVEL_NEW,
                //period of the destination warehouse (installed WH)
                Bit2Shop__Period_Id__c                  = warehouse.Bit2Shop__Inventory_CurrentPeriodAtConfirmation__c,
                Bit2Shop__Stock_Qty__c                  = 0,
                Plc_WithdrawnQty__c                     = 0,
                Plc_OrderedQty__c                       = 0,
                Plc_UsableQty__c                        = 0
        );
    }
    /**
     * Creates the Configuration Items
     *
     * @param fType - Type of flow (not null for Substitution)
     * @param woli - WorkOrderLineItem elaborated
     * @param woliToProductStocksDestMap
     * @param woToConfigurationsMap
     * @param woToStockOrders
     * @param woToConfigItems
     * @param configItemsInsertList
     */
    private static void createConfigurationItem(FlowType fType,
            WorkOrderLineItem woli,
            ClassContext context,
            List<NE__OrderItem__c> configItemsInsertList){

        LogTracker.debugLogBegin(CLASS_NAME, 'createConfigurationItem');

        /*Boolean isInstall = (woli.WorkOrder.RecordTypeId == woRtypeInstallationId);
        Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);
        Boolean isDeactivation = (woli.WorkOrder.RecordTypeId == woRtypeDeactivationId);
        Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);*/

        String key = woli.WorkOrder.Id;
        String woliKey = woli.Id;
        if(fType != null) {
            key = getKey(fType, woli.WorkOrder.Id);
            woliKey = getKey(fType, woli.Id);
        }

        //gets Product Stock, Configuration, Stock Order
        Bit2Shop__Product_Stock__c pStockDest   = context.woliToproductStocksDestMap.get(woliKey);
        NE__Order__c configuration              = context.woToConfigurationsMap.get(key);
        Bit2Shop__StockOrder__c stockOrder      = context.woToStockOrders.get(key);

        //** Configuration items **
        //get all Configuration Items for the given Work Order => if is easier to get the Config.Item
        //related to the current Product Stock.
        //This for loop is used to compile this map,
        //so it handles the need to create a new Config.Item object
        Map<ID, NE__OrderItem__c> confiItemsMap = context.woToConfigItems.get(key);
        if(confiItemsMap == null){
            confiItemsMap = new Map<ID, NE__OrderItem__c>();
            context.woToConfigItems.put(key, confiItemsMap);
        }
        System.debug('### key/woliKey:'+key+'/'+woliKey);
        System.debug('### woToConfigItems:'+context.woToConfigItems);
        System.debug('### woToConfigurationsMap:'+context.woToConfigurationsMap);
        System.debug('### woliToproductStocksDestMap:'+context.woliToproductStocksDestMap);
        System.debug('### pStockDest:'+pStockDest);
        NE__OrderItem__c configItem = confiItemsMap.get(pStockDest.Id);

        //creates the Config.Item for the given Product Stock if not already created
        if(configItem == null){
            configItem = new NE__OrderItem__c(
                    RecordTypeId    = Plc_Utils.getRecordTypeId(CONFIG_ITEM_RECORDTYPE_STANDARD,
                            NE__OrderItem__c.SObjectType.getDescribe().name),
                    NE__OrderId__c  = configuration.Id,
                    NE__Qty__c      = 1,
                    NE__Status__c   = CONFIG_ITEM_STATUS_COMPLETED,
                    NE__Account__c  = stockOrder.Bit2Shop__Holding_Id__c,
                    Bit2Shop__Required_Serial__c = (woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_INSTALL) /*!isInstall*/
            );
            configItemsInsertList.add(configItem);
            confiItemsMap.put(pStockDest.Id, configItem);
        }
        LogTracker.debugLogEnd(CLASS_NAME, 'createConfigurationItem');
    }

    /**
     * Creates Shipments
     *
     * @param fType - Type of flow (not null for Substitution)
     * @param woli - WorkOrderLineItem elaborated
     * @param woliToProductStocksDestMap
     * @param woliToproductStocksOrigMap
     * @param woToStockOrders
     * @param woToConfigItems
     * @param woToShipmentsInbound
     * @param woToShipmentsOutbound
     */
    private static void createShipments(FlowType fType,
            WorkOrderLineItem woli,
            ClassContext context,
            List<Bit2Shop__Shipment__c> shipmentsInsertList
    ){

        LogTracker.debugLogBegin(CLASS_NAME, 'createShipments');
        /*Boolean isInstall = (woli.WorkOrder.RecordTypeId == woRtypeInstallationId);
        Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);
        Boolean isDeactivation = (woli.WorkOrder.RecordTypeId == woRtypeDeactivationId);
        Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);*/

        String woliKey = woli.Id;
        String key = woli.WorkOrder.Id;
        if(fType != null) {
            key = getKey(fType, woli.WorkOrder.Id);
            woliKey = getKey(fType, woli.Id);
        }

        //gets Product Stock, Configuration, Stock Order
        Bit2Shop__Product_Stock__c pStockDest   = context.woliToproductStocksDestMap.get(woliKey);
        Bit2Shop__Product_Stock__c pStockOrig   = context.woliToproductStocksOrigMap.get(woliKey);
        System.debug('## woliToproductStocksOrigMap: '+context.woliToproductStocksOrigMap);

        Bit2Shop__StockOrder__c stockOrder      = context.woToStockOrders.get(key);
        NE__OrderItem__c configurationItem      = context.woToConfigItems.get(key).get(pStockDest.Id);

        
        //** Shipments **
        //get all Shipments for the given Work Order => if is easier to get the Shipment
        //related to the current Product Stock.
        //This for loop is used to compile this map,
        //so it handles the need to create a new Shipment object
        //the Inbound and Outbound are speculas (the logic is done on the Inbound and if we have to create
        //the Shipment Inbound we create the Outbound as well)
        Map<ID, Bit2Shop__Shipment__c> shipmentsInboundMap = context.woToShipmentsInbound.get(key);
        Map<ID, Bit2Shop__Shipment__c> shipmentsOutboundMap = context.woToShipmentsOutbound.get(key);
        if (shipmentsInboundMap == null) {
            shipmentsInboundMap = new Map<ID, Bit2Shop__Shipment__c>();
            shipmentsOutboundMap = new Map<ID, Bit2Shop__Shipment__c>();
            context.woToShipmentsInbound.put(key, shipmentsInboundMap);
            context.woToShipmentsOutbound.put(key, shipmentsOutboundMap);
        }
        Bit2Shop__Shipment__c shipmentIn    = shipmentsInboundMap.get(pStockDest.Id);
        Bit2Shop__Shipment__c shipmentOut   = shipmentsOutboundMap.get(pStockOrig.Id);

        //creates the Config.Item for the given Product Stock if not already created
        if (shipmentIn == null) {

            Date endDate;
            if(context.woMap.get(woli.WorkOrder.Id).EndDate != null ){
            endDate = context.woMap.get(woli.WorkOrder.Id).EndDate.date();
            }else{
                endDate = System.now().date();
            }
            shipmentIn = new Bit2Shop__Shipment__c(
                    RecordTypeId                            = Plc_Utils.getRecordTypeId(SHIPMENT_RECORDTYPE_INBOUND,
                            Bit2Shop__Shipment__c.SObjectType.getDescribe().name),
                    Bit2Shop__Status__c                     = (fType == FlowType.Installation)? SHIPMENT_STATUS_CLOSED
                            : SHIPMENT_STATUS_PENDING,
                    Bit2Shop__Expected_Delivery_Date__c     = endDate,
                    Bit2Shop__Close_Date__c                 = (fType == FlowType.Installation) ? endDate
                            : null,
                    Bit2Shop__Date__c                       = endDate,
                    Bit2Shop__Shipped_Quantity__c           = 0,    //this will be incremented for each woli in the request
                    Bit2Shop__Stock_Order_Id__c             = stockOrder.Id,
                    Bit2Shop__Sub_Type__c                   = SHIPMENT_SUBTYPE_INBOUND,
                    Bit2Shop__Type__c                       = SHIPMENT_TYPE_FINAL,
                    Bit2Shop__Configuration_Item_Id__c      = configurationItem.Id,
                    Bit2Shop__Shipment_Document_Number__c   = 'Doc_'+configurationItem.Id,
                    //FB 22-02-2019: Adding lookup to Product Stock
                    Plc_ProductStock__c                     = pStockDest.Id,
                    OwnerId                                 = stockOrder.OwnerId
            );
            shipmentsInsertList.add(shipmentIn);
            shipmentsInboundMap.put(pStockDest.Id, shipmentIn);

            //if the Inbound shipment is created, must be created the Outbound one as well
            shipmentOut = shipmentIn.clone();
            shipmentOut.RecordTypeId            = Plc_Utils.getRecordTypeId(SHIPMENT_RECORDTYPE_OUTBOUND,
                    Bit2Shop__Shipment__c.SObjectType.getDescribe().name);
            shipmentOut.Bit2Shop__Sub_Type__c   = SHIPMENT_SUBTYPE_OUTBOUND;
            shipmentOut.Bit2Shop__Status__c     = SHIPMENT_STATUS_CLOSED;
            shipmentOut.Bit2Shop__Close_Date__c = endDate;
            //FB 22-02-2019: Adding lookup to Product Stock
            shipmentOut.Plc_ProductStock__c = pStockOrig.Id;

            shipmentsInsertList.add(shipmentOut);
            shipmentsOutboundMap.put(pStockOrig.Id, shipmentOut);
        }
        //increment the shipped quantity because of the current WOLI
        shipmentIn.Bit2Shop__Shipped_Quantity__c    += 1;
        shipmentOut.Bit2Shop__Shipped_Quantity__c   += 1;
        LogTracker.debugLogEnd(CLASS_NAME, 'createShipments');
    }

    /**
     * Creates Shipment Line Items of type Product
     *
     * @param fType
     * @param woli
     * @param woliToProductStocksDestMap
     * @param woliToproductStocksOrigMap
     * @param woToStockOrders
     * @param woToShipmentsInbound
     * @param woToShipmentsOutbound
     * @param shipmentToShipmentLineItemProductInbound
     * @param shipmentToShipmentLineItemProductOutbound
     * @param shipmentsItemsInsertList
     * @param woMap
     */
    private static void createShipmentLineItemsProduct(FlowType fType,
            WorkOrderLineItem woli,
            ClassContext context,
            List<Bit2Shop__Shipment_Line_Item__c> shipmentsItemsInsertList){

        LogTracker.debugLogBegin(CLASS_NAME, 'createShipmentLineItemsProduct');
        String key = woli.WorkOrder.Id;
        String woliKey = woli.Id;
        if(fType != null) {
            key = getKey(fType, woli.WorkOrder.Id);
            woliKey = getKey(fType, woli.Id);
        }

        //gets Product Stock, Configuration, Stock Order
        Bit2Shop__Product_Stock__c pStockDest   = context.woliToproductStocksDestMap.get(woliKey);
        Bit2Shop__Product_Stock__c pStockOrig   = context.woliToproductStocksOrigMap.get(woliKey);
        Bit2Shop__StockOrder__c stockOrder      = context.woToStockOrders.get(key);
        Bit2Shop__Shipment__c shipmentIn        = context.woToShipmentsInbound.get(key).get(pStockDest.Id);
        Bit2Shop__Shipment__c shipmentOut       = context.woToShipmentsOutbound.get(key).get(pStockOrig.Id);

        //looks for the "Product" Shipment Line Items for the given shipment and create them if not already created
        Bit2Shop__Shipment_Line_Item__c shLineItemIn    = context.shipmentToShipmentLineItemProductInbound.get(shipmentIn.Id);
        Bit2Shop__Shipment_Line_Item__c shLineItemOut   = context.shipmentToShipmentLineItemProductOutbound.get(shipmentOut.Id);

        //looks for the Stock History 2 for the given shipment and creates them if not present (they are coupled
        //with the Shipment Line Items
        //Bit2Shop__StockHistory2__c stockHistoryOut  = shipmentToStockHistoryOutbound.get(shipmentOut.Id);
        //Bit2Shop__StockHistory2__c stockHistoryIn   = shipmentToStockHistoryInbound.get(shipmentIn.Id);
        System.debug('@@@@ stock action: ' + stockOrder.Plc_TransferDetail__c);
        //the main Shipment Line Item of type product has not been created yet
        if(shLineItemOut == null){

            Date endDateVar;
            if(context.woMap.get(woli.WorkOrder.Id).EndDate != null) {
                endDateVar = context.woMap.get(woli.WorkOrder.Id).EndDate.date();
            } else {
                endDateVar = System.now().date();
            }
            shLineItemOut = new Bit2Shop__Shipment_Line_Item__c(
                    RecordTypeId                    =  Plc_Utils.getRecordTypeId(SHIPMENT_ITEM_RECORDTYPE_PRODUCT,
                                                                                 Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                    Bit2Shop__Type__c               = SHIPMENT_ITEM_TYPE_PRODUCT,
                    Bit2Shop__Status__c             = SHIPMENT_ITEM_STATUS_CLOSED,
                    Bit2Shop__Transfer_Detail_Id__c = stockOrder.Plc_TransferDetail__c,
                    Bit2Shop__Date__c               = endDateVar,
                    Bit2Shop__Requested_Quantity__c = shipmentOut.Bit2Shop__Shipped_Quantity__c,
                    Bit2Shop__Shipment_Id__c        = shipmentOut.Id,
                    Bit2Shop__Product_Stock_Id__c   = pStockOrig.Id
            );

            shLineItemIn = shLineItemOut.clone();
            shLineItemIn.Bit2Shop__Product_Stock_Id__c      = pStockDest.Id;
            if(fType == FlowType.Removal) {
                shLineItemIn.Bit2Shop__Requested_Quantity__c = shipmentIn.Bit2Shop__Shipped_Quantity__c;
                shLineItemIn.Bit2Shop__Received_Quantity__c  = null;
            } else {
                shLineItemIn.Bit2Shop__Received_Quantity__c = shipmentIn.Bit2Shop__Shipped_Quantity__c;
                shLineItemIn.Bit2Shop__Requested_Quantity__c    = shipmentIn.Bit2Shop__Shipped_Quantity__c;
            }

            shLineItemIn.Bit2Shop__Shipment_Id__c           = shipmentIn.Id;
            shLineItemIn.Bit2Shop__Stock_Action_Id__c       = null; //todo it is in standby
            shLineItemIn.Bit2Shop__Status__c                = SHIPMENT_ITEM_STATUS_PENDING;//SHIPMENT_ITEM_STATUS_CLOSED;

            shipmentsItemsInsertList.add(shLineItemIn);
            shipmentsItemsInsertList.add(shLineItemOut);

            context.shipmentToShipmentLineItemProductOutbound.put(shipmentOut.Id, shLineItemOut);
            context.shipmentToShipmentLineItemProductInbound.put(shipmentIn.Id, shLineItemIn);

            //triggers the status transition at the end of this process
            context.shipmentLineItemsTransitions.add(shLineItemIn);
        }

        LogTracker.debugLogEnd(CLASS_NAME, 'createShipmentLineItemsProduct');
    }

    /**
     * Create the Shipment Line Items of type "Serial"
     *
     * @param fType
     * @param woli
     * @param woliToProductStocksDestMap
     * @param woliToproductStocksOrigMap
     * @param woToStockOrders
     * @param woToShipmentsInbound
     * @param woToShipmentsOutbound
     * @param shipmentToShipmentLineItemProductInbound
     * @param shipmentToShipmentLineItemProductOutbound
     * @param shipmentsItemsInsertList
     * @param woMap
     * @param woliToStockSerialsMap
     * @param woliToAsset
     * @param extCatalogItemsMap
     * @param serialsToSerialStock2
     * @param termIdToAssetMap
     * @param codeToTermIds
     * @param stockSerialsMap
     */
    private static void createShipmentLineItemsSerial(FlowType fType,
            WorkOrderLineItem woli,
            ClassContext context,
            List<Bit2Shop__Shipment_Line_Item__c> shipmentsItemsInsertList){

        LogTracker.debugLogBegin(CLASS_NAME, 'createShipmentLineItemsSerial');

        /*Boolean isInstall = (woli.WorkOrder.RecordTypeId == woRtypeInstallationId);
        Boolean isUninstall = (woli.WorkOrder.RecordTypeId == woRtypeUninstallationId);
        Boolean isDeactivation = (woli.WorkOrder.RecordTypeId == woRtypeDeactivationId);
        Boolean isSubstitution = (woli.WorkOrder.RecordTypeId == woRtypeSubstitutionId);*/

        //if the WOLI is of Serial Type, we create the Serial Shipment Line Item and Serial Stock HIstory
        if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_INSTALL
                || String.isNotblank(woli.Plc_SerialNumber__c)){

            String key = woli.WorkOrder.Id;
            String woliKey = woli.Id;
            if(fType != null) {
                key = getKey(fType, woli.WorkOrder.Id);
                woliKey = getKey(fType, woli.Id);
            }

            //gets Product Stock, Configuration, Stock Order
            Bit2Shop__Product_Stock__c pStockDest = context.woliToproductStocksDestMap.get(woliKey);
            Bit2Shop__Product_Stock__c pStockOrig = context.woliToproductStocksOrigMap.get(woliKey);
            Bit2Shop__StockOrder__c stockOrder = context.woToStockOrders.get(key);
            Bit2Shop__Shipment__c shipmentIn = context.woToShipmentsInbound.get(key).get(pStockDest.Id);
            Bit2Shop__Shipment__c shipmentOut = context.woToShipmentsOutbound.get(key).get(pStockOrig.Id);

            //looks for the "Product" Shipment Line Items for the given shipment and create them if not already created
            Bit2Shop__Shipment_Line_Item__c shLineItemIn    = context.shipmentToShipmentLineItemProductInbound.get(shipmentIn.Id);
            Bit2Shop__Shipment_Line_Item__c shLineItemOut   = context.shipmentToShipmentLineItemProductOutbound.get(shipmentOut.Id);

            String extCatItemAlias = woli.Plc_ReferenceExternalCatalogItem__c;

            B2WExtCat__External_Catalog_Item__c extCatItem = context.extCatalogItemsMap.get(extCatItemAlias);
            String stockSerialKey = getStockSerial2Key(extCatItem.Plc_Manufacturer__r.Plc_Alias__c, woli.Plc_SerialNumber__c);
            Bit2Shop__Stock_Serials2__c stockSerial = context.serialsToSerialStock2.get(stockSerialKey);
            System.debug('### serialsToSerialStock2: '+context.serialsToSerialStock2);
            System.debug('### stockSerialKey: '+stockSerialKey);

            //in case of Deactivation and Uninstallation (and Substitution w/ deactivation)
            //the stock serial is got directly from the asset
            if(woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_INSTALL && 
               (woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_SUBSTITUTE || fType == FlowType.Removal) &&
               (woli.Plc_OperationType__c != WOLI_OPERATION_TYPE_TO_SUBSTCORR  || fType == FlowType.Removal)) {
                system.debug('### termIdToAssetMap: '+ context.termIdToAssetMap);
                system.debug('### codeToTermIds: '+ context.codeToTermIds);
                system.debug('### woli.Plc_TermId__c: '+ woli.Plc_TermId__c);
                system.debug('### woli.Plc_ExternalTermId__c: '+ woli.Plc_ExternalTermId__c);

                /*ID termId = woli.Plc_TermId__c;
                if(termId == null){
                    termId = context.codeToTermIds.get(woli.Plc_ExternalTermId__c).Id;
                }
                if(termId == null){
                    termId = woli.Plc_Parent__r.Asset.Plc_TermId__c;
                }*/

                Asset ast = getAssetForWoli(woli, context.codeToTermIds, context.termIdToAssetMap, context.assetsMap);
                if(ast == null || ast.Plc_StockSerial__c == null) {
                    throw new Plc_Exception('Error on WOLI ['+woliKey+', Asset: ['+(ast==null?null:ast.Id)+']]: found Installed asset null or without Stock Serial');
                }
                stockSerial = context.stockSerialsMap.get(ast.Plc_StockSerial__c);
                context.woliToAsset.put(wolikey, ast);
            }

            if(stockSerial == null) {
                throw new Plc_Exception('Stock Serial 2 not found (WOLI: ['+woliKey+'] Unique code:'+stockSerialKey+')');
            }

            context.woliToStockSerialsMap.put(woliKey, stockSerial);

            Date endDateVar;
            if(context.woMap.get(woli.WorkOrder.Id).EndDate != null) {
                endDateVar = context.woMap.get(woli.WorkOrder.Id).EndDate.date();
            } else {
                endDateVar = System.now().date();
            }

            Bit2Shop__Shipment_Line_Item__c serialOut = new Bit2Shop__Shipment_Line_Item__c(
                    RecordTypeId                    = Plc_Utils.getRecordTypeId(SHIPMENT_ITEM_RECORDTYPE_SERIAL,
                            Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                    Bit2Shop__Type__c               = SHIPMENT_ITEM_TYPE_SERIAL,
                    Bit2Shop__Status__c             = SHIPMENT_ITEM_STATUS_CLOSED,
                    Bit2Shop__Serial_Number__c      = woli.Plc_SerialNumber__c,
                    Bit2Shop__Target_Line_Item__c   = shLineItemOut.Id,
                    Bit2Shop__Transfer_Detail_Id__c = stockOrder.Plc_TransferDetail__c,
                    Bit2Shop__Date__c               = endDateVar,
                    Bit2Shop__Requested_Quantity__c  = 1,
                    Bit2Shop__Shipment_Id__c        = shipmentOut.Id,
                    Plc_StockSerial__c              = stockSerial.Id,
                    //FB 20190711 NEXIPLC-661 [START]
                    Bit2Shop__Product_Stock_Id__c   = stockSerial.Bit2Shop__Product_Stock_Id__c
                    //Bit2Shop__Product_Stock_Id__c   = pStockOrig.Id
                    //FB 20190711 NEXIPLC-661 [END]
            );


            //FB 20190711 NEXIPLC-661 [START]
            if (fType == FlowType.Installation) {
                if (!context.sliProductOutToProductStockMap.containsKey(serialOut.Bit2Shop__Target_Line_Item__c) && 
                    stockSerial.Bit2Shop__Product_Stock_Id__c != pStockOrig.Id) {
                    context.sliProductOutToProductStockMap.put(serialOut.Bit2Shop__Target_Line_Item__c, stockSerial.Bit2Shop__Product_Stock_Id__c);
                    context.shipmentOutToProductStockMap.put(serialOut.Bit2Shop__Shipment_Id__c, stockSerial.Bit2Shop__Product_Stock_Id__c);
                }
            }
            //FB 20190711 NEXIPLC-661 [END]


            Bit2Shop__Shipment_Line_Item__c serialIn    = serialOut.clone();
            if(fType == FlowType.Removal) {
                serialIn.Bit2Shop__Requested_Quantity__c = 1;
                serialIn.Bit2Shop__Received_Quantity__c  = null;
            }else{
                serialIn.Bit2Shop__Received_Quantity__c = 1;
                serialIn.Bit2Shop__Requested_Quantity__c    = 1;
            }
            serialIn.Bit2Shop__Target_Line_Item__c      = shLineItemIn.Id;
            serialIn.Bit2Shop__Shipment_Id__c           = shipmentIn.Id;
            serialIn.Bit2Shop__Status__c                = SHIPMENT_ITEM_STATUS_PENDING;
            serialIn.Bit2Shop__Received_Status__c       = ((fType == FlowType.Removal)
                    ?null
                    :SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED);
            serialIn.Bit2Shop__Stock_Action_Id__c       = null;
            serialIn.Bit2Shop__Product_Stock_Id__c   = pStockDest.Id;

            shipmentsItemsInsertList.add(serialIn);
            shipmentsItemsInsertList.add(serialOut);

            //triggers the status transition at the end of this process
            context.shipmentLineItemsTransitions.add(serialIn);
        }
        LogTracker.debugLogEnd(CLASS_NAME, 'createShipmentLineItemsSerial');
    }

    /**
     * Creates the Stock Order Share
     *
     * @param fType
     * @param wo
     * @param woToStockOrders
     * @param allWareshousesMap
     * @param stockOrderShares
     */
    private static void createStockOrderShare(FlowType fType,
            WorkOrder wo,
            ClassContext context,
            List<Bit2Shop__StockOrder__share> stockOrderShares){

        LogTracker.debugLogBegin(CLASS_NAME, 'createStockOrderShare');
        String key = wo.Id;
        if(fType != null) {
            key = getKey(fType, wo.Id);
        }

        Bit2Shop__StockOrder__c stockOrder = context.woToStockOrders.get(key);
        Bit2Shop__StockOrder__share share = new Bit2Shop__StockOrder__share(
                ParentId        = stockOrder.Id,
                UserOrGroupId   = context.allWareshousesMap
                        .get(stockOrder.Bit2Shop__Destination_Warehouse_Id__c)
                        .Bit2Shop__Dealer_Id__r.Bit2Shop__Group_Id__c,
                AccessLevel     = SHARE_ACCESS_LEVEL_EDIT,
                RowCause        = SHARE_ROW_CAUSE_MANUAL
        );
        Bit2Shop__StockOrder__share share2 = new Bit2Shop__StockOrder__share(
                ParentId        = stockOrder.Id,
                UserOrGroupId   = context.allWareshousesMap.get(stockOrder.Bit2Shop__Warehouse_Id__c).Bit2Shop__Dealer_Id__r.Bit2Shop__Group_Id__c,
                AccessLevel     = SHARE_ACCESS_LEVEL_EDIT,
                RowCause        = SHARE_ROW_CAUSE_MANUAL
        );
        stockOrderShares.add(share);
        stockOrderShares.add(share2);
        LogTracker.debugLogEnd(CLASS_NAME, 'createStockOrderShare');
    }

    /**
     * Creates the Shipment Shares
     *
     * @param fType
     * @param wo
     * @param woToShipments
     * @param woToStockOrders
     * @param allWareshousesMap
     * @param shipmentShares
     * @param isInbound
     */
    private static void createShipmentShare(String woId,
            ClassContext context,
            Map<String, Map<ID, Bit2Shop__Shipment__c>> woToShipments,
            List<Bit2Shop__Shipment__share> shipmentShares,
            Boolean isInbound){

        LogTracker.debugLogBegin(CLASS_NAME, 'createShipmentShare');
        String key = woId;


        Map<ID, Bit2Shop__Shipment__c> shipments = woToShipments.get(key);
        Bit2Shop__StockOrder__c stockOrder = context.woToStockOrders.get(key);

        for(ID pStockId : shipments.keyset()){
            Bit2Shop__Shipment__c shipment = shipments.get(pStockId);
            Bit2Shop__Warehouse__c destinationWH = context.allWareshousesMap.get(
                    (isInbound)
                            ?stockOrder.Bit2Shop__Destination_Warehouse_Id__c
                            :stockOrder.Bit2Shop__Warehouse_Id__c);

            Bit2Shop__Shipment__share shipmentShare = new Bit2Shop__Shipment__share(
                    ParentId = shipment.Id,
                    UserOrGroupId = destinationWH.Bit2Shop__Dealer_Id__r.Bit2Shop__Group_Id__c,
                    AccessLevel = SHARE_ACCESS_LEVEL_EDIT,
                    RowCause = SHARE_ROW_CAUSE_MANUAL
            );
            shipmentShares.add(shipmentShare);
        }
        LogTracker.debugLogEnd(CLASS_NAME, 'createShipmentShare');
    }

    private static void productStockElaboration(FlowType ftype,
            WorkOrderLineItem woli,
            Asset existingAsset,
            ClassContext context,
            List<Bit2Shop__Product_Stock__c> newPStocks
    ) {

        LogTracker.debugLogBegin(CLASS_NAME, 'productStockElaboration');
        String key = woli.WorkOrderId;
        String woliKey = woli.Id;
        if(fType != null) {
            key = getKey(fType, woli.WorkOrderId);
            woliKey = getKey(fType, woli.Id);
        }

        //search the Product Stock from the query map (that has key "warehouse_id + product_sku")
        //FB 14-02-2019
        B2WExtCat__External_Catalog_Item__c extCatItem;
        if (existingAsset == null) {
            extCatItem = context.extCatalogItemsMap.get(woli.Plc_ReferenceExternalCatalogItem__c);
        } else {
            extCatItem = existingAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r;
        }

        Id destinationWarehouseId = getWhDestination(woli, key, context);
        Id originWarehouseId      = getWhOrigin(woli, key, context);

        String pStockKeyDest = '' + destinationWarehouseId+extCatItem.Id;
        String pStockKeyOrig = '' + originWarehouseId+extCatItem.id;
        Bit2Shop__Product_Stock__c psDest = context.skuWHtoProductStockMap.get(pStockKeyDest);
        Bit2Shop__Product_Stock__c psOrig = context.skuWHtoProductStockMap.get(pStockKeyOrig);

        System.debug('######### pStockKeyDest ' +  destinationWarehouseId + '' + extCatItem.Id);
        System.debug('######### psDest        ' +  context.skuWHtoProductStockMap.get(pStockKeyDest));
        System.debug('######### pStockKeyOrig ' +  originWarehouseId + '' + extCatItem.Id);

        if(psDest != null) {
            context.woliToproductStocksDestMap.put(woliKey, psDest);
        } else {
            psDest = createProductStock(woli, context.allWareshousesMap.get(destinationWarehouseId), extCatItem);

            Integer index = newPStocks.indexOf(psDest);
            if (index == -1) {

                newPStocks.add(psDest);
                context.woliToproductStocksDestMap.put(woliKey, psDest);
            } else {
                context.woliToproductStocksDestMap.put(woliKey, newPStocks.get(index));
            }
        }

        if(psOrig != null) {
            System.debug('## psOrig (if):'+psOrig);
            context.woliToproductStocksOrigMap.put(woliKey, psOrig);
        } else {
            //Product Stock not found: create it
            psOrig = createProductStock(woli, context.allWareshousesMap.get(originWarehouseId), extCatItem);
            newPStocks.add(psOrig);
            System.debug('## psOrig (else):'+psOrig);
            context.woliToproductStocksOrigMap.put(woliKey, psOrig);
        }
        LogTracker.debugLogEnd(CLASS_NAME, 'productStockElaboration');
    }


    private static void newInstallationStockOrder(WorkOrder wo, ClassContext context){

        String transferDetailCode = STOCK_ORDER_TRANSDETAIL_MESSAINCAMPO;

        //transfer detail for current process
        Bit2Shop__TransferDetail__c tDetail = context.transferDetailsMap.get(transferDetailCode);

        if(tDetail == null){
            throw new Plc_Exception('[ERR:CL-0390301] Missing Transfer Detail ['+transferDetailCode+']');
        }
        //referenced WH on the WO
        Bit2Shop__Warehouse__c woWH = context.aliasToWarehouses.get(wo.Plc_LegacyWarehouseId__c);

        //origin WH
        Bit2Shop__Warehouse__c whOrigin = woWH;

        if(whOrigin == null){
            throw new Plc_Exception('[ERR:CL-0390303] Cannot find origin Warehouse record for Work Order ['+wo.Id+']');
        }

        //destination WH
        Bit2Shop__Warehouse__c whDestination = context.divisionToInstalledWarehousesMap.get('Installed');

        if(whDestination == null){
            throw new Plc_Exception('[ERR:CL-0390304] Cannot find destination Warehouse record for Work Order ['+wo.Id+']');
        }

        //Stock Ordere are all generated with Status "Generated": after every piece of the chain is actually created,
        //there will be a Status transition to the actual values (this way Action Details can trigger successfully, otherwise
        //their algorithm won't get any shipment line items to whom do their actions)
        //The same thing happens for Shipment Line Items (their status is changed after the Stock Orders status
        //are changed)
        Date endDateVar;

        if(context.woMap.get(wo.Id).EndDate != null ){
            endDateVar=context.woMap.get(wo.Id).EndDate.date();
        }else{
            endDateVar=System.now().date();
        }
        Bit2Shop__StockOrder__c so = new Bit2Shop__StockOrder__c(
                RecordtypeId                                = Plc_Utils.getRecordTypeId(STOCK_ORDER_RECORDTYPE_TRANSFER,
                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = STOCK_ORDER_STATUS_GENERATED,
                Plc_TransferDetail__c                       = tDetail.Id,
                Plc_WorkOrder__c                            = wo.Id,
                Bit2Shop__Date__c                           = endDateVar,
                Plc_ShippingDate__c                         = endDateVar,
                Plc_CloseDate__c                            = endDateVar,
                Bit2Shop__Transfer_Type__c                  = STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Bit2Shop__Point_Of_Sales_Id__c              = whOrigin.Bit2Shop__Dealer_Id__c,
                Bit2Shop__Holding_Id__c                     = whOrigin.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                Bit2Shop__Warehouse_Id__c                   = whOrigin.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = whDestination.Bit2Shop__Dealer_Id__c,
                Bit2Shop__Destination_Warehouse_Id__c       = whDestination.Id,
                OwnerId                                     = whOrigin.Bit2Shop__Dealer_Id__r.OwnerId
        );

        String key = getKey(FlowType.Installation, wo.Id);

        context.stockOrdersTransitionsMap.put(key, STOCK_ORDER_STATUS_CLOSED);

        LogTracker.debugLog(CLASS_NAME, 'createInstallationStockOrder', '## Stock Order: ' + so);

        context.woToStockOrders.put(key, so);

    }

    private static void newRemovalStockOrder(WorkOrder wo, ClassContext context){

        String transferDetailCode = STOCK_ORDER_TRANSDETAIL_RITIRODALCAMPO;

        //transfer detail for current process
        Bit2Shop__TransferDetail__c tDetail = context.transferDetailsMap.get(transferDetailCode);

        if(tDetail == null){
            throw new Plc_Exception('[ERR:CL-0390301] Missing Transfer Detail ['+transferDetailCode+']');
        }
        //referenced WH on the WO
        Bit2Shop__Warehouse__c woWH = context.aliasToWarehouses.get(wo.Plc_LegacyWarehouseId__c);

        //origin WH
        Bit2Shop__Warehouse__c whOrigin = context.divisionToInstalledWarehousesMap.get('Installed');

        if(whOrigin == null){
            throw new Plc_Exception('[ERR:CL-0390303] Cannot find origin Warehouse record for Work Order ['+wo.Id+']');
        }

        //destination WH
        Bit2Shop__Warehouse__c whDestination = woWH;

        if(whDestination == null){
            throw new Plc_Exception('[ERR:CL-0390304] Cannot find destination Warehouse record for Work Order ['+wo.Id+']');
        }

        //Stock Ordere are all generated with Status "Generated": after every piece of the chain is actually created,
        //there will be a Status transition to the actual values (this way Action Details can trigger successfully, otherwise
        //their algorithm won't get any shipment line items to whom do their actions)
        //The same thing happens for Shipment Line Items (their status is changed after the Stock Orders status
        //are changed)
        Date endDateVar;

        if(context.woMap.get(wo.Id).EndDate != null ) {
            endDateVar = context.woMap.get(wo.Id).EndDate.date();
        } else {
            endDateVar = System.now().date();
        }

        Bit2Shop__StockOrder__c so = new Bit2Shop__StockOrder__c(
                RecordtypeId                                = Plc_Utils.getRecordTypeId(STOCK_ORDER_RECORDTYPE_TRANSFER,
                                                                                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = STOCK_ORDER_STATUS_GENERATED,
                Plc_TransferDetail__c                       = tDetail.Id,
                Plc_WorkOrder__c                            = wo.Id,
                Bit2Shop__Date__c                           = endDateVar,
                Plc_ShippingDate__c                         = endDateVar,
                Plc_CloseDate__c                            = endDateVar,
                Bit2Shop__Transfer_Type__c                  = STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Bit2Shop__Point_Of_Sales_Id__c              = whOrigin.Bit2Shop__Dealer_Id__c,
                Bit2Shop__Holding_Id__c                     = whOrigin.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                Bit2Shop__Warehouse_Id__c                   = whOrigin.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = whDestination.Bit2Shop__Dealer_Id__c,
                Bit2Shop__Destination_Warehouse_Id__c       = whDestination.Id,
                OwnerId                                     = whOrigin.Bit2Shop__Dealer_Id__r.OwnerId
        );

        String key = getKey(FlowType.Removal, wo.Id);

        context.stockOrdersTransitionsMap.put(key, STOCK_ORDER_STATUS_ASSIGNED);

        LogTracker.debugLog(CLASS_NAME, 'createRemovalStockOrder', '## Stock Order: ' + so);

        context.woToStockOrders.put(key, so);

    }

    private static void newDeactivationStockOrder(WorkOrder wo, ClassContext context) {
        String transferDetailCode = STOCK_ORDER_TRANSDETAIL_DISATTIVAZIONE;

        //transfer detail for current process
        Bit2Shop__TransferDetail__c tDetail = context.transferDetailsMap.get(transferDetailCode);

        if(tDetail == null){
            throw new Plc_Exception('[ERR:CL-0390301] Missing Transfer Detail ['+transferDetailCode+']');
        }
        //referenced WH on the WO
        Bit2Shop__Warehouse__c woWH = context.aliasToWarehouses.get(wo.Plc_LegacyWarehouseId__c);

        //origin WH
        Bit2Shop__Warehouse__c whOrigin = null;

        //NOTE: deactivation has all WOLI with Operation Type = ToDeactivate,
        //while Uninstallation can have one or more ToDeactivate: if it
        //doesn't have any ToRemove, than we consider it like a Deactivation

        //gets the first WOLI and the Installed Asset on the list of Assets per TermId, this is enough to
        //get the Stock Serial 2 and so the origin Warehouse
        Asset woliAsset = null;
        for(WorkOrderLineItem woli : context.lineItemsMap.values()) {

            woliAsset = getAssetForWoli(woli, context.codeToTermIds, context.termIdToAssetMap, context.assetsMap);

            //try to get parent's asset, if any this may not be the right warehouse
            // (tha parent asset may already have moved to irrecoverable)
            // but its logistic division is right
            if(woliAsset == null
                    && woli.Plc_Parent__c != null
                    && woli.Plc_Parent__r.Asset.Plc_StockSerial__c != null){
                woliAsset = woli.Plc_Parent__r.Asset;//.Plc_StockSerial__c
            }

            if(woliAsset != null) break;
        }

        if(woliAsset == null){
            throw new Plc_Exception('[ERR:CL-0390302] Cannot find an active Asset for Work Order ['+wo.Id+']');
        }

        Bit2Shop__Stock_Serials2__c serialStock = context.stockSerialsMap.get(woliAsset.Plc_StockSerial__c);
        whOrigin = context.allWareshousesMap.get(serialStock.Bit2Shop__Warehouse_Id__c);

        whOrigin = context.divisionToInstalledWarehousesMap.get('Installed');

        if(whOrigin == null){
            throw new Plc_Exception('[ERR:CL-0390303] Cannot find origin Warehouse record for Work Order ['+wo.Id+']');
        }

        //destination WH
        Bit2Shop__Warehouse__c whDestination = context.divisionToIrrecoverableWarehousesMap.get('Irrecoverable');

        if(whDestination == null){
            throw new Plc_Exception('[ERR:CL-0390304] Cannot find destination Warehouse record for Work Order ['+wo.Id+']');
        }

        //Stock Ordere are all generated with Status "Generated": after every piece of the chain is actually created,
        //there will be a Status transition to the actual values (this way Action Details can trigger successfully, otherwise
        //their algorithm won't get any shipment line items to whom do their actions)
        //The same thing happens for Shipment Line Items (their status is changed after the Stock Orders status
        //are changed)
        Date endDateVar;

        if(context.woMap.get(wo.Id).EndDate != null ) {
            endDateVar=context.woMap.get(wo.Id).EndDate.date();
        }else{
            endDateVar=System.now().date();
        }

        Bit2Shop__StockOrder__c so = new Bit2Shop__StockOrder__c(
                RecordtypeId                                = Plc_Utils.getRecordTypeId(STOCK_ORDER_RECORDTYPE_TRANSFER,
                                                                                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = STOCK_ORDER_STATUS_GENERATED,
                Plc_TransferDetail__c                       = tDetail.Id,
                Plc_WorkOrder__c                            = wo.Id,
                Bit2Shop__Date__c                           = endDateVar,
                Plc_ShippingDate__c                         = endDateVar,
                Plc_CloseDate__c                            = endDateVar,
                Bit2Shop__Transfer_Type__c                  = STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Bit2Shop__Point_Of_Sales_Id__c              = whOrigin.Bit2Shop__Dealer_Id__c,
                Bit2Shop__Holding_Id__c                     = whOrigin.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                Bit2Shop__Warehouse_Id__c                   = whOrigin.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = whDestination.Bit2Shop__Dealer_Id__c,
                Bit2Shop__Destination_Warehouse_Id__c       = whDestination.Id,
                OwnerId                                     = whOrigin.Bit2Shop__Dealer_Id__r.OwnerId
        );

        String key = getKey(FlowType.Deactivation, wo.Id);

        context.stockOrdersTransitionsMap.put(key, STOCK_ORDER_STATUS_CLOSED);

        LogTracker.debugLog(CLASS_NAME, 'createDeactivationStockOrder', '## Stock Order: ' + so);

        context.woToStockOrders.put(key, so);
    }

    private static NE__Order__c createConfiguration(Bit2Shop__StockOrder__c stockOrder){
        NE__Order__c conf = new NE__Order__c(
            RecordTypeId                = Plc_Utils.getRecordTypeId(CONFIGURATION_RECORDTYPE_STOCK_ORDER,
                                                                    NE__Order__c.SObjectType.getDescribe().name),
            Bit2Shop__StockOrder__c     = stockOrder.Id,
            Bit2Shop__Cost_Total__c     = 0,
            NE__AccountId__c            = stockOrder.Bit2Shop__Holding_Id__c,
            NE__OrderStatus__c          = CONFIGURATION_ORDER_STATUS_COMPLETED,
            NE__ConfigurationStatus__c  = CONFIGURATION_STATUS_INPROGRESS,
            NE__Version__c              = 1
        );
        return conf;
    }

    private static Id getWhDestination(WorkOrderLineItem woli, String key, ClassContext context) {
        
        if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {

            //referenced warehouse on the WO
            Bit2Shop__Warehouse__c woWH = context.aliasToWarehouses.get(woli.WorkOrder.Plc_LegacyWarehouseId__c);            
            //destination WH
            Bit2Shop__Warehouse__c whDestination = context.divisionToInstalledWarehousesMap.get('Installed');
            return whDestination.Id;
        }

        return context.woToStockOrders.get(key).Bit2Shop__Destination_Warehouse_Id__c;        
    }

    private static Id getWhOrigin(WorkOrderLineItem woli, String key, ClassContext context) {
        
        if(woli.Plc_OperationType__c == WOLI_OPERATION_TYPE_TO_RECONFCORR) {

            //referenced warehouse on the WO
            Bit2Shop__Warehouse__c whOrigin = context.aliasToWarehouses.get(woli.WorkOrder.Plc_LegacyWarehouseId__c);
            //origin WH
            return whOrigin.Id;
        }

        return context.woToStockOrders.get(key).Bit2Shop__Warehouse_Id__c;        
    }

}