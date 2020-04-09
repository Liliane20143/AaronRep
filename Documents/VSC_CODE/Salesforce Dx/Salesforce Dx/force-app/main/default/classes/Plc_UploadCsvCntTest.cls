/**
 * @author Shahid Khan
 * @date Creation 13/02/2019
 * @Modify 18/02/2019 by Mame Dairra
 * @version 1.0
 * @description Test of Plc_UploadCsvCnt.
 */
 @isTest
 public class Plc_UploadCsvCntTest {
     
    @TestSetup
    static void setup(){
    
        Plc_TestFactory.initProcessClickPackage();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'New');
        bit2ShopDealer.Plc_Alias__c = 'Test';
        bit2ShopDealer.Plc_Manufacturer__c = true;
        bit2ShopDealer.Plc_DealerManufacturer__c = true;
        insert bit2ShopDealer;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('Aspiag', 'Repaired','','000001NEXI',bit2ShopDealer);
        bit2ShopWarehouse.Plc_Tipology__c = 'New';
        bit2ShopWarehouse.Plc_CoverageIndex__c = 1;
        bit2ShopWarehouse.Plc_LogisticDivision__c = '';
        insert bit2ShopWarehouse;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'test','type');
        b2wExtCatExtCat.Plc_Manufacturer__c = bit2ShopDealer.Id;
        insert b2wExtCatExtCat;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat1 = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'test','type');
        b2wExtCatExtCat1.Plc_Manufacturer__c = bit2ShopDealer.Id;
        
        b2wExtCatExtCat1.Plc_ProductSku__c='1';
        insert b2wExtCatExtCat1;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c =2;
        bit2ShopProductStock.Plc_WithdrawnQty__c=1;
        insert bit2ShopProductStock;

        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('Testupl');
        insert plcTermId;
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2= Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'value1';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'Test';
        bnit2ShopStockSerials2.Plc_DllSerialNumberUnique__c = 'serialNumbers';
        bnit2ShopStockSerials2.Plc_Property__c='N';
        bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id ;
        bnit2ShopStockSerials2.Plc_DllSerialNumberUnique__c = 'test_serialNumbers';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumberUnique__c = 'test_serialNumbers';
        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumberUnique__c = 'test_serialNumbers';
        
        insert bnit2ShopStockSerials2;

        /************/
        Bit2Shop__Stock_Serials2__c stockSerial = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        stockSerial.Plc_ManufacturerSerialNumber__c = 'MAN1';
        stockSerial.Plc_Property__c = 'N';
        stockSerial.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;

        Bit2Shop__Stock_Serials2__c stockSerial2 = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        stockSerial2.Plc_EncodedSerialNumber__c = 'ENC1';
        stockSerial2.Plc_Property__c = 'N';
        stockSerial2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;

        Bit2Shop__Stock_Serials2__c stockSerial3 = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        stockSerial3.Plc_DllSerialNumber__c = 'DLL1';
        stockSerial3.Plc_Property__c = 'N';
        stockSerial3.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        
        insert new List<Bit2Shop__Stock_Serials2__c>{stockSerial, stockSerial2, stockSerial3};

        stockSerial.Plc_EncodedSerialNumber__c = '';
        stockSerial.Plc_DllSerialNumber__c = '';
        stockSerial2.Plc_ManufacturerSerialNumber__c = '';
        stockSerial2.Plc_DllSerialNumber__c = '';
        stockSerial3.Plc_ManufacturerSerialNumber__c = '';
        stockSerial3.Plc_EncodedSerialNumber__c = '';

        update new List<Bit2Shop__Stock_Serials2__c>{stockSerial2, stockSerial3};

        system.debug('### ss1 ' + stockSerial);
        system.debug('### ss1 ' + stockSerial2);
        system.debug('### ss1 ' + stockSerial3);
        
        /********************/

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials.Plc_PurchaseDate__c = System.today();                                                                                        
        bit2ShopStockSerials.Plc_DllSerialNumberUnique__c = 'Test_';
        
        insert bit2ShopStockSerials;
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials1 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials1.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials1.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials1.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials1.Plc_PurchaseDate__c = System.today();                                                                                        
        bit2ShopStockSerials1.Plc_DllSerialNumberUnique__c = 'test_test1';
        insert bit2ShopStockSerials1;
        List<Bit2Shop__Stock_Serials2__c>filteredStockSerials = [SELECT Plc_ProductSku__c,Plc_DllSerialNumberUnique__c,Plc_EncodedSerialNumberUnique__c from Bit2Shop__Stock_Serials2__c where id =:bnit2ShopStockSerials2.id ];
        system.debug('=totalStock=='+filteredStockSerials);
        /*
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials2.Plc_PurchaseDate__c = System.today();                                                                                        
        bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c = 'manufacturerAlias_serialNumbers';
        insert bit2ShopStockSerials2;
        */
       
       /***/
        Bit2Shop__Dealer__c dealer2 = Plc_TestFactory.createDealer('dealer', account,'dealer2');
        dealer2.Plc_Manufacturer__c = true;
        dealer2.Plc_DealerManufacturer__c = true;
        insert dealer2;

        B2WExtCat__External_Catalog_Item__c model2 = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'model2','type');
        model2.Plc_Manufacturer__c = dealer2.Id;
        insert model2;

        Bit2Shop__Product_Stock__c productStock2 = Plc_TestFactory.createProductStock(model2, bit2ShopWarehouse);
        productStock2.Plc_UsableQty__c =2;
        productStock2.Plc_WithdrawnQty__c=1;
        insert productStock2;

        Bit2Shop__Stock_Serials2__c stockSerialModel2 = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'Withdrawn');
        stockSerialModel2.Plc_ManufacturerSerialNumber__c = 'MAN1';
        stockSerialModel2.Plc_Property__c='N';
        stockSerialModel2.Bit2Shop__Product_Stock_Id__c = productStock2.Id ;
        insert stockSerialModel2;

        Bit2Shop__Stock_Serials2__c stockSerial2Model2 = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'Withdrawn');
        stockSerial2Model2.Plc_EncodedSerialNumber__c = 'ENC1';
        stockSerial2Model2.Plc_Property__c='N';
        stockSerial2Model2.Bit2Shop__Product_Stock_Id__c = productStock2.Id ;
        insert stockSerial2Model2;

        Bit2Shop__Stock_Serials2__c stockSerial3Model2 = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'Withdrawn');
        stockSerial3Model2.Plc_DllSerialNumber__c = 'DLL1';
        stockSerial3Model2.Plc_Property__c='N';
        stockSerial3Model2.Bit2Shop__Product_Stock_Id__c = productStock2.Id ;
        insert stockSerial3Model2;

        stockSerialModel2.Plc_EncodedSerialNumber__c = '';
        stockSerialModel2.Plc_DllSerialNumber__c = '';
        stockSerial2Model2.Plc_ManufacturerSerialNumber__c = '';
        stockSerial2Model2.Plc_DllSerialNumber__c = '';
        stockSerial3Model2.Plc_ManufacturerSerialNumber__c = '';
        stockSerial3Model2.Plc_EncodedSerialNumber__c = '';

        update new List<Bit2Shop__Stock_Serials2__c>{stockSerialModel2, stockSerial2Model2, stockSerial3Model2};

        /***/
        
    }
     
    /**
    * @author Mame Diarra
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test of the method manageUpdateOperation.
    */
     /*
    @isTest
    static void checkCSVSerials1(){ 
        String SerialJson = '[{"serialNumbers":"","manufacturerAlias":"CHECK_BY_MANUFACTURER_ALIAS","productSku":"checkByProductSku","error":"err","processStep":"checkByProductSku","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        
        obj = Plc_UploadCsvCnt.checkCSVSerials('','test','');
        Test.stopTest();
    }
         @isTest
    static void checkCSVSerials2(){ 
        String SerialJson = '{"serialNumbers":"","manufacturerAlias":"CHECK_BY_MANUFACTURER_ALIAS","productSku":"checkByProductSku","error":"","processStep":"checkByProductSku","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'test','');
        Test.stopTest();
    }
    @isTest
    static void checkCSVSerials3(){ 
        String SerialJson = '[{"serialNumbers":"","manufacturerAlias":"CHECK_BY_MANUFACTURER_ALIAS","productSku":"test","error":"err","processStep":"checkByProductSku","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'',bitObj.Id);
        Test.stopTest();
    }
      @isTest
    static void checkCSVSerials4(){ 
        String SerialJson = '[{"serialNumbers":"","manufacturerAlias":"manufacturerAlias","productSku":"test","error":"","processStep":"checkByProductSku","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'',bitObj.Id);
        Test.stopTest();
    }
      @isTest
    static void checkCSVSerials5(){ 
        String SerialJson = '[{"serialNumbers":"","manufacturerAlias":"","productSku":"test","error":"","processStep":"","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'',bitObj.Id);
        Test.stopTest();
    }
        @isTest
    static void checkCSVSerials6(){ 
        String SerialJson = '[{"serialNumbers":"","manufacturerAlias":"test","productSku":"","error":"","processStep":"","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'',bitObj.Id);
        Test.stopTest();
    }
            @isTest
    static void checkCSVSerials7(){ 
        String SerialJson = '[{"serialNumbers":"serialNumbers","manufacturerAlias":"manufacturerAlias","productSku":"test","error":"","processStep":"","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'',bitObj.Id);
        Test.stopTest();
    }*/
    
    @isTest
    static void recordsToReturnInEvt(){
    List<Bit2Shop__Stock_Serials2__c> listOfObjs = new List<Bit2Shop__Stock_Serials2__c>();
    List<Plc_UploadCsvCnt.CSVSerials> lists = new List<Plc_UploadCsvCnt.CSVSerials>();
    Plc_UploadCsvCnt.CSVSerials obj = new Plc_UploadCsvCnt.CSVSerials();
    obj.serialNumbers = '';obj.manufacturerAlias = '';obj.productSku='';obj.error='';obj.processStep='';obj.csvLinePosition='';
    lists.add(obj);
    Test.startTest();
    listOfObjs = Plc_UploadCsvCnt.recordsToReturnInEvt(lists);
    Test.StopTest();
    }
    /**
    * @Modify 13/03/2019 by Mame Diarra
    * @version 1.0
    * @description Test of checkCSVSerials method when manufacturerAlias is empty.
    */
     
    @isTest
    static void checkCSVSerials8(){ 
        String serialsToCheck;
        String stockSerialStatus;
        String warehouseId;
        String distributionListItemModels='test';
        String SerialJson = '[{},{"serialNumbers":"serialNumbers","manufacturerAlias":"manufacturerAlias","productSku":" ","error":"error","processStep":"","csvLinePosition":""}]';
        Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'',bitObj.Id,distributionListItemModels, null);
        Test.stopTest();
    }
    /**
    * @Modify 13/03/2019 by Mame Diarra
    * @version 1.0
    * @description Test of checkCSVSerials method when manufacturerAlias is not null.
    */
    @isTest
    static void checkCSVSerials9(){ 
        String distributionListItemModels='test';
        String SerialJson = '[{"serialNumbers":"serialNumbers","manufacturerAlias":"Test","productSku":"test","error":"","processStep":"composeListOfCSVserials1","csvLinePosition":""}]';
        Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'',bitObj.Id,distributionListItemModels, null);
        Plc_UploadCsvCnt cnt = new Plc_UploadCsvCnt();
        //when manufacturerAlias not equals Plc_Alias
        String SerialJson2 = '[{"productSku":"t","processStep":" "},{"serialNumbers":"serialNumbers","manufacturerAlias":"Tests","productSku":"test","error":"","processStep":"composeListOfCSVserials1","csvLinePosition":""}]';
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson2,'',bitObj.Id,distributionListItemModels, null);
        //cnt.composeListOfCSVserials([select id,Plc_ProductSku__c,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c,Plc_Model__c from Bit2Shop__Stock_Serials2__c]);
        Test.stopTest();
    }
    @isTest
    static void checkCSVSerials10(){ 
        String distributionListItemModels='test'; 
        String SerialJson = '["serialNumbers":"serialNumbers","manufacturerAlias":"manufacturerAlias","productSku":"test","error":"","processStep":"","csvLinePosition":""}]';
        Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'status;status1',bitObj.Id,distributionListItemModels, null);
        Test.stopTest();
    }
    @isTest
    static void checkCSVSerials11(){ 
        String distributionListItemModels='test';
        String SerialJson = '[]';
        Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'status;status1',bitObj.Id,distributionListItemModels, null);
        Test.stopTest();
    }
    @isTest
    static void checkCSVSerials12(){ 
        String distributionListItemModels='test';
        String SerialJson = '[{"serialNumbers":"Test","manufacturerAlias":"Test","productSku":"test","error":"","processStep":"","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'status;status1',bitObj.Id,distributionListItemModels, null);
        Test.stopTest();
    }
    @isTest
    static void checkCSVSerials13(){ 
        String distributionListItemModels='test';
        String SerialJson = '[{"serialNumbers":"value1","manufacturerAlias":"Test","productSku":"test","error":"","processStep":"","csvLinePosition":""}]';
        Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'status;status1',bitObj.Id,distributionListItemModels, null);
        
        List<Bit2Shop__Stock_Serials2__c>filteredStockSerials1 = [SELECT Plc_ProductSku__c,Plc_DllSerialNumberUnique__c,Plc_EncodedSerialNumberUnique__c from Bit2Shop__Stock_Serials2__c LIMIT 3 ]; 
        system.debug('=totalStockss=='+filteredStockSerials1);
        Test.stopTest();
    }

    /**
     * @author FB
     * @date 07/06/2019
     * @version 1.0
     */
    @isTest
    static void checkCSVSerials13b(){ 
        String distributionListItemModels='test';
        String SerialJson = '[{"serialNumbers":"value1","manufacturerAlias":"Test","productSku":"test","error":"","processStep":"","csvLinePosition":""}]';
        Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Bit2Shop__Stock_Serials2__c ss2 = [Select Id from Bit2Shop__Stock_Serials2__c WHERE Plc_EncodedSerialNumber__c = 'value1'];
        ss2.Plc_ManufacturerSerialNumber__c = '';
        update ss2;
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'status;status1',bitObj.Id,distributionListItemModels, null);
        Test.stopTest();
    }

    @isTest
    static void checkCSVSerials14(){ 
        String distributionListItemModels='test';
        String SerialJson = '[{"serialNumbers":"","manufacturerAlias":"","productSku":"test","error":"","processStep":"","csvLinePosition":""}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'status;status1',bitObj.Id,distributionListItemModels, null);
        Test.stopTest();
    }
    @isTest
    static void checkCSVSerials15(){ 
        String distributionListItemModels='test';
        String SerialJson = '[{"serialNumbers":"test","manufacturerAlias":"test1","productSku":"productSku","error":"","processStep":"processStep","csvLinePosition":"1"}]';
       Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials(SerialJson,'status;status1',bitObj.Id,distributionListItemModels, null);
        Test.stopTest();
    }
    @isTest
    static void checkCSVSerials16(){ 
        String distributionListItemModels='test';
        String SerialJson = '[{"serialNumbers":"test","manufacturerAlias":"test1","productSku":"productSku","error":"","processStep":"processStep","csvLinePosition":"1"}]';
        Account bitObj = [Select Id from Account];
        Map<String, Object> obj = new Map<String, Object>();
        // Start test
        Test.startTest();
        obj = Plc_UploadCsvCnt.checkCSVSerials('','status;status1',null,distributionListItemModels, null);
        Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 13/03/2019
    * @version 1.0
    * @description Test exception of the method checkCSVSerials.
    */
    @isTest
     static void checkCSVSerialsKO(){
         
         Test.startTest();
         Bit2Shop__Warehouse__c bitObj = [Select Id from Bit2Shop__Warehouse__c];
         Map<String, Object> obj  = Plc_UploadCsvCnt.checkCSVSerials('[{]}',null,bitObj.Id,'', null);
         Test.stopTest();
     }

   /**
    * @author FB
    * @date 09/05/2019
    * @version 1.0
    * @description Test of the method checkCSVSerials.
    */
    @isTest
     static void checkCSVSerialsOK1(){

        Bit2Shop__Warehouse__c bitObj = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];

        Test.startTest();
        Map<String, Object> obj  = Plc_UploadCsvCnt.checkCSVSerials('[{"serialNumbers": "MAN1", "manufacturerAlias": "", "productSku": "", "error": "", "processStep": "processStep", "csvLinePosition": "1"}]',null,bitObj.Id,'', null);
        Map<String, Object> obj2  = Plc_UploadCsvCnt.checkCSVSerials('[{"serialNumbers": "DLL1", "manufacturerAlias": "", "productSku": "", "error": "", "processStep": "processStep", "csvLinePosition": "2"}]',null,bitObj.Id,'', null);
        Map<String, Object> obj3  = Plc_UploadCsvCnt.checkCSVSerials('[{"serialNumbers": "ENC1", "manufacturerAlias": "", "productSku": "", "error": "", "processStep": "processStep", "csvLinePosition": "3"}]',null,bitObj.Id,'', null);
        Test.stopTest();
    }

   /**
    * @author FB
    * @date 28/06/2019
    * @version 1.0
    * @description Test with technician fixed
    */
    @isTest
     static void checkCSVSerialsOK2(){

        Bit2Shop__Warehouse__c bitObj = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        Map<String, Object> configurationMap = new Map<String, Object>{
            'technicianWithdrawnManagement' => true,
            'technicianName' => 'Mario Rossi'
        };
        Test.startTest();
        Map<String, Object> obj  = Plc_UploadCsvCnt.checkCSVSerials('[{"serialNumbers": "MAN1", "manufacturerAlias": "", "productSku": "", "error": "", "processStep": "processStep", "csvLinePosition": "1"}]',
                                                                      null, bitObj.Id, '', configurationMap);
        Test.stopTest();
    }

   /**
    * @author FB
    * @date 28/06/2019
    * @version 1.0
    * @description Test with technician in the csv column
    */
    @isTest
     static void checkCSVSerialsOK3(){

        Bit2Shop__Warehouse__c bitObj = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        Map<String, Object> configurationMap = new Map<String, Object>{
            'technicianWithdrawnManagement' => true,
            'technicianName' => null
        };
        Test.startTest();
        Map<String, Object> obj  = Plc_UploadCsvCnt.checkCSVSerials('[{"serialNumbers": "ENC1", "manufacturerAlias": "", "productSku": "", "error": "", "processStep": "processStep", "csvLinePosition": "1", "technician" : "Mario Rossi"}]',
                                                                      null, bitObj.Id, '', configurationMap);
        Test.stopTest();
    }
}