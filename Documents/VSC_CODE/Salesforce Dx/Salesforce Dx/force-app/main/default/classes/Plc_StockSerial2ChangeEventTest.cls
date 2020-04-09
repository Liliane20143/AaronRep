@isTest
public class Plc_StockSerial2ChangeEventTest {
    @TestSetup
    public static void makeData (){
        Plc_TestFactory.initProcessClickPackage();
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
        // Stop test
    }
    @isTest
    public static void TestChangeEvent(){
        // Enable all Change Data Capture entities for notifications.
        Test.enableChangeDataCapture();
        Bit2Shop__Product_Stock__c pd = [SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Warehouse__c wh = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c ss = new Bit2Shop__Stock_Serials2__c();
        ss.Bit2Shop__Product_Stock_Id__c = pd.Id;
        ss.Bit2Shop__Warehouse_Id__c = wh.Id;
        ss.Plc_Status2__c = 'Sent';
        insert ss;

        Test.getEventBus().deliver();
        ss.Plc_Status2__c = 'None';
        update ss;

        Test.getEventBus().deliver();

        Bit2Shop__Stock_Serials2__c ssTest = [SELECT Id,Plc_Status2__c from Bit2Shop__Stock_Serials2__c where Id = :ss.id];
        System.assertEquals('None', ssTest.Plc_Status2__c);

        Bit2Shop__Stock_Serials2__c ss2 = new Bit2Shop__Stock_Serials2__c();
        ss2.Bit2Shop__Product_Stock_Id__c = pd.Id;
        ss2.Bit2Shop__Warehouse_Id__c = wh.Id;
        ss2.Bit2Shop__Status__c = 'New';
        ss2.Plc_Status2__c = 'None';
        insert ss2;

        

        Test.getEventBus().deliver();

        delete ss2;
        
        Test.getEventBus().deliver();
    
    }
}