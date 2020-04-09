/**
     * @author Luca Belometti
     * @date Creation 13/08/2019
     * @version 1.0
     * @description Test of PLC Plc_StockOrderPrintLabelController.
     */
 	@isTest
 	public class Plc_StockOrderPrintLabelCntTest {

    /**
    * @author Luca Belometti
    * @date Creation 13/08/2019
    * @version 1.0
    * @description Test of the constructor.
    */
    @isTest
    static void constructorTest(){
        Plc_TestFactory.initProcessClickPackage();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        account.name='Account';
        insert account;
        Account account2 = Plc_TestFactory.createAccountSupplier('Name2');
        account2.name='Account';
        insert account2;
        
        Contact contact = Plc_TestFactory.createContactGeneric('Name');
        contact.Account=account;
        //contact.LastName='LastName';
        insert contact;

        Bit2Shop__Dealer__c dealerInstallati = Plc_TestFactory.createDealer('Installati',account,'1234567');
        dealerInstallati.Plc_Repairer__c=true;
        insert dealerInstallati;
        
        Bit2Shop__Dealer__c dealer = Plc_TestFactory.createDealer('Nestle',account2,'123456');
        dealer.Plc_Manufacturer__c =true;
        insert dealer;
        
        Plc_SystemSettings__c settings = new Plc_SystemSettings__c();
        settings.Plc_DaysForCalculatingConsumption__c=30;
        settings.Plc_PurchaseWarrantyMonthsDelay__c = 5;
        insert settings;
        
        Bit2Shop__Warehouse__c wareHouseInstallati1 = Plc_TestFactory.createWarehouse('UniqueKey1', 'Repaired','','000001NEXI',dealerInstallati);
        insert wareHouseInstallati1;
        
        B2WExtCat__External_Catalog__c catalog = new B2WExtCat__External_Catalog__c();
        catalog.B2WExtCat__External_Catalog_Name__c='Principale';
        insert catalog;
        
        List<Plc_Solution__c> solutions = Plc_TestFactory.createSolutions(4);
        insert solutions;
        
        Bit2Shop__Warehouse__c wareHouse1 = Plc_TestFactory.createWarehouse('test', 'New','','',dealer);
        insert wareHouse1;
        
        B2WExtCat__External_Catalog_Item__c externalCatItem1 = Plc_TestFactory.createExtCatalogItem('POS001',catalog,'sku','extCatItemType');
        externalCatItem1.B2WExtCat__External_Catalog_Item_Name__c = 'NCC 1701';
        insert externalCatItem1;

        List<Bit2Shop__Product_Stock__c> productStockitemList = new List<Bit2Shop__Product_Stock__c>();
        Bit2Shop__Product_Stock__c productStockItem =Plc_TestFactory.createProductStock(externalCatItem1,wareHouse1);
        Bit2Shop__Product_Stock__c productStockItem2 = Plc_TestFactory.createProductStock(externalCatItem1,wareHouse1);
        insert productStockItem;

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = wareHouse1.Id;
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = productStockItem.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials2.Plc_PurchaseDate__c=Date.newInstance(2019, 02, 06);
        bit2ShopStockSerials2.Plc_PurchaseWarrantyStartDate__c=Date.newInstance(2019, 01, 01);
        bit2ShopStockSerials2.Plc_PurchaseWarrantyEndDate__c=Date.newInstance(2019, 02, 16);
        insert bit2ShopStockSerials2;

        WorkOrder workOrder1 = Plc_TestFactory.createWorkOrder('AG',account,contact,'1','2','3','4','5','6','7','8','9','NoCategory');
        insert workOrder1;
        
        Bit2Shop__StockOrder__c stockOrder = Plc_TestFactory.createStockOrder('Stock2OtherShop',workOrder1,wareHouseInstallati1,dealerInstallati,wareHouse1,dealer);
        insert stockOrder;

        Bit2Shop__Shipment__c bit2ShopShipment= new Bit2Shop__Shipment__c();
        bit2ShopShipment.Bit2Shop__Stock_Order_Id__c=stockOrder.Id;
        bit2ShopShipment.Bit2Shop__Shipment_Document_Number__c='10';
        bit2ShopShipment.Bit2Shop__Sub_Type__c='Inbound';
        insert bit2ShopShipment;

        Bit2Shop__Shipment__c bit2ShopShipment2=bit2ShopShipment.clone();
        bit2ShopShipment2.Bit2Shop__Sub_Type__c='Inbound';
        bit2ShopShipment2.Bit2Shop__Stock_Order_Id__c=stockOrder.Id;
        insert bit2ShopShipment2;

        Bit2Shop__Shipment_Line_Item__c shipmentLineItem=new Bit2Shop__Shipment_Line_Item__c();
        shipmentLineItem.Bit2Shop__Date__c=Date.newInstance(2019,2,13);
        shipmentLineItem.Bit2Shop__Line_Item_Price__c=800;
        shipmentLineItem.Bit2Shop__Missed__c=false;
        shipmentLineItem.Bit2Shop__Notes__c='';
        shipmentLineItem.Bit2Shop__Package_Code__c='';
        shipmentLineItem.Bit2Shop__Product_Stock_Id__c=productStockItem.Id;
        shipmentLineItem.Bit2Shop__Received_Quantity__c=10;
        shipmentLineItem.Bit2Shop__Received_Status__c='';
        shipmentLineItem.Bit2Shop__Requested_Quantity__c=10;
        shipmentLineItem.Bit2Shop__Serial_Number__c='00008956';
        shipmentLineItem.Bit2Shop__Status__c='Closed';
        shipmentLineItem.Bit2Shop__Type__c='Serial';
        shipmentLineItem.Bit2Shop__Unpacked__c=true;
        shipmentLineItem.Plc_StockSerial__c = bit2ShopStockSerials2.Id;
        shipmentLineItem.Bit2Shop__Shipment_Id__c=''+bit2ShopShipment.Id;
        insert shipmentLineItem;

        Bit2Shop__Shipment_Line_Item__c shipmentLineItem2=shipmentLineItem.clone();
        shipmentLineItem2.Bit2Shop__Type__c='Serial';
        shipmentLineItem2.Bit2Shop__Shipment_Id__c=''+bit2ShopShipment2.Id;
        //shipmentLineItem2.Bit2Shop__Product_Stock_Id__c=productStockItem.Id;
        insert shipmentLineItem2;

        Bit2Shop__Shipment_Line_Item__c shipmentLineItem3=shipmentLineItem2.clone();
        shipmentLineItem3.Bit2Shop__Shipment_Id__c=''+bit2ShopShipment2.Id;
        //shipmentLineItem3.Bit2Shop__Product_Stock_Id__c=productStockItem.Id;
        insert shipmentLineItem3;

        NE__Order__c neOrder= new NE__Order__c(Bit2Shop__StockOrder__c=stockOrder.Id);
        insert neOrder;

        
        PageReference myVfPage = Page.Plc_StockOrderPrintLabel;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('Id',stockOrder.Id);
        //ApexPages.currentPage().getParameters().put('idValueToCheck',stockSerial.Id);

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(stockOrder);
        Plc_StockOrderPrintLabelCnt stockOrderPrintLabelController=new Plc_StockOrderPrintLabelCnt(sc);

        /*ApexPages.StandardController sc1 = new ApexPages.StandardController(stockOrder);
        ApexPages.currentPage().getParameters().put('idValueToCheck',bit2ShopStockSerials2.Id);
        Plc_StockOrderPrintLabelCnt stockOrderPrintLabelController1=new Plc_StockOrderPrintLabelCnt(sc1);*/
        
        Test.stopTest();            
    }
    
        
}