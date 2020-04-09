/**
 * @author Abdoulaye & Moussa
 * @date Creation 23/11/2018
 * @Modify 13/02/2019 by Mame Diarra
 * @version 1.0
 * @description Test of PLC Monetica Rest WebService.
 */
@isTest
public class Plc_MoneticaWsTest {
    @testSetup
    
    static void setup(){    
        Plc_SystemSettings__c systemSettings = new Plc_SystemSettings__c();
        systemSettings.Plc_WsMoneticaKoMockResponseEnabled__c = true;
        systemSettings.Plc_DaysForCalculatingConsumption__c = 30;
        systemSettings.Plc_PurchaseWarrantyMonthsDelay__c = 30;
        insert systemSettings;
        
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('Parent Dealer',account,'Alias');
        insert parentDealer;

        Bit2Shop__Dealer__c dealerChild = Plc_TestFactory.createDealerChild('dealer',account,'45262',parentDealer);
        dealerChild.Plc_Alias__c='0167766272';
        dealerChild.Plc_Repairer__c =TRUE;
        insert dealerChild;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('Warehouse Name','Installed','Nexi','000001NEXI', dealerChild);        
        bit2ShopWarehouse.Plc_Alias__c ='00789654123654789';
        bit2ShopWarehouse.Plc_Tipology__c = 'Repaired';                     
        insert bit2ShopWarehouse;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
       
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'','Process');
        b2wExtCatExtCat.Plc_Alias__c='00541237896541230';
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;
        
         Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );
        insert reservation;
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;

        Plc_WorkOrderConfiguration__c WorkOrderConf= new Plc_WorkOrderConfiguration__c(Plc_IntegrationName__c='Installation',
                                                                                       Plc_EligibleOperationTypes__c='ToInstall',
                                                                                       Plc_NeedsCalculation__c=true,
                                                                                       Plc_NeedsReservation__c=true
                                                                                        );
        insert WorkOrderConf;
        Contact contact = new Contact(FirstName='Mame', LastName='Kane');
        insert contact;

        WorkOrder workOrder = Plc_TestFactory.createWorkOrder(  'state', account, contact, 'abi',
                                                                'bankDescription', 'legacyAccountId', 'legacyAccount',
                                                                'siaCode', 'legacyServicePointId', 'servicePoint', 'cti',
                                                                 'customerCare', 'fCode');
        WorkOrder.Status = 'Assigned';
        workOrder.Plc_Alias__c = '123456789';
        workOrder.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        insert workOrder;

        WorkOrderLineItem workOrderLineItem = Plc_TestFactory.createWorkOrderLineItem('123456789', b2wExtCatExtCat, plcTermId, 'logistic', 'ToInstall', 
                                        'ToExecute', 'note', '1235698', 'bundle');
        workOrderLineItem.WorkOrderId = workOrder.Id;
        WorkOrderLineItem.Status = 'Executed';
        WorkOrderLineItem.Plc_ReferenceExternalCatalogItem__c = '123456789';
        WorkOrderLineItem.Plc_Reservation__c = reservation.id;
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 13/02/2019
     * @Modify 08/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method doPost when header contains retry equals true 
     * and containt instance of Plc_Log__c.
     */
    @isTest
    static void doPostAnRetryAndRestLogTest(){ 
        
        Plc_ServiceWs.WsSingleResponse singleResponse= new Plc_ServiceWs.WsSingleResponse();
        Plc_Log__c plcRestLog= new Plc_Log__c(Plc_RequestHeader__c='{"retry":"true", "httpMethod":"POST","messageid":"idmes"}',
                                                      Plc_ResponseBody__c=JSON.serialize(singleResponse),
                                                      Plc_Timestamp__c='1');
        insert plcRestLog;
        String uri = 'product-stocks/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');       
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Installation', '00987456321078965', '1234567980', '00541237896541230', '00789654123654789', 'Nexi');
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
        restRequest.requestBody = requestBody;
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_RETRY, 'true');
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_MESSAGEID, 'idmes');
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Mame Diarra
     * @date Creation 13/02/2019
     * @Modify 08/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method doPost when header contains retry equals true.
     */
    @isTest
    static void doPostAnRetryTest(){ 
        String uri = 'product-stocks/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
         
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Installation', '00987456321078965', '1234567980', '00541237896541230', '00789654123654789', 'Nexi');
        
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
        restRequest.requestBody = requestBody;
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_RETRY, 'true');
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_MESSAGEID, 'idmes');
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /*************************************************BEGIN product-stocks*************************************************************/

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 3/12/2018
     * @Modify 05/03.2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method doPost when product-stocks and isReadMaintanace equals true.
     */
    //@isTest
    static void doPostWhenProductStocksAndIsReadMaintanace(){        

        String uri = 'product-stocks/check/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        Blob requestBody = Blob.valueOf(JSON.serialize('test'));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        Plc_SystemSettings__c settings = new Plc_SystemSettings__c();
        settings.Plc_DaysForCalculatingConsumption__c=1;
        settings.Plc_PurchaseWarrantyMonthsDelay__c=1;
        settings.Plc_WsMoneticaInMaintenance__c=true;
        insert settings;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 26/11/2018
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'product-stocks' 
     * and actionName only contains 'check' and gestioneDisponibilitaRequest = null.
     */
    @isTest
    static void doPostWhenProductStocksActionNameNotContainsSlashAndErrorMessageNullTestOK(){

        String uri = 'product-stocks/check/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');       
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Installation', '00987456321078965', '1234567980', '00541237896541230', '00789654123654789', 'Nexi');
        
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;    
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response=Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 26/11/2018
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'product-stocks' 
     * and actionName only contains 'check' and the data in requestBody not valid.
     */
    @isTest
    static void doPostWhenProductStocksInvalidRequestBodyAndActionNameNotContainsSlashTestOK(){

        String uri = 'product-stocks/check/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');       
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Installation', '00541237896541230', '1234567980', '00789654123654789');
        
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestionDisponibilita));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;  
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response=Plc_MoneticaWs.doPost();
        //Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 26/11/2018
     * @Modify 05/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'product-stocks' and actionName not containt only check .
     */
    @isTest
    static void doPostWhenProductStocksAndActionNameContaintCheckTestOK(){        

        String uri = 'product-stocks/test/checktest';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Installation', '00541237896541230', '1234567980', '00789654123654789');
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita2 = new Plc_Wrappers.GestioneDisponibilitaRequestBody();
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        request.add(gestionDisponibilita2);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        // Start test
        Test.startTest();
          Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();
          
          // if null request
          gestioneDisponibilitaRequest.request = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
          Blob requestBody2 = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
          restRequest.requestBody = requestBody2;
          RestContext.request = restRequest;
          Plc_ServiceWs.WsResponse response2 = Plc_MoneticaWs.doPost();
            
        // Stop test
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'product-stocks' and actionName not containt only check 
     * and not null error message.
     */
    @isTest
    static void doPostWhenProductStocksAndActionNameContaintCheckAndErrorMessageTestOK(){        

        String uri = 'product-stocks/checktest';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita =new Plc_Wrappers.GestioneDisponibilitaRequestBody();
       
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
          Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }
   
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/11/2018
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'product-stocks' and actionName not containt check.
     */
    ///@isTest
    static void doPostWhenProductStocksRequestAndActionNameNotContaintCheckTestOK(){        

        String uri = 'product-stocks/check/test';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Disinstallazione', '009874563210789651234', '1234567980', '0123654789560');
        
        Blob requestBody = Blob.valueOf(JSON.serialize(gestionDisponibilita));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
       //start debug
       System.debug('MYA '+Plc_WsUtils.ERROR_MESSAGE_MAP.get('[ERR:CL-0090118] ')); 
       //end debug 
        
        // Start test
        Test.startTest();
          Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }

    /******************************************************* END Product-stocks *******************************************************/

    /******************************************************* Begin Reservations *******************************************************/

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 3/12/2018
    * @Modify 05/03/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method doPost when Reservations and isWriteInMaintenance equals true.
    */
    //@isTest
    static void doPostWhenReservationsAndIsWriteInMaintenance(){        

        String uri = 'reservations';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        Blob requestBody = Blob.valueOf(JSON.serialize('test'));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        Plc_SystemSettings__c settings = new Plc_SystemSettings__c();
        settings.Plc_WsMoneticaInMaintenance__c=true;
        settings.Plc_PurchaseWarrantyMonthsDelay__c=1;
        settings.Plc_DaysForCalculatingConsumption__c=1;
        insert settings;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 27/11/2018
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'reservations',
     * actionName is blank and invalid requestBody
     * @comments review this method after exchange with the gars
     */
    @isTest
    static void doPostWhenReservationsAndIsBlankActionNameAndInvalidRequestBodyTestOK(){        

        String uri = 'reservations/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');               

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Installation', '00987456321078965', '1234567980', '00541237896541230', '00789654123654789', 'Nexi');

        Blob requestBody = Blob.valueOf(JSON.serialize(gestionDisponibilita));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
          Plc_ServiceWs.WsResponse response1 = Plc_MoneticaWs.doPost();

        // Stop test
        Test.stopTest();
    }
     
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 30/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'reservations',
     * actionName is blank and valid requestBody
     * @comments review this method after exchange with the gars
     */
    @isTest
    static void doPostWhenReservationsAndIsBlankActionNameAndvalidRequestBodyTestOK(){        

        String uri = 'reservations/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');               

        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = new Plc_Wrappers.GestioneDisponibilitaRequestBody(); 

        Blob requestBody = Blob.valueOf(JSON.serialize(gestionDisponibilita));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
          Plc_ServiceWs.WsResponse response1 = Plc_MoneticaWs.doPost();

        // Stop test
        Test.stopTest();
    }
     
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'reservations' and 
     * actionName equals multipleCreate.
     */
    @isTest
    static void doPostWhenReservationsAndMultipleCreateTest(){  

        String uri = 'reservations/test/multipleCreate';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');               
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = new Plc_Wrappers.GestioneDisponibilitaRequestBody();
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response1 = Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }
 
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'reservations' and 
     * actionName equals multipleCreate and error message equals null.
     */
    @isTest
    static void doPostWhenReservationsAndMultipleCreateAndNullErrorMessageTest(){        
        
        String uri = 'reservations/test/multipleCreate';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');               
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            'Installation', '00987456321078965', '1234567980', '00789654123654789');
        List<Plc_Wrappers.GestioneDisponibilitaRequestBody> request  = new List<Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        request.add(gestionDisponibilita);
        Plc_Wrappers.GestioneDisponibilitaRequest gestioneDisponibilitaRequest = new Plc_Wrappers.GestioneDisponibilitaRequest();
        gestioneDisponibilitaRequest.request = request;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestioneDisponibilitaRequest));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response1 = Plc_MoneticaWs.doPost();  
        // Stop test
        Test.stopTest();
    }
 
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'reservations' and 
     * action name containt only delete and null error message.
     */
    @isTest
    static void doPostWhenReservationsAndOnlyDeleteAndNullErrorMessageTestOK(){        

        String uri = 'reservations/test/delete';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');               

        Plc_Wrappers.AnnullaImpegnoRequestBody annullaImpegnoReqBody = new Plc_Wrappers.AnnullaImpegnoRequestBody();
        annullaImpegnoReqBody.termId='';
        annullaImpegnoReqBody.reservationId=''+([SELECT Id FROM Plc_Reservation__c LIMIT 1]).Id;
        Blob requestBody = Blob.valueOf(JSON.serialize(annullaImpegnoReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response1 = Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 30/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'reservations' and 
     * action name containt only delete.
     */
    @isTest
    static void doPostWhenReservationsAndOnlyDeleteAndTestOK(){        

        String uri = 'reservations/test/delete';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');               

        Plc_Wrappers.AnnullaImpegnoRequestBody annullaImpegnoReqBody = new Plc_Wrappers.AnnullaImpegnoRequestBody();
        annullaImpegnoReqBody.termId='188';
        annullaImpegnoReqBody.reservationId='411';
       
        Blob requestBody = Blob.valueOf(JSON.serialize(annullaImpegnoReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response1 = Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }
 
    /******************************************************* End Reservations *******************************************************/
    
    /******************************************************* Begin Work-Orders *******************************************************/
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 27/11/2018
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and
     * actionName contains multiple-create.
     */
    @isTest
    static void doPostWhenWorkOrdersAndMultipleCreateTestOK(){        

        String uri = 'work-orders/test/multiplecreate';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                  
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);

        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        System.debug('plc-42-gestOrdReqBodies ' + JSON.serialize(gestOrdReqBodies));
        System.debug('plc-42-gestOrdReq ' + JSON.serialize(gestOrdReq));

        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Mame Diarra
     * @date Creation 05/03/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and
     * actionName contains multiple-create and not null responseDataList of serviceResponse.
     */
    @isTest
    static void doPostWhenWorkOrdersAndMultipleCreateAndResponseDataListTestOK(){        

        String uri = 'work-orders/test/multiplecreate';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                  
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';

        Plc_Reservation__c reservation=[SELECT Id FROM  Plc_Reservation__c LIMIT 1];
        
        gestOrdReqBodyDetRiga.reservationId='';
        gestOrdReqBodyDetRiga.bundleId='713';

        Plc_TermId__c plcTermId=[SELECT Id FROM Plc_TermId__c LIMIT 1];
        
        gestOrdReqBodyDetRiga.termId=''+plcTermId.Id;
        gestOrdReqBodyDetRiga.generationDate='01/10/12019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='ToInstall';

        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);

        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        System.debug('plc-42-gestOrdReqBodies ' + JSON.serialize(gestOrdReqBodies));
        System.debug('plc-42-gestOrdReq ' + JSON.serialize(gestOrdReq));

        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Mame Diarra
     * @date Creation 13/02/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and blank actionName
     */
    @isTest
    static void doPostWhenWorkOrdersAndBlankActionNameTestOK(){        

        String uri = 'work-orders/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);

        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        System.debug('plc-42-gestOrdReqBodies ' + JSON.serialize(gestOrdReqBodies));
        System.debug('plc-42-gestOrdReq ' + JSON.serialize(gestOrdReq));

        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date Creation 13/02/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and blank actionName
     * and valid requestbody
     */
    @isTest
    static void doPostWhenWorkOrdersAndBlankActionNameAndValidRequestTestOK(){        

        String uri = 'work-orders/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM  Plc_Reservation__c LIMIT 1];
        gestOrdReqBodyDetRiga.reservationId='';
        gestOrdReqBodyDetRiga.bundleId='713';
        Plc_TermId__c plcTermId=[SELECT Id FROM Plc_TermId__c LIMIT 1];
        gestOrdReqBodyDetRiga.termId=''+plcTermId.Id;
        gestOrdReqBodyDetRiga.generationDate='01/03/2019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);

        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        System.debug('plc-42-gestOrdReqBodies ' + JSON.serialize(gestOrdReqBodies));
        System.debug('plc-42-gestOrdReq ' + JSON.serialize(gestOrdReq));

        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 27/11/2018
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and
     * actionName contains multiple-create.
     */
    @isTest
    static void doPostWhenWorkOrdersAndMultipleUpdateTestOK(){        

        String uri = 'work-orders/test/multipleUpdate';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);   
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 27/11/2018
     * @version 1.0
     * @description Test of the method doPost when methodName contains only 'work-orders' and actionName is blank
     */
    @isTest
    static void doPostWhenWorkOrdersTestOK(){        

        String uri = 'work-orders/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType', '1234567980', 
                                                                                                                    'status', 'serialNumber', 'reservationId', 
                                                                                                                    'bundleId', 'termId', System.today().format(),  'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody2 = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', null, gestOrdReqBodyRigOrdLavs);
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();

        requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody2));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        Plc_ServiceWs.WsResponse response2 = Plc_MoneticaWs.doPost();
        //System.assertNotEquals(response.result, response2.result);

        // Stop test
        Test.stopTest();
    }
 
    /**
     * @author Mame Diarra
     * @date Creation 06/03/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains only 'work-orders'
     * and actionName is blank and blank referenceObject.
     */
    @isTest
    static void doPostWhenWorkOrdersAndBlankActionNameAndBlankReferenceObjectTest(){        

        String uri = 'work-orders//';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Bit2Shop__Dealer__c b2SDealer= [SELECT Id,Plc_Repairer__c FROM Bit2Shop__Dealer__c LIMIT 1];
        b2SDealer.Plc_Repairer__c=FALSE;
        update b2SDealer;
        Bit2Shop__Warehouse__c b2sWarehouse= [SELECT Id,Plc_Tipology__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        b2sWarehouse.Plc_Tipology__c='Irrecoverable';
        //update b2sWarehouse;

        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');                                                                                  
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType', '1234567980', 
                                                                                                                    'status', 'serialNumber', 'reservationId', 
                                                                                                                    'bundleId', 'termId', System.today().format(),  'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }
 
     /**
     * @author Mame Diarra
     * @date Creation 06/03/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains only 'work-orders'
     * and actionName is blank and blank referenceObject and valid field .
     */
    @isTest
    static void doPostWhenWorkOrdersAndBlankActionNameAndBlankRefObjAndValidFieldTest(){        

        String uri = 'work-orders//';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
     
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();
        // Stop test
        Test.stopTest();
    }
 
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and
     * actionName contains multipleFulfillment.
     */
    @isTest
    static void doPostWhenWorkOrdersAndMultipleFulfillmentTestOK(){        

        String uri = 'work-orders/test/multipleFulfillment';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);   
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and
     * actionName contains fulfillment and null error message.
     */
    @isTest
    static void doPostWhenWorkOrdersAndFulfillmentAndNullErrorMessageTestOK(){        

        String uri = 'work-orders/test/fulfillment';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType', '1234567980', 
                                                                                                                    'status', 'serialNumber', 'reservationId', 
                                                                                                                    'bundleId', 'termId', System.today().format(),  'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 30/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and
     * actionName contains fulfillment.
     */
    @isTest
    static void doPostWhenWorkOrdersAndFulfillmentTestOK(){        

        String uri = 'work-orders/test/fulfillment';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
     
    /**
     * @author Mame Diarra
     * @date Creation 12/01/2019
     * @version 1.0
     * @description Test of the method doPost when methodName contains 'work-orders' and
     * blank actionName, not blank methodName.
     */
    @isTest
    static void doPostWhenWorkOrdersAndNotBlankMethodNameTestOK(){        

        String uri = 'work-orders/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    

    /******************************************************* End Work-Order *******************************************************/

    /******************************************************* Begin Work-Order line items ******************************************/

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 29/01/2019
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'work-order-line-items' and actionName equals check
    */
    @isTest
    static void doPostWhenWorkOrderLineItemsAndCheckTestOK(){        

        String uri = 'work-order-line-items/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBodyRigOrdLavoro));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
   
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 27/11/2018
    * @Modify 05/03/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'work-order-line-items'
    */
    ///@isTest
    static void doPostWhenWorkOrderLineItemsTestOK(){        

        String uri = 'work-order-line-items/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                  
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM  Plc_Reservation__c LIMIT 1];
        gestOrdReqBodyDetRiga.reservationId='';
        gestOrdReqBodyDetRiga.bundleId='713';
        Plc_TermId__c plcTermId=[SELECT Id FROM Plc_TermId__c LIMIT 1];
        gestOrdReqBodyDetRiga.termId=''+plcTermId.Id;
        gestOrdReqBodyDetRiga.generationDate='01/03/2019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='ToInstall'; 
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
       
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);

        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;

        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

   
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 29/01/2019
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'work-order-line-items' and actionName containt check
    */
    ///@isTest
    static void doPostWhenWorkOrderLineItemsContaintCheckTestOK(){        

        String uri = 'work-order-line-items/test/checktest';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBodyRigOrdLavoro));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 29/01/2019
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'work-order-line-items' and actionName equals multipleUnlock
    */
    @isTest
    static void doPostWhenWorkOrderLineItemsAndMultipleUnlockTestOK(){        

        String uri = 'work-order-line-items/test/multipleUnlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);   
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'work-order-line-items' and actionName equals multipleUnlock
    * and null error message
    */
    @isTest
    static void doPostWhenWorkOrderLineItemsAndMultipleUnlockAndNullErrorMessageTestOK(){        

        String uri = 'work-order-line-items/test/multipleUnlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation = [SELECT Id FROM Plc_Reservation__c LIMIT 1];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/12019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'work-order-line-items' and actionName equals unlock
    */
    @isTest
    static void doPostWhenWorkOrderLineItemsAndUnlockTestOK(){        

        String uri = 'work-order-line-items/test/unlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);   
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'work-order-line-items' and actionName equals unlock
    * and null error message
    */
    @isTest
    static void doPostWhenWorkOrderLineItemsAndUnlockAndNullErrorMessageTestOK(){        

        String uri = 'work-order-line-items/test/unlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
                                                                                                
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM Plc_Reservation__c];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/12019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = new Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro();
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='123456789';
        gestOrdReqBodyRigOrdLavoro.cause=gestOrdReqBodCause;
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemDetail=gestOrdReqBodyDetRiga;
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and multipleLock
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndMultipleLockTest(){
        
        String uri = 'work-order-line-items/test/multipleLock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and multipleLock and null error message
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndMultipleLockAndNullErrorMessageTest(){
        
        String uri = 'work-order-line-items/test/multipleLock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM Plc_Reservation__c];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/12019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro =Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        
        List<Plc_Wrappers.GestioneOrdineRequestBody> gestOrdReqBodies = new List<Plc_Wrappers.GestioneOrdineRequestBody>();
        gestOrdReqBodies.add(gestOrdReqBody);
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder = gestOrdReqBodies;
        
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
  
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and lock and null error message
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndLockAndNullErrorMessageTest(){
        
        String uri = 'work-order-line-items/test/lock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Reservation__c reservation=[SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/12019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and lock
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndLockTest(){
        
        String uri = 'work-order-line-items/test/lock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();   
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and action name not null
    */
    //@isTest
    static void doPostAndWorkOrderLineItemsAndActionNameNotNullTest(){
        
        String uri = 'work-order-line-items/test/test';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        //Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = new Plc_Wrappers.GestioneOrdineRequestBodyCausale();
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();   
    }

    /******************************************************* End Work-Order line items ******************************************************/

  /******************************************************* Start terms-ids ******************************************************/

   
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 28/11/2018
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'term-ids' and ActionName contains Only Check
    */
    @isTest
    static void doPostWhenTermIdsAndActionNameContainsOnlyCheckTestOK(){        

        String uri = 'term-ids/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody = Plc_WsTestFactory.createInformazioniMatricolaRequestBody('1234567980');

        Blob requestBody = Blob.valueOf(JSON.serialize(infMatReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Mame Diarra
    * @date Creation 06/02/2019
    * @version 1.0
    * @description Test of the method doPost when methodName contains 'term-ids' and ActionName contains Only Check 
    * and field is invalid
    */
    @isTest
    static void doPostWhenTermIdsAndActionNameContainsOnlyCheckAndValidTest(){        

        String uri = 'term-ids/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody = new Plc_Wrappers.InformazioniMatricolaRequestBody();

        Blob requestBody = Blob.valueOf(JSON.serialize(infMatReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @Modify 06/03/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method doPost when methodName only contains 'term-ids' 
    */
    @isTest
    static void doPostWhenTermIdsNotContainsCheckTestOK(){        

        String uri = 'term-ids/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        Plc_Wrappers.AggiornaTermIdRequestBody aggTerlReq= new Plc_Wrappers.AggiornaTermIdRequestBody();
        Blob requestBody = Blob.valueOf(JSON.serialize(aggTerlReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/01/2019
    * @Modify 06/03/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method doPost when methodName only contains 'term-ids' 
    * and null error message
    */
    @isTest
    static void doPostWhenTermIdsNotContainsCheckAndNullErrorMessageTestOK(){        

        String uri = 'term-ids/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        Plc_Wrappers.AggiornaTermIdRequestBody aggTerlReq= new Plc_Wrappers.AggiornaTermIdRequestBody();
        aggTerlReq.oldTermId='test';
        aggTerlReq.newTermId='test';
        Blob requestBody = Blob.valueOf(JSON.serialize(aggTerlReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
    
 
    /******************************************************* end terms-ids ******************************************************/
  
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 30/11/2018
    * @version 1.0
    * @description Test of the method doPost.
    */
    //@isTest
    static void doPostKO(){        

        String uri = '';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        RestContext.request = restRequest;
        /*Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
            '{Installation', '00987456321078965', '1234567980', '00541237896541230', '00789654123654789', 'Nexi');*/
        
        Blob requestBody = Blob.valueOf(JSON.serialize('test'));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();        
        // Stop test
        Test.stopTest();
    }
        
   }