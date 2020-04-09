/**
 * PLC Test Factory to create object for test classes
 *
 * @author Emanuele Campese
 * @version 1.0
 * @description Used to create object for test classes
 * @testedIn Plc_TestFactoryTest
 * @errorcode [ERR:CL-000YYZZ]
 * @history
 * 2019/02/06 Emanuele Campese
 */
public class Plc_TestFactory {

    /**
     * create Account
     * @param  suffix account suffix
     * @return        Account
     */
    public static Account createAccountSupplier(String suffix) {

        Account account = new Account(
            Name = 'testAccount' + suffix,
            RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.Account.RecordType_PlcSupplier, 'Account')
        );

        return account;
    }

    /**
     * create Contact
     * @param  suffix contact suffix
     * @return        Contact
     */
    public static Contact createContactGeneric(String suffix) {

        Contact contact = new Contact(
            LastName = 'testContact' + suffix,
            RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.Contact.RecordType_PlcReferenteGenerico, 'Contact')
        );

        return contact;
    }

    /**
     * Creates dealer
     *
     * @author FB
     * 
     * @param  name           Dealer Name
     * @param  account        Dealer Account
     * @param  alias          Dealer Alias
     * @param  recordTypeName Record Type developer name
     * @return                A Bit2Shop__Dealer__c instance
     */
    public static Bit2Shop__Dealer__c createDealer(String name, Account account, String alias) {

        Bit2Shop__Dealer__c dealer = new Bit2Shop__Dealer__c();
        dealer.Name = name;
        dealer.Bit2Shop__Account_Id__c = account.Id;
        dealer.Plc_Alias__c = alias;
        return dealer;
    }

    /**
     * Creates parent dealer
     *
     * @author FB
     * 
     * @param  name    Dealer Name
     * @param  account Dealer Account
     * @param  alias   Dealer Alias
     * @return         A Bit2Shop__Dealer__c instance
     */
    public static Bit2Shop__Dealer__c createDealerParent(String name, Account account, String alias) {

        Bit2Shop__Dealer__c dealer = createDealer(name, account, alias);
        dealer.RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_Dealer.RecordType_PlcParentDealer, Bit2Shop__Dealer__c.SObjectType.getDescribe().name);
        return dealer;
    }
    
    /**
     * Creates child dealer
     *
     * @author FB
     * 
     * @param  name    Dealer Name
     * @param  account Dealer Account
     * @param  alias   Dealer Alias
     * @return         A Bit2Shop__Dealer__c instance
     */
    public static Bit2Shop__Dealer__c createDealerChild(String name, Account account, String alias, Bit2Shop__Dealer__c dealerParent) {

        Bit2Shop__Dealer__c dealer = createDealer(name, account, alias);
        dealer.RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_Dealer.RecordType_PlcChildDealer, Bit2Shop__Dealer__c.SObjectType.getDescribe().name);
        return dealer;
    }
    
    /**
     * Creates warehouse
     *
     * @author FB
     * 
     * @param  name             Warehouse name
     * @param  tipology         Warehouse tipology  
     * @param  logisticDivision Warehouse logistic division 
     * @param  alias            Warehouse alias  
     * @param  dealerChild      Warehouse dealer
     * @return                  A Bit2Shop__Warehouse__c instance
     */
    public static Bit2Shop__Warehouse__c createWarehouse(String name, String tipology, String logisticDivision, 
                                                         String alias, Bit2Shop__Dealer__c dealerChild) {

        Bit2Shop__Warehouse__c warehouse = new Bit2Shop__Warehouse__c();
        warehouse.Name = name;
        warehouse.Plc_Tipology__c = tipology;
        warehouse.Bit2Shop__Dealer_Id__c = dealerChild.Id;
        warehouse.Plc_Alias__c = alias;
        warehouse.Plc_LogisticDivision__c = logisticDivision;

        return warehouse;
    }

    /**
     * Creates stock serial 2
     *
     * @author FB
     * 
     * @param  warehouse    Stock serial 2 warehouse
     * @param  status       Stock serial 2 status
     * @return              A Bit2Shop__Stock_Serials2__c instance
     */
    public static Bit2Shop__Stock_Serials2__c createStockSerial2(Bit2Shop__Warehouse__c warehouse, String status) {

        Bit2Shop__Stock_Serials2__c stockSerial = new Bit2Shop__Stock_Serials2__c();
        stockSerial.Bit2Shop__Warehouse_Id__c = warehouse.Id;
        stockSerial.Bit2Shop__Status__c = status;

        return stockSerial;
    }

    /**
     * Creates solution
     *
     * @author EC
     * 
     * @param  alias Solution alias
     * @return       A Plc_Solution__c instance         
     */
    public static  Plc_Solution__c createSolution(String alias) {

        Plc_Solution__c solution = new Plc_Solution__c();
        solution.plc_Alias__c = alias;

        return solution;
    }


    /**
     * Creates a fixed number solutions 
     *
     * @author FB
     * 
     * @param  numOfSolutions Number of solutions to create
     * @return                A list of Plc_Solution__c instances
     */
    public static List<Plc_Solution__c> createSolutions(Integer numOfSolutions) {

        List<Plc_Solution__c> solutionsList = new List<Plc_Solution__c>();

        for (Integer i = 0; i < numOfSolutions; i++) {
            solutionsList.add(createSolution('Alias' + i));
        }

        return solutionsList;
    }

    /**
     * Creates external catalog
     *
     * @author FB
     * 
     * @param  name External catalog name
     * @return      A B2WExtCat__External_Catalog__c instance
     */
    public static B2WExtCat__External_Catalog__c createExtCatalog(String name) {

        B2WExtCat__External_Catalog__c extCatalog = new B2WExtCat__External_Catalog__c();
        extCatalog.B2WExtCat__External_Catalog_Name__c = name;
        return extCatalog;
    }

    /**
     * Creates external catalog item
     *
     * @author FB
     * 
     * @param  name       External catalog item name
     * @param  extCatalog External catalog item extCatalog
     * @param  productSku External catalog item productSku
     * @param  type       External catalog item type
     * @return            A B2WExtCat__External_Catalog_Item__c instance
     */
    public static B2WExtCat__External_Catalog_Item__c createExtCatalogItem(String name, B2WExtCat__External_Catalog__c extCatalog,
                                                                           String productSku, String type) {

        B2WExtCat__External_Catalog_Item__c extCatalogItem = new B2WExtCat__External_Catalog_Item__c();
        extCatalogItem.B2WExtCat__External_Catalog_Item_Name__c = name;
        extCatalogItem.B2WExtCat__External_Catalog__c = extCatalog.Id;
        extCatalogItem.Plc_ProductSku__c = productSku;
        extCatalogItem.B2WExtCat__Type__c = type;

        return extCatalogItem;
    }
    
    /**
     * Creates termId
     *
     * @author FB
     * 
     * @param  termIdCode TermId code
     * @return            A Plc_TermId__c instance
     */
    public static Plc_TermId__c createTermId(String termIdCode) {

        Plc_TermId__c termId = new Plc_TermId__c();
        termId.Plc_TermIdCode__c = termIdCode;

        return termId;
    }

    /**
     * Creates warehouse solution
     *
     * @author Luca Belometti
     * 
     * @param  name      Warehouse solution name
     * @param  solution  Warehouse solution sol.
     * @param  warehouse Warehouse solution warehouse
     * @return           A Plc_WarehouseSolution__c instance
     */
    public static Plc_WarehouseSolution__c createWarehouseSolution(String name, Plc_Solution__c solution, 
                                                                   Bit2Shop__Warehouse__c warehouse) {
        
        Plc_WarehouseSolution__c warehouseSolution = new Plc_WarehouseSolution__c();
        warehouseSolution.Name = name;
        warehouseSolution.Plc_Solution__c = solution.Id;
        warehouseSolution.Plc_Warehouse__c = warehouse.Id;

        return warehouseSolution;

    }

    /**
     * Creates product stock
     *
     * @author FB
     * 
     * @param  extCatalogItem Product Stock external catalog item
     * @param  warehouse      Product Stock warehouse
     * @return                A Bit2Shop__Product_Stock__c instance
     */
    public static Bit2Shop__Product_Stock__c createProductStock(B2WExtCat__External_Catalog_Item__c extCatalogItem,
                                                                Bit2Shop__Warehouse__c warehouse) {

       Bit2Shop__Product_Stock__c productStock = new Bit2Shop__Product_Stock__c();
       productStock.Bit2Shop__External_Catalog_Item_Id__c = extCatalogItem.Id;
       productStock.Bit2Shop__Warehouse_Id__c = warehouse.Id;

       return productStock;
   }

    /**
     * Creates work order
     *
     * @author FB
     * 
     * @param  account Work Order account
     * @param  contact Work Order contact
     * @return         Work Order fiscal code
     */
    
    /**
     * Creates work order
     *
     * @author FB
     * 
     * @param  state                Work Order state
     * @param  account              Work Order account
     * @param  contact              Work Order contact
     * @param  abi                  Work Order abi
     * @param  bankDescription      Work Order bank description
     * @param  legacyAccountId      Work Order legacy account id
     * @param  legacyAccount        Work Order legacy account
     * @param  siaCode              Work Order sia code
     * @param  legacyServicePointId Work Order service point id
     * @param  servicePoint         Work Order service point
     * @param  cti                  Work Order cti
     * @param  customerCare         Work Order customer care
     * @param  fiscalCode           Work Order fiscal code
     * @return                      A WorkOrder instance
     */
    public static WorkOrder createWorkOrder(String state, Account account, Contact contact, String abi,
                                            String bankDescription, String legacyAccountId, String legacyAccount,
                                            String siaCode, String legacyServicePointId, String servicePoint,
                                            String cti, String customerCare, String fiscalCode) {

        WorkOrder workOrder = new WorkOrder();
        workOrder.State = state;
        workOrder.AccountId = account.Id;
        workOrder.ContactId = contact.Id;
        workOrder.Plc_Abi__c = abi;
        workOrder.Plc_BankDescription__c = bankDescription;
        workOrder.Plc_LegacyAccountId__c = legacyAccountId;
        workOrder.Plc_SiaCode__c = siaCode;
        workOrder.Plc_LegacyServicePointId__c = legacyServicePointId;
        workOrder.Plc_ServicePoint__c = servicePoint;
        workOrder.Plc_Cti__c = cti;
        workOrder.Plc_CustomerCare__c = customerCare;
        workOrder.Plc_FiscalCode__c = fiscalCode;

        return workOrder;
    }

    /**
     * Creates work order line item
     *
     * @author FB
     *
     * @param  alias            Work Order Line Item alias
     * @param  extCatalogItem   Work Order Line Item extCatalogItem
     * @param  termId           Work Order Line Item termId
     * @param  logisticDivision Work Order Line Item logistic
     * @param  operationType    Work Order Line Item operationType
     * @param  status           Work Order Line Item status
     * @param  note             Work Order Line Item note
     * @param  serial           Work Order Line Item serial
     * @param  bundle           Work Order Line Item bundle
     * @return                  A WorkOrderLineItem instance
     */
    public static WorkOrderLineItem createWorkOrderLineItem(String alias, B2WExtCat__External_Catalog_Item__c extCatalogItem, 
                                                            Plc_TermId__c termId, String logisticDivision, String operationType, 
                                                            String status, String note, String serial, String bundle) {
        
        WorkOrderLineItem workOrderLineItem = new WorkOrderLineItem();
        workOrderLineItem.Plc_Alias__c = alias;
        workOrderLineItem.Plc_ExternalCatalogItem__c = extCatalogItem.Id;
        workOrderLineItem.Plc_TermId__c = termId.Id;
        workOrderLineItem.Plc_LogisticDivision__c = logisticDivision;
        workOrderLineItem.Plc_OperationType__c = operationType;
        workOrderLineItem.Status = status;
        workOrderLineItem.Plc_Note__c = note;
        workOrderLineItem.Plc_SerialNumber__c = serial;
        workOrderLineItem.Plc_BundleId__c = bundle;

        return workOrderLineItem;
    }

    /**
     * Creates stock order
     *
     * @author FB
     * 
     * @param  transferType         Stock Order transfer type
     * @param  workOrder            Stock Order work order
     * @param  warehouse            Stock Order warehouse
     * @param  pointOfSales         Stock Order point of sales
     * @param  destinationWarehouse Stock Order destination warehouse
     * @param  destinationDealer    Stock Order destination dealer
     * @return                      A Bit2Shop__StockOrder__c instance
     */
    public static Bit2Shop__StockOrder__c createStockOrder(String transferType, WorkOrder workOrder,
                                                           Bit2Shop__Warehouse__c warehouse,
                                                           Bit2Shop__Dealer__c pointOfSales,
                                                           Bit2Shop__Warehouse__c destinationWarehouse,
                                                           Bit2Shop__Dealer__c destinationDealer) {
        
        Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c();
        stockOrder.Bit2Shop__Transfer_Type__c = transferType;
        stockorder.Bit2Shop__Warehouse_Id__c = warehouse.Id;
        stockOrder.Bit2Shop__Destination_Warehouse_Id__c = destinationWarehouse.Id;
        stockOrder.Plc_WorkOrder__c = workOrder.Id;
        stockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c = destinationDealer.Id;
        stockorder.Bit2Shop__Point_Of_Sales_Id__c = pointOfSales.Id;

        return stockOrder;
    }

    /**
     * Creates shipment
     *
     * @author FB
     * 
     * @param  recordTypeName Shipment record type name
     * @param  stockOrder     Shipment Stock order
     * @param  type           Shipment type
     * @return                Creates a Bit2Shop__Shipment__c instance
     */
    private static Bit2Shop__Shipment__c createShipment(String recordTypeName, Bit2Shop__StockOrder__c stockOrder, 
                                                        String type) {

        Bit2Shop__Shipment__c shipment = new Bit2Shop__Shipment__c();
        shipment.RecordTypeId = Plc_Utils.getRecordTypeId(recordTypeName, Bit2Shop__Shipment__c.SObjectType.getDescribe().name);
        shipment.Bit2Shop__Sub_Type__c = type;
        shipment.Bit2Shop__Stock_Order_Id__c = stockOrder.Id;

        return shipment;
    }

    /**
     * Creates outbound shipment
     *
     * @author FB
     * 
     * @param  stockOrder Shipment Stock order
     * @return            Creates a Bit2Shop__Shipment__c instance
     */
    public static Bit2Shop__Shipment__c createOutboundShipment(Bit2Shop__StockOrder__c stockOrder) {

        Bit2Shop__Shipment__c shipment = createShipment(Plc_Constants.B2S_Shipment.RecordType_OutboundShipment, stockOrder, 'Outbound');
        shipment.Bit2Shop__Stock_Order_Id__c = stockOrder.Id;

        return shipment;
    }

    /**
     * Creates inbound shipment
     *
     * @author FB
     * 
     * @param  stockOrder Shipment Stock order
     * @return            Creates a Bit2Shop__Shipment__c instance
     */
    public static Bit2Shop__Shipment__c createInboundShipment(Bit2Shop__StockOrder__c stockOrder) {

        Bit2Shop__Shipment__c shipment = createShipment(Plc_Constants.B2S_Shipment.RecordType_InboundShipment, stockOrder, 'Inbound');
        shipment.Bit2Shop__Stock_Order_Id__c = stockOrder.Id;

        return shipment;
    }  

    /**
     * Creates shipment line item
     * 
     * @param  recordTypeName Shipment Line Item record type developer name
     * @param  simpleDate     Shipment Line Item date
     * @param  productStock   Shipment Line Item product stock 
     * @param  shipment       Shipment Line Item shipment
     * @param  receivedQty    Shipment Line Item received quantity
     * @param  transferStatus Shipment Line Item transfer status
     * @return                A Bit2Shop__Shipment_Line_Item__c instance
     */
    public static Bit2Shop__Shipment_Line_Item__c createShipmentLineItem(String recordTypeName, Date simpleDate, Bit2Shop__Product_Stock__c productStock,
                                                                        Bit2Shop__Shipment__c shipment, Decimal receivedQty, String transferStatus) {

        Bit2Shop__Shipment_Line_Item__c shipmentLineItem = new Bit2Shop__Shipment_Line_Item__c();
        shipmentLineItem.RecordTypeId = Plc_Utils.getRecordTypeId(recordTypeName, Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name);
        shipmentLineItem.Bit2Shop__Date__c = simpleDate;
        shipmentLineItem.Bit2Shop__Product_Stock_Id__c = productStock.Id;
        shipmentLineItem.Bit2Shop__Shipment_Id__c = shipment.Id;
        shipmentLineItem.Bit2Shop__Received_Quantity__c = receivedQty;
        shipmentLineItem.Plc_TransfertStatus__c = transferStatus;

        return shipmentLineItem;
    }

    /**
     * Creates user
     *
     * @author FB
     * 
     * @param  suffix      User suffix
     * @param  profileName User profile name
     * @return             A User instance
     */
    public static User createUser(String suffix, String profileName) {

        Profile profile = [SELECT Id 
                           FROM Profile 
                           WHERE Name = :profileName];

        User user = new User();
        user.Alias = 'usr';
        user.Email = 'user' + suffix + '@testorg.com';
        user.EmailEncodingKey = 'UTF-8';
        user.LastName = 'Testing' + suffix;
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId = profile.Id;
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.UserName = 'user' + suffix + '@testorg.com';

        Boolean isSandbox = false;

        isSandbox = [SELECT Id, IsSandbox 
                     FROM Organization 
                     LIMIT 1].isSandbox;

        if (isSandbox) {
            user.UserName += '.test';
        }

        return user;
    }


    /**
     * Creates fake warehouse used when stock serial 2 are created
     *
     * @author FB
     * 
     * @param  plcTermId TermId
     * @param  wareHouse Warehouse
     * @return        Bit2Shop__Stock_Serials2__c
     */
    public static void createWarehouseFake() {

        Account accountFake = createAccountSupplier('Fake');
        insert accountFake;
        
        Bit2Shop__Dealer__c dealerParentFake = createDealerParent('FakeParent', accountFake, 'FakeParentAlias');
        insert dealerParentFake;

        Bit2Shop__Dealer__c dealerChildFake = createDealerChild('FakeChild', accountFake, 'FakeChildAlias', dealerParentFake);
        insert dealerChildFake;
        
        Bit2Shop__Warehouse__c warehouseFake = createWarehouse('FakeWarehouse', 'Irrecoverable', 'Nexi', '000001NEXI', dealerChildFake);
        insert warehouseFake;

        Bit2Shop__StockHistory2__c stockHistoryFake = new Bit2Shop__StockHistory2__c();
        stockHistoryFake.Name = 'FakeStockHistory';
        stockHistoryFake.Bit2Shop__Warehouse_Id__c = warehouseFake.Id;
        stockHistoryFake.Bit2Shop__Action_Code__c = 'Fake';
        stockHistoryFake.Bit2Shop__Qty__c = 0;

        insert stockHistoryFake;
        
    }

    /**
     * Creates Plc_SystemSettings__c
     *
     * @author FB
     * 
     * @return A Plc_SystemSettings__c instance
     */
    public static Plc_SystemSettings__c createSystemSettings() {

        Plc_SystemSettings__c systemSettings = new Plc_SystemSettings__c();
        systemSettings.Plc_StatusPicklistValueForSS2__c = 'test';
        systemSettings.Plc_DaysForCalculatingConsumption__c = 2;
        systemSettings.Plc_MonthsToRemovePrdSnpShot__c = 3;
        systemSettings.Plc_PurchaseWarrantyMonthsDelay__c = 2;

        return systemSettings;
    }

    /**
     * Creates Plc_ProcessSettings__c 
     * 
     * @author FB
     *       
     * @return A Plc_ProcessSettings__c instance
     */
    public static Plc_ProcessSettings__c createProcessSettings() {

        Plc_ProcessSettings__c processSettings = new Plc_ProcessSettings__c();
        processSettings.Plc_DaysToDeleteStockSerial2New__c = 1;
        processSettings.Plc_DaysForReorderTime__c = 15;
        processSettings.Plc_DaysToDeleteStockSerial2New__c = 60;
        processSettings.Plc_DepreciationDuration__c = 3;
        processSettings.Plc_MaxDaysToRetainReservations__c = 60;
        processSettings.Plc_DepreciationPercentage__c = '40,30,30';

        return processSettings;
    }

    /**
     * Initialize process click settings
     * 
     * @author Luca Belometti
     * 
     */
    public static void initProcessClickPackage(){

        wrts_prcgvr.InstallIntegration.install();

        insert new List<Wrts_prcgvr__PhaseManagerSObjectSetting__c> {
                new Wrts_prcgvr__PhaseManagerSObjectSetting__c(
                        Name = 'Work Order',
                        Wrts_prcgvr__ObjectType__c = 'WorkOrder',
                        Wrts_prcgvr__PivotField__c = 'Status',
                        Wrts_prcgvr__TypeField__c = 'RecordTypeId'
                ),
                new Wrts_prcgvr__PhaseManagerSObjectSetting__c(
                        Name = 'Bit2Shop__Stock_Serials2__c',
                        Wrts_prcgvr__ObjectType__c = 'Bit2Shop__Stock_Serials2__c',
                        Wrts_prcgvr__PivotField__c = 'Bit2Shop__Status__c',
                        Wrts_prcgvr__TypeField__c = 'RecordTypeId'
                )
        };
    }

    /**
     * creates a ProcessClick PhaseManager transition
     * 
     * @author Carlo Muntoni
     * @version 1.0
     *      
     * @param String sObjectType API name of the sObject
     * @param String rtDevName   API name of the a record type of the sObject.
     * @param String originPhase origin phase name
     * @param String destPhase   destination phase name
     * 
     * @return       an new instance of Wrts_prcgvr__PhaseTransition__c
     */
    public static Wrts_prcgvr__PhaseTransition__c newPhaseTrans(String sObjectType, String rtDevName,
                                                                String originPhase, String destPhase) {
        return new Wrts_prcgvr__PhaseTransition__c(
            Wrts_prcgvr__Code__c             = Math.random()+'',
            Wrts_prcgvr__DestinationPhase__c = destPhase,
            Wrts_prcgvr__OriginPhase__c      = originPhase,
            Wrts_prcgvr__RecordTypeId__c     = Plc_Utils.getRecordTypeId(rtDevName, sObjectType),
            Wrts_prcgvr__RecordTypeName__c   = rtDevName,
            Wrts_prcgvr__Type__c             = 'A'
        );
    }


}