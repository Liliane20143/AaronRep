/**************************************************************** *
Name:  OB_TrackingOrder
============================================================
Purpose: Method to call to get the tracking order information
============================================================
History
-------                                                            
VERSION  		AUTHOR         		DATE           	DETAIL          Description
1.0          	micol.ferrari       16/08/2018      Created         Creation of the class
*****************************************************************/
//TEST GIT
@RestResource(urlMapping='/TrackingOrder/*')
global without sharing class OB_TrackingOrder 
{
	public final static String COMPLETED = 'Completed';
	public final static String FAILED = 'Failed';
	public final static String CANCELLED = 'Cancelled';
	public final static String DMODELLO = 'Descrizione Modello';
	public final static String DRELEASE = 'Descrizione Release';
	public final static String DCONNESSIONE = 'Descrizione Connessione';
	public final static String MONETICAOK = 'OK';
	public final static String MONETICAKO = 'KO';
	public final static String MAINTENANCE = 'Maintenance';
	//START gianluigi.virga 11/06/2019
	public final static String RESPONSEHTTPSTATUS = 'Response status: ';
	public final static String RESPONSEMESSAGE = 'Response message: ';
	//END gianluigi.virga
	//START gianluigi.virga 17/05/2019
	public final static String NEXI = 'NEXI';
	public final static String MONETICA = 'MONETICA';
	//END gianluigi.virga 17/05/2019

	//LUBRANO 2019-01-26 -- incapsulamento metodo getTrackingOrder(TrackingOrderRequest request)
	@HttpPost
	global static OB_TrackingOrder.TrackingOrderResponse trackOrder(){
		RestResponse res = RestContext.response;
		OB_TrackingOrder.TrackingOrderResponse response = new OB_TrackingOrder.TrackingOrderResponse();
		String confId; //francesca.ribezzi 26/09/19 - F2WAVE2-189 - adding confId
		try{
			

			if(RestContext.request.requestBody ==null){
				//responseStatus 					= 400;
				//headerStatus					= 400;
				throw new applicationException('There is no body for the request ');
			}

			String req 	= RestContext.request.requestBody.toString();

			TrackingOrderRequest request 	= (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(req,OB_TrackingOrder.TrackingOrderRequest.class);
			confId = request.idOrdineSfdc; //francesca.ribezzi 26/09/19 - F2WAVE2-189 - adding confId
			//START francesca.ribezzi 09/09/19 checking if order is not null here:
			if(confId != null){
				response = getTrackingOrder(request);
			} 
			//END francesca.ribezzi 09/09/19
			//francesca.ribezzi 06/09/19 - calling updateResponse and insertLog only here
			OB_TrackingOrder.updateResponse(confId, response.httpMessage, response.httpStatus);
			res.statusCode  =	response.httpStatus;
			Id plcId = insertLog(RestContext.request,response,response.httpStatus,'','S');  //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
			//francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the order id: 
			OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, confId);

		}catch(Exception e){
			System.debug('OB_TrackingOrder.getTrackingOrder Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
			response.httpStatus 						= 400;
			res.statusCode 								= 400;
			// LUBRANO -- 2019-05-28 -- add web results log
			Id plcId = insertLog(RestContext.request,response,response.httpStatus,'OB_TrackingOrder.getTrackingOrder Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString(),'E'); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
			// francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the order id: 
			OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, confId); 
		}
		// LUBRANO -- 2019-05-28 -- add web results log
		
		return response;
	}

	//@HttpPost
	global static OB_TrackingOrder.TrackingOrderResponse getTrackingOrder(TrackingOrderRequest request)
	{
		RestResponse res 							= RestContext.response;
		Map<String,String> decodeValues 			= new Map<String,String>();
		Map<String,String> conventionCodes			= new Map<String,String>();

		list<NE__Lov__c> lovs = [SELECT Name,NE__Value1__c,NE__Value2__c 
                                        FROM NE__Lov__c WHERE NE__Sub_Type__c= 'TIPOLOGICHE' AND NE__Type__c='TRACKING'];

        /**********************************************
             * BUILD A MAP FROM SFDC VALUES TO MIP VALUES
             * Name contains the logical gruping
             * NE__Value1__c Monetica Company CODE
             * NE__Value2__c contains Product Code
             **********************************************/
            
        for(NE__Lov__c val : lovs ){
            decodeValues.put(val.NE__Value1__c.trim(),val.NE__Value2__c);
            conventionCodes.put(val.NE__Value2__c,val.NE__Value2__c);
        }
        system.debug('decodeValues ' + decodeValues);
        system.debug('conventionCodes ' + conventionCodes);

		OB_TrackingOrder.TrackingOrderResponse response = new OB_TrackingOrder.TrackingOrderResponse();
		//OB_TrackingOrder.TrackingOrderRequest request 	= new OB_TrackingOrder.TrackingOrderRequest();
		List<NE__OrderItem__c> itemToUpdateList	 		= new List<NE__OrderItem__c>();
		Integer responseStatus 							= 500;
		//Integer headerStatus							= 500;
		try
		{
			//if(RestContext.request.requestBody ==null){
			//	responseStatus 					= 400;
			//	//headerStatus					= 400;
			//	throw new applicationException('There is no body for the request ');
			//}

			//String req 	= RestContext.request.requestBody.toString();
			//request 	= (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(req,OB_TrackingOrder.TrackingOrderRequest.class);
			if(request==null){
				responseStatus 					= 400;
			
				throw new applicationException('There is no body for the request ');
			}
			//System.debug('OB_TrackingOrder.TrackingOrderRequest request: '+ req);
			System.debug('OB_TrackingOrder.getTrackingOrder request deserialize --> ' +request);
			System.debug('Configuration id --> '+request.idOrdineSfdc);
			String merchantId 						= '';
			String servicePointId 					= '';
			String MCC 								= '';
			String MCC2 							= '';
			String shopSign 						= '';
			String settlementMethod 				= '';
			String internationalSettlementMethod 	= '';
			String reportTypeFormat 				= '';
			String proposerABI 						= '';
			String businessModel					= '';
			String pricingType						= '';
			String receiptCity						= '';
			String receiptHeader					= '';
			String reportType						= '';
			Boolean isMoto							= false;
			Boolean isAlberghiAutonoleggi			= false;
			Boolean pagobancomatFlag				= false;
			//LUBRANO - 2019-02-12 -- TODO IMPLEMENTAZIONE CHIAMATA WELCOME LETTER
			Boolean hasMonetica 					= false;
			Boolean hasEquens 						= false;
			Boolean posPB 							= false;
			Boolean hasAcq 							= false;
			Boolean isMoneticaCall					= false;
			String welcomePOS						= '';
			String mainProcess 						= '';
			//LUBRANO - 2019-03-25 -- CONVENTION CODE FOR ACQUIRING AND GT REQUESTS
			String conventionCodeExSM = '';
			// LUBRANO -- 2019-04-02 -- new method to check if all terminals have been rejected
			Boolean cancelPB;
			String confId;
			// if((request.GT != null && !request.GT.isEmpty())
			// 		&& (request.GT.get(0).puntiVendita != null && !request.GT.get(0).puntiVendita.isEmpty())
			// 		&& (request.GT.get(0).puntiVendita.get(0).termsIdInformations != null && !request.GT.get(0).puntiVendita.get(0).termsIdInformations.isEmpty())){
			// 	String item = request.GT.get(0).puntiVendita.get(0).termsIdInformations.get(0).termId;
			// 	List<NE__OrderItem__c> confList = [SELECT NE__OrderId__c,NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c//Simone Misani F2WAVE2-107 12/07/2019
			// 									FROM NE__OrderItem__c
			// 									WHERE OB_TermId__c =:item AND NE__Status__c !=: CANCELLED AND OB_FulfilmentStatus__c !=: OB_TrackingOrderMaintenance.DRAFT LIMIT 1];
			// //START Simone Misani F2WAVE2-107 12/07/2019
			// 	if(confList != null && !confList.isEmpty()){
			// 		if(String.isBlank(confList.get(0).NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c)){
			// 			confId = request.idOrdineSfdc;
			// 		}else{
			// 			confId = confList.get(0).NE__OrderId__c;
			// 		}
					
			// 	}
			// 	// END Simone Misani F2WAVE2-107 12/07/2019
			// 	//START----Simone Misani 09/07/2019 F2WAVE2-107
			// 	else{
			// 	confId = request.idOrdineSfdc;
			// 	}
			// 	//END----Simone Misani 09/07/2019 F2WAVE2-107			
			// 	}else{
			confId = request.idOrdineSfdc;
			
						
			List<GT> GTArray 									= new List<GT>();
			List<Acquiring> acquiringArray 						= new List<Acquiring>();
			List<NE__OrderItem__c> pagobancomatList				= new List<NE__OrderItem__c>();
			Map<String,NE__OrderItem__c> mapTermId 				= new Map<String,NE__OrderItem__c>();
			List<NE__OrderItem__c> acquiringNexiList 			= new List<NE__OrderItem__c>();
			Map<String,NE__OrderItem__c> rootVasList 			= new Map<String,NE__OrderItem__c>();
			
			List<NE__Order_Item_Attribute__c> attributes 		= new  List<NE__Order_Item_Attribute__c>();				
			List <ExternalSourceMapping__c> externalMappingList = new List<ExternalSourceMapping__c>();


			List<NE__Order__c> configurations = [SELECT Id,
														NE__AccountId__c,
														OB_MCCL2__c,
														OB_MCC__c,
														OB_Service_Point__c,
														OB_ShopSign__c,
														OB_PBSettlementMethod__c,
														OB_InternationalSettlementMethod__c,
														NE__Order_Header__c,
														NE__Order_Header__r.OB_Business_Model_Acquiring__c,
														NE__Order_Header__r.OB_Main_Process__c,
														OB_ReceiptCity__c,
														OB_ReceiptHeader__c,
														OB_Report_Type__c,
														NE__FulfilmentStatus__c,
														//LUBRANO - 2019-02-12 -- TODO IMPLEMENTAZIONE CHIAMATA WELCOME LETTER
														//START gianluigi.virga 10/06/2019
														OB_ResponseTrackingOrder__c,
														//END gianluigi.virga														
														NE__Order_Header__r.OB_ProposerABI__c														
														FROM NE__Order__c WHERE Id = :confId];

			System.debug('Configurations --> '+configurations);

			if(configurations == null || configurations.isEmpty()){
				throw new applicationException('There is no configuration for id --> ' + request.idOrdineSfdc);
			}
			
			merchantId 						= configurations[0].NE__AccountId__c;
			servicePointId 					= configurations[0].OB_Service_Point__c;
			MCC 							= configurations[0].OB_MCC__c;
			//MCC2 							= configurations[0].OB_MCCL2__c;
			MCC2 							= [SELECT Id,OB_Value4__c, ne__value2__c 
														FROM NE__Lov__c 
														WHERE ne__type__c = 'mcc' 
														AND ne__value3__c = 'L2' 
														AND (OB_Value4__c =: configurations[0].OB_MCCL2__c 
														OR NE__Value2__c = : configurations[0].OB_MCCL2__c) LIMIT 1].OB_Value4__c;
			//shopSign 						= configurations[0].OB_ShopSign__c;
			settlementMethod 				= configurations[0].OB_PBSettlementMethod__c;
			internationalSettlementMethod 	= configurations[0].OB_InternationalSettlementMethod__c;
			businessModel					= configurations[0].NE__Order_Header__r.OB_Business_Model_Acquiring__c;
			receiptCity 					= configurations[0].OB_ReceiptCity__c;
			receiptHeader 					= configurations[0].OB_ReceiptHeader__c;
			reportType 						= configurations[0].OB_Report_Type__c;
			shopSign 						= configurations[0].OB_ShopSign__c;
			mainProcess						= configurations[0].NE__Order_Header__r.OB_Main_Process__c;
			//francesca.ribezzi 13/07/19 adding NE__ProdName__c, NE__Action__c fields - F2WAVE2-86_TrackingEcommerce
			List<NE__OrderItem__c> orderItems = [SELECT Id,
														NE__ProdName__c, 
														NE__Action__c, 
														OB_Processor__c,
														OB_CompanyCode__c,
														OB_ServicePointCode__c,
														NE__StartDate__c,
														NE__EndDate__c,
														OB_MCC__c,
														OB_MCCL2__c,
														OB_FulfilmentStatus__c,
														OB_TermId__c,
														NE__ProdId__c,
														NE__Parent_Order_Item__c,
														NE__ProdId__r.RecordType.DeveloperName,
														NE__ProdId__r.OB_Acquirer__c,
														NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c,
														NE__OrderId__r.NE__Order_Header__r.OB_Report_Type_Format__c, 
														NE__Bundle__c,
														NE__Bundle_Configuration__c,
														NE__ProdId__r.OB_Codice_sfdc__c,
														OB_GT__c,
														OB_CustomerCode__c,
														OB_Tech_Outcome_Monetica__c,
														OB_Tech_Outcome_Equens__c,
														OB_ShopCode__c,
														OB_RAC_SIA__c,
												 		(SELECT id,Name, NE__Value__c FROM NE__Order_Item_Attributes__r)
												 												 		FROM NE__OrderItem__c 
														WHERE NE__OrderId__c = :confId//Simone Misani F2WAVE2-100-82 05/07/2019
														and NE__Status__c !=: CANCELLED ]; 
			System.debug('Order Items --> '+orderItems);
			//LUBRANO - 2019-02-12 -- TODO IMPLEMENTAZIONE CHIAMATA WELCOME LETTER
			List<OB_Bank_Profile__c> bankProfiles = [select id,OB_Welcome_Letter_POS__c from OB_Bank_Profile__c where OB_Bank__c =: configurations[0].NE__Order_Header__r.OB_ProposerABI__c limit 1];
			if(bankProfiles.size() > 0){
				welcomePOS = bankProfiles[0].OB_Welcome_Letter_POS__c;
			}

			if(orderItems == null || orderItems.isEmpty()){
				throw new applicationException('There is no configuration item for id --> ' + request.idOrdineSfdc);
			}
			
			Map<Id,List<NE__OrderItem__c>> mapChildOI 	= new Map<Id,List<NE__OrderItem__c>>();
			proposerABI 								= orderItems[0].NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c;
			reportTypeFormat 							= orderItems[0].NE__OrderId__r.NE__Order_Header__r.OB_Report_Type_Format__c ;

			//francesca.ribezzi 13/07/19 - F2WAVE2-86 
			List<NE__OrderItem__c> virtualPosToCheck = new List<NE__OrderItem__c>();
			for(NE__OrderItem__c orderItem : orderItems) 
			{
				//START francesca.ribezzi 13/07/19 - F2WAVE2-86
				String prodName = orderItem.NE__ProdName__c;
				if((prodName == 'OneClick' || prodName == 'Recurring'|| prodName == 'Moto'|| prodName== 'e-commerce') && orderItem.NE__Action__c == 'Add'){
					virtualPosToCheck.add(orderItem);
				}
				//END francesca.ribezzi 13/07/19 - F2WAVE2-86
				if(orderItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.MOTO)
                    isMoto = true;
				if(orderItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.ALBERGIAUTONOLEGGI)
                    isAlberghiAutonoleggi = true;
				// CREATE A MAP OF ALL TERMS IDs
				if(String.isNotBlank(orderItem.OB_TermId__c))
				{
					mapTermId.put(orderItem.OB_TermId__c,orderItem);
				}
				//LUBRANO 2019-02-09 -- IMPLEMENTAZIONE WELCOME LETTER
				if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.TERMINALE && String.isNotBlank(orderItem.OB_GT__c) && orderItem.OB_GT__c.equalsIgnoreCase('MONETICA')){
					posPB = true;
					if(MONETICAOK.equalsIgnoreCase(orderItem.OB_Tech_Outcome_Monetica__c)){
						hasMonetica = true;
					}
				}

				if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PAGOBANCOMAT)
				{
					if(orderItem.NE__ProdId__r.OB_Acquirer__c == OB_EnrichOrder.NEXI && orderItem.NE__Parent_Order_Item__c == null)
					{
						acquiringNexiList.add(orderItem);
					} else {
						if(orderItem.OB_FulfilmentStatus__c != COMPLETED && orderItem.OB_FulfilmentStatus__c != CANCELLED && orderItem.NE__Parent_Order_Item__c == null){
							pagobancomatList.add(orderItem);
						}
						
					}
					
				}

				if (orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.COMMISSIONE){
            		pricingType = orderItem.NE__ProdId__r.OB_Codice_sfdc__c;
        		}

				// CREATE A MAP OF ALL NEXI ACQUIRING and VAS not requiring convention CODE
				if((orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI) 
					|| (orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && !conventionCodes.containskey(orderItem.NE__ProdId__r.OB_Codice_sfdc__c))
					|| (orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && orderItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI)
					|| (orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PCI )
					|| (orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.COMMISSIONE)){
					hasAcq = true;
					acquiringNexiList.add(orderItem);
					//TODO IMPLEMENTAZIONE CHIAMATA WELCOME LETTER
					if(MONETICAOK.equalsIgnoreCase(orderItem.OB_Tech_Outcome_Equens__c)){
						hasEquens = true;
					}
				}

				if(
					((orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && conventionCodes.containskey(orderItem.NE__ProdId__r.OB_Codice_sfdc__c) && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI) || 
					(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI )
					)&& orderItem.NE__Parent_Order_Item__c ==null)
					 
				{
					rootVasList.put(orderItem.NE__ProdId__r.OB_Codice_sfdc__c,orderItem);
				}
				
				//CREATE A MAP FOR ALL CHILDS
				List<NE__OrderItem__c> tmpOI = new List<NE__OrderItem__c>(); 
				if(mapChildOI.containsKey(orderItem.NE__Parent_Order_Item__c)){
					tmpOI = mapChildOI.get(orderItem.NE__Parent_Order_Item__c);
				}
				tmpOI.add(orderItem);
				mapChildOI.put(orderItem.NE__Parent_Order_Item__c,tmpOI);
			}
			System.debug('mapChildOI : ' + mapChildOI);
			System.debug('Map<String,NE__OrderItem__c>  --> '+mapTermId);

			List<ExternalSourceMapping__c> extSourceMappingList = [SELECT Id,
																		  OB_Service_Point_ID__c,
																		  OB_ServicePointCodeShopCode__c,
																		  OB_Source__c,
																		  OB_Merchant_ID__c,
																		  OB_CustomerCodeClientCode__c,
																		  OB_Conventioncode__c 
																   		FROM ExternalSourceMapping__c
																		WHERE OB_Merchant_ID__c = : merchantId 
																		OR OB_Service_Point_ID__c =: servicePointId ]; 
            
			System.debug('External Source Mapping --> '+extSourceMappingList);
			/*
			if(extSourceMappingList == null|| extSourceMappingList.isEmpty()){
				throw new applicationException('There is no external source mapping ' );
			}*/

			acquiringArray 		= request.Acquiring;
			GTArray 			= request.GT;
			Boolean isAcquiring = request.Acquiring != null  && !request.Acquiring.isEmpty();
			Boolean isGT 		= request.GT != null && !request.GT.isEmpty();

			//@@@@
			Map<String,Object> acquiringArguments = new Map<String,Object>();
			Map<String,Object> gtArguments = new Map<String,Object>();
			acquiringArguments.put('configuration', configurations[0]);
			acquiringArguments.put('acquiringNexiList', acquiringNexiList);
			acquiringArguments.put('mapChildOI', mapChildOI);
			acquiringArguments.put('itemToUpdateList',itemToUpdateList);
			gtArguments.put('mapTermId', mapTermId);
			gtArguments.put('pagobancomatList',pagobancomatList);
			gtArguments.put('rootVasList',rootVasList);
			// START gianluigi.virga 20/11/2019 - fix to restore configuration.OB_Tracking_Errors__c update
			checkErrors(acquiringArray,GTArray,acquiringArguments,gtArguments); // removed responseStatus and itemToUpdateList arguments
			// if(responseStatus == 200){
			// 	throw new applicationException('Errors found in requests');
			// }
			// END gianluigi.virga 20/11/2019 - fix to restore configuration.OB_Tracking_Errors__c update
			//TO DO Check Acquiring For Error
			if(isAcquiring){
				Map<String,ExternalSourceMapping__c> acquiringCodes = new Map<String,ExternalSourceMapping__c>();
				for(Acquiring acq : acquiringArray){
					//START francesca.ribezzi 06/09/19 - WN-249 - return if there are errors
					if(acq.errori != null && acq.errori.size() > 0){  //antonio.vatrano Wn-386 10/09/2019
						for(ErrorList e : acq.errori){
							response.httpMessage += e.codice +' ' + e.descrizione+ ' ';
						}
						//francesca.ribezzi 06/11/19 - PROD-36 - calling this method to update  OB_FulfilmentStatus__c to failed
						acquaringItemsToUpdateManagement(configurations[0],acquiringNexiList,FAILED,'','','','',mapChildOI,itemToUpdateList);
						response.httpStatus = 200;
						return response;
					}
					//END francesca.ribezzi 06/09/19 - WN-249 
					if(String.isBlank(acq.codiceSocieta) || acq.puntiVendita.size()==0){
						/*
						acquaringItemsToUpdateManagement(configurations[0],acquiringNexiList,'Failed','','','','',mapChildOI,itemToUpdateList);
						Map<String,CodiciConvenzioni> codiciConvenzione = new Map<String,CodiciConvenzioni>();
						String itemStatus = 'Failed';
						for(NE__OrderItem__c orderItem : mapTermId.values()){
							gtItemsToUpdateManagement(configurations[0],orderItem,itemStatus,mapChildOI,pagobancomatList, codiciConvenzione,rootVasList,itemToUpdateList);
						}
						update itemToUpdateList;*/
						throw new applicationException('One or more empty fields - Acquiring');
					}

					for(puntoVendita pv : acq.puntiVendita){
						if(String.isBlank(pv.codicePuntoVendita) || String.isBlank(pv.dataInizio)){
							/*
							acquaringItemsToUpdateManagement(configurations[0],acquiringNexiList,'Failed','','','','',mapChildOI,itemToUpdateList);
							Map<String,CodiciConvenzioni> codiciConvenzione = new Map<String,CodiciConvenzioni>();
							String itemStatus = 'Failed';
							for(NE__OrderItem__c orderItem : mapTermId.values()){
								gtItemsToUpdateManagement(configurations[0],orderItem,itemStatus,mapChildOI,pagobancomatList, codiciConvenzione,rootVasList,itemToUpdateList);
							}
							update itemToUpdateList;*/
							throw new applicationException('One or more empty fields - Acquiring puntoVendita');
						}
						//START francesca.ribezzi 13/07/19 - F2WAVE2-86 - setting OB_ServicePointCode__c on order item:
						String picklistVal;
						Boolean checkVirtual = false; //  Noemi.Infantino 24/09/2019 WN-467
						//Simone Misani vs Ribezzi Francesca  04/10/2019 START
						 List<NE__OrderItem__c> updateorderItem = new List<NE__OrderItem__c>();
						if((pv.tipo == 'OneClick' || pv.tipo == 'Recurring'|| pv.tipo == 'Moto'|| pv.tipo == 'Ecommerce') && virtualPosToCheck.size()> 0){
							for(NE__OrderItem__c o : virtualPosToCheck){
								System.debug('prodttonome : '+o.NE__ProdName__c);
								System.debug('prodTipo : '+pv.tipo);
								checkVirtual = true;  //Noemi.Infantino 24/09/2019 WN-467 
								String isEcom =(pv.tipo ==  'Ecommerce') ? 'e-commerce' : '';
								String isMotoNew =(pv.tipo ==  'Moto') ? 'Mail order e telephone order' : '';
								
								if(o.NE__ProdName__c == isEcom || o.NE__ProdName__c == isMotoNew){
									o.OB_ServicePointCode__c = pv.codicePuntoVendita;
									updateorderItem.add(o);
								}else if(pv.tipo == o.NE__ProdName__c){
										o.OB_ServicePointCode__c = pv.codicePuntoVendita;
										updateorderItem.add(o);
								}         
						
							}
						}
						//22/07/19 francesca.ribezzi updating list
						update updateorderItem;
						//END francesca.ribezzi 13/07/19 - F2WAVE2-86
						//Simone Misani vs Ribezzi Francesca  04/10/2019 START

						//Service Point
						ExternalSourceMapping__c ext1 				= new ExternalSourceMapping__c();
						//francesca.ribezzi 13/07/19 - adding OB_EcommerceType__c F2WAVE2-86
						//Start Noemi.Infantino 24/09/2019 WN-467
						if(checkVirtual){
							ext1.OB_EcommerceType__c = pv.tipo;
						}

                         //Stop Noemi.Infantino 24/09/2019 WN-467
						
						String externalmapKey = '';
						//LUBRANO - 2019-02-14 -- aggiunta codice società
						ext1.OB_CustomerCodeClientCode__c 			= acquiringArray[0].codiceSocieta;
						ext1.OB_ServicePointCodeShopCode__c 		= pv.codicePuntoVendita;
						ext1.OB_Business_Model__c 					= businessModel;
						if(String.isNotBlank(pv.tipo)){
							ext1.OB_Service_Point_Type__c 				= (checkVirtual) ? 'Virtuale' :pv.tipo;// Noemi.Infantino 24/09/2019 WN-467
						}else{
							ext1.OB_Service_Point_Type__c 				= 'Fisico';

						}
						ext1.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
						ext1.OB_MCCL2__c 							= MCC2;
					ext1.OB_MCC__c 								= MCC;
						if(acquiringArray[0].sistemaSorgente.equalsIgnoreCase(OB_EnrichOrder.EQUENS) || acquiringArray[0].sistemaSorgente.equalsIgnoreCase(OB_EnrichOrder.SIA)){
							ext1.OB_PBSettlementMethod__c 				= settlementMethod;
						}
						ext1.OB_Pricing__c 							= pricingType;
						ext1.OB_ReceiptCity__c 						= receiptCity;
						ext1.OB_ReceiptHeader__c 					= receiptHeader;
						ext1.OB_ReportTypeFormat__c 				= reportTypeFormat;
						//ext1.OB_ReportType__c 						= reportType ;
						ext1.OB_Source__c 							= acquiringArray[0].sistemaSorgente;
						//ext1.OB_Merchant_ID__c						= merchantId;
						ext1.OB_Service_Point_ID__c					= servicePointId;
						ext1.OB_ShopSign__c							= shopSign;
						//externalmapKey = ext1.OB_Source__c+ext1.OB_CustomerCodeClientCode__c+ext1.OB_ServicePointCodeShopCode__c;
						//acquiringCodes.put(pv.codicePuntoVendita,ext1);
						//acquiringCodes.put(externalmapKey,ext1);
						//LUBRANO - 18-03-2019 -- new update externalmappings
						updateServicePointExternalMapping(ext1);
						//LUBRANO - 2019-03-25 -- CONVENTION CODE FOR ACQUIRING AND GT REQUESTS
						conventionCodeExSM = ext1.OB_ServicePointCodeShopCode__c;

						//Merchant
						ExternalSourceMapping__c ext2 				= new ExternalSourceMapping__c();
						ext2.OB_CustomerCodeClientCode__c 			= acquiringArray[0].codiceSocieta;
						ext2.OB_Business_Model__c 					= businessModel;
						ext2.OB_Source__c 							= acquiringArray[0].sistemaSorgente;
						//ext2.OB_Service_Point_Type__c 				= pv.tipo;
						//ext2.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
						//ext2.OB_PBSettlementMethod__c 				= settlementMethod;
						//ext2.OB_Pricing__c 							= pricingType;
						//ext2.OB_ReceiptCity__c 						= receiptCity;
						//ext2.OB_ReceiptHeader__c 					= receiptHeader;
						ext2.OB_ReportTypeFormat__c 				= reportTypeFormat;
						if(acquiringArray[0].sistemaSorgente.equalsIgnoreCase(OB_EnrichOrder.EQUENS) || acquiringArray[0].sistemaSorgente.equalsIgnoreCase(OB_EnrichOrder.SIA)){
							ext2.OB_ReportType__c 						= reportType ;
						}
						//ext2.OB_Source__c 							= acquiringArray[0].sistemaSorgente;
						ext2.OB_Merchant_ID__c						= merchantId;
						//LUBRANO - 18-03-2019 -- new update externalmappings
						updateMerchantExternalMapping(ext2);
						//LUBRANO 2019-02-18 -- MODIFICA LOGICHE EXTERNAL SOURCE MAPPING
						//externalmapKey = ext2.OB_Source__c+ext2.OB_CustomerCodeClientCode__c+ext2.OB_Merchant_ID__c;
						//acquiringCodes.put(acquiringArray[0].codiceSocieta,ext2);
						//acquiringCodes.put(externalmapKey,ext2);
						acquaringItemsToUpdateManagement(configurations[0],acquiringNexiList,COMPLETED,acq.codiceSocieta,pv.codicePuntoVendita,pv.dataInizio,pv.dataCessazione,mapChildOI,itemToUpdateList);
						hasEquens = true;

						//LUBRANO 2019-02-20 -- AGGIORNAMENTO CONVENTIONCODE PER EXSM MONETICA
						if(hasMonetica){
							ExternalSourceMapping__c servicePointMonetica = conventionCodeManagement(isAcquiring,isGT,hasMonetica,hasAcq,ext1,acquiringNexiList,servicePointId,mapTermId,conventionCodeExSM);
							if(servicePointMonetica != null){
								update servicePointMonetica;
							}
							
						}
					}
				}
				//LUBRANO 2019-02-18 -- MODIFICA LOGICHE EXTERNAL SOURCE MAPPING
				//updateExternalMapping (acquiringCodes,merchantId ,servicePointId, MCC, shopSign,  isMoto, pricingType);
				
				
			}
			String codiceCTI;//francesca.ribezzi 08/11/19 codiceCTI  
			if(isGT){
				Map<String,ExternalSourceMapping__c> gtCodes = new Map<String,ExternalSourceMapping__c>();
				for(GT gt : GTArray){
					//START francesca.ribezzi 06/09/19 - WN-249 - return if there are errors
					if(gt.errori !=null && gt.errori.size() > 0){ //antonio.vatrano Wn-386 10/09/2019
						for(ErrorList e : gt.errori){
							response.httpMessage += e.codice +' ' + e.descrizione+ ' ';
						}
						response.httpStatus = 200;
						return response;
					}
					//END francesca.ribezzi 06/09/19 - WN-249
					//LUBRANO - 2019-02-20 -- RILASSAMENTO OBBLIGO CODICECLIENTE,CODICESTAB,CODICECTI,CODICESTABSIA,CODICEPROGSIA,CODICESIA
					if((String.isBlank(gt.codiceCliente) && mainProcess != MAINTENANCE)|| String.isBlank(gt.statoProvisioning) || gt.puntiVendita.size()==0){
						/*
						acquaringItemsToUpdateManagement(configurations[0],acquiringNexiList,'Failed','','','','',mapChildOI,itemToUpdateList);
						Map<String,CodiciConvenzioni> codiciConvenzione = new Map<String,CodiciConvenzioni>();
						String itemStatus = 'Failed';
						for(NE__OrderItem__c orderItem : mapTermId.values()){
								gtItemsToUpdateManagement(configurations[0],orderItem,itemStatus,mapChildOI,pagobancomatList, codiciConvenzione,rootVasList,itemToUpdateList);
						}
						update itemToUpdateList;*/
						throw new applicationException('One or more empty fields - GT');
					}
					for(puntoVendita pv : gt.puntiVendita){
						Boolean isNotValid 		= (String.isBlank(pv.codiceStabilimento) && mainProcess != MAINTENANCE)
												|| (String.isBlank(pv.codiceCTI) && mainProcess != MAINTENANCE)
												//|| String.isBlank(pv.numeroAssistenzaPOS)
												|| (String.isBlank(pv.codiceStabilimentoSIA)&& mainProcess != MAINTENANCE)
												|| (String.isBlank(pv.codiceProgressivoSIA)&& mainProcess != MAINTENANCE)
												|| (String.isBlank(pv.codiceSIA)&& mainProcess != MAINTENANCE)
												|| String.isBlank(pv.dataInizio);
						if(isNotValid){
							/*
							acquaringItemsToUpdateManagement(configurations[0],acquiringNexiList,'Failed','','','','',mapChildOI,itemToUpdateList);
							Map<String,CodiciConvenzioni> codiciConvenzione = new Map<String,CodiciConvenzioni>();
							String itemStatus = 'Failed';
							for(NE__OrderItem__c orderItem : mapTermId.values()){
								gtItemsToUpdateManagement(configurations[0],orderItem,itemStatus,mapChildOI,pagobancomatList,codiciConvenzione,rootVasList,itemToUpdateList);
							}
							update itemToUpdateList;*/
							throw new applicationException('One or more empty fields - GT puntiVendita');
						}
						//START francesca.ribezzi 13/07/19 - F2WAVE2-86 - setting OB_ShopCode on order item: 

						String picklistVal;
						Boolean checkVirtual = false; //  Noemi.Infantino 24/09/2019 WN-467
						if((pv.tipo == 'OneClick' || pv.tipo == 'Recurring'|| pv.tipo == 'Moto'|| pv.tipo == 'Ecommerce') && virtualPosToCheck.size()> 0){
							for(NE__OrderItem__c o : virtualPosToCheck){

								checkVirtual = true;  //Noemi.Infantino 24/09/2019 WN-467 
								o.OB_ShopCode__c  = pv.codicePuntoVendita;
								
						
							}
						}
						//22/07/19 francesca.ribezzi updating list
						update virtualPosToCheck;						//END francesca.ribezzi 13/07/19 - F2WAVE2-86
						//Service Point	//Service Point
						ExternalSourceMapping__c ext1 				= new ExternalSourceMapping__c();
						//francesca.ribezzi 13/07/19 - adding OB_EcommerceType__c F2WAVE2-86
						//Start Noemi.Infantino 24/09/2019 WN-467
						if(checkVirtual){
							ext1.OB_EcommerceType__c = pv.tipo;
						}

                         //Stop Noemi.Infantino 24/09/2019 WN-467

						String externalmapKey = '';
						//LUBRANO - 2019-02-14 -- aggiunta codice cliente
						ext1.OB_CustomerCodeClientCode__c			= GTArray[0].codiceCliente;
						ext1.OB_ServicePointCodeShopCode__c 		= pv.codiceStabilimento;
						if(String.isNotBlank(pv.tipo)){
							ext1.OB_Service_Point_Type__c 				= (checkVirtual) ? 'Virtuale' :pv.tipo;// Noemi.Infantino 24/09/2019 WN-467
						}else{
							ext1.OB_Service_Point_Type__c 				= 'Fisico';

						}
						//ext1.OB_ConventionCode__c 					= terminfo.codiciConvenzioni.codiceConvenzione;
						//ext1.OB_ConventionCodeSource__c 			= terminfo.codiciConvenzioni.companyCode.equalsIgnoreCase('03')? 'EQUENS':'SIA';
						ext1.OB_Business_Model__c 					= businessModel;
						ext1.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
						ext1.OB_MCCL2__c 							= MCC2;
						ext1.OB_MCC__c 								= MCC;
						//ext1.OB_PBSettlementMethod__c 				= settlementMethod;
						ext1.OB_Pricing__c 							= pricingType;
						ext1.OB_ReceiptCity__c 						= receiptCity;
						ext1.OB_ReceiptHeader__c 					= receiptHeader;
						ext1.OB_ReportTypeFormat__c 				= reportTypeFormat;
						//ext1.OB_ReportType__c 						= reportType ;
						//ext1.OB_Service_Point_Type__c 				= pv.tipo;
						ext1.OB_CTICode__c 							= pv.codiceCTI;
						ext1.OB_Source__c 							= (GTArray[0].sistemaSorgente.equalsIgnoreCase('NEXI')?'MONETICA':GTArray[0].sistemaSorgente);
						//ext1.OB_Merchant_ID__c						= merchantId;
						ext1.OB_Service_Point_ID__c					= servicePointId;
						ext1.OB_ShopSign__c							= shopSign;
						externalmapKey = ext1.OB_Source__c+ext1.OB_CustomerCodeClientCode__c+ext1.OB_ServicePointCodeShopCode__c;
						//gtCodes.put(pv.codicePuntoVendita,ext1);
						//AGGIORNAMENTO CONVENTIONCODE PER EXSM MONETICA
						ext1 = conventionCodeManagement(isAcquiring,isGT,hasMonetica,hasAcq,ext1,acquiringNexiList,servicePointId,mapTermId,conventionCodeExSM);
						system.debug('external mapping servicepoint monetica : ' + ext1);
						//gtCodes.put(externalmapKey,ext1);

						//Merchant
						ExternalSourceMapping__c ext2 				= new ExternalSourceMapping__c();
						ext2.OB_CustomerCodeClientCode__c 			= GTArray[0].codiceCliente;
						ext2.OB_Source__c 							= (GTArray[0].sistemaSorgente.equalsIgnoreCase('NEXI')?'MONETICA':GTArray[0].sistemaSorgente);
						//ext2.OB_ConventionCode__c 					= terminfo.codiciConvenzioni.codiceConvenzione;
						ext2.OB_Business_Model__c 					= businessModel;
						//ext2.OB_ConventionCodeSource__c 			= terminfo.codiciConvenzioni.companyCode.equalsIgnoreCase('03')? 'EQUENS':'SIA';
						//ext2.OB_CTICode__c 							= pv.codiceCTI;
						//ext2.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
						//ext2.OB_PBSettlementMethod__c 				= settlementMethod;
						//ext2.OB_Pricing__c 							= pricingType;
						//ext2.OB_ReceiptCity__c 						= receiptCity;
						//ext2.OB_ReceiptHeader__c 					= receiptHeader;
						ext2.OB_ReportTypeFormat__c 				= reportTypeFormat;
						//ext2.OB_ReportType__c 						= reportType ;
						ext2.OB_Merchant_ID__c						= merchantId;
						//LUBRANO 2019-02-18 -- MODIFICA LOGICHE EXTERNAL SOURCE MAPPING
						//externalmapKey = ext2.OB_Source__c+ext2.OB_CustomerCodeClientCode__c+ext2.OB_Merchant_ID__c;
						//gtCodes.put(GTArray[0].codiceCliente,ext2);
						//gtCodes.put(externalmapKey,ext2);
						//updateExternalMapping (gtCodes,merchantId ,servicePointId, MCC, shopSign,  isMoto, pricingType);
						//LUBRANO - 18-03-2019 -- new update externalmappings
						updateServicePointExternalMapping(ext1);
						updateMerchantExternalMapping(ext2);
						
						if(pv.termsIdInformations== null ||pv.termsIdInformations.size() <1){
							System.debug('@@@ No Exception -- Term info empy');
							//START gianluigi.virga 17/05/2019
							//updateServicePointInfo(orderItems, gt.puntiVendita,configurations[0]);
							updateGTItemsOkMonetica(mapTermId, mapChildOI, pagobancomatList, pv, (GTArray[0].sistemaSorgente.equalsIgnoreCase(NEXI)?MONETICA:GTArray[0].sistemaSorgente), gt, configurations[0]);
							//END gianluigi.virga
							//LUBRANO - 2019-02-12 -- TODO IMPLEMENTAZIONE CHIAMATA WELCOME LETTER
							isMoneticaCall = true;
							hasMonetica = true;
							responseStatus = 200;
							//throw new applicationException('No Exception -- Term info empy');
							break;
						} 
					
						cancelPB = checkAllRejected(mapTermId, pv.termsIdInformations);
						for(TermsIdInformation terminfo : pv.termsIdInformations){
							//LUBRANO 18/01/2019 - - TRASLOCO LOGICHE FUORI DAL CICLO
							/*
							ExternalSourceMapping__c ext1 				= new ExternalSourceMapping__c();
							ext1.OB_ServicePointCodeShopCode__c 		= pv.codicePuntoVendita;
							ext1.OB_Service_Point_Type__c 				= pv.tipo;
							//ext1.OB_ConventionCode__c 					= terminfo.codiciConvenzioni.codiceConvenzione;
							//ext1.OB_ConventionCodeSource__c 			= terminfo.codiciConvenzioni.companyCode.equalsIgnoreCase('03')? 'EQUENS':'SIA';
							ext1.OB_Business_Model__c 					= businessModel;
							ext1.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
							ext1.OB_MCCL2__c 							= MCC2;
							ext1.OB_MCC__c 								= MCC;
							ext1.OB_PBSettlementMethod__c 				= settlementMethod;
							ext1.OB_Pricing__c 							= pricingType;
							ext1.OB_ReceiptCity__c 						= receiptCity;
							ext1.OB_ReceiptHeader__c 					= receiptHeader;
							ext1.OB_ReportTypeFormat__c 				= reportTypeFormat;
							ext1.OB_ReportType__c 						= reportType ;
							ext1.OB_Service_Point_Type__c 				= pv.tipo;
							ext1.OB_CTICode__c 							= pv.codiceCTI;
							ext1.OB_Source__c 							= (GTArray[0].sistemaSorgente.equalsIgnoreCase('NEXI')?'MONETICA':GTArray[0].sistemaSorgente);
							ext1.OB_Merchant_ID__c						= merchantId;
							ext1.OB_Service_Point_ID__c					= servicePointId;
							
							gtCodes.put(pv.codicePuntoVendita,ext1);

							ExternalSourceMapping__c ext2 				= new ExternalSourceMapping__c();
							ext2.OB_CustomerCodeClientCode__c 			= GTArray[0].codiceCliente;
							ext2.OB_Source__c 							= (GTArray[0].sistemaSorgente.equalsIgnoreCase('NEXI')?'MONETICA':GTArray[0].sistemaSorgente);
							//ext2.OB_ConventionCode__c 					= terminfo.codiciConvenzioni.codiceConvenzione;
							ext2.OB_Business_Model__c 					= businessModel;
							//ext2.OB_ConventionCodeSource__c 			= terminfo.codiciConvenzioni.companyCode.equalsIgnoreCase('03')? 'EQUENS':'SIA';
							//ext2.OB_CTICode__c 							= pv.codiceCTI;
							//ext2.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
							//ext2.OB_PBSettlementMethod__c 				= settlementMethod;
							//ext2.OB_Pricing__c 							= pricingType;
							//ext2.OB_ReceiptCity__c 						= receiptCity;
							//ext2.OB_ReceiptHeader__c 					= receiptHeader;
							ext2.OB_ReportTypeFormat__c 				= reportTypeFormat;
							ext2.OB_ReportType__c 						= reportType ;
							ext2.OB_Merchant_ID__c						= merchantId;
							
							gtCodes.put(GTArray[0].codiceCliente,ext2);
							*/
							if(!mapTermId.containskey(terminfo.termId)){
								/*
								acquaringItemsToUpdateManagement(configurations[0],acquiringNexiList,'Failed','','','','',mapChildOI,itemToUpdateList);
								Map<String,CodiciConvenzioni> codiciConvenzione = new Map<String,CodiciConvenzioni>();
								String itemStatus = 'Failed';
								for(NE__OrderItem__c orderItem : mapTermId.values()){
									gtItemsToUpdateManagement(configurations[0],orderItem,itemStatus,mapChildOI,pagobancomatList,codiciConvenzione,rootVasList,itemToUpdateList);
								}
								
								update itemToUpdateList;*/
								throw new applicationException('TermId not valid - GT');
							}
							codiceCTI  = pv.codiceCTI;//francesca.ribezzi 08/11/19 codiceCTI updated here -removing update from loop
						    NE__OrderItem__c orderItem 		= mapTermId.get(terminfo.termId);
							orderItem.OB_ShopCode__c 		= pv.codiceStabilimento;
							orderItem.OB_GT__c 				= (GTArray[0].sistemaSorgente.equalsIgnoreCase('NEXI')?'MONETICA':GTArray[0].sistemaSorgente);
			                orderItem.OB_CustomerCode__c 	= GTArray[0].codiceCliente;
							orderItem.OB_Numero_Assitenza_POS__c = pv.numeroAssistenzaPOS;
							//LUBRANO 15/03/2019 -- aggiunta ok monetica per maintenance
							if(MAINTENANCE.equalsIgnoreCase(configurations[0].NE__Order_Header__r.OB_Main_Process__c) ){
								orderItem.OB_Tech_Outcome_Monetica__c = MONETICAOK;
							}
							
			                for(NE__Order_Item_Attribute__c attr : orderItem.NE__Order_Item_Attributes__r ){	
								// terminal id da aggiungere agli attribute
								if(attr.Name.equalsIgnoreCase('TermId'))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='TermId';
									attr.NE__Value__c = terminfo.termId;
									//attr.NE__Order_Item__c = orderItem.Id;
									//orderItem.OB_Model__c = pv.termsIdInformation.modello;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase('modello'))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='Modello';
									attr.NE__Value__c = terminfo.modello;
									//a.NE__Order_Item__c = orderItem.Id;
									orderItem.OB_Model__c = terminfo.modello;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase('release'))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='Release';
									attr.NE__Value__c = terminfo.release;
									//a.NE__Order_Item__c = orderItem.Id;
									orderItem.OB_Release__c = terminfo.release;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase('modalità Collegamento'))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='modalitaCollegamento';
									attr.NE__Value__c = terminfo.modalitaCollegamento;
									//a.NE__Order_Item__c = orderItem.Id;
									orderItem.OB_LinkType__c = terminfo.modalitaCollegamento;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase(DMODELLO))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='descrizioneModello';
									attr.NE__Value__c = terminfo.descrizioneModello;
									//a.NE__Order_Item__c = orderItem.Id;
									orderItem.OB_ModelDescription__c = terminfo.descrizioneModello;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase(DRELEASE))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='descrizioneRelease';
									attr.NE__Value__c = terminfo.descrizioneRelease;
									//a.NE__Order_Item__c = orderItem.Id;
									orderItem.OB_ReleaseDescription__c = terminfo.descrizioneRelease; 
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase(DCONNESSIONE))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='descrizioneConnessione';
									attr.NE__Value__c = terminfo.descrizioneConnessione;
									//a.NE__Order_Item__c = orderItem.Id;
									orderItem.OB_LinkDescription__c = terminfo.descrizioneConnessione;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase('Progressivo SIA'))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='descrizioneConnessione';
									attr.NE__Value__c = pv.codiceProgressivoSIA;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase('Codice Stabilimento SIA'))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='descrizioneConnessione';
									attr.NE__Value__c = pv.codiceStabilimentoSIA;
									attributes.add(attr);
								}
								if(attr.Name.equalsIgnoreCase('Codice SIA'))
								{
									//NE__Order_Item_Attribute__c a = new NE__Order_Item_Attribute__c();
									//a.Name='descrizioneConnessione';
									attr.NE__Value__c =pv.codiceSIA;
									attributes.add(attr);
								}
							}
							
							String itemStatus = '';
							if(terminfo.statoInstallazione.equalsIgnoreCase('Installato')){
								orderItem.NE__StartDate__c = formatDate(terminfo.dataInstallazione);
								itemStatus =COMPLETED;
							}
							if(terminfo.statoInstallazione.equalsIgnoreCase('Rifiutato')){
								itemStatus = CANCELLED;
							}
							if(terminfo.statoInstallazione.equalsIgnoreCase('disinstallato')){
								orderItem.NE__EndDate__c = formatDate(terminfo.dataDisinstallazione);
								itemStatus =COMPLETED;
								//itemStatus ='Disconnected';
							}

							Map<String,CodiciConvenzioni> codiciConvenzione =  new Map<String,CodiciConvenzioni>();
							//LUBRANO 05-02-2019 --- FIX in caso di codiciConvenzione null
							if(terminfo.codiciconvenzioni != null){
								for(CodiciConvenzioni convenzione : terminfo.codiciconvenzioni){
									if(decodeValues.containsKey(convenzione.companyCode)){
										codiciConvenzione.put(decodeValues.get(convenzione.companyCode),convenzione);
									}
								}
							} 
							
							system.debug('codiciConvenzione ' + codiciConvenzione);
							system.debug('itemStatus ' + itemStatus);
							if(itemStatus != ''){
								//codice obsoleto, sostituito da gtItemsToUpdateManagement
								/*
								orderItem.OB_FulfilmentStatus__c=itemStatus;
								itemToUpdateList.add(orderItem);
								system.debug('orderItem.Id ' + orderItem.Id);
								system.debug('orderItem.Id ' + mapChildOI.containsKey(orderItem.Id));

								if(itemstatus == 'Completed'){
									for(NE__OrderItem__c pagobancomatItem : pagobancomatList){
										pagobancomatItem.OB_FulfilmentStatus__c = itemStatus;
										itemToUpdateList.add(pagobancomatItem);
										if(mapChildOI.containsKey(pagobancomatItem.Id)){
											for(NE__OrderItem__c childOrderItem: mapChildOI.get(pagobancomatItem.Id)){
												childOrderItem.OB_FulfilmentStatus__c=itemStatus;
												itemToUpdateList.add(childOrderItem);
											}
										}
									}

								}

								if(mapChildOI.containsKey(orderItem.Id)){
									for(NE__OrderItem__c childOrderItem: mapChildOI.get(orderItem.Id)){
										if((itemStatus =='Completed' && childOrderItem.NE__ProdId__r.RecordType.DeveloperName==OB_EnrichOrder.PRICING)
											|| itemStatus !='Completed'){
												childOrderItem.OB_FulfilmentStatus__c=itemStatus;
										}



										system.debug('childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c ' + childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
										
										if(itemStatus =='Completed' && codiciConvenzione.containsKey(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c)){
												CodiciConvenzioni convenzione = codiciConvenzione.get(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
												childOrderItem.OB_FulfilmentStatus__c	= itemStatus;
												childOrderItem.OB_CompanyCode__c 		= convenzione.companyCode;
												childOrderItem.OB_Conventioncode__c		= convenzione.codiceConvenzione;
												childOrderItem.NE__StartDate__c			= formatDate(convenzione.dataInizio);
												if(rootVasList.containskey(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c)){
													NE__OrderItem__c root 			= rootVasList.get(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
													root.OB_FulfilmentStatus__c		= itemStatus;
													root.NE__StartDate__c			= formatDate(convenzione.dataInizio);
													itemToUpdateList.add(root);
												}
												
										}
										itemToUpdateList.add(childOrderItem);
									}
								}*/
								
								gtItemsToUpdateManagement(configurations[0],orderItem,itemStatus,mapChildOI,pagobancomatList,codiciConvenzione,rootVasList,itemToUpdateList,pagobancomatFlag,acquiringNexiList,cancelPB,request);
								pagobancomatFlag = true;
							}
						}
					}
				}
			}
			
			//update orderItems;
			if(itemToUpdateList.size()>0){
				//Simone Misani WN-467 28/09/2019 START
				Set<NE__OrderItem__c> itemToUpdateSet = new Set<NE__OrderItem__c>();
				itemToUpdateSet.addAll(itemToUpdateList);
				itemToUpdateList.clear();
                itemToUpdateList.addAll(itemToUpdateSet);
				//Simone Misani WN-467 28/09/2019 START 
				System.debug('Order Items --> '+orderItems);
				update itemToUpdateList;
			}
			if(attributes.size()>0){
				System.debug('Order Item Attributes --> '+ attributes);
				update attributes;
			}
			
			/*
			NE__Order__c ord = new NE__Order__c(id=request.idOrdineSfdc,NE__OrderStatus__c = 'Completed',NE__ConfigurationStatus__c = 'Valid');
			update ord;
			String newOrderID= NE.JS_RemoteMethods.order2asset(request.idOrdineSfdc);
			*/ 
			//Asset can be creted?
			//

			List<NE__OrderItem__c> missingItems = [SELECT 	OB_FulfilmentStatus__c,
														NE__ProdId__r.Name,
														NE__ProdId__r.RecordType.DeveloperName, 
														NE__ProdId__r.OB_Acquirer__c 
														FROM  NE__OrderItem__c 
														WHERE  OB_FulfilmentStatus__c not in ('Completed','Cancelled','Disconnected','Rejected') 
														AND (NE__ProdId__r.RecordType.DeveloperName= :OB_EnrichOrder.TERMINALE OR 
															NE__ProdId__r.RecordType.DeveloperName= :OB_UtilityConstants.PRODUCT_RECORDTYPE_ECOMMERCE OR
															 NE__ProdId__r.RecordType.DeveloperName= :OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO
														OR (NE__ProdId__r.RecordType.DeveloperName!=: OB_EnrichOrder.TERMINALE  AND NE__ProdId__r.OB_Acquirer__c=: OB_EnrichOrder.NEXI)) 
														AND NE__OrderId__c = :request.idOrdineSfdc];
														//23/07/19 francesca.ribezzi adding moto and ecommerce RecordTypes
			if(missingItems.size()==0){
				//update all items to completed
				/*
				for(NE__OrderItem__c orderItem : orderItems){
					orderItem.OB_FulfilmentStatus__c='Completed';
				}*/
				//update orderItems;
				configurations[0].OB_FulfilmentStatus__c = COMPLETED;
				configurations[0].OB_CTI_Code__c = codiceCTI; //francesca.ribezzi 08/11/19 codiceCTI updated here -removing update from loop
				update configurations[0];

				OB_UtilityCallingServices.createAsset(configurations[0].Id,configurations[0].NE__Order_Header__r.OB_Main_Process__c);
				//NE.DataMap dm = new NE.DataMap();
				//Map <String , String> result = new map<String,String>();
				//result          =   dm.GenerateMapObjects('Order2StdAsset', request.idOrdineSfdc);
				
				//if(String.isNotBlank(result.get('ErrorMessage'))) {
				//	throw new applicationException('Error generating asset --> ' + result.get('ErrorMessage'));
				//}
			}
			
			System.debug('posPB : ' + posPB + ' hasAcq : '+ hasAcq + 'isMoneticaCall : ' + isMoneticaCall + ' welcomePOS : ' + welcomePOS + ' isAcquiring : ' + isAcquiring + ' hasEquens :  ' + hasEquens + ' hasMonetica ' + hasMonetica + ' mainprocess ' + configurations[0].NE__Order_Header__r.OB_Main_Process__c );
			//LUBRANO - 2019-02-12 -- TODO IMPLEMENTAZIONE CHIAMATA WELCOME LETTER
			if(!MAINTENANCE.equalsIgnoreCase(configurations[0].NE__Order_Header__r.OB_Main_Process__c) && !Test.isRunningTest() ){
				if(posPB && !hasAcq && isMoneticaCall && (welcomePOS == 'SI')){
					//1° caso SOLO POS+PAGBANCOMAT, all'ok di monetica inviamo la welcome letter
					System.debug('welcome caso 1');
					//michele.lubrano@accenutre.com - 28-05-2019 preventing consecutive http callouts to filenet - START
					if(configurations[0].NE__FulfilmentStatus__c != 'WelcomeLetter sent'){						
						configurations[0].NE__FulfilmentStatus__c = 'WelcomeLetter sent';
						//michele.lubrano@accenutre.com - 28-05-2019 END
						OB_UtilityCallingServices.welcomeLetter(configurations[0].NE__Order_Header__c, configurations[0].Id, configurations[0].NE__AccountId__c, servicePointId);
					}
				}else if(!posPB && hasAcq && isAcquiring){
					//2° caso SOLO ACQUIRING, alla chiamata acquiring inviamo la welcome
					System.debug('welcome caso 2');
					//michele.lubrano@accenutre.com - 28-05-2019 preventing consecutive http callouts to filenet - START
					if(configurations[0].NE__FulfilmentStatus__c != 'WelcomeLetter sent'){						
						configurations[0].NE__FulfilmentStatus__c = 'WelcomeLetter sent';
						//michele.lubrano@accenutre.com - 28-05-2019 END
						OB_UtilityCallingServices.welcomeLetter(configurations[0].NE__Order_Header__c, configurations[0].Id, configurations[0].NE__AccountId__c, servicePointId);
					}
				}else if(posPB && hasAcq && isMoneticaCall && hasEquens){
					//3° caso POS+PAGBANCOMAT + ACQUIRING, abbiamo già avuto chiamata acquiring e ora abbiamo chiamata ok monetica, oppure le abbiamo ottenute insieme 
					System.debug('welcome caso 3a');
					//michele.lubrano@accenutre.com - 28-05-2019 preventing consecutive http callouts to filenet - START
					if(configurations[0].NE__FulfilmentStatus__c != 'WelcomeLetter sent'){						
						configurations[0].NE__FulfilmentStatus__c = 'WelcomeLetter sent';
						//michele.lubrano@accenutre.com - 28-05-2019 END
						OB_UtilityCallingServices.welcomeLetter(configurations[0].NE__Order_Header__c, configurations[0].Id, configurations[0].NE__AccountId__c, servicePointId);
					}
				} else if(posPB && hasAcq && isAcquiring && hasMonetica){
					//3° caso POS+PAGBANCOMAT + ACQUIRING, abbiamo già avuto chiamato ok monetica e ora riceviamo ok acquiring
					System.debug('welcome caso 3b');
					//michele.lubrano@accenutre.com - 28-05-2019 preventing consecutive http callouts to filenet - START
					if(configurations[0].NE__FulfilmentStatus__c != 'WelcomeLetter sent'){						
						configurations[0].NE__FulfilmentStatus__c = 'WelcomeLetter sent';
						//michele.lubrano@accenutre.com - 28-05-2019 END
						OB_UtilityCallingServices.welcomeLetter(configurations[0].NE__Order_Header__c, configurations[0].Id, configurations[0].NE__AccountId__c, servicePointId);
					}
				}
				update configurations; //configuration config moved here - francesca.ribezzi 08/11/19 - Prod-36
			}			
			//	OK
			response.httpStatus 					= 200;
			response.httpMessage                    = MONETICAOK;

		}
		catch(Exception e)
		{
			System.debug('OB_TrackingOrder.getTrackingOrder Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
			//LUBRANO 28/05/2019 -- adding webresults log
			//GENERIC ERROR
			/*
			response.httpStatus 						= responseStatus;
			System.debug('error response : ' + res);
			res.statusCode 								= responseStatus;
			System.debug('Response Status : ' + responseStatus + ' Header Status : ' + responseStatus);
			*/
			response.httpMessage							= e.getMessage();		
			throw new applicationException('OB_TrackingOrder.getTrackingOrder Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());			
		}		
		return response;
	}

	//	----------------------------------------------------------------------------------------------------------------------
	//	REQUEST
	global class TrackingOrderRequest
	{
		global String idOrdineSfdc 									{get;set;}
		global List<Acquiring> Acquiring	 					    {get;set;}
		global List<GT> GT 											{get;set;}
		global TrackingOrderRequest()
		{
			Acquiring 		= new List<Acquiring>();
			GT 				= new List<GT>();
		}
	}

	global class Acquiring
	{
		global String sistemaSorgente 								{get;set;}
		global String codiceSocieta 								{get;set;}
		global List<ErrorList> errori								{get;set;}		
		global List<puntoVendita> puntiVendita 						{get;set;}	
		global Acquiring()
		{
			puntiVendita 		= new List<puntoVendita>();
			errori 			= new List<ErrorList>();
		}
	}

	global class puntoVendita
	{	
		global String itemId										{get;set;}		//	@Processor
		global String codicePuntoVendita							{get;set;}		//	@Processor
		global String dataInizio									{get;set;}		//	@Both
		global String dataCessazione								{get;set;}		//	@Processor
		global String causaleCessazione								{get;set;}		//	@Processor
		global String tipo											{get;set;}		//	@Both
		global String codiceCTI										{get;set;}		//	@GT
		//global String codiceRacSIA								{get;set;}		//	@GT
		global String codiceStabilimento							{get;set;}		//	@GT
		global String codiceStabilimentoSIA							{get;set;}		//	@GT
		global String codiceProgressivoSIA							{get;set;}		//	@GT
		global String codiceSIA										{get;set;}		//	@GT
		//global String numeroVerde									{get;set;}		//	@GT
		global String numeroAssistenzaPOS							{get;set;}		//	@GT
		global String dataInizioAttivita							{get;set;}		//	@GT
		global List<TermsIdInformation> termsIdInformations         {get;set;}
	}

	global class GT 
	{
		global String sistemaSorgente								{get;set;}
		global String statoProvisioning								{get;set;}
		global String codiceCliente									{get;set;}
		global List<ErrorList> errori								{get;set;}				
		global List<puntoVendita> puntiVendita 						{get;set;}
		//global List<TermsIdInformation> termsIdInformation 		{get;set;}
		global GT()
		{
			puntiVendita 				= new List<puntoVendita>();
			//termsIdInformation 	= new List<TermsIdInformation>();
			errori 					= new List<ErrorList>();
		}
	}

	global class ErrorList
	{
		global String codice 									{get;set;}
		global String descrizione 								{get;set;}
	}

	global class TermsIdInformation
	{
		global String termId										{get;set;}
		global String modello										{get;set;}
		global String release										{get;set;}
		global String modalitaCollegamento							{get;set;}
		global String descrizioneModello							{get;set;}
		global String descrizioneRelease							{get;set;}
		global String descrizioneConnessione						{get;set;}
		global String statoInstallazione							{get;set;}
		global String causaleRifiuto								{get;set;}
		global String dataInstallazione								{get;set;}
		global String dataDisinstallazione							{get;set;}
		global List<CodiciConvenzioni> codiciconvenzioni 			{get;set;}
		//global TermsIdInformation()
		//{
		//	codiciconvenzioni = new List<CodiciConvenzioni>();
		//}
	}

	global class CodiciConvenzioni
	{
		global String idItemSalesforce 								{get;set;}
		global String companyCode									{get;set;}
		global String companyName									{get;set;}
		global String codiceConvenzione								{get;set;}
		global String causaleRifiuto								{get;set;}
		global String dataInizio								    {get;set;}
		global String dataFine										{get;set;}
	}

	//	----------------------------------------------------------------------------------------------------------------------
	//	RESPONSE
	global class TrackingOrderResponse
	{
		global Integer httpStatus 									{get;set;}
	//START gianluigi.virga 10/06/2019
		global String httpMessage									{get;set;}
	//END gianluigi.virga	
	}

	// LUBRANO -- 2019-05-28 -- add web results log  //francesca.ribezzi 26/09/19 - F2WAVE2-189 - changing return from void to id (plcId)
	global static Id insertLog(RestRequest req, OB_TrackingOrder.TrackingOrderResponse res, Integer status, String message, String plcStatus){
		
		String header = '';
		Datetime dateNow =  Datetime.now();
		Integer millisecondsNow = dateNow.millisecond();
		for(String key : req.headers.keySet()){
			header = key + ' : ' + req.headers.get(key) + '\r';
		}
		Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
		ls.processingTime = String.valueOf(millisecondsNow);
		ls.httpMethod = 'POST';
		ls.requestUri = '';
		ls.requestHeader = header;
		ls.requestBody = req.requestBody.toString();
		ls.responseBody = res.toString();
		ls.responseStatus = plcStatus;
		ls.responseMessage = message;
		ls.responseStackTrace = String.valueOf(status);
		ls.recordUrl = '';
		return Plc_LogHelper.logCall(ls); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - changing return from void to id (plcId)

	}


	global static Datetime formatDate (String dateString){
		//Datetime t  = new Datetime();
		system.debug('dateString '+dateString);
		if(String.isNotBlank(dateString)){
			String[] arrayString = dateString.split('-');
			Datetime instanceDate  = Datetime.newInstanceGmt(Integer.valueOf(arrayString[0]), Integer.valueOf(arrayString[1]), Integer.valueOf(arrayString[2]));
			return instanceDate;
		}else{
			return null;
		}
		
	}


	global static void updateServicePointExternalMapping(ExternalSourceMapping__c inputMapping){
		List<ExternalSourceMapping__c> spMappings = [SELECT id,ob_source__c,OB_CustomerCodeClientCode__c,OB_ServicePointCodeShopCode__c,OB_Conventioncode__c  FROM ExternalSourceMapping__c WHERE OB_Source__c =: inputMapping.OB_Source__c and OB_CustomerCodeClientCode__c =: inputMapping.OB_CustomerCodeClientCode__c and OB_ServicePointCodeShopCode__c =: inputMapping.OB_ServicePointCodeShopCode__c ];
		Map<String,ExternalSourceMapping__c> extNewMap = new Map<String,ExternalSourceMapping__c>();
		if(spMappings.size()==0){
			insert inputMapping;
		}else{
			for(ExternalSourceMapping__c exMap : spMappings){
				if(String.isBlank(exMap.OB_Conventioncode__c)){
					extNewMap.put(exMap.ob_source__c+exMap.OB_CustomerCodeClientCode__c+exMap.OB_ServicePointCodeShopCode__c,exMap);
				}else{
					extNewMap.put(exMap.ob_source__c+exMap.OB_CustomerCodeClientCode__c+exMap.OB_ServicePointCodeShopCode__c+exMap.OB_Conventioncode__c,exMap);
				}
			}

			if(extNewMap.containsKey(inputMapping.ob_source__c+inputMapping.OB_CustomerCodeClientCode__c+inputMapping.OB_ServicePointCodeShopCode__c+inputMapping.OB_Conventioncode__c)){
				inputMapping.Id = extNewMap.get(inputMapping.ob_source__c+inputMapping.OB_CustomerCodeClientCode__c+inputMapping.OB_ServicePointCodeShopCode__c+inputMapping.OB_Conventioncode__c).id;
				update inputMapping;
			}else if(extNewMap.containsKey(inputMapping.ob_source__c+inputMapping.OB_CustomerCodeClientCode__c+inputMapping.OB_ServicePointCodeShopCode__c)){
				inputMapping.Id = extNewMap.get(inputMapping.ob_source__c+inputMapping.OB_CustomerCodeClientCode__c+inputMapping.OB_ServicePointCodeShopCode__c).id;
				update inputMapping;
			}else{
				insert inputMapping;
			}
		}
	}

	global static void updateMerchantExternalMapping(ExternalSourceMapping__c inputMapping){
		List<ExternalSourceMapping__c> spMappings = [SELECT id,ob_source__c,OB_CustomerCodeClientCode__c,OB_ServicePointCodeShopCode__c,OB_Conventioncode__c  FROM ExternalSourceMapping__c WHERE OB_Source__c =: inputMapping.OB_Source__c and OB_CustomerCodeClientCode__c =: inputMapping.OB_CustomerCodeClientCode__c and OB_Merchant_ID__c =: inputMapping.OB_Merchant_ID__c];

		if(spMappings.size()==0){
			insert inputMapping;
		}else{
			inputMapping.id = spMappings[0].id;
			update inputMapping;
		}
	}

	//LUBRANO 2019-03-18 -- obsolete method
	/*
	global static void updateExternalMapping (Map<String,ExternalSourceMapping__c> extNewMap, Id merchantId , Id servicePointId,String MCC, String shopSign, Boolean isMoto,String pricingType){
		
		String query  = 'SELECT Id,MIG_Batch_ID__c,Mig_External_ID__c,MIG_Run_ID__c, Name, OB_Business_Model__c, ';
               query += 'OB_Company_End_Reason__c,OB_Conventioncode__c,OB_CTICode__c,OB_CustomerCodeClientCode__c,';
               query += 'OB_Description__c,OB_EcommerceType__c,OB_End_Date__c,';
               query += 'OB_isCarRentalisHotel__c,OB_isMoTo__c, OB_Merchant_ID__c, ';
               query += 'OB_Pricing__c,OB_ReportTypeFormat__c,OB_ReportType__c,OB_ServicePointCodeShopCode__c, ';
               query += 'OB_Service_Point_ID__c,OB_Service_Point_Type__c,OB_SionID__c,OB_Source__c,OB_Start_Date__c, OB_ConventionCodeSource__c,';
               query += 'OB_PBSettlementMethod__c,OB_InternationalSettlementMethod__c, OB_MCC__c, OB_MCCL2__c,';
               query += 'OB_ToBeChecked__c FROM ExternalSourceMapping__c ';
               query += 'WHERE (OB_Merchant_ID__c = : merchantId OR (OB_Service_Point_ID__c =: servicePointId ';     
               query += ' AND OB_MCC__c =: MCC ';

               query += 'AND OB_ShopSign__c =: shopSign AND OB_Pricing__c =: pricingType))';
			   query += ' AND OB_ToBeChecked__c=false ';
			   query += ' AND OB_isMoTo__c =: isMoto';

      	List<ExternalSourceMapping__c> externalMapping 	= Database.query(query);     
        List<ExternalSourceMapping__c> mappingToInsert 	= new List<ExternalSourceMapping__c>();
        List<ExternalSourceMapping__c> mappingToUpdate 	= new List<ExternalSourceMapping__c>();
        
       	for(ExternalSourceMapping__c extItem : externalMapping){
    		
    		ExternalSourceMapping__c tmp 	= new ExternalSourceMapping__c();
    		String 	currentKey				= '';
    		Boolean containskey 			= false;

			//LUBRANO 2019-02-18 -- MODIFICA LOGICHE EXTERNAL SOURCE MAPPING
			
    		if(extNewMap.containskey(extItem.OB_ServicePointCodeShopCode__c)){
    			tmp = extNewMap.get(extItem.OB_ServicePointCodeShopCode__c);
    			currentKey = extItem.OB_ServicePointCodeShopCode__c;
    			containskey = true;
    		}
			
    		if(extNewMap.containskey(extItem.OB_CustomerCodeClientCode__c)){
    			tmp = extNewMap.get(extItem.OB_CustomerCodeClientCode__c);
    			currentKey = extItem.OB_CustomerCodeClientCode__c;
    			containskey = true;
    		} 
			//check Service Point
			
			if(extNewMap.containskey(extItem.OB_Source__c+extItem.OB_CustomerCodeClientCode__c+extItem.OB_ServicePointCodeShopCode__c)){
    			tmp = extNewMap.get(extItem.OB_Source__c+extItem.OB_CustomerCodeClientCode__c+extItem.OB_ServicePointCodeShopCode__c);
    			currentKey = extItem.OB_Source__c+extItem.OB_CustomerCodeClientCode__c+extItem.OB_ServicePointCodeShopCode__c;
    			containskey = true;
				System.debug('*** SP : ' + extItem);
    		}
			//check Merchant
			if(extNewMap.containskey(extItem.OB_Source__c+extItem.OB_CustomerCodeClientCode__c+extItem.OB_Merchant_ID__c)){
    			tmp = extNewMap.get(extItem.OB_Source__c+extItem.OB_CustomerCodeClientCode__c+extItem.OB_Merchant_ID__c);
    			currentKey = extItem.OB_Source__c+extItem.OB_CustomerCodeClientCode__c+extItem.OB_Merchant_ID__c;
    			containskey = true;
				System.debug('*** ME : ' + extItem);
    		} 

    		if(containskey){
    			if(tmp.OB_Source__c == extItem.OB_Source__c){
    				tmp.id = extItem.Id;
    				mappingToUpdate.add(tmp);
					System.debug('*** remove ' + ' key : ' + currentKey + ' item : ' + extItem );
    				ExternalSourceMapping__c result = extNewMap.remove(currentKey);
    			}
    		}
    	}

    	for(String key: extNewMap.keySet()){
    		mappingToInsert.add(extNewMap.get(key));
    	}

        if(mappingToInsert.size()>0){
        	insert mappingToInsert;
        }

        if(mappingToUpdate.size()>0){
        	update mappingToUpdate;
        }


	}*/

	public class applicationException extends Exception {}

	public class  associativeCode{
		String companyCode ;
		String servicePointCode;
		String obInternationalSettlementMethod;
		String processor;
		Datetime startDate;
		Datetime endDate;

		associativeCode(){

		}

	}

	public static void acquaringItemsToUpdateManagement(NE__Order__c configuration,List<NE__OrderItem__c> acquiringNexiList, String obFulfilmentStatus, String codiceSocieta, String codicePuntoVendita, String dataInizio, String dataCessazione,Map<Id,List<NE__OrderItem__c>> mapChildOI, List<NE__OrderItem__c> itemToUpdateList){

		for (NE__OrderItem__c orderItem: acquiringNexiList){
			if(obFulfilmentStatus != FAILED){
				orderItem.OB_CompanyCode__c = codiceSocieta;
				if(String.isBlank(orderItem.OB_ServicePointCode__c )){ //francesca.ribezzi 04/11/19 - WN-617 setting value only when sp code is blank to not overwrite previous values
					orderItem.OB_ServicePointCode__c = codicePuntoVendita;
				}
				if(String.isNotBlank(dataInizio)){
					orderItem.NE__StartDate__c = OB_TrackingOrder.formatDate(dataInizio);
				}
				if(String.isNotBlank(dataCessazione)){
					orderItem.NE__EndDate__c = OB_TrackingOrder.formatDate(dataCessazione);
				}				
			}
			orderItem.OB_Tech_Outcome_Equens__c = (obFulfilmentStatus == FAILED) ? MONETICAKO : MONETICAOK;
			orderItem.OB_FulfilmentStatus__c=obFulfilmentStatus;
			itemToUpdateList.add(orderItem);
			if(mapChildOI.containsKey(orderItem.Id)){
				for(NE__OrderItem__c childOrderItem: mapChildOI.get(orderItem.Id)){
					childOrderItem.OB_FulfilmentStatus__c=obFulfilmentStatus;
					itemToUpdateList.add(childOrderItem);
				}
			}
		}
		if(obFulfilmentStatus == FAILED){ //francesca.ribezzi 08/11/19 - PROD-36 updating configuration status to failed 
			configuration.OB_FulfilmentStatus__c = obFulfilmentStatus;
			update configuration;
		}	
		update itemToUpdateList; //francesca.ribezzi 06/11/19 - PROD-36 - adding update
	}

	public static void gtItemsToUpdateManagement(NE__Order__c configuration,NE__OrderItem__c orderItem,String obFulfilmentStatus,Map<Id,List<NE__OrderItem__c>> mapChildOI, List<NE__OrderItem__c> pagobancomatList ,Map<String,CodiciConvenzioni> codiciConvenzione,Map<String,NE__OrderItem__c> rootVasList,List<NE__OrderItem__c> itemToUpdateList, Boolean pagobancomatFlag,List<NE__OrderItem__c> acquiringNexiList,Boolean cancelPB,OB_TrackingOrder.TrackingOrderRequest req){

		orderItem.OB_FulfilmentStatus__c=obFulfilmentStatus;
		//LUBRANO - 2019-02-08 - registarzione ok/ko MONETICA in nuovo campo separato
		if(obFulfilmentStatus == FAILED){
			orderItem.OB_Tech_Outcome_Monetica__c = MONETICAKO;
		}
		itemToUpdateList.add(orderItem);
		system.debug('orderItem.Id ' + orderItem.Id);
		system.debug('orderItem.Id ' + mapChildOI.containsKey(orderItem.Id));

		//Update pagobancomat items section
		if(
			((obFulfilmentStatus == COMPLETED || obFulfilmentStatus == FAILED) || cancelPB )
			&& pagobancomatFlag == false		
		){
			//we update the status only if Monetica sends us a KO or an installation/disinstallation request
			//if it is a rejection we update them only if all terminals have been rejected
			for(NE__OrderItem__c pagobancomatItem : pagobancomatList){
				pagobancomatItem.OB_FulfilmentStatus__c = obFulfilmentStatus;
				System.debug(' pagobancomatItem : ' + pagobancomatItem);
				itemToUpdateList.add(pagobancomatItem);
				if(mapChildOI.containsKey(pagobancomatItem.Id)){
					for(NE__OrderItem__c childOrderItem: mapChildOI.get(pagobancomatItem.Id)){
						childOrderItem.OB_FulfilmentStatus__c=obFulfilmentStatus;
						System.debug(' childOrderItem X' + childOrderItem);
						itemToUpdateList.add(childOrderItem);
					}
				}
			}
			//pagobancomatFlag = true;
		}

		if(mapChildOI.containsKey(orderItem.Id)){
			for(NE__OrderItem__c childOrderItem: mapChildOI.get(orderItem.Id)){
				if((obFulfilmentStatus ==COMPLETED && childOrderItem.NE__ProdId__r.RecordType.DeveloperName==OB_EnrichOrder.PRICING)
					|| obFulfilmentStatus !=COMPLETED){
						childOrderItem.OB_FulfilmentStatus__c=obFulfilmentStatus;
						System.debug(' mapChildOI childOrderItem ' + childOrderItem);
				}
				system.debug('childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c ' + childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
										
				if(obFulfilmentStatus ==COMPLETED  || obFulfilmentStatus == FAILED ){
					//START VAS -- esclusi acquiring nexi che vengono processati come acquiring
					if(orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI){						
						CodiciConvenzioni convenzione = new CodiciConvenzioni();
						if(codiciConvenzione.containsKey(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c)){
							convenzione = codiciConvenzione.get(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
							childOrderItem.OB_FulfilmentStatus__c	= obFulfilmentStatus;
							if(obFulfilmentStatus != FAILED ){
								childOrderItem.OB_CompanyCode__c 		= convenzione.companyCode;
								childOrderItem.OB_Conventioncode__c		= convenzione.codiceConvenzione;
								childOrderItem.NE__StartDate__c			= formatDate(convenzione.dataInizio);
							}
							if(rootVasList.containskey(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c) && obFulfilmentStatus != FAILED){
								NE__OrderItem__c root 			= rootVasList.get(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
								root.OB_FulfilmentStatus__c		= obFulfilmentStatus;
								root.NE__StartDate__c			= convenzione != null ? formatDate(convenzione.dataInizio) : null;
								itemToUpdateList.add(root);
								//LUBRANO 2019-04-08 -- BUGFIX DUPLICATE ITEMS FOR ROOT VAS
								rootVasList.remove(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
								
							}	
						}
					}
				}
				//LUBRANO -- se acquiring non aggiungiamo
				//if(!acquiringNexiList.contains(childOrderItem)){
				if(!(childOrderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && childOrderItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI) 
					&& !(childOrderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && !codiciConvenzione.containskey(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c))
					&& !(childOrderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && childOrderItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI)
					&& !(childOrderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PCI )
					&& !(childOrderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.COMMISSIONE)){
					itemToUpdateList.add(childOrderItem);
				}
			}
		}
		List<Asset> assetList = [SELECT OB_ShopCode__c,
									OB_GT__c,
									OB_CustomerCode__c,
									(SELECT Id, Name, NE__Value__c FROM NE__AssetItemAttributes__r)
									FROM Asset
									WHERE Id =: orderItem.NE__AssetItemEnterpriseId__c LIMIT 1];
		System.debug('Asset in updateGTItemsDetails: '+ assetList);
		Asset asset = new Asset();
		List<NE__AssetItemAttribute__c> attributes = new List<NE__AssetItemAttribute__c>();
		List<NE__Order_Item_Attribute__c> attributesToUpdate = new  List<NE__Order_Item_Attribute__c>();
		if(!assetList.isEmpty()){
			asset = assetList.get(0);
			asset.OB_ShopCode__c = orderItem.OB_ShopCode__c;
			asset.OB_GT__c = orderItem.OB_GT__c;
			asset.OB_CustomerCode__c = orderItem.OB_CustomerCode__c;

			for(NE__AssetItemAttribute__c attr : asset.NE__AssetItemAttributes__r){
				System.debug('Update asset attributes');
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.TERMID)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].termsIdInformations[0].termId;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.MODELLO)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].termsIdInformations[0].modello;
					asset.OB_Model__c = req.GT[0].puntiVendita[0].termsIdInformations[0].modello;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.RELEASE)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].termsIdInformations[0].descrizioneRelease;
					asset.OB_Release__c = req.GT[0].puntiVendita[0].termsIdInformations[0].descrizioneRelease;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.MODCOLLEGAMENTO)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].termsIdInformations[0].modalitaCollegamento;
					asset.OB_LinkType__c = req.GT[0].puntiVendita[0].termsIdInformations[0].modalitaCollegamento;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.DMODELLO)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].termsIdInformations[0].descrizioneModello;
					asset.OB_ModelDescription__c = req.GT[0].puntiVendita[0].termsIdInformations[0].descrizioneModello;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.DRELEASE)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].termsIdInformations[0].release;
					asset.OB_ReleaseDescription__c = req.GT[0].puntiVendita[0].termsIdInformations[0].release;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.DCONNESSIONE)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].termsIdInformations[0].descrizioneConnessione;
					asset.OB_LinkDescription__c = req.GT[0].puntiVendita[0].termsIdInformations[0].descrizioneConnessione;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.PROGRESSIVOSIA)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].codiceProgressivoSIA;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].codiceStabilimentoSIA;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase(OB_TrackingOrderMaintenance.CODICESIA)){
					attr.NE__Value__c = req.GT[0].puntiVendita[0].codiceSIA;
					attributes.add(attr);
				}
			}
			update asset;
		}
		if(obFulfilmentStatus == FAILED){ //francesca.ribezzi 08/11/19 - PROD-36 updating configuration status to failed
			configuration.OB_FulfilmentStatus__c = obFulfilmentStatus;
			update configuration;
		}
		update attributes;
		update attributesToUpdate;
	}



	public static void checkErrors(List<Acquiring> acquiringList,List<GT> GTArray, Map<String,Object> acquiringArguments,Map<String,Object> gtArguments){ //gianluigi.virga 20/11/2019 - changed method return from integer to void and removed Integer responseStatus and List<NE__OrderItem__c> itemToUpdateList parameters
		// Gestione Error Codes
		//Controlliamo se ci sono error code per capire se cambiare lo status in 200

		NE__Order__c configuration = (NE__Order__c) acquiringArguments.get('configuration');
		List<NE__OrderItem__c> acquiringNexiList = (List<NE__OrderItem__c>) acquiringArguments.get('acquiringNexiList');
		Map<Id,List<NE__OrderItem__c>> mapChildOI = (Map<Id,List<NE__OrderItem__c>>) acquiringArguments.get('mapChildOI');
		Map<String,NE__OrderItem__c> mapTermId = (Map<String,NE__OrderItem__c>) gtArguments.get('mapTermId');
		List<NE__OrderItem__c> pagobancomatList = (List<NE__OrderItem__c>) gtArguments.get('pagobancomatList');
		Map<String,CodiciConvenzioni> codiciConvenzione = new Map<String,CodiciConvenzioni>();
		Map<String,NE__OrderItem__c> rootVasList = (Map<String,NE__OrderItem__c>) gtArguments.get('rootVasList');
		Boolean isAcquiring = false;
		Boolean isGT = false;
		// START gianluigi.virga 20/11/2019 - fix to restore configuration.OB_Tracking_Errors__c update
		if(acquiringList != null && acquiringList.size() > 0){
			for(Acquiring acq : acquiringList){
				if(acq.errori != null && acq.errori.size() > 0){
					isAcquiring = true;
		// 			responseStatus = 200;
		// 			acquaringItemsToUpdateManagement(configuration,acquiringNexiList,FAILED,'','','','',mapChildOI,itemToUpdateList);

		// 			update itemToUpdateList;
					
		// 			//throw new applicationException('Errors found in acquiring requests');
		// 			//return responseStatus;
				}
			}	
		}
		
		if(GTArray != null && GTArray.size() > 0){
			for(GT singleGt : GTArray){
				if(singleGt.errori != null && singleGt.errori.size() > 0){
					isGT = true;
		// 			responseStatus = 200;
		// 			for(NE__OrderItem__c orderItem : mapTermId.values()){
		// 				gtItemsToUpdateManagement(configuration,orderItem,FAILED,mapChildOI,pagobancomatList, codiciConvenzione,rootVasList,itemToUpdateList,false,acquiringNexiList,false);
		// 			}
		// 			update itemToUpdateList;
		// 			// configuration.OB_FulfilmentStatus__c = FAILED;
		// 			// update configuration;
		// 			// System.debug('checkErrorGT responseStatus : ' + responseStatus);
		// 			// NE__Order_Header__c orderHeader = new NE__Order_Header__c(Id = configuration.NE__Order_Header__c);
		// 			// //orderHeader.OB_FulfilmentStatus__c = FAILED;
		// 			// orderHeader.OB_Rejection_Comments__c = 'Sistema sorgente : ' + singleGt.sistemaSorgente + ' Codice Cliente : ' + singleGt.codiceCliente  + ' Stato Provisioning : ' + singleGt.statoProvisioning +' Error List : ' + singleGt.errori;
		// 			// update orderHeader;
		// 			//throw new applicationException('Errors found in gt requests');
		// 			//return responseStatus;
				}
			}
		}
		if(isAcquiring == true || isGT == true){
		// 	configuration.OB_FulfilmentStatus__c = FAILED;
		// 	NE__Order_Header__c orderHeader = new NE__Order_Header__c(Id = configuration.NE__Order_Header__c);
		// 	System.debug('checkErrorAcquiring responseStatus : ' + responseStatus);
			String errorConfig = '';
		// 	String errorHeader = '';

			if(isAcquiring == true){
				for(Acquiring acq : acquiringList){
					errorConfig += errorStringFormatter(true,acq.errori);
					// errorHeader += 'Sistema sorgente : ' + acq.sistemaSorgente + ' Codice Società : ' + acq.codiceSocieta  + ' Error List : ' + acq.errori;
				}
			}

			if(isGT == true){
				for(GT singleGt : GTArray){
					errorConfig += errorStringFormatter(false,singleGT.errori);
					// errorHeader += 'Sistema sorgente : ' + singleGt.sistemaSorgente + ' Codice Cliente : ' + singleGt.codiceCliente  + ' Stato Provisioning : ' + singleGt.statoProvisioning +' Error List : ' + singleGt.errori;
				}
			}

			configuration.OB_Tracking_Errors__c = errorConfig;
		// 	orderHeader.OB_Rejection_Comments__c = errorHeader;

			update configuration;
		// 	//update orderHeader;
		// 	return responseStatus;
		}
		
		// return 500; //gianluigi.virga 20/11/2019 - commented return;
		// END gianluigi.virga 20/11/2019 - fix to restore configuration.OB_Tracking_Errors__c update
	}

	public static void updateServicePointInfo(List<NE__OrderItem__c> orderitemlist,List<OB_TrackingOrder.puntoVendita> puntiVendita,NE__Order__c configuration ){

		List<NE__OrderItem__c> itemsToUpdate = new List<NE__OrderItem__c>();
		List<NE__Order_Item_Attribute__c> attributes = new  List<NE__Order_Item_Attribute__c>();

		if(orderitemlist != null && puntiVendita != null && orderitemlist.size()>0 && puntiVendita.size()>0){
			
			for(OB_TrackingOrder.puntoVendita pv : puntiVendita){
				//LUBRANO 23-02-2019 -- AGGIORNAMENTO CTI E NUMEROVERDE SU CONFIGURATION
				configuration.OB_Numero_Assitenza_POS__c = pv.numeroAssistenzaPOS;
				configuration.OB_CTI_Code__c = pv.codiceCTI;
				for( NE__OrderItem__c item : orderitemlist){
					//enrico Purificato WN-207 - END
					if((
						(item.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.TERMINALE || item.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PAGOBANCOMAT) 
						|| (item.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ECOMMERCERT || item.NE__ProdId__r.RecordType.DeveloperName  == OB_EnrichOrder.MOTORT)
						|| (item.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && item.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.ONECLICK) 
						|| (item.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && item.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.RECURRING) 
						) && item.OB_FulfilmentStatus__c != COMPLETED && item.OB_FulfilmentStatus__c != CANCELLED )
						//enrico Purificato WN-207 - END
						{
						
						item.OB_ShopCode__c = pv.codiceStabilimento;
						//LUBRANO - 2019-02-08 - registarzione ok/ko MONETICA in nuovo campo separato + numeroAssistenzaPOS
						if(item.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.PAGOBANCOMAT) //enrico Purificato WN-207 from == OB_EnrichOrder.TERMINALE to != OB_EnrichOrder.PAGOBANCOMAT
						{
							item.OB_Tech_Outcome_Monetica__c = MONETICAOK;
							item.OB_Numero_Assitenza_POS__c = pv.numeroAssistenzaPOS;
							//START [13-03-2019 Manage Rac Sia Code] Andrea Saracini
							item.OB_RAC_SIA__c = pv.codiceSIA + pv.codiceStabilimentoSIA + pv.codiceProgressivoSIA;
							//STOP [13-03-2019 Manage Rac Sia Code] Andrea Saracini 							
						}	

						for(NE__Order_Item_Attribute__c attr : item.NE__Order_Item_Attributes__r ){
							if(attr.Name.equalsIgnoreCase('Codice Stabilimento SIA')){
								attr.NE__Value__c = pv.codiceStabilimentoSIA;
								attributes.add(attr);
							}
							if(attr.Name.equalsIgnoreCase('Progressivo SIA')){
								attr.NE__Value__c = pv.codiceProgressivoSIA;
								attributes.add(attr);
							}
							if(attr.Name.equalsIgnoreCase('Codice SIA')){
								attr.NE__Value__c =pv.codiceSIA;
								attributes.add(attr);
							}
						}
						itemsToUpdate.add(item);
					}
				}
				break;
			}
		}
		if(itemsToUpdate.size()>0){
			update itemsToUpdate;
			update attributes;
		}
		update configuration; 
	}

	//LUBRANO 2019-02-20 -- AGGIORNAMENTO CONVENTIONCODE PER EXSM MONETICA
	public static ExternalSourceMapping__c conventionCodeManagement(Boolean isAcquiring,Boolean isGT,Boolean hasMonetica,Boolean hasAcquiring,ExternalSourceMapping__c servicePoint,List<NE__OrderItem__c> acquiringNexiList,Id servicePointId,Map<String,NE__OrderItem__c> mapTermId, String conventionCodeExSM){
		//extItem.OB_Source__c+extItem.OB_CustomerCodeClientCode__c+extItem.OB_Merchant_ID__c
		
		if(isAcquiring && isGT){
			//servicePoint input monetica
			//output monetica
			//ExternalSourceMapping__c servicePointEquens = [select id,OB_ServicePointCodeShopCode__c  from ExternalSourceMapping__c where OB_Source__c = 'EQUENS' AND OB_Service_Point_ID__c =:servicePointId ];
			servicePoint.OB_ConventionCode__c  = conventionCodeExSM;
			return servicePoint;
		}else if(isAcquiring && hasMonetica && !isGT){
			//servicePoint input di equens
			//output monetica
			NE__OrderItem__c terminal = mapTermId.values()[0];
			ExternalSourceMapping__c servicePointMonetica;
			List<ExternalSourceMapping__c> servicePointMoneticaList = [select id,OB_ConventionCode__c  from ExternalSourceMapping__c where OB_Source__c = 'MONETICA' AND OB_CustomerCodeClientCode__c =: terminal.OB_CustomerCode__c and OB_ServicePointCodeShopCode__c =: terminal.OB_ShopCode__c and OB_Service_Point_ID__c =: servicePointId ];
			system.debug(' ### eternalmaps list : ' + servicePointMoneticaList);
			if(servicePointMoneticaList.size() >1 ){

				for(ExternalSourceMapping__c spExtMap : servicePointMoneticaList){
					if(spExtMap.OB_ConventionCode__c  == servicePoint.OB_ServicePointCodeShopCode__c){
						//we already have the convention code so we don't need any update
						return null;
					}else if(String.isBlank(spExtMap.OB_ConventionCode__c)){
						servicePointMonetica = spExtMap;
						servicePointMonetica.OB_ConventionCode__c = servicePoint.OB_ServicePointCodeShopCode__c;
					}
				}
				return servicePointMonetica;
			} else{
				if(servicePointMoneticaList.size() >0 && String.isBlank(servicePointMoneticaList[0].OB_ConventionCode__c)){
						servicePointMonetica = servicePointMoneticaList[0];
						servicePointMonetica.OB_ConventionCode__c = servicePoint.OB_ServicePointCodeShopCode__c;
						system.debug(' *** servicp ' + servicePointMonetica);
						return servicePointMonetica;
				}else {
					return null;
				}
			}			
		}else if(isGT && hasAcquiring && !isAcquiring){
			//servicePoint input di monetica
			//output monetica
			servicePoint.OB_ConventionCode__c  = acquiringNexiList[0].OB_ServicePointCode__c;
			return servicePoint;
		}
		return servicePoint;
	}

	public static String errorStringFormatter(Boolean isAcquiring,List<ErrorList> errorList){
		String errorString = isAcquiring ? 'Acquiring errors : ' : ' GT errors : ';

		for(ErrorList error : errorList){
			errorString += '\r codice : ' + error.codice + ' \r errore : ' + error.descrizione;			
		}

		return errorString;

	}

	// LUBRANO -- 2019-04-02 -- new method to check if all terminals have been rejected
	public static Boolean checkAllRejected(Map<String,NE__OrderItem__c> mapTermId,List<TermsIdInformation> termsIdInformations ){
		Set<String> allTermIds = mapTermId.keySet();
		//Boolean cancelPB = true;
		Boolean cancelPB;
		for(String terminalID : allTermIds){
			// Boolean terminalFound = false;
			cancelPB = false;
			for(TermsIdInformation terminal : termsIdInformations){
				if(terminalID.equalsIgnoreCase(terminal.termId)){
					cancelPB = true;
				}
			}
			// if(terminalFound == false){
			// 	cancelPB = false;
			// }
		}
		return cancelPB;
	}

	//START gianluigi.virga 28/06/2019 - method to print response on configuration in catch case on getTrackingOrder
	public static void updateResponse(String orderId, String message, Integer status){
		try{	
			//francesca.ribezzi 06/09/19 no need to query for the order
			if(String.isNotBlank(orderId) && orderId != null){
				update new NE__Order__c(Id= orderId,OB_ResponseTrackingOrder__c = RESPONSEHTTPSTATUS + ' '+String.valueOf(status)+' - ' + RESPONSEMESSAGE + message); 
			}	
		}catch(Exception e)
		{
			System.debug(Logginglevel.ERROR,'OB_TrackingOrder.updateResponse Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
		}
	}
	//END gianluigi.virga
	/*****************************************************************
Purpose:  Update GT items OK Monetica
History
--------
VERSION  AUTHOR         	DATE           DETAIL          Description
1.0   	 gianluigi.virga    17/05/2019     Created         CSR:
*****************************************************************/

	public static void updateGTItemsOkMonetica(Map<String,NE__OrderItem__c> mapTermId, Map<Id,List<NE__OrderItem__c>> mapChildOI, List<NE__OrderItem__c> pagobancomatList, puntoVendita pv, String source, GT gt, NE__Order__c conf){
		List<NE__OrderItem__c> itemsToUpdate = new List<NE__OrderItem__c>();
		List<NE__Order_Item_Attribute__c> attributes = new  List<NE__Order_Item_Attribute__c>();
		for(NE__OrderItem__c terminal : mapTermId.values()){
			if(terminal.OB_FulfilmentStatus__c != COMPLETED && terminal.OB_FulfilmentStatus__c != CANCELLED){
				terminal.OB_FulfilmentStatus__c = COMPLETED;
				terminal.OB_ShopCode__c 		= pv.codiceStabilimento;
				terminal.OB_GT__c 				= source;
				terminal.OB_CustomerCode__c 	= gt.codiceCliente;
				terminal.OB_Numero_Assitenza_POS__c = pv.numeroAssistenzaPOS;
				terminal.OB_Tech_Outcome_Monetica__c = MONETICAOK;
				terminal.OB_RAC_SIA__c = pv.codiceSIA + pv.codiceStabilimentoSIA + pv.codiceProgressivoSIA;
				itemsToUpdate.add(terminal);
				if(mapChildOI.containsKey(terminal.id)){
					List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(terminal.Id);
					for(NE__OrderItem__c child : listOfChildItem){
						if(child.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.ACQUIRING
								&& child.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.VAS){
							child.OB_FulfilmentStatus__c = COMPLETED;
							itemsToUpdate.add(child);
						}
					}
				}
			}
		}

		for(NE__OrderItem__c pagobancomatItem : pagobancomatList){
			System.debug(' pagobancomatItem ' + pagobancomatItem);
			pagobancomatItem.OB_FulfilmentStatus__c = COMPLETED;
			itemsToUpdate.add(pagobancomatItem);
			if(mapChildOI.containsKey(pagobancomatItem.Id)){
				for(NE__OrderItem__c childOrderItem: mapChildOI.get(pagobancomatItem.Id)){
					System.debug(' childOrderItem ' + childOrderItem);
					childOrderItem.OB_FulfilmentStatus__c=COMPLETED;
					itemsToUpdate.add(childOrderItem);
				}
			}
		}

		for(NE__OrderItem__c item : itemsToUpdate){
			for(NE__Order_Item_Attribute__c attr : item.NE__Order_Item_Attributes__r ){
				if(attr.Name.equalsIgnoreCase('Codice Stabilimento SIA')){
					attr.NE__Value__c = pv.codiceStabilimentoSIA;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase('Progressivo SIA')){
					attr.NE__Value__c = pv.codiceProgressivoSIA;
					attributes.add(attr);
				}
				if(attr.Name.equalsIgnoreCase('Codice SIA')){
					attr.NE__Value__c =pv.codiceSIA;
					attributes.add(attr);
				}
			}
		}
		conf.OB_Numero_Assitenza_POS__c = pv.numeroAssistenzaPOS;
		conf.OB_CTI_Code__c = pv.codiceCTI;
		update itemsToUpdate;
		update attributes;
		update conf; 
	}
}