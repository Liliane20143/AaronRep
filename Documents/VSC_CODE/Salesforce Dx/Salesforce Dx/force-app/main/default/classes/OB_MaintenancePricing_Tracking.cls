/*****************************************************************
Name: OB_MaintenancePricing_Tracking
============================================================
Purpose:  Class used to get Maintenance Pricing tracking order information

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Francesca Ribezzi        02/05/2019                            
********************************************************************************/

/*
*@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
*@date 02/05/2019
*@description this method is called by MIP to track Maintenance Pricing orders
*/
@RestResource(urlMapping='/MaintenancePricingTrackingOrder/*') //TODO: choose an url
global without sharing class OB_MaintenancePricing_Tracking { 

	@HttpPost
	global static OB_TrackingUtility.TrackingOrderResponseMaintenance trackMaintenancePricingOrder(){
		RestResponse res = RestContext.response;
        //TrackingOrderResponse is the httpStatus 
		OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();
		
		try{
			if(RestContext.request.requestBody ==null){
				//TODO: throw new Exception;
                throw new MaintenancePricingException('There is no body for the request ');
			}
			String req 	= RestContext.request.requestBody.toString();
            System.debug('req body: ' + req);
			OB_TrackingUtility.TrackingOrderRequestMaintenance request 	= (OB_TrackingUtility.TrackingOrderRequestMaintenance)JSON.deserialize(req,OB_TrackingUtility.TrackingOrderRequestMaintenance.class);
			//calling method here
            response = orderItemSortChecker(request);
              //TODO: create Plc_LogHelper 
		}catch(Exception e){
			System.debug('•	OB_MaintenancePricing_Tracking trackMaintenancePricingOrder Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
			response.httpStatus 						= 400;
            response.message = '•	OB_MaintenancePricing_Tracking trackMaintenancePricingOrder Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();
			res.statusCode 								= 400;
            //TODO: create Plc_LogHelper 
		}
		return response;
	}
																						   
    /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 02/05/2019
    *@description this method divides orderItems by pricing and commissional model processes
    */

     global static OB_TrackingUtility.TrackingOrderResponseMaintenance orderItemSortChecker(OB_TrackingUtility.TrackingOrderRequestMaintenance request){
        String orderId = request.orderId;
        
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();
        response.httpStatus 	= 200;	
        if(String.isBlank(orderId)){
            response.httpStatus 						= 400;
            return response;  
        }
																	 
        String variazioneEconomica = OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA;
        List<NE__OrderItem__c> orderItems =
            [
                SELECT 
                id,
                NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c,
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c,
                NE__Action__c,//Simone Misani 11/11/2019 fix Tracking
                NE__Qty__c //Simone Misani 11/11/2019 fix Tracking
                FROM NE__OrderItem__c
                WHERE NE__OrderId__c = :orderId
                AND NE__OrderId__r.NE__Order_Header__r.NE__Type__c = 'ChangeOrder'
                AND NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c = :variazioneEconomica
                AND OB_FulfilmentStatus__c != 'Cancelled' 
            ];

            if(orderItems.size() > 0){
                if(orderItems[0].NE__OrderId__r.OB_Model_Changed__c){
                    //call model commission method:
                   return  commissionModelTracking(request, orderItems);
                }else{
                    //call pricing method:
                    return pricingMaintenanceTracking(request, orderItems);
                }  
            }else{
                //TODO: change return
                response.httpStatus 						= 400;
                response.message 						    = 'order cancelled';
                return response;
            }

     }

        /*
        *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
        *@date 07/05/2019
        *@description this method is used to track Maintenance Pricing process orderItems
        */
												
       global static OB_TrackingUtility.TrackingOrderResponseMaintenance pricingMaintenanceTracking(OB_TrackingUtility.TrackingOrderRequestMaintenance request, List<NE__OrderItem__c> orderItems){
            //creating two lists: one for equens and the other for monetica 
            List<NE__OrderItem__c> equensOrderItems = new List<NE__OrderItem__c>();
            List<NE__OrderItem__c> moneticaOrderItems = new List<NE__OrderItem__c>();
            finalResultObj finalResponseEq = new finalResultObj();
            finalResultObj finalResponseMonetica = new finalResultObj();
            finalResultObj finalRespObj = new finalResultObj();
            OB_TrackingUtility.TrackingOrderResponseMaintenance   finalResponse= new OB_TrackingUtility.TrackingOrderResponseMaintenance ();
            //TODO: change this loop?:
            for(NE__OrderItem__c o : orderItems ){
                String recordType = o.NE__ProdId__r.RecordType.DeveloperName; 
                if(recordType == 'Acquiring' || (recordType == 'Vas' && o.NE__ProdId__r.OB_Acquirer__c == 'NEXI')){
                    equensOrderItems.add(o);
                    //Simone Misani WN-437 08/10/2019 START
                }else if(recordType == 'Terminali' ||recordType == 'Pagobancomat' || recordType=='eCommerce' || recordType == 'Moto'||(recordType == 'Vas' && o.NE__ProdId__r.OB_Acquirer__c != 'NEXI')){
                    moneticaOrderItems.add(o);
                }
                //Simone Misani WN-437 08/10/2019   END
                
            }
            System.debug('equensOrderItems: ' + equensOrderItems);
            System.debug('moneticaOrderItems: ' + moneticaOrderItems);
            if(equensOrderItems.size() > 0 && request.Acquiring != null) //enrico.purificato WN-147
            {
              finalResponseEq =  equensMaintenanceTracking(request, equensOrderItems);
            }
            
            if(moneticaOrderItems.size() > 0 && request.GT != null) //enrico.purificato WN-147
            {
               finalResponseMonetica = moneticaMaintenanceTracking(request, moneticaOrderItems);
            }
            //TODO: update configuration, call checkOrderItemsStatus (orderId)
            if(finalResponseEq.httpStatus == 400 || finalResponseMonetica.httpStatus == 400){ //TODO: oppure 500
                finalResponse.httpStatus = 400;
                return finalResponse;
            }else{
               finalRespObj =  updateEquensAndMoneticaOrderItems(finalResponseEq, finalResponseMonetica, request.orderId);
              finalResponse.httpStatus =  finalRespObj.httpStatus;
              return finalResponse;
            }

			   
       }
        global static finalResultObj updateEquensAndMoneticaOrderItems(finalResultObj finalResponseEq, finalResultObj finalResponseMonetica, String orderId){
            OB_TrackingUtility.TrackingOrderResponseMaintenance response = new  OB_TrackingUtility.TrackingOrderResponseMaintenance();
            finalResultObj finalRes = new finalResultObj();
            NE__Order__c configuration = new NE__Order__c();
            configuration.Id = orderId;
            //davide.franzini - WN-605 - 11/10/2019 - START
            if(finalResponseEq.orderHeaderId != null){
                configuration.NE__Order_Header__c = finalResponseEq.orderHeaderId;
            }
            //davide.franzini - WN-605 - 11/10/2019 - END
            if(finalResponseEq.fulfilmentStatus == 'Failed' || finalResponseMonetica.fulfilmentStatus == 'Failed'){ //francesca.ribezzi 08/11/19 - PROD-49 - setting failed on order
                configuration.OB_FulfilmentStatus__c = 'Failed';
            }
            configuration.OB_Tracking_Errors__c = finalResponseEq.trackingErrors + finalResponseMonetica.trackingErrors;
            List<NE__OrderItem__c> fullOrderItemsList = new List<NE__OrderItem__c>();
            fullOrderItemsList.addAll(finalResponseEq.childOrderItems);
            fullOrderItemsList.addAll(finalResponseMonetica.childOrderItems);
            try{
                update configuration;
                upsert fullOrderItemsList;
                response = checkOrderItemsStatus(configuration.Id);
                finalRes.httpStatus = response.httpStatus;
                finalRes.message = finalResponseEq.message + finalResponseMonetica.message;  //francesca.ribezzi 19/11/19 - PROD-88 adding message
                return finalRes;
            }catch(Exception e){
                 System.debug('OB_MaintenancePricing_Tracking updateEquensAndMoneticaOrderItems Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());   
                 finalRes.httpStatus = 400;
                 finalRes.message = 'OB_MaintenancePricing_Tracking updateEquensAndMoneticaOrderItems Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();
                 return finalRes;
            }
           
        }
											 
        global static finalResultObj equensMaintenanceTracking(OB_TrackingUtility.TrackingOrderRequestMaintenance request, List<NE__OrderItem__c> equensOrderItems){
            System.debug('into equensMaintenanceTracking');
           // OB_TrackingOrder.TrackingOrderResponse response = new OB_TrackingOrder.TrackingOrderResponse();
           finalResultObj finalRes = new finalResultObj();
					
            String errorConfig = '';
            //external id, OK
            Map<String, String> externalIdResultMap = new Map<String, String>();
            Map<String, Boolean> externalIdMissingFieldsMap = new Map<String, Boolean>();
            Map<String, NE__OrderItem__c> externalIdOrderItemMap = new Map<String, NE__OrderItem__c>();
            List<NE__OrderItem__c> rootOrderItems = new  List<NE__OrderItem__c>();
            Boolean missingRequiredFields = false;
            List<OB_TrackingUtility.puntoVendita> pvCodesList = new List<OB_TrackingUtility.puntoVendita>();
														 
            for(NE__OrderItem__c eq :  equensOrderItems){  
                externalIdOrderItemMap.put(eq.Id, eq);												 
            }														  
            for(OB_TrackingUtility.Acquiring acq :  request.Acquiring){
                pvCodesList.addAll(acq.PVCodes);
            }  
            System.debug('externalIdOrderItemMap + pvCodesList size: ' + externalIdOrderItemMap.size() + ' ____ ' + pvCodesList.size());
            for(OB_TrackingUtility.puntoVendita pv : pvCodesList){      
                for(OB_TrackingUtility.changes ch : pv.changes){	
                    if(externalIdOrderItemMap.containsKey(ch.externalId)){
                        //TODO: check start date requirements for pricing equens
                        NE__OrderItem__c tempOrderItem = new NE__OrderItem__c();
                        tempOrderItem = externalIdOrderItemMap.get(ch.externalId);  
                        tempOrderItem.OB_StartValidationDate__c = String.isNotBlank(pv.startDate) ? (DateTime)Json.deserialize('"'+pv.startDate+'"', DateTime.class) : tempOrderItem.OB_StartValidationDate__c;
                        rootOrderItems.add(tempOrderItem);
                        System.debug('rootItem and externalId matched!');
                    }
                    externalIdResultMap.put(ch.externalId, ch.result);
                    //check required fields:
                     if((String.isBlank(ch.result) || String.isBlank(ch.externalId) || String.isBlank(pv.startDate))&& ch.result == 'OK'){//Simone Misani WN-437 01/10/2019
                        externalIdMissingFieldsMap.put(ch.externalId, true);
                    }
                    if(ch.result == 'KO'){
                        for(OB_TrackingUtility.ErrorList e : ch.errors){
                            if(String.isBlank(e.description) || String.isBlank(e.code)){
                                externalIdMissingFieldsMap.put(ch.externalId, true);
                            }
                        }	 
                        errorConfig += errorStringFormatter(true, ch.errors);
                    }
                }    
            }
            if(!externalIdMissingFieldsMap.isEmpty()){
                System.debug('OB_MaintenancePricing_Tracking equensMaintenanceTracking - there are some missing required fields!');
                finalRes.httpStatus 						= 400;
                return finalRes;   
            }else{
                //change StartDate and OB_FulfilmentStatus__c on Pricing child orderItems 
                return updateEquensAcqAndVasOrderItems(externalIdMissingFieldsMap,externalIdResultMap,rootOrderItems, errorConfig); 
            }
        }

    /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 08/05/2019
    *@description this method is used to process equensAcqAndVasOrderItems
    */
    global static finalResultObj updateEquensAcqAndVasOrderItems(Map<String, Boolean> externalIdMissingFieldsMap,     Map<String, String> externalIdResultMap,List<NE__OrderItem__c> rootOrderItems, String errorConfig){
       System.debug('into updateEquensAcqAndVasOrderItems');
       OB_TrackingOrder.TrackingOrderResponse response = new OB_TrackingOrder.TrackingOrderResponse();
       List<String> koResultCheckerList = new List<String>(); 
       String fulfilmentStatus = 'Completed';
       finalResultObj resObj = new finalResultObj();
       List<NE__OrderItem__c> listUpdateOI = new List<NE__OrderItem__c>();//Simone Misani 11/11/2019 fix Tracking

        List<NE__OrderItem__c> childOrderItems =
            [
                SELECT 
                id,
                OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                OB_Tech_Outcome_Monetica__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                NE__OrderId__r.NE__Order_Header__c,
                NE__Root_Order_Item__c,
                NE__Qty__c,
                NE__ProdId__r.name,
                (SELECT id,Name, NE__Value__c, NE__Old_Value__c FROM NE__Order_Item_Attributes__r)//Simone Misani 11/11/2019 fix Tracking
                FROM NE__OrderItem__c
                WHERE NE__Root_Order_Item__c IN :rootOrderItems 
                AND (OB_FulfilmentStatus__c != 'Cancelled' AND OB_FulfilmentStatus__c != 'Completed')
            ]; //francesca.ribezzi 08/11/19 - PROD-49 adding OB_FulfilmentStatus__c
        System.debug('childOrderItems size: ' + childOrderItems.size());
        for(NE__OrderItem__c ci : childOrderItems){
            for(NE__OrderItem__c root : rootOrderItems){
                if(ci.NE__Root_Order_Item__c == root.Id){
                    ci.OB_Tech_Outcome_Equens__c = externalIdResultMap.get(root.Id);
                    System.debug('ci.OB_Tech_Outcome_Equens__c: ' +  ci.OB_Tech_Outcome_Equens__c);
                    String changeResult =  externalIdResultMap.get(root.Id);
                    if(changeResult == 'OK'){
                        ci.OB_FulfilmentStatus__c = 'Completed';
                    //    ci.NE__OrderId__r.OB_FulfilmentStatus__c = 'Completed';
                    }else if(changeResult == 'KO'){
                        ci.OB_Tech_Outcome_Equens__c = 'KO';
                        ci.OB_FulfilmentStatus__c = 'Failed';//Simone Misani 11/11/2019 fix Tracking
                        ci.OB_AcquiringErrorTracking__c= errorConfig;//Simone Misani 18/10/2019
                        koResultCheckerList.add(changeResult);
                     //   ci.NE__OrderId__r.OB_FulfilmentStatus__c = 'Failed';
                    } 
                }								 
            }
        }
        //Simone Misani 11/11/2019 fix Tracking START
        if(koResultCheckerList.size() > 0){
            //fulfilmentStatus = '';
            listUpdateOI.addAll(rollBackmodify(childOrderItems));
           
        }
        //Simone Misani 11/11/2019 fix Tracking STOP
        //davide.franzini - WN-605 - 11/10/2019 - START
        if(rootOrderItems[0].NE__OrderId__r.NE__Order_Header__c != null){
            resObj.orderHeaderId =      rootOrderItems[0].NE__OrderId__r.NE__Order_Header__c;
        }
        //davide.franzini - WN-605 - 11/10/2019 - END
        resObj.fulfilmentStatus =   fulfilmentStatus;
        resObj.childOrderItems =    (koResultCheckerList.size() > 0) ? listUpdateOI :  childOrderItems;//Simone Misani 11/11/2019 fix Tracking
        resObj.trackingErrors =     errorConfig;
        resObj.httpStatus   =       null;

        return resObj;
    }

    global static finalResultObj moneticaMaintenanceTracking(OB_TrackingUtility.TrackingOrderRequestMaintenance request, List<NE__OrderItem__c> moneticaOrderItems){
       // OB_TrackingOrder.TrackingOrderResponse response = new OB_TrackingOrder.TrackingOrderResponse();
       finalResultObj response = new finalResultObj();
        String errorConfig = '';
        Map<String, NE__OrderItem__c> externalIdOrderItemMap = new Map<String, NE__OrderItem__c>();
        List<OB_TrackingUtility.TermsIdInformation> terminalInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
       // List<NE__OrderItem__c> rootOrderItems = new List<NE__OrderItem__c>();
        Map<String, Boolean> externalIdMissingFieldsMap = new Map<String, Boolean>();
        Map<String, OB_TrackingUtility.pricingChange> changePricingOrderItemMap = new Map<String, OB_TrackingUtility.pricingChange>();
        for(NE__OrderItem__c oi :  moneticaOrderItems){  
            if(String.isNotBlank(oi.OB_TermId__c)){
                //adding only the pos Items to this map:
                externalIdOrderItemMap.put(oi.OB_TermId__c, oi);
            }
        }
        for(OB_TrackingUtility.GT gt : request.GT){
            System.debug('request.GT: ' + request.GT);
           for(OB_TrackingUtility.puntoVendita pv: gt.PVCodes){
                //START--Simone Misani WN-187 02/09/2019
               if(pv.terminalInformation == null || pv.terminalInformation.size() == 0){
                    throw new MaintenancePricingException('There is no Terminal Informations for the request ');
               }
               //END--Simone Misani WN-187 02/09/2019
               terminalInfoList.addAll(pv.terminalInformation);
           }
        }
        for(OB_TrackingUtility.TermsIdInformation t : terminalInfoList){ 
            //START--Simone Misani WN-187 02/09/2019
            if(String.isBlank(t.terminalId)){
                 throw new MaintenancePricingException('There is no  terminalId for the request ');
            } 
            //END--Simone Misani WN-187 02/09/2019
            if(externalIdOrderItemMap.containsKey(t.terminalId)){
                //START francesca.ribezzi 05/09/19 - WN-187 - throwing a new exce if pricingChange is null
                if(t.pricingChange == null){
                    throw new MaintenancePricingException('pricingChange is null'); 
                }
                //END francesca.ribezzi 05/09/19 - WN-187
                OB_TrackingUtility.pricingChange pc = new OB_TrackingUtility.pricingChange();
                pc = t.pricingChange; //francesca.ribezzi WN-187 - 18/09/19 pricingChange is not a list 
                if((String.isNotBlank(pc.status) && String.isBlank(t.terminalId)) || String.isBlank(pc.status) || (String.isBlank(pc.startDate) && pc.status == 'Changed')){
                    //if there is a pricing change but the terminalId is empty, there are some missing fields:
                    externalIdMissingFieldsMap.put(t.terminalId, true);
                }else if(String.isNotBlank(pc.status)){
                    changePricingOrderItemMap.put(externalIdOrderItemMap.get(t.terminalId).Id, pc);
                }
                if(pc.status == 'Refused'){
                    System.debug('pricingChange status is Refused');
                    for(OB_TrackingUtility.ErrorList e : pc.Errors){
                        System.debug('errors....' + e.code + e.description);
                        if(String.isBlank(e.code) || String.isBlank(e.description)){
                            externalIdMissingFieldsMap.put(t.terminalId, true);
                        }
                    }
                    errorConfig += errorStringFormatter(false, pc.errors);
                }
            }
        }
        if(!externalIdMissingFieldsMap.isEmpty()){
            System.debug('OB_MaintenancePricing_Tracking moneticaMaintenanceTracking - there are some missing required fields!');
            response.httpStatus 						= 400;
            
            return response;   
        }else{
            //change StartDate and OB_FulfilmentStatus__c on Pricing child orderItems 
            return updateMoneticaOrderItems(changePricingOrderItemMap,errorConfig, moneticaOrderItems[0].NE__OrderId__c);   //START francesca.ribezzi 19/11/19 - PROD-88 - passing orderId
        }
    }

    /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 08/05/2019
    *@description this method is used to update Monetica orderItems
    */
    global static finalResultObj updateMoneticaOrderItems(Map<String,OB_TrackingUtility.pricingChange> changePricingOrderItemMap, String errorConfig, Id orderId){  //START francesca.ribezzi 19/11/19 - PROD-88 passing orderId
       OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();
       finalResultObj resObj = new finalResultObj();
        List<String> koResultCheckerList = new List<String>();
        String fulfilmentStatus = 'Completed';
        List<NE__OrderItem__c> listUpdateOI = new List<NE__OrderItem__c>();//Simone Misani 11/11/2019 fix Tracking
        List<NE__OrderItem__c> childOrderItems =
            [
                SELECT 
                id,
                OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Monetica__c,
                OB_Tech_Outcome_Equens__c ,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                NE__OrderId__r.NE__Order_Header__c,
                NE__Root_Order_Item__c,
                NE__StartDate__c,
                NE__Qty__c,
                NE__ProdId__r.name,
                NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                NE__Action__c,
                (SELECT id,Name, NE__Value__c, NE__Old_Value__c FROM NE__Order_Item_Attributes__r)//Simone Misani 11/11/2019 fix Tracking
                FROM NE__OrderItem__c
                WHERE (NE__Root_Order_Item__c IN :changePricingOrderItemMap.keySet()
                        OR NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Pagobancomat' )
                AND (OB_FulfilmentStatus__c != 'Cancelled' AND  OB_FulfilmentStatus__c != 'Completed')
                AND NE__OrderId__c = :orderId
            ];  //francesca.ribezzi 08/11/19 - PROD-49 - adding  OB_FulfilmentStatus__c
                                //19/11/19 - PROD-88 adding filters for pagobancomat pricing
       
        if(childOrderItems.size() == 0){ 
             throw new MaintenancePricingException('There are no price changed child-orderItems for this termId');  
        }
        for(NE__OrderItem__c ci : childOrderItems){
            OB_TrackingUtility.pricingChange pc = new OB_TrackingUtility.pricingChange();
            if(changePricingOrderItemMap.containsKey(ci.NE__Root_Order_Item__c)){  
                pc = changePricingOrderItemMap.get(ci.NE__Root_Order_Item__c);
            }
            //START francesca.ribezzi 19/11/19 - PROD-88 adding filters for pagobancomat pricing 
            if(ci.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Pagobancomat'){ 
                pc =  changePricingOrderItemMap.values()[0];
            }
            if(pc == null){
                continue;
            }
           //END francesca.ribezzi - 19/11/19 - PROD-88 
            if(pc.status == 'Changed'){
                ci.OB_Tech_Outcome_Monetica__c = 'OK';
                ci.OB_FulfilmentStatus__c = 'Completed';
                // ci.NE__OrderId__r.OB_FulfilmentStatus__c = 'Completed';
                ci.NE__StartDate__c = String.isNotBlank(pc.startDate) ? (DateTime)Json.deserialize('"'+pc.startDate+'"', DateTime.class)  :  ci.NE__StartDate__c;
            }else if(pc.status == 'Refused'){
                ci.OB_Tech_Outcome_Monetica__c = 'KO';
                ci.OB_FulfilmentStatus__c = 'Failed';
                ci.OB_GTErrorTracking__c = errorConfig;
                //ci.NE__OrderId__r.OB_FulfilmentStatus__c = 'Failed';
                koResultCheckerList.add('KO');
            } 
        }
        //Simone Misani 11/11/2019 fix Tracking START
        if(koResultCheckerList.size() > 0){
          //fulfilmentStatus = 'Failed';
            listUpdateOI.addAll(rollBackmodify(childOrderItems));
          
           
        }
        //Simone Misani 11/11/2019 fix Tracking END
        //davide.franzini - WN-605 - 11/10/2019 - START
        if(childOrderItems[0].NE__OrderId__r.NE__Order_Header__c != null){
            resObj.orderHeaderId =      childOrderItems[0].NE__OrderId__r.NE__Order_Header__c;
        }
        //davide.franzini - WN-605 - 11/10/2019 - END
        resObj.fulfilmentStatus =   fulfilmentStatus;
        resObj.childOrderItems =    (koResultCheckerList.size() > 0) ? listUpdateOI : childOrderItems;//Simone Misani 11/11/2019 fix Tracking
        resObj.trackingErrors =     errorConfig;
        resObj.httpStatus   =       null;

        return resObj;
    }

    /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 06/05/2019
    *@description this method is used to track commission Model process orderItems
    */
    global static OB_TrackingUtility.TrackingOrderResponseMaintenance commissionModelTracking(OB_TrackingUtility.TrackingOrderRequestMaintenance request,  List<NE__OrderItem__c> orderItems){
        String startDate = '';
        String changeResult = '';
        String externalId = '';
        String code = '';
        String description = '';
        String errorConfig = '';
        Boolean missingRequiredFields = false;
        List<OB_TrackingUtility.changes> changesList = new List<OB_TrackingUtility.changes>();
        List<OB_TrackingUtility.puntoVendita> pvCodesList = new List<OB_TrackingUtility.puntoVendita>();
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();
        //get root V/M orderItem:
        NE__OrderItem__c visaMastercard = new NE__OrderItem__c();
        for(NE__OrderItem__c oi : orderItems){
            if(oi.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase('visamastercard')  && oi.NE__Root_Order_Item__c == null){ //enrico.purificato WN-189
                visaMastercard = oi;
            }
        }
        for(OB_TrackingUtility.Acquiring acq :  request.Acquiring){
            pvCodesList.addAll(acq.PVCodes);
        }
       
        //match root visaMastercard with Acquiring externalId:
        for(OB_TrackingUtility.puntoVendita pv :pvCodesList ){
            startDate = pv.startDate;
            for(OB_TrackingUtility.changes ch : pv.changes){
                changesList.add(ch);
                externalId = ch.externalId;
                if(ch.externalId == visaMastercard.Id){ 
                    if(String.isNotBlank(startDate)){
                        visaMastercard.OB_StartValidationDate__c = (DateTime)Json.deserialize('"'+startDate+'"', DateTime.class) ; 
                        System.debug('rootItem and externalId matched!');
                    }
                }
                    changeResult = ch.result;
            }
        }    
        //check required fields:
        
        if(changeResult == 'KO'){
            for(OB_TrackingUtility.Changes c : changesList){
                    for(OB_TrackingUtility.ErrorList e : c.errors){
                    if(String.isBlank(e.description) || String.isBlank(e.code)){
                        response.message = 'error description or error code are mmissing';
                        missingRequiredFields = true;
                    }
                }
                errorConfig += errorStringFormatter(true, c.errors);
            }
        }
        if(String.isBlank(changeResult) && changeResult != 'KO'){
            missingRequiredFields = true;
            response.message = 'changeResult - missing';
        }
        if(String.isBlank(externalId) && changeResult != 'KO'){
            missingRequiredFields = true;
            response.message = 'externalId - missing';
        }
        if(String.isBlank(startDate) && changeResult != 'KO'){
            missingRequiredFields = true;
            response.message = 'startDate - missing';
        }

        if(missingRequiredFields){
            System.debug('OB_MaintenancePricing_Tracking commissionModelTracking - there are some missing required fields!');
            response.httpStatus 						= 400;
            return response;  
        }else{
            //change StartDate and OB_FulfilmentStatus__c on Pricing child orderItems 
            return updateStartDateEquensAndStatus(changeResult,visaMastercard.Id, orderItems, errorConfig, startDate); //visaMastercard.Id
        }
    }

    /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 06/05/2019
    *@description this method is used to update commission Model process orderItems
    */
    global static OB_TrackingUtility.TrackingOrderResponseMaintenance  updateStartDateEquensAndStatus(String changeResult, String visaMid,  List<NE__OrderItem__c> orderItems, String errorConfig, String startDate){
      
       System.debug('into updateStartDateEquensAndStatus');
       OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();

        for(NE__OrderItem__c ci : orderItems){
            if(ci.NE__Root_Order_Item__c == visaMid){
                ci.OB_Tech_Outcome_Equens__c = changeResult;
                if(changeResult == 'OK'){
                   ci.OB_FulfilmentStatus__c = 'Completed';
                   ci.NE__OrderId__r.OB_FulfilmentStatus__c = 'Completed';
                   ci.NE__StartDate__c = String.isNotBlank(startDate) ? (DateTime)Json.deserialize('"'+startDate+'"', DateTime.class) :  ci.NE__StartDate__c;
                }else if(changeResult == 'KO'){
                   //ci.OB_FulfilmentStatus__c = 'Failed';
                   //ci.NE__OrderId__r.OB_FulfilmentStatus__c = 'Failed';
                } 
            }
        }
        //enrico.purificato WN-189 START
      
        //enrico.purificato WN-189 END
        try{
            if(changeResult == 'KO'){
                rollBackCommisisonModel(orderItems,errorConfig);
            }
            update orderItems;
            //START---Simone Misani WN-285 "23/08/2019
            if(changeResult == 'OK')
            {
                OB_TrackingOrderMaintenance.updatePciandCommissione(orderItems[0].NE__OrderId__c, false);//Simone Misani WN-186 22/08/2019
            }
            //END---Simone Misani WN-285 "23/08/2019
            NE__Order__c configuration = new NE__Order__c();
            configuration.Id = orderItems[0].NE__OrderId__c;
            //davide.franzini - WN-605 - 11/10/2019 - START
            if(orderItems[0].NE__OrderId__r.NE__Order_Header__c != null){
                configuration.NE__Order_Header__c =   orderItems[0].NE__OrderId__r.NE__Order_Header__c;
            }
            //davide.franzini - WN-605 - 11/10/2019 - END
            configuration.OB_FulfilmentStatus__c = 'Completed';//orderItems[0].NE__OrderId__r.OB_FulfilmentStatus__c;//Simone Misani 11/11/2019 fix Tracking
            configuration.OB_Tracking_Errors__c =  errorConfig;
            update configuration;
            //check for items in pending or sent:
            response = checkOrderItemsStatus(configuration.Id);
        }catch(Exception e){
            System.debug('•	OB_MaintenancePricing_Tracking updateStartDateEquensAndStatus Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());   
            response.httpStatus = 400;
            response.message = '•	OB_MaintenancePricing_Tracking updateStartDateEquensAndStatus Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();
        }
        //TODO change return 
        return  response ;

    }

    /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 06/05/2019
    *@description this method is used to check orderItems status
    */
    public static OB_TrackingUtility.TrackingOrderResponseMaintenance checkOrderItemsStatus(String orderId){
        System.debug('into checkOrderItemsStatus');
         OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();

          List<NE__OrderItem__c> orderItems = 
          [
              SELECT Id, OB_FulfilmentStatus__c
              FROM
              NE__OrderItem__c
              WHERE NE__OrderId__c = :orderId
              AND (OB_FulfilmentStatus__c = 'Sent' OR OB_FulfilmentStatus__c = 'Pending') 
          ];
          if(orderItems.size() == 0){
                //set LogRequest status to confirmed
                OB_TrackingOrderMaintenance.updateLogRequest(orderId);//Simone Misani 28/08/2019 WN-285
                //call createAsset which also update logRequest status to confirmed
                System.debug('calling createAsset');
                //OB_UtilityCallingServices.createAsset(orderId, OB_UtilityConstants.MAINTENANCE);
          }
          response.httpStatus 	= 200;
          return response;
    }

	public static String errorStringFormatter(Boolean isAcquiring, List<OB_TrackingUtility.ErrorList> errors){
		String errorString = isAcquiring ? 'Acquiring errors : ' : ' GT errors : ';

		for(OB_TrackingUtility.ErrorList err : errors){
			errorString += '\r code : ' + err.code + ' \r error : ' + err.description;			
		}

		return errorString;
	}

    /**
    * @file Delete logic Failed and add the rollback value
    * @author Simone Misani (simone.misani@accenture.com)
    * @brief 
    * @version 0.1
    * @date 2019-11-11    
    * 
    */
    @TestVisible        //  micol.ferrari 13/11/2019 - Added @TestVisible
    private  static List<NE__OrderItem__c>  rollBackmodify(List<NE__OrderItem__c> listOrderItem ){
        Map<String,Object> mapToReturn = new Map<String,Object>();
        List<NE__OrderItem__c> listReturn = new List<NE__OrderItem__c>();
        List<NE__Order_Item_Attribute__c> listReturnAttribute = new List<NE__Order_Item_Attribute__c>();
        for(NE__OrderItem__c oi : listOrderItem){
            if(oi.OB_FulfilmentStatus__c == 'Failed'){
                listReturn.addAll( cloneOrderItemFailed(oi));
                listReturnAttribute.addAll(updateAttrubute (listReturn));

            }else{
                listReturn.add(oi);
            }

        }
        update listReturnAttribute;
        return listReturn;
    }
    /**
    * @file Delete logic Failed and add the rollback value
    * @author Simone Misani (simone.misani@accenture.com)
    * @brief 
    * @version 0.1
    * @date 2019-11-11    
    * 
    */
    @TestVisible        //  micol.ferrari 13/11/2019 - Added @TestVisible
    private static List<NE__OrderItem__c> cloneOrderItemFailed(NE__OrderItem__c oldOrderItem){
            List<NE__OrderItem__c> listReturn = new List<NE__OrderItem__c>();
           
            Map<String,Object> mapToReturn = new Map<String,Object>();
            NE__OrderItem__c coloneOrderItemFailed = oldOrderItem.clone(false,false,false,false);
            coloneOrderItemFailed.OB_FulfilmentStatus__c = 'Cancelled';
            coloneOrderItemFailed.NE__Action__c = 'None';
            listReturn.add(coloneOrderItemFailed);


            oldOrderItem.OB_FulfilmentStatus__c = 'Completed';
            oldOrderItem.OB_AcquiringErrorTracking__c = '';
            oldOrderItem.OB_GTErrorTracking__c= '';
            oldOrderItem.NE__Action__c = 'None';
            listReturn.add(oldOrderItem);
           

            //mapToReturn.put('orderItem',listReturn);
           

            return listReturn;

    }

     /**
    * @file Delete logic Failed and add the rollback value
    * @author Simone Misani (simone.misani@accenture.com)
    * @brief 
    * @version 0.1
    * @date 2019-11-11    
    * 
    */
    @TestVisible        //  micol.ferrari 13/11/2019 - Added @TestVisible
    private static void rollBackCommisisonModel(List<NE__OrderItem__c> listOi, String errorConfig){

													
        for (NE__OrderItem__c oi : listOi ){
               if( oi.NE__ProdId__r.RecordType.DeveloperName == 'Commissione' || oi.NE__ProdId__r.RecordType.DeveloperName == 'PCI') {
                   if(oi.NE__Action__c == 'Add'){
                       oi.OB_FulfilmentStatus__c = 'Cancelled';
                       oi.OB_AcquiringErrorTracking__c = errorConfig;
                   }else if (oi.NE__Action__c == 'Remove'){
                       oi.NE__Action__c = 'None';
                       oi.OB_FulfilmentStatus__c = 'Completed';
                   }

               }
        }

        update listOi;

    }

    @TestVisible        //  micol.ferrari 13/11/2019 - Added @TestVisible
    private static List<NE__Order_Item_Attribute__c> updateAttrubute(List<NE__OrderItem__c> listOi ){
        
        List<NE__Order_Item_Attribute__c> listReturnAttribute = new List<NE__Order_Item_Attribute__c>();
        for(NE__OrderItem__c oi : listOi ){
            if(oi.OB_Tech_Outcome_Equens__c == 'KO' || oi.OB_Tech_Outcome_Monetica__c == 'KO'){
                for(NE__Order_Item_Attribute__c oiAttr : oi.NE__Order_Item_Attributes__r){
                    if(oiAttr.NE__Value__c !=  oiAttr.NE__Old_Value__c){
                        oiAttr.NE__Value__c =  oiAttr.NE__Old_Value__c;
                        listReturnAttribute.add(oiAttr);
                    }               

                }

            }
        }

        return listReturnAttribute;
    }

    

	  
    /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 07/05/2019
    *@description custom exception
    */
    public class MaintenancePricingException extends Exception {

    }

    //	REQUEST
	// global class TrackMaintenancePricingOrderRequest
	// {
	// 	global String orderId 									    {get;set;}
	// 	global List<Acquiring> Acquiring	 					    {get;set;}
	// 	global List<GT> GT 											{get;set;}
	// 	global TrackMaintenancePricingOrderRequest()
	// 	{
	// 		Acquiring 		= new List<Acquiring>();
	// 		GT 				= new List<GT>();
	// 	}
	// }

    // global class Acquiring
	// {
	// 	global String source         								{get;set;}
	// 	global String companyCode    								{get;set;}
	// 	//global List<ErrorList> errori								{get;set;}		
	// 	global List<PVCodes> PVCodes         						{get;set;}	
	// 	global Acquiring()
	// 	{
	// 		PVCodes 		= new List<PVCodes>();
	// 	//	errori 			= new List<ErrorList>();
	// 	}
	// }

    // global class PVCodes        
	// {	
    //     global String       ctiCode                         {get;set;}	
    //      global String      StabiCode                       {get;set;}	
    //     global String       PVCode                          {get;set;}	
    //     global String       siaMerchantCode                 {get;set;}	
    //     global String       siaPVCode                       {get;set;}	
    //     global String       siaProgressiveCode              {get;set;}	
    //     global String       assistanceNumber                {get;set;}	
    //     global String       startDate                       {get;set;}	
    //     global String       model                       	{get;set;}	
    //     global String       modelDescription              	{get;set;}	
    //     global String       release                   	    {get;set;}	
    //     global String       releaseDescription            	{get;set;}	
    //     global String       connectionType                	{get;set;}	
    //     global String       modality                  	    {get;set;}	
    //     global String       status                        	{get;set;}	
    //     global String       reasonOfRejection             	{get;set;}	
    //     global String       installationDate              	{get;set;}	
    //     global String       uninstallationDate              {get;set;}	
																
    //     global List<terminalInformation> terminalInformation     {get;set;}
															   

    //     //PV CODES just for Acquiring:
    //     global String endDate               {get;set;}
    //     global String  reasonOfClosure      {get;set;}
    //     global List<changes> changes        {get;set;}

    //     global PVCodes()
	// 	{
	// 		changes 		= new List<changes>();
    //         terminalInformation 		= new List<terminalInformation>();
														
	// 	}

	// }

    // global class pricingChange
	// {
    //     global String       status       {get;set;}	
    //     global String       startDate    {get;set;}	
    //   	global List<errors> errors       {get;set;}
    //     global pricingChange()
	// 	{
	// 		errors 		= new List<errors>(); 
	// 	}

    // }
    // global class changes
	// {
    //     global String       externalId       {get;set;}	
    //     global String       result           {get;set;}	
    //   	global List<errors> errors           {get;set;}
    //     global changes()
	// 	{
	// 		errors 		= new List<errors>();
	// 	}
    // }

    // global class agreementCodes
	// {
    //     global String       status                   {get;set;}	
    //     global String       companyCode              {get;set;}	
    //     global String       companyName              {get;set;}	
    //     global String       code                     {get;set;}	
    //     global String       startDate                {get;set;}	
    //     global String       endDate                  {get;set;}	
    // }

    // global class terminalInformation
	// {
    //     global String   terminalId      {get;set;}	
    //     global String   model                {get;set;}	
    //     global String  modelDescription      {get;set;}	
    //     global String  release               {get;set;}	
    //     global String  releaseDescription        {get;set;}	
    //     global String  connectionType        {get;set;}	
    //     global String  modality              {get;set;}	
    //     global String  status                {get;set;}	
    //     global String  reasonOfRejection         {get;set;}	
    //     global String  installationDate      {get;set;}	
    //     global String  uninstallationDate    {get;set;}	
	// 	global List<errors> errors          {get;set;}
    //     global List<agreementCodes> agreementCodes          {get;set;}
    //     global pricingChange         pricingChange     {get;set;}
    //     global terminalInformation()
	// 	{
	// 		errors 		        = new List<errors>();
    //         agreementCodes 		= new List<agreementCodes>();
	// 	}

    // }
    
    // global class errors
	// {
	// 	global String code 								{get;set;}
	// 	global String description 						{get;set;}
    // }

    // global class GT
	// {

    //     global String  source               {get;set;}
    //     global String    gtCompanyCode      {get;set;}
  	//     global List<errors> errors          {get;set;}
    //     global List<PVCodes> PVCodes          {get;set;}
    //     global GT()
	// 	{
	// 		errors 		= new List<errors>();
    //         PVCodes     = new List<PVCodes>();
	// 	}

    // }
    // //obj used for final result
    global class finalResultObj
	{
        global String                       fulfilmentStatus     {get;set;}
        global String                        orderHeaderId      {get;set;}
        global String                        trackingErrors      {get;set;}   
         global Integer                      httpStatus              {get;set;}
         global String                      message              {get;set;}   
        global List<NE__OrderItem__c>       childOrderItems      {get;set;}   
        global finalResultObj()
		{
			childOrderItems 		= new List<NE__OrderItem__c>();

		}
     }

}