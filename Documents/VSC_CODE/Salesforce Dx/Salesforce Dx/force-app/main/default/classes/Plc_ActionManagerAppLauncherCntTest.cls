/** 
 * @author Mame Diarra
 * @date Creation 26/02/2019
 * @version 1.0
 * @description test of Plc_ActionManagerAppLauncherCnt class.
 */
@isTest
public class Plc_ActionManagerAppLauncherCntTest {
    @testSetup
    static void setup() {
        
        Plc_TestFactory.initProcessClickPackage();
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'New');
        bit2ShopDealer.Plc_Maintainer__c=true;
        insert bit2ShopDealer;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('nexi', 'Generic','','000001NEXI',bit2ShopDealer);
        insert bit2ShopWarehouse;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'test','type');
        insert b2wExtCatExtCat;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c =2;
        bit2ShopProductStock.Plc_WithdrawnQty__c=1; 
        insert bit2ShopProductStock;

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Repaired';
        insert bit2ShopStockSerials2;
        
        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c(
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Point_Of_Sales_Id__c              = bit2ShopDealer.Id,
                Bit2Shop__Holding_Id__c                     = account.Id,
                Bit2Shop__Warehouse_Id__c                   = bit2ShopWarehouse.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = bit2ShopDealer.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = bit2ShopWarehouse.Id
        );
        insert stockOrder;

        Bit2Shop__Shipment__c shipmentIn = new Bit2Shop__Shipment__c(
                RecordTypeId                            = Plc_Utils.getRecordTypeId(Plc_WorkOrderApxAct.SHIPMENT_RECORDTYPE_INBOUND,
                                                            Bit2Shop__Shipment__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                     = Plc_WorkOrderApxAct.SHIPMENT_STATUS_CLOSED,
                Bit2Shop__Expected_Delivery_Date__c     = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Close_Date__c                 = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Date__c                       = stockOrder.Bit2Shop__Date__c,
                Bit2Shop__Shipped_Quantity__c           = 1,
                Bit2Shop__Stock_Order_Id__c             = stockOrder.Id,
                Bit2Shop__Sub_Type__c                   = Plc_WorkOrderApxAct.SHIPMENT_SUBTYPE_INBOUND,
                Bit2Shop__Type__c                       = Plc_WorkOrderApxAct.SHIPMENT_TYPE_FINAL,
                Bit2Shop__Shipment_Document_Number__c   = 'Doc'
        );
        insert shipmentIn;


    }
        
    /** 
    * @author Mame Diarra
    * @date Creation 26/02/2019
    * @Modify 27/02/2019 by Mame Diarra
    * @Modify 28/02/2019 by Mame Diarra
    * @version 1.0
    * @description test of compatibilityCheck method.
    */
    @isTest
    static void compatibilityCheckWhenAccountTest() {
        Account account= [SELECT Id FROM Account LIMIT 1];
     
        UrlParameters urlParam= new UrlParameters();
        urlParam.objId=''+account.Id;
        urlParam.actionType='test';
        Test.startTest();
        Map<String, Object> result = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
       
        //when actionType equals placeHolder
        urlParam.actionType='placeHolder';
        Map<String, Object> result2 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        
        //when actionType and objId are empty
        UrlParameters urlParam3= new UrlParameters();
        Map<String,Object> result3 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam3));
        
        //when id and actionType are empty 
        Map<String, Object> result4 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck('');
        Test.stopTest();
    }

    /** 
    * @author Mame Diarra
    * @date Creation 27/02/2019
    * @Modify 28/02/2019 by Mame Diarra
    * @Modify 14/03/2019 by Mame Diarra
    * @version 1.0
    * @description test of compatibilityCheck method when Bit2Shop__Stock_Serials2__c.
    */
    @isTest
    static void compatibilityCheckWhenSotckSerial2Test() {
        
        Bit2Shop__Stock_Serials2__c b2StockSerials2= [SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
     
        UrlParameters urlParam= new UrlParameters();
        urlParam.objId=''+b2StockSerials2.Id;
        urlParam.actionType='test';
        Test.startTest();
        Map<String, Object> result = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        
        //when actionType equals placeHolder
        urlParam.actionType='serialMergeFromUndefined';
        Map<String, Object> result2 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));

        urlParam.actionType='fillReport';
        Map<String, Object> result3 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        Test.stopTest();
    }
    
    /** 
    * @author Mame Diarra
    * @date Creation 27/02/2019
    * @Modify 28/02/2019 by Mame Diarra
    * @version 1.0
    * @description test of compatibilityCheck method when Bit2Shop__StockOrder__c.
    */
    @isTest
    static void compatibilityCheckWhenSotckOrderTest() {
        
        Bit2Shop__StockOrder__c b2StockOrder= [SELECT Id FROM Bit2Shop__StockOrder__c LIMIT 1];
        
        
        UrlParameters urlParam= new UrlParameters();
        urlParam.objId=''+b2StockOrder.Id;
        urlParam.actionType='assign';
        Test.startTest();
        Map<String, Object> result = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        
        //when actionType equals TAKE_IN_CHARGE
        urlParam.actionType='takeInCharge';
        Map<String, Object> result2 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        
        //when actionType equals GOODS_RECEIVING
        urlParam.actionType='goodsReceiving';
        Map<String, Object> result3 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        
        //when else actionType  
        urlParam.actionType='test';
        Map<String, Object> result4 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
       
        Test.stopTest();
    }

    /** 
    * @author Mame Diarra
    * @date Creation 27/02/2019
    * @Modify 28/02/2019 by Mame Diarra
    * @version 1.0
    * @description test of compatibilityCheck method when Bit2Shop__StockOrder__c.
    */
    @isTest
    static void compatibilityCheckWhenWarehouseTest() {
        
        Bit2Shop__Warehouse__c warehouse= [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
     
        UrlParameters urlParam= new UrlParameters();
        urlParam.objId=''+warehouse.Id;
        urlParam.actionType='openComponent';
        Test.startTest();
        Map<String, Object> result = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        
        //when actionType equals placeHolder
        urlParam.actionType='placeHolder';
        Map<String, Object> result2 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        Test.stopTest();
    }
    
    /** 
    * @author FB
    * @date Creation 11/06/2019
    * @version 1.0
    * @description test of compatibilityCheck method when Bit2Shop__Shipment__c.
    */
    @isTest
    static void compatibilityCheckWhenShipmentTest() {
        
        Bit2Shop__Shipment__c shipment = [SELECT Id FROM Bit2Shop__Shipment__c LIMIT 1];
        
        UrlParameters urlParam= new UrlParameters();
        urlParam.objId=''+shipment.Id;
        
        Test.startTest();
        //when actionType equals GOODS_RECEIVING
        urlParam.actionType='goodsReceiving';
        Map<String, Object> result3 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        
        //when else actionType  
        urlParam.actionType='test';
        Map<String, Object> result4 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
       
        Test.stopTest();
    }

    /** 
    * @author Mame Diarra
    * @date Creation 27/02/2019
    * @Modify 28/02/2019 by Mame Diarra
    * @version 1.0
    * @description test of compatibilityCheck method when else.
    */
    @isTest
    static void compatibilityCheckWhenElseTest() {
        Bit2Shop__Dealer__c dealer= [SELECT Id FROM Bit2Shop__Dealer__c LIMIT 1];
     
        UrlParameters urlParam= new UrlParameters();
        urlParam.objId=''+dealer.Id;
        urlParam.actionType='test';
        Test.startTest();
        Map<String, Object> result = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        Test.stopTest();
    }

    /** 
    * @author Mame Diarra
    * @date Creation 28/02/2019
    * @Modify 14/03/2019 by Mame Diarra
    * @version 1.0
    * @description test of compatibilityCheck.
    */
    @isTest
    static void compatibilityCheckTest() {
        B2WExtCat__External_Catalog_Item__c extCat= [SELECT Id FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
     
        UrlParameters urlParam= new UrlParameters();
        urlParam.objId=' ';
        urlParam.actionType='dlManagement';
        Test.startTest();
        Map<String, Object> result = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        urlParam.actionType='serialsCensus';
        Map<String, Object> result2 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        urlParam.actionType='manageWarehouseProvince';
        Map<String, Object> result3 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        urlParam.actionType='productStockConsolidation';
        Map<String, Object> result4 = Plc_ActionManagerAppLauncherCnt.compatibilityCheck(JSON.serialize(urlParam));
        Test.stopTest();
    }

    public class UrlParameters {
        String objId { get; set ; }
        String actionType { get; set; }
        String additionalParameters { get; set; }
        String apiName { get; set; }
    }
}