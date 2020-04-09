/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC WsUtils Rest WebService.
 */
@isTest
public class Plc_WsUtilsTest {
    @testSetup
    
    static void setup(){	
   		
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, '1234');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Nexi', '0123654789560', bit2ShopDealer);
        insert bit2ShopWarehouse;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, 'Test', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = '009874563210789651234';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;

    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 17/12/2018
    * @version 1.0
    * @description Test of the method getRequestTimestamp.
    */
    @isTest
    static void getRequestTimestampTest(){
       Datetime dt = DateTime.newInstanceGMT(System.now().year(),System.now().month(),System.now().day(), System.now().hour(),System.now().minute(),System.now().second());
       // Start test
       Test.startTest();
       Long timestamp = Plc_WsUtils.getRequestTimestamp(dt);
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 17/12/2018
    * @version 1.0
    * @description Test of the method getRequestTimestamp without parameter.
    */
    @isTest
    static void getRequestTimestampWithoutParamTest(){
       // Start test
       Test.startTest();
       Long timestamp = Plc_WsUtils.getRequestTimestamp();
       // Stop test
       Test.stopTest();
    }
    
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 17/12/2018
   * @version 1.0
   * @description Test of the method retrieveProductStocks.
   */
   @isTest
   static void retrieveProductStocksTest(){
    
   Plc_Wrappers.GestioneDisponibilitaRequestBody payLoad = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
   'Disinstallazione', '009874563210789651234', '1234567980', '005412378965412301234', '0123654789560', 'Nexi');
    
    // Start test
    Test.startTest();
    Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(payLoad);
    // Stop test
    Test.stopTest();
    }
    
        
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 17/12/2018
   * @version 1.0
   * @description Test of the method retrieveProductStocks with resource Alias and warehouse alias parameters.
   */
   @isTest
   static void retrieveProductStocksWithTwoParametersTest(){
    
    List<String> resourceAliasList = new List<String>{'009874563210789651234'};
    List<String> warehouseAliasList= new List<String>{'0123654789560'};
    // Start test
    Test.startTest();
    Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(resourceAliasList,warehouseAliasList);
    // Stop test
    Test.stopTest();
    }
    
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 17/12/2018
   * @Modified 02/04/2019 by Mame Diarra
   * @version 1.0
   * @description Test of the method retrieveProductStocksCompatible.
   */
   @isTest
   static void retrieveProductStocksCompatibleTest(){
	   B2WExtCat__External_Catalog_Item__c b2ExtCatItem  =[SELECT Id,Plc_ProductSku__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];  
       b2ExtCatItem.Plc_ProductSku__c='009874563210789651234';
       update b2ExtCatItem;
    // Start test
    Test.startTest();
    Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocksCompatible('009874563210789651234','0123654789560');
    // Stop test
    Test.stopTest();
    }
    
   /**
   * @author Abdoulaye & Moussa
   * @date Creation 17/12/2018
   * @version 1.0
   * @description Test of the method addTimeValue.
   */
   @isTest
   static void addTimeValueTest(){
    
    // Start test
    Test.startTest();
    String infoValue = Plc_WsUtils.addTimeValue('info','value');
    // Stop test
    Test.stopTest();
    }

   /**
   * @author Abdoulaye & Moussa
   * @date Creation 17/12/2018
   * @version 1.0
   * @description Test of the method makeProcessingTime.
   */
   @isTest
   static void makeProcessingTimeTest(){
    
    Datetime dt = DateTime.newInstanceGMT(System.now().year(),System.now().month(),System.now().day(), System.now().hour(),System.now().minute(),System.now().second());
    // Start test
    Test.startTest();
    String processingTime = Plc_WsUtils.makeProcessingTime(dt,dt+7);
    // Stop test
    Test.stopTest();
    }
   
   /**
   * @author Mame Diarra
   * @date Creation 01/02/2019
   * @version 1.0
   * @description Test of the method retriveWarehouseOwners.
   */
    @isTest
    static void retriveWarehouseOwnersTest(){
        List<String> warehouseAliasList = new List<String>();
        warehouseAliasList.add('0123654789560');
        // Start test
        Test.startTest();
     	Map<String, Bit2Shop__Warehouse__c> warehouseOwnersMap = Plc_WsUtils.retriveWarehouseOwners(warehouseAliasList);
    	// Stop test
    	Test.stopTest();//
    }
}