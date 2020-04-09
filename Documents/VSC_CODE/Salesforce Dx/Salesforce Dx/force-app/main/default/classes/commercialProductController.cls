global without sharing class commercialProductController {
	
	global static String docId {get;set;}
	global static  Map <String,String> docIds = new Map <String,String>();

	@AuraEnabled
	public static String getMapDocId(){
		system.debug('getMapDocId docIds: '+docId);
		return docId;        
	} 

	@AuraEnabled 
	public static Map<String,String> getContractList(String orderId){
		system.debug('orderId --> '+orderId);
		//   Set<String> contractTypesNoDuplicates = new Set<String>();
		Set<String> contractsUnique = new Set<String>();
		Set<String> businessModelAcquiringUnique = new Set<String>();
		Set<String> businessModelPOSUnique = new Set<String>();
		Set<String> orderTypeUnique = new Set<String>();
		//   Set<String> chosenItemsUnique = new Set<String>(); 
		List<String> businessModelAcquiring = new List<String>();
		List<String> businessModelPOS = new List<String>();
		List<String> orderType = new List<String>();
		//    List<String> contractTypes = new List<String>();
		List<String> contractList = new List<String>();
		//    List<String> chosenItems = new List<String>();
		Map <String, String> contractsMap = new Map<String,String>();

		// contatore
		Integer counter = 0;

		List<OB_Contract__c> listaContract = new List<OB_Contract__c>();

        List<NE__OrderItem__c> orderItems = [
                select NE__ProdId__r.OB_Contract_Type__c,
		NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,RecordType.Name,
		NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c,
		NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
		NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
		NE__ProdId__r.Name, NE__ProdId__r.RecordType.DeveloperName, // antonio.vatrano wn-199 25/07/2019 add field to query
		NE__ProdId__r.OB_Codice_sfdc__c 
		FROM    NE__OrderItem__c 
		WHERE 
		NE__OrderId__c =:orderId  
		AND
		(NE__Action__c = 'Add' OR NE__Action__c = 'Change')
		AND 
		(NE__ProdId__r.OB_Contract_Type__c!=null OR NE__Root_Order_Item__r.NE__ProdId__r.OB_Contract_Type__c!=null)
		];

		system.debug('orderItems: '+ orderItems);
		String subProcess = '';
		for(NE__OrderItem__c orderItem :orderItems){
			//       contractTypesNoDuplicates.add(orderItem.NE__ProdId__r.OB_Contract_Type__c); 
			businessModelAcquiringUnique.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c);
			businessModelPOSUnique.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c);
			orderTypeUnique.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c);
			subProcess = orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c;
	 		//chosenItemsUnique.add(orderItem.NE__ProdId__c);
	 	}
		 
	   	// chosenItems.addAll(chosenItemsUnique);
	   	// contractTypes.addAll(contractTypesNoDuplicates);
	   	businessModelAcquiring.addAll(businessModelAcquiringUnique);
	   	businessModelPOS.addAll(businessModelPOSUnique);
	   	orderType.addAll(orderTypeUnique);
	   	system.debug('businessModelAcquiring: '+ businessModelAcquiring);
	   	system.debug('businessModelPOS: '+ businessModelPOS);
	   	system.debug('orderType: '+ orderType);
		//for(String typeContract : contractTypes){
        listaContract = [ SELECT 	Id,
									OB_Commercial_Product__c,
									OB_Commercial_Product__r.Name,
									OB_Contract_Code__c,OB_Contract_Type__c,OB_Contract_Version__c,
									OB_Modello_di_Business_Acquiring__c,
									OB_Modello_di_business_POS__c,
									OB_Order_Type__c,OB_Template_Name__c,
									OB_Typology__c 
							FROM    OB_Contract__c 
							WHERE 
									//OB_Description_contract__c <> null 
									OB_Modello_di_Business_Acquiring__c in :businessModelAcquiring
							AND     OB_Modello_di_business_POS__c in :businessModelPOS ];
		//  }AND     OB_Order_Type__c in :orderType 

		system.debug('contractList: '+ listaContract);
		// MORITTU ANDREA START 05.Spet-2019 - BACKLOG.442
		OB_Bank_Profile__c contextBankProfile = executeQueryOnBankProfile();
		// MORITTU ANDREA END 05.Spet-2019 - BACKLOG.442
		//Start antonio.vatrano 09/07/2019 problem with documents 
		if(listaContract.size() == 1 && listaContract.get(0).OB_Contract_Code__c =='SFDCWELCOMELETTER'){
			return contractsMap;
		}
		else{
			for(OB_Contract__c contract:listaContract){
				system.debug('***contract.OB_Typology__c: '+contract.OB_Typology__c);
				system.debug('contract.OB_Contract_Type__c: '+contract.OB_Contract_Type__c);
				for(String ord : orderType){
					if((contract.OB_Order_Type__c).contains(ord)){
						counter++;
						switch on(contract.OB_Typology__c){
							when 'Offerta'{
								Integer numberOfferta = [
										SELECT COUNT()
															FROM NE__OrderItem__c 
															WHERE NE__Action__c = 'Add' 
															AND NE__OrderId__c = :orderId 
															AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)
										AND NE__Parent_Order_Item__c = null
								];
								system.debug('numberOfferta: ' + numberOfferta);
								if(numberOfferta > 0){
									// ANDREA MORITTU START 04-Sept-2019 - BACKLOG - 442 AMEX SPECIAL DOCUMENT
									switch on contract.OB_Contract_Code__c {
										// AMEX CAV
										when 'SFDCAMEXCAV' {
											if(contextBankProfile.OB_AmexCAV__c) {
												contractsMap.put(contract.OB_Template_Name__c,contract.id);
											}
										}
										// AMEX
										when 'SFDCAMEX' {
											if(!contextBankProfile.OB_AmexCAV__c) {
												contractsMap.put(contract.OB_Template_Name__c,contract.id);
											}
										} 
										// ELSE
										when else {
											contractsMap.put(contract.OB_Template_Name__c,contract.id);
										}
										// ANDREA MORITTU END 04-Sept-2019 - BACKLOG - 442 AMEX SPECIAL DOCUMENT
									}
									//contractsMap.put(contract.OB_Template_Name__c,contract.id);
									//contractsUnique.add(contract.OB_Template_Name__c);
								}
							}
							when 'Terminale'{
								//List<NE__OrderItem__c> orderItemsTerminale = [SELECT OB_TermId__c, NE__ProdId__r.RecordType.DeveloperName
								//												FROM NE__OrderItem__c 
								//												WHERE NE__Action__c = 'Add' 
								//												AND NE__OrderId__c = :orderId 
								//												AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)
								//												AND NE__ProdId__r.RecordType.DeveloperName = 'Terminali' 
								//												AND NE__Parent_Order_Item__c  != null 
								//												AND NE__Parent_Order_Item__r.OB_Enablement__c = 'Y'
								//												AND NE__Parent_Order_Item__r.OB_Old_Enablement__c = 'N'];

								//need to check, changed beacuse documnent Funzionalià Aggintive didn't come out elena.preteni 26/01/2019
								//Start antonio.vatrano r1f2-235 12/06/2019 Change where condition
								//antonio.vatrano r1f2-263 12/06/2019 Change where condition
								List<NE__OrderItem__c> orderItemsTerminale = [SELECT	NE__Parent_Order_Item__r.OB_TermId__c,
																						NE__Parent_Order_Item__r.OB_Terminal_Id__c, 
																						NE__ProdId__r.RecordType.DeveloperName
																				FROM 	NE__OrderItem__c 
																				WHERE 	NE__OrderId__c = :orderId 
																						AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)
																						AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Terminali' 
																						AND ((NE__Action__c = 'Add' AND OB_Enablement__c = 'Y') 
																						OR (NE__Action__c = 'Change' AND OB_Enablement__c = 'Y' AND OB_Old_Enablement__c = 'N') 
																						OR (NE__Action__c = 'Add' AND NE__ProdId__r.RecordType.DeveloperName = 'Sim'))
								];
								//End antonio.vatrano r1f2-235 12/06/2019 Change where  condition

								if(!orderItemsTerminale.isEmpty() || !(orderItemsTerminale == NULL)){
									for (NE__OrderItem__c orderItemTerminale : orderItemsTerminale){
										System.debug('orderItemTerminale: ' + orderItemTerminale);
										// Daniele Gandini - 29/01/19 - UAT_SETUP_04_RO-68
										// DG - 15/03/2019 - SETUP-188 - START
										// IF
										//		Term id empty and template name != from 'Modulo Funzionalità aggiuntive POS' 
										// OR
										// 		Term id empty, template name = 'Modulo Funzionalità aggiuntive POS', template name NOT IN contractsMap
										// ADD template name WITH NO term id associated in the document's name map
										System.debug('@@@@ contractsMap: ' + counter + ' ' + contractsMap);
										if((String.isBlank(orderItemTerminale.NE__Parent_Order_Item__r.OB_TermId__c) && ((contract.OB_Template_Name__c != OB_UtilityConstants.CONTRACT_TEMPLATE_NAME_MFAPos) || ((contract.OB_Template_Name__c == OB_UtilityConstants.CONTRACT_TEMPLATE_NAME_MFAPos) && (!contractsMap.containsKey(OB_UtilityCOnstants.CONTRACT_TEMPLATE_NAME_MFAPos)))))){
											contractsMap.put(contract.OB_Template_Name__c,contract.id);
										//	IF
										// 		Term id NOT empty, template name = 'Modulo Funzionalità aggiuntive POS', template name NOT IN contractsMap
										// ADD template name WITH NO term id associated in the document's name map
										}else if(((contract.OB_Template_Name__c == OB_UtilityConstants.CONTRACT_TEMPLATE_NAME_MFAPos) && (!contractsMap.containsKey(OB_UtilityCOnstants.CONTRACT_TEMPLATE_NAME_MFAPos)))){
												contractsMap.put(contract.OB_Template_Name__c,contract.id);
										// IF
										// 		Term id NOT empty, template name = 'Modulo Funzionalità aggiuntive POS', template name IN contractsMap
										// DO NOTHING
										}else if(((contract.OB_Template_Name__c == OB_UtilityConstants.CONTRACT_TEMPLATE_NAME_MFAPos) && (contractsMap.containsKey(OB_UtilityCOnstants.CONTRACT_TEMPLATE_NAME_MFAPos)))){
												// Non aggiunge niente
										}
										//start antonio.vatrano r1f2-263 13/06/2019
										else if(!contractsMap.containsKey(contract.OB_Template_Name__c) &&  orderItemTerminale.NE__ProdId__r.RecordType.DeveloperName == 'Sim'){
											contractsMap.put(contract.OB_Template_Name__c,contract.id);
										}
										//end antonio.vatrano r1f2-263 13/06/2019
										else{
										// OTHER CASES
											if(orderItemTerminale.NE__ProdId__r.RecordType.DeveloperName == 'Sim'){
												continue;
											}else{
												contractsMap.put(contract.OB_Template_Name__c+' - '+orderItemTerminale.NE__Parent_Order_Item__r.OB_TermId__c,contract.id ); 
											}
											//end antonio.vatrano r1f2-263 13/06/2019
											// contractsUnique.add(contract.OB_Template_Name__c+' - '+orderItemTerminale.OB_TermId__c);
										}
									}
								}
							}

							when 'Famiglia POS'{   
								for(NE__OrderItem__c orderItem :orderItems){
									system.debug('orderItem Famiglia POS: ' + orderItem);
									if(orderItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Terminali')){ // antonio.vatrano wn-199 25/07/2019
										//LUBRANO 2019-04-09 -- SETUP-251-sending OB_Codice_sfdc__c to frontEnd to be processed in ob_continuationController
										contractsMap.put(contract.OB_Template_Name__c + ' - ' + orderItem.NE__ProdId__r.Name + '__' + orderItem.NE__ProdId__r.OB_Codice_sfdc__c, contract.id);

									}
								}
							}
							/****************************************START AV 18_01_2019****************************/
							when 'Pricing'{
								System.debug('@@@@In Pricing');
								System.debug('@@@@In Pricing');
								
								Boolean rem = false;
								Boolean add = false;
								Integer changeInt;
								if(ord == 'Maintenance' && subProcess == 'variazione economica'){
									//LUBRANO -- 2019-02-23 -- CHANGE QUERY
									changeInt = [
											SELECT COUNT()
												FROM NE__OrderItem__c 
												WHERE NE__OrderId__c = :orderId 
													AND NE__OrderId__r.OB_AgreedChanges__c = true
													AND((( NE__ProdId__r.RecordType.DeveloperName = 'Commissione' AND NE__Action__c = 'Add')
													// AND NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Acquiring'
														AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c))
														OR (NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Acquiring'
											AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' AND NE__Action__c = 'Change'))
									];
									/*
									changeInt = [SELECT COUNT()
												FROM NE__OrderItem__c 
												WHERE 	NE__OrderId__c = :orderId 
													AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
													AND (NE__Action__c = 'Change' OR NE__Action__c = 'Add')
													// AND NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Acquiring'
													AND NE__OrderId__r.OB_AgreedChanges__c = true
													AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)];
									*/
									//--------------------------------------
								}
								// List<NE__OrderItem__c> orItems =  [select id, NE__ProdId__r.RecordType.DeveloperName,NE__Action__c
								// 									FROM NE__OrderItem__c WHERE 	NE__OrderId__c = :orderId				
								// 									AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)
								// 									AND NE__OrderId__r.OB_AgreedChanges__c = true	];
								
								
								// system.debug(orItems );
								// for(NE__OrderItem__c oi : orItems ){
								// 	if(oi.NE__ProdId__r.RecordType.DeveloperName == 'Commissione' && oi.NE__Action__c == 'Add'){ 
								// 		add = true;
								// 	}
								// 	if(oi.NE__ProdId__r.RecordType.DeveloperName == 'Commissione' && oi.NE__Action__c == 'Remove'){
								// 		rem= true;
								// 	}
								// }(rem && add) ||
								if( changeInt>0){
									contractsMap.put(contract.OB_Template_Name__c,contract.id);
									//contractsUnique.add(contract.OB_Template_Name__c+' - '+orderItemTerminale.OB_TermId__c); 
								}
								// Integer numOrderItemPricing = [SELECT COUNT()
								// 								FROM NE__OrderItem__c 
								// 								WHERE 	NE__OrderId__c = :orderId 
								// 											AND(((NE__ProdId__r.RecordType.DeveloperName = 'Commissione' 
								// 												AND NE__Action__c = 'Add' )
								// 											AND (NE__ProdId__r.RecordType.DeveloperName = 'Commissione'
								// 												AND NE__Action__c = 'Remove')
								// 											AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)
								// 											AND NE__OrderId__r.OB_AgreedChanges__c = true)
								// 										OR 	(NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
								// 											AND NE__Action__c = 'Change'
								// 											AND NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Acquiring'
								// 											AND NE__OrderId__r.OB_AgreedChanges__c = true
								// 											))];
								// System.debug('#####numOrderItemPricing: ' + numOrderItemPricing);
								// if(numOrderItemPricing>0){
									// contractsMap.put(contract.OB_Template_Name__c,contract.id);
									//contractsUnique.add(contract.OB_Template_Name__c+' - '+orderItemTerminale.OB_TermId__c); 
															
								// }
								
							}
							when 'Estensione GT NEXI'{
								System.debug('@@@@In Estensione GT NEXI');
								Integer numExtGtNexi = [
										SELECT COUNT()
														FROM NE__OrderItem__c 
														WHERE NE__OrderId__c = :orderId 
														AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)
														AND NE__ProdId__r.RecordType.DeveloperName = 'Acquiring' 
														AND NE__Action__c = 'Add'
														AND NE__Parent_Order_Item__c = null
										AND NE__OrderId__r.OB_GT__c = 'Nexi'
								];

								System.debug('#####numExtGtNexi: ' + numExtGtNexi);
								if(numExtGtNexi>0){
									contractsMap.put(contract.OB_Template_Name__c,contract.id);
									//contractsUnique.add(contract.OB_Template_Name__c+' - '+orderItemTerminale.OB_TermId__c);                            
								}
							}
							when 'Estensione GT OTHER'{
								System.debug('@@@@In Estensione GT OTHER');
								Integer numExtGtOther = [
										SELECT COUNT()
														FROM NE__OrderItem__c 
														WHERE NE__OrderId__c = :orderId 
														AND NE__ProdId__r.OB_Contract_Type__c includes (:contract.OB_Contract_Type__c)
														AND NE__ProdId__r.RecordType.DeveloperName = 'Acquiring' 
														AND NE__Action__c = 'Add'
														AND NE__Parent_Order_Item__c=null
										AND NE__OrderId__r.OB_GT__c != 'Nexi'
								];
								System.debug('#####numExtGtOther: ' + numExtGtOther);
								if(numExtGtOther>0){
									contractsMap.put(contract.OB_Template_Name__c,contract.id);
									//contractsUnique.add(contract.OB_Template_Name__c+' - '+orderItemTerminale.OB_TermId__c);                            
								}
							}
							/****************************************END AV 18_01_2019****************************/
						}
					}
				}
			}
			
			contractList.addAll(contractsUnique);
			system.debug('contactsMap: '+ contractsMap);
			return contractsMap;
		} 
		//end antonio.vatrano 09/07/2019 problem with documents       
	}
	/*
	* Author : Giovanni Spinelli
	* Date : 06/05/2019
	* Description : Method fire a future method to deprecate all contrat generated.
	*/
	@AuraEnabled
	public static void deprecateContracts(String merchantId,String servicePointId,String orderId,List<String> contractsIdList){
		System.debug('DEPRECATING ALL CONTRACTS');
		System.debug('merchantId: ' + merchantId);
		System.debug('servicePointId: ' + servicePointId);
		System.debug('orderId: ' + orderId);
		System.debug('contractsIdList: ' + contractsIdList);
		commercialProductController.asyncCall( merchantId, servicePointId, orderId, contractsIdList);
	}
	/*
	* Author : Giovanni Spinelli
	* Date : 06/05/2019
	* Description : future method to deprecate all contrat generated.
	*/	
	@future(callout=true)
	private static void asyncCall (String merchantId,String servicePointId,String orderId,List<String> contractsIdList){

		//for each id make an http call and deprecate single contract
		for(String ids : contractsIdList){
			String url = 'callout:OB_callService/api/merchants/'+merchantId+'/sales-points/'+servicePointId+'/orders/'+orderId+'/documents/'+ids;
			String body = '{"documentStatus":"DEPRECATED"}';
			String traceIdHeader =  String.valueof(DateTime.now()).replaceAll(' ','T');
			String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
			OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
			HttpRequest  req = new HttpRequest();
			String token = OB_UtilityCallingServices.checkToken();
			req.setEndpoint(url);
			req.setMethod('POST');
			system.debug('Service message: '+token);
			req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
			req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
			if(intConfig.OB_CAsigned_name__c != null)
			{
				req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
			}
			req.setHeader('Content-Type','application/json');
			req.setBody(body);
			System.debug('RESPONSE: '+req);
			HTTPResponse httpResponse = new  HTTPResponse();
			Http http = new Http();
			httpResponse = http.send(req);
			System.debug('Response body deprecateDocument: '+ httpResponse.getBody());
        }
	}
    

	/*
	*	Author	:	Morittu	Andrea	
	*	Date	:	04-Sept-2019
	*	Task	:	BACKLOG.442
	*/
	public virtual class applicationException extends Exception {
		String errorMessage;
	}



	
	/*
	*	Author	:	Morittu	Andrea	
	*	Date	:	04-Sept-2019
	*	Task	:	BACKLOG.442
	*/
	@TestVisible //g.v. 26/09/2019
	private static OB_Bank_Profile__c executeQueryOnBankProfile() {

		OB_Bank_Profile__c toReturn = new OB_Bank_Profile__c();
		try {

			List<User> listOfUsers = [SELECT Id, 
											Profile.Userlicense.Name,
											OB_CAB__c, 
											Contact.Account.OB_ABI__c 
									FROM User 
									WHERE Id = : userinfo.getuserid() 
									LIMIT 1];
			String UNIQUE_ABI;
			if (!listOfUsers.isEmpty() && !String.isEmpty(listOfUsers.get(0).Contact.Account.OB_ABI__c)) {
				UNIQUE_ABI = listOfUsers.get(0).Profile.Userlicense.Name==Label.OB_License_PartnerCommunity ? listOfUsers.get(0).contact.account.OB_ABI__c : '';
			} else {
				throw new applicationException('Fatal Error in CommercialProductController.executeQueryOnBankProfile: User ABI is null');
			}
			List<OB_Bank_Profile__c> bankProfileList = new List<OB_Bank_Profile__c>();
			bankProfileList = [	SELECT 	Id, 
										OB_AmexCAV__c
								FROM 	OB_Bank_Profile__c 
								WHERE OB_Bank__r.OB_ABI__c=: UNIQUE_ABI];
			if(bankProfileList == null || bankProfileList.size()< 1){
				throw new applicationException('Fatal Error in CommercialProductController.executeQueryOnBankProfile: lenght of listOfBankProfile retrieved is: ' + bankProfileList.size());
			} else {
				toReturn = bankProfileList.get(0);
			}
		} catch (Exception exc ) {
			System.debug('An error has occured inside commercialProductController.executeQueryOnBankProfile() : ' + exc.getMessage() + ' at the following line : ' + exc.getLineNumber());
		}
	return toReturn;

	}
}