/**
 * *************************************************
 *     * @Author nunzio.capasso@/webresults.it
 *     * @date  11/02/2019 10:52
 *     * @description apex controller for Plc_UploadCsvCmp.cmp
 *     * @Modified by
 *   ***********************************************
 **/
public without sharing class Plc_UploadCsvCnt {

    public class CSVSerials {
        @AuraEnabled
        public String serialNumbers { get; set; }
        @AuraEnabled
        public String manufacturerAlias { get; set; }
        @AuraEnabled
        public String productSku { get; set; }
        @AuraEnabled
        public String error { get; set; }
        @AuraEnabled
        public String processStep { get; set; }
        @AuraEnabled
        public String csvLinePosition { get; set; }
        //FB 20190627 - NEXIPLC-590 [START]
        @AuraEnabled
        public String technician { get; set; }
        //FB 20190627 - NEXIPLC-590 [END]
    }

    public static final String CHECK_BY_PRODUCT_SKU = 'checkByProductSku';
    public static final String CHECK_BY_MANUFACTURER_ALIAS = 'checkByManufacturerAlias';
    public static final String PRODUCT_SKU_NOT_PRESENT = 'ProductSkuNotPresent';
    public static final String MATCHED_BY_SERIAL_NUMBER = 'matchedBySerialNumber';
    public static final String MATCHED_BY_ALIAS = 'matchedByAlias';
    public static final String NO_MATCH_BY_ALIAS = 'noMatchByAlias';
    public static final String COMPOSE_LIST_OF_CSVSERIALS = 'composeListOfCSVserials';
    public static final String PRODUCT_SKU_AND_MANUFACTURER_ALIAS_NOT_PRESENT = Label.Plc_ProductSkuAndManufacturerAliasNotPresentError;
    public static final String DIFFERENT_WAREHOUSE = Label.Plc_DifferentWarehouseError;
    public static final String DIFFERENT_WAREHOUSE_AND_STATUS = Label.Plc_DifferentWarehouseAndStatusError;
    public static final String DIFFERENT_STATUS = Label.Plc_SerialInDifferentStatusError;
    public static final String NO_SERIAL_FOUND_IN_DATABASE = Label.Plc_SerialNotFoundInDatabaseError;
    public static final String CSV_ALIAS_DIFF_MANU_ALIAS = Label.Plc_csvAliasDiffFromManuAlias;
    public static final String DIFFERENT_MODEL = Label.Plc_SerialModelsDiffError;
    public static final String DIFFERENT_MODEL_AND_STATUS = Label.Plc_DifferentModelAndStatusError;
    public static final String MULTIPLE_SERIAL_ERROR = Label.Plc_LightningComponentGoodsHandlingMultipleSerialsFoundError;
    public static final String STATUS2_NOT_NONE = Label.Plc_LightningComponentUploadCSVStatus2ValueNotNone;


    public static List<String> stockSerialStatusList = new List<String>();
    public static List<String> distributionListItemModelsList = new List<String>();
    public static List<CSVSerials> serialsFromCSV = new List<CSVSerials>();
    public static String serialsToCheckStat;
    public static String stockSerialStatusStat;
    public static String warehouseIdStat;
    public static String distributionListItemModelsStat;

    //FB 20190627 - NEXIPLC-590 [START]
    public static String technicianName = '';
    public static Boolean technicianWithdrawnManagement = false;
    public static Boolean skipStatus2Check = false;
    public static Bit2Shop__Warehouse__c warehouse;
    public static Map<String, Contact> contactMap = new Map<String, Contact>();
    public static Map<String, String> serialIdToTechnicianMap = new Map<String, String>();
    //FB 20190627 - NEXIPLC-590 [END]

    /**
     * *************************************************
     *     * @Author nunzio.capasso@/webresults.it
     *     * @date  11/02/2019 10:53
     *     * @description method that return a map of valid and invalid records with the relative errors
     *     * @Modified by
     *         - FB 20190627: NEXIPLC-589/NEXIPLC-590
     *     * @param serialsToCheck serialized list of 'CSVSerials' (check the above wrapper)
     *     * @param stockSerialStatus string separated by ';' .
     *     Records with diffrent status from the specified one will generate an error
     *     * @param warehouseId just the warehouse Id.
     *     Records with diffrent status from the specified one will generate an error
     *   ***********************************************
     **/
    @AuraEnabled
    public static Map<String, Object> checkCSVSerials(String serialsToCheck, String stockSerialStatus, String warehouseId, String distributionListItemModels, Map<String, Object> configurationMap) {
        System.debug('\n\n@@@@@checkCSVSerials-start@@@@\n\n');

        //FB 20190627 - NEXIPLC-590 [START]
        String technicianRecordTypeId = Plc_Utils.getRecordTypeId('Plc_TecnicoOnSite', Contact.SObjectType.getDescribe().name);
        //Adding new configuration parameters for technician management
        if (configurationMap != null) {
            if (configurationMap.containsKey('technicianName')) {
                technicianName = (String)configurationMap.get('technicianName');
            }
            if (configurationMap.containsKey('technicianWithdrawnManagement')) {
                technicianWithdrawnManagement = (Boolean)configurationMap.get('technicianWithdrawnManagement');
            }
            if (configurationMap.containsKey('skipStatus2Check')) {
                skipStatus2Check = (Boolean)configurationMap.get('skipStatus2Check');
            }
        }

        if (technicianWithdrawnManagement && String.isBlank(technicianName)) {
            warehouse = [SELECT Id, Bit2Shop__Dealer_Id__r.Name
                         FROM Bit2Shop__Warehouse__c
                         WHERE Id = :warehouseId];
        }
        //FB 20190627 - NEXIPLC-590 [END]
        
        serialsToCheckStat = serialsToCheck;
        stockSerialStatusStat = stockSerialStatus;
        warehouseIdStat = warehouseId;
        distributionListItemModelsStat = distributionListItemModels;
        if (String.isEmpty(serialsToCheck)) {
            return null;
        }

        try {
            serialsFromCSV = (List<CSVSerials>) JSON.deserialize(serialsToCheck, List<CSVSerials>.class);
        } catch (Exception e) {
            String errorMessage = '\n\ncheckCSVSerials-deserialize-Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
        }
        if (!String.isEmpty(stockSerialStatus)) {
            stockSerialStatusList = stockSerialStatus.split(';');
        }
        if (!String.isEmpty(distributionListItemModels)) {
            distributionListItemModelsList = distributionListItemModels.split(';');
        }

        System.debug('\n@@@@serialsFromCSVList:\n ' + serialsFromCSV);
        System.debug('@@@@stockSerialStatusList: ' + stockSerialStatusList);
        System.debug('@@@@sdistributionListItemModelsList: ' + distributionListItemModelsList);
        System.debug('@@@@warehouseId: ' + warehouseId);
        List<String> serialNumberFound = new List<String>();
        List<String> serialsNumberFoundList = new List<String>();
        //FB 20190627 - NEXIPLC-590 [START]
        Set<String> techniciansFoundSet = new Set<String>();
        //FB 20190627 - NEXIPLC-590 [END]

        try {

            for (Integer i = 0; i < serialsFromCSV.size(); i++) {
                //remove records already in error
                serialNumberFound.add(serialsFromCSV[i].serialNumbers);
                //FB 20190627 - NEXIPLC-590 [START]
                if (String.isNotEmpty(serialsFromCSV[i].technician)) {
                    techniciansFoundSet.add(serialsFromCSV[i].technician);
                }
                //FB 20190627 - NEXIPLC-590 [END]
                if (String.isNotEmpty(serialsFromCSV[i].error)) {
                    serialsFromCSV.remove(i);
                }
                //splitting cases in separate list
            }
            //FB 20190627 - NEXIPLC-590 [START]
            if (technicianWithdrawnManagement && String.isBlank(technicianName)) {
                for (Contact c : [SELECT Id, Name, Plc_TecnhicianSerialNumber__c 
                                  FROM Contact 
                                  WHERE (Name IN :techniciansFoundSet OR 
                                        Plc_TecnhicianSerialNumber__c IN :techniciansFoundSet) AND
                                        Plc_Dealer__c = :warehouse.Bit2Shop__Dealer_Id__c]) {

                    contactMap.put(c.Name.toUpperCase(), c);
                    if (String.isNotBlank(c.Plc_TecnhicianSerialNumber__c)) {
                        contactMap.put(c.Plc_TecnhicianSerialNumber__c.toUpperCase(), c);
                    }
                }
            }
            //FB 20190627 - NEXIPLC-590 [END]

            List<Bit2Shop__Stock_Serials2__c> serialNumberCheck = [
                    SELECT Plc_DllSerialNumber__c,
                            Plc_EncodedSerialNumber__c,
                            Plc_ManufacturerSerialNumber__c,
                            Plc_ProductSku__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c
                    FROM Bit2Shop__Stock_Serials2__c WHERE Plc_DllSerialNumber__c IN:  serialNumberFound OR
                         Plc_ManufacturerSerialNumber__c  IN:  serialNumberFound OR
                         Plc_EncodedSerialNumber__c  IN:  serialNumberFound ];

            Map<String, Integer> serialToQty = new Map<String,Integer>();
            Map<String, Integer> serialDllToQty = new Map<String,Integer>();
            Map<String, Integer> serialEncodedToQty = new Map<String,Integer>();
            Map<String, Integer> serialManuToQty = new Map<String,Integer>();
            Map<String, Bit2Shop__Stock_Serials2__c> csvSerialToFoundSerial = new Map<String, Bit2Shop__Stock_Serials2__c>();  
            
            for (Integer i = 0; i < serialNumberCheck.size(); i++) {
                 if (String.isNotBlank(serialNumberCheck[i].Plc_DllSerialNumber__c)) {
                    csvSerialToFoundSerial.put(serialNumberCheck[i].Plc_DllSerialNumber__c.toUpperCase(), serialNumberCheck[i]);
                     if (serialDllToQty.containsKey(serialNumberCheck[i].Plc_DllSerialNumber__c.toUpperCase())) {
                         serialDllToQty.put(serialNumberCheck[i].Plc_DllSerialNumber__c.toUpperCase(), serialDllToQty.get(serialNumberCheck[i].Plc_DllSerialNumber__c )+1 );
                     } else {
                         serialDllToQty.put(serialNumberCheck[i].Plc_DllSerialNumber__c.toUpperCase(), 1 );
                     }      
                 }
                 if (String.isNotBlank(serialNumberCheck[i].Plc_EncodedSerialNumber__c)) {
                     csvSerialToFoundSerial.put(serialNumberCheck[i].Plc_EncodedSerialNumber__c.toUpperCase(), serialNumberCheck[i]);
                     if (serialEncodedToQty.containsKey(serialNumberCheck[i].Plc_EncodedSerialNumber__c.toUpperCase())) {
                         serialEncodedToQty.put(serialNumberCheck[i].Plc_EncodedSerialNumber__c.toUpperCase(), serialEncodedToQty.get(serialNumberCheck[i].Plc_EncodedSerialNumber__c )+1);
                     } else {
                         serialEncodedToQty.put(serialNumberCheck[i].Plc_EncodedSerialNumber__c.toUpperCase(), 1 );
                     }      
                 }
                 if (String.isNotBlank(serialNumberCheck[i].Plc_ManufacturerSerialNumber__c)) {
                     csvSerialToFoundSerial.put(serialNumberCheck[i].Plc_ManufacturerSerialNumber__c.toUpperCase(), serialNumberCheck[i]);
                     if (serialManuToQty.containsKey(serialNumberCheck[i].Plc_ManufacturerSerialNumber__c.toUpperCase())) {
                         serialManuToQty.put(serialNumberCheck[i].Plc_ManufacturerSerialNumber__c.toUpperCase(), serialManuToQty.get(serialNumberCheck[i].Plc_ManufacturerSerialNumber__c )+1);
                     } else {
                         serialManuToQty.put(serialNumberCheck[i].Plc_ManufacturerSerialNumber__c.toUpperCase(), 1 );
                     }      
                 }

            }


            for (Integer x = 0; x < serialsFromCSV.size(); x++) {
                Boolean hasError = false;
                Boolean isFound = false;
                 //L.B 13/05/2019 --FIX per mancato Alias della query- ORIGINALE:  if (string.isBlank(serialsFromCSV[x].productSku) && String.isBlank(serialsFromCSV[x].manufacturerAlias) ) {
                if (String.isBlank(serialsFromCSV[x].productSku) || String.isBlank(serialsFromCSV[x].manufacturerAlias) ) {
                    if (serialEncodedToQty.containsKey(serialsFromCSV[x].serialNumbers.toUpperCase())) {
                        if (serialEncodedToQty.get(serialsFromCSV[x].serialNumbers.toUpperCase()) > 1) {
                            hasError = true;
                            isFound = false;
                            serialsFromCSV[x].error = MULTIPLE_SERIAL_ERROR;               
                        } else {
                           isFound = true;
                           serialsFromCSV[x].manufacturerAlias = csvSerialToFoundSerial.get(serialsFromCSV[x].serialNumbers.toUpperCase()).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c;
                           serialsFromCSV[x].productSku = csvSerialToFoundSerial.get(serialsFromCSV[x].serialNumbers.toUpperCase()).Plc_ProductSku__c;
                        }     
                    } 
                    if (serialManuToQty.containsKey(serialsFromCSV[x].serialNumbers.toUpperCase()) && !hasError) {
                        if (serialManuToQty.get(serialsFromCSV[x].serialNumbers.toUpperCase()) > 1) {
                            hasError = true;
                            isFound = false;
                            serialsFromCSV[x].error = MULTIPLE_SERIAL_ERROR;               
                        } else {
                           isFound = true;
                           serialsFromCSV[x].manufacturerAlias = csvSerialToFoundSerial.get(serialsFromCSV[x].serialNumbers.toUpperCase()).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c;
                           serialsFromCSV[x].productSku = csvSerialToFoundSerial.get(serialsFromCSV[x].serialNumbers.toUpperCase()).Plc_ProductSku__c;
                        }   
                    }
                    if (serialDllToQty.containsKey(serialsFromCSV[x].serialNumbers.toUpperCase()) && !hasError) {
                        if (serialDllToQty.get(serialsFromCSV[x].serialNumbers.toUpperCase()) > 1 ) {
                            hasError = true;
                            isFound = false;
                            serialsFromCSV[x].error = MULTIPLE_SERIAL_ERROR;               
                        }  
                        else {
                          isFound = true;
                          serialsFromCSV[x].manufacturerAlias = csvSerialToFoundSerial.get(serialsFromCSV[x].serialNumbers.toUpperCase()).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c;
                          serialsFromCSV[x].productSku = csvSerialToFoundSerial.get(serialsFromCSV[x].serialNumbers.toUpperCase()).Plc_ProductSku__c;
                        }     
                    }

                    if (hasError) {
                          serialsFromCSV[x].manufacturerAlias = '';
                          serialsFromCSV[x].productSku = '';
                    }

                    if(!isFound && !hasError) {
                      serialsFromCSV[x].error = NO_SERIAL_FOUND_IN_DATABASE;              
                    }
                } else {
                    if ((String.isNotEmpty(serialsFromCSV[x].manufacturerAlias)
                         && String.isNotEmpty(serialsFromCSV[x].productSku))
                         || (String.isNotEmpty(serialsFromCSV[x].productSku)
                         && String.isEmpty(serialsFromCSV[x].manufacturerAlias))) {
                        serialsFromCSV[x].processStep = CHECK_BY_PRODUCT_SKU;
                    } else if (String.isEmpty(serialsFromCSV[x].productSku)
                               && String.isNotEmpty(serialsFromCSV[x].manufacturerAlias)) {
                        serialsFromCSV[x].processStep = CHECK_BY_MANUFACTURER_ALIAS;
                    }
                }
                //FB 20190627 - NEXIPLC-590 [START]
                if (String.isBlank(serialsFromCSV[x].error) && technicianWithdrawnManagement) {
                    if (String.isBlank(technicianName)) {
                        if (String.isNotBlank(serialsFromCSV[x].technician) && !contactMap.containsKey(serialsFromCSV[x].technician.toUpperCase())) {
                            serialsFromCSV[x].error = Label.Plc_ContactNotFound + ' ' + warehouse.Bit2Shop__Dealer_Id__r.Name; 
                        } else {
                            serialsFromCSV[x].technician = contactMap.get(serialsFromCSV[x].technician.toUpperCase()).Name;
                        }
                    } else {
                        serialsFromCSV[x].technician = technicianName;
                    }
                }
                //FB 20190627 - NEXIPLC-590 [END]
            }

        } catch (Exception e) {
            String errorMessage = '\n\ncheckCSVSerials Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }
        return concatAndSearch();
    }


   /* private static Map<String, Object> checkByProductSKU() {
        System.debug('\n\n@@@@@checkByProductSKU-start@@@@\n\n');
        //check checkByProductSku
        try {
            List<String> productSkuList = new List<String>();
            for (Integer i = 0; i < serialsFromCSV.size(); i++) {
                if (serialsFromCSV[i].processStep == CHECK_BY_PRODUCT_SKU) {
                    productSkuList.add(serialsFromCSV[i].productSku);
                    System.debug('\n@@@@checkskuSERIAL: ' + serialsFromCSV[i].serialNumbers + '\n');
                }
            }

            List<B2WExtCat__External_Catalog_Item__c> externalCatalogItems = [
                    SELECT Id,Plc_ProductSku__c,Plc_Manufacturer__r.Plc_Alias__c
                    FROM B2WExtCat__External_Catalog_Item__c
                    WHERE Plc_ProductSku__c IN :productSkuList
            ];

            System.debug('@@@@productSkuList: ' + productSkuList);
            System.debug('@@@@externalCatalogItems: ' + externalCatalogItems);


            for (Integer i = 0; i < externalCatalogItems.size(); i++) {
                for (Integer x = 0; x < serialsFromCSV.size(); x++) {

                    if (String.isEmpty(serialsFromCSV[x].error)) {

                    if (serialsFromCSV[x].processStep == CHECK_BY_PRODUCT_SKU) {
                        System.debug('\n@@@@matchedSKUProcessStep ' + serialsFromCSV[x] + '\n');
                        if (serialsFromCSV[x].productSku.equalsIgnoreCase(externalCatalogItems[i].Plc_ProductSku__c)) {

                            if (serialsFromCSV[x].manufacturerAlias.equalsIgnoreCase(externalCatalogItems[i].Plc_Manufacturer__r.Plc_Alias__c)
                                    || String.isEmpty(serialsFromCSV[x].manufacturerAlias)) {

                                serialsFromCSV[x].manufacturerAlias = externalCatalogItems[i].Plc_Manufacturer__r.Plc_Alias__c;
                                serialsFromCSV[x].processStep = MATCHED_BY_ALIAS;
                                serialsFromCSV[x].error = '';
                                System.debug('\n@@@@matchedSKU ' + serialsFromCSV + '\n');

                            } else if (serialsFromCSV[x].processStep != MATCHED_BY_ALIAS) {
                                serialsFromCSV[x].error = CSV_ALIAS_DIFF_MANU_ALIAS;
                                serialsFromCSV[x].processStep = NO_MATCH_BY_ALIAS;
                                System.debug('\n@@@@RecordWithDiffAlias ' + serialsFromCSV[x] + '\n');
                            }


                        } else {
                            //todo gestire come un warning?
                            if (String.isEmpty(serialsFromCSV[x].processStep)) {
                                serialsFromCSV[x].processStep = PRODUCT_SKU_NOT_PRESENT;
                            }
                            //fallback check to  the CSV manufacturerAlias (if present)
                            if (String.isEmpty(serialsFromCSV[x].manufacturerAlias)) {
                                serialsFromCSV[x].error = PRODUCT_SKU_AND_MANUFACTURER_ALIAS_NOT_PRESENT;
                            }
                        }
                    }

                }

                }

            }

            return concatAndSearch();

        } catch (Exception e) {
            String errorMessage = '\n\n@@@@checkByProductSKU Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }


    }*/

    private static Map<String, Object> concatAndSearch() {

        System.debug('\n\n@@@@@concatAndSearch-start@@@@\n\n');
        try {
            //CONCAT data to query
            List<String> cancatAlias_SerialNumber = new List<String>();
            for (Integer x = 0; x < serialsFromCSV.size(); x++) {
                if (String.isNotEmpty(serialsFromCSV[x].manufacturerAlias)
                        && String.isEmpty(serialsFromCSV[x].error)) {
                    cancatAlias_SerialNumber.add(serialsFromCSV[x].manufacturerAlias + '_' + serialsFromCSV[x].serialNumbers);
/** [START MOD 24/02/2019 15:55]@Author:marco.lebellini@/webresults.it @Description: **/
                    /*} else if (String.isEmpty(serialsFromCSV[x].error)) { //probably not necessary but whatever
                        serialsFromCSV[x].error = PRODUCT_SKU_AND_MANUFACTURER_ALIAS_NOT_PRESENT;*/
/** [END MOD 24/02/2019 15:55]@Author:marco.lebellini@/webresults.it @Description: **/
                }


            }


            //retrieving the stockSerials filtered by concatened costr.Alias and SerialNumber
            List<Bit2Shop__Stock_Serials2__c>filteredStockSerials = [
                    SELECT Plc_ProductSku__c,
                            Plc_Manufacturer__c,
                            Plc_DllSerialNumber__c,
                            Plc_DllSerialNumberUnique__c,
                            Plc_EncodedSerialNumber__c,
                            Plc_EncodedSerialNumberUnique__c,
                            Plc_ManufacturerSerialNumber__c,
                            Plc_ManufacturerSerialNumberUnique__c,
                            Plc_Model__c,
                            Bit2Shop__Warehouse_Id__c,
                            Bit2Shop__Status__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c,
                            Plc_WithdrawnBy__c,
                            Plc_Status2__c
                    FROM Bit2Shop__Stock_Serials2__c
                    WHERE Plc_DllSerialNumberUnique__c IN :cancatAlias_SerialNumber
                    OR Plc_EncodedSerialNumberUnique__c IN :cancatAlias_SerialNumber
                    OR Plc_ManufacturerSerialNumberUnique__c IN :cancatAlias_SerialNumber
            ];

            /*  AND Bit2Shop__Warehouse_Id__c = :warehouseId
              AND Bit2Shop__Status__c IN:stockSerialStatusList*/

            System.debug('@@@@filteredStockSerials: ' + filteredStockSerials);
            System.debug('@@@@cancatAlias_SerialNumber: ' + cancatAlias_SerialNumber);

            return composeListOfCSVserials(filteredStockSerials);

        } catch (Exception e) {
            String errorMessage = '\n\n@@@@concatAndSearch Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }

    }

    private static Map<String, Object> composeListOfCSVserials(List<Bit2Shop__Stock_Serials2__c>filteredStockSerials) {
        System.debug('\n\n@@@@@composeListOfCSVserials-start@@@@\n\n');
        try {
            //checking for more errors and composing the list of object
            List<CSVSerials> serialsResult = new List<CSVSerials>();

            Map<String, Bit2Shop__Stock_Serials2__c> manufacturerToSerialMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
            Map<String, Bit2Shop__Stock_Serials2__c> encodedToSerialMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
            Map<String, Bit2Shop__Stock_Serials2__c> dllToSerialMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
            //composeListOfCSVserials only on serials that are actually in the database
            Set<String> serialNumbersResult = new Set<String>();
            for (Integer x = 0; x < filteredStockSerials.size(); x++) {

                if (String.isNotBlank(filteredStockSerials[x].Plc_ManufacturerSerialNumber__c)) {
                    manufacturerToSerialMap.put(filteredStockSerials[x].Plc_ManufacturerSerialNumber__c.toUpperCase(), filteredStockSerials[x]);
                    serialNumbersResult.add(filteredStockSerials[x].Plc_ManufacturerSerialNumber__c.toUpperCase());
                }

                if (String.isNotBlank(filteredStockSerials[x].Plc_EncodedSerialNumber__c)) {
                    encodedToSerialMap.put(filteredStockSerials[x].Plc_EncodedSerialNumber__c.toUpperCase(), filteredStockSerials[x]);
                    serialNumbersResult.add(filteredStockSerials[x].Plc_EncodedSerialNumber__c.toUpperCase());
                }

                if (String.isNotBlank(filteredStockSerials[x].Plc_DllSerialNumber__c)) {
                    dllToSerialMap.put(filteredStockSerials[x].Plc_DllSerialNumber__c.toUpperCase(), filteredStockSerials[x]);
                    serialNumbersResult.add(filteredStockSerials[x].Plc_DllSerialNumber__c.toUpperCase());
                }
            }

            System.debug('### manufacturerToSerialMap ' + manufacturerToSerialMap);
            System.debug('### encodedToSerialMap ' + encodedToSerialMap);
            System.debug('### dllToSerialMap ' + dllToSerialMap);

            System.debug('### serialsFromCSV ' + serialsFromCSV);
            /*****************************************/

            Bit2Shop__Stock_Serials2__c stockSerial;
            Set<Integer> foundSerialRows = new Set<Integer>();
            for (Integer i = 0; i < serialsFromCSV.size(); i++) {

                if (manufacturerToSerialMap.containsKey(serialsFromCSV[i].serialNumbers.toUpperCase()) && !foundSerialRows.contains(i)) {                   
                    
                    stockSerial = manufacturerToSerialMap.get(serialsFromCSV[i].serialNumbers.toUpperCase());
                    foundSerialRows.add(i);

                    if (String.isNotEmpty(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c)
                            && String.isNotEmpty(serialsFromCSV[i].manufacturerAlias)) {
                        /*if (serialsFromCSV[i].productSku.equalsIgnoreCase(filteredStockSerials[x].Plc_ProductSku__c)
                                && serialsFromCSV[i].processStep != COMPOSE_LIST_OF_CSVSERIALS) {*/
                        if (serialsFromCSV[i].manufacturerAlias.equalsIgnoreCase(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c)
                                && serialsFromCSV[i].processStep != COMPOSE_LIST_OF_CSVSERIALS
                                && (serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_EncodedSerialNumber__c) || serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_ManufacturerSerialNumber__c)
                                || serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_DllSerialNumber__c))) {

                            //setting processStep to avoid duplicates
                            serialsFromCSV[i].processStep = COMPOSE_LIST_OF_CSVSERIALS;
                            serialsResult.add(elaborateCsvSerialWrp(serialsFromCSV[i], stockSerial));
                        }
                    }
                }
            }

            for (Integer i = 0; i < serialsFromCSV.size(); i++) {

                if (encodedToSerialMap.containsKey(serialsFromCSV[i].serialNumbers.toUpperCase()) && !foundSerialRows.contains(i)) {                   
                    
                    stockSerial = encodedToSerialMap.get(serialsFromCSV[i].serialNumbers.toUpperCase());
                    foundSerialRows.add(i);

                    if (String.isNotEmpty(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c)
                            && String.isNotEmpty(serialsFromCSV[i].manufacturerAlias)) {
                        /*if (serialsFromCSV[i].productSku.equalsIgnoreCase(filteredStockSerials[x].Plc_ProductSku__c)
                                && serialsFromCSV[i].processStep != COMPOSE_LIST_OF_CSVSERIALS) {*/
                        if (serialsFromCSV[i].manufacturerAlias.equalsIgnoreCase(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c)
                                && serialsFromCSV[i].processStep != COMPOSE_LIST_OF_CSVSERIALS
                                && (serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_EncodedSerialNumber__c) || serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_ManufacturerSerialNumber__c)
                                || serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_DllSerialNumber__c))) {

                            //setting processStep to avoid duplicates
                            serialsFromCSV[i].processStep = COMPOSE_LIST_OF_CSVSERIALS;
                            serialsResult.add(elaborateCsvSerialWrp(serialsFromCSV[i], stockSerial));
                        }
                    }
                }
            }

            for (Integer i = 0; i < serialsFromCSV.size(); i++) {

                if (dllToSerialMap.containsKey(serialsFromCSV[i].serialNumbers.toUpperCase()) && !foundSerialRows.contains(i)) {                   
                    
                    stockSerial = dllToSerialMap.get(serialsFromCSV[i].serialNumbers.toUpperCase());
                    foundSerialRows.add(i);

                    if (String.isNotEmpty(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c)
                            && String.isNotEmpty(serialsFromCSV[i].manufacturerAlias)) {
                        /*if (serialsFromCSV[i].productSku.equalsIgnoreCase(filteredStockSerials[x].Plc_ProductSku__c)
                                && serialsFromCSV[i].processStep != COMPOSE_LIST_OF_CSVSERIALS) {*/
                        if (serialsFromCSV[i].manufacturerAlias.equalsIgnoreCase(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c)
                                && serialsFromCSV[i].processStep != COMPOSE_LIST_OF_CSVSERIALS
                                && (serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_EncodedSerialNumber__c) || serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_ManufacturerSerialNumber__c)
                                || serialsFromCSV[i].serialNumbers.equalsIgnoreCase(stockSerial.Plc_DllSerialNumber__c))) {

                            //setting processStep to avoid duplicates
                            serialsFromCSV[i].processStep = COMPOSE_LIST_OF_CSVSERIALS;
                            serialsResult.add(elaborateCsvSerialWrp(serialsFromCSV[i], stockSerial));
                        }
                    }
                }
            }

            /**********************************/

            System.debug('@@@@serialsResult ' + serialsResult);

            //comparing old list with new list to check serials not in database
            for (Integer i = 0; i < serialsFromCSV.size(); i++) {
                if (!serialNumbersResult.contains(serialsFromCSV[i].serialNumbers)
                        && String.isEmpty(serialsFromCSV[i].error)) {
                   serialsFromCSV[i].error = NO_SERIAL_FOUND_IN_DATABASE;
                }


                /* for (Integer i = 0; i < serialsFromCSV.size(); i++) {
                     for (Integer x = 0; x < serialsResult.size(); x++) {
                         if (serialsResult[x].serialNumbers.equalsIgnoreCase(serialsFromCSV[i].serialNumbers)) {
                             serialsFromCSV[i].error = '';
                             serialsFromCSV[i].processStep = MATCHED_BY_SERIAL_NUMBER;
                             System.debug('\n@@@@matchedserials ' + serialsFromCSV[i] + '\n');
                         } else if (serialsFromCSV[i].processStep != MATCHED_BY_SERIAL_NUMBER) {
                             serialsFromCSV[i].error = NO_SERIAL_FOUND_IN_DATABASE;
                             System.debug('\n@@@@unmatchedserials ' + serialsFromCSV[i] + '\n');
                         }
                     }*/

                if (serialsResult.isEmpty()) {
                    for (Integer y = 0; y < serialsFromCSV.size(); y++) {
                        serialsFromCSV[y].error = String.isEmpty(serialsFromCSV[y].error)
                                ? NO_SERIAL_FOUND_IN_DATABASE
                                : serialsFromCSV[y].error;
                    }
                    break;
                }

            }
            return sepValRecFromInvRec(serialsResult);

        } catch (Exception e) {
            String errorMessage = '\n\n@@@@composeListOfCSVserials Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }
    }

    private static Map<String, Object> sepValRecFromInvRec(List<CSVSerials> serialsResult) {

        System.debug('\n\n@@@@@sepValRecFromInvRec-start@@@@\n\n');
        try {
            //adding records in error (from the firstcheck) to a list and concateneting the csv line
            List<CSVSerials> invalidSerialsresult = new List<CSVSerials>();
            for (Integer i = 0; i < serialsFromCSV.size(); i++) {
                //todo except the warning above?
                if (String.isNotEmpty(serialsFromCSV[i].error)) {
                    serialsFromCSV[i].error += '\nCSV line: ' + serialsFromCSV[i].csvLinePosition;
                    invalidSerialsresult.add(serialsFromCSV[i]);
                }
            }

            System.debug('@@@@invalidSerialsresultCheck_1: ' + invalidSerialsresult);
            //adding records in error (from the second check) to a list
            for (Integer i = 0; i < serialsResult.size(); i++) {
                if (String.isNotEmpty(serialsResult[i].error)) {
                    serialsResult[i].error += '\nCSV line: ' + serialsResult[i].csvLinePosition;
                    invalidSerialsresult.add(serialsResult[i]);
                }
            }

            System.debug('@@@@invalidSerialsresultCheck_2: ' + invalidSerialsresult);
            //adding valid records to a list
            List<CSVSerials> validSerialsResult = new List<CSVSerials>();
            for (Integer i = 0; i < serialsResult.size(); i++) {
                if (String.isEmpty(serialsResult[i].error)) {
                    validSerialsResult.add(serialsResult[i]);
                }
            }


            Map<String, Object> results = new Map<String, Object>();
            results.put('validResults', validSerialsResult);
            results.put('invalidResults', invalidSerialsresult);

            System.debug('@@@@validSerialsResult' + validSerialsResult);


            //creating the list of records to sent in the event
            List<CSVSerials> recordsToReturnInEvt = new List<CSVSerials>();
            for (CSVSerials csvs : validSerialsResult) {
                recordsToReturnInEvt.add(csvs);
            }
            results.put('stockSerialFromCSV', recordsToReturnInEvt(recordsToReturnInEvt));
            //FB 20190627 - NEXIPLC-590 [START]
            results.put('additionalData', new Map<String, Object>{
                'contactMap' => contactMap,
                'serialIdToTechnicianMap' => serialIdToTechnicianMap
            });
            //FB 20190627 - NEXIPLC-590 [END]
            return results;

        } catch (Exception e) {
            String errorMessage = '@@@@sepValRecFromInvRec Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(errorMessage);
            return null;
        }

    }


/**
 * *************************************************
 *     * @Author nunzio.capasso@/webresults.it
 *     * @date  12/02/2019 10:53
 *     * @description method that return a list o valid serial given a valid list of CSVSerials
 *     * @param serialsToQuery list of valid CSVSerials
 *     * @Modified by
 *   ***********************************************
 **/
    @AuraEnabled
    public static List<Bit2Shop__Stock_Serials2__c> recordsToReturnInEvt(List<CSVSerials> serialsToQuery) {

        System.debug('@@@@@recordsToReturnInEvt-start@@@@');
        try {

            if (serialsToQuery.isEmpty()) {
                return null;
            }

            List<String> stringSerialsToquery = new List<String>();

            for (CSVSerials csvs : serialsToQuery) {
                stringSerialsToquery.add(csvs.manufacturerAlias + '_' + csvs.serialNumbers);
            }

            System.debug('@@@@stringSerialsToquery: ' + stringSerialsToquery);

            List<Bit2Shop__Stock_Serials2__c>recordsToReturnInEvt = [
                    SELECT Plc_ProductSku__c,
                            Plc_Manufacturer__c,
                            Plc_DllSerialNumber__c,
                            Plc_DllSerialNumberUnique__c,
                            Plc_EncodedSerialNumber__c,
                            Plc_EncodedSerialNumberUnique__c,
                            Plc_ManufacturerSerialNumber__c,
                            Plc_ManufacturerSerialNumberUnique__c,
                            Plc_Model__c,
                            Bit2Shop__Warehouse_Id__c,
                            Bit2Shop__Status__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,
                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,
                            Plc_WithdrawnBy__c,
                            Plc_Status2__c
                    FROM Bit2Shop__Stock_Serials2__c
                    WHERE Plc_DllSerialNumberUnique__c IN :stringSerialsToquery
                    OR Plc_EncodedSerialNumberUnique__c IN :stringSerialsToquery
                    OR Plc_ManufacturerSerialNumberUnique__c IN :stringSerialsToquery
            ];

            System.debug('@@@@recordsToReturnInEvt: ' + recordsToReturnInEvt);

            return recordsToReturnInEvt;


        } catch (Exception e) {
            String errorMessage = '@@@@recordsToReturnInEvt Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(errorMessage);
            return null;
        }
    }

    private static CSVSerials elaborateCsvSerialWrp(CSVSerials serialsFromCSV, Bit2Shop__Stock_Serials2__c stockSerial){ 

        CSVSerials holdserials = new CSVSerials();
        holdserials.serialNumbers = serialsFromCSV.serialNumbers;
        holdserials.manufacturerAlias = serialsFromCSV.manufacturerAlias;
        holdserials.productSku = stockSerial.Plc_ProductSku__c;
        holdserials.technician = serialsFromCSV.technician;
        //FB 20190627 - NEXIPLC-590 [START]
        if (technicianWithdrawnManagement && String.isBlank(technicianName)) {
            serialIdToTechnicianMap.put(stockSerial.Id, serialsFromCSV.technician == null ? '' : serialsFromCSV.technician);
        }
        //FB 20190627 - NEXIPLC-590 [END]
        
        if (String.isNotEmpty(warehouseIdStat)) {


            if (stockSerial.Bit2Shop__Warehouse_Id__c == warehouseIdStat) {
                holdserials.error = '';
            } else {
                holdserials.error = DIFFERENT_WAREHOUSE;
            }
        }
        if (!stockSerialStatusList.isEmpty()) {

            if (!stockSerialStatusList.contains(stockSerial.Bit2Shop__Status__c)) {
                if (holdserials.error == DIFFERENT_WAREHOUSE) {
                    holdserials.error = DIFFERENT_WAREHOUSE_AND_STATUS;
                } else {
                    holdserials.error = DIFFERENT_STATUS;
                }
            } else if (String.isNotEmpty(holdserials.error) && holdserials.error != DIFFERENT_WAREHOUSE) {
                holdserials.error = DIFFERENT_STATUS;
            }
        }
        //FB 20190627 - NEXIPLC-590: Adding skipStatus2Check variable [START]
        if (!skipStatus2Check && stockSerial.Plc_Status2__c != 'None') {
            holdserials.error = STATUS2_NOT_NONE;
        }
        //FB 20190627 - NEXIPLC-590 [END]
        
        //handle Liverani process
        if (!distributionListItemModelsList.isEmpty()) {
            if (!distributionListItemModelsList.contains(stockSerial.Plc_Model__c)) {
                if (holdserials.error == DIFFERENT_STATUS) {
                    //different model and status error
                    holdserials.error = DIFFERENT_MODEL_AND_STATUS;
                } else {
                    holdserials.error = DIFFERENT_MODEL;
                }
            }
        }

        holdserials.csvLinePosition = serialsFromCSV.csvLinePosition;
        holdserials.processStep = '';

        return holdserials;
    }
}