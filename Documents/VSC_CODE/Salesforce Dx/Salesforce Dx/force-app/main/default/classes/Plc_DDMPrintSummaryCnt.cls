/**
 * Created by Luca Belometti on 13/08/2019.
 */

public with sharing class Plc_DDMPrintSummaryCnt {


    public List<Bit2Shop__StockOrder__c> stockOrderToPrint {get; set;}
    public Map<String,Bit2Shop__StockOrder__c> stockOrderToPrintMap {get; set;}
    public list<Bit2Shop__Shipment__c> AllList{get;set;}


    public static List<String> stockOrderFields {get; set;}



    public Plc_DDMPrintSummaryCnt(ApexPages.StandardController controller){
        String id = ApexPages.currentPage().getParameters().get('id');

        stockOrderFields = new List<String>{'Id', 'OwnerId', 'IsDeleted', 'Name', 'RecordTypeId', 'CreatedDate', 'CreatedById',
            'LastModifiedDate', 'LastModifiedById', 'SystemModstamp', 'LastActivityDate', 'LastViewedDate', 'LastReferencedDate',
            'Bit2Shop__Date__c', 'Bit2Shop__Destination_Dealer_Calc__c', 'Bit2Shop__Destination_Point_Of_Sales_Id__c',
            'Bit2Shop__Destination_Warehouse_Id__c', 'Bit2Shop__ExternalId__c', 'Bit2Shop__Holding_Id__c', 'Bit2Shop__Note__c',
            'Bit2Shop__Payment_condition__c', 'Bit2Shop__Point_Of_Sales_Id__c', 'Bit2Shop__Status__c', 
            'Bit2Shop__Stock_Orderable_Amount__c', 'Bit2Shop__Transfer_Type__c', 'Bit2Shop__Warehouse_Id__c', 'Plc_TransferDetail__c',
            'Plc_DdmNumber__c', 'Plc_IssueDate__c', 'Plc_CloseDate__c', 'Plc_LegacyPurchaseOrderId__c', 'Plc_PurchaseDate__c',
            'Plc_IsPrinted__c', 'Plc_DdmNumberMigr__c', 'Plc_Alias__c', 'Plc_ExternalAccount__c', 'Plc_ShippingDate__c',
            'Plc_PurchaseOrder__c', 'Plc_ExternalWorkOrder__c', 'Plc_ExternalPointOfSales__c', 'Plc_ExternalWarehouseId__c',
            'Plc_ExternalDestinationWarehouse__c', 'Plc_ExternalPurchaseOrder__c', 'Plc_WorkOrder__c', 'Plc_CancellationDate__c',
            'Plc_IsDeleted__c', 'Plc_ExternalDestinationPointOfSales__c', 'Plc_ExternalDistributionList__c',
            'Plc_ExternalTransferDetail__c', 'Plc_DistributionList__c', 'Plc_DdtNumber__c',
            'Plc_SourceLegacySystem__c', 'Plc_Migration__c', 'Plc_ViewName__c', 'Plc_DestinationDealerPublicGroup__c',
            'Plc_SupplyTimeToDateWorkingDays__c', 'Plc_DdmNumberLegacy__c', 'Plc_SupplyTime__c', 'Plc_DeliveryTime__c',
            'Plc_DestinationDealerOwner__c', 'Plc_SupplyTimetoDate__c','Plc_TakeInCharge__c'
            };

            List<Bit2Shop__StockOrder__c> stockOrderToPrintList = [SELECT Id,Name,Plc_DdtNumber__c,Plc_IssueDate__c,Bit2Shop__Status__c,Plc_DdmNumber__c,Plc_ShippingDate__c,
            Bit2Shop__Destination_Dealer_Calc__c,CreatedById,Bit2Shop__Destination_Point_Of_Sales_Id__r.Name,Plc_TakenInChargeDate__c,
            Plc_ViewName__c,Plc_TransferDetail__r.Name,Plc_CloseDate__c,Bit2Shop__Point_Of_Sales_Id__r.Name,
            (SELECT Id, Bit2Shop__Expected_Delivery_Date__c, Bit2Shop__Shipped_Quantity__c,Bit2Shop__Type__c FROM Bit2Shop__ShipmentOrders__r)
            FROM Bit2Shop__StockOrder__c WHERE Id = :id];

            AllList=[SELECT Id, Bit2Shop__Expected_Delivery_Date__c,Bit2Shop__Stock_Order_Id__c,Plc_ProductStock__r.Name, Bit2Shop__Shipped_Quantity__c,Bit2Shop__Type__c,Plc_ProductStock__r.Plc_ProductSku__c
            FROM Bit2Shop__Shipment__c WHERE Bit2Shop__Stock_Order_Id__c = :id AND Bit2Shop__Sub_Type__c = 'Inbound'];




        if(stockOrderToPrintList.size() > 0){
            stockOrderToPrint = stockOrderToPrintList;


        }
        System.debug('### Map for field: ' + stockOrderToPrintMap);

    }
}