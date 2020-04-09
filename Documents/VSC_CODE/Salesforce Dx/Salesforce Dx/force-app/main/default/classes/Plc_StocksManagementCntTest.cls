/**
 * @author Abdoulaye & Moussa
 * @date Creation 05/02/2019
 * @Modify : Moussa FOFANA on 2019/03/28
 * @version 1.0
 * @description Test of Plc_StocksManagementCnt.
 */

@isTest
public class Plc_StocksManagementCntTest {

    @TestSetup
    static void makeData(){
  
        Plc_TestFactory.initProcessClickPackage();
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, '000001NEXI');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;

        Contact contact = Plc_TestFactory.createContactGeneric('LastName');
        contact.Account = account;
        //contact.LastName='LastName';
        contact.AccountId = account.Id;
        contact.Plc_Dealer__c = bit2ShopDealer.Id;
        insert contact;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Nexi', '000001NEXI', bit2ShopDealer);
        bit2ShopWarehouse.Plc_CoverageIndex__c = 1;
        //bit2ShopWarehouse.Plc_Tipology__c = 'Undefined';
        bit2ShopWarehouse.Plc_UniqueKey__c = 'code';
        insert bit2ShopWarehouse;   
   
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        Plc_WarehouseSolution__c plcWarehouseSolution = Plc_TestFactory.createWarehouseSolution('00789654123654789', plcSolution, bit2ShopWarehouse);
        plcWarehouseSolution.Name = 'warehouse solution';
        plcWarehouseSolution.Plc_ConsumedQty__c = 2;
        plcWarehouseSolution.Plc_CorrectionQty__c = 1;
        plcWarehouseSolution.Plc_AvailableQty__c = 3;
        plcWarehouseSolution.Plc_OrderedQty__c = 1;
        insert plcWarehouseSolution;

        Plc_DistributionList__c plcDistributionList = new Plc_DistributionList__c(Plc_Alias__c='Plc_AliasTest1',Plc_Status__c='Draft');
        insert plcDistributionList;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalogC = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalogC;
        

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalogC, '37377', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = '00541237896541230';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat.B2WExtCat__Status__c='Active';
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Name='Test';
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials= new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials.Bit2Shop__Status__c = 'Available';
        bit2ShopStockSerials.Plc_EncodedSerialNumber__c = 'FIT-00785610';
        bit2ShopStockSerials.Plc_ManufacturerSerialNumber__c = 'FIT-00785610';
        bit2ShopStockSerials.Plc_DllSerialNumber__c = 'FIT-00785610';
        bit2ShopStockSerials.Plc_EncodedSerialNumber__c = '00785610';
        bit2ShopStockSerials.Plc_DllSerialNumber__c = 'FIT-00785610';
        bit2ShopStockSerials.Plc_WithdrawnBy__c = contact.Id;
        bit2ShopStockSerials.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerial2WithDraw = bit2ShopStockSerials.clone();
        bit2ShopStockSerial2WithDraw.Bit2Shop__Status__c = 'Withdrawn';
        insert new List<Bit2Shop__Stock_Serials2__c>{bit2ShopStockSerials,bit2ShopStockSerial2WithDraw};
        
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 05/02/2019
     * @version 1.0
     * @description Test of the method initialize.
     */
    @isTest
    static void initializeTest(){
        
        Plc_StocksManagementCnt stockManagement=new Plc_StocksManagementCnt();

        Bit2Shop__Warehouse__c bit2ShopWh=[SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        
        Test.startTest();
            Object result1 = Plc_StocksManagementCnt.initialize(''+bit2ShopWh.Id,'initialize');
            Object result2 = Plc_StocksManagementCnt.initialize(''+bit2ShopWh.Id,'refreshAvailableManagement');
            Object result3 = Plc_StocksManagementCnt.initialize(''+bit2ShopWh.Id,'refreshWithdrawnManagement');
        Test.stopTest();
        
        System.debug('===== '+ JSON.serialize(result1));
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 06/02/2019
     * @Modify 26/02/2019 by Mame Diarra
     * @Modify 07/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method confirm.
     */
    @isTest
    static void confirmTest(){
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Bit2Shop__Stock_Serials2__c b2sS2=[SELECT Id FROM Bit2Shop__Stock_Serials2__c WHERE Bit2Shop__Status__c = :'Available'];
        String Id=''+b2sS2.Id;
        String productSKU='';
        String model='';
        String manufacturer='';
        String encodedSerialNumber='';
        String manufacturerSerialNumber='';
        String dllSerialNumber='2';
        String technicianId=''+contact.Id; 
        String status='';
        Boolean selected=true;
        
        Plc_StocksManagementCnt.stockSerialWrapper stockSWrap= new Plc_StocksManagementCnt.stockSerialWrapper(Id,productSKU,model,manufacturer,
                                                                                                                encodedSerialNumber,manufacturerSerialNumber,
                                                                                                                dllSerialNumber,contact,status,selected);
        
        List<Plc_StocksManagementCnt.stockSerialWrapper> availableSelectedSerialized  = new List<Plc_StocksManagementCnt.stockSerialWrapper>();
        availableSelectedSerialized.add(stockSWrap);
        List<Plc_StocksManagementCnt.stockSerialWrapper> withdrawnSelectedSerialiazed  = new List<Plc_StocksManagementCnt.stockSerialWrapper>();
       
        Test.startTest();
            Plc_StocksManagementCnt.confirm(JSON.serialize(availableSelectedSerialized) , JSON.serialize(withdrawnSelectedSerialiazed));
        Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 26/02/2019
     * @Modify 07/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method confirm and empty Bit2Shop__Stock_Serials2__c list.
     */
    @isTest
    static void confirmAndEmptyListStockSer2Test(){
        
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Bit2Shop__Stock_Serials2__c b2SS2=[SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        String Id=''+b2SS2.Id;
        String productSKU='';
        String model='';
        String manufacturer='';
        String encodedSerialNumber='';
        String manufacturerSerialNumber='';
        String dllSerialNumber='2';
        String technicianId=''+contact.Id; 
        String status='';
        Boolean selected=true;

        Plc_StocksManagementCnt.stockSerialWrapper stockSWrap2= new Plc_StocksManagementCnt.stockSerialWrapper(Id,productSKU,model,manufacturer,
                                                                                                                encodedSerialNumber,manufacturerSerialNumber,
                                                                                                                dllSerialNumber,contact,status,selected);
        
        List<Plc_StocksManagementCnt.stockSerialWrapper> availableSelectedSerialized  = new List<Plc_StocksManagementCnt.stockSerialWrapper>();
        List<Plc_StocksManagementCnt.stockSerialWrapper> withdrawnSelectedSerialiazed  = new List<Plc_StocksManagementCnt.stockSerialWrapper>();
        withdrawnSelectedSerialiazed.add(stockSWrap2);

        Test.startTest();
            Plc_StocksManagementCnt.confirm(JSON.serialize(availableSelectedSerialized),JSON.serialize(withdrawnSelectedSerialiazed));
        Test.stopTest();
    }
   
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 06/02/2019
     * @version 1.0
     * @description Test of the method createWrapperListFromResults.
     */
    @isTest
    static void createWrapperListFromResultsandB2shopStatusIsAvailableTest(){
        
        List<Bit2Shop__Stock_Serials2__c> bit2ShopStock = [SELECT ID,Plc_ManufacturerSerialNumber__c,Plc_DllSerialNumber__c,Plc_EncodedSerialNumber__c,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c,Bit2Shop__Product_Stock_Id__c,Plc_WithdrawnBy__c,Plc_WithdrawnBy__r.Name FROM Bit2Shop__Stock_Serials2__c];
        
        Map<String, List<Bit2Shop__Stock_Serials2__c>> resultsList=new Map<String, List<Bit2Shop__Stock_Serials2__c>>();
        Map<String, List<Bit2Shop__Stock_Serials2__c>> resultsList2=resultsList.clone();
        resultsList.put('Bit2Shop__Stock_Serials2__c',bit2ShopStock);

        Bit2Shop__Warehouse__c bit2ShopWh=[SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        Contact cont =[SELECT ID FROM Contact LIMIT 1];

        Test.startTest();
            List<Plc_StocksManagementCnt.stockSerialWrapper> results=   Plc_StocksManagementCnt.createWrapperListFromResults(JSON.serialize(resultsList),''+bit2ShopWh.Id,'AvailableManagement');
        Test.stopTest();
        //System.assertNotEquals(results,results2);

    }
      
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 06/02/2019
     * @version 1.0
     * @description Test of the method createWrapperListFromResults.
     */
    @isTest
    static void createWrapperListFromResultsAndB2ShopStatusIsWithdrawnTest(){
        
        List<Bit2Shop__Stock_Serials2__c> bit2ShopStock = [SELECT ID,Plc_ManufacturerSerialNumber__c,Plc_DllSerialNumber__c,Plc_EncodedSerialNumber__c,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c,Bit2Shop__Product_Stock_Id__c,Plc_WithdrawnBy__c,Plc_WithdrawnBy__r.Name FROM Bit2Shop__Stock_Serials2__c];
        bit2ShopStock[0].Bit2Shop__Status__c='Withdrawn';

        Map<String, List<Bit2Shop__Stock_Serials2__c>> resultsList=new Map<String, List<Bit2Shop__Stock_Serials2__c>>();
        Map<String, List<Bit2Shop__Stock_Serials2__c>> resultsList2=resultsList.clone();
        resultsList.put('Bit2Shop__Stock_Serials2__c',bit2ShopStock);
            
        Bit2Shop__Warehouse__c bit2ShopWh=[SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        Contact cont =[SELECT ID FROM Contact LIMIT 1];

        Test.startTest();
            List<Plc_StocksManagementCnt.stockSerialWrapper> results=   Plc_StocksManagementCnt.createWrapperListFromResults(JSON.serialize(resultsList),''+bit2ShopWh.Id,'WithdrawnManagement');
        Test.stopTest();
    }
    
    /**
     * @author FB
     * @date Creation 24/04/2019
     * @version 1.0
     * @description Test of the method  retrieveTranslationMap.
     */
    @isTest
    static void retrieveTranslationMapTest(){
        // Start test
        Test.startTest();
        Map<String, Object> response =Plc_StocksManagementCnt.retrieveTranslationMap();
        // Stop test
        Test.stopTest();
    }

    /**
     * @author FB
     * @date Creation 24/04/2019
     * @version 1.0
     * @description Test of the method retrieveAvailableWarehouses
     */
    @isTest
    static void retrieveAvailableWarehousesTest(){
        
        String searchKey = 'Test';
        Test.startTest();
        Plc_StocksManagementCnt.retrieveAvailableWarehouses(searchKey);
        Test.stopTest();
    }
    
    public class stockSerialWrapper {

        @AuraEnabled
        public String Id { get; set; }

        @AuraEnabled
        public String productSKU { get; set; }

        @AuraEnabled
        public String model { get; set; }

        @AuraEnabled
        public String manufacturer { get; set; }

        @AuraEnabled
        public String encodedSerialNumber { get; set; }

        @AuraEnabled
        public String manufacturerSerialNumber { get; set; }

        @AuraEnabled
        public String dllSerialNumber { get; set; }

        @AuraEnabled
        public Contact newTechnician { get; set; }

        @AuraEnabled
        public Contact oldTechnician { get ; set; }

        @AuraEnabled
        public String status { get; set; }

        @AuraEnabled
        public Boolean selected { get; set; }

        public stockSerialWrapper(String Id, String productSKU, String model, String manufacturer, String encodedSerialNumber, String manufacturerSerialNumber, String dllSerialNumber, Contact technician, String status, Boolean selected) {

            this.Id = Id;
            this.productSKU = productSKU;
            this.model = model;
            this.manufacturer = manufacturer;
            this.encodedSerialNumber = encodedSerialNumber;
            this.manufacturerSerialNumber = manufacturerSerialNumber;
            this.dllSerialNumber = dllSerialNumber;
            this.status = status;
            this.selected = selected;
            this.newTechnician = technician;
            this.oldTechnician = technician;
        }
    }
    
}