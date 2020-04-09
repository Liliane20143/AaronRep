/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @Modify 14/02/2019 by Mame Diarra
 * @version 1.0
 * @description Test of PLC WsictWs Rest WebService.
 */
@isTest
public class Plc_WsictWsTest {
    
      @TestSetup
      static void setup(){
        Plc_TestFactory.initProcessClickPackage();

        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account, '12345');
        bit2ShopDealer.Plc_Repairer__c = true;
        insert bit2ShopDealer;

        Contact contact = new Contact(FirstName = 'laye', LastName = 'DIOP');
        insert contact;
            
        WorkOrder workOrder = Plc_TestFactory.createWorkOrder('state', account, contact, 'abi',
                                                              'bankDescription', 'legacyAccountId', 'legacyAccount',
                                                              'siaCode', 'legacyServicePointId', 'servicePoint',
                                                              'cti', 'customerCare', 'fCode');
        workOrder.Plc_Alias__c = '123456789';
        workOrder.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        insert workOrder;
          
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('w1', 'Repaired', 'Nexi', '0123654789560', bit2ShopDealer);
        insert bit2ShopWarehouse;  
          
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('123456789');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, 'Test', 'Process');
        b2wExtCatExtCat.Plc_Alias__c = '123456789';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock.Plc_UsableQty__c = 5;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock;
          
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;

        WorkOrderLineItem workOrderLineItem = Plc_TestFactory.createWorkOrderLineItem('123456789', b2wExtCatExtCat, plcTermId, 'logistic', 'ToInstall', 
                                                                                      'ToExecute', 'note', '1235698', 'bundle');
        workOrderLineItem.WorkOrderId = workOrder.Id;

        insert workOrderLineItem;  
            
        Plc_WorkOrderConfiguration__c workOrderConfiguration = new Plc_WorkOrderConfiguration__c();
        // workOrderConfiguration.Name='';
        workOrderConfiguration.Plc_IntegrationName__c='integration';
        workOrderConfiguration.Plc_EligibleOperationTypes__c='ToInstall';
        workOrderConfiguration.Plc_NeedsCalculation__c=true;
        workOrderConfiguration.Plc_NeedsReservation__c=true;
        insert workOrderConfiguration;
        
        Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );
        insert reservation;
        }
    
     /**
     * @author Mame Diarra
     * @date Creation 17/12/2018
     * @version 1.0
     * @description Test of the method doPost when isInMaintenance
     */
     @isTest
     static void isInMaintenanceTest(){
        Plc_SystemSettings__c settings = new Plc_SystemSettings__c();
        settings.Plc_DaysForCalculatingConsumption__c=1;
        settings.Plc_PurchaseWarrantyMonthsDelay__c=1;
        settings.Plc_WsWsictInMaintenance__c=true;
        insert settings;
        
        String uri = 'work-orders//';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = new Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro();
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='123456789';
        gestOrdReqBodyRigOrdLavoro.cause=null;
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

        Test.startTest();
        Plc_ServiceWs.WsResponse respone = Plc_WsictWs.doPost();
        Test.stopTest();
     }

    /******************************************************BEGIN WorkOrders********************************************/
    
     /**
     * @author Abdoulaye & Moussa
     * @date Creation 17/12/2018
     * @Modify 07/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method doPost when work-orders and actionName and referenceObject are blank
     */
     @isTest
     static void doPostWorkOrdersAndBlankActionNameAndRefObjTest(){
		 
        Plc_ServiceWs.WsSingleResponse singleResponse = new Plc_ServiceWs.WsSingleResponse();
        Plc_Log__c plcRestLog = new Plc_Log__c(Plc_RequestHeader__c = '{"retry":"true", "httpMethod":"POST","messageid":"idmes"}',
                                                      Plc_ResponseBody__c = JSON.serialize(singleResponse),
                                                      Plc_Timestamp__c = '1');
        insert plcRestLog;
        String uri = 'work-orders//';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
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
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_RETRY, 'true');
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_MESSAGEID, 'idmes');
        RestContext.request = restRequest;
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone = Plc_WsictWs.doPost();
        Test.stopTest();
    }
    
     /**
     * @author Mame Diarra
     * @date Creation 08/03/2019
     * @version 1.0
     * @description Test of the method doPost
     *  and not instance of Plc_Log__c object
     */
     @isTest
     static void doPostAndNotPlcLogTest(){
		 
        String uri = 'work-orders//';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM  Plc_Reservation__c LIMIT 1];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        Plc_TermId__c plcTermId=[SELECT Id FROM Plc_TermId__c LIMIT 1];
        gestOrdReqBodyDetRiga.termId=''+plcTermId.Id;
        gestOrdReqBodyDetRiga.generationDate='01/10/12019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='Installation';
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
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_RETRY, 'true');
        restRequest.addHeader(''+Plc_MoneticaWs.REQUEST_HEADER_MESSAGEID, 'idmes');
        RestContext.request = restRequest;
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone = Plc_WsictWs.doPost();
        Test.stopTest();
    }
    
     /**
     * @author Mame Diarra
     * @date Creation 07/03/2019
     * @version 1.0
     * @description Test of the method doPost when work-orders and actionName and referenceObject are blank and valid field
     */
     @isTest
     static void doPostWorkOrdersAndBlankActionNameAndRefObjAndValidFieldTest(){

        String uri = 'work-orders//';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM  Plc_Reservation__c LIMIT 1];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        Plc_TermId__c plcTermId=[SELECT Id FROM Plc_TermId__c LIMIT 1];
        gestOrdReqBodyDetRiga.termId=''+plcTermId.Id;
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
        gestOrdReqBodyDetRiga.resourceAlias='resourceAlias';
        gestOrdReqBodyDetRiga.notes='notes';
        gestOrdReqBodyDetRiga.operationType='Installation';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = new Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro();
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='123456789';
        gestOrdReqBodyRigOrdLavoro.cause=gestOrdReqBodCause;
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemDetail=gestOrdReqBodyDetRiga;
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro2 = new Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro();
        gestOrdReqBodyRigOrdLavoro2.workOrderLineItemLegacyId='123456789';
        gestOrdReqBodyRigOrdLavoro2.cause=gestOrdReqBodCause;
         
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro); 
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro2); 
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone = Plc_WsictWs.doPost();
        Test.stopTest();
    }
    
     /**
     * @author Mame Diarra
     * @date Creation 11/03/2019
     * @version 1.0
     * @description Test of the method doPost when work-orders and actionName and referenceObject are blank and not valid field
     */
     @isTest
     static void doPostWorkOrdersAndBlankActionNameAndRefObjAndNotValidFieldTest(){
	
        Plc_WorkOrderConfiguration__c workOrderConfiguration = [SELECT Id,Plc_IntegrationName__c FROM Plc_WorkOrderConfiguration__c];
        workOrderConfiguration.Plc_IntegrationName__c='Installation';
        update workOrderConfiguration;
        Bit2Shop__Dealer__c b2SDealer= [SELECT Id,Plc_Repairer__c FROM Bit2Shop__Dealer__c LIMIT 1];
        b2SDealer.Plc_Repairer__c=FALSE;
        update b2SDealer;
        Bit2Shop__Warehouse__c b2sWarehouse= [SELECT Id,Plc_Tipology__c FROM Bit2Shop__Warehouse__c LIMIT 1];
        b2sWarehouse.Plc_Tipology__c='Irrecoverable';
        update b2sWarehouse;
         
        String uri = 'work-orders//';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
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
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
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
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone = Plc_WsictWs.doPost();
        Test.stopTest();
    }
    
     /**
     * @author Abdoulaye & Moussa
     * @date Creation 28/01/2019
     * @version 1.0
     * @description Test of the method doPost when work-orders and blank action Name 
     * and error message not null
     */
     @isTest
     static void doPostWhenWorkOrdersAndBlankActionNameTest(){
        
        String uri = 'work-orders/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',
                                                                                'accountLegacyId',  'address',  'bankDescription','businessName',  'status', System.today()+ '',
                                                                                System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839',
                                                                                '4792971','shopLegacyId','signboard','posta','locality','prefix','778197878','ghwd@wsq','0033',
                                                                                '14:00','referent', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
         
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
               
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
        
    }
    
     /**
     * @author Abdoulaye & Moussa
     * @date Creation 17/12/2018
     * @version 1.0
     * @description Test of the method doPost when Term-Ids and blank action Name
     * and null error message
     */
     @isTest
     static void doPostWhenWorkOrdersAndBlankActionNameAndNullErrorMessageTest(){
         
        String uri = 'work-orders/test/';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
		   
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','integration','abi',
                                                                                'accountLegacyId',  'address',  'bankDescription','businessName',  'status', System.today()+ '',
                                                                                System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839',
                                                                                '4792971','shopLegacyId','signboard','posta','locality','prefix','778197878','ghwd@wsq','0033',
                                                                                '14:00','referent', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('ToInstall', '1234567980', 
                                                                                                                    'status', 'serialNumber', 'reservationId', 
                                                                                                                    'bundleId', 'termId', System.today().format(), 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
               
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
        
    }
  
     /**
     * @author Abdoulaye & Moussa & Mame Diarra
     * @date Creation 10/12/2018
     * @version 1.0
     * @description Test of the method doPost when WorkOrders and actionName equals multiplecreate.
     */
     @isTest
     static void doPostWhenWorkOrdersAndMultiplecreateTest(){
        String uri = 'work-orders/test/multiplecreate';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
         
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();

        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
    
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }

     /**
     * @author Abdoulaye & Moussa
     * @date Creation 17/12/2018
     * @version 1.0
     * @description Test of the method doPost when WorkOrders and action Name is multipleUpdate
     */
     @isTest
     static void doPostWhenWorkOrdersAndMultipleUpdateTest(){

        String uri = 'work-orders/test/multipleUpdate';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','integration','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','postalCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
        WorkOrder workOrderLegacy =[SELECT Id FROM WorkOrder LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='123456789';
        Plc_Wrappers.GestioneOrdineRequest gestOrdReq = new Plc_Wrappers.GestioneOrdineRequest();
        gestOrdReq.workOrder.add(gestOrdReqBody);
        
        Blob requestBody = Blob.valueOf(JSON.serialize(gestOrdReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }
          
     /**
     * @author Abdoulaye & Moussa
     * @date Creation 23/01/2019
     * @version 1.0
     * @description Test of the method doPost when WorkOrders and multipleFulfillment
     */
     @isTest
     static void doPostWhenWorkOrdersAndMultipleFulfillmentTest(){
        Plc_WorkOrderConfiguration__c workOrderConfiguration = [SELECT Id,Plc_IntegrationName__c FROM Plc_WorkOrderConfiguration__c];
        workOrderConfiguration.Plc_IntegrationName__c='Installation';
        update workOrderConfiguration;
        String uri = 'work-orders/test/multipleFulfillment';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');

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
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }
    
     /**
     * @author Abdoulaye & Moussa
     * @date Creation 24/01/2019
     * @version 1.0
     * @description Test of the method doPost when WorkOrders and fulfillment
     */
     @isTest
     static void doPostWhenWorkOrdersAndFulfillmentTest(){
        
        Plc_WorkOrderConfiguration__c workOrderConfiguration = [SELECT Id,Plc_IntegrationName__c FROM Plc_WorkOrderConfiguration__c];
        workOrderConfiguration.Plc_IntegrationName__c='Installation';
        update workOrderConfiguration;
        String uri = 'work-orders/test/fulfillment';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');

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
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }
     
     /**
     * @author Abdoulaye & Moussa
     * @date Creation 25/01/2019
     * @version 1.0
     * @description Test of the method doPost when WorkOrders and fulfillment and error message equals null
     */
     @isTest
     static void doPostWhenWorkOrdersAndFulfillmentAndNullErrorMesTest(){

        Plc_WorkOrderConfiguration__c workOrderConfiguration = [SELECT Id,Plc_IntegrationName__c FROM Plc_WorkOrderConfiguration__c];
        workOrderConfiguration.Plc_IntegrationName__c='Installation';
        update workOrderConfiguration;
        String uri = 'work-orders/test/fulfillment';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
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
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
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
        
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }
     
    
    /****************************************************End WorkOrders **************************************************/
    
    /****************************************************begin term-ids **************************************************/
   
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 17/12/2018
     * @Modify 08/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method doPost when Term-Ids and action Name contains check
     */
    @isTest
    static void doPostWhenTerlIdsAndCheckTest(){

        String uri = 'term-ids/test/checktest';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.AggiornaTermIdRequestBody aggTerlReq= new Plc_Wrappers.AggiornaTermIdRequestBody();
        aggTerlReq.oldTermId='test';
        aggTerlReq.newTermId='test';
        
        Blob requestBody = Blob.valueOf(JSON.serialize(aggTerlReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
       
        Test.startTest();
        Plc_ServiceWs.WsResponse respone = Plc_WsictWs.doPost();
        Test.stopTest();
    }
     
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 17/12/2018
     * @Modify 08/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method doPost when Term-Ids and action Name is not blank and not containt only check
     */
    @isTest
    static void doPostWhenTermIdsAndActionNotContaintOnlyCheckTest(){
        
        String uri = 'term-ids/test/checktest';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.AggiornaTermIdRequestBody aggTerlReq= new Plc_Wrappers.AggiornaTermIdRequestBody();
        Blob requestBody = Blob.valueOf(JSON.serialize(aggTerlReq));
        
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }
   
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method doPost when Term-Ids and actionName contains check and  Slash
     */
    @isTest
    static void doPostWhenTerlIdsAndAndActionNameNotContainsSlashTest(){
        
        String uri = 'term-ids/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.InformazioniMatricolaRequest infoMatricolaReq= new Plc_Wrappers.InformazioniMatricolaRequest();
        Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody = new Plc_Wrappers.InformazioniMatricolaRequestBody();
        List<Plc_Wrappers.InformazioniMatricolaRequestBody> listInfMatReqBody= new List<Plc_Wrappers.InformazioniMatricolaRequestBody>();
        listInfMatReqBody.add(infMatReqBody);
        infoMatricolaReq.request=listInfMatReqBody;
        
        Blob requestBody = Blob.valueOf(JSON.serialize(infoMatricolaReq));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest; 

        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }  
  
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 17/12/2018
     * @version 1.0
     * @description Test of the method doPost when Term-Ids and action Name is not blank and not containt only check
     * and null error message
     */
    @isTest
    static void doPostWhenTermIdsAndActionNotContaintOnlyCheckAndNullErrorMessageTest(){
        
        String uri = 'term-ids/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.InformazioniMatricolaRequest infoMatricolaReq= new Plc_Wrappers.InformazioniMatricolaRequest();
        Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody = new Plc_Wrappers.InformazioniMatricolaRequestBody();
        Plc_TermId__c plcTermId= [SELECT Id FROM Plc_TermId__c LIMIT 1];
        infMatReqBody.termId=''+plcTermId.Id;
        List<Plc_Wrappers.InformazioniMatricolaRequestBody> listInfMatReqBody= new List<Plc_Wrappers.InformazioniMatricolaRequestBody>();
        listInfMatReqBody.add(infMatReqBody);
        infoMatricolaReq.request=listInfMatReqBody;
        
        Blob requestBody = Blob.valueOf(JSON.serialize(infMatReqBody));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        Test.stopTest();
    }
 
    /**************************************************** end term-ids **************************************************/

    
    /**************************************************** start work-order-line-items **************************************************/
     
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 24/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and multipleUnlock
    */
    @isTest
    static void doPostAndWorkOrderLineItemsTest(){
        
        String uri = 'work-order-line-items/test/multipleUnlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
   
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 24/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and multipleUnlock
    * and null errormessage
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndNullErrorMessageTest(){
        
        String uri = 'work-order-line-items/test/multipleUnlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation = [SELECT Id FROM Plc_Reservation__c LIMIT 1];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
      
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 24/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and actionname containt and equals check
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndCheckTest(){
        
        String uri = 'work-order-line-items/test/check';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro verMatPerEvasReqBodyOrdDil= new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();
        verMatPerEvasReqBodyOrdDil.workOrderLegacyId='1234567890';
        Blob requestBody = Blob.valueOf(JSON.serialize(verMatPerEvasReqBodyOrdDil));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 25/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and unlock and 
    * Null error message
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndUnlockAndNullErrorMessageTest(){
        
        String uri = 'work-order-line-items/test/unlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM Plc_Reservation__c];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 24/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and unlock
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndUnlockTest(){
        
        String uri = 'work-order-line-items/test/unlock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.termId='1685';
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
   
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 24/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and multipleLock
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndMultipleLockTest(){
        
        String uri = 'work-order-line-items/test/multipleLock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 28/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and multipleLock
    * and null error message
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndMultipleLockAndNullErrorMessageTest(){
        
        String uri = 'work-order-line-items/test/multipleLock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        Plc_Reservation__c reservation=[SELECT Id FROM Plc_Reservation__c];
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 24/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and lock
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndLockTest(){
        
        String uri = 'work-order-line-items/test/lock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');


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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 25/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and lock
    * and null error message
    */
    @isTest
    static void doPostAndWorkOrderLineItemsAndLockAndNullErrorMessageTest(){
        
        String uri = 'work-order-line-items/test/lock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Reservation__c reservation=[SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }    
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 25/01/2019
    * @version 1.0
    * @description Test of the method doPost when work-order-line-items and lock
    * and null error message
    */
    ///@isTest
    static void doPostAndWorkOrderLineItemsAndLockAndOutcomeCodeEquals200Test(){
        
        String uri = 'work-order-line-items/test/lock';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
        Plc_Reservation__c reservation=[SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new  Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();
        gestOrdReqBodyDetRiga.status='1234567890';
        gestOrdReqBodyDetRiga.parent='parent';
        gestOrdReqBodyDetRiga.serialNumber='122';
        gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
        gestOrdReqBodyDetRiga.bundleId='713';
        gestOrdReqBodyDetRiga.termId='1685';
        gestOrdReqBodyDetRiga.generationDate='01/10/2019';
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
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }    
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 24/01/2019
    * @version 1.0
    * @description Test of the method doPost
    */
    ///@isTest
    static void doPostTest(){
        
        String uri = '';
        RestRequest restRequest = Plc_WsTestFactory.createRestRequest(uri, Plc_WsictWs.URL_MAPPING, 'POST');
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('1234567980');
        gestOrdReqBodyDetRiga.operationType='ToInstall';
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
             
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Blob requestBody = Blob.valueOf(JSON.serialize('test'));
        restRequest.requestBody = requestBody;
        RestContext.request = restRequest;
        Test.startTest();
        Plc_ServiceWs.WsResponse respone1 = Plc_WsictWs.doPost();
        
        Test.stopTest();
    }
    
    /**************************************************** end work-order-line-items **************************************************/
}