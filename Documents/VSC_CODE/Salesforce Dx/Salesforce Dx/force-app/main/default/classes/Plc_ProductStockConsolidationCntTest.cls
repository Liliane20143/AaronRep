/** 
 * @author Francesco Bigoni
 * @date Creation 02/04/2019
 * @version 1.0
 * @description Plc_ProductStockConsolidationCnt test class
 */
@isTest
public class Plc_ProductStockConsolidationCntTest {

    @testSetup
    static void setup() {
        
        //Init process click data
        Plc_TestFactory.initProcessClickPackage();

        //Creating a new Account and Dealer
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        //Creatin dealer
        Bit2Shop__Dealer__c dealer1 = new Bit2Shop__Dealer__c();
        dealer1.Bit2Shop__Account_Id__c = account.Id;
        dealer1.Plc_Repairer__c = true;
        dealer1.Plc_Alias__c = 'dealer1';
        insert dealer1;

        //Creating a new Warehouse
        Bit2Shop__Warehouse__c warehouse1 = new Bit2Shop__Warehouse__c();
        warehouse1.Name = 'warehouse1';
        warehouse1.Plc_Alias__c = 'aliasWarehouse';
        warehouse1.Bit2Shop__Dealer_Id__c = dealer1.Id;
        warehouse1.Plc_UniqueKey__c= '12345567';
        warehouse1.Plc_Tipology__c = 'Repaired';
        insert warehouse1;

        //Creating a new External Catalog and an Item
        B2WExtCat__External_Catalog__c catalog = new B2WExtCat__External_Catalog__c();
        catalog.B2WExtCat__all__c = 'Catalogue';
        catalog.B2WExtCat__External_Catalog_Name__c = 'Cat Name';
        insert catalog;

        //Creating model
        B2WExtCat__External_Catalog_Item__c model = new B2WExtCat__External_Catalog_Item__c();
        model.B2WExtCat__External_Catalog_Item_Name__c = 'Test';
        model.Bit2Shop__Product_SKU__c = 'testSKU';
        model.B2WExtCat__Type__c = 'Process';
        model.Bit2Shop__Required_Serial__c = false;
        model.B2WExtCat__External_Catalog__c = catalog.Id;
        insert model;

        //Creating a new Product Stock
        Bit2Shop__Product_Stock__c productStock = new Bit2Shop__Product_Stock__c();
        productStock.Bit2Shop__External_Catalog_Item_Id__c = model.Id;
        productStock.Bit2Shop__Warehouse_Id__c = warehouse1.Id;
        productStock.Plc_UsableQty__c = 5;
        productStock.Plc_WithdrawnQty__c = 3;
        insert productStock;
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 02/04/2019
    * @version 1.0
    * @description Test of the method retrieveTranslationMap
    */
    @isTest
    static void retrieveTranslationMapTestOk() { 
        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_ProductStockConsolidationCnt.retrieveTranslationMap();
        //Stopping test
        Test.stopTest();
        System.assert(response != null);
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 02/04/2019
    * @version 1.0
    * @description Test of the method retrieveProductStocks
    */
    @isTest
    static void retrieveProductStocksTestOk() {

        Bit2Shop__Warehouse__c warehouse1 = [SELECT Id
                                             FROM Bit2Shop__Warehouse__c
                                             LIMIT 1];

        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_ProductStockConsolidationCnt.retrieveProductStocks('' + warehouse1.Id, '');
        //Stopping test
        Test.stopTest();
        System.assert(response.get('error') == false);
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 02/04/2019
    * @version 1.0
    * @description Test of the method createProductStockSnapshots
    */
    @isTest
    static void createProductStockSnapshotsTestOk() {

        Bit2Shop__Warehouse__c warehouse1 = [SELECT Id
                                             FROM Bit2Shop__Warehouse__c
                                             LIMIT 1];

        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_ProductStockConsolidationCnt.createProductStockSnapshots('' + warehouse1.Id);
        //Stopping test
        Test.stopTest();
        System.assert(response.get('error') == false);
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 02/04/2019
    * @version 1.0
    * @description Test of the method preCheck
    */
    @isTest
    static void preCheckTestOk() {
        //Starting test
        Test.startTest();
        String response = Plc_ProductStockConsolidationCnt.preCheck();
        //Stopping test
        Test.stopTest();
        System.assert(response != null);
    }
}