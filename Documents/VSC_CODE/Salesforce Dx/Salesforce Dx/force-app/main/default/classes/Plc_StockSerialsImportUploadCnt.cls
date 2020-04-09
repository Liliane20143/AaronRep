/** 
 * @author Francesco Bigoni
 * @date Creation 23/11/2018 
 * @description Controller of lightning component Plc_StockSerialsImportUpload
 * @errorcode [ERR:CL-00DYYZZ]
 *
 * 2019-03-27 FB - Adding update records handling
 */
public with sharing class Plc_StockSerialsImportUploadCnt {

    private static List<String> inputCsvRows = new List<String>();
    private static final Integer INPUT_CHARACTER_MAX = 100000; // Default csv character limit
    private static final Integer INPUT_ROW_INSERT_MAX = 4000;
    private static final Integer INPUT_ROW_UPDATE_MAX = 1500;

    private static Map<String, Integer> insertFieldMapping = new Map<String, Integer> {
        'Plc_ManufacturerSerialNumber__c' => 0,
        'Plc_EncodedSerialNumber__c' => 1,
        'Plc_DllSerialNumber__c' => 2,
        'Plc_ProductSku__c' => 3,
        'Plc_Alias__c' => 4,
        'Bit2Shop__Status__c' => 5,
        'Bit2Shop__Purchase_Price__c' => 6,
        'Plc_PTSCode__c' => 7 ,
        'Plc_PcipedModel__c' => 8,
        'Plc_PcipedLetterOfApproval__c' => 9,
        'Plc_PcipedApprovalNumber__c' => 10,
        'Plc_PcipedVersion__c' => 11,
        'Plc_PcipedExpiryDate__c' => 12,
        'Plc_Note__c' => 13
    };

    private static Map<String, Integer> updateFieldMapping = new Map<String, Integer> {   
        'Id' => 0,
        'Plc_Alias__c' => 1,
        'Plc_ManufacturerSerialNumber__c' => 2,
        'Plc_EncodedSerialNumber__c' => 3,
        'Plc_DllSerialNumber__c' => 4,
        'Plc_ProductSku__c' => 5,
        'Bit2Shop__Status__c' => 6,
        'Plc_Status2__c' => 7,
        'Bit2Shop__Purchase_Price__c' => 8,
        'Plc_PTSCode__c' => 9,
        'Plc_PcipedModel__c' => 10,
        'Plc_PcipedLetterOfApproval__c' =>11,
        'Plc_PcipedApprovalNumber__c' => 12,
        'Plc_PcipedVersion__c' => 13,
        'Plc_PcipedExpiryDate__c' => 14
    };

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

    /**
    * Method used in order to get update report id
    *
    * @code 02
    * 
    * @param  No one
    * @return Id of update record template
    */
    @AuraEnabled
    public static Map<String, Object> retrieveUpdateReport(){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {
            //Getting id of template report
            Plc_SystemSettings__c settings = Plc_SystemSettings__c.getInstance();
            response.put('updateReportId', settings.Plc_SerialsUpdateReportId__c);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-00D0201] ' + e.getMessage());
        }
        return response;
    }

    /**
    * Method used in order to get some utils and context data
    *
    * @code 03
    * 
    * @param  warehouseId Starting warehouse record
    * @return Utils and context data
    */
    @AuraEnabled
    public static Map<String, Object> retrievePropertiesMap(String warehouseId){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);

        try {
            Bit2Shop__Warehouse__c warehouse = [SELECT Id, Name, Plc_Alias__c
                                                FROM Bit2Shop__Warehouse__c
                                                WHERE Id = :warehouseId];

            response.put('warehouse', warehouse);
            //Getting id of template report
            Plc_SystemSettings__c settings = Plc_SystemSettings__c.getInstance();
            response.put('updateReportId', settings.Plc_SerialsUpdateReportId__c);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-00D0301] ' + e.getMessage());
        }
        return response;
    }

    /**
     * Evaluates the list of stock serials from given csv input file 
     *
     * @code 04
     *
     * @param  csvAsString         Uploaded csv file represented by a string
     * @param  warehouseId         Starting warehouse record
     * @param  columnDelimiter     Sets the column delimiter
     * @param  isEditMode          Identifies whether we are currently in update mode
     * @return                     List of stock serials with status messagges
     */
    @AuraEnabled
    public static Map<String,Object> parseCsvInputfile(String csvAsString, String warehouseId, String columnDelimiter, Boolean isEditMode) {

        Map<String, Object> response = new Map<String, Object>();
        Map<String, String> translationMap = retrieveTranslationMap();
        response.put('error', false);
        columnDelimiter = String.isBlank(columnDelimiter) ? ',' : columnDelimiter;

        //Map containing error messagges
        Map<String, String> errorMessagesMap = new Map<String, String> {
            'InvalidFileErrorMessage' => Label.Plc_AllAllInvalidFileErrorMessage,
            'UpdateWarningMessage' => '[Warning] ' + Label.Plc_LightningComponentStockSerialsImportUploadUpdateWarningMessage,
            'Missing_Bit2Shop__Product_Stock__c' => '[Warning] ' + Label.Plc_LightningComponentStockSerialsImportUploadMissingProductStockWarningMessage,
            'WarehouseNotFoundMessage' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadWarehouseNotFoundMessage,
            'Missing_Serials' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadMissingSerialsErrorMessage,
            'Missing_Plc_ProductSku__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadMandatoryFieldErrorMessage
                                                                           .replace('{0}', translationMap.get('Plc_ProductSku__c')),
            'Missing_Warehouse_Alias' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadMandatoryFieldErrorMessage
                                                                        .replace('{0}', translationMap.get('Plc_Alias__c')),
            'DuplicatedInFile_Plc_ManufacturerSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadDuplicatedValueErrorMessage
                                                                                                 .replace('{0}', translationMap.get('Plc_ManufacturerSerialNumber__c')),
            'DuplicatedInFile_Plc_EncodedSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadDuplicatedValueErrorMessage
                                                                                            .replace('{0}', translationMap.get('Plc_EncodedSerialNumber__c')),
            'DuplicatedInFile_Plc_DllSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadDuplicatedValueErrorMessage
                                                                                        .replace('{0}', translationMap.get('Plc_DllSerialNumber__c')),
            'Error_Plc_ProductSku__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadProductStockErrorMessage,
            'Error_B2WExtCat__External_Catalog_Item__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadModelErrorMessage
                                                                                          .replace('{1}', translationMap.get('B2WExtCat__External_Catalog_Item__c')),
            'DuplicatedRecord_Plc_ManufacturerSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllDuplicatedRecordErrorMessage
                                                                                                 .replace('{0}', translationMap.get('Plc_ManufacturerSerialNumber__c')),
            'DuplicatedRecord_Plc_EncodedSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllDuplicatedRecordErrorMessage
                                                                                            .replace('{0}', translationMap.get('Plc_EncodedSerialNumber__c')),
            'DuplicatedRecord_Plc_DllSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllDuplicatedRecordErrorMessage
                                                                                        .replace('{0}', translationMap.get('Plc_DllSerialNumber__c')),
            'Invalid_Bit2Shop__Purchase_Price__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllNotValidValueErrorMessage
                                                                                    .replace('{0}', translationMap.get('Bit2Shop__Purchase_Price__c')),
            'Invalid_Plc_PcipedExpiryDate__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllNotValidValueErrorMessage
                                                                                .replace('{0}', translationMap.get('Plc_PcipedExpiryDate__c')),
            'Invalid_Bit2Shop__Status__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllNotValidValueErrorMessage
                                                                            .replace('{0}', translationMap.get('Bit2Shop__Status__c')),
            'Unmatching_Plc_Alias__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadWarehouseAliasMatchErrorMessage,
            'Forbidden_Bit2Shop__Status__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadForbiddenStatusErrorMessage,
            'Forbidden_Plc_Tipology__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadForbiddenTipologyErrorMessage,
            'NotAlphanumeric_Plc_ManufacturerSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadNotAlphanumericSerialMessage
                                                                                                 .replace('{0}', translationMap.get('Plc_ManufacturerSerialNumber__c')),
            'NotAlphanumeric_Plc_EncodedSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadNotAlphanumericSerialMessage
                                                                                            .replace('{0}', translationMap.get('Plc_EncodedSerialNumber__c')),
            'NotAlphanumeric_Plc_DllSerialNumber__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadNotAlphanumericSerialMessage
                                                                                        .replace('{0}', translationMap.get('Plc_DllSerialNumber__c')),

            'Forbidden_Plc_Status2__c' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllNotValidValueErrorMessage
                                                                         .replace('{0}', translationMap.get('Plc_Status2__c')),
            'Missing_Id' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadMandatoryFieldErrorMessage
                                                           .replace('{0}', 'ID'),
            'Not_Found_Stock_Serial' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllNoRecordFoundWithField
                                                                       .replace('{0}', translationMap.get('Bit2Shop__Stock_Serials2__c')),
            'Invalid_Id' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_AllAllNotValidValueErrorMessage,
            'Unmatching_Serial_Warehouse' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadUnmatchingSerialWhAlias,
            //TODO
            'Update_From_Undefined' => '[Warning] ' + Label.Plc_LightningComponentStockSerialsImportUploadMatchingUndefinedWarning,
            'Unmatching_Sku_Error' => '[' + Label.Plc_AllAllError + '] ' + Label.Plc_LightningComponentStockSerialsImportUploadMatchingUnmatchingSku 
            
        };

        /**
         *  The structure of the input csv file must be the following:
         *  - 1 header row, composed by fields:
         *  Manufacturer Serial Number | Encoded Serial Number | DLL Serial Number | Modello (SKU)* | Warehouse alias | Purchase Price | PTS Code | PCIPED Model |
         *  PCIPED Letter of Approval | PCIPED Approval Nr. | PCIPED Version | PCIPED Expiry date| Note 
         *  ==> mandatory, the ones indicated by the star (*)
         */

        try {

            /* START
             * Initialization
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Decoding input file
            String inputFile;
            String file;
            try {
                inputFile = EncodingUtil.urlDecode(csvAsString, 'UTF-8');
                file = EncodingUtil.base64Decode(inputFile).toString();
            } catch (StringException se) {
                response.put('error', true);
                response.put('errorMsg', errorMessagesMap.get('InvalidFileErrorMessage'));
                return response;
            }

            Integer pivot = file.indexOf( '\n', Integer.valueOf(Math.floor(inputFile.length() / 2)) );

            if (pivot > INPUT_CHARACTER_MAX) {
                divideString(file);
            }
            else {
                inputCsvRows = file.split('\n');
            }

            List<String> inputCsvRowsToReturn = new List<String>();
            Set<Integer> inputRowsWithoutErrors = new Set<Integer>(); 
            List<Integer> indexesToRemove = new List<Integer>();
            String warehouseInputAlias = '';
            String warehouseInputTipology = '';
            //Checking if input csv is composed by just one row
            if (inputCsvRows.isEmpty() || inputCsvRows.size() == 1) {

                response.put('error', true);
                response.put('errorMsg', errorMessagesMap.get('InvalidFileErrorMessage'));
                return response;
            }
            //Getting selected warehouse
            List<Bit2Shop__Warehouse__c> warehouseInputList = [SELECT Id, Name, Plc_Alias__c
                                                               FROM Bit2Shop__Warehouse__c
                                                               WHERE Id = :warehouseId];
            //If a warehouse was found then it means that user started from a selected 
            //specific warehouse
            if (warehouseInputList.size() > 0) {
                warehouseInputAlias = warehouseInputList.get(0).Plc_Alias__c;
            }
            //Getting current user profile
            String profileName = [SELECT Id, Name 
                                  FROM Profile 
                                  WHERE Id=:Userinfo.getProfileId()].Name;
            //Retrieving available picklist values for the status field
            Map<String, Schema.PicklistEntry> statusAvailableValuesMap = retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c',
                                                                                                      'Bit2Shop__Status__c');
            Map<String, Schema.PicklistEntry> status2AvailableValuesMap = retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c',
                                                                                                      'Plc_Status2__c');
            //Removing header from Csv file if the check was ok
            inputCsvRows.remove(0);
            Map<Integer, List<String>> rowIndexErrorsListMap = new Map<Integer, List<String>>();
            Map<Integer, List<String>> rowIndexWarningsListMap = new Map<Integer, List<String>>();
            Map<Integer, List<String>> rowIndexExistingIdsListMap = new Map<Integer, List<String>>();
            Map<String, List<String>> skuToModelIdsMap = new Map<String, List<String>>();
            Map<String, List<Integer>> manufacturerSerialRowIndexesMap = new Map<String, List<Integer>>();
            Map<String, List<Integer>> encodedSerialRowIndexesMap = new Map<String, List<Integer>>();
            Map<String, List<Integer>> dllSerialRowIndexesMap = new Map<String, List<Integer>>();
            Map<String, List<Integer>> warehouseAliasRowIndexesMap = new Map<String, List<Integer>>();
            Map<Integer, String> rowIndexModelSkuMap = new Map<Integer, String>();
            Map<Integer, String> rowIndexToAliasMap = new Map<Integer, String>();
            Map<Integer, String> rowIndexToModelSkuWarehouseMap = new Map<Integer, String>();
            Map<String, String> rowIndexToExistingIdMap = new Map<String, String>();
            Map<String, String> rowIndexWarehouseMap = new Map<String, String>();
            Map<String, String> skuToManufacturerAlias = new Map<String, String>();
            Map<String, Integer> serialIdToRowIndexMap = new Map<String, Integer>();
            Set<Integer> foundSerialRowsSet = new Set<Integer>();
            Set<String> foundModelsSkuSet = new Set<String>();
            Set<String> foundWarehousesSet = new Set<String>();
            Set<String> manufacturerSerialsUniqueSet = new Set<String>();
            Set<String> encodedSerialsUniqueSet = new Set<String>();
            Set<String> dllSerialsUniqueSet = new Set<String>();
            Map<String, Bit2Shop__Warehouse__c> warehouseAliasToWarehouseMap = new Map<String, Bit2Shop__Warehouse__c>();
            Map<String, B2WExtCat__External_Catalog_Item__c> skuToModelMap = new Map<String, B2WExtCat__External_Catalog_Item__c>();
            Integer currentIndex = 0;
            Boolean hasWarehouse;
            Boolean hasAtLeastOneSerial;
            Integer fieldIndex; //It is calculated during runtime
            Integer fieldSkuIndex;
            Integer fieldAliasIndex;  

            if (isEditMode) {
                fieldSkuIndex = updateFieldMapping.get('Plc_ProductSku__c');
                fieldAliasIndex = updateFieldMapping.get('Plc_Alias__c');
            } else {
                fieldSkuIndex = insertFieldMapping.get('Plc_ProductSku__c');   
                fieldAliasIndex = insertFieldMapping.get('Plc_Alias__c');
            }

            /* END
             * Initialization
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Iterating though csv file in order to find syntactical errors
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            for (Integer index = 0; index < inputCsvRows.size(); index++) {
                hasWarehouse = false;
                hasAtLeastOneSerial = false;

                if (String.isBlank(inputCsvRows.get(index))) {
                    indexesToRemove.add(index);
                } else {

                    inputCsvRows[index] = inputCsvRows.get(index)
                                          .replace('\n','')
                                          .replace('"','')
                                          .trim();

                    List<String> cells = inputCsvRows.get(index).split(columnDelimiter);

                    if (isEditMode) {
                        fieldIndex = updateFieldMapping.get('Plc_ManufacturerSerialNumber__c');
                    } else {
                        fieldIndex = insertFieldMapping.get('Plc_ManufacturerSerialNumber__c');
                    }

                    if (cells.size() > fieldIndex) {
                        //Checking Manufacturer Serial Number
                        String serialNumber = cells.get(fieldIndex).trim().toUpperCase();
                        cells[fieldIndex] = cells.get(fieldIndex).trim().toUpperCase();
                        
                        if (!String.isBlank(serialNumber)) {
                            hasAtLeastOneSerial = true;
                            if (serialNumber.isAlphanumeric()) {
                                if (manufacturerSerialRowIndexesMap.containsKey(serialNumber)) {
                                    manufacturerSerialRowIndexesMap.get(serialNumber).add(currentIndex + 1);
                                } else {
                                    manufacturerSerialRowIndexesMap.put(serialNumber, new List<Integer> {currentIndex + 1});
                                }
                            } else {
                                rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('NotAlphanumeric_Plc_ManufacturerSerialNumber__c')});
                            }
                        }
                    }

                    if (isEditMode) {
                        fieldIndex = updateFieldMapping.get('Plc_EncodedSerialNumber__c');
                    } else {
                        fieldIndex = insertFieldMapping.get('Plc_EncodedSerialNumber__c');    
                    }

                    if (cells.size() > fieldIndex) {
                        //Checking Matricola Calcolata (Nexi)
                        String matricola = cells.get(fieldIndex).trim().toUpperCase();
                        cells[fieldIndex] = cells.get(fieldIndex).trim().toUpperCase();

                        if (!String.isBlank(matricola)) {
                            hasAtLeastOneSerial = true;
                            if (matricola.isAlphanumeric()) {
                                if (encodedSerialRowIndexesMap.containsKey(matricola)) {
                                    encodedSerialRowIndexesMap.get(matricola).add(currentIndex + 1);
                                } else {
                                    encodedSerialRowIndexesMap.put(matricola, new List<Integer> {currentIndex + 1});
                                }
                            } else {
                                if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                    rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('NotAlphanumeric_Plc_EncodedSerialNumber__c'));
                                } else {
                                    rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('NotAlphanumeric_Plc_EncodedSerialNumber__c')});
                                }
                            }
                        }
                    }

                    if (isEditMode) {
                        fieldIndex = updateFieldMapping.get('Plc_DllSerialNumber__c');
                    } else {
                        fieldIndex = insertFieldMapping.get('Plc_DllSerialNumber__c');    
                    }

                    if (cells.size() > fieldIndex){
                        //Checking DLL Serial Number
                        String dllSerialNumber = cells.get(fieldIndex).trim().toUpperCase();
                        cells[fieldIndex] = cells.get(fieldIndex).trim().toUpperCase();

                        if (!String.isBlank(dllSerialNumber)) {
                            hasAtLeastOneSerial = true;
                            if (dllSerialNumber.isAlphanumeric()) {
                                if (dllSerialRowIndexesMap.containsKey(dllSerialNumber)) {
                                    dllSerialRowIndexesMap.get(dllSerialNumber).add(currentIndex + 1);
                                } else {
                                    dllSerialRowIndexesMap.put(dllSerialNumber, new List<Integer> {currentIndex + 1});
                                }
                            } else {
                                if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                    rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('NotAlphanumeric_Plc_DllSerialNumber__c'));
                                } else {
                                    rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('NotAlphanumeric_Plc_DllSerialNumber__c')});
                                }
                            }
                        }
                    }

                    if (cells.size() > fieldSkuIndex) {
                        //Checking Model (SKU)
                        String modelSku = cells.get(fieldSkuIndex).trim();
                        if (String.isBlank(modelSku)) {
                            if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Missing_Plc_ProductSku__c'));
                            } else {
                                rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Missing_Plc_ProductSku__c')});
                            }
                        }
                    } else {
                        if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                            rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Missing_Plc_ProductSku__c'));
                        } else {
                            rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Missing_Plc_ProductSku__c')});
                        }
                    }

                    //Checking warehouse alias
                    if (cells.size() > fieldAliasIndex) {
                        String warehouseAlias = cells.get(fieldAliasIndex).trim();
                        if (!String.isBlank(warehouseAlias)) {
                            hasWarehouse = true;
                            if (warehouseAliasRowIndexesMap.containsKey(warehouseAlias)) {
                                warehouseAliasRowIndexesMap.get(warehouseAlias).add(currentIndex + 1);
                            } else {
                                warehouseAliasRowIndexesMap.put(warehouseAlias, new List<Integer> {currentIndex + 1});
                            }
                        } else if (!String.isBlank(warehouseInputAlias)) {
                            if (warehouseAliasRowIndexesMap.containsKey(warehouseInputAlias)) {
                                warehouseAliasRowIndexesMap.get(warehouseInputAlias).add(currentIndex + 1);
                            } else {
                                warehouseAliasRowIndexesMap.put(warehouseInputAlias, new List<Integer> {currentIndex + 1});
                            }
                        }
                    }

                    if (isEditMode) {
                        fieldIndex = updateFieldMapping.get('Bit2Shop__Status__c');
                    } else {
                        fieldIndex = insertFieldMapping.get('Bit2Shop__Status__c');    
                    }

                    //Checking serial status
                    if (cells.size() > fieldIndex) {
                        String status = cells.get(fieldIndex).trim();
                        if (!String.isBlank(status)){
                            //Making first letter capital because first letter of api names needs uppercase
                            status = status.toLowerCase();
                            if(!statusAvailableValuesMap.containsKey(status)) {
                                if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                    rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Invalid_Bit2Shop__Status__c'));
                                } else {
                                    rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Invalid_Bit2Shop__Status__c')});
                                }
                            } else {
                                //Checking whether current user can decide the status other than 'New'
                                if(profileName == 'Costruttore' && (status != 'new' && status != 'nuovo')) {
                                    if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                        rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Forbidden_Bit2Shop__Status__c') 
                                                                                    + ' "' + cells.get(fieldIndex).trim() + '"');
                                    } else {
                                        rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Forbidden_Bit2Shop__Status__c') 
                                                                                                  + ' \'' + cells.get(fieldIndex).trim() + '\''});
                                    }
                                }
                            }
                        }
                    }

                    if (isEditMode) {
                        fieldIndex = updateFieldMapping.get('Bit2Shop__Purchase_Price__c');
                    } else {
                        fieldIndex = insertFieldMapping.get('Bit2Shop__Purchase_Price__c');    
                    }

                    //Checking price
                    if (cells.size() > fieldIndex) {
                        try {
                            if (String.isNotBlank(cells[fieldIndex].trim())) {
                                Double.valueOf(cells[fieldIndex].trim());
                            }
                        } catch (Exception e) {
                            if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Invalid_Bit2Shop__Purchase_Price__c'));
                            } else {
                                rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Invalid_Bit2Shop__Purchase_Price__c')});
                            }
                        }
                    }

                    if (isEditMode) {
                        fieldIndex = updateFieldMapping.get('Plc_PcipedExpiryDate__c');
                    } else {
                        fieldIndex = insertFieldMapping.get('Plc_PcipedExpiryDate__c');    
                    }

                    //Checking whether expiry date is valid
                    if (cells.size() > fieldIndex) {
                        try {
                            if (String.isNotBlank(cells[fieldIndex].trim())) {
                                Date.parse(cells[fieldIndex].trim());
                            }
                        } catch (Exception e) {
                            if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Invalid_Plc_PcipedExpiryDate__c'));
                            } else {
                                rowIndexErrorsListMap.put(currentIndex, new List<String>{errorMessagesMap.get('Invalid_Plc_PcipedExpiryDate__c')});
                            }
                        }
                    }

                    if (isEditMode) {

                        //Checking id
                        fieldIndex = updateFieldMapping.get('Id');

                        if (cells.size() > fieldIndex) {
                            //Checking Model (SKU)
                            
                            String serialId = cells.get(fieldIndex).trim();

                            if (String.isBlank(serialId)) {
                                if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                    rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Missing_Id'));
                                } else {
                                    rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Missing_Id')});
                                }
                            } else {
                                try {
                                    Id id = serialId;
                                    serialIdToRowIndexMap.put(id, currentIndex);

                                } catch (Exception e) {
                                    if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                        rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Invalid_Id').replace('{0}', '[' + serialId + '] ID'));
                                    } else {
                                        rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Invalid_Id').replace('{0}', '[' + serialId + '] ID')});
                                    }
                                }
                            }
                        } else {
                            if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Missing_Id'));
                            } else {
                                rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Missing_Id')});
                            }
                        }

                        //If it is edit mode check status 2 
                        fieldIndex = updateFieldMapping.get('Plc_Status2__c');
                        //Checking serial status 2
                        if (cells.size() > fieldIndex) {
                            String status2 = cells.get(fieldIndex).trim();
                            if (!String.isBlank(status2)){
                                //Making first letter capital because first letter of api names needs uppercase
                                status2 = status2.toLowerCase();
                                if(!status2AvailableValuesMap.containsKey(status2)) {
                                    if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                        rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Forbidden_Plc_Status2__c'));
                                    } else {
                                        rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Forbidden_Plc_Status2__c')});
                                    }
                                }
                            }
                        }
                    } else {

                        //In this case it means that no serial has been specified
                        if (!hasAtLeastOneSerial) {
                            if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                                rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Missing_Serials'));
                            } else {
                                rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Missing_Serials')});
                            }
                        }
                    }

                    //In this case the warehouse was not specified in the file therefore throws an error
                    if (!hasWarehouse && warehouseId == '') {
                        if (rowIndexErrorsListMap.containsKey(currentIndex)) {
                            rowIndexErrorsListMap.get(currentIndex).add(errorMessagesMap.get('Missing_Warehouse_Alias'));
                        } else {
                            rowIndexErrorsListMap.put(currentIndex, new List<String> {errorMessagesMap.get('Missing_Warehouse_Alias')});
                        }
                    }
                    inputCsvRowsToReturn.add(String.join(cells, columnDelimiter));
                    currentIndex ++;
                }
            }
            //Checking duplicates inside the csv file and putting errors is something is not correct
            for (String tempSerialNumber : manufacturerSerialRowIndexesMap.keySet()) {
                if (manufacturerSerialRowIndexesMap.get(tempSerialNumber).size() > 1){
                    for (Integer i : manufacturerSerialRowIndexesMap.get(tempSerialNumber)) {
                        i = i -1;
                        if (rowIndexErrorsListMap.containsKey(i)) {
                            rowIndexErrorsListMap.get(i).add(errorMessagesMap.get('DuplicatedInFile_Plc_ManufacturerSerialNumber__c') + ': ' + 
                                                             manufacturerSerialRowIndexesMap.get(tempSerialNumber));
                        } else {
                            rowIndexErrorsListMap.put(i, new List<String> {errorMessagesMap.get('DuplicatedInFile_Plc_ManufacturerSerialNumber__c') + ': ' + 
                                                      manufacturerSerialRowIndexesMap.get(tempSerialNumber)});
                        }
                    }
                    manufacturerSerialRowIndexesMap.remove(tempSerialNumber);
                }
            }

            for (String tempMatricola : encodedSerialRowIndexesMap.keySet()) {
                if (encodedSerialRowIndexesMap.get(tempMatricola).size() > 1){
                    for (Integer i : encodedSerialRowIndexesMap.get(tempMatricola)) {
                        i = i -1;
                        if (rowIndexErrorsListMap.containsKey(i)) {
                            rowIndexErrorsListMap.get(i).add(errorMessagesMap.get('DuplicatedInFile_Plc_EncodedSerialNumber__c')+ ': ' +
                                                             encodedSerialRowIndexesMap.get(tempMatricola));
                        } else {
                            rowIndexErrorsListMap.put(i, new List<String> {errorMessagesMap.get('DuplicatedInFile_Plc_EncodedSerialNumber__c') + ': ' +
                                                      encodedSerialRowIndexesMap.get(tempMatricola)});
                        }
                    }
                    encodedSerialRowIndexesMap.remove(tempMatricola);
                }
            }

            for (String tempDllSerialNumber : dllSerialRowIndexesMap.keySet()) {
                if (dllSerialRowIndexesMap.get(tempDllSerialNumber).size() > 1){
                    for (Integer i : dllSerialRowIndexesMap.get(tempDllSerialNumber)) {
                        i = i -1;
                        if (rowIndexErrorsListMap.containsKey(i)) {
                            rowIndexErrorsListMap.get(i).add(errorMessagesMap.get('DuplicatedInFile_Plc_DllSerialNumber__c')+ ': ' +
                                                             dllSerialRowIndexesMap.get(tempDllSerialNumber));
                        } else {
                            rowIndexErrorsListMap.put(i, new List<String> {errorMessagesMap.get('DuplicatedInFile_Plc_DllSerialNumber__c') + ': ' +
                                                      dllSerialRowIndexesMap.get(tempDllSerialNumber)});
                        }
                    }
                    dllSerialRowIndexesMap.remove(tempDllSerialNumber);
                }
            }
            //Removing blank rows
            for (Integer i = indexesToRemove.size() - 1; i >= 0; i--) {
                inputCsvRows.remove(indexesToRemove[i]);
            }

            //If input rows size is equal to 0 it means that input file is blank
            if (inputCsvRows.size() == 0) {
                response.put('error', true);
                response.put('errorMsg', errorMessagesMap.get('InvalidFileErrorMessage'));
                return response;
            }

            //Finally getting the only models SKU needed for the queries
            for (Integer index = 0; index < inputCsvRows.size(); index++) {
                //Checking if the current row has not generated some errors. Therefore needed it 
                if (!rowIndexErrorsListMap.containsKey(index)) {
                    List<String> cells = inputCsvRows.get(index).replace('\n','').trim().split(columnDelimiter);
                    //if the warehouse id is not empty then use this one otherwise use the one 
                    //indicated by file
                    if (warehouseId != '') {
                        //Populating the map of indexes with found Model SKU identifier
                        //The index fieldSkuIndex stands for the model SKU identificator
                        rowIndexToAliasMap.put(index, warehouseInputAlias);
                        rowIndexToModelSkuWarehouseMap.put(index, cells.get(fieldSkuIndex).trim() + warehouseInputAlias);
                    } else {
                        rowIndexToAliasMap.put(index, cells.get(fieldAliasIndex).trim());
                        rowIndexToModelSkuWarehouseMap.put(index, cells.get(fieldSkuIndex).trim() + cells.get(fieldAliasIndex).trim());
                    }
                    rowIndexModelSkuMap.put(index, cells.get(fieldSkuIndex).trim());
                    foundModelsSkuSet.add(cells.get(fieldSkuIndex).trim());
                    inputRowsWithoutErrors.add(index);
                }
            }

            /* START
             * Checking warehouse in which importing serials
             * ----------------------------------------------------------------------------------------------------------------------------------- */
             //Getting all warehouses according to found aliases
             for (Bit2Shop__Warehouse__c warehouse : [SELECT Id, Name, Plc_Alias__c,
                                                             Plc_Tipology__c
                                                      FROM Bit2Shop__Warehouse__c
                                                      WHERE Plc_Alias__c IN :warehouseAliasRowIndexesMap.keySet() OR 
                                                            Id = :warehouseId]) {

                foundWarehousesSet.add(warehouse.Id);
                warehouseAliasToWarehouseMap.put(warehouse.Plc_Alias__c, warehouse);
            }
            //Putting errors on rows if a warehouse as not found. Done only if a warehouse
            //was not selected
            for (String alias : warehouseAliasRowIndexesMap.keySet()) {
                if (!warehouseAliasToWarehouseMap.containsKey(alias)) {
                    for (Integer i : warehouseAliasRowIndexesMap.get(alias)) {
                        i = i -1;
                        if (rowIndexErrorsListMap.containsKey(i)) {
                            rowIndexErrorsListMap.get(i).add(errorMessagesMap.get('WarehouseNotFoundMessage') + ' \'' + alias + '\'');
                        } else {
                            rowIndexErrorsListMap.put(i, new List<String> {errorMessagesMap.get('WarehouseNotFoundMessage') + ' \'' + alias + '\''});
                        }
                        inputRowsWithoutErrors.remove(i);
                    }
                } else {
                    if(warehouseId != '') {
                        if (alias != warehouseInputAlias) {
                            for (Integer i : warehouseAliasRowIndexesMap.get(alias)) {
                                i = i -1;
                                if (rowIndexErrorsListMap.containsKey(i)) {
                                    rowIndexErrorsListMap.get(i).add(errorMessagesMap.get('Unmatching_Plc_Alias__c'));
                                } else {
                                    rowIndexErrorsListMap.put(i, new List<String> {errorMessagesMap.get('Unmatching_Plc_Alias__c')});
                                }
                                inputRowsWithoutErrors.remove(i);
                            }
                        }
                    }

                    if (warehouseAliasToWarehouseMap.get(alias).Plc_Tipology__c == 'Installed') {
                        for (Integer i : warehouseAliasRowIndexesMap.get(alias)) {
                            i = i -1;
                            if (rowIndexErrorsListMap.containsKey(i)) {
                                rowIndexErrorsListMap.get(i).add(errorMessagesMap.get('Forbidden_Plc_Tipology__c'));
                            } else {
                                rowIndexErrorsListMap.put(i, new List<String> {errorMessagesMap.get('Forbidden_Plc_Tipology__c')});
                            }
                            inputRowsWithoutErrors.remove(i);
                        }
                    }
                }
            }

            /* END
             * Checking warehouse in which importing serials
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Checking model SKU consistence
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Some helper maps, needed to link the gathered results of the queries with the input data
            Map<String, List<String>> modelSkuWarehouseToProductStockMap = new Map<String, List<String>>();
            Map<String, ProductStockWrp> modelSkuWarehouseToProductStockMapToInsert = new Map<String, ProductStockWrp>();
            //Getting product stocks filtering on warehouse id and input product SKU of external catalog items 
            for (B2WExtCat__External_Catalog_Item__c model : [SELECT Id, Plc_ProductSku__c, Bit2Shop__Required_Serial__c,
                                                                     Plc_Manufacturer__r.Plc_Alias__c,
                                                                     Bit2Shop__Product_Description__c,
                                                                     B2WExtCat__External_Catalog_Item_Name__c
                                                              FROM B2WExtCat__External_Catalog_Item__c
                                                              WHERE Bit2Shop__Required_Serial__c = true AND
                                                                    Plc_ProductSku__c IN :foundModelsSkuSet]) {
                String key = model.Plc_ProductSku__c;
                if (skuToModelIdsMap.containsKey(key)) {
                    skuToModelIdsMap.get(key).add(model.Id);
                } else {
                    skuToModelIdsMap.put(key, new List<String> {model.Id});
                }
                //Map that contains the name of the model
                skuToModelMap.put(key, model);
                skuToManufacturerAlias.put(key, model.Plc_Manufacturer__r.Plc_Alias__c);
            }

            //Checking if product sku exist 
            for (Integer index : inputRowsWithoutErrors) {
                List<String> models = skuToModelIdsMap.get(rowIndexModelSkuMap.get(index));
                if (models == null || models.size() == 0) {
                    rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Error_B2WExtCat__External_Catalog_Item__c')
                                                                       .replace('{0}','0')});
                    inputRowsWithoutErrors.remove(index);
                    foundModelsSkuSet.remove(rowIndexModelSkuMap.get(index));
                } else if (models.size() > 1) {
                    rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Error_B2WExtCat__External_Catalog_Item__c')
                                                                       .replace('{0}', '' + models.size()) +
                                                                                '. ID:' + models});
                    inputRowsWithoutErrors.remove(index);
                    foundModelsSkuSet.remove(rowIndexModelSkuMap.get(index));
                }
            }

            for (Bit2Shop__Product_Stock__c productStock : [SELECT Id, Plc_ProductSku__c, 
                                                                   Bit2Shop__Warehouse_Id__r.Plc_Alias__c
                                                            FROM Bit2Shop__Product_Stock__c
                                                            WHERE Bit2Shop__Warehouse_Id__c IN :foundWarehousesSet AND 
                                                                  Plc_ProductSku__c IN :foundModelsSkuSet]) {

                String key = productStock.Plc_ProductSku__c + productStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c;
                if (modelSkuWarehouseToProductStockMap.containsKey(key)) {
                    modelSkuWarehouseToProductStockMap.get(key).add(productStock.Id);
                } else {
                    modelSkuWarehouseToProductStockMap.put(key, new List<String> {productStock.Id});
                }
            }
            //Temporary Product Stock Wrapper
            ProductStockWrp productStockWrp;
            //Checking if every model (SKU) is referred to exactly one product stock
            for (Integer index : inputRowsWithoutErrors) {
                //Getting retrieved product SKU
                List<String> productStockIds = modelSkuWarehouseToProductStockMap.get(rowIndexToModelSkuWarehouseMap.get(index));
                
                //If found product stock are null or empty then it must be created
                if (productStockIds == null || productStockIds.size() == 0) {
                    productStockWrp = new ProductStockWrp();
                    //Getting model that must be available according to previous checks
                    productStockWrp.modelId = skuToModelIdsMap.get(rowIndexModelSkuMap.get(index))[0];
                    productStockWrp.modelName = skuToModelMap.get(rowIndexModelSkuMap.get(index)).B2WExtCat__External_Catalog_Item_Name__c;
                    productStockWrp.sku = rowIndexModelSkuMap.get(index);
                    //If a warehouse was selected then use that one, otherwise calculate the warehouse of the single rew
                    //(Also in this case the warehouse for the given alias must be in SF according to previous checks)
                    if (warehouseId == '') {
                        productStockWrp.warehouseId = warehouseAliasToWarehouseMap.get(rowIndexToAliasMap.get(index)).Id;
                        productStockWrp.warehouseAlias = rowIndexToAliasMap.get(index);
                        modelSkuWarehouseToProductStockMapToInsert.put(rowIndexModelSkuMap.get(index) + rowIndexToAliasMap.get(index), productStockWrp);
                    } else {
                        productStockWrp.warehouseId = warehouseId;
                        productStockWrp.warehouseAlias = warehouseInputAlias;
                        modelSkuWarehouseToProductStockMapToInsert.put(rowIndexModelSkuMap.get(index) + warehouseInputAlias, productStockWrp);
                    }
                    //Adding an alert for user
                    rowIndexWarningsListMap.put(index, new List<String> {errorMessagesMap.get('Missing_Bit2Shop__Product_Stock__c')});
                } else if (productStockIds.size() > 1) {
                    rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Error_Plc_ProductSku__c').replace('{0}',
                                                                       '' + productStockIds.size()) +
                                                                       '. ID:' + productStockIds});
                    inputRowsWithoutErrors.remove(index);
                }
            }

            /* END
             * Checking model SKU consistence
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Checking duplicated serial stock records
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            Map<String, Bit2Shop__Stock_Serials2__c> stockSerialsMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
            //If it is edit mode then retrieve stock serials according to given id
            if (isEditMode) {

                Set<String> foundStockSerialIdSet = new Set<String>(); 

                for (Bit2Shop__Stock_Serials2__c stockSerial : [SELECT Id, Name, Bit2Shop__Warehouse_Id__r.Plc_Alias__c
                                                                FROM Bit2Shop__Stock_Serials2__c
                                                                WHERE Id IN :serialIdToRowIndexMap.keySet()]) {

                    Integer index = serialIdToRowIndexMap.get(stockSerial.Id);

                    if (inputRowsWithoutErrors.contains(index) && stockSerial.Bit2Shop__Warehouse_Id__r.Plc_Alias__c != rowIndexToAliasMap.get(index)) {
                        if (rowIndexErrorsListMap.containsKey(index)){
                            rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('Unmatching_Serial_Warehouse'));
                        } else {
                            rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Unmatching_Serial_Warehouse')});
                        }
                    }

                    rowIndexToExistingIdMap.put('' + index, stockSerial.Id);
                    stockSerialsMap.put(stockSerial.Id, stockSerial);
                }

                //Iterating trough file rows in order to show to user missing stock serials
                for (String serialId : serialIdToRowIndexMap.keySet()) {

                    Integer index = serialIdToRowIndexMap.get(serialId);
                    if (!stockSerialsMap.keySet().contains(serialId) && inputRowsWithoutErrors.contains(index)) {
                        inputRowsWithoutErrors.remove(index);
                        if (rowIndexErrorsListMap.containsKey(index)){
                            rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('Not_Found_Stock_Serial').replace('{1}', ' ID [' + serialId + ']'));
                        } else {
                            rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Not_Found_Stock_Serial').replace('{1}', ' ID [' + serialId + ']')});
                        }
                    }
                }
            } else {
                //Otherwise checks if the stock serial exists with given serials
                
                //Bulding set of unique encoded serials to search
                for (String encodedSerial : encodedSerialRowIndexesMap.keySet()) {
                    for (Integer index : encodedSerialRowIndexesMap.get(encodedSerial)) {
                        index = index -1;
                        if (inputRowsWithoutErrors.contains(index) && rowIndexModelSkuMap.containsKey(index)){
                            encodedSerialsUniqueSet.add('' + skuToModelMap.get(rowIndexModelSkuMap.get(index))
                                                        .Plc_Manufacturer__r.Plc_Alias__c + '_' + encodedSerial);
                        }
                    }
                }

                Boolean showDuplicatedError;

                for (Bit2Shop__Stock_Serials2__c stockSerial : [SELECT Id, Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__r.Plc_Tipology__c, 
                                                                       Plc_EncodedSerialNumber__c, Plc_ProductSku__c
                                                                FROM Bit2Shop__Stock_Serials2__c
                                                                WHERE Plc_EncodedSerialNumberUnique__c != '' AND 
                                                                      Plc_EncodedSerialNumberUnique__c IN :encodedSerialsUniqueSet]) {
                    showDuplicatedError = true;
                    if (encodedSerialRowIndexesMap.containsKey(stockSerial.Plc_EncodedSerialNumber__c.toUpperCase())) {
                        for (Integer index : encodedSerialRowIndexesMap.get(stockSerial.Plc_EncodedSerialNumber__c.toUpperCase())) {
                            index = index -1;
                            foundSerialRowsSet.add(index);

                            if (stockSerial.Bit2Shop__Status__c == 'Decommissioned') {
                                showDuplicatedError = false;
                                //If a stock serial was found then it is a decomissioned serial that must be updated
                                rowIndexToExistingIdMap.put('' + index, stockSerial.Id);
                                if (rowIndexWarningsListMap.containsKey(index)){
                                    rowIndexWarningsListMap.get(index).add(errorMessagesMap.get('UpdateWarningMessage') + '. ID: ' + 
                                                                           stockSerial.Id);
                                } else {
                                    rowIndexWarningsListMap.put(index, new List<String> {errorMessagesMap.get('UpdateWarningMessage') + '. ID: ' + 
                                                                                         stockSerial.Id});
                                }
                            } 

                            if (stockSerial.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c == 'Undefined') {

                                if (stockSerial.Bit2Shop__Warehouse_Id__c != warehouseAliasToWarehouseMap.get(rowIndexToAliasMap.get(index)).Id) {
                                    showDuplicatedError = false;
                                    rowIndexToExistingIdMap.put('' + index, stockSerial.Id);
                                    if (rowIndexWarningsListMap.containsKey(index)){
                                        rowIndexWarningsListMap.get(index).add(errorMessagesMap.get('Update_From_Undefined') + '. ID: ' + 
                                                                               stockSerial.Id);
                                    } else {
                                        rowIndexWarningsListMap.put(index, new List<String> {errorMessagesMap.get('Update_From_Undefined') + '. ID: ' + 
                                                                                             stockSerial.Id});
                                    }
                                }
                            } 

                            if (showDuplicatedError) {
                                //If a stock serial was found then it is duplicated
                                if (rowIndexErrorsListMap.containsKey(index)) {
                                    rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('DuplicatedRecord_Plc_EncodedSerialNumber__c') 
                                                                         + '. ID: ' + stockSerial.Id);
                                } else {
                                    rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('DuplicatedRecord_Plc_EncodedSerialNumber__c') 
                                                                                       + '. ID: ' + stockSerial.Id});
                                }
                            } else {
                                if (stockSerial.Plc_ProductSku__c != rowIndexModelSkuMap.get(index)) {
                                    if (rowIndexErrorsListMap.containsKey(index)) {
                                        rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('Unmatching_Sku_Error').replace('{0}', stockSerial.Plc_ProductSku__c)
                                                                             + '. ID: ' + stockSerial.Id);
                                    } else {
                                        rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Unmatching_Sku_Error').replace('{0}', stockSerial.Plc_ProductSku__c)
                                                                                           + '. ID: ' + stockSerial.Id});
                                    }
                                }
                            }
                        }
                        encodedSerialRowIndexesMap.remove(stockSerial.Plc_EncodedSerialNumber__c.toUpperCase());
                    }
                }

                //Bulding set of unique manufacturer serials to search
                for (String manufacturerSerial : manufacturerSerialRowIndexesMap.keySet()) {
                    for (Integer index : manufacturerSerialRowIndexesMap.get(manufacturerSerial)) {
                        index = index -1;
                        if (inputRowsWithoutErrors.contains(index) 
                            && rowIndexModelSkuMap.containsKey(index) 
                            && !foundSerialRowsSet.contains(index)){
                            manufacturerSerialsUniqueSet.add('' + skuToModelMap.get(rowIndexModelSkuMap.get(index))
                                                             .Plc_Manufacturer__r.Plc_Alias__c + '_' + manufacturerSerial);
                        }
                    }
                }

                for (Bit2Shop__Stock_Serials2__c stockSerial : [SELECT Id, Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__r.Plc_Tipology__c, 
                                                                       Plc_ManufacturerSerialNumber__c, Plc_ProductSku__c
                                                                FROM Bit2Shop__Stock_Serials2__c
                                                                WHERE Plc_ManufacturerSerialNumberUnique__c != '' AND 
                                                                      Plc_ManufacturerSerialNumberUnique__c IN :manufacturerSerialsUniqueSet]) {

                    showDuplicatedError = true;

                    if (manufacturerSerialRowIndexesMap.containsKey(stockSerial.Plc_ManufacturerSerialNumber__c.toUpperCase())) {
                        for (Integer index : manufacturerSerialRowIndexesMap.get(stockSerial.Plc_ManufacturerSerialNumber__c.toUpperCase())) {
                            index = index -1;
                            foundSerialRowsSet.add(index);
                            if (stockSerial.Bit2Shop__Status__c == 'Decommissioned') {
                                showDuplicatedError = false;
                                //If a stock serial was found then it is a decomissioned serial that must be updated
                                rowIndexToExistingIdMap.put('' + index, stockSerial.Id);
                                if (rowIndexWarningsListMap.containsKey(index)){
                                    rowIndexWarningsListMap.get(index).add(errorMessagesMap.get('UpdateWarningMessage') + '. ID: ' + 
                                                                           stockSerial.Id);
                                } else {
                                    rowIndexWarningsListMap.put(index, new List<String> {errorMessagesMap.get('UpdateWarningMessage') + '. ID: ' + 
                                                                                         stockSerial.Id});
                                }
                            } 

                            if (stockSerial.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c == 'Undefined') {

                                if (stockSerial.Bit2Shop__Warehouse_Id__c != warehouseAliasToWarehouseMap.get(rowIndexToAliasMap.get(index)).Id) {
                                    showDuplicatedError = false;
                                    rowIndexToExistingIdMap.put('' + index, stockSerial.Id);
                                    if (rowIndexWarningsListMap.containsKey(index)){
                                        rowIndexWarningsListMap.get(index).add(errorMessagesMap.get('Update_From_Undefined') + '. ID: ' + 
                                                                               stockSerial.Id);
                                    } else {
                                        rowIndexWarningsListMap.put(index, new List<String> {errorMessagesMap.get('Update_From_Undefined') + '. ID: ' + 
                                                                                             stockSerial.Id});
                                    }
                                }
                            }

                            if (showDuplicatedError) {
                                //If a stock serial was found then it is duplicated
                                if (rowIndexErrorsListMap.containsKey(index)) {
                                    rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('DuplicatedRecord_Plc_ManufacturerSerialNumber__c') 
                                                                         + '. ID: ' + stockSerial.Id);
                                } else {
                                    rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('DuplicatedRecord_Plc_ManufacturerSerialNumber__c') 
                                                                                       + '. ID: ' + stockSerial.Id});
                                }
                            } else {
                                if (stockSerial.Plc_ProductSku__c != rowIndexModelSkuMap.get(index)) {
                                    if (rowIndexErrorsListMap.containsKey(index)) {
                                        rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('Unmatching_Sku_Error').replace('{0}', stockSerial.Plc_ProductSku__c)
                                                                             + '. ID: ' + stockSerial.Id);
                                    } else {
                                        rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Unmatching_Sku_Error').replace('{0}', stockSerial.Plc_ProductSku__c)
                                                                                           + '. ID: ' + stockSerial.Id});
                                    }
                                }
                            }
                        }
                        manufacturerSerialRowIndexesMap.remove(stockSerial.Plc_ManufacturerSerialNumber__c.toUpperCase());
                    }
                }

                //Bulding set of unique dll serials to search
                for (String dllSerial : dllSerialRowIndexesMap.keySet()) {
                    for (Integer index : dllSerialRowIndexesMap.get(dllSerial)) {
                        index = index -1;
                        if (inputRowsWithoutErrors.contains(index) 
                            && rowIndexModelSkuMap.containsKey(index) 
                            && !foundSerialRowsSet.contains(index)){
                            dllSerialsUniqueSet.add('' + skuToModelMap.get(rowIndexModelSkuMap.get(index))
                                                    .Plc_Manufacturer__r.Plc_Alias__c + '_' + dllSerial);
                        }
                    }
                }
                
                for (Bit2Shop__Stock_Serials2__c stockSerial : [SELECT Id, Bit2Shop__Status__c, Bit2Shop__Warehouse_Id__r.Plc_Tipology__c, 
                                                                       Plc_DllSerialNumber__c, Plc_ProductSku__c
                                                                FROM Bit2Shop__Stock_Serials2__c
                                                                WHERE Plc_DllSerialNumberUnique__c != '' AND 
                                                                      Plc_DllSerialNumberUnique__c IN :dllSerialsUniqueSet]) {

                    showDuplicatedError = true;

                    if (dllSerialRowIndexesMap.containsKey(stockSerial.Plc_DllSerialNumber__c.toUpperCase())) {
                        for (Integer index : dllSerialRowIndexesMap.get(stockSerial.Plc_DllSerialNumber__c.toUpperCase())) {
                            index = index -1;
                            foundSerialRowsSet.add(index);
                            if (stockSerial.Bit2Shop__Status__c == 'Decommissioned') {
                                showDuplicatedError = false;
                                //If a stock serial was found then it is a decomissioned serial that must be updated
                                rowIndexToExistingIdMap.put('' + index, stockSerial.Id);
                                if (rowIndexWarningsListMap.containsKey(index)){
                                    rowIndexWarningsListMap.get(index).add(errorMessagesMap.get('UpdateWarningMessage') + '. ID: ' + 
                                                                           stockSerial.Id);
                                } else {
                                    rowIndexWarningsListMap.put(index, new List<String> {errorMessagesMap.get('UpdateWarningMessage') + '. ID: ' + 
                                                                                         stockSerial.Id});
                                }
                            }

                            if (stockSerial.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c == 'Undefined') {

                                if (stockSerial.Bit2Shop__Warehouse_Id__c != warehouseAliasToWarehouseMap.get(rowIndexToAliasMap.get(index)).Id) {
                                    showDuplicatedError = false;
                                    rowIndexToExistingIdMap.put('' + index, stockSerial.Id);
                                    if (rowIndexWarningsListMap.containsKey(index)){
                                        rowIndexWarningsListMap.get(index).add(errorMessagesMap.get('Update_From_Undefined') + '. ID: ' + 
                                                                               stockSerial.Id);
                                    } else {
                                        rowIndexWarningsListMap.put(index, new List<String> {errorMessagesMap.get('Update_From_Undefined') + '. ID: ' + 
                                                                                             stockSerial.Id});
                                    }
                                }
                            }

                            if (showDuplicatedError) {
                                //If a stock serial was found then it is duplicated
                                if (rowIndexErrorsListMap.containsKey(index)) {
                                    rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('DuplicatedRecord_Plc_DllSerialNumber__c') 
                                                                         + '. ID: ' + stockSerial.Id);
                                } else {
                                    rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('DuplicatedRecord_Plc_DllSerialNumber__c') 
                                                                                       + '. ID: ' + stockSerial.Id});
                                }
                            } else {
                                if (stockSerial.Plc_ProductSku__c != rowIndexModelSkuMap.get(index)) {
                                    if (rowIndexErrorsListMap.containsKey(index)) {
                                        rowIndexErrorsListMap.get(index).add(errorMessagesMap.get('Unmatching_Sku_Error').replace('{0}', stockSerial.Plc_ProductSku__c)
                                                                             + '. ID: ' + stockSerial.Id);
                                    } else {
                                        rowIndexErrorsListMap.put(index, new List<String> {errorMessagesMap.get('Unmatching_Sku_Error').replace('{0}', stockSerial.Plc_ProductSku__c)
                                                                                           + '. ID: ' + stockSerial.Id});
                                    }
                                }
                            }
                        }
                        dllSerialRowIndexesMap.remove(stockSerial.Plc_DllSerialNumber__c.toUpperCase());
                    }
                }
            }

            /* END
             * Checking duplicated serial stock records
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            if (rowIndexToExistingIdMap.keySet().size() > INPUT_ROW_UPDATE_MAX) {
                response.put('error', true);
                response.put('errorMsg', Label.Plc_LightningComponentStockSerialsImportUploadUpdateLimitExceededMessage.replace('{0}', '' + INPUT_ROW_UPDATE_MAX)
                                         + ': ' + rowIndexToExistingIdMap.keySet().size());
                return response;
            }

            if (inputCsvRowsToReturn.size() > INPUT_ROW_INSERT_MAX) {
                response.put('error', true);
                response.put('errorMsg', Label.Plc_LightningComponentStockSerialsImportUploadInsertLimitExceededMessage.replace('{0}', '' + INPUT_ROW_INSERT_MAX)
                                         + ': ' + inputCsvRowsToReturn.size());
                return response;
            }

            //It is not needed to return map of product stocks/Models if some error happened
            if (rowIndexErrorsListMap.keySet().size() == 0) {
                response.put('modelSkuWarehouseToProductStockMap', modelSkuWarehouseToProductStockMap);
                response.put('skuToManufacturerAlias', skuToManufacturerAlias);
                response.put('productStockToInsert', JSON.serialize(modelSkuWarehouseToProductStockMapToInsert.values()));
            }

            
            //Returning data back to client
            response.put('insertFieldMapping', insertFieldMapping);
            response.put('updateFieldMapping', updateFieldMapping);
            response.put('rowIndexErrorsListMap', rowIndexErrorsListMap);
            response.put('rowIndexWarningsListMap', rowIndexWarningsListMap);
            response.put('rowsWithErrorsSize', rowIndexErrorsListMap.keySet().size());
            response.put('rowsWithWarningsSize', rowIndexWarningsListMap.keySet().size());
            response.put('rowIndexToExistingIdMap', rowIndexToExistingIdMap);
            response.put('stockSerialsMap', stockSerialsMap);
            response.put('warehouseAliasToWarehouseMap', warehouseAliasToWarehouseMap);
            response.put('inputFileList', inputCsvRowsToReturn);
        } catch(Exception e) {
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-00D0401] ' + e.getMessage());
        }
        return response;
    }

   /**
     * Saves the list of stock serials from given csv input file 
     *
     * @code 05
     *
     * @param  csvAsList                                 Uploaded csv file represented by a list
     * @param  modelSkuWarehouseToProductStockUntypedMap Map that link product stock with model SKU identificator
     * @param  productStockWrpToInsertString             Contains Product Stock to insert
     * @param  skuToManufacturerAlias                    Matches a found sku to corresponding manufacturer alias
     * @param  warehouseId                               Starting warehouse record Id
     * @param  rowIndexToExistingIdMap                   Maps index row with an existing serial stock id
     * @param  warehouseAliasToWarehouseMap              Maps warehoused alias to id
     * @param  columnDelimiter                           Sets the column delimiter
     * @param  isEditMode                                Identifies whether it is edit mode
     * @return                                           List of stock serials with status messagges
     */
    @AuraEnabled
    public static Map<String, Object> saveCsvData(List<String> csvAsList, Map<String, List<Object>> modelSkuWarehouseToProductStockUntypedMap, 
                                                  String productStockWrpToInsertString, Map<String, String> skuToManufacturerAlias,
                                                  String warehouseId, Map<String, String> rowIndexToExistingIdMap, 
                                                  Map<String, Bit2Shop__Warehouse__c> warehouseAliasToWarehouseMap,
                                                  String columnDelimiter, Boolean isEditMode) {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        Savepoint sp = Database.setSavepoint();
        columnDelimiter = String.isBlank(columnDelimiter) ? ',' : columnDelimiter;
        //Retrieving available picklist values for the status field
        Map<String, Schema.PicklistEntry> statusAvailableValuesMap = retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c',
                                                                                                  'Bit2Shop__Status__c');
        Map<String, Schema.PicklistEntry> status2AvailableValuesMap = retrieveActivePickListValues('Bit2Shop__Stock_Serials2__c',
                                                                                                  'Plc_Status2__c');
        Map<String, list<Bit2Shop__Stock_Serials2__c>> destinationWhtoStockSerialsListMap = new Map<String, List<Bit2Shop__Stock_Serials2__c>>();
        Set<String> originWarehousesSet = new Set<String>();

        try {

            /* START
             * Initialization of needed data
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            Map<String, Bit2Shop__Product_Stock__c> productStockToInsertMap = new Map<String, Bit2Shop__Product_Stock__c>();
            Map<Integer, List<String>> rowIndexErrorsListMap = new Map<Integer, List<String>>();
            Map<Integer, List<String>> rowIndexWarningsListMap = new Map<Integer, List<String>>();
            Map<String, String> modelSkuWarehouseToProductStockMap = new Map<String, String>();
            Map<String, Integer> serialIdToRowIndex = new Map<String, Integer>();
            List<String> stockSerialsIds = new List<String>();
            String warehouseInputAlias = '';

            Integer fieldIndex; //It is calculated during runtime
            Integer fieldSkuIndex;
            Integer fieldAliasIndex;  

            if (isEditMode) {
                fieldSkuIndex = updateFieldMapping.get('Plc_ProductSku__c');
                fieldAliasIndex = updateFieldMapping.get('Plc_Alias__c');
            } else {
                fieldSkuIndex = insertFieldMapping.get('Plc_ProductSku__c');   
                fieldAliasIndex = insertFieldMapping.get('Plc_Alias__c');
            }

            //Getting selected warehouse
            List<Bit2Shop__Warehouse__c> warehouseInputList = [SELECT Id, Name, Plc_Alias__c
                                                               FROM Bit2Shop__Warehouse__c
                                                               WHERE Id = :warehouseId];
            //If a warehouse was found then it means that user started from a selected 
            //specific warehouse
            if (warehouseInputList.size() > 0) {
                warehouseInputAlias = warehouseInputList.get(0).Plc_Alias__c;
            }

            //Getting existing stock Serials
            Map<String, Bit2Shop__Stock_Serials2__c> oldStockSerialsMap = new Map<String, Bit2Shop__Stock_Serials2__c>([SELECT Id, Name, Bit2Shop__Status__c,
                                                                                                                               Bit2Shop__Product_Stock_Id__c,
                                                                                                                               Bit2Shop__Warehouse_Id__c,
                                                                                                                               Bit2Shop__Warehouse_Id__r.Plc_Tipology__c,
                                                                                                                               Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c
                                                                                                                        FROM Bit2Shop__Stock_Serials2__c
                                                                                                                        WHERE Id IN :rowIndexToExistingIdMap.values()]);
            
            /* END
             * Initialization of needed data
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Creating missing Product Stock
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Deserializing product stock to insert
            List<ProductStockWrp> productStockWrpToInsertList = (List<ProductStockWrp>)
                                                                 JSON.deserialize(productStockWrpToInsertString, 
                                                                                  List<ProductStockWrp>.class);

            Bit2Shop__Product_Stock__c newProductStock;
            //Preparing new product stock to insert
            for (ProductStockWrp productStockWrp : productStockWrpToInsertList) {
                newProductStock = new Bit2Shop__Product_Stock__c();
                newProductStock.Name = ProductStockWrp.modelName;
                newProductStock.Bit2Shop__External_Catalog_Item_Id__c = productStockWrp.modelId;
                newProductStock.Bit2Shop__Warehouse_Id__c = productStockWrp.warehouseId;
                newProductStock.Bit2Shop__Stock_Qty__c = 0;
                productStockToInsertMap.put('' + productStockWrp.sku + productStockWrp.warehouseAlias, newProductStock);
            }
            
            for (String key : modelSkuWarehouseToProductStockUntypedMap.keySet()) {
                //The index is fixed to 0 because the length MUST BE 1 according to first check evaluation
                modelSkuWarehouseToProductStockMap.put(key, (String)(modelSkuWarehouseToProductStockUntypedMap.get(key)).get(0));
            }

            //Inserting new product stocks
            insert productStockToInsertMap.values();
            //Adding inserted product stock to map of available Skus
            for(String key : productStockToInsertMap.keySet()) {
                modelSkuWarehouseToProductStockMap.put(key, productStockToInsertMap.get(key).Id);
            }

            /* END
             * Creating missing Product Stock
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Iterating through csv file in order to save stock serials
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Stock Serials to upsert
            List<Bit2Shop__Stock_Serials2__c> stockSerialsToUpsert = new List<Bit2Shop__Stock_Serials2__c>();
            Bit2Shop__Stock_Serials2__c newStockSerial;
            //Identifies existing serials and current serial warehouse id
            Bit2Shop__Stock_Serials2__c oldStockSerial;
            String currentWarehouseId;
            String targetWarehouseId;

            for (Integer index = 0; index < csvAsList.size(); index++) {
                List<String> cells = csvAsList.get(index).replace('\n','').trim().split(columnDelimiter);
                
                //String manufacturerAlias = skuToManufacturerAlias.get(cells[fieldAliasIndex].trim()) == null ? '' :
                //                           skuToManufacturerAlias.get(cells[fieldAliasIndex].trim());

                newStockSerial = new Bit2Shop__Stock_Serials2__c();

                if (rowIndexToExistingIdMap.containsKey('' + index)) {
                    newStockSerial.Id = rowIndexToExistingIdMap.get('' + index);

                    if (warehouseId == '' || warehouseId == null) {
                        targetWarehouseId = warehouseAliasToWarehouseMap.get(cells[fieldAliasIndex].trim()).Id;
                    } else {
                        targetWarehouseId = warehouseId;
                    }

                    //If the serial exist already and the origin warehouse's tipology is undefined then populate the map
                    //that matches the destination warehouse to the stock serial
                    oldStockSerial = oldStockSerialsMap.get(rowIndexToExistingIdMap.get('' + index));
                    currentWarehouseId = oldStockSerialsMap.get(rowIndexToExistingIdMap.get('' + index)).Bit2Shop__Warehouse_Id__c;
                    //Check whether the serial is moving to another warehouse
                    if (currentWarehouseId != targetWarehouseId) {
                        originWarehousesSet.add(currentWarehouseId);
                        if (oldStockSerial.Bit2Shop__Warehouse_Id__r.Plc_Tipology__c == 'Undefined') {
                            if (destinationWhtoStockSerialsListMap.containsKey(targetWarehouseId)) {
                                destinationWhtoStockSerialsListMap.get(targetWarehouseId).add(oldStockSerial);
                            } else {
                                destinationWhtoStockSerialsListMap.put(targetWarehouseId, new List<Bit2Shop__Stock_Serials2__c>{oldStockSerial});
                            }
                        }
                    }
                } 

                if (isEditMode) {
                    fieldIndex = updateFieldMapping.get('Plc_ManufacturerSerialNumber__c');
                } else {
                    fieldIndex = insertFieldMapping.get('Plc_ManufacturerSerialNumber__c');
                }

                if (cells.size() > fieldIndex && String.isNotBlank(cells[fieldIndex].trim())) {
                    newStockSerial.Plc_ManufacturerSerialNumber__c = cells[fieldIndex].trim();
                }

                if (isEditMode) {
                    fieldIndex = updateFieldMapping.get('Plc_EncodedSerialNumber__c');
                } else {
                    fieldIndex = insertFieldMapping.get('Plc_EncodedSerialNumber__c');
                }

                if (cells.size() > fieldIndex && String.isNotBlank(cells[fieldIndex].trim())) {
                    newStockSerial.Plc_EncodedSerialNumber__c = cells[fieldIndex].trim();
                }

                if (isEditMode) {
                    fieldIndex = updateFieldMapping.get('Plc_DllSerialNumber__c');
                } else {
                    fieldIndex = insertFieldMapping.get('Plc_DllSerialNumber__c');
                }

                if (cells.size() > fieldIndex  && String.isNotBlank(cells[fieldIndex].trim())) {
                    newStockSerial.Plc_DllSerialNumber__c = cells[fieldIndex].trim();
                }

                if (warehouseId == '' || warehouseId == null) {
                    newStockSerial.Bit2Shop__Product_Stock_Id__c = modelSkuWarehouseToProductStockMap.get(cells[fieldSkuIndex].trim() + cells[fieldAliasIndex].trim());
                    newStockSerial.Bit2Shop__Warehouse_Id__c = warehouseAliasToWarehouseMap.get(cells[fieldAliasIndex].trim()).Id;
                } else {
                    newStockSerial.Bit2Shop__Product_Stock_Id__c = modelSkuWarehouseToProductStockMap.get(cells[fieldSkuIndex].trim() + warehouseInputAlias);
                    newStockSerial.Bit2Shop__Warehouse_Id__c = warehouseId;
                }

                if (isEditMode) {
                    fieldIndex = updateFieldMapping.get('Bit2Shop__Status__c');
                } else {
                    fieldIndex = insertFieldMapping.get('Bit2Shop__Status__c');
                }

                //Status of serials
                if (cells.size() > fieldIndex && String.isNotBlank(cells[fieldIndex].trim())) {
                    newStockSerial.Bit2Shop__Status__c = statusAvailableValuesMap.get(cells[fieldIndex].trim().toLowerCase()).getValue();

                    if (statusAvailableValuesMap.get(cells[fieldIndex].trim().toLowerCase()) != null &&
                        (statusAvailableValuesMap.get(cells[fieldIndex].trim().toLowerCase()).getValue() == 'WITHDRAWN')) {
                        newStockSerial.Plc_Status2__c = 'Sent';
                    }

                } else {
                    if (!isEditMode) {
                        newStockSerial.Bit2Shop__Status__c   = 'New';
                    }
                }

                /*
                 * Checking if other not mandatory cells are compiled and then assigning values to stock serial instance
                 */
                if (isEditMode) {
                    fieldIndex = updateFieldMapping.get('Bit2Shop__Purchase_Price__c');
                } else {
                    fieldIndex = insertFieldMapping.get('Bit2Shop__Purchase_Price__c');
                }
                if (cells.size() > fieldIndex) {
                    if (String.isNotBlank(cells[fieldIndex].trim())) {
                        newStockSerial.Bit2Shop__Purchase_Price__c = Double.valueOf(cells[fieldIndex].trim());
                    }
                    if (isEditMode) {
                        fieldIndex = updateFieldMapping.get('Plc_PTSCode__c');
                    } else {
                        fieldIndex = insertFieldMapping.get('Plc_PTSCode__c');
                    }
                    if (cells.size() > fieldIndex) {
                        if (String.isNotBlank(cells[fieldIndex].trim())) {
                            newStockSerial.Plc_PTSCode__c = cells[fieldIndex].trim();
                        }
                        if (isEditMode) {
                            fieldIndex = updateFieldMapping.get('Plc_PcipedModel__c');
                        } else {
                            fieldIndex = insertFieldMapping.get('Plc_PcipedModel__c');
                        }
                        if (cells.size() > fieldIndex) {
                            if (String.isNotBlank(cells[fieldIndex].trim())) {
                                newStockSerial.Plc_PcipedModel__c = cells[fieldIndex].trim();
                            }
                            if (isEditMode) {
                                fieldIndex = updateFieldMapping.get('Plc_PcipedLetterOfApproval__c');
                            } else {
                                fieldIndex = insertFieldMapping.get('Plc_PcipedLetterOfApproval__c');
                            }
                            if (cells.size() > fieldIndex) {
                                if (String.isNotBlank(cells[fieldIndex].trim())) {
                                    newStockSerial.Plc_PcipedLetterOfApproval__c = cells[fieldIndex].trim();
                                }
                                if (isEditMode) {
                                    fieldIndex = updateFieldMapping.get('Plc_PcipedApprovalNumber__c');
                                } else {
                                    fieldIndex = insertFieldMapping.get('Plc_PcipedApprovalNumber__c');
                                }
                                if (cells.size() > fieldIndex) {
                                    if (String.isNotBlank(cells[fieldIndex].trim())) {
                                        newStockSerial.Plc_PcipedApprovalNumber__c = cells[fieldIndex].trim();
                                    }
                                    if (isEditMode) {
                                        fieldIndex = updateFieldMapping.get('Plc_PcipedVersion__c');
                                    } else {
                                        fieldIndex = insertFieldMapping.get('Plc_PcipedVersion__c');
                                    }
                                    if (cells.size() > fieldIndex) {
                                        if (String.isNotBlank(cells[fieldIndex].trim())) {
                                            newStockSerial.Plc_PcipedVersion__c = cells[fieldIndex].trim();
                                        }
                                        if (isEditMode) {
                                            fieldIndex = updateFieldMapping.get('Plc_PcipedExpiryDate__c');
                                        } else {
                                            fieldIndex = insertFieldMapping.get('Plc_PcipedExpiryDate__c');
                                        }
                                        if (cells.size() > fieldIndex) {
                                            if (String.isNotBlank(cells[fieldIndex].trim())) {
                                                newStockSerial.Plc_PcipedExpiryDate__c = Date.parse(cells[fieldIndex].trim());
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if (isEditMode) {
                    fieldIndex = updateFieldMapping.get('Plc_Status2__c');
                    if (cells.size() > fieldIndex  && String.isNotBlank(cells[fieldIndex].trim())) {
                        newStockSerial.Plc_Status2__c = status2AvailableValuesMap.get(cells[fieldIndex].trim().toLowerCase()).getValue();
                    }

                } else {
                    fieldIndex = insertFieldMapping.get('Plc_Note__c');
                    if (cells.size() > fieldIndex) {
                        newStockSerial.Plc_Note__c = cells[fieldIndex].trim();
                    }
                }

                //if no error was generated, then insert the stock serial
                if (!rowIndexErrorsListMap.containsKey(index)) {
                    stockSerialsToUpsert.add(newStockSerial);
                }
            }

            System.debug('### Size of serial stock to upsert: ' + stockSerialsToUpsert.size());
            //Inserting serial stocks
            Plc_StockSerial2HistoryManager.DisableManageInsertOperation = true;
            List<Database.UpsertResult> upsertResults = Database.upsert(stockSerialsToUpsert, false);

            for (Integer index = 0; index < stockSerialsToUpsert.size(); index++) {
                Database.UpsertResult saveResult = upsertResults[index];
                //Failed/Successed inserts are shown to user
                if (!saveResult.isSuccess()) {
                    stockSerialsIds.add('');
                    oldStockSerialsMap.remove(saveResult.getId());
                    rowIndexErrorsListMap.put(index, new List<String>{saveResult.getErrors()[0].getMessage()});
                } else {
                    serialIdToRowIndex.put(saveResult.getId(), index);
                    stockSerialsIds.add(saveResult.getId());
                }
            }
            
            //removing 
            for (String oldStockSerialId : oldStockSerialsMap.keySet()) {
                if (!stockSerialsIds.contains(oldStockSerialId)) {
                    oldStockSerialsMap.remove(oldStockSerialId);
                }
            }

            /* END
             * Iterating through csv file in order to save stock serials
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            /* START
             * Updating Product Stock related to upserted serial stock
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Getting inserted serial stock in order to get records names and Product Stock, in order to update it
            Map<String, Bit2Shop__Stock_Serials2__c> newStockSerialsMap = new Map<String, Bit2Shop__Stock_Serials2__c>([SELECT Id, Name, Bit2Shop__Status__c,
                                                                                                                               Bit2Shop__Product_Stock_Id__c,
                                                                                                                               Bit2Shop__Warehouse_Id__c
                                                                                                                        FROM Bit2Shop__Stock_Serials2__c
                                                                                                                        WHERE Id IN :stockSerialsIds]);

            if (newStockSerialsMap != null && newStockSerialsMap.keySet().size() > 0) {
                Map<String, List<String>> stockSerialIdToErrorsMap = Plc_Utils.productStockQties.updateProductStockQuantities(oldStockSerialsMap, newStockSerialsMap);

                for (String serialStockId : stockSerialIdToErrorsMap.keySet()) {
                    if (serialIdToRowIndex.containsKey(serialStockId)) {
                        rowIndexWarningsListMap.put(serialIdToRowIndex.get(serialStockId), stockSerialIdToErrorsMap.get(serialStockId));
                    }
                }
            }
            
            List<Integer> indexesToRemove = new List<Integer>();

            //removing stock serials that failed
            for (String destinationWarehouse : destinationWhtoStockSerialsListMap.keySet()) {

                for (Integer i = 0; i < destinationWhtoStockSerialsListMap.get(destinationWarehouse).size(); i++) {
                    if (!oldStockSerialsMap.containsKey(destinationWhtoStockSerialsListMap.get(destinationWarehouse)[i].Id)) {
                        indexesToRemove.add(i);
                    }
                }

                //Removing failed items
                for (Integer i = indexesToRemove.size() - 1; i >= 0; i--) {
                    destinationWhtoStockSerialsListMap.get(destinationWarehouse).remove(indexesToRemove[i]);
                }

                if (destinationWhtoStockSerialsListMap.get(destinationWarehouse).isEmpty()) {
                    destinationWhtoStockSerialsListMap.remove(destinationWarehouse);
                }
            }

            //Creating transfer records
            if (!destinationWhtoStockSerialsListMap.keySet().isEmpty()) {
                buildTransferRecords(destinationWhtoStockSerialsListMap, originWarehousesSet);
            }

            /* END
             * Updating Product Stock related to upserted serial stock
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //returning data to client
            response.put('stockSerialsIds', stockSerialsIds);
            response.put('insertedStockSerials', newStockSerialsMap);
            response.put('rowIndexErrorsListMap', rowIndexErrorsListMap);
            response.put('rowIndexWarningsListMap', rowIndexWarningsListMap);
            response.put('rowsWithErrorsSize', rowIndexErrorsListMap.keySet().size());
            response.put('rowsWithWarningsSize', rowIndexWarningsListMap.keySet().size());

        } catch (Exception e) {
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            Database.rollback(sp);
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-00D0501] ' + e.getMessage());
        }
        return response;
    }

    /**
     * Used to retrieve list of available warehouses
     *
     * @code 06
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
                                                                 Plc_Tipology__c != 'Installed' AND
                                                                 (Name LIKE :searchKey OR
                                                                  Bit2Shop__Dealer_Id__r.Name LIKE :searchKey OR
                                                                  Plc_Tipology__c LIKE :searchKey OR
                                                                  Plc_LogisticDivision__c LIKE :searchKey OR
                                                                  Plc_Property__c LIKE :searchKey OR
                                                                  Bit2Shop__City__c LIKE :searchKey)];
            response.put('warehousesList', warehousesList);

        } catch (Exception e) {
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-00D0601] ' + e.getMessage());
        }
        return response;
    }

    /**
     * Retrieves a map containing the picklist values of specified field/object
     *
     * @code 08
     * 
     * @param  sObjectType Name of object from which getting the field
     * @param  fieldName   Name of the field from which getting values
     * @return             Map containing pairs picklist values Api Name/Value
     */
    private Static Map<String, Schema.PicklistEntry> retrieveActivePickListValues(String sObjectType, 
                                                                                  String fieldName) {

        Map<String, Schema.PicklistEntry> picklistMapToReturn = new Map<String, Schema.PicklistEntry>();
        Schema.DescribeFieldResult objectFieldMap = Schema.getGlobalDescribe()
                                                    .get(sObjectType)
                                                    .getDescribe()
                                                    .fields.getMap()
                                                    .get(fieldName)
                                                    .getDescribe();

        for (Schema.PicklistEntry picklistEntry : objectFieldMap.getPicklistValues()) {
            if (picklistEntry.isActive()) {
                picklistMapToReturn.put(picklistEntry.getLabel().toLowerCase(), picklistEntry);
            }
        }
        return picklistMapToReturn;
    }

    /**
     * Recursive method used to process big csv files
     *
     * @code 09
     * 
     * @param input Input csv file as string
     */
    private static void divideString(String input) {
        
        Integer pivot = input.indexOf('\n', Integer.valueOf(Math.floor(input.length() / 2)));

        String left = input.substring(0, pivot);
        String right = input.substring(pivot + 1);
        
        if (pivot < INPUT_CHARACTER_MAX) {
            //Split left and right chunks, add to inputCsvRows
            List<String> leftLines = left.split('\n');
            List<String> rightLines = right.split('\n');
            inputCsvRows.addAll(leftLines);
            inputCsvRows.addAll(rightLines);
        } else {
            //Divide at impera!
            divideString(left);
            divideString(right);
        }
    }

    /**
     * Main method used to create transfer records
     *
     * @code 10
     * 
     * @param destinationWhtoStockSerialsListMap
     * @param originWarehousesSet
     */
    private static void buildTransferRecords(Map<String, List<Bit2Shop__Stock_Serials2__c>> destinationWhtoStockSerialsListMap, Set<String> originWarehousesSet) {

        Map<String, Bit2Shop__Warehouse__c> warehousesMap = new Map<String, Bit2Shop__Warehouse__c>();
        List<Bit2Shop__Dealer_User__c> dealerUserList = new List<Bit2Shop__Dealer_User__c>();

        /* START
         * Retrieving needed records such as warehouses, dealers, dealer users, ...
         * ----------------------------------------------------------------------------------------------------------------------------------- */

        //Getting warehouse of undefined
        Bit2Shop__Warehouse__c undefinedWarehouse = [SELECT Id, Bit2Shop__Dealer_Id__c,
                                                            Bit2Shop__Dealer_Id__r.OwnerId
                                                     FROM Bit2Shop__Warehouse__c
                                                     WHERE Plc_Alias__c = '999011NEXI' LIMIT 1];

        //Building set of origin dealers
        for (Bit2Shop__Warehouse__c warehouse : [SELECT Id, Bit2Shop__Dealer_Id__c,
                                                        Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c
                                                 FROM Bit2Shop__Warehouse__c
                                                 WHERE Id IN :originWarehousesSet OR 
                                                       Id IN :destinationWhtoStockSerialsListMap.keySet() OR
                                                       ID = :undefinedWarehouse.Id]) {

            warehousesMap.put(warehouse.Id, warehouse);
        }
        //Buidling dealer users for each dealer found
        for (Bit2Shop__Dealer_User__c dealerUser : [SELECT Id, Bit2Shop__User_Id__c,
                                                           Bit2Shop__Dealer_User__c.Bit2Shop__Dealer_Id__c
                                                    FROM Bit2Shop__Dealer_User__c 
                                                    WHERE Bit2Shop__Dealer_Id__c = :undefinedWarehouse.Bit2Shop__Dealer_Id__c]) {

            dealerUserList.add(dealerUser);
        }


        //Declaring transfer detail
        Bit2Shop__TransferDetail__c transferDetail = [SELECT Id, Bit2Shop__Transfer_Type__c, Bit2Shop__Code__c 
                                                      FROM  Bit2Shop__TransferDetail__c 
                                                      WHERE Bit2Shop__Code__c = 'SPOS_INDEFINITI'];

        /* END
         * Retrieving needed records such as warehouses, dealers, dealer users, ...
         * ----------------------------------------------------------------------------------------------------------------------------------- */

        /* START
         * Building transfer records
         * ----------------------------------------------------------------------------------------------------------------------------------- */

        Bit2Shop__StockOrder__c newStockOrder;
        NE__Order__c newConfiguration;
        Map<String, Bit2Shop__StockOrder__c> destinationWhToStockOrder = new Map<String, Bit2Shop__StockOrder__c>();
        Map<String, NE__Order__c> destinationWhToConfiguration = new Map<String, NE__Order__c>();
        String currentUserId = UserInfo.getUserId();
        Boolean containsUserId = false;

        //Creating Stock Order and Configurations
        for (String destinationWarehouse : destinationWhtoStockSerialsListMap.keySet()) {
            //Creating Stock Order
            newStockOrder = new Bit2Shop__StockOrder__c();
            newStockOrder.Bit2Shop__Status__c = Plc_WorkOrderApxAct.STOCK_ORDER_STATUS_CLOSED; //TODO
            newStockOrder.Bit2Shop__Destination_Warehouse_Id__c = destinationWarehouse;
            newStockOrder.Bit2Shop__Warehouse_Id__c = undefinedWarehouse.Id;
            newStockOrder.Bit2Shop__Transfer_Type__c = transferDetail.Bit2Shop__Transfer_Type__c;
            newStockOrder.Bit2Shop__Point_Of_Sales_Id__c = warehousesMap.get(undefinedWarehouse.Id).Bit2Shop__Dealer_Id__c;
            newStockOrder.Bit2Shop__Holding_Id__c = warehousesMap.get(undefinedWarehouse.Id).Bit2Shop__Dealer_Id__r.Bit2Shop__Account_Id__c;
            newStockOrder.Bit2Shop__Destination_Point_Of_Sales_Id__c = warehousesMap.get(destinationWarehouse).Bit2Shop__Dealer_Id__c;
            newStockOrder.Plc_TransferDetail__c = transferDetail.Id;
            newStockOrder.Plc_ShippingDate__c = System.today();
            newStockOrder.Plc_TakenInChargeDate__c = System.today();
            newStockOrder.RecordtypeId = Plc_Utils.getRecordTypeId (
                Plc_WorkOrderApxAct.STOCK_ORDER_RECORDTYPE_TRANSFER, 
                Bit2Shop__StockOrder__c.SObjectType.getDescribe().name
            );

            if (!dealerUserList.isEmpty()) {
                for(Bit2Shop__Dealer_User__c dealerUser : dealerUserList) {
                    if(dealerUser.Bit2Shop__User_Id__c == currentUserId) {
                        containsUserId = true;
                        continue;
                    }
                }
            }

            if (currentUserId != undefinedWarehouse.Bit2Shop__Dealer_Id__r.OwnerId && !containsUserId) {
                newStockOrder.OwnerId = undefinedWarehouse.Bit2Shop__Dealer_Id__r.OwnerId;
            } else {
                newStockOrder.OwnerId = currentUserId;
            }


            destinationWhToStockOrder.put(destinationWarehouse, newStockOrder);

            //Configuration
            newConfiguration = new NE__Order__c (
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

            destinationWhToConfiguration.put(destinationWarehouse, newConfiguration);
            
        }

        insert destinationWhToStockOrder.values();
        insert destinationWhToConfiguration.values();

        for (String destinationWarehouse : destinationWhtoStockSerialsListMap.keySet()) {
            //Getting stock order and configuration for given destination warehouse
            Bit2Shop__StockOrder__c stockOrder = destinationWhToStockOrder.get(destinationWarehouse);
            NE__Order__c configuration = destinationWhToConfiguration.get(destinationWarehouse);
            //Launching the method that creates the stock serial structure
            createProductSerialStructureFuture(JSON.serialize(destinationWhtoStockSerialsListMap.get(destinationWarehouse)), JSON.serialize(configuration), 
                                               JSON.serialize(stockOrder), true);
        }

        /* END
         * Building transfer records
         * ----------------------------------------------------------------------------------------------------------------------------------- */
    }

    @future(callout = true)
    public static void createProductSerialStructureFuture(String selectedProductSerialSerialized, String configurationToCreateSerialized, String stockOrderSerialized, Boolean toClose) {

        List<Bit2Shop__Stock_Serials2__c> selectedProductSerial = (List<Bit2Shop__Stock_Serials2__c>) JSON.deserialize(selectedProductSerialSerialized, List<Bit2Shop__Stock_Serials2__c>.class);
        NE__Order__c configurationToCreate = (NE__Order__c) JSON.deserialize(configurationToCreateSerialized, NE__Order__c.class);
        Bit2Shop__StockOrder__c stockOrder = (Bit2Shop__StockOrder__c) JSON.deserialize(stockOrderSerialized, Bit2Shop__StockOrder__c.class);

        Plc_Utils.shipmentsUtils.createProductSerialStructure(selectedProductSerial, configurationToCreate, stockOrder, toClose);
    }
    
    /* Wrapper class used to represent product stock to insert */
    private class ProductStockWrp {
        String warehouseId;
        String modelId;
        String modelName;
        String warehouseAlias;
        String sku;
    }
}