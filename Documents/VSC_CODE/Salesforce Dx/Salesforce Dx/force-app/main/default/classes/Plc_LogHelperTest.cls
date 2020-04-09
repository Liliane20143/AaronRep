/**
 * @author Emanuele Campese
 * @date Creation 22/02/2019
 * @version 1.0
 * @description Test class for Plc_LogHelper.
 */
@isTest
private class Plc_LogHelperTest {

    /**
    * @author Tanzi Gabriele Giovanni
    * @date Creation 03/12/2018
    * @version 1.0
    * @description Test setup.
    */
    @testSetup
    static void setup() {

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'New');
        bit2ShopDealer.Plc_Repairer__c=true;
        insert bit2ShopDealer;
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('UniqueKey1','Repaired','','000001NEXI',bit2ShopDealer);
        insert bit2ShopWarehouse;
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog,'sku','type');
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        insert bit2ShopProductStock;
    }

    /**
    * @author Tanzi Gabriele Giovanni
    * @date Creation 03/12/2018
    * @version 1.0
    * @description Test method for logRestCall.
    */
    @isTest
    static void logRestCallTest() {

        String uri = 'product-stocks/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                    'Installation', 'D3200DEM0CV4', '10998877', 'CSC001');
        Blob requestBody = Blob.valueOf(JSON.serialize(gestionDisponibilita));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();
        Plc_LogHelper.logRestCall(restRequest, response, 'processing', 10, 0,'', '');

        // Stop test
        Test.stopTest();

    }

    /**
    * @author Tanzi Gabriele Giovanni
    * @date Creation 03/12/2018
    * @version 1.0
    * @description Test method for logRestCall.
    */
    @isTest
    static void logCallTest() {
        // Start test
        Test.startTest();
        Plc_LogHelper.LogStructure newLogStructure = new Plc_LogHelper.LogStructure();
        newLogStructure.processingTime='processingTime';
        newLogStructure.executionTimeStep1=10;
        newLogStructure.executionTimeStep2=12;
        newLogStructure.httpMethod='POST';
        newLogStructure.requestUri='Test';
        newLogStructure.requestHeader=null;
        newLogStructure.requestBody='Test';
        newLogStructure.responseBody='Test';
        newLogStructure.responseStatus='S';
        newLogStructure.responseMessage='Test';
        newLogStructure.responseStackTrace='Test';
        newLogStructure.recordUrl='Test';
        newLogStructure.recordId = '';
        Plc_LogHelper.logCall(newLogStructure);
        // Stop test
        Test.stopTest();
    }
   
   
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 4/12/2018
    * @version 1.0
    * @description Test of the method logRestCall with six parameters .
    */
    @isTest static void logRestCallWithSixParametersTest() {

        String uri = 'product-stocks/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_MoneticaWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneDisponibilitaRequestBody gestionDisponibilita = Plc_WsTestFactory.createGestioneDisponibilitaRequestBody(
                    'Installation', 'D3200DEM0CV4', '10998877', 'CSC001', '00789654123654789', '00789654123654789');
        Blob requestBody = Blob.valueOf(JSON.serialize(gestionDisponibilita));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;

        // Start test
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Plc_MockServices');
        mock.setStatusCode(200); 
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);


        HttpRequest req = new HttpRequest();
        req.setEndpoint(Plc_WsTestFactory.siteUrl+Plc_MoneticaWs.URL_MAPPING+uri);
        req.setMethod('POST');
        System.debug('Mya' +req.toString());

        Http http = new Http();
        HttpResponse res = http.send(req);

        Map<string, string> headers= new Map<string, string>();
        headers.put('Plc_RequestHeader__c', 'RequestHeader');

        Plc_ServiceWs.WsResponse response = Plc_MoneticaWs.doPost();
        Plc_LogHelper.logRestCall(req, response, 'processingTime', 10, headers, res,'', '');
        //Plc_LogHelper.logRestCall(req, response, 'pt',10,10,'');
        // Stop test
        Test.stopTest();

    }

}