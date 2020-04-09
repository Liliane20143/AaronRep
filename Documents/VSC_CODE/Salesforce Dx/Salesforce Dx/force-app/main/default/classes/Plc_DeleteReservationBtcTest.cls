/**
 * @author Pietro Santochirico 
 * @date Creation 01//03/2019
 * @description Test class for Plc_DeleteReservationBtc.
 */
@isTest
private class Plc_DeleteReservationBtcTest {

    
    @testSetup
    static void setup() {
        insert new Plc_SystemSettings__c(Name = 'SystemSettings',
           Plc_DaysForCalculatingConsumption__c = 30,
           Plc_PurchaseWarrantyMonthsDelay__c   = 5
        );

        Plc_ProcessSettings__c csMaxDays = new Plc_ProcessSettings__c();
        csMaxDays.Plc_MaxDaysToRetainReservations__c = 10;
        insert csMaxDays;
        
        Plc_TestFactory.initProcessClickPackage();
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c dealerParent = Plc_TestFactory.createDealerParent('name',  account, 'test');
        insert dealerParent;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealerChild('name', account, '1234567', dealerParent);
        bit2ShopDealer.Bit2Shop__Approver_Group_Id__c = 'dealer';
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Repaired', '',
                '00889654123654789', bit2ShopDealer);
        insert bit2ShopWarehouse;
       
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = '00541237896541230';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        insert b2wExtCatExtCat;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 2;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 1;
        bit2ShopProductStock.Plc_OrderedQty__c=2;
        insert bit2ShopProductStock;
        
        WorkOrder WorkOrd= new WorkOrder(Status='Closed',Plc_FiscalCode__c='12345');
        insert WorkOrd;
    
        List<Plc_Reservation__c> plcReservations = new List<Plc_Reservation__c>();
        for(Integer i=0 ; i<200; i++){
        Plc_Reservation__c plcReservation = new Plc_Reservation__c(Plc_Status__c='NotReserved',Plc_ProductStock__c=bit2ShopProductStock.Id );
            plcReservations.add(plcReservation);
        }     
        insert plcReservations; 

        WorkOrderLineItem workOrdLineItem= new WorkOrderLineItem();
        workOrdLineItem.WorkOrderId=WorkOrd.Id;
        workOrdLineItem.Plc_Reservation__c = plcReservations[0].id;
        insert workOrdLineItem;
    }
    
    /** 
    * @author Mame Diarra
    * @date Creation 04/03/2019
    * @version 1.0
    * @description test Batch execution.
    */
    
    @isTest
    static void executeBatchTest() {
        
        Plc_DeleteReservationBtc deleteReservationBtc = new Plc_DeleteReservationBtc();
        Test.startTest();
        Integer initialSize;
        Integer afterSize;
        Id batchId  =   Database.executeBatch(deleteReservationBtc);
        Database.BatchableContext batchableContext;
        List<Plc_Reservation__c> plcReservation = [select id,(select id FROM Plc_WorkOrderLineItems__r) from Plc_Reservation__c];

        initialSize = plcReservation.size();

        deleteReservationBtc.execute(batchableContext, plcReservation);
        system.debug('==reservationList=='+plcReservation);
        deleteReservationBtc.finish(batchableContext);

        

        List<Plc_Reservation__c> noReservation = [select id,(select id FROM Plc_WorkOrderLineItems__r) from Plc_Reservation__c];
        afterSize = noReservation.size();
        System.assertEquals(afterSize+1,initialSize);
        Test.stopTest();
    }
    
    
}