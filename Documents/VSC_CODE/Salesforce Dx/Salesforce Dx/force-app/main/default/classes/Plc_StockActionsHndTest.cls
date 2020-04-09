/**
 * Plc_StockActionsHndTest - Test class for Plc_StockActionsHnd
 *
 * @author EM
 * @date Creation 17/01/2019
 * @description
 */
@IsTest
private class Plc_StockActionsHndTest {
    @testsetup
    static void setup(){
        //phase manager
        Plc_TestFactory.initProcessClickPackage();

        insert new Plc_SystemSettings__c(Name = 'SystemSettings',
                Plc_DaysForCalculatingConsumption__c = 30,
                Plc_PurchaseWarrantyMonthsDelay__c   = 5
        );

        wrts_prcgvr__PhaseTransition__c pt = new wrts_prcgvr__PhaseTransition__c(
                wrts_prcgvr__Code__c                = Math.random()+'',
                wrts_prcgvr__DestinationPhase__c    = 'Installed',
                wrts_prcgvr__OriginPhase__c         = 'New',
                wrts_prcgvr__RecordTypeId__c        = Plc_Utils.getRecordTypeId('Standard',
                        Bit2Shop__Stock_Serials2__c.SObjectType.getDescribe().name),
                wrts_prcgvr__RecordTypeName__c      = 'Standard',
                wrts_prcgvr__Type__c                = 'A'
        );
        insert pt;

        //creates stock actions (parent ones)
        Bit2Shop__Stock_Action__c sourceActionParent = new Bit2Shop__Stock_Action__c(
                Bit2Shop__Action_Code__c = 'SOURCE_PARENT',
                Bit2Shop__Active__c = true,
                recordtypeid = Plc_Utils.getRecordTypeId('Plc_ParentAction',
                        Bit2Shop__Stock_Action__c.SObjectType.getDescribe().name)
        );
        insert sourceActionParent;

        Bit2Shop__Stock_Action__c destinationActionParent = new Bit2Shop__Stock_Action__c(
                Bit2Shop__Action_Code__c = 'DESTINATION_PARENT',
                Bit2Shop__Active__c = true,
                recordtypeid = Plc_Utils.getRecordTypeId('Plc_ParentAction',
                        Bit2Shop__Stock_Action__c.SObjectType.getDescribe().name)
        );
        insert destinationActionParent;

        //creates stock actions (child ones)
        Bit2Shop__Stock_Action__c sourceAction = new Bit2Shop__Stock_Action__c(
                Bit2Shop__Action_Code__c = 'SOURCE',
                Bit2Shop__Active__c = true,
                Plc_ParentAction__c = sourceActionParent.Id,
                recordtypeid = Plc_Utils.getRecordTypeId('Plc_ChildAction',
                        Bit2Shop__Stock_Action__c.SObjectType.getDescribe().name)
        );
        insert sourceAction;

        Bit2Shop__Stock_Action__c destinationAction = new Bit2Shop__Stock_Action__c(
                Bit2Shop__Action_Code__c = 'DESTINATION',
                Bit2Shop__Active__c = true,
                Plc_ParentAction__c = destinationActionParent.Id,
                recordtypeid = Plc_Utils.getRecordTypeId('Plc_ChildAction',
                        Bit2Shop__Stock_Action__c.SObjectType.getDescribe().name),
            	Plc_StatusTrigger__c		='StockOrder.Generated'
        );
        insert destinationAction;
    
        Bit2Shop__TransferDetail__c transfDetail1 = new Bit2Shop__TransferDetail__c(
                //Bit2Shop__Code__c   = 'ACTION1',
                Bit2Shop__Code__c   = 'APPR',
                Bit2Shop__Transfer_Type__c = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Plc_Alias__c        = 'TD001',
                Plc_SourceWarehouseStockAction__c = sourceActionParent.Id,
                Plc_DestinationWarehouseStockAction__c = destinationActionParent.Id
        );
        insert transfDetail1;
        
        //creates main chain
        Account accInstalled = Plc_TestFactory.createAccountSupplier('Installed');
        //accInstalled.Name    =   'Installed';
        insert accInstalled;

        Account acc = Plc_TestFactory.createAccountSupplier('Test');
        //acc.Name    =   'Test';
        insert acc;

        Contact cnt = Plc_TestFactory.createContactGeneric('Test');
        cnt.AccountId   =   acc.Id;
        //cnt.LastName    =   'Test';
        insert cnt;

        //fake dealer / warehouse
        //this is needed by Plc_StockSerial2HistoryManager.performInsertOperation() (MF)
        Bit2Shop__Dealer__c fakeDealer = new Bit2Shop__Dealer__c(
                Name                    = 'FORNITORE FITTIZIO',
                RecordTypeId            = Plc_Utils.getRecordTypeId('Plc_ChildDealer',
                        Bit2Shop__Dealer__c.SObjectType.getDescribe().name),
                Bit2Shop__Account_Id__c = acc.Id,
                Plc_Alias__c = '000_001'
        );
        insert fakeDealer;
        Bit2Shop__Warehouse__c fakeWhouse = new Bit2Shop__Warehouse__c(
                Name                    = 'FORNITORE FITTIZIO - NEXI',
                Bit2Shop__Dealer_Id__c  = fakeDealer.Id,
                Plc_LogisticDivision__c = 'Neutral',
                Plc_Tipology__c         = 'Undefined',
                Plc_IsActive__c         = true,
                Plc_Alias__c            = '000001NEXI'
        );
        insert fakeWhouse;

        //Nexi WH & Dealer
        Bit2Shop__Dealer__c dealer = new Bit2Shop__Dealer__c(
            	RecordTypeId            = Plc_Utils.getRecordTypeId('Plc_ChildDealer',
                        Bit2Shop__Dealer__c.SObjectType.getDescribe().name),
                Name                    = 'Dealer Test',
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

        Plc_TermId__c termId = new Plc_TermId__c(Plc_TermIdCode__c = 'TERMID001');
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

        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c(
                RecordtypeId                                = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER,
                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = 'Taken in charge',
                Plc_TransferDetail__c                       = transfDetail1.Id,
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Transfer_Type__c                  = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Bit2Shop__Point_Of_Sales_Id__c              = dealer.Id,
                Bit2Shop__Holding_Id__c                     = acc.Id,
                Bit2Shop__Warehouse_Id__c                   = whouse.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = dealerInstalled.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = whouseInstalled.Id
        );
        
        insert stockOrder;
        
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
                Bit2Shop__Shipped_Quantity__c           = 1,
                Bit2Shop__Stock_Order_Id__c             = stockOrder.Id,
                Bit2Shop__Sub_Type__c                   = Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_INBOUND,
                Bit2Shop__Type__c                       = Plc_WorkOrderApxAct.SHIPMENT_TYPE_FINAL,
                Bit2Shop__Configuration_Item_Id__c      = configurationItem.Id,
                Bit2Shop__Shipment_Document_Number__c   = 'Doc_'+configurationItem.Id
        );
        insert shipmentIn;

        Bit2Shop__Shipment__c shipmentOut = shipmentIn.clone();
        shipmentOut.RecordTypeId            = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND,
                                                Bit2Shop__Shipment__c.SObjectType.getDescribe().name);
        shipmentOut.Bit2Shop__Sub_Type__c   = Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_OUTBOUND;
        shipmentOut.Bit2Shop__Status__c     = Plc_WorkOrderApxAct.SHIPMENT_STATUS_CLOSED;
        shipmentOut.Bit2Shop__Close_Date__c = stockOrder.Bit2Shop__Date__c;
        shipmentOut.Bit2Shop__Stock_Order_Id__c        = stockOrder.Id;
        insert shipmentOut;

        Bit2Shop__Shipment_Line_Item__c shLineItemOut = new Bit2Shop__Shipment_Line_Item__c(
                RecordTypeId                    =  Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_ITEM_RECORDTYPE_PRODUCT,
                                                    Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                Bit2Shop__Type__c               = Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_PRODUCT,
                Bit2Shop__Status__c             = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_PENDING,
                Bit2Shop__Transfer_Detail_Id__c = stockOrder.Plc_TransferDetail__c,
                Bit2Shop__Date__c               = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Requested_Quantity__c = shipmentOut.Bit2Shop__Shipped_Quantity__c,
                Bit2Shop__Shipment_Id__c        = shipmentOut.Id,
                Bit2Shop__Product_Stock_Id__c   = pStock.Id
        );
        insert shLineItemOut;

        Bit2Shop__Shipment_Line_Item__c shLineItemIn = shLineItemOut.clone();
        shLineItemIn.Bit2Shop__Product_Stock_Id__c  = pStock.Id;
        shLineItemIn.Bit2Shop__Received_Quantity__c = shipmentIn.Bit2Shop__Shipped_Quantity__c;
        shLineItemIn.Bit2Shop__Requested_Quantity__c = null;
        shLineItemIn.Bit2Shop__Shipment_Id__c       = shipmentIn.Id;
        shLineItemIn.Bit2Shop__Stock_Action_Id__c   = null; //todo it is in standby
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
                Bit2Shop__Requested_Quantity__c  = 1,
                Bit2Shop__Shipment_Id__c        = shipmentOut.Id,
                Bit2Shop__Received_Status__c    = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_NOTRECEIVED,
                Plc_StockSerial__c              = stockSerial.Id
        );
        insert serialOut;

        Bit2Shop__Shipment_Line_Item__c serialIn    = serialOut.clone();
        serialIn.Bit2Shop__Requested_Quantity__c    = null;
        serialIn.Bit2Shop__Received_Quantity__c     = 1;
        serialIn.Bit2Shop__Target_Line_Item__c      = shLineItemIn.Id;
        serialIn.Bit2Shop__Shipment_Id__c           = shipmentIn.Id;
        serialIn.Bit2Shop__Received_Status__c       = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        serialIn.Bit2Shop__Stock_Action_Id__c       = null; //todo it is in standby
        insert serialIn;
    }

    @isTest
    static void testBehaviorOnShippingItem() {
        //testing costanti
        String tmp = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_PRODUCT;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_BOTH;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_STOCKERIAL;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_INCREASE;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_DECREASE;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_UPDATEFIELD;
        tmp = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_MOVETOWAREHOUSE;

        Map<ID, Bit2Shop__Product_Stock__c> prodStocksMap = new Map<ID, Bit2Shop__Product_Stock__c>([Select Id, Bit2Shop__Stock_Qty__c,
                Plc_UsableQty__c, Plc_WithdrawnQty__c, Plc_OrderedQty__c,
                Bit2Shop__Inventory_ConfirmedQty__c, Bit2Shop__Inventory_PreviousQty__c,
                Bit2Shop__Inventory_QtyToJustify__c, Bit2Shop__Inventory_QtyUnjustified__c,
                Bit2Shop__Reserved_Qty__c, Bit2Shop__Shipped_Qty__c
        From Bit2Shop__Product_Stock__c]);

        Map<ID, Bit2Shop__Stock_Serials2__c> serStocksMap = new Map<ID, Bit2Shop__Stock_Serials2__c>([Select Id, Bit2Shop__Status__c
        From Bit2Shop__Stock_Serials2__c]);

        Bit2Shop__Stock_Action__c sourceAction  = [Select Id From Bit2Shop__Stock_Action__c
            WHERE Bit2Shop__Action_Code__c = 'SOURCE' and Plc_ParentAction__c != null];
        
        Bit2Shop__Stock_Action__c destAction    = [Select Id From Bit2Shop__Stock_Action__c
            WHERE Bit2Shop__Action_Code__c = 'DESTINATION' and Plc_ParentAction__c != null];

        destAction.Plc_StatusTrigger__c = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        update destAction;
        
        System.debug('==StockAction== '+destAction);

        //changes the serial status after the inbound shipment close
        Bit2Shop__StockActionsDetail__c inboundActionSerial = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                /*Plc_StatusTrigger__c = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                        +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                        +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED,*/
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_STOCKERIAL,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_UPDATEFIELD + ' 1',
                Plc_TargetField__c              = 'Bit2Shop__Status__c',
                Bit2Shop__Target_Field_Value__c = 'Installed',
                Bit2Shop__Used_Value__c         = 'Transaction Value'
        );
        insert inboundActionSerial;

        //changes the warehous eof the stock serial
        Bit2Shop__StockActionsDetail__c inboundActionSerialWH = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                /*Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                        +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                        +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED,*/
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_STOCKERIAL,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_MOVETOWAREHOUSE
        );
        insert inboundActionSerialWH;

        //increases the product stock on the source warehouse product stock after the outbound shipment close
        Bit2Shop__StockActionsDetail__c inboundActionProduct = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_PRODUCT,
                /*Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                                                    +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                                                    +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED,*/
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_INCREASE,
                Bit2Shop__Target_Counter__c     = 'Bit2Shop__Stock_Qty__c',
                Bit2Shop__Used_Value__c         = 'Qty'
        );
        insert inboundActionProduct;

        sourceAction.Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        update sourceAction;

        //decreases the product stock on the source warehouse product stock after the outbound shipment close
        Bit2Shop__StockActionsDetail__c outboundActionProduct = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = sourceAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                /*Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                                                    +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                                                    +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED,*/
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_DECREASE,
                Bit2Shop__Target_Counter__c     = 'Bit2Shop__Stock_Qty__c',
                Bit2Shop__Used_Value__c         = 'Qty'
        );
        insert outboundActionProduct;

        Bit2Shop__Shipment_Line_Item__c serialShipmentIn = [Select Id,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c,
                Plc_StockSerial__c,
                Plc_StockSerial__r.Bit2Shop__Status__c
                From Bit2Shop__Shipment_Line_Item__c
            Where Bit2Shop__Type__c = :Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL
            AND Bit2Shop__Shipment_Id__r.RecordType.DeveloperName = :Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_INBOUND];

        Bit2Shop__Shipment_Line_Item__c serialShipmentOut = [Select Id,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c,
                Plc_StockSerial__c,
                Plc_StockSerial__r.Bit2Shop__Status__c
            From Bit2Shop__Shipment_Line_Item__c
            Where Bit2Shop__Type__c = :Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL
            AND Bit2Shop__Shipment_Id__r.RecordType.DeveloperName = :Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND];

        Bit2Shop__StockOrder__c stockOrder = [Select Id, Bit2Shop__Destination_Warehouse_Id__c, Bit2Shop__Warehouse_Id__c
        From Bit2Shop__StockOrder__c Limit 1];

        Test.startTest();
        Integer sourceQty = (Integer)serialShipmentOut.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c;
        Integer destinationQty = (Integer)serialShipmentIn.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c;
        String initialStatus = serialShipmentIn.Plc_StockSerial__r.Bit2Shop__Status__c;

        //Actions on the outbound are done when the inbound goes closure/received
        //serialShipmentOut.Bit2Shop__Status__c = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED;
        //update serialShipmentOut;

        serialShipmentIn.Bit2Shop__Status__c = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED;
        serialShipmentIn.Bit2Shop__Received_Status__c = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        update serialShipmentIn;

        Test.stopTest();

        Bit2Shop__Stock_Serials2__c stockSerial = [Select Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__c From Bit2Shop__Stock_Serials2__c
            Where ID = :serialShipmentIn.Plc_StockSerial__c LIMIT 1];
        Bit2Shop__Product_Stock__c productStockSource = [Select Bit2Shop__Stock_Qty__c From Bit2Shop__Product_Stock__c
            Where ID = :serialShipmentOut.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c LIMIT 1];
        Bit2Shop__Product_Stock__c productStockDestination = [Select Bit2Shop__Stock_Qty__c From Bit2Shop__Product_Stock__c
            Where ID = :serialShipmentIn.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c LIMIT 1];
        serialShipmentOut = [Select Id,Bit2Shop__Status__c, Bit2Shop__Received_Status__c
            From Bit2Shop__Shipment_Line_Item__c Where Id = :serialShipmentOut.Id];

        Integer newSourceQty = (Integer)productStockSource.Bit2Shop__Stock_Qty__c;
        Integer newDestinationQty = (Integer)productStockDestination.Bit2Shop__Stock_Qty__c;
        String newStatus = stockSerial.Bit2Shop__Status__c;

        System.assert(newDestinationQty == 9,
                'Wrong action applied on Shipment Item Product Outbound (NEW: '+newDestinationQty+', OLD: '+destinationQty);

        /*System.assert(stockSerial.Bit2Shop__Warehouse_Id__c == stockOrder.Bit2Shop__Destination_Warehouse_Id__c,
                'Wrong action applied on Shipment Item Product Outbound [Move to Warehouse]');*/

        System.assert(serialShipmentOut.Bit2Shop__Status__c == Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
            && serialShipmentOut.Bit2Shop__Received_Status__c == Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED,
            'Outbound shipment has not changed status: '+serialShipmentOut);

        System.assert(newStatus == 'Installed',
                'Wrong action applied on Shipment Item Serial Inbound (NEW: '+newStatus+', OLD: '+initialStatus);

        System.assert(newSourceQty == 9,
                'Wrong action applied on Shipment Item Product Inbound (NEW: '+newSourceQty+', OLD: '+sourceQty);
        
        Bit2Shop__TransferDetail__c transfDetail =[SELECT Bit2Shop__Code__c FROM Bit2Shop__TransferDetail__c LIMIT 1];
        transfDetail.Bit2Shop__Code__c='RESO_RIP';
        update transfDetail;
        System.assert(serialShipmentOut.Bit2Shop__Status__c == Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
            && serialShipmentOut.Bit2Shop__Received_Status__c == Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED,
            'Outbound shipment has not changed status: '+serialShipmentOut);

    }

    @isTest
    static void testBehaviorOnStockOrder() {
        Map<ID, Bit2Shop__Product_Stock__c> prodStocksMap = new Map<ID, Bit2Shop__Product_Stock__c>([Select Id, Bit2Shop__Stock_Qty__c,
                Plc_UsableQty__c, Plc_WithdrawnQty__c, Plc_OrderedQty__c,
                Bit2Shop__Inventory_ConfirmedQty__c, Bit2Shop__Inventory_PreviousQty__c,
                Bit2Shop__Inventory_QtyToJustify__c, Bit2Shop__Inventory_QtyUnjustified__c,
                Bit2Shop__Reserved_Qty__c, Bit2Shop__Shipped_Qty__c
        From Bit2Shop__Product_Stock__c]);

        Map<ID, Bit2Shop__Stock_Serials2__c> serStocksMap = new Map<ID, Bit2Shop__Stock_Serials2__c>([Select Id, Bit2Shop__Status__c
        From Bit2Shop__Stock_Serials2__c]);

        Bit2Shop__Stock_Action__c sourceAction  = [Select Id From Bit2Shop__Stock_Action__c WHERE Bit2Shop__Action_Code__c = 'SOURCE' and Plc_ParentAction__c != null];
        Bit2Shop__Stock_Action__c destAction    = [Select Id From Bit2Shop__Stock_Action__c WHERE Bit2Shop__Action_Code__c = 'DESTINATION' and Plc_ParentAction__c != null];

        destAction.Plc_StatusTrigger__c = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER +'.Closed';
        update destAction;

        //changes the serial status after the inbound shipment close
        Bit2Shop__StockActionsDetail__c inboundActionSerial = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                /*Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER
                                                    +'.Closed',*/
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_STOCKERIAL,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_UPDATEFIELD + ' 1',
                Plc_TargetField__c              = 'Bit2Shop__Status__c',
                Bit2Shop__Target_Field_Value__c = 'Installed',
                Bit2Shop__Used_Value__c         = 'Transaction Value'
        );
        insert inboundActionSerial;

        //increases the product stock on the source warehouse product stock after the outbound shipment close
        Bit2Shop__StockActionsDetail__c inboundActionProduct = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                /*Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER
                                                    +'.Closed',*/
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_INCREASE,
                Bit2Shop__Target_Counter__c     = 'Bit2Shop__Stock_Qty__c',
                Bit2Shop__Used_Value__c         = 'Qty'
        );
        insert inboundActionProduct;

        sourceAction.Plc_StatusTrigger__c = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER +'.Closed';
        update sourceAction;
        //decreases the product stock on the source warehouse product stock after the outbound shipment close
        Bit2Shop__StockActionsDetail__c outboundActionProduct = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = sourceAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                /*Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_STOCKORDER
                                                    +'.Closed',*/
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_DECREASE,
                Bit2Shop__Target_Counter__c     = 'Bit2Shop__Stock_Qty__c',
                Bit2Shop__Used_Value__c         = 'Qty'
        );
        insert outboundActionProduct;

        Bit2Shop__Shipment_Line_Item__c serialShipmentIn = [Select Id,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c,
                Plc_StockSerial__c,
                Plc_StockSerial__r.Bit2Shop__Status__c
                From Bit2Shop__Shipment_Line_Item__c
                Where Bit2Shop__Type__c = :Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL
                AND Bit2Shop__Shipment_Id__r.RecordType.DeveloperName = :Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_INBOUND];

        /*serialShipmentIn.Bit2Shop__Status__c = 'Closed';
        serialShipmentIn.Bit2Shop__Received_Status__c = 'Received';
        update serialShipmentIn;*/

        Bit2Shop__Shipment_Line_Item__c serialShipmentOut = [Select Id,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c,
                Plc_StockSerial__c,
                Plc_StockSerial__r.Bit2Shop__Status__c
                From Bit2Shop__Shipment_Line_Item__c
                Where Bit2Shop__Type__c = :Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL
                AND Bit2Shop__Shipment_Id__r.RecordType.DeveloperName = :Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND];

        /*serialShipmentOut.Bit2Shop__Status__c = 'Closed';
        serialShipmentOut.Bit2Shop__Received_Status__c = 'Received';
        update serialShipmentOut;*/

        Bit2Shop__StockOrder__c stockOrder = [Select Id, Bit2Shop__Destination_Warehouse_Id__c, Bit2Shop__Warehouse_Id__c
                From Bit2Shop__StockOrder__c ];

        Test.startTest();
        Integer sourceQty = (Integer)serialShipmentOut.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c;
        Integer destinationQty = (Integer)serialShipmentIn.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c;
        String initialStatus = serialShipmentIn.Plc_StockSerial__r.Bit2Shop__Status__c;

        stockOrder.Bit2Shop__Status__c = 'Assigned';
        update stockOrder;

        stockOrder.Bit2Shop__Status__c = 'Closed';
        update stockOrder;
        Test.stopTest();

        Bit2Shop__Stock_Serials2__c stockSerial = [Select Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__c From Bit2Shop__Stock_Serials2__c
        Where ID = :serialShipmentIn.Plc_StockSerial__c LIMIT 1];
        Bit2Shop__Product_Stock__c productStockSource = [Select Bit2Shop__Stock_Qty__c From Bit2Shop__Product_Stock__c
        Where ID = :serialShipmentOut.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c LIMIT 1];
        Bit2Shop__Product_Stock__c productStockDestination = [Select Bit2Shop__Stock_Qty__c From Bit2Shop__Product_Stock__c
        Where ID = :serialShipmentIn.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c LIMIT 1];

        Integer newSourceQty = (Integer)productStockSource.Bit2Shop__Stock_Qty__c;
        Integer newDestinationQty = (Integer)productStockDestination.Bit2Shop__Stock_Qty__c;
        String newStatus = stockSerial.Bit2Shop__Status__c;





        System.assert(newDestinationQty == 10,
                'Wrong action applied on Shipment Item Product Outbound (NEW: '+newDestinationQty+', OLD: '+destinationQty);

        System.assert(newSourceQty == 10,
                'Wrong action applied on Shipment Item Product Inbound (NEW: '+newSourceQty+', OLD: '+sourceQty);

        System.assert(newStatus == 'Installed',
                'Wrong action applied on Shipment Item Serial Inbound (NEW: '+newStatus+', OLD: '+initialStatus);
    }


    /*static testMethod void testClosingInbound() {

        Map<ID, Bit2Shop__Product_Stock__c> prodStocksMap = new Map<ID, Bit2Shop__Product_Stock__c>([Select Id, Bit2Shop__Stock_Qty__c,
                Plc_UsableQty__c, Plc_WithdrawnQty__c, Plc_OrderedQty__c,
                Bit2Shop__Inventory_ConfirmedQty__c, Bit2Shop__Inventory_PreviousQty__c,
                Bit2Shop__Inventory_QtyToJustify__c, Bit2Shop__Inventory_QtyUnjustified__c,
                Bit2Shop__Reserved_Qty__c, Bit2Shop__Shipped_Qty__c
        From Bit2Shop__Product_Stock__c]);

        Map<ID, Bit2Shop__Stock_Serials2__c> serStocksMap = new Map<ID, Bit2Shop__Stock_Serials2__c>([Select Id, Bit2Shop__Status__c
        From Bit2Shop__Stock_Serials2__c]);

        Bit2Shop__Stock_Action__c sourceAction  = [Select Id From Bit2Shop__Stock_Action__c
        WHERE Bit2Shop__Action_Code__c = 'SOURCE' and Plc_ParentAction__c != null];

        Bit2Shop__Stock_Action__c destAction    = [Select Id From Bit2Shop__Stock_Action__c
        WHERE Bit2Shop__Action_Code__c = 'DESTINATION' and Plc_ParentAction__c != null];

        destAction.Plc_StatusTrigger__c = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        update destAction;

        System.debug('==StockAction== '+destAction);

        //changes the serial status after the inbound shipment close
        Bit2Shop__StockActionsDetail__c inboundActionSerial = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_STOCKERIAL,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_UPDATEFIELD + ' 1',
                Plc_TargetField__c              = 'Bit2Shop__Status__c',
                Bit2Shop__Target_Field_Value__c = 'Installed',
                Bit2Shop__Used_Value__c         = 'Transaction Value'
        );
        insert inboundActionSerial;

        //changes the warehous eof the stock serial
        Bit2Shop__StockActionsDetail__c inboundActionSerialWH = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_STOCKERIAL,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_MOVETOWAREHOUSE
        );
        insert inboundActionSerialWH;

        //increases the product stock on the source warehouse product stock after the outbound shipment close
        Bit2Shop__StockActionsDetail__c inboundActionProduct = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = destAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_INCREASE,
                Bit2Shop__Target_Counter__c     = 'Bit2Shop__Stock_Qty__c',
                Bit2Shop__Used_Value__c         = 'Qty'
        );
        insert inboundActionProduct;

        sourceAction.Plc_StatusTrigger__c            = Plc_StockActionsHnd.STOCK_ACTION_STATUS_TRIGGER_PREFIX_SHIPMENTITEM
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                +'.'+Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        update sourceAction;

        //decreases the product stock on the source warehouse product stock after the outbound shipment close
        Bit2Shop__StockActionsDetail__c outboundActionProduct = new Bit2Shop__StockActionsDetail__c(
                Bit2Shop__Stock_Action_Id__c    = sourceAction.Id,
                Plc_ProductType__c              = Plc_StockActionsHnd.STOCK_ACTION_DETAIL_PRODUCT_TYPE_SERIAL,
                Bit2Shop__Target_Object__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_OBJECT_PRODUCTSTOCK,
                Bit2Shop__Target_Action__c      = Plc_StockActionsHnd.STOCK_ACTION_TARGET_ACTION_DECREASE,
                Bit2Shop__Target_Counter__c     = 'Bit2Shop__Stock_Qty__c',
                Bit2Shop__Used_Value__c         = 'Qty'
        );
        insert outboundActionProduct;

        Bit2Shop__Shipment_Line_Item__c serialShipmentIn = [Select Id,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c,
                Plc_StockSerial__c,
                Plc_StockSerial__r.Bit2Shop__Status__c
        From Bit2Shop__Shipment_Line_Item__c
        Where Bit2Shop__Type__c = :Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL
        AND Bit2Shop__Shipment_Id__r.RecordType.DeveloperName = :Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_INBOUND];

        Bit2Shop__Shipment_Line_Item__c serialShipmentOut = [Select Id,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c,
                Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c,
                Plc_StockSerial__c,
                Plc_StockSerial__r.Bit2Shop__Status__c
        From Bit2Shop__Shipment_Line_Item__c
        Where Bit2Shop__Type__c = :Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL
        AND Bit2Shop__Shipment_Id__r.RecordType.DeveloperName = :Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND];

        Bit2Shop__StockOrder__c stockOrder = [Select Id, Bit2Shop__Destination_Warehouse_Id__c, Bit2Shop__Warehouse_Id__c
        From Bit2Shop__StockOrder__c Limit 1];

        Test.startTest();
        Integer sourceQty = (Integer)serialShipmentOut.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c;
        Integer destinationQty = (Integer)serialShipmentIn.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__Stock_Qty__c;
        String initialStatus = serialShipmentIn.Plc_StockSerial__r.Bit2Shop__Status__c;

        //Actions on the outbound are done when the inbound goes closure/received
        //serialShipmentOut.Bit2Shop__Status__c = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED;
        //update serialShipmentOut;

        serialShipmentIn.Bit2Shop__Status__c = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED;
        serialShipmentIn.Bit2Shop__Received_Status__c = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        update serialShipmentIn;

        Test.stopTest();

        Bit2Shop__Stock_Serials2__c stockSerial = [Select Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__c From Bit2Shop__Stock_Serials2__c
        Where ID = :serialShipmentIn.Plc_StockSerial__c LIMIT 1];
        Bit2Shop__Product_Stock__c productStockSource = [Select Bit2Shop__Stock_Qty__c From Bit2Shop__Product_Stock__c
        Where ID = :serialShipmentOut.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c LIMIT 1];
        Bit2Shop__Product_Stock__c productStockDestination = [Select Bit2Shop__Stock_Qty__c From Bit2Shop__Product_Stock__c
        Where ID = :serialShipmentIn.Bit2Shop__Target_Line_Item__r.Bit2Shop__Product_Stock_Id__c LIMIT 1];
        serialShipmentOut = [Select Id,Bit2Shop__Status__c, Bit2Shop__Received_Status__c
        From Bit2Shop__Shipment_Line_Item__c Where Id = :serialShipmentOut.Id];

        Integer newSourceQty = (Integer)productStockSource.Bit2Shop__Stock_Qty__c;
        Integer newDestinationQty = (Integer)productStockDestination.Bit2Shop__Stock_Qty__c;
        String newStatus = stockSerial.Bit2Shop__Status__c;

        System.assert(newDestinationQty == 1,
                'Wrong action applied on Shipment Item Product Outbound (NEW: '+newDestinationQty+', OLD: '+destinationQty);

        System.assert(stockSerial.Bit2Shop__Warehouse_Id__c == stockOrder.Bit2Shop__Destination_Warehouse_Id__c,
                'Wrong action applied on Shipment Item Product Outbound [Move to Warehouse]');

        System.assert(serialShipmentOut.Bit2Shop__Status__c == Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED
                && serialShipmentOut.Bit2Shop__Received_Status__c == Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED,
                'Outbound shipment has not changed status: '+serialShipmentOut);

        System.assert(newStatus == 'Installed',
                'Wrong action applied on Shipment Item Serial Inbound (NEW: '+newStatus+', OLD: '+initialStatus);

        System.assert(newSourceQty == 9,
                'Wrong action applied on Shipment Item Product Inbound (NEW: '+newSourceQty+', OLD: '+sourceQty);
    }*/



}