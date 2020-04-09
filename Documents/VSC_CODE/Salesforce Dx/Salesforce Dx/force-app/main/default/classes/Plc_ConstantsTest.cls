/**
 * Plc_ConstantsTest - Test class for Plc_Constants
 *
 * @author EM
 * @date Creation 04/03/2019
 * @description
 */

@IsTest
private class Plc_ConstantsTest {


    @IsTest
    static  void constantsTest() {
        Test.startTest();
        Plc_Constants cnst = new Plc_Constants();

        String tmp = null;

        tmp = Plc_Constants.B2S_Warehouse.PlcTipology_Installed;
        tmp = Plc_Constants.B2S_Warehouse.PlcTipology_Irrecoverable;
        tmp = Plc_Constants.B2S_Warehouse.PlcTipology_Generic;

        tmp = Plc_Constants.B2S_Dealer.RecordType_PlcParentDealer;
        tmp = Plc_Constants.B2S_Dealer.RecordType_PlcChildDealer;

        tmp = Plc_Constants.B2S_StockActionsDetail.PlcProductType_Product;
        tmp = Plc_Constants.B2S_StockActionsDetail.PlcProductType_Serial;
        tmp = Plc_Constants.B2S_StockActionsDetail.PlcProductType_Both;
        tmp = Plc_Constants.B2S_StockActionsDetail.B2S_TargetObject_ProductStock;
        tmp = Plc_Constants.B2S_StockActionsDetail.B2S_TargetObject_StockSerials2;
        tmp = Plc_Constants.B2S_StockActionsDetail.B2S_TargetObject_Warehouse;
        tmp = Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_IncreaseQty;
        tmp = Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_DecreaseQty;
        tmp = Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_UpdateField;
        tmp = Plc_Constants.B2S_StockActionsDetail.B2S_TargetAction_MoveToWarehouse;
        tmp = Plc_Constants.B2S_StockActionsDetail.PlcStatusTrigger_StockOrder;
        tmp = Plc_Constants.B2S_StockActionsDetail.PlcStatusTrigger_ShipmentLineItem;

        tmp = Plc_Constants.ObjectShare.AccessLevel_Edit;
        tmp = Plc_Constants.ObjectShare.RowClause_Manual;

        tmp = Plc_Constants.B2S_StockOrder.RecordType_Transfer;
        tmp = Plc_Constants.B2S_StockOrder.B2S_Status_TakeCharge;
        tmp = Plc_Constants.B2S_StockOrder.B2S_Status_Assigned;
        tmp = Plc_Constants.B2S_StockOrder.B2S_Status_Closed;
        tmp = Plc_Constants.B2S_StockOrder.B2S_Status_Generated;
        tmp = Plc_Constants.B2S_StockOrder.B2S_Status_ClosedWithResLines;
        tmp = Plc_Constants.B2S_StockOrder.B2S_Status_Suspended;
        tmp = Plc_Constants.B2S_StockOrder.B2S_Status_Canceled;

        tmp = Plc_Constants.B2S_TransferDetail.B2S_TranferType_Stock2OtherShop;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_Dismissione;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_ResoDaVendita;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_InvioCNexi;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_InvioCNexiDisp;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_ResoInvioCNexi;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_MessaInCampo;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_Ritiro;
        tmp = Plc_Constants.B2S_TransferDetail.B2S_Code_Disatt;
        tmp = Plc_Constants.B2S_TransferDetail.PlcFilterDestinationDealer_Mantainer;
        tmp = Plc_Constants.B2S_TransferDetail.PlcFilterDestinationDealer_Manufacturer;
        tmp = Plc_Constants.B2S_TransferDetail.PlcFilterDestinationDealer_Repairer;
        tmp = Plc_Constants.B2S_TransferDetail.PlcFilterDestinationDealer_Scrapyard;

        tmp = Plc_Constants.B2S_Shipment.RecordType_InboundShipment;
        tmp = Plc_Constants.B2S_Shipment.RecordType_OutboundShipment;
        tmp = Plc_Constants.B2S_Shipment.B2S_Status_Pending;
        tmp = Plc_Constants.B2S_Shipment.B2S_Status_Closed;
        tmp = Plc_Constants.B2S_Shipment.B2S_Status_Rejected;
        tmp = Plc_Constants.B2S_Shipment.B2S_Status_Returning;
        tmp = Plc_Constants.B2S_Shipment.B2S_Status_Returned;
        tmp = Plc_Constants.B2S_Shipment.B2S_Type_Partial;
        tmp = Plc_Constants.B2S_Shipment.B2S_Type_Final;
        tmp = Plc_Constants.B2S_Shipment.B2S_Subtype_Inbound;
        tmp = Plc_Constants.B2S_Shipment.B2S_Subtype_Outbound;

        tmp = Plc_Constants.B2S_ShipmentLineItem.RecordType_Product;
        tmp = Plc_Constants.B2S_ShipmentLineItem.RecordType_Serial;
        tmp = Plc_Constants.B2S_ShipmentLineItem.RecordType_InboundShipments;
        tmp = Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Closed;
        tmp = Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Pending;
        tmp = Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_NotReceived;
        tmp = Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_Received;
        tmp = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Product;
        tmp = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Serial;

        tmp = Plc_Constants.WorkOrder.RecordType_Installation;
        tmp = Plc_Constants.WorkOrder.RecordType_Uninstallation;
        tmp = Plc_Constants.WorkOrder.RecordType_Deactivation;
        tmp = Plc_Constants.WorkOrder.RecordType_Substitution;
        tmp = Plc_Constants.WorkOrder.RecordType_Corr;

        tmp = Plc_Constants.WorkOrderLineItems.PlcOperationType_ToInstall;
        tmp = Plc_Constants.WorkOrderLineItems.PlcOperationType_ToRemove;
        tmp = Plc_Constants.WorkOrderLineItems.PlcOperationType_ToSubstitute;
        tmp = Plc_Constants.WorkOrderLineItems.PlcOperationType_ToDeactivate;
        tmp = Plc_Constants.WorkOrderLineItems.PlcOperationType_NoOperation;
        tmp = Plc_Constants.WorkOrderLineItems.PlcOperationType_ToReconfigureCorr;
        tmp = Plc_Constants.WorkOrderLineItems.PlcOperationType_ToSubstituteCorr;
        tmp = Plc_Constants.WorkOrderLineItems.Status_Executed;
        tmp = Plc_Constants.WorkOrderLineItems.Status_NotExecuted;

        tmp = Plc_Constants.Account.RecordType_PlcSupplier;

        tmp = Plc_Constants.Contact.RecordType_PlcReferenteGenerico;

        tmp = Plc_Constants.Asset.RecordType_PlcTechnicalAsset;
        tmp = Plc_Constants.Asset.Status_Installed;
        tmp = Plc_Constants.Asset.Status_Uninstalled;

        tmp = Plc_Constants.B2S_ProductStock.RecordType_Current;
        tmp = Plc_Constants.B2S_ProductStock.B2S_InventoryLevel_New;
        tmp = Plc_Constants.B2S_ProductStock.B2S_InventoryLevel_Refurbished;
        tmp = Plc_Constants.B2S_ProductStock.B2S_InventoryLevel_Dismissed;
        tmp = Plc_Constants.B2S_ProductStock.B2S_InventoryLevel_Stolen;
        tmp = Plc_Constants.B2S_ProductStock.B2S_InventoryLevel_Defective;
        tmp = Plc_Constants.B2S_ProductStock.B2S_InventoryLevel_ToBeReturned;

        tmp = Plc_Constants.NE_Order.RecordType_StockOrder;
        tmp = Plc_Constants.NE_Order.NE_OrderStatus_Pending;
        tmp = Plc_Constants.NE_Order.NE_OrderStatus_Completed;
        tmp = Plc_Constants.NE_Order.NE_ConfigurationStatus_InProgress;

        tmp = Plc_Constants.NE_OrderItem.RecordType_Standard;
        tmp = Plc_Constants.NE_OrderItem.NE_Status_Completed;
        tmp = Plc_Constants.NE_OrderItem.NE_Status_Pending;

        tmp = Plc_Constants.B2WExtCat_ExternalCatalogItem.PlcCategoryProduct;

        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_New;
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_Withdrawn;
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_Available;
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_Installed;
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeVerified;
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_ReceivedFailure;   
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_Decommissioned;  
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeDecommissioned;
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_TamperedWith;
        tmp = Plc_Constants.B2S_StockSerials2.B2S_Status_Irrecoverable;

        tmp = Plc_Constants.PLC_Reservation.PlcStatus_NotReserved;
        tmp = Plc_Constants.PLC_Reservation.PlcStatus_Reserved;
        
        tmp = Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Blank;
        tmp = Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Yesterday;
        tmp = Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Today;
        tmp = Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Tomorrow;
        tmp = Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Next_Week;
        tmp = Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Next_Month;
        tmp = Plc_Constants.B2S_StockActionsDetail.Stock_Action_Date_Value_Next_Year;
          
        tmp = Plc_Constants.customPermission.PlcMergeStockSerialFromUndefined;
        tmp = Plc_Constants.customPermission.PlcTakeInChargeStockOrder;
        tmp = Plc_Constants.customPermission.PlcConfirmGoodsReceiving;
        tmp = Plc_Constants.customPermission.PlcConfirmDistributionList;
        tmp = Plc_Constants.customPermission.PlcEditStockSerial;
        tmp = Plc_Constants.customPermission.PlcManageWarehouseProvince;
        tmp = Plc_Constants.customPermission.Plc_HandleAllTransferDetails;
        tmp = Plc_Constants.customPermission.PlcProductStockConsolidation;
        tmp = Plc_Constants.customPermission.PlcGoodsHandling;
        tmp = Plc_Constants.customPermission.PlcStocksManagement;
        tmp = Plc_Constants.customPermission.PlcSerialsCensus;
        tmp = Plc_Constants.customPermission.PlcSerialsUpdate;
        tmp = Plc_Constants.customPermission.PlcGoodsReceivingEnhanced;

        tmp = Plc_Constants.GoodsManagement.PlcGoodAvailable;
        tmp = Plc_Constants.GoodsManagement.PlcGoodAccepted;
        tmp = Plc_Constants.GoodsManagement.PlcGoodRejected;
        
        Test.stopTest();
    }
}