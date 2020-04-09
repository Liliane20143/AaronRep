/**
 * @author Mame Diarra
 * @date Creation 01/02/2019
 * @date Modification 11/02/2019 by @Abdoulaye DIOP , Moussa FOFANA on 2019/03/27
 * @version 1.0
 * @description Test of Plc GoodsHandlingCnt.
 */
@isTest
public class Plc_GoodsHandlingCntTest {
//
    @testSetup
    static void setup(){    

        Plc_TestFactory.initProcessClickPackage();
        Plc_SystemSettings__c setting = new Plc_SystemSettings__c(Name = 'Purchase Warranty Months Delay', Plc_DaysForCalculatingConsumption__c = 1,
                                                                  Plc_PurchaseWarrantyMonthsDelay__c = 2);
        insert setting;
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('dealerParent', account, 'parentDealer');
        insert parentDealer;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealerChild('dealer', account,'childDealer', parentDealer);
        bit2ShopDealer.Plc_Repairer__c=true;
        insert bit2ShopDealer;

        Plc_TestFactory.createWarehouseFake();
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = new Bit2Shop__Warehouse__c();
        bit2ShopWarehouse.Name='Warehouse Name';
        bit2ShopWarehouse.Plc_Alias__c='Warehouse';
        bit2ShopWarehouse.Bit2Shop__Dealer_Id__c=bit2ShopDealer.Id;
        bit2ShopWarehouse.Plc_LogisticDivision__c='';
        bit2ShopWarehouse.Plc_Tipology__c='Repaired';
        insert bit2ShopWarehouse;
      
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalogC = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalogC;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCatItem = Plc_TestFactory.createExtCatalogItem('Cat Item Name',b2WExtCatExtCatalogC,'37377','Item');
        b2wExtCatExtCatItem.Plc_Alias__c ='00541237896541230';
        insert b2wExtCatExtCatItem;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCatItem, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c =2;
        bit2ShopProductStock.Name='Test';
        bit2ShopProductStock.Plc_WithdrawnQty__c=1;
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3;
        insert bit2ShopProductStock;
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials= new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials.Bit2Shop__Warehouse_Id__c=bit2ShopWarehouse.Id;
        bit2ShopStockSerials.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials.Plc_EncodedSerialNumber__c = 'a1y1j00785610';
        bit2ShopStockSerials.Plc_ManufacturerSerialNumber__c='a1y1j00785610';
        bit2ShopStockSerials.Plc_EncodedSerialNumber__c ='a1y1j00785610';
        bit2ShopStockSerials.Plc_DllSerialNumber__c='00785610';
        insert bit2ShopStockSerials;
        
        Bit2Shop__TransferDetail__c transferDetail = new Bit2Shop__TransferDetail__c();
        transferDetail.Plc_FilterDestinationDealer__c='Plc_Manufacturer__c;Plc_Maintainer__c;Plc_Repairer__c;Plc_Scrapyard__c';
        transferDetail.Plc_FilterDestinationWarehouse__c='Repaired';
        transferDetail.Bit2Shop__Code__c='SPOS_DL';
        insert transferDetail;

        //Dealer_User
        Bit2Shop__Dealer_User__c dealerUser = new Bit2Shop__Dealer_User__c();
        dealerUser.Bit2Shop__Dealer_Id__c=bit2ShopDealer.Id;
        dealerUser.Bit2Shop__User_Id__c= userinfo.getUserId();
        insert dealerUser;

    }
    
    /**
     * @author Mame Diarra
     * @date Creation 01/02/2019
     * @version 1.0
     * @description Test of the method initComponent.
     */
    @isTest
    static void getInitComponentTest(){
        Bit2Shop__Dealer__c dealer = [SELECT Id FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = 'childDealer'];
        // Start test
       Test.startTest();
       Map<String, Object> result = Plc_GoodsHandlingCnt.initComponent(''+dealer.Id);
       // Stop test
       Test.stopTest();
    }

    /**
     * @author Mame Diarra
     * @date Creation 01/02/2019
     * @version 1.0
     * @description Test of the method selectOrigin.
     */
    @isTest
    static void getSelectOriginTest(){
        Bit2Shop__Dealer__c dealer = [SELECT Id FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = 'childDealer'];
        // Start test
       Test.startTest();
       List<Bit2Shop__Warehouse__c> result = Plc_GoodsHandlingCnt.selectOrigin(''+dealer.Id,'origin');
       // Stop test
       Test.stopTest();
    }

    /**
     * @author Mame Diarra
     * @date Creation 01/02/2019
     * @Modify 21/02/2019 by Mame Diarra & Abdoulaye diop,Moussa FOFANA on 2019/03/27
     * @version 1.0
     * @description Test of the method selectDestinationDealer.
     */
    @isTest
    static void getSelectDestinationDealerTest(){
       Bit2Shop__TransferDetail__c transferDetail = [SELECT Id FROM Bit2Shop__TransferDetail__c];
       String tranferDetailId = '' + transferDetail.Id;
       //Bit2Shop__Warehouse__c originWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
       Bit2Shop__Warehouse__c originWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c = 'Repaired' LIMIT 1];

       // Start test
       Test.startTest();
       
       //when Manufacturer
       List<Bit2Shop__Dealer__c> resultManufacturer = Plc_GoodsHandlingCnt.selectDestinationDealer('Plc_Manufacturer__c', tranferDetailId, originWarehouse.Id);
       
       //when maintainer
       List<Bit2Shop__Dealer__c> resultMaintainer   = Plc_GoodsHandlingCnt.selectDestinationDealer('Plc_Maintainer__c', tranferDetailId, originWarehouse.Id);
       
       //when repairer
       List<Bit2Shop__Dealer__c> resultRepairer     = Plc_GoodsHandlingCnt.selectDestinationDealer('Plc_Repairer__c', tranferDetailId, originWarehouse.Id);
  
       //when scrapyard
       List<Bit2Shop__Dealer__c> resultScrapyard    = Plc_GoodsHandlingCnt.selectDestinationDealer('Plc_Scrapyard__c', tranferDetailId, originWarehouse.Id);
  
       //when finder equals false
       List<Bit2Shop__Dealer__c> result            = Plc_GoodsHandlingCnt.selectDestinationDealer('test', tranferDetailId, originWarehouse.Id);
        
       //Bit2Shop__TransferDetail__c transferDetail = [SELECT Id, Bit2Shop__Code__c FROM Bit2Shop__TransferDetail__c LIMIT 1];
       transferDetail.Bit2Shop__Code__c = 'SPOS_PRO'; // 228
       update transferDetail;
       
       result  = Plc_GoodsHandlingCnt.selectDestinationDealer('test', tranferDetailId, originWarehouse.Id);
       
       //Line 185 
       //When code is SPOS_PRO_S2OS  
       transferDetail.Bit2Shop__Code__c = 'SPOS_PRO_S2OS';
       update transferDetail; 
       result  = Plc_GoodsHandlingCnt.selectDestinationDealer('test', tranferDetailId, originWarehouse.Id);
       
       //When code is SPOS_PRO_MATRDISP_S2S 
       transferDetail.Bit2Shop__Code__c = 'SPOS_PRO_MATRDISP_S2S';
       update transferDetail; 
       result  = Plc_GoodsHandlingCnt.selectDestinationDealer('test', tranferDetailId, originWarehouse.Id);
  
       //When code is SPOS_PRO_MATRDISP_S2OS 
       transferDetail.Bit2Shop__Code__c = 'SPOS_PRO_MATRDISP_S2OS';
       update transferDetail; 
       result  = Plc_GoodsHandlingCnt.selectDestinationDealer('test', tranferDetailId, originWarehouse.Id); 	
        
       //When code is SPOS_PRO_MATRDISP 
       transferDetail.Bit2Shop__Code__c = 'SPOS_PRO_MATRDISP';
       update transferDetail; 
       result  = Plc_GoodsHandlingCnt.selectDestinationDealer('test', tranferDetailId, originWarehouse.Id); 
        
       //When incorrect code
       transferDetail.Bit2Shop__Code__c = 'bad Code';
       update transferDetail; 
       result  = Plc_GoodsHandlingCnt.selectDestinationDealer('test', tranferDetailId, originWarehouse.Id); 
        
 
       // Stop test
       Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 04/02/2019
     * @Modify 21/02/2019 by Mame Diarra 
     * @version 1.0
     * @description Test of the method selectDestinationWarehouse.
     */
    @isTest
    static void getselectDestinationWarehouseTest(){
       Bit2Shop__Dealer__c dealer = [SELECT Id FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = 'childDealer'];
       String filterDestinationWarehouse='test';
       String logisticDivision='';
       String property='';
       // Start test
       Test.startTest();
       // when code equals SPOS 
       List<Bit2Shop__Warehouse__c> resultSPOS = Plc_GoodsHandlingCnt.selectDestinationWarehouse(filterDestinationWarehouse,''+dealer.Id,'SPOS',logisticDivision,property);
       
       // when code equals SPOS_DL 
       List<Bit2Shop__Warehouse__c> resultSPOS_DL = Plc_GoodsHandlingCnt.selectDestinationWarehouse(filterDestinationWarehouse,'' + dealer.Id,'SPOS_DL',logisticDivision,property);

       // when code equals SPOS_PRO 
       List<Bit2Shop__Warehouse__c> resultSPOS_PRO = Plc_GoodsHandlingCnt.selectDestinationWarehouse(filterDestinationWarehouse,'' + dealer.Id,'SPOS_DL',logisticDivision,property);
 
       // Stop test
       Test.stopTest();
    }

    /**
     * @author Mame Diarra
     * @date Creation 04/02/2019
     * @version 1.0
     * @description Test of the method loadData.
     */
    @isTest
    static void getloadDataTest(){
       Bit2Shop__Warehouse__c originWarehouseId = [SELECT Id FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c = 'Repaired' LIMIT 1];
       String filterSerial='test';
       // Start test
       Test.startTest();
       Map<String, Object> result = Plc_GoodsHandlingCnt.loadData(filterSerial,''+originWarehouseId.Id);
       // Stop test
       Test.stopTest();
    }

    /**
     * @author Mame Diarra
     * @date Creation 04/02/2019
     * @Modify 21/02/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method loadData.
     */
    @isTest
    static void saveTest(){
        Bit2Shop__TransferDetail__c transferDetail= [SELECT Id,Bit2Shop__Transfer_Type__c FROM Bit2Shop__TransferDetail__c LIMIT 1];
        
        Bit2Shop__Warehouse__c originWarehouse=[SELECT Id,Bit2Shop__Dealer_Id__c,
                                                Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                                                Bit2Shop__Dealer_Id__r.OwnerId FROM Bit2Shop__Warehouse__c LIMIT 1];
        
        Bit2Shop__Warehouse__c destinationWarehouse=[SELECT Id,Bit2Shop__Dealer_Id__c,
                                                Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c,
                                                Bit2Shop__Dealer_Id__r.OwnerId FROM Bit2Shop__Warehouse__c LIMIT 1];
        
        List<Bit2Shop__Stock_Serials2__c> selectedProductSerial = [SELECT Id,
                                                                   Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Stock_Serials2__c];
        
        List<Bit2Shop__Product_Stock__c> selectedProductQuantity = [SELECT Id,Name,Bit2Shop__Shipped_Qty__c,Bit2Shop__External_Catalog_Item_Id__c
                                                                    FROM Bit2Shop__Product_Stock__c];
        String note='test';
        // Start test
       Test.startTest();
       Plc_GoodsHandlingCnt.save(transferDetail,originWarehouse,destinationWarehouse,selectedProductSerial,selectedProductQuantity,note);
       // Stop test
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
        Map<String, Object> response =Plc_GoodsHandlingCnt.retrieveTranslationMap();
        // Stop test
        Test.stopTest();
    }

    /**
     * @author FB
     * @date Creation 24/04/2019
     * @version 1.0
     * @description Test of the method retrieveAvailableDealers
     */
    @isTest
    static void retrieveAvailableDealersTest(){
        
        String searchKey = 'Test';
        Test.startTest();
        Plc_GoodsHandlingCnt.retrieveAvailableDealers(searchKey);
        Test.stopTest();
    }
}