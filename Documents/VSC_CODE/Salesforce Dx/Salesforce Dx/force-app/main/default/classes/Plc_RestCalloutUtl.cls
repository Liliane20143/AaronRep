/**
 * @author Dam Kebe
 * @date Creation 22/11/2018
 * @description Plc_RestCalloutUtl - Controller used to test the correct invocation of webservice.
 */
public with sharing class Plc_RestCalloutUtl {
	
    //Response
    public String responsePost {get; set;}
    //Response
    //public Plc_RequestSettings__c requestSettings {get; set;}{requestSettings = Plc_RequestSettings__c.getInstance();}
 	
	public Plc_RestCalloutUtl() {
		
        responsePost = '';
	}

	/**
     * @author Gabriele Giovanni Tanzi
     * @date 19/10/2018
     * @description It makes a 'POST' to ensure that the call to the webservice properly works.
     * @param Nothing
     * @return Nothing
     */
    public void run(String endPoint, String payloadJson, String flowCode, Boolean isGet, String clientId, String clientSecret) {
        try {

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            if(!isGet) {
                request.setMethod('POST');
            } else {
                request.setMethod('GET');
            }

            String token = OB_UtilityCallingServices.checkToken();
            request.setHeader(OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('MessageId', String.valueOf(Datetime.now()));//REFACTOR: must be update with Hash code creating method 
            request.setHeader('FlowCode', flowCode);
            request.setHeader('TransmissionDate', Datetime.now().format('yyyy-MM-dd-hh.mm.ss.SSS'));
            request.setHeader('CLIENT_ID', clientId);
            request.setHeader('CLIENT_SECRET', clientSecret);

            /*
            //request.setHeader('OperatorCode', 'application/json');
            request.setHeader('OperatorUserName', UserInfo.getUserName());
            request.setHeader('SF_SANDBOX_NAME', requestSettings.Plc_SfSandboxName__c);
            request.setHeader('SF_SANDBOX_USERNAME', requestSettings.Plc_SfSandboxUsername__c);
            request.setHeader('SF_SANDBOX_PASSWORD', requestSettings.Plc_SfSandboxPassword__c);
            request.setHeader('SF_SANDBOX_CONSUMER_KEY', requestSettings.Plc_SfSandboxConsumerKey__c);
            request.setHeader('SF_SANDBOX_CONSUMER_SECRET', requestSettings.Plc_SfSandboxConsumerSecret__c);
            */
            if (!isGet) request.setBody(payloadJson);

            Datetime initTimestamp = Datetime.now();
            String processingTime = Plc_WsUtils.addTimeValue('Init', initTimestamp.format(Plc_WsUtils.TIMESTAMP_FORMAT));
            HttpResponse response = http.send(request);
            Datetime endTimestamp = Datetime.now();
            responsePost = response.getBody();
            System.debug('responsePost: ' + responsePost);
            responsePost.replace('&quot;', '"');
            Map<String,Object> payloadMap =  (Map<String,Object>)JSON.deserializeUntyped(responsePost);
            System.debug('payloadMap.get("result"): ' + payloadMap.get('result'));
            Plc_ServiceWs.WsResponse wsResponse = new Plc_ServiceWs.WsResponse();
            if(Boolean.valueOf(payloadMap.get('result'))){

                wsResponse.result.outcomeType = 'S';
                wsResponse.result.outcomeDescription = 'Richiesta inoltrata con successo.';
                wsResponse.result.outcomeCode = '200';
            } else {

                wsResponse.result.outcomeType = 'W';
                wsResponse.result.outcomeDescription = 'Non è possibile procedere con la richiesta in base alle informazioni selezionate.';
                wsResponse.result.outcomeCode = '404';   
            }
            System.debug('wsResponse: ' + wsResponse);

            //get the list of header names (keys)
            List<String> headerkeys = new List<String>{'Authorization','Content-Type', 'MessageId', 'FlowCode', 'TransmissionDate', 'CLIENT_ID', 'CLIENT_SECRET'};

            //create an object to store your header key-value pairs
            Map<string, string> headers = new map<string, string>();

            //iterate through they keys, and populate your map
            for(string s : headerkeys){
               headers.put(s,request.getHeader(s));
               system.debug('header: ' + s + ' value: ' + request.getHeader(s));
            }
            Integer executionTimeStep1 = Integer.valueOf(((endTimestamp.getTime() - initTimestamp.getTime())));

            processingTime += Plc_WsUtils.addTimeValue('End', endTimestamp.format(Plc_WsUtils.TIMESTAMP_FORMAT));
            processingTime += Plc_WsUtils.addTimeValue('Tot Exec', String.valueOf(executionTimeStep1) + 'ms');
            Plc_LogHelper.logRestCall(request, wsResponse, processingTime, executionTimeStep1, headers, response,'', '');

        } catch (Exception ex) {
            responsePost = 'WS ERROR: ' + ex.getMessage() + ' ' + ex.getCause() + ' ' + ex.getStackTraceString();
            System.debug(responsePost);
        }

    }
}