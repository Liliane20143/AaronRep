global class OB_Maintenance_Flow_Override implements bit2flow.dynWizardsIFExt  {
	//BUILD RECORD TYPE
	static final Id rtDatiSocietaLegale 			= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId();
	static final Id rtEsecutore    					= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ESECUTORE ).getRecordTypeId();
	static final Id rtReferentePuntoVendita      	= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.REFERENTE_PUNTO_VENDITA ).getRecordTypeId();
	static final Id rtReferenteTecnico    			= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.REFERENTE_TECNICO ).getRecordTypeId();
	static final Id rtResponsabileAmministrativo 	= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO ).getRecordTypeId();
	static final Id rtTitolareEffettivo   			= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId();
	//RECORD TYPE BANK
	static final Id rtBank 							= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId();
	//RECORD TYPE CONSISTENZA
	static final Id rtConsistenza					= Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.CONSISTENZART ).getRecordTypeId();
	static final List<Id> rtList = new List<Id>{rtDatiSocietaLegale , rtEsecutore,rtTitolareEffettivo};
	//RECORD TYPE COMMERCIAL PRODUCT
	//26/07/19 francesca.ribezzi using commercial product record type
	//Simone Misani WN-610 14/10/2019 START
	static final Id rtPOSEcommerce					= Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('eCommerce' ).getRecordTypeId();
	static final Id rtPOS					= Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.POS_RT ).getRecordTypeId();
	static final Id rtPOSMoto					= Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO ).getRecordTypeId();
	//Simone Misani WN-610 14/10/2019 END
	static final Id rtACQUIRING				= Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId();
	static final List<Id> rtListOrderItem	= new List<Id>{rtACQUIRING , rtPOS,rtTitolareEffettivo, rtPOSEcommerce ,rtPOSMoto};//Simone Misani 16/10/2019

	/*******************************************************************************
    Purpose:  		Control method to parse Boolean to String
	Method name: 	parseBoolean
    History:
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Francesca Ribezzi       01/07/2019      Created         F2WAVE2-53
    ********************************************************************************/
	private static String parseBoolean(Boolean a) {
		String toReturn = '';
		if(a) {
			toReturn = 'true';
		} else {
			toReturn = 'false';
		}
		return toReturn;
	}

	public static bit2flow.DynamicWizardStepWrapper validate(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
		System.debug('Validate Method in OB_Maintenance_Flow_Override');
		System.debug('STEP_VALIDATE: ' + step);
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		try
		{
			System.debug('response' + response);
			switch on step
			{
				
				// Step == Dati Societa
				when 'step2'
				{
					//...do some other thing
					System.debug('In Validate Method with step :' + step);
					response = executeMethod(step, data, 'targetObjectKey','companyData', stepsDefinition, dynamicWizardWrapper);
				}
				// Step == Titolari Effettivi
				when 'step3'
				{
					//...do some other thing
					System.debug('In Validate Method with step :' + step);
					response = executeMethod(step, data, 'targetObjectKey','actualOwner', stepsDefinition, dynamicWizardWrapper);
				}
				// Step == Punto Vendita
				when 'step4'
				{
					System.debug('In Validate Method with step :' + step);
					response = executeMethod(step, data, 'targetObjectKey','servicePoint', stepsDefinition, dynamicWizardWrapper);

				}
				// Step == Carica Documenti
				when 'step5'
				{
					//...do some other thing
					System.debug('In Validate Method with step :' + step);
					response = executeMethod(step, data, 'targetObjectKey','downloadDocument', stepsDefinition, dynamicWizardWrapper);
				}
			}
			System.debug('response' + response);
		}
		catch(Exception ecc)
			{
			System.debug('Generic Error validate: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}

			
		return response;
		
	}
	
	@AuraEnabled
	public static bit2flow.DynamicWizardStepWrapper overwriteNext (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
	{    
		System.debug('OVERWRITE NEXT METHOD');     
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		try
		{
			switch on step
			{
			// Step == Dati Operativi
				when '1'
				{
					//...do some other thing
					System.debug('Overwrite of next button operational data');
					response = executeMethod(step, data, 'targetObjectKey','operationalData', stepsDefinition, WizardWrapper);
				}
				// Step == Carica Documenti
				when '5'
				{
						//...do some other thing
						response = executeMethod(step, data, 'targetObjectKey','downloadDocument', stepsDefinition, WizardWrapper);

				}
				when else 
				{
			 //...under all other circumstances
				}
			}
			
			System.debug('response' + response);
		}
		catch(Exception ecc)
			{
			System.debug('Generic Error overwriteNext: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}

			return response;
			//return null;
		}
	
		@AuraEnabled
		public static bit2flow.DynamicWizardStepWrapper overwritePrevious (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
		{  
				
			bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
			System.debug('OVERWRITE PREVIOUS METHOD');
			System.debug('overwritePrevious data dati ' + data);
				String stepName =String.valueOf(step);
			System.debug('overwritePrevious step : '	+ step);
				System.debug('overwritePrevious step name ' + stepName);
				try
				{

					
					switch on stepName
					{
						// Step == dati Societa
					when '2'
					{
						//....do some other thing
						System.debug('COMPANYDATA_PREVIOUS_CALL_METHOD');
						response = executeMethod(step, data, 'targetObjectKey','companyDataPrevious', stepsDefinition, WizardWrapper);
					}
					//Step == Service Point
					when '4'
					{
						//....do some other thing
						System.debug('SERVICEPOINT_PREVIOUS_CALL_METHOD');
						response = executeMethod(step, data, 'targetObjectKey','servicePointPrevious', stepsDefinition, WizardWrapper);
					}	
					//Step == Riepilogo
					when '5'
					{
						System.debug('RIEPILOGO_PREVIOUS_CALL_METHOD');
						//....do some other thing
						response = executeMethod(step, data, 'targetObjectKey','riepilogoPrevious', stepsDefinition, WizardWrapper);
					}
					when '6'
					{
						System.debug('into previous riepilogo');
					}
					when else 
					{
						//...under all other circumstances
						System.debug('into previous other');
					}
					}
				}
				catch(Exception ecc)
				{
				System.debug('Generic Error overwritePrevious: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
				}
		
			return response;
		}

		@AuraEnabled
		public static bit2flow.DynamicWizardStepWrapper overwriteSave (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper,String targetObjectKey)
		{		
			System.debug('OVERWRITE SAVE METHOD');
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		System.debug('overwriteSave data dati ' + data);
		String stepName =String.valueOf(step);
		System.debug('overwriteSave step name ' + stepName);
		try{
				switch on stepName
				{
					when '2'
					{
						//....do some other thing 
						//response = executeMethod(step, data, 'targetObjectKey','riepilogoSave', stepsDefinition, WizardWrapper);
						response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
						}
						when '3'
						{
					//....do some other thing
					response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
						}
						when '4'
						{ 
						//....do some other thing
						response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
						}
						when '5'
						{
						//....do some other thing
						response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
						}
					when else 
					{
					//...under all other circumstances
						}
					}
			
			}
			catch(Exception ecc)
			{
				System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}
		//try
		//{
		//	system.debug('saveHistoricData: ' + data);	

		//	//	START 	micol.ferrari 12/11/2018
		//	String orderString = JSON.serialize(data.get('OrderHeader'));
		//	System.debug(' orderString string :' + orderString);
		//	NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderString, NE__Order_Header__c.class);
		//	//	END 	micol.ferrari 12/11/2018

		//	// Retrieve from the wrapper the wizardId (not the attach Id). If the field is not there or it is empty, get the Id by Name
		//	String wizardIdValue = '';
		//	System.debug('wizardWrapper.wizardId: ' + wizardWrapper.wizardId);
	
		//	if(wizardWrapper.wizardId != null && wizardWrapper.wizardId != '')
		//	{
		//		wizardIdValue = wizardWrapper.wizardId;
		//	}
		//	else
		//	{
		//		// we have to retrieve the Id from the IntegrationAdministarion or the Wizard Definition

		//		if(Type.forName('NE__IntegrationAdministration__c') != null)
		//		{
		//			System.debug('Finding administrationList');
		//			List<sObject> administrationList = Database.query('SELECT Id FROM NE__IntegrationAdministration__c WHERE NE__Name__c =\'' + wizardWrapper.name + '\' ORDER BY CreatedDate DESC LIMIT 1');
		//			System.debug('administrationList: ' + administrationList);
		//			if(!administrationList.isEmpty())
		//			{
		//				wizardIdValue = (String) administrationList[0].get('Id'); 
		//			}
		//		}
		//		//JGL 20/03/2018 fix saving historic 
		//		if(wizardIdValue =='')
		//		{	
		//			System.debug('Finding wizarddefList');
		//			List<sObject> wizarddefList = Database.query('SELECT Id FROM bit2flow__Wizard_Definition__c WHERE bit2flow__Name__c =\'' + wizardWrapper.name + '\' ORDER BY CreatedDate DESC LIMIT 1');
		//			System.debug('wizarddefList: ' + wizarddefList);
		//			if(!wizarddefList.isEmpty())
		//			{
		//				wizardIdValue = (String) wizarddefList[0].get('Id');
		//			}
		//		}
		//	}

		//   	sObject historicData = bit2flow.B2FUtils.newSObject('bit2flow__Historic_Wizard_Data__c'); 	

		//   	historicData.put('bit2flow__Wizard_Name__c',wizardWrapper.name);
		//   	historicData.put('bit2flow__Wizard_Label__c',wizardWrapper.label);
		//   	historicData.put('bit2flow__Status__c','Draft');
		//   	historicData.put('bit2flow__Wizard_Id__c',wizardIdValue);	

		//   	//	START 	micol.ferrari 12/11/2018
		//   	historicData.put('OB_OrderHeaderId__c',orderHeader.Id);
		//   	//	END 	micol.ferrari 12/11/2018

		//   	String historicExistingId = '';
	
		//   	if(data.containsKey('historicObject'))
		//   	{   
		//		historicExistingId = (String) bit2flow.B2FUtils.getJSONValue(data,'historicObject','Id');
		//	 	historicData.put('Id',historicExistingId);

		//		// remove all the previous attachments
		//		List<sObject> attachsToDelete = Database.query('SELECT Id FROM Attachment WHERE ParentId = \'' + historicExistingId + '\'');

		//		delete  attachsToDelete;  
		//   }

		//   	upsert historicData;

		//   	System.debug('upsert done: ' + historicData);	

		//   	List<Attachment> atachmentsList = new List<Attachment>();

		//   	// data attachment
		//	Attachment dataAttachment = new Attachment();
		//	System.debug('DATA: '+JSON.serialize(data));
		//	dataAttachment.Body = Blob.valueOf(JSON.serialize(data));
		//	dataAttachment.Name = String.valueOf('dataJSON.json');
		//	dataAttachment.ParentId = (Id) historicData.get('Id');
		
		//   	atachmentsList.add(dataAttachment);

		//	// wrapper attachment
		//   	Attachment wrapperAttachment = new Attachment();
		//   	wrapperAttachment.Body = Blob.valueOf(String.valueOf(wizardWrapper));
		//   	wrapperAttachment.Name = String.valueOf('wrapperJSON.json');
		//   	wrapperAttachment.ParentId = (Id) historicData.get('Id');
		
		//   	atachmentsList.add(wrapperAttachment);

		//   	insert atachmentsList;
		//}
		//catch(Exception e)
		//{
		//	System.debug('Exception creating JSON attach: ' + e.getMessage());

		//}

		response.result = '000';
				response.description = 'This is a successfully test for overwrite a wizard button';
		//response.stepToGo = 2;
				response.data = data;
				response.dynamicWizardWrapper = wizardWrapper;

		System.debug('response' + response);
		return response;
		}
		@AuraEnabled
		public static bit2flow.DynamicWizardStepWrapper overwriteExit (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper,String targetObjectKey){
			
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
			
		response.result = '000';
		response.description = 'This is a successfully test for overwrite a wizard button';
			//response.stepToGo = 2;
		response.data = data;
		response.dynamicWizardWrapper = wizardWrapper;

		System.debug('response' + response);
		
		return response;
		}
	
	//funzione per modificare la visibilità di una sezione/campo
	 @AuraEnabled
	 global static bit2flow.DynamicWizardWrapper updateSection(bit2flow.DynamicWizardWrapper wizardWrapper,String stepName, Integer sectionPos, Boolean hidden){
		 return null;
	 }
	
		@AuraEnabled
		global static bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
		System.debug('EXECUTE METHOD');
		System.debug('STEP: ' + step);
		System.debug('METHOD: ' + method);
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		//giovanni spinelli - 16/01/2019 - execute methods to overWrite next button of each step
		try{
			switch on method 
			{
				when 'operationalData' 
				{
					System.debug('executeMethod operationalData');
					response = OB_FlowControlUtility.operationalData(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
					}
					when 'companyData' {
						System.debug('executeMethod companyData');
					response = OB_FlowControlUtility.companyData(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
					}
					when 'actualOwner' {
						System.debug('executeMethod actualOwner');
					response = OB_FlowControlUtility.actualOwner(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
					}
					when 'servicePoint' {
						System.debug('executeMethod servicePoint');
						response = OB_FlowControlUtility.servicePoint(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
					}
				when 'downloadDocument'{
					System.debug('executeMethod downloadDocument');
				 	response = OB_FlowControlUtility.downloadDocument(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
					}
					//giovanni spinelli - 16/01/2019 - execute methods to overWrite previous button of each step
					when 'companyDataPrevious' {
					response = OB_FlowControlUtility.companyDataPrevious(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
				}
				when 'servicePointPrevious'{
					response = OB_FlowControlUtility.servicePointPrevious(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
				}
				when 'riepilogoPrevious'{
					response = OB_FlowControlUtility.riepilogoPrevious(step, data, stepsDefinition, targetObjectKey, method,dynamicWizardWrapper);
				}
				when 'saveDraft'
				{
					System.debug('Into SaveDraft');
					String stringWizard = bit2flow.B2FUtils.serializeWrapper(dynamicWizardWrapper);
					System.debug('Test WizardWrapper String: '+stringWizard);
					String resp = OB_FlowControlUtility.saveDraft(step, data, stepsDefinition, dynamicWizardWrapper,stringWizard);
					response.description = resp;
				}
				when else 
				{
				 //...under all other circumstances
				 response.result = '666'; //errore
				 response.description = 'something has not validated properly in executeMethod';
				 response.dynamicWizardWrapper = dynamicWizardWrapper; 
					}
			}
		}
		catch(Exception ecc)
		{
			System.debug('Generic executeMethod: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}



		
		return response;
	}
		
		
		global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper)
		{
			bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
			try {
			System.debug('Init Method');
			System.debug('DATA IN INIT: ' + JSON.serialize(data));
			System.debug('WIZARD WRAPPER IN INIT: ' + dynamicWizardWrapper);

			//String orderString = JSON.serialize(data.get('OrderHeader_temp'));
			//System.debug(' orderString string :' + orderString);
			//NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderString, NE__Order_Header__c.class);

			String configurationInitString = JSON.serialize(data.get('Configuration'));
			NE__Order__c initConfiguration = (NE__Order__c)JSON.deserialize(configurationInitString, NE__Order__c.class);

			//	Daniele Gandini <daniele.gandini@accenture.com>	- 15/05/2019 - TerminalsReplacement - retrieve TerminalsIdChanged list to add on ObjectDatamap - START
			List<String> terminalIdFromRemovedPOS = retrieveTerminalIdFromRemovedPOS(initConfiguration.Id);
			if(terminalIdFromRemovedPOS != null && !(terminalIdFromRemovedPOS.isEmpty())){
				data.put('TerminalIdsChanged', terminalIdFromRemovedPOS);
			}
			Boolean isReplacement = checkIfReplacementCase(initConfiguration.Id);
			if(isReplacement == true){
				data.put('isReplacement', isReplacement);
			}
			//	Daniele Gandini <daniele.gandini@accenture.com>	- 15/05/2019 - TerminalsReplacement - retrieve TerminalsIdChanged list to add on ObjectDatamap - END

			System.debug('INIT ID CONFIGURATION: ' + initConfiguration.Id);
			Map<String,String> idMap = OB_Maintenance_Flow_Override.getLookupsFromConfigurations(initConfiguration.Id);
			// Map<String,String> idMap = OB_Maintenance_Flow_Override.getLookupsFromConfigurations('a0y9E000004jzIbQAI');
			
			System.debug('ID MAP IN INIT METHOD: ' + idMap);
			
			NE__Order_Header__c orderHeader = OB_Maintenance_Flow_Override.createOrderHeaderNode( idMap.get('NE__Order_Header__c'));
			NE__Service_Point__c servicePoint = OB_Maintenance_Flow_Override.createServicePointNode( idMap.get('OB_Service_Point__c'));
			List<String> lookupSPContact = new List<String>();
			if(servicePoint != null) {
				System.debug('servicePoint != null');
				//NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Start
				String administrativeResp = getContactId ( servicePoint.Id, rtResponsabileAmministrativo );
				String respSP = getContactId ( servicePoint.Id, rtReferentePuntoVendita );
				String techincalRef = getContactId ( servicePoint.Id, rtReferenteTecnico );
                //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Stop
				System.debug('administrativeResp: ' + administrativeResp + ' respSP: ' + respSP + ' techincalRef: ' +techincalRef);
				if(!String.isBlank(administrativeResp)) {
					lookupSPContact.add(administrativeResp);
				}
				if(!String.isBlank(respSP)) {
					lookupSPContact.add(respSP);
				}
				if(!String.isBlank(techincalRef)) {
					lookupSPContact.add(techincalRef);
				}
			}
			System.debug('lookupSPContact != null' + lookupSPContact);
			
					data.put('pv'               , servicePoint);
					Account merchant = OB_Maintenance_Flow_Override.createMerchantNode( idMap.get('NE__AccountId__c') );
					data.put('merchant'         , merchant );
					//SET SOME VALUES OF UNBIND
					//SET THE VALUE OF MERCHANT NAME ON UNBIND "DenominazioneSociale"
					// <daniele.gandini@accenture.com> - 21/06/2019 - error toast in upload document page fix - start
					bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'isCompanyDataModified'		, 'false');
					// <daniele.gandini@accenture.com> - 21/06/2019 - error toast in upload document page fix - end
					bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'DenominazioneSociale'		, merchant.Name);
					bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'VAT_notPresent'				, (String.valueOf(merchant.OB_VAT_Not_Present__c)));
					bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'InsegnaPv'					, servicePoint.Name);
					//elena.preteni 19/5/2019 sostituzione
					// bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'isReplacement'					, 'isReplacement');
					//elena.preteni 19/5/2019 sostituzione
					System.debug('YEARS OF CONSTITUTION NUMBER: ' +String.valueOf(merchant.OB_Year_constitution_company__c) );
					//giovanni spinelli 11/02/2019 set unbind with value or with null to avoid crash with get method
					if(!String.isBlank(String.valueOf(merchant.OB_Year_constitution_company__c))){
						System.debug('before 1 if ' + JSON.serialize(merchant));
						bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'yearOfConstitutionCompany'	, (String.valueOf(merchant.OB_Year_constitution_company__c)));
						System.debug('after 1 if ' + JSON.serialize(merchant));
					}else{
						System.debug('before 2 if ' + JSON.serialize(merchant));
						bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'yearOfConstitutionCompany'	, null);
						System.debug('after 2 if ' + JSON.serialize(merchant));
					}
					
					//String unbindString =JSON.serialize(data.get('unbind'));
					//NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(unbindString, NE__Order_Header__c.class);


					data.put('OrderHeader'      , orderHeader );
					data.put('prelimVerifCodeRO' , true);//SET TRUE THIS ATTRIBUTE TO HAVE THE DEFAULT READ ONLY IN OPERATIONAL DATA
					
					// GET MERCHANT ID FOR EXTERNAL SOURCE MAPPING
					//String merchantId = merchant.Id;
					//List<ExternalSourceMapping__c> externalSourceMapping = new OB_Maintenance_Flow_Override.createExternalSourceNode();
					
		/*-----------------------------------------------------------CONFIGURATION NODE-----------------------------------------------------------*/	        
					NE__Order__c configuration = OB_Maintenance_Flow_Override.createConfigurationNode( idMap.get('configId') );
					configuration.NE__Parameters__c = 'lightningFromVF='+OB_UtilityCallingServices.isCommunityUser()+';ordId='+configuration.Id; 
					System.debug('CONFIGURATION_AFTER_QUERY: ' + configuration);
					data.put('Configuration'    , configuration );
					//CREATE ORDER ITEM NODE-->IN SETUP FLOW THIS NODE DOESN'T EXIST
					Map<String , List<NE__OrderItem__c>> oderItem = OB_Maintenance_Flow_Override.createOrderItemNode(idMap.get('configId'));
					data.put('orderItem'    , oderItem );
				 	// 07/03/19 francesca.ribezzi: adding check on order items action:
				//	Boolean goToFinalStep = OB_Maintenance_Flow_Override.getChangedAddOrderItems(configuration.Id);
					//if goToFinalStep -> redirect to final step
				//	bit2flow.B2FUtils.setJSONValue(data, 'unbind', 'goToFinalStep', String.valueof(goToFinalStep));
					//francesca.ribezzi end check

					String proposerABI = String.valueOf(orderHeader.OB_ProposerABI__c) ;
					List<Contact> contactsNodeList = OB_Maintenance_Flow_Override.createContactsNodes( idMap.get('NE__AccountId__c')  , proposerABI);
					System.debug('contactsNodeList: ' + contactsNodeList);
					List<Contact> contactTitolariEffettivi = new List<Contact>();
		/*-----------------------------------------------------------CONTACTS TITOLARE NODE-----------------------------------------------------------*/
			if(contactsNodeList!=null)
			{

				 
						for(Contact cnt : contactsNodeList){
					if(cnt.recordtypeid == OB_Maintenance_Flow_Override.rtDatiSocietaLegale){
						 data.put('sede_legale' , cnt);
							}
							if(cnt.recordtypeid == OB_Maintenance_Flow_Override.rtEsecutore){
								data.put( 'legale_rappresentante' , cnt);
							}
							if(cnt.recordtypeid == OB_Maintenance_Flow_Override.rtTitolareEffettivo){
								System.debug('INTO IF TITOLARE EFFETTIVO');
								contactTitolariEffettivi.add(cnt);
								System.debug('cnt titolari effettivi: ' + contactTitolariEffettivi);
								for(Integer i=0; i<contactTitolariEffettivi.size(); i++){
									System.debug('INTO_FOR_GET(i): '+contactTitolariEffettivi.get(i));
									data.put('contact'+(i+1) , contactTitolariEffettivi.get(i) );
									System.debug('DATA_AFTER_PUT_CONTACT: ' + JSON.serialize(data));
								}
							}
						}
				}
					List<Contact> contactsSPList = new List<Contact>();
					if(!lookupSPContact.isEmpty()){
							contactsSPList =  OB_Maintenance_Flow_Override.createContactsSPNode( idMap.get('NE__AccountId__c'), proposerABI, lookupSPContact);
					}
				 
				 /*-----------------------------------------------------------CONTACTS SERVICE POINT NODE-----------------------------------------------------------*/	
					System.debug('@@@contactsSPList are : ' + contactsSPList);
					if(contactsSPList != null) {
						for(Contact contSP : contactsSPList){
					//---------------------------------------------------REFERENTE PUNTO VENDITA NODE-----------------------------------------------------------//
							if(contSP.recordtypeid == OB_Maintenance_Flow_Override.rtReferentePuntoVendita){
						data.put('Responsabile_PV' , contSP);
							}
							//---------------------------------------------------REFERENTE TECNICO NODE-----------------------------------------------------------//
							if(contSP.recordtypeid == OB_Maintenance_Flow_Override.rtReferenteTecnico) {
								data.put('Referente_TecnicoPV' , contSP);
							}
							//---------------------------------------------------RESPONSABILE AMMINSITRATIVO NODE-----------------------------------------------------------//
							if(contSP.recordtypeid == OB_Maintenance_Flow_Override.rtResponsabileAmministrativo) {
								data.put('Responsabile_Amm_PV' , contSP);
							}
						}
					}
		/*-----------------------------------------------------------BANK PROFILE NODE-----------------------------------------------------------*/	 
					OB_Bank_Profile__c bankProf = OB_Maintenance_Flow_Override.createBankProfileNode(proposerABI);
					data.put('bankProfile' , bankProf);
					
					String billingPOS = (String) 		configuration.NE__BillingProfId__c; 
					String billingAcquiring = (String) configuration.OB_BankAccount_Acquiring__c; 
					System.debug('billingPOS is: ' + billingPOS);
			System.debug('billingAcquiring is: ' + billingAcquiring);
			List<String> billingProfLookups = new List<String>();
			
			if(!String.isBlank(billingPOS)){
				billingProfLookups.add(billingPOS);
			}
			if(!String.isBlank(billingAcquiring)) {
				billingProfLookups.add(billingAcquiring);
			}
			
			List<NE__Billing_Profile__c> billingProfile = OB_Maintenance_Flow_Override.createBillingProfileNode(billingProfLookups);
					
					for(NE__Billing_Profile__c billProf : billingProfile){
						if(billProf.Id == (Id) billingPOS) {
							data.put('BillingProfilePOS' , billProf);
						}
						if(billProf.Id == (Id) billingAcquiring) {
							data.put('BillingProfileAcquiring' , billProf);
						}
					}
					
				 
					//CREATE BANK NODE
					Account bank = new Account();
					bank.recordTypeId = rtBank;
					bank.OB_ABI__c = orderHeader.OB_ABI__c;
					data.put('bank', bank);
					//CREATE ACTUAL BANK
					data.put('actualBank' , orderHeader.OB_ProposerABI__c);
					//CREATE ORDER NODE --> only with mcc --> for upload documents
					NE__Order__c orderTOMCC = new NE__Order__c();
					System.debug('MCC_L2: ' + configuration.OB_MCCL2__c);
					orderTOMCC.OB_MCC__c = configuration.OB_MCCL2__c;
					data.put('order' , orderTOMCC);
					//SET USER NODE
					bit2flow.B2FUtils.setJSONValue(data, 'user', 'OB_CAB__c'				, configuration.OB_CAB__c);
					//String userString = JSON.serialize(data.get('user'));
					//Object userToObjectDataMap = (Object)JSON.deserialize(userString, Object.class);
					//userToObjectDataMap.OB_ABI__c=orderHeader.OB_ABI__c;
					//userToObjectDataMap.OB__CAB__c=orderHeader.OB__CAB__c;
					//data.put('User' , userToObjectDataMap);
					
					System.debug('CONTACT LIST: ' + JSON.serialize(contactsNodeList));
					System.debug('OBJECT_DATA_MAP_FINAL: ' + JSON.serialize(data));
					response.result 				= 	'000'; //bit2flow.DynamicWizardStepWrapper.OKCODE;
					response.description 			= 	'OK';
					response.data					=	data;
					response.dynamicWizardWrapper 	= 	dynamicWizardWrapper;
		 		
	
		 		// insert method to create object data map
	
			System.debug('@@response is: ' + response);
			} catch (Exception ecc) {
				System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}
				return response;
		}

	global bit2flow.DynamicWizardStepWrapper save(String step, map<String, Object> data, String targetObjectKey,List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		try
		{
			System.debug('SAVE METHOD');
			System.debug('DATA OBJECT: ' + JSON.serialize(data));
			String orderHeaderString =JSON.serialize(data.get('OrderHeader'));
			//elena.preteni  28/06/2019 added field to logic descoping consistenza
			System.debug(' orderHeaderString string :' + orderHeaderString);
			
			NE__Order_Header__c orderHeader 	= (NE__Order_Header__c)JSON.deserialize(orderHeaderString, NE__Order_Header__c.class);
			//START francesca.ribezzi 13/09/19 - R1F3-48 - setting OB_ExitFlow to true
			orderHeader.OB_ExitFlow__c = true;
			//END francesca.ribezzi 13/09/19 - R1F3-48
			String ContactString 				= JSON.serialize(data.get('legale_rappresentante'));
			
			// Contact esecutore				= (Contact)JSON.deserialize(ContactString, Contact.class);
			// String esecFiscalCode 			= esecutore.OB_Fiscal_Code__c;
			//NE__Order_Header__c orderHeaderValue = (NE__Order_Header__c)JSON.deserialize(orderHeaderStringValue, NE__Order_Header__c.class);
			
			String bankProfileString 			= JSON.serialize(data.get('bankProfile'));
			OB_Bank_Profile__c bankProfileValue = (OB_Bank_Profile__c)JSON.deserialize(bankProfileString, OB_Bank_Profile__c.class);

			String configurationString 			=JSON.serialize(data.get('Configuration'));
			NE__Order__c configurationValue 	= (NE__Order__c)JSON.deserialize(configurationString, NE__Order__c.class);

			System.debug('OB_Maintenance_Flow_Override.save() : bankProfileValue 	: ' + bankProfileValue);
			System.debug('OB_Maintenance_Flow_Override.save() : configurationValue 	: ' + configurationValue.Id);
			
			String configurationId 				= configurationValue.Id;

			//GET CONFIGURATION FROM DATAMAP
			// String configurationString = JSON.serialize(data.get('Configuration'));
			// NE__Order__c configuration 			= (NE__Order__c)JSON.deserialize(configurationString, NE__Order__c.class);
			// GET ORDER HEADER FROM DATA MAP
			// String orderHeaderString = JSON.serialize(data.get('OrderHeader'));
			
			String merchantString 				= JSON.serialize(data.get('merchant')); 
			Account merchant 					= (Account)JSON.deserialize(merchantString, Account.class);
			Id servicePointID 					= (Id) (bit2flow.B2FUtils.getJSONValue(data, 'pv', 'Id'));
			NE__Order_Header__c oderHeader		= (NE__Order_Header__c)JSON.deserialize(orderHeaderString, NE__Order_Header__c.class);

		 	System.debug('merchant: ' + merchant);
		 	System.debug('servicePointID: ' + servicePointID);
		 	System.debug('configuration: ' + configurationValue);
		 	System.debug('oderHeader: ' + orderHeader);

			//michele.lubrano@accenture.com 07/05/2019 - implementation of method for creating log requests OB_Utility.insertLogRequest(Map<String,String>) START
			// START elena.preteni descoping consistenza
			List<NE__Service_Point__c> sp = [SELECT id,
													OB_Typology__c 
											FROM NE__Service_Point__c 
											WHERE id = :servicePointID ];
			// END elena.preteni descoping consistenza
			Map<String,String> sourceMap 		= new Map<String,String>();

		 	sourceMap.put('OB_AccountId__c',merchant.Id);
		 	sourceMap.put('OB_ServicePointId__c',servicePointID);
		 	sourceMap.put('OB_OrderId__c',configurationValue.Id);
		 	sourceMap.put('OB_ABI__c',orderHeader.OB_ABI__c);
		 	sourceMap.put('OB_CAB__c',orderHeader.OB_CAB__c);
		 	sourceMap.put('OB_MaintenanceType__c',(sp != null && sp.get(0).OB_Typology__c == 'Virtuale') ? OB_UtilityConstants.CONSISTENZA_ECOMMERCE  : OB_UtilityConstants.CONSISTENZA);
			
			//START francesca.ribezzi 01/07/19 - F2WAVE2-53
			Boolean flagSIA 					= getIsSIAtoApprove(configurationId);
			system.debug( 'flagSIA? ' + flagSIA);
			
			String flagSIAStringified 			= parseBoolean(flagSIA);
			system.debug( 'flagSIAStringified? ' + flagSIAStringified);

			sourceMap.put('OB_SIAToBeApproved__c',flagSIAStringified); 
			
			/*if(flagSIA){	
				sourceMap.put('OB_Status__c',OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA);
				system.debug( 'sourceMap.get(OB_Status__c)? ' + sourceMap.get('OB_Status__c'));
			}else{
					system.debug( 'sourceMap.get(OB_Status__c)? ' + sourceMap.get('OB_Status__c'));
			
			}*/
			//END francesca.ribezzi 01/07/19 - F2WAVE2-53
			sourceMap.put('OB_Status__c',OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT);
		 	sourceMap.put('RecordTypeId',rtConsistenza);
			 //START---- Simone.Misani  F2wave-2-34 26/06/2019
			String hasPos 					= JSON.serialize(data.get('hasPos')); 
			String hasAcquiring 			= JSON.serialize(data.get('hasAcquiring')); 
			String hasVas 					= JSON.serialize(data.get('hasVas'));			
			
			sourceMap.put('OB_HasAcquiring__c',hasAcquiring );
			sourceMap.put('OB_HasPos__c',hasPos);
			sourceMap.put('OB_HasVas__c',hasVas);			
			 //END---- Simone.Misani  F2wave-2-34 26/06/2019
			sourceMap.put('OB_RequestDate__c',String.valueOf(Date.today()));
			//START - elena.preteni  28/06/2019 added field to logic descoping consistenza
			
			//enrico.purificato WN-185 - PLEASE DO NOT DELETE COMMENTED LINE AFTER

			// List<NE__OrderItem__c> oiListToUpdate = new List<NE__OrderItem__c>();
			
			// List<NE__OrderItem__c> oiListVMToUpdate = new List<NE__OrderItem__c>();//Simone Misani 23/07/2019 fix track
			// List<NE__OrderItem__c> oiList = [SELECT id,
			// 										NE__ProdId__c,
			// 										NE__ProdId__r.OB_Acquirer__c,
			// 										NE__ProdId__r.RecordType.DeveloperName,
			// 										NE__ProdId__r.OB_Codice_sfdc__c, 
			// 										NE__Root_Order_Item__c,  
			// 										NE__OrderId__c,
			// 										OB_isNotIntegrated__c,
			// 										OB_Enablement__c,  
			// 										NE__Action__c,
			// 										NE__ProdId__r.Name,//Simone Misani 24/04/2019 WN-193
			// 										NE__Service_Point__r.OB_Typology__c,
			// 										OB_Old_Enablement__c,
			// 										NE__Parent_Order_Item__c //enrico.purificato WN-185
			// 								   FROM NE__OrderItem__c 
			// 								   WHERE NE__OrderId__c = :configurationValue.Id];

			// List<NE__Order__c> oList = [SELECT id, NE__Configuration_Type__c,OB_ApprovalStatus__c //Simone Misani 22/07/2019 fix Tracking
			// 								   FROM NE__Order__c 
			// 								   WHERE id = :configurationValue.Id LIMIT 1];
			// Boolean isTerminaOfferta = oList.get(0).NE__Configuration_Type__c =='Disconnect';
			// String  appovalBio = oList.get(0).OB_ApprovalStatus__c; //Simone Misani 22/07/2019 fix Tracking
			
			// Boolean isEcommerce = !oiList.isEmpty() ?  oiList.get(0).NE__Service_Point__r.OB_Typology__c=='Virtuale' : false;
			// Boolean isNotIntegrated = false;
			// String logRequestStatus = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
			// //START--Simone Misani Fix Tracking 20/07/2019
			// Boolean isIntegrate = false;
			// Boolean mixMaint = false;
			// Boolean isVisaMaster = false;
			// Boolean isVisaMasterRemoved= false;//Simone Misani 23/07/2019 fix track
			// Boolean removeAcquiringNexi = false;
			// //END--Simone Misani Fix Tracking 20/07/2019
			// sourceMap.put('OB_MaintenanceType__c',isEcommerce ? OB_UtilityConstants.CONSISTENZA_ECOMMERCE  : OB_UtilityConstants.CONSISTENZA);
			// for(NE__OrderItem__c oiCurrent : oiList){//oiCurrent.NE__Root_Order_Item__c == null
				
			// 	/* ANDREA MORITTU START - 26-Jul-2019 - F2WAVE2-163 */
			// 	if(!isEcommerce && !isTerminaOfferta ) {

			// 		if((oiCurrent.NE__ProdId__r.OB_Acquirer__c=='NEXI' && oiCurrent.NE__ProdId__r.RecordType.DeveloperName=='Acquiring')||oiCurrent.NE__ProdId__r.RecordType.DeveloperName =='Pricing' &&   oiCurrent.NE__Action__c == 'Remove'){
			// 			oiCurrent.OB_isNotIntegrated__c = true;
			// 				//Simone Misani 22/07/2019 fix Tracking		
			// 			oiListToUpdate.add(oiCurrent);
			// 			if(oiCurrent.NE__ProdId__r.Name == 'Visa/Mastercard'){//Simone Misani 23/07/2019 Fix Tracking
			// 				isVisaMasterRemoved= true;
			// 			}

			// 		}else{
			// 			isIntegrate= true;//Simone Misani 22/07/2019 fix Tracking
			// 		}
			// 		//START ---Simone Misani 23/07/2019 Fix Tracking
			// 		if(oiCurrent.NE__ProdId__r.RecordType.DeveloperName == 'Commissione'&& (oiCurrent.NE__Action__c == 'Remove' || oiCurrent.NE__Action__c == 'Add')){
			// 			if(oiCurrent.NE__Action__c == 'Remove'){
			// 				oiCurrent.OB_isNotIntegrated__c = true;
			// 				isNotIntegrated = true;
			// 			}else
			// 			{
			// 				oiCurrent.OB_isNotIntegrated__c = false;
			// 				isIntegrate= true;
			// 			}
			// 			oiListVMToUpdate.add(oiCurrent);
			// 		}//END ---Simone Misani 23/07/2019 Fix Tracking
			// 		if(isVisaMasterRemoved &&  oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c	== 'PCI'){
			// 			oiCurrent.OB_isNotIntegrated__c = true;
			// 			oiListVMToUpdate.add(oiCurrent);
			// 			logRequestStatus = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;//--- ---Simone Misani 23/07/2019 Fix Tracking
			// 		}
			// 		system.debug('oiCurrent.NE__ProdId__r.OB_Acquirer__c'+oiCurrent.NE__ProdId__r.OB_Acquirer__c);
			// 		system.debug('oiCurrent.NE__ProdId__r.RecordType.DeveloperName'+oiCurrent.NE__ProdId__r.RecordType.DeveloperName);
			// 		system.debug('oiCurrent.NE__Root_Order_Item__c'+oiCurrent.NE__Root_Order_Item__c);
			// 		system.debug('oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c'+oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c);
			// 		system.debug('oiCurrent.OB_Old_Enablement__c'+oiCurrent.OB_Old_Enablement__c);
			// 		system.debug('oiCurrent.OB_Enablement__c'+oiCurrent.OB_Enablement__c);
			// 		if(oiCurrent.NE__ProdId__r.OB_Acquirer__c=='NEXI' && oiCurrent.NE__ProdId__r.RecordType.DeveloperName=='Acquiring' && oiCurrent.NE__Root_Order_Item__c != null && 
			// 			(oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == 'JCB' || oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == 'UPI')){
			// 			oiCurrent.OB_isNotIntegrated__c = true;
			// 			removeAcquiringNexi= true;
			// 			isNotIntegrated= true;//Simone Misani 22/07/2019 fix Tracking
			// 			oiListToUpdate.add(oiCurrent);
			// 		}

					
			// 		//STARt---Simone Misani 22/07/2019 fix Tracking
			// 		else{
			// 			isIntegrate= true;
			// 		}
			// 		//START ---Simone Misani 23/07/2019 Fix Tracking
			// 		if(oiCurrent.NE__ProdId__r.RecordType.DeveloperName == 'Commissione'&& (oiCurrent.NE__Action__c == 'Remove' || oiCurrent.NE__Action__c == 'Add')){
			// 			if(oiCurrent.NE__Action__c == 'Remove'){
			// 				oiCurrent.OB_isNotIntegrated__c = true;
			// 				isNotIntegrated = true;
			// 			}else
			// 			{
			// 				oiCurrent.OB_isNotIntegrated__c = false;
			// 				isIntegrate= true;
			// 			}
			// 		}
			// 		if(oiCurrent.NE__ProdId__r.Name == 'Visa/Mastercard' && oiCurrent.NE__Action__c != 'Remove'){//END ---Simone Misani 23/07/2019 Fix Tracking
						
			// 				isVisaMaster= true;
						
			// 			}
			// 		if(isVisaMaster &&oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == 'PCI' && oiCurrent.NE__Action__c == 'Add' ){
			// 			oiCurrent.OB_isNotIntegrated__c = false;
			// 			isNotIntegrated= false;//Simone Misani 22/07/2019 fix Tracking
			// 			oiListVMToUpdate.add(oiCurrent);//START--Simone Misani Fix Tracking 20/07/2019
			// 		}
			// 	} else {
			// 		if(isEcommerce) {
			// 			oiCurrent.OB_isNotIntegrated__c = true;
			// 			isNotIntegrated = true;
			// 			oiListToUpdate.add(oiCurrent);
			// 		} else {
			// 			isIntegrate = true;
			// 		}
			// 		if(isTerminaOfferta) {
			// 			oiCurrent.OB_isNotIntegrated__c = true;
			// 			isNotIntegrated = true;
			// 			oiListToUpdate.add(oiCurrent);
			// 		} else {
			// 			isIntegrate = true;
			// 		}
			// 	}
			// 	/* ANDREA MORITTU START - 26-Jul-2019 - F2WAVE2-163 */
			// }
			// List<NE__OrderItem__c> oiListfatherupdate = new List<NE__OrderItem__c>();//START--Simone Misani Fix Tracking 20/07/2019
			// 	List<NE__OrderItem__c> oiListfather = [SELECT id,
			// 										NE__ProdId__c,
			// 										NE__Root_Order_Item__c,  
			// 										NE__OrderId__c,
			// 										OB_isNotIntegrated__c,
			// 										OB_Enablement__c,  
			// 										NE__Action__c,
			// 										NE__Service_Point__r.OB_Typology__c,
			// 										OB_Old_Enablement__c
			// 								   FROM NE__OrderItem__c 
			// 								   WHERE NE__OrderId__c = :configurationValue.Id
			// 								   AND NE__ProdId__r.RecordType.DeveloperName ='Terminali'
			// 								   AND NE__Root_Order_Item__c= null];
			// 	for(NE__OrderItem__c oif : oiListfather){
			// 		for(NE__OrderItem__c oiCurrent : oiList){
			// 			if(oiCurrent.NE__Root_Order_Item__c == oif.id && oiCurrent.NE__ProdId__r.RecordType.DeveloperName=='Acquiring' && (oiCurrent.NE__Action__c =='Remove' || oiCurrent.NE__Action__c =='Add')){
			// 				if(oiCurrent.NE__Action__c =='Add'){
			// 					oiCurrent.OB_isNotIntegrated__c = oif.OB_isNotIntegrated__c;
								
			// 				}else if(oiCurrent.NE__Action__c =='Remove' && removeAcquiringNexi){
			// 					oiCurrent.OB_isNotIntegrated__c = true;
			// 					oiListToUpdate.add(oiCurrent);
			// 				}
			// 				oiListfatherupdate.add(oiCurrent);////--Simone Misani Fix Tracking 20/07/2019
			// 			}
			// 		}
			// 	}
			// 	//START--Simone Misani Fix Tracking 20/07/2019
			// 	update oiListfatherupdate;
			// 	if(!isNotIntegrated){
					
			// 	//START--Simone Misani Fix Tracking 20/07/2019
			
			// 		isIntegrate=true;
			// 	}//END--Simone Misani Fix Tracking 20/07/2019
			
			// sourceMap.put('OB_isNotIntegrated__c',String.valueOf(isNotIntegrated));
			// if(isTerminaOfferta){
			// 	sourceMap.put('OB_isNotIntegrated__c','true');
			// }
			// if(isNotIntegrated && appovalBio != OB_UtilityConstants.ORDER_APPROVALSTATUS_INAPPROVBIO){
			// 	logRequestStatus = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
			// }
			// //NEXI-254 Zuzanna Urban <z.urban@accenture.com> 06/08/2019 - Start, add set to not have duplicates
            // Set<NE__OrderItem__c> orderItemSet = new Set<NE__OrderItem__c>( );
            // List<NE__OrderItem__c> orderItemFinalUpdate = new List<NE__OrderItem__c>( );
            // orderItemSet.addAll( oiListToUpdate );
            // orderItemFinalUpdate.addAll( orderItemSet );

			// update orderItemFinalUpdate;
			// //NEXI-254 Zuzanna Urban <z.urban@accenture.com> 06/08/2019 - Stop, add set to not have duplicates
			// update oiListVMToUpdate;
			// //END--Simone Misani 22/07/2019 fix Tracking
			// //START--Simone Misani Fix Tracking 20/07/2019
			// for(NE__OrderItem__c oi: oiList){
			// 	if(oi.NE__Action__c !='None')
			// 		if(!isNotIntegrated){
			// 			isIntegrate= true;	
			// 		}
			// }
			// System.debug('isIntegrate: '+isIntegrate);
			// System.debug('isNotIntegrated: '+isNotIntegrated);
			// if(isIntegrate && isNotIntegrated){
			// 	if( appovalBio != OB_UtilityConstants.ORDER_APPROVALSTATUS_INAPPROVBIO){
			// 		logRequestStatus = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;	
			// 	}	
			// 	sourceMap.put('OB_Mixed_Maintenance__c','true');
			// }else{
			// 	sourceMap.put('OB_Mixed_Maintenance__c','false');
			// }
			// //END--Simone Misani Fix Tracking 20/07/2019
						
			// sourceMap.put('OB_Status__c',logRequestStatus);			
            // //END - elena.preteni  28/06/2019 added field to logic descoping consistenza
		 	// OB_LogRequest__c logRequest = OB_Utility.insertLogRequest(sourceMap);			
			// updateOrderItemActionNone(orderHeader.Id);//--Simone Misani Fix Tracking 20/07/2019			
		 	// System.debug('LOG REQUEST IN SAVE: ' + logRequest.Id);
			// //michele.lubrano@accenture.com 07/05/2019 END
			// data.put('logRequest',logRequest);

			//enrico.purificato WN-185 END - PLEASE DO NOT DELETE COMMENT BELOWE

			//enrico.purificato WN-185 START - REFACTORED CODE
			Map<Id,NE__OrderItem__c> oiListToUpdate = new Map<Id,NE__OrderItem__c>();


			List<NE__OrderItem__c> oiList = [SELECT id,
												NE__OrderId__r.NE__Configuration_Type__c,
												NE__OrderId__r.OB_ApprovalStatus__c,
												NE__OrderId__r.OB_ApprovalType__c,
												NE__ProdId__c,
												NE__ProdId__r.OB_Acquirer__c,
												NE__ProdId__r.RecordType.DeveloperName,
												NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
												NE__ProdId__r.OB_Codice_sfdc__c, 
												NE__Root_Order_Item__c,
												NE__OrderId__c,
												OB_isNotIntegrated__c,
												OB_Enablement__c,
												NE__OrderId__r.OB_MCC__c,  
												NE__Action__c,
												NE__ProdId__r.Name,
												NE__Service_Point__r.OB_Typology__c,
												OB_Old_Enablement__c,
												NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c,
												NE__OrderId__r.OB_AdditionalDocumentationRequired__c,//Simone Misani  WN-384  11/09/2019
												NE__OrderId__r.NE__Order_Header__c,//Simone Misani  WN-384   11/09/2019
												NE__Parent_Order_Item__c //enrico.purificato WN-185
										FROM NE__OrderItem__c 
										WHERE NE__OrderId__c = :configurationValue.Id];
										

			Boolean isTerminaOfferta 	= oiList.get(0).NE__OrderId__r.NE__Configuration_Type__c =='Disconnect';
			String  appovalBio 			= oiList.get(0).NE__OrderId__r.OB_ApprovalStatus__c; 
			Boolean addDoc 				= oiList.get(0).NE__OrderId__r.OB_AdditionalDocumentationRequired__c;//Simone Misani  WN-384  11/09/2019
			String 	orderHeaderId					= oiList.get(0).NE__OrderId__r.NE__Order_Header__c;//Simone Misani  WN-384  11/09/2019
			String boo= oiList.get(0).NE__OrderId__r.OB_ApprovalType__c;

			Boolean isEcommerce 		= !oiList.isEmpty() ?  oiList.get(0).NE__Service_Point__r.OB_Typology__c=='Virtuale' : false;

			sourceMap.put('OB_MaintenanceType__c',isEcommerce ? OB_UtilityConstants.CONSISTENZA_ECOMMERCE  : OB_UtilityConstants.CONSISTENZA);

			Boolean isNotIntegrated 	= false;
			Boolean isIntegrate 		= true;
			Boolean mixMaint 			= false;

			String logRequestStatus 	= OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
						
			Map<Id,Boolean> isNotIntegratedMap 	= new Map<Id,Boolean>();
			Id idVisa 							= null;
			NE__OrderItem__c PCI;
			NE__OrderItem__c Commisione ;
			//start antonio.vatrano 03/09/2019 wn-544
			Boolean hasVM = false;
			Boolean hasUnattended = false;
			Id checkVMadd;
			//End antonio.vatrano 03/09/2019 wn-544

													
			for(NE__OrderItem__c oiCurrent : oiList){
				
				if(!isEcommerce && !isTerminaOfferta ){
					//start antonio.vatrano 03/09/2019 wn-544
					if(oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == OB_UtilityConstants.VISAMASTERCARD && oiCurrent.NE__Action__c== 'Add'){
						hasVM = true;
						checkVMadd = oiCurrent.id;
					}
					if(oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == OB_UtilityConstants.POS_TERZI_UNATTENDED && oiCurrent.NE__Action__c != 'Remove'){
						hasUnattended = true;
					}
					//End antonio.vatrano 03/09/2019 wn-544
					//if an aquring nexi is DISCONNECTED maintenace is not integrated
					if((oiCurrent.NE__ProdId__r.OB_Acquirer__c=='NEXI' && oiCurrent.NE__ProdId__r.RecordType.DeveloperName=='Acquiring') &&  oiCurrent.NE__Action__c == 'Remove' && oiCurrent.NE__Parent_Order_Item__c == null){
						oiCurrent.OB_isNotIntegrated__c = true;
						isNotIntegrated = true;			
						isNotIntegratedMap.put(oiCurrent.Id,true);
						//isNotIntegratedMap.put(oiCurrent.NE__ProdId__c,true);//Simone Misani  WN-384  11/09/2019
						
						// Track VISAMASTERCARD Id
						if(oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == 'VISAMASTERCARD')
						{
							idVisa = oiCurrent.Id;
						}
						oiListToUpdate.put(oiCurrent.Id,oiCurrent);
					}
					
					//if an aquring nexi is DISABLED maintenace is not integrated
					//Simone Misani  WN-384 Start 11/09/2019
					//Start antonio.vatrano  WN-519  28/09/2019
					if( oiCurrent.NE__ProdId__r.OB_Acquirer__c=='NEXI' && 
					oiCurrent.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.POS_RT && 
					oiCurrent.NE__ProdId__r.RecordType.DeveloperName != OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS && 
					(oiCurrent.OB_Old_Enablement__c =='Y' && oiCurrent.OB_Enablement__c =='N') && 
					oiCurrent.NE__Action__c == 'Change'){
					//End antonio.vatrano  WN-519  28/09/2019
						oiCurrent.OB_isNotIntegrated__c = true;
						isNotIntegrated = true;			
						isNotIntegratedMap.put(oiCurrent.Id,true);
						oiListToUpdate.put(oiCurrent.Id,oiCurrent);
						//isNotIntegratedMap.put(oiCurrent.NE__ProdId__c,true);
					}
					//Simone Misani  WN-384 Start 11/09/2019
					//for untouched ITEM set the fulfilment status to Completed
					if(oiCurrent.NE__Action__c == 'None')
					{
						oiCurrent.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
						oiListToUpdate.put(oiCurrent.Id,oiCurrent);
					}
					//PCI and COMMISSIONE depends from VISAMASTERCARD they are checked later
					if(oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == 'PCI' && oiCurrent.NE__Parent_Order_Item__c == null){
						PCI = oiCurrent;
					}
					
					if(oiCurrent.NE__ProdId__r.RecordType.DeveloperName == 'Commissione' && oiCurrent.NE__Parent_Order_Item__c == null){
						Commisione = oiCurrent;
					}
				}
				else
				{
					//Simone Misani Termina Offerta WN-30/09/2019 START
					if(isTerminaOfferta){
						if(oiCurrent.NE__ProdId__r.RecordType.DeveloperName == 'Terminali' || oiCurrent.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Terminali'){
							oiCurrent.OB_isNotIntegrated__c = false;// Simone Misani WN-573
							isIntegrate 	= true;
							isNotIntegrated = false;
							oiListToUpdate.put(oiCurrent.Id,oiCurrent); // Simone Misani WN-573
						}else{
							oiCurrent.OB_isNotIntegrated__c = true;
							isNotIntegrated = true;
							isIntegrate 	= false;
							oiListToUpdate.put(oiCurrent.Id,oiCurrent);
						}
						System.enqueueJob(new OB_QueueableClass(orderHeaderId));
					}else{
					oiCurrent.OB_isNotIntegrated__c = true;
					isNotIntegrated = true;
					isIntegrate 	= false; // in case of Termination or E-Commerce ril always not Integrated it can not be mixed
					oiListToUpdate.put(oiCurrent.Id,oiCurrent); 
					}
					//Simone Misani Termina Offerta WN-30/09/2019 END

					
				}
			}
			//Start antonio.vatrano 03/09/2019 wn_544
			String mccOrder = oiList.get(0).NE__OrderId__r.OB_MCC__c;
			if(OB_EnrichOrder.PETROL == mccOrder && hasVM && hasUnattended){
				oiListToUpdate.put(checkVMadd, new NE__OrderItem__c (id = checkVMadd, OB_isNotIntegrated__c=true));
			}
			//End antonio.vatrano 03/09/2019 wn_544

			// if VISAMASTERCARD is not integrated also PCI and COMMISSIONE are not integrated
			if(idVisa != null && isNotIntegratedMap.containsKey(idVisa)){
				
				if(PCI != null)
				{
					isNotIntegratedMap.put(PCI.Id,true);
					PCI.OB_isNotIntegrated__c = true;
					oiListToUpdate.put(PCI.Id,PCI);
				}
				
				if(Commisione != null)
				{
					isNotIntegratedMap.put(Commisione.Id,true);
					Commisione.OB_isNotIntegrated__c = true;
					oiListToUpdate.put(Commisione.Id,Commisione);
				}
			}

			// if parent ITEM is not INTEGRATED also CHILD are not Integrated
			if(isNotIntegratedMap.keyset().size()>0){
				for(NE__OrderItem__c oiCurrent : oiList)
				{
					if(oiCurrent.NE__Action__c != 'None' && oiCurrent.NE__Parent_Order_Item__c !=null 
					&& isNotIntegratedMap.containsKey(oiCurrent.NE__Parent_Order_Item__c) && !oiListToUpdate.containskey(oiCurrent.Id)){
						oiCurrent.OB_isNotIntegrated__c = true;
						isNotIntegrated = true;
						oiListToUpdate.put(oiCurrent.Id,oiCurrent);
					}
				}
			}
			//START antonio.vatrano 20/08/2019 WN-248
            // List<NE__OrderItem__c> newOiListToUp = new List<NE__OrderItem__c>();
            // for(Id singleId : oiListToUpdate.keySet()){
            //     newOiListToUp.add(oiListToUpdate.get(singleId));
            // }
			//update newOiListToUp; 
			//Simone Misani  WN-384 Start 11/09/2019
			
			//Simone Misani  WN-384 End 11/09/2019
			
            //END antonio.vatrano 20/08/2019 WN-248

			sourceMap.put('OB_isNotIntegrated__c',String.valueOf(isNotIntegrated));

		//Simone Misani  WN-384-380-364 Stop 11/09/2019	
			Boolean confTech = OB_Maintenance_Consistenza_LogRequest_CC.compatibilityTechnicalConfigurator( configurationValue.Id );
			String proposerAbi                      = oiList.get(0).ne__orderId__r.NE__Order_Header__r.OB_ProposerABI__c;
			Id bankRt                               = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId();
			List<Account> listOfAccount = new List<Account>();
			listOfAccount = [   SELECT  Id,Name,
									(SELECT Id,OB_NeedBIO__c FROM Bank_Profiles1__r)
								FROM    Account
								WHERE   RecordTypeId =: bankRt
								AND     Id =: proposerAbi   
								LIMIT   1];
			if(!listOfAccount.isEmpty()){
			list<OB_Bank_Profile__c> listOfBankProfiles = listOfAccount.get(0).Bank_Profiles1__r;
				if(!listOfBankProfiles.isEmpty()){
					OB_Bank_Profile__c currentBankProfile = listOfBankProfiles.get(0);
			Boolean checkAcquiring = OB_Utility.retrieveSpecialCategoryConfigurations(orderHeaderId);
					if((isNotIntegrated||confTech || OB_EnrichOrder.PETROL == mccOrder ) && ((currentBankProfile.OB_NeedBIO__c && !addDoc)|| (!currentBankProfile.OB_NeedBIO__c)) && !checkAcquiring){ // Simone Misani WN-563 08/10/2019 .
						logRequestStatus = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
						
					}

				}				

			}
			//Simone Misani  WN-384-380-364 Stop 11/09/2019 - +91

			if(oiListToUpdate.keySet().size()>0){
				update oiListToUpdate.values();
			}		
			

			if(isIntegrate && isNotIntegrated){
				sourceMap.put('OB_Mixed_Maintenance__c','true');
			}else{
				sourceMap.put('OB_Mixed_Maintenance__c','false');
			}
			System.debug('sourceMap: '+sourceMap);						
			sourceMap.put('OB_Status__c',logRequestStatus);			
			OB_LogRequest__c logRequest = OB_Utility.insertLogRequest(sourceMap);					

			System.debug('LOG REQUEST IN SAVE: ' + logRequest.Id);
			data.put('logRequest',logRequest);
			//enrico.purificato WN-185 END - REFACTORED CODE

			//06-03-2019--S.P.--CALL METHOD ON OB_UTILITY TO DO FINAL ACTIONS
			OB_Utility.opsEndFlow(configurationId,false);
		}
		catch(Exception ecc) 
		{
			System.debug('[EXCE] OB_FlowControlUtility.riepilogoSave '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		
		System.debug('data:'+JSON.serialize(data.get('orderHeader')));
		
		System.debug('data:'+JSON.serialize(data.get('unbind.orderHeaderId')));
		System.debug('data:'+JSON.serialize(data.get('unbind.TEXT')));
		response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
		response.data = data;
		return response;
	}

	public static String createObjDataMap(String configId){
		String objDataMap = '';
		String accountId='';
		String pvId ='';
		String orderHeaderId='';
		String billProfId='';
		
		List<NE__Order__c> orders = [SELECT Id, OB_Service_Point__c, NE__AccountId__c, NE__BillingProfId__c, NE__Order_Header__c
									 FROM NE__Order__c 
									 WHERE id= :configId];
		//LOOKUP WITH OB_Service_Point__c(SP)
		pvId = orders.get(0).OB_Service_Point__c;
		//LOOKUP WITH NE__AccountId__c(Account)
		accountId = orders.get(0).NE__AccountId__c;
		//LOOKUP WITH NE_BillingProfId__c(BillingProf)
		orderHeaderId = orders.get(0).NE__Order_Header__c;
		//LOOKUP WITH NE__Order_Header__c(OrdHeader)
		billProfId = orders.get(0).NE__BillingProfId__c;
		
		System.debug('pvId : '+ pvId + 'accountId : ' + accountId + 'orderHeaderId : ' + orderHeaderId  + 'billProfId : ' + billProfId );
		
		//String servicePonitString = OB_Maintenance_Flow_Override.createServicePointNode(pvId);
		//String tempNodeServicePoint = OB_Maintenance_Flow_Override.createTempNode(servicePonitString);
		//String nodes = createNodes(accountId,pvId,orderHeaderId);

		return objDataMap;
	}

	public static String createTempNode (String objectToTemp){
		String tempoNodes = '';
		//String service = createServicePointNodeTemp(pvId);
		return tempoNodes;
	}

	public static NE__Service_Point__c createServicePointNode(String pvId){
		
		//OB_ServicePointAdminResponsible__c(Contact), OB_ServicePointResponsible__c(Contact)
		System.debug('SERVICE POINT ID: ' + pvId);
		List<NE__Service_Point__c> spList = [SELECT RecordTypeId, Id, Name, NE__City__c, NE__Street__c, NE__Province__c, NE__Postal_Code__c,
											 	OB_Opening_Monday_Morning__c, OB_Opening_Monday_Afternoon__c, OB_Opening_Tuesday_Morning__c, OB_Opening_Tuesday_Afternoon__c, OB_Opening_Wednesday_Morning__c,
											 	OB_Opening_Wednesday_Afternoon__c, OB_Opening_Thursday_Morning__c,OB_Opening_Thursday_Afternoon__c,OB_Opening_Friday_Morning__c,OB_Opening_Friday_Afternoon__c,
											 	OB_Opening_Saturday_Morning__c, OB_Opening_Saturday_Afternoon__c, OB_Opening_Sunday_Morning__c, OB_Opening_Sunday_Afternoon__c, OB_Street_Number__c, OB_Address_Hamlet__c, OB_Email__c, 
											 	OB_PEC__c, OB_Service_Point_City__c, OB_Workshift__c, OB_Start_Seasonal__c, OB_End_Seasonal__c, OB_Phone_Number__c, OB_Mobile_Phone_Number__c,
											 	OB_Fax_Number__c, OB_Privacy_C3__c, OB_Privacy_C4__c, OB_Privacy_C5__c, OB_AlternativeAddress__c, OB_Typology__c, NE__Zip_Code__c, OB_BypassValidation__c, 
											 	OB_Ecommerce__c, NE__Country__c, OB_MCC__c, OB_MCC_Description__c, NE__Country_Code__c,
												NE__Account__c, OB_Opening_Time__c, OB_Ending_Time__c,
												OB_Break_Start_Time__c, OB_Break_End_Time__c 
										 FROM NE__Service_Point__c 
										 WHERE id = :pvId];
		System.debug('SERVICE POINT LIST: ' + spList);
		NE__Service_Point__c spoint = new NE__Service_Point__c();
		if( !spList.isEmpty() ){
			spoint = spList.get(0);
			return spoint;
		} else {
			return null;
		}

	}
	
		
	public static Account createMerchantNode(String merchantId){
		System.debug('MERCHANT ID: ' + merchantId);
		Account merchant = new Account();
		List<Account> accList = new List<Account>();
		try {
			accList = [SELECT id,OB_Master_Merchant_Id__c,RecordTypeId,OB_Bank_Owner__c,OB_Legal_Form__c,NE__VAT__c,OB_ABI__c,OB_Description__c,NE__Status__c,OB_Bank_Group__c,
																				OB_New_Bank__c,OB_New_Bank_ABI__c,OB_Legal_Address_Name__c,OB_Legal_Address_Detail__c,OB_Legal_Address_Street__c,OB_Legal_Address_Street_Number__c,OB_Legal_Address_ZIP__c,
																				OB_Legal_Address_City__c,OB_Legal_Address_State__c,OB_Legal_Address_Country__c,OB_Merchants_Mngmnt_Office_Name__c,OB_Merchants_Mngmnt_Office_Street__c,
																				OB_Merchants_Mngmnt_Office_ZIP__c,OB_Merchants_Mngmnt_Office_City__c,OB_Merchants_Mngmnt_Office_State__c,OB_Merchants_Mngmnt_Office_Country__c,OB_Administrative_Office_Name__c,
																				OB_Administrative_Office_Street__c,OB_Administrative_Office_Street_Number__c,OB_Administrative_Office_Address_Details__c,OB_Administrative_Office_ZIP__c,OB_Administrative_Office_City__c,
																				OB_Administrative_Office_State__c,OB_Administrative_Office_Country__c,BillingAddress,Name,OB_Group_Code__c,OB_Year_constitution_company__c,
																				OB_No_Profit_Class__c,OB_No_Profit_Recipient_Class__c,OB_No_Profit_Recipient_Other__c,NE__Fiscal_code__c,OB_CCIAA__c,OB_CCIAA_Province__c,OB_SAE_Code__c,
																				OB_SAE_Description__c,OB_ATECO__c,OB_ATECO_Description__c,OB_Employees_Number__c,OB_Annual_Revenue__c,OB_Annual_Negotiated__c,OB_Beneficial_Owner_Existence__c,
																				OB_Reason_Absence_Owner__c,OB_VAT_Not_Present__c,OB_DescriptionVATNotPresent__c,OB_POSCTICode__c,OB_POSToolFreeNumber__c,OB_AcquiringToolFreeNumber__c,
																				OB_AlternativeAddress__c,OB_Legal_Form_Code__c, OB_FATECO__c
																				FROM Account WHERE RecordType.DeveloperName =: OB_UtilityConstants.MERCHANTRT AND Id = :merchantId LIMIT 1];
			
				System.debug('MERCHANT IS: ' + accList);                              
			if(! accList.isEmpty() ) {
				merchant = accList.get(0);
				return merchant;
			} 
		} catch (Exception ecc) {
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		return merchant;
	}
	
	public static NE__Order_Header__c createOrderHeaderNode(String ordHeadId) {
		NE__Order_Header__c orderHeader = new NE__Order_Header__c();
		List<NE__Order_Header__c> ordHeadList = new List<NE__Order_Header__c>();
		//	Daniele Gandini <daniele.gandini@accenture.com>	- 15/05/2019 - TerminalsReplacement - OB_Sub_Process__c added to the query - START
		try
		{
			ordHeadList = [SELECT Id, Name, OB_Business_Model_Acquiring__c, OB_Business_Model_POS__c, OB_FulfilmentStatus__c , OB_FinalRejectionEmail__c ,OB_ProposerABI__c, 
							 OB_GT_Error_Desc__c, OB_GT_Error_TS__c, OB_ABI__c, OB_CAB__c, OB_Report_Type__c  ,OB_PreliminaryVerificationCode__c,OB_Main_Process__c,OB_OrderDate__c,OB_NDG__c, OB_Sub_Process__c
							 FROM NE__Order_Header__c 
							 WHERE Id = :ordHeadId];
		//	Daniele Gandini <daniele.gandini@accenture.com>	- 15/05/2019 - TerminalsReplacement - OB_Sub_Process__c added to the query - END
			if( !ordHeadList.isEmpty() ) {
				orderHeader = ordHeadList.get(0);
			}
		} 
		catch (Exception ecc) 
		{
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		return orderHeader;
	}
	public static NE__Order__c createConfigurationNode(String configId){
		NE__Order__c configuration = new NE__Order__c();
		List<NE__Order__c> configurationList = new List<NE__Order__c>();
		try 
		{
			configurationList = [	select OB_GT__c,OB_MCCL2__c,NE__AccountId__c,NE__BillAccId__c, NE__ServAccId__c, OB_CAB__c, OB_Petitioner__c,OB_RequestDate__c,OB_Note__c,OB_Unistallation_Procedure__c,
									OB_ABI__c,id,OB_MCC__c,NE__Order_Header__r.OB_Main_Process__c,
									NE__Order_Header__r.OB_Business_Model_Acquiring__c, NE__Order_Header__r.OB_Business_Model_POS__c,
									OB_Service_Point__r.NE__City__c, OB_Service_Point__c,OB_Service_Point__r.OB_MCC__c, OB_ReceiptCity__c,
									NE__Order_Header__c, NE__Order_Header__r.OB_ABI__c, OB_ShopSign__c, Name, NE__Order_date__c, NE__Order_Header__r.OB_Report_Type__c,
									NE__OrderStatus__c, OB_Variation__c, OB_ReceiptHeader__c,RecordTypeId,OB_Report_Type__c,OB_MCC_Description__c,
									OB_BankAccount_Acquiring__c,NE__Parameters__c,NE__BillingProfId__c ,OB_SettlementType__c,OB_InternationalSettlementMethod__c,OB_PBSettlementMethod__c

									FROM NE__Order__c 
									WHERE Id = :configId];
			if(!configurationList.isEmpty()){
				configuration = configurationList.get(0);
			}
			System.debug('CONFIGURATION_RETURN: ' + configuration);
		}
		catch(Exception ecc)
		{
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		return configuration;

	}
	
	public static List<Contact> createContactsNodes(String accountId , String proposerABI){
		Id merchantId = (Id)accountId;
		System.debug('PARAMS_ACCOUNT ID:  '+accountId+'_PROPOSERABI: '+ proposerABI);
		List<Id> idListContacts = new List<Id>(); 
		idListContacts = OB_Maintenance_Flow_Override.rtList;
		System.debug('idListContacts: ' + idListContacts);
		List<Contact> contactsNodes = new List<Contact>();
		try
		{


			contactsNodes = [SELECT id, Phone,Email,OB_PEC__c,FirstName,LastName,OB_Company_Link_Type__c,OB_Fiscal_code__c,OB_Sex__c,OB_Country_Birth__c,OB_Country_Birth_Code__c,
													OB_Birth_State_Code__c,OB_Birth_Date__c,OB_Birth_City__c,OB_Birth_State__c,OB_Address_Country__c,OB_Citizenship__c,mobilephone,fax,OB_Document_Release_Country__c,
													OB_Document_Release_Country_Code__c, OB_Document_Release_State_Code__c,OB_Document_Release_State__c,OB_Document_Type__c,OB_Document_Number__c,OB_Document_Release_Authority__c,
													OB_Document_Release_Date__c,OB_Document_Expiration_Date__c,OB_Document_Release_City__c,OB_PEP__c,OB_Address_Street__c,OB_Address_Street_Number__c,OB_Address_City__c,
													OB_Address_State__c,OB_Address_PostalCode__c,OB_Address_Hamlet__c,OB_Address_State_Code__c,OB_Address_Country_Code__c,OB_Contact_State__c,accountid,recordtypeid,OB_Bank__c
													FROM contact 
													WHERE accountid =:  merchantId AND OB_Bank__c=: proposerABI AND OB_Contact_State__c='Active' AND recordtypeid IN: idListContacts];//status active
					System.debug('contactsNodes: ' + contactsNodes);
					if(!contactsNodes.isEmpty()){
						return contactsNodes;
					}else{
						contactsNodes = null;
					}
			}
			catch(Exception ecc)
		{
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		return contactsNodes;
		
		
	}
	
	
	//method to get lookup from configuration
	public static Map<String, String> getLookupsFromConfigurations(String configId) {
		Map<String, String> toReturn = new Map<String, String>();
		//configId='a0y9E000004XDYr';//a0y9E000004X965QAC
		try
		{
			List<NE__Order__c> orderList = [SELECT Id, OB_Service_Point__c, NE__AccountId__c, NE__BillingProfId__c, NE__Order_Header__c
									 	FROM NE__Order__c 
									 	WHERE id= :configId];
			System.debug('orderList: ' + orderList);						 
			if( !orderList.isEmpty() ) 
			{
				toReturn.put('OB_Service_Point__c' , String.valueOf(orderList.get(0).OB_Service_Point__c));
				toReturn.put('NE__AccountId__c'    , String.valueOf(orderList.get(0).NE__AccountId__c));
				toReturn.put('NE__BillingProfId__c' , String.valueOf(orderList.get(0).NE__BillingProfId__c));
				toReturn.put('NE__Order_Header__c' , String.valueOf(orderList.get(0).NE__Order_Header__c)); 
				toReturn.put('configId'            , String.valueOf(orderList.get(0).Id)); 
				System.debug('ID MAP: ' + toReturn);
			
			}
		}
		catch(Exception ecc){
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		return toReturn;
		
		
	}
	public static List<Contact> createContactsSPNode(String merchantId, String proposerABI, List<String> lookupSPContact) {
		System.debug(' PArAMS ARE: ');
		System.debug(' @@ merchantId is: ' + merchantId);
		System.debug(' @@ proposerABI is: ' + proposerABI);
		System.debug(' @@ lookupSPContact are : ' + lookupSPContact);
		List<Contact> contactsSPNodes = new List<Contact>();
		try {
			contactsSPNodes = [	SELECT id, Phone,Email,OB_PEC__c,FirstName,LastName,OB_Company_Link_Type__c,OB_Fiscal_code__c,OB_Sex__c,OB_Country_Birth__c,OB_Country_Birth_Code__c,
														OB_Birth_State_Code__c,OB_Birth_Date__c,OB_Birth_City__c,OB_Birth_State__c,OB_Address_Country__c,OB_Citizenship__c,mobilephone,fax,OB_Document_Release_Country__c,
														OB_Document_Release_Country_Code__c, OB_Document_Release_State_Code__c,OB_Document_Release_State__c,OB_Document_Type__c,OB_Document_Number__c,OB_Document_Release_Authority__c,
														OB_Document_Release_Date__c,OB_Document_Expiration_Date__c,OB_Document_Release_City__c,OB_PEP__c,OB_Address_Street__c,OB_Address_Street_Number__c,OB_Address_City__c,
														OB_Address_State__c,OB_Address_PostalCode__c,OB_Address_Hamlet__c,OB_Address_State_Code__c,OB_Address_Country_Code__c,OB_Contact_State__c,accountid, recordtypeid, OB_Bank__c
														FROM Contact 
														WHERE accountid =:  merchantId AND OB_Bank__c=: proposerABI AND OB_Contact_State__c='Active' AND Id IN :lookupSPContact];
			System.debug(' @@ contactsSPNodes are: ' + contactsSPNodes);
														
		} catch (Exception ecc) {
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}        
										
		return !contactsSPNodes.isEmpty()?contactsSPNodes:null;
	}
	
	public static OB_Bank_profile__c createBankProfileNode(String proposerABI){
		OB_Bank_profile__c bankProfile = new OB_Bank_profile__c();
		List<OB_Bank_profile__c> bankProfileList = new List<OB_Bank_profile__c>();
		try {
			bankProfileList = [SELECT id ,
																		OB_Business_Model_Acquiring__c,
																		OB_Bank__c,
																		OB_GT__c,
																		OB_Business_Model_POS__c ,
																		OB_Circuit__c,
																		OB_Other_Acquirer__c ,
																		OB_Service_Type__c,
																		OB_Apm_Circuit__c,
																		OB_Vas__c,
																		OB_SettlementType__c ,
																		OB_AccountHolder__c ,
																		OB_Applicant_RAC_Code_SIA__c ,
																		OB_Terminal_Id_Generator__c ,
																		OB_Terminal_Id_Gateway__c, //davide.franzini - F2WAVE2-4 - 17/07/2019
																		OB_NeedBIO__c,
																		OB_NDG__c
																		FROM OB_Bank_Profile__c
																		WHERE OB_Bank__c = :proposerABI 
																		LIMIT 1];
																		
			System.debug('bankProfileList is : ' + bankProfileList );                                    
			if( !bankProfileList.isEmpty() ){
				bankProfile = bankProfileList.get(0);
			} else {
				bankProfile =  null;
			}
		} catch(Exception ecc) {
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		return bankProfile;

	}
	
	public static List<NE__Billing_Profile__c> createBillingProfileNode(List<String> billingProfLookups){
		List<NE__Billing_Profile__c> billingProfileList = new List<NE__Billing_Profile__c>();
		
		try {
			billingProfileList = [	SELECT Id, NE__Account__c, OB_ABI__c, OB_EuroControlCode__c, OB_CountryCode__c, OB_CINCode__c, OB_CABCode__c, OB_ABICode__c, OB_Bank_Account_Type__c, OB_Bank_Account_Number__c, OB_IBAN__c , OB_HeaderInternational__c
									FROM NE__Billing_Profile__c 
									WHERE Id IN : billingProfLookups];
		
		System.debug('billingProfileList: ' + billingProfileList);
		} 
		catch(Exception ecc) 
		{
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			billingProfileList = null;
		}
		return billingProfileList;
	}

	public static List<ExternalSourceMapping__c> createExternalSourceNode(String merchantId){
		 List<ExternalSourceMapping__c> externalSourceMappingList = new  List<ExternalSourceMapping__c>();
		 
		 try {
		 	externalSourceMappingList = [	SELECT Id,Name,OB_Merchant_ID__c,OB_Service_Point_ID__c, OB_CustomerCodeClientCode__c  ,OB_Source__c ,OB_ReportType__c
											FROM ExternalSourceMapping__c
											WHERE OB_Source__c !='' 
											AND OB_Service_Point_ID__c = '' 
											AND OB_Merchant_ID__c=:merchantId 
											AND OB_ToBeChecked__c=true]; // OPPURE OB_ToBeChecked__c=false ??????? 
		 } catch (Exception Ecc) {
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		 	externalSourceMappingList= null;
		 }
		 return externalSourceMappingList;
	}
	
	public static Map<String,List<NE__OrderItem__c>> createOrderItemNode(String configId){
		Map<String , List<NE__OrderItem__c>> mapOrderItemAdded = new Map<String , List<NE__OrderItem__c>>();
		List<NE__OrderItem__c> orderItemList =new List<NE__OrderItem__c>(); 
		System.debug('RECORD_TYPE_ORDER_ITEM: ' + rtListOrderItem);
		try 
		{
			//create a list with new order item from maintenance 'modfica offerta' (only acquiring)
			//26/07/19 francesca.ribezzi adding NE__ProdId__r.RecordTypeId
			orderItemList= [SELECT Id,NE__Action__c, NE__Status__c , RecordTypeId,Name, NE__ProdName__c,NE__BillingProfId__c,NE__ProdId__r.OB_Codice_sfdc__c ,
							NE__ProdId__r.OB_Acquirer__c, NE__ProdId__r.Name, NE__ProdId__r.RecordTypeId
							FROM NE__OrderItem__c 
							WHERE NE__OrderId__c =:configId AND NE__Action__c='Add' AND NE__ProdId__r.RecordTypeId IN: rtListOrderItem AND NE__Root_Order_item__c=''];
			List<NE__OrderItem__c> orderPOSList 		= new List<NE__OrderItem__c>();
			List<NE__OrderItem__c> orderACQUIRINGList 	= new List<NE__OrderItem__c>();
			for(NE__OrderItem__c orderItem : orderItemList )
			{ 
				if(orderItem.NE__ProdId__r.RecordTypeId == rtPOS || orderItem.NE__ProdId__r.RecordTypeId == rtPOSMoto || orderItem.NE__ProdId__r.RecordTypeId == rtPOSEcommerce){ 	//26/07/19 francesca.ribezzi adding NE__ProdId__r.RecordTypeId && Simone Misani WN-610 14/10/2019
					orderPOSList.add(orderItem);
					
				}
				if(orderItem.NE__ProdId__r.RecordTypeId == rtACQUIRING){ //26/07/19 francesca.ribezzi adding NE__ProdId__r.RecordTypeId
					orderACQUIRINGList.add(orderItem);
					
				}
			}
			mapOrderItemAdded.put('POS' , orderPOSList);
			mapOrderItemAdded.put('ACQUIRING' , orderACQUIRINGList);
			System.debug('ORDER_ITEM_MAP: ' + JSON.serialize(mapOrderItemAdded));
		}
		catch(Exception Ecc) 
		{
			System.debug('Generic Error createOrderItemNode: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		 	
		}
		return mapOrderItemAdded;
	}

	/*------------------------------------------------------------
    Author:        Daniele Gandini
    Company:       Accenture Tecnology
    Description:   retrieve old terminals info
    Date:          15/05/2019
   ------------------------------------------------------------*/
	public static List<String> retrieveTerminalIdFromRemovedPOS(String confId){

		List<String> terminalIdList = new List<String>();
		List<NE__OrderItem__c> oldTerminals = new List<NE__OrderItem__c>();
		oldTerminals = 	[SELECT	Id,
								OB_TermId__c
								// NE__OrderId__r.NE__BillingProfId__c,
								// OB_RAC_SIA__c
								FROM NE__OrderItem__c
								WHERE
								NE__OrderId__c = :confId AND
								NE__ProdId__r.RecordType.DeveloperName = :OB_UtilityConstants.POS_RT AND
								NE__Action__c  = :OB_UtilityConstants.REMOVE_ACTION
								ORDER BY OB_TermId__c
						];
		if(oldTerminals.size() > 0){
			for(NE__OrderItem__c singleTerminalId : oldTerminals){
				if(!terminalIdList.contains(singleTerminalId.OB_TermId__c)){
					terminalIdList.add(singleTerminalId.OB_TermId__c);
				}
			}
			return terminalIdList;
		}else{
			return null;
		}
	}

	/*------------------------------------------------------------
    Author:        Daniele Gandini
    Company:       Accenture Tecnology
    Description:   retrieve old terminals info
    Date:          15/05/2019
   ------------------------------------------------------------*/
	public static Boolean checkIfReplacementCase(String confId){
		List <NE__Order__c> isReplacementOrder = new List <NE__Order__c>();
		Boolean isReplacement = false;

		isReplacementOrder = [SELECT	Id,
										OB_Active_Terminals__c,
										NE__Order_Header__c,
										NE__Order_Header__r.OB_Sub_Process__c
										FROM NE__Order__c
										WHERE Id = :confId];
		if(!isReplacementOrder.isEmpty() && !(isReplacementOrder.size()>1)){
			for(NE__Order__c order : isReplacementOrder){
				// if(order.OB_Active_Terminals__c != null && order.OB_Active_Terminals__c != 0){
					if(order.NE__Order_Header__r.OB_Sub_Process__c == OB_UtilityConstants.TERMINALS_REPLACEMENT){
					isReplacement = true;
				}
			}
		}
		return isReplacement;
	}

    /*******************************************************************************
    Purpose:  Method prepare a new logic for referente
    Parameters: Id pvId, Id recordId
    Returns: Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban       	24/06/2019      Created         NEXI-112
    ********************************************************************************/
    public static Id getContactId( Id pvId, Id recordId )
    {
        List<Contact> nodeContacts =
        [
                SELECT Id
                FROM Contact
                WHERE OB_Service_Point__c = :pvId
                AND RecordTypeId = :recordId
                AND OB_Contact_State__c= :OB_UtilityConstants.STATUS_ACTIVE
        ];
        if( nodeContacts.size() > 0 )
        {
            return nodeContacts.get(0).Id;
        }
        else
        {
            return null;
        }
    }
    /*******************************************************************************
    Purpose:  		Method to get sia source for Log Request Status
	Method name: 	getIsSIAtoApprove
    History:
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Francesca Ribezzi       01/07/2019      Created         F2WAVE2-53
    ********************************************************************************/
    public static Boolean getIsSIAtoApprove( String configurationId ){
		String sia = OB_UtilityConstants.SIA;
		Boolean flagSia = false;
		List<NE__OrderItem__c> siaList = 
		[ 
			SELECT id, OB_Processor__c 
			FROM NE__OrderItem__c 
			WHERE OB_Processor__c = :sia
			AND NE__OrderId__c = :configurationId

		];
		System.debug('siaList: ' + siaList.size());
		if(siaList.size() > 0){
			flagSia = true;
		}
		return flagSia;
	}
//START--Simone Misani Fix Tracking 20/07/2019
	public static void updateOrderItemActionNone(String orderHeadId){
		List<NE__OrderItem__c> listUpdateOrderItem = new List<NE__OrderItem__c>();
		//START--Simone Misani WN-180 - WN-289 29/08/2019
		String idOrder = '';
		Integer countASSPremium = 0;
        Integer countAdd = 0;
		//END--Simone Misani WN-180 - WN-289 29/08/2019
		List<NE__OrderItem__c> listOrderItem = [	SELECT 	Id,
															NE__Action__c,
															NE__Status__c,
															OB_FulfilmentStatus__c,
															NE__OrderId__c,
                                                			NE__ProdId__r.OB_Codice_sfdc__c,//Simone Misani WN-180 - WN-289 29/08/2019
                                                			NE__Root_Order_Item__r.NE__ProdId__r.OB_Codice_sfdc__c//Simone Misani WN-180 - WN-289 29/08/2019
													FROM	NE__OrderItem__c
													WHERE	NE__OrderId__r.NE__Order_Header__c  =:orderHeadId 
													
													AND		NE__Status__c !=: OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED];
		//START--Simone Misani WN-180 28/08/2019
		if(!listOrderItem.isEmpty()){
			for(NE__OrderItem__c oi : listOrderItem){
				if(oi.NE__Action__c ==  OB_UtilityConstants.ORDERITEM_ACTION_NONE 
					|| oi.NE__ProdId__r.OB_Codice_sfdc__c == 'ASS_PREMIUM'
					|| oi.NE__Root_Order_Item__r.NE__ProdId__r.OB_Codice_sfdc__c=='ASS_PREMIUM'){
					
					oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
					listUpdateOrderItem.add(oi);
				}
			}		// Antonio.vatrano wn-413 18/09/2019
			update listUpdateOrderItem;	
		}// Antonio.vatrano wn-413 18/09/2019
	}//END--Simone Misani   Fix Tracking 20/07/2019

}