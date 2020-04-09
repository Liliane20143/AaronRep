/**
     * @author Abdoulaye & Moussa
     * @date Creation 08/01/2019
     * @version 1.0
     * @description Test of PLC Plc_StockSerialPrintLabelController.
     */
 	@isTest
 	public class Plc_StockSerialPrintLabelCntTest {

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 08/01/2019
    * @version 1.0
    * @description Test of the constructor.
    */
    @isTest
    static void constructorTest(){
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'123456');
        insert bit2ShopDealer;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('WarehouseName', 'Installed','Nexi' ,'000001NEXI' , bit2ShopDealer);
        insert bit2ShopWarehouse;
        
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;
        
        Bit2Shop__Stock_Serials2__c stockSerial = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse, 'New');
        insert stockSerial;
        
        PageReference myVfPage = Page.Plc_StockSerialPrintLabel;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('Id',stockSerial.Id);
        //ApexPages.currentPage().getParameters().put('idValueToCheck',stockSerial.Id);

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(stockSerial);
        Plc_StockSerialPrintLabelCnt stockSerialPrintLabelController=new Plc_StockSerialPrintLabelCnt(sc);

        ApexPages.StandardController sc1 = new ApexPages.StandardController(stockSerial);
        ApexPages.currentPage().getParameters().put('idValueToCheck',stockSerial.Id);
        Plc_StockSerialPrintLabelCnt stockSerialPrintLabelController1=new Plc_StockSerialPrintLabelCnt(sc1);
        
        Test.stopTest();            
    }
    
        
}