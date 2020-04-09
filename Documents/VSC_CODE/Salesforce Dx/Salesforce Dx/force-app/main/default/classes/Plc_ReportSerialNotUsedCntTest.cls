/**
 * @author Abdoulaye DIOP
 * @date Creation 22/03/2019
 * @version 1.0
 * @description Test of the class Plc_ReportSerialNotUsedCnt.
 */
@isTest
public class Plc_ReportSerialNotUsedCntTest {

    @TestSetup
    static void makeData(){

        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c bit2ShopDealerParent = Plc_TestFactory.createDealer('dealer', account, '456512665');
        bit2ShopDealerParent.Plc_Alias__c = '456512665';
        bit2ShopDealerParent.Plc_Repairer__c = true;
        bit2ShopDealerParent.Plc_DealerManufacturer__c = true;
        bit2ShopDealerParent.Name='parent';
        insert bit2ShopDealerParent;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealerChild('dealerfarman', account, '4565165', bit2ShopDealerParent);
        insert bit2ShopDealer;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Irrecoverable', '', '000001NEXI', bit2ShopDealer);
        insert bit2ShopWarehouse;

        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('123456789');
        insert plcTermId;

        Bit2Shop__Stock_Serials2__c serial = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse, 'Withdrawn');

        serial.Bit2Shop__Serial_Number__c = 'SERIALNUMBER';
        serial.Plc_TermId__c = plcTermId.Id;
        serial.Plc_Property__c = 'Nexi';
        serial.Plc_PTSCode__c = 'ptccode';
        serial.Bit2Shop__ICCID__c = 'bit2ShopICCID';
        serial.Bit2Shop__IMEI__c = 'bit2ShopIMEI';
        serial.Plc_PcipedModel__c = 'plc_PcipedModel';
        serial.Plc_PcipedLetterOfApproval__c = 'plcPcipedLetterOfApproval';
        serial.Plc_PcipedApprovalNumber__c = 'plcPcipedApprovalNumber';
        serial.Plc_PcipedVersion__c = 'plcPcipedVersion';
        serial.Plc_PcipedExpiryDate__c = System.today();
        serial.Bit2Shop__Status__c = 'Repaired';
        serial.Plc_Property__c = 'N';
        serial.Plc_ManufacturerSerialNumber__c='1278';
        insert serial;
        
        Bit2Shop__Serial_Stock_History__c serialStockHistor= new Bit2Shop__Serial_Stock_History__c();
        serialStockHistor.Bit2Shop__Action_Code__c='test';
        serialStockHistor.Bit2Shop__Action_Date__c=Date.newInstance(2019, 04, 11);
        insert serialStockHistor;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('123456789');
        insert plcSolution;


        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '123456789', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = '123456789';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat.Bit2Shop__Product_Description__c = 'description';
        b2wExtCatExtCat.Bit2Shop__Required_Serial__c = true;
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 15;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;

        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c();
        stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c = bit2ShopDealer.Id;
        insert stockOrder;
    }

    /**
    * @author Abdoulaye DIOP
    * @date Creation 22/03/2019
    * @Modification : Khalidou I. Sow BA on 2019/04/01
    * @version 1.0
    */
    @isTest
    static void initializeTest(){
        Test.startTest();
            Map<String, Object> result = Plc_ReportSerialNotUsedCnt.initialize();
            System.assertNotEquals(null,result);
        Test.stopTest();
    }

    /**
    * @author Abdoulaye DIOP
    * @date Creation 22/03/2019
    * @version 1.0
    */
    @isTest
    static void applyFilterTest(){
        Date today = System.today();
        Date startDate = Date.newInstance(today.year(), today.month() ,today.day() -1);
        Date endDate = Date.newInstance(today.year(), today.month() ,today.day() +2);

        Bit2Shop__Stock_Serials2__c stockSerials2 = [SELECT Id, Bit2Shop__Status__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        String status = stockSerials2.Bit2Shop__Status__c;
        Bit2Shop__Warehouse__c warehouse = [SELECT Id, Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        Bit2Shop__Dealer__c dealerParent = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = '456512665' LIMIT 1];
        Bit2Shop__Dealer__c dealerChild = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = '4565165' LIMIT 1];

        Test.startTest();
        List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper> serialWrappers1 = Plc_ReportSerialNotUsedCnt.applyFilter(null, null, status, '', '', '');
        System.assertEquals(null, serialWrappers1);

        List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper> serialWrappers2 = Plc_ReportSerialNotUsedCnt.applyFilter(startDate, endDate, status, dealerChild.Id, dealerParent.Id, warehouse.Id);
        System.assertEquals(null, serialWrappers2);

        List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper> serialWrappers3 = Plc_ReportSerialNotUsedCnt.applyFilter(startDate, endDate, 'Test',null, null, null);
        //System.assertEquals(null, serialWrappers3);

        /*delete stockSerials2;
        List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper> serialWrappers4 = Plc_ReportSerialNotUsedCnt.applyFilter(startDate, endDate, status, dealerChild.Id, dealerParent.Id, null);
        */

        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 25/03/2019 
     * @Modified 28/03/2019 by Mame Diarra
     * @version 1.0
     * @description return a list WrapperListFromStockSerialList
     */
    @isTest
    static void getWrapperListFromStockSerialListTest(){
        List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id, Name, Bit2Shop__Warehouse_Id__c,  Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__r.Name,
                Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Name, Bit2Shop__Warehouse_Id__r.Name,Plc_ManufacturerSerialNumber__c,Plc_EncodedSerialNumber__c,Plc_DllSerialNumber__c,
                Plc_Model__c
                FROM Bit2Shop__Stock_Serials2__c];

        Test.startTest();
            List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper> wrapperListFromStockSerialList = Plc_ReportSerialNotUsedCnt.getWrapperListFromStockSerialList(stockSerialList);
            System.assertNotEquals(0, wrapperListFromStockSerialList.size());
        Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 28/03/2019 
     * @version 1.0
     * @description test exception getWrapperListFromStockSerialList method
     */
    @isTest
    static void getWrapperListFromStockSerialListTestKo(){
        List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        
        Test.startTest();
            List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper> wrapperListFromStockSerialList = Plc_ReportSerialNotUsedCnt.getWrapperListFromStockSerialList(stockSerialList);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye DIOP
     * @date Creation 25/03/2019
     * @Modified 28/03/2019 by Mame Diarra
     * @Modified 11/04/2019 by Mame Diarra
     * @version 1.0
     * @description return a list WrapperListFromStockSerialList
     */
    @isTest
    static void exportCSVTest(){
        String separatorCSV = ',';
        List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper> stockSerialWrapperList =
                new List<Plc_ReportSerialNotUsedCnt.stockSerialWrapper>();

        Test.startTest();

        String exportCSV1 = Plc_ReportSerialNotUsedCnt.exportCSV(stockSerialWrapperList, separatorCSV);
        System.assertEquals(null, exportCSV1);
	    Plc_ReportSerialNotUsedCnt.stockSerialWrapper  stockSerialWrapper = new Plc_ReportSerialNotUsedCnt.stockSerialWrapper('Id', 'Name','manufacturerSerialNumber','encodedSerialNumber',
                                                                                                                              'dllSerialNumber','model','parentDealer','childDealer','warehouse');
        Plc_ReportSerialNotUsedCnt.stockSerialWrapper  stockSerialWrapper2 = new Plc_ReportSerialNotUsedCnt.stockSerialWrapper('', '','','','','','','','');

        stockSerialWrapperList.add(stockSerialWrapper);
        stockSerialWrapperList.add(stockSerialWrapper2);
        String exportCSV2 = Plc_ReportSerialNotUsedCnt.exportCSV(stockSerialWrapperList, separatorCSV);
        System.assertNotEquals(null, exportCSV2);
        //start test of the exception
        String exportCSV3 = Plc_ReportSerialNotUsedCnt.exportCSV(null, separatorCSV);
        //end test of the exception
        Test.stopTest();
    }
}