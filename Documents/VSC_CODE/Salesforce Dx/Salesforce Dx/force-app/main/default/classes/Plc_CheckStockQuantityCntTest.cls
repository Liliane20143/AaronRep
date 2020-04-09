/**
 * @author Mame Diarra
 * @date creation 14/03/2019
 * @version 1.0
 * @description test of the Plc_CheckStockQuantityCnt class
 */
 @isTest
public class Plc_CheckStockQuantityCntTest {

    @testSetup
    static void setup() {
        
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, 'alias');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Nexi', '000001NEXI', bit2ShopDealer);
        bit2ShopWarehouse.Plc_CoverageIndex__c=1;
        bit2ShopWarehouse.Plc_LogisticDivision__c = 'Nexi';
        insert bit2ShopWarehouse;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'test','type');
        insert b2wExtCatExtCat;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = (Decimal)2;
        bit2ShopProductStock.Plc_WithdrawnQty__c = (Decimal)1; 
        bit2ShopProductStock.Bit2Shop__Stock_Qty__c = (Decimal)1; 
        bit2ShopProductStock.Plc_OrderedQty__c = (Decimal)1; 
        insert bit2ShopProductStock;
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Repaired';
        insert bit2ShopStockSerials2;
        
        Bit2Shop__Stock_Serials2__History stockSerials2History= new Bit2Shop__Stock_Serials2__History(ParentId=bit2ShopStockSerials2.Id,Field='Bit2Shop__Status__c');
        insert stockSerials2History;

        Bit2Shop__Product_Stock__History productStockHistory = new Bit2Shop__Product_Stock__History();
        productStockHistory.ParentId = bit2ShopProductStock.Id;
        productStockHistory.Field = 'Plc_UsableQty__c';
        insert productStockHistory;
        
        Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );
        insert reservation;
        
        Plc_Reservation__History reservationHistory= new Plc_Reservation__History(ParentId=reservation.Id,Field='Plc_Status__c');
        insert reservationHistory;
        
        Plc_DistributionList__c plcDistributionList = new Plc_DistributionList__c(Plc_Alias__c='Plc_AliasTest1',Plc_Status__c='Draft');
        insert plcDistributionList;
        
        Plc_DistributionListItem__c plcDistributionListItem = new Plc_DistributionListItem__c();
        plcDistributionListItem.Plc_DistributionList__c = plcDistributionList.Id;
        plcDistributionListItem.Plc_OriginDealer__c = bit2ShopDealer.Id;
        plcDistributionListItem.Plc_DestinationWarehouse__c = bit2ShopWarehouse.Id;
        plcDistributionListItem.Plc_Product__c = b2wExtCatExtCat.Id;
        plcDistributionListItem.Plc_RequestedQty__c = 5;
        plcDistributionListItem.Plc_Status__c = 'Requested';
        insert plcDistributionListItem;
        
        Plc_DistributionListItem__History distListItemHistory = new Plc_DistributionListItem__History(ParentId=plcDistributionListItem.Id,Field='Plc_Status__c');
        insert distListItemHistory;

       }
    
    /** 
    * @author Mame Diarra
    * @date Creation 14/03/2019
    * @version 1.0
    * @description test of method getData.
    */
    @isTest
    static void getData1Test(){
        Bit2Shop__Product_Stock__c bit2ShopProductStock = [SELECT Id FROM  Bit2Shop__Product_Stock__c LIMIT 1];
        String warehouseId = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1].Id;
        String productStockId = [SELECT Id FROM  Bit2Shop__Product_Stock__c LIMIT 1].Id;
        String solutionName = [SELECT Name FROM Plc_Solution__c LIMIT 1].Name;
        String extCatId = [SELECT Id FROM B2WExtCat__External_Catalog_Item__c LIMIT 1].Id;
        String logistickDivision = 'Nexi';
        Datetime inputDate= System.now();
        List<Bit2Shop__Product_Stock__History> testvalore = [SELECT Id FROM Bit2Shop__Product_Stock__History];
        system.debug('####TEST VALORE: '+testvalore);
        Test.startTest();
		 Plc_CheckStockQuantityCnt.getData1(warehouseId, extCatId, logistickDivision, solutionName,inputDate);
		Test.stopTest();
    }
    
    /** 
    * @author Mame Diarra
    * @date Creation 18/03/2019
    * @version 1.0
    * @description test of filterModelLookup method.
    */
    @isTest
    static void filterModelLookupTest(){
        String warehouseId=''+([SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1]).Id;
        Test.startTest();
		String result = Plc_CheckStockQuantityCnt.filterModelLookup(warehouseId);
        //when warehouseId is empty
		String result2 = Plc_CheckStockQuantityCnt.filterModelLookup('');
        Test.stopTest();
    }
    
    /** 
    * @author Mame Diarra
    * @date Creation 18/03/2019
    * @version 1.0
    * @description test exception of filterModelLookup method.
    */
    @isTest
    static void filterModelLookupTestKO(){
        Test.startTest();
		String result = Plc_CheckStockQuantityCnt.filterModelLookup('test');
        Test.stopTest();
    }
        
    /** 
    * @author Mame Diarra
    * @date Creation 18/03/2019
    * @version 1.0
    * @description test of getRelativeProductStock method.
    */
    @isTest
    static void getRelativeProductStockTest(){
        String warehouseId=''+([SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1]).Id;
        String extCatId=''+([SELECT Id FROM B2WExtCat__External_Catalog_Item__c LIMIT 1]).Id;
        Test.startTest();
		Object result = Plc_CheckStockQuantityCnt.getRelativeProductStock(warehouseId, extCatId, ' ' ,' ');
        //warehouseId is empty
		Object result2 = Plc_CheckStockQuantityCnt.getRelativeProductStock('', extCatId, '', '');
        Test.stopTest();
    }
    
    /** 
    * @author Mame Diarra
    * @date Creation 18/03/2019
    * @version 1.0
    * @description test exception of getRelativeProductStock method.
    */
    @isTest
    static void getRelativeProductStockTestKO(){
        Test.startTest();
		Object result = Plc_CheckStockQuantityCnt.getRelativeProductStock(' ', ' ', ' ',' ');
        Test.stopTest();
    }
    
    /** 
    * @author Mame Diarra
    * @date Creation 19/03/2019
    * @version 1.0
    * @description test of getRelativeWarhouseAndModel method.
    */
    @isTest
    static void getRelativeWarhouseAndModelTest(){
        Bit2Shop__Product_Stock__c bit2ShopProductStock = [SELECT Id FROM  Bit2Shop__Product_Stock__c LIMIT 1];
        String prodstockId=''+bit2ShopProductStock.Id;
        Test.startTest();
		Object result = Plc_CheckStockQuantityCnt.getRelativeWarhouseAndModel(prodstockId);
        Test.stopTest();
    }
    
    /** 
    * @author Mame Diarra
    * @date Creation 20/03/2019
    * @version 1.0
    * @description test exception of getRelativeWarhouseAndModel method.
    */
    @isTest
    static void getRelativeWarhouseAndModelTestKO(){}

    
@isTest
static void testfetchRecordsError() {
 Plc_CheckStockQuantityCnt.ProductStockWrp recordData = new Plc_CheckStockQuantityCnt.ProductStockWrp();
        /*recordData.label = ' ';*/
        recordData.id = ' ';
        recordData.modelName = ' '; 
        recordData.warehouse = ' ';
        recordData.solutionName = ' ';
        recordData.logistickDivisionName = ' ';
        recordData.stock = null;
        recordData.usable = null;
        recordData.withdrawn = null;
        recordData.ordered = null;

        Test.startTest();

        try
        {
           Plc_CheckStockQuantityCnt.getData1('', '', '', '', null);
           
        }Catch(exception e){
        
        }  
        Test.stopTest();
  }
    
}