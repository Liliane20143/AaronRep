/**
 * PLC Product Stocks Rest WebService
 *
 * @author Dam Kebe
 * @version 1.0
 * @description 
 * @testedIn 
 * @code
 * @errorcode [ERR:CL-XXXYYZZ]
 * @history
 * 2018-11-15 : Dam Kebe
 */
public with sharing class Plc_ProductStocksServices extends Plc_ServiceWs {
    /**
     * Used to retrive information about the aveilability of certain productStocks
     * @param  requestList list requests from payload
     * @return             map that has the response code as key and a list of responsedata as values
     */
    private static final String CLASS_NAME = 'Plc_ProductStocksServices';
    public static ServiceResponse productStocksCheck(Plc_Wrappers.GestioneDisponibilitaRequest requestList) {
        LogTracker.debugLogBegin(CLASS_NAME, 'productStocksCheck MASSIVE');

        ServiceResponse serviceResponse = new ServiceResponse();
        Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap = getWorkOrderConfigurationMap();
        Set<String> validRequestTypes = new Set<String>();
        for(String workOrderConfigurationKey : workOrderConfigurationMap.keySet()){

            validRequestTypes.add(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_IntegrationName__c);
        }
        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;
        List<Plc_Wrappers.VerificaDisponibilitaResponseData> responseDataList = new List<Plc_Wrappers.VerificaDisponibilitaResponseData>();
        List<String> resourceAliasSet = new List<String>();
        List<String> warehouseAliasSet = new List<String>();
        List<String> uniqueKey = new List<String>();
        for(Plc_Wrappers.GestioneDisponibilitaRequestBody requestBody : requestList.request){
            if(!uniqueKey.contains(requestBody.warehouseAlias+requestBody.resourceAlias)){
                uniqueKey.add(requestBody.warehouseAlias+requestBody.resourceAlias);
                warehouseAliasSet.add(requestBody.warehouseAlias);
                resourceAliasSet.add(requestBody.resourceAlias);
            }
        }
        Map<String, Bit2Shop__Warehouse__c> warehouseAliasMap = new Map<String, Bit2Shop__Warehouse__c>();
        for(Bit2Shop__Warehouse__c warehouse : [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c IN: warehouseAliasSet ]){
            warehouseAliasMap.put(warehouse.Plc_Alias__c, warehouse);
        }
        //
        uniqueKey.clear();
        //
        beginExecutionStep1 = Datetime.now();
        Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(resourceAliasSet,warehouseAliasSet);
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
        Boolean needSearchInCompatible;

        try{
            for(Plc_Wrappers.GestioneDisponibilitaRequestBody request : requestList.request){
                needSearchInCompatible=false;

                if(!validRequestTypes.contains(request.requestType)){

                    Plc_Wrappers.VerificaDisponibilitaResponseData responseData = new Plc_Wrappers.VerificaDisponibilitaResponseData();
                    responseData.termId = request.termId;
                    responseData.resourceAlias = request.resourceAlias;
                    responseData.available = false;
                    responseData.outcomeMessage = Label.Plc_ApexClassWorkOrdersServicesInvalidRequestType;
                    responseDataList.add(responseData);
                    continue;
                }
                if(productStockMap.containsKey('' + request.resourceAlias + request.warehouseAlias)) {
                    if(productStockMap.get('' + request.resourceAlias + request.warehouseAlias).Plc_AvailableQty__c > 0) {
                        Plc_Wrappers.VerificaDisponibilitaResponseData responseData = new Plc_Wrappers.VerificaDisponibilitaResponseData();
                        responseData.termId = request.termId;
                        responseData.resourceAlias = request.resourceAlias;
                        responseData.available = true;
                        responseData.outcomeMessage = null;
                        responseDataList.add(responseData);
                    } else {
                        serviceResponse.outcomeCode = '200';
                        serviceResponse.executionTimeStep1 = executionTimeStep1; 
                        serviceResponse.responseDataList = responseDataList;
                        return serviceResponse;
                    }
                }else{
                    //VERIFICA COMPATIBILE
                    if(productStockMap.containsKey('' + request.warehouseAlias)){

                        Plc_Wrappers.VerificaDisponibilitaResponseData responseData = new Plc_Wrappers.VerificaDisponibilitaResponseData();
                        responseData.termId = request.termId;
                        responseData.resourceAlias = productStockMap.get('' + request.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c;
                        responseData.available = true;
                        responseData.outcomeMessage =  Label.Plc_ApexClassProductStocksServicesProductAliasOnlyHasCompatible.replace('{0}',request.resourceAlias);
                        responseDataList.add(responseData);
                    } else {
                        Plc_Wrappers.VerificaDisponibilitaResponseData responseData = new Plc_Wrappers.VerificaDisponibilitaResponseData();
                        responseData.termId = request.termId;
                        responseData.resourceAlias = request.resourceAlias;
                        responseData.available = false;
                        if(!warehouseAliasMap.containsKey(request.warehouseAlias)){

                            responseData.outcomeMessage = 'Warehouse does not exist in the system.';
                        } else {

                            responseData.outcomeMessage = 'Product does not exist in the system.';
                        }
                        responseDataList.add(responseData);
                    }
                }
            }
            serviceResponse.outcomeCode = '200';
            serviceResponse.executionTimeStep1 = executionTimeStep1; 
            serviceResponse.responseDataList = responseDataList;
            LogTracker.debugLogEnd(CLASS_NAME, 'productStocksCheck MASSIVE');
            return serviceResponse;
        } catch (Exception ex){
            serviceResponse.outcomeCode = '603';
            serviceResponse.executionTimeStep1 = executionTimeStep1; 
            serviceResponse.responseDataList = null;
            return serviceResponse;
        }
        
    }

    /**
     * Used to retrive information about the aveilability of certain productStocks
     * @param  requestList list requests from payload
     * @return             map that has the response code as key and a list of responsedata as values
     */
    public static ServiceResponse productStocksCheck(Plc_Wrappers.GestioneDisponibilitaRequestBody request) {
        LogTracker.debugLogBegin(CLASS_NAME, 'productStocksCheck MASSIVE');

        //----EXECUTION TIME----//
        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;
        Datetime beginExecutionStep2 = Datetime.now();
        //----EXECUTION TIME----//

        ServiceResponse serviceResponse = new ServiceResponse();
        Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap = getWorkOrderConfigurationMap();
        Set<String> validRequestTypes = new Set<String>();
        for(String workOrderConfigurationKey : workOrderConfigurationMap.keySet()){

            validRequestTypes.add(workOrderConfigurationMap.get(workOrderConfigurationKey).Plc_IntegrationName__c);
        }
        List<Plc_Wrappers.VerificaDisponibilitaResponseData> responseDataList = new List<Plc_Wrappers.VerificaDisponibilitaResponseData>();

        beginExecutionStep1 = Datetime.now();
        Map<String, Bit2Shop__Product_Stock__c> productStockMap = Plc_WsUtils.retrieveProductStocks(request);
        List<Bit2Shop__Warehouse__c> warehouse = [SELECT Plc_Alias__c FROM Bit2Shop__Warehouse__c WHERE Plc_Alias__c =: request.warehouseAlias LIMIT 1];
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
        Boolean needSearchInCompatibile = false;
        try{
            if(!validRequestTypes.contains(request.requestType)){

                serviceResponse.outcomeCode = '602';
                serviceResponse.outcomeMessage = Label.Plc_ApexClassWorkOrdersServicesInvalidRequestType;
                serviceResponse.executionTimeStep1 = executionTimeStep1;
                serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                serviceResponse.responseDataList = null;
                return serviceResponse; 
            }
            if(!productStockMap.isEmpty()){
            //VERIFICA PUNTUALE
                if(productStockMap.values()[0].Plc_AvailableQty__c > 0){
                    Plc_Wrappers.VerificaDisponibilitaResponseData responseData = new Plc_Wrappers.VerificaDisponibilitaResponseData();
                    responseData.termId = request.termId;
                    responseData.resourceAlias = request.resourceAlias;
                    responseData.available = true;
                    responseData.outcomeMessage = null;
                    responseDataList.add(responseData);
                    serviceResponse.outcomeCode = '200';
                    serviceResponse.executionTimeStep1 = executionTimeStep1;
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    serviceResponse.responseDataList = responseDataList;
                    // MZ 20190130: Put new attribute for Record Context link ----- START
                    serviceResponse.contextLink = '/lightning/r/Bit2Shop__Product_Stock__c/' + productStockMap.values()[0].Id + '/view';
                    // MZ 20190130: Put new attribute for Record Context link ----- END
                    return serviceResponse;
                } else {
                    needSearchInCompatibile = true;                    
                }
            }else{
                needSearchInCompatibile = true;
            }
            
             if(needSearchInCompatibile) {
                
                //VERIFICA COMPATIBILE
                try{
                    beginExecutionStep1 = Datetime.now();
                    Map<String, Bit2Shop__Product_Stock__c> productStockMap2 = Plc_WsUtils.retrieveProductStocksCompatible(request.resourceAlias,request.warehouseAlias);
                    endExecutionStep1 = Datetime.now();
                    executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));
                    if(productStockMap2.containsKey('' + request.warehouseAlias)){
                        if(productStockMap2.get('' + request.warehouseAlias).Plc_AvailableQty__c>0){
                            Plc_Wrappers.VerificaDisponibilitaResponseData responseData = new Plc_Wrappers.VerificaDisponibilitaResponseData();
                            responseData.termId = request.termId;
                            responseData.resourceAlias = productStockMap2.get('' + request.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c;
                            responseData.available = true;
                            responseData.outcomeMessage = Label.Plc_ApexClassProductStocksServicesProductAliasOnlyHasCompatible.replace('{0}',productStockMap2.get('' + request.warehouseAlias).Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c );
                            responseDataList.add(responseData);
                            serviceResponse.outcomeCode = '200';

                            serviceResponse.executionTimeStep1 = executionTimeStep1;
                            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                            serviceResponse.responseDataList = responseDataList;
                            // MZ 20190130: Put new attribute for Record Context link ----- START
                            serviceResponse.contextLink = '/lightning/r/Bit2Shop__Product_Stock__c/' + productStockMap2.values()[0].Id + '/view';
                            // MZ 20190130: Put new attribute for Record Context link ----- END

                            return serviceResponse;
                        }
                        else{
                            serviceResponse.outcomeCode = '202';
                            serviceResponse.executionTimeStep1 = executionTimeStep1;
                            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                            serviceResponse.responseDataList = null;
                            LogTracker.debugLogEnd(CLASS_NAME, 'productStocksCheck MASSIVE');
                            return serviceResponse;
                        }
                    }
                    else{
                        serviceResponse.outcomeCode = '202';
                        if(warehouse.isEmpty()){

                            serviceResponse.outcomeMessage = 'Warehouse does not exist in the system.';
                        } else {

                            serviceResponse.outcomeMessage = 'Product does not exist in the system.';
                        }
                        serviceResponse.executionTimeStep1 = executionTimeStep1;
                        serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                        serviceResponse.responseDataList = null;
                        return serviceResponse;
                    }                    
                } catch (Exception ex) {
                    serviceResponse.outcomeCode = '603';
                    serviceResponse.outcomeMessage = ex.getMessage();
                    serviceResponse.executionTimeStep1 = executionTimeStep1;
                    serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                    serviceResponse.responseDataList = null;
                    return serviceResponse;
                }
            }
        } catch (Exception ex){
            serviceResponse.outcomeCode = '603';
            serviceResponse.outcomeMessage = ex.getMessage();
            serviceResponse.executionTimeStep1 = executionTimeStep1;
            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
            serviceResponse.responseDataList = null;
            return serviceResponse;
        }
        return serviceResponse;
    }

    public static Map<String,Bit2Shop__Product_Stock__c> retrieveProductStocks (List<String> resourceAliasSet , Set<String> warehouseIdAliasSet ){
        Map<String,Bit2Shop__Product_Stock__c> productStockMap = new Map<String,Bit2Shop__Product_Stock__c>();

        for(Bit2Shop__Product_Stock__c tempProductStock : [SELECT Id,Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c,Bit2Shop__Warehouse_Id__r.Plc_Alias__c 
                                                            FROM Bit2Shop__Product_Stock__c 
                                                            WHERE Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c IN:resourceAliasSet 
                                                            AND Bit2Shop__Warehouse_Id__r.Plc_Alias__c IN:warehouseIdAliasSet]){

            productStockMap.put(tempProductStock.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c+tempProductStock.Bit2Shop__Warehouse_Id__r.Plc_Alias__c,tempProductStock);
        }
        return productStockMap;
    }
}