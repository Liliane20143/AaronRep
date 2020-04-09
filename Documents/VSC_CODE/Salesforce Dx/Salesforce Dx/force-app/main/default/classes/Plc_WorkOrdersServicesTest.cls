/**
 * @author Abdoulaye & Moussa
 * @modified by Abdoulaye DIOP 08/04/2019
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC WorkOrdersServices Rest WebService.
 */

@isTest
public class Plc_WorkOrdersServicesTest {
    @TestSetup
    static void makeData(){
        
        Plc_TestFactory.initProcessClickPackage();
        
        insert Plc_TestFactory.newPhaseTrans('Bit2Shop__Stock_Serials2__c', 'Standard', 'Available', 'Withdrawn');
        insert Plc_TestFactory.newPhaseTrans('WorkOrder', 'Installation', 'Assigned', 'Closed');
        
        Bit2Shop__Stock_Action__c messaincampoStockAction = new Bit2Shop__Stock_Action__c();
        messaincampoStockAction.Bit2Shop__Action_Code__c='MESSAINCAMPO_DESTINAZIONE';
        messaincampoStockAction.Bit2Shop__Active__c=true;
        messaincampoStockAction.Bit2Shop__Order_Type__c='Transfer';
        messaincampoStockAction.Bit2Shop__Required_Attachment__c=false;
        messaincampoStockAction.Bit2Shop__Target_Inventory_Level__c='New';
        messaincampoStockAction.Name='Messa in campo Destinazione';
        insert messaincampoStockAction;

        Bit2Shop__TransferDetail__c messaInCampo = new Bit2Shop__TransferDetail__c();
        messaInCampo.Bit2Shop__Code__c='MESSAINCAMPO';
        messaInCampo.Bit2Shop__Transfer_Type__c='Stock2OtherShop';
        messaInCampo.Plc_DestinationWarehouseStockAction__c=messaincampoStockAction.Id;
        messaInCampo.Plc_FilterDestinationWarehouse__c='Installed';
        messaInCampo.Plc_FilterOriginDealer__c='Plc_Maintainer__c';
        messaInCampo.Plc_FilterOriginWarehouse__c='Generic';
        messaInCampo.Plc_FilterSerialStatus__c='Withdrawn';
        messaInCampo.Plc_SourceWarehouseStockAction__c=messaincampoStockAction.id;
        
        insert messaInCampo;
        
            
        Account account01 = Plc_TestFactory.createAccountSupplier('01');
        insert account01;

        Bit2Shop__Dealer__c dealerParent01 = Plc_TestFactory.createDealerParent('01', account01,'alias1');
        dealerParent01.Plc_Repairer__c = true;
        dealerParent01.Plc_DealerManufacturer__c = true;
        insert dealerParent01;

        Bit2Shop__Dealer__c dealerChild01 = Plc_TestFactory.createDealerChild('01', account01,'alias2', dealerParent01);
        dealerChild01.Bit2Shop__Parent_Dealer__c= dealerParent01.Id;
        insert dealerChild01;

        Bit2Shop__Warehouse__c warehouse01 = Plc_TestFactory.createWarehouse('01', 'Irrecoverable', 'Nexi', 'WH0001', dealerChild01);
        insert warehouse01;

        Bit2Shop__Dealer__c dealerChild02 = Plc_TestFactory.createDealerChild('02', account01,'alias3',dealerParent01);
        dealerChild02.Bit2Shop__Parent_Dealer__c= dealerParent01.Id;
        dealerChild02.Plc_Repairer__c = true;
        insert dealerChild02;

        Bit2Shop__Warehouse__c warehouse02 = Plc_TestFactory.createWarehouse('02', 'Repaired', 'Nexi','WH0002', dealerChild02);
        insert warehouse02;

        Plc_TestFactory.createWarehouseFake();

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('123456789');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;

        /**********************************  B2WExtCat__External_Catalog_Item__c Creation     **************************************/

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '123456789', 'Process');                                                                                               
        b2wExtCatExtCat.Plc_Alias__c = '123456789';
        b2wExtCatExtCat.Plc_Category__c = 'Product';
        b2wExtCatExtCat.Plc_Subcategory__c = 'SIM';
        b2wExtCatExtCat.Plc_Solution__c = plcSolution.Id;

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat2 = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '4565165', 'Process');                                                
        b2wExtCatExtCat2.Plc_Category__c='Product';
        b2wExtCatExtCat2.Plc_Alias__c = '4565165';
        b2wExtCatExtCat2.Plc_Solution__c = plcSolution.Id;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat3 = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '165923', 'Process');
        b2wExtCatExtCat3.Plc_Category__c='Product';
        b2wExtCatExtCat3.Plc_Alias__c = '165923';
        b2wExtCatExtCat3.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat3.Plc_Manufacturer__c=dealerParent01.id;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat4 = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '165920', 'Process');
        b2wExtCatExtCat4.Plc_Category__c='Product';
        b2wExtCatExtCat4.Plc_Alias__c = '165920';
        b2wExtCatExtCat4.Plc_Solution__c = plcSolution.Id;
        b2wExtCatExtCat4.Plc_Manufacturer__c=dealerParent01.id;
        b2wExtCatExtCat4.Plc_Subcategory__c='SIM';

        insert new List<B2WExtCat__External_Catalog_Item__c>{b2wExtCatExtCat2,b2wExtCatExtCat,b2wExtCatExtCat3,b2wExtCatExtCat4};

        /**********************************  Bit2Shop__Product_Stock__c Creation     **************************************/

        Bit2Shop__Product_Stock__c bit2ShopProductStock = Plc_TestFactory.createProductStock(b2wExtCatExtCat,warehouse01);
        bit2ShopProductStock.Bit2Shop__Warehouse_Id__c = warehouse01.Id;
        bit2ShopProductStock.Plc_UsableQty__c = 15;
        bit2ShopProductStock.Plc_WithdrawnQty__c = 3;

        Bit2Shop__Product_Stock__c bit2ShopProductStock2 = Plc_TestFactory.createProductStock(b2wExtCatExtCat2, warehouse02);
        bit2ShopProductStock2.Bit2Shop__Warehouse_Id__c = warehouse02.Id;
        bit2ShopProductStock2.Plc_UniqueKey__c = System.now() +'1';
        bit2ShopProductStock2.Plc_UsableQty__c = 0;
        bit2ShopProductStock2.Plc_WithdrawnQty__c = 0;
        bit2ShopProductStock2.Bit2Shop__External_Catalog_Item_Id__c=b2wExtCatExtCat3.id;
        

        Bit2Shop__Product_Stock__c bit2ShopProductStock3 = Plc_TestFactory.createProductStock(b2wExtCatExtCat3, warehouse01);
        bit2ShopProductStock3.Bit2Shop__Warehouse_Id__c = warehouse01.Id;
        bit2ShopProductStock3.Plc_UsableQty__c  = 10;
        bit2ShopProductStock3.Plc_WithdrawnQty__c = 3;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock4 = Plc_TestFactory.createProductStock(b2wExtCatExtCat4, warehouse01);
        bit2ShopProductStock4.Bit2Shop__Warehouse_Id__c = warehouse01.Id;
        bit2ShopProductStock4.Plc_UniqueKey__c = System.now() +'2';
        bit2ShopProductStock4.Plc_UsableQty__c = 100;
        bit2ShopProductStock4.Plc_WithdrawnQty__c = 0;
        bit2ShopProductStock4.Bit2Shop__External_Catalog_Item_Id__c=b2wExtCatExtCat4.id;
        
        insert new List<Bit2Shop__Product_Stock__c> {bit2ShopProductStock, bit2ShopProductStock2, bit2ShopProductStock3,bit2ShopProductStock4};
        
        
        
        /**********************************  TriggerSettings__c Creation     **************************************/
        
        //TriggerSettings__c setting = new TriggerSettings__c();
        //setting.WorkOrderTrigger__c = System.now();
        //insert setting;
		
        /**********************************  Contact Creation     **************************************/

        Contact contact = new Contact(FirstName='laye', LastName='DIOP');
        insert contact;

        /**********************************  Plc_TermId__c Creation     **************************************/

        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('123456789');
        insert plcTermId;

        Plc_TermId__c plcTermId2 = Plc_TestFactory.createTermId('20190510');
        insert plcTermId2;

        /**********************************  Asset Creation     **************************************/

        /*Asset parentAsset =new Asset(Name='Parent');
        parentAsset.Plc_ProductStock__c=bit2ShopProductStock.Id;
        parentAsset.Plc_ServicePointLegacyId__c='ff4a01hg';
        parentAsset.AccountId=account01.Id;
        parentAsset.Status='Uninstalled';
        insert parentAsset;*/
        Asset parentAsset = new Asset();
        parentAsset.Plc_ServicePointLegacyId__c='ff4a01hg';
        parentAsset.Status='Uninstalled';
        parentAsset.Plc_ProductStock__c=bit2ShopProductStock.Id;
        parentAsset.AccountId=account01.Id;

        Asset childAsset =new Asset(Name='Test');
        childAsset.Plc_ProductStock__c=bit2ShopProductStock.Id;
        childAsset.Plc_ServicePointLegacyId__c='ea594cc00';
        childAsset.AccountId=account01.Id;
        childAsset.Status='Installed';
        childAsset.ParentId=parentAsset.Id;
        childAsset.Plc_TermId__c=plcTermId.Id;
        insert childAsset;


        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2_2 = Plc_TestFactory.createStockSerial2(warehouse01,  'Installed');
        bnit2ShopStockSerials2_2.Plc_ManufacturerSerialNumber__c = '2019051009351234567';
        bnit2ShopStockSerials2_2.Plc_EncodedSerialNumber__c = '2019051009351234567';
        bnit2ShopStockSerials2_2.Plc_Property__c='N';
        bnit2ShopStockSerials2_2.Plc_DllSerialNumber__c='2019051009351234567';
        bnit2ShopStockSerials2_2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock2.Id ;
        insert bnit2ShopStockSerials2_2;
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2_3 = Plc_TestFactory.createStockSerial2(warehouse01,  'Installed');
        bnit2ShopStockSerials2_3.Plc_ManufacturerSerialNumber__c = '2019051009351234568';
        bnit2ShopStockSerials2_3.Plc_EncodedSerialNumber__c = '2019051009351234568';
        bnit2ShopStockSerials2_3.Plc_Property__c='N';
        bnit2ShopStockSerials2_3.Plc_DllSerialNumber__c='2019051009351234568';
        bnit2ShopStockSerials2_3.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock4.Id ;
        insert bnit2ShopStockSerials2_3;
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2_4 = Plc_TestFactory.createStockSerial2(warehouse01,  'Installed');
        bnit2ShopStockSerials2_4.Plc_ManufacturerSerialNumber__c = '2019051009351234569';
        bnit2ShopStockSerials2_4.Plc_Property__c='N';
        bnit2ShopStockSerials2_4.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock4.Id ;
        insert bnit2ShopStockSerials2_4;
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2_5 = Plc_TestFactory.createStockSerial2(warehouse01,  'Installed');
        bnit2ShopStockSerials2_5.Plc_EncodedSerialNumber__c = '20190510093512345610';
        bnit2ShopStockSerials2_5.Plc_Property__c='N';
        bnit2ShopStockSerials2_5.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock4.Id ;
        insert bnit2ShopStockSerials2_5;

        Asset childAsset2 =new Asset(Name='Asset');
        childAsset2.Plc_ProductStock__c=bit2ShopProductStock2.Id;
        childAsset2.Plc_ServicePointLegacyId__c='ea594cc0g0';
        childAsset2.AccountId=account01.Id;
        childAsset2.Status='Installed';
        childAsset2.Plc_TermId__c=plcTermId2.Id;
        childAsset2.Plc_StockSerial__c=bnit2ShopStockSerials2_2.id;
        insert childAsset2;

        /**********************************  Plc_Reservation__c Creation     **************************************/

        Plc_Reservation__c reservation1 = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '123456789'
        );

        Plc_Reservation__c reservation2 = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock2.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '68652652'
        );
        Plc_Reservation__c reservation3 = new Plc_Reservation__c(
                Plc_ProductStock__c = bit2ShopProductStock3.Id,
                Plc_Status__c = 'Reserved',
                Plc_Alias__c = '201903291537'
        );
        insert new List<Plc_Reservation__c>{reservation1, reservation2,reservation3};

        /**********************************  WorkOrder Creation     **************************************/

        WorkOrder workOrder = Plc_TestFactory.createWorkOrder('state', account01, contact, 'abi',
                                          'bankDescription', 'legacyAccountId', 'legacyAccount',
                                          'siaCode', 'legacyServicePointId', 'servicePoint',
                                          'cti', 'customerCare', 'fCode');
        WorkOrder.Status = 'Assigned';
        workOrder.Plc_Alias__c = '123456789';
        workOrder.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');

        WorkOrder workOrder2 = Plc_TestFactory.createWorkOrder('state', account01, contact, 'abi',
                                          'bankDescription', 'legacyAccountId', 'legacyAccount',
                                          'siaCode', 'legacyServicePointId', 'servicePoint',
                                          'cti', 'customerCare', 'fCode');
        WorkOrder2.Status = 'OnHold';
        workOrder2.Plc_Alias__c = '1234567890';
        workOrder2.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');

        WorkOrder workOrder3 = Plc_TestFactory.createWorkOrder('state', account01, contact, 'abi',
                                          'bankDescription', 'legacyAccountId', 'legacyAccount',
                                          'siaCode', 'legacyServicePointId', 'servicePoint',
                                          'cti', 'customerCare', 'fCode');                            
        workOrder3.Status = 'Assigned';
        workOrder3.Plc_Alias__c = '201903291147';
        workOrder3.RecordTypeId = Plc_Utils.getRecordTypeId('Uninstallation', 'WorkOrder');

        insert new List<WorkOrder> {workOrder, workOrder2, workOrder3};

        /**********************************  WorkOrderLineItem Creation     **************************************/

        WorkOrderLineItem workOrderLineItem = Plc_TestFactory.createWorkOrderLineItem('123456789', b2wExtCatExtCat, plcTermId, 'logistic', 'ToInstall',
                                        'ToExecute', 'note', '1235698', 'bundle');
        workOrderLineItem.WorkOrderId = workOrder.Id;
        WorkOrderLineItem.Plc_ReferenceExternalCatalogItem__c = '123456789';
        WorkOrderLineItem.Plc_Reservation__c = reservation1.id;
        WorkOrderLineItem.Plc_Closed__c=false;

        WorkOrderLineItem workOrderLineItem2 = Plc_TestFactory.createWorkOrderLineItem('12345678999', b2wExtCatExtCat, plcTermId, 'logistic', 'ToInstall',
                                        'ToExecute', 'note', '1235698', 'bundle');
        workOrderLineItem2.WorkOrderId = workOrder2.Id;
        WorkOrderLineItem2.Status = 'NotExecuted';
        WorkOrderLineItem2.Plc_Reservation__c = reservation2.id;
        WorkOrderLineItem2.Plc_ReferenceExternalCatalogItem__c = '123456789';
        WorkOrderLineItem2.Plc_Closed__c=false;

        WorkOrderLineItem workOrderLineItem3 = Plc_TestFactory.createWorkOrderLineItem('201903291147_1', b2wExtCatExtCat, plcTermId, 'logistic', 'ToRemove',
                                        'ToExecute', 'note', '1235698', 'bundle');
        workOrderLineItem3.WorkOrderId = workOrder3.Id;
        WorkOrderLineItem3.Plc_Reservation__c = reservation3.id;
        workOrderLineItem3.Plc_ReferenceExternalCatalogItem__c = '123456789';
        workOrderLineItem3.Plc_Closed__c=false;

        WorkOrderLineItem workOrderLineItem4 = Plc_TestFactory.createWorkOrderLineItem('201903291148_1', b2wExtCatExtCat, plcTermId, 'logistic', 'ToDeactivate',
                                        'ToExecute', 'note', '1235698', 'bundle');
        workOrderLineItem3.WorkOrderId = workOrder3.Id;
        WorkOrderLineItem3.Plc_Reservation__c = reservation3.id;
        workOrderLineItem3.Plc_ReferenceExternalCatalogItem__c = '123456789';
        workOrderLineItem3.Plc_Closed__c=false;

        insert new List<WorkOrderLineItem> {workOrderLineItem, workOrderLineItem2,workOrderLineItem3};

        /**********************************  Plc_WorkOrderConfiguration__c Creation     **************************************/

        Plc_WorkOrderConfiguration__c workOrderConf1 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'ToInstall',
                                                                                            Plc_NeedsCalculation__c         =   true,
                                                                                            Plc_NeedsReservation__c         =   true,
                                                                                            Name                            =   'Installation',
                                                                                            Plc_IntegrationName__c          =   'Installation'  );

        Plc_WorkOrderConfiguration__c workOrderConf2 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'ToSubstitute',
                                                                                            Plc_NeedsCalculation__c         =   true,
                                                                                            Plc_NeedsReservation__c         =   true,
                                                                                            Name                            =   'Test',
                                                                                            Plc_IntegrationName__c          =   'Test'  );

        Plc_WorkOrderConfiguration__c workOrderConf3 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'ToDeactivate',
                                                                                            Plc_NeedsCalculation__c         =   true,
                                                                                            Plc_NeedsReservation__c         =   true,
                                                                                            Name                            =   'Installation',
                                                                                            Plc_IntegrationName__c          =   'Installation'  );

        Plc_WorkOrderConfiguration__c workOrderConf4 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'ToRemove',
                                                                                            Plc_NeedsCalculation__c         =   true,
                                                                                            Plc_NeedsReservation__c         =   true,
                                                                                            Name                            =   'Uninstallation',
                                                                                            Plc_IntegrationName__c          =   'Uninstallation'  );

        Plc_WorkOrderConfiguration__c workOrderConf5 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'TOINSTALL',
                                                                                            Plc_NeedsCalculation__c         =   true,
                                                                                            Plc_NeedsReservation__c         =   true,
                                                                                            Name                            =   'Test',
                                                                                            Plc_IntegrationName__c          =   'Test'  );

        Plc_WorkOrderConfiguration__c workOrderConf6 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'ToReconfigureCorr',
                                                                                            Plc_NeedsCalculation__c         =   false,
                                                                                            Plc_NeedsReservation__c         =   false,
                                                                                            Name                            =   'Corr',
                                                                                            Plc_IntegrationName__c          =   'Corr'  );
        Plc_WorkOrderConfiguration__c workOrderConf7 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'ToSubstituteCorr',
                                                                                            Plc_NeedsCalculation__c         =   false,
                                                                                            Plc_NeedsReservation__c         =   false,
                                                                                            Name                            =   'Corr',
                                                                                            Plc_IntegrationName__c          =   'Corr'  );

        Plc_WorkOrderConfiguration__c workOrderConf8 = new Plc_WorkOrderConfiguration__c(   Plc_EligibleOperationTypes__c   =   'ToDeactivate',
                                                                                            Plc_NeedsCalculation__c         =   false,
                                                                                            Plc_NeedsReservation__c         =   false,
                                                                                            Name                            =   'Deactivation',
                                                                                            Plc_IntegrationName__c          =   'Deactivation'  );                                                                                  


        insert new List<Plc_WorkOrderConfiguration__c> {workOrderConf1, workOrderConf2,workOrderConf3,workOrderConf4,workOrderConf5,workOrderConf6,workOrderConf7,workOrderConf8};


        /**********************************  Bit2Shop__Stock_Serials2__c Creation     **************************************/

        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2 = Plc_TestFactory.createStockSerial2(warehouse01,  'Withdrawn');
        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'VALUE1';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'TEST';
        bnit2ShopStockSerials2.Plc_Property__c='N';
        bnit2ShopStockSerials2.Plc_DllSerialNumber__c='023302AA';
        bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id ;
        bnit2ShopStockSerials2.Plc_DllSerialNumberUnique__c = '125874965';

        insert bnit2ShopStockSerials2;

        
        // system.debug('==StockSerial2222==='+[select id,Plc_ManufacturerSerialNumber__c,Plc_EncodedSerialNumber__c,Plc_DllSerialNumberUnique__c from Bit2Shop__Stock_Serials2__c where id=:bnit2ShopStockSerials2.id]);

        //
       Account acc = Plc_TestFactory.createAccountSupplier('test');
       insert acc;

       User costr = Plc_TestFactory.createUser('ad', 'Costruttore');
       insert costr;

       Bit2Shop__Dealer__c dealerParent = Plc_TestFactory.createDealerParent('parent', acc,'alias4');
       insert dealerParent;

       Bit2Shop__Dealer__c dealer = Plc_TestFactory.createDealerChild('child', acc,'alias5' ,dealerParent);
       dealer.OwnerId = costr.Id;
       insert dealer;

    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 29/03/2019
     * @version 1.0
     * @description Test of the method workOrdersCreateTest when
     */
    @isTest
    static void workOrdersCreateGestioneRequestTest(){
        Plc_Wrappers.GestioneOrdineRequest requestList = new Plc_Wrappers.GestioneOrdineRequest();
        String sourceExtSystem = '';
        Test.startTest();
            Plc_WorkOrdersServices.workOrdersCreate(requestList, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 29/03/2019
     * @version 1.0
     * @description Test of the method workOrdersCreateTest when workOrderConfigurationMap not contains (workOrderConfigurationKey)
     */
    @isTest
    static void workOrdersCreateWhenWorkOrderConfigurationMapTest(){
        // workOrderConfigurationKey = INSTALLATIONTODEACTIVATE
        //if(!workOrderConfigurationMap.containsKey(workOrderConfigurationKey)) line 164
        String sourceExtSystem = '';
        Plc_Wrappers.GestioneOrdineRequestBody workOrder = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        workOrder.workOrderLegacyId = '321654';
        workOrder.workOrderDetail.requestType = 'UNINSTALLATION';
        workOrder.workOrderLineItem[0].workOrderLineItemDetail.operationType ='ToDeactivate';
		workOrder.workOrderLineItem[0].workOrderLineItemDetail.termId ='123456789';
        Test.startTest();
            Plc_WorkOrdersServices.workOrdersCreate(workOrder, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Modification 11/01/2018
     * @version 1.0
     * @description Test of the method workOrdersCreateTest
     */
    @isTest
    static void workOrdersCreateTest(){

        WorkOrder wo = [SELECT ID FROM WorkOrder LIMIT 1];
        WorkOrderLineItem woli=[SELECT ID FROM WorkOrderLineItem LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode', 'blockDescription');        

        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        requestBody.workOrderLineItem[0].cause = cause;
        requestBody.workOrderLineItem[0].workOrderLineItemLegacyId = woli.Id+'';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        requestBody.workOrderLegacyId = wo.Id + '';

        Test.startTest();
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');
        
        // trigg exception i end date line 145 workOrder.workOrderDetail.endDate
        requestBody.workOrderDetail.endDate= 'bad Date';
        Plc_ServiceWs.ServiceResponse responseEndDate = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');

        /************************************     Product Available Quantity > 0    **********************************/
        requestBody.workOrderDetail.endDate= System.today() + '';
        requestBody.workOrderDetail.warehouseAlias='WH0001';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias='165923';
        Bit2Shop__Product_Stock__c product9 = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        product9.Plc_WithdrawnQty__c = 0;
        product9.Plc_UsableQty__c = 100;
        update product9;

        Plc_ServiceWs.ServiceResponse response9 = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');

        /************************************     Product Available Quantity < 0    **********************************/
        requestBody.workOrderDetail.endDate= System.today() + '';
        requestBody.workOrderDetail.warehouseAlias='123456789';
        Bit2Shop__Product_Stock__c product = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        product.Plc_WithdrawnQty__c = -10;
        product.Plc_UsableQty__c = -10;
        update product;

        Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');

        /************************************  sourceExtSystem is MONETICA    *******************************/

        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'MONETICA');

        Map<String, Plc_Reservation__c> reservationsToInsert = new Map<String, Plc_Reservation__c>();


        /*************************************** Product stock does not exist   ******************************************/
       
        requestBody.workOrderDetail.warehouseAlias='';
        Plc_ServiceWs.ServiceResponse responseX = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');

        /***********************    workOrderConfigurationMap does not conntain key  workOrderConfigurationKey  **********/
        
        //gestOrdReqBodyDetRiga.operationType = '';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = '';
        requestBody.workOrderDetail.warehouseAlias='123456789';

        Plc_ServiceWs.ServiceResponse responseY = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');

        /*********************************************  Handle Exception WITH EMPTY RECORD TYPE ID **************************************/
        requestBody.workOrderDetail.requestType='';
        requestBody.workOrderDetail.endDate= System.today()+'bad Date';
        Plc_ServiceWs.ServiceResponse responseZ = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'MONETICA');
        //System.debug('=MF=  Dt endDate  ==' + DateTime.valueOfGmt(requestList.workOrder[0].workOrderDetail.endDate.replace('T', ' ')));

        Test.stopTest(); 

    }

    @isTest
    static void workOrdersCreateTest2(){

        WorkOrder wo = [SELECT ID FROM WorkOrder LIMIT 1];
        WorkOrderLineItem woli=[SELECT ID FROM WorkOrderLineItem LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');
        
        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        requestBody.workOrderLegacyId = wo.Id+'';
        requestBody.workOrderLineItem[0].workOrderLineItemLegacyId = woli.Id+'';
        requestBody.workOrderLineItem[0].cause = cause;
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today()+'';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';

        Test.startTest();

        //Exception Line 232
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate='bad value';
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');

        requestBody.workOrderDetail.warehouseAlias='123456789';
        requestBody.workOrderDetail.requestType='INSTALLATION';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate=''+System.now();
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.operationType='ToInstall';
        requestBody.workOrderLegacyId='1234567890';
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');

        Test.stopTest();

    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 03/01/2019
     * @version 1.0
     * @description Test of the method workOrdersCreate when ErrorMessageMap Not Contains WorkOrderLegacyId.
     */
    @isTest
    static void workOrdersCreateWhenErrorMessageMapNotContainsWorkOrderLegacyIdTest(){
        
        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        requestBody.workOrderLegacyId = '123456789';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today()+'';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        requestBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';

        Test.startTest();
        Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 15/01/2019
     * @version 1.0
     * @description Test of the method workOrdersCreateTest
     */
    @isTest
    static void workOrdersCreateWhenPlcAliasIsNotMissingTest(){
        
        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();

        Test.startTest();
        // line 191
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(requestBody, 'WSICT');
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 15/01/2019
     * @version 1.0
     * @description Test of the method workOrdersCreate
     */
    @isTest
    static void workOrdersCreate2Test(){

        String sourceExtSystem = 'WSICT';

        List<Plc_Reservation__c> rservations = [SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLegacyId = '125588';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = '' +rservations[0].Id;
        gestOrdReqBody.workOrderDetail.warehouseAlias= 'WH0001';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';

        Test.startTest();

        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);
        //Assertion
        //System.assertEquals('602',response.outcomeCode);
        //System.assertEquals('[ERR:CL-00E099] : Work order with alias '+gestOrdReqBody.workOrderLegacyId+' already in system',response.outcomeMessage);

        // line 497
        gestOrdReqBody.workOrderLegacyId = '1234';
        gestOrdReqBody.workOrderDetail.warehouseAlias = '14256';
        Plc_ServiceWs.ServiceResponse response1 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        //operationType is 'ToDeactivate'
        gestOrdReqBody.workOrderDetail.warehouseAlias = '123456789';
        gestOrdReqBody.workOrderLegacyId='';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToDeactivate';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '123456789';
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        //operationType not 'ToDeactivate' AND workOrder.workOrderDetail.warehouseAlias not blank
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderDetail.warehouseAlias = '';
        Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);
        //Assertion
        //System.assertEquals('602',response3.outcomeCode);
        //System.assertEquals('[ERR:CL-00E0100] : warehouseAlias is blank or null',response3.outcomeMessage);

        gestOrdReqBody.workOrderDetail.warehouseAlias = '123456789';
        gestOrdReqBody.workOrderDetail.requestType = 'INSTALLATION';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        //resourceAliasMap contains Key workOrderLineItem.workOrderLineItemDetail.resourceAlias
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias='';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        //Assert
        //System.assertEquals('602',response5.outcomeCode);
        // when stockSerialMap containsKey(workOrderLineItem.workOrderLineItemDetail.termId)) line 586
        gestOrdReqBody.workOrderDetail.startDate = System.today()+'';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '55245846';

        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 22/01/2019
     * @version 1.0
     * @description Test of the method workOrdersCreate When PlcAvailableQty < 0
     */
    @isTest
    static void workOrdersCreate2WhenPlcAvailableQtyTest(){

        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody =Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderDetail.warehouseAlias= 'WH0001';
        gestOrdReqBody.workOrderLegacyId = '123';
        gestOrdReqBody.workOrderDetail.requestType='TechnicalAssistance';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType='NoOperation';

        Test.startTest();
        Bit2Shop__Product_Stock__c product = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        product.Plc_WithdrawnQty__c = -10;
        product.Plc_UsableQty__c = -10;
        update product;
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/01/2019
     * @version 1.0
     * @description Test of the method workOrdersCreateTest when sourceExtSystem different 'WSICT'
     */
    @isTest
    static void workOrdersCreate2WhenSourceExtSystem(){
        String sourceExtSystem = 'MONETICA';
        List<Plc_Reservation__c> rservations = [SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLegacyId = '125588';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = '' +rservations[0].Id;
        gestOrdReqBody.workOrderDetail.warehouseAlias= 'WH0001';

        Test.startTest();
        // line 338
        Plc_ServiceWs.ServiceResponse response0 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        delete rservations;
        Plc_ServiceWs.ServiceResponse response1 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 01/04/2019
     * @version 1.0
     * @description Test of the method workOrdersCreate try to handle the set of exceptions
     */
    @isTest
    static void workOrderHandleExceptionTest(){

        String sourceExtSystem = 'WSICT';
        List<Plc_Reservation__c> rservations = [SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLegacyId = '125588';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = '' +rservations[0].Id;
        gestOrdReqBody.workOrderDetail.warehouseAlias= 'WH0001';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';

        Test.startTest();

        // line 154
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '987456321';
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        // line 236
        /***************************   Handle exception defining bad date format Line 602   ***************************************/
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';
        gestOrdReqBody.workOrderDetail.startDate = 'Bad Date';
        Plc_ServiceWs.ServiceResponse response0 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        gestOrdReqBody.workOrderDetail.startDate = System.today()+'';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '55245846';
        Plc_ServiceWs.ServiceResponse response1 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = rservations[0].Id;
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        /**************************    Handle exception inserting newWorkOrder  Line 647     ****************************************/
        gestOrdReqBody.workOrderDetail.startDate = ''+System.now();
        gestOrdReqBody.workOrderDetail.status = 'bad status';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        gestOrdReqBody.workOrderDetail.status = 'Completed';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        gestOrdReqBody.workOrderDetail.requestType = 'Test';
        Plc_ServiceWs.ServiceResponse response6 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        Plc_ServiceWs.ServiceResponse response7 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, 'Test');

        // handle exception in generation date
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = 'generationDate';
        Plc_ServiceWs.ServiceResponse response8 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today()+'';
        Plc_ServiceWs.ServiceResponse response9 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        // when reservationId is not on the reservationIdInSystem
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = rservations[0].Id;
        delete rservations[0];
        Plc_ServiceWs.ServiceResponse response10 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 17/01/2019
     * @version 1.0
     * @description full Test of the method workOrdersCreateTest
     */
    @isTest
    static void workOrdersCreate2FullTest(){

        String sourceExtSystem = 'WSICT';
        List<Plc_Reservation__c> rservations = [SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';

        Test.startTest();
        // trigg the exception in insert newWorkOrder line 655
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        // insert a valid workOrderLegacyId
        WorkOrderLineItem woli =[SELECT ID FROM WorkOrderLineItem LIMIT 1];
        gestOrdReqBody.workOrderLegacyId = '123';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = woli.Id;
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        // // Check if there isn't a product in the Warehouse line 550
        gestOrdReqBody.workOrderDetail.startDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '165923';
        gestOrdReqBody.workOrderDetail.warehouseAlias = 'WH0001';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 18/03/2019
     * @version 1.0
     * @description full Test of the method workOrdersCreateTest when insert newWorkOrder
     */
    @isTest
    static void workOrderCreate2InsertWorkOrderTest(){
        String sourceExtSystem = 'WSICT';

        List<Plc_Reservation__c> rservations = [SELECT Id FROM Plc_Reservation__c];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLegacyId = '123';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = rservations[0].Id;

        Test.startTest();
        // trigg exception in insert newWorkOrder
        Plc_ServiceWs.ServiceResponse response1 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, 'source');

        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = 'generationDate';
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);

        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 18/03/2019
     * @version 1.0
     * @description full Test of the method workOrdersCreateTest when start date is not correct
     */
    @isTest
    static void workOrdersCreate2WhenStartDateIsNotCorrect(){
        String sourceExtSystem = 'WSICT';

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLegacyId = '123';
        gestOrdReqBody.workOrderDetail.startDate = 'start';

        Test.startTest();
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 03/04/2019
     * @version 1.0
     * @description full Test of the method workOrdersUpdate When GestioneOrdineRequest
     */
    @isTest
    static  void workOrdersUpdateWhenGestioneOrdineRequest(){
        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequest gestioneOrdineRequest = new Plc_Wrappers.GestioneOrdineRequest();

        Test.startTest();
        Plc_WorkOrdersServices.workOrdersUpdate(gestioneOrdineRequest, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 04/01/2018
     * @version 1.0
     * @description Test of the method .
     */
    @isTest
    static void workOrdersUpdateTest(){
        String sourceExtSystem = 'WSICT';

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderDetail.warehouseAlias= 'WH0001';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';

        Test.startTest();
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        Plc_Reservation__c reservation = [SELECT Id FROM Plc_Reservation__c LIMIT 1];
        WorkOrderLineItem woli =[SELECT ID FROM WorkOrderLineItem LIMIT 1];

        // send a valid workOrderLineItemLegacyId
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = woli.Id;
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = reservation.Id;
        // review after
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        // productStockMap not contains resourcealias et warehousealias
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '1234567890';
        Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        // update the success
        gestOrdReqBody.workOrderDetail.status = 'Assigned';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        // when endDate is not valid
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';
        gestOrdReqBody.workOrderDetail.endDate = 'date';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        // trigg exception in workOrderToUpdate.RecordTypeId 768
        gestOrdReqBody.workOrderDetail.endDate = System.today()+'';
        gestOrdReqBody.workOrderDetail.requestType = 'Test';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToSubstitute';
        Plc_ServiceWs.ServiceResponse response6 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        Test.stopTest();        
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 21/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUpdate when GestioneOrdineRequestBody.
     */
    @isTest
    static void workOrdersUpdate2WhenPlcAvailableQtyTest(){

        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].cause = cause;
        gestOrdReqBody.workOrderDetail.warehouseAlias= 'WH0001';

        // when Plc_AvailableQty__c < 0  // 676
        Bit2Shop__Product_Stock__c product = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        product.Plc_WithdrawnQty__c = -10;
        product.Plc_UsableQty__c = -10;
        update product;

        WorkOrderLineItem woli=[SELECT Id FROM WorkOrderLineItem LIMIT 1];

        Test.startTest();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId =woli.Id;
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 21/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUpdate when GestioneOrdineRequestBody and sourceExtSystem not equals 'WSICT'.
     */
    @isTest
    static void workOrdersUpdate2WhenSourceExtSystemTest(){

        String sourceExtSystem = 'WSIC';        

        WorkOrderLineItem woli=[SELECT ID FROM WorkOrderLineItem LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();        
        
        
        Test.startTest();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = woli.Id;
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        Plc_Reservation__c reservation = [SELECT Id FROM Plc_Reservation__c LIMIT 1];
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = reservation.Id;
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 19/03/2019
     * @version 1.0
     * @description Test of the method workOrdersUpdate
     */
    @isTest
    static void workOrdersUpdate2WhenResourceAliasMapTest(){

        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();

        Test.startTest();
        // resourceAliasMap not containsKey (workOrderLineItem.workOrderLineItemDetail.resourceAlias)
        Plc_ServiceWs.ServiceResponse response1 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        integer i = 0;
        for (Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : gestOrdReqBody.workOrderLineItem){
            workOrderLineItem.workOrderLineItemLegacyId = '366225' + i;
        }
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 21/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUpdate when GestioneOrdineRequestBody.
     */
    @isTest
    static void workOrdersUpdate2UpdateWorkOrderFullTest(){

        String sourceExtSystem = 'WSICT';
        WorkOrderLineItem woli=[SELECT Id FROM WorkOrderLineItem LIMIT 1];
        WorKOrder wo=[SELECT Id FROM WorKOrder LIMIT 1];
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLegacyId = wo.Id +'';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = ''+woli.Id;

        Test.startTest();        
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }

    @isTest
    static void workOrdersUpdate2FullExceptionHandleTest(){

        String sourceExtSystem = 'WSICT';
        String warehouAlias = 'WorkOrder';                
        WorkOrderLineItem woli = [SELECT Id FROM WorkOrderLineItem LIMIT 1];
        WorKOrder wo = [SELECT Id FROM WorKOrder LIMIT 1];

        //Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('123456789', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderDetail.warehouseAlias = warehouAlias;   

        Test.startTest();

        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        //workOrdersToUpdate empty
        gestOrdReqBody.workOrderLegacyId='';
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);


        //end date exc
        gestOrdReqBody.workOrderDetail.requestType='Installation';
        gestOrdReqBody.workOrderDetail.endDate='bad date';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, '');

        //Available quantity less 1
        List<Bit2Shop__Product_Stock__c> products = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c,Plc_AvailableQty__c FROM Bit2Shop__Product_Stock__c];
        for (Bit2Shop__Product_Stock__c product : products){
            product.Plc_WithdrawnQty__c = -10;
            product.Plc_UsableQty__c = -10;
        }

        update products;
        System.debug('==product quantity== ' +products[0].Plc_AvailableQty__c);

        gestOrdReqBody.workOrderDetail.endDate=''+System.now();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status='ToExecute';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId='123456789';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias='123456789';
        gestOrdReqBody.workOrderDetail.warehouseAlias='123456789';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, 'WSICT');

        for (Bit2Shop__Product_Stock__c product : products){
            product.Plc_WithdrawnQty__c = 25;
            product.Plc_UsableQty__c = 30;
        }
        update  products;

        System.debug('==product quantity== ' +products[0].Plc_AvailableQty__c);

        gestOrdReqBody.workOrderDetail.status='OnHold';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status='NotExecuted';
        Plc_ServiceWs.ServiceResponse response6 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, 'WSICT');

        //Generation date Exc
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = 'bad date';
        Plc_ServiceWs.ServiceResponse response7 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, 'WSICT');

        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 21/01/2019
     * @version 1.0
     * @description Test of the method workOrdersUpdate when GestioneOrdineRequestBody.
     */
    @isTest
    static void workOrdersUpdate2FullTest(){
        
        String sourceExtSystem = 'WSICT';
        WorkOrderLineItem woli=[SELECT Id FROM WorkOrderLineItem LIMIT 1];
        WorkOrder wo=[SELECT Id FROM WorkOrder LIMIT 1];
        Plc_Reservation__c rservation=[SELECT Id FROM Plc_Reservation__c LIMIT 1];
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();        
        gestOrdReqBody.workOrderLegacyId = wo.Id;        
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody1 = gestOrdReqBody;
        gestOrdReqBody1.workOrderDetail.warehouseAlias = '123456788';

        Test.startTest();
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = woli.Id;
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = rservation.Id;
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        Plc_ServiceWs.ServiceResponse response33 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody1, sourceExtSystem);
        
        gestOrdReqBody1.workOrderLineItem[0].workOrderLineItemDetail.reservationId = rservation.Id;
        Plc_ServiceWs.ServiceResponse response44 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody1, sourceExtSystem);
        
        // exception in startDate line 1212
        gestOrdReqBody.workOrderDetail.startDate = 'date';
        gestOrdReqBody.workOrderDetail.status = 'Canceled';
        Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        // trigg exception in generation date
        gestOrdReqBody.workOrderDetail.startDate = System.today() +'';
        gestOrdReqBody.workOrderDetail.status = 'Assigned';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = 'date';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        //productStockMap not contains containsKey workOrderLineItem.workOrderLineItemDetail.resourceAlias
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '69876';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        // workOrder.workOrderDetail.requestType is not valid line 1194
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';
        gestOrdReqBody.workOrderDetail.requestType = 'Test';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToSubstitute';
        Plc_ServiceWs.ServiceResponse response6 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        //workOrdersToUpdate is Empty and
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';
        gestOrdReqBody.workOrderLegacyId = '4553656';
        Plc_ServiceWs.ServiceResponse response7 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);

        //workOrdersToUpdate is not Empty
        gestOrdReqBody.workOrderLegacyId = '123456789';
        Map<String, WorkOrder> workOrdersToUpdate = Plc_WorkOrdersServices.retrieveWorkOrders(new Set<String>{gestOrdReqBody.workOrderLegacyId});
        System.debug('===workOrdersToUpdate is empty==== '+workOrdersToUpdate.isEmpty());
        Plc_ServiceWs.ServiceResponse response8 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, sourceExtSystem);
        
        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 04/04/2019
     * @version 1.0
     * @description full Test of the method workOrdersFullfilment When GestioneOrdineRequest
     */
    @isTest
    static  void workOrdersFullfilmentWhenGestioneOrdineRequestTest(){
        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequest gestioneOrdineRequest = new Plc_Wrappers.GestioneOrdineRequest();

        Test.startTest();
        Plc_WorkOrdersServices.workOrdersFullfilment(gestioneOrdineRequest, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 22/01/2019
     * @version 1.0
     * @description Test of the method workOrdersFullfilment when GestioneOrdineRequestBody.
     */
    @isTest
    static void workOrdersFullfilment2Test(){
        
        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '5569';
        gestOrdReqBody.workOrderLineItem[0].cause = cause;

        Test.startTest();
        //when workOrderLineItemMap containsKey workOrderLineItem.workOrderLineItemLegacyId
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '12345g1367';
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        // when workOrdersToUpdate is empty
        gestOrdReqBody.workOrderLegacyId = '1234567890';
        //gestOrdReqBody.serialNumber = '01235777';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '01235777';
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
                
        //
        gestOrdReqBody.workOrderLegacyId = '123456789';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '456321';
        Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
       
        // when productStockMap not contains resourceAlias or warehouseAlias
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '25663';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        //when end date is empty 
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '123456789';
        gestOrdReqBody.workOrderDetail.endDate ='';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        //when end date is not correct
        gestOrdReqBody.workOrderDetail.endDate = 'date';
        Plc_ServiceWs.ServiceResponse response6 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        // trigg exception in RecordType
        // workOrder.workOrderDetail.requestType is not valid
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today()+'';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToSubstitute';
        Plc_ServiceWs.ServiceResponse response7 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        gestOrdReqBody.workOrderLegacyId = '1234567890';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today()+'';
        gestOrdReqBody.workOrderDetail.requestType = 'Deactivation';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToDeactivate';
        Plc_ServiceWs.ServiceResponse response8 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 19/03/2019
     * @version 1.0
     * @description Test of the method workOrdersFullfilment.
     */
    @isTest
    static void workOrdersFullfilment2whenStockSerialMapInSystemTest(){

        String sourceExtSystem = 'WSICT';

        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '5569';
        gestOrdReqBody.workOrderLineItem[0].cause = cause;

        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '01235777';
        gestOrdReqBody.workOrderLegacyId = '123456789';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '456321';

        Bit2Shop__Dealer__c dealer = [SELECT Id FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = 'alias1' LIMIT 1];
        List<B2WExtCat__External_Catalog_Item__c> externalsCatalogItems = [SELECT Id, Plc_Manufacturer__c FROM B2WExtCat__External_Catalog_Item__c];

        for (B2WExtCat__External_Catalog_Item__c externalsCatalogItem : externalsCatalogItems ){
            externalsCatalogItem.Plc_Manufacturer__c = dealer.Id;
        }
        update externalsCatalogItems;

        String serial = gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber;
        String operationType = gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType;
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias1';
        Test.startTest();
        Plc_ServiceWs.ServiceResponse response1 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);


        List<Bit2Shop__Stock_Serials2__c> stockSerials = [SELECT Id, Plc_DllSerialNumberUnique__c, Plc_ManufacturerSerialNumber__c,
                Plc_DllSerialNumber__c,Plc_EncodedSerialNumber__c, Plc_EncodedSerialNumberUnique__c,
                Plc_ManufacturerSerialNumberUnique__c FROM  Bit2Shop__Stock_Serials2__c];

        integer i = 0;
        for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerials){
            stockSerial.Plc_DllSerialNumberUnique__c = 'dll' + i;
            stockSerial.Plc_EncodedSerialNumberUnique__c = 'enc'+ i;
            i++;
        }
        update  stockSerials;

        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = ' ';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType ='ToDeactivate';
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias1';
        //If the WorkOrderLineItem is Already Closed ( Executed ) SKIP THIS
        List<WorkOrderLineItem> workOrderLineItems = [SELECT Id, Plc_Alias__c, Plc_Closed__c FROM WorkOrderLineItem];
        for (WorkOrderLineItem workOrderLineItem : workOrderLineItems){
            workOrderLineItem.Plc_Closed__c = true;
        }
        update workOrderLineItems;

        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = serial;
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = operationType;
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = workOrderLineItems[0].Plc_Alias__c;
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        Test.stopTest();
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 19/03/2019
     * @version 1.0
     * @description Test of the method workOrdersFullfilment.
     */
    @isTest
    static void workOrdersfilment2whenStockSerialMapInSystemTest(){

        String sourceExtSystem = 'Monetica';

        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '5569';
        gestOrdReqBody.workOrderLineItem[0].cause = cause;
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias1';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '01235777';
        gestOrdReqBody.workOrderLegacyId = '123456789';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '456321';

        Bit2Shop__Dealer__c dealer = [SELECT Id FROM Bit2Shop__Dealer__c WHERE Plc_Alias__c = 'alias1' LIMIT 1];
        System.debug('###### ' + dealer);
        List<B2WExtCat__External_Catalog_Item__c> externalsCatalogItems = [SELECT Id, Plc_Manufacturer__c FROM B2WExtCat__External_Catalog_Item__c];

        for (B2WExtCat__External_Catalog_Item__c externalsCatalogItem : externalsCatalogItems ){
            externalsCatalogItem.Plc_Manufacturer__c = dealer.Id;
        }
        update externalsCatalogItems;

        String serial = gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber;
        String operationType = gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType;

        List<Bit2Shop__Stock_Serials2__c> stockSerials = [SELECT Id, Plc_DllSerialNumberUnique__c, Plc_ManufacturerSerialNumber__c,
                Plc_DllSerialNumber__c,Plc_EncodedSerialNumber__c, Plc_EncodedSerialNumberUnique__c,
                Plc_ManufacturerSerialNumberUnique__c FROM  Bit2Shop__Stock_Serials2__c];

        integer i = 0;
        for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerials){
            stockSerial.Plc_DllSerialNumberUnique__c = 'dll' + i;
            stockSerial.Plc_EncodedSerialNumberUnique__c = 'enc'+ i;
            i++;
        }
        update  stockSerials;

        Plc_WorkOrderConfiguration__c workOrderConfiguration = new Plc_WorkOrderConfiguration__c();
        workOrderConfiguration.Plc_IntegrationName__c= gestOrdReqBody.workOrderDetail.requestType.toUpperCase();
        workOrderConfiguration.Plc_EligibleOperationTypes__c= gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType.toUpperCase();
        workOrderConfiguration.Plc_NeedsCalculation__c=true;
        workOrderConfiguration.Plc_NeedsReservation__c=true;
        insert workOrderConfiguration;

        Plc_TermId__c termId = [SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c  LIMIT 1];
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = termId.Plc_TermIdCode__c;
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias1';
        Test.startTest();
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 22/01/2019
     * @version 1.0
     * @description Test of the method workOrdersFullfilment when GestioneOrdineRequestBody.
     */
    @isTest
    static void workOrdersFullfilment2WhenPlcAvailableQtyTest(){
        
        String sourceExtSystem = 'WSICT';

        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '5569';
        gestOrdReqBody.workOrderLineItem[0].cause = cause;

        // when Plc_AvailableQty__c < 0  // 676
        Bit2Shop__Product_Stock__c product = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        product.Plc_WithdrawnQty__c = -10;
        product.Plc_UsableQty__c = -10;
        update product;
        
        Test.startTest();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '456321';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '456321';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType='ToInstall';
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 23/01/2019
     * @version 1.0
     * @description Test of the method workOrdersFullfilment when GestioneOrdineRequestBody.
     * @laye
     */
    @isTest
    static void workOrdersFullfilment2WhenStatusTest(){
        
        String sourceExtSystem = 'WSICT';

        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '5569';
        gestOrdReqBody.workOrderLineItem[0].cause = cause;

        Test.startTest();
        // when status is different to 'Executed'
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '456321';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Status';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '456321'; 
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        // when status is 'Executed'
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Executed'; 
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        // when worKOrderToUpdate contains workOrderLineItemLegacyId
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '123456789';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '12345678f';
        Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        // trigg exception when generationDate isn't valid 
        gestOrdReqBody.workOrderDetail.endDate = System.today()+'';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = 'date';
        Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        //gestOrdReq.workOrder[0].workOrderLegacyId = '123456789';
        WorkOrderLineItem workOrderLineItem = [SELECT Id, Plc_Alias__c, Status FROM WorkOrderLineItem WHERE Plc_Alias__c = '123456789' LIMIT 1];
        workOrderLineItem.Status = 'Not Executed';
        update workOrderLineItem;
        
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType='ToInstall';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        // line 865 when workOrdersToUpdate isEmpty()
        gestOrdReqBody.workOrderLegacyId = 'xxxxx';
        Plc_ServiceWs.ServiceResponse response7 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        Account account01 = [SELECT Id FROM Account LIMIT 1];
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        WorkOrder workOrder4 = Plc_TestFactory.createWorkOrder('state', account01, contact, 'abi',
                'bankDescription', 'legacyAccountId', 'legacyAccount',
                'siaCode', 'legacyServicePointId', 'servicePoint',
                'cti', 'customerCare', 'fCode');
        workOrder4.Status = 'Closed';
        workOrder4.Plc_Alias__c = 'xxx0000123';
        workOrder4.RecordTypeId = Plc_Utils.getRecordTypeId('Installation', 'WorkOrder');
        insert workOrder4;

        // line 870 when Status is 'Closed'
        gestOrdReqBody.workOrderLegacyId = 'xxx0000123';
        Plc_ServiceWs.ServiceResponse response6 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 23/01/2019
     * @version 1.0
     * @description Test of the method workOrdersFullfilment when sourceExtSystem is not equals 'WSICT'.
     */
    @isTest
    static void workOrdersFullfilment2WhenSourceExtSystem(){
        
        String sourceExtSystem = 'WSIC';
        //Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = [SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c LIMIT 1].Id;

        Test.startTest();
        
        WorkOrderLineItem workOrderLineItem = [SELECT Id, Plc_Alias__c, Status FROM WorkOrderLineItem WHERE Plc_Alias__c = '123456789' LIMIT 1];
        workOrderLineItem.Status = 'Not Executed';
        update workOrderLineItem;
        
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '8966';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '456621';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Executed'; 
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        // when reservationId is instanceOf id reservationId
        Plc_Reservation__c reservation = [SELECT Id FROM Plc_Reservation__c LIMIT 1];
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId = reservation.Id;
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 23/01/2019
     * @version 1.0
     * @description Test of the method workOrdersFullfilment to give it a valid WorKOrder.
     */
    @isTest
    static void workOrdersFullfillement2UpdateTest(){
        
        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = [SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c LIMIT 1].Id;
        gestOrdReqBody.workOrderLineItem[0].cause = cause;

        Test.startTest();
        
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '456321';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Executed';
        gestOrdReqBody.workOrderDetail.Status = 'Assigned';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '01235777';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Executed';
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        Test.stopTest();
    }
    
    @isTest
    static void workOrdersFullfillement2UpdateTest2(){
        
        String sourceExtSystem = 'WSICT';
        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToInstall';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.generationDate = System.today() + '';
        //gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = [SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c LIMIT 1].Id;
        gestOrdReqBody.workOrderLineItem[0].cause = cause;


        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId='123456789';

        Test.startTest();


        //workOrdersToUpdate is empty
        gestOrdReqBody.workOrderLegacyId='123456789';  
        Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        //Line 2038-2049
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber= '123456';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias='0000';
        Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        //resourceAliasObjectMap does not containsKey resourceAlias Line 2060
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias='123456789';
        Plc_ServiceWs.ServiceResponse response6 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

        //2025 is Blank
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias=' ';
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);


        /*
        workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Closed__c==true 
        || workOrderLineItem.workOrderLineItemDetail.status=='ToExecute' 
        || workOrderLineItem.workOrderLineItemDetail.status=='NoOperation'
        */

        Test.stopTest();

    }

    /**Added by Shahid 13/2/2019**/
    @isTest
    static void retrieveReservationToExecuteTest(){
      
      Test.startTest();
      
       Set<String>reservationAlias = new Set<String>();
       reservationAlias.add('123456789');
       Plc_WorkOrdersServices.retrieveReservationToExecute(reservationAlias);
       Plc_WorkOrdersServices.retrieveWorkOrdersLineItemToExecute();
        
        
       Set<String>serialalias= new Set<String>();
       serialalias.add('125874965');
           
    }

    @isTest
    static void operationTypeToRemoveTest(){
        
        String sourceExtSystem = 'WSICT';        

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody(); 
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '123456789';
        //gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId= 'fda43ds';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = 'value1';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias= '4565165';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = [SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c LIMIT 1].Id;
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Executed';

        Test.startTest();
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        Test.stopTest();
    
    }
    
    @isTest
    static void operationTypeToSubstituteTest(){
        
        Test.startTest();
        String sourceExtSystem = 'WSICT';
        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();         
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '343244';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.reservationId= '';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = 'value1';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias= '4565165'; 
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = [SELECT Id FROM Plc_TermId__c LIMIT 1].Id;
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Executed';
        
        Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        system.debug('==tempidd=='+[SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c]);
        Test.stopTest();
    
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 19/03/2019
     * @version 1.0
     * @description Test of the method retrieveStockSerials.
     */
     /*
    @isTest
    static  void retrieveStockSerialsTest(){
        Set<String> serialNumbers;
        serialNumbers.add('num1');

        Set<String> serialNumbersLike;
        serialNumbersLike.add('num2');

        Set<String> serialNumbersLikeFull;
        serialNumbersLikeFull.add('num3');

        String warehouse ='warehouse';
        String sourceExtSystem = 'WSICT';
        Map<String,String> serialNumbersUniqueToSingle = new Map<String,String>();
        Map<String,String> stockSerial2Warehouse = new Map<String,String>();
        //serialNumbers.add('');

        List<Bit2Shop__Stock_Serials2__c> stockSerials = [SELECT Id, Plc_DllSerialNumberUnique__c, Plc_ManufacturerSerialNumber__c,
                Plc_DllSerialNumber__c,Plc_EncodedSerialNumber__c, Plc_EncodedSerialNumberUnique__c,
                Plc_ManufacturerSerialNumberUnique__c FROM  Bit2Shop__Stock_Serials2__c];

        integer i = 0;
        for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerials){
            stockSerial.Plc_DllSerialNumberUnique__c = 'dll' + i;
            stockSerial.Plc_EncodedSerialNumberUnique__c = 'enc'+ i;
            i++;
        }

        //update  stockSerials;
        System.debug('JSJK#');
        Test.startTest();
        Plc_WorkOrdersServices.retrieveStockSerials(2,serialNumbers,serialNumbersLike,serialNumbersLikeFull, sourceExtSystem, serialNumbersUniqueToSingle,stockSerial2Warehouse,warehouse);
        Test.stopTest();
    }
    */

     /**
     * @author Abdoulaye DIOP
     * @date Modification 08/04/2019
     * @version 1.0
     * @description Test of the method workOrdersFullFilmentFull.
     */
    @isTest
    static void workOrdersFullFilmentFullTest(){
        WorkOrderLineItem woli=[SELECT ID FROM WorkOrderLineItem WHERE Plc_Alias__c='201903291147_1'];

        System.debug('QUERYRW: FINAL WO '+[SELECT Id,Status,Plc_Alias__c FROM WorkOrder]);
        System.debug('QUERYRW: FINAL WOLI '+[SELECT Id,Status,Plc_Alias__c FROM WorkOrderLineItem]);
        String sourceExtSystem = 'WSICT';

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('165923');
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToRemove';

        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = 
            Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('201903291147_1', cause, gestOrdReqBodyDetRiga);

        //workOrderLineItem
        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);

        // workOrderDetail
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd = 
            Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('WH0001','Uninstallation','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName', 'Executed', System.today() + '', System.today() + 3+'', 'cti','Ageing',
                                                                                'ctiType','alias1','province','1797921', '737839','4792971', 'shopLegacyId','signboard', 
                                                                                'post','locality','prefix','778197878','ghwd@wsq','0033', System.now().getTime() + '','referent', 'notes');

        
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('201903291147', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToRemove';

        gestOrdReqBody.workOrderDetail.warehouseAlias='WH0001';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.status = 'Executed';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemLegacyId = '201903291147_1';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias='165923';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber=null;
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId='123456789';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias1';
        Bit2Shop__Product_Stock__c product9 = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c LIMIT 1];
        product9.Plc_WithdrawnQty__c = 0;
        product9.Plc_UsableQty__c = 100;
        update product9;
        
        woli.Plc_Closed__c=false;
        woli.Status= 'ToExecute';
        update woli;

        Test.startTest();
            Plc_ServiceWs.ServiceResponse response1 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

            // line 1017
            gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = 'xxxx123';
            gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToDeactivate';
            Plc_ServiceWs.ServiceResponse response2 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

            // 1254
            gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = ' ';
            Plc_ServiceWs.ServiceResponse response3 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);

            // trigg exception in end date
            gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = 'xxxx123';
            gestOrdReqBody.workOrderDetail.endDate = 'endDate';
            Plc_ServiceWs.ServiceResponse response4 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        	
        	WorkOrder woWo = [SELECT Id,Status,Plc_Alias__c FROM WorkOrder WHERE Plc_Alias__c='201903291147'];
        	wowo.Status='Assigned';
        	update wowo;
            woli.Plc_Closed__c=false;
            woli.Status= 'ToExecute';
            update woli;
        	
        
        	gestOrdReqBody.workOrderDetail.status = 'Executed';
        	gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber = '2019051009351234569';
        	gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = '165920';
            gestOrdReqBody.workOrderDetail.endDate = 'endDate';
        	gestOrdReqBody.workOrderDetail.warehouseAlias = 'WH001';
            Plc_ServiceWs.ServiceResponse response5 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
        
        Test.stopTest();
        System.debug('AFTER RESPONSE:!');
    }

    /**
     * @author Abdoulaye DIOP
     * @date Creation 10/04/2019
     * @version 1.0
     * @description Test of the method workOrdersFullFilmentFull when to substitute.
     */
    @isTest
    static void workOrdersFullFilmentFullWhenToSubstituteTest(){
        String sourceExtSystem = 'MONETICA';
        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody();        
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.operationType = 'ToSubstitute';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.serialNumber= 'xxx-x';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias = 'xxx-x';
        gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.termId = '123456789';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias1';

        Account account = [SELECT Id FROM Account LIMIT 1];
        Bit2Shop__Dealer__c dealer = Plc_TestFactory.createDealer('name',  account,  'xxx-x');
        dealer.Plc_DealerManufacturer__c = true;
        insert dealer;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = [SELECT Id FROM B2WExtCat__External_Catalog__c LIMIT 1];

        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Catalog Item', b2WExtCatExtCatalog, '123456789', 'Process');                                                                                               
        b2wExtCatExtCat.Plc_Alias__c = 'xxx-x';
        b2wExtCatExtCat.Plc_Category__c = 'Product';
        b2wExtCatExtCat.Plc_Subcategory__c = 'SIM';
        b2wExtCatExtCat.Plc_ProductSku__c = gestOrdReqBody.workOrderLineItem[0].workOrderLineItemDetail.resourceAlias;
        b2wExtCatExtCat.Plc_Manufacturer__c = dealer.Id;
        insert b2wExtCatExtCat;

        /*List<Bit2Shop__Stock_Serials2__c> stockSerials = [SELECT Id,  Plc_DllSerialNumberUnique__c FROM Bit2Shop__Stock_Serials2__c];
        for (Bit2Shop__Stock_Serials2__c stockSerial :  stockSerials) {
            stockSerial.Plc_DllSerialNumberUnique__c = 'xxx-x';
        } 
        update stockSerials;*/

        Bit2Shop__Warehouse__c warehouse01 = [SELECT Id FROM Bit2Shop__Warehouse__c LIMIT 1];

        Bit2Shop__Product_Stock__c bit2ShopProductStock = [SELECT Id FROM Bit2Shop__Product_Stock__c LIMIT 1];

        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2 = Plc_TestFactory.createStockSerial2(warehouse01,  'Withdrawn');
        bnit2ShopStockSerials2.Plc_ManufacturerSerialNumber__c = 'xxx-x';
        bnit2ShopStockSerials2.Plc_EncodedSerialNumber__c = 'xxx-x';
        bnit2ShopStockSerials2.Plc_Property__c='N';
        bnit2ShopStockSerials2.Plc_DllSerialNumber__c='xxx-x';
        bnit2ShopStockSerials2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock.Id ;
        bnit2ShopStockSerials2.Plc_DllSerialNumberUnique__c = 'xxx-x';

        insert bnit2ShopStockSerials2;
        
        Test.startTest();            
            // line 1017
            Plc_ServiceWs.ServiceResponse response = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, sourceExtSystem);
            System.debug('### outcomeMessage '+ response.outcomeMessage);
        Test.stopTest();
    }
    @isTest
    static void retrieveStockSerials(){
        Map<String,String> stockSerial2Warehouse = new Map<String,String>();
        List<String> warehouseAlias = new List<String>();
        Map<String,String> serialNumbersUniqueToSingle = new Map<String,String>();
        String sourceExtSystem = 'WSICT';
        Integer typeOfSearch;
        Set<String> stockSerialIdSetOnTime = new Set<String>();
        Set<String> simToSearchInEncoded = new Set<String>();
        Set<String> simToSearchInOther = new Set<String>();
        warehouseAlias.add('WH0001');
        stockSerialIdSetOnTime.add('alias1_2019051009351234567');
        simToSearchInEncoded.add('alias1_2019051009351234567');
        simToSearchInOther.add('alias1_2019051009351234567');
        
        stockSerialIdSetOnTime.add('alias1_2019051009351234568');
        simToSearchInEncoded.add('alias1_2019051009351234568');
        simToSearchInOther.add('alias1_2019051009351234568');
        
        stockSerialIdSetOnTime.add('alias1_2019051009351234569');
        simToSearchInEncoded.add('alias1_2019051009351234569');
        simToSearchInOther.add('alias1_2019051009351234569');
        
        stockSerialIdSetOnTime.add('alias1_2019051009351234561');
        simToSearchInEncoded.add('alias1_2019051009351234561');
        simToSearchInOther.add('alias1_2019051009351234561');
        
        //
        stockSerialIdSetOnTime.add('impossibletoFind');
        simToSearchInEncoded.add('impossibleToFind');
        simToSearchInOther.add('impossibleToFind');

        Map<String, Bit2Shop__Stock_Serials2__c> result;
       	typeOfSearch = 1;
        result = Plc_WorkOrdersServices.retrieveStockSerials(typeOfSearch,stockSerialIdSetOnTime,simToSearchInEncoded,simToSearchInOther,sourceExtSystem,serialNumbersUniqueToSingle,stockSerial2Warehouse,warehouseAlias,false);
    	typeOfSearch = 2;
        result = Plc_WorkOrdersServices.retrieveStockSerials(typeOfSearch,stockSerialIdSetOnTime,simToSearchInEncoded,simToSearchInOther,sourceExtSystem,serialNumbersUniqueToSingle,stockSerial2Warehouse,warehouseAlias,false);
    	typeOfSearch = 3;
        result = Plc_WorkOrdersServices.retrieveStockSerials(typeOfSearch,stockSerialIdSetOnTime,simToSearchInEncoded,simToSearchInOther,sourceExtSystem,serialNumbersUniqueToSingle,stockSerial2Warehouse,warehouseAlias,false);
        result = Plc_WorkOrdersServices.retrieveStockSerials(typeOfSearch,stockSerialIdSetOnTime,simToSearchInEncoded,simToSearchInOther,sourceExtSystem,serialNumbersUniqueToSingle,stockSerial2Warehouse,warehouseAlias,true);
    	
    }
    @isTest
    static void fulfillmentCorrect(){
        Test.startTest();
        Account account01 = Plc_TestFactory.createAccountSupplier('02');
        insert account01;
        
        Bit2Shop__Dealer__c dealerParent01 = Plc_TestFactory.createDealerParent('001', account01,'alias10');
        dealerParent01.Plc_Repairer__c = true;
        dealerParent01.Plc_DealerManufacturer__c = true;
        insert dealerParent01;

        Bit2Shop__Dealer__c dealerChild01 = Plc_TestFactory.createDealerChild('001', account01,'alias20', dealerParent01);
        dealerChild01.Bit2Shop__Parent_Dealer__c= dealerParent01.Id;
        insert dealerChild01;

        Bit2Shop__Warehouse__c warehouse01 = Plc_TestFactory.createWarehouse('001', 'Irrecoverable', 'Nexi', '999010NEXI', dealerChild01);
        insert warehouse01;
        
        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat1Name');
        insert b2WExtCatExtCatalog;
        
        //--Solution-- //   
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('solution1');
        insert plcSolution;
        //--Solution-- //   
		
		//--External Catalog Item-- //        
        B2WExtCat__External_Catalog_Item__c POS1 = Plc_TestFactory.createExtCatalogItem('Catalog1Item', b2WExtCatExtCatalog, 'POS1', 'Process');
        POS1.Plc_Category__c='Product';
        POS1.Plc_Alias__c = 'POS1';
        POS1.Plc_Solution__c = plcSolution.Id;
        POS1.Plc_Manufacturer__c=dealerParent01.id;
        POS1.Plc_Subcategory__c='POS';
        insert POS1;
        
        B2WExtCat__External_Catalog_Item__c POS2 = Plc_TestFactory.createExtCatalogItem('Catalog2Item', b2WExtCatExtCatalog, 'POS2', 'Process');
        POS2.Plc_Category__c='Product';
        POS2.Plc_Alias__c = 'POS2';
        POS2.Plc_Solution__c = plcSolution.Id;
        POS2.Plc_Manufacturer__c=dealerParent01.id;
        POS2.Plc_Subcategory__c='POS';
        insert POS2;
        //--External Catalog Item-- //
        
        //--Product Stock-- //
		Bit2Shop__Product_Stock__c bit2ShopProductStock4 = Plc_TestFactory.createProductStock(POS1, warehouse01);
        bit2ShopProductStock4.Bit2Shop__Warehouse_Id__c = warehouse01.Id;
        bit2ShopProductStock4.Plc_UniqueKey__c = System.now() +'3';
        bit2ShopProductStock4.Plc_UsableQty__c = 100;
        bit2ShopProductStock4.Plc_WithdrawnQty__c = 0;
        bit2ShopProductStock4.Bit2Shop__External_Catalog_Item_Id__c=POS1.id;
		insert bit2ShopProductStock4;
        
        Bit2Shop__Product_Stock__c bit2ShopProductStock5 = Plc_TestFactory.createProductStock(POS2, warehouse01);
        bit2ShopProductStock5.Bit2Shop__Warehouse_Id__c = warehouse01.Id;
        bit2ShopProductStock5.Plc_UniqueKey__c = System.now() +'3';
        bit2ShopProductStock5.Plc_UsableQty__c = 100;
        bit2ShopProductStock5.Plc_WithdrawnQty__c = 0;
        bit2ShopProductStock5.Bit2Shop__External_Catalog_Item_Id__c=POS2.id;
		insert bit2ShopProductStock5;
        //--Product Stock-- //
        
        //--SerialNumber--//
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2_2 = Plc_TestFactory.createStockSerial2(warehouse01,  'Available');
        bnit2ShopStockSerials2_2.Plc_ManufacturerSerialNumber__c = '1234567891234567891';
        bnit2ShopStockSerials2_2.Plc_EncodedSerialNumber__c = '1234567891234567891';
        bnit2ShopStockSerials2_2.Plc_DllSerialNumber__c='1234567891234567891';
        bnit2ShopStockSerials2_2.Plc_Property__c='N';
        bnit2ShopStockSerials2_2.Bit2Shop__Status__c='Available';
        bnit2ShopStockSerials2_2.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock4.Id ;
        bnit2ShopStockSerials2_2.Bit2Shop__Warehouse_Id__c = warehouse01.id;
        insert bnit2ShopStockSerials2_2;
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2_3 = Plc_TestFactory.createStockSerial2(warehouse01,  'Available');
        bnit2ShopStockSerials2_3.Plc_ManufacturerSerialNumber__c = '1234567891234567892';
        bnit2ShopStockSerials2_3.Plc_EncodedSerialNumber__c = '1234567891234567892';
        bnit2ShopStockSerials2_3.Plc_DllSerialNumber__c='1234567891234567892';
        bnit2ShopStockSerials2_3.Plc_Property__c='N';
        bnit2ShopStockSerials2_3.Bit2Shop__Status__c='Available';
        bnit2ShopStockSerials2_3.Bit2Shop__Product_Stock_Id__c = bit2ShopProductStock5.Id ;
        bnit2ShopStockSerials2_3.Bit2Shop__Warehouse_Id__c = warehouse01.id;
        insert bnit2ShopStockSerials2_3;
        
        //--SerialNumber--//
        
        //--WorkOrderLineItemPayload--//
        
        Plc_Wrappers.GestioneOrdineRequestBodyCausale cause = Plc_WsTestFactory.createGestioneOrdineRequestBodyCausale('blockCode',  'blockDescription');

        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioRiga gestOrdReqBodyDetRiga = Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioRiga('null');
        

        Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro gestOrdReqBodyRigOrdLavoro = Plc_WsTestFactory.createGestioneOrdineRequestBodyRigheOrdineDiLavoro('-------', cause, gestOrdReqBodyDetRiga);

        List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro> gestOrdReqBodyRigOrdLavs = new List<Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro>();
        gestOrdReqBodyRigOrdLavs.add(gestOrdReqBodyRigOrdLavoro);
        
       	//--WorkOrderLineItemPayload--//
       	
       	//--Work Order Payload--//
        Plc_Wrappers.GestioneOrdineRequestBodyDettaglioOrdine gestOrdReqDetOrd = 
            Plc_WsTestFactory.createGestioneOrdineRequestBodyDettaglioOrdine('-----','----','abi',  'accountLegacyId',  'address',  'bankDescription',
                                                                                'businessName', 'Assigned', '', '', 'cti','Ageing',
                                                                                'ctiType','alias1','province','1797921', '737839','4792971', 'shopLegacyId','signboard', 
                                                                                'post','locality','prefix','778197878','ghwd@wsq','0033', System.now().getTime() + '','referent', 'notes');

        Plc_Wrappers.GestioneOrdineRequestBody gestOrdReqBody = Plc_WsTestFactory.createGestioneOrdineRequestBody('------', gestOrdReqDetOrd, gestOrdReqBodyRigOrdLavs);
        
        
        //--Work Order Payload--//
        //Creazione Reservation
        Plc_Reservation__c reservation1 = new Plc_Reservation__c();
        reservation1.Plc_ProductStock__c=bit2ShopProductStock4.id;
        reservation1.Plc_Status__c='Reserved';
        insert reservation1;
        //
        //-Creazione Installazione-//
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='201906260942_1';
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';
		gestOrdReqBodyDetRiga.status='ToExecute';
        gestOrdReqBodyDetRiga.serialNumber='1234567891234567891';
        gestOrdReqBodyDetRiga.termId='TID201906260942';
        gestOrdReqBodyDetRiga.resourceAlias='POS1';
        gestOrdReqBodyDetRiga.reservationId=reservation1.id;
        
        gestOrdReqBody.workOrderLegacyId = '201906260942';
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderDetail.status='Assigned';
        
        Plc_ServiceWs.ServiceResponse creazione1 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, 'MONETICA');
        //-Creazione Installazione-//
        
        //Aggiornamento Ordine//
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='201906260942_1';
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';
		gestOrdReqBodyDetRiga.status='NotExecuted';
        gestOrdReqBodyDetRiga.serialNumber='1234567891234567891';
        gestOrdReqBodyDetRiga.termId='TID201906260942';
        gestOrdReqBodyDetRiga.resourceAlias='POS1';
        gestOrdReqBodyDetRiga.reservationId=reservation1.id;
        
        gestOrdReqBody.workOrderLegacyId = '201906260942';
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderDetail.status='OnHold';
        
        Plc_ServiceWs.ServiceResponse update2 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, 'MONETICA');
        //Aggiornamento Ordine//
        
        //////Aggiornamento Ordine//
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='201906260942_1';
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';
		gestOrdReqBodyDetRiga.status='ToExecute';
        gestOrdReqBodyDetRiga.serialNumber='1234567891234567891';
        gestOrdReqBodyDetRiga.termId='TID201906260942';
        gestOrdReqBodyDetRiga.resourceAlias='POS2';
        gestOrdReqBodyDetRiga.reservationId=reservation1.id;
        
        gestOrdReqBody.workOrderLegacyId = '201906260942';
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderDetail.status='Assigned';
        
        Plc_ServiceWs.ServiceResponse update3 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, 'MONETICA');
        //Aggiornamento Ordine//
        
        //Aggiornamento Ordine//
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='201906260942_1';
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';
		gestOrdReqBodyDetRiga.status='ToExecute';
        gestOrdReqBodyDetRiga.serialNumber='1234567891234567891';
        gestOrdReqBodyDetRiga.termId='TID201906260942';
        gestOrdReqBodyDetRiga.resourceAlias='POS1';
        gestOrdReqBodyDetRiga.reservationId=reservation1.id;
        
        gestOrdReqBody.workOrderLegacyId = '201906260942';
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderDetail.status='Assigned';
        
        Plc_ServiceWs.ServiceResponse update4 = Plc_WorkOrdersServices.workOrdersUpdate(gestOrdReqBody, 'MONETICA');
        //Aggiornamento Ordine//
        
        //-Evasione Installazione-//
		gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';
		gestOrdReqBodyDetRiga.status='Executed';
        gestOrdReqBodyDetRiga.serialNumber='1234567891234567892';
        gestOrdReqBodyDetRiga.termId='TID201906260942';
        gestOrdReqBodyDetRiga.resourceAlias='POS2';
        gestOrdReqBodyDetRiga.reservationId=reservation1.id;
        
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderDetail.status='Closed';
        
        Plc_ServiceWs.ServiceResponse evasione1 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, 'MONETICA');
        //-Evasione Installazione-//
        
               
        //-Creazione Disattivazione-//
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='201906261020_1';
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToDeactivate';
		gestOrdReqBodyDetRiga.status='ToExecute';
        gestOrdReqBodyDetRiga.serialNumber='2019260609451234567';
        gestOrdReqBodyDetRiga.termId='123456789';
        gestOrdReqBodyDetRiga.resourceAlias='POS1';
        
        gestOrdReqBody.workOrderLegacyId = '201906261020';
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Deactivation';
        gestOrdReqBody.workOrderDetail.status='Assigned';
        Plc_ServiceWs.ServiceResponse creazione2 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, 'WSICT');
        //-Creazione Disattivazione-//
        
        //-Evasione Disattivazione-//
		gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToDeactivate';
		gestOrdReqBodyDetRiga.status='Executed';
        gestOrdReqBodyDetRiga.serialNumber='2019260609451234567';
        gestOrdReqBodyDetRiga.termId='123456789';
        gestOrdReqBodyDetRiga.resourceAlias='POS1';
        
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Deactivation';
        gestOrdReqBody.workOrderDetail.status='Closed';
        
        Plc_ServiceWs.ServiceResponse evasione2 = Plc_WorkOrdersServices.workOrdersFullfilment(gestOrdReqBody, 'WSICT');
        //-Evasione Disattivazione-//
        
        //-Creazione NoOperation-//
        gestOrdReqBodyRigOrdLavoro.workOrderLineItemLegacyId='201906261714_1';
        gestOrdReqBodyDetRiga.generationDate = System.today() + '';
        gestOrdReqBodyDetRiga.operationType = 'ToInstall';
		gestOrdReqBodyDetRiga.status='ToExecute';
        gestOrdReqBodyDetRiga.serialNumber='2019260609451234567';
        gestOrdReqBodyDetRiga.termId='123456789';
        gestOrdReqBodyDetRiga.resourceAlias='POS1';
        
        gestOrdReqBody.workOrderLegacyId = '201906261714';
        gestOrdReqBody.workOrderDetail.warehouseAlias='999010NEXI';
        gestOrdReqBody.workOrderDetail.dealerAlias = 'alias10';
        gestOrdReqBody.workOrderDetail.requestType = 'Installation';
        gestOrdReqBody.workOrderDetail.status='Assigned';
        Plc_ServiceWs.ServiceResponse creazione3 = Plc_WorkOrdersServices.workOrdersCreate(gestOrdReqBody, 'WSICT');
        //-Creazione NoOperation-//
        
        Test.stopTest();
    }
    @isTest
    static void checkValidity(){
        
        Plc_WorkOrdersServices.checkValidityWorkOrder('1234567891234567891',true);
                Plc_WorkOrdersServices.checkValidityWorkOrder('12345678912345678922',true);

                Plc_WorkOrdersServices.checkValidityWorkOrder('123456789123456789333',true);

                Plc_WorkOrdersServices.checkValidityWorkOrder('1234567891234567894444',true);

    }
    
    
}