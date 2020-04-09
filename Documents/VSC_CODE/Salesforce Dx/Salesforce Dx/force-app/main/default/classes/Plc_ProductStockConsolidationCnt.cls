/** 
 * @author Francesco Bigoni
 * @date Creation 01/04/2019 
 * @description Controller of lightning component Plc_ProductStockConsolidation
 * @errorcode [ERR:CL-086YYZZ]
 *
 */
public class Plc_ProductStockConsolidationCnt {

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
        //Getting Product Stock labels
        Schema.DescribeSObjectResult productStockSchema = Bit2Shop__Product_Stock__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> productStockFieldsMap = productStockSchema.fields.getMap();
        response.put('Bit2Shop__Product_Stock__c', productStockSchema.getLabel());
        response.put('PluralBit2Shop__Product_Stock__c', productStockSchema.getLabelPlural());
        response.put('ProductStockName', productStockFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Plc_ProductSku__c', productStockFieldsMap.get('Plc_ProductSku__c').getDescribe().getLabel());
        response.put('Plc_Manufacturer__c', productStockFieldsMap.get('Plc_Manufacturer__c').getDescribe().getLabel());
        response.put('Plc_AvailableQty__c', productStockFieldsMap.get('Plc_AvailableQty__c').getDescribe().getLabel());
        response.put('Plc_OrderedQty__c', productStockFieldsMap.get('Plc_OrderedQty__c').getDescribe().getLabel());
        response.put('Bit2Shop__Stock_Qty__c', productStockFieldsMap.get('Bit2Shop__Stock_Qty__c').getDescribe().getLabel());
        response.put('Plc_UsableQty__c', productStockFieldsMap.get('Plc_UsableQty__c').getDescribe().getLabel());
        response.put('Plc_WithdrawnQty__c', productStockFieldsMap.get('Plc_WithdrawnQty__c').getDescribe().getLabel());
        response.put('Plc_ReservedQty__c', productStockFieldsMap.get('Plc_ReservedQty__c').getDescribe().getLabel());
        response.put('Plc_OtherQty__c', productStockFieldsMap.get('Plc_OtherQty__c').getDescribe().getLabel());
        //Getting External catalog item labels
        Schema.DescribeSObjectResult modelSchema = B2WExtCat__External_Catalog_Item__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> modelFieldsMap = modelSchema.fields.getMap();
        response.put('B2WExtCat__External_Catalog_Item__c', modelSchema.getLabel());
        response.put('B2WExtCat__External_Catalog_Item_Name__c', modelFieldsMap.get('B2WExtCat__External_Catalog_Item_Name__c').getDescribe().getLabel());
        Schema.DescribeSObjectResult warehouseSchema = Bit2Shop__Warehouse__c.SObjectType.getDescribe();
        response.put('Bit2Shop__Warehouse__c', warehouseSchema.getLabel());
        //Getting Product Stock Snapshot labels
        Schema.DescribeSObjectResult productStockSnapshotSchema = Plc_ProductStockSnapshot__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> productStockSnapshotFieldsMap = productStockSnapshotSchema.fields.getMap();
        response.put('Plc_ProductStockSnapshot__c', productStockSnapshotSchema.getLabel());
        response.put('PluralPlc_ProductStockSnapshot__c', productStockSnapshotSchema.getLabelPlural());
        return response;
    }

    /**
     * Retrieves list of Product Stock record according to given filters
     *
     * @code 02
     *
     * @param warehouseId Warehouse in which searching Product Stocks
     * @param searchKey   Search key
     * @return            List of Product Stocks
     */
    @AuraEnabled
    public static Map<String, Object> retrieveProductStocks(String warehouseId, String searchKey) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        //redefining search key in order to be used with LIKE operator

        try {

            List<Bit2Shop__Product_Stock__c> productStocksList = new List<Bit2Shop__Product_Stock__c>();

            productStocksList = composeProductStockQuery(warehouseId, searchKey);

            response.put('productStocksList', productStocksList);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-0860201] ' + e.getMessage());
        }
        return response;
    }

    /**
     * Method used to create Product Stock Snapshots of given warehouse
     *
     * @code 03
     * 
     * @param  warehouseId Warehouse in which looking for Product Stocks
     * @return             Success if everything is ok
     */
    @AuraEnabled
    public static Map<String, Object> createProductStockSnapshots(String warehouseId) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

            List<Bit2Shop__Product_Stock__c> productStocksList = new List<Bit2Shop__Product_Stock__c>();
            List<Plc_ProductStockSnapshot__c> productStockSnapshotsList = new List<Plc_ProductStockSnapshot__c>();
            Plc_ProductStockSnapshot__c newProductStockSnapshot;

            productStocksList = composeProductStockQuery(warehouseId, '');

            System.debug(productStocksList);

            for (Bit2Shop__Product_Stock__c productStock : productStocksList) {

                newProductStockSnapshot = new Plc_ProductStockSnapshot__c();

                newProductStockSnapshot.Plc_AvailableQty__c = productStock.Plc_AvailableQty__c;
                newProductStockSnapshot.Plc_ExternalCatalogItem__c = productStock.Bit2Shop__External_Catalog_Item_Id__c;
                newProductStockSnapshot.Plc_ReservedQty__c = productStock.Plc_ReservedQty__c;
                newProductStockSnapshot.Plc_ReservedQty__c = productStock.Plc_ReservedQty__c;
                newProductStockSnapshot.Plc_ShippedQty__c = productStock.Bit2Shop__Shipped_Qty__c;
                newProductStockSnapshot.Plc_StockQty__c = productStock.Bit2Shop__Stock_Qty__c;
                newProductStockSnapshot.Plc_UsableQty__c = productStock.Plc_UsableQty__c;
                newProductStockSnapshot.Plc_Warehouse__c = productStock.Bit2Shop__Warehouse_Id__c;
                newProductStockSnapshot.Plc_WithdrawnQty__c = productStock.Plc_WithdrawnQty__c;
                newProductStockSnapshot.Plc_OrderedQty__c = productStock.Plc_OrderedQty__c;
                newProductStockSnapshot.Plc_InventoryLevel__c = productStock.Bit2Shop__Inventory_Level__c;
                newProductStockSnapshot.Plc_ExternalPeriod__c = productStock.Plc_ExternalReferenceExternalCatalogItem__c;
                newProductStockSnapshot.Plc_ExternalPeriod__c = productStock.Plc_ExternalReferencePeriod__c;
                newProductStockSnapshot.Plc_ExternalWarehouse__c = productStock.Plc_ExternalWarehouse__c;
                newProductStockSnapshot.Plc_Note__c = productStock.Plc_Note__c;
                newProductStockSnapshot.Plc_Period__c = productStock.Bit2Shop__Period_Id__c;
                newProductStockSnapshot.Plc_Alias__c = productStock.Plc_Alias__c;
                newProductStockSnapshot.Plc_Property__c = productStock.Plc_Property__c;
                newProductStockSnapshot.Plc_PtsCode__c = productStock.Plc_PTSCode__c;
                newProductStockSnapshot.Plc_Solution__c = productStock.Plc_Solution__c;
                newProductStockSnapshot.Plc_Timestamp__c = System.now();

                productStockSnapshotsList.add(newProductStockSnapshot);
            }

            System.debug(productStockSnapshotsList);

            if (!productStockSnapshotsList.isEmpty()) {
                insert productStockSnapshotsList;
            }

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-0860301] ' + e.getMessage());
        }

        return response;
    }

    /**
     * Helper method used to retrieve Product Stocks
     *
     * @code 04
     * 
     * @param warehouseId Warehouse in which searching Product Stocks
     * @param searchKey   Search key
     * @return            List of Product Stocks
     */
    private static List<Bit2Shop__Product_Stock__c> composeProductStockQuery(String warehouseId, String searchKey) {

        searchKey = '%' + searchKey + '%';

        return [SELECT Id, Name, Plc_OrderedQty__c, Plc_Property__c,
                       Plc_ExternalReferenceExternalCatalogItem__c,
                       Bit2Shop__Warehouse_Id__c, Plc_ExternalReferencePeriod__c,
                       Plc_ProductSku__c, Plc_Manufacturer__c, Bit2Shop__Period_Id__c,
                       Bit2Shop__Stock_Qty__c, Plc_AvailableQty__c, Plc_Alias__c,
                       Plc_UsableQty__c, Plc_WithdrawnQty__c, Plc_Note__c,
                       Plc_OtherQty__c, Plc_ReservedQty__c, Plc_ExternalWarehouse__c,
                       Bit2Shop__Shipped_Qty__c, Bit2Shop__Inventory_Level__c,
                       Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                       Plc_PTSCode__c, Plc_Solution__c
                FROM Bit2Shop__Product_Stock__c
                WHERE Bit2Shop__Warehouse_Id__c = :warehouseId AND
                      Bit2Shop__External_Catalog_Item_Id__r.Bit2Shop__Required_Serial__c = false AND
                      (Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c LIKE :searchKey OR
                       Plc_Manufacturer__c LIKE :searchKey OR
                       Plc_ProductSku__c LIKE :searchKey)];
    }

    /**
     * Checks whether current user can access the wizard 
     *
     * @code 05
     * 
     * @return A message if there is an error
     */
    @AuraEnabled
    public static String preCheck(){

        if (FeatureManagement.checkPermission(Plc_Constants.CustomPermission.PlcProductStockConsolidation)) {
            return '';
        } else {
            return Label.Plc_AllAllUserForbiddenOperation;
        }
    }

}