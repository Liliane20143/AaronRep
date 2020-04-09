/**
 * Created by dilorenzo on 15/11/2018.
 * Mod: FDL 23/11/2018
 */

public with sharing class Plc_ReservationsServices extends Plc_ServiceWs {

    /*BEGIN Gestione Disponibilita*/
    //verificaDisponibilita
    //prenotaDisponibilita
    private static final String CLASS_NAME = 'Plc_ReservationsServices';
    //Implemetazione servizio massivo
    public static ServiceResponse createReservationMass(Plc_Wrappers.GestioneDisponibilitaRequest requestList, String sourceExtSystem) {
        LogTracker.debugLogBegin(CLASS_NAME, 'createReservationMass MASSIVE');
        
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
        Map<String, Plc_Reservation__c> reservationsToInsert = new Map<String, Plc_Reservation__c>();
        Map<String, Plc_Wrappers.GestioneDisponibilitaRequestBody> payloadMap = new Map<String, Plc_Wrappers.GestioneDisponibilitaRequestBody>();
        List<Plc_Wrappers.PrenotaDisponibilitaResponseData> responseDataList = new List<Plc_Wrappers.PrenotaDisponibilitaResponseData>();
        List<String> resourceAliasSet = new List<String>();
        List<String> warehouseAliasSet = new List<String>();
        List<String> uniqueKey = new List<String>();
        for(Plc_Wrappers.GestioneDisponibilitaRequestBody requestBody : requestList.request){
            if(!uniqueKey.contains(requestBody.warehouseAlias+requestBody.resourceAlias)){
                uniqueKey.add(requestBody.warehouseAlias+requestBody.resourceAlias);
                warehouseAliasSet.add(requestBody.warehouseAlias);
                resourceAliasSet.add(requestBody.resourceAlias);
                payloadMap.put('' + requestBody.resourceAlias + requestBody.warehouseAlias,
                               requestBody);
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

        serviceResponse.outcomeCode = '202';
        
        try{
            for(Plc_Wrappers.GestioneDisponibilitaRequestBody requestBody : requestList.request){

                if(!validRequestTypes.contains(requestBody.requestType)){

                    Plc_Wrappers.PrenotaDisponibilitaResponseData responseData = new Plc_Wrappers.PrenotaDisponibilitaResponseData();
                    responseData.termId = requestBody.termId;
                    responseData.reserved = false; 
                    responseData.reservationId = null;
                    responseData.outcomeMessage = Label.Plc_ApexClassWorkOrdersServicesInvalidRequestType;
                    responseDataList.add(responseData);
                    continue;
                }
                if(productStockMap.containsKey('' + requestBody.resourceAlias + requestBody.warehouseAlias)){

                    if(productStockMap.get('' + requestBody.resourceAlias + requestBody.warehouseAlias).Plc_AvailableQty__c > 0){

                        Plc_Reservation__c tempReservationRequest = new Plc_Reservation__c();
                        tempReservationRequest.Plc_Status__c  = 'Reserved';
                        tempReservationRequest.Plc_ProductStock__c = productStockMap.get('' + requestBody.resourceAlias + requestBody.warehouseAlias).Id;
                        tempReservationRequest.Plc_SourceLegacySystem__c = sourceExtSystem;
                        reservationsToInsert.put('' + requestBody.resourceAlias  + requestBody.warehouseAlias,
                                                   tempReservationRequest);
                    } else {

                        Plc_Wrappers.PrenotaDisponibilitaResponseData responseData = new Plc_Wrappers.PrenotaDisponibilitaResponseData();
                        responseData.termId = requestBody.termId;
                        responseData.reserved = false; 
                        responseData.reservationId = null;
                        responseData.outcomeMessage = Label.Plc_ApexClassReservationsServicesProductNotAvailable;
                        responseDataList.add(responseData);
                    }
                } else {

                    Plc_Wrappers.PrenotaDisponibilitaResponseData responseData = new Plc_Wrappers.PrenotaDisponibilitaResponseData();
                    responseData.termId = requestBody.termId;
                    responseData.reserved = false; 
                    responseData.reservationId = null;
                    if(!warehouseAliasMap.containsKey(requestBody.warehouseAlias)){

                        responseData.outcomeMessage = 'Warehouse does not exist in the system.';
                    } else {

                        responseData.outcomeMessage = 'Product does not exist in the system.';
                    }
                    responseDataList.add(responseData);
                }
            }

            try {

                Map<String,String> reservationInsertionMap;
                if(!reservationsToInsert.isEmpty()){

                    reservationInsertionMap = upsertReservations(reservationsToInsert);
                    for(String payloadTripleKey : reservationsToInsert.keySet()){

                        Plc_Wrappers.PrenotaDisponibilitaResponseData responseData = new Plc_Wrappers.PrenotaDisponibilitaResponseData();
                        if((reservationInsertionMap.get(payloadTripleKey) instanceOf Id)){

                            responseData.termId = payloadMap.get(payloadTripleKey).termId;
                            responseData.reserved = true; //impegnato: (true | false)
                            responseData.reservationId = reservationInsertionMap.get(payloadTripleKey);//capise se inserire anche questo
                            responseData.outcomeMessage = null;//messaggioEsito: (null | value)
                            serviceResponse.outcomeCode = '200';
                            responseDataList.add(responseData);
                        } else {

                            responseData.termId = payloadMap.get(payloadTripleKey).termId;
                            responseData.reserved = false; //impegnato: (true | false)
                            responseData.reservationId = null;//capise se inserire anche questo
                            responseData.outcomeMessage = reservationInsertionMap.get(payloadTripleKey);//messaggioEsito: (null | value)
                            responseDataList.add(responseData); 
                        }
                    }
                }
            } catch(Exception ex){

                serviceResponse.outcomeCode = '603';
                serviceResponse.executionTimeStep1 = executionTimeStep1;
                serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
                serviceResponse.responseDataList = null;
                return serviceResponse;
            }
            serviceResponse.executionTimeStep1 = executionTimeStep1;
            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
            serviceResponse.responseDataList = responseDataList;
            If( responseDataList[0].reservationId != null || responseDataList[0].reservationId != ''){
                serviceResponse.contextLink = '/lightning/r/Plc_Reservation__c/' + responseDataList[0].reservationId + '/view';
            }
            LogTracker.debugLogEnd(CLASS_NAME, 'createReservationMass MASSIVE');
            return serviceResponse;
        } catch (Exception ex){

            serviceResponse.outcomeCode = '603';
            serviceResponse.executionTimeStep1 = executionTimeStep1;
            serviceResponse.executionTimeStep2 = Integer.valueOf((Datetime.now()).getTime()-beginExecutionStep2.getTime());
            serviceResponse.responseDataList = null;
            return serviceResponse;
        }

    }

    public static ServiceResponse reservationsDelete(Plc_Wrappers.AnnullaImpegnoRequestBody requestBody, String sourceExtSystem) {

        ServiceResponse serviceResponse = new ServiceResponse();
        List<Plc_Wrappers.AnnullaImpegnoResponseData> responseDataList = new List<Plc_Wrappers.AnnullaImpegnoResponseData>();
        Plc_Wrappers.AnnullaImpegnoResponseData responseData = new Plc_Wrappers.AnnullaImpegnoResponseData();
        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;
        Integer executionTimeStep2 = 0;
        Datetime endExecutionStep2 = Datetime.now();
        Datetime beginExecutionStep2 = Datetime.now();
        //Flusso monetica
        if (sourceExtSystem == 'MONETICA') {

            beginExecutionStep2 = Datetime.now();
            Savepoint sp = Database.setSavepoint();
            try {
                
                Map<String,String> reservationInsertionMap;
                List<Plc_Reservation__c> reservationToUpdate = [SELECT id, Plc_Status__c,
                                                                (   SELECT Plc_Alias__c
                                                                    FROM Plc_WorkOrderLineItems__r
                                                                )
                                                                FROM Plc_Reservation__c 
                                                                WHERE id =: requestBody.reservationId 
                                                                LIMIT 1];
                //Check if there are WOLI referenced to the reservation
               if(reservationToUpdate.size() > 0){
               
                if(!reservationToUpdate[0].Plc_WorkOrderLineItems__r.isEmpty()){
                    serviceResponse.outcomeCode = '602';
                    serviceResponse.outcomeMessage = ' Impossible to delete the reservation because there are WorkOrderLineItem related to it';
                    serviceResponse.responseDataList = null;
                    serviceResponse.executionTimeStep1 = executionTimeStep1;
                    serviceResponse.executionTimeStep2 = executionTimeStep2;
                    return serviceResponse;
                }
               } 
                if(!reservationToUpdate.isEmpty()){

                    if(reservationToUpdate[0].Plc_Status__c != 'NotReserved'){

                        reservationToUpdate[0].Plc_Status__c = 'NotReserved';
                        update reservationToUpdate;
                        responseData.termId = requestBody.termId;
                        responseData.reservationId = requestBody.reservationId;
                        responseData.cancelled = true;
                        responseData.outcomeMessage = '';
                        responseDataList.add(responseData);
                        If( requestBody.reservationId != null || requestBody.reservationId != ''){
                            serviceResponse.contextLink = '/lightning/r/Plc_Reservation__c/' + requestBody.reservationId + '/view';
                        }
                        serviceResponse.outcomeCode = '200';
                        serviceResponse.outcomeMessage = '';
                        serviceResponse.responseDataList = responseDataList;
                        serviceResponse.executionTimeStep1 = executionTimeStep1;
                        serviceResponse.executionTimeStep2 = executionTimeStep2;
                        return serviceResponse;
                    } else {

                        serviceResponse.outcomeCode = '602';
                        serviceResponse.outcomeMessage = 'Reservation has already been deleted.';
                        serviceResponse.responseDataList = null;
                        serviceResponse.executionTimeStep1 = executionTimeStep1;
                        serviceResponse.executionTimeStep2 = executionTimeStep2;
                        return serviceResponse;
                    }

                } else {

                    serviceResponse.outcomeCode = '602';
                    serviceResponse.outcomeMessage = 'Invalid value for ReservationId.';
                    serviceResponse.responseDataList = null;
                    serviceResponse.executionTimeStep1 = executionTimeStep1;
                    serviceResponse.executionTimeStep2 = executionTimeStep2;
                    return serviceResponse;
                }

            } catch (Plc_Exception e) {

                Database.rollback(sp);
                serviceResponse.outcomeCode = '603';
                serviceResponse.responseDataList = null;
                serviceResponse.executionTimeStep1 = executionTimeStep1;
                serviceResponse.executionTimeStep2 = executionTimeStep2;
                return serviceResponse;
            }
        } else {
            serviceResponse.outcomeCode = '606';
            serviceResponse.executionTimeStep1 = executionTimeStep1;
            serviceResponse.executionTimeStep2 = executionTimeStep2;
            serviceResponse.responseDataList = null;
            return serviceResponse;
        }
    }

    public static Map<String, String> upsertReservations(Map<String, Plc_Reservation__c> reservationToUpsert){

        Map<String, String> messageMap = new Map<String, String>();
        //try to insert work orders
        List<Database.UpsertResult> reservationUpsertResults = Database.upsert(reservationToUpsert.values(), false);
        for(Integer i = 0; i < reservationToUpsert.keySet().size(); i++) {

            Database.UpsertResult UpsertResult = reservationUpsertResults[i];
            if(UpsertResult.isSuccess()) {

                messageMap.put(new List<String>(reservationToUpsert.keySet())[i], UpsertResult.getId());
            } else {

                messageMap.put(new List<String>(reservationToUpsert.keySet())[i], UpsertResult.getErrors()[0].getMessage());
            }
        }

        return messageMap;
    }

    public static Map<Id,Plc_Reservation__c> retrieveReservation (Set<String> reservationId){
        Map<Id,Plc_Reservation__c> reservationIdSet = new Map<Id,Plc_Reservation__c>();

        for(Plc_Reservation__c tempReservation : [SELECT Id,Plc_ProductStock__r.Plc_AvailableQty__c,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Solution__r.Plc_Alias__c,Plc_ProductStock__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_ProductSku__c FROM Plc_Reservation__c WHERE Id IN: reservationId]){
            reservationIdSet.put(tempReservation.id,tempReservation);
        }
        return reservationIdSet;
    }
}