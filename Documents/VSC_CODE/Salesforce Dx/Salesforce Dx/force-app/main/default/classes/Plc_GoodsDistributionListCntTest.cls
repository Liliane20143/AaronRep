/**
 * @author Abdoulaye & Moussa
 * @author Francesco Bigoni
 * @date Creation 06/12/2018
 * @Modify : 2019/03/04 by Moussa Fofana
 * @version 1.0
 * @description Test of Plc_GoodsDistributionListCnt
 */
@isTest
public class Plc_GoodsDistributionListCntTest {
    
    @testSetup
    static void setup(){
        
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer1 = Plc_TestFactory.createDealer('dealer1', account, 'Test1');
        insert bit2ShopDealer1;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, 'Test2');
        bit2ShopDealer.Plc_Maintainer__c = true;
        bit2ShopDealer.Plc_Repairer__c = false;
        bit2ShopDealer.Bit2Shop__Parent_Dealer__c = bit2ShopDealer1.Id;
        insert bit2ShopDealer;

        System.debug('### bit2ShopDealer ### ' + JSON.serialize(bit2ShopDealer));
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Generic', '', '000001NEXI',  bit2ShopDealer);
        bit2ShopWarehouse.Plc_UniqueKey__c = 'code';
        bit2ShopWarehouse.Plc_CoverageIndex__c = 1;//000001NEXI
        System.debug('### bit2ShopWarehouse ### ' + JSON.serialize(bit2ShopWarehouse));
        insert bit2ShopWarehouse;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        Plc_WarehouseSolution__c plcWarehouseSolution = Plc_TestFactory.createWarehouseSolution('00789654123654789',plcSolution,bit2ShopWarehouse);
        plcWarehouseSolution.Name='warehouse solution';
        plcWarehouseSolution.Plc_ConsumedQty__c = 2;
        plcWarehouseSolution.Plc_CorrectionQty__c = 10;
        plcWarehouseSolution.Plc_AvailableQty__c = 1;
        plcWarehouseSolution.Plc_OrderedQty__c = 1;
        insert plcWarehouseSolution;

        /********************************************************/
        //Records for warehouse of new items
        Id recordType=Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');
        
        Bit2Shop__Dealer__c dealerNewItems = Plc_TestFactory.createDealer('dealerNewItems', account, 'Test3');
        dealerNewItems.Plc_Repairer__c = false;
        dealerNewItems.Plc_Manufacturer__c = true;
        insert dealerNewItems;

        Bit2Shop__Dealer__c childDealerNewItems = Plc_TestFactory.createDealerChild('childDealerNew', account, 'Test4', dealerNewItems);
        childDealerNewItems.Plc_Repairer__c = true;
        dealerNewItems.Plc_Manufacturer__c=true;
        insert childDealerNewItems;

        Plc_TestFactory.createWarehouse('WarehouseNewItems', 'Repaired', '000002NEXI', '',  childDealerNewItems);

        Bit2Shop__Warehouse__c warehouseNewItems = Plc_TestFactory.createWarehouse('WarehouseNewItems', 'Repaired', '', '000002NEXI',  childDealerNewItems);
        warehouseNewItems.Plc_CoverageIndex__c = 1;
        warehouseNewItems.Plc_UniqueKey__c = 'newItems';
        insert warehouseNewItems;
        /********************************************************/

        Bit2Shop__Warehouse__c dummyWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c =:'000001NEXI' LIMIT 1];
        System.debug('MYA ' + dummyWarehouse);

        Plc_DistributionList__c plcDistributionList = new Plc_DistributionList__c(Plc_Alias__c='Plc_AliasTest1',Plc_Status__c='Draft');
        insert plcDistributionList;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, 
                                                                                                    '37377', 'Process');
            //b2wExtCatExtCat.Plc_Manufacturer__c = dealerNewItems.Id;
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 2;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 1; 
        insert bit2ShopProductStock;
        
        Plc_PurchaseOrder__c plcPurchaseOrder = new Plc_PurchaseOrder__c(Plc_Status__c = 'Open', Plc_RdaNumber__c='Test');
        plcPurchaseOrder.Plc_PurchaseWarrantyDuration__c = 2;
        insert plcPurchaseOrder;      

        Plc_DistributionListItem__c plcDistListItem = new Plc_DistributionListItem__c();
        plcDistListItem.Plc_PurchaseOrder__c = plcPurchaseOrder.Id;
        plcDistListItem.Plc_DistributionList__c = plcDistributionList.Id;
        plcDistListItem.Plc_OriginDealer__c = childDealerNewItems.Id;
        plcDistListItem.Plc_DestinationWarehouse__c = bit2ShopWarehouse.Id;
        plcDistListItem.Plc_Product__c = b2wExtCatExtCat.Id;
        plcDistListItem.Plc_RequestedQty__c = 15;
        plcDistListItem.Plc_OriginWarehouse__c = warehouseNewItems.Id;
        plcDistListItem.Plc_Note__c = 'test';
        insert plcDistListItem;

        Plc_PurchaseOrderItem__c plcPurchaseOrderItem1 = new Plc_PurchaseOrderItem__c (Plc_Alias__c = 'PlcPurchaseOrderTest1',
                                                                                       Plc_PurchaseOrder__c = plcPurchaseOrder.Id,
                                                                                       Plc_Model__c = b2wExtCatExtCat.Id,
                                                                                       Plc_Quantity__c = 35,
                                                                                       Plc_UnitPrice__c = 100,
                                                                                       Plc_OrderedQty__c = 2);
        insert plcPurchaseOrderItem1;

        Plc_PurchaseOrderItem__c plcPurchaseOrderItem2 = new Plc_PurchaseOrderItem__c (Plc_Alias__c = 'PlcPurchaseOrderTest2',
                                                                                       Plc_PurchaseOrder__c = plcPurchaseOrder.Id,
                                                                                       Plc_Model__c = b2wExtCatExtCat.Id,
                                                                                       Plc_Quantity__c = 15,
                                                                                       Plc_UnitPrice__c = 100,
                                                                                       Plc_OrderedQty__c = 2);
        insert plcPurchaseOrderItem2;

        /********************************************************/
        //Records for repaired items
        Bit2Shop__Dealer__c dealerRepaired = Plc_TestFactory.createDealer('dealerRepaired', account, 'Test5');
        dealerRepaired.Plc_Repairer__c = true;
        insert dealerRepaired;

        Bit2Shop__Dealer__c childDealerRepaired = Plc_TestFactory.createDealer('childDealerRep', account, 'Test6');
        childDealerRepaired.Plc_Repairer__c = true;
        insert childDealerRepaired;

        Bit2Shop__Warehouse__c warehouseRepaired = Plc_TestFactory.createWarehouse('warehouse repaired', 'Repaired', '', '000003NEXI', childDealerRepaired);
        warehouseRepaired.Plc_CoverageIndex__c = 1;
        warehouseRepaired.Plc_LogisticDivision__c ='';
        insert warehouseRepaired;
        
        /*************************************  Tipology New Warehouse  *************************************/
                
        Bit2Shop__Dealer__c childDealerNew = Plc_TestFactory.createDealerChild('childDealerNew', account, 'TestTipo', bit2ShopDealer1);
        //childDealerNew.Plc_Maintainer__c = true;
        childDealerNew.Plc_Repairer__c = false;
        childDealerNew.Plc_Manufacturer__c = true;
        insert childDealerNew;

        Bit2Shop__Warehouse__c warehouseNew = Plc_TestFactory.createWarehouse('warehouse new', 'New', 'Neutral', '000004NEXI', childDealerRepaired);
        warehouseNew.Plc_CoverageIndex__c = 1;
        //insert warehouseNew;
        
        /*********************************************    END     **********************************************/

        Bit2Shop__Product_Stock__c productStockRepaired = Plc_TestFactory.createProductStock(b2wExtCatExtCat, warehouseRepaired);
        productStockRepaired.Plc_UsableQty__c = 2;
        productStockRepaired.Plc_WithdrawnQty__c = 1; 
        insert productStockRepaired;

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = warehouseRepaired.Id;
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = productStockRepaired.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Repaired';
        insert bit2ShopStockSerials2;

        Plc_DistributionListItem__c plcDistListItemRepaired = new Plc_DistributionListItem__c();
        plcDistListItemRepaired.Plc_DistributionList__c = plcDistributionList.Id;
        plcDistListItemRepaired.Plc_OriginDealer__c = dealerRepaired.Id;
        plcDistListItemRepaired.Plc_DestinationWarehouse__c = bit2ShopWarehouse.Id;
        plcDistListItemRepaired.Plc_Product__c = b2wExtCatExtCat.Id;
        plcDistListItemRepaired.Plc_RequestedQty__c = 1;
        plcDistListItemRepaired.Plc_OriginWarehouse__c = warehouseRepaired.Id;
        plcDistListItemRepaired.Plc_Note__c = 'test';
        insert plcDistListItemRepaired;

        /********************************************************/
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 29/01/2019
    * @version 1.0
    * @description Test of the method retrieveTranslationMap
    */
    @isTest
    static void retrieveTranslationMapTestOk() {
      //Start test
      Test.startTest();
      Map<String, Object> response = Plc_GoodsDistributionListCnt.retrieveTranslationMap();
      //Stop test
      Test.stopTest();
      System.assert(response != null);
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 13/12/2018
    * @version 1.0
    * @description Test of the method  retrievePropertiesMap.
    */
    @isTest
    static void retrievePropertiesMapTest(){
        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_GoodsDistributionListCnt.retrievePropertiesMap();
        //for the Plc_DistributionList__c with Plc_Status__c equals Draft
        Plc_DistributionList__c plcDistribution = [SELECT Id,Plc_Status__c FROM Plc_DistributionList__c LIMIT 1];
        plcDistribution.Plc_Status__c = 'Requested';
        update plcDistribution;
        Map<String, Object> response1 = Plc_GoodsDistributionListCnt.retrievePropertiesMap();
        //for the Bit2Shop__Warehouse__c with Plc_Tipology__c equals New
        Bit2Shop__Warehouse__c bit2ShopWarehouse = [SELECT Id,Plc_Tipology__c, Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        
        Bit2Shop__Dealer__c dealer = [SELECT Id, Plc_Maintainer__c, Plc_Repairer__c FROM Bit2Shop__Dealer__c WHERE Id=: bit2ShopWarehouse.Bit2Shop__Dealer_Id__c  LIMIT 1];
        dealer.Plc_Maintainer__c = false;
        dealer.Plc_Manufacturer__c = true;
        update dealer;
        
        bit2ShopWarehouse.Plc_Tipology__c = 'New';
        update bit2ShopWarehouse;
        Map<String, Object> response2 = Plc_GoodsDistributionListCnt.retrievePropertiesMap();
       // Stop test
        Test.stopTest();
    }
     
    @isTest
    static void test(){
        Test.startTest();
        System.runAs(Plc_TestFactory.createUser('ad', 'Costruttore')) {
            Map<String, Object> response = Plc_GoodsDistributionListCnt.retrievePropertiesMap();
        }
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 15/01/2019
     * @version 1.0
     * @description Test of the method  retrievePropertiesMap and not null plc purchaseOrder.
     */
    @isTest
    static void retrievePropertiesMapAndNotNullPurchaseOrderTest(){
        
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse= [SELECT Id,Plc_Tipology__c, Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        bit2ShopWarehouse.Plc_Tipology__c = 'Repaired';
        
        Bit2Shop__Dealer__c dealer = [SELECT Id, Plc_Maintainer__c, Plc_Repairer__c FROM Bit2Shop__Dealer__c WHERE Id=: bit2ShopWarehouse.Bit2Shop__Dealer_Id__c  LIMIT 1];
        dealer.Plc_Maintainer__c = false;
        dealer.Plc_Repairer__c = true;
        update dealer;
        
        Plc_DistributionListItem__c plcDistListItem = [SELECT Id, Name, Plc_DestinationWarehouse__c, Plc_PurchaseOrder__c, Plc_Product__c,
                                                                Plc_RequestedQty__c, Plc_OriginWarehouse__r.Bit2Shop__Dealer_Id__c, Plc_Note__c
                                                        FROM Plc_DistributionListItem__c LIMIT 1];
        Plc_PurchaseOrder__c plcPurchaseOrder= [SELECT Id FROM Plc_PurchaseOrder__c LIMIT 1];
        plcDistListItem.Plc_PurchaseOrder__c=plcPurchaseOrder.Id;
        update plcDistListItem;
        
        // Start test
        Test.startTest();
        Map<String, Object> response =Plc_GoodsDistributionListCnt.retrievePropertiesMap();
        
        update bit2ShopWarehouse;
        Map<String, Object> response2 =Plc_GoodsDistributionListCnt.retrievePropertiesMap();
        // Stop test
        Test.stopTest();
    }

   /**
   * @author Abdoulaye & Moussa
   * @author Francesco Bigoni
   * @date Creation 14/12/2018
   * @version 1.0
   * @description Test of the method  saveDistributionList.
   */
   @isTest
   static void saveDistributionListTestOK(){

      Account account = Plc_TestFactory.createAccountSupplier('Name');
      insert account;

      Bit2Shop__Dealer__c fakeDealer = Plc_TestFactory.createDealer('fake dealer', account, '000_001');
      insert fakeDealer;
       
      Plc_DistributionList__c  plcDistList = [SELECT Id 
                                              FROM Plc_DistributionList__c 
                                              LIMIT 1];
      Plc_PurchaseOrder__c plcPurchaseOrder = [SELECT Id 
                                               FROM Plc_PurchaseOrder__c 
                                               LIMIT 1];
      Plc_DistributionListItem__c plcDistListItem = [SELECT Id, Plc_PurchaseOrder__c 
                                                     FROM Plc_DistributionListItem__c 
                                                     LIMIT 1];
      plcDistListItem.Plc_PurchaseOrder__c = plcPurchaseOrder.Id;
      update plcDistListItem;

      Bit2Shop__Product_Stock__c productStock= [SELECT Id, Name, Plc_ProductSku__c, Plc_AvailableQty__c,
                                                       Plc_OrderedQty__c, Bit2Shop__Warehouse_Id__c,
                                                       Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c,
                                                       Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__c,
                                                       Bit2Shop__External_Catalog_Item_Id__c 
                                                 FROM Bit2Shop__Product_Stock__c 
                                                 LIMIT 1];
                                                 
      Plc_WarehouseSolution__c warehouseSolution= [SELECT Id 
                                                   FROM Plc_WarehouseSolution__c 
                                                   LIMIT 1];

      Bit2Shop__Warehouse__c warehouseRepaired = [SELECT Id
                                                  FROM Bit2Shop__Warehouse__c
                                                  WHERE Plc_Alias__c = '000003NEXI'
                                                  LIMIT 1];
      WarehouseRepairedItemsRequestWrp whRepairedItemsRequest = new WarehouseRepairedItemsRequestWrp(warehouseRepaired.Id, 
                                                                                                     'test', 
                                                                                                     'testDealer', 
                                                                                                     '', 
                                                                                                     1, 
                                                                                                     1);
      ProductSolutionWrp productSolution = new ProductSolutionWrp(productStock.Name, 
                                                                  productStock.Plc_ProductSku__c,
                                                                  productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__c,
                                                                  productStock.Plc_AvailableQty__c,
                                                                  productStock.Plc_OrderedQty__c,
                                                                  productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c,
                                                                  productStock.Bit2Shop__Warehouse_Id__c,
                                                                  productStock.Bit2Shop__External_Catalog_Item_Id__c,
                                                                  '' + warehouseSolution.Id);
      productSolution.whRepairedItems = new List<WarehouseRepairedItemsRequestWrp>{whRepairedItemsRequest};
      productSolution.newItems = 40;
      
      // Start test
      Test.startTest();
      Map<String, Object> response = Plc_GoodsDistributionListCnt.saveDistributionList(JSON.serialize(new List<ProductSolutionWrp>{productSolution}),'' + plcDistList.Id);
      Map<String, Object> response2 = Plc_GoodsDistributionListCnt.saveDistributionList(JSON.serialize(new List<ProductSolutionWrp>{}), null);
      // Stop test
      Test.stopTest();
   }

   /**
   * @author Francesco Bigoni
   * @date Creation 14/12/2018
   * @version 1.0
   * @description Test ko (missing fake dealer )of the method saveDistributionList.
   */
   @isTest
   static void saveDistributionListTestMissingFakeDealerKO(){
       
      Bit2Shop__Product_Stock__c productStock= [SELECT Id, Name, Plc_ProductSku__c, Plc_AvailableQty__c,
                                                       Plc_OrderedQty__c, Bit2Shop__Warehouse_Id__c,
                                                       Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c,
                                                       Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__c,
                                                       Bit2Shop__External_Catalog_Item_Id__c 
                                                 FROM Bit2Shop__Product_Stock__c 
                                                 LIMIT 1];
      Plc_WarehouseSolution__c warehouseSolution= [SELECT Id FROM Plc_WarehouseSolution__c LIMIT 1];

      ProductSolutionWrp productSolution = new ProductSolutionWrp(productStock.Name, 
                                                                  productStock.Plc_ProductSku__c,
                                                                  productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__c,
                                                                  productStock.Plc_AvailableQty__c,
                                                                  productStock.Plc_OrderedQty__c,
                                                                  productStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c,
                                                                  productStock.Bit2Shop__Warehouse_Id__c,
                                                                  productStock.Bit2Shop__External_Catalog_Item_Id__c,
                                                                  '' + warehouseSolution.Id);
      productSolution.newItems = 5;
      
      // Start test
      Test.startTest();
      Map<String, Object> response2 = Plc_GoodsDistributionListCnt.saveDistributionList(JSON.serialize(new List<ProductSolutionWrp>{}), null);
      // Stop test
      Test.stopTest();
   }

   /**
   * @author Abdoulaye & Moussa
   * @date Creation 14/12/2018
   * @version 1.0
   * @description Test of the method  saveDistributionList and blank Plc_Manufacturer.
   */
   //@isTest
   /*static void saveDistributionListAndBlankPlcManufaturerTest(){
       
       B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat=[SELECT Id,Plc_Manufacturer__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
       Bit2Shop__Dealer__c bit2ShopDealer = [SELECT Id FROM Bit2Shop__Dealer__c LIMIT 1];
       b2wExtCatExtCat.Plc_Manufacturer__c=bit2ShopDealer.Id;
       update b2wExtCatExtCat;
       Plc_DistributionList__c  plcDistList=[SELECT Id FROM Plc_DistributionList__c LIMIT 1];
       Plc_PurchaseOrder__c plcPurchaseOrder=[SELECT Id,Plc_Status__c FROM Plc_PurchaseOrder__c LIMIT 1];
       Plc_DistributionListItem__c plcDistListItem= [SELECT Id,Plc_PurchaseOrder__c,Plc_OriginDealer__c FROM Plc_DistributionListItem__c LIMIT 1];
       plcDistListItem.Plc_PurchaseOrder__c=plcPurchaseOrder.Id;
       update plcDistListItem;
       Bit2Shop__Product_Stock__c productStock= [SELECT Id,Plc_ProductSku__c,Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c,Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__c,Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
       Plc_WarehouseSolution__c warehouseSolution= [SELECT Id FROM Plc_WarehouseSolution__c LIMIT 1];

       WarehouseRepairedItemsRequestWrp whouseRepairedItemsRequestWrp = new WarehouseRepairedItemsRequestWrp(plcDistListItem.Id,'test',
                                        'test',
                                        plcDistListItem.Plc_OriginDealer__c, 5,10);
       List<WarehouseRepairedItemsRequestWrp> whRepairedItems = new List<WarehouseRepairedItemsRequestWrp>{whouseRepairedItemsRequestWrp};
       ProductSolutionWrp productSolution = new ProductSolutionWrp(productStock, warehouseSolution.Id);
       productSolution.newItems = 5;
       productSolution.whRepairedItems=whRepairedItems;
       Bit2Shop__Warehouse__c bit2ShopWarehouse= [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
       // Start test
       Test.startTest();
       Map<String, Object> response = Plc_GoodsDistributionListCnt.saveDistributionList(JSON.serialize(new List<ProductSolutionWrp>{productSolution}),''+plcDistList.Id);
       productSolution.warehouseNewProductsId=''+bit2ShopWarehouse.Id;
       Map<String, Object> response2 = Plc_GoodsDistributionListCnt.saveDistributionList(JSON.serialize(new List<ProductSolutionWrp>{productSolution}),''+plcDistList.Id);
       productSolution.newItems = 2;
       Map<String, Object> response3 = Plc_GoodsDistributionListCnt.saveDistributionList(JSON.serialize(new List<ProductSolutionWrp>{productSolution}),''+plcDistList.Id);     
       whouseRepairedItemsRequestWrp.requestedQty=0;
       Map<String, Object> response4 = Plc_GoodsDistributionListCnt.saveDistributionList(JSON.serialize(new List<ProductSolutionWrp>{productSolution}),''+plcDistList.Id);     

       // Stop test
       Test.stopTest();
   }*/
 
   /**
    * @author Abdoulaye & Moussa
    * @date Creation 03/01/2019
    * @version 1.0
    * @description Test of the method changeDistributionListOwner.
    */    
   @isTest
   static void changeDistributionListOwnerTestOK(){
       Plc_DistributionList__c distributionList = [SELECT Id FROM Plc_DistributionList__c LIMIT 1];
       //Start test
       Test.startTest();
       Map<String, Object> response = Plc_GoodsDistributionListCnt.changeDistributionListOwner('' + distributionList.Id);
       //Stop test
       Test.stopTest();
   }
     
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 03/01/2019
   * @version 1.0
   * @description Test of the method catch changeDistributionListOwner.
   */
   @isTest
   static void changeDistributionListOwnerTestKO(){       
       // Start test
       Test.startTest();
       Map<String, Object> response = Plc_GoodsDistributionListCnt.changeDistributionListOwner('HH666H');
       // Stop test
       Test.stopTest();
   }
    
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 03/01/2019
   * @version 1.0
   * @description Test of the method retrieveAvailableModels.
   */
   @isTest
   static void retrieveAvailableModelsTestOK(){    
       
       Plc_WarehouseSolution__c whSolutions= [SELECT Id FROM Plc_WarehouseSolution__c LIMIT 1];
       
       // Start test
       Test.startTest();
       Map<String, Object> response = Plc_GoodsDistributionListCnt.retrieveAvailableModels(''+whSolutions.Id);
       // Stop test
       Test.stopTest();
   }
   
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 03/01/2019
   * @version 1.0
   * @description Test of the method catch retrieveAvailableModels.
   */
   @isTest
   static void retrieveAvailableModelsTestKO(){    
              
       // Start test
       Test.startTest();
       Map<String, Object> response = Plc_GoodsDistributionListCnt.retrieveAvailableModels('[');
       // Stop test
       Test.stopTest();
   }
    
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 03/01/2019
   * @version 1.0
   * @description Test of the method catch createNewProductStock.
   */
   @isTest
   static void createNewProductStockTestOK(){    
       B2WExtCat__External_Catalog_Item__c modelId= [SELECT Id FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
       Bit2Shop__Warehouse__c warehouseId=[SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
       Bit2Shop__Dealer__c dealerId=[SELECT Id FROM Bit2Shop__Dealer__c LIMIT 1];
       Bit2Shop__Reference_Period__c bit2ShopRefPeriod = new Bit2Shop__Reference_Period__c(Bit2Shop__Status__c='Current');
       bit2ShopRefPeriod.Bit2Shop__Dealer_Id__c=dealerId.Id;
       bit2ShopRefPeriod.Bit2Shop__Start_Date__c=  date.newInstance(2019, 01, 03);
       insert bit2ShopRefPeriod;
              
       // Start test
       Test.startTest();
       Map<String, Object> response = Plc_GoodsDistributionListCnt.createNewProductStock(modelId.Id,warehouseId.Id,dealerId.Id);
       // Stop test
       Test.stopTest();
   }
    
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 03/01/2019
   * @version 1.0
   * @description Test of the method catch createNewProductStock.
   */
   @isTest
   static void createNewProductStockTestKO(){    
       Bit2Shop__Dealer__c dealerId=[SELECT Id FROM Bit2Shop__Dealer__c LIMIT 1];  
       // Start test
       Test.startTest();
       Map<String, Object> response = Plc_GoodsDistributionListCnt.createNewProductStock(''+dealerId.Id,'warehouseId','dealerId');
       // Stop test
       Test.stopTest();
   }
   
   
    /**
     * Wrapper class for products with additional information
     */
    class ProductSolutionWrp {
        //Bit2Shop__Product_Stock__c productStock;
        String warehouseSolutionId;
        Decimal remainingQty;
        String warehouseNewProductsId;
        Decimal numberOfRepaired;
        Decimal newItems;
        Decimal repairedItems;
        String noteNew;
        /****/
        String Name;
        String PlcProductSku;
        String PlcManufacturer;
        Decimal PlcAvailableQty;
        Decimal PlcOrderedQty;
        Decimal PlcMinimumStock;
        String Bit2ShopWarehouseId;
        String Bit2ShopExternalCatalogItemId;
        /***/
        List<WarehouseRepairedItemsRequestWrp> whRepairedItems;

        public ProductSolutionWrp(String Name, String PlcProductSku, String PlcManufacturer,
                                  Decimal PlcAvailableQty, Decimal Plc_OrderedQty, Decimal PlcMinimumStock, 
                                  String Bit2ShopWarehouseId, String Bit2ShopExternalCatalogItemId, 
                                  String warehouseSolutionId) {
            /*****/
            this.Name = Name; 
            this.PlcProductSku = PlcProductSku; 
            this.PlcManufacturer = PlcManufacturer; 
            this.PlcAvailableQty = PlcAvailableQty; 
            this.PlcOrderedQty = PlcOrderedQty; 
            this.PlcMinimumStock = PlcMinimumStock; 
            this.Bit2ShopWarehouseId = Bit2ShopWarehouseId;
            this.Bit2ShopExternalCatalogItemId = Bit2ShopExternalCatalogItemId;
            /*****/ 
            //this.productStock = productStock;
            this.warehouseSolutionId = warehouseSolutionId;
            this.remainingQty = 0;
            this.numberOfRepaired = 0;
            this.newItems = 0;
            this.repairedItems = 0;
        }
    }

   /**
    * Wrapper class for repaired items warehouse with related information
    */
   class WarehouseRepairedItemsRequestWrp {
        String id;
        String name;
        String dealerName;
        String dealerId;
        Decimal availableQty;
        Decimal requestedQty;
        String distributionListItemId;
        String note;

        public WarehouseRepairedItemsRequestWrp(String id, String name, String dealerName,
                                                String dealerId, Decimal availableQty, 
                                                Integer requestedQty) {
            this.id = id;
            this.name = name;
            this.dealerName = dealerName;
            this.dealerId = dealerId;
            this.availableQty = availableQty;
            this.requestedQty = requestedQty;
        }
    }
}