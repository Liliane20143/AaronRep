/** 
 * @author Francesco Bigoni
 * @date Creation 15/08/2019
 * @version 1.0
 * @description Controller of lightning component Plc_CreateMockWorkOrder
 *
 */
public with sharing class Plc_CreateMockWorkOrderCnt {

    /**
     * Method used in order to get some different system labels
     *
     * @code 01
     *
     * @return A map containing pairs Api Name/Label
     */
    @AuraEnabled
    public static Map<String, String> retrieveTranslationMap(){
        Map<String, String> response = new Map<String,String>();

        //Getting Serial Stock 2 labels
        Schema.DescribeSObjectResult serialStockSchema = Bit2Shop__Stock_Serials2__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> serialStockFieldsMap = serialStockSchema.fields.getMap();
        response.put('Bit2Shop__Stock_Serials2__c', serialStockSchema.getLabelPlural());
        response.put('SerialStock', serialStockSchema.getLabel());
        response.put('SerialStockName', serialStockFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Plc_Model__c', serialStockFieldsMap.get('Plc_Model__c').getDescribe().getLabel());
        response.put('Plc_ManufacturerSerialNumber__c', serialStockFieldsMap.get('Plc_ManufacturerSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_EncodedSerialNumber__c', serialStockFieldsMap.get('Plc_EncodedSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_DllSerialNumber__c', serialStockFieldsMap.get('Plc_DllSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_ProductSku__c', serialStockFieldsMap.get('Plc_ProductSku__c').getDescribe().getLabel());
        response.put('Plc_Manufacturer__c', serialStockFieldsMap.get('Plc_Manufacturer__c').getDescribe().getLabel());
        //Getting Product Stock labels
        Schema.DescribeSObjectResult productStockSchema = Bit2Shop__Product_Stock__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> productStockFieldsMap = productStockSchema.fields.getMap();
        response.put('Bit2Shop__Product_Stock__c', productStockSchema.getLabelPlural());
        response.put('ProductStockName', productStockFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Plc_AvailableQty__c', productStockFieldsMap.get('Plc_AvailableQty__c').getDescribe().getLabel());
        response.put('Bit2Shop__Stock_Qty__c', productStockFieldsMap.get('Bit2Shop__Stock_Qty__c').getDescribe().getLabel());
        //Getting External catalog item labels
        Schema.DescribeSObjectResult modelSchema =  B2WExtCat__External_Catalog_Item__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> modelFieldsMap = modelSchema.fields.getMap();
        response.put('B2WExtCat__External_Catalog_Item__c', modelSchema.getLabelPlural());
        response.put('Plc_Solution__c', modelFieldsMap.get('Plc_Solution__c').getDescribe().getLabel());
        response.put('Plc_Category__c', modelFieldsMap.get('Plc_Category__c').getDescribe().getLabel());
        response.put('Plc_Subcategory__c', modelFieldsMap.get('Plc_Subcategory__c').getDescribe().getLabel());
        response.put('Plc_MinimumStock__c', modelFieldsMap.get('Plc_MinimumStock__c').getDescribe().getLabel());
        //Getting Work Order Line Item labels
        Schema.DescribeSObjectResult workOrderLineItemSchema =  WorkOrderLineItem.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> workOrderLineItemFieldsMap = workOrderLineItemSchema.fields.getMap();
        response.put('WorkOrderLineItem', workOrderLineItemSchema.getLabel());
        response.put('WorkOrderLineItems', workOrderLineItemSchema.getLabelPlural());
        response.put('Status', workOrderLineItemFieldsMap.get('Status').getDescribe().getLabel());
        response.put('Plc_SerialNumber__c', workOrderLineItemFieldsMap.get('Plc_SerialNumber__c').getDescribe().getLabel());
        response.put('Quantity', workOrderLineItemFieldsMap.get('Quantity').getDescribe().getLabel());
        response.put('Plc_ReplacedBy__c', workOrderLineItemFieldsMap.get('Plc_ReplacedBy__c').getDescribe().getLabel());
        //Getting Work Order labels
        Schema.DescribeSObjectResult workOrderSchema =  WorkOrder.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> workOrderFieldsMap = workOrderSchema.fields.getMap();
        response.put('WorkOrder', workOrderSchema.getLabel());
        response.put('Plc_Alias__c', workOrderFieldsMap.get('Plc_Alias__c').getDescribe().getLabel());
        response.put('Plc_ServicePoint__c', workOrderFieldsMap.get('Plc_ServicePoint__c').getDescribe().getLabel());
        response.put('Plc_LegacyServicePointId__c', workOrderFieldsMap.get('Plc_LegacyServicePointId__c').getDescribe().getLabel());
        response.put('Plc_LegacyAccountId__c', workOrderFieldsMap.get('Plc_LegacyAccountId__c').getDescribe().getLabel());
        response.put('Plc_FiscalCode__c', workOrderFieldsMap.get('Plc_FiscalCode__c').getDescribe().getLabel());
        response.put('Plc_Vat__c', workOrderFieldsMap.get('Plc_Vat__c').getDescribe().getLabel());
        response.put('Plc_SiaCode__c', workOrderFieldsMap.get('Plc_SiaCode__c').getDescribe().getLabel());
        response.put('Street', workOrderFieldsMap.get('Street').getDescribe().getLabel());
        response.put('City', workOrderFieldsMap.get('City').getDescribe().getLabel());
        response.put('Zip', workOrderFieldsMap.get('PostalCode').getDescribe().getLabel());
        response.put('State', workOrderFieldsMap.get('State').getDescribe().getLabel());
        response.put('Country', workOrderFieldsMap.get('Country').getDescribe().getLabel());
        //Getting termId labels
        Schema.DescribeSObjectResult termIdSchema = Plc_TermId__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> termIdFieldsMap = termIdSchema.fields.getMap();
        response.put('Plc_TermId__c', termIdSchema.getLabel());
        response.put('Plc_TermIdCode__c', termIdFieldsMap.get('Plc_TermIdCode__c').getDescribe().getLabel());
        //Getting Asset labels
        Schema.DescribeSObjectResult assetSchema = Asset.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> assetFieldsMap = assetSchema.fields.getMap();
        response.put('Asset', assetSchema.getLabel());
        response.put('AssetName', assetFieldsMap.get('Name').getDescribe().getLabel());
        //Getting Shipment Line Item
        Schema.DescribeSObjectResult shipmentLineItemSchema = Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> shipmentLineItemFieldsMap = shipmentLineItemSchema.fields.getMap();
        response.put('ShipmentLineItem', shipmentLineItemSchema.getLabel());
        //Getting Contact
        Schema.DescribeSObjectResult contactSchema = Contact.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> contactFieldsMap = contactSchema.fields.getMap();
        response.put('Contact', contactSchema.getLabel());
        response.put('ContactName', contactFieldsMap.get('Name').getDescribe().getLabel());
        //Getting Stock Order
        Schema.DescribeSObjectResult stockOrderSchema = Bit2Shop__StockOrder__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> stockOrderFieldsMap = stockOrderSchema.fields.getMap();
        response.put('Bit2Shop__Destination_Warehouse_Id__c', stockOrderFieldsMap.get('Bit2Shop__Destination_Warehouse_Id__c').getDescribe().getLabel());
        return response;
    }

    /**
     * Method used in order to get some utils and context data
     *
     * @code 02
     * 
     * @return Utils and context data
     */
    @AuraEnabled
    public static Map<String, Object> retrievePropertiesMap(){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        Map<String, String> availableOperationTypesMap = retrieveActivePickListValues('WorkOrderLineItem', 'Plc_OperationType__c');
        response.put('availableOperationTypesMap', availableOperationTypesMap);

        return response;
    }

    /**
     * Method used in order to get available from serials warehouse
     *
     * @code 03
     *
     * @param warehouseAlias               Warehouse alias on given work order
     * @param searchKey                    Search key string
     * @param consumedSerials              Serials that must be excluded from search
     * @param statusList                   Searchable status list for serials
     * @return                             Available serials
     */
    @AuraEnabled
    public static Map<String, Object> retrieveAvailableSerials(String warehouseAlias, String searchKey, Integer searchLimit,
                                                               List<String> consumedSerials, List<String> statusList,
                                                               String termId) {

        Map<String, Object> response = new Map<String, Object>();
        searchKey = '%' + searchKey + '%';
        searchLimit = (searchLimit == null) ? 20 : searchLimit;
        System.debug('### ' + warehouseAlias);
        System.debug('### ' + statusList);
        System.debug('### ' + searchKey);
        System.debug('### ' + termId);
        //Stock serials contained in the given warehouse
        List<Bit2Shop__Stock_Serials2__c> availableStockSerialsList = new List<Bit2Shop__Stock_Serials2__c>();

        try {
            availableStockSerialsList = Database.query(composeStockSerialsQuery(warehouseAlias, 'Product', termId, searchLimit));
            response.put('availableStockSerialsList', availableStockSerialsList);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Helper method used to compose the query for retrieving the list of stock serials
     *
     * @code 04
     *
     * @param  warehouseAlias    Alias of warehouse in which looking for material
     * @param  category          Category of the serial to search
     * @param  termId            TermId from which searching
     * @return                   String that represents the SOQL query
     */
    private static String composeStockSerialsQuery(String warehouseAlias, String category, String termId, Integer searchLimit) {

        String query;
        query =  ' SELECT Id, Name, Plc_ManufacturerSerialNumber__c, Plc_EncodedSerialNumber__c,' 
               +       ' Plc_DllSerialNumber__c, Plc_Manufacturer__c, Plc_ProductSku__c, Plc_Model__c,' 
               +       ' Plc_TermId__c, Plc_TermId__r.Name, Plc_TermId__r.Plc_TermIdCode__c, '
               +       ' Bit2Shop__Product_Stock_Id__r.Name,Bit2Shop__Status__c,' 
               +       ' Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Plc_Solution__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,' 
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c'
               + ' FROM Bit2Shop__Stock_Serials2__c '
               + ' WHERE Bit2Shop__Warehouse_Id__r.Plc_Alias__c = \'' + warehouseAlias + '\' AND'
               +       ' Id NOT IN :consumedSerials AND'
               +       ' Bit2Shop__Status__c IN :statusList AND'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c = true AND'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = \'' + category + '\' AND'
               +       ' (Plc_Model__c LIKE :searchKey OR'
               +       '  Plc_ProductSku__c LIKE :searchKey OR'
               +       '  Plc_ManufacturerSerialNumber__c LIKE :searchKey OR'
               +       '  Plc_EncodedSerialNumber__c LIKE :searchKey OR'
               +       '  Plc_DllSerialNumber__c LIKE :searchKey OR'
               +       '  Plc_Manufacturer__c LIKE :searchKey OR'
               +       '  Bit2Shop__Product_Stock_Id__r.Plc_Solution__c LIKE :searchKey)';
        
        if (String.isNotBlank(termId)) {
            query += ' AND Plc_TermId__c = \'' + termId + '\'';
        }

        query += ' ORDER BY Plc_Model__c';
        query += ' LIMIT ' + searchLimit;
        return query;
    }

    /**
     * Retrieves available operations with the selected type
     *
     * @code 05
     * 
     * @param  woTipology       Work Order integration name tipology
     * @return                  Map containing available operations api/label
     */
    @AuraEnabled
    public static Map<String, Object> retrieveEligibleOperations(String woTipology) {
        
        Map<String, Object> response = new Map<String, Object>();
        Map<String, String> availableOperationTypesMap = new Map<String, String>();
        Set<String> foundOperationsSet = new Set<String>();
        Map<String, String> operationTypesMap = retrieveActivePickListValues('WorkOrderLineItem', 'Plc_OperationType__c');

        System.debug('### ' + woTipology);

        for (Plc_WorkOrderConfiguration__c woConfiguration : [SELECT Id, Plc_IntegrationName__c,
                                                                     Plc_EligibleOperationTypes__c,
                                                                     RecordType.DeveloperName
                                                              FROM Plc_WorkOrderConfiguration__c
                                                              WHERE Plc_IntegrationName__c = :woTipology]) {

            foundOperationsSet.add(woConfiguration.Plc_EligibleOperationTypes__c);
        }

        System.debug('### ' + foundOperationsSet);
        System.debug('### ' + operationTypesMap);

        for (String key : operationTypesMap.keySet()) {
            if (foundOperationsSet.contains(key)) {
                availableOperationTypesMap.put(key, operationTypesMap.get(key));
            }
        }

        System.debug('### ' + availableOperationTypesMap);

        response.put('availableOperationTypesMap', availableOperationTypesMap);                       
        return response;                                           
    }

    /**
     * Creates the work order with the line items
     *
     * @code 06
     * 
     * @param  workOrderWrp       Work Order information
     * @param  tipology           Work Order tipology
     * @param  selectedWarehouse  Warehouse on which working on
     * @param  woliAsString       Work Order Line Items list as string
     * @param  serialIdList       WList containing the list of serials
     * @return                    Ok if everything goes well
     */
    @AuraEnabled
    public static Map<String, Object> createWorkOrder(Map<String, String> workOrderWrp, String tipology, Bit2Shop__Warehouse__c selectedWarehouse,
                                                      String woliAsString, List<String> serialIdList) {

        Map<String, Object> response = new Map<String, Object>();
        Savepoint sp = Database.setSavepoint();
        System.debug('### selected warehouse: ' + selectedWarehouse);
        System.debug('### tipology: ' + tipology);
        System.debug('### workOrderWrp: ' + workOrderWrp);
        System.debug('### serialIdList: ' + serialIdList);

        try {

            DateTime now = System.now();
            String nowTimeStamp = '' + now.year() + now.month() + now.day() + now.hour() + now.minute() + now.second() + '';

            Map<String, String> serialIdToAssetMap = new Map<String, String>();

            //Getting assets to be uninstalled
            for (Asset asset : [SELECT Id, Plc_StockSerial__c
                                FROM Asset 
                                WHERE Plc_StockSerial__c IN :serialIdList AND
                                      Status = 'Installed' AND
                                      Plc_StockSerial__c != null]) {
                
                serialIdToAssetMap.put(asset.Plc_StockSerial__c, asset.Id);
            }

            //Parsing back list of work order line items to check
            List<WorkOrderLineItemWrp> woliWrpList = (List<WorkOrderLineItemWrp>)JSON.deserialize(woliAsString, List<WorkOrderLineItemWrp>.class);
            System.debug('### woliWrpList: ' + JSON.serializePretty(woliWrpList));

            WorkOrder woToCreate = new WorkOrder();
            List<WorkOrderLineItem> woliToCreateList = new List<WorkOrderLineItem>();
            Map<String, Bit2Shop__Stock_Serials2__c> serialsVerifiedToAvailableMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
            Map<String, Bit2Shop__Stock_Serials2__c> serialsAvailableToWithdrawnMap = new Map<String, Bit2Shop__Stock_Serials2__c>();

            if (String.isBlank(workOrderWrp.get('Plc_Alias__c'))) {
                woToCreate.Plc_Alias__c = nowTimeStamp;
            } else {
                woToCreate.Plc_Alias__c = workOrderWrp.get('Plc_Alias__c');
            }

            woToCreate.RecordTypeId = Plc_Utils.getRecordTypeId(tipology, 'WorkOrder');
            woToCreate.Plc_ServicePoint__c = workOrderWrp.get('Plc_ServicePoint__c');
            woToCreate.Plc_LegacyServicePointId__c = workOrderWrp.get('Plc_LegacyServicePointId__c');
            woToCreate.Plc_LegacyAccountId__c = workOrderWrp.get('Plc_LegacyAccountId__c');
            woToCreate.Plc_FiscalCode__c = workOrderWrp.get('Plc_FiscalCode__c');
            woToCreate.Plc_Vat__c = workOrderWrp.get('Plc_Vat__c');
            woToCreate.Plc_SiaCode__c = workOrderWrp.get('Plc_SiaCode__c');
            woToCreate.Street = workOrderWrp.get('Street');
            woToCreate.City = workOrderWrp.get('City');
            woToCreate.PostalCode = workOrderWrp.get('Zip');
            woToCreate.State = workOrderWrp.get('State');
            woToCreate.Country = workOrderWrp.get('Country');
            woToCreate.Plc_LegacyWarehouseId__c = selectedWarehouse.Plc_Alias__c;
            woToCreate.Plc_WarehouseName__c = selectedWarehouse.Name;
            woToCreate.Plc_SourceLegacySystem__c = 'SF_MOCK';
            woToCreate.StartDate = System.DateTime.now();
            woToCreate.Status = 'Assigned';


            if (String.isBlank(workOrderWrp.get('Plc_FiscalCode__c')) && String.isBlank(workOrderWrp.get('Plc_Vat__c'))) {
                woToCreate.Plc_FiscalCode__c = 'FIT';
            }

            System.debug('### woToCreate: ' + JSON.serializePretty(woToCreate));
            insert woToCreate;

            Integer index = 0;

            for (WorkOrderLineItemWrp woliWrp : woliWrpList) {
                index ++;
                WorkOrderLineItem woliToCreate = new WorkOrderLineItem();
                woliToCreate.Plc_Alias__c = woToCreate.Plc_Alias__c + '_' + index;
                woliToCreate.Plc_StockSerial__c = woliWrp.serialId;
                woliToCreate.Plc_SerialNumber__c = woliWrp.serialNumber;
                woliToCreate.Plc_OperationType__c = woliWrp.operationType;
                woliToCreate.Plc_ExternalCatalogItem__c = woliWrp.externalCatalogItemId;
                woliToCreate.Plc_ReferenceExternalCatalogItem__c = woliWrp.productSku;
                woliToCreate.Status = 'Executed';
                woliToCreate.WorkOrderId = woToCreate.Id;

                //If the tipology is Installation, then further checks on termId are needed
                if (woliToCreate.Plc_OperationType__c == 'ToInstall') {

                    //Getting the serials which status must be work on
                    if (String.isNotBlank(woliToCreate.Plc_StockSerial__c)) {
                        if (woliWrp.serialStatus == Plc_Constants.B2S_StockSerials2.B2S_Status_Available) {
                            serialsAvailableToWithdrawnMap.put(woliToCreate.Plc_StockSerial__c,
                                new Bit2Shop__Stock_Serials2__c(
                                    Id = woliToCreate.Plc_StockSerial__c,
                                    Bit2Shop__Status__c = Plc_Constants.B2S_StockSerials2.B2S_Status_Available,
                                    Bit2Shop__Product_Stock_Id__c = woliWrp.productStockId
                                )
                            );
                        } else if (woliWrp.serialStatus == Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeVerified) {
                            serialsVerifiedToAvailableMap.put(woliToCreate.Plc_StockSerial__c,
                                new Bit2Shop__Stock_Serials2__c(
                                    Id = woliToCreate.Plc_StockSerial__c,
                                    Bit2Shop__Status__c = Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeVerified,
                                    Bit2Shop__Product_Stock_Id__c = woliWrp.productStockId
                                )
                            );
                        }
                    }

                    //Setting termId
                    if (String.isNotBlank(woliWrp.newTermIdCode)) {
                        woliToCreate.Plc_ExternalTermId__c = woliWrp.newTermIdCode;
                    } else {
                        woliToCreate.Plc_ExternalTermId__c = woliWrp.existingTermIdCode;
                        woliToCreate.Plc_TermId__c = woliWrp.existingTermIdId;
                    }
                } else {
                    woliToCreate.AssetId = serialIdToAssetMap.get( woliToCreate.Plc_StockSerial__c);
                    woliToCreate.Plc_ExternalTermId__c = woliWrp.existingTermIdCode;
                    woliToCreate.Plc_TermId__c = woliWrp.existingTermIdId;
                }

                woliToCreateList.add(woliToCreate);
            }


            //Managing the serials updating the status
            System.debug('### serialsVerifiedToAvailableMap: ' + JSON.serializePretty(serialsVerifiedToAvailableMap));
            System.debug('### serialsAvailableToWithdrawnMap: ' + JSON.serializePretty(serialsAvailableToWithdrawnMap));

            manageSerials(serialsVerifiedToAvailableMap, serialsAvailableToWithdrawnMap);

            System.debug('### woliToCreateList: ' + JSON.serializePretty(woliToCreateList));
            insert woliToCreateList;

            //Updating work order status
            woToCreate.Status = 'Closed';
            woToCreate.EndDate = System.DateTime.now();
            update woToCreate;
            response.put('workOrderId', woToCreate.Id);

        } catch (Exception e) {
            Database.rollback(sp);
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }
    
    /**
     * Helper to manage the product stock quantities
     *
     * @code 07
     * 
     * @param  serialsVerifiedToAvailableMap   Serials with transition To Be Verified => Available
     * @param  serialsAvailableToWithdrawnMap  Serials with transition Available => Withdrawn
     * @return  Nothing
     */
    private static void manageSerials(Map<String, Bit2Shop__Stock_Serials2__c> serialsVerifiedToAvailableMap, 
                                      Map<String, Bit2Shop__Stock_Serials2__c> serialsAvailableToWithdrawnMap) {

        //Updating serials from To be verified to Available
        if (!serialsVerifiedToAvailableMap.keySet().isEmpty()) { 
            Map<String, Bit2Shop__Stock_Serials2__c> serialsAvailableMap = new Map<String, Bit2Shop__Stock_Serials2__c>();

            for (String key: serialsVerifiedToAvailableMap.keySet()) {

                Bit2Shop__Stock_Serials2__c stockSerialToUpdate = new Bit2Shop__Stock_Serials2__c (
                    Id = key,
                    Bit2Shop__Status__c = Plc_Constants.B2S_StockSerials2.B2S_Status_Available,
                    Bit2Shop__Product_Stock_Id__c = serialsVerifiedToAvailableMap.get(key).Bit2Shop__Product_Stock_Id__c
                );

                serialsAvailableMap.put(key, stockSerialToUpdate);
                serialsAvailableToWithdrawnMap.put(key, stockSerialToUpdate);
            }

            update serialsAvailableMap.values();
            Plc_Utils.productStockQties.updateProductStockQuantities(serialsVerifiedToAvailableMap, serialsAvailableMap);
        }

        //Updating serials from Available to Withdrawn
        if (!serialsAvailableToWithdrawnMap.keySet().isEmpty()) {
            Map<String, Bit2Shop__Stock_Serials2__c> serialsWithdrawnMap = new Map<String, Bit2Shop__Stock_Serials2__c>();

            for (String key: serialsAvailableToWithdrawnMap.keySet()) {

                    Bit2Shop__Stock_Serials2__c stockSerialToUpdate = new Bit2Shop__Stock_Serials2__c (
                    Id = key,
                    Bit2Shop__Status__c = Plc_Constants.B2S_StockSerials2.B2S_Status_Withdrawn,
                    Bit2Shop__Product_Stock_Id__c = serialsAvailableToWithdrawnMap.get(key).Bit2Shop__Product_Stock_Id__c
                );

                serialsWithdrawnMap.put(key, stockSerialToUpdate);
            }

            update serialsWithdrawnMap.values();
            Plc_Utils.productStockQties.updateProductStockQuantities(serialsAvailableToWithdrawnMap, serialsWithdrawnMap);
        }
    }
    /**
     * Retrieves a map containing the picklist values of specified field/object
     *
     * @code 08
     * 
     * @param  sObjectType       Name of object from which getting the field
     * @param  fieldName         Name of the field from which getting values
     * @return                   Map containing pairs picklist values  ApiName/Label
     */
    private static Map<String, String> retrieveActivePickListValues(String sObjectType, 
                                                                    String fieldName) {

        Map<String, String> picklistMapToReturn = new Map<String, String>();
        Schema.DescribeFieldResult objectFieldMap = Schema.getGlobalDescribe()
                                                    .get(sObjectType)
                                                    .getDescribe()
                                                    .fields.getMap()
                                                    .get(fieldName)
                                                    .getDescribe();

        for (Schema.PicklistEntry picklistEntry : objectFieldMap.getPicklistValues()) {
            if (picklistEntry.isActive()) {
                picklistMapToReturn.put(picklistEntry.getValue(), picklistEntry.getLabel());
            }
        }
        return picklistMapToReturn;
    }

    /**
     * Work Order Line Item wrapper
     */
    @TestVisible
    class WorkOrderLineItemWrp {
        String serialId;
        String serialStatus;
        String productStockId;
        /* TermId splitted to 2 different fields */
        String existingTermIdId;
        String existingTermIdCode;
        /* */
        String newTermIdCode;
        String serialNumber;
        String operationType;
        String externalCatalogItemId;
        String productSku;
    }
}