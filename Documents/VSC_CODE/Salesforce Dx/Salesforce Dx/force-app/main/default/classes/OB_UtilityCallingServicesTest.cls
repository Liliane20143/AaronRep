@isTest
global class OB_UtilityCallingServicesTest {

	@testSetup
	public static void setup()
	{
		//	micol.ferrari 17/01/2019
		OB_EnvironmentConfiguration__c environmentConfiguration = new OB_EnvironmentConfiguration__c();
		environmentConfiguration.Name = 'CURRENTORG';
		environmentConfiguration.OB_CurrentOrg__c = 'DEV1';
		insert environmentConfiguration;

		OB_Integration_Configuration__c configuration = new OB_Integration_Configuration__c();
		configuration.Name = 'DEV1';
		configuration.OB_CAsigned_name__c = '';
		configuration.OB_Client_ID__c = '631edaf5-d79a-43b8-8753-1dd64e8e210f';
		configuration.OB_Client_Secret__c = '1b332dad-0b9f-4745-87b1-01c4f5d1a292';
		configuration.OB_Domain__c = 'dev1';
		configuration.OB_Grant_Type__c = 'client_credentials';
		configuration.OB_Timeout_Continuation__c = '30';
		configuration.OB_Timestamp__c = '154392275757575';
		configuration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.Lgw6lqjmOIWy4dPRJmvIyKQBht9BlMDATRylNS1nJGeDePjmvfSxgeZbRzMnu89snNTh9b6SzxsPVUMsgDJ4klsUT81GuFU-sPe4u_zBss5y9jvXe8KwuU5zXDm7ElY_jYUqHKaWaLpCpkfq8UwGcJ_VL7TDJ7m7_eWAc67P';
		configuration.OB_Token_2__c = 'gPl_TKmk2ggdSoRnvQqC9FF2ywLGPtYj_6kKea5esiQlrfmmgtJUy2kcjeUS8YOtxw3X63q-ehEYEvPwQ_eZ9Mpr09DuKtlnOQCsOqBCle60zxNZpiWsyOmmT_Z4Diy2CjaN84u9uIUT-9cea4cdKgEMXTJpqhD5MGHaegt8m-DKKA.pnvamAYqa8kZ_uDcM2tAnQ.ox1twscMrBYAHxrob9WYAgzLu76VDEIKNT5xZgm53kkwmzRqs2lPkBp92';
		configuration.OB_Token_3__c = 'eTSNiQC0mvmjuu2JL0K3h5XLwTUgjHsBW90uAj8oBEnubLcjzb_bQLi5kBTuCmZmIYmVaO3PNl4-RTzWpKcmm6ICa53xxcU_N81mzi_QM9meGrPOOH9YsCJuwPDvacSDg6-XfgHUvqelmSSHKbJBR_-A12b8WjyrFFTHzthFQp36h2Q9kovuYAwukbDTaakh6OOtpxw7zzROB4hM5k2kLRkiNRBg6zslcYytx5tXHnZzZLsZO73cSsD8mG_iRmT';
		configuration.OB_Token_4__c = 'gkR6gY0FEswxXWrbVrGdVtLxNwNctoqwWtxBiDfzJgA30byG0N6TM4IBfnt6c58VtAlqOUpsB_Qm3TbDk4SF3NtGTxOuaT-TgRyWQkt5_Dq-XatnL9W_RtNcnuOruhImP-X6zc9m6lYDQ98TArn-4ADOWpZpB8vOx6-bDrOxr-OG5uQ6V5FymfSZI5K24QXxuiofZzvPfhJzsS_4fpNkCUGPGhQCr_KTmqMMqgmzfRcErX23RRh6uFo0Hm2ohXH';
		configuration.OB_Token_5__c = 'LZTWscVQ1OZl9qDSMA9vFJle-WWxoxhfXdQeD9ePZ41werIqxkf6nZp6sAm3wwKVnSnLVVBstnAXFOTbGfzzX8LQJOrfs8R1jvoOa9ylLpPoBQwdkkR9MeE7pjMAfbebqJh2BX8Xx-MzB5CVkyxPPNchDkidvPUA8UW4EkZQWvDLElUKhAChy9J5TyYkYWvbRgrx4fDgZ5QPZ00-afJYiK1uHfR7botM4xm5hR_04R3XdCCnCicShD2XLN6doaG';
		configuration.OB_Token_6__c = 't6Gzv14CU1S-rN9zA9FCO7PDBywCWfzR2G8tzud0rUq_JnBTBCJFfDu01ki82TR78Od1dbM0iLpVcNJMMEMTFi_Csh3tdXM_yPiE07009WrFiWl29goM8VPlQxbmLmsqg-bWCNAVKZqutqMavqnRjJN2q3EkJbGfut9Ghc0OUae4wXDwbwvh3dijaaftSuaY0xuCVuqbopiPfS4_y5VSztt5gai1rpW0NSO3_D1pSA9Ikvfl1DipbN1tk529J_0';
		configuration.OB_Token_7__c = 'NXsfUdKgf3ADwJPcNPb2pVafkyfqr-R4xn44bnaIuOyG5firipGOROVColCMkwyL0nRYSf40CYG.KpiIzQP0btC54uMB-gvw8Q';

		insert configuration;

		Account merchant = new Account();

		merchant.NE__VAT__c             = '05218600962';
		merchant.NE__Fiscal_code__c     = '05218600962';
		merchant.Name                   = 'STRADIVARIUS ITALIA SRL';
		merchant.OB_Legal_Form__c       = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE'; 
		merchant.NE__E_mail__c          = 'test@gmail.it';
		merchant.OB_Employees_Number__c = 'Minore di 10';
		merchant.OB_Legal_Address_Street__c = 'POLO DELLA QUALITA\' ASI SUD MOD	';
		merchant.OB_Legal_Address_Street_Number__c   = '';
		merchant.OB_Legal_Address_Detail__c   = 'STUDIO DE MATTEIS	';
		merchant.OB_Legal_Address_ZIP__c      = '81025';
		merchant.OB_Legal_Address_City__c     = 'MARCIANISE';
		merchant.OB_Legal_Address_State_Code__c   = '';
		merchant.OB_Legal_Address_Country_Code__c = '';
		merchant.OB_No_Profit_Recipient_Class__c  = 'Senza tetto'; 
		merchant.OB_No_Profit_Class__c            = 'Fondazioni';
		merchant.RecordTypeId                     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
		
		insert merchant;
		Id merchantId    = merchant.id ;
		Id proposerABIId = merchantId; 


		Id rtSedeLegale = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Dati_Societ_Legale').getRecordTypeId();

		List<Contact> contactList = new List<Contact>();
		Contact legalReference  = new Contact();
		legalReference.Phone = '123456765';
		legalReference.Email    = 'contact@gmail.com';
		legalReference.MobilePhone = '56767676';
		legalReference.FirstName = 'RIRI'; 
		legalReference.LastName = 'TOTI' ; 
		legalReference.OB_Sex__c = 'M';
		legalReference.OB_Fiscal_Code__c = 'TTORRI00A01D150K'; 
		legalReference.OB_Document_Release_Authority__c = 'Comune';
		legalReference.OB_Document_Type__c = 'Carta di Identità';
		legalReference.OB_Document_Number__c  = '123erty645';
		legalReference.OB_Birth_Date__c = Date.newInstance(2000, 01, 01);
		legalReference.OB_Document_Expiration_Date__c = Date.newInstance(2029, 01, 01);
		//legalReference.OB_Document_Release_Date__c  =  Date.newInstance(2018, 10, 26);
		legalReference.Fax = '2345456';  
		legalReference.RecordTypeId = rtSedeLegale;

		legalReference.OB_bank__c = proposerABIId ; 
		insert legalReference;

		NE__Service_Point__c sp = new NE__Service_Point__c(	NE__Account__c=merchant.Id,
			Name='TEST SP',
			OB_Status__c='Inactive');
		insert sp;

		List<NE__Order__c> configurations = new List<NE__Order__c> ();
		NE__Order_Header__c oh = new NE__Order_Header__c(NE__AccountId__c=merchantId, OB_ProposerABI__c = merchantId, OB_Main_Process__c='Setup', NE__Type__c='');
		insert oh;
		

		
		NE__Product__c prod = new NE__Product__c(OB_Codice_sfdc__c = '1111');
		insert prod;


		Account acc = new Account(Name = 'test');
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__Fiscal_code__c = '12345678909';
		acc.NE__VAT__c = '67543456789';
		insert acc;


		NE__Billing_Profile__c billProf = new NE__Billing_Profile__c();
		String iban = 'IT26D0511611703000000002340';
		billProf.NE__Iban__c = iban;
		billProf.OB_ABICode__c = '05116';
		billProf.OB_CABCode__c = '11703';
		billProf.OB_CINCode__c = 'D';
		billProf.OB_Bank_Account_Number__c  = '000000002340';
		billProf.OB_EuroControlCode__c  = '26';
		billProf.OB_CountryCode__c = 'IT';
		billProf.OB_BypassValidation__c = false;
		billProf.NE__Account__c = acc.Id;
		insert billProf; 

		NE__Order__c order = new NE__Order__c(  OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO, OB_Service_Point__c = sp.Id, 
			NE__BillingProfId__c = billProf.Id, NE__BillAccId__c = acc.Id, OB_BankAccount_Acquiring__c= billProf.Id );
		order.NE__Order_Header__c = oh.Id;
		configurations.add(order);
		insert configurations;

		NE__OrderItem__c configurationItem  = new NE__OrderItem__c();
		configurationItem.NE__Description__c = 'test';
		configurationItem.NE__Qty__c = 10;
		configurationItem.NE__OrderId__c = configurations[0].Id;
		configurationItem.NE__ProdId__c = prod.Id;
		insert configurationItem;

	}

	
	
	@isTest
	global static void getUnescapeTest()
	{
		
		Test.startTest();	
		OB_UtilityCallingServices.tokenGlobalVar = '123456789';
		String s2 = OB_UtilityCallingServices.getUnescape('new String');
		Test.stopTest();
	}

	//returnCurrentOrg
	@isTest
	global static void returnCurrentOrg_Test()
	{
		Test.startTest();	
		OB_UtilityCallingServices.returnCurrentOrg();
		Test.stopTest();
	}




	@isTest 
	static void getTokenTest (){
		OB_UtilityCallingServices ucs = new OB_UtilityCallingServices();
		ucs.rs = 'test';
		String x = ucs.rs;
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];

		
		String body  ='';
		String token = '';
		//Test.setMock(HttpCalloutMock.class, new OB_MockGetToken());
		Test.setMock(HttpCalloutMock.class, new MockGeneratorOB_UtilityCallingServices());
		Test.startTest();
		Map<String,String> mapTest = OB_UtilityCallingServices.getToken();
		Test.stopTest();
	} 

	
	@isTest
	static void checkTokenTestNew (){
		

		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];

		Test.startTest();
		String error = 'Error';
		//Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		String token = OB_UtilityCallingServices.checkToken();
		
		Test.stopTest(); 
	}
	@isTest static void checkTokenTestValid (){
		Test.startTest();
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		//Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		String token = OB_UtilityCallingServices.checkToken();
		Test.stopTest(); 
	}


	@isTest 
	static void checkToken_Test(){ //OB_Token_1__c = null
		Test.startTest();
		OB_Integration_Configuration__c configuration = new OB_Integration_Configuration__c();
		configuration.Name = 'DEV1';
		configuration.OB_CAsigned_name__c = '';
		configuration.OB_Client_ID__c = '631edaf5-d79a-43b8-8753-1dd64e8e210f';
		configuration.OB_Client_Secret__c = '1b332dad-0b9f-4745-87b1-01c4f5d1a292';
		configuration.OB_Domain__c = 'dev1';
		configuration.OB_Grant_Type__c = 'client_credentials';
		configuration.OB_Timeout_Continuation__c = '30';
		configuration.OB_Timestamp__c = '154392275757575';
		configuration.OB_Token_1__c = null;		
		insert configuration;
		String token = OB_UtilityCallingServices.checkToken();
		Test.stopTest(); 
	}

	

	@isTest static void saveTokenTest (){
		Test.startTest();
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		OB_UtilityCallingServices.saveToken('eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2In0..hxBlok5mj8kgmKAL2_vFvg.MoeN6WM19lzmTQjCWV7jvF86keiHCvl2BlYAPdp5dHCV5a4Iwsc5iISOhampRVi95u5uqGWwo1xd9DUxXvZHTyeS7BZsFzux9OCgEQP-Refq3hIDrdSezq48aiKlZSREj00DJApiu9mKbhdQ06yw4W0yiBdbEQxpCBFkt9BQMfmnFiazLbNMBhKxUPgJJWgiqIurZATVD9LUjWjwMb3dcFiykUn6KJ2jg_X5b6G5dbkm3CeElxlymCm8pBqopt34oXuSs0pMO8F4_0WKAFHoDYhewj2CsPwOBuB1MCx8WIEt56st2mgeFO0zNoce3Fh3sgTwE44N3RDBHsXW3uWUk71kmDDrV-ivmcWmoHJty3EneXh9imfspjkKyz-KJC2Sf9liKGaBW539dguIENajGS4feZcx30yn5vCn7H53FXydRyq2nDLCkJ0lyQWnKzEjEGLB5KxXsJiZzV5xYBY4aVvEQUQ_pufZ-lqE0NxT9WbL8CG69KvTSPiCPxOPL55cbsOuH9OHQGoyW7E3zzeHYm41ry5Z_pqVUYCoWuNzZ_RoqHU1FxthQ729ZAmBU9V6.q_SLSz3CYH8Tw95c0z2_nw',String.valueof(DateTime.now().getTime() + 50000000));
		Test.stopTest();
	}

//--------------------------- callServiceUtilAura & callServiceUtil ------------------------------------------//
	@isTest static void callServiceUtilTest(){
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		HttpRequest req = new HttpRequest();
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockGeneratorOB_UtilityCallingServices());
		OB_UtilityCallingServices.callServiceUtil('http://www.test.com','GET');
		//OB_UtilityCallingServices.callServiceUtilAura('http://www.test.com','GET');

		Test.stopTest(); 
	} 

	@isTest static void callServiceUcampTest(){

		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myMerchant = new Account( Name='TEST', 
			RecordTypeId=rtMerchant, 
			OB_Employees_Number__c='Minore di 10',
			OB_VAT_Not_Present__c=false, 
			NE__VAT__c = '06363391001',
			OB_DescriptionVATNotPresent__c='description', 
			NE__Fiscal_code__c='RSSMRA80A01F205X',
			OB_BypassValidation__c=true,
			OB_Status__c='Active');

		insert myMerchant;
		String token = 'test';
		Test.setMock(HttpCalloutMock.class, new OB_MockUCAMP());
		Test.startTest();
		OB_UtilityCallingServices.callServiceUcamp(myMerchant.NE__VAT__c, token);

		Test.stopTest(); 
	}

	@isTest static void callServiceBlacklistTest(){
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		Id rtMasterMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myMastMerchant = new Account( Name='TEST', 
			RecordTypeId=rtMasterMerchant, 
			OB_Employees_Number__c='Minore di 10',
			OB_VAT_Not_Present__c=false, 
			NE__VAT__c = '06363391001',
			OB_DescriptionVATNotPresent__c='description', 
			NE__Fiscal_code__c='RSSMRA80A01F205X',
			OB_BypassValidation__c=true,
			OB_Status__c='Active');   

		insert myMastMerchant;
		String token = 'test';
		Test.setMock(HttpCalloutMock.class, new OB_MockCallServiceBlacklist());
		Test.startTest();
		OB_UtilityCallingServices.callServiceBlacklist(myMastMerchant.NE__VAT__c, myMastMerchant.NE__Fiscal_code__c, myMastMerchant.NE__Fiscal_code__c, token);

		Test.stopTest(); 
	}

	@isTest static void callTerminalIdTest(){
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		//Test.setMock(HttpCalloutMock.class, new OB_MockGetToken());
		Test.setMock(HttpCalloutMock.class, new MockGeneratorOB_UtilityCallingServices());
		Test.startTest();
		OB_UtilityCallingServices.callTerminalId(true, '', '', '', '', '');

		Test.stopTest();
	}
	@isTest static void callTerminalIdTest2(){
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		//Test.setMock(HttpCalloutMock.class, new OB_MockGetToken());
		Test.setMock(HttpCalloutMock.class, new MockGeneratorOB_UtilityCallingServices());
		Test.startTest();
		OB_UtilityCallingServices.callTerminalId(false, '', '', '', '', '');
		
		Test.stopTest();
	}
	
	@isTest static void callSubmitTest(){
		OB_Integration_Configuration__c configuration = [SELECT Name, OB_CAsigned_name__c, OB_Client_ID__c, 
																OB_Client_Secret__c , OB_Domain__c, OB_Grant_Type__c , 
																OB_Timeout_Continuation__c, OB_Timestamp__c, 
																OB_Token_1__c, OB_Token_2__c, OB_Token_3__c, 
																OB_Token_4__c, OB_Token_5__c, OB_Token_6__c, 
																OB_Token_7__c
														FROM OB_Integration_Configuration__c
														LIMIT 1];
		Id orderHeaderId =  [SELECT Id FROM NE__Order_Header__c LIMIT 1].Id;
		Test.setMock(HttpCalloutMock.class, new OB_MockCallSubmit());
		Test.startTest();
		OB_UtilityCallingServices.callSubmit(orderHeaderId);

		Test.stopTest();
	}
	
	@isTest static void encryptionValuesTest(){
		Test.startTest();
		OB_UtilityCallingServices.encryptionValues('test');
		Test.stopTest();
	}
	
	@isTest static void sendEmailTest(){
		Id orderHeaderId =  [SELECT Id FROM NE__Order_Header__c LIMIT 1].Id;

		Test.startTest();
		OB_UtilityCallingServices.sendEmail(orderHeaderId);
		Test.stopTest();
	}

	@isTest static void getClientTypeSetTest(){

		Test.startTest();

		Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		NE__Order_Header__c oh = new NE__Order_Header__c();
		insert oh;
		NE__Order__c o = new NE__Order__c(NE__Order_Header__c = oh.id, OB_MCC__c='7932');
		insert o;
		NE__Product__c prod = new NE__Product__c(OB_Codice_sfdc__c = '1111', NE__Engine_Code__c = '');
		insert prod;
		List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c>();
		NE__OrderItem__c itemFather  = new NE__OrderItem__c(NE__OrderId__c = o.Id, NE__Qty__c = 1);
		insert itemFather;
		NE__OrderItem__c oi1 = new NE__OrderItem__c(NE__OrderId__c = o.id, NE__Qty__c = 3, NE__ProdId__c = prod.id,NE__Parent_Order_Item__c = itemFather.id);
		NE__OrderItem__c oi2 = new NE__OrderItem__c(NE__OrderId__c = o.id, NE__Qty__c = 2, NE__ProdId__c = prod.id);
		NE__OrderItem__c oi3 = new NE__OrderItem__c(NE__OrderId__c = o.id, NE__Qty__c = 1, NE__ProdId__c = prod.id);
		orderItems.add(oi1);
		orderItems.add(oi2);
		orderItems.add(oi3);
		insert orderItems;
		System.debug('orderItems ----> ' +orderItems);
		System.debug('product   ----> ' +prod);

		Account myMerchant = new Account( Name='TEST', 
			RecordTypeId				  = rtMerchant, 
			OB_Employees_Number__c		  ='Minore di 10',
			OB_VAT_Not_Present__c		  =false, 
			NE__VAT__c 					  = '06363391001',
			OB_DescriptionVATNotPresent__c ='description', 
			NE__Fiscal_code__c			  = 'RSSMRA80A01F205X',
			OB_BypassValidation__c		  = true,
			OB_Status__c				  = 'Active',
			OB_Legal_Form__c 			  = 'ASD (associazioni sportive dilettantistiche)',
			OB_ATECO__c 				  = '920' ,
			OB_IsCrowdfunding__c   = true);
		insert myMerchant;

		Account bank = new Account();
		bank.Name 					= 'bank'; 
		bank.NE__VAT__c 			= '12345678901'; 
		bank.OB_Employees_Number__c = 'Minore di 10';
		bank.NE__Fiscal_code__c     = 'AAAAAA11A11A111A';
		bank.OB_ABI__c       		= '05116';
		bank.OB_IsCrowdfunding__c   = true;
		bank.RecordTypeId 			= [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank'].id;
		insert bank;

		OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
		bp.OB_Bank__c = bank.Id;
		bp.OB_Service_Type__c 				   = 'Acquiring'; 
		bp.OB_Business_Model_POS__c 		   = 'Bilaterale'; 
		bp.OB_Circuit__c				 	   = 'JCB'; 
		bp.OB_Other_Acquirer__c 		       = 'Amex';
		bp.OB_Applicant_RAC_Code_SIA__c 	   = 'Banca'; 
		bp.OB_Terminal_Id_Generator__c 		   = 'Banca'; 
		bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
		bp.OB_GT__c 						   = 'Nexi'; 
		bp.OB_Processor__c 					   = 'SIA SMAC'; 
		bp.OB_Bilateral_Pricing__c 			   = 'SI'; 
		bp.OB_Sending_Contract_to_Nexi__c 	   = 'SI'; 
		bp.OB_SME_Factory__c 				   = 'SI';
		bp.OB_UploadSignedContract__c 		   = true;
		insert bp;

		List<OB_Bank_Profile__c> listBankProfile = new List<OB_Bank_Profile__c> ();
		listBankProfile.add(bp);

		List<String> listOfLogRequestTypes = new List<String>();
		listOfLogRequestTypes.add('OB_MAINTENANCE_CHANGEMERCHANTNAME');
		listOfLogRequestTypes.add('OB_MAINTENANCE_CHANGELEGALFORM');

	

		Id  formaGiuridica = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_FORMA_GIURIDICA').getRecordTypeId();
		Id  noVat = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_DESCRIPTION_NO_VAT').getRecordTypeId();
		Id  crowd = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_CROWDFUNDING').getRecordTypeId();
		Id  prodActive = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_PRODUCT_ACTIVATION').getRecordTypeId();
		Id  prodActiveFormaGiu = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_PRODUCT_ACTIVATION_FORMA_GIURIDICA').getRecordTypeId();
		Id  prodActiveNOTFormaGiu = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_PRODUCT_ACTIVATION_NOT_FORMA_GIURIDICA').getRecordTypeId();
		Id  mccORateco = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_MCC_OR_ATECO').getRecordTypeId();
		Id  mccORatecoFormaGiu = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_MCC_OR_ATECO_FORMA_GIURIDICA').getRecordTypeId();
		Id  prodEnab = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_PRODUCT_ENABLEMENT').getRecordTypeId();
		Id  contrFirmEnabled = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_UPLOAD_CONTRATTO_FIRMATO_MAINTENANCE').getRecordTypeId();
		Id  contrFirmSetup = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('OB_UPLOAD_CONTRATTO_FIRMATO_SETUP').getRecordTypeId();
		//CAMBIO_DENOMINAZIONE_SOCIALE
		Id  cambioDenminazioneSoc = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('CAMBIO_DENOMINAZIONE_SOCIALE').getRecordTypeId();
		//CAMBIO_FORMA_GIURIDICA
		Id  cambioFormaGiuridica = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('CAMBIO_FORMA_GIURIDICA').getRecordTypeId();
		//CAMBIO_ESECUTORE
		Id  cambioEsecutore      = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName().get('CAMBIO_ESECUTORE').getRecordTypeId();

		OB_Special_Category_Configuration__c spCat1 = new OB_Special_Category_Configuration__c( Name = 'ASD (associazioni sportive dilettantistiche)',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'DITTA_INDIVIDUALE',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = formaGiuridica);

		OB_Special_Category_Configuration__c spCat2 = new OB_Special_Category_Configuration__c( Name = 'B&B senza p.iva',
			OB_ATECO__c = '',
			//OB_DescriptionNoVat__c = 'BED & BREAKFAST',
			OB_DescriptionNoVat__c   = myMerchant.OB_DescriptionVATNotPresent__c,
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = '',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = noVat);

		OB_Special_Category_Configuration__c spCat3 = new OB_Special_Category_Configuration__c( Name = 'Crowdfunding',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = true,
			OB_Legal_Form__c = '',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = crowd);

		OB_Special_Category_Configuration__c spCat4 = new OB_Special_Category_Configuration__c( Name = 'eCommerce',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = '',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = prodActive);

		OB_Special_Category_Configuration__c spCat5 = new OB_Special_Category_Configuration__c( Name = 'eCommerce Lavoratore autonomo',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'DITTA_INDIVIDUALE',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = prodActiveFormaGiu);

		OB_Special_Category_Configuration__c spCat6 = new OB_Special_Category_Configuration__c( Name = 'eCommerce No Lavoratore autonomo',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'LAV_AUTONOMO',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = prodActiveNOTFormaGiu);

		OB_Special_Category_Configuration__c spCat7 = new OB_Special_Category_Configuration__c( Name = 'Gambling',
			OB_ATECO__c = 'Gambling',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = '',
			OB_MCC__c = 'Gambling',
			OB_OrderHeader__c = 'OB_Gambling__c',
			OB_RequestType__c = 'Setup',
			RecordTypeId = mccORateco);

		OB_Special_Category_Configuration__c spCat8 = new OB_Special_Category_Configuration__c( Name = 'Gambling - Non Ditta individuale',
			OB_ATECO__c = 'Gambling',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'DITTA_INDIVIDUALE',
			OB_MCC__c = 'Gambling',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = mccORatecoFormaGiu);

		OB_Special_Category_Configuration__c spCat9 = new OB_Special_Category_Configuration__c( Name = 'MOTO',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = '',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = prodActive);

		OB_Special_Category_Configuration__c spCat10 = new OB_Special_Category_Configuration__c( Name = 'MOTO Lavoratore autonomo',	
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'LAV_AUTONOMO',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = prodActiveFormaGiu);

		OB_Special_Category_Configuration__c spCat11 = new OB_Special_Category_Configuration__c( Name = 'MOTO No Lavoratore autonomo',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'LAV_AUTONOMO',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = prodActiveNOTFormaGiu);

		OB_Special_Category_Configuration__c spCat12 = new OB_Special_Category_Configuration__c( Name = 'Onlus',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'ORG_NO_PROFIT',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = formaGiuridica);

		OB_Special_Category_Configuration__c spCat13 = new OB_Special_Category_Configuration__c( Name = 'Preautorizzazione',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = prod.id,
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = '',
			OB_MCC__c = '',
			OB_OrderHeader__c = 'OB_PreAuth__c',
			OB_RequestType__c = 'Maintenance',
			RecordTypeId = prodEnab);

		OB_Special_Category_Configuration__c spCat14 = new OB_Special_Category_Configuration__c(Name = 'Servizio distintivo Albergo/Autonoleggi',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = '',
			OB_MCC__c = '',
			OB_OrderHeader__c = 'OB_HotelCarRental__c',
			OB_RequestType__c = 'Maintenance',
			RecordTypeId = prodEnab);

		OB_Special_Category_Configuration__c spCat15 = new OB_Special_Category_Configuration__c( Name = 'SSD (società sportive dilettantistiche)',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'SSD',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = formaGiuridica);

		OB_Special_Category_Configuration__c spCat16 = new OB_Special_Category_Configuration__c( Name = 'SSD (società sportive dilettantistiche)',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'SSD',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = OB_UtilityConstants.MAINTENANCE,
			RecordTypeId = contrFirmEnabled);

		OB_Special_Category_Configuration__c spCat17 = new OB_Special_Category_Configuration__c( Name = 'SSD (società sportive dilettantistiche)',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'SSD',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = contrFirmSetup);

		OB_Special_Category_Configuration__c spCat18 = new OB_Special_Category_Configuration__c( Name = 'SSD (società sportive dilettantistiche)',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'SSD',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = cambioDenminazioneSoc);

		OB_Special_Category_Configuration__c spCat19 = new OB_Special_Category_Configuration__c( Name = 'SSD (società sportive dilettantistiche)',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'SSD',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = cambioFormaGiuridica);

		OB_Special_Category_Configuration__c spCat20 = new OB_Special_Category_Configuration__c( Name = 'SSD (società sportive dilettantistiche)',
			OB_ATECO__c = '',
			OB_DescriptionNoVat__c = '',
			OB_EngineCodeCommercialProduct__c = '',
			OB_isCrowdfunding__c = false,
			OB_Legal_Form__c = 'SSD',
			OB_MCC__c = '',
			OB_OrderHeader__c = '',
			OB_RequestType__c = '',
			RecordTypeId = cambioEsecutore);	
			
		List<OB_Special_Category_Configuration__c> listToFilter = new List<OB_Special_Category_Configuration__c>();
		listToFilter.add(spCat1);
		listToFilter.add(spCat2);
		listToFilter.add(spCat3);
		listToFilter.add(spCat4);
		listToFilter.add(spCat5);
		listToFilter.add(spCat6);
		listToFilter.add(spCat7);
		listToFilter.add(spCat8);
		listToFilter.add(spCat9);
		listToFilter.add(spCat10);
		listToFilter.add(spCat11);
		listToFilter.add(spCat12);
		listToFilter.add(spCat13);
		listToFilter.add(spCat14);
		listToFilter.add(spCat15);
		listToFilter.add(spCat16);
		listToFilter.add(spCat17);
		listToFilter.add(spCat18);
		listToFilter.add(spCat19);
		listToFilter.add(spCat20);


		insert listToFilter;
		List<OB_Special_Category_Configuration__c> listToFilter1 = [SELECT Name,OB_ATECO__c,OB_Commercial_Product__c,
		OB_DocRequired__c,OB_isCrowdfunding__c,OB_DescriptionNoVat__c,
		OB_Legal_Form__c,OB_MCC__c,RecordType.DeveloperName,OB_EngineCodeCommercialProduct__c,OB_RequestType__c
		FROM OB_Special_Category_Configuration__c];
		System.debug('*********** recTypeDevName: '+listToFilter1);

		String legalForm = myMerchant.OB_Legal_Form__c;
		String merchantId = myMerchant.Id;
		String ateco = myMerchant.OB_ATECO__c;
		String mcc = o.OB_MCC__c;
		
		NE__Lov__c mccLov = new NE__Lov__c ();
		mccLov.NE__Type__c    ='MCC';
		mccLov.NE__Active__c  =true;
		mccLov.NE__Value3__c = 'L3';
		mccLov.NE__Value2__c  = mcc;
		mccLov.NE__Value1__c  = 'Gambling';
		insert mccLov;

		NE__Lov__c atecoLov = new NE__Lov__c();
		atecoLov.NE__Type__c ='ATECO';
		atecoLov.NE__Active__c = true;
		atecoLov.Name = myMerchant.OB_ATECO__c;
		atecoLov.NE__Value3__c = 'Gambling';
		insert atecoLov;

		NE__Lov__c legalFormLov = new NE__Lov__c();
		legalFormLov.NE__Type__c ='LegalForm';
		legalFormLov.NE__Active__c =true;
		legalFormLov.Name = 'ASD (associazioni sportive dilettantistiche)';
		//legalFormLov.NE__Value1__c = 'ASD';
		legalFormLov.NE__Value1__c = 'DITTA_INDIVIDUALE';
		insert legalFormLov;
		
		//Set<String> getClientTypeSet (List<OB_Special_Category_Configuration__c> listToFilter,List<NE__OrderItem__c> orderItems,String mcc, String ateco, String legalForm, String merchantId, List<String> listOfLogRequestTypes,String abi,String mainProcess)
		OB_UtilityCallingServices.getClientTypeSet(listToFilter1, orderItems, mcc, ateco, legalForm, merchantId, listOfLogRequestTypes, '05116','Setup');
		OB_UtilityCallingServices.getClientTypeSet(listToFilter1, orderItems, '5236', '93.29.30', 'Lavoratore autonomo', merchantId, null, '05116','Setup');
		OB_UtilityCallingServices.getClientTypeSet(listToFilter1, orderItems, '5236', '93.29.30', 'LAV_AUTONOMO', merchantId, null, '05116','Setup');
		Test.stopTest();
	}

	// //welcomeLetter
	// @isTest static void welcomeLetter_Test(){

	// 	Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
	// 	Id recordTypeIdBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.BANKRT).getRecordTypeId();

	// 	Account bank = new Account();
	// 	bank.Name = 'bank';
	// 	bank.RecordTypeId = recordTypeIdBank;
	// 	bank.OB_ABI__c    = '05116';
	// 	insert bank;

	// 	Account merchant = new Account( Name='TEST', 
	// 									RecordTypeId 				 = rtMerchant, 
	// 									OB_Employees_Number__c		 ='Minore di 10',
	// 									OB_VAT_Not_Present__c		 =false, 
	// 									NE__VAT__c 					 = '06363391001',
	// 									OB_DescriptionVATNotPresent__c='description', 
	// 									NE__Fiscal_code__c			  ='RSSMRA80A01F205X',
	// 									OB_BypassValidation__c		  = true,
	// 									OB_Status__c				  ='Active',
	// 									OB_ABI__c                     = '05116',
	// 									OB_Bank_owner__c              = bank.id);
	// 	insert merchant;

	// 	NE__Order_Header__c oh = new NE__Order_Header__c();
	// 	oh.OB_Main_Process__c = 'Setup';
	// 	oh.NE__Type__c        = 'ChangeOrder';
	// 	oh.OB_NDG__c          = '123_Stella'; 
	// 	oh.NE__AccountId__c   = merchant.id;
	// 	oh.OB_ProposerABI__c  = merchant.id; 
	// 	oh.OB_Business_Model_Acquiring__c = 'Bancario';
	// 	oh.OB_Business_Model_POS__c       = 'Trilaterale Nuovo';
	// 	insert oh;
	// 	NE__Order__c o = new NE__Order__c(NE__Order_Header__c = oh.id, OB_MCC__c='7932');
	// 	insert o;

		
	// 	NE__Service_Point__c salePoint = new NE__Service_Point__c(	NE__Account__c = merchant.Id,
	// 																Name='TEST SP',
	// 																OB_Status__c = 'Inactive');
	// 	insert salePoint;
		
	// 	Test.startTest();
	// 	OB_UtilityCallingServices.welcomeLetter(oh.id, o.id,merchant.id , salePoint.id );
	// 	Test.stopTest();
	// }

	//createAsset
	@isTest static void createAsset_Test(){

		NE__Order_Header__c oh = new NE__Order_Header__c();
		oh.OB_Main_Process__c = 'Setup';
		oh.NE__Type__c        = 'ChangeOrder';
		insert oh;
		NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id, OB_MCC__c='7932');
		insert ord;

		Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account merchant = new Account( Name='TEST', 
			RecordTypeId=rtMerchant, 
			OB_Employees_Number__c='Minore di 10',
			OB_VAT_Not_Present__c=false, 
			NE__VAT__c = '06363391001',
			OB_DescriptionVATNotPresent__c='description', 
			NE__Fiscal_code__c='RSSMRA80A01F205X',
			OB_BypassValidation__c=true,
			OB_Status__c='Active');
		insert merchant;

		Asset myAsset 	= new Asset(AccountId     = merchant.Id,
									Name          ='TEST',
									NE__Status__c ='Disconnected');
		myAsset.NE__Status__c 	= 'Active';
		insert myAsset;
		
		
		NE__Service_Point__c salePoint = new NE__Service_Point__c(	NE__Account__c=merchant.Id,
															Name='TEST SP',
															OB_Status__c='Inactive');
		insert salePoint;
		NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=ord.id, NE__Action__c = 'Add');
		insert orderItem;		
		NE__OrderItem__c orderItem1 = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=ord.id, NE__Action__c = 'Remove');
		orderItem1.NE__AssetItemEnterpriseId__c = myAsset.id;
		insert orderItem1;
		List<NE__OrderItem__c> allLineItems = new List<NE__OrderItem__c>();
		allLineItems.add(orderItem);
		allLineItems.add(orderItem1);
		

		Asset ass = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
        //ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = merchant.id;
        //ass.OB_DebitProfId__c               = bp.id;
		//ass.OB_ProposerABI__c               = merchant.id;
        ass.IsCompetitorProduct             = false;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = orderItem.id;
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = merchant.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        //ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = merchant.id;
        ass.NE__Service_Point__c            = salePoint.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'MANVACA';
        ass.OB_CustomerCode__c              = '1016918';
        ass.OB_TermId__c                    = '01883677';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
    	insert ass;														
		List<Asset> assets = new List<Asset> ();
		assets.add(ass);
		assets.add(myAsset);

		Test.startTest();
		OB_UtilityCallingServices.createAsset( ord.id, 'Setup');
		Test.stopTest();
	}

	//createShare
	@isTest 
	static void createShare_Test(){
		Map<String, Object> bankAccountMap = new Map<String, Object>();
		 NE__Order_Header__c orh = new  NE__Order_Header__c();
		orh.OB_Main_Process__c = 'Setup';
		orh.NE__Type__c        = 'ChangeOrder';
		orh.OB_ABI__c          = '05696';
		insert orh;
		NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = orh.id, OB_MCC__c='7932', OB_ABI__c = '05116');
		insert ord;
		
		 Account acc = new Account();
		 Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account merchant = new Account( Name       			   ='TEST', 
										RecordTypeId 		   = rtMerchant, 
										OB_Employees_Number__c = 'Minore di 10',
										OB_VAT_Not_Present__c  = false, 
										NE__VAT__c             = '06363391001',
										OB_DescriptionVATNotPresent__c='description', 
										NE__Fiscal_code__c     ='RSSMRA80A01F205X',
										OB_BypassValidation__c = true,
										OB_Status__c           = 'Active',
										OB_ABI__c              = orh.OB_ABI__c);
		insert merchant;
		List<Account> listOfBanks	= new List<Account>();
		listOfBanks.add(merchant);
		bankAccountMap.put('OB_ABI__c', orh.OB_ABI__c);
		System.debug('bankAccountMap test ::>> ' +bankAccountMap);

		NE__Service_Point__c sp = new NE__Service_Point__c();
		sp.NE__Account__c = merchant.Id;
		sp.Name  		  ='TEST SP';
		sp.OB_Status__c	  ='Inactive';
		 insert sp;

		Test.startTest();
		OB_UtilityCallingServices.createShare( bankAccountMap, orh, sp, merchant, false);
		OB_UtilityCallingServices.createShare( bankAccountMap, orh, sp, merchant, true);
		Test.stopTest();
	}


	
	
	
	
}