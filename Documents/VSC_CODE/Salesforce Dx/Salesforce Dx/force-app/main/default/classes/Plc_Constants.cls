/**
 * Public class to collect constants used in all PLC code base
 * 
 * acronyms:
 * B2S = BIT2SHOP
 * ns = suffix of any inner subclass that acts as a namespace for the given values
 * WRPG = wrts_prcgvr
 * 
 * use these guidelines to name new constants:
 * Plc_Constants.<package_objectname>.<package>_<field>_<value>
 * Plc_Constants.<package_objectname>.<package>_<recordtype>_<value>
 * 
 * where:
 * <package_objectname>: the name of the object with a package prefix, when needed; 
 *                       use camelcase for objectname
 *                       use underscore only as separator between prefix and object name
 *                       example: B2S_StockOrder
 * <field>|<recordtype>: the developer name of a field or a recordtype
 *                       use camelcase, do not use underscores
 *                       example: PlcTipology 
 * <value>: a name associated to a particular value that a field can be assigned 
 *          use camelcase, do not use underscores  
 *          example: ToBeVerified, Installed, InProgress
 * <package>: a prefix for a package name (or a short acronym) if needed; 
 *            use camelcase, do not use underscores
 *            example: B2S_xxxx, Bit2Shop_xxxx, NE_xxxx
 * 
 * example of usage: 
 * String soRtTransferDevName = Plc_Constants.B2S_StockOrder.RecordType_Transfer;
 * String soRtTakeChargeDevName = Plc_Constants.B2S_StockOrder.B2S_Status_TakeCharge;
 *
 * you can still define your constants in your classes:
 * example:
 * private static final String WO_RT_INSTALLATION   = Plc_Constants.WorkOrder.RecordType_Installation;
 * private static final String WO_RT_UNINSTALLATION = Plc_Constants.WorkOrder.RecordType_Uninstallation;
 *  
 * @author Carlo Muntoni
 * @date Creation 2019-02-26
 * @version 1.0
 *
 * @history
 * 2019-02-26 - Carlo Muntoni - first implementation
 */
public class Plc_Constants {

    //wrts_prcgvr__Activity__c
    private static WRPG_Activity_ns wrpgActivity_ns;
    public static WRPG_Activity_ns WRPG_Activity {
        get {
            if (wrpgActivity_ns == null) wrpgActivity_ns = new WRPG_Activity_ns();
            return wrpgActivity_ns;
        }
    }
    public class WRPG_Activity_ns {
        public String RecordType_PlcReport { get { return 'Plc_Report'; } }

        //add more here...
    }

    //Bit2Shop__Warehouse__c
    private static B2S_Warehouse_ns b2sWarehouse_ns;
    public static B2S_Warehouse_ns B2S_Warehouse {
        get {
            if (b2sWarehouse_ns == null) b2sWarehouse_ns = new B2S_Warehouse_ns();
            return b2sWarehouse_ns;
        }
    }
    public class B2S_Warehouse_ns {
        public String PlcTipology_Installed     { get { return 'Installed'; } }
        public String PlcTipology_Irrecoverable { get { return 'Irrecoverable'; } }
        public String PlcTipology_Generic       { get { return 'Generic'; } }

        //add more here...
    }

    //Bit2Shop__StockActionsDetail__c
    private static B2S_StockActionsDetail_ns b2sStockActionsDetail_ns;
    public static B2S_StockActionsDetail_ns B2S_StockActionsDetail {
        get {
            if (b2sStockActionsDetail_ns == null) b2sStockActionsDetail_ns = new B2S_StockActionsDetail_ns();
            return b2sStockActionsDetail_ns;
        }
    }
    public class B2S_StockActionsDetail_ns {

        public String PlcProductType_Product { get { return 'Product'; } }
        public String PlcProductType_Serial  { get { return 'Serial'; } }
        public String PlcProductType_Both    { get { return 'Both'; } }

        public String B2S_TargetObject_ProductStock  { get { return 'Product_Stock__c'; } }
        public String B2S_TargetObject_StockSerials2 { get { return 'Stock_Serials2__c'; } }
        public String B2S_TargetObject_Warehouse     { get { return 'Warehouse__c'; } }

        public String B2S_TargetAction_IncreaseQty     { get { return 'Increase Qty'; } }
        public String B2S_TargetAction_DecreaseQty     { get { return 'Decrease Qty'; } }
        public String B2S_TargetAction_UpdateField     { get { return 'Update Field'; } }
        public String B2S_TargetAction_MoveToWarehouse { get { return 'Move To Warehouse'; } }

        public String PlcStatusTrigger_StockOrder       { get { return 'StockOrder'; } }
        public String PlcStatusTrigger_ShipmentLineItem { get { return 'ShipmentLineItem'; } }

/** [START MOD 20/03/2019 16:07]@Author:marco.lebellini@/webresults.it @Description: NEXIPLC-452**/
        public String Stock_Action_Date_Value_Blank      { get { return 'BLANK'; } } //'selectable value on target date field update';
        public String Stock_Action_Date_Value_Yesterday  { get { return 'YESTERDAY'; } } //'selectable value on target date field update';
        public String Stock_Action_Date_Value_Today      { get { return 'TODAY'; } } //'selectable value on target date field update';
        public String Stock_Action_Date_Value_Tomorrow   { get { return 'TOMORROW'; } } //'selectable value on target date field update';
        public String Stock_Action_Date_Value_Next_Week  { get { return 'NEXT_WEEK'; } } //'selectable value on target date field update';
        public String Stock_Action_Date_Value_Next_Month { get { return 'NEXT_MONTH'; } } //'selectable value on target date field update';
        public String Stock_Action_Date_Value_Next_Year  { get { return 'NEXT_YEAR'; } } //'selectable value on target date field update';
/** [START MOD 20/03/2019 16:07]@Author:marco.lebellini@/webresults.it @Description: NEXIPLC-452**/
        //add more here...
    }

    //XXXX__share
    private static Object_Share_ns objectShare_ns;
    public static Object_Share_ns ObjectShare {
        get {
            if (objectShare_ns == null) objectShare_ns = new Object_Share_ns();
            return objectShare_ns;
        }
    }
    public class Object_Share_ns {
        public String AccessLevel_Edit { get { return 'Edit'; } }
        public String RowClause_Manual { get { return 'Manual'; } }
    }


    //Bit2Shop__StockOrder__c
    private static B2S_StockOrder_ns b2sStockOrder_ns;
    public static B2S_StockOrder_ns B2S_StockOrder {
        get {
            if (b2sStockOrder_ns == null) b2sStockOrder_ns = new B2S_StockOrder_ns();
            return b2sStockOrder_ns;
        }
    }
    public class B2S_StockOrder_ns {

        public String RecordType_Transfer { get { return 'Transfer'; } }

        public String B2S_Status_TakeCharge         { get { return 'Taken in charge'; } }
        public String B2S_Status_Assigned           { get { return 'Assigned'; } }
        public String B2S_Status_Closed             { get { return 'Closed'; } }
        public String B2S_Status_Generated          { get { return 'Generated'; } }
        public String B2S_Status_ClosedWithResLines { get { return 'Closed with residual lines'; } }
        public String B2S_Status_Suspended          { get { return 'Suspended'; } }
        public String B2S_Status_Canceled           { get { return 'Canceled'; } }

        //Bit2Shop__StockOrder__share
        //public String Share_AccessLevel { get { return 'Edit'; } }
        //public String Share_RowClause   { get { return 'Manual'; } }

        //add more here...
    }

    //Bit2Shop__TransferDetail__c
    private static B2S_TransferDetail_ns b2sTransferDetail_ns;
    public static B2S_TransferDetail_ns B2S_TransferDetail {
        get {
            if (b2sTransferDetail_ns == null) b2sTransferDetail_ns = new B2S_TransferDetail_ns();
            return b2sTransferDetail_ns;
        }
    }
    public class B2S_TransferDetail_ns {

        public String B2S_TranferType_Stock2OtherShop { get { return 'Stock2OtherShop'; } }

        public String B2S_Code_Dismissione    { get { return 'DISM_DL'; } }
        public String B2S_Code_ResoDaVendita  { get { return 'RES_VEN'; } }
        public String B2S_Code_InvioCNexi     { get { return 'C_NEX'; } }
        public String B2S_Code_InvioCNexiDisp { get { return 'C_NEX_DISP'; } }
        public String B2S_Code_ResoInvioCNexi { get { return 'RESO_NEX'; } }
        public String B2S_Code_MessaInCampo   { get { return 'MESSAINCAMPO'; } }
        public String B2S_Code_Ritiro         { get { return 'RITIRO'; } }
        public String B2S_Code_Disatt         { get { return 'DISATT'; } }

        public String PlcFilterDestinationDealer_Mantainer    { get { return 'Mantainer'; } }
        public String PlcFilterDestinationDealer_Manufacturer { get { return 'Manufacturer'; } }
        public String PlcFilterDestinationDealer_Repairer     { get { return 'Repairer'; } }
        public String PlcFilterDestinationDealer_Scrapyard    { get { return 'Scrapyard'; } }

        //add more here...
    }


    //Bit2Shop__Shipment__c
    private static B2S_Shipment_ns b2sShipment_ns;
    public static B2S_Shipment_ns B2S_Shipment {
        get {
            if (b2sShipment_ns == null) b2sShipment_ns = new B2S_Shipment_ns();
            return b2sShipment_ns;
        }
    }
    public class B2S_Shipment_ns {

        public String RecordType_InboundShipment  { get { return 'Inbound_Shipment'; } }
        public String RecordType_OutboundShipment { get { return 'Outbound_Shipment'; } }

        public String B2S_Status_Pending   { get { return 'Pending'; } }
        public String B2S_Status_Closed    { get { return 'Closed'; } }
        public String B2S_Status_Rejected  { get { return 'Rejected'; } }
        public String B2S_Status_Returning { get { return 'Returning'; } }
        public String B2S_Status_Returned  { get { return 'Returned'; } }

        public String B2S_Type_Partial { get { return 'Partial'; } }
        public String B2S_Type_Final   { get { return 'Final'; } }

        public String B2S_Subtype_Inbound  { get { return 'Inbound'; } }
        public String B2S_Subtype_Outbound { get { return 'Outbound'; } }

        //add more here...
    }

    //Bit2Shop__Shipment_Line_Item__c
    private static B2S_ShipmentLineItem_ns b2sShipmentLineItem_ns;
    public static B2S_ShipmentLineItem_ns B2S_ShipmentLineItem {
        get {
            if (b2sShipmentLineItem_ns == null) b2sShipmentLineItem_ns = new B2S_ShipmentLineItem_ns();
            return b2sShipmentLineItem_ns;
        }
    }
    public class B2S_ShipmentLineItem_ns {

        public String RecordType_Product          { get { return 'Shipment_Line_Item_Product'; } }
        public String RecordType_Serial           { get { return 'Shipment_Line_Item_Serial'; } }
        public String RecordType_InboundShipments { get { return 'Inbound_Shipment'; } }

        public String B2S_Status_Closed  { get { return 'Closed'; } }
        public String B2S_Status_Pending { get { return 'Pending'; } }

        public String B2S_ReceivedStatus_NotReceived { get { return 'Not Received'; } }
        public String B2S_ReceivedStatus_Received    { get { return 'Received'; } }

        public String B2S_Type_Product { get { return 'Product'; } }
        public String B2S_Type_Serial  { get { return 'Serial'; } }

        //add more here...
    }

    //Bit2Shop__Dealer__c
    private static B2S_Dealer_ns b2sDealer_ns;
    public static B2S_Dealer_ns B2S_Dealer {
        get {
            if (b2sDealer_ns == null) b2sDealer_ns = new B2S_Dealer_ns();
            return b2sDealer_ns;
        }
    }
    public class B2S_Dealer_ns {
        public String RecordType_PlcParentDealer { get { return 'Plc_ParentDealer'; } }
        public String RecordType_PlcChildDealer  { get { return 'Plc_ChildDealer'; } }

        //add more here...
    }

    //WorkOrder
    private static WorkOrder_ns workOrder_ns;
    public static WorkOrder_ns WorkOrder {
        get {
            if (workOrder_ns == null) workOrder_ns = new WorkOrder_ns();
            return workOrder_ns;
        }
    }
    public class WorkOrder_ns {

        public String RecordType_Installation   { get { return 'Installation'; } }
        public String RecordType_Uninstallation { get { return 'Uninstallation'; } }
        public String RecordType_Deactivation   { get { return 'Deactivation'; } }
        public String RecordType_Substitution   { get { return 'Substitution'; } }
        public String RecordType_Corr           { get { return 'Corr'; } }

        //add more here...
    }


    //WorkOrderLineItems 
    private static WorkOrderLineItems_ns workOrderLineItems_ns;
    public static WorkOrderLineItems_ns WorkOrderLineItems {
        get {
            if (workOrderLineItems_ns == null) workOrderLineItems_ns = new WorkOrderLineItems_ns();
            return workOrderLineItems_ns;
        }
    }
    public class WorkOrderLineItems_ns {

        public String PlcOperationType_ToInstall         { get { return 'ToInstall'; } }
        public String PlcOperationType_ToRemove          { get { return 'ToRemove'; } }
        public String PlcOperationType_ToSubstitute      { get { return 'ToSubstitute'; } }
        public String PlcOperationType_ToDeactivate      { get { return 'ToDeactivate'; } }
        public String PlcOperationType_NoOperation       { get { return 'NoOperation'; } }
        public String PlcOperationType_ToReconfigureCorr { get { return 'ToReconfigureCorr'; } }
        public String PlcOperationType_ToSubstituteCorr  { get { return 'ToSubstituteCorr'; } }

        public String Status_Executed    { get { return 'Executed'; } }
        public String Status_NotExecuted { get { return 'NotExecuted'; } }

        //add more here...
    }


    //Asset 
    private static Asset_ns asset_ns;
    public static Asset_ns Asset {
        get {
            if (asset_ns == null) asset_ns = new Asset_ns();
            return asset_ns;
        }
    }
    public class Asset_ns {

        public String RecordType_PlcTechnicalAsset { get { return 'Plc_TechnicalAsset'; } }

        public String Status_Installed   { get { return 'Installed'; } }
        public String Status_Uninstalled { get { return 'Uninstalled'; } }

        //add more here...
    }

    //Account
    private static Account_ns account_ns;
    public static Account_ns Account {
        get {
            if (account_ns == null) account_ns = new Account_ns();
            return account_ns;
        }
    }
    public class Account_ns {

        public String RecordType_PlcSupplier { get { return 'Plc_Supplier'; } }

        //add more here...
    }

    //Contact
    private static Contact_ns contact_ns;
    public static Contact_ns contact {
        get {
            if (contact_ns == null) contact_ns = new Contact_ns();
            return contact_ns;
        }
    }
    public class Contact_ns {

        public String RecordType_PlcReferenteGenerico { get { return 'Plc_ReferenteGenerico'; } }

        //add more here...
    }

    //Bit2Shop__Product_Stock__c
    private static B2S_ProductStock_ns b2sProductStock_ns;
    public static B2S_ProductStock_ns B2S_ProductStock {
        get {
            if (b2sProductStock_ns == null) b2sProductStock_ns = new B2S_ProductStock_ns();
            return b2sProductStock_ns;
        }
    }
    public class B2S_ProductStock_ns {

        public String RecordType_Current { get { return 'Current'; } }

        public String B2S_InventoryLevel_New          { get { return 'New'; } }
        public String B2S_InventoryLevel_Refurbished  { get { return 'Refurbished'; } }
        public String B2S_InventoryLevel_Dismissed    { get { return 'Dismissed'; } }
        public String B2S_InventoryLevel_Stolen       { get { return 'Stolen'; } }
        public String B2S_InventoryLevel_Defective    { get { return 'Defective'; } }
        public String B2S_InventoryLevel_ToBeReturned { get { return 'To be returned'; } }

        //add more here...
    }


    //NE__Order__c
    private static NE_Order_ns neOrder_ns;
    public static NE_Order_ns NE_Order {
        get {
            if (neOrder_ns == null) neOrder_ns = new NE_Order_ns();
            return neOrder_ns;
        }
    }
    public class NE_Order_ns {
        public String RecordType_StockOrder { get { return 'Stock_Order'; } }

        public String NE_OrderStatus_Pending   { get { return 'Pending'; } }
        public String NE_OrderStatus_Completed { get { return 'Completed'; } }

        public String NE_ConfigurationStatus_InProgress { get { return 'In progress'; } }
        //add more here...
    }


    //NE__OrderItem__c
    private static NE_OrderItem_ns neOrderItem_ns;
    public static NE_OrderItem_ns NE_OrderItem {
        get {
            if (neOrderItem_ns == null) neOrderItem_ns = new NE_OrderItem_ns();
            return neOrderItem_ns;
        }
    }
    public class NE_OrderItem_ns {
        public String RecordType_Standard { get { return 'StanStandarddard'; } }

        public String NE_Status_Pending   { get { return 'Pending'; } }
        public String NE_Status_Completed { get { return 'Completed'; } }
        //add more here...
    }


    //B2WExtCat__External_Catalog_Item__c
    private static B2WExtCat_ExternalCatalogItem_ns neExternalCatalogItem_ns;
    public static B2WExtCat_ExternalCatalogItem_ns B2WExtCat_ExternalCatalogItem {
        get {
            if (neExternalCatalogItem_ns == null) neExternalCatalogItem_ns = new B2WExtCat_ExternalCatalogItem_ns();
            return neExternalCatalogItem_ns;
        }
    }
    public class B2WExtCat_ExternalCatalogItem_ns {
        public String PlcCategoryProduct { get { return 'Product'; } }
        //add more here...
    }


    //Bit2Shop__Stock_Serials2__c
    private static B2S_StockSerials2_ns b2sStockSerials2_ns;
    public static B2S_StockSerials2_ns B2S_StockSerials2 {
        get {
            if (b2sStockSerials2_ns == null) b2sStockSerials2_ns = new B2S_StockSerials2_ns();
            return b2sStockSerials2_ns;
        }
    }
    public class B2S_StockSerials2_ns {
        public String B2S_Status_New          { get { return 'New'; } }
        public String B2S_Status_Withdrawn    { get { return 'Withdrawn'; } }
        public String B2S_Status_Available    { get { return 'Available'; } }
        public String B2S_Status_ToBeVerified { get { return 'To be verified'; } }
        public String B2S_Status_Installed    { get { return 'Installed'; } }
        public String B2S_Status_ReceivedFailure    { get { return 'Received failure'; } }
        public String B2S_Status_Decommissioned    { get { return 'Decommissioned'; } }
        public String B2S_Status_ToBeDecommissioned    { get { return 'To be decommissioned'; } }
        public String B2S_Status_TamperedWith    { get { return 'Tampered with'; } }
        public String B2S_Status_Irrecoverable    { get { return 'Irrecoverable'; } }
        //add more here...
    }


    //Plc_Reservation__c     
    private static PLC_Reservation_ns plcReservation_ns;
    public static PLC_Reservation_ns PLC_Reservation {
        get {
            if (plcReservation_ns == null) plcReservation_ns = new PLC_Reservation_ns();
            return plcReservation_ns;
        }
    }
    public class PLC_Reservation_ns {
        public String PlcStatus_NotReserved { get { return 'NotReserved'; } }
        public String PlcStatus_Reserved    { get { return 'Reserved'; } }
        //add more here...
    }

    //Custom permission
    private static CustomPermission_ns customPermission_ns;
    public static CustomPermission_ns customPermission {
        get {
            if (CustomPermission_ns == null) CustomPermission_ns = new CustomPermission_ns();
            return CustomPermission_ns;
        }
    }
    public class CustomPermission_ns {
        public String PlcMergeStockSerialFromUndefined { get { return 'Plc_MergeStockSerialFromUndefined'; } }
        public String PlcTakeInChargeStockOrder        { get { return 'Plc_TakeInChargeStockOrder'; } }
        public String PlcConfirmGoodsReceiving         { get { return 'Plc_ConfirmGoodsReceiving'; } }
        public String PlcConfirmDistributionList       { get { return 'Plc_ConfirmDistributionList'; } }
        public String PlcEditStockSerial               { get { return 'Plc_EditStockSerial'; } }
        public String PlcManageWarehouseProvince       { get { return 'Plc_ManageWarehouseProvince'; } }
        public String Plc_HandleAllTransferDetails     { get { return 'Plc_HandleAllTransferDetails'; } }
        public String PlcProductStockConsolidation     { get { return 'Plc_ProductStockConsolidation'; } }
        public String PlcGoodsHandling                 { get { return 'Plc_GoodsHandling'; } }
        public String PlcStocksManagement              { get { return 'Plc_StocksManagement'; } }
        public String PlcSerialsCensus                 { get { return 'Plc_SerialsCensus'; } }
        public String PlcSerialsUpdate                 { get { return 'Plc_SerialsUpdate'; } }
        public String PlcGoodsReceivingEnhanced        { get { return 'Plc_GoodsReceivingEnhanced'; } }
        //add more here...
    }


    //Goods Management
    private static GoodsManagement_ns GoodsManagement_ns;
    public static GoodsManagement_ns GoodsManagement {
        get {
            if (GoodsManagement_ns == null) GoodsManagement_ns = new GoodsManagement_ns();
            return GoodsManagement_ns;
        }
    }
    public class GoodsManagement_ns {
        public String PlcGoodAvailable { get { return 'Available'; } }
        public String PlcGoodAccepted  { get { return 'Accepted'; } }
        public String PlcGoodRejected  { get { return 'Rejected'; } }
    }

}