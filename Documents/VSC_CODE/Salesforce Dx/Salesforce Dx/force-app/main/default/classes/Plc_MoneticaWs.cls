/**
 * @author Kebe Dam
 * @date Creation 23/10/2018
 * @version 1.0
 * @description PLC Monetica Rest WebService.
 * @errorcode [ERR:CL-009YYZZ]
 */
@RestResource(urlMapping='/mon/v1/*')
global with sharing class Plc_MoneticaWs extends Plc_ServiceWs {

    private static final String CLASS_NAME = 'Plc_MoneticaWs';
    public static final String URL_MAPPING = '/mon/v1/';
    public static final String SOURCE_EXT_SYS = 'MONETICA';
    public static final String REQUEST_HEADER_RETRY = 'retry';
    public static final String REQUEST_HEADER_MESSAGEID = 'messageid';
    public static final String MONETICA='M';

    /**
     * @author Kebe Dam
     * @date Creation 15/11/2018
     * @version 1.0 
     * @description HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.
     *              Used to retrieve data coming in the request body and performing corressponding actions.
     * @return WsResponse.
     * @code 01
     */
    @HttpPost
    global static WsResponse doPost() {

        LogTracker.debugLogBegin(CLASS_NAME, 'doPost');
        Datetime initTimestamp = Datetime.now();
        // Check if the WS are enabled
        if (isInMaintenance(MONETICA)) {

            LogTracker.debugLog(CLASS_NAME, 'doPost', 'isInMaintenance');
            WsResponse response = new WsMaintenanceResponse();
            traceWsCall(RestContext.request, response, initTimestamp);
            return response;
        }

        try {
            RestRequest restRequest = RestContext.request;
            System.debug('HEADERREQUEST: '+restRequest.Headers.keySet() );
            if(restRequest.Headers.containsKey(REQUEST_HEADER_RETRY)){
                
                if(restRequest.Headers.get(REQUEST_HEADER_RETRY).contains('true') ){
                                            System.debug('HERE0: '+restRequest.Headers.keySet() );

                    String recordTypeForWebServices = Plc_Utils.getRecordTypeId('Plc_WebService', 'Plc_Log__c');
                    for(Plc_Log__c restLog : [SELECT id, Plc_RequestHeader__c,RecordTypeId, Plc_ResponseBody__c,Plc_Tipology__c FROM Plc_Log__c WHERE RecordTypeId = :recordTypeForWebServices ORDER BY CreatedDate DESC LIMIT 100]){

                        Plc_Wrappers.retryData requestHeaderMap = new Plc_Wrappers.retryData();
                        requestHeaderMap = (Plc_Wrappers.retryData) JSON.deserialize(restLog.Plc_RequestHeader__c,Plc_Wrappers.retryData.class );
                        System.debug('HERE1: '+restRequest.Headers.keySet() );

                        if(!String.isBlank(requestHeaderMap.messageid) &&
                            restRequest.Headers.containsKey(REQUEST_HEADER_MESSAGEID)){
                                                        System.debug('HERE2: '+restRequest.Headers.keySet() );

                            if(requestHeaderMap.messageid.contains(restRequest.Headers.get(REQUEST_HEADER_MESSAGEID)) ){
                                                        System.debug('HERE3: '+restRequest.Headers.keySet() );
                                WsSingleResponse singleResponse = new WsSingleResponse();
                                
                                if(restLog.Plc_Tipology__c=='WO Create'){
                                    Plc_Wrappers.retryDataResponseCreate responseBodyCreate = (Plc_Wrappers.retryDataResponseCreate) System.JSON.deserialize(restLog.Plc_ResponseBody__c, Plc_Wrappers.retryDataResponseCreate.class);
                                    singleResponse.data=responseBodyCreate.data;
                                }else{
                                    Plc_Wrappers.retryDataResponseUpdate responseBodyUpdate = (Plc_Wrappers.retryDataResponseUpdate) System.JSON.deserialize(restLog.Plc_ResponseBody__c, Plc_Wrappers.retryDataResponseUpdate.class);
                                    singleResponse.data=responseBodyUpdate.data;
                                }
                                System.debug('HERE4: '+singleResponse );
                                return singleResponse;
                                
                            }
                        }
                    }
                                            System.debug('HERE6: '+restRequest.Headers.keySet() );

                    WsSingleResponse response = new WsSingleResponse('602', '[ERR:CL-0080101] No feedback has been found in our systems.');
                    return response;
                }
            }

            List<String>splittedEndpoint  = (restRequest.requestURI.substring(restRequest.requestURI.lastIndexOf(URL_MAPPING) + URL_MAPPING.length())).split('/');
            
            // methodName 1 params
            String methodName;
            //referenceObject 2 params
            String referenceObject;
            // action name of the methodName 3 params
            String actionName;
            switch on splittedEndpoint.size(){
                when 3 {
                     methodName = splittedEndpoint[0];
                     referenceObject = splittedEndpoint[1];
                     actionName = splittedEndpoint[2];
                }
                when 2 {
                     methodName = splittedEndpoint[0];
                     referenceObject = splittedEndpoint[1];
                }
                when 1 {
                     methodName = splittedEndpoint[0];
                }
            }
            LogTracker.debugLog(CLASS_NAME, 'doPost', 'methodName: ' + methodName);
            LogTracker.debugLog(CLASS_NAME, 'doPost', 'referenceObject: ' + referenceObject);
            LogTracker.debugLog(CLASS_NAME, 'doPost', 'actionName: ' + actionName);


            Plc_LogHelper.LogStructure momentaryLogOK = new  Plc_LogHelper.LogStructure();
            momentaryLogOK.httpMethod = 'POST';

            switch on methodName {

                when 'product-stocks' {

                LogTracker.debugLog(CLASS_NAME, 'doPost', 'product-stocks');

                    if (actionName.containsIgnoreCase('check')) {

                        List<String> fieldList = new List<String> {'resourceAlias', 'warehouseAlias', 'termId', 'requestType'};
                        if (actionName == 'check') {
                            // single
                            LogTracker.debugLog(CLASS_NAME, 'doPost', 'Single check');
                            Plc_Wrappers.GestioneDisponibilitaRequestBody requestBody = Plc_Wrappers.gestioneDisponibilitaRequestBodyParse(restRequest.requestBody.toString().trim());
                            String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                            if (errorMessage != null) {
                                WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090102] ' + errorMessage);
                                traceWsCall(RestContext.request, response, initTimestamp);
                                return response;
                            }

                            ServiceResponse serviceResponse = Plc_ProductStocksServices.productStocksCheck(requestBody);

                            WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode, serviceResponse.outcomeMessage);
                            if (serviceResponse.outcomeCode == '200') {
                                response.data = serviceResponse.responseDataList[0];
                            } else {
                                
                                response.data = null;
                            }
                            traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                            return response;
                        } else {
                            // bulk
                            LogTracker.debugLog(CLASS_NAME, 'doPost', 'Massive check');
                            Plc_Wrappers.GestioneDisponibilitaRequest request = Plc_Wrappers.gestioneDisponibilitaRequestParse(restRequest.requestBody.toString().trim());
                            if (request.request == null) {
                                throw new Plc_Exception('602');
                            }

                            for (Plc_Wrappers.GestioneDisponibilitaRequestBody requestBody : request.request) {
                                String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                                if (errorMessage != null) {
                                    WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090103] ' + errorMessage);
                                                                    traceWsCall(RestContext.request, response, initTimestamp);

                                    return response;
                                }
                            }

                            ServiceResponse serviceResponse = Plc_ProductStocksServices.productStocksCheck(request);
                            WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);
                            for (Object singleResponseData : serviceResponse.responseDataList) {
                                response.data.add(singleResponseData);
                            }

                            traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                            return response;
                        }
                    } else {

                        throw new Plc_Exception('606');
                    }
                }
                when 'reservations' {
                    LogTracker.debugLog(CLASS_NAME, 'doPost', 'reservations');

                    List<String> fieldList = new List<String> {'termId'};
                    if (String.isBlank(actionName)) {
                        LogTracker.debugLog(CLASS_NAME, 'doPost', 'Massive createReservation');
                        Plc_Wrappers.GestioneDisponibilitaRequest request = new Plc_Wrappers.GestioneDisponibilitaRequest();
                        Plc_Wrappers.GestioneDisponibilitaRequestBody requestBody = Plc_Wrappers.gestioneDisponibilitaRequestBodyParse(restRequest.requestBody.toString().trim());
                        String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                        if (errorMessage != null) {

                            WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090104] ' + errorMessage);
                                                            traceWsCall(RestContext.request, response, initTimestamp);

                            return response;
                        }
                        request.request.add(requestBody);

                        ServiceResponse serviceResponse = Plc_ReservationsServices.createReservationMass(request, SOURCE_EXT_SYS);
                        WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode);
                        if (serviceResponse.outcomeCode == '200') {
                            response.data = serviceResponse.responseDataList[0];
                        } else {
                            response.data = null;
                        }

                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                        return response;

                    } else if (actionName == 'multipleCreate') {

                        LogTracker.debugLog(CLASS_NAME, 'doPost', 'Single Reservation multipleCreate');
                        Plc_Wrappers.GestioneDisponibilitaRequest request = Plc_Wrappers.gestioneDisponibilitaRequestParse(restRequest.requestBody.toString().trim());
                        if (request.request == null) {

                            throw new Plc_Exception('602');
                        }

                        for (Plc_Wrappers.GestioneDisponibilitaRequestBody requestBody : request.request) {
                            String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                            if (errorMessage != null) {

                                WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090105] ' + errorMessage);
                                                                traceWsCall(RestContext.request, response, initTimestamp);

                                return response;
                            }
                        }
                        ServiceResponse serviceResponse = Plc_ReservationsServices.createReservationMass(request, SOURCE_EXT_SYS);
                        WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);
                        if (serviceResponse.responseDataList != null) {
                            for (Object singleResponseData : serviceResponse.responseDataList) {

                                response.data.add(singleResponseData);
                            }
                        }
                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                        return response;
                    } else if (actionName.contains('delete')) {
                        LogTracker.debugLog(CLASS_NAME, 'doPost', 'contains delete');
                        if (actionName == 'delete') {
                            // single
                            LogTracker.debugLog(CLASS_NAME, 'doPost', 'Single delete');
                            Plc_Wrappers.AnnullaImpegnoRequestBody requestBody = Plc_Wrappers.AnnullaImpegnoRequestBodyParse(restRequest.requestBody.toString().trim());
                            String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                            if (errorMessage != null) {
                                WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090106] ' + errorMessage);
                                                                traceWsCall(RestContext.request, response, initTimestamp);

                                return response;
                            }

                            ServiceResponse serviceResponse = Plc_ReservationsServices.reservationsDelete(requestBody, SOURCE_EXT_SYS);

                            WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode, serviceResponse.outcomeMessage);
                            if (serviceResponse.outcomeCode == '200') {

                                response.data = serviceResponse.responseDataList[0];
                            } else {
                                response.data = null;
                            }
                            traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                            return response;

                        } else {
                            // bulk
                            // ToDevelope
                            throw new Plc_Exception('606');
                        }
                    } else {
                        throw new Plc_Exception('606');
                    }
                }
                when 'work-orders' {

                LogTracker.debugLog(CLASS_NAME, 'doPost', 'work-orders');

                    if (actionName == 'multiplecreate') {
                        // bulk
                        Plc_Wrappers.GestioneOrdineRequest request = Plc_Wrappers.requestGestioneOrdineParse(restRequest.requestBody.toString().trim());
                        ServiceResponse serviceResponse = Plc_WorkOrdersServices.workOrdersCreate(request, SOURCE_EXT_SYS);
                        WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);
                        if (serviceResponse.responseDataList != null) {
                            for (Object singleResponseData : serviceResponse.responseDataList) {
                                response.data.add(singleResponseData);
                            }
                        }
                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                        return response;
                    } else if (String.isBlank(referenceObject) && String.isBlank(actionName)) {
                        // single
                        List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
                        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_Wrappers.gestioneOrdineRequestBodyParse(restRequest.requestBody.toString().trim());
                        String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                        if (errorMessage != null) {
                            WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090107] ' + errorMessage);
                                                            traceWsCall(RestContext.request, response, initTimestamp);

                            return response;
                        }

                        ServiceResponse serviceResponse = Plc_WorkOrdersServices.workOrdersCreate(requestBody, SOURCE_EXT_SYS);
                        WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode, serviceResponse.outcomeMessage);
                        if (serviceResponse.outcomeCode == '200') {
                            response.data = serviceResponse.responseDataList[0];
                        } else {
                            response.data = null;
                        }
                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                        return response;
                    } else if(actionName == 'multipleFulfillment'){
                        // bulk
                        Plc_Wrappers.GestioneOrdineRequest request = Plc_Wrappers.requestGestioneOrdineParse(restRequest.requestBody.toString().trim());
                        ServiceResponse serviceResponse = Plc_WorkOrdersServices.workOrdersFullfilment(request, SOURCE_EXT_SYS);
                        WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);
                        if (serviceResponse.responseDataList != null) {
                            for (Object singleResponseData : serviceResponse.responseDataList) {

                                response.data.add(singleResponseData);
                            }
                        }
                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                        return response;
                    } else if(actionName == 'fulfillment'){
                        // single
                        List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
                        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_Wrappers.gestioneOrdineRequestBodyParse(restRequest.requestBody.toString().trim());
                        String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                        if (errorMessage != null) {
                            WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090108] ' + errorMessage);
                                                            traceWsCall(RestContext.request, response, initTimestamp);

                            return response;
                        }


                        
                        ServiceResponse serviceResponse = Plc_WorkOrdersServices.workOrdersFullfilment(requestBody, SOURCE_EXT_SYS);
                        WsSingleResponse response;
                        response =  new WsSingleResponse(serviceResponse.outcomeCode, serviceResponse.outcomeMessage);

                        List<Plc_Wrappers.AggiornaOrdineResponseData> responseDataListMock = new List<Plc_Wrappers.AggiornaOrdineResponseData>();
                        //Fix for uninstallation - Warning Message
                        if(serviceResponse.outcomeCode == '210'){
                            serviceResponse.outcomeCode = '200';
                            response.result.outcomeCode = '200';
                        }

                        if (serviceResponse.outcomeCode == '200') {

                            response.data = serviceResponse.responseDataList[0];

                        } else {
                            // <-----
                            /*
                            momentaryLogOK.requestUri = restRequest.requestURI;
                            momentaryLogOk.requestHeader= restRequest.headers;
                            momentaryLogOK.requestBody = restRequest.requestBody;
                            momentaryLogOK.responseStackTrace = serviceResponse.outcomeCode;
                            momentaryLogOk.responseMessage = serviceResponse.outcomeMessage;
                            momentaryLogOK.responseStatus = 'E';
                            */
                            
                            Plc_SystemSettings__c settings = Plc_SystemSettings__c.getOrgDefaults();

                            if (settings.Plc_WsMoneticaKoMockResponseEnabled__c) {

                                response = new WsSingleResponse('200', 'OK (Request completed successfully).');

                                Plc_Wrappers.AggiornaOrdineResponseData mockResponse = new Plc_Wrappers.AggiornaOrdineResponseData();
                                mockResponse.workOrderId = 'WORKORDERID';
                                mockResponse.workOrderLegacyId = 'WORKORDERLEGACYID';
                                mockResponse.updated = true;
                                mockResponse.outcomeMessage = null;
                                responseDataListMock.add(mockResponse);

                                serviceResponse.responseDataList = responseDataListMock;

                                response.data = serviceResponse.responseDataList[0];

                                momentaryLogOK.requestUri = restRequest.requestURI;
                                //momentaryLogOk.requestHeader = restRequest.headers;
                                momentaryLogOK.requestBody = restRequest.requestBody.toString().trim();
                                momentaryLogOK.responseStackTrace = '000';
                                momentaryLogOk.responseMessage = serviceResponse.outcomeMessage;
                                momentaryLogOK.requestHeader = String.valueOf(JSON.serializePretty(restRequest.headers) );
                                momentaryLogOK.responseBody = String.valueOf(JSON.serializePretty(serviceResponse.responseDataList[0] ) );
                                momentaryLogOK.responseStatus = 'E';
                                momentaryLogOK.enitityLegacyId = requestBody.workOrderLegacyId;
                                List<WorkOrder> woOrder = [SELECT Id FROM WorkOrder WHERE Plc_Alias__c = :requestBody.workOrderLegacyId];

                                if(woOrder.size()>0){
                                    momentaryLogOK.recordId = woOrder[0].Id;
                                }

                                Plc_LogHelper.logCall(momentaryLogOK);
                            } else {
                                // <-----
                                //<--RIPRISTINARE
                                response.data = null;
                                //<--RIPRISTINARE
                            }
                        }

                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                        return response;
                    } else if(actionName == 'multipleUpdate'){
                        // bulk
                        Plc_Wrappers.GestioneOrdineRequest request = Plc_Wrappers.requestGestioneOrdineParse(restRequest.requestBody.toString().trim());
                        ServiceResponse serviceResponse = Plc_WorkOrdersServices.workOrdersUpdate(request, SOURCE_EXT_SYS);
                        WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);
                        if (serviceResponse.responseDataList != null) {
                            for (Object singleResponseData : serviceResponse.responseDataList) {
                                response.data.add(singleResponseData);
                            }
                        }

                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                        return response;
                    } else if((String.isNotBlank(methodName) && String.isNotBlank(referenceObject)) && String.isBlank(actionName)){
                        // single
                        List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
                        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_Wrappers.gestioneOrdineRequestBodyParse(restRequest.requestBody.toString().trim());
                        String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                        if (errorMessage != null) {
                            WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090109] ' + errorMessage);
                                                            traceWsCall(RestContext.request, response, initTimestamp);

                            return response;
                        }

                        ServiceResponse serviceResponse = Plc_WorkOrdersServices.workOrdersUpdate(requestBody, SOURCE_EXT_SYS);
                        WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode, serviceResponse.outcomeMessage);
                        if (serviceResponse.outcomeCode == '200') {
                            response.data = serviceResponse.responseDataList[0];
                        } else {
                            response.data = null;
                        }

                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                        return response;
                    }  else {
                        throw new Plc_Exception('606');
                    }
                }
                when 'term-ids' {
                    LogTracker.debugLog(CLASS_NAME, 'doPost', 'term-ids');

                    if (actionName=='check') {

                        List<String> fieldList = new List<String> {'termId'};
                        if (actionName == 'check') {
                            Plc_Wrappers.InformazioniMatricolaRequestBody requestBody = Plc_Wrappers.InformazioniMatricolaRequestBodyParse(restRequest.requestBody.toString().trim());
                            String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                            if (errorMessage != null) {

                                WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090110] ' + errorMessage);
                                                                traceWsCall(RestContext.request, response, initTimestamp);

                                return response;
                            }

                            ServiceResponse serviceResponse = Plc_TermIdsServices.termIdsCheck(requestBody,SOURCE_EXT_SYS);
                            WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode);
                            if(serviceResponse.responseDataList != null){
                                response.data = serviceResponse.responseDataList[0];
                            }
                            else{
                                response.data = null; 
                            }

                            traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                            return response;
                        } else {
                            Plc_Wrappers.InformazioniMatricolaRequest request = Plc_Wrappers.informazioniMatricolaRequestParse(restRequest.requestBody.toString().trim());
                            if (request.request == null) {

                                throw new Plc_Exception('602');
                            }
                            for (Plc_Wrappers.InformazioniMatricolaRequestBody requestBody : request.request) {

                                String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                                if (errorMessage != null) {

                                    WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090111] ' + errorMessage);
                                                                    traceWsCall(RestContext.request, response, initTimestamp);

                                    return response;
                                }
                            }

                            ServiceResponse serviceResponse = Plc_TermIdsServices.termIdsCheck(request,SOURCE_EXT_SYS);
                            WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);

                            for (Object singleResponseData : serviceResponse.responseDataList) {
                                response.data.add(singleResponseData);
                            }
                            traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                            return response;
                        }
                    } else if( !String.isBlank(referenceObject) && String.isBlank(actionName)) {
                        List<String> fieldList = new List<String> {'oldTermId', 'newTermId'};

                        Plc_Wrappers.AggiornaTermIdRequestBody requestBody = Plc_Wrappers.AggiornaTermIdRequestBodyParse(restRequest.requestBody.toString().trim());
                        String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                        if (errorMessage != null) {
                            WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090112] ' + errorMessage);
                                                            traceWsCall(RestContext.request, response, initTimestamp);

                            return response;
                        }

                        ServiceResponse serviceResponse = Plc_TermIdsServices.termIdsUpdate(requestBody);
                        WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode);
                        if (serviceResponse.outcomeCode == '200') {
                            response.data = serviceResponse.responseDataList[0];
                        } else {
                            response.data = null;
                        }

                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                        return response;
                    } else {
                        throw new Plc_Exception('606');
                    }
                }
                when 'work-order-line-items' {
                    LogTracker.debugLog(CLASS_NAME, 'doPost', 'work-order-line-items');
                    if (actionName=='check') {
                        //List<String> fieldList = new List<String> {'termId'};
                        if (actionName == 'check') {
                            Plc_Wrappers.VerificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoro requestBody = Plc_Wrappers.verificaMatricolaPerEvasioneRequestBodyOrdiniDiLavoroParse(restRequest.requestBody.toString().trim());
                            /*String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                            if (errorMessage != null) {

                                WsSingleResponse response = new WsSingleResponse('604', errorMessage);
                                return response;
                            }*/

                            ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrderLineItemCheck(requestBody, SOURCE_EXT_SYS);
                            WsSingleResponse response;
                            List<Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData> responseDataListMock = new List<Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData>();
                            response =  new WsSingleResponse(serviceResponse.outcomeCode, serviceResponse.outcomeMessage);

                        if (serviceResponse.outcomeCode == '200') {

                            response.data = serviceResponse.responseDataList[0];
                        } else {
                                
                            Plc_SystemSettings__c settings = Plc_SystemSettings__c.getOrgDefaults();

                            if (settings.Plc_WsMoneticaKoMockResponseEnabled__c) {
                                //RISPOSTA REALE MOCKATA
                                response = new WsSingleResponse('200', 'OK (Request completed successfully).');

                                Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData mockResponse = new Plc_Wrappers.VerificaMatricolaPerEvasioneResponseData();
                                mockResponse.workOrderLegacyId = 'WORKORDERLEGACYID';
                                mockResponse.outcomeMessage = null;
                                mockResponse.serialNumber = 'SERIALNUMBER';
                                mockResponse.workOrderLineItemLegacyId = 'WOLILEGACYID';
                                mockResponse.usable = true;
                                mockResponse.outcomeMessage = null;

                                responseDataListMock.add(mockResponse);

                                serviceResponse.responseDataList = responseDataListMock;

                                response.data = serviceResponse.responseDataList[0];

                                momentaryLogOK.requestUri = restRequest.requestURI;
                                //momentaryLogOk.requestHeader = restRequest.headers;
                                momentaryLogOK.requestBody = restRequest.requestBody.toString().trim();
                                momentaryLogOK.responseStackTrace = '001';
                                momentaryLogOk.responseMessage = '';
                                momentaryLogOK.requestHeader = String.valueOf(JSON.serializePretty(restRequest.headers) );
                                momentaryLogOK.responseBody = String.valueOf(JSON.serializePretty(serviceResponse.responseDataList ) );
                                momentaryLogOK.responseStatus = 'E';
                                momentaryLogOK.enitityLegacyId = requestBody.workOrderLegacyId;
                                
                                Plc_LogHelper.logCall(momentaryLogOK);
                            } else {
                                //<--RIPRISTINARE
                                response.data = null;
                                //<--RIPRISTINARE
                            }
                        }

                            traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                            return response;
                        }  else {
                            throw new Plc_Exception('606');
                        }
                    } else if(actionName == 'multipleUnlock') {
                        Plc_Wrappers.GestioneOrdineRequest request = Plc_Wrappers.requestGestioneOrdineParse(restRequest.requestBody.toString().trim());
                        List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
                        for(Plc_Wrappers.GestioneOrdineRequestBody requestBody: request.workOrder){
                            String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                            if (errorMessage != null) {
                                WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090113] ' + errorMessage);
                                                                traceWsCall(RestContext.request, response, initTimestamp);

                                return response;
                            }
                        }

                        ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrdersUnlock(request, SOURCE_EXT_SYS);
                        WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);
                        response.data = serviceResponse.responseDataList;

                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                        return response;

                    } else if(actionName == 'unlock') {
                        Plc_Wrappers.GestioneOrdineRequest request = new Plc_Wrappers.GestioneOrdineRequest();
                        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_Wrappers.gestioneOrdineRequestBodyParse(restRequest.requestBody.toString().trim());
                        List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
                        String errorMessage = Plc_Utils.isValid(requestBody, fieldList);

                        if (errorMessage != null) {

                            WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090114] ' + errorMessage);
                            traceWsCall(RestContext.request, response, initTimestamp, 0, 0,'', '');
                            return response;
                        }
                        request.workOrder.add(requestBody);
                        ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrdersUnlock(request, SOURCE_EXT_SYS);
                        WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode,serviceResponse.outcomeMessage);
                        if (serviceResponse.outcomeCode == '200') {
                            response.data = serviceResponse.responseDataList[0];
                        } else {
                            response.data = null;
                        }
                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                        return response;

                    } else if(actionName == 'multipleLock') {
                        Plc_Wrappers.GestioneOrdineRequest request = Plc_Wrappers.requestGestioneOrdineParse(restRequest.requestBody.toString().trim());
                        List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
                        for(Plc_Wrappers.GestioneOrdineRequestBody requestBody: request.workOrder){
                            String errorMessage = Plc_Utils.isValid(requestBody, fieldList);
                            if (errorMessage != null) {
                                WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090115] ' + errorMessage);
                                                                traceWsCall(RestContext.request, response, initTimestamp);

                                return response;
                            }
                        }

                        ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrdersLock(request, SOURCE_EXT_SYS);
                        WsMultipleResponse response = new WsMultipleResponse(serviceResponse.outcomeCode);
                        response.data = serviceResponse.responseDataList;

                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,'', '');
                        return response;
                    } else if(actionName == 'lock') {
                        Plc_Wrappers.GestioneOrdineRequest request = new Plc_Wrappers.GestioneOrdineRequest();
                        Plc_Wrappers.GestioneOrdineRequestBody requestBody = Plc_Wrappers.gestioneOrdineRequestBodyParse(restRequest.requestBody.toString().trim());
                        List<String> fieldList = new List<String> {'workOrderLegacyId', 'workOrderDetail', 'workOrderLineItem'};
                        String errorMessage = Plc_Utils.isValid(requestBody, fieldList);

                        if (errorMessage != null) {
                            WsSingleResponse response = new WsSingleResponse('604', '[ERR:CL-0090116] ' + errorMessage);
                            traceWsCall(RestContext.request, response, initTimestamp, 0, 0,'', '');
                            return response;
                        }
                        request.workOrder.add(requestBody);
                        ServiceResponse serviceResponse = Plc_WorkOrderLineItemsServices.workOrdersLock(request, SOURCE_EXT_SYS);
                        WsSingleResponse response = new WsSingleResponse(serviceResponse.outcomeCode,serviceResponse.outcomeMessage);
                        if (serviceResponse.outcomeCode == '200') {
                            response.data = serviceResponse.responseDataList[0];
                        } else {
                            response.data = null;
                        }
                        traceWsCall(RestContext.request, response, initTimestamp, serviceResponse.executionTimeStep1, serviceResponse.executionTimeStep2,serviceResponse.contextLink, serviceResponse.recordId);
                        return response;
                    }
                    else {
                        throw new Plc_Exception('606');
                    }
                } when else {
                    throw new Plc_Exception('606');
                }
            }

        } catch (JSONException jsone) {
            WsSingleResponse response = new WsSingleResponse('600', '[ERR:CL-0090117] ' + jsone.getMessage());
            traceWsCall(RestContext.request, response, initTimestamp);
            return response;
        } catch (Plc_Exception wse) {
            WsSingleResponse response = new WsSingleResponse('603','[ERR:CL-0090118] ' + wse.getMessage());
            system.debug('===response==='+response);
            system.debug('=testtt===[ERR:CL-0090118] ' + wse.getMessage());
            traceWsCall(RestContext.request, response, initTimestamp);
            return response;
        } catch (Exception exc) {
            WsSingleResponse response = new WsSingleResponse('603', '[ERR:CL-0090119] ' + exc.getTypeName() + ' ' + exc.getMessage() + ' ' + exc.getStackTraceString());
            traceWsCall(RestContext.request, response, initTimestamp);
            return response;
        }
    }
}//