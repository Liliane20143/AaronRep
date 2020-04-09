/*****************************************************************
Name: OB_Utility_Test 
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_Utility class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Marta Stempien              23/04/2019       Modified            RP_000
********************************************************************************/

@isTest
public class OB_Utility_Test
{
    /*******************************************************************************
    Purpose:  Method returns Account needed in test classes
    Parameters: -
    Returns: Account
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    private static Account getTestAccount( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.OB_Employees_Number__c = 'Minore di 10';
        testAccount.NE__VAT__c = '00000000000';
        testAccount.NE__Fiscal_code__c = 'ABCDEF12G34H567I';
        return testAccount;
    }
    /*******************************************************************************
    Purpose:  Method returns NE__Product__c needed in test classes
    Parameters: -
    Returns: NE__Product__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    private static NE__Product__c getTestProduct( )
    {
        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.OB_CommercialBundle__c = true;
        testProduct.OB_Acquirer__c = 'NEXI';
        testProduct.NE__Engine_Code__c = 'engCode';
        testProduct.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        return testProduct;
    }

    /*******************************************************************************
    Purpose:  Method insert objects needed to test retrieveSpecialCategoryConfigurations( orderHeaderId )
    and returns orderHeader.id
    Parameters: -
    Returns: String orderHeaderId
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    private static String getDataForRetrieveSpecialCategoryTest( String finalSpecialCategoryOrderHeader )
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


        Account testAccount = getTestAccount( );
        testAccount.OB_ATECO__c = ateco.Name;
        insert testAccount;

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = testAccount.Id;
        orderHeader.OB_Main_Process__c = 'Setup';
        insert orderHeader;

        List<OB_Special_Category_Configuration__c> specialCatsList = new List<OB_Special_Category_Configuration__c>( );
        Id recordTypeIdSpecialCat = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_MCC_AND_PRODUCT' ).getRecordTypeId( );
        Id atecoSpecialCategoryRecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_MCC_OR_ATECO' ).getRecordTypeId( );
        Id productEnablementSpecialCategoryRecordTypeId = Schema.SObjectType.OB_Special_Category_Configuration__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_PRODUCT_ENABLEMENT' ).getRecordTypeId( );

        OB_Special_Category_Configuration__c specialCategory = OB_TestDataFactory.getSpecialCategoryConfiguration( );
        specialCategory.OB_ApprovalProcessRequired__c = true;
        specialCategory.OB_RequestType__c = orderHeader.OB_Main_Process__c;
        specialCategory.RecordTypeId = recordTypeIdSpecialCat;
        specialCategory.OB_MCC__c = 'PO118';
        specialCategory.OB_OrderHeader__c = finalSpecialCategoryOrderHeader;
        specialCategory.OB_EngineCodeCommercialProduct__c = 'engCode';

        specialCatsList.add( specialCategory );
        insert specialCatsList;

        NE__Order__c configuration = OB_TestDataFactory.getOrder( );
        configuration.OB_MCC__c = mcc.NE__Value2__c;
        configuration.NE__Order_Header__c = orderHeader.Id;
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
        parentItem.NE__Qty__c = 1.0;
        parentItem.NE__Parent_Order_Item__c = item.Id;
        insert parentItem;

        String orderHeaderId = orderHeader.Id;
        String esecFiscalCode = 'ABCDEF12G34H567I';

        Test.setMock( HttpCalloutMock.class, new MockGetCadastrialCode( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );

        return orderHeaderId;
    }

    private static OB_LogRequest__c insertDataForLockRequestAndGetLogRequest( Boolean isTrueTestLogRequestParams )
    {
        Account testAccount = getTestAccount( );
        insert testAccount;

        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.OB_Acquirer__c = 'Nexi';
        insert product;

        NE__Catalog__c catalog = OB_TestDataFactory.getCatalog( );
        insert catalog;

        NE__Catalog_Item__c catItem = OB_TestDataFactory.getCatalogItem( catalog.Id, product.Id );
        insert catItem;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.NE__CatalogItem__c = catItem.id;
        testAsset.NE__Status__c = 'Active';
        testAsset.AccountId = testAccount.id;
        insert testAsset;

        NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint( );
        servicePoint.NE__Account__c = testAccount.Id;
        servicePoint.OB_Status__c = 'Inactive';
        insert servicePoint;

        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_ReducedOldData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111A", "OB_PEP__c":true}]}';
        logRequest.OB_ReducedNewData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111B", "OB_PEP__c":true}]}';
        logRequest.OB_Status__c = 'Confermato';
        logRequest.OB_ABI__c = '12345';
        logRequest.OB_AccountId__c = testAccount.id;
        logRequest.OB_PEP__c = true;
        logRequest.OB_isBlackList__c = true;
        logRequest.OB_ServicePointId__c = servicePoint.id;
        logRequest.OB_StartApprovalProcess__c = true;
        logRequest.OB_ChangeLegalRepresentative__c = isTrueTestLogRequestParams;
        logRequest.OB_NewLegalRepresentative__c = isTrueTestLogRequestParams;
        return logRequest;
    }

    private static OB_Integration_Configuration__c getAndInsertIntegrationConfiguration( )
    {
        String timeStampBefore = '1542025783107';
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = timeStampBefore;
        insert integrationConfiguration;
        return integrationConfiguration;
    }

    /*******************************************************************************
    Purpose: Tests retrieveSpecialCategoryConfigurations(String orderHeaderId)
                method when Final Special Category is 'OB_Gambling__c'
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void retrieveSpecialCategoryConfigurations_FinalSpecialCatOrderHeaderGambling_Test( )
    {
        String orderHeaderId = getDataForRetrieveSpecialCategoryTest( 'OB_Gambling__c' );
        Test.startTest( );
        OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );
        NE__Order_Header__c orderHeader = [ SELECT OB_Gambling__c, OB_StartApprovalProcess__c From NE__Order_Header__c WHERE Id = :orderHeaderId ];
        System.assertEquals( true, orderHeader.OB_Gambling__c );
        System.assertEquals( true, orderHeader.OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose: Tests retrieveSpecialCategoryConfigurations(String orderHeaderId)
                method when Final Special Category is 'OB_PO118_Ecommerce__c'
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void retrieveSpecialCategoryConfigurations_FinalSpecialCatOrderHeaderEcommerce_Test( )
    {
        String orderHeaderId = getDataForRetrieveSpecialCategoryTest( 'OB_PO118_Ecommerce__c' );
        Test.startTest( );
        OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );
        NE__Order_Header__c orderHeader = [ SELECT OB_PO118_Ecommerce__c, OB_StartApprovalProcess__c From NE__Order_Header__c WHERE Id = :orderHeaderId ];
        System.assertEquals( true, orderHeader.OB_PO118_Ecommerce__c );
        System.assertEquals( true, orderHeader.OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose: Tests retrieveSpecialCategoryConfigurations(String orderHeaderId)
                method when Final Special Category is 'OB_PO118_MOTO__c'
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/

    @isTest
    public static void retrieveSpecialCategoryConfigurations_FinalSpecialCatOrderHeaderMoto_Test( )
    {
        String orderHeaderId = getDataForRetrieveSpecialCategoryTest( 'OB_PO118_MOTO__c' );
        Test.startTest( );
        OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );
        NE__Order_Header__c orderHeader = [ SELECT OB_PO118_MOTO__c, OB_StartApprovalProcess__c From NE__Order_Header__c WHERE Id = :orderHeaderId ];
        System.assertEquals( true, orderHeader.OB_PO118_MOTO__c );
        System.assertEquals( true, orderHeader.OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose: Tests retrieveSpecialCategoryConfigurations(String orderHeaderId)
                method when Final Special Category is 'OB_HotelCarRental__c'
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void retrieveSpecialCategoryConfigurations_FinalSpecialCatOrderHeaderHotelCarRental_Test( )
    {
        String orderHeaderId = getDataForRetrieveSpecialCategoryTest( 'OB_HotelCarRental__c' );
        Test.startTest( );
        OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );
        NE__Order_Header__c orderHeader = [ SELECT OB_StartApprovalProcess__c From NE__Order_Header__c WHERE Id = :orderHeaderId ];
        System.assert( orderHeader.OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose: Tests retrieveSpecialCategoryConfigurations(String orderHeaderId)
                method when Final Special Category is 'OB_PreAuth__c'
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void retrieveSpecialCategoryConfigurations_FinalSpecialCatOrderHeaderPreAuth_Test( )
    {
        String orderHeaderId = getDataForRetrieveSpecialCategoryTest( 'OB_PreAuth__c' );
        Test.startTest( );
        OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );
        NE__Order_Header__c orderHeader = [ SELECT OB_PreAuth__c, OB_StartApprovalProcess__c From NE__Order_Header__c WHERE Id = :orderHeaderId ];
        System.assertEquals( true, orderHeader.OB_PreAuth__c );
        System.assertEquals( true, orderHeader.OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose:  submitApprovalProcess (String objectId,String approvalProcessName) method
    for Order Header Object in case of success
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       23/04/2019        Created           [RP_000]
	2.0			Zuzanna Urban		 23/07/2019		   Modyfied			 NEXI-217
    2.1         Marta Stempien       30/08/2019        Modified          NEXI-287 Add fields on OH to meet entry criteria for submit AP
    ********************************************************************************/
    @isTest
    public static void submitApprovalProcess_ControlliAcquiring_Test( )
    {
        Account testAccount = getTestAccount( );

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.OB_StartApprovalProcess__c = true;
        orderHeader.OB_ProcessInstanceAlredyExist__c = false;
        orderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_OPERATIVI;
        orderHeader.OB_ApprovalStep__c = '3';
        orderHeader.OB_AdditionalDocumentationRequired__c = true;
        orderHeader.NE__AccountId__c = testAccount.Id;
        insert orderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.NE__Order_Header__c = orderHeader.id;
        insert testOrder;

        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );

        Test.startTest( );
        OB_Utility.submitApprovalProcess( orderHeader.id, System.Label.OB_ApprovalProcessAcquiring );
        Test.stopTest( );
        Id orderHeaderProcessInstance = [ Select ID From ProcessInstance Where TargetObjectID = :orderHeader.id ].id;
        System.assertNotEquals( null, orderHeaderProcessInstance );
    }

    public static void retrieveSpecialCategoryConfigurations_FinalSpecialCatOrderHeaderManualPAN_Test( )
    {
        String orderHeaderId = getDataForRetrieveSpecialCategoryTest( 'OB_ManualPAN__c' );
        Test.startTest( );
        OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  submitApprovalProcess (String objectId,String approvalProcessName) method
    for Order Header Object in case of exception
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       23/04/2019        Created           [RP_000]
	2.0			Zuzanna Urban		 23/07/2019		   Modified			 NEXI-217
    ********************************************************************************/
    @isTest
    public static void submitApprovalProcess_ControlliAcquiringException_Test( )
    {
        Account testAccount = getTestAccount( );

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = testAccount.Id;
        insert orderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.NE__Order_Header__c = orderHeader.id;
        insert testOrder;

        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );

        Test.startTest( );
        OB_Utility.submitApprovalProcess( orderHeader.id, System.Label.OB_ApprovalProcessAcquiring );
        Test.stopTest( );
        List <ProcessInstance> orderHeaderProcessInstances = [ Select ID From ProcessInstance Where TargetObjectID = :orderHeader.id LIMIT 1 ];
        System.assertEquals( 0, orderHeaderProcessInstances.size( ) );
    }

    /*******************************************************************************
    Purpose:  submitApprovalProcess (String objectId,String approvalProcessName) method
    for Log Request Object in case of exception
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       23/04/2019        Created           [RP_000]
	2.0			Zuzanna Urban		 23/07/2019		   Modyfied			 NEXI-217
    ********************************************************************************/
    @isTest
    public static void submitApprovalProcess_LogRequestException_Test( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        insert logRequest;

        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );

        Test.startTest( );
        OB_Utility.submitApprovalProcess( logRequest.id, System.Label.OB_MAINTENANCE_APPROVALPROCESS );
        Test.stopTest( );
        List <ProcessInstance> logRequestProcessInstances = [ Select ID From ProcessInstance Where TargetObjectID = :logRequest.id LIMIT 1 ];
        System.assertEquals( 0, logRequestProcessInstances.size( ) );
    }

    @isTest
    public static void submitApprovalProcess_OrderHeader_Test( )
    {
        Account testAccount = getTestAccount( );

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = testAccount.Id;
        insert orderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.NE__Order_Header__c = orderHeader.id;
        insert testOrder;

        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );

        Test.startTest( );
        //NEXI-217 Zuzanna Urban <z.urban@accenture.com> 23/07/2019 Start, change label for the approval process
        OB_Utility.submitApprovalProcess( orderHeader.id, System.Label.OB_ApprovalProcessAcquiring );
        //NEXI-217 Zuzanna Urban <z.urban@accenture.com> 23/07/2019 Stop, change label for the approval process
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  submitApprovalProcess (String objectId,String approvalProcessName) method
    for Log Request Object in case of success
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       23/04/2019        Created           [RP_000]
	2.0			Zuzanna Urban		 23/07/2019		   Modyfied			 NEXI-217
    ********************************************************************************/
    @isTest
    public static void submitApprovalProcess_LogRequest_Test( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_StartApprovalProcess__c = true;
        logRequest.OB_ApprovalStep__c = '1';
        logRequest.OB_PEP__c = true;
        insert logRequest;

        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );

        Test.startTest( );
        OB_Utility.submitApprovalProcess( logRequest.id, System.Label.OB_MAINTENANCE_APPROVALPROCESS );
        Test.stopTest( );
        List<ProcessInstance> processInstances = [ Select ID From ProcessInstance Where TargetObjectID = :logRequest.id LIMIT 1 ];
        Id logRequestProcessInstance;
        if ( !processInstances.isEmpty( ) )
        {
            logRequestProcessInstance = processInstances.get( 0 ).id;
        }
        System.assertNotEquals( null, logRequestProcessInstance );
    }

    /*******************************************************************************
    Purpose:  submitApprovalProcess (String objectId,String approvalProcessName) method
    in case for Order object
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       23/04/2019        Created            [RP_000]
    ********************************************************************************/
    @isTest
    public static void submitApprovalProcess_OrderException_Test( )
    {
        NE__Order__c order = OB_TestDataFactory.getOrder( );
        insert order;

        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );

        Test.startTest( );
        OB_Utility.submitApprovalProcess( order.id, 'Approvazione_BIO' );
        Test.stopTest( );
        List <ProcessInstance> orderProcessInstances = [ Select ID From ProcessInstance Where TargetObjectID = :order.id LIMIT 1 ];
        System.assertEquals( 0, orderProcessInstances.size( ) );
    }

    @isTest
    public static void submitApprovalProcess_Order_Test( )
    {
        NE__Order__c order = OB_TestDataFactory.getOrder( );
        insert order;

        Test.setMock( HttpCalloutMock.class, new OB_MockUCAMP( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.setMock( HttpCalloutMock.class, new OB_MockCallSubmit( ) );

        Test.startTest( );
        OB_Utility.submitApprovalProcess( order.id, 'Approvazione_BIO' );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  checkItemsToCancel( String orderHeader ) method in case of cancellation
    of Order Item NE__OrderItem__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Monika Kocot          18/07/2019        Created           NEXI-220
    ********************************************************************************/
    @isTest
    public static void checkItemsToCancelOrderItem( )
    {
        Id rtAcquiring = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_ACQUIRING ).getRecordTypeId( );

        Account testAccount = getTestAccount( );
        insert testAccount;

        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint( );
        sp.Name = 'sp';
        sp.NE__Account__c = testAccount.Id;
        sp.OB_Typology__c = OB_UtilityConstants.SERVICE_POINT_FISICO;
        insert sp;

        List<Id> listOfConf = new List<Id>( );
        List<NE__OrderItem__c> listOfItems = new List<NE__OrderItem__c>( );

        OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c( );
        intConfig = OB_TestDataFactory.getIntegrationConfiguration( );
        intConfig.OB_Timestamp__c = '1552402089589';
        insert intConfig;

        NE__Billing_Profile__c billingProf = OB_TestDataFactory.getBillingProfile( testAccount.Id );
        insert billingProf;

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = testAccount.Id;
        insert orderHeader;

        NE__Order__c configuration = OB_TestDataFactory.getOrder( );
        configuration.NE__Order_Header__c = orderHeader.Id;
        configuration.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        configuration.NE__BillAccId__c = testAccount.Id;
        configuration.NE__BillingProfId__c = billingProf.Id;
        configuration.OB_BankAccount_Acquiring__c = billingProf.Id;
        insert configuration;
        listOfConf.add( configuration.Id );

        NE__Product__c testProduct = getTestProduct( );
        testProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT ).getRecordTypeId( );
        testProduct.OB_Codice_sfdc__c = OB_UtilityConstants.CUSTOM_SFDC;
        testProduct.OB_Acquirer__c = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI;
        insert testProduct;

        NE__OrderItem__c childItem = OB_TestDataFactory.getOrderItem( configuration.Id );
        childItem.NE__Parent_Order_Item__c = null;
        childItem.NE__OrderId__c = configuration.Id;
        childItem.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        childItem.NE__ProdId__c = testProduct.Id;
        childItem.NE__Service_Point__c = sp.id;
        insert childItem;
        listOfItems.add( childItem );

        Test.startTest( );
        OB_Utility.checkItemsToCancel( orderHeader.Id );
        Test.stopTest( );

        String status = [ SELECT OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE Id = :childItem.Id ].OB_FulfilmentStatus__c;
        Boolean checkbox = [ SELECT OB_POSInstallationOnlyPBOperator__c FROM NE__Order_Header__c WHERE Id = :orderHeader.Id ].OB_POSInstallationOnlyPBOperator__c;

        System.assertEquals( true, checkbox );
        System.assertEquals( OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED, status );
    }

    /*******************************************************************************
    Purpose:  checkItemsToCancel( String orderHeader ) method in case of cancellation of Order
     and Order Item and Parent Order Item
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       23/04/2019        Created           [RP_000]
    1.1         Kinga Fornal         12/08/2019        Updated           changed assert, mock for callSubmit test is now used
    ********************************************************************************/
    @isTest
    public static void checkItemsToCancel_CancelOrderAndOrderItemAndParentOrderItem_Test( )
    {
        Id rtAcquiring = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_ACQUIRING ).getRecordTypeId( ); // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9

        Account testAccount = getTestAccount( );
        insert testAccount;

        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
        List<Id> listOfConf = new List<Id>( );
        List<NE__OrderItem__c> listOfItems = new List<NE__OrderItem__c>( );

        OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c( );
        intConfig = OB_TestDataFactory.getIntegrationConfiguration( );
        intConfig.OB_Timestamp__c = '1552402089589';
        insert intConfig;

        NE__Billing_Profile__c billingProf = OB_TestDataFactory.getBillingProfile( testAccount.Id );
        insert billingProf;
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = testAccount.Id;
        insert orderHeader;

        NE__Order__c configuration = OB_TestDataFactory.getOrder( );
        configuration.NE__Order_Header__c = orderHeader.Id;
        configuration.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
        configuration.NE__BillAccId__c = testAccount.Id;
        configuration.NE__BillingProfId__c = billingProf.Id;
        configuration.OB_BankAccount_Acquiring__c = billingProf.Id;
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
        insert configuration;
        listOfConf.add( configuration.Id ); // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-9

        NE__Product__c testProduct = getTestProduct( );
        testProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT ).getRecordTypeId( );
        testProduct.OB_Codice_sfdc__c = OB_UtilityConstants.CUSTOM_SFDC;
        testProduct.OB_Acquirer__c = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI; // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9
        insert testProduct;

        NE__OrderItem__c childItem = OB_TestDataFactory.getOrderItem( configuration.Id );
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
        childItem.NE__OrderId__c = configuration.Id;
        childItem.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        childItem.NE__Parent_Order_Item__c = null;
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
        childItem.NE__ProdId__c = testProduct.Id;
        childItem.NE__Root_Order_Item__c = null;
        childItem.NE__Bundle_Configuration__c = null;
        insert childItem;
        listOfItems.add( childItem ); // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-9

        NE__OrderItem__c item = OB_TestDataFactory.getOrderItem( configuration.Id );
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
        item.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        item.NE__Parent_Order_Item__c = childItem.Id;
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
        item.NE__ProdId__c = testProduct.Id;
        item.NE__Root_Order_Item__c = childItem.Id;
        item.NE__Bundle_Configuration__c = childItem.Id;
        insert item;
        listOfItems.add( item ); // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-9

        NE__OrderItem__c parentItem = OB_TestDataFactory.getOrderItem( configuration.Id );
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
        parentItem.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
        parentItem.NE__ProdId__c = testProduct.Id;
        insert parentItem;
        listOfItems.add( parentItem ); // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-9

        Test.startTest( );
        OB_Utility.checkItemsToCancel( orderHeader.Id );
        Test.stopTest( );
        String status = [ SELECT OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE Id = :childItem.Id ].OB_FulfilmentStatus__c;
        String parentStatus = [ SELECT OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE Id = :item.Id ].OB_FulfilmentStatus__c;
        String configurationStatus = [ SELECT OB_FulfilmentStatus__c FROM NE__Order__c WHERE Id = :configuration.Id ].OB_FulfilmentStatus__c;
        System.debug( 'status ' + status );
        System.debug( 'parentStatus ' + parentStatus );
        System.debug( 'configurationStatus ' + configurationStatus );
        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_SENT, configurationStatus );  //NEXI Kinga Fornal <kinga.fornal@accenture.com>, 20/09/2019//Roland Nieznanski <roland.nieznanski@accenture.com> 24/09/2019
        System.assertEquals( OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED, parentStatus );
        System.assertEquals( OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED, status );
    }

    /*******************************************************************************
    Purpose:  Tests changeStatus( String orderHeaderId ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void changeStatus_Test( )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        insert orderHeader;
        NE__Order__c configuration = OB_TestDataFactory.getOrder( );
        configuration.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        configuration.NE__Order_Header__c = orderHeader.Id;
        insert configuration;
        NE__OrderItem__c item = OB_TestDataFactory.getOrderItem( configuration.Id );
        item.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
        insert item;
        OB_Utility.changeStatus( orderHeader.Id );
        String updatedOrderHeader = [ SELECT OB_FulfilmentStatus__c FROM NE__Order_Header__c WHERE Id = :orderHeader.id ].OB_FulfilmentStatus__c;
        String updatedOrder = [ SELECT OB_FulfilmentStatus__c FROM NE__Order__c WHERE Id = :configuration.id ].OB_FulfilmentStatus__c;
        String updatedOrderItem = [ SELECT OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE Id = :item.id ].OB_FulfilmentStatus__c;

        System.assertEquals( updatedOrderHeader, OB_UtilityConstants.ORDERS_STATUS_SENT );
        System.assertEquals( updatedOrder, OB_UtilityConstants.ORDERS_STATUS_SENT );
        System.assertEquals( updatedOrderItem, OB_UtilityConstants.ORDERS_STATUS_SENT );
    }

    @isTest
    public static void checkLogRequestTest( )
    {
        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c( );
        ic.Name = 'DEV1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        ic.OB_Timestamp__c = '1542025783107';
        insert ic;

        Account testAccount = getTestAccount( );
        insert testAccount;

        NE__Product__c prod = new NE__Product__c( );
        prod.Name = 'prod';
        prod.OB_Acquirer__c = 'Nexi';
        insert prod;

        NE__Catalog__c cat = new NE__Catalog__c( );
        insert cat;

        NE__Catalog_Item__c catItem = new NE__Catalog_Item__c( );
        catItem.NE__ProductId__c = prod.id;
        catItem.NE__Catalog_Id__c = cat.id;
        insert catItem;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.NE__CatalogItem__c = catItem.id;
        testAsset.NE__Status__c = 'Active';
        testAsset.AccountId = testAccount.id;
        insert testAsset;

        NE__Service_Point__c sp = new NE__Service_Point__c( );
        sp.Name = 'sp';
        sp.NE__Account__c = testAccount.Id;
        sp.OB_Status__c = 'Inactive';
        insert sp;

        OB_LogRequest__c lr = new OB_LogRequest__c( );
        lr.OB_ReducedOldData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111A", "OB_PEP__c":false}]}';
        lr.OB_ReducedNewData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111B", "OB_PEP__c":true}]}';
        lr.OB_Status__c = 'Confermato';
        lr.OB_ABI__c = '12345';
        lr.OB_AccountId__c = testAccount.id;
        lr.OB_PEP__c = true;
        lr.OB_isBlackList__c = true;
        lr.OB_ServicePointId__c = sp.id;
        lr.OB_StartApprovalProcess__c = true;
        lr.OB_ChangeLegalRepresentative__c = true;
        lr.OB_NewLegalRepresentative__c = true;
        insert lr;
        //giovanni spinelli 30/05/2019 start
        OB_LogRequest__c lr2 = new OB_LogRequest__c( );
        lr2.OB_ReducedOldData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111A", "OB_PEP__c":false}]}';
        lr2.OB_ReducedNewData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111B", "OB_PEP__c":true}]}';
        lr2.OB_Status__c = 'Confermato';
        lr2.OB_ABI__c = '12345';
        lr2.OB_PEP__c = true;
        lr2.OB_isBlackList__c = true;
        lr2.OB_ServicePointId__c = sp.id;
        lr2.OB_StartApprovalProcess__c = true;
        lr2.OB_ChangeLegalRepresentative__c = true;
        lr2.OB_NewLegalRepresentative__c = true;
        insert lr2;
        //giovanni spinelli 30/05/2019 end
        Test.startTest( );
        OB_Utility.checkLogRequest( lr.id );
        OB_Utility.checkLogRequest( lr2.id );//giovanni spinelli 30/05/2019
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Tests checkLogRequest( String logRequestId ) method for success scenario
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       17/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void checkLogRequestTestFailed1( )
    {
        String logRequestId = insertDataForLockRequestAndGetLogRequest( true ).Id;
        OB_Utility.checkLogRequest( logRequestId );
    }

    /*******************************************************************************
    Purpose:  Tests checkLogRequest( String logRequestId ) method for success scenario
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    1.1         Wojciech Szuba          08/10/2019      Refactored      NEXI-358, Fixed assertion
    ********************************************************************************/
    @isTest
    public static void checkLogRequest_ExceptionScenario_Test( )
    {
        OB_Integration_Configuration__c integrationConfiguration = getAndInsertIntegrationConfiguration( );
        OB_LogRequest__c logRequest = insertDataForLockRequestAndGetLogRequest( true );
        logRequest.OB_ReducedOldData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111A", "OB_PEP__c":false}]}';
        insert logRequest;
        OB_Utility.checkLogRequest( logRequest.id );
        String status = [ SELECT OB_Status__c FROM OB_LogRequest__c WHERE Id = :logRequest.Id ].OB_Status__c;
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE, status ); // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019 aligned assertion
    }

    /*******************************************************************************
    Purpose:  Tests checkLogRequest( String logRequestId ) method for success scenario
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void checkLogRequest_SaveToken_Test( )
    {
        OB_Integration_Configuration__c integrationConfiguration = getAndInsertIntegrationConfiguration( );
        String timeStampBefore = [ SELECT OB_Timestamp__c FROM OB_Integration_Configuration__c WHERE Id = :integrationConfiguration.id ].OB_Timestamp__c;
        OB_LogRequest__c logRequest = insertDataForLockRequestAndGetLogRequest( true );
        insert logRequest;
        OB_Utility.checkLogRequest( logRequest.Id );
        String timeStampAfter = [ SELECT OB_Timestamp__c FROM OB_Integration_Configuration__c WHERE Id = :integrationConfiguration.id ].OB_Timestamp__c;
        Boolean isTimeStampChanged = ( timeStampBefore != timeStampAfter );
        System.assertEquals( true, isTimeStampChanged );
    }

    /*******************************************************************************
    Purpose:  Tests checkLogRequest( String logRequestId ) method for failure scenario
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       19/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void checkLogRequest_FailureSaveTokenScenario_Test( )
    {
        OB_Integration_Configuration__c integrationConfiguration = getAndInsertIntegrationConfiguration( );
        String timeStampBefore = [ SELECT OB_Timestamp__c FROM OB_Integration_Configuration__c WHERE Id = :integrationConfiguration.id ].OB_Timestamp__c;
        OB_LogRequest__c logRequest = insertDataForLockRequestAndGetLogRequest ( false );
        insert logRequest;
        OB_Utility.checkLogRequest( logRequest.Id );
        String timeStampAfter = [ SELECT OB_Timestamp__c FROM OB_Integration_Configuration__c WHERE Id = :integrationConfiguration.Id ].OB_Timestamp__c;
        Boolean isTimeStampChanged = ( timeStampBefore != timeStampAfter );
        System.assertEquals( false, isTimeStampChanged );
    }

    /*******************************************************************************
    Purpose:  Tests checkLogRequest( String logRequestId ) method for failure scenario
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       17/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void checkLogRequest_FailureScenario_Test( )
    {
        String logRequestId = insertDataForLockRequestAndGetLogRequest ( false ).Id;
        OB_Utility.checkLogRequest( logRequestId );
    }

    @isTest
    public static void checkLogRequestTestException( )
    {
        Account testAccount = getTestAccount( );
        insert testAccount;

        NE__Product__c prod = new NE__Product__c( );
        prod.Name = 'prod';
        prod.OB_Acquirer__c = 'Nexi';
        insert prod;

        NE__Catalog__c cat = new NE__Catalog__c( );
        insert cat;

        NE__Catalog_Item__c catItem = new NE__Catalog_Item__c( );
        catItem.NE__ProductId__c = prod.id;
        catItem.NE__Catalog_Id__c = cat.id;
        insert catItem;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.NE__CatalogItem__c = catItem.id;
        testAsset.NE__Status__c = 'Active';
        testAsset.AccountId = testAccount.id;
        insert testAsset;

        NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint( );
        servicePoint.NE__Account__c = testAccount.Id;
        servicePoint.OB_Status__c = 'Inactive';
        insert servicePoint;

        OB_LogRequest__c lr = new OB_LogRequest__c( );
        lr.OB_ReducedOldData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111A", "OB_PEP__c":true}]}';
        lr.OB_ReducedNewData__c = '{"obj":[{"attributes":{"type":"Contact"}, "OB_Fiscal_Code__c":"AAAAAA11A11A111B", "OB_PEP__c":true}]}';
        lr.OB_Status__c = 'Confermato';
        lr.OB_ABI__c = '12345';
        lr.OB_AccountId__c = testAccount.id;
        lr.OB_PEP__c = true;
        lr.OB_isBlackList__c = true;
        lr.OB_ServicePointId__c = servicePoint.id;
        lr.OB_StartApprovalProcess__c = true;
        lr.OB_ChangeLegalRepresentative__c = true;
        lr.OB_NewLegalRepresentative__c = true;
        insert lr;

        Test.startTest( );
        OB_Utility.checkLogRequest( lr.id );
        Test.stopTest( );
    }

    @isTest
    public static void checkForAcquiringChangesTest( )
    {
        Account testAccount = getTestAccount( );
        insert testAccount;

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = testAccount.id;
        insert orderHeader;

        NE__Order__c order = new NE__Order__c( );
        order.NE__Order_Header__c = orderHeader.id;
        insert order;

        Id acquiringProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Acquiring' ).getRecordTypeId( );

        NE__Product__c prod = new NE__Product__c( );
        prod.OB_CommercialBundle__c = false;
        prod.OB_Acquirer__c = 'NEXI';
        prod.RecordTypeId = acquiringProductRecordTypeId ;
        insert prod;

        NE__OrderItem__c oi = new NE__OrderItem__c( );
        oi.NE__OrderId__c = order.id;
        oi.NE__ProdId__c = prod.id;
        oi.NE__Qty__c = 1;
        oi.NE__Action__c = 'Add';
        insert oi;

        List<Id> confList = new List<Id>( );
        confList.add( order.id );
        OB_Utility.checkForAcquiringChanges( confList );
    }

    /*******************************************************************************
    Purpose:  Tests opsEndFlow( configurationId  ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void opsEndFlow_Test( )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.OB_Main_Process__c = 'Maintenance';
        insert orderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.NE__Order_Header__c = orderHeader.Id;
        insert testOrder;
        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert orderItem;
        OB_Utility.opsEndFlow( testOrder.Id, false );
        String updatedFulfilmentStatus = [ SELECT OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE Id = :orderItem.Id ].OB_FulfilmentStatus__c;
        System.assertEquals( OB_UtilityConstants.ORDERS_STATUS_PENDING, updatedFulfilmentStatus );
    }

    /*******************************************************************************
    Purpose:  getDocumentsFromFilenet( String orderHeaderId  ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       16/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void getDocumentsFromFilenet_Test( )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.NE__Order_Header__c = orderHeader.Id;
        insert testOrder;
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Timestamp__c = '20000000';
        insert integrationConfiguration;
        Test.setMock( HttpCalloutMock.class, new OB_MockCallServiceBlacklist( ) );
        Test.startTest( );
        Map <String, OB_Utility.Documents > expectedMap = new Map <String, OB_Utility.Documents>( );
        expectedMap.put( testOrder.id, new OB_Utility.Documents( ) );
        system.debug( 'Expected map = ' + expectedMap );
        Map<String, OB_Utility.Documents> newMap = OB_Utility.getDocumentsFromFilenet( orderHeader.id );
        Test.stopTest( );
        System.assertEquals( expectedMap.get( orderHeader.id ), newMap.get( orderHeader.id ) );
    }

    /*******************************************************************************
    Purpose:  Tests getOrders( String orderHeaderId ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void getOrders_Test( )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.NE__Order_Header__c = orderHeader.Id;
        insert testOrder;
        System.assertEquals( 1, OB_Utility.getOrders( orderHeader.Id ).size( ) );
    }

    /*******************************************************************************
    Purpose:  Tests getOrderItems( String orderId ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void getOrderItems_Test( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert orderItem;
        System.assertEquals( 1, OB_Utility.getOrderItems( testOrder.Id ).size( ) );
    }

    /*******************************************************************************
    Purpose:  Tests getSpecialCategory( ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void getSpecialCategory_Test( )
    {
        OB_Special_Category_Configuration__c specialCategoryConfiguration =
                OB_TestDataFactory.getSpecialCategoryConfiguration( );
        specialCategoryConfiguration.OB_DocRequired__c = true;
        insert specialCategoryConfiguration;
        System.assertEquals( 1, OB_Utility.getSpecialCategory( ).size( ) );
    }

    /*******************************************************************************
    Purpose:  Tests getAllDocuments( List<String> listClientType, String mainProcess ) method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       12/04/2019        Created           [RP_000]
    ********************************************************************************/
    @isTest
    public static void getAllDocuments_Test( )
    {
        OB_Product_Document__c productDocument = OB_TestDataFactory.getProductDocument( );
        productDocument.OB_Request_Typology__c = 'Setup';
        productDocument.OB_Client_Type__c = 'eCommerce';
        insert productDocument;
        String mainProcess = 'Setup';
        List <String> clientTypes = new List <String>( );
        clientTypes.add( 'eCommerce' );
        System.assertEquals( 1, OB_Utility.getAllDocuments( clientTypes, mainProcess ).size( ) );
    }

    @isTest
    public static void insertLogRequest_Test( )
    {
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
        OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c( );
        intConfig = OB_TestDataFactory.getIntegrationConfiguration( );
        intConfig.OB_Timestamp__c = '1552402089589';
        insert intConfig;
        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        insert logRequest;
        OB_Utility.serializeAnagrafica( logRequest.Id );

    }

    @isTest
    public static void serializeAnagrafica_Test( )
    {
        Account a = OB_TestDataFactory.getAccount( );
        insert a;
        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_MaintenanceType__c', 'Anagrafica' );
        sourceMap.put( 'OB_AccountId__c', a.id );
        sourceMap.put( 'OB_ServicePointId__c', null );
        sourceMap.put( 'OB_ReducedOldData__c', '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb885","Id":"0039E00000mpvFPQAY"}]}' );
        sourceMap.put( 'OB_ReducedNewData__c', '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb880","Id":"0039E00000mpvFPQAY"}]}' );
        sourceMap.put( 'OB_ChangeCompanyData__c', 'false' );
        sourceMap.put( 'OB_ChangeLegalForm__c', 'false' );
        sourceMap.put( 'OB_ChangeLegalRepresentative__c', 'false' );
        sourceMap.put( 'OB_ChangeMerchantName__c', 'false' );
        sourceMap.put( 'OB_ChangeServicePointData__c', 'false' );
        sourceMap.put( 'OB_NewLegalRepresentative__c', 'true' );
        sourceMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT );
        sourceMap.put( 'OB_SIAToBeApproved__c', 'false' );
        sourceMap.put( 'OB_CAB__c', '12700' );
        sourceMap.put( 'OB_ABI__c', '12300' );
        OB_Utility.insertLogRequest( sourceMap );
    }

    //giovanni spinelli 15/04/2019 - start
    /**********************************************
    *METHOD FOR OB_Utility.searchOnAsset
    **********************************************/
    @isTest
    public static void searchOnAsset_Test( )
    {
        OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper( );
        OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper( );

        Test.startTest( );
        OB_Utility.searchOnAsset( searchWrapper, result );
        Test.stopTest( );
    }
    //giovanni spinelli 15/04/2019 - end
    /*******************************************************************************
    Purpose:  Tests toUppercaseUpdate method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         giovanni spinelli     25/07/2019        Created           
    ********************************************************************************/
    @isTest
    public static void toUppercaseUpdate_Test( )
    {
        List<String> fieldList = new List<String> {'lastname'};
        list<Contact> newObjList = new list<Contact>( );
        list<Contact> oldObjlist = new list<Contact>( );
        Contact cnt1 = new Contact( );
        cnt1.LastName = 'test';
        newObjList.add( cnt1 );
        Contact cnt2 = new Contact( );
        cnt2.LastName = 'test2';
        oldObjlist.add( cnt2 );
        Test.startTest( );
        OB_Utility.toUppercaseUpdate( newObjList, oldObjlist, fieldList );
        Test.stopTest( );
    }


    /*******************************************************************************
    Purpose:  Tests insertLogRequest( Map<String, String> sourceMap ) method for the scenario with reqestType == ANAGRAFICA
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       24/06/2019        Created           NEXI-83
    ********************************************************************************/
    @isTest
    public static void insertLogRequestForAnagraficaTest( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;
        NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
        insert sServicePoint;
        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_MaintenanceType__c', 'Anagrafica' );
        sourceMap.put( 'OB_AccountId__c', aAccount.id );
        sourceMap.put( 'OB_ServicePointId__c', sServicePoint.Id );
        sourceMap.put( 'OB_ReducedOldData__c', '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb885","Id":"0039E00000mpvFPQAY"}]}' );
        sourceMap.put( 'OB_ReducedNewData__c', '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb880","Id":"0039E00000mpvFPQAY"}]}' );
        sourceMap.put( 'OB_ChangeCompanyData__c', 'false' );
        sourceMap.put( 'OB_ChangeLegalForm__c', 'false' );
        sourceMap.put( 'OB_ChangeLegalRepresentative__c', 'false' );
        sourceMap.put( 'OB_ChangeMerchantName__c', 'false' );
        sourceMap.put( 'OB_ChangeServicePointData__c', 'false' );
        sourceMap.put( 'OB_NewLegalRepresentative__c', 'true' );
        sourceMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT );
        sourceMap.put( 'OB_SIAToBeApproved__c', 'false' );
        sourceMap.put( 'OB_CAB__c', '12700' );
        sourceMap.put( 'OB_ABI__c', '12300' );
        sourceMap.put( 'OB_StartApprovalProcess__c', 'true' );
        sourceMap.put( 'OB_isGambling__c', 'true' );
        sourceMap.put( 'OB_PO118_eCommerce__c', 'false' );
        OB_LogRequest__c logRequest = OB_Utility.insertLogRequest( sourceMap );
        System.assertNotEquals( logRequest.Id, null );
    }
    //giovanni spinelli 15/04/2019 - end

    /*******************************************************************************
    Purpose:  prepare data for submit approval process controlli acquring tests
    Returns: orderHeaderTest.Id
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       26/07/2019        Created           NEXI-207
    1.1         Joanna Mielczarek    06/09/2019        Modified          NEXI-314 added account and product type
    ********************************************************************************/
    private static String prepareDateForSubmitApprovalProcessControlliAcquring( String productType )
    {
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;

        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Order_Header__c orderHeaderTest = OB_TestDataFactory.getOrderHeader( );
        orderHeaderTest.NE__AccountId__c = testAccount.Id;
        orderHeaderTest.OB_Main_Process__c = OB_UtilityConstants.MAINTENANCE;
        orderHeaderTest.OB_Gianos__c = '25';
        insert orderHeaderTest;

        NE__Order__c orderTest = OB_TestDataFactory.getOrder( );
        orderTest.NE__AccountId__c = testAccount.Id;
        orderTest.NE__Order_Header__c = orderHeaderTest.Id;
        insert orderTest;

        NE__Product__c productTest = OB_TestDataFactory.getProduct( );
        productTest.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS ).getRecordTypeId( );
        productTest.OB_Codice_sfdc__c = productType;
        insert productTest;

        NE__OrderItem__c orderItemTest = OB_TestDataFactory.getOrderItem( orderTest.Id );
        orderItemTest.OB_ProductRecordType__c = OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS;
        orderItemTest.NE__OrderId__c = orderTest.Id;
        orderItemTest.NE__ProdId__c = productTest.Id;
        orderItemTest.NE__OrderId__c = orderTest.Id;
        orderItemTest.NE__Action__c = OB_UtilityConstants.ADD_ACTION ;
        orderItemTest.NE__Root_Order_Item__c = null;
        insert orderItemTest;

        return orderHeaderTest.Id;
    }

    /*******************************************************************************
    Purpose:  Method tests searchOnAsset - happy flow with one Asset

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-243 just increase cc
    ********************************************************************************/
    @isTest
    private static void searchOnAssetHappy( )
    {
        OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper( );
        OB_MaintenanceSearch_Controller.SearchResultWrapper searchResultWrapper = new OB_MaintenanceSearch_Controller.SearchResultWrapper( );

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;
        Account testAccount;
        User testUser;

        System.runAs( portalAccountOwner )
        {
            Account bankAccount = OB_TestDataFactory.getBankAccount( );
            bankAccount.OB_ABI__c = '03138';
            insert bankAccount;
            OB_Bank_Profile__c testBankProfile = OB_TestDataFactory.getBankProfile( bankAccount );
            testBankProfile.OB_Business_Model_Acquiring__c = 'Associate';
            insert testBankProfile;

            testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OB_Bank_owner__c = bankAccount.Id;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testUser = OB_TestDataFactory.getCommunityUser( testContact );
            testUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
            insert testUser;

            Asset testAsset = OB_TestDataFactory.getAsset( );
            testAsset.AccountId = testAccount.Id;
            testAsset.OB_ProposerABI__c = bankAccount.Id;
            insert testAsset;
        }

        System.runAs( testUser )
        {
            OB_Utility.searchOnAsset( searchWrapper, searchResultWrapper );
        }

        System.assertEquals( testAccount.Id, searchResultWrapper.selectedMerchantAsset );
    }

    /*******************************************************************************
    Purpose:  Method prepares map for creating LogRequest
    Params:   String maintenanceType
    Returns:  Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-243 just increase cc
    ********************************************************************************/
    private static Map<String, String> createMapToInsertLogRequest( String maintenanceType )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        insert testServicePoint;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        Map<String, String> sourceMap = new Map<String, String>( );
        sourceMap.put( 'OB_MaintenanceType__c', maintenanceType );
        sourceMap.put( 'OB_AccountId__c', testAccount.Id );
        sourceMap.put( 'OB_ServicePointId__c', testServicePoint.Id );
        sourceMap.put( 'OB_OrderId__c', testOrder.Id );
        sourceMap.put( 'OB_ABI__c', '' );
        sourceMap.put( 'OB_CAB__c', '' );
        sourceMap.put( 'OB_Status__c', OB_UtilityConstants.STATUS_ACTIVE );
        sourceMap.put( 'OB_HasAcquiring__c', 'false' );
        sourceMap.put( 'OB_HasPos__c', 'false' );
        sourceMap.put( 'OB_HasVas__c', 'false' );
        sourceMap.put( 'OB_ReducedOldData__c', JSON.serialize( new Map<String, Object>( ) ) );
        sourceMap.put( 'OB_ReducedNewData__c', JSON.serialize( new Map<String, Object>( ) ) );
        sourceMap.put( 'OB_isNotIntegrated__c', 'false' );
        sourceMap.put( 'OB_SIAToBeApproved__c', 'false' );

        return sourceMap;
    }

    /*******************************************************************************
    Purpose:  Method tests insertLogRequest - happy flow with Consistenza request type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-243 just increase cc
    ********************************************************************************/
    @isTest
    private static void insertLogRequestConsitenza( )
    {
        OB_LogRequest__c result = OB_Utility.insertLogRequest( createMapToInsertLogRequest( OB_UtilityConstants.CONSISTENZA ) );
        System.assert( result.Id != null );
    }

    /*******************************************************************************
    Purpose:  Method tests insertLogRequest - happy flow with Pricing request type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-243 just increase cc
    ********************************************************************************/
    @isTest
    private static void insertLogRequestPricing( )
    {
        OB_LogRequest__c result = OB_Utility.insertLogRequest( createMapToInsertLogRequest( OB_UtilityConstants.PRICING ) );
        System.assert( result.Id != null );
    }

    /*******************************************************************************
    Purpose:  Method tests insertLogRequest - happy flow with Cambio Coba request type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-243 just increase cc
    ********************************************************************************/
    @isTest
    private static void insertLogRequestCambioCoba( )
    {
        OB_LogRequest__c result = OB_Utility.insertLogRequest( createMapToInsertLogRequest( OB_UtilityConstants.CAMBIOCOBA ) );
        System.assert( result.Id != null );
    }

    /*******************************************************************************
    Purpose:  Method tests insertLogRequest - happy flow with Ecommerce request type

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-243 just increase cc
    ********************************************************************************/
    @isTest
    private static void insertLogRequestEcommerce( )
    {
        OB_LogRequest__c result = OB_Utility.insertLogRequest( createMapToInsertLogRequest( OB_UtilityConstants.CONSISTENZA_ECOMMERCE ) );
        System.assert( result.Id != null );
    }

    /*******************************************************************************
    Purpose:  Method tests checkLogRequest - Gianos returns more than 25 and log request has status - In attesa di Controlli Interni

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       28/08/2019      Created         NEXI-281
    1.1         Wojciech Szuba          08/10/2019      Refactored      NEXI-358, Fixed assertion
    ********************************************************************************/
    @isTest
    private static void checkLogRequestGianosAndApprovalProcess( )
    {
        OB_Util009_Gianos.mockResponse = false;

        Id testAccountId = OB_Util009_Gianos_Test.coreDataPreparationForGianos( );

        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.OB_Acquirer__c = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI;
        insert product;

        NE__Catalog__c catalog = OB_TestDataFactory.getCatalog( );
        insert catalog;

        NE__Catalog_Item__c catalogItem = OB_TestDataFactory.getCatalogItem( catalog.Id, product.Id );
        insert catalogItem;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.NE__CatalogItem__c = catalogItem.id;
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.AccountId = testAccountId;
        insert testAsset;

        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_AccountId__c = testAccountId;
        Contact executor = [ SELECT OB_PEP__c FROM Contact WHERE RecordTypeId = :OB_Util009_Gianos.RECORD_TYPE_ESECUTORE ].get( 0 );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {executor} );
        testLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        executor.OB_PEP__c = true;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {executor} );
        testLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        testLogRequest.OB_ChangeLegalRepresentative__c = true;
        testLogRequest.OB_StartApprovalProcess__c = true;
        insert testLogRequest;

        Test.setMock( HttpCalloutMock.class, new OB_Util009_Gianos_Mock( ) );
        Test.startTest( );
        OB_Utility.checkLogRequest( testLogRequest.Id );
        Test.stopTest( );

        String result =
                [
                        SELECT OB_Status__c
                        FROM OB_LogRequest__c
                        WHERE Id = :testLogRequest.Id
                ].get( 0 ).OB_Status__c;

        OB_Util009_Gianos.mockResponse = true;
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE, result );
    }

    /*******************************************************************************
    Purpose:  Method prepares Order Header for checkEntryCriteria tests
    Parameters: -
    Return: NE__Order_Header__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         30/08/2019       Created         NEXI-287
    ********************************************************************************/
    private static NE__Order_Header__c getOrderHeaderToApprovalProcess( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_ProcessInstanceAlredyExist__c = false;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        return testOrderHeader;
    }

    /*******************************************************************************
    Purpose:  Method tests checkStepsEntryCriteriaOrderHeader for meeting entry criteria of first step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         30/08/2019       Created         NEXI-287
    ********************************************************************************/
    @isTest
    private static void checkStepsEntryCriteriaOrderHeaderFirstStepEntryCriteriaTest( )
    {
        NE__Order_Header__c testOrderHeader = getOrderHeaderToApprovalProcess( );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_OPERATIVI;
        testOrderHeader.OB_AdditionalDocumentationRequired__c = true;
        testOrderHeader.OB_ApprovalStep__c = '3';
        System.assert( OB_Utility.checkStepsEntryCriteriaOrderHeader( testOrderHeader ) );
    }

    /*******************************************************************************
    Purpose:  Method tests checkStepsEntryCriteriaOrderHeader for meeting entry criteria of second step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         30/08/2019       Created         NEXI-287
    ********************************************************************************/
    @isTest
    private static void checkStepsEntryCriteriaOrderHeaderSecondStepEntryCriteriaTest( )
    {
        NE__Order_Header__c testOrderHeader = getOrderHeaderToApprovalProcess( );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_AML;
        testOrderHeader.OB_PEP__c = true;
        testOrderHeader.OB_ApprovalStep__c = '4';
        System.assert( OB_Utility.checkStepsEntryCriteriaOrderHeader( testOrderHeader ) );
    }

    /*******************************************************************************
    Purpose:  Method tests checkStepsEntryCriteriaOrderHeader for meeting entry criteria of third step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         30/08/2019       Created         NEXI-287
    ********************************************************************************/
    @isTest
    private static void checkStepsEntryCriteriaOrderHeaderThirdStepEntryCriteriaTest( )
    {
        NE__Order_Header__c testOrderHeader = getOrderHeaderToApprovalProcess( );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_SICUREZZA;
        testOrderHeader.OB_PO118_MOTO__c = true;
        System.assert( OB_Utility.checkStepsEntryCriteriaOrderHeader( testOrderHeader ) );
    }

    /*******************************************************************************
    Purpose:  Method tests checkStepsEntryCriteriaOrderHeader for meeting entry criteria of third step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         30/08/2019       Created         NEXI-287
    ********************************************************************************/
    @isTest
    private static void checkStepsEntryCriteriaOrderHeaderShouldStartNewApprovalTest( )
    {
        NE__Order_Header__c testOrderHeader = getOrderHeaderToApprovalProcess( );
        testOrderHeader.OB_AdditionalDocumentationRequired__c = false;
        testOrderHeader.OB_Gambling__c = false;
        testOrderHeader.OB_Fiduciarie__c = false;
        testOrderHeader.OB_Onlus__c = false;
        testOrderHeader.OB_Moneytransfer__c = false;
        testOrderHeader.OB_Crowdfunding__c = false;
        testOrderHeader.OB_PEP__c = false;
        testOrderHeader.OB_Gianos__c = '20';
        testOrderHeader.OB_PO118_MOTO__c = false;
        testOrderHeader.OB_Moto__c = true;
        System.assert( OB_Utility.checkStepsEntryCriteriaOrderHeader( testOrderHeader ) );
    }

    /*******************************************************************************
    Purpose:  Method tests checkStepsEntryCriteriaLogRequest for  meeting entry criteria

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         30/08/2019       Created         NEXI-287
    ********************************************************************************/
    @isTest
    private static void checkStepsEntryCriteriaLogRequestMeetingEntryCriteriaTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_StartApprovalProcess__c = true;
        testLogRequest.OB_ApprovalStep__c = '1';
        testLogRequest.OB_Gianos__c = '21';
        testLogRequest.OB_isBlackList__c = true;
        System.assert( OB_Utility.checkStepsEntryCriteriaLogRequest( testLogRequest ) );
    }

    /*******************************************************************************
    Purpose:  Method tests checkStepsEntryCriteriaOrderHeader for not meeting entry criteria

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         30/08/2019       Created         NEXI-287
    ********************************************************************************/
    @isTest
    private static void checkStepsEntryCriteriaLogRequestNotMeetingEntryCriteriaTest( )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_StartApprovalProcess__c = true;
        testLogRequest.OB_ApprovalStep__c = '2';
        System.assert( !OB_Utility.checkStepsEntryCriteriaLogRequest( testLogRequest ) );
    }

    /*******************************************************************************
   Purpose:  Method tests OB_UtilityisBooleanTrue it should return false when it gets null in the parameter

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Marta Stempien         30/08/2019       Created         NEXI-287
   ********************************************************************************/
    @isTest
    private static void isBooleanTrueTest( )
    {
        System.assert( !OB_Utility.isBooleanTrue( null ) );
    }

    /*******************************************************************************
    Purpose:  Method tests checkLogRequest - Gianos returns les than 25 and log request has status - In attesa

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki     04/09/2019        Created         NEXI-289
    1.1         Wojciech Szuba          08/10/2019      Refactored      NEXI-358
    ********************************************************************************/
    @isTest
    private static void checkLogRequestGianosAndNoApprovalProcess( )
    {
        OB_Util009_Gianos.mockResponse = false;

        Id testAccountId = OB_Util009_Gianos_Test.coreDataPreparationForGianos( );

        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.OB_Acquirer__c = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI;
        insert product;

        NE__Catalog__c catalog = OB_TestDataFactory.getCatalog( );
        insert catalog;

        NE__Catalog_Item__c catalogItem = OB_TestDataFactory.getCatalogItem( catalog.Id, product.Id );
        insert catalogItem;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.NE__CatalogItem__c = catalogItem.id;
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.AccountId = testAccountId;
        insert testAsset;

        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_AccountId__c = testAccountId;
        Contact executor = [ SELECT OB_PEP__c, RecordTypeId FROM Contact WHERE RecordTypeId = :OB_Util009_Gianos.RECORD_TYPE_ESECUTORE ].get( 0 );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {executor} );
        testLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        executor.OB_PEP__c = false;
        executor.OB_Contact_State__c = 'Active';

        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {executor} );
        testLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        testLogRequest.OB_ChangeLegalRepresentative__c = true;
        testLogRequest.OB_StartApprovalProcess__c = true;
        testLogRequest.OB_NewLegalRepresentative__c = true;
        insert testLogRequest;

        OB_Util009_Gianos_Mock.dataResponse.actualOwners.get( 0 ).score = '22';
        OB_Util009_Gianos_Mock.dataResponse.executor.score = '22';

        Test.setMock( HttpCalloutMock.class, new OB_Util009_Gianos_Mock( ) );
        Test.startTest( );
        OB_Utility.checkLogRequest( testLogRequest.Id );
        Test.stopTest( );

        String result =
                [
                        SELECT OB_Status__c
                        FROM OB_LogRequest__c
                        WHERE Id = :testLogRequest.Id
                ].get( 0 ).OB_Status__c;

        OB_Util009_Gianos.mockResponse = true;
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, result );//GIOVANNI SPINELLI CHANGE ASSERT 17/1072019
    }

    /*******************************************************************************
    Purpose:  Method tests retrieveSpecialCategoryConfigurations - Main Process: Maintenance and Gambling special category

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       06/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void retrieveSpecialCategoryConfigurationsMaintenanceSpecialCategory( )
    {
        String orderHeaderId = prepareDateForSubmitApprovalProcessControlliAcquring( OB_UtilityConstants.VISAMASTERCARD );
        NE__Order__c testOrder = [ SELECT Id, NE__Order_Header__c FROM NE__Order__c WHERE NE__Order_Header__c = :orderHeaderId ].get( 0 );
        testOrder.OB_AdditionalDocumentationRequired__c = false;
        testOrder.OB_CheckApprovalProcessAcquiring__c = false;
        testOrder.OB_MCC__c = OB_UtilityConstants.GAMBLING_VALUE_7996;
        update testOrder;

        Test.startTest( );
        Boolean result = OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );

        System.assert( [ SELECT OB_StartApprovalProcess__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId ].get( 0 ).OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieveSpecialCategoryConfigurations - Main Process: Maintenance and Fiduciare special category

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       06/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void retrieveSpecialCategoryConfigurationsMaintenanceConsistenza( )
    {
        String orderHeaderId = prepareDateForSubmitApprovalProcessControlliAcquring( OB_UtilityConstants.VISAMASTERCARD );
        NE__Order__c testOrder = [ SELECT Id, NE__AccountId__c, NE__Order_Header__c FROM NE__Order__c WHERE NE__Order_Header__c = :orderHeaderId ].get( 0 );
        testOrder.OB_AdditionalDocumentationRequired__c = false;
        testOrder.OB_CheckApprovalProcessAcquiring__c = false;
        update testOrder;
        NE__OrderItem__c testOrderItem = [ SELECT NE__ProdId__c FROM NE__OrderItem__c WHERE NE__OrderId__c = :testOrder.Id ].get( 0 );
        NE__Product__c testProduct = [ SELECT Id FROM NE__Product__c WHERE Id = :testOrderItem.NE__ProdId__c ].get( 0 );
        testProduct.OB_Codice_sfdc__c = OB_UtilityConstants.OBCodiceALBAUTO;
        update testProduct;
        Account testAccount = new Account( Id = testOrder.NE__AccountId__c );
        testAccount.OB_SAE_Code__c = OB_UtilityConstants.FIDUCIARIE_VALUE_273;
        update testAccount;

        Test.startTest( );
        Boolean result = OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );

        System.assert( [ SELECT OB_StartApprovalProcess__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId ].get( 0 ).OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieveSpecialCategoryConfigurations - Main Process: Setup and acquirer Nexi

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       06/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void retrieveSpecialCategoryConfigurationsSetupSpecialCategory( )
    {
        String orderHeaderId = prepareDateForSubmitApprovalProcessControlliAcquring( OB_UtilityConstants.VISAMASTERCARD );
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( Id = orderHeaderId );
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.SETUP;
        update testOrderHeader;
        NE__Order__c testOrder = [ SELECT Id, NE__Order_Header__c FROM NE__Order__c WHERE NE__Order_Header__c = :orderHeaderId ].get( 0 );
        testOrder.OB_AdditionalDocumentationRequired__c = false;
        testOrder.OB_CheckApprovalProcessAcquiring__c = false;
        testOrder.OB_MCC__c = OB_UtilityConstants.GAMBLING_VALUE_7996;
        update testOrder;
        NE__OrderItem__c testOrderItem = [ SELECT NE__ProdId__c FROM NE__OrderItem__c WHERE NE__OrderId__c = :testOrder.Id ].get( 0 );
        NE__Product__c testProduct = [ SELECT Id FROM NE__Product__c WHERE Id = :testOrderItem.NE__ProdId__c ].get( 0 );
        testProduct.OB_Acquirer__c = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI;
        update testProduct;

        Test.startTest( );
        Boolean result = OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );

        System.assert( [ SELECT OB_StartApprovalProcess__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId ].get( 0 ).OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieveSpecialCategoryConfigurations - Main Process: Maintenance and false scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       06/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void retrieveSpecialCategoryConfigurationsFalseScenario( )
    {
        String orderHeaderId = prepareDateForSubmitApprovalProcessControlliAcquring( OB_UtilityConstants.VISAMASTERCARD );

        Test.startTest( );
        Boolean result = OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
        Test.stopTest( );

        System.assert( ![ SELECT OB_StartApprovalProcess__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId ].get( 0 ).OB_StartApprovalProcess__c );
    }

    /*******************************************************************************
    Purpose:  Method tests isOperation

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void isOperation( )
    {
        User operation = OB_TestDataFactory.getUser( );
        operation.ProfileId = [ SELECT Id FROM Profile WHERE Name = :OB_UtilityConstants.OPERATION LIMIT 1 ].get( 0 ).Id;
        insert operation;

        System.runAs( operation )
        {
            Boolean result = OB_Utility.isOperation( );
            System.assert( result );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderToApprove - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void updateOrderToApproveSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        OB_Utility.updateOrderToApprove( testOrder.Id, OB_UtilityConstants.BIO );
        List<NE__Order__c> result = [ SELECT OB_FulfilmentStatus__c FROM NE__Order__c ];
        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE, result.get( 0 ).OB_FulfilmentStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderToApprove - exception scenario - invalid id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void updateOrderToApproveException( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );

        OB_Utility.updateOrderToApprove( testOrder.Id, null );
        List<NE__Order__c> result = [ SELECT OB_FulfilmentStatus__c FROM NE__Order__c ];
        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderToApprove - exception scenario - null param

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void updateOrderToApproveNull( )
    {
        OB_Utility.updateOrderToApprove( null, null );
        List<NE__Order__c> result = [ SELECT OB_FulfilmentStatus__c FROM NE__Order__c ];
        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderHeaderPending - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void updateOrderHeaderPendingSuccess( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        OB_Utility.updateOrderHeaderPending( testOrderHeader.Id );
        List<NE__Order_Header__c> result = [ SELECT OB_FulfilmentStatus__c FROM NE__Order_Header__c ];
        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_PENDING, result.get( 0 ).OB_FulfilmentStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderHeaderPending - exception scenario - invalid id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void updateOrderHeaderPendingException( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );

        OB_Utility.updateOrderHeaderPending( testOrderHeader.Id );
        List<NE__Order_Header__c> result = [ SELECT OB_FulfilmentStatus__c FROM NE__Order_Header__c ];
        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderHeaderPending - exception scenario - null param

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void updateOrderHeaderPendingNull( )
    {
        OB_Utility.updateOrderHeaderPending( null );
        List<NE__Order_Header__c> result = [ SELECT OB_FulfilmentStatus__c FROM NE__Order_Header__c ];
        System.assert( result.isEmpty( ) );
    }
    /*	
	* 	Author	:	Morittu		Andrea	
	*	Date	:	04-Sept-2019
	*	Task	:	Cover OB_Utility.retrieveObjectFieldsDetails method
	*/
	@isTest
	public static void  retrieveObjectFieldsDetails_Test() {
		Test.startTest();
		// COVERING METHOD BODY
			OB_Utility.retrieveObjectFieldsDetails('Account');
		// COVERING EXCEPTION SECTION
        	OB_Utility.retrieveObjectFieldsDetails('Not_Existing_Object');
		Test.stopTest();
	}
    
    /*	
	* 	Author	:	Morittu		Andrea	
	*	Date	:	16-Oct-2019
	*	Task	:	Cover OB_Utility.findObjectNameFromRecordIdPrefix method
	*/
    @isTest
    public static void findObjectNameFromRecordIdPrefix_Test() {
        Account a = OB_TestDataFactory.getAccount();
        insert a;
        List<String> idStringList = new List<String>();
        idStringList.add(a.Id);
        Test.startTest();
        	Map<String, String> toMatch = OB_Utility.findObjectNameFromRecordIdPrefix(idStringList);
        	System.assertEquals(toMatch.get('Account') , a.Id );
        Test.stopTest();
    }
    
    /*	
	* 	Author	:	Morittu		Andrea	
	*	Date	:	16-Oct-2019
	*	Task	:	Cover OB_Utility.findObjectNameFromRecordIdPrefix (catch) method
	*/
    @isTest
    public static void findObjectNameFromRecordIdPrefix_TestCatch() {
        Account a = OB_TestDataFactory.getAccount();
        insert a;
        
        Test.startTest();
        	Map<String, String> toMatch = OB_Utility.findObjectNameFromRecordIdPrefix(null);
        	System.assertNotEquals(toMatch.get('Account') , a.Id );
        Test.stopTest();
    }
	

 /*	
	* 	Author	:	Francesca Ribezzi
	*	Date	:	26-Sept-2019
	*	Task	:	Cover OB_Utility.updateLogRequestOrderIdOnPlcLog_Test method
	*/
	@isTest
	public static void  updateLogRequestOrderIdOnPlcLog_Test() {
        Plc_Log__c plcLog = new Plc_Log__c();
        insert plcLog;
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
        insert order;
		Test.startTest();
			OB_Utility.updateLogRequestOrderIdOnPlcLog(plcLog.Id, order.Id);
		Test.stopTest();
        List<Plc_Log__c> plcLogs = [select id,OB_OrderId__c from Plc_Log__c Limit 1];
        if(plcLogs.size()> 0){
            System.assertEquals(order.Id, plcLogs[0].OB_OrderId__c);
        }
        
	}
    
/*
	*	Author		:	Morittu Andrea
	*	Date		:	08-Nov-2019
	*	Task		:	EVO_BACKLOG_143
	*	Description	:	Testing retrieveObjectFieldsDetailsBySpecificFields() method
*/
    @isTest
    public static void retrieveObjectFieldsDetailsBySpecificFields_Test() {
        String objectType = 'Account';
        List<String> fieldToReturn = new List<String>{'Id', 'Name', 'CreatedDate', 'isDeleted', 'Phone', 'Email'};
            
        Test.startTest();
        	OB_Utility.retrieveObjectFieldsDetailsBySpecificFields(objectType, fieldToReturn);
        	objectType = 'UNEXISTING_OBJECT';
        	OB_Utility.retrieveObjectFieldsDetailsBySpecificFields(objectType, fieldToReturn);
        Test.stopTest();
	}
    
/*
	*	Author		:	Morittu Andrea
	*	Date		:	08-Nov-2019
	*	Task		:	EVO_BACKLOG_143
	*	Description	:	Testing retrieveConventionCodes() method
*/
    @isTest
    public static void retrieveConventionCodes_Test() {
        String bankABI = '03138';
        Boolean isAdmin = true;
        Test.startTest();
        	OB_Utility.retrieveConventionCodes(bankABI, isAdmin);
            isAdmin = false;
        	OB_Utility.retrieveConventionCodes(bankABI, isAdmin);
        Test.stopTest();
    }

    /*
	*	Author		:	Francesca Ribezzi
	*	Date		:	19-11-2019
	*	Task		:	PROD-69
	*	Description	:	Testing retrieveConventionCodes() method
*/
    @isTest
    public static void updateMerchantTakeOverOnAsset_Test() {
        Asset a = new Asset();
        a.Name = 'test';
        a.OB_MerchantTakeover__c = true;
        insert a;

        NE__Order__c o = new NE__Order__c();
        o.OB_Takeover_OfferAsset__c = a.Id;
        insert o;
  
        String status = 'Active';
        Test.startTest(); 
        	Asset assetToReturn = OB_Utility.updateMerchantTakeOverOnAsset(o.OB_Takeover_OfferAsset__c, status);   
            System.assertEquals(false,assetToReturn.OB_MerchantTakeover__c); //francesca.ribezzi 20/11/19 - adding assertEquals  
        Test.stopTest();
    }


}