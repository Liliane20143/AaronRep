/**
* @author Abdoulaye & Moussa
* @date Creation 14/12/2018
* @version 1.0
* @description Test of PLC BatchManagerServiceTest.
*/

@isTest
public class Plc_BatchManagerServiceTest {
    
    @TestSetup
    static void makeData(){
        wrts_prcgvr__AsyncJob__c asyncJob = new wrts_prcgvr__AsyncJob__c();
        asyncJob.wrts_prcgvr__ApexClassName__c = 'Name';
        insert asyncJob;

        Plc_SystemSettings__c setting = new Plc_SystemSettings__c(Name = 'Purchase Warranty Months Delay', 
                                                                  Plc_DaysForCalculatingConsumption__c = 1,
                                                                    Plc_PurchaseWarrantyMonthsDelay__c = 2);
        insert setting;
        
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
     * @author Abdoulaye & Moussa
     * @date Creation 14/12/2018
     * @version 1.0
     * @description Test of the method  executeBatch.
     */
    @isTest
    static void executeBatchTest(){
        Test.startTest();
        //plc_test
        Plc_BatchManagerService.executeBatch('Plc_GetAvailableQtyJob');
        // try to trig an exception
        try {
            Plc_BatchManagerService.executeBatch('test');
        } catch(Exception e) {
            System.debug('exception message '+ e.getMessage());
        }
        
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 14/12/2018
    * @modify at 11/02/2019 by Mame Diarra 
    * @version 1.0
    * @description Test of the method  abortCurrentJob.
    */
    @isTest
    static void abortCurrentJobTest(){
        List<wrts_prcgvr__AsyncJob__c> asyncApexJobs = [SELECT Id FROM wrts_prcgvr__AsyncJob__c ];
        List<String> jobIds = new List<String>();
        //jobIds.add(''+asyncApexJobs[0].Id);
        Test.startTest();
        Plc_BatchManagerService.abortCurrentJob(jobIds);
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 14/12/2018
    * @version 1.0
    * @description Test of the method  getBatchQueryLimit.
    */
    @isTest
    static void getBatchQueryLimitTest(){
        
        Test.startTest();
        Plc_BatchManagerService.getBatchQueryLimit('Plc_GetAvailableQtyBtc');
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 14/12/2018
    * @version 1.0
    * @description Test of the method  scheduleNextBatchs.
    */
    @isTest
    static void scheduleNextBatchsTest(){
        
        Test.startTest();
        Plc_BatchManagerService.scheduleNextBatchs('Plc_GetAvailableQtyJob',true);
        Test.stopTest();
    }
    
}