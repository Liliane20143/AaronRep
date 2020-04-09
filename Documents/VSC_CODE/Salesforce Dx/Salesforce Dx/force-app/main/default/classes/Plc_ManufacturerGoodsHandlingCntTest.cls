/**
 * @Modify 15/02/2019 by Mame Dairra
 * @version 1.0
 * @description Test of PLC ManufacturerGoodsHandlingCnt.
 */
@isTest
public class Plc_ManufacturerGoodsHandlingCntTest {

    @TestSetup
    static void Setup(){
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'new');
        bit2ShopDealer.Plc_Alias__c='12345';
        bit2ShopDealer.Plc_Repairer__c=true;
        bit2ShopDealer.Bit2Shop__Dealer_Type__c = 'filter';
        insert bit2ShopDealer;
        Plc_DistributionList__c plcDistributionList=new Plc_DistributionList__c(Plc_Alias__c='Requested',Plc_Status__c='Draft');
        insert plcDistributionList;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('name ware', 'Repaired','Nexi','000001NEXI',bit2ShopDealer);
        insert bit2ShopWarehouse;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'sku','type');
        insert b2wExtCatExtCat;

        
        Plc_DistributionListItem__c plcDistributionListItem =new Plc_DistributionListItem__c();
        plcDistributionListItem.Plc_DistributionList__c = plcDistributionList.Id;
        plcDistributionListItem.Plc_OriginDealer__c = bit2ShopDealer.Id;
        plcDistributionListItem.Plc_DestinationWarehouse__c = bit2ShopWarehouse.Id;
        plcDistributionListItem.Plc_Product__c = b2wExtCatExtCat.Id;
        plcDistributionListItem.Plc_RequestedQty__c=5;
        plcDistributionListItem.Plc_Status__c = 'Requested';
        plcDistributionListItem.Plc_OriginWarehouse__c = bit2ShopWarehouse.Id;
        insert plcDistributionListItem;
        
        Bit2Shop__TransferDetail__c b2ShopTransferDetail = new Bit2Shop__TransferDetail__c();
        b2ShopTransferDetail.Bit2Shop__Code__c='RESO_RIP';
        insert b2ShopTransferDetail;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        insert bit2ShopProductStock;
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials2.Plc_Status2__c='None';
        insert bit2ShopStockSerials2;
        
        Bit2Shop__TransferDetail__c bit2ShopTransferDetail= new Bit2Shop__TransferDetail__c();
        bit2ShopTransferDetail.Bit2Shop__Transfer_Type__c='Stock2Stock';
        bit2ShopTransferDetail.Bit2Shop__Code__c='SPOS_DL';
        bit2ShopTransferDetail.Name='test';
        bit2ShopTransferDetail.Plc_FilterDestinationWarehouse__c='Repaired;New';
        bit2ShopTransferDetail.Plc_Alias__c= 'TD001';
        insert bit2ShopTransferDetail;
        
        Bit2Shop__StockOrder__c bit2ShopStockOrder = new Bit2Shop__StockOrder__c(
                Plc_TransferDetail__c                       = bit2ShopTransferDetail.Id,
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Point_Of_Sales_Id__c              = bit2ShopDealer.Id,
                Bit2Shop__Holding_Id__c                     = account.Id,
                Bit2Shop__Warehouse_Id__c                   = bit2ShopWarehouse.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = bit2ShopDealer.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = bit2ShopWarehouse.Id,
                Bit2Shop__Transfer_Type__c                  ='Stock2Stock',
                Plc_DistributionList__c                     =plcDistributionList.Id
                );
                insert bit2ShopStockOrder;
        
                NE__Order__c neOrder= new NE__Order__c();
                neOrder.Bit2Shop__StockOrder__c=bit2ShopStockOrder.Id;
                neOrder.Bit2Shop__Cost_Total__c= 0;
                insert neOrder;
                
         		Plc_PurchaseOrder__c purchaseOrder= new Plc_PurchaseOrder__c(Plc_RdaNumber__c='test',Plc_PurchaseWarrantyDuration__c=18);
        		insert purchaseOrder;
        
                Bit2Shop__Shipment__c bit2Shopshipment = new Bit2Shop__Shipment__c();
                bit2Shopshipment.Bit2Shop__Sub_Type__c   = 'Outbound';
                bit2Shopshipment.Bit2Shop__Stock_Order_Id__c=bit2ShopStockOrder.Id;
                bit2Shopshipment.Bit2Shop__Shipment_Document_Number__c='test';
                insert bit2Shopshipment;
        
                Bit2Shop__Shipment_Line_Item__c shLineItem = new Bit2Shop__Shipment_Line_Item__c(
                Bit2Shop__Shipment_Id__c        = bit2Shopshipment.Id,
                Bit2Shop__Product_Stock_Id__c   = bit2ShopProductStock.Id
                );
                insert shLineItem;
        
                Bit2Shop__Shipment_Line_Item__c bit2ShopshipmentLineItem = new Bit2Shop__Shipment_Line_Item__c(
                Bit2Shop__Transfer_Detail_Id__c = bit2ShopStockOrder.Plc_TransferDetail__c,
                Bit2Shop__Date__c               = bit2ShopStockOrder.Bit2Shop__Date__c,
                Bit2Shop__Received_Quantity__c  = bit2Shopshipment.Bit2Shop__Shipped_Quantity__c,
                Bit2Shop__Product_Stock_Id__c   = bit2ShopProductStock.Id,
                Bit2Shop__Shipment_Id__c        =bit2Shopshipment.Id,
                Bit2Shop__Type__c               ='Serial',
                Bit2Shop__Target_Line_Item__c   = shLineItem.Id,
                Plc_PurchaseOrder__c			= purchaseOrder.Id
                );
                insert bit2ShopshipmentLineItem;
         
        Bit2Shop__Dealer_User__c dealerUser = new Bit2Shop__Dealer_User__c(Bit2Shop__User_Id__c=UserInfo.getUserId(),
                                                                           Bit2Shop__Dealer_Id__c=bit2ShopDealer.Id);
        insert dealerUser;
       
    }
    
    /**
    * @Mofify 15/02/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method initialize.
    */
    @isTest
    static void initializeTestOK(){
    Plc_DistributionList__c plcDistributionList=[SELECT Id FROM Plc_DistributionList__c];
      Test.startTest();                                                         
      Object obj = Plc_ManufacturerGoodsHandlingCnt.initialize(plcDistributionList.Id);
      // start for Plc_ManufacturerGoodsHandlingCnt whose Plc_Alias different from Requested 
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id,Plc_DestinationWarehouse__c,Plc_Product__c,Plc_RequestedQty__c
                                                              FROM Plc_DistributionListItem__c]; 
      plcDistributionListItem.Plc_Alias__c='test'; 
      update plcDistributionListItem;
      obj = Plc_ManufacturerGoodsHandlingCnt.initialize(plcDistributionList.Id);
      // end for Plc_ManufacturerGoodsHandlingCnt whose Plc_Alias different from Requested  
      Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 25/02/2019 
    * @version 1.0
    * @description Test exception of the method initialize.
    */
    @isTest
    static void initializeTestKO(){
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c]; 
      Test.startTest();                                                         
      Object obj = Plc_ManufacturerGoodsHandlingCnt.initialize(plcDistributionListItem.Id);
      Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 15/02/2019 
    * @modify 25/02/2019 by Mame Diarra/ Khalidou I. Sow BA 2019/04/02
    * @version 1.0
    * @description Test of the method getOriginDealer.
    */
    @isTest
    static void getOriginDealerTest(){
        
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id,Plc_OriginDealer__c FROM Plc_DistributionListItem__c LIMIT 1];
      List<String> dliIdList= new List<String>();
      dliIdList.add(''+plcDistributionListItem.Id);
      String transferDetailCode='';
        
		List<Plc_DistributionListItem__c> dliList =[SELECT Id, Plc_OriginDealer__c
											FROM Plc_DistributionListItem__c
 											WHERE (Plc_OriginDealer__r.Plc_Maintainer__c = true OR Plc_OriginDealer__r.Plc_Manufacturer__c = true
 											OR Plc_OriginDealer__r.Plc_Repairer__c = true
											OR Plc_OriginDealer__r.Plc_Scrapyard__c = true) AND Id IN :dliIdList];
        
        System.debug('#KISB#  DistList '+dliIdList);
      Test.startTest();   
          String filter='Plc_Maintainer__c;Plc_Repairer__c;Plc_Scrapyard__c;Plc_Manufacturer__c';  
          List<Bit2Shop__Dealer__c> originDealerList  = Plc_ManufacturerGoodsHandlingCnt.getOriginDealer(dliIdList,filter,transferDetailCode);
          
          filter='Plc_Manufacturer__c;Plc_Maintainer__c;Plc_Repairer__c';
          List<Bit2Shop__Dealer__c> originDealerList2 = Plc_ManufacturerGoodsHandlingCnt.getOriginDealer(dliIdList,filter,transferDetailCode);
          
          filter='Plc_Repairer__c;Plc_Manufacturer__c;Plc_Maintainer__c';
          List<Bit2Shop__Dealer__c> originDealerList3 = Plc_ManufacturerGoodsHandlingCnt.getOriginDealer(dliIdList,filter,transferDetailCode);
           
          filter='Plc_Scrapyard__c;Plc_Manufacturer__c;Plc_Maintainer__c';
          List<Bit2Shop__Dealer__c> originDealerList4 = Plc_ManufacturerGoodsHandlingCnt.getOriginDealer(dliIdList,filter,transferDetailCode);
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 15/02/2019 
    * @version 1.0
    * @description Test of the method getOriginWarehouse.
    */
    @isTest
    static void getOriginWarehouseTest(){
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id,Plc_OriginDealer__c FROM Plc_DistributionListItem__c LIMIT 1];
      List<String> dliIdList= new List<String>();
      dliIdList.add(''+plcDistributionListItem.Id);
      String originDealerId=''+plcDistributionListItem.Plc_OriginDealer__c; 
      String filter='Repaired';
      Test.startTest();                                                         
      List<Bit2Shop__Warehouse__c> originWarehouseList = Plc_ManufacturerGoodsHandlingCnt.getOriginWarehouse(dliIdList,originDealerId,filter);
      //start filter equals null
      List<Bit2Shop__Warehouse__c> originWarehouseList2 = Plc_ManufacturerGoodsHandlingCnt.getOriginWarehouse(dliIdList,originDealerId,null);
      //end filter equals null
      Test.stopTest();
    }

    /**
    * @author Mame Diarra
    * @date Creation 25/03/2019 
    * @version 1.0
    * @description Test exception of the method getOriginWarehouse.
    */
    @isTest
    static void getOriginWarehouseTestKO(){
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id,Plc_OriginDealer__c FROM Plc_DistributionListItem__c LIMIT 1];
      Database.delete(plcDistributionListItem.Id);
      List<String> dliIdList= new List<String>();
      dliIdList.add('');
      Test.startTest();                                                         
      List<Bit2Shop__Warehouse__c> originWarehouseList = Plc_ManufacturerGoodsHandlingCnt.getOriginWarehouse(dliIdList,'test','test');
      Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 15/02/2019 
    * @Modified 25/02/2019 by Mame Diarra
    * @Modified 04/03/2019 by Mame Diarra
    * @Modified 09/04/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method getDestinationDealer.
    */
    @isTest
    static void getDestinationDealerTest(){
      Bit2Shop__Warehouse__c originWarehouse =[SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c LIMIT 1];
      List<String> dliIdList= new List<String>();
      List<String> dliIdList2= new List<String>();  
      dliIdList.add(''+plcDistributionListItem.Id);
      String originWarehouseId=''+originWarehouse.Id; 
      String filter='Plc_Maintainer__c;Plc_Manufacturer__c;Plc_Repairer__c;Plc_Scrapyard__c';
      String transferDetailCode='SPOS_DL';
      Test.startTest();                                                         
      List<Bit2Shop__Dealer__c> originWarehouseList = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList,originWarehouseId,filter,transferDetailCode);
      //start Empty list ID of Plc_DistributionListItem__c
      List<Bit2Shop__Dealer__c> originWarehouseList2 = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList2,originWarehouseId,filter,transferDetailCode);
      //end Empty list ID of Plc_DistributionListItem__c
      List<Bit2Shop__Dealer__c> originWarehouseList3 = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList,originWarehouseId,'Plc_Manufacturer__c;Plc_Repairer__c;Plc_Scrapyard__c',transferDetailCode);
      List<Bit2Shop__Dealer__c> originWarehouseList4 = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList,originWarehouseId,'Plc_Repairer__c;Plc_Scrapyard__c',transferDetailCode);
      List<Bit2Shop__Dealer__c> originWarehouseList5 = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList,originWarehouseId,'Plc_Scrapyard__c','');
           
      //when code equals SPOS_DL_MATRDISP_S2OS
      Bit2Shop__TransferDetail__c bit2ShopTransferDetail=[SELECT Id,Plc_FilterDestinationWarehouse__c,Bit2Shop__Code__c FROM Bit2Shop__TransferDetail__c LIMIT 1];
      bit2ShopTransferDetail.Bit2Shop__Code__c='SPOS_DL_MATRDISP_S2OS';
      bit2ShopTransferDetail.Plc_FilterDestinationWarehouse__c='Repaired;New';
      update bit2ShopTransferDetail;
     
      List<Bit2Shop__Dealer__c> originWarehouseList6 = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList,originWarehouseId,filter,bit2ShopTransferDetail.Bit2Shop__Code__c);
      bit2ShopTransferDetail.Bit2Shop__Code__c='SPOS_PRO_S2OS';
      update bit2ShopTransferDetail;
      List<Bit2Shop__Dealer__c> originWarehouseList7 = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList,originWarehouseId,filter,bit2ShopTransferDetail.Bit2Shop__Code__c);
      bit2ShopTransferDetail.Bit2Shop__Code__c='SPOS_PRO_MATRDISP';
      bit2ShopTransferDetail.Plc_FilterDestinationDealer__c='Plc_Manufacturer__c;Plc_Repairer__c';
      update bit2ShopTransferDetail;
      List<Bit2Shop__Dealer__c> originWarehouseList8 = Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer(dliIdList,originWarehouseId,filter,bit2ShopTransferDetail.Bit2Shop__Code__c);
      Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 15/02/2019 
    * @version 1.0
    * @description Test of the method getDestinationWarehouse.
    */
    @isTest
    static void getDestinationWarehouseTest(){
      Bit2Shop__Dealer__c bit2ShopDealer =[SELECT Id FROM Bit2Shop__Dealer__c LIMIT 1];
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c LIMIT 1];
      List<String> dliIdList= new List<String>();
      List<String> dliIdList2= new List<String>();  
      dliIdList.add(''+plcDistributionListItem.Id);
      String destinationDealerId=''+bit2ShopDealer.Id; 
      String filter='12345';
         Test.startTest();                                                         
         List<Bit2Shop__Warehouse__c> originWarehouseList = Plc_ManufacturerGoodsHandlingCnt.getDestinationWarehouse(dliIdList,destinationDealerId,filter);
         Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 18/02/2019 
    * @version 1.0
    * @description Test of the method getDestinationWarehouse and filter is blank.
    */
    @isTest
    static void getDestinationWarehouseAndBlankFilterTest(){
      Bit2Shop__Dealer__c bit2ShopDealer =[SELECT Id FROM Bit2Shop__Dealer__c LIMIT 1];
      Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c LIMIT 1];
      List<String> dliIdList= new List<String>();
      List<String> dliIdList2= new List<String>();  
      dliIdList.add(''+plcDistributionListItem.Id);
      String destinationDealerId=''+bit2ShopDealer.Id; 
      String filter='';
         Test.startTest();                                                         
         List<Bit2Shop__Warehouse__c> originWarehouseList = Plc_ManufacturerGoodsHandlingCnt.getDestinationWarehouse(dliIdList,destinationDealerId,filter);
         Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 18/02/2019 
    * @version 1.0
    * @description Test exception of the method getDestinationWarehouse.
    */
    @isTest
    static void getDestinationWarehouseTestKO(){
      List<String> dliIdList= new List<String>();
      dliIdList.add('');
      String destinationDealerId=''; 
      String filter='';
         Test.startTest();                                                         
         List<Bit2Shop__Warehouse__c> originWarehouseList = Plc_ManufacturerGoodsHandlingCnt.getDestinationWarehouse(dliIdList,destinationDealerId,filter);
         Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 18/02/2019 
    * @version 1.0
    * @description Test of the method getDliWrapper.
    */
    @isTest
    static void getDliWrapperTest(){
         Bit2Shop__Dealer__c bit2ShopDealer= [SELECT Id,Name FROM Bit2Shop__Dealer__c LIMIT 1];
         Bit2Shop__Warehouse__c bit2ShopWarehouse= [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
         Plc_DistributionList__c distributionList= [SELECT Id FROM Plc_DistributionList__c LIMIT 1];
         String originDealerId=''+bit2ShopDealer.Id;
         String originWarehouseId=''+bit2ShopWarehouse.Id;
         String destinationDealerId=''+bit2ShopDealer.Id;
         String destinationWarehouseId=''+bit2ShopWarehouse.Id;
         String distributionListId=''+distributionList.Id;
        
         Test.startTest();                                                         
         List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper> dliWrapperList = Plc_ManufacturerGoodsHandlingCnt.getDliWrapper(originDealerId,originWarehouseId,destinationDealerId,
                                                                                         destinationWarehouseId,distributionListId);
         Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 18/02/2019 
    * @version 1.0
    * @description Test of the method createSerialWrapperFromResults.
    */
    @isTest
    static void createSerialWrapperFromResultsTest(){
        Bit2Shop__Warehouse__c bit2ShopWarehouse= [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        Map<String, List<Bit2Shop__Stock_Serials2__c>> stockSerialsFilteredMap= new Map<String, List<Bit2Shop__Stock_Serials2__c>>();
        List<Bit2Shop__Stock_Serials2__c> stockSerialFilteredList=[Select Id,Plc_Model__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c from Bit2Shop__Stock_Serials2__c];
        stockSerialsFilteredMap.put('Bit2Shop__Stock_Serials2__c', stockSerialFilteredList);
        String resultsList=JSON.serialize(stockSerialsFilteredMap);
        List<String> modelList=new List<String>();
        modelList.add(''+stockSerialFilteredList[0].Plc_Model__c);
        String warehouseId=''+stockSerialFilteredList[0].Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c;
        Test.startTest();                                                         
        List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper> stockSerialWrap = Plc_ManufacturerGoodsHandlingCnt.createSerialWrapperFromResults(resultsList,modelList,true);
        //when createcsv equals false
        List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper> stockSerialWrap2 = Plc_ManufacturerGoodsHandlingCnt.createSerialWrapperFromResults(resultsList,modelList,false);
        Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 18/02/2019 
    * @version 1.0
    * @description Test exception of the method createSerialWrapperFromResults.
    */
    @isTest
    static void createSerialWrapperFromResultsTestKO(){
        String resultsList='';
        List<String> modelList=new List<String>();
        modelList.add('');
        String warehouseId='';
        Test.startTest();                                                         
        List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper> stockSerialWrap = Plc_ManufacturerGoodsHandlingCnt.createSerialWrapperFromResults(resultsList,modelList,true);
        Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 18/02/2019 
    * @Modify 22/02/2019 by Mame Diarra
    * @Modify 27/02/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method save.
    */
    @isTest
    static void saveTest(){
        Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c LIMIT 1];
        Bit2Shop__Product_Stock__c bit2ShopProductStock=[SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c stockSerial=[SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        Bit2Shop__Warehouse__c bit2ShopWarehouse=[SELECT Id,Name FROM Bit2Shop__Warehouse__c LIMIT 1];
        Plc_DistributionList__c plcDistributionList=[SELECT Id FROM Plc_DistributionList__c LIMIT 1];
        Bit2Shop__TransferDetail__c transferDetail = [SELECT Id,Name FROM Bit2Shop__TransferDetail__c LIMIT 1];
        
        Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper stockserWra= new Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper(''+stockSerial.Id,'productSKU','model',
                                                                                                                                 'manufacturerSerialNumber','nexiSerialNumber',
                                                                                                                                 'status','productStockId', 'dllSerialNumber');
       
        List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper> stockSerialWrapperList=new List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper>();
        stockSerialWrapperList.add(stockserWra);
        
        Plc_ManufacturerGoodsHandlingCnt.dliWrapper wliwrap=new Plc_ManufacturerGoodsHandlingCnt.dliWrapper('','productSKU','model','qtToBeSent',
                                                                                                            '1','1',true,stockSerialWrapperList,''+bit2ShopProductStock.Id,true,'test');    
        List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper> dliWrapperQuantityList = new List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper>();
        dliWrapperQuantityList.add(wliwrap);
        String transferDetailSelected='SPOS_DL';
        String originWarehouseId=''+bit2ShopWarehouse.Name;
        String destinationWarehouseId=''+bit2ShopWarehouse.Name;
        String objQuantityList=JSON.serialize(dliWrapperQuantityList);
        String objSerialList=JSON.serialize(dliWrapperQuantityList);
        String note='';
        String distributionListId=''+plcDistributionList.Id;
        String originDealerId='';
        String destinationDealerId='';
        String stockOrderId='';
        Test.startTest();      
        //when stockOrderId is blank
        Id stockOrderToCreateid = Plc_ManufacturerGoodsHandlingCnt.save(transferDetailSelected,originWarehouseId,
                                                                        destinationWarehouseId,originDealerId,destinationDealerId,
                                                                        objQuantityList,objSerialList,note,distributionListId,stockOrderId);
        //when stockOrderId is not blank
        NE__Order__c neOrder= [SELECT Id,Bit2Shop__StockOrder__c FROM NE__Order__c LIMIT 1];
        stockOrderId=''+neOrder.Bit2Shop__StockOrder__c;
        Id stockOrderToCreateid2 = Plc_ManufacturerGoodsHandlingCnt.save(transferDetailSelected,originWarehouseId,
                                                                        destinationWarehouseId,originDealerId,destinationDealerId,
                                                                        objQuantityList,objSerialList,note,distributionListId,stockOrderId);
        Test.stopTest();
    }
    
    /**
    * @author FB
    * @date Creation 14/05/2019 
    * @version 1.0
    * @description Test of the method save_new.
    */
    @isTest
    static void saveNewTest(){
        Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c LIMIT 1];
        Bit2Shop__Product_Stock__c bit2ShopProductStock=[SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c stockSerial=[SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        Bit2Shop__Warehouse__c bit2ShopWarehouse=[SELECT Id,Name FROM Bit2Shop__Warehouse__c LIMIT 1];
        Plc_DistributionList__c plcDistributionList=[SELECT Id FROM Plc_DistributionList__c LIMIT 1];
        Bit2Shop__TransferDetail__c transferDetail = [SELECT Id,Name FROM Bit2Shop__TransferDetail__c LIMIT 1];
        
        Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper stockserWra= new Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper(''+stockSerial.Id,'productSKU','model',
                                                                                                                                 'manufacturerSerialNumber','nexiSerialNumber',
                                                                                                                                 'status','productStockId', 'dllSerialNumber');
       
        List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper> stockSerialWrapperList=new List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper>();
        stockSerialWrapperList.add(stockserWra);
        
        Plc_ManufacturerGoodsHandlingCnt.dliWrapper wliwrap=new Plc_ManufacturerGoodsHandlingCnt.dliWrapper('','productSKU','model','qtToBeSent',
                                                                                                            '1','1',true,stockSerialWrapperList,''+bit2ShopProductStock.Id,true,'test');    
        List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper> dliWrapperQuantityList = new List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper>();
        dliWrapperQuantityList.add(wliwrap);
        String transferDetailSelected='SPOS_DL';
        String originWarehouseId=''+bit2ShopWarehouse.Name;
        String destinationWarehouseId=''+bit2ShopWarehouse.Name;
        String objQuantityList=JSON.serialize(dliWrapperQuantityList);
        String objSerialList=JSON.serialize(dliWrapperQuantityList);
        String note='';
        String distributionListId=''+plcDistributionList.Id;
        String originDealerId='';
        String destinationDealerId='';
        String stockOrderId='';
        Test.startTest();      
        //when stockOrderId is blank
        List<Id> stockOrderToCreateid = Plc_ManufacturerGoodsHandlingCnt.save_new(transferDetailSelected,originWarehouseId,
                                                                        destinationWarehouseId,originDealerId,destinationDealerId,
                                                                        objQuantityList,objSerialList,note,distributionListId,stockOrderId);
        //when stockOrderId is not blank
        NE__Order__c neOrder= [SELECT Id,Bit2Shop__StockOrder__c FROM NE__Order__c LIMIT 1];
        stockOrderId=''+neOrder.Bit2Shop__StockOrder__c;
        List<Id> stockOrderToCreateid2 = Plc_ManufacturerGoodsHandlingCnt.save_new(transferDetailSelected,originWarehouseId,
                                                                        destinationWarehouseId,originDealerId,destinationDealerId,
                                                                        objQuantityList,objSerialList,note,distributionListId,stockOrderId);
        Test.stopTest();
    }

    /**
    * @author Mame Diarra
    * @date Creation 18/02/2019
    * @Modify 27/02/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method save id Plc_DistributionListItem__c in dliWrapper.
    */
    @isTest
    static void saveAndDistributionListTest(){
        Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c LIMIT 1];
        Bit2Shop__Product_Stock__c bit2ShopProductStock=[SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c stockSerial=[SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper stockserWra= new Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper(''+stockSerial.Id,'productSKU','model',
                                                                                                                                 'manufacturerSerialNumber','nexiSerialNumber',
                                                                                                                                 'status','productStockId', 'dllSerialNumber');
        List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper> stockSerialWrapperList=new List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper>();
        stockSerialWrapperList.add(stockserWra);
        Plc_ManufacturerGoodsHandlingCnt.dliWrapper wliwrap=new Plc_ManufacturerGoodsHandlingCnt.dliWrapper(''+plcDistributionListItem.Id,'productSKU','model','qtToBeSent',
                                                                                                            '1','1',true,stockSerialWrapperList,''+bit2ShopProductStock.Id,true,'rdaNumber');

        List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper> dliWrapperQuantityList = new List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper>();
        dliWrapperQuantityList.add(wliwrap);
        String transferDetailCodeSelected='';
        String originWarehouseId='';
        String destinationWarehouseId='';
        String objQuantityList=JSON.serialize(dliWrapperQuantityList);
        String objSerialList=JSON.serialize(dliWrapperQuantityList);
        String note='';
        String distributionListId='';
        String originDealerId=''; 
        String destinationDealerId='';
        String stockOrderId='';
        Test.startTest();                                                         
        Id stockOrderToCreateid = Plc_ManufacturerGoodsHandlingCnt.save(transferDetailCodeSelected,originWarehouseId,
                                                                        destinationWarehouseId,originDealerId,destinationDealerId,
                                                                        objQuantityList,objSerialList,note,distributionListId,stockOrderId);
        Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 22/02/2019 
    * @version 1.0
    * @description Test of the method loadDataForEdit.
    */
    @isTest
    static void loadDataForEditTest(){
        Bit2Shop__StockOrder__c bit2ShopStockOrder= [SELECT Id FROM Bit2Shop__StockOrder__c LIMIT 1];
        String stockOrderId=''+bit2ShopStockOrder.Id;
        Test.startTest();                                                         
        Map<String, Object> dataLoadedMap= Plc_ManufacturerGoodsHandlingCnt.loadDataForEdit(stockOrderId);
        Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 09/04/2019 
    * @version 1.0
    * @description Test exception of the method loadDataForEdit.
    */
    @isTest
    static void loadDataForEditTestKO(){
        Test.startTest();                                                         
        Map<String, Object> dataLoadedMap= Plc_ManufacturerGoodsHandlingCnt.loadDataForEdit('null');
        Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 22/02/2019 
    * @Modify 27/02/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method feedWrappers.
    */
    @isTest
    static void feedWrappersTest(){
        List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper> dliWrapperQuantityList  = new List<Plc_ManufacturerGoodsHandlingCnt.dliWrapper>(); 
        
        Plc_DistributionListItem__c plcDistributionListItem=[SELECT Id FROM Plc_DistributionListItem__c LIMIT 1];
        Bit2Shop__Product_Stock__c bit2ShopProductStock=[SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Bit2Shop__Stock_Serials2__c stockSerial=[SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper stockserWra= new Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper(''+stockSerial.Id,'productSKU','model',
                                                                                                                                 'manufacturerSerialNumber','nexiSerialNumber',
                                                                                                                                 'status','productStockId', 'dllSerialNumber');
        List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper> stockSerialWrapperList=new List<Plc_ManufacturerGoodsHandlingCnt.stockSerialWrapper>();
        stockSerialWrapperList.add(stockserWra);
        Plc_ManufacturerGoodsHandlingCnt.dliWrapper wliwrap=new Plc_ManufacturerGoodsHandlingCnt.dliWrapper(
                                                            ''+plcDistributionListItem.Id,'productSKU','model','qtToBeSent',
                                                            '1','1',true,stockSerialWrapperList,''+bit2ShopProductStock.Id,true,'test');
        dliWrapperQuantityList.add(wliwrap); 
        Bit2Shop__StockOrder__c bit2ShopStockOrder=[SELECT Id FROM Bit2Shop__StockOrder__c LIMIT 1];
        String stockOrderId=''+bit2ShopStockOrder.Id;
        String objQuantityList=''+JSON.serialize(dliWrapperQuantityList);
        String objSerialList=''+JSON.serialize(dliWrapperQuantityList);
        Test.startTest();                                                         
        Map<String, Object> dataLoadedMap = Plc_ManufacturerGoodsHandlingCnt.feedWrappers(stockOrderId,objQuantityList,objSerialList);
        //when Bit2Shop__Type__c equals Product
        Bit2Shop__Shipment_Line_Item__c b2ShipmentLineItem = [SELECT Id,Bit2Shop__Type__c FROM Bit2Shop__Shipment_Line_Item__c LIMIT 1];
        b2ShipmentLineItem.Bit2Shop__Type__c='Product';
        b2ShipmentLineItem.Bit2Shop__Target_Line_Item__c=null;
        update b2ShipmentLineItem;
        Map<String, Object> dataLoadedMap2 = Plc_ManufacturerGoodsHandlingCnt.feedWrappers(stockOrderId,objQuantityList,objSerialList);
        Test.stopTest();
    }
    /**
    * @author Mame Diarra
    * @date Creation 09/04/2019 
    * @version 1.0
    * @description Test exception of the method feedWrappers.
    */
    @isTest
    static void feedWrappersTestKO(){
    	Map<String, Object> dataLoadedMap3 = Plc_ManufacturerGoodsHandlingCnt.feedWrappers(null,null,null);
    }
    
   }