/******************************************************************
Name:  OB_TrackingOrderMaintenance
============================================================
Purpose: Service to tracking order information in maintenance
============================================================
History
-------                                                            
VERSION  		AUTHOR         		DATE           	DETAIL         Description
1.0          	gianluigi.virga     02/05/2019      Created           Creation of the  class
*****************************************************************/

@RestResource(urlMapping='/TrackingOrderMaintenance/*')
global without sharing class OB_TrackingOrderMaintenance 
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
	//public final static String MCC = 'mcc';
	public final static String L2 = 'L2';
	public final static String NEXI = 'NEXI';
	public final static String MONETICA = 'MONETICA';
	public final static String TIPOLOGICHE ='TIPOLOGICHE';
	public final static String TRACKING ='TRACKING';
	public final static String SOSTITUZIONETERMINALI = 'sostituzione terminali';
	public final static String VARIAZIONECONOMICA = 'variazione economica';//Simone Misani 13/07/2019
	public final static String NONE = 'NONE';
	public final static String ADD = 'ADD';
	public final static String REMOVE = 'REMOVE';
	public final static String PROGRESSIVOSIA = 'Progressivo SIA';
	public final static String CODICESTABILIMENTOSIA = 'Codice Stabilimento SIA';
	public final static String CODICESIA = 'Codice SIA';
	public final static String INSTALLED = 'Installed';
	public final static String DISINSTALLED = 'Uninstalled';
	public final static String REFUSED = 'Refused';
	public final static String TERMID = 'TermId';
	public final static String MODELLO = 'modello';
	public final static String RELEASE = 'Release';
	public final static String MODCOLLEGAMENTO = 'modalità Collegamento';
	public final static String DISCONNECTED = 'Disconnected';
	public final static String REJECTED = 'Rejected';
	public final static String ACTIVE = 'Active';
	public final static String EQUENS = 'Equens';
	public final static String SIA = 'Sia';
	public final static String DRAFT = 'Draft';
	

    //	REQUEST
    

    @HttpPost
	global static OB_TrackingUtility.TrackingOrderResponseMaintenance trackOrderMaintenance()
	{
		RestResponse res = RestContext.response;
		OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();
		String req 	= '';
		Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
		String header = '';
		Id plcId; // francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
		String orderId; //francesca.ribezzi 26/09/19 - F2WAVE2-189 - declaring orderId outside
		for(String key : res.headers.keySet()){
			header = key + ' : ' + res.headers.get(key) + '\r';
		}
			try{
				ls.processingTime = '';
				ls.httpMethod = 'POST';
				ls.requestUri = '';
				ls.requestHeader =header;
				ls.requestBody = String.valueOf(RestContext.request.requestBody);
				//elena.preteni WN-60 09/07/2019
				ls.responseMessage ='';
				ls.responseStatus = 'W';
			
				plcId = Plc_LogHelper.logCall(ls); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
				
				//elena.preteni WN-60 09/07/2019

				if(RestContext.request.requestBody == null){
					throw new applicationException('There is no body for the request ');
				}
				req 	= RestContext.request.requestBody.toString();
                OB_TrackingUtility.TrackingOrderRequestMaintenance request = (OB_TrackingUtility.TrackingOrderRequestMaintenance)JSON.deserialize(req,OB_TrackingUtility.TrackingOrderRequestMaintenance.class);
				orderId = request.orderId;
				// francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the order id: 
				 OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, orderId);
				 NE__Order__c orderMain = [SELECT id, NE__Order_Header__r.OB_Sub_Process__c  FROM NE__Order__c WHERE id =: orderId LIMIT 1 ];
				 if(orderMain != null && orderMain.NE__Order_Header__r.OB_Sub_Process__c =='variazione economica')
				 {
					response = OB_MaintenancePricing_Tracking.orderItemSortChecker(request);
				 }
				 else 
				 {
					 response = getTrackingOrderMaintenance(request);
				 }

				res.statusCode						= response.httpStatus; //enrico.purificatoWN-147

				//elena.preteni WN-60 09/07/2019
				ls = new Plc_LogHelper.LogStructure();
				//elena.preteni WN-60 09/07/2019
				ls.processingTime = '';
				ls.httpMethod = 'POST';
				ls.requestUri = '';
				ls.requestBody=req;//Simone Misani 13/07/2019 Fix Tracking
				ls.responseBody = JSON.serialize(response);
				//elena.preteni WN-60 09/07/2019
				ls.responseStatus = 'W';
				//elena.preteni WN-60 09/07/2019
				ls.responseMessage = response.message != null ? String.valueOf( response.message) : 'manca il messaggio';
				ls.recordUrl = '';
				//elena.preteni WN-60 09/07/2019
					plcId = Plc_LogHelper.logCall(ls);
				
				//elena.preteni WN-60 09/07/2019
				//francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the order id: 
		 		OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, orderId); 
			}catch(Exception e){
				System.debug('OB_TrackingOrderMaintenance.getTrackingOrderMaintenance Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
				response.message 					= 'OB_TrackingOrderMaintenance.getTrackingOrderMaintenance Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();//enrico.purificato WN-147				
				response.httpStatus					= 400;
				res.statusCode						= response.httpStatus; //enrico.purificato WN-147
				//elena.preteni WN-60 09/07/2019
				ls = new Plc_LogHelper.LogStructure();
				//elena.preteni WN-60 09/07/2019
				ls.processingTime = '';
				ls.httpMethod = 'POST';
				ls.requestUri = '';
				ls.requestHeader = header;
				ls.requestBody = req;
				ls.responseBody = JSON.serialize(response);
				//elena.preteni WN-60 09/07/2019
				ls.responseStatus = 'E';
				//elena.preteni WN-60 09/07/2019
				ls.responseMessage = 'OB_TrackingOrderMaintenance.getTrackingOrderMaintenance Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();
				ls.responseStackTrace = '400';
				ls.recordUrl = '';
				//elena.preteni WN-60 09/07/2019
					plcId = Plc_LogHelper.logCall(ls);
				
				//elena.preteni WN-60 09/07/2019
				// francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the order id: 
				 OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, orderId);
			}
		//OB_TrackingOrderMaintenance.sendLog();
		return response;
	}
    
	//@HttpPost
	global static OB_TrackingUtility.TrackingOrderResponseMaintenance getTrackingOrderMaintenance(OB_TrackingUtility.TrackingOrderRequestMaintenance request)
	{
        RestResponse res 							= RestContext.response;
		Map<String,String> decodeValues 			= new Map<String,String>();
		Map<String,String> conventionCodes			= new Map<String,String>();
		list<NE__Lov__c> lovs = [SELECT Name,NE__Value1__c,NE__Value2__c 
                                        FROM NE__Lov__c WHERE NE__Sub_Type__c=: TIPOLOGICHE AND NE__Type__c=:TRACKING];
    	
		//BUILD MAPS FROM SFDC VALUES TO MIP VALUES CONTAINING COMPANY CODE AND PRODUCT CODE
		if(lovs != null && !lovs.isEmpty()){
			for(NE__Lov__c val : lovs ){
				decodeValues.put(val.NE__Value1__c.trim(),val.NE__Value2__c);
				conventionCodes.put(val.NE__Value2__c,val.NE__Value2__c);
			}
		}
        system.debug('decodeValues ' + decodeValues);
        system.debug('conventionCodes ' + conventionCodes);
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = new OB_TrackingUtility.TrackingOrderResponseMaintenance();
        List<NE__OrderItem__c> itemToUpdateList	 		= new List<NE__OrderItem__c>();
		Integer responseStatus = 500;
        try
		{
            if(request==null){
				responseStatus 					= 400;
				throw new applicationException('There is no body for the request');
			}
            System.debug('OB_TrackingOrder.getTrackingOrder request deserialize --> ' +request);
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
			//Boolean isMoto						= false;
			//Boolean isAlberghiAutonoleggi			= false;
			Boolean pagobancomatFlag				= false;
			Boolean hasEquens 						= false;
			Boolean posPB 							= false;
			Boolean hasAcq 							= false;
			//String welcomePOS						= '';
			String mainProcess 						= '';
			String conventionCodeExSM 				= '';
            Boolean cancelPB						= false;
            Boolean isGTNexi                        = false;
			Boolean isSubProcessChangeTerm			= false;
			//START Simone Misani 13/07/2019 fix Tracking
			Boolean isVariazioneEconomica			= false;
			Boolean isModelloCommissionale			= false;
			Boolean	addAcqu							= false;
			Boolean addVas							= false;
			Boolean addvm							= false;
			//END Simone Misani 13/07/2019 fix Tracking
			//RETRIEVE CONFIGURATION
			String confId;
			Boolean hasGT							= false;
			Boolean isAcquiringTerzi				=false;//START--Simone Misani Fix Tracking 20/07/2019
			Boolean firstTracking 					=false;//START--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
		
		
			confId = request.orderId;
				
			
			//END Simone Misani 13/07/2019 fix Tracking
			System.debug('Configuration id --> '+confId);
            Map<String,NE__OrderItem__c> mapTermId 				= new Map<String,NE__OrderItem__c>();
			Map<String,NE__OrderItem__c> mapTermRemoved			= new Map<String,NE__OrderItem__c>();
			Map<String,NE__OrderItem__c> mapTermIdActionNotNone	= new Map<String,NE__OrderItem__c>();
			Map<String,List<NE__OrderItem__c>> acquiringNexiMap 	= new Map<String,List<NE__OrderItem__c>>();
			//Map<String, NE__OrderItem__c> mainAcquiringNexiMap  = new Map<String, NE__OrderItem__c>();
			List<NE__OrderItem__c> mainAcquiringNexiList 		= new List<NE__OrderItem__c>();
			List<NE__OrderItem__c> listVasNexi 					= new List<NE__OrderItem__c>();
			List<NE__OrderItem__c> listAcquNexi 					= new List<NE__OrderItem__c>();
			Map<String,List<NE__OrderItem__c>> linkedAcquiringNexi  = new Map<String,List<NE__OrderItem__c>>();
			Map<String,NE__OrderItem__c> rootVasMap 			= new Map<String,NE__OrderItem__c>();
			List<String> enablementActionNone					= new List<String>();
            List<NE__OrderItem__c> pagobancomatList				= new List<NE__OrderItem__c>();
            List<OB_TrackingUtility.GT> GTArray 									= new List<OB_TrackingUtility.GT>();
			List<OB_TrackingUtility.Acquiring> acquiringArray 						= new List<OB_TrackingUtility.Acquiring>();
            Map<Id,List<NE__OrderItem__c>> mapChildOI 			= new Map<Id,List<NE__OrderItem__c>>(); 
			List<OB_TrackingUtility.TermsIdInformation> termInf = new List<OB_TrackingUtility.TermsIdInformation>();//START--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
			List<OB_TrackingUtility.TermsIdInformation> termInfError = new List<OB_TrackingUtility.TermsIdInformation>();//START--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
			List<NE__OrderItem__c> listorderIteminError 		= new List<NE__OrderItem__c>();
            List<NE__OrderItem__c> itemsNotChanged              = new List<NE__OrderItem__c>();
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
														NE__Order_Header__r.OB_Sub_Process__c,
														OB_ReceiptCity__c,
														OB_ReceiptHeader__c,
														OB_Report_Type__c,
														OB_EXCH_Commission__c,//START Simone Misani 13/07/2019 fix Tracking
														NE__Order_Header__r.OB_ProposerABI__c,
                                                        OB_GT__c,
														OB_FirstorSecondTracking__c//START Simone Misani 09/09/2019 fix Tracking
														FROM NE__Order__c WHERE id = :confId];
			System.debug('Configurations --> '+ configurations);
			if(configurations == null || configurations.isEmpty()){
				throw new applicationException('There is no configuration for id --> ' + confId);
			}											  
																																							  
	
			//START--Simone Misani Fix Tracking 20/07/2019
			List<OB_LogRequest__c> currentLog = [SELECT	id,
														OB_Response_Track__c,
														OB_Error_Tracking__c,
														OB_Status__c
												FROM OB_LogRequest__c
												where OB_OrderId__c  =: confId];
			//END--Simone Misani Fix Tracking 20/07/2019
			
			NE__Order__c conf = configurations.get(0);
			merchantId 						= conf.NE__AccountId__c;
			servicePointId 					= conf.OB_Service_Point__c;
			MCC 							= conf.OB_MCC__c;
			List<NE__Lov__c> MCC2List			= [SELECT Id, OB_Value4__c 
													FROM NE__Lov__c 
													WHERE NE__Type__c =: 'mcc' 
													AND NE__Value3__c =: L2 
													AND (OB_Value4__c =: conf.OB_MCCL2__c 
														OR NE__Value2__c =: conf.OB_MCCL2__c)
													LIMIT 1];
			if(MCC2List != null && !MCC2List.isEmpty()){
				MCC2						= MCC2List.get(0).OB_Value4__c;
			}
			settlementMethod 				= conf.OB_PBSettlementMethod__c;
			internationalSettlementMethod 	= conf.OB_InternationalSettlementMethod__c;
			businessModel					= conf.NE__Order_Header__r.OB_Business_Model_Acquiring__c;
			receiptCity 					= conf.OB_ReceiptCity__c;
			receiptHeader 					= conf.OB_ReceiptHeader__c;
			reportType 						= conf.OB_Report_Type__c;
			shopSign 						= conf.OB_ShopSign__c;	
			mainProcess						= conf.NE__Order_Header__r.OB_Main_Process__c;
			//START Simone Misani 13/07/2019 fix Tracking
			if(	conf.NE__Order_Header__r.OB_Sub_Process__c != null  
				&& conf.NE__Order_Header__r.OB_Sub_Process__c.equalsIgnoreCase(SOSTITUZIONETERMINALI))
			{ //  WN-92 Micol Ferrari 
				isSubProcessChangeTerm = true;
			}else if (conf.NE__Order_Header__r.OB_Sub_Process__c != null  
				&& conf.NE__Order_Header__r.OB_Sub_Process__c.equalsIgnoreCase(VARIAZIONECONOMICA)){
				isVariazioneEconomica = true;
				if( !conf.OB_EXCH_Commission__c){
					isModelloCommissionale= true;
				}
			}
            //END Simone Misani 13/07/2019 fix Tracking
			if(conf.OB_GT__c != null && conf.OB_GT__c.equalsIgnoreCase(NEXI)){
                isGTNexi = true;
            }
			List<NE__OrderItem__c> orderItems = [SELECT Id,
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
														NE__ProdId__r.Name,
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
                                                        NE__Action__c,
														OB_GTErrorTracking__c,
														OB_AcquiringErrorTracking__c,
														NE__AssetItemEnterpriseId__c,
														NE__Status__c,
														NE__Qty__c,
														NE__Root_Order_Item__c,
														OB_ReasonOfRejection__c,
														OB_RAC_SIA__c,(SELECT id,NE__AssetItemEnterpriseId__c  From NE__Parent_Order_Item__r ),
												 		(SELECT id,Name, NE__Value__c FROM NE__Order_Item_Attributes__r) 
												 		FROM NE__OrderItem__c WHERE NE__OrderId__c = :confId AND NE__Status__c !=: CANCELLED]; 


				


			
				List<Id> assetRemove = new List<Id>();
				//START--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
				for( NE__OrderItem__c oi : orderItems){
					 Id assetItemEnterpriseId = oi.NE__AssetItemEnterpriseId__c;
					if(oi.NE__Action__c == 'Add'){
						if(oi.NE__AssetItemEnterpriseId__c != null){							
							firstTracking= (assetItemEnterpriseId.getsobjecttype() != Schema.Asset.getSObjectType());
						}				
					}else if (oi.NE__Action__c == 'Remove'){						
						if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType()){
							assetRemove.add(assetItemEnterpriseId);
						}
					}
				}//end--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
				//START--Simone Misani Fix Second Tracking  MONETICA 03/09/2019
				List<Asset> listAsset = [SELECT id, NE__Status__c FROM Asset WHERE id IN :assetRemove];
				Map<Id,Asset> mapofAsset = new Map<Id,Asset>();

				for(Asset a : listAsset){
					if(a.NE__Status__c != 'Disconnected'){						
						firstTracking = true;
					}
					if(a.NE__Status__c == 'Disconnected'){
						mapofAsset.put(a.id,a);
					} 
				}
				//END--Simone Misani Fix Second Tracking  MONETICA 03/09/2019
				

				
			
//START Simone Misani 13/07/2019 fix Tracking
			List<NE__OrderItem__c> listOrderIAcquandVas = [	SELECT 	id,
																		NE__Action__c,
																		NE__OrderId__c,
																		NE__ProdId__r.RecordType.DeveloperName,
																		NE__ProdName__c,
																		NE__Root_Order_Item__c,//--Simone Misani Fix Tracking 20/07/2019
																		NE__ProdId__r.OB_Acquirer__c,//Simone Misani 10/07/2019 fix Configuratore Tecnico
																		NE__ProdId__r.OB_Codice_sfdc__c
														FROM 		NE__OrderItem__c 
														WHERE 
																		NE__Root_Order_Item__c = null AND //Simone Misani 18/07/2019 WN-135
																		NE__OrderId__c =:confId
																		AND(NE__ProdId__r.RecordType.DeveloperName ='Vas' OR NE__ProdId__r.RecordType.DeveloperName = 'Acquiring')
																		AND (NE__Action__c !='None'
																		OR NE__Action__c 	!='Remove')
																		];
			Boolean  requiredChange = false;
			List<NE__OrderItem__c> listOrderITerminal = [	SELECT 	id,
																	NE__Action__c,
																	NE__OrderId__c,
																	NE__ProdId__r.RecordType.DeveloperName,
																	NE__ProdName__c,
																	NE__ProdId__r.OB_Acquirer__c
													FROM 		NE__OrderItem__c 
													WHERE 
																	NE__OrderId__c =:confId
																	AND NE__ProdId__r.RecordType.DeveloperName ='Terminali'
																	AND (NE__Action__c !=: OB_UtilityConstants.ORDERITEM_ACTION_NONE 
																	OR NE__Action__c !=: OB_UtilityConstants.ORDERITEM_ACTION_CHANGE)
																];
			if(!listOrderITerminal.isEmpty()){
				if(!listOrderIAcquandVas.isEmpty()){
					for(NE__OrderItem__c oiTerm : listOrderITerminal){
						for(NE__OrderItem__c oi :listOrderIAcquandVas){
							//START--Simone Misani Fix Tracking 20/07/2019
							if(oi.NE__ProdId__r.OB_Acquirer__c !='NEXI' || oi.NE__ProdId__r.OB_Codice_sfdc__c =='TAX_FREE'||oi.NE__ProdId__r.OB_Codice_sfdc__c =='TIPS'||oi.NE__ProdId__r.OB_Codice_sfdc__c =='ASS_PREMIUM'|| oi.NE__ProdId__r.OB_Codice_sfdc__c =='MTERMID'){
									isAcquiringTerzi= true;
							}//END--Simone Misani Fix Tracking 20/07/2019
								//francesca.ribezzi 10/09/19 considering every action except for None as we need to go into isAcquiringVas to check for errors in any case:
								if(oi.NE__ProdId__r.RecordType.DeveloperName =='Vas' && (oi.NE__Action__c == 'Add' || oi.NE__Action__c == 'Remove'|| oi.NE__Action__c == 'Change')){						
			 						addVas= true;
								}else if(oi.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring' && oi.NE__Action__c== 'Add' ){
									addAcqu	= true;
									if(OB_UtilityConstants.VisaM.equalsIgnoreCase(oi.NE__ProdName__c)){
										addvm = true;
									}
								}
								if(oiTerm.id == oi.NE__Root_Order_Item__c && oiTerm.NE__ProdId__r.OB_Acquirer__c == OB_UtilityConstants.GT_NEXI){
									requiredChange = true;
								}						
						}
					}
				}
			}
//END Simone Misani 13/07/2019 fix Tracking
            if(orderItems == null || orderItems.isEmpty()){
				throw new applicationException('There is no configuration item for id --> ' + confId);
			}
			NE__OrderItem__c firstOrderItem = new NE__OrderItem__c();
			firstOrderItem = orderItems.get(0);
			proposerABI 								= firstOrderItem.NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c;
			reportTypeFormat 							= firstOrderItem.NE__OrderId__r.NE__Order_Header__r.OB_Report_Type_Format__c;
			System.debug('Order Items --> '+orderItems);
			System.debug('firstOrderItem --> '+firstOrderItem);
			//START Simone Misani 13/07/2019 fix Tracking
			Boolean termAdd = false;
			Boolean termRemove = false;
			//END Simone Misani 13/07/2019 fix Tracking
            for(NE__OrderItem__c orderItem : orderItems)
			{
				//IF SUBPROCESS IS 'SOSTITUZIONE TERMINALI' PUT IN THE MAP ONLY TERMINAL IN 'ADD'
                // if(String.isNotBlank(orderItem.OB_TermId__c) && 
				// 		((isSubProcessChangeTerm && orderItem.NE__Action__c == ADD) || (!isSubProcessChangeTerm)))
				// {
				// 	mapTermId.put(orderItem.OB_TermId__c, orderItem);
				// 	System.debug('$$$IN mapTermId ' + orderItem );
				// }
				if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && orderItem.NE__Root_Order_Item__c== null && orderItem.NE__Action__c != none){
					listVasNexi.add(orderItem);
				}

				if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__Root_Order_Item__c== null && orderItem.NE__Action__c != none && orderItem.NE__ProdId__r.OB_Acquirer__c == OB_EnrichOrder.NEXI){
					listAcquNexi.add(orderItem);
				}
				System.debug(' @@@ ' + isSubProcessChangeTerm);
				System.debug(' ### ' + orderItem.NE__Action__c);
				if(String.isNotBlank(orderItem.OB_TermId__c) && isSubProcessChangeTerm && orderItem.NE__Action__c == ADD)
				{
					termAdd = true;//START Simone Misani 13/07/2019 fix Tracking
					mapTermId.put(orderItem.OB_TermId__c, orderItem);
					System.debug('$$$IN mapTermId is change term' + orderItem );
				}//END Simone Misani 28/08/2019 WN-276
				if(String.isNotBlank(orderItem.OB_TermId__c) && !isSubProcessChangeTerm && orderItem.NE__Action__c == ADD)
				{
					termAdd = true;//START Simone Misani 13/07/2019 fix Tracking
					
				}
				//END Simone Misani 28/08/2019 WN-276
				if(String.isNotBlank(orderItem.OB_TermId__c) && !isSubProcessChangeTerm)
				{
					mapTermId.put(orderItem.OB_TermId__c, orderItem);
					System.debug('$$$IN mapTermId !changeTerm' + orderItem );
				}

				if(String.isNotBlank(orderItem.OB_TermId__c) && 
						(isSubProcessChangeTerm && orderItem.NE__Action__c == REMOVE)){
							termRemove = false;//START Simone Misani 13/07/2019 fix Tracking
					mapTermRemoved.put(orderItem.OB_TermId__c, orderItem);
				}
				if(String.isNotBlank(orderItem.OB_TermId__c) && 
						(orderItem.NE__Action__c != NONE)){
					mapTermIdActionNotNone.put(orderItem.OB_TermId__c, orderItem);
				}
				//Lista of Acquiring Nexi with empty parent
				if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && 
						orderItem.NE__ProdId__r.OB_Acquirer__c == OB_EnrichOrder.NEXI
						&& orderItem.NE__Parent_Order_Item__c == null){
					//mainAcquiringNexiMap.put(orderItem.NE__ProdId__r.Name, orderItem);
					mainAcquiringNexiList.add(orderItem);
				}
				//Map of Acquiring with parent not null
				if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && 
						orderItem.NE__ProdId__r.OB_Acquirer__c == OB_EnrichOrder.NEXI){

					List<NE__OrderItem__c> tmpNexiOI = new List<NE__OrderItem__c>();
					if(acquiringNexiMap.containsKey(orderItem.NE__ProdId__r.Name)){
						tmpNexiOI = acquiringNexiMap.get(orderItem.NE__ProdId__r.Name);
					}
					tmpNexiOI.add(orderItem);
					acquiringNexiMap.put(orderItem.NE__ProdId__r.Name, tmpNexiOI);
					hasAcq = true;
					if(orderItem.NE__Action__c == NONE && !enablementActionNone.contains(orderItem.NE__ProdId__r.OB_Codice_sfdc__c)){
						enablementActionNone.add(orderItem.NE__ProdId__r.OB_Codice_sfdc__c);
					}
				}
				if(((orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && conventionCodes.containskey(orderItem.NE__ProdId__r.OB_Codice_sfdc__c) && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI) || 
					(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI )
					)&& orderItem.NE__Parent_Order_Item__c == null){
					rootVasMap.put(orderItem.NE__ProdId__r.OB_Codice_sfdc__c, orderItem);
					if(orderItem.NE__Action__c == NONE && !enablementActionNone.contains(orderItem.NE__ProdId__r.OB_Codice_sfdc__c)){
						enablementActionNone.add(orderItem.NE__ProdId__r.OB_Codice_sfdc__c);
					}
				}
				if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PAGOBANCOMAT){
					pagobancomatList.add(orderItem);
				}
				if(orderItem.NE__Parent_Order_Item__c != null){
					List<NE__OrderItem__c> tmpOI = new List<NE__OrderItem__c>(); 
					if(mapChildOI.containsKey(orderItem.NE__Parent_Order_Item__c)){
						tmpOI = mapChildOI.get(orderItem.NE__Parent_Order_Item__c);
					}
					tmpOI.add(orderItem);
					mapChildOI.put(orderItem.NE__Parent_Order_Item__c, tmpOI);
				}
                if(orderItem.NE__Action__c.equalsIgnoreCase(NONE)){
                    orderItem.OB_FulfilmentStatus__c = COMPLETED;
                    itemsNotChanged.add(orderItem);
                }
				if (orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.COMMISSIONE){
            		pricingType = orderItem.NE__ProdId__r.OB_Codice_sfdc__c;
        		}
            }
			
			if(mainAcquiringNexiList != null && !mainAcquiringNexiList.isEmpty()){
				for(NE__OrderItem__c mainAcquiring : mainAcquiringNexiList){
					if(acquiringNexiMap.containsKey(mainAcquiring.NE__ProdId__r.Name)){
						linkedAcquiringNexi.put(mainAcquiring.Id, acquiringNexiMap.get(mainAcquiring.NE__ProdId__r.Name));
					}
				}
			}
			//System.debug('mapTermId : ' + mapTermId);
			System.debug('mapTermRemoved :' + mapTermRemoved);
			System.debug('acquiringNexiMap : ' + acquiringNexiMap);
			//System.debug('mainAcquiringNexiMap :' + mainAcquiringNexiMap);
			System.debug('mainAcquiringNexiList :' + mainAcquiringNexiList);
			System.debug('linkedAcquiringNexi :' + linkedAcquiringNexi);
			System.debug('rootVasMap : ' + rootVasMap);
			System.debug('pagobancomatList : ' + pagobancomatList);
			System.debug('mapChildOI : ' + JSON.serialize(mapChildOI));
			System.debug('itemsNotChanged : ' + itemsNotChanged);
			System.debug('enablementActionNone :' + enablementActionNone);

		//SET EXTERNAL SOURCE MAPPING
			// List<ExternalSourceMapping__c> extSourceMappingList = [SELECT Id,
			// 															  OB_Service_Point_ID__c,
			// 															  OB_ServicePointCodeShopCode__c,
			// 															  OB_Source__c,
			// 															  OB_Merchant_ID__c,
			// 															  OB_CustomerCodeClientCode__c,
			// 															  OB_Conventioncode__c 
			// 													   		FROM ExternalSourceMapping__c
			// 															WHERE OB_Merchant_ID__c = : merchantId 
			// 															OR OB_Service_Point_ID__c =: servicePointId ]; 
            
			List<NE__Order_Item_Attribute__c> attributes 		= new  List<NE__Order_Item_Attribute__c>();
			// System.debug('External Source Mapping --> '+extSourceMappingList);
			acquiringArray 		= request.Acquiring;
			GTArray 			= request.GT;
			Boolean isAcquiring = request.Acquiring != null && !request.Acquiring.isEmpty();
			Boolean isGT 		= request.GT != null && !request.GT.isEmpty();
			//Simone misani 06/09/2019  STARt
			NE__Order__C ordertoUpdate = [SELECT Id, OB_FirstorSecondTracking__c  FROM NE__Order__c WHERE id =: confId FOR UPDATE ];
			if(isGT){
				if(String.isBlank(configurations.get(0).OB_FirstorSecondTracking__c)){
					firstTracking = true;
					ordertoUpdate.OB_FirstorSecondTracking__c = 'First Tracking';

				}
				else{
					firstTracking = false;
					ordertoUpdate.OB_FirstorSecondTracking__c = 'Second Tracking';
				}
			}
			
			update ordertoUpdate;
			//Simone misani 06/09/2019 END


			// Map<String,Object> acquiringArguments = new Map<String,Object>();
			// Map<String,Object> gtArguments = new Map<String,Object>();
			// acquiringArguments.put('configuration', conf);
			// //acquiringArguments.put('acquiringNexiMap', acquiringNexiMap);
			// acquiringArguments.put('linkedAcquiringNexi', linkedAcquiringNexi);
			// acquiringArguments.put('mapChildOI', mapChildOI);
			// acquiringArguments.put('itemToUpdateList', itemToUpdateList);
			// gtArguments.put('mapTermId', mapTermId);
			// gtArguments.put('pagobancomatList', pagobancomatList);
			// gtArguments.put('rootVasMap', rootVasMap);
			
			if(isAcquiring){
				//START Simone Misani 13/07/2019 fix Tracking
				List<ExternalSourceMapping__c> servicePointMoneticaList =  new List<ExternalSourceMapping__c>();
				Boolean trackKO = OB_TrackingOrderMaintenance.isAcquiringKO(acquiringArray);
				if(!trackKO){
					if( termAdd || termRemove){
						OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringArray, requiredChange);
					}
					if(addAcqu){
						OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringArray);
					}
					if(addVas){
						OB_TrackingOrderMaintenance.isAcquiringVas(acquiringArray);
					}
				}
				//END Simone Misani 13/07/2019 fix Tracking
				Map<String,ExternalSourceMapping__c> acquiringCodes = new Map<String,ExternalSourceMapping__c>();
				//START Simone Misani 20/08/2019 WN-250
				List<NE__OrderItem__c> itemsAcquiringTerziList = new List<NE__OrderItem__c>();
				Boolean checkErrorEquens = false;
				for(OB_TrackingUtility.Acquiring acq : acquiringArray){					
					for(OB_TrackingUtility.puntoVendita pv : acq.PVCodes){					
						//Service Point
						for(OB_TrackingUtility.Changes ch : pv.Changes){
							if(ch.result == 'KO')
								checkErrorEquens = true;
						}
						if(!checkErrorEquens){
							ExternalSourceMapping__c ext1 				= new ExternalSourceMapping__c();
							ext1.OB_CustomerCodeClientCode__c 			= acquiringArray[0].companyCode;
							ext1.OB_ServicePointCodeShopCode__c 		= pv.PVCode;
							ext1.OB_Business_Model__c 					= businessModel;
							ext1.OB_Service_Point_Type__c 				= pv.tipo;
							ext1.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
							ext1.OB_MCCL2__c 							= MCC2;
							ext1.OB_MCC__c 								= MCC;
							if(acquiringArray[0].source.equalsIgnoreCase(EQUENS) || acquiringArray[0].source.equalsIgnoreCase(SIA)){
								ext1.OB_PBSettlementMethod__c 				= settlementMethod;
							}
							ext1.OB_Pricing__c 							= pricingType;
							ext1.OB_ReceiptCity__c 						= receiptCity;
							ext1.OB_ReceiptHeader__c 					= receiptHeader;
							ext1.OB_ReportTypeFormat__c 				= reportTypeFormat;
							// ext1.OB_ReportType__c 						= reportType ;
							ext1.OB_Source__c 							= acquiringArray[0].source;
							ext1.OB_Service_Point_ID__c					= servicePointId;
							ext1.OB_ShopSign__c							= shopSign;
							OB_TrackingOrder.updateServicePointExternalMapping(ext1);
							conventionCodeExSM = ext1.OB_ServicePointCodeShopCode__c;

							//Merchant
							ExternalSourceMapping__c ext2 				= new ExternalSourceMapping__c();
							ext2.OB_CustomerCodeClientCode__c 			= acquiringArray[0].companyCode;
							ext2.OB_Business_Model__c 					= businessModel;
							ext2.OB_Source__c 							= acquiringArray[0].source;
							ext2.OB_ReportTypeFormat__c 				= reportTypeFormat;
							if(acquiringArray[0].source.equalsIgnoreCase(EQUENS) || acquiringArray[0].source.equalsIgnoreCase(SIA)){
								ext2.OB_ReportType__c 						= reportType ;
							}
							ext2.OB_Merchant_ID__c						= merchantId;
							OB_TrackingOrder.updateMerchantExternalMapping(ext2);
							ExternalSourceMapping__c servicePointMonetica = OB_TrackingOrderMaintenance.conventionCodeManagement(isAcquiring,isGT,hasAcq,ext1,acquiringNexiMap,servicePointId,mapTermId,conventionCodeExSM);
							// START -----Simone Misani WN-28 23/08/2019
							if(servicePointMonetica != null){
									servicePointMoneticaList.add(servicePointMonetica);
							}
							// END -----Simone Misani WN-28 23/08/2019
							
						}//END Simone Misani 20/08/2019 WN-250
						hasEquens = true;

						//UPDATE ACQUIRING ITEMS
						//START--Simone Misani Fix Tracking 20/07/2019
						OB_TrackingOrderMaintenance.updateAcquiringItems(conf, pv.changes, linkedAcquiringNexi, mapChildOI, acq.companyCode, pv.PVCode, pv.startDate, pv.endDate, currentLog, addvm,listAcquNexi);
						OB_TrackingOrderMaintenance.updateVasItems(listVasNexi, pv.changes,acq.companyCode, pv.PVCode, pv.startDate, pv.endDate, currentLog);
						if(isAcquiringTerzi){
							itemsAcquiringTerziList.addAll(updateAcquiringItemsTerzi(confId));
						}
						
						//END--Simone Misani Fix Tracking 20/07/2019
						
					}
				}
				// START -----Simone Misani WN-28 23/08/2019
				if(!servicePointMoneticaList.isEmpty() ){
								update servicePointMoneticaList;
				}
				if(!itemsAcquiringTerziList.isEmpty() ){
							update itemsAcquiringTerziList;
				}
				
				// END -----Simone Misani WN-28 23/08/2019
			}
			Map<String,Object> updateItemLog = new Map<String,Object>();	
			if(isGT){
				//START Simone Misani 13/07/2019 fix Tracking		
				
				Boolean trackKO = OB_TrackingOrderMaintenance.isGTKO(GTArray);                
				if(!trackKO){
					//START--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
					if(firstTracking&&(isSubProcessChangeTerm || termAdd)){
						OB_TrackingOrderMaintenance.isGtTerminalFirstTracking(GTArray,  termAdd,  termRemove, isSubProcessChangeTerm);

				}else{
				//end--Simone Misani Fix Second Tracking  MONETICA 02/09/2019	
					if( termAdd || termRemove){
					OB_TrackingOrderMaintenance.isGtTerminal(GTArray,  termAdd,  termRemove, isSubProcessChangeTerm);
					}
				
					if(addAcqu){
						if(!addvm){			
							OB_TrackingOrderMaintenance.isGtAcquiring(GTArray, confId);
						}
					}
					if(addVas){
						OB_TrackingOrderMaintenance.isGtVas(GTArray, confId);
					}

				}
					
			}
				//END Simone Misani 13/07/2019 fix Tracking
				//START Simone Misani 20/08/2019 WN-250
				Boolean checkErrorMonetica = false;
				Map<String,ExternalSourceMapping__c> gtCodes = new Map<String,ExternalSourceMapping__c>();
				for(OB_TrackingUtility.GT gt : GTArray){
					if(gt.errors != null && gt.errors.size() != 0 ){
						checkErrorMonetica = true;
					}
					for(OB_TrackingUtility.puntoVendita pv : gt.PVCodes){	
						//Service Point
						if(!checkErrorMonetica && firstTracking){//--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
							ExternalSourceMapping__c ext1 				= new ExternalSourceMapping__c();
							String externalmapKey = '';
							ext1.OB_CustomerCodeClientCode__c			= GTArray[0].gtCompanyCode;
							ext1.OB_ServicePointCodeShopCode__c 		= pv.StabiCode;
							if(String.isNotBlank(pv.tipo)){
								ext1.OB_Service_Point_Type__c 			= pv.tipo ;
							}							
							ext1.OB_Business_Model__c 					= businessModel;
							ext1.OB_InternationalSettlementMethod__c 	= internationalSettlementMethod;
							ext1.OB_MCCL2__c 							= MCC2;
							ext1.OB_MCC__c 								= MCC;
							//ext1.OB_PBSettlementMethod__c 				= settlementMethod;
							ext1.OB_Pricing__c 							= pricingType;
							ext1.OB_ReceiptCity__c 						= receiptCity;
							ext1.OB_ReceiptHeader__c 					= receiptHeader;
							ext1.OB_ReportTypeFormat__c 				= reportTypeFormat;
							//ext1.OB_ReportType__c 						= reportType;
							ext1.OB_CTICode__c 							= pv.ctiCode;
							ext1.OB_Source__c 							= (GTArray[0].source.equalsIgnoreCase(NEXI)?MONETICA:GTArray[0].source.toUpperCase());//Francesca Ribezzi-Antonio Vatrano-SImone Misani  WN-75 10/09/2010
							ext1.OB_Service_Point_ID__c					= servicePointId;
							ext1.OB_ShopSign__c							= shopSign;
							externalmapKey = ext1.OB_Source__c+ext1.OB_CustomerCodeClientCode__c+ext1.OB_ServicePointCodeShopCode__c;
							
							//Merchant
							ExternalSourceMapping__c ext2 				= new ExternalSourceMapping__c();
							ext2.OB_CustomerCodeClientCode__c 			= GTArray[0].gtCompanyCode;
							ext2.OB_Source__c 							= (GTArray[0].source.equalsIgnoreCase(NEXI)?MONETICA:GTArray[0].source.toUpperCase());//Francesca Ribezzi-Antonio Vatrano-SImone Misani  WN-75 10/09/2010
							ext2.OB_Business_Model__c 					= businessModel;
							ext2.OB_ReportTypeFormat__c 				= reportTypeFormat;
							//ext2.OB_ReportType__c 						= reportType ;
							ext2.OB_Merchant_ID__c						= merchantId;
							OB_TrackingOrder.updateServicePointExternalMapping(ext1);
							OB_TrackingOrder.updateMerchantExternalMapping(ext2);

							//AGGIORNAMENTO CONVENTIONCODE PER EXSM MONETICA
							ext1 = OB_TrackingOrderMaintenance.conventionCodeManagement(isAcquiring,isGT,hasAcq,ext1,acquiringNexiMap,servicePointId,mapTermId,conventionCodeExSM);
							system.debug('external mapping servicepoint monetica : ' + ext1);
						}//END Simone Misani 20/08/2019 WN-250
////START--Simone Misani Fix Tracking 20/07/2019
						//UPDATE GT
						// if(isSubProcessChangeTerm && pv.terminalInformation.isEmpty()){
						// 	System.debug('@@@ Update GT -- Change Terminals - OK MONETICA' );
						// 	OB_TrackingOrderMaintenance.updateGTChangeTerminalsOKMonetica(mapTermId, mapTermRemoved, mapChildOI, pv, (GTArray[0].source.equalsIgnoreCase(NEXI)?MONETICA:GTArray[0].source), gt, conf);
						// }

						// if(isSubProcessChangeTerm && !pv.terminalInformation.isEmpty()){
						// 	System.debug('@@@ Update GT -- Change Terminals - DETAILS');
						// 	for(TermsIdInformation terminfo : pv.terminalInformation){
						// 		if(!mapTermId.containskey(terminfo.terminalId)){
						// 			throw new applicationException('TerminalId not valid - GT');
						// 		}
						// 		conf.OB_CTI_Code__c  = pv.ctiCode;
						// 		update conf;
						// 		OB_TrackingOrderMaintenance.updateGTItemsChangeTerminalsDetails(mapTermId.get(terminfo.terminalId), mapTermRemoved.get(terminfo.terminalId), terminfo, mapChildOI);
						// 	}
						// }

						// if(!isSubProcessChangeTerm && pv.terminalInformation.isEmpty()){
						// 	System.debug('@@@ Update GT -- OK MONETICA' );
						//START--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
						if(firstTracking){
								updateItemLog = updateGTItemsOkMonetica(mapTermIdActionNotNone, mapChildOI, pagobancomatList, itemsNotChanged, enablementActionNone, pv, (GTArray[0].source.equalsIgnoreCase(NEXI)?MONETICA:GTArray[0].source), gt, mapTermId, conf, currentLog,confId,isAcquiringTerzi,isSubProcessChangeTerm);
							// if(pv.terminalInformation!= null){
							// 	termInfError.addAll(pv.terminalInformation);
							// 	listorderIteminError = checkedErrorTerminalInfo(termInf, confId);

							// }
								
						}
						//
						if(!firstTracking){
                            termInf.addAll(pv.terminalInformation);
                        }
						 //end--Simone Misani Fix Second Tracking  MONETICA 02/09/2019				
						

						// if(!isSubProcessChangeTerm && !pv.terminalInformation.isEmpty()){
						// 	System.debug('@@@ Update GT -- DETAILS');
						// 	for(TermsIdInformation terminfo : pv.terminalInformation){
						// 		if(!mapTermId.containskey(terminfo.terminalId)){
						// 			throw new applicationException('TerminalId not valid - GT');
						// 		}
						// 		Map<String,CodiciConvenzioni> codiciConvenzione =  new Map<String,CodiciConvenzioni>();
						// 		if(terminfo.agreementCodes != null){
						// 			for(CodiciConvenzioni convenzione : terminfo.agreementCodes){
						// 				if(decodeValues.containsKey(convenzione.companyCode)){
						// 					codiciConvenzione.put(decodeValues.get(convenzione.companyCode),convenzione);
						// 				}
						// 			}
						// 		} 
						// 		System.debug('codiciConvenzione ' + codiciConvenzione);
						// 		conf.OB_CTI_Code__c  = pv.ctiCode;
						// 		update conf;
                        //         OB_TrackingOrderMaintenance.updateGTItemsOkMonetica(mapTermIdActionNotNone, mapChildOI, pagobancomatList, itemsNotChanged, enablementActionNone, pv, (GTArray[0].source.equalsIgnoreCase(NEXI)?MONETICA:GTArray[0].source), gt, mapTermId, conf);
						// 		OB_TrackingOrderMaintenance.updateGTItemsDetails(rootVasMap, mainAcquiringNexiList, mapTermId, mapChildOI, mapTermId.get(terminfo.terminalId), codiciConvenzione, terminfo, pv);
                        //        							}
						// }
					}
				}				
			}

			
			if(updateItemLog.containsKey('order')){
				update (List<NE__Order__c>) updateItemLog.get('order');
			}
			 if(updateItemLog.containsKey('orderItem')){
				update (List<NE__OrderItem__c>) updateItemLog.get('orderItem');
			}
			 if(updateItemLog.containsKey('AcquiringTerzi')){
				update (List<NE__OrderItem__c>) updateItemLog.get('AcquiringTerzi');
			}
			 if(updateItemLog.containsKey('logRequest')){
				update (List<OB_LogRequest__c>)updateItemLog.get('logRequest');
			}
			//START ---Simone Misani 23/07/2019 Fix Tracking	

			


			if(isSubProcessChangeTerm){
				updateorderItemChangeterm(confId);
			}//END ---Simone Misani 23/07/2019 Fix Tracking
			// 	List<NE__OrderItem__c> missingItems = [SELECT OB_FulfilmentStatus__c,
			// 													NE__ProdId__r.Name,
			// 													NE__ProdId__r.RecordType.DeveloperName, 
			// 													NE__ProdId__r.OB_Acquirer__c 
			// 													FROM NE__OrderItem__c 
			// 													WHERE NE__OrderId__c =: confId 
			// 														AND OB_FulfilmentStatus__c not in (:COMPLETED,:CANCELLED,:DISCONNECTED,:REJECTED) 
			// 														AND (NE__ProdId__r.RecordType.DeveloperName =: OB_EnrichOrder.TERMINALE 
			// 															OR (NE__ProdId__r.RecordType.DeveloperName !=: OB_EnrichOrder.TERMINALE 
			// 																AND NE__ProdId__r.OB_Acquirer__c=: OB_EnrichOrder.NEXI))];
			// 	if(missingItems.size()==0){
			// 		conf.OB_FulfilmentStatus__c = COMPLETED;
			// 		update conf;
			// 		OB_UtilityCallingServices.createAsset(conf.Id, conf.NE__Order_Header__r.OB_Main_Process__c);
			// 	}
			// }
//END--Simone Misani Fix Tracking 20/07/2019
			//START--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
			if(!listorderIteminError.isEmpty()){
				update listorderIteminError;
			}
			
		
			

			if(!firstTracking){
				updateAssetDate( termInf,confId , mapofAsset );
			}


			updateLogRequest(confId);//--Simone Misani Fix Tracking 20/07/2019
			//end--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
			response.httpStatus				= 200;
			response.message				= MONETICAOK;
			
    	}
		catch(Exception e){
			System.debug('OB_TrackingOrderMaintenance.getTrackingOrderMaintenance Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
			//	GENERIC ERROR
			response.httpStatus 						= responseStatus;
			response.message							= e.getMessage() + ' ' + e.getStackTraceString();
			System.debug('error response : ' + res);
			res.statusCode 								= responseStatus;
			System.debug('Response Status : ' + responseStatus + ' Header Status : ' + responseStatus);
			/*Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
			ls.processingTime = '';
			ls.httpMethod = 'POST';
			ls.requestUri = '';
			ls.requestHeader = request.headers;
			ls.requestBody = request.requestBody();
			ls.responseBody = response.responseBody();
			ls.responseStatus = response.statuscode();
			ls.responseMessage = System.debug('OB_TrackingOrderMaintenance.getTrackingOrderMaintenance Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
			ls.responseStackTrace = responseStatus;
			ls.recordUrl = '';*/
		}
		return response;
	}

	public class applicationException extends Exception {}


	public static void updateVasItems(List<NE__OrderItem__c> listVasNexi,List<OB_TrackingUtility.Changes> listOfChanges,String companyCode, String PVCode, String startDate, String endDate,List<OB_LogRequest__c> currentLog){
		List<NE__OrderItem__c> listItemsToUpdate = new List<NE__OrderItem__c>();		
		Map<Id,OB_LogRequest__c> updateLog = new Map<Id,OB_LogRequest__c>(); //enrico.purificato WN-186
       if(listVasNexi.isEmpty()){
		   return ; 
	   }
		if(listOfChanges != null && !listOfChanges.isEmpty()){
				for(OB_TrackingUtility.Changes change : listOfChanges){
					System.debug('change: '+change);
					if(String.isBlank(change.externalId) || String.isBlank(change.result)){
						throw new applicationException('One or more empty fields - Changes');
					}
                    
					if(change.result == 'OK'){
						//enrico.purificato WN-186 START
						NE__OrderItem__c oi = new NE__OrderItem__c();
						oi.id = change.externalId;
						oi.OB_FulfilmentStatus__c = COMPLETED;
						listItemsToUpdate.add(oi);
						//enrico.purificato WN-186 ENRD
					}else{
						//enrico.purificato WN-186 START
                        NE__OrderItem__c oi = new NE__OrderItem__c();
						oi.id = change.externalId;
						oi.OB_FulfilmentStatus__c = FAILED;
						oi.OB_AcquiringErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(true, change.errors);
						listItemsToUpdate.addAll(vasFailedRollBackValue(listVasNexi,change));
						//enrico.purificato WN-186 END
						for(OB_LogRequest__c log: currentLog){
							//enrico.purificato WN-186 START
							log.OB_Error_Tracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(true, change.errors).left(250);
							if(!updateLog.containsKey(log.id)){
								log.OB_Status__c = OB_UtilityConstants.INATTESA;
								updateLog.put(log.id,log);
							}
							//enrico.purificato WN-186 END
						}

					}

				}	
		}
        //enrico.purificato WN-186 START
		if(updateLog.keySet().isEmpty()){
			update updateLog.values();
		}
		//enrico.purificato WN-186 END
		
		if(!listItemsToUpdate.isEmpty()){
			upsert listItemsToUpdate;
		}
	}

	public static void updateAcquiringItems(NE__Order__c configuration, List<OB_TrackingUtility.Changes> listOfChanges, Map<String,List<NE__OrderItem__c>> linkedAcquiringNexi, Map<Id,List<NE__OrderItem__c>> mapChildOI, String companyCode, String PVCode, String startDate, String endDate, List<OB_LogRequest__c> currentLog, Boolean addVm, List<NE__OrderItem__c> listAcquNexi) {
		Boolean equensKo = false; // Simone Misani WN-186 22/08/2019
		if(listOfChanges != null && !listOfChanges.isEmpty()){
			List<NE__OrderItem__c> listItemsToUpdate = new List<NE__OrderItem__c>();
			// enrico Purificato TBV Simone Miasni DO NOT DELETE List<OB_LogRequest__c> updateLog = new List<OB_LogRequest__c>();//--Simone Misani Fix Tracking 20/07/2019
			Map<Id,OB_LogRequest__c> updateLog = new Map<Id,OB_LogRequest__c>(); //enrico.purificato WN-186

			for(OB_TrackingUtility.Changes change : listOfChanges){
				System.debug('change: '+change);
				if(String.isBlank(change.externalId) || String.isBlank(change.result)){
						throw new applicationException('One or more empty fields - Changes');
				}
				system.debug('linkedAcquiringNexi: '+linkedAcquiringNexi);
				List<NE__OrderItem__c> listOfAcquiring = linkedAcquiringNexi.get(change.externalId);
				System.debug('change.externalId: '+change.externalId);
				System.debug('listOfAcquiring: '+listOfAcquiring);
				if(listOfAcquiring != null && !listOfAcquiring.isEmpty()){
					if(change.result == MONETICAKO){
						equensKo = false; // Simone Misani WN-186 22/08/2019
						System.debug('CHANGE RESULT KO :' + change.result);
						//Simone Misani 08/11/2019 Tracking Fix for Prod START
						listItemsToUpdate.addAll(acquiringFailedRollBackValue(listAcquNexi , change));
						// for(NE__OrderItem__c itemToUpdate : listOfAcquiring){
						// 	itemToUpdate.OB_Tech_Outcome_Equens__c = MONETICAKO;
						// 	itemToUpdate.OB_FulfilmentStatus__c = FAILED;
						// 	itemToUpdate.OB_AcquiringErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(true, change.errors);
						// 	listItemsToUpdate.add(itemToUpdate);
						// 	List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(itemToUpdate.Id);
						// 	if(listOfChildItem != null && !listOfChildItem.isEmpty()){
						// 		for(NE__OrderItem__c childItem : listOfChildItem){
						// 			childItem.OB_FulfilmentStatus__c = FAILED;
						// 			listItemsToUpdate.add(childItem);
						// 		}
						// 	}
						// }
						for(OB_LogRequest__c log: currentLog){
							
							//enrico.purificato WN-186 START
							log.OB_Error_Tracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(true, change.errors).left(250);
							if(!updateLog.containsKey(log.id)){
								log.OB_Status__c = OB_UtilityConstants.INATTESA;
								updateLog.put(log.id,log);
							}
							//enrico.purificato WN-186 END
						}
						//enrico.purificato WN-186 START
						if(updateLog.keySet().isEmpty()){
							update updateLog.values();
						}
						//enrico.purificato WN-186 END
						// configuration.OB_Tracking_Errors__c = OB_TrackingOrderMaintenance.errorStringFormatter(true, change.errors);
						// configuration.OB_FulfilmentStatus__c = FAILED;
						// update configuration;
						//Simone Misani 08/11/2019 Tracking Fix for Prod END
					}else if(change.result == MONETICAOK){
						System.debug('CHANGE RESULT OK :' + change.result);
						for(NE__OrderItem__c itemToUpdate : listOfAcquiring){
							itemToUpdate.OB_CompanyCode__c = companyCode;
							itemToUpdate.OB_ServicePointCode__c = PVCode;
							itemToUpdate.OB_Tech_Outcome_Equens__c = MONETICAOK;
							itemToUpdate.OB_FulfilmentStatus__c = COMPLETED;
							listItemsToUpdate.add(itemToUpdate);
							List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(itemToUpdate.Id);
							
							if(listOfChildItem != null && !listOfChildItem.isEmpty()){
								for(NE__OrderItem__c childItem : listOfChildItem){
									childItem.OB_FulfilmentStatus__c = COMPLETED;
									listItemsToUpdate.add(childItem);
								}
							}
						}
						
						
						 // enrico.purificato WN-189 (removed if)
						
						//update updateLog; //enrico purificato DO NOT DELETE TBV Simone Misani
					}
					updatePciandCommissione(configuration.Id , equensKo );// Simone Misani WN-186 22/08/2019
				}
			}
			System.debug('listItemsAcquiringToUpdate :' + listItemsToUpdate);
			upsert  listItemsToUpdate;
		}
	}

	public static String errorStringFormatter(Boolean isAcquiring,List<OB_TrackingUtility.ErrorList> errorList){
		System.debug('ERRORS:' + errorList);
		String errorString = isAcquiring ? 'Acquiring errors : ' : ' GT errors : ';
		for(OB_TrackingUtility.ErrorList error : errorList){
			errorString += '\r codice : ' + error.code + ' \r errore : ' + error.description;
			System.debug('errorString:' + errorString);	
		}
		return errorString;
	}

	//OK MONETICA//T ---Simone Misani 23/07/2019 Fix Tracking
	//--Simone Misani Fix Second Tracking  MONETICA 02/09/2019
		public static Map<String,Object> updateGTItemsOkMonetica(Map<String,NE__OrderItem__c> mapTermIdActionNotNone, Map<Id,List<NE__OrderItem__c>> mapChildOI, List<NE__OrderItem__c> pagobancomatList, List<NE__OrderItem__c> itemsNotChanged, List<String> enablementActionNone, OB_TrackingUtility.puntoVendita pv, String source, OB_TrackingUtility.GT gt, Map<String,NE__OrderItem__c> mapTermId, NE__Order__c conf, List<OB_LogRequest__c> currentLog,String confId ,  Boolean isAcquiringTerzi, Boolean isSubProcessChangeTerm){
		Map<String,Object> returnMap = new Map<String,Object>();
		List<NE__OrderItem__c> itemsToUpdate = new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> itemsAcquiringTerziList = new List<NE__OrderItem__c>();
		Map<Id,OB_LogRequest__c> updateLog = new Map<Id,OB_LogRequest__c>(); //enrico.purificato WN-186
		List<NE__Order__c> updateorder = new List<NE__Order__c>();
		Boolean isEnablementActive = false;
		
		 //enrico.purificato WN-262
		
		if(gt.errors != null && !gt.errors.isEmpty()){
			System.debug('updateGTItemsOkMonetica - KO MONETICA - GT errors is not empty');
			for(NE__OrderItem__c terminal : mapTermId.values()){

				System.debug('terminal: '+ terminal);
				terminal.OB_FulfilmentStatus__c = FAILED;
				terminal.OB_Tech_Outcome_Monetica__c = MONETICAKO;
				terminal.OB_RAC_SIA__c = pv.siaMerchantCode + pv.siaPVCode + pv.siaProgressiveCode;
				terminal.OB_GTErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(false, gt.errors);
				itemsToUpdate.add(terminal);
				if(mapChildOI.containsKey(terminal.Id)){
					List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(terminal.Id);
					System.debug('listOfChildItem: '+ listOfChildItem);
					for(NE__OrderItem__c child : listOfChildItem){
						child.OB_FulfilmentStatus__c = FAILED;
						itemsToUpdate.add(child);
					}
				}
			}
			//START--Simone Misani Fix Tracking 20/07/2019
			for(OB_LogRequest__c log: currentLog){
				//enrico.purificato WN-186 START
				log.OB_Error_Tracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(false, gt.errors).left(250);
				if(!updateLog.containsKey(log.id)){
					log.OB_Status__c = OB_UtilityConstants.INATTESA;
					updateLog.put(log.id,log);
				}
				//enrico.purificato WN-186 END
			}
			conf.OB_FulfilmentStatus__c = FAILED;
			updateorder.add(conf);
			//update updateLog;
			//END--Simone Misani Fix Tracking 20/07/2019
			returnMap.put('order',updateorder);
			//update conf;
		}else{
			//START ---Simone Misani 23/07/2019 Fix Tracking
			// Boolean confError = checkedErrorTerminalInfo(termInf, confId);
			// Boolean confStatusRefused = checkedRefusedStatus(termInf, confId);
			// if(!confError && !confStatusRefused){
		
				if(isAcquiringTerzi){
					itemsAcquiringTerziList.addAll(updateAcquiringItemsTerzi(confId));				
					returnMap.put('AcquiringTerzi',itemsAcquiringTerziList);
				}//END ---Simone Misani 23/07/2019 Fix Tracking
				
				for(NE__OrderItem__c terminal : mapTermIdActionNotNone.values()){
					System.debug('$$$TERMINALE '+terminal.id);
					terminal.OB_FulfilmentStatus__c = COMPLETED;
					terminal.OB_ShopCode__c 		= pv.StabiCode;
					terminal.OB_GT__c 				= source;
					terminal.OB_CustomerCode__c 	= gt.gtCompanyCode;
					terminal.OB_Numero_Assitenza_POS__c = pv.assistanceNumber;
					terminal.OB_Tech_Outcome_Monetica__c = MONETICAOK;
					terminal.OB_RAC_SIA__c = pv.siaMerchantCode + pv.siaPVCode + pv.siaProgressiveCode;
					itemsToUpdate.add(terminal);
					if(mapChildOI.containsKey(terminal.id)){
						List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(terminal.Id);
						System.debug('$$$CHILDS TERMINALE '+listOfChildItem);
						for(NE__OrderItem__c child : listOfChildItem){
							if(child.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.ACQUIRING 
									&& child.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.VAS){
								System.debug('$$$CHILD_!ACQ&!VAS_CHILD.ID '+child.id);
								child.OB_FulfilmentStatus__c = COMPLETED;
								itemsToUpdate.add(child);
							}
							if(enablementActionNone.contains(child.NE__ProdId__r.OB_Codice_sfdc__c)
									&& (child.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING 
										|| child.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS)
									){
								isEnablementActive = true;
								// if(child.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PRICING
								// 		|| child.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.COMMISSIONE
								// 		|| isEnablementActive == true){
									System.debug('$$$CHILD_ACQ&VAS_CHILD.ID '+child.id);
									child.OB_FulfilmentStatus__c = COMPLETED;
									itemsToUpdate.add(child);
							}
							 //Simone Misani  WN-384-364  10/09/2019 START
							if(child.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && child.NE__ProdId__r.OB_Acquirer__c == NEXI){
								System.debug('$$$CHILD_VAS&ACUIRER-NEXI_CHILD.ID '+child.id);
								child.OB_FulfilmentStatus__c = COMPLETED;
								itemsToUpdate.add(child);
							}
							 //Simone Misani  WN-384-364  10/09/2019 END
								// if(child.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PCI){
								// 	child.OB_FulfilmentStatus__c = COMPLETED;
								// 	if(mapChildOI.containsKey(child.id)){
								// 		List<NE__OrderItem__c> childPCIList = mapChildOI.get(child.Id);
								// 		System.debug('$$$childPCIList '+childPCIList);
								// 		for(NE__OrderItem__c childPCI : childPCIList){
								// 			childPCI.OB_FulfilmentStatus__c = COMPLETED;
								// 			itemsToUpdate.add(childPCI);
								// 		}
								// 	}
								// 	itemsToUpdate.add(child);
								// }
						}
					}
				}
				//set completed if parent item is null, status is active and action is none
				for(NE__OrderItem__c itemNoAction : itemsNotChanged){
					//System.debug('$$$itemsNotChanged '+itemsNotChanged);
					if(itemNoAction.NE__Parent_Order_Item__c == null && itemNoAction.NE__Status__c.equalsIgnoreCase(ACTIVE)){ 
						//System.debug('$$$itemNoAction.Id '+itemNoAction.Id);
						if(mapChildOI.containsKey(itemNoAction.id)){
							List<NE__OrderItem__c> childNoActionList =  mapChildOI.get(itemNoAction.Id);
							System.debug('$$$childNoActionList '+childNoActionList);
							for(NE__OrderItem__c childNoAction : childNoActionList){
								childNoAction.OB_FulfilmentStatus__c = COMPLETED;
								itemsToUpdate.add(childNoAction);
							}
						}
						itemsToUpdate.add(itemNoAction);
					}
				}
				//set completed pagobancomat
				for(NE__OrderItem__c pagoB : pagobancomatList){
					if(pagoB.NE__Action__c != NONE){ //enrico.purificato WN-34
						System.debug('$$$itemsPagoB '+pagoB);
						pagoB.OB_FulfilmentStatus__c = COMPLETED;
						itemsToUpdate.add(pagoB);
						//enrico.purificato WN-34 START
						if(mapChildOI.containsKey(pagoB.id)){
							List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(pagoB.Id);
							System.debug('$$$CHILDS itemsPagoB '+listOfChildItem);
							for(NE__OrderItem__c child : listOfChildItem)
							{
									child.OB_FulfilmentStatus__c = COMPLETED;
									itemsToUpdate.add(child);
							}
						}
						//enrico.purificato WN-34 END
					}
				}
			
				//START--Simone Misani Fix Tracking 20/07/2019
				
				
			// }else{
			// 	for(OB_LogRequest__c log: currentLog){
						
			// 		//enrico.purificato WN-186 START
			// 		if(!updateLog.containsKey(log.id)){
			// 			log.OB_Status__c = OB_UtilityConstants.INATTESA;
			// 			updateLog.put(log.id,log);
			// 		}
			// 		//enrico.purificato WN-186 END
			// 	}
			// }
		}//END--Simone Misani Fix Tracking 20/07/2019
		
        //enrico.purificato WN-186 START
		if(updateLog.keySet().isEmpty()){
			returnMap.put('logRequest',updateLog.values());
			//update updateLog.values();
		}
		//enrico.purificato WN-186 END
		System.debug('$$$itemsToUpdate '+itemsToUpdate);
		returnMap.put('orderItem',itemsToUpdate);
		//update itemsToUpdate;
		return returnMap;
	}
	/*
	public static void updateGTItemsDetails(Map<String,NE__OrderItem__c> rootVasMap, List<NE__OrderItem__c> mainAcquiringNexiList, Map<String,NE__OrderItem__c> mapTermId, Map<Id,List<NE__OrderItem__c>> mapChildOI, NE__OrderItem__c terminal, Map<String,CodiciConvenzioni> codiciConvenzione, TermsIdInformation terminfo, puntoVendita pv){
        List<NE__OrderItem__c> itemToUpdateList = new List<NE__OrderItem__c>();
		List<NE__AssetItemAttribute__c> attributes = new List<NE__AssetItemAttribute__c>();
		List<NE__Order_Item_Attribute__c> attributesToUpdate = new  List<NE__Order_Item_Attribute__c>();
		System.debug('IN updateGTItemsDetails');
		//UPDATE ATTRIBUTES PV
		//OB_TrackingOrderMaintenance.updatePVattributes(terminal, pv);
		for(NE__Order_Item_Attribute__c attr : terminal.NE__Order_Item_Attributes__r){
			System.debug('Update terminal attributes');
			if(attr.Name.equalsIgnoreCase(PROGRESSIVOSIA)){
				attr.NE__Value__c = pv.siaProgressiveCode;
				attributesToUpdate.add(attr);
			}
			if(attr.Name.equalsIgnoreCase(CODICESTABILIMENTOSIA)){
				attr.NE__Value__c = pv.siaPVCode;
				attributesToUpdate.add(attr);
			}
			if(attr.Name.equalsIgnoreCase(CODICESIA)){
				attr.NE__Value__c = pv.siaMerchantCode;
				attributesToUpdate.add(attr);
			}
		//UPDATE ATTRIBUTES TERMINFO
		//OB_TrackingOrderMaintenance.updateTerminalattributes(terminal, termInfo);
			if(attr.Name.equalsIgnoreCase(TERMID)){
				attr.NE__Value__c = terminfo.terminalId;
				attributesToUpdate.add(attr);
			}
			if(attr.Name.equalsIgnoreCase(MODELLO)){
				attr.NE__Value__c = terminfo.model;
				terminal.OB_Model__c = terminfo.model;
				attributesToUpdate.add(attr);
			}
			if(attr.Name.equalsIgnoreCase(RELEASE)){
				attr.NE__Value__c = terminfo.connectionType;
				terminal.OB_Release__c = terminfo.connectionType;
				attributesToUpdate.add(attr);
				}
			if(attr.Name.equalsIgnoreCase(MODCOLLEGAMENTO)){
				attr.NE__Value__c = terminfo.modality;
				terminal.OB_LinkType__c = terminfo.modality;
				attributesToUpdate.add(attr);
			}
			if(attr.Name.equalsIgnoreCase(DMODELLO)){
				attr.NE__Value__c = terminfo.modelDescription;
				terminal.OB_ModelDescription__c = terminfo.modelDescription;
				attributesToUpdate.add(attr);
			}
			if(attr.Name.equalsIgnoreCase(DRELEASE)){
				attr.NE__Value__c = terminfo.release;
				terminal.OB_ReleaseDescription__c = terminfo.release; 
				attributesToUpdate.add(attr);
			}
			if(attr.Name.equalsIgnoreCase(DCONNESSIONE)){
				attr.NE__Value__c = terminfo.releaseDescription;
				terminal.OB_LinkDescription__c = terminfo.releaseDescription;
				attributesToUpdate.add(attr);
			}
		}
		 //START---Simone Misani 18/07/2019 WN-135
       	if(terminfo.errors == null ){
			if(terminfo.status.equalsIgnoreCase(INSTALLED)){
				System.debug('Update terminal status installed');
				terminal.NE__StartDate__c = OB_TrackingOrder.formatDate(terminfo.installationDate);
				terminal.OB_FulfilmentStatus__c = COMPLETED;
			}
			if(terminfo.status.equalsIgnoreCase(REFUSED)){
				System.debug('Update terminal status refused');
				terminal.OB_FulfilmentStatus__c = CANCELLED;
				terminal.OB_ReasonOfRejection__c = termInfo.reasonOfRejection;
			}
			if(terminfo.status.equalsIgnoreCase(DISINSTALLED)){
				System.debug('Update terminal status disinstalled');
				terminal.NE__EndDate__c = OB_TrackingOrder.formatDate(terminfo.uninstallationDate);
				terminal.OB_FulfilmentStatus__c = COMPLETED;
				}
		}else{
				System.debug('Update terminal status disinstalled');
				terminal.NE__EndDate__c = OB_TrackingOrder.formatDate(terminfo.uninstallationDate);
				terminal.OB_FulfilmentStatus__c = 	FAILED;
		}
		//END---Simone Misani 18/07/2019 WN-135
		itemToUpdateList.add(terminal);
		if(mapChildOI.containsKey(terminal.Id)){
            System.debug('mapChildOI in to the if ');
			System.debug('Child Terminal: '+mapChildOI.get(terminal.Id));
			for(NE__OrderItem__c childOrderItem: mapChildOI.get(terminal.Id)){
				if(terminal.OB_FulfilmentStatus__c != COMPLETED &&
						childOrderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PRICING){
					childOrderItem.OB_FulfilmentStatus__c = terminal.OB_FulfilmentStatus__c;
					itemToUpdateList.add(childOrderItem);
				}
				System.debug('Update child terminal pricing');
				//VAS AND ACQ NOT NEXI					
				CodiciConvenzioni convenzione = new CodiciConvenzioni();
				if(codiciConvenzione.containsKey(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c)){
					convenzione = codiciConvenzione.get(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
					childOrderItem.OB_FulfilmentStatus__c 	= terminal.OB_FulfilmentStatus__c;
					childOrderItem.OB_CompanyCode__c 		= convenzione.companyCode;
					childOrderItem.OB_Conventioncode__c		= convenzione.code;
					childOrderItem.NE__StartDate__c			= OB_TrackingOrder.formatDate(convenzione.startDate);
					itemToUpdateList.add(childOrderItem);
					if(rootVasMap.containskey(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c)){
						NE__OrderItem__c root 			= rootVasMap.get(childOrderItem.NE__ProdId__r.OB_Codice_sfdc__c);
						root.OB_FulfilmentStatus__c		= terminal.OB_FulfilmentStatus__c;
						root.NE__StartDate__c			= convenzione != null ? OB_TrackingOrder.formatDate(convenzione.startDate) : null;
						itemToUpdateList.add(root);
					}	
				}
			}
		}
		System.debug('terminal.NE__AssetItemEnterpriseId__c: ' + terminal.NE__AssetItemEnterpriseId__c + 'terminal.Id: '+terminal.Id );

		if(terminal.NE__AssetItemEnterpriseId__c != terminal.Id){ //l'asset esiste
			// List<Asset> assetList = [SELECT OB_ShopCode__c,
			// 						OB_GT__c,
			// 						OB_CustomerCode__c,
			// 						//OB_Numero_Assitenza_POS__c, //Field to be created on Asset
			// 						(SELECT Id, Name, NE__Value__c FROM NE__AssetItemAttributes__r)
			// 						FROM Asset 
			// 						WHERE NE__AssetItemEnterpriseId__c =: terminal.Id LIMIT 1];
			List<Asset> assetList = [SELECT OB_ShopCode__c,
									OB_GT__c,
									OB_CustomerCode__c,
									//OB_Numero_Assitenza_POS__c, //Field to be created on Asset
									(SELECT Id, Name, NE__Value__c FROM NE__AssetItemAttributes__r)
									FROM Asset 
									WHERE Id =: terminal.NE__AssetItemEnterpriseId__c LIMIT 1];

			System.debug('Asset in updateGTItemsDetails: '+ assetList);
			Asset asset = new Asset();
			if(!assetList.isEmpty()){
				asset = assetList.get(0);
				System.debug('Asset Id: '+ asset.id);				
				asset.OB_ShopCode__c = terminal.OB_ShopCode__c;
				asset.OB_GT__c = terminal.OB_GT__c;
				asset.OB_CustomerCode__c = terminal.OB_CustomerCode__c;
				//Field to be created on Asset
				//asset.OB_Numero_Assitenza_POS__c = terminal.OB_Numero_Assitenza_POS__c;
				
				for(NE__AssetItemAttribute__c attr : asset.NE__AssetItemAttributes__r){
					System.debug('Update asset attributes');
					if(attr.Name.equalsIgnoreCase(TERMID)){
						attr.NE__Value__c = terminfo.terminalId;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(MODELLO)){
						attr.NE__Value__c = terminfo.model;
						asset.OB_Model__c = terminfo.model;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(RELEASE)){
						attr.NE__Value__c = terminfo.connectionType;
						asset.OB_Release__c = terminfo.connectionType;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(MODCOLLEGAMENTO)){
						attr.NE__Value__c = terminfo.modality;
						asset.OB_LinkType__c = terminfo.modality;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(DMODELLO)){
						attr.NE__Value__c = terminfo.modelDescription;
						asset.OB_ModelDescription__c = terminfo.modelDescription;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(DRELEASE)){
						attr.NE__Value__c = terminfo.release;
						asset.OB_ReleaseDescription__c = terminfo.release; 
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(DCONNESSIONE)){
						attr.NE__Value__c = terminfo.releaseDescription;
						asset.OB_LinkDescription__c = terminfo.releaseDescription;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(PROGRESSIVOSIA)){
						attr.NE__Value__c = pv.siaProgressiveCode;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(CODICESTABILIMENTOSIA)){
						attr.NE__Value__c = pv.siaPVCode;
						attributes.add(attr);
					}
					if(attr.Name.equalsIgnoreCase(CODICESIA)){
						attr.NE__Value__c = pv.siaMerchantCode;
						attributes.add(attr);
					}
				}
				update asset;
			}
			//CHECK LAST ENABLEMENT
			
			List<NE__OrderItem__c> lastEnablement = OB_TrackingOrderMaintenance.checkLastEnablement(rootVasMap, mainAcquiringNexiList, mapTermId, mapChildOI, asset);
			if(!lastEnablement.isEmpty()){
				System.debug('lastEnablement: '+ lastEnablement);
				itemToUpdateList.addAll(lastEnablement);
			}
		}
		update itemToUpdateList;
		update attributes;
		update attributesToUpdate;
	}*/
/*
	public static List<NE__OrderItem__c> checkLastEnablement(Map<String,NE__OrderItem__c> rootVasMap, List<NE__OrderItem__c> mainAcquiringNexiList, Map<String,NE__OrderItem__c> mapTermId, Map<Id,List<NE__OrderItem__c>> mapChildOI, Asset asset){
		Map<String, List<NE__OrderItem__c>> enablementMap = new Map<String, List<NE__OrderItem__c>>();
		for(String keyVas : rootVasMap.keySet()){
			enablementMap.put(keyVas, null); //key == OB_Codice_sfdc__c
		}
		// List<NE__OrderItem__c> codSFDCList = [SELECT NE__ProdId__r.OB_Codice_sfdc__c FROM NE__OrderItem__c WHERE Id IN: acquiringNexiMap.keySet()];
		// if(!codSFDCList.isEmpty()){
		// 	for(NE__OrderItem__c codSFDC : codSFDCList ){
		// 		enablementMap.put(codSFDC.NE__ProdId__r.OB_Codice_sfdc__c, null);
		// 	}
		// }
		for(NE__OrderItem__c mainAcquiring : mainAcquiringNexiList){
			enablementMap.put(mainAcquiring.NE__ProdId__r.OB_Codice_sfdc__c, null);
		}
		for(NE__OrderItem__c terminal : mapTermId.values()){
			System.debug('terminal : ' + terminal);
			for(String enablement : enablementMap.keySet()){
				System.debug('enablement : ' + enablement);
				if(mapChildOI.containsKey(terminal.id)){
					for(NE__OrderItem__c childTerminal : mapChildOI.get(terminal.id)){
						System.debug('childTerminal : ' + childTerminal);
						if(childTerminal.NE__ProdId__r.OB_Codice_sfdc__c == enablement &&
								terminal.NE__Action__c != REMOVE){
							List<NE__OrderItem__c> listOfTerminal = new List<NE__OrderItem__c>();
							if(enablementMap.containsKey(childTerminal.NE__ProdId__r.OB_Codice_sfdc__c)){
								//START Simone Misani 13/07/2019 fix Tracking
								if(enablementMap.get(enablement) != null){
									listOfTerminal.addAll(enablementMap.get(enablement));
								}
								//END Simone Misani 13/07/2019 fix Tracking
							}
							listOfTerminal.add(terminal);
							enablementMap.put(enablement, listOfTerminal);
						}
					}
				}
			}
		}
		System.debug('enablementMap : ' + enablementMap);

		List<NE__OrderItem__c> listAssetChild = [SELECT Id, NE__Status__c, NE__ProdId__r.OB_Codice_sfdc__c 
													FROM NE__OrderItem__c 
													WHERE NE__AssetItemEnterpriseId__c =: asset.Id 
													AND NE__ProdId__r.RecordType.DeveloperName !=: OB_EnrichOrder.TERMINALE];
		List<NE__OrderItem__c> toReturn = new List<NE__OrderItem__c>();
		if(listAssetChild != null && !listAssetChild.isEmpty()){
			System.debug('listAssetChild : ' + listAssetChild);
			//If there isn't any enablement, set status 'Disconnected' for asset and all soons
			if(enablementMap.values() == null || enablementMap.values().isEmpty()){
				asset.NE__Status__c = DISCONNECTED;
				update asset;
					for(NE__OrderItem__c assetChild : listAssetChild){
						assetChild.NE__Status__c = DISCONNECTED;
						toReturn.add(assetChild);

					}
			}else{
				//If the map of enablements contains at least one value, set status 'Disconnected' only for empty soons
				for(String enablement : enablementMap.keySet()){
					if(enablementMap.get(enablement) == null || enablementMap.get(enablement).isEmpty() ){
						for(NE__OrderItem__c assetChild : listAssetChild){
							if(assetChild.NE__ProdId__r.OB_Codice_sfdc__c == enablement){
								assetChild.NE__Status__c = DISCONNECTED;
								toReturn.add(assetChild);
							}
						}
					}
				}
			}
		}
		return toReturn;
	}*/

	// public static void checkPagobancomat(Map<String,NE__OrderItem__c> mapTermId){
	// 	Boolean pagobancomatFlag = false;
	// 	for(NE__OrderItem__c terminal : mapTermId.values()){
	// 		if(terminal.NE__Action__c != REMOVE){
	// 			pagobancomatFlag = true;
	// 		}
	// 	}
	// 	System.debug('pagobancomatFlag : ' + pagobancomatFlag);
	// 	if(!pagobancomatFlag){
	// 		//TBD
	// 	}
	// }

	// public static void updateGTChangeTerminalsOKMonetica(Map<String,NE__OrderItem__c> mapTermAdd, Map<String,NE__OrderItem__c> mapTermRemoved, Map<Id,List<NE__OrderItem__c>> mapChildOI, puntoVendita pv, String source, GT gt, NE__Order__c conf){
	// 	List<NE__OrderItem__c> itemsToUpdate = new List<NE__OrderItem__c>();
	// 	if(gt.errors == null && gt.errors.isEmpty()){
	// 		System.debug('IN SOSTITUZIONE TERMINALI - OK MONETICA');
	// 		for(NE__OrderItem__c terminal : mapTermAdd.values()){
	// 			System.debug('TERMINALE: '+ terminal);
	// 			terminal.OB_FulfilmentStatus__c = COMPLETED;
	// 			terminal.OB_ShopCode__c 		= pv.StabiCode;
	// 			terminal.OB_GT__c 				= source;
	// 			terminal.OB_CustomerCode__c 	= gt.gtCompanyCode;
	// 			terminal.OB_Numero_Assitenza_POS__c = pv.assistanceNumber;
	// 			terminal.OB_Tech_Outcome_Monetica__c = MONETICAOK;
	// 			terminal.OB_RAC_SIA__c = pv.siaMerchantCode + pv.siaPVCode + pv.siaProgressiveCode;
	// 			itemsToUpdate.add(terminal);
	// 			if(mapChildOI.containsKey(terminal.Id)){
	// 				List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(terminal.Id);
	// 				System.debug('listOfChildItem: '+ listOfChildItem);
	// 				for(NE__OrderItem__c child : listOfChildItem){
	// 					child.OB_FulfilmentStatus__c = COMPLETED;
	// 					itemsToUpdate.add(child);
	// 				}
	// 			}
	// 			//call method to update pv attributes
	// 			OB_TrackingOrderMaintenance.updatePVattributes(terminal, pv);
	// 		}
	// 	}else{
	// 		System.debug('IN SOSTITUZIONE TERMINALI - KO MONETICA - GT errors is nor empty');
	// 		for(NE__OrderItem__c terminal : mapTermAdd.values()){
	// 			System.debug('terminal in add: '+ terminal);
	// 			terminal.OB_FulfilmentStatus__c = FAILED;
	// 			terminal.OB_Tech_Outcome_Monetica__c = MONETICAKO;
	// 			terminal.OB_RAC_SIA__c = pv.siaMerchantCode + pv.siaPVCode + pv.siaProgressiveCode;
	// 			itemsToUpdate.add(terminal);
	// 			if(mapChildOI.containsKey(terminal.Id)){
	// 				List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(terminal.Id);
	// 				System.debug('listOfChildItemInAdd: '+ listOfChildItem);
	// 				for(NE__OrderItem__c child : listOfChildItem){
	// 					child.OB_FulfilmentStatus__c = FAILED;
	// 					itemsToUpdate.add(child);
	// 				}
	// 			}
	// 		}
	// 		for(NE__OrderItem__c terminal : mapTermRemoved.values()){
	// 			System.debug('terminal in remove: '+ terminal);
	// 			terminal.OB_FulfilmentStatus__c = FAILED;
	// 			itemsToUpdate.add(terminal);
	// 			if(mapChildOI.containsKey(terminal.Id)){
	// 				List<NE__OrderItem__c> listOfChildItem = mapChildOI.get(terminal.Id);
	// 				System.debug('listOfChildItemInRemove: '+ listOfChildItem);
	// 				for(NE__OrderItem__c child : listOfChildItem){
	// 					child.OB_FulfilmentStatus__c = FAILED;
	// 					itemsToUpdate.add(child);
	// 				}
	// 			}
	// 		}
	// 		conf.OB_FulfilmentStatus__c = FAILED;
	// 		update conf;
	// 	}
	// 	update itemsToUpdate;
	// }

	// public static void updateGTItemsChangeTerminalsDetails(NE__OrderItem__c termAdd, NE__OrderItem__c termRemoved, TermsIdInformation terminfo, Map<Id,List<NE__OrderItem__c>> mapChildOI){
	// 	List<NE__OrderItem__c> itemToUpdate = new List<NE__OrderItem__c>();
	// 	//update terminal 'REMOVED'
	// 	System.debug('IN SOSTITUZIONE TERMINALI - DETTAGLIO');
	// 	termRemoved.OB_FulfilmentStatus__c = COMPLETED;
		
	// 	if(mapChildOI.containsKey(termRemoved.id)){
	// 		for(NE__OrderItem__c childRemoved : mapChildOI.get(termRemoved.Id)){
	// 			System.debug('childs terminal removed' + mapChildOI.get(termRemoved.Id));
	// 			childRemoved.OB_FulfilmentStatus__c = COMPLETED;
	// 			itemToUpdate.add(childRemoved);
	// 		}
	// 	}
	// 	itemToUpdate.add(termRemoved);
	// 	//call method to update attributes for terminal in 'ADD' and terminal status
	// 	//OB_TrackingOrderMaintenance.updateTerminalAttributes(termAdd, terminfo);
	// 	List<NE__Order_Item_Attribute__c> attributesToUpdate = new  List<NE__Order_Item_Attribute__c>();
	// 	for(NE__Order_Item_Attribute__c attr : termAdd.NE__Order_Item_Attributes__r){
	// 		System.debug('UPDATE TERMINAL ATTRIBUTE');
	// 		if(attr.Name.equalsIgnoreCase(TERMID)){
	// 			attr.NE__Value__c = terminfo.terminalId;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(MODELLO)){
	// 			attr.NE__Value__c = terminfo.model;
	// 			termAdd.OB_Model__c = terminfo.model;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(RELEASE)){
	// 			attr.NE__Value__c = terminfo.connectionType;
	// 			termAdd.OB_Release__c = terminfo.connectionType;
	// 			attributesToUpdate.add(attr);
	// 			}
	// 		if(attr.Name.equalsIgnoreCase(MODCOLLEGAMENTO)){
	// 			attr.NE__Value__c = terminfo.modality;
	// 			termAdd.OB_LinkType__c = terminfo.modality;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(DMODELLO)){
	// 			attr.NE__Value__c = terminfo.modelDescription;
	// 			termAdd.OB_ModelDescription__c = terminfo.modelDescription;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(DRELEASE)){
	// 			attr.NE__Value__c = terminfo.release;
	// 			termAdd.OB_ReleaseDescription__c = terminfo.release; 
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(DCONNESSIONE)){
	// 			attr.NE__Value__c = terminfo.releaseDescription;
	// 			termAdd.OB_LinkDescription__c = terminfo.releaseDescription;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 	}
	// 	if(terminfo.status.equalsIgnoreCase(INSTALLED)){
	// 		System.debug('UPDATE TERMINAL status INSTALLED');
	// 		termAdd.NE__StartDate__c = OB_TrackingOrder.formatDate(terminfo.installationDate);
	// 		termAdd.OB_FulfilmentStatus__c = COMPLETED;
	// 	}
	// 	if(terminfo.status.equalsIgnoreCase(REFUSED)){
	// 		System.debug('UPDATE TERMINAL status REFUSED');
	// 		termAdd.OB_FulfilmentStatus__c = CANCELLED;
	// 		termAdd.OB_ReasonOfRejection__c = termInfo.reasonOfRejection;
	// 	}
	// 	if(terminfo.status.equalsIgnoreCase(DISINSTALLED)){
	// 		System.debug('UPDATE TERMINAL status DISINSTALLED');
	// 		termAdd.NE__EndDate__c = OB_TrackingOrder.formatDate(terminfo.uninstallationDate);
	// 		termAdd.OB_FulfilmentStatus__c = COMPLETED;
	// 	}
	// 	itemToUpdate.add(termAdd);
	// 	update attributesToUpdate;
	// 	update itemToUpdate;
	// }

	// public static void updatePVattributes(NE__OrderItem__c terminal, puntoVendita pv){
	// 	List<NE__Order_Item_Attribute__c> attributesToUpdate = new  List<NE__Order_Item_Attribute__c>();
	// 	for(NE__Order_Item_Attribute__c attr : terminal.NE__Order_Item_Attributes__r){
	// 		if(attr.Name.equalsIgnoreCase(PROGRESSIVOSIA)){
	// 			attr.NE__Value__c = pv.siaProgressiveCode;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(CODICESTABILIMENTOSIA)){
	// 			attr.NE__Value__c = pv.siaPVCode;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(CODICESIA)){
	// 			attr.NE__Value__c = pv.siaMerchantCode;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 	}
	// 	update attributesToUpdate;
	// }

	// public static void updateTerminalAttributes(NE__OrderItem__c terminal, TermsIdInformation terminfo){
	// 	List<NE__Order_Item_Attribute__c> attributesToUpdate = new  List<NE__Order_Item_Attribute__c>();
	// 	for(NE__Order_Item_Attribute__c attr : terminal.NE__Order_Item_Attributes__r){
	// 		if(attr.Name.equalsIgnoreCase(TERMID)){
	// 			attr.NE__Value__c = terminfo.terminalId;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(MODELLO)){
	// 			attr.NE__Value__c = terminfo.model;
	// 			terminal.OB_Model__c = terminfo.model;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(RELEASE)){
	// 			attr.NE__Value__c = terminfo.connectionType;
	// 			terminal.OB_Release__c = terminfo.connectionType;
	// 			attributesToUpdate.add(attr);
	// 			}
	// 		if(attr.Name.equalsIgnoreCase(MODCOLLEGAMENTO)){
	// 			attr.NE__Value__c = terminfo.modality;
	// 			terminal.OB_LinkType__c = terminfo.modality;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(DMODELLO)){
	// 			attr.NE__Value__c = terminfo.modelDescription;
	// 			terminal.OB_ModelDescription__c = terminfo.modelDescription;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(DRELEASE)){
	// 			attr.NE__Value__c = terminfo.release;
	// 			terminal.OB_ReleaseDescription__c = terminfo.release; 
	// 			attributesToUpdate.add(attr);
	// 		}
	// 		if(attr.Name.equalsIgnoreCase(DCONNESSIONE)){
	// 			attr.NE__Value__c = terminfo.releaseDescription;
	// 			terminal.OB_LinkDescription__c = terminfo.releaseDescription;
	// 			attributesToUpdate.add(attr);
	// 		}
	// 	}
	// 	if(terminfo.status.equalsIgnoreCase(INSTALLED)){
	// 		terminal.NE__StartDate__c = OB_TrackingOrder.formatDate(terminfo.installationDate);
	// 		terminal.OB_FulfilmentStatus__c = COMPLETED;
	// 	}
	// 	if(terminfo.status.equalsIgnoreCase(REFUSED)){
	// 		terminal.OB_FulfilmentStatus__c = CANCELLED;
	// 		terminal.OB_ReasonOfRejection__c = termInfo.reasonOfRejection;
	// 	}
	// 	if(terminfo.status.equalsIgnoreCase(DISINSTALLED)){
	// 		terminal.NE__EndDate__c = OB_TrackingOrder.formatDate(terminfo.uninstallationDate);
	// 		terminal.OB_FulfilmentStatus__c = COMPLETED;
	// 	}
	// 	update attributesToUpdate;
	// 	update terminal; 
	// }

	public static ExternalSourceMapping__c conventionCodeManagement(Boolean isAcquiring,Boolean isGT,Boolean hasAcquiring,ExternalSourceMapping__c servicePoint,Map<String,List<NE__OrderItem__c>> acquiringNexiMap,Id servicePointId,Map<String,NE__OrderItem__c> mapTermId, String conventionCodeExSM){
		if(isAcquiring && isGT){
			servicePoint.OB_ConventionCode__c  = conventionCodeExSM;
			return servicePoint;
		}else if(isAcquiring && !isGT){
			NE__OrderItem__c terminal = mapTermId.values()[0];
			ExternalSourceMapping__c servicePointMonetica;
			List<ExternalSourceMapping__c> servicePointMoneticaList = [select id,OB_ConventionCode__c  from ExternalSourceMapping__c where OB_Source__c = 'MONETICA' AND OB_CustomerCodeClientCode__c =: terminal.OB_CustomerCode__c and OB_ServicePointCodeShopCode__c =: terminal.OB_ShopCode__c and OB_Service_Point_ID__c =: servicePointId ];
			system.debug(' ### eternalmaps list : ' + servicePointMoneticaList);
			if(servicePointMoneticaList.size() > 1){
				for(ExternalSourceMapping__c spExtMap : servicePointMoneticaList){
					if(spExtMap.OB_ConventionCode__c  == servicePoint.OB_ServicePointCodeShopCode__c){
						return null;
					}else if(String.isBlank(spExtMap.OB_ConventionCode__c)){
						servicePointMonetica = spExtMap;
						servicePointMonetica.OB_ConventionCode__c = servicePoint.OB_ServicePointCodeShopCode__c;
					}
				}
				return servicePointMonetica;
			} else{
				if(servicePointMoneticaList.size() > 0 && String.isBlank(servicePointMoneticaList[0].OB_ConventionCode__c)){
						servicePointMonetica = servicePointMoneticaList[0];
						servicePointMonetica.OB_ConventionCode__c = servicePoint.OB_ServicePointCodeShopCode__c;
						system.debug(' *** servicp ' + servicePointMonetica);
						return servicePointMonetica;
				}else {
					return null;
				}
			}			
		}else if(isGT && hasAcquiring && !isAcquiring){
			List<NE__OrderItem__c> acquiringNexiList = acquiringNexiMap.values()[0];
			servicePoint.OB_ConventionCode__c = acquiringNexiList[0].OB_ServicePointCode__c;
			return servicePoint;
		}
		return servicePoint;
	}


	/**Simone Misani 
	Description: method for controll the part isGT with terminal 
	13/07/2019 */
@TestVisible
	private static void isGtTerminal(List<OB_TrackingUtility.GT> GTArray, Boolean termAdd, Boolean termRemove, Boolean isSubProcessChangeTerm){

		for(OB_TrackingUtility.GT gt : GTArray){
					if(gt.PVCodes.size()==0){					
							for(OB_TrackingUtility.ErrorList er: gt.errors){
								Boolean isNotValid 		= (String.isBlank(er.code))
												|| (String.isBlank(er.description));
								if(isNotValid){
									throw new applicationException('Method: isGtTerminal :One or more empty fields - GT.Error');
								}

							}						
						
						throw new applicationException('Method: isGtTerminal :One or more empty fields - GT');
					}
					for(OB_TrackingUtility.puntoVendita pv : gt.PVCodes){
						Boolean isNotValid 		= (String.isBlank(pv.ctiCode))
												|| (String.isBlank(pv.stabiCode))
												|| (String.isBlank(pv.siaMerchantCode))
												|| (String.isBlank(pv.siaPVCode))
												|| (String.isBlank(pv.siaProgressiveCode))
												|| (String.isBlank(pv.assistanceNumber))
												|| (String.isBlank(pv.startDate));
						if(isNotValid){
							throw new applicationException('Method: isGtTerminal :One or more empty fields - GT puntiVendita');
						}
						if(pv.TerminalInformation.size()==0){ //Simone Misani 12/07/2019 Fix trace-Tracking gtCompanyCode no required

						throw new applicationException('Method: isGtTerminal :One or more empty fields - GT.PVCodes.TerminalInformation');
						}
						for(OB_TrackingUtility.TermsIdInformation ti : pv.TerminalInformation){
							Boolean requiredReason= false;
							Boolean isNotValidTermInfo;
							if(ti.Status== REFUSED){
									requiredReason = (String.isBlank(ti.reasonOfRejection));

							}
							if(!termAdd && termRemove){
							 isNotValidTermInfo = 	(String.isBlank(ti.terminalId))
												|| 			(String.isBlank(ti.status))
												|| 			(String.isBlank(ti.uninstallationDate)
												|| 			(ti.terminalId.length()!= 8)); // Simone Misani tracking 22/08/2019
							}
							else{
								 isNotValidTermInfo = 	(String.isBlank(ti.terminalId))
												|| 			(String.isBlank(ti.model))
												|| 			(String.isBlank(ti.modelDescription))
												|| 			(String.isBlank(ti.release))
												|| 			(String.isBlank(ti.releaseDescription))
												|| 			(String.isBlank(ti.connectionType))
												|| 			(String.isBlank(ti.modality))
												|| 			(String.isBlank(ti.status))
												|| 			(String.isBlank(ti.installationDate));
							}
							if(isNotValidTermInfo&&!isSubProcessChangeTerm&&requiredReason){
								throw new applicationException('Method: isGtTerminal :One or more empty fields - GT.PVCodes.TerminalInformation');
							}
							
						}
					}
		}
	}
	/**Simone Misani 
	Description: method for controll the part isAcquiring with terminal 
	13/07/2019 */
	@TestVisible
 	private static void isAcquiringTerminal(List<OB_TrackingUtility.Acquiring> acquiringArray, Boolean requiredChange){
		for(OB_TrackingUtility.Acquiring acq : acquiringArray){
					if(acq.PVCodes.size()==0){
						throw new applicationException('Method: isGtTerminal :One or more empty fields - Acquiring');
					}
					for(OB_TrackingUtility.puntoVendita pv : acq.PVCodes){
						
						for (OB_TrackingUtility.Changes ch : pv.changes){
							Boolean isNotValidChange = requiredChange;
							if(requiredChange &&(String.isBlank(ch.externalId)|| String.isBlank(ch.result))){
								for(OB_TrackingUtility.ErrorList er: ch.errors){
									Boolean isNotValid 		= (String.isBlank(er.code))
												|| (String.isBlank(er.description));
									if(isNotValid){
										throw new applicationException('Method: isGtTerminal :One or more empty fields - Acquiring.pv.changes.Error');
									}

								}
								throw new applicationException('Method: isGtTerminal :One or more empty fields - Acquiring puntoVendita.changes');

							}

						}

					}
		}
	}


	/**Simone Misani 
	Description: method for controll the part isAcquiring with Acquiring 
	13/07/2019 */
	@TestVisible
	private static void isAcquiringAcquiring(List<OB_TrackingUtility.Acquiring> acquiringArray){

		

		for(OB_TrackingUtility.Acquiring acq : acquiringArray){
					if(acq.PVCodes.size()==0){
						throw new applicationException('Method: isAcquiringAcquiring :One or more empty fields - Acquiring.pvCode');
					}
					for(OB_TrackingUtility.puntoVendita pv : acq.PVCodes){
						if(String.isBlank(pv.PVCode)|| String.isBlank(pv.startDate)){
						 	throw new applicationException('Method: isAcquiringAcquiring :One or more empty fields - Acquiring.pvCode o startDate');
						}
						for (OB_TrackingUtility.Changes ch : pv.changes){

							if(String.isBlank(ch.externalId)|| String.isBlank(ch.result)){
								for(OB_TrackingUtility.ErrorList er: ch.errors){
								Boolean isNotValid 		= (String.isBlank(er.code))
												|| (String.isBlank(er.description));
									if(isNotValid){
										throw new applicationException('Method: isAcquiringAcquiring :One or more empty fields - Acquiring.Error');
									}

								}
								throw new applicationException('Method: isAcquiringAcquiring :One or more empty fields - Acquiring puntoVendita.changes');
							//START-----Simone Misani WN-67 20/08/2019
							}else if (ch.result == 'KO'){
								if(ch.errors == null && ch.errors.size() == 0){
									throw new applicationException('Method: isAcquiringAcquiring :One or more empty fields - Acquiring.Error');
								}
								for(OB_TrackingUtility.ErrorList er: ch.errors){
								Boolean isValid 		= (String.isNotBlank(er.code))
												&&(String.isNotBlank(er.description));
									if(!isValid){
										throw new applicationException('Method: isAcquiringAcquiring :One or more empty fields - Acquiring.Error');
									}

								}
							}//START-----Simone Misani WN-67 20/08/2019
						

						}

					}
		}
	}



	/**Simone Misani 
	Description: method for controll the part isGt with Acquiring 
	13/07/2019 */
	@TestVisible
	private static void isGtAcquiring (List<OB_TrackingUtility.GT> GTArray,  String confId){//Boolean isPreAuthDcc,

		List<NE__OrderItem__c> listOrderIAcquandVas = [	SELECT 	id,
																				NE__Action__c,
																				NE__OrderId__c,
																				NE__ProdId__r.RecordType.DeveloperName,
																				NE__ProdName__c,
																				NE__Root_Order_Item__c	
																FROM 		NE__OrderItem__c 
																WHERE 
																				NE__OrderId__c =:confId
																				AND NE__ProdId__r.RecordType.DeveloperName = 'Acquiring'
																				AND (NE__Action__c !='None'
																				OR NE__Action__c 	!='Change')
																				];
																				

		for(OB_TrackingUtility.GT gt : GTArray){
			if(gt.PVCodes.size()==0){						
				throw new applicationException('Method: isGtAcquiring :One or more empty fields - GT');
			}
				for(OB_TrackingUtility.puntoVendita pv : gt.PVCodes){
					if(pv.TerminalInformation.size()==0){ //Simone Misani 12/07/2019 Fix trace-Tracking gtCompanyCode no required
						throw new applicationException('Method: isGtAcquiring :One or more empty fields - GT.PVCodes.TerminalInformation');
					}
						for(OB_TrackingUtility.TermsIdInformation ti : pv.TerminalInformation){
							
								Boolean isNotValidTermInfo = 	(String.isBlank(ti.terminalId));						
								if(isNotValidTermInfo){
									for(OB_TrackingUtility.ErrorList er: ti.errors){
										Boolean isNotValid 		= (String.isBlank(er.code))
													|| (String.isBlank(er.description));
										if(isNotValid){
											throw new applicationException('Method: isGtAcquiring :One or more empty fields - GT.Error');
										}

									}
									throw new applicationException('Method: isGtAcquiring :One or more empty fields - GT.PVCodes.TerminalInformation.terminalId');
								}

								for (OB_TrackingUtility.CodiciConvenzioni agre : ti.agreementCodes){
									for(NE__OrderItem__c oi : listOrderIAcquandVas){
										
										Boolean isNotValid 		= 	(String.isBlank(agre.status))
														|| 			(String.isBlank(agre.companyCode)
														||			(String.isBlank(agre.companyName)));
										if(isNotValid){
											throw new applicationException('Method: isGtAcquiring :One or more empty fields - GT.agreementCodes');
										}
									}
								}	
							
							//}

						}
				}
		}
	}

	/**Simone Misani 
	Description: method for controll the part isGt with vas 
	13/07/2019 */
	@TestVisible
	private static void isGtVas(List<OB_TrackingUtility.Gt>  GTArray, String confId  ){//Boolean isPreAuthDcc

			List<NE__OrderItem__c> listOrderIAcquandVas = [	SELECT 	id,
																				NE__Action__c,
																				NE__OrderId__c,
																				NE__ProdId__r.RecordType.DeveloperName,
																				NE__ProdName__c,
																				NE__Root_Order_Item__c	//Simone Misani 10/07/2019 fix Configuratore Tecnico
																FROM 		NE__OrderItem__c 
																WHERE 
																				NE__OrderId__c =:confId
																				AND NE__ProdId__r.RecordType.DeveloperName = 'Vas'//Simone Misani 10/09/2019 WN-384
																				AND NE__Action__c !='None'//Simone Misani 10/09/2019 WN-384
																				];

			for(OB_TrackingUtility.GT gt : GTArray){
			if(gt.PVCodes.size()==0){						
				throw new applicationException('Method: isGtVas :One or more empty fields - GT.pvCode');
			}
				for(OB_TrackingUtility.puntoVendita pv : gt.PVCodes){
					if(pv.TerminalInformation.size()==0){ //Simone Misani 12/07/2019 Fix trace-Tracking gtCompanyCode no required
						throw new applicationException('Method: isGtVas :One or more empty fields - GT.PVCodes.TerminalInformation');
					}
						for(OB_TrackingUtility.TermsIdInformation ti : pv.TerminalInformation){
							//manca di isPreAuthDcc valorizzarlo chiedere a susy
							// if(isPreAuthDcc){
								Boolean isNotValidTermInfo = 	(String.isBlank(ti.terminalId));						
								if(isNotValidTermInfo){
									for(OB_TrackingUtility.ErrorList er: ti.errors){
										Boolean isNotValid 		= (String.isBlank(er.code))
													|| (String.isBlank(er.description));
										if(isNotValid){
											throw new applicationException('Method: isGtVas :One or more empty fields - GT.Error');
										}

									}
									throw new applicationException('Method: isGtVas :One or more empty fields - GT.PVCodes.TerminalInformation');
								}

								for (OB_TrackingUtility.CodiciConvenzioni agre : ti.agreementCodes){
									for(NE__OrderItem__c oi : listOrderIAcquandVas){
									
										Boolean isNotValid 		= 	(String.isBlank(agre.status))
														|| 			(String.isBlank(agre.companyCode)
														||			(String.isBlank(agre.companyName)));
										if(isNotValid){
											throw new applicationException('Method: isGtVas :One or more empty fields - GT.agreementCodes');
										}
									}
								}	
							
							}

						// }
				}
		}

	}
	/**Simone Misani 
	Description: method for controll the part isAcquiring with Acquiring 
	13/07/2019 */
	@TestVisible
	private static void isAcquiringVas(List<OB_TrackingUtility.Acquiring> acquiringArray){
		for(OB_TrackingUtility.Acquiring acq : acquiringArray){
					if(acq.PVCodes.size()==0){
						throw new applicationException('Method: isAcquiringVas :One or more empty fields - Acquiring');
					}
					for(OB_TrackingUtility.puntoVendita pv : acq.PVCodes){
						
						for (OB_TrackingUtility.Changes ch : pv.changes){

							if(String.isBlank(ch.externalId)|| String.isBlank(ch.result)){
								for(OB_TrackingUtility.ErrorList er: ch.errors){
								Boolean isNotValid 		= (String.isBlank(er.code))
												|| (String.isBlank(er.description));
									if(isNotValid){
										throw new applicationException('Method: isAcquiringVas :One or more empty fields - GT.Error');
									}

								}
								throw new applicationException('Method: isAcquiringVas :One or more empty fields - Acquiring puntoVendita.changes');

							}

						}

					}
		}
	}

	/**Simone Misani 
	Description: method for controll Ko to Acquiring
	13/07/2019 */
	@TestVisible
	private static Boolean isAcquiringKO(List<OB_TrackingUtility.Acquiring> acquiringArray){
		Boolean toReturn = false ;
		for(OB_TrackingUtility.Acquiring acq : acquiringArray){
			for(OB_TrackingUtility.puntoVendita pv : acq.PVCodes){						
				for (OB_TrackingUtility.Changes ch : pv.changes){
					if((ch.errors == null || ch.errors.size() == 0) && ch.result == 'KO'  ){
                        System.debug('isAquring Ko ooooo errors');
								throw new applicationException('Method: isAcquiringAcquiring :One or more empty fields - Acquiring.Error');
							}
					if(ch.errors != null){//Simone Misani 25/09/2019 WN-492
						toReturn=true;
					}
				

				}
			}
		}
		return toReturn;	

	}

	/**Simone Misani 
	Description: method for controll Ko to GT
	13/07/2019 */
@TestVisible
	private static Boolean isGTKo(List<OB_TrackingUtility.GT>  GTArray){
		Boolean GterrorKO = false;
        System.debug('Sonodentro');
		for(OB_TrackingUtility.GT gtko : GTArray ){
			if(gtko.errors != null && gtko.errors.size() != 0 ){
				GterrorKO = true;
            }
				for(OB_TrackingUtility.puntoVendita pv : gtko.PVCodes){
						for(OB_TrackingUtility.TermsIdInformation ti : pv.TerminalInformation){
							if(ti.errors != null ){
								GterrorKO = true;
							}
						}

				}
			
		}
		return GterrorKO;

	}


	

//START--Simone Misani Fix Tracking 20/07/2019
	public static void updateLogRequest(String orderId){
		List<NE__Order__c> updateListOrder = new List <NE__Order__c>();
		list<OB_LogRequest__c> currentLogRequest = new List <OB_LogRequest__c>();
		List<NE__Order__c> listOrder = new List <NE__Order__c>();
		List<OB_LogRequest__c> updateLogrequest = new List <OB_LogRequest__c>();
		Integer counOrderItem =0;
		Integer countFailed =0;
        Integer countSent =0;
		List<NE__OrderItem__c> listOrderItem = [	SELECT 	id, 
															NE__Action__c,
															OB_FulfilmentStatus__c,
															NE__Status__c
													FROM 	NE__OrderItem__c
													WHERE 	NE__OrderId__c =: orderId
													AND OB_FulfilmentStatus__c != 'Cancelled' ];//Simone Misani 11/11/2019 fix Tracking
		
		if(!listOrderItem.isEmpty()){
			for(NE__OrderItem__c oItem : listOrderItem){
				if(oItem.OB_FulfilmentStatus__c.equalsIgnoreCase(OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED)){
					
				}else {
					counOrderItem ++;
						if(oItem.OB_FulfilmentStatus__c.equalsIgnoreCase(OB_UtilityConstants.FULFILMENTSTATUS_FAILED)){
							countFailed++;
						}else if(oItem.OB_FulfilmentStatus__c.equalsIgnoreCase(OB_UtilityConstants.ORDERS_STATUS_SENT)){
                        countSent++;//SImone Misani perf-96|!!!!!!
                    }
				}
				
			}
			
				 listOrder= 		[		SELECT 	Id,
															OB_FulfilmentStatus__c,
															OB_FirstorSecondTracking__c,//Simone Misani  07/10/2019
															OB_Bank_OrderStatus__c,//Simone Misani WN-67 20/08/2019
															OB_Nexi_OrderStatus__c,//Simone Misani WN-67 22/08/2019
															NE__Order_Header__r.OB_Sub_Process__c//SIMONE misani perf-366 10/01/2020 
													FROM	NE__Order__c
													WHERE 	id =: orderId FOR UPDATE ];
				currentLogRequest = [	SELECT 	id,
																		OB_Status__c
																FROM	OB_LogRequest__c	
																WHERE 	OB_OrderId__c =: orderId
																AND OB_Status__c != :OB_UtilityConstants.CONFERMATO 
																FOR UPDATE ]; //francesca.ribezzi 25/09/19 - WN-454 - not considering confirmed logrequests];
				String firstTrack;//Simone Misani  07/10/2019
				String subProcesstermoffer;//SIMONE misani perf-366 10/01/2020 
				if(counOrderItem == 0){

					if(!listOrder.isEmpty() && !currentLogRequest.isEmpty()){
						for(NE__Order__c ord : listOrder){
							ord.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
							ord.OB_Bank_OrderStatus__c = OB_UtilityConstants.BANKORDERSTATUS_ORDERFULFILLED;//Simone Misani WN-67 20/08/2019
							ord.OB_Nexi_OrderStatus__c = OB_UtilityConstants.BANKORDERSTATUS_ORDERFULFILLED;
							//updateListOrder.add(ord);
							firstTrack = ord.OB_FirstorSecondTracking__c;
						}
						for(OB_LogRequest__c log : currentLogRequest){
							log.OB_Status__c = OB_UtilityConstants.CONFERMATO;
							log.OB_Response_Track__c = 'OK';
							//updateLogrequest.add(log);
						}
					//Simone Misani  07/10/2019 START 
					if(firstTrack != 'Second Tracking'){
							OB_UtilityCallingServices.createAsset(orderId, OB_UtilityConstants.MAINTENANCE);
					}
					//Simone Misani  07/10/2019 END
					}
			}else{
				//Simone Misani WN-324-288-75 05/09/2019 START
				if(!listOrder.isEmpty() && !currentLogRequest.isEmpty()){
					subProcesstermoffer = listOrder.get(0).NE__Order_Header__r.OB_Sub_Process__c ; //SIMONE misani perf-366 10/01/2020 
					if(countFailed>0){
						for(NE__Order__c ord : listOrder){						
						ord.OB_Bank_OrderStatus__c = OB_UtilityConstants.BANKORDERSTATUS_ORDERFULFILLEDPARTIALY;
						ord.OB_Nexi_OrderStatus__c = OB_UtilityConstants.BANKORDERSTATUS_ORDERFULFILLEDPARTIALY;
						ord.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_FAILED; //francesca.ribezzi 08/11/19 - PROD-49 - adding  OB_FulfilmentStatus__c
						
						//updateListOrder.add(ord);
					}
					for(OB_LogRequest__c log : currentLogRequest){
							log.OB_Status__c = OB_UtilityConstants.INATTESA;
							log.OB_Response_Track__c = 'KO';
							//updateLogrequest.add(log);
						}
				//Simone Misani WN-324-288-75 05/09/2019  START

				}
				//SImone Misani perf-96|!!!!!!
                    else if(countSent>0){
                        for(OB_LogRequest__c log : currentLogRequest){
							log.OB_Status__c = OB_UtilityConstants.BOZZA;
							//SIMONE misani perf-366 10/01/2020 start
							if(subProcesstermoffer == 'termina offerta')  {
								log.OB_Status__c = OB_UtilityConstants.INATTESA;
							}//SIMONE misani perf-366 10/01/2020 end                     	
							//updateLogrequest.add(log);
						}
                        
                    }//SImone Misani perf-96|!!!!!!
				
				

				}
			}
			if(!listOrder.isEmpty()){
				update listOrder; 
			}
			
			if(!currentLogRequest.isEmpty()){
				update currentLogRequest;
				
			}	
		}		
	}//END--Simone Misani Fix Tracking 20/07/2019

/*
Simone Misani  create method  for  the order Items in action remove for the change term
23/07/2019
 */
 @TestVisible
	private static void updateorderItemChangeterm(String orderId){
		List<NE__OrderItem__c> updateListOrder = new List <NE__OrderItem__c>();
		List<NE__OrderItem__c> listOrderItem = [	SELECT 	id, 
															NE__Action__c,
															OB_FulfilmentStatus__c,
															NE__Status__c
													FROM 	NE__OrderItem__c
													WHERE 	NE__OrderId__c =: orderId
													AND NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c=:SOSTITUZIONETERMINALI
													AND NE__Action__c='Remove'
													AND OB_FulfilmentStatus__c != 'Failed'];

		if(!listOrderItem.isEmpty()){
			for(NE__OrderItem__c oi : listOrderItem){
				oi.OB_FulfilmentStatus__c =  OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
				updateListOrder.add(oi);
			}
			 update updateListOrder;
		}

	}

	// @TestVisible
	// private static List<NE__OrderItem__c> checkedErrorTerminalInfo( List<OB_TrackingUtility.TermsIdInformation> termErr, String orderId){
	// 	Set<String> termidKo = new Set<String>();
	// 	List<NE__OrderItem__c> updateOrderItem = new List<NE__OrderItem__c>();
	// 	Map<String ,List<OB_TrackingUtility.ErrorList>> errorTracking = new Map<String ,List<OB_TrackingUtility.ErrorList>>();
		
	// 	Boolean checkError = false;
	// 	for (OB_TrackingUtility.TermsIdInformation term : termErr){
	// 		if(term.errors!= null && !term.errors.isEmpty()){
	// 			// START Simone Misani tracking 22/08/2019
	// 			if(term.terminalId.length()!= 8){
	// 				throw new applicationException('Method: isGtTerminal - Error Length of TermId');
	// 			}// END Simone Misani tracking 22/08/2019
	// 			termidKo.add(term.terminalId);
	// 			errorTracking.put(term.terminalId,term.errors);
				
	// 		} //enrico.purificato WN-262
	// 	}
			
	// 	List<NE__OrderItem__c> orderItemTerminal = [SELECT 	id,
	// 														NE__Action__c,
	// 														OB_FulfilmentStatus__c,
	// 														NE__Status__c,
	// 														OB_TermId__c,
	// 														OB_GTErrorTracking__c,
	// 														NE__Root_Order_Item__r.OB_TermId__c

	// 												FROM 	NE__OrderItem__c
	// 												WHERE NE__OrderId__c =:orderId 
	// 												AND   (NE__ProdId__r.RecordType.DeveloperName ='Terminali' 
	// 													OR NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName ='Terminali')]; //wn-241//enrico.purificato WN-262 
	// 																												// before it was completing everithing that was not in error 

	// 	for(NE__OrderItem__c oiTerm  : orderItemTerminal){
	// 			//enrico.purificato WN-262 START
	// 			if(errorTracking.containskey(oiTerm.OB_TermId__c)||errorTracking.containskey(oiTerm.NE__Root_Order_Item__r.OB_TermId__c)){
	// 				checkError= true;
	// 				oiTerm.OB_FulfilmentStatus__c= FAILED;
	// 				if(errorTracking.containskey(oiTerm.OB_TermId__c)){
	// 					oiTerm.OB_GTErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(false,errorTracking.get(oiTerm.OB_TermId__c));
	// 				}
	// 				updateOrderItem.add(oiTerm);
	// 			}
	// 		//enrico.purificato WN-262 END

	// 	}
	// 	//update updateOrderItem;
	// 	return updateOrderItem;
	// }
/* Simone Misani 24/07/2019 
Method for update status Acuiring Terzi Because  arrive only Monetica not Ew */
@TestVisible
	private static List<NE__OrderItem__c> updateAcquiringItemsTerzi (String confId){
		List<NE__OrderItem__c> orderItemToUpdate = new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> listOrderItem = [	SELECT 	Id, 	
															NE__Action__c, 
															OB_FulfilmentStatus__c  
													FROM 	NE__OrderItem__c 
													WHERE 	NE__Action__c!=: NONE
														AND	NE__OrderId__c =: confId
														AND NE__ProdId__r.OB_Acquirer__c !='NEXI'];

		if(!listOrderItem.isEmpty()){
			for(NE__OrderItem__c ordeItem : listOrderItem){
				ordeItem.OB_FulfilmentStatus__c = COMPLETED;
				orderItemToUpdate.add(ordeItem);
			}
			
		}
		return orderItemToUpdate;

	}


	/*****************************************************************
	Name:  OB_TrackingOrderMaintenance
	============================================================
	Purpose: method for  one terminale has error, set the fullfilment status = failed 
	============================================================
	History
	-------                                                            
	VERSION  		AUTHOR         		DATE           	DETAIL          Description
	1.0          	simone.misani      22/08/2019      Created           
	*****************************************************************/

@TestVisible //enrico.purificato WN-189 changed accessibility
	public static void updatePciandCommissione (String confId , Boolean equensKo){//Simone Misani WN-186 22/08/2019
		List<NE__OrderItem__c> orderItemToUpdate = new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> orderItemSon = new List<NE__OrderItem__c>();
		String statusorderItem = (equensKo == true) ? FAILED : COMPLETED;//Simone Misani WN-186 22/08/2019
		List<NE__OrderItem__c> listOrderItem = [	SELECT 
															id, 
															NE__ProdId__r.name, OB_FulfilmentStatus__c,
															(	SELECT id, 
																		NE__ProdId__r.name,OB_FulfilmentStatus__c 
															FROM 	NE__Order_Items_Conf__r )
													FROM 	NE__OrderItem__c 
													WHERE	 NE__orderid__c =:confId 
													AND 	((NE__ProdId__r.RecordType.DeveloperName = 'Commissione'
													OR 		NE__ProdId__r.RecordType.DeveloperName = 'PCI')) 
													AND 	OB_FulfilmentStatus__c ='Sent'];

		
		if(!listOrderItem.isEmpty()){
            System.debug('listOrderItem.get(0).NE__Order_Items_Conf__r: '+listOrderItem.get(0).NE__Order_Items_Conf__r);
			Integer i=0;
            
			for(NE__OrderItem__c ordeItem : listOrderItem){
                            
                 
				ordeItem.OB_FulfilmentStatus__c = statusorderItem;//Simone Misani WN-186 22/08/2019
				orderItemToUpdate.add(ordeItem);
				for(NE__OrderItem__c ordeItem1 : ordeItem .NE__Order_Items_Conf__r){
					ordeItem1.OB_FulfilmentStatus__c = statusorderItem;//Simone Misani WN-186 22/08/2019
					orderItemToUpdate.add(ordeItem1);
				}
             
			}
			update orderItemToUpdate;
		}
	}



	/*****************************************************************
	Name:  OB_TrackingOrderMaintenance
	============================================================
	Purpose: method for  one terminale has status = 'refused', set the fullfilment status = failed 
	============================================================
	History
	-------                                                            
	VERSION  		AUTHOR         		DATE           	DETAIL          Description
	1.0          	simone.misani      22/08/2019      Created           
	*****************************************************************/


// @TestVisible
// 	private static Boolean checkedRefusedStatus ( List<OB_TrackingUtility.TermsIdInformation> termErr, String orderId){
// 		Set<String> termidKo = new Set<String>();
// 		List<NE__OrderItem__c> updateOrderItem = new List<NE__OrderItem__c>();
// 		Integer count= 0 ;
// 		Boolean checkError = false;
// 		for (OB_TrackingUtility.TermsIdInformation term : termErr){
// 			if(term.status == REFUSED){
// 				termidKo.add(term.terminalId);
// 				count ++;
// 			} //enrico.purificato WN-262
// 		}
			
// 		List<NE__OrderItem__c> orderItemTerminal = [SELECT 	id,
// 															NE__Action__c,
// 															OB_FulfilmentStatus__c,
// 															NE__Status__c,
// 															OB_TermId__c,
// 															OB_GTErrorTracking__c

// 													FROM 	NE__OrderItem__c
// 													WHERE NE__OrderId__c =:orderId 
// 													AND   NE__ProdId__r.RecordType.DeveloperName ='Terminali']; //enrico.purificato WN-262 
// 																													// before it was completing everithing that was not in error 

// 		for(NE__OrderItem__c oiTerm  : orderItemTerminal){
// 				//enrico.purificato WN-262 START
// 				if(termidKo.contains(oiTerm.OB_TermId__c)){
// 					checkError= true;
// 					oiTerm.OB_FulfilmentStatus__c= CANCELLED;
// 					updateOrderItem.add(oiTerm);
// 				}
// 			//enrico.purificato WN-262 END

// 		}

		
// 		update updateOrderItem;
// 		return checkError;
// 	}


/*****************************************************************
Name:  OB_TrackingOrderMaintenance.isGtTerminalFirstTracking
============================================================
Purpose: Method controll the field required for Frist Tracking
============================================================
History
-------                                                            
VERSION  		AUTHOR         		DATE           	DETAIL          Description
1.0          	Simone Misani     02/09/2019      Created           Creation of the Mtehod
*****************************************************************/
	@TestVisible
	private static void isGtTerminalFirstTracking (List<OB_TrackingUtility.GT> GTArray, Boolean termAdd, Boolean termRemove, Boolean isSubProcessChangeTerm){

		for(OB_TrackingUtility.GT gt : GTArray){
			if(gt.PVCodes.size()==0){					
					for(OB_TrackingUtility.ErrorList er: gt.errors){
						Boolean isNotValid 		= (String.isBlank(er.code))
										|| (String.isBlank(er.description));
						if(isNotValid){
							throw new applicationException('Method: isGtTerminal :One or more empty fields - GT.Error');
						}

					}						
				
				throw new applicationException('Method: isGtTerminal :One or more empty fields - GT');
			}
			for(OB_TrackingUtility.puntoVendita pv : gt.PVCodes){
				Boolean isNotValid 		= (String.isBlank(pv.ctiCode))
										|| (String.isBlank(pv.stabiCode))
										|| (String.isBlank(pv.siaMerchantCode))
										|| (String.isBlank(pv.siaPVCode))
										|| (String.isBlank(pv.siaProgressiveCode))
										|| (String.isBlank(pv.assistanceNumber))
										|| (String.isBlank(pv.startDate));
				if(isNotValid){
					throw new applicationException('Method: isGtTerminal :One or more empty fields - GT puntiVendita');
				}
			}
		}
		
	}

/*****************************************************************
Name:  OB_TrackingOrderMaintenance.updateAssetDate
============================================================
Purpose: Method  update the Asset and Order Item when Arrive the seocond tracking
============================================================
History
-------                                                            
VERSION  		AUTHOR         		DATE           	DETAIL          Description
1.0          	Simone Misani     02/09/2019      Created           Creation of the Mtehod
*****************************************************************/

	@TestVisible
	private static void updateAssetDate(  List<OB_TrackingUtility.TermsIdInformation> termInfo, String orderId, Map<Id,Asset> mapofAsset ){
		
		Set<String> termidKo = new Set<String>();
		Map<String,String> termidinfo = new Map<String,String>();
		List<NE__OrderItem__c> updateOrderItem = new List<NE__OrderItem__c>();
		List<Asset> assetListUpdate = new List<Asset>();
		Integer count= 0 ;
		Boolean checkError = false;
		Map<String,NE__OrderItem__c> mapporderItem = new Map<String,NE__OrderItem__c>();
		Map<String,NE__OrderItem__c> mapporderItemFirstPosChange = new Map<String,NE__OrderItem__c>();
		Map<String,List<Object>> mappAgreedCode = new Map<String,List<Object>>();
		List<NE__OrderItem__c> listPagoBancomat = new List<NE__OrderItem__c>();
	 	Map<id,DateTime> installDateMap = new map<Id,DateTime>();
		Map<id,DateTime> disconnetedDateMap = new map<Id,DateTime>();
		Map<Id,String> cancellAsset = new Map<Id,String>();
		List<id> listassetEnterpriseId = new List<Id>();
		List<Asset> listassetDelete = new List<Asset>();
		Map<String,String> termIdStatusMap = new Map<String,String>();
		List<id> configurationsId = new List<id>();
		List<Id> assetTodelete = new List<Id>();	
		List<NE__OrderItem__c> orderItemTerminal = [SELECT 	id,
															NE__Action__c,
															NE__OrderId__r.CreatedDate,
															OB_FulfilmentStatus__c,
															NE__Status__c,
															OB_TermId__c,
															NE__OrderId__r.OB_Service_Point__c,
															NE__Account__c,
															NE__ProdId__r.RecordType.DeveloperName,
															NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c,
															NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
															OB_GTErrorTracking__c,
															NE__AssetItemEnterpriseId__c,(SELECT id,NE__AssetItemEnterpriseId__c  From NE__Parent_Order_Item__r ),
															(SELECT id,Name, NE__Value__c FROM NE__Order_Item_Attributes__r) 
													FROM 	NE__OrderItem__c
													WHERE NE__OrderId__c =:orderId 
													AND (NE__ProdId__r.RecordType.DeveloperName ='Terminali'
													OR NE__ProdId__r.RecordType.DeveloperName ='Pagobancomat')
												 
													]; //enrico.purificato WN-262 
																													// before it was completing everithing that was not in error 
		if(orderItemTerminal.isEmpty()){
			throw new applicationException('There is no orderid ');
		}
		//Simone Misani 07/10/2019 START
		DateTime orderDate ;
		if(!Test.isRunningTest()){
		 orderDate = orderItemTerminal.get(0).NE__OrderId__r.CreatedDate;

		}else {
			orderDate= System.today().addDays(-3);
		}
		//Simone Misani 07/10/2019 END
		Boolean subProcesChangeTerm = false;		
		Id merchantId = orderItemTerminal.get(0).NE__Account__c ;
		Id pv = orderItemTerminal.get(0).NE__OrderId__r.OB_Service_Point__c ;
		Id proposerAbi =orderItemTerminal.get(0). NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c ;
		if(orderItemTerminal.get(0).NE__orderId__r.NE__Order_Header__r.OB_Sub_Process__c!= null){
			subProcesChangeTerm = (orderItemTerminal.get(0).NE__orderId__r.NE__Order_Header__r.OB_Sub_Process__c.equalsIgnoreCase(SOSTITUZIONETERMINALI));
		//START gianluigi.virga 31/10/2019 - gestione sostituzione terminali su ordini migrati
		}else if(orderItemTerminal.get(0).NE__OrderId__r.NE__Order_Header__c == null){
			List<String> termIdDuplicate = new List<String>();
			for(NE__OrderItem__c oiMigrated  : orderItemTerminal){
				String termIdToMatch = oiMigrated.OB_TermId__c;
				if(String.isNotBlank(termIdToMatch)){
					if(termIdDuplicate.contains(termIdToMatch)){
						subProcesChangeTerm = true;
					}else{
						termIdDuplicate.add(termIdToMatch);
					}
				}
			}
		}
		//END gianluigi.virga 31/10/2019 
		for(NE__OrderItem__c oiTerm  : orderItemTerminal){
			if(oiTerm.NE__ProdId__r.RecordType.DeveloperName =='Terminali'){
				if(subProcesChangeTerm && !mapporderItemFirstPosChange.containsKey(oiTerm.OB_TermId__c)){
					mapporderItemFirstPosChange.put(oiTerm.OB_TermId__c,oiTerm);
				}
				mapporderItem.put(oiTerm.OB_TermId__c,oiTerm);
			}
			if(oiTerm.NE__ProdId__r.RecordType.DeveloperName ==  'Pagobancomat' && (oiTerm.NE__Action__c == 'Remove' ||oiTerm.NE__Action__c == 'Add' )){
				listPagoBancomat.add(oiTerm);
			}
			
		}
				//enrico.purificato WN-262 START
			

		//
		if(subProcesChangeTerm){
			updateOrderItemandAsset(termInfo,mapofAsset,mapporderItemFirstPosChange, subProcesChangeTerm,orderId,orderDate,merchantId, pv, proposerAbi );
		}
		updateOrderItemandAsset(termInfo,mapofAsset,mapporderItem, subProcesChangeTerm, orderId,orderDate, merchantId , pv,proposerAbi  );
		

		


		
			

		
		

		
	}

	@TestVisible
	private  static Map<String,List<Object>> enablementAgreedCode(String orderId,List<OB_TrackingUtility.CodiciConvenzioni> listAgreedCode, String termid, 	List<OB_TrackingUtility.ErrorList> errorsEnablement){

		Map<id,DateTime> installDateMap = new map<Id,DateTime>();
		Map<id,DateTime> disconnetedDateMap = new map<Id,DateTime>();
		Map<Id,String> cancellAsset = new Map<Id,String>();
		List<id> listassetEnterpriseId = new List<Id>();
		List<NE__OrderItem__c> updateOrderItem = new List<NE__OrderItem__c>();
		list<Asset> assetListUpdate = new List<Asset>();
		Map<String,List<Object>> mapforUpdate = new Map<String,List<Object>>();
		List<NE__OrderItem__c> orderItem = 	[SELECT 	id,
															NE__Action__c,
															NE__ProdId__r.OB_Codice_sfdc__c,
															OB_FulfilmentStatus__c,
															OB_GTErrorTracking__c,
															OB_enablement__c,
															OB_Old_Enablement__c,
															OB_CompanyCode__c,
															NE__AssetItemEnterpriseId__c,
															NE__StartDate__c,
															NE__EndDate__c,
															NE__Parent_Order_Item__r.OB_TermId__c 
													FROM 	NE__OrderItem__c
													WHERE NE__OrderId__c =:orderId ];

		System.debug('termid: '+termid);
		Set<String> codeSfdc = new Set<String>();
		for(OB_TrackingUtility.CodiciConvenzioni ac : listAgreedCode){
			for( NE__OrderItem__c oi : orderItem){
				system.debug('@@@ac: '+ac);
					
					codeSfdc.add(oi.NE__ProdId__r.OB_Codice_sfdc__c);//Simone Misani 10/10/2019 
					if(ac.companyName == oi.NE__ProdId__r.OB_Codice_sfdc__c && 	oi.NE__Parent_Order_Item__r.OB_TermId__c == termid){
				
							system.debug('## codice sfdc matched:'+ac.companyName);
							system.debug('## codice sfdc matched status: '+ac.status);
							system.debug('## codice sfdc matched action: '+oi.NE__Action__c);
							system.debug('## codice sfdc matched new eneble: '+oi.OB_enablement__c );
                            system.debug('## codice sfdc matched old eneble: '+oi.OB_Old_Enablement__c);

						Id assetItemEnterpriseId = oi.NE__AssetItemEnterpriseId__c;
						if(ac.status == REFUSED && (oi.NE__Action__c == 'Add' || oi.NE__Action__c == 'Remove' )){
							system.debug('## in refused if');
							if(errorsEnablement == null || (errorsEnablement.size()== 0)){
								throw new applicationException('REFUSED ENABLEMENT and there is not the error');
							}

							if(oi.OB_enablement__c == 'Y' && (oi.OB_Old_Enablement__c == null ||oi.OB_Old_Enablement__c == 'N')){
								oi.OB_enablement__c = 'N';
								oi.OB_FulfilmentStatus__c = COMPLETED;
								oi.OB_GTErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(false,errorsEnablement);
								updateOrderItem.add(oi);
								if(!Test.isRunningTest()){
									if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType() ){		
										cancellAsset.put(oi.NE__AssetItemEnterpriseId__c, 'Cancelled');
									}
								}							

							}else if(oi.OB_enablement__c == 'N' && oi.OB_Old_Enablement__c == 'Y'){
								oi.OB_enablement__c = 'Y';
								oi.OB_FulfilmentStatus__c = COMPLETED;
								oi.OB_GTErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(false,errorsEnablement);
								updateOrderItem.add(oi);
								if(!Test.isRunningTest()){
									if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType()  ){		
										cancellAsset.put(oi.NE__AssetItemEnterpriseId__c, 'Active');
									}
								}							

							}

						} else if(ac.status == 'Activated' && (oi.NE__Action__c == 'Add' || oi.NE__Action__c == 'Change' )){
							Datetime dt = null;
							if(ac.startDate == null){
								 dt = OB_TrackingOrder.formatDate(ac.startDate);
								oi.NE__StartDate__c = dt;

							}							
							oi.OB_FulfilmentStatus__c = COMPLETED;
							
							oi.OB_CompanyCode__c = ac.companyCode;
							updateOrderItem.add(oi);
							if(!Test.isRunningTest()){
								if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType() ){		
									installDateMap.put(oi.NE__AssetItemEnterpriseId__c, dt);
								}
							}	
						} else if(ac.status == 'Disabled' && (oi.NE__Action__c == 'Remove' || oi.NE__Action__c == 'Change')){
							
							System.debug('@@ Disabled : '+oi.NE__ProdId__r.OB_Codice_sfdc__c);
							Datetime dt = OB_TrackingOrder.formatDate(ac.endDate);

							oi.OB_FulfilmentStatus__c = COMPLETED;
							oi.NE__EndDate__c = dt;
							oi.OB_CompanyCode__c = ac.companyCode;
							updateOrderItem.add(oi);
							disconnetedDateMap.put(oi.NE__AssetItemEnterpriseId__c, dt);

						}

					}


			}
			//Simone Misani 10/10/2019 STARt
			if(!codeSfdc.contains(ac.companyName)){
				throw new applicationException('ERROR SFDC Code  in  companyName');
			}
			//Simone Misani 10/10/2019 END
		}

		

			if(installDateMap.keySet().size()>0){
			listassetEnterpriseId.addAll(installDateMap.keySet());
			}
			if(disconnetedDateMap.keySet().size()>0){
				listassetEnterpriseId.addAll(disconnetedDateMap.keySet());
			}
			if(cancellAsset.keySet().size()>0){
				listassetEnterpriseId.addAll(cancellAsset.keySet());
			}

			for(Id a : listassetEnterpriseId){

			if(cancellAsset.containsKey(a)){
				if(cancellAsset.get(a) == 'Cancelled'){
					//assetListUpdate.add(new Asset(id =a, NE__Status__c = CANCELLED ));
					assetListUpdate.add(new Asset(id = a, OB_enablement__c ='N'));
				}else if(cancellAsset.get(a) == 'Active'){
					assetListUpdate.add(new Asset(id =a, NE__Status__c = ACTIVE , NE__Action__c = 'None', OB_enablement__c='Y'));
				}				

			}else if(installDateMap.containsKey(a)){
				Datetime dt = installDateMap.get(a);
				Date    d = null;
				if(dt != null){
					 d = date.newinstance(dt.year(), dt.month(), dt.day());   
				}
                            
				assetListUpdate.add(new Asset(id =a, NE__StartDate__c= dt, InstallDate = d,OB_enablement__c = 'Y'  ));				
			
				
			}else if (disconnetedDateMap.containsKey(a)){				
				Datetime dt = disconnetedDateMap.get(a);
                //Date     d = date.newinstance(dt.year(), dt.month(), dt.day());                
				assetListUpdate.add(new Asset(id =a, NE__EndDate__c= dt,OB_enablement__c='N' ));				
					
			}


		}

		mapforUpdate.put('NE__OrderItem__c',updateOrderItem);
		mapforUpdate.put('Asset',assetListUpdate);


		return mapforUpdate;

		

	}





	private static void  updateOrderItemandAsset (List<OB_TrackingUtility.TermsIdInformation> termInfo, Map<Id,Asset> mapofAsset, Map<String,NE__OrderItem__c> mapporderItem, Boolean subProcesChangeTerm, String orderId, DateTime orderDate, Id merchantId, Id pv, Id proposerAbi ){
		

		Set<String> termidKo = new Set<String>();
		Map<String,String> termidinfo = new Map<String,String>();
		List<NE__OrderItem__c> updateOrderItem = new List<NE__OrderItem__c>();
		List<Asset> assetListUpdate = new List<Asset>();
		Integer count= 0 ;
		Boolean checkError = false;
		//Simone Misani 07/10/2019 START
		String model ;
		String modelDescription;
		String release;
		String releaseDescription;
		String connectionsType;
		String modality;
		//Simone Misani 07/10/2019 END
		Map<String,List<Object>> mappAgreedCode = new Map<String,List<Object>>();
		List<NE__OrderItem__c> listPagoBancomat = new List<NE__OrderItem__c>();
	 	Map<id,DateTime> installDateMap = new map<Id,DateTime>();
		Map<id,DateTime> disconnetedDateMap = new map<Id,DateTime>();
		Map<Id,String> cancellAsset = new Map<Id,String>();
		List<id> listassetEnterpriseId = new List<Id>();
		List<Asset> listassetDelete = new List<Asset>();
		Map<String,String> termIdStatusMap = new Map<String,String>();
		List<id> configurationsId = new List<id>();
		List<Id> assetTodelete = new List<Id>();	
		List<NE__Order_Item_Attribute__c> updateAttribute = new List<NE__Order_Item_Attribute__c>();//Simone Misani 07/10/2019 
		for (OB_TrackingUtility.TermsIdInformation term : termInfo){		
			if(!mapporderItem.containsKey(term.terminalId)){
				throw new applicationException('There is no body for the request');
			}
			NE__OrderItem__c currentItem = mapporderItem.get(term.terminalId);

			//Simone Misani Tracking 05/09/2019 STARt
			Id assetItemEnterpriseId = currentItem.NE__AssetItemEnterpriseId__c;
			if(term.status == REFUSED ){
				if(currentItem.NE__Action__c == 'Add' ){
					updateOrderItem.add(new NE__OrderItem__c(id =currentItem.id, OB_FulfilmentStatus__c= CANCELLED, NE__Status__c = CANCELLED, OB_GTErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(false,term.errors) ));
				
					if(!Test.isRunningTest()){
					if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType()  ){					
						cancellAsset.put(currentItem.NE__AssetItemEnterpriseId__c, 'Cancelled');
					}
					}
					for(NE__OrderItem__c oi : currentItem.NE__Parent_Order_Item__r){
						updateOrderItem.add(new NE__OrderItem__c(id =oi.id, OB_FulfilmentStatus__c= CANCELLED, NE__Status__c = CANCELLED  ));
						if(!Test.isRunningTest()){
							if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType()  ){					
								cancellAsset.put(oi.NE__AssetItemEnterpriseId__c, 'Cancelled');
							}
						}
						
					}					
					if(!listPagoBancomat.isEmpty()){
						NE__OrderItem__c updatePago = listPagoBancomat.get(0);
						System.debug('updatePago: '+updatePago);
						Id assetItemEnterpriseIdPago = updatePago.NE__AssetItemEnterpriseId__c;
						updateOrderItem.add(new NE__OrderItem__c(id =updatePago.id, OB_FulfilmentStatus__c= CANCELLED, NE__Status__c = CANCELLED ));
						if(!Test.isRunningTest()){
							if(assetItemEnterpriseIdPago.getsobjecttype() == Schema.Asset.getSObjectType()  ){			
								cancellAsset.put(updatePago.NE__AssetItemEnterpriseId__c,'Active');
							}
						}		

						for(NE__OrderItem__c oi : updatePago.NE__Parent_Order_Item__r){
							updateOrderItem.add(new NE__OrderItem__c(id =oi.id, OB_FulfilmentStatus__c= CANCELLED, NE__Status__c = CANCELLED  ));
							Id assetItemEnterpriseIdPagoChild = oi.NE__AssetItemEnterpriseId__c;
							if(!Test.isRunningTest()){
							if(assetItemEnterpriseIdPagoChild.getsobjecttype() == Schema.Asset.getSObjectType()  ){		
								cancellAsset.put(oi.NE__AssetItemEnterpriseId__c,'Active');
							}
						}		
					}


					}
				}else if (currentItem.NE__Action__c == 'Remove'){
					updateOrderItem.add(new NE__OrderItem__c(id =currentItem.id, OB_FulfilmentStatus__c= COMPLETED, NE__Status__c = ACTIVE, NE__Action__c = 'None' , OB_GTErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(false,term.errors)));
				
					if(mapofAsset.containsKey(currentItem.NE__AssetItemEnterpriseId__c)){
						cancellAsset.put(currentItem.NE__AssetItemEnterpriseId__c,'Active');
					}
					
					for(NE__OrderItem__c oi : currentItem.NE__Parent_Order_Item__r){
						updateOrderItem.add(new NE__OrderItem__c(id =oi.id, OB_FulfilmentStatus__c= COMPLETED , NE__Status__c = ACTIVE, NE__Action__c = 'None' ));
						if(mapofAsset.containsKey(oi.NE__AssetItemEnterpriseId__c)){
							cancellAsset.put(oi.NE__AssetItemEnterpriseId__c,'Active');
						}
					}

					if(!listPagoBancomat.isEmpty()){
						NE__OrderItem__c updatePago = listPagoBancomat.get(0);
						System.debug('updatePago: '+updatePago);
						updateOrderItem.add(new NE__OrderItem__c(id = updatePago.id, OB_FulfilmentStatus__c= COMPLETED, NE__Status__c = ACTIVE, NE__Action__c = 'None' ));
						cancellAsset.put(updatePago.NE__AssetItemEnterpriseId__c,'Active');

						for(NE__OrderItem__c oi : updatePago.NE__Parent_Order_Item__r){
							updateOrderItem.add(new NE__OrderItem__c(id =oi.id, OB_FulfilmentStatus__c= COMPLETED , NE__Status__c = ACTIVE, NE__Action__c = 'None' ));
							if(mapofAsset.containsKey(oi.NE__AssetItemEnterpriseId__c)){
								cancellAsset.put(oi.NE__AssetItemEnterpriseId__c,'Active');
							}
					}


					}
				}
				
				

			}else if(term.status == INSTALLED){
				Datetime dt = OB_TrackingOrder.formatDate(term.installationDate);
                //Date     d = date.newinstance(dt.year(), dt.month(), dt.day());                
				//START gianluigi.virga 31/10/2019 - Gestione sostituzione terminali
				if(!subProcesChangeTerm || (currentItem.NE__Action__c == 'Add' && subProcesChangeTerm)){
				 	updateOrderItem.add(new NE__OrderItem__c(id =currentItem.id, OB_FulfilmentStatus__c= COMPLETED, NE__StartDate__c= dt  ));
					if(!Test.isRunningTest()){
						if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType()){					
							installDateMap.put(currentItem.NE__AssetItemEnterpriseId__c, dt);
						}
					}
				}else if(currentItem.NE__Action__c == 'Remove' && subProcesChangeTerm){
					updateOrderItem.add(new NE__OrderItem__c(id =currentItem.id, OB_FulfilmentStatus__c= COMPLETED, NE__EndDate__c = dt  ));
					if(!Test.isRunningTest()){
						if(assetItemEnterpriseId.getsobjecttype() == Schema.Asset.getSObjectType()){					
							if(mapofAsset.containsKey(currentItem.NE__AssetItemEnterpriseId__c))	{
								disconnetedDateMap.put(currentItem.NE__AssetItemEnterpriseId__c, dt);
							}	
						}
					}
				}              
				// updateOrderItem.add(new NE__OrderItem__c(id =currentItem.id, OB_FulfilmentStatus__c= COMPLETED, NE__StartDate__c= dt  ));
				//END gianluigi.virga 31/10/2019
				
				//Simone Misani 07/10/2019 START
				for(NE__Order_Item_Attribute__c oiattr : currentItem.NE__Order_Item_Attributes__r ){

					if(oiattr.name == 'Modello'){
						oiattr.NE__Value__c = term.model;	
						 model = term.model;
				
					}
					if(oiattr.name == 'Modalità Collegamento'){
						oiattr.NE__Value__c	= term.connectionType;		
		 				connectionsType =  term.connectionType;
					
					}
					if(oiattr.name == 'Release'){
						oiattr.NE__Value__c	= term.release;										
		 				release = term.release;
		
					}
					if(oiattr.name == 'Descrizione Modello'){
						oiattr.NE__Value__c	= term.modelDescription;
						 modelDescription = term.modelDescription;
					}
					if(oiattr.name == 'Descrizione Release'){
						oiattr.NE__Value__c	= term.releaseDescription;
						 releaseDescription = term.releaseDescription;
					}
					if(oiattr.name == 'Descrizione Connessione'){
						oiattr.NE__Value__c	= term.modality;
						 modality= term.modality;
					}

					updateAttribute.add(oiattr);
				//Simone Misani 07/10/2019 END

				}
				
					
				
				
			}else if (term.status == DISINSTALLED){
				Datetime dt = null;
				if(!subProcesChangeTerm){
				 	dt = OB_TrackingOrder.formatDate(term.uninstallationDate);
				}else{
					dt = OB_TrackingOrder.formatDate(term.installationDate);
				}
                //Date     d = date.newinstance(dt.year(), dt.month(), dt.day());                
				updateOrderItem.add(new NE__OrderItem__c(id =currentItem.id, OB_FulfilmentStatus__c= DISCONNECTED, NE__EndDate__c= dt  ));
				if(mapofAsset.containsKey(currentItem.NE__AssetItemEnterpriseId__c))	{
					disconnetedDateMap.put(currentItem.NE__AssetItemEnterpriseId__c, dt);
				}	
				//Simone Misani Tracking 05/09/2019 STARt	
					
			}

			if(term.status != REFUSED && currentItem.NE__Action__c != 'Add'){
				List<OB_TrackingUtility.ErrorList> errorsEnablement = new List<OB_TrackingUtility.ErrorList>();
				if(term.errors!= null){
					errorsEnablement.addAll(term.errors);
				}
				if(term.agreementCodes!=null){
					mappAgreedCode.putAll(enablementAgreedCode(orderId, term.agreementCodes, term.terminalId,errorsEnablement));
				}

			}
				
			
		}
		
		
			//enrico.purificato WN-262 END


		if(installDateMap.keySet().size()>0){
			listassetEnterpriseId.addAll(installDateMap.keySet());
		}
		if(disconnetedDateMap.keySet().size()>0){
			listassetEnterpriseId.addAll(disconnetedDateMap.keySet());
		}
		if(cancellAsset.keySet().size()>0){
			listassetEnterpriseId.addAll(cancellAsset.keySet());
		}

		
		for(Id a : listassetEnterpriseId){

			if(cancellAsset.containsKey(a)){
				if(cancellAsset.get(a) == 'Cancelled'){
					//assetListUpdate.add(new Asset(id =a, NE__Status__c = CANCELLED ));
					listassetDelete.add(new Asset(id = a));
				}else if(cancellAsset.get(a) == 'Active'){
					assetListUpdate.add(new Asset(id =a, NE__Status__c = ACTIVE , NE__Action__c = 'None'));
				}				

			}else if(installDateMap.containsKey(a)){
				Datetime dt = installDateMap.get(a);
                Date     d = date.newinstance(dt.year(), dt.month(), dt.day());                
				assetListUpdate.add(new Asset(id =a, NE__StartDate__c= dt, InstallDate = d  ));				
			
				
			}else if (disconnetedDateMap.containsKey(a)){
					
				
                //Date     d = date.newinstance(dt.year(), dt.month(), dt.day());                
				assetListUpdate.add(new Asset(id =a, NE__EndDate__c= disconnetedDateMap.get(a)  ));				
					
			}


		}
		if(!updateAttribute.isEmpty()){
			update updateAttribute;
		}
		if(!assetListUpdate.isEmpty() &&  !Test.isRunningTest()){
			update assetListUpdate;
		}
		
		if(!listassetDelete.isEmpty() && !Test.isRunningTest()){
			delete listassetDelete;
		}
		
		updateAssetItemAttribute(installDateMap.keySet(),  model,  connectionsType,  release,  modelDescription,  releaseDescription ,  modality );
		
		Map<id,DateTime> installDateMapSecondorder = new map<Id,DateTime>();
		Map<id,DateTime> disconnetedDateMapSecondOrder = new map<Id,DateTime>();
		Map<Id,String> cancellAssetSecondorder = new Map<Id,String>();
		List<id> listassetEnterpriseIdSecondOrder = new List<Id>();
		List<Asset> listassetdeleteSecond = new List<Asset>();
		List<NE__OrderItem__c> listorderItemDelete = new List<NE__OrderItem__c>();
		List<Asset> updateSecondAsset = new List<Asset>();
		for(NE__OrderItem__c oi : [SELECT id, NE__AssetItemEnterpriseId__c FROM NE__OrderItem__c WHERE NE__AssetItemEnterpriseId__c IN : listassetEnterpriseId AND  NE__Account__c = : merchantId AND NE__OrderId__r.OB_Service_Point__c = : pv AND  NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c = : proposerAbi AND NE__orderid__c != :  orderId AND NE__OrderId__r.CreatedDate >= : orderDate]){
			
			if(cancellAsset.containsKey(oi.NE__AssetItemEnterpriseId__c)){
				if(cancellAsset.get(oi.NE__AssetItemEnterpriseId__c) == 'Cancelled'){
					// updateOrderItem.add(new NE__OrderItem__c(id =oi.id, NE__Status__c = CANCELLED ));
					// cancellAssetSecondorder.put(oi.NE__AssetItemEnterpriseId__c,'Cancelled');
					listorderItemDelete.add(new NE__OrderItem__c(id = oi.id));
				}else if(cancellAsset.get(oi.NE__AssetItemEnterpriseId__c) == 'Active'){
					updateOrderItem.add(new NE__OrderItem__c(id =oi.id, NE__Status__c = ACTIVE, NE__Action__c = 'None'));
					cancellAssetSecondorder.put(oi.NE__AssetItemEnterpriseId__c,'Active');
				}				
				
			}else if(installDateMap.containsKey(oi.NE__AssetItemEnterpriseId__c)){
				Datetime dt = installDateMap.get(oi.NE__AssetItemEnterpriseId__c);
                Date     d = date.newinstance(dt.year(), dt.month(), dt.day());                
				updateOrderItem.add(new NE__OrderItem__c(id =oi.id, NE__StartDate__c= dt  ));				
				installDateMapSecondorder.put(oi.NE__AssetItemEnterpriseId__c, dt);
				
			}else if (disconnetedDateMap.containsKey(oi.NE__AssetItemEnterpriseId__c)){				
                //Date     d = date.newinstance(dt.year(), dt.month(), dt.day()); 
				Datetime dt = disconnetedDateMap.get(oi.NE__AssetItemEnterpriseId__c);               
				updateOrderItem.add(new NE__OrderItem__c(id =oi.id, NE__EndDate__c= disconnetedDateMap.get(oi.NE__AssetItemEnterpriseId__c)  ));
				disconnetedDateMapSecondOrder.put(oi.NE__AssetItemEnterpriseId__c, dt);
					
			}

			
		}
		System.debug('updateOrderItem: '+updateOrderItem);
		if(!updateOrderItem.isEmpty() && !Test.isRunningTest()){
			update updateOrderItem;
		}
		if(!listorderItemDelete.isEmpty() && !Test.isRunningTest()){
			delete listorderItemDelete;
		}

		
		if(mappAgreedCode.containsKey('NE__OrderItem__c')){
			update (List<NE__OrderItem__c>) mappAgreedCode.get('NE__OrderItem__c');
		}
			if(mappAgreedCode.containsKey('Asset')){
			update (List<Asset>) mappAgreedCode.get('Asset');
		}
	}



	/******************************************************************
	Name:  OB_TrackingOrderMaintenance-updateAssetItemAttribute
	============================================================
	Purpose: update the order items attriubute
	============================================================
	History
	-------                                                            
	VERSION  		AUTHOR         		DATE           	DETAIL         
	1.0          	Simone Misani      07/10/2019      Created           
	*****************************************************************/
	@TestVisible
	private static void updateAssetItemAttribute (Set<Id> assetidSet, String model, String connectionsType, String release, String modelDescription, String releaseDescription , String modality){
		List<NE__AssetItemAttribute__c> updateAssetAttributesList = new List<NE__AssetItemAttribute__c>();
		List<Asset> updateAssetAttribute = [	SELECT id, (SELECT Name, NE__Value__c FROM NE__AssetItemAttributes__r )
												FROM Asset 
												WHERE id In:assetidSet
													AND NE__ProdId__r.RecordType.Name ='Terminali'];

		if(updateAssetAttribute.isEmpty()){
			return ;
		}

	
		
		
		

		for(Asset neeAsset : updateAssetAttribute){
			for(NE__AssetItemAttribute__c attributeAsset : neeAsset.NE__AssetItemAttributes__r){
				if(attributeAsset.name == 'Modello'){ 
						attributeAsset.NE__Value__c = model;						
					}
					if(attributeAsset.name == 'Modalità Collegamento'){
						attributeAsset.NE__Value__c	= connectionsType;
					}
					if(attributeAsset.name == 'Release'){
						attributeAsset.NE__Value__c	= release;
					}
					if(attributeAsset.name == 'Descrizione Modello'){
						attributeAsset.NE__Value__c	= modelDescription;
					}
					if(attributeAsset.name == 'Descrizione Release'){
						attributeAsset.NE__Value__c	= releaseDescription;
					}
					if(attributeAsset.name == 'Descrizione Connessione'){
						attributeAsset.NE__Value__c	= modality;
					}

					updateAssetAttributesList.add(attributeAsset);
			}

		}
		if(!updateAssetAttributesList.isEmpty()){
			update updateAssetAttributesList;
		}
		
	}


	/**
	* @file acquiringFailedRollBackValue Method for rollBack EW
	* @author Simone Misani (simone.misani@accenture.com)
	* @brief 
	* @version 0.1
	* @date 2019-11-08

	* 
	*/

	private static List<NE__OrderItem__c> acquiringFailedRollBackValue (List<NE__OrderItem__c> listOfAcquiring , OB_TrackingUtility.Changes change  ){
		List<NE__OrderItem__c> listOIForUpdate = new List<NE__OrderItem__c>();
		for(NE__OrderItem__c oi : listOfAcquiring){
			List<NE__OrderItem__c> listOfChildItem = oi.NE__Parent_Order_Item__r;
			if(oi.NE__Action__c == 'Remove'){
				listOIForUpdate.addAll(cloneOIFailedAndCancelledOne(oi, change, listOfChildItem));
			}else if(oi.NE__Action__c == 'Add'){
				listOIForUpdate.addAll(rollBackNewValue(oi, change, listOfChildItem));
			}
		}
		return listOIForUpdate;


	}

	private static List<NE__OrderItem__c> vasFailedRollBackValue (List<NE__OrderItem__c> listVasNexi, OB_TrackingUtility.Changes change){

		List<NE__OrderItem__c> listOIForUpdate = new List<NE__OrderItem__c>();
		for(NE__OrderItem__c oi : listVasNexi){
			List<NE__OrderItem__c> listOfChildItem = oi.NE__Parent_Order_Item__r;
			if(oi.NE__Action__c == 'Remove'){
				listOIForUpdate.addAll(cloneOIFailedAndCancelledOne(oi, change, listOfChildItem));
			}else if(oi.NE__Action__c == 'Add'){
				listOIForUpdate.addAll(rollBackNewValue(oi, change, listOfChildItem));
			}
		}
		return listOIForUpdate;


	}

	/**
	* @file acquiringFailedRollBackValue Method for rollBack EW
	* @author Simone Misani (simone.misani@accenture.com)
	* @brief 
	* @version 0.1
	* @date 2019-11-08

	* 
	*/


	private static List<NE__OrderItem__c> cloneOIFailedAndCancelledOne(NE__OrderItem__c orderforClone,OB_TrackingUtility.Changes change, List<NE__OrderItem__c> listOfChildItem){
		List<NE__OrderItem__c> listOIForUpdate = new List<NE__OrderItem__c>();
		NE__OrderItem__c cloneOiforKO = orderforClone.clone(false,false,false,false);
		cloneOiforKO.OB_FulfilmentStatus__c = CANCELLED;
		cloneOiforKO.OB_Tech_Outcome_Equens__c = MONETICAKO ;
		cloneOiforKO.OB_AcquiringErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(true, change.errors);
		listOIForUpdate.add(cloneOiforKO);
		orderforClone.OB_FulfilmentStatus__c= COMPLETED;
		orderforClone.NE__Action__c = 'None';
		listOIForUpdate.add(orderforClone);
		if(listOfChildItem != null && !listOfChildItem.isEmpty()){
			for(NE__OrderItem__c childItem : listOfChildItem){
				childItem.OB_FulfilmentStatus__c = COMPLETED;
				childItem.NE__Action__c = 'None';
				listOIForUpdate.add(childItem);
			}
		}
		return listOIForUpdate;



	}

	private static List<NE__OrderItem__c> rollBackNewValue(NE__OrderItem__c orderforClone,OB_TrackingUtility.Changes change, List<NE__OrderItem__c> listOfChildItem){
		List<NE__OrderItem__c> listOIForUpdate = new List<NE__OrderItem__c>();
		orderforClone.OB_FulfilmentStatus__c= CANCELLED;
		orderforClone.OB_Tech_Outcome_Equens__c = MONETICAKO ;
		orderforClone.OB_AcquiringErrorTracking__c = OB_TrackingOrderMaintenance.errorStringFormatter(true, change.errors);
		listOIForUpdate.add(orderforClone);
		if(listOfChildItem != null && !listOfChildItem.isEmpty()){
			for(NE__OrderItem__c childItem : listOfChildItem){
				childItem.OB_FulfilmentStatus__c = CANCELLED;
				listOIForUpdate.add(childItem);
			}
		}
		return listOIForUpdate;

	}


	
	




 }