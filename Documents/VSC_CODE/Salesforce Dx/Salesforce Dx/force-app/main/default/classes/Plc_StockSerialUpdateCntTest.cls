/** 
 * @author Francesco Bigoni
 * @date Creation 29/01/2019
 * @version 1.0
 * @description Plc_StockSerialUpdateCnt test class
 * @Modifcation : Khalidou I. Sow BA On 2019/04/01
 */
@isTest
public class Plc_StockSerialUpdateCntTest {

     @testSetup
     static void setup() {

        Plc_SystemSettings__c systemSettings = Plc_TestFactory.createSystemSettings();
        insert systemSettings;
        //Init process click data
        Plc_TestFactory.initProcessClickPackage();
        //Creating a new Account and Dealer
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c dummyDealer = Plc_TestFactory.createDealer('dummyDealer', account,'TestDummy');
        dummyDealer.Plc_Repairer__c = true;
        insert dummyDealer;

        Bit2Shop__Dealer__c dealer1 = Plc_TestFactory.createDealer('dealerTest1', account,'Test1');
        dealer1.Plc_Repairer__c = true;
        insert dealer1;

        User testUser = Plc_TestFactory.createUser('ad', 'Costruttore');
        insert testUser;

        Bit2Shop__Dealer__c dealerNew = Plc_TestFactory.createDealer('dealerNew', account,'Test00');
        dealerNew.OwnerId= testUser.Id;
        dealerNew.Plc_Repairer__c = true;
        insert dealerNew ;

        Bit2Shop__Dealer__c dealer2 = Plc_TestFactory.createDealer('dealerTest2', account,'Test2');
        dealer2.Plc_Repairer__c = true;
        insert dealer2;

        Bit2Shop__Warehouse__c dummyWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Repaired','Nexi','000000NEXI',dummyDealer);
        dummyWarehouse.Plc_CoverageIndex__c = 1;//000001NEXI
        dummyWarehouse.Plc_UniqueKey__c = 'code';
        insert dummyWarehouse;

        //Creating a new Warehouse
        Bit2Shop__Warehouse__c warehouse = Plc_TestFactory.createWarehouse('WarehouseTest','Repaired','Nexi','000001NEXI',dealer1);
        warehouse.Plc_CoverageIndex__c = 1;//000001NEXI
        warehouse.Plc_UniqueKey__c = '0002523';
        insert warehouse;

         //Creating a new Warehouse
        Bit2Shop__Warehouse__c warehouse2 = Plc_TestFactory.createWarehouse('WarehouseTest2','Repaired','Nexi','0000NX0',dealer2);
        warehouse2.Plc_UniqueKey__c = '0002524';
        insert warehouse2;
         
         //Creating a new Warehouse
        Bit2Shop__Warehouse__c warehouseNew = Plc_TestFactory.createWarehouse('warehouseNew','Repaired','Nexi','0000NX00',dealerNew);
        warehouseNew.Plc_UniqueKey__c = '00025240';
        insert warehouseNew;

        //Creating a new External Catalog and an Item
        B2WExtCat__External_Catalog__c catalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert catalog;
        
        B2WExtCat__External_Catalog_Item__c model = new B2WExtCat__External_Catalog_Item__c();
        model.B2WExtCat__External_Catalog_Item_Name__c = 'Test';
        model.Bit2Shop__Product_SKU__c = 'testSKU';
        model.B2WExtCat__Type__c = 'Process';
        model.B2WExtCat__External_Catalog__c = catalog.Id;
        insert model;

        //Creating a new Product Stock
        Bit2Shop__Product_Stock__c productStock = Plc_TestFactory.createProductStock(model, warehouse);
        productStock.Plc_UsableQty__c=5;
        productStock.Plc_WithdrawnQty__c=3;
        insert productStock;

        Bit2Shop__Stock_Serials2__c newStockSerial = new Bit2Shop__Stock_Serials2__c();
        newStockSerial.Bit2Shop__Product_Stock_Id__c = productStock.Id;
        newStockSerial.Bit2Shop__Warehouse_Id__c = warehouseNew.Id;
        insert newStockSerial;

        Bit2Shop__Stock_Serials2__c stockSerial2 = new Bit2Shop__Stock_Serials2__c();
        stockSerial2.Bit2Shop__Product_Stock_Id__c = productStock.Id;
        stockSerial2.Bit2Shop__Warehouse_Id__c = warehouse.Id;
        insert stockSerial2;

        Bit2Shop__Stock_Action__c stockAction = new Bit2Shop__Stock_Action__c(Plc_Alias__c='10230',Bit2Shop__Action_Code__c='0003111');
        insert stockAction;

        /******************************  Bit2Shop__TransferDetail__c CREATION   ****************************************/
        
         Bit2Shop__TransferDetail__c transferDet = new Bit2Shop__TransferDetail__c();

         transferDet.Bit2Shop__Code__c                       =   'CORREZ';
         transferDet.Bit2Shop__Transfer_Type__c              =   'Stock2OtherShop';
         transferDet.Plc_Alias__c                            =   '000001NEXI';
         transferDet.Plc_AvailableForProfiles__c             =   'Operation';
         transferDet.Plc_DestinationWarehouseStockAction__c  =   stockAction.Id;
         transferDet.Plc_FilterDestinationWarehouse__c       =   'New';
         transferDet.Plc_FilterOriginWarehouse__c            =   'Repaired';
         transferDet.Plc_FilterSerialStatus__c               =   'New';
         transferDet.Plc_SourceWarehouseStockAction__c       =   stockAction.Id;
         transferDet.Plc_StockGrouping__c                    =   'Causale1';
         insert transferDet; 

        /******************************  Bit2Shop__Dealer_User__c CREATION *********************************************/ 
        
        Bit2Shop__Dealer_User__c dealerUser = new Bit2Shop__Dealer_User__c( Bit2Shop__User_Id__c =  UserInfo.getUserId(),Plc_Alias__c ='0000NEXI',Bit2Shop__Dealer_Id__c = dealer1.Id);
        insert dealerUser;

     }

     @isTest
     static void retrieveTranslationMapTestOk() {
        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialUpdateCnt.retrieveTranslationMap();
        //Stopping test
        Test.stopTest();
        System.assert(response != null);
     }

     @isTest
     static void retrievePropertiesMapTestOk() {

        List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id
                                                             FROM Bit2Shop__Stock_Serials2__c
                                                             LIMIT 1];
        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialUpdateCnt.retrievePropertiesMap(stockSerialList.get(0).Id);
        //Stopping test
        Test.stopTest();                                         
        System.assert(response.get('error') == false);
     }

     @isTest
     static void updateStockSerialTestOk() {
        List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id, Name, Bit2Shop__Status__c, 
                                                                    Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                                                                    Plc_Status2__c, Bit2Shop__Warehouse_Id__c
                                                             FROM Bit2Shop__Stock_Serials2__c
                                                             ];
        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialUpdateCnt.updateStockSerial(stockSerialList.get(0), 
                                       '' + stockSerialList.get(0).Bit2Shop__Warehouse_Id__c,
                                       '' + stockSerialList.get(0).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                                       'NewModelName',
                                       stockSerialList.get(0).Bit2Shop__Status__c,
                                       stockSerialList.get(0).Plc_Status2__c);
        //Stopping test
        Test.stopTest();                                         
        System.assert(response.get('error') == false);

     }

     @isTest
     static void updateStockSerialTestMissingProductStockOk() {
        List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id, Name, Bit2Shop__Status__c, 
                                                                    Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                                                                    Plc_Status2__c, Bit2Shop__Warehouse_Id__c
                                                             FROM Bit2Shop__Stock_Serials2__c];

        List<Bit2Shop__Warehouse__c> warehousesList = [SELECT Id
                                                       FROM Bit2Shop__Warehouse__c
                                                       WHERE Name = 'WarehouseTest2'];
        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialUpdateCnt.updateStockSerial(stockSerialList.get(0), 
                                       '' + warehousesList.get(0).Id,
                                       '' + stockSerialList.get(0).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                                       'NewModelName',
                                       stockSerialList.get(0).Bit2Shop__Status__c,
                                       stockSerialList.get(0).Plc_Status2__c);
     
        //StockSerials2 with different warehouse's dealer owner. Line 275
        Map<String, Object> response2 = Plc_StockSerialUpdateCnt.updateStockSerial(stockSerialList.get(1), 
                                       '' + warehousesList.get(0).Id,
                                       '' + stockSerialList.get(0).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                                       'NewModelName',
                                       stockSerialList.get(0).Bit2Shop__Status__c,
                                       stockSerialList.get(0).Plc_Status2__c);
        //Stopping test
        Test.stopTest();                                         
        System.assert(response.get('error') == false);

     }
}