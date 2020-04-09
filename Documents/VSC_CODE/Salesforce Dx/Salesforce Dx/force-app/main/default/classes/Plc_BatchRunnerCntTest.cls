/**
 * @author Shahid Khan
 * @date Creation 04/03/2019
 
 * @version 1.0
 * @description Test of Plc_ActivityPrintReportCnt.
 */
 @isTest
 public class Plc_BatchRunnerCntTest {
     
    @TestSetup
    static void setup(){
        
    Plc_SystemSettings__c PROCESS_SETTINGS = new Plc_SystemSettings__c();
		PROCESS_SETTINGS.Plc_MonthsToRemovePrdSnpShot__c=3;
		PROCESS_SETTINGS.Plc_DaysForCalculatingConsumption__c = 30;
        PROCESS_SETTINGS.Plc_PurchaseWarrantyMonthsDelay__c   = 5;
		insert PROCESS_SETTINGS;

		Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Id b2ShopDealRecType = Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');

        Bit2Shop__Dealer__c bit2ShopDealerParent = Plc_TestFactory.createDealer('dealerParent', account,'456512665');
        bit2ShopDealerParent.Plc_Repairer__c = true;
        insert bit2ShopDealerParent;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealerChild('dealer', account,'4565165',bit2ShopDealerParent);
        bit2ShopDealer.Bit2Shop__Approver_Group_Id__c = 'dealerfarman';
        bit2ShopDealer.RecordTypeId = b2ShopDealRecType;

        Bit2Shop__Dealer__c bit2ShopDealer2 = Plc_TestFactory.createDealerChild('dealerali', account, '456516589',bit2ShopDealerParent);
        bit2ShopDealer2.Bit2Shop__Approver_Group_Id__c = 'dealer2';
        bit2ShopDealer2.RecordTypeId = b2ShopDealRecType;
        bit2ShopDealer2.Plc_Repairer__c = true;
        
        insert new List<Bit2Shop__Dealer__c> {bit2ShopDealer, bit2ShopDealer2};
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Irrecoverable', '','123456789',bit2ShopDealer);

        Bit2Shop__Warehouse__c bit2ShopWarehouse2 = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI','Repaired','Nexi','123456780',bit2ShopDealer2);
        bit2ShopWarehouse2.Plc_UniqueKey__c = '356';
        insert new List<Bit2Shop__Warehouse__c>{bit2ShopWarehouse, bit2ShopWarehouse2};
        
		List<Plc_ProductStockSnapshot__c> productStockSnapshots = new List<Plc_ProductStockSnapshot__c>();
		
		for(Integer i = 0; i < 200; i++) {

			Plc_ProductStockSnapshot__c productStockSnapshot = new Plc_ProductStockSnapshot__c(Plc_Warehouse__c=''+bit2ShopWarehouse.Id,Plc_Timestamp__c=System.now().addMonths(-Integer.valueOf(PROCESS_SETTINGS.Plc_MonthsToRemovePrdSnpShot__c)-1));
			productStockSnapshots.add(productStockSnapshot);
		}
		insert productStockSnapshots;
    
    }
    
    @isTest
    static void batchStatusTest(){ 
    
      string classname = 'Plc_RemoveProductStockSnapshotJob';
      Plc_BatchRunnerCnt.getBatchStatus(classname);
      Plc_BatchRunnerCnt.getBatchExecutionsStatuses(classname);
      Plc_BatchRunnerCnt.runBatchByName(classname);
      Plc_BatchManagerService.executeBatch(classname);
      Plc_BatchRunnerCnt.stopBatch(classname);
      Map<String,Object> itemRetrieved = Plc_BatchRunnerCnt.getBatchAvailable();
      Map<String,String> translation = Plc_BatchRunnerCnt.retrieveTranslationMap();
    }
    
  }