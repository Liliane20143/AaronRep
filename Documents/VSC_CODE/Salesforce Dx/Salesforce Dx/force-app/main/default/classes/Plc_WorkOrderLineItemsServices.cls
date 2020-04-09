/**
 * PLC Work Orders Rest WebService
 *
 * @author Emanuele Campese
 * @version 1.0
 * @description 
 * @testedIn 
 * @code
 * @errorcode [ERR:CL-XXXYYZZ]
 * @history
 * 2019-01-15 : Emanuele Campese
 */
public with sharing class Plc_WorkOrderLineItemsServices extends Plc_ServiceWs {

    /**
     * used to create work orders and related work order line items
     * @param  requestList list requests from payload
     * @return             map that has the response code as key and a list of responsedata as values
     */
     @testVisible private static final String WORK_ORDER_LINE_ITEM_EXECUTED = 'Executed';
     private static final String CLASS_NAME = 'Plc_WorkOrderLineItemsServices';

    public static ServiceResponse workOrderLineItemCheck(Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody, String sourceExtSystem) {        
        ServiceResponse serviceResponse = new ServiceResponse();
        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;
        Integer executionTimeStep2 = 0;
        Datetime endExecutionStep2 = Datetime.now();
        Datetime beginExecutionStep2 = Datetime.now();

        List<Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData> responseDataList = new List<Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData>();
        Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData responseData = new Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData();
        Map<String,String> serialNumbers = new Map<String,String>();
        List<String> workOrderLineItemAlias = new List<String>();
        Map<String, String> stockSerialMap = new Map<String, String>();
        Map<String, String> serialToFind = new Map<String, String>();
        Map<String, String> solutionForSerial = new Map<String, String>();
        Map<String, String> subcategoryForSerial = new Map<String, String>();
        Map<String, String> manufacturerSerialKey = new Map<String, String>();
        Map<String, String> manufacturerForSerial = new Map<String, String>();
        Map<String, String> productSkuForSerial = new Map<String, String>();
        Map<String, String> woliManufacturer = new Map<String, String>();
        Map<String, String> woliProductSku = new Map<String, String>();
        Map<String, String> woliSerialSolution = new Map<String, String>();
        Map<String, String> woliSerialSubcategory = new Map<String, String>();

        LogTracker.debugLogBegin(CLASS_NAME, 'workOrderLineItemCheck SINGLE');

        if(String.isBlank(requestBody.workOrderLegacyId)){
            serviceResponse.outcomeCode = '604';
            serviceResponse.outcomeMessage = 'workOrderLegacyId is blank or null.';
            return serviceResponse;
        }

        List<WorkOrder> workOrder = [SELECT id FROM WorkOrder WHERE Plc_Alias__c =: requestBody.workOrderLegacyId LIMIT 1];
        if(workOrder.isEmpty()){

            serviceResponse.outcomeCode = '204';
            return serviceResponse;
        }
        System.debug('requestBody***workOrderLineItem:'+requestBody.workOrderLineItem);
        for(Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro workOrderLineItem : requestBody.workOrderLineItem){

            if(String.isBlank(workOrderLineItem.workOrderLineItemLegacyId)){
                serviceResponse.outcomeCode = '604';
                serviceResponse.outcomeMessage = 'workOrderLineItemLegacyId is blank or null.';
                return serviceResponse;
            }
            if(String.isBlank(workOrderLineItem.serialNumber)){
                serviceResponse.outcomeCode = '604';
                serviceResponse.outcomeMessage = 'serialNumber is blank or null.';
                return serviceResponse;
            }
            serialNumbers.put(workOrderLineItem.workOrderLineItemLegacyId,workOrderLineItem.serialNumber);
            //workOrderLineItemAlias.add(workOrderLineItem.workOrderLineItemLegacyId);
        }
        System.debug('serialNumbers: '+serialNumbers);

        MAP<string,string> stockSerial2IdMap = new MAP<string,string>();

        beginExecutionStep1 = Datetime.now();

        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
        
        for(Bit2Shop__Stock_Serials2__c stockSerial : [SELECT id, Plc_DllSerialNumber__c,Bit2Shop__Status__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c,
                                                            Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c,Plc_EncodedSerialNumber__c,
                                                            Plc_ManufacturerSerialNumber__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c
                                                        FROM Bit2Shop__Stock_Serials2__c 
                                                        WHERE (Plc_DllSerialNumber__c IN: serialNumbers.values() OR
                                                            Plc_EncodedSerialNumber__c IN: serialNumbers.values() OR
                                                            Plc_ManufacturerSerialNumber__c IN: serialNumbers.values())]){
            System.debug('STOCK SERIAL OBJECT: '+stockSerial);
            //PM 20191105 NEXIPLC-749[START]
            //Deleted status filter

            if(String.isNotBlank(stockSerial.Plc_DllSerialNumber__c)){
                stockSerial2IdMap.put(stockSerial.Plc_DllSerialNumber__c,stockSerial.id);
                manufacturerSerialKey.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_DllSerialNumber__c,stockSerial.Plc_DllSerialNumber__c);
                //manufacturerForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c,stockSerial.Plc_DllSerialNumber__c);
                productSkuForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_DllSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c);
                solutionForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_DllSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c);
                subcategoryForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_DllSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c);
            }
            if(String.isNotBlank(stockSerial.Plc_EncodedSerialNumber__c)){
                stockSerial2IdMap.put(stockSerial.Plc_EncodedSerialNumber__c,stockSerial.id);
                manufacturerSerialKey.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_EncodedSerialNumber__c,stockSerial.Plc_EncodedSerialNumber__c);
                //manufacturerForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c,stockSerial.Plc_EncodedSerialNumber__c);
                productSkuForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_EncodedSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c);
                solutionForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_EncodedSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c);
                subcategoryForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_EncodedSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c);
            }
            if(String.isNotBlank(stockSerial.Plc_ManufacturerSerialNumber__c)){
                stockSerial2IdMap.put(stockSerial.Plc_ManufacturerSerialNumber__c,stockSerial.id);
                manufacturerSerialKey.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_ManufacturerSerialNumber__c,stockSerial.Plc_ManufacturerSerialNumber__c);
                //manufacturerForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c,stockSerial.Plc_ManufacturerSerialNumber__c);
                productSkuForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_ManufacturerSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c);
                solutionForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_ManufacturerSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c);
                subcategoryForSerial.put(stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Manufacturer__r.Plc_Alias__c+'_'+stockSerial.Plc_ManufacturerSerialNumber__c,stockSerial.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c);
            }
            //PM 20191105 NEXIPLC-749[END]
            

        }

        for(WorkOrderLineItem workOrderLineItem : [SELECT Plc_ExternalCatalogItem__r.Plc_Manufacturer__r.Plc_Alias__c, 
                                                          Plc_Alias__c,Plc_ExternalCatalogItem__r.Plc_Solution__r.Plc_Alias__c,Plc_ExternalCatalogItem__r.Plc_ProductSku__c,Plc_ExternalCatalogItem__r.Plc_Subcategory__c
                                                   FROM WorkOrderLineItem WHERE Plc_Alias__c IN: serialNumbers.keySet()]){
            woliSerialSolution.put(workOrderLineItem.Plc_Alias__c,workOrderLineItem.Plc_ExternalCatalogItem__r.Plc_Solution__r.Plc_Alias__c);
            woliManufacturer.put(workOrderLineItem.Plc_Alias__c,workOrderLineItem.Plc_ExternalCatalogItem__r.Plc_Manufacturer__r.Plc_Alias__c);
            woliProductSku.put(workOrderLineItem.Plc_Alias__c,workOrderLineItem.Plc_ExternalCatalogItem__r.Plc_ProductSku__c);
            woliSerialSubcategory.put(workOrderLineItem.Plc_Alias__c,workOrderLineItem.Plc_ExternalCatalogItem__r.Plc_Subcategory__c);
        }
       
        System.debug('woliSerialSolution: '+woliSerialSolution);
        System.debug('woliManufacturer: '+woliManufacturer);
        System.debug('woliProductSku: '+woliProductSku);
        

        responseData.workOrderLegacyId = requestBody.workOrderLegacyId;
        System.debug('manufacturerSerialKey: '+manufacturerSerialKey);

        if(manufacturerSerialKey.isEmpty()){
            serviceResponse.outcomeCode = '602';
            serviceResponse.outcomeMessage = 'There are not Serial with this key in system';
            return serviceResponse;
        }
        
        System.debug('productSkuForSerial: '+productSkuForSerial);
        
        System.debug('solutionForSerial: '+solutionForSerial);
        System.debug('woliSerialSolution: '+woliSerialSolution);
        responseData.outcomeMessage = 'ToBeVerified';

        for(Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyRigheOrdineDiLavoro workOrderLineItem : requestBody.workOrderLineItem){
            for(String manufacuterSerial : manufacturerSerialKey.keySet()){
                if(productSkuForSerial.get(manufacuterSerial) == woliProductSku.get(workOrderLineItem.workOrderLineItemLegacyId) ){
                    responseData.serialNumber = workOrderLineItem.serialNumber;
                    responseData.workOrderLineItemLegacyId = workOrderLineItem.workOrderLineItemLegacyId;
                    responseData.usable = true;
                    responseData.outcomeMessage = null;
                    serviceResponse.outcomeCode = '200';
                    /*
                    IF( manufacturerSerialKey.get(workOrderLineItem.serialNumber) != null ){
                        //String serialstock2Id = serialSolution.get(workOrderLineItem.serialNumber);
                        serviceResponse.contextLink = '/lightning/r/Bit2Shop__Stock_Serials2__c/';
                    }*/
                    serviceResponse.responseDataList.add(responseData);
                    serviceResponse.executionTimeStep1 = executionTimeStep1; 
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    LogTracker.debugLogEnd(CLASS_NAME, 'workOrderLineItemCheck SINGLE');
                    return serviceResponse;
                }
                if(solutionForSerial.get(manufacuterSerial) == woliSerialSolution.get(workOrderLineItem.workOrderLineItemLegacyId) ){
                    responseData.serialNumber = workOrderLineItem.serialNumber;
                    responseData.workOrderLineItemLegacyId = workOrderLineItem.workOrderLineItemLegacyId;
                    responseData.usable = true;
                    responseData.outcomeMessage = null;
                    serviceResponse.outcomeCode = '200';
                    /*
                    IF( manufacturerSerialKey.get(workOrderLineItem.serialNumber) != null ){
                        //String serialstock2Id = serialSolution.get(workOrderLineItem.serialNumber);
                        serviceResponse.contextLink = '/lightning/r/Bit2Shop__Stock_Serials2__c/';
                    }*/
                    serviceResponse.responseDataList.add(responseData);
                    serviceResponse.executionTimeStep1 = executionTimeStep1; 
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    LogTracker.debugLogEnd(CLASS_NAME, 'workOrderLineItemCheck SINGLE');
                    return serviceResponse;
                }
                if(subcategoryForSerial.get(manufacuterSerial) == woliSerialSubcategory.get(workOrderLineItem.workOrderLineItemLegacyId) ){
                    responseData.serialNumber = workOrderLineItem.serialNumber;
                    responseData.workOrderLineItemLegacyId = workOrderLineItem.workOrderLineItemLegacyId;
                    responseData.usable = true;
                    responseData.outcomeMessage = null;
                    serviceResponse.outcomeCode = '200';
                    /*
                    IF( manufacturerSerialKey.get(workOrderLineItem.serialNumber) != null ){
                        //String serialstock2Id = serialSolution.get(workOrderLineItem.serialNumber);
                        serviceResponse.contextLink = '/lightning/r/Bit2Shop__Stock_Serials2__c/';
                    }*/
                    serviceResponse.responseDataList.add(responseData);
                    serviceResponse.executionTimeStep1 = executionTimeStep1; 
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    LogTracker.debugLogEnd(CLASS_NAME, 'workOrderLineItemCheck SINGLE');
                    return serviceResponse;
                }

            }
            if(responseData.outcomeMessage != null){
                serviceResponse.outcomeCode = '602';
                serviceResponse.outcomeMessage = 'The Solution of the product in Work Order Line Item and related Solution Serial do not match OR The product not is the same of the Work Order Line Item';
            }

            /*
            system.debug('Shahid::::' + stockSerialMap);
            if(serialSolution.containsKey(workOrderLineItem.serialNumber) &&
                woliSerialSolution.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
                if(serialSolution.get(workOrderLineItem.serialNumber) == 
                    woliSerialSolution.get(workOrderLineItem.workOrderLineItemLegacyId)){

                    responseData.serialNumber = workOrderLineItem.serialNumber;
                    responseData.workOrderLineItemLegacyId = workOrderLineItem.workOrderLineItemLegacyId;
                    responseData.usable = true;
                    responseData.outcomeMessage = null;
                    serviceResponse.outcomeCode = '200';
                    IF( serialSolution.get(workOrderLineItem.serialNumber) != null ){
                        String serialstock2Id = serialSolution.get(workOrderLineItem.serialNumber);
                        serviceResponse.contextLink = '/lightning/r/Bit2Shop__Stock_Serials2__c/' + serialstock2Id + '/view';
                    }
                    
                } else {

                    serviceResponse.outcomeCode = '602';
                    serviceResponse.outcomeMessage = 'The Solution of the products in Work Order Line Item and related Solution Serial do not match.';
                    return serviceResponse;
                }
            } else {

                if(!serialSolution.containsKey(workOrderLineItem.serialNumber) ){

                    serviceResponse.outcomeCode = '208';
                    return serviceResponse;
                } else {

                    serviceResponse.outcomeCode = '204';
                    serviceResponse.outcomeMessage = 'workOrderLineItem with alias: "' + workOrderLineItem.workOrderLineItemLegacyId + '" is not in the system.';
                    return serviceResponse;
                }
            }*/
        }
        return serviceResponse;

    }
    /**
     * used to lock MASSIVE - ONTIME work orders and related work order line items
     * @param  requestList list requests from payload
     * @return             map that has the response code as key and a list of responsedata as values
     */

    public static ServiceResponse workOrdersLock(Plc_Wrappers.GestioneOrdineRequest requestList, String sourceExtSystem){

        ServiceResponse serviceResponse = new ServiceResponse();
        List<Plc_Wrappers.AggiornaOrdineResponseData> responseDataList = new List<Plc_Wrappers.AggiornaOrdineResponseData>();
        Map<String, WorkOrder> workOrderMap = new Map<String, WorkOrder>();
        Map<String, List<WorkOrderLineItem>> workOrderWorkOrderLineItemsMap = new Map<String, List<WorkOrderLineItem>>();
        Map<String, String> workOrderLineItemsWorkOrderLegacyIdMap = new Map<String, String>();
        Map<String, String> errorMessageMap = new Map<String, String>();
        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;
        Integer executionTimeStep2 = 0;
        Datetime endExecutionStep2 = Datetime.now();
        Datetime beginExecutionStep2 = Datetime.now();
        Set<String> workOrderAlias = new Set<String>();
        Set<String> reservationIdSet = new Set<String>();
        Set<String> workOrderLegacyIdSet = new Set<String>();
        Map<String, WorkOrder> workOrdersToUpdate = new Map<String, WorkOrder>();
        Map<String, WorkOrderLineItem> workOrderLineItemsToUpdate = new Map<String, WorkOrderLineItem>();
        Map<Id,Plc_Reservation__c> reservationToUpdate = new  Map<Id,Plc_Reservation__c>();
        List<WorkOrder> updListWorkOrder = new  List<WorkOrder>();
        List<WorkOrderLineItem> updListWorkOrderLineItem = new List<WorkOrderLineItem>();
        List<Plc_Reservation__c> updListReservation = new List<Plc_Reservation__c>();
        List<String> GetWOLIFromWO = new List<String>();
        List<String> resourceAliasList = new List<String>();
        List<String> warehouseAliasList = new List<String>();

        LogTracker.debugLogBegin(CLASS_NAME, 'workOrdersLock MASSIVE');

        for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder) {
            workOrderAlias.add(workOrder.workOrderLegacyId);
            warehouseAliasList.add(workOrder.workOrderDetail.warehouseAlias);
        }

        for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder){
            for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem) {
                resourceAliasList.add(workOrderLineItem.workOrderLineItemDetail.resourceAlias);
            }
        }
        

        beginExecutionStep1=Datetime.now();
        Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap = getWorkOrderConfigurationMap();
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

        beginExecutionStep1 = Datetime.now();
        workOrdersToUpdate = retrieveWorkOrdersToExecute(workOrderAlias);
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

        
        if(workOrdersToUpdate.isEmpty()){
            serviceResponse.outcomeCode = '204';
            serviceResponse.executionTimeStep1 = executionTimeStep1; 
            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()); 
            return serviceResponse;
        }

        try{

            Savepoint sp = Database.setSavepoint();

            for(String tempWorkOrderKey : workOrdersToUpdate.keySet()){
                WorkOrder workOrderTemp = workOrdersToUpdate.get(tempWorkOrderKey);
                for(WorkOrderLineItem workOrderLineItemTemp : workOrderTemp.workOrderLineItems){
                    workOrderLineItemsToUpdate.put(workOrderLineItemTemp.Plc_Alias__c,workOrderLineItemTemp);
                    reservationIdSet.add(workOrderLineItemTemp.Plc_Reservation__c);
                }
            }

            reservationToUpdate = Plc_ReservationsServices.retrieveReservation(reservationIdSet);

            beginExecutionStep1 = Datetime.now();
            Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(resourceAliasList,warehouseAliasList);
            endExecutionStep1 = Datetime.now();

            for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder){
                if(workOrdersToUpdate.containsKey(workOrder.workOrderLegacyId)){ // SE IL WORK ORDER E' PRESENTE NELLA LISTA RITORNATA DALLA QUERY
                    
                    for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){ //PER OGNI LINE ITEM

                        String workOrderConfigurationKey = workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
                        
                        if(workOrderLineItemsToUpdate.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){   // SE IL WORK ORDER LINE ITEM E' PRESENTE A SISTEMA
                            if(workOrderLineItemsToUpdate.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Closed__c!=true ){
                                if(sourceExtSystem=='MONETICA' && workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){    
                                    if(!String.isBlank(workOrderLineItem.workOrderLineItemDetail.reservationId)){
                                        if(!reservationToUpdate.containsKey(workOrderLineItem.workOrderLineItemDetail.reservationId)){

                                            errorMessageMap.put(workOrder.workOrderLegacyId,'Work Order Line Item with ReservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' not in system');   // SE LA RESERVATION ID E' PRESENTE A SISTEMA   
                                            break;
                                        }else{
                                            if(reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c != workOrderLineItem.workOrderLineItemDetail.resourceAlias){
                                                
                                                if (productStockMap.containsKey('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias)) {
                                                    
                                                    if(reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c == productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c){
                                                        reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__c = productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Id;
                                                    }else{
                                                        errorMessageMap.put(workOrder.workOrderLegacyId,'Is not possible change product on Work Order Line Item with reservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' because the resource does not have the same solution' );                                                    
                                                    }

                                                }else{
                                                    errorMessageMap.put(workOrder.workOrderLegacyId,'Is not possible change product on Work Order Line Item with reservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' because product is not in System' );                                                    

                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        errorMessageMap.put(workOrder.workOrderLegacyId,'The reservationId field on work order line item '+workOrderLineItem.workOrderLineItemLegacyId+' is empty' );
                                        break;
                                    }
                                }
                            }
                        }
                        else{
                            errorMessageMap.put(workOrder.workOrderLegacyId,'Work Order Line Item with WorkOrderLegacyId '+workOrderLineItem.workOrderLineItemLegacyId+' not in system');
                            break;

                        }
                    }

                } else {
                    errorMessageMap.put(workOrder.workOrderLegacyId, Label.Plc_ApexClass204UserFeedback);
                    
                }
            }
            //Procedura di inserimento in lista del work Order
            
            Map<String,String> reservationWorkOrder = new  Map<String,String>();

            for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder){
                if(!errorMessageMap.containsKey(workOrder.workOrderLegacyId)){
                    //DA ISTANZIARE VARIABILE E POPOLARLA CON WORK ORDER
                    WorkOrder temporaryWorkOrder = workOrdersToUpdate.get(workOrder.workOrderLegacyId);
                    temporaryWorkOrder.Status=workOrder.workOrderDetail.status;
                    updListWorkOrder.add(temporaryWorkOrder);
                    //
                    for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
                    GetWOLIFromWO.add(workOrderLineItem.workOrderLineItemLegacyId);
                        if(workOrderLineItemsToUpdate.get(workOrderLineItem.workOrderLineItemLegacyId).Plc_Closed__c!=true ){                        
                            String workOrderConfigurationKey = workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
                            WorkOrderLineItem temporaryWorkOrderLineItem = workOrderLineItemsToUpdate.get(workOrderLineItem.workOrderLineItemLegacyId);
                            temporaryWorkOrderLineItem.Status = 'NotExecuted';
                            updListWorkOrderLineItem.add(temporaryWorkOrderLineItem);

                            if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){
                                  
                                Plc_Reservation__c temporaryReservationId = reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId);
                                temporaryReservationId.Plc_Status__c = 'NotReserved';
                                updListReservation.add(temporaryReservationId);
                                reservationWorkOrder.put(workOrderLineItem.workOrderLineItemDetail.reservationId,workOrder.workOrderLegacyId);
                            }
                        }
                    }
                }
            }

            beginExecutionStep2 = Datetime.now();

            if(!errorMessageMap.containsKey(requestList.workOrder[0].workOrderLegacyId)){
                try{
                    update updListWorkOrder;
                    update updListWorkOrderLineItem;
                    update updListReservation;
                }catch(Exception ex){
                    System.debug('Exception '+ex.getMessage()+' '+ex.getStackTraceString());
                    errorMessageMap.put(requestList.workOrder[0].workOrderLegacyId, ex.getMessage()+' '+ex.getStackTraceString());
                }
            }

            //Try to give a response
            for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder){

                Plc_Wrappers.BloccaWorkOrderResponseData responseData = new Plc_Wrappers.BloccaWorkOrderResponseData();
                if(errorMessageMap.containsKey(workOrder.workOrderLegacyId)){
                    responseData.workOrderId = '';
                    responseData.workOrderLegacyId = workOrder.workOrderLegacyId;
                    responseData.updated = false;
                    serviceResponse.outcomeCode = '204';
                    serviceResponse.outcomeMessage = errorMessageMap.get(workOrder.workOrderLegacyId);
                    serviceResponse.executionTimeStep1 = executionTimeStep1; 
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    Database.rollback(sp);
                    return serviceResponse;
                } else {

                    responseData.workOrderId = workOrdersToUpdate.get(workOrder.workOrderLegacyId).Id;
                    responseData.workOrderLegacyId = workOrder.workOrderLegacyId;
                    responseData.updated = true;
                    responseData.outcomeMessage = null;
                    IF(GetWOLIFromWO[0] != null)
                        serviceResponse.contextLink = '/lightning/r/WorkOrderLineItem/' + GetWOLIFromWO[0] + '/view';
                    serviceResponse.outcomeCode = '200';
                    serviceResponse.executionTimeStep1 = executionTimeStep1; 
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    serviceResponse.responseDataList.add(responseData);
                    LogTracker.debugLogEnd(CLASS_NAME, 'workOrdersLock MASSIVE');
                    return serviceResponse;
                }
            }

            /*
            if(errorMessageMap.isEmpty()){
                serviceResponse.outcomeCode = '200';
                serviceResponse.executionTimeStep1 = executionTimeStep1; 
                serviceResponse.executionTimeStep2 = executionTimeStep2;
                return serviceResponse;
            }
            else{
                serviceResponse.outcomeCode = '200';
                serviceResponse.executionTimeStep1 = executionTimeStep1; 
                serviceResponse.executionTimeStep2 = executionTimeStep2;
                return serviceResponse;
            }
            */
            return serviceResponse;
            
        } catch (Exception ex) {
            serviceResponse.outcomeCode = '603';
            serviceResponse.outcomeMessage = '[ERR:CL-00E0680] Error found: '+ex.getMessage()+' '+ex.getLineNumber();
            serviceResponse.responseDataList = null;
            serviceResponse.executionTimeStep1 = executionTimeStep1; 
            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
            return serviceResponse;
        }

    }
    /**
     * used to unlock MASSIVE - ONTIME work orders and related work order line items
     * @param  requestList list requests from payload
     * @return             map that has the response code as key and a list of responsedata as values
     */

    public static ServiceResponse workOrdersUnlock(Plc_Wrappers.GestioneOrdineRequest requestList, String sourceExtSystem){
        ServiceResponse serviceResponse = new ServiceResponse();
        List<Plc_Wrappers.AggiornaOrdineResponseData> responseDataList = new List<Plc_Wrappers.AggiornaOrdineResponseData>();
        Map<String, WorkOrder> workOrderMap = new Map<String, WorkOrder>();
        Map<String, List<WorkOrderLineItem>> workOrderWorkOrderLineItemsMap = new Map<String, List<WorkOrderLineItem>>();
        Map<String, String> workOrderLineItemsWorkOrderLegacyIdMap = new Map<String, String>();
        Map<String, String> errorMessageMap = new Map<String, String>();
        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;
        Integer executionTimeStep2 = 0;
        Datetime endExecutionStep2 = Datetime.now();
        Datetime beginExecutionStep2 = Datetime.now();
        Set<String> workOrderAlias = new Set<String>();
        Set<Id> reservationIdSet = new Set<Id>();
        Set<String> workOrderLegacyIdSet = new Set<String>();
        Map<String, WorkOrder> workOrdersToUpdate = new Map<String, WorkOrder>();
        Map<String, WorkOrderLineItem> workOrderLineItemsToUpdate = new Map<String, WorkOrderLineItem>();
        Map<Id,Plc_Reservation__c> reservationToUpdate = new  Map<Id,Plc_Reservation__c>();
        List<WorkOrder> updListWorkOrder = new  List<WorkOrder>();
        List<WorkOrderLineItem> updListWorkOrderLineItem = new List<WorkOrderLineItem>();
        List<Plc_Reservation__c> updListReservation = new List<Plc_Reservation__c>();
        List<String> GetWorkOrderLineItemId = new List<String>();
        List<String> resourceAliasList = new List<String>();
        List<String> warehouseAliasList = new List<String>();
        Map<String,Id> productSkuCompatibleForWoli = new Map<String,Id>();

        LogTracker.debugLogBegin(CLASS_NAME, 'workOrdersUnlock MASSIVE');

        Boolean isDeactivation = false;

        for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder) {

            workOrderAlias.add(workOrder.workOrderLegacyId);
            warehouseAliasList.add(workOrder.workOrderDetail.warehouseAlias);

            for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
                if(workOrderLineItem.workOrderLineItemDetail.operationType == 'ToDeactivate'){
                    isDeactivation = true;
                }
                reservationIdSet.add(workOrderLineItem.workOrderLineItemDetail.reservationId);
                if(String.isNotBlank(workOrderLineItem.workOrderLineItemDetail.resourceAlias)){
                    resourceAliasList.add(workOrderLineItem.workOrderLineItemDetail.resourceAlias);
                }
            }

        }

        Set<String> extFind = new Set<String>();

        if(isDeactivation){
            for(B2WExtCat__External_Catalog_Item__c ex : [SELECT Plc_ProductSku__c FROM B2WExtCat__External_Catalog_Item__c WHERE Plc_ProductSku__c IN:resourceAliasList]){
                extFind.add(ex.Plc_ProductSku__c);
            }
        }

        beginExecutionStep1=Datetime.now();
        Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap = getWorkOrderConfigurationMap();
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

        beginExecutionStep1 = Datetime.now();
        workOrdersToUpdate = retrieveWorkOrdersToExecute(workOrderAlias);
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
        
        if(workOrdersToUpdate.isEmpty()){
            serviceResponse.outcomeCode = '204';
            serviceResponse.executionTimeStep1 = executionTimeStep1; 
            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime()); 
            return serviceResponse;
        }
        
        try{
            Savepoint sp = Database.setSavepoint();

            for(String tempWorkOrderKey : workOrdersToUpdate.keySet()){
                WorkOrder workOrderTemp = workOrdersToUpdate.get(tempWorkOrderKey);
                for(WorkOrderLineItem workOrderLineItemTemp : workOrderTemp.workOrderLineItems){
                    workOrderLineItemsToUpdate.put(workOrderLineItemTemp.Plc_Alias__c,workOrderLineItemTemp);
                    reservationIdSet.add(workOrderLineItemTemp.Plc_Reservation__c);
                }
            }
            
            reservationToUpdate = retrieveReservationToExecute(reservationIdSet);

            beginExecutionStep1 = Datetime.now();
            Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(resourceAliasList,warehouseAliasList);
            endExecutionStep1 = Datetime.now();

            for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder){

                if(workOrdersToUpdate.containsKey(workOrder.workOrderLegacyId)){ // SE IL WORK ORDER E' PRESENTE NELLA LISTA RITORNATA DALLA QUERY
                    
                    for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){ //PER OGNI LINE ITEM
                        Map<String, Bit2Shop__Product_Stock__c> productStockMapCompatible;
                        String workOrderConfigurationKey = workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
                        if(workOrderLineItemsToUpdate.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){    // SE IL WORK ORDER LINE ITEM E' PRESENTE A SISTEMA
                            if(sourceExtSystem=='MONETICA' && workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){

                                if(!String.isBlank(workOrderLineItem.workOrderLineItemDetail.reservationId)){
                                    if(!reservationToUpdate.containsKey(workOrderLineItem.workOrderLineItemDetail.reservationId)){

                                        errorMessageMap.put(workOrder.workOrderLegacyId,'Work Order Line Item with ReservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' not in system');   // SE LA RESERVATION ID E' PRESENTE A SISTEMA   
                                        break;
                                    }
                                    else{

                                        if(reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c != workOrderLineItem.workOrderLineItemDetail.resourceAlias){

                                            if (productStockMap.containsKey('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias)) {

                                                if(productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Plc_AvailableQty__c > 0){
                                                    
                                                    if(reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c == productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c){
                                                        
                                                        reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__c = productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Id;
                                                    
                                                    }else{

                                                        errorMessageMap.put(workOrder.workOrderLegacyId,'Is not possible change product on Work Order Line Item with reservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' because the resource does not have the same solution' );                                                    
                                                        
                                                    } 

                                                } else {
                                                    productStockMapCompatible = Plc_WsUtils.retrieveProductStocksCompatible(workOrderLineItem.workOrderLineItemDetail.resourceAlias,workOrder.workOrderDetail.warehouseAlias);
                                                    if(productStockMapCompatible.size()>0){
                                                        reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__c = productStockMapCompatible.get(workOrder.workOrderDetail.warehouseAlias).Id;
                                                    }else{
                                                        errorMessageMap.put(workOrder.workOrderLegacyId,'Is not possible change product on Work Order Line Item with reservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' because product is not available' );                                               
                                                    }
                                                }
                                            }else{
                                                errorMessageMap.put(workOrder.workOrderLegacyId,'Is not possible change product on Work Order Line Item with reservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' because product is not available' );                                                    

                                            }
                                        }else{
                                            if(reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__r.Plc_AvailableQty__c<=0){
                                                productStockMapCompatible = Plc_WsUtils.retrieveProductStocksCompatible(workOrderLineItem.workOrderLineItemDetail.resourceAlias,workOrder.workOrderDetail.warehouseAlias);
                                                if(productStockMapCompatible.size()>0){
                                                    reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId).Plc_ProductStock__c = productStockMapCompatible.get(workOrder.workOrderDetail.warehouseAlias).Id;
                                                    productSkuCompatibleForWoli.put(workOrderLineItem.workOrderLineItemLegacyId,productStockMapCompatible.get(workOrder.workOrderDetail.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__c);
                                                }else{
                                                    errorMessageMap.put(workOrder.workOrderLegacyId,'Is not possible to unlock Work Order Line Item with reservationId '+workOrderLineItem.workOrderLineItemDetail.reservationId+' because product is not available and there are not compatible' );
                                                }                                            
                                            }
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    errorMessageMap.put(workOrder.workOrderLegacyId,'The reservationId field on work order line item '+workOrderLineItem.workOrderLineItemLegacyId+' is empty' );
                                    break;
                                }
                            }else{
                                if (isDeactivation == false && !productStockMap.containsKey('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias)) {
                                    errorMessageMap.put(workOrder.workOrderLegacyId,'product '+workOrderLineItem.workOrderLineItemDetail.resourceAlias+' not registered in the warehouse: '+workOrder.workOrderDetail.warehouseAlias);
                                }else if(isDeactivation && !extFind.contains(workOrderLineItem.workOrderLineItemDetail.resourceAlias) ){
                                    errorMessageMap.put(workOrder.workOrderLegacyId,'product '+workOrderLineItem.workOrderLineItemDetail.resourceAlias+' not registered in System');
                                }
                            }
                        }
                        else{
                            errorMessageMap.put(workOrder.workOrderLegacyId,'Work Order Line Item with WorkOrderLegacyId '+workOrderLineItem.workOrderLineItemLegacyId+' not in system');
                            break;
                        }
                    }

                } else {
                    errorMessageMap.put(workOrder.workOrderLegacyId, Label.Plc_ApexClass204UserFeedback);
                    
                }
            }
            //Procedura di inserimento in lista del work Order
            
            Map<Id,String> reservationWorkOrder = new  Map<Id,String>();

            for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder){
                if(!errorMessageMap.containsKey(workOrder.workOrderLegacyId)){
                    //DA ISTANZIARE VARIABILE E POPOLARLA CON WORK ORDER
                    WorkOrder temporaryWorkOrder = workOrdersToUpdate.get(workOrder.workOrderLegacyId);
                    temporaryWorkOrder.Status=workOrder.workOrderDetail.status;
                    
                    updListWorkOrder.add(temporaryWorkOrder);
                    //
                    for(Plc_Wrappers.GestioneOrdineRequestBodyRigheOrdineDiLavoro workOrderLineItem : workOrder.workOrderLineItem){
                            GetWorkOrderLineItemId.add(workOrderLineItem.workOrderLineItemLegacyId);
                            WorkOrderLineItem temporaryWorkOrderLineItem = workOrderLineItemsToUpdate.get(workOrderLineItem.workOrderLineItemLegacyId);
                            temporaryWorkOrderLineItem.Status = workOrderLineItem.workOrderLineItemDetail.status;

                            if(productSkuCompatibleForWoli.containsKey(workOrderLineItem.workOrderLineItemLegacyId)){
                                
                                temporaryWorkOrderLineItem.Plc_ExternalCatalogItem__c = productSkuCompatibleForWoli.get(workOrderLineItem.workOrderLineItemLegacyId);
                            }else if (productStockMap.containsKey('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias)){
                                temporaryWorkOrderLineItem.Plc_ExternalCatalogItem__c = productStockMap.get('' + workOrderLineItem.workOrderLineItemDetail.resourceAlias + workOrder.workOrderDetail.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__c;
                            }
                            updListWorkOrderLineItem.add(temporaryWorkOrderLineItem);
                            String workOrderConfigurationKey = workOrder.workOrderDetail.requestType.toUpperCase() + workOrderLineItem.workOrderLineItemDetail.operationType.toUpperCase();
                            if(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_NeedsReservation__c){
                                if(sourceExtSystem=='MONETICA'){
                                    Plc_Reservation__c temporaryReservationId = reservationToUpdate.get(workOrderLineItem.workOrderLineItemDetail.reservationId);
                                    temporaryReservationId.Plc_Status__c = 'Reserved';
                                    updListReservation.add(temporaryReservationId);
                                    reservationWorkOrder.put(workOrderLineItem.workOrderLineItemDetail.reservationId,workOrder.workOrderLegacyId);
                                }else{

                                    if(reservationToUpdate.containsKey(temporaryWorkOrderLineItem.Plc_Reservation__c)){

                                        if(reservationToUpdate.get(temporaryWorkOrderLineItem.Plc_Reservation__c).Plc_ProductStock__r.Plc_AvailableQty__c>0){
                                            Plc_Reservation__c temporaryReservationId = reservationToUpdate.get(temporaryWorkOrderLineItem.Plc_Reservation__c);
                                            temporaryReservationId.Plc_Status__c = 'Reserved';
                                            updListReservation.add(temporaryReservationId);
                                            reservationWorkOrder.put(temporaryWorkOrderLineItem.Plc_Reservation__c,workOrder.workOrderLegacyId);
                                        }
                                        else{
                                            errorMessageMap.put(workOrder.workOrderLegacyId,'Is not possible to unlock Work Order Line Item '+workOrderLineItem.workOrderLineItemLegacyId+' because product is not available' );
                                            break;
                                        }
                                        
                                    }
                                    else{
                                        errorMessageMap.put(workOrder.workOrderLegacyId,'ReservationId on WorkOrderLineItem: '+workOrderLineItem.workOrderLineItemLegacyId+' not in system');   
                                        break;
                                    }

                                }
                            }
                    }
                }
            }

            beginExecutionStep2 = Datetime.now();
            //try to insert work orders

            if(!errorMessageMap.containsKey(requestList.workOrder[0].workOrderLegacyId)){
                try{
                    update updListWorkOrder;
                    update updListWorkOrderLineItem;
                    update updListReservation;
                }catch(Exception ex){
                    System.debug('Exception '+ex.getMessage()+' '+ex.getStackTraceString());
                    errorMessageMap.put(requestList.workOrder[0].workOrderLegacyId, ex.getMessage()+' '+ex.getStackTraceString());
                }
            }

            //Try to give a response
            for(Plc_Wrappers.GestioneOrdineRequestBody workOrder : requestList.workOrder){

                Plc_Wrappers.BloccaWorkOrderResponseData responseData = new Plc_Wrappers.BloccaWorkOrderResponseData();
                if(errorMessageMap.containsKey(workOrder.workOrderLegacyId)){
                    responseData.workOrderId = '';
                    responseData.workOrderLegacyId = workOrder.workOrderLegacyId;
                    responseData.updated = false;
                    serviceResponse.outcomeCode = '204';
                    serviceResponse.outcomeMessage = errorMessageMap.get(workOrder.workOrderLegacyId);
                    serviceResponse.executionTimeStep1 = executionTimeStep1; 
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    Database.rollback(sp);
                    return serviceResponse;
                } else {

                    responseData.workOrderId = workOrdersToUpdate.get(workOrder.workOrderLegacyId).Id;
                    responseData.workOrderLegacyId = workOrder.workOrderLegacyId;
                    responseData.updated = true;
                    responseData.outcomeMessage = null;
                    IF( GetWorkOrderLineItemId[0] != null )
                        serviceResponse.contextLink = '/lightning/r/WorkOrderLineItem/' + GetWorkOrderLineItemId[0] + '/view';
                    serviceResponse.outcomeCode = '200';
                    serviceResponse.executionTimeStep1 = executionTimeStep1; 
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    serviceResponse.responseDataList.add(responseData);
                    LogTracker.debugLogEnd(CLASS_NAME,'workOrdersUnlock MASSIVE');
                    return serviceResponse;
                }
            }

            /*
            if(errorMessageMap.isEmpty()){
                serviceResponse.outcomeCode = '200';
                serviceResponse.executionTimeStep1 = executionTimeStep1; 
                serviceResponse.executionTimeStep2 = executionTimeStep2;
                return serviceResponse;
            }
            else{
                serviceResponse.outcomeCode = '200';
                serviceResponse.executionTimeStep1 = executionTimeStep1; 
                serviceResponse.executionTimeStep2 = executionTimeStep2;
                return serviceResponse;
            }
            */
            return serviceResponse;

        } catch (Exception ex) {
            serviceResponse.outcomeCode = '603';
            serviceResponse.outcomeMessage = '[ERR:CL-00E0680] Error found: '+ex.getMessage()+' '+ex.getLineNumber();
            serviceResponse.responseDataList = null;
            serviceResponse.executionTimeStep1 = executionTimeStep1; 
            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
            return serviceResponse;
        }

    }

    public static Map<String, WorkOrder> retrieveWorkOrders(Set<String> workOrderAlias){

        Map<String, WorkOrder> workOrdersMap = new Map<String, WorkOrder>();
        for(WorkOrder workOrder : [SELECT Id, Plc_Alias__c, Plc_LegacyWarehouseId__c, Plc_Abi__c, 
                                   Plc_BankDescription__c, Plc_ServicePoint__c, Plc_LegacyServicePointId__c,
                                   Plc_Vat__c, Plc_FiscalCode__c, Plc_SiaCode__c, Plc_LegacyAccountId__c,
                                   Street, PostalCode, City, State, Plc_Prefix__c,
                                   Plc_Phone__c, Plc_Email__c, Plc_Cti__c, Plc_CustomerCare__c,
                                   Plc_OpeingHours__c, Plc_Contact__c, Plc_Note__c, StartDate, EndDate, RecordTypeId,
                                   Status,
                                   (SELECT Id, Plc_Alias__c, Plc_ExternalCatalogItem__c, Plc_TermId__c,
                                   Plc_LogisticDivision__c, Plc_OperationType__c, Status,
                                   Plc_Note__c, Plc_SerialNumber__c, Plc_BundleId__c
                                   FROM WorkOrderLineItems)
                                   FROM WorkOrder
                                   WHERE Plc_Alias__c IN: workOrderAlias]){

            workOrdersMap.put(workOrder.Plc_Alias__c, workOrder);
        }

        return workOrdersMap;
    }

    public static Map<String, WorkOrder> retrieveWorkOrdersToExecute(Set<String> workOrderAlias){

        Map<String, WorkOrder> workOrdersMap = new Map<String, WorkOrder>();
        for(WorkOrder workOrder : [SELECT Id, Plc_Alias__c, Plc_LegacyWarehouseId__c, Plc_Abi__c, 
                                   Plc_BankDescription__c, Plc_ServicePoint__c, Plc_LegacyServicePointId__c,
                                   Plc_Vat__c, Plc_FiscalCode__c, Plc_SiaCode__c, Plc_LegacyAccountId__c,
                                   Street, PostalCode, City, State, Plc_Prefix__c,
                                   Plc_Phone__c, Plc_Email__c, Plc_Cti__c, Plc_CustomerCare__c,
                                   Plc_OpeingHours__c, Plc_Contact__c, Plc_Note__c, StartDate, EndDate, RecordTypeId,
                                   (SELECT Id, Plc_Alias__c,Plc_Closed__c, Plc_ExternalCatalogItem__c, Plc_TermId__c,
                                   Plc_LogisticDivision__c, Plc_OperationType__c, Status,
                                   Plc_Note__c, Plc_SerialNumber__c, Plc_BundleId__c,Plc_Reservation__c
                                   FROM WorkOrderLineItems)
                                   FROM WorkOrder
                                   WHERE Plc_Alias__c IN: workOrderAlias]){

            workOrdersMap.put(workOrder.Plc_Alias__c, workOrder);
        }

        return workOrdersMap;
    }

    public static Map<String,WorkOrderLineItem> retrieveWorkOrdersLineItemToExecute(){
        Map<String, WorkOrderLineItem> workOrderLineItemMap = new Map<String, WorkOrderLineItem>();
        for(WorkOrderLineItem workOrderLienItemTemp : [SELECT Id, Plc_Alias__c, Plc_ExternalCatalogItem__c, Plc_TermId__c,
                                                       Plc_LogisticDivision__c, Plc_OperationType__c, Status,
                                                       Plc_Note__c, Plc_SerialNumber__c, Plc_BundleId__c
                                                       FROM WorkOrderLineItem]){
            workOrderLineItemMap.put(workOrderLienItemTemp.Plc_Alias__c,workOrderLienItemTemp);
        }
        return workOrderLineItemMap;
    }
    public static Map<Id,Plc_Reservation__c> retrieveReservationToExecute(Set<Id> reservationIdLegacy){
        Map<Id,Plc_Reservation__c> reservationMap = new Map<Id,Plc_Reservation__c>();
        for(Plc_Reservation__c reservationTemp : [SELECT Id,Plc_ProductStock__r.Plc_AvailableQty__c ,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__c,Plc_Alias__c,Plc_Status__c FROM Plc_Reservation__c WHERE Id IN :reservationIdLegacy]){
            reservationMap.put(reservationTemp.Id,reservationTemp);
        }
        return reservationMap;
    }

}