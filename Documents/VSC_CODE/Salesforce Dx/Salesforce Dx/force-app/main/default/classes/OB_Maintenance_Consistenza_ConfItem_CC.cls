global class OB_Maintenance_Consistenza_ConfItem_CC
{	
	public class trkResponse {
		@AuraEnabled public Integer errorCode { get; set; }
		@AuraEnabled public String errorMessage { get; set; }
		trkResponse(){
			this.errorCode = 0;
			this.errorMessage ='';
		}
	}




	@AuraEnabled
	public static trkResponse saveAndSetTrackingGT(Map<String,String> wrapperPar,List<Object> enablementsList) 
	{
		trkResponse res = new trkResponse();
		System.debug('@wrapperPar : ' + wrapperPar);
		// TrackingWrapper wrapper = (TrackingWrapper) JSON.deserializeUntyped(wrapperPar);
		OB_TrackingOrder track = new OB_TrackingOrder();
		OB_TrackingOrder.TrackingOrderRequest req = new OB_TrackingOrder.TrackingOrderRequest();

		//	TrackingOrderRequest
		req.idOrdineSfdc 						= wrapperPar.get('idOrdineSfdc');
		req.Acquiring 							= null;//new List<OB_TrackingOrder.Acquiring>();  
		req.GT  								= new List<OB_TrackingOrder.GT>();
		OB_TrackingOrder.GT currentGT			= new OB_TrackingOrder.GT();
		OB_TrackingOrder.Acquiring currentAcq 	= new OB_TrackingOrder.Acquiring();
		currentGT.sistemaSorgente 				= wrapperPar.get('sistemaSorgente');
		currentGT.statoProvisioning 			= wrapperPar.get('statoProvisioning');
		currentGT.codiceCliente 				= wrapperPar.get('codiceCliente');
		currentGT.puntiVendita 					= new List<OB_TrackingOrder.puntoVendita>();

		OB_TrackingOrder.TermsIdInformation currentTermsIdInfo 		= new OB_TrackingOrder.TermsIdInformation();
		OB_TrackingOrder.CodiciConvenzioni currentcodiceConvenzione = new OB_TrackingOrder.CodiciConvenzioni();

		OB_TrackingOrder.puntoVendita currentPV 	= new OB_TrackingOrder.puntoVendita();
		currentPV.termsIdInformations  				= new List<OB_TrackingOrder.TermsIdInformation>();
		currentTermsIdInfo.codiciconvenzioni 		= new List<OB_TrackingOrder.CodiciConvenzioni>();


		// currentcodiceConvenzione.idItemSalesforce 	= wrapperPar.get('confId');	
		// currentcodiceConvenzione.companyCode 		= wrapperPar.get('companyCode');				
		// currentcodiceConvenzione.companyName 		= wrapperPar.get('companyName');				
		// currentcodiceConvenzione.codiceConvenzione 	= wrapperPar.get('codiceConvenzione');			
		// currentcodiceConvenzione.dataInizio 		= wrapperPar.get('startDateVas');				
		// currentcodiceConvenzione.dataFine 			= wrapperPar.get('endDateVas');
		currentTermsIdInfo.termId 					= wrapperPar.get('termId');
		currentTermsIdInfo.modello 					= wrapperPar.get('modello');
		currentTermsIdInfo.descrizioneModello 		= wrapperPar.get('descrizioneModello');
		System.debug('descrizioneModello is : ' + currentTermsIdInfo.descrizioneModello);
		currentTermsIdInfo.descrizioneRelease 		= wrapperPar.get('descrizioneRelease');
		currentTermsIdInfo.descrizioneConnessione 	= wrapperPar.get('descrizioneConnessione');
		currentTermsIdInfo.release 					= wrapperPar.get('release');
		currentTermsIdInfo.modalitaCollegamento 	= wrapperPar.get('modalitaCollegamento');
		System.debug('currentTermsIdInfo.modalitaCollegamento is : ' + currentTermsIdInfo.modalitaCollegamento);
		currentTermsIdInfo.statoInstallazione 		= wrapperPar.get('statoInstallazione');
		System.debug('currentTermsIdInfo.statoInstallazione is : ' + currentTermsIdInfo.statoInstallazione);
		currentTermsIdInfo.causaleRifiuto 			= wrapperPar.get('causaleRifiuto');
		currentTermsIdInfo.dataInstallazione 		= wrapperPar.get('dataInstallazione');
		System.debug('currentTermsIdInfo.dataInstallazione is : ' + currentTermsIdInfo.dataInstallazione);
		currentTermsIdInfo.dataDisinstallazione 	= wrapperPar.get('dataDisinstallazione');
		currentPV.itemId							= wrapperPar.get('itemId');
		currentPV.codicePuntoVendita				= wrapperPar.get('codicePuntoVendita');
		currentPV.dataInizio						= wrapperPar.get('dataInstallazione');
		currentPV.dataCessazione					= wrapperPar.get('dataDisinstallazione');
		currentPV.causaleCessazione					= wrapperPar.get('causaleCessazione');
		currentPV.tipo								= wrapperPar.get('tipo');
		currentPV.codiceCTI							= wrapperPar.get('codiceCTI');
		currentPV.codiceStabilimento				= wrapperPar.get('codiceStabilimento');
		currentPV.codiceStabilimentoSIA				= wrapperPar.get('codiceStabilimentoSIA');
		currentPV.codiceProgressivoSIA				= wrapperPar.get('codiceProgressivoSIA');
		currentPV.codiceSIA							= wrapperPar.get('codiceSIA');
		currentPV.numeroAssistenzaPOS				= '';
		currentPV.dataInizioAttivita				= wrapperPar.get('dataInstallazione');

		// currentAcq.sistemaSorgente 	= wrapperPar.get('sistemaSorgente');
		// currentAcq.codiceSocieta	= wrapperPar.get('companyCode');
		// currentAcq.puntiVendita.add(currentPV);
		//currentTermsIdInfo.codiciconvenzioni.add(currentcodiceConvenzione);
		currentPV.termsIdInformations.add(currentTermsIdInfo);
		currentGT.puntiVendita.add(currentPV);

		req.GT.add(currentGT);
		System.debug('@req : ' + JSON.serialize(req));
		try{
			OB_TrackingOrder.getTrackingOrder(req);			
		}
		catch(Exception e){
			res.errorCode = 1;
			res.errorMessage = e.getMessage();
			System.debug('Exception in OB_Maintenance_Consistenza_ConfItem_CC.saveAndSetTrackingGT at line ' + e.getLineNumber() +'. Error message: ' + e.getMessage());
		}
		//LUBRANO 2019-03-26 -- SAVING END/START DATE FOR POS CHILD ENABLEMENTS
		System.debug(' enablementsList : ' + enablementsList);
		List<NE__OrderItem__c> enablemetsToUpdate = new List<NE__OrderItem__c>();
		for(Object enablement : enablementsList){
			enablemetsToUpdate.add((NE__OrderItem__c)JSON.deserialize(JSON.serialize(enablement), NE__OrderItem__c.class) );
		}
		update enablemetsToUpdate;
		System.debug(' enablementsList after update: ' + enablementsList);
		String posId = wrapperPar.get('itemId');
		if(posId != ''){
			List<NE__OrderItem__c> childItems = [SELECT Id FROM NE__OrderItem__c WHERE NE__Parent_Order_Item__c =: posId ];
			for(NE__OrderItem__c child : childItems){
				child.OB_FulfilmentStatus__c ='Completed';
			}
				try{
					update childItems;
				}
				catch(Exception e){
					res.errorCode = 1;
					res.errorMessage = e.getMessage();
					System.debug('Exception in OB_Maintenance_Consistenza_ConfItem_CC.saveAndSetTrackingGT at line ' + e.getLineNumber() +'. Error message: ' + e.getMessage());
				}
		}
		checkConfiguration(wrapperPar.get('idOrdineSfdc'));
		return res;
	}

	@AuraEnabled
	public static trkResponse saveAndSetTrackingAcquiring(Map<String,String> wrapperPar)
	{
		System.debug('@wrapperPar : ' + wrapperPar);
		trkResponse res = new trkResponse();
		OB_TrackingOrder track 						= new OB_TrackingOrder();
		OB_TrackingOrder.TrackingOrderRequest req 	= new OB_TrackingOrder.TrackingOrderRequest();
		req.idOrdineSfdc 							= wrapperPar.get('idOrdineSfdc');
		req.Acquiring 								= new List<OB_TrackingOrder.Acquiring>(); 
		OB_TrackingOrder.Acquiring currentAcq 		= new OB_TrackingOrder.Acquiring();
		OB_TrackingOrder.puntoVendita currentPV 	= new OB_TrackingOrder.puntoVendita();
		currentPV.itemId							= wrapperPar.get('itemId');
		currentPV.codicePuntoVendita				= wrapperPar.get('codicePuntoVendita');
		currentPV.dataInizioAttivita				= wrapperPar.get('dataInizioAcq');
		currentPV.dataInizio						= wrapperPar.get('dataInizioAcq');
		currentPV.dataCessazione					= wrapperPar.get('dataCessazioneAcq');
		currentPV.causaleCessazione					= wrapperPar.get('causaleCessazioneAcq');
		currentPV.tipo								= wrapperPar.get('tipo');
		currentAcq.sistemaSorgente 					= wrapperPar.get('sistemaSorgente');
		currentAcq.codiceSocieta					= wrapperPar.get('codiceSocieta');
		currentPV.codiceStabilimento				= wrapperPar.get('codiceStabilimento');
		currentPV.codiceStabilimentoSIA				= wrapperPar.get('codiceStabilimentoSIA');
		currentPV.codiceProgressivoSIA				= wrapperPar.get('codiceProgressivoSIA');
		currentPV.codiceSIA							= wrapperPar.get('codiceSIA');
		currentPV.codiceCTI							= wrapperPar.get('codiceCTI');
		currentAcq.puntiVendita.add(currentPV);
		req.Acquiring.add(currentAcq);
		System.debug('@req : ' + JSON.serialize(req));
		String acquiringType 	= wrapperPar.get('acquirerType');
		String action			= wrapperPar.get('action');

		if(acquiringType== 'NEXI' && action =='Add' ){
			// OB_TrackingOrder.TrackingOrderResponse  response = OB_TrackingOrder.getTrackingOrder(req);
			// System.debug('@Response of Tracking Order : ' + response.httpStatus );
			try{
				OB_TrackingOrder.getTrackingOrder(req);
			}
			catch(Exception e){
				res.errorCode = 1;
				res.errorMessage = e.getMessage();
			}
		}
		else{
			System.debug(' inside update secco ');
			//elena.preteni 24/12/2019 R1P-349 add codicePuntoVendita
			res = updateItem(wrapperPar.get('itemId') ,wrapperPar.get('dataInizioAcq'), wrapperPar.get('dataCessazioneAcq'),wrapperPar.get('codicePuntoVendita'));
			//elena.preteni 24/12/2019 R1P-349 add codicePuntoVendita

			
			
		}
		checkConfiguration(wrapperPar.get('idOrdineSfdc'));
		
		return res;
	}


	@AuraEnabled
	//START -elena.preteni descoping convenzione stringConventionCode signature
	public static trkResponse updateItem(Id rootId,String startDate, String endDate,String stringConventionCode){
	//END -elena.preteni descoping convenzione stringConventionCode signature

		trkResponse res = new trkResponse();
		List<NE__OrderItem__c> itemToUpdate = new List<NE__OrderItem__c>(); 
		//START -elena.preteni added list
		List<NE__OrderItem__c> rootItem = [SELECT Id, NE__ProdId__r.OB_Codice_sfdc__c,NE__OrderId__c from NE__OrderItem__c where id = : rootId LIMIT 1];
		String configuration = rootItem.get(0).NE__OrderId__c;
		String productCode = rootItem.get(0).NE__ProdId__r.OB_Codice_sfdc__c;
		//END -elena.preteni added list
		//START -elena.preteni descoping convenzione OB_Conventioncode__c added
		//START - elena.preteni 24/12/2019 R1P-349 add OB_ServicePointCode__c
		List<NE__OrderItem__c> itemlist = [SELECT Id ,NE__StartDate__c,NE__EndDate__c,OB_Conventioncode__c,OB_ServicePointCode__c,(select id from NE__Order_Items_Conf__r ) FROM NE__OrderItem__c where  NE__ProdId__r.OB_Codice_sfdc__c =: productCode AND  NE__OrderId__c =:configuration and NE__ProdId__r.RecordType.DeveloperName != 'Pricing'];
        //END - elena.preteni 24/12/2019 R1P-349 add OB_ServicePointCode__c
		//END - elena.preteni descoping convenzione OB_Conventioncode__c added
		system.debug(' itemlist : ' + itemlist);
		for(NE__OrderItem__c child : itemlist){
				child.OB_FulfilmentStatus__c ='Completed';
				child.NE__StartDate__c = formatDate(startDate);
				child.NE__EndDate__c = formatDate(endDate);
				//START - elena.preteni descoping convenzione OB_Conventioncode__c added
				if(stringConventionCode!=''){
					child.OB_Conventioncode__c= stringConventionCode;
					//START - elena.preteni 24/12/2019 R1P-349 add codicePuntoVendita
                    child.OB_ServicePointCode__c = stringConventionCode;
                    //END - elena.preteni 24/12/2019 R1P-349 add codicePuntoVendita
				}
				//END - elena.preteni descoping convenzione OB_Conventioncode__c added
				itemToUpdate.add(child);
				if(child.NE__Order_Items_Conf__r != null && child.NE__Order_Items_Conf__r.size() > 0){
					for(NE__OrderItem__c item : child.NE__Order_Items_Conf__r){
						item.ob_fulfilmentstatus__c = 'Completed';
						itemToUpdate.add(item);
					}
				}		
		}
		try{
			
			System.debug('itemtoupdate : ' + itemToUpdate);
			update itemToUpdate;
			checkConfiguration(configuration);
		}
		catch(Exception e){
			res.errorCode = 1;
			res.errorMessage = e.getMessage();
			System.debug('Exception in OB_Maintenance_Consistenza_ConfItem_CC.saveAndSetTrackingGT at line ' + e.getLineNumber() +'. Error message: ' + e.getMessage());
		}
		return res;

	}

	@AuraEnabled
	public static List<NE__OrderItem__c> getVasClone(String parentVas)
	{
		System.debug('@Into getVasClone()');
		NE__OrderItem__c parentVasItem = (NE__OrderItem__c)JSON.deserialize(parentVas,NE__OrderItem__c.class);
		System.debug('@parentVas : ' + JSON.serialize(parentVas));
		List<NE__OrderItem__c> listToReturn = new List<NE__OrderItem__c>(); 
		List<NE__OrderItem__c> listOfVasClone = [	SELECT 	Id,
															Name,
															NE__ProdId__c,
															NE__Root_Order_Item__c,
															OB_CustomerCode__c,
															NE__Account__c,
															NE__BillingProfId__c,
															NE__Bundle_Configuration__c,
															NE__CatalogItem__c,
															NE__OrderId__c,
															NE__StartDate__c,
															NE__EndDate__c, 
															OB_CompanyCode__c , 
															OB_ServicePointCode__c,
															MIG_External_Id__c,
															NE__Action__c,
															RecordTypeId,
															RecordType.Name,
															RecordType.DeveloperName,
															NE__ProdId__r.Name,
															OB_TermId__c,
															NE__Parent_Order_Item__c,
															OB_Processor__c,
															OB_ServicePointType__c,
															OB_GT__c,
															OB_ShopCode__c,
															NE__ProdId__r.RecordType.DeveloperName,
															OB_Numero_Assitenza_POS__c
													FROM 	NE__OrderItem__c
													WHERE 	NE__OrderId__c 	=: 	parentVasItem.NE__OrderId__c
													AND 	NE__ProdId__c 	=:	parentVasItem.NE__ProdId__c
													AND 	NE__ProdId__r.RecordType.DeveloperName = 'Vas'
													AND 	NE__Parent_Order_Item__c != ''];

		if(!listOfVasClone.isEmpty())
		{
			for(NE__OrderItem__c item : listOfVasClone)
			{
				listToReturn.add(item);
			}
		}
		System.debug('@listToReturn : ' + JSON.serialize(listToReturn));
		return listToReturn;
	}

	public static void checkConfiguration(String idOrdineSfdc){
		List<NE__OrderItem__c> missingItems = [SELECT 	OB_FulfilmentStatus__c,
													NE__ProdId__r.Name,
													NE__ProdId__r.RecordType.DeveloperName, 
													NE__ProdId__r.OB_Acquirer__c 
													FROM  NE__OrderItem__c 
													WHERE  OB_FulfilmentStatus__c not in ('Completed','Cancelled','Disconnected','Rejected') 
													AND NE__ProdId__r.RecordType.DeveloperName != 'Standard'
													AND NE__OrderId__c = :idOrdineSfdc];
		system.debug('missingItems'+missingItems);
		if(missingItems.size()==0){
			List<NE__Order__c> configurations = [SELECT Id,OB_FulfilmentStatus__c,NE__Order_Header__r.OB_Main_Process__c FROM NE__Order__c WHERE id =:idOrdineSfdc];

			configurations[0].OB_FulfilmentStatus__c = 'Completed';
			update configurations[0];
			OB_UtilityCallingServices.createAsset(configurations[0].Id,configurations[0].NE__Order_Header__r.OB_Main_Process__c);
		}



	}

	global static Datetime formatDate (String dateString){
		//Datetime t  = new Datetime();
		system.debug('dateString '+dateString);
		if(String.isNotBlank(dateString)){
			Datetime instanceDate;
			// <daniele.gandini@ccenture.com> - 17/07/2019 - F2WAVE2-154 - start
			if(dateString.contains('T')){
				String[] firstArray = dateString.split('T');
				String[] arrayString = firstArray[0].split('-');
				instanceDate = Datetime.newInstanceGmt(Integer.valueOf(arrayString[0]), Integer.valueOf(arrayString[1]), Integer.valueOf(arrayString[2]));
			// <daniele.gandini@ccenture.com> - 17/07/2019 - F2WAVE2-154 - stop
			}else{
				String[] arrayString = dateString.split('-');
				instanceDate  = Datetime.newInstanceGmt(Integer.valueOf(arrayString[0]), Integer.valueOf(arrayString[1]), Integer.valueOf(arrayString[2]));
			}
			return instanceDate;
		}else{
			return null;
		}
		
	}

	//start antonio.vatrano r1f2-270 27/06/2019
	@AuraEnabled //antonio.vatrano 27/06/2019 add @AuraEnabled
	global static Boolean isPartnerUser (){
		List<User> listUser= [SELECT Id,
									Profile.UserLicense.Name,
									Profile.Name,
									OB_CAB__C,
									OB_ABI__c
								FROM	User
								WHERE 	Id = : UserInfo.getUserId()];
		if(!listUser.isEmpty()){
			User us = listUser.get(0);
			String license = us.Profile.UserLicense.Name;
			if(license == 'Partner Community'){
				return true;
			}
		}
		return false;
	}
	//end antonio.vatrano r1f2-270 27/06/2019


// * @author Elena Preteni <elena.preteni@accenture.com>
// * @date 07/06/2019
// * @description Method to save data to Order Item
// * @history NEXI-07/06/2019 Created

/* 	@	History - Morittu Andrea 
	@	Description: Change return method from void to Boolean + try-catch block
	@ 	Date : 18-Jul-19
	@	Task F2WAVE2-154
*/
	@AuraEnabled
	global static Boolean saveOrderItemIntegrazione (String action, String startDate, String endDate, String itemId){
		Boolean updateisDone;
		try{
			// <daniele.gandini@accenture.com> - 16/07/2019 - F2WAVE2-154 - start
			NE__OrderItem__c oi = new NE__OrderItem__c(id=itemId,NE__Action__c = action,NE__Status__c='Completed',ob_fulfilmentstatus__c='Completed');
			if(!String.isEmpty(startDate)){
				oi.NE__StartDate__c = formatDate(startDate);
			}
			if(!String.isEmpty(endDate)){
				oi.NE__EndDate__c = formatDate(endDate);
			}
			// <daniele.gandini@accenture.com> - 16/07/2019 - F2WAVE2-154 - stop
			List<NE__OrderItem__c> oiList = [SELECT id, NE__OrderId__c FROM NE__OrderItem__c WHERE id=:itemId];
			update oi;
			updateisDone = true;
			if(!oiList.isEmpty()){
				checkConfiguration(oiList.get(0).NE__OrderId__c);
			}
			system.debug('saveOrderItemIntegrazione oi'+oi);
		} catch (Exception exc) {
			System.debug('!!!! An error has occured : ' + exc.getMessage() );
		}
		return updateisDone;
	}

// * @author Elena Preteni <elena.preteni@accenture.com>
// * @date 07/06/2019
// * @description Method to retrieve data from Order Item
// * @history NEXI-07/06/2019 Created
	@AuraEnabled
	public static NE__OrderItem__c retrieveStatus(String itemId){
		List<NE__OrderItem__c> oiList = [SELECT NE__Action__c,NE__StartDate__c,NE__EndDate__c,NE__Status__c, OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE id =:itemId ]; // antonio.vatrano 29/07/2019 f2wave2-153
		if(!oiList.isEmpty()){
			return oiList.get(0);
		} else {
			return null;
		}

	}


// * @author Elena Preteni <elena.preteni@accenture.com>
// * @date 07/06/2019
// * @description Method to save data to Order Item
// * @history NEXI-07/06/2019 Created
// @    History : Morittu Andrea - Change return method for the correct update
    @AuraEnabled //elena.preteni 17/07/2019 F2WAVW2-153 changed name for list
    global static Boolean saveOrderItemGateway (String action, String itemId, List<Object> enablements){//Simone Misani 16/07/2019 F2WAVE2-153
        Boolean updateDone = false;
    
        try {
            NE__OrderItem__c oi = new NE__OrderItem__c(id=itemId,NE__Action__c = action,NE__Status__c='Completed',ob_fulfilmentstatus__c='Completed');
            List<NE__OrderItem__c> oiList = [SELECT id,
                                                NE__OrderId__c, 
                                                /*Andrea Saracini 17/07/2019 F2WAVE2-153bis START*/
                                                (SELECT Id,
                                                        NE__Status__c,
                                                        OB_fulfilmentstatus__c
                                                FROM NE__Order_Items_Conf__r
                                                )
                                                /*Andrea Saracini 17/07/2019 F2WAVE2-153bis STOP*/
                                        FROM  NE__OrderItem__c
                                        WHERE id  =: itemId]; //elena.preteni 17/07/2019 F2WAVW2-153

            update oi;
            /*Andrea Saracini 17/07/2019 F2WAVE2-153bis START*/
            if(!oiList.isEmpty() && !oiList.get(0).NE__Order_Items_Conf__r.isEmpty()){
                List<NE__OrderItem__c> childsToUpdate = new List<NE__OrderItem__c>();
                for(NE__OrderItem__c item : oiList.get(0).NE__Order_Items_Conf__r){
                    item.OB_FulfilmentStatus__c = 'Completed';
                    childsToUpdate.add(item);
                }
                if(!childsToUpdate.isEmpty()){
                    update childsToUpdate;
                }
            }
            /*Andrea Saracini 17/07/2019 F2WAVE2-153bis STOP*/
            System.debug(' enablementsList : ' + enablements);
            /*List<NE__OrderItem__c> enablemetsToUpdate = new List<NE__OrderItem__c>();
            for(Object enablement : enablements){
                enablemetsToUpdate.add((NE__OrderItem__c)JSON.deserialize(JSON.serialize(enablement), NE__OrderItem__c.class) );
            }
            update enablemetsToUpdate;*/ // antonio.vatrano 29/07/2019 f2wave2-153
            System.debug(' enablementsListList after update: ' + JSON.serialize(enablements));
            if(!oiList.isEmpty()){
                checkConfiguration(oiList.get(0).NE__OrderId__c);
            }
            updateDone = true;
            System.debug('saveOrderItemGateway oi'+oi);
        } catch(Exception exc) {
            System.debug('An error has occured in OB_Maintenance_Consistenza_ConfItem_CC.saveOrderItemGateway');
            updateDone = false;
        }
        return updateDone;
    }

	
	
	//START--Simone Misani Fix Tracking 20/07/2019
	@AuraEnabled
	public static Boolean verifyMixedLogrequest(String confId){

		List<OB_LogRequest__c> currentLog = [	SELECT 	Id,
														OB_Mixed_Maintenance__c
												FROM	OB_LogRequest__c
												WHERE	OB_OrderId__c =: confId];
		if(!currentLog.isEmpty()){
			if(currentLog.get(0).OB_Mixed_Maintenance__c){
					return true;
			}else{
					return false;
			}
		}
		return false;

	}

	@AuraEnabled
	public static Boolean updateOrderItemMixedMaintenance(String confId, String type){
		List<NE__OrderItem__c> updateOrderItem = new List<NE__OrderItem__c>();
		List<OB_LogRequest__c> updateLog = new List <OB_LogRequest__c>();
		System.debug('confId: '+confId);
		Boolean missTrack= false;
		Set<id> idOrderItemFather = new Set<Id>();
		List<NE__OrderItem__c> listOrderItem = [	SELECT  
															Id,
															OB_isNotIntegrated__c,
															NE__Action__c,
															NE__Status__c,
															OB_FulfilmentStatus__c,
															NE__ProdId__r.RecordType.DeveloperName,
															NE__Root_Order_Item__c
													FROM	NE__OrderItem__c
													WHERE	id =: confId
														AND NE__Action__c!=:OB_UtilityConstants.ORDERITEM_ACTION_NONE
														AND NE__Status__c !=: OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED
														AND NE__ProdId__r.RecordType.DeveloperName =: type
														AND NE__Root_Order_Item__c = null
														AND OB_isNotIntegrated__c = true];
		for(NE__OrderItem__c ordItem : listOrderItem){
			idOrderItemFather.add(ordItem.Id);

		}

		list<OB_LogRequest__c> currentLogRequest = [	SELECT 	id,
																		OB_Status__c,
																		OB_Response_Track__c
																FROM	OB_LogRequest__c	
																WHERE 	OB_OrderId__c =: confId];	
		List<NE__OrderItem__c> listchildOi = [	SELECT 	Id,
															OB_isNotIntegrated__c,
															NE__Action__c,
															NE__Status__c,
															OB_FulfilmentStatus__c,
															RecordType.DeveloperName

													FROM	NE__OrderItem__c
													WHERE	Id =: confId
														AND NE__Action__c!=:OB_UtilityConstants.ORDERITEM_ACTION_NONE
														AND NE__Status__c !=: OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED
														AND RecordType.DeveloperName =: type
														AND NE__Root_Order_Item__c IN : idOrderItemFather
														AND OB_isNotIntegrated__c = true];

						
		System.debug('listchildOi: '+listchildOi);
		System.debug('listOrderItem: '+listOrderItem);
		if(!listOrderItem.isEmpty()){
			for(NE__OrderItem__c oi : listOrderItem){

				oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
				updateOrderItem.add(oi);
			}
			for( NE__OrderItem__c childOi: listchildOi){
				childOi.OB_FulfilmentStatus__c=OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
				updateOrderItem.add(childOi);
			}
			update updateOrderItem;
			for (OB_LogRequest__c log : currentLogRequest){
					if(log.OB_Response_Track__c==''){
						log.OB_Status__c= OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
						updateLog.add(log);
						missTrack= true;
					}else{
						missTrack= false;
					}
			}
			if(!updateLog.isEmpty()){
			update updateLog;
			}
			if(!missTrack){
				System.debug('sono updatelog');
				OB_TrackingOrderMaintenance.updateLogRequest(confId);
			}
			
		
		}
		return missTrack;
	}


//END--Simone Misani Fix Tracking 20/07/2019

	

}