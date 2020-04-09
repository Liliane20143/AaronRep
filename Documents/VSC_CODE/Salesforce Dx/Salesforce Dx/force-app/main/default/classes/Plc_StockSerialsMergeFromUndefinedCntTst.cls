/**
     * @author Abdoulaye & Moussa
     * @date Creation 30/01/2019
     * @version 1.0
     * @description Test of PLC Plc_StockSerialsMergeFromUndefinedCntTst.
     */
    @isTest
    public class Plc_StockSerialsMergeFromUndefinedCntTst {
    
    @TestSetup    
    static void setup(){
        
        Plc_TestFactory.initProcessClickPackage();
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Account account2 = Plc_TestFactory.createAccountSupplier('Name');
        insert account2;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, '000001NEXI');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;
        
        Bit2Shop__Dealer__c bit2ShopDealer2 = Plc_TestFactory.createDealer('dealer', account, 'aliasc');
        bit2ShopDealer2.Plc_Repairer__c = true;
        insert bit2ShopDealer2;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Nexi', '000001NEXI', bit2ShopDealer);
        bit2ShopWarehouse.Plc_CoverageIndex__c = 1;
        bit2ShopWarehouse.Plc_UniqueKey__c = 'code1';
        insert bit2ShopWarehouse;   
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse2 = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Aspiag', '999014NEXI', bit2ShopDealer);
        bit2ShopWarehouse2.Plc_CoverageIndex__c=2;
        bit2ShopWarehouse2.Plc_UniqueKey__c='code2';
        insert bit2ShopWarehouse2;
   
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        Plc_Solution__c plcSolution2 = Plc_TestFactory.createSolution('00541237896541231');
        insert plcSolution2;

        Plc_WarehouseSolution__c plcWarehouseSolution = Plc_TestFactory.createWarehouseSolution('00789654123654789', plcSolution, bit2ShopWarehouse);
        plcWarehouseSolution.Name = 'warehouse solution';
        plcWarehouseSolution.Plc_ConsumedQty__c = 2;
        plcWarehouseSolution.Plc_CorrectionQty__c = 1;
        plcWarehouseSolution.Plc_AvailableQty__c = 3;
        plcWarehouseSolution.Plc_OrderedQty__c = 1;
        insert plcWarehouseSolution;

        Plc_DistributionList__c plcDistributionList=new Plc_DistributionList__c(Plc_Alias__c='Plc_AliasTest1',Plc_Status__c='Draft');
        insert plcDistributionList;


        B2WExtCat__External_Catalog__c b2WExtCatExtCatalogC = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalogC;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCatItem = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalogC, '37377', 'Process');
        b2wExtCatExtCatItem.Plc_Alias__c = '00541237896541230';
        b2wExtCatExtCatItem.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCatItem.Bit2Shop__Product_Description__c = 'description';
        b2wExtCatExtCatItem.Bit2Shop__Required_Serial__c = true;
        insert b2wExtCatExtCatItem;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCatItem, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 2;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 1; 
        insert bit2ShopProductStock;
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials.Plc_EncodedSerialNumber__c = 'FIT-00785610';
        bit2ShopStockSerials.Plc_ManufacturerSerialNumber__c = 'FIT-00785610';
        bit2ShopStockSerials.Plc_DllSerialNumber__c = 'FIT-00785610';
        bit2ShopStockSerials.Plc_EncodedSerialNumber__c = '00785610';
        
        //clone before setting Bit2Shop__Warehouse_Id__c
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = bit2ShopStockSerials.clone();

        bit2ShopStockSerials.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        insert bit2ShopStockSerials;
        
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = ''+bit2ShopWarehouse2.Id;
        bit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'FIT-00783600';
        bit2ShopStockSerials2.Plc_DllSerialNumber__c = 'FIT-00783600';
        bit2ShopStockSerials2.Plc_EncodedSerialNumber__c = '00783600';
        insert bit2ShopStockSerials2;
        
        System.debug('==bit2ShopStockSerials2== ' + bit2ShopStockSerials2);
        
        bit2ShopStockSerials.Plc_DllSerialNumber__c = 'FIT-00785610';
        update bit2ShopStockSerials;
    }   
        
     /**
     * @author Moussa
     * @date Modification 08/02/2019
     * @version 1.0
     * @description Test of the method retrieveInfoStockSerialTest
     * @returned type Map<String, Object>
     */     
    @isTest
    static void retrieveInfoStockSerialTestOK() {
        
        Bit2Shop__Stock_Serials2__c bitshopStockSerials=[SELECT ID,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c,Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        //begin Test
        Test.startTest();
        
        Map<String, Object> stockserialInfo=Plc_StockSerialsMergeFromUndefinedCnt.retrieveInfoStockSerial(bitshopStockSerials.Id);
        
        Plc_StockSerialsMergeFromUndefinedCnt.currentStockSerial2=bitshopStockSerials;
        List<Bit2Shop__Stock_Serials2__c> listStockSerial2=new List<Bit2Shop__Stock_Serials2__c>();
        Plc_StockSerialsMergeFromUndefinedCnt.listStockSerial2=new List<Bit2Shop__Stock_Serials2__c>{bitshopStockSerials};
       
        Test.stopTest();
    
        System.assertEquals(true, stockserialInfo.containsKey('stockSerial'));
    }
        
     /**
     * @author Moussa
     * @date Modification 08/02/2019
     * @version 1.0
     * @description Test of the method retrieveInfoStockSerialTest
     * @returned type Map<String, Object>
     */         
    @isTest 
    static void retrieveInfoStockSerialIndefinitiTestOK() {

        Bit2Shop__Warehouse__c bit2ShopWarehouse=[SELECT ID,Plc_Tipology__c,Plc_LogisticDivision__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        //bit2ShopWarehouse.Plc_LogisticDivision__c='Neutral';
        update bit2ShopWarehouse;
        
        Test.startTest();
        Map<String, Object> infoStockSerialIndefiniti=Plc_StockSerialsMergeFromUndefinedCnt.retrieveInfoStockSerialIndefiniti('FIT-00785610');
        Test.stopTest();
        
        //System.assertEquals(true, infoStockSerialIndefiniti.containsKey('stockSerialIndef'));
    }   
        
     /**
     * @author Moussa
     * @date Modification 08/02/2019
     * @version 1.0
     * @description Test of the method retrieveInfoStockSerialIndefiniti
     * @returned type Map<String, Object>
     */     
    @isTest
    static void retrieveInfoStockSerialIndefinitiTestKO() {

        Bit2Shop__Stock_Serials2__c bitshopStockSerials=[SELECT ID,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c,Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        bitshopStockSerials.Plc_EncodedSerialNumber__c='00';
        update bitshopStockSerials;
        
        Test.startTest();
        Map<String, Object> infoStockSerialIndefiniti2=Plc_StockSerialsMergeFromUndefinedCnt.retrieveInfoStockSerialIndefiniti(''+bitshopStockSerials.Id);
        Test.stopTest();
        
        System.assertEquals(true, infoStockSerialIndefiniti2.get('error'));
    }      
     /**
     * @author Moussa
     * @date Modification 08/02/2019
     * @version 1.0
     * @description Test of the method updateMainSS2
     */    
    @isTest
    static void updateMainSS2Test(){
        
        Bit2Shop__Product_Stock__c productStock=[SELECT Id,Name,Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c bitshopStockSerials=[SELECT Bit2Shop__Product_Stock_Id__c,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c,
                                                         Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c,Plc_DllSerialNumber__c
                                                         FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
                
        bitshopStockSerials.Bit2Shop__Product_Stock_Id__r=productStock;
        
        bitshopStockSerials.Bit2Shop__Shipment_Date__c=Date.newInstance(2019, 2, 17);
        bitshopStockSerials.Plc_FirstInstallationDate__c=Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_PurchaseDate__c=Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Bit2Shop__Purchase_Price__c=100.0;
        bitshopStockSerials.Plc_PurchaseWarrantyStartDate__c = Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_PurchaseWarrantyEndDate__c = Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_LastRepairCost__c = 125;
        bitshopStockSerials.Plc_RepairWarrantyStartDate__c = Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_RepairWarrantyEndDate__c = Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_RentalStartDate__c = Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_RentalEndDate__c = Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_DepreciationDuration__c = 10;
        bitshopStockSerials.Plc_DepreciationPercentage__c = '10';
        bitshopStockSerials.Plc_DepreciationCompleted__c = true;
        bitshopStockSerials.Plc_PTSCode__c = '9510';
        bitshopStockSerials.Plc_PcipedModel__c = 'M1';
        bitshopStockSerials.Plc_PCIPEDLetterOfApproval__c = 'LLL';
        bitshopStockSerials.Plc_PcipedApprovalNumber__c = '00210314';
        bitshopStockSerials.Plc_PcipedVersion__c = '36';
        bitshopStockSerials.Plc_PcipedExpiryDate__c = Date.newInstance(2019, 3, 17);
        bitshopStockSerials.Plc_VoiceCode__c = '1006800';
        bitshopStockSerials.Plc_Pin__c = '123456';
        bitshopStockSerials.Plc_Puk1__c = '1245';
        bitshopStockSerials.Plc_Puk2__c = '1346';
        bitshopStockSerials.Plc_Note__c = 'Note';
        update bitshopStockSerials;
              
        List<Bit2Shop__Product_Stock__c> productStockList = [SELECT Id, Bit2Shop__Warehouse_Id__c, Bit2Shop__External_Catalog_Item_Id__c
                                                             FROM Bit2Shop__Product_Stock__c LIMIT 1];
        
        System.debug('==Liste size== '+productStockList.size());
        System.debug('==list product stock== '+productStockList);
        System.debug('==list product stock ID== '+productStockList.get(0).Id);
        bitshopStockSerials.Bit2Shop__Product_Stock_Id__c=productStockList.get(0).Id;
        System.debug('==b2s product stock == '+bitshopStockSerials.Bit2Shop__Product_Stock_Id__c);
        System.debug('==b2sSerials == '+bitshopStockSerials);
    
        Test.startTest();
            Plc_StockSerialsMergeFromUndefinedCnt.updateMainSS2(bitshopStockSerials,bitshopStockSerials);
        Test.stopTest(); 
    }    
        
     /**
     * @author Moussa
     * @date Modification 08/02/2019
     * @version 1.0
     * @description Test of the method updateIndispSS2
     */
    @isTest
    static void updateIndispSS2Test(){
        
        Bit2Shop__Product_Stock__c productStock=[SELECT Id,Name,Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c bitshopStockSerials=[SELECT Bit2Shop__Product_Stock_Id__c,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        bitshopStockSerials.Bit2Shop__Product_Stock_Id__r=productStock;
        update bitshopStockSerials;
        
        Test.startTest();
            Plc_StockSerialsMergeFromUndefinedCnt.updateIndispSS2(bitshopStockSerials,bitshopStockSerials);
        Test.stopTest(); 
    }  
        
     /**
     * @author Moussa
     * @date Modification 08/02/2019
     * @version 1.0
     * @description Test of the method updateIndispSS2
     */
    @isTest
    static void updateIndispSS2KOTest(){
        
        Bit2Shop__Product_Stock__c productStock=[SELECT Id,Name,Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
                
        Bit2Shop__Stock_Serials2__c bitshopStockSerials2=[SELECT Bit2Shop__Product_Stock_Id__c,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c 
                                                         FROM Bit2Shop__Stock_Serials2__c
                                                         WHERE Plc_DllSerialNumber__c='FIT-00783600' LIMIT 1];
        
        bitshopStockSerials2.Bit2Shop__Product_Stock_Id__r=productStock;
        update bitshopStockSerials2;
                
        Test.startTest();
            Plc_StockSerialsMergeFromUndefinedCnt.updateIndispSS2(bitshopStockSerials2,bitshopStockSerials2);
        Test.stopTest(); 
    }
        
     /**
     * @author Moussa
     * @date Modification 08/02/2019
     * @version 1.0
     * @description Test of the method updateIndispLkSS2
     */        
    @isTest
    static void updateIndispLkSS2Test(){
        
        Bit2Shop__Product_Stock__c productStock=[SELECT Id,Name,Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c bitshopStockSerials=[SELECT Bit2Shop__Product_Stock_Id__c,Bit2Shop__Warehouse_Id__c,Bit2Shop__Status__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        bitshopStockSerials.Bit2Shop__Product_Stock_Id__r=productStock;
        update bitshopStockSerials;
        
        B2WExtCat__External_Catalog_Item__c externalCatItem=[SELECT ID,B2WExtCat__External_Catalog_Item_Name__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        
        
        Test.startTest();
            Plc_StockSerialsMergeFromUndefinedCnt.updateIndispLkSS2(bitshopStockSerials,bitshopStockSerials,externalCatItem);
        Test.stopTest(); 
        
    }      
    
     /**
     * @author Moussa
     * @date Modification 21/02/2019
     * @version 1.0
     * @description Test of the method checkCurrentUserProfile
     * @return : Boolean
     */    
    @isTest
    static void checkCurrentUserProfileTest(){

        Bit2Shop__Stock_Serials2__c bitshopStockSerials=[SELECT ID,Bit2Shop__Warehouse_Id__c,Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c,Plc_DllSerialNumber__c,Bit2Shop__Status__c,Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        Test.startTest();
        bitshopStockSerials.Plc_DllSerialNumber__c = 'FIT-00785000';
        update bitshopStockSerials;
        Plc_StockSerialsMergeFromUndefinedCnt.preCheckSerial(bitshopStockSerials);
        Test.stopTest();
        
    }
        
    /**
     * @author Shahid
     * @date Modification 08/03/2019
     * @version 1.0
     * @description Test of the method checkCurrentUserProfile for null
     * @return : Boolean
     */    
    @isTest
    static void checkCurrentUserProfileTestNull(){

        Bit2Shop__Stock_Serials2__c bitshopStockSerials1 =[SELECT ID,Bit2Shop__Warehouse_Id__c,Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c,Plc_DllSerialNumber__c,Bit2Shop__Status__c,Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        Test.startTest();
        bitshopStockSerials1.Plc_DllSerialNumber__c = null;
        bitshopStockSerials1.Plc_ManufacturerSerialNumber__c = null;
        bitshopStockSerials1.Plc_EncodedSerialNumber__c= null;
        update bitshopStockSerials1;
        Plc_StockSerialsMergeFromUndefinedCnt.preCheckSerial(bitshopStockSerials1);
        Test.stopTest();
        //FeatureManagement.checkPermission('');
    }

    /**
    * @author FB
    * @date Creation 11/09/2019
    * @version 1.0
    * @description Test of the method retrieveTranslationMap
    */
    @isTest
    static void retrieveTranslationMapTestOk() {

        //Start test
        Test.startTest();
        Map<String, Object> response = Plc_StockSerialsMergeFromUndefinedCnt.retrieveTranslationMap();
        //Stop test
        Test.stopTest();

        System.assert(response != null);
    }
}