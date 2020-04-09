/**
    * @author Andrea Liverani - andrea.liverani@webresults.it
    * @description Controller Apex for Plc_StocksManagement
    * @history 29/01/2019 - Andrea Liverani - andrea.liverani@webresults.it - Class created.
*/

public with sharing class Plc_StocksManagementCnt {

    public class stockSerialWrapper {

        @AuraEnabled
        public String Id { get; set; }

        @AuraEnabled
        public String productSKU { get; set; }

        @AuraEnabled
        public String model { get; set; }

        @AuraEnabled
        public String manufacturer { get; set; }

        @AuraEnabled
        public String encodedSerialNumber { get; set; }

        @AuraEnabled
        public String manufacturerSerialNumber { get; set; }

        @AuraEnabled
        public String dllSerialNumber { get; set; }

        @AuraEnabled
        public Contact newTechnician { get; set; }

        @AuraEnabled
        public Contact oldTechnician { get ; set; }

        @AuraEnabled
        public String status { get; set; }

        @AuraEnabled
        public Boolean selected { get; set; }

        public stockSerialWrapper(String Id, String productSKU, String model, String manufacturer, String encodedSerialNumber, String manufacturerSerialNumber, String dllSerialNumber, Contact technician, String status, Boolean selected) {

            this.Id = Id;
            this.productSKU = productSKU;
            this.model = model;
            this.manufacturer = manufacturer;
            this.encodedSerialNumber = encodedSerialNumber;
            this.manufacturerSerialNumber = manufacturerSerialNumber;
            this.dllSerialNumber = dllSerialNumber;
            this.status = status;
            this.selected = selected;
            this.newTechnician = technician;
            this.oldTechnician = technician;
        }
    }

    /**
    * @createdBy Andrea Liverani
    * @date 29/01/2019
    * @description Initialize method
    * @param warehouseId, action
    * @return Object
    */
    @AuraEnabled
    public static Object initialize(String warehouseId, String action) {

        try {
            System.debug('[START] @A - initialize');
            System.debug('[PROCESSING] @A - initialize - warehouseId >> ' + warehouseId);
            System.debug('[PROCESSING] @A - initialize - action >> ' + action);

            Map<String, Object> result = new Map<String, Object>();
            if (action == 'initialize') {
                result.put('availableList', getInitialStockSerialByStatus('Available', warehouseId));
                result.put('withdrawnList', getInitialStockSerialByStatus('Withdrawn', warehouseId));
            } else if (action == 'refreshAvailableManagement') {
                result.put('withdrawnList', getInitialStockSerialByStatus('Withdrawn', warehouseId));
            } else if (action == 'refreshWithdrawnManagement') {
                result.put('availableList', getInitialStockSerialByStatus('Available', warehouseId));
            }

            //FB 20190627 - NEXIPLC-590 [START]
            Bit2Shop__Warehouse__c warehouse = [SELECT Id, Name FROM Bit2Shop__Warehouse__c WHERE Id = :warehouseId];
            result.put('warehouse', warehouse);
            //FB 20190627 - NEXIPLC-590 [END]
            result.put('technicianList', getTechnicianListByWarehouseId(warehouseId));

            System.debug('[PROCESSING] @A - initialize - result >> ' + result);
            System.debug('[END] @A - initialize');
            return result;
        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - initialize >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }

        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 29/01/2019
    * @description Method used for create List<stockSerialWrapper> from List<Bit2Shop__Stock_Serials2__c>
    * @param stockSerials2sList
    * @return List<stockSerialWrapper>
    */
    public static List<stockSerialWrapper> createStockSerialWrapperList(List<Bit2Shop__Stock_Serials2__c> stockSerialList) {
        try {
            System.debug('createStockSerialWrapperList --> start');
            System.debug('createStockSerialWrapperList --> stockSerialList : ' + stockSerialList);

            List<stockSerialWrapper> stockSerialWrapperList = new List<stockSerialWrapper>();
            List<String> contactIdsList = new List<String>();
            Map<String, Contact> stockSerialIdToContactMap = new Map<String, Contact>();

            if (!stockSerialList.isEmpty()) {

                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialList) {
                    contactIdsList.add(stockSerial.Plc_WithdrawnBy__c);
                }

                List<Contact> technicianList = [SELECT Id, Name FROM Contact WHERE Id IN :contactIdsList];

                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialList) {
                    for(Contact c : technicianList) {
                        if(stockSerial.Plc_WithdrawnBy__c == c.Id) {
                            stockSerialIdToContactMap.put(stockSerial.Id, c);
                        }
                    }
                    stockSerialWrapperList.add(new stockSerialWrapper(stockSerial.Id, stockSerial.Plc_ProductSku__c, stockSerial.Plc_Model__c, stockSerial.Plc_Manufacturer__c, stockSerial.Plc_EncodedSerialNumber__c, stockSerial.Plc_ManufacturerSerialNumber__c, stockSerial.Plc_DllSerialNumber__c, stockSerialIdToContactMap.get(stockSerial.Id), stockSerial.Bit2Shop__Status__c, false));
                }

                if (!stockSerialWrapperList.isEmpty()) {
                    System.debug('createStockSerialWrapperList --> stockSerialWrapperList : ' + stockSerialWrapperList);
                    return stockSerialWrapperList;
                } else {
                    System.debug('createStockSerialWrapperList --> stockSerialWrapperList is empty.');
                }
            } else {
                System.debug('createStockSerialWrapperList --> stockSerialList is empty.');
            }

        } catch (Exception error) {
            String errorMessage = 'createStockSerialWrapperList --> exception: error in: ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 29/01/2019
    * @description Return the initials data by status passed
    * @param status, warehouseId
    * @return List<stockSerialWrapper>
    */
    @AuraEnabled
    (cacheable = true)
    public static List<stockSerialWrapper> getInitialStockSerialByStatus(String status, String warehouseId) {
        try {
            System.debug('[START] @A - getInitialStockSerialByStatus');
            System.debug('[PROCESSING] @A - getInitialStockSerialByStatus - status >> ' + status);
            System.debug('[PROCESSING] @A - getInitialStockSerialByStatus - warehouseId >> ' + warehouseId);

            List<Bit2Shop__Stock_Serials2__c> intialStockSerialList = [SELECT Id, Plc_ProductSku__c, Plc_Model__c, Plc_Manufacturer__c, Plc_EncodedSerialNumber__c, Plc_ManufacturerSerialNumber__c, Plc_DllSerialNumber__c, Bit2Shop__Status__c,Plc_WithdrawnBy__c, Plc_WithdrawnBy__r.Name FROM Bit2Shop__Stock_Serials2__c WHERE Bit2Shop__Warehouse_Id__c = :warehouseId AND Bit2Shop__Status__c = :status LIMIT 300];

            if (!intialStockSerialList.isEmpty()) {
                System.debug('[PROCESSING] @A - getInitialStockSerialByStatus - intialStockSerialList >> ' + intialStockSerialList);
                System.debug('[END] @A - getInitialStockSerialByStatus');
                return createStockSerialWrapperList(intialStockSerialList);
            } else {
                System.debug('[PROCESSING] @A - getInitialStockSerialByStatus - intialStockSerialList >> List is empty.');
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - initialize >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 01/02/2019
    * @description return the list of technician (contacts) related to warehouse
    * @param warehouseId
    * @return List<Contact>
    */
    @AuraEnabled
    (cacheable = true)
    public static List<Contact> getTechnicianListByWarehouseId(String warehouseId) {
        try {
            System.debug('getTechnicianListByWarehouseId --> start');
            System.debug('getTechnicianListByWarehouseId --> warehouseId : ' + warehouseId);

            Bit2Shop__Warehouse__c warehouse = [SELECT Id, Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c FROM Bit2Shop__Warehouse__c WHERE Id = :warehouseId];

            if (warehouse != null) {
                String accountId = warehouse.Bit2Shop__Dealer_Id__c != null ? warehouse.Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c : '';
                String dealerId = warehouse.Bit2Shop__Dealer_Id__c;

                List<Contact> technicianList = [SELECT Id, Name FROM Contact WHERE AccountId = :accountId AND Plc_Dealer__c = :dealerId ORDER BY Name];
                if (!technicianList.isEmpty()) {
                    System.debug('getTechnicianListByWarehouseId --> technicianList : ' + technicianList);
                    System.debug('getTechnicianListByWarehouseId --> end');
                    return technicianList;
                } else {
                    System.debug('getTechnicianListByWarehouseId --> technicianList is empty.');
                }
            } else {
                System.debug('getTechnicianListByWarehouseId --> warehouse is null.');
            }
        } catch (Exception error) {
            String errorMessage = 'getTechnicianListByWarehouseId --> exception: error in: ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 01/02/2019
    * @description Return a List<stockSerialWrapper> for Available and Withdrawn stockserials filtered
    * @param resultsList, warehouseId, tabFocused
    * @return List<stockSerialWrapper>
    */
    @AuraEnabled
    public static List<stockSerialWrapper> createWrapperListFromResults(String resultsList, String warehouseId, String tabFocused) {
        try {
            System.debug('[START] @A - createWrapperListFromResults');

            Map<String, List<Bit2Shop__Stock_Serials2__c>> stockSerialsFilteredMap = (Map<String, List<Bit2Shop__Stock_Serials2__c>>) JSON.deserialize(resultsList, Map<String, List<Bit2Shop__Stock_Serials2__c>>.class);
            List<Bit2Shop__Stock_Serials2__c> stockSerialFilteredList = (List<Bit2Shop__Stock_Serials2__c>) stockSerialsFilteredMap.get('Bit2Shop__Stock_Serials2__c');

            System.debug('[PROCESSING] @A - createWrapperListFromResults - resultsList >> ' + stockSerialFilteredList);
            System.debug('[PROCESSING] @A - createWrapperListFromResults - warehouseId >> ' + warehouseId);


            List<Bit2Shop__Stock_Serials2__c> stockSerialAvailableList = new List<Bit2Shop__Stock_Serials2__c>();
            List<Bit2Shop__Stock_Serials2__c> stockSerialWithdrawnList = new List<Bit2Shop__Stock_Serials2__c>();

            if (!stockSerialFilteredList.isEmpty()) {
                for (Bit2Shop__Stock_Serials2__c stockSerials2 : stockSerialFilteredList) {
                    if (stockSerials2.Bit2Shop__Warehouse_Id__c == warehouseId && stockSerials2.Bit2Shop__Status__c == 'Available') {
                        stockSerialAvailableList.add(stockSerials2);
                    } else if (stockSerials2.Bit2Shop__Warehouse_Id__c == warehouseId && stockSerials2.Bit2Shop__Status__c == 'Withdrawn') {
                        stockSerialWithdrawnList.add(stockSerials2);
                    }
                }
                System.debug('[PROCESSING] @A - createWrapperListFromResults - resultsList >> ' + resultsList);
            }

            if (!stockSerialAvailableList.isEmpty() && tabFocused == 'WithdrawnManagement') {
                System.debug('[PROCESSING] @A - createWrapperListFromResults - stockSerialAvailableList >> ' + stockSerialAvailableList);
                return createStockSerialWrapperList(stockSerialAvailableList);
            } else {
                System.debug('[PROCESSING] @A - createWrapperListFromResults - stockSerialAvailableList >> List is empty.');
            }

            if (!stockSerialWithdrawnList.isEmpty() && tabFocused == 'AvailableManagement') {
                System.debug('[PROCESSING] @A - createWrapperListFromResults - stockSerialWithdrawnList >> ' + stockSerialWithdrawnList);
                return createStockSerialWrapperList(stockSerialWithdrawnList);
            } else {
                System.debug('[PROCESSING] @A - createWrapperListFromResults - stockSerialWithdrawnList >> List is empty.');
            }

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - initialize >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @createdBy Andrea Liverani
    * @date 04/02/2019
    * @description update the records in availableSelectedList and withdrawnSelectedList
    * @param availableSelectedSerialized, withdrawnSelectedSerialiazed
    */
    @AuraEnabled
    public static Boolean confirm(String availableSelectedSerialized, String withdrawnSelectedSerialiazed) {
        try {
            System.debug('[START] @A - confirm');
            List<stockSerialWrapper> availableSelectedList = (List<stockSerialWrapper>) JSON.deserialize(availableSelectedSerialized, List<stockSerialWrapper>.class);
            List<stockSerialWrapper> withdrawnSelectedList = (List<stockSerialWrapper>) JSON.deserialize(withdrawnSelectedSerialiazed, List<stockSerialWrapper>.class);

            System.debug('[PROCESSING] @A - confirm - availableSelectedList >> ' + availableSelectedList);
            System.debug('[PROCESSING] @A - confirm - withdrawnSelectedList >> ' + withdrawnSelectedList);

            List<Bit2Shop__Stock_Serials2__c> stockSerialListToUpdate = new List<Bit2Shop__Stock_Serials2__c>();
            Map<String, String> stockSerialAvailableMap = new Map<String, String>();
            List<String> stockSerialWithdrawnIdsList = new List<String>();

            if (!availableSelectedList.isEmpty()) {
                for (stockSerialWrapper wrpAvailable : availableSelectedList) {
                    stockSerialAvailableMap.put(wrpAvailable.Id, wrpAvailable.newTechnician.Id);
                }
            } else {
                System.debug('[PROCESSING] @A - confirm - availableSelectedList >> List is empty.');
            }

            if (!withdrawnSelectedList.isEmpty()) {
                for (stockSerialWrapper wrpWithdrawn : withdrawnSelectedList) {
                    stockSerialWithdrawnIdsList.add(wrpWithdrawn.Id);
                }
            } else {
                System.debug('[PROCESSING] @A - confirm - withdrawnSelectedList >> List is empty.');
            }

            List<String> productStockAvailableIdsList = new List<String>();
            List<String> productStockWithdrawnIdsList = new List<String>();

            if (!stockSerialAvailableMap.isEmpty()) {
                List<Bit2Shop__Stock_Serials2__c> stockSerialAvailableToUpdate = [SELECT Id, Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Stock_Serials2__c WHERE Id IN :stockSerialAvailableMap.keySet() FOR UPDATE];
                if (!stockSerialAvailableToUpdate.isEmpty()) {
                    for (Bit2Shop__Stock_Serials2__c stockSerialAvailable : stockSerialAvailableToUpdate) {
                        stockSerialAvailable.Bit2Shop__Status__c = 'Withdrawn';
                        stockSerialAvailable.Plc_Status2__c = 'Sent';
                        stockSerialAvailable.Plc_WithdrawnBy__c = stockSerialAvailableMap.get(stockSerialAvailable.Id);
                        productStockAvailableIdsList.add(stockSerialAvailable.Bit2Shop__Product_Stock_Id__c);
                    }
                    update stockSerialAvailableToUpdate;
                }

                if (!productStockAvailableIdsList.isEmpty()) {
                    List<Bit2Shop__Product_Stock__c> productStockAvailableToUpdate = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c WHERE Id IN :productStockAvailableIdsList FOR UPDATE];
                    if (!productStockAvailableToUpdate.isEmpty()) {
                        for (Bit2Shop__Product_Stock__c productStock : productStockAvailableToUpdate) {

                            Decimal quantity = 0;

                            for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialAvailableToUpdate) {
                                if (stockSerial.Bit2Shop__Product_Stock_Id__c == productStock.Id) {
                                    quantity++;
                                }
                            }
                            productStock.Plc_WithdrawnQty__c = productStock.Plc_WithdrawnQty__c != null ? productStock.Plc_WithdrawnQty__c + quantity : 1;
                            productStock.Plc_UsableQty__c = (productStock.Plc_UsableQty__c != null && productStock.Plc_UsableQty__c > 0) ? (productStock.Plc_UsableQty__c - quantity) : 0;
                        }
                        update productStockAvailableToUpdate;
                    }
                }
            }


            if (!stockSerialWithdrawnIdsList.isEmpty()) {
                List<Bit2Shop__Stock_Serials2__c> stockSerialWithdrawnToUpdate = [SELECT Id, Bit2Shop__Product_Stock_Id__c FROM Bit2Shop__Stock_Serials2__c WHERE Id IN :stockSerialWithdrawnIdsList FOR UPDATE];
                if (!stockSerialWithdrawnToUpdate.isEmpty()) {
                    for (Bit2Shop__Stock_Serials2__c stockSerialWithdrawn : stockSerialWithdrawnToUpdate) {
                        stockSerialWithdrawn.Bit2Shop__Status__c = 'Available';
                        stockSerialWithdrawn.Plc_Status2__c = 'None';
                        stockSerialWithdrawn.Plc_WithdrawnBy__c = null;
                        productStockWithdrawnIdsList.add(stockSerialWithdrawn.Bit2Shop__Product_Stock_Id__c);
                    }
                    update stockSerialWithdrawnToUpdate;
                }

                if (!productStockWithdrawnIdsList.isEmpty()) {
                    List<Bit2Shop__Product_Stock__c> productStockWithdrawnToUpdate = [SELECT Id, Plc_WithdrawnQty__c, Plc_UsableQty__c FROM Bit2Shop__Product_Stock__c WHERE Id IN :productStockWithdrawnIdsList FOR UPDATE];
                    if (!productStockWithdrawnToUpdate.isEmpty()) {
                        for (Bit2Shop__Product_Stock__c productStock : productStockWithdrawnToUpdate) {

                            Decimal quantity = 0;

                            for(Bit2Shop__Stock_Serials2__c stockSerial : stockSerialWithdrawnToUpdate) {
                                if (stockSerial.Bit2Shop__Product_Stock_Id__c == productStock.Id) {
                                    quantity++;
                                }
                            }
                            productStock.Plc_WithdrawnQty__c = (productStock.Plc_WithdrawnQty__c != null && productStock.Plc_WithdrawnQty__c > 0) ? productStock.Plc_WithdrawnQty__c - quantity : 0;
                            productStock.Plc_UsableQty__c = productStock.Plc_UsableQty__c != null ? productStock.Plc_UsableQty__c + quantity : 1;
                        }
                        update productStockWithdrawnToUpdate;
                    }
                }
            }
            return true;

        } catch (Exception error) {
            String errorMessage = '[EXCEPTION] @A - confirm >> Error in : ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
            return false;
        }
    }

    /**
     * Used to retrieve list of available warehouses
     *
     * @createdBy FB
     * @date 24/04/2019
     * 
     * @param  searchKey String used to match the name
     * @return           List of available warehouses
     */
    @AuraEnabled
    public Static Map<String, Object> retrieveAvailableWarehouses(String searchKey){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {

            searchKey = '%' + (searchKey == null ? '' :  searchKey) + '%';
            List<Bit2Shop__Warehouse__c> warehousesList = [SELECT Id, Name, Bit2Shop__Dealer_Id__r.Name,
                                                                  Plc_Property__c, Plc_LogisticDivision__c,
                                                                  Plc_Tipology__c, Bit2Shop__City__c,
                                                                  Bit2Shop__State_Province__c, Plc_Alias__c
                                                           FROM Bit2Shop__Warehouse__c
                                                           WHERE Plc_IsActive__c = true AND
                                                                 Plc_Tipology__c = 'Generic' AND
                                                                 (Name LIKE :searchKey OR
                                                                  Bit2Shop__Dealer_Id__r.Name LIKE :searchKey OR
                                                                  Plc_Tipology__c LIKE :searchKey OR
                                                                  Plc_LogisticDivision__c LIKE :searchKey OR
                                                                  Plc_Property__c LIKE :searchKey OR
                                                                  Bit2Shop__City__c LIKE :searchKey)];
            response.put('warehousesList', warehousesList);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
            System.debug(e.getMessage() + '' + e.getStackTraceString());
        }
        return response;
    }

    /**
     * Method used in order to get some different system labels
     *
     * @createdBy FB
     * @date 24/04/2019
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
        response.put('SerialStockSingular', serialStockSchema.getLabel());
        response.put('SerialStockName', serialStockFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Plc_ManufacturerSerialNumber__c', serialStockFieldsMap.get('Plc_ManufacturerSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_EncodedSerialNumber__c', serialStockFieldsMap.get('Plc_EncodedSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_DllSerialNumber__c', serialStockFieldsMap.get('Plc_DllSerialNumber__c').getDescribe().getLabel());
        response.put('Plc_ProductSku__c', serialStockFieldsMap.get('Plc_ProductSku__c').getDescribe().getLabel());
        response.put('Bit2Shop__Warehouse_Id__c', serialStockFieldsMap.get('Bit2Shop__Warehouse_Id__c').getDescribe().getLabel());
        response.put('Bit2Shop__Purchase_Price__c', serialStockFieldsMap.get('Bit2Shop__Purchase_Price__c').getDescribe().getLabel());
        response.put('Plc_PcipedExpiryDate__c', serialStockFieldsMap.get('Plc_PcipedExpiryDate__c').getDescribe().getLabel());
        response.put('Plc_Note__c', serialStockFieldsMap.get('Plc_Note__c').getDescribe().getLabel());
        response.put('Bit2Shop__Status__c', serialStockFieldsMap.get('Bit2Shop__Status__c').getDescribe().getLabel());
        response.put('Plc_Status2__c', serialStockFieldsMap.get('Plc_Status2__c').getDescribe().getLabel());
        //Getting Warehouse labels
        Schema.DescribeSObjectResult warehouseSchema = Bit2Shop__Warehouse__c.SObjectType.getDescribe();
        Map<String, Schema.SObjectField> warehouseFieldsMap = warehouseSchema.fields.getMap();
        response.put('Bit2Shop__Warehouse__c', warehouseSchema.getLabelPlural());
        response.put('WarehouseName', warehouseFieldsMap.get('Name').getDescribe().getLabel());
        response.put('Bit2Shop__Dealer_Id__c', warehouseFieldsMap.get('Bit2Shop__Dealer_Id__c').getDescribe().getLabel());
        response.put('Plc_Property__c', warehouseFieldsMap.get('Plc_Property__c').getDescribe().getLabel());
        response.put('Plc_LogisticDivision__c', warehouseFieldsMap.get('Plc_LogisticDivision__c').getDescribe().getLabel());
        response.put('Bit2Shop__State_Province__c', warehouseFieldsMap.get('Bit2Shop__State_Province__c').getDescribe().getLabel());
        response.put('Plc_Tipology__c', warehouseFieldsMap.get('Plc_Tipology__c').getDescribe().getLabel());
        response.put('Bit2Shop__City__c', warehouseFieldsMap.get('Bit2Shop__City__c').getDescribe().getLabel());
        response.put('Plc_Alias__c', warehouseFieldsMap.get('Plc_Alias__c').getDescribe().getLabel());
        //Getting External catalog item labels
        Schema.DescribeSObjectResult modelSchema =  B2WExtCat__External_Catalog_Item__c.SObjectType.getDescribe();
        response.put('B2WExtCat__External_Catalog_Item__c', modelSchema.getLabelPlural());

        return response;
    }
}