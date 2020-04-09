/**
 * @author Abdoulaye DIOP
 * @date Creation 19/03/2019
 * @description Plc_GetAvailableQtyJobTest - test of the Schedulable class for Batch 'Plc_GetAvailableQtyJob'.
 */
@isTest
public class Plc_GetAvailableQtyJobTest {
	
    @testSetup
    static void setup(){
        
        List<Plc_Solution__c> solutions = Plc_TestFactory.createSolutions(4);
        insert solutions;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        B2WExtCat__External_Catalog__c catalog = new B2WExtCat__External_Catalog__c();
        catalog.B2WExtCat__External_Catalog_Name__c = 'Principale';
        insert catalog;

        List<B2WExtCat__External_Catalog_Item__c> externalCatItemList = new List<B2WExtCat__External_Catalog_Item__c>();
        B2WExtCat__External_Catalog_Item__c externalCatItem1 = Plc_TestFactory.createExtCatalogItem('POS001',catalog,'test','type');
        B2WExtCat__External_Catalog_Item__c externalCatItem2 = Plc_TestFactory.createExtCatalogItem('POS002',catalog,'test2','type');
        externalCatItem1.Plc_Solution__c = solutions[0].Id;
        externalCatItem2.Plc_Solution__c = solutions[1].Id;
        externalCatItemList.add(externalCatItem1);
        externalCatItemList.add(externalCatItem2);
        insert externalCatItemList;
        
        System.debug('==Bit2Shop__External_Catalog== ' + externalCatItem1);
        
        Account account = Plc_TestFactory.createAccountSupplier('Account');
        insert account;
        
        Contact contact = Plc_TestFactory.createContactGeneric('LastName');
        contact.Account = account;
        insert contact;

        Bit2Shop__Dealer__c dealerInstallati = Plc_TestFactory.createDealer('Installati', account, 'New');
        dealerInstallati.Plc_Manufacturer__c = TRUE;
        insert dealerInstallati;
        
        Bit2Shop__Warehouse__c wareHouseInstallati1 = Plc_TestFactory.createWarehouse('w1', 'New', '', 'Alias1', dealerInstallati);
        wareHouseInstallati1.Plc_UniqueKey__c = 'UniqueKey1';
        insert wareHouseInstallati1;

        Bit2Shop__Dealer__c dealer = Plc_TestFactory.createDealer('Nestle', account, 'test');
        dealer.Plc_Maintainer__c = true;
        insert dealer;

        Bit2Shop__Warehouse__c warehouse1 = Plc_TestFactory.createWarehouse('w1', 'Generic', '', 'Alias2', dealer);
        warehouse1.Plc_UniqueKey__c = 'UniqueKey2';
        insert warehouse1;
        
        Plc_WarehouseProvince__c provWareHouse1AG = new Plc_WarehouseProvince__c();
        provWareHouse1AG.Plc_Warehouse__c = wareHouse1.Id;
        provWareHouse1AG.Plc_Province__c = 'AG';
        provWareHouse1AG.Plc_DistributionPercentage__c = 100;
        insert provWareHouse1AG;

        Plc_WarehouseProvince__c provWareHouse1OR = new Plc_WarehouseProvince__c();
        provWareHouse1OR.Plc_Warehouse__c = wareHouse1.Id;
        provWareHouse1OR.Plc_Province__c = 'OR';
        provWareHouse1OR.Plc_DistributionPercentage__c = 100;
        insert provWareHouse1OR;
        
        List<Bit2Shop__Product_Stock__c> productStockitemList = new List<Bit2Shop__Product_Stock__c>();

        Bit2Shop__Product_Stock__c productStockItem = Plc_TestFactory.createProductStock(externalCatItem1, wareHouse1);
        productStockItem.Plc_UsableQty__c = 100;
        productStockItem.Plc_WithdrawnQty__c = 50;
        productStockItem.Plc_OrderedQty__c = 0;

        Bit2Shop__Product_Stock__c productStockItem2 = Plc_TestFactory.createProductStock(externalCatItem2, wareHouseInstallati1);
        productStockItem2.Plc_UsableQty__c = 100;
        productStockItem2.Plc_WithdrawnQty__c = 50;
        productStockItem2.Plc_OrderedQty__c = 0;

        Bit2Shop__Product_Stock__c productStockItem3 = Plc_TestFactory.createProductStock(externalCatItem1, wareHouseInstallati1);
        productStockItem3.Plc_UsableQty__c = 0;
        productStockItem3.Plc_WithdrawnQty__c = 0;
        productStockItem3.Plc_OrderedQty__c = 0;

        productStockitemList.add(productStockItem);
        productStockitemList.add(productStockItem2);
        productStockitemList.add(productStockItem3);
        insert productStockitemList;
        
        List<Plc_WarehouseSolution__c> wareHouseSolutionList = new List<Plc_WarehouseSolution__c>();
        Plc_WarehouseSolution__c wareHouseSolution1 = Plc_TestFactory.createWarehouseSolution('Alias1',solutions[0],wareHouse1);
        wareHouseSolution1.Plc_ConsumedExecutionDate__c = System.now().addDays(2);
        wareHouseSolution1.Plc_ConsumedQty__c = 0;
        
        Plc_WarehouseSolution__c wareHouseSolution2 = Plc_TestFactory.createWarehouseSolution('Alias2',solutions[1],wareHouse1);
        wareHouseSolution2.Plc_ConsumedQty__c = 0;
        wareHouseSolution2.Plc_ConsumedExecutionDate__c = System.now();

        wareHouseSolutionList.add(wareHouseSolution2);
        wareHouseSolutionList.add(wareHouseSolution1);
        insert wareHouseSolutionList ;
    }
    /**
     * @author Abdoulaye DIOP
     * @date Creation 19/03/2019
     * @description test of the method execute.
     */
    @isTest
    static void getAvailableQtyJobTest(){

        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new Plc_GetAvailableQtyJob());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}