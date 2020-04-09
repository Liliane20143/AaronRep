/*****************************************************************
Name:  OB_ValidatingOrder
============================================================
Purpose: Method to call to get the validating order informations
============================================================
History
-------                                                            
VERSION         AUTHOR              DATE            DETAIL          Description
1.0             Eros Orlando       08/01/2019      Created         Creation of the class
*****************************************************************/
@RestResource(urlMapping='/ValidatingOrder/*')
global with sharing class OB_ValidatingOrder {
    public final static String COMPLETED = 'Completed';
    public final static String FAILED = 'Failed';
    
    @HttpPost
    global static OB_ValidatingOrder.ValidatingOrderResponse getValidatingOrder() 
    {
        RestResponse res                            = RestContext.response;
        OB_ValidatingOrder.ValidatingOrderResponse response = new OB_ValidatingOrder.ValidatingOrderResponse();
        OB_ValidatingOrder.ValidatingOrderRequest request   = new OB_ValidatingOrder.ValidatingOrderRequest();
        List<NE__OrderItem__c> itemToUpdateList         = new List<NE__OrderItem__c>();
        Integer responseStatus                          = 500;
        Integer headerStatus                            = 500;
        try
        {
            if(RestContext.request.requestBody ==null){
                responseStatus                  = 400;
                headerStatus                    = 400;
                throw new applicationException('There is no body for the request ');
            }

            String req  = RestContext.request.requestBody.toString();
            request     = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(req,OB_ValidatingOrder.ValidatingOrderRequest.class);
            
            System.debug('OB_ValidatingOrder.ValidatingOrderRequest request: '+ req);
            System.debug('OB_ValidatingOrder.getValidatingOrder request deserialize --> ' +request);
            System.debug('OrderHeader id --> '+request.orderHeaderId);
            
            
            switch on request.sourceType 
            {
                when 'GT' {
                    response = validateGT(request);
                }
                when 'ACQUIRING' {
                    response = validateACQ(request);
                }
                when else {
                    throw new TypeException ('sourceType ' + request.sourceType + ' not recognized');
                }
            }

            if (res != null)            
                res.statusCode                          = response.httpStatus;
        }
        catch(Exception e)
        {
            System.debug('OB_ValidatingOrder.getValidatingOrder Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
            response.httpStatus                         = responseStatus;
            response.error                              = 'OB_ValidatingOrder.getValidatingOrder Exception: ' + e.getMessage();
            if (res != null)            
                res.statusCode                              = headerStatus;
        }
        
        return response;
    }
    
    private static OB_ValidatingOrder.ValidatingOrderResponse validateGT(OB_ValidatingOrder.ValidatingOrderRequest request)
    {
        OB_ValidatingOrder.ValidatingOrderResponse response = new OB_ValidatingOrder.ValidatingOrderResponse();
        response.httpStatus                     = 404;
        response.error                          = 'Not found';
        response.orderHeaderId                  = request.orderHeaderId;
        
        List<NE__Order_Header__c> orderHeaders = [SELECT Id,
                                                 OB_FulfilmentStatus__c,
                                                 OB_GT_Error_Code__c,
                                                 OB_GT_Error_Desc__c,
                                                 OB_GT_Error_TS__c
                                                 FROM NE__Order_Header__c WHERE id = :request.orderHeaderId];
            
        if (orderHeaders != null && orderHeaders.size() == 1)
        {
            if (orderHeaders[0].OB_GT_Error_TS__c != null && orderHeaders[0].OB_GT_Error_Code__c == 0)
                throw new applicationException('[GT] Order is already validated.');
            
            orderHeaders[0].OB_GT_Error_Code__c     = integer.valueOf(request.errorCode);
            orderHeaders[0].OB_GT_Error_Desc__c     = request.errorCode + ' - [' + request.sourceName + '] ' + request.errorDescription;
            orderHeaders[0].OB_GT_Error_TS__c       = DateTime.valueOf(request.timeStamp);  
            if (orderHeaders[0].OB_GT_Error_Code__c != 0)
            {
                orderHeaders[0].OB_FulfilmentStatus__c = FAILED;
                List<NE__OrderItem__c> items = UpdateChildrenGT(orderHeaders[0]);
                if (items.size()>0) update(items);
            }
            
            update(orderHeaders[0]);

            response.httpStatus                     = 200;
            response.error                          = 'OK';
            response.orderHeaderId                  = request.orderHeaderId;
        }
        
        return response;
    }
    
    private static List<NE__OrderItem__c> UpdateChildrenGT(NE__Order_Header__c orderHeader)
    {
        List<Id> orderIds = new List<Id>(new Map<Id, NE__Order__c>([SELECT Id
                                        FROM NE__Order__c WHERE NE__Order_Header__c = :orderHeader.Id]).keySet());
            
        List<NE__OrderItem__c> orderItems =  [SELECT Id,OB_FulfilmentStatus__c FROM NE__OrderItem__c
                            WHERE (     (NE__ProdId__r.RecordType.DeveloperName = 'Pagobancomat' 
                                        AND NE__ProdId__r.OB_Acquirer__c != 'NEXI') 
                                    OR (OB_TermId__c != '')
                                  ) AND NE__OrderId__c in :orderIds ];
        
        for(NE__OrderItem__c item : orderItems)
            item.OB_FulfilmentStatus__c = FAILED;
        
        System.debug('NE__OrderItem__c for GT: ' + orderItems);
        return orderItems;
    }
    
    private static OB_ValidatingOrder.ValidatingOrderResponse validateACQ(OB_ValidatingOrder.ValidatingOrderRequest request)
    {
        OB_ValidatingOrder.ValidatingOrderResponse response = new OB_ValidatingOrder.ValidatingOrderResponse();
        response.httpStatus                     = 404;
        response.error                          = 'Not found';
        response.orderHeaderId                  = request.orderHeaderId;
        
        List<NE__Order_Header__c> orderHeaders = [SELECT Id,
                                                 OB_FulfilmentStatus__c,
                                                 OB_ACQ_Error_Code__c,
                                                 OB_ACQ_Error_Desc__c,
                                                 OB_ACQ_Error_TS__c
                                                 FROM NE__Order_Header__c WHERE id = :request.orderHeaderId];
            
        if (orderHeaders != null && orderHeaders.size() == 1)
        {
            if (orderHeaders[0].OB_ACQ_Error_TS__c != null && orderHeaders[0].OB_ACQ_Error_Code__c == 0)
                throw new applicationException('[ACQUIRING] Order is already validated.');   
            
            orderHeaders[0].OB_ACQ_Error_Code__c    = integer.valueOf(request.errorCode);
            orderHeaders[0].OB_ACQ_Error_Desc__c    = request.errorCode + ' - [' + request.sourceName + '] ' + request.errorDescription;
            orderHeaders[0].OB_ACQ_Error_TS__c      = DateTime.valueOf(request.timeStamp);  
            if (orderHeaders[0].OB_ACQ_Error_Code__c != 0)
            {
                orderHeaders[0].OB_FulfilmentStatus__c = FAILED;
                List<NE__OrderItem__c> items = UpdateChildrenACQ(orderHeaders[0]);
                if (items.size()>0) update(items);
            }

            update(orderHeaders[0]);
            
            response.httpStatus                     = 200;
            response.error                          = 'OK';
            response.orderHeaderId                  = request.orderHeaderId;
        }
        
        return response;
    }
    
    private static List<NE__OrderItem__c> UpdateChildrenACQ(NE__Order_Header__c orderHeader)
    {
        List<String> lovs = new List<String>();
        for (NE__Lov__c lov :[SELECT NE__Value2__c FROM NE__Lov__c WHERE NE__Sub_Type__c = 'TIPOLOGICHE' AND NE__Type__c='TRACKING'])
        {
            lovs.add(lov.NE__Value2__c);
        }
        
        List<Id> orderIds = new List<Id>(new Map<Id, NE__Order__c>([SELECT Id
                                        FROM NE__Order__c WHERE NE__Order_Header__c = :orderHeader.Id]).keySet());
            
        List<NE__OrderItem__c> orderItems = [
                                SELECT Id, OB_FulfilmentStatus__c FROM NE__OrderItem__c 
                                WHERE ((    (NE__ProdId__r.RecordType.DeveloperName = 'Acquiring' and NE__ProdId__r.OB_Acquirer__c = 'NEXI')
                                            OR (NE__ProdId__r.RecordType.DeveloperName = 'PCI') 
                                            OR (NE__ProdId__r.RecordType.DeveloperName = 'Commissione') 
                                            OR (NE__ProdId__r.RecordType.DeveloperName = 'Pagobancomat' 
                                                AND NE__ProdId__r.OB_Acquirer__c = 'NEXI' 
                                                AND NE__Parent_Order_Item__c = null))
                                        AND (NE__OrderId__c in :orderIds)
                                        )];
        
        List<NE__OrderItem__c> orderItems2 = [
                                SELECT Id, OB_FulfilmentStatus__c FROM NE__OrderItem__c 
                                WHERE (NE__ProdId__r.RecordType.DeveloperName = 'Vas'
                                        AND (NE__ProdId__r.OB_Codice_sfdc__c NOT IN :lovs)
                                        AND (NE__OrderId__c in :orderIds)
                                       )];
        
        List<NE__OrderItem__c> tot = new List<NE__OrderItem__c>();
        tot.addAll(orderItems);
        tot.addAll(orderItems2);
        
        for(NE__OrderItem__c item : tot)
            item.OB_FulfilmentStatus__c = FAILED;
        System.debug('NE__OrderItem__c for ACQUIRING: ' + tot);
        return tot;
    }
    
    
    public class applicationException extends Exception {}
    
    //  ----------------------------------------------------------------------------------------------------------------------
    //  REQUEST
    global class ValidatingOrderRequest
    {
        global String orderHeaderId                                 {get;set;}
        global String sourceName                                    {get;set;}
        global String sourceType                                    {get;set;}
        global String errorCode                                     {get;set;}
        global String errorDescription                              {get;set;}
        global String timeStamp                                     {get;set;}
        
    }
    
    //  ----------------------------------------------------------------------------------------------------------------------
    //  RESPONSE
    global class ValidatingOrderResponse
    {
        global Integer httpStatus                                   {get;set;}
        global String error                                         {get;set;}        
        global String orderHeaderId                                 {get;set;}
    }
}