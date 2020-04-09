/**
* *************************************************
*     * @Author nunzio.capasso@/webresults.it
*     * @date  29/01/2019 10:02
*     * @description apex controller for Plc_filtercmp
*     * @Modified by
*   ***********************************************
**/
public without sharing class Plc_FilterCmpCnt {

    public static List<String> encodedSerialNumbersToQuery = new List<String>();
    public static Set<String> filter =new Set<String>();

    public class InputString {
        @AuraEnabled
        String inputString { get; set; }
        @AuraEnabled
        String rangeMatricolaDa { get; set; }
        @AuraEnabled
        String rangeMatricolaA { get; set; }
        @AuraEnabled
        String manufacturer { get; set; }
        @AuraEnabled
        String status { get; set; }
    }

/**
 * *************************************************
 *     * @Author nunzio.capasso@/webresults.it
 *     * @date  29/01/2019 10:02
 *     * @description Method that queries Bit2Shop__Stock_Serials2__c with the passed string
 *     * @param  inputString string , value to search
 *     * @param  choosenCase string, value for future method expansion
 *     * @Modified by
 *   ***********************************************
 **/
    @AuraEnabled (Cacheable=true)
    public static Map<String, Object> applyFilters(String inputsFields, Map<String, String> configurationMap) {

        InputString input = new InputString();
        Map<String, Object> queryResults = new Map<String, Object>();

        try {
            input = (InputString) JSON.deserialize(inputsFields, InputString.class);

            Integer.valueOf(findNumberInsideString(input.rangeMatricolaA));

        } catch (Exception e) {
            String errorMessage = 'applyFilters Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(errorMessage);
        }


        if (input == null) {
            return null;
        }

        System.debug('input: ' + input);
        System.debug('input: ' + input.inputString);



        /* MAPPING CAMPI -> LAYOUT
         * Plc_ProductSKU__c = SKU PRODOTTO
         * Plc_Model__c= MODELLO
         * Bit2Shop__Status__c = STATO SERIALE
         * Bit2Shop__Serial_Number__c = SERIALE
         * Plc_DllSerialNumber__c = MATRICOLA DLL
         * Plc_Manufacturer__c = COSTRUTTORE
         * Plc_ManufacturerSerialNumber__c = MATRICOLA COSTRUTTORE
         * Plc_EncodedSerialNumber__c = MATRICOLA NEXI?
        * */

        if (configurationMap.containsKey('Bit2Shop__Stock_Serials2__c')) {

            queryResults.put('Bit2Shop__Stock_Serials2__c', Database.query(buildSOQLToRetrieveStockSerials(input, configurationMap.get('Bit2Shop__Stock_Serials2__c'))));
        }

        if (configurationMap.containsKey('Bit2Shop__Product_Stock__c')) {
            queryResults.put('Bit2Shop__Product_Stock__c', Database.query(buildSOQLToretrieveProductStocks(input, configurationMap.get('Bit2Shop__Product_Stock__c'))));
        }

        if (configurationMap.containsKey('SLI_StockSerials')) {
            queryResults.put('SLI_StockSerials', Database.query(buildSOQLToRetrieveShipmentStockSerials(input, configurationMap.get('SLI_StockSerials'))));
        }

        if (configurationMap.containsKey('SLI_ProductStocks')) {
            queryResults.put('SLI_ProductStocks', Database.query(buildSOQLToRetrieveShipmentProductStocks(input, configurationMap.get('SLI_ProductStocks'))));
        }

        if (configurationMap.containsKey('fromGoodsHandling')) {
            queryResults.put('Bit2Shop__Product_Stock__c', Database.query(buildSOQLToretrieveProductStocksForGoodsHandling(input, configurationMap.get('originWarehouse'))));
            queryResults.put('Bit2Shop__Stock_Serials2__c', Database.query(buildSOQLToretrieveStockSerialForGoodsHandling(input, configurationMap.get('originWarehouse'), configurationMap.get('filterSerialStatus'))));
            System.debug('Plc_GoodsHandlingCnt loadData filter: '+filter);
        }

        return queryResults;
    }

    /**
     * *************************************************
     *     * @Author nunzio.capasso@/webresults.it
     *     * @date  29/01/2019 16:32
     *     * @description
     *     * @Modified by
     *   ***********************************************
     **/

    public static Long findNumberInsideString(String stringToScan) {
        if (String.isEmpty(stringToScan)) {
            return null;
        }
        Long returnValue = 0;
        Pattern pat = Pattern.compile('([0-9]+)');
        Matcher matcher = pat.matcher(stringToScan);
        Boolean matches = matcher.find();
        System.debug(LoggingLevel.ERROR, matches);
        System.debug(LoggingLevel.ERROR, matcher.group(1));
        try {
            returnValue = Long.valueOf(matcher.group(1));
        } catch (Exception e) {
            String errorMessage = 'findNumberInsideString Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(errorMessage);
        }

        System.debug('findNumberInsideString returnValue: ' + returnValue);
        return returnValue;
    }


    /**
     * *************************************************
     *     * @Author nunzio.capasso@/webresults.it
     *     * @date  30/01/2019 10:42
     *     * @description methods that gets the picklist values
     *     * @param fieldName  api name
     *     * @param sObjectName api name
     *     * @Modified by
     *   ***********************************************
     **/

    public class picklistEntryObj {
        @AuraEnabled
        public String picklistValue;
        @AuraEnabled
        public String picklistLabel;
        public picklistEntryObj(String picklistValue, String picklistLabel) {
            this.picklistValue = picklistValue;
            this.picklistLabel = picklistLabel;
        }

    }

    @AuraEnabled(Cacheable=true)
    public static List<picklistEntryObj> getPicklistOptions(String fieldName, String sObjectName) {
        List<picklistEntryObj> options = new List<picklistEntryObj>();

        // Get describe of all the objects
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        // Get the SObject Type from the specific object name that is passed in
        Schema.SObjectType sobjType = gd.get(sObjectName);
        // Get the describe result of the passed in object
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        // Get the fields of the passed in object
        Map<String, Schema.SObjectField> field_map = r.fields.getMap();
        // get the pick list values of the field that was passed in from the field map of the object passed in
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPicklistValues();

        for (Schema.PicklistEntry f : pick_list_values) {
            options.add(new picklistEntryObj (f.getLabel(), f.getValue()));
        }

        System.debug('Options: ' + options);
        return options;
    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  02/02/2019 06:06
     *     * @description Create a dynamic soql query string to retrieve Stock Serials
     *     * @Modified by
     *   ***********************************************
     **/
    private static String buildSOQLToRetrieveStockSerials(Plc_FilterCmpCnt.InputString filterInputs, String additionalFilters) {

        List<Long> EncodedSerialNumbers = new List<Long>();
        encodedSerialNumbersToQuery = new List<String>();

        List<String> query = new List<String>();
        String composedQuery = '';

        query.add('SELECT ' +
                'Plc_ProductSKU__c,Plc_Manufacturer__c,' +
                'Bit2Shop__Status__c,Plc_DllSerialNumber__c,Plc_Model__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c,'+
                'Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c,Bit2Shop__Warehouse_Id__c,Plc_WithdrawnBy__c,Plc_Status2__c');

        query.add(' FROM Bit2Shop__Stock_Serials2__c');


        if (!String.isEmpty(filterInputs.inputString)) {
            query.add(' WHERE ' +
                    '(Plc_ProductSKU__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_DllSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_Model__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_EncodedSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_ManufacturerSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ')');
        }

        /*sostituire data con Encoded Serial Number*/
        if (!String.isEmpty(filterInputs.rangeMatricolaA) && !String.isEmpty(filterInputs.rangeMatricolaDa)) {

            EncodedSerialNumbers.add(findNumberInsideString(filterInputs.rangeMatricolaDa));
            EncodedSerialNumbers.add(findNumberInsideString(filterInputs.rangeMatricolaA));
            EncodedSerialNumbers.sort();
            System.debug('EncodedSerialNumbers ' + EncodedSerialNumbers);


            Integer count = 0;
            for (Long i = EncodedSerialNumbers[0]; i <= EncodedSerialNumbers[1]; i++) {
                encodedSerialNumbersToQuery.add(String.valueOf(i).leftPad(10, '0'));
                count++;
                if (count >= 1000000) {
                    System.debug('Limit exceded! Max intervall 1000000 ');
                    break;
                }
            }

            System.debug('EncodedSerialNumbersToQuery ' + encodedSerialNumbersToQuery);

            if (String.isEmpty(filterInputs.inputString)) {
                query.add(' WHERE(' +
                        ' Plc_EncodedSerialNumber__c IN :encodedSerialNumbersToQuery )');
            } else {
                query.add(' AND(Plc_EncodedSerialNumber__c IN :encodedSerialNumbersToQuery )');
            }
        }

        if (!String.isEmpty(filterInputs.manufacturer)) {
            if ((String.isEmpty(filterInputs.rangeMatricolaA) && String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString))) {
                query.add(' WHERE(Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.manufacturer + '%\'' + ' )');
            } else {
                query.add(' AND(Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.manufacturer + '%\'' + ' )');
            }
        }

        if (!String.isEmpty(filterInputs.status)) {
            if ((String.isEmpty(filterInputs.rangeMatricolaA) && String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString)) && String.isEmpty(filterInputs.manufacturer)) {
                query.add(' WHERE(Bit2Shop__Status__c LIKE ' + '\'%' + filterInputs.status + '%\'' + ' )');
            } else {
                query.add(' AND(Bit2Shop__Status__c LIKE ' + '\'%' + filterInputs.status + '%\'' + ' )');
            }

        }

        if (!String.isEmpty(additionalFilters)) {

            if ((String.isEmpty(filterInputs.rangeMatricolaA) && String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString)) && String.isEmpty(filterInputs.manufacturer) && String.isEmpty(filterInputs.status)) {
                query.add(' WHERE (' + additionalFilters + ')');
            } else {
                query.add(' AND (' + additionalFilters + ')');
            }
        }


        query.add(' LIMIT 1000');

        //compose the query
        for (String s : query) {
            composedQuery += s;
        }

        System.debug('Composed query: ' + composedQuery);

        return composedQuery;

    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  02/02/2019 06:06
     *     * @description Create a dynamic soql query string to retrieve Product Stocks
     *     * @Modified by nunzio.capasso@/webresults.it 04/02/2019
     *   ***********************************************
     **/
    private static String buildSOQLToretrieveProductStocks(Plc_FilterCmpCnt.InputString filterInputs, String additionalFilters) {

        List<String> query = new List<String>();
        String composedQuery = '';

        query.add('SELECT ' +
                'Id,Plc_ProductSku__c,Plc_Manufacturer__c,' +
                'Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,' +
                'Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,' +
                'Bit2Shop__Product_Description__c,Plc_AvailableQty__c,Bit2Shop__Warehouse_Id__c,Plc_Required_Serial__c,Bit2Shop__Shipped_Qty__c');

        query.add(' FROM Bit2Shop__Product_Stock__c');


        if (!String.isEmpty(filterInputs.inputString)) {
            query.add(' WHERE ' +
                    '(Plc_ProductSku__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ')');
        }

        if (!String.isEmpty(additionalFilters)) {
            if ((String.isEmpty(filterInputs.rangeMatricolaA) && String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString)) && String.isEmpty(filterInputs.manufacturer) && String.isEmpty(filterInputs.status)) {
                query.add(' WHERE (' + additionalFilters + ')');
            } else {
                query.add(' AND (' + additionalFilters + ')');
            }
        }

        query.add(' LIMIT 1000');

        //compose the query
        for (String s : query) {
            composedQuery += s;
        }

        System.debug('Composed query: ' + composedQuery);

        return composedQuery;

    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  05/02/2019 10:58
     *     * @description query on Shipment Line Items to retrieve Stock Serials
     *     * @Modified by
     *   ***********************************************
     **/
    private static String buildSOQLToRetrieveShipmentStockSerials(Plc_FilterCmpCnt.InputString filterInputs, String additionalFilters) {

        //List<Integer> EncodedSerialNumbers = new List<Integer>();
        //List<String> EncodedSerialNumbersToQuery = new List<String>();

        String sliStockSerialRTId = Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_ShipmentLineItem.RecordType_Serial).getRecordTypeId();

        String inboundShipmentRTId = Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_Shipment.RecordType_InboundShipment).getRecordTypeId();

        List<String> query = new List<String>();
        String composedQuery = '';

        query.add('SELECT Id, Plc_StockSerial__r.Id,Recordtype.DeveloperName,Bit2Shop__Shipment_Id__c,Bit2Shop__Shipment_Id__r.Name,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__c,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Name,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__c,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Name,' +
                'Plc_StockSerial__r.Plc_ProductSKU__c,  Plc_StockSerial__r.Plc_Manufacturer__c,' +
                'Plc_StockSerial__r.Bit2Shop__Status__c,Plc_StockSerial__r.Plc_DllSerialNumber__c,Plc_StockSerial__r.Plc_Model__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,' +
                'Bit2Shop__Status__c,Bit2Shop__Received_Status__c,Bit2Shop__Shipment_Status__c,' +
                'Plc_StockSerial__r.Plc_EncodedSerialNumber__c,Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c,' +
                'Bit2Shop__Received_Quantity__c,Plc_NotReceivedQty__c,Bit2Shop__Requested_Quantity__c,' +
                'Plc_StockSerial__r.Bit2Shop__Warehouse_Id__c,Plc_StockSerial__r.Plc_WithdrawnBy__c');

        query.add(' FROM Bit2Shop__Shipment_Line_Item__c ' +
                    ' WHERE RecordTypeId =\'' + sliStockSerialRTId + '\'' +
                    ' AND Bit2Shop__Shipment_Id__r.RecordTypeId =\'' + inboundShipmentRTId   + '\'');


        if (!String.isEmpty(filterInputs.inputString)) {

            query.add(' AND ' +
                    '(Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Bit2Shop__Product_Stock_Id__r.Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_StockSerial__r.Plc_ProductSKU__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_StockSerial__r.Plc_DllSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_StockSerial__r.Plc_Model__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_StockSerial__r.Plc_EncodedSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_StockSerial__r.Plc_ManufacturerSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ')');
        }

        if (!String.isEmpty(filterInputs.manufacturer)) {

            query.add(' AND(Plc_StockSerial__r.Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.manufacturer + '%\'' + ' )');
        }

        if (!String.isEmpty(additionalFilters)) {
            query.add(' AND ' + additionalFilters);
        }

        query.add(' LIMIT 1000');

        //compose the query
        for (String s : query) {
            composedQuery += s;
        }

        System.debug('Composed query: ' + composedQuery);

        return composedQuery;

    }

    /**
     * *************************************************
     *     * @Author marco.lebellini@/webresults.it
     *     * @date  05/02/2019 10:58
     *     * @description query on Shipment Line Items to retrieve Stock Serials
     *     * @Modified by
     *   ***********************************************
     **/
    private static String buildSOQLToRetrieveShipmentProductStocks(Plc_FilterCmpCnt.InputString filterInputs, String additionalFilters) {

        List<String> query = new List<String>();
        String composedQuery = '';

        String sliProductStocksRTId = Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_ShipmentLineItem.RecordType_Product).getRecordTypeId();

        String inboundShipmentRTId = Bit2Shop__Shipment__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(Plc_Constants.B2S_Shipment.RecordType_InboundShipment).getRecordTypeId();

        query.add('SELECT Id,RecordType.DeveloperName,Bit2Shop__Shipment_Id__c,Bit2Shop__Shipment_Id__r.Name,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__c,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Point_Of_Sales_Id__r.Name,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__c,' +
                'Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__r.Bit2Shop__Warehouse_Id__r.Name,' +
                'Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,' + 
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Name,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_Description__c,Bit2Shop__Product_Stock_Id__r.Plc_AvailableQty__c,' +
                'Bit2Shop__Status__c,Bit2Shop__Received_Status__c,Bit2Shop__Shipment_Status__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__Warehouse_Id__c,' +
                'Bit2Shop__Received_Quantity__c,Plc_NotReceivedQty__c,Bit2Shop__Requested_Quantity__c,' +
                'Bit2Shop__Product_Stock_Id__r.Plc_Required_Serial__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__Shipped_Qty__c');

        query.add(' FROM Bit2Shop__Shipment_Line_Item__c WHERE RecordTypeId =\'' + sliProductStocksRTId + '\'' +
                    ' AND Bit2Shop__Shipment_Id__r.RecordTypeId =\'' + inboundShipmentRTId   + '\'');

        if (!String.isEmpty(filterInputs.inputString)) {
            query.add(' AND ' +
                    '(Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Bit2Shop__Product_Stock_Id__r.Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ')');
        }

        if (!String.isEmpty(additionalFilters)) {
            query.add(' AND ' + additionalFilters);
        }

        query.add(' LIMIT 1000');

        //compose the query
        for (String s : query) {
            composedQuery += s;
        }

        System.debug('Composed query: ' + composedQuery);

        return composedQuery;

    }

    /**
     * *************************************************
     *     * @Author giampaolo.mei@webresults.it
     *     * @date  05/02/2019
     *     * @description query to retrieve product stock
     *     * @Modified by
     *   ***********************************************
     **/
    private static String buildSOQLToretrieveProductStocksForGoodsHandling(Plc_FilterCmpCnt.InputString filterInputs, String additionalFilters) {
        List<String> query = new List<String>();
        String composedQuery = '';

        query.add('SELECT ' +
                'Plc_ProductSku__c,Plc_Manufacturer__c,' +
                'Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c, Bit2Shop__External_Catalog_Item_Id__c, Bit2Shop__External_Catalog_Item_Id__r.Name, Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,' +
                'Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,' +
                'Bit2Shop__Product_Description__c,Plc_AvailableQty__c,Bit2Shop__Warehouse_Id__c,Plc_Required_Serial__c,Bit2Shop__Shipped_Qty__c');

        query.add(' FROM Bit2Shop__Product_Stock__c');


        if (!String.isEmpty(filterInputs.inputString)) {
            query.add(' WHERE ' +
                    '(Plc_ProductSku__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ')');
        }

        if (!String.isEmpty(filterInputs.manufacturer)) {
            if ((String.isEmpty(filterInputs.inputString))) {
                query.add(' WHERE(Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.manufacturer + '%\'' + ' )');
            } else {
                query.add(' AND(Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.manufacturer + '%\'' + ' )');
            }
        }
        /*

        if (!String.isEmpty(filterInputs.status)) {
            if ((String.isEmpty(filterInputs.rangeMatricolaA) && String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString)) && String.isEmpty(filterInputs.manufacturer)) {
                query.add(' WHERE(Bit2Shop__Status__c LIKE ' + '\'%' + filterInputs.status + '%\'' + ' )');
            } else {
                query.add(' AND(Bit2Shop__Status__c LIKE ' + '\'%' + filterInputs.status + '%\'' + ' )');
            }

        }
        */

        if (!String.isEmpty(additionalFilters)) {
            if ((String.isEmpty(filterInputs.inputString)) && String.isEmpty(filterInputs.manufacturer)) {
                query.add(' WHERE (Plc_Required_Serial__c = false AND Plc_AvailableQty__c > 0 AND Bit2Shop__Warehouse_Id__c = \'' + additionalFilters + '\')');
            } else {
                query.add(' AND (Plc_Required_Serial__c = false AND Plc_AvailableQty__c > 0 AND Bit2Shop__Warehouse_Id__c = \'' + additionalFilters + '\')');
            }
        }

        query.add(' LIMIT 1000');

        //compose the query
        for (String s : query) {
            composedQuery += s;
        }

        System.debug('Composed query: ' + composedQuery);

        return composedQuery;
    }

    /**
     * *************************************************
     *     * @Author giampaolo.mei@webresults.it
     *     * @date  05/02/2019
     *     * @description query to retrieve stock Serial 2
     *     * @Modified by
     *   ***********************************************
     **/
    private static String buildSOQLToretrieveStockSerialForGoodsHandling(Plc_FilterCmpCnt.InputString filterInputs, String originalWarehouse, String additionalFilters) {
        List<Long> EncodedSerialNumbers = new List<Long>();
        encodedSerialNumbersToQuery = new List<String>();

        List<String> query = new List<String>();
        //Set<String> filter = new Set<String>();
        String composedQuery = '';

        query.add('SELECT ' +
                'Plc_ProductSKU__c,Plc_Manufacturer__c,' +
                'Bit2Shop__Status__c,Plc_DllSerialNumber__c,Plc_Model__c,' +
                'Bit2Shop__Product_Stock_Id__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,' +
                'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,' +
                'Bit2Shop__Shipment_Line_Item_Id__r.Bit2Shop__Status__c,Bit2Shop__Shipment_Line_Item_Id__r.Bit2Shop__Received_Status__c,' +
                'Bit2Shop__Shipment_Line_Item_Id__r.Bit2Shop__Shipment_Status__c,' +
                'Plc_EncodedSerialNumber__c,Plc_ManufacturerSerialNumber__c,Bit2Shop__Warehouse_Id__c,Plc_WithdrawnBy__c,Plc_Status2__c');

        query.add(' FROM Bit2Shop__Stock_Serials2__c');


        if (!String.isEmpty(filterInputs.inputString)) {
            query.add(' WHERE ' +
                    '(Plc_ProductSKU__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_DllSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_Model__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_EncodedSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ' ' +
                    'OR Plc_ManufacturerSerialNumber__c LIKE ' + '\'%' + filterInputs.inputString + '%\'' + ')');
        }

        /*sostituire data con Encoded Serial Number*/
        if (!String.isEmpty(filterInputs.rangeMatricolaA) && !String.isEmpty(filterInputs.rangeMatricolaDa)) {

            EncodedSerialNumbers.add(findNumberInsideString(filterInputs.rangeMatricolaDa));
            EncodedSerialNumbers.add(findNumberInsideString(filterInputs.rangeMatricolaA));
            EncodedSerialNumbers.sort();
            System.debug('EncodedSerialNumbers ' + EncodedSerialNumbers);

            Integer count = 0;
            for (Long i = EncodedSerialNumbers[0]; i <= EncodedSerialNumbers[1]; i++) {
                encodedSerialNumbersToQuery.add(String.valueOf(i).leftPad(10, '0'));
                count++;
                if (count >= 1000000) {
                    System.debug('Limit exceded! Max intervall 1000000 ');
                    break;
                }
            }

            System.debug('EncodedSerialNumbersToQuery ' + encodedSerialNumbersToQuery);

            if (String.isEmpty(filterInputs.inputString)) {
                query.add(' WHERE(' +
                        ' Plc_EncodedSerialNumber__c IN: encodedSerialNumbersToQuery )');
            } else {
                query.add(' AND(Plc_EncodedSerialNumber__c IN: encodedSerialNumbersToQuery )');
            }
        }

        if (!String.isEmpty(filterInputs.manufacturer)) {
            if ((String.isEmpty(filterInputs.rangeMatricolaA) || String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString))) {
                query.add(' WHERE(Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.manufacturer + '%\'' + ' )');
            } else {
                query.add(' AND(Plc_Manufacturer__c LIKE ' + '\'%' + filterInputs.manufacturer + '%\'' + ' )');
            }
        }

        if (!String.isEmpty(filterInputs.status)) {
            if ((String.isEmpty(filterInputs.rangeMatricolaA) || String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString)) && String.isEmpty(filterInputs.manufacturer)) {
                query.add(' WHERE(Bit2Shop__Status__c LIKE ' + '\'%' + filterInputs.status + '%\'' + ' )');
            } else {
                query.add(' AND(Bit2Shop__Status__c LIKE ' + '\'%' + filterInputs.status + '%\'' + ' )');
            }

        }

        if (!String.isEmpty(originalWarehouse)) {

            if ((String.isEmpty(filterInputs.rangeMatricolaA) || String.isEmpty(filterInputs.rangeMatricolaDa)) && (String.isEmpty(filterInputs.inputString)) && String.isEmpty(filterInputs.manufacturer) && String.isEmpty(filterInputs.status)) {
                query.add(' WHERE Bit2Shop__Warehouse_Id__c = ' + '\'' + originalWarehouse + '\'');
                //List<String> filter = new List<String>();
                if(additionalFilters != null && additionalFilters != ''){
                    System.debug('Plc_GoodsHandlingCnt loadData additionalFilters: '+additionalFilters);
                    filter.addAll(additionalFilters.split(';'));
                    query.add(' AND Bit2Shop__Status__c IN :filter');
                    System.debug('filter vale: '+filter);
                }

            } else {
                query.add(' AND (Bit2Shop__Warehouse_Id__c = ' + '\'' + originalWarehouse + '\'');
                //List<String> filter = new List<String>();
                if(additionalFilters != null && additionalFilters != ''){
                    System.debug('Plc_GoodsHandlingCnt loadData additionalFilters: '+additionalFilters);
                    filter.addAll(additionalFilters.split(';'));
                    query.add(' AND Bit2Shop__Status__c IN :filter)');
                    System.debug('filter vale: '+filter);
                }else{
                    query.add(')');
                }
            }
        }

        query.add(' LIMIT 1000');

        //compose the query
        for (String s : query) {
            composedQuery += s;
        }

        System.debug('Composed query: ' + composedQuery);

        return composedQuery;
    }

}