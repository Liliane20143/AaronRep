/**
 * @author Abdoulaye & Moussa
 * @date Creation 17/01/2019
 * @version 1.0
 * @modification on 2019/02/25 By Moussa FOFANA
 * @description Test of PLC WorkOrderLineItemsServices.
 */
@isTest
public class Plc_WorkOrderLineItemsServicesTest {
    //
    @TestSetup
    static void setup(){
        
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        Account acc = Plc_TestFactory.createAccountSupplier('Test');
        insert acc;
        
        Bit2Shop__Dealer__c parentBit2ShopDealer = Plc_TestFactory.createDealer('dealer 1', acc,'New');
        parentBit2ShopDealer.Plc_Alias__c='1235667890';
        parentBit2ShopDealer.Plc_DealerManufacturer__c = true;
        insert parentBit2ShopDealer;
        
        Id b2ShopDealRecType = Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c');

        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'New');
        bit2ShopDealer.Plc_Manufacturer__c = true; 
        bit2ShopDealer.Bit2Shop__Parent_Dealer__c=''+parentBit2ShopDealer.Id;
        bit2ShopDealer.RecordTypeId = b2ShopDealRecType;
        bit2ShopDealer.Plc_Alias__c='123568';
        insert bit2ShopDealer;
        
		/*
        Bit2Shop__Dealer__c bit2ShopDealer2 = Plc_WsTestFactory.createBit2ShopDealer('dealer2', account);
        bit2ShopDealer2.Plc_Manufacturer__c = true; 
        bit2ShopDealer2.Bit2Shop__Parent_Dealer__c=''+parentBit2ShopDealer.Id;
        bit2ShopDealer2.RecordTypeId = b2ShopDealRecType;
        bit2ShopDealer2.Plc_Alias__c='12356800';
        insert bit2ShopDealer2;
        */
       
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('Nexi', 'New', '', '000001NEXI', bit2ShopDealer);
        bit2ShopWarehouse.Plc_CoverageIndex__c=1;
        bit2ShopWarehouse.Plc_UniqueKey__c='code';
        insert bit2ShopWarehouse;   
        
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item',b2WExtCatExtCatalog,'37377','type');
        insert b2wExtCatExtCat;

        Plc_WorkOrderConfiguration__c woConfiguration = new Plc_WorkOrderConfiguration__c();
        woConfiguration.Plc_EligibleOperationTypes__c = 'ToInstall';
        woConfiguration.Plc_IntegrationName__c = 'Installation';
        woConfiguration.Plc_NeedsCalculation__c  = true;
        woConfiguration.Plc_NeedsReservation__c = true;

        insert woConfiguration;

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        
        insert bit2ShopProductStock;        
       
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2= new Bit2Shop__Stock_Serials2__c();
        bit2ShopStockSerials2.Bit2Shop__Warehouse_Id__c=bit2ShopWarehouse.Id;
        //bit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c=bit2ShopProductStock.Id;
        bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c='123';
        bit2ShopStockSerials2.Plc_EncodedSerialNumberUnique__c='123';
        bit2ShopStockSerials2.Plc_ManufacturerSerialNumberUnique__c='123';
        bit2ShopStockSerials2.Plc_DllSerialNumber__c='123';
        bit2ShopStockSerials2.Bit2Shop__Status__c='Withdrawn';
        insert bit2ShopStockSerials2;

        Contact contact = new Contact(FirstName='laye', LastName='DIOP');
        insert contact;
        
        WorkOrder workOrder = Plc_TestFactory.createWorkOrder('state', account, contact, 'abi',
                                          'bankDescription', 'legacyAccountId', 'legacyAccount',
                                          'siaCode', 'legacyServicePointId', 'servicePoint',
                                          'cti', 'customerCare', 'fCode');
        
        workOrder.Plc_Alias__c = '123456789';
        workOrder.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        insert workOrder;

        WorkOrder workOrder2 = Plc_TestFactory.createWorkOrder('state', account, contact, 'abi',
                                          'bankDescription', 'legacyAccountId', 'legacyAccount',
                                          'siaCode', 'legacyServicePointId', 'servicePoint',
                                          'cti', 'customerCare', 'fCode');
        
        workOrder2.Plc_Alias__c = '';
        workOrder2.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        insert workOrder2;
        
        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;

        Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );
        insert reservation;
        Plc_Reservation__c reservation2 = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '1234567890'
        );
        insert reservation2;



        WorkOrderLineItem workOrderLineItem = Plc_TestFactory.createWorkOrderLineItem('123456789', b2wExtCatExtCat, plcTermId, 'logistic', 'ToInstall', 
                                        'ToExecute', 'note', '1235698', 'bundle');
        workOrderLineItem.WorkOrderId = workOrder.Id;
        workOrderLineItem.Plc_Alias__c='123456789';
        workOrderLineItem.Plc_Reservation__c=''+reservation.Id;
        insert workOrderLineItem; 
        

    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 17/01/2019
     * @version 1.0
     * @description Test of the method workOrderLineItemCheck and blank serialNumber
     */
    @isTest
    static void workOrderLineItemCheckAndBlankSerialNumberTest(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='123456789';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='';

        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='';
        
        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
        Test.stopTest();
        System.assertEquals('604',serviceResponse.outcomeCode);
        
    }

    @isTest
    static void workOrderLineItemBit2ShopStatus(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='123';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='123';
        
        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456789';
        
        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
        Test.stopTest();
        
    }

    /*WorkorderLineITemLegacyID is empty*/
    @isTest
    static void workOrderLineItemCheckAndBlankWorkOrderLineITemLegacyIdTest(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='123';
        
        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456789';
        
        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
        Test.stopTest();
        
    }
    
    @isTest
    static void workOrderLineItemCheckAndBlankSerialNumbersTest(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='12345';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='';
        
        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456789';
        
        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
        Test.stopTest();
        
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Modification 21/01/2019
     * @Modiy 11/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method workOrderLineItemCheck with workOrderLegacyId not equals plc_alias
     */
    @isTest
    static void workOrderLineItemCheckAndworkOrderLegacyIdEqualsAliasTest(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
       
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='123547';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='123';
        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456789';
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2=[SELECT ID,Plc_DllSerialNumberUnique__c,Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c='123';
        bit2ShopStockSerials2.Plc_EncodedSerialNumber__c='123';
        bit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c='123';
        update bit2ShopStockSerials2; 
        WorkOrderLineItem woekOrdLineItem=[SELECT Id,Plc_Alias__c FROM WorkOrderLineItem LIMIT 1];
        woekOrdLineItem.Plc_Alias__c='123547';
        update woekOrdLineItem;
        
        //Debug start
        List<String> serialNumbers = new List<String>();
        for(Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro workOrderLineItem2 : requestBody.workOrderLineItem){
            serialNumbers.add(workOrderLineItem2.serialNumber);
        }
        System.debug('==Plc_DllSerialNumberUnique__c== '+bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c);
        System.debug('==Plc_DllSerialNumberUnique__c IN== '+serialNumbers.contains(bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c));  
        //Debug end
        
        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
             requestBody.workOrderLegacyId='';
             Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
             System.assertNotEquals(serviceResponse.outcomeCode,serviceResponse2.outcomeCode);
        
        Test.stopTest();
        
    }

    @isTest
    static void workOrderLineItem(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='123';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='123';
        
        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456789';

        WorkOrderLineItem woli= [SELECT ID,Plc_Alias__c FROM WorkOrderLineItem LIMIT 1];
        woli.Plc_Alias__c='123';
        update woli;

       
        Bit2Shop__Dealer__c bit2ShopDealer = [SELECT ID,Plc_Manufacturer__c,Plc_Repairer__c FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = '1235667890' LIMIT 1];
       	//bit2ShopDealer.Plc_Manufacturer__c=true;
        //update bit2ShopDealer;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = [SELECT ID,Plc_Manufacturer__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        b2wExtCatExtCat.Plc_Manufacturer__c=bit2ShopDealer.Id;
        update b2wExtCatExtCat;

        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse response= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
        Test.stopTest();
        
    }
      
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 17/01/2019
     * @version 1.0
     * @description Test of the method workOrderLineItemCheck
     */
    @isTest
    static void workOrderLineItemCheckNotBlankWorkOrderLegacyTest(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
       
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='1234567';
        //List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        //workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        //requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456';
        
        String sourceExtSystem='test';
        Test.startTest();
              
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
            //Plc_ServiceWs.ServiceResponse serviceResponse1= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
        Test.stopTest();
        System.assertEquals('204',serviceResponse.outcomeCode);
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 21/01/2019
     * @version 1.0
     * @description Test of the method workOrderLineItemCheck with not blank serial number
     */
    @isTest
    static void workOrderLineItemCheckAndNotBlankSerialNumberTest(){
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
       
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2 = [SELECT ID,Bit2Shop__Status__c,Plc_DllSerialNumberUnique__c,Plc_EncodedSerialNumberUnique__c,Plc_ManufacturerSerialNumberUnique__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
       
        bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c='123456789';
        //bit2ShopStockSerials2.Plc_EncodedSerialNumberUnique__c='123456789';
        bit2ShopStockSerials2.Plc_ManufacturerSerialNumberUnique__c='123456789';
        bit2ShopStockSerials2.Bit2Shop__Status__c = 'Withdrawn';
        update bit2ShopStockSerials2;
        system.debug('===serialll=='+[SELECT ID,Plc_DllSerialNumberUnique__c,Plc_EncodedSerialNumberUnique__c,Plc_ManufacturerSerialNumberUnique__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1]);
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='123456789';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='123456789';
        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456789';
        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
        Test.stopTest();
    }
    
    /**
     * @author Mame Diarra
     * @date creation 11/03/2019
     * @Modified 21/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method workOrderLineItemCheck with workOrderLegacyId not equals plc_alias
     */
    ///@isTest
    static void workOrderLineItemCheckAndworkOrderLegacyIdTest(){
        Bit2Shop__Dealer__c bit2ShopDealer2= [SELECT Id FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = '1235667890' LIMIT 1];
        bit2ShopDealer2.Plc_Alias__c='null';
        update bit2ShopDealer2;
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = [SELECT Id,Plc_Manufacturer__c FROM B2WExtCat__External_Catalog_Item__c LIMIT 1];
        b2wExtCatExtCat.Plc_Manufacturer__c=bit2ShopDealer2.Id;
        update b2wExtCatExtCat;
        
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro();   
       
        Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro=new Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro();   
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.workOrderLineItemLegacyId='null_123';
        verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro.serialNumber='123';
        List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro> workOrderLineItem= new List<Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro>();
        workOrderLineItem.add(verificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro);
        requestBody.workOrderLineItem=workOrderLineItem;
        requestBody.workOrderLegacyId='123456789';
        
        Bit2Shop__Stock_Serials2__c bit2ShopStockSerials2=[SELECT ID,Plc_DllSerialNumberUnique__c,Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c='123';
        bit2ShopStockSerials2.Plc_EncodedSerialNumber__c='1234';
        bit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c='123';
        update bit2ShopStockSerials2; 
        WorkOrderLineItem woekOrdLineItem=[SELECT Id,Plc_Alias__c FROM WorkOrderLineItem LIMIT 1];
        woekOrdLineItem.Plc_Alias__c='null_123';
        update woekOrdLineItem;
        
        //Debug start
        List<String> serialNumbers = new List<String>();
        for(Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro workOrderLineItem2 : requestBody.workOrderLineItem){
            serialNumbers.add(workOrderLineItem2.serialNumber);
        }
        System.debug('==Plc_DllSerialNumberUnique__c== '+bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c);
        System.debug('==Plc_DllSerialNumberUnique__c IN== '+serialNumbers.contains(bit2ShopStockSerials2.Plc_DllSerialNumberUnique__c));  
        //Debug end
        
        String sourceExtSystem='test';
        Test.startTest();
             Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
             //requestBody.workOrderLegacyId='';
             //Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody,sourceExtSystem) ;
             //System.assertNotEquals(serviceResponse.outcomeCode,serviceResponse2.outcomeCode);
        
        Test.stopTest();
    }

    /***********************************************************************************************************************/
    /***********************************************************************************************************************/

    /**
     * @author Abdoulaye & Moussa
     * @date Modification 17/01/2019
     * @version 1.0
     * @description Test of the method workOrdersLock and blank workOrdersToUpdate
     */
    @isTest
    static void retrieveWorkOrdersLineItemToExecuteTest(){
        Test.startTest();
         Map<String,WorkOrderLineItem> workOrderLineItemMap= Plc_WorkOrderLineItemsServices.retrieveWorkOrdersLineItemToExecute() ;
        Test.stopTest();
    }   

    /************************************************** WORK ORDER LOCK ***********************************************/
    /************************************************** WORK ORDER LOCK ***********************************************/
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 17/01/2019
     * @version 1.0
     * @description Test of the method workOrdersLock
     */
    @isTest
    static void workOrdersLockTest(){
        
        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c =:'123456789' LIMIT 1];
   
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','pCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
       

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('ToInstall',  
                                                                                                                    'ToExecute', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');

        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();

        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);

        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
        
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='123456789';
        requestList.workOrder.add(gestOrdReqBody);

        Test.startTest();
        String sourceExtSystem='MONETICA';
         Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;
        String sourceExtSystem10='WSICT';
         Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem10) ;
        Test.stopTest();
    }
     
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 17/01/2019
     * @version 1.0
     * @description Test of the method workOrdersLock and blank workOrdersToUpdate
     */
    @isTest
    static void workOrdersLockAndBlankWorkOrdersToUpdateTest(){

        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c =:'123456789' LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType',  
                                                                                                                    'status', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','pCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
       
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
          
        
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='';
        requestList.workOrder.add(gestOrdReqBody);

        String sourceExtSystem='MONETICA';
        Test.startTest();
        Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;
        Test.stopTest();
    }
   
    /**
     * @author Mame Diarra
     * @date creation 12/03/2019
     * @version 1.0
     * @description Test of the method workOrdersLock and reservationToUpdate containt reservationId
     */
    @isTest
    static void workOrdersLockAndReservationIdTest(){
        Bit2Shop__Product_Stock__c bit2ShopProductStock= [SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];
        Plc_Reservation__c reservation = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = ''
        );
        insert reservation;
         
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();        
         gestOrdReqBodyDetRiga.reservationId=''+reservation.Id;
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','pCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
       
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
        
        
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='123456789';
        requestList.workOrder.add(gestOrdReqBody);
   
        String sourceExtSystem='MONETICA';
        Test.startTest();
        Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;
        
        WorkOrderLineItem WorkOrdLineItem= [SELECT Id, Plc_Alias__c FROM WorkOrderLineItem LIMIT 1];
        WorkOrdLineItem.Plc_Alias__c='';
        update WorkOrdLineItem;
        Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;
        Test.stopTest();
    }
   
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 17/01/2019
     * @version 1.0
     * @description Test of the method workOrdersLock and WorkOrder is empty
     */
    @isTest
    static void workOrdersLockAndEmptyWorkOrderTest(){
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = new Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga();        
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','pCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
       
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
        
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='123456789';
        requestList.workOrder.add(gestOrdReqBody);

        String sourceExtSystem='MONETICA';
        Test.startTest();
         Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;
        Test.stopTest();
    }
   
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 17/01/2019
     * @Modify 12/03/2019 by Mame Diarra
     * @version 1.0
     * @description Test of the method workOrdersLock errorMessageNotContaint workOrderLegacyId
     */
    @isTest
    static void workOrdersLockAndErrorMessageMapNotContaintWorkOrderLegacyIdTest(){
        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c ='123456789' LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType',  
                                                                                                                    'status', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','pCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
       
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
          
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='123456789';
        requestList.workOrder.add(gestOrdReqBody);

        String sourceExtSystem='test';
        Test.startTest();
         Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;
         Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,'MONETICA') ;
        Test.stopTest();
    }  

    /**
     * @author Abdoulaye & Moussa
     * @date Modification 20/03/2019
     * @version 1.0
     * @description Test of the method workOrdersLock
     */
    @isTest
    static void workOrdersLockNewTest(){

        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c =:'123456789' LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType',  
                                                                                                                    'status', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');
        
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','pCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
       
        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
          
        
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='123456789';
        requestList.workOrder.add(gestOrdReqBody);

        String sourceExtSystem='MONETICA';
        Test.startTest();
        Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;
        
        //workOrderLineItem.workOrderLineItemDetail.reservationId blank 307
        requestList.workOrder[0].workOrderLineItem[0].workOrderLineItemDetail.reservationId=' ';
        Plc_ServiceWs.ServiceResponse serviceResponse2 = Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;

        //workOrdersToUpdate does not contain Key workOrder.workOrderLegacyId 329
        requestList.workOrder[0].workOrderLegacyId=' '; 
        Plc_ServiceWs.ServiceResponse serviceResponse3 = Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,sourceExtSystem) ;


        Test.stopTest();
    }
   
   /**************************************************************************************************************************/
   /**********************************************  WORK ORDER UNLOCK***************************************************************************/
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 18/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUnlock
     */
    @isTest
    static void workOrdersUnlockTest(){
         Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c =:'123456789' LIMIT 1];
   
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','pCode','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
        Plc_Wrappers.GestioneOrdineRequestBodyCausale gestOrdReqBodCause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');
       

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('ToInstall',  
                                                                                                                    'ToExecute', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');

        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();

        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', gestOrdReqBodCause, gestOrdReqBodyDetRiga);

        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
        
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        gestOrdReqBody.workOrderLegacyId='123456789';
        requestList.workOrder.add(gestOrdReqBody);

        Test.startTest();
        String sourceExtSystem='MONETICA';
         Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersUnlock(requestList,sourceExtSystem) ;
        String sourceExtSystem11='WSICT';
         Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_WorkOrderLineItemsServices.workOrdersUnlock(requestList,sourceExtSystem11) ;
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 18/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUnlock and not blank reservationIdTest
     */
    @isTest
    static void workOrdersUnlockAndNotBlankReservationIdTest(){
        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c =:'123456789' LIMIT 1];
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType',  
                                                                                                                    'status', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');
        
         Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
         List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
         gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
         Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
         Plc_Wrappers.GestioneOrdineRequestBody gestioneOrdReqBody=Plc_WsTestFactory.createGestioneOrdineRequestBody('1425369', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
         
        Test.startTest();
           Plc_ServiceWs.ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrdersUnlock(requestList,'MONETICA') ;
        
           gestioneOrdReqBody.workOrderLegacyId='123456789'; 
           requestList.workOrder.add(gestioneOrdReqBody);
           Plc_ServiceWs.ServiceResponse serviceResponse2 = Plc_WorkOrderLineItemsServices.workOrdersUnlock(requestList,'test') ;
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 18/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUnlock and blank reservationIdTest
     */
    @isTest
    static void workOrdersUnlockAndBlanReservationIdTest(){
        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c =:'123456789' LIMIT 1];
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType',  
                                                                                                                    'status', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');
        
         Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
         List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
         gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
         Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
         Plc_Wrappers.GestioneOrdineRequestBody gestioneOrdReqBody=Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
         
        Test.startTest();
           Plc_ServiceWs.ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrdersUnlock(requestList,'MONETICA') ;
        
           gestioneOrdReqBody.workOrderLegacyId='123456789'; 
           requestList.workOrder.add(gestioneOrdReqBody);
           Plc_ServiceWs.ServiceResponse serviceResponse2 = Plc_WorkOrderLineItemsServices.workOrdersUnlock(requestList,'MONETICA') ;
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 18/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUnlock and blank reservationIdTest
     */
    @isTest
    static void workOrdersUnlockAndBlanWorkOrderLegacyIdTest(){
        Plc_Reservation__c reservationTemp = [SELECT Id FROM Plc_Reservation__c WHERE Plc_Alias__c =:'123456789' LIMIT 1];
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('operationType',  
                                                                                                                    'status', 'serialNumber', ''+reservationTemp.Id, 
                                                                                                                    'bundleId', 'termId', System.today().format(),'1234567980', 'notes');
        
         Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('123456789', null, gestOrdReqBodyDetRiga);
         List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
         gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);        
        
         Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd =Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('00789654123654789','Installation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName',  'status', System.today()+ '', System.today() + 3+'',  'cti','category',  'ctiType','dealerAlias','province','1797921', '737839','4792971', 
                                                                                'shopLegacyId','signboard','post','locality','prefix','778197878','ghwd@wsq','0033','14:00','referent', 'notes');
         Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
         Plc_Wrappers.GestioneOrdineRequestBody gestioneOrdReqBody=Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
         gestioneOrdReqBody.workOrderLegacyId=''; 
         requestList.workOrder.add(gestioneOrdReqBody);         
        Test.startTest();
           Plc_ServiceWs.ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrdersUnlock(requestList,'MONETICA') ;
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 18/01/2019
     * @version 1.0
     * @description Test of the method retrieveWorkOrders
     */
    @isTest
    static void retrieveWorkOrdersTest(){
         Set<String>   workOrderAlias= new Set<String> ();
         workOrderAlias.add('123456789');      
         Test.startTest();
            Map<String, WorkOrder>  workOrdersMap = Plc_WorkOrderLineItemsServices.retrieveWorkOrders(workOrderAlias) ;
         Test.stopTest();
    }
            
    /**
     * @author Abdoulaye & Moussa
     * @date Modification 21/01/2019
     * @version 1.0
     * @description Test of the method workOrdersLock for to cover catch
     */
    @isTest
    static void workOrdersLockTestKO(){
 
        Plc_Wrappers.GestioneOrdineRequest requestList= new Plc_Wrappers.GestioneOrdineRequest();
       
        Test.startTest();
            Plc_ServiceWs.ServiceResponse serviceResponse= Plc_WorkOrderLineItemsServices.workOrdersLock(requestList,'sourceExtSystem') ;
        Test.stopTest();
      }
    
    @isTest
    static void retrieveWorkOrders(){
        SET<string> workOrderAlias = new SET<string>();
        workOrderAlias.add('123456789');
        Test.startTest();
            Plc_WorkOrderLineItemsServices.retrieveWorkOrders(workOrderAlias) ;
        Test.stopTest();
    }
    
}