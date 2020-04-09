/**
     * @author Abdoulaye & Moussa
     * @date Creation 19/12/2018
     * @version 1.0
     * @description Test of Plc_DistributionListStatusUpdateCnt.
     */

@isTest
public class Plc_DistributionListStatusUpdateCntTest {
    
    @testSetup
    static void setup(){    
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, '12345');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;
        
        Bit2Shop__Dealer_User__c bit2ShopDealerUser=new Bit2Shop__Dealer_User__c();
        
        Plc_DistributionList__c plcDistributionList=new Plc_DistributionList__c(Plc_Alias__c='Plc_AliasTest1',Plc_Status__c='Draft');
        insert plcDistributionList;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('warehouseChild', 'Repaired', 'Nexi', 'warehouseAlias', bit2ShopDealer);
        insert bit2ShopWarehouse;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        //L.B 05/04/2019 Add Creation of ExtCatalog
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('ExtCatalogName');
        insert b2WExtCatExtCatalog;

        //B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalogItem('catalogue', extCatalog, 'sku', 'item');
        //insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('catalogue', b2WExtCatExtCatalog, 'sku', 'item');
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        insert bit2ShopProductStock;
        
        Plc_DistributionListItem__c plcDistributionListItem =new Plc_DistributionListItem__c();
        plcDistributionListItem.Plc_DistributionList__c = ''+plcDistributionList.Id;
        plcDistributionListItem.Plc_OriginDealer__c =''+bit2ShopDealer.Id;
        plcDistributionListItem.Plc_DestinationWarehouse__c = ''+bit2ShopWarehouse.Id;
        plcDistributionListItem.Plc_OriginWarehouse__c =''+bit2ShopWarehouse.Id;
        plcDistributionListItem.Plc_Product__c =''+b2wExtCatExtCat.Id;
        plcDistributionListItem.Plc_RequestedQty__c=5;
        insert plcDistributionListItem;
        
    }
    
    /**
      * @author Abdoulaye & Moussa
      * @date Creation 19/12/2018
      * @version 1.0
      * @description Test of the method updateStatus.
      */
    @isTest
    static void updateStatusTest(){
        
        Plc_DistributionList__c distList = [SELECT Id, Plc_Status__c FROM Plc_DistributionList__c LIMIT 1];
        
        List<Plc_DistributionListItem__c> dliListItem = [SELECT Id, Plc_Product__c, Plc_RequestedQty__c,Plc_OriginWarehouse__c,Plc_DestinationWarehouse__c 
                                                     FROM Plc_DistributionListItem__c 
                                                     WHERE Plc_DistributionList__c = :distList.Id];

        Test.startTest();
        
        Plc_DistributionListStatusUpdateCnt.updateStatus(distList.Id);
        //Plc_DistributionListStatusUpdateCnt.updateStatus(null);
        
        Test.stopTest();
    }  
    
    /**
      * @author Mame Diarra
      * @date Creation 25/12/2018
      * @version 1.0
      * @description Test of the method updateStatus and Plc_Status__c equals Closed.
      */
    @isTest
    static void updateStatusToClosedTest(){
        
        Plc_DistributionList__c distList = [SELECT Id, Plc_Status__c FROM Plc_DistributionList__c LIMIT 1];
        distList.Plc_Status__c='Closed';
        update distList;
        List<Plc_DistributionListItem__c> dliListItem = [SELECT Id, Plc_Product__c, Plc_RequestedQty__c,Plc_OriginWarehouse__c,Plc_DestinationWarehouse__c 
                                                     FROM Plc_DistributionListItem__c 
                                                     WHERE Plc_DistributionList__c = :distList.Id];
        Test.startTest();
        Plc_DistributionListStatusUpdateCnt.updateStatus(distList.Id);
        Test.stopTest();
    }  

    /**
      * @author Mame Diarra
      * @date Creation 25/12/2018
      * @version 1.0
      * @description Test of the method updateStatus and Plc_Status__c equals Requested.
      */
    @isTest
    static void updateStatusToRequestedTest(){
        
        Plc_DistributionList__c distList = [SELECT Id, Plc_Status__c FROM Plc_DistributionList__c LIMIT 1];
        distList.Plc_Status__c='Requested';
        update distList;
        List<Plc_DistributionListItem__c> dliListItem = [SELECT Id, Plc_Product__c, Plc_RequestedQty__c,Plc_OriginWarehouse__c,Plc_DestinationWarehouse__c 
                                                     FROM Plc_DistributionListItem__c 
                                                     WHERE Plc_DistributionList__c = :distList.Id];
        Test.startTest();
        Plc_DistributionListStatusUpdateCnt.updateStatus(distList.Id);
        Test.stopTest();
    }  

    /**
      * @author Mame Diarra
      * @date Creation 25/12/2018
      * @version 1.0
      * @description Test exception of the method updateStatus.
      */
    @isTest
    static void updateStatusKOTest() {      
        Plc_DistributionListItem__c distList = [SELECT Id, Plc_Status__c FROM Plc_DistributionListItem__c LIMIT 1];
        Test.startTest();
        Plc_DistributionListStatusUpdateCnt.updateStatus(distList.Id);
        Test.stopTest();
    }  


    
}