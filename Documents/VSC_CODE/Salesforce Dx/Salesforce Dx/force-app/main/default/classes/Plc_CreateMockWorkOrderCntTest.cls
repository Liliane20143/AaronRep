/**
 * @author FB
 * @date Creation 19/08/2019
 * @version 1.0
 *
 * @description Test of Plc_CreateMockWorkOrderCnt.
 */
@isTest
public class Plc_CreateMockWorkOrderCntTest {

    @testSetup
    static void setup() {
        
        Plc_TestFactory.initProcessClickPackage();

        insert Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'Available', 'Withdrawn');
        insert Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'To Be Verified', 'Available');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', 'Installation', 'Assigned', 'Closed');

        Plc_TestFactory.createWarehouseFake();

        Plc_WorkOrderConfiguration__c WorkOrderConf = new Plc_WorkOrderConfiguration__c (
            Plc_IntegrationName__c = 'Installation',
            Plc_EligibleOperationTypes__c = 'ToInstall',
            Plc_NeedsCalculation__c = true,
            Plc_NeedsReservation__c = true
        );

        insert WorkOrderConf;

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

        Plc_TermId__c termId = new Plc_TermId__c();
        termId.Plc_TermIdCode__c = '12345';
        insert termId;

        //Creating a new Product Stock
        Bit2Shop__Product_Stock__c productStock = new Bit2Shop__Product_Stock__c();
        productStock.Bit2Shop__External_Catalog_Item_Id__c = model.Id;
        productStock.Bit2Shop__Warehouse_Id__c = warehouse1.Id;
        productStock.Plc_UsableQty__c = 5;
        productStock.Plc_WithdrawnQty__c = 3;
        insert productStock;

        Bit2Shop__Stock_Serials2__c stockSerialAvailable = new Bit2Shop__Stock_Serials2__c();
        stockSerialAvailable.Bit2Shop__Warehouse_Id__c= warehouse1.Id;
        stockSerialAvailable.Plc_ManufacturerSerialNumber__c = 'TestManufacturer1';
        stockSerialAvailable.Plc_EncodedSerialNumber__c = 'TestEncoded1';
        stockSerialAvailable.Bit2Shop__Product_Stock_Id__c = productStock.Id;
        stockSerialAvailable.Bit2Shop__Status__c = 'Available';
        insert stockSerialAvailable;

        Bit2Shop__Stock_Serials2__c stockSerialToBeVerified = new Bit2Shop__Stock_Serials2__c();
        stockSerialToBeVerified.Bit2Shop__Warehouse_Id__c= warehouse1.Id;
        stockSerialToBeVerified.Plc_ManufacturerSerialNumber__c = 'TestManufacturer2';
        stockSerialToBeVerified.Plc_EncodedSerialNumber__c = 'TestEncoded2';
        stockSerialToBeVerified.Bit2Shop__Product_Stock_Id__c = productStock.Id;
        stockSerialToBeVerified.Bit2Shop__Status__c = 'To Be Verified';
        insert stockSerialToBeVerified;

    }

   /**
    * @author FB
    * @date Creation 19/08/2019
    * @version 1.0
    * @description Test of the method retrieveTranslationMap
    */
    @isTest
    static void retrieveTranslationMapTestOk() {

        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_CreateMockWorkOrderCnt.retrieveTranslationMap();
        //Stop test
        Test.stopTest();

        System.assert(response != null);
    }

   /** 
    * @author FB
    * @date Creation 19/08/2019
    * @version 1.0
    * @description Test of the method retrievePropertiesMap
    */
    @isTest
    static void retrievePropertiesMapTestOk() {
        
        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_CreateMockWorkOrderCnt.retrievePropertiesMap();
        //Stop test
        Test.stopTest();

        System.assert(response != null);
    }

   /** 
    * @author FB
    * @date Creation 19/08/2019
    * @version 1.0
    * @description Test of the method retrieveEligibleOperations
    */
    @isTest
    static void retrieveEligibleOperationsTestOk() {
        
        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_CreateMockWorkOrderCnt.retrieveEligibleOperations('Installation');
        //Stop test
        Test.stopTest();

        System.assert(response != null);
    }

   /** 
    * @author FB
    * @date Creation 20/08/2019
    * @version 1.0
    * @description Test OK of the method retrieveAvailableSerials
    */
    @isTest
    static void retrieveAvailableSerialsTestOk() {
        
        Plc_TermId__c termId = [SELECT Id FROM Plc_TermId__c LIMIT 1];
        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_CreateMockWorkOrderCnt.retrieveAvailableSerials('aliasWarehouse', '', 20, new List<String>(),
                                                                                            new List<String>{'Available'}, termId.Id);
        //Stop test
        Test.stopTest();

        System.assert(response != null);
    }

   /** 
    * @author FB
    * @date Creation 20/08/2019
    * @version 1.0
    * @description Test KO of the method retrieveAvailableSerials
    */
    @isTest
    static void retrieveAvailableSerialsTestKo() {
        
        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_CreateMockWorkOrderCnt.retrieveAvailableSerials('aliasWarehouse', '', 20, new List<String>(),
                                                                                            new List<String>{'Available'}, 'termId');
        //Stop test
        Test.stopTest();

        System.assert(response != null);
    }

   /** 
    * @author FB
    * @date Creation 20/08/2019
    * @version 1.0
    * @description Test of the method createWorkOrder
    */
    @isTest
    static void createWorkOrderTestOk() {
        
        //Work Order wrapper
        Map<String, String> workOrderWrp = new Map<String, String> {
            'Plc_Vat__c' => 'Vat'
        };

        Bit2Shop__Warehouse__c warehouse = [SELECT Id, Name, Plc_Alias__c 
                                            FROM Bit2Shop__Warehouse__c
                                            WHERE Plc_Alias__c = 'aliasWarehouse'];

        List<Bit2Shop__Stock_Serials2__c> stockSerialsList = [SELECT Id, Bit2Shop__Status__c,
                                                                     Bit2Shop__Product_Stock_Id__c,
                                                                     Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c
                                                              FROM Bit2Shop__Stock_Serials2__c];
        
        String woliAsString = '[{' 
            + '"serialId":"' + stockSerialsList[0].Id +'",'
            + '"serialStatus":"' + stockSerialsList[0].Bit2Shop__Status__c +'",'
            + '"productStockId":"' + stockSerialsList[0].Bit2Shop__Product_Stock_Id__c +'",'
            + '"externalCatalogItemId":"' + stockSerialsList[0].Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c +'",'
            + '"operationType":"ToInstall"},'
            + '{' 
            + '"serialId":"' + stockSerialsList[1].Id +'",'
            + '"serialStatus":"' + stockSerialsList[1].Bit2Shop__Status__c +'",'
            + '"productStockId":"' + stockSerialsList[1].Bit2Shop__Product_Stock_Id__c +'",'
            + '"externalCatalogItemId":"' + stockSerialsList[1].Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c +'",'
            + '"operationType":"ToInstall"}]';

        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_CreateMockWorkOrderCnt.createWorkOrder(workOrderWrp, 'Installation', warehouse, woliAsString, new List<String>{''});
        //Stop test
        Test.stopTest();

        System.assert(response != null);
    }
}