/**
 * @author Kebe Dam
 * @date Creation 19/09/2018
 * @version 1.0
 * @description Plc_ServiceWs - Plc virtual Rest WebService.
 * @errorcode [ERR:CL-006YYZZ]
 */
global with sharing virtual class Plc_ServiceWs {

    public static final String MONETICA='M';
    public static final String WSICT='W';

    /**
     * @author Kebe Dam
     * @date Creation 19/09/2018
     * @version 1.0
     * @description
     * @code 01
     *
     * @param  obj              [description]
     * @param  requestTimestamp [description]
     * @return                  Evaluation
     */
    global static Boolean isResourceChanged(SObject obj, Long requestTimestamp) {

        return requestTimestamp == null || requestTimestamp <
               Plc_WsUtils.getRequestTimestamp((DateTime)obj.get('LastModifiedDate'));
    }

    /**
     * @author Kebe Dam
     * @date Creation 11/01/2019
     * @version 1.0
     * @description map containing configurations for each request type
     * @code 02
     */
    public static Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap {
        get{

            if(workOrderConfigurationMap != null){

                return workOrderConfigurationMap;
            }

            workOrderConfigurationMap = new Map<String, Plc_WorkOrderConfiguration__c>();
            for(Plc_WorkOrderConfiguration__c workOrderConfiguration : [SELECT Name, Plc_IntegrationName__c, Plc_EligibleOperationTypes__c, 
                                                                        Plc_NeedsCalculation__c, Plc_NeedsReservation__c
                                                                        FROM Plc_WorkOrderConfiguration__c]){

                workOrderConfigurationMap.put('' + workOrderConfiguration.Plc_IntegrationName__c.toUpperCase() + 
                                            workOrderConfiguration.Plc_EligibleOperationTypes__c.toUpperCase(), 
                                            workOrderConfiguration);
            }
            return workOrderConfigurationMap;
        }
        set;
    }
    /**
     * [getWorkOrderConfigurationMap description]
     * @return [description]
     * @code 03
     */
    public static Map<String, Plc_WorkOrderConfiguration__c> getWorkOrderConfigurationMap(){

        return workOrderConfigurationMap;
    }
    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 21/11/2018
     * @version 1.0
     * @description Reads the parameter in Custom setting to turn off the writing services.
     * @code 03
     *
     * @return value of the field Plc_WsWriteInMaintenance__c
     */
    global static Boolean isInMaintenance(String sourceExtSystem) {

        Plc_SystemSettings__c settings = Plc_SystemSettings__c.getOrgDefaults();
        if(sourceExtSystem==MONETICA){
            return settings.Plc_WsMoneticaInMaintenance__c;
        }
        else if(sourceExtSystem==WSICT){
            return settings.Plc_WsWsictInMaintenance__c;
        }
        return false;
    }


    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 07/12/2018
     * @version 1.0
     * @description The method traces the WS call (NO DB).
     * @code 05
     *
     * @param  request       [description]
     * @param  response      [description]
     * @param  initTimestamp [description]
     * @return               [description]
     */
    global static void traceWsCall(RestRequest request, WsResponse response, Datetime initTimestamp) {
        Datetime endTimeStamp = Datetime.now();
        String processingTime = Plc_WsUtils.makeProcessingTime(initTimestamp, endTimeStamp);
        Plc_LogHelper.logRestCall(RestContext.request, response, processingTime, Math.abs(Integer.valueOf((endTimeStamp.getTime() - initTimestamp.getTime())) ), 0,'', '');
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 07/12/2018
     * @version 1.0
     * @description The method traces the WS call (YES DB).
     * @code 06
     *
     * @history - FB 19-06-2019: NEXIPLC-640 Adding "recordId" parameter
     *
     * @param  request            
     * @param  response           
     * @param  initTimestamp      
     * @param  executionTimeStep1 
     * @param  executionTimeStep2 
     * @return                    
     */
    global static void traceWsCall(RestRequest request, WsResponse response, Datetime initTimestamp, Integer executionTimeStep1, Integer executionTimeStep2, String recordLink, String recordId) {
        Datetime endTimeStamp = Datetime.now();
        String processingTime = Plc_WsUtils.makeProcessingTime(initTimestamp, endTimeStamp);
        Plc_LogHelper.logRestCall(RestContext.request, response, processingTime, executionTimeStep1, executionTimeStep2, recordLink, recordId);
    }

    /**
     * @author Kebe Dam
     * @date Creation 13/11/2018
     * @version 1.0
     * @description Default response.
     * @code 07
     *
     * @return WsMultipleResponse
     */
    global virtual class WsResponse {

        global Result result {get; set;} {result = new Result();}
        global WsResponse() {

            this.result = Plc_WsUtils.ERROR_MESSAGE_MAP.get('200');
        }

        global WsResponse(String errorCode) {

            this.result = Plc_WsUtils.ERROR_MESSAGE_MAP.get(errorCode);
        }

        global WsResponse(String errorCode, String outcomeDescription) {

            this.result = Plc_WsUtils.ERROR_MESSAGE_MAP.get(errorCode);
            if(String.isNotBlank(outcomeDescription)){

                this.result.outcomeDescription = outcomeDescription;
            }
        }
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 21/11/2018
     * @version 1.0
     * @description Default response for Maintenance (code 605).
     *              Extends WsResponse.
     * @code 08
     *
     * @return WsMaintenanceResponse
     */
    global class WsMaintenanceResponse extends WsResponse {

        public WsMaintenanceResponse() {
            super('605');
        }
    }

    /**
     * @author Di Lorenzo Fabio
     * @date Creation 13/11/2018
     * @version 1.0
     * @description Default response for PLC.
     *              Extends WsResponse.
     * @code 09
     *
     * @return WsSingleResponse
     */
    global class WsSingleResponse extends WsResponse {

        public Object data;

        public WsSingleResponse() {

            super();
        }

        public WsSingleResponse(String errorcode) {

            super();
            this.result = Plc_WsUtils.ERROR_MESSAGE_MAP.get(errorcode);
            this.data = null;
        }

        global WsSingleResponse(String errorCode, String outcomeDescription) {

            this.result = Plc_WsUtils.ERROR_MESSAGE_MAP.get(errorCode);
            if(String.isNotBlank(outcomeDescription)){

                this.result.outcomeDescription = outcomeDescription;
                //Da rimuovere quando si vuole che lo user feedback sia indipendente dal commento tecnico
                if(errorCode!='600' && errorCode!='603' && errorCode!='604'){
                    this.result.userFeedback = this.result.userFeedback+' '+this.result.outcomeDescription;
                }
                //
            }
        }
    }

    /**
     * @author Di Lorenzo Fabio
     * @date Creation 13/11/2018
     * @version 1.0
     * @description Default response for PLC.
     *              Extends WsResponse.
     * @code 10
     *
     * @return WsMultipleResponse
     */
    global class WsMultipleResponse extends WsResponse {

        public List<Object> data {get; set;} {data = new List<Object>();}

        public WsMultipleResponse() {

            super();
        }

        public WsMultipleResponse(String errorcode) {

            super();
            this.result = Plc_WsUtils.ERROR_MESSAGE_MAP.get(errorcode);
        }
    }

    /**
     * @author Di Lorenzo Fabio
     * @date Creation 13/11/2018
     * @version 1.0
     * @description Default result.
     * @code 11
     *
     * @return Result
     */
    global class Result {

        global String outcomeType;
        global String outcomeCode;
        global String outcomeDescription;
        global String userFeedback;

        global Result() {}

        global Result(String outcomeType, String outcomeCode, String userFeedback, String outcomeDescription) {

            this.outcomeType = outcomeType;
            this.outcomeCode = outcomeCode;
            this.userFeedback = userFeedback;
            this.outcomeDescription = outcomeDescription;
        }
    }

    /**
     * @author Kebe Dam
     * @date Creation 03/12/2018
     * @version 1.0
     * @description Service response.
     * @code 12
     *
     * @return ServiceResponse
     */
    global virtual class ServiceResponse {
        global String outcomeCode {get; set;}
        global String outcomeMessage {get; set;}
        global List<Object> responseDataList {get; set;} {responseDataList = new List<Object>();}
        global Integer executionTimeStep1 {get; set;} {executionTimeStep1 = 0;}
        global Integer executionTimeStep2 {get; set;} {executionTimeStep2 = 0;}
        // MZ 20190130: Put new attribute for Record Context link ----- START
        global String contextLink {get; set;}
        // MZ 20190130: Put new attribute for Record Context link ----- END
        //FB 19-06-2019: NEXIPLC-641 [START]
        global String recordId {get; set;}
        //FB 19-06-2019: NEXIPLC-641 [END]
    }

}