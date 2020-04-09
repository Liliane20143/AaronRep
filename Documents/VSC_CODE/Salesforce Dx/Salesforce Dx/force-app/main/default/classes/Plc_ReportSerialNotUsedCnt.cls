/**
* @author      Andrea Liverani andrea.liverani@webresults.it
* @description Controller class for Plc_ReportSerialNotUsed
* @history     Andrea Liverani (andrea.liverani@webresults.it) - 18/03/2019 - Created
**/
public without sharing class Plc_ReportSerialNotUsedCnt {
    public Plc_ReportSerialNotUsedCnt() {
    }

    public class statusWrapper {
        @AuraEnabled
        public String label {get;set;}

        @AuraEnabled
        public String value {get;set;}

        public statusWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    public class stockSerialWrapper {
        @AuraEnabled
        public String Id { get; set; }

        @AuraEnabled
        public String name { get; set; }

        @AuraEnabled
        public String manufacturerSerialNumber {get;set;}

        @AuraEnabled
        public String encodedSerialNumber {get;set;}

        @AuraEnabled
        public String dllSerialNumber {get;set;}

        @AuraEnabled
        public String model {get;set;}

        @AuraEnabled
        public String parentDealer { get; set; }

        @AuraEnabled
        public String childDealer { get; set; }

        @AuraEnabled
        public String warehouse { get; set; }

        public stockSerialWrapper(String Id, String name, String manufacturerSerialNumber, String encodedSerialNumber, String dllSerialNumber, String model, String parentDealer, String childDealer, String warehouse) {
            this.Id = Id;
            this.name = name;
            this.manufacturerSerialNumber = manufacturerSerialNumber;
            this.encodedSerialNumber = encodedSerialNumber;
            this.dllSerialNumber = dllSerialNumber;
            this.model = model;
            this.parentDealer = parentDealer;
            this.childDealer = childDealer;
            this.warehouse = warehouse;
        }

        public stockSerialWrapper() {
        }

    }

    /**
    * @author Andrea Liverani
    * @date 29 mar 2019 12:11
    * @description initialize method
    * @param
    * @return Map<String, Object>
    */
    @AuraEnabled
    (cacheable = true)
    public static Map<String, Object> initialize() {
        try {
            System.debug('initialize --> start');
            Map<String, Object> result = new Map<String, Object>();

            result.put('statusPicklistValues', getStockSerialStatusPicklistValues());
            result.put('dealerChildRecordTypeId', Plc_Utils.getRecordTypeId('Plc_ChildDealer', 'Bit2Shop__Dealer__c'));
            result.put('dealerParentRecordTypeId',Plc_Utils.getRecordTypeId('Plc_ParentDealer', 'Bit2Shop__Dealer__c'));

            System.debug('initialize --> end');
            return result;

        } catch (Exception error) {
            String errorMessage = 'initialize --> exception: error in: ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @author Andrea Liverani
    * @date 29 mar 2019 12:11
    * @description method for retrieve all stock serial status picklist values
    * @param
    * @return List<String>
    */
    public static List<statusWrapper> getStockSerialStatusPicklistValues() {
        try {
            System.debug('getStockSerialStatusPicklistValues --> start');

            List<statusWrapper> stockSerialStatusPickListValues = new List<statusWrapper>();

            Schema.DescribeFieldResult statusField = Bit2Shop__Stock_Serials2__c.Bit2Shop__Status__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntryList = statusField.getPicklistValues();

            for (Schema.PicklistEntry pe : picklistEntryList) {
                stockSerialStatusPickListValues.add(new statusWrapper(pe.getLabel(), pe.getValue()));
            }

            System.debug('getStockSerialStatusPicklistValues --> end - stockSerialStatusPickListValues : ' + stockSerialStatusPickListValues);
            return stockSerialStatusPickListValues;

        } catch (Exception error) {
            String errorMessage = 'getStockSerialStatusPicklistValues --> exception: error in: ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @author Andrea Liverani
    * @date 29 mar 2019 12:12
    * @description method which apply filter to search
    * @param Date startDate, Date endDate, String status, String dealerChildId, String dealerParentId, String warehouseId
    * @return List<stockSerialWrapper>
    */
    @AuraEnabled
    (cacheable = true)
    public static List<stockSerialWrapper> applyFilter(Date startDate, Date endDate, String status, String dealerChildId, String dealerParentId, String warehouseId) {
        try {
            System.debug('applyFilter --> start - startDate : ' + startDate + ', endDate : ' + endDate + ', status : ' + status + ', dealerChildId : ' + dealerChildId + ', dealerParentId : ' + dealerParentId + ', warehouseId : ' + warehouseId);

            String whereConditionHistory = '';
            String whereConditionStockSerial = '';

            DateTime startDateTime = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day());
            DateTime endDateTime = DateTime.newInstance(endDate.year(), endDate.month(), endDate.day());
            String dealerChildIdForQuery = dealerChildId != null ? dealerChildId.remove('\'') : null;
            String dealerParentIdForQuery = dealerParentId != null ? dealerParentId.remove('\'') : null;

            if (startDate != null) {
                whereConditionHistory += ' Plc_RecordStartDate__c > :startDateTime AND';
            }

            if (endDate != null) {
                whereConditionHistory += ' Plc_RecordEndDate__c < :endDateTime';
            }

            if (String.isNotBlank(status)) {
                whereConditionStockSerial += 'Bit2Shop__Status__c = :status ';
            }

            if (String.isNotBlank(dealerChildIdForQuery)) {
                whereConditionStockSerial += ' AND Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__c = :dealerChildIdForQuery';
            }

            if (String.isNotBlank(dealerParentIdForQuery)) {
                whereConditionStockSerial += ' AND Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__c = :dealerParentIdForQuery';
            }

            if (String.isNotBlank(warehouseId)) {
                whereConditionStockSerial += ' AND Bit2Shop__Warehouse_Id__c = :warehouseId';
            }

            String additionalLimit = '';

            if(String.isBlank(dealerChildIdForQuery) && String.isBlank(dealerParentIdForQuery) && String.isBlank(warehouseId)) {
                additionalLimit = ' LIMIT 1000';
            }

            String queryString = 'SELECT Id, Name, Plc_Model__c, Plc_ManufacturerSerialNumber__c, Plc_EncodedSerialNumber__c, Plc_DllSerialNumber__c, Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__r.Name, Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Name, Bit2Shop__Warehouse_Id__r.Name, (SELECT Id FROM Bit2Shop__Serial_Stock_Histories__r WHERE ' + whereConditionHistory + ') FROM Bit2Shop__Stock_Serials2__c WHERE ' + whereConditionStockSerial + additionalLimit;

            System.debug('applyFilter --> queryString : ' + queryString);

            List<Bit2Shop__Stock_Serials2__c> stockSerialList = Database.query(queryString);
            List<Bit2Shop__Stock_Serials2__c> stockSerialNotUsedList = new List<Bit2Shop__Stock_Serials2__c>();

            if (!stockSerialList.isEmpty()) {
                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialList) {
                    if(stockSerial.Bit2Shop__Serial_Stock_Histories__r.isEmpty()) {
                        stockSerialNotUsedList.add(stockSerial);
                    }
                }

                if(!stockSerialNotUsedList.isEmpty()) {
                    return getWrapperListFromStockSerialList(stockSerialNotUsedList);
                } else {
                    System.debug('applyFilter --> stockSerialNotUsedList : ' + stockSerialNotUsedList);
                }
            } else {
                System.debug('applyFilter --> stockSerialList is empty.');
            }

        } catch (Exception error) {
            String errorMessage = 'applyFilter --> exception: error in: ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @author Andrea Liverani
    * @date 29 mar 2019 12:14
    * @description method which create a stockWrapper record for each stock serial present in the list
    * @param List<Bit2Shop__Stock_Serials2__c> stockSerialList
    * @return List<stockSerialWrapper>
    */
    public static List<stockSerialWrapper> getWrapperListFromStockSerialList(List<Bit2Shop__Stock_Serials2__c> stockSerialList) {
        try {
            System.debug('getWrapperListFromStockSerialList --> stockSerialList' + stockSerialList);

            List<stockSerialWrapper> stockSerialWrapperList = new List<stockSerialWrapper>();

            if (!stockSerialList.isEmpty()) {
                for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerialList) {
                    stockSerialWrapperList.add(new stockSerialWrapper(stockSerial.Id, stockSerial.Name, stockSerial.Plc_ManufacturerSerialNumber__c, stockSerial.Plc_EncodedSerialNumber__c, stockSerial.Plc_DllSerialNumber__c, stockSerial.Plc_Model__c, stockSerial.Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__r.Name, stockSerial.Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Name, stockSerial.Bit2Shop__Warehouse_Id__r.Name));
                }
            } else {
                System.debug('getWrapperListFromStockSerialList --> stockSerialList is empty.');
            }

            System.debug('getWrapperListFromStockSerialList --> end - stockSerialWrapperList : ' + stockSerialWrapperList);
            return stockSerialWrapperList;

        } catch (Exception error) {
            String errorMessage = 'getWrapperListFromStockSerialList --> exception: error in: ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }

    /**
    * @author Andrea Liverani
    * @date 29 mar 2019 12:16
    * @description method which create CSV to be downloaded
    * @param List<stockSerialWrapper> stockSerialWrapperList, String separatorCSV
    * @return String
    */
    @AuraEnabled
    public static String exportCSV(List<stockSerialWrapper> stockSerialWrapperList, String separatorCSV) {
        try {
            System.debug('exportCSV --> stockSerialWrapperList : ' + stockSerialWrapperList + ', separatorCSV : ' + separatorCSV);

            if (String.isNotBlank(separatorCSV)) {

                String separator = separatorCSV == 'semicolon' ? ';' : separatorCSV == 'comma' ? ',' : separatorCSV;
                String headerCSV = 'Id' + separator + Label.Plc_ManufacturerSerialNumber + separator + Label.Plc_EncodedSerialNumber + separator + Label.Plc_DllSerialNumber + separator + Label.Plc_ParentDealer + separator + Label.Plc_ChildDealer + separator + Label.Plc_Warehouse + '\n';
                String bodyCSV = '';

                if (!stockSerialWrapperList.isEmpty()) {
                    for (stockSerialWrapper stockSerial : stockSerialWrapperList) {
                        bodyCSV += stockSerial.Id + separator + stockSerial.manufacturerSerialNumber + separator + stockSerial.encodedSerialNumber + separator + stockSerial.dllSerialNumber + separator + stockSerial.parentDealer + separator + stockSerial.childDealer + separator + stockSerial.warehouse +'\n';
                    }

                    if (String.isNotBlank(bodyCSV)) {
                        String exportCSV = headerCSV + bodyCSV;
                        System.debug('exportCSV --> exportCSV : ' + exportCSV);
                        return exportCSV;
                    } else {
                        System.debug('exportCSV --> exportCSV is null or blank.');
                    }
                } else {
                    System.debug('exportCSV --> stockSerialWrapperList is empty.');
                }
            } else {
                System.debug('exportCSV --> separatorCSV is null or blank.');
            }

        } catch (Exception error) {
            String errorMessage = 'exportCSV --> exception: error in: ' + error.getMessage() + ' at line: ' + error.getLineNumber() + ' stack trace: ' + error.getStackTraceString();
            System.debug(errorMessage);
        }
        return null;
    }
}