@IsTest
private class Plc_RetrieveWorkOrderListCntTest {

        @TestSetup
    static void setup(){
        
        //phase manager
        Plc_TestFactory.initProcessClickPackage();

        insert new Plc_SystemSettings__c(Name = 'SystemSettings',
                Plc_DaysForCalculatingConsumption__c = 30,
                Plc_PurchaseWarrantyMonthsDelay__c   = 5
        );


        Bit2Shop__TransferDetail__c transfDetail1 = new Bit2Shop__TransferDetail__c(
                Bit2Shop__Code__c   = 'ACTION1',
                Bit2Shop__Transfer_Type__c = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Plc_Alias__c        = 'TD001'
        );
        insert transfDetail1;

        //creates main chain
        Account accInstalled = Plc_TestFactory.createAccountSupplier('Installed');
        //accInstalled.Name    =   'Installed';
        insert accInstalled;

        Account acc = Plc_TestFactory.createAccountSupplier('Test');
        //acc.Name    =   'Test';
        insert acc;
                   //create a instance WorkOrder
        WorkOrder workOrder = new WorkOrder(Plc_FiscalCode__c='fiscale');
        workOrder.Plc_Abi__c='abi';
        workOrder.StartDate = System.now();
        workOrder.EndDate = System.now();
        workOrder.Plc_LegacyWarehouseId__c = '00789654123654789';
        workOrder.Plc_BankDescription__c='description';
        workOrder.Plc_LegacyAccountId__c=''+account.Id; 
        workOrder.Plc_SiaCode__c='sia code'; 
        workOrder.Plc_LegacyServicePointId__c='service point id'; 
        workOrder.Plc_ServicePoint__c='point'; 
        workOrder.Plc_Cti__c='cti';
        workOrder.Plc_CustomerCare__c='customer care';
        workOrder.Plc_Alias__c='0015';
        workOrder.Plc_SourceLegacySystem__c='WSICT';
        workOrder.Status = 'Closed';
        //workOrder.WorkOrderNumber='S159';
        insert workOrder;


        Contact cnt = Plc_TestFactory.createContactGeneric('Test');
        cnt.AccountId   =   acc.Id;
       // cnt.LastName    =   'Test';
        insert cnt;

        //fake dealer / warehouse
        Plc_TestFactory.createWarehouseFake();
        //this is needed by Plc_StockSerial2HistoryManager.performInsertOperation() (MF)
        //Account account01 = Plc_TestFactory.createAccountSupplier('01');
        //insert account01;

        //Bit2Shop__Dealer__c dealerParent01 = Plc_TestFactory.createDealerParent('01', account01,'alias1');
        //insert dealerParent01;

        //Bit2Shop__Dealer__c dealerChild01 = Plc_TestFactory.createDealerChild('FORNITORE FITTIZIO', account01,'alias2', dealerParent01);
        //insert dealerChild01;

        //Bit2Shop__Warehouse__c warehouse01 = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Undefined','Neutral',dealerChild01);
        //warehouse01.Plc_IsActive__c = true;
        //warehouse01.Plc_Alias__c='000001NEXI';
        //insert warehouse01;

        

        //Nexi WH & Dealer
        Bit2Shop__Dealer__c dealer = new Bit2Shop__Dealer__c(
                Name                    = 'Dealer Test',
                RecordTypeId            = Plc_Utils.getRecordTypeId('Plc_ChildDealer',
                        Bit2Shop__Dealer__c.SObjectType.getDescribe().name),
                Bit2Shop__Account_Id__c = acc.Id,
                Plc_Alias__c = 'D001',
                Plc_Maintainer__c = true,
                Plc_DealerManufacturer__c = true
        );
        insert dealer;

        Bit2Shop__Warehouse__c whouse = new Bit2Shop__Warehouse__c(
                Name                    = 'Warehouse Test',
                Bit2Shop__Dealer_Id__c  = dealer.Id,
                Plc_LogisticDivision__c = 'Nexi',
                Plc_Tipology__c         = 'Generic',
                Plc_IsActive__c         = true,
                Plc_Alias__c            = 'WH001',
                Plc_UniqueKey__c = 'WH001'
        );
        insert whouse;

        //Installed WH & Dealer INSTALLED
        Bit2Shop__Dealer__c dealerInstalled = new Bit2Shop__Dealer__c(
                Name                    = 'Dealer Installed Test',
                RecordTypeId            = Plc_Utils.getRecordTypeId('Plc_ChildDealer',
                        Bit2Shop__Dealer__c.SObjectType.getDescribe().name),
                Bit2Shop__Account_Id__c = accInstalled.Id,
                Plc_Alias__c = 'D002'
        );
        insert dealerInstalled;

        Bit2Shop__Warehouse__c whouseInstalled = new Bit2Shop__Warehouse__c(
                Name                    = 'Warehouse Installed Test',
                Bit2Shop__Dealer_Id__c  = dealerInstalled.Id,
                Plc_LogisticDivision__c = 'Nexi',
                Plc_Tipology__c         = Plc_WorkOrderApxAct.WAREHOUSE_TIPOLOGY_INSTALLED,
                Plc_IsActive__c         = true,
                Plc_Alias__c            = 'WHINST001',
                Plc_UniqueKey__c = 'WHINST001'
        );
        insert whouseInstalled;

        Plc_Solution__c solution = new Plc_Solution__c(
                Name = 'Solution Test'
        );
        insert solution;

        B2WExtCat__External_Catalog__c catalog = new B2WExtCat__External_Catalog__c(
                B2WExtCat__External_Catalog_Name__c = 'Main Catalog',
                B2WExtCat__Status__c                = 'Active',
                RecordTypeId                        = Plc_Utils.getRecordTypeId('Standard',
                        B2WExtCat__External_Catalog__c.SObjectType.getDescribe().name),
                B2WExtCat__Start_Date__c            = System.now()
        );
        insert catalog;

        //cat item for a "serial" item
        B2WExtCat__External_Catalog_Item__c catItemSerial = new B2WExtCat__External_Catalog_Item__c(
                B2WExtCat__External_Catalog_Item_Name__c    = 'POS TEST',
                B2WExtCat__Status__c                        = 'Active',
                B2WExtCat__Type__c                          = 'extCatItemType',
                B2WExtCat__all__c                           = 'all',
                Bit2Shop__Required_Serial__c                = true,
                RecordTypeId                                = Plc_Utils.getRecordTypeId('Installation',
                        B2WExtCat__External_Catalog_Item__c.SObjectType.getDescribe().name),
                Plc_Solution__c                             = solution.Id,
                B2WExtCat__External_Catalog__c              = catalog.Id,
                Plc_Alias__c                                = 'SKU001INT',
                Bit2Shop__Product_Description__c            = 'DESCRIPTION SKU001',
                Plc_ProductSku__c                           = 'SKU001',
                Plc_Manufacturer__c                         = dealer.Id
        );
        insert catItemSerial;

        //cat item for a "product" (quatity) item
        B2WExtCat__External_Catalog_Item__c catItemProd = new B2WExtCat__External_Catalog_Item__c(
                B2WExtCat__External_Catalog_Item_Name__c    = 'CAVI TEST',
                B2WExtCat__Status__c                        = 'Active',
                B2WExtCat__Type__c                          = 'extCatItemType',
                B2WExtCat__all__c                           = 'all',
                Bit2Shop__Required_Serial__c                = true,
                RecordTypeId                                = Plc_Utils.getRecordTypeId('Installation',
                        B2WExtCat__External_Catalog_Item__c.SObjectType.getDescribe().name),
                Plc_Solution__c                             = solution.Id,
                B2WExtCat__External_Catalog__c              = catalog.Id,
                Plc_Alias__c                                = 'SKU002INT',
                Bit2Shop__Product_Description__c            = 'DESCRIPTION SKU002',
                Plc_ProductSku__c                           = 'SKU002',
                Plc_Manufacturer__c                         = dealer.Id
        );
        insert catItemProd;

        Plc_TermId__c termId = new Plc_TermId__c(Plc_TermIdCode__c = 'TERMID001',
        Plc_Alias__c = 'test1234');
        insert termId;

        Bit2Shop__Product_Stock__c pstock = new Bit2Shop__Product_Stock__c(
                Bit2Shop__External_Catalog_Item_Id__c   = catItemSerial.Id,
                Bit2Shop__Warehouse_Id__c               = whouse.Id,
                Name                                    = catItemSerial.B2WExtCat__External_Catalog_Item_Name__c,
                Plc_UsableQty__c                        = 10,
                Bit2Shop__Stock_Qty__c                  = 10,
                Plc_WithdrawnQty__c                     = 10,
                Plc_OrderedQty__c                       = 10,
                RecordTypeId                            = Plc_Utils.getRecordTypeId('Current',
                        Bit2Shop__Product_Stock__c.SObjectType.getDescribe().name)
        );
        insert pstock;

        Bit2Shop__Product_Stock__c pstockInstalled = new Bit2Shop__Product_Stock__c(
                Bit2Shop__External_Catalog_Item_Id__c   = catItemSerial.Id,
                Bit2Shop__Warehouse_Id__c               = whouseInstalled.Id,
                Name                                    = catItemSerial.B2WExtCat__External_Catalog_Item_Name__c,
                Plc_UsableQty__c                        = 0,
                Bit2Shop__Stock_Qty__c                  = 0,
                Plc_WithdrawnQty__c                     = 0,
                Plc_OrderedQty__c                       = 0,
                RecordTypeId                            = Plc_Utils.getRecordTypeId('Current',
                        Bit2Shop__Product_Stock__c.SObjectType.getDescribe().name)
        );
        insert pstockInstalled;

        Plc_DistributionList__c plcDistributionList=new Plc_DistributionList__c(Plc_Alias__c='Plc_AliasTest1',Plc_Status__c='Draft');
        insert plcDistributionList;
        
        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c(
                RecordtypeId                                = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER,
                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = 'Closed',
                Plc_TransferDetail__c                       = transfDetail1.Id,
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Transfer_Type__c                  = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Bit2Shop__Point_Of_Sales_Id__c              = dealer.Id,
                Bit2Shop__Holding_Id__c                     = acc.Id,
                Bit2Shop__Warehouse_Id__c                   = whouse.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = dealerInstalled.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = whouseInstalled.Id,
                Plc_WorkOrder__c = workOrder.Id
        );

        insert stockOrder;


                Bit2Shop__StockOrder__c stockOrder1 = new Bit2Shop__StockOrder__c(
                RecordtypeId                                = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER,
                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = 'Open',
                Plc_TransferDetail__c                       = transfDetail1.Id,
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Transfer_Type__c                  = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Bit2Shop__Point_Of_Sales_Id__c              = dealer.Id,
                Bit2Shop__Holding_Id__c                     = acc.Id,
                Bit2Shop__Warehouse_Id__c                   = whouse.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = dealerInstalled.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = whouseInstalled.Id,
                Plc_WorkOrder__c = workOrder.Id
        );

        insert stockOrder1;

      
        Plc_DistributionListItem__c plcDistributionListItem =new Plc_DistributionListItem__c();
        plcDistributionListItem.Plc_DistributionList__c = ''+plcDistributionList.Id;
        plcDistributionListItem.Plc_OriginDealer__c =''+dealer.Id;
        plcDistributionListItem.Plc_DestinationWarehouse__c = ''+whouse.Id;
        plcDistributionListItem.Plc_OriginWarehouse__c =''+whouse.Id;
        plcDistributionListItem.Plc_RequestedQty__c=5;
        plcDistributionListItem.Plc_ShippedQty__c=5;
        plcDistributionListItem.Plc_Product__c=catItemSerial.Id;
        insert plcDistributionListItem;
       
        
        Bit2Shop__Stock_Serials2__c stockSerial = new Bit2Shop__Stock_Serials2__c(
                Bit2Shop__Status__c             = 'New',
                //there can be 3 different serial numbers
                Bit2Shop__Serial_Number__c      = '00610998800',
                Plc_DllSerialNumber__c          = '00610998800',
                Plc_EncodedSerialNumber__c      = '00610998800',
                Plc_ManufacturerSerialNumber__c = '00610998800',
                Bit2Shop__Product_Stock_Id__c   = pstock.Id,
                Plc_TermId__c                   = termId.Id,
                Bit2Shop__Warehouse_Id__c       = whouse.Id,
                Bit2Shop__Transfer_Order_Id__c  =stockOrder.Id

        );
        insert stockSerial;

        NE__Order__c configuration = new NE__Order__c(
                RecordTypeId                = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.CONFIGURATION_RECORDTYPE_STOCK_ORDER,
                        NE__Order__c.SObjectType.getDescribe().name),
                Bit2Shop__StockOrder__c     = stockOrder.Id,
                Bit2Shop__Cost_Total__c     = 0,
                NE__AccountId__c            = stockOrder.Bit2Shop__Holding_Id__c,
                NE__OrderStatus__c          = Plc_WorkOrderApxAct.CONFIGURATION_ORDER_STATUS_COMPLETED,
                NE__ConfigurationStatus__c  = Plc_WorkOrderApxAct.CONFIGURATION_STATUS_INPROGRESS,
                NE__Version__c              = 1

        );
        insert configuration;

        NE__OrderItem__c configurationItem = new NE__OrderItem__c(
                RecordTypeId    = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.CONFIG_ITEM_RECORDTYPE_STANDARD,
                        NE__OrderItem__c.SObjectType.getDescribe().name),
                NE__OrderId__c  = configuration.Id,
                NE__Qty__c      = 1,
                NE__Status__c   = Plc_WorkOrderApxAct.CONFIG_ITEM_STATUS_COMPLETED,
                NE__Account__c  = stockOrder.Bit2Shop__Holding_Id__c,
                Bit2Shop__Required_Serial__c = false
        );
        insert configurationItem;

        Bit2Shop__Shipment__c shipmentIn = new Bit2Shop__Shipment__c(
                RecordTypeId                            = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_INBOUND,
                        Bit2Shop__Shipment__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                     = Plc_WorkOrderApxAct.SHIPMENT_STATUS_CLOSED,
                Bit2Shop__Expected_Delivery_Date__c     = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Close_Date__c                 = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Date__c                       = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Shipped_Quantity__c           = 0,
                Bit2Shop__Stock_Order_Id__c             = stockOrder.Id,
                Bit2Shop__Sub_Type__c                   = Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_INBOUND,
                Bit2Shop__Type__c                       = Plc_WorkOrderApxAct.SHIPMENT_TYPE_FINAL,
                Bit2Shop__Configuration_Item_Id__c      = configurationItem.Id,
                Bit2Shop__Shipment_Document_Number__c   = 'Doc_'+configurationItem.Id
        );
        shipmentIn.Plc_ProductStock__c=pstockInstalled.Id;
        insert shipmentIn;

        Bit2Shop__Shipment__c shipmentOut = shipmentIn.clone();
        shipmentOut.RecordTypeId            = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND,
                                            Bit2Shop__Shipment__c.SObjectType.getDescribe().name);
        shipmentOut.Bit2Shop__Sub_Type__c   = Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_OUTBOUND;
        shipmentOut.Bit2Shop__Status__c     = Plc_WorkOrderApxAct.SHIPMENT_STATUS_CLOSED;
        shipmentOut.Bit2Shop__Close_Date__c = stockOrder.Bit2Shop__Date__c;
        shipmentOut.Bit2Shop__Shipped_Quantity__c=1;
        insert shipmentOut;

        Bit2Shop__Shipment_Line_Item__c shLineItemOut = new Bit2Shop__Shipment_Line_Item__c(
                RecordTypeId                    =  Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_ITEM_RECORDTYPE_PRODUCT,
                        Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                Bit2Shop__Type__c               = Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_PRODUCT,
                Bit2Shop__Status__c             = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_PENDING,
                Bit2Shop__Transfer_Detail_Id__c = stockOrder.Plc_TransferDetail__c,
                Bit2Shop__Date__c               = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Received_Quantity__c  = shipmentOut.Bit2Shop__Shipped_Quantity__c,
                Bit2Shop__Shipment_Id__c        = shipmentOut.Id,
                Bit2Shop__Product_Stock_Id__c   = pStock.Id,
                Bit2Shop__Requested_Quantity__c = 1
        );
        insert shLineItemOut;

        Bit2Shop__Shipment_Line_Item__c shLineItemIn = shLineItemOut.clone();
        shLineItemIn.Bit2Shop__Product_Stock_Id__c  = pStockInstalled.Id;
        shLineItemIn.Bit2Shop__Received_Quantity__c = shipmentIn.Bit2Shop__Shipped_Quantity__c;
        shLineItemIn.Bit2Shop__Shipment_Id__c       = shipmentIn.Id;
        shLineItemIn.Bit2Shop__Stock_Action_Id__c   = null;
        shLineItemIn.Bit2Shop__Status__c            = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_PENDING;
        insert shLineItemIn;

        Bit2Shop__Shipment_Line_Item__c serialOut = new Bit2Shop__Shipment_Line_Item__c(
                RecordTypeId                    = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_ITEM_RECORDTYPE_SERIAL,
                        Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                Bit2Shop__Type__c               = Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL,
                Bit2Shop__Status__c             = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_PENDING,
                Bit2Shop__Serial_Number__c      = stockSerial.Bit2Shop__Serial_Number__c,
                Bit2Shop__Target_Line_Item__c   = shLineItemOut.Id,
                Bit2Shop__Transfer_Detail_Id__c = stockOrder.Plc_TransferDetail__c,
                Bit2Shop__Date__c               = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Received_Quantity__c  = 1,
                Bit2Shop__Shipment_Id__c        = shipmentOut.Id,
                Bit2Shop__Received_Status__c    = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_NOTRECEIVED,
                Plc_StockSerial__c              = stockSerial.Id
        );
        insert serialOut;



        Bit2Shop__Shipment_Line_Item__c serialIn    = serialOut.clone();
        serialIn.Bit2Shop__Target_Line_Item__c      = shLineItemIn.Id;
        serialIn.Bit2Shop__Shipment_Id__c           = shipmentIn.Id;
        serialIn.Bit2Shop__Received_Status__c       = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        serialIn.Bit2Shop__Stock_Action_Id__c       = null;
        insert serialIn;


        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCatItemProduct = Plc_TestFactory.createExtCatalogItem('EFT930 Ethernet Modem V1', catalog, 
                                                                                                          'FT930DEM0NV1', 'Process');
        b2wExtCatExtCatItemProduct.Plc_Alias__c = 'FT930DEM0NV1';
        b2wExtCatExtCatItemProduct.Plc_Category__c='Product';
        b2wExtCatExtCatItemProduct.Plc_Solution__c = solution.Id;
        b2wExtCatExtCatItemProduct.B2WExtCat__Status__c='Active';
        b2wExtCatExtCatItemProduct.Plc_Subcategory__c='Router';
        insert b2wExtCatExtCatItemProduct;


        Asset parentAsset =new Asset(Name='Parent');
        parentAsset.Plc_ProductStock__c=pstock.Id;
		parentAsset.Plc_ServicePointLegacyId__c='ff4a01hg';
        //parentAsset.AccountId=account.Id;
        parentAsset.Status='Uninstalled';
        insert parentAsset;

        WorkOrderLineItem woliProductsList = new WorkOrderLineItem();
        woliProductsList.Status='ToExecute';
        woliProductsList.Plc_TermId__c=termId.Id;
        woliProductsList.Plc_SerialNumber__c='serial number';
        woliProductsList.Plc_ExternalCatalogItem__c=b2wExtCatExtCatItemProduct.Id;
        woliProductsList.WorkOrderId=workOrder.Id;
        woliProductsList.Plc_StockSerial__c = stockSerial.Id;
        woliProductsList.Plc_SerialNumber__c = stockSerial.Plc_EncodedSerialNumber__c;
        woliProductsList.Plc_OperationType__c='ToSubstitute';
        woliProductsList.AssetId=parentAsset.Id;
        woliProductsList.Plc_SerialNumber__c = 'testserialNumber';
        insert woliProductsList;

}
    
@isTest
static void testfetchRecords() {
 Plc_RetrieveWorkOrderListCnt.RecordsData recordData = new Plc_RetrieveWorkOrderListCnt.RecordsData();
        /*recordData.label = ' ';*/
        recordData.value = ' ';
        recordData.woNumber = ' '; 
        recordData.alias = ' ';
        recordData.status = ' ';
        recordData.status2 = ' ';
        recordData.legacyAccountId = ' ';
        recordData.legacyServicePointId = ' ';
        recordData.servicepoint  = ' ';
        recordData.sourceLegacySystem = ' ';
        recordData.startDate = ' ';
        recordData.endDate = ' ';

Test.startTest();
    Plc_RetrieveWorkOrderListCnt.fetchRecords(' ', ' ', ' ', 'All');
    Plc_RetrieveWorkOrderListCnt.fetchRecords('1', ' ', ' ', 'All');
    Plc_RetrieveWorkOrderListCnt.fetchRecords(' ', '2', ' ', 'All');
    Plc_RetrieveWorkOrderListCnt.fetchRecords(' ', ' ', '3', 'All');
    Plc_RetrieveWorkOrderListCnt.fetchRecords(' ', ' ', ' ', 'stockOrderPresentOpen');
    Plc_RetrieveWorkOrderListCnt.fetchRecords(' ', ' ', ' ', 'stockOrderPresentClosed');
Test.stopTest();

}


@isTest
static void testfetchRecordsError() {
 Plc_RetrieveWorkOrderListCnt.RecordsData recordData = new Plc_RetrieveWorkOrderListCnt.RecordsData();
        /*recordData.label = ' ';*/
        recordData.value = ' ';
        recordData.woNumber = ' '; 
        recordData.alias = ' ';
        recordData.status = ' ';
        recordData.status2 = ' ';
        recordData.legacyAccountId = ' ';
        recordData.legacyServicePointId = ' ';
        recordData.servicepoint  = ' ';
        recordData.sourceLegacySystem = ' ';
        recordData.startDate = ' ';
        recordData.endDate = ' ';

        Test.startTest();

        try
        {
           Plc_RetrieveWorkOrderListCnt.fetchRecords(' ', ' ',' ', null);
           system.assert(false);
        }Catch(exception e){
        
        }  
        Test.stopTest();
  }

}