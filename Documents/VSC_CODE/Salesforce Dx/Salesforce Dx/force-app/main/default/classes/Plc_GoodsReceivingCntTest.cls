/**
 * @author Mame Diarra
 * @date Creation 01/02/2019
 * @date Modification 11/02/2019 by @Abdoulaye
 * @date Modification 15/02/2019 by @Mame Diarra
 * @date Modification 18/02/2019 by @Mame Diarra
 * @version 1.0
 * @description Test of Plc Plc_GoodsReceivingCnt.
 */
@isTest
public class Plc_GoodsReceivingCntTest {
    
    @testSetup
    static void setup(){

        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('Parent Dealer',account,'Alias');
        insert parentDealer;

        //childDealer
        Bit2Shop__Dealer__c childDealer = Plc_TestFactory.createDealerChild('Child Dealer',account,'12345',parentDealer);
        childDealer.Plc_Repairer__c=true;
        insert childDealer;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('Warehouse Name','','Nexi','000001NEXI',childDealer);
        bit2ShopWarehouse.Plc_Tipology__c = 'Repaired';
        bit2ShopWarehouse.Plc_CoverageIndex__c=1;
        insert bit2ShopWarehouse;

        B2WExtCat__External_Catalog__c b2wExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2wExtCatalog;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Cat Item Name',b2wExtCatalog,'test','Process');
        b2wExtCatExtCat.Plc_Alias__c ='00541237896541230';    
        insert b2wExtCatExtCat;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c =2;
        bit2ShopProductStock.Plc_WithdrawnQty__c=1;
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Repaired';
        bit2ShopStockSerials2.Plc_PurchaseDate__c=Date.newInstance(2019, 02, 06);
        bit2ShopStockSerials2.Plc_PurchaseWarrantyStartDate__c=Date.newInstance(2019, 01, 01);
        bit2ShopStockSerials2.Plc_PurchaseWarrantyEndDate__c=Date.newInstance(2019, 02, 16);
        insert bit2ShopStockSerials2;
        
        Bit2Shop__TransferDetail__c bit2ShopTransDetail= new Bit2Shop__TransferDetail__c();
        bit2ShopTransDetail.Name='Approvvigionamento';
        bit2ShopTransDetail.Bit2Shop__Code__c='12345';
        insert bit2ShopTransDetail;
        System.debug('MY '+bit2ShopTransDetail.Id);
        
        Bit2Shop__StockOrder__c bit2ShopStockOrder= new Bit2Shop__StockOrder__c();
        bit2ShopStockOrder.Plc_Alias__c='01234567890';
        bit2ShopStockOrder.Plc_PurchaseDate__c=Date.newInstance(2019, 01, 01);
        //bit2ShopStockOrder.Plc_TransferDetail__c=bit2ShopTransDetail.Id;
        bit2ShopStockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c = childDealer.Id;
        bit2ShopStockOrder.Bit2Shop__Status__c ='Taken in charge';
        insert bit2ShopStockOrder;
        
        Bit2Shop__Shipment__c bit2ShopShipment= new Bit2Shop__Shipment__c();
        bit2ShopShipment.Bit2Shop__Stock_Order_Id__c=bit2ShopStockOrder.Id;
        bit2ShopShipment.Bit2Shop__Shipment_Document_Number__c='test';
        insert bit2ShopShipment;
 
        Id recordType=Plc_Utils.getRecordTypeId('Shipment_Line_Item_Serial','Bit2Shop__Shipment_Line_Item__c');
        Bit2Shop__Shipment_Line_Item__c bit2ShopShipmentLineItem= new Bit2Shop__Shipment_Line_Item__c();
        bit2ShopShipmentLineItem.Bit2Shop__Shipment_Id__c=bit2ShopShipment.Id;
        bit2ShopShipmentLineItem.Plc_StockSerial__c=bit2ShopStockSerials2.Id;
        bit2ShopShipmentLineItem.Bit2Shop__Status__c='Closed';
        bit2ShopShipmentLineItem.Bit2Shop__Received_Status__c='Received';
        bit2ShopShipmentLineItem.Bit2Shop__Requested_Quantity__c=4;
        bit2ShopShipmentLineItem.Bit2Shop__Received_Quantity__c=2;
        bit2ShopShipmentLineItem.Plc_NotReceivedQty__c=2;
        bit2ShopShipmentLineItem.RecordTypeId=recordType;
        insert bit2ShopShipmentLineItem;
        
        Id recordType2 = Plc_Utils.getRecordTypeId('Shipment_Line_Item_Product','Bit2Shop__Shipment_Line_Item__c');
        Bit2Shop__Shipment_Line_Item__c bit2ShopShipmentLineItem2 = new Bit2Shop__Shipment_Line_Item__c();
        bit2ShopShipmentLineItem2.Bit2Shop__Shipment_Id__c = bit2ShopShipment.Id;
        bit2ShopShipmentLineItem2.Plc_StockSerial__c = bit2ShopStockSerials2.Id;
        bit2ShopShipmentLineItem2.Bit2Shop__Status__c = 'Closed';
        bit2ShopShipmentLineItem2.Bit2Shop__Received_Status__c = 'Received';
        bit2ShopShipmentLineItem2.Bit2Shop__Requested_Quantity__c = 10;
        bit2ShopShipmentLineItem2.Bit2Shop__Received_Quantity__c = 2;
        bit2ShopShipmentLineItem2.Plc_NotReceivedQty__c = 2;
        bit2ShopShipmentLineItem2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id; //257
        bit2ShopShipmentLineItem2.RecordTypeId = recordType2;
        insert bit2ShopShipmentLineItem2;
        
        Plc_SystemSettings__c plcSysSettings= new Plc_SystemSettings__c();
        plcSysSettings.Plc_PurchaseWarrantyMonthsDelay__c=12;
        plcSysSettings.Plc_DaysForCalculatingConsumption__c = 2;
        insert plcSysSettings;
        
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 04/02/2019
    * @version 1.0
    * @description Test of the method initData and not blank stockOrderId.
    */ 
    @isTest
    static void initDataAndNotBlankStockOrderIdTest(){
       String stockOrderId=''+([SELECT Id FROM Bit2Shop__StockOrder__c LIMIT 1]).Id;
       // Start test
       Test.startTest();
       /** [START MOD 10/02/2019 16:13]@Author:marco.lebellini@/webresults.it @Description: **/
       //Object result=Plc_GoodsReceivingCnt.initData(stockOrderId,shipmentId);
       Object result=Plc_GoodsReceivingCnt.initData(stockOrderId);
       /** [END MOD 10/02/2019 16:13]@Author:marco.lebellini@/webresults.it @Description: **/
       // Stop test
       Test.stopTest();
    }

    /**
    * @author Mame Diarra
    * @date Creation 04/02/2019
    * @version 1.0
    * @description Test of the method initData and not blank shipmentId.
    */ 
    @isTest
    static void initDataAndNotBlankShipmentIdTest(){
       String shipmentId=''+([SELECT Id FROM Bit2Shop__Shipment__c LIMIT 1]).Id;
       // Start test
       Test.startTest();
       /** [START MOD 10/02/2019 16:15]@Author:marco.lebellini@/webresults.it @Description: **/
       //Object result=Plc_GoodsReceivingCnt.initData(stockOrderId,shipmentId);
       Object result=Plc_GoodsReceivingCnt.initData(shipmentId);
       /** [END MOD 10/02/2019 16:15]@Author:marco.lebellini@/webresults.it @Description: **/
       // Stop test
       Test.stopTest();
    }

    /**
    * @author Mame Diarra
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test of the method fetchDataForTables.
    */ 
    @isTest
    static void fetchDataForTablesTest(){
        List<Bit2Shop__Shipment_Line_Item__c> shipmentStockSerials  = new List<Bit2Shop__Shipment_Line_Item__c>(); 
        shipmentStockSerials=[SELECT Id,Bit2Shop__Status__c,Bit2Shop__Requested_Quantity__c,
                              Bit2Shop__Received_Quantity__c,Plc_NotReceivedQty__c,RecordType.DeveloperName
                              FROM Bit2Shop__Shipment_Line_Item__c];
        List<Bit2Shop__Shipment_Line_Item__c> shipmentProductStocks = new List<Bit2Shop__Shipment_Line_Item__c>();
        List<Plc_GoodsReceivingCnt.goodWrapper> availableGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        Plc_GoodsReceivingCnt.goodWrapper goodWrap= new Plc_GoodsReceivingCnt.goodWrapper('sliId','goodId','status','productSKU','model',
                                                                                         'catalogName','manufacturer','encodedSerialNumber', 
                                                                                          'manufacturerSerialNumber','dllSerialNumber',
                                                                                          '4','2','4','2','0',true);
        availableGoodsFromWizard.add(goodWrap);
        List<Plc_GoodsReceivingCnt.goodWrapper> acceptedGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        acceptedGoodsFromWizard=availableGoodsFromWizard;
        List<Plc_GoodsReceivingCnt.goodWrapper> rejectedGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        rejectedGoodsFromWizard=availableGoodsFromWizard;
       // Start test
       Test.startTest();
       Object result=Plc_GoodsReceivingCnt.fetchDataForTables(JSON.serialize(shipmentStockSerials),JSON.serialize(shipmentProductStocks),
                                                              JSON.serialize(availableGoodsFromWizard),JSON.serialize(acceptedGoodsFromWizard),
                                                              JSON.serialize(rejectedGoodsFromWizard)); 
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 12/02/2019
    * @version 1.0
    * @description Test of the method fetchDataForTables and Bit2Shop__Status__c not equals Closed
    * and Bit2Shop__Requested_Quantity__c!=(Bit2Shop__Received_Quantity__c+Plc_NotReceivedQty__c).
    */ 
    @isTest
    static void fetchDataForTablesAndStatusNotEqualsClosedTest(){
        List<Bit2Shop__Shipment_Line_Item__c> shipmentStockSerials  = new List<Bit2Shop__Shipment_Line_Item__c>(); 
        shipmentStockSerials=[SELECT Id,Bit2Shop__Status__c,Bit2Shop__Requested_Quantity__c,
                              Bit2Shop__Received_Quantity__c,Plc_NotReceivedQty__c,RecordType.DeveloperName
                              FROM Bit2Shop__Shipment_Line_Item__c];
        shipmentStockSerials[0].Bit2Shop__Requested_Quantity__c=2;
        shipmentStockSerials[0].Bit2Shop__Status__c='test';
        shipmentStockSerials[0].Bit2Shop__Received_Status__c='Received';
        update shipmentStockSerials[0];
        List<Bit2Shop__Shipment_Line_Item__c> shipmentProductStocks = new List<Bit2Shop__Shipment_Line_Item__c>();
        shipmentProductStocks=shipmentStockSerials;
        List<Plc_GoodsReceivingCnt.goodWrapper> availableGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        Plc_GoodsReceivingCnt.goodWrapper goodWrap= new Plc_GoodsReceivingCnt.goodWrapper('sliId','goodId','status','productSKU','model',
                                                                                         'catalogName','manufacturer','encodedSerialNumber', 
                                                                                          'manufacturerSerialNumber','dllSerialNumber',
                                                                                          '4','2','4','2','0',true);
        availableGoodsFromWizard.add(goodWrap);
        List<Plc_GoodsReceivingCnt.goodWrapper> acceptedGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        acceptedGoodsFromWizard=availableGoodsFromWizard;
        List<Plc_GoodsReceivingCnt.goodWrapper> rejectedGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        rejectedGoodsFromWizard=availableGoodsFromWizard;
       // Start test
       Test.startTest();
       Object result=Plc_GoodsReceivingCnt.fetchDataForTables(JSON.serialize(shipmentStockSerials),JSON.serialize(shipmentProductStocks),
                                                              JSON.serialize(availableGoodsFromWizard),JSON.serialize(acceptedGoodsFromWizard),
                                                              JSON.serialize(rejectedGoodsFromWizard)); 
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 12/02/2019
    * @date Modification 22/02/2019 by @Abdoulaye
    * @version 1.0
    * @description Test of the method fetchDataForTables and Bit2Shop__Status__c not equals Closed
    * and Bit2Shop__Requested_Quantity__c!=(Bit2Shop__Received_Quantity__c+Plc_NotReceivedQty__c) and 
    * RecordType.DeveloperName equals Plc_WizardsConstants.PLC_SHIPMENT_LINE_ITEMS_PRODUCT_RT.
    */ 
    @isTest
    static void fetchDataForTablesAndStatusProductTest(){
        Id recordType=Plc_Utils.getRecordTypeId('Shipment_Line_Item_Product','Bit2Shop__Shipment_Line_Item__c');
               
        Bit2Shop__Shipment_Line_Item__c bit2ShopShipmentLineItem= [SELECT Id,RecordTypeId,Bit2Shop__Status__c,Bit2Shop__Received_Status__c FROM Bit2Shop__Shipment_Line_Item__c LIMIT 1];
        bit2ShopShipmentLineItem.Bit2Shop__Status__c='Closed';
        bit2ShopShipmentLineItem.Bit2Shop__Received_Status__c='Not Received';
        bit2ShopShipmentLineItem.Bit2Shop__Requested_Quantity__c=4;
        bit2ShopShipmentLineItem.Bit2Shop__Received_Quantity__c=2;
        bit2ShopShipmentLineItem.Plc_NotReceivedQty__c=2;
        bit2ShopShipmentLineItem.RecordTypeId=recordType;
        update bit2ShopShipmentLineItem;
        List<Bit2Shop__Shipment_Line_Item__c> shipmentStockSerials  = new List<Bit2Shop__Shipment_Line_Item__c>(); 
        shipmentStockSerials.add(bit2ShopShipmentLineItem);
        List<Bit2Shop__Shipment_Line_Item__c> shipmentProductStocks = new List<Bit2Shop__Shipment_Line_Item__c>();
        shipmentProductStocks=shipmentStockSerials;
        
        List<Plc_GoodsReceivingCnt.goodWrapper> availableGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        Plc_GoodsReceivingCnt.goodWrapper goodWrap= new Plc_GoodsReceivingCnt.goodWrapper(''+shipmentProductStocks[0].Id,'goodId','status','productSKU','model',
                                                                                         'catalogName','manufacturer','encodedSerialNumber', 
                                                                                          'manufacturerSerialNumber','dllSerialNumber',
                                                                                          '4','2','4','2','0',true);
        availableGoodsFromWizard.add(goodWrap);
        List<Plc_GoodsReceivingCnt.goodWrapper> acceptedGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        acceptedGoodsFromWizard=availableGoodsFromWizard;
        List<Plc_GoodsReceivingCnt.goodWrapper> rejectedGoodsFromWizard= new List<Plc_GoodsReceivingCnt.goodWrapper>();
        rejectedGoodsFromWizard=availableGoodsFromWizard;
       // Start test
       Test.startTest();
       Object result=Plc_GoodsReceivingCnt.fetchDataForTables(JSON.serialize(shipmentStockSerials),JSON.serialize(shipmentProductStocks),
                                                              JSON.serialize(availableGoodsFromWizard),JSON.serialize(acceptedGoodsFromWizard),
                                                              JSON.serialize(rejectedGoodsFromWizard)); 
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 12/02/2019
    * @version 1.0
    * @description Test exception of the method fetchDataForTables.
    */ 
    @isTest
    static void fetchDataForTablesTestKO(){
       
       // Start test
       Test.startTest();
       Object result=Plc_GoodsReceivingCnt.fetchDataForTables(JSON.serialize(''),JSON.serialize(''),' ',' ',' '); 
       // Stop test
       Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 12/02/2019
    * @date Modification 22/02/2019 by @Abdoulaye
    * @version 1.0
    * @description Test of the method saveGoods.
    */ 
    @isTest
    static void saveGoodsTest(){
       List<Bit2Shop__Shipment_Line_Item__c> shipmentStockSerials = [SELECT Id FROM Bit2Shop__Shipment_Line_Item__c];
       List<Plc_GoodsReceivingCnt.goodWrapper> availableGoods =new List<Plc_GoodsReceivingCnt.goodWrapper>();
       for(Bit2Shop__Shipment_Line_Item__c shipmentStockSerial : shipmentStockSerials){
            
           Plc_GoodsReceivingCnt.goodWrapper goodWrap = new Plc_GoodsReceivingCnt.goodWrapper(''+shipmentStockSerial.Id,'goodId','status','productSKU','model','catalogName',
                                                                                         'manufacturer','encodedSerialNumber','manufacturerSerialNumber',
                                                                                         'dllSerialNumber','2','2',
                                                                                         '2','2','0',true);
           availableGoods.add(goodWrap);
       }
       
       
       String serializedAvailableGoods=''+JSON.serialize(availableGoods);
       String serializedAcceptedGoods=''+JSON.serialize(availableGoods);
       String serializedRejectedGoods=''+JSON.serialize(availableGoods);
       String sourceRecordId=''+([SELECT Id FROM Bit2Shop__StockOrder__c LIMIT 1]).Id;
       // Start test
       Test.startTest();
       Plc_GoodsReceivingCnt.saveGoods(serializedAvailableGoods,serializedAcceptedGoods,serializedRejectedGoods,sourceRecordId);
       
       if(shipmentStockSerials.size() > 1){
            shipmentStockSerials[1].Bit2Shop__Target_Line_Item__c = shipmentStockSerials[0].Id;
            update shipmentStockSerials[1];
       }
       
       Plc_GoodsReceivingCnt.saveGoods(serializedAvailableGoods,serializedAcceptedGoods,serializedRejectedGoods,sourceRecordId);
        // Stop test
       Test.stopTest();
       
        
       
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 12/02/2019
    * @version 1.0
    * @description Test of the method saveGoods with Bit2Shop__Shipment__c object.
    */ 
    @isTest
    static void saveGoodsAndObjectShipmentTest(){
       List<Plc_GoodsReceivingCnt.goodWrapper> availableGoods =new List<Plc_GoodsReceivingCnt.goodWrapper>();
       String serializedAvailableGoods=''+JSON.serialize(availableGoods);
       String serializedAcceptedGoods='test';
       String serializedRejectedGoods='test';
       String sourceRecordId=''+([SELECT Id FROM Bit2Shop__Shipment__c LIMIT 1]).Id;
       // Start test
       Test.startTest();
       Plc_GoodsReceivingCnt.saveGoods(serializedAvailableGoods,serializedAcceptedGoods,serializedRejectedGoods,sourceRecordId);
       // Stop test
       Test.stopTest();
    }
    
     /**
    * @author Mame Diarra
    * @date Creation 15/03/2019
    * @version 1.0
    * @description Test of the method grantAccess.
    */ 
    @isTest
    static void grantAccessTest(){
        Bit2Shop__StockOrder__c inputStockOrder=[SELECT Id FROM Bit2Shop__StockOrder__c LIMIT 1];
       
       // Start test
       Test.startTest();
       String response =Plc_GoodsReceivingCnt.grantAccess(inputStockOrder);
       // Stop test
       Test.stopTest();
    }

   /**
    * @author FB
    * @date Creation 11/06/2019
    * @version 1.0
    * @description Test of the method grantAccess (Shipment)
    */ 
    @isTest
    static void grantAccessShipmentTest(){
        Bit2Shop__Shipment__c inputShipment = [SELECT Id FROM Bit2Shop__Shipment__c LIMIT 1];
       
       // Start test
       Test.startTest();
       String response =Plc_GoodsReceivingCnt.grantAccess(inputShipment);
       // Stop test
       Test.stopTest();
    }
    
    public class goodWrapper {

        @AuraEnabled
        public String sliId { get; set; }

        @AuraEnabled
        public String goodId { get; set; }

        @AuraEnabled
        public String productSKU { get; set; }

        @AuraEnabled
        public String model { get; set; }

        @AuraEnabled
        public String manufacturer { get; set; }

        @AuraEnabled
        public String catalogName { get; set; }

        @AuraEnabled
        public String encodedSerialNumber { get; set; }

        @AuraEnabled
        public String manufacturerSerialNumber { get; set; }

        @AuraEnabled
        public String dllSerialNumber { get; set; }

        @AuraEnabled
        public String status { get; set; }

        @AuraEnabled
        public String selectedQuantity { get; set; }

        @AuraEnabled
        public String requestedQuantity { get; set; }

        @AuraEnabled
        public String availableQuantity { get; set; }

        @AuraEnabled
        public String acceptedQuantity { get; set; }

        @AuraEnabled
        public String rejectedQuantity { get; set; }

        @AuraEnabled
        public Boolean locked { get; set; }

        @AuraEnabled
        public Boolean closed { get; set; }

        public goodWrapper(String sliId, String goodId, String status, String productSKU, String model, String catalogName, String manufacturer, String encodedSerialNumber, String manufacturerSerialNumber, String dllSerialNumber, String requestedQuantity, String availableQuantity, String acceptedQuantity, String rejectedQuantity, String selectedQuantity, Boolean locked, Boolean closed) {
            this.sliId = sliId;
            this.goodId = goodId;
            this.status = status;
            this.productSKU = productSKU;
            this.model = model;
            this.catalogName = catalogName;
            this.manufacturer = manufacturer;
            this.encodedSerialNumber = encodedSerialNumber;
            this.manufacturerSerialNumber = manufacturerSerialNumber;
            this.dllSerialNumber = dllSerialNumber;
            this.locked = locked;
            this.requestedQuantity = requestedQuantity;
            this.availableQuantity = availableQuantity;
            this.acceptedQuantity = acceptedQuantity;
            this.rejectedQuantity = rejectedQuantity;
            this.selectedQuantity = locked ? '0' : selectedQuantity;
            this.closed = closed;
        }
    }
}