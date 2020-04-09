public with sharing class OB_Maintenance_Consistenza_LogRequest_CC
{
	
	public class WrapperTerminalwithVAS{
		// public String terminalId 									{get;set;}
		// public String sfdcid 										{get;set;}
		public NE__OrderItem__c VAS 								{get;set;}
		public List<NE__OrderItem__c> terminalList						{get;set;}
		// public List<NE__Order_Item_Attribute__c> relatedAttributes 	{get;set;}
		
		public WrapperTerminalwithVAS(){
			VAS 				= new NE__OrderItem__c();
			// relatedAttributes 	= new List<NE__Order_Item_Attribute__c>();
			terminalList		= new  List<NE__OrderItem__c>();
		}
	}
	
	@AuraEnabled
	public static Boolean checkProfileOnLogRequestConsistenza()
	{
		Boolean toReturn = false;
		String userId = UserInfo.getUserId();
		list<User> listOfUsers = [	SELECT 	Id, Profile.Name, Profile.UserLicense.Name
									FROM 	User
									WHERE 	Id =: userId
									LIMIT 	1	];
		if(!listOfUsers.isEmpty())
		{
			User user					= listOfUsers.get(0);
			String license 		= user.Profile.UserLicense.Name;
			String profile 		= user.Profile.Name;
			System.debug('license:  '+license);
			System.debug('profile:  '+profile);

			String confInfProfiles;
			Boolean profileIsInConfInf = false;
			OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt();
			OB_ConfigurationInformation__mdt[] listOfConfigurationInformations = [SELECT 	Id,
																																										MasterLabel,
																																										Label,
																																										QualifiedApiName,
																																										OB_String_Value__c
																																										FROM 	OB_ConfigurationInformation__mdt 
																																										WHERE 	QualifiedApiName =: System.Label.OB_Maintenance_Pricing_Consistency	];
			if(!listOfConfigurationInformations.isEmpty())
			{
				configurationInformation = listOfConfigurationInformations.get(0);
				confInfProfiles = configurationInformation.OB_String_Value__c;
				System.debug('@confInfProfiles : ' +  confInfProfiles);
				profileIsInConfInf = confInfProfiles.contains(profile);
				System.debug('@profileIsInConfInf : ' +  profileIsInConfInf);

				if(profileIsInConfInf == true)
				{
					toReturn = true;
				}
			}
		}
		return toReturn;
	}

	
	@AuraEnabled
	public static OB_LogRequest__c retrieveLogRequestConsistenza(Id logRequestId)
	{
		
		/*
		OB_HasVas__c,
		OB_CustomerCode,
		OB_CTI_Code,
		OB_EstablishmentSIACode,
		OB_ProgressiveCodeSIA,
		OB_SIACode 
		*/
		OB_LogRequest__c logRequestRetrived = new OB_LogRequest__c();
		List<OB_LogRequest__c> logrequests = [	SELECT 	Id,
														OB_AccountId__c,
														OB_AccountId__r.Name,
														OB_OrderId__r.Name,
														OB_HasPos__c,
														OB_HasAcquiring__c,
														OB_HasVas__c,
														OB_InstallationDate_POS__c,
														OB_UninstallationDate_POS__c,
														OB_ConventionCode__c,
														OB_CompanyCode__c,
														OB_Status__c,
														OB_ServicePointId__c,
														OB_ServicePointId__r.Name,
														OB_OrderId__c,
														ob_orderid__r.OB_ApprovalStatus__c,
														ob_orderid__r.OB_AdditionalDocumentationRequired__c,
														ob_orderid__r.NE__Order_Header__r.OB_ProposerABI__c,
														ob_orderid__r.NE__Order_Header__c,OB_SIAToBeApproved__c, //2019/05/10 - salvatore.pianura - fields 'Conferma SIA' button
														OB_isNotIntegrated__c,
														OB_Track_LogRequest__c, //francesca.ribezzi 25/09/19 adding OB_Track_LogRequest__c to show Conferma button
														OB_MaintenanceType__c // micol.ferrari 19/12/2019 - PERF-97
												FROM 	OB_LogRequest__c
												WHERE 	Id =:logRequestId	
												LIMIT 	1 	];
		String orderHeaderId; //antonio.vatrano 19/09/19 - WN-413  - orderHeaderId
		if(!logrequests.isEmpty())
		{
		
			logRequestRetrived = logrequests.get(0);
			//START antonio.vatrano 19/09/19 - WN-413 - checking if it is not integrated. then calling updateOrderItemActionNone to set orderItems to completed
			orderHeaderId	= logRequestRetrived.OB_OrderId__r.NE__Order_Header__c;
			System.debug('@LogRequestConsistenza retrieved : ' + logRequestRetrived);
			if(logRequestRetrived.OB_isNotIntegrated__c){
				OB_Maintenance_Flow_Override.updateOrderItemActionNone(orderHeaderId);
			}
			//END antonio.vatrano 19/09/19 - WN-413 
		}
		/*
		Boolean needBio = [select OB_NeedBIO__c  from OB_Bank_Profile__c where OB_Bank__c =:logRequestRetrived.ob_orderid__r.NE__Order_Header__r.OB_ProposerABI__c limit 1].OB_NeedBIO__c;
		if(logRequestRetrived.OB_Status__c.equalsIgnorecase('Bozza') && logRequestRetrived.ob_orderid__r.OB_ApprovalStatus__c.equalsIgnoreCase(OB_UtilityConstants.APPROVAZIONE_PRICING) && (!needBio && !logRequestRetrived.ob_orderid__r.OB_AdditionalDocumentationRequired__c) ){
			logRequestRetrived.OB_Status__c = OB_UtilityConstants.INATTESA;
			update logRequestRetrived;
		} else if(logRequestRetrived.OB_Status__c.equalsIgnorecase('Bozza') && logRequestRetrived.ob_orderid__r.OB_ApprovalStatus__c.equalsIgnoreCase(OB_UtilityConstants.APPROVAZIONE_BIO) && (needBio && logRequestRetrived.ob_orderid__r.OB_AdditionalDocumentationRequired__c)){
			logRequestRetrived.OB_Status__c = OB_UtilityConstants.INATTESA;
			update logRequestRetrived;
		}*/
		return logRequestRetrived;
	}
	
	/*CONFIGURATION:*/
	@AuraEnabled
	public static NE__Order__c getConfigurationServer(String configurationId) {
		NE__Order__c configuration = new NE__Order__c();
		List<NE__Order__c> configurations = new List<NE__Order__c>();
		try {
			configurations = [SELECT 	Id,
										Name,
										OB_CTI_Code__c,
										NE__Type__c,
										OB_BankApprovalStatus__c
								FROM 	NE__Order__c
								WHERE 	Id =: configurationId];
			System.debug('Configurtions are : ' + configurations);
			if(!configurations.isEmpty() && configurations.size() > 0) {
				configuration = configurations.get(0);
				System.debug('configuration is : ' + configuration);
			}
		} catch(Exception e) {
				System.debug('Exception in OB_Maintenance_Consistenza_LogRequest_CC.getConfigItemsServer at line ' + e.getLineNumber() +'. Error message: ' + e.getMessage());
		}
		return configuration;
	}

	/*CONFIGURATION ITEM:*/
	@AuraEnabled
	public static Map<String, List<NE__OrderItem__c>> getConfigItemsServer(String configurationId) {
		NE__OrderItem__c terminalConfigurationItem = null;
		String add = 'Add';
		String terminal = OB_UtilityConstants.POS_RT;
		String vas = OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS;
		Map<String, List<NE__OrderItem__c>> finalMap = null;

		try {
			List<NE__OrderItem__c> listOfItemsTerm = [	SELECT 	Id,
																NE__ProdId__r.Name,
																OB_CustomerCode__c,
																NE__Account__c,
																NE__BillingProfId__c,
																NE__Bundle_Configuration__c,
																NE__CatalogItem__c,
																NE__OrderId__c,
																NE__StartDate__c ,
																NE__EndDate__c , 
																OB_CompanyCode__c , 
																OB_ServicePointCode__c,
																MIG_External_Id__c,
																NE__Action__c,
																OB_TermId__c,
																RecordTypeId,
																RecordType.Name,
																RecordType.DeveloperName
														FROM 	NE__OrderItem__c
														WHERE 	NE__OrderId__c  =: configurationId ];
														
			System.debug('## listOfItemsTerm is: ' + listOfItemsTerm);
			
				//AND 	RecordType.DeveloperName =: OB_UtilityConstants.POS_RT
				//									AND 	NE__Action__c =: add										
			if(!listOfItemsTerm.isEmpty() && listOfItemsTerm.size() > 0) {
				finalMap = new Map<String, List<NE__OrderItem__c>>(); 
				List<NE__OrderItem__c> listTerminalItem = new List<NE__OrderItem__c>();
				List<NE__OrderItem__c> listAcquiringItem = new List<NE__OrderItem__c>();
				List<NE__OrderItem__c> listVasItem = new List<NE__OrderItem__c>();
				List<NE__OrderItem__c> listPagoBancomatItem = new List<NE__OrderItem__c>();
				for(Integer i = 0; i < listOfItemsTerm.size(); i++) {
					System.debug('orderItems are: '+ listOfItemsTerm[i]);
						if(listOfItemsTerm[i].RecordType.DeveloperName.equalsIgnoreCase(terminal)) {
							listTerminalItem.add(listOfItemsTerm[i]);
						}
					if(listOfItemsTerm[i].NE__Action__c.equalsIgnoreCase(add)) {
						if(listOfItemsTerm[i].RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.ACQUIRING)) {
							listAcquiringItem.add(listOfItemsTerm[i]);
						}
						if(listOfItemsTerm[i].RecordType.DeveloperName.equalsIgnoreCase(vas)) {
							listVasItem.add(listOfItemsTerm[i]);
						}
						if(listOfItemsTerm[i].RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT) ){
							listPagoBancomatItem.add(listOfItemsTerm[i]);
						}
					}
				}
				if(!listTerminalItem.isEmpty()) {
					finalMap.put('TERMINALItem', listTerminalItem);
				}
				if(!listAcquiringItem.isEmpty()) {
					finalMap.put('ACQUIRINGItems', listAcquiringItem);
				}
				if(!listVasItem.isEmpty()) {
					finalMap.put('VASItem', listVasItem);
				}
				if(!listPagoBancomatItem.isEmpty()) {
					finalMap.put('PAGOBANCOMATItem', listPagoBancomatItem);
				}
				System.debug('finalMap is: ' + finalMap);
			}
		} catch(Exception e) {
				System.debug('Exception in OB_Maintenance_Consistenza_LogRequest_CC.getTerminalItemsServer at line ' + e.getLineNumber() +'. Error message: ' + e.getMessage());
		}
		return finalMap;		
	}
	

		@AuraEnabled
	public static String getSortedConfigItemsServer2(String configurationId) {
		/*VARIABLE GRABBED FROM UTILITY CLASS (CONSTANTS) */
		String add 				= 'Add';
		String terminal 	=	OB_UtilityConstants.POS_RT;
		String ecommerce 	= 	OB_UtilityConstants.PRODUCT_RECORDTYPE_ECOMMERCE;
		String moto 		=	OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO; //francesca.ribezzi 19/09/19 - WN-438 - adding moto and ecommerce
		String vas 				= OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS;
		Boolean conftech = compatibilityTechnicalConfigurator(configurationId);//Simone Misani 25/07/2019 WN-67
		// 30/04/2019 shaghayegh.tofighian add OB_Replacement__c , NE__OrderId__r.OB_FulfilmentStatus__c and NE__Action__c IN ('None','Change') for Terminali + NE__OrderId__r.NE__Order_Header__c configurationTerminalObject

		List<NE__OrderItem__c> orderItems 	=  [SELECT  Id,
														Name,
														OB_Conventioncode__c,
														NE__Root_Order_Item__c,
														NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, //elena.preteni 06/06/19 Descoping consistenza
														NE__Root_Order_Item__r.NE__Action__c, //elena.preteni 06/06/19 Descoping consistenza
														OB_CustomerCode__c,
														NE__Account__c,
														NE__BillingProfId__c,
														NE__Bundle_Configuration__c,
														NE__CatalogItem__c,
														NE__OrderId__c,
														NE__OrderId__r.OB_Service_Point__r.OB_Typology__c, //elena.preteni 06/06/19 Descoping consistenza
														NE__StartDate__c,
														NE__EndDate__c,
														OB_CompanyCode__c ,
														OB_ServicePointCode__c,
														NE__Service_Point__r.OB_Typology__c, //elena.preteni 06/06/19 Descoping consistenza
														MIG_External_Id__c,
														NE__Action__c,
														NE__ProdId__c,
														NE__ProdId__r.Name,
														NE__ProdId__r.RecordType.DeveloperName,
														NE__ProdId__r.OB_Acquirer__c,
														NE__ProdId__r.OB_Codice_sfdc__c, //elena.preteni 06/06/19 Descoping consistenza
														NE__Parent_Order_Item__c,
														OB_Processor__c,
														OB_ServicePointType__c,
														OB_GT__c,
														OB_ShopCode__c,
														OB_TermId__c,
														OB_Numero_Assitenza_POS__c,
														OB_FulfilmentStatus__c,
														OB_Replacement__c,
														NE__OrderId__r.OB_FulfilmentStatus__c,
														NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,//Simone Misani 16/10/2019
														NE__OrderId__r.NE__Order_Header__c,
														OB_isNotIntegrated__c,//elena.preteni 28/06/2019 descoping
														(SELECT Id, Name, NE__Value__c, NE__Order_Item__c,NE__Action__c  FROM NE__Order_Item_Attributes__r where NE__Value__c!=''),
																(SELECT Id,
																				NE__Root_Order_Item__c,
																				OB_enablement__c,
																				OB_Old_Enablement__c ,
																				NE__ProdId__r.Name ,
																				NE__StartDate__c ,
																				NE__EndDate__c,
																				NE__Action__c,
																				NE__ProdId__r.OB_Acquirer__c,
																				OB_FulfilmentStatus__c,
																				OB_isNotIntegrated__c
																FROM 	NE__Order_Items_Conf__r
																WHERE 	NE__ProdId__r.RecordType.DeveloperName !='Pricing'
																AND 		NE__ProdId__r.RecordType.DeveloperName !='PCI'
																AND 		NE__ProdId__r.RecordType.DeveloperName !='Pinpad'
																AND 		NE__ProdId__r.RecordType.DeveloperName !='Sim')
												FROM  NE__OrderItem__c
												WHERE NE__OrderId__c  =: configurationId  	AND
												NE__Parent_Order_Item__c = null 			AND (((
												NE__ProdId__r.RecordType.DeveloperName = 'Acquiring' 		OR
												NE__ProdId__r.RecordType.DeveloperName = 'Vas' 	OR
												NE__ProdId__r.RecordType.DeveloperName = 'Integrazione' OR
												NE__ProdId__r.RecordType.DeveloperName = 'Moto' OR
												NE__ProdId__r.RecordType.DeveloperName = 'eCommerce' )	AND //elena.preteni 06/06/19 Descoping consistenza added or condition RT Integrazione,Moto,eCommerce
												NE__Action__c NOT IN ('None')) OR //antonio.vatrano wn318 02/09/2019
												(NE__ProdId__r.RecordType.DeveloperName = 'Terminali')	OR //francesca.ribezzi 20/06/19 -  Descoping consistenza - removing action condition
												NE__ProdId__r.RecordType.DeveloperName = 'Pagobancomat' OR 
												NE__ProdId__r.RecordType.DeveloperName = 'eCommerce' OR
												NE__ProdId__r.RecordType.DeveloperName = 'Moto')];  //francesca.ribezzi 19/09/19 - WN-438 - adding moto and ecommerce


												System.debug('orderItems is: ' + orderItems);

		List<NE__OrderItem__c> 	listAcquiringItem 			= new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> 	listVasItem 						= new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> 	listPagoBancomatItem 		= new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> 	listPOStItem 						= new List<NE__OrderItem__c>();
		//START - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
		List<NE__OrderItem__c> 	listIntegrazionetItem 						= new List<NE__OrderItem__c>();
		//END - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
			//START - elena.preteni 07/06/2019 descoping consistenza RT Gateway
		List<NE__OrderItem__c> 	listGatewaytItem 		= new List<NE__OrderItem__c>();
		//END - elena.preteni 07/06/2019 descoping consistenza RT Gateway

		Boolean isFirstPos	= true;
		String  notIntegrated = 'false';
		OB_Maintenance_Flow_Override.updateOrderItemActionNone(configurationId);//Simone Misani 22/07/2019 fix Tracking
		List<Id> listOfOrdersToUpdateId = new List<Id>();
		integer i=0;//Simone Misani WN-573 16/10/2019
		for(NE__OrderItem__c singleConfigurationItem : orderItems ) 
		{
				Boolean isAcquiring =  singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.ACQUIRING);
				if(isAcquiring) {
					if(singleConfigurationItem.NE__Action__c !='None'){
						//Simone Misani WN-573 16/10/2019 START 
						if(singleConfigurationItem.OB_isNotIntegrated__c){
							 listAcquiringItem.add(singleConfigurationItem);
							if(singleConfigurationItem.NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c == 'termina offerta' && singleConfigurationItem.NE__ProdId__r.OB_Acquirer__c != 'NEXI'){
								listAcquiringItem.remove(i);
								i--;//Simone Misani 18/10/2019
							}
                            i++;

						//Simone Misani WN-573 16/10/2019 END
						}

					}
					
					System.debug('listAcquiringItem is: '+ listAcquiringItem);
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
						}
					}
					
				}
				Boolean isVas = singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Vas');
				if(isVas) {
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listVasItem.add(singleConfigurationItem);
						System.debug('listVasItem is : ' + listVasItem);
						}
					}
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
						}
					}	
				}
				Boolean isPagobancomat = singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Pagobancomat') && (singleConfigurationItem.NE__Order_Item_Attributes__r!=null && singleConfigurationItem.NE__Order_Item_Attributes__r.size() > 0);
				if(isPagobancomat){
					if(singleConfigurationItem.OB_isNotIntegrated__c){
					listPagoBancomatItem.add(singleConfigurationItem);
					System.debug('listPagoBancomatItem is : ' + listPagoBancomatItem);
					}
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c || conftech ){//Simone Misani 25/07/2019 WN-67
						listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
						}
					}
				}
				//START francesca.ribezzi 19/09/19 - WN-438 - adding moto and ecommerce
				Boolean isPOS = singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase(terminal);
				Boolean isEcommerce = singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase(ecommerce); 
				Boolean isMoto = singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase(moto);
				if(isEcommerce || isMoto || isPOS){
					isPOS = true;
				}
				//END francesca.ribezzi 19/09/19 - WN-438 -
				System.debug('@@@recordType: ' + singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName);
				if(isPOS) {
					System.debug('isPOS is true');
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listPOStItem.add(singleConfigurationItem);
						notIntegrated = 'true';
						listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
						}
					}else{
						isFirstPos = false;
						Boolean firstenablement = true;
						if(singleConfigurationItem.NE__Order_Items_Conf__r.size()>0){
							for(NE__OrderItem__c child: singleConfigurationItem.NE__Order_Items_Conf__r ) {
								if(!child.OB_enablement__c.equalsIgnoreCase(child.OB_Old_Enablement__c)){
									if(firstenablement){
										if(singleConfigurationItem.OB_isNotIntegrated__c || conftech || child.OB_isNotIntegrated__c){//Simone Misani 25/07/2019 WN-67
										listPOStItem.add(singleConfigurationItem);
										notIntegrated= 'true';
										}
										firstenablement = false;
										//LUBRANO - 26-03-2019 -- not updating POS if it has at least one enablement change
										if(singleConfigurationItem.OB_isNotIntegrated__c|| conftech){//Simone Misani 25/07/2019 WN-67
										listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
										}
									}									
									listOfOrdersToUpdateId.add(child.Id);
									//break;
								}
								if(child.NE__Action__c !='None' && singleConfigurationItem.OB_isNotIntegrated__c){		
								 	listOfOrdersToUpdateId.add(child.Id);
								}	// listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
							}
						}
					}	
					System.debug('listPOStItem is : ' + listPOStItem);
				}
				//START - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
				Boolean isIntegrazione = singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Integrazione');
				if(isIntegrazione){
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listIntegrazionetItem.add(singleConfigurationItem);
						}
					}

					System.debug('listAcquiringItem is: '+ listAcquiringItem);
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
						}
					}
				}
				//END - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
				//START - elena.preteni 07/06/2019 descoping consistenza RT Gateway
				Boolean isGateway = singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('eCommerce') || singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Moto');
				if(isGateway){
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listGatewaytItem.add(singleConfigurationItem);
						}
					}

					System.debug('listGatewaytItem is: '+ listGatewaytItem);
					if(singleConfigurationItem.NE__Action__c !='None'){
						if(singleConfigurationItem.OB_isNotIntegrated__c){
						listOfOrdersToUpdateId.add(singleConfigurationItem.Id);
						}
					}
				}
				//END - elena.preteni 07/06/2019 descoping consistenza RT Gateway
		}
	System.debug(' listOfOrdersToUpdateId : ' + listOfOrdersToUpdateId);
		/*ANDREA MORITTU START 2019.02.21*/
		if(!listOfOrdersToUpdateId.isEmpty()) {
			List<NE__OrderItem__c> itemsToUpdate = new List<NE__OrderItem__c>();
			List<NE__OrderItem__c> ordersToUpdate = [SELECT Id,NE__OrderId__r.OB_BankApprovalStatus__c,OB_isNotIntegrated__c, //Simone Misani 22/07/2019 fix Tracking
													(SELECT Id FROM NE__Order_Items_Conf__r where id NOT IN : listOfOrdersToUpdateId)
												FROM  NE__OrderItem__c  
												WHERE NE__OrderId__c  =: configurationId
												AND OB_isNotIntegrated__c != false //Simone Misani 22/07/2019 fix Tracking
												AND NE__Parent_Order_Item__c = null 
												AND Id NOT IN : listOfOrdersToUpdateId
												];
			
			system.debug(' ordersToUpdate : ' + ordersToUpdate);
			if(ordersToUpdate.size() > 0 && ordersToUpdate.get(0).NE__OrderId__r.OB_BankApprovalStatus__c!='In Approvazione') {
				system.debug('not approve '+ordersToUpdate.get(0).NE__OrderId__r.OB_BankApprovalStatus__c!='In Approvazione');
				for(NE__OrderItem__c singleToUpdate : ordersToUpdate) {
					singleToUpdate.OB_FulfilmentStatus__c = 'Completed';
					itemsToUpdate.add(singleToUpdate);
					if(singleToUpdate.NE__Order_Items_Conf__r.size()>0){
						for(NE__OrderItem__c childToUpdate: singleToUpdate.NE__Order_Items_Conf__r){
							childToUpdate.OB_FulfilmentStatus__c = 'Completed';
							itemsToUpdate.add(childToUpdate);
						}	
					}
				}

				if(itemsToUpdate.size()>0){
					update itemsToUpdate;
				}
			}
		}
		/*ANDREA MORITTU END 2019.02.21*/

		Map<String,String> toReturn = new Map<String,String>();
		toReturn.put('listAcquiringItem',JSON.serialize(listAcquiringItem));
		toReturn.put('listVasItem',JSON.serialize(listVasItem));
		toReturn.put('listPagoBancomatItem',JSON.serialize(listPagoBancomatItem));
		toReturn.put('listPOStItem',JSON.serialize(listPOStItem));
		toReturn.put('isFirstPos',String.valueOf(isFirstPos));
		//START - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
		toReturn.put('listIntegrazionetItem',JSON.serialize(listIntegrazionetItem));
		//END - elena.preteni 06/06/2019 descoping consistenza RT Integrazione
		//START - elena.preteni 07/06/2019 descoping consistenza RT Integrazione
		toReturn.put('listGatewaytItem',JSON.serialize(listGatewaytItem));
		toReturn.put('isNotIntegrated',notIntegrated);
		//END - elena.preteni 07/06/2019 descoping consistenza RT Integrazione
		System.debug('Massive Map toReturn is: ' + JSON.serialize(toReturn));
		return  JSON.serialize(toReturn);
	}

	/*CONFIGURATION ITEM:*/


	@AuraEnabled
	public static String getSortedConfigItemsServer(String configurationId) {
		/*VARIABLE GRABBED FROM UTILITY CLASS (CONSTANTS) */
		String add = 'Add';
		String terminal = OB_UtilityConstants.POS_RT;
		String vas = OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS;
		/*SORTING LIST FOR RETURNING INTO MAP */
		List<NE__OrderItem__c> orderItems 	= new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> childVas 	= new List<NE__OrderItem__c>();
		Map<String, List<Object>> toReturn 	= new Map<String, List<Object>>();
		List<Object> disconnectedVas = new List<Object>();

		orderItems = 				[SELECT Id,
										Name,
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
										NE__ProdId__c,
										NE__ProdId__r.Name,
										NE__ProdId__r.RecordType.DeveloperName,
										NE__Parent_Order_Item__c,
										OB_Processor__c,
										OB_ServicePointType__c,
										OB_GT__c,
										OB_ShopCode__c,
										OB_TermId__c,
										OB_Numero_Assitenza_POS__c,
										(SELECT Id, Name, NE__Value__c, NE__Order_Item__c  FROM NE__Order_Item_Attributes__r),
											(SELECT Id,
													NE__Root_Order_Item__c,
													OB_enablement__c,  
													OB_Old_Enablement__c , 
													NE__ProdId__r.Name , 
													NE__StartDate__c , 
													NE__EndDate__c
											FROM 	NE__Order_Items_Conf__r 
											WHERE 	( RecordType.DeveloperName = 'Acquiring') OR (RecordType.DeveloperName = 'Pagobancomat') )
								  FROM  NE__OrderItem__c  
								  WHERE NE__OrderId__c  =: configurationId 	AND 
								  NE__Parent_Order_Item__c = null 			AND (
									(NE__ProdId__r.RecordType.DeveloperName =: terminal) 		OR
									(NE__ProdId__r.RecordType.DeveloperName = 'Acquiring') 		OR
									(NE__ProdId__r.RecordType.DeveloperName = 'Vas')			OR
									(NE__ProdId__r.RecordType.DeveloperName = 'Pagobancomat'))
									
								  ];

		System.debug('orderItems is: ' + orderItems);

		List<NE__OrderItem__c> sortedConfigurationItems 					= new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> configurationTerminalItemsAdd 				= new List<NE__OrderItem__c>();
		
		List<NE__Order_Item_Attribute__c> configurationAttributesChildren 	= new List<NE__Order_Item_Attribute__c>();
		List<NE__Order_Item_Attribute__c> configurationAttributesPB 	= new List<NE__Order_Item_Attribute__c>();
		List<NE__Order_Item_Attribute__c> childrenTerminalAttributes 	= new List<NE__Order_Item_Attribute__c>();

		List<NE__OrderItem__c> 	listAcquiringItem 	= new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> 	listVasItem 			= new List<NE__OrderItem__c>();
		List<NE__OrderItem__c> 	listPagoBancomatItem = new List<NE__OrderItem__c>();
		// List<NE__OrderItem__c>	listVasParent = new List<NE__OrderItem__c>();
		List<Object>	listVasParent = new List<Object>();
		List<OB_Maintenance_Consistenza_LogRequest_CC.WrapperTerminalwithVAS> terminalwithVAS = new List<OB_Maintenance_Consistenza_LogRequest_CC.WrapperTerminalwithVAS>();
		
		Map<String, WrapperTerminalwithVAS> vasMap = new Map<String, WrapperTerminalwithVAS>();
		

		List<String> IdTerminalParentVas = new List<String>();
		List<NE__OrderItem__c> listMatches = new List<NE__OrderItem__c>();
		Map<String, NE__OrderItem__c> tmpTerminalMap = new Map<String, NE__OrderItem__c>();
		if(!orderItems.isEmpty() && orderItems.size() > 0) {
			System.debug('List Not Empty');
			sortedConfigurationItems.addAll(orderItems);
		
			
			for(NE__OrderItem__c singleConfigurationItem : orderItems ) {
				if(singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.ACQUIRING) && singleConfigurationItem.NE__Action__c != 'None' && singleConfigurationItem.NE__Action__c != 'Change' && singleConfigurationItem.NE__Parent_Order_Item__c == null) {
					listAcquiringItem.add(singleConfigurationItem);
					System.debug('listAcquiringItem is: '+ listAcquiringItem);
				}
				if(singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Vas') && singleConfigurationItem.NE__Action__c != 'None' && singleConfigurationItem.NE__Parent_Order_Item__c == null) {
					WrapperTerminalwithVAS wrapperObject = new WrapperTerminalwithVAS();
					wrapperObject.VAS = singleConfigurationItem;
					//listVasParent.add(singleConfigurationItem);
					System.debug('listVasParent is : ' + listVasParent);
					vasMap.put(singleConfigurationItem.NE__ProdId__c, wrapperObject);
					
					
				}
				if(singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Pagobancomat') && singleConfigurationItem.NE__Order_Item_Attributes__r!=null && (singleConfigurationItem.NE__Order_Item_Attributes__r!=null && singleConfigurationItem.NE__Order_Item_Attributes__r.size() > 0)  && singleConfigurationItem.NE__Parent_Order_Item__c==null){
					System.debug('singleConfigurationItem PB is :  ' + singleConfigurationItem);
					listPagoBancomatItem.add(singleConfigurationItem);
					System.debug('listPagoBancomatItem is : ' + listPagoBancomatItem);
				}
				if(singleConfigurationItem.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase(terminal)) {     
					tmpTerminalMap.put(singleConfigurationItem.Id, singleConfigurationItem);
					if(singleConfigurationItem.NE__Action__c != 'None') { 
						configurationTerminalItemsAdd.add(singleConfigurationItem);
						/* SET IN A LIST ALL ID OF PARENT TERMINAL !*/
						IdTerminalParentVas.add(singleConfigurationItem.Id);
						System.debug('IdTerminalParentVas is : ' + IdTerminalParentVas);
					}
				}
			}
		}
			
		childVas = 	[ 
								SELECT Id,
										Name,
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
										NE__ProdId__c,
										NE__ProdId__r.Name,
										OB_TermId__c,
										NE__Parent_Order_Item__c,
										NE__ProdId__r.RecordType.DeveloperName,
										OB_Processor__c,
										OB_ServicePointType__c,
										OB_GT__c,
										OB_ShopCode__c,
										OB_Numero_Assitenza_POS__c						
							FROM NE__OrderItem__c
							WHERE NE__Parent_Order_Item__c IN: IdTerminalParentVas 
							AND NE__ProdId__r.RecordType.DeveloperName = 'Vas'
						];
		disconnectedVas	 = 	[ SELECT Id,
										Name,
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
										NE__ProdId__c,
										NE__ProdId__r.Name,
										OB_TermId__c,
										NE__Parent_Order_Item__c,
										OB_Processor__c,
										OB_ServicePointType__c,
										OB_GT__c,
										OB_ShopCode__c,
										NE__ProdId__r.RecordType.DeveloperName,
										OB_Numero_Assitenza_POS__c						
							FROM NE__OrderItem__c
							WHERE NE__OrderId__c = :configurationId 
							AND NE__Parent_Order_Item__c = null 
							AND NE__ProdId__r.RecordType.DeveloperName = 'Vas'
						];

						

		System.debug('childVas is : '+ childVas);

		List<WrapperTerminalwithVAS> finalWrapper = new List<WrapperTerminalwithVAS>();

		List<NE__Order_Item_Attribute__c> attributes = new List<NE__Order_Item_Attribute__c>();

		OB_Maintenance_Consistenza_LogRequest_CC.WrapperTerminalwithVAS wrapperTerminalwithVAS;
		
		System.debug('tmpTerminalMap is : ' + tmpTerminalMap);

		/*		 
		for(NE__OrderItem__c vasItem : childVas) {
				if(vasItem.NE__Action__c != 'None' || vasItem.OB_enablement__c != vasItem.OB_Old_Enablement__c) {
					wrapperTerminalwithVAS = new WrapperTerminalwithVAS();
					wrapperTerminalwithVAS = vasMap.get(vasItem.NE__ProdId__c);
					NE__OrderItem__c terminalItm = tmpTerminalMap.get(vasItem.NE__Parent_Order_Item__c);
                    if(terminalItm != null){
                      	wrapperTerminalwithVAS.terminalList.add(terminalItm);
                        System.debug('tmpTerminalMap.get(vasItem.NE__Parent_Order_Item__c) is : ' + tmpTerminalMap.get(vasItem.NE__Parent_Order_Item__c));
                        for(String str : vasMap.keySet() ) {
                            listVasParent.add((Object)vasMap.get(str));
                        }  
                    }
					
				}
		}
        */
		System.debug('listVasParent is : ' + listVasParent);
		// if(!finalWrapper.isEmpty()) {
		// 	toReturn.put('FINALWRAPPER', finalWrapper);
		// }
		
		if(sortedConfigurationItems.size() > 0) {
			toReturn.put('AllConfigurationItems', sortedConfigurationItems );
		}
		if(listAcquiringItem.size() > 0) {
			toReturn.put('listAcquiringItem', listAcquiringItem);
		}
		if(listVasItem.size() > 0) {
			toReturn.put('listVasItem', listVasItem);
		}
		if(listPagoBancomatItem.size() > 0) {
			toReturn.put('listPagoBancomatItem', listPagoBancomatItem);
		}
		if(configurationTerminalItemsAdd.size() > 0 ) {
			toReturn.put('terminalItems', configurationTerminalItemsAdd );
		}
		if(listVasParent.size() > 0 ) {
			toReturn.put('vasChild', listVasParent);
		}
		if(disconnectedVas.size() > 0) {
			toReturn.put('VasDisconnected', disconnectedVas);
		}
		System.debug('Massive Map toReturn is: ' + JSON.serialize(toReturn));
		return  JSON.serialize(toReturn);
	}

	/*CONFIGURATION ITEM ATTRIBUTE:*/
	@AuraEnabled
	public static Map<String, List<NE__Order_Item_Attribute__c>> getConfigurationItemAttributeServer(List<String> listConfigurationItemIDS) {
		List<NE__Order_Item_Attribute__c> configurationItemAttributes = null;
		List<NE__Order_Item_Attribute__c> PagoBancomatItemAttributes = null;
		
		Map<String, List<NE__Order_Item_Attribute__c>> toReturn = null;
		System.debug('INSIDE getConfigurationItemAttributeServer');		
		System.debug('Inside OB_Maintenance_Consistenza_LogRequest_CC.getConfigurationItemAttributeServer()');
		System.debug('listConfigurationItemIDS '+ listConfigurationItemIDS);

		configurationItemAttributes = new List<NE__Order_Item_Attribute__c>();
		configurationItemAttributes = [SELECT 	Id,
												Name,
												NE__Value__c,
											 	NE__Order_Item__c,
											 	NE__Order_Item__r.RecordType.Name,
												NE__Order_Item__r.RecordType.DeveloperName,
												NE__Order_Item__r.NE__ProdId__r.RecordType.DeveloperName
									 FROM 		NE__Order_Item_Attribute__c
									 WHERE 		NE__Order_Item__c  IN: listConfigurationItemIDS
									 AND		NE__Order_Item__r.NE__Action__c != 'None'
									 AND		NE__Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Pagobancomat'
									 AND		NE__Order_Item__r.NE__Parent_Order_Item__c = null];
		System.debug('configurationItemAttributes are: ' + configurationItemAttributes);
		
		toReturn = new Map<String, List<NE__Order_Item_Attribute__c>>();
		List<NE__Order_Item_Attribute__c> SIAitemsAttributes = new List<NE__Order_Item_Attribute__c>();
		List<NE__Order_Item_Attribute__c> progressiveSIAAttributes = new List<NE__Order_Item_Attribute__c>();
		List<NE__Order_Item_Attribute__c> SIACODEitemsAttributes = new List<NE__Order_Item_Attribute__c>();
		
		if(!configurationItemAttributes.isEmpty() && configurationItemAttributes.size() > 0) {
			for(NE__Order_Item_Attribute__c singleAttr : configurationItemAttributes) {
				if(singleAttr.NE__Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('PagoBancomat')) {
					if(singleAttr.Name.equalsIgnoreCase('Codice Stabilimento SIA')) {
						SIAitemsAttributes.add(singleAttr);
					}
					if(singleAttr.Name.equalsIgnoreCase('Progressivo SIA')) {
						progressiveSIAAttributes.add(singleAttr);
					}
					if(singleAttr.Name.equalsIgnoreCase('Codice SIA')) {
						SIACODEitemsAttributes.add(singleAttr);
					}
				} 
			}
		}
		
		
		
		if(!SIAitemsAttributes.isEmpty()) {
			toReturn.put('SIAITEMS', SIAitemsAttributes);
		}
		if(!progressiveSIAAttributes.isEmpty()) {
			toReturn.put('PROGRESSIVESIA', progressiveSIAAttributes);
		}
		if(!SIACODEitemsAttributes.isEmpty()) {
			toReturn.put('SIACODEITEMS', SIACODEitemsAttributes);
		}
		System.debug('Final Map is : ' + toReturn);								
		return toReturn;
	}



/**
	*@author shaghayegh tofighian <shaghayegh.tofighian@accenture.com> 
	*@date 02/05/2019
	*@description this method updates the list of orderitem
*/
	@AuraEnabled
	public static Boolean getSortedConfigItemsServer2UpdateList(list<NE__OrderItem__c> orderItems)
	{


		try
		{
			update orderItems;
            System.debug('@Setup : callSubmit - Id: ' + orderItems[0].NE__OrderId__r.NE__Order_Header__c);
            String orderHeaderid = orderItems[0].NE__OrderId__r.NE__Order_Header__c;
			//System.enqueueJob(new OB_QueueableClass(orderHeaderId)); // Simone Misani 03/07/2019  F2WAVE2-82
			return true;
		}
	  catch(Exception ecc)
		{

			System.debug('[EXCE]  OB_Maintenance_Consistenza_LogRequest_CC getSortedConfigItemsServer2UpdateList: '+ecc.getMessage()+' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			return false;
		}
	}

		/*****************************************************************
		Purpose: Update log Request and related Object when is confirmed SIA
		Parameters: OB_LogRequest__C logRequest
		Returns: String outcome

		History
		--------
		VERSION AUTHOR 				DATE 		DETAIL 		Description
		1.0 	Salvatore Pianura 	06/05/2019 	Created 	CSR:
		*****************************************************************/
		@AuraEnabled
		public static void updateRequestSia(OB_LogRequest__c logRequest)
		{
			try
			{
				System.debug('@Into OB_Maintenance_Consistenza_LogRequest_CC.updateRequestSia()');
				String orderHeaderId = logRequest.OB_OrderId__r.NE__Order_Header__c;
				logRequest.OB_SIAToBeApproved__c = false;
				logRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
				update logRequest;
				//System.enqueueJob(new OB_QueueableClass(orderHeaderId));
			}
			catch(Exception ecc)
			{
				System.debug('[EXCE]  OB_Maintenance_Consistenza_LogRequest_CC.updateRequestSia: '+ecc.getMessage()+' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}
		}



		/*****************************************************************
		Purpose: checks whether the situation is technical Configuration
		Parameters: String  configurationId
		Returns: Boolean isConftech

		History
		--------
		VERSION  AUTHOR 				DATE 		  DETAIL 		Description
		1.0 	Simone Misani 	07/07/2019 	Created 	CSR:
		*****************************************************************/

			@AuraEnabled
		public  static Boolean compatibilityTechnicalConfigurator(String configurationId){
			Boolean isConftech = false;
			System.debug('in to the compatibilityTechnicalConfigurator');
			List<NE__OrderItem__c> listOrderIAcquandVas = [	SELECT 	id,
																										NE__Action__c,
																										NE__OrderId__c,
																										NE__ProdId__r.RecordType.DeveloperName,
																										NE__ProdName__c,
																										OB_enablement__c,
																										OB_Old_Enablement__c,
																										NE__Root_Order_Item__c	//Simone Misani 10/07/2019 fix Configuratore Tecnico
																						FROM 		NE__OrderItem__c 
																						WHERE 
																										NE__OrderId__c =:configurationId
																										AND(NE__ProdId__r.RecordType.DeveloperName ='Vas' OR NE__ProdId__r.RecordType.DeveloperName = 'Acquiring')
																										AND (NE__Action__c !='None'
																										OR NE__Action__c 	!='Remove')
																										];

				List<NE__OrderItem__c> listOrderITerminal = [	SELECT 	id,
																											NE__Action__c,
																											NE__OrderId__c,
																											NE__ProdId__r.RecordType.DeveloperName,
																											NE__ProdName__c
																							FROM 		NE__OrderItem__c 
																							WHERE 
																											NE__OrderId__c =:configurationId
																											AND NE__ProdId__r.RecordType.DeveloperName ='Terminali'
																											AND NE__Action__c =: OB_UtilityConstants.ORDERITEM_ACTION_NONE
																										];
			if(!listOrderITerminal.isEmpty()){
				if(!listOrderIAcquandVas.isEmpty()){
					for(NE__OrderItem__c oiTerm : listOrderITerminal){
						for(NE__OrderItem__c oi :listOrderIAcquandVas){
								System.debug('NE__ProdName__c:'+ oi.NE__ProdName__c );
								System.debug('NE__Action__cterm:'+ oiTerm.NE__Action__c);
								System.debug('NE__Action__c:'+ oi.NE__Action__c);
								//START-----Simone Misani 10/07/2019 fix Configuratore  Tecnico
								if(oiTerm.id == oi.NE__Root_Order_Item__c ){							

									if(oi.NE__ProdName__c == OB_UtilityConstants.ACQUIRING_UPI &&  oiTerm.NE__Action__c==OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_ADD) {
										isConftech =  true;
									}
									else if(oi.NE__ProdName__c == OB_UtilityConstants.ACQUIRING_UPI  && oiTerm.NE__Action__c==OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c=='Change' && oi.OB_enablement__c=='Y' && oi.OB_Old_Enablement__c== 'N'){
										isConftech = true;
									}
									else if((oi.NE__ProdName__c== OB_UtilityConstants.VAS_TAX_FREE || oi.NE__ProdName__c== OB_UtilityConstants.VAS_DCC ||oi.NE__ProdName__c== OB_UtilityConstants.VAS_PREAUT)  && oiTerm.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_ADD){
												isConftech =  true;
									}
									else if((oi.NE__ProdName__c== OB_UtilityConstants.VAS_TAX_FREE || oi.NE__ProdName__c== OB_UtilityConstants.VAS_DCC ||oi.NE__ProdName__c== OB_UtilityConstants.VAS_PREAUT)  && oiTerm.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c=='Change' && oi.OB_enablement__c=='Y' && oi.OB_Old_Enablement__c== 'N'){
									isConftech = true ;
									}
								}else if (String.isBlank(oi.NE__Root_Order_Item__c))
								{
									if(oi.NE__ProdName__c == OB_UtilityConstants.ACQUIRING_UPI &&  oiTerm.NE__Action__c==OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_ADD ) {
										isConftech =  true;
									}
									else if(oi.NE__ProdName__c == OB_UtilityConstants.ACQUIRING_UPI  && oiTerm.NE__Action__c==OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c=='Change' && oi.OB_enablement__c=='Y' && oi.OB_Old_Enablement__c== 'N' ){
										isConftech = true;
									}
									else if((oi.NE__ProdName__c== OB_UtilityConstants.VAS_TAX_FREE || oi.NE__ProdName__c== OB_UtilityConstants.VAS_DCC ||oi.NE__ProdName__c== OB_UtilityConstants.VAS_PREAUT)  && oiTerm.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_ADD){
												isConftech =  true;
									}
									else if((oi.NE__ProdName__c== OB_UtilityConstants.VAS_TAX_FREE || oi.NE__ProdName__c== OB_UtilityConstants.VAS_DCC ||oi.NE__ProdName__c== OB_UtilityConstants.VAS_PREAUT)  && oiTerm.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Action__c=='Change' && oi.OB_enablement__c=='Y' && oi.OB_Old_Enablement__c== 'N'){
									isConftech = true ;
									}
								}
						}
					}
						//END -----Simone Misani 10/07/2019 fix Configuratore Tecnico
				
				}
			}
			System.debug('isConftech: '+isConftech);
				return isConftech;
		}
		// 	@AuraEnabled
		// public  static Boolean compatibilityTechnicalConfigurator(String configurationId){
			
		// 	System.debug('in to the compatibilityTechnicalConfigurator');
		// 	List<NE__OrderItem__c> listOrderIAcquandVas = [	SELECT 	id,
		// 																								NE__Action__c,
		// 																								NE__OrderId__c,
		// 																								NE__ProdId__r.RecordType.DeveloperName,
		// 																								NE__ProdName__c,
		// 																								NE__ProdId__r.OB_Codice_sfdc__c, //enrico.purificato WN-261
		// 																								OB_enablement__c,
		// 																								OB_Old_Enablement__c,
		// 																								NE__Root_Order_Item__c	//Simone Misani 10/07/2019 fix Configuratore Tecnico
		// 																				FROM 		NE__OrderItem__c 
		// 																				WHERE 
		// 																								NE__OrderId__c =:configurationId
		// 																								AND(NE__ProdId__r.RecordType.DeveloperName ='Vas' OR NE__ProdId__r.RecordType.DeveloperName = 'Acquiring')
		// 																								AND (NE__Action__c !='None'
		// 																								OR NE__Action__c 	!='Remove')
		// 																								];
		// 	//enrico.purificato WN-261 START
		// 	String UPI 		= 'UPI';
		// 	String TAXFREE 	= 'TAX_FREE';
		// 	String DCC		= 'DCC';
		// 	String PREAUT	= 'PRE-AUT';

		// 	if(listOrderIAcquandVas.size()==0){
		// 		return false;
		// 	}

		// 	Boolean isConftech = false;
		// 	for(NE__OrderItem__c oi :listOrderIAcquandVas){
				
		// 		Boolean isTech = oi.NE__ProdId__r.OB_Codice_sfdc__c == UPI || oi.NE__ProdId__r.OB_Codice_sfdc__c == TAXFREE	
		// 						||  oi.NE__ProdId__r.OB_Codice_sfdc__c == DCC || oi.NE__ProdId__r.OB_Codice_sfdc__c == PREAUT;

		// 		if(isTech && (oi.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_ADD || oi.NE__Action__c=='Change'))
		// 		{
		// 			if(oi.NE__Root_Order_Item__c == null && oi.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_ADD){
		// 				isConftech =  true;
		// 				break;
		// 			}
		// 			if(oi.NE__Root_Order_Item__c != null && (oi.NE__Action__c== OB_UtilityConstants.ORDERITEM_ACTION_ADD  || 
		// 													(oi.NE__Action__c=='Change' && oi.OB_enablement__c=='Y' && oi.OB_Old_Enablement__c== 'N'))){
		// 				isConftech =  true;
		// 				break;
		// 			}
		// 		}

		// 	}
		// 	//enrico.purificato WN-261 END
		// 	System.debug('isConftech: '+isConftech);
		// 	return isConftech;
		// }

		/*****************************************************************
		Purpose: create secondo log requets after cofrim first
		Parameters: Id  logRequestId
		Returns: Boolean isConftech

		History
		--------
		VERSION  AUTHOR 				DATE 		  DETAIL 		Description
		1.0 	Simone Misani 	07/07/2019 	Created 	CSR:
		*****************************************************************/


		@AuraEnabled
		public static string createSecondLogrequestTechnicalConfigurator(Id logRequestId){
			System.debug('createSecondLogrequestTechnicalConfigurator');
			OB_LogRequest__c secondLogRequest =  new OB_LogRequest__c();

			list<OB_LogRequest__c> listOldLogrequest = [	SELECT	OB_AccountId__c,
																												OB_ServicePointId__c,
																												OB_OrderId__c,
																												OB_ABI__c,
																												OB_CAB__c,
																												OB_MaintenanceType__c,
																												OB_Status__c,
																												OB_HasAcquiring__c,
																												OB_HasPos__c,
																												OB_HasVas__c,
																												RecordTypeId,
																												OB_isNotIntegrated__c,
																												OB_SIAToBeApproved__c,
																												OB_OrderId__r.NE__Order_Header__c,
																												OB_Track_LogRequest__c,
																												OB_Requestor__c,//Simone Misani  set  required field  23/08/2019
																												OB_RequestDate__c//Simone Misani  set  required field  23/08/2019
																								FROM 	OB_LogRequest__c
																								WHERE Id=: logRequestId];
			if(!listOldLogrequest.isEmpty()){

					OB_LogRequest__c oldLogRequets = new OB_LogRequest__c();
					NE__Service_Point__c mccSP = new NE__Service_Point__c();
					oldLogRequets = listOldLogrequest.get(0);
					List<NE__Service_Point__c> listmcc = [	SELECT id, OB_MCC__c 
																								FROM	NE__Service_Point__c
																								WHERE Id =: oldLogRequets.OB_ServicePointId__c];
				if(!listmcc.isEmpty()){
							mccSP = listmcc.get(0);
					

					Id rtConsistenza = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.CONSISTENZART).getRecordTypeId();
					secondLogRequest.OB_AccountId__c		    	= 	oldLogRequets.OB_AccountId__c;
					secondLogRequest.OB_ServicePointId__c   	= 	oldLogRequets.OB_ServicePointId__c;
					secondLogRequest.OB_OrderId__c          	= 	oldLogRequets.OB_OrderId__c;
					secondLogRequest.OB_ABI__c			        	=		oldLogRequets.OB_ABI__c;
					secondLogRequest.OB_CAB__c			        	=		oldLogRequets.OB_CAB__c;
					secondLogRequest.OB_MaintenanceType__c  	=   oldLogRequets.OB_MaintenanceType__c;
					secondLogRequest.OB_Status__c			      	=		OB_UtilityConstants.BOZZA;
					secondLogRequest.OB_HasAcquiring__c   		=   oldLogRequets.OB_HasAcquiring__c;
					secondLogRequest.OB_HasPos__c           	=   oldLogRequets.OB_HasPos__c;
					secondLogRequest.OB_HasVas__c           	=   oldLogRequets.OB_HasVas__c;
					secondLogRequest.OB_OrderId__c          	=   oldLogRequets.OB_OrderId__c;
					secondLogRequest.RecordTypeId			      	=		rtConsistenza;			
					secondLogRequest.OB_isNotIntegrated__c  	=   oldLogRequets.OB_isNotIntegrated__c;
					secondLogRequest.OB_Requestor__c 					=		oldLogRequets.OB_Requestor__c;//Simone Misani  set  required field  23/08/2019
					secondLogRequest.OB_RequestDate__c 				=		oldLogRequets.OB_RequestDate__c;//Simone Misani  set  required field  23/08/2019
					if(mccSP.OB_MCC__c !='5542'){
						secondLogRequest.OB_SIAToBeApproved__c  = 	false;
					}else{
						secondLogRequest.OB_SIAToBeApproved__c  = oldLogRequets.OB_SIAToBeApproved__c;
					}
					secondLogRequest.OB_Track_LogRequest__c		=		true;

					oldLogRequets.OB_Status__c= OB_UtilityConstants.CONFERMATO;
					update oldLogRequets;
					insert  secondLogRequest;
					System.debug('secondLogRequest: '+secondLogRequest);
					String orderHeaderId = oldLogRequets.OB_OrderId__r.NE__Order_Header__c;
					System.debug(orderHeaderId);
					System.enqueueJob(new OB_QueueableClass(orderHeaderId));
				}
			}

			String returnUrlNewLogrequest = OB_MainApprovedPricingProcessController.getStringUrl();
			returnUrlNewLogrequest = returnUrlNewLogrequest+'/'+secondLogRequest.Id;
			return returnUrlNewLogrequest;
			
		}

}