/**
 * @author Emanuele Campese
 * @date Creation 19/03/2019
 * @description Plc_DeleteStockSerial2FromWarehouseBtc - Batch to delete all stock serial 2 from warehouse where created date < customDays .
 */
@isTest
public class Plc_DeleteStSe2FromWarehouseBtcTest {
    @testSetup
    public static void setup() {
        Plc_ProcessSettings__c processSettings = Plc_TestFactory.createProcessSettings();
        insert processSettings;

        TriggerSettings__c setting = new TriggerSettings__c();
        setting.StockSerial2Trigger__c = System.now().addDays(1);
        insert setting;

        Account account =   Plc_TestFactory.createAccountSupplier('Account');
        //account.name    =   'Account';
        insert account;

        Bit2Shop__Dealer__c dealerParent = Plc_TestFactory.createDealerParent('01',account,'TD001');
        insert dealerParent;

        Bit2Shop__Dealer__c dealerChild = Plc_TestFactory.createDealerChild('02',account,'TD002',dealerParent);
        dealerChild.Plc_Repairer__c = false;
        dealerChild.Plc_Manufacturer__c = true;
        insert dealerChild;

        Bit2Shop__Warehouse__c warehouse = Plc_TestFactory.createWarehouse('Nexi','New','Neutral', 'WH0001', dealerChild);
        insert warehouse;

        Plc_TermId__c termId = new Plc_TermId__c();
        insert termId;

        List<Bit2Shop__Stock_Serials2__c> stockSerialToDeleteList1 = new List<Bit2Shop__Stock_Serials2__c>();
        for(Integer i=0;i<150;i++){
            Bit2Shop__Stock_Serials2__c stockSerial2 = Plc_TestFactory.createStockSerial2(warehouse,' ');
            stockSerial2.Bit2Shop__Status__c = 'New';
            stockSerialToDeleteList1.add(stockSerial2);
        }
        insert stockSerialToDeleteList1;

        List<Bit2Shop__Stock_Serials2__c> stockSerialToDeleteList2 = new List<Bit2Shop__Stock_Serials2__c>();
        for(Bit2Shop__Stock_Serials2__c stockSerialFromList : stockSerialToDeleteList1){

            Bit2Shop__Stock_Serials2__c stkSer = new Bit2Shop__Stock_Serials2__c();
            stkSer = stockSerialFromList;

            Test.setCreatedDate(stkser.Id, Datetime.newInstance(2019, 01, 01, 00, 00, 00)) ;
            stockSerialToDeleteList2.add(stkser);
        }
        update stockSerialToDeleteList2;
    }
    @isTest
    public static void runTest(){
        Test.startTest();
        List<Bit2Shop__Stock_Serials2__c> listBefore = [SELECT Id,CreatedDate FROM Bit2Shop__Stock_Serials2__c];
        Database.executeBatch(new Plc_DeleteStockSerial2FromWarehouseBtc() );
        List<Bit2Shop__Stock_Serials2__c> listAfter = [SELECT Id,CreatedDate FROM Bit2Shop__Stock_Serials2__c];
        System.assertEquals(listBefore.size(),listAfter.size());
        Test.stopTest();
    }
}