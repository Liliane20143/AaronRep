/**
   @author Marco Zisa
   @date Creation 05/02/2019
   @version 1.0
   @description Test of Plc_StockSerial2HistoryManager
   @Modification by Moussa FOFANA on 2019/02/22	
*/
@isTest
public class Plc_StockSerial2HistoryManagerTest {
    
	@testSetup    
    static void setup() {
    	Plc_TestFactory.initProcessClickPackage();

    }

    @isTest
    static void updateStockSerialHistoryWithoutStockOrder() {
        // Start test
        Test.startTest();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('Parent Dealer',account,'Alias');
        insert parentDealer;
        
        Bit2Shop__Dealer__c childDealer = Plc_TestFactory.createDealerChild('dealer', account,'45262',parentDealer);
        insert childDealer;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('Warehouse Name','Installed','Nexi','000001NEXI', childDealer);
        insert bit2ShopWarehouse;

        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('123456789');
        insert plcSolution;

    	B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
		insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Cat Item Name',b2WExtCatExtCatalog, '37377','Process');
		//b2wExtCatExtCat.Plc_Manufacturer__c=childDealer1.Id;
        b2wExtCatExtCat.Plc_Alias__c ='00541237896541230';    
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
		bit2ShopProductStock.Plc_UsableQty__c =2;
        bit2ShopProductStock.Plc_WithdrawnQty__c=1; 
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;

        Map<Id, Bit2Shop__Stock_Serials2__c> newItems = new Map<Id, Bit2Shop__Stock_Serials2__c>();

    	Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2 = 
    	Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        bnit2ShopStockSerials2.Plc_PcipedExpiryDate__c=Date.newInstance(System.now().year(),System.now().month(),System.now().day());
        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'value1';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_DllSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_Property__c='N';
        //bnit2ShopStockSerials2.Bit2Shop__Status__c='Closed';
		bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c=null;
        //bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        insert bnit2ShopStockSerials2;
        newItems.put(bnit2ShopStockSerials2.Id, bnit2ShopStockSerials2);

        Plc_StockSerial2HistoryManager.manageInsertOperation(newItems);

        Bit2Shop__Stock_Serials2__c serial = new Bit2Shop__Stock_Serials2__c(Id = bnit2ShopStockSerials2.Id);
        serial.Plc_DllSerialNumber__c = 'Test333';
        //serial.Bit2Shop__Status__c='Pending';
        update serial;

        newItems.clear();
        newItems.put(serial.Id, serial);

        Plc_StockSerial2HistoryManager.manageUpdateOperation(newItems);

        // Stop test
        Test.stopTest();
    }

    @isTest
    static void updateStockSerialHistoryWithStockOrder() {
        // Start test
        Test.startTest();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Contact contact = Plc_TestFactory.createContactGeneric('Name');
        contact.Account = account;
        insert contact;

        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('Parent Dealer',account,'Alias');
        insert parentDealer;

        Bit2Shop__Dealer__c dealerInstallati = Plc_TestFactory.createDealerChild('Installati',account,'122100',parentDealer);
        //dealerInstallati.Plc_Maintainer__c=true;
        insert dealerInstallati;
        
        Bit2Shop__Dealer__c dealer = Plc_TestFactory.createDealerChild('Nestle',account,'0002121',parentDealer);
        insert dealer;
        
        Plc_SystemSettings__c settings = new Plc_SystemSettings__c();
        settings.Plc_DaysForCalculatingConsumption__c=30;
        settings.Plc_PurchaseWarrantyMonthsDelay__c = 5;
        insert settings;
        
        Bit2Shop__Warehouse__c wareHouseInstallati1 = Plc_TestFactory.createWarehouse('wareHouse Name','Installed','Nexi','000001NEXI',dealerInstallati);
        insert wareHouseInstallati1;
        
        B2WExtCat__External_Catalog__c catalog = new B2WExtCat__External_Catalog__c();
        catalog.B2WExtCat__External_Catalog_Name__c='Principale';
        insert catalog;
        
        List<Plc_Solution__c> solutions = Plc_TestFactory.createSolutions(4);
        insert solutions;
        
        Bit2Shop__Warehouse__c wareHouse1 = Plc_TestFactory.createWarehouse('Warehouse2','Installed','Nexi','alias2',dealer);
        insert wareHouse1;
        
        B2WExtCat__External_Catalog_Item__c externalCatItem1 = Plc_TestFactory.createExtCatalogItem('Cat Item Name',catalog,'POS001','Process');
        externalCatItem1.Plc_Alias__c='alias1';
        externalCatItem1.B2WExtCat__External_Catalog_Item_Name__c = 'NCC 1701';
        insert externalCatItem1;

        List<Bit2Shop__Product_Stock__c> productStockitemList = new List<Bit2Shop__Product_Stock__c>();
        Bit2Shop__Product_Stock__c productStockItem = Plc_TestFactory.createProductStock(externalCatItem1,wareHouse1);
        productStockItem.Plc_UsableQty__c = 100;
        productStockItem.Plc_WithdrawnQty__c = 50;
        productStockItem.Plc_OrderedQty__c=0;

        Bit2Shop__Product_Stock__c productStockItem2 = Plc_TestFactory.createProductStock(externalCatItem1,wareHouse1);
        productStockItem2.Plc_UsableQty__c = 100;
        productStockItem2.Plc_WithdrawnQty__c = 50;
        productStockItem2.Plc_OrderedQty__c=0;

        Id inboundRecordTypeId = Plc_Utils.getRecordTypeId('Inbound_Shipment', 'Bit2Shop__Shipment__c');
        Id outboundRecordTypeId = Plc_Utils.getRecordTypeId('Outbound_Shipment', 'Bit2Shop__Shipment__c');
        Id productRecordTypeId = Plc_Utils.getRecordTypeId('Shipment_Line_Item_Product', 'Bit2Shop__Shipment_Line_Item__c');
        Id serialRecordTypeId = Plc_Utils.getRecordTypeId('Shipment_Line_Item_Serial', 'Bit2Shop__Shipment_Line_Item__c');
        
        WorkOrder workOrder1 = Plc_TestFactory.createWorkOrder('AG',account,contact,'1','2','3','4','5','6','7','8','9','10');
        insert workOrder1;
        
        Bit2Shop__StockOrder__c nexitowareHouse1 = Plc_TestFactory.createStockOrder('Stock2OtherShop',workOrder1,wareHouseInstallati1,dealerInstallati,wareHouse1,dealer);
        insert nexitowareHouse1;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(externalCatItem1, wareHouse1);
		bit2ShopProductStock.Plc_UsableQty__c =2;
        bit2ShopProductStock.Plc_WithdrawnQty__c=1;
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        bit2ShopProductStock.Bit2Shop__External_Catalog_Item_Id__c = externalCatItem1.Id;
        insert bit2ShopProductStock;

        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;

    	Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2 = Plc_TestFactory.createStockSerial2(wareHouse1,'New');
        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'value1';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_DllSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_Property__c='N';
        bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bnit2ShopStockSerials2.Bit2Shop__Transfer_Order_Id__c = nexitowareHouse1.Id;
        bnit2ShopStockSerials2.Plc_TermId__c = plcTermId.Id;
        insert bnit2ShopStockSerials2;

        Bit2Shop__Stock_Serials2__c serial = [SELECT Id FROM Bit2Shop__Stock_Serials2__c Limit 1];
        serial.Plc_DllSerialNumber__c = 'Test333';
        update serial;
        
        // Stop test
        Test.stopTest();
    }
}