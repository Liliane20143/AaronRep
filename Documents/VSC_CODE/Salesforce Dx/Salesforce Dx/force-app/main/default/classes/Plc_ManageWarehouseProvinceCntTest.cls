/**
 * ***********************************************************************************
 *     * @Author abdoulaye.diop@/webresults.it
 *     * @date  28/02/2019
 *     * @description Test of Controller Plc_ManageWarehouseProvinceCnt
 * ************************************************************************************
 **/
@isTest
public class Plc_ManageWarehouseProvinceCntTest {
    
    @TestSetup
    static void Setup(){
        
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('name', account, '12345');
        bit2ShopDealer.Plc_Alias__c = '12345';
        bit2ShopDealer.Plc_Repairer__c = true;
        bit2ShopDealer.Bit2Shop__Dealer_Type__c = 'filter';
        insert bit2ShopDealer;

        Plc_DistributionList__c plcDistributionList=new Plc_DistributionList__c(Plc_Alias__c='Requested',Plc_Status__c='Draft');
        insert plcDistributionList;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Repaired', '',
            '00789654123654789', bit2ShopDealer);
        insert bit2ShopWarehouse;

                Plc_WarehouseProvince__c warehouseProvince = new Plc_WarehouseProvince__c();
        warehouseProvince.Plc_Province__c = 'AL';
        warehouseProvince.Plc_Warehouse__c = bit2ShopWarehouse.Id;
        warehouseProvince.Plc_DistributionPercentage__c = 60;
        
        Plc_WarehouseProvince__c warehouseProvince2 = new Plc_WarehouseProvince__c();
        warehouseProvince2.Plc_Province__c = 'AL';
        warehouseProvince2.Plc_Warehouse__c = bit2ShopWarehouse.Id;
        warehouseProvince2.Plc_DistributionPercentage__c = 40;
        insert new List<Plc_WarehouseProvince__c>{warehouseProvince,warehouseProvince2};
    }
	
    /**
     *  @Author abdoulaye.diop@/webresults.it
     *  @date  06/03/2019
     *  @description Test of the method getPickListValues
     */
    @isTest
    static void getPickListValuesTest(){
        Test.startTest();
        Plc_ManageWarehouseProvinceCnt.getPickListValues('Plc_Province__c');
        Test.stopTest();
    }
    
    /**
     *  @Author abdoulaye.diop@/webresults.it
     *  @date  06/03/2019
     *  @description Test of the method findWareHouses
     */
    @isTest
    static void findWareHousesTest(){
        Test.startTest();
        Plc_ManageWarehouseProvinceCnt.findWareHouses('nexi');
        Test.stopTest();
    }
    
    /**
     *  @Author abdoulaye.diop@/webresults.it
     *  @date  06/03/2019
     *  @description Test of the method saveWarehouses
     */
    @isTest
    static void saveWarehousesTest(){
        List<Plc_WarehouseProvince__c> warehouseProvinces = new List<Plc_WarehouseProvince__c>();
        Bit2Shop__Warehouse__c bit2ShopWarehouse = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];
        
        Plc_WarehouseProvince__c warehouseProvince = new Plc_WarehouseProvince__c();
        warehouseProvince.Plc_Province__c = 'AL';
        warehouseProvince.Plc_Warehouse__c = bit2ShopWarehouse.Id;
        warehouseProvince.Plc_DistributionPercentage__c = 100;
        warehouseProvinces.add(warehouseProvince);
        
        Test.startTest();
        Map<String, String> result = Plc_ManageWarehouseProvinceCnt.saveWarehouses(JSON.serialize(warehouseProvinces));
        System.assertEquals(result.get('error'), 'false');

        Plc_WarehouseProvince__c warehouseProvince2 = new Plc_WarehouseProvince__c();
        warehouseProvinces.add(warehouseProvince2);
        Map<String, String> result2 = Plc_ManageWarehouseProvinceCnt.saveWarehouses(JSON.serialize(warehouseProvinces));
        System.assertEquals(result2.get('error'), 'true');
        Test.stopTest();
    }

    @isTest
    static void findWarehouseProvincesByProvinceTest(){
        Test.startTest();
        Map<String, String> result = Plc_ManageWarehouseProvinceCnt.findWarehouseProvincesByProvince('AG');
        System.assertEquals(result.get('error'), 'false');
        Test.stopTest();
    }

    /**
     *  @Author FB
     *  @date  29/03/2019
     *  @description Test of the method retrievePropertiesMap 
     */
    @isTest
    static void retrieveTranslationsMapTest(){
        Test.startTest();
        Plc_ManageWarehouseProvinceCnt.retrieveTranslationsMap();
        Test.stopTest();
    }
}