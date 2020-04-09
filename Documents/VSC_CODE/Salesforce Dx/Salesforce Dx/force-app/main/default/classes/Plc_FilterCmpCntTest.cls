/**
 * @author Abdoulaye & Moussa
 * @date Creation 29/01/2019
 * @Modify 19/02/2019 by Mame Diarra
 * @Modify 04/03/2019 by Mame Diarra
 * @version 1.0
 * @description Test of Plc_FilterCmpCnt.
 */
@isTest
public class Plc_FilterCmpCntTest {
    
    @TestSetup
    static void makeData(){

        Plc_TestFactory.initProcessClickPackage();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Id recordType=Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'Test');
        bit2ShopDealer.RecordTypeId=recordType;
        bit2ShopDealer.Plc_Repairer__c =true;
        //bit2ShopDealer.Plc_Manufacturer__c=TRUE;
        insert bit2ShopDealer;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Repaired','','000001NEXI', bit2ShopDealer);
        insert bit2ShopWarehouse;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'test','Process');
        b2wExtCatExtCat.Plc_Alias__c = '00541237896541230';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        insert b2wExtCatExtCat;

        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_WithdrawnQty__c=1;
        insert bit2ShopProductStock;

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials.Plc_PurchaseDate__c = System.today();
        insert bit2ShopStockSerials;
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 08/02/2019
     * @version 1.0
     * @description return a JSON of InputString.
     */
    public static String getData(){

        Bit2Shop__Stock_Serials2__c stock = [SELECT  Plc_ProductSku__c, Plc_Manufacturer__c, Bit2Shop__Serial_Number__c,Bit2Shop__Status__c,
                    Plc_PurchaseDate__c, Plc_DllSerialNumber__c,  Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        InputString input = getInputString(stock.Plc_ProductSku__c, stock.Plc_PurchaseDate__c+'', stock.Plc_PurchaseDate__c+'', 
                                                                                            stock.Plc_Manufacturer__c, stock.Bit2Shop__Status__c);
        String inputString = JSON.serialize(input);

        return inputString;
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method applyFilters.
     */
    @isTest
    static void applyFiltersTest(){
        
        Map<String, String> myMap = new Map<String, String>();
        myMap.put('Bit2Shop__Stock_Serials2__c', 'Bit2Shop__ICCID__c = null');
        
        Bit2Shop__Stock_Serials2__c stock = [SELECT  Plc_ProductSku__c, Plc_Manufacturer__c, Bit2Shop__Serial_Number__c,Bit2Shop__Status__c,
                    Plc_PurchaseDate__c, Plc_DllSerialNumber__c,  Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        InputString input = getInputString(stock.Plc_ProductSku__c, stock.Plc_PurchaseDate__c+'', stock.Plc_PurchaseDate__c+'', 
                                                                                            stock.Plc_Manufacturer__c, stock.Bit2Shop__Status__c);
        String inputString = JSON.serialize(input);

        Test.startTest();
        
        Plc_FilterCmpCnt.applyFilters(null, myMap);
        
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        
        // when input.inputString is empty line 232
        input.inputString = '';
        String inputString2 = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString2, myMap);
        
        // when rangeMatricolaA, rangeMatricolaDa && inputString are empty line 240
        input.inputString = '';
        input.rangeMatricolaDa = '';
        input.rangeMatricolaA = '';
        String inputString3 = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString3, myMap);
        
        /* when rangeMatricolaA, rangeMatricolaDa, inputString, manufacturer */
        input.manufacturer = '';
        String inputString4 = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString4, myMap);
        
        // when additionalFilters is not empty 
        String inputString5 = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString5, myMap);
        
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 07/02/2019
     * @version 1.0
     * @description Test of the method applyFilters.
     */
    @isTest
    static void applyFiltersFullTest(){

        Map<String, String> myMap = new Map<String, String>();
        myMap.put('SLI_StockSerials', 'Plc_ExternalProductStock__c = null'); 
        myMap.put('SLI_ProductStocks', 'Plc_ExternalProductStock__c = null');
        myMap.put('originWarehouse', '');

        Bit2Shop__Stock_Serials2__c stock = [SELECT  Plc_ProductSku__c, Plc_Manufacturer__c, Bit2Shop__Serial_Number__c,Bit2Shop__Status__c,
                    Plc_PurchaseDate__c, Plc_DllSerialNumber__c,  Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        InputString input = getInputString(stock.Plc_ProductSku__c, stock.Plc_PurchaseDate__c+'', stock.Plc_PurchaseDate__c+'', 
                                                                                            stock.Plc_Manufacturer__c, stock.Bit2Shop__Status__c);
        String inputString = JSON.serialize(input);

        Test.startTest();
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        Test.stopTest();
        
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 06/02/2019
     * @version 1.0
     * @description Test of the method applyFilters.
     */
    //@isTest
    static void applyFiltersWhenLimitExceteedTest(){
        String choosenCase = 'Bit2Shop__Stock_Serials2__c';
        Map<String, String> myMap = new Map<String, String>();
        myMap.put('Bit2Shop__Stock_Serials2__c', '');

        Bit2Shop__Stock_Serials2__c bit2ShopStock = [SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];        
        
        
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year()+ 1000000, dT.month(), dT.day());

        Bit2Shop__Stock_Serials2__c stock = [SELECT  Plc_ProductSku__c, Plc_Manufacturer__c, Bit2Shop__Serial_Number__c,Bit2Shop__Status__c,
                    Plc_PurchaseDate__c, Plc_DllSerialNumber__c,  Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        InputString input2 = getInputString(stock.Plc_ProductSku__c, stock.Plc_PurchaseDate__c+'', myDate+'', 
                                                                                            stock.Plc_Manufacturer__c, stock.Bit2Shop__Status__c);
        String inputString2 = JSON.serialize(input2);

        Test.startTest();
        Plc_FilterCmpCnt.applyFilters(inputString2, myMap);
        Test.stopTest();
        
    }
    
    /**
     * @author Mame Diarra
     * @Modified by Abdoulaye
     * @date Creation 05/02/2019
     * @version 1.0
     * @description Test of the method getPicklistOptions.
     */
    @isTest
    static void getPicklistOptionsTest(){
        String fieldName = 'Plc_Property__c';
        String sObjectName = 'Bit2Shop__Stock_Serials2__c';
        Test.startTest();
        List<Plc_FilterCmpCnt.picklistEntryObj> result=Plc_FilterCmpCnt.getPicklistOptions(fieldName,sObjectName);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 07/02/2019
     * @version 1.0
     * @description Test of the method findNumberInsideString when stringToScan is not in normal format.
     */
    @isTest
    static void findNumberInsideString(){
        String stringToScan = '100000000000000000000000test';

        Test.startTest();
        Plc_FilterCmpCnt.findNumberInsideString(stringToScan);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method applyFilters.
     */
    @isTest
    static void applyFiltersWhenAdditionalFiltersTest(){
        Map<String, String> myMap = new Map<String, String>();
        
        myMap.put('Bit2Shop__Stock_Serials2__c', 'Bit2Shop__ICCID__c = null');
        
        Bit2Shop__Stock_Serials2__c stock = [SELECT  Plc_ProductSku__c, Plc_Manufacturer__c, Bit2Shop__Serial_Number__c,Bit2Shop__Status__c,
                    Plc_PurchaseDate__c, Plc_DllSerialNumber__c,  Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        InputString input = getInputString(stock.Plc_ProductSku__c, stock.Plc_PurchaseDate__c+'', stock.Plc_PurchaseDate__c+'', 
                                                                                         stock.Plc_Manufacturer__c, stock.Bit2Shop__Status__c);
        String inputString = JSON.serialize(input);

        Test.startTest();
        
        //Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        
        Plc_FilterCmpCnt.applyFilters(JSON.serialize('Ingenico'), myMap);

        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 08/02/2019
     * @version 1.0
     * @description Test of the method applyFilters when myMap containskey Bit2Shop__Product_Stock__c .
     */
    @isTest
    static void applyFiltersWhenBit2ShopProductStockTest(){

        Map<String, String> myMap = new Map<String, String>();
        myMap.put('Bit2Shop__Product_Stock__c', 'Plc_ExternalReferencePeriod__c = null');
        
        String inputString = Plc_FilterCmpCntTest.getData();

        Test.startTest();
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);

        InputString input = new InputString();
        inputString = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        Test.stopTest();

    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 15/02/2019
     * @version 1.0
     * @description Test of the method applyFilters when myMap containskey FromGoodsHandling .
     */
    @isTest
    static void applyFiltersWhenFromGoodsHandlingTest(){
        
        Map<String, String> myMap = new Map<String, String>();
        myMap.put('fromGoodsHandling', 'Plc_ExternalReferencePeriod__c = null');

        Bit2Shop__Stock_Serials2__c stock = [SELECT  Plc_ProductSku__c, Plc_Manufacturer__c, Bit2Shop__Serial_Number__c,Bit2Shop__Status__c,
                    Plc_PurchaseDate__c, Plc_DllSerialNumber__c,  Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        InputString input = getInputString(stock.Plc_ProductSku__c, stock.Plc_PurchaseDate__c+'', stock.Plc_PurchaseDate__c+'', 
                                                                                            stock.Plc_Manufacturer__c, stock.Bit2Shop__Status__c);
        String inputString = JSON.serialize(input);
        
        Bit2Shop__Warehouse__c warehouse = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        myMap.put('originWarehouse', warehouse.Id+'');
        
        Test.startTest();
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        
        input.inputString = ''; 
        inputString = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        
        input.rangeMatricolaA = '';
        input.rangeMatricolaDa = '';
        inputString = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        
        input.manufacturer = '';
        inputString = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        
        input.status = '';
        inputString = JSON.serialize(input);
        Plc_FilterCmpCnt.applyFilters(inputString, myMap);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 29/01/2019
     * @version 1.0
     * @description create an instance of Plc_FilterCmpCnt.inputString
     * @param String input This parameter inputString.
     * @param String rangeMatricolaDa this parameter is the rangeMatricolaDa
     * @param String rangeMatricolaA this parameter is the rangeMatricolaA
     * @param String manufacturer is the manufacturer
     * @param String status is the status
     * @return inputString.
     */
    private static InputString getInputString(String input, String rangeMatricolaDa, String rangeMatricolaA, String manufacturer, String status){
        
        InputString inputString = new InputString();
        
        inputString.inputString = input;
        inputString.rangeMatricolaDa = rangeMatricolaDa;
        inputString.rangeMatricolaA = rangeMatricolaA;
        inputString.manufacturer = manufacturer;
        inputString.status = status;
        return inputString;
    }
    
    /**
     * @author Abdoulaye DIOP & Moussa FOFANA
     * @date Creation 29/01/2019
     * @version 1.0
     * @description it's the class InputString
     */
    private class InputString {
        @AuraEnabled
        String inputString { get; set; }
        @AuraEnabled
        String rangeMatricolaDa { get; set; }
        @AuraEnabled
        String rangeMatricolaA { get; set; }
        @AuraEnabled
        String manufacturer { get; set; }
        @AuraEnabled
        String status { get; set; }
    }
}