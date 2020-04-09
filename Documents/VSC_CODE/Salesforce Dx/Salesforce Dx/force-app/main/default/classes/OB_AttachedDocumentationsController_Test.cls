/*****************************************************************
Name: OB_AttachedDocumentationsController_Test
Copyright © 2016 ITC 
============================================================
Purpose:  Class tests OB_AttachedDocumentationsController class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Marta Stempien           11/04/2019       Modified            RP_000
********************************************************************************/
	@isTest
public class OB_AttachedDocumentationsController_Test
{
    /*******************************************************************************
    Purpose:  Tests retrieveOrderHeaderId(String configurationId) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019        Modified        [RP_000] Assertion added
    ********************************************************************************/
    @isTest
    public static void retrieveOrderHeaderId_Test( )
    {
		String configurationId;
		List<NE__Order__c> listOfOrders = new List<NE__Order__c> ();		
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        NE__Order__c config = OB_TestDataFactory.getOrder( orderHeader );
        config.NE__Type__c = 'InOrder';
        config.OB_ABI__c = '05116' ;
        insert config;
        String retrievedHeaderId = OB_AttachedDocumentationsController.retrieveOrderHeaderId ( config.id );
        System.assertEquals( orderHeader.id, retrievedHeaderId );
	}

    /*******************************************************************************
    Purpose:  Tests retrieveUserLicense() method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019        Modified       [RP_000] Assertion added
    ********************************************************************************/
	@isTest
    public static void retrieveUserLicense_test( )
    {
        String userLicence = [
                SELECT Profile.UserLicense.Name
                FROM User
                WHERE Id = :UserInfo.getUserId( )
        ].Profile.UserLicense.Name;
        String retrievedUserLicence = OB_AttachedDocumentationsController.retrieveUserLicense( );
        System.assertEquals( userLicence, retrievedUserLicence );
	}

    /*******************************************************************************
    Purpose:  Tests retrieveUserProfile( ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019        Modified       [RP_000] Assertion added
    ********************************************************************************/
	@isTest
    public static void retrieveUserProfile_Test( )
    {
        String userProfile = [
                SELECT Profile.Name
                FROM User
                WHERE Id = :UserInfo.getUserId( )
        ].Profile.Name;
        String retrievedProfile = OB_AttachedDocumentationsController.retrieveUserProfile( );
        System.assertEquals( userProfile, retrievedProfile );
	}

    /*******************************************************************************
    Purpose:  Tests getProductDocumentsServer( String orderHeaderId ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019        Modified       [RP_000] Assertion added
    ********************************************************************************/
	@isTest
    public static void getProductDocumentsServerTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__E_mail__c = 'test@null.it';
        testAccount.OB_Employees_Number__c = 'Minore di 10';
        testAccount.NE__VAT__c = '12345678901';
        testAccount.NE__Fiscal_code__c = '12345678901';
        testAccount.OB_VAT_Not_Present__c = false;
        testAccount.OB_ABI__c = '12345';
        testAccount.OB_ATECO__c = '1234567';
        testAccount.OB_Legal_Form__c = 'A100';
        insert testAccount;

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = testAccount.id;
        orderHeader.OB_Main_Process__c = 'Setup';
        insert orderHeader;
        String orderHeaderId = orderHeader.id;

        List<OB_Special_Category_Configuration__c> specialCatsList = new List<OB_Special_Category_Configuration__c>( );
        Id recordTypeIdSpecialCat = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_MCC_AND_PRODUCT' ).getRecordTypeId( );
        Id atecoSpecialCategoryRecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_MCC_OR_ATECO' ).getRecordTypeId( );
        Id productEnablementSpecialCategoryRecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_PRODUCT_ENABLEMENT' ).getRecordTypeId( );

		List<OB_Special_Category_Configuration__c> listToFilter = new List<OB_Special_Category_Configuration__c>();
		OB_Special_Category_Configuration__c   obj1             = new OB_Special_Category_Configuration__c();
		obj1.OB_DocRequired__c = true;
		obj1.OB_ATECO__c       = 'Gambling';
		obj1.OB_MCC__c         = 'Gambling';
		listToFilter.add(obj1);
		insert listToFilter;

        NE__Order__c order = OB_TestDataFactory.getOrder( );
        order.NE__Order_Header__c = orderHeaderId;
        order.OB_MCC__C = '0511';
        insert order;

        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.OB_Contract_Type__c = 'Test';
        insert product;

        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( order.id );
        orderItem.NE__Qty__c = 1;
        orderItem.NE__ProdId__c = product.id;
        insert orderItem;

		OB_Product_Document__c document = new OB_Product_Document__c();
		document.Name = 'Documento 2'; 
        document.OB_Commercial_Product__c = product.id;
		document.OB_Business_Model__c     = 'Bancario';
		document.OB_Client_Type__c        = 'Gambling';
		document.OB_Request_Typology__c   = 'Setup';
		document.OB_Client_Type__c        = 'Gambling';
		document.OB_Request_Typology__c   = 'Setup';
        insert document;
        Map<String, Map<String, String>> documents = OB_AttachedDocumentationsController.getProductDocumentsServer ( orderHeaderId );
        System.assertNotEquals( null, documents );
	}

    /*******************************************************************************
    Purpose:  serverGetDocumentListId( String orderHeaderId ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019        Modified       [RP_000] Assertion added
    ********************************************************************************/
	@isTest
    public static void serverGetDocumentListId_Test( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__E_mail__c = 'test@null.it';
        testAccount.OB_Employees_Number__c = 'Minore di 10';
        testAccount.NE__VAT__c = '12345678901';
        testAccount.NE__Fiscal_code__c = '12345678901';
        testAccount.OB_VAT_Not_Present__c = false;
        testAccount.OB_ABI__c = '12345';
        insert testAccount;

        NE__Service_Point__c servicePoint = new NE__Service_Point__c( );
        insert servicePoint;

		NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        orderHeader.NE__AccountId__c = testAccount.id;
        insert orderHeader;

        NE__Order__c configuration = new NE__Order__c( NE__Order_Header__c = orderHeader.Id );
        configuration.OB_Service_Point__c = servicePoint.id;

        List<NE__Order__c> listConfiguration = new List<NE__Order__c>( );
        listConfiguration.add( configuration );
        insert listConfiguration;
		String orderHeaderId = orderHeader.id;

        OB_Integration_Configuration__c integrationConfiguration = new OB_Integration_Configuration__c( );
        integrationConfiguration.Name = 'DEV1';
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;
		Test.setMock(HttpCalloutMock.class, new MockGetCadastrialCode());

	    Test.startTest();
        String retrievedDocument = OB_AttachedDocumentationsController.serverGetDocumentListId( orderHeaderId );
		Test.stopTest();
        System.assertNotEquals( null, retrievedDocument );
	}

    /*******************************************************************************
       Purpose:  submitApprovalProcess( String orderHeaderId ) method
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0         Marta Stempień       15/04/2019         Created           [RP_000]
       ********************************************************************************/
    @isTest
    public static void submitApprovalProcess_Test( )
    {
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;

        NE__Lov__c ateco = OB_TestDataFactory.getLov( );
        ateco.Name = '920';
        ateco.NE__Active__c = true;
        ateco.NE__Type__c = 'ATECO';
        ateco.NE__Value3__c = 'Gambling';
        insert ateco;

        NE__Lov__c mcc = OB_TestDataFactory.getLov( );
        mcc.NE__Type__c = 'MCC';
        mcc.NE__Value2__c = '3204';
        mcc.NE__Value1__c = 'PO118';
        mcc.NE__Value3__c = 'L3';
        insert mcc;
		
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__E_mail__c = 'test@null.it';
        testAccount.OB_Employees_Number__c = 'Minore di 10';
        testAccount.NE__VAT__c = '12345678901';
        testAccount.NE__Fiscal_code__c = '12345678901';
        testAccount.OB_VAT_Not_Present__c = false;
        testAccount.OB_ATECO__c = ateco.Name;
        insert testAccount;

		NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c();
		currentOrderHeader.OB_PEP__c = true;
        currentOrderHeader.NE__AccountId__c = testAccount.id;
        currentOrderHeader.OB_Gambling__c = true;
        currentOrderHeader.OB_PEP__c = true;
        currentOrderHeader.OB_PO118_MOTO__c = true;
        currentOrderHeader.OB_Main_Process__c = 'Setup';
		insert currentOrderHeader;

        List<OB_Special_Category_Configuration__c> specialCatsList = new List<OB_Special_Category_Configuration__c>( );
        Id recordTypeIdSpecialCat = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_MCC_AND_PRODUCT' ).getRecordTypeId( );
        Id atecoSpecialCategoryRecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_MCC_OR_ATECO' ).getRecordTypeId( );
        Id productEnablementSpecialCategoryRecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_PRODUCT_ENABLEMENT' ).getRecordTypeId( );

        OB_Special_Category_Configuration__c specialCat1 = OB_TestDataFactory.getSpecialCategoryConfiguration( );
        specialCat1.OB_ApprovalProcessRequired__c = true;
        specialCat1.OB_RequestType__c = currentOrderHeader.OB_Main_Process__c;
        specialCat1.RecordTypeId = recordTypeIdSpecialCat;
        specialCat1.OB_MCC__c = 'PO118';
        specialCat1.OB_OrderHeader__c = currentOrderHeader.Id;
        specialCat1.OB_EngineCodeCommercialProduct__c = 'engCode';

        specialCatsList.add( specialCat1 );
        insert specialCatsList;

        NE__Order__c configuration = OB_TestDataFactory.getOrder( );
        configuration.OB_MCC__c = mcc.NE__Value2__c;
        configuration.NE__Order_Header__c = currentOrderHeader.Id;
        insert configuration;

        Id terminaliProductRecordTypeId = [ SELECT Id FROM RecordType WHERE DeveloperName = 'Terminali' AND sObjectType = 'NE__Product__c' LIMIT 1 ].id;

        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.RecordTypeId = terminaliProductRecordTypeId;
        product.OB_Acquirer__c = 'Nexi';
        product.NE__Engine_Code__c = 'engCode';
        product.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        insert product;

        NE__OrderItem__c itemFather = OB_TestDataFactory.getOrderItem( configuration.id );
        itemFather.NE__ProdId__c = product.id;
        itemFather.NE__Qty__c = 1;
        insert itemFather;

        NE__OrderItem__c item = OB_TestDataFactory.getOrderItem( configuration.Id );
        item.NE__Qty__c = 1.0;
        item.NE__Parent_Order_Item__c = itemFather.id;
        item.NE__ProdId__c = product.id;
        item.NE__Action__c = 'Add';
        insert item;

        NE__OrderItem__c parentItem = OB_TestDataFactory.getOrderItem( configuration.Id );
        parentItem.NE__Parent_Order_Item__c = item.Id;
        insert parentItem;

		List<Contact> contacts = new List<Contact>();
        Contact testContact = new Contact( );
        testContact.FirstName = 'RIRI';
        testContact.LastName = 'TOTI';
        testContact.OB_Fiscal_Code__c = 'TTORRI00B01D150K';
        testContact.OB_Document_Release_Authority__c = 'Comune' ;
        testContact.OB_Document_Type__c = 'Carta di Identità';
        testContact.OB_Sex__c = 'M';
        testContact.OB_BypassValidation__c = false;
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Esecutore' ).getRecordTypeId( );
        testContact.OB_Document_Number__c = '123erty644';
        testContact.AccountId = testAccount.id;
        contacts.add( testContact );
		insert contacts;

		Test.setMock(HttpCalloutMock.class, new MockGetCadastrialCode());
		Test.setMock(HttpCalloutMock.class, new OB_MockCallServiceBlacklist());
	
		Test.startTest();
		OB_AttachedDocumentationsController.submitApprovalProcess(currentOrderHeader.Id);
		Test.stopTest();
        List <ProcessInstance> orderHeaderProcessInstances =  [Select ID From ProcessInstance Where TargetObjectID = :currentOrderHeader.id];
        System.assertNotEquals(null, orderHeaderProcessInstances);
	}
    /*******************************************************************************
    Purpose:  Tests getMapDocId( ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019        Modified       [RP_000] Assertion added
    ********************************************************************************/
	@isTest
    public static void getMapDocId_Test( )
    {
		Test.startTest();
        String docId = OB_AttachedDocumentationsController.getMapDocId( );
		Test.stopTest();
        System.assertEquals( null, docId );
	} 

    /*******************************************************************************
    Purpose:  Tests showCmpDocs( ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019        Modified       [RP_000] Assertion added
    ********************************************************************************/
	@isTest
    public static void showCmpDocs_Test( )
    {
        Account acc = OB_TestDataFactory.getAccount( );
		acc.NE__E_mail__c  = 'test@null.it';
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__VAT__c  = '12345678901';
		acc.NE__Fiscal_code__c= '12345678901';
		acc.OB_VAT_Not_Present__c = false;
		insert acc;
		NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c();
		currentOrderHeader.OB_PEP__c = true;
		currentOrderHeader.NE__AccountId__c = acc.id;
		insert currentOrderHeader;
		NE__Order__c config        = new  NE__Order__c(NE__Order_Header__c=currentOrderHeader.Id);
		insert config;
        // Start antonio.vatrano r1f3-54 13/09/2019
        map<string, string> cmpDocs = OB_AttachedDocumentationsController.showCmpDocs( config.id );
        System.assertEquals( 'false', cmpDocs.get('ShowDoc') );
        // End antonio.vatrano r1f3-54 13/09/2019
    }

    /*******************************************************************************
    Purpose:  Tests retrieveContracts( ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempień       11/04/2019         Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void retrieveContracts_Test( )
    {
        OB_Contract__c cContract = OB_TestDataFactory.getContract( );
        cContract.OB_Template_Name__c = 'AMEX';
        cContract.OB_Contract_Code__c = 'SFDCAMEX';
        insert cContract;
        Map<String, String> mapExpected = new Map<String, String>( );
        mapExpected.put( cContract.OB_Contract_Code__c, cContract.OB_Template_Name__c );
        System.assertEquals( mapExpected, OB_AttachedDocumentationsController.retrieveContracts( ) );
	}
    //Start antonio.vatrano r1f3-97 28/09/2019
    @isTest
    public static void retrieveInfoRiskEvaluation_Test( )
    {
        Account acc = OB_TestDataFactory.getAccount( );
		acc.NE__E_mail__c  = 'test@null.it';
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__VAT__c  = '12345678901';
		acc.NE__Fiscal_code__c= '12345678901';
		acc.OB_VAT_Not_Present__c = false;
		insert acc;
		NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c();
		currentOrderHeader.OB_PEP__c = true;
		currentOrderHeader.NE__AccountId__c = acc.id;
		insert currentOrderHeader;
		NE__Order__c config        = new  NE__Order__c(NE__Order_Header__c=currentOrderHeader.Id, NE__AccountId__c =acc.id);
		insert config;
        map<string, string> returnedMap = OB_AttachedDocumentationsController.retrieveInfoRiskEvaluation( config.id );
        System.assertEquals( acc.id, returnedMap.get('MERCHANT') );
    }
    //End antonio.vatrano r1f3-97 28/09/2019
}