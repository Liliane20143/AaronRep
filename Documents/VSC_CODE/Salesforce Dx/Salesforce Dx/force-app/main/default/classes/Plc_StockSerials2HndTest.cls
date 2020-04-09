/*
 * @date creator 28/01/2019
 * @author Alessandro Picchiri
 * @modified by Abdoulaye DIOP 29/03/2019
 * @description
 * */
@isTest
public class Plc_StockSerials2HndTest {
    
    @testSetup    
    static void setup(){

        Plc_TestFactory.initProcessClickPackage();  
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'123456');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;
      
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Repaired','','000001NEXI', bit2ShopDealer);
        insert bit2ShopWarehouse;
        
        Plc_TermId__c plcTerm = Plc_TestFactory.createTermId('55245846');
        insert plcTerm;
        
        Bit2Shop__Stock_Serials2__c stockSerial = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'');
        stockSerial.Bit2Shop__Serial_Number__c='01223150640';
        stockserial.Plc_ComeFromProcess__c=true;
        stockSerial.Plc_TermId__c = plcTerm.Id;
        insert stockSerial;
    }
    @isTest static void unit_test_IsDisabled_false(){
        
        // inizio il test
        test.startTest();
                
        TriggerSettings__c setting = new TriggerSettings__c();
        setting.StockSerial2Trigger__c = System.now();
        insert setting;
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        Boolean isdisp = pss2h.IsDisabled();
        
        // termino il test
        test.stopTest();
        
        // eseguo la verifica
        System.assertEquals(isdisp,false);
        
    }
    
    @isTest static void unit_test_IsDisabled_true(){
        
        // inizio il test
        test.startTest();

        TriggerSettings__c setting = new TriggerSettings__c();
        setting.StockSerial2Trigger__c = System.now().addDays(3);
        insert setting;
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        Boolean isdisp = pss2h.IsDisabled();
        
        // termino il test
        test.stopTest();
        
        // eseguo la verifica
        System.assertEquals(isdisp,true);
        
    }
    
    @isTest static void unit_test_BeforeInsert(){
        
        test.startTest();
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        List<SObject> newItems = new List<SObject>();
        pss2h.BeforeInsert(newItems);
        
        test.stopTest();
        
    }
    
    @isTest static void unit_test_AfterInsert(){
        
        test.startTest();
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        Map<Id,SObject> newItems = new Map<Id,SObject>();
        pss2h.AfterInsert(newItems);
        
        test.stopTest();
        
    }
    /*
    @isTest static void unit_test_AfterUpdate(){
        
        test.startTest();
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        Map<Id,SObject> newItems = new Map<Id,SObject>();
        Map<Id,SObject> oldItems = new Map<Id,SObject>();
        pss2h.AfterUpdate(newItems,oldItems);
        
        test.stopTest();
        
    }
    
    @isTest static void unit_test_AfterDelete(){
        
        test.startTest();
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();        
        Map<Id,SObject> oldItems = new Map<Id,SObject>();
        pss2h.AfterDelete(oldItems);
        
        test.stopTest();
        
    }
    
    @isTest static void unit_test_AfterUndelete(){
        
        test.startTest();
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        Map<Id,SObject> newItems = new Map<Id,SObject>();
        Map<Id,SObject> oldItems = new Map<Id,SObject>();
        pss2h.AfterUpdate(newItems,oldItems);
        
        test.stopTest();
        
    }
    */
    
    /**
    * @author Mame Diarra
    * @date Creation 08/02/2019
    * @version 1.0
    * @description Test of the BeforeUpdate.
    */
    @isTest
    static void beforeUpdateTest(){   
        
        wrts_prcgvr__PhaseManagerSObjectSetting__c phaseManagerSObjectSetting = new wrts_prcgvr__PhaseManagerSObjectSetting__c();
        phaseManagerSObjectSetting.wrts_prcgvr__ObjectType__c='Object';
        phaseManagerSObjectSetting.Name='Account';
        insert phaseManagerSObjectSetting;
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        
        Bit2Shop__Stock_Serials2__c stockSerials=[SELECT ID,Plc_ComeFromProcess__c, Bit2Shop__Warehouse_Id__c FROM Bit2Shop__Stock_Serials2__c];
        Map<Id,SObject> newItems = new Map<Id,SObject>();
                        newItems.put(stockSerials.Id,stockSerials);
        
        Map<Id,SObject> oldItems = new Map<Id,SObject>();
        
        Test.startTest();
            pss2h.BeforeUpdate(newItems,oldItems);
        Test.stopTest(); 
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 11/02/2019
    * @version 1.0
    * @description Test of the BeforeDelete.
    */
    @isTest
    static void beforeDeleteTest(){
        
        Plc_StockSerials2Hnd pss2h = new Plc_StockSerials2Hnd();
        Map<Id,SObject> newItems = new Map<Id,SObject>();
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer1', account,'1234567');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Repaired','', '00789654123654780', bit2ShopDealer);
        insert bit2ShopWarehouse;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541231');
        insert plcSolution;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem( 'Catalog Item1', b2WExtCatExtCatalog,'test','Process');
        b2wExtCatExtCat.Plc_Alias__c = '00541237896541231';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        insert b2wExtCatExtCat;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c       =   2;
        bit2ShopProductStock.Plc_WithdrawnQty__c    =   1; 
        insert bit2ShopProductStock;

       //Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = new Bit2Shop__Stock_Serials2__c();
        //bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c = bit2ShopWarehouse.Id;
        //bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
        //bit2ShopStockSerials2.Bit2Shop__Status__c = 'New';
        //bit2ShopStockSerials2.Plc_Status2__c = 'None';
        
        //insert bit2ShopStockSerials2;
        
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846d');
        insert plcTermId;

        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials1= Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        bit2ShopStockSerials1.Plc_ManufacturerSerialNumber__c = '2value2';
        bit2ShopStockSerials1.Plc_Status2__c = 'None';
        bit2ShopStockSerials1.Plc_EncodedSerialNumber__c = 'Test';
        bit2ShopStockSerials1.Bit2Shop__Product_Stock_Id__c= bit2ShopProductStock.Id;
        bit2ShopStockSerials1.Plc_Property__c='N';
        bit2ShopStockSerials1.Plc_PcipedModel__c='plc_PcipedModel';
        bit2ShopStockSerials1.Bit2Shop__IMEI__c='bit2ShopIMEI';
        bit2ShopStockSerials1.Bit2Shop__ICCID__c='bit2ShopICCID';
        bit2ShopStockSerials1.Plc_PTSCode__c='ptccode';
        bit2ShopStockSerials1.Plc_TermId__c= plcTermId.Id;
        bit2ShopStockSerials1.Bit2Shop__Serial_Number__c = 'bit2ShopSerialNumber';
        bit2ShopStockSerials1.Plc_PcipedLetterOfApproval__c='plcPcipedLetterOfApproval';
        bit2ShopStockSerials1.Plc_PcipedApprovalNumber__c= 'plcPcipedApprovalNumber';
        bit2ShopStockSerials1.Plc_PcipedVersion__c='plcPcipedVersion';
        bit2ShopStockSerials1.Plc_PcipedExpiryDate__c = Date.newInstance(System.now().year(),System.now().month(),System.now().day());
        insert bit2ShopStockSerials1;
        
        newItems.put(bit2ShopStockSerials1.Id,bit2ShopStockSerials1);
        
        Test.startTest();
        pss2h.BeforeDelete(newItems);
        Map<Id, SObject> oldItems = new Map<Id, SObject>();
        pss2h.AfterDelete(oldItems);
        pss2h.AfterUndelete(oldItems);
        Test.stopTest(); 
    }
    
}