/**
 * @author Emanuele Campese
 * @date Creation 22/02/2019
 * @version 1.0
 * @description Plc_LogHelper - it defines a standard log format.
 * @errorcode [ERR:CL-085YYZZ]
 */
public with sharing class Plc_LogHelper{

    /**
     * @author Emanuele Campese
     * @date Creation 08/04/2019
     * @version 1.0
     * @description
     *
     * LogStructure - wrapper for standard log format
     */
    public class LogStructure{
        public String processingTime; // Start Processing - End Processing - Tot Exec 
        public Double executionTimeStep1; // Time to execute reading queries
        public Double executionTimeStep2;// Total processing time 
        public String httpMethod; // Standard http method (POST / GET / PUT / DELETE / PATCH)
        public String requestUri; // CallIn Request Uri
        public String requestHeader; // JSON Request header
        public String requestBody; // // JSON Request body
        public String responseBody; //// JSON Body response
        public String responseStatus; // Synthetic result request (W warning / S success / E exception)
        public String responseMessage; // 
        public String responseStackTrace; // Response Code
        public String recordUrl; // Link to display the result of the call on the desired record
        public String recordType; // DeveloperName recordType to use, if not the default value will be used (WebServices)
        public String enitityLegacyId;
        public String schedulerName;
        //FB 19-06-2019: NEXIPLC-641 [START]
        public String recordId;
        //FB 19-06-2019: NEXIPLC-641 [START]
        //internal property
        private String timeStamp;
        private String stProcessingTime;


        /**
        * @author Emanuele Campese
        * @date Creation 09/04/2019
        * @version 1.0
        * @description The method creates a record of Plc_Log__c in platform.
        *
        * @param ls validate the value for Plc_Logs
        */
        private LogStructure validate(LogStructure ls){

            try {
                ls.timeStamp = String.valueOf(Plc_WsUtils.getRequestTimestamp());
                ls.stProcessingTime = ls.processingTime;
                ls.executionTimeStep1 = (ls.executionTimeStep1 > 0 ? ls.executionTimeStep1 : 0);
                ls.executionTimeStep2 = (ls.executionTimeStep2 > 0 ? ls.executionTimeStep2 : 0);
                ls.recordType = (ls.recordType != null ? Plc_Utils.getRecordTypeId(ls.recordType, 'Plc_Log__c') : Plc_Utils.getRecordTypeId('Plc_WebService', 'Plc_Log__c') );
                ls.requestHeader = (ls.requestHeader != null && ls.requestHeader != '' ? ls.requestHeader : '');
                ls.requestBody = (String.isNotBlank(ls.requestBody) ? ls.requestBody.substring(0, ls.requestBody.length() > 131072 ? 131071 : ls.requestBody.length() ) : '');
                ls.responseBody = ls.responseBody;
                ls.responseMessage = (ls.responseMessage != null && ls.responseMessage != '' ? ls.responseMessage : '');
                ls.responseMessage = ((ls.responseMessage.length() > 255) ? ls.responseMessage.substring(0,255) : ls.responseMessage);
                ls.recordUrl = (ls.recordUrl != null && ls.recordUrl != '' ? ls.recordUrl : '');
                ls.enitityLegacyId = (ls.enitityLegacyId != null && ls.enitityLegacyId != '' ? ls.enitityLegacyId : '');
                ls.schedulerName = (ls.schedulerName != null && ls.schedulerName != '' ? ls.schedulerName : '');
                return ls;

            } catch(Exception ex) {

                throw new Plc_Exception('[ERR:CL-0850101] ' + ex.getMessage(),ex.getStackTraceString());
            }
       }

        /**
        * @author Emanuele Campese
        * @date Creation 09/04/2019
        * @version 1.0
        * @description The method creates a record of Plc_Log__c in platform.
        *
        * @param logStructure contains the values for the fields of the Plc_Log__c.
        */
        private Id insertLog (LogStructure logStructure){

            try {

                //FB 19-06-2019: NEXIPLC-640 Getting messageId from header [START]
                
                /*
                String messageId = '';
                if (logStructure.requestHeader != null && logStructure.requestHeader != '' && logStructure.requestHeader.replaceAll('\\s','').substringBetween('messageId:','"') != null) {
                	messageId = logStructure.requestHeader.replaceAll('\\s','').substringBetween('messageId:','"');
                }*/
                
                //FB 19-06-2019: NEXIPLC-640 Getting messageId from header [START]
                Plc_Wrappers.retryData requestHeaderMap = new Plc_Wrappers.retryData();
                try{
                	if (logStructure.requestHeader != null && logStructure.requestHeader != '') {
                    	requestHeaderMap = (Plc_Wrappers.retryData) JSON.deserialize(logStructure.requestHeader, Plc_Wrappers.retryData.class);
                    }    
                }catch(JSONException ex ){
                    LogTracker.debugLog('Plc_LogHelper','insertLog', 'Error Occurred in deserialize: '+ex.getMessage());
                }
                //FB 19-06-2019: NEXIPLC-640 [END]
                
                Plc_Log__c restLog = new Plc_Log__c(
                    Plc_Timestamp__c          = logStructure.timeStamp,
                    Plc_ProcessingTime__c     = logStructure.stProcessingTime,
                    Plc_ExecutionStep1__c     = logStructure.executionTimeStep1,
                    Plc_TotalExecutionTime__c = logStructure.executionTimeStep2,
                    Plc_RequestType__c        = logStructure.httpMethod,
                    Plc_RequestURI__c         = logStructure.requestUri,
                    Plc_RequestHeader__c      = logStructure.requestHeader,
                    Plc_RequestBody__c        = logStructure.requestBody,
                    Plc_ResponseBody__c       = logStructure.responseBody,
                    Plc_ResponseStatus__c     = logStructure.responseStatus,
                    Plc_ResponseMessage__c    = logStructure.responseMessage,
                    Plc_ResponseStackTrace__c = logStructure.responseStackTrace,
                    Plc_ContextEntity__c      = logStructure.recordUrl,
                    RecordTypeId              = logStructure.recordType,
                    Plc_EntityLegacyId__c     = logStructure.enitityLegacyId,
                    Plc_SchedulerName__c      = logStructure.schedulerName,

                    //FB 19-06-2019: NEXIPLC-640 [START]
                    
					Plc_MessageId__c          = requestHeaderMap.messageId
                    //Plc_MessageId__c = messageId
                    
                    //FB 19-06-2019: NEXIPLC-640 [END]
                );

                if (String.isNotBlank(logStructure.recordId) && logStructure.recordId.startsWith('0WO')) {
                    //It must be assured that the recordId is from a Work Order
                    restLog.Plc_WorkOrder__c = logStructure.recordId;
                }
                //FB 19-06-2019: NEXIPLC-641 [END]
                List<String> fieldsToCheck = new List<String>{'Plc_Timestamp__c','Plc_ProcessingTime__c','Plc_ExecutionStep1__c','Plc_TotalExecutionTime__c','Plc_RequestType__c','Plc_RequestURI__c','Plc_RequestHeader__c','Plc_RequestBody__c','Plc_ResponseBody__c','Plc_ResponseStatus__c','Plc_ResponseMessage__c','Plc_ResponseStackTrace__c','Plc_ContextEntity__c','RecordTypeId','Plc_EntityLegacyId__c','Plc_SchedulerName__c','Plc_MessageId__c','Plc_WorkOrder__c'};
                String resultFound = Plc_Utils.checkCrudFieldPermission('Plc_Log__c', fieldsToCheck, 'insert');
                if(resultFound != null){
                    System.debug('Exception checkCrudFieldPermission');
                    throw new Plc_Exception(resultFound);
                }
                insert restLog;
                return restLog.Id;

            }catch(Exception ex){

                throw new Plc_Exception('[ERR:CL-0850102] ' + ex.getMessage(),ex.getStackTraceString());
            }
       }
    }

    /**
     * @author Emanuele Campese
     * @date Creation 08/04/2019
     * @version 1.0
     * @description create a rest call with a object of logStructrue type
     *
     *
     *
     * @param  logStructure
     * @return void
     */
    public static Id logCall(LogStructure logStructure) {

        if (isLogEnabled()) {
            Id ids = logStructure.insertLog(logStructure.validate(logStructure));
            return ids;
        }
        return null;
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 23/11/2018
     * @version 1.0
     * @description Reads the parameter in Custom setting to turn off the insert
     *              of the RestLog.
     *
     * @return value of the field Plc_RestLogDisabled__c
     */
    public static Boolean isLogEnabled() {
        
        Plc_SystemSettings__c settings = Plc_SystemSettings__c.getOrgDefaults();
        return !settings.Plc_WsLogDisabled__c;
    }

     /**
     * @author Kebe Dam
     * @date Creation 15/11/2018
     * @version 1.0
     * @description This method provides the log for a Rest Call.
     *
     * 
     * @param  RestRequest restRequest
     * @param  Plc_ServiceWs.WsResponse response
     * @param  String processingTime
     * @param  Integer executionTimeStep1
     * @return void.
     */
     public static void logRestCall(System.HttpRequest restRequest, Plc_ServiceWs.WsResponse response, String processingTime, Integer executionTimeStep1, Map<string, string> headers, 
                                    System.HttpResponse restResponse, String recordLink, String recordId) {

        // Check if log is enabled for current call
        String timestamp = String.valueOf(Plc_WsUtils.getRequestTimestamp());
    
        if (isLogEnabled()) {
            String requestBody = '';
            String responseBody = restResponse.getBodyAsBlob().toString();
            Plc_Log__c restLog = new Plc_Log__c(
                Plc_RequestType__c = restRequest.getMethod(),
                Plc_RequestURI__c = restRequest.getEndpoint(),
                Plc_RequestHeader__c = String.valueOf(JSON.serializePretty(headers)),
                Plc_RequestBody__c = requestBody.substring(0, requestBody.length() > 131072 ? 131071 : requestBody.length()),
                Plc_ResponseBody__c = responseBody.substring(0, responseBody.length() > 131072 ? 131071 : responseBody.length()),
                Plc_Timestamp__c = timestamp,
                Plc_ProcessingTime__c = processingTime,
                Plc_ExecutionStep1__c = 0,
                Plc_TotalExecutionTime__c = executionTimeStep1,
                Plc_ResponseStatus__c = response.result.outcomeType,
                Plc_ResponseMessage__c = (response.result.outcomeDescription.length() > 255) ? response.result.outcomeDescription.substring(0,255) : response.result.outcomeDescription,
                Plc_ResponseStackTrace__c = response.result.outcomeCode,
                Plc_ContextEntity__c = recordLink,
                //FB 19-06-2019: NEXIPLC-640 [START]
                Plc_MessageId__c = headers.containsKey(Plc_WsictWs.REQUEST_HEADER_MESSAGEID) ? headers.get(Plc_WsictWs.REQUEST_HEADER_MESSAGEID) : '',
                //FB 19-06-2019: NEXIPLC-640 [END]
                RecordTypeId = Plc_Utils.getRecordTypeId('Plc_WebService', 'Plc_Log__c')
            );
            //FB 19-06-2019: NEXIPLC-641 [START]
            if (String.isNotBlank(recordId) && recordId.startsWith('0WO')) {
                //It must be assured that the recordId is from a Work Order
                restLog.Plc_WorkOrder__c = recordId;
            }
            //FB 19-06-2019: NEXIPLC-641 [END]
            insert restLog;
        }
      }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 23/11/2018
     * @version 1.0
     * @description The method collects the parameters for the Plc_Log__c to track.
     *              NOTE: Only primitive types and collections of them are allowed as parameter
     *                    for 'future' methods.
     *
     * @history - FB 19-06-2019: NEXIPLC-640 Adding "recordId" parameter
     * 
     * @param  request
     * @param  response
     * @param  processingTime
     * @param  executionTimeStep1
     * @param  executionTimeStep2
     * @return void
     */
    public static void logRestCall(RestRequest request, Plc_ServiceWs.WsResponse response, String processingTime, Integer executionTimeStep1, Integer executionTimeStep2, 
                                   String recordLink, String recordId) {

        if (isLogEnabled()) {
            Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
            ls.processingTime = processingTime;
            ls.executionTimeStep1 = executionTimeStep1;
            ls.executionTimeStep2 = executionTimeStep2;
            ls.httpMethod =  request.httpMethod;
            ls.requestUri = request.requestURI;
            ls.requestHeader = String.valueOf(JSON.serializePretty(request.headers));
            ls.requestBody = request.requestBody.toString();
            ls.responseBody = String.valueOf(JSON.serializePretty(response));
            ls.responseStatus = response.result.outcomeType;
            ls.responseMessage = response.result.outcomeDescription;
            ls.responseStackTrace = response.result.outcomeCode;
            ls.recordUrl = recordLink;
            //FB 19-06-2019: NEXIPLC-641 [START]
            ls.recordId = recordId;
            //FB 19-06-2019: NEXIPLC-641 [END]
            logCall(ls);
        }
    }

}