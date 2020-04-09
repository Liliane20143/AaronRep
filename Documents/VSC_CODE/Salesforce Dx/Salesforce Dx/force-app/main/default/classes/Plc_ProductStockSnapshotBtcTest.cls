/**
 * @author : Moussa FOFANA
 * @created date : 2019-03-18
 * @description Test class for Plc_ProductStockSnapshotBtc .
 */
@isTest
public with sharing class Plc_ProductStockSnapshotBtcTest {
    
    @TestSetup
	static void makedata() {

		Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Id b2ShopDealRecType = Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');

        Bit2Shop__Dealer__c bit2ShopDealerParent = Plc_TestFactory.createDealer('dealerParent', account,'456512665');
        bit2ShopDealerParent.Plc_Repairer__c = true;
        insert bit2ShopDealerParent;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealerChild('dealerfarman', account,'4565165',bit2ShopDealerParent);
        bit2ShopDealer.Bit2Shop__Approver_Group_Id__c = 'dealerfarman';
        bit2ShopDealer.RecordTypeId = b2ShopDealRecType;
        insert bit2ShopDealer;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Irrecoverable','','123456789', bit2ShopDealer);
        insert bit2ShopWarehouse;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('123456789');
        insert plcSolution;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;

        /**********************************  B2WExtCat__External_Catalog_Item__c Creation     **************************************/

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'123456789','Process');
        b2wExtCatExtCat.Plc_Alias__c = '123456789';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat.Plc_Category__c='Product'; 
        b2wExtCatExtCat.Plc_Subcategory__c='SIM';
        insert b2wExtCatExtCat;

        /********************************** Bit2Shop__Product_Stock__c CREATION ********************************************/
	 	Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat,bit2ShopWarehouse);
	 	bit2ShopProductStock.Bit2Shop__Warehouse_Id__c=''+bit2ShopWarehouse.Id;
	 	bit2ShopProductStock.Plc_OrderedQty__c=5;
        bit2ShopProductStock.Plc_UsableQty__c = 15;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3;
		insert bit2ShopProductStock;

		
	}
    
    /**
     * @author : Moussa FOFANA
     * @created date : 2019-03-18
     * @description Test batch execution
     */
    @isTest
    static void executeBatchTest(){

		Test.startTest();
			Plc_ProductStockSnapshotBtc job = new Plc_ProductStockSnapshotBtc();
			Database.executebatch(job);
		Test.stopTest();

    }    
    
    
}