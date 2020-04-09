/**
 * ***********************************************************************************
 *     * @Author abdoulaye.diop@/webresults.it
 *     * @date  19/04/2019
 *     * @description test of the class  Plc_AvailableStockPercentageWgtCnt 
 * ************************************************************************************
 **/
 @isTest
public with sharing class Plc_AvailableStockPercentageWgtCntTst {
   
    @testSetup
    static void makeData(){
         
          Plc_TestFactory.initProcessClickPackage();

          /*********************************  Bit2Shop__Dealer__c  *****************************************************/

          Account account = Plc_TestFactory.createAccountSupplier('test account');
          insert account;

          /*********************************  Bit2Shop__Dealer__c  *****************************************************/

          Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('dealerParent', account, 'aliasParent');
          insert parentDealer;
          Bit2Shop__Dealer__c childDealer = Plc_TestFactory.createDealerChild('dealerChild', account, 'aliasChild', parentDealer);
          insert childDealer;

          /*********************************  Bit2Shop__Warehouse__c  *****************************************************/

          Bit2Shop__Warehouse__c warehouse = Plc_TestFactory.createWarehouse('warehouseChild', 'Installed', 'Nexi', '000001NEXI', childDealer);
          insert warehouse; 

          /*********************************  B2WExtCat__External_Catalog__c*****************************************************/

          B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
          insert b2WExtCatExtCatalog;

          /*********************************  B2WExtCat__External_Catalog_Item__c*****************************************************/

          B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'sku','type');
          b2wExtCatExtCat.Plc_Subcategory__c='POS'; 
          insert b2wExtCatExtCat;

          /*********************************  Bit2Shop__Product_Stock__c *****************************************************/

          Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, warehouse);
          insert bit2ShopProductStock;
         
          /*********************************  Bit2Shop__Stock_Serials2__c *****************************************************/

          List<Bit2Shop__Stock_Serials2__c> bit2ShopStockSerialsList = new List<Bit2Shop__Stock_Serials2__c>();
          List<String> statusList = new List<String>{'Installed', 'Available', 'Withdrawn'};
          for(String status: statusList){
            Bit2Shop__Stock_Serials2__c bit2ShopStockSerials = Plc_TestFactory.createStockSerial2(warehouse,status);
            bit2ShopStockSerials.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id;
            if(status == 'Installed') {
              bit2ShopStockSerialsList.add(bit2ShopStockSerials.clone());
            }
            bit2ShopStockSerialsList.add(bit2ShopStockSerials);
          }
          insert bit2ShopStockSerialsList;
        

          /*********************************  END SETUP  *************************************/
     }

    @isTest
    static void getAllSerialsByStatusListTest(){
        Test.startTest();
          String developerName = 'test';
          Map<String, String> results = Plc_AvailableStockPercentageWgtCnt.getAllSerialsByStatusList(developerName);  
        Test.stopTest();
        System.assert(results.get('percentage') != 'error');
    }    
}