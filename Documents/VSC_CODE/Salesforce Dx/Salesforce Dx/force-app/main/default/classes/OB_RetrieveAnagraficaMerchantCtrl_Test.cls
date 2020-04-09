@isTest
public class OB_RetrieveAnagraficaMerchantCtrl_Test {

	@isTest
	public static void updateMerchantTest1(){

		List <Account> accList = new List<Account>();
		Account acc = new Account(Name = 'accName', OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c='05218600962', NE__VAT__c='13454210157', OB_VAT_Not_Present__c=false );
		insert acc;
		//accList.add(acc);

		Test.startTest();
		OB_RetrieveAnagraficaMerchantController.updateMerchant(acc.Id, null);
		Test.stopTest();
	}

	@isTest
	public static void updateMerchantTest2(){

		Account acc = new Account(Name = 'accName',OB_Employees_Number__c = 'Minore di 10 ', NE__Fiscal_code__c='05218600962', NE__VAT__c='13454210157', OB_VAT_Not_Present__c=false );
		insert acc;
		List <Account> accList = new List<Account>();
		//accList.add(acc);
		ExternalSourceMapping__c esm = new ExternalSourceMapping__c();
		esm.OB_Merchant_ID__c = acc.id;
		esm.OB_CustomerCodeClientCode__c = '425080';
		esm.OB_Source__c = 'Monetica';
		insert esm; 
		String accService = '{"pgId":"","fiscalCode":"05218600962","vatCode":"05218600962","name":"STRADIVARIUS ITALIA SRL","legalForm":null,"PEC":null,"yearConstitutionCompany":null,"companyRegistrationNumber":null,"provinceChamberOfCommerce":null,"commoditySectorCodeSAE":null,"atecoCode":null,"RegisteredOfficeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"InvoicingAddress":{"street":null,"civicNumber":null,"careOf":null,"postalCode":null,"city":null,"province":null,"country":null},"AdmistrativeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"Acquiring" : [{"socId" : "123", "activityStartDate" : "' + Date.newInstance(2018, 10, 05) + '", "typeOfAccountStatement" : "SOCIETA_PER_PUNTO_VENDITA"}],"POS":[{"clientId":"425080","gt":"NEXI","updatedDate":"2010-09-07"}],"result":0}';
		Test.startTest();
		OB_RetrieveAnagraficaMerchantController.updateMerchant(acc.Id, accService); 
		Test.stopTest();
	}

	@isTest
	public static void updateMerchantTest3(){

		Account acc = new Account(Name = 'accName',OB_Employees_Number__c = 'Minore di 10 ', NE__Fiscal_code__c='05218600962', NE__VAT__c='13454210157', OB_VAT_Not_Present__c=false );
		insert acc;
		List <Account> accList = new List<Account>();
		//accList.add(acc);
		ExternalSourceMapping__c esm = new ExternalSourceMapping__c();
		esm.OB_Merchant_ID__c = acc.id;
		esm.OB_CustomerCodeClientCode__c = '425080';
		esm.OB_Source__c = 'Monetica';
		insert esm; 
		String accService = '{"pgId":"","fiscalCode":"05218600962","vatCode":"05218600962","name":"STRADIVARIUS ITALIA SRL","legalForm":null,"PEC":null,"yearConstitutionCompany":null,"companyRegistrationNumber":null,"provinceChamberOfCommerce":null,"commoditySectorCodeSAE":null,"atecoCode":null,"RegisteredOfficeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"InvoicingAddress":{"street":null,"civicNumber":null,"careOf":null,"postalCode":null,"city":null,"province":null,"country":null},"AdmistrativeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"Acquiring" : [{"socId" : "123", "activityStartDate" : "' + Date.newInstance(2018, 10, 05) + '", "typeOfAccountStatement" : "SOCIETA_CUMULATIVO"}],"POS":[{"clientId":"425080","gt":"NEXI","updatedDate":"2010-09-07"}],"result":0}';
		Test.startTest();
		OB_RetrieveAnagraficaMerchantController.updateMerchant(acc.Id, accService); 
		Test.stopTest();
	}

	@isTest
	public static void updateMerchantTest4(){

		Account acc = new Account(Name = 'accName',OB_Employees_Number__c = 'Minore di 10 ', NE__Fiscal_code__c='05218600962', NE__VAT__c='13454210157', OB_VAT_Not_Present__c=false );
		insert acc;
		List <Account> accList = new List<Account>();
		//accList.add(acc);
		ExternalSourceMapping__c esm = new ExternalSourceMapping__c();
		esm.OB_Merchant_ID__c = acc.id;
		esm.OB_CustomerCodeClientCode__c = '425080';
		esm.OB_Source__c = 'Monetica';
		insert esm; 
		String accService = '{"pgId":"","fiscalCode":"05218600962","vatCode":"05218600962","name":"STRADIVARIUS ITALIA SRL","legalForm":null,"PEC":null,"yearConstitutionCompany":null,"companyRegistrationNumber":null,"provinceChamberOfCommerce":null,"commoditySectorCodeSAE":null,"atecoCode":null,"RegisteredOfficeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"InvoicingAddress":{"street":null,"civicNumber":null,"careOf":null,"postalCode":null,"city":null,"province":null,"country":null},"AdmistrativeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"Acquiring" : [{"socId" : "123", "activityStartDate" : "' + Date.newInstance(2018, 10, 05) + '", "typeOfAccountStatement" : "PUNTO_VENDITA"}],"POS":[{"clientId":"425080","gt":"NEXI","updatedDate":"2010-09-07"}],"result":0}';
		Test.startTest();
		OB_RetrieveAnagraficaMerchantController.updateMerchant(acc.Id, accService); 
		Test.stopTest();
	}

	@isTest
	public static void updateMerchantTest5(){

		Account acc = new Account(Name = 'accName',OB_Employees_Number__c = 'Minore di 10 ', NE__Fiscal_code__c='05218600962', NE__VAT__c='13454210157', OB_VAT_Not_Present__c=false );
		insert acc;
		List <Account> accList = new List<Account>();
		//accList.add(acc);
		ExternalSourceMapping__c esm = new ExternalSourceMapping__c();
		esm.OB_Merchant_ID__c = acc.id;
		esm.OB_CustomerCodeClientCode__c = '425080';
		esm.OB_Source__c = 'Monetica';
		insert esm; 
		String accService = '{"pgId":"","fiscalCode":"05218600962","vatCode":"05218600962","name":"STRADIVARIUS ITALIA SRL","legalForm":null,"PEC":null,"yearConstitutionCompany":null,"companyRegistrationNumber":null,"provinceChamberOfCommerce":null,"commoditySectorCodeSAE":null,"atecoCode":null,"RegisteredOfficeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"InvoicingAddress":{"street":null,"civicNumber":null,"careOf":null,"postalCode":null,"city":null,"province":null,"country":null},"AdmistrativeAddress":{"street":"VIA MORIMONDO 26","civicNumber":"","careOf":null,"postalCode":"20143","city":"MILANO","province":"MI","country":"ITA"},"Acquiring" : [{"socId" : "123", "activityStartDate" : "' + Date.newInstance(2018, 10, 05) + '", "typeOfAccountStatement" : ""}],"POS":[{"clientId":"425080","gt":"NEXI","updatedDate":"2010-09-07"}],"result":0}';
		Test.startTest();
		OB_RetrieveAnagraficaMerchantController.updateMerchant(acc.Id, accService); 
		Test.stopTest();
	}

}