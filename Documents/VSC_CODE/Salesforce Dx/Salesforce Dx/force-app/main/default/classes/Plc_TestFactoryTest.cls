/**
 * @author Shahid Khan
 * @date Creation 14/03/2019
 * @version 1.0
 * @description Test of PLC Plc_TestFactory.
 */
@isTest
public class Plc_TestFactoryTest {

    /**
     * @author FB
     * @date Creation 22/03/2019
     * @version 1.0
     * @description Test of creation warehouse, dealer, external catalog, external catalog item, stock serial, ecc..
     */
    @isTest
    static void createFullChainTest() {  

        Account account = Plc_TestFactory.createAccountSupplier('test account');
        Contact contact = Plc_TestFactory.createContactGeneric('test contact');
        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('dealerParent', account, 'aliasParent');
        Bit2Shop__Dealer__c childDealer = Plc_TestFactory.createDealerChild('dealerChild', account, 'aliasChild', parentDealer);
        Bit2Shop__Warehouse__c warehouse = Plc_TestFactory.createWarehouse('warehouseChild', 'Nexi', 'Installed', 'warehouseAlias', childDealer);
        B2WExtCat__External_Catalog__c extCatalog = Plc_TestFactory.createExtCatalog('ExtCatalog');
        B2WExtCat__External_Catalog_Item__c extCatalogItem = Plc_TestFactory.createExtCatalogItem('extCatalogItem', extCatalog, 'sku', 'item');
        Bit2Shop__Product_Stock__c productStock = Plc_TestFactory.createProductStock(extCatalogItem, warehouse);
        Bit2Shop__Stock_Serials2__c stockSerial = Plc_TestFactory.createStockSerial2(warehouse, 'New');
        Plc_Solution__c solution = Plc_TestFactory.createSolution('solution');
        List<Plc_Solution__c> solutionsList = Plc_TestFactory.createSolutions(4);
        Plc_WarehouseSolution__c warehouseSolution = Plc_TestFactory.createWarehouseSolution('warehouseSolution' , solution, warehouse);
        WorkOrder workOrder = Plc_TestFactory.createWorkOrder('state', account, contact, '1', '2', '3', '4', '5', '6', '7', '8', '9', '10');
        Plc_TermId__c termId = Plc_TestFactory.createTermId('termIdCode');
        WorkOrderLineItem workOrderLineItem = Plc_TestFactory.createWorkOrderLineItem('Alias', extCatalogItem, termId, '1', '2', '3', '4', '5', '6');
        Bit2Shop__StockOrder__c stockOrder = Plc_TestFactory.createStockOrder('1', workOrder, warehouse, parentDealer, warehouse, childDealer);
        Bit2Shop__Shipment__c outboundShipment = Plc_TestFactory.createOutboundShipment(stockOrder);
        Bit2Shop__Shipment__c inboundShipment = Plc_TestFactory.createInboundShipment(stockOrder);
        Bit2Shop__Shipment_Line_Item__c shipmentLineItem = Plc_TestFactory.createShipmentLineItem(Plc_Constants.B2S_ShipmentLineItem.RecordType_Product,
                                                                                                  Date.today(), productStock, inboundShipment, 1, 'Pending');
    }

    /**
     * @author FB
     * @date Creation 22/03/2019
     * @version 1.0
     * @description Test of createSystemSettings
     */
    @isTest
    static void createSystemSettingsTest() {  
       Plc_TestFactory.createSystemSettings();
    }

    /**
     * @author FB
     * @date Creation 04/04/2019
     * @version 1.0
     * @description Test of createProcessSettings
     */
    @isTest
    static void createProcessSettingsTest() {  
       Plc_TestFactory.createProcessSettings();
    }

    /**
     * @author FB
     * @date Creation 04/04/2019
     * @version 1.0
     * @description Test of createWarehouseFake
     */
    @isTest
    static void createWarehouseFakeTest() {  
       Plc_TestFactory.createWarehouseFake();
    }

    /**
     * @author FB
     * @date Creation 04/04/2019
     * @version 1.0
     * @description Test of initProcessClickPackage
     */
    @isTest
    static void initProcessClickPackageTest() {  
       Plc_TestFactory.initProcessClickPackage();
    }

    /**
     * @author CM
     * @date Creation 05/08/2019
     * @version 1.0
     * @description Test of newPhaseTrans
     */
    @isTest
    static void newPhaseTransTest() {  
       Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'Withdrawn', 'Installed');
    }

    /**
     * @author FB
     * @date Creation 04/04/2019
     * @version 1.0
     * @description Test of createUser
     */
    @isTest
    static void createUserTest() {  
       Plc_TestFactory.createUser('test', 'Magazziniere');
    }
}