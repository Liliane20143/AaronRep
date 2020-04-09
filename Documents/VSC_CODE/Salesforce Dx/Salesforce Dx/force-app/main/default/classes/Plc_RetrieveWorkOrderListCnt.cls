/**
 * Controller of the "Plc_RetrieveWorkOrdersListCnt"
 *
 * @author Luca Belometti
 * @version 1.0
 * @description 
 * @testedIn Plc_RetrieveWorkOrderListCntTest
 * @history
 * 2019/05/30 Luca Belometti
 */
public class Plc_RetrieveWorkOrderListCnt {

	private static final String CLASS_NAME = 'Plc_RetrieveWorkOrderListCnt';

    /**
     * execute the query to search all the WorkOrders that match with a search of
	 * Serial Number, TermId Code and Work Order Alias
     * @param  searchSerialNumber Input value from the inputbox Serial Number
     * @param  searchTermId       Input value from the inputbox TermId
     * @param  searchWorkOrder    Input value from the inputbox Work Order Alias
     * @param  picklistValue      Picklist value selected in the picklist
     * @return                    Return the results to front-end
     */
    @AuraEnabled (cacheable=true)
    public static List<RecordsData> fetchRecords(String searchSerialNumber, String searchTermId, String searchWorkOrder, String picklistValue) {
		LogTracker.debugLogBegin(CLASS_NAME,'fetchRecords');

        List<RecordsData> recordsDataList = new List<RecordsData>();
		String picklistValueQuery;

    	if (picklistValue == 'All') {
    		picklistValueQuery = ' ORDER BY StartDate DESC LIMIT 50';
    	}

    	if (picklistValue == 'stockOrderPresentOpen') {
    		picklistValueQuery = ' AND Id IN(SELECT Plc_WorkOrder__c FROM Bit2Shop__StockOrder__c  WHERE Bit2Shop__Status__c = ' + '\''+'Open' + '\'' + ')' + ' ORDER BY StartDate DESC LIMIT 50';
    	}

    	if (picklistValue == 'stockOrderPresentClosed') {
    		picklistValueQuery = ' AND Id IN(SELECT Plc_WorkOrder__c FROM Bit2Shop__StockOrder__c WHERE Bit2Shop__Status__c = ' + '\''+'Closed' + '\'' + ' OR Bit2Shop__Status__c = ' +  + '\''+'Closed with residual lines' + '\'' + ')' + ' ORDER BY StartDate DESC LIMIT 50';
    	}

        String fieldsQuery = 'Id,WorkOrderNumber, Plc_Alias__c, Status, Plc_LegacyAccountId__c, Plc_LegacyServicePointId__c, Plc_ServicePoint__c, Plc_SourceLegacySystem__c, StartDate, EndDate';
        List<String> whereConditions = new List<String>();
        if (String.isNotBlank(searchWorkOrder)) {
            whereConditions.add('Plc_Alias__c LIKE \'%' + String.escapeSingleQuotes(searchWorkOrder.trim()) + '%\'');
        }

        if (String.isNotBlank(searchTermId)) {
            whereConditions.add('Id IN (Select WorkOrderId From WorkOrderLineItem WHERE Plc_TermId__r.Plc_TermIdCode__c LIKE \'' + String.escapeSingleQuotes(searchTermId.trim()) + '%\')');
        }

        if (String.isNotBlank(searchSerialNumber)) {
			String searchSerialNumberInput = '%'+String.escapeSingleQuotes(searchSerialNumber.trim())+'%';
			Map<Id, Bit2Shop__Stock_Serials2__c > mapStockSerial = new Map<Id, Bit2Shop__Stock_Serials2__c>([SELECT Id FROM Bit2Shop__Stock_Serials2__c WHERE Plc_DllSerialNumber__c LIKE :searchSerialNumberInput OR Plc_ManufacturerSerialNumber__c LIKE :searchSerialNumberInput OR Plc_EncodedSerialNumber__c LIKE  :searchSerialNumberInput LIMIT 50]);
			LogTracker.debugLog(CLASS_NAME, 'fetchRecords', 'mapStockSerial.keySet: ' + mapStockSerial.keySet());
			Map<Id, WorkOrderLineItem > mapWoli = new Map<Id, WorkOrderLineItem>([SELECT WorkOrderId FROM WorkOrderLineItem WHERE Plc_StockSerial__c IN :mapStockSerial.keySet() OR Asset.Plc_StockSerial__c IN :mapStockSerial.keySet() LIMIT 50]);
			LogTracker.debugLog(CLASS_NAME, 'fetchRecords', 'mapWoli.keySet: ' + mapWoli.keySet());
			Set<Id> woSet = mapWoli.keySet();
            whereConditions.add('Id IN (Select WorkOrderId From WorkOrderLineItem WHERE Id IN :woSet) ');
        }

		if (String.isBlank(searchWorkOrder) && String.isBlank(searchTermId) && String.isBlank(searchSerialNumber)) {
			whereConditions.add( 'Plc_Alias__c LIKE \'%' + String.escapeSingleQuotes(searchWorkOrder.trim()) + '%\'');
		}

        String query = 'SELECT ' + fieldsQuery + ' FROM WorkOrder WHERE ' + String.join(whereConditions, ' AND ') + picklistValueQuery;
		LogTracker.debugLog(CLASS_NAME, 'fetchRecords', 'query: ' + query);
		LogTracker.debugLog(CLASS_NAME, 'fetchRecords', 'picklistValueQuery: ' + picklistValueQuery);

		try {
	        for(SObject s : Database.query(query)){
	            RecordsData recordsData = new RecordsData();
	            recordsData.value = String.valueOf(s.get('id'));
				recordsData.woNumber = String.valueOf(s.get('WorkOrderNumber'));
				recordsData.alias = String.valueOf(s.get('Plc_Alias__c'));
				recordsData.status = String.valueOf(s.get('Status'));
				recordsData.status2 = String.valueOf(s.get('WorkOrderNumber'));
				recordsData.legacyAccountId = String.valueOf(s.get('Plc_LegacyAccountId__c'));
				recordsData.legacyServicePointId = String.valueOf(s.get('Plc_LegacyServicePointId__c'));
				recordsData.servicepoint = String.valueOf(s.get('Plc_ServicePoint__c'));
				recordsData.sourceLegacySystem = String.valueOf(s.get('Plc_SourceLegacySystem__c'));
				recordsData.startDate = String.valueOf(s.get('StartDate'));
				recordsData.endDate = String.valueOf(s.get('EndDate'));
	            //recordsData.label = String.valueOf(s.get(filterField));
	            recordsDataList.add(recordsData);
	        }
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
		LogTracker.debugLogEnd(CLASS_NAME,'fetchRecords');
		return recordsDataList;
	}

    public class RecordsData{
        //@AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}
		@AuraEnabled public String woNumber {get;set;}
  		@AuraEnabled public String alias {get;set;}
  		@AuraEnabled public String status {get;set;}
 		@AuraEnabled public String status2 {get;set;}
 	 	@AuraEnabled public String legacyAccountId {get;set;}
 		@AuraEnabled public String legacyServicePointId {get;set;}
 		@AuraEnabled public String servicepoint {get;set;}
 		@AuraEnabled public String sourceLegacySystem {get;set;}
 		@AuraEnabled public String startDate {get;set;}
 		@AuraEnabled public String endDate {get;set;}
    }

}