/**
 * @author Abdoulaye & Moussa
 * @date Creation 05/12/2018
 * @Mydify 20/02/2019 by Mame Diarra
 * @version 1.0
 * @description Test of PLC Plc_ProductStocksServices Rest WebService.
 */
@isTest
public class Plc_ReservationsServicesTest {

    @TestSetup
    static void setup(){
         Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'172');
        bit2ShopDealer.Plc_Repairer__c=true;
        insert bit2ShopDealer;
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('WarehouseName', 'Repaired','Nexi','00789654123654789', bit2ShopDealer);
        bit2ShopWarehouse.Plc_UniqueKey__c='test';
        bit2ShopWarehouse.Plc_Alias__c = '00789654123654789';
        bit2ShopWarehouse.Plc_LogisticDivision__c='';
        insert bit2ShopWarehouse;
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        b2WExtCatExtCatalog.B2WExtCat__all__c = 'Catalogue';
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,
                                                                                                   '00541237896541230', 'Process');
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;

        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 100;
        insert bit2ShopProductStock;
        
        Plc_WorkOrderConfiguration__c workOrderConfiguration = new  Plc_WorkOrderConfiguration__c();
        workOrderConfiguration.Plc_IntegrationName__c='Installation';
        workOrderConfiguration.Plc_EligibleOperationTypes__c='ToInstall';
        workOrderConfiguration.Plc_NeedsCalculation__c=true;
        workOrderConfiguration.Plc_NeedsReservation__c=true;
        insert workOrderConfiguration;
        
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 05/12/2018
    * @version 1.0
    * @description Test createReservationMass with parameter  Plc_Wrappers.GestioneDisponibilitaRequest and sourceExtSystem not equals MON.
    */
    @isTest
    static void createReservationMassTest(){  
        Plc_WorkOrderConfiguration__c workOrderConfiguration = [SELECT Id,Plc_IntegrationName__c FROM Plc_WorkOrderConfiguration__c LIMIT 1];
        workOrderConfiguration.Plc_IntegrationName__c='Installation';
        update workOrderConfiguration;
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita1 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                'Installation', '00541237896541230', '1234567980', '00789654123654789');

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita2 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                'Installation Test', '00541237896541230', '1234567980', '00789654123654789');

        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita1);
        request.add(gestionDisponibilita2);
    
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;

        // Start test
        Test.startTest();
        Plc_ServiceWs.ServiceResponse serviceResponse1= Plc_ReservationsServices.createReservationMass(gestioneDisponibilitaRequest,'MONETICA');
        
        Plc_ReservationsServices.createReservationMass(gestioneDisponibilitaRequest,'MONETICA');
        Plc_ReservationsServices.createReservationMass(gestioneDisponibilitaRequest,'MONETA');
        
        // Stop test
        Test.stopTest();
      
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 22/01/2019
    * @version 1.0
    * @description Test createReservationMass with parameter  Plc_Wrappers.GestioneDisponibilitaRequest and sourceExtSystem
    * and validRequestTypes not containt requestType and negative plc_AvailableQty.
    */
    @isTest
    static void createReservationMassAndNotValidRequestTypesAndNegAvailableTest(){  
        Bit2Shop__Product_Stock__c productStock = [SELECT Id,Plc_UsableQty__c,Plc_WithdrawnQty__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        productStock.Plc_UsableQty__c=0;
        productStock.Plc_WithdrawnQty__c=0;
        update productStock;

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita1 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                'Installation', '00541237896541230', '1234567980', '00789654123654789');

        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita1);
    
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;

        // Start test
        Test.startTest();        
        Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_ReservationsServices.createReservationMass(gestioneDisponibilitaRequest,'MONETICA');
        // Stop test
        Test.stopTest();
      
    }
  
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 22/01/2019
    * @version 1.0
    * @description Test createReservationMass with parameter  Plc_Wrappers.GestioneDisponibilitaRequest and sourceExtSystem
    * and productStockMap not containt (resourceAlias + warehouseAlias) .
    */
    @isTest
    static void createReservationMassAndProductStockMapNotContaintAliasTest(){  
       Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita1 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                'Installation', '0054123789654123011', '1234567980', '0078965412365478911');
       Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita2 = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                'Installation', '0054123789654123011', '1234567980', '00789654123654789');

        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita1);
        request.add(gestionDisponibilita2);
    
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;

        // Start test
        Test.startTest();        
        Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_ReservationsServices.createReservationMass(gestioneDisponibilitaRequest,'MONETICA');
        // Stop test
        Test.stopTest();
      
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 22/01/2019
    * @version 1.0
    * @description Test of the method reservationsDelete
    */
    @isTest
    static void reservationsDeleteTestOK(){
        Bit2Shop__Product_Stock__c bit2ShopProductStock= [SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );
        insert reservation;
        
        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c LIMIT 1];
        Plc_Wrappers.AnnullaImpegnoRequestBody requestBody= new Plc_Wrappers.AnnullaImpegnoRequestBody();
        requestBody.reservationId=reservationTemp.Id;
        // Start test
        Test.startTest();        
        Plc_ServiceWs.ServiceResponse serviceResponse= Plc_ReservationsServices.reservationsDelete(requestBody,'MONETICA');
        //for plc_status equals not reserved
        reservationTemp.Plc_Status__c='NotReserved';
        update reservationTemp;
        Plc_ServiceWs.ServiceResponse serviceResponse3= Plc_ReservationsServices.reservationsDelete(requestBody,'MONETICA');
        //for not reservation 
        requestBody.reservationId='test';
        Plc_ServiceWs.ServiceResponse serviceResponse4= Plc_ReservationsServices.reservationsDelete(requestBody,'MONETICA');
        //for sourceException different monetica
        Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_ReservationsServices.reservationsDelete(requestBody,'TEST');
        // Stop test
        Test.stopTest();
    }
       
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 31/01/2019
    * @version 1.0
    * @description Test of the method retrieveReservation 
    */
    @isTest
    static void retrieveReservationTest(){
        Bit2Shop__Product_Stock__c bit2ShopProductStock= [SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );
        insert reservation;
        Set<String> reservationIdSet = new Set<String>();
        reservationIdSet.add(''+reservation.Id);
        // Start test
        Test.startTest();        
         Map<Id,Plc_Reservation__c> serviceResponse= Plc_ReservationsServices.retrieveReservation(reservationIdSet);
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Mame Diarra
    * @date Creation 20/02/2019
    * @version 1.0
    * @description Test exception of the method reservationsDelete
    */
    @isTest
    static void reservationsDeleteTestKO(){
        Bit2Shop__Product_Stock__c bit2ShopProductStock= [SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );
        //insert reservation;
        
        Plc_Wrappers.AnnullaImpegnoRequestBody requestBody= new Plc_Wrappers.AnnullaImpegnoRequestBody();
        
        // Start test
        Test.startTest();        
        Plc_ServiceWs.ServiceResponse serviceResponse= Plc_ReservationsServices.reservationsDelete(requestBody,'MONETICA');
        // Stop test
        Test.stopTest();
    }
 
}