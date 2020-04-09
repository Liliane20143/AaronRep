/*****************************************************************
Name:  RetrieveAnagraficaMerchantController

============================================================
Purpose:                                                                                                                     
============================================================
History                                                            
-------                                                            
VERSION  AUTHOR             				DATE           DETAIL          Description
1.0  Marco Armato		   10/09/2018       Created          CSR: 
*****************************************************************/
public without sharing class OB_RetrieveAnagraficaMerchantController {
   
	@AuraEnabled
	public static Account getAccountById(String idAcc){
		return  [select id, Name, NE__Fiscal_code__c, NE__VAT__c, OB_SAE_Code__c, OB_Year_constitution_company__c, OB_SionID__c, OB_CCIAA__c, OB_CCIAA_Province__c, OB_VAT_Not_Present__c
					from account
					where Id =: idAcc  
					limit 1];
	}

	private static List<Contact> getListContactSedeLegale(String idAcc){
		return [Select id, name, RecordType.Name
					FROM Contact
					WHERE AccountId =: idAcc AND RecordType.DeveloperName = 'Dati_Societ_Legale'];
	}

	@AuraEnabled
	public static Account updateMerchant(String idAcc, String accService){ 
		System.debug('Id account into updateMerchant: '+idAcc);
		System.debug('account Service into update merchant: '+accService);

		Account accLocal = OB_RetrieveAnagraficaMerchantController.getAccountbyId(idAcc);

		List<Contact> listConSedeLegale = OB_RetrieveAnagraficaMerchantController.getListContactSedeLegale(idAcc);

		 if (accService == null)
			return acclocal;
		
		 System.debug('account Service into update merchant: '+accLocal);

		OB_MerchantFromJSON accountFromService = OB_MerchantFromJSON.parse(accService);
		System.debug('accountFromService: ' + accountFromService);

		if (listConSedeLegale.isEmpty()){
			Recordtype rt  = [select id,name from RecordType where Sobjecttype='Contact' and DeveloperName='Dati_Societ_Legale' and isActive = true limit 1];
			Contact conSedeLegale = new Contact( accountId = accLocal.id, 
												lastname = 'Sede Legale '+accLocal.name,
												RecordTypeId = rt.Id );                                              
			listConSedeLegale.add(conSedeLegale);
		}

		listConSedeLegale[0].OB_PEC__c = accountFromService.PEC;

		accLocal.OB_SionID__c = String.isBlank(accountFromService.pgId) ? accLocal.OB_SionID__c : accountFromService.pgId; 
		accLocal.NE__Fiscal_code__c = String.isBlank(accountFromService.fiscalCode) ? accLocal.NE__Fiscal_code__c : accountFromService.fiscalCode;
		accLocal.NE__VAT__c = String.isBlank(accountFromService.vatCode) ? accLocal.NE__VAT__C : accountFromService.vatCode;
		accLocal.Name = String.isBlank(accountFromService.name) ?  accLocal.Name : accountFromService.name;
		accLocal.OB_Legal_Form__c = String.isBlank(accountFromService.legalForm) ? accLocal.OB_Legal_Form__c : accountFromService.legalForm;

		accLocal.OB_Year_constitution_company__c = String.isBlank(accountFromService.yearConstitutionCompany) ? accLocal.OB_Year_constitution_company__c : Decimal.valueOf(accountFromService.yearConstitutionCompany); 
		accLocal.OB_CCIAA__c = String.isBlank(accountFromService.companyRegistrationNumber) ? accLocal.OB_CCIAA__c : accountFromService.companyRegistrationNumber; 
		accLocal.OB_CCIAA_Province__c = String.isBlank(accountFromService.provinceChamberOfCommerce) ? accLocal.OB_CCIAA_Province__c : accountFromService.provinceChamberOfCommerce; 
		accLocal.OB_SAE_Code__c = String.isBlank(accountFromService.commoditySectorCodeSAE) ?  accLocal.Name : accountFromService.commoditySectorCodeSAE;
		accLocal.OB_ATECO__c = String.isBlank(accountFromService.atecoCode) ? accLocal.OB_ATECO__c : accountFromService.atecoCode;


		//Legal form fields  
		
		if(accountFromService.RegisteredOfficeAddress != null){
			accLocal.OB_Legal_Address_Street__c = String.isBlank(accountFromService.RegisteredOfficeAddress.street) ? accLocal.OB_Legal_Address_Street__c : accountFromService.RegisteredOfficeAddress.street;
			accLocal.OB_Legal_Address_Street_Number__c = String.isBlank(accountFromService.RegisteredOfficeAddress.civicNumber) ? accLocal.OB_Legal_Address_Street_Number__c : accountFromService.RegisteredOfficeAddress.civicNumber;
			accLocal.OB_Legal_Address_Detail__c = String.isBlank(accountFromService.RegisteredOfficeAddress.careOf) ? accLocal.OB_Legal_Address_Detail__c : accountFromService.RegisteredOfficeAddress.careOf;
			accLocal.OB_Legal_Address_ZIP__c = String.isBlank(accountFromService.RegisteredOfficeAddress.postalCode) ? accLocal.OB_Legal_Address_ZIP__c : accountFromService.RegisteredOfficeAddress.postalCode;
			accLocal.OB_Legal_Address_City__c = String.isBlank(accountFromService.RegisteredOfficeAddress.city) ? accLocal.OB_Legal_Address_City__c : accountFromService.RegisteredOfficeAddress.city;
			accLocal.OB_Legal_Address_State__c = String.isBlank(accountFromService.RegisteredOfficeAddress.province) ? accLocal.OB_Legal_Address_State__c : accountFromService.RegisteredOfficeAddress.province;
			accLocal.OB_Legal_Address_Country__c = String.isBlank(accountFromService.RegisteredOfficeAddress.country) ? accLocal.OB_Legal_Address_Country__c : accountFromService.RegisteredOfficeAddress.country;

		}
		
		//Billing form fields  

		if(accountFromService.InvoicingAddress != null){
			accLocal.BillingStreet = String.isBlank(accountFromService.InvoicingAddress.street) ? accLocal.BillingStreet : accountFromService.InvoicingAddress.street + ', ' + accountFromService.InvoicingAddress.civicNumber;
			accLocal.BillingPostalCode = String.isBlank(accountFromService.InvoicingAddress.postalCode) ? accLocal.BillingPostalCode : accountFromService.InvoicingAddress.postalCode;
			accLocal.BillingCity = String.isBlank(accountFromService.InvoicingAddress.city) ? accLocal.BillingCity : accountFromService.InvoicingAddress.city + ' (' + accountFromService.InvoicingAddress.city + ')';
			accLocal.BillingCountry = String.isBlank(accountFromService.InvoicingAddress.country) ? accLocal.BillingCountry : accountFromService.InvoicingAddress.country;
			accLocal.BillingState = String.isBlank(accountFromService.InvoicingAddress.province) ? accLocal.BillingCountry : accountFromService.InvoicingAddress.province;
		}

		//Administrative form fields 
		if(accountFromService.AdmistrativeAddress != null){
			accLocal.OB_Administrative_Office_Street__c = String.isBlank(accountFromService.AdmistrativeAddress.street) ? accLocal.OB_Administrative_Office_Street__c : accountFromService.AdmistrativeAddress.street;
			accLocal.OB_Administrative_Office_Street_Number__c = String.isBlank(accountFromService.AdmistrativeAddress.civicNumber) ? accLocal.OB_Administrative_Office_Street_Number__c : accountFromService.AdmistrativeAddress.civicNumber;
			accLocal.OB_Administrative_Office_Address_Details__c = String.isBlank(accountFromService.AdmistrativeAddress.careOf) ? accLocal.OB_Administrative_Office_Address_Details__c : accountFromService.AdmistrativeAddress.careOf;
			accLocal.OB_Administrative_Office_ZIP__c = String.isBlank(accountFromService.AdmistrativeAddress.postalCode) ? accLocal.OB_Administrative_Office_Address_Details__c : accountFromService.AdmistrativeAddress.postalCode;
			accLocal.OB_Administrative_Office_City__c = String.isBlank(accountFromService.AdmistrativeAddress.city) ? accLocal.OB_Administrative_Office_City__c : accountFromService.AdmistrativeAddress.city;
			accLocal.OB_Administrative_Office_State__c = String.isBlank(accountFromService.AdmistrativeAddress.province) ? accLocal.OB_Administrative_Office_State__c : accountFromService.AdmistrativeAddress.province;
			accLocal.OB_Administrative_Office_Country__c = String.isBlank(accountFromService.AdmistrativeAddress.country) ? accLocal.OB_Administrative_Office_Country__c : accountFromService.AdmistrativeAddress.country;
		}

		set<string> sourceSet = new set<string>();
		set<string> customerCodeClientCodeSet = new set<string>();
		List<ExternalSourceMapping__c> listNotExistingDataSource = new List<ExternalSourceMapping__c>();

		List<ExternalSourceMapping__c> listAcquiring = new List<ExternalSourceMapping__c>();
		
		for (OB_MerchantFromJSON.cls_acquiring currentAcquiring : accountFromService.Acquiring) {
			ExternalSourceMapping__c accountFormAcquiring = new ExternalSourceMapping__c( 
																						OB_Merchant_ID__c = idAcc,
																						OB_CustomerCodeClientCode__c = currentAcquiring.socId,
																						OB_Source__c = currentAcquiring.processor, 
																						OB_Start_Date__c =  Date.valueOf(currentAcquiring.activityStartDate), 
																						OB_Pricing__c = currentAcquiring.pricingType, 
																						OB_ReportType__c = OB_RetrieveAnagraficaMerchantController.getReportType(currentAcquiring.typeOfAccountStatement));  
			listAcquiring.add(accountFormAcquiring);
			sourceSet.add(accountFormAcquiring.OB_Source__c);
			customerCodeClientCodeSet.add(accountFormAcquiring.OB_CustomerCodeClientCode__c);
		}

		List<ExternalSourceMapping__c> listPOS = new List<ExternalSourceMapping__c>();
		
		for (OB_MerchantFromJSON.cls_POS currentPOS : accountFromService.POS) {
			ExternalSourceMapping__c accountFormPOS = new ExternalSourceMapping__c( OB_Merchant_ID__c = idAcc,
																					OB_CustomerCodeClientCode__c =  currentPOS.clientId, 
																					OB_Source__c = currentPOS.gt=='NEXI' ? 'Monetica' : currentPOS.gt);
			listPOS.add(accountFormPOS);
			sourceSet.add(accountFormPOS.OB_Source__c);
			customerCodeClientCodeSet.add(accountFormPOS.OB_CustomerCodeClientCode__c);
		}
		
		List<ExternalSourceMapping__c> listExistingExternalSource = [select Id, 
																			OB_Source__c, 
																			OB_CustomerCodeClientCode__c,
																			OB_Start_Date__c,
																			OB_Pricing__c,
																			OB_ReportType__c,
																			OB_Merchant_ID__c

																			from ExternalSourceMapping__c where OB_Merchant_ID__c !='' AND OB_CustomerCodeClientCode__c in: customerCodeClientCodeSet AND OB_Source__c in: sourceSet ];
		
		List<ExternalSourceMapping__c> listNotExistingExternalSource = new List<ExternalSourceMapping__c>();
		List<ExternalSourceMapping__c> listNewExternalSource = new List<ExternalSourceMapping__c>();
		listNewExternalSource.addAll(listAcquiring); 
		listNewExternalSource.addAll(listPOS);

		System.debug('List New External Source'+listNewExternalSource);

		ExternalSourceMapping__c tempSource = new ExternalSourceMapping__c();
		for(ExternalSourceMapping__c currExternalSource: listNewExternalSource ){
			Boolean exist = false;
			for(ExternalSourceMapping__c existExternalSource: listExistingExternalSource ){
				tempSource = existExternalSource.clone(false,false,false,false);
				if((currExternalSource.OB_CustomerCodeClientCode__c == existExternalSource.OB_CustomerCodeClientCode__c && currExternalSource.OB_Source__c == existExternalSource.OB_Source__c )){
					exist = true;
					existExternalSource.OB_Merchant_ID__c = currExternalSource.OB_Merchant_ID__c;
					existExternalSource.OB_Start_Date__c = currExternalSource.OB_Start_Date__c; 
					existExternalSource.OB_Pricing__c = currExternalSource.OB_Pricing__c;
					existExternalSource.OB_ReportType__c = currExternalSource.OB_ReportType__c;
					break;
				}
			}
			if(exist == false){
				tempSource.OB_Merchant_ID__c = currExternalSource.OB_Merchant_ID__c;
				tempSource.OB_Source__c = currExternalSource.OB_Source__c;
				tempSource.OB_CustomerCodeClientCode__c = currExternalSource.OB_CustomerCodeClientCode__c;
				tempSource.OB_Start_Date__c = currExternalSource.OB_Start_Date__c; 
				tempSource.OB_Pricing__c = currExternalSource.OB_Pricing__c;
				tempSource.OB_ReportType__c = currExternalSource.OB_ReportType__c;
				listNotExistingExternalSource.add(tempSource);
			}
		}

		System.debug('List External: '+listNewExternalSource);
		System.debug('List Existing: '+listExistingExternalSource);
		System.debug('List Not Existing: '+listNotExistingExternalSource);

		try{
			//database.upsert(listAcquiring, ExternalSourceMapping__c.OB_CustomerCodeClientCode__c);
			//database.upsert(listPOS, ExternalSourceMapping__c.OB_CustomerCodeClientCode__c); 
			insert(listNotExistingExternalSource);
			update(listExistingExternalSource);
			update(acclocal);
			return accLocal;
		}catch(Exception e){
			System.debug('The following exception has occurred: ' + e.getMessage());
			return null;
		}
	}

	private static String getReportType(String strReport){
		String[] values = OB_RetrieveAnagraficaMerchantController.picklist_values('ExternalSourceMapping__c', 'OB_ReportType__c');
		System.debug('Values List Picklist: '+values);
		if(strReport=='SOCIETA_CUMULATIVO'){
			System.debug('Entrato Società Cumulativo');
			return values[0];
		}
		else if(strReport=='SOCIETA_PER_PUNTO_VENDITA')
			return values[1];
		else if(strReport=='PUNTO_VENDITA')
			return values[2];
		else
			return '';     
	}
	
	private static String[] picklist_values(String object_name, String field_name) {
		String[] values = new String[]{};
		String[] types = new String[]{object_name};
		Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
		for(Schema.DescribeSobjectResult res : results) {
			for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) {
			if (entry.isActive()) {values.add(entry.getValue());}
			}
		}
		return values;
   }

/********************************** START Antonio Vatrano  17-12-18 **********************/

	@AuraEnabled
	public static Object retrieveMerchantNew(String fiscalCode, String vatCode){

		//	START 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
		//String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
		String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
		//OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(system.Label.OB_Environment);
		OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
		//	END 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

		
		String url = 'callout:OB_callService/api/merchant-registry/merchants/search';
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('POST');
		String token = OB_UtilityCallingServices.checkToken();
		//system.debug('Service message: '+token);
		if(token != 'Error')
		{
			req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
			req.setHeader('Content-Type','application/json');
			req.setBody('{"fiscalCode":"'+fiscalCode+'","vatCode":"'+vatCode+'"}');
			if(intConfig.OB_CAsigned_name__c!=null)
			{
				req.setClientCertificateName(intConfig.OB_CAsigned_name__c); 
			} 
			System.debug('Request to service contract: ' + req);
			Http http = new Http();
			HTTPResponse res = new HTTPResponse();
			res = http.send(req);
			System.debug('Response body: '+res.getBody());
			return res.getBody();
		}
		else
		{
			return 'Error parsing';
		}

	}

/********************************** END Antonio Vatrano  17-12-18 **********************/

}