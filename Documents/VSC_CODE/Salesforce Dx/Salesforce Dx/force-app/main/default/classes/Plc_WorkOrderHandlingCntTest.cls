/**
 * @author Abdoulaye & Moussa
 * @author Francesco Bigoni
 * @date Creation 02/01/2019
 * @version 1.0
 * @description Test of Plc Plc_WorkOrderHandlingCnt.
 */
@isTest
public class Plc_WorkOrderHandlingCntTest {
    
    @testSetup
    static void setup(){
        
        Plc_TestFactory.initProcessClickPackage();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Account account2 = Plc_TestFactory.createAccountSupplier('Name2');
        insert account2;
        
        Account account3 = Plc_TestFactory.createAccountSupplier('Name3');
        insert account3;
        
        Contact contact = Plc_TestFactory.createContactGeneric('Name');
        insert contact;

        Id b2ShopDealRecType = Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, 'Dealer1');
        bit2ShopDealer.Plc_Repairer__c = true;
        bit2ShopDealer.Plc_DealerManufacturer__c = true;
        insert bit2ShopDealer;

        Bit2Shop__Dealer__c bit2ShopDealer2 = Plc_TestFactory.createDealerChild('dealer', account, 'Installati_Dealer2', bit2ShopDealer);
        bit2ShopDealer2.Plc_Repairer__c = true;
        insert bit2ShopDealer2;

        Bit2Shop__Dealer__c bit2ShopDealer3 = Plc_TestFactory.createDealerChild('dealer', account, 'Installati_Dealer3', bit2ShopDealer);
        bit2ShopDealer3.Plc_Repairer__c = true;
        insert bit2ShopDealer3;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w', 'Repaired', 'Nexi', '00789654123654789', bit2ShopDealer2);
        insert bit2ShopWarehouse;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('005412378965412303');
        insert plcSolution;



        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Catalogo Tecnico');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, 'T930DEM0NV1', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = 'T930DEM0NV1';
        b2wExtCatExtCat.Plc_Category__c='Accessory';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat.Plc_Manufacturer__c = bit2ShopDealer.Id;
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;
        
        
        Plc_WarehouseSolution__c plcWarehouseSolution = Plc_TestFactory.createWarehouseSolution('00789654123654789', plcSolution, bit2ShopWarehouse);
        plcWarehouseSolution.Name='warehouse solution';
        plcWarehouseSolution.Plc_ConsumedQty__c =2;
        plcWarehouseSolution.Plc_CorrectionQty__c =1;
        plcWarehouseSolution.Plc_AvailableQty__c=3;
        plcWarehouseSolution.Plc_OrderedQty__c=1;
        //plcWarehouseSolution.Plc_Warehouse__c=''+bit2ShopWarehouse.Id;
        insert plcWarehouseSolution;
        
        /****/
        B2WExtCat__External_Catalog_Item__c modelProduct = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '1234567', 'Process');
        modelProduct.Plc_Alias__c = '1234567';
        modelProduct.Plc_Category__c='Product';
        modelProduct.Plc_Solution__c = plcSolution.Id;
        modelProduct.Plc_Manufacturer__c = bit2ShopDealer.Id;
        insert modelProduct;

        Bit2Shop__Product_Stock__c productStockProduct = Plc_TestFactory.createProductStock(modelProduct, bit2ShopWarehouse);
        productStockProduct.Plc_UsableQty__c = 5;
        productStockProduct.Plc_WithdrawnQty__c = 3; 
        insert productStockProduct;
        /***/
        
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('12345');
        insert plcTermId;
        
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
        insert workOrder;
        

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCatItemProduct = Plc_TestFactory.createExtCatalogItem('EFT930 Ethernet Modem V1', b2WExtCatExtCatalog, 
                                                                                                              'FT930DEM0NV1', 'Process');
        b2wExtCatExtCatItemProduct.Plc_Alias__c = 'FT930DEM0NV1';
        b2wExtCatExtCatItemProduct.Plc_Category__c='Product';
        b2wExtCatExtCatItemProduct.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCatItemProduct.B2WExtCat__Status__c='Active';
        b2wExtCatExtCatItemProduct.Plc_Subcategory__c='Router';
        insert b2wExtCatExtCatItemProduct;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCatItemAccessory = Plc_TestFactory.createExtCatalogItem('Accessory', b2WExtCatExtCatalog, 
                                                                                                              'VX45T89GG', 'Process');
        b2wExtCatExtCatItemAccessory.Plc_Alias__c = 'VX45T89GG';
        b2wExtCatExtCatItemAccessory.Plc_Category__c='Accessory';
        b2wExtCatExtCatItemAccessory.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCatItemAccessory.B2WExtCat__Status__c='Active';
        b2wExtCatExtCatItemAccessory.Plc_Subcategory__c='Pinpad';
        insert b2wExtCatExtCatItemAccessory;

        Asset parentAsset =new Asset(Name='Parent');
        parentAsset.Plc_ProductStock__c=productStockProduct.Id;
		parentAsset.Plc_ServicePointLegacyId__c='ff4a01hg';
        parentAsset.AccountId=account.Id;
        parentAsset.Status='Uninstalled';
        parentAsset.Plc_TermId__c = plcTermId.Id;
        insert parentAsset;
        
        Asset childAsset =new Asset(Name='Test');
        childAsset.Plc_ProductStock__c=bit2ShopProductStock.Id;
		childAsset.Plc_ServicePointLegacyId__c='ea594cc00';
        childAsset.AccountId=account.Id;
        childAsset.Status='Installed';
        childAsset.ParentId=parentAsset.Id;
        childAsset.Plc_TermId__c = plcTermId.Id;
    	insert childAsset;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse2 = Plc_TestFactory.createWarehouse('w2', 'Repaired', 'Nexi', '000001NEXI', bit2ShopDealer3);
        bit2ShopWarehouse2.Plc_CoverageIndex__c=1;
        insert bit2ShopWarehouse2;
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c=bit2ShopWarehouse2.Id;
        bit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'TestManufacturer1';
        bit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'TestEncoded1';
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Withdrawn';
        insert bit2ShopStockSerials2;

        /****/
        Bit2Shop__Stock_Serials2__c stockSerialProduct = new Bit2Shop__Stock_Serials2__c();
        stockSerialProduct.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse2.Id;
        bit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'TestManufacturer2';
        stockSerialProduct.Plc_EncodedSerialNumber__c = 'TestEncoded2';
        stockSerialProduct.Bit2Shop__Product_Stock_Id__c = productStockProduct.Id;
        stockSerialProduct.Bit2Shop__Status__c = 'Withdrawn';
        insert stockSerialProduct;
        /****/

        WorkOrderLineItem woliProductsList = new WorkOrderLineItem();
        woliProductsList.Status='Executed';
        woliProductsList.Plc_TermId__c=plcTermId.Id;
        woliProductsList.Plc_SerialNumber__c='serial number';
        woliProductsList.Plc_ExternalCatalogItem__c=b2wExtCatExtCatItemProduct.Id;
        woliProductsList.WorkOrderId=workOrder.Id;
        woliProductsList.Plc_StockSerial__c = bit2ShopStockSerials2.Id;
        woliProductsList.Plc_SerialNumber__c = bit2ShopStockSerials2.Plc_EncodedSerialNumber__c;
        woliProductsList.Plc_OperationType__c='ToSubstitute';
        woliProductsList.AssetId=parentAsset.Id;
        insert woliProductsList;

        WorkOrderLineItem woliAccessory = new WorkOrderLineItem();
        woliAccessory.Status = 'Executed';
        woliAccessory.Plc_TermId__c = plcTermId.Id;
        woliAccessory.Plc_SerialNumber__c = 'serial number';
        woliAccessory.Plc_ExternalCatalogItem__c = b2wExtCatExtCatItemAccessory.Id;
        woliAccessory.WorkOrderId = workOrder.Id;
        woliAccessory.Plc_StockSerial__c = bit2ShopStockSerials2.Id;
        woliAccessory.Plc_SerialNumber__c = bit2ShopStockSerials2.Plc_EncodedSerialNumber__c;
        woliAccessory.ParentWorkOrderLineItemId = woliProductsList.Id;
        woliAccessory.Plc_OperationType__c = 'ToSubstitute';
        insert woliAccessory;
       
        Plc_ProductCompatibility__c productCompatibility=new Plc_ProductCompatibility__c ();
        productCompatibility.Plc_Accessory__c=''+b2wExtCatExtCat.Id;
		productCompatibility.Plc_Alias__c='00541237896541230';
		productCompatibility.Plc_ExternalAccessory__c='Wr_Matricola_Difettosa';
		productCompatibility.Plc_ExternalProduct__c='Product';
		productCompatibility.Plc_Product__c=''+b2wExtCatExtCatItemProduct.Id;
        insert productCompatibility;

        //Added FB 4-02-2019
        Bit2Shop__TransferDetail__c transfDetail1 = new Bit2Shop__TransferDetail__c(
                Bit2Shop__Code__c   = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSDETAIL_MESSAINCAMPO,
                Bit2Shop__Transfer_Type__c = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Plc_Alias__c        = 'TD001'
        );
        insert transfDetail1;

        insert new Plc_SystemSettings__c(Name = 'SystemSettings',
                Plc_DaysForCalculatingConsumption__c = 30,
                Plc_PurchaseWarrantyMonthsDelay__c   = 5
        );

        /*************************/

        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c(
                RecordtypeId                                = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER,
                                                                                        Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = Plc_WorkOrderApxAct.STOCK_ORDER_STATUS_GENERATED,
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Transfer_Type__c                  = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Bit2Shop__Point_Of_Sales_Id__c              = bit2ShopDealer2.Id,
                Bit2Shop__Holding_Id__c                     = account.Id,
                Bit2Shop__Warehouse_Id__c                   = bit2ShopWarehouse.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = bit2ShopWarehouse2.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = bit2ShopWarehouse2.Id
        );

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
                Bit2Shop__Shipment_Document_Number__c   = 'test'
        );
        insert shipmentIn;

        Bit2Shop__Shipment_Line_Item__c serialIn = new Bit2Shop__Shipment_Line_Item__c(
                RecordTypeId                    = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_ITEM_RECORDTYPE_SERIAL,
                        Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                Bit2Shop__Type__c               = Plc_WorkOrderApxAct.SHIPMENT_ITEM_TYPE_SERIAL,
                Bit2Shop__Status__c             = Plc_WorkOrderApxAct.SHIPMENT_ITEM_STATUS_PENDING,
                Bit2Shop__Transfer_Detail_Id__c = stockOrder.Plc_TransferDetail__c,
                Bit2Shop__Date__c               = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Received_Quantity__c  = 1,
                Bit2Shop__Shipment_Id__c        = shipmentIn.Id,
                Bit2Shop__Received_Status__c    = Plc_WorkOrderApxAct.SHIPMENT_ITEM_REVEICED_STATUS_NOTRECEIVED,
                Plc_StockSerial__c              = bit2ShopStockSerials2.Id
        );

        insert serialIn;
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method retrieveTranslationMap
    */
    @isTest
    static void retrieveTranslationMapTestOk() {
      //Start test
      Test.startTest();
      Map<String, Object> response = Plc_WorkOrderHandlingCnt.retrieveTranslationMap();
      //Stop test
      Test.stopTest();
      System.assert(response != null);
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 02/01/2019
     * @version 1.0
     * @description Test of the method retrievePropertiesMap .
     */
    @isTest
    static void retrievePropertiesMapTestOK(){ 
       
        WorkOrder workOrder = [SELECT Id FROM WorkOrder LIMIT 1];
        
        Asset asset = [SELECT Id,Status,Plc_ServicePointLegacyId__c,ParentId FROM Asset  WHERE Status='Installed' LIMIT 1];
        
        //Start test
        Test.startTest();
        Map<String, Object> wolineProductsList =Plc_WorkOrderHandlingCnt.retrievePropertiesMap(''+workOrder.Id);
        //Stop test
        Test.stopTest();
        
    }

     /**
     * @author Abdoulaye & Moussa
     * @date Creation 02/01/2019
     * @version 1.0
     * @description Test of the method retrieveAvailableModels.
     */
    @isTest
    static void retrieveAvailableModelsTestOK(){

        List<B2WExtCat__External_Catalog_Item__c> prod=[SELECT Name, Plc_Solution__c FROM B2WExtCat__External_Catalog_Item__c];
        Bit2Shop__Product_Stock__c b2ShopProductStock =[SELECT Name FROM Bit2Shop__Product_Stock__c LIMIT 1];
        
        // Start test
        Test.startTest();
        Map<String, Object> warehousesList =Plc_WorkOrderHandlingCnt.retrieveAvailableModels('00789654123654789',''+b2ShopProductStock.Name,
                                                                                             'Product',new List<String>(),prod[1].Id,
                                                                                              new List<String>(), prod[0].Plc_Solution__c);
        // Stop test
        Test.stopTest();
        
    }
    
     /**
     * @author Abdoulaye & Moussa
     * @date Creation 02/01/2019
     * @version 1.0
     * @description Test of the method catch retrieveAvailableModels.
     */
    @isTest
    static void retrieveAvailableModelsTestKO(){ 
        
        Bit2Shop__Product_Stock__c b2ShopProductStock =[SELECT Name,Bit2Shop__Warehouse_Id__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        B2WExtCat__External_Catalog_Item__c prod=[SELECT Name, Plc_Solution__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];

        // Start test
        Test.startTest();
        Map<String, Object> warehousesList = Plc_WorkOrderHandlingCnt.retrieveAvailableModels('','','',new List<String>(), 
                                                                                              prod.Id, new List<String>(),
                                                                                              prod.Plc_Solution__c);
        // Stop test
        Test.stopTest();
    }
    
    //@isTest static void saveItemsTest(){
        
    //    WorkOrder workOrder = [SELECT Id FROM WorkOrder LIMIT 1];

    //    List<WorkOrderLineItem> woliProductsList=[SELECT ID FROM WorkOrderLineItem LIMIT 1];

    //    Test.startTest();
    //    Map<String, Object> result=Plc_WorkOrderHandlingCnt.saveItems(workOrder.Id,JSON.serialize(woliProductsList));
    //    Test.stopTest();
    //}

  //  @isTest static void saveItemsTestEmptyWoliId(){
        
  //      WorkOrder workOrder = [SELECT Id FROM WorkOrder LIMIT 1];
		//Plc_TermId__c plcTermId = [SELECT Id FROM Plc_TermId__c LIMIT 1];
  //      WorkOrderLineItem parentWoli = [SELECT Id FROM WorkOrderLineItem LIMIT 1];

  //      WorkOrderLineItem woliProductsLi = new WorkOrderLineItem();
  //      woliProductsLi.Plc_TermId__c=plcTermId.Id;
  //      woliProductsLi.WorkOrderId=workOrder.Id;
  //      woliProductsLi.Plc_OperationType__c='ToSubstitute';
  //      woliProductsLi.Plc_Parent__c=parentWoli.Id;
            
  //      List<WorkOrderLineItem> woliProductsList=new List<WorkOrderLineItem>{woliProductsLi}; 
            
  //      //List<WorkOrderLineItemWrp> woliWrpList = (List<WorkOrderLineItemWrp>)JSON.deserialize(JSON.serialize(woliProductsList), List<WorkOrderLineItemWrp>.class);
  //      //woliWrpList[0].childWorkOrderLineItems.add(woliProductsLi);	
        
  //      //System.debug('==WorkOrderLi To WoliWrp== ');
            
  //      Test.startTest();
  //      Map<String, Object> result=Plc_WorkOrderHandlingCnt.saveItems(workOrder.Id,JSON.serialize(woliProductsList));
  //      Test.stopTest();
  //  }
    
    /**
    * @author Francesco Bigoni
    * @date Creation 01/02/2019
    * @version 1.0
    * @description Test of the method saveItems
    * @Modified by Fofana Moussa on 2019/02/11
    */
    @isTest 
    static void saveItemsTestNewProductWithNewAccessoryOk() {
        
        WorkOrder workOrder = [SELECT Id 
                               FROM WorkOrder 
                               LIMIT 1];
        
        Plc_TermId__c plcTermId = [SELECT Id, Plc_TermIdCode__c 
                                   FROM Plc_TermId__c 
                                   LIMIT 1];
        
        List<Bit2Shop__Stock_Serials2__c> stockSerial2List = [SELECT Id, Plc_EncodedSerialNumber__c,
                                                                     Plc_ProductSku__c,
                                                                     Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c
                                                              FROM Bit2Shop__Stock_Serials2__c 
                                                              LIMIT 2];
        B2WExtCat__External_Catalog_Item__c model = [SELECT Id, Plc_ProductSku__c 
                                                     FROM B2WExtCat__External_Catalog_Item__c 
                                                     LIMIT 1];
        Asset asset = [SELECT Id 
                       FROM Asset 
                       LIMIT 1];

        WorkOrderLineItemWrp woliProductInstallationWrp = new WorkOrderLineItemWrp();
        woliProductInstallationWrp.requestedQty = 1;
        woliProductInstallationWrp.termId = plcTermId.Id;
        woliProductInstallationWrp.termIdCode = plcTermId.Plc_TermIdCode__c;
        woliProductInstallationWrp.operationType = 'ToInstall';
        woliProductInstallationWrp.externalCatalogItemId = stockSerial2List.get(0).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c;
        woliProductInstallationWrp.serialId = stockSerial2List.get(0).Id;
        woliProductInstallationWrp.serialNumber = stockSerial2List.get(0).Plc_EncodedSerialNumber__c;
        woliProductInstallationWrp.productSku = stockSerial2List.get(0).Plc_ProductSku__c;
        woliProductInstallationWrp.assetId = '';

        WorkOrderLineItemWrp woliAccessoryInstallationWrp = new WorkOrderLineItemWrp();
        woliAccessoryInstallationWrp.requestedQty = 1;
        woliAccessoryInstallationWrp.termId = plcTermId.Id;
        woliAccessoryInstallationWrp.termIdCode = plcTermId.Plc_TermIdCode__c;
        woliAccessoryInstallationWrp.operationType = 'ToInstall';
        woliAccessoryInstallationWrp.externalCatalogItemId = stockSerial2List.get(1).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c;
        woliAccessoryInstallationWrp.serialId = stockSerial2List.get(1).Id;
        woliAccessoryInstallationWrp.serialNumber = stockSerial2List.get(1).Plc_EncodedSerialNumber__c;
        woliAccessoryInstallationWrp.productSku = stockSerial2List.get(1).Plc_ProductSku__c;
        woliAccessoryInstallationWrp.assetId = '';
        
        woliProductInstallationWrp.childWorkOrderLineItems = new List<WorkOrderLineItemWrp>{woliAccessoryInstallationWrp};
        List<WorkOrderLineItemWrp> woliProductsList = new List<WorkOrderLineItemWrp>{woliProductInstallationWrp}; 
            
        Test.startTest();
        	Map<String, Object> response = Plc_WorkOrderHandlingCnt.saveItems(workOrder, JSON.serialize(woliProductsList));
        Test.stopTest();
    }

     /**
    * @author Francesco Bigoni
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test Ok of the method saveItems
  	* @Modified by Fofana Moussa on 2019/02/11
	*/
    @isTest 
    static void saveItemsTestWxistingWoliWithNewAccessoryOk() {
        
        WorkOrder workOrder = [SELECT Id 
                               FROM WorkOrder 
                               LIMIT 1];
        Plc_TermId__c plcTermId = [SELECT Id, Plc_TermIdCode__c 
                                   FROM Plc_TermId__c 
                                   LIMIT 1];
        WorkOrderLineItem parentWoli = [SELECT Id, Plc_TermId__c
                                        FROM WorkOrderLineItem 
                                        LIMIT 1];
        Bit2Shop__Stock_Serials2__c stockSerial2 = [SELECT Id 
                                                    FROM Bit2Shop__Stock_Serials2__c 
                                                    LIMIT 1];
        B2WExtCat__External_Catalog_Item__c model = [SELECT Id, Plc_ProductSku__c 
                                                     FROM B2WExtCat__External_Catalog_Item__c 
                                                     LIMIT 1];
        Asset asset = [SELECT Id 
                       FROM Asset 
                       LIMIT 1];

        WorkOrderLineItemWrp existingWoliProductWrp = new WorkOrderLineItemWrp();
        existingWoliProductWrp.id = parentWoli.Id;

        WorkOrderLineItemWrp woliAccessorySubstitutionWrp = new WorkOrderLineItemWrp();  
        woliAccessorySubstitutionWrp.requestedQty = 1;  
        woliAccessorySubstitutionWrp.termId = plcTermId.Id;
        woliAccessorySubstitutionWrp.termIdCode = plcTermId.Plc_TermIdCode__c;
        woliAccessorySubstitutionWrp.operationType = 'ToSubstitute';
        woliAccessorySubstitutionWrp.externalCatalogItemId = model.Id;
        woliAccessorySubstitutionWrp.serialId = stockSerial2.Id;
        woliAccessorySubstitutionWrp.serialNumber = 'Test';
        woliAccessorySubstitutionWrp.productSku = model.Plc_ProductSku__c;
        woliAccessorySubstitutionWrp.assetId = asset.Id;
        woliAccessorySubstitutionWrp.replacedBySerialId = stockSerial2.Id;
        
        existingWoliProductWrp.childWorkOrderLineItems = new List<WorkOrderLineItemWrp>{woliAccessorySubstitutionWrp};
        List<WorkOrderLineItemWrp> woliProductsList = new List<WorkOrderLineItemWrp>{existingWoliProductWrp}; 
            
        Test.startTest();
        	Map<String, Object> response = Plc_WorkOrderHandlingCnt.saveItems(workOrder, JSON.serialize(woliProductsList));
        Test.stopTest();
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test Ko of the method saveItems
  	* @Modified by Fofana Moussa on 2019/02/11
    */
    @isTest 
    static void saveItemsTestKo() {
        
        WorkOrder workOrder = [SELECT Id 
                               FROM WorkOrder 
                               LIMIT 1];
            
        Test.startTest();
        	Map<String, Object> response = Plc_WorkOrderHandlingCnt.saveItems(workOrder, null);
        Test.stopTest();
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test ok of the method retrieveAvailableAssets
    */
    @isTest 
    static void retrieveAvailableAssetsTestOk() {


        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.retrieveAvailableAssets('TestAlias', 'TestSearchKey', new List<String>());
        // Stop test
        Test.stopTest();

    }

    /**
    * @author Francesco Bigoni
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test Ko of the method retrieveAvailableAssets
    */
    @isTest 
    static void retrieveAvailableAssetsTestNullConsumedAssetsTestKo() {

        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.retrieveAvailableAssets('TestAlias', 'TestSearchKey', null);
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 06/03/2019
    * @version 1.0
    * @description Test Ok of the method retrieveChildStoreProductAssets
    */
    @isTest 
    static void retrieveChildStoreProductAssetsTestOk() {

        Asset parentAsset = [SELECT Id
                             FROM Asset
                             WHERE ParentId = ''
                             LIMIT 1];
        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.retrieveChildStoreProductAssets(parentAsset.Id);
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Moussa Fofana
    * @date Creation 11/02/2019
    * @version 1.0
    * @description Test of the method saveAccessories
    */
    @isTest 
    static void saveAccessoriesTest() {

       	WorkOrder workOrder = [SELECT Id FROM WorkOrder LIMIT 1];
        
		Plc_TermId__c plcTermId = [SELECT Id FROM Plc_TermId__c LIMIT 1];
  		WorkOrderLineItem parentWoli = [SELECT Id FROM WorkOrderLineItem LIMIT 1];

      	WorkOrderLineItem woliProductsLi = new WorkOrderLineItem();
      	woliProductsLi.Plc_TermId__c=plcTermId.Id;
  		woliProductsLi.WorkOrderId=workOrder.Id;
  		woliProductsLi.Plc_OperationType__c='ToSubstitute';
  		woliProductsLi.Plc_Parent__c=parentWoli.Id;
        
        List<WorkOrderLineItem> woliAccessoryToInsertList=new List<WorkOrderLineItem>{woliProductsLi};
            
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.saveAccessories(workOrder,woliAccessoryToInsertList);
        Test.stopTest();
    }

    /**
    * @author FB
    * @date Creation 08/05/2019
    * @version 1.0
    * @description Test of the method manageSLI with accept
    */
    @isTest 
    static void manageSLITestAcceptOk() {

        Bit2Shop__Shipment_Line_Item__c sli = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c LIMIT 1];
        
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.manageSLI(sli.Id, Plc_WorkOrderHandlingCnt.ACCEPT_ACTION);
        Test.stopTest();
    }

    /**
    * @author FB
    * @date Creation 08/05/2019
    * @version 1.0
    * @description Test of the method manageSLI with refuse
    */
    @isTest 
    static void manageSLITestRefuseOk() {

        Bit2Shop__Shipment_Line_Item__c sli = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c LIMIT 1];
        
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.manageSLI(sli.Id, Plc_WorkOrderHandlingCnt.REFUSE_ACTION);
        Test.stopTest();
    }

    /**
    * @author FB
    * @date Creation 08/05/2019
    * @version 1.0
    * @description Test of the method changeSerialToWithdrawn
    */
    @isTest 
    static void changeSerialToWithdrawn() {

        Contact contact = [SELECT Id 
                           FROM Contact 
                           LIMIT 1];

        Bit2Shop__Stock_Serials2__c stockSerial = [SELECT Id 
                                                   FROM Bit2Shop__Stock_Serials2__c
                                                   LIMIT 1];
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.changeSerialToWithdrawn(stockSerial.Id, contact.Id);
        Map<String, Object> responseKo = Plc_WorkOrderHandlingCnt.changeSerialToWithdrawn('', '');
        Test.stopTest();
    }

    /**
    * @author FB
    * @date Creation 10/05/2019
    * @version 1.0
    * @description Test of the method retrieveWithdrawingTechnician
    */
    @isTest 
    static void retrieveWithdrawingTechnician() {

        Contact contact = [SELECT Id 
                           FROM Contact 
                           LIMIT 1];

        Bit2Shop__Stock_Serials2__c stockSerial = [SELECT Id 
                                                   FROM Bit2Shop__Stock_Serials2__c
                                                   LIMIT 1];
        Test.startTest();
        Map<String, Object> response = Plc_WorkOrderHandlingCnt.retrieveWithdrawingTechnician(stockSerial.Id);
        Map<String, Object> responseKo = Plc_WorkOrderHandlingCnt.retrieveWithdrawingTechnician('');
        Test.stopTest();
    }
    
    /*
     * Wrapper class used to store work order line items information
     */
    class WorkOrderLineItemWrp {
        String id;
        String externalCatalogItemId;
        String lineItemNumber;
        String parentWorkOrderLineItemId;
        String category;
        String subCategory;
        String status;
        String operationType;
        String serialId;
        String serialNumber;
        String productSku;
        String termIdName;
        String termId;
        String termIdCode;
        String assetId;
        Decimal requestedQty;
        String replacedBySerial;
        String replacedBySerialId;
        Boolean requiredSerial; 
        List<WorkOrderLineItemWrp> childWorkOrderLineItems;

        public WorkOrderLineItemWrp(){
            this.id = '';
            this.externalCatalogItemId = '';
            this.lineItemNumber = '';
            this.parentWorkOrderLineItemId = '';
            this.category = '';
            this.subCategory = '';
            this.status = '';
            this.serialId = '';
            this.serialNumber = '';
            this.productSku = '';
            this.termIdName= '';
            this.termId = '';
            this.termIdCode = '';
            this.assetId = '';
            this.requestedQty = 0;
            this.replacedBySerial = '';
            this.replacedBySerialId = '';
            this.requiredSerial = false;
            this.childWorkOrderLineItems = new List<WorkOrderLineItemWrp>();
        }
    }
}