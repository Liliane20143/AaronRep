/** 
 * @author Francesco Bigoni
 * @date Creation 22/01/2019
 * @version 1.0
 * @description Controller of lightning component Plc_StockSerialUpdate
 */
public without sharing class Plc_StockSerialUpdateCnt {

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
        response.put('Bit2Shop__Stock_Serials2__c', serialStockSchema.getLabel());
        response.put('Bit2Shop__Warehouse_Id__c', serialStockFieldsMap.get('Bit2Shop__Warehouse_Id__c').getDescribe().getLabel());
        response.put('Bit2Shop__Status__c', serialStockFieldsMap.get('Bit2Shop__Status__c').getDescribe().getLabel());
        response.put('Plc_Status2__c', serialStockFieldsMap.get('Plc_Status2__c').getDescribe().getLabel());
        //Getting External catalog item labels
        Schema.DescribeSObjectResult modelSchema =  B2WExtCat__External_Catalog_Item__c.SObjectType.getDescribe();
        response.put('B2WExtCat__External_Catalog_Item__c', modelSchema.getLabel());
        //Getting product Stock
        Schema.DescribeSObjectResult productStockSchema =  Bit2Shop__Product_Stock__c.SObjectType.getDescribe();
        response.put('Bit2Shop__Product_Stock__c', productStockSchema.getLabel());
        return response;
    }

    /**
    * Method used in order to get some utils and context data
    *
    * @code 02
    * 
    * @param stockSerialId Starting Stock Serial Id
    * @return Utils and context data
    */
    @AuraEnabled
    public static Map<String, Object> retrievePropertiesMap(String stockSerialId){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

            response.put('showInputWarehouse', FeatureManagement.checkPermission(Plc_Constants.customPermission.PlcEditStockSerial));

            //Getting current Stock Serial
            List<Bit2Shop__Stock_Serials2__c> stockSerialList = [SELECT Id, Name, Bit2Shop__Status__c, 
                                                                        Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,
                                                                        Plc_Status2__c, Bit2Shop__Warehouse_Id__c
                                                                 FROM Bit2Shop__Stock_Serials2__c
                                                                 WHERE Id = :stockSerialId];
            if (stockSerialList != null && stockSerialList.size() > 0) {
                response.put('stockSerial', stockSerialList.get(0));
                
                //Getting warehouse only if lookup is not empty
                if (String.isNotBlank(stockSerialList.get(0).Bit2Shop__Warehouse_Id__c)) {

                    List<Bit2Shop__Warehouse__c> warehouseList = [SELECT Id, Name, Plc_Tipology__c
                                                                  FROM Bit2Shop__Warehouse__c
                                                                  WHERE Id = :stockSerialList.get(0).Bit2Shop__Warehouse_Id__c];

                    if (warehouseList != null && warehouseList.size() > 0) {
                        response.put('currentWarehouse', warehouseList.get(0));
                    }
                }

                //Getting model only if lookup is not empty
                if (String.isNotBlank(stockSerialList.get(0).Bit2Shop__Product_Stock_Id__c)) {

                    List<B2WExtCat__External_Catalog_Item__c> modelList = [SELECT Id, B2WExtCat__External_Catalog_Item_Name__c
                                                                           FROM B2WExtCat__External_Catalog_Item__c
                                                                           WHERE Id = :stockSerialList.get(0).Bit2Shop__Product_Stock_Id__r
                                                                                                             .Bit2Shop__External_Catalog_Item_Id__c];
                    if (modelList != null && modelList.size() > 0) {
                        response.put('currentModel', modelList.get(0));
                    }
                }
                
            }

            //Getting and sending back picklist values
            response.put('statusAvailableOptionsMap', retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c', 'Bit2Shop__Status__c'));
            response.put('status2AvailableOptionsMap', retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c', 'Plc_Status2__c'));

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
        }
        return response;
    }

    /**
    * Method used to update Stock Serial
    *
    * @code 03
    * 
    * @param stockSerialId Starting Stock Serial Id
    * @return                Ok if everything goes well
    */
    @AuraEnabled
    public static Map<String, Object> updateStockSerial(Bit2Shop__Stock_Serials2__c stockSerial, String newWarehouseId, String newModelId,
                                                        String newModelName, String newStatus, String newStatus2){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

            Bit2Shop__Stock_Serials2__c stockSerialOldClone = stockSerial.clone();
            stockSerialOldClone.Id = stockSerial.Id;

            List<Bit2Shop__Product_Stock__c> productStockList = (List<Bit2Shop__Product_Stock__c>)
                                                                  retrieveAvailableProductStock(newWarehouseId, newModelId).get('productStockList');
            //A Product Stock was found in given warehouse
            if (productStockList.size() > 0) {
                stockSerial.Bit2Shop__Product_Stock_Id__c = productStockList.get(0).Id;
            } else {
                //Otherwise Product Stock will be created
                Bit2Shop__Product_Stock__c newProductStock = new Bit2Shop__Product_Stock__c();
                newProductStock.Name = newModelName;
                newProductStock.Bit2Shop__External_Catalog_Item_Id__c = newModelId;
                newProductStock.Bit2Shop__Warehouse_Id__c = newWarehouseId;

                insert newProductStock;

                stockSerial.Bit2Shop__Product_Stock_Id__c = newProductStock.Id;
            }

            //Setting warehouse
            if (stockSerial.Bit2Shop__Warehouse_Id__c != newWarehouseId) {
                stockSerial.Bit2Shop__Warehouse_Id__c = newWarehouseId;
            }
            //Setting status fields
            stockSerial.Bit2Shop__Status__c = newStatus;
            stockSerial.Plc_Status2__c = newStatus2;

            update stockSerial;

            //Updating Product Stocks Quantities
            Plc_Utils.productStockQties.updateProductStockQuantities(new Map<String, Bit2Shop__Stock_Serials2__c>{stockSerialOldClone.Id => stockSerialOldClone},
                                                                     new Map<String, Bit2Shop__Stock_Serials2__c>{stockSerial.Id => stockSerial});
            buildTransferRecords(stockSerialOldClone, stockSerial);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
        }
        return response;
    }

    /**
     * Method used to retrieve list of Product Stock according to given warehouse and model
     *
     * @code 04
     * @param  warehouseId Warehouse Id
     * @param  modelId     External Catalog Item Id
     * @return             List of Product Stock
     */
    @AuraEnabled
    public static Map<String, Object> retrieveAvailableProductStock(String warehouseId, String modelId){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        List<Bit2Shop__Product_Stock__c> productStockList = [SELECT Id
                                                             FROM Bit2Shop__Product_Stock__c
                                                             WHERE Bit2Shop__Warehouse_Id__c = :warehouseId AND 
                                                                   Bit2Shop__External_Catalog_Item_Id__c = :modelId];
        response.put('productStockList', productStockList);
        return response;
    }

    /**
     * Retrieves a map containing the picklist values of specified field/object
     *
     * @code 05
     * 
     * @param  sObjectType Name of object from which getting the field
     * @param  fieldName   Name of the field from which getting values
     * @return             Map containing pairs picklist values Api Name/Label
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
     * Methods used to build all records involved in the transfer actions such as stock orders, shipment, shipment
     * line items, ...
     *
     * @code 06
     * 
     * @param stockSerialOldClone Old Stock Serial before update (without Id)
     * @param stockSerialNew      New Stock Serial after update
     */
    private static void buildTransferRecords(Bit2Shop__Stock_Serials2__c stockSerialOldClone, Bit2Shop__Stock_Serials2__c stockSerialNew) {

        Savepoint sp = Database.setSavepoint();
        try{
            //If old and new warehouse are the same return
            if (stockSerialOldClone.Bit2Shop__Warehouse_Id__c == stockSerialNew.Bit2Shop__Warehouse_Id__c) {
                return;
            }

            //Declaring two warehouses
            Bit2Shop__Warehouse__c originWarehouse;
            Bit2Shop__Warehouse__c destinationWarehouse;
            //Getting warehouses for Stock Order
            for (Bit2Shop__Warehouse__c warehouse : [SELECT Id, Bit2Shop__Dealer_Id__c,
                                                            Bit2Shop__Dealer_Id__r.OwnerId,
                                                            Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c
                                                     FROM Bit2Shop__Warehouse__c
                                                     WHERE Id = :stockSerialOldClone.Bit2Shop__Warehouse_Id__c OR
                                                           Id = :stockSerialNew.Bit2Shop__Warehouse_Id__c ]) {

                if (warehouse.Id == stockSerialOldClone.Bit2Shop__Warehouse_Id__c) {
                    originWarehouse = warehouse;
                } else if (warehouse.Id == stockSerialNew.Bit2Shop__Warehouse_Id__c) {
                    destinationWarehouse = warehouse;
                }
            }

            //Declaring transfer detail
            Bit2Shop__TransferDetail__c transferDetail = [SELECT Id,Bit2Shop__Transfer_Type__c,Bit2Shop__Code__c FROM  Bit2Shop__TransferDetail__c WHERE Bit2Shop__Code__c = 'CORREZ'];

            //Creating Stock Order
            Bit2Shop__StockOrder__c newStockOrder = new Bit2Shop__StockOrder__c();
            newStockOrder.Bit2Shop__Status__c = Plc_WorkOrderApxAct.STOCK_ORDER_STATUS_CLOSED; //TODO
            newStockOrder.Bit2Shop__Destination_Warehouse_Id__c = destinationWarehouse.Id;
            newStockOrder.Bit2Shop__Warehouse_Id__c = originWarehouse.Id;
            newStockOrder.Bit2Shop__Transfer_Type__c = transferDetail.Bit2Shop__Transfer_Type__c;
            newStockOrder.Bit2Shop__Point_Of_Sales_Id__c = originWarehouse.Bit2Shop__Dealer_Id__c;
            newStockOrder.Bit2Shop__Holding_Id__c = originWarehouse.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c;
            newStockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c = destinationWarehouse.Bit2Shop__Dealer_Id__c;
            newStockOrder.Plc_TransferDetail__c = transferDetail.Id;
            newStockOrder.Plc_ShippingDate__c = System.today();
            newStockOrder.Plc_TakenInChargeDate__c = System.today();
            newStockOrder.OwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
            // START - GIA' UTILIZZATO SU ALTRE CLASSI, PREVEDERE NELLA UTILS
            List<Bit2Shop__Dealer_User__c > dealerUserList = [SELECT Id, Bit2Shop__User_Id__c FROM Bit2Shop__Dealer_User__c WHERE Bit2Shop__Dealer_Id__c = :originWarehouse.Bit2Shop__Dealer_Id__c];
            String currentUserId = UserInfo.getUserId();
            Boolean containsUserId = false;

            if(!dealerUserList.isEmpty()) {
                for(Bit2Shop__Dealer_User__c dealerUser : dealerUserList) {
                    if(dealerUser.Bit2Shop__User_Id__c == currentUserId) {
                        containsUserId = true;
                        continue;
                    }
                }
            }

            if(currentUserId != originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId && !containsUserId) {
                newStockOrder.OwnerId = originWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
            } else {
                newStockOrder.OwnerId = currentUserId;
            }
            // END
            
            newStockOrder.RecordtypeId = Plc_Utils.getRecordTypeId (
                Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER, 
                Bit2Shop__StockOrder__c.SObjectType.getDescribe().name
            );

            insert newStockOrder;

            //Configuration
            NE__Order__c newConfiguration = new NE__Order__c (
                Bit2Shop__StockOrder__c = newStockOrder.Id,
                Bit2Shop__Cost_Total__c = 0,
                NE__AccountId__c = newStockOrder.Bit2Shop__Holding_Id__c,
                NE__OrderStatus__c = Plc_Constants.NE_Order.NE_OrderStatus_Completed,
                NE__ConfigurationStatus__c = Plc_Constants.NE_Order.NE_ConfigurationStatus_InProgress,
                NE__Version__c = 1,
                RecordTypeId = Plc_Utils.getRecordTypeId (
                    Plc_Constants.NE_Order.RecordType_StockOrder, 
                    NE__Order__c.SObjectType.getDescribe().Name
                )
            );
            insert newConfiguration;
            
            //Creating Configuration Item
            /*NE__OrderItem__c newConfigurationItem = new NE__OrderItem__c(
                    RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.NE_OrderItem.RecordType_Standard,
                            NE__OrderItem__c.SObjectType.getDescribe().Name),
                    NE__OrderId__c = newConfiguration.Id,
                    NE__Qty__c = 1,
                    NE__Status__c = Plc_Constants.NE_OrderItem.NE_Status_Completed,
                    NE__Account__c = newStockOrder.Bit2Shop__Holding_Id__c,
                    Bit2Shop__Required_Serial__c = true
            )*/
            //insert newConfigurationItem;
            
            /* DA MODIFICARE LA UTILS PER PASSARE PARAMETRO IN CASO DI STOCK ORDER APERTO O CHIUSO */
            //creo la struttura da configuration item in giu per i prodotti a seriale
            List<Bit2Shop__Stock_Serials2__c> ss2List = new List<Bit2Shop__Stock_Serials2__c>();
            ss2List.add(stockSerialNew);
            Plc_Utils.shipmentsUtils.createProductSerialStructure(ss2List, newConfiguration, newStockOrder,true);

            //creo la struttura da configuration item in giu per i prodotti a quantità
            /* VERIFICARE SE LO STOCK SERIAL 2 HA IL CAMPO Bit2Shop__Product_Stock_Id__c NELLA QUERY RECUPERATA */
            //List<Bit2Shop__Product_Stock__c> psList = [SELECT Id, Bit2Shop__External_Catalog_Item_Id__c,Bit2Shop__Shipped_Qty__c,Name, Bit2Shop__Stock_Qty__c, Plc_ProductSku__c FROM Bit2Shop__Product_Stock__c WHERE Id = :stockSerialNew.Bit2Shop__Product_Stock_Id__c];
            //Plc_Utils.shipmentsUtils.createProductQuantityStructure(psList, newConfiguration, newStockOrder,true);
        }catch(Exception ex){
            Database.rollback(sp);
            throw new Plc_Exception(ex,'');
        }
    }
}