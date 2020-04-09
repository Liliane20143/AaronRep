/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC ServiceWs Rest WebService.
 */
@isTest
public class Plc_StockSerialsImportUploadCntTest {
    
    @testSetup    
    static void setup(){
        Plc_TestFactory.initProcessClickPackage();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        /* Dummy dealer and warehouse */
        Plc_TestFactory.createWarehouseFake();
        /****/

        Bit2Shop__Dealer__c installedDealer = Plc_TestFactory.createDealer('dealer', account, 'TestInst');
        installedDealer.Plc_Repairer__c = false;
        insert installedDealer;

        Bit2Shop__Dealer__c manufacturerDealer = Plc_TestFactory.createDealer('dealer', account, 'Test');
        manufacturerDealer.Plc_Repairer__c = true;
        manufacturerDealer.Plc_DealerManufacturer__c = true;
        insert manufacturerDealer;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, 'TestRep');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;

        Bit2Shop__Dealer__c bit2ShopDealer2 = Plc_TestFactory.createDealer('dealer', account, '45263');
        bit2ShopDealer2.Plc_Repairer__c = true;
        insert bit2ShopDealer2;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Nexi', '00789654123654789', bit2ShopDealer);
        bit2ShopWarehouse.Plc_UniqueKey__c = 'key1';
        //bit2ShopWarehouse.Plc_Tipology__c = 'Installed';
        insert bit2ShopWarehouse;

        Bit2Shop__Warehouse__c warehouseOfInstalled = Plc_TestFactory.createWarehouse('w2', 'Installed', 'Nexi', '0023244924', installedDealer);
        warehouseOfInstalled.Plc_UniqueKey__c = 'key2';
        insert warehouseOfInstalled;

        Bit2Shop__Warehouse__c warehouseOfUndefined = Plc_TestFactory.createWarehouse('w3', 'Undefined', 'Neutral', '999011NEXI', installedDealer);
        warehouseOfUndefined.Plc_UniqueKey__c = 'key3';
        insert warehouseOfUndefined;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse2 = Plc_TestFactory.createWarehouse('w3', 'Repaired', 'Nexi', '456935', bit2ShopDealer2);
        bit2ShopWarehouse2.Plc_UniqueKey__c = 'key3';
        insert bit2ShopWarehouse2;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, 'Test', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = '00541237896541230';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat.Plc_Manufacturer__c = manufacturerDealer.Id;
        b2wExtCatExtCat.Bit2Shop__Product_Description__c = 'description';
        b2wExtCatExtCat.Bit2Shop__Required_Serial__c = true;
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock1 = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock1.Plc_UsableQty__c = 2;
        bit2ShopProductStock1.Plc_WithdrawnQty__c = 1; 
        insert bit2ShopProductStock1;

        Bit2Shop__Product_Stock__c productStockUndefined = Plc_TestFactory.createProductStock(b2wExtCatExtCat, warehouseOfUndefined);
        productStockUndefined.Plc_UsableQty__c = 2;
        productStockUndefined.Plc_WithdrawnQty__c = 1; 
        insert productStockUndefined;
        
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;

        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bnit2ShopStockSerials2.Bit2Shop__Status__c = 'New';
        bnit2ShopStockSerials2.Bit2Shop__Serial_Number__c = 'bit2ShopSerialNumber';
        bnit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c= bit2ShopWarehouse.Id;
        bnit2ShopStockSerials2.Plc_TermId__c = plcTermId.Id;
        bnit2ShopStockSerials2.Plc_Property__c = 'Nexi';
        bnit2ShopStockSerials2.Plc_PTSCode__c='ptccode';
        bnit2ShopStockSerials2.Bit2Shop__ICCID__c='bit2ShopICCID';
        bnit2ShopStockSerials2.Bit2Shop__IMEI__c='bit2ShopIMEI';
        bnit2ShopStockSerials2.Plc_PcipedModel__c='plc_PcipedModel';
        bnit2ShopStockSerials2.Plc_PcipedLetterOfApproval__c='plcPcipedLetterOfApproval';
        bnit2ShopStockSerials2.Plc_PcipedApprovalNumber__c='plcPcipedApprovalNumber';
        bnit2ShopStockSerials2.Plc_PcipedVersion__c='plcPcipedVersion';
        bnit2ShopStockSerials2.Plc_PcipedExpiryDate__c= Date.newInstance(System.now().year(),System.now().month(),System.now().day());

        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_DllSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_Property__c='N';
        bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock1.Id;
        insert bnit2ShopStockSerials2;

        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumberUnique__c = manufacturerDealer.Plc_Alias__c + '_' + bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c;
        bnit2ShopStockSerials2.Plc_EncodedSerialNumberUnique__c = manufacturerDealer.Plc_Alias__c + '_' + bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c;
        bnit2ShopStockSerials2.Plc_DllSerialNumberUnique__c = manufacturerDealer.Plc_Alias__c + '_' + bnit2ShopStockSerials2.Plc_DllSerialNumber__c;
        update bnit2ShopStockSerials2;

        Bit2Shop__Stock_Serials2__c decomissionedStockSerial = new Bit2Shop__Stock_Serials2__c();
        decomissionedStockSerial.Bit2Shop__Status__c = 'Decommissioned';
        decomissionedStockSerial.Bit2Shop__Serial_Number__c = 'bit2ShopSerialNumber2';
        decomissionedStockSerial.Bit2Shop__Warehouse_Id__c= warehouseOfUndefined.Id;
        decomissionedStockSerial.Plc_TermId__c = plcTermId.Id;
        decomissionedStockSerial.Plc_Property__c = 'Neutral';
        decomissionedStockSerial.Plc_PTSCode__c='ptccode2';
        decomissionedStockSerial.Bit2Shop__ICCID__c='bit2ShopICCID2';
        decomissionedStockSerial.Bit2Shop__IMEI__c='bit2ShopIMEI2';
        decomissionedStockSerial.Plc_PcipedModel__c='plc_PcipedModel2';
        decomissionedStockSerial.Plc_PcipedLetterOfApproval__c='plcPcipedLetterOfApproval2';
        decomissionedStockSerial.Plc_PcipedApprovalNumber__c='plcPcipedApprovalNumber2';
        decomissionedStockSerial.Plc_PcipedVersion__c='plcPcipedVersion2';
        decomissionedStockSerial.Plc_PcipedExpiryDate__c= Date.newInstance(System.now().year(),System.now().month(),System.now().day());

        decomissionedStockSerial.Plc_ManufacturerSerialNumber__c = 'TestDec';
        decomissionedStockSerial.Plc_EncodedSerialNumber__c = 'TestDec';
        decomissionedStockSerial.Plc_DllSerialNumber__c = 'TestDec';
        decomissionedStockSerial.Plc_Property__c='N';
        decomissionedStockSerial.Bit2Shop__Product_Stock_Id__c = productStockUndefined.Id;
        insert decomissionedStockSerial;

        decomissionedStockSerial.Plc_ManufacturerSerialNumberUnique__c = manufacturerDealer.Plc_Alias__c + '_' + decomissionedStockSerial.Plc_ManufacturerSerialNumber__c;
        decomissionedStockSerial.Plc_EncodedSerialNumberUnique__c = manufacturerDealer.Plc_Alias__c + '_' + decomissionedStockSerial.Plc_EncodedSerialNumber__c;
        decomissionedStockSerial.Plc_DllSerialNumberUnique__c = manufacturerDealer.Plc_Alias__c + '_' + decomissionedStockSerial.Plc_DllSerialNumber__c;
        update decomissionedStockSerial;

        Bit2Shop__Stock_Action__c stockAction = new Bit2Shop__Stock_Action__c(Plc_Alias__c='10230',Bit2Shop__Action_Code__c='0003111');
        insert stockAction;

        /******************************  Bit2Shop__TransferDetail__c CREATION   ****************************************/
        
         Bit2Shop__TransferDetail__c transferDet = new Bit2Shop__TransferDetail__c();

         transferDet.Bit2Shop__Code__c                       =   'SPOS_INDEFINITI';
         transferDet.Bit2Shop__Transfer_Type__c              =   'Stock2OtherShop';
         transferDet.Plc_Alias__c                            =   '000001NEXI';
         transferDet.Plc_AvailableForProfiles__c             =   'Operation';
         transferDet.Plc_DestinationWarehouseStockAction__c  =   stockAction.Id;
         transferDet.Plc_FilterDestinationWarehouse__c       =   'New';
         transferDet.Plc_FilterOriginWarehouse__c            =   'Repaired';
         transferDet.Plc_FilterSerialStatus__c               =   'New';
         transferDet.Plc_SourceWarehouseStockAction__c       =   stockAction.Id;
         transferDet.Plc_StockGrouping__c                    =   'Causale1';
         insert transferDet; 

        /******************************  Bit2Shop__Dealer_User__c CREATION *********************************************/ 
        
        Bit2Shop__Dealer_User__c dealerUser = new Bit2Shop__Dealer_User__c( Bit2Shop__User_Id__c =  UserInfo.getUserId(),Plc_Alias__c ='0000NEXI',Bit2Shop__Dealer_Id__c = installedDealer.Id);
        insert dealerUser;
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 07/12/2018
     * @version 1.0
     * @description Test of the method  retrieveTranslationMap.
     */
    @isTest
    static void retrieveTranslationMapTest(){
        // Start test
        Test.startTest();
        Map<String, Object> response =Plc_StockSerialsImportUploadCnt.retrieveTranslationMap();
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 07/12/2018
     * @version 1.0
     * @description Test of the method  retrievePropertiesMap.
     */
    @isTest
    static void retrievePropertiesMapTest(){
        Bit2Shop__Warehouse__c warehouse = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed' Limit 1];
        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.retrievePropertiesMap(''+warehouse.Id);
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 07/12/2018
     * @version 1.0
     * @description Test of the method  retrievePropertiesMap.
     */
    @isTest
    static void retrievePropertiesMapKOTest(){
        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.retrievePropertiesMap('1');
        // Stop test
        Test.stopTest();
    }
 
    /************************* modified at 11/02/2019  by Abdoulaye *************************/
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 31/01/2019
     * @version 1.0
     * @description Test of the method  parseCsvInputfile .
     */
    @isTest
    static void parseCsvInputfileFullTest(){

        Bit2Shop__Warehouse__c warehouse = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed' Limit 1];
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        
        String csvFile = 'field1,field2,field3\n';
        csvFile += '\n';
        csvFile += 'test,\n';
        csvFile += 'test,test,\n';
        csvFile += 'test,test,test,\n';
        csvFile += 'test,test,test, ,\n';
        csvFile += 'test,test,test,test,\n';
        csvFile += 'test,test,test,test, ,\n';
        csvFile += 'test,test,test,test,test,\n';
        csvFile += 'test,test,test,test,test,test,\n';
        csvFile += 'test,test,test,test,test,test,  ,\n';
        csvFile += 'test,test,test,test,test,  ,test,test,\n';
        csvFile += 'test,test,test,test,test,test,test\n';
        csvFile += 'test,test,test,test,test,test,1.5\n';
        csvFile += 'test,test,test,test,test,test,1.5,test,test,test,test,test,test,1.5\n';
        csvFile += 'test,test,test,test,test,test,1.5,test,test,test,test,test,'+System.today()+',1.5\n';
        csvFile += 'test,test,test,test,test,test,1.5,test,test,test,test,test,  ,1.5\n';
        csvFile += ' , ,  ,test,test,test,1.5,test,test,test,test,test,'+System.today()+',1.5\n';
        csvFile += 'test,test,test,test,test,  ,1.5,test,test,test,test,test,test,1.5\n';
        csvFile += ' , , ,test, ,  ,1.5,test,test,test,test,test,'+myDate.format()+',1.5\n'; // 349
        csvFile += ' ,test, ,test, , ,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n';
        csvFile += ' ,test, ,test, , ,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; //429
        

        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);

        // when warehousId equals null
        String csvFile2 = 'field1,field2,field3\n';
        csvFile2 += 'test,test,test,test,  ,test,1.5,test,test,test,test,test,'+System.today()+',1.5\n';
        csvFile2 += 'test,test,test,test,  ,test,1.5,test,test,test,test,test,test,1.5\n';
        csvFile2 += 'test,test,test, ,test,test,\n'; //306
        csvFile2 += ' ,test, ,test, , ,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; //358
        
        Blob csv2 = Blob.valueOf(csvFile2);
        String csvString2 = EncodingUtil.base64Encode(csv2);
        
        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, ''+warehouse.Id, '', false);
        
        Map<String, Object> response2 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString2, '', '', false);
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 31/01/2019
     * @version 1.0
     * @description Test of the method  parseCsvInputfile.
     */
    @isTest
    static void parseCsvInputfileHasOneRowTest(){
        Bit2Shop__Warehouse__c warehouse = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed' Limit 1];
        /*DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());*/
        
        String csvFile = 'Test,Test,Test\n';
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);
        // Start test
        Test.startTest();
        Map<String, Object> response =Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString,''+warehouse.Id, '', false);
        // Stop test

        // when the second row is empty // String.isBlank(inputCsvRows.get(index)) line 218
        csvFile += '\n';
        csvFile += 'tset,Test';
        Blob csv2 = Blob.valueOf(csvFile);
        csvString = EncodingUtil.base64Encode(csv2);
        Map<String, Object> response2 =Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString,''+warehouse.Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 07/12/2018
     * @version 1.0
     * @description Test of the method  parseCsvInputfile when the inputFifle is note correct.
     */
    @isTest
    static void parseCsvInputfileTestWhenFileIsNotCorrect(){
        Bit2Shop__Warehouse__c warehouse = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed' Limit 1];
        // Start test
        Test.startTest();
        Map<String, Object> response =Plc_StockSerialsImportUploadCnt.parseCsvInputfile('test',''+warehouse.Id, '', false);
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 05/02/2018
     * @version 1.0
     * @description Test of the method  parseCsvInputfile when the inputFifle is blank.
     */
    @isTest
    static void parseCsvInputfileWhereFileIsBlankTest(){

        Bit2Shop__Warehouse__c warehouse = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed' Limit 1];
        
        
        String csvFile = 'field1,field2,field3\n';
        csvFile += ' \n';
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);

        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString,''+warehouse.Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 05/02/2018
     * @version 1.0
     * @description Test of the method  parseCsvInputfile when the warhouseId is not null and not valid.
     */
    @isTest
    static void parseCsvInputfileFullWhenWareHouseIdIsNull(){

        String csvFile = 'field1,field2,field3\n';
        csvFile += ' ,test, ,test,test, ,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; //438

        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);

        String warehouseId = '';
        
        // Start test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, ''+warehouseId, '', false);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 05/02/2018
     * @version 1.0
     * @description Test of the method  parseCsvInputfile when Finally getting the only models SKU needed for the queries
     */
    @isTest
    static void parseCsvInputfileOnlyModelsSKU(){
        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed'];
        
        String csvFile = 'field1,field2,field3\n';
        //csvFile += ' ,test, ,test,test, ,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; //433
        //csvFile += ' ,test, ,test,3,test,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; // 465
        csvFile += ' ,test, ,test,'+warehouses[0].Plc_Alias__c+', ,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; //472
        csvFile += ' ,test, ,test,'+warehouses[1].Plc_Alias__c +',test,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; // line 477
        csvFile += ' ,test, ,test,'+warehouses[1].Plc_Alias__c +', ,1.5,test,test,test,test,test,'+System.today().format()+',1.5\n'; // line 480

        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye diop
     * @date Creation 12/02/2019
     * @version 1.0
     * @description Test of the method  parseCsvInputfile and Checking if product sku exist
     */
    @isTest
    static void parseCsvInputfileCheckProductSkuExist(){

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed'];
        
        // Integer index : inputRowsWithoutErrors
        String csvFile = 'field1,field2,field3\n';
        csvFile += ' ,test, ,test,'+warehouses[0].Plc_Alias__c+', ,1,test,test,test,test,test,'+System.today().format()+',1.5\n';        
        csvFile += ' ,test, ,Test,'+warehouses[0].Plc_Alias__c+', ,1,test,test,test,test,test,'+System.today().format()+',1.5\n'; //line 541
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);        
        
        String csvFile2 = 'field1,field2,field3\n';
        csvFile2 += ' ,test, ,Test,'+warehouses[0].Plc_Alias__c+', ,1,test,test,test,test,test,'+System.today().format()+',1.5\n'; //line 526
		Blob csv2 = Blob.valueOf(csvFile2);
        String csvString2 = EncodingUtil.base64Encode(csv2);
        
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        
        Map<String, Object> response2 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString2, warehouses[0].Id, '', false);        
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = '456935' LIMIT 1];        
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = [SELECT Id, Plc_Alias__c FROM B2WExtCat__External_Catalog_Item__c WHERE Plc_Alias__c = '00541237896541230' limit 1];
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock2 = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock2.Plc_UsableQty__c = 6;
        bit2ShopProductStock2.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock2;
        
        String csvFile3 = 'field1,field2,field3\n';
        csvFile3 += ' ,test, ,Test,'+warehouses[0].Plc_Alias__c+', ,1,test,test,test,test,test,'+System.today().format()+',1.5\n';
        Blob csv3 = Blob.valueOf(csvFile3);
        String csvString3 = EncodingUtil.base64Encode(csv3);     
        Map<String, Object> response3 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString3, warehouses[0].Id, '', false);
        
        List<Bit2Shop__Product_Stock__c> productStocks = [SELECT Id FROM Bit2Shop__Product_Stock__c];
        delete productStocks;
        
        List<Bit2Shop__Stock_Serials2__c> stockSerials = [SELECT Id, Bit2Shop__Status__c, Plc_EncodedSerialNumber__c, Plc_EncodedSerialNumberUnique__c
                                                            FROM Bit2Shop__Stock_Serials2__c];
        System.debug('### stockSerials ### '+ stockSerials);
        
        //If found product stock are null or empty then it must be created
        Map<String, Object> response4 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString3, warehouses[0].Id, '', false);
        
        //If a warehouse was selected then use that one, otherwise calculate the warehouse of the single rew
        //(Also in this case the warehouse for the given alias must be in SF according to previous checks)
        Map<String, Object> response5 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString3, '', '', false);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye DIOP
     * @date Creation 14/02/2019
     * @version 1.0
     * @description Test of the method  saveCsvData
     */
    @isTest
    static void saveCsvDataTest(){
        
        Bit2Shop__Warehouse__c warehouse = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed' Limit 1];
        Map<String, List<Object>> modelSkuProductStockUntypedMap = new Map<String, List<Object>>();
        
        List<Bit2Shop__Product_Stock__c> productStocks = [SELECT Id, Plc_ProductSku__c FROM Bit2Shop__Product_Stock__c];
        
        Bit2Shop__Stock_Serials2__c stockSerial = [SELECT Id, Plc_ProductSku__c FROM Bit2Shop__Stock_Serials2__c WHERE Plc_ManufacturerSerialNumber__c = 'TestDec'];

        Map<String, List<Object>> modelSkuWarehouseToProductStockUntypedMap = new Map<String, List<Object>>();
        modelSkuWarehouseToProductStockUntypedMap.put('', new List<String>{productStocks[0].Id});
        
        B2WExtCat__External_Catalog_Item__c bitExtCatItem = [SELECT Id, Plc_Alias__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        Bit2Shop__Warehouse__c bitWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c limit 1];
        
        ProductStockWrp productStockWrp = new ProductStockWrp();
        productStockWrp.warehouseId = warehouse.Id;
        productStockWrp.modelId = bitExtCatItem.Id;
        productStockWrp.modelName = 'modelName';
        productStockWrp.warehouseAlias = 'warehouseAlias';
        productStockWrp.sku = 'sku';
        
        String productStockWrpToInsertString = JSON.serialize(new List<ProductStockWrp>{productStockWrp});
        Map<String, String> skuToManufacturerAlias = new Map<String, String>();
        skuToManufacturerAlias.put(bitExtCatItem.Id , bitExtCatItem.Plc_Alias__c);
        
        Map<String, String> rowIndexToExistingIdMap = new Map<String, String>();
        List<Bit2Shop__Stock_Serials2__c> bitStockSerials = [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        Integer i= 0;
        for(Bit2Shop__Stock_Serials2__c bitStockSerial :  bitStockSerials){
            rowIndexToExistingIdMap.put(i+'', bitStockSerial.Id);
            i++;
        }
        Map<String, Bit2Shop__Warehouse__c> warehouseAliasToWarehouseMap = new Map<String, Bit2Shop__Warehouse__c>();
		
        String csvFile1 = 'value1,value2,'+productStocks[0].Id+',12,'+bitExtCatItem.Id+',2,6,8,2,2,'+System.today().format()+',8,'+System.today().format()+',2,4\n';
        List<String> csvAsList = new List<String>{csvFile1};
            
        Test.startTest();
        Plc_StockSerialsImportUploadCnt.saveCsvData(csvAsList, modelSkuWarehouseToProductStockUntypedMap, productStockWrpToInsertString, 
                                                    skuToManufacturerAlias, warehouse.Id, rowIndexToExistingIdMap, warehouseAliasToWarehouseMap, '', false);
        
        rowIndexToExistingIdMap = new Map<String, String>();
        Plc_StockSerialsImportUploadCnt.saveCsvData(csvAsList, modelSkuWarehouseToProductStockUntypedMap, productStockWrpToInsertString, 
                                                    skuToManufacturerAlias, warehouse.Id, rowIndexToExistingIdMap, warehouseAliasToWarehouseMap, '', false);
        
        // when cells[5] is empty
        String csvFile2 = 'value1,value2,'+productStocks[0].Id+',12,'+bitExtCatItem.Id+', ,6,8,2,2,'+System.today().format()+',8,'+System.today().format()+',3,4\n';
        List<String> csvAsList2 = new List<String>{csvFile2};
        Plc_StockSerialsImportUploadCnt.saveCsvData(csvAsList2, modelSkuWarehouseToProductStockUntypedMap, productStockWrpToInsertString, 
                                                    skuToManufacturerAlias, warehouse.Id, rowIndexToExistingIdMap, warehouseAliasToWarehouseMap, '', false);
        
        // when  warehouseId == '' || warehouseId == null
        Plc_StockSerialsImportUploadCnt.saveCsvData(csvAsList2, modelSkuWarehouseToProductStockUntypedMap, productStockWrpToInsertString, 
                                                    skuToManufacturerAlias, '', rowIndexToExistingIdMap, warehouseAliasToWarehouseMap, '', false);
        Test.stopTest();
    }

    /**
     * @author FB
     * @date Creation 29/04/2019
     * @version 1.0
     * @description Test of the method saveCsvData
     */
    @isTest
    static void saveCsvDataTestRowIndexExisting(){
        
        Bit2Shop__Warehouse__c warehouse = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = '00789654123654789' LIMIT 1];
        Map<String, List<Object>> modelSkuProductStockUntypedMap = new Map<String, List<Object>>();
        
        List<Bit2Shop__Product_Stock__c> productStocks = [SELECT Id, Plc_ProductSku__c FROM Bit2Shop__Product_Stock__c WHERE Bit2Shop__Warehouse_Id__c = :warehouse.Id];
        
        Bit2Shop__Stock_Serials2__c stockSerial = [SELECT Id, Plc_ProductSku__c FROM Bit2Shop__Stock_Serials2__c WHERE Plc_ManufacturerSerialNumber__c = 'TestDec'];

        Map<String, List<Object>> modelSkuWarehouseToProductStockUntypedMap = new Map<String, List<Object>>();
        modelSkuWarehouseToProductStockUntypedMap.put(productStocks[0].Plc_ProductSku__c + warehouse.Plc_Alias__c, new List<String>{productStocks[0].Id});
        
        B2WExtCat__External_Catalog_Item__c bitExtCatItem = [SELECT Id, Plc_Alias__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        Bit2Shop__Warehouse__c bitWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c limit 1];
        
        String productStockWrpToInsertString = JSON.serialize(new List<ProductStockWrp>{});
        Map<String, String> skuToManufacturerAlias = new Map<String, String>();
        skuToManufacturerAlias.put(bitExtCatItem.Id , bitExtCatItem.Plc_Alias__c);
        
        Map<String, String> rowIndexToExistingIdMap = new Map<String, String>();
        List<Bit2Shop__Stock_Serials2__c> bitStockSerials = [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        Integer i = 0;
        rowIndexToExistingIdMap.put('1', stockSerial.Id);
        Map<String, Bit2Shop__Warehouse__c> warehouseAliasToWarehouseMap = new Map<String, Bit2Shop__Warehouse__c>();
        
        String csvFile1 = 'value1,value2,'+productStocks[0].Id+',Test,,,8,2,2,'+System.today().format()+',8,2,'+System.today().format()+',4\n';
        List<String> csvAsList = new List<String>{csvFile1};
        csvAsList.add('TestDec,,,Test,,Decommissioned,8,2,2,'+System.today().format()+',8,2,'+System.today().format()+',4\n');
            
        Test.startTest();
        Plc_StockSerialsImportUploadCnt.saveCsvData(csvAsList, modelSkuWarehouseToProductStockUntypedMap, productStockWrpToInsertString, 
                                                    skuToManufacturerAlias, warehouse.Id, rowIndexToExistingIdMap, warehouseAliasToWarehouseMap, '', false);
        
    }

    /**
     * @author FB
     * @date Creation 30/04/2019
     * @version 1.0
     * @description Test of the method saveCsvData
     */
    @isTest
    static void saveCsvDataTestEditModeWithError(){
        
        Bit2Shop__Warehouse__c warehouse = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = '00789654123654789' LIMIT 1];
        Map<String, List<Object>> modelSkuProductStockUntypedMap = new Map<String, List<Object>>();
        
        List<Bit2Shop__Product_Stock__c> productStocks = [SELECT Id, Plc_ProductSku__c FROM Bit2Shop__Product_Stock__c WHERE Bit2Shop__Warehouse_Id__c = :warehouse.Id];
        
        Bit2Shop__Stock_Serials2__c stockSerial = [SELECT Id, Plc_ProductSku__c FROM Bit2Shop__Stock_Serials2__c WHERE Plc_ManufacturerSerialNumber__c = 'TestDec'];

        Map<String, List<Object>> modelSkuWarehouseToProductStockUntypedMap = new Map<String, List<Object>>();
        modelSkuWarehouseToProductStockUntypedMap.put(productStocks[0].Plc_ProductSku__c + warehouse.Plc_Alias__c, new List<String>{productStocks[0].Id});
        
        B2WExtCat__External_Catalog_Item__c bitExtCatItem = [SELECT Id, Plc_Alias__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        Bit2Shop__Warehouse__c bitWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c limit 1];
        
        String productStockWrpToInsertString = JSON.serialize(new List<ProductStockWrp>{});
        Map<String, String> skuToManufacturerAlias = new Map<String, String>();
        skuToManufacturerAlias.put(bitExtCatItem.Id , bitExtCatItem.Plc_Alias__c);
        
        Map<String, String> rowIndexToExistingIdMap = new Map<String, String>();
        List<Bit2Shop__Stock_Serials2__c> bitStockSerials = [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        Integer i = 0;
        rowIndexToExistingIdMap.put('1', stockSerial.Id);
        Map<String, Bit2Shop__Warehouse__c> warehouseAliasToWarehouseMap = new Map<String, Bit2Shop__Warehouse__c>();
        
        String csvFile1 = stockSerial.Id + ',00789654123654789,TestDec,,,Test,Decommissioned,None,8,2,2,2,2,2,'+System.today().format()+ ',\n';
        List<String> csvAsList = new List<String>{csvFile1};
            
        Test.startTest();
        Plc_StockSerialsImportUploadCnt.saveCsvData(csvAsList, modelSkuWarehouseToProductStockUntypedMap, productStockWrpToInsertString, 
                                                    skuToManufacturerAlias, warehouse.Id, rowIndexToExistingIdMap, warehouseAliasToWarehouseMap, '', true);
        
    }
	
    /**
     * @author Abdoulaye DIOP
     * @date Creation 15/02/2019
     * @version 1.0
     * @description Test of the method  saveCsvData when stock serials contains product stock
     */
    @isTest
    static void saveCsvDataWhenStockSerialsContainsProductTest(){
        //line 974        
        Map<String, String> rowIndexToExistingIdMap = new Map<String, String>();
        List<Bit2Shop__Stock_Serials2__c> bitStockSerials = [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        Integer i= 0;
        for(Bit2Shop__Stock_Serials2__c bitStockSerial :  bitStockSerials){
            rowIndexToExistingIdMap.put(i+'', bitStockSerial.Id);
            i++;
        }
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer 03', account, '466663');
        bit2ShopDealer.Plc_Repairer__c = true;
        bit2ShopDealer.Plc_DealerManufacturer__c = true;
        insert bit2ShopDealer;
        
        Bit2Shop__Warehouse__c warehouse = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = '456935' Limit 1];
        Map<String, List<Object>> modelSkuProductStockUntypedMap = new Map<String, List<Object>>();
        
        Plc_Solution__c plcSolution = [SELECT Id FROM Plc_Solution__c LIMIT 1];
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, 'Test 256', 'Process');
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat.Plc_Manufacturer__c = bit2ShopDealer.Id;
        b2wExtCatExtCat.Bit2Shop__Product_Description__c = 'description';
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, warehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;
        
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('5524584623');
        insert plcTermId;

        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bnit2ShopStockSerials2.Bit2Shop__Status__c = 'New';
        bnit2ShopStockSerials2.Bit2Shop__Serial_Number__c = 'bit2ShopSerial';
        bnit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c= warehouse.Id;
        bnit2ShopStockSerials2.Plc_TermId__c = plcTermId.Id;
        bnit2ShopStockSerials2.Plc_Property__c = 'Nexi';
        bnit2ShopStockSerials2.Plc_PTSCode__c='ptccode';
        bnit2ShopStockSerials2.Bit2Shop__ICCID__c='bit2ShopICCID';
        bnit2ShopStockSerials2.Bit2Shop__IMEI__c='bit2ShopIMEI';
        bnit2ShopStockSerials2.Plc_PcipedModel__c='plc_PcipedModel';
        bnit2ShopStockSerials2.Plc_PcipedLetterOfApproval__c='plcPcipedLetterOfApproval';
        bnit2ShopStockSerials2.Plc_PcipedApprovalNumber__c='plcPcipedApprovalNumber';
        bnit2ShopStockSerials2.Plc_PcipedVersion__c='plcPcipedVersion';
        bnit2ShopStockSerials2.Plc_PcipedExpiryDate__c= System.today();

        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'value11'; 
        bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'Test03';
        bnit2ShopStockSerials2.Plc_Property__c='N';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumberUnique__c = '452634569';
        bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        insert bnit2ShopStockSerials2;
        
        Map<String, List<Object>> modelSkuWarehouseToProductStockUntypedMap = new Map<String, List<Object>>();
        //modelSkuWarehouseToProductStockUntypedMap.put('', new List<String>{bit2ShopProductStock.Id});
        
        ProductStockWrp productStockWrp = new ProductStockWrp();
        productStockWrp.warehouseId = warehouse.Id;
        productStockWrp.modelId = b2wExtCatExtCat.Id;
        productStockWrp.modelName = 'modelName';
        productStockWrp.warehouseAlias = 'warehouseAlias';
        productStockWrp.sku = 'sku';
        
        String productStockWrpToInsertString = JSON.serialize(new List<ProductStockWrp>{productStockWrp});
        Map<String, String> skuToManufacturerAlias = new Map<String, String>();
        skuToManufacturerAlias.put(b2wExtCatExtCat.Id , b2wExtCatExtCat.Plc_Alias__c);
        
        Map<String, Bit2Shop__Warehouse__c> warehouseAliasToWarehouseMap = new Map<String, Bit2Shop__Warehouse__c>();
		
        String csvFile1 = 'value1,value2,'+bit2ShopProductStock.Id+',sku,'+b2wExtCatExtCat.Id+',2,6,8,2,2,'+System.today().format()+',8,'+System.today().format()+',2,4\n';
        List<String> csvAsList = new List<String>{csvFile1};
            
        Test.startTest();
        Plc_StockSerialsImportUploadCnt.saveCsvData(csvAsList, modelSkuWarehouseToProductStockUntypedMap, productStockWrpToInsertString, 
                                                    skuToManufacturerAlias, warehouse.Id, rowIndexToExistingIdMap, warehouseAliasToWarehouseMap, '', false);
        
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye DIOP
     * @date Creation 18/02/2019
     * @version 1.0
     * @description Test of the method retrieveAvailableWarehouses
     */
    @isTest
    static void retrieveAvailableWarehousesTest(){
        
        String searchKey = 'Test';
        Test.startTest();
        Plc_StockSerialsImportUploadCnt.retrieveAvailableWarehouses(searchKey);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye DIOP
     * @date Creation 19/02/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile whether current user can decide the status other than 'New'
     */
    @isTest
    static void parseCsvInputfileCheckingCurrentUser(){
        
        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed'];
        
        String csvFile = 'field1,field2,field3\n';
        csvFile += ' ,test, ,test,'+warehouses[0].Plc_Alias__c+',withdrawn,1,test,test,test,test,test,'+System.today().format()+',1.5\n';
        csvFile += ' ,test, , ,'+warehouses[0].Plc_Alias__c+',withdrawn,1,test,test,test,test,test,'+System.today().format()+',1.5\n'; //line 322
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);

        Test.startTest();
        System.runAs(Plc_TestFactory.createUser('ad', 'Costruttore')) {
            Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        }
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye DIOP
     * @date Creation 19/02/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile whether current user can decide the status other than 'New'
     */
    @isTest
    static void parseCsvWhenProductSkuExistTest(){
        
        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c != 'Installed'];
        
        String csvFile = 'field1,field2,field3\n';
        csvFile += ' ,test, ,test,'+warehouses[0].Plc_Alias__c+',withdrawn,1,test,test,test,test,test,'+System.today().format()+',1.5\n';
        
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);
        
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 04/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile whether input file length is greater than fixed length
     */
    @isTest
    static void parseCsvUsingDivideEtImperaAlgorithmTest(){

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c 
                                                   FROM Bit2Shop__Warehouse__c
                                                   WHERE Plc_Tipology__c != 'Installed'];
        String csvFile = 'Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test\n';
        //Need to load a file with at least 200000 characters
        for (Integer i = 0; i < 3400; i++) {
            csvFile += 'Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test\n';
        }

        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);
        
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 04/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile when serials are not alphanumeric
     */
    @isTest
    static void parseCsvNotAlpanumericSerialsTest(){

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c 
                                                   FROM Bit2Shop__Warehouse__c
                                                   WHERE Plc_Tipology__c != 'Installed'];

        String csvFile = 'Header,could,be,everything\n';
        csvFile += 'Test.,Test.,Test.,Test,Test,Test,Test,Test,Test,Test,Test,Test\n';
        
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);
        
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 04/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile when csv file contains just blank lines
     */
    @isTest
    static void parseCsvMultipleBlankLinesTest(){

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c 
                                                   FROM Bit2Shop__Warehouse__c
                                                   WHERE Plc_Tipology__c != 'Installed'];

        String csvFile = '\n\n  \n\n   \t\n \n';
        
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);
        
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 04/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile when csv file contains just blank lines
     */
    @isTest
    static void parseCsvWarehouseOfInstalledTest(){

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c 
                                                   FROM Bit2Shop__Warehouse__c
                                                   WHERE Plc_Tipology__c = 'Installed'];

        String csvFile = 'Header,could,be,everything\n';
        csvFile += 'Test.,Test.,Test.,Ajeje,Test,Test,Test,Test,Test,Test,Test,Test\n';
        
        Blob csv = Blob.valueOf(csvFile);
        String csvString = EncodingUtil.base64Encode(csv);
        
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 04/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile when serials are duplicated
     */
    @isTest
    static void parseCsvFindDuplicatesTest(){

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c 
                                                   FROM Bit2Shop__Warehouse__c
                                                   WHERE Plc_Alias__c = '456935'];

        String csvFileDuplicatedManufacturer = 'Header,could,be,everything\nTest,,,Test\n';
        String csvFileDuplicatedEncoded = 'Header,could,be,everything\n,Test,,Test\n';
        String csvFileDuplicatedDll = 'Header,could,be,everything\n,,Test,Test\n';
        
        String csvStringManufacturer = EncodingUtil.base64Encode(Blob.valueOf(csvFileDuplicatedManufacturer));
        String csvStringEncoded = EncodingUtil.base64Encode(Blob.valueOf(csvFileDuplicatedEncoded));
        String csvStringDll = EncodingUtil.base64Encode(Blob.valueOf(csvFileDuplicatedDll));

        Test.startTest();
        Map<String, Object> response1 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringManufacturer, warehouses[0].Id, '', false);
        Map<String, Object> response2 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringEncoded, warehouses[0].Id, '', false);
        Map<String, Object> response3 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringDll, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 04/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile when serials duplicates are decomissioned
     */
    @isTest
    static void parseCsvFindDuplicatesDecomissionedTest(){

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c 
                                                   FROM Bit2Shop__Warehouse__c
                                                   WHERE Plc_Tipology__c != 'Installed'];

        String csvFileDuplicatedManufacturer = 'Header,could,be,everything\nTestDec,,,Test\n';
        String csvFileDuplicatedEncoded = 'Header,could,be,everything\n,TestDec,,Test\n';
        String csvFileDuplicatedDll = 'Header,could,be,everything\n,,TestDec,Test\n';
        
        String csvStringManufacturer = EncodingUtil.base64Encode(Blob.valueOf(csvFileDuplicatedManufacturer));
        String csvStringEncoded = EncodingUtil.base64Encode(Blob.valueOf(csvFileDuplicatedEncoded));
        String csvStringDll = EncodingUtil.base64Encode(Blob.valueOf(csvFileDuplicatedDll));

        Test.startTest();
        Map<String, Object> response1 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringManufacturer, warehouses[0].Id, '', false);
        Map<String, Object> response2 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringEncoded, warehouses[0].Id, '', false);
        Map<String, Object> response3 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringDll, warehouses[0].Id, '', false);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 27/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile when serial is updated
     */
    @isTest
    static void parseCsvFindSerialToUpdateTest(){

        Bit2Shop__Stock_Serials2__c serial = [SELECT Id, Bit2Shop__Warehouse_Id__r.Plc_Alias__c, Plc_ProductSku__c 
                                              FROM Bit2Shop__Stock_Serials2__c 
                                              LIMIT 1];

        List<Bit2Shop__Warehouse__c> warehouses = [SELECT Plc_Alias__c 
                                                   FROM Bit2Shop__Warehouse__c
                                                   WHERE Plc_Tipology__c = 'Installed'];

        String csvFileSerialToUpdate = 'Header,could,be,everything,yes,yes\n' + serial.Id + ',' + 
                                        serial.Bit2Shop__Warehouse_Id__r.Plc_Alias__c + ',,,,' + serial.Plc_ProductSku__c +',\n';
        String csvFileSerialToUpdateKo1 = 'Header,could,be,everything,yes,yes\nTest,' + 
                                           serial.Bit2Shop__Warehouse_Id__r.Plc_Alias__c + ',,,,' + serial.Plc_ProductSku__c +',\n';
        String csvFileSerialToUpdateKo2 = 'Header,could,be,everything,yes,yes\n' + serial.Id + ',' + 
                                           warehouses.get(0).Plc_Alias__c + ',,,,' + serial.Plc_ProductSku__c +',\n';
        String csvFileSerialToUpdateKo3 = 'Header,could,be,everything,yes,yes\n' + warehouses.get(0).Id + ',' + 
                                           serial.Bit2Shop__Warehouse_Id__r.Plc_Alias__c + ',,,,' + serial.Plc_ProductSku__c +',\n';
        
        String csvStringFileSerialToUpdate = EncodingUtil.base64Encode(Blob.valueOf(csvFileSerialToUpdate));
        String csvStringFileSerialToUpdateKo1 = EncodingUtil.base64Encode(Blob.valueOf(csvFileSerialToUpdateKo1));
        String csvStringFileSerialToUpdateKo2 = EncodingUtil.base64Encode(Blob.valueOf(csvFileSerialToUpdateKo2));
        String csvStringFileSerialToUpdateKo3 = EncodingUtil.base64Encode(Blob.valueOf(csvFileSerialToUpdateKo3));

        Test.startTest();
        Map<String, Object> response0 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringFileSerialToUpdate, '', '', true);
        Map<String, Object> response1 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringFileSerialToUpdateKo1, '', '', true);
        Map<String, Object> response2 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringFileSerialToUpdateKo2, '', '', true);
        Map<String, Object> response3 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvStringFileSerialToUpdateKo3, '', '', true);
        Test.stopTest();
    }

    /**
     * @author Francesco Bigoni
     * @date Creation 04/03/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile when serials duplicates are decomissioned
     */
    @isTest
    static void retrieveUpdateReportTest() { 
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsImportUploadCnt.retrieveUpdateReport();
        Test.stopTest();
    }

    /* Wrapper class used to represent product stock to insert */
    private class ProductStockWrp {
        String warehouseId;
        String modelId;
        String modelName;
        String warehouseAlias;
        String sku;
    }

	/**
     * @author Abdoulaye DIOP
     * @date Creation 19/02/2019
     * @version 1.0
     * @description Test of the method parseCsvInputfile whether current user can decide the status other than 'New'
     */
    /*@isTest
    static void test(){
        
        //00789654123654789
        Bit2Shop__Warehouse__c warehouse = [SELECT Id, Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c = '456935' LIMIT 1];
        System.debug('### warehouse ### '+ JSON.serialize(warehouse));
        String csvFile3 = 'field1,field2,field3\n';
        csvFile3 += ' ,test, ,Test,'+warehouse.Plc_Alias__c+', ,1,test,test,test,test,test,'+System.today().format()+',1.5\n';
        
        Blob csv3 = Blob.valueOf(csvFile3);
        String csvString3 = EncodingUtil.base64Encode(csv3);
        
        List<Bit2Shop__Stock_Serials2__c> stockSerials = [SELECT Id, Bit2Shop__Status__c, 
                                                                   Plc_EncodedSerialNumber__c
                                                            FROM Bit2Shop__Stock_Serials2__c
                                                             ];
        
        System.debug('### stockSerials ### '+ JSON.serialize(stockSerials));
        Test.startTest();
        Map<String, Object> response3 = Plc_StockSerialsImportUploadCnt.parseCsvInputfile(csvString3, warehouse.Id);
        Test.stopTest();
        
    }*/
    
}