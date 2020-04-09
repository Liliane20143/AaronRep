@isTest
public class OB_Serialize_Order_Test
{
	Map<String, Map<String, String>> decodeValues = new Map<String, Map<String, String>>( );

    /*******************************************************************************
    Purpose:  Method inserts test lovs
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-121
    ********************************************************************************/
	private static void prepareAndInsertTestLovs( )
	{
		List<NE__Lov__c> testLovList = new List<NE__Lov__c>( );
		testLovList.add( OB_Serialize_Order_Test.prepareTestLov( OB_UtilityConstants.DITTA_INDIVIDUALE, OB_UtilityConstants.DITTA_INDIVIDUALE_CODE, OB_UtilityConstants.TYPE_LEGALFORM ) );
		testLovList.add( OB_Serialize_Order_Test.prepareTestLov( OB_UtilityConstants.ORG_NO_PROFIT, OB_UtilityConstants.ORG_NO_PROFIT_CODE, OB_UtilityConstants.TYPE_LEGALFORM ) );
		insert testLovList;
	}

	/*******************************************************************************
    Purpose:  Method to create lov object with given parameters
    Parameters: String name, String value1, String type
    Returns: NE__Lov__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-121
    ********************************************************************************/
	private static NE__Lov__c prepareTestLov( String name, String value1, String type )
	{
		NE__Lov__c testLov = OB_TestDataFactory.getLov( );
		testLov.Name = name;
		testLov.NE__Value1__c = value1;
		testLov.NE__Type__c = type;
		return testLov;
	}
	/*******************************************************************************
	Purpose:  Method to create test data for checking legal form code
	Parameters: -
	Returns: Map<String,String>

	Historys
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Damian Krzyzaniak       17/07/2019      Created         NEXI-121
	********************************************************************************/
	private static Map<String, String> prepareDataForCheckForEmptyLegalFormCode( )
	{

		String action = 'action test' ;
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.NE__E_mail__c = 'test@null.it';
		testAccount.OB_VAT_Not_Present__c = false;
		insert testAccount;

		Id recordTypeBankId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId( );
		Account testBank = OB_TestDataFactory.getAccount( );
		testBank.RecordTypeId = recordTypeBankId;
		testBank.Name = 'bank';
		insert testBank;

		Account merchant = OB_TestDataFactory.getAccount( );

		merchant.OB_Legal_Form__c = OB_UtilityConstants.ORG_NO_PROFIT;
		merchant.NE__E_mail__c = 'test@gmail.it';
		merchant.OB_No_Profit_Recipient_Class__c = 'Senza tetto';
		merchant.OB_No_Profit_Class__c = 'Fondazioni';
		merchant.OB_Year_constitution_company__c = 2000;
		merchant.OB_Bank_owner__c = testBank.id;
		merchant.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
		insert merchant;

		NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( testBank.Id );
		insert testBillingProfile;

		Id recordTypeDSLId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId( );
		Contact testContact = OB_TestDataFactory.getContact( merchant );
		testContact.RecordTypeId = recordTypeDSLId;
		testContact.OB_Bank__c = testBank.id;
		insert testContact;

		List<Contact> contactList = new List<Contact>( );
		Contact legalReference = OB_TestDataFactory.getContact( merchant );
		legalReference.Phone = '123456765';
		legalReference.Email = 'contact@gmail.com';
		legalReference.MobilePhone = '56767676';
		legalReference.LastName = 'contact lastname' ;
		legalReference.Fax = '2345456';
		contactList.add( legalReference );
		insert contactList;

		Contract testContract = OB_TestDataFactory.getContract( merchant.Id );
		testContract.StartDate = Date.newInstance( 2018, 05, 31 );
		testContract.Status = 'Draft';
		insert testContract;

		NE__Order__c testOrderWithDate = OB_TestDataFactory.getOrder( );
		testOrderWithDate.NE__Order_date__c = date.newinstance( 1960, 2, 17 );
		insert testOrderWithDate;
		NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
		orderHeader.NE__AccountId__c = merchant.Id;
		orderHeader.NE__OrderId__c = testOrderWithDate.Id;
		orderHeader.OB_ProposerABI__c = testBank.Id;

		insert orderHeader;

		NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
		testOrder.NE__Order_Header__c = orderHeader.Id;
		testOrder.NE__BillingProfId__c = testBillingProfile.Id;
		testOrder.NE__BillAccId__c = testBank.Id;
		testOrder.OB_BankAccount_Acquiring__c = testBillingProfile.Id;
		insert testOrder;

		NE__OrderItem__c testItem = OB_TestDataFactory.getorderitem( testOrder.Id );
		insert testItem;
		List<String> recordTypesDevName = new List<String> {'Terminali', 'Gateway_Virtuale', 'Moto', 'eCommerce', 'Acquiring', 'Pagobancomat', 'Vas', 'PCI', 'Integrazione'};
		List<NE__Product__c> productsList = new List<NE__Product__c>( );

		for ( RecordType recItem : [ SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName IN :recordTypesDevName ] )
		{
			NE__Product__c tmp_product = OB_TestDataFactory.getProduct( );
			tmp_product.RecordTypeId = recItem.id;
			productsList.add( tmp_product );
		}
		insert productsList;

		Id pricingRecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1 ].id;

		NE__Product__c pricingProduct = OB_TestDataFactory.getProduct( );
		pricingProduct.RecordTypeId = pricingRecordTypeId;
		List<NE__OrderItem__c> itemsList = new List<NE__OrderItem__c>( );
		for ( NE__Product__c prod : productsList )
		{
			NE__OrderItem__c tmp_orderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
			tmp_orderItem.NE__ProdId__c = prod.id;
			itemsList.add( tmp_orderItem );
		}

		List<NE__OrderItem__c> childItemList = new List<NE__OrderItem__c>( );

		insert itemsList;
		for ( NE__OrderItem__c itemm : itemsList )
		{
			NE__OrderItem__c tmp_orderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
			tmp_orderItem.NE__ProdId__c = pricingProduct.id;
			tmp_orderItem.NE__Parent_Order_Item__c = itemm.id;
			childItemList.add( tmp_orderItem );
		}
		insert childItemList;

		Map<String, String> dataMap = new Map<String, String>( );
		dataMap.put( 'merchantId', merchant.Id );
		dataMap.put( 'orderHeaderId', orderHeader.Id );
		dataMap.put( 'orderId', testOrderWithDate.Id );
        dataMap.put( 'merchant', JSON.serialize(merchant)); // antonio.vatrano 23/09/2019 wn-448
		return dataMap;
	}

	@isTest
	public static void OB_Serialize_OrderTest( )
	{
		List<NE__Lov__c> testLovList = new List<NE__Lov__c>( );
		NE__Lov__c lov1 = new NE__Lov__c( );
		lov1.NE__Value1__c = 'value1_1';
		lov1.NE__Value2__c = 'value1_2';
		lov1.Name = 'Lov name';
		lov1.NE__Sub_Type__c = 'TIPOLOGICHE';
		lov1.NE__Type__c = 'SUBMIT';
		testLovList.add( lov1 );
		NE__Lov__c lov2 = new NE__Lov__c( );
		lov2.NE__Value1__c = 'value2_1';
		lov2.NE__Value2__c = 'value2_2';
		lov2.Name = 'Lov name';
		lov2.NE__Sub_Type__c = 'TIPOLOGICHE';
		lov2.NE__Type__c = 'SUBMIT';
		testLovList.add( lov2 );
		insert testLovList;

		Map<String, Map<String, String>> expectedEqualsResult = new Map<String, Map<String, String>>( );
		Map<String, String> tempMap = new Map<String, String>( );
		tempMap.put( lov1.NE__Value1__c, lov1.NE__Value2__c );
		tempMap.put( lov2.NE__Value1__c, lov2.NE__Value2__c );
		expectedEqualsResult.put( testLovList[ 0 ].Name, tempMap );

		Map<String, Map<String, String>> expectedNotEqualsResult = new Map<String, Map<String, String>>( );
		Map<String, String> tempMap1 = new Map<String, String>( );
		expectedNotEqualsResult.put( 'wrong', tempMap1 );

		Test.startTest( );
		OB_Serialize_Order OB_so = new OB_Serialize_Order( );
		Test.stopTest( );
		System.assertEquals( expectedEqualsResult, OB_Serialize_Order.decodeValues );
		System.assertNotEquals( expectedNotEqualsResult, OB_Serialize_Order.decodeValues );
	}

	@isTest
	public static void decodeValTest1( )
	{
		List<NE__Lov__c> testLovList = new List<NE__Lov__c>( );
		NE__Lov__c lov1 = new NE__Lov__c( );
		lov1.NE__Value1__c = 'value1_1';
		lov1.NE__Value2__c = 'value1_2';
		lov1.Name = 'Lov name';
		lov1.NE__Sub_Type__c = 'TIPOLOGICHE';
		lov1.NE__Type__c = 'SUBMIT';
		testLovList.add( lov1 );
		NE__Lov__c lov2 = new NE__Lov__c( );
		lov2.NE__Value1__c = 'value2_1';
		lov2.NE__Value2__c = 'value2_2';
		lov2.Name = 'Lov name';
		lov2.NE__Sub_Type__c = 'TIPOLOGICHE';
		lov2.NE__Type__c = 'SUBMIT';
		testLovList.add( lov2 );
		insert testLovList;
		String fieldName = 'Lov name';
		String fiedValue = lov1.Name;

		OB_Serialize_Order OB_so = new OB_Serialize_Order( );
		System.assertEquals( fieldName, OB_Serialize_Order.decodeVal( fieldName, fiedValue ) );
	}

	@isTest
	public static void decodeValTest2( )
	{
		NE__Lov__c testLov = new NE__Lov__c( );
		testLov.NE__Sub_Type__c = 'TIPOLOGICHE';
		testLov.NE__Type__c = 'SUBMIT';
		testLov.Name = 'COUNTRY';
		insert testLov;
		String fieldName = 'Name';
		String fieldValue = testLov.Name;

		System.assertNotEquals( fieldName, OB_Serialize_Order.decodeVal( fieldName, fieldValue ) );
		System.assertEquals( testLov.Name, OB_Serialize_Order.decodeVal( fieldName, fieldValue ) );
	}

	@isTest
	public static void decodeValTest3( )
	{
		List<NE__Lov__c> testLovList = new List<NE__Lov__c>( );
		NE__Lov__c lov1 = new NE__Lov__c( );
		lov1.NE__Value1__c = 'value1_1';
		lov1.NE__Value2__c = 'value1_2';
		lov1.Name = 'Lov name';
		lov1.NE__Sub_Type__c = 'TIPOLOGICHE';
		lov1.NE__Type__c = 'SUBMIT';
		testLovList.add( lov1 );
		NE__Lov__c lov2 = new NE__Lov__c( );
		lov2.NE__Value1__c = 'value2_1';
		lov2.NE__Value2__c = 'value2_2';
		lov2.Name = 'Lov name';
		lov2.NE__Sub_Type__c = 'TIPOLOGICHE';
		lov2.NE__Type__c = 'SUBMIT';
		testLovList.add( lov2 );
		insert testLovList;
		String fieldName = 'Lov name';
		String fieldValue = 'value1_1';
		Test.startTest( );
		OB_Serialize_Order OB_so = new OB_Serialize_Order( );
		OB_Serialize_Order.decodeVal( fieldName, fieldValue );
		Test.stopTest( );
		System.assertEquals( 'value1_2', OB_Serialize_Order.decodeVal( fieldName, fieldValue ) );
	}

	@isTest
	public static void serializeDateTest( )
	{
		Date dt = Date.newInstance( 1960, 2, 17 );
		String expectResult = '1960-02-17';
		String unexpectResult = '2022-05-10';

		Test.startTest( );
		String result = OB_Serialize_Order.serializeDate( dt );
		Test.stopTest( );
		System.assertEquals( expectResult, result );
		System.assertNotEquals( unexpectResult, result );
	}

	@isTest
	public static void serializeDateWhenNoDateTest( )
	{
		Date dt = null;

		Test.startTest( );
		String result = OB_Serialize_Order.serializeDate( dt );
		Test.stopTest( );
		System.assertEquals( null, result );
	}

	@isTest
	public static void serializeTimeTest( )
	{
		Time tm = Time.newInstance( 1, 2, 4, 400 );
		String expectResult = '01:02';
		String unexpectResult = '23:45';

		Test.startTest( );
		String result = OB_Serialize_Order.serializeTime( tm );
		Test.stopTest( );
		System.assertEquals( expectResult, result );
		System.assertNotEquals( unexpectResult, result );
	}

	@isTest
	public static void serializeTimeWhenNoTime( )
	{
		Time tm = null;

		Test.startTest( );
		String result = OB_Serialize_Order.serializeTime( tm );
		Test.stopTest( );
		System.assertEquals( null, result );
	}

	@isTest
	public static void serializeDateWhenParametrIsDataTime( )
	{
		Datetime dt = Datetime.newInstance( Date.newInstance( 1960, 2, 17 ), Time.newInstance( 1, 2, 4, 400 ) );
		String expectResult = '1960-02-17';
		String unexpectResult = '1999-02-10';

		Test.startTest( );
		String result = OB_Serialize_Order.serializeDate( dt );
		Test.stopTest( );
		System.assertEquals( expectResult, result );
		System.assertNotEquals( unexpectResult, result );
	}

	@isTest
	public static void serializeDateWhenInvalidParametrDataTime( )
	{
		Datetime dt = null;

		Test.startTest( );
		String result = OB_Serialize_Order.serializeDate( dt );
		Test.stopTest( );
		System.assertEquals( null, result );
	}

	@isTest
	public static void serializeOrder_Test1( )
	{
		OB_Serialize_Order_Test.prepareAndInsertTestLovs( ); //NEXI-121 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> 17.07.2019
		String action = 'action test' ;
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.NE__E_mail__c = 'test@null.it';
		testAccount.OB_VAT_Not_Present__c = false;
		insert testAccount;

		Id recordTypeBankId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId( );
		Account bank = new Account( );
		bank.RecordTypeId = recordTypeBankId;
		bank.Name = 'bank';
		insert bank;

		Account merchant = new Account( );

		merchant.NE__VAT__c = '05218600962';
		merchant.NE__Fiscal_code__c = '05218600962';
		merchant.Name = 'STRADIVARIUS ITALIA SRL';
		merchant.OB_Legal_Form__c = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE';
		merchant.NE__E_mail__c = 'test@gmail.it';
		merchant.OB_Employees_Number__c = 'Minore di 10';
		merchant.OB_Legal_Address_Street__c = 'POLO DELLA QUALITA\' ASI SUD MOD	';
		merchant.OB_Legal_Address_Street_Number__c = '';
		merchant.OB_Legal_Address_Detail__c = 'STUDIO DE MATTEIS	';
		merchant.OB_Legal_Address_ZIP__c = '81025';
		merchant.OB_Legal_Address_City__c = 'MARCIANISE';
		merchant.OB_Legal_Address_State_Code__c = '';
		merchant.OB_Legal_Address_Country_Code__c = '';
		merchant.OB_No_Profit_Recipient_Class__c = 'Senza tetto';
		merchant.OB_No_Profit_Class__c = 'Fondazioni';
		merchant.OB_Year_constitution_company__c = 2000;
		merchant.OB_Bank_owner__c = bank.id;
		merchant.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
		insert merchant;

		NE__Billing_Profile__c bp = new NE__Billing_Profile__c( );
		bp.NE__Account__c = bank.id;
		insert bp;

		Id recordTypeDSLId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId( );
		Contact c = new Contact( );
		c.LastName = 'c';
		c.RecordTypeId = recordTypeDSLId;
		c.AccountId = merchant.id;
		c.OB_Bank__c = bank.id;
		insert c;

		List<Contact> contactList = new List<Contact>( );
		Contact legalReference = new Contact( );
		legalReference.Phone = '123456765';
		legalReference.Email = 'contact@gmail.com';
		legalReference.MobilePhone = '56767676';
		legalReference.LastName = 'contact lastname' ;
		legalReference.Fax = '2345456';
		contactList.add( legalReference );
		insert contactList;

		Contract contract = new Contract( );
		contract.AccountId = merchant.id;
		contract.StartDate = Date.newInstance( 2018, 05, 31 );
		contract.Status = 'Draft';
		insert contract;

		NE__Order__c ord = new NE__Order__c( NE__Order_date__c = date.newinstance( 1960, 2, 17 ) );
		insert ord;
		NE__Order_Header__c orderHeader = new NE__Order_Header__c( NE__AccountId__c = merchant.id, NE__OrderId__c = ord.id, OB_ProposerABI__c = bank.id );
		insert orderHeader;

		NE__Order__c order = new NE__Order__c( NE__Order_Header__c = orderHeader.id, NE__BillingProfId__c = bp.id, NE__BillAccId__c = bank.id, OB_BankAccount_Acquiring__c = bp.id );
		insert order;

		NE__OrderItem__c item = new NE__OrderItem__c( NE__OrderId__c = order.id, NE__Qty__c = 1 );
		insert item;
		List<String> recordTypesDevName = new List<String> {'Terminali', 'Gateway_Virtuale', 'Moto', 'eCommerce', 'Acquiring', 'Pagobancomat', 'Vas', 'PCI', 'Integrazione'};
		List<NE__Product__c> productsList = new List<NE__Product__c>( );

		for ( RecordType recItem : [ SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName IN :recordTypesDevName ] )
		{
			NE__Product__c tmp_product = new NE__Product__c( RecordTypeId = recItem.id );
			productsList.add( tmp_product );
		}
		insert productsList;

		Id pricingRecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Pricing' LIMIT 1 ].id;

		NE__Product__c pricingProduct = new NE__Product__c( RecordTypeId = pricingRecordTypeId );
		List<NE__OrderItem__c> itemsList = new List<NE__OrderItem__c>( );
		for ( NE__Product__c prod : productsList )
		{
			NE__OrderItem__c tmp_orderItem = new NE__OrderItem__c( );
			tmp_orderItem.NE__ProdId__c = prod.id;
			tmp_orderItem.NE__OrderId__c = order.id;
			tmp_orderItem.NE__Qty__c = 1;
			itemsList.add( tmp_orderItem );
		}

		List<NE__OrderItem__c> childItemList = new List<NE__OrderItem__c>( );

		insert itemsList;
		for ( NE__OrderItem__c itemm : itemsList )
		{
			NE__OrderItem__c tmp_orderItem = new NE__OrderItem__c( );
			tmp_orderItem.NE__ProdId__c = pricingProduct.id;
			tmp_orderItem.NE__OrderId__c = order.id;
			tmp_orderItem.NE__Qty__c = 1;
			tmp_orderItem.NE__Parent_Order_Item__c = itemm.id;
			childItemList.add( tmp_orderItem );
		}
		insert childItemList;

		Test.startTest( );
		OB_Serialize_Order OB_so = new OB_Serialize_Order( );
		OB_Order_Wrapper ow = new OB_Order_Wrapper( orderHeader.Id );
		OB_Order_Wrapper.Pci t = ow.getPCI( order.Id );
		Test.stopTest( );
		System.assert( !String.isBlank( OB_so.serializeOrder( orderHeader.Id ) ) );
	}

	@isTest
	public static void serializeOrder_Test2( )
	{
		OB_Serialize_Order_Test.prepareAndInsertTestLovs( ); //NEXI-121 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> 17.07.2019
		Test.startTest( );
		String action = 'action test' ;
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.NE__E_mail__c = 'test@null.it';
		testAccount.OB_VAT_Not_Present__c = false;
		insert testAccount;

		Account merchant = OB_TestDataFactory.getAccount( );
		merchant.OB_Legal_Form__c = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE';
		merchant.OB_No_Profit_Recipient_Class__c = 'Senza tetto';
		merchant.OB_No_Profit_Class__c = 'Fondazioni';
		insert merchant;

		List<Contact> contactList = new List<Contact>( );
		Contact legalReference = new Contact( );
		legalReference.Phone = '123456765';
		legalReference.Email = 'contact@gmail.com';
		legalReference.MobilePhone = '56767676';
		legalReference.LastName = 'contact lastname' ;
		legalReference.Fax = '2345456';
		contactList.add( legalReference );
		insert contactList;

		Contract contract = new Contract( );
		contract.AccountId = merchant.id;
		contract.StartDate = Date.newInstance( 2018, 05, 31 );
		contract.Status = 'Draft';
		insert contract;


		NE__Order_Header__c orderHeader = new NE__Order_Header__c( NE__AccountId__c = merchant.id );
		insert orderHeader;
		//michele.lubrano@accenture.com 13/05/2019 inserting configuration START
		NE__Billing_Profile__c billingProfile = new NE__Billing_Profile__c(NE__Account__c = testAccount.Id);
		insert billingProfile;
		NE__Billing_Profile__c bankAccountDetails = new NE__Billing_Profile__c(NE__Account__c = testAccount.Id);
		insert bankAccountDetails;
		NE__Product__c product = new NE__Product__c(Name = 'TEST PRODUCT',OB_Codice_sfdc__c = '666');
		insert product;
		NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c = orderHeader.id, OB_Petitioner__c = 'Banca', NE__BillAccId__c = testAccount.Id, NE__BillingProfId__c = billingProfile.Id, OB_BankAccount_Acquiring__c = bankAccountDetails.Id);
		insert configuration;
		NE__OrderItem__c offeitem = new NE__OrderItem__c(NE__OrderId__c = configuration.Id,NE__ProdId__c = product.Id, NE__Qty__c = 1);
		insert offeitem;
		//michele.lubrano@accenture.com 13/05/2019 END

		OB_Serialize_Order OB_so = new OB_Serialize_Order( );
		OB_so.serializeOrder( orderHeader.id );
		System.assert( !String.isBlank( OB_so.serializeOrder( orderHeader.Id ) ) );
	}

	@isTest
	public static void serializeMerchant_Test( )
	{
		OB_Serialize_Order_Test.prepareAndInsertTestLovs( ); //NEXI-121 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> 17.07.2019
		Account merchant = OB_TestDataFactory.getAccount( );
		merchant.OB_Legal_Form__c = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE';
		merchant.NE__E_mail__c = 'test@gmail.it';
		merchant.OB_No_Profit_Recipient_Class__c = 'Senza tetto';
		merchant.OB_No_Profit_Class__c = 'Fondazioni';
		merchant.OB_Year_constitution_company__c = 2000;
		insert merchant;
		Id proposerABIId;

		Object result = OB_Serialize_Order.serializeMerchant( merchant.Id, proposerABIId );

		System.assertNotEquals( null, result );
	}


	@isTest
	public static void serializeContactPhonesTest( )
	{
		Contact c = new Contact( LastName = 'c' );
		c.Phone = '2345666';
		c.MobilePhone = '23456776';
		c.Fax = '0523181919';
		System.assertEquals( 3, OB_Serialize_Order.serializeContactPhones( c ).size( ) );
	}

	@isTest
	public static void serializeServicePointPhonesTest( )
	{
		NE__Service_Point__c testServicePoint = new NE__Service_Point__c( );
		testServicePoint.OB_Fax_Number__c = '123455';
		testServicePoint.OB_Phone_Number__c = '1234554';
		testServicePoint.OB_Mobile_Phone_Number__c = '3455555';
		testServicePoint.NE__Street__c = 'VIA ADDA' ;
		testServicePoint.OB_Street_Number__c = '21';
		testServicePoint.OB_Address_Detail__c = '' ;
		testServicePoint.NE__Zip_Code__c = '20124' ;
		testServicePoint.OB_Province_code__c = 'MI';
		testServicePoint.NE__City__c = 'MILANO';
		insert testServicePoint;

		NE__Order__c testOrder = new NE__Order__c( );
		testOrder.NE__Street__c = testServicePoint.NE__Street__c;
		testOrder.NE__Zip_Code__c = testServicePoint.NE__Zip_Code__c;
		testOrder.NE__City__c = testServicePoint.NE__City__c;
		testOrder.OB_Service_Point__c = testServicePoint.id;
		insert testOrder;

		NE__Order__c targetOrder =
		[
				SELECT Id,
						name,
						OB_Service_Point__r.OB_Phone_Number__c,
						OB_Service_Point__r.OB_Mobile_Phone_Number__c,
						OB_Service_Point__r.OB_Fax_Number__c
				FROM NE__Order__c
				WHERE OB_Service_Point__r.OB_Fax_Number__c = :'123455'
		];

		System.assertEquals( 3, OB_Serialize_Order.serializeServicePointPhones( targetOrder ).size( ) );
	}

	@isTest
	public static void serializecontactsTest1( )
	{
		Id proposerABIId;
		Account testAccount = OB_TestDataFactory.getAccount( );
		Contact testContact = OB_TestDataFactory.getContact(testAccount);
		insert testContact;

		System.assertEquals( 1, OB_Serialize_Order.serializecontacts( testAccount.Id, proposerABIId ).size( ) );
	}

	@isTest
	public static void serializecontactsTest2( )
	{
	
		// noemi.infantino - 04/07/2019 - start
		Account merchantAccount = OB_TestDataFactory.getAccount( );
		insert merchantAccount;

		Account bankAccount = OB_TestDataFactory.getAccount( );
		bankAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId( );
		insert bankAccount;

		NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint();
		insert servicePoint;

		Contact contatto = OB_TestDataFactory.getContact(merchantAccount);
		contatto.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO ).getRecordTypeId( );
		contatto.OB_Bank__c = bankAccount.Id;
		contatto.OB_Service_Point__c = servicePoint.Id;
		insert contatto;

		System.debug('merchantAccount ' + JSON.serialize(merchantAccount));
		System.debug('bankAccount ' + JSON.serialize(bankAccount));
		System.debug('servicePoint ' + JSON.serialize(servicePoint));
		System.debug('contatto ' + JSON.serialize(contatto));

		System.assertEquals( 1, OB_Serialize_Order.serializecontacts( merchantAccount.Id, bankAccount.Id, servicePoint.id ).size( ) );
		// noemi.infantino - 04/07/2019 - end  

		
	}

	@isTest
	public static void serializeBankAccount_Test( )
	{
		Id posBP;
		Id acquiringBP;
		NE__Billing_Profile__c bp = new NE__Billing_Profile__c( );
		NE__Billing_Profile__c bp1 = new NE__Billing_Profile__c( );
		Account acc = OB_TestDataFactory.getAccount( );
		acc.NE__E_mail__c = 'test@null.it';
		acc.OB_VAT_Not_Present__c = false;
		insert acc;

		bp.NE__Account__c = acc.id;
		bp.OB_CountryCode__c = 'IT';
		bp.OB_EuroControlCode__c = '26';
		bp.OB_CINCode__c = 'D';
		bp.OB_ABICode__c = '05116';
		bp.OB_CABCode__c = '11703';
		bp.OB_Bank_Account_Number__c = '000000002340';
		bp.OB_HeaderInternational__c = 'prova s.r.l.';
		insert bp;

		bp1.NE__Account__c = acc.id;
		bp1.OB_CountryCode__c = 'IT';
		bp1.OB_EuroControlCode__c = '26';
		bp1.OB_CINCode__c = 'D';
		bp1.OB_ABICode__c = '05116';
		bp1.OB_CABCode__c = '11703';
		bp1.OB_Bank_Account_Number__c = '000000002340';
		bp1.OB_HeaderInternational__c = 'prova s.r.l.';
		insert bp1;

		System.assertEquals( 2, OB_Serialize_Order.serializeBankAccount( bp.id, bp1.id ).size( ) );
	}

	@isTest
	public static void getMerchantTest( )
	{
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.OB_Legal_Form__c = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE';
		testAccount.NE__E_mail__c = 'test@gmail.it';
		testAccount.OB_No_Profit_Recipient_Class__c = 'Senza tetto';
		testAccount.OB_No_Profit_Class__c = 'Fondazioni';
		testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId( );
		insert testAccount;
		Id merchantId = testAccount.id ;
		Id proposerABIId = merchantId;

		List<Contact> contactList = new List<Contact>( );
		Contact legalReference = new Contact( );
		legalReference.Phone = '123456765';
		legalReference.Email = 'contact@gmail.com';
		legalReference.MobilePhone = '56767676';
		legalReference.LastName = 'contact lastname' ;
		legalReference.Fax = '2345456';
		legalReference.OB_bank__c = proposerABIId ;
		insert legalReference;
		OB_Serialize_Order OB_so = new OB_Serialize_Order( );

		System.assertEquals( testAccount.Id, OB_Serialize_Order.getMerchant( merchantId, proposerABIId ).Id );
	}

	@isTest
	public static void getOrderHeaderTest( )
	{
		NE__Order_Header__c oh = new NE__Order_Header__c( );
		insert oh;
		NE__Order__c conf = new NE__Order__c( NE__Order_Header__c = oh.Id );
		insert conf;
		OB_Serialize_Order OB_so = new OB_Serialize_Order( );

		System.assertEquals( oh.Id, OB_so.getOrderHeader( oh.Id ).Id );
	}

	@isTest
	public static void getBillingProfile_Test( )
	{
		NE__Billing_Profile__c bp = new NE__Billing_Profile__c( );
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.NE__E_mail__c = 'test@null.it';
		testAccount.OB_VAT_Not_Present__c = false;
		insert testAccount;

		bp.NE__Account__c = testAccount.id;
		insert bp;

		System.assertEquals( bp.Id, OB_Serialize_Order.getBillingProfile( bp.id ).Id );
	}
	/*******************************************************************************
	Purpose: Method checks value of 'atecoCode' if value is equal to '0000'
	then transcode to null
	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Michal Targiel       09/07/2019        Created            NEXI-119
	********************************************************************************/
	@isTest static void getMerchantWithAtecoCodeEqual0000ReturnNullTest( )
	{
		String merchantId = prepareDataForGetMerchantWithAtecoCode( '0000' );

		OB_Serialize_Order.MerchantDTO merchantDTO = OB_Serialize_Order.serializeMerchant( merchantId, merchantId );
		System.assertEquals( null, merchantDTO.atecoCode );
	}
	/*******************************************************************************
    Purpose: Method checks value of 'atecoCode' if value is not equal to '0000'
    then return atecoCode
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       09/07/2019        Created            NEXI-119
    ********************************************************************************/
	@isTest static void getMerchantWithAtecoCodeNotEqual0000ReturnAtecoCodeTest( )
	{
		String merchantId = prepareDataForGetMerchantWithAtecoCode( '1234' );

		OB_Serialize_Order.MerchantDTO merchantDTO = OB_Serialize_Order.serializeMerchant( merchantId, merchantId );
		System.assertEquals( '1234', merchantDTO.atecoCode );
	}

	/*******************************************************************************
	Purpose: Method for prepare data for tests
	Parameters: String atecoCode
	Returns: String
	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Michal Targiel       15/07/2019        Created            NEXI-119
	********************************************************************************/
	private static String prepareDataForGetMerchantWithAtecoCode( String atecoCode )
	{
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.OB_ATECO__c = atecoCode;
		testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId( );
		insert testAccount;

		Contact legalReference = new Contact( );
		legalReference.Phone = '123456765';
		legalReference.Email = 'contact@gmail.com';
		legalReference.MobilePhone = '56767676';
		legalReference.LastName = 'contact lastname' ;
		legalReference.Fax = '2345456';
		legalReference.OB_bank__c = testAccount.id ;
		insert legalReference;

		return testAccount.id;
	}

	/*******************************************************************************
	Purpose:  Method tests OB_Serialize_Order.checkForEmptyLegalFormCode method with null parameter
	Parameters: -
	Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-121
	********************************************************************************/
	@IsTest
	private static void checkForEmptyLegalFormCodeNullTest( )
	{
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.OB_Legal_Form__c = OB_UtilityConstants.DITTA_INDIVIDUALE;
        insert testAccount;
		OB_Serialize_Order.checkForEmptyLegalFormCode( null );
		Account testAccountAfterMethod = [ SELECT OB_Legal_Form_Code__c FROM Account WHERE Id = :testAccount.Id ].get( 0 );
		System.assertEquals( null, testAccountAfterMethod.OB_Legal_Form_Code__c );
	}

	/*******************************************************************************
	Purpose:  Method tests OB_Serialize_Order.checkForEmptyLegalFormCode method with merchant with empty legal form code and filled legal form
	Parameters: -
	Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-121
    ********************************************************************************/
	@IsTest
	public static void checkForEmptyLegalFormCodeTest( )
	{
		OB_Serialize_Order_Test.prepareAndInsertTestLovs( );

		Map<String, String> dataMap = OB_Serialize_Order_Test.prepareDataForCheckForEmptyLegalFormCode( );
		Id merchantId = dataMap.get( 'merchantId' );
		Id orderHeaderId = dataMap.get( 'orderHeaderId' );
		Id orderId = dataMap.get( 'orderId' );
        Account acc = (Account) JSON.deserialize(dataMap.get( 'merchant' ), Account.class); // antonio.vatrano 23/09/2019 wn-448


		Test.startTest( );
        // Start antonio.vatrano 23/09/2019 wn-448
		/*OB_Serialize_Order OB_so = new OB_Serialize_Order( );
		OB_Order_Wrapper ow = new OB_Order_Wrapper( orderHeaderId );	
		OB_Order_Wrapper.Pci t = ow.getPCI( orderId );*/
        
		Test.stopTest( );
		//System.assert( !String.isBlank( OB_so.serializeOrder( orderHeaderId ) ) );
		OB_Serialize_Order.checkForEmptyLegalFormCode(acc);
        //End antonio.vatrano 23/09/2019 wn-448
		Account testAccountAfterMethod = [ SELECT OB_Legal_Form_Code__c FROM Account WHERE Id = :merchantId ];
		system.debug( 'mDebug' + testAccountAfterMethod );
		System.assertEquals( OB_UtilityConstants.ORG_NO_PROFIT_CODE, testAccountAfterMethod.OB_Legal_Form_Code__c );
	}

	/*******************************************************************************
    Purpose:  Method tests OB_Serialize_Order.checkForEmptyLegalFormCode method to check exception handling
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-121
    ********************************************************************************/
	@IsTest
	private static void checkForEmptyLegalFormCodeExceptionTest( )
	{
		OB_Serialize_Order_Test.prepareAndInsertTestLovs( );
		Account testAccount = OB_TestDataFactory.getAccount( );
		testAccount.OB_Legal_Form__c = OB_UtilityConstants.DITTA_INDIVIDUALE;
		OB_Serialize_Order.checkForEmptyLegalFormCode( testAccount );
		List<Account> testAccountListAfterMethod = [ SELECT OB_Legal_Form_Code__c FROM Account WHERE Id = :testAccount.Id ];
		System.assert( testAccountListAfterMethod.isEmpty( ) );
	}

}