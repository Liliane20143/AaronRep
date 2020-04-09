/**
 * @author Abdoulaye & Moussa
 * @date Creation 05/12/2018
 * @date Modification 09/04/2019 by @Abdoulaye
 * @version 1.0
 * @description Test of PLC Plc_ProductStocksServices Rest WebService.
 */
@isTest
public class Plc_ProductStocksServicesTest {

    @testSetup
    static void setup(){   

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        Account acc = Plc_TestFactory.createAccountSupplier('Test');
        Account acc3 = Plc_TestFactory.createAccountSupplier('Test');
        insert new List<Account>{account,acc,acc3};

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, '6661');
        bit2ShopDealer.Plc_Repairer__c = true;
        //bit2ShopDealer.Plc_Alias__c='6661';

        Bit2Shop__Dealer__c bit2ShopDealer2 = Plc_TestFactory.createDealer('dealer2', account, '666100');
        bit2ShopDealer2.Plc_Repairer__c = true;
        

        Bit2Shop__Dealer__c bit2ShopDealer3 = Plc_TestFactory.createDealer('dealer3', account, '6661005');
        bit2ShopDealer2.Plc_Repairer__c = true;
        
        insert new List<Bit2Shop__Dealer__c>{bit2ShopDealer, bit2ShopDealer2, bit2ShopDealer3};
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Repaired', '','00789654123654789', bit2ShopDealer);
        //bit2ShopWarehouse.Plc_Tipology__c = 'Repaired';

        Bit2Shop__Warehouse__c bit2ShopWarehouse2 = Plc_TestFactory.createWarehouse('FORNITORE FITTIZIO - NEXI', 'Repaired', '','123456789', bit2ShopDealer2);

        insert new List<Bit2Shop__Warehouse__c>{bit2ShopWarehouse2,bit2ShopWarehouse};

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');

        //plcSolution.Plc_MandatorySpareParts__c = 'Alimentatore';
        Plc_Solution__c plcSolution2 = Plc_TestFactory.createSolution('123456789');
        insert new List<Plc_Solution__c>{plcSolution,plcSolution2};

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog2 = Plc_TestFactory.createExtCatalog('Test Cat');

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog3 = Plc_TestFactory.createExtCatalog('Test Cat New');

        insert new List<B2WExtCat__External_Catalog__c>{b2WExtCatExtCatalog,b2WExtCatExtCatalog2,b2WExtCatExtCatalog3};

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '00541237896541230', 'Process');
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        //b2wExtCatExtCat.Plc_ProductSku__c = '00541237896541230';
        insert b2wExtCatExtCat;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat2 = Plc_TestFactory.createExtCatalogItem('Cat Item', b2WExtCatExtCatalog2, '123456789', 'Process');
        b2wExtCatExtCat2.Plc_Solution__c = plcSolution2.Id;
        insert b2wExtCatExtCat2;

        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat3 = Plc_TestFactory.createExtCatalogItem('Cat Item', b2WExtCatExtCatalog3, '1234567890', 'Process');
        b2wExtCatExtCat3.Plc_Solution__c = plcSolution2.Id;
        insert b2wExtCatExtCat3;

        /*********************************** NEW PRODUCT ***************************************************/

        Bit2Shop__Product_Stock__c bit2ShopProductStock1 = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock1.Plc_UsableQty__c = 10;
        bit2ShopProductStock1.Plc_WithdrawnQty__c = 10;
        insert bit2ShopProductStock1;

        Bit2Shop__Product_Stock__c bit2ShopProductStock2 = Plc_TestFactory.createProductStock(b2wExtCatExtCat2, bit2ShopWarehouse2);
        bit2ShopProductStock2.Plc_UsableQty__c = 0;
        bit2ShopProductStock2.Plc_WithdrawnQty__c = 0;
        insert bit2ShopProductStock2;

        Bit2Shop__Product_Stock__c bit2ShopProductStock3 = Plc_TestFactory.createProductStock(b2wExtCatExtCat3, bit2ShopWarehouse2);
        bit2ShopProductStock3.Plc_UsableQty__c = 10;
        bit2ShopProductStock3.Plc_WithdrawnQty__c = 10;
        insert bit2ShopProductStock3;

        /*****************************************************************************************************/

        Plc_WorkOrderConfiguration__c workOrderConfiguration = new Plc_WorkOrderConfiguration__c();
        workOrderConfiguration.Plc_IntegrationName__c='To Install';
        workOrderConfiguration.Plc_EligibleOperationTypes__c='ToInstall';
        workOrderConfiguration.Plc_NeedsCalculation__c=true;
        workOrderConfiguration.Plc_NeedsReservation__c=true;
        insert workOrderConfiguration;
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 05/12/2018
     * @date Modification 22/02/2019 by @Abdoulaye DIOP
     * @version 1.0
     * @description Test of the method productStocksCheck with parameter  Plc_Wrappers.GestioneDisponibilitaRequest.
     */
    @isTest
    static void productStocksCheckWithRequestListTest(){        


        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat=[SELECT Plc_Alias__c,Plc_ProductSku__c ,B2WExtCat__External_Catalog__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        Bit2Shop__Warehouse__c bit2ShopWarehouse = [SELECT Plc_Alias__c,Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 10;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3;
        insert bit2ShopProductStock;

        system.debug('==catelineitem=='+b2wExtCatExtCat.Plc_ProductSku__c );
        system.debug('==warehouseItem=='+bit2ShopWarehouse.Plc_Alias__c);
        //system.debug('==productStock=='+[select id,Plc_AvailableQty__c from Bit2Shop__Product_Stock__c]);
        //00789654123654789
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita1 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Install', '00541237896541230', '1234567980', '00789654123654789');

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita2 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'To Install', '00541237896541230', '1234567980', '00789654123654789');

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'To Install', '00541237', '1234567980', '00789654');

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita3 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'To Install', '00541237', '1234567980', '00789654123654789');
              
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita4 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'To Install', '0078965412365478', '1234567980', '007896541236547891');
        
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        request.add(gestionDisponibilita1);
        request.add(gestionDisponibilita2);
        request.add(gestionDisponibilita3);
        request.add(gestionDisponibilita4);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
  
        // Start test
        Test.startTest();

            gestioneDisponibilitaRequest.request[0].requestType = 'Installation';
            gestioneDisponibilitaRequest.request[0].warehouseAlias = '00789654123654789';
            gestioneDisponibilitaRequest.request[0].resourceAlias = '00541237896541230';
            Plc_ServiceWs.ServiceResponse serviceResponse= Plc_ProductStocksServices.productStocksCheck(gestioneDisponibilitaRequest);
            
            bit2ShopProductStock.Plc_UsableQty__c=0;
            bit2ShopProductStock.Plc_WithdrawnQty__c=0;
            update bit2ShopProductStock;
            Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_ProductStocksServices.productStocksCheck(gestioneDisponibilitaRequest);   
        
        // Stop test
        Test.stopTest();
      
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 05/12/2018
     * @version 1.0
     * @description Test of the method productStocksCheck with parameter  Plc_Wrappers.GestioneDisponibilitaRequestBody.
     */

    @isTest
    static void productStocksCheckWithRequestTest(){        
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat=[SELECT Plc_Alias__c,B2WExtCat__External_Catalog__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        Bit2Shop__Warehouse__c bit2ShopWarehouse = [SELECT Id, Plc_Alias__c,Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        
        bit2ShopWarehouse.Plc_Alias__c = '00541237896541230';
        update bit2ShopWarehouse;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3;
        insert bit2ShopProductStock;

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita1 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'To Install', '00541237896541230', '1234567980', '00541237896541230');

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita2 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Install', '00541237896541230', '1234567980', '00789654123654789');
        
        // Start test
        Test.startTest();
        
            Plc_ServiceWs.ServiceResponse serviceResponse = Plc_ProductStocksServices.productStocksCheck(gestionDisponibilita1);

                                          serviceResponse = Plc_ProductStocksServices.productStocksCheck(gestionDisponibilita2);
          
            Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita3 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                'To Install', '00541237896541230', '1234567980', '00541237896541231');

            Plc_ServiceWs.ServiceResponse serviceResponse2 = Plc_ProductStocksServices.productStocksCheck(gestionDisponibilita3);

            
        // Stop test
        Test.stopTest();
    }


    /**
     * @author Moussa FOFANA
     * @date Creation 21/03/2019
     * @version 1.0
     * @description Test of the method productStocksCheck with parameter  Plc_Wrappers.GestioneDisponibilitaRequestBody product Stock map 2 not empty and Available quantity more then 1.
     */

    @isTest
    static void productStocksCheckWithRequestAvailableQuantityTest(){        
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita1 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'To Install', '123456789', '1234567980', '123456789');


        // Start test
        Test.startTest();

            //Line 195
            Plc_ServiceWs.ServiceResponse serviceResponse = Plc_ProductStocksServices.productStocksCheck(gestionDisponibilita1);
            System.assertEquals('200',serviceResponse.outcomeCode);

            //Line 214
            List<Bit2Shop__Product_Stock__c> products = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c WHERE Plc_AvailableQty__c > 0 ];
            
            for(Bit2Shop__Product_Stock__c product: products) {
                product.Plc_WithdrawnQty__c = -10;
                product.Plc_UsableQty__c = -10;
            }
            update products;

            Plc_ServiceWs.ServiceResponse serviceResponse2 = Plc_ProductStocksServices.productStocksCheck(gestionDisponibilita1);
            System.assertEquals('202',serviceResponse2.outcomeCode);
          
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 20/12/2018
     * @version 1.0
     * @description Test of the method productStocksCheck with parameter  Plc_Wrappers.GestioneDisponibilitaRequestBody 
     * and Empty ProductStockMap.
     */
    @isTest
    static void productStocksCheckWithRequestAndEmptyProductStockMapTest(){        
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat=[SELECT Plc_Alias__c,Plc_ProductSku__c,B2WExtCat__External_Catalog__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        Bit2Shop__Warehouse__c bit2ShopWarehouse = [SELECT Plc_Alias__c,Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 0;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 0;
        insert bit2ShopProductStock;

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita1 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'To Install',b2wExtCatExtCat.Plc_ProductSku__c , '1234567980', bit2ShopWarehouse.Plc_Alias__c);
        
        System.debug('productStockMap2');
        Bit2Shop__Product_Stock__c bit2ShopPS = [SELECT Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c,Bit2Shop__Warehouse_Id__r.Plc_Alias__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        System.debug('productStockMap2 '+bit2ShopPS.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c+'/ 00541237896541230' );
        System.debug('productStockMap2 '+bit2ShopPS.Bit2Shop__Warehouse_Id__r.Plc_Alias__c+' /00789654123654789'  );
        Map<String, Bit2Shop__Product_Stock__c> productStockMap2 = Plc_WsUtils.retrieveProductStocksCompatible(gestionDisponibilita1.resourceAlias,gestionDisponibilita1.warehouseAlias);
        Plc_Wrappers.VerificaDisponibilitaResponseData responseData = new Plc_Wrappers.VerificaDisponibilitaResponseData();
        System.debug('productStockMap2 '+productStockMap2);
        System.debug('productStockMap2 '+productStockMap2.get('' + gestionDisponibilita1.warehouseAlias));
        //responseData.resourceAlias = productStockMap2.get('' + gestionDisponibilita1.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_Alias__c;
        System.debug('productStockMap2 ');
        

        // Start test
        Test.startTest();
        Plc_ServiceWs.ServiceResponse serviceResponse= Plc_ProductStocksServices.productStocksCheck(gestionDisponibilita1);
        // Stop test
        Test.stopTest();
      
    } 
    
    /**
     * @author Mame Diarra
     * @date Creation 04/02/2019
     * @version 1.0
     * @description Test of the method retrieveProductStocks.
     */
    @isTest
    static void retrieveProductStocksTest(){

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat=[SELECT Plc_Alias__c,B2WExtCat__External_Catalog__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        
        Bit2Shop__Warehouse__c bit2ShopWarehouse = [SELECT Plc_Alias__c,Bit2Shop__Dealer_Id__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 0;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 0;
        insert bit2ShopProductStock;

        List<String> resourceAliasSet= new List<String>();
        resourceAliasSet.add(''+b2wExtCatExtCat.Plc_Alias__c);
        Set<String> warehouseIdAliasSet= new Set<String>();
        warehouseIdAliasSet.add(''+bit2ShopWarehouse.Plc_Alias__c);

        // Start test
        Test.startTest();
        Map<String,Bit2Shop__Product_Stock__c> productStockMap= Plc_ProductStocksServices.retrieveProductStocks(resourceAliasSet,warehouseIdAliasSet);
        // Stop test
        Test.stopTest();
        }
}