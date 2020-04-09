/**
 * PLC Work Orders Rest WebService
 *
 * @author Emanuele Campese
 * @version 1.0
 * @description 
 * @testedIn Plc_WorkOrdersServicesTest
 * @errorcode [ERR:CL-00EYYZZ]
 * @history
 * 2019/02/06 Emanuele Campese
 */
public with sharing class Plc_WorkOrdersServices extends Plc_ServiceWs {

	@testVisible private static final String WORK_ORDER_LINE_ITEM_EXECUTED = 'Executed';
	@testVisible private static final String WORK_ORDER_LINE_ITEM_TOEXECUTE = 'ToExecute';
	private static final String CLASS_NAME = 'Plc_WorkOrdersServices';
	
	/**
	 * used to create Massive work orders and related work order line items
	 * @param  requestList list requests from payload
	 * @return             map that has the response code as key and a list of responsedata as values
	 * @code 01
	 */
	public static ServiceResponse workOrdersCreate(Plc_Wrappers.GestioneOrdineRequest requestList, String sourceExtSystem) {
		ServiceResponse serviceResponse = new ServiceResponse();
		return serviceResponse;
	}


	/**
	 * used to create On Time work orders and related work order line items
	 * @param  workOrder list requests from payload
	 * @return             map that has the response code as key and a list of responsedata as values
	 * @code 02
	 */
	public static ServiceResponse workOrdersCreate(Plc_Wrappers.GestioneOrdineRequestBody workOrder, String sourceExtSystem) {
		ServiceResponse serviceResponse = new ServiceResponse();
		
		//Execution times --- BEGIN --------
		Datetime beginExecutionStep2 = Datetime.now();
		Datetime beginExecutionStep1;
		Datetime endExecutionStep1;
		Integer executionTimeStep1 = 0;
		//Execution times --- END --------
		
		List<Plc_Wrappers.CreaEvadiOrdineResponseData> responseDataList = new List<Plc_Wrappers.CreaEvadiOrdineResponseData>();
		List<WorkOrderLineItem> workOrderLineItems = new List<WorkOrderLineItem>();
		List<String> resourceAliasList = new List<String>();
		List<String> warehouseAliasList = new List<String>();
		Set<String> reservationIdSet = new Set<String>();
		Map<Id,Plc_Reservation__c> reservationIdInSystem = new Map<Id,Plc_Reservation__c>();
		Map<String, Bit2Shop__Warehouse__c> warehouseOwnersMap = new Map<String, Bit2Shop__Warehouse__c>();
		Map<String,String> reservationInsertionMap = new Map<String,String>();
		Map<String,WorkOrder> workOrderInSystem = new Map<String,WorkOrder>();
		Bit2Shop__Warehouse__c warehouseIrrecuperable = new Bit2Shop__Warehouse__c();
		Map<String,Id> workOrderLineItemMap = new Map<String,Id>();
		Set<String> workOrderAlias = new Set<String>();
		Map<String,WorkOrderLineItem> woliProductParentWithId = new Map<String,WorkOrderLineItem>();
		Map<String,String> woliChildParentWithoutId = new Map<String,String>();
		Map<String, String> termIdsMap = retrieveTermIdCodes(new List<Plc_Wrappers.GestioneOrdineRequestBody>{workOrder});

		//get all resource aliases
		LogTracker.debugLogBegin(CLASS_NAME,'workOrdersCreate');

		warehouseAliasList.add(workOrder.workOrderDetail.warehouseAlias);

		beginExecutionStep1 = Datetime.now();
		Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap = getWorkOrderConfigurationMap();
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
			resourceAliasList.add(workOrderLineItem.workOrderLineItemDetail.resourceAlias);
			reservationIdSet.add(workOrderLineItem.workOrderLineItemDetail.reservationId);
			//Create a map with line item CHILD legacy id and its Parent
			woliChildParentWithoutId.put(workOrderLineItem.workOrderLineItemLegacyId,workOrderLineItem.workOrderLineItemDetail.parent);

			String woliKeyConfiguration =  workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
			if(!workOrderConfigurationMap.containsKey(woliKeyConfiguration)){
				return composeError(serviceResponse,'204','[ERR:CL-00E0598] WorkOrder: '+workOrder.workOrderLegacyId+' the configuration with requestType: '+workOrder.workOrderDetail.requestType.toUpperCase()+' and operationType: '+workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase()+' is not possible',executionTimeStep1,Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()));
			}
		}

		beginExecutionStep1 = Datetime.now();
		warehouseIrrecuperable = [SELECT Id,Bit2Shop__Dealer_Id__r.OwnerId FROM Bit2Shop__Warehouse__c WHERE Plc_Tipology__c='Irrecoverable' LIMIT 1];
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		workOrderAlias.add(workOrder.workOrderLegacyId);

		beginExecutionStep1 = Datetime.now();
		workOrderInSystem = retrieveWorkOrders(workOrderAlias);
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		beginExecutionStep1 = Datetime.now();
		reservationIdInSystem = Plc_ReservationsServices.retrieveReservation(reservationIdSet);
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		beginExecutionStep1 = Datetime.now();
		Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(resourceAliasList,warehouseAliasList);
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		beginExecutionStep1 = Datetime.now();
		warehouseOwnersMap = Plc_WsUtils.retriveWarehouseOwners(warehouseAliasList);
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 += Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		beginExecutionStep1 = Datetime.now();
		Map<String, B2WExtCat__External_Catalog_Item__c> resourceAliasMap = retrieveExternalCatalogItemObject(resourceAliasList);
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		Savepoint sp = Database.setSavepoint();

		if(workOrderInSystem.containsKey(workOrder.workOrderLegacyId)){
			serviceResponse.outcomeCode = '602';
			serviceResponse.outcomeMessage = '[ERR:CL-00E099] : Work order with alias '+workOrder.workOrderLegacyId+' already in system';
			serviceResponse.executionTimeStep1 = executionTimeStep1; 
			serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
			Database.rollback(sp);
			return serviceResponse;
		}
		//get all resource aliases
		Map<String, Plc_Reservation__c> reservationsToInsert = new Map<String, Plc_Reservation__c>();
		Boolean needOwnerIdIrrecuberable = false;
		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem) {
			// check if the there is resource in ECI

			if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToDeactivate'){
				needOwnerIdIrrecuberable = true;
			}
			if(workOrderLineItem.workOrderLineItemDetail.operationType!='ToDeactivate'){
				if(String.isBlank(workOrder.workOrderDetail.warehouseAlias)){
					serviceResponse.outcomeCode = '602';
					serviceResponse.outcomeMessage = '[ERR:CL-00E0100] : warehouseAlias is blank or null';
					serviceResponse.executionTimeStep1 = executionTimeStep1; 
					serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
					Database.rollback(sp);
					return serviceResponse;
				}
				if(!warehouseOwnersMap.containsKey(workOrder.workOrderDetail.warehouseAlias)){
					serviceResponse.outcomeCode = '602';
					serviceResponse.outcomeMessage = '[ERR:CL-00E0102] Cannot finish operation because warehouse doesnt exist.';
					serviceResponse.executionTimeStep1 = executionTimeStep1; 
					serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
					Database.rollback(sp);
					return serviceResponse;
				}
			}
			if(!resourceAliasMap.containsKey(workOrderLineItem.workOrderLineItemDetail.resourceAlias)){
				serviceResponse.outcomeCode = '602';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0101] ResourceAlias: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.resourceAlias).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId );
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				Database.rollback(sp);
				return serviceResponse;
			}
			
			

			String workOrderConfigurationKey = workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
			if(!workOrderConfigurationMap.containsKey(workOrderConfigurationKey)){

				serviceResponse.outcomeCode = '202';serviceResponse.outcomeMessage = '[ERR:CL-00E0103] Values for requestType and operationType of line item with alias: ' + workOrderLineItem.workOrderLineItemLegacyId + ' are not managed';serviceResponse.executionTimeStep1 = executionTimeStep1; serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				return serviceResponse;
			}
			
			if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){

				if(sourceExtSystem == 'WSICT'){

					// Check if there is a product in the Warehouse
					if (productStockMap.containsKey(workOrderLineItem.workOrderLineItemDetail.resourceAlias +
													 workOrder.workOrderDetail.warehouseAlias)) {

						if(productStockMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias +
												 workOrder.workOrderDetail.warehouseAlias).Plc_AvailableQty__c > 0){
							Plc_Reservation__c tempReservationRequest = new Plc_Reservation__c();
							tempReservationRequest.Plc_Status__c  = 'Reserved';
							tempReservationRequest.Plc_ProductStock__c = productStockMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias +
																						 workOrder.workOrderDetail.warehouseAlias).Id;
							tempReservationRequest.Plc_SourceLegacySystem__c = sourceExtSystem;
							reservationsToInsert.put(workOrderLineItem.workOrderLineItemLegacyId,tempReservationRequest);
						} else {
							serviceResponse.outcomeCode = '202';LogTracker.debugLogBegin(CLASS_NAME,'workOrdersCreate','Product not available');serviceResponse.outcomeMessage = '[ERR:CL-00E0104] Product '+workOrderLineItem.workOrderLineItemDetail.resourceAlias+' Not Available in WareHouse '+workOrder.workOrderDetail.warehouseAlias+' For Item '+workOrderLineItem.workOrderLineItemLegacyId ;serviceResponse.executionTimeStep1 = executionTimeStep1;serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
						}

					} else {
						LogTracker.debugLogBegin(CLASS_NAME,'workOrdersCreate','Product does not exist in the system');
						serviceResponse.outcomeCode = '202';
						serviceResponse.outcomeMessage = '[ERR:CL-00E0105] Product ('+workOrderLineItem.workOrderLineItemDetail.resourceAlias+') in warehouse ('+workOrder.workOrderDetail.warehouseAlias+') for Item '+workOrderLineItem.workOrderLineItemLegacyId+' does not exist in the system.';
						serviceResponse.executionTimeStep1 = executionTimeStep1; 
						serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
						return serviceResponse;
					}

				} else {
					// sourceExtSystem Monetica
					if(workOrderLineItem.workOrderLineItemDetail.operationType !='ToRemove' && workOrderLineItem.workOrderLineItemDetail.operationType !='ToDeactivate'){
						 system.debug('==reservationIdSystemmm=='+reservationIdInSystem);
						 system.debug('==workOrderLineItemmm=='+workOrderLineItem.workOrderLineItemDetail);
						if(!reservationIdInSystem.containsKey(workOrderLineItem.workOrderLineItemDetail.reservationId)){
							serviceResponse.outcomeCode = '602';
							serviceResponse.outcomeMessage = '[ERR:CL-00E0106] ReservationId: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.reservationId).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId);
							serviceResponse.executionTimeStep1 = executionTimeStep1; 
							serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
						}
					}
				}
			}
		}
		if(!reservationsToInsert.isEmpty()){
			reservationInsertionMap = Plc_ReservationsServices.upsertReservations(reservationsToInsert);
		}

		

		try {
			//Create work orders and related line items
			WorkOrder newWorkOrder = new WorkOrder();
			try {
				newWorkOrder.RecordTypeId = Plc_Utils.getRecordTypeId(workOrder.workOrderDetail.requestType,'WorkOrder');
			} catch(Exception ex) {
				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0107] ' + Label.Plc_ApexClassWorkOrdersServicesInvalidRequestType;
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				Database.rollback(sp);
				return serviceResponse;
			}
			newWorkOrder.Status = workOrder.workOrderDetail.status;
			try {
				if(String.isNotBlank(workOrder.workOrderDetail.startDate)) {
					newWorkOrder.StartDate = DateTime.valueOfGmt(workOrder.workOrderDetail.startDate.replace('T', ' '));
				}
				//if(String.isNotBlank(workOrder.workOrderDetail.endDate)) {
				//    newWorkOrder.EndDate = DateTime.valueOfGmt(workOrder.workOrderDetail.endDate.replace('T', ' '));
				//}
			} catch(Exception ex) {
				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0108] ' + ex.getMessage();
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				Database.rollback(sp);
				return serviceResponse;
			}
			newWorkOrder.Plc_LegacyWarehouseId__c = workOrder.workOrderDetail.warehouseAlias;
			newWorkOrder.Plc_Abi__c = workOrder.workOrderDetail.abi;
			newWorkOrder.Plc_BankDescription__c = workOrder.workOrderDetail.bankDescription;
			newWorkOrder.Plc_ServicePoint__c = workOrder.workOrderDetail.businessName;
			newWorkOrder.Plc_LegacyServicePointId__c = workOrder.workOrderDetail.shopLegacyId;
			newWorkOrder.Plc_Vat__c = workOrder.workOrderDetail.vatNumber;
			newWorkOrder.Plc_FiscalCode__c = workOrder.workOrderDetail.fiscalCode;
			newWorkOrder.Plc_SiaCode__c = workOrder.workOrderDetail.siaCode;
			newWorkOrder.Plc_LegacyAccountId__c = workOrder.workOrderDetail.accountLegacyId;
			newWorkOrder.Street = workOrder.workOrderDetail.address;
			newWorkOrder.PostalCode = workOrder.workOrderDetail.postalCode;
			newWorkOrder.City = workOrder.workOrderDetail.locality;
			newWorkOrder.State = workOrder.workOrderDetail.province;
			newWorkOrder.Plc_Prefix__c = workOrder.workOrderDetail.prefix;
			newWorkOrder.Plc_Phone__c = workOrder.workOrderDetail.phone;
			newWorkOrder.Plc_Email__c = workOrder.workOrderDetail.mail;
			newWorkOrder.Plc_Cti__c = workOrder.workOrderDetail.cti;
			newWorkOrder.Plc_CustomerCare__c = workOrder.workOrderDetail.supportPhoneNumber;
			newWorkOrder.Plc_OpeingHours__c = workOrder.workOrderDetail.openingTime;
			newWorkOrder.Plc_Contact__c = workOrder.workOrderDetail.referent;
			newWorkOrder.Plc_Note__c = workOrder.workOrderDetail.notes;
			newWorkOrder.Plc_Alias__c = workOrder.workOrderLegacyId;
			newWorkOrder.Plc_SourceLegacySystem__c = sourceExtSystem;

			if(needOwnerIdIrrecuberable==false){
				 newWorkOrder.OwnerId = warehouseOwnersMap.get(workOrder.workOrderDetail.warehouseAlias).Bit2Shop__Dealer_Id__r.OwnerId;
				 newWorkOrder.Plc_WarehouseName__c = warehouseOwnersMap.get(workOrder.workOrderDetail.warehouseAlias).Name;
			}
			else{
				newWorkOrder.OwnerId = warehouseIrrecuperable.Bit2Shop__Dealer_Id__r.OwnerId;
			}

			try{
				
				insert newWorkOrder;
			
			} catch (Exception ex){

				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0109] ' + ex.getMessage();
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', 'Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());
				Database.rollback(sp);
				return serviceResponse;
			}

			for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem) {
				WorkOrderLineItem newWorkOrderLineItem = new WorkOrderLineItem();
				newWorkOrderLineItem.Plc_OperationType__c = workOrderLineItem.workOrderLineItemDetail.operationType;
				newWorkOrderLineItem.Status = workOrderLineItem.workOrderLineItemDetail.status;
				newWorkOrderLineItem.Plc_BundleId__c = workOrderLineItem.workOrderLineItemDetail.bundleId;
				newWorkOrderLineItem.Plc_ExternalTermId__c = workOrderLineItem.workOrderLineItemDetail.termId;

				if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.resourceAlias)){
					newWorkOrderLineItem.Plc_ReferenceExternalCatalogItem__c = workOrderLineItem.workOrderLineItemDetail.resourceAlias;
					newWorkOrderLineItem.Plc_ExternalCatalogItem__c = resourceAliasMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Id;
				}
				
				if(workOrderLineItem.workOrderLineItemDetail.operationType!='ToReconfigureCorr'){
					newWorkOrderLineItem.Plc_SerialNumber__c = workOrderLineItem.workOrderLineItemDetail.serialNumber;
				}
				
				//<-- 

				if(resourceAliasMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Category__c == 'Product'){
					woliProductParentWithId.put(workOrderLineItem.workOrderLineItemLegacyId,newWorkOrderLineItem);
				}
				//<--
				newWorkOrderLineItem.WorkOrderId = newWorkOrder.id;
				

				String workOrderConfigurationKey = '' + workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();

				if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c) {
					if(sourceExtSystem == 'WSICT'){
						if(reservationInsertionMap.get(workOrderLineItem.workOrderLineItemLegacyId) instanceOf id) {
							newWorkOrderLineItem.Plc_Reservation__c = reservationInsertionMap.get(workOrderLineItem.workOrderLineItemLegacyId);
						} else {
							serviceResponse.outcomeCode = '202';	serviceResponse.outcomeMessage = '[ERR:CL-00E0110] ' + reservationInsertionMap.get(workOrderLineItem.workOrderLineItemLegacyId);serviceResponse.executionTimeStep1 = executionTimeStep1;serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							Database.rollback(sp);
							return serviceResponse;
						}
					} else {
						// sourceExtSystem Monetica
						if(workOrderLineItem.workOrderLineItemDetail.reservationId instanceOf Id){
							newWorkOrderLineItem.Plc_Reservation__c = workOrderLineItem.workOrderLineItemDetail.reservationId;
						} else {
							serviceResponse.outcomeCode = '602';serviceResponse.outcomeMessage = '[ERR:CL-00E0111] ' + Label.Plc_ApexClassWorkOrdersServicesInvalidValueReservationId;serviceResponse.executionTimeStep1 = executionTimeStep1; serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							Database.rollback(sp);
							return serviceResponse;
						}
					}
				}
				
				try {

					newWorkOrderLineItem.Plc_LegacyCreatedDate__c = DateTime.valueOfGmt(workOrderLineItem.workOrderLineItemDetail.generationDate.replace('T', ' '));

				} catch(Exception ex) {

					serviceResponse.outcomeCode = '603';
					serviceResponse.outcomeMessage = '[ERR:CL-00E0112] ' + ex.getMessage();
					serviceResponse.executionTimeStep1 = executionTimeStep1; 
					serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
					Database.rollback(sp); 
					return serviceResponse;
				}
				newWorkOrderLineItem.Plc_Note__c = workOrderLineItem.workOrderLineItemDetail.notes;
				newWorkOrderLineItem.Plc_Alias__c = workOrderLineItem.workOrderLineItemLegacyId;
				workOrderLineItems.add(newWorkOrderLineItem);
			}

			try{
				if(workOrderLineItems.size()>0){
					
						insert workOrderLineItems;
						//Attach the parent to woli child

						for(WorkOrderLineItem workOrderLineItemTemp : workOrderLineItems){
							if(String.isNotBlank(woliChildParentWithoutId.get(workOrderLineItemTemp.Plc_Alias__c)) ){
									workOrderLineItemTemp.Plc_Parent__c = woliProductParentWithId.get(woliChildParentWithoutId.get(workOrderLineItemTemp.Plc_Alias__c)).Id;
									workOrderLineItemTemp.ParentWorkOrderLineItemId = woliProductParentWithId.get(woliChildParentWithoutId.get(workOrderLineItemTemp.Plc_Alias__c)).Id;
							}
						}
						update workOrderLineItems;
						
				}
				

				
				
			} catch (Exception ex){

				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0113] ' + ex.getMessage();
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', 'Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());
				Database.rollback(sp);
				return serviceResponse;
			}
			
			//composes responseData
			Plc_Wrappers.CreaEvadiOrdineResponseData responseData = new Plc_Wrappers.CreaEvadiOrdineResponseData();
			responseData.workOrderId = newWorkOrder.Id;
			responseData.workOrderLegacyId = workOrder.workOrderLegacyId;
			responseData.created = true;
			responseData.outcomeMessage = null;
			responseDataList.add(responseData);
			
			serviceResponse.contextLink = '/lightning/r/WorkOrder/' + newWorkOrder.Id + '/view';
			//FB 19-06-2019: NEXIPLC-641 [START]
			serviceResponse.recordId = newWorkOrder.Id;
			//FB 19-06-2019: NEXIPLC-641 [END]
			serviceResponse.outcomeCode = '200';
			serviceResponse.responseDataList = responseDataList;
			serviceResponse.executionTimeStep1 = executionTimeStep1; 
			serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());

			LogTracker.debugLogEnd(CLASS_NAME,'workOrdersCreate');
			return serviceResponse;
		} catch (Exception ex){

			serviceResponse.outcomeCode = '603';serviceResponse.executionTimeStep1 = executionTimeStep1; serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', '[ERR:CL-00E0114] Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());
			Database.rollback(sp);
			return serviceResponse;
		}
		
	}

	/**
	 * used to update Massive work orders and related work order line items
	 * @param  requestList list requests from payload
	 * @return             map that has the response code as key and a list of responsedata as values
	 * @code 03
	 */
	public static ServiceResponse workOrdersUpdate(Plc_Wrappers.GestioneOrdineRequest requestList, String sourceExtSystem){
		ServiceResponse serviceResponse = new ServiceResponse();
		return serviceResponse;
	}

	/**
	 * used to update On Time work orders and related work order line items
	 * @param  workOrder list requests from payload
	 * @return             map that has the response code as key and a list of responsedata as values
	 * @code 04
	 */
	public static ServiceResponse workOrdersUpdate(Plc_Wrappers.GestioneOrdineRequestBody workOrder, String sourceExtSystem){
		ServiceResponse serviceResponse = new ServiceResponse();
		List<Plc_Wrappers.AggiornaOrdineResponseData> responseDataList = new List<Plc_Wrappers.AggiornaOrdineResponseData>();
		List<WorkOrderLineItem> workOrderLineItems = new List<WorkOrderLineItem>();
		Set<String> workOrderAlias = new Set<String>();
		Map<String, WorkOrderLineItem> workOrderLineItemsToUpdate = new Map<String, WorkOrderLineItem>();
		List<String> resourceAliasList = new List<String>();
		Datetime beginExecutionStep1 = Datetime.now();
		Datetime endExecutionStep1 = Datetime.now();
		Integer executionTimeStep1 = 0;
		Integer executionTimeStep2 = 0;
		Datetime endExecutionStep2 = Datetime.now();
		Datetime beginExecutionStep2 = Datetime.now();
		Map<String,String> reservationInsertionMap = new Map<String,String>();
		List<String> resourceAliasSet = new List<String>();
		List<String> warehouseAliasList = new List<String>();
		Map<Id,Plc_Reservation__c> reservationToUpdate = new  Map<Id,Plc_Reservation__c>();
		Set<String> reservationIdSet = new Set<String>();
		List<Plc_Reservation__c> reservationToDeactivateList = new List<Plc_Reservation__c>();
		Map<String, WorkOrderLineItem> workOrderLineItemMap = new Map<String, WorkOrderLineItem>();
		Map<String, String> termIdsMap = retrieveTermIdCodes(new List<Plc_Wrappers.GestioneOrdineRequestBody>{workOrder});

		//get all resource aliases
		LogTracker.debugLogBegin(CLASS_NAME,'workOrdersUpdate SINGLE');

		Savepoint sp = Database.setSavepoint();
		warehouseAliasList.add(workOrder.workOrderDetail.warehouseAlias);
		workOrderAlias.add(workOrder.workOrderLegacyId);


		Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap = getWorkOrderConfigurationMap();

		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
			resourceAliasList.add(workOrderLineItem.workOrderLineItemDetail.resourceAlias);

			String woliKeyConfiguration =  workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
			if(!workOrderConfigurationMap.containsKey(woliKeyConfiguration)){
				serviceResponse.outcomeCode = '204';serviceResponse.outcomeMessage = '[ERR:CL-00E0598] WorkOrder: '+workOrder.workOrderLegacyId+' the configuration with requestType: '+workOrder.workOrderDetail.requestType.toUpperCase()+' and operationType: '+workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase()+' is not possible';serviceResponse.executionTimeStep1 = executionTimeStep1; LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T003]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				return serviceResponse;
			}
		}

		beginExecutionStep1 = Datetime.now();
		Map<String, WorkOrder> workOrdersToUpdate = retrieveWorkOrders(workOrderAlias);
		Map<String, B2WExtCat__External_Catalog_Item__c> resourceAliasMap = retrieveExternalCatalogItemObject(resourceAliasList);
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
		
		if(workOrdersToUpdate.isEmpty()){

			serviceResponse.outcomeCode = '204';
			serviceResponse.executionTimeStep1 = executionTimeStep1; 
			serviceResponse.executionTimeStep2 = executionTimeStep2; 
			return serviceResponse;
		}

		beginExecutionStep1 = Datetime.now();
		Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(resourceAliasList,warehouseAliasList);
		endExecutionStep1 = Datetime.now();
		//get all resource aliases
		Map<String, Plc_Reservation__c> reservationToUpsert = new Map<String, Plc_Reservation__c>();

		for(WorkOrderLineItem workOrderLineItem : workOrdersToUpdate.get(workOrder.workOrderLegacyId).workOrderLineItems){

			workOrderLineItemMap.put(workOrderLineItem.Plc_Alias__c, workOrderLineItem);
			reservationIdSet.add(workOrderLineItem.Plc_Reservation__c);

		}

		reservationToUpdate = Plc_ReservationsServices.retrieveReservation(reservationIdSet);

		Boolean needProductStockChange;
		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){

			needProductStockChange=false;
			String workOrderConfigurationKey = '' + workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
			if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){
				
				if(workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
					//potrei inserire qui la condizione per poter controllare se i PRODUCTSKU sono uguali
					// se sono uguali fai
					String productSkuChangeToCheck = '';

					if(workOrderLineItem.workOrderLineItemDetail.operationType == 'ToSubstituteCorr'){
						if(sourceExtSystem=='MONETICA'){
							productSkuChangeToCheck = reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c;
							
							if(workOrderLineItem.workOrderLineItemDetail.resourceAlias==productSkuChangeToCheck){
								continue;
							}else{
								needProductStockChange = true;
							}
						}

					}else{
						productSkuChangeToCheck = reservationToUpdate.get(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Reservation__c).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c ;
						if(workOrderLineItem.workOrderLineItemDetail.resourceAlias==productSkuChangeToCheck){
							continue;
						}else{
							needProductStockChange = true;
						}
					}
					//else -> metti in not reserved la reservation recuperata da reservationToUpdate aggiungendola a reservationToDeactivateList e fagli fare la creazione della reservation
				}
				if (productStockMap.containsKey('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias +
													workOrder.workOrderDetail.warehouseAlias)) {
                                                        
					Plc_Reservation__c tempReservationRequest = new Plc_Reservation__c();
					if(productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Plc_AvailableQty__c > 0){
						tempReservationRequest = new Plc_Reservation__c();
                        
						if(needProductStockChange==false){
							tempReservationRequest.Plc_Status__c  = 'Reserved';
							tempReservationRequest.Plc_ProductStock__c = productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Id;
							tempReservationRequest.Plc_SourceLegacySystem__c = sourceExtSystem;
							reservationToUpsert.put('' + workOrderLineItem.workOrderLineItemLegacyId,tempReservationRequest);
						}else{
							//if the Solution of the product on the reservation is the same of the product that it's trying to change 
							if(reservationToUpdate.get(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Reservation__c).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c == productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c ){
								tempReservationRequest = reservationToUpdate.get(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Reservation__c);
								tempReservationRequest.Plc_ProductStock__c = productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Id;
								tempReservationRequest.Plc_SourceLegacySystem__c = sourceExtSystem;
								reservationToUpsert.put('' + workOrderLineItem.workOrderLineItemLegacyId,tempReservationRequest);
							}
							else{
								serviceResponse.outcomeCode = '202';serviceResponse.outcomeMessage = 'The Solution of the product in Work Order Line Item and the Solution of the product in Reservation do not match';serviceResponse.responseDataList = responseDataList;serviceResponse.executionTimeStep1 = executionTimeStep1; serviceResponse.executionTimeStep2 = executionTimeStep2;
								Database.rollback(sp);
								return serviceResponse;
							}
						}
						//Altrimenti controlla se è un unlock dell'ordine e processalo nel modo corretto
					}else if(workOrder.workOrderDetail.status=='Assigned' && (workOrderLineItem.workOrderLineItemDetail.operationType=='ToInstall'||workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstitute' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstituteCorr') && workOrderLineItem.workOrderLineItemDetail.status=='ToExecute' && workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
						tempReservationRequest = new Plc_Reservation__c();
                        
						Map<String, Bit2Shop__Product_Stock__c> productStockMapCompatible = Plc_WsUtils.retrieveProductStocksCompatible(workOrderLineItem.workOrderLineItemDetail.resourceAlias,workOrder.workOrderDetail.warehouseAlias);
						if(productStockMapCompatible.size()>0){
							tempReservationRequest = reservationToUpdate.get(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Reservation__c);
							tempReservationRequest.Plc_ProductStock__c = productStockMapCompatible.get(workOrder.workOrderDetail.warehouseAlias).Id;
							tempReservationRequest.Plc_SourceLegacySystem__c = sourceExtSystem;
							reservationToUpsert.put('' + workOrderLineItem.workOrderLineItemLegacyId,tempReservationRequest);
						}else{
							serviceResponse.outcomeCode = '202';serviceResponse.outcomeMessage = Label.Plc_ApexClassWorkOrdersServicesProductNotAvailableForLineItem + workOrderLineItem.workOrderLineItemLegacyId;serviceResponse.responseDataList = responseDataList;serviceResponse.executionTimeStep1 = executionTimeStep1; serviceResponse.executionTimeStep2 = executionTimeStep2;
							Database.rollback(sp);
							return serviceResponse;
						}
					}else if (workOrder.workOrderDetail.status!='OnHold' && workOrderLineItem.workOrderLineItemDetail.status!='NotExecuted') {
						serviceResponse.outcomeCode = '202';
						serviceResponse.outcomeMessage = Label.Plc_ApexClassWorkOrdersServicesProductNotAvailableForLineItem + workOrderLineItem.workOrderLineItemLegacyId;
						serviceResponse.responseDataList = responseDataList;
						serviceResponse.executionTimeStep1 = executionTimeStep1; 
						serviceResponse.executionTimeStep2 = executionTimeStep2;
						Database.rollback(sp);
						return serviceResponse;
					}
					
				} else {
					serviceResponse.outcomeCode = '202';
					serviceResponse.outcomeMessage = 'Product does not exist in the system.';
					serviceResponse.responseDataList = responseDataList;
					serviceResponse.executionTimeStep1 = executionTimeStep1; 
					serviceResponse.executionTimeStep2 = executionTimeStep2;
					Database.rollback(sp);
					return serviceResponse;
				}
			}
		}
		if(!reservationToUpsert.isEmpty()){
			beginExecutionStep2 = Datetime.now();
			reservationInsertionMap = Plc_ReservationsServices.upsertReservations(reservationToUpsert);
			reservationIdSet.addAll(reservationInsertionMap.keySet());
			reservationToUpdate = Plc_ReservationsServices.retrieveReservation(reservationIdSet);
			endExecutionStep2 = Datetime.now();
			executionTimeStep2 +=  Integer.valueOf(((endExecutionStep2.getTime() - beginExecutionStep2.getTime())));
		}


		try{
			//Create work orders and related line items

			WorkOrder workOrderToUpdate = workOrdersToUpdate.get(workOrder.workOrderLegacyId);
			try{

				workOrderToUpdate.RecordTypeId = Plc_Utils.getRecordTypeId(workOrder.workOrderDetail.requestType,'WorkOrder');
			}catch(Exception ex){
				serviceResponse.outcomeCode = '602';
				serviceResponse.outcomeMessage = Label.Plc_ApexClassWorkOrdersServicesInvalidRequestType;
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = executionTimeStep2;
				Database.rollback(sp);
				return serviceResponse;
			}
			workOrderToUpdate.Status = workOrder.workOrderDetail.status;
			try{
				
				if(String.isNotBlank(workOrder.workOrderDetail.startDate)){

					workOrderToUpdate.StartDate = DateTime.valueOfGmt(workOrder.workOrderDetail.startDate.replace('T', ' '));
				}
				if(String.isNotBlank(workOrder.workOrderDetail.endDate)){

					workOrderToUpdate.EndDate = DateTime.valueOfGmt(workOrder.workOrderDetail.endDate.replace('T', ' '));
				}
			}catch(Exception ex){

				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = ex.getMessage();
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = executionTimeStep2;
				Database.rollback(sp);
				return serviceResponse;
			}
			workOrderToUpdate.Plc_LegacyWarehouseId__c = workOrder.workOrderDetail.warehouseAlias;
			workOrderToUpdate.Plc_Abi__c = workOrder.workOrderDetail.abi;
			workOrderToUpdate.Plc_BankDescription__c = workOrder.workOrderDetail.bankDescription;
			workOrderToUpdate.Plc_ServicePoint__c = workOrder.workOrderDetail.businessName;
			workOrderToUpdate.Plc_LegacyServicePointId__c = workOrder.workOrderDetail.shopLegacyId;
			workOrderToUpdate.Plc_Vat__c = workOrder.workOrderDetail.vatNumber;
			workOrderToUpdate.Plc_FiscalCode__c = workOrder.workOrderDetail.fiscalCode;
			workOrderToUpdate.Plc_SiaCode__c = workOrder.workOrderDetail.siaCode;
			workOrderToUpdate.Plc_LegacyAccountId__c = workOrder.workOrderDetail.accountLegacyId;
			workOrderToUpdate.Street = workOrder.workOrderDetail.address;
			workOrderToUpdate.PostalCode = workOrder.workOrderDetail.postalCode;
			workOrderToUpdate.City = workOrder.workOrderDetail.locality;
			workOrderToUpdate.State = workOrder.workOrderDetail.province;
			workOrderToUpdate.Plc_Prefix__c = workOrder.workOrderDetail.prefix;
			workOrderToUpdate.Plc_Phone__c = workOrder.workOrderDetail.phone;
			workOrderToUpdate.Plc_Email__c = workOrder.workOrderDetail.mail;
			workOrderToUpdate.Plc_Cti__c = workOrder.workOrderDetail.cti;
			workOrderToUpdate.Plc_CustomerCare__c = workOrder.workOrderDetail.supportPhoneNumber;
			workOrderToUpdate.Plc_OpeingHours__c = workOrder.workOrderDetail.openingTime;
			workOrderToUpdate.Plc_Contact__c = workOrder.workOrderDetail.referent;
			workOrderToUpdate.Plc_Note__c = workOrder.workOrderDetail.notes;
			workOrderToUpdate.Plc_Alias__c = workOrder.workOrderLegacyId;
			workOrderToUpdate.Plc_SourceLegacySystem__c = sourceExtSystem;
			for(WorkOrderLineItem workOrderLineItem : workOrderToUpdate.workOrderLineItems){

				workOrderLineItemsToUpdate.put(workOrderLineItem.Plc_Alias__c, workOrderLineItem);
			}
			for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){

				String payloadKey = '' + workOrderLineItem.workOrderLineItemDetail.resourceAlias +
											  workOrder.workOrderDetail.warehouseAlias;
				WorkOrderLineItem workOrderLineItemToUpsert = new WorkOrderLineItem();
				if(workOrderLineItemsToUpdate.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){

					workOrderLineItemToUpsert = workOrderLineItemsToUpdate.get(workOrderLineItem.workOrderLineItemLegacyId);
				}

				workOrderLineItemToUpsert.Plc_OperationType__c = workOrderLineItem.workOrderLineItemDetail.operationType;
				workOrderLineItemToUpsert.Status = workOrderLineItem.workOrderLineItemDetail.status;
				workOrderLineItemToUpsert.Plc_BundleId__c = workOrderLineItem.workOrderLineItemDetail.bundleId;
				workOrderLineItemToUpsert.Plc_ExternalTermId__c = workOrderLineItem.workOrderLineItemDetail.termId;
				workOrderLineItemToUpsert.Plc_ReferenceExternalCatalogItem__c = workOrderLineItem.workOrderLineItemDetail.resourceAlias;
				if(workOrderLineItem.workOrderLineItemDetail.operationType!='ToReconfigureCorr'){
					workOrderLineItemToUpsert.Plc_SerialNumber__c = workOrderLineItem.workOrderLineItemDetail.serialNumber;
				}
				//<--
				String workOrderConfigurationKey = '' + workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
				
				if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){
					if(reservationInsertionMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
						workOrderLineItemToUpsert.Plc_Reservation__c = reservationInsertionMap.get(workOrderLineItem.workOrderLineItemLegacyId);
					}else if (sourceExtSystem == 'MONETICA'){
						workOrderLineItemToUpsert.Plc_Reservation__c = workOrderLineItem.workOrderLineItemDetail.reservationId;
					}
					// Deactivate or Activate the reservation if it is in System
					if(workOrder.workOrderDetail.status=='OnHold'||workOrder.workOrderDetail.status=='Canceled'){
						if(workOrderLineItem.workOrderLineItemDetail.status=='NotExecuted'){
							Plc_Reservation__c tempReservationToDeactivate = new Plc_Reservation__c();
							tempReservationToDeactivate = reservationToUpdate.get(workOrderLineItemToUpsert.Plc_Reservation__c);
							tempReservationToDeactivate.Plc_Status__c= 'NotReserved';
							reservationToDeactivateList.add(tempReservationToDeactivate);
						}
					}
					else if(workOrder.workOrderDetail.status=='Assigned'){
						if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToInstall'||workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstitute' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstituteCorr'){
						//<--
							if(workOrderLineItem.workOrderLineItemDetail.status=='ToExecute'){
								Plc_Reservation__c tempReservationToDeactivate = new Plc_Reservation__c();
								if(reservationToUpdate.containsKey(workOrderLineItemToUpsert.Plc_Reservation__c) ){

									tempReservationToDeactivate = reservationToUpdate.get(workOrderLineItemToUpsert.Plc_Reservation__c);
									
									if(tempReservationToDeactivate.Plc_ProductStock__r.Plc_AvailableQty__c>0){
										tempReservationToDeactivate.Plc_Status__c= 'Reserved';
										reservationToDeactivateList.add(tempReservationToDeactivate);
									}else{
										Map<String, Bit2Shop__Product_Stock__c> productStockMapCompatible = Plc_WsUtils.retrieveProductStocksCompatible(workOrderLineItem.workOrderLineItemDetail.resourceAlias,workOrder.workOrderDetail.warehouseAlias);
										if(productStockMapCompatible.size()>0){
											tempReservationToDeactivate.Plc_Status__c= 'Reserved';
											tempReservationToDeactivate.Plc_ProductStock__c=productStockMapCompatible.get(workOrder.workOrderDetail.warehouseAlias).Id;
											workOrderLineItemToUpsert.Plc_ExternalCatalogItem__c = productStockMapCompatible.get(workOrder.workOrderDetail.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__c;
											reservationToDeactivateList.add(tempReservationToDeactivate);
										}else{
											serviceResponse.outcomeCode = '202';serviceResponse.outcomeMessage = Label.Plc_ApexClassWorkOrdersServicesProductNotAvailableForLineItem + workOrderLineItem.workOrderLineItemLegacyId;serviceResponse.executionTimeStep1 = executionTimeStep1; serviceResponse.executionTimeStep2 = executionTimeStep2; 
											return serviceResponse;
										}
										
									}
								}
							}
						}
					}
						
				}
					
				
				
				if(resourceAliasMap.containsKey(workOrderLineItem.workOrderLineItemDetail.resourceAlias)){
						workOrderLineItemToUpsert.Plc_ExternalCatalogItem__c = resourceAliasMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Id;
				}
				else{
							serviceResponse.outcomeCode = '602';serviceResponse.outcomeMessage = 'ResourceAlias: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.resourceAlias).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId );serviceResponse.executionTimeStep1 = executionTimeStep1; serviceResponse.executionTimeStep2 = executionTimeStep2;
							Database.rollback(sp); 
							return serviceResponse;
				}
				
				

				try{

					workOrderLineItemToUpsert.Plc_LegacyCreatedDate__c = DateTime.valueOfGmt(workOrderLineItem.workOrderLineItemDetail.generationDate.replace('T', ' '));
				}catch(Exception ex){

					serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = ex.getMessage();serviceResponse.executionTimeStep1 = executionTimeStep1;serviceResponse.executionTimeStep2 = executionTimeStep2;
					Database.rollback(sp); 
					return serviceResponse;
				}
				workOrderLineItemToUpsert.Plc_Note__c = workOrderLineItem.workOrderLineItemDetail.notes;
				workOrderLineItemToUpsert.Plc_Alias__c = workOrderLineItem.workOrderLineItemLegacyId;
				workOrderLineItems.add(workOrderLineItemToUpsert);
			}

			try {

				for(WorkOrderLineItem workOrderLineItem : workOrderLineItems){

					if(workOrderLineItem.id == null){
						workOrderLineItem.WorkOrderId = workOrderToUpdate.id;
					}
				}

				upsert workOrderLineItems;
				endExecutionStep2 = Datetime.now();
				executionTimeStep2 +=  Integer.valueOf(((endExecutionStep2.getTime() - beginExecutionStep2.getTime())));

				if(reservationToDeactivateList.size()>0){
				   update reservationToDeactivateList;
				}

				update workOrderToUpdate;

			} catch (Exception ex){

				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = ex.getMessage();
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				serviceResponse.executionTimeStep2 = executionTimeStep2;
				LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', 'Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());
				Database.rollback(sp);
				return serviceResponse;
			}
			//composes responseData
			Plc_Wrappers.AggiornaOrdineResponseData responseData = new Plc_Wrappers.AggiornaOrdineResponseData();
			responseData.workOrderId = workOrderToUpdate.Id;
			responseData.workOrderLegacyId = workOrder.workOrderLegacyId;
			responseData.updated = true;
			responseData.outcomeMessage = null;
			responseDataList.add(responseData);
			
			serviceResponse.contextLink = '/lightning/r/WorkOrder/' + workOrderToUpdate.Id + '/view';
			//FB 19-06-2019: NEXIPLC-641 [START]
			serviceResponse.recordId = workOrderToUpdate.Id;
			//FB 19-06-2019: NEXIPLC-641 [END]
			serviceResponse.outcomeCode = '200';
			serviceResponse.responseDataList = responseDataList;
			serviceResponse.executionTimeStep1 = executionTimeStep1; 
			serviceResponse.executionTimeStep2 = executionTimeStep2; 
			LogTracker.debugLogEnd(CLASS_NAME,'workOrdersUpdate SINGLE');
			return serviceResponse;
		} catch (Exception ex){					
			LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', 'Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());
			Database.rollback(sp);
			return composeError(serviceResponse, '603', ex.getMessage(), executionTimeStep1, executionTimeStep2);
		}
		
	}

	/**
	 * used to fulfillment Massive work orders and related work order line items
	 * @param  requestList list requests from payload
	 * @return             map that has the response code as key and a list of responsedata as values
	 * @code 05
	 */
	public static ServiceResponse workOrdersFullfilment(Plc_Wrappers.GestioneOrdineRequest requestList, String sourceExtSystem){
		ServiceResponse serviceResponse = new ServiceResponse();
		return serviceResponse;
	}


	/**
	 * used to fulFillment work orders and related work order line items
	 * @param  workOrder list requests from payload
	 * @return             map that has the response code as key and a list of responsedata as values
	 * @code 06
	 */
	public static ServiceResponse workOrdersFullfilment(Plc_Wrappers.GestioneOrdineRequestBody workOrder, String sourceExtSystem){
		Datetime beginExecutionStep2 = Datetime.now();
		Datetime beginExecutionStep1;
		Datetime endExecutionStep1;
		Integer executionTimeStep1 = 0;
		ServiceResponse serviceResponse = new ServiceResponse();
		List<Plc_Wrappers.AggiornaOrdineResponseData> responseDataList = new List<Plc_Wrappers.AggiornaOrdineResponseData>();
		List<WorkOrderLineItem> workOrderLineItems = new List<WorkOrderLineItem>();
		Set<String> workOrderAlias = new Set<String>();
		Map<String, WorkOrderLineItem> workOrderLineItemsToUpdate = new Map<String, WorkOrderLineItem>();
		List<String> resourceAliasList = new List<String>();
		Map<String,String> reservationInsertionMap = new Map<String,String>();
		Set<String> reservationIdSet = new Set<String>();
		Map<Id,Plc_Reservation__c> reservationIdInSystem = new Map<Id,Plc_Reservation__c>();
		List<String> resourceAliasSet = new List<String>();
		List<String> warehouseAliasList = new List<String>();
		Set<String> termIdSet = new Set<String>();
		Map<String, String> termIdsMap = retrieveTermIdCodes(new List<Plc_Wrappers.GestioneOrdineRequestBody>{workOrder});
		//<--
		Map<Id,List<Asset>> termIdAsset = new Map<Id,List<Asset>>();
		Map<String,Bit2Shop__Stock_Serials2__c> stockSerialMapInSystem = new Map<String,Bit2Shop__Stock_Serials2__c>();
		Set<String> stockSerialIdSetOnTime = new Set<String>();
		Set<String> simToSearchInEncoded = new Set<String>();
		Set<String> simToSearchInOther = new Set<String>();
		Map<Id,WorkOrderLineItem> AssetIdWoliMap = new Map<Id,WorkOrderLineItem>();
		Map<String, WorkOrderLineItem> workOrderLineItemMap = new Map<String, WorkOrderLineItem>();
		List<WorkOrder> workOrderPartial = new List<WorkOrder>();
		List<WorkOrderLineItem> workOrderLineItemPartial = new List<WorkOrderLineItem>();
		Map<String,String> serialNumbersUniqueToSingle = new Map<String,String>();
		List<Plc_Reservation__c> reservationToRelase = new List<Plc_Reservation__c>();
		List<WorkOrderLineItem> assetWoliLineItemList = new List<WorkOrderLineItem>();
		Map<String,String> stockSerial2Warehouse = new Map<String,String>();
		Map<String, Bit2Shop__Stock_Serials2__c> oldStockSerialsToUpdateMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
		//FB 20190711 NEXIPLC-661  [START]
		Map<String, Bit2Shop__Stock_Serials2__c> serialsFromVerifiedToAvailableMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
		//FB 20190711 NEXIPLC-661  [END] 
		Map<String,Id> woliExternalCatalaogItemToUse = new Map<String,Id>();
		Map<String,String> woliExternalReferenceItemToUse = new Map<String,String>();
		Map<String,String> woliExternalCategoryToUse = new Map<String,String>();
		Map<String,String> woliExternalSolutionToUse = new Map<String,String>();
		Map<String,String> woliExternalSubcategoryToUse = new Map<String,String>();



		String warningForToRemove;
		Integer typeOfSearch;
		Plc_Utils utilsIstance = new Plc_Utils();
		//CE 27/09/2019 START
		Set<String> solutionToSubCorMap = new Set<String>();
		//CE 27/09/2019 END

		LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment');
		Savepoint sp = Database.setSavepoint();
		//FB 10-06-2019 : NEXIPLC-632 [START]
		//String dealerAlias = (workOrder.workOrderDetail.dealerAlias.length() > 2 ? workOrder.workOrderDetail.dealerAlias.substring(0,3) : workOrder.workOrderDetail.dealerAlias);
		String dealerAlias = workOrder.workOrderDetail.dealerAlias;
		for (Bit2Shop__Warehouse__c warehouse : [SELECT Id, Plc_Alias__c
												 FROM Bit2Shop__Warehouse__c 
												 WHERE Bit2Shop__Dealer_Id__r.Bit2Shop__Parent_Dealer__r.Plc_Alias__c = :dealerAlias OR Bit2Shop__Dealer_Id__r.Plc_Alias__c = :dealerAlias]) {
			if (String.isNotBlank(warehouse.Plc_Alias__c)) {
				warehouseAliasList.add(warehouse.Plc_Alias__c);
			}
		}//
		//FB 20190711 NEXIPLC-661: Adding warehouse of undefined [START] 
		warehouseAliasList.add('999011NEXI');
		//FB 20190711 NEXIPLC-661 [END]
		
		//warehouseAliasList.add(workOrder.workOrderDetail.warehouseAlias);
		//FB 10-06-2019 : NEXIPLC-632 [END]
		workOrderAlias.add(workOrder.workOrderLegacyId);

		beginExecutionStep1=Datetime.now();
		Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap = getWorkOrderConfigurationMap();
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

		Boolean needToRemoveWarehouseFromlist = false;
		Boolean containsToSubstituteCorr = false;
		Boolean containsToReconfigureCorr = false;

		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
			
			resourceAliasList.add(workOrderLineItem.workOrderLineItemDetail.resourceAlias);
			
			if(workOrderLineItem.workOrderLineItemDetail.operationType!='ToReconfigureCorr' && workOrderLineItem.workOrderLineItemDetail.operationType!='ToSubstituteCorr'){
				if(workOrderLineItem.workOrderLineItemDetail.termId != ''){
					termIdSet.add(workOrderLineItem.workOrderLineItemDetail.termId);
				}
			}else{
				if(workOrderLineItem.workOrderLineItemDetail.termIdOld != ''){
					termIdSet.add(workOrderLineItem.workOrderLineItemDetail.termIdOld);
				}
				//CE 27/09/2019
				if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToReconfigureCorr'){
					containsToReconfigureCorr = true;
				}
				if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstituteCorr'){
					containsToSubstituteCorr = true;
				}
				//CE 27/09/2019
			}

			if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToRemove' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToReconfigureCorr'){
				warehouseAliasList.add('999010NEXI');
				needToRemoveWarehouseFromlist = true;
			}
			String woliKeyConfiguration =  workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
			if(!workOrderConfigurationMap.containsKey(woliKeyConfiguration)){
				serviceResponse.outcomeCode = '204';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0598] WorkOrder: '+workOrder.workOrderLegacyId+' the configuration with requestType: '+workOrder.workOrderDetail.requestType.toUpperCase()+' and operationType: '+workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase()+' is not possible';
				serviceResponse.executionTimeStep1 = executionTimeStep1; 
				LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T003]' + executionTimeStep1);
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				return serviceResponse;
			}
			//<--
			reservationIdSet.add(workOrderLineItem.workOrderLineItemDetail.reservationId);
		}


		LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## resourceAliasList' + resourceAliasList);
		LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## termIdSet' + termIdSet);
		LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## reservationIdSet' + reservationIdSet);

		// retrieve WorkOrders
		beginExecutionStep1 = Datetime.now();
		Map<String, WorkOrder> workOrdersToUpdate = retrieveWorkOrders(workOrderAlias);
		endExecutionStep1=Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));


		if(workOrdersToUpdate.isEmpty() || !workOrdersToUpdate.containsKey(workOrder.workOrderLegacyId)){
			serviceResponse.outcomeCode = '204';
			serviceResponse.executionTimeStep1 = executionTimeStep1; 
			serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
			return serviceResponse;
		}else if(workOrdersToUpdate.get(workOrder.workOrderLegacyId).Status=='Closed'){
			serviceResponse.outcomeCode = '204';
			serviceResponse.outcomeMessage = '[ERR:CL-00E0599] The WorkOrder: '+workOrder.workOrderLegacyId+' is already Closed';
			serviceResponse.executionTimeStep1 = executionTimeStep1; 
			LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T003]' + executionTimeStep1);
			serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
			return serviceResponse;
		}
		
		beginExecutionStep1=Datetime.now();
		Map<String, B2WExtCat__External_Catalog_Item__c> resourceAliasObjectMap = retrieveExternalCatalogItemObject(resourceAliasList); 
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
		// check if there is ECI
		
		for(WorkOrderLineItem workOrderLineItem : workOrdersToUpdate.get(workOrder.workOrderLegacyId).workOrderLineItems){
			workOrderLineItemMap.put(workOrderLineItem.Plc_Alias__c, workOrderLineItem);
			reservationIdSet.add(workOrderLineItem.Plc_Reservation__c);
		}

		//CE 27/09/2019 START
		if(containsToSubstituteCorr && containsToReconfigureCorr)
		{
			for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
				if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstituteCorr' && resourceAliasObjectMap.containsKey(workOrderLineItem.workOrderLineItemDetail.resourceAlias)){
					solutionToSubCorMap.add(workOrderLineItem.workOrderLineItemDetail.termIdOld+'_'+resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Solution__c);
				}
			}
		}
		//CE 27/09/2019 END

		// retrieve reservations
		beginExecutionStep1=Datetime.now();
		reservationIdInSystem = Plc_ReservationsServices.retrieveReservation(reservationIdSet);
		endExecutionStep1=Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
		
		
		if(workOrdersToUpdate.get(workOrder.workOrderLegacyId).RecordTypeId != Plc_Utils.getRecordTypeId(workOrder.workOrderDetail.requestType, 'WorkOrder') ){
			serviceResponse.outcomeCode = '204';
			serviceResponse.outcomeMessage = '[ERR:CL-00E0622] Unable to vary request type in: '+workOrder.workOrderDetail.requestType+' the tipology of workOrder in creation was: '+utilsIstance.getRecordTypeNameById('WorkOrder',workOrdersToUpdate.get(workOrder.workOrderLegacyId).RecordTypeId );
			serviceResponse.executionTimeStep1 = executionTimeStep1; 
			serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
			return serviceResponse;
		}
		// retrieve asset of serial woli with childs assets
		beginExecutionStep1=Datetime.now();
		for(Asset tempAsset : [SELECT Id,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__c,Plc_StockSerial__r.Plc_EncodedSerialNumber__c,ParentId,SerialNumber,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,
										Plc_TermId__c,Plc_TermId__r.Plc_TermIdCode__c,Plc_StockSerial__c,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c,Status,
										Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c
							   FROM Asset
							   WHERE Plc_TermId__r.Plc_TermIdCode__c IN:termIdSet]){
			List<Asset> tempListAsset = new List<Asset>();
			if(termIdAsset.containsKey(tempAsset.Plc_TermId__c)){
				tempListAsset = termIdAsset.get(tempAsset.Plc_TermId__c);
				tempListAsset.add(tempAsset);
				termIdAsset.put(tempAsset.Plc_TermId__c,tempListAsset);
			} else{

				tempListAsset.add(tempAsset);
				termIdAsset.put(tempAsset.Plc_TermId__c,tempListAsset);
			}
		}
		
		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
				//If the WorkOrderLineItem is Already Closed ( Executed ) SKIP THIS
				if(workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ){
					if(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Closed__c==true || workOrderLineItem.workOrderLineItemDetail.status=='ToExecute' || workOrderLineItem.workOrderLineItemDetail.operationType=='NoOperation'){
						continue;
					}
				}
				//Check if isn't an installation and is needed to check TERMID in system
				if(workOrderLineItem.workOrderLineItemDetail.operationType != 'ToInstall' && workOrderLineItem.workOrderLineItemDetail.operationType != 'NoOperation'){
					//Check if all TERMID are in system 
					String termIdToUse = (workOrderLineItem.workOrderLineItemDetail.operationType != 'ToSubstituteCorr' && workOrderLineItem.workOrderLineItemDetail.operationType != 'ToReconfigureCorr' ? workOrderLineItem.workOrderLineItemDetail.termId : workOrderLineItem.workOrderLineItemDetail.termIdOld);
					if(!termIdsMap.containsKey(termIdToUse) ){
						serviceResponse.outcomeCode = '602';
						serviceResponse.outcomeMessage = '[ERR:CL-00E0606] TermId: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',termIdToUse).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId);
						serviceResponse.executionTimeStep1 = executionTimeStep1;
						LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T008]' + executionTimeStep1);
						serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
						return serviceResponse;
					}
				}
				if(String.isbLank(workOrderLineItem.workOrderLineItemDetail.resourceAlias) ){

					if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToInstall' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstitute' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstituteCorr'){
					//<--
						serviceResponse.outcomeCode = '602';
						serviceResponse.outcomeMessage = '[ERR:CL-00E0601] resourceAlias is blank or null';
						serviceResponse.executionTimeStep1 = executionTimeStep1; 
						LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T003]' + executionTimeStep1);
						serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
						return serviceResponse;
					}
				}
				else{

					if(!resourceAliasObjectMap.containsKey(workOrderLineItem.workOrderLineItemDetail.resourceAlias)){

							serviceResponse.outcomeCode = '602';
							serviceResponse.outcomeMessage = '[ERR:CL-00E0601] ResourceAlias: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.resourceAlias).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId );
							serviceResponse.executionTimeStep1 = executionTimeStep1; 
							LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T003]' + executionTimeStep1);
							serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
					}

					if(workOrderLineItem.workOrderLineItemDetail.operationType!='ToDeactivate'){
						if(String.isbLank(workOrderLineItem.workOrderLineItemDetail.serialNumber) ) {
							if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToInstall' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstitute' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstituteCorr'){
							//<--    
								serviceResponse.outcomeCode = '602';
								serviceResponse.outcomeMessage = '[ERR:CL-00E0600] serial Number is blank or null';
								serviceResponse.executionTimeStep1 = executionTimeStep1;
								LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T002]' + executionTimeStep1);
								serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
								return serviceResponse;
							}
						}else{

							if(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__c!=null && resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c!=null ){
								if(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Subcategory__c=='SIM' ){
									if(workOrderLineItem.workOrderLineItemDetail.serialNumber.length() == 19 ){
									simToSearchInEncoded.add(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase());
									simToSearchInOther.add(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase());
									}else if(workOrderLineItem.workOrderLineItemDetail.serialNumber.length() == 20 ){
									 simToSearchInEncoded.add(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase());
									}else if(workOrderLineItem.workOrderLineItemDetail.serialNumber.length() == 16){
									simToSearchInOther.add(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase());
									}					
								}
								else{
									stockSerialIdSetOnTime.add(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase());
								}
							}else{
								serviceResponse.outcomeCode = '602';
								serviceResponse.outcomeMessage = '[ERR:CL-00E0602] Manufacturer Field or Manufacturer Alias Field on'+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.serialNumber).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId);
								serviceResponse.executionTimeStep1 = executionTimeStep1;
								LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T004]' + executionTimeStep1);
								serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
								return serviceResponse;
							}
						}
					}

					
				}

				
		}

        System.debug('EXECUTION TIME[0]: '+Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()) );
		System.debug('### stockSerialIdSetOnTime'+ JSON.serialize(stockSerialIdSetOnTime));
		System.debug('### warehouseAliasList: '+warehouseAliasList);
		
		typeOfSearch = 0;

		if(!warehouseAliasList.isEmpty()){
			System.debug('warehouseAliasList not empty');
			if(warehouseAliasList[0] != null){
				System.debug('warehouseAliasList[0] not null');

				if( (simToSearchInEncoded.size()>0 || simToSearchInOther.size()>0 ) && stockSerialIdSetOnTime.size()>0){
					typeOfSearch=1;
				}else if (stockSerialIdSetOnTime.size()>0 && (simToSearchInEncoded.size()==0 && simToSearchInOther.size()==0 ) ){
					typeOfSearch=2;
				}else if( (simToSearchInEncoded.size()>0 || simToSearchInOther.size()>0 ) && stockSerialIdSetOnTime.size()==0){
					typeOfSearch=3;
				}
				System.debug('EXECUTION TIME[0]: '+Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()) );
				beginExecutionStep1=Datetime.now();
				if(typeOfSearch!=0){
					try{
						stockSerialMapInSystem = retrieveStockSerials(typeOfSearch,stockSerialIdSetOnTime,simToSearchInEncoded,simToSearchInOther,sourceExtSystem, serialNumbersUniqueToSingle, stockSerial2Warehouse, warehouseAliasList , false);
					}
					catch(Plc_Exception ex){
						return composeError(serviceResponse, '602', ex.getMessage(), executionTimeStep1, Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()));
					}
				}
				endExecutionStep1 = Datetime.now();
				executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
				System.debug('EXECUTION TIME[1]: '+Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()) );
			}
			
		}
		System.debug('Query To Execute');
		System.debug('#### stockSerialMapInSystem '+ stockSerialMapInSystem.keySet());
		

		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
			//If the WorkOrderLineItem is Already Closed ( Executed ) SKIP THIS
			if(workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ){
			   if(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Closed__c==true || workOrderLineItem.workOrderLineItemDetail.status=='ToExecute' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToDeactivate'){
				continue;
			   } 
			}

			String workOrderConfigurationKey = workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();

			if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.serialNumber) && String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.resourceAlias) && workOrderLineItem.workOrderLineItemDetail.operationType!='NoOperation') {
				//Check if serialNumber is in system
				if(!stockSerialMapInSystem.containsKey( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ) && workOrderLineItem.workOrderLineItemDetail.operationType!='ToRemove'){
						serialNumbersUniqueToSingle.clear();
						stockSerial2Warehouse.clear();
						
						Map<String,Bit2Shop__Stock_Serials2__c> stockSerialMapFindInCorrectWarehouse = (typeOfSearch == 0 ? null :retrieveStockSerials(typeOfSearch,stockSerialIdSetOnTime,simToSearchInEncoded,simToSearchInOther,sourceExtSystem, serialNumbersUniqueToSingle, stockSerial2Warehouse, null , true) );
						if(typeOfSearch != 0 && stockSerialMapFindInCorrectWarehouse.containskey( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() )){
							String termIdToUse = (workOrderLineItem.workOrderLineItemDetail.operationType != 'ToSubstituteCorr' && workOrderLineItem.workOrderLineItemDetail.operationType != 'ToReconfigureCorr' ? workOrderLineItem.workOrderLineItemDetail.termId : workOrderLineItem.workOrderLineItemDetail.termIdOld);
							return composeError(serviceResponse, '602', '[ERR:CL-00E0650] TermId: '+termIdToUse+' WorkOrder Legacy: '+workOrder.workOrderLegacyId+' Serial Number: '+workOrderLineItem.workOrderLineItemDetail.serialNumber +'not found with the indicated search criteria. Searched under dealer: '+workOrder.workOrderDetail.dealerAlias+' but found in warehouse: '+stockSerialMapFindInCorrectWarehouse.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Warehouse_Id__r.Plc_Alias__c+' serial resource in SFDC: '+stockSerialMapFindInCorrectWarehouse.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Plc_ProductSku__c+',you passed: '+workOrderLineItem.workOrderLineItemDetail.resourceAlias, executionTimeStep1, Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()));
						}else{
							serviceResponse.outcomeCode = '602';
							serviceResponse.outcomeMessage = '[ERR:CL-00E0603] Serial Number: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.serialNumber).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId);
							serviceResponse.executionTimeStep1 = executionTimeStep1;
							LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T005]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
						}
						
				} 
				if(stockSerialMapInSystem.containsKey( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() )){
					if(stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Plc_ProductSku__c != workOrderLineItem.workOrderLineItemDetail.resourceAlias){
							if(stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c != resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Subcategory__c ){
								LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T005]' + executionTimeStep1);
								return composeError(serviceResponse, '602', '[ERR:CL-00E0637] Serial Number: '+workOrderLineItem.workOrderLineItemDetail.serialNumber+' on WOLI: '+workOrderLineItem.workOrderLineItemLegacyId+' has a subcategory different from the one indicated, serial resource subcategory in SFDC: '+stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c+' while you passed: '+workOrderLineItem.workOrderLineItemDetail.resourceAlias+ ' with subcategory: '+ resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Subcategory__c, executionTimeStep1, Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()));
							}
							//If the product sku in payload is different from the one on the serial, use the serial resource for that line item
							String dynamicMessage = 'Serial Number: '+workOrderLineItem.workOrderLineItemDetail.serialNumber+' on WOLI: '+workOrderLineItem.workOrderLineItemLegacyId+' has a product resource different from the one indicated, serial resource in SFDC: '+stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Plc_ProductSku__c+' while you passed: '+workOrderLineItem.workOrderLineItemDetail.resourceAlias;
							warningForToRemove = (warningForToRemove == null ? '[ERR:CL-00E0626] '+dynamicMessage : warningForToRemove+' , '+dynamicMessage);
							woliExternalCatalaogItemToUse.put(workOrderLineItem.workOrderLineItemLegacyId,stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c);
							woliExternalReferenceItemToUse.put(workOrderLineItem.workOrderLineItemLegacyId,stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Plc_ProductSku__c );
							woliExternalCategoryToUse.put(workOrderLineItem.workOrderLineItemLegacyId,stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c );
							woliExternalSolutionToUse.put(workOrderLineItem.workOrderLineItemLegacyId,stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c );
							woliExternalSubcategoryToUse.put(workOrderLineItem.workOrderLineItemLegacyId,stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c);
							
							//CRCAMPESE 21/01/2019 START
							resourceAliasList.add(stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Plc_ProductSku__c);
							//CRCAMPESE 21/01/2019 END
							/*
							serviceResponse.outcomeCode = '602';
							serviceResponse.outcomeMessage = '[ERR:CL-00E0636] Serial Number: '+workOrderLineItem.workOrderLineItemDetail.serialNumber+' on WOLI: '+workOrderLineItem.workOrderLineItemLegacyId+' has a product resource different from the one indicated, serial resource in SFDC: '+stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Plc_ProductSku__c+' while you passed: '+workOrderLineItem.workOrderLineItemDetail.resourceAlias;
							serviceResponse.executionTimeStep1 = executionTimeStep1;
							LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T005]' + executionTimeStep1);
							serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
							*/
						
					}
					/*
					if(workOrderLineItem.workOrderLineItemDetail.operationType!='ToRemove' && workOrderLineItem.workOrderLineItemDetail.operationType!='ToDeactivate'){
						if(warehouseAliasList.size()>0){
							if(String.isNotBlank(warehouseAliasList[0]) ){
								if(stockSerial2Warehouse.get((resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ) != warehouseAliasList[0] ){
									serviceResponse.outcomeCode = '602';
									serviceResponse.outcomeMessage = '[ERR:CL-00E06123] Serial Number: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.serialNumber).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId)+' check if the warehouse is correct';
									serviceResponse.executionTimeStep1 = executionTimeStep1;
												LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T005]' + executionTimeStep1);
									serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
									return serviceResponse;
								}
							}
						}
					}*/
					
						
					
					if(workOrderLineItem.workOrderLineItemDetail.operationType=='ToInstall' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstitute' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToSubstituteCorr'){
						//Check if the serial number need to be in WithDrawn Status
						if(stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Status__c != Plc_Constants.B2S_StockSerials2.B2S_Status_Withdrawn &&
						   stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase()).Bit2Shop__Status__c != Plc_Constants.B2S_StockSerials2.B2S_Status_Available &&
						   //FB 20190711 NEXIPLC-661 [START] 
						   stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase()).Bit2Shop__Status__c != Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeVerified) {														
						 	//FB 20190711 NEXIPLC-661 [END]
						 	
							serviceResponse.outcomeCode = '602';

							serviceResponse.outcomeMessage = '[ERR:CL-00E0604] Serial Number: '+Label.Plc_ApexClassWorkOrdersServicesStatusDifferentFromWithdrawnOrAvailableOrVerified.replace('{0}',workOrderLineItem.workOrderLineItemDetail.serialNumber)+' ,serial status is: '+
							stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Status__c;

							serviceResponse.executionTimeStep1 = executionTimeStep1;
							LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T006]' + executionTimeStep1);
							serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
						}

						Bit2Shop__Stock_Serials2__c currentStockSerial = stockSerialMapInSystem.get((resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase());
						if (currentStockSerial.Bit2Shop__Status__c == Plc_Constants.B2S_StockSerials2.B2S_Status_Available) {
							oldStockSerialsToUpdateMap.put('' + currentStockSerial.Id, currentStockSerial);
						}
						//FB 20190711 NEXIPLC-661 [START] 
						if (currentStockSerial.Bit2Shop__Status__c == Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeVerified) {
							serialsFromVerifiedToAvailableMap.put('' + currentStockSerial.Id, currentStockSerial);
						}
						//FB 20190711 NEXIPLC-661 [END] 
					}else{   
						//Check if the serial number need to be in Installed Status
						if(stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Status__c!='Installed'){
							serviceResponse.outcomeCode = '602';

							serviceResponse.outcomeMessage = '[ERR:CL-00E0605] Serial Number: '+Label.Plc_ApexClassWorkOrdersServicesSerialStatusDifferentFromInstalled.replace('{0}',workOrderLineItem.workOrderLineItemDetail.serialNumber)+' ,serial status is: '+
							stockSerialMapInSystem.get( (resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber).toUpperCase() ).Bit2Shop__Status__c;

							serviceResponse.executionTimeStep1 = executionTimeStep1;
							LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T007]' + executionTimeStep1);
							serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
						}
					}	
				}
                
			}
			
			//Check if all ReservationId (except empty for WSICT) are in system
			if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c && sourceExtSystem=='MONETICA' && workOrderLineItem.workOrderLineItemDetail.operationType!='NoOperation'){
				if(String.isBlank(workOrderLineItem.workOrderLineItemDetail.reservationId)){
					serviceResponse.outcomeCode = '602';serviceResponse.outcomeMessage = '[ERR:CL-00E0630] Reservation on Work Order Line Item: '+workOrderLineItem.workOrderLineItemLegacyId+' is blank or null';serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T009]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
					return serviceResponse;
				}else if(!reservationIdInSystem.containsKey(workOrderLineItem.workOrderLineItemDetail.reservationId) ){
					serviceResponse.outcomeCode = '602';serviceResponse.outcomeMessage = '[ERR:CL-00E0607] ReservationId: '+Label.Plc_ApexClassWorkOrdersServicesFieldNotInSystem.replace('{0}',workOrderLineItem.workOrderLineItemDetail.reservationId).replace('{1}',workOrderLineItem.workOrderLineItemLegacyId);serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T009]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
					return serviceResponse;
				}
			}
			
		}

		//FB 10-06-2019 : NEXIPLC-632 [START]
		if(needToRemoveWarehouseFromlist){
			if (warehouseAliasList.size()>1 ){
				warehouseAliasList.remove(warehouseAliasList.size()-1);
			}
		}
		
		//Previous one
		//if (warehouseAliasList.size()>1 ){
		//	warehouseAliasList.remove(1);
		//}
		//FB 10-06-2019 : NEXIPLC-632 [END]
		
		beginExecutionStep1 = Datetime.now();
		Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(resourceAliasList,warehouseAliasList);
		endExecutionStep1 = Datetime.now();
		executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
		// get all resource aliases
		Map<String, Plc_Reservation__c> reservationToUpsert = new Map<String, Plc_Reservation__c>();
		
		Boolean needProductStockChange;

		for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
			needProductStockChange = false;
			//If the WorkOrderLineItem is Already Closed ( Executed ) SKIP THIS
			if(workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ){
				if(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Closed__c==true || workOrderLineItem.workOrderLineItemDetail.status=='ToExecute' || workOrderLineItem.workOrderLineItemDetail.operationType=='NoOperation'){
				continue;
				} 
			}

			if(workOrderLineItem.workOrderLineItemDetail.operationType != 'ToDeactivate' && workOrderLineItem.workOrderLineItemDetail.operationType != 'ToRemove'){

				String workOrderConfigurationKey = workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
				if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){
					
					String resourceAliasToUse = workOrderLineItem.workOrderLineItemDetail.resourceAlias;

					if(workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
						String productSkuChangeToCheck = '';
						//CRCAMPESE 21/01/2019 START

						if(woliExternalReferenceItemToUse.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
							resourceAliasToUse = woliExternalReferenceItemToUse.get(workOrderLineItem.workOrderLineItemLegacyId);
						}
						//CRCAMPESE 21/01/2019 END

						if(workOrderLineItem.workOrderLineItemDetail.operationType == 'ToSubstituteCorr'){
							if(sourceExtSystem=='MONETICA'){
								productSkuChangeToCheck = reservationIdInSystem.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c;
								//CRCAMPESE 21/01/2019 START

								if(resourceAliasToUse==productSkuChangeToCheck){
									continue;
								}else{
									needProductStockChange = true;
								}
								//CRCAMPESE 21/01/2019 END

							}

						}else{
							
							productSkuChangeToCheck = reservationIdInSystem.get(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Reservation__c).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c ;
					
							//CRCAMPESE 21/01/2019 START
							if(resourceAliasToUse==productSkuChangeToCheck){
								continue;
							}else{
								needProductStockChange = true;
							}
							//CRCAMPESE 21/01/2019 END
						}
						
						System.debug('-.-: '+productSkuChangeToCheck);
					}
					System.debug('keyResourceWarehuse: '+resourceAliasToUse + workOrder.workOrderDetail.warehouseAlias );
					System.debug('productStockmap: '+productStockMap);

					if (productStockMap.containsKey(resourceAliasToUse + workOrder.workOrderDetail.warehouseAlias)) {

						if(productStockMap.get(resourceAliasToUse + workOrder.workOrderDetail.warehouseAlias).Plc_AvailableQty__c > 0){

							Plc_Reservation__c reservationRequest = new Plc_Reservation__c();
							if(needProductStockChange==false){
								reservationRequest.Plc_Status__c  = 'Reserved';
								reservationRequest.Plc_ProductStock__c = productStockMap.get(resourceAliasToUse + workOrder.workOrderDetail.warehouseAlias).Id;
								reservationRequest.Plc_SourceLegacySystem__c = sourceExtSystem;
								reservationToUpsert.put(workOrderLineItem.workOrderLineItemLegacyId,reservationRequest);
							}else{
								//if the Solution of the product on the reservation is the same of the product that it's trying to change 
								System.debug('reservationIdInSystem: '+reservationIdInSystem);
								System.debug('WOLINEITEM '+workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId)) ;
								System.debug('WOLINEITEMRESERVATION '+workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Reservation__c) ;
								String reservationToUse;

								if(sourceExtSystem == 'MONETICA'){
									reservationToUse = workOrderLineItem.workOrderLineItemDetail.reservationId;
								}else{
									reservationToUse = workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Reservation__c ;
								}

								if(reservationIdInSystem.get(reservationToUse).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c == productStockMap.get('' + resourceAliasToUse + workOrder.workOrderDetail.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c ){
									reservationRequest = reservationIdInSystem.get(reservationToUse);
									reservationRequest.Plc_ProductStock__c = productStockMap.get(resourceAliasToUse + workOrder.workOrderDetail.warehouseAlias).Id;
									reservationRequest.Plc_SourceLegacySystem__c = sourceExtSystem;
									reservationToUpsert.put(workOrderLineItem.workOrderLineItemLegacyId,reservationRequest);
								}
								else{
									serviceResponse.outcomeCode = '202';
									serviceResponse.outcomeMessage = 'The Solution of the product ('+resourceAliasToUse+') in Work Order Line Item and the Solution of the product in Reservation do not match';
									serviceResponse.responseDataList = responseDataList;
									serviceResponse.executionTimeStep1 = executionTimeStep1; 
									serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
									Database.rollback(sp);
									return serviceResponse;                                    
								}
								
							}
							
						} else {
							serviceResponse.outcomeCode = '202';
							serviceResponse.outcomeMessage = '[ERR:CL-00E0608] ' + Label.Plc_ApexClassWorkOrdersServicesProductNotAvailableForLineItem + workOrderLineItem.workOrderLineItemLegacyId +' product searched: '+resourceAliasToUse+' in warehouse: '+workOrder.workOrderDetail.warehouseAlias;
							serviceResponse.responseDataList = responseDataList;
							serviceResponse.executionTimeStep1 = executionTimeStep1;
							LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T0010]' + executionTimeStep1);
							serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							return serviceResponse;
						}

					} else {
						serviceResponse.outcomeCode = '202';
						serviceResponse.outcomeMessage = '[ERR:CL-00E0609] product '+resourceAliasToUse+' not registered in the warehouse: '+workOrder.workOrderDetail.warehouseAlias;
						serviceResponse.responseDataList = responseDataList;
						serviceResponse.executionTimeStep1 = executionTimeStep1;
						LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T011]' + executionTimeStep1);
						serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
						return serviceResponse;
					}
				}
			}
		}

		if(!reservationToUpsert.isEmpty()){
			reservationInsertionMap = Plc_ReservationsServices.upsertReservations(reservationToUpsert);
			reservationIdSet.addAll(reservationInsertionMap.keySet());
			reservationIdInSystem = Plc_ReservationsServices.retrieveReservation(reservationIdSet);
		}
		String outcomeMessage = '';
		try{

			//FB 20190711 NEXIPLC-661 [START]
			if (!serialsFromVerifiedToAvailableMap.keySet().isEmpty()) { 
				Map<String, Bit2Shop__Stock_Serials2__c> newStockSerialsUpdatedMap = new Map<String, Bit2Shop__Stock_Serials2__c>();

				for (String key: serialsFromVerifiedToAvailableMap.keySet()) {
					Bit2Shop__Stock_Serials2__c stockSerialToUpdate = serialsFromVerifiedToAvailableMap.get(key).clone();
					stockSerialToUpdate.Id = key;
					stockSerialToUpdate.Bit2Shop__Status__c = Plc_Constants.B2S_StockSerials2.B2S_Status_Available;
					newStockSerialsUpdatedMap.put(key, stockSerialToUpdate);
					oldStockSerialsToUpdateMap.put(key, stockSerialToUpdate);
				}

				update newStockSerialsUpdatedMap.values();

				Plc_Utils.productStockQties.updateProductStockQuantities(serialsFromVerifiedToAvailableMap, newStockSerialsUpdatedMap);
			}
			//FB 20190711 NEXIPLC-661 [END] 

			//FB 21-05-2019 - adding serials update to withdrawn
			if (!oldStockSerialsToUpdateMap.keySet().isEmpty()) {
				Map<String, Bit2Shop__Stock_Serials2__c> newStockSerialsUpdatedMap = new Map<String, Bit2Shop__Stock_Serials2__c>();

				for (String key: oldStockSerialsToUpdateMap.keySet()) {
					Bit2Shop__Stock_Serials2__c stockSerialToUpdate = oldStockSerialsToUpdateMap.get(key).clone();
					stockSerialToUpdate.Id = key;
					stockSerialToUpdate.Bit2Shop__Status__c = Plc_Constants.B2S_StockSerials2.B2S_Status_Withdrawn;
					newStockSerialsUpdatedMap.put(key, stockSerialToUpdate);
				}

				update newStockSerialsUpdatedMap.values();

				Plc_Utils.productStockQties.updateProductStockQuantities(oldStockSerialsToUpdateMap, newStockSerialsUpdatedMap);
			}
			//Create work orders and related line items
			WorkOrder workOrderToUpdate = workOrdersToUpdate.get(workOrder.workOrderLegacyId);
			try{

				workOrderToUpdate.RecordTypeId = Plc_Utils.getRecordTypeId(workOrder.workOrderDetail.requestType,'WorkOrder');
			}catch(Exception ex){
				serviceResponse.outcomeCode = '602';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0610] ' + Label.Plc_ApexClassWorkOrdersServicesInvalidRequestType;
				serviceResponse.executionTimeStep1 = executionTimeStep1;
				LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T012]' + executionTimeStep1);
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				Database.rollback(sp);
				return serviceResponse;
			}
			workOrderToUpdate.Status = workOrder.workOrderDetail.status;
			try{
				
				if(String.isNotBlank(workOrder.workOrderDetail.startDate)){

					workOrderToUpdate.StartDate = DateTime.valueOfGmt(workOrder.workOrderDetail.startDate.replace('T', ' '));
				}
				if(String.isNotBlank(workOrder.workOrderDetail.endDate)){

					workOrderToUpdate.EndDate = DateTime.valueOfGmt(workOrder.workOrderDetail.endDate.replace('T', ' '));
				}
			}catch(Exception ex){
				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0611] ' + ex.getMessage();
				serviceResponse.executionTimeStep1 = executionTimeStep1;
				LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T013]' + executionTimeStep1);
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				Database.rollback(sp);
				return serviceResponse;
			}
			workOrderToUpdate.Plc_LegacyWarehouseId__c = workOrder.workOrderDetail.warehouseAlias;
			workOrderToUpdate.Plc_Abi__c = workOrder.workOrderDetail.abi;
			workOrderToUpdate.Plc_BankDescription__c = workOrder.workOrderDetail.bankDescription;
			workOrderToUpdate.Plc_ServicePoint__c = workOrder.workOrderDetail.businessName;
			workOrderToUpdate.Plc_LegacyServicePointId__c = workOrder.workOrderDetail.shopLegacyId;
			workOrderToUpdate.Plc_Vat__c = workOrder.workOrderDetail.vatNumber;
			workOrderToUpdate.Plc_FiscalCode__c = workOrder.workOrderDetail.fiscalCode;
			workOrderToUpdate.Plc_SiaCode__c = workOrder.workOrderDetail.siaCode;
			workOrderToUpdate.Plc_LegacyAccountId__c = workOrder.workOrderDetail.accountLegacyId;
			workOrderToUpdate.Street = workOrder.workOrderDetail.address;
			workOrderToUpdate.PostalCode = workOrder.workOrderDetail.postalCode;
			workOrderToUpdate.City = workOrder.workOrderDetail.locality;
			workOrderToUpdate.State = workOrder.workOrderDetail.province;
			workOrderToUpdate.Plc_Prefix__c = workOrder.workOrderDetail.prefix;
			workOrderToUpdate.Plc_Phone__c = workOrder.workOrderDetail.phone;
			workOrderToUpdate.Plc_Email__c = workOrder.workOrderDetail.mail;
			workOrderToUpdate.Plc_Cti__c = workOrder.workOrderDetail.cti;
			workOrderToUpdate.Plc_CustomerCare__c = workOrder.workOrderDetail.supportPhoneNumber;
			workOrderToUpdate.Plc_OpeingHours__c = workOrder.workOrderDetail.openingTime;
			workOrderToUpdate.Plc_Contact__c = workOrder.workOrderDetail.referent;
			workOrderToUpdate.Plc_Note__c = workOrder.workOrderDetail.notes;
			workOrderToUpdate.Plc_Alias__c = workOrder.workOrderLegacyId;
			workOrderToUpdate.Plc_SourceLegacySystem__c = sourceExtSystem;
			workOrderPartial.add(workOrderToUpdate);

			for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
				//If the WorkOrderLineItem is Already Closed ( Executed ) SKIP THIS
				if(workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ){
				   if(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Closed__c==true || workOrderLineItem.workOrderLineItemDetail.status=='ToExecute' ){
					continue;
				   } 
				}
				
				String solutionToUse = (woliExternalCatalaogItemToUse.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ? woliExternalSolutionToUse.get(workOrderLineItem.workOrderLineItemLegacyId) : resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Solution__c); 
				String categoryToUse = (woliExternalCatalaogItemToUse.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ? woliExternalCategoryToUse.get(workOrderLineItem.workOrderLineItemLegacyId) : resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Category__c); 
				String externalIdToUse = (woliExternalCatalaogItemToUse.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ? woliExternalCatalaogItemToUse.get(workOrderLineItem.workOrderLineItemLegacyId) : resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Id); 
				String productSkuToUse = (woliExternalCatalaogItemToUse.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ? woliExternalReferenceItemToUse.get(workOrderLineItem.workOrderLineItemLegacyId) : workOrderLineItem.workOrderLineItemDetail.resourceAlias); 
				String subcategoryToUse = (woliExternalCatalaogItemToUse.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ? woliExternalSubcategoryToUse.get(workOrderLineItem.workOrderLineItemLegacyId) : resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Subcategory__c); 

				WorkOrderLineItem workOrderLineItemToUpsert = new WorkOrderLineItem();
				if(workOrderLineItemMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
					if(workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId).Status == WORK_ORDER_LINE_ITEM_EXECUTED){
						continue;
					}
					workOrderLineItemToUpsert = workOrderLineItemMap.get(workOrderLineItem.workOrderLineItemLegacyId);
					
				}
				workOrderLineItemToUpsert.Status = workOrderLineItem.workOrderLineItemDetail.status;
				workOrderLineItemToUpsert.Plc_OperationType__c = workOrderLineItem.workOrderLineItemDetail.operationType;
				workOrderLineItemToUpsert.Plc_BundleId__c = workOrderLineItem.workOrderLineItemDetail.bundleId;
				
				if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.serialNumber) ){
					if(serialNumbersUniqueToSingle.containsKey(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase() ) ){
						workOrderLineItemToUpsert.Plc_SerialNumber__c = serialNumbersUniqueToSingle.get(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase() );
					}else if ( workOrderLineItem.workOrderLineItemDetail.operationType=='NoOperation' || workOrderLineItem.workOrderLineItemDetail.operationType=='ToDeactivate'){
						workOrderLineItemToUpsert.Plc_SerialNumber__c = workOrderLineItem.workOrderLineItemDetail.serialNumber;
					}
				}
				if(workOrderLineItem.workOrderLineItemDetail.operationType != 'ToSubstituteCorr' && workOrderLineItem.workOrderLineItemDetail.operationType != 'ToReconfigureCorr'){
					if(termIdsMap.containsKey(workOrderLineItem.workOrderLineItemDetail.termId) ){
						workOrderLineItemToUpsert.Plc_TermId__c = termIdsMap.get(workOrderLineItem.workOrderLineItemDetail.termId);
					}
				}else{
					if(termIdsMap.containsKey(workOrderLineItem.workOrderLineItemDetail.termIdOld) ){
						workOrderLineItemToUpsert.Plc_TermIdOld__c = termIdsMap.get(workOrderLineItem.workOrderLineItemDetail.termIdOld);
					}
				}

				if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.termId) ){
					workOrderLineItemToUpsert.Plc_ExternalTermId__c = workOrderLineItem.workOrderLineItemDetail.termId;
				}

				
				if(String.isNotBlank(productSkuToUse)){
					workOrderLineItemToUpsert.Plc_ReferenceExternalCatalogItem__c = productSkuToUse;
				}

				if(String.isNotBlank(externalIdToUse)){
					workOrderLineItemToUpsert.Plc_ExternalCatalogItem__c = externalIdToUse;
				}

				System.debug('VERIFY FIX EXTID: '+workOrderLineItemToUpsert.Plc_ExternalCatalogItem__c);


				String workOrderConfigurationKey = '' + workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
				if(workOrderLineItem.workOrderLineItemDetail.operationType!='NoOperation' ){
					if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){
						if(reservationInsertionMap.containsKey(workOrderLineItem.workOrderLineItemLegacyId) ){
							workOrderLineItemToUpsert.Plc_Reservation__c = reservationInsertionMap.get(workOrderLineItem.workOrderLineItemLegacyId);
						}else if(sourceExtSystem == 'MONETICA'){
							workOrderLineItemToUpsert.Plc_Reservation__c = workOrderLineItem.workOrderLineItemDetail.reservationId;
						}
					}
				}
				try{
					workOrderLineItemToUpsert.Plc_LegacyCreatedDate__c = DateTime.valueOfGmt(workOrderLineItem.workOrderLineItemDetail.generationDate.replace('T', ' '));
				}catch(Exception ex){

					serviceResponse.outcomeCode = '603';
					serviceResponse.outcomeMessage = '[ERR:CL-00E0615] ' + ex.getMessage();
					serviceResponse.executionTimeStep1 = executionTimeStep1;
					LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T017]' + executionTimeStep1);
					serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
					Database.rollback(sp);
					return serviceResponse;
				}

				workOrderLineItemToUpsert.Plc_Note__c = workOrderLineItem.workOrderLineItemDetail.notes;
				workOrderLineItemToUpsert.Plc_Alias__c = workOrderLineItem.workOrderLineItemLegacyId;
				//Attach the parent to WOLI
				if(categoryToUse!='Product'){
					for(WorkOrderLineItem workOrderLineItemTemp : workOrderLineItemMap.values()){
						if(workOrderLineItemTemp.Plc_Alias__c == workOrderLineItem.workOrderLineItemDetail.parent){
							workOrderLineItemToUpsert.Plc_Parent__c = workOrderLineItemTemp.Id;
							workOrderLineItemToUpsert.ParentWorkOrderLineItemId = workOrderLineItemTemp.Id;
						}
					}
				}
				
				//
				if(workOrderLineItemToUpsert.Plc_OperationType__c !='ToDeactivate' && workOrderLineItemToUpsert.Plc_OperationType__c != 'ToReconfigureCorr'){
						workOrderLineItems.add(workOrderLineItemToUpsert);
				}
				else{
					System.debug('##TOREC');
					System.debug('EXTCAT: '+workOrderLineItemToUpsert.Plc_ExternalCatalogItem__c);
					System.debug('##Category: '+categoryToUse);
					if(categoryToUse=='Product'){
						System.debug('##TORECIN');
						workOrderLineItems.add(workOrderLineItemToUpsert);
					}
				}
				// CREATE WOLI FOR ONLY ASSET CHILD, FOR EACH WOLI EXCEPT THE FATHER WOLI
				if(workOrderLineItemToUpsert.Plc_OperationType__c =='ToDeactivate'){
					if(termIdAsset.containsKey(workOrderLineItemToUpsert.Plc_TermId__c)){
						if(categoryToUse=='Product'){
							for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermId__c)){
								if(tempAsset.Status=='Installed'){
									//IF IS THE PRODUCT ITEM IN THE ASSET LIST : CONTINUE 
									if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c ){
										//TEMPORARY MOD
										workOrderLineItemToUpsert.AssetId= tempAsset.Id;
										// TEMPOARY MOD
										continue;
									}
									if(!AssetIdWoliMap.containsKey(tempAsset.Id)){
										WorkOrderLineItem newWorkOrderLineItem = new  WorkOrderLineItem();
										newWorkOrderLineItem.Plc_Parent__c = workOrderLineItemToUpsert.Id;
										newWorkOrderLineItem.ParentWorkOrderLineItemId = workOrderLineItemToUpsert.Id;
										newWorkOrderLineItem.Plc_SerialNumber__c = tempAsset.SerialNumber;
										newWorkOrderLineItem.Plc_ReferenceExternalCatalogItem__c = tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c;
										newWorkOrderLineItem.Plc_TermId__c = tempAsset.Plc_TermId__c;
										newWorkOrderLineItem.Status = 'Executed';
										newWorkOrderLineItem.AssetId= tempAsset.Id;
										newWorkOrderLineItem.Plc_OperationType__c = 'ToDeactivate';
										newWorkOrderLineItem.Plc_ExternalCatalogItem__c = tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__c;
										AssetIdWoliMap.put(tempAsset.Id,newWorkOrderLineItem);
									}
								}
								
							}
						}else{ //Else not is a Product resource
							for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermId__c)){
								//IF IS THE PRODUCT ITEM IN THE ASSET LIST : CONTINUE 
								if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c && tempAsset.Status=='Installed'){
									//TEMPORARY MOD
									workOrderLineItemToUpsert.AssetId= tempAsset.Id;
									workOrderLineItems.add(workOrderLineItemToUpsert);
									// TEMPOARY MOD
									if(AssetIdWoliMap.containsKey(tempAsset.Id)){
										AssetIdWoliMap.remove(tempAsset.Id);
									}
								}
								
							}
						}
					}
					else{
						Database.rollback(sp);
						return composeError(serviceResponse,'603','[ERR:CL-00E0616] ' + workOrderLineItemToUpsert.Plc_Alias__c+' doesnt have assests related',executionTimeStep1,Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()));
					}

				}if(workOrderLineItemToUpsert.Plc_OperationType__c =='ToReconfigureCorr'){ 
					if(termIdAsset.containsKey(workOrderLineItemToUpsert.Plc_TermIdOld__c)){
						if(categoryToUse=='Product'){
							for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermIdOld__c)){
								
								if( tempAsset.Status=='Installed'){
									//IF IS THE PRODUCT ITEM IN THE ASSET LIST : CONTINUE 
									if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c){
										//TEMPORARY MOD
										workOrderLineItemToUpsert.AssetId= tempAsset.Id;
										// TEMPOARY MOD
										continue;
									}
									if(!AssetIdWoliMap.containsKey(tempAsset.Id)){
										//CE 27/09/2019
										if(!solutionToSubCorMap.isEmpty() && solutionToSubCorMap.contains(workOrderLineItem.workOrderLineItemDetail.termIdOld+'_'+tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c)){
											continue;
										}
										//CE 27/09/2019
										WorkOrderLineItem newWorkOrderLineItem = new  WorkOrderLineItem();
										newWorkOrderLineItem.Plc_Parent__c = workOrderLineItemToUpsert.Id;
										newWorkOrderLineItem.ParentWorkOrderLineItemId = workOrderLineItemToUpsert.Id;
										newWorkOrderLineItem.Plc_SerialNumber__c = tempAsset.SerialNumber;
										newWorkOrderLineItem.Plc_ReferenceExternalCatalogItem__c = tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c;
										newWorkOrderLineItem.Plc_TermIdOld__c = tempAsset.Plc_TermId__c;
										newWorkOrderLineItem.Plc_ExternalTermId__c = workOrderLineItem.workOrderLineItemDetail.termId;
										newWorkOrderLineItem.Status = 'Executed';
										newWorkOrderLineItem.AssetId= tempAsset.Id;
										newWorkOrderLineItem.Plc_OperationType__c = 'ToReconfigureCorr';
										newWorkOrderLineItem.Plc_ExternalCatalogItem__c = tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__c;
										AssetIdWoliMap.put(tempAsset.Id,newWorkOrderLineItem);
									}
								}
								
							}
						}else{ //Else not is a Product resource
							for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermIdOld__c)){
								//IF IS THE PRODUCT ITEM IN THE ASSET LIST : CONTINUE 
								if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c && tempAsset.Status=='Installed'){
									//TEMPORARY MOD
									workOrderLineItemToUpsert.AssetId= tempAsset.Id;
									workOrderLineItems.add(workOrderLineItemToUpsert);
									// TEMPOARY MOD
									if(AssetIdWoliMap.containsKey(tempAsset.Id)){
										AssetIdWoliMap.remove(tempAsset.Id);
									}
								}
								
							}
						}
					}
					else{
						serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0616] ' + workOrderLineItemToUpsert.Plc_Alias__c+' doesnt have assests related';serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T018]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
						Database.rollback(sp);
						return serviceResponse;
					}

				}else if (workOrderLineItemToUpsert.Plc_OperationType__c =='ToRemove'){
					String dynamicMessage;
					if(termIdAsset.containsKey(workOrderLineItemToUpsert.Plc_TermId__c)){
						Boolean foundAssetRelated = false;
						for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermId__c)){
							System.debug('### AssetTermId: '+tempAsset);

							//IF IS THE SAME SERIAL OF THE ASSET GIVE TO IT
							if(tempAsset.Status=='Installed'){
								dynamicMessage = 'On TermId '+workOrderLineItem.workOrderLineItemDetail.termId+' serial number: '+tempAsset.Plc_StockSerial__r.Plc_EncodedSerialNumber__c +' has been uninstalled ,while you passed: '+workOrderLineItem.workOrderLineItemDetail.serialNumber;

								if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.serialNumber) && stockSerialMapInSystem.containsKey(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase() ) && stockSerialMapInSystem.get(resourceAliasObjectMap.get(workOrderLineItem.workOrderLineItemDetail.resourceAlias).Plc_Manufacturer__r.Plc_Alias__c.toUpperCase()+'_'+workOrderLineItem.workOrderLineItemDetail.serialNumber.toUpperCase() ).Id == tempAsset.Plc_StockSerial__c){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									System.debug('IN1');
									break;
								}
								if(woliExternalReferenceItemToUse.containsKey(workOrderLineItem.workOrderLineItemLegacyId) && woliExternalReferenceItemToUse.get(workOrderLineItem.workOrderLineItemLegacyId) == tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.serialNumber)){
										warningForToRemove = (warningForToRemove == null ? '[ERR:CL-00E0626] '+dynamicMessage : warningForToRemove+' , '+dynamicMessage);
									}
									System.debug('IN2');
									break;
								} else if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.serialNumber)){
										warningForToRemove = (warningForToRemove == null ? '[ERR:CL-00E0626] '+dynamicMessage : warningForToRemove+' , '+dynamicMessage);
									}
									System.debug('IN3');
									break;
								}
								if(solutionToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.serialNumber)){
										warningForToRemove = (warningForToRemove == null ? '[ERR:CL-00E0626] '+dynamicMessage : warningForToRemove+' , '+dynamicMessage);
									}
									System.debug('IN4');
									break;
								} // Associate the substituted one with same Subcategory
								if(subcategoryToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.serialNumber)){
										warningForToRemove = (warningForToRemove == null ? '[ERR:CL-00E0626] '+dynamicMessage : warningForToRemove+' , '+dynamicMessage);
									}									System.debug('IN5');
									break;
								}
							}
						}
						if(foundAssetRelated == false){
							serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0640] WOLI:'+workOrderLineItemToUpsert.Plc_Alias__c+' no type of matching under TermId: '+workOrderLineItem.workOrderLineItemDetail.termId+' with the serial or resource indicated';serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T019]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());Database.rollback(sp);
							return serviceResponse;
						}
						
					}else{
						serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0617] ' + workOrderLineItemToUpsert.Plc_Alias__c+' doesnt have assests related';serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T019]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
						Database.rollback(sp);
						return serviceResponse;
					}
				}else if (workOrderLineItemToUpsert.Plc_OperationType__c =='ToSubstitute'){
					if(workOrderLineItem.workOrderLineItemDetail.operationType!='NoOperation'){
						if(termIdAsset.containsKey(workOrderLineItemToUpsert.Plc_TermId__c)){
							Boolean foundAssetRelated = false;
							for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermId__c)){
								//IF IS THE PRODUCT OF THE ASSET LIST , GIVE TO IT THE ASSETID
								// Associate the substituted one with same Product SKU
								if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c && tempAsset.Status=='Installed'){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									break;
								}
								// Associate the substituted one with same Solution
								if(solutionToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c && tempAsset.Status=='Installed'){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									break;
								}
								// Associate the substituted one with same Subcategory
								if(subcategoryToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c && tempAsset.Status=='Installed'){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									foundAssetRelated = true;
									break;
								}
							}
							if(foundAssetRelated == false){
								serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0640] WOLI:'+workOrderLineItemToUpsert.Plc_Alias__c+' no type of matching under TermId: '+workOrderLineItem.workOrderLineItemDetail.termId+' with the serial or resource indicated';serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T019]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
								Database.rollback(sp);
								return serviceResponse;
							}
						}else{
							serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0617] ' + workOrderLineItemToUpsert.Plc_Alias__c+' doesnt have assests related';serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T019]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							Database.rollback(sp);
							return serviceResponse;
						}
					}
				}
				else if (workOrderLineItemToUpsert.Plc_OperationType__c =='ToSubstituteCorr'){
					if(workOrderLineItem.workOrderLineItemDetail.operationType!='NoOperation'){
						if(termIdAsset.containsKey(workOrderLineItemToUpsert.Plc_TermIdOld__c)){
							for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermIdOld__c)){
								//IF IS THE PRODUCT OF THE ASSET LIST , GIVE TO IT THE ASSETID
								if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c && tempAsset.Status=='Installed'){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									break;
								}
								if(solutionToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c && tempAsset.Status=='Installed'){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									break;
								}
								if(subcategoryToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c && tempAsset.Status=='Installed'){
									workOrderLineItemToUpsert.AssetId = tempAsset.Id;
									break;
								}
							}
						}else{
							serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0617] ' + workOrderLineItemToUpsert.Plc_Alias__c+' doesnt have assests related';serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T019]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
							Database.rollback(sp);
							return serviceResponse;
						}
					}
				}

				// If is a NoOperation and there are some reservation related to woli, it need to be released
				if(workOrderLineItem.workOrderLineItemDetail.operationType=='NoOperation'){

					if(termIdAsset.containsKey(workOrderLineItemToUpsert.Plc_TermId__c)){
						for(Asset tempAsset : termIdAsset.get(workOrderLineItemToUpsert.Plc_TermId__c)){
							//IF IS THE PRODUCT OF THE ASSET LIST , GIVE TO IT THE ASSETID
							if(productSkuToUse==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c && tempAsset.Status=='Installed'){
								workOrderLineItemToUpsert.AssetId = tempAsset.Id;
								break;
							}
							/*
							if(workOrderLineItemToUpsert.Plc_ExternalCatalogItem__r.Plc_Solution__c==tempAsset.Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c && tempAsset.Status=='Installed'){
								workOrderLineItemToUpsert.AssetId = tempAsset.Id;
								break;
							}
							*/
						}
					}
					if(reservationIdInSystem.containsKey(workOrderLineItemToUpsert.Plc_Reservation__c)){
						Plc_Reservation__c tempReservation = reservationIdInSystem.get(workOrderLineItemToUpsert.Plc_Reservation__c);
						tempReservation.Plc_Status__c='NotReserved';
						reservationToRelase.add(tempReservation);
					}
				}
			}

			try{


				for(WorkOrderLineItem workOrderLineItem : workOrderLineItems){

					if(workOrderLineItem.id == null){
						workOrderLineItem.WorkOrderId = workOrderToUpdate.id;
					}
				}

				if(AssetIdWoliMap.size()>0){
					for(WorkOrderLineItem tempWOLI : AssetIdWoliMap.values()){
						assetWoliLineItemList.add(tempWOLI);
					}
				}

				for(WorkOrderLineItem workOrderLineItem : assetWoliLineItemList){

					if(workOrderLineItem.id == null){
						workOrderLineItem.WorkOrderId = workOrderToUpdate.id;
					}
				}

				if(assetWoliLineItemList.size()>0){
					upsert assetWoliLineItemList;
				}

				if(workOrderLineItems.size()>0 ){
					upsert workOrderLineItems;
				}
				for(WorkOrderLineItem assetWoliLineItemList1 : assetWoliLineItemList){
					System.debug('ASSETWOLIITEM: '+assetWoliLineItemList1);
				}
				for(WorkOrderLineItem workOrderLineItems1 : workOrderLineItems){
					System.debug('NORMALWOLIITEM: '+workOrderLineItems1);
				}
				
				
				//da qui
				workOrderLineItems.clear();
				assetWoliLineItemList.clear();
				

				//Chiusura dei line item residui per Wsict in caso non vengano inviati nel payload
				//Controlli per Monetica per verificare se ci sono dei WOLI non ancora eseguiti
				if(workOrder.workorderDetail.status=='Closed'){ 
					beginExecutionStep1=Datetime.now();
					Map<String, WorkOrder> workOrdersToExecute2 = retrieveWorkOrders(workOrderAlias);
					endExecutionStep1 = Datetime.now();
					executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

					//Do this to close all line item
					for(String workOrderLegacyId : workOrdersToExecute2.keySet()){
						for(WorkOrderLineItem workOrderLineItem : workOrdersToExecute2.get(workOrderLegacyId).workOrderLineItems){
							System.debug('WOLITODEBUG: '+workOrderLineItem.Plc_Alias__c+'<-ALIAS '+workOrderLineItem.status+'<-STATUS');
							if(sourceExtSystem=='MONETICA'){
								if(workOrderLineItem.status.equalsIgnoreCase(WORK_ORDER_LINE_ITEM_TOEXECUTE)){
									outcomeMessage = '[ERR:CL-00E0618] Line item with alias: ' + workOrderLineItem.Plc_Alias__c + ' has not been executed yet.\n';
									if(reservationIdInSystem.containsKey(workOrderLineItem.Plc_Reservation__c) && workOrderLineItem.Plc_OperationType__c !='NoOperation'){
										Plc_Reservation__c tempReservation = reservationIdInSystem.get(workOrderLineItem.Plc_Reservation__c);
										tempReservation.Plc_Status__c='NotReserved';
										reservationToRelase.add(tempReservation);
									}
									break;
								}
							}else{
								if(!workOrderLineItem.status.equalsIgnoreCase(WORK_ORDER_LINE_ITEM_EXECUTED)){
									workOrderLineItem.status='NotExecuted';
									workOrderLineItems.add(workOrderLineItem);
									if(reservationIdInSystem.containsKey(workOrderLineItem.Plc_Reservation__c) && workOrderLineItem.Plc_OperationType__c !='NoOperation'){
										Plc_Reservation__c tempReservation = reservationIdInSystem.get(workOrderLineItem.Plc_Reservation__c);
										tempReservation.Plc_Status__c='NotReserved';
										reservationToRelase.add(tempReservation);
									}
								}
							}
						}
					}
					if(workOrderLineItems.size()>0){
						update workOrderLineItems;
					}
				}

				if(reservationToRelase.size()>0){
					update reservationToRelase;
				}
				if(String.isNotBlank(outcomeMessage)){
					
					serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0619] ' + outcomeMessage;serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T020]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
					Database.rollback(sp);
					return serviceResponse;
				}
				

				LogTracker.debugLog(CLASS_NAME, 'workOrdersFullfilment', '@@ workOrderToUpdate: ' + workOrderToUpdate);
				update workOrderToUpdate;

				LogTracker.debugLog(CLASS_NAME, 'workOrdersFullfilment', 'workOrderPartial: ' + workOrderPartial);
				LogTracker.debugLog(CLASS_NAME, 'workOrdersFullfilment', 'workOrderLineItemPartial: ' + workOrderLineItemPartial);
				//Insert Partial Line Item
				if(workOrderToUpdate.Status=='Assigned'){
					Boolean result = (Boolean) Plc_WorkOrderApxAct.oncloseWorkOrderWithFilters(workOrderPartial,null);
					LogTracker.debugLog(CLASS_NAME, 'workOrdersFullfilment', 'insertPartialLineItem: ' + result);
				}

			} catch (DMLException ex){

				
				serviceResponse.outcomeCode = '603';
				serviceResponse.outcomeMessage = '[ERR:CL-00E0620] ' + ex.getDMLMessage(0);
				serviceResponse.executionTimeStep1 = executionTimeStep1;
				LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T021]' + executionTimeStep1);
				serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
				LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', 'Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());
				Database.rollback(sp);
				return serviceResponse;

			} catch (Exception ex){
				serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0620] ' + ex.getMessage();serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T021]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', 'Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());Database.rollback(sp);
				return serviceResponse;
			}
			//composes responseData
			Plc_Wrappers.AggiornaOrdineResponseData responseData = new Plc_Wrappers.AggiornaOrdineResponseData();
			responseData.workOrderId = workOrderToUpdate.Id;
			responseData.workOrderLegacyId = workOrder.workOrderLegacyId;
			responseData.updated = true;
			responseData.outcomeMessage = null;
			responseDataList.add(responseData);
			
			serviceResponse.contextLink = '/lightning/r/WorkOrder/' + workOrderToUpdate.Id + '/view';
			//FB 19-06-2019: NEXIPLC-641 [START]
			serviceResponse.recordId = workOrderToUpdate.Id;
			//FB 19-06-2019: NEXIPLC-641 [END]
			if(warningForToRemove != null ){
				serviceResponse.outcomeCode = '210';
				serviceResponse.outcomeMessage = warningForToRemove;
			}else{
				serviceResponse.outcomeCode = '200';
			}
			serviceResponse.responseDataList = responseDataList;
			serviceResponse.executionTimeStep1 = executionTimeStep1;
			LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T022]' + executionTimeStep1);
			serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
			LogTracker.debugLogEnd(CLASS_NAME,'workOrdersFullfilment');
			return serviceResponse;
		} catch (Exception ex){
			
			serviceResponse.outcomeCode = '603';serviceResponse.outcomeMessage = '[ERR:CL-00E0621] ' + ex.getMessage();serviceResponse.executionTimeStep1 = executionTimeStep1;LogTracker.debugLogBegin(CLASS_NAME,'workOrdersFullfilment', '## [executionTimeStep1 T023]' + executionTimeStep1);serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());LogTracker.debugLog('Plc_WorkOrdersServices', 'workOrdersCreate', 'Error: ' + ex.getMessage() + ' at line: ' + ex.getStackTraceString());
			Database.rollback(sp);
			
			return serviceResponse;
		}
	}

	/**
	 * [retrieveWorkOrders description]
	 * @param  workOrderAlias [description]
	 * @return                [description]
	 * @code 07
	 */
	public static Map<String, WorkOrder> retrieveWorkOrders(Set<String> workOrderAlias){

		Map<String, WorkOrder> workOrdersMap = new Map<String, WorkOrder>();
		for(WorkOrder workOrder : [SELECT Id, Plc_Alias__c, Plc_LegacyWarehouseId__c, Plc_Abi__c,
								   Plc_BankDescription__c, Plc_ServicePoint__c, Plc_LegacyServicePointId__c,
								   Plc_Vat__c, Plc_FiscalCode__c, Plc_SiaCode__c, Plc_LegacyAccountId__c,
								   Street, PostalCode, City, State, Plc_Prefix__c,
								   Plc_Phone__c, Plc_Email__c, Plc_Cti__c, Plc_CustomerCare__c,
								   Plc_OpeingHours__c, Plc_Contact__c, StartDate, EndDate, RecordTypeId,
								   Status,
								   (SELECT Id, Plc_Alias__c, Plc_ExternalCatalogItem__c,Plc_TermIdOld__c,Plc_TermId__c,Plc_StockSerial__c,Plc_ExternalCatalogItem__r.Plc_ProductSku__c,Plc_ExternalCatalogItem__r.Plc_Solution__c,
								   Plc_LogisticDivision__c, Plc_OperationType__c,Plc_Closed__c, Status,Plc_ExternalCatalogItem__r.Plc_Category__c,Plc_Parent__c,ParentWorkOrderLineItemId,
								   Plc_SerialNumber__c, Plc_BundleId__c, Plc_Reservation__c
								   FROM WorkOrderLineItems)
								   FROM WorkOrder
								   WHERE Plc_Alias__c IN: workOrderAlias]){

			workOrdersMap.put(workOrder.Plc_Alias__c, workOrder);
		}

		return workOrdersMap;
	}

	public static boolean checkValidityWorkOrder (String workOrderId, Boolean alreadyClosed){
		Boolean alreadyClosedTrue;
		if(workOrderId.length()==20){
			alreadyClosedTrue = true;
			workOrderId = workOrderId + '1';
		}
		if(workOrderId.length()==21){
			alreadyClosedTrue = true;
						workOrderId = workOrderId + '2';

		}
		if(workOrderId.length()==22){
			alreadyClosedTrue = false;
			workOrderId = workOrderId + '1';

		}
		if(alreadyClosed){
			alreadyClosedTrue = true;
			workOrderId = workOrderId + '2';

		}
		if(alreadyClosed){
			alreadyClosedTrue = true;
			workOrderId = workOrderId + '1';

		}
		if(alreadyClosed){
			alreadyClosedTrue = false;
			alreadyClosed = true;
		}
		return false;
	}


	/**
	 * [retrieveWorkOrdersLineItemToExecute description]
	 * @return [description]
	 * @code 08
	 */
	public static Map<String,WorkOrderLineItem> retrieveWorkOrdersLineItemToExecute(){
		Map<String, WorkOrderLineItem> workOrderLineItemMap = new Map<String, WorkOrderLineItem>();
		for(WorkOrderLineItem workOrderLienItemTemp : [SELECT Id, Plc_Alias__c, Plc_ExternalCatalogItem__c, Plc_TermId__c,
													   Plc_LogisticDivision__c, Plc_OperationType__c, Status,Plc_SerialNumber__c, Plc_BundleId__c
													   FROM WorkOrderLineItem]){
			workOrderLineItemMap.put(workOrderLienItemTemp.Plc_Alias__c,workOrderLienItemTemp);
		}
		return workOrderLineItemMap;
	}

	/**
	 * [retrieveReservationToExecute description]
	 * @param  reservationIdLegacy [description]
	 * @return                     [description]
	 * @code 09
	 */
	public static Map<String,Plc_Reservation__c> retrieveReservationToExecute(Set<String> reservationIdLegacy){
		Map<String,Plc_Reservation__c> reservationMap = new Map<String,Plc_Reservation__c>();
		for(Plc_Reservation__c reservationTemp : [SELECT Id,Plc_Alias__c,Plc_Status__c FROM Plc_Reservation__c WHERE Plc_Alias__c IN :reservationIdLegacy]){
			reservationMap.put(reservationTemp.Plc_Alias__c,reservationTemp);
		}
		return reservationMap;
	}

	/**
	 * [retrieveExternalCatalogItemObject description]
	 * @param  resourceAliasIds [description]
	 * @return                  [description]
	 * @code 11
	 */
	public static Map<String, B2WExtCat__External_Catalog_Item__c> retrieveExternalCatalogItemObject(List<String> resourceAliasIds){
		Map<String, B2WExtCat__External_Catalog_Item__c> resourceAliasMap = new Map<String, B2WExtCat__External_Catalog_Item__c>();
		for(B2WExtCat__External_Catalog_Item__c externalCatalogItem : [SELECT Id, Plc_ProductSku__c,Plc_Manufacturer__r.Plc_Alias__c,Plc_Subcategory__c,Plc_Category__c,Plc_Solution__c
																	   FROM B2WExtCat__External_Catalog_Item__c
																	   WHERE Plc_ProductSku__c IN: resourceAliasIds])
		{
			resourceAliasMap.put(externalCatalogItem.Plc_ProductSku__c, externalCatalogItem);
		}
		return resourceAliasMap;
	}

	/**
	 * [retrieveTermIdCodes description]
	 * @param  workOrders [description]
	 * @return            [description]
	 * @code 12
	 */
	public static Map<String, String> retrieveTermIdCodes (List<Plc_Wrappers.GestioneOrdineRequestBody> workOrders) {
		List<String> termIdCodeList = new List<String>();
		Map<String, String> termIdCodeMap = new Map<String, String>();

		for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : workOrders) {
			for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem) {
				termIdCodeList.add(workOrderLineItem.workOrderLineItemDetail.termId);
				if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.termIdOld)){
					termIdCodeList.add(workOrderLineItem.workOrderLineItemDetail.termIdOld);
				}
			}
		}
		for (Plc_TermId__c termId : [SELECT Id, Plc_TermIdCode__c FROM Plc_TermId__c WHERE Plc_TermIdCode__c IN :termIdCodeList]) {
			termIdCodeMap.put(termId.Plc_TermIdCode__c, termId.Id);
		}
		return termIdCodeMap;
	}

	public static ServiceResponse composeError(ServiceResponse serviceResponse, String errorCode ,String errorMessage , Integer executionTimeStep1, Integer executionTimeStep2){
		serviceResponse.outcomeCode = errorCode;
		serviceResponse.outcomeMessage = errorMessage;
		serviceResponse.executionTimeStep1 = executionTimeStep1;
		serviceResponse.executionTimeStep2 = executionTimeStep2;
		return serviceResponse;
	}
	/**
	 * [retrieveStockSerials description]
	 * @param  serialNumbers [description]
	 * @return               [description]
	 * @code 13
	 */
	public static Map<String, Bit2Shop__Stock_Serials2__c> retrieveStockSerials(Integer typeOfSearch, Set<String> stockSerialIdSetOnTime,Set<String> simToSearchInEncoded,Set<String> simToSearchInOther,String sourceExtSystem, Map<String,String> serialNumbersUniqueToSingle, Map<String,String> stockSerial2Warehouse, List<String> warehouseAlias , Boolean searchInAllWarehouse) {

        LogTracker.debugLogBegin(CLASS_NAME, 'retrieveStockSerials');
        Map<String, Bit2Shop__Stock_Serials2__c> stockSerialMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
        
        /*	RF 2019_0516: Search on the last 8 char for Encoded Serial Number
        	START PART 1
        	- Data variables
        */
        // serialsToSearchMap contains pairs short serial/long serial found in WO --> [79843700, 0579843700]
        Map<String, String> deviceTrimmedMap = new Map<String, String>();
		Map<String, String> deviceToFind = new Map<String, String>();
		Map<String,Bit2Shop__Stock_Serials2__c> resultMap = new  Map<String,Bit2Shop__Stock_Serials2__c>();
        
		System.debug('typeOfSearch'+typeOfSearch);
        for(String deviceSerial : stockSerialIdSetOnTime) {
			deviceToFind.put(deviceSerial.toUpperCase() ,deviceSerial.right(8).toUpperCase() );
        	deviceTrimmedMap.put(deviceSerial.right(8).toUpperCase() , deviceSerial.toUpperCase() );
        }

		System.debug('#deviceToFind: '+deviceToFind);
		System.debug('#deviceTrimmedMap: '+deviceTrimmedMap);

		System.debug('#stockSerialIdSetOnTime: '+stockSerialIdSetOnTime);


        /*	RF 2019_0516: Search on the last 8 char for Encoded Serial Number
        	END PART 1
        */

		String queryToExecute ='SELECT Id, Bit2Shop__Product_Stock_Id__c, Plc_DllSerialNumberUnique__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,'+
                                    'Bit2Shop__Status__c,Plc_ProductSku__c,Plc_ManufacturerSerialNumber__c,Plc_DllSerialNumber__c,'+
                                    'Plc_EncodedSerialNumber__c,Plc_EncodedSerialNumberUnique__c,Plc_ManufacturerSerialNumberUnique__c,Plc_EncodedSerialNumberShort__c,Plc_EncodedSerialNumberFirst19__c, '+
                                    'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,'+
									'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,'+
									'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,'+
                                    'Bit2Shop__Warehouse_Id__r.Plc_Alias__c FROM Bit2Shop__Stock_Serials2__c WHERE ';
        //FB 12-06-2019: Adding field Plc_EncodedSerialNumberFirst19__c to query

		if(searchInAllWarehouse == false){
			String searchInWarehouseSpecified = ' Bit2Shop__Warehouse_Id__r.Plc_Alias__c IN: warehouseAlias AND ';
			queryToExecute = queryToExecute + searchInWarehouseSpecified;
		}

        if(typeOfSearch==1){ // Query for SIM and Device

            queryToExecute = queryToExecute +' ((Plc_EncodedSerialNumberUnique__c IN :stockSerialIdSetOnTime OR Plc_ManufacturerSerialNumberUnique__c IN :stockSerialIdSetOnTime OR Plc_DllSerialNumberUnique__c IN :stockSerialIdSetOnTime) OR (Plc_EncodedSerialNumberUnique__c IN :simToSearchInEncoded) OR (Plc_ManufacturerSerialNumberUnique__c IN :simToSearchInOther OR Plc_EncodedSerialNumberFirst19__c IN :simToSearchInOther) )';

        }else if (typeOfSearch==2){ // Query only Device

            queryToExecute =  queryToExecute+' ((Plc_EncodedSerialNumberUnique__c IN: stockSerialIdSetOnTime OR Plc_ManufacturerSerialNumberUnique__c IN: stockSerialIdSetOnTime OR Plc_DllSerialNumberUnique__c IN: stockSerialIdSetOnTime) )';

        }else if(typeOfSearch==3){ // Query only SIM

            queryToExecute = queryToExecute+' ((Plc_EncodedSerialNumberUnique__c IN :simToSearchInEncoded) OR (Plc_ManufacturerSerialNumberUnique__c IN :simToSearchInOther OR Plc_EncodedSerialNumberFirst19__c IN :simToSearchInOther) )';
        }
		
		

		System.debug('#QUERY# '+queryToExecute);

		Boolean alreadyInsertedInThisSerial = true;
		String key;

        for(Bit2Shop__Stock_Serials2__c stockSerial : Database.query(queryToExecute) ){
			
	        /*	RF 2019_0516: Search on the last 8 char for Encoded Serial Number
	        	END PART 2
	        */
			// Enter here only if it is a Device
			if(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c!='SIM'){
				if (String.isNotBlank(stockSerial.Plc_EncodedSerialNumberUnique__c)) {
					key = stockSerial.Plc_EncodedSerialNumberUnique__c.toUpperCase();
						if ( deviceToFind.containsKey(key) ) {
							deviceToFind.remove(key);
						}
						if(stockSerialMap.containsKey(key) && stockSerialMap.get(key).Id != stockSerial.Id){
							throw new Plc_Exception('[ERR:CL-00E0642] It is not possible to identify uniquely the serial because the unique key: '+key+' is duplicated in the system','602');
						}
						stockSerialMap.put(key, stockSerial);
						serialNumbersUniqueToSingle.put(key,stockSerial.Plc_EncodedSerialNumber__c);

				}
				if (String.isNotBlank(stockSerial.Plc_ManufacturerSerialNumberUnique__c) ) { 
					key = stockSerial.Plc_ManufacturerSerialNumberUnique__c.toUpperCase();
						if ( deviceToFind.containsKey(key) ) {
							deviceToFind.remove(key );
						}
						if(stockSerialMap.containsKey(key) && stockSerialMap.get(key).Id != stockSerial.Id){
							throw new Plc_Exception('[ERR:CL-00E0642] It is not possible to identify uniquely the serial because the unique key: '+key+' is duplicated in the system','602');
						}
						stockSerialMap.put(key, stockSerial);
						serialNumbersUniqueToSingle.put(key,stockSerial.Plc_ManufacturerSerialNumber__c);
				}
				if (String.isNotBlank(stockSerial.Plc_DllSerialNumberUnique__c)) {
					key = stockSerial.Plc_DllSerialNumberUnique__c.toUpperCase();
						if(deviceToFind.containsKey(key)){
							deviceToFind.remove(key);
						}
						if(stockSerialMap.containsKey(key) && stockSerialMap.get(key).Id != stockSerial.Id){
							throw new Plc_Exception('[ERR:CL-00E0642] It is not possible to identify uniquely the serial because the unique key: '+key+' is duplicated in the system','602');
						}
						stockSerialMap.put(key, stockSerial);
						serialNumbersUniqueToSingle.put(key,stockSerial.Plc_DllSerialNumber__c);
				}
				continue;
			}
				
			//Enter below only if it a SIM
			if( String.isNotBlank(stockSerial.Plc_EncodedSerialNumberUnique__c) ){
				key = stockSerial.Plc_EncodedSerialNumberUnique__c.toUpperCase();

				if(stockSerial.Plc_EncodedSerialNumber__c.length()==20 || stockSerial.Plc_EncodedSerialNumber__c.length()==19 ){
					if(simToSearchInEncoded.contains(stockSerial.Plc_EncodedSerialNumberUnique__c) ){
						if(stockSerialMap.containsKey(key)){
							throw new Plc_Exception('[ERR:CL-00E0642] It is not possible to identify uniquely the serial because the unique key: '+key+' is duplicated in the system','602');
						}
						stockSerialMap.put(key, stockSerial);
						serialNumbersUniqueToSingle.put(key,stockSerial.Plc_EncodedSerialNumber__c);
						continue;
					}
				}
			}
			if (String.isNotBlank(stockSerial.Plc_ManufacturerSerialNumberUnique__c) ){
				key = stockSerial.Plc_ManufacturerSerialNumberUnique__c.toUpperCase();

				if(stockSerial.Plc_ManufacturerSerialNumber__c.length()==19 || stockSerial.Plc_ManufacturerSerialNumber__c.length()==16 ){
					if(simToSearchInOther.contains(stockSerial.Plc_ManufacturerSerialNumberUnique__c) ){
						if(stockSerialMap.containsKey(key)){
							throw new Plc_Exception('[ERR:CL-00E0642] It is not possible to identify uniquely the serial because the unique key: '+key+' is duplicated in the system','602');
						}
						stockSerialMap.put(key, stockSerial);
                    	serialNumbersUniqueToSingle.put(key,stockSerial.Plc_ManufacturerSerialNumber__c);
						continue;
					}
				}
			}
			if(String.isNotBlank(stockSerial.Plc_EncodedSerialNumberFirst19__c) && String.isNotBlank(stockSerial.Plc_EncodedSerialNumber__c) ){
				key = stockSerial.Plc_EncodedSerialNumberFirst19__c.toUpperCase();
				if(stockSerial.Plc_EncodedSerialNumber__c.length()==20 ){
					if(simToSearchInOther.contains(key) ){
						if(stockSerialMap.containsKey(key)){
							throw new Plc_Exception('[ERR:CL-00E0642] It is not possible to identify uniquely the serial because the unique key: '+key+' is duplicated in the system','602');
						}
						stockSerialMap.put(key, stockSerial);
                    	serialNumbersUniqueToSingle.put(key,stockSerial.Plc_EncodedSerialNumber__c);
						continue;
					}
				}
			}
		}
		
		/*	RF 2019_0516: Search on the last 8 char for Encoded Serial Number
        	START PART 3
        	- Searching serials not found previously trying to look for last 8 chars of encoded serial
        	- In case there are some matches, the results are returned
        	- If there are any errors, they are returned
        */
        if(deviceToFind.size()>0){
        	Set<String> deviceTrimmedSet = deviceTrimmedMap.keySet();
			queryToExecute ='SELECT Id, Bit2Shop__Product_Stock_Id__c, Plc_DllSerialNumberUnique__c,'+
                                    'Bit2Shop__Status__c,Plc_ProductSku__c,Plc_ManufacturerSerialNumber__c,Plc_DllSerialNumber__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c,'+
                                    'Plc_EncodedSerialNumber__c,Plc_EncodedSerialNumberUnique__c,Plc_ManufacturerSerialNumberUnique__c,Plc_EncodedSerialNumberShort__c,'+
                                    'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c,'+
									'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Category__c,'+
									'Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__c,'+
                                    'Bit2Shop__Warehouse_Id__r.Plc_Alias__c FROM Bit2Shop__Stock_Serials2__c WHERE ';
			if(searchInAllWarehouse == false ){
				queryToExecute = queryToExecute + ' Bit2Shop__Warehouse_Id__r.Plc_Alias__c IN :warehouseAlias AND ';
			}
			
			queryToExecute = queryToExecute + 'Plc_EncodedSerialNumberShort__c IN :deviceTrimmedSet';

			for(Bit2Shop__Stock_Serials2__c srl : Database.query(queryToExecute) ){
				if(!resultMap.containsKey(srl.Plc_EncodedSerialNumberShort__c.toUpperCase() ) ){
					resultMap.put(srl.Plc_EncodedSerialNumberShort__c.toUpperCase() ,srl);
				}else{
					throw new Plc_Exception('[ERR:CL-00E0641] The indicated serial cannot be found, and not is possible to be found with the last 8 characters because there are two or more identical serial with the last 8 characters: '+srl.Plc_EncodedSerialNumberShort__c,'602');
				}
			}//
		}
        
		for(String result : resultMap.keySet() ){
			stockSerialMap.put(deviceTrimmedMap.get(result).toUpperCase() , resultMap.get(result) );
			serialNumbersUniqueToSingle.put(deviceTrimmedMap.get(result).toUpperCase() , resultMap.get(result).Plc_EncodedSerialNumber__c );
		}
	           
        LogTracker.debugLogEnd(CLASS_NAME, 'retrieveStockSerials');
        return stockSerialMap;
    }
}