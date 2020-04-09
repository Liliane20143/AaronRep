/**
 * @author Emanuele Campese 
 * @date Creation 27//12/2018
 * @Modify 19/02/2019 by Mame Diarra
 * @description Test class for Plc_WarehouseSolutionConsumedQtyBtc.
 */
@isTest
public class Plc_WarehouseSolutionConsumedQtyBtcTest {

    
    @testSetup
    static void setup(){
       
        insert new Plc_SystemSettings__c(Name = 'SystemSettings',
               Plc_DaysForCalculatingConsumption__c = 30,
               Plc_PurchaseWarrantyMonthsDelay__c   = 5
        );
        Id inboundRecordTypeId = Plc_Utils.getRecordTypeId('Inbound_Shipment', 'Bit2Shop__Shipment__c');
        Id serialRecordTypeId = Plc_Utils.getRecordTypeId('Shipment_Line_Item_Serial', 'Bit2Shop__Shipment_Line_Item__c');

        Plc_Solution__c plcSolution = new Plc_Solution__c();
        insert plcSolution;

        List<Plc_Solution__c> solutions = Plc_TestFactory.createSolutions(4);
        insert solutions;
        
        B2WExtCat__External_Catalog__c catalog = new B2WExtCat__External_Catalog__c();
        catalog.B2WExtCat__External_Catalog_Name__c='Principale';
        insert catalog;

        List<B2WExtCat__External_Catalog_Item__c> externalCatItemList = new List<B2WExtCat__External_Catalog_Item__c>();
        B2WExtCat__External_Catalog_Item__c externalCatItem1 = Plc_TestFactory.createExtCatalogItem('POS001', catalog, 'sku', 'extCatItemType');
        externalCatItem1.Plc_Alias__c = 'alias1';
        externalCatItem1.Bit2Shop__Required_Serial__c = false;
        externalCatItemList.add(externalCatItem1);

        B2WExtCat__External_Catalog_Item__c externalCatItem2 = Plc_TestFactory.createExtCatalogItem('POS001', catalog, 'sku', 'extCatItemType');
        externalCatItem2.Plc_Alias__c = 'alias1';
        externalCatItem2.Bit2Shop__Required_Serial__c = false;

        insert externalCatItemList;
        
        //Plc_Solution__c=a2l1j0000008aWfAAI
        System.debug('==Bit2Shop__External_Catalog== '+externalCatItem1);
        
        Account account =   Plc_TestFactory.createAccountSupplier('Account');
        //account.name    =   'Account';
        insert account;
        
        Contact contact     =   Plc_TestFactory.createContactGeneric('LastName');
        contact.Account     =   account;
        //contact.LastName    =   'LastName';
        insert contact;

        Bit2Shop__Dealer__c dealerParent = Plc_TestFactory.createDealerParent('name',  account, 'test');
        insert dealerParent;

        Bit2Shop__Dealer__c dealerInstallati = Plc_TestFactory.createDealerChild('name', account, 'Installati', dealerParent);
        dealerInstallati.Bit2Shop__Approver_Group_Id__c = 'dealer';
        dealerInstallati.Plc_Repairer__c = true;
        insert dealerInstallati;

        Bit2Shop__Warehouse__c wareHouseInstallati1 = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Repaired', '',
                'Alias1', dealerInstallati);
        wareHouseInstallati1.Plc_UniqueKey__c= 'UniqueKey1';
        insert wareHouseInstallati1;
        
        Bit2Shop__Dealer__c dealer = Plc_TestFactory.createDealer('name', account,  'Nestle');
        dealer.Plc_Scrapyard__c=false;
        dealer.Plc_Repairer__c=false;
        dealer.Plc_Manufacturer__c=false;
        dealer.Plc_Maintainer__c=false;
        insert dealer;
        //getBit2ShopDealerAlias('Nestle',account);

        Bit2Shop__Dealer__c dealer2 = Plc_TestFactory.createDealer('name2', account,  'Nexi');
        dealer2.Plc_Scrapyard__c=false;
        dealer2.Plc_Repairer__c=false;
        dealer2.Plc_Manufacturer__c=false;
        dealer2.Plc_Maintainer__c=false;
        insert dealer2;

        Bit2Shop__Warehouse__c wareHouse1 = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Installed', '', 'Alias2', dealer);
        insert wareHouse1;

        Bit2Shop__Warehouse__c wareHouse2 = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Installed', '', 'Alias3', dealer2);
        insert wareHouse2;

        Plc_WarehouseProvince__c provWareHouse1AG = new Plc_WarehouseProvince__c();
        provWareHouse1AG.Plc_Warehouse__c               =   wareHouse1.Id;
        provWareHouse1AG.Plc_Province__c                =   'AG';
        provWareHouse1AG.Plc_DistributionPercentage__c  =   100;
        insert provWareHouse1AG;

        Plc_WarehouseProvince__c provWareHouse1OR = new Plc_WarehouseProvince__c();
        provWareHouse1OR.Plc_Warehouse__c               =   wareHouse1.Id;
        provWareHouse1OR.Plc_Province__c                =   'OR';
        provWareHouse1OR.Plc_DistributionPercentage__c  =   100;
        insert provWareHouse1OR;
        
        List<Bit2Shop__Product_Stock__c> productStockitemList = new List<Bit2Shop__Product_Stock__c>();

        Bit2Shop__Product_Stock__c productStockItem = Plc_TestFactory.createProductStock( externalCatItem1, wareHouse1);
        productStockItem.Plc_UsableQty__c = 100;
        productStockItem.Plc_WithdrawnQty__c = 50;
        productStockItem.Plc_OrderedQty__c=0;

        Bit2Shop__Product_Stock__c productStockItem2 = Plc_TestFactory.createProductStock(externalCatItem2, wareHouse1);
        productStockItem2.Plc_UsableQty__c = 100;
        productStockItem2.Plc_WithdrawnQty__c = 50;
        productStockItem2.Plc_OrderedQty__c=0;

        productStockitemList.add(productStockItem);
        productStockitemList.add(productStockItem2);
        insert productStockitemList;
        
        List<Plc_WarehouseSolution__c> wareHouseSolutionList = new List<Plc_WarehouseSolution__c>();

        Plc_WarehouseSolution__c wareHouseSolution1 = Plc_TestFactory.createWarehouseSolution('name', solutions[0], wareHouse1);
        wareHouseSolution1.Plc_ConsumedExecutionDate__c =   Datetime.newInstance(2000, 00, 00, 00, 00, 00);
        wareHouseSolution1.Plc_ConsumedQty__c           =   0;
        wareHouseSolution1.Plc_Alias__c = 'Alias1';

        Plc_WarehouseSolution__c wareHouseSolution2 = Plc_TestFactory.createWarehouseSolution('name2', solutions[0], wareHouse1);
        wareHouseSolution2.Plc_ConsumedExecutionDate__c =   Datetime.newInstance(2000, 00, 00, 00, 00, 00);
        wareHouseSolution2.Plc_ConsumedQty__c           =   0;
        wareHouseSolution1.Plc_Alias__c = 'Alias2';

        wareHouseSolutionList.add(wareHouseSolution2);
        wareHouseSolutionList.add(wareHouseSolution1);
        insert wareHouseSolutionList;
        
        List<Plc_SolutionProvince__c> plcSolutionProvinces = new List<Plc_SolutionProvince__c>();
        
        Plc_SolutionProvince__c plcSolutionProvince =   new Plc_SolutionProvince__c();
        plcSolutionProvince.Plc_Province__c =   'AG'; 
        plcSolutionProvince.Plc_Quantity__c =   2;
        plcSolutionProvince.Plc_Solution__c =   solutions[0].Id;
        plcSolutionProvinces.add(plcSolutionProvince);
        
        Plc_SolutionProvince__c plcSolutionProvince2    =   new Plc_SolutionProvince__c();
        plcSolutionProvince2.Plc_Province__c    =   'AG'; 
        plcSolutionProvince2.Plc_Quantity__c    =   0;
        plcSolutionProvince2.Plc_Solution__c    =   solutions[0].Id;
        //plcSolutionProvinces.add(plcSolutionProvince2);
        
        insert plcSolutionProvinces;
        
        Plc_WorkOrderConfiguration__c workOrderSettings = new Plc_WorkOrderConfiguration__c();
        workOrderSettings.Plc_NeedsCalculation__c       =   true;
        workOrderSettings.Name                          =   'Installation';
        workOrderSettings.Plc_EligibleOperationTypes__c =   'ToInstall';
        workOrderSettings.Plc_IntegrationName__c        =   'Plc_IntegrationName'; // review
        insert workOrderSettings;

        WorkOrder workOrder1        =   Plc_TestFactory.createWorkOrder('AG', account, contact, '1','2','3','4','5','6','7','8','9','10');
        workOrder1.RecordTypeId     =   Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        workOrder1.Status           =   'Closed';
        insert workOrder1;
        
        WorkOrder workOrder2        =   Plc_TestFactory.createWorkOrder('OR',account,contact,'1','2','3','4','5','6','7','8','9','10');
        workOrder2.RecordTypeId     =   Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        workOrder2.Status           =   'Closed';
        insert workOrder2;

        Bit2Shop__StockOrder__c wareHouse1toNexi = Plc_TestFactory.createStockOrder('Stock2OtherShop', workOrder1,
                wareHouse1, dealer, wareHouseInstallati1, dealerInstallati);
        insert wareHouse1toNexi;

        Bit2Shop__StockOrder__c wareHouse2toNexi = Plc_TestFactory.createStockOrder('Stock2OtherShop', workOrder2,
                wareHouseInstallati1, dealerInstallati, wareHouse2, dealer2);
        insert wareHouse2toNexi;

        Bit2Shop__Shipment__c shipInbound1 = Plc_TestFactory.createInboundShipment(wareHouse1toNexi);
        shipInbound1.Bit2Shop__Shipment_Document_Number__c='DDM1';
        insert shipInbound1;

        Bit2Shop__Shipment__c shipInbound2 = Plc_TestFactory.createInboundShipment(wareHouse2toNexi);
        shipInbound2.Bit2Shop__Shipment_Document_Number__c='DDM1';
        insert shipInbound2;
        
        //Create at least 200 rows for insertion to activate Batch
        List<Bit2Shop__Shipment_Line_Item__c> shipLineItemList = new List<Bit2Shop__Shipment_Line_Item__c>();

        for(Integer i=0 ; i<200; i++){
            Bit2Shop__Shipment_Line_Item__c shipLineItem = Plc_TestFactory.createShipmentLineItem('Shipment_Line_Item_Serial', Date.today(), productStockItem,
                    shipInbound1, i, 'OK '+i);
            shipLineItem.Plc_HandlingStatusDate__c = Datetime.Now();
            shipLineItemList.add(shipLineItem);
        }

        for(Integer i=0 ; i<200; i++){
            Bit2Shop__Shipment_Line_Item__c shipLineItem2 = Plc_TestFactory.createShipmentLineItem('Shipment_Line_Item_Serial', Date.today(), productStockItem,
                    shipInbound2, i, 'OK '+i);
            shipLineItem2.Plc_HandlingStatusDate__c = Datetime.Now();
            shipLineItemList.add(shipLineItem2);
        }

        insert shipLineItemList;
    }
    
    /**
     * @author Moussa Fofana
     * @date Creation 12/02/2019
     * @Modify 01/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test Batch Execution
     */
    @isTest
    static void executeBatchTest(){
        
        
        //Start Test
        Test.startTest();
            Plc_BatchManagerService.executeBatch ('Plc_WarehouseSolutionConsumedQtyJob');
            /*whouseSolutionConsQty.execute(null,shipLineItemList);
            whouseSolutionConsQty.Finish(null);*/
        Test.stopTest();
        //end Test
    }
}