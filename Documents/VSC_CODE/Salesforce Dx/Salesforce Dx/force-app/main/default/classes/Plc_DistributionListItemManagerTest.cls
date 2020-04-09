/**
 * @author Mame Diarra
 * @date Creation 05/02/2019
 * @version 1.0
 * @description Test of PLC DistributionListItemManager.
 */
 @isTest
 public class Plc_DistributionListItemManagerTest {
     
    @TestSetup
    static void setup(){

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('Parent Dealer',account,'Alias');
        insert parentDealer;

        Bit2Shop__Dealer__c childDealer = Plc_TestFactory.createDealerChild('dealer', account,'12345',parentDealer);
        insert childDealer;

        Plc_DistributionList__c plcDistributionList = new Plc_DistributionList__c(Plc_Alias__c='Plc_AliasTest1',Plc_Status__c='Draft');
        insert plcDistributionList;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('Warehouse Name','Installed','Nexi','000001NEXI',childDealer);
        insert bit2ShopWarehouse;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Cat Item Name',b2WExtCatExtCatalog, 'SKU00012', 'Process' );
        b2wExtCatExtCat.Plc_Alias__c ='00541237896541230';
        insert b2wExtCatExtCat;

        Plc_PurchaseOrder__c purchaseOrder = new Plc_PurchaseOrder__c(Plc_Status__c = 'Open', Plc_RdaNumber__c = 'Test');
        purchaseOrder.Plc_PurchaseWarrantyDuration__c = 2;
        insert purchaseOrder;

        Plc_PurchaseOrderItem__c purchaseOrderItem = new Plc_PurchaseOrderItem__c(
            Plc_Alias__c = 'PlcPurchaseOrderItemTest1',
            Plc_PurchaseOrder__c = purchaseOrder.Id,
            Plc_Model__c = b2wExtCatExtCat.Id,
            Plc_Quantity__c = 35,
            Plc_UnitPrice__c = 100,
            Plc_OrderedQty__c = 2

        );
        insert purchaseOrderItem;

        Plc_DistributionListItem__c plcDistributionListItem = new Plc_DistributionListItem__c();
        plcDistributionListItem.Plc_DistributionList__c = plcDistributionList.Id;
        plcDistributionListItem.Plc_OriginDealer__c = childDealer.Id;
        plcDistributionListItem.Plc_DestinationWarehouse__c = bit2ShopWarehouse.Id;
        plcDistributionListItem.Plc_Product__c = b2wExtCatExtCat.Id;
        plcDistributionListItem.Plc_RequestedQty__c = 5;
        plcDistributionListItem.Plc_Status__c = 'Requested';
        plcDistributionListItem.Plc_PurchaseOrder__c = purchaseOrder.Id;
        insert plcDistributionListItem;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;
    }
     
    /**
    * @author Mame Diarra
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test of the method manageUpdateOperation.
    */
    @isTest
    static void manageUpdateOperationTest(){ 
        Plc_DistributionListItem__c plcDistributionListItem = [SELECT Id, Plc_DestinationWarehouse__c, Plc_Product__c, Plc_RequestedQty__c,
                                                                      Plc_Status__c, Plc_PurchaseOrder__c
                                                               FROM Plc_DistributionListItem__c];
        Plc_DistributionListItem__c plcDistributionListItemOldClone = plcDistributionListItem.clone();

        Map<Id, SObject> newItems = new Map<Id, SObject>();
        newItems.put(plcDistributionListItem.Id, plcDistributionListItem);
        Map<Id, SObject> oldItems = new Map<Id, SObject>();
        plcDistributionListItemOldClone.Plc_Status__c = 'Draft';
        oldItems.put(plcDistributionListItem.Id, plcDistributionListItemOldClone);
        //Start test
        Test.startTest();
        Plc_DistributionListItemManager.manageUpdateOperation(newItems,oldItems);
        //Stop test
        Test.stopTest();
    }
}