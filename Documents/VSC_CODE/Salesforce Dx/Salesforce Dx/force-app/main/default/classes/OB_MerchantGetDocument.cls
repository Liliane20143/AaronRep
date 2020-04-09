/*********************************************************************
Name:  OB_MerchantGetDocument
======================================================================                                                                                                       
History                                                            
                                                        
  AUTHOR            DATE CREATED        DESCRIPTION
  gianluigi.virga   01/08/2019			Class to handle the retrieve of merchant document

**********************************************************************/
global with sharing class OB_MerchantGetDocument {
    public class Documents
    {
        list<Document> documents;
    }
    public class Document
    {
        String documentId;
        list<Metadata> metadata;
    }
    public class Metadata
    {
        String metadataLabel;
        List<Values> values;
        String indexId;
    }
    public class Values
    {
        String str;
    }
    @AuraEnabled
    public static Map<String, Map<String,String>> getMerchantDocumentsFromFilenet( String merchantId ){
        Map<String, Map<String, String>> mapOfDocuments = new Map<String,Map<String, String>>();
        try{
            String url = 'callout:OB_callService/api/merchants/' + merchantId + '/documents?documentStatus=ACTIVE';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            String token = OB_UtilityCallingServices.checkToken();
            req.setHeader(OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token);
            req.setHeader('Content-Type', 'application/json');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug( '###MY RES' + res.getBody());
            String jsonResponse = res.getBody();
            String response = jsonResponse.replace('string', 'str').replaceAll('\\\\', '');
            Documents docsList = (Documents) JSON.deserialize( response, Documents.class);
            List<String> listOfServicePoint = new List<String>();
            List<String> listOfOrder = new List<String>();
            List<String> listOfLogReq = new List<String>();
            Map<string, string> contractType = OB_AttachedDocumentationsController.retrieveContracts();
            if(docsList != null){
                System.debug('docsList : '+docsList);
                for (Document doc : docsList.documents){
                    String docId = doc.documentId;
                    System.debug('docId: '+ docId);
                    System.debug('doc is : ' + doc);
                    Map<String,String> attributes = new Map<String,String>();
                    for(Metadata meta : doc.metadata){
                        // DOC TYPE
                        if(meta.metadataLabel.equalsIgnoreCase(System.Label.OB_DocType)){
                            attributes.put(System.Label.OB_DocType, meta.values.get(0).str);
                        }
                        // TEMPLATE NAME
                        if(meta.metadataLabel.equalsIgnoreCase(System.Label.OB_DocumentTemplateName)){
                            attributes.put(System.Label.OB_DocumentTemplateName, meta.values.get(0).str);
                        }
                        //DOCUMENT NAME
                        if(meta.metadataLabel.equalsIgnoreCase(System.Label.OB_DocumentFileName)){
                            attributes.put(System.Label.OB_DocumentFileName, meta.values.get(0).str);
                        }
                        // ORDER
                        if(meta.metadataLabel.equalsIgnoreCase(System.Label.OB_OrderId)){
                            
                            for(OB_MerchantGetDocument.Values singleVal : meta.values){
                                System.debug('## singleVal is . ' + singleVal.str);
                                attributes.put(System.Label.OB_OrderId, singleVal.str);
                                listOfOrder.add(singleVal.str);
                            }
                            // listOfOrder.add(meta.values.get(doc).str);
                        }
                        // SERVICE POINT
                        if(meta.metadataLabel.equalsIgnoreCase(System.Label.OB_SalesPoint)){
                             for(OB_MerchantGetDocument.Values singleVal : meta.values){
                                attributes.put(System.Label.OB_SalesPoint, singleVal.str);
                            }
                        }
                        // LOG REQUEST
                        if(meta.metadataLabel.equalsIgnoreCase(System.Label.OB_requestIDLabel)){
                            for(OB_MerchantGetDocument.Values singleVal : meta.values){
                                System.debug('## singleVal is . ' + singleVal.str);
                                attributes.put('requestId', singleVal.str);
                                listOfLogReq.add(singleVal.str);
                            }
                            // listOfLogReq.add(meta.values.get(0).str);
                        }
                        // CREATED DATE
                        if(meta.metadataLabel.equalsIgnoreCase(System.Label.OB_DateCreatedLabel)){
                            String createdDateReplaced = meta.values.get(0).str;
                            createdDateReplaced = createdDateReplaced.replace('\\', '');
                            System.debug('## createdDateReplaced is : ' + createdDateReplaced);
                            attributes.put(System.Label.OB_DateCreatedLabel, createdDateReplaced);
                        }
                    }
                    if(attributes.get(System.Label.OB_DocType).equalsIgnoreCase(System.Label.OB_ContractType)){
                        String type = contractType.get(attributes.get(System.Label.OB_DocumentTemplateName));
                        attributes.put(System.Label.OB_DocType, type.toUpperCase());
                    }
                    mapOfDocuments.put(docId, attributes);
                }
                Map<String, Object> mapServicePointNameAndAbi = OB_MerchantGetDocument.getDynamicFieldsFromMapOfDocuments(listOfOrder, listOfLogReq, mapOfDocuments);
                if(mapOfDocuments != null) {

                    
                    Set<String> keyList = mapOfDocuments.keySet();
                    if(!keyList.isEmpty() && keyList != null){
                        List<OB_LogRequest__c> currentLogRequests = (List<OB_LogRequest__c>) mapServicePointNameAndAbi.get('OB_LogRequest__c');
                        List<NE__Order__c> currentOrders =(List<NE__Order__c>) mapServicePointNameAndAbi.get('NE__Order__c');
                        for(String key : keyList){
                            //set service point name and Abi attribute
                            if(mapServicePointNameAndAbi.containsKey('OB_LogRequest__c')) {                                
                                for(OB_LogRequest__c currentLogRequest : currentLogRequests) {
                                    if(currentLogRequest != null && mapOfDocuments.get(key).get('isAnagraphic') == 'true') {

                                        // SERVICE POINT HYPERLINK (ID + NAME)
                                        if(!String.isBlank(currentLogRequest.OB_ServicePointId__r.Name  ) && mapOfDocuments.get(key).get('salesPointId') == currentLogRequest.OB_ServicePointId__c) {
                                            mapOfDocuments.get(key).put(System.Label.OB_ServicePoint, currentLogRequest.OB_ServicePointId__c);
                                            mapOfDocuments.get(key).put('servicePointName', currentLogRequest.OB_ServicePointId__r.Name);
                                            
                                        }
                                        // LOG REQUEST HYPERLINK (ID + NAME)
                                        if(mapOfDocuments.get(key).get('requestId') != null  && !String.isBlank(currentLogRequest.Name) &&  mapOfDocuments.get(key).get('requestId') == currentLogRequest.Id) {
                                            mapOfDocuments.get(key).put('logRequestName', currentLogRequest.Name);
                                            mapOfDocuments.get(key).put('requestId', currentLogRequest.Id);

                                            // ABI
                                            mapOfDocuments.get(key).put('ABI', String.valueOf(currentLogRequest.OB_ABI__c));
                                        }
                                    }
                                }
                            } 
                            if(mapServicePointNameAndAbi.containsKey('NE__Order__c')){
                                for(NE__Order__c currentOrder : currentOrders) {
                                    if(currentOrder != null && mapOfDocuments.get(key).get('isConsistence') == 'true')  {

                                        System.debug('## currentOrder.OB_ABI__c is : ' + currentOrder.OB_ABI__c);
                                        System.debug('## mapOfDocuments.OB_MAINTENANCE_ABI is : ' + mapOfDocuments.get(key).get(System.Label.OB_MAINTENANCE_ABI) );

                                        // SERVICE POINT HYPERLINK (ID + NAME)
                                        if(mapOfDocuments.get(key).get('salesPointId') == currentOrder.OB_Service_Point__c) {
                                            mapOfDocuments.get(key).put('servicePointName', currentOrder.OB_Service_Point__r.Name);
                                        }

                                        // ORDER HYPERLINK (ID + NAME)
                                        if(mapOfDocuments.get(key).get(System.Label.OB_OrderId) == currentOrder.Id) {
                                            mapOfDocuments.get(key).put('orderId', currentOrder.Id);
                                            mapOfDocuments.get(key).put('orderName', currentOrder.Name);
                                            // ABI
                                            mapOfDocuments.get(key).put(System.Label.OB_MAINTENANCE_ABI, currentOrder.OB_ABI__c);
                                        }
                                        
                                    }
                                } 
                            }
                        }
                    }
                }
                System.debug('mapOfDocuments: '+mapOfDocuments);
            }
        }catch(Exception e)
		{
			System.debug(Logginglevel.ERROR,'OB_MerchantGetDocuments.getMerchantDocumentsFromFilenet Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
		}
        return mapOfDocuments;
    }

    @AuraEnabled
    public static Map<String , String> getTokenJWE(string documentId){
		Map<String , String> returnMap = new Map<String , String>();
		returnMap = OB_UtilityCallingServices.getTokenJWEMethod(documentId);
		return returnMap;
	}


    /*
        *   Authhor     :   Morittu Andrea
        *   Date        :   30/Aug/2019
        *   Description :   Method to match document object Ids with salesforce object Ids
    */

    @AuraEnabled
    public static Map<String, Object> getDynamicFieldsFromMapOfDocuments( List<String> listOfOrder, List<String> listOfLogReq, Map<String, Map<String, String>> mapOfDocuments ){
        Map<String, Object> toReturn = new Map<String, Object>();

        Boolean isConsistence = false;
        Boolean isAnagraphic = false;
        List<String> angraphicIDS =  new List<String>();
        List<String> consistenceID =  new List<String>();
        if(mapOfDocuments != null) {
            Set<String> keyList = mapOfDocuments.keySet();
            for(String  key     :   keyList) {
                if(!String.isEmpty(mapOfDocuments.get(key).get('requestId'))) {
                    isAnagraphic = true;
                    isConsistence = false;
                    mapOfDocuments.get(key).put('isAnagraphic', 'true');
                    mapOfDocuments.get(key).put('isConsistence', 'false');
                    angraphicIDS.add(mapOfDocuments.get(key).get('requestId'));

                } if(!String.isEmpty(mapOfDocuments.get(key).get(System.Label.OB_OrderId))) {
                    isConsistence = true;
                    isAnagraphic = false;
                    mapOfDocuments.get(key).put('isAnagraphic', 'false');
                    mapOfDocuments.get(key).put('isConsistence', 'true');
                    consistenceID.add(mapOfDocuments.get(key).get('orderId'));
                }                    
            }
        }        
        
        if(!consistenceID.isEmpty()) {
            List<NE__Order__c> orderRelated = [SELECT   Id,
                                                        Name,
                                                        OB_ABI__c, 
                                                        OB_Service_Point__c,
                                                        OB_Service_Point__r.Name 
                                                FROM    NE__Order__c 
                                                WHERE   Id IN : consistenceID];
            if(!orderRelated.isEmpty() && orderRelated.size() > 0){
                toReturn.put('NE__Order__c', orderRelated);
            }    
        }
        if(!angraphicIDS.isEmpty()) {
            List<OB_LogRequest__c> logReqRelated =  [SELECT     Id, 
                                                                Name,
                                                                OB_ABI__c, 
                                                                OB_ServicePointId__c,
                                                                OB_ServicePointId__r.Name,
                                                                OB_OrderId__c,
                                                                OB_OrderId__r.OB_ABI__c
                                                    FROM        OB_LogRequest__c 
                                                    WHERE       Id IN: angraphicIDS ];
            if(!logReqRelated.isEmpty() && logReqRelated.size() > 0){
                toReturn.put('OB_LogRequest__c', logReqRelated);
            }
        } else {
            toReturn.put('ERROR', null);
        }
        System.debug('getServicePointNameAndAbiForServicePoint return is : ' + toReturn);
        return toReturn;
    }

}