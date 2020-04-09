/**
 * PLC Monetica Rest WebService
 *
 * @author Emanuele Campese
 * @version 1.0
 * @description
 * @testedIn
 * @code
 * @errorcode [ERR:CL-XXXYYZZ]
 * @history
 */
public with sharing class Plc_TermIdsServices extends Plc_ServiceWs {
        private static final String CLASS_NAME = 'Plc_TermIdsServices';
    public static ServiceResponse termIdsCheck(Plc_Wrappers.InformazioniMatricolaRequestBody requestBody,String sourceLegacySystem) {

        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;

        ServiceResponse serviceResponse = new ServiceResponse();
        List<Plc_Wrappers.InformazioniMatricolaResponseData> responseDataList = new List<Plc_Wrappers.InformazioniMatricolaResponseData>();

        Set<String> termidSet = new Set<String>();
        termidSet.add(requestBody.termId);

        beginExecutionStep1 = Datetime.now();
        Map<String, Bit2Shop__Stock_Serials2__c> allStockSerialMap = retrieveStockSerials(termidSet);
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

        if (allStockSerialMap.containsKey(requestBody.termId)) {

            System.debug('has specific');
            Plc_Wrappers.InformazioniMatricolaResponseData responseData = new Plc_Wrappers.InformazioniMatricolaResponseData();
            responseData.termId = requestBody.termId;
            responseData.maker = allStockSerialMap.get(requestBody.termId).Plc_Manufacturer__c;
            responseData.status = allStockSerialMap.get(requestBody.termId).Bit2Shop__Status__c;

            if(sourceLegacySystem=='MONETICA'){

                    responseData.serialNumber = allStockSerialMap.get(requestBody.termId).Plc_EncodedSerialNumber__c;

            }else if (sourceLegacySystem=='WSICT'){

                    responseData.serialNumber = allStockSerialMap.get(requestBody.termId).Plc_ManufacturerSerialNumber__c;
            }
            
            responseData.warehouseAlias = allStockSerialMap.get(requestBody.termId).Bit2Shop__Warehouse_Id__r.Plc_Alias__c;
            responseData.property = allStockSerialMap.get(requestBody.termId).Plc_Property__c;
            responseData.PTSCode = allStockSerialMap.get(requestBody.termId).Plc_PTSCode__c;
            responseData.ICCID = allStockSerialMap.get(requestBody.termId).Bit2Shop__ICCID__c;
            responseData.IMEI = allStockSerialMap.get(requestBody.termId).Bit2Shop__IMEI__c;
            responseData.PCIPEDModel = allStockSerialMap.get(requestBody.termId).Plc_PcipedModel__c;
            responseData.PCIPEDLetterofApproval = allStockSerialMap.get(requestBody.termId).Plc_PcipedLetterOfApproval__c;
            responseData.PCIPEDApprovalNr = allStockSerialMap.get(requestBody.termId).Plc_PcipedApprovalNumber__c;
            responseData.PCIPEDVersion = allStockSerialMap.get(requestBody.termId).Plc_PcipedVersion__c;
            responseData.PCIPEDExpirydate = String.valueOf(allStockSerialMap.get(requestBody.termId).Plc_PcipedExpiryDate__c);
            responseData.outcomeMessage = null;
            responseDataList.add(responseData);
            IF(allStockSerialMap.get(requestBody.termId).Id != null){
                serviceResponse.contextLink = '/lightning/r/Bit2Shop__Stock_Serials2__c/' + allStockSerialMap.get(requestBody.termId).Id + '/view';
            }
            serviceResponse.outcomeCode = '200';
            serviceResponse.executionTimeStep1 = executionTimeStep1;
            serviceResponse.responseDataList = responseDataList;
            return serviceResponse;
        } else {

            System.debug('not available');
            Plc_Wrappers.InformazioniMatricolaResponseData responseData = new Plc_Wrappers.InformazioniMatricolaResponseData();
            responseData.termId = requestBody.termId;
            responseData.maker = null;
            responseData.status = null;
            responseData.serialNumber = null;
            responseData.warehouseAlias = null;
            responseData.property = null;
            responseData.PTSCode = null;
            responseData.ICCID = null;
            responseData.IMEI = null;
            responseData.PCIPEDModel = null;
            responseData.PCIPEDLetterofApproval = null;
            responseData.PCIPEDApprovalNr = null;
            responseData.PCIPEDVersion = null;
            responseData.PCIPEDExpirydate = null;
            responseData.outcomeMessage = Plc_WsUtils.ERROR_MESSAGE_MAP.get('208').userFeedback;
            responseDataList.add(responseData);
            serviceResponse.outcomeCode = '208';
            serviceResponse.executionTimeStep1 = executionTimeStep1;
            serviceResponse.responseDataList = responseDataList;
            return serviceResponse;
        }
    }


    public static ServiceResponse termIdsCheck(Plc_Wrappers.InformazioniMatricolaRequest requestList,String sourceLegacySystem) {

        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;

        ServiceResponse serviceResponse = new ServiceResponse();
        List<Plc_Wrappers.InformazioniMatricolaResponseData> responseDataList = new List<Plc_Wrappers.InformazioniMatricolaResponseData>();

        Set<String> termidSet = new Set<String>();
        for (Plc_Wrappers.InformazioniMatricolaRequestBody request : requestList.request) {

            termidSet.add(request.termId);
        }

        beginExecutionStep1 = Datetime.now();
        Map<String, Bit2Shop__Stock_Serials2__c> allStockSerialMap = retrieveStockSerials(termidSet);
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

        for (Plc_Wrappers.InformazioniMatricolaRequestBody requestBody : requestList.request) {

            if (allStockSerialMap.containsKey(requestBody.termId)) {

                System.debug('has specific');
                Plc_Wrappers.InformazioniMatricolaResponseData responseData = new Plc_Wrappers.InformazioniMatricolaResponseData();
                responseData.termId = requestBody.termId;
                responseData.maker = allStockSerialMap.get(requestBody.termId).Plc_Manufacturer__c;
                responseData.status = allStockSerialMap.get(requestBody.termId).Bit2Shop__Status__c;

                if(sourceLegacySystem=='MONETICA'){

                    responseData.serialNumber = allStockSerialMap.get(requestBody.termId).Plc_EncodedSerialNumber__c;

                }else if (sourceLegacySystem=='WSICT'){

                    responseData.serialNumber = allStockSerialMap.get(requestBody.termId).Plc_ManufacturerSerialNumber__c;
                }

                responseData.warehouseAlias = allStockSerialMap.get(requestBody.termId).Bit2Shop__Warehouse_Id__r.Plc_Alias__c;
                responseData.property = allStockSerialMap.get(requestBody.termId).Plc_Property__c;
                responseData.PTSCode = allStockSerialMap.get(requestBody.termId).Plc_PTSCode__c;
                responseData.ICCID = allStockSerialMap.get(requestBody.termId).Bit2Shop__ICCID__c;
                responseData.IMEI = allStockSerialMap.get(requestBody.termId).Bit2Shop__IMEI__c;
                responseData.PCIPEDModel = allStockSerialMap.get(requestBody.termId).Plc_PcipedModel__c;
                responseData.PCIPEDLetterofApproval = allStockSerialMap.get(requestBody.termId).Plc_PcipedLetterOfApproval__c;
                responseData.PCIPEDApprovalNr = allStockSerialMap.get(requestBody.termId).Plc_PcipedApprovalNumber__c;
                responseData.PCIPEDVersion = allStockSerialMap.get(requestBody.termId).Plc_PcipedVersion__c;
                responseData.PCIPEDExpirydate = String.valueOf(allStockSerialMap.get(requestBody.termId).Plc_PcipedExpiryDate__c);
                responseData.outcomeMessage = null;
                responseDataList.add(responseData);
            } else {

                System.debug('not available');
                Plc_Wrappers.InformazioniMatricolaResponseData responseData = new Plc_Wrappers.InformazioniMatricolaResponseData();
                responseData.termId = requestBody.termId;
                responseData.maker = null;
                responseData.status = null;
                responseData.serialNumber = null;
                responseData.warehouseAlias = null;
                responseData.property = null;
                responseData.PTSCode = null;
                responseData.ICCID = null;
                responseData.IMEI = null;
                responseData.PCIPEDModel = null;
                responseData.PCIPEDLetterofApproval = null;
                responseData.PCIPEDApprovalNr = null;
                responseData.PCIPEDVersion = null;
                responseData.PCIPEDExpirydate = null;
                responseData.outcomeMessage = Plc_WsUtils.ERROR_MESSAGE_MAP.get('208').userFeedback;
                responseDataList.add(responseData);
            }
        }
        serviceResponse.outcomeCode = '200';
        serviceResponse.executionTimeStep1 = executionTimeStep1;
        serviceResponse.responseDataList = responseDataList;
        return serviceResponse;
    }

    public static ServiceResponse termIdsUpdate(Plc_Wrappers.AggiornaTermIdRequestBody requestBody) {
        LogTracker.debugLogBegin(CLASS_NAME, 'termIdsUpdate');
        ServiceResponse serviceResponse = new ServiceResponse();
        List<Plc_Wrappers.AggiornaTermIdResponseData> responseDataList = new List<Plc_Wrappers.AggiornaTermIdResponseData>();
        Datetime beginExecutionStep1 = Datetime.now();
        Datetime endExecutionStep1 = Datetime.now();
        Integer executionTimeStep1 = 0;

        beginExecutionStep1 = Datetime.now();
        List<Plc_TermId__c> termId = [SELECT id FROM Plc_TermId__c WHERE Plc_TermIdCode__c =: requestBody.oldTermId OR
                                                                         Plc_Alias__c =: requestBody.oldTermId 
                                                                    LIMIT 1];
        endExecutionStep1 = Datetime.now();
        executionTimeStep1 +=  Integer.valueOf(((endExecutionStep1.getTime() - beginExecutionStep1.getTime())));

        Plc_Wrappers.AggiornaTermIdResponseData responseData = new Plc_Wrappers.AggiornaTermIdResponseData();
        try{

            if(!termId.isEmpty()){

                termId[0].Plc_Alias__c = requestBody.newTermId;
                termId[0].Plc_TermIdCode__c = requestBody.newTermId;
                update termId;
                responseData.newTermId = requestBody.newTermId;
                responseData.oldTermId = requestBody.oldTermId;
                responseData.updated = true;
                responseData.outcomeMessage = '';
                responseDataList.add(responseData);
                serviceResponse.outcomeCode = '200';
                IF(requestBody.newTermId != null){
                    serviceResponse.contextLink = '/lightning/r/Plc_TermId__c/' + requestBody.newTermId + '/view';
                }
                serviceResponse.executionTimeStep1 = executionTimeStep1;
                serviceResponse.responseDataList = responseDataList;
                return serviceResponse;
            } else {

                serviceResponse.outcomeCode = '206';
                serviceResponse.executionTimeStep1 = executionTimeStep1;
                serviceResponse.responseDataList = responseDataList;
                return serviceResponse;
            }
        } catch (Exception ex){

            serviceResponse.outcomeCode = '207';
            serviceResponse.executionTimeStep1 = executionTimeStep1; 
            return serviceResponse;
        }
    }
    public static Map<String, Bit2Shop__Stock_Serials2__c> retrieveStockSerials(Set<String> termIds) {

        Map<String, Bit2Shop__Stock_Serials2__c> stockSerialMap = new Map<String, Bit2Shop__Stock_Serials2__c>();
        for (Bit2Shop__Stock_Serials2__c stockSerial : [SELECT Id, Plc_Manufacturer__c, Bit2Shop__Status__c,
                Bit2Shop__Serial_Number__c, Bit2Shop__Warehouse_Id__r.Plc_Alias__c,
                Plc_TermId__r.Plc_TermIdCode__c, Plc_Property__c, Plc_PTSCode__c,
                Bit2Shop__ICCID__c, Bit2Shop__IMEI__c, Plc_PcipedModel__c,Plc_EncodedSerialNumber__c,
                Plc_PcipedLetterOfApproval__c, Plc_PcipedApprovalNumber__c,Plc_ManufacturerSerialNumber__c,
                Plc_PcipedVersion__c, Plc_PcipedExpiryDate__c
                FROM Bit2Shop__Stock_Serials2__c
                WHERE Plc_TermId__r.Plc_TermIdCode__c IN: termIds]) {
            System.debug('has results');
            stockSerialMap.put(stockSerial.Plc_TermId__r.Plc_TermIdCode__c, stockSerial);
        }
        return stockSerialMap;
    }
}