/**
 * @author Shahid Khan
 * @date Creation 26/02/2019
 * @version 1.0
 * @description Test of Plc_StockOrderTriggerHnd.
 */
@isTest
public class Plc_StockOrderTriggerHndTest {
  
    @TestSetup
    static void setup(){

        Plc_TestFactory.initProcessClickPackage();
        Account acc = Plc_TestFactory.createAccountSupplier('Test');
        //acc.Name    =   'Test';
        insert acc;
        
        Bit2Shop__TransferDetail__c transfDetail1 = new Bit2Shop__TransferDetail__c(
                Bit2Shop__Code__c   = 'ACTION1',
                Bit2Shop__Transfer_Type__c = Plc_WorkOrderApxAct.STOCK_ORDER_TRANSFERTYPE_STOCK2OTHERSHOP,
                Plc_Alias__c        = 'TD001'
        );
        insert transfDetail1;
        
        Account account01 = Plc_TestFactory.createAccountSupplier('01');
        insert account01;

        Bit2Shop__Dealer__c dealerParent01 = Plc_TestFactory.createDealerParent('01', account01, 'TD001');
        insert dealerParent01;

        Bit2Shop__Dealer__c dealerChild01 = Plc_TestFactory.createDealerChild('02', account01,'TD003', dealerParent01);
        dealerChild01.Plc_Maintainer__c = true;
        insert dealerChild01;

        Bit2Shop__Warehouse__c whouse01 = Plc_TestFactory.createWarehouse('Nexi','Generic','Nexi', 'WH0001', dealerChild01);
        insert whouse01;

        Account account02 = Plc_TestFactory.createAccountSupplier('02');
        insert account02;

        Bit2Shop__Dealer__c dealerParent02 = Plc_TestFactory.createDealerParent('03', account02, 'TD002');
        insert dealerParent02;

        Bit2Shop__Dealer__c dealerChild02 = Plc_TestFactory.createDealerChild('04', account02,'TD004', dealerParent02);
        dealerChild02.Plc_Maintainer__c = true;
        insert dealerChild02;

        Bit2Shop__Warehouse__c whouse02 = Plc_TestFactory.createWarehouse('Nexi12','Generic','Nexi', 'WH0002',dealerChild02);
        insert whouse02;
        
        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c(
                RecordtypeId  = Plc_Utils.getRecordTypeId('Transfer',Bit2Shop__StockOrder__c.SObjectType.getDescribe().name),
                Bit2Shop__Status__c                         = 'Generated',
                Plc_TransferDetail__c                       = transfDetail1.Id,
                Bit2Shop__Date__c                           = System.today(),
                Plc_ShippingDate__c                         = System.today(),
                Plc_CloseDate__c                            = System.today(),
                Bit2Shop__Transfer_Type__c                  = 'Stock2OtherShop',
                Bit2Shop__Point_Of_Sales_Id__c              = dealerChild01.Id,
                Bit2Shop__Destination_Point_Of_Sales_Id__c  = dealerChild02.Id,
                Bit2Shop__Destination_Warehouse_Id__c       = whouse02.Id,
                Bit2Shop__Holding_Id__c                     = account01.Id,
                Bit2Shop__Warehouse_Id__c                   = whouse01.Id
        );
        insert stockOrder;

    }

    /**
    * @author Shahid Khan
    * @date Creation 263/02/2019
    * @version 1.0
    * @description Test of the method dretrieveLegacyInfo
    */
    @isTest
    static void AfterUpdateTest(){
        //Bit2Shop__StockOrder__c stockorder = [SELECT Id,Bit2Shop__Status__c FROM Bit2Shop__StockOrder__c LIMIT 1];
        MAP<Id,Bit2Shop__StockOrder__c> oldStockOrderMap = new MAP<Id,Bit2Shop__StockOrder__c>([SELECT Id,Bit2Shop__Status__c FROM Bit2Shop__StockOrder__c LIMIT 1]);
        Plc_SystemSettings__c settings = Plc_SystemSettings__c.getOrgDefaults();
        
        settings.Plc_PurchaseWarrantyMonthsDelay__c = 20.0;
        settings.Plc_DaysForCalculatingConsumption__c = 10.0;
        insert settings;
        system.debug('===settingss=='+settings);
        Bit2Shop__StockOrder__c stockOrd = oldStockOrderMap.values();
        stockOrd.Bit2Shop__Status__c = 'Assigned';
        update stockOrd;
        MAP<Id,Bit2Shop__StockOrder__c> newStockOrderMap = new MAP<Id,Bit2Shop__StockOrder__c>();
        newStockOrderMap.put(stockOrd.id,stockOrd);
        
        Plc_StockOrderTriggerHnd obj = new Plc_StockOrderTriggerHnd();
        obj.AfterUpdate(newStockOrderMap,oldStockOrderMap);
    }

   /**
    * @author Moussa FOFANA
    * @date Creation 21/03/2019
    * @version 1.0
    * @description Test of the method AfterDelete
    */
    @isTest
    static void beforeDeleteDeleteTest(){
        
        MAP<Id,Bit2Shop__StockOrder__c> stockOrderMap = new MAP<Id,Bit2Shop__StockOrder__c>([SELECT Id,Bit2Shop__Status__c FROM Bit2Shop__StockOrder__c LIMIT 1]);
        
        Plc_StockOrderTriggerHnd obj = new Plc_StockOrderTriggerHnd();

        Test.startTest();
        	obj.BeforeDelete(stockOrderMap);
        Test.stopTest();

    }

   /**
    * @author Moussa FOFANA
    * @date Creation 21/03/2019
    * @version 1.0
    * @description Test of the method AfterDelete
    */
    @isTest
    static void afterDeleteTest(){
        
        MAP<Id,Bit2Shop__StockOrder__c> stockOrderMap = new MAP<Id,Bit2Shop__StockOrder__c>([SELECT Id,Bit2Shop__Status__c FROM Bit2Shop__StockOrder__c LIMIT 1]);
        
        Plc_StockOrderTriggerHnd obj = new Plc_StockOrderTriggerHnd();

        Test.startTest();
            obj.AfterDelete(stockOrderMap);
        Test.stopTest();

    }
   /**
    * @author Moussa FOFANA
    * @date Creation 21/03/2019
    * @version 1.0
    * @description Test of the method AfterUndelete
    */
    @isTest
    static void afterUndeleteTest(){
        
        MAP<Id,Bit2Shop__StockOrder__c> stockOrderMap = new MAP<Id,Bit2Shop__StockOrder__c>([SELECT Id,Bit2Shop__Status__c FROM Bit2Shop__StockOrder__c LIMIT 1]);
        
        Plc_StockOrderTriggerHnd obj = new Plc_StockOrderTriggerHnd();

        Test.startTest();
            obj.AfterUndelete(stockOrderMap);
        Test.stopTest();

    }

}