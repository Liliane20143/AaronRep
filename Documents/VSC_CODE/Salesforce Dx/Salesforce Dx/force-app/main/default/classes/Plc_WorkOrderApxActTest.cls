/**
 * Plc_WorkOrderApxActTest - Test class for Plc_WorkOrderApxAct
 * WARNING: the unit_test_close() method uses the Phase Manager on the WorkOrder object.
 * If the PM is not used anymore, this method won't cover at all.
 * 
 * @author EM
 * @date Creation 28/12/2018
 * @history:
 * UPDATE 2019-01-19: this class has been moved to afterUpdate trigger of Work Order due to recursive call to Phase Manager.
 * CM20190506 - added test method for toReconfigCorr and toSubstituteCorrt opertation types - coverage at ~95%
 */
@IsTest
private class Plc_WorkOrderApxActTest {

    private static final String WORKORDER_RT_INSTALLATION   = Plc_Constants.WorkOrder.RecordType_Installation;
    private static final String WORKORDER_RT_UNINSTALLATION = Plc_Constants.WorkOrder.RecordType_Uninstallation;
    private static final String WORKORDER_RT_DEACTIVATION   = Plc_Constants.WorkOrder.RecordType_Deactivation;
    private static final String WORKORDER_RT_SUBSTITUTION   = Plc_Constants.WorkOrder.RecordType_Substitution;
    private static final String WORKORDER_RT_CORR           = Plc_Constants.WorkOrder.RecordType_Corr;


    static void setupPhaseManager(){

        insert new Plc_SystemSettings__c(Name = 'SystemSettings',
            Plc_DaysForCalculatingConsumption__c = 30,
            Plc_PurchaseWarrantyMonthsDelay__c   = 5
        );

        //creates ProcessClick PhaseManager transitions
        Plc_TestFactory.initProcessClickPackage();

        insert Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'New', 'Installed');
        insert Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'New', 'To Be Verified');
        insert Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'Installed', 'To Be Verified');
        insert Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'Withdrawn', 'Installed');

        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_INSTALLATION,   'Assigned', 'Closed');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_INSTALLATION,   'Assigned', 'Canceled');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_UNINSTALLATION, 'Assigned', 'Closed');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_UNINSTALLATION, 'Assigned', 'Canceled');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_DEACTIVATION,   'Assigned', 'Closed');        
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_SUBSTITUTION,   'Assigned', 'Closed');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_SUBSTITUTION,   'Assigned', 'Canceled');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', WORKORDER_RT_CORR,           'Assigned', 'Closed');
    }


    @testsetup
    static void setup() {

        setupPhaseManager();

        Bit2Shop__Stock_Action__c saParent = new Bit2Shop__Stock_Action__c(
            RecordTypeId = Plc_Utils.getRecordTypeId('Plc_ParentAction', 'Bit2Shop__Stock_Action__c'),
            Bit2Shop__Action_Code__c = 'MESSAINCAMPO_DESTINAZIONE',
            Bit2Shop__Active__c = true,
            Bit2Shop__Child_Action__c = null,
            Bit2Shop__ExternalId__c = 'a1x1j0000009lKrAAI',
            Bit2Shop__Order_Type__c = 'Transfer',
            Bit2Shop__Target_Inventory_Level__c = 'New'
        );
        insert saParent;

        Bit2Shop__Stock_Action__c saChild = new Bit2Shop__Stock_Action__c(
            RecordTypeId = Plc_Utils.getRecordTypeId('Plc_ChildAction', 'Bit2Shop__Stock_Action__c'),
            Plc_Description__c = null,
            Plc_Alias__c = null,
            Plc_ParentAction__c = saParent.Id,
            Plc_StatusTrigger__c = 'ShipmentLineItem.Closed.Received',
            Bit2Shop__Action_Code_Rollback__c = null,
            Bit2Shop__Action_Code__c = 'MESSAINCAMPO_DESTINAZIONE_CR',
            Bit2Shop__Active__c = true,
            Bit2Shop__Child_Action__c = null,
            Bit2Shop__ExternalId__c = 'a1x1j0000009lR9AAI',
            Bit2Shop__History_Tracking__c = false,
            Bit2Shop__Inventory_Type__c = null,
            Bit2Shop__Order_Type__c = 'Transfer',
            Bit2Shop__Required_Attachment__c = false,
            Bit2Shop__Target_Inventory_Level__c = 'New',
            Bit2Shop__Upsert__c = false);
        insert saChild;

        Bit2Shop__StockActionsDetail__c saDetail = new Bit2Shop__StockActionsDetail__c(
            Plc_Alias__c = null,
            Plc_ProductType__c = 'Serial',
            Plc_StatusTrigger__c = null,
            Plc_TargetField__c = 'Bit2Shop__Status__c',
            Bit2Shop__Stock_Action_Id__c = saChild.Id,
            Bit2Shop__ExternalId__c = 'a1t1j000000HQ1aAAG',
            Bit2Shop__Target_Action__c = 'Update Field 1',
            Bit2Shop__Target_Counter__c = null,
            Bit2Shop__Target_Field_Value__c = 'Installed',
            Bit2Shop__Target_Object__c = 'Stock_Serials2__c',
            Bit2Shop__Target_Warehouse_Type__c = null,
            Bit2Shop__Used_Value__c = 'Qty');
        insert saDetail;

        //creates WO chain
        Bit2Shop__TransferDetail__c transfDetail1 = new Bit2Shop__TransferDetail__c(
            Plc_DestinationWarehouseStockAction__c = saParent.Id,
            Bit2Shop__Code__c   = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSDETAIL_MESSAINCAMPO,
            Bit2Shop__Transfer_Type__c = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
            Plc_Alias__c        = 'TD001'
        );
        insert transfDetail1;
        Bit2Shop__TransferDetail__c transfDetail2 = new Bit2Shop__TransferDetail__c(
            Bit2Shop__Code__c   = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSDETAIL_RITIRODALCAMPO,
            Bit2Shop__Transfer_Type__c = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
            Plc_Alias__c        = 'TD002'
        );
        insert transfDetail2;
        Bit2Shop__TransferDetail__c transfDetail3 = new Bit2Shop__TransferDetail__c(
            Bit2Shop__Code__c   = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSDETAIL_DISATTIVAZIONE,
            Bit2Shop__Transfer_Type__c = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
            Plc_Alias__c        = 'TD003'
        );
        insert transfDetail3;
        
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

        /*Bit2Shop__Dealer__c manufacturerDealer = new Bit2Shop__Dealer__c(
            Name                    = 'Manufacturer Test',
            RecordTypeId            = Plc_Utils.getRecordTypeId('Plc_ChildDealer',
                    Bit2Shop__Dealer__c.SObjectType.getDescribe().name),
            Bit2Shop__Account_Id__c = acc.Id,
            Plc_Alias__c = 'MD001',
            Plc_DealerManufacturer__c = true
        );
        insert manufacturerDealer;*/

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
            Plc_Alias__c            = 'WHINST001'
        );
        insert whouseInstalled;

        //Installed WH & Dealer IRREVOVERABLE
        Bit2Shop__Dealer__c dealerIrrec = new Bit2Shop__Dealer__c(
            Name                    = 'Dealer Irrecoverable Test',
            RecordTypeId            = Plc_Utils.getRecordTypeId('Plc_ChildDealer',
                    Bit2Shop__Dealer__c.SObjectType.getDescribe().name),
            Bit2Shop__Account_Id__c = accInstalled.Id,
            Plc_Alias__c = 'D003'
        );
        insert dealerIrrec;

        Bit2Shop__Warehouse__c whouseIrrec = new Bit2Shop__Warehouse__c(
            Name                    = 'Warehouse Irrecoverable Test',
            Bit2Shop__Dealer_Id__c  = dealerIrrec.Id,
            Plc_LogisticDivision__c = 'Nexi',
            Plc_Tipology__c         = Plc_WorkOrderApxAct.WAREHOUSE_TIPOLOGY_IRRECOVERABLE,
            Plc_IsActive__c         = true,
            Plc_Alias__c            = 'WHIRREC001'
        );
        insert whouseIrrec;


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
            Plc_Manufacturer__c                         = dealer.Id,
            Plc_Category__c                             = Plc_WorkOrderApxAct.EXT_CATALOG_ITEM_CATEGORY_PRODUCT
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


        Bit2Shop__Stock_Serials2__c stockSerial = new Bit2Shop__Stock_Serials2__c(
            Bit2Shop__Status__c             = 'New',
            //there can be 3 different serial numbers
            Bit2Shop__Serial_Number__c      = '00610998800',
            Plc_DllSerialNumber__c          = '00610998800',
            Plc_EncodedSerialNumber__c      = '00610998800',
            Plc_ManufacturerSerialNumber__c = '00610998800',
            Bit2Shop__Product_Stock_Id__c   = pstock.Id,
            Plc_TermId__c                   = termId.Id,
            Bit2Shop__Warehouse_Id__c       = whouseInstalled.Id
        );
        insert stockSerial;
        //stockSerial.Plc_DllSerialNumber__c = stockSerial.Bit2Shop__Serial_Number__c;
        //update stockSerial;


        //Work Order
        WorkOrder wo = Plc_TestFactory.createWorkOrder('AG',acc,cnt,'1','2','3','4','5','6','7','8','9','10');
        wo.RecordTypeId             = Plc_Utils.getRecordTypeId(WORKORDER_RT_INSTALLATION,
                                                                WorkOrder.SObjectType.getDescribe().name);
        wo.Status                   = 'Assigned';
        wo.Plc_LegacyWarehouseId__c = whouse.Plc_Alias__c;
        wo.Plc_LegacyServicePointId__c = '1234';
        wo.StartDate                = System.now().addDays(-2);
        wo.EndDate                  = System.now();
        //wo.Plc_Category__c          = 'NoCategory';
        wo.AccountId                = acc.Id;
        //wo.Plc_Category__c = 'NoCategory';
        insert wo;


        WorkOrderLineItem woli = new WorkOrderLineItem(
            WorkOrderId                         = wo.Id,
            Plc_ExternalTermId__c               = termId.Plc_TermIdCode__c,
            Plc_OperationType__c                = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_INSTALL,
            Plc_SerialNumber__c                 = stockSerial.Bit2Shop__Serial_Number__c,
            Status                              = Plc_WorkOrderApxAct.WOLI_STATUS_EXECUTED,
            Plc_ReferenceExternalCatalogItem__c = catItemSerial.Plc_Alias__c
        );
        insert woli;

        woli = new WorkOrderLineItem(
            WorkOrderId                         = wo.Id,
            Plc_ExternalTermId__c               = 'TERMIID002',
            Plc_OperationType__c                = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_INSTALL,
            Plc_SerialNumber__c                 = null,
            Status                              = Plc_WorkOrderApxAct.WOLI_STATUS_EXECUTED,
            Plc_ReferenceExternalCatalogItem__c = catItemProd.Plc_Alias__c
        );
        insert woli;
    }

    @isTest
    static void propertiesTest() {
        
        //constants coverage
        String tmp = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_INSTALL;
        tmp = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_REMOVE;
        tmp = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_SUBSTITUTE;
        tmp = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_DEACTIVATE;
        tmp = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_NO_OPERATION;
        tmp = Plc_WorkOrderApxAct.WOLI_STATUS_EXECUTED;
        tmp = Plc_WorkOrderApxAct.WOLI_STATUS_NOT_EXECUTED;
        tmp = Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET;
        tmp = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED;
        tmp = Plc_WorkOrderApxAct.ASSET_STATUS_UNINSTALLED;
        tmp = Plc_WorkOrderApxAct.RESERVATION_STATUS_NOT_RESERVED;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_STATUS_GENERATED;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_STATUS_CLOSED;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_STATUS_ASSIGNED;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSDETAIL_MESSAINCAMPO;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSDETAIL_RITIRODALCAMPO;
        tmp = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSDETAIL_DISATTIVAZIONE;
        tmp = Plc_WorkOrderApxAct.PRODUCT_STOCK_RECORDTYPE_CURRENT;
        tmp = Plc_WorkOrderApxAct.PRODUCT_STOCK_INVENTORY_LEVEL_NEW;
        tmp = Plc_WorkOrderApxAct.WAREHOUSE_TIPOLOGY_INSTALLED;
        tmp = Plc_WorkOrderApxAct.WAREHOUSE_TIPOLOGY_IRRECOVERABLE;
        tmp = Plc_WorkOrderApxAct.CONFIGURATION_RECORDTYPE_STOCK_ORDER;
        tmp = Plc_WorkOrderApxAct.CONFIGURATION_ORDER_STATUS_COMPLETED;
        tmp = Plc_WorkOrderApxAct.CONFIGURATION_STATUS_INPROGRESS;
        tmp = Plc_WorkOrderApxAct.CONFIG_ITEM_RECORDTYPE_STANDARD;
        tmp = Plc_WorkOrderApxAct.CONFIG_ITEM_STATUS_COMPLETED;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_INBOUND;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_OUTBOUND;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_STATUS_CLOSED;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_STATUS_PENDING;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_INBOUND;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_OUTBOUND;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_TYPE_FINAL;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_RECORDTYPE_PRODUCT;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_RECORDTYPE_SERIAL;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_PRODUCT;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_CLOSED;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_PENDING;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_RECEIVED;
        tmp = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_NOTRECEIVED;
        tmp = Plc_WorkOrderApxAct.SHARE_ACCESS_LEVEL_EDIT;
        tmp = Plc_WorkOrderApxAct.SHARE_ROW_CAUSE_MANUAL;
        tmp = Plc_WorkOrderApxAct.EXT_CATALOG_ITEM_CATEGORY_PRODUCT;
        tmp = Plc_WorkOrderApxAct.SERIAL_STOCK_STATUS_TOBEVERIFIED;
    }


    @isTest
    static void exceptionsTest() {

        Test.startTest();

        Object result;
        //Plc_WorkOrderApxAct apxAct = new Plc_WorkOrderApxAct();
        Map<String, Object> paramMap = new Map<String, Object>();

        try {
            result = Plc_WorkOrderApxAct.onCancelWorkOrder(null);
            System.assert(false, 'Expected exception for null params');
        } catch(Exception ex) {
            System.debug('Expected exception: ' +ex);
        }

        try {
            result = Plc_WorkOrderApxAct.onCloseWorkOrder(null);
            System.assert(false, 'Expected exception for null params');
        } catch(Exception ex) {
            System.debug('Expected exception: ' +ex);
        }

        //try {
        //    result = apxAct.execute(paramMap);
        //    System.assert(false, 'Expected exception for null parameter');
        //} catch(Exception ex)  {
        //    System.debug('Expected exception: ' +ex);
        //}

        //Map<String,Object> parameter = new Map<String,Object>();
        //paramMap.put('parameter', parameter);

        //try {
        //    result = apxAct.execute(paramMap);
        //    System.assert(false, 'Expected exception for null method');
        //} catch(Exception ex) {
        //    System.debug('Expected exception: ' +ex);
        //}

        //paramMap.put('method', 'aMethod');

        //try {
        //    result = Plc_WorkOrderApxAct.onCloseWorkOrder(paramMap);
        //    System.assert(false, 'Expected exception for null records');
        //} catch(Exception ex) {
        //    System.debug('Expected exception: ' +ex);
        //}

        //List<Sobject> records = new List<Sobject>();
        //parameter.put('records', records);

        //try {
        //    result = apxAct.execute(paramMap);
        //    System.assert(false, 'Expected exception for null transitionsMap');
        //} catch(Exception ex) {
        //    System.debug('Expected exception: ' +ex);
        //}
        //Map<Id, wrts_prcgvr__PhaseTransition__c> transitionsMap = new Map<Id, wrts_prcgvr__PhaseTransition__c>();
        //parameter.put('transitionsMap', transitionsMap);

        //try {
        //    result = apxAct.execute(paramMap);
        //    System.assert(false, 'Expected exception for invalid method');
        //} catch(Exception ex) {
        //    System.debug('Expected exception: ' +ex);
        //}

        Test.stopTest();
    }

    static testMethod void unit_test_installation_close() {
                
        WorkOrder wo = [Select Id, Status From WorkOrder Limit 1];

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transizione from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();
        List<Asset> assetList = [Select Id From Asset Limit 2];
        List<Plc_TermId__c> termIdList = [Select Id From Plc_TermId__c Limit 3];
        system.assert(assetList.size() == 2, 'Found 0 or more assets: '+assetList.size());
        system.assert(termIdList.size() == 2, 'Found 0 or more termIds: '+termIdList.size());
    }

    static testMethod void unit_test_uninstallation_close() {
        WorkOrder wo = [Select Id, Status, Plc_LegacyServicePointId__c From WorkOrder Limit 1];
        wo.RecordTypeId = Plc_Utils.getRecordTypeId(WORKORDER_RT_UNINSTALLATION,
                                WorkOrder.SObjectType.getDescribe().name);
        update wo;

        //deletes the Woli without serials
        delete [Select Id From WorkOrderLineItem Where Plc_SerialNumber__c = null];

        List<WorkOrderLineItem> woliList = [Select Id, Plc_SerialNumber__c, Plc_ExternalTermId__c, Status,
                WorkOrder.AccountId From WorkOrderLineItem Where WorkOrderId = :wo.Id];

        Asset ast = new Asset(
                RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET,
                        Asset.SObjectType.getDescribe().name),
                Name = 'Asset 1234',
                InstallDate = System.today(),
                Quantity = 1,
                SerialNumber = woliList[0].Plc_SerialNumber__c,
                NE__SerialNum__c = woliList[0].Plc_SerialNumber__c,
                Bit2Shop__Serial_Number__c = woliList[0].Plc_SerialNumber__c,
                Status = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED,
                Plc_TermId__c = [Select Id From Plc_TermId__c WHere Plc_TermIdCode__c = :woliList[0].Plc_ExternalTermId__c].Id,
                AccountId = woliList[0].WorkOrder.AccountId,
                Plc_ServicePointLegacyId__c = wo.Plc_LegacyServicePointId__c,
                Plc_StockSerial__c = [Select Id From Bit2Shop__Stock_Serials2__c limit 1].Id,
                Plc_ProductStock__c = [Select Id From Bit2Shop__Product_Stock__c
                                        Where Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = :Plc_WorkOrderApxAct.EXT_CATALOG_ITEM_CATEGORY_PRODUCT limit 1].Id
        );
        insert ast;

        woliList[0].Plc_OperationType__c = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_REMOVE;
        woliList[0].AssetId = ast.Id;
        update woliList[0];

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transizione from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();

        woliList = [Select Plc_Closed__c From WorkOrderLineItem Where Id IN :woliList];
        for(WorkOrderLineItem woli: woliList){
            System.assert(woli.Plc_Closed__c == true, 'Woli is not closed');
        }
    }

    static testMethod void unit_test_deactivation_close() {
        WorkOrder wo = [Select Id, Status, Plc_LegacyServicePointId__c From WorkOrder Limit 1];
        wo.RecordTypeId = Plc_Utils.getRecordTypeId(WORKORDER_RT_DEACTIVATION,
                WorkOrder.SObjectType.getDescribe().name);
        update wo;

        //deletes the Woli without serials
        delete [Select Id From WorkOrderLineItem Where Plc_SerialNumber__c = null];

        List<WorkOrderLineItem> woliList = [Select Id, Plc_SerialNumber__c, Plc_ExternalTermId__c, Status,
                WorkOrder.AccountId From WorkOrderLineItem Where WorkOrderId = :wo.Id];

        Asset ast = new Asset(
                RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET,
                        Asset.SObjectType.getDescribe().name),
                Name = 'Asset 1234',
                InstallDate = System.today(),
                Quantity = 1,
                SerialNumber = woliList[0].Plc_SerialNumber__c,
                NE__SerialNum__c = woliList[0].Plc_SerialNumber__c,
                Bit2Shop__Serial_Number__c = woliList[0].Plc_SerialNumber__c,
                Status = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED,
                Plc_TermId__c = [Select Id From Plc_TermId__c WHere Plc_TermIdCode__c = :woliList[0].Plc_ExternalTermId__c].Id,
                AccountId = woliList[0].WorkOrder.AccountId,
                Plc_ServicePointLegacyId__c = wo.Plc_LegacyServicePointId__c,
                Plc_StockSerial__c = [Select Id From Bit2Shop__Stock_Serials2__c limit 1].Id,
                Plc_ProductStock__c = [Select Id From Bit2Shop__Product_Stock__c
                                        Where Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = :Plc_WorkOrderApxAct.EXT_CATALOG_ITEM_CATEGORY_PRODUCT limit 1].Id
        );
        insert ast;

        woliList[0].Plc_OperationType__c = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_DEACTIVATE;
        woliList[0].AssetId = ast.Id;
        update woliList[0];

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transizione from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();

        woliList = [Select Plc_Closed__c From WorkOrderLineItem Where Id IN :woliList];
        for(WorkOrderLineItem woli: woliList){
            System.assert(woli.Plc_Closed__c == true, 'Woli is not closed');
        }
    }

    @isTest
    static void cancelWorkOrderTest() {
        WorkOrder wo = [SELECT Id, Status FROM WorkOrder LIMIT 1];

        Plc_Reservation__c reservation = new Plc_Reservation__c(                    
            Plc_Status__c = Plc_Constants.Plc_Reservation.PlcStatus_Reserved,
            Plc_ProductStock__c = [SELECT Id FROM Bit2Shop__Product_Stock__c WHERE Name = 'POS TEST'].Id
        );
        insert reservation;

        delete [SELECT Id FROM WorkOrderLineItem];
        WorkOrderLineItem newWoli = new WorkOrderLineItem(
            WorkOrderId                         = wo.Id,
            //AssetId                             = ast.Id,   // current asset to uninstall
            Plc_Reservation__c                  = reservation.Id,
            Plc_ExternalTermId__c               = 'NewTID',
            Plc_OperationType__c                = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_INSTALL,
            Plc_SerialNumber__c                 = [SELECT Id FROM Bit2Shop__Stock_Serials2__c WHERE Bit2Shop__Serial_Number__c = '00610998800'].Id,
            Status                              = Plc_WorkOrderApxAct.WOLI_STATUS_EXECUTED,
            Plc_ReferenceExternalCatalogItem__c = 'SKU001INT'
        );
        insert newWoli;

        Test.startTest();
        wo.Status = 'Canceled';
        update wo;
        Test.stopTest();

        Plc_Reservation__c reservChk = [SELECT Id, Plc_Status__c FROM Plc_Reservation__c WHERE Id = :reservation.Id];
        System.assertEquals(Plc_Constants.Plc_Reservation.PlcStatus_NotReserved, reservChk.Plc_Status__c);

        List<WorkOrderLineItem> woliList = [SELECT Plc_Closed__c FROM WorkOrderLineItem WHERE WorkOrderId = :wo.Id];
        for(WorkOrderLineItem woli: woliList) {
            System.assert(woli.Plc_Closed__c == true, 'Woli is not closed');
        }
    }

    static testMethod void unit_test_substitution_close() {
        WorkOrder wo = [Select Id, Status, Plc_LegacyServicePointId__c From WorkOrder Limit 1];
        wo.RecordTypeId = Plc_Utils.getRecordTypeId(WORKORDER_RT_SUBSTITUTION, WorkOrder.SObjectType.getDescribe().name);
        update wo;

        //deletes the Woli without serials
        delete [Select Id From WorkOrderLineItem Where Plc_SerialNumber__c = null];

        //creates an installed Asset
        List<WorkOrderLineItem> woliList = [Select Id, Plc_SerialNumber__c, Plc_ExternalTermId__c, Status,
                WorkOrder.AccountId From WorkOrderLineItem Where WorkOrderId = :wo.Id];

        B2WExtCat__External_Catalog_Item__c catItemSerial = [Select Id, B2WExtCat__External_Catalog_Item_Name__c
            From B2WExtCat__External_Catalog_Item__c
            Where Plc_ProductSku__c = 'SKU001'];

        Bit2Shop__Product_Stock__c pstockInstalled = new Bit2Shop__Product_Stock__c(
                Bit2Shop__External_Catalog_Item_Id__c   = catItemSerial.Id,
                Bit2Shop__Warehouse_Id__c               = [Select id From Bit2Shop__Warehouse__c Where Plc_Alias__c = 'WHINST001'].Id,
                Name                                    = catItemSerial.B2WExtCat__External_Catalog_Item_Name__c,
                Plc_UsableQty__c                        = 10,
                Bit2Shop__Stock_Qty__c                  = 10,
                Plc_WithdrawnQty__c                     = 10,
                Plc_OrderedQty__c                       = 10,
                RecordTypeId                            = Plc_Utils.getRecordTypeId('Current',
                        Bit2Shop__Product_Stock__c.SObjectType.getDescribe().name)
        );
        insert pstockInstalled;

        Asset ast = new Asset(
                RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET,
                        Asset.SObjectType.getDescribe().name),
                Name = 'Asset 1234',
                InstallDate = System.today(),
                Quantity = 1,
                SerialNumber = woliList[0].Plc_SerialNumber__c,
                NE__SerialNum__c = woliList[0].Plc_SerialNumber__c,
                Bit2Shop__Serial_Number__c = woliList[0].Plc_SerialNumber__c,
                Status = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED,
                Plc_TermId__c = [Select Id From Plc_TermId__c WHere Plc_TermIdCode__c = :woliList[0].Plc_ExternalTermId__c].Id,
                AccountId = woliList[0].WorkOrder.AccountId,
                Plc_ServicePointLegacyId__c = wo.Plc_LegacyServicePointId__c,
                Plc_StockSerial__c = [Select Id From Bit2Shop__Stock_Serials2__c limit 1].Id,
                Plc_ProductStock__c = pstockInstalled.Id

        );
        insert ast;

        Bit2Shop__Stock_Serials2__c stockSerial = new Bit2Shop__Stock_Serials2__c(
                Bit2Shop__Status__c             = 'New',
                //there can be 3 different serial numbers
                Bit2Shop__Serial_Number__c      = 'SUBSTITUTE1234',
                Plc_DllSerialNumber__c          = 'SUBSTITUTE1234',
                Plc_EncodedSerialNumber__c      = 'SUBSTITUTE1234',
                Plc_ManufacturerSerialNumber__c = 'SUBSTITUTE1234',
                Bit2Shop__Product_Stock_Id__c   = ast.Plc_ProductStock__c,
                Plc_TermId__c                   = ast.Plc_TermId__c,
                Bit2Shop__Warehouse_Id__c       = pstockInstalled.Bit2Shop__Warehouse_Id__c
        );
        insert stockSerial;

        woliList[0].Plc_OperationType__c = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_SUBSTITUTE;
        woliList[0].Plc_TermId__c = ast.Plc_TermId__c;
        woliList[0].Plc_SerialNumber__c = 'SUBSTITUTE1234';
        update woliList[0];

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transizione from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();
        List<Asset> assetList = [Select Id From Asset Limit 3];
        List<Plc_TermId__c> termIdList = [Select Id From Plc_TermId__c Limit 3];
        List<Bit2Shop__Shipment_Line_Item__c> shipments = [Select Id From Bit2Shop__Shipment_Line_Item__c];

        //Product: 2 IN and 2 OUT, Serial: 2 IN and 2 OUT
        system.assert(shipments.size() == 8, 'Cound of Shipment Line Items differs from 4: '+shipments.size());

        system.assert(assetList.size() == 2, 'Found 0 or more assets: '+assetList.size());
        system.assert(termIdList.size() == 1, 'Found 0 or more termIds: '+termIdList.size());

        woliList = [Select Plc_Closed__c From WorkOrderLineItem Where Id IN :woliList];
        for(WorkOrderLineItem woli: woliList){
            System.assert(woli.Plc_Closed__c == true, 'Woli is not closed');
        }
    }


    static testMethod void unit_test_substitution_with_removal_close() {
        WorkOrder wo = [Select Id, Status, Plc_LegacyServicePointId__c From WorkOrder Limit 1];
        wo.RecordTypeId = Plc_Utils.getRecordTypeId(WORKORDER_RT_SUBSTITUTION, WorkOrder.SObjectType.getDescribe().name);
        update wo;

        //deletes the Woli without serials
        delete [Select Id From WorkOrderLineItem Where Plc_SerialNumber__c = null];

        //creates an installed Asset
        List<WorkOrderLineItem> woliList = [Select Id, Plc_SerialNumber__c, Plc_ExternalTermId__c, Status,
                WorkOrder.AccountId From WorkOrderLineItem Where WorkOrderId = :wo.Id];

        B2WExtCat__External_Catalog_Item__c catItemSerial = [Select Id, B2WExtCat__External_Catalog_Item_Name__c
        From B2WExtCat__External_Catalog_Item__c
        Where Plc_ProductSku__c = 'SKU001'];

        Bit2Shop__Product_Stock__c pstockInstalled = new Bit2Shop__Product_Stock__c(
                Bit2Shop__External_Catalog_Item_Id__c   = catItemSerial.Id,
                Bit2Shop__Warehouse_Id__c               = [Select id From Bit2Shop__Warehouse__c Where Plc_Alias__c = 'WHINST001'].Id,
                Name                                    = catItemSerial.B2WExtCat__External_Catalog_Item_Name__c,
                Plc_UsableQty__c                        = 10,
                Bit2Shop__Stock_Qty__c                  = 10,
                Plc_WithdrawnQty__c                     = 10,
                Plc_OrderedQty__c                       = 10,
                RecordTypeId                            = Plc_Utils.getRecordTypeId('Current',
                        Bit2Shop__Product_Stock__c.SObjectType.getDescribe().name)
        );
        insert pstockInstalled;

        Asset ast = new Asset(
                RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET,
                        Asset.SObjectType.getDescribe().name),
                Name = 'Asset 1234',
                InstallDate = System.today(),
                Quantity = 1,
                SerialNumber = woliList[0].Plc_SerialNumber__c,
                NE__SerialNum__c = woliList[0].Plc_SerialNumber__c,
                Bit2Shop__Serial_Number__c = woliList[0].Plc_SerialNumber__c,
                Status = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED,
                Plc_TermId__c = [Select Id From Plc_TermId__c WHere Plc_TermIdCode__c = :woliList[0].Plc_ExternalTermId__c].Id,
                AccountId = woliList[0].WorkOrder.AccountId,
                Plc_ServicePointLegacyId__c = wo.Plc_LegacyServicePointId__c,
                Plc_StockSerial__c = [Select Id From Bit2Shop__Stock_Serials2__c limit 1].Id,
                Plc_ProductStock__c = pstockInstalled.Id

        );
        insert ast;

        Bit2Shop__Stock_Serials2__c stockSerial = new Bit2Shop__Stock_Serials2__c(
                Bit2Shop__Status__c             = 'New',
                //there can be 3 different serial numbers
                Bit2Shop__Serial_Number__c      = 'SUBSTITUTE1234',
                Plc_DllSerialNumber__c          = 'SUBSTITUTE1234',
                Plc_EncodedSerialNumber__c      = 'SUBSTITUTE1234',
                Plc_ManufacturerSerialNumber__c = 'SUBSTITUTE1234',
                Bit2Shop__Product_Stock_Id__c   = ast.Plc_ProductStock__c,
                Plc_TermId__c                   = ast.Plc_TermId__c,
                Bit2Shop__Warehouse_Id__c       = pstockInstalled.Bit2Shop__Warehouse_Id__c
        );
        insert stockSerial;

        woliList[0].Plc_OperationType__c = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_REMOVE;
        woliList[0].Plc_TermId__c = ast.Plc_TermId__c;
        woliList[0].Plc_SerialNumber__c = 'SUBSTITUTE1234';
        update woliList[0];

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transizione from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();
        List<Asset> assetList = [Select Id From Asset Limit 3];
        List<Plc_TermId__c> termIdList = [Select Id From Plc_TermId__c Limit 3];
        List<Bit2Shop__Shipment_Line_Item__c> shipments = [Select Id From Bit2Shop__Shipment_Line_Item__c];

        woliList = [Select Plc_Closed__c From WorkOrderLineItem Where Id IN :woliList];

        //Product: 2 IN and 2 OUT, Serial: 2 IN and 2 OUT
        system.assert(shipments.size() == 4, 'Cound of Shipment Line Items differs from 4: '+shipments.size());

        system.assert(assetList.size() == 1, 'Found 0 or more assets: '+assetList.size());

        for(WorkOrderLineItem woli: woliList){
            System.assert(woli.Plc_Closed__c == true, 'Woli is not closed');
        }
    }

    static testMethod void unit_test_uninstallation_with_deactivation_close() {
        WorkOrder wo = [Select Id, Status, Plc_LegacyServicePointId__c From WorkOrder Limit 1];
        wo.RecordTypeId = Plc_Utils.getRecordTypeId(WORKORDER_RT_UNINSTALLATION, WorkOrder.SObjectType.getDescribe().name);
        update wo;

        //deletes the Woli without serials
        delete [Select Id From WorkOrderLineItem Where Plc_SerialNumber__c = null];

        List<WorkOrderLineItem> woliList = [Select Id, Plc_SerialNumber__c, Plc_ExternalTermId__c, Status,
                WorkOrder.AccountId From WorkOrderLineItem Where WorkOrderId = :wo.Id];

        Asset ast = new Asset(
                RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET,
                        Asset.SObjectType.getDescribe().name),
                Name = 'Asset 1234',
                InstallDate = System.today(),
                Quantity = 1,
                SerialNumber = woliList[0].Plc_SerialNumber__c,
                NE__SerialNum__c = woliList[0].Plc_SerialNumber__c,
                Bit2Shop__Serial_Number__c = woliList[0].Plc_SerialNumber__c,
                Status = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED,
                Plc_TermId__c = [Select Id From Plc_TermId__c WHere Plc_TermIdCode__c = :woliList[0].Plc_ExternalTermId__c].Id,
                AccountId = woliList[0].WorkOrder.AccountId,
                Plc_ServicePointLegacyId__c = wo.Plc_LegacyServicePointId__c,
                Plc_StockSerial__c = [Select Id From Bit2Shop__Stock_Serials2__c limit 1].Id,
                Plc_ProductStock__c = [Select Id From Bit2Shop__Product_Stock__c
                Where Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = :Plc_WorkOrderApxAct.EXT_CATALOG_ITEM_CATEGORY_PRODUCT limit 1].Id
        );
        insert ast;

        woliList[0].Plc_OperationType__c = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_DEACTIVATE;
        woliList[0].AssetId = ast.Id;
        update woliList[0];

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transizione from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();

        woliList = [Select Plc_Closed__c From WorkOrderLineItem Where Id IN :woliList];
        for(WorkOrderLineItem woli: woliList){
            System.assert(woli.Plc_Closed__c == true, 'Woli is not closed');
        }
    }


    @isTest
    static void toSubstituteCorrTest() {
        
        delete [SELECT Id FROM WorkOrderLineItem];
        delete [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        delete [SELECT Id FROM Plc_TermId__c];

        B2WExtCat__External_Catalog_Item__c catItemSerial = 
            [SELECT Id, B2WExtCat__External_Catalog_Item_Name__c, Plc_Alias__c
             FROM B2WExtCat__External_Catalog_Item__c
             WHERE Plc_ProductSku__c = 'SKU001'];

        Bit2Shop__Product_Stock__c pstockInstalled = new Bit2Shop__Product_Stock__c(
            Bit2Shop__External_Catalog_Item_Id__c   = catItemSerial.Id,
            Bit2Shop__Warehouse_Id__c               = [SELECT id From Bit2Shop__Warehouse__c WHERE Plc_Alias__c = 'WHINST001'].Id,
            Name                                    = 'PSinstalled',
            Plc_UsableQty__c                        = 10,
            Bit2Shop__Stock_Qty__c                  = 10,
            Plc_WithdrawnQty__c                     = 10,
            Plc_OrderedQty__c                       = 10,
            RecordTypeId                            = Plc_Utils.getRecordTypeId('Current',
                                                      Bit2Shop__Product_Stock__c.SObjectType.getDescribe().name)
        );
        insert pstockInstalled;

        Plc_Reservation__c reservation = new Plc_Reservation__c(                    
            Plc_Status__c = Plc_Constants.Plc_Reservation.PlcStatus_Reserved,
            Plc_ProductStock__c = pstockInstalled.Id
        );
        insert reservation;

        Plc_TermId__c termId = new Plc_TermId__c(Plc_TermIdCode__c = 'CurrentTID-001');
        insert termId;

        Bit2Shop__Stock_Serials2__c ss2Installed = new Bit2Shop__Stock_Serials2__c(
            Bit2Shop__Status__c             = Plc_Constants.B2S_StockSerials2.B2S_Status_Installed,
            Bit2Shop__Serial_Number__c      = 'ss1234',
            Plc_DllSerialNumber__c          = 'ss1234',
            Plc_EncodedSerialNumber__c      = 'ss1234',
            Plc_ManufacturerSerialNumber__c = 'ss1234',
            Bit2Shop__Product_Stock_Id__c   = pstockInstalled.Id,
            Plc_TermId__c                   = termId.Id,
            Bit2Shop__Warehouse_Id__c       = pstockInstalled.Bit2Shop__Warehouse_Id__c
        );
        insert ss2Installed;

        Asset ast = new Asset(
            RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET,
                                                     Asset.SObjectType.getDescribe().name),
            Name = 'Asset 1234',
            InstallDate = System.today(),
            Quantity = 1,
            SerialNumber = ss2Installed.Plc_EncodedSerialNumber__c,
            NE__SerialNum__c = ss2Installed.Plc_EncodedSerialNumber__c,
            Bit2Shop__Serial_Number__c = ss2Installed.Plc_EncodedSerialNumber__c,
            Status = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED,
            Plc_TermId__c = termId.Id,
            AccountId = [SELECT Id FROM Account WHERE Name = 'testAccountInstalled'].Id,
            Plc_ServicePointLegacyId__c = 'Current service point',
            Plc_StockSerial__c = ss2Installed.Id,
            Plc_ProductStock__c = pstockInstalled.Id
        );
        insert ast;

        Bit2Shop__Stock_Serials2__c ss2withdrawn = new Bit2Shop__Stock_Serials2__c(
            Bit2Shop__Status__c             = Plc_Constants.B2S_StockSerials2.B2S_Status_Withdrawn,
            Bit2Shop__Serial_Number__c      = 'ss4567',
            Plc_DllSerialNumber__c          = 'ss4567',
            Plc_EncodedSerialNumber__c      = 'ss4567',
            Plc_ManufacturerSerialNumber__c = 'ss4567',
            Bit2Shop__Product_Stock_Id__c   = [SELECT Id FROM Bit2Shop__Product_Stock__c WHERE Name = :catItemSerial.B2WExtCat__External_Catalog_Item_Name__c].Id,
            Plc_TermId__c                   = null,
            Bit2Shop__Warehouse_Id__c       = [SELECT Id FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = 'WH001'].Id
        );
        insert ss2withdrawn;

        WorkOrder wo = [SELECT Id, Status, Plc_LegacyServicePointId__c FROM WorkOrder LIMIT 1];
        wo.Plc_LegacyServicePointId__c = 'new service point';
        wo.RecordTypeId = Plc_Utils.getRecordTypeId(WORKORDER_RT_CORR, 'WorkOrder');
        update wo;
                
        WorkOrderLineItem woli = new WorkOrderLineItem(
            WorkOrderId                         = wo.Id,
            AssetId                             = ast.Id,   // current asset to uninstall
            Plc_Reservation__c                  = reservation.Id,
            Plc_ExternalTermId__c               = 'NewTID-002',
            Plc_OperationType__c                = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_SUBSTCORR,
            Plc_SerialNumber__c                 = ss2withdrawn.Bit2Shop__Serial_Number__c,   //new serial to substitute
            Status                              = Plc_WorkOrderApxAct.WOLI_STATUS_EXECUTED,
            Plc_ReferenceExternalCatalogItem__c = catItemSerial.Plc_Alias__c
        );
        insert woli;

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transition from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();

        List<Asset> assetList = [SELECT Id FROM Asset];
        System.assertEquals(2, assetList.size(), 'Found 0 or more assets: '+assetList.size());

        List<Plc_TermId__c> termIdList = [SELECT Id FROM Plc_TermId__c];
        System.assertEquals(2, termIdList.size(), 'Found 0 or more termIds: '+termIdList.size());

        //CHECK new asset
        Asset astNew = [SELECT Id, Plc_TermId__c, Plc_TermId__r.Plc_TermIdCode__c,
                               SerialNumber, NE__SerialNum__c, Bit2Shop__Serial_Number__c,
                               Plc_ServicePointLegacyId__c, Plc_ProductStock__c,
                               Plc_StockSerial__c, Plc_StockSerial__r.Bit2Shop__Status__c
                        FROM Asset
                        WHERE Status = :Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED 
                          AND SerialNumber = :woli.Plc_SerialNumber__c];
        
        System.assert(astNew != null, 'new asset has not been created');
        System.assertNotEquals(null, astNew.Plc_TermId__c, 'new termid has not been created');
        System.assertNotEquals(termId.Id, astNew.Plc_TermId__c, 'the new asset should point to the new termid');
        System.assertEquals(woli.Plc_ExternalTermId__c, astNew.Plc_TermId__r.Plc_TermIdCode__c);
        
        //check also SS2 transition performed by stock actions
        System.assertEquals(Plc_Constants.B2S_StockSerials2.B2S_Status_Installed, astNew.Plc_StockSerial__r.Bit2Shop__Status__c, 'new ss2 should be in Installed status');
        
        System.assertEquals(wo.Plc_LegacyServicePointId__c, astNew.Plc_ServicePointLegacyId__c);

        //CHECK sli - Product: 2 IN and 2 OUT, Serial: 2 IN and 2 OUT
        List<Bit2Shop__Shipment_Line_Item__c> sliList = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c];
        System.assertEquals(8, sliList.size(), 'Count of Shipment Line Items differs from 8: '+sliList.size());

        //CHECK woli
        List<WorkOrderLineItem> woliChkList = [SELECT Plc_Closed__c, WorkOrder.Plc_LegacyServicePointId__c 
                                               FROM WorkOrderLineItem];
        for(WorkOrderLineItem woliChk : woliChkList) {
            System.assertEquals(true, woliChk.Plc_Closed__c, 'Woli is not closed');
            System.assertEquals(wo.Plc_LegacyServicePointId__c, woliChk.WorkOrder.Plc_LegacyServicePointId__c);
        }
    }


    @isTest
    static void toReconfigCorrTest() {
        
        delete [SELECT Id FROM WorkOrderLineItem];
        delete [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        delete [SELECT Id FROM Plc_TermId__c];

        B2WExtCat__External_Catalog_Item__c catItemSerial = 
            [SELECT Id, B2WExtCat__External_Catalog_Item_Name__c, Plc_Alias__c
             FROM B2WExtCat__External_Catalog_Item__c
             WHERE Plc_ProductSku__c = 'SKU001'];

        Bit2Shop__Product_Stock__c pstockInstalled = new Bit2Shop__Product_Stock__c(
            Bit2Shop__External_Catalog_Item_Id__c   = catItemSerial.Id,
            Bit2Shop__Warehouse_Id__c               = [SELECT id From Bit2Shop__Warehouse__c WHERE Plc_Alias__c = 'WHINST001'].Id,
            Name                                    = 'PSinstalled',
            Plc_UsableQty__c                        = 10,
            Bit2Shop__Stock_Qty__c                  = 10,
            Plc_WithdrawnQty__c                     = 10,
            Plc_OrderedQty__c                       = 10,
            RecordTypeId                            = Plc_Utils.getRecordTypeId('Current',
                                                      Bit2Shop__Product_Stock__c.SObjectType.getDescribe().name)
        );
        insert pstockInstalled;

        Plc_TermId__c termId = new Plc_TermId__c(Plc_TermIdCode__c = 'CurrentTID-001');
        insert termId;

        Bit2Shop__Stock_Serials2__c ss2Installed = new Bit2Shop__Stock_Serials2__c(
            Bit2Shop__Status__c             = Plc_Constants.B2S_StockSerials2.B2S_Status_Installed,
            Bit2Shop__Serial_Number__c      = 'ss1234',
            Plc_DllSerialNumber__c          = 'ss1234',
            Plc_EncodedSerialNumber__c      = 'ss1234',
            Plc_ManufacturerSerialNumber__c = 'ss1234',
            Bit2Shop__Product_Stock_Id__c   = pstockInstalled.Id,
            Plc_TermId__c                   = termId.Id,
            Bit2Shop__Warehouse_Id__c       = pstockInstalled.Bit2Shop__Warehouse_Id__c
        );
        insert ss2Installed;

        Asset ast = new Asset(
            RecordTypeId = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.ASSET_RECORDTYPE_TECHNICAL_ASSET,
                                                     Asset.SObjectType.getDescribe().name),
            Name = 'Asset 1234',
            InstallDate = System.today(),
            Quantity = 1,
            SerialNumber = ss2Installed.Plc_EncodedSerialNumber__c,
            NE__SerialNum__c = ss2Installed.Plc_EncodedSerialNumber__c,
            Bit2Shop__Serial_Number__c = ss2Installed.Plc_EncodedSerialNumber__c,
            Status = Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED,
            Plc_TermId__c = termId.Id,
            AccountId = [SELECT Id FROM Account WHERE Name = 'testAccountInstalled'].Id,
            Plc_ServicePointLegacyId__c = 'Current service point',
            Plc_StockSerial__c = ss2Installed.Id,
            Plc_ProductStock__c = pstockInstalled.Id
        );
        insert ast;
        System.debug('CHECK-asset:\n'+JSON.serializePretty(ast));

        WorkOrder wo = [SELECT Id, Status, Plc_LegacyServicePointId__c FROM WorkOrder LIMIT 1];
        wo.Plc_LegacyServicePointId__c = 'new service point';
        wo.RecordTypeId = Plc_Utils.getRecordTypeId(WORKORDER_RT_CORR, 'WorkOrder');
        update wo;
                
        WorkOrderLineItem woli = new WorkOrderLineItem(
            WorkOrderId                         = wo.Id,
            AssetId                             = ast.Id,   // current asset to uninstall
            Plc_ExternalTermId__c               = 'NewTID-002',
            Plc_OperationType__c                = Plc_WorkOrderApxAct.WOLI_OPERATION_TYPE_TO_RECONFCORR,
            Plc_SerialNumber__c                 = null,
            Status                              = Plc_WorkOrderApxAct.WOLI_STATUS_EXECUTED,
            Plc_ReferenceExternalCatalogItem__c = catItemSerial.Plc_Alias__c
        );
        insert woli;

        Test.startTest();
        //to test Plc_WorkOrderApxAct we'll be using the Phase Manager phase transition from Assigned to Closed
        wo.Status = 'Closed';
        update wo;
        Test.stopTest();

        List<Asset> assetList = [SELECT Id FROM Asset];
        System.assertEquals(2, assetList.size(), 'Found 0 or more assets: '+assetList.size());

        List<Plc_TermId__c> termIdList = [SELECT Id FROM Plc_TermId__c];
        System.assertEquals(2, termIdList.size(), 'Found 0 or more termIds: '+termIdList.size());

        //CHECK old asset
        Asset astOld = [SELECT Id, Status, Plc_TermId__c, Plc_TermId__r.Plc_TermIdCode__c,
                               SerialNumber, NE__SerialNum__c, Bit2Shop__Serial_Number__c,
                               Plc_ServicePointLegacyId__c, Plc_ProductStock__c,
                               Plc_StockSerial__c, Plc_StockSerial__r.Bit2Shop__Status__c, Plc_StockSerial__r.Plc_TermId__c
                        FROM Asset
                        WHERE Id = :ast.Id];
        System.assertEquals(Plc_WorkOrderApxAct.ASSET_STATUS_UNINSTALLED, astOld.Status, 'old asset should be in Uninstalled status');
        System.assertEquals(ss2Installed.Id, astOld.Plc_StockSerial__c, 'the old asset should point to the same ss2');

        //CHECK new asset
        Asset astNew = [SELECT Id, Status, Plc_TermId__c, Plc_TermId__r.Plc_TermIdCode__c,
                               SerialNumber, NE__SerialNum__c, Bit2Shop__Serial_Number__c,
                               Plc_ServicePointLegacyId__c, Plc_ProductStock__c,
                               Plc_StockSerial__c, Plc_StockSerial__r.Bit2Shop__Status__c, Plc_StockSerial__r.Plc_TermId__c
                        FROM Asset
                        WHERE Plc_TermId__r.Plc_TermIdCode__c = :woli.Plc_ExternalTermId__c];

        System.assertNotEquals(astNew.Id, ast.Id, 'new asset has not been created');
        //System.assert(astNew != null, 'new asset has not been created');
        System.assertNotEquals(null, astNew.Plc_TermId__c, 'new termid has not been created');
        System.assertNotEquals(termId.Id, astNew.Plc_TermId__c, 'the new asset should point to the new termid');
        System.assertEquals(ss2Installed.Id, astNew.Plc_StockSerial__c, 'the new asset should point to the same ss2');
        System.assertEquals(astNew.Plc_TermId__c, astNew.Plc_StockSerial__r.Plc_TermId__c, 'the ss2 should point to the new termid');
        
        System.assertEquals(Plc_WorkOrderApxAct.ASSET_STATUS_INSTALLED, astNew.Status, 'new asset should be in Installed status');
        System.assertEquals(Plc_Constants.B2S_StockSerials2.B2S_Status_Installed, astNew.Plc_StockSerial__r.Bit2Shop__Status__c, 'the ss2 should not had changed Installed status');
        System.assertEquals(wo.Plc_LegacyServicePointId__c, astNew.Plc_ServicePointLegacyId__c);

        //CHECK sli
        List<Bit2Shop__Shipment_Line_Item__c> sliList = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c];
        System.assertEquals(0, sliList.size(), 'no Shipment Line Items should be created: '+sliList.size());

        //CHECK woli
        List<WorkOrderLineItem> woliChkList = [SELECT Plc_Closed__c, WorkOrder.Plc_LegacyServicePointId__c 
                                               FROM WorkOrderLineItem];
        for(WorkOrderLineItem woliChk : woliChkList) {
            System.assertEquals(true, woliChk.Plc_Closed__c, 'Woli is not closed');
            System.assertEquals(wo.Plc_LegacyServicePointId__c, woliChk.WorkOrder.Plc_LegacyServicePointId__c);
        }
    }

}