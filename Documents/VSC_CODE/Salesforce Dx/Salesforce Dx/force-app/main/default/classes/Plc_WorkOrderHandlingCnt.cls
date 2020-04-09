/** 
 * @author FB
 * @date Creation 31/12/2018
 * @version 1.0
 * @description Controller of lightning component Plc_WorkOrderHandling
 *
 * @history 30/04/2019 - Adding logic for implementing the WO Console
 */
public without sharing class Plc_WorkOrderHandlingCnt {

    public static final String ACCEPT_ACTION = 'accept';
    public static final String REFUSE_ACTION = 'refuse';

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
        response.put('Status', workOrderLineItemFieldsMap.get('Status').getDescribe().getLabel());
        response.put('Plc_SerialNumber__c', workOrderLineItemFieldsMap.get('Plc_SerialNumber__c').getDescribe().getLabel());
        response.put('Quantity', workOrderLineItemFieldsMap.get('Quantity').getDescribe().getLabel());
        response.put('Plc_ReplacedBy__c', workOrderLineItemFieldsMap.get('Plc_ReplacedBy__c').getDescribe().getLabel());
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
     * @param workOrderId Current opened work order id
     * @return            Initialization and context data
     */
    @AuraEnabled
    public static Map<String, Object> retrievePropertiesMap(String workOrderId){

        Map<String, Object> response = new Map<String, Object>();
        Map<String, String> translationMap = retrieveTranslationMap();
        response.put('error', false);

        try {
            //Getting starting work order information
            List<WorkOrder> woList = [SELECT Id, Plc_LegacyWarehouseId__c,
                                             Plc_LegacyServicePointId__c,
                                             RecordTypeId, Plc_Alias__c,
                                             RecordType.DeveloperName,
                                             Status, EndDate, Plc_ServicePoint__c
                                      FROM WorkOrder
                                      WHERE Id = :workOrderId
                                      LIMIT 1];

            Map<String, WorkOrderLineItemWrp> woliProductsMap = new Map<String, WorkOrderLineItemWrp>();

            Map<String, String> assetIdToWoliMap = new Map<String, String>();
            Map<String, WorkOrderLineItem> termIdToWoliIdMap = new Map<String, WorkOrderLineItem>();
            List<WorkOrderLineItemWrp> woliAccessoriesList = new List<WorkOrderLineItemWrp>();
            Set<String> foundOperationsSet = new Set<String>();
            Set<String> foundAccessoryAssetSet = new Set<String>();
            Set<String> foundSerialSubstituteSet = new Set<String>();
            //Set<String> foundSerialsSet = new Set<String>();
            Map<String, Bit2Shop__Shipment_Line_Item__c> serialToShipmentLineItemMap = new Map<String, Bit2Shop__Shipment_Line_Item__c>();
            Map<String, String> woliToSerialMap = new Map<String, String>();
            Map<String, Bit2Shop__Stock_Serials2__c> stockSerialsMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
            Map<String, String> serialToOpenActivityMap = new Map<String, String>();
            Map<String, String> serialToClosedActivityMap = new Map<String, String>();
            Map<String, String> accessoryAvailableOperationTypesMap = new Map<String, String>();
            Map<String, String> availableOperationTypesMap = retrieveActivePickListValues('WorkOrderLineItem', 'Plc_OperationType__c');

            /* START
             * Retrieving work order configurations
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            for (Plc_WorkOrderConfiguration__c woConfiguration : [SELECT Id, Plc_IntegrationName__c,
                                                                         Plc_EligibleOperationTypes__c,
                                                                         RecordType.DeveloperName
                                                                  FROM Plc_WorkOrderConfiguration__c
                                                                  WHERE Plc_IntegrationName__c = :woList.get(0).RecordType.DeveloperName]) {

                foundOperationsSet.add(woConfiguration.Plc_EligibleOperationTypes__c);
            }

            /* END
             * Retrieving work order configurations
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Woli of products to retrieve
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Getting work order line items of given products
            for (WorkOrderLineItem woliProduct: [SELECT Id, LineItemNumber, toLabel(Status), Plc_TermId__r.Name,
                                                        Plc_TermId__r.Plc_TermIdCode__c,
                                                        Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name,
                                                        Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                        Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                        Plc_StockSerial__r.Plc_DllSerialNumber__c,
                                                        Asset.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                        Asset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                        Asset.Plc_StockSerial__r.Plc_DllSerialNumber__c,
                                                        Plc_Quantity__c, WorkOrder.Plc_LegacyAccountId__c, AssetId,
                                                        Plc_SerialNumber__c, Plc_OperationType__c, Plc_StockSerial__c,
                                                        Plc_ExternalCatalogItem__r.Plc_ProductSku__c,
                                                        Plc_ExternalCatalogItem__r.Bit2Shop__Required_Serial__c,
                                                        Plc_ExternalCatalogItem__r.B2WExtCat__External_Catalog_Item_Name__c,
                                                        toLabel(Plc_ExternalCatalogItem__r.Plc_Category__c),
                                                        toLabel(Plc_ExternalCatalogItem__r.Plc_Subcategory__c)
                                                 FROM WorkOrderLineItem
                                                 WHERE Plc_ExternalCatalogItem__r.Plc_Category__c = 'Product' AND
                                                       WorkOrderId = :workOrderId AND
                                                       ParentWorkOrderLineItemId = '' AND
                                                       //FB 20190711 NEXIPLC-702 [START]
                                                       Status = 'Executed'
                                                       //FB 20190711 NEXIPLC-702 [END]
                                                 ORDER BY LineItemNumber DESC]) {

                //Populating woli wrapper to send back to client
                WorkOrderLineItemWrp woliProductWrp = new WorkOrderLineItemWrp();
                woliProductWrp.id = woliProduct.Id;
                //woliProductWrp.lineItemNumber = translationMap.get('WorkOrderLineItem') 
                //                                + ' • ' 
                //                                + woliProduct.LineItemNumber
                //                                + ' • ' 
                //                                + (woliProduct.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name == null ?
                //                                  '' : woliProduct.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name);
                woliProductWrp.productName = woliProduct.Plc_ExternalCatalogItem__r.B2WExtCat__External_Catalog_Item_Name__c;
                woliProductWrp.lineItemNumber = woliProduct.LineItemNumber;
                woliProductWrp.category = woliProduct.Plc_ExternalCatalogItem__r.Plc_Category__c;
                woliProductWrp.subCategory = woliProduct.Plc_ExternalCatalogItem__r.Plc_Subcategory__c;
                woliProductWrp.externalCatalogItemId = woliProduct.Plc_ExternalCatalogItem__c;
                woliProductWrp.productSku = woliProduct.Plc_ExternalCatalogItem__r.Plc_ProductSku__c;

                if (woliProduct.Plc_OperationType__c == 'ToSubstitute' || woliProduct.Plc_OperationType__c == 'ToSubstituteCorr') {
                    woliProductWrp.serialId = woliProduct.Plc_StockSerial__c;
                    //Getting serial to show
                    woliProductWrp.serialNumber = retrieveSerialFromStockSerial(woliProduct.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                                                woliProduct.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                                                woliProduct.Plc_StockSerial__r.Plc_DllSerialNumber__c);
                } else {
                    woliProductWrp.serialId = woliProduct.Asset.Plc_StockSerial__c;
                    //Getting serial to show
                    woliProductWrp.serialNumber = retrieveSerialFromStockSerial(woliProduct.Asset.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                                                woliProduct.Asset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                                                woliProduct.Asset.Plc_StockSerial__r.Plc_DllSerialNumber__c);
                }
                if (String.isBlank(woliProductWrp.serialNumber)) {
                    woliProductWrp.serialNumber = woliProduct.Plc_SerialNumber__c;
                }

                woliProductWrp.status = woliProduct.Status;
                woliProductWrp.operationType = woliProduct.Plc_OperationType__c;
                woliProductWrp.termIdName = woliProduct.Plc_TermId__r.Name;
                woliProductWrp.termId = woliProduct.Plc_TermId__c;
                woliProductWrp.termIdCode = woliProduct.Plc_TermId__r.Plc_TermIdCode__c;
                woliProductWrp.requestedQty = woliProduct.Plc_Quantity__c;
                woliProductWrp.requiredSerial = woliProduct.Plc_ExternalCatalogItem__r.Bit2Shop__Required_Serial__c;

                if (woliProduct.Plc_ExternalCatalogItem__r.Plc_Subcategory__c != 'Router' &&
                    woliProduct.Plc_ExternalCatalogItem__r.Plc_Subcategory__c != 'Switch') {
                    
                    //FB 20190711 NEXIPLC-702 [START]
                    if (woliProduct.Plc_TermId__c != null) {
                    //FB 20190711 NEXIPLC-702 [END]
                        termIdToWoliIdMap.put(woliProduct.Plc_TermId__c, woliProduct);
                    }

                } else {
                    //FB 20190711 NEXIPLC-702 [START]
                    if (woliProduct.AssetId != null) {
                    //FB 20190711 NEXIPLC-702 [END]
                        assetIdToWoliMap.put(woliProduct.AssetId, woliProduct.Id);
                    }
                }
                
                //Getting serial that must be verified
                if (woliProduct.Plc_OperationType__c == 'ToRemove'
                    || woliProduct.Plc_OperationType__c == 'ToDeactivate'
                    || woliProduct.Plc_OperationType__c == 'ToSubstitute'
                    || woliProduct.Plc_OperationType__c == 'ToSubstituteCorr') {

                    if (String.isNotBlank(woliProduct.AssetId)) {
                        woliToSerialMap.put(woliProduct.Id, '' + woliProduct.Asset.Plc_StockSerial__c);
                    }
                }

                //Getting serial from which drawing the chain of child assets
                if (woliProduct.Plc_OperationType__c == 'ToRemove'
                    || woliProduct.Plc_OperationType__c == 'ToDeactivate') {

                     assetIdToWoliMap.put(woliProduct.AssetId, woliProduct.Id);

                }

                woliProductsMap.put(woliProduct.Id, woliProductWrp);
            }

            //Getting main assets for given termIds
            for (Asset parentAsset: 
                 [SELECT Id, Plc_TermId__c, Status, Plc_StockSerial__c
                  FROM Asset 
                  WHERE Plc_TermId__c IN :termIdToWoliIdMap.keySet() AND 
                        Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = 'Product']) {

                String operationType = termIdToWoliIdMap.get(parentAsset.Plc_TermId__c).Plc_OperationType__c;
                if (parentAsset.Status == 'Installed' && 
                    (operationType == 'NoOperation' 
                    || operationType == 'ToInstall' 
                    || operationType == 'ToSubstitute'
                    || operationType == 'ToSubstituteCorr')) {

                    assetIdToWoliMap.put(parentAsset.Id, termIdToWoliIdMap.get(parentAsset.Plc_TermId__c).Id);

                } 
                //Replaced by check in woliProduct loop
                /*else if (parentAsset.Status == 'Uninstalled' && (
                           operationType == 'ToRemove' 
                           || operationType == 'ToDeactivate')) {

                    assetIdToWoliMap.put(parentAsset.Id, termIdToWoliIdMap.get(parentAsset.Plc_TermId__c).Id);
                }*/

                //Getting the serial to verified
                /*if (parentAsset.Status == 'Uninstalled' && (
                    operationType == 'ToRemove' 
                    || operationType == 'ToDeactivate'
                    || operationType == 'ToSubstitute')) {

                    if (String.isNotBlank(parentAsset.Plc_StockSerial__c)) {
                        woliToSerialMap.put('' + termIdToWoliIdMap.get(parentAsset.Plc_TermId__c).Id, '' + parentAsset.Plc_StockSerial__c);
                    }
                }*/
            }
            
            /* END
             * Woli of products to retrieve 
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Retrieving child work order line items
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Getting work order line items of given products
            for (WorkOrderLineItem woliAccessory: [SELECT Id, LineItemNumber, toLabel(Status), Plc_TermId__r.Name,
                                                          WorkOrder.Plc_LegacyAccountId__c, AssetId, Plc_ReplacedBy__c,
                                                          Plc_ReplacedBy__r.Name, Plc_TermId__r.Plc_TermIdCode__c,
                                                          ParentWorkOrderLineItemId, Plc_Quantity__c,
                                                          Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                          Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                          Plc_StockSerial__r.Plc_DllSerialNumber__c,
                                                          Asset.SerialNumber, Asset.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                          Asset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                          Asset.Plc_StockSerial__r.Plc_DllSerialNumber__c,
                                                          Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name,
                                                          Plc_SerialNumber__c, Plc_OperationType__c, Plc_StockSerial__c,
                                                          Plc_ExternalCatalogItem__r.Plc_ProductSku__c,
                                                          Plc_ExternalCatalogItem__r.Bit2Shop__Required_Serial__c,
                                                          toLabel(Plc_ExternalCatalogItem__r.Plc_Category__c),
                                                          toLabel(Plc_ExternalCatalogItem__r.Plc_Subcategory__c),
                                                          Plc_ExternalCatalogItem__r.B2WExtCat__External_Catalog_Item_Name__c,
                                                          Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name,
                                                          Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c, 
                                                          Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,
                                                          Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c
                                                   FROM WorkOrderLineItem
                                                   WHERE WorkOrderId = :workOrderId AND
                                                         ParentWorkOrderLineItemId != '' AND
                                                         //FB 20190711 NEXIPLC-702 [START]
                                                         Status = 'Executed'
                                                         //FB 20190711 NEXIPLC-702 [END]
                                                   ORDER BY LineItemNumber ASC]) {

                //Populating woli wrapper to send back to client
                WorkOrderLineItemWrp woliAccessoryWrp = new WorkOrderLineItemWrp();
                woliAccessoryWrp.id = woliAccessory.Id;
                woliAccessoryWrp.parentWorkOrderLineItemId = woliAccessory.ParentWorkOrderLineItemId;
                //woliAccessoryWrp.lineItemNumber = translationMap.get('WorkOrderLineItem') 
                //                                  + ' • ' 
                //                                  + woliAccessory.LineItemNumber
                //                                  + ' • ';
                woliAccessoryWrp.lineItemNumber = woliAccessory.LineItemNumber;
                woliAccessoryWrp.category = woliAccessory.Plc_ExternalCatalogItem__r.Plc_Category__c;
                woliAccessoryWrp.subCategory = woliAccessory.Plc_ExternalCatalogItem__r.Plc_Subcategory__c;
                woliAccessoryWrp.externalCatalogItemId = woliAccessory.Plc_ExternalCatalogItem__c;
                woliAccessoryWrp.productSku = woliAccessory.Plc_ExternalCatalogItem__r.Plc_ProductSku__c;
                woliAccessoryWrp.serialId = woliAccessory.Asset.Plc_StockSerial__c;
                //Getting serial to show
                woliAccessoryWrp.serialNumber = retrieveSerialFromStockSerial(woliAccessory.Asset.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                                              woliAccessory.Asset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                                              woliAccessory.Asset.Plc_StockSerial__r.Plc_DllSerialNumber__c);
                if (String.isBlank(woliAccessoryWrp.serialNumber)) {
                    woliAccessoryWrp.serialNumber = woliAccessory.Plc_SerialNumber__c;
                }
                woliAccessoryWrp.status = woliAccessory.Status;
                woliAccessoryWrp.operationType = woliAccessory.Plc_OperationType__c;
                woliAccessoryWrp.termIdName = woliAccessory.Plc_TermId__r.Name;
                woliAccessoryWrp.termId = woliAccessory.Plc_TermId__c;
                woliAccessoryWrp.termIdCode = woliAccessory.Plc_TermId__r.Plc_TermIdCode__c;
                woliAccessoryWrp.requestedQty = woliAccessory.Plc_Quantity__c; 
                woliAccessoryWrp.requiredSerial = woliAccessory.Plc_ExternalCatalogItem__r.Bit2Shop__Required_Serial__c;
                //Adding accessory asset to related set
                if (String.isNotEmpty(woliAccessory.AssetId)) {
                    foundAccessoryAssetSet.add(woliAccessory.AssetId);
                }

                if (woliAccessory.Plc_OperationType__c == 'ToRemove' ||
                    woliAccessory.Plc_OperationType__c == 'ToDeactivate' ||
                    woliAccessory.Plc_OperationType__c == 'ToSubstitute' || 
                    woliAccessory.Plc_OperationType__c == 'ToSubstituteCorr') {
                    if (String.isNotBlank(woliAccessory.Asset.Plc_StockSerial__c)) {
                        woliToSerialMap.put(woliAccessory.Id, woliAccessory.Asset.Plc_StockSerial__c);
                    }
                }

                if (woliAccessory.Plc_OperationType__c == 'ToSubstitute' || 
                    woliAccessory.Plc_OperationType__c == 'ToSubstituteCorr') {
                    //woliAccessoryWrp.lineItemNumber += woliAccessory.Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name;
                    woliAccessoryWrp.productName = woliAccessory.Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name;
                    woliAccessoryWrp.replacedBySerial = retrieveSerialFromStockSerial(woliAccessory.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                                                      woliAccessory.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                                                      woliAccessory.Plc_StockSerial__r.Plc_DllSerialNumber__c);
                    if (String.isBlank(woliAccessoryWrp.replacedBySerial)) {
                        woliAccessoryWrp.replacedBySerial = woliAccessory.Plc_SerialNumber__c;
                    }
                    woliAccessoryWrp.replacedBySerialId = woliAccessory.Plc_StockSerial__c;
                    woliAccessoryWrp.replacedByProductSku = woliAccessory.Plc_ExternalCatalogItem__r.Plc_ProductSku__c;
                    woliAccessoryWrp.replacedByExternalCatalogItemId = woliAccessory.Plc_ExternalCatalogItem__c;woliAccessoryWrp.replacedByProductName = woliAccessory.Plc_ExternalCatalogItem__r.B2WExtCat__External_Catalog_Item_Name__c;woliAccessoryWrp.productSku = woliAccessory.Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c;woliAccessoryWrp.category = woliAccessory.Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c;woliAccessoryWrp.subCategory = woliAccessory.Asset.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c;
                    foundSerialSubstituteSet.add(woliAccessory.Plc_SerialNumber__c);
                } else {
                    //woliAccessoryWrp.lineItemNumber += (woliAccessory.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name == null
                    //                                   ? '' : woliAccessory.Plc_StockSerial__r.Bit2Shop__Product_Stock_Id__r.Name);
                    woliAccessoryWrp.productName = woliAccessory.Plc_ExternalCatalogItem__r.B2WExtCat__External_Catalog_Item_Name__c;

                }
                woliAccessoriesList.add(woliAccessoryWrp);
            }
            /* END
             * Retrieving child work order line items
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Retrieving Shipment Line Items and activities
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            String inboundShipmentRTId = Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName()
                                                                                        .get(Plc_Constants.B2S_ShipmentLineItem.RecordType_InboundShipments)
                                                                                        .getRecordTypeId();

            for (Bit2Shop__Shipment_Line_Item__c sli : [SELECT Id, Plc_StockSerial__c, Bit2Shop__Status__c,
                                                               Bit2Shop__Received_Status__c, 
                                                               Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Destination_Warehouse_Id__r.Name
                                                        FROM Bit2Shop__Shipment_Line_Item__c
                                                        WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Plc_WorkOrder__c = :workOrderId AND
                                                              Plc_StockSerial__c IN :woliToSerialMap.values() AND
                                                              Bit2Shop__Shipment_Id__r.RecordTypeId = :inboundShipmentRTId AND
                                                              (Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Status__c != :Plc_Constants.B2S_StockOrder.B2S_Status_Generated)]) {

                if (serialToShipmentLineItemMap.containsKey(sli.Plc_StockSerial__c)) {
                    if (sli.Bit2Shop__Status__c != serialToShipmentLineItemMap.get(sli.Plc_StockSerial__c).Bit2Shop__Status__c && sli.Bit2Shop__Status__c == 'Pending') {
                        serialToShipmentLineItemMap.put(sli.Plc_StockSerial__c, sli);
                    }
                } else {
                    serialToShipmentLineItemMap.put(sli.Plc_StockSerial__c, sli);
                }

            }
            //Retrieving activities
            for (wrts_prcgvr__Activity__c activity : [SELECT Id, wrts_prcgvr__ObjectId__c, Plc_ChecklistExecuted__c 
                                                      FROM wrts_prcgvr__Activity__c
                                                      WHERE RecordTypeId = :Plc_Utils.getRecordTypeId('Plc_Report', 'wrts_prcgvr__Activity__c') AND wrts_prcgvr__ObjectId__c IN :woliToSerialMap.values()
                                                      ORDER BY LastModifiedDate 
                                                      DESC NULLS LAST]) {
                if (activity.Plc_ChecklistExecuted__c == false) {
                    serialToOpenActivityMap.put(activity.wrts_prcgvr__ObjectId__c, activity.Id);
                } else {
                    serialToClosedActivityMap.put(activity.wrts_prcgvr__ObjectId__c, activity.Id);
                }
            }

            //retrieving stock serials
            for (Bit2Shop__Stock_Serials2__c stockSerial : [SELECT Id, Name, Bit2Shop__Status__c, Plc_ProductSku__c,
                                                                   Plc_ManufacturerSerialNumber__c, Plc_EncodedSerialNumber__c, Plc_DllSerialNumber__c,
                                                                   Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                                                                   Bit2Shop__Warehouse_Id__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__c,
                                                                   Bit2Shop__Product_Stock_Id__r.Name,
                                                                   Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c
                                                            FROM Bit2Shop__Stock_Serials2__c
                                                            WHERE Id In :woliToSerialMap.values()]) {

                stockSerialsMap.put(stockSerial.Id, stockSerial);
            }

            /* END
             * Retrieving Shipment Line Items and activities
             * ----------------------------------------------------------------------------------------------------------------------------------- */


            /* START
             * Retrieving child asset
             * ----------------------------------------------------------------------------------------------------------------------------------- */

             woliAccessoriesList.addAll(retrieveChildAssets(assetIdToWoliMap, assetIdToWoliMap.keySet(), foundAccessoryAssetSet, foundSerialSubstituteSet));
            /* END
             * Retrieving child asset
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //If a warehouse was found then return information to client
            if (woList.size() > 0) {
                response.put('workOrder', woList.get(0));
                response.put('warehouseAlias', woList.get(0).Plc_LegacyWarehouseId__c);
                response.put('woStatus', woList.get(0).Status);
                response.put('servicePointLegacyId', woList.get(0).Plc_LegacyServicePointId__c);

                //if a work order is a deactivation then component is in read only mode
                if (woList.get(0).RecordType.DeveloperName == 'Deactivation') {
                    response.put('disableNewProductItem', true);
                } else if (woList.get(0).RecordType.DeveloperName == 'Uninstallation') {
                    response.put('disableNewProductItem', true);
                } else {
                    response.put('disableNewProductItem', false);
                }
                
                if (woList.get(0).RecordType.DeveloperName == 'Installation') {
                    response.put('disableNewProductAsset', true);
                } else {
                    response.put('disableNewProductAsset', false);
                }
            }

            //returning information to client
            response.put('stockSerialsMap', stockSerialsMap);
            response.put('serialToOpenActivityMap', serialToOpenActivityMap);
            response.put('serialToClosedActivityMap', serialToClosedActivityMap);
            response.put('woliToSerialMap', woliToSerialMap);
            response.put('serialToShipmentLineItemMap', serialToShipmentLineItemMap);
            response.put('woliAccessoriesList', JSON.serialize(woliAccessoriesList));
            response.put('woliProductsMap', JSON.serialize(woliProductsMap));
            response.put('availableOperationTypesMap', availableOperationTypesMap);
            
            for (String key : availableOperationTypesMap.keySet()) {
                if (foundOperationsSet.contains(key)) {
                    accessoryAvailableOperationTypesMap.put(key, availableOperationTypesMap.get(key));
                }
            }
            response.put('accessoryAvailableOperationTypesMap', accessoryAvailableOperationTypesMap);
        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to get available models from warehouse indicated by work order
     *
     * @code 03
     *
     * @param warehouseAlias               Warehouse alias on given work order
     * @param searchKey                    Search key string
     * @param category                     Category in which searching
     * @param consumedSerials              Serials that must be excluded from search
     * @param productId                    External catalog item id from which an accessory is being added
     * @param consumedExternalCatalogItems External catalog items to exclude
     * @param subItemSolutionId            Solution of substituted item
     * @return                             Available models
     */
    @AuraEnabled
    public static Map<String, Object> retrieveAvailableModels(String warehouseAlias, String searchKey, 
                                                              String category, List<String> consumedSerials,
                                                              String productId, List<String> consumedExternalCatalogItems,
                                                              String subItemSolutionId){

        Map<String, Object> response = new Map<String, Object>();
        Set<String> solutionToExcludeSet = new Set<String>();
        Set<String> skuToExcludeSet = new Set<String>();
        response.put('error', false);
        //redefining search key in order to be used with LIKE operator
        searchKey = '%' + searchKey + '%';
        try {
            List<Bit2Shop__Warehouse__c> warehousesList = [SELECT Id, Name
                                                           FROM Bit2Shop__Warehouse__c
                                                           WHERE Plc_Alias__c = :warehouseAlias
                                                           LIMIT 1];

            //Stock serials contained in the given warehouse
            List<Bit2Shop__Stock_Serials2__c> availableStockSerialsList = new List<Bit2Shop__Stock_Serials2__c>();
            List<Bit2Shop__Product_Stock__c> availableProductStocksList = new List<Bit2Shop__Product_Stock__c>();
            Set<String> compatibleAccessoriesSet = new Set<String>();
            if (warehousesList.size() > 0) {
                //If product id is not empty then it means that it is needed to retrieve accessories
                //which are actually compatible to given product
                if (String.isNotBlank(productId)) {
                    for(Plc_ProductCompatibility__c productCompatibility : [SELECT Id, Plc_Accessory__c
                                                                            FROM Plc_ProductCompatibility__c
                                                                            WHERE Plc_Product__c = :productId]) {
                        compatibleAccessoriesSet.add(productCompatibility.Plc_Accessory__c);
                    }
                }
                //Getting consumed solutions and sku 
                for (B2WExtCat__External_Catalog_Item__c model : [SELECT Id, Plc_Solution__c,
                                                                         Plc_ProductSku__c
                                                                  FROM B2WExtCat__External_Catalog_Item__c
                                                                  WHERE Id IN :consumedExternalCatalogItems]) {

                    solutionToExcludeSet.add(model.Plc_Solution__c);
                    skuToExcludeSet.add(model.Plc_ProductSku__c);
                }

                //System.debug('### wh ' + warehousesList.get(0).Id );
                //System.debug('### product ' + productId);
                //System.debug('### category ' + category);
                //System.debug('### subItemSolutionId ' + subItemSolutionId);
                //System.debug('### skuToExclude ' + skuToExcludeSet);
                //System.debug('### solutionToExcludeSet ' + solutionToExcludeSet);

                availableStockSerialsList = Database.query(composeStockSerialsQuery(warehousesList.get(0).Id, productId, category, subItemSolutionId));
                availableProductStocksList = Database.query(composeProductStockQuery(warehousesList.get(0).Id, productId, category, subItemSolutionId));
            }

            response.put('availableStockSerialsList', availableStockSerialsList);
            response.put('availableProductStocksList', availableProductStocksList);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to save items
     *
     * @code 04
     *
     * @param wo           Starting work order object
     * @param woliAsString Serialized work order line items to handle
     * @return             Ok if everything goes well
     */
    @AuraEnabled
    public static Map<String, Object> saveItems(WorkOrder wo, String woliAsString){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        Savepoint sp = Database.setSavepoint();
        //Declaring needed structures
        List<WorkOrderLineItem> woliAccessoryToInsertList = new List<WorkOrderLineItem>();
        Map<Integer, WorkOrderLineItem> indexToWoliProductMap = new Map<Integer, WorkOrderLineItem>();
        Map<Integer, List<WorkOrderLineItemWrp>> indexToWoliAccessoriesMap = new Map<Integer, List<WorkOrderLineItemWrp>>();
        
        //Loop in the list of work order line items got from client
        try {

            WorkOrderLineItem woliAccessoryToInsert;
            WorkOrderLineItem woliProductToInsert;
            Integer productIndex = 0;

            //Parsing back list of work order line items to check
            List<WorkOrderLineItemWrp> woliWrpList = (List<WorkOrderLineItemWrp>)JSON.deserialize(woliAsString, List<WorkOrderLineItemWrp>.class);
            
            for (WorkOrderLineItemWrp woliProduct : woliWrpList) {
                //If id is blank it means that the work order line item must be created
                if (String.isEmpty(woliProduct.id) && woliProduct.operationType != 'NoOperation') {
                    woliProductToInsert = new WorkOrderLineItem();
                    woliProductToInsert.WorkOrderId = wo.Id;
                    woliProductToInsert.Status = 'Executed';
                    woliProductToInsert.Plc_Quantity__c = woliProduct.requestedQty;
                    woliProductToInsert.Plc_TermId__c = woliProduct.termId;
                    woliProductToInsert.Plc_ExternalTermId__c = woliProduct.termIdCode;
                    woliProductToInsert.Plc_OperationType__c = woliProduct.operationType;
                    if (String.isNotBlank(woliProduct.assetId)) {
                        woliProductToInsert.AssetId = woliProduct.assetId;
                    }
                    if (woliProduct.operationType == 'ToSubstitute' || woliProduct.operationType == 'ToSubstituteCorr') {
                        woliProductToInsert.Plc_StockSerial__c = woliProduct.replacedBySerialId;woliProductToInsert.Plc_SerialNumber__c = woliProduct.replacedBySerial;woliProductToInsert.Plc_ReplacedBy__c = woliProduct.replacedBySerialId;woliProductToInsert.Plc_ExternalCatalogItem__c = woliProduct.replacedByExternalCatalogItemId;woliProductToInsert.Plc_ReferenceExternalCatalogItem__c = woliProduct.replacedByProductSku;
                    } else {
                        woliProductToInsert.Plc_ExternalCatalogItem__c = woliProduct.externalCatalogItemId;
                        woliProductToInsert.Plc_ReferenceExternalCatalogItem__c = woliProduct.productSku;
                        woliProductToInsert.Plc_StockSerial__c = woliProduct.serialId;
                        woliProductToInsert.Plc_SerialNumber__c = woliProduct.serialNumber;
                    }

                    indexToWoliProductMap.put(productIndex, woliProductToInsert);

                    if (!woliProduct.childWorkOrderLineItems.isEmpty()) {
                        indexToWoliAccessoriesMap.put(productIndex, woliProduct.childWorkOrderLineItems);
                    }

                } else {

                    for (WorkOrderLineItemWrp woliAccessory : woliProduct.childWorkOrderLineItems) {
                        if (String.isEmpty(woliAccessory.id)) {
                            //If operation type is NoOperation then nothing changes
                            if (woliAccessory.operationType != 'NoOperation') {
                                woliAccessoryToInsert = new WorkOrderLineItem();
                                woliAccessoryToInsert.WorkOrderId = wo.Id;
                                woliAccessoryToInsert.ParentWorkOrderLineItemId = woliProduct.id;
                                woliAccessoryToInsert.Plc_Parent__c = woliProduct.id;
                                woliAccessoryToInsert.Status = 'Executed';
                                woliAccessoryToInsert.Plc_Quantity__c = woliAccessory.requestedQty;
                                woliAccessoryToInsert.Plc_TermId__c = woliAccessory.termId;
                                woliAccessoryToInsert.Plc_ExternalTermId__c = woliAccessory.termIdCode;
                                woliAccessoryToInsert.Plc_OperationType__c = woliAccessory.operationType;
                                woliAccessoryToInsert.AssetId = woliAccessory.assetId;
                                //In this case it means that accessory is being replaced
                                if (woliAccessory.operationType == 'ToSubstitute' || woliAccessory.operationType == 'ToSubstituteCorr') {
                                    woliAccessoryToInsert.Plc_StockSerial__c = woliAccessory.replacedBySerialId;
                                    woliAccessoryToInsert.Plc_SerialNumber__c = woliAccessory.replacedBySerial;
                                    woliAccessoryToInsert.Plc_ReplacedBy__c = woliAccessory.replacedBySerialId;
                                    woliAccessoryToInsert.Plc_ExternalCatalogItem__c = woliAccessory.replacedByExternalCatalogItemId;
                                    woliAccessoryToInsert.Plc_ReferenceExternalCatalogItem__c = woliAccessory.replacedByProductSku;
                                } else {
                                    woliAccessoryToInsert.Plc_ExternalCatalogItem__c = woliAccessory.externalCatalogItemId;woliAccessoryToInsert.Plc_ReferenceExternalCatalogItem__c = woliAccessory.productSku;woliAccessoryToInsert.Plc_StockSerial__c = woliAccessory.serialId;woliAccessoryToInsert.Plc_SerialNumber__c = woliAccessory.serialNumber;
                                }
                                woliAccessoryToInsertList.add(woliAccessoryToInsert);
                            }
                        }
                    }
                }
                productIndex++;
            }

            //for testing
            //System.debug(JSON.serializePretty(indexToWoliProductMap.values()));
            
            if (indexToWoliProductMap.values().size() > 0) {
                insert indexToWoliProductMap.values();
            }

            for (Integer key : indexToWoliProductMap.keySet()){
                if (indexToWoliAccessoriesMap.containsKey(key)) {
                    for (WorkOrderLineItemWrp woliAccessory : indexToWoliAccessoriesMap.get(key)) {
                        if (String.isEmpty(woliAccessory.id)) {
                            woliAccessoryToInsert = new WorkOrderLineItem();
                            woliAccessoryToInsert.WorkOrderId = wo.Id;
                            woliAccessoryToInsert.ParentWorkOrderLineItemId = indexToWoliProductMap.get(key).id;
                            woliAccessoryToInsert.Plc_Parent__c = indexToWoliProductMap.get(key).id;
                            woliAccessoryToInsert.Status = 'Executed';
                            woliAccessoryToInsert.Plc_Quantity__c = woliAccessory.requestedQty;
                            woliAccessoryToInsert.Plc_TermId__c = woliAccessory.termId;
                            woliAccessoryToInsert.Plc_ExternalTermId__c = woliAccessory.termIdCode;
                            woliAccessoryToInsert.Plc_OperationType__c = woliAccessory.operationType;
                            woliAccessoryToInsert.Plc_ExternalCatalogItem__c = woliAccessory.externalCatalogItemId;
                            woliAccessoryToInsert.Plc_ReferenceExternalCatalogItem__c = woliAccessory.productSku;
                            woliAccessoryToInsert.Plc_StockSerial__c = woliAccessory.serialId;
                            woliAccessoryToInsert.Plc_SerialNumber__c = woliAccessory.serialNumber;
                            woliAccessoryToInsert.AssetId = woliAccessory.assetId;
                            woliAccessoryToInsertList.add(woliAccessoryToInsert);
                        }
                    }
                }
            }

            if (woliAccessoryToInsertList.size() > 0) {
                insert woliAccessoryToInsertList;
            }
            List<WorkOrderLineItem> woliInserted = new List<WorkOrderLineItem>();
            woliInserted.addAll(indexToWoliProductMap.values());
            woliInserted.addAll(woliAccessoryToInsertList);

            if (woliInserted.size() > 0) {
                Plc_WorkOrderApxAct.oncloseWorkOrderWithFilters(new List<WorkOrder>{wo}, woliInserted);
            }

            //response.put('woliAccessoryToInsertList', woliAccessoryToInsertList);

        } catch (Exception e) {
            Database.rollback(sp);
            response.put('error', true);
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to save items
     *
     * @code 0x
     *
     * @param wo                         Starting work order object
     * @param woliAccessoryToInsertList  Accessories to insert
     * @return                           Ok if everything goes well
     */
    @AuraEnabled
    public static Map<String, Object> saveAccessories(WorkOrder wo, List<WorkOrderLineItem> woliAccessoryToInsertList) { 

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        Savepoint sp = Database.setSavepoint();
        
        try {

            //for testing
            //System.debug(JSON.serializePretty(woliAccessoryToInsertList));

            if (woliAccessoryToInsertList.size() > 0) {
                insert woliAccessoryToInsertList;
                Plc_WorkOrderApxAct.oncloseWorkOrderWithFilters(new List<WorkOrder>{wo}, woliAccessoryToInsertList);
            }
            
        } catch (Exception e) {
            Database.rollback(sp);
            response.put('error', true);
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Helper method used to compose the query for retrieving the list of stock serials
     *
     * @05
     *
     * @param  warehouseId       Id of warehouse in which looking for material
     * @param  productId         Id of product on which checking the compatibility
     * @param  category          Indicates which category the material belongs to
     * @param  subItemSolutionId Solution of substituted item
     * @return                   String that represents the SOQL query
     */
    private static String composeStockSerialsQuery(String warehouseId, String productId, String category, String subItemSolutionId) {

        String query;
        query =  ' SELECT Id, Name, Plc_ManufacturerSerialNumber__c, Plc_EncodedSerialNumber__c,' 
               +       ' Plc_DllSerialNumber__c, Plc_Manufacturer__c, Plc_ProductSku__c, Plc_Model__c,' 
               +       ' Plc_TermId__c, Plc_TermId__r.Name, Plc_TermId__r.Plc_TermIdCode__c, '
               +       ' Bit2Shop__Product_Stock_Id__r.Name,' 
               +       ' Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Plc_Solution__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,' 
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c'
               + ' FROM Bit2Shop__Stock_Serials2__c '
               + ' WHERE Bit2Shop__Warehouse_Id__c = \'' + warehouseId + '\' AND'
               +       ' Id NOT IN :consumedSerials AND'
               +       ' Bit2Shop__Status__c = \'Withdrawn\' AND'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c = true AND'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = \'' + category + '\' AND'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c NOT IN :solutionToExcludeSet AND'
               +       ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c NOT IN :skuToExcludeSet AND'
               +       ' (Plc_Model__c LIKE :searchKey OR'
               +       '  Plc_ProductSku__c LIKE :searchKey OR'
               +       '  Plc_ManufacturerSerialNumber__c LIKE :searchKey OR'
               +       '  Plc_EncodedSerialNumber__c LIKE :searchKey OR'
               +       '  Plc_DllSerialNumber__c LIKE :searchKey OR'
               +       '  Plc_Manufacturer__c LIKE :searchKey OR'
               +       '  Bit2Shop__Product_Stock_Id__r.Plc_Solution__c LIKE :searchKey)';
        //In case the product id is not empty it means that accessories must be retrieved according to compatibility
        if (String.isNotBlank(productId)) {
            query += ' AND Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c IN :compatibleAccessoriesSet';
        }

        //In the case an item is being substituted check also for the same solution
        if (String.isNotBlank(subItemSolutionId)) {
            query += ' AND Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c = \'' + subItemSolutionId + '\'';
        }

        if (category == 'Product') {
            query += ' AND (Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = \'Router\'';
            query += ' OR Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = \'Switch\')';
        }
        query += ' ORDER BY Plc_Model__c';
        return query;
    }

    /**
     * Helper method used to compose the query for retrieving the list of Product Stock
     *
     * @06
     * 
     * @param  warehouseId       Id of warehouse in which looking for material
     * @param  productId         Id of product on which checking the compatibility
     * @param  category          Indicates which category the material belongs to
     * @param  subItemSolutionId Solution of substituted item
     * @return                   String that represents the SOQL query
     */
    private static String composeProductStockQuery(String warehouseId, String productId, String category, String subItemSolutionId) {

        String query;
        query =  ' SELECT Id, Name, Plc_ProductSku__c,'
               +        ' Plc_Solution__c,'
               +        ' Plc_Manufacturer__c, Plc_AvailableQty__c,'
               +        ' Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,'
               +        ' Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,'
               +        ' Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,'
               +        ' Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c, '
               +        ' Bit2Shop__External_Catalog_Item_Id__r.Plc_MinimumStock__c'
               + ' FROM Bit2Shop__Product_Stock__c'
               + ' WHERE Bit2Shop__Warehouse_Id__c = \'' + warehouseId + '\' AND'
               +       ' Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c = false AND'
               +       ' Plc_AvailableQty__c > 0 AND'
               +       ' Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = \'' + category + '\' AND'
               +       ' Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c NOT IN :solutionToExcludeSet AND'
               +       ' Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c NOT IN :skuToExcludeSet AND'
               +       ' (Name LIKE :searchKey OR'
               +       '  Plc_Manufacturer__c LIKE :searchKey OR'
               +       '  Plc_ProductSku__c LIKE :searchKey OR'
               +       '  Plc_Solution__c LIKE :searchKey)';

        //In case the product id is not empty it means that accessories must be retrieved according to compatibility
        if (String.isNotBlank(productId)) {
            query += ' AND Bit2Shop__External_Catalog_Item_Id__c IN :compatibleAccessoriesSet';
        }

        //In the case an item is being substituted check also for the same solution
        if (String.isNotBlank(subItemSolutionId)) {
            query += ' AND Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c = \'' + subItemSolutionId + '\'';
        }

        if (category == 'Product') {
            query += ' AND (Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = \'Router\'';
            query += ' OR Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = \'Switch\')';
        }

        query += ' ORDER BY Name';
        return query;
    }

    /**
     * Retrieves a map containing the picklist values of specified field/object
     *
     * @code 07
     * 
     * @param  sObjectType       Name of object from which getting the field
     * @param  fieldName         Name of the field from which getting values
     * @param foundOperationsSet Operations retrieved from Work Order Configuration
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
     * Method used in order to get assets of products (router, switch) of given service point
     *
     * @code 08
     * 
     * @param servicePointLegacyId Id of service point in which searching assets
     * @param searchKey            Search key string
     * @param consumedAsset        Assets that must be excluded from search
     * @return                     Available assets
     */
    @AuraEnabled
    public static Map<String, Object> retrieveAvailableAssets(String servicePointLegacyId, String searchKey,
                                                              List<String> consumedAssets) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        //redefining search key in order to be used with LIKE operator
        searchKey = '%' + searchKey + '%';

        try {

            List<Asset> assetList = [SELECT Id, Name, Plc_StockSerial__c,
                                            Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                            Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                            Plc_StockSerial__r.Plc_DllSerialNumber__c,
                                            SerialNumber, Plc_TermId__r.Name, Plc_TermId__r.Plc_TermIdCode__c,
                                            Plc_ProductStock__r.Plc_ProductSku__c,
                                            Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,
                                            Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,
                                            Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,
                                            Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c,
                                            Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c
                                     FROM Asset
                                     WHERE Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c = 'Product' AND
                                           Id NOT IN :consumedAssets AND
                                           Name LIKE :searchKey AND 
                                           Status = 'Installed' AND
                                           Plc_ServicePointLegacyId__c = :servicePointLegacyId AND
                                           (Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = 'Router' OR
                                            Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = 'Switch')];
            response.put('assetList', assetList);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to get child assets of a selected asset
     *
     * @code 09
     * 
     * @param assetId Id of asset from which retrieving children
     * @return        Child assets
     */
    @AuraEnabled
    public static Map<String, Object> retrieveChildStoreProductAssets(String assetId) {
        Map<String, Object> response = new Map<String, Object>();
        response.put('woliAccessoriesList', JSON.serialize(retrieveChildAssets(new Map<String, String>(), 
                                                                               new Set<String>{assetId},
                                                                               new Set<String>(),
                                                                               new Set<String>())));
        return response;
    }

    /**
     * Method used in order to get child assets from given parameters
     *
     * @code 10
     * 
     * @param assetIdToWoliMap Asset to woli map
     * @param parentAssetSet Set containing found parent assets
     * @param assetToExcludeSet Set containing assets to exclude
     * @param serialsToExclude Set containing serials to exclude
     * 
     * @return                 Child assets
     */
    private static List<WorkOrderLineItemWrp> retrieveChildAssets(Map<String, String> assetIdToWoliMap, Set<String> parentAssetSet, 
                                                                  Set<String> assetToExcludeSet, Set<String> serialsToExclude) {

        List<WorkOrderLineItemWrp> woliAccessoriesList = new List<WorkOrderLineItemWrp>();
        Map<String, String> translationMap = retrieveTranslationMap();

        //Retrieving child assets related to found products
        for(Asset childAsset : [SELECT Id, Name, Parent.SerialNumber, Plc_TermId__r.Name, Quantity, SerialNumber, Plc_StockSerial__c,
                                       toLabel(Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c),
                                       toLabel(Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c),
                                       Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c,
                                       Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c,
                                       Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,
                                       Plc_TermId__r.Plc_TermIdCode__c, ParentId,
                                       Plc_ProductStock__r.Name,
                                       Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                       Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                       Plc_StockSerial__r.Plc_DllSerialNumber__c
                                 FROM Asset
                                 WHERE ParentId IN :parentAssetSet AND
                                       //Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c = true AND
                                       Id NOT IN :assetToExcludeSet AND
                                       SerialNumber NOT IN :serialsToExclude AND
                                       Status != 'Uninstalled']){

            //Setting child work order line items based on installed assets
            WorkOrderLineItemWrp woliAccessoryWrp = new WorkOrderLineItemWrp();
            //woliAccessoryWrp.lineItemNumber = translationMap.get('Asset') + ' • ' + childAsset.Name;
            woliAccessoryWrp.productName = childAsset.Plc_ProductStock__r.Name;
            woliAccessoryWrp.lineItemNumber = translationMap.get('Asset');

            if (assetIdToWoliMap.containsKey(childAsset.ParentId)) {
                woliAccessoryWrp.parentWorkOrderLineItemId = assetIdToWoliMap.get(childAsset.ParentId);
            } else {
                woliAccessoryWrp.parentWorkOrderLineItemId = childAsset.ParentId;
            }
            
            woliAccessoryWrp.category = childAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c;
            woliAccessoryWrp.subCategory = childAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c;
            woliAccessoryWrp.solutionId = childAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c;
            woliAccessoryWrp.externalCatalogItemId = childAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__c;
            woliAccessoryWrp.status = 'New';
            woliAccessoryWrp.serialId = childAsset.Plc_StockSerial__c;
            woliAccessoryWrp.serialNumber = retrieveSerialFromStockSerial(childAsset.Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,
                                                                          childAsset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c,
                                                                          childAsset.Plc_StockSerial__r.Plc_DllSerialNumber__c);
            woliAccessoryWrp.productSku = childAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c;
            woliAccessoryWrp.termIdName = childAsset.Plc_TermId__r.Name;
            woliAccessoryWrp.termId = childAsset.Plc_TermId__c;
            woliAccessoryWrp.termIdCode = childAsset.Plc_TermId__r.Plc_TermIdCode__c;
            woliAccessoryWrp.requestedQty = childAsset.Quantity;
            woliAccessoryWrp.assetId = childAsset.Id;
            woliAccessoryWrp.requiredSerial = childAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c;

            woliAccessoriesList.add(woliAccessoryWrp);
        }

        return woliAccessoriesList;
    }

    /**
     * Method used in order to manage Stock Order and Shipment Line Item
     *
     * @code 11
     * 
     * @param shipmentLineItemId Id of the target shipment line item
     * @param operation             Operation to do on the shipment line item
     * @return                   Ok if everything is ok
     */
    @AuraEnabled
    public static Map<String, Object> manageSLI(String shipmentLineItemId, String operation) {
        
        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        Savepoint sp = Database.setSavepoint();
        String errorMessage = '';

        try {
            
            Bit2Shop__Shipment_Line_Item__c shipmentLiteItem = [SELECT Id, Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Status__c,
                                                                       Bit2Shop__Target_Line_Item__c,
                                                                       Bit2Shop__Target_Line_Item__r.Bit2Shop__Received_Quantity__c,
                                                                       Bit2Shop__Target_Line_Item__r.Plc_NotReceivedQty__c,
                                                                       Bit2Shop__Target_Line_Item__r.Bit2Shop__Requested_Quantity__c
                                                                FROM Bit2Shop__Shipment_Line_Item__c
                                                                WHERE Id = :shipmentLineItemId];

            Bit2Shop__StockOrder__c stockOrder = new Bit2Shop__StockOrder__c(Id = shipmentLiteItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c);

            Bit2Shop__Shipment_Line_Item__c productSLI = new Bit2Shop__Shipment_Line_Item__c(
                                            Id = shipmentLiteItem.Bit2Shop__Target_Line_Item__c,
                Bit2Shop__Received_Quantity__c = shipmentLiteItem.Bit2Shop__Target_Line_Item__r.Bit2Shop__Received_Quantity__c,
                Plc_NotReceivedQty__c = shipmentLiteItem.Bit2Shop__Target_Line_Item__r.Plc_NotReceivedQty__c,
               Bit2Shop__Requested_Quantity__c = shipmentLiteItem.Bit2Shop__Target_Line_Item__r.Bit2Shop__Requested_Quantity__c);

            if (shipmentLiteItem.Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Status__c == Plc_Constants.B2S_StockOrder.B2S_Status_Assigned) {
                errorMessage = Plc_StockOrderApxAct.takeCharge(stockOrder, new Map<String, String>());
            }

            if (String.isBlank(errorMessage)) {
                productSLI.Bit2Shop__Requested_Quantity__c = productSLI.Bit2Shop__Requested_Quantity__c == null ? 1 :
                                                             productSLI.Bit2Shop__Requested_Quantity__c;
                if (operation == ACCEPT_ACTION) {
                    shipmentLiteItem.Bit2Shop__Received_Status__c = Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_Received;
                    shipmentLiteItem.Bit2Shop__Received_Quantity__c = 1;
                    productSLI.Bit2Shop__Received_Quantity__c = (productSLI.Bit2Shop__Received_Quantity__c == null) ? 1 : 
                                                                 productSLI.Bit2Shop__Received_Quantity__c + 1;
                } else if (operation == REFUSE_ACTION) {
                    shipmentLiteItem.Bit2Shop__Received_Status__c = Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_NotReceived;
                    shipmentLiteItem.Plc_NotReceivedQty__c = 1;
                    productSLI.Plc_NotReceivedQty__c = (productSLI.Plc_NotReceivedQty__c == null) ? 1 : 
                                                        productSLI.Plc_NotReceivedQty__c + 1;
                }
                shipmentLiteItem.Bit2Shop__Status__c = Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Closed;
            } else {
                throw new Plc_Exception(errorMessage + ': ID [' + stockOrder.Id +']');
            }
            
            update shipmentLiteItem;
            update productSLI;

        } catch (Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            response.put('error', true);
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to update a serial to withdrawn with selected contact
     *
     * @code 12
     * 
     * @param stockSerialId Id of the stock serial to update
     * @param contactId     Id of the contact to which bind the serial      
     * @return              Ok if everything is ok
     */
    @AuraEnabled
    public static Map<String, Object> changeSerialToWithdrawn(String stockSerialId, String contactId) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        Savepoint sp = Database.setSavepoint();

        try {

            Bit2Shop__Stock_Serials2__c stockSerial = new Bit2Shop__Stock_Serials2__c(Id = stockSerialId);
            stockSerial.Bit2Shop__Status__c = 'Withdrawn';
            stockSerial.Plc_Status2__c   = 'Sent';
            stockSerial.Plc_WithdrawnBy__c = contactId;

            update stockSerial;

        } catch (Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            response.put('error', true);
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to get technician who has withdrawn the selected serial
     *
     * @code 13
     * 
     * @param stockSerialId Id of the stock serial of which checking the technician
     * @return              Ok if everything is ok
     */
    @AuraEnabled
    public static Map<String, Object> retrieveWithdrawingTechnician(String stockSerialId) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

        Bit2Shop__Stock_Serials2__c stockSerial = [SELECT Id, Name, Plc_WithdrawnBy__c,
                                                          Plc_WithdrawnBy__r.Name
                                                   FROM Bit2Shop__Stock_Serials2__c
                                                   WHERE Id = :stockSerialId];

        response.put('ContactId', stockSerial.Plc_WithdrawnBy__c);
        response.put('ContactName', stockSerial.Plc_WithdrawnBy__r.Name);                                        

        } catch (Exception e) {
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            response.put('error', true);
            response.put('errorMsg', e.getMessage() + ' ' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to get child assets from given parameters
     *
     * @code 10
     * 
     * @param assetIdToWoliMap Asset to woli map
     * @param parentAssetSet Set containing found parent assets
     * @param assetToExcludeSet Set containing assets to exclude
     * @param serialsToExclude Set containing serials to exclude
     * 
     * @return                 Child assets
     */
    private static String retrieveSerialFromStockSerial(String manufacturerSerial, String dllSerial, String encodedSerial) {

        if (String.isNotBlank(manufacturerSerial)) {
            return manufacturerSerial;
        } else if (String.isNotBlank(dllSerial)) {
            return dllSerial;
        } else if (String.isNotBlank(encodedSerial)) {
            return encodedSerial;
        } else {
            return '';
        }
    }

    /*
     * Wrapper class used to store work order line items information
     */
    class WorkOrderLineItemWrp {
        String id;
        String externalCatalogItemId;
        String lineItemNumber;
        String parentWorkOrderLineItemId;
        String category;
        String subCategory;
        String solutionId;
        String status;
        String operationType;
        String serialId;
        String serialNumber;
        String productSku;
        String termIdName;
        String termId;
        String termIdCode;
        String assetId;
        Decimal requestedQty;
        String replacedBySerial;
        String replacedBySerialId;
        String replacedByExternalCatalogItemId;
        String replacedByProductSku;
        String replacedByProductName;
        String productName;
        Boolean requiredSerial; 
        List<WorkOrderLineItemWrp> childWorkOrderLineItems;

        public WorkOrderLineItemWrp(){
            this.id = '';
            this.externalCatalogItemId = '';
            this.lineItemNumber = '';
            this.parentWorkOrderLineItemId = '';
            this.category = '';
            this.subCategory = '';
            this.solutionId = '';
            this.status = '';
            this.serialId = '';
            this.serialNumber = '';
            this.productSku = '';
            this.termIdName= '';
            this.termId = '';
            this.termIdCode = '';
            this.assetId = '';
            this.requestedQty = 0;
            this.replacedBySerial = '';
            this.replacedBySerialId = '';
            this.replacedByExternalCatalogItemId = '';
            this.replacedByProductSku = '';
            this.replacedByProductName = '';
            this.productName = '';
            this.requiredSerial = false;
            this.childWorkOrderLineItems = new List<WorkOrderLineItemWrp>();
        }
    }
}